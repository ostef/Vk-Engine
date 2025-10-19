Jolt :: #import "JoltPhysics";

Physics_Temp_Allocator_Capacity :: 10 * 1024 * 1024;
Physics_Max_Bodies :: 1024;
Physics_Num_Body_Mutexes :: 0;
Physics_Max_Body_Pairs :: 1024;
Physics_Max_Contact_Constraints :: 1024;
Physics_Num_Updates_Per_Second :: 60;
Physics_Delta_Time :: 1.0 / Physics_Num_Updates_Per_Second;
Physics_Num_Collision_Steps :: 1;

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

RigidBodyComponent :: struct {
    #as using _ : Component; @Serialize(1) @InspectorNoTree

    layer := PhysicsBodyLayer.Moving; @Serialize(2)
    motion_type := PhysicsMotionType.Dynamic; @Serialize(3)
    activate_on_create := true; @Serialize(4)
    jolt_body_id : Jolt.BodyID;

    OnCreate :: (world : *World, entity : *Entity, using body : *RigidBodyComponent) {
        shapes : [..]*Jolt.Shape;
        shapes.allocator = Temp;

        for :AllSphereColliderComponents entity {
            shape := CreateJoltShape(world, entity, it);
            ArrayPush(*shapes, xx shape);
        }
        // for :AllCapsuleColliderComponents entity {
        //     shape := CreateJoltShape(world, entity, it);
        //     ArrayPush(*shapes, xx shape);
        // }
        // for :AllBoxColliderComponents entity {
        //     shape := CreateJoltShape(world, entity, it);
        //     ArrayPush(*shapes, xx shape);
        // }

        final_shape : *Jolt.Shape;
        if shapes.count > 1 {
            compound_shape_settings := Jolt.StaticCompoundShapeSettings_Create();
            for shapes {
                Jolt.CompoundShapeSettings_AddShape2(xx compound_shape_settings, *(Vec3f.{}), *(Quatf.{}), it, 0);
            }

            final_shape = xx Jolt.StaticCompoundShape_Create(compound_shape_settings);
        } else if shapes.count > 0 {
            final_shape = shapes[0];
        } else {
            empty_settings := Jolt.EmptyShapeSettings_Create(*(Vec3f.{0,0,0}));
            final_shape = xx Jolt.EmptyShapeSettings_CreateShape(empty_settings);
        }

        world_position := TranslationVector(entity.world_transform);
        world_rotation := QuatfFromMatrix(entity.world_transform);

        jolt_motion_type : Jolt.MotionType;
        if #complete motion_type == {
        case .Static; jolt_motion_type = .Static;
        case .Kinematic; jolt_motion_type = .Kinematic;
        case .Dynamic; jolt_motion_type = .Dynamic;
        }

        body_settings := Jolt.BodyCreationSettings_Create3(final_shape, *world_position, *world_rotation, jolt_motion_type, xx layer);

        jolt_body_id = Jolt.BodyInterface_CreateAndAddBody(world.physics.body_interface, body_settings, ifx activate_on_create then .Activate else .DontActivate);
    }

    OnDestroy :: (world : *World, using body : *RigidBodyComponent) {
        Jolt.BodyInterface_RemoveAndDestroyBody(world.physics.body_interface, jolt_body_id);
    }
} @Component @Category(Physics)

SphereColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    radius : float = 1; @Serialize(2)
    density : float = 1; @Serialize(3)

    // OnCreate :: (world : *World, entity : *Entity, sphere : *SphereColliderComponent) {
    //     rigidbody := GetComponent(entity, RigidBodyComponent);
    //     if rigidbody {
    //         AddSphere(world, entity, rigidbody, sphere);
    //     }
    // }

    // OnDestroy :: (world : *World, sphere : *SphereColliderComponent) {
    //     rigidbody := GetComponent(entity, RigidBodyComponent);
    //     if rigidbody {
    //         RemoveSphere(world, entity, rigidbody, sphere);
    //     }
    // }

    OnDebugDraw :: (world : *World, entity : *Entity, using sphere : *SphereColliderComponent) {
        center := TranslationVector(world_transform);
        DebugDrawSphereOutline(world, .{0,1,0,1}, center, radius);
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
        DebugDrawCapsuleOutline(world, .{0,1,0,1}, center - up * height * 0.5, center + up * height * 0.5, radius);
    }
} @Component @Category(Physics/Colliders)

AllCapsuleColliderComponents :: #bake_arguments AllEntityComponents(T=CapsuleColliderComponent);

BoxColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    half_extents : Vec3f = .{1,1,1}; @Serialize(2)
    density : float = 1; @Serialize(3)
    margin : float = 0.01; @Serialize(4)

    OnDebugDraw :: (world : *World, entity : *Entity, using box : *BoxColliderComponent) {
        DebugDrawBoxOutline(world, .{0,1,0,1}, .{0,0,0}, half_extents, world_transform);
    }
} @Component @Category(Physics/Colliders)

AllBoxColliderComponents :: #bake_arguments AllEntityComponents(T=BoxColliderComponent);

MeshColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    mesh : *Asset(StaticMesh); @Serialize(2)
} @Component @Category(Physics/Colliders)

AllMeshColliderComponents :: #bake_arguments AllEntityComponents(T=MeshColliderComponent);
