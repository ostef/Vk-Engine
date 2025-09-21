#load "gfx_vulkan.jai";

Gfx_Max_Color_Attachments :: 8;
Gfx_Num_Frames_In_Flight :: 2;

GfxFrameStatistics :: struct {
    num_draw_calls : int;
    num_dispatch_calls : int;
    num_render_passes : int;
    num_compute_passes : int;
    num_graphics_binding_set_binds : int;
    num_compute_binding_set_binds : int;
    num_graphics_pipeline_binds : int;
    num_compute_pipeline_binds : int;
    num_texture_barriers : int;
    num_memory_barriers : int;
    num_execution_barriers : int;
}

GetGfxFrameStatistics :: () -> GfxFrameStatistics {
    return g_gfx_context.last_frame_statistics;
} @NoProfile

// Tool to defer destroying objects after the last frame they were used is finished processing on the GPU
GfxGarbageCollector :: struct($T : Type) {
    garbage : [..]T;
    destroy_func : (*T);
}

AddGarbage :: (collector : *GfxGarbageCollector, garbage : collector.T) {
    ArrayPush(*collector.garbage, garbage);
} @NoProfile

DestroyGfxGarbageCollector :: (collector : *GfxGarbageCollector) {
    CollectGarbage(collector);
    ArrayFree(*collector.garbage);
}

CollectGarbage :: (collector : *GfxGarbageCollector) {
    Assert(collector.destroy_func != null, "Collector destroy function not set");

    for * collector.garbage {
        collector.destroy_func(it);
    }

    ArrayClear(*collector.garbage);
}

GfxLimits :: struct {
    max_texture_1d_dimension : u32;
    max_texture_2d_dimension : u32;
    max_texture_3d_dimension : u32;
    max_texture_cube_dimension : u32;
    max_texture_array_layers : u32;
    max_memory_allocation_count : u32;
    max_sampler_allocation_count : u32;
    max_uniform_buffer_size : u32;
    max_storage_buffer_size : u32;
    uniform_buffer_offset_alignment : u32;
    storage_buffer_offset_alignment : u32;
    timestamp_tick_period : u32;
}

GfxShaderStageFlags :: enum_flags u8 {
    Vertex;
    Fragment;
    Compute;
}

GfxBindingType :: enum u8 {
    UniformBuffer;
    StorageBuffer;
    Texture;
    Sampler;
    CombinedTextureSampler;
    StorageImage;
}

// @Todo: do not compare type_info results like this, it won't work when comparing
// across library boundaries
GetGfxBindingType :: (type : *Type_Info) -> GfxBindingType {
    if type == {
    case type_info(GfxBindingUniformBuffer);
        return .UniformBuffer;
    case type_info(GfxBindingStorageBuffer);
        return .StorageBuffer;
    case type_info(GfxBindingTexture);
        return .Texture;
    case type_info(GfxBindingSampler);
        return .Sampler;
    case type_info(GfxBindingCombinedTextureSampler);
        return .CombinedTextureSampler;
    case type_info(GfxBindingStorageImage);
        return .StorageImage;
    }

    Panic("Invalid shader param type %", get_type(type));
    return xx 0;
} @NoProfile

GfxBindingFlags :: enum_flags u8 {
    AllowNull;
}

GfxBindingDesc :: struct {
    binding : u32;
    type : GfxBindingType;
    stage_flags : GfxShaderStageFlags;
    num_array_layers : u32 = 1;
    flags : GfxBindingFlags;
}

GfxBindingSetLayoutDesc :: struct {
    bindings : []GfxBindingDesc;
}

GfxBindingPoolDesc :: struct {
    max_binding_sets : u32;
    max_uniform_buffers : u32;
    max_storage_buffers : u32;
    max_textures : u32;
    max_samplers : u32;
    max_combined_texture_samplers : u32;
    max_storage_images : u32;
}

GfxBindingPoolAllocResult :: enum {
    Success;
    OutOfPoolMemory;
    OutOfDeviceMemory;
    OutOfHostMemory;
    FragmentedPool;
    UnknownError;
}

// To help reduce error prone boilerplate code for layout creation and binding set allocation, we provide
// these types below. You can define a struct containing these members, and that struct can be used to both
// create a binding set layout as well as allocate a binding set.
// This is a simple solution that simplifies layout and binding set creation without using reflection (although
// reflection would probably simplify even more that process, and in particular would not require us to know
// the binding point indices on the CPU side).
// I am sure most engines use reflection to make this automatic. I don't believe this is a good design choice because
// the programmer has to setup the descriptor sets in the source code anyway, so it makes more sense to define the layouts
// in the source code too (though to be fair without code generation and type information this is maybe the only solution).
// Furthermore, your shaders cannot work if the bindings are not setup properly CPU side, so your ability to add new bindings
// in the shader and hot-reload is limited or even non-existent.

/* Example (not 1:1 with how you actually use the API):

MyParamSet :: struct {
    a_buffer : GfxBindingUniformBuffer; @Binding(0) @VertexStage @FragmentStage
    a_texture : GfxBindingTexture; @Binding(1) @AllowNull @FragmentStage
    many_textures : [10]GfxBindingTexture; @Binding(2) @FragmentStage
    a_sampler : GfxBindingSampler; @Binding(3) @FragmentStage
}

set_layout := CreateGfxBindingSetLayout(MyParamSet);

bindings : MyParamSet;
bindings.a_buffer = .{buffer=my_buffer, offset=0};
bindings.a_texture = null;
for bindings.many_textures {
    bindings.many_textures = GetTexture(it_index);
}
bindings.a_sample = my_sampler;

binding_set := CreateGfxBindingSet(*set_layout, bindings);

...

BindGraphicsBindingSet(*pass, 0, *binding_set);

*/

GfxBindingUniformBuffer :: struct {
    buffer : *GfxBuffer;
    offset : u32;
    size : u32;
}

GfxBindingStorageBuffer :: struct {
    buffer : *GfxBuffer;
    offset : u32;
    size : u32;
}

GfxBindingTexture :: struct {
    texture : *GfxTexture;
}

GfxBindingSampler :: struct {
    sampler : *GfxSampler;
}

GfxBindingCombinedTextureSampler :: struct {
    texture : *GfxTexture;
    sampler : *GfxSampler;
}

GfxBindingStorageImage :: struct {
    texture : *GfxTexture;
}

CreateGfxBindingSetLayout :: ($T : Type) -> GfxBindingSetLayout {
    desc : GfxBindingSetLayoutDesc;

    #insert -> string {
        info := type_info(T);
        struct_location := compiler_get_struct_location(get_current_workspace(), info);

        builder : StringBuilder;
        Appendln(*builder, "Name :: \"%\";", T);
        Appendln(*builder, "desc.bindings = GfxBindingDesc.[");

        for info.members {
            binding : u32;
            num_array_layers : u32 = 1;
            type : GfxBindingType;
            stage_flags : GfxShaderStageFlags;
            flags : GfxBindingFlags;

            if it.type.type == .ARRAY {
                num_array_layers = xx cast(*Type_Info_Array, it.type).array_count;
                type = GetGfxBindingType(cast(*Type_Info_Array, it.type).element_type);
            } else {
                type = GetGfxBindingType(it.type);
            }

            found_binding := false;
            for note : it.notes {
                if note == "AllowNull" {
                    flags |= .AllowNull;
                } if note == "VertexStage" {
                    stage_flags |= .Vertex;
                } else if note == "FragmentStage" {
                    stage_flags |= .Fragment;
                } else if note == "ComputeStage" {
                    stage_flags |= .Compute;
                } else if StringStartsWith(note, "Binding(") {
                    found_binding = true;
                    _note := StringAdvance(note, "Binding(".count);
                    value, ok, remainder := Basic.string_to_int(_note);
                    if !ok || remainder != ")" {
                        compiler_report(TPrint("Invalid @Binding note on member %", it.name), loc=struct_location);
                    }

                    binding = xx value;
                }
            }

            if !found_binding {
                compiler_report(TPrint("Missing @Binding note on member %", it.name), loc=struct_location);
            }

            if stage_flags == 0 {
                compiler_report(TPrint("Missing @VertexStage, @FragmentStage or @ComputeStage note on member %", it.name), loc=struct_location);
            }

            Appendln(*builder, "    .{binding=%, num_array_layers=%, type=.%, stage_flags=%, flags=%},", binding, num_array_layers, type, cast(u8, stage_flags), cast(u8, flags));
        }

        Appendln(*builder, "];");

        return StringBuilderBuild(*builder);
    }

    return CreateGfxBindingSetLayout(Name, desc);
}

GfxPixelFormat :: enum u8 {
    Invalid;

    R8UNorm;
    R8SNorm;
    R8UInt;
    R8SInt;
    RGBA8SRGB;
    RGBA8UNorm;
    RGBA8SNorm;
    RGBA8UInt;
    RGBA8SInt;
    BGRA8UNorm;
    BGRA8SRGB;
    R32UInt;
    R32SInt;
    RGBA16Float;
    RGBA32UInt;
    RGBA32SInt;
    RGBA32Float;

    Depth32FloatStencil8;
    Depth32Float;
    Stencil8;
}

GetPixelSize :: inline (pixel_format : GfxPixelFormat) -> u32 {
    if #complete pixel_format == {
    case .Invalid; return 0;
    case .R8UNorm; return 1;
    case .R8SNorm; return 1;
    case .R8UInt; return 1;
    case .R8SInt; return 1;
    case .RGBA8SRGB; return 4;
    case .RGBA8UNorm; return 4;
    case .RGBA8SNorm; return 4;
    case .RGBA8UInt; return 4;
    case .RGBA8SInt; return 4;
    case .BGRA8UNorm; return 4;
    case .BGRA8SRGB; return 4;
    case .R32UInt; return 4;
    case .R32SInt; return 4;
    case .RGBA16Float; return 8;
    case .RGBA32UInt; return 16;
    case .RGBA32SInt; return 16;
    case .RGBA32Float; return 16;
    case .Depth32FloatStencil8; return 5;
    case .Depth32Float; return 4;
    case .Stencil8; return 1;
    }

    return 0;
} @NoProfile

GfxVertexFormat :: enum {
    Invalid;

    Float;
    Float2;
    Float3;
    Float4;

    Char2;
    Char3;
    Char4;
    UChar2;
    UChar3;
    UChar4;

    Short2;
    Short3;
    Short4;
    UShort2;
    UShort3;
    UShort4;

    Int;
    Int2;
    Int3;
    Int4;
    UInt;
    UInt2;
    UInt3;
    UInt4;
}

MakeGfxVertexFormat :: inline (type : Type) -> GfxVertexFormat {
    if type == {
    case; return .Invalid;
    case float; return .Float;
    case Vec2f; return .Float2;
    case Vec3f; return .Float3;
    case Vec4f; return .Float4;
    case Vec2b; return .Char2;
    case Vec3b; return .Char3;
    case Vec4b; return .Char4;
    case Vec2ub; return .UChar2;
    case Vec3ub; return .UChar3;
    case Vec4ub; return .UChar4;
    case Vec2s; return .Short2;
    case Vec3s; return .Short3;
    case Vec4s; return .Short4;
    case Vec2us; return .UShort2;
    case Vec3us; return .UShort3;
    case Vec4us; return .UShort4;
    case s32; return .Int;
    case Vec2i; return .Int2;
    case Vec3i; return .Int3;
    case Vec4i; return .Int4;
    case u32; return .UInt;
    case Vec2u; return .UInt2;
    case Vec3u; return .UInt3;
    case Vec4u; return .UInt4;
    }
} @NoProfile

GfxVertexInputAttribute :: struct {
    location : u32;
    binding : u32;
    format : GfxVertexFormat;
    offset : u32;
    normalized : bool;
}

GfxVertexInputBufferBinding :: struct {
    binding : u32;
    stride : u32;
}

GfxVertexInputDesc :: struct {
    attributes : []GfxVertexInputAttribute;
    buffer_bindings : []GfxVertexInputBufferBinding;
}

MakeVertexInputDesc :: inline ($T : Type, buffer_binding : u32) -> GfxVertexInputDesc {
    return MakeVertexInputDesc(T, .[buffer_binding]);
} @NoProfile

MakeVertexInputDesc :: ($T : Type, buffer_bindings : []u32) -> GfxVertexInputDesc {
    desc : GfxVertexInputDesc;

    #insert -> string {
        builder : StringBuilder;

        info := type_info(T);
        Appendln(*builder, "attributes := GfxVertexInputAttribute.[");

        highest_offset := 0;
        for info.members {
            if it.flags & .CONSTANT || it.offset_in_bytes < highest_offset {
                continue;
            }

            highest_offset = it.offset_in_bytes + it.type.runtime_size;

            normalized := GetNote(it.notes, "Normalized");
            has_attrib_note, attrib_index := GetNote(it.notes, "VertexAttrib", int);
            has_buffer_note, buffer_index := GetNote(it.notes, "VertexBuffer", int);

            location := cast(u32, ifx has_attrib_note then attrib_index else it_index);
            format := MakeGfxVertexFormat(get_type(it.type));
            Assert(format != .Invalid, "Invalid vertex attribute type %", get_type(it.type));

            Appendln(*builder, "    .{location=%, binding=buffer_bindings[%], format=.%, offset=%, normalized=%},",
                location, buffer_index, format, it.offset_in_bytes, normalized);
        }

        Appendln(*builder, "];");

        return StringBuilderBuild(*builder);
    }

    desc.attributes = ArrayClone(attributes ,, Temp);
    desc.buffer_bindings = AllocArray(GfxVertexInputBufferBinding, buffer_bindings.count ,, Temp);
    for * desc.buffer_bindings {
        it.binding = buffer_bindings[it_index];
        it.stride = size_of(T);
    }

    return desc;
}

GfxPipelineLayoutDesc :: struct {
    binding_sets : []GfxBindingSetLayout;
}

GfxWindingOrder :: enum u8 {
    Clockwise;
    CounterClockwise;
}

GfxPrimitiveTopology :: enum u8 {
    PointList;
    LineList;
    TriangleList;
}

GfxFillMode :: enum u8 {
    Fill;
    Lines;
}

GfxPolygonFace :: enum u8 {
    None;
    Front;
    Back;
}

GfxRasterizerStateDesc :: struct {
    fill_mode : GfxFillMode = .Fill;
    cull_face : GfxPolygonFace = .Back;
    winding_order : GfxWindingOrder = .CounterClockwise;
    num_samples : u32 = 1;
}

GfxCompareOp :: enum u8 {
    None;
    Never;
    Always;
    Less;
    LessEqual;
    Greater;
    GreaterEqual;
    Equal;
    NotEqual;
}

GfxDepthStateDesc :: struct {
    test_enabled := false;
    write_enabled := false;
    compare_op : GfxCompareOp = .LessEqual;
}

GfxStencilOp :: enum u8 {
    Keep;
    Zero;
    Replace;
    IncrementClamp;
    IncrementWrap;
    DecrementClamp;
    DecrementWrap;
    Invert;
}

GfxStencilFaceStateDesc :: struct {
    failed_op : GfxStencilOp = .Keep;
    depth_failed_op : GfxStencilOp = .Keep;
    passed_op : GfxStencilOp = .Keep;
    write_mask : u32 = 0xffffffff;
    read_mask : u32 = 0xffffffff;
    compare_op : GfxCompareOp = .Always;
}

GfxStencilStateDesc :: struct {
    test_enabled := false;
    front_face : GfxStencilFaceStateDesc;
    back_face : GfxStencilFaceStateDesc;
}

GfxBlendFactor :: enum u8 {
    One;
    Zero;
    SrcColor;
    OneMinusSrcColor;
    DstColor;
    OneMinusDstColor;
    SrcAlpha;
    OneMinusSrcAlpha;
    DstAlpha;
    OneMinusDstAlpha;
    ConstantColor;
    OneMinusConstantColor;
    ConstantAlpha;
    OneMinusConstantAlpha;
    SrcAlphaSaturate;
    Src1Color;
    OneMinusSrc1Color;
    Src1Alpha;
    OneMinusSrc1Alpha;
}

GfxBlendOp :: enum u8 {
    Add;
    Subtract;
    ReverseSubtract;
    Min;
    Max;
}

GfxBlendStateDesc :: struct {
    enabled := false;
    src_color_factor : GfxBlendFactor = .SrcAlpha;
    dst_color_factor : GfxBlendFactor = .OneMinusSrcAlpha;
    src_alpha_factor : GfxBlendFactor = .SrcAlpha;
    dst_alpha_factor : GfxBlendFactor = .OneMinusSrcAlpha;
    color_op : GfxBlendOp = .Add;
    alpha_op : GfxBlendOp = .Add;
}

GfxGraphicsPipelineDesc :: struct {
    vertex_shader : *GfxShader;
    fragment_shader : *GfxShader;

    layout : GfxPipelineLayoutDesc;
    vertex_input : GfxVertexInputDesc;
    primitive_topology : GfxPrimitiveTopology = .TriangleList;
    rasterizer_state : GfxRasterizerStateDesc;
    depth_state : GfxDepthStateDesc;
    stencil_state : GfxStencilStateDesc;

    num_color_attachments : u32;

    blend_states : [Gfx_Max_Color_Attachments]GfxBlendStateDesc;
    color_formats : [Gfx_Max_Color_Attachments]GfxPixelFormat;
    depth_format : GfxPixelFormat;
    stencil_format : GfxPixelFormat;
}

AddColorAttachment :: (desc : *GfxGraphicsPipelineDesc, format : GfxPixelFormat) {
    desc.color_formats[desc.num_color_attachments] = format;
    desc.num_color_attachments += 1;
} @NoProfile

GfxComputePipelineDesc :: struct {
    shader : *GfxShader;
    layout : GfxPipelineLayoutDesc;
}

GfxBufferUsageFlags :: enum_flags {
    TransferSrc;
    TransferDst;
    UniformBuffer;
    StorageBuffer;
    IndexBuffer;
    VertexBuffer;
}

GfxBufferMemoryUsage :: enum {
    GPUOnly;
    Upload;
    Readback;
}

GfxBufferDesc :: struct {
    size : u64;
    usage : GfxBufferUsageFlags;
    memory_usage : GfxBufferMemoryUsage;
}

GfxTextureType :: enum u8 {
    Invalid;
    Texture1D;
    Texture2D;
    Texture2DMS;
    Texture3D;
    TextureCube;
    Texture1DArray;
    Texture2DArray;
    Texture2DMSArray;
    TextureCubeArray;
}

GfxTextureUsage :: enum_flags u8 {
    TransferSrc;
    TransferDst;
    Sampled;
    Storage;
    ColorAttachment;
    DepthStencilAttachment;
}

GfxTextureDesc :: struct {
    type : GfxTextureType;
    pixel_format : GfxPixelFormat;
    usage : GfxTextureUsage;
    width : u32 = 1;
    height : u32 = 1;
    depth : u32 = 1;
    num_array_layers : u32 = 1;
    num_mipmap_levels : u32 = 1;
    num_samples : u32 = 1;
}

GetNumMipmapLevelsForTextureSize :: (width : u32, height : u32) -> u32 {
    return cast(u32, Floor(Log2(xx Max(width, height)))) + 1;
} @NoProfile

GetTextureMemoryRequirementsForLevel0 :: (desc : GfxTextureAndViewDesc) -> u64 {
    size := desc.width * desc.height * desc.depth * desc.num_array_layers * GetPixelSize(desc.pixel_format);
    if desc.type == .TextureCube || desc.type == .TextureCubeArray {
        size *= 6;
    }

    return size;
} @NoProfile

GfxTextureViewDesc :: struct {
    type : GfxTextureType;
    pixel_format : GfxPixelFormat;
    first_array_layer : u32;
    num_array_layers : u32 = 1;
    first_mipmap_level : u32;
    num_mipmap_levels : u32 = 1;
}

GfxTextureAndViewDesc :: struct {
    type : GfxTextureType;
    pixel_format : GfxPixelFormat;
    usage : GfxTextureUsage;
    width : u32 = 1;
    height : u32 = 1;
    depth : u32 = 1;
    first_array_layer : u32;
    num_array_layers : u32 = 1;
    first_mipmap_level : u32;
    num_mipmap_levels : u32 = 1;
    num_samples : u32 = 1;
}

GetTextureMipWidth :: (w : u32, mipmap_level : int) -> u32 {
    for 1..mipmap_level {
        w = Max(w / 2, 1);
    }

    return w;
} @NoProfile

GetTextureMipHeight :: (h : u32, mipmap_level : int) -> u32 {
    for 1..mipmap_level {
        h = Max(h / 2, 1);
    }

    return h;
} @NoProfile

GetTextureMipSize :: (w : u32, h : u32, mipmap_level : int) -> w : u32, h : u32 {
    for 1..mipmap_level {
        w = Max(w / 2, 1);
        h = Max(h / 2, 1);
    }

    return w, h;
} @NoProfile

GetTextureMipSize :: (desc : GfxTextureAndViewDesc, mipmap_level : int) -> w : u32, h : u32 {
    w, h := GetTextureMipSize(desc.width, desc.height, mipmap_level);
    return w, h;
} @NoProfile

MakeGfxTextureAndViewDesc :: inline (desc : GfxTextureDesc) -> GfxTextureAndViewDesc {
    return .{
        type=desc.type,
        pixel_format=desc.pixel_format,
        usage=desc.usage,
        width=desc.width,
        height=desc.height,
        depth=desc.depth,
        num_array_layers=desc.num_array_layers,
        num_mipmap_levels=desc.num_mipmap_levels,
        num_samples=desc.num_samples,
    };
} @NoProfile

MakeGfxTextureAndViewDesc :: inline (desc : GfxTextureAndViewDesc, view_desc : GfxTextureViewDesc) -> GfxTextureAndViewDesc {
    result := desc;
    result.type = view_desc.type;
    result.pixel_format = view_desc.pixel_format;
    result.first_array_layer = view_desc.first_array_layer;
    result.num_array_layers = view_desc.num_array_layers;
    result.first_mipmap_level = view_desc.first_mipmap_level;
    result.num_mipmap_levels = view_desc.num_mipmap_levels;

    return result;
} @NoProfile

GfxSamplerFilter :: enum u8 {
    Nearest;
    Linear;
}

GfxSamplerAddressMode :: enum u8 {
    Repeat;
    ClampToEdge;
    ClampToBorder;
    MirrorRepeat;
    MirrorClampToEdge;
}

GfxSamplerBorderColor :: enum u8 {
    Transparent;
    OpaqueBlack;
    OpaqueWhite;
}

GfxSamplerDesc :: struct {
    min_filter : GfxSamplerFilter = .Nearest;
    mag_filter : GfxSamplerFilter = .Nearest;
    mipmap_filter : GfxSamplerFilter = .Nearest;
    u_address_mode : GfxSamplerAddressMode = .ClampToEdge;
    v_address_mode : GfxSamplerAddressMode = .ClampToEdge;
    w_address_mode : GfxSamplerAddressMode = .ClampToEdge;
    border_color : GfxSamplerBorderColor;
    compare_op : GfxCompareOp = .None;
    anisotropy_enabled := false;
    max_anisotropy : float;
    mip_lod_bias := 0.0;
    min_lod := 0.0;
    max_lod := F32_Inf;
}

GfxAttachmentLoadOp :: enum {
    Load;
    Clear;
    DontCare;
}

GfxAttachmentStoreOp :: enum {
    Store;
    DontCare;
}

GfxAttachment :: struct {
    texture : *GfxTexture;
    resolve_texture : *GfxTexture;
    load_op : GfxAttachmentLoadOp = .Load;
    store_op : GfxAttachmentStoreOp = .Store;
}

GfxColorAttachment :: struct {
    #as using _ : GfxAttachment;
    clear_value : union {
        float4 : [4]float;
        int4   : [4]s32;
        uint4  : [4]u32;
    }
}

GfxDepthAttachment :: struct {
    #as using _ : GfxAttachment;
    clear_value : float;
}

GfxStencilAttachment :: struct {
    #as using _ : GfxAttachment;
    clear_value : u32;
}

GfxRenderPassDesc :: struct {
    num_color_attachments : u32;
    num_layers : u32 = 1;

    color_attachments : [Gfx_Max_Color_Attachments]GfxColorAttachment;
    depth_attachment : GfxDepthAttachment;
    stencil_attachment : GfxStencilAttachment;
}

AddColorAttachment :: (
    pass_desc : *GfxRenderPassDesc,
    texture : *GfxTexture,
    resolve_texture : *GfxTexture = null,
    load_op : GfxAttachmentLoadOp = .Load,
    store_op : GfxAttachmentStoreOp = .Store
) {
    Assert(pass_desc.num_color_attachments < Gfx_Max_Color_Attachments, "Too many color attachments");

    pass_desc.color_attachments[pass_desc.num_color_attachments] = .{
        texture=texture,
        resolve_texture=resolve_texture,
        load_op=load_op,
        store_op=store_op
    };
    pass_desc.num_color_attachments += 1;
} @NoProfile

AddDepthAttachment :: (
    pass_desc : *GfxRenderPassDesc,
    texture : *GfxTexture,
    resolve_texture : *GfxTexture = null,
    load_op : GfxAttachmentLoadOp = .Load,
    store_op : GfxAttachmentStoreOp = .Store
) {
    Assert(pass_desc.depth_attachment.texture == null, "Depth attachment is already set");

    pass_desc.depth_attachment = .{texture=texture, resolve_texture=resolve_texture, load_op=load_op, store_op=store_op};
} @NoProfile

AddStencilAttachment :: (
    pass_desc : *GfxRenderPassDesc,
    texture : *GfxTexture,
    resolve_texture : *GfxTexture,
    load_op : GfxAttachmentLoadOp = .Load,
    store_op : GfxAttachmentStoreOp = .Store
) {
    Assert(pass_desc.depth_attachment.texture == null, "Stencil attachment is already set");

    pass_desc.stencil_attachment = .{texture=texture, resolve_texture=resolve_texture, load_op=load_op, store_op=store_op};
} @NoProfile

ClearColor :: inline (pass_desc : *GfxRenderPassDesc, index : u32, value : Vec4f) {
    Assert(index < pass_desc.num_color_attachments, "No color attachment at index %", index);

    pass_desc.color_attachments[index].load_op = .Clear;
    pass_desc.color_attachments[index].clear_value.float4[0] = value.r;
    pass_desc.color_attachments[index].clear_value.float4[1] = value.g;
    pass_desc.color_attachments[index].clear_value.float4[2] = value.b;
    pass_desc.color_attachments[index].clear_value.float4[3] = value.a;
} @NoProfile

ClearColor :: inline (pass_desc : *GfxRenderPassDesc, index : u32, value : Vec4i) {
    Assert(index < pass_desc.num_color_attachments, "No color attachment at index %", index);

    pass_desc.color_attachments[index].load_op = .Clear;
    pass_desc.color_attachments[index].clear_value.int4[0] = value.r;
    pass_desc.color_attachments[index].clear_value.int4[1] = value.g;
    pass_desc.color_attachments[index].clear_value.int4[2] = value.b;
    pass_desc.color_attachments[index].clear_value.int4[3] = value.a;
} @NoProfile

ClearColor :: inline (pass_desc : *GfxRenderPassDesc, index : u32, value : Vec4u) {
    Assert(index < pass_desc.num_color_attachments, "No color attachment at index %", index);

    pass_desc.color_attachments[index].load_op = .Clear;
    pass_desc.color_attachments[index].clear_value.uint4[0] = value.r;
    pass_desc.color_attachments[index].clear_value.uint4[1] = value.g;
    pass_desc.color_attachments[index].clear_value.uint4[2] = value.b;
    pass_desc.color_attachments[index].clear_value.uint4[3] = value.a;
} @NoProfile

ClearDepth :: inline (pass_desc : *GfxRenderPassDesc, value : float) {
    pass_desc.depth_attachment.load_op = .Clear;
    pass_desc.depth_attachment.clear_value = value;
} @NoProfile

ClearStencil :: inline (pass_desc : *GfxRenderPassDesc, value : u32) {
    pass_desc.stencil_attachment.load_op = .Clear;
    pass_desc.stencil_attachment.clear_value = value;
} @NoProfile

GfxViewport :: struct {
    top_left_x : float;
    top_left_y : float;
    width : float;
    height : float;
    min_depth : float = 0;
    max_depth : float = 1;
}

GfxIndexType :: enum {
    UInt16;
    UInt32;
}

// More fine grained sync points can be added and are supported by Vulkan
GfxBarrierSyncPointFlags :: enum_flags {
    AllGraphics;
    AllCompute;
    AllTransfer;
    AllCommands;
}

// More fine grained access flags can be added and are supported by Vulkan
GfxBarrierAccessFlags :: enum_flags {
    AllWrites;
    AllReads;
}

GfxTextureLayout :: enum {
    Undefined;
    General;
    TransferSrc;
    TransferDst;
    ShaderReadOnly;
    ColorAttachment;
    DepthStencilAttachment;
    PresentSrc;
}
