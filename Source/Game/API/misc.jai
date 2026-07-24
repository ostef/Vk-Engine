g_flying_light_rng := Random_State.{123456, 123456};

FlyingLightEntity :: struct {
    #as using _ : Entity; @Serialize(1) @InspectorNoTree

    point_light : *PointLightComponent; @Serialize(2)
    spawn_position : Vec3f;
    orbit_distance : float;
    rotation_speed : float;
    rotation_axis : Vec3f;

    OnCreate :: (world : *World, using entity : *FlyingLightEntity) {
        point_light = CreateComponent(world, PointLightComponent, entity);
    }

    OnDestroy :: (world : *World, using entity : *FlyingLightEntity) {
        DestroyComponent(world, point_light);
    }

    OnSpawn :: (world : *World, using entity : *FlyingLightEntity) {
        point_light.intensity = random_get_within_range(*g_flying_light_rng, 0.3, 25);
        point_light.intensity_radius = random_get_within_range(*g_flying_light_rng, 1, 5);
        point_light.color = .{
            random_get_within_range(*g_flying_light_rng, 0.2,1),
            random_get_within_range(*g_flying_light_rng, 0.2,1),
            random_get_within_range(*g_flying_light_rng, 0.2,1),
        };

        rotation_axis = .{
            random_get_within_range(*g_flying_light_rng, -1, 1),
            random_get_within_range(*g_flying_light_rng, -1, 1),
            random_get_within_range(*g_flying_light_rng, -1, 1),
        };
        rotation_axis = Normalized(rotation_axis);

        rotation_speed = random_get_within_range(*g_flying_light_rng, Pi * 0.1, Pi * 2);

        spawn_position = .{
            random_get_within_range(*g_flying_light_rng, -10, 10),
            random_get_within_range(*g_flying_light_rng, 0, 10),
            random_get_within_range(*g_flying_light_rng, -10, 10),
        };

        orbit_distance = random_get_within_range(*g_flying_light_rng, 1, 10);
    }

    OnUpdate :: (world : *World, using entity : *FlyingLightEntity) {
        rotate := QuatfFromAxisAngle(rotation_axis, rotation_speed * GetDeltaTime());
        local_rotation *= rotate;

        local_position = spawn_position + orbit_distance * (RightVector(local_rotation) + ForwardVector(local_rotation));

        UpdateWorldTransform(world, entity);
    }
} @Entity

TestRayEntity :: struct {
    #as using _ : Entity; @Serialize(1) @InspectorNoTree

    ray_length := 10.0; @Serialize(2)

    GetEditorIcon :: (world : *World, using entity : *TestRayEntity) -> *Asset(Texture2D) {
        return LoadAssetPermanent(Texture2D, "Editor/Icons/Default.png");
    }

    OnDebugDraw :: (world : *World, using entity : *TestRayEntity) {
        position := TranslationVector(world_transform);
        direction := ForwardVector(world_transform);
        DebugDrawCross(world, .{1,1,1,1}, position, 0.1);
        DebugDrawLine(world, .{1,1,1,1}, position, position + direction * ray_length);

        result := Raycast(world, position, direction, ray_length);
        if result.hit {
            DebugDrawCross(world, .{1,0,0,1}, result.point, 0.1);
            DebugDrawLine(world, .{0,0,1,1}, result.point, result.point + result.normal * 0.2);
        }
    }
} @Entity
