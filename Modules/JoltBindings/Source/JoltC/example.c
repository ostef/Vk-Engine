#include <JoltC.h>
#include <stdarg.h>
#include <stdio.h>

static
void Trace(const char *fmt, ...) {
	va_list list;
	va_start(list, fmt);
    vprintf(fmt, list);
	va_end(list);

    printf("\n");
}

static
bool AssertFailed(const char *expression, const char *message, const char *file, uint32_t line) {
    printf("Assertion failed at file %s:%u: (%s) %s\n", file, line, expression, message ? message : "");
	// Breakpoint
	return true;
}

enum {
    ObjectLayer_NonMoving,
    ObjectLayer_Moving,
};

enum {
    BroadPhaseLayer_NonMoving,
    BroadPhaseLayer_Moving,
};

static
uint32_t BroadPhaseLayerInterface_GetNumBroadPhaseLayers(const void *data) {
    return 2;
}

static
JPH_BroadPhaseLayer BroadPhaseLayerInterface_GetBroadPhaseLayer(const void *data, JPH_ObjectLayer layer) {
    switch (layer) {
    case ObjectLayer_NonMoving: return BroadPhaseLayer_NonMoving;
    case ObjectLayer_Moving:    return BroadPhaseLayer_Moving;
    default:                    return 0;
    }
}

static
const char *BroadPhaseLayerInterface_GetBroadPhaseLayerName(const void *data, JPH_BroadPhaseLayer layer) {
    switch (layer) {
    case BroadPhaseLayer_NonMoving: return "NonMoving";
    case BroadPhaseLayer_Moving:    return "Moving";
    default:                        return "Invalid";
    }
}

static
bool ObjectLayerPairFilter_ShouldCollide(const void *data, JPH_ObjectLayer layer1, JPH_ObjectLayer layer2) {
    switch (layer1) {
    case ObjectLayer_NonMoving:
        return layer2 == ObjectLayer_Moving;
    case ObjectLayer_Moving:
        return true;
    default:
        return false;
    }
}

static
bool ObjectVsBroadPhaseLayerFilter_ShouldCollide(const void *data, JPH_ObjectLayer objectLayer, JPH_BroadPhaseLayer broadPhaseLayer) {
    switch (objectLayer) {
    case ObjectLayer_NonMoving:
        return broadPhaseLayer == BroadPhaseLayer_Moving;
    case ObjectLayer_Moving:
        return true;
    default:
        return false;
    }
}

int main(int argc, char **argv) {
    printf("Jolt version ID: %lx\n", JPH_GetJoltVersionID());

    JPH_RegisterDefaultAllocator();
    JPH_SetTraceHandler(Trace);
    JPH_SetAssertFailedHandler(AssertFailed);

    JPH_CreateFactory();
    JPH_RegisterTypes();

    JPH_TempAllocator *tempAllocator = JPH_TempAllocatorImpl_Create(1 * 1024 * 1024);
    JPH_JobSystem *jobSystem = JPH_JobSystemThreadPool_Create(JPH_cMaxPhysicsJobs, JPH_cMaxPhysicsBarriers, -1);

    JPH_BroadPhaseLayerInterface *bplInterface = JPH_BroadPhaseLayerInterface_Create(NULL, (JPH_BroadPhaseLayerInterface_Funcs){
            .GetNumBroadPhaseLayers=BroadPhaseLayerInterface_GetNumBroadPhaseLayers,
            .GetBroadPhaseLayer=BroadPhaseLayerInterface_GetBroadPhaseLayer,
            #if defined(JPH_EXTERNAL_PROFILE) || defined(JPH_PROFILE_ENABLED)
            .GetBroadPhaseLayerName=BroadPhaseLayerInterface_GetBroadPhaseLayerName,
            #endif
        }, (JPH_Allocator){});

    JPH_ObjectLayerPairFilter *objectLayerPairFilter = JPH_ObjectLayerPairFilter_Create(NULL, (JPH_ObjectLayerPairFilter_Funcs){
            .ShouldCollide=ObjectLayerPairFilter_ShouldCollide,
        }, (JPH_Allocator){});

    JPH_ObjectVsBroadPhaseLayerFilter *objectVsBroadPhaseLayerFilter = JPH_ObjectVsBroadPhaseLayerFilter_Create(NULL, (JPH_ObjectVsBroadPhaseLayerFilter_Funcs){
            .ShouldCollide=ObjectVsBroadPhaseLayerFilter_ShouldCollide,
        }, (JPH_Allocator){});

    JPH_PhysicsSystemSettings systemSettings = {
        .maxBodies=1024,
        .numBodyMutexes=0,
        .maxBodyPairs=1024,
        .maxContactConstraints=1024,
        .broadPhaseLayerInterface=bplInterface,
        .objectVsBroadPhaseLayerFilter=objectVsBroadPhaseLayerFilter,
        .objectLayerPairFilter=objectLayerPairFilter,
    };
    JPH_PhysicsSystem *system = JPH_PhysicsSystem_Create(systemSettings);

    JPH_BodyInterface *bodyInterface = JPH_PhysicsSystem_GetBodyInterface(system);

    JPH_BoxShapeSettings *floorShapeSettings = JPH_BoxShapeSettings_Create();
    JPH_BoxShapeSettings_SetHalfExtent(floorShapeSettings, (JPH_Vec3){100, 1, 100});

    JPH_Shape *floorShape = JPH_ShapeSettings_CreateShape((JPH_ShapeSettings *)floorShapeSettings);

    JPH_BodyCreationSettings floorSettings;
    JPH_BodyCreationSettings_SetDefaults(&floorSettings);
    floorSettings.position = (JPH_RVec3){0, -1, 0};
    floorSettings.rotation = JPH_Quat_sIdentity;
    floorSettings.objectLayer = ObjectLayer_NonMoving;
    floorSettings.motionType = JPH_EMotionType_Static;
    floorSettings.shapePtr = floorShape;

    JPH_Body *floor = JPH_BodyInterface_CreateBody(bodyInterface, &floorSettings);
    JPH_BodyInterface_AddBody(bodyInterface, JPH_Body_GetID(floor), JPH_EActivation_Activate);

    JPH_SphereShapeSettings *sphereShapeSettings = JPH_SphereShapeSettings_Create();
    JPH_SphereShapeSettings_SetRadius(sphereShapeSettings, 0.5f);

    JPH_Shape *sphereShape = JPH_ShapeSettings_CreateShape((JPH_ShapeSettings *)sphereShapeSettings);

    JPH_BodyCreationSettings sphereSettings;
    JPH_BodyCreationSettings_SetDefaults(&sphereSettings);
    sphereSettings.position = (JPH_RVec3){0, 2, 0};
    sphereSettings.rotation = JPH_Quat_sIdentity;
    sphereSettings.objectLayer = ObjectLayer_Moving;
    sphereSettings.motionType = JPH_EMotionType_Dynamic;
    sphereSettings.shapePtr = sphereShape;

    JPH_BodyID sphereID = JPH_BodyInterface_CreateAndAddBody(bodyInterface, &sphereSettings, JPH_EActivation_Activate);

    JPH_BodyInterface_SetLinearVelocity(bodyInterface, sphereID, (JPH_Vec3){0, -5, 0});

    JPH_PhysicsSystem_OptimizeBroadPhase(system);

    const float cDeltaTime = 1.0f / 60.0f;
    uint32_t step = 0;
    while (JPH_BodyInterface_IsActive(bodyInterface, sphereID)) {
        step += 1;

        JPH_RVec3 position = JPH_BodyInterface_GetCenterOfMassPosition(bodyInterface, sphereID);
        JPH_Vec3 velocity = JPH_BodyInterface_GetLinearVelocity(bodyInterface, sphereID);
        printf("Step %d: Position = (%f, %f, %f), Velocity = (%f, %f, %f)\n", step, position.x, position.y, position.z, velocity.x, velocity.y, velocity.z);

        const int cCollisionSteps = 1;
        JPH_PhysicsSystem_Update(system, cDeltaTime, cCollisionSteps, tempAllocator, jobSystem);
    }

    JPH_BodyInterface_RemoveBody(bodyInterface, sphereID);
    JPH_BodyInterface_DestroyBody(bodyInterface, sphereID);

    JPH_BodyInterface_RemoveBody(bodyInterface, JPH_Body_GetID(floor));
    JPH_BodyInterface_DestroyBody(bodyInterface, JPH_Body_GetID(floor));

    JPH_PhysicsSystem_Destroy(system);

    JPH_ObjectVsBroadPhaseLayerFilter_Destroy(objectVsBroadPhaseLayerFilter);
    JPH_ObjectLayerPairFilter_Destroy(objectLayerPairFilter);
    JPH_BroadPhaseLayerInterface_Destroy(bplInterface);

    JPH_JobSystem_Destroy(jobSystem);
    JPH_TempAllocator_Destroy(tempAllocator);

    JPH_UnregisterTypes();
    JPH_DestroyFactory();
}
