EntityIDPassBindingSet :: struct {
    viewpoints : GfxBindingUniformBuffer; @Binding(0) @VertexStage
} @BindingSet

g_entity_id_material_pass := MaterialRenderPass.{
    name="Entity ID",
    fragment_shader="ENTITY_ID",
    pipeline_template=.{
        num_color_attachments=1,
        color_formats[0]=.RGBA32UInt,
        depth_format=.Depth32Float,
        depth_state=.{test_enabled=true, write_enabled=true, compare_op=Depth_Compare_Op},
    },
};

EntityIDsPass :: (using ctx : *RenderContext, texture : *GfxTexture, depth_texture : *GfxTexture, mesh_buffer : *MeshBuffer) {
    if !g_entity_id_material_pass.initialized {
        InitMaterialRenderPass(*g_entity_id_material_pass, *g_binding_set_layouts.EntityIDPassBindingSet);
    }

    viewpoints : ViewpointsData;
    viewpoints.viewpoints[0] = MakeViewpoint(viewpoint);
    viewpoints_offset, viewpoints_size := AllocAndPackUniformFrameData(viewpoints);

    pass_bindings := EntityIDPassBindingSet.{
        viewpoints=.{buffer=FrameDataBuffer(), offset=xx viewpoints_offset, size=xx viewpoints_size},
    };

    binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), pass_bindings);

    w, h := viewpoint.resolution.x, viewpoint.resolution.y;

    pass_desc : GfxRenderPassDesc;
    AddColorAttachment(*pass_desc, texture);
    AddDepthAttachment(*pass_desc, depth_texture);
    ClearColor(*pass_desc, 0, Vec4u.{0,0,0,0});
    ClearDepth(*pass_desc, Depth_Clear);

    pass := BeginGfxRenderPass(cmd_buffer, "Entity ID", pass_desc);
    {
        SetViewport(*pass, .{width=xx w, height=xx h});
        SetScissor(*pass, .{w=xx w, h=xx h});

        BindGraphicsBindingSet(cmd_buffer, *g_entity_id_material_pass.pipeline_layout, 1, *binding_set);

        for mesh_buffer.draw_calls {
            pipeline := GetPipeline(*g_entity_id_material_pass, it);
            BindGraphicsPipeline(*pass, pipeline);

            BindGraphicsBindingSet(*pass, 2, *it.binding_set);
            BindVertexBuffer(*pass, 0, it.vertex_buffer);

            if it.index_buffer {
                BindIndexBuffer(*pass, .UInt32, it.index_buffer);
                DrawIndexed(*pass, it.index_count, it.instance_count);
            } else {
                Draw(*pass, it.vertex_count, it.instance_count);
            }
        }
    }
    EndGfxRenderPass(*pass);
}

TransferEntityIDsForReadback :: (using ctx : *RenderContext) {
    buffer := *render_targets.entity_ids_readback_buffers[GetGfxContext().frame_in_flight];
    if IsNull(buffer) || buffer.desc.size < size_of(UUID) * viewpoint.resolution.x * viewpoint.resolution.y {
        if !IsNull(buffer) {
            DestroyGfxBuffer(buffer);
        }

        desc : GfxBufferDesc;
        desc.size = size_of(UUID) * viewpoint.resolution.x * viewpoint.resolution.y;
        desc.usage = .TransferDst;
        desc.memory_usage = .Readback;

        buffer.* = CreateGfxBuffer(TPrint("Viewpoint %, Entity IDs Readback", viewpoint.unique_id), desc);
        Assert(!IsNull(buffer), "Could not create entity guids readback buffer");
    }

    pass := BeginGfxCopyPass(cmd_buffer, "Transfer Entity IDs for Readback");
    {
        CopyTextureToBuffer(*pass, *render_targets.entity_ids_texture, buffer);
    }
    EndGfxCopyPass(*pass);
}

RenderEntitySelection :: (using ctx : *RenderContext, mesh_buffer : *MeshBuffer, selected_mesh_buffer : *MeshBuffer) {
    EntityIDsPass(ctx, *render_targets.entity_ids_texture, *render_targets.depth_texture, mesh_buffer);
    EntityIDsPass(ctx, *render_targets.selected_entity_ids_texture, *render_targets.depth_texture, selected_mesh_buffer);

    AddTextureBarrier(cmd_buffer, .ColorAttachment, .TransferSrc, *render_targets.entity_ids_texture);
    TransferEntityIDsForReadback(ctx);
    AddTextureBarrier(cmd_buffer, .TransferSrc, .ShaderReadOnly, *render_targets.entity_ids_texture);
}
