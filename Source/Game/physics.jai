g_physics : PhysicsGlobals;

GetPhysicsGlobals :: () -> *PhysicsGlobals {
    return *g_physics;
} @Public

GetPhysicsGlobalSettings :: () -> *PhysicsGlobalSettings {
    return *g_physics.settings;
} @Public

GetPhysicsDebugDrawSettings :: () -> *PhysicsDebugDrawSettings {
    return *g_physics.debug_draw_settings;
} @Public

SetPhysicsDebugRendererTarget :: (world : *World) {
    g_physics.debug_renderer_target_world = world;
} @Public

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
} @Public

DisablePhysicsCollisionLayersCollision :: (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) {
    index := GetPhysicsCollisionLayersMatrixIndex(a, b);
    g_physics.settings.collision_layer_matrix[index] = false;
} @Public

ShouldPhysicsCollisionLayersCollide :: (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) -> bool {
    index := GetPhysicsCollisionLayersMatrixIndex(a, b);

    return g_physics.settings.collision_layer_matrix[index];
} @Public

UpdatePhysicsCollisionLayerMatrix :: () {
    using g_physics;
} @Public

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
} @Public

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
} @Public

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
} @Public

UpdateWorldTransform :: (world : *World, entity : *Entity, using rigid_body : *RigidBodyComponent) {
    world_rotation := QuatfFromMatrix(entity.world_transform);
    world_position := TranslationVector(entity.world_transform);

    Jolt.BodyInterface.SetPositionAndRotation(world.physics.body_interface, jolt_body_id, ToJolt(world_position), ToJolt(world_rotation), .DontActivate);
} @Public

PhysicsCastRay :: (world : *World, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float, settings : RayCastSettings = .{}) -> RayCastResult {
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


    body_lock_interface := Jolt.PhysicsSystem.GetBodyLockInterfaceNoLock(world.physics.system);
    {
        body_lock : Jolt.BodyLockRead;
        Jolt.BodyLockInterface.LockRead(body_lock_interface, result.bodyID, *body_lock);
        defer Jolt.BodyLockInterface.UnlockRead(body_lock_interface, *body_lock);

        if body_lock.body {
            rigid_body = cast(*RigidBodyComponent, Jolt.Body.GetUserData(body_lock.body));

            if settings.flags & .ComputeNormals {
                normal = FromJolt(Jolt.Body.GetWorldSpaceSurfaceNormal(body_lock.body, result.subShapeID2, point));
            }

            // Always retrieve the collider, it's not an expensive operation and we always retrieve the rigidbody anyway
            shape := Jolt.Body.GetShape(body_lock.body);

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
        rigid_body=rigid_body,
        entity=ifx rigid_body then GetEntity(world, rigid_body.entity_index) else ifx collider then GetEntity(world, collider.entity_index),
        collider=collider,
    };
} @Public

SortByDistance :: (results : []RayCastResult) {
    QuickSort(results, (a, b) => ifx a.dist < b.dist then -1 else ifx a.dist > b.dist then 1 else 0);
} @Public

PhysicsCastRay :: (world : *World, ray_origin : Vec3f, ray_direction : Vec3f, ray_length : float, results : *[..]RayCastResult, settings : RayCastSettings = .{}) -> bool {
    if !world.physics.system {
        return false;
    }

    initial_num_results := results.count; // Allow calling this with a prefilled results

    ray_vector := ray_direction * ray_length;

    ray : Jolt.RRayCast;
    ray.origin = ToJolt(ray_origin);
    ray.direction = ToJolt(ray_vector);

    collector_data : struct {
        jai_context : *#Context;
        hit : bool;
        world : *World;
        ray : Jolt.RRayCast;
        results : *[..]RayCastResult;
        body_ids : [..]Jolt.BodyID;
        sub_shape_ids : [..]Jolt.SubShapeID;
        current_entity : *Entity;
        current_rigid_body : *RigidBodyComponent;
    } = .{world=world, ray=ray, results=results};
    collector_data.body_ids.allocator = Temp;
    collector_data.sub_shape_ids.allocator = Temp;

    Collector :: Jolt.CastRayCollector.Funcs.{
        OnBody = (collector : *Jolt.CastRayCollector, data : *void, body : *Jolt.Body) -> void #c_call {
            using _ := cast(*type_of(collector_data), data);
            push_context,defer_pop jai_context.*;

            current_rigid_body = cast(*RigidBodyComponent, body.GetUserData(body));
            if current_rigid_body {
                current_entity = GetEntity(world, current_rigid_body.entity_index);
            } else {
                current_entity = null;
            }
        },

        OnBodyEnd = (collector : *Jolt.CastRayCollector, data : *void) -> void #c_call {
            using _ := cast(*type_of(collector_data), data);

            current_rigid_body = null;
            current_entity = null;
        },

        AddHit = (collector : *Jolt.CastRayCollector, data : *void, result : Jolt.RayCastResult) -> void #c_call {
            using _ := cast(*type_of(collector_data), data);
            push_context,defer_pop jai_context.*;

            hit = true;

            res := ArrayPush(results);
            res.hit = true;
            res.point = FromJolt(ray.GetPointOnRay(*ray, result.fraction));
            res.dist = Length(res.point - FromJolt(ray.origin));
            res.entity = current_entity;
            res.rigid_body = current_rigid_body;

            ArrayPush(*body_ids, result.bodyID);
            ArrayPush(*sub_shape_ids, result.subShapeID2);
        },
    };

    collector := Jolt.CastRayCollector.Create(*collector_data, Collector, Jolt.Temp());
    defer collector.Destroy(collector);

    // @Todo: layer filter
    narrow_phase := Jolt.PhysicsSystem.GetNarrowPhaseQueryNoLock(world.physics.system);
    Jolt.NarrowPhaseQuery.CastRay(narrow_phase, ray, .{}, collector, null, null, null, null);

    if !collector_data.hit {
        return false;
    }

    if (settings.flags & .ComputeNormals) || (settings.flags & .RetrieveColliders) {
        body_lock : Jolt.BodyLockMultiRead;

        body_lock_interface := Jolt.PhysicsSystem.GetBodyLockInterfaceNoLock(world.physics.system);
        body_lock_interface.LockReadMulti(body_lock_interface, collector_data.body_ids.data, xx collector_data.body_ids.count, *body_lock);
        defer body_lock_interface.UnlockReadMulti(body_lock_interface, *body_lock);

        for collector_data.body_ids {
            res := results.*[initial_num_results + it_index];
            body := body_lock.GetBody(*body_lock, body_lock_interface, xx it_index);
            if !body {
                continue;
            }

            sub_shape_id := collector_data.sub_shape_ids[it_index];

            if settings.flags & .ComputeNormals {
                res.normal = FromJolt(body.GetWorldSpaceSurfaceNormal(body, sub_shape_id, ToJolt(res.point)));
            }

            if settings.flags & .RetrieveColliders {
                shape := body.GetShape(body);
                subshape := shape.GetLeafShape(shape, sub_shape_id, null);
                if subshape {
                    shape = subshape;
                }

                res.collider = cast(*Component, shape.GetUserData(shape));
            }
        }
    }

    return true;
} @Public

// CollidePoint :: (world : *World, point : Vec3f) {
// }

// CollidePoint :: (world : *World, point : Vec3f) {
//     if !world.physics.system {
//         return .{};
//     }

//     collector_data : struct {
//     };

//     Collector :: Jolt.CollidePointCollector.Funcs {
//         Destruct = (data : *void) -> void #c_call {
//             using _ := cast(*type_of(collector_data), data);
//         },

//         Reset = (data : *void) -> void #c_call {
//             using _ := cast(*type_of(collector_data), data);
//         },

//         OnBody = (data : *void, body : *Jolt.Body) -> void #c_call {
//             using _ := cast(*type_of(collector_data), data);
//         },

//         OnBodyEnd = (data : *void) -> void #c_call {
//             using _ := cast(*type_of(collector_data), data);
//         },

//         AddHit = (data : *void, result : Jolt.CollidePointResult) -> void #c_call {
//             using _ := cast(*type_of(collector_data), data);
//         },
//     }

//     collector := Jolt.CollidePointCollector.Create(xx *collector_data, Collector, Jolt.Temp());
//     defer collector.Destroy(collector);

//     narrow_phase := Jolt.PhysicsSystem.GetNarrowPhaseQuery(world.physics.system);
//     Jolt.NarrowPhaseQuery.CollidePoint(narrow_phase, ToJolt(point), collector, null, null, null);

//     point := Jolt.RRayCast.GetPointOnRay(*ray, result.fraction);

//     collider : *Component;
//     rigid_body : *RigidBodyComponent;

//     normal : Vec3f;

// }
