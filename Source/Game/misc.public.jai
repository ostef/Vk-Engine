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

        result := PhysicsCastRay(world, position, direction, ray_length);
        if result.hit {
            DebugDrawCross(world, .{1,0,0,1}, result.point, 0.1);
            DebugDrawLine(world, .{0,0,1,1}, result.point, result.point + result.normal * 0.2);
        }
    }
} @Entity

TestShapeEntity :: struct {
    #as using _ : Entity; @Serialize(1) @InspectorNoTree

    ShapeKind :: enum {
        Sphere;
        Box;
        Capsule;
        Cylinder;
    }

    shape : union kind : ShapeKind @Serialize(1) {
        .Sphere ,, sphere : struct {
            radius := 1.0; @Serialize(1)
        }; @Serialize(2) @InspectorNoTree

        .Box ,, box : struct {
            half_extents := Vec3f.{1,1,1}; @Serialize(1)
        }; @Serialize(3) @InspectorNoTree

        .Capsule ,, capsule : struct {
            height := 2.0; @Serialize(1)
            radius := 0.5; @Serialize(2)
        }; @Serialize(4) @InspectorNoTree

        .Cylinder ,, cylinder : struct {
            height := 2.0; @Serialize(1)
            radius := 0.5; @Serialize(2)
        }; @Serialize(5) @InspectorNoTree
    }; @Serialize(2)

    jolt_shape : *Jolt.Shape;

    RecreateShape :: (world : *World, using test_shape : *TestShapeEntity) {
        if jolt_shape != null {
            jolt_shape.Destroy(jolt_shape);
            jolt_shape = null;
        }

        if #complete shape.kind == {
        case .Sphere;
            if shape.sphere.radius <= 0 {
                return;
            }

            jolt_shape = Jolt.SphereShape.Create(shape.sphere.radius, null);
        case .Box;
            if shape.box.half_extents.x <= 0 || shape.box.half_extents.y <= 0 || shape.box.half_extents.z <= 0 {
                return;
            }

            jolt_shape = Jolt.BoxShape.Create(ToJolt(shape.box.half_extents), Jolt.ConvexShapeSettings.cDefaultConvexRadius, null);
        case .Capsule;
            if shape.capsule.radius <= 0 {
                return;
            }

            if shape.cylinder.height * 0.5 <= shape.capsule.radius {
                jolt_shape = Jolt.SphereShape.Create(shape.capsule.radius, null);
            } else {
                jolt_shape = Jolt.CapsuleShape.Create(Max(shape.capsule.height * 0.5 - shape.capsule.radius, 0), shape.capsule.radius, null);
            }
        case .Cylinder;
            if shape.cylinder.radius <= 0 || shape.cylinder.height <= 0 {
                return;
            }

            jolt_shape = Jolt.CylinderShape.Create(Max(shape.cylinder.height * 0.5, 0), shape.cylinder.radius, Jolt.ConvexShapeSettings.cDefaultConvexRadius, null);
        }
    }

    OnValidate :: (world : *World, using test_shape : *TestShapeEntity) {
        RecreateShape(world, test_shape);
    }

    OnSpawn :: (world : *World, using test_shape : *TestShapeEntity) {
        RecreateShape(world, test_shape);
    }

    OnDespawn :: (world : *World, using test_shape : *TestShapeEntity) {
        jolt_shape.Destroy(jolt_shape);
    }

    OnDebugDraw :: (world : *World, using test_shape : *TestShapeEntity) {
        if !jolt_shape {
            return;
        }

        jolt_shape.Draw(jolt_shape, GetPhysicsGlobals().debug_renderer, ToJolt(world_position_rotation_transform), Jolt.Vec3.Make(1,1,1), 0xffffffff, false, true);
    }
} @Entity
