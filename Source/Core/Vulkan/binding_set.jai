CreateGfxBindingSetLayout :: (name : string, desc : GfxBindingSetLayoutDesc) -> GfxBindingSetLayout {
    LogSectionScope(*Log_Vulkan);

    create_info : VkDescriptorSetLayoutCreateInfo;
    create_info.bindingCount = xx desc.bindings.count;
    create_info.pBindings = Alloc(VkDescriptorSetLayoutBinding, desc.bindings.count, initialize=true ,, Temp);

    binding_flags : VkDescriptorSetLayoutBindingFlagsCreateInfo;
    binding_flags.bindingCount = xx desc.bindings.count;
    binding_flags.pBindingFlags = Alloc(VkDescriptorBindingFlags, desc.bindings.count, initialize=true ,, Temp);

    create_info.pNext = *binding_flags;

    for desc.bindings {
        binding := *create_info.pBindings[it_index];
        binding.binding = it.binding;
        binding.descriptorType = MakeVkDescriptorType(it.type);
        binding.descriptorCount = it.num_array_layers;
        binding.stageFlags = MakeVkShaderStageFlags(it.stage_flags);

        binding_flags.pBindingFlags[it_index] = MakeVkDescriptorBindingFlags(it.flags);
    }

    layout : VkDescriptorSetLayout;
    if vkCreateDescriptorSetLayout(g_gfx_context.device, *create_info, g_vk_alloc_callbacks, *layout) != .SUCCESS {
        return .{};
    }

    SetDebugName(layout, TPrint("Descriptor Set Layout '%'", name));

    copied_desc := desc;
    copied_desc.bindings = ArrayClone(desc.bindings);

    return .{layout=layout, name=StringClone(name), desc=copied_desc};
} @ModuleAPI

DestroyGfxBindingSetLayout :: (layout : *GfxBindingSetLayout) {
    LogSectionScope(*Log_Vulkan);

    Free(layout.name.data);
    Free(layout.desc.bindings.data);
    vkDestroyDescriptorSetLayout(g_gfx_context.device, layout.layout, g_vk_alloc_callbacks);
    layout.* = .{};
} @ModuleAPI

CreateGfxBindingPool :: (name : string, desc : GfxBindingPoolDesc) -> GfxBindingPool {
    pool_sizes : [..]VkDescriptorPoolSize;
    pool_sizes.allocator = Temp;

    if desc.max_uniform_buffers > 0 {
        ArrayPush(*pool_sizes, .{type=.UNIFORM_BUFFER, descriptorCount=desc.max_uniform_buffers});
    }
    if desc.max_storage_buffers > 0 {
        ArrayPush(*pool_sizes, .{type=.STORAGE_BUFFER, descriptorCount=desc.max_storage_buffers});
    }
    if desc.max_textures > 0 {
        ArrayPush(*pool_sizes, .{type=.SAMPLED_IMAGE, descriptorCount=desc.max_textures});
    }
    if desc.max_samplers > 0 {
        ArrayPush(*pool_sizes, .{type=.SAMPLER, descriptorCount=desc.max_samplers});
    }
    if desc.max_combined_texture_samplers > 0 {
        ArrayPush(*pool_sizes, .{type=.COMBINED_IMAGE_SAMPLER, descriptorCount=desc.max_combined_texture_samplers});
    }
    if desc.max_storage_images > 0 {
        ArrayPush(*pool_sizes, .{type=.STORAGE_IMAGE, descriptorCount=desc.max_storage_images});
    }

    info : VkDescriptorPoolCreateInfo;
    info.maxSets = desc.max_binding_sets;
    info.poolSizeCount = xx pool_sizes.count;
    info.pPoolSizes = pool_sizes.data;

    pool : VkDescriptorPool;
    if vkCreateDescriptorPool(g_gfx_context.device, *info, g_vk_alloc_callbacks, *pool) != .SUCCESS {
        return .{};
    }

    SetDebugName(pool, TPrint("Descriptor Pool '%'", name));

    return .{pool=pool};
} @ModuleAPI

DestroyGfxBindingPool :: (pool : *GfxBindingPool) {
    vkDestroyDescriptorPool(g_gfx_context.device, pool.pool, g_vk_alloc_callbacks);
    pool.* = .{};
} @ModuleAPI

ResetGfxBindingPool :: (pool : *GfxBindingPool) {
    vkResetDescriptorPool(g_gfx_context.device, pool.pool, 0);
} @ModuleAPI

AllocGfxBindingSet :: (pool : *GfxBindingPool, layout : *GfxBindingSetLayout) -> GfxBindingSet, GfxBindingPoolAllocResult {
    info : VkDescriptorSetAllocateInfo;
    info.descriptorPool = pool.pool;
    info.descriptorSetCount = 1;
    info.pSetLayouts = *layout.layout;

    set : VkDescriptorSet;
    result := vkAllocateDescriptorSets(g_gfx_context.device, *info, *set);
    if result != .SUCCESS {
        return .{}, MakeGfxBindingPoolAllocResult(result);
    }

    return .{set=set}, .Success;
} @ModuleAPI @NoProfile
