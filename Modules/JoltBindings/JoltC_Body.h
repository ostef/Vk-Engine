#pragma once

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

// @Todo: BodyFilter
