LoadTexture2DFromMemory :: (texture : *Texture2D, data : []u8, name : string) -> bool {
    #import "stb_image";

    is_hdr := stbi_is_hdr_from_memory(data.data, xx data.count);
    // @Hack: we need to choose the color space between SRGB and linear for LDR images because we want
    // to treat HDR and LDR images the same way in the shaders. HDR images are in linear space, and we have
    // no performant way of gamma correcting, hence why we choose to use SRGB pixel formats for LDR images.
    // The problem is not all images are actually in sRGB space, normal maps et metallic/roughness/AO are in
    // linear space, and we cannot use SRGB for them or everything breaks. Hence, we enforce a naming
    // convention for images that are SRGB (it's better for the naming convention to enforce specifying SRGB
    // instead of specifying linear, because it's easier to see when a color texture is not in the correct space
    // than to know why your normals or lighting look weird). A better solution would probably be to use another
    // file format, or add a metadata file.
    basename := path_basename(name);
    is_srgb := StringEndsWith(basename, "_BaseColor") || StringEndsWith(basename, "_Emissive") || StringEndsWith(basename, "_Color");

    w, h : s32;
    image_data : *void;
    defer stbi_image_free(image_data);

    if is_hdr {
        image_data = stbi_loadf_from_memory(data.data, xx data.count, *w, *h, null, 4);
    } else {
        image_data = stbi_load_from_memory(data.data, xx data.count, *w, *h, null, 4);
    }

    if !image_data {
        return false;
    }

    desc : GfxTextureDesc;
    desc.type = .Texture2D;
    desc.pixel_format = ifx is_hdr then .RGBA32Float else ifx is_srgb then .RGBA8SRGB else .RGBA8UNorm;
    desc.usage = .Sampled | .TransferDst | .TransferSrc;
    desc.width = xx w;
    desc.height = xx h;
    desc.num_mipmap_levels = GetNumMipmapLevelsForTextureSize(desc.width, desc.height);

    texture.texture = CreateGfxTexture(name, desc);
    if IsNull(*texture.texture) {
        return false;
    }

    QueueTextureUpload(image_data, texture);

    return true;
}

DestroyTexture2D :: (texture : *Texture2D) {
    CancelTextureUpload(texture);
    QueueDestroyGfxTexture(*texture.texture);
}

#scope_file

// Contains buffers for each frame in flight that were copied
// All buffers from frame N are destroyed at frame N + Gfx_Num_Frames_In_Flight
g_upload_buffers_to_destroy : [Gfx_Num_Frames_In_Flight][..]GfxBuffer;

// The two arrays are separate so we can directly send the whole textures array for transition barriers
g_texture_uploads : [..]*Texture2D;
g_texture_upload_buffers : [..]GfxBuffer;
g_texture_upload_mutex : Mutex;

#scope_export

InitTextureUpload :: () {
    init(*g_texture_upload_mutex, "Queue Texture2D Upload");
}

CleanupTextureUpload :: () {
    ArrayFree(*g_texture_uploads);

    for * buffers : g_upload_buffers_to_destroy {
        for * buffers.* {
            DestroyGfxBuffer(it);
        }

        ArrayFree(buffers);
    }

    for * g_texture_upload_buffers {
        DestroyGfxBuffer(it);
    }

    ArrayFree(*g_texture_upload_buffers);

    destroy(*g_texture_upload_mutex);
}

QueueTextureUpload :: (data : *void, texture : *Texture2D) {
    lock(*g_texture_upload_mutex);
    defer unlock(*g_texture_upload_mutex);

    buffer_desc : GfxBufferDesc;
    buffer_desc.size = GetTextureMemoryRequirementsForLevel0(texture.texture.desc);
    buffer_desc.usage = .TransferSrc;
    buffer_desc.memory_usage = .Upload;

    buffer := CreateGfxBuffer("Texture2D Upload", buffer_desc);
    Assert(!IsNull(*buffer), "Could not create upload buffer");

    vmaCopyMemoryToAllocation(g_gfx_context.allocator, data, buffer.allocation, 0, buffer_desc.size);

    ArrayPush(*g_texture_upload_buffers, buffer);
    ArrayPush(*g_texture_uploads, texture);
}

CancelTextureUpload :: (texture : *Texture2D) {
    lock(*g_texture_upload_mutex);
    defer unlock(*g_texture_upload_mutex);

    index := ArrayFindFirst(g_texture_uploads, texture);
    if index >= 0 {
        DestroyGfxBuffer(*g_texture_upload_buffers[index]);

        ArrayRemove(*g_texture_uploads, index);
        ArrayRemove(*g_texture_upload_buffers, index);
    }
}

UploadTexturesAndGenerateMipmaps :: (pass : *GfxCopyPass) {
    AddTextureBarriers(pass.cmd_buffer, .Undefined, .TransferDst, .{data=xx g_texture_uploads.data, count=g_texture_uploads.count});

    for i : 0..g_texture_uploads.count - 1 {
        buffer := *g_texture_upload_buffers[i];
        texture := g_texture_uploads[i];
        CopyBufferToTexture(pass, buffer, *texture.texture);
    }

    for g_texture_uploads {
        GenerateMipmaps(pass, *it.texture, .TransferDst, .ShaderReadOnly);
    }

    ArrayClear(*g_texture_uploads);
    Swap(*g_texture_upload_buffers, *g_upload_buffers_to_destroy[g_gfx_context.frame_in_flight]);
}

DestroyUsedTextureUploadBuffers :: () {
    // Destroy upload buffers that were created at the last same frame in flight, we're sure that
    // upload was done because the fence was waited upon
    for * g_upload_buffers_to_destroy[g_gfx_context.frame_in_flight] {
        DestroyGfxBuffer(it);
    }

    ArrayClear(*g_upload_buffers_to_destroy[g_gfx_context.frame_in_flight]);
}

TextureUploadPass :: (cmd_buffer : *GfxCommandBuffer) {
    DestroyUsedTextureUploadBuffers();

    if g_texture_uploads.count <= 0 {
        return;
    }

    pass := BeginGfxCopyPass(cmd_buffer, "Upload Textures");
    {
        UploadTexturesAndGenerateMipmaps(*pass);
    }
    EndGfxCopyPass(*pass);
}
