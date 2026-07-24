#pragma once

#include <JoltC_Core.h>

typedef struct JPH_BodyInterface     JPH_BodyInterface;
typedef struct JPH_BodyLockInterface JPH_BodyLockInterface;
typedef struct JPH_Body JPH_Body;

typedef uint32_t JPH_BodyID;

typedef uint8_t JPH_EBodyType;
enum {
    JPH_EBodyType_RigidBody,
    JPH_EBodyType_SoftBody,
};

typedef struct JPH_BodyManager_BodyStats {
    uint32_t numBodies;
    uint32_t maxBodies;
    uint32_t numBodiesStatic;
    uint32_t numBodiesDynamic;
    uint32_t numActiveBodiesDynamic;
    uint32_t numBodiesKinematic;
    uint32_t numActiveBodiesKinematic;
    uint32_t numSoftBodies;
    uint32_t numActiveSoftBodies;
} JPH_BodyManager_BodyStats;

// @Todo: BodyFilter
