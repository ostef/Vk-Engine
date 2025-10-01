CompositingBindingSet :: struct {
    viewpoint : GfxBindingUniformBuffer; @Binding(0) @FragmentStage
    hdr_color_texture : GfxBindingCombinedTextureSampler; @Binding(1) @FragmentStage
    bloom_texture : GfxBindingCombinedTextureSampler; @Binding(2) @FragmentStage
    entity_guid_texture : GfxBindingCombinedTextureSampler; @Binding(3) @FragmentStage
    selected_entity_guid_texture : GfxBindingCombinedTextureSampler; @Binding(4) @FragmentStage
    // gizmo_texture : GfxBindingCombinedTextureSampler; @Binding(5) @FragmentStage
} @BindingSet

g_compositing_pipeline : GfxGraphicsPipeline;
g_entity_guid_sampler : GfxSampler;

CreateCompositingPipeline :: () {
    desc : GfxGraphicsPipelineDesc;
    desc.vertex_shader = GetVertexShader("screen_effect");
    desc.fragment_shader = GetFragmentShader("compositing");
    AddColorAttachment(*desc, .RGBA8UNorm);

    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.CompositingBindingSet,
    ];

    g_compositing_pipeline = CreateGfxGraphicsPipeline("Compositing", desc);
    Assert(!IsNull(*g_compositing_pipeline), "Could not create compositing pipeline");
}

CompositingPass :: (using ctx : *RenderContext) {
    if IsNull(*g_entity_guid_sampler) {
        desc : GfxSamplerDesc;
        desc.min_filter = .Nearest;
        desc.mag_filter = .Nearest;
        g_entity_guid_sampler = CreateGfxSampler("Entity GUID", desc);
    }

    if IsNull(*g_compositing_pipeline) {
        CreateCompositingPipeline();
    }

    viewpoint_offset, viewpoint_size := AllocAndPackUniformFrameData(MakeViewpoint(viewpoint));

    bindings := CompositingBindingSet.{
        viewpoint=.{buffer=FrameDataBuffer(), offset=xx viewpoint_offset, size=xx viewpoint_size},
        hdr_color_texture=.{texture=*render_targets.hdr_color_texture, sampler=*g_linear_clamp_sampler},
        bloom_texture=.{texture=GetFinalBloomTexture(*render_targets.bloom_textures), sampler=*g_linear_clamp_sampler},
        entity_guid_texture=.{texture=*render_targets.entity_guids_texture, sampler=*g_entity_guid_sampler},
        selected_entity_guid_texture=.{texture=*render_targets.selected_entity_guids_texture, sampler=*g_entity_guid_sampler},
        // gizmo_texture=.{texture=*g_gizmo_ctx.color_resolve, sampler=*g_linear_clamp_sampler},
    };

    binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), bindings);

    w, h := viewpoint.resolution.x, viewpoint.resolution.y;

    pass_desc : GfxRenderPassDesc;
    AddColorAttachment(*pass_desc, *render_targets.final_color_texture, load_op=.DontCare);

    pass := BeginGfxRenderPass(cmd_buffer, "Compositing", pass_desc);
    {
        BindGraphicsPipeline(*pass, *g_compositing_pipeline);
        SetViewport(*pass, .{width=xx w, height=xx h});
        SetScissor(*pass, .{w=xx w, h=xx h});

        BindGraphicsBindingSet(*pass, 1, *binding_set);
        Draw(*pass, vertex_count=6, instance_count=1);
    }
    EndGfxRenderPass(*pass);
}
