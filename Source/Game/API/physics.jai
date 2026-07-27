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

PhysicsCollisionLayer :: enum u32 {
    Default;
    Foliage;
}

Physics_Num_Collision_Layers :: #run type_info(PhysicsCollisionLayer).names.count;

#insert -> string {
    builder : StringBuilder;

    Appendln(*builder, "PhysicsCollisionLayerFlags :: enum_flags u32 {");

    info := type_info(PhysicsCollisionLayer);
    for info.names {
        Appendln(*builder, "    %1 :: 1 << PhysicsCollisionLayer.%1;", it);
    }

    Appendln(*builder, "}");

    return StringBuilderBuild(*builder);
}

// Triangular number with N = Physics_Num_Collision_Layers
Physics_Collision_Layer_Matrix_Size :: #run (Physics_Num_Collision_Layers * (Physics_Num_Collision_Layers + 1)) / 2;

PhysicsSettings :: struct {
    collision_layer_matrix : [Physics_Collision_Layer_Matrix_Size]bool;
}

PhysicsGlobals :: struct {
    settings : PhysicsSettings;
    debug_draw_settings : PhysicsDebugDrawSettings;
    debug_renderer : *Jolt.DebugRenderer;
    debug_renderer_target_world : *World;
}

PhysicsDebugDrawSettings :: struct {
    enabled := false; @Serialize(9)
    draw_colliders := true; @Serialize(1)
    draw_colliders_wireframe := true; @Serialize(2)
    collider_color := Jolt.BodyManager_EShapeColor.SleepColor; @Serialize(3)
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
    broad_phase_layer_interface : *Jolt.BroadPhaseLayerInterface;
    object_vs_broad_phase_layer_filter : *Jolt.ObjectVsBroadPhaseLayerFilter;
    object_vs_object_layer_filter : *Jolt.ObjectLayerPairFilter;
}

RayCastResult :: struct {
    hit : bool;
    point : Vec3f;
    normal : Vec3f;
    dist := F32_Inf;
    entity : *Entity;
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

    layer := PhysicsCollisionLayer.Default; @Serialize(2)
    motion_type := PhysicsMotionType.Dynamic; @Serialize(3)
    motion_quality := PhysicsMotionQuality.Discrete; @Serialize(5)
    activate_on_create := true; @Serialize(4)
    jolt_body_id : Jolt.BodyID;

    OnSpawn :: (world : *World, entity : *Entity, using rigid_body : *RigidBodyComponent) {
        LogSectionScope(*Log_Physics);

        shape_transforms : [..]struct{position : Jolt.Vec3; rotation : Jolt.Quat;};
        shape_transforms.allocator = Temp;
        shapes : [..]*Jolt.Shape;
        shapes.allocator = Temp;

        for :AllSphereColliderComponents entity {
            shape := CreateJoltShape(world, entity, it);
            ArrayPush(*shapes, shape);
            ArrayPush(*shape_transforms, .{ToJolt(it.local_position), xx,force it.local_rotation});
        }
        for :AllCapsuleColliderComponents entity {
            shape := CreateJoltShape(world, entity, it);
            ArrayPush(*shapes, shape);
            ArrayPush(*shape_transforms, .{ToJolt(it.local_position), xx,force it.local_rotation});
        }
        for :AllBoxColliderComponents entity {
            shape := CreateJoltShape(world, entity, it);
            ArrayPush(*shapes, shape);
            ArrayPush(*shape_transforms, .{ToJolt(it.local_position), xx,force it.local_rotation});
        }
        for :AllPlaneColliderComponents entity {
            shape := CreateJoltShape(world, entity, it);
            ArrayPush(*shapes, shape);
            ArrayPush(*shape_transforms, .{ToJolt(it.local_position), xx,force it.local_rotation});
        }

        final_shape : *Jolt.Shape;
        if shapes.count > 1 {
            compound_shape_settings := Jolt.StaticCompoundShapeSettings_Create();
            for shapes {
                transform := shape_transforms[it_index];
                Jolt.CompoundShapeSettings_AddShape(xx compound_shape_settings, transform.position, transform.rotation, it, 0);
            }

            final_shape = xx Jolt.ShapeSettings_CreateShape(xx compound_shape_settings);
        } else if shapes.count > 0 {
            transform := shape_transforms[0];
            rotated_translated := Jolt.RotatedTranslatedShapeSettings_Create();
            Jolt.RotatedTranslatedShapeSettings_SetInnerShape(rotated_translated, shapes[0]);
            Jolt.RotatedTranslatedShapeSettings_SetPosition(rotated_translated, transform.position);
            Jolt.RotatedTranslatedShapeSettings_SetRotation(rotated_translated, transform.rotation);

            final_shape = Jolt.ShapeSettings_CreateShape(xx rotated_translated);
        } else {
            empty_settings := Jolt.EmptyShapeSettings_Create();

            final_shape = Jolt.ShapeSettings_CreateShape(xx empty_settings);
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

        body_settings := Jolt.BodyCreationSettings_Default();
        body_settings.position = ToJolt(world_position);
        body_settings.rotation = xx,force world_rotation;
        body_settings.motionType = jolt_motion_type;
        body_settings.motionQuality = jolt_motion_quality;
        body_settings.objectLayer = xx layer;
        body_settings.shapePtr = final_shape;

        body := Jolt.BodyInterface_CreateBody(world.physics.body_interface, *body_settings);
        Jolt.Body_SetUserData(body, xx rigid_body);

        jolt_body_id = Jolt.Body_GetID(body);
        Jolt.BodyInterface_AddBody(world.physics.body_interface, jolt_body_id, ifx activate_on_create then .Activate else .DontActivate);

        LogMessage("Created rigid body %: layer=%, motion_type=%, activate=%, num shapes=%", jolt_body_id, layer, motion_type, activate_on_create, shapes.count);
    }

    OnDestroy :: (world : *World, using body : *RigidBodyComponent) {
        LogSectionScope(*Log_Physics);

        if jolt_body_id {
            Jolt.BodyInterface_RemoveBody(world.physics.body_interface, jolt_body_id);
            Jolt.BodyInterface_DestroyBody(world.physics.body_interface, jolt_body_id);
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

    OnDebugDrawSelected :: (world : *World, entity : *Entity, using sphere : *SphereColliderComponent) {
        center := TranslationVector(world_transform);
        right := RightVector(world_transform);
        up := UpVector(world_transform);
        forward := ForwardVector(world_transform);
        DebugDrawSphereOutline(world, Collider_Color, center, radius, right=right, up=up, forward=forward);
    }
} @Component @Category(Physics/Colliders)

AllSphereColliderComponents :: #bake_arguments AllEntityComponents(T=SphereColliderComponent);

CreateJoltShape :: (world : *World, entity : *Entity, sphere : *SphereColliderComponent) -> *Jolt.Shape {
    settings := Jolt.SphereShapeSettings_Create();
    Jolt.SphereShapeSettings_SetRadius(settings, sphere.radius);
    Jolt.ConvexShapeSettings_SetDensity(xx settings, sphere.density);

    shape : *Jolt.Shape = xx Jolt.SphereShapeSettings_CreateShape(settings);
    Jolt.Shape_SetUserData(shape, xx sphere);

    world_scale := GetWorldScale(world, entity, sphere);
    if world_scale != .{1,1,1} {
        if !Jolt.Shape_IsValidScale(xx shape, ToJolt(world_scale)) {
            LogWarning("Invalid scale % for sphere collider", world_scale);
        }

        shape = Jolt.Shape_ScaleShape(xx shape, ToJolt(world_scale));
        Jolt.Shape_SetUserData(shape, xx sphere);
    }

    return shape;
}

CapsuleColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    height : float = 2; @Serialize(2)
    radius : float = 0.5; @Serialize(3)
    density : float = 1; @Serialize(4)

    OnDebugDrawSelected :: (world : *World, entity : *Entity, using capsule : *CapsuleColliderComponent) {
        center := TranslationVector(world_transform);
        up := UpVector(world_transform);
        DebugDrawCapsuleOutline(world, Collider_Color, center - up * height * 0.5, center + up * height * 0.5, radius);
    }
} @Component @Category(Physics/Colliders)

AllCapsuleColliderComponents :: #bake_arguments AllEntityComponents(T=CapsuleColliderComponent);

CreateJoltShape :: (world : *World, entity : *Entity, capsule : *CapsuleColliderComponent) -> *Jolt.Shape {
    settings := Jolt.CapsuleShapeSettings_Create();
    Jolt.CapsuleShapeSettings_SetHalfHeightOfCylinder(settings, capsule.height * 0.5 - capsule.radius);
    Jolt.CapsuleShapeSettings_SetRadius(settings, capsule.radius);
    Jolt.ConvexShapeSettings_SetDensity(xx settings, capsule.density);

    shape : *Jolt.Shape = xx Jolt.CapsuleShapeSettings_CreateShape(settings);
    Jolt.Shape_SetUserData(shape, xx capsule);

    world_scale := GetWorldScale(world, entity, capsule);
    if world_scale != .{1,1,1} {
        if !Jolt.Shape_IsValidScale(xx shape, ToJolt(world_scale)) {
            LogWarning("Invalid scale % for capsule collider", world_scale);
        }

        shape = Jolt.Shape_ScaleShape(xx shape, ToJolt(world_scale));
        Jolt.Shape_SetUserData(shape, xx capsule);
    }

    return shape;
}

BoxColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    half_extents : Vec3f = .{0.5,0.5,0.5}; @Serialize(2)
    density : float = 1; @Serialize(3)
    margin : float = 0.01; @Serialize(4)

    OnDebugDrawSelected :: (world : *World, entity : *Entity, using box : *BoxColliderComponent) {
        DebugDrawBoxOutline(world, Collider_Color, .{0,0,0}, half_extents, world_transform);
    }
} @Component @Category(Physics/Colliders)

AllBoxColliderComponents :: #bake_arguments AllEntityComponents(T=BoxColliderComponent);

CreateJoltShape :: (world : *World, entity : *Entity, box : *BoxColliderComponent) -> *Jolt.Shape {
    settings := Jolt.BoxShapeSettings_Create();
    Jolt.BoxShapeSettings_SetHalfExtent(settings, ToJolt(box.half_extents));
    Jolt.BoxShapeSettings_SetConvexRadius(settings, box.margin);
    Jolt.ConvexShapeSettings_SetDensity(xx settings, box.density);

    shape : *Jolt.Shape = xx Jolt.BoxShapeSettings_CreateShape(settings);
    Jolt.Shape_SetUserData(shape, xx box);

    world_scale := GetWorldScale(world, entity, box);
    if world_scale != .{1,1,1} {
        if !Jolt.Shape_IsValidScale(xx shape, ToJolt(world_scale)) {
            LogWarning("Invalid scale % for box collider", world_scale);
        }

        shape = Jolt.Shape_ScaleShape(xx shape, ToJolt(world_scale));
        Jolt.Shape_SetUserData(shape, xx box);
    }

    return shape;
}

PlaneColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    half_extent : float = 1; @Serialize(2)

    OnDebugDrawSelected :: (world : *World, entity : *Entity, using plane : *PlaneColliderComponent) {
        DebugDrawBoxOutline(world, Collider_Color, .{0,0,0}, .{half_extent,0,half_extent}, world_transform);
    }
} @Component @Category(Physics/Colliders)

AllPlaneColliderComponents :: #bake_arguments AllEntityComponents(T=PlaneColliderComponent);

CreateJoltShape :: (world : *World, entity : *Entity, plane : *PlaneColliderComponent) -> *Jolt.Shape {
    p := Jolt.Plane_FromPointAndNormal(ToJolt(plane.local_position), ToJolt(UpVector(plane.local_rotation)));

    settings := Jolt.PlaneShapeSettings_Create();
    Jolt.PlaneShapeSettings_SetPlane(settings, p);
    Jolt.PlaneShapeSettings_SetHalfExtent(settings, plane.half_extent);

    shape : *Jolt.Shape = xx Jolt.PlaneShapeSettings_CreateShape(settings);
    Jolt.Shape_SetUserData(shape, xx plane);

    world_scale := GetWorldScale(world, entity, plane);
    if world_scale != .{1,1,1} {
        if !Jolt.Shape_IsValidScale(xx shape, ToJolt(world_scale)) {
            LogWarning("Invalid scale % for plane collider", world_scale);
        }

        shape = Jolt.Shape_ScaleShape(xx shape, ToJolt(world_scale));
        Jolt.Shape_SetUserData(shape, xx plane);
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
        cols[0].x, cols[1].x, cols[2].x, cols[3].x,
        cols[0].y, cols[1].y, cols[2].y, cols[3].y,
        cols[0].z, cols[1].z, cols[2].z, cols[3].z,
        cols[0].w, cols[1].w, cols[2].w, cols[3].w,
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
