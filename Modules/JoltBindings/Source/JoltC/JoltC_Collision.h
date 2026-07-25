#pragma once

#include <JoltC_Core.h>

typedef struct JPH_PhysicsMaterial               JPH_PhysicsMaterial;
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

// @Todo: ShapeFilter
