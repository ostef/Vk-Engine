ShadowMap :: struct {
    resolution : u32;
    direction : Vec3f;
    cascade_sizes : [Num_Shadow_Map_Cascades]float = Shadow_Map_Cascade_Sizes;
    viewpoints : [Num_Shadow_Map_Cascades]Viewpoint;
} @ShaderType

g_unused_shadow_map_render_targets : [..]GfxTexture;
g_used_shadow_map_render_targets : [..]GfxTexture;

GetShadowMapRenderTarget :: (desired_resolution : u32) -> GfxTexture {
    index := -1;
    for g_unused_shadow_map_render_targets {
        if it.desc.width == desired_resolution {
            index = it_index;
            break;
        }
    }

    if index >= 0 {
        texture := g_unused_shadow_map_render_targets[index];
        ArrayOrderedRemove(*g_unused_shadow_map_render_targets, index);
        ArrayPush(*g_used_shadow_map_render_targets, texture);

        return texture;
    }

    desc : GfxTextureDesc;
    desc.type = .Texture2DArray;
    desc.pixel_format = .Depth32Float;
    desc.width = desired_resolution;
    desc.height = desired_resolution;
    desc.num_array_layers = Num_Shadow_Map_Cascades;
    desc.usage = .DepthStencilAttachment | .Sampled;
    texture := CreateGfxTexture(TPrint("Shadow Map (%1x%1)", desired_resolution), desc);
    Assert(!IsNull(*texture), "Could not create shadow map texture");

    ArrayPush(*g_used_shadow_map_render_targets, texture);

    return texture;
}

RecycleShadowMapRenderTargets :: () {
    while g_used_shadow_map_render_targets.count > 0 {
        texture := g_used_shadow_map_render_targets[g_used_shadow_map_render_targets.count - 1];
        ArrayPop(*g_used_shadow_map_render_targets);
        ArrayOrderedInsert(*g_unused_shadow_map_render_targets, 0, texture);
    }
}

#if Shadow_Map_Reverse_Depth_Range {
    Shadow_Map_Depth_Compare_Op :: GfxCompareOp.GreaterEqual;
    Shadow_Map_Depth_Clear :: 0.0;
} else {
    Shadow_Map_Depth_Compare_Op :: GfxCompareOp.LessEqual;
    Shadow_Map_Depth_Clear :: 1.0;
}

#assert Num_Shadow_Map_Cascades <= Max_Viewpoints;

g_shadow_map_noise_texture : GfxTexture;
g_shadow_map_noise_sampler : GfxSampler;
g_shadow_map_sampler : GfxSampler;

CreateGlobalShadowMapObjects :: () {
    texture_desc : GfxTextureDesc;
    texture_desc.type = .Texture2DArray;
    texture_desc.pixel_format = .RGBA32Float;
    texture_desc.width = Shadow_Map_Noise_Size;
    texture_desc.height = Shadow_Map_Noise_Size;
    texture_desc.num_array_layers = Num_Shadow_Map_Samples;
    texture_desc.usage = .TransferDst | .Sampled;

    g_shadow_map_noise_texture = CreateGfxTexture("Shadow Map Noise", texture_desc);
    Assert(!IsNull(*g_shadow_map_noise_texture), "Could not create shadow map noise texture");

    noise_pixels := AllocArray(Vec4f, texture_desc.width * texture_desc.height * texture_desc.num_array_layers ,, Temp);
    for * noise_pixels {
        offset := Vec2f.{
            random_get_zero_to_one(),
            random_get_zero_to_one(),
        };
        it.x = Sqrt(offset.y) * Cos(2 * Pi * offset.x);
        it.y = Sqrt(offset.y) * Sin(2 * Pi * offset.x);

        offset = Vec2f.{
            random_get_zero_to_one(),
            random_get_zero_to_one(),
        };
        it.z = Sqrt(offset.y) * Cos(2 * Pi * offset.x);
        it.w = Sqrt(offset.y) * Sin(2 * Pi * offset.x);
    }

    QueueTextureUpload(noise_pixels.data, cast(*Texture2D, *g_shadow_map_noise_texture));

    {
        sampler_desc : GfxSamplerDesc;
        sampler_desc.min_filter = .Nearest;
        sampler_desc.mag_filter = .Nearest;
        sampler_desc.u_address_mode = .Repeat;
        sampler_desc.v_address_mode = .Repeat;
        sampler_desc.w_address_mode = .Repeat;

        g_shadow_map_noise_sampler = CreateGfxSampler("Shadow Map Noise", sampler_desc);
        Assert(!IsNull(*g_shadow_map_noise_sampler), "Could not create shadow map noise sampler");
    }
    {
        sampler_desc : GfxSamplerDesc;
        sampler_desc.min_filter = .Linear;
        sampler_desc.mag_filter = .Linear;
        sampler_desc.u_address_mode = .ClampToEdge;
        sampler_desc.v_address_mode = .ClampToEdge;
        sampler_desc.compare_op = ifx Shadow_Map_Reverse_Depth_Range then .Less else .Greater;

        g_shadow_map_sampler = CreateGfxSampler("Shadow Map", sampler_desc);
        Assert(!IsNull(*g_shadow_map_sampler), "Could not create shadow map sampler");
    }
}

DestroyGlobalShadowMapObjects :: () {
    DestroyGfxTexture(*g_shadow_map_noise_texture);
    DestroyGfxSampler(*g_shadow_map_noise_sampler);
    DestroyGfxSampler(*g_shadow_map_sampler);
}

GetShadowMapViewpoint :: (using shadow_map : *ShadowMapToRender, level : int) -> Viewpoint {
    size := Shadow_Map_Cascade_Sizes[level];
    depth := size * Shadow_Map_Depth_Extent_Factor;

    center := TranslationVector(target_transform) + ForwardVector(target_transform) * size * 0.5 * Shadow_Map_Forward_Offset;

    viewpoint : Viewpoint;
    if Shadow_Map_Reverse_Depth_Range {
        viewpoint.projection = Mat4fOrthographicProjection(-size * 0.5, size * 0.5, -size * 0.5, size * 0.5, depth * 0.5, -depth * 0.5);
    } else {
        viewpoint.projection = Mat4fOrthographicProjection(-size * 0.5, size * 0.5, -size * 0.5, size * 0.5, -depth * 0.5, depth * 0.5);
    }
    viewpoint.inv_projection = Inverse(viewpoint.projection);

    viewpoint.transform = Mat4fLookAt(center, center + direction, .{1,0,0});
    viewpoint.position = TranslationVector(viewpoint.transform);
    viewpoint.right = RightVector(viewpoint.transform);
    viewpoint.up = UpVector(viewpoint.transform);
    viewpoint.direction = ForwardVector(viewpoint.transform);
    viewpoint.view = Inverse(viewpoint.transform);
    viewpoint.view_projection = viewpoint.projection * viewpoint.view;
    viewpoint.inv_view_projection = Inverse(viewpoint.view_projection);
    viewpoint.viewport_size = .{xx shadow_map.resolution, xx shadow_map.resolution};
    viewpoint.z_near = -depth * 0.5;
    viewpoint.z_far = depth * 0.5;

    return viewpoint;
}

GetShadowMapFrustum :: (using shadow_map : *ShadowMapToRender, level : int) -> Frustum {
    size := Shadow_Map_Cascade_Sizes[level];
    depth := size * Shadow_Map_Depth_Extent_Factor;

    center := TranslationVector(target_transform) + ForwardVector(target_transform) * size * 0.5 * Shadow_Map_Forward_Offset;

    light_transform := Mat4fLookAt(center, center + direction, .{1,0,0});

    return MakeOrthographicFrustum(
        light_transform,
        -size * 0.5, size * 0.5,
        -size * 0.5, size * 0.5,
        -depth * 0.5, depth * 0.5
    );
}

PopulateShadowMapMeshBuffer :: (world : *WorldToRender, using shadow_map : *ShadowMapToRender, mesh_buffer : *MeshBuffer) {
    frustums : [Num_Shadow_Map_Cascades]Frustum = ---;
    for * frustums {
        it.* = GetShadowMapFrustum(shadow_map, it_index);
    }

    viewpoints : [Num_Shadow_Map_Cascades]Viewpoint = ---;
    for * viewpoints {
        it.* = GetShadowMapViewpoint(shadow_map, it_index);
    }

    right := viewpoints[0].right;
    up := viewpoints[0].up;
    billboard_rotation := Mat4fFromRightUpForwardOrigin(-right, up, -direction, .{});

    for world.meshes {
        mesh := it;

        if mesh.is_billboard {
            mesh.transform *= billboard_rotation;
        }

        if !mesh.cast_shadows {
            continue;
        }

        is_inside_frustum := false;
        if !mesh.is_skinned {
            aabb := GetTransformedAABB(mesh.transform, mesh.static_bounds);
            for < frustum : frustums {
                if AABBIsInFrustum(aabb, frustum) {
                    is_inside_frustum = true;
                    break;
                }
            }
        } else {
            is_inside_frustum = true;
        }

        if is_inside_frustum {
            depth := TransformPoint(viewpoints[0].view, TranslationVector(mesh.transform)).z;
            key := MakeMeshBufferKey(mesh, depth);

            PushMesh(mesh_buffer, key, mesh);
        }
    }

    SortMeshBuffer(mesh_buffer);
    AllocDrawData(mesh_buffer);
}

ShadowMapPassBindingSet :: struct {
    viewpoints : GfxBindingUniformBuffer; @Binding(0) @VertexStage
} @BindingSet

g_shadow_map_material_pass := MaterialRenderPass.{
    name="Shadow Map",
    fragment_shader="DEPTH_ONLY",
    pipeline_template=.{
        depth_format=.Depth32Float,
        depth_state=.{test_enabled=true, write_enabled=true, compare_op=Shadow_Map_Depth_Compare_Op},
    },
};

RenderShadowMap :: (using ctx : *RenderContext, shadow_map : *ShadowMapToRender, render_target : *GfxTexture) {
    if !g_shadow_map_material_pass.initialized {
        InitMaterialRenderPass(*g_shadow_map_material_pass, *g_binding_set_layouts.ShadowMapPassBindingSet);
    }

    mesh_buffer : MeshBuffer;
    mesh_buffer.meshes.allocator = Temp;
    mesh_buffer.draw_calls.allocator = Temp;
    PopulateShadowMapMeshBuffer(world, shadow_map, *mesh_buffer);

    AddTextureBarrier(cmd_buffer, .Undefined, .DepthStencilAttachment, render_target);

    viewpoints : ViewpointsData;
    viewpoints.num_viewpoints = Num_Shadow_Map_Cascades;
    for i : 0..Num_Shadow_Map_Cascades - 1 {
        viewpoints.viewpoints[i] = GetShadowMapViewpoint(shadow_map, i);
    }

    viewpoints_offset, viewpoints_size := AllocAndPackUniformFrameData(viewpoints);

    pass_bindings := ShadowMapPassBindingSet.{
        viewpoints=.{buffer=FrameDataBuffer(), offset=xx viewpoints_offset, size=xx viewpoints_size},
    };
    binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), pass_bindings);

    pass_desc : GfxRenderPassDesc;
    pass_desc.num_layers = Num_Shadow_Map_Cascades;
    AddDepthAttachment(*pass_desc, render_target);
    ClearDepth(*pass_desc, Shadow_Map_Depth_Clear);

    pass := BeginGfxRenderPass(cmd_buffer, "Shadow Map", pass_desc);
    {
        SetViewport(*pass, .{width=xx shadow_map.resolution, height=xx shadow_map.resolution});
        SetScissor(*pass, .{w=xx shadow_map.resolution, h=xx shadow_map.resolution});

        BindGraphicsBindingSet(cmd_buffer, *g_shadow_map_material_pass.pipeline_layout, 1, *binding_set);

        for mesh_buffer.draw_calls {
            pipeline := GetPipeline(*g_shadow_map_material_pass, it);
            BindGraphicsPipeline(*pass, pipeline);

            BindGraphicsBindingSet(*pass, 2, *it.binding_set);
            BindVertexBuffer(*pass, 0, it.vertex_buffer);

            if it.index_buffer {
                BindIndexBuffer(*pass, .UInt32, it.index_buffer);
                DrawIndexed(*pass, it.index_count, it.instance_count * Num_Shadow_Map_Cascades);
            } else {
                Draw(*pass, it.vertex_count, it.instance_count * Num_Shadow_Map_Cascades);
            }
        }
    }
    EndGfxRenderPass(*pass);

    AddTextureBarrier(cmd_buffer, .DepthStencilAttachment, .ShaderReadOnly, render_target);
}
