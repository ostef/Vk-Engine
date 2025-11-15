g_jolt_debug_renderer : *Jolt.DebugRenderer;

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

    g_jolt_debug_renderer = Jolt.DebugRenderer_Create();
    Jolt.DebugRenderer_SetProcs(*DebugRenderer_Interface);

    LogMessage("Initialized Jolt" ,, log_section=*Log_Physics);
}

ShutdownPhysics :: () {
    Jolt.DebugRenderer_Destroy(g_jolt_debug_renderer);

    Jolt.Shutdown();
    LogMessage("Shut down Jolt" ,, log_section=*Log_Physics);
}

InitPhysicsWorld :: (world : *World) {
    using world.physics;

    job_system = Jolt.JobSystemThreadPool_Create(null);
    Jolt.JobSystemThreadPool_Create(null);

    object_vs_object_layer_filter = Jolt.ObjectLayerPairFilterTable_Create(Physics_Num_Body_Layers);
    Jolt.ObjectLayerPairFilterTable_EnableCollision(object_vs_object_layer_filter, xx PhysicsBodyLayer.Moving, xx PhysicsBodyLayer.Moving);
    Jolt.ObjectLayerPairFilterTable_EnableCollision(object_vs_object_layer_filter, xx PhysicsBodyLayer.Moving, xx PhysicsBodyLayer.Static);

    broad_phase_layer_interface = Jolt.BroadPhaseLayerInterfaceTable_Create(Physics_Num_Body_Layers, Physics_Num_Body_Layers);
    Jolt.BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(broad_phase_layer_interface, xx PhysicsBodyLayer.Static, xx PhysicsBodyLayer.Static);
    Jolt.BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(broad_phase_layer_interface, xx PhysicsBodyLayer.Moving, xx PhysicsBodyLayer.Moving);

    object_vs_broad_phase_layer_filter = Jolt.ObjectVsBroadPhaseLayerFilterTable_Create(broad_phase_layer_interface, Physics_Num_Body_Layers, object_vs_object_layer_filter, Physics_Num_Body_Layers);

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

g_physics_debug_draw_settings : PhysicsDebugDrawSettings;

GetPhysicsDebugDrawSettings :: () -> *PhysicsDebugDrawSettings {
    return *g_physics_debug_draw_settings;
} @ModuleAPI

UpdatePhysicsWorld :: (world : *World) {
    using world.physics;

    Jolt.PhysicsSystem_Update(system, Physics_Delta_Time, Physics_Num_Collision_Steps, job_system);

    Jolt.DebugRenderer_NextFrame(g_jolt_debug_renderer, world);

    if g_physics_debug_draw_settings.enabled {
        draw_settings : Jolt.DrawSettings;
        draw_settings.drawShape = g_physics_debug_draw_settings.draw_colliders;
        draw_settings.drawShapeWireframe = g_physics_debug_draw_settings.draw_colliders_wireframe;
        draw_settings.drawShapeColor = g_physics_debug_draw_settings.collider_color;
        draw_settings.drawBoundingBox = g_physics_debug_draw_settings.draw_bounding_box;
        draw_settings.drawCenterOfMassTransform = g_physics_debug_draw_settings.draw_center_of_mass_transform;
        draw_settings.drawWorldTransform = g_physics_debug_draw_settings.draw_world_transform;
        draw_settings.drawVelocity = g_physics_debug_draw_settings.draw_velocity;
        draw_settings.drawMassAndInertia = g_physics_debug_draw_settings.draw_mass_and_inertia;

        Jolt.PhysicsSystem_DrawBodies(system, *draw_settings, g_jolt_debug_renderer, null);
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

RayIntersection :: (world : *World, sphere : *SphereColliderComponent, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float) -> RaycastResult {
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

RayIntersection :: (world : *World, capsule : *CapsuleColliderComponent, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float) -> RaycastResult {
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

RayIntersection :: (world : *World, box : *BoxColliderComponent, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float) -> RaycastResult {
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

RayIntersection :: (world : *World, mesh : *MeshColliderComponent, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float) -> RaycastResult {
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

RaycastAll :: (world : *World, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float, results : *[..]RaycastResult) -> bool {
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

Raycast :: (world : *World, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float) -> RaycastResult {
    closest_hit : RaycastResult;
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
