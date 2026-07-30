#include <JoltC.hpp>

JOLTC_SUPPRESS_WARNINGS()

JPH_PhysicsSystem *JPH_PhysicsSystem_Create(JPH_PhysicsSystemSettings settings) {
    auto system = new JPH::PhysicsSystem();
    system->Init(
        settings.maxBodies,
        settings.numBodyMutexes,
        settings.maxBodyPairs,
        settings.maxContactConstraints,
        *ToCpp(settings.broadPhaseLayerInterface),
        *ToCpp(settings.objectVsBroadPhaseLayerFilter),
        *ToCpp(settings.objectLayerPairFilter)
    );

    return ToC(system);
}

void JPH_PhysicsSystem_Destroy(JPH_PhysicsSystem *system) {
    delete ToCpp(system);
}

void JPH_PhysicsSystem_SetPhysicsSettings(JPH_PhysicsSystem *system, JPH_PhysicsSettings settings) {
    JPH::PhysicsSettings cppSettings = {};
    memcpy(reinterpret_cast<void *>(&cppSettings), &settings, sizeof(settings));

    ToCpp(system)->SetPhysicsSettings(cppSettings);
}

JPH_PhysicsSettings JPH_PhysicsSystem_GetPhysicsSettings(const JPH_PhysicsSystem *system) {
    auto settings = ToCpp(system)->GetPhysicsSettings();

    JPH_PhysicsSettings result = {};
    memcpy(&result, reinterpret_cast<void *>(&settings), sizeof(settings));

    return result;
}

void JPH_PhysicsSystem_SetGravity(JPH_PhysicsSystem *system, JPH_Vec3 gravity) {
    ToCpp(system)->SetGravity(ToCpp(gravity));
}

JPH_Vec3 JPH_PhysicsSystem_GetGravity(const JPH_PhysicsSystem *system) {
    return ToC(ToCpp(system)->GetGravity());
}

uint32_t JPH_PhysicsSystem_GetNumBodies(const JPH_PhysicsSystem *system) {
    return ToCpp(system)->GetNumBodies();
}

uint32_t JPH_PhysicsSystem_GetNumActiveBodies(const JPH_PhysicsSystem *system, JPH_EBodyType type) {
    return ToCpp(system)->GetNumActiveBodies(static_cast<JPH::EBodyType>(type));
}

uint32_t JPH_PhysicsSystem_GetMaxBodies(const JPH_PhysicsSystem *system) {
    return ToCpp(system)->GetMaxBodies();
}

JPH_BodyManager_BodyStats JPH_PhysicsSystem_GetBodyStats(const JPH_PhysicsSystem *system) {
    auto stats = ToCpp(system)->GetBodyStats();
    JPH_BodyManager_BodyStats result;
    memcpy(&result, &stats, sizeof(stats));

    return result;
}

uint32_t JPH_PhysicsSystem_GetBodies(const JPH_PhysicsSystem *system, JPH_BodyID **outIDs, JPH_JoltCAllocator allocator) {
    if (!outIDs) {
        return 0;
    }

    JPH::BodyIDVector resultVector = {};
    ToCpp(system)->GetBodies(resultVector);

    uint32_t numBodies = static_cast<uint32_t>(resultVector.size());
    JPH_BodyID *ids = reinterpret_cast<JPH_BodyID *>(JPH_JoltCAllocator_Allocate(allocator, sizeof(JPH_BodyID) * numBodies));
    memcpy(ids, resultVector.data(), sizeof(JPH_BodyID) * numBodies);

    *outIDs = ids;

    return numBodies;
}

uint32_t JPH_PhysicsSystem_GetActiveBodies(const JPH_PhysicsSystem *system, JPH_EBodyType type, JPH_BodyID **outIDs, JPH_JoltCAllocator allocator) {
    if (!outIDs) {
        return 0;
    }

    JPH::BodyIDVector resultVector = {};
    ToCpp(system)->GetActiveBodies(static_cast<JPH::EBodyType>(type), resultVector);

    uint32_t numBodies = static_cast<uint32_t>(resultVector.size());
    JPH_BodyID *ids = reinterpret_cast<JPH_BodyID *>(JPH_JoltCAllocator_Allocate(allocator, sizeof(JPH_BodyID) * numBodies));
    memcpy(ids, resultVector.data(), sizeof(JPH_BodyID) * numBodies);

    *outIDs = ids;

    return numBodies;
}

const JPH_BodyID *JPH_PhysicsSystem_GetActiveBodiesUnsafe(const JPH_PhysicsSystem *system, JPH_EBodyType type) {
    auto bodies = ToCpp(system)->GetActiveBodiesUnsafe(static_cast<JPH::EBodyType>(type));
    return reinterpret_cast<const JPH_BodyID *>(bodies);
}

bool JPH_PhysicsSystem_WereBodiesInContact(const JPH_PhysicsSystem *system, JPH_BodyID body1ID, JPH_BodyID body2ID) {
    return ToCpp(system)->WereBodiesInContact(JPH::BodyID(body1ID), JPH::BodyID(body2ID));
}

JPH_AABox JPH_PhysicsSystem_GetBounds(const JPH_PhysicsSystem *system) {
    return ToC(ToCpp(system)->GetBounds());
}

JPH_BodyInterface *JPH_PhysicsSystem_GetBodyInterface(JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBodyInterface());
}

const JPH_BodyInterface *JPH_PhysicsSystem_GetBodyInterfaceConst(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBodyInterface());
}

JPH_BodyInterface *JPH_PhysicsSystem_GetBodyInterfaceNoLock(JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBodyInterfaceNoLock());
}

const JPH_BodyInterface *JPH_PhysicsSystem_GetBodyInterfaceNoLockConst(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBodyInterfaceNoLock());
}

const JPH_BroadPhaseQuery *JPH_PhysicsSystem_GetBroadPhaseQuery(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBroadPhaseQuery());
}

const JPH_NarrowPhaseQuery *JPH_PhysicsSystem_GetNarrowPhaseQuery(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetNarrowPhaseQuery());
}

const JPH_NarrowPhaseQuery *JPH_PhysicsSystem_GetNarrowPhaseQueryNoLock(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetNarrowPhaseQueryNoLock());
}

const JPH_BodyLockInterface *JPH_PhysicsSystem_GetBodyLockInterface(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBodyLockInterface());
}

const JPH_BodyLockInterface *JPH_PhysicsSystem_GetBodyLockInterfaceNoLock(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBodyLockInterfaceNoLock());
}

const JPH_BroadPhaseLayerInterface *JPH_PhysicsSystem_GetBroadPhaseLayerInterface(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBroadPhaseLayerInterface());
}

const JPH_ObjectVsBroadPhaseLayerFilter *JPH_PhysicsSystem_GetObjectVsBroadPhaseLayerFilter(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetObjectVsBroadPhaseLayerFilter());
}

const JPH_ObjectLayerPairFilter *JPH_PhysicsSystem_GetObjectLayerPairFilter(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetObjectLayerPairFilter());
}

JPH_DefaultBroadPhaseLayerFilter JPH_PhysicsSystem_GetDefaultBroadPhaseLayerFilter(const JPH_PhysicsSystem *system, JPH_ObjectLayer layer) {
    JPH_DefaultBroadPhaseLayerFilter filter = {};
    filter.objectVsBroadPhaseLayerFilter = JPH_PhysicsSystem_GetObjectVsBroadPhaseLayerFilter(system);
    filter.layer = layer;

    return filter;
}

JPH_DefaultObjectLayerFilter JPH_PhysicsSystem_GetDefaultLayerFilter(const JPH_PhysicsSystem *system, JPH_ObjectLayer layer) {
    JPH_DefaultObjectLayerFilter filter = {};
    filter.objectLayerPairFilter = JPH_PhysicsSystem_GetObjectLayerPairFilter(system);
    filter.layer = layer;

    return filter;
}

void JPH_PhysicsSystem_OptimizeBroadPhase(JPH_PhysicsSystem *system) {
    ToCpp(system)->OptimizeBroadPhase();
}

JPH_EPhysicsUpdateError JPH_PhysicsSystem_Update(JPH_PhysicsSystem *system, float deltaTime, int collisionSteps, JPH_TempAllocator *tempAllocator, JPH_JobSystem *jobSystem) {
    return static_cast<JPH_EPhysicsUpdateError>(ToCpp(system)->Update(deltaTime, collisionSteps, ToCpp(tempAllocator), ToCpp(jobSystem)));
}

#ifdef JPH_DEBUG_RENDERER

void JPH_PhysicsSystem_DrawBodies(JPH_PhysicsSystem *system, const JPH_BodyManager_DrawSettings *settings, JPH_DebugRenderer *renderer, const JPH_BodyDrawFilter *bodyFilter) {
    JPH::BodyManager::DrawSettings cppSettings;
    memcpy(reinterpret_cast<void *>(&cppSettings), settings, sizeof(JPH_BodyManager_DrawSettings));

    ToCpp(system)->DrawBodies(cppSettings, ToCpp(renderer), ToCpp(bodyFilter));
}

void JPH_PhysicsSystem_DrawConstraints(JPH_PhysicsSystem *system, JPH_DebugRenderer *renderer) {
    ToCpp(system)->DrawConstraints(ToCpp(renderer));
}

void JPH_PhysicsSystem_DrawConstraintLimits(JPH_PhysicsSystem *system, JPH_DebugRenderer *renderer) {
    ToCpp(system)->DrawConstraintLimits(ToCpp(renderer));
}

void JPH_PhysicsSystem_DrawConstraintReferenceFrame(JPH_PhysicsSystem *system, JPH_DebugRenderer *renderer) {
    ToCpp(system)->DrawConstraintReferenceFrame(ToCpp(renderer));
}

#endif

JOLTC_POP_WARNINGS()
