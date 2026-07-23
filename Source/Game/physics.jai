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

InitPhysics :: () {
    ok := Jolt.Init();
    Assert(ok, "Could not initialize Jolt");

    DebugRenderer_Interface :: Jolt.DebugRenderer_Procs.{
        DrawLine = (user_data : *void, from : *Jolt.RVec3, to : *Jolt.RVec3, color : Jolt.Color) #c_call {
            if !user_data {
                return;
            }

            push_context,defer_pop;

            rgba := cast(*u8, *color);

            world := cast(*World, user_data);
            DebugDrawLine(world, .{rgba[0] / 255.0, rgba[1] / 255.0, rgba[2] / 255.0, rgba[3] / 255.0}, .{from.x, from.y, from.z}, .{to.x, to.y, to.z});
        }
    };

    using g_physics;

    Jolt.DebugRenderer_SetProcs(*DebugRenderer_Interface);
    debug_renderer = Jolt.DebugRenderer_Create();

    BroadPhaseLayerFilter_Interface :: Jolt.BroadPhaseLayerFilter_Procs.{
        ShouldCollide = (user_data : *void, layer : Jolt.BroadPhaseLayer) -> bool #c_call {
            return true;
        },
    };

    Jolt.BroadPhaseLayerFilter_SetProcs(*BroadPhaseLayerFilter_Interface);

    ObjectLayerFilter_Interface :: Jolt.ObjectLayerFilter_Procs.{
        ShouldCollide = (user_data : *void, layer : Jolt.ObjectLayer) -> bool #c_call {
            return true;
        },
    };

    Jolt.ObjectLayerFilter_SetProcs(*ObjectLayerFilter_Interface);

    BodyFilter_Interface :: Jolt.BodyFilter_Procs.{
        ShouldCollide = (user_data : *void, body_id : Jolt.BodyID) -> bool #c_call {
            return true;
        },

        ShouldCollideLocked = (user_data : *void, body_id : *Jolt.Body) -> bool #c_call {
            return true;
        }
    };

    Jolt.BodyFilter_SetProcs(*BodyFilter_Interface);

    LogMessage("Initialized Jolt" ,, log_section=*Log_Physics);
}

ShutdownPhysics :: () {
    Jolt.DebugRenderer_Destroy(g_physics.debug_renderer);

    Jolt.Shutdown();

    LogMessage("Shut down Jolt" ,, log_section=*Log_Physics);
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
    using world.physics;

    job_system = Jolt.JobSystemThreadPool_Create(null);

    object_vs_object_layer_filter = Jolt.ObjectLayerPairFilterTable_Create(Physics_Num_Collision_Layers);

    for i : 0..Physics_Num_Collision_Layers - 1 {
        for j : 0..i {
            if ShouldPhysicsCollisionLayersCollide(xx i, xx j) {
                Jolt.ObjectLayerPairFilterTable_EnableCollision(object_vs_object_layer_filter, xx i, xx j);
            } else {
                Jolt.ObjectLayerPairFilterTable_DisableCollision(object_vs_object_layer_filter, xx i, xx j);
            }
        }
    }

    broad_phase_layer_interface = Jolt.BroadPhaseLayerInterfaceTable_Create(Physics_Num_Collision_Layers, Physics_Num_Collision_Layers);

    for i : 0..Physics_Num_Collision_Layers - 1 {
        Jolt.BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(broad_phase_layer_interface, xx i, xx i);
    }

    object_vs_broad_phase_layer_filter = Jolt.ObjectVsBroadPhaseLayerFilterTable_Create(broad_phase_layer_interface, Physics_Num_Collision_Layers, object_vs_object_layer_filter, Physics_Num_Collision_Layers);

    system_settings := Jolt.PhysicsSystemSettings.{
        maxBodies=Physics_Max_Bodies,
        numBodyMutexes=Physics_Num_Body_Mutexes,
        maxBodyPairs=Physics_Max_Body_Pairs,
        maxContactConstraints=Physics_Max_Contact_Constraints,
        broadPhaseLayerInterface=broad_phase_layer_interface,
        objectLayerPairFilter=object_vs_object_layer_filter,
        objectVsBroadPhaseLayerFilter=object_vs_broad_phase_layer_filter,
    };
    system = Jolt.PhysicsSystem_Create(*system_settings);

    body_interface = Jolt.PhysicsSystem_GetBodyInterface(system);
}

DestroyPhysicsWorld :: (world : *World) {
    using world.physics;

    Jolt.PhysicsSystem_Destroy(system);
    Jolt.JobSystem_Destroy(job_system);
}

UpdatePhysicsWorld :: (world : *World) {
    using world.physics;

    Jolt.PhysicsSystem_Update(system, Physics_Delta_Time, Physics_Num_Collision_Steps, job_system);

    Jolt.DebugRenderer_NextFrame(g_physics.debug_renderer, world);

    if g_physics.debug_draw_settings.enabled {
        draw_settings : Jolt.DrawSettings;
        draw_settings.drawShape = g_physics.debug_draw_settings.draw_colliders;
        draw_settings.drawShapeWireframe = g_physics.debug_draw_settings.draw_colliders_wireframe;
        draw_settings.drawShapeColor = g_physics.debug_draw_settings.collider_color;
        draw_settings.drawBoundingBox = g_physics.debug_draw_settings.draw_bounding_box;
        draw_settings.drawCenterOfMassTransform = g_physics.debug_draw_settings.draw_center_of_mass_transform;
        draw_settings.drawWorldTransform = g_physics.debug_draw_settings.draw_world_transform;
        draw_settings.drawVelocity = g_physics.debug_draw_settings.draw_velocity;
        draw_settings.drawMassAndInertia = g_physics.debug_draw_settings.draw_mass_and_inertia;

        Jolt.PhysicsSystem_DrawBodies(system, *draw_settings, g_physics.debug_renderer, null);
    }

    for * world.RigidBodyComponent_storage {
        if !Jolt.BodyInterface_IsActive(body_interface, it.jolt_body_id) {
            continue;
        }

        entity := GetEntity(world, it.entity_index);

        world_transform : Mat4f;
        Jolt.BodyInterface_GetWorldTransform(body_interface, it.jolt_body_id, xx *world_transform);

        world_transform = Transposed(world_transform);
        SetWorldTransformNoScale(world, entity, world_transform);
    }
} @ModuleAPI

RayIntersection :: (world : *World, sphere : *SphereColliderComponent, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float) -> RayCastResult {
    entity := GetEntity(world, sphere.entity_index);
    if !entity {
        return .{};
    }

    center := TranslationVector(sphere.world_transform);
    // @Todo: take the full transform into account
    intersects, point, dist, normal := RayIntersectsSphere(ray_origin, ray_direction, ray_length, center, sphere.radius);

    return .{
        hit=intersects,
        entity=entity,
        collider=sphere,
        point=point,
        dist=dist,
        normal=normal,
    };
} @ModuleAPI

RayIntersection :: (world : *World, capsule : *CapsuleColliderComponent, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float) -> RayCastResult {
    entity := GetEntity(world, capsule.entity_index);
    if !entity {
        return .{};
    }

    center := TranslationVector(capsule.world_transform);
    up := UpVector(capsule.world_transform);
    base := center - up * capsule.height * 0.5;
    tip  := center + up * capsule.height * 0.5;
    // @Todo: take the full transform into account
    intersects, point, dist, normal := RayIntersectsCapsule(ray_origin, ray_direction, ray_length, base, tip, capsule.radius);

    return .{
        hit=intersects,
        entity=entity,
        collider=capsule,
        point=point,
        dist=dist,
        normal=normal,
    };
} @ModuleAPI

RayIntersection :: (world : *World, box : *BoxColliderComponent, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float) -> RayCastResult {
    entity := GetEntity(world, box.entity_index);
    if !entity {
        return .{};
    }

    intersects, point, dist, normal := RayIntersectsBox(ray_origin, ray_direction, ray_length, box.half_extents, box.world_transform);

    return .{
        hit=intersects,
        entity=entity,
        collider=box,
        point=point,
        dist=dist,
        normal=normal,
    };
} @ModuleAPI

RayIntersection :: (world : *World, mesh : *MeshColliderComponent, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float) -> RayCastResult {
    entity := GetEntity(world, mesh.entity_index);
    if !entity {
        return .{};
    }

    intersects, point, dist, normal := RayIntersectsMesh(ray_origin, ray_direction, ray_length, mesh.mesh, mesh.world_transform, mesh.inv_world_transform);

    return .{
        hit=intersects,
        entity=entity,
        collider=mesh,
        point=point,
        dist=dist,
        normal=normal,
    };
} @ModuleAPI

RaycastAll :: (world : *World, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float, results : *[..]RayCastResult) -> bool {
    original_count := results.count;

    for * world.SphereColliderComponent_storage {
        hit := RayIntersection(world, it, ray_origin, ray_direction, ray_length);
        if hit.hit {
            ArrayPush(results, hit);
        }
    }
    for * world.CapsuleColliderComponent_storage {
        hit := RayIntersection(world, it, ray_origin, ray_direction, ray_length);
        if hit.hit {
            ArrayPush(results, hit);
        }
    }
    for * world.BoxColliderComponent_storage {
        hit := RayIntersection(world, it, ray_origin, ray_direction, ray_length);
        if hit.hit {
            ArrayPush(results, hit);
        }
    }
    for * world.MeshColliderComponent_storage {
        hit := RayIntersection(world, it, ray_origin, ray_direction, ray_length);
        if hit.hit {
            ArrayPush(results, hit);
        }
    }

    return results.count > original_count;
} @ModuleAPI

Raycast :: (world : *World, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float) -> RayCastResult {
    closest_hit : RayCastResult;
    for * world.SphereColliderComponent_storage {
        hit := RayIntersection(world, it, ray_origin, ray_direction, ray_length);
        if hit.hit && hit.dist < closest_hit.dist {
            closest_hit = hit;
        }
    }
    for * world.CapsuleColliderComponent_storage {
        hit := RayIntersection(world, it, ray_origin, ray_direction, ray_length);
        if hit.hit && hit.dist < closest_hit.dist {
            closest_hit = hit;
        }
    }
    for * world.BoxColliderComponent_storage {
        hit := RayIntersection(world, it, ray_origin, ray_direction, ray_length);
        if hit.hit && hit.dist < closest_hit.dist {
            closest_hit = hit;
        }
    }
    for * world.MeshColliderComponent_storage {
        hit := RayIntersection(world, it, ray_origin, ray_direction, ray_length);
        if hit.hit && hit.dist < closest_hit.dist {
            closest_hit = hit;
        }
    }

    return closest_hit;
} @ModuleAPI

CastRay :: (world : *World, ray_origin : Vec3f, ray_direction : Vec3f) -> RayCastResult {
    broad_phase_layer_filter := Jolt.BroadPhaseLayerFilter_Create(null);
    defer Jolt.BroadPhaseLayerFilter_Destroy(broad_phase_layer_filter);

    object_layer_filter := Jolt.ObjectLayerFilter_Create(null);
    defer Jolt.ObjectLayerFilter_Destroy(object_layer_filter);

    body_filter := Jolt.BodyFilter_Create(null);
    defer Jolt.BodyFilter_Destroy(body_filter);

    narrow_phase := Jolt.PhysicsSystem_GetNarrowPhaseQuery(world.physics.system);

    result : Jolt.RayCastResult;
    hit := Jolt.NarrowPhaseQuery_CastRay(narrow_phase, *ray_origin, *ray_direction, *result, broad_phase_layer_filter, object_layer_filter, body_filter);
    if !hit {
        return .{};
    }

    point : Vec3f;
    Jolt.RayCast_GetPointOnRay(*ray_origin, *ray_direction, result.fraction, *point);

    collider : *Component;

    normal : Vec3f;

    body_lock_read : Jolt.BodyLockRead;
    {
        body_lock_interface := Jolt.PhysicsSystem_GetBodyLockInterface(world.physics.system);
        Jolt.BodyLockInterface_LockRead(body_lock_interface, result.bodyID, *body_lock_read);
        defer Jolt.BodyLockInterface_UnlockRead(body_lock_interface, *body_lock_read);

        if body_lock_read.body {
            Jolt.Body_GetWorldSpaceSurfaceNormal(body_lock_read.body, result.subShapeID2, *point, *normal);

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
        point=point,
        normal=normal,
        dist=Length(point - ray_origin),
        entity=ifx collider then GetEntity(world, collider.entity_index),
        collider=collider,
    };
} @ModuleAPI
