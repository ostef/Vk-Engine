SkyboxBindingSet :: struct {
    viewpoint : GfxBindingUniformBuffer; @Binding(0) @FragmentStage
    skybox : GfxBindingCombinedTextureSampler; @Binding(1) @FragmentStage
} @BindingSet

g_skybox_pipeline : GfxGraphicsPipeline;
g_skybox_sampler : GfxSampler;

CreateSkyboxPipeline :: () {
    desc : GfxGraphicsPipelineDesc;
    if Reverse_Depth_Range {
        desc.vertex_shader = GetVertexShader("screen_effect");
    } else {
        desc.vertex_shader = GetVertexShader("background_screen_effect");
    }
    desc.fragment_shader = GetFragmentShader("skybox");

    AddColorAttachment(*desc, .RGBA16Float);
    desc.depth_format = .Depth32Float;

    desc.depth_state = .{test_enabled=true, compare_op=Depth_Compare_Op};

    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.SkyboxBindingSet,
    ];

    CreateGfxGraphicsPipeline(*g_skybox_pipeline, "Skybox", desc);
}

SkyboxPass :: (using ctx : *RenderContext, skybox_texture : *GfxTexture) {
    if IsNull(*g_skybox_pipeline) {
        CreateSkyboxPipeline();
    }

    if !skybox_texture {
        return;
    }

    w, h := viewpoint.resolution.x, viewpoint.resolution.y;

    viewpoint_offset, viewpoint_size := AllocAndPackUniformFrameData(MakeViewpoint(viewpoint));

    pass_bindings := SkyboxBindingSet.{
        viewpoint=.{buffer=FrameDataBuffer(), offset=xx viewpoint_offset, size=xx viewpoint_size},
        skybox=.{texture=skybox_texture, sampler=*g_skybox_sampler},
    };
    binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), pass_bindings);

    pass_desc : GfxRenderPassDesc;
    AddColorAttachment(*pass_desc, *render_targets.hdr_color_texture);
    AddDepthAttachment(*pass_desc, *render_targets.depth_texture);

    pass := BeginGfxRenderPass(cmd_buffer, "Skybox", pass_desc);
    {
        BindGraphicsPipeline(*pass, *g_skybox_pipeline);
        SetViewport(*pass, .{width=xx w, height=xx h});
        SetScissor(*pass, .{w=xx w, h=xx h});

        BindGraphicsBindingSet(*pass, 1, *binding_set);

        Draw(*pass, vertex_count=6, instance_count=1);
    }
    EndGfxRenderPass(*pass);
}
