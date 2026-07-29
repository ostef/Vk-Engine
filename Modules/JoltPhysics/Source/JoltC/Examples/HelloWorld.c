#include <JoltC.h>
#include <stdarg.h>
#include <stdio.h>
#include <inttypes.h>

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

int main(int argc, char **argv) {
    (void)argc;
    (void)argv;

    printf("Jolt version ID: %" PRIx64 "\n", JPH_GetJoltVersionID());

    JPH_RegisterDefaultAllocator();
    JPH_SetTraceHandler(Trace);
#ifdef JOLTC_ENABLE_ASSERTS
    JPH_SetAssertFailedHandler(AssertFailed);
#endif

    JPH_CreateFactory();
    JPH_RegisterTypes();

    JPH_TempAllocator *tempAllocator = JPH_TempAllocatorImpl_Create(1 * 1024 * 1024);
    JPH_JobSystem *jobSystem = JPH_JobSystemThreadPool_Create(JPH_cMaxPhysicsJobs, JPH_cMaxPhysicsBarriers, -1);

    JPH_BroadPhaseLayerInterfaceTable *bplInterface = JPH_BroadPhaseLayerInterfaceTable_Create(2, 2);
    JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(bplInterface, ObjectLayer_NonMoving, BroadPhaseLayer_NonMoving);
    JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(bplInterface, ObjectLayer_Moving, BroadPhaseLayer_Moving);
#if defined(JOLTC_EXTERNAL_PROFILE) || defined(JOLTC_PROFILE_ENABLED)
    JPH_BroadPhaseLayerInterfaceTable_SetBroadPhaseLayerName(bplInterface, BroadPhaseLayer_NonMoving, "NonMoving");
    JPH_BroadPhaseLayerInterfaceTable_SetBroadPhaseLayerName(bplInterface, BroadPhaseLayer_Moving, "Moving");
#endif

    JPH_ObjectLayerPairFilterTable *objectLayerPairFilter = JPH_ObjectLayerPairFilterTable_Create(2);
    JPH_ObjectLayerPairFilterTable_EnableCollision(objectLayerPairFilter, ObjectLayer_NonMoving, ObjectLayer_Moving);
    JPH_ObjectLayerPairFilterTable_EnableCollision(objectLayerPairFilter, ObjectLayer_Moving, ObjectLayer_Moving);

    JPH_ObjectVsBroadPhaseLayerFilterTable *objectVsBroadPhaseLayerFilter = JPH_ObjectVsBroadPhaseLayerFilterTable_Create((JPH_BroadPhaseLayerInterface *)bplInterface, 2, (JPH_ObjectLayerPairFilter *)objectLayerPairFilter, 2);

    JPH_PhysicsSystemSettings systemSettings = {
        .maxBodies=1024,
        .numBodyMutexes=0,
        .maxBodyPairs=1024,
        .maxContactConstraints=1024,
        .broadPhaseLayerInterface=(JPH_BroadPhaseLayerInterface *)bplInterface,
        .objectVsBroadPhaseLayerFilter=(JPH_ObjectVsBroadPhaseLayerFilter *)objectVsBroadPhaseLayerFilter,
        .objectLayerPairFilter=(JPH_ObjectLayerPairFilter *)objectLayerPairFilter,
    };
    JPH_PhysicsSystem *system = JPH_PhysicsSystem_Create(systemSettings);

    JPH_BodyInterface *bodyInterface = JPH_PhysicsSystem_GetBodyInterface(system);

    JPH_BoxShapeSettings *floorShapeSettings = JPH_BoxShapeSettings_Create();
    JPH_BoxShapeSettings_SetHalfExtent(floorShapeSettings, JPH_Vec3_Make(100, 1, 100));

    JPH_Shape *floorShape = JPH_ShapeSettings_CreateShape((JPH_ShapeSettings *)floorShapeSettings);

    JPH_BodyCreationSettings floorSettings = JPH_BodyCreationSettings_Default();
    floorSettings.position = JPH_RVec3_Make(0, -1, 0);
    floorSettings.rotation = JPH_Quat_sIdentity;
    floorSettings.objectLayer = ObjectLayer_NonMoving;
    floorSettings.motionType = JPH_EMotionType_Static;
    floorSettings.shapePtr = floorShape;

    JPH_Body *floor = JPH_BodyInterface_CreateBody(bodyInterface, &floorSettings);
    JPH_BodyInterface_AddBody(bodyInterface, JPH_Body_GetID(floor), JPH_EActivation_Activate);
    printf("Created floor: %u\n", JPH_Body_GetID(floor));

    JPH_SphereShapeSettings *sphereShapeSettings = JPH_SphereShapeSettings_Create();
    JPH_SphereShapeSettings_SetRadius(sphereShapeSettings, 0.5f);

    JPH_Shape *sphereShape = JPH_ShapeSettings_CreateShape((JPH_ShapeSettings *)sphereShapeSettings);

    JPH_BodyCreationSettings sphereSettings = JPH_BodyCreationSettings_Default();
    sphereSettings.position = JPH_RVec3_Make(0, 2, 0);
    sphereSettings.rotation = JPH_Quat_sIdentity;
    sphereSettings.objectLayer = ObjectLayer_Moving;
    sphereSettings.motionType = JPH_EMotionType_Dynamic;
    sphereSettings.shapePtr = sphereShape;

    JPH_BodyID sphereID = JPH_BodyInterface_CreateAndAddBody(bodyInterface, &sphereSettings, JPH_EActivation_Activate);
    printf("Created sphere: %u\n", sphereID);

    JPH_BodyInterface_SetLinearVelocity(bodyInterface, sphereID, JPH_Vec3_Make(0, -5, 0));

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

        const JPH_NarrowPhaseQuery *query = JPH_PhysicsSystem_GetNarrowPhaseQuery(system);

        JPH_RRayCast ray;
        ray.origin = JPH_RVec3_Make(0, 1, -5);
        ray.direction = JPH_Vec3_Make(0, 0, 50);

        JPH_RayCastResult rayCastResult = JPH_RayCastResult_Default();
        bool hit = JPH_NarrowPhaseQuery_CastRay(query, ray, &rayCastResult, NULL, NULL, NULL);

        if (hit) {
            JPH_Vec3 hitPoint = JPH_RRayCast_GetPointOnRay(&ray, rayCastResult.fraction);
            printf("Hit, Fraction = %f, Point = (%f, %f, %f), BodyID = %u\n", rayCastResult.fraction, hitPoint.x, hitPoint.y, hitPoint.z, rayCastResult.bodyID);
        }
    }

    JPH_BodyInterface_RemoveBody(bodyInterface, sphereID);
    JPH_BodyInterface_DestroyBody(bodyInterface, sphereID);

    JPH_BodyInterface_RemoveBody(bodyInterface, JPH_Body_GetID(floor));
    JPH_BodyInterface_DestroyBody(bodyInterface, JPH_Body_GetID(floor));

    JPH_PhysicsSystem_Destroy(system);

    JPH_ObjectVsBroadPhaseLayerFilter_Destroy((JPH_ObjectVsBroadPhaseLayerFilter *)objectVsBroadPhaseLayerFilter);
    JPH_ObjectLayerPairFilter_Destroy((JPH_ObjectLayerPairFilter *)objectLayerPairFilter);
    JPH_BroadPhaseLayerInterface_Destroy((JPH_BroadPhaseLayerInterface *)bplInterface);

    JPH_JobSystem_Destroy(jobSystem);
    JPH_TempAllocator_Destroy(tempAllocator);

    JPH_UnregisterTypes();
    JPH_DestroyFactory();
}
