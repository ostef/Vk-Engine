FlyingLightEntity :: struct {
    #as using _ : Entity; @Serialize(1) @InspectorNoTree

    point_light : *PointLightComponent; @Serialize(2)
    spawn_position : Vec3f;
    orbit_distance : float;
    rotation_speed : float;
    rotation_axis : Vec3f;

    OnSpawn :: (world : *World, using entity : *FlyingLightEntity) {
        point_light = CreateComponent(world, PointLightComponent, entity);
        point_light.intensity = random_get_within_range(0.3,25);
        point_light.intensity_radius = random_get_within_range(1,5);
        point_light.color = .{
            random_get_within_range(0.2,1),
            random_get_within_range(0.2,1),
            random_get_within_range(0.2,1),
        };

        rotation_axis = .{
            random_get_within_range(-1, 1),
            random_get_within_range(-1, 1),
            random_get_within_range(-1, 1),
        };
        rotation_axis = Normalized(rotation_axis);

        rotation_speed = random_get_within_range(Pi * 0.1, Pi * 2);

        spawn_position = .{
            random_get_within_range(-10, 10),
            random_get_within_range(0, 10),
            random_get_within_range(-10, 10),
        };

        orbit_distance = random_get_within_range(1, 10);
    }

    OnDespawn :: (world : *World, using entity : *FlyingLightEntity) {
        DestroyComponent(world, point_light);
    }

    OnEditorUpdate :: (world : *World, using entity : *FlyingLightEntity) {
        rotate := QuatfFromAxisAngle(rotation_axis, rotation_speed * GetDeltaTime());
        local_rotation *= rotate;

        local_position = spawn_position + orbit_distance * (RightVector(local_rotation) + ForwardVector(local_rotation));

        UpdateWorldTransform(world, entity);
    }
} @Entity
