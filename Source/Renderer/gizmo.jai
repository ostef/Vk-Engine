// @Todo: ensure we don't use more samples than what is allowed on the machine
// @Todo: do not do multisampling and create resolve texture when num samples == 1
Gizmo_Texture_Num_Samples :: 8;

GizmoWidget :: struct {
    transform : Mat4f;
    shaded : bool;
    color : Vec4f;
} @ShaderType

GizmoBindingSet :: struct {
    viewpoint : GfxBindingUniformBuffer; @Binding(0) @VertexStage
    widgets : GfxBindingStorageBuffer; @Binding(1) @VertexStage @AllowNull
} @BindingSet

g_gizmo_pipeline : GfxGraphicsPipeline;

CreateGizmoPipeline :: () {
    desc : GfxGraphicsPipelineDesc;
    desc.vertex_shader = GetVertexShader("gizmo");
    desc.fragment_shader = GetFragmentShader("gizmo");
    desc.rasterizer_state = .{cull_face=.None, num_samples=Gizmo_Texture_Num_Samples};
    desc.blend_states[0] = .{enabled=true};
    desc.depth_state = .{test_enabled=true, write_enabled=true, compare_op=Depth_Compare_Op};

    AddColorAttachment(*desc, .RGBA8UNorm);
    desc.depth_format = .Depth32Float;

    desc.vertex_input = MakeVertexInputDesc(StaticVertex, 0);

    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.GizmoBindingSet,
    ];

    CreateGfxGraphicsPipeline(*g_gizmo_pipeline, "Gizmo", desc);
}

GizmoPass :: (using ctx : *RenderContext) {
    if IsNull(*g_gizmo_pipeline) {
        CreateGizmoPipeline();
    }

    AddTextureBarriers(cmd_buffer, .Undefined, .ColorAttachment, .[*render_targets.gizmo_color_texture, *render_targets.gizmo_color_resolve]);
    AddTextureBarrier(cmd_buffer, .Undefined, .DepthStencilAttachment, *render_targets.gizmo_depth_texture);

    w, h := viewpoint.resolution.x, viewpoint.resolution.y;

    viewpoint_offset, viewpoint_size := AllocAndPackUniformFrameData(MakeViewpoint(viewpoint));

    widgets := AllocArray(GizmoWidget, viewpoint.gizmo_widgets.count ,, Temp);
    for viewpoint.gizmo_widgets {
        widgets[it_index] = .{
            transform=it.transform,
            shaded=it.shaded,
            color=it.color,
        };
    }

    widgets_offset, widgets_size := AllocAndPackStorageFrameData(widgets);

    bindings := GizmoBindingSet.{
        viewpoint=.{buffer=FrameDataBuffer(), offset=xx viewpoint_offset, size=xx viewpoint_size},
        widgets=.{buffer=FrameDataBuffer(), offset=xx widgets_offset, size=xx widgets_size},
    };

    binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), bindings);

    pass_desc : GfxRenderPassDesc;
    AddColorAttachment(*pass_desc, *render_targets.gizmo_color_texture, resolve_texture=*render_targets.gizmo_color_resolve);
    AddDepthAttachment(*pass_desc, *render_targets.gizmo_depth_texture);
    ClearColor(*pass_desc, 0, Vec4f.{0,0,0,0});
    ClearDepth(*pass_desc, Depth_Clear);

    pass := BeginGfxRenderPass(cmd_buffer, "Gizmo", pass_desc);
    {
        BindGraphicsPipeline(*pass, *g_gizmo_pipeline);
        SetViewport(*pass, .{width=xx w, height=xx h});
        SetScissor(*pass, .{w=xx w, h=xx h});

        BindGraphicsBindingSet(*pass, 1, *binding_set);

        prev_vertex_buffer, prev_index_buffer : *GfxBuffer;
        for viewpoint.gizmo_widgets {
            if it.vertex_buffer != prev_vertex_buffer {
                BindVertexBuffer(*pass, 0, it.vertex_buffer);
                prev_vertex_buffer = it.vertex_buffer;
            }
            if it.index_buffer != prev_index_buffer {
                BindIndexBuffer(*pass, .UInt32, it.index_buffer);
                prev_index_buffer = it.index_buffer;
            }

            // @Todo: instancing
            DrawIndexed(*pass, index_count=it.index_count, instance_count=1, base_instance=xx it_index);
        }
    }
    EndGfxRenderPass(*pass);

    GizmoLinesPass(ctx);

    AddTextureBarrier(cmd_buffer, .ColorAttachment, .ShaderReadOnly, *render_targets.gizmo_color_resolve);
}

g_gizmo_lines_pipeline : GfxGraphicsPipeline;

CreateGizmoLinesPipeline :: () {
    desc : GfxGraphicsPipelineDesc;
    desc.vertex_shader = GetVertexShader("debug_line");
    desc.fragment_shader = GetFragmentShader("debug_line");
    desc.primitive_topology = .LineList;
    desc.rasterizer_state = .{cull_face=.None, num_samples=Gizmo_Texture_Num_Samples};

    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.DebugLinesBindingSet,
    ];

    AddColorAttachment(*desc, .RGBA8UNorm);
    desc.depth_format = .Depth32Float;

    desc.blend_states[0] = .{enabled=true};
    desc.depth_state = .{test_enabled=true, write_enabled=true, compare_op=Depth_Compare_Op};

    CreateGfxGraphicsPipeline(*g_gizmo_lines_pipeline, "Gizmo Lines", desc);
}

GizmoLinesPass :: (using ctx : *RenderContext) {
    if IsNull(*g_gizmo_lines_pipeline) {
        CreateGizmoLinesPipeline();
    }

    if viewpoint.gizmo_lines.count <= 0 {
        return;
    }

    w, h := viewpoint.resolution.x, viewpoint.resolution.y;

    viewpoint_offset, viewpoint_size := AllocAndPackUniformFrameData(MakeViewpoint(viewpoint));
    lines_offset, lines_size := AllocAndPackStorageFrameData(viewpoint.gizmo_lines);

    bindings := DebugLinesBindingSet.{
        viewpoint=.{buffer=FrameDataBuffer(), offset=xx viewpoint_offset, size=xx viewpoint_size},
        lines=.{buffer=FrameDataBuffer(), offset=xx lines_offset, size=xx lines_size},
    };
    binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), bindings);

    pass_desc : GfxRenderPassDesc;
    AddColorAttachment(*pass_desc, *render_targets.gizmo_color_texture, resolve_texture=*render_targets.gizmo_color_resolve);
    AddDepthAttachment(*pass_desc, *render_targets.gizmo_depth_texture, store_op=.DontCare);

    pass := BeginGfxRenderPass(cmd_buffer, "Gizmo Lines", pass_desc);
    {
        BindGraphicsPipeline(*pass, *g_gizmo_lines_pipeline);
        SetViewport(*pass, .{width=xx w, height=xx h});
        SetScissor(*pass, .{w=xx w, h=xx h});

        BindGraphicsBindingSet(*pass, 1, *binding_set);

        Draw(*pass, vertex_count=2, instance_count=xx viewpoint.gizmo_lines.count);
    }
    EndGfxRenderPass(*pass);
}
