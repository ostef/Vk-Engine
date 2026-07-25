#pragma once

// @Todo: BodyFilter

#include <JoltC_Core.h>
#include <JoltC_Collision.h>
#include <JoltC_Shapes.h>

typedef struct JPH_BodyInterface             JPH_BodyInterface;
typedef struct JPH_BodyLockInterface         JPH_BodyLockInterface;
typedef struct JPH_Body                      JPH_Body;
typedef struct JPH_MotionProperties          JPH_MotionProperties;
typedef struct JPH_SoftBodyMotionProperties  JPH_SoftBodyMotionProperties;
typedef struct JPH_SoftBodySharedSettings    JPH_SoftBodySharedSettings;

typedef uint32_t JPH_BodyID;

#define JPH_cInvalidBodyID 0xffffffff

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

// BodyCreationSettings

typedef uint8_t JPH_EOverrideMassProperties;
enum {
    CalculateMassAndInertia,
    CalculateInertia,
    MassAndInertiaProvided
};

typedef struct JPH_BodyCreationSettings {
    JPH_RVec3 position;
    JPH_Quat rotation;
    JPH_Vec3 linearVelocity;
    JPH_Vec3 angularVelocity;
    uint64_t userData;
    JPH_ObjectLayer objectLayer;
    JPH_CollisionGroup collisionGrou;
    JPH_EMotionType motionType;
    JPH_EAllowedDOFs allowedDOFs;
    bool allowDynamicOrKinematic;
    bool isSensor;
    bool collideKinematicVsNonDynamic;
    bool useManifoldReduction;
    bool applyGyroscopicForce;
    JPH_EMotionQuality motionQuality;
    bool enhancedInternalEdgeRemoval;
    bool allowSleeping;
    float friction;
    float restitution;
    float linearDamping;
    float angularDamping;
    float maxLinearVelocity;
    float maxAngularVelocity;
    float gravityFactor;
    uint32_t numVelocityStepsOverride;
    uint32_t numPositionStepsOverride;
    JPH_EOverrideMassProperties overrideMassProperties;
    float inertiaMultiplier;
    JPH_MassProperties massPropertiesOverride;
    const JPH_ShapeSettings *shape;
    const JPH_Shape *shapePtr;
} JPH_BodyCreationSettings;

JOLTC_API void JPH_BodyCreationSettings_SetDefaults(JPH_BodyCreationSettings *settings);
JOLTC_API JPH_Shape *JPH_BodyCreationSettings_ConvertShapeSettings(JPH_BodyCreationSettings *settings);
JOLTC_API bool JPH_BodyCreationSettings_HasMassProperties(const JPH_BodyCreationSettings *settings);
JOLTC_API JPH_MassProperties JPH_BodyCreationSettings_GetMassProperties(const JPH_BodyCreationSettings *settings);

// SoftBodyCreationSettings

typedef struct JPH_SoftBodyCreationSettings {
    const JPH_SoftBodySharedSettings *settings;
    JPH_RVec3 position;
    JPH_Quat rotation;
    uint64_t userData;
    JPH_ObjectLayer objectLayer;
    JPH_CollisionGroup collisionGroup;
    uint32_t numIterations;
    float linearDamping;
    float maxLinearVelocity;
    float restitution;
    float friction;
    float pressure;
    float gravityFactor;
    float vertexRadius;
    bool updatePosition;
    bool makeRotationIdentity;
    bool allowSleeping;
    bool facesDoubleSided;
} JPH_SoftBodyCreationSettings;

JOLTC_API void JPH_SoftBodyCreationSettings_SetDefaults(JPH_SoftBodyCreationSettings *settings);

// BodyInterface

typedef uint32_t JPH_EActivation;
enum {
    JPH_EActivation_Activate,
    JPH_EActivation_DontActivate,
};

JOLTC_API JPH_Body *JPH_BodyInterface_CreateBody(JPH_BodyInterface *bodyInterface, const JPH_BodyCreationSettings *settings);
JOLTC_API JPH_Body *JPH_BodyInterface_CreateSoftBody(JPH_BodyInterface *bodyInterface, const JPH_SoftBodyCreationSettings *settings);
JOLTC_API JPH_Body *JPH_BodyInterface_CreateBodyWithID(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, const JPH_BodyCreationSettings *settings);
JOLTC_API JPH_Body *JPH_BodyInterface_CreateSoftBodyWithID(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, const JPH_SoftBodyCreationSettings *settings);
JOLTC_API JPH_Body *JPH_BodyInterface_CreateBodyWithoutID(const JPH_BodyInterface *bodyInterface, const JPH_BodyCreationSettings *settings);
JOLTC_API JPH_Body *JPH_BodyInterface_CreateSoftBodyWithoutID(const JPH_BodyInterface *bodyInterface, const JPH_SoftBodyCreationSettings *settings);
JOLTC_API void JPH_BodyInterface_DestroyBodyWithoutID(const JPH_BodyInterface *bodyInterface, JPH_Body *body);
JOLTC_API bool JPH_BodyInterface_AssignBodyID(JPH_BodyInterface *bodyInterface, JPH_Body *ioBody);
JOLTC_API bool JPH_BodyInterface_SetBodyID(JPH_BodyInterface *bodyInterface, JPH_Body *ioBody, JPH_BodyID bodyID);
JOLTC_API JPH_Body *JPH_BodyInterface_UnassignBodyID(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_UnassignBodyIDs(JPH_BodyInterface *bodyInterface, const JPH_BodyID *bodyIDs, int count, JPH_Body **outBodies);
JOLTC_API void JPH_BodyInterface_DestroyBody(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_DestroyBodies(JPH_BodyInterface *bodyInterface, const JPH_BodyID *bodyIDs, int count);
JOLTC_API void JPH_BodyInterface_AddBody(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_EActivation activationMode);
JOLTC_API void JPH_BodyInterface_RemoveBody(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API bool JPH_BodyInterface_IsAdded(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API JPH_BodyID JPH_BodyInterface_CreateAndAddBody(JPH_BodyInterface *bodyInterface, const JPH_BodyCreationSettings *settings, JPH_EActivation activationMode);
JOLTC_API JPH_BodyID JPH_BodyInterface_CreateAndAddSoftBody(JPH_BodyInterface *bodyInterface, const JPH_SoftBodyCreationSettings *settings, JPH_EActivation activationMode);
// JOLTC_API JPH_TwoBodyConstraint *JPH_BodyInterface_CreateConstraint(JPH_BodyInterface *bodyInterface, const TwoBodyConstraintSettings *settings, JPH_BodyID bodyID1, JPH_BodyID bodyID2);
// JOLTC_APIvoid JPH_BodyInterface_ActivateConstraint(JPH_BodyInterface *bodyInterface, const TwoBodyConstraint *constraint);
JOLTC_API void JPH_BodyInterface_MoveKinematic(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 targetPosition, JPH_Quat targetRotation, float deltaTime);
JOLTC_API void JPH_BodyInterface_SetLinearAndAngularVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 linearVelocity, JPH_Vec3 angularVelocity);
JOLTC_API void JPH_BodyInterface_GetLinearAndAngularVelocity(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 *outLinearVelocity, JPH_Vec3 *outAngularVelocity);
JOLTC_API void JPH_BodyInterface_SetLinearVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 linearVelocity);
JOLTC_API JPH_Vec3 JPH_BodyInterface_GetLinearVelocity(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_AddLinearVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 linearVelocity);
JOLTC_API void JPH_BodyInterface_AddLinearAndAngularVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 linearVelocity, JPH_Vec3 angularVelocity);
JOLTC_API void JPH_BodyInterface_SetAngularVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 angularVelocity);
JOLTC_API JPH_Vec3 JPH_BodyInterface_GetAngularVelocity(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API JPH_Vec3 JPH_BodyInterface_GetPointVelocity(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 point);
JOLTC_API void JPH_BodyInterface_SetPositionRotationAndVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 position, JPH_Quat rotation, JPH_Vec3 linearVelocity, JPH_Vec3 angularVelocity);
JOLTC_API JPH_Mat44 JPH_BodyInterface_GetInverseInertia(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
// JOLTC_API TransformedShape const JPH_BodyInterface_GetTransformedShape(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API uint64_t JPH_BodyInterface_GetUserData(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetUserData(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, uint64_t userData);
JOLTC_API const JPH_PhysicsMaterial *JPH_BodyInterface_GetMaterial(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_SubShapeID subShapeID);
JOLTC_API void JPH_BodyInterface_InvalidateContactCache(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void *JPH_BodyInterface_AddBodiesPrepare(JPH_BodyInterface *bodyInterface, JPH_BodyID *ioBodies, int count);
JOLTC_API void JPH_BodyInterface_AddBodiesFinalize(JPH_BodyInterface *bodyInterface, JPH_BodyID *ioBodies, int count, void *addState, JPH_EActivation activationMode);
JOLTC_API void JPH_BodyInterface_AddBodiesAbort(JPH_BodyInterface *bodyInterface, JPH_BodyID *ioBodies, int count, void *addState);
JOLTC_API void JPH_BodyInterface_RemoveBodies(JPH_BodyInterface *bodyInterface, JPH_BodyID *ioBodies, int count);
JOLTC_API void JPH_BodyInterface_ActivateBody(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_ActivateBodies(JPH_BodyInterface *bodyInterface, const JPH_BodyID *bodyIDs, int count);
JOLTC_API void JPH_BodyInterface_ActivateBodiesInAABox(JPH_BodyInterface *bodyInterface, JPH_AABox inBox, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter);
JOLTC_API void JPH_BodyInterface_DeactivateBody(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_DeactivateBodies(JPH_BodyInterface *bodyInterface, const JPH_BodyID *bodyIDs, int count);
JOLTC_API bool JPH_BodyInterface_IsActive(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_ResetSleepTimer(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API const JPH_Shape *JPH_BodyInterface_GetShape(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetShape(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, const JPH_Shape *shape, bool updateMassProperties, JPH_EActivation activationMode);
JOLTC_API void JPH_BodyInterface_NotifyShapeChanged(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 inPreviousCenterOfMass, bool updateMassProperties, JPH_EActivation activationMode);
JOLTC_API void JPH_BodyInterface_SetObjectLayer(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_ObjectLayer layer);
JOLTC_API JPH_ObjectLayer JPH_BodyInterface_GetObjectLayer(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetPositionAndRotation(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 position, JPH_Quat rotation, JPH_EActivation activationMode);
JOLTC_API void JPH_BodyInterface_SetPositionAndRotationWhenChanged(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 position, JPH_Quat rotation, JPH_EActivation activationMode);
JOLTC_API void JPH_BodyInterface_GetPositionAndRotation(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 *outPosition, JPH_Quat *outRotation);
JOLTC_API void JPH_BodyInterface_SetPosition(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 position, JPH_EActivation activationMode);
JOLTC_API JPH_RVec3 JPH_BodyInterface_GetPosition(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API JPH_RVec3 JPH_BodyInterface_GetCenterOfMassPosition(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetRotation(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Quat rotation, JPH_EActivation activationMode);
JOLTC_API JPH_Quat JPH_BodyInterface_GetRotation(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API JPH_RMat44 JPH_BodyInterface_GetWorldTransform(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API JPH_RMat44 JPH_BodyInterface_GetCenterOfMassTransform(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_AddForce(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 force, JPH_EActivation activationMode);
JOLTC_API void JPH_BodyInterface_AddForceAtPoint(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 force, JPH_RVec3 point, JPH_EActivation activationMode);
JOLTC_API void JPH_BodyInterface_AddTorque(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 torque, JPH_EActivation activationMode);;
JOLTC_API void JPH_BodyInterface_AddForceAndTorque(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 force, JPH_Vec3 torque, JPH_EActivation activationMode);
JOLTC_API void JPH_BodyInterface_AddImpulse(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 impulse);
JOLTC_API void JPH_BodyInterface_AddImpulseAtPoint(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 impulse, JPH_RVec3 point);
JOLTC_API void JPH_BodyInterface_AddAngularImpulse(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 angularImpulse);
JOLTC_API bool JPH_BodyInterface_ApplyBuoyancyImpulse(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 surfacePosition, JPH_Vec3 surfaceNormal, float buoyancy, float linearDrag, float angularDrag, JPH_Vec3 fluidVelocity, JPH_Vec3 gravity, float deltaTime);
JOLTC_API JPH_EBodyType JPH_BodyInterface_GetBodyType(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetMotionType(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_EMotionType motionType, JPH_EActivation activationMode);
JOLTC_API JPH_EMotionType JPH_BodyInterface_GetMotionType(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetMotionQuality(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_EMotionQuality motionQuality);
JOLTC_API JPH_EMotionQuality JPH_BodyInterface_GetMotionQuality(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetRestitution(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, float restitution);
JOLTC_API float JPH_BodyInterface_GetRestitution(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetFriction(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, float friction);
JOLTC_API float JPH_BodyInterface_GetFriction(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetGravityFactor(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, float gravityFactor);
JOLTC_API float JPH_BodyInterface_GetGravityFactor(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetMaxLinearVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, float linearVelocity);
JOLTC_API float JPH_BodyInterface_GetMaxLinearVelocity(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetMaxAngularVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, float angularVelocity);
JOLTC_API float JPH_BodyInterface_GetMaxAngularVelocity(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetUseManifoldReduction(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, bool useReduction);
JOLTC_API bool JPH_BodyInterface_GetUseManifoldReduction(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetIsSensor(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, bool isSensor);
JOLTC_API bool JPH_BodyInterface_IsSensor(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
JOLTC_API void JPH_BodyInterface_SetCollisionGroup(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, const JPH_CollisionGroup *collisionGroup);
JOLTC_API const JPH_CollisionGroup *JPH_BodyInterface_GetCollisionGroup(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);

// BodyLockInterface

typedef uint64_t JPH_BodyManager_MutexMask;

JOLTC_API JPH_Body *JPH_BodyLockInterface_TryGetBody(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyID bodyID);

typedef struct JPH_BodyLockRead {
    JPH_SharedMutex *bodyLockMutex;
    const JPH_Body *body;
} JPH_BodyLockRead;

typedef struct JPH_BodyLockWrite {
    JPH_SharedMutex *bodyLockMutex;
    JPH_Body *body;
} JPH_BodyLockWrite;

JOLTC_API void JPH_BodyLockInterface_LockRead(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyID bodyID, JPH_BodyLockRead *outLock);
JOLTC_API void JPH_BodyLockInterface_UnlockRead(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyLockRead *outLock);
JOLTC_API void JPH_BodyLockInterface_LockWrite(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyID bodyID, JPH_BodyLockWrite *outLock);
JOLTC_API void JPH_BodyLockInterface_UnlockWrite(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyLockWrite *outLock);

typedef struct JPH_BodyLockMultiRead {
    JPH_BodyManager_MutexMask mutexMask;
    const JPH_BodyID *bodyIDs;
    int numBodies;
} JPH_BodyLockMultiRead;

typedef struct JPH_BodyLockMultiWrite {
    JPH_BodyManager_MutexMask mutexMask;
    const JPH_BodyID *bodyIDs;
    int numBodies;
} JPH_BodyLockMultiWrite;

JOLTC_API void JPH_BodyLockInterface_LockReadMulti(const JPH_BodyLockInterface *bodyLockInterface, const JPH_BodyID *bodyIDs, int numBodies, JPH_BodyLockMultiRead *outLock);
JOLTC_API void JPH_BodyLockInterface_UnlockReadMulti(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyLockMultiRead *outLock);
JOLTC_API void JPH_BodyLockInterface_LockWriteMulti(const JPH_BodyLockInterface *bodyLockInterface, const JPH_BodyID *bodyIDs, int numBodies, JPH_BodyLockMultiWrite *outLock);
JOLTC_API void JPH_BodyLockInterface_UnlockWriteMulti(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyLockMultiWrite *outLock);

JOLTC_API const JPH_Body *JPH_BodyLockMultiRead_GetBody(const JPH_BodyLockMultiRead *lock, int bodyIndex);
JOLTC_API JPH_Body *JPH_BodyLockMultiWrite_GetBody(const JPH_BodyLockMultiWrite *lock, int bodyIndex);

JOLTC_API void JPH_BodyLockInterface_LockReadAll(const JPH_BodyLockInterface *bodyLockInterface);
JOLTC_API void JPH_BodyLockInterface_UnlockReadAll(const JPH_BodyLockInterface *bodyLockInterface);

JOLTC_API void JPH_BodyLockInterface_LockWriteAll(const JPH_BodyLockInterface *bodyLockInterface);
JOLTC_API void JPH_BodyLockInterface_UnlockWriteAll(const JPH_BodyLockInterface *bodyLockInterface);

// Body

JPH_BodyID JPH_Body_GetID(const JPH_Body *body);
JPH_EBodyType JPH_Body_GetBodyType(const JPH_Body *body);
bool JPH_Body_IsRigidBody(const JPH_Body *body);
bool JPH_Body_IsSoftBody(const JPH_Body *body);
bool JPH_Body_IsActive(const JPH_Body *body);
bool JPH_Body_IsStatic(const JPH_Body *body);
bool JPH_Body_IsKinematic(const JPH_Body *body);
bool JPH_Body_IsDynamic(const JPH_Body *body);
bool JPH_Body_CanBeKinematicOrDynamic(const JPH_Body *body);
void JPH_Body_SetIsSensor(JPH_Body *body, bool isSensor);
bool JPH_Body_IsSensor(const JPH_Body *body);
void JPH_Body_SetCollideKinematicVsNonDynamic(JPH_Body *body, bool collide);
bool JPH_Body_GetCollideKinematicVsNonDynamic(const JPH_Body *body);
void JPH_Body_SetUseManifoldReduction(JPH_Body *body, bool useReduction);
bool JPH_Body_GetUseManifoldReduction(const JPH_Body *body);
bool JPH_Body_GetUseManifoldReductionWithBody(const JPH_Body *body, const JPH_Body *body2);
void JPH_Body_SetApplyGyroscopicForce(JPH_Body *body, bool apply);
bool JPH_Body_GetApplyGyroscopicForce(const JPH_Body *body);
void JPH_Body_SetEnhancedInternalEdgeRemoval(JPH_Body *body, bool apply);
bool JPH_Body_GetEnhancedInternalEdgeRemoval(const JPH_Body *body);
bool JPH_Body_GetEnhancedInternalEdgeRemovalWithBody(const JPH_Body *body, const JPH_Body *body2);
JPH_EMotionType JPH_Body_GetMotionType(const JPH_Body *body);
void JPH_Body_SetMotionType(JPH_Body *body, JPH_EMotionType motionType);
JPH_BroadPhaseLayer JPH_Body_GetBroadPhaseLayer(const JPH_Body *body);
JPH_ObjectLayer JPH_Body_GetObjectLayer(const JPH_Body *body);
const JPH_CollisionGroup *JPH_Body_GetCollisionGroup(const JPH_Body *body);
JPH_CollisionGroup *JPH_Body_GetCollisionGroup(JPH_Body *body);
void JPH_Body_SetCollisionGroup(JPH_Body *body, const JPH_CollisionGroup *group);
bool JPH_Body_GetAllowSleeping(const JPH_Body *body);
void JPH_Body_SetAllowSleeping(JPH_Body *body, bool allow);
void JPH_Body_ResetSleepTimer(JPH_Body *body);
float JPH_Body_GetFriction(const JPH_Body *body);
void JPH_Body_SetFriction(JPH_Body *body, float friction);
float JPH_Body_GetRestitution(const JPH_Body *body);
void JPH_Body_SetRestitution(JPH_Body *body, float restitution);
JPH_Vec3 JPH_Body_GetLinearVelocity(const JPH_Body *body);
void JPH_Body_SetLinearVelocity(JPH_Body *body, JPH_Vec3 linearVelocity);
void JPH_Body_SetLinearVelocityClamped(JPH_Body *body, JPH_Vec3 linearVelocity);
JPH_Vec3 JPH_Body_GetAngularVelocity(const JPH_Body *body);
void JPH_Body_SetAngularVelocity(JPH_Body *body, JPH_Vec3 angularVelocity);
void JPH_Body_SetAngularVelocityClamped(JPH_Body *body, JPH_Vec3 angularVelocity);
JPH_Vec3 JPH_Body_GetPointVelocityCOM(const JPH_Body *body, JPH_Vec3 pointRelativeToCOM);
JPH_Vec3 JPH_Body_GetPointVelocity(const JPH_Body *body, JPH_RVec3 point);
void JPH_Body_AddForce(JPH_Body *body, JPH_Vec3 force);
void JPH_Body_AddForceAtPoint(JPH_Body *body, JPH_Vec3 force, JPH_RVec3 position);
void JPH_Body_AddTorque(JPH_Body *body, JPH_Vec3 torque);
JPH_Vec3 JPH_Body_GetAccumulatedForce(const JPH_Body *body);
JPH_Vec3 JPH_Body_GetAccumulatedTorque(const JPH_Body *body);
void JPH_Body_ResetForce(JPH_Body *body);
void JPH_Body_ResetTorque(JPH_Body *body);
void JPH_Body_ResetMotion(JPH_Body *body);
JPH_Mat44 JPH_Body_GetInverseInertia(const JPH_Body *body);
void JPH_Body_AddImpulse(JPH_Body *body, JPH_Vec3 impulse);
void JPH_Body_AddImpulseAtPoint(JPH_Body *body, JPH_Vec3 impulse, JPH_RVec3 position);
void JPH_Body_AddAngularImpulse(JPH_Body *body, JPH_Vec3 angularImpulse);
void JPH_Body_MoveKinematic(JPH_Body *body, JPH_RVec3 targetPosition, JPH_Quat targetRotation, float deltaTime);
void JPH_Body_GetSubmergedVolume(const JPH_Body *body, JPH_RVec3 surfacePosition, JPH_Vec3 surfaceNormal, float *outTotalVolume, float *outSubmergedVolume, JPH_Vec3 *outRelativeCenterOfBuoyancy);
bool JPH_Body_ApplyBuoyancyImpulseWithSurface(JPH_Body *body, JPH_RVec3 surfacePosition, JPH_Vec3 surfaceNormal, float buoyancy, float linearDrag, float angularDrag, JPH_Vec3 fluidVelocity, JPH_Vec3 gravity, float deltaTime);
bool JPH_Body_ApplyBuoyancyImpulse(JPH_Body *body, float totalVolume, float submergedVolume, JPH_Vec3 relativeCenterOfBuoyancy, float buoyancy, float linearDrag, float angularDrag, JPH_Vec3 fluidVelocity, JPH_Vec3 gravity, float deltaTime);
bool JPH_Body_IsInBroadPhase(const JPH_Body *body);
bool JPH_Body_IsCollisionCacheInvalid(const JPH_Body *body);
const JPH_Shape *JPH_Body_GetShape(const JPH_Body *body);
JPH_RVec3 JPH_Body_GetPosition(const JPH_Body *body);
JPH_Quat JPH_Body_GetRotation(const JPH_Body *body);
JPH_RMat44 JPH_Body_GetWorldTransform(const JPH_Body *body);
JPH_RVec3 JPH_Body_GetCenterOfMassPosition(const JPH_Body *body);
JPH_RMat44 JPH_Body_GetCenterOfMassTransform(const JPH_Body *body);
JPH_RMat44 JPH_Body_GetInverseCenterOfMassTransform(const JPH_Body *body);
JPH_AABox JPH_Body_GetWorldSpaceBounds(const JPH_Body *body);
const JPH_MotionProperties *JPH_Body_GetMotionProperties(const JPH_Body *body);
JPH_MotionProperties *JPH_Body_GetMotionProperties(JPH_Body *body);
const JPH_MotionProperties *JPH_Body_GetMotionPropertiesUnchecked(const JPH_Body *body);
JPH_MotionProperties *JPH_Body_GetMotionPropertiesUnchecked(JPH_Body *body);
uint64_t JPH_Body_GetUserData(const JPH_Body *body);
void JPH_Body_SetUserData(JPH_Body *body, uint64_t userData);
JPH_Vec3 JPH_Body_GetWorldSpaceSurfaceNormal(const JPH_Body *body, JPH_SubShapeID subShapeID, JPH_RVec3 position);
// TransformedShape JPH_Body_GetTransformedShape(const JPH_Body *body);
JPH_BodyCreationSettings JPH_Body_GetBodyCreationSettings(const JPH_Body *body);
void JPH_Body_ApplyBodyCreationSettings(JPH_Body *body, const JPH_BodyCreationSettings *bodyCreationSettings, const JPH_BroadPhaseLayerInterface *bplInterface);
JPH_SoftBodyCreationSettings JPH_Body_GetSoftBodyCreationSettings(const JPH_Body *body);
void JPH_Body_ApplySoftBodyCreationSettings(JPH_Body *body, const JPH_SoftBodyCreationSettings *softBodyCreationSettings, const JPH_BroadPhaseLayerInterface *bplInterface);
