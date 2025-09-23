#import "Vulkan";

Gfx_Viewport_Origin_Bottom_Left :: false;

GfxContext :: struct {
    window : *SDL_Window;
    instance : VkInstance;
    debug_messenger : VkDebugUtilsMessengerEXT;
    surface : VkSurfaceKHR;
    physical_device : VkPhysicalDevice;
    device : VkDevice;
    general_purpose_queue_index : u32;
    present_queue_index : u32;
    general_purpose_queue : VkQueue;
    present_queue : VkQueue;
    swapchain : VkSwapchainKHR;
    swapchain_format : GfxPixelFormat;
    swapchain_extent : VkExtent2D;
    swapchain_textures : []GfxTexture;
    frame_command_pools : []GfxCommandPool;
    swapchain_image_acquired_semaphores : []VkSemaphore;
    swapchain_image_ready_for_present_semaphores : []VkSemaphore;
    frame_in_flight_fences : []VkFence;
    frame_in_flight : int;
    frame_index : int;
    frame_swapchain_image_index : u32;
    allocation_callbacks : VkAllocationCallbacks;
    allocator : VmaAllocator;
    limits : GfxLimits;
    last_frame_statistics : GfxFrameStatistics;
    frame_statistics : GfxFrameStatistics;

    texture_view_collectors : [Gfx_Num_Frames_In_Flight]GfxGarbageCollector(GfxTexture);
    texture_collectors : [Gfx_Num_Frames_In_Flight]GfxGarbageCollector(GfxTexture);
    sampler_collectors : [Gfx_Num_Frames_In_Flight]GfxGarbageCollector(GfxSampler);
    buffer_collectors : [Gfx_Num_Frames_In_Flight]GfxGarbageCollector(GfxBuffer);

    command_buffers_to_submit : [..]VkCommandBuffer;

    vkSetDebugUtilsObjectNameEXT : PFN_vkSetDebugUtilsObjectNameEXT;
    vkCmdBeginDebugUtilsLabelEXT : PFN_vkCmdBeginDebugUtilsLabelEXT;
    vkCmdEndDebugUtilsLabelEXT : PFN_vkCmdEndDebugUtilsLabelEXT;
    vkQueueBeginDebugUtilsLabelEXT : PFN_vkQueueBeginDebugUtilsLabelEXT;
    vkQueueEndDebugUtilsLabelEXT : PFN_vkQueueEndDebugUtilsLabelEXT;
}

MakeGfxLimits :: inline (limits : VkPhysicalDeviceLimits) -> GfxLimits {
    result : GfxLimits;
    result.max_texture_1d_dimension = limits.maxImageDimension1D;
    result.max_texture_2d_dimension = limits.maxImageDimension2D;
    result.max_texture_3d_dimension = limits.maxImageDimension3D;
    result.max_texture_cube_dimension = limits.maxImageDimensionCube;
    result.max_texture_array_layers = limits.maxImageArrayLayers;
    result.max_memory_allocation_count = limits.maxMemoryAllocationCount;
    result.max_sampler_allocation_count = limits.maxSamplerAllocationCount;
    result.max_uniform_buffer_size = limits.maxUniformBufferRange;
    result.max_storage_buffer_size = limits.maxStorageBufferRange;
    result.uniform_buffer_offset_alignment = xx limits.minUniformBufferOffsetAlignment;
    result.storage_buffer_offset_alignment = xx limits.minStorageBufferOffsetAlignment;
    result.timestamp_tick_period = xx limits.timestampPeriod;

    return result;
} @NoProfile

GfxCommandPool :: struct {
    pool : VkCommandPool;
    free_cmd_buffers : [..]GfxCommandBuffer;
    used_cmd_buffers : [..]GfxCommandBuffer;
    name : string;
}

IsNull :: inline (pool : *GfxCommandPool) -> bool {
    return pool == null || pool.pool == VK_NULL_HANDLE;
} @NoProfile

GfxCommandBuffer :: struct {
    cmd_buffer : VkCommandBuffer;
}

IsNull :: inline (cmd_buffer : *GfxCommandBuffer) -> bool {
    return cmd_buffer == null || cmd_buffer.cmd_buffer == VK_NULL_HANDLE;
} @NoProfile

GfxShader :: struct {
    module : VkShaderModule;
}

IsNull :: inline (shader : *GfxShader) -> bool {
    return shader == null || shader.module == VK_NULL_HANDLE;
} @NoProfile

MakeVkShaderStageFlags :: inline (stages : GfxShaderStageFlags) -> VkShaderStageFlags {
    result : VkShaderStageFlags;
    if stages & .Vertex {
        result |= .VERTEX_BIT;
    }
    if stages & .Fragment {
        result |= .FRAGMENT_BIT;
    }
    if stages & .Compute {
        result |= .COMPUTE_BIT;
    }

    return result;
} @NoProfile

MakeVkDescriptorType :: inline (type : GfxBindingType) -> VkDescriptorType {
    if #complete type == {
    case .UniformBuffer;          return .UNIFORM_BUFFER;
    case .StorageBuffer;          return .STORAGE_BUFFER;
    case .Texture;                return .SAMPLED_IMAGE;
    case .Sampler;                return .SAMPLER;
    case .CombinedTextureSampler; return .COMBINED_IMAGE_SAMPLER;
    case .StorageImage;           return .STORAGE_IMAGE;
    }
} @NoProfile

MakeVkDescriptorBindingFlags :: inline (flags : GfxBindingFlags) -> VkDescriptorBindingFlags {
    result : VkDescriptorBindingFlags;
    if flags & .AllowNull {
        result |= .PARTIALLY_BOUND_BIT;
    }

    return result;
} @NoProfile

GfxBindingSetLayout :: struct {
    layout : VkDescriptorSetLayout;
    name : string;
    desc : GfxBindingSetLayoutDesc;
}

IsNull :: inline (layout : *GfxBindingSetLayout) -> bool {
    return layout == null || layout.layout == VK_NULL_HANDLE;
} @NoProfile

GfxBindingPool :: struct {
    pool : VkDescriptorPool;
}

IsNull :: inline (pool : *GfxBindingPool) -> bool {
    return pool == null || pool.pool == VK_NULL_HANDLE;
} @NoProfile

GfxBindingSet :: struct {
    set : VkDescriptorSet;
}

IsNull :: inline (set : *GfxBindingSet) -> bool {
    return set == null || set.set == VK_NULL_HANDLE;
} @NoProfile

MakeGfxBindingPoolAllocResult :: inline (result : VkResult) -> GfxBindingPoolAllocResult {
    if result == {
    case .SUCCESS; return .Success;
    case .ERROR_OUT_OF_POOL_MEMORY; return .OutOfPoolMemory;
    case .ERROR_OUT_OF_DEVICE_MEMORY; return .OutOfDeviceMemory;
    case .ERROR_OUT_OF_HOST_MEMORY; return .OutOfHostMemory;
    case .ERROR_FRAGMENTED_POOL; return .FragmentedPool;
    case; return .UnknownError;
    }
} @NoProfile

// Generates VkDescriptorBufferInfo, VkDescriptorImageInfo and VkWriteDescriptorSet then calls vkUpdateDescriptorSets automatically
// @AllowNull bindings are handled using the partially bound feature, so it is expected that when the binding is null it
// is not accessed in the shader. It is not the same thing as the null descriptor feature and failure to comply to this
// will result in crashes!
UpdateGfxBindingSet :: (set : *GfxBindingSet, value : $T) {
    #insert -> string {
        AppendBufferInfo :: (builder : *StringBuilder, name : string) {
            Appendln(builder, "    .{buffer=ifx value.%1.buffer then value.%1.buffer.buffer, offset=value.%1.offset, range=value.%1.size},", name);
        }

        AppendImageInfo :: (builder : *StringBuilder, name : string) {
            Appendln(builder, "    .{imageView=ifx value.%1.texture then value.%1.texture.image_view else VK_NULL_HANDLE, imageLayout=.READ_ONLY_OPTIMAL},", name);
        }

        AppendSamplerInfo :: (builder : *StringBuilder, name : string) {
            Appendln(builder, "    .{sampler=ifx value.%1.sampler then value.%1.sampler.sampler else VK_NULL_HANDLE},", name);
        }

        AppendCombinedImageSamplerInfo :: (builder : *StringBuilder, name : string) {
            Appendln(builder, "    .{sampler=ifx value.%1.sampler then value.%1.sampler.sampler else VK_NULL_HANDLE, imageView=ifx value.%1.texture then value.%1.texture.image_view else VK_NULL_HANDLE, imageLayout=.READ_ONLY_OPTIMAL},", name);
        }

        AppendStorageImageInfo :: (builder : *StringBuilder, name : string) {
            Appendln(builder, "    .{imageView=ifx value.%1.texture then value.%1.texture.image_view else VK_NULL_HANDLE, imageLayout=.GENERAL},", name);
        }

        builder : StringBuilder;
        info := type_info(T);

        Appendln(*builder, "// UpdateGfxBindingSet(%)", T);
        Appendln(*builder, "buffer_infos := VkDescriptorBufferInfo.[");

        max_possible_writes := 0;

        for info.members {
            if it.type.type == .ARRAY {
                continue;
            }

            type := GetGfxBindingType(it.type);
            if type == {
            case .UniformBuffer; #through;
            case .StorageBuffer;
                AppendBufferInfo(*builder, it.name);
                max_possible_writes += 1;
            }
        }

        Appendln(*builder, "];");

        Appendln(*builder, "image_infos := VkDescriptorImageInfo.[");

        for info.members {
            if it.type.type == .ARRAY {
                count := cast(*Type_Info_Array, it.type).array_count;
                type := GetGfxBindingType(cast(*Type_Info_Array, it.type).element_type);
                for i : 0..count - 1 {
                    if type == {
                    case .Texture;
                        AppendImageInfo(*builder, TPrint("%[%]", it.name, i));
                    case .Sampler;
                        AppendSamplerInfo(*builder, TPrint("%[%]", it.name, i));
                    case .CombinedTextureSampler;
                        AppendCombinedImageSamplerInfo(*builder, TPrint("%[%]", it.name, i));
                    case .StorageImage;
                        AppendStorageImageInfo(*builder, TPrint("%[%]", it.name, i));
                    }
                }

                max_possible_writes += count;
            } else {
                type := GetGfxBindingType(it.type);
                if type == {
                case .Texture;
                    AppendImageInfo(*builder, it.name);
                case .Sampler;
                    AppendSamplerInfo(*builder, it.name);
                case .CombinedTextureSampler;
                    AppendCombinedImageSamplerInfo(*builder, it.name);
                case .StorageImage;
                    AppendStorageImageInfo(*builder, it.name);
                }

                max_possible_writes += 1;
            }
        }

        Appendln(*builder, "];");

        AppendWrite :: (builder : *StringBuilder, allow_null : bool, binding : int, type : GfxBindingType, name : string, array_index : int, buffer_info_index : *int, image_info_index : *int) {
            if allow_null {
                if type == {
                case .UniformBuffer; #through;
                case .StorageBuffer;
                    Appendln(builder, "if !IsNull(value.%1.buffer) && value.%1.size > 0 {", name);

                case .Texture; #through;
                case .StorageImage;
                    Appendln(builder, "if !IsNull(value.%1) {", name);

                case .Sampler;
                    Appendln(builder, "if !IsNull(value.%1) {", name);

                case .CombinedTextureSampler;
                    Appendln(builder, "if !IsNull(value.%1.texture) {", name);
                }
            }

            if allow_null {
                Append(builder, "    ");
            }

            Appendln(builder, "write = ArrayPush(*writes);");

            if allow_null {
                Append(builder, "    ");
            }

            Append(builder,   "write.* = .{dstSet=set.set, dstBinding=%, descriptorType=.%, descriptorCount=1, dstArrayElement=%, ", binding, MakeVkDescriptorType(type), array_index);

            if type == {
            case .UniformBuffer; #through;
            case .StorageBuffer;
                Append(builder, "pBufferInfo=*buffer_infos[%]", buffer_info_index.*);
                buffer_info_index.* += 1;

            case .StorageImage; #through;
            case .Texture; #through;
            case .Sampler; #through;
            case .CombinedTextureSampler;
                Append(builder, "pImageInfo=*image_infos[%]", image_info_index.*);
                image_info_index.* += 1;
            }

            Appendln(builder, "};");

            if allow_null {
                Appendln(builder, "}");
            }
        }

        buffer_info_index := 0;
        image_info_index := 0;

        Appendln(*builder, "writes_stack_data : [%]VkWriteDescriptorSet = ---;", max_possible_writes);
        Appendln(*builder, "writes : [..]VkWriteDescriptorSet;");
        Appendln(*builder, "writes.allocator = Trap;");
        Appendln(*builder, "writes.data = writes_stack_data.data;");
        Appendln(*builder, "writes.allocated = writes_stack_data.count;");
        Appendln(*builder, "write : *VkWriteDescriptorSet;");

        for info.members {
            has_binding_note, binding := GetNote(it.notes, "Binding", int);
            allow_null := GetNote(it.notes, "AllowNull");

            if it.type.type == .ARRAY {
                elem_type := cast(*Type_Info_Array, it.type).element_type;
                elem_count := cast(*Type_Info_Array, it.type).array_count;
                type := GetGfxBindingType(elem_type);
                for i : 0..elem_count - 1 {
                    AppendWrite(*builder, allow_null, binding, type, TPrint("%[%]", it.name, i), i, *buffer_info_index, *image_info_index);
                }
            } else {
                type := GetGfxBindingType(it.type);
                AppendWrite(*builder, allow_null, binding, type, it.name, 0, *buffer_info_index, *image_info_index);
            }
        }

        return StringBuilderBuild(*builder);
    }

    vkUpdateDescriptorSets(GetGfxContext().device, xx writes.count, writes.data, 0, null);
} @NoProfile

MakeVkFormat :: inline (pixel_format : GfxPixelFormat) -> VkFormat {
    if #complete pixel_format == {
    case .Invalid; return .UNDEFINED;
    case .R8UNorm; return .R8_UNORM;
    case .R8SNorm; return .R8_SNORM;
    case .R8UInt; return .R8_UINT;
    case .R8SInt; return .R8_SINT;
    case .RGBA8SRGB; return .R8G8B8A8_SRGB;
    case .RGBA8UNorm; return .R8G8B8A8_UNORM;
    case .RGBA8SNorm; return .R8G8B8A8_SNORM;
    case .RGBA8UInt; return .R8G8B8A8_UINT;
    case .RGBA8SInt; return .R8G8B8A8_SINT;
    case .BGRA8UNorm; return .B8G8R8A8_UNORM;
    case .BGRA8SRGB; return .B8G8R8A8_SRGB;
    case .R32UInt; return .R32_UINT;
    case .R32SInt; return .R32_SINT;
    case .RGBA16Float; return .R16G16B16A16_SFLOAT;
    case .RGBA32UInt; return .R32G32B32A32_UINT;
    case .RGBA32SInt; return .R32G32B32A32_SINT;
    case .RGBA32Float; return .R32G32B32A32_SFLOAT;
    case .Depth32FloatStencil8; return .D32_SFLOAT_S8_UINT;
    case .Depth32Float; return .D32_SFLOAT;
    case .Stencil8; return .S8_UINT;
    }
    return .UNDEFINED;
} @NoProfile

MakeGfxPixelFormat :: inline (format : VkFormat) -> GfxPixelFormat {
    if format == {
    case .UNDEFINED; return .Invalid;
    case .R8_UNORM; return .R8UNorm;
    case .R8_SNORM; return .R8SNorm;
    case .R8_UINT; return .R8UInt;
    case .R8_SINT; return .R8SInt;
    case .R8G8B8A8_SRGB; return .RGBA8SRGB;
    case .R8G8B8A8_UNORM; return .RGBA8UNorm;
    case .R8G8B8A8_SNORM; return .RGBA8SNorm;
    case .R8G8B8A8_UINT; return .RGBA8UInt;
    case .R8G8B8A8_SINT; return .RGBA8SInt;
    case .B8G8R8A8_UNORM; return .BGRA8UNorm;
    case .B8G8R8A8_SRGB; return .BGRA8SRGB;
    case .R32_UINT; return .R32UInt;
    case .R32_SINT; return .R32SInt;
    case .R16G16B16A16_SFLOAT; return .RGBA16Float;
    case .R32G32B32A32_UINT; return .RGBA32UInt;
    case .R32G32B32A32_SINT; return .RGBA32SInt;
    case .R32G32B32A32_SFLOAT; return .RGBA32Float;
    case .D32_SFLOAT_S8_UINT; return .Depth32FloatStencil8;
    case .D32_SFLOAT; return .Depth32Float;
    case .S8_UINT; return .Stencil8;
    }
    return .Invalid;
} @NoProfile

MakeVkFormat :: (format : GfxVertexFormat, normalized : bool) -> VkFormat {
    if #complete format == {
    case .Invalid; return .UNDEFINED;
    case .Float; return .R32_SFLOAT;
    case .Float2; return .R32G32_SFLOAT;
    case .Float3; return .R32G32B32_SFLOAT;
    case .Float4; return .R32G32B32A32_SFLOAT;
    case .Char2; return ifx normalized then .R8G8_SNORM else .R8G8_SINT;
    case .Char3; return ifx normalized then .R8G8B8_SNORM else .R8G8B8_SINT;
    case .Char4; return ifx normalized then .R8G8B8A8_SNORM else .R8G8B8A8_SINT;
    case .UChar2; return ifx normalized then .R8G8_UNORM else .R8G8_UINT;
    case .UChar3; return ifx normalized then .R8G8B8_UNORM else .R8G8B8_UINT;
    case .UChar4; return ifx normalized then .R8G8B8A8_UNORM else .R8G8B8A8_UINT;
    case .Short2; return ifx normalized then .R16G16_SNORM else .R16G16_SINT;
    case .Short3; return ifx normalized then .R16G16B16_SNORM else .R16G16B16_SINT;
    case .Short4; return ifx normalized then .R16G16B16A16_SNORM else .R16G16B16A16_SINT;
    case .UShort2; return ifx normalized then .R16G16_UNORM else .R16G16_UINT;
    case .UShort3; return ifx normalized then .R16G16B16_UNORM else .R16G16B16_UINT;
    case .UShort4; return ifx normalized then .R16G16B16A16_UNORM else .R16G16B16A16_UINT;
    // No normalized 32-bit integer formats?
    case .Int; return .R32_SINT;
    case .Int2; return .R32G32_SINT;
    case .Int3; return .R32G32B32_SINT;
    case .Int4; return .R32G32B32A32_SINT;
    case .UInt; return .R32G32_UINT;
    case .UInt2; return .R32G32_UINT;
    case .UInt3; return .R32G32B32_UINT;
    case .UInt4; return .R32G32B32A32_UINT;
    }
} @NoProfile

MakeVkCompareOp :: inline (compare_op : GfxCompareOp) -> VkCompareOp {
    if #complete compare_op == {
    case; #through;
    case .None; Panic("Invalid value for compare_op");
    case .Never;        return .NEVER;
    case .Always;       return .ALWAYS;
    case .Less;         return .LESS;
    case .LessEqual;    return .LESS_OR_EQUAL;
    case .Greater;      return .GREATER;
    case .GreaterEqual; return .GREATER_OR_EQUAL;
    case .Equal;        return .EQUAL;
    case .NotEqual;     return .NOT_EQUAL;
    }
    return .MAX_ENUM;
} @NoProfile

MakeVkStencilOp :: inline (stencil_op : GfxStencilOp) -> VkStencilOp {
    if #complete stencil_op == {
    case; Panic("Invalid value for stencil_op");
    case .Keep;           return .KEEP;
    case .Zero;           return .ZERO;
    case .Replace;        return .REPLACE;
    case .IncrementClamp; return .INCREMENT_AND_CLAMP;
    case .IncrementWrap;  return .INCREMENT_AND_WRAP;
    case .DecrementClamp; return .DECREMENT_AND_CLAMP;
    case .DecrementWrap;  return .DECREMENT_AND_WRAP;
    case .Invert;         return .INVERT;
    }
    return .MAX_ENUM;
} @NoProfile

MakeVkBlendFactor :: inline (blend_factor : GfxBlendFactor) -> VkBlendFactor {
    if #complete blend_factor == {
    case; Panic("Invalid value for blend_factor");
    case .Zero;                  return .ZERO;
    case .One;                   return .ONE;
    case .SrcColor;              return .SRC_COLOR;
    case .OneMinusSrcColor;      return .ONE_MINUS_SRC_COLOR;
    case .DstColor;              return .DST_COLOR;
    case .OneMinusDstColor;      return .ONE_MINUS_DST_COLOR;
    case .SrcAlpha;              return .SRC_ALPHA;
    case .OneMinusSrcAlpha;      return .ONE_MINUS_SRC_ALPHA;
    case .DstAlpha;              return .DST_ALPHA;
    case .OneMinusDstAlpha;      return .ONE_MINUS_DST_ALPHA;
    case .ConstantColor;         return .CONSTANT_COLOR;
    case .OneMinusConstantColor; return .ONE_MINUS_CONSTANT_COLOR;
    case .ConstantAlpha;         return .CONSTANT_ALPHA;
    case .OneMinusConstantAlpha; return .ONE_MINUS_CONSTANT_ALPHA;
    case .SrcAlphaSaturate;      return .SRC_ALPHA_SATURATE;
    case .Src1Color;             return .SRC1_COLOR;
    case .OneMinusSrc1Color;     return .ONE_MINUS_SRC1_COLOR;
    case .Src1Alpha;             return .SRC1_ALPHA;
    case .OneMinusSrc1Alpha;     return .ONE_MINUS_SRC1_ALPHA;
    }
    return .MAX_ENUM;
} @NoProfile

MakeVkBlendOp :: inline (blend_op : GfxBlendOp) -> VkBlendOp {
    if #complete blend_op == {
    case .Add;             return .ADD;
    case .Subtract;        return .SUBTRACT;
    case .ReverseSubtract; return .REVERSE_SUBTRACT;
    case .Min;             return .MIN;
    case .Max;             return .MAX;
    }
    return .MAX_ENUM;
} @NoProfile

// I don't like having this concept in the abstraction layer as I don't find this very useful.
// Currently it is needed so we can bind the global frame binding set at the beginning of the
// frame outside of any render passes (and without needing a full pipeline).
GfxPipelineLayout :: struct {
    layout : VkPipelineLayout;
    name : string;
}

IsNull :: inline (layout : *GfxPipelineLayout) -> bool {
    return layout == null || layout.layout == VK_NULL_HANDLE;
} @NoProfile

GfxGraphicsPipeline :: struct {
    layout : GfxPipelineLayout;
    pipeline : VkPipeline;
    name : string;
    desc : GfxGraphicsPipelineDesc;
}

IsNull :: inline (pipeline : *GfxGraphicsPipeline) -> bool {
    return pipeline == null || pipeline.pipeline == VK_NULL_HANDLE || IsNull(*pipeline.layout);
} @NoProfile

GfxComputePipeline :: struct {
    layout : GfxPipelineLayout;
    pipeline : VkPipeline;
    name : string;
    desc : GfxComputePipelineDesc;
}

IsNull :: inline (pipeline : *GfxComputePipeline) -> bool {
    return pipeline == null || pipeline.pipeline == VK_NULL_HANDLE || IsNull(*pipeline.layout);
} @NoProfile

GfxBuffer :: struct {
    buffer : VkBuffer;
    allocation : VmaAllocation;
    name : string;
    desc : GfxBufferDesc;
}

IsNull :: inline (buffer : *GfxBuffer) -> bool {
    return buffer == null || buffer.buffer == VK_NULL_HANDLE;
} @NoProfile

MakeVkImageSubresourceRange :: (desc : GfxTextureAndViewDesc) -> VkImageSubresourceRange {
    subresource : VkImageSubresourceRange;
    subresource.baseMipLevel = desc.first_mipmap_level;
    subresource.levelCount = desc.num_mipmap_levels;
    subresource.baseArrayLayer = desc.first_array_layer;
    subresource.layerCount = desc.num_array_layers;

    if desc.type == .TextureCube || desc.type == .TextureCubeArray {
        subresource.layerCount *= 6;
    }

    if desc.pixel_format == {
    case .Depth32FloatStencil8;
        subresource.aspectMask = .DEPTH_BIT | .STENCIL_BIT;
    case .Depth32Float;
        subresource.aspectMask = .DEPTH_BIT;
    case .Stencil8;
        subresource.aspectMask = .STENCIL_BIT;
    case;
        subresource.aspectMask = .COLOR_BIT;
    }

    return subresource;
} @NoProfile

MakeVkImageSubresourceLayers :: (desc : GfxTextureAndViewDesc, mip_level : u32) -> VkImageSubresourceLayers {
    subresource : VkImageSubresourceLayers;
    subresource.mipLevel = mip_level;
    subresource.baseArrayLayer = desc.first_array_layer;
    subresource.layerCount = desc.num_array_layers;

    if desc.type == .TextureCube || desc.type == .TextureCubeArray {
        subresource.layerCount *= 6;
    }

    if desc.pixel_format == {
    case .Depth32FloatStencil8;
        subresource.aspectMask = .DEPTH_BIT | .STENCIL_BIT;
    case .Depth32Float;
        subresource.aspectMask = .DEPTH_BIT;
    case .Stencil8;
        subresource.aspectMask = .STENCIL_BIT;
    case;
        subresource.aspectMask = .COLOR_BIT;
    }

    return subresource;
} @NoProfile

GfxTexture :: struct {
    image : VkImage;
    image_view : VkImageView; // Default view for this texture
    allocation : VmaAllocation;
    name : string;
    desc : GfxTextureAndViewDesc;
}

IsNull :: inline (texture : *GfxTexture) -> bool {
    return texture == null || texture.image == VK_NULL_HANDLE;
} @NoProfile

MakeVkFilter :: inline (filter : GfxSamplerFilter) -> VkFilter {
    if #complete filter == {
    case .Nearest; return .NEAREST;
    case .Linear; return .LINEAR;
    }
} @NoProfile

MakeVkSamplerMipmapMode :: inline (filter : GfxSamplerFilter) -> VkSamplerMipmapMode {
    if #complete filter == {
    case .Nearest; return .NEAREST;
    case .Linear; return .LINEAR;
    }
} @NoProfile

MakeVkSamplerAddressMode :: (mode : GfxSamplerAddressMode) -> VkSamplerAddressMode {
    if #complete mode == {
    case .Repeat;            return .REPEAT;
    case .ClampToEdge;       return .CLAMP_TO_EDGE;
    case .ClampToBorder;     return .CLAMP_TO_BORDER;
    case .MirrorRepeat;      return .MIRRORED_REPEAT;
    case .MirrorClampToEdge; return .MIRROR_CLAMP_TO_EDGE;
    }
} @NoProfile

MakeVkBorderColor :: (color : GfxSamplerBorderColor) -> VkBorderColor {
    if #complete color == {
    case .Transparent; return .FLOAT_TRANSPARENT_BLACK;
    case .OpaqueBlack; return .FLOAT_OPAQUE_BLACK;
    case .OpaqueWhite; return .FLOAT_OPAQUE_WHITE;
    }
} @NoProfile

GfxSampler :: struct {
    sampler : VkSampler;
    name : string;
    desc : GfxSamplerDesc;
}

IsNull :: inline (sampler : *GfxSampler) -> bool {
    return sampler == null || sampler.sampler == VK_NULL_HANDLE;
} @NoProfile

MakeVkAttachmentLoadOp :: inline (op : GfxAttachmentLoadOp) -> VkAttachmentLoadOp {
    if #complete op == {
    case .Load;     return .LOAD;
    case .Clear;    return .CLEAR;
    case .DontCare; return .DONT_CARE;
    }
} @NoProfile

MakeVkAttachmentStoreOp :: inline (op : GfxAttachmentStoreOp) -> VkAttachmentStoreOp {
    if #complete op == {
    case .Store;    return .STORE;
    case .DontCare; return .DONT_CARE;
    }
} @NoProfile

GfxRenderPass :: struct {
    cmd_buffer : *GfxCommandBuffer;
    profiling_event : *GPUProfilingEvent;

    current_pipeline : *GfxGraphicsPipeline;

    name : string;
    desc : GfxRenderPassDesc;
}

GfxComputePass :: struct {
    cmd_buffer : *GfxCommandBuffer;
    profiling_event : *GPUProfilingEvent;

    current_pipeline : *GfxComputePipeline;

    name : string;
}

GfxCopyPass :: struct {
    cmd_buffer : *GfxCommandBuffer;
    profiling_event : *GPUProfilingEvent;
    name : string;
}

MakeVkPipelineStageFlags :: inline (sync_point : GfxBarrierSyncPointFlags) -> VkPipelineStageFlags {
    result : VkPipelineStageFlags;
    if sync_point & .AllGraphics {
        result |= .ALL_GRAPHICS_BIT;
    }
    if sync_point & .AllCompute {
        result |= .COMPUTE_SHADER_BIT;
    }
    if sync_point & .AllTransfer {
        result |= .TRANSFER_BIT;
    }
    if sync_point & .AllCommands {
        result |= .ALL_COMMANDS_BIT;
    }

    return result;
} @NoProfile

MakeVkAccessFlags :: inline (access : GfxBarrierAccessFlags) -> VkAccessFlags {
    result : VkAccessFlags;
    if access & .AllReads {
        result |= .MEMORY_READ_BIT;
    }
    if access & .AllWrites {
        result |= .MEMORY_WRITE_BIT;
    }

    return result;
} @NoProfile

MakeVkImageLayout :: inline (layout : GfxTextureLayout) -> VkImageLayout {
    if #complete layout == {
    case .Undefined;              return .UNDEFINED;
    case .General;                return .GENERAL;
    case .TransferSrc;            return .TRANSFER_SRC_OPTIMAL;
    case .TransferDst;            return .TRANSFER_DST_OPTIMAL;
    case .ShaderReadOnly;         return .SHADER_READ_ONLY_OPTIMAL ;
    case .ColorAttachment;        return .COLOR_ATTACHMENT_OPTIMAL;
    case .DepthStencilAttachment; return .DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
    case .PresentSrc;             return .PRESENT_SRC_KHR;
    }
} @NoProfile
