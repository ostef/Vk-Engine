// #placeholder Shader_Binding_Set_Types;

EmptyBindingSet :: struct {
} @BindingSet

IsInShaderBindingSetTypesArray :: (type : Type) -> bool {
    return ArrayFindFirst(Shader_Binding_Set_Types, type) != -1;
}

g_binding_set_layouts : struct {
    #insert -> string {
        builder : StringBuilder;

        for Shader_Binding_Set_Types {
            Appendln(*builder, "%1 : GfxBindingSetLayout;", it);
        }

        return StringBuilderBuild(*builder);
    }
}

CreateAllBindingSetLayouts :: () {
    #insert -> string {
        builder : StringBuilder;

        for Shader_Binding_Set_Types {
            Appendln(*builder, "g_binding_set_layouts.%1 = CreateGfxBindingSetLayout(%1);", it);
            Appendln(*builder, "Assert(!IsNull(*g_binding_set_layouts.%1), \"Could not create shader binding set layout for type %1\");", it);
        }

        return StringBuilderBuild(*builder);
    }
}

DestroyAllBindingSetLayouts :: () {
    #insert -> string {
        builder : StringBuilder;

        for Shader_Binding_Set_Types {
            Appendln(*builder, "DestroyGfxBindingSetLayout(*g_binding_set_layouts.%1);", it);
        }

        return StringBuilderBuild(*builder);
    }
}

BindingSetAllocator :: struct {
    name : string;
    base_pool_desc : GfxBindingPoolDesc;
    new_pool_desc : GfxBindingPoolDesc;
    pools : [..]GfxBindingPool;
    current_pool_index : int;
}

MakeGfxBindingPoolDesc :: (layout : *GfxBindingSetLayout, max_binding_sets : u32) -> GfxBindingPoolDesc {
    desc : GfxBindingPoolDesc;
    desc.max_binding_sets = max_binding_sets;

    for layout.desc.bindings {
        if #complete it.type == {
        case .UniformBuffer; desc.max_uniform_buffers += it.num_array_layers;
        case .StorageBuffer; desc.max_storage_buffers += it.num_array_layers;
        case .Texture; desc.max_textures += it.num_array_layers;
        case .Sampler; desc.max_samplers += it.num_array_layers;
        case .CombinedTextureSampler; desc.max_combined_texture_samplers += it.num_array_layers;
        case .StorageImage; desc.max_storage_images += it.num_array_layers;
        }
    }

    desc.max_uniform_buffers *= max_binding_sets;
    desc.max_storage_buffers *= max_binding_sets;
    desc.max_textures *= max_binding_sets;
    desc.max_samplers *= max_binding_sets;
    desc.max_combined_texture_samplers *= max_binding_sets;
    desc.max_storage_images *= max_binding_sets;

    return desc;
}

MakeGfxBindingPoolDesc :: ($T : Type, max_binding_sets : u32) -> GfxBindingPoolDesc
#modify { return IsInShaderBindingSetTypesArray(T), TPrint("Type % is not in Shader_Binding_Set_Types array", T); } {
    layout := #insert #run TPrint("*g_binding_set_layouts.%;", T);

    return MakeGfxBindingPoolDesc(layout, max_binding_sets);
}

InitBindingSetAllocator :: (allocator : *BindingSetAllocator, name : string, base_pool_desc : GfxBindingPoolDesc, new_pool_desc : GfxBindingPoolDesc) -> bool {
    allocator.base_pool_desc = base_pool_desc;
    allocator.new_pool_desc = new_pool_desc;

    return InitBindingSetAllocator(allocator, name);
}

InitBindingSetAllocator :: (allocator : *BindingSetAllocator, name : string) -> bool {
    Assert(allocator.base_pool_desc.max_binding_sets > 0);

    pool := CreateGfxBindingPool(TPrint("%, base pool", name), allocator.base_pool_desc);
    if IsNull(*pool) {
        return false;
    }

    ArrayPush(*allocator.pools, pool);

    allocator.name = StringClone(name);
    allocator.current_pool_index = 0;

    return true;
}

DestroyBindingSetAllocator :: (using allocator : *BindingSetAllocator) {
    while pools.count > 0 {
        DestroyGfxBindingPool(*pools[pools.count - 1]);
        ArrayPop(*pools);
    }

    ArrayFree(*pools);

    Free(name.data);

    allocator.* = .{};
}

DestroyAdditionalPools :: (using allocator : *BindingSetAllocator) {
    while pools.count > 1 {
        DestroyGfxBindingPool(*pools[pools.count - 1]);
        ArrayPop(*pools);
    }

    current_pool_index = 0;
}

ResetBindingSetAllocator :: (using allocator : *BindingSetAllocator) {
    for * pools {
        ResetGfxBindingPool(it);
    }

    current_pool_index = 0;
}

AddPool :: (using allocator : *BindingSetAllocator) -> bool {
    if allocator.new_pool_desc.max_binding_sets == 0 {
        return false;
    }

    pool := CreateGfxBindingPool(TPrint("%, pool %", name, pools.count), new_pool_desc);
    if IsNull(*pool) {
        return false;
    }

    ArrayPush(*pools, pool);

    current_pool_index = pools.count - 1;

    return true;
}

GetCurrentPool :: (using allocator : *BindingSetAllocator) -> *GfxBindingPool {
    Assert(pools.count > 0, "No pool, allocator has not been initialized");

    return *pools[current_pool_index];
}

BindingSetAllocatorResult :: enum {
    Success           :: GfxBindingPoolAllocResult.Success;
    OutOfPoolMemory   :: GfxBindingPoolAllocResult.OutOfPoolMemory;
    OutOfDeviceMemory :: GfxBindingPoolAllocResult.OutOfDeviceMemory;
    OutOfHostMemory   :: GfxBindingPoolAllocResult.OutOfHostMemory;
    FragmentedPool    :: GfxBindingPoolAllocResult.FragmentedPool;
    UnknownError      :: GfxBindingPoolAllocResult.UnknownError;

    AdditionalPoolAllocationForbidden;
}

AllocGfxBindingSet :: inline (allocator : *BindingSetAllocator, $T : Type) -> GfxBindingSet, BindingSetAllocatorResult
#modify { return IsInShaderBindingSetTypesArray(T), TPrint("Type % is not in Shader_Binding_Set_Types array", T); } {
    layout := #insert #run TPrint("*g_binding_set_layouts.%;", T);
    set, result := AllocGfxBindingSet(allocator, layout);

    return set, result;
}

AllocGfxBindingSet :: (allocator : *BindingSetAllocator, layout : *GfxBindingSetLayout) -> GfxBindingSet, BindingSetAllocatorResult {
    pool := GetCurrentPool(allocator);
    set, result := AllocGfxBindingSet(pool, layout);

    if result == .FragmentedPool || result == .OutOfPoolMemory {
        if !AddPool(allocator) {
            return .{}, .AdditionalPoolAllocationForbidden;
        }

        pool = GetCurrentPool(allocator);
        set, result = AllocGfxBindingSet(pool, layout);
    }

    if result != .Success {
        return .{}, xx result;
    }

    return set, .Success;
}

CreateGfxBindingSet :: (allocator : *BindingSetAllocator, bindings : $T) -> GfxBindingSet, BindingSetAllocatorResult
#modify { return IsInShaderBindingSetTypesArray(T), TPrint("Type % is not in Shader_Binding_Set_Types array", T); } {
    set, result := AllocGfxBindingSet(allocator, T);
    if IsNull(*set) {
        return set, result;
    }

    UpdateGfxBindingSet(*set, bindings);

    return set, result;
}

// For per frame or per render pass binding sets, not supposed to allocate many binding sets
g_global_binding_set_allocators : [Gfx_Num_Frames_In_Flight]BindingSetAllocator;

GlobalBindingSetAllocator :: inline () -> *BindingSetAllocator {
    return *g_global_binding_set_allocators[GetFrameInFlight()];
}

// Specific allocator for MeshBindingSet layout
g_mesh_binding_set_allocators : [Gfx_Num_Frames_In_Flight]BindingSetAllocator;

MeshBindingSetAllocator :: inline () -> *BindingSetAllocator {
    return *g_mesh_binding_set_allocators[GetFrameInFlight()];
}

InitBindingSetAllocators :: () {
    for * g_global_binding_set_allocators {
        it.base_pool_desc = .{
            max_binding_sets=200,
            max_uniform_buffers=100,
            max_storage_buffers=100,
            max_textures=100,
            max_samplers=100,
            max_combined_texture_samplers=100,
            max_storage_images=100,
        };

        if !InitBindingSetAllocator(it, TPrint("Global binding set allocator, frame in flight %", it_index)) {
            Panic("Could not create global binding set allocator");
        }
    }

    for * g_mesh_binding_set_allocators {
        it.base_pool_desc = MakeGfxBindingPoolDesc(MeshBindingSet, 1000);
        it.new_pool_desc = MakeGfxBindingPoolDesc(MeshBindingSet, 100);

        if !InitBindingSetAllocator(it, TPrint("Mesh binding set allocator, frame in flight %", it_index)) {
            Panic("Could not create MeshBindingSet allocator");
        }
    }
}

DestroyBindingSetAllocators :: () {
    for * g_global_binding_set_allocators {
        DestroyBindingSetAllocator(it);
    }
    for * g_mesh_binding_set_allocators {
        DestroyBindingSetAllocator(it);
    }
}

ResetBindingSetAllocators :: () {
    ResetBindingSetAllocator(*g_global_binding_set_allocators[GetFrameInFlight()]);
    ResetBindingSetAllocator(*g_mesh_binding_set_allocators[GetFrameInFlight()]);
}
