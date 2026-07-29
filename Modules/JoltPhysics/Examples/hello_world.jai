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

    temp_allocator := Jolt.TempAllocatorImpl_Create(1 * 1024 * 1024);
    defer Jolt.TempAllocator_Destroy(temp_allocator);

    job_system := Jolt.JobSystemThreadPool_Create(Jolt.cMaxPhysicsJobs, Jolt.cMaxPhysicsBarriers, -1);
    defer Jolt.JobSystem_Destroy(job_system);

    bpl_interface_funcs := Jolt.BroadPhaseLayerInterface_Funcs.{
        GetNumBroadPhaseLayers=(data : *void) -> u32 #c_call {
            return xx type_info(BroadPhaseLayer).names.count;
        },

        GetBroadPhaseLayer=(data : *void, layer : Jolt.ObjectLayer) -> Jolt.BroadPhaseLayer #c_call {
            if #complete cast(ObjectLayer, layer) == {
            case .NonMoving; return xx BroadPhaseLayer.NonMoving;
            case .Moving; return xx BroadPhaseLayer.Moving;
            }
        },
    };

    #if Jolt.PROFILE_ENABLED {
        bpl_interface_funcs.GetBroadPhaseLayerName = (data : *void, layer : Jolt.BroadPhaseLayer) -> *u8 #c_call {
            return type_info(BroadPhaseLayer).names[layer].data;
        }
    }

    bpl_interface := Jolt.BroadPhaseLayerInterface_Create(null, bpl_interface_funcs, .{});
    defer Jolt.BroadPhaseLayerInterface_Destroy(bpl_interface);

    object_layer_pair_filter := Jolt.ObjectLayerPairFilter_Create(null, .{
        ShouldCollide=(data : *void, layer1 : Jolt.ObjectLayer, layer2 : Jolt.ObjectLayer) -> bool #c_call {
            if #complete cast(ObjectLayer, layer1) == {
            case .NonMoving;
                return layer2 == xx ObjectLayer.Moving;
            case .Moving;
                return true;
            }
        },
    }, .{});
    defer Jolt.ObjectLayerPairFilter_Destroy(object_layer_pair_filter);

    object_vs_broad_phase_layer_filter := Jolt.ObjectVsBroadPhaseLayerFilter_Create(null, .{
        ShouldCollide=(data : *void, object_layer : Jolt.ObjectLayer, broad_phase_layer : Jolt.BroadPhaseLayer) -> bool #c_call {
            if #complete cast(ObjectLayer, object_layer) == {
            case .NonMoving;
                return broad_phase_layer == xx BroadPhaseLayer.Moving;
            case .Moving;
                return true;
            }
        },
    }, .{});
    defer Jolt.ObjectVsBroadPhaseLayerFilter_Destroy(object_vs_broad_phase_layer_filter);

    system := Jolt.PhysicsSystem_Create(.{
        maxBodies=1024,
        numBodyMutexes=0,
        maxBodyPairs=1024,
        maxContactConstraints=1024,
        broadPhaseLayerInterface=bpl_interface,
        objectVsBroadPhaseLayerFilter=object_vs_broad_phase_layer_filter,
        objectLayerPairFilter=object_layer_pair_filter,
    });
    defer Jolt.PhysicsSystem_Destroy(system);

    body_interface := Jolt.PhysicsSystem_GetBodyInterface(system);

    floor_shape_settings := Jolt.BoxShapeSettings_Create();
    defer Jolt.BoxShapeSettings_Destroy(floor_shape_settings);

    Jolt.BoxShapeSettings_SetHalfExtent(floor_shape_settings, Jolt.Vec3_Make(100, 1, 100));

    floor_shape := Jolt.ShapeSettings_CreateShape(xx floor_shape_settings);

    floor_settings := Jolt.BodyCreationSettings_Default();
    floor_settings.position = Jolt.Vec3_Make(0,-1,0);
    floor_settings.objectLayer = xx ObjectLayer.NonMoving;
    floor_settings.motionType = .Static;
    floor_settings.shapePtr = floor_shape;

    floor := Jolt.BodyInterface_CreateBody(body_interface, *floor_settings);
    Jolt.BodyInterface_AddBody(body_interface, Jolt.Body_GetID(floor), .Activate);
    print("Created floor: %\n", Jolt.Body_GetID(floor));

    sphere_shape_settings := Jolt.SphereShapeSettings_Create();
    defer Jolt.SphereShapeSettings_Destroy(sphere_shape_settings);

    Jolt.SphereShapeSettings_SetRadius(sphere_shape_settings, 0.5);

    sphere_shape := Jolt.ShapeSettings_CreateShape(xx sphere_shape_settings);

    sphere_settings := Jolt.BodyCreationSettings_Default();
    sphere_settings.position = Jolt.Vec3_Make(0,2,0);
    sphere_settings.objectLayer = xx ObjectLayer.Moving;
    sphere_settings.motionType = .Dynamic;
    sphere_settings.shapePtr = sphere_shape;

    sphere_id := Jolt.BodyInterface_CreateAndAddBody(body_interface, *sphere_settings, .Activate);
    print("Created sphere: %\n", sphere_id);

    Jolt.BodyInterface_SetLinearVelocity(body_interface, sphere_id, Jolt.Vec3_Make(0,-5,0));

    Jolt.PhysicsSystem_OptimizeBroadPhase(system);

    Delta_Time :: 1 / 60.0;
    step := 0;
    while Jolt.BodyInterface_IsActive(body_interface, sphere_id) {
        step += 1;

        position := Jolt.BodyInterface_GetCenterOfMassPosition(body_interface, sphere_id);
        velocity := Jolt.BodyInterface_GetLinearVelocity(body_interface, sphere_id);
        print("Step %: Position = (%, %, %), Velocity = (%, %, %)\n", step, position.x, position.y, position.z, velocity.x, velocity.y, velocity.z);

        Collision_Steps :: 1;
        Jolt.PhysicsSystem_Update(system, Delta_Time, Collision_Steps, temp_allocator, job_system);

        query := Jolt.PhysicsSystem_GetNarrowPhaseQuery(system);

        ray := Jolt.RRayCast.{
            origin=Jolt.Vec3_Make(0, 1, -5),
            direction=Jolt.Vec3_Make(0, 0, 50),
        };

        ray_cast_result := Jolt.RayCastResult_Default();
        hit := Jolt.NarrowPhaseQuery_CastRay(query, ray, *ray_cast_result, null, null, null);

        if (hit) {
            hit_point := Jolt.RRayCast_GetPointOnRay(*ray, ray_cast_result.fraction);
            print("Hit, Fraction = %, Point = (%, %, %), BodyID = %\n", ray_cast_result.fraction, hit_point.x, hit_point.y, hit_point.z, ray_cast_result.bodyID);
        }
    }

    Jolt.BodyInterface_RemoveBody(body_interface, sphere_id);
    Jolt.BodyInterface_DestroyBody(body_interface, sphere_id);

    Jolt.BodyInterface_RemoveBody(body_interface, Jolt.Body_GetID(floor));
    Jolt.BodyInterface_DestroyBody(body_interface, Jolt.Body_GetID(floor));
}

#run {
    #import "File_Utilities";

    #if OS == .WINDOWS {
        copy_file("../Libs/Windows/JoltC.dll", "JoltC.dll");
    } else #if OS == .LINUX {
        copy_file("../Libs/Linux/libJoltC.so", "libJoltC.so");
    }
}
