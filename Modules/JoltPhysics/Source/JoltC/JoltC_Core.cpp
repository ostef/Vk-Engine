#include <JoltC.hpp>
#include <JoltC_Core.h>

#include <stdarg.h>
#include <stdio.h>

JOLTC_SUPPRESS_WARNINGS()

// Math functions

JPH_Vec3 JPH_Vec3_Make(float x, float y, float z) {
    JPH_Vec3 v;
    v.x = x;
    v.y = y;
    v.z = z;
    v.z2 = z;
    return v;
}

JPH_DVec3 JPH_DVec3_Make(double x, double y, double z) {
    JPH_DVec3 v;
    v.x = x;
    v.y = y;
    v.z = z;
    v.z2 = z;
    return v;
}

JPH_RVec3 JPH_RVec3_Make(JPH_Real x, JPH_Real y, JPH_Real z) {
    JPH_RVec3 v;
    v.x = x;
    v.y = y;
    v.z = z;
    v.z2 = z;
    return v;
}

JPH_Plane JPH_Plane_Make(JPH_Vec3 normal, float constant) {
    JPH_Plane plane;
    plane.normalAndConstant.x = normal.x;
    plane.normalAndConstant.y = normal.y;
    plane.normalAndConstant.z = normal.z;
    plane.normalAndConstant.w = constant;

    return plane;
}

JPH_Plane JPH_Plane_Offset(JPH_Plane plane, float distance) {
    return ToC(ToCpp(plane).Offset(distance));
}

JPH_Plane JPH_Plane_Scaled(JPH_Plane plane, JPH_Vec3 scale) {
    return ToC(ToCpp(plane).Scaled(ToCpp(scale)));
}

JPH_Plane JPH_Plane_GetTransformed(JPH_Plane plane, JPH_Mat44 transform) {
    return ToC(ToCpp(plane).GetTransformed(ToCpp(transform)));
}

float JPH_Plane_SignedDistance(JPH_Plane plane, JPH_Vec3 point) {
    return ToCpp(plane).SignedDistance(ToCpp(point));
}

JPH_Vec3 JPH_Plane_ProjectPointOnPlane(JPH_Plane plane, JPH_Vec3 point) {
    return ToC(ToCpp(plane).ProjectPointOnPlane(ToCpp(point)));
}

JPH_Plane JPH_Plane_FromPointAndNormal(JPH_Vec3 point, JPH_Vec3 normal) {
    return ToC(JPH::Plane::sFromPointAndNormal(ToCpp(point), ToCpp(normal)));
}

bool JPH_OrientedBox_OverlapsAABox(const JPH_OrientedBox *box, JPH_AABox otherBox, float epsilon) {
    return ToCpp(box)->Overlaps(ToCpp(otherBox), epsilon);
}

bool JPH_OrientedBox_OverlapsOrientedBox(const JPH_OrientedBox *box, JPH_OrientedBox otherBox, float epsilon) {
    return ToCpp(box)->Overlaps(ToCpp(otherBox), epsilon);
}

// Core functions

void JPH_RegisterDefaultAllocator() {
    JPH::RegisterDefaultAllocator();
}

static
void DefaultTrace(const char *fmt, ...) {
    va_list list;
    va_start(list, fmt);
    vprintf(fmt, list);
    va_end(list);

    printf("\n");
}

void JPH_RegisterDefaultTraceHandler() {
    JPH_SetTraceHandler(DefaultTrace);
}

static
bool DefaultAssertFailed(const char *expression, const char *message, const char *file, uint32_t line) {
    printf("Assertion failed at file %s:%u: (%s) %s\n", file, line, expression, message ? message : "");
    // Breakpoint
    return true;
}

#ifdef JOLTC_ENABLE_ASSERTS
void JPH_RegisterDefaultAssertFailedHandler() {
    JPH_SetAssertFailedHandler(DefaultAssertFailed);
}
#endif

void JPH_SetAllocatorFunctions(JPH_AllocateFunction allocate, JPH_ReallocateFunction reallocate, JPH_FreeFunction free, JPH_AlignedAllocateFunction alignedAllocate, JPH_AlignedFreeFunction alignedFree) {
    JPH::Allocate = allocate;
    JPH::Reallocate = reallocate;
    JPH::Free = free;
    JPH::AlignedAllocate = alignedAllocate;
    JPH::AlignedFree = alignedFree;
}

void JPH_SetTraceHandler(JPH_TraceHandler handler) {
    JPH::Trace = handler;
}

#ifdef JOLTC_ENABLE_ASSERTS
void JPH_SetAssertFailedHandler(JPH_AssertFailedHandler handler) {
    JPH::AssertFailed = handler;
}
#endif

void JPH_CreateFactory() {
    JPH::Factory::sInstance = new JPH::Factory;
}

void JPH_DestroyFactory() {
    delete JPH::Factory::sInstance;
    JPH::Factory::sInstance = nullptr;
}

void ABITests();

void JPH_RegisterTypes() {
    ABITests();

    JPH::RegisterTypes();
}

void JPH_UnregisterTypes() {
    JPH::UnregisterTypes();
}

void *JPH_Allocate(size_t size) {
    return JPH::Allocate(size);
}

void *JPH_Reallocate(void *block, size_t oldSize, size_t newSize) {
    return JPH::Reallocate(block, oldSize, newSize);
}

void JPH_Free(void *block) {
    JPH::Free(block);
}

void *JPH_AlignedAllocate(size_t size, size_t alignment) {
    return JPH::AlignedAllocate(size, alignment);
}

void JPH_AlignedFree(void *block) {
    JPH::AlignedFree(block);
}

// Allocator

void *JPH_JoltCAllocator_Allocate(JPH_JoltCAllocator allocator, uint64_t size) {
    if (size == 0) {
        return 0;
    }

    if (allocator.AllocateFunc) {
        return allocator.AllocateFunc(allocator.data, size);
    }

    return JPH::Allocate(size);
}

void JPH_JoltCAllocator_Free(JPH_JoltCAllocator allocator, void *ptr) {
    if (!ptr) {
        return;
    }

    if (allocator.FreeFunc) {
        allocator.FreeFunc(allocator.data, ptr);
    } else if (!allocator.AllocateFunc) {
        // Only call JPH::Free when the allocator has no Allocate function
        // so we can set Free to null to have an allocator that never frees
        JPH::Free(ptr);
    }
}

uint64_t JPH_GetJoltVersionID() {
    using uint64 = uint64_t;

    return JPH_VERSION_ID;
}

JPH_TempAllocatorImpl *JPH_TempAllocatorImpl_Create(size_t size) {
    return ToC(new JPH::TempAllocatorImpl(size));
}

JPH_TempAllocatorImplWithMallocFallback *JPH_TempAllocatorImplWithMallocFallback_Create(uint32_t size) {
    return ToC(new JPH::TempAllocatorImplWithMallocFallback(size));
}

JPH_TempAllocatorMalloc *JPH_TempAllocatorMalloc_Create() {
    return ToC(new JPH::TempAllocatorMalloc);
}

void JPH_TempAllocator_Destroy(JPH_TempAllocator *allocator) {
    delete ToCpp(allocator);
}

void *JPH_TempAllocator_Allocate(JPH_TempAllocator *allocator, uint32_t size) {
    return ToCpp(allocator)->Allocate(size);
}

void JPH_TempAllocator_Free(JPH_TempAllocator *allocator, void *ptr, uint32_t size) {
    ToCpp(allocator)->Free(ptr, size);
}

JPH_JobSystemSingleThreaded *JPH_JobSystemSingleThreaded_Create(uint32_t maxJobs) {
    return ToC(new JPH::JobSystemSingleThreaded(maxJobs));
}

JPH_JobSystemThreadPool *JPH_JobSystemThreadPool_Create(uint32_t maxJobs, uint32_t maxBarriers, int numThreads) {
    return ToC(new JPH::JobSystemThreadPool(maxJobs, maxBarriers, numThreads));
}

void JPH_JobSystem_Destroy(JPH_JobSystem *job_system) {
    delete ToCpp(job_system);
}

JOLTC_POP_WARNINGS()
