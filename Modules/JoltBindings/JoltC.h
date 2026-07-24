// @Todo: find a way to bring in comments from the original header files
// Jolt v.5.6.0 C wrapper

#ifndef JOLTC_H
#define JOLTC_H

#include <stdbool.h>
#include <stdint.h>

#if !defined(JOLTC_EXPORT)
#define JOLTC_EXPORT
#endif

#if defined(__cplusplus)
#define JOLTC_EXTERN extern "C"
#else
#define JOLTC_EXTERN extern
#endif

#define JOLTC_API JOLTC_EXTERN JOLTC_EXPORT

#if defined(_WIN32)
#define JOLTC_CALL __cdecl
#else
#define JOLTC_CALL
#endif

typedef uint32_t JPH_Bool;

#ifndef JPH_OBJECT_LAYER_BITS
    #define JPH_OBJECT_LAYER_BITS 16
#endif // JPH_OBJECT_LAYER_BITS
#if JPH_OBJECT_LAYER_BITS == 16
    typedef uint16_t JPH_ObjectLayer;
#elif JPH_OBJECT_LAYER_BITS == 32
    typedef uint32_t JPH_ObjectLayer;
#else
    #error "JPH_OBJECT_LAYER_BITS must be 16 or 32"
#endif

// Custom allocator struct, we have this in an effort to let users provide
// a fast allocation solution specifically for interfaces. We make interfaces
// opaque because the ABI is too complicated (vtables + inheritence), but in a lot
// of places the "right" usage is to create the concrete class on the stack, which
// of course is not possible for opaque data types, hence we allocate dynamically.

// The default empty allocator calls JPH::Allocate and JPH::Free

typedef struct JPH_Allocator {
    void *data;
    void *(JOLTC_CALL *Allocate)(void *data, uint64_t size);
    void (JOLTC_CALL *Free)(void *data, void *ptr);
} JPH_Allocator;

JOLTC_API void *JPH_Allocate(JPH_Allocator allocator, uint64_t size);
JOLTC_API void JPH_Free(JPH_Allocator allocator, void *ptr);

// Math

// @Todo: ensure vector type alignment

typedef union JPH_Vec3 {
    struct {
        float x, y, z;
    };
    float values[4];
} JPH_Vec3;

typedef union JPH_Vec4 {
    struct {
        float x, y, z, w;
    };
    float values[4];
} JPH_Vec4;

typedef struct JPH_Mat44 {
    JPH_Vec4 cols[4];
} JPH_Mat44;

typedef union JPH_DVec3 {
    struct {
        double x, y, z;
    };
    double values[4];
} JPH_DVec3;

typedef union JPH_DVec4 {
    struct {
        double x, y, z, w;
    };
    double values[4];
} JPH_DVec4;

typedef struct JPH_DMat44 {
    JPH_DVec4 cols[4];
} JPH_DMat44;

#ifdef JPH_DOUBLE_PRECISION

typedef JPH_DVec3  JPH_RVec3;
typedef JPH_DMat44 JPH_RMat44;

#else

typedef JPH_Vec3  JPH_RVec3;
typedef JPH_Mat44 JPH_RMat44;

#endif

typedef union JPH_Quat {
    struct {
        float x, y, z, w;
    };
    float values[4];
} JPH_Quat;

typedef uint32_t JPH_Color;

typedef struct JPH_AABox {
    JPH_Vec3 min;
    JPH_Vec3 max;
} JPH_AABox;

typedef struct JPH_Plane {
    JPH_Vec4 normalAndConstant;
} JPH_Plane;

JOLTC_API JPH_Plane JPH_Plane_Make(JPH_Vec3 normal, float constant);
JOLTC_API JPH_Plane JPH_Plane_Offset(JPH_Plane plane, float distance);
JOLTC_API JPH_Plane JPH_Plane_Scaled(JPH_Plane plane, JPH_Vec3 scale);
JOLTC_API JPH_Plane JPH_Plane_GetTransformed(JPH_Plane plane, JPH_Mat44 transform);
JOLTC_API float JPH_Plane_SignedDistance(JPH_Plane plane, JPH_Vec3 point);
JOLTC_API JPH_Vec3 JPH_Plane_ProjectPointOnPlane(JPH_Plane plane, JPH_Vec3 point);
JOLTC_API JPH_Plane JPH_Plane_FromPointAndNormal(JPH_Vec3 point, JPH_Vec3 normal);

typedef uint8_t JPH_BroadPhaseLayer;
typedef uint32_t JPH_CollisionGroupID;
typedef uint32_t JPH_CollisionSubGroupID;
typedef uint32_t JPH_CharacterID;

// Opaque structs

typedef struct JPH_PhysicsSystem     JPH_PhysicsSystem;
typedef struct JPH_BodyInterface     JPH_BodyInterface;
typedef struct JPH_BodyLockInterface JPH_BodyLockInterface;
typedef struct JPH_BroadPhaseQuery   JPH_BroadPhaseQuery;
typedef struct JPH_NarrowPhaseQuery  JPH_NarrowPhaseQuery;
typedef struct JPH_TempAllocator     JPH_TempAllocator;
typedef struct JPH_JobSystem         JPH_JobSystem;

typedef struct JPH_BroadPhaseLayerInterface      JPH_BroadPhaseLayerInterface;
typedef struct JPH_ObjectVsBroadPhaseLayerFilter JPH_ObjectVsBroadPhaseLayerFilter;
typedef struct JPH_ObjectLayerPairFilter         JPH_ObjectLayerPairFilter;
typedef struct JPH_BroadPhaseLayerFilter         JPH_BroadPhaseLayerFilter;
typedef struct JPH_ObjectLayerFilter             JPH_ObjectLayerFilter;

// Shape settings

typedef struct JPH_ShapeSettings                   JPH_ShapeSettings;
typedef struct JPH_ConvexShapeSettings             JPH_ConvexShapeSettings;
typedef struct JPH_SphereShapeSettings             JPH_SphereShapeSettings;
typedef struct JPH_BoxShapeSettings                JPH_BoxShapeSettings;
typedef struct JPH_PlaneShapeSettings              JPH_PlaneShapeSettings;
typedef struct JPH_TriangleShapeSettings           JPH_TriangleShapeSettings;
typedef struct JPH_CapsuleShapeSettings            JPH_CapsuleShapeSettings;
typedef struct JPH_TaperedCapsuleShapeSettings     JPH_TaperedCapsuleShapeSettings;
typedef struct JPH_CylinderShapeSettings           JPH_CylinderShapeSettings;
typedef struct JPH_TaperedCylinderShapeSettings    JPH_TaperedCylinderShapeSettings;
typedef struct JPH_ConvexHullShapeSettings         JPH_ConvexHullShapeSettings;
typedef struct JPH_CompoundShapeSettings           JPH_CompoundShapeSettings;
typedef struct JPH_StaticCompoundShapeSettings     JPH_StaticCompoundShapeSettings;
typedef struct JPH_MutableCompoundShapeSettings    JPH_MutableCompoundShapeSettings;
typedef struct JPH_MeshShapeSettings               JPH_MeshShapeSettings;
typedef struct JPH_HeightFieldShapeSettings        JPH_HeightFieldShapeSettings;
typedef struct JPH_DecoratedShapeSettings          JPH_DecoratedShapeSettings;
typedef struct JPH_RotatedTranslatedShapeSettings  JPH_RotatedTranslatedShapeSettings;
typedef struct JPH_ScaledShapeSettings             JPH_ScaledShapeSettings;
typedef struct JPH_OffsetCenterOfMassShapeSettings JPH_OffsetCenterOfMassShapeSettings;
typedef struct JPH_EmptyShapeSettings              JPH_EmptyShapeSettings;

// Shapes

typedef uint32_t JPH_SubShapeID;

typedef struct JPH_Shape                   JPH_Shape;
typedef struct JPH_ConvexShape             JPH_ConvexShape;
typedef struct JPH_SphereShape             JPH_SphereShape;
typedef struct JPH_BoxShape                JPH_BoxShape;
typedef struct JPH_PlaneShape              JPH_PlaneShape;
typedef struct JPH_TriangleShape           JPH_TriangleShape;
typedef struct JPH_CapsuleShape            JPH_CapsuleShape;
typedef struct JPH_TaperedCapsuleShape     JPH_TaperedCapsuleShape;
typedef struct JPH_CylinderShape           JPH_CylinderShape;
typedef struct JPH_TaperedCylinderShape    JPH_TaperedCylinderShape;
typedef struct JPH_ConvexHullShape         JPH_ConvexHullShape;
typedef struct JPH_CompoundShape           JPH_CompoundShape;
typedef struct JPH_StaticCompoundShape     JPH_StaticCompoundShape;
typedef struct JPH_MutableCompoundShape    JPH_MutableCompoundShape;
typedef struct JPH_MeshShape               JPH_MeshShape;
typedef struct JPH_HeightFieldShape        JPH_HeightFieldShape;
typedef struct JPH_DecoratedShape          JPH_DecoratedShape;
typedef struct JPH_RotatedTranslatedShape  JPH_RotatedTranslatedShape;
typedef struct JPH_ScaledShape             JPH_ScaledShape;
typedef struct JPH_OffsetCenterOfMassShape JPH_OffsetCenterOfMassShape;
typedef struct JPH_EmptyShape              JPH_EmptyShape;

typedef struct JPH_PhysicsMaterial JPH_PhysicsMaterial;

// Body

typedef uint32_t JPH_BodyID;

typedef struct JPH_Body JPH_Body;

typedef uint8_t JPH_EBodyType;
enum {
    JPH_EBodyType_RigidBody,
    JPH_EBodyType_SoftBody,
};

typedef struct JPH_BodyManager_BodyStats {
    uint32_t mNumBodies;
    uint32_t mMaxBodies;
    uint32_t mNumBodiesStatic;
    uint32_t mNumBodiesDynamic;
    uint32_t mNumActiveBodiesDynamic;
    uint32_t mNumBodiesKinematic;
    uint32_t mNumActiveBodiesKinematic;
    uint32_t mNumSoftBodies;
    uint32_t mNumActiveSoftBodies;
} JPH_BodyManager_BodyStats;

// Debug renderer

#ifdef JPH_DEBUG_RENDERER

typedef struct JPH_DebugRenderer  JPH_DebugRenderer;
typedef struct JPH_BodyDrawFilter JPH_BodyDrawFilter;

typedef struct JPH_BodyDrawFilter_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    bool (JOLTC_CALL *ShouldDraw)(const void *data, const JPH_Body *body);
} JPH_BodyDrawFilter_Funcs;

JOLTC_API JPH_BodyDrawFilter *JPH_BodyDrawFilter_Create(void *data, JPH_BodyDrawFilter_Funcs funcs, JPH_Allocator allocator);
JOLTC_API void JPH_BodyDrawFilter_Destroy(JPH_BodyDrawFilter *self);

typedef uint32_t JPH_DebugRenderer_ECastShadow;
enum {
    JPH_DebugRenderer_ECastShadow_On,
    JPH_DebugRenderer_ECastShadow_Off,
};

typedef uint32_t JPH_DebugRenderer_EDrawMode;
enum {
    JPH_DebugRenderer_EDrawMode_Solid,
    JPH_DebugRenderer_EDrawMode_Wireframe,
};

typedef uint32_t JPH_DebugRenderer_ECullMode;
enum {
    JPH_DebugRenderer_ECullMode_CullBackFace,
    JPH_DebugRenderer_ECullMode_CullFrontFace,
    JPH_DebugRenderer_ECullMode_Off,
};

typedef uint32_t JPH_ESoftBodyConstraintColor;
enum {
    JPH_ESoftBodyConstraintColor_ConstraintType,
    JPH_ESoftBodyConstraintColor_ConstraintGroup,
    JPH_ESoftBodyConstraintColor_ConstraintOrder,
};

typedef uint32_t JPH_BodyManager_EShapeColor;
enum {
    JPH_BodyManager_EShapeColor_InstanceColor,
    JPH_BodyManager_EShapeColor_ShapeTypeColor,
    JPH_BodyManager_EShapeColor_MotionTypeColor,
    JPH_BodyManager_EShapeColor_SleepColor,
    JPH_BodyManager_EShapeColor_IslandColor,
    JPH_BodyManager_EShapeColor_MaterialColor,
};

typedef struct JPH_BodyManager_DrawSettings {
    bool drawGetSupportFunction;
    bool drawSupportDirection;
    bool drawGetSupportingFace;
    bool drawShape;
    bool drawShapeWireframe;
    JPH_BodyManager_EShapeColor drawShapeColor;
    bool drawBoundingBox;
    bool drawCenterOfMassTransform;
    bool drawWorldTransform;
    bool drawVelocity;
    bool drawMassAndInertia;
    bool drawSleepStats;
    bool drawSoftBodyVertices;
    bool drawSoftBodyVertexVelocities;
    bool drawSoftBodyEdgeConstraints;
    bool drawSoftBodyBendConstraints;
    bool drawSoftBodyVolumeConstraints;
    bool drawSoftBodySkinConstraints;
    bool drawSoftBodyLRAConstraints;
    bool drawSoftBodyRods;
    bool drawSoftBodyRodStates;
    bool drawSoftBodyRodBendTwistConstraints;
    bool drawSoftBodyPredictedBounds;
    JPH_ESoftBodyConstraintColor drawSoftBodyConstraintColor;
} JPH_BodyManager_DrawSettings;

typedef struct JPH_DebugRendererSimple_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    void (JOLTC_CALL *DrawLine)(void *data, JPH_RVec3 from, JPH_RVec3 to, JPH_Color color);
    void (JOLTC_CALL *DrawTriangle)(void *data, JPH_RVec3 v1, JPH_RVec3 v2, JPH_RVec3 v3, JPH_Color color, JPH_DebugRenderer_ECastShadow castShadow);
    void (JOLTC_CALL *DrawText3D)(void *data, JPH_RVec3 position, const char *str, uint64_t strLength, JPH_Color color, float height);
} JPH_DebugRendererSimple_Funcs;

JOLTC_API JPH_DebugRenderer *JPH_DebugRendererSimple_Create(void *data, JPH_DebugRendererSimple_Funcs funcs, JPH_Allocator allocator);
JOLTC_API void JPH_DebugRenderer_Destroy(JPH_DebugRenderer *self);
JOLTC_API void JPH_DebugRenderer_NextFrame(JPH_DebugRenderer *self);
// @Todo: other DebugRenderer functions

#endif

// PhysicsSettings

#define JPH_cDefaultCollisionTolerance 1.0e-4f
#define JPH_cDefaultPenetrationTolerance 1.0e-4f
#define JPH_cDefaultConvexRadius 0.05f
#define JPH_cCapsuleProjectionSlop 0.02f
#define JPH_cDefaultInternalEdgeRemovalVertexToleranceSq 1.0e-8f
#define JPH_cMaxPhysicsJobs 2048
#define JPH_cMaxPhysicsBarriers 8

typedef struct JPH_PhysicsSettings {
    int maxInFlightBodyPairs;
    int stepListenersBatchSize;
    int stepListenerBatchesPerJob;
    float baumgarte;
    float speculativeContactDistance;
    float penetrationSlop;
    float linearCastThreshold;
    float linearCastMaxPenetration;
    float manifoldTolerance;
    float maxPenetrationDistance;
    float bodyPairCacheMaxDeltaPositionSq;
    float bodyPairCacheCosMaxDeltaRotationDiv2;
    float contactNormalCosMaxDeltaRotation;
    float contactPointPreserveLambdaMaxDistSq;
    float internalEdgeRemovalVertexToleranceSq;
    uint32_t numVelocitySteps;
    uint32_t numPositionSteps;
    float minVelocityForRestitution;
    float timeBeforeSleep;
    float pointVelocitySleepThreshold;
    bool deterministicSimulation;
    bool constraintWarmStart;
    bool useBodyPairContactCache;
    bool useManifoldReduction;
    bool useLargeIslandSplitter;
    bool allowSleeping;
    bool checkActiveEdges;
} JPH_PhysicsSettings;

// Layer and filter interfaces

typedef struct JPH_BroadPhaseLayerInterface_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    uint32_t (JOLTC_CALL *GetNumBroadPhaseLayers)(const void *data);
    JPH_BroadPhaseLayer (JOLTC_CALL *GetBroadPhaseLayer)(const void *data, JPH_ObjectLayer layer);

#if defined(JPH_EXTERNAL_PROFILE) || defined(JPH_PROFILE_ENABLED)
    const char *(JOLTC_CALL *GetBroadPhaseLayerName)(const void *data, JPH_BroadPhaseLayer layer);
#endif
} JPH_BroadPhaseLayerInterface_Funcs;

JOLTC_API JPH_BroadPhaseLayerInterface *JPH_BroadPhaseLayerInterface_Create(void *data, JPH_BroadPhaseLayerInterface_Funcs funcs, JPH_Allocator allocator);
JOLTC_API void JPH_BroadPhaseLayerInterface_Destroy(JPH_BroadPhaseLayerInterface *self);

typedef struct JPH_ObjectVsBroadPhaseLayerFilter_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    bool (JOLTC_CALL *ShouldCollide)(const void *data, JPH_ObjectLayer layer1, JPH_BroadPhaseLayer layer2);
} JPH_ObjectVsBroadPhaseLayerFilter_Funcs;

JOLTC_API JPH_ObjectVsBroadPhaseLayerFilter *JPH_ObjectVsBroadPhaseLayerFilter_Create(void *data, JPH_ObjectVsBroadPhaseLayerFilter_Funcs funcs, JPH_Allocator allocator);
JOLTC_API void JPH_ObjectVsBroadPhaseLayerFilter_Destroy(JPH_ObjectVsBroadPhaseLayerFilter *self);

typedef struct JPH_ObjectLayerPairFilter_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    bool (JOLTC_CALL *ShouldCollide)(const void *data, JPH_ObjectLayer layer1, JPH_ObjectLayer layer2);
} JPH_ObjectLayerPairFilter_Funcs;

JOLTC_API JPH_ObjectLayerPairFilter *JPH_ObjectLayerPairFilter_Create(void *data, JPH_ObjectLayerPairFilter_Funcs funcs, JPH_Allocator allocator);
JOLTC_API void JPH_ObjectLayerPairFilter_Destroy(JPH_ObjectLayerPairFilter *self);

typedef struct JPH_BroadPhaseLayerFilter_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    bool (JOLTC_CALL *ShouldCollide)(const void *data, JPH_BroadPhaseLayer layer);
} JPH_BroadPhaseLayerFilter_Funcs;

JOLTC_API JPH_BroadPhaseLayerFilter *JPH_BroadPhaseLayerFilter_Create(void *data, JPH_BroadPhaseLayerFilter_Funcs funcs, JPH_Allocator allocator);
JOLTC_API void JPH_BroadPhaseLayerFilter_Destroy(JPH_BroadPhaseLayerFilter *self);

typedef struct JPH_ObjectLayerFilter_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    bool (JOLTC_CALL *ShouldCollide)(const void *data, JPH_ObjectLayer layer);
} JPH_ObjectLayerFilter_Funcs;

JOLTC_API JPH_ObjectLayerFilter *JPH_ObjectLayerFilter_Create(void *data, JPH_ObjectLayerFilter_Funcs funcs, JPH_Allocator allocator);
JOLTC_API void JPH_ObjectLayerFilter_Destroy(JPH_ObjectLayerFilter *self);

// Default filters

typedef struct JPH_DefaultBroadPhaseLayerFilter {
    const JPH_ObjectVsBroadPhaseLayerFilter *objectVsBroadPhaseLayerFilter;
    JPH_ObjectLayer layer;
} JPH_DefaultBroadPhaseLayerFilter;

JOLTC_API bool JPH_DefaultBroadPhaseLayerFilter_ShouldCollide(const void *data, JPH_BroadPhaseLayer layer);
JOLTC_API const JPH_BroadPhaseLayerFilter *JPH_JPH_DefaultBroadPhaseLayerFilter_CreateFilter(JPH_DefaultBroadPhaseLayerFilter *filter, JPH_Allocator allocator);

typedef struct JPH_DefaultObjectLayerFilter {
    const JPH_ObjectLayerPairFilter *objectLayerPairFilter;
    JPH_ObjectLayer layer;
} JPH_DefaultObjectLayerFilter;

JOLTC_API bool JPH_DefaultObjectLayerFilter_ShouldCollide(const void *data, JPH_ObjectLayer layer);
JOLTC_API const JPH_ObjectLayerFilter *JPH_DefaultObjectLayerFilter_CreateFilter(JPH_DefaultObjectLayerFilter *filter, JPH_Allocator allocator);

// PhysicsSystem

typedef struct JPH_PhysicsSystemSettings {
    uint32_t maxBodies;
    uint32_t numBodyMutexes;
    uint32_t maxBodyPairs;
    uint32_t maxContactConstraints;
    const JPH_BroadPhaseLayerInterface *broadPhaseLayerInterface;
    const JPH_ObjectVsBroadPhaseLayerFilter *objectVsBroadPhaseLayerFilter;
    const JPH_ObjectLayerPairFilter *objectLayerPairFilter;
} JPH_PhysicsSystemSettings;

typedef uint32_t JPH_EPhysicsUpdateError;
enum {
    JPH_EPhysicsUpdateError_None = 0,
    JPH_EPhysicsUpdateError_ManifoldCacheFull = 1 << 0,
    JPH_EPhysicsUpdateError_BodyPairCacheFull = 1 << 1,
    JPH_EPhysicsUpdateError_ContactConstraintsFull = 1 << 2,
};

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
JOLTC_API JPH_DefaultBroadPhaseLayerFilter JPH_PhysicsSystem_GetDefaultBroadPhaseLayerFilter(const JPH_PhysicsSystem *system, JPH_ObjectLayer layer, JPH_Allocator allocator);
JOLTC_API JPH_DefaultObjectLayerFilter JPH_PhysicsSystem_GetDefaultLayerFilter(const JPH_PhysicsSystem *system, JPH_ObjectLayer layer, JPH_Allocator allocator);

JOLTC_API void JPH_PhysicsSystem_OptimizeBroadPhase(JPH_PhysicsSystem *system);
JOLTC_API JPH_EPhysicsUpdateError JPH_PhysicsSystem_Update(JPH_PhysicsSystem *system, float deltaTime, int collisionSteps, JPH_TempAllocator *tempAllocator, JPH_JobSystem *jobSystem);

#ifdef JPH_DEBUG_RENDERER

JOLTC_API void JPH_PhysicsSystem_DrawBodies(JPH_PhysicsSystem *system, const JPH_BodyManager_DrawSettings *settings, JPH_DebugRenderer *renderer, const JPH_BodyDrawFilter *bodyFilter);
JOLTC_API void JPH_PhysicsSystem_DrawConstraints(JPH_PhysicsSystem *system, JPH_DebugRenderer *renderer);
JOLTC_API void JPH_PhysicsSystem_DrawConstraintLimits(JPH_PhysicsSystem *system, JPH_DebugRenderer *renderer);
JOLTC_API void JPH_PhysicsSystem_DrawConstraintReferenceFrame(JPH_PhysicsSystem *system, JPH_DebugRenderer *renderer);

#endif

// Shape settings

// @Todo: add aliases for inherited methods

JOLTC_API void JPH_ShapeSettings_Destroy(JPH_ShapeSettings *settings);
JOLTC_API JPH_Shape *JPH_ShapeSettings_CreateShape(JPH_ShapeSettings *settings);
JOLTC_API void JPH_ShapeSettings_ClearCachedResult(JPH_ShapeSettings *settings);
JOLTC_API void JPH_ShapeSettings_SetUserData(JPH_ShapeSettings *settings, uint64_t userData);
JOLTC_API uint64_t JPH_ShapeSettings_GetUserData(const JPH_ShapeSettings *settings);

JOLTC_API JPH_EmptyShapeSettings *JPH_EmptyShapeSettings_Create();
JOLTC_API void JPH_EmptyShapeSettings_Destroy(JPH_EmptyShapeSettings *settings);
JOLTC_API JPH_EmptyShape *JPH_EmptyShapeSettings_CreateShape(JPH_EmptyShapeSettings *settings);
JOLTC_API void JPH_EmptyShapeSettings_SetCenterOfMass(JPH_EmptyShapeSettings *settings, JPH_Vec3 centerOfMass);
JOLTC_API JPH_Vec3 JPH_EmptyShapeSettings_GetCenterOfMass(const JPH_EmptyShapeSettings *settings);

JOLTC_API JPH_HeightFieldShapeSettings *JPH_HeightFieldShapeSettings_Create(const float *samples, JPH_Vec3 offset, JPH_Vec3 scale, uint32_t sampleCount, const uint8_t *materialIndices, const JPH_PhysicsMaterial *materials, uint32_t materialCount);
JOLTC_API void JPH_HeightFieldShapeSettings_Destroy(JPH_HeightFieldShapeSettings *settings);
JOLTC_API JPH_HeightFieldShape *JPH_HeightFieldShapeSettings_CreateShape(JPH_HeightFieldShapeSettings *settings);
JOLTC_API void JPH_HeightFieldShapeSettings_DetermineMinAndMaxSample(const JPH_HeightFieldShapeSettings *settings, float *outMinValue, float *outMaxValue, float *outQuantizationScale);
JOLTC_API uint32_t JPH_HeightFieldShapeSettings_CalculateBitsPerSampleForError(const JPH_HeightFieldShapeSettings *settings, float maxError);

JOLTC_API JPH_PlaneShapeSettings *JPH_PlaneShapeSettings_Create(JPH_Plane plane, const JPH_PhysicsMaterial *material, float halfExtent);
JOLTC_API void JPH_PlaneShapeSettings_Destroy(JPH_PlaneShapeSettings *settings);
JOLTC_API JPH_PlaneShape *JPH_PlaneShapeSettings_CreateShape(JPH_PlaneShapeSettings *settings);
JOLTC_API void JPH_PlaneShapeSettings_SetPlane(JPH_PlaneShapeSettings *settings, JPH_Plane plane);
JOLTC_API JPH_Plane JPH_PlaneShapeSettings_GetPlane(const JPH_PlaneShapeSettings *settings);
JOLTC_API void JPH_PlaneShapeSettings_SetPhysicsMaterial(JPH_PlaneShapeSettings *settings, const JPH_PhysicsMaterial *material);
JOLTC_API const JPH_PhysicsMaterial *JPH_PlaneShapeSettings_GetPhysicsMaterial(const JPH_PlaneShapeSettings *settings);
JOLTC_API void JPH_PlaneShapeSettings_SetHalfExtent(JPH_PlaneShapeSettings *settings, float halfExtent);
JOLTC_API float JPH_PlaneShapeSettings_GetHalfExtent(const JPH_PlaneShapeSettings *settings);

JOLTC_API JPH_OffsetCenterOfMassShapeSettings *JPH_OffsetCenterOfMassShapeSettings_Create();
JOLTC_API void JPH_OffsetCenterOfMassShapeSettings_Destroy(JPH_OffsetCenterOfMassShapeSettings *settings);
JOLTC_API JPH_OffsetCenterOfMassShape *JPH_OffsetCenterOfMassShapeSettings_CreateShape(JPH_OffsetCenterOfMassShapeSettings *settings);
JOLTC_API void JPH_OffsetCenterOfMassShapeSettings_SetInnerShape(JPH_OffsetCenterOfMassShapeSettings *settings, const JPH_Shape *innerShape);
JOLTC_API const JPH_Shape *JPH_OffsetCenterOfMassShapeSettings_GetInnerShape(const JPH_OffsetCenterOfMassShapeSettings *settings);
JOLTC_API void JPH_OffsetCenterOfMassShapeSettings_SetInnerShapeSettings(JPH_OffsetCenterOfMassShapeSettings *settings, const JPH_ShapeSettings *innerShapeSettings);
JOLTC_API const JPH_ShapeSettings *JPH_OffsetCenterOfMassShapeSettings_GetInnerShapeSettings(const JPH_OffsetCenterOfMassShapeSettings *settings);
JOLTC_API void JPH_OffsetCenterOfMassShapeSettings_SetOffset(JPH_OffsetCenterOfMassShapeSettings *settings, JPH_Vec3 offset);
JOLTC_API JPH_Vec3 JPH_OffsetCenterOfMassShapeSettings_GetOffset(const JPH_OffsetCenterOfMassShapeSettings *settings);

JOLTC_API JPH_RotatedTranslatedShapeSettings *JPH_RotatedTranslatedShapeSettings_Create();
JOLTC_API void JPH_RotatedTranslatedShapeSettings_Destroy(JPH_RotatedTranslatedShapeSettings *settings);
JOLTC_API JPH_RotatedTranslatedShape *JPH_RotatedTranslatedShapeSettings_CreateShape(JPH_RotatedTranslatedShapeSettings *settings);
JOLTC_API void JPH_RotatedTranslatedShapeSettings_SetInnerShape(JPH_RotatedTranslatedShapeSettings *settings, const JPH_Shape *innerShape);
JOLTC_API const JPH_Shape *JPH_RotatedTranslatedShapeSettings_GetInnerShape(const JPH_RotatedTranslatedShapeSettings *settings);
JOLTC_API void JPH_RotatedTranslatedShapeSettings_SetInnerShapeSettings(JPH_RotatedTranslatedShapeSettings *settings, const JPH_ShapeSettings *innerShapeSettings);
JOLTC_API const JPH_ShapeSettings *JPH_RotatedTranslatedShapeSettings_GetInnerShapeSettings(const JPH_RotatedTranslatedShapeSettings *settings);
JOLTC_API void JPH_RotatedTranslatedShapeSettings_SetPosition(JPH_RotatedTranslatedShapeSettings *settings, JPH_Vec3 position);
JOLTC_API JPH_Vec3 JPH_RotatedTranslatedShapeSettings_GetPosition(const JPH_RotatedTranslatedShapeSettings *settings);
JOLTC_API void JPH_RotatedTranslatedShapeSettings_SetRotation(JPH_RotatedTranslatedShapeSettings *settings, JPH_Quat rotation);
JOLTC_API JPH_Quat JPH_RotatedTranslatedShapeSettings_GetRotation(const JPH_RotatedTranslatedShapeSettings *settings);

JOLTC_API JPH_ScaledShapeSettings *JPH_ScaledShapeSettings_Create();
JOLTC_API void JPH_ScaledShapeSettings_Destroy(JPH_ScaledShapeSettings *settings);
JOLTC_API JPH_ScaledShape *JPH_ScaledShapeSettings_CreateShape(JPH_ScaledShapeSettings *settings);
JOLTC_API void JPH_ScaledShapeSettings_SetInnerShape(JPH_ScaledShapeSettings *settings, const JPH_Shape *innerShape);
JOLTC_API const JPH_Shape *JPH_ScaledShapeSettings_GetInnerShape(const JPH_ScaledShapeSettings *settings);
JOLTC_API void JPH_ScaledShapeSettings_SetInnerShapeSettings(JPH_ScaledShapeSettings *settings, const JPH_ShapeSettings *innerShapeSettings);
JOLTC_API const JPH_ShapeSettings *JPH_ScaledShapeSettings_GetInnerShapeSettings(const JPH_ScaledShapeSettings *settings);
JOLTC_API void JPH_ScaledShapeSettings_SetScale(JPH_ScaledShapeSettings *settings, JPH_Vec3 scale);
JOLTC_API JPH_Vec3 JPH_ScaledShapeSettings_GetScale(const JPH_ScaledShapeSettings *settings);

JOLTC_API void JPH_CompoundShapeSettings_Destroy(JPH_CompoundShapeSettings *settings);
JOLTC_API JPH_CompoundShape *JPH_CompoundShapeSettings_CreateShape(JPH_CompoundShapeSettings *settings);
JOLTC_API void JPH_CompoundShapeSettings_AddShape(JPH_CompoundShapeSettings *settings, JPH_Vec3 position, JPH_Quat rotation, const JPH_Shape *subShape, uint32_t userData);
JOLTC_API void JPH_CompoundShapeSettings_AddShapeSettings(JPH_CompoundShapeSettings *settings, JPH_Vec3 position, JPH_Quat rotation, const JPH_ShapeSettings *subShapeSettings, uint32_t userData);

JOLTC_API JPH_StaticCompoundShapeSettings *JPH_StaticCompoundShapeSettings_Create();
JOLTC_API void JPH_StaticCompoundShapeSettings_Destroy(JPH_StaticCompoundShapeSettings *settings);
JOLTC_API JPH_StaticCompoundShape *JPH_StaticCompoundShapeSettings_CreateShape(JPH_StaticCompoundShapeSettings *settings);

JOLTC_API JPH_MutableCompoundShapeSettings *JPH_MutableCompoundShapeSettings_Create();
JOLTC_API void JPH_MutableCompoundShapeSettings_Destroy(JPH_MutableCompoundShapeSettings *settings);
JOLTC_API JPH_MutableCompoundShape *JPH_MutableCompoundShapeSettings_CreateShape(JPH_MutableCompoundShapeSettings *settings);

JOLTC_API void JPH_ConvexShapeSettings_Destroy(JPH_ConvexShapeSettings *settings);
JOLTC_API JPH_ConvexShape *JPH_ConvexShapeSettings_CreateShape(JPH_ConvexShapeSettings *settings);
JOLTC_API void JPH_ConvexShapeSettings_SetPhysicsMaterial(JPH_ConvexShapeSettings *settings, const JPH_PhysicsMaterial *material);
JOLTC_API const JPH_PhysicsMaterial *JPH_ConvexShapeSettings_GetPhysicsMaterial(const JPH_ConvexShapeSettings *settings);
JOLTC_API void JPH_ConvexShapeSettings_SetDensity(JPH_ConvexShapeSettings *settings, float density);
JOLTC_API float JPH_ConvexShapeSettings_GetDensity(const JPH_ConvexShapeSettings *settings);

JOLTC_API JPH_BoxShapeSettings *JPH_BoxShapeSettings_Create();
JOLTC_API void JPH_BoxShapeSettings_Destroy(JPH_BoxShapeSettings *settings);
JOLTC_API JPH_BoxShape *JPH_BoxShapeSettings_CreateShape(JPH_BoxShapeSettings *settings);
JOLTC_API void JPH_BoxShapeSettings_SetHalfExtent(JPH_BoxShapeSettings *settings, JPH_Vec3 halfExtent);
JOLTC_API JPH_Vec3 JPH_BoxShapeSettings_GetHalfExtent(const JPH_BoxShapeSettings *settings);
JOLTC_API void JPH_BoxShapeSettings_SetConvexRadius(JPH_BoxShapeSettings *settings, float convexRadius);
JOLTC_API float JPH_BoxShapeSettings_GetConvexRadius(const JPH_BoxShapeSettings *settings);

#endif
