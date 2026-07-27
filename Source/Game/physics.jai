g_physics : PhysicsGlobals;

GetPhysicsGlobals :: () -> *PhysicsGlobals {
    return *g_physics;
} @ModuleAPI

GetPhysicsSettings :: () -> *PhysicsSettings {
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

    debug_renderer_funcs := Jolt.DebugRendererSimple_Funcs.{
        DrawLine = (user_data : *void, from : Jolt.RVec3, to : Jolt.RVec3, color : Jolt.Color) #c_call {
            if !g_physics.debug_renderer_target_world {
                return;
            }

            push_context,defer_pop;

            rgba := cast(*u8, *color);

            world := g_physics.debug_renderer_target_world;
            DebugDrawLine(world, .{rgba[0] / 255.0, rgba[1] / 255.0, rgba[2] / 255.0, rgba[3] / 255.0}, Jolt.ToXYZ(from), Jolt.ToXYZ(to));
        }
    };
    debug_renderer = Jolt.DebugRendererSimple_Create(null, debug_renderer_funcs, .{});
}

ShutdownPhysics :: () {
    Jolt.DebugRenderer_Destroy(g_physics.debug_renderer);
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

    temp_allocator = Jolt.TempAllocatorImpl_Create(5 * 1024 * 1024);

    job_system = Jolt.JobSystemThreadPool_Create(Jolt.JPH_cMaxPhysicsJobs, Jolt.JPH_cMaxPhysicsBarriers, -1);

    broad_phase_layer_interface_funcs := Jolt.BroadPhaseLayerInterface_Funcs.{
        GetNumBroadPhaseLayers = (data : *void) -> u32 #c_call {
            return Physics_Num_Collision_Layers;
        },

        GetBroadPhaseLayer = (data : *void, layer : Jolt.ObjectLayer) -> Jolt.BroadPhaseLayer #c_call {
            return xx layer;
        },

        GetBroadPhaseLayerName = (data : *void, layer : Jolt.BroadPhaseLayer) -> *u8 #c_call {
            return type_info(PhysicsCollisionLayer).names[layer].data;
        }
    };
    broad_phase_layer_interface = Jolt.BroadPhaseLayerInterface_Create(null, broad_phase_layer_interface_funcs, .{});

    object_vs_object_layer_filter_funcs := Jolt.ObjectLayerPairFilter_Funcs.{
        ShouldCollide = (data : *void, layer1 : Jolt.ObjectLayer, layer2 : Jolt.ObjectLayer) -> bool #c_call {
            push_context,defer_pop;
            return ShouldPhysicsCollisionLayersCollide(xx layer1, xx layer2);
        }
    };
    object_vs_object_layer_filter = Jolt.ObjectLayerPairFilter_Create(null, object_vs_object_layer_filter_funcs, .{});

    object_vs_broad_phase_layer_filter_funcs := Jolt.ObjectVsBroadPhaseLayerFilter_Funcs.{
        ShouldCollide = (data : *void, layer1 : Jolt.ObjectLayer, layer2 : Jolt.BroadPhaseLayer) -> bool #c_call {
            push_context,defer_pop;
            return ShouldPhysicsCollisionLayersCollide(xx layer1, xx layer2);
        }
    };
    object_vs_broad_phase_layer_filter = Jolt.ObjectVsBroadPhaseLayerFilter_Create(null, object_vs_broad_phase_layer_filter_funcs, .{});

    system_settings := Jolt.PhysicsSystemSettings.{
        maxBodies=Physics_Max_Bodies,
        numBodyMutexes=Physics_Num_Body_Mutexes,
        maxBodyPairs=Physics_Max_Body_Pairs,
        maxContactConstraints=Physics_Max_Contact_Constraints,
        broadPhaseLayerInterface=broad_phase_layer_interface,
        objectLayerPairFilter=object_vs_object_layer_filter,
        objectVsBroadPhaseLayerFilter=object_vs_broad_phase_layer_filter,
    };
    system = Jolt.PhysicsSystem_Create(system_settings);

    body_interface = Jolt.PhysicsSystem_GetBodyInterface(system);

    LogMessage("Initialized physics system");
}

DestroyPhysicsWorld :: (world : *World) {
    using world.physics;

    Jolt.PhysicsSystem_Destroy(system);
    Jolt.JobSystem_Destroy(job_system);
    Jolt.TempAllocator_Destroy(temp_allocator);

    system = null;
    job_system = null;
}

UpdatePhysicsWorld :: (world : *World) {
    using world.physics;

    Jolt.PhysicsSystem_Update(system, Physics_Delta_Time, Physics_Num_Collision_Steps, temp_allocator, job_system);

    Jolt.DebugRenderer_NextFrame(g_physics.debug_renderer);

    if g_physics.debug_draw_settings.enabled {
        draw_settings : Jolt.BodyManager_DrawSettings;
        draw_settings.drawShape = g_physics.debug_draw_settings.draw_colliders;
        draw_settings.drawShapeWireframe = g_physics.debug_draw_settings.draw_colliders_wireframe;
        draw_settings.drawShapeColor = g_physics.debug_draw_settings.collider_color;
        draw_settings.drawBoundingBox = g_physics.debug_draw_settings.draw_bounding_box;
        draw_settings.drawCenterOfMassTransform = g_physics.debug_draw_settings.draw_center_of_mass_transform;
        draw_settings.drawWorldTransform = g_physics.debug_draw_settings.draw_world_transform;
        draw_settings.drawVelocity = g_physics.debug_draw_settings.draw_velocity;
        draw_settings.drawMassAndInertia = g_physics.debug_draw_settings.draw_mass_and_inertia;

        SetPhysicsDebugRendererTarget(world);
        Jolt.PhysicsSystem_DrawBodies(system, *draw_settings, g_physics.debug_renderer, null);
    }

    for * world.RigidBodyComponent_storage {
        if !Jolt.BodyInterface_IsActive(body_interface, it.jolt_body_id) {
            continue;
        }

        entity := GetEntity(world, it.entity_index);

        world_transform := cast,force(Mat4f, Jolt.BodyInterface_GetWorldTransform(body_interface, it.jolt_body_id));

        world_transform = Transposed(world_transform);
        SetWorldTransformNoScale(world, entity, world_transform);
    }
} @ModuleAPI

CastRay :: (world : *World, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float) -> RayCastResult {
    if !world.physics.system {
        return .{};
    }

    broad_phase_layer_filter_funcs := Jolt.BroadPhaseLayerFilter_Funcs.{
        ShouldCollide = (user_data : *void, layer : Jolt.BroadPhaseLayer) -> bool #c_call {
            return true;
        }
    };
    broad_phase_layer_filter := Jolt.BroadPhaseLayerFilter_Create(null, broad_phase_layer_filter_funcs, .{});
    defer Jolt.BroadPhaseLayerFilter_Destroy(broad_phase_layer_filter);

    object_layer_filter_funcs := Jolt.ObjectLayerFilter_Funcs.{
        ShouldCollide = (user_data : *void, layer : Jolt.ObjectLayer) -> bool #c_call {
            return true;
        }
    };
    object_layer_filter := Jolt.ObjectLayerFilter_Create(null, object_layer_filter_funcs, .{});
    defer Jolt.ObjectLayerFilter_Destroy(object_layer_filter);

    body_filter_funcs := Jolt.BodyFilter_Funcs.{
        ShouldCollide = (user_data : *void, body_id : Jolt.BodyID) -> bool #c_call {
            return true;
        },

        ShouldCollideLocked = (user_data : *void, body_id : *Jolt.Body) -> bool #c_call {
            return true;
        }
    };
    body_filter := Jolt.BodyFilter_Create(null, body_filter_funcs, .{});
    defer Jolt.BodyFilter_Destroy(body_filter);

    narrow_phase := Jolt.PhysicsSystem_GetNarrowPhaseQuery(world.physics.system);

    ray_vector := ray_direction * ray_length;

    ray : Jolt.RRayCast;
    ray.origin = Jolt.XYZ(ray_origin);
    ray.direction = Jolt.XYZ(ray_vector);
    Println("%", ray);

    result : Jolt.RayCastResult;
    hit := Jolt.NarrowPhaseQuery_CastRay(narrow_phase, ray, *result, broad_phase_layer_filter, object_layer_filter, body_filter);

    if !hit {
        return .{};
    }

    point := Jolt.RRayCast_GetPointOnRay(*ray, result.fraction);

    collider : *Component;
    rigid_body : *RigidBodyComponent;

    normal : Vec3f;

    body_lock_read : Jolt.BodyLockRead;
    {
        // Happens in between physics update, so we use the NoLock interface
        body_lock_interface := Jolt.PhysicsSystem_GetBodyLockInterfaceNoLock(world.physics.system);
        Jolt.BodyLockInterface_LockRead(body_lock_interface, result.bodyID, *body_lock_read);
        defer Jolt.BodyLockInterface_UnlockRead(body_lock_interface, *body_lock_read);

        if body_lock_read.body {
            rigid_body = cast(*RigidBodyComponent, Jolt.Body_GetUserData(body_lock_read.body));

            normal = Jolt.ToXYZ(Jolt.Body_GetWorldSpaceSurfaceNormal(body_lock_read.body, result.subShapeID2, point));

            shape := Jolt.Body_GetShape(body_lock_read.body);

            remainder_shape_id : Jolt.SubShapeID;
            subshape := Jolt.Shape_GetLeafShape(shape, result.subShapeID2, *remainder_shape_id);
            if subshape {
                shape = subshape;
            }

            collider = cast(*Component, Jolt.Shape_GetUserData(shape));
        }
    }

    return .{
        hit=true,
        point=Jolt.ToXYZ(point),
        normal=normal,
        dist=Length(Jolt.ToXYZ(point) - ray_origin),
        entity=ifx collider then GetEntity(world, collider.entity_index) else ifx rigid_body then GetEntity(world, rigid_body.entity_index),
        collider=collider,
    };
} @ModuleAPI
