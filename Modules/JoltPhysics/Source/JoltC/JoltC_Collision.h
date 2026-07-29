#pragma once

#include <JoltC_Core.h>
#include <JoltC_Shapes.h>

// Forward declarations
struct JPH_Body;

typedef struct JPH_BroadPhaseLayerInterface {
    char opaque;
} JPH_BroadPhaseLayerInterface;

typedef struct JPH_BroadPhaseLayerInterfaceTable {
    JPH_BroadPhaseLayerInterface base;
} JPH_BroadPhaseLayerInterfaceTable;

typedef struct JPH_BroadPhaseLayerInterfaceMask {
    JPH_BroadPhaseLayerInterface base;
} JPH_BroadPhaseLayerInterfaceMask;

typedef struct JPH_ObjectLayerPairFilter {
    char opaque;
} JPH_ObjectLayerPairFilter;

typedef struct JPH_ObjectLayerPairFilterTable {
    JPH_ObjectLayerPairFilter base;
} JPH_ObjectLayerPairFilterTable;

typedef struct JPH_ObjectLayerPairFilterMask {
    JPH_ObjectLayerPairFilter base;
} JPH_ObjectLayerPairFilterMask;

typedef struct JPH_ObjectVsBroadPhaseLayerFilter {
    char opaque;
} JPH_ObjectVsBroadPhaseLayerFilter;

typedef struct JPH_ObjectVsBroadPhaseLayerFilterTable {
    JPH_ObjectVsBroadPhaseLayerFilter base;
} JPH_ObjectVsBroadPhaseLayerFilterTable;

typedef struct JPH_ObjectVsBroadPhaseLayerFilterMask {
    JPH_ObjectVsBroadPhaseLayerFilter base;
} JPH_ObjectVsBroadPhaseLayerFilterMask;

typedef struct JPH_BroadPhaseLayerFilter              JPH_BroadPhaseLayerFilter;
typedef struct JPH_ObjectLayerFilter                  JPH_ObjectLayerFilter;
typedef struct JPH_GroupFilter                        JPH_GroupFilter;
typedef struct JPH_BodyFilter                         JPH_BodyFilter;
typedef struct JPH_ShapeFilter                        JPH_ShapeFilter;
typedef struct JPH_BroadPhaseQuery                    JPH_BroadPhaseQuery;
typedef struct JPH_NarrowPhaseQuery                   JPH_NarrowPhaseQuery;

typedef uint8_t JPH_BroadPhaseLayer;

#if !defined(JOLTC_OBJECT_LAYER_BITS) || JPH_OBJECT_LAYER_BITS == 16
    typedef uint16_t JPH_ObjectLayer;
#elif JPH_OBJECT_LAYER_BITS == 32
    typedef uint32_t JPH_ObjectLayer;
#else
    #error "JPH_OBJECT_LAYER_BITS must be 16 or 32"
#endif

typedef uint32_t JPH_CollisionGroup_GroupID;
typedef uint32_t JPH_CollisionGroup_SubGroupID;

typedef struct JPH_CollisionGroup {
    const JPH_GroupFilter *groupFilter;
    JPH_CollisionGroup_GroupID groupID;
    JPH_CollisionGroup_SubGroupID subGroupID;
} JPH_CollisionGroup;

// Interfaces

typedef struct JPH_BroadPhaseLayerInterface_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    uint32_t (JOLTC_CALL *GetNumBroadPhaseLayers)(const void *data);
    JPH_BroadPhaseLayer (JOLTC_CALL *GetBroadPhaseLayer)(const void *data, JPH_ObjectLayer layer);

#if defined(JOLTC_EXTERNAL_PROFILE) || defined(JOLTC_PROFILE_ENABLED)
    const char *(JOLTC_CALL *GetBroadPhaseLayerName)(const void *data, JPH_BroadPhaseLayer layer);
#endif
} JPH_BroadPhaseLayerInterface_Funcs;

JOLTC_API JPH_BroadPhaseLayerInterface *JPH_BroadPhaseLayerInterface_Create(void *data, JPH_BroadPhaseLayerInterface_Funcs funcs, JPH_Allocator allocator);
JOLTC_API void JPH_BroadPhaseLayerInterface_Destroy(JPH_BroadPhaseLayerInterface *self);
JOLTC_API uint32_t JPH_BroadPhaseLayerInterface_GetNumBroadPhaseLayers(const JPH_BroadPhaseLayerInterface *bplInterface);
JOLTC_API JPH_BroadPhaseLayer JPH_BroadPhaseLayerInterface_GetBroadPhaseLayer(const JPH_BroadPhaseLayerInterface *bplInterface, JPH_ObjectLayer objectLayer);
#if defined(JOLTC_EXTERNAL_PROFILE) || defined(JOLTC_PROFILE_ENABLED)
JOLTC_API const char *JPH_BroadPhaseLayerInterface_GetBroadPhaseLayerName(const JPH_BroadPhaseLayerInterface *bplInterface, JPH_BroadPhaseLayer broadPhaseLayer);
#endif

JOLTC_API JPH_BroadPhaseLayerInterfaceTable *JPH_BroadPhaseLayerInterfaceTable_Create(uint32_t numObjectLayers, uint32_t numBroadPhaseLayers);
JOLTC_API void JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(JPH_BroadPhaseLayerInterfaceTable *table, JPH_ObjectLayer objectLayer, JPH_BroadPhaseLayer broadPhaseLayer);
#if defined(JOLTC_EXTERNAL_PROFILE) || defined(JOLTC_PROFILE_ENABLED)
JOLTC_API void JPH_BroadPhaseLayerInterfaceTable_SetBroadPhaseLayerName(JPH_BroadPhaseLayerInterfaceTable *table, JPH_BroadPhaseLayer broadPhaseLayer, const char *name);
#endif

JOLTC_API JPH_BroadPhaseLayerInterfaceMask *JPH_BroadPhaseLayerInterfaceMask_Create(uint32_t numBroadPhaseLayers);
JOLTC_API void JPH_BroadPhaseLayerInterfaceMask_ConfigureLayer(JPH_BroadPhaseLayerInterfaceMask *mask, JPH_BroadPhaseLayer broadPhaseLayer, uint32_t groupsToInclude, uint32_t groupsToExclude);
#if defined(JOLTC_EXTERNAL_PROFILE) || defined(JOLTC_PROFILE_ENABLED)
JOLTC_API void JPH_BroadPhaseLayerInterfaceMask_SetBroadPhaseLayerName(JPH_BroadPhaseLayerInterfaceMask *mask, JPH_BroadPhaseLayer broadPhaseLayer, const char *name);
#endif

typedef struct JPH_ObjectLayerPairFilter_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    bool (JOLTC_CALL *ShouldCollide)(const void *data, JPH_ObjectLayer layer1, JPH_ObjectLayer layer2);
} JPH_ObjectLayerPairFilter_Funcs;

JOLTC_API JPH_ObjectLayerPairFilter *JPH_ObjectLayerPairFilter_Create(void *data, JPH_ObjectLayerPairFilter_Funcs funcs, JPH_Allocator allocator);
JOLTC_API void JPH_ObjectLayerPairFilter_Destroy(JPH_ObjectLayerPairFilter *self);
JOLTC_API bool JPH_ObjectLayerPairFilter_ShouldCollide(const JPH_ObjectLayerPairFilter *filter, JPH_ObjectLayer layer1, JPH_ObjectLayer layer2);

JOLTC_API JPH_ObjectLayerPairFilterTable *JPH_ObjectLayerPairFilterTable_Create(uint32_t numObjectLayers);
JOLTC_API uint32_t JPH_ObjectLayerPairFilterTable_GetNumObjectLayers(const JPH_ObjectLayerPairFilterTable *table);
JOLTC_API void JPH_ObjectLayerPairFilterTable_EnableCollision(JPH_ObjectLayerPairFilterTable *table, JPH_ObjectLayer layer1, JPH_ObjectLayer layer2);
JOLTC_API void JPH_ObjectLayerPairFilterTable_DisableCollision(JPH_ObjectLayerPairFilterTable *table, JPH_ObjectLayer layer1, JPH_ObjectLayer layer2);

#define JPH_ObjectLayerPairFilterMask_cNumBits (JOLTC_OBJECT_LAYER_BITS / 2)
#define JPH_ObjectLayerPairFilterMask_cMask ((1 << JPH_ObjectLayerPairFilterMask_cNumBits) - 1)

JOLTC_API JPH_ObjectLayerPairFilterMask *JPH_ObjectLayerPairFilterMask_Create();
JOLTC_API uint32_t JPH_ObjectLayerPairFilterMask_GetGroup(JPH_ObjectLayer objectLayer);
JOLTC_API uint32_t JPH_ObjectLayerPairFilterMask_GetMask(JPH_ObjectLayer objectLayer);
JOLTC_API JPH_ObjectLayer JPH_ObjectLayerPairFilterMask_GetObjectLayer(uint32_t group, uint32_t mask);

typedef struct JPH_ObjectVsBroadPhaseLayerFilter_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    bool (JOLTC_CALL *ShouldCollide)(const void *data, JPH_ObjectLayer layer1, JPH_BroadPhaseLayer layer2);
} JPH_ObjectVsBroadPhaseLayerFilter_Funcs;

JOLTC_API JPH_ObjectVsBroadPhaseLayerFilter *JPH_ObjectVsBroadPhaseLayerFilter_Create(void *data, JPH_ObjectVsBroadPhaseLayerFilter_Funcs funcs, JPH_Allocator allocator);
JOLTC_API void JPH_ObjectVsBroadPhaseLayerFilter_Destroy(JPH_ObjectVsBroadPhaseLayerFilter *self);
JOLTC_API bool JPH_ObjectVsBroadPhaseLayerFilter_ShouldCollide(const JPH_ObjectVsBroadPhaseLayerFilter *filter, JPH_ObjectLayer objectLayer, JPH_BroadPhaseLayer broadPhaseLayer);

JOLTC_API JPH_ObjectVsBroadPhaseLayerFilterTable *JPH_ObjectVsBroadPhaseLayerFilterTable_Create(const JPH_BroadPhaseLayerInterface *bplInterface, uint32_t numBroadPhaseLayers, const JPH_ObjectLayerPairFilter *objectLayerPairFilter, uint32_t numObjectLayers);
JOLTC_API JPH_ObjectVsBroadPhaseLayerFilterMask *JPH_ObjectVsBroadPhaseLayerFilterMask_Create(const JPH_BroadPhaseLayerInterfaceMask *bplInterface);

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

typedef struct JPH_BodyFilter_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    bool (JOLTC_CALL *ShouldCollide)(const void *data, JPH_BodyID bodyID);
    bool (JOLTC_CALL *ShouldCollideLocked)(const void *data, const struct JPH_Body *body);
} JPH_BodyFilter_Funcs;

JOLTC_API JPH_BodyFilter *JPH_BodyFilter_Create(void *data, JPH_BodyFilter_Funcs funcs, JPH_Allocator allocator);
JOLTC_API JPH_BodyFilter *JPH_IgnoreMultipleBodiesFilter_Create(const JPH_BodyID *bodyIDs, int numBodies, JPH_Allocator allocator);
JOLTC_API JPH_BodyFilter *JPH_IgnoreSingleBodyFilter_Create(JPH_BodyID bodyID, JPH_Allocator allocator);
JOLTC_API JPH_BodyFilter *JPH_IgnoreSingleBodyFilterChained_Create(JPH_BodyID bodyID, const JPH_BodyFilter *otherFilter, JPH_Allocator allocator);
JOLTC_API void JPH_BodyFilter_Destroy(JPH_BodyFilter *self);

typedef struct JPH_ShapeFilter_Funcs {
    void (JOLTC_CALL *Destruct)(void *data);
    bool (JOLTC_CALL *ShouldCollide)(const void *data, const JPH_Shape *shape2, JPH_SubShapeID subShapeIDOfShape2);
    bool (JOLTC_CALL *ShapesShouldCollide)(const void *data, const JPH_Shape *shape1, JPH_SubShapeID subShapeIDOfShape1, const JPH_Shape *shape2, JPH_SubShapeID subShapeIDOfShape2);
} JPH_ShapeFilter_Funcs;

JOLTC_API JPH_ShapeFilter *JPH_ShapeFilter_Create(void *data, JPH_ShapeFilter_Funcs funcs, JPH_Allocator allocator);
JOLTC_API JPH_ShapeFilter *JPH_ReversedShapeFilter_Create(const JPH_ShapeFilter *other, JPH_Allocator allocator);
JOLTC_API void JPH_ShapeFilter_Destroy(JPH_ShapeFilter *self);

// Default filters

typedef struct JPH_DefaultBroadPhaseLayerFilter {
    const JPH_ObjectVsBroadPhaseLayerFilter *objectVsBroadPhaseLayerFilter;
    JPH_ObjectLayer layer;
} JPH_DefaultBroadPhaseLayerFilter;

JOLTC_API bool JPH_DefaultBroadPhaseLayerFilter_ShouldCollide(const void *data, JPH_BroadPhaseLayer layer);
JOLTC_API const JPH_BroadPhaseLayerFilter *JPH_DefaultBroadPhaseLayerFilter_CreateFilter(JPH_DefaultBroadPhaseLayerFilter *filter, JPH_Allocator allocator);

typedef struct JPH_DefaultObjectLayerFilter {
    const JPH_ObjectLayerPairFilter *objectLayerPairFilter;
    JPH_ObjectLayer layer;
} JPH_DefaultObjectLayerFilter;

JOLTC_API bool JPH_DefaultObjectLayerFilter_ShouldCollide(const void *data, JPH_ObjectLayer layer);
JOLTC_API const JPH_ObjectLayerFilter *JPH_DefaultObjectLayerFilter_CreateFilter(JPH_DefaultObjectLayerFilter *filter, JPH_Allocator allocator);

typedef struct JPH_RayCast {
    JPH_Vec3 origin;
    JPH_Vec3 direction;
} JPH_RayCast;

JOLTC_API JPH_RayCast JPH_RayCast_Transformed(const JPH_RayCast *ray, JPH_Mat44 transform);
JOLTC_API JPH_RayCast JPH_RayCast_Translated(const JPH_RayCast *ray, JPH_Vec3 translation);
JOLTC_API JPH_Vec3 JPH_RayCast_GetPointOnRay(const JPH_RayCast *ray, float fraction);

typedef struct JPH_RRayCast {
    JPH_RVec3 origin;
    JPH_Vec3 direction;
} JPH_RRayCast;

JOLTC_API JPH_RRayCast JPH_RRayCast_Transformed(const JPH_RRayCast *ray, JPH_RMat44 transform);
JOLTC_API JPH_RRayCast JPH_RRayCast_Translated(const JPH_RRayCast *ray, JPH_RVec3 translation);
JOLTC_API JPH_RVec3 JPH_RRayCast_GetPointOnRay(const JPH_RRayCast *ray, float fraction);

typedef uint8_t JPH_EBackFaceMode;
enum JPH_EBackFaceMode_ {
    JPH_EBackFaceMode_IgnoreBackFaces,
    JPH_EBackFaceMode_CollideWithBackFaces,
};

typedef struct JPH_RayCastSettings {
    JPH_EBackFaceMode backFaceModeTriangles;
    JPH_EBackFaceMode backFaceModeConvex;
    bool treatConvexAsSolid;
} JPH_RayCastSettings;

JOLTC_API JPH_RayCastSettings JPH_RayCastSettings_Default();

typedef struct JPH_AABoxCast {
    JPH_AABox box;
    JPH_Vec3 direction;
} JPH_AABoxCast;

typedef uint32_t JPH_ECollisionCollectorType;
enum JPH_ECollisionCollectorType_ {
    JPH_ECollisionCollectorType_AnyHit,
    JPH_ECollisionCollectorType_ClosestHit,
    JPH_ECollisionCollectorType_AllHitsSorted,
    JPH_ECollisionCollectorType_AllHits,
};

typedef struct JPH_BroadPhaseCastResult {
    JPH_BodyID bodyID;
    float fraction;
} JPH_BroadPhaseCastResult;

typedef struct JPH_RayCastResult {
    JPH_BodyID bodyID;
    float fraction;
    JPH_SubShapeID subShapeID2;
} JPH_RayCastResult;

JOLTC_API JPH_RayCastResult JPH_RayCastResult_Default();

typedef void (*JPH_BroadPhaseQuery_CastRayHitCallback)(void *data, const JPH_BroadPhaseCastResult *hit);
typedef float (*JPH_BroadPhaseQuery_CastRayCollectCallback)(void *data, const JPH_BroadPhaseCastResult *hit);

JOLTC_API JPH_AABox JPH_BroadPhaseQuery_GetBounds(const JPH_BroadPhaseQuery *query);
JOLTC_API bool JPH_BroadPhaseQuery_CastRay(const JPH_BroadPhaseQuery *query, JPH_RayCast ray, JPH_ECollisionCollectorType collectorType, void *data, JPH_BroadPhaseQuery_CastRayHitCallback callback, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter);

// JOLTC_API bool JPH_BroadPhaseQuery_CollideAABox(const JPH_BroadPhaseQuery *query, JPH_AABox box, JPH_ECollisionCollectorType collectorType, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter);
// JOLTC_API bool JPH_BroadPhaseQuery_CollideSphere(const JPH_BroadPhaseQuery *query, JPH_Vec3 center, float radius, JPH_ECollisionCollectorType collectorType, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter);
// JOLTC_API bool JPH_BroadPhaseQuery_CollidePoint(const JPH_BroadPhaseQuery *query, JPH_Vec3 point, JPH_ECollisionCollectorType collectorType, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter);
// JOLTC_API bool JPH_BroadPhaseQuery_CollideOrientedBox(const JPH_BroadPhaseQuery *query, JPH_OrientedBox box, JPH_ECollisionCollectorType collectorType, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter);
// JOLTC_API bool JPH_BroadPhaseQuery_CastAABox(const JPH_BroadPhaseQuery *query, JPH_AABoxCast box, JPH_ECollisionCollectorType collectorType, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *inObjectLayerFilter);

JOLTC_API bool JPH_NarrowPhaseQuery_CastRay(const JPH_NarrowPhaseQuery *query, JPH_RRayCast ray, JPH_RayCastResult *ioHit, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter, const JPH_BodyFilter *bodyFilter);
// void JPH_NarrowPhaseQuery_CastRay(const JPH_NarrowPhaseQuery *query, JPH_RRayCast ray, const RayCastSettings &inRayCastSettings, CastRayCollector &ioCollector, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter, const JPH_BodyFilter *bodyFilter, const ShapeFilter &inShapeFilter);
// void JPH_NarrowPhaseQuery_CollidePoint(const JPH_NarrowPhaseQuery *query, RVec3Arg inPoint, CollidePointCollector &ioCollector, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter, const JPH_BodyFilter *bodyFilter, const ShapeFilter &inShapeFilter);
// void JPH_NarrowPhaseQuery_CollideShape(const JPH_NarrowPhaseQuery *query, const Shape *inShape, Vec3Arg inShapeScale, RMat44Arg inCenterOfMassTransform, const CollideShapeSettings &inCollideShapeSettings, RVec3Arg inBaseOffset, CollideShapeCollector &ioCollector, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter, const JPH_BodyFilter *bodyFilter, const ShapeFilter &inShapeFilter);
// void JPH_NarrowPhaseQuery_CollideShapeWithInternalEdgeRemoval(const JPH_NarrowPhaseQuery *query, const Shape *inShape, Vec3Arg inShapeScale, RMat44Arg inCenterOfMassTransform, const CollideShapeSettings &inCollideShapeSettings, RVec3Arg inBaseOffset, CollideShapeCollector &ioCollector, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter, const JPH_BodyFilter *bodyFilter, const ShapeFilter &inShapeFilter);
// void JPH_NarrowPhaseQuery_CastShape(const JPH_NarrowPhaseQuery *query, const RShapeCast &inShapeCast, const ShapeCastSettings &inShapeCastSettings, RVec3Arg inBaseOffset, CastShapeCollector &ioCollector, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter, const JPH_BodyFilter *bodyFilter, const ShapeFilter &inShapeFilter);
// void JPH_NarrowPhaseQuery_CollectTransformedShapes(const JPH_NarrowPhaseQuery *query, const AABox &inBox, TransformedShapeCollector &ioCollector, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter, const JPH_BodyFilter *bodyFilter, const ShapeFilter &inShapeFilter);

// @Todo: ShapeFilter
