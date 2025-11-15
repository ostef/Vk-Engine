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

TestShapeEntity :: struct {
    #as using _ : Entity; @Serialize(1) @InspectorNoTree

    Shape :: enum {
        Point;
        Ray;
        Box;
        Sphere;
        Capsule;
        Mesh;
        Plane;
    }

    shape : Shape; @Serialize(2)
    sphere_radius := 1.0; @Serialize(4) @FloatRange(0.1,100)
    capsule_height := 2.0; @Serialize(5) @FloatRange(0.1,100)
    capsule_radius := 0.5; @Serialize(6) @FloatRange(0.1,100)
    mesh : *StaticMeshComponent; @Serialize(8)
    ray_length := 10.0; @Serialize(9)

    GetEditorIcon :: (world : *World, using entity : *TestShapeEntity) -> *Asset(Texture2D) {
        return LoadAssetPermanent(Texture2D, "Editor/Icons/Default.png");
    }

    OnCreate :: (world : *World, using entity : *TestShapeEntity) {
        mesh = CreateComponent(world, StaticMeshComponent, entity);
    }

    OnDestroy :: (world : *World, using entity : *TestShapeEntity) {
        DestroyComponent(world, mesh);
    }

    OnDebugDraw :: (world : *World, using entity : *TestShapeEntity) {
        position := TranslationVector(world_transform);
        if #complete shape == {
        case .Point;
            DebugDrawCross(world, .{1,1,1,1}, position, 0.1);

            for * world.TestShapeEntity_storage {
                if it.shape == {
                case .Box;
                case .Plane;
                case .Ray;
                case .Sphere;
                case .Capsule;
                case .Mesh;
                    if !mesh.mesh {
                        continue;
                    }
                }
            }
        case .Ray;
            direction := ForwardVector(world_transform);
            DebugDrawCross(world, .{1,1,1,1}, position, 0.1);
            DebugDrawLine(world, .{1,1,1,1}, position, position + direction * ray_length);

            intersects : bool;
            point : Vec3f;
            normal : Vec3f;
            for * world.TestShapeEntity_storage {
                if it.shape == {
                case .Box;
                    intersects, point, _, normal =
                        RayIntersectsBox(position, direction, ray_length, .{1,1,1}, it.world_transform);

                case .Plane;
                case .Ray;
                case .Sphere;
                    intersects, point, _, normal =
                        RayIntersectsSphere(position, direction, ray_length, TranslationVector(it.world_transform), it.sphere_radius);

                case .Capsule;
                    capsule_normal := UpVector(it.world_transform);
                    capsule_center := TranslationVector(it.world_transform);
                    capsule_base := capsule_center - capsule_normal * it.capsule_height * 0.5;
                    capsule_tip := capsule_center + capsule_normal * it.capsule_height * 0.5;
                    intersects, point, _, normal =
                        RayIntersectsCapsule(position, direction, ray_length, capsule_base, capsule_tip, it.capsule_radius);

                case .Mesh;
                    if !it.mesh.mesh {
                        continue;
                    }

                    intersects, point, _, normal =
                        RayIntersectsMesh(position, direction, ray_length, it.mesh.mesh, it.world_transform);
                }

                if intersects {
                    DebugDrawCross(world, .{1,0,0,1}, point, 0.1);
                    DebugDrawLine(world, .{0,0,1,1}, point, point + normal * 0.2);
                }
            }
        case .Box;
            DebugDrawBoxOutline(world, .{1,1,1,1}, .{0,0,0}, .{1,1,1}, world_transform);
        case .Sphere;
            DebugDrawSphereOutline(world, .{1,1,1,1}, position, sphere_radius);
        case .Capsule;
            normal := UpVector(world_transform);
            DebugDrawCapsuleOutline(world, .{1,1,1,1}, position - normal * capsule_height * 0.5, position + normal * capsule_height * 0.5, capsule_radius);
        case .Mesh;
        case .Plane;
        }
    }
} @Entity
