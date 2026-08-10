Jolt :: #import "JoltPhysics";

Log_Physics :: Log_Section.{"Physics"};

JoltSettings :: struct {
    max_bodies : u32 = 10000;
    num_body_mutexes : u32;
    max_body_pairs : u32 = 10000;
    max_contact_constraints : u32 = 1000;
    target_updates_per_seconds : u32 = 60;
    num_collision_steps : u32 = 1;
    temp_allocator_size : u32 = 2 * 1024 * 1024;
    max_jobs : u32 = 2048;
    max_job_system_barriers : u32 = 8;
    num_job_system_threads : s32 = -1;
}

PhysicsSettings :: struct {
    collision_layer_matrix : [Physics_Num_Collision_Layers][Physics_Num_Collision_Layers]bool;
}

PhysicsCollisionLayer :: enum Jolt.ObjectLayer {
    NonMoving;
    Moving;
    Foliage;
}

Physics_Num_Collision_Layers :: #run type_info(PhysicsCollisionLayer).names.count;

// We can't have more layers than there are bits in the collision layer (see PhysicsCollisionLayerMask)
#assert Physics_Num_Collision_Layers <= size_of(PhysicsCollisionLayer) * 8;

PhysicsBroadPhaseLayer :: enum Jolt.BroadPhaseLayer {
    NonMoving;
    Moving;
}

Physics_Num_Broad_Phase_Layers ::  #run type_info(PhysicsBroadPhaseLayer).names.count;

PhysicsCollisionLayerMask :: enum_flags Jolt.ObjectLayer {
    #insert -> string {
        builder : StringBuilder;

        info := type_info(PhysicsCollisionLayer);
        for info.names {
            Appendln(*builder, "    %1 :: 1 << PhysicsCollisionLayer.%1;", it);
        }

        return StringBuilderBuild(*builder);
    };

    All :: ~cast(Jolt.ObjectLayer, 0);
}

PhysicsGlobals :: struct {
    debug_draw_settings : PhysicsDebugDrawSettings;
    debug_renderer : *Jolt.DebugRenderer;
    debug_renderer_target_world : *World;
}

PhysicsDebugDrawSettings :: struct {
    enabled := false; @Serialize(9)
    enabled_in_editor := false; @Serialize(10)
    draw_colliders := true; @Serialize(1)
    draw_colliders_wireframe := true; @Serialize(2)
    collider_color := Jolt.BodyManager.EShapeColor.SleepColor; @Serialize(3)
    draw_bounding_box := false; @Serialize(4)
    draw_center_of_mass_transform := false; @Serialize(5)
    draw_world_transform := false; @Serialize(6)
    draw_velocity := false; @Serialize(7)
    draw_mass_and_inertia := false; @Serialize(8)
}

PhysicsWorld :: struct {
    system : *Jolt.PhysicsSystem;
    temp_allocator : *Jolt.TempAllocator;
    job_system : *Jolt.JobSystem;
    body_interface : *Jolt.BodyInterface;
    broad_phase_layer_interface : *Jolt.BroadPhaseLayerInterfaceTable;
    object_vs_broad_phase_layer_filter : *Jolt.ObjectVsBroadPhaseLayerFilterTable;
    object_vs_object_layer_filter : *Jolt.ObjectLayerPairFilterTable;
}

RayCastSettings :: struct {
    layer_mask := PhysicsCollisionLayerMask.All;
    flags : enum_flags {
        RetrieveColliders;
        ComputeNormals;
    };
}

RayCastResult :: struct {
    hit : bool;
    point : Vec3f;
    normal : Vec3f;
    dist := F32_Inf;
    entity : *Entity;
    rigid_body : *RigidBodyComponent;
    collider : *Component;
}

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

    layer := PhysicsCollisionLayer.NonMoving; @Serialize(2)
    motion_type := PhysicsMotionType.Static; @Serialize(3)
    motion_quality := PhysicsMotionQuality.Discrete; @Serialize(5)
    activate_on_create := true; @Serialize(4)
    jolt_body_id : Jolt.BodyID;
    jolt_shape : *Jolt.Shape;

    OnSpawn :: (world : *World, entity : *Entity, using rigid_body : *RigidBodyComponent) {
        CreateRigidBody(world, entity, rigid_body);
    }

    OnDespawn :: (world : *World, using body : *RigidBodyComponent) {
        DestroyRigidBody(world, body);
    }
} @Component @Category(Physics)

CreateRigidBody :: (world : *World, entity : *Entity, using rigid_body : *RigidBodyComponent) {
    LogSectionScope(*Log_Physics);

    if jolt_body_id != Jolt.cInvalidBodyID {
        DestroyRigidBody(world, rigid_body);
    }

    compound_subshapes : [..]Jolt.CompoundShapeSettings.SubShapeSettings;

    for :AllSphereColliderComponents entity {
        if it.jolt_shape {
            ArrayPush(*compound_subshapes, .{shape=it.jolt_shape, position=ToJolt(it.local_position), rotation=ToJolt(it.local_rotation)});
        }
    }
    for :AllCapsuleColliderComponents entity {
        if it.jolt_shape {
            ArrayPush(*compound_subshapes, .{shape=it.jolt_shape, position=ToJolt(it.local_position), rotation=ToJolt(it.local_rotation)});
        }
    }
    for :AllBoxColliderComponents entity {
        if it.jolt_shape {
            ArrayPush(*compound_subshapes, .{shape=it.jolt_shape, position=ToJolt(it.local_position), rotation=ToJolt(it.local_rotation)});
        }
    }
    for :AllPlaneColliderComponents entity {
        if it.jolt_shape {
            ArrayPush(*compound_subshapes, .{shape=it.jolt_shape, position=ToJolt(it.local_position), rotation=ToJolt(it.local_rotation)});
        }
    }

    if compound_subshapes.count > 1 {
        compound_shape_settings := Jolt.StaticCompoundShapeSettings.{
            numSubShapes=xx compound_subshapes.count,
            subShapes=compound_subshapes.data,
        };

        jolt_shape = compound_shape_settings.CreateShape(*compound_shape_settings);
    } else if compound_subshapes.count > 0 {
        rotated_translated := Jolt.RotatedTranslatedShapeSettings.{
            innerShape=compound_subshapes[0].shape,
            position=compound_subshapes[0].position,
            rotation=compound_subshapes[0].rotation,
        };

        jolt_shape = rotated_translated.CreateShape(*rotated_translated);
    } else {
        empty_settings : Jolt.EmptyShapeSettings;

        jolt_shape = empty_settings.CreateShape(*empty_settings);
    }

    world_position := TranslationVector(entity.world_transform);
    world_rotation := QuatfFromMatrix(entity.world_transform);

    jolt_motion_type : Jolt.EMotionType;
    if #complete motion_type == {
    case .Static;    jolt_motion_type = .Static;
    case .Kinematic; jolt_motion_type = .Kinematic;
    case .Dynamic;   jolt_motion_type = .Dynamic;
    }

    jolt_motion_quality : Jolt.EMotionQuality;
    if #complete motion_quality == {
    case .Discrete;   jolt_motion_quality = .Discrete;
    case .Continuous; jolt_motion_quality = .LinearCast;
    }

    body_settings := Jolt.BodyCreationSettings.Default();
    body_settings.position = ToJolt(world_position);
    body_settings.rotation = xx,force world_rotation;
    body_settings.motionType = jolt_motion_type;
    body_settings.motionQuality = jolt_motion_quality;
    body_settings.objectLayer = xx layer;
    body_settings.shapePtr = jolt_shape;

    body := Jolt.BodyInterface.CreateBody(world.physics.body_interface, *body_settings);
    body.SetUserData(body, xx rigid_body);

    jolt_body_id = body.GetID(body);
    Jolt.BodyInterface.AddBody(world.physics.body_interface, jolt_body_id, ifx activate_on_create then .Activate else .DontActivate);

    LogMessage("Created rigid body %: layer=%, motion_type=%, activate=%, num shapes=%", jolt_body_id, layer, motion_type, activate_on_create, compound_subshapes.count);
}

DestroyRigidBody :: (world : *World, using body : *RigidBodyComponent) {
    LogSectionScope(*Log_Physics);

    if jolt_body_id {
        Jolt.BodyInterface.RemoveBody(world.physics.body_interface, jolt_body_id);
        Jolt.BodyInterface.DestroyBody(world.physics.body_interface, jolt_body_id);
        LogMessage("Destroyed rigid body %", jolt_body_id);

        jolt_body_id = Jolt.cInvalidBodyID;
    }

    if jolt_shape {
        jolt_shape.Release(jolt_shape);
        jolt_shape = null;
    }
}

Collider_Color :: Vec4f.{0,1,0,1};

SphereColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    jolt_shape : *Jolt.Shape;
    density : float = 1000; @Serialize(3)
    radius : float = 0.5; @Serialize(2)

    RecreateJoltShape :: (world : *World, entity : *Entity, using sphere : *SphereColliderComponent) {
        if jolt_shape {
            jolt_shape.Release(jolt_shape);
            jolt_shape = null;
        }
        jolt_shape = CreateJoltShape(world, entity, sphere);
    }

    OnValidate :: (world : *World, entity : *Entity, using sphere : *SphereColliderComponent) {
        RecreateJoltShape(world, entity, sphere);
    }

    OnCreate :: (world : *World, entity : *Entity, using sphere : *SphereColliderComponent) {
        RecreateJoltShape(world, entity, sphere);
    }

    OnDestroy :: (world : *World, using sphere : *SphereColliderComponent) {
        if jolt_shape {
            jolt_shape.Release(jolt_shape);
            jolt_shape = null;
        }
    }

    OnDebugDrawSelected :: (world : *World, entity : *Entity, using sphere : *SphereColliderComponent) {
        if jolt_shape {
            jolt_shape.Draw(jolt_shape, GetPhysicsGlobals().debug_renderer, ToJolt(world_position_rotation_transform), Jolt.Vec3.Make(1,1,1), Jolt.Color_FromVec4(ToJolt(Collider_Color)), false, true);
        }
    }
} @Component @Category(Physics/Colliders)

AllSphereColliderComponents :: #bake_arguments AllEntityComponents(T=SphereColliderComponent);

CreateJoltShape :: (world : *World, entity : *Entity, sphere : *SphereColliderComponent) -> *Jolt.Shape {
    if sphere.radius <= 0 {
        return null;
    }

    settings := Jolt.SphereShapeSettings.{
        density=sphere.density,
        radius=sphere.radius,
    };

    shape := settings.CreateShape(*settings);
    if !shape {
        return null;
    }

    shape.SetUserData(shape, xx sphere);

    world_scale := GetWorldScale(world, entity, sphere);
    if world_scale != .{1,1,1} {
        if !shape.IsValidScale(shape, ToJolt(world_scale)) {
            LogWarning("Invalid scale % for sphere collider", world_scale);
        }

        shape = shape.ScaleShape(shape, ToJolt(world_scale));
        if !shape {
            return null;
        }

        shape.SetUserData(shape, xx sphere);
    }

    return shape;
}

CapsuleColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    jolt_shape : *Jolt.Shape;
    density : float = 1000; @Serialize(4)
    height : float = 2; @Serialize(2)
    radius : float = 0.5; @Serialize(3)

    RecreateJoltShape :: (world : *World, entity : *Entity, using capsule : *CapsuleColliderComponent) {
        if jolt_shape {
            jolt_shape.Release(jolt_shape);
            jolt_shape = null;
        }
        jolt_shape = CreateJoltShape(world, entity, capsule);
    }

    OnValidate :: (world : *World, entity : *Entity, using capsule : *CapsuleColliderComponent) {
        RecreateJoltShape(world, entity, capsule);
    }

    OnCreate :: (world : *World, entity : *Entity, using capsule : *CapsuleColliderComponent) {
        RecreateJoltShape(world, entity, capsule);
    }

    OnDestroy :: (world : *World, using capsule : *CapsuleColliderComponent) {
        if jolt_shape {
            jolt_shape.Release(jolt_shape);
            jolt_shape = null;
        }
    }

    OnDebugDrawSelected :: (world : *World, entity : *Entity, using capsule : *CapsuleColliderComponent) {
        if jolt_shape {
            jolt_shape.Draw(jolt_shape, GetPhysicsGlobals().debug_renderer, ToJolt(world_position_rotation_transform), Jolt.Vec3.Make(1,1,1), Jolt.Color_FromVec4(ToJolt(Collider_Color)), false, true);
        }
    }
} @Component @Category(Physics/Colliders)

AllCapsuleColliderComponents :: #bake_arguments AllEntityComponents(T=CapsuleColliderComponent);

CreateJoltShape :: (world : *World, entity : *Entity, capsule : *CapsuleColliderComponent) -> *Jolt.Shape {
    if capsule.radius <= 0 || capsule.height * 0.5 <= capsule.radius {
        return null;
    }

    settings := Jolt.CapsuleShapeSettings.{
        density=capsule.density,
        halfHeightOfCylinder=capsule.height * 0.5 - capsule.radius,
        radius=capsule.radius,
    };

    shape := settings.CreateShape(*settings);
    if !shape {
        return null;
    }

    shape.SetUserData(shape, xx capsule);

    world_scale := GetWorldScale(world, entity, capsule);
    if world_scale != .{1,1,1} {
        if !shape.IsValidScale(shape, ToJolt(world_scale)) {
            LogWarning("Invalid scale % for capsule collider", world_scale);
        }

        shape = shape.ScaleShape(shape, ToJolt(world_scale));
        if !shape {
            return null;
        }

        shape.SetUserData(shape, xx capsule);
    }

    return shape;
}

BoxColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    jolt_shape : *Jolt.Shape;
    density : float = 1000; @Serialize(3)
    half_extents : Vec3f = .{0.5,0.5,0.5}; @Serialize(2)
    margin : float = 0.01; @Serialize(4)

    RecreateJoltShape :: (world : *World, entity : *Entity, using box : *BoxColliderComponent) {
        if jolt_shape {
            jolt_shape.Release(jolt_shape);
            jolt_shape = null;
        }
        jolt_shape = CreateJoltShape(world, entity, box);
    }

    OnValidate :: (world : *World, entity : *Entity, using box : *BoxColliderComponent) {
        RecreateJoltShape(world, entity, box);
    }

    OnCreate :: (world : *World, entity : *Entity, using box : *BoxColliderComponent) {
        RecreateJoltShape(world, entity, box);
    }

    OnDestroy :: (world : *World, using box : *BoxColliderComponent) {
        if jolt_shape {
            jolt_shape.Release(jolt_shape);
            jolt_shape = null;
        }
    }

    OnDebugDrawSelected :: (world : *World, entity : *Entity, using box : *BoxColliderComponent) {
        if jolt_shape {
            jolt_shape.Draw(jolt_shape, GetPhysicsGlobals().debug_renderer, ToJolt(world_position_rotation_transform), Jolt.Vec3.Make(1,1,1), Jolt.Color_FromVec4(ToJolt(Collider_Color)), false, true);
        }
    }
} @Component @Category(Physics/Colliders)

AllBoxColliderComponents :: #bake_arguments AllEntityComponents(T=BoxColliderComponent);

CreateJoltShape :: (world : *World, entity : *Entity, box : *BoxColliderComponent) -> *Jolt.Shape {
    if box.half_extents.x <= 0 || box.half_extents.y <= 0 || box.half_extents.z <= 0 {
        return null;
    }

    settings := Jolt.BoxShapeSettings.{
        density=box.density,
        halfExtent=ToJolt(box.half_extents),
        convexRadius=box.margin,
    };

    shape := settings.CreateShape(*settings);
    if !shape {
        return null;
    }

    shape.SetUserData(shape, xx box);

    world_scale := GetWorldScale(world, entity, box);
    if world_scale != .{1,1,1} {
        if !shape.IsValidScale(shape, ToJolt(world_scale)) {
            LogWarning("Invalid scale % for box collider", world_scale);
        }

        shape = shape.ScaleShape(shape, ToJolt(world_scale));
        if !shape {
            return null;
        }

        shape.SetUserData(shape, xx box);
    }

    return shape;
}

PlaneColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    jolt_shape : *Jolt.Shape;
    half_extent : float = 1; @Serialize(2)

    RecreateJoltShape :: (world : *World, entity : *Entity, using plane : *PlaneColliderComponent) {
        if jolt_shape {
            jolt_shape.Release(jolt_shape);
            jolt_shape = null;
        }
        jolt_shape = CreateJoltShape(world, entity, plane);
    }

    OnValidate :: (world : *World, entity : *Entity, using plane : *PlaneColliderComponent) {
        RecreateJoltShape(world, entity, plane);
    }

    OnCreate :: (world : *World, entity : *Entity, using plane : *PlaneColliderComponent) {
        RecreateJoltShape(world, entity, plane);
    }

    OnDestroy :: (world : *World, using plane : *PlaneColliderComponent) {
        if jolt_shape {
            jolt_shape.Release(jolt_shape);
            jolt_shape = null;
        }
    }

    OnDebugDrawSelected :: (world : *World, entity : *Entity, using plane : *PlaneColliderComponent) {
        if jolt_shape {
            jolt_shape.Draw(jolt_shape, GetPhysicsGlobals().debug_renderer, ToJolt(world_position_rotation_transform), Jolt.Vec3.Make(1,1,1), Jolt.Color_FromVec4(ToJolt(Collider_Color)), false, true);
        }
    }
} @Component @Category(Physics/Colliders)

AllPlaneColliderComponents :: #bake_arguments AllEntityComponents(T=PlaneColliderComponent);

CreateJoltShape :: (world : *World, entity : *Entity, plane : *PlaneColliderComponent) -> *Jolt.Shape {
    if plane.half_extent <= 0 {
        return null;
    }

    p := Jolt.Plane.FromPointAndNormal(ToJolt(plane.local_position), ToJolt(UpVector(plane.local_rotation)));

    settings := Jolt.PlaneShapeSettings.{
        plane=p,
        halfExtent=plane.half_extent,
    };

    shape := settings.CreateShape(*settings);
    if !shape {
        return null;
    }

    shape.SetUserData(shape, xx plane);

    world_scale := GetWorldScale(world, entity, plane);
    if world_scale != .{1,1,1} {
        if !shape.IsValidScale(shape, ToJolt(world_scale)) {
            LogWarning("Invalid scale % for plane collider", world_scale);
        }

        shape = shape.ScaleShape(shape, ToJolt(world_scale));
        if !shape {
            return null;
        }

        shape.SetUserData(shape, xx plane);
    }

    return shape;
}

MeshColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    mesh : *Asset(StaticMesh); @Serialize(2)
} @Component @Category(Physics/Colliders)

AllMeshColliderComponents :: #bake_arguments AllEntityComponents(T=MeshColliderComponent);

ToJolt :: inline (v : Vec4u) -> Jolt.UVec4 #no_context {
    return .{x=v.x, y=v.y, z=v.z, w==v.w};
}

FromJolt :: inline (v : Jolt.UVec4) -> Vec4u #no_context {
    return .{x=v.x, y=v.y, z=v.z, w=v.w};
}

ToJolt :: inline (v : Vec3f) -> Jolt.Vec3 #no_context {
    return .{x=v.x, y=v.y, z=v.z, values[3]=v.z};
}

FromJolt :: inline (v : Jolt.Vec3) -> Vec3f #no_context {
    return .{x=v.x, y=v.y, z=v.z};
}

ToJolt :: inline (v : Vec4f) -> Jolt.Vec4 #no_context {
    return .{x=v.x, y=v.y, z=v.z, w=v.w};
}

FromJolt :: inline (v : Jolt.Vec4) -> Vec4f #no_context {
    return .{x=v.x, y=v.y, z=v.z, w=v.w};
}

ToJolt :: inline (m : Mat4f) -> Jolt.Mat44 #no_context {
    return .{
        cols[0].x=m.r0c0, cols[0].y=m.r1c0, cols[0].z=m.r2c0, cols[0].w=m.r3c0,
        cols[1].x=m.r0c1, cols[1].y=m.r1c1, cols[1].z=m.r2c1, cols[1].w=m.r3c1,
        cols[2].x=m.r0c2, cols[2].y=m.r1c2, cols[2].z=m.r2c2, cols[2].w=m.r3c2,
        cols[3].x=m.r0c3, cols[3].y=m.r1c3, cols[3].z=m.r2c3, cols[3].w=m.r3c3,
    };
}

FromJolt :: inline (m : Jolt.Mat44) -> Mat4f #no_context {
    return .{
        m.cols[0].x, m.cols[1].x, m.cols[2].x, m.cols[3].x,
        m.cols[0].y, m.cols[1].y, m.cols[2].y, m.cols[3].y,
        m.cols[0].z, m.cols[1].z, m.cols[2].z, m.cols[3].z,
        m.cols[0].w, m.cols[1].w, m.cols[2].w, m.cols[3].w,
    };
}

ToJolt :: inline (v : Quatf) -> Jolt.Quat #no_context {
    return .{x=v.x, y=v.y, z=v.z, w=v.w};
}

FromJolt :: inline (v : Jolt.Quat) -> Quatf #no_context {
    return .{x=v.x, y=v.y, z=v.z, w=v.w};
}

ToJolt :: inline (v : Vec3d) -> Jolt.DVec3 #no_context {
    return .{x=v.x, y=v.y, z=v.z, values[3]=v.z};
}

FromJolt :: inline (v : Jolt.DVec3) -> Vec3d #no_context {
    return .{x=v.x, y=v.y, z=v.z};
}

ToJolt :: inline (m : Mat4d) -> Jolt.DMat44 #no_context {
    return .{
        cols[0].x=m.r0c0, cols[0].y=m.r1c0, cols[0].z=m.r2c0, cols[0].w=m.r3c0,
        cols[1].x=m.r0c1, cols[1].y=m.r1c1, cols[1].z=m.r2c1, cols[1].w=m.r3c1,
        cols[2].x=m.r0c2, cols[2].y=m.r1c2, cols[2].z=m.r2c2, cols[2].w=m.r3c2,
        col3.x=m.r0c3, col3.y=m.r1c3, col3.z=m.r2c3, col3.w=1,
    };
}

FromJolt :: inline (m : Jolt.DMat44) -> Mat4d #no_context {
    return .{
        cols[0].x, cols[1].x, cols[2].x, col3.x,
        cols[0].y, cols[1].y, cols[2].y, col3.y,
        cols[0].z, cols[1].z, cols[2].z, col3.z,
        cols[0].w, cols[1].w, cols[2].w, 1,
    };
}
