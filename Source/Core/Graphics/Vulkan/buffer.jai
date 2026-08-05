CreateGfxBuffer :: (name : string, desc : GfxBufferDesc) -> GfxBuffer {
    LogSectionScope(*Log_Vulkan);

    buffer_info : VkBufferCreateInfo;
    buffer_info.size = desc.size;
    if desc.usage & .TransferSrc {
        buffer_info.usage |= .TRANSFER_SRC_BIT;
    }
    if desc.usage & .TransferDst {
        buffer_info.usage |= .TRANSFER_DST_BIT;
    }
    if desc.usage & .UniformBuffer {
        buffer_info.usage |= .UNIFORM_BUFFER_BIT;
    }
    if desc.usage & .StorageBuffer {
        buffer_info.usage |= .STORAGE_BUFFER_BIT;
    }
    if desc.usage & .IndexBuffer {
        buffer_info.usage |= .INDEX_BUFFER_BIT;
    }
    if desc.usage & .VertexBuffer {
        buffer_info.usage |= .VERTEX_BUFFER_BIT;
    }
    buffer_info.sharingMode = .EXCLUSIVE;
    buffer_info.queueFamilyIndexCount = 1;
    buffer_info.pQueueFamilyIndices = *g_gfx_context.general_purpose_queue_index;

    alloc_info : VmaAllocationCreateInfo;
    alloc_info.usage = .AUTO;
    if #complete desc.memory_usage == {
    case .GPUOnly;
        alloc_info.flags = .DEDICATED_MEMORY_BIT;
    case .Upload;
        alloc_info.flags = .HOST_ACCESS_SEQUENTIAL_WRITE_BIT | .MAPPED_BIT;
    case .Readback;
        alloc_info.flags = .HOST_ACCESS_RANDOM_BIT | .MAPPED_BIT;
    }

    buffer : VkBuffer;
    allocation : VmaAllocation;
    if vmaCreateBuffer(g_gfx_context.allocator, *buffer_info, *alloc_info, *buffer, *allocation, null) != .SUCCESS {
        return .{};
    }

    SetDebugName(buffer, TPrint("Buffer '%'", name));

    return .{buffer=buffer, allocation=allocation, name=StringClone(name), desc=desc};
} @Public @NoProfile

DestroyGfxBuffer :: (buffer : *GfxBuffer) {
    LogSectionScope(*Log_Vulkan);

    Free(buffer.name.data);
    vmaDestroyBuffer(g_gfx_context.allocator, buffer.buffer, buffer.allocation);
    buffer.* = .{};
} @Public @NoProfile

QueueDestroyGfxBuffer :: (buffer : *GfxBuffer) {
    collector := *g_gfx_context.buffer_collectors[g_gfx_context.frame_in_flight];
    AddGarbage(collector, buffer);
    buffer.* = .{};
} @Public @NoProfile

GetMappedPtr :: (buffer : *GfxBuffer) -> *void {
    if IsNull(buffer) {
        return null;
    }

    alloc_info : VmaAllocationInfo;
    vmaGetAllocationInfo(GetGfxContext().allocator, buffer.allocation, *alloc_info);

    return alloc_info.pMappedData;
} @Public @NoProfile
