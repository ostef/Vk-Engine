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

    JPH_PhysicsSystemSettings systemSettings = (JPH_PhysicsSystemSettings){
        .maxBodies=1024,
        .numBodyMutexes=0,
        .maxBodyPairs=1024,
        .maxContactConstraints=1024,
        .broadPhaseLayerInterface=bplInterface,
        .objectVsBroadPhaseLayerFilter=objectVsBroadPhaseLayerFilter,
        .objectLayerPairFilter=objectLayerPairFilter,
    };
    JPH_PhysicsSystem *system = JPH_PhysicsSystem_Create(systemSettings);

    JPH_PhysicsSystem_Destroy(system);

    JPH_ObjectVsBroadPhaseLayerFilter_Destroy(objectVsBroadPhaseLayerFilter);
    JPH_ObjectLayerPairFilter_Destroy(objectLayerPairFilter);
    JPH_BroadPhaseLayerInterface_Destroy(bplInterface);

    JPH_JobSystem_Destroy(jobSystem);
    JPH_TempAllocator_Destroy(tempAllocator);

    JPH_UnregisterTypes();
    JPH_DestroyFactory();
}
