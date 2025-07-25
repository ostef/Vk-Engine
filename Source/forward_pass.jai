ForwardPassBindingSet :: struct {
    viewpoints : GfxBindingUniformBuffer; @Binding(0) @VertexStage @FragmentStage
    shadow_maps : [Max_Shadow_Maps]GfxBindingCombinedTextureSampler; @Binding(1) @FragmentStage @AllowNull
    irradiance_map : GfxBindingCombinedTextureSampler; @Binding(2) @FragmentStage @AllowNull
    environment_map : GfxBindingCombinedTextureSampler; @Binding(3) @FragmentStage @AllowNull
} @BindingSet

g_forward_pipeline : GfxGraphicsPipeline;

CreateForwardPipeline :: () {
    desc : GfxGraphicsPipelineDesc;
    desc.vertex_shader = GetVertexShader("mesh_geometry");
    desc.fragment_shader = GetFragmentShader("opaque_surface");
    AddColorAttachment(*desc, g_color_texture.desc.pixel_format);
    desc.depth_format = g_depth_texture.desc.pixel_format;
    desc.depth_state = .{test_enabled=true, write_enabled=true};

    desc.vertex_input = MakeVertexInputDesc(StaticVertex, 0);

    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.ForwardPassBindingSet,
        g_binding_set_layouts.MeshBindingSet,
    ];

    ok := CreateGfxGraphicsPipeline(*g_forward_pipeline, "Forward", desc);
    Assert(ok, "Could not create forward pass pipeline");
}

ForwardPass :: (using ctx : *FrameRenderContext, camera : *Camera, mesh_buffer : *MeshBuffer) {
    if IsNull(*g_forward_pipeline) {
        CreateForwardPipeline();
    }

    w, h : s32;
    SDL_GetWindowSizeInPixels(g_window, *w, *h);

    viewpoints : [Max_Viewpoints]Viewpoint;
    viewpoints[0] = .{
        position=camera.position,
        right=RightVector(camera.transform),
        up=UpVector(camera.transform),
        direction=ForwardVector(camera.transform),
        transform=camera.transform,
        view=camera.view,
        projection=camera.projection,
        view_projection=camera.projection * camera.view,
        fov=ToRads(camera.fov_in_degrees),
        viewport_size=.{xx w, xx h},
    };
    viewpoints_offset, viewpoints_size := AllocAndPackUniformFrameData(viewpoints);

    pass_bindings := ForwardPassBindingSet.{
        viewpoints=.{buffer=FrameDataBuffer(), offset=xx viewpoints_offset, size=xx viewpoints_size},
        irradiance_map=.{texture=ifx world.skybox then *world.skybox.irradiance_map, sampler=*g_skybox_sampler},
        environment_map=.{texture=ifx world.skybox then *world.skybox.environment_map, sampler=*g_skybox_sampler},
    };

    shadow_map_index := 0;
    for * world.DirectionalLightEntity_storage {
        defer shadow_map_index += 1;

        if shadow_map_index >= Max_Shadow_Maps {
            break;
        }

        if !it.cast_shadows {
            continue;
        }

        pass_bindings.shadow_maps[shadow_map_index] = .{texture=*it.shadow_map.depth_texture, sampler=*g_shadow_map_sampler};
    }

    binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), pass_bindings);

    pass_desc : GfxRenderPassDesc;
    AddColorAttachment(*pass_desc, *g_color_texture);
    AddDepthAttachment(*pass_desc, *g_depth_texture);
    ClearColor(*pass_desc, 0, Vec4f.{0,0,0,1});
    ClearDepth(*pass_desc, 1);

    pass := BeginGfxRenderPass(cmd_buffer, "Forward Pass", pass_desc);
    {
        BindGraphicsPipeline(*pass, *g_forward_pipeline);
        SetViewport(*pass, .{width=xx w, height=xx h});
        SetScissor(*pass, .{w=xx w, h=xx h});

        BindGraphicsBindingSet(*pass, 1, *binding_set);

        for mesh_buffer.draw_calls {
            BindGraphicsBindingSet(*pass, 2, *it.binding_set);
            BindVertexBuffer(*pass, 0, it.vertex_buffer);
            BindIndexBuffer(*pass, .UInt32, it.index_buffer);

            DrawIndexed(*pass, it.index_count, it.instance_count);
        }
    }
    EndGfxRenderPass(*pass);
}
