InitPhysics :: () {
    Jolt.RegisterDefaultAllocator();
    Jolt.FactoryInit();
    Jolt.RegisterTypes();
}

ShutdownPhysics :: () {
    Jolt.UnregisterTypes();
    Jolt.FactoryDelete();
}

GetNumBroadPhaseLayers :: (self : *void) -> u32 #c_call {
    return 1;
}

GetBroadPhaseLayer :: (self : *void, in_layer : Jolt.ObjectLayer) -> Jolt.BroadPhaseLayer #c_call {
    return 0;
}

BPL_Interface :: Jolt.BroadPhaseLayerInterfaceFns.{
    GetNumBroadPhaseLayers=GetNumBroadPhaseLayers,
    GetBroadPhaseLayer=GetBroadPhaseLayer,
};

ObjectShouldCollideBroadPhase :: (self : *void, in_obj_layer : Jolt.ObjectLayer, in_broad_phase_layer : Jolt.BroadPhaseLayer) -> bool #c_call {
    return true;
}

OvB_Interface :: Jolt.ObjectVsBroadPhaseLayerFilterFns.{
    ShouldCollide=ObjectShouldCollideBroadPhase,
};

ObjectShouldCollideObject :: (self : *void, in_layer1 : Jolt.ObjectLayer, in_layer2 : Jolt.ObjectLayer) -> bool #c_call {
    return true;
}

OvO_Interface :: Jolt.ObjectLayerPairFilterFns.{
    ShouldCollide=ObjectShouldCollideObject,
};

InitPhysicsWorld :: (world : *World) {
    using world.physics;;

    temp_allocator = Jolt.TempAllocatorImpl_new(Physics_Temp_Allocator_Capacity);
    job_system = Jolt.JobSystemThreadPool_new2(xx Jolt.JPC_MAX_PHYSICS_JOBS, xx Jolt.JPC_MAX_PHYSICS_BARRIERS);
    broad_phase_layer_interface = Jolt.BroadPhaseLayerInterface_new(null, BPL_Interface);
    object_vs_broad_phase_layer_filter = Jolt.ObjectVsBroadPhaseLayerFilter_new(null, OvB_Interface);
    object_vs_object_layer_filter = Jolt.ObjectLayerPairFilter_new(null, OvO_Interface);

    system = Jolt.PhysicsSystem_new();
    Jolt.PhysicsSystem_Init(
        system,
        Physics_Max_Bodies,
        Physics_Num_Body_Mutexes,
        Physics_Max_Body_Pairs,
        Physics_Max_Contact_Constraints,
        broad_phase_layer_interface,
        object_vs_broad_phase_layer_filter,
        object_vs_object_layer_filter
    );

    body_interface = Jolt.PhysicsSystem_GetBodyInterface(system);
}

DestroyPhysicsWorld :: (world : *World) {
    using world.physics;

    Jolt.PhysicsSystem_delete(system);
    Jolt.BroadPhaseLayerInterface_delete(broad_phase_layer_interface);
    Jolt.ObjectVsBroadPhaseLayerFilter_delete(object_vs_broad_phase_layer_filter);
    Jolt.ObjectLayerPairFilter_delete(object_vs_object_layer_filter);

    Jolt.JobSystemThreadPool_delete(job_system);
    Jolt.TempAllocatorImpl_delete(temp_allocator);
}

UpdatePhysicsWorld :: (world : *World) {
    using world.physics;

    Jolt.PhysicsSystem_Update(system, Physics_Delta_Time, Physics_Num_Collision_Steps, temp_allocator, cast(*Jolt.JobSystem, job_system));
}

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
