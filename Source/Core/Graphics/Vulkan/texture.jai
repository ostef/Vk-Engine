CreateGfxTexture :: (name : string, desc : GfxTextureDesc) -> GfxTexture {
    LogSectionScope(*Log_Vulkan);

    image_info : VkImageCreateInfo;
    if #complete desc.type == {
    case .Invalid; Panic("Invalid image type");
    case .Texture1D;        image_info.imageType = ._1D;
    case .Texture2D;        image_info.imageType = ._2D;
    case .Texture2DMS;      image_info.imageType = ._2D;
    case .Texture3D;        image_info.imageType = ._3D;
    case .TextureCube;      image_info.imageType = ._2D;
    case .Texture1DArray;   image_info.imageType = ._1D;
    case .Texture2DArray;   image_info.imageType = ._2D;
    case .Texture2DMSArray; image_info.imageType = ._2D;
    case .TextureCubeArray; image_info.imageType = ._2D;
    }

    if desc.num_samples == {
    case 1;  image_info.samples = ._1_BIT;
    case 2;  image_info.samples = ._2_BIT;
    case 4;  image_info.samples = ._4_BIT;
    case 8;  image_info.samples = ._8_BIT;
    case 16; image_info.samples = ._16_BIT;
    case 32; image_info.samples = ._32_BIT;
    case 64; image_info.samples = ._64_BIT;
    case;
        Panic("Invalid sample count % for texture (expected 1, 2, 4, 8, 16, 32 or 64)", desc.num_samples);
    }

    image_info.format = MakeVkFormat(desc.pixel_format);
    image_info.tiling = .OPTIMAL;

    image_info.arrayLayers = desc.num_array_layers;
    image_info.mipLevels = desc.num_mipmap_levels;
    image_info.extent = .{desc.width, desc.height, desc.depth};

    if desc.type == .TextureCube || desc.type == .TextureCubeArray {
        image_info.flags |= .CUBE_COMPATIBLE_BIT;
        image_info.arrayLayers *= 6;
    }

    if desc.usage & .TransferSrc {
        image_info.usage |= .TRANSFER_SRC_BIT;
    }
    if desc.usage & .TransferDst {
        image_info.usage |= .TRANSFER_DST_BIT;
    }
    if desc.usage & .Sampled {
        image_info.usage |= .SAMPLED_BIT;
    }
    if desc.usage & .Storage {
        image_info.usage |= .STORAGE_BIT;
    }
    if desc.usage & .ColorAttachment {
        image_info.usage |= .COLOR_ATTACHMENT_BIT;
    }
    if desc.usage & .DepthStencilAttachment {
        image_info.usage |= .DEPTH_STENCIL_ATTACHMENT_BIT;
    }

    image_info.sharingMode = .EXCLUSIVE;
    image_info.queueFamilyIndexCount = 1;
    image_info.pQueueFamilyIndices = *g_gfx_context.general_purpose_queue_index;

    alloc_info : VmaAllocationCreateInfo;
    alloc_info.usage = .AUTO;
    alloc_info.flags = .DEDICATED_MEMORY_BIT;
    alloc_info.priority = 1;

    image : VkImage;
    allocation : VmaAllocation;
    if vmaCreateImage(g_gfx_context.allocator, *image_info, *alloc_info, *image, *allocation, null) != .SUCCESS {
        return .{};
    }

    view_info : VkImageViewCreateInfo;
    view_info.image = image;
    view_info.format = image_info.format;

    if #complete desc.type == {
    case .Invalid;
    case .Texture1D;        view_info.viewType = ._1D;
    case .Texture2D;        view_info.viewType = ._2D;
    case .Texture2DMS;      view_info.viewType = ._2D;
    case .Texture3D;        view_info.viewType = ._3D;
    case .TextureCube;      view_info.viewType = .CUBE;
    case .Texture1DArray;   view_info.viewType = ._1D_ARRAY;
    case .Texture2DArray;   view_info.viewType = ._2D_ARRAY;
    case .Texture2DMSArray; view_info.viewType = ._2D_ARRAY;
    case .TextureCubeArray; view_info.viewType = .CUBE_ARRAY;
    }

    if desc.pixel_format == {
    case .Depth32FloatStencil8;
        view_info.subresourceRange.aspectMask = .DEPTH_BIT | .STENCIL_BIT;
    case .Depth32Float;
        view_info.subresourceRange.aspectMask = .DEPTH_BIT;
    case .Stencil8;
        view_info.subresourceRange.aspectMask = .STENCIL_BIT;
    case;
        view_info.subresourceRange.aspectMask = .COLOR_BIT;
    }

    view_info.subresourceRange.baseMipLevel = 0;
    view_info.subresourceRange.levelCount = image_info.mipLevels;
    view_info.subresourceRange.baseArrayLayer = 0;
    view_info.subresourceRange.layerCount = image_info.arrayLayers;

    image_view : VkImageView;
    if vkCreateImageView(g_gfx_context.device, *view_info, g_vk_alloc_callbacks, *image_view) != .SUCCESS {
        vmaDestroyImage(g_gfx_context.allocator, image, allocation);
        return .{};
    }

    SetDebugName(image, TPrint("Image '%'", name));
    SetDebugName(image_view, TPrint("Image View '%'", name));

    return .{image=image, image_view=image_view, allocation=allocation, name=StringClone(name), desc=MakeGfxTextureAndViewDesc(desc)};
} @Public @NoProfile

DestroyGfxTexture :: (texture : *GfxTexture) {
    LogSectionScope(*Log_Vulkan);

    Free(texture.name.data);
    vkDestroyImageView(g_gfx_context.device, texture.image_view, g_vk_alloc_callbacks);
    vmaDestroyImage(g_gfx_context.allocator, texture.image, texture.allocation);
    texture.* = .{};
} @Public @NoProfile

QueueDestroyGfxTexture :: (texture : *GfxTexture) {
    collector := *g_gfx_context.texture_collectors[g_gfx_context.frame_in_flight];
    AddGarbage(collector, texture);
    texture.* = .{};
} @Public @NoProfile

CreateGfxTextureView :: (name : string, desc : GfxTextureViewDesc, texture : *GfxTexture) -> GfxTexture {
    if IsNull(texture) {
        return .{};
    }

    view_info : VkImageViewCreateInfo;
    view_info.image = texture.image;
    view_info.format = MakeVkFormat(desc.pixel_format);

    if #complete desc.type == {
    case .Invalid;
    case .Texture1D;        view_info.viewType = ._1D;
    case .Texture2D;        view_info.viewType = ._2D;
    case .Texture2DMS;      view_info.viewType = ._2D;
    case .Texture3D;        view_info.viewType = ._3D;
    case .TextureCube;      view_info.viewType = .CUBE;
    case .Texture1DArray;   view_info.viewType = ._1D_ARRAY;
    case .Texture2DArray;   view_info.viewType = ._2D_ARRAY;
    case .Texture2DMSArray; view_info.viewType = ._2D_ARRAY;
    case .TextureCubeArray; view_info.viewType = .CUBE_ARRAY;
    }

    if desc.pixel_format == {
    case .Depth32FloatStencil8;
        view_info.subresourceRange.aspectMask = .DEPTH_BIT | .STENCIL_BIT;
    case .Depth32Float;
        view_info.subresourceRange.aspectMask = .DEPTH_BIT;
    case .Stencil8;
        view_info.subresourceRange.aspectMask = .STENCIL_BIT;
    case;
        view_info.subresourceRange.aspectMask = .COLOR_BIT;
    }

    view_info.subresourceRange.baseMipLevel = desc.first_mipmap_level;
    view_info.subresourceRange.levelCount = desc.num_mipmap_levels;
    view_info.subresourceRange.baseArrayLayer = desc.first_array_layer;
    view_info.subresourceRange.layerCount = desc.num_array_layers;

    image_view : VkImageView;
    if vkCreateImageView(g_gfx_context.device, *view_info, g_vk_alloc_callbacks, *image_view) != .SUCCESS {
        return .{};
    }

    SetDebugName(image_view, TPrint("Image View '%'", name));

    return .{image=texture.image, image_view=image_view, allocation=texture.allocation, name=StringClone(name), desc=MakeGfxTextureAndViewDesc(texture.desc, desc)};
} @Public @NoProfile

DestroyGfxTextureView :: (texture : *GfxTexture) {
    LogSectionScope(*Log_Vulkan);

    Free(texture.name.data);
    vkDestroyImageView(g_gfx_context.device, texture.image_view, g_vk_alloc_callbacks);
    texture.* = .{};
} @Public @NoProfile

QueueDestroyGfxTextureView :: (texture : *GfxTexture) {
    collector := *g_gfx_context.texture_view_collectors[g_gfx_context.frame_in_flight];
    AddGarbage(collector, texture);
    texture.* = .{};
} @Public @NoProfile

CreateGfxSampler :: (name : string, desc : GfxSamplerDesc) -> GfxSampler {
    LogSectionScope(*Log_Vulkan);

    create_info : VkSamplerCreateInfo;
    create_info.minFilter = MakeVkFilter(desc.min_filter);
    create_info.magFilter = MakeVkFilter(desc.mag_filter);
    create_info.mipmapMode = MakeVkSamplerMipmapMode(desc.mipmap_filter);
    create_info.mipLodBias = desc.mip_lod_bias;
    create_info.minLod = desc.min_lod;
    create_info.maxLod = desc.max_lod;
    create_info.addressModeU = MakeVkSamplerAddressMode(desc.u_address_mode);
    create_info.addressModeV = MakeVkSamplerAddressMode(desc.v_address_mode);
    create_info.addressModeW = MakeVkSamplerAddressMode(desc.w_address_mode);
    if desc.compare_op != .None {
        create_info.compareEnable = VK_TRUE;
        create_info.compareOp = MakeVkCompareOp(desc.compare_op);
    }
    create_info.anisotropyEnable = xx desc.anisotropy_enabled;
    create_info.maxAnisotropy = desc.max_anisotropy;
    create_info.borderColor = MakeVkBorderColor(desc.border_color);

    sampler : VkSampler;
    if vkCreateSampler(g_gfx_context.device, *create_info, g_vk_alloc_callbacks, *sampler) != .SUCCESS {
        return .{};
    }

    SetDebugName(sampler, TPrint("Sampler '%'", name));

    return .{sampler=sampler, name=StringClone(name), desc=desc};
} @Public @NoProfile

DestroyGfxSampler :: (sampler : *GfxSampler) {
    LogSectionScope(*Log_Vulkan);

    Free(sampler.name.data);
    vkDestroySampler(g_gfx_context.device, sampler.sampler, g_vk_alloc_callbacks);
    sampler.* = .{};
} @Public @NoProfile

QueueDestroyGfxSampler :: (sampler : *GfxSampler) {
    collector := *g_gfx_context.sampler_collectors[g_gfx_context.frame_in_flight];
    AddGarbage(collector, sampler);
    sampler.* = .{};
} @Public @NoProfile
