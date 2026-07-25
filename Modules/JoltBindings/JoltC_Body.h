#pragma once

#include <JoltC_Core.h>

typedef struct JPH_BodyInterface             JPH_BodyInterface;
typedef struct JPH_BodyLockInterface         JPH_BodyLockInterface;
typedef struct JPH_Body                      JPH_Body;
typedef struct JPH_MotionProperties          JPH_MotionProperties;
typedef struct JPH_SoftBodyMotionProperties  JPH_SoftBodyMotionProperties;

typedef uint32_t JPH_BodyID;

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

typedef uint8_t JPH_EBodyType;
enum {
    JPH_EBodyType_RigidBody,
    JPH_EBodyType_SoftBody,
};

typedef uint32_t JPH_ECanSleep;
enum {
    JPH_ECanSleep_CannotSleep,
    JPH_ECanSleep_CanSleep,
};

typedef uint8_t JPH_EMotionQuality;
enum {
    JPH_EMotionQuality_Discrete,
    JPH_EMotionQuality_LinearCast,
};

typedef uint8_t JPH_EMotionType;
enum {
    JPH_EMotionType_Static,
    JPH_EMotionType_Kinematic,
    JPH_EMotionType_Dynamic,
};

typedef uint8_t JPH_EAllowedDOFs;
enum {
    JPH_EAllowedDOFs_None = 0,
    JPH_EAllowedDOFs_All = 0xff,
    JPH_EAllowedDOFs_TranslationX = 1 << 0,
    JPH_EAllowedDOFs_TranslationY = 1 << 1,
    JPH_EAllowedDOFs_TranslationZ = 1 << 2,
    JPH_EAllowedDOFs_RotationX = 1 << 3,
    JPH_EAllowedDOFs_RotationY = 1 << 4,
    JPH_EAllowedDOFs_RotationZ = 1 << 5,
    JPH_EAllowedDOFs_Plane2D = JPH_EAllowedDOFs_TranslationX | JPH_EAllowedDOFs_TranslationY | JPH_EAllowedDOFs_TranslationZ,
};

// MotionProperties

// SoftBodyMotionProperties

// @Todo: BodyFilter
