// @Todo: allow all shadow map passes to run concurrently (currently EndGfxRenderPass puts execution barriers for correctness)

PointShadowMap :: struct {
    resolution : u32;
    z_near : float;
    z_far : float;
    position : Vec3f;
    viewpoints : [6]Viewpoint;
} @ShaderType

g_unused_point_shadow_map_render_targets : [..]PointShadowMapRenderTargets;
g_used_point_shadow_map_render_targets : [..]PointShadowMapRenderTargets;

using _ :: struct {
    Num_Point_Shadow_Map_Cbrt_Samples :: 3;
    Num_Point_Shadow_Map_Samples :: Num_Point_Shadow_Map_Cbrt_Samples * Num_Point_Shadow_Map_Cbrt_Samples * Num_Point_Shadow_Map_Cbrt_Samples;
} @ShaderType

CubeMapFace :: enum {
    PositiveX;
    NegativeX;
    PositiveY;
    NegativeY;
    PositiveZ;
    NegativeZ;
}

Cube_Map_Face_Orientations :: Quatf.[
    #run QuatfLookAt(.{ 1, 0, 0}, .{ 0, 1, 0}), // PositiveX
    #run QuatfLookAt(.{-1, 0, 0}, .{ 0, 1, 0}), // NegativeX
    #run QuatfLookAt(.{ 0, 1, 0}, .{ 0, 0,-1}), // PositiveY
    #run QuatfLookAt(.{ 0,-1, 0}, .{ 0, 0, 1}), // NegativeY
    #run QuatfLookAt(.{ 0, 0, 1}, .{ 0, 1, 0}), // PositiveZ
    #run QuatfLookAt(.{ 0, 0,-1}, .{ 0, 1, 0}), // NegativeZ
];

GetPointShadowMapRenderTarget :: (desired_resolution : u32) -> PointShadowMapRenderTargets {
    index := -1;
    for g_unused_point_shadow_map_render_targets {
        if it.texture.desc.width == desired_resolution {
            index = it_index;
            break;
        }
    }

    if index >= 0 {
        texture := g_unused_point_shadow_map_render_targets[index];
        ArrayOrderedRemove(*g_unused_point_shadow_map_render_targets, index);
        ArrayPush(*g_used_point_shadow_map_render_targets, texture);

        return texture;
    }

    render_targets : PointShadowMapRenderTargets;

    desc : GfxTextureDesc;
    desc.type = .TextureCube;
    desc.pixel_format = .Depth32Float;
    desc.width = desired_resolution;
    desc.height = desired_resolution;
    desc.usage = .DepthStencilAttachment | .Sampled;

    render_targets.texture = CreateGfxTexture(TPrint("Point Shadow Map (%1x%1)", desired_resolution), desc);
    Assert(!IsNull(*render_targets.texture), "Could not create shadow map texture");

    for i : 0..5 {
        desc : GfxTextureViewDesc;
        desc.type = .Texture2D;
        desc.pixel_format = .Depth32Float;
        desc.first_array_layer = xx i;

        render_targets.face_views[i] = CreateGfxTextureView(TPrint("Point Shadow Map (%1x%1, %2)", desired_resolution, cast(CubeMapFace, i)), desc, *render_targets.texture);
        Assert(!IsNull(*render_targets.face_views[i]), "Could not create point shadow map texture view for face %", cast(CubeMapFace, i));
    }

    ArrayPush(*g_used_point_shadow_map_render_targets, render_targets);

    return render_targets;
}

RecyclePointShadowMapRenderTargets :: () {
    while g_used_point_shadow_map_render_targets.count > 0 {
        render_target := g_used_point_shadow_map_render_targets[g_used_point_shadow_map_render_targets.count - 1];
        ArrayPop(*g_used_point_shadow_map_render_targets);
        ArrayOrderedInsert(*g_unused_point_shadow_map_render_targets, 0, render_target);
    }
}

DestroyPointShadowMapRenderTargets :: (using render_targets : *PointShadowMapRenderTargets) {
    DestroyGfxTexture(*texture);
    for * face_views {
        DestroyGfxTextureView(it);
    }

    render_targets.* = .{};
}

GetPointShadowMapViewpoint :: (using shadow_map : *PointShadowMapToRender, face : CubeMapFace) -> Viewpoint {
    right := RightVector(Cube_Map_Face_Orientations[face]);
    up := UpVector(Cube_Map_Face_Orientations[face]);
    forward := ForwardVector(Cube_Map_Face_Orientations[face]);

    viewpoint : Viewpoint;
    viewpoint.projection = Mat4fPerspectiveProjection(90, 1, z_near, z_far);
    viewpoint.inv_projection = Inverse(viewpoint.projection);

    viewpoint.transform = Mat4fFromRightUpForwardOrigin(right, up, forward, position);
    viewpoint.position = position;
    viewpoint.right = right;
    viewpoint.up = up;
    viewpoint.direction = forward;
    viewpoint.view = Inverse(viewpoint.transform);
    viewpoint.view_projection = viewpoint.projection * viewpoint.view;
    viewpoint.inv_view_projection = Inverse(viewpoint.view_projection);
    viewpoint.viewport_size = .{xx resolution, xx resolution};
    viewpoint.z_near = z_near;
    viewpoint.z_far = z_far;

    return viewpoint;
}

GetPointShadowMapFrustum :: (using shadow_map : *PointShadowMapToRender, face : CubeMapFace) -> Frustum {
    right := RightVector(Cube_Map_Face_Orientations[face]);
    up := UpVector(Cube_Map_Face_Orientations[face]);
    forward := ForwardVector(Cube_Map_Face_Orientations[face]);

    transform := Mat4fFromRightUpForwardOrigin(right, up, forward, position);;

    return MakePerspectiveFrustum(transform, 90, 1, z_near, z_far);
}

PopulateShadowMapMeshBuffer :: (world : *WorldToRender, shadow_map : *PointShadowMapToRender, mesh_buffer : *MeshBuffer, face : CubeMapFace) {
    ClearMeshBuffer(mesh_buffer);

    frustum := GetPointShadowMapFrustum(shadow_map, face);
    viewpoint := GetPointShadowMapViewpoint(shadow_map, face);

    right := viewpoint.right;
    up := viewpoint.up;
    direction := viewpoint.direction;
    billboard_rotation := Mat4fFromRightUpForwardOrigin(-right, up, -direction, .{});

    for world.meshes {
        mesh := it;

        if mesh.is_billboard {
            mesh.transform *= billboard_rotation;
        }

        if !mesh.cast_shadows {
            continue;
        }

        if !mesh.is_skinned {
            aabb := GetTransformedAABB(mesh.transform, mesh.static_bounds);
            if !AABBIsInFrustum(aabb, frustum) {
                continue;
            }
        }

        depth := TransformPoint(viewpoint.view, TranslationVector(mesh.transform)).z;
        key := MakeMeshBufferKey(mesh, depth);

        PushMesh(mesh_buffer, key, mesh);
    }

    SortMeshBuffer(mesh_buffer);
    AllocDrawData(mesh_buffer);
}

PointShadowMapPassBindingSet :: struct {
    viewpoints : GfxBindingUniformBuffer; @Binding(0) @VertexStage @FragmentStage
} @BindingSet

g_point_shadow_map_material_pass := MaterialRenderPass.{
    name="Point Shadow Map",
    fragment_shader="point_shadow_map",
    pipeline_template=.{
        depth_format=.Depth32Float,
        depth_state=.{test_enabled=true, write_enabled=true},
    },
};

PointShadowMapPass :: (using ctx : *RenderContext, shadow_map : *PointShadowMapToRender, render_target : *GfxTexture, mesh_buffer : *MeshBuffer, face : CubeMapFace) {
    PopulateShadowMapMeshBuffer(world, shadow_map, mesh_buffer, face);

    viewpoints : ViewpointsData;
    viewpoints.viewpoints[0] = GetPointShadowMapViewpoint(shadow_map, xx face);

    viewpoints_offset, viewpoints_size := AllocAndPackUniformFrameData(viewpoints);

    pass_bindings := PointShadowMapPassBindingSet.{
        viewpoints=.{buffer=FrameDataBuffer(), offset=xx viewpoints_offset, size=xx viewpoints_size},
    };
    binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), pass_bindings);

    pass_desc : GfxRenderPassDesc;
    AddDepthAttachment(*pass_desc, render_target);
    ClearDepth(*pass_desc, 1);

    pass := BeginGfxRenderPass(cmd_buffer, TPrint("Point Shadow Map, %", face), pass_desc);
    {
        SetViewport(*pass, .{width=xx shadow_map.resolution, height=xx shadow_map.resolution});
        SetScissor(*pass, .{w=xx shadow_map.resolution, h=xx shadow_map.resolution});

        BindGraphicsBindingSet(cmd_buffer, *g_point_shadow_map_material_pass.pipeline_layout, 1, *binding_set);

        for mesh_buffer.draw_calls {
            pipeline := GetPipeline(*g_point_shadow_map_material_pass, it);
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

RenderPointShadowMap :: (using ctx : *RenderContext, shadow_map : *PointShadowMapToRender, textures : *PointShadowMapRenderTargets) {
    if !g_point_shadow_map_material_pass.initialized {
        InitMaterialRenderPass(*g_point_shadow_map_material_pass, *g_binding_set_layouts.PointShadowMapPassBindingSet);
    }

    mesh_buffer : MeshBuffer;
    mesh_buffer.meshes.allocator = Temp;
    mesh_buffer.draw_calls.allocator = Temp;

    ProfileGPUZone(cmd_buffer, GetGPUFrameProfiler(), "Point Shadow Map");
    BeginGfxDebugMarker(cmd_buffer, "Point Shadow Map");

    AddTextureBarrier(cmd_buffer, .Undefined, .DepthStencilAttachment, *textures.texture);

    for i : 0..5 {
        PointShadowMapPass(ctx, shadow_map, *textures.face_views[i], *mesh_buffer, xx i);
    }

    AddTextureBarrier(cmd_buffer, .DepthStencilAttachment, .ShaderReadOnly, *textures.texture);

    EndGfxDebugMarker(cmd_buffer);
}
