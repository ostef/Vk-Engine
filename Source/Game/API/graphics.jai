StaticMeshComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    mesh : *Asset(StaticMesh); @Serialize(2)
    material : *Asset(Material); @Serialize(3)
    cast_shadows := true; @Serialize(4)
    cast_point_shadows := false; @Serialize(5)
} @Component

AllStaticMeshComponents :: #bake_arguments AllEntityComponents(T=StaticMeshComponent);

SkinnedMeshComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    mesh : *Asset(SkinnedMesh); @Serialize(2)
    material : *Asset(Material); @Serialize(3)
    cast_shadows := true; @Serialize(4)
    cast_point_shadows := false; @Serialize(5)
    skinning_matrices : []Mat4f;

    OnDestroy :: (world : *World, using comp : *SkinnedMeshComponent) {
        Free(skinning_matrices.data);
    }
} @Component

AllSkinnedMeshComponents :: #bake_arguments AllEntityComponents(T=SkinnedMeshComponent);

// SetPose :: (using component : *SkinnedMeshComponent, pose : *ArmaturePose) {
//     if !pose.mesh {
//         return;
//     }

//     if pose.mesh != mesh {
//         LogError("Mismatching mesh when setting pose ('%' vs '%')", mesh.asset_name, pose.mesh.asset_name);
//     }

//     CalculateSkinningMatrices(pose, *skinning_matrices);
// }

StaticMeshEntity :: struct {
    #as using _ : Entity; @Serialize(1) @InspectorNoTree

    mesh : *StaticMeshComponent; @Serialize(2)

    OnSpawn :: (world : *World, entity : *StaticMeshEntity) {
        entity.mesh = CreateComponent(world, StaticMeshComponent, entity);
    }

    OnDespawn :: (world : *World, entity : *StaticMeshEntity) {
        DestroyComponent(world, entity.mesh);
    }
} @Entity

// AnimatedMeshEntity :: struct {
//     #as using _ : Entity; @Serialize(1) @InspectorNoTree

//     mesh : *SkinnedMeshComponent; @Serialize(2)

//     animation : *Asset(ArmatureAnimation); @Serialize(3)
//     animation_frames_per_second := 30.0; @Serialize(4)
//     animation_time : float;
//     pose : ArmaturePose;

//     OnSpawn :: (world : *World, entity : *AnimatedMeshEntity) {
//         entity.mesh = CreateComponent(world, SkinnedMeshComponent, entity);
//     }

//     OnDespawn :: (world : *World, using entity : *AnimatedMeshEntity) {
//         DestroyComponent(world, mesh);
//         FreeArmaturePose(*pose);
//     }

//     OnEditorUpdate :: (world : *World, using entity : *AnimatedMeshEntity) {
//         if pose.mesh != mesh.mesh {
//             FreeArmaturePose(*pose);

//             if mesh {
//                 InitArmaturePose(*pose, mesh.mesh);
//             }
//         }

//         if !mesh.mesh {
//             return;
//         }

//         if animation {
//             SampleAnimation(animation, animation_time, *pose);
//             animation_time += GetDeltaTime() * animation_frames_per_second;
//         } else {
//             ResetToBindPose(*pose);
//             animation_time = 0;
//         }

//         CalculatePoseTransforms(*pose);
//         SetPose(mesh, *pose);
//     }
// } @Entity

DirectionalLightComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    color : Vec3f = .{1,1,1}; @Serialize(2) @ColorEdit
    intensity : float = 1; @Serialize(3) @FloatRange(0,1000)
    cast_shadows : bool; @Serialize(4)
    // shadow_map : ShadowMap;

    // OnDestroy :: (world : *World, using component : *DirectionalLightComponent) {
    //     DestroyShadowMap(*shadow_map);
    // }

    // OnDebugDraw :: (world : *World, entity : *Entity, light : *DirectionalLightComponent) {
    //     if EntityOrParentIsSelected(world, entity.guid) {
    //         position := TranslationVector(light.world_transform);
    //         right := RightVector(light.world_transform);
    //         up := UpVector(light.world_transform);
    //         direction := ForwardVector(light.world_transform);

    //         p0 := position + right * 0.3;
    //         p1 := position - right * 0.3;
    //         p2 := position + up * 0.3;
    //         p3 := position - up * 0.3;

    //         DebugDrawCircleOutline(.{1,1,1,1}, position, right, up, 0.3);
    //         DebugDrawLine(.{1,1,1,1}, p0, p0 + direction);
    //         DebugDrawLine(.{1,1,1,1}, p1, p1 + direction);
    //         DebugDrawLine(.{1,1,1,1}, p2, p2 + direction);
    //         DebugDrawLine(.{1,1,1,1}, p3, p3 + direction);
    //     }
    // }

    GetEditorIcon :: (world : *World, entity : *Entity, light : *DirectionalLightComponent) -> *Asset(Texture2D) {
        return LoadAssetPermanent(Texture2D, "Editor/Icons/DirectionalLight.png");
    }
} @Component

AllDirectionalLightComponents :: #bake_arguments AllEntityComponents(T=DirectionalLightComponent);

DirectionalLightEntity :: struct {
    #as using _ : Entity; @Serialize(1) @InspectorNoTree

    light : *DirectionalLightComponent; @Serialize(2)

    OnSpawn :: (world : *World, light : *DirectionalLightEntity) {
        light.light = CreateComponent(world, DirectionalLightComponent, light);
    }

    OnDespawn :: (world : *World, light : *DirectionalLightEntity) {
        DestroyComponent(world, light.light);
    }
} @Entity

PointLightComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    color : Vec3f = .{1,1,1}; @Serialize(2) @ColorEdit
    intensity : float = 1; @Serialize(3) @FloatRange(0,1000)
    intensity_radius : float = 0; @Serialize(5) @FloatRange(0,100)
    source_radius : float = 0.05; @Serialize(6) @FloatRange(0.001,100)
    cast_shadows : bool; @Serialize(4)
    // shadow_map : PointShadowMap;

    // OnDestroy :: (world : *World, using component : *PointLightComponent) {
    //     DestroyShadowMap(*shadow_map);
    // }

    // OnDebugDraw :: (world : *World, entity : *Entity, light : *PointLightComponent) {
    //     if EntityOrParentIsSelected(world, entity.guid) {
    //         position := TranslationVector(light.world_transform);
    //         DebugDrawSphereOutline(.{1,1,1,1}, position, light.source_radius);
    //         DebugDrawSphereOutline(.{1,1,1,1}, position, GetPointLightAttenuationDistance(light));
    //     }
    // }

    GetEditorIcon :: (world : *World, entity : *Entity, light : *PointLightComponent) -> *Asset(Texture2D) {
        return LoadAssetPermanent(Texture2D, "Editor/Icons/PointLight.png");
    }
} @Component

AllPointLightComponents :: #bake_arguments AllEntityComponents(T=PointLightComponent);

PointLightEntity :: struct {
    #as using _ : Entity; @Serialize(1) @InspectorNoTree

    light : *PointLightComponent; @Serialize(2)

    OnSpawn :: (world : *World, light : *PointLightEntity) {
        light.light = CreateComponent(world, PointLightComponent, light);
    }

    OnDespawn :: (world : *World, light : *PointLightEntity) {
        DestroyComponent(world, light.light);
    }
} @Entity

Point_Light_Attenuation_Threshold :: 0.07;

GetPointLightAttenuationDistance :: (source_radius : float, base_intensity : float, intensity_radius : float) -> float {
    if intensity_radius > 0 {
        return source_radius + intensity_radius;
    }

    return source_radius + Sqrt(base_intensity / Point_Light_Attenuation_Threshold);
}

GetPointLightAttenuationDistance :: (light : *PointLightComponent) -> float {
    return GetPointLightAttenuationDistance(light.source_radius, light.intensity, light.intensity_radius);
}
