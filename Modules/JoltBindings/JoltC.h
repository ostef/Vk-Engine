// @Todo: find a way to bring in comments from the original header files
// Jolt v.5.6.0 C wrapper

#ifndef JOLTC_H
#define JOLTC_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#if !defined(JOLTC_EXPORT)
#define JOLTC_EXPORT
#endif

#if defined(__cplusplus)
#define JOLTC_EXTERN extern "C"
#else
#define JOLTC_EXTERN extern
#endif

#if defined(__cplusplus)
#define JOLTC_ALIGNAS(N) alignas(N)
#else
#define JOLTC_ALIGNAS(N) _Alignas(N)
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

typedef union JPH_Float3 {
    struct {
        float x, y, z;
    };
    float values[3];
} JPH_Float3;

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

typedef uint8_t JPH_Shape_EShapeType;
enum {
    JPH_Shape_EShapeType_Convex,
    JPH_Shape_EShapeType_Compound,
    JPH_Shape_EShapeType_Decorated,
    JPH_Shape_EShapeType_Mesh,
    JPH_Shape_EShapeType_HeightField,
    JPH_Shape_EShapeType_SoftBody,
    JPH_Shape_EShapeType_User1,
    JPH_Shape_EShapeType_User2,
    JPH_Shape_EShapeType_User3,
    JPH_Shape_EShapeType_User4,
    JPH_Shape_EShapeType_Plane,
    JPH_Shape_EShapeType_Empty,
};

typedef uint8_t JPH_Shape_EShapeSubType;
enum {
    JPH_Shape_EShapeSubType_Sphere,
    JPH_Shape_EShapeSubType_Box,
    JPH_Shape_EShapeSubType_Triangle,
    JPH_Shape_EShapeSubType_Capsule,
    JPH_Shape_EShapeSubType_TaperedCapsule,
    JPH_Shape_EShapeSubType_Cylinder,
    JPH_Shape_EShapeSubType_ConvexHull,
    JPH_Shape_EShapeSubType_StaticCompound,
    JPH_Shape_EShapeSubType_MutableCompound,
    JPH_Shape_EShapeSubType_RotatedTranslated,
    JPH_Shape_EShapeSubType_Scaled,
    JPH_Shape_EShapeSubType_OffsetCenterOfMass,
    JPH_Shape_EShapeSubType_Mesh,
    JPH_Shape_EShapeSubType_HeightField,
    JPH_Shape_EShapeSubType_SoftBody,
    JPH_Shape_EShapeSubType_User1,
    JPH_Shape_EShapeSubType_User2,
    JPH_Shape_EShapeSubType_User3,
    JPH_Shape_EShapeSubType_User4,
    JPH_Shape_EShapeSubType_User5,
    JPH_Shape_EShapeSubType_User6,
    JPH_Shape_EShapeSubType_User7,
    JPH_Shape_EShapeSubType_User8,
    JPH_Shape_EShapeSubType_UserConvex1,
    JPH_Shape_EShapeSubType_UserConvex2,
    JPH_Shape_EShapeSubType_UserConvex3,
    JPH_Shape_EShapeSubType_UserConvex4,
    JPH_Shape_EShapeSubType_UserConvex5,
    JPH_Shape_EShapeSubType_UserConvex6,
    JPH_Shape_EShapeSubType_UserConvex7,
    JPH_Shape_EShapeSubType_UserConvex8,
    JPH_Shape_EShapeSubType_Plane,
    JPH_Shape_EShapeSubType_TaperedCylinder,
    JPH_Shape_EShapeSubType_Empty,
};

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

typedef struct JPH_IndexedTriangle {
    uint32_t idx[3];
    uint32_t materialIndex;
    uint32_t userData;
} JPH_IndexedTriangle;

typedef uint32_t JPH_MeshShapeSettings_EBuildQuality;
enum {
    JPH_MeshShapeSettings_EBuildQuality_FavorRuntimePerformance,
    JPH_MeshShapeSettings_EBuildQuality_FavorBuildSpeed,
};

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

JOLTC_API JPH_SphereShapeSettings *JPH_SphereShapeSettings_Create();
JOLTC_API void JPH_SphereShapeSettings_Destroy(JPH_SphereShapeSettings *settings);
JOLTC_API JPH_SphereShape *JPH_SphereShapeSettings_CreateShape(JPH_SphereShapeSettings *settings);
JOLTC_API void JPH_SphereShapeSettings_SetRadius(JPH_SphereShapeSettings *settings, float radius);
JOLTC_API float JPH_SphereShapeSettings_GetRadius(const JPH_SphereShapeSettings *settings);

JOLTC_API JPH_CapsuleShapeSettings *JPH_CapsuleShapeSettings_Create();
JOLTC_API void JPH_CapsuleShapeSettings_Destroy(JPH_CapsuleShapeSettings *settings);
JOLTC_API JPH_CapsuleShape *JPH_CapsuleShapeSettings_CreateShape(JPH_CapsuleShapeSettings *settings);
JOLTC_API void JPH_CapsuleShapeSettings_SetRadius(JPH_CapsuleShapeSettings *settings, float radius);
JOLTC_API float JPH_CapsuleShapeSettings_GetRadius(const JPH_CapsuleShapeSettings *settings);
JOLTC_API void JPH_CapsuleShapeSettings_SetHalfHeightOfCylinder(JPH_CapsuleShapeSettings *settings, float halfHeightOfCylinder);
JOLTC_API float JPH_CapsuleShapeSettings_GetHalfHeightOfCylinder(const JPH_CapsuleShapeSettings *settings);
JOLTC_API bool JPH_CapsuleShapeSettings_IsValid(const JPH_CapsuleShapeSettings *settings);
JOLTC_API bool JPH_CapsuleShapeSettings_IsSphere(const JPH_CapsuleShapeSettings *settings);

JOLTC_API JPH_TaperedCapsuleShapeSettings *JPH_TaperedCapsuleShapeSettings_Create();
JOLTC_API void JPH_TaperedCapsuleShapeSettings_Destroy(JPH_TaperedCapsuleShapeSettings *settings);
JOLTC_API JPH_TaperedCapsuleShape *JPH_TaperedCapsuleShapeSettings_CreateShape(JPH_TaperedCapsuleShapeSettings *settings);
JOLTC_API void JPH_TaperedCapsuleShapeSettings_SetHalfHeightOfTaperedCylinder(JPH_TaperedCapsuleShapeSettings *settings, float halfHeightOfTaperedCylinder);
JOLTC_API float JPH_TaperedCapsuleShapeSettings_GetHalfHeightOfTaperedCylinder(const JPH_TaperedCapsuleShapeSettings *settings);
JOLTC_API void JPH_TaperedCapsuleShapeSettings_SetTopRadius(JPH_TaperedCapsuleShapeSettings *settings, float topRadius);
JOLTC_API float JPH_TaperedCapsuleShapeSettings_GetTopRadius(const JPH_TaperedCapsuleShapeSettings *settings);
JOLTC_API void JPH_TaperedCapsuleShapeSettings_SetBottomRadius(JPH_TaperedCapsuleShapeSettings *settings, float bottomRadius);
JOLTC_API float JPH_TaperedCapsuleShapeSettings_GetBottomRadius(const JPH_TaperedCapsuleShapeSettings *settings);
JOLTC_API bool JPH_TaperedCapsuleShapeSettings_IsValid(const JPH_TaperedCapsuleShapeSettings *settings);
JOLTC_API bool JPH_TaperedCapsuleShapeSettings_IsSphere(const JPH_TaperedCapsuleShapeSettings *settings);

JOLTC_API JPH_CylinderShapeSettings *JPH_CylinderShapeSettings_Create();
JOLTC_API void JPH_CylinderShapeSettings_Destroy(JPH_CylinderShapeSettings *settings);
JOLTC_API JPH_CylinderShape *JPH_CylinderShapeSettings_CreateShape(JPH_CylinderShapeSettings *settings);
JOLTC_API void JPH_CylinderShapeSettings_SetHalfHeight(JPH_CylinderShapeSettings *settings, float halfHeight);
JOLTC_API float JPH_CylinderShapeSettings_GetHalfHeight(const JPH_CylinderShapeSettings *settings);
JOLTC_API void JPH_CylinderShapeSettings_SetRadius(JPH_CylinderShapeSettings *settings, float radius);
JOLTC_API float JPH_CylinderShapeSettings_GetRadius(const JPH_CylinderShapeSettings *settings);
JOLTC_API void JPH_CylinderShapeSettings_SetConvexRadius(JPH_CylinderShapeSettings *settings, float convexRadius);
JOLTC_API float JPH_CylinderShapeSettings_GetConvexRadius(const JPH_CylinderShapeSettings *settings);

JOLTC_API JPH_TaperedCylinderShapeSettings *JPH_TaperedCylinderShapeSettings_Create();
JOLTC_API void JPH_TaperedCylinderShapeSettings_Destroy(JPH_TaperedCylinderShapeSettings *settings);
JOLTC_API JPH_TaperedCylinderShape *JPH_TaperedCylinderShapeSettings_CreateShape(JPH_TaperedCylinderShapeSettings *settings);
JOLTC_API void JPH_TaperedCylinderShapeSettings_SetHalfHeight(JPH_TaperedCylinderShapeSettings *settings, float halfHeight);
JOLTC_API float JPH_TaperedCylinderShapeSettings_GetHalfHeight(const JPH_TaperedCylinderShapeSettings *settings);
JOLTC_API void JPH_TaperedCylinderShapeSettings_SetTopRadius(JPH_TaperedCylinderShapeSettings *settings, float topRadius);
JOLTC_API float JPH_TaperedCylinderShapeSettings_GetTopRadius(const JPH_TaperedCylinderShapeSettings *settings);
JOLTC_API void JPH_TaperedCylinderShapeSettings_SetBottomRadius(JPH_TaperedCylinderShapeSettings *settings, float bottomRadius);
JOLTC_API float JPH_TaperedCylinderShapeSettings_GetBottomRadius(const JPH_TaperedCylinderShapeSettings *settings);
JOLTC_API void JPH_TaperedCylinderShapeSettings_SetConvexRadius(JPH_TaperedCylinderShapeSettings *settings, float convexRadius);
JOLTC_API float JPH_TaperedCylinderShapeSettings_GetConvexRadius(const JPH_TaperedCylinderShapeSettings *settings);

JOLTC_API JPH_TriangleShapeSettings *JPH_TriangleShapeSettings_Create();
JOLTC_API void JPH_TriangleShapeSettings_Destroy(JPH_TriangleShapeSettings *settings);
JOLTC_API JPH_TriangleShape *JPH_TriangleShapeSettings_CreateShape(JPH_TriangleShapeSettings *settings);
JOLTC_API void JPH_TriangleShapeSettings_SetV1(JPH_TriangleShapeSettings *settings, JPH_Vec3 v1);
JOLTC_API JPH_Vec3 JPH_TriangleShapeSettings_GetV1(const JPH_TriangleShapeSettings *settings);
JOLTC_API void JPH_TriangleShapeSettings_SetV2(JPH_TriangleShapeSettings *settings, JPH_Vec3 v2);
JOLTC_API JPH_Vec3 JPH_TriangleShapeSettings_GetV2(const JPH_TriangleShapeSettings *settings);
JOLTC_API void JPH_TriangleShapeSettings_SetV3(JPH_TriangleShapeSettings *settings, JPH_Vec3 v3);
JOLTC_API JPH_Vec3 JPH_TriangleShapeSettings_GetV3(const JPH_TriangleShapeSettings *settings);
JOLTC_API void JPH_TriangleShapeSettings_SetPoints(JPH_TriangleShapeSettings *settings, JPH_Vec3 v1, JPH_Vec3 v2, JPH_Vec3 v3);
JOLTC_API void JPH_TriangleShapeSettings_GetPoints(const JPH_TriangleShapeSettings *settings, JPH_Vec3 *outV1, JPH_Vec3 *outV2, JPH_Vec3 *outV3);
JOLTC_API void JPH_TriangleShapeSettings_SetConvexRadius(JPH_TriangleShapeSettings *settings, float convexRadius);
JOLTC_API float JPH_TriangleShapeSettings_GetConvexRadius(const JPH_TriangleShapeSettings *settings);

JOLTC_API JPH_ConvexHullShapeSettings *JPH_ConvexHullShapeSettings_Create();
JOLTC_API void JPH_ConvexHullShapeSettings_Destroy(JPH_ConvexHullShapeSettings *settings);
JOLTC_API JPH_ConvexHullShape *JPH_ConvexHullShapeSettings_CreateShape(JPH_ConvexHullShapeSettings *settings);
JOLTC_API void JPH_ConvexHullShapeSettings_AddPoints(JPH_ConvexHullShapeSettings *settings, const JPH_Vec3 *points, uint32_t count);
JOLTC_API uint32_t JPH_ConvexHullShapeSettings_GetNumPoints(const JPH_ConvexHullShapeSettings *settings);
JOLTC_API const JPH_Vec3 *JPH_ConvexHullShapeSettings_GetPoints(const JPH_ConvexHullShapeSettings *settings);
JOLTC_API void JPH_ConvexHullShapeSettings_SetMaxConvexRadius(JPH_ConvexHullShapeSettings *settings, float maxConvexRadius);
JOLTC_API float JPH_ConvexHullShapeSettings_GetMaxConvexRadius(const JPH_ConvexHullShapeSettings *settings);
JOLTC_API void JPH_ConvexHullShapeSettings_SetMaxErrorConvexRadius(JPH_ConvexHullShapeSettings *settings, float maxErrorConvexRadius);
JOLTC_API float JPH_ConvexHullShapeSettings_GetMaxErrorConvexRadius(const JPH_ConvexHullShapeSettings *settings);
JOLTC_API void JPH_ConvexHullShapeSettings_SetHullTolerance(JPH_ConvexHullShapeSettings *settings, float hullTolerance);
JOLTC_API float JPH_ConvexHullShapeSettings_GetHullTolerance(const JPH_ConvexHullShapeSettings *settings);

JOLTC_API JPH_MeshShapeSettings *JPH_MeshShapeSettings_Create();
JOLTC_API void JPH_MeshShapeSettings_Destroy(JPH_MeshShapeSettings *settings);
JOLTC_API JPH_MeshShape *JPH_MeshShapeSettings_CreateShape(JPH_MeshShapeSettings *settings);
JOLTC_API void JPH_MeshShapeSettings_Sanitize(JPH_MeshShapeSettings *settings);
JOLTC_API void JPH_MeshShapeSettings_AddVertex(JPH_MeshShapeSettings *settings, JPH_Float3 vertex);
JOLTC_API void JPH_MeshShapeSettings_AddVertices(JPH_MeshShapeSettings *settings, const JPH_Float3 *vertices, uint32_t count);
JOLTC_API uint32_t JPH_MeshShapeSettings_GetNumVertices(const JPH_MeshShapeSettings *settings);
JOLTC_API const JPH_Float3 *JPH_MeshShapeSettings_GetVertices(const JPH_MeshShapeSettings *settings);
JOLTC_API void JPH_MeshShapeSettings_AddIndexedTriangle(JPH_MeshShapeSettings *settings, JPH_IndexedTriangle triangle);
JOLTC_API void JPH_MeshShapeSettings_AddIndexedTriangles(JPH_MeshShapeSettings *settings, const JPH_IndexedTriangle *triangles, uint32_t count);
JOLTC_API uint32_t JPH_MeshShapeSettings_GetNumIndexedTriangles(const JPH_MeshShapeSettings *settings);
JOLTC_API const JPH_IndexedTriangle *JPH_MeshShapeSettings_GetIndexedTriangles(const JPH_MeshShapeSettings *settings);
JOLTC_API void JPH_MeshShapeSettings_AddMaterial(JPH_MeshShapeSettings *settings, const JPH_PhysicsMaterial *material);
JOLTC_API void JPH_MeshShapeSettings_AddMaterials(JPH_MeshShapeSettings *settings, const JPH_PhysicsMaterial **materials, uint32_t count);
JOLTC_API uint32_t JPH_MeshShapeSettings_GetNumMaterials(const JPH_MeshShapeSettings *settings);
JOLTC_API const JPH_PhysicsMaterial *JPH_MeshShapeSettings_GetMaterial(const JPH_MeshShapeSettings *settings, uint32_t index);
JOLTC_API void JPH_MeshShapeSettings_SetMaxTrianglesPerLeaf(JPH_MeshShapeSettings *settings, uint32_t maxTrianglesPerLeaf);
JOLTC_API uint32_t JPH_MeshShapeSettings_GetMaxTrianglesPerLeaf(const JPH_MeshShapeSettings *settings);
JOLTC_API void JPH_MeshShapeSettings_SetActiveEdgeCosThresholdAngle(JPH_MeshShapeSettings *settings, float activeEdgeCosThresholdAngle);
JOLTC_API float JPH_MeshShapeSettings_GetActiveEdgeCosThresholdAngle(const JPH_MeshShapeSettings *settings);
JOLTC_API void JPH_MeshShapeSettings_SetPerTriangleUserData(JPH_MeshShapeSettings *settings, bool perTriangleUserData);
JOLTC_API bool JPH_MeshShapeSettings_GetPerTriangleUserData(const JPH_MeshShapeSettings *settings);
JOLTC_API void JPH_MeshShapeSettings_SetBuildQuality(JPH_MeshShapeSettings *settings, JPH_MeshShapeSettings_EBuildQuality buildQuality);
JOLTC_API JPH_MeshShapeSettings_EBuildQuality JPH_MeshShapeSettings_GetBuildQuality(const JPH_MeshShapeSettings *settings);

JOLTC_API JPH_HeightFieldShapeSettings *JPH_HeightFieldShapeSettings_Create();
JOLTC_API void JPH_HeightFieldShapeSettings_Destroy(JPH_HeightFieldShapeSettings *settings);
JOLTC_API JPH_HeightFieldShape *JPH_HeightFieldShapeSettings_CreateShape(JPH_HeightFieldShapeSettings *settings);
JOLTC_API void JPH_HeightFieldShapeSettings_DetermineMinAndMaxSample(const JPH_HeightFieldShapeSettings *settings, float *outMinValue, float *outMaxValue, float *outQuantizationScale);
JOLTC_API uint32_t JPH_HeightFieldShapeSettings_CalculateBitsPerSampleForError(const JPH_HeightFieldShapeSettings *settings, float maxError);
JOLTC_API void JPH_HeightFieldShapeSettings_AddHeightSample(JPH_HeightFieldShapeSettings *settings, float sample);
JOLTC_API void JPH_HeightFieldShapeSettings_AddHeightSamples(JPH_HeightFieldShapeSettings *settings, const float *samples, uint32_t count);
JOLTC_API uint32_t JPH_HeightFieldShapeSettings_GetNumHeightSamples(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API const float *JPH_HeightFieldShapeSettings_GetHeightSamples(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API void JPH_HeightFieldShapeSettings_AddMaterialIndex(JPH_HeightFieldShapeSettings *settings, uint8_t materialIndex);
JOLTC_API void JPH_HeightFieldShapeSettings_AddMaterialIndices(JPH_HeightFieldShapeSettings *settings, const uint8_t *materialIndices, uint32_t count);
JOLTC_API uint32_t JPH_HeightFieldShapeSettings_GetNumMaterialIndices(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API const uint8_t *JPH_HeightFieldShapeSettings_GetMaterialIndices(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API void JPH_HeightFieldShapeSettings_AddMaterial(JPH_HeightFieldShapeSettings *settings, const JPH_PhysicsMaterial *material);
JOLTC_API void JPH_HeightFieldShapeSettings_AddMaterials(JPH_HeightFieldShapeSettings *settings, const JPH_PhysicsMaterial **materials, uint32_t count);
JOLTC_API uint32_t JPH_HeightFieldShapeSettings_GetNumMaterials(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API const JPH_PhysicsMaterial *JPH_HeightFieldShapeSettings_GetMaterial(const JPH_HeightFieldShapeSettings *settings, uint32_t index);
JOLTC_API void JPH_HeightFieldShapeSettings_SetOffset(JPH_HeightFieldShapeSettings *settings, JPH_Vec3 offset);
JOLTC_API JPH_Vec3 JPH_HeightFieldShapeSettings_GetOffset(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API void JPH_HeightFieldShapeSettings_SetScale(JPH_HeightFieldShapeSettings *settings, JPH_Vec3 scale);
JOLTC_API JPH_Vec3 JPH_HeightFieldShapeSettings_GetScale(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API void JPH_HeightFieldShapeSettings_SetSampleCount(JPH_HeightFieldShapeSettings *settings, uint32_t sampleCount);
JOLTC_API uint32_t JPH_HeightFieldShapeSettings_GetSampleCount(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API void JPH_HeightFieldShapeSettings_SetMinHeightValue(JPH_HeightFieldShapeSettings *settings, float minHeightValue);
JOLTC_API float JPH_HeightFieldShapeSettings_GetMinHeightValue(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API void JPH_HeightFieldShapeSettings_SetMaxHeightValue(JPH_HeightFieldShapeSettings *settings, float maxHeightValue);
JOLTC_API float JPH_HeightFieldShapeSettings_GetMaxHeightValue(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API void JPH_HeightFieldShapeSettings_SetMaterialsCapacity(JPH_HeightFieldShapeSettings *settings, uint32_t materialsCapacity);
JOLTC_API uint32_t JPH_HeightFieldShapeSettings_GetMaterialsCapacity(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API void JPH_HeightFieldShapeSettings_SetBlockSize(JPH_HeightFieldShapeSettings *settings, uint32_t blockSize);
JOLTC_API uint32_t JPH_HeightFieldShapeSettings_GetBlockSize(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API void JPH_HeightFieldShapeSettings_SetBitsPerSample(JPH_HeightFieldShapeSettings *settings, uint32_t bitsPerSample);
JOLTC_API uint32_t JPH_HeightFieldShapeSettings_GetBitsPerSample(const JPH_HeightFieldShapeSettings *settings);
JOLTC_API void JPH_HeightFieldShapeSettings_SetActiveEdgeCosThresholdAngle(JPH_HeightFieldShapeSettings *settings, float activeEdgeCosThresholdAngle);
JOLTC_API float JPH_HeightFieldShapeSettings_GetActiveEdgeCosThresholdAngle(const JPH_HeightFieldShapeSettings *settings);

// Shape

typedef struct JPH_MassProperties {
    float mass;
    JPH_Mat44 inertia;
} JPH_MassProperties;

JOLTC_API JPH_Vec3 JPH_MassProperties_GetEquivalentSolidBoxSize(float mass, JPH_Vec3 inertiaDiagonal);
JOLTC_API bool JPH_MassProperties_DecomposePrincipalMomentsOfInertia(JPH_MassProperties *massProperties, JPH_Mat44 *outRotation, JPH_Vec3 *outDiagonal);
JOLTC_API void JPH_MassProperties_SetMassAndInertiaOfSolidBox(JPH_MassProperties *massProperties, JPH_Vec3 boxSize, float density);
JOLTC_API void JPH_MassProperties_ScaleToMass(JPH_MassProperties *massProperties, float mass);
JOLTC_API void JPH_MassProperties_Rotate(JPH_MassProperties *massProperties, JPH_Mat44 rotation);
JOLTC_API void JPH_MassProperties_Translate(JPH_MassProperties *massProperties, JPH_Vec3 translation);
JOLTC_API void JPH_MassProperties_Scale(JPH_MassProperties *massProperties, JPH_Vec3 scale);

JOLTC_API void JPH_Shape_AddRef(JPH_Shape *shape);
JOLTC_API void JPH_Shape_Release(JPH_Shape *shape);

JOLTC_API JPH_Shape_EShapeType JPH_Shape_GetType(const JPH_Shape *shape);
JOLTC_API JPH_Shape_EShapeSubType JPH_Shape_GetSubType(const JPH_Shape *shape);

JOLTC_API uint64_t JPH_Shape_GetUserData(const JPH_Shape *shape);
JOLTC_API void JPH_Shape_SetUserData(JPH_Shape *shape, uint64_t userData);

JOLTC_API bool JPH_Shape_MustBeStatic(const JPH_Shape *shape);
JOLTC_API JPH_Vec3 JPH_Shape_GetCenterOfMass(const JPH_Shape *shape);
JOLTC_API JPH_AABox JPH_Shape_GetLocalBounds(const JPH_Shape *shape);
JOLTC_API uint32_t JPH_Shape_GetSubShapeIDBitsRecursive(const JPH_Shape *shape);
JOLTC_API JPH_AABox JPH_Shape_GetWorldSpaceBounds(const JPH_Shape *shape, JPH_Mat44 centerOfMassTransform, JPH_Vec3 scale);
JOLTC_API float JPH_Shape_GetInnerRadius(const JPH_Shape *shape);

JOLTC_API JPH_MassProperties JPH_Shape_GetMassProperties(const JPH_Shape *shape);

JOLTC_API const JPH_Shape *JPH_Shape_GetLeafShape(const JPH_Shape *shape, JPH_SubShapeID subShapeID, JPH_SubShapeID *outRemainder);
JOLTC_API const JPH_PhysicsMaterial *JPH_Shape_GetMaterial(const JPH_Shape *shape, JPH_SubShapeID subShapeID);
JOLTC_API JPH_Vec3 JPH_Shape_GetSurfaceNormal(const JPH_Shape *shape, JPH_SubShapeID subShapeID, JPH_Vec3 localSurfacePosition);

typedef struct JPH_SupportingFace {
    uint32_t size;
    JPH_Vec3 elements[32]; // @Todo: make sure this is correctly aligned
} JPH_SupportingFace;

JOLTC_API void JPH_Shape_GetSupportingFace(const JPH_Shape *shape, JPH_SubShapeID subShapeID, JPH_Vec3 direction, JPH_Vec3 scale, JPH_Mat44 centerOfMassTransform, JPH_SupportingFace *outVertices);

JOLTC_API uint64_t JPH_Shape_GetSubShapeUserData(const JPH_Shape *shape, JPH_SubShapeID subShapeID);

JOLTC_API void JPH_Shape_GetSubmergedVolume(const JPH_Shape *shape, JPH_Mat44 centerOfMassTransform, JPH_Vec3 scale, JPH_Plane surface, float *outTotalVolume, float *outSubmergedVolume, JPH_Vec3 *outCenterOfBuoyancy);

// @Todo: Shape::CastRay
// @Todo: Shape::CollidePoint

JOLTC_API JPH_Shape *JPH_Shape_ScaleShape(const JPH_Shape *shape, JPH_Vec3 scale);

typedef struct JPH_Shape_GetTrianglesContext {
    JOLTC_ALIGNAS(16) uint8_t data[4288];
} JPH_Shape_GetTrianglesContext;

JOLTC_API void JPH_Shape_GetTrianglesStart(const JPH_Shape *shape, JPH_Shape_GetTrianglesContext *ioContext, JPH_AABox box, JPH_Vec3 positionCOM, JPH_Quat rotation, JPH_Vec3 scale);
JOLTC_API uint32_t JPH_Shape_GetTrianglesNext(const JPH_Shape *shape, JPH_Shape_GetTrianglesContext *ioContext, uint32_t maxTrianglesRequested, JPH_Float3 *outTriangleVertices, const JPH_PhysicsMaterial **outMaterials);

typedef struct JPH_Shape_Stats {
    size_t sizeBytes;
    uint32_t numTriangles;
} JPH_Shape_Stats;

JOLTC_API JPH_Shape_Stats JPH_Shape_GetStats(const JPH_Shape *shape);

JOLTC_API float JPH_Shape_GetVolume(const JPH_Shape *shape);
JOLTC_API bool JPH_Shape_IsValidScale(const JPH_Shape *shape, JPH_Vec3 scale);
JOLTC_API JPH_Vec3 JPH_Shape_MakeScaleValid(const JPH_Shape *shape, JPH_Vec3 scale);

#endif
