StaticMeshComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    mesh : *Asset(StaticMesh); @Serialize(2)
    material : *Asset(Material); @Serialize(3)
    cast_shadows := true; @Serialize(4)
    cast_point_shadows := false; @Serialize(5)
} @Component

AllStaticMeshComponents :: #bake_arguments AllEntityComponents(T=StaticMeshComponent);

MakeMeshToRender :: (entity : *Entity, component : *StaticMeshComponent) -> bool, MeshToRender {
    if entity.flags & .Hidden || !component.mesh || IsNull(*component.mesh.vertex_buffer) || IsNull(*component.mesh.index_buffer) {
        return false, .{};
    }

    return true, .{
        entity_guid=xx entity.guid,
        transform=component.world_transform,
        vertex_buffer=*component.mesh.vertex_buffer,
        index_buffer=*component.mesh.index_buffer,
        vertex_count=component.mesh.vertex_count,
        index_count=component.mesh.index_count,
        static_bounds=component.mesh.static_bounds,
        material=ifx component.material then component.material else GetDefaultMaterial(),
        cast_shadows=component.cast_shadows,
        cast_point_shadows=component.cast_point_shadows,
        is_skinned=false,
    };
}

MakeMeshToRender :: (world : *World, component : *StaticMeshComponent) -> bool, MeshToRender {
    entity := GetEntity(world, component.entity_index);
    if !entity {
        LogError("Could not get entity %", component.entity_index);
        return false, .{};
    }

    ok, mesh := MakeMeshToRender(entity, component);
    return ok, mesh;
}

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

MakeMeshToRender :: (entity : *Entity, component : *SkinnedMeshComponent) -> bool, MeshToRender {
    if entity.flags & .Hidden || !component.mesh || IsNull(*component.mesh.vertex_buffer) || IsNull(*component.mesh.index_buffer) {
        return false, .{};
    }

    return true, .{
        entity_guid=xx entity.guid,
        transform=component.world_transform,
        vertex_buffer=*component.mesh.vertex_buffer,
        index_buffer=*component.mesh.index_buffer,
        vertex_count=component.mesh.vertex_count,
        index_count=component.mesh.index_count,
        material=ifx component.material then component.material else GetDefaultMaterial(),
        cast_shadows=component.cast_shadows,
        cast_point_shadows=component.cast_point_shadows,
        is_skinned=true,
        skinning_matrices=component.skinning_matrices,
    };
}

MakeMeshToRender :: (world : *World, component : *SkinnedMeshComponent) -> bool, MeshToRender {
    entity := GetEntity(world, component.entity_index);
    if !entity {
        LogError("Could not get entity");
        return false, .{};
    }

    ok, mesh := MakeMeshToRender(entity, component);
    return ok, mesh;
}

SetPose :: (using component : *SkinnedMeshComponent, pose : *ArmaturePose) {
    if !pose.mesh {
        return;
    }

    if pose.mesh != mesh {
        LogError("Mismatching mesh when setting pose ('%' vs '%')", mesh.asset_name, pose.mesh.asset_name);
        return;
    }

    CalculateSkinningMatrices(pose, *skinning_matrices);
}

StaticMeshEntity :: struct {
    #as using _ : Entity; @Serialize(1) @InspectorNoTree

    mesh : *StaticMeshComponent; @Serialize(2)

    OnCreate :: (world : *World, entity : *StaticMeshEntity) {
        entity.mesh = CreateComponent(world, StaticMeshComponent, entity);
    }

    OnDestroy :: (world : *World, entity : *StaticMeshEntity) {
        DestroyComponent(world, entity.mesh);
    }
} @Entity

AnimatedMeshEntity :: struct {
    #as using _ : Entity; @Serialize(1) @InspectorNoTree

    mesh : *SkinnedMeshComponent; @Serialize(2)

    animation : *Asset(ArmatureAnimation); @Serialize(3)
    animation_frames_per_second := 30.0; @Serialize(4)
    animation_time : float;
    pose : ArmaturePose;

    OnCreate :: (world : *World, entity : *AnimatedMeshEntity) {
        entity.mesh = CreateComponent(world, SkinnedMeshComponent, entity);
    }

    OnDestroy :: (world : *World, using entity : *AnimatedMeshEntity) {
        DestroyComponent(world, mesh);
        FreeArmaturePose(*pose);
    }

    OnUpdate :: (world : *World, using entity : *AnimatedMeshEntity) {
        if pose.mesh != mesh.mesh {
            FreeArmaturePose(*pose);

            if mesh {
                InitArmaturePose(*pose, mesh.mesh);
            }
        }

        if !mesh.mesh {
            return;
        }

        if animation {
            SampleAnimation(animation, animation_time, *pose);
            animation_time += GetDeltaTime() * animation_frames_per_second;
        } else {
            ResetToBindPose(*pose);
            animation_time = 0;
        }

        CalculatePoseTransforms(*pose);
        SetPose(mesh, *pose);
    }
} @Entity

AllMeshesToRender :: (world : *World, body : Code, flags : For_Flags) #expand {
    `it : MeshToRender;
    `it_index : int;

    for * c, i : world.StaticMeshComponent_storage {
        defer it_index += 1;

        ok:, it = MakeMeshToRender(world, c);
        if !ok {
            continue;
        }

        #insert(break=return) body;
    }

    for * c, i : world.SkinnedMeshComponent_storage {
        defer it_index += 1;

        ok:, it = MakeMeshToRender(world, c);
        if !ok {
            continue;
        }

        #insert(break=return) body;
    }
}

AllMeshesToRender :: (entity : *$E, body : Code, flags : For_Flags) #expand {
    `it : MeshToRender;
    `it_index : int;

    for :AllStaticMeshComponents c, i : entity {
        defer it_index += 1;

        ok:, it = MakeMeshToRender(entity, c);
        if !ok {
            continue;
        }

        #insert(break=return) body;
    }

    for :AllSkinnedMeshComponents c, i : entity {
        defer it_index += 1;

        ok:, it = MakeMeshToRender(entity, c);
        if !ok {
            continue;
        }

        #insert(break=return) body;
    }
}

DirectionalLightComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    color : Vec3f = .{1,1,1}; @Serialize(2) @ColorEdit
    intensity : float = 1; @Serialize(3) @FloatRange(0,1000)
    cast_shadows : bool; @Serialize(4)

    OnEditorUpdate :: (world : *World, entity : *Entity, light : *DirectionalLightComponent, is_selected : bool) {
        if !is_selected {
            return;
        }

        position := TranslationVector(light.world_transform);
        right := RightVector(light.world_transform);
        up := UpVector(light.world_transform);
        direction := ForwardVector(light.world_transform);

        p0 := position + right * 0.3;
        p1 := position - right * 0.3;
        p2 := position + up * 0.3;
        p3 := position - up * 0.3;

        DebugDrawCircleOutline(world, .{rgb=light.color, a=1}, position, right, up, 0.3);
        DebugDrawLine(world, .{rgb=light.color, a=1}, p0, p0 + direction);
        DebugDrawLine(world, .{rgb=light.color, a=1}, p1, p1 + direction);
        DebugDrawLine(world, .{rgb=light.color, a=1}, p2, p2 + direction);
        DebugDrawLine(world, .{rgb=light.color, a=1}, p3, p3 + direction);
    }

    GetEditorIcon :: (world : *World, entity : *Entity, light : *DirectionalLightComponent) -> *Asset(Texture2D) {
        return LoadAssetPermanent(Texture2D, "Editor/Icons/DirectionalLight.png");
    }
} @Component

AllDirectionalLightComponents :: #bake_arguments AllEntityComponents(T=DirectionalLightComponent);

DirectionalLightEntity :: struct {
    #as using _ : Entity; @Serialize(1) @InspectorNoTree

    light : *DirectionalLightComponent; @Serialize(2)

    OnCreate :: (world : *World, light : *DirectionalLightEntity) {
        light.light = CreateComponent(world, DirectionalLightComponent, light);
    }

    OnDestroy :: (world : *World, light : *DirectionalLightEntity) {
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

    OnEditorUpdate :: (world : *World, entity : *Entity, light : *PointLightComponent, is_selected : bool) {
        if !is_selected {
            return;
        }

        position := TranslationVector(light.world_transform);
        DebugDrawSphereOutline(world, .{1,1,1,1}, position, light.source_radius);
        DebugDrawSphereOutline(world, .{1,1,1,1}, position, GetPointLightAttenuationDistance(light));
    }

    GetEditorIcon :: (world : *World, entity : *Entity, light : *PointLightComponent) -> *Asset(Texture2D) {
        return LoadAssetPermanent(Texture2D, "Editor/Icons/PointLight.png");
    }
} @Component

AllPointLightComponents :: #bake_arguments AllEntityComponents(T=PointLightComponent);

PointLightEntity :: struct {
    #as using _ : Entity; @Serialize(1) @InspectorNoTree

    light : *PointLightComponent; @Serialize(2)

    OnCreate :: (world : *World, light : *PointLightEntity) {
        light.light = CreateComponent(world, PointLightComponent, light);
    }

    OnDestroy :: (world : *World, light : *PointLightEntity) {
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
