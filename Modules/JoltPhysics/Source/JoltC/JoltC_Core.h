#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdalign.h>

#if defined(JOLTC_SHARED_LIBRARY)
  #if defined(JOLTC_BUILD_SHARED_LIBRARY)
    #if defined(_WIN32)
      #define JOLTC_EXPORT __declspec(dllexport)
    #else
      #define JOLTC_EXPORT __attribute__((visibility("default")))
    #endif
  #else
    #if defined(_WIN32)
      #define JOLTC_EXPORT __declspec(dllimport)
    #else
      #define JOLTC_EXPORT __attribute__((visibility("default")))
    #endif
  #endif
#else
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

#ifdef JPH_DOUBLE_PRECISION
  #define JOLTC_DOUBLE_PRECISION
#endif
#ifdef JPH_CROSS_PLATFORM_DETERMINISTIC
  #define JOLTC_CROSS_PLATFORM_DETERMINISTIC
#endif
#ifdef JPH_FLOATING_POINT_EXCEPTIONS_ENABLED
  #define JOLTC_FLOATING_POINT_EXCEPTIONS_ENABLED
#endif
#ifdef JPH_PROFILE_ENABLED
  #define JOLTC_PROFILE_ENABLED
#endif
#ifdef JPH_EXTERNAL_PROFILE
  #define JOLTC_EXTERNAL_PROFILE
#endif
#ifdef JPH_DEBUG_RENDERER
  #define JOLTC_DEBUG_RENDERER
#endif
#ifdef JPH_DISABLE_TEMP_ALLOCATOR
  #define JOLTC_DISABLE_TEMP_ALLOCATOR
#endif
#ifdef JPH_DISABLE_CUSTOM_ALLOCATOR
  #define JOLTC_DISABLE_CUSTOM_ALLOCATOR
#endif
#ifdef JPH_OBJECT_LAYER_BITS
  #define JOLTC_OBJECT_LAYER_BITS JPH_OBJECT_LAYER_BITS
#endif
#ifdef JPH_ENABLE_ASSERTS
  #define JOLTC_ENABLE_ASSERTS
#endif
#ifdef JPH_OBJECT_STREAM
  #define JOLTC_OBJECT_STREAM
#endif

#ifdef JOLTC_DOUBLE_PRECISION
	#define JOLTC_VERSION_FEATURE_BIT_1 1
#else
	#define JOLTC_VERSION_FEATURE_BIT_1 0
#endif
#ifdef JOLTC_CROSS_PLATFORM_DETERMINISTIC
	#define JOLTC_VERSION_FEATURE_BIT_2 1
#else
	#define JOLTC_VERSION_FEATURE_BIT_2 0
#endif
#ifdef JOLTC_FLOATING_POINT_EXCEPTIONS_ENABLED
	#define JOLTC_VERSION_FEATURE_BIT_3 1
#else
	#define JOLTC_VERSION_FEATURE_BIT_3 0
#endif
#ifdef JOLTC_PROFILE_ENABLED
	#define JOLTC_VERSION_FEATURE_BIT_4 1
#else
	#define JOLTC_VERSION_FEATURE_BIT_4 0
#endif
#ifdef JOLTC_EXTERNAL_PROFILE
	#define JOLTC_VERSION_FEATURE_BIT_5 1
#else
	#define JOLTC_VERSION_FEATURE_BIT_5 0
#endif
#ifdef JOLTC_DEBUG_RENDERER
	#define JOLTC_VERSION_FEATURE_BIT_6 1
#else
	#define JOLTC_VERSION_FEATURE_BIT_6 0
#endif
#ifdef JOLTC_DISABLE_TEMP_ALLOCATOR
	#define JOLTC_VERSION_FEATURE_BIT_7 1
#else
	#define JOLTC_VERSION_FEATURE_BIT_7 0
#endif
#ifdef JOLTC_DISABLE_CUSTOM_ALLOCATOR
	#define JOLTC_VERSION_FEATURE_BIT_8 1
#else
	#define JOLTC_VERSION_FEATURE_BIT_8 0
#endif
#if defined(JOLTC_OBJECT_LAYER_BITS) && JOLTC_OBJECT_LAYER_BITS == 32
	#define JOLTC_VERSION_FEATURE_BIT_9 1
#else
	#define JOLTC_VERSION_FEATURE_BIT_9 0
#endif
#ifdef JOLTC_ENABLE_ASSERTS
	#define JOLTC_VERSION_FEATURE_BIT_10 1
#else
	#define JOLTC_VERSION_FEATURE_BIT_10 0
#endif
#ifdef JOLTC_OBJECT_STREAM
	#define JOLTC_VERSION_FEATURE_BIT_11 1
#else
	#define JOLTC_VERSION_FEATURE_BIT_11 0
#endif
#define JOLTC_VERSION_FEATURES (uint64_t(JOLTC_VERSION_FEATURE_BIT_1) | (JOLTC_VERSION_FEATURE_BIT_2 << 1) | (JOLTC_VERSION_FEATURE_BIT_3 << 2) | (JOLTC_VERSION_FEATURE_BIT_4 << 3) | (JOLTC_VERSION_FEATURE_BIT_5 << 4) | (JOLTC_VERSION_FEATURE_BIT_6 << 5) | (JOLTC_VERSION_FEATURE_BIT_7 << 6) | (JOLTC_VERSION_FEATURE_BIT_8 << 7) | (JOLTC_VERSION_FEATURE_BIT_9 << 8) | (JOLTC_VERSION_FEATURE_BIT_10 << 9) | (JOLTC_VERSION_FEATURE_BIT_11 << 10))

// Determine if we want extra debugging code to be active
#if !defined(NDEBUG) && !defined(JPH_NO_DEBUG)
	#define JOLTC_DEBUG
#endif

// Always turn on asserts in Debug mode
#if !defined(JOLTC_ENABLE_ASSERTS)
    #if defined(JPH_ENABLE_ASSERTS)
        #define JOLTC_ENABLE_ASSERTS
    #elif defined(JOLTC_DEBUG)
        #define JOLTC_ENABLE_ASSERTS
    #endif
#endif

#define JOLTC_VECTOR_ALIGNMENT 16 // @Todo: match this with Jolt/Core/Core.h
#define JOLTC_DVECTOR_ALIGNMENT 32

typedef struct JPH_TempAllocator JPH_TempAllocator;
typedef struct JPH_JobSystem     JPH_JobSystem;
typedef struct JPH_SharedMutex   JPH_SharedMutex;

// Math

typedef struct JPH_Float3 {
    float x, y, z;
} JPH_Float3;

typedef struct JPH_UVec4 {
    alignas(JOLTC_VECTOR_ALIGNMENT) uint32_t x;
    uint32_t y;
    uint32_t z;
    uint32_t w;
} JPH_UVec4;

typedef struct JPH_Vec3 {
    alignas(JOLTC_VECTOR_ALIGNMENT) float x;
    float y;
    float z;
    float z2;
} JPH_Vec3;

JOLTC_API JPH_Vec3 JPH_Vec3_Make(float x, float y, float z);

typedef struct JPH_Vec4 {
    alignas(JOLTC_VECTOR_ALIGNMENT) float x;
    float y;
    float z;
    float w;
} JPH_Vec4;

typedef struct JPH_Mat44 {
    JPH_Vec4 cols[4];
} JPH_Mat44;

typedef struct JPH_DVec3 {
    alignas(JOLTC_DVECTOR_ALIGNMENT) double x;
    double y;
    double z;
    double z2;
} JPH_DVec3;

JOLTC_API JPH_DVec3 JPH_DVec3_Make(double x, double y, double z);

typedef struct JPH_DMat44 {
    JPH_Vec4 cols[3];
    JPH_DVec3 col3;
} JPH_DMat44;

#ifdef JPH_DOUBLE_PRECISION

typedef JPH_DVec3  JPH_RVec3;
typedef JPH_DMat44 JPH_RMat44;
typedef double     JPH_Real;

#else

typedef JPH_Vec3  JPH_RVec3;
typedef JPH_Mat44 JPH_RMat44;
typedef float     JPH_Real;

#endif

JOLTC_API JPH_RVec3 JPH_RVec3_Make(JPH_Real x, JPH_Real y, JPH_Real z);

typedef struct JPH_Quat {
    alignas(JOLTC_VECTOR_ALIGNMENT) float x;
    float y;
    float z;
    float w;
} JPH_Quat;

#define JPH_Quat_sIdentity ((JPH_Quat){0.0f, 0.0f, 0.0f, 1.0f})

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

typedef struct JPH_OrientedBox {
    JPH_Mat44 orientation;
    JPH_Vec3 halfExtents;
} JPH_OrientedBox;

JOLTC_API bool JPH_OrientedBox_OverlapsAABox(const JPH_OrientedBox *box, JPH_AABox otherBox, float epsilon);
JOLTC_API bool JPH_OrientedBox_OverlapsOrientedBox(const JPH_OrientedBox *box, JPH_OrientedBox otherBox, float epsilon);

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
#ifdef JOLTC_ENABLE_ASSERTS
typedef bool (*JPH_AssertFailedHandler)(const char *expression, const char *message, const char *file, uint32_t line);
#endif

JOLTC_API void JPH_RegisterDefaultAllocator();
JOLTC_API void JPH_RegisterDefaultTraceHandler();
#ifdef JOLTC_ENABLE_ASSERTS
JOLTC_API void JPH_RegisterDefaultAssertFailedHandler();
#endif
JOLTC_API void JPH_SetAllocatorFunctions(JPH_AllocateFunction allocate, JPH_ReallocateFunction reallocate, JPH_FreeFunction free, JPH_AlignedAllocateFunction alignedAllocate, JPH_AlignedFreeFunction alignedFree);
JOLTC_API void JPH_SetTraceHandler(JPH_TraceHandler handler);
#ifdef JOLTC_ENABLE_ASSERTS
JOLTC_API void JPH_SetAssertFailedHandler(JPH_AssertFailedHandler handler);
#endif
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

// Forward decls

typedef uint32_t JPH_BodyID;

#define JPH_cInvalidBodyID 0xffffffff

typedef struct JPH_PhysicsMaterial JPH_PhysicsMaterial;
