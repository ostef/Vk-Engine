DepthOnlyPassBindingSet :: struct {
    viewpoints : GfxBindingUniformBuffer; @Binding(0) @VertexStage @FragmentStage
} @BindingSet

g_depth_only_material_pass := MaterialRenderPass.{
    name="Depth Prepass",
    fragment_shader="DEPTH_ONLY",
    pipeline_template=.{
        depth_format=.Depth32Float,
        depth_state=.{test_enabled=true, write_enabled=true, compare_op=Depth_Compare_Op},
    },
};

DepthPrepass :: (using ctx : *RenderContext, mesh_buffer : *MeshBuffer) {
    if !g_depth_only_material_pass.initialized {
        InitMaterialRenderPass(*g_depth_only_material_pass, *g_binding_set_layouts.DepthOnlyPassBindingSet);
    }

    viewpoints : ViewpointsData;
    viewpoints.viewpoints[0] = MakeViewpoint(viewpoint);
    viewpoints_offset, viewpoints_size := AllocAndPackUniformFrameData(viewpoints);

    pass_bindings := DepthOnlyPassBindingSet.{
        viewpoints=.{buffer=FrameDataBuffer(), offset=xx viewpoints_offset, size=xx viewpoints_size},
    };

    binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), pass_bindings);

    w, h := viewpoint.resolution.x, viewpoint.resolution.y;

    pass_desc : GfxRenderPassDesc;
    AddDepthAttachment(*pass_desc, *render_targets.depth_texture);
    ClearDepth(*pass_desc, Depth_Clear);

    pass := BeginGfxRenderPass(cmd_buffer, "Depth Prepass", pass_desc);
    {
        SetViewport(*pass, .{width=xx w, height=xx h});
        SetScissor(*pass, .{w=xx w, h=xx h});

        BindGraphicsBindingSet(cmd_buffer, *g_depth_only_material_pass.pipeline_layout, 1, *binding_set);

        pipeline_flags : MaterialPipelineFlags;
        if viewpoint.flags & .ShowWireframe {
            pipeline_flags |= .Wireframe;
        }

        for mesh_buffer.draw_calls {
            pipeline := GetPipeline(*g_depth_only_material_pass, it, pipeline_flags);
            BindGraphicsPipeline(*pass, pipeline);

            BindGraphicsBindingSet(cmd_buffer, *g_depth_only_material_pass.pipeline_layout, 2, *it.binding_set);
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
