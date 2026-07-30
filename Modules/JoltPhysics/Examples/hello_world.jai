#import "Basic";
Jolt :: #import,file "../module.jai";

ObjectLayer :: enum Jolt.ObjectLayer {
    NonMoving;
    Moving;
}

BroadPhaseLayer :: enum Jolt.BroadPhaseLayer {
    NonMoving;
    Moving;
}

main :: () {
    print("Jolt version ID: %\n", FormatInt.{value=Jolt.GetJoltVersionID(), base=16});

    Jolt.RegisterDefaultAllocator();
    Jolt.RegisterDefaultTraceHandler();
    #if Jolt.ENABLE_ASSERTS {
        Jolt.RegisterDefaultAssertFailedHandler();
    }

    Jolt.CreateFactory();
    defer Jolt.DestroyFactory();

    Jolt.RegisterTypes();
    defer Jolt.UnregisterTypes();

    temp_allocator := Jolt.TempAllocatorImpl.Create(1 * 1024 * 1024);
    defer temp_allocator.Destroy(temp_allocator);

    job_system := Jolt.JobSystemThreadPool.Create(Jolt.cMaxPhysicsJobs, Jolt.cMaxPhysicsBarriers, -1);
    defer job_system.Destroy(job_system);

    bpl_interface := Jolt.BroadPhaseLayerInterfaceTable.Create(2, 2);
    defer bpl_interface.Destroy(bpl_interface);

    bpl_interface.MapObjectToBroadPhaseLayer(bpl_interface, xx ObjectLayer.NonMoving, xx BroadPhaseLayer.NonMoving);
    bpl_interface.MapObjectToBroadPhaseLayer(bpl_interface, xx ObjectLayer.Moving, xx BroadPhaseLayer.Moving);
#if Jolt.EXTERNAL_PROFILE || Jolt.PROFILE_ENABLED {
    bpl_interface.SetBroadPhaseLayerName(bpl_interface, xx BroadPhaseLayer.NonMoving, "NonMoving");
    bpl_interface.SetBroadPhaseLayerName(bpl_interface, xx BroadPhaseLayer.Moving, "Moving");
}

    object_layer_pair_filter := Jolt.ObjectLayerPairFilterTable.Create(2);
    defer object_layer_pair_filter.Destroy(object_layer_pair_filter);

    object_layer_pair_filter.EnableCollision(object_layer_pair_filter, xx ObjectLayer.NonMoving, xx ObjectLayer.Moving);
    object_layer_pair_filter.EnableCollision(object_layer_pair_filter, xx ObjectLayer.Moving, xx ObjectLayer.Moving);

    object_vs_broad_phase_layer_filter := Jolt.ObjectVsBroadPhaseLayerFilterTable.Create(bpl_interface, 2, object_layer_pair_filter, 2);
    defer object_vs_broad_phase_layer_filter.Destroy(object_vs_broad_phase_layer_filter);

    system := Jolt.PhysicsSystem.Create(.{
        maxBodies=1024,
        numBodyMutexes=0,
        maxBodyPairs=1024,
        maxContactConstraints=1024,
        broadPhaseLayerInterface=bpl_interface,
        objectVsBroadPhaseLayerFilter=object_vs_broad_phase_layer_filter,
        objectLayerPairFilter=object_layer_pair_filter,
    });
    defer system.Destroy(system);

    body_interface := system.GetBodyInterface(system);

    floor_shape_settings := Jolt.BoxShapeSettings.Create();
    defer floor_shape_settings.Destroy(floor_shape_settings);

    floor_shape_settings.SetHalfExtent(floor_shape_settings, Jolt.Vec3.Make(100, 1, 100));

    floor_shape := floor_shape_settings.CreateShape(floor_shape_settings);

    floor_settings := Jolt.BodyCreationSettings.Default();
    floor_settings.position = Jolt.Vec3.Make(0,-1,0);
    floor_settings.objectLayer = xx ObjectLayer.NonMoving;
    floor_settings.motionType = .Static;
    floor_settings.shapePtr = floor_shape;

    floor := body_interface.CreateBody(body_interface, *floor_settings);
    body_interface.AddBody(body_interface, floor.GetID(floor), .Activate);
    print("Created floor: %\n", floor.GetID(floor));

    sphere_shape_settings := Jolt.SphereShapeSettings.Create();
    defer sphere_shape_settings.Destroy(sphere_shape_settings);

    sphere_shape_settings.SetRadius(sphere_shape_settings, 0.5);

    sphere_shape := sphere_shape_settings.CreateShape(sphere_shape_settings);

    sphere_settings := Jolt.BodyCreationSettings.Default();
    sphere_settings.position = Jolt.Vec3.Make(0,2,0);
    sphere_settings.objectLayer = xx ObjectLayer.Moving;
    sphere_settings.motionType = .Dynamic;
    sphere_settings.shapePtr = sphere_shape;

    sphere_id := Jolt.BodyInterface.CreateAndAddBody(body_interface, *sphere_settings, .Activate);
    print("Created sphere: %\n", sphere_id);

    body_interface.SetLinearVelocity(body_interface, sphere_id, Jolt.Vec3.Make(0,-5,0));

    system.OptimizeBroadPhase(system);

    Delta_Time :: 1 / 60.0;
    step := 0;
    while body_interface.IsActive(body_interface, sphere_id) {
        step += 1;

        position := body_interface.GetCenterOfMassPosition(body_interface, sphere_id);
        velocity := body_interface.GetLinearVelocity(body_interface, sphere_id);
        print("Step %: Position = (%, %, %), Velocity = (%, %, %)\n", step, position.x, position.y, position.z, velocity.x, velocity.y, velocity.z);

        Collision_Steps :: 1;
        system.Update(system, Delta_Time, Collision_Steps, temp_allocator, job_system);

        query := system.GetNarrowPhaseQuery(system);

        ray := Jolt.RRayCast.{
            origin=Jolt.Vec3.Make(0, 1, -5),
            direction=Jolt.Vec3.Make(0, 0, 50),
        };

        ray_cast_result := Jolt.RayCastResult.Default();
        hit := Jolt.NarrowPhaseQuery.CastRay(query, ray, *ray_cast_result, null, null, null);

        if (hit) {
            hit_point := ray.GetPointOnRay(*ray, ray_cast_result.fraction);
            print("Hit, Fraction = %, Point = (%, %, %), BodyID = %\n", ray_cast_result.fraction, hit_point.x, hit_point.y, hit_point.z, ray_cast_result.bodyID);
        }
    }

    body_interface.RemoveBody(body_interface, sphere_id);
    body_interface.DestroyBody(body_interface, sphere_id);

    body_interface.RemoveBody(body_interface, floor.GetID(floor));
    body_interface.DestroyBody(body_interface, floor.GetID(floor));
}

#run {
    #import "File_Utilities";

    #if OS == .WINDOWS {
        copy_file("../Libs/Windows/JoltC.dll", "JoltC.dll");
    } else #if OS == .LINUX {
        copy_file("../Libs/Linux/libJoltC.so", "libJoltC.so");
    }
}
