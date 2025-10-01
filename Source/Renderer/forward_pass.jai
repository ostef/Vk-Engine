ForwardPassBindingSet :: struct {
    viewpoints : GfxBindingUniformBuffer; @Binding(0) @VertexStage @FragmentStage
    clusters : GfxBindingStorageBuffer; @Binding(5) @FragmentStage
} @BindingSet

g_forward_material_pass := MaterialRenderPass.{
    name="Forward",
    fragment_shader="FORWARD_SHADING",
    pipeline_template=.{
        num_color_attachments=1,
        color_formats[0]=.RGBA16Float,
        depth_format=.Depth32Float,
        depth_state=.{test_enabled=true, write_enabled=true, compare_op=Depth_Compare_Op},
    },
};

ForwardPass :: (using ctx : *RenderContext, mesh_buffer : *MeshBuffer) {
    if !g_forward_material_pass.initialized {
        InitMaterialRenderPass(*g_forward_material_pass, *g_binding_set_layouts.ForwardPassBindingSet);
    }

    viewpoints : ViewpointsData;
    viewpoints.viewpoints[0] = MakeViewpoint(viewpoint);
    viewpoints_offset, viewpoints_size := AllocAndPackUniformFrameData(viewpoints);

    pass_bindings := ForwardPassBindingSet.{
        viewpoints=.{buffer=FrameDataBuffer(), offset=xx viewpoints_offset, size=xx viewpoints_size},
        clusters=.{buffer=FrameDataBuffer(), offset=xx clusters_offset, size=xx clusters_size},
    };

    binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), pass_bindings);

    w, h := viewpoint.resolution.x, viewpoint.resolution.y;

    pass_desc : GfxRenderPassDesc;
    AddColorAttachment(*pass_desc, *render_targets.color_texture);
    AddDepthAttachment(*pass_desc, *render_targets.depth_texture);
    ClearColor(*pass_desc, 0, Vec4f.{0,0,0,1});
    ClearDepth(*pass_desc, Depth_Clear);

    pass := BeginGfxRenderPass(cmd_buffer, "Forward Pass", pass_desc);
    {
        SetViewport(*pass, .{width=xx w, height=xx h});
        SetScissor(*pass, .{w=xx w, h=xx h});

        BindGraphicsBindingSet(cmd_buffer, *g_forward_material_pass.pipeline_layout, 1, *binding_set);

        for mesh_buffer.draw_calls {
            pipeline := GetPipeline(*g_forward_material_pass, it);
            BindGraphicsPipeline(*pass, pipeline);

            BindGraphicsBindingSet(cmd_buffer, *g_forward_material_pass.pipeline_layout, 2, *it.binding_set);
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
