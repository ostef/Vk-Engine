AddBarrier :: (
    cmd_buffer : *GfxCommandBuffer,
    src_sync_points : GfxBarrierSyncPointFlags, dst_sync_points : GfxBarrierSyncPointFlags
) {
    src_stages := ifx src_sync_points != 0 then MakeVkPipelineStageFlags(src_sync_points) else .TOP_OF_PIPE_BIT;
    dst_stages := ifx dst_sync_points != 0 then MakeVkPipelineStageFlags(dst_sync_points) else .BOTTOM_OF_PIPE_BIT;
    vkCmdPipelineBarrier(
        cmd_buffer.cmd_buffer,
        src_stages, dst_stages,
        dependencyFlags=0,
        memoryBarrierCount=0, pMemoryBarriers=null,
        bufferMemoryBarrierCount=0, pBufferMemoryBarriers=null,
        imageMemoryBarrierCount=0, pImageMemoryBarriers=null,
    );

    g_gfx_context.frame_statistics.num_execution_barriers += 1;
} @NoProfile

AddBarrier :: inline (cmd_buffer : *GfxCommandBuffer) {
    AddBarrier(cmd_buffer, .AllCommands, .AllCommands);
} @ModuleAPI @NoProfile

AddMemoryBarrier :: (
    cmd_buffer : *GfxCommandBuffer,
    src_sync_points : GfxBarrierSyncPointFlags, src_accesses : GfxBarrierAccessFlags,
    dst_sync_points : GfxBarrierSyncPointFlags, dst_accesses : GfxBarrierAccessFlags
) {
    barrier : VkMemoryBarrier;
    barrier.srcAccessMask = MakeVkAccessFlags(src_accesses);
    barrier.dstAccessMask = MakeVkAccessFlags(dst_accesses);

    src_stages := ifx src_sync_points != 0 then MakeVkPipelineStageFlags(src_sync_points) else .TOP_OF_PIPE_BIT;
    dst_stages := ifx dst_sync_points != 0 then MakeVkPipelineStageFlags(dst_sync_points) else .BOTTOM_OF_PIPE_BIT;
    vkCmdPipelineBarrier(
        cmd_buffer.cmd_buffer,
        src_stages, dst_stages,
        dependencyFlags=0,
        memoryBarrierCount=1, pMemoryBarriers=*barrier,
        bufferMemoryBarrierCount=0, pBufferMemoryBarriers=null,
        imageMemoryBarrierCount=0, pImageMemoryBarriers=null,
    );

    g_gfx_context.frame_statistics.num_memory_barriers += 1;
} @ModuleAPI @NoProfile

AddTextureBarrier :: (
    cmd_buffer : *GfxCommandBuffer,
    src_sync_points : GfxBarrierSyncPointFlags, src_accesses : GfxBarrierAccessFlags,
    dst_sync_points : GfxBarrierSyncPointFlags, dst_accesses : GfxBarrierAccessFlags,
    old_layout : GfxTextureLayout, new_layout : GfxTextureLayout,
    texture : *GfxTexture
) {
    barrier : VkImageMemoryBarrier;
    barrier.srcAccessMask = MakeVkAccessFlags(src_accesses);
    barrier.dstAccessMask = MakeVkAccessFlags(dst_accesses);
    barrier.oldLayout = MakeVkImageLayout(old_layout);
    barrier.newLayout = MakeVkImageLayout(new_layout);
    barrier.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    barrier.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    barrier.image = texture.image;
    barrier.subresourceRange = MakeVkImageSubresourceRange(texture.desc);

    src_stages := ifx src_sync_points != 0 then MakeVkPipelineStageFlags(src_sync_points) else .TOP_OF_PIPE_BIT;
    dst_stages := ifx dst_sync_points != 0 then MakeVkPipelineStageFlags(dst_sync_points) else .BOTTOM_OF_PIPE_BIT;
    vkCmdPipelineBarrier(
        cmd_buffer.cmd_buffer,
        src_stages, dst_stages,
        dependencyFlags=0,
        memoryBarrierCount=0, pMemoryBarriers=null,
        bufferMemoryBarrierCount=0, pBufferMemoryBarriers=null,
        imageMemoryBarrierCount=1, pImageMemoryBarriers=*barrier,
    );

    g_gfx_context.frame_statistics.num_texture_barriers += 1;
} @ModuleAPI @NoProfile

AddTextureBarrier :: (
    cmd_buffer : *GfxCommandBuffer,
    old_layout : GfxTextureLayout, new_layout : GfxTextureLayout,
    texture : *GfxTexture
) {
    AddTextureBarrier(
        cmd_buffer,
        .AllCommands, .AllWrites | .AllReads, .AllCommands, .AllWrites | .AllReads, old_layout,
        new_layout,
        texture
    );
} @ModuleAPI @NoProfile

AddTextureBarriers :: (
    cmd_buffer : *GfxCommandBuffer,
    old_layout : GfxTextureLayout, new_layout : GfxTextureLayout,
    textures : []*GfxTexture
) {
    barriers := AllocArray(VkImageMemoryBarrier, textures.count ,, Temp);
    for textures {
        barriers[it_index].sType = .IMAGE_MEMORY_BARRIER;
        barriers[it_index].pNext = null;
        barriers[it_index].srcAccessMask = .MEMORY_READ_BIT | .MEMORY_WRITE_BIT;
        barriers[it_index].dstAccessMask = .MEMORY_READ_BIT | .MEMORY_WRITE_BIT;
        barriers[it_index].oldLayout = MakeVkImageLayout(old_layout);
        barriers[it_index].newLayout = MakeVkImageLayout(new_layout);
        barriers[it_index].srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
        barriers[it_index].dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
        barriers[it_index].image = it.image;
        barriers[it_index].subresourceRange = MakeVkImageSubresourceRange(it.desc);
    }

    src_stages := MakeVkPipelineStageFlags(.AllCommands);
    dst_stages := MakeVkPipelineStageFlags(.AllCommands);
    vkCmdPipelineBarrier(
        cmd_buffer.cmd_buffer,
        src_stages, dst_stages,
        dependencyFlags=0,
        memoryBarrierCount=0, pMemoryBarriers=null,
        bufferMemoryBarrierCount=0, pBufferMemoryBarriers=null,
        imageMemoryBarrierCount=xx barriers.count, pImageMemoryBarriers=barriers.data,
    );

    g_gfx_context.frame_statistics.num_texture_barriers += barriers.count;
} @ModuleAPI @NoProfile
