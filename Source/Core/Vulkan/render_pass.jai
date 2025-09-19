BeginGfxRenderPass :: (cmd_buffer : *GfxCommandBuffer, name : string, desc : GfxRenderPassDesc) -> GfxRenderPass {
    LogSectionScope(*Log_Vulkan);

    w, h : u32;

    color_attachments : [Gfx_Max_Color_Attachments]VkRenderingAttachmentInfo;
    if desc.num_color_attachments > 0 {
        for i : 0..desc.num_color_attachments - 1 {
            Assert(!IsNull(desc.color_attachments[i].texture), "Color attachment % is null", i);

            w = desc.color_attachments[i].texture.desc.width;
            h = desc.color_attachments[i].texture.desc.height;

            color_attachments[i].imageView = desc.color_attachments[i].texture.image_view;
            color_attachments[i].imageLayout = .ATTACHMENT_OPTIMAL_KHR;

            if !IsNull(desc.color_attachments[i].resolve_texture) {
                color_attachments[i].resolveMode = .AVERAGE_BIT;
                color_attachments[i].resolveImageView = desc.color_attachments[i].resolve_texture.image_view;
                color_attachments[i].resolveImageLayout = .ATTACHMENT_OPTIMAL_KHR;
            }

            color_attachments[i].loadOp = MakeVkAttachmentLoadOp(desc.color_attachments[i].load_op);
            color_attachments[i].storeOp = MakeVkAttachmentStoreOp(desc.color_attachments[i].store_op);
            color_attachments[i].clearValue.color.int32[0] = desc.color_attachments[i].clear_value.int4[0];
            color_attachments[i].clearValue.color.int32[1] = desc.color_attachments[i].clear_value.int4[1];
            color_attachments[i].clearValue.color.int32[2] = desc.color_attachments[i].clear_value.int4[2];
            color_attachments[i].clearValue.color.int32[3] = desc.color_attachments[i].clear_value.int4[3];
        }
    }

    depth_attachment : VkRenderingAttachmentInfo;
    if !IsNull(desc.depth_attachment.texture) {
        w = desc.depth_attachment.texture.desc.width;
        h = desc.depth_attachment.texture.desc.height;

        depth_attachment.imageView = desc.depth_attachment.texture.image_view;
        depth_attachment.imageLayout = .ATTACHMENT_OPTIMAL_KHR;

        if !IsNull(desc.depth_attachment.resolve_texture) {
            depth_attachment.resolveMode = .AVERAGE_BIT;
            depth_attachment.resolveImageView = desc.depth_attachment.resolve_texture.image_view;
            depth_attachment.resolveImageLayout = .ATTACHMENT_OPTIMAL_KHR;
        }

        depth_attachment.loadOp = MakeVkAttachmentLoadOp(desc.depth_attachment.load_op);
        depth_attachment.storeOp = MakeVkAttachmentStoreOp(desc.depth_attachment.store_op);
        depth_attachment.clearValue.depthStencil.depth = desc.depth_attachment.clear_value;
    }

    stencil_attachment : VkRenderingAttachmentInfo;
    if !IsNull(desc.stencil_attachment.texture) {
        w = desc.stencil_attachment.texture.desc.width;
        h = desc.stencil_attachment.texture.desc.height;

        stencil_attachment.imageView = desc.stencil_attachment.texture.image_view;
        stencil_attachment.imageLayout = .ATTACHMENT_OPTIMAL_KHR;

        if !IsNull(desc.stencil_attachment.resolve_texture) {
            stencil_attachment.resolveMode = .AVERAGE_BIT;
            stencil_attachment.resolveImageView = desc.stencil_attachment.resolve_texture.image_view;
            stencil_attachment.resolveImageLayout = .ATTACHMENT_OPTIMAL_KHR;
        }

        stencil_attachment.loadOp = MakeVkAttachmentLoadOp(desc.stencil_attachment.load_op);
        stencil_attachment.storeOp = MakeVkAttachmentStoreOp(desc.stencil_attachment.store_op);
        stencil_attachment.clearValue.depthStencil.stencil = desc.stencil_attachment.clear_value;
    }

    render_info : VkRenderingInfo;
    render_info.layerCount = desc.num_layers;
    render_info.colorAttachmentCount = desc.num_color_attachments;
    render_info.pColorAttachments = color_attachments.data;
    render_info.pDepthAttachment = ifx !IsNull(desc.depth_attachment.texture) then *depth_attachment;
    render_info.pStencilAttachment = ifx !IsNull(desc.stencil_attachment.texture) then *stencil_attachment;
    render_info.renderArea.extent = .{width=xx w, height=xx h};

    BeginGfxDebugMarker(cmd_buffer, name);
    profiling_event := ProfilerBeginEvent(cmd_buffer, *g_gpu_profiler, name);
    vkCmdBeginRendering(cmd_buffer.cmd_buffer, *render_info);

    g_gfx_context.frame_statistics.num_render_passes += 1;

    return .{cmd_buffer=cmd_buffer, profiling_event=profiling_event, name=name, desc=desc};
} @ModuleAPI

EndGfxRenderPass :: (pass : *GfxRenderPass) {
    LogSectionScope(*Log_Vulkan);

    vkCmdEndRendering(pass.cmd_buffer.cmd_buffer);
    ProfilerEndEvent(pass.cmd_buffer, *g_gpu_profiler, pass.profiling_event);
    EndGfxDebugMarker(pass.cmd_buffer);

    AddBarrier(pass.cmd_buffer);
} @ModuleAPI

BindGraphicsPipeline :: (pass : *GfxRenderPass, pipeline : *GfxGraphicsPipeline) {
    if pass.current_pipeline == pipeline {
        return;
    }

    pass.current_pipeline = pipeline;
    vkCmdBindPipeline(pass.cmd_buffer.cmd_buffer, .GRAPHICS, pipeline.pipeline);

    g_gfx_context.frame_statistics.num_graphics_pipeline_binds += 1;
} @ModuleAPI @NoProfile

BindGraphicsBindingSet :: (pass : *GfxRenderPass, index : u32, set : *GfxBindingSet) {
    Assert(pass.current_pipeline != null, "Render pass has no pipeline bound yet. Use BindGraphicsBindingSet on a command buffer and specify pipeline layout or bind a pipeline first");

    BindGraphicsBindingSet(pass.cmd_buffer, *pass.current_pipeline.layout, index, set);
} @ModuleAPI @NoProfile

SetViewport :: (pass : *GfxRenderPass, viewport : GfxViewport) {
    vk_viewport := VkViewport.{x=viewport.top_left_x, y=viewport.top_left_y, width=viewport.width, height=viewport.height, minDepth=viewport.min_depth, maxDepth=viewport.max_depth};
    vkCmdSetViewport(pass.cmd_buffer.cmd_buffer, 0, 1, *vk_viewport);
} @ModuleAPI @NoProfile

SetScissor :: (pass : *GfxRenderPass, rect : Recti) {
    vk_scissor := VkRect2D.{offset=.{rect.x, rect.y}, extent=.{xx rect.w, xx rect.h}};
    vkCmdSetScissor(pass.cmd_buffer.cmd_buffer, 0, 1, *vk_scissor);
} @ModuleAPI @NoProfile

SetStencilReference :: (pass : *GfxRenderPass, front_value : u32, back_value : u32) {
    vkCmdSetStencilReference(pass.cmd_buffer.cmd_buffer, .FACE_FRONT_BIT, front_value);
    vkCmdSetStencilReference(pass.cmd_buffer.cmd_buffer, .FACE_BACK_BIT, back_value);
} @ModuleAPI @NoProfile

SetBlendConstant :: (pass : *GfxRenderPass, color : Vec4f) {
    vkCmdSetBlendConstants(pass.cmd_buffer.cmd_buffer, xx *color);
} @ModuleAPI @NoProfile

BindVertexBuffer :: (pass : *GfxRenderPass, binding : u32, buffer : *GfxBuffer, offset : u64 = 0) {
    vkCmdBindVertexBuffers(pass.cmd_buffer.cmd_buffer, binding, 1, *buffer.buffer, *offset);
} @ModuleAPI @NoProfile

BindGraphicsBindingSet :: (cmd_buffer : *GfxCommandBuffer, layout : *GfxPipelineLayout, index : u32, set : *GfxBindingSet) {
    vkCmdBindDescriptorSets(cmd_buffer.cmd_buffer, .GRAPHICS, layout.layout, index, 1, *set.set, 0, null);
    g_gfx_context.frame_statistics.num_graphics_binding_set_binds += 1;
} @ModuleAPI @NoProfile

BindComputeBindingSet :: (cmd_buffer : *GfxCommandBuffer, layout : *GfxPipelineLayout, index : u32, set : *GfxBindingSet) {
    vkCmdBindDescriptorSets(cmd_buffer.cmd_buffer, .COMPUTE, layout.layout, index, 1, *set.set, 0, null);
    g_gfx_context.frame_statistics.num_compute_binding_set_binds += 1;
} @ModuleAPI @NoProfile

BindIndexBuffer :: (pass : *GfxRenderPass, type : GfxIndexType, buffer : *GfxBuffer, offset : u64 = 0) {
    vk_index_type : VkIndexType;
    if #complete type == {
    case .UInt16; vk_index_type = .UINT16;
    case .UInt32; vk_index_type = .UINT32;
    }

    vkCmdBindIndexBuffer(pass.cmd_buffer.cmd_buffer, buffer.buffer, offset, vk_index_type);
} @ModuleAPI @NoProfile

Draw :: (
    pass : *GfxRenderPass,
    vertex_count : u32,
    instance_count : u32,
    base_vertex : u32 = 0,
    base_instance : u32 = 0
) {
    vkCmdDraw(pass.cmd_buffer.cmd_buffer, vertex_count, instance_count, base_vertex, base_instance);
    g_gfx_context.frame_statistics.num_draw_calls += 1;
} @ModuleAPI @NoProfile

DrawIndexed :: (
    pass : *GfxRenderPass,
    index_count : u32,
    instance_count : u32,
    base_index : u32 = 0,
    base_vertex : u32 = 0,
    base_instance : u32 = 0
) {
    vkCmdDrawIndexed(pass.cmd_buffer.cmd_buffer, index_count, instance_count, base_index, xx base_vertex, base_instance);
    g_gfx_context.frame_statistics.num_draw_calls += 1;
} @ModuleAPI @NoProfile
