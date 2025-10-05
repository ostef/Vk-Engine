// Technique used in bloom, though for bloom we upsample differently

KawaseBlur :: struct {
    downsample_texture : GfxTexture;
    downsample_levels : []GfxTexture;
    upsample_texture : GfxTexture;
    upsample_levels : []GfxTexture;
}

GetFinalTexture :: inline (using blur : *KawaseBlur) -> *GfxTexture {
    return *upsample_levels[0];
}

CreateKawaseBlurTextures :: (using blur : *KawaseBlur, num_iterations : int, base_texture_desc : GfxTextureDesc, resolution_factor : float) {
    DestroyKawaseBlur(blur);

    desc : GfxTextureDesc;
    desc.type = .Texture2D;
    desc.pixel_format = base_texture_desc.pixel_format;
    desc.width = Max(cast(u32, base_texture_desc.width * resolution_factor) / 2, 1);
    desc.height = Max(cast(u32, base_texture_desc.height * resolution_factor) / 2, 1);
    desc.num_mipmap_levels = xx num_iterations;
    desc.usage = .ColorAttachment | .Sampled | .Storage;

    downsample_texture = CreateGfxTexture("Kawase Downsample", desc);

    desc.width = base_texture_desc.width;
    desc.height = base_texture_desc.height;
    upsample_texture = CreateGfxTexture("Kawase Upsample", desc);

    downsample_levels = AllocArray(GfxTexture, num_iterations);
    upsample_levels = AllocArray(GfxTexture, num_iterations);

    for i : 0..num_iterations - 1 {
        view_desc : GfxTextureViewDesc;
        view_desc.type = .Texture2D;
        view_desc.pixel_format = desc.pixel_format;
        view_desc.first_mipmap_level = xx i;

        downsample_levels[i] = CreateGfxTextureView(TPrint("Kawase Downsample %", i), view_desc, *downsample_texture);
        upsample_levels[i] = CreateGfxTextureView(TPrint("Kawase Upsample %", i), view_desc, *upsample_texture);
    }
}

DestroyKawaseBlur :: (using blur : *KawaseBlur) {
    for * downsample_levels {
        QueueDestroyGfxTextureView(it);
    }
    for * upsample_levels {
        QueueDestroyGfxTextureView(it);
    }

    Free(downsample_levels.data);
    Free(upsample_levels.data);

    if !IsNull(*downsample_texture) {
        QueueDestroyGfxTexture(*downsample_texture);
    }
    if !IsNull(*upsample_texture) {
        QueueDestroyGfxTexture(*upsample_texture);
    }

    blur.* = .{};
}

using _ :: struct {
    Kawase_Bur_Compute_Work_Group_Size :: 16;
} @ShaderType

KawaseBlurComputeBindingSet :: struct {
    src_texture : GfxBindingCombinedTextureSampler; @Binding(0) @ComputeStage
    dst_image : GfxBindingStorageImage; @Binding(1) @ComputeStage
} @BindingSet

g_kawase_blur_downsample_compute_pipeline : GfxComputePipeline;
g_kawase_blur_upsample_compute_pipeline : GfxComputePipeline;

CreateKawaseBlurDownsampleComputePipeline :: () {
    desc : GfxComputePipelineDesc;
    desc.shader = GetComputeShader("kawase_blur_downsample");
    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.KawaseBlurComputeBindingSet,
    ];

    ok := CreateGfxComputePipeline(*g_kawase_blur_downsample_compute_pipeline, "Kawase Blur Downsample", desc);
    Assert(ok, "Could not create kawase blur downsample compute pipeline");
}

CreateKawaseBlurUpsampleComputePipeline :: () {
    desc : GfxComputePipelineDesc;
    desc.shader = GetComputeShader("kawase_blur_upsample");
    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.KawaseBlurComputeBindingSet,
    ];

    ok := CreateGfxComputePipeline(*g_kawase_blur_upsample_compute_pipeline, "Kawase Blur Upsample", desc);
    Assert(ok, "Could not create kawase blur upsample compute pipeline");
}

ComputeKawaseBlur :: (cmd_buffer : *GfxCommandBuffer, blur : *KawaseBlur, base_texture : *GfxTexture) {
    BeginGfxDebugMarker(cmd_buffer, "Kawase Blur");
    defer EndGfxDebugMarker(cmd_buffer);

    ProfileGPUZone(cmd_buffer, *g_gpu_profiler, "Kawase Blur");

    if IsNull(*g_kawase_blur_downsample_compute_pipeline) {
        CreateKawaseBlurDownsampleComputePipeline();
    }
    if IsNull(*g_kawase_blur_upsample_compute_pipeline) {
        CreateKawaseBlurUpsampleComputePipeline();
    }

    pass := BeginGfxComputePass(cmd_buffer, "Kawase Blur Downsample");
    {
        BindComputePipeline(*pass, *g_kawase_blur_downsample_compute_pipeline);

        for i : 0..blur.downsample_levels.count - 1 {
            bindings := KawaseBlurComputeBindingSet.{
                dst_image=.{*blur.downsample_levels[i]},
            };

            if i == 0 {
                bindings.src_texture = .{texture=base_texture, sampler=*g_linear_clamp_sampler};
            } else {
                bindings.src_texture = .{texture=*blur.downsample_levels[i - 1], sampler=*g_linear_clamp_sampler};
            }

            AddTextureBarrier(cmd_buffer, .Undefined, .General, *blur.downsample_levels[i]);

            binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), bindings);
            BindComputeBindingSet(*pass, 1, *binding_set);

            num_groups_x, num_groups_y := GetNumComputeWorkGroupsForTexture(blur.downsample_texture.desc, i, Kawase_Bur_Compute_Work_Group_Size);

            Dispatch(*pass, num_groups_x, num_groups_y, num_groups_z=1);

            AddTextureBarrier(cmd_buffer, .General, .ShaderReadOnly, *blur.downsample_levels[i]);
        }
    }
    EndGfxComputePass(*pass);

    pass = BeginGfxComputePass(cmd_buffer, "Kawase Blur Upsample");
    {
        BindComputePipeline(*pass, *g_kawase_blur_upsample_compute_pipeline);

        for #v2 < i : 0..blur.upsample_levels.count - 1 {
            bindings := KawaseBlurComputeBindingSet.{
                dst_image=.{*blur.upsample_levels[i]},
            };

            if i == blur.upsample_levels.count - 1 {
                bindings.src_texture = .{texture=*blur.downsample_levels[blur.downsample_levels.count - 1], sampler=*g_linear_clamp_sampler};
            } else {
                bindings.src_texture = .{texture=*blur.upsample_levels[i + 1], sampler=*g_linear_clamp_sampler};
            }

            AddTextureBarrier(cmd_buffer, .Undefined, .General, *blur.upsample_levels[i]);

            binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), bindings);
            BindComputeBindingSet(*pass, 1, *binding_set);

            num_groups_x, num_groups_y := GetNumComputeWorkGroupsForTexture(blur.upsample_texture.desc, i, Kawase_Bur_Compute_Work_Group_Size);

            Dispatch(*pass, num_groups_x, num_groups_y, num_groups_z=1);

            AddTextureBarrier(cmd_buffer, .General, .ShaderReadOnly, *blur.upsample_levels[i]);
        }
    }
    EndGfxComputePass(*pass);
}
