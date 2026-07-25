#pragma once

#include <JoltC_Core.h>
#include <JoltC_Body.h>
#include <JoltC_Collision.h>
#ifdef JPH_DEBUG_RENDERER
#include <JoltC_DebugRenderer.h>
#endif

typedef struct JPH_PhysicsSystem JPH_PhysicsSystem;

typedef struct JPH_PhysicsSystemSettings {
    uint32_t maxBodies;
    uint32_t numBodyMutexes;
    uint32_t maxBodyPairs;
    uint32_t maxContactConstraints;
    const JPH_BroadPhaseLayerInterface *broadPhaseLayerInterface;
    const JPH_ObjectVsBroadPhaseLayerFilter *objectVsBroadPhaseLayerFilter;
    const JPH_ObjectLayerPairFilter *objectLayerPairFilter;
} JPH_PhysicsSystemSettings;

JOLTC_API JPH_PhysicsSystem *JPH_PhysicsSystem_Create(JPH_PhysicsSystemSettings settings);
JOLTC_API void JPH_PhysicsSystem_Destroy(JPH_PhysicsSystem *system);

JOLTC_API void JPH_PhysicsSystem_SetPhysicsSettings(JPH_PhysicsSystem *system, JPH_PhysicsSettings settings);
JOLTC_API JPH_PhysicsSettings JPH_PhysicsSystem_GetPhysicsSettings(const JPH_PhysicsSystem *system);
JOLTC_API void JPH_PhysicsSystem_SetGravity(JPH_PhysicsSystem *system, JPH_Vec3 gravity);
JOLTC_API JPH_Vec3 JPH_PhysicsSystem_GetGravity(const JPH_PhysicsSystem *system);
JOLTC_API uint32_t JPH_PhysicsSystem_GetNumBodies(const JPH_PhysicsSystem *system);
JOLTC_API uint32_t JPH_PhysicsSystem_GetNumActiveBodies(const JPH_PhysicsSystem *system, JPH_EBodyType type);
JOLTC_API uint32_t JPH_PhysicsSystem_GetMaxBodies(const JPH_PhysicsSystem *system);
JOLTC_API JPH_BodyManager_BodyStats JPH_PhysicsSystem_GetBodyStats(const JPH_PhysicsSystem *system);
JOLTC_API uint32_t JPH_PhysicsSystem_GetBodies(const JPH_PhysicsSystem *system, JPH_BodyID **outIDs, JPH_Allocator allocator);
JOLTC_API uint32_t JPH_PhysicsSystem_GetActiveBodies(const JPH_PhysicsSystem *system, JPH_EBodyType type, JPH_BodyID **outIDs, JPH_Allocator allocator);
JOLTC_API const JPH_BodyID *JPH_PhysicsSystem_GetActiveBodiesUnsafe(const JPH_PhysicsSystem *system, JPH_EBodyType type);
JOLTC_API bool JPH_PhysicsSystem_WereBodiesInContact(const JPH_PhysicsSystem *system, JPH_BodyID body1ID, JPH_BodyID body2ID);
JOLTC_API JPH_AABox JPH_PhysicsSystem_GetBounds(const JPH_PhysicsSystem *system);

JOLTC_API JPH_BodyInterface *JPH_PhysicsSystem_GetBodyInterface(JPH_PhysicsSystem *system);
JOLTC_API const JPH_BodyInterface *JPH_PhysicsSystem_GetBodyInterfaceConst(const JPH_PhysicsSystem *system);
JOLTC_API JPH_BodyInterface *JPH_PhysicsSystem_GetBodyInterfaceNoLock(JPH_PhysicsSystem *system);
JOLTC_API const JPH_BodyInterface *JPH_PhysicsSystem_GetBodyInterfaceNoLockConst(const JPH_PhysicsSystem *system);
JOLTC_API const JPH_BroadPhaseQuery *JPH_PhysicsSystem_GetBroadPhaseQuery(const JPH_PhysicsSystem *system);
JOLTC_API const JPH_NarrowPhaseQuery *JPH_PhysicsSystem_GetNarrowPhaseQuery(const JPH_PhysicsSystem *system);
JOLTC_API const JPH_NarrowPhaseQuery *JPH_PhysicsSystem_GetNarrowPhaseQueryNoLock(const JPH_PhysicsSystem *system);
JOLTC_API const JPH_BodyLockInterface *JPH_PhysicsSystem_GetBodyLockInterface(const JPH_PhysicsSystem *system);
JOLTC_API const JPH_BodyLockInterface *JPH_PhysicsSystem_GetBodyLockInterfaceNoLock(const JPH_PhysicsSystem *system);
JOLTC_API const JPH_BroadPhaseLayerInterface *JPH_PhysicsSystem_GetBroadPhaseLayerInterface(const JPH_PhysicsSystem *system);
JOLTC_API const JPH_ObjectVsBroadPhaseLayerFilter *JPH_PhysicsSystem_GetObjectVsBroadPhaseLayerFilter(const JPH_PhysicsSystem *system);
JOLTC_API const JPH_ObjectLayerPairFilter *JPH_PhysicsSystem_GetObjectLayerPairFilter(const JPH_PhysicsSystem *system);
JOLTC_API JPH_DefaultBroadPhaseLayerFilter JPH_PhysicsSystem_GetDefaultBroadPhaseLayerFilter(const JPH_PhysicsSystem *system, JPH_ObjectLayer layer);
JOLTC_API JPH_DefaultObjectLayerFilter JPH_PhysicsSystem_GetDefaultLayerFilter(const JPH_PhysicsSystem *system, JPH_ObjectLayer layer);

JOLTC_API void JPH_PhysicsSystem_OptimizeBroadPhase(JPH_PhysicsSystem *system);

typedef uint32_t JPH_EPhysicsUpdateError;
enum {
    JPH_EPhysicsUpdateError_None = 0,
    JPH_EPhysicsUpdateError_ManifoldCacheFull = 1 << 0,
    JPH_EPhysicsUpdateError_BodyPairCacheFull = 1 << 1,
    JPH_EPhysicsUpdateError_ContactConstraintsFull = 1 << 2,
};

JOLTC_API JPH_EPhysicsUpdateError JPH_PhysicsSystem_Update(JPH_PhysicsSystem *system, float deltaTime, int collisionSteps, JPH_TempAllocator *tempAllocator, JPH_JobSystem *jobSystem);

#ifdef JPH_DEBUG_RENDERER

JOLTC_API void JPH_PhysicsSystem_DrawBodies(JPH_PhysicsSystem *system, const JPH_BodyManager_DrawSettings *settings, JPH_DebugRenderer *renderer, const JPH_BodyDrawFilter *bodyFilter);
JOLTC_API void JPH_PhysicsSystem_DrawConstraints(JPH_PhysicsSystem *system, JPH_DebugRenderer *renderer);
JOLTC_API void JPH_PhysicsSystem_DrawConstraintLimits(JPH_PhysicsSystem *system, JPH_DebugRenderer *renderer);
JOLTC_API void JPH_PhysicsSystem_DrawConstraintReferenceFrame(JPH_PhysicsSystem *system, JPH_DebugRenderer *renderer);

#endif
