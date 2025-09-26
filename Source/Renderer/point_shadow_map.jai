// @Todo: allow all shadow map passes to run concurrently (currently EndGfxRenderPass puts execution barriers for correctness)

using _ :: struct {
    Num_Point_Shadow_Map_Cbrt_Samples :: 3;
    Num_Point_Shadow_Map_Samples :: Num_Point_Shadow_Map_Cbrt_Samples * Num_Point_Shadow_Map_Cbrt_Samples * Num_Point_Shadow_Map_Cbrt_Samples;
} @ShaderType

Default_Point_Shadow_Map_Resolution :: 1024;

PointShadowMap :: struct {
    resolution : u32;
    z_near := 0.01;
    z_far := 30.0;
    mesh_buffers : [6]MeshBuffer;
    depth_texture : GfxTexture;
    depth_texture_faces : [6]GfxTexture;
}

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

// InitShadowMap :: (shadow_map : *PointShadowMap, resolution : u32) {
//     if !IsNull(*shadow_map.depth_texture) && shadow_map.resolution == resolution {
//         return;
//     }

//     if !IsNull(*shadow_map.depth_texture) {
//         for * shadow_map.depth_texture_faces {
//             QueueDestroyGfxTextureView(it);
//         }

//         QueueDestroyGfxTexture(*shadow_map.depth_texture);
//     }

//     shadow_map.resolution = resolution;

//     desc : GfxTextureDesc;
//     desc.type = .TextureCube;
//     desc.pixel_format = .Depth32Float;
//     desc.usage = .DepthStencilAttachment | .Sampled;
//     desc.width = resolution;
//     desc.height = resolution;

//     shadow_map.depth_texture = CreateGfxTexture("Point Shadow Map", desc);
//     Assert(!IsNull(*shadow_map.depth_texture), "Could not create point shadow map texture");

//     for i : 0..5 {
//         desc : GfxTextureViewDesc;
//         desc.type = .Texture2D;
//         desc.pixel_format = .Depth32Float;
//         desc.first_array_layer = xx i;

//         shadow_map.depth_texture_faces[i] = CreateGfxTextureView(TPrint("Point Shadow Map, %", cast(CubeMapFace, i)), desc, *shadow_map.depth_texture);
//         Assert(!IsNull(*shadow_map.depth_texture_faces[i]), "Could not create point shadow map texture view for face %", cast(CubeMapFace, i));
//     }
// }

// DestroyShadowMap :: (shadow_map : *PointShadowMap) {
//     for * shadow_map.depth_texture_faces {
//         QueueDestroyGfxTextureView(it);
//     }

//     QueueDestroyGfxTexture(*shadow_map.depth_texture);

//     for * shadow_map.mesh_buffers {
//         FreeMeshBuffer(it);
//     }
// }

// UpdatePointShadowMapFarPlane :: (light : *PointLightComponent) {
//     light.shadow_map.z_far = GetPointLightAttenuationDistance(light);
// }

// GetShadowMapViewpoint :: (shadow_map : *PointShadowMap, light_position : Vec3f, face : CubeMapFace) -> Viewpoint {
//     right := RightVector(Cube_Map_Face_Orientations[face]);
//     up := UpVector(Cube_Map_Face_Orientations[face]);
//     forward := ForwardVector(Cube_Map_Face_Orientations[face]);

//     viewpoint : Viewpoint;
//     viewpoint.projection = Mat4fPerspectiveProjection(90, 1, shadow_map.z_near, shadow_map.z_far);
//     viewpoint.inv_projection = Inverse(viewpoint.projection);

//     viewpoint.transform = Mat4fFromRightUpForwardOrigin(right, up, forward, light_position);
//     viewpoint.position = light_position;
//     viewpoint.right = right;
//     viewpoint.up = up;
//     viewpoint.direction = forward;
//     viewpoint.view = Inverse(viewpoint.transform);
//     viewpoint.view_projection = viewpoint.projection * viewpoint.view;
//     viewpoint.inv_view_projection = Inverse(viewpoint.view_projection);
//     viewpoint.viewport_size = .{xx shadow_map.resolution, xx shadow_map.resolution};
//     viewpoint.z_near = shadow_map.z_near;
//     viewpoint.z_far = shadow_map.z_far;

//     return viewpoint;
// }

// GetShadowMapFrustum :: (shadow_map : *PointShadowMap, light_position : Vec3f, face : CubeMapFace) -> Frustum {
//     right := RightVector(Cube_Map_Face_Orientations[face]);
//     up := UpVector(Cube_Map_Face_Orientations[face]);
//     forward := ForwardVector(Cube_Map_Face_Orientations[face]);

//     transform := Mat4fFromRightUpForwardOrigin(right, up, forward, light_position);;

//     return MakePerspectiveFrustum(transform, 90, 1, shadow_map.z_near, shadow_map.z_far);
// }

// PopulateShadowMapMeshBuffer :: (world : *World, shadow_map : *PointShadowMap, light_position : Vec3f, face : CubeMapFace) {
//     mesh_buffer := *shadow_map.mesh_buffers[face];

//     ClearMeshBuffer(mesh_buffer);

//     frustum := GetShadowMapFrustum(shadow_map, light_position, face);
//     viewpoint := GetShadowMapViewpoint(shadow_map, light_position, face);

//     for :AllMeshesToDraw world {
//         if !it.cast_point_shadows {
//             continue;
//         }

//         if !it.is_skinned {
//             aabb := GetTransformedAABB(it.transform, it.static_bounds);
//             if !AABBIsInFrustum(aabb, frustum) {
//                 continue;
//             }
//         }

//         position := TranslationVector(it.transform);
//         depth := TransformPoint(viewpoint.view, position).z;
//         key := MakeMeshBufferKey(it, depth);
//         PushMesh(mesh_buffer, key, it);
//     }

//     SortMeshBuffer(mesh_buffer);
//     AllocDrawData(mesh_buffer);
// }

// PopulateShadowMapMeshBuffers :: (world : *World, shadow_map : *PointShadowMap, light_position : Vec3f) {
//     for i : 0..5 {
//         PopulateShadowMapMeshBuffer(world, shadow_map, light_position, xx i);
//     }
// }

// PointShadowMapPassBindingSet :: struct {
//     viewpoints : GfxBindingUniformBuffer; @Binding(0) @VertexStage @FragmentStage
// } @BindingSet

// g_point_shadow_map_material_pass := MaterialRenderPass.{
//     name="Point Shadow Map",
//     fragment_shader="point_shadow_map",
//     pipeline_template=.{
//         depth_format=.Depth32Float,
//         depth_state=.{test_enabled=true, write_enabled=true},
//     },
// };

// PointShadowMapPass :: (using ctx : *FrameRenderContext, shadow_map : *PointShadowMap, light_position : Vec3f, face : CubeMapFace) {
//     viewpoints : ViewpointsData;
//     viewpoints.viewpoints[0] = GetShadowMapViewpoint(shadow_map, light_position, xx face);

//     viewpoints_offset, viewpoints_size := AllocAndPackUniformFrameData(viewpoints);

//     pass_bindings := PointShadowMapPassBindingSet.{
//         viewpoints=.{buffer=FrameDataBuffer(), offset=xx viewpoints_offset, size=xx viewpoints_size},
//     };
//     binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), pass_bindings);

//     pass_desc : GfxRenderPassDesc;
//     AddDepthAttachment(*pass_desc, *shadow_map.depth_texture_faces[face]);
//     ClearDepth(*pass_desc, 1);

//     pass := BeginGfxRenderPass(cmd_buffer, TPrint("Point Shadow Map, %", face), pass_desc);
//     {
//         SetViewport(*pass, .{width=xx shadow_map.resolution, height=xx shadow_map.resolution});
//         SetScissor(*pass, .{w=xx shadow_map.resolution, h=xx shadow_map.resolution});

//         BindGraphicsBindingSet(cmd_buffer, *g_point_shadow_map_material_pass.pipeline_layout, 1, *binding_set);

//         for shadow_map.mesh_buffers[face].draw_calls {
//             pipeline := GetPipeline(*g_point_shadow_map_material_pass, it);
//             BindGraphicsPipeline(*pass, pipeline);

//             BindGraphicsBindingSet(*pass, 2, *it.binding_set);
//             BindVertexBuffer(*pass, 0, it.vertex_buffer);

//             if it.index_buffer {
//                 BindIndexBuffer(*pass, .UInt32, it.index_buffer);
//                 DrawIndexed(*pass, it.index_count, it.instance_count);
//             } else {
//                 Draw(*pass, it.vertex_count, it.instance_count);
//             }
//         }
//     }
//     EndGfxRenderPass(*pass);
// }

// PointShadowMapPass :: (using ctx : *FrameRenderContext, shadow_map : *PointShadowMap, light_position : Vec3f) {
//     if !g_point_shadow_map_material_pass.initialized {
//         InitMaterialRenderPass(*g_point_shadow_map_material_pass, *g_binding_set_layouts.PointShadowMapPassBindingSet);
//     }

//     if IsNull(*shadow_map.depth_texture) {
//         InitShadowMap(shadow_map, Default_Point_Shadow_Map_Resolution);
//     }

//     ProfileGPUZone(cmd_buffer, *g_gpu_profiler, "Point Shadow Map");
//     BeginGfxDebugMarker(cmd_buffer, "Point Shadow Map");

//     AddTextureBarrier(cmd_buffer, .Undefined, .DepthStencilAttachment, *shadow_map.depth_texture);

//     for i : 0..5 {
//         PointShadowMapPass(ctx, shadow_map, light_position, xx i);
//     }

//     AddTextureBarrier(cmd_buffer, .DepthStencilAttachment, .ShaderReadOnly, *shadow_map.depth_texture);

//     EndGfxDebugMarker(cmd_buffer);
// }
