Jolt :: #import "JoltPhysics";

Log_Physics :: Log_Section.{"Physics"};

Physics_Temp_Allocator_Capacity :: 10 * 1024 * 1024;
Physics_Max_Bodies :: 1024;
Physics_Num_Body_Mutexes :: 0;
Physics_Max_Body_Pairs :: 1024;
Physics_Max_Contact_Constraints :: 1024;
Physics_Num_Updates_Per_Second :: 60;
Physics_Delta_Time :: 1.0 / Physics_Num_Updates_Per_Second;
Physics_Num_Collision_Steps :: 1;

PhysicsDebugDrawSettings :: struct {
    enabled := false; @Serialize(9)
    draw_colliders := true; @Serialize(1)
    draw_colliders_wireframe := true; @Serialize(2)
    collider_color := Jolt.BodyManager_ShapeColor.MotionTypeColor; @Serialize(3)
    draw_bounding_box := false; @Serialize(4)
    draw_center_of_mass_transform := false; @Serialize(5)
    draw_world_transform := false; @Serialize(6)
    draw_velocity := false; @Serialize(7)
    draw_mass_and_inertia := false; @Serialize(8)
}

PhysicsWorld :: struct {
    system : *Jolt.PhysicsSystem;
    job_system : *Jolt.JobSystem;
    broad_phase_layer_interface : *Jolt.BroadPhaseLayerInterface;
    object_vs_broad_phase_layer_filter : *Jolt.ObjectVsBroadPhaseLayerFilter;
    object_vs_object_layer_filter : *Jolt.ObjectLayerPairFilter;
    body_interface : *Jolt.BodyInterface;
    debug_renderer : *Jolt.DebugRenderer;
}

RaycastResult :: struct {
    hit : bool;
    point : Vec3f;
    normal : Vec3f;
    dist := F32_Inf;
    entity : *Entity;
    collider : *Component;
}

PhysicsBodyLayer :: enum u8 {
    Static;
    Moving;
}

Physics_Num_Body_Layers :: #run type_info(PhysicsBodyLayer).names.count;

PhysicsMotionType :: enum u8 {
    Static;
    Kinematic;
    Dynamic;
}

PhysicsMotionQuality :: enum u8 {
    Discrete;
    Continuous;
}

RigidBodyComponent :: struct {
    #as using _ : Component; @Serialize(1) @InspectorNoTree

    layer := PhysicsBodyLayer.Moving; @Serialize(2)
    motion_type := PhysicsMotionType.Dynamic; @Serialize(3)
    motion_quality := PhysicsMotionQuality.Discrete; @Serialize(5)
    activate_on_create := true; @Serialize(4)
    jolt_body_id : Jolt.BodyID;

    OnSpawn :: (world : *World, entity : *Entity, using body : *RigidBodyComponent) {
        LogSectionScope(*Log_Physics);

        shape_transforms : [..]struct{position : Vec3f; rotation : Quatf;};
        shape_transforms.allocator = Temp;
        shapes : [..]*Jolt.Shape;
        shapes.allocator = Temp;

        for :AllSphereColliderComponents entity {
            shape := CreateJoltShape(world, entity, it);
            ArrayPush(*shapes, xx shape);
            ArrayPush(*shape_transforms, .{it.local_position, it.local_rotation});
        }
        for :AllCapsuleColliderComponents entity {
            shape := CreateJoltShape(world, entity, it);
            ArrayPush(*shapes, xx shape);
            ArrayPush(*shape_transforms, .{it.local_position, it.local_rotation});
        }
        for :AllBoxColliderComponents entity {
            shape := CreateJoltShape(world, entity, it);
            ArrayPush(*shapes, xx shape);
            ArrayPush(*shape_transforms, .{it.local_position, it.local_rotation});
        }
        for :AllPlaneColliderComponents entity {
            shape := CreateJoltShape(world, entity, it);
            ArrayPush(*shapes, xx shape);
            ArrayPush(*shape_transforms, .{it.local_position, it.local_rotation});
        }

        final_shape : *Jolt.Shape;
        if shapes.count > 1 {
            compound_shape_settings := Jolt.StaticCompoundShapeSettings_Create();
            for shapes {
                transform := shape_transforms[it_index];
                Jolt.CompoundShapeSettings_AddShape2(xx compound_shape_settings, *transform.position, *transform.rotation, it, 0);
            }

            final_shape = xx Jolt.StaticCompoundShape_Create(compound_shape_settings);
        } else if shapes.count > 0 {
            transform := shape_transforms[0];
            rotated_translated := Jolt.RotatedTranslatedShapeSettings_Create2(*transform.position, *transform.rotation, shapes[0]);
            final_shape = xx Jolt.RotatedTranslatedShapeSettings_CreateShape(rotated_translated);
        } else {
            empty_settings := Jolt.EmptyShapeSettings_Create(*(Vec3f.{0,0,0}));
            final_shape = xx Jolt.EmptyShapeSettings_CreateShape(empty_settings);
        }

        world_position := TranslationVector(entity.world_transform);
        world_rotation := QuatfFromMatrix(entity.world_transform);

        jolt_motion_type : Jolt.MotionType;
        if #complete motion_type == {
        case .Static;    jolt_motion_type = .Static;
        case .Kinematic; jolt_motion_type = .Kinematic;
        case .Dynamic;   jolt_motion_type = .Dynamic;
        }

        jolt_motion_quality : Jolt.MotionQuality;
        if #complete motion_quality == {
        case .Discrete;   jolt_motion_quality = .Discrete;
        case .Continuous; jolt_motion_quality = .LinearCast;
        }

        body_settings := Jolt.BodyCreationSettings_Create3(final_shape, *world_position, *world_rotation, jolt_motion_type, xx layer);
        Jolt.BodyCreationSettings_SetMotionQuality(body_settings, jolt_motion_quality);

        jolt_body_id = Jolt.BodyInterface_CreateAndAddBody(world.physics.body_interface, body_settings, ifx activate_on_create then .Activate else .DontActivate);
        LogMessage("Created rigid body %: layer=%, motion_type=%, activate=%, num shapes=%", jolt_body_id, layer, motion_type, activate_on_create, shapes.count);
    }

    OnDestroy :: (world : *World, using body : *RigidBodyComponent) {
        LogSectionScope(*Log_Physics);

        if jolt_body_id {
            Jolt.BodyInterface_RemoveAndDestroyBody(world.physics.body_interface, jolt_body_id);
            LogMessage("Destroyed rigid body %", jolt_body_id);
        }

        jolt_body_id = 0;
    }
} @Component @Category(Physics)

Collider_Color :: Vec4f.{0,1,0,1};

SphereColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    radius : float = 0.5; @Serialize(2)
    density : float = 1; @Serialize(3)

    OnDebugDraw :: (world : *World, entity : *Entity, using sphere : *SphereColliderComponent) {
        center := TranslationVector(world_transform);
        right := RightVector(world_transform);
        up := UpVector(world_transform);
        forward := ForwardVector(world_transform);
        DebugDrawSphereOutline(world, Collider_Color, center, radius, right=right, up=up, forward=forward);
    }
} @Component @Category(Physics/Colliders)

AllSphereColliderComponents :: #bake_arguments AllEntityComponents(T=SphereColliderComponent);

CreateJoltShape :: (world : *World, entity : *Entity, sphere : *SphereColliderComponent) -> *Jolt.SphereShape {
    settings := Jolt.SphereShapeSettings_Create(sphere.radius);
    Jolt.ConvexShapeSettings_SetDensity(xx settings, sphere.density);

    return Jolt.SphereShapeSettings_CreateShape(settings);
}

CapsuleColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    height : float = 2; @Serialize(2)
    radius : float = 0.5; @Serialize(3)
    density : float = 1; @Serialize(4)

    OnDebugDraw :: (world : *World, entity : *Entity, using capsule : *CapsuleColliderComponent) {
        center := TranslationVector(world_transform);
        up := UpVector(world_transform);
        DebugDrawCapsuleOutline(world, Collider_Color, center - up * height * 0.5, center + up * height * 0.5, radius);
    }
} @Component @Category(Physics/Colliders)

AllCapsuleColliderComponents :: #bake_arguments AllEntityComponents(T=CapsuleColliderComponent);

CreateJoltShape :: (world : *World, entity : *Entity, capsule : *CapsuleColliderComponent) -> *Jolt.CapsuleShape {
    settings := Jolt.CapsuleShapeSettings_Create(capsule.height * 0.5 - capsule.radius, capsule.radius);
    Jolt.ConvexShapeSettings_SetDensity(xx settings, capsule.density);

    return Jolt.CapsuleShapeSettings_CreateShape(settings);
}

BoxColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    half_extents : Vec3f = .{1,1,1}; @Serialize(2)
    density : float = 1; @Serialize(3)
    margin : float = 0.01; @Serialize(4)

    OnDebugDraw :: (world : *World, entity : *Entity, using box : *BoxColliderComponent) {
        DebugDrawBoxOutline(world, Collider_Color, .{0,0,0}, half_extents, world_transform);
    }
} @Component @Category(Physics/Colliders)

AllBoxColliderComponents :: #bake_arguments AllEntityComponents(T=BoxColliderComponent);

CreateJoltShape :: (world : *World, entity : *Entity, box : *BoxColliderComponent) -> *Jolt.BoxShape {
    settings := Jolt.BoxShapeSettings_Create(*box.half_extents, box.margin);
    Jolt.ConvexShapeSettings_SetDensity(xx settings, box.density);

    return Jolt.BoxShapeSettings_CreateShape(settings);
}

PlaneColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    half_extent : float = 1; @Serialize(2)
    density : float = 1; @Serialize(3)

    // OnDebugDraw :: (world : *World, entity : *Entity, using box : *BoxColliderComponent) {
    //     DebugDrawBoxOutline(world, Collider_Color, .{0,0,0}, half_extents, world_transform);
    // }
} @Component @Category(Physics/Colliders)

AllPlaneColliderComponents :: #bake_arguments AllEntityComponents(T=PlaneColliderComponent);

CreateJoltShape :: (world : *World, entity : *Entity, plane : *PlaneColliderComponent) -> *Jolt.PlaneShape {
    normal := UpVector(plane.local_rotation);
    distance := Dot(normal, plane.local_position);
    p := Jolt.Plane.{normal, distance};

    settings := Jolt.PlaneShapeSettings_Create(*p, null, plane.half_extent);
    Jolt.ConvexShapeSettings_SetDensity(xx settings, plane.density);

    return Jolt.PlaneShapeSettings_CreateShape(settings);
}

MeshColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    mesh : *Asset(StaticMesh); @Serialize(2)
} @Component @Category(Physics/Colliders)

AllMeshColliderComponents :: #bake_arguments AllEntityComponents(T=MeshColliderComponent);
