#pragma once

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

#define JOLTC_API JOLTC_EXTERN JOLTC_EXPORT

#if defined(_WIN32)
#define JOLTC_CALL __cdecl
#else
#define JOLTC_CALL
#endif

#define JOLTC_VECTOR_ALIGNMENT 16 // @Todo: match this with Jolt/Core/Core.h
#define JOLTC_DVECTOR_ALIGNMENT 32

typedef struct JPH_TempAllocator JPH_TempAllocator;
typedef struct JPH_JobSystem     JPH_JobSystem;
typedef struct JPH_SharedMutex   JPH_SharedMutex;

typedef uint32_t JPH_Bool;

// Math

// @Todo: ensure vector type alignment

typedef struct JPH_Float3 {
    float x, y, z;
} JPH_Float3;

typedef union JPH_UVec4 {
    struct {
        uint32_t x, y, z, w;
    };
    uint32_t values[4];
} JPH_UVec4 __attribute__((aligned(JOLTC_VECTOR_ALIGNMENT)));

typedef union JPH_Vec3 {
    struct {
        float x, y, z;
    };
    float values[4];
} JPH_Vec3 __attribute__((aligned(JOLTC_VECTOR_ALIGNMENT)));

typedef union JPH_Vec4 {
    struct {
        float x, y, z, w;
    };
    float values[4];
} JPH_Vec4 __attribute__((aligned(JOLTC_VECTOR_ALIGNMENT)));

typedef struct JPH_Mat44 {
    JPH_Vec4 cols[4];
} JPH_Mat44;

typedef union JPH_DVec3 {
    struct {
        double x, y, z;
    };
    double values[4];
} JPH_DVec3 __attribute__((aligned(JOLTC_DVECTOR_ALIGNMENT)));

typedef union JPH_DVec4 {
    struct {
        double x, y, z, w;
    };
    double values[4];
} JPH_DVec4 __attribute__((aligned(JOLTC_DVECTOR_ALIGNMENT)));

typedef struct JPH_DMat44 {
    JPH_Vec4 cols[3];
    JPH_DVec3 col3;
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
} JPH_Quat __attribute__((aligned(JOLTC_VECTOR_ALIGNMENT)));

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

JOLTC_API JPH_TempAllocator *JPH_TempAllocatorImpl_Create(size_t size);
JOLTC_API JPH_TempAllocator *JPH_TempAllocatorImplWithMallocFallback_Create(uint32_t size);
JOLTC_API JPH_TempAllocator *JPH_TempAllocatorMalloc_Create();
JOLTC_API void JPH_TempAllocator_Destroy(JPH_TempAllocator *allocator);
JOLTC_API void *JPH_TempAllocator_Allocate(JPH_TempAllocator *allocator, uint32_t size);
JOLTC_API void JPH_TempAllocator_Free(JPH_TempAllocator *allocator, void *ptr, uint32_t size);

JOLTC_API JPH_JobSystem *JPH_JobSystemSingleThreaded_Create(uint32_t maxJobs);
JOLTC_API JPH_JobSystem *JPH_JobSystemThreadPool_Create(uint32_t maxJobs, uint32_t maxBarriers, int numThreads);
JOLTC_API void JPH_JobSystem_Destroy(JPH_JobSystem *job_system);

// @Todo: ifdef custom allocators
typedef void *(*JPH_AllocateFunction)(size_t size);
typedef void *(*JPH_ReallocateFunction)(void *block, size_t oldSize, size_t newSize);
typedef void (*JPH_FreeFunction)(void *block);
typedef void *(*JPH_AlignedAllocateFunction)(size_t size, size_t alignment);
typedef void (*JPH_AlignedFreeFunction)(void *block);

typedef void (*JPH_TraceHandler)(const char *fmt, ...);
// @Todo: ifdef enable asserts
typedef bool (*JPH_AssertFailedHandler)(const char *expression, const char *message, const char *file, uint32_t line);

JOLTC_API void JPH_RegisterDefaultAllocator();
JOLTC_API void JPH_SetAllocatorFunctions(JPH_AllocateFunction allocate, JPH_ReallocateFunction reallocate, JPH_FreeFunction free, JPH_AlignedAllocateFunction alignedAllocate, JPH_AlignedFreeFunction alignedFree);
JOLTC_API void JPH_SetTraceHandler(JPH_TraceHandler handler);
JOLTC_API void JPH_SetAssertFailedHandler(JPH_AssertFailedHandler handler);
JOLTC_API void JPH_CreateFactory();
JOLTC_API void JPH_DestroyFactory();
JOLTC_API void JPH_RegisterTypes();
JOLTC_API void JPH_UnregisterTypes();

JOLTC_API void *JPH_Allocate(size_t size);
JOLTC_API void *JPH_Reallocate(void *block, size_t oldSize, size_t newSize);
JOLTC_API void JPH_Free(void *block);
JOLTC_API void *JPH_AlignedAllocate(size_t size, size_t alignment);
JOLTC_API void JPH_AlignedFree(void *block);

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

JOLTC_API void *JPH_Allocator_Allocate(JPH_Allocator allocator, uint64_t size);
JOLTC_API void JPH_Allocator_Free(JPH_Allocator allocator, void *ptr);

JOLTC_API uint64_t JPH_GetJoltVersionID();
