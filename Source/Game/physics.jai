g_physics : PhysicsGlobals;

GetPhysicsGlobals :: () -> *PhysicsGlobals {
    return *g_physics;
} @ModuleAPI

GetPhysicsGlobalSettings :: () -> *PhysicsGlobalSettings {
    return *g_physics.settings;
} @ModuleAPI

GetPhysicsDebugDrawSettings :: () -> *PhysicsDebugDrawSettings {
    return *g_physics.debug_draw_settings;
} @ModuleAPI

SetPhysicsDebugRendererTarget :: (world : *World) {
    g_physics.debug_renderer_target_world = world;
} @ModuleAPI

InitPhysics :: () {
    LogSectionScope(*Log_Physics);

    using g_physics;

    debug_renderer_funcs := Jolt.DebugRendererSimple.Funcs.{
        DrawLine = (user_data : *void, from : Jolt.RVec3, to : Jolt.RVec3, color : Jolt.Color) #c_call {
            if !g_physics.debug_renderer_target_world {
                return;
            }

            push_context,defer_pop;

            rgba := cast(*u8, *color);

            world := g_physics.debug_renderer_target_world;
            DebugDrawLine(world, .{rgba[0] / 255.0, rgba[1] / 255.0, rgba[2] / 255.0, rgba[3] / 255.0}, FromJolt(from), FromJolt(to));
        }
    };
    debug_renderer = Jolt.DebugRendererSimple.Create(null, debug_renderer_funcs, .{});
}

ShutdownPhysics :: () {
    Jolt.DebugRenderer.Destroy(g_physics.debug_renderer);
}

GetPhysicsCollisionLayersMatrixIndex :: (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) -> int {
    if a < b {
        Swap(*a, *b);
    }

    first_index_of_row := cast(int, a + 1) * cast(int, a + 2) / 2;
    index := Physics_Collision_Layer_Matrix_Size - first_index_of_row + cast(int, b);

    return index;
}

EnablePhysicsCollisionLayersCollision :: (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) {
    index := GetPhysicsCollisionLayersMatrixIndex(a, b);
    g_physics.settings.collision_layer_matrix[index] = true;
} @ModuleAPI

DisablePhysicsCollisionLayersCollision :: (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) {
    index := GetPhysicsCollisionLayersMatrixIndex(a, b);
    g_physics.settings.collision_layer_matrix[index] = false;
} @ModuleAPI

ShouldPhysicsCollisionLayersCollide :: (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) -> bool {
    index := GetPhysicsCollisionLayersMatrixIndex(a, b);

    return g_physics.settings.collision_layer_matrix[index];
} @ModuleAPI

UpdatePhysicsCollisionLayerMatrix :: () {
    using g_physics;
} @ModuleAPI

InitPhysicsWorld :: (world : *World) {
    LogSectionScope(*Log_Physics);

    using world.physics;

    temp_allocator = Jolt.TempAllocatorImpl.Create(5 * 1024 * 1024);

    job_system = Jolt.JobSystemThreadPool.Create(Jolt.cMaxPhysicsJobs, Jolt.cMaxPhysicsBarriers, -1);

    broad_phase_layer_interface = Jolt.BroadPhaseLayerInterfaceTable.Create(Physics_Num_Collision_Layers, Physics_Num_Broad_Phase_Layers);
    broad_phase_layer_interface.MapObjectToBroadPhaseLayer(broad_phase_layer_interface, xx PhysicsCollisionLayer.NonMoving, xx PhysicsBroadPhaseLayer.NonMoving);
    broad_phase_layer_interface.MapObjectToBroadPhaseLayer(broad_phase_layer_interface, xx PhysicsCollisionLayer.Foliage, xx PhysicsBroadPhaseLayer.NonMoving);
    broad_phase_layer_interface.MapObjectToBroadPhaseLayer(broad_phase_layer_interface, xx PhysicsCollisionLayer.Moving, xx PhysicsBroadPhaseLayer.Moving);

    #if Jolt.EXTERNAL_PROFILE || Jolt.PROFILE_ENABLED {
        for type_info(PhysicsBroadPhaseLayer).names {
            broad_phase_layer_interface.SetBroadPhaseLayerName(broad_phase_layer_interface, xx type_info(PhysicsBroadPhaseLayer).values[it_index], xx it.data);
        }
    }

    object_vs_object_layer_filter = Jolt.ObjectLayerPairFilterTable.Create(Physics_Num_Collision_Layers);
    object_vs_object_layer_filter.EnableCollision(object_vs_object_layer_filter, xx PhysicsCollisionLayer.Moving, xx PhysicsCollisionLayer.NonMoving);
    object_vs_object_layer_filter.EnableCollision(object_vs_object_layer_filter, xx PhysicsCollisionLayer.Moving, xx PhysicsCollisionLayer.Moving);

    object_vs_broad_phase_layer_filter = Jolt.ObjectVsBroadPhaseLayerFilterTable.Create(broad_phase_layer_interface, Physics_Num_Broad_Phase_Layers, object_vs_object_layer_filter, Physics_Num_Collision_Layers);

    system_settings := Jolt.PhysicsSystemSettings.{
        maxBodies=Physics_Max_Bodies,
        numBodyMutexes=Physics_Num_Body_Mutexes,
        maxBodyPairs=Physics_Max_Body_Pairs,
        maxContactConstraints=Physics_Max_Contact_Constraints,
        broadPhaseLayerInterface=broad_phase_layer_interface,
        objectLayerPairFilter=object_vs_object_layer_filter,
        objectVsBroadPhaseLayerFilter=object_vs_broad_phase_layer_filter,
    };
    system = Jolt.PhysicsSystem.Create(system_settings);

    body_interface = Jolt.PhysicsSystem.GetBodyInterface(system);

    LogMessage("Initialized physics system");
}

DestroyPhysicsWorld :: (world : *World) {
    using world.physics;

    Jolt.ObjectVsBroadPhaseLayerFilter.Destroy(object_vs_broad_phase_layer_filter);
    Jolt.ObjectLayerPairFilter.Destroy(object_vs_object_layer_filter);
    Jolt.BroadPhaseLayerInterface.Destroy(broad_phase_layer_interface);
    Jolt.PhysicsSystem.Destroy(system);
    Jolt.JobSystem.Destroy(job_system);
    Jolt.TempAllocator.Destroy(temp_allocator);

    system = null;
    job_system = null;
}

PhysicsDebugRendererNextFrame :: () {
    Jolt.DebugRenderer.NextFrame(g_physics.debug_renderer);
} @ModuleAPI

DebugDrawPhysicsBodies :: (world : *World, settings : PhysicsDebugDrawSettings) {
    draw_settings : Jolt.BodyManager.DrawSettings;
    draw_settings.drawShape = settings.draw_colliders;
    draw_settings.drawShapeWireframe = settings.draw_colliders_wireframe;
    draw_settings.drawShapeColor = settings.collider_color;
    draw_settings.drawBoundingBox = settings.draw_bounding_box;
    draw_settings.drawCenterOfMassTransform = settings.draw_center_of_mass_transform;
    draw_settings.drawWorldTransform = settings.draw_world_transform;
    draw_settings.drawVelocity = settings.draw_velocity;
    draw_settings.drawMassAndInertia = settings.draw_mass_and_inertia;

    SetPhysicsDebugRendererTarget(world);
    Jolt.PhysicsSystem.DrawBodies(world.physics.system, *draw_settings, g_physics.debug_renderer, null);
} @ModuleAPI

UpdatePhysicsWorld :: (world : *World) {
    using world.physics;

    Jolt.PhysicsSystem.Update(system, Physics_Delta_Time, Physics_Num_Collision_Steps, temp_allocator, job_system);

    if g_physics.debug_draw_settings.enabled {
        DebugDrawPhysicsBodies(world, g_physics.debug_draw_settings);
    }

    for * world.RigidBodyComponent_storage {
        if !Jolt.BodyInterface.IsActive(body_interface, it.jolt_body_id) {
            continue;
        }

        entity := GetEntity(world, it.entity_index);

        world_transform := cast,force(Mat4f, Jolt.BodyInterface.GetWorldTransform(body_interface, it.jolt_body_id));

        world_transform = Transposed(world_transform);
        SetWorldTransformNoScale(world, entity, world_transform);
    }
} @ModuleAPI

UpdateWorldTransform :: (world : *World, entity : *Entity, using rigidbody : *RigidBodyComponent) {
    world_rotation := QuatfFromMatrix(entity.world_transform);
    world_position := TranslationVector(entity.world_transform);

    Jolt.BodyInterface.SetPositionAndRotation(world.physics.body_interface, jolt_body_id, ToJolt(world_position), ToJolt(world_rotation), .DontActivate);
} @ModuleAPI

CastRay :: (world : *World, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float) -> RayCastResult {
    if !world.physics.system {
        return .{};
    }

    ray_vector := ray_direction * ray_length;

    ray : Jolt.RRayCast;
    ray.origin = ToJolt(ray_origin);
    ray.direction = ToJolt(ray_vector);

    result := Jolt.RayCastResult.Default();

    narrow_phase := Jolt.PhysicsSystem.GetNarrowPhaseQuery(world.physics.system);
    hit := Jolt.NarrowPhaseQuery.CastRayClosest(narrow_phase, ray, *result, null, null, null);

    if !hit {
        return .{};
    }

    point := Jolt.RRayCast.GetPointOnRay(*ray, result.fraction);

    collider : *Component;
    rigid_body : *RigidBodyComponent;

    normal : Vec3f;

    body_lock_read : Jolt.BodyLockRead;
    {
        // Happens in between physics update, so we use the NoLock interface
        body_lock_interface := Jolt.PhysicsSystem.GetBodyLockInterfaceNoLock(world.physics.system);
        Jolt.BodyLockInterface.LockRead(body_lock_interface, result.bodyID, *body_lock_read);
        defer Jolt.BodyLockInterface.UnlockRead(body_lock_interface, *body_lock_read);

        if body_lock_read.body {
            rigid_body = cast(*RigidBodyComponent, Jolt.Body.GetUserData(body_lock_read.body));

            normal = FromJolt(Jolt.Body.GetWorldSpaceSurfaceNormal(body_lock_read.body, result.subShapeID2, point));

            shape := Jolt.Body.GetShape(body_lock_read.body);

            remainder_shape_id : Jolt.SubShapeID;
            subshape := Jolt.Shape.GetLeafShape(shape, result.subShapeID2, *remainder_shape_id);
            if subshape {
                shape = subshape;
            }

            collider = cast(*Component, Jolt.Shape.GetUserData(shape));
        }
    }

    return .{
        hit=true,
        point=FromJolt(point),
        normal=normal,
        dist=Length(FromJolt(point) - ray_origin),
        entity=ifx collider then GetEntity(world, collider.entity_index) else ifx rigid_body then GetEntity(world, rigid_body.entity_index),
        collider=collider,
    };
} @ModuleAPI
