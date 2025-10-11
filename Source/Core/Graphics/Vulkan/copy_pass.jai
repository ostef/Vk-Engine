BeginGfxCopyPass :: (cmd_buffer : *GfxCommandBuffer, name : string, location := #caller_location) -> GfxCopyPass {
    LogSectionScope(*Log_Vulkan);

    BeginGfxDebugMarker(cmd_buffer, name);
    profiling_event := ProfilerBeginEvent(cmd_buffer, *g_gpu_frame_profiler, name, location);

    return .{cmd_buffer=cmd_buffer, profiling_event=profiling_event, name=name};
} @ModuleAPI @NoProfile

EndGfxCopyPass :: (pass : *GfxCopyPass) {
    LogSectionScope(*Log_Vulkan);

    ProfilerEndEvent(pass.cmd_buffer, *g_gpu_frame_profiler, pass.profiling_event);
    EndGfxDebugMarker(pass.cmd_buffer);

    AddBarrier(pass.cmd_buffer);
} @ModuleAPI @NoProfile

CopyBufferToTexture :: (pass : *GfxCopyPass, src_buffer : *GfxBuffer, dst_texture : *GfxTexture) {
    copy : VkBufferImageCopy;
    copy.imageSubresource = MakeVkImageSubresourceLayers(dst_texture.desc, 0);
    copy.imageExtent = .{dst_texture.desc.width, dst_texture.desc.height, dst_texture.desc.depth};

    vkCmdCopyBufferToImage(pass.cmd_buffer.cmd_buffer, src_buffer.buffer, dst_texture.image, .TRANSFER_DST_OPTIMAL, 1, *copy);
} @ModuleAPI @NoProfile

CopyTextureToBuffer :: (pass : *GfxCopyPass, src_texture : *GfxTexture, dst_buffer : *GfxBuffer) {
    copy : VkBufferImageCopy;
    copy.imageSubresource = MakeVkImageSubresourceLayers(src_texture.desc, 0);
    copy.imageExtent = .{src_texture.desc.width, src_texture.desc.height, src_texture.desc.depth};

    vkCmdCopyImageToBuffer(pass.cmd_buffer.cmd_buffer, src_texture.image, .TRANSFER_SRC_OPTIMAL, dst_buffer.buffer, 1, *copy);
} @ModuleAPI @NoProfile

CopyBufferToBuffer :: (pass : *GfxCopyPass, src_buffer : *GfxBuffer, dst_buffer : *GfxBuffer, src_offset : u64, dst_offset : u64, size : u64) {
    region : VkBufferCopy;
    region.srcOffset = src_offset;
    region.dstOffset = dst_offset;
    region.size = size;

    vkCmdCopyBuffer(pass.cmd_buffer.cmd_buffer, src_buffer.buffer, dst_buffer.buffer, 1, *region);
} @ModuleAPI @NoProfile

GenerateMipmaps :: (pass : *GfxCopyPass, texture : *GfxTexture, old_layout : GfxTextureLayout, new_layout : GfxTextureLayout) {
    if texture.desc.num_mipmap_levels < 2 {
        AddTextureBarrier(pass.cmd_buffer, old_layout, new_layout, texture);
        return;
    }

    src_mip_width := cast(s32, texture.desc.width);
    src_mip_height := cast(s32, texture.desc.height);
    for i : 0..texture.desc.num_mipmap_levels - 2 {
        source_old_layout := ifx i == 0 then old_layout else .TransferDst;

        barriers : [2]VkImageMemoryBarrier;
        barriers[0].srcAccessMask = MakeVkAccessFlags(.AllWrites | .AllReads);
        barriers[0].dstAccessMask = MakeVkAccessFlags(.AllWrites | .AllReads);
        barriers[0].oldLayout = MakeVkImageLayout(source_old_layout);
        barriers[0].newLayout = MakeVkImageLayout(.TransferSrc);
        barriers[0].srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
        barriers[0].dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
        barriers[0].image = texture.image;
        barriers[0].subresourceRange = MakeVkImageSubresourceRange(texture.desc);
        barriers[0].subresourceRange.baseMipLevel = i;
        barriers[0].subresourceRange.levelCount = 1;

        barriers[1].srcAccessMask = MakeVkAccessFlags(.AllWrites | .AllReads);
        barriers[1].dstAccessMask = MakeVkAccessFlags(.AllWrites | .AllReads);
        barriers[1].oldLayout = MakeVkImageLayout(.Undefined);
        barriers[1].newLayout = MakeVkImageLayout(.TransferDst);
        barriers[1].srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
        barriers[1].dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
        barriers[1].image = texture.image;
        barriers[1].subresourceRange = MakeVkImageSubresourceRange(texture.desc);
        barriers[1].subresourceRange.baseMipLevel = i + 1;
        barriers[1].subresourceRange.levelCount = 1;

        src_stages := MakeVkPipelineStageFlags(ifx i == 0 then .AllCommands else .AllTransfer);
        dst_stages := MakeVkPipelineStageFlags(.AllTransfer);
        vkCmdPipelineBarrier(
            pass.cmd_buffer.cmd_buffer,
            src_stages, dst_stages,
            dependencyFlags=0,
            memoryBarrierCount=0, pMemoryBarriers=null,
            bufferMemoryBarrierCount=0, pBufferMemoryBarriers=null,
            imageMemoryBarrierCount=xx barriers.count, pImageMemoryBarriers=barriers.data,
        );

        blit : VkImageBlit;
        blit.srcSubresource = MakeVkImageSubresourceLayers(texture.desc, i);
        blit.dstSubresource = MakeVkImageSubresourceLayers(texture.desc, i + 1);
        blit.srcOffsets[1] = .{src_mip_width, src_mip_height, 1};
        blit.dstOffsets[1] = .{Max(src_mip_width / 2, 1), Max(src_mip_height / 2, 1), 1};

        vkCmdBlitImage(pass.cmd_buffer.cmd_buffer, texture.image, .TRANSFER_SRC_OPTIMAL, texture.image, .TRANSFER_DST_OPTIMAL, 1, *blit, .LINEAR);

        src_mip_width /= 2;
        src_mip_height /= 2;
    }

    // Transition all mipmap levels to new layout
    barriers : [2]VkImageMemoryBarrier;
    barriers[0].srcAccessMask = MakeVkAccessFlags(.AllWrites | .AllReads);
    barriers[0].dstAccessMask = MakeVkAccessFlags(.AllWrites | .AllReads);
    barriers[0].oldLayout = MakeVkImageLayout(.TransferSrc);
    barriers[0].newLayout = MakeVkImageLayout(new_layout);
    barriers[0].srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    barriers[0].dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    barriers[0].image = texture.image;
    barriers[0].subresourceRange = MakeVkImageSubresourceRange(texture.desc);
    barriers[0].subresourceRange.baseMipLevel = 0;
    barriers[0].subresourceRange.levelCount = texture.desc.num_mipmap_levels - 1;

    barriers[1].srcAccessMask = MakeVkAccessFlags(.AllWrites | .AllReads);
    barriers[1].dstAccessMask = MakeVkAccessFlags(.AllWrites | .AllReads);
    barriers[1].oldLayout = MakeVkImageLayout(.TransferDst);
    barriers[1].newLayout = MakeVkImageLayout(new_layout);
    barriers[1].srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    barriers[1].dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    barriers[1].image = texture.image;
    barriers[1].subresourceRange = MakeVkImageSubresourceRange(texture.desc);
    barriers[1].subresourceRange.baseMipLevel = texture.desc.num_mipmap_levels - 1;
    barriers[1].subresourceRange.levelCount = 1;

    src_stages := MakeVkPipelineStageFlags(.AllTransfer);
    dst_stages := MakeVkPipelineStageFlags(.AllCommands);
    vkCmdPipelineBarrier(
        pass.cmd_buffer.cmd_buffer,
        src_stages, dst_stages,
        dependencyFlags=0,
        memoryBarrierCount=0, pMemoryBarriers=null,
        bufferMemoryBarrierCount=0, pBufferMemoryBarriers=null,
        imageMemoryBarrierCount=xx barriers.count, pImageMemoryBarriers=barriers.data,
    );
} @ModuleAPI
