InfiniteGridBindingSet :: struct {
    viewpoint : GfxBindingUniformBuffer; @Binding(0) @VertexStage
} @BindingSet

g_infinite_grid_pipeline : GfxGraphicsPipeline;

CreateInfiniteGridPipeline :: () {
    desc : GfxGraphicsPipelineDesc;
    desc.vertex_shader = GetVertexShader("infinite_grid");
    desc.fragment_shader = GetFragmentShader("infinite_grid");

    AddColorAttachment(*desc, .RGBA16Float);
    desc.depth_format = .Depth32Float;

    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.InfiniteGridBindingSet,
    ];

    desc.rasterizer_state = .{cull_face=.None};
    desc.depth_state = .{test_enabled=true, write_enabled=true, compare_op=Depth_Compare_Op};
    desc.blend_states[0] = .{enabled=true};

    g_infinite_grid_pipeline = CreateGfxGraphicsPipeline("Infinite Grid", desc);
    Assert(!IsNull(*g_infinite_grid_pipeline), "Could not create infinite grid pipeline");
}

InfiniteGridPass :: (using ctx : *RenderContext) {
    if IsNull(*g_infinite_grid_pipeline) {
        CreateInfiniteGridPipeline();
    }

    w, h := viewpoint.resolution.x, viewpoint.resolution.y;

    viewpoint_offset, viewpoint_size := AllocAndPackUniformFrameData(MakeViewpoint(viewpoint));

    pass_bindings := InfiniteGridBindingSet.{
        viewpoint=.{buffer=FrameDataBuffer(), offset=xx viewpoint_offset, size=xx viewpoint_size},
    };
    pass_binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), pass_bindings);

    pass_desc : GfxRenderPassDesc;
    AddColorAttachment(*pass_desc, *render_targets.hdr_color_texture);
    AddDepthAttachment(*pass_desc, *render_targets.depth_texture);

    pass := BeginGfxRenderPass(cmd_buffer, "Infinite Grid", pass_desc);
    {
        BindGraphicsPipeline(*pass, *g_infinite_grid_pipeline);
        SetViewport(*pass, .{width=xx w, height=xx h});
        SetScissor(*pass, .{w=xx w, h=xx h});

        BindGraphicsBindingSet(*pass, 1, *pass_binding_set);

        Draw(*pass, vertex_count=6, instance_count=1);
    }
    EndGfxRenderPass(*pass);
}
