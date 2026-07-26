#pragma once

#include <JoltC_Core.h>
#include <JoltC_Shapes.h>

typedef struct JPH_BroadPhaseLayerInterface      JPH_BroadPhaseLayerInterface;
typedef struct JPH_ObjectVsBroadPhaseLayerFilter JPH_ObjectVsBroadPhaseLayerFilter;
typedef struct JPH_ObjectLayerPairFilter         JPH_ObjectLayerPairFilter;
typedef struct JPH_BroadPhaseLayerFilter         JPH_BroadPhaseLayerFilter;
typedef struct JPH_ObjectLayerFilter             JPH_ObjectLayerFilter;
typedef struct JPH_GroupFilter                   JPH_GroupFilter;
typedef struct JPH_BroadPhaseQuery               JPH_BroadPhaseQuery;
typedef struct JPH_NarrowPhaseQuery              JPH_NarrowPhaseQuery;

typedef uint8_t JPH_BroadPhaseLayer;

#if !defined(JPH_OBJECT_LAYER_BITS) || JPH_OBJECT_LAYER_BITS == 16
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
JOLTC_API const JPH_BroadPhaseLayerFilter *JPH_DefaultBroadPhaseLayerFilter_CreateFilter(JPH_DefaultBroadPhaseLayerFilter *filter, JPH_Allocator allocator);

typedef struct JPH_DefaultObjectLayerFilter {
    const JPH_ObjectLayerPairFilter *objectLayerPairFilter;
    JPH_ObjectLayer layer;
} JPH_DefaultObjectLayerFilter;

JOLTC_API bool JPH_DefaultObjectLayerFilter_ShouldCollide(const void *data, JPH_ObjectLayer layer);
JOLTC_API const JPH_ObjectLayerFilter *JPH_DefaultObjectLayerFilter_CreateFilter(JPH_DefaultObjectLayerFilter *filter, JPH_Allocator allocator);

// BroadPhaseQuery

typedef struct JPH_RayCast {
    JPH_Vec3 origin;
    JPH_Vec3 direction;
} JPH_RayCast;

typedef struct JPH_RRayCast {
    JPH_RVec3 origin;
    JPH_Vec3 direction;
} JPH_RRayCast;

typedef uint8_t JPH_EBackFaceMode;
enum {
    JPH_EBackFaceMode_IgnoreBackFaces,
    JPH_EBackFaceMode_CollideWithBackFaces,
};

typedef struct JPH_RayCastSettings {
    JPH_EBackFaceMode backFaceModeTriangles;
    JPH_EBackFaceMode backFaceModeConvex;
    bool treatConvexAsSolid;
} JPH_RayCastSettings;

JOLTC_API JPH_RayCastSettings JPH_RayCastSettings_Default();

typedef struct JPH_OrientedBox {
    JPH_Mat44 orientation;
    JPH_Vec3 halfExtents;
} JPH_OrientedBox;

JOLTC_API bool JPH_OrientedBox_OverlapsAABox(const JPH_OrientedBox *box, JPH_AABox otherBox, float epsilon);
JOLTC_API bool JPH_OrientedBox_OverlapsOrientedBox(const JPH_OrientedBox *box, JPH_OrientedBox otherBox, float epsilon);

typedef struct JPH_AABoxCast {
    JPH_AABox box;
    JPH_Vec3 direction;
} JPH_AABoxCast;

// For now we have a simplified version of the body collector

typedef uint32_t JPH_ECollisionCollectorType;
enum {
    JPH_ECollisionCollectorType_Any,
    JPH_ECollisionCollectorType_Closest,
    JPH_ECollisionCollectorType_AllSorted,
    JPH_ECollisionCollectorType_All,
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

typedef void (*JPH_BroadPhaseQuery_CastRayHitCallback)(void *data, const JPH_BroadPhaseCastResult *hit);
typedef float (*JPH_BroadPhaseQuery_CastRayCollectCallback)(void *data, const JPH_BroadPhaseCastResult *hit);

JOLTC_API JPH_AABox JPH_BroadPhaseQuery_GetBounds(const JPH_BroadPhaseQuery *query);
JOLTC_API bool JPH_BroadPhaseQuery_CastRay(const JPH_BroadPhaseQuery *query, JPH_RayCast ray, JPH_ECollisionCollectorType collectorType, void *data, JPH_BroadPhaseQuery_CastRayHitCallback callback, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter);

JOLTC_API bool JPH_BroadPhaseQuery_CollideAABox(const JPH_BroadPhaseQuery *query, JPH_AABox box, JPH_ECollisionCollectorType collectorType, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter);
JOLTC_API bool JPH_BroadPhaseQuery_CollideSphere(const JPH_BroadPhaseQuery *query, JPH_Vec3 center, float radius, JPH_ECollisionCollectorType collectorType, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter);
JOLTC_API bool JPH_BroadPhaseQuery_CollidePoint(const JPH_BroadPhaseQuery *query, JPH_Vec3 point, JPH_ECollisionCollectorType collectorType, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter);
JOLTC_API bool JPH_BroadPhaseQuery_CollideOrientedBox(const JPH_BroadPhaseQuery *query, JPH_OrientedBox box, JPH_ECollisionCollectorType collectorType, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter);
JOLTC_API bool JPH_BroadPhaseQuery_CastAABox(const JPH_BroadPhaseQuery *query, JPH_AABoxCast box, JPH_ECollisionCollectorType collectorType, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *inObjectLayerFilter);

// @Todo: ShapeFilter
