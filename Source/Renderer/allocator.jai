// Thread safe, lock free frame data allocator
Frame_Data_Capacity :: 10 * 1024 * 1024;

FrameDataAllocator :: struct {
    buffer : GfxBuffer;
    mapped_ptr : *void;
    capacity : u64;
    current_offset : u64;
}

g_frame_data_allocators : [Gfx_Num_Frames_In_Flight]FrameDataAllocator;

InitFrameDataAllocator :: (allocator : *FrameDataAllocator, name : string, capacity : u64) -> bool {
    desc : GfxBufferDesc;
    desc.size = capacity;
    desc.usage = .VertexBuffer | .IndexBuffer | .UniformBuffer | .StorageBuffer | .TransferSrc | .TransferDst;
    desc.memory_usage = .Upload;

    allocator.buffer = CreateGfxBuffer(name, desc);
    if IsNull(*allocator.buffer) {
        return false;
    }

    alloc_info : VmaAllocationInfo;
    vmaGetAllocationInfo(g_gfx_context.allocator, allocator.buffer.allocation, *alloc_info);

    allocator.mapped_ptr = alloc_info.pMappedData;
    if !allocator.mapped_ptr {
        DestroyGfxBuffer(*allocator.buffer);
        return false;
    }

    allocator.capacity = capacity;
    allocator.current_offset = 0;

    return true;
}

DestroyFrameDataAllocator :: (allocator : *FrameDataAllocator) {
    DestroyGfxBuffer(*allocator.buffer);
    allocator.* = .{};
}

InitFrameDataAllocators :: () {
    for * g_frame_data_allocators {
        ok := InitFrameDataAllocator(it, TPrint("Frame Data %", it_index), Frame_Data_Capacity);
        Assert(ok, "Could not initialize frame data allocator");
    }
}

FrameDataBuffer :: () -> *GfxBuffer {
    using allocator := *g_frame_data_allocators[g_gfx_context.frame_in_flight];

    return *buffer;
}

ResetFrameDataAllocator :: () {
    using allocator := *g_frame_data_allocators[g_gfx_context.frame_in_flight];

    current_offset = 0;
}

AllocAndPackUniformFrameData :: (data : $T) -> offset : u64, size : u64
#modify { return (cast(*Type_Info) T).type == .STRUCT; }
{
    size : u64 = xx GLSLStd140Size(T);

    offset, ptr := AllocFrameData(size);
    PackToGLSLStd(data, ptr, .Std140);

    return offset, size;
}

AllocAndPackUniformFrameData :: (data : []$T) -> offset : u64, size : u64 {
    array_stride : s64 = xx GLSLStd140Size(T);
    size : u64 = xx (data.count * array_stride);

    offset, ptr := AllocFrameData(size);
    PackToGLSLStd(data, ptr, .Std140);

    return offset, size;
}

AllocAndPackStorageFrameData :: (data : $T) -> offset : u64, size : u64
#modify { return cast(*Type_Info, T).type == .STRUCT; }
{
    size : u64 = xx GLSLStd430Size(T);

    offset, ptr := AllocFrameData(size);
    PackToGLSLStd(data, ptr, .Std430);

    return offset, size;
}

AllocAndPackStorageFrameData :: (data : []$T) -> offset : u64, size : u64 {
    array_stride : s64 = xx GLSLStd430Size(T);
    size : u64 = xx (data.count * array_stride);

    offset, ptr := AllocFrameData(size);
    PackToGLSLStd(data, ptr, .Std430);

    return offset, size;
}

AllocFrameData :: (size : u64) -> offset : u64, ptr : *void {
    #import "Atomics";

    using allocator := *g_frame_data_allocators[g_gfx_context.frame_in_flight];

    limits := GetGfxLimits();
    alignment := Max(limits.uniform_buffer_offset_alignment, limits.storage_buffer_offset_alignment);
    aligned_size := AlignForward(size, alignment);
    offset := atomic_add(*current_offset, aligned_size);
    Assert(offset + aligned_size <= capacity, "Reached frame buffer limit (requested % bytes, capacity is % bytes out of % bytes)", size, capacity - offset, capacity);

    ptr := mapped_ptr + offset;

    return offset, ptr;
}
