#include <JoltC.h>

#include <Jolt/Core/Core.h>

#include <Jolt/Jolt.h>
#include <Jolt/RegisterTypes.h>
#include <Jolt/Core/Factory.h>
#include <Jolt/Core/TempAllocator.h>
#include <Jolt/Core/JobSystemSingleThreaded.h>
#include <Jolt/Core/JobSystemThreadPool.h>
#include <Jolt/Physics/PhysicsSettings.h>
#include <Jolt/Physics/PhysicsSystem.h>
#include <Jolt/Physics/Collision/BroadPhase/BroadPhaseLayerInterfaceMask.h>
#include <Jolt/Physics/Collision/BroadPhase/ObjectVsBroadPhaseLayerFilterMask.h>
#include <Jolt/Physics/Collision/ObjectLayerPairFilterMask.h>
#include <Jolt/Physics/Collision/BroadPhase/BroadPhaseLayerInterfaceTable.h>
#include <Jolt/Physics/Collision/BroadPhase/ObjectVsBroadPhaseLayerFilterTable.h>
#include <Jolt/Physics/Collision/ObjectLayerPairFilterTable.h>
#include <Jolt/Physics/Collision/CastResult.h>
#include <Jolt/Physics/Collision/CollidePointResult.h>
#include <Jolt/Physics/Collision/CollideShape.h>
#include <Jolt/Physics/Collision/CollisionCollectorImpl.h>
#include <Jolt/Physics/Collision/CollisionDispatch.h>
#include <Jolt/Physics/Collision/EstimateCollisionResponse.h>
#include <Jolt/Physics/Collision/ShapeCast.h>
#include <Jolt/Physics/Collision/SimShapeFilter.h>
#include <Jolt/Physics/Collision/Shape/PlaneShape.h>
#include <Jolt/Physics/Collision/Shape/BoxShape.h>
#include <Jolt/Physics/Collision/Shape/SphereShape.h>
#include <Jolt/Physics/Collision/Shape/TriangleShape.h>
#include <Jolt/Physics/Collision/Shape/CapsuleShape.h>
#include <Jolt/Physics/Collision/Shape/TaperedCapsuleShape.h>
#include <Jolt/Physics/Collision/Shape/CylinderShape.h>
#include <Jolt/Physics/Collision/Shape/TaperedCylinderShape.h>
#include <Jolt/Physics/Collision/Shape/ConvexHullShape.h>
#include <Jolt/Physics/Collision/Shape/MeshShape.h>
#include <Jolt/Physics/Collision/Shape/HeightFieldShape.h>
#include <Jolt/Physics/Collision/Shape/StaticCompoundShape.h>
#include <Jolt/Physics/Collision/Shape/MutableCompoundShape.h>
#include <Jolt/Physics/Collision/Shape/DecoratedShape.h>
#include <Jolt/Physics/Collision/Shape/RotatedTranslatedShape.h>
#include <Jolt/Physics/Collision/Shape/ScaledShape.h>
#include <Jolt/Physics/Collision/Shape/OffsetCenterOfMassShape.h>
#include <Jolt/Physics/Collision/Shape/EmptyShape.h>
#include <Jolt/Physics/Body/BodyCreationSettings.h>
#include <Jolt/Physics/Body/BodyActivationListener.h>
#include <Jolt/Physics/SoftBody/SoftBodyCreationSettings.h>
#include <Jolt/Physics/Collision/RayCast.h>
#include <Jolt/Physics/Collision/BroadPhase/BroadPhaseQuery.h>
#include <Jolt/Physics/Collision/NarrowPhaseQuery.h>
#include <Jolt/Physics/Constraints/SpringSettings.h>
#include <Jolt/Physics/Constraints/FixedConstraint.h>
#include <Jolt/Physics/Constraints/PointConstraint.h>
#include <Jolt/Physics/Constraints/DistanceConstraint.h>
#include <Jolt/Physics/Constraints/HingeConstraint.h>
#include <Jolt/Physics/Constraints/SliderConstraint.h>
#include <Jolt/Physics/Constraints/ConeConstraint.h>
#include <Jolt/Physics/Constraints/SwingTwistConstraint.h>
#include <Jolt/Physics/Constraints/SixDOFConstraint.h>
#include <Jolt/Physics/Constraints/GearConstraint.h>
#include <Jolt/Physics/Constraints/PulleyConstraint.h>
#include <Jolt/Physics/Character/Character.h>
#include <Jolt/Physics/Character/CharacterVirtual.h>
#include <Jolt/Physics/Collision/PhysicsMaterialSimple.h>
#include <Jolt/Physics/Collision/GroupFilterTable.h>
#include <Jolt/Physics/Body/BodyLockMulti.h>
#include <Jolt/Physics/Ragdoll/Ragdoll.h>
#include <Jolt/Physics/Vehicle/WheeledVehicleController.h>
#include <Jolt/Physics/Vehicle/MotorcycleController.h>
#include <Jolt/Physics/Vehicle/TrackedVehicleController.h>

#ifdef JPH_DEBUG_RENDERER
#include <Jolt/Renderer/DebugRenderer.h>
#include <Jolt/Renderer/DebugRendererSimple.h>
#endif

// Allocator

void *JPH_Allocate(JPH_Allocator allocator, uint64_t size) {
    if (size == 0) {
        return 0;
    }

    if (allocator.Allocate) {
        return allocator.Allocate(allocator.data, size);
    }

    return JPH::Allocate(size);
}

void JPH_Free(JPH_Allocator allocator, void *ptr) {
    if (!ptr) {
        return;
    }

    if (allocator.Free) {
        allocator.Free(allocator.data, ptr);
    } else if (!allocator.Allocate) {
        // Only call JPH::Free when the allocator has no Allocate function
        // so we can set Free to null to have an allocator that never frees
        JPH::Free(ptr);
    }
}

// Math conversion

static inline JPH::Float3 ToCpp(JPH_Float3 v) {
    return *reinterpret_cast<JPH::Float3 *>(&v);
}

static inline JPH_Float3 ToC(JPH::Float3 v) {
    return *reinterpret_cast<JPH_Float3 *>(&v);
}

static inline JPH::Vec3 ToCpp(JPH_Vec3 v) {
    return *reinterpret_cast<JPH::Vec3 *>(&v);
}

static inline JPH_Vec3 ToC(JPH::Vec3 v) {
    return *reinterpret_cast<JPH_Vec3 *>(&v);
}

static inline JPH::Vec4 ToCpp(JPH_Vec4 v) {
    return *reinterpret_cast<JPH::Vec4 *>(&v);
}

static inline JPH_Vec4 ToC(JPH::Vec4 v) {
    return *reinterpret_cast<JPH_Vec4 *>(&v);
}

static inline JPH::Mat44 ToCpp(JPH_Mat44 v) {
    return *reinterpret_cast<JPH::Mat44 *>(&v);
}

static inline JPH_Mat44 ToC(JPH::Mat44 v) {
    return *reinterpret_cast<JPH_Mat44 *>(&v);
}

static inline JPH::DVec3 ToCpp(JPH_DVec3 v) {
    return *reinterpret_cast<JPH::DVec3 *>(&v);
}

static inline JPH_DVec3 ToC(JPH::DVec3 v) {
    return *reinterpret_cast<JPH_DVec3 *>(&v);
}

static inline JPH::DMat44 ToCpp(JPH_DMat44 v) {
    return *reinterpret_cast<JPH::DMat44 *>(&v);
}

static inline JPH_DMat44 ToC(JPH::DMat44 v) {
    return *reinterpret_cast<JPH_DMat44 *>(&v);
}

static inline JPH::Quat ToCpp(JPH_Quat v) {
    return *reinterpret_cast<JPH::Quat *>(&v);
}

static inline JPH_Quat ToC(JPH::Quat v) {
    return *reinterpret_cast<JPH_Quat *>(&v);
}

static inline JPH::AABox ToCpp(JPH_AABox v) {
    return *reinterpret_cast<JPH::AABox *>(&v);
}

static inline JPH_AABox ToC(JPH::AABox v) {
    return *reinterpret_cast<JPH_AABox *>(&v);
}

static inline JPH::Plane ToCpp(JPH_Plane v) {
    return *reinterpret_cast<JPH::Plane *>(&v);
}

static inline JPH_Plane ToC(JPH::Plane v) {
    return *reinterpret_cast<JPH_Plane *>(&v);
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

static inline JPH::IndexedTriangle ToCpp(JPH_IndexedTriangle v) {
    return *reinterpret_cast<JPH::IndexedTriangle *>(&v);
}

static inline JPH_IndexedTriangle ToC(JPH::IndexedTriangle v) {
    return *reinterpret_cast<JPH_IndexedTriangle *>(&v);
}

#define DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(c_type, cpp_type) \
    static inline const cpp_type &ToCpp(const c_type &v) { \
        return reinterpret_cast<const cpp_type &>(v); \
    } \
    static inline const cpp_type *ToCpp(const c_type *v) { \
        return reinterpret_cast<const cpp_type *>(v); \
    } \
    static inline cpp_type &ToCpp(c_type &v) { \
        return reinterpret_cast<cpp_type &>(v); \
    } \
    static inline cpp_type *ToCpp(c_type *v) { \
        return reinterpret_cast<cpp_type *>(v); \
    } \
    static inline const c_type &ToC(const cpp_type &v) { \
        return reinterpret_cast<const c_type &>(v); \
    } \
    static inline const c_type *ToC(const cpp_type *v) { \
        return reinterpret_cast<const c_type *>(v); \
    } \
    static inline c_type &ToC(cpp_type &v) { \
        return reinterpret_cast<c_type &>(v); \
    } \
    static inline c_type *ToC(cpp_type *v) { \
        return reinterpret_cast<c_type *>(v); \
    }

#define BEGIN_INTERFACE_WRAPPER_CLASS(name) \
    class name##Wrapper final : public JPH::name { \
    private: \
        void *data; \
        JPH_##name##_Funcs funcs; \
        JPH_Allocator allocator; \
    \
    public: \
        name##Wrapper(void *data, JPH_##name##_Funcs funcs, JPH_Allocator allocator) \
            : data(data), funcs(funcs), allocator(allocator) { \
        } \
    \
        virtual ~name##Wrapper() override { \
            if (funcs.Destruct) { \
                funcs.Destruct(data); \
            } \
        }

#define END_INTERFACE_WRAPPER_CLASS() };

#define DEFINE_INTERFACE_WRAPPER_FUNCTIONS(name) \
    JPH_##name *JPH_##name##_Create(void *data, JPH_##name##_Funcs funcs, JPH_Allocator allocator) { \
        void *ptr = JPH_Allocate(allocator, sizeof(name##Wrapper)); \
        return ToC(new(ptr) name##Wrapper(data, funcs, allocator)); \
    } \
    \
    void JPH_##name##_Destroy(JPH_##name *self) { \
        delete ToCpp(self); \
    }

DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_PhysicsSystem, JPH::PhysicsSystem);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_BodyInterface, JPH::BodyInterface);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_BodyLockInterface, JPH::BodyLockInterface);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_BroadPhaseQuery, JPH::BroadPhaseQuery);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_NarrowPhaseQuery, JPH::NarrowPhaseQuery);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_TempAllocator, JPH::TempAllocator);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_JobSystem, JPH::JobSystem);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_SharedMutex, JPH::SharedMutex);

DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_BroadPhaseLayerInterface, JPH::BroadPhaseLayerInterface);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_ObjectVsBroadPhaseLayerFilter, JPH::ObjectVsBroadPhaseLayerFilter);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_ObjectLayerPairFilter, JPH::ObjectLayerPairFilter);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_BroadPhaseLayerFilter, JPH::BroadPhaseLayerFilter);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_ObjectLayerFilter, JPH::ObjectLayerFilter);

#ifdef JPH_DEBUG_RENDERER

DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_DebugRenderer, JPH::DebugRenderer);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_BodyDrawFilter, JPH::BodyDrawFilter);

#endif

// Shape settings

DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_ShapeSettings, JPH::ShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_ConvexShapeSettings, JPH::ConvexShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_SphereShapeSettings, JPH::SphereShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_BoxShapeSettings, JPH::BoxShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_PlaneShapeSettings, JPH::PlaneShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_TriangleShapeSettings, JPH::TriangleShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_CapsuleShapeSettings, JPH::CapsuleShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_TaperedCapsuleShapeSettings, JPH::TaperedCapsuleShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_CylinderShapeSettings, JPH::CylinderShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_TaperedCylinderShapeSettings, JPH::TaperedCylinderShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_ConvexHullShapeSettings, JPH::ConvexHullShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_CompoundShapeSettings, JPH::CompoundShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_StaticCompoundShapeSettings, JPH::StaticCompoundShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_MutableCompoundShapeSettings, JPH::MutableCompoundShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_MeshShapeSettings, JPH::MeshShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_HeightFieldShapeSettings, JPH::HeightFieldShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_DecoratedShapeSettings, JPH::DecoratedShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_RotatedTranslatedShapeSettings, JPH::RotatedTranslatedShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_ScaledShapeSettings, JPH::ScaledShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_OffsetCenterOfMassShapeSettings, JPH::OffsetCenterOfMassShapeSettings);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_EmptyShapeSettings, JPH::EmptyShapeSettings);

// Shapes

DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_Shape, JPH::Shape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_ConvexShape, JPH::ConvexShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_SphereShape, JPH::SphereShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_BoxShape, JPH::BoxShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_PlaneShape, JPH::PlaneShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_TriangleShape, JPH::TriangleShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_CapsuleShape, JPH::CapsuleShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_TaperedCapsuleShape, JPH::TaperedCapsuleShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_CylinderShape, JPH::CylinderShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_TaperedCylinderShape, JPH::TaperedCylinderShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_ConvexHullShape, JPH::ConvexHullShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_CompoundShape, JPH::CompoundShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_StaticCompoundShape, JPH::StaticCompoundShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_MutableCompoundShape, JPH::MutableCompoundShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_MeshShape, JPH::MeshShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_HeightFieldShape, JPH::HeightFieldShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_DecoratedShape, JPH::DecoratedShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_RotatedTranslatedShape, JPH::RotatedTranslatedShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_ScaledShape, JPH::ScaledShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_OffsetCenterOfMassShape, JPH::OffsetCenterOfMassShape);
DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_EmptyShape, JPH::EmptyShape);

DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_PhysicsMaterial, JPH::PhysicsMaterial);

// Body

DEFINE_OPAQUE_TYPE_CONVERSION_FUNCTIONS(JPH_Body, JPH::Body);

// Core

JPH_TempAllocator *JPH_TempAllocatorImpl_Create(size_t size) {
    return ToC(static_cast<JPH::TempAllocator *>(new JPH::TempAllocatorImpl(size)));
}

JPH_TempAllocator *JPH_TempAllocatorImplWithMallocFallback_Create(uint32_t size) {
    return ToC(static_cast<JPH::TempAllocator *>(new JPH::TempAllocatorImplWithMallocFallback(size)));
}

JPH_TempAllocator *JPH_TempAllocatorMalloc_Create() {
    return ToC(static_cast<JPH::TempAllocator *>(new JPH::TempAllocatorMalloc));
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

JPH_JobSystem *JPH_JobSystemSingleThreaded_Create(uint32_t maxJobs) {
    return ToC(static_cast<JPH::JobSystem *>(new JPH::JobSystemSingleThreaded(maxJobs)));
}

JPH_JobSystem *JPH_JobSystemThreadPool_Create(uint32_t maxJobs, uint32_t maxBarriers, int numThreads) {
    return ToC(static_cast<JPH::JobSystem *>(new JPH::JobSystemThreadPool(maxJobs, maxBarriers, numThreads)));
}

void JPH_JobSystem_Destroy(JPH_JobSystem *job_system) {
    delete ToCpp(job_system);
}

// Debug renderer

#ifdef JPH_DEBUG_RENDERER

BEGIN_INTERFACE_WRAPPER_CLASS(BodyDrawFilter);

    virtual bool ShouldDraw(const JPH::Body &body) const {
        if (funcs.ShouldDraw) {
            return funcs.ShouldDraw(data, &ToC(body));
        }
        return true;
    }

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(BodyDrawFilter);

BEGIN_INTERFACE_WRAPPER_CLASS(DebugRendererSimple);

    virtual void DrawLine(JPH::RVec3Arg inFrom, JPH::RVec3Arg inTo, JPH::ColorArg inColor) override {
        if (funcs.DrawLine) {
            funcs.DrawLine(data, ToC(inFrom), ToC(inTo), inColor.GetUInt32());
        }
    }

    virtual void DrawTriangle(JPH::RVec3Arg inV1, JPH::RVec3Arg inV2, JPH::RVec3Arg inV3, JPH::ColorArg inColor, ECastShadow inCastShadow) override {
        if (funcs.DrawTriangle) {
            funcs.DrawTriangle(data, ToC(inV1), ToC(inV2), ToC(inV3), inColor.GetUInt32(), static_cast<JPH_DebugRenderer_ECastShadow>(inCastShadow));
        } else {
            DrawLine(inV1, inV2, inColor);
            DrawLine(inV2, inV3, inColor);
            DrawLine(inV3, inV1, inColor);
        }
    }

    virtual void DrawText3D(JPH::RVec3Arg inPosition, const std::string_view &inString, JPH::ColorArg inColor, float inHeight) override {
        if (funcs.DrawText3D) {
            funcs.DrawText3D(data, ToC(inPosition), inString.data(), inString.size(), inColor.GetUInt32(), inHeight);
        }
    }

END_INTERFACE_WRAPPER_CLASS();

JPH_DebugRenderer *JPH_DebugRendererSimple_Create(void *data, JPH_DebugRendererSimple_Funcs funcs, JPH_Allocator allocator) {
    void *ptr = JPH_Allocate(allocator, sizeof(DebugRendererSimpleWrapper));
    return ToC(reinterpret_cast<JPH::DebugRenderer *>(new(ptr) DebugRendererSimpleWrapper(data, funcs, allocator)));
}

void JPH_DebugRenderer_Destroy(JPH_DebugRenderer *self) {
    delete ToCpp(self);
}

void JPH_DebugRenderer_NextFrame(JPH_DebugRenderer *self) {
    ToCpp(self)->NextFrame();
}

#endif

// Layer filter interfaces

BEGIN_INTERFACE_WRAPPER_CLASS(BroadPhaseLayerInterface);

    virtual uint32_t GetNumBroadPhaseLayers() const override {
        if (funcs.GetNumBroadPhaseLayers) {
            return funcs.GetNumBroadPhaseLayers(data);
        }
        return 0;
    }

    virtual JPH::BroadPhaseLayer GetBroadPhaseLayer(JPH::ObjectLayer layer) const override {
        if (funcs.GetBroadPhaseLayer) {
            return JPH::BroadPhaseLayer(funcs.GetBroadPhaseLayer(data, layer));
        }
        return JPH::BroadPhaseLayer(0);
    }

#if defined(JPH_EXTERNAL_PROFILE) || defined(JPH_PROFILE_ENABLED)
    virtual const char *GetBroadPhaseLayerName(JPH::BroadPhaseLayer layer) const override {
        if (funcs.GetBroadPhaseLayerName) {
            return funcs.GetBroadPhaseLayerName(data, layer.GetValue());
        }
        return "";
    }
#endif

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(BroadPhaseLayerInterface);

BEGIN_INTERFACE_WRAPPER_CLASS(ObjectVsBroadPhaseLayerFilter);

    virtual bool ShouldCollide(JPH::ObjectLayer layer1, JPH::BroadPhaseLayer layer2) const override {
        if (funcs.ShouldCollide) {
            return funcs.ShouldCollide(data, layer1, layer2.GetValue());
        }
        return true;
    }

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(ObjectVsBroadPhaseLayerFilter);

BEGIN_INTERFACE_WRAPPER_CLASS(ObjectLayerPairFilter);

    virtual bool ShouldCollide(JPH::ObjectLayer layer1, JPH::ObjectLayer layer2) const override {
        if (funcs.ShouldCollide) {
            return funcs.ShouldCollide(data, layer1, layer2);
        }
        return true;
    }

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(ObjectLayerPairFilter);

BEGIN_INTERFACE_WRAPPER_CLASS(BroadPhaseLayerFilter);

	virtual bool ShouldCollide(JPH::BroadPhaseLayer inLayer) const override {
        if (funcs.ShouldCollide) {
            return funcs.ShouldCollide(data, inLayer.GetValue());
        }
        return true;
    }

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(BroadPhaseLayerFilter);

BEGIN_INTERFACE_WRAPPER_CLASS(ObjectLayerFilter);

	virtual bool ShouldCollide(JPH::ObjectLayer inLayer) const override {
        if (funcs.ShouldCollide) {
            return funcs.ShouldCollide(data, inLayer);
        }
        return true;
    }

END_INTERFACE_WRAPPER_CLASS();

DEFINE_INTERFACE_WRAPPER_FUNCTIONS(ObjectLayerFilter);

// Default filters

bool JPH_DefaultBroadPhaseLayerFilter_ShouldCollide(const void *data, JPH_BroadPhaseLayer layer) {
    auto filter = reinterpret_cast<const JPH_DefaultBroadPhaseLayerFilter *>(data);
    return ToCpp(filter->objectVsBroadPhaseLayerFilter)->ShouldCollide(filter->layer, JPH::BroadPhaseLayer(layer));
}

const JPH_BroadPhaseLayerFilter *JPH_DefaultBroadPhaseLayerFilter_CreateFilter(JPH_DefaultBroadPhaseLayerFilter *filter, JPH_Allocator allocator) {
    JPH_BroadPhaseLayerFilter_Funcs funcs = {};
    funcs.ShouldCollide = JPH_DefaultBroadPhaseLayerFilter_ShouldCollide;

    return JPH_BroadPhaseLayerFilter_Create(filter, funcs, allocator);
}

bool JPH_DefaultObjectLayerFilter_ShouldCollide(const void *data, JPH_ObjectLayer layer) {
    auto filter = reinterpret_cast<const JPH_DefaultObjectLayerFilter *>(data);
    return ToCpp(filter->objectLayerPairFilter)->ShouldCollide(filter->layer, layer);
}

const JPH_ObjectLayerFilter *JPH_DefaultObjectLayerFilter_CreateFilter(JPH_DefaultObjectLayerFilter *filter, JPH_Allocator allocator) {
    JPH_ObjectLayerFilter_Funcs funcs = {};
    funcs.ShouldCollide = JPH_DefaultObjectLayerFilter_ShouldCollide;

    return JPH_ObjectLayerFilter_Create(filter, funcs, allocator);
}

// PhysicsSystem

JPH_PhysicsSystem *JPH_PhysicsSystem_Create(JPH_PhysicsSystemSettings settings) {
    auto system = new JPH::PhysicsSystem();
    system->Init(
        settings.maxBodies,
        settings.numBodyMutexes,
        settings.maxBodyPairs,
        settings.maxContactConstraints,
        *ToCpp(settings.broadPhaseLayerInterface),
        *ToCpp(settings.objectVsBroadPhaseLayerFilter),
        *ToCpp(settings.objectLayerPairFilter)
    );

    return ToC(system);
}

void JPH_PhysicsSystem_Destroy(JPH_PhysicsSystem *system) {
    delete ToCpp(system);
}

void JPH_PhysicsSystem_SetPhysicsSettings(JPH_PhysicsSystem *system, JPH_PhysicsSettings settings) {
    JPH::PhysicsSettings cppSettings = {};
    memcpy(&cppSettings, &settings, sizeof(settings));

    ToCpp(system)->SetPhysicsSettings(cppSettings);
}

JPH_PhysicsSettings JPH_PhysicsSystem_GetPhysicsSettings(const JPH_PhysicsSystem *system) {
    auto settings = ToCpp(system)->GetPhysicsSettings();

    JPH_PhysicsSettings result = {};
    memcpy(&result, &settings, sizeof(settings));

    return result;
}

void JPH_PhysicsSystem_SetGravity(JPH_PhysicsSystem *system, JPH_Vec3 gravity) {
    ToCpp(system)->SetGravity(ToCpp(gravity));
}

JPH_Vec3 JPH_PhysicsSystem_GetGravity(const JPH_PhysicsSystem *system) {
    return ToC(ToCpp(system)->GetGravity());
}

uint32_t JPH_PhysicsSystem_GetNumBodies(const JPH_PhysicsSystem *system) {
    return ToCpp(system)->GetNumBodies();
}

uint32_t JPH_PhysicsSystem_GetNumActiveBodies(const JPH_PhysicsSystem *system, JPH_EBodyType type) {
    return ToCpp(system)->GetNumActiveBodies(static_cast<JPH::EBodyType>(type));
}

uint32_t JPH_PhysicsSystem_GetMaxBodies(const JPH_PhysicsSystem *system) {
    return ToCpp(system)->GetMaxBodies();
}

JPH_BodyManager_BodyStats JPH_PhysicsSystem_GetBodyStats(const JPH_PhysicsSystem *system) {
    auto stats = ToCpp(system)->GetBodyStats();
    JPH_BodyManager_BodyStats result;
    memcpy(&result, &stats, sizeof(stats));

    return result;
}

uint32_t JPH_PhysicsSystem_GetBodies(const JPH_PhysicsSystem *system, JPH_BodyID **outIDs, JPH_Allocator allocator) {
    if (!outIDs) {
        return 0;
    }

    JPH::BodyIDVector resultVector = {};
    ToCpp(system)->GetBodies(resultVector);

    uint32_t numBodies = static_cast<uint32_t>(resultVector.size());
    JPH_BodyID *ids = reinterpret_cast<JPH_BodyID *>(JPH_Allocate(allocator, sizeof(JPH_BodyID) * numBodies));
    memcpy(ids, resultVector.data(), sizeof(JPH_BodyID) * numBodies);

    *outIDs = ids;

    return numBodies;
}

uint32_t JPH_PhysicsSystem_GetActiveBodies(const JPH_PhysicsSystem *system, JPH_EBodyType type, JPH_BodyID **outIDs, JPH_Allocator allocator) {
    if (!outIDs) {
        return 0;
    }

    JPH::BodyIDVector resultVector = {};
    ToCpp(system)->GetActiveBodies(static_cast<JPH::EBodyType>(type), resultVector);

    uint32_t numBodies = static_cast<uint32_t>(resultVector.size());
    JPH_BodyID *ids = reinterpret_cast<JPH_BodyID *>(JPH_Allocate(allocator, sizeof(JPH_BodyID) * numBodies));
    memcpy(ids, resultVector.data(), sizeof(JPH_BodyID) * numBodies);

    *outIDs = ids;

    return numBodies;
}

const JPH_BodyID *JPH_PhysicsSystem_GetActiveBodiesUnsafe(const JPH_PhysicsSystem *system, JPH_EBodyType type) {
    auto bodies = ToCpp(system)->GetActiveBodiesUnsafe(static_cast<JPH::EBodyType>(type));
    return reinterpret_cast<const JPH_BodyID *>(bodies);
}

bool JPH_PhysicsSystem_WereBodiesInContact(const JPH_PhysicsSystem *system, JPH_BodyID body1ID, JPH_BodyID body2ID) {
    return ToCpp(system)->WereBodiesInContact(JPH::BodyID(body1ID), JPH::BodyID(body2ID));
}

JPH_AABox JPH_PhysicsSystem_GetBounds(const JPH_PhysicsSystem *system) {
    return ToC(ToCpp(system)->GetBounds());
}

JPH_BodyInterface *JPH_PhysicsSystem_GetBodyInterface(JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBodyInterface());
}

const JPH_BodyInterface *JPH_PhysicsSystem_GetBodyInterfaceConst(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBodyInterface());
}

JPH_BodyInterface *JPH_PhysicsSystem_GetBodyInterfaceNoLock(JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBodyInterfaceNoLock());
}

const JPH_BodyInterface *JPH_PhysicsSystem_GetBodyInterfaceNoLockConst(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBodyInterfaceNoLock());
}

const JPH_BroadPhaseQuery *JPH_PhysicsSystem_GetBroadPhaseQuery(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBroadPhaseQuery());
}

const JPH_NarrowPhaseQuery *JPH_PhysicsSystem_GetNarrowPhaseQuery(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetNarrowPhaseQuery());
}

const JPH_NarrowPhaseQuery *JPH_PhysicsSystem_GetNarrowPhaseQueryNoLock(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetNarrowPhaseQueryNoLock());
}

const JPH_BodyLockInterface *JPH_PhysicsSystem_GetBodyLockInterface(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBodyLockInterface());
}

const JPH_BodyLockInterface *JPH_PhysicsSystem_GetBodyLockInterfaceNoLock(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBodyLockInterfaceNoLock());
}

const JPH_BroadPhaseLayerInterface *JPH_PhysicsSystem_GetBroadPhaseLayerInterface(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetBroadPhaseLayerInterface());
}

const JPH_ObjectVsBroadPhaseLayerFilter *JPH_PhysicsSystem_GetObjectVsBroadPhaseLayerFilter(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetObjectVsBroadPhaseLayerFilter());
}

const JPH_ObjectLayerPairFilter *JPH_PhysicsSystem_GetObjectLayerPairFilter(const JPH_PhysicsSystem *system) {
    return &ToC(ToCpp(system)->GetObjectLayerPairFilter());
}

JPH_DefaultBroadPhaseLayerFilter JPH_PhysicsSystem_GetDefaultBroadPhaseLayerFilter(const JPH_PhysicsSystem *system, JPH_ObjectLayer layer) {
    JPH_DefaultBroadPhaseLayerFilter filter = {};
    filter.objectVsBroadPhaseLayerFilter = JPH_PhysicsSystem_GetObjectVsBroadPhaseLayerFilter(system);
    filter.layer = layer;

    return filter;
}

JPH_DefaultObjectLayerFilter JPH_PhysicsSystem_GetDefaultLayerFilter(const JPH_PhysicsSystem *system, JPH_ObjectLayer layer) {
    JPH_DefaultObjectLayerFilter filter = {};
    filter.objectLayerPairFilter = JPH_PhysicsSystem_GetObjectLayerPairFilter(system);
    filter.layer = layer;

    return filter;
}

void JPH_PhysicsSystem_OptimizeBroadPhase(JPH_PhysicsSystem *system) {
    ToCpp(system)->OptimizeBroadPhase();
}

JPH_EPhysicsUpdateError JPH_PhysicsSystem_Update(JPH_PhysicsSystem *system, float deltaTime, int collisionSteps, JPH_TempAllocator *tempAllocator, JPH_JobSystem *jobSystem) {
    return static_cast<JPH_EPhysicsUpdateError>(ToCpp(system)->Update(deltaTime, collisionSteps, ToCpp(tempAllocator), ToCpp(jobSystem)));
}

#ifdef JPH_DEBUG_RENDERER

void JPH_PhysicsSystem_DrawBodies(JPH_PhysicsSystem *system, const JPH_BodyManager_DrawSettings *settings, JPH_DebugRenderer *renderer, const JPH_BodyDrawFilter *bodyFilter) {
    JPH::BodyManager::DrawSettings cppSettings;
    memcpy(&cppSettings, settings, sizeof(JPH_BodyManager_DrawSettings));

    ToCpp(system)->DrawBodies(cppSettings, ToCpp(renderer), ToCpp(bodyFilter));
}

void JPH_PhysicsSystem_DrawConstraints(JPH_PhysicsSystem *system, JPH_DebugRenderer *renderer) {
    ToCpp(system)->DrawConstraints(ToCpp(renderer));
}

void JPH_PhysicsSystem_DrawConstraintLimits(JPH_PhysicsSystem *system, JPH_DebugRenderer *renderer) {
    ToCpp(system)->DrawConstraintLimits(ToCpp(renderer));
}

void JPH_PhysicsSystem_DrawConstraintReferenceFrame(JPH_PhysicsSystem *system, JPH_DebugRenderer *renderer) {
    ToCpp(system)->DrawConstraintReferenceFrame(ToCpp(renderer));
}

#endif

// Shape settings

#define CREATE_SHAPE_IMPL(name) \
    JPH_##name *JPH_##name##Settings_CreateShape(JPH_##name##Settings *settings) { \
        auto result = ToCpp(settings)->Create(); \
        if (!result.IsValid()) { \
            return nullptr; \
        } \
    \
        auto shape = result.Get().GetPtr(); \
        shape->AddRef(); \
    \
        return reinterpret_cast<JPH_##name *>(ToC(shape)); \
    }

void JPH_ShapeSettings_Destroy(JPH_ShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(Shape);

void JPH_ShapeSettings_ClearCachedResult(JPH_ShapeSettings *settings) {
    ToCpp(settings)->ClearCachedResult();
}

void JPH_ShapeSettings_SetUserData(JPH_ShapeSettings *settings, uint64_t userData) {
    ToCpp(settings)->mUserData = userData;
}

uint64_t JPH_ShapeSettings_GetUserData(const JPH_ShapeSettings *settings) {
    return ToCpp(settings)->mUserData;
}

JPH_EmptyShapeSettings *JPH_EmptyShapeSettings_Create() {
    return ToC(new JPH::EmptyShapeSettings);
}

void JPH_EmptyShapeSettings_Destroy(JPH_EmptyShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(EmptyShape);

void JPH_EmptyShapeSettings_SetCenterOfMass(JPH_EmptyShapeSettings *settings, JPH_Vec3 centerOfMass) {
    ToCpp(settings)->mCenterOfMass = ToCpp(centerOfMass);
}

JPH_Vec3 JPH_EmptyShapeSettings_GetCenterOfMass(const JPH_EmptyShapeSettings *settings) {
    return ToC(ToCpp(settings)->mCenterOfMass);
}

JPH_PlaneShapeSettings *JPH_PlaneShapeSettings_Create(JPH_Plane plane, const JPH_PhysicsMaterial *material, float halfExtent) {
    return ToC(new JPH::PlaneShapeSettings(ToCpp(plane), ToCpp(material), halfExtent));
}

void JPH_PlaneShapeSettings_Destroy(JPH_PlaneShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(PlaneShape);

void JPH_PlaneShapeSettings_SetPlane(JPH_PlaneShapeSettings *settings, JPH_Plane plane) {
    ToCpp(settings)->mPlane = ToCpp(plane);
}

JPH_Plane JPH_PlaneShapeSettings_GetPlane(const JPH_PlaneShapeSettings *settings) {
    return ToC(ToCpp(settings)->mPlane);
}

void JPH_PlaneShapeSettings_SetPhysicsMaterial(JPH_PlaneShapeSettings *settings, const JPH_PhysicsMaterial *material) {
    ToCpp(settings)->mMaterial = ToCpp(material);
}

const JPH_PhysicsMaterial *JPH_PlaneShapeSettings_GetPhysicsMaterial(const JPH_PlaneShapeSettings *settings) {
    return ToC(ToCpp(settings)->mMaterial.GetPtr());
}

void JPH_PlaneShapeSettings_SetHalfExtent(JPH_PlaneShapeSettings *settings, float halfExtent) {
    ToCpp(settings)->mHalfExtent = halfExtent;
}

float JPH_PlaneShapeSettings_GetHalfExtent(const JPH_PlaneShapeSettings *settings) {
    return ToCpp(settings)->mHalfExtent;
}

JPH_OffsetCenterOfMassShapeSettings *JPH_OffsetCenterOfMassShapeSettings_Create() {
    return ToC(new JPH::OffsetCenterOfMassShapeSettings);
}

void JPH_OffsetCenterOfMassShapeSettings_Destroy(JPH_OffsetCenterOfMassShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(OffsetCenterOfMassShape);

void JPH_OffsetCenterOfMassShapeSettings_SetInnerShape(JPH_OffsetCenterOfMassShapeSettings *settings, const JPH_Shape *innerShape) {
    ToCpp(settings)->mInnerShapePtr = ToCpp(innerShape);
}

const JPH_Shape *JPH_OffsetCenterOfMassShapeSettings_GetInnerShape(const JPH_OffsetCenterOfMassShapeSettings *settings) {
    return ToC(ToCpp(settings)->mInnerShapePtr.GetPtr());
}

void JPH_OffsetCenterOfMassShapeSettings_SetInnerShapeSettings(JPH_OffsetCenterOfMassShapeSettings *settings, const JPH_ShapeSettings *innerShapeSettings) {
    ToCpp(settings)->mInnerShape = ToCpp(innerShapeSettings);
}

const JPH_ShapeSettings *JPH_OffsetCenterOfMassShapeSettings_GetInnerShapeSettings(const JPH_OffsetCenterOfMassShapeSettings *settings) {
    return ToC(ToCpp(settings)->mInnerShape.GetPtr());
}

void JPH_OffsetCenterOfMassShapeSettings_SetOffset(JPH_OffsetCenterOfMassShapeSettings *settings, JPH_Vec3 offset) {
    ToCpp(settings)->mOffset = ToCpp(offset);
}

JPH_Vec3 JPH_OffsetCenterOfMassShapeSettings_GetOffset(const JPH_OffsetCenterOfMassShapeSettings *settings) {
    return ToC(ToCpp(settings)->mOffset);
}

JPH_RotatedTranslatedShapeSettings *JPH_RotatedTranslatedShapeSettings_Create() {
    return ToC(new JPH::RotatedTranslatedShapeSettings);
}

void JPH_RotatedTranslatedShapeSettings_Destroy(JPH_RotatedTranslatedShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(RotatedTranslatedShape);

void JPH_RotatedTranslatedShapeSettings_SetInnerShape(JPH_RotatedTranslatedShapeSettings *settings, const JPH_Shape *innerShape) {
    ToCpp(settings)->mInnerShapePtr = ToCpp(innerShape);
}

const JPH_Shape *JPH_RotatedTranslatedShapeSettings_GetInnerShape(const JPH_RotatedTranslatedShapeSettings *settings) {
    return ToC(ToCpp(settings)->mInnerShapePtr.GetPtr());
}

void JPH_RotatedTranslatedShapeSettings_SetInnerShapeSettings(JPH_RotatedTranslatedShapeSettings *settings, const JPH_ShapeSettings *innerShapeSettings) {
    ToCpp(settings)->mInnerShape = ToCpp(innerShapeSettings);
}

const JPH_ShapeSettings *JPH_RotatedTranslatedShapeSettings_GetInnerShapeSettings(const JPH_RotatedTranslatedShapeSettings *settings) {
    return ToC(ToCpp(settings)->mInnerShape.GetPtr());
}

void JPH_RotatedTranslatedShapeSettings_SetPosition(JPH_RotatedTranslatedShapeSettings *settings, JPH_Vec3 position) {
    ToCpp(settings)->mPosition = ToCpp(position);
}

JPH_Vec3 JPH_RotatedTranslatedShapeSettings_GetPosition(const JPH_RotatedTranslatedShapeSettings *settings) {
    return ToC(ToCpp(settings)->mPosition);
}

void JPH_RotatedTranslatedShapeSettings_SetRotation(JPH_RotatedTranslatedShapeSettings *settings, JPH_Quat rotation) {
    ToCpp(settings)->mRotation = ToCpp(rotation);
}

JPH_Quat JPH_RotatedTranslatedShapeSettings_GetRotation(const JPH_RotatedTranslatedShapeSettings *settings) {
    return ToC(ToCpp(settings)->mRotation);
}

JPH_ScaledShapeSettings *JPH_ScaledShapeSettings_Create() {
    return ToC(new JPH::ScaledShapeSettings);
}

void JPH_ScaledShapeSettings_Destroy(JPH_ScaledShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(ScaledShape);

void JPH_ScaledShapeSettings_SetInnerShape(JPH_ScaledShapeSettings *settings, const JPH_Shape *innerShape) {
    ToCpp(settings)->mInnerShapePtr = ToCpp(innerShape);
}

const JPH_Shape *JPH_ScaledShapeSettings_GetInnerShape(const JPH_ScaledShapeSettings *settings) {
    return ToC(ToCpp(settings)->mInnerShapePtr.GetPtr());
}

void JPH_ScaledShapeSettings_SetInnerShapeSettings(JPH_ScaledShapeSettings *settings, const JPH_ShapeSettings *innerShapeSettings) {
    ToCpp(settings)->mInnerShape = ToCpp(innerShapeSettings);
}

const JPH_ShapeSettings *JPH_ScaledShapeSettings_GetInnerShapeSettings(const JPH_ScaledShapeSettings *settings) {
    return ToC(ToCpp(settings)->mInnerShape.GetPtr());
}

void JPH_ScaledShapeSettings_SetScale(JPH_ScaledShapeSettings *settings, JPH_Vec3 scale) {
    ToCpp(settings)->mScale = ToCpp(scale);
}

JPH_Vec3 JPH_ScaledShapeSettings_GetScale(const JPH_ScaledShapeSettings *settings) {
    return ToC(ToCpp(settings)->mScale);
}

void JPH_CompoundShapeSettings_Destroy(JPH_CompoundShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(CompoundShape);

void JPH_CompoundShapeSettings_AddShape(JPH_CompoundShapeSettings *settings, JPH_Vec3 position, JPH_Quat rotation, const JPH_Shape *subShape, uint32_t userData) {
    ToCpp(settings)->AddShape(ToCpp(position), ToCpp(rotation), ToCpp(subShape), userData);
}

void JPH_CompoundShapeSettings_AddShapeSettings(JPH_CompoundShapeSettings *settings, JPH_Vec3 position, JPH_Quat rotation, const JPH_ShapeSettings *subShapeSettings, uint32_t userData) {
    ToCpp(settings)->AddShape(ToCpp(position), ToCpp(rotation), ToCpp(subShapeSettings), userData);
}

JPH_StaticCompoundShapeSettings *JPH_StaticCompoundShapeSettings_Create() {
    return ToC(new JPH::StaticCompoundShapeSettings);
}

void JPH_StaticCompoundShapeSettings_Destroy(JPH_StaticCompoundShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(StaticCompoundShape);

JPH_MutableCompoundShapeSettings *JPH_MutableCompoundShapeSettings_Create() {
    return ToC(new JPH::MutableCompoundShapeSettings);
}

void JPH_MutableCompoundShapeSettings_Destroy(JPH_MutableCompoundShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(MutableCompoundShape);

void JPH_ConvexShapeSettings_Destroy(JPH_ConvexShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(ConvexShape);

void JPH_ConvexShapeSettings_SetPhysicsMaterial(JPH_ConvexShapeSettings *settings, const JPH_PhysicsMaterial *material) {
    ToCpp(settings)->mMaterial = ToCpp(material);
}

const JPH_PhysicsMaterial *JPH_ConvexShapeSettings_GetPhysicsMaterial(const JPH_ConvexShapeSettings *settings) {
    return ToC(ToCpp(settings)->mMaterial.GetPtr());
}

void JPH_ConvexShapeSettings_SetDensity(JPH_ConvexShapeSettings *settings, float density) {
    ToCpp(settings)->mDensity = density;
}

float JPH_ConvexShapeSettings_GetDensity(const JPH_ConvexShapeSettings *settings) {
    return ToCpp(settings)->mDensity;
}

JPH_BoxShapeSettings *JPH_BoxShapeSettings_Create() {
    return ToC(new JPH::BoxShapeSettings);
}

void JPH_BoxShapeSettings_Destroy(JPH_BoxShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(BoxShape);

void JPH_BoxShapeSettings_SetHalfExtent(JPH_BoxShapeSettings *settings, JPH_Vec3 halfExtent) {
    ToCpp(settings)->mHalfExtent = ToCpp(halfExtent);
}

JPH_Vec3 JPH_BoxShapeSettings_GetHalfExtent(const JPH_BoxShapeSettings *settings) {
    return ToC(ToCpp(settings)->mHalfExtent);
}

void JPH_BoxShapeSettings_SetConvexRadius(JPH_BoxShapeSettings *settings, float convexRadius) {
    ToCpp(settings)->mConvexRadius = convexRadius;
}

float JPH_BoxShapeSettings_GetConvexRadius(const JPH_BoxShapeSettings *settings) {
    return ToCpp(settings)->mConvexRadius;
}

JPH_SphereShapeSettings *JPH_SphereShapeSettings_Create() {
    return ToC(new JPH::SphereShapeSettings);
}

void JPH_SphereShapeSettings_Destroy(JPH_SphereShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(SphereShape);

void JPH_SphereShapeSettings_SetRadius(JPH_SphereShapeSettings *settings, float radius) {
    ToCpp(settings)->mRadius = radius;
}

float JPH_SphereShapeSettings_GetRadius(const JPH_SphereShapeSettings *settings) {
    return ToCpp(settings)->mRadius;
}

JPH_CapsuleShapeSettings *JPH_CapsuleShapeSettings_Create() {
    return ToC(new JPH::CapsuleShapeSettings);
}

void JPH_CapsuleShapeSettings_Destroy(JPH_CapsuleShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(CapsuleShape);

void JPH_CapsuleShapeSettings_SetRadius(JPH_CapsuleShapeSettings *settings, float radius) {
    ToCpp(settings)->mRadius = radius;
}

float JPH_CapsuleShapeSettings_GetRadius(const JPH_CapsuleShapeSettings *settings) {
    return ToCpp(settings)->mRadius;
}

void JPH_CapsuleShapeSettings_SetHalfHeightOfCylinder(JPH_CapsuleShapeSettings *settings, float halfHeightOfCylinder) {
    ToCpp(settings)->mHalfHeightOfCylinder = halfHeightOfCylinder;
}

float JPH_CapsuleShapeSettings_GetHalfHeightOfCylinder(const JPH_CapsuleShapeSettings *settings) {
    return ToCpp(settings)->mHalfHeightOfCylinder;
}

bool JPH_CapsuleShapeSettings_IsValid(const JPH_CapsuleShapeSettings *settings) {
    return ToCpp(settings)->IsValid();
}

bool JPH_CapsuleShapeSettings_IsSphere(const JPH_CapsuleShapeSettings *settings) {
    return ToCpp(settings)->IsSphere();
}

JPH_TaperedCapsuleShapeSettings *JPH_TaperedCapsuleShapeSettings_Create() {
    return ToC(new JPH::TaperedCapsuleShapeSettings);
}

void JPH_TaperedCapsuleShapeSettings_Destroy(JPH_TaperedCapsuleShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(TaperedCapsuleShape);

void JPH_TaperedCapsuleShapeSettings_SetHalfHeightOfTaperedCylinder(JPH_TaperedCapsuleShapeSettings *settings, float halfHeightOfTaperedCylinder) {
    ToCpp(settings)->mHalfHeightOfTaperedCylinder = halfHeightOfTaperedCylinder;
}

float JPH_TaperedCapsuleShapeSettings_GetHalfHeightOfTaperedCylinder(const JPH_TaperedCapsuleShapeSettings *settings) {
    return ToCpp(settings)->mHalfHeightOfTaperedCylinder;
}

void JPH_TaperedCapsuleShapeSettings_SetTopRadius(JPH_TaperedCapsuleShapeSettings *settings, float topRadius) {
    ToCpp(settings)->mTopRadius = topRadius;
}

float JPH_TaperedCapsuleShapeSettings_GetTopRadius(const JPH_TaperedCapsuleShapeSettings *settings) {
    return ToCpp(settings)->mTopRadius;
}

void JPH_TaperedCapsuleShapeSettings_SetBottomRadius(JPH_TaperedCapsuleShapeSettings *settings, float bottomRadius) {
    ToCpp(settings)->mBottomRadius = bottomRadius;
}

float JPH_TaperedCapsuleShapeSettings_GetBottomRadius(const JPH_TaperedCapsuleShapeSettings *settings) {
    return ToCpp(settings)->mBottomRadius;
}

bool JPH_TaperedCapsuleShapeSettings_IsValid(const JPH_TaperedCapsuleShapeSettings *settings) {
    return ToCpp(settings)->IsValid();
}

bool JPH_TaperedCapsuleShapeSettings_IsSphere(const JPH_TaperedCapsuleShapeSettings *settings) {
    return ToCpp(settings)->IsSphere();
}

JPH_CylinderShapeSettings *JPH_CylinderShapeSettings_Create() {
    return ToC(new JPH::CylinderShapeSettings);
}

void JPH_CylinderShapeSettings_Destroy(JPH_CylinderShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(CylinderShape);

void JPH_CylinderShapeSettings_SetHalfHeight(JPH_CylinderShapeSettings *settings, float halfHeight) {
    ToCpp(settings)->mHalfHeight = halfHeight;
}

float JPH_CylinderShapeSettings_GetHalfHeight(const JPH_CylinderShapeSettings *settings) {
    return ToCpp(settings)->mHalfHeight;
}

void JPH_CylinderShapeSettings_SetRadius(JPH_CylinderShapeSettings *settings, float radius) {
    ToCpp(settings)->mRadius = radius;
}

float JPH_CylinderShapeSettings_GetRadius(const JPH_CylinderShapeSettings *settings) {
    return ToCpp(settings)->mRadius;
}

void JPH_CylinderShapeSettings_SetConvexRadius(JPH_CylinderShapeSettings *settings, float convexRadius) {
    ToCpp(settings)->mConvexRadius = convexRadius;
}

float JPH_CylinderShapeSettings_GetConvexRadius(const JPH_CylinderShapeSettings *settings) {
    return ToCpp(settings)->mConvexRadius;
}

JPH_TaperedCylinderShapeSettings *JPH_TaperedCylinderShapeSettings_Create() {
    return ToC(new JPH::TaperedCylinderShapeSettings);
}

void JPH_TaperedCylinderShapeSettings_Destroy(JPH_TaperedCylinderShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(TaperedCylinderShape);

void JPH_TaperedCylinderShapeSettings_SetHalfHeight(JPH_TaperedCylinderShapeSettings *settings, float halfHeight) {
    ToCpp(settings)->mHalfHeight = halfHeight;
}

float JPH_TaperedCylinderShapeSettings_GetHalfHeight(const JPH_TaperedCylinderShapeSettings *settings) {
    return ToCpp(settings)->mHalfHeight;
}

void JPH_TaperedCylinderShapeSettings_SetTopRadius(JPH_TaperedCylinderShapeSettings *settings, float topRadius) {
    ToCpp(settings)->mTopRadius = topRadius;
}

float JPH_TaperedCylinderShapeSettings_GetTopRadius(const JPH_TaperedCylinderShapeSettings *settings) {
    return ToCpp(settings)->mTopRadius;
}

void JPH_TaperedCylinderShapeSettings_SetBottomRadius(JPH_TaperedCylinderShapeSettings *settings, float bottomRadius) {
    ToCpp(settings)->mBottomRadius = bottomRadius;
}

float JPH_TaperedCylinderShapeSettings_GetBottomRadius(const JPH_TaperedCylinderShapeSettings *settings) {
    return ToCpp(settings)->mBottomRadius;
}

void JPH_TaperedCylinderShapeSettings_SetConvexRadius(JPH_TaperedCylinderShapeSettings *settings, float convexRadius) {
    ToCpp(settings)->mConvexRadius = convexRadius;
}

float JPH_TaperedCylinderShapeSettings_GetConvexRadius(const JPH_TaperedCylinderShapeSettings *settings) {
    return ToCpp(settings)->mConvexRadius;
}

JPH_TriangleShapeSettings *JPH_TriangleShapeSettings_Create() {
    return ToC(new JPH::TriangleShapeSettings);
}

void JPH_TriangleShapeSettings_Destroy(JPH_TriangleShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(TriangleShape);

void JPH_TriangleShapeSettings_SetV1(JPH_TriangleShapeSettings *settings, JPH_Vec3 v1) {
    ToCpp(settings)->mV1 = ToCpp(v1);
}

JPH_Vec3 JPH_TriangleShapeSettings_GetV1(const JPH_TriangleShapeSettings *settings) {
    return ToC(ToCpp(settings)->mV1);
}

void JPH_TriangleShapeSettings_SetV2(JPH_TriangleShapeSettings *settings, JPH_Vec3 v2) {
    ToCpp(settings)->mV2 = ToCpp(v2);
}

JPH_Vec3 JPH_TriangleShapeSettings_GetV2(const JPH_TriangleShapeSettings *settings) {
    return ToC(ToCpp(settings)->mV2);
}

void JPH_TriangleShapeSettings_SetV3(JPH_TriangleShapeSettings *settings, JPH_Vec3 v3) {
    ToCpp(settings)->mV3 = ToCpp(v3);
}

JPH_Vec3 JPH_TriangleShapeSettings_GetV3(const JPH_TriangleShapeSettings *settings) {
    return ToC(ToCpp(settings)->mV3);
}

void JPH_TriangleShapeSettings_SetPoints(JPH_TriangleShapeSettings *settings, JPH_Vec3 v1, JPH_Vec3 v2, JPH_Vec3 v3) {
    ToCpp(settings)->mV1 = ToCpp(v1);
    ToCpp(settings)->mV2 = ToCpp(v2);
    ToCpp(settings)->mV3 = ToCpp(v3);
}

void JPH_TriangleShapeSettings_GetPoints(const JPH_TriangleShapeSettings *settings, JPH_Vec3 *outV1, JPH_Vec3 *outV2, JPH_Vec3 *outV3) {
    *outV1 = ToC(ToCpp(settings)->mV1);
    *outV2 = ToC(ToCpp(settings)->mV2);
    *outV3 = ToC(ToCpp(settings)->mV3);
}

void JPH_TriangleShapeSettings_SetConvexRadius(JPH_TriangleShapeSettings *settings, float convexRadius) {
    ToCpp(settings)->mConvexRadius = convexRadius;
}

float JPH_TriangleShapeSettings_GetConvexRadius(const JPH_TriangleShapeSettings *settings) {
    return ToCpp(settings)->mConvexRadius;
}

JPH_ConvexHullShapeSettings *JPH_ConvexHullShapeSettings_Create() {
    return ToC(new JPH::ConvexHullShapeSettings);
}

void JPH_ConvexHullShapeSettings_Destroy(JPH_ConvexHullShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(ConvexHullShape);

void JPH_ConvexHullShapeSettings_AddPoints(JPH_ConvexHullShapeSettings *settings, const JPH_Vec3 *points, uint32_t count) {
    auto &arr = ToCpp(settings)->mPoints;
    auto *cppPoints = reinterpret_cast<const JPH::Vec3 *>(points);
    arr.insert(arr.end(), cppPoints, cppPoints + count);
}

uint32_t JPH_ConvexHullShapeSettings_GetNumPoints(const JPH_ConvexHullShapeSettings *settings) {
    return static_cast<uint32_t>(ToCpp(settings)->mPoints.size());
}

const JPH_Vec3 *JPH_ConvexHullShapeSettings_GetPoints(const JPH_ConvexHullShapeSettings *settings) {
    return reinterpret_cast<const JPH_Vec3 *>(ToCpp(settings)->mPoints.data());
}

void JPH_ConvexHullShapeSettings_SetMaxConvexRadius(JPH_ConvexHullShapeSettings *settings, float maxConvexRadius) {
    ToCpp(settings)->mMaxConvexRadius = maxConvexRadius;
}

float JPH_ConvexHullShapeSettings_GetMaxConvexRadius(const JPH_ConvexHullShapeSettings *settings) {
    return ToCpp(settings)->mMaxConvexRadius;
}

void JPH_ConvexHullShapeSettings_SetMaxErrorConvexRadius(JPH_ConvexHullShapeSettings *settings, float maxErrorConvexRadius) {
    ToCpp(settings)->mMaxErrorConvexRadius = maxErrorConvexRadius;
}

float JPH_ConvexHullShapeSettings_GetMaxErrorConvexRadius(const JPH_ConvexHullShapeSettings *settings) {
    return ToCpp(settings)->mMaxErrorConvexRadius;
}

void JPH_ConvexHullShapeSettings_SetHullTolerance(JPH_ConvexHullShapeSettings *settings, float hullTolerance) {
    ToCpp(settings)->mHullTolerance = hullTolerance;
}

float JPH_ConvexHullShapeSettings_GetHullTolerance(const JPH_ConvexHullShapeSettings *settings) {
    return ToCpp(settings)->mHullTolerance;
}

JPH_MeshShapeSettings *JPH_MeshShapeSettings_Create() {
    return ToC(new JPH::MeshShapeSettings);
}

void JPH_MeshShapeSettings_Destroy(JPH_MeshShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(MeshShape);

void JPH_MeshShapeSettings_Sanitize(JPH_MeshShapeSettings *settings) {
    ToCpp(settings)->Sanitize();
}

void JPH_MeshShapeSettings_AddVertex(JPH_MeshShapeSettings *settings, JPH_Float3 vertex) {
    ToCpp(settings)->mTriangleVertices.push_back(*reinterpret_cast<JPH::Float3 *>(&vertex));
}

void JPH_MeshShapeSettings_AddVertices(JPH_MeshShapeSettings *settings, const JPH_Float3 *vertices, uint32_t count) {
    auto &arr = ToCpp(settings)->mTriangleVertices;
    auto *cppVertices = reinterpret_cast<const JPH::Float3 *>(vertices);
    arr.insert(arr.end(), cppVertices, cppVertices + count);
}

uint32_t JPH_MeshShapeSettings_GetNumVertices(const JPH_MeshShapeSettings *settings) {
    return static_cast<uint32_t>(ToCpp(settings)->mTriangleVertices.size());
}

const JPH_Float3 *JPH_MeshShapeSettings_GetVertices(const JPH_MeshShapeSettings *settings) {
    return reinterpret_cast<const JPH_Float3 *>(ToCpp(settings)->mTriangleVertices.data());
}

void JPH_MeshShapeSettings_AddIndexedTriangle(JPH_MeshShapeSettings *settings, JPH_IndexedTriangle triangle) {
    ToCpp(settings)->mIndexedTriangles.push_back(*reinterpret_cast<JPH::IndexedTriangle *>(&triangle));
}

void JPH_MeshShapeSettings_AddIndexedTriangles(JPH_MeshShapeSettings *settings, const JPH_IndexedTriangle *triangles, uint32_t count) {
    auto &arr = ToCpp(settings)->mIndexedTriangles;
    auto *cppTriangles = reinterpret_cast<const JPH::IndexedTriangle *>(triangles);
    arr.insert(arr.end(), cppTriangles, cppTriangles + count);
}

uint32_t JPH_MeshShapeSettings_GetNumIndexedTriangles(const JPH_MeshShapeSettings *settings) {
    return static_cast<uint32_t>(ToCpp(settings)->mIndexedTriangles.size());
}

const JPH_IndexedTriangle *JPH_MeshShapeSettings_GetIndexedTriangles(const JPH_MeshShapeSettings *settings) {
    return reinterpret_cast<const JPH_IndexedTriangle *>(ToCpp(settings)->mIndexedTriangles.data());
}

void JPH_MeshShapeSettings_AddMaterial(JPH_MeshShapeSettings *settings, const JPH_PhysicsMaterial *material) {
    ToCpp(settings)->mMaterials.push_back(ToCpp(material));
}

void JPH_MeshShapeSettings_AddMaterials(JPH_MeshShapeSettings *settings, const JPH_PhysicsMaterial **materials, uint32_t count) {
    auto &arr = ToCpp(settings)->mMaterials;
    for (uint32_t i = 0; i < count; i++) {
        arr.push_back(ToCpp(materials[i]));
    }
}

uint32_t JPH_MeshShapeSettings_GetNumMaterials(const JPH_MeshShapeSettings *settings) {
    return static_cast<uint32_t>(ToCpp(settings)->mMaterials.size());
}

const JPH_PhysicsMaterial *JPH_MeshShapeSettings_GetMaterial(const JPH_MeshShapeSettings *settings, uint32_t index) {
    return ToC(ToCpp(settings)->mMaterials[index].GetPtr());
}

void JPH_MeshShapeSettings_SetMaxTrianglesPerLeaf(JPH_MeshShapeSettings *settings, uint32_t maxTrianglesPerLeaf) {
    ToCpp(settings)->mMaxTrianglesPerLeaf = maxTrianglesPerLeaf;
}

uint32_t JPH_MeshShapeSettings_GetMaxTrianglesPerLeaf(const JPH_MeshShapeSettings *settings) {
    return ToCpp(settings)->mMaxTrianglesPerLeaf;
}

void JPH_MeshShapeSettings_SetActiveEdgeCosThresholdAngle(JPH_MeshShapeSettings *settings, float activeEdgeCosThresholdAngle) {
    ToCpp(settings)->mActiveEdgeCosThresholdAngle = activeEdgeCosThresholdAngle;
}

float JPH_MeshShapeSettings_GetActiveEdgeCosThresholdAngle(const JPH_MeshShapeSettings *settings) {
    return ToCpp(settings)->mActiveEdgeCosThresholdAngle;
}

void JPH_MeshShapeSettings_SetPerTriangleUserData(JPH_MeshShapeSettings *settings, bool perTriangleUserData) {
    ToCpp(settings)->mPerTriangleUserData = perTriangleUserData;
}

bool JPH_MeshShapeSettings_GetPerTriangleUserData(const JPH_MeshShapeSettings *settings) {
    return ToCpp(settings)->mPerTriangleUserData;
}

void JPH_MeshShapeSettings_SetBuildQuality(JPH_MeshShapeSettings *settings, JPH_MeshShapeSettings_EBuildQuality buildQuality) {
    ToCpp(settings)->mBuildQuality = static_cast<JPH::MeshShapeSettings::EBuildQuality>(buildQuality);
}

JPH_MeshShapeSettings_EBuildQuality JPH_MeshShapeSettings_GetBuildQuality(const JPH_MeshShapeSettings *settings) {
    return static_cast<JPH_MeshShapeSettings_EBuildQuality>(ToCpp(settings)->mBuildQuality);
}

JPH_HeightFieldShapeSettings *JPH_HeightFieldShapeSettings_Create() {
    return ToC(new JPH::HeightFieldShapeSettings);
}

void JPH_HeightFieldShapeSettings_Destroy(JPH_HeightFieldShapeSettings *settings) {
    delete ToCpp(settings);
}

CREATE_SHAPE_IMPL(HeightFieldShape);

void JPH_HeightFieldShapeSettings_DetermineMinAndMaxSample(const JPH_HeightFieldShapeSettings *settings, float *outMinValue, float *outMaxValue, float *outQuantizationScale) {
    ToCpp(settings)->DetermineMinAndMaxSample(*outMinValue, *outMaxValue, *outQuantizationScale);
}

uint32_t JPH_HeightFieldShapeSettings_CalculateBitsPerSampleForError(const JPH_HeightFieldShapeSettings *settings, float maxError) {
    return ToCpp(settings)->CalculateBitsPerSampleForError(maxError);
}

void JPH_HeightFieldShapeSettings_AddHeightSample(JPH_HeightFieldShapeSettings *settings, float sample) {
    ToCpp(settings)->mHeightSamples.push_back(sample);
}

void JPH_HeightFieldShapeSettings_AddHeightSamples(JPH_HeightFieldShapeSettings *settings, const float *samples, uint32_t count) {
    auto &arr = ToCpp(settings)->mHeightSamples;
    arr.insert(arr.end(), samples, samples + count);
}

uint32_t JPH_HeightFieldShapeSettings_GetNumHeightSamples(const JPH_HeightFieldShapeSettings *settings) {
    return static_cast<uint32_t>(ToCpp(settings)->mHeightSamples.size());
}

const float *JPH_HeightFieldShapeSettings_GetHeightSamples(const JPH_HeightFieldShapeSettings *settings) {
    return ToCpp(settings)->mHeightSamples.data();
}

void JPH_HeightFieldShapeSettings_AddMaterialIndex(JPH_HeightFieldShapeSettings *settings, uint8_t materialIndex) {
    ToCpp(settings)->mMaterialIndices.push_back(materialIndex);
}

void JPH_HeightFieldShapeSettings_AddMaterialIndices(JPH_HeightFieldShapeSettings *settings, const uint8_t *materialIndices, uint32_t count) {
    auto &arr = ToCpp(settings)->mMaterialIndices;
    arr.insert(arr.end(), materialIndices, materialIndices + count);
}

uint32_t JPH_HeightFieldShapeSettings_GetNumMaterialIndices(const JPH_HeightFieldShapeSettings *settings) {
    return static_cast<uint32_t>(ToCpp(settings)->mMaterialIndices.size());
}

const uint8_t *JPH_HeightFieldShapeSettings_GetMaterialIndices(const JPH_HeightFieldShapeSettings *settings) {
    return ToCpp(settings)->mMaterialIndices.data();
}

void JPH_HeightFieldShapeSettings_AddMaterial(JPH_HeightFieldShapeSettings *settings, const JPH_PhysicsMaterial *material) {
    ToCpp(settings)->mMaterials.push_back(ToCpp(material));
}

void JPH_HeightFieldShapeSettings_AddMaterials(JPH_HeightFieldShapeSettings *settings, const JPH_PhysicsMaterial **materials, uint32_t count) {
    auto &arr = ToCpp(settings)->mMaterials;
    for (uint32_t i = 0; i < count; i++) {
        arr.push_back(ToCpp(materials[i]));
    }
}

uint32_t JPH_HeightFieldShapeSettings_GetNumMaterials(const JPH_HeightFieldShapeSettings *settings) {
    return static_cast<uint32_t>(ToCpp(settings)->mMaterials.size());
}

const JPH_PhysicsMaterial *JPH_HeightFieldShapeSettings_GetMaterial(const JPH_HeightFieldShapeSettings *settings, uint32_t index) {
    return ToC(ToCpp(settings)->mMaterials[index].GetPtr());
}

void JPH_HeightFieldShapeSettings_SetOffset(JPH_HeightFieldShapeSettings *settings, JPH_Vec3 offset) {
    ToCpp(settings)->mOffset = ToCpp(offset);
}

JPH_Vec3 JPH_HeightFieldShapeSettings_GetOffset(const JPH_HeightFieldShapeSettings *settings) {
    return ToC(ToCpp(settings)->mOffset);
}

void JPH_HeightFieldShapeSettings_SetScale(JPH_HeightFieldShapeSettings *settings, JPH_Vec3 scale) {
    ToCpp(settings)->mScale = ToCpp(scale);
}

JPH_Vec3 JPH_HeightFieldShapeSettings_GetScale(const JPH_HeightFieldShapeSettings *settings) {
    return ToC(ToCpp(settings)->mScale);
}

void JPH_HeightFieldShapeSettings_SetSampleCount(JPH_HeightFieldShapeSettings *settings, uint32_t sampleCount) {
    ToCpp(settings)->mSampleCount = sampleCount;
}

uint32_t JPH_HeightFieldShapeSettings_GetSampleCount(const JPH_HeightFieldShapeSettings *settings) {
    return ToCpp(settings)->mSampleCount;
}

void JPH_HeightFieldShapeSettings_SetMinHeightValue(JPH_HeightFieldShapeSettings *settings, float minHeightValue) {
    ToCpp(settings)->mMinHeightValue = minHeightValue;
}

float JPH_HeightFieldShapeSettings_GetMinHeightValue(const JPH_HeightFieldShapeSettings *settings) {
    return ToCpp(settings)->mMinHeightValue;
}

void JPH_HeightFieldShapeSettings_SetMaxHeightValue(JPH_HeightFieldShapeSettings *settings, float maxHeightValue) {
    ToCpp(settings)->mMaxHeightValue = maxHeightValue;
}

float JPH_HeightFieldShapeSettings_GetMaxHeightValue(const JPH_HeightFieldShapeSettings *settings) {
    return ToCpp(settings)->mMaxHeightValue;
}

void JPH_HeightFieldShapeSettings_SetMaterialsCapacity(JPH_HeightFieldShapeSettings *settings, uint32_t materialsCapacity) {
    ToCpp(settings)->mMaterialsCapacity = materialsCapacity;
}

uint32_t JPH_HeightFieldShapeSettings_GetMaterialsCapacity(const JPH_HeightFieldShapeSettings *settings) {
    return ToCpp(settings)->mMaterialsCapacity;
}

void JPH_HeightFieldShapeSettings_SetBlockSize(JPH_HeightFieldShapeSettings *settings, uint32_t blockSize) {
    ToCpp(settings)->mBlockSize = blockSize;
}

uint32_t JPH_HeightFieldShapeSettings_GetBlockSize(const JPH_HeightFieldShapeSettings *settings) {
    return ToCpp(settings)->mBlockSize;
}

void JPH_HeightFieldShapeSettings_SetBitsPerSample(JPH_HeightFieldShapeSettings *settings, uint32_t bitsPerSample) {
    ToCpp(settings)->mBitsPerSample = bitsPerSample;
}

uint32_t JPH_HeightFieldShapeSettings_GetBitsPerSample(const JPH_HeightFieldShapeSettings *settings) {
    return ToCpp(settings)->mBitsPerSample;
}

void JPH_HeightFieldShapeSettings_SetActiveEdgeCosThresholdAngle(JPH_HeightFieldShapeSettings *settings, float activeEdgeCosThresholdAngle) {
    ToCpp(settings)->mActiveEdgeCosThresholdAngle = activeEdgeCosThresholdAngle;
}

float JPH_HeightFieldShapeSettings_GetActiveEdgeCosThresholdAngle(const JPH_HeightFieldShapeSettings *settings) {
    return ToCpp(settings)->mActiveEdgeCosThresholdAngle;
}

static inline JPH::MassProperties ToCpp(JPH_MassProperties v) {
    return *reinterpret_cast<JPH::MassProperties *>(&v);
}

static inline JPH_MassProperties ToC(JPH::MassProperties v) {
    return *reinterpret_cast<JPH_MassProperties *>(&v);
}

JPH_Vec3 JPH_MassProperties_GetEquivalentSolidBoxSize(float mass, JPH_Vec3 inertiaDiagonal) {
    return ToC(JPH::MassProperties::sGetEquivalentSolidBoxSize(mass, ToCpp(inertiaDiagonal)));
}

bool JPH_MassProperties_DecomposePrincipalMomentsOfInertia(JPH_MassProperties *massProperties, JPH_Mat44 *outRotation, JPH_Vec3 *outDiagonal) {
    return reinterpret_cast<JPH::MassProperties *>(massProperties)->DecomposePrincipalMomentsOfInertia(*reinterpret_cast<JPH::Mat44 *>(outRotation), *reinterpret_cast<JPH::Vec3 *>(outDiagonal));
}

void JPH_MassProperties_SetMassAndInertiaOfSolidBox(JPH_MassProperties *massProperties, JPH_Vec3 boxSize, float density) {
    reinterpret_cast<JPH::MassProperties *>(massProperties)->SetMassAndInertiaOfSolidBox(ToCpp(boxSize), density);
}

void JPH_MassProperties_ScaleToMass(JPH_MassProperties *massProperties, float mass) {
    reinterpret_cast<JPH::MassProperties *>(massProperties)->ScaleToMass(mass);
}

void JPH_MassProperties_Rotate(JPH_MassProperties *massProperties, JPH_Mat44 rotation) {
    reinterpret_cast<JPH::MassProperties *>(massProperties)->Rotate(ToCpp(rotation));
}

void JPH_MassProperties_Translate(JPH_MassProperties *massProperties, JPH_Vec3 translation) {
    reinterpret_cast<JPH::MassProperties *>(massProperties)->Translate(ToCpp(translation));
}

void JPH_MassProperties_Scale(JPH_MassProperties *massProperties, JPH_Vec3 scale) {
    reinterpret_cast<JPH::MassProperties *>(massProperties)->Scale(ToCpp(scale));
}

void JPH_Shape_AddRef(JPH_Shape *shape) {
    ToCpp(shape)->AddRef();
}

void JPH_Shape_Release(JPH_Shape *shape) {
    ToCpp(shape)->Release();
}

JPH_Shape_EShapeType JPH_Shape_GetType(const JPH_Shape *shape) {
    return static_cast<JPH_Shape_EShapeType>(ToCpp(shape)->GetType());
}

JPH_Shape_EShapeSubType JPH_Shape_GetSubType(const JPH_Shape *shape) {
    return static_cast<JPH_Shape_EShapeSubType>(ToCpp(shape)->GetSubType());
}

uint64_t JPH_Shape_GetUserData(const JPH_Shape *shape) {
    return ToCpp(shape)->GetUserData();
}

void JPH_Shape_SetUserData(JPH_Shape *shape, uint64_t userData) {
    ToCpp(shape)->SetUserData(userData);
}

bool JPH_Shape_MustBeStatic(const JPH_Shape *shape) {
    return ToCpp(shape)->MustBeStatic();
}

JPH_Vec3 JPH_Shape_GetCenterOfMass(const JPH_Shape *shape) {
    return ToC(ToCpp(shape)->GetCenterOfMass());
}

JPH_AABox JPH_Shape_GetLocalBounds(const JPH_Shape *shape) {
    return ToC(ToCpp(shape)->GetLocalBounds());
}

uint32_t JPH_Shape_GetSubShapeIDBitsRecursive(const JPH_Shape *shape) {
    return ToCpp(shape)->GetSubShapeIDBitsRecursive();
}

JPH_AABox JPH_Shape_GetWorldSpaceBounds(const JPH_Shape *shape, JPH_Mat44 centerOfMassTransform, JPH_Vec3 scale) {
    return ToC(ToCpp(shape)->GetWorldSpaceBounds(ToCpp(centerOfMassTransform), ToCpp(scale)));
}

float JPH_Shape_GetInnerRadius(const JPH_Shape *shape) {
    return ToCpp(shape)->GetInnerRadius();
}

JPH_MassProperties JPH_Shape_GetMassProperties(const JPH_Shape *shape) {
    return ToC(ToCpp(shape)->GetMassProperties());
}

const JPH_Shape *JPH_Shape_GetLeafShape(const JPH_Shape *shape, JPH_SubShapeID subShapeID, JPH_SubShapeID *outRemainder) {
    JPH::SubShapeID remainder;
    const JPH::Shape *result = ToCpp(shape)->GetLeafShape(*reinterpret_cast<JPH::SubShapeID *>(&subShapeID), remainder);
    *outRemainder = *reinterpret_cast<JPH_SubShapeID *>(&remainder);
    return ToC(result);
}

const JPH_PhysicsMaterial *JPH_Shape_GetMaterial(const JPH_Shape *shape, JPH_SubShapeID subShapeID) {
    return ToC(ToCpp(shape)->GetMaterial(*reinterpret_cast<JPH::SubShapeID *>(&subShapeID)));
}

JPH_Vec3 JPH_Shape_GetSurfaceNormal(const JPH_Shape *shape, JPH_SubShapeID subShapeID, JPH_Vec3 localSurfacePosition) {
    return ToC(ToCpp(shape)->GetSurfaceNormal(*reinterpret_cast<JPH::SubShapeID *>(&subShapeID), ToCpp(localSurfacePosition)));
}

void JPH_Shape_GetSupportingFace(const JPH_Shape *shape, JPH_SubShapeID subShapeID, JPH_Vec3 direction, JPH_Vec3 scale, JPH_Mat44 centerOfMassTransform, JPH_SupportingFace *outVertices) {
    ToCpp(shape)->GetSupportingFace(*reinterpret_cast<JPH::SubShapeID *>(&subShapeID), ToCpp(direction), ToCpp(scale), ToCpp(centerOfMassTransform), *reinterpret_cast<JPH::Shape::SupportingFace *>(outVertices));
}

uint64_t JPH_Shape_GetSubShapeUserData(const JPH_Shape *shape, JPH_SubShapeID subShapeID) {
    return ToCpp(shape)->GetSubShapeUserData(*reinterpret_cast<JPH::SubShapeID *>(&subShapeID));
}

void JPH_Shape_GetSubmergedVolume(const JPH_Shape *shape, JPH_Mat44 centerOfMassTransform, JPH_Vec3 scale, JPH_Plane surface, float *outTotalVolume, float *outSubmergedVolume, JPH_Vec3 *outCenterOfBuoyancy) {
#ifdef JPH_DEBUG_RENDERER
    ToCpp(shape)->GetSubmergedVolume(ToCpp(centerOfMassTransform), ToCpp(scale), ToCpp(surface), *outTotalVolume, *outSubmergedVolume, *reinterpret_cast<JPH::Vec3 *>(outCenterOfBuoyancy), JPH::RVec3(JPH::Vec3::sZero()));
#else
    ToCpp(shape)->GetSubmergedVolume(ToCpp(centerOfMassTransform), ToCpp(scale), ToCpp(surface), *outTotalVolume, *outSubmergedVolume, *reinterpret_cast<JPH::Vec3 *>(outCenterOfBuoyancy));
#endif
}

JPH_Shape *JPH_Shape_ScaleShape(const JPH_Shape *shape, JPH_Vec3 scale) {
    auto result = ToCpp(shape)->ScaleShape(ToCpp(scale));
    if (!result.IsValid()) {
        return nullptr;
    }

    auto scaledShape = result.Get().GetPtr();
    scaledShape->AddRef();

    return ToC(scaledShape);
}

void JPH_Shape_GetTrianglesStart(const JPH_Shape *shape, JPH_Shape_GetTrianglesContext *ioContext, JPH_AABox box, JPH_Vec3 positionCOM, JPH_Quat rotation, JPH_Vec3 scale) {
    ToCpp(shape)->GetTrianglesStart(*reinterpret_cast<JPH::Shape::GetTrianglesContext *>(ioContext), ToCpp(box), ToCpp(positionCOM), ToCpp(rotation), ToCpp(scale));
}

uint32_t JPH_Shape_GetTrianglesNext(const JPH_Shape *shape, JPH_Shape_GetTrianglesContext *ioContext, uint32_t maxTrianglesRequested, JPH_Float3 *outTriangleVertices, const JPH_PhysicsMaterial **outMaterials) {
    return static_cast<uint32_t>(ToCpp(shape)->GetTrianglesNext(*reinterpret_cast<JPH::Shape::GetTrianglesContext *>(ioContext), static_cast<int>(maxTrianglesRequested), reinterpret_cast<JPH::Float3 *>(outTriangleVertices), reinterpret_cast<const JPH::PhysicsMaterial **>(outMaterials)));
}

JPH_Shape_Stats JPH_Shape_GetStats(const JPH_Shape *shape) {
    auto stats = ToCpp(shape)->GetStats();
    return *reinterpret_cast<JPH_Shape_Stats *>(&stats);
}

float JPH_Shape_GetVolume(const JPH_Shape *shape) {
    return ToCpp(shape)->GetVolume();
}

bool JPH_Shape_IsValidScale(const JPH_Shape *shape, JPH_Vec3 scale) {
    return ToCpp(shape)->IsValidScale(ToCpp(scale));
}

JPH_Vec3 JPH_Shape_MakeScaleValid(const JPH_Shape *shape, JPH_Vec3 scale) {
    return ToC(ToCpp(shape)->MakeScaleValid(ToCpp(scale)));
}

// Body

static inline JPH::BodyCreationSettings *ToCpp(JPH_BodyCreationSettings *settings) {
    return reinterpret_cast<JPH::BodyCreationSettings *>(settings);
}

static inline const JPH::BodyCreationSettings *ToCpp(const JPH_BodyCreationSettings *settings) {
    return reinterpret_cast<const JPH::BodyCreationSettings *>(settings);
}

void JPH_BodyCreationSettings_SetDefaults(JPH_BodyCreationSettings *settings) {
    *ToCpp(settings) = JPH::BodyCreationSettings();
}

JPH_Shape *JPH_BodyCreationSettings_ConvertShapeSettings(JPH_BodyCreationSettings *settings) {
    auto result = ToCpp(settings)->ConvertShapeSettings();
    if (!result.IsValid()) {
        return nullptr;
    }

    auto shape = result.Get().GetPtr();
    if (shape) {
        shape->AddRef();
    }

    return ToC(shape);
}

bool JPH_BodyCreationSettings_HasMassProperties(const JPH_BodyCreationSettings *settings) {
    return ToCpp(settings)->HasMassProperties();
}

JPH_MassProperties JPH_BodyCreationSettings_GetMassProperties(const JPH_BodyCreationSettings *settings) {
    return ToC(ToCpp(settings)->GetMassProperties());
}

static inline JPH::SoftBodyCreationSettings *ToCpp(JPH_SoftBodyCreationSettings *settings) {
    return reinterpret_cast<JPH::SoftBodyCreationSettings *>(settings);
}

static inline const JPH::SoftBodyCreationSettings *ToCpp(const JPH_SoftBodyCreationSettings *settings) {
    return reinterpret_cast<const JPH::SoftBodyCreationSettings *>(settings);
}

JOLTC_API void JPH_SoftBodyCreationSettings_SetDefaults(JPH_SoftBodyCreationSettings *settings) {
    *ToCpp(settings) = JPH::SoftBodyCreationSettings();
}

// BodyInterface

JPH_Body *JPH_BodyInterface_CreateBody(JPH_BodyInterface *bodyInterface, const JPH_BodyCreationSettings *settings) {
    return ToC(ToCpp(bodyInterface)->CreateBody(*ToCpp(settings)));
}

JPH_Body *JPH_BodyInterface_CreateSoftBody(JPH_BodyInterface *bodyInterface, const JPH_SoftBodyCreationSettings *settings) {
    return ToC(ToCpp(bodyInterface)->CreateSoftBody(*ToCpp(settings)));
}

JPH_Body *JPH_BodyInterface_CreateBodyWithID(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, const JPH_BodyCreationSettings *settings) {
    return ToC(ToCpp(bodyInterface)->CreateBodyWithID(JPH::BodyID(bodyID), *ToCpp(settings)));
}

JPH_Body *JPH_BodyInterface_CreateSoftBodyWithID(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, const JPH_SoftBodyCreationSettings *settings) {
    return ToC(ToCpp(bodyInterface)->CreateSoftBodyWithID(JPH::BodyID(bodyID), *ToCpp(settings)));
}

JPH_Body *JPH_BodyInterface_CreateBodyWithoutID(const JPH_BodyInterface *bodyInterface, const JPH_BodyCreationSettings *settings) {
    return ToC(ToCpp(bodyInterface)->CreateBodyWithoutID(*ToCpp(settings)));
}

JPH_Body *JPH_BodyInterface_CreateSoftBodyWithoutID(const JPH_BodyInterface *bodyInterface, const JPH_SoftBodyCreationSettings *settings) {
    return ToC(ToCpp(bodyInterface)->CreateSoftBodyWithoutID(*ToCpp(settings)));
}

void JPH_BodyInterface_DestroyBodyWithoutID(const JPH_BodyInterface *bodyInterface, JPH_Body *body) {
    ToCpp(bodyInterface)->DestroyBodyWithoutID(ToCpp(body));
}

bool JPH_BodyInterface_AssignBodyID(JPH_BodyInterface *bodyInterface, JPH_Body *ioBody) {
    return ToCpp(bodyInterface)->AssignBodyID(ToCpp(ioBody));
}

bool JPH_BodyInterface_SetBodyID(JPH_BodyInterface *bodyInterface, JPH_Body *ioBody, JPH_BodyID bodyID) {
    return ToCpp(bodyInterface)->AssignBodyID(ToCpp(ioBody), JPH::BodyID(bodyID));
}

JPH_Body *JPH_BodyInterface_UnassignBodyID(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToC(ToCpp(bodyInterface)->UnassignBodyID(JPH::BodyID(bodyID)));
}

void JPH_BodyInterface_UnassignBodyIDs(JPH_BodyInterface *bodyInterface, const JPH_BodyID *bodyIDs, int count, JPH_Body **outBodies) {
    ToCpp(bodyInterface)->UnassignBodyIDs(reinterpret_cast<const JPH::BodyID *>(bodyIDs), count, reinterpret_cast<JPH::Body **>(outBodies));
}

void JPH_BodyInterface_DestroyBody(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    ToCpp(bodyInterface)->DestroyBody(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_DestroyBodies(JPH_BodyInterface *bodyInterface, const JPH_BodyID *bodyIDs, int count) {
    ToCpp(bodyInterface)->DestroyBodies(reinterpret_cast<const JPH::BodyID *>(bodyIDs), count);
}

void JPH_BodyInterface_AddBody(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->AddBody(JPH::BodyID(bodyID), static_cast<JPH::EActivation>(activationMode));
}

void JPH_BodyInterface_RemoveBody(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    ToCpp(bodyInterface)->RemoveBody(JPH::BodyID(bodyID));
}

bool JPH_BodyInterface_IsAdded(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToCpp(bodyInterface)->IsAdded(JPH::BodyID(bodyID));
}

JPH_BodyID JPH_BodyInterface_CreateAndAddBody(JPH_BodyInterface *bodyInterface, const JPH_BodyCreationSettings *settings, JPH_EActivation activationMode) {
    return ToCpp(bodyInterface)->CreateAndAddBody(*ToCpp(settings), static_cast<JPH::EActivation>(activationMode)).GetIndexAndSequenceNumber();
}

JPH_BodyID JPH_BodyInterface_CreateAndAddSoftBody(JPH_BodyInterface *bodyInterface, const JPH_SoftBodyCreationSettings *settings, JPH_EActivation activationMode) {
    return ToCpp(bodyInterface)->CreateAndAddSoftBody(*ToCpp(settings), static_cast<JPH::EActivation>(activationMode)).GetIndexAndSequenceNumber();
}

void JPH_BodyInterface_MoveKinematic(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 targetPosition, JPH_Quat targetRotation, float deltaTime) {
    ToCpp(bodyInterface)->MoveKinematic(JPH::BodyID(bodyID), ToCpp(targetPosition), ToCpp(targetRotation), deltaTime);
}

void JPH_BodyInterface_SetLinearAndAngularVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 linearVelocity, JPH_Vec3 angularVelocity) {
    ToCpp(bodyInterface)->SetLinearAndAngularVelocity(JPH::BodyID(bodyID), ToCpp(linearVelocity), ToCpp(angularVelocity));
}

void JPH_BodyInterface_GetLinearAndAngularVelocity(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 *outLinearVelocity, JPH_Vec3 *outAngularVelocity) {
    ToCpp(bodyInterface)->GetLinearAndAngularVelocity(JPH::BodyID(bodyID), *reinterpret_cast<JPH::Vec3 *>(outLinearVelocity), *reinterpret_cast<JPH::Vec3 *>(outAngularVelocity));
}

void JPH_BodyInterface_SetLinearVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 linearVelocity) {
    ToCpp(bodyInterface)->SetLinearVelocity(JPH::BodyID(bodyID), ToCpp(linearVelocity));
}

JPH_Vec3 JPH_BodyInterface_GetLinearVelocity(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToC(ToCpp(bodyInterface)->GetLinearVelocity(JPH::BodyID(bodyID)));
}

void JPH_BodyInterface_AddLinearVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 linearVelocity) {
    ToCpp(bodyInterface)->AddLinearVelocity(JPH::BodyID(bodyID), ToCpp(linearVelocity));
}

void JPH_BodyInterface_AddLinearAndAngularVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 linearVelocity, JPH_Vec3 angularVelocity) {
    ToCpp(bodyInterface)->AddLinearAndAngularVelocity(JPH::BodyID(bodyID), ToCpp(linearVelocity), ToCpp(angularVelocity));
}

void JPH_BodyInterface_SetAngularVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 angularVelocity) {
    ToCpp(bodyInterface)->SetAngularVelocity(JPH::BodyID(bodyID), ToCpp(angularVelocity));
}

JPH_Vec3 JPH_BodyInterface_GetAngularVelocity(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToC(ToCpp(bodyInterface)->GetAngularVelocity(JPH::BodyID(bodyID)));
}

JPH_Vec3 JPH_BodyInterface_GetPointVelocity(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 point) {
    return ToC(ToCpp(bodyInterface)->GetPointVelocity(JPH::BodyID(bodyID), ToCpp(point)));
}

void JPH_BodyInterface_SetPositionRotationAndVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 position, JPH_Quat rotation, JPH_Vec3 linearVelocity, JPH_Vec3 angularVelocity) {
    ToCpp(bodyInterface)->SetPositionRotationAndVelocity(JPH::BodyID(bodyID), ToCpp(position), ToCpp(rotation), ToCpp(linearVelocity), ToCpp(angularVelocity));
}

JPH_Mat44 JPH_BodyInterface_GetInverseInertia(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToC(ToCpp(bodyInterface)->GetInverseInertia(JPH::BodyID(bodyID)));
}

uint64_t JPH_BodyInterface_GetUserData(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToCpp(bodyInterface)->GetUserData(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_SetUserData(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, uint64_t userData) {
    ToCpp(bodyInterface)->SetUserData(JPH::BodyID(bodyID), userData);
}

const JPH_PhysicsMaterial *JPH_BodyInterface_GetMaterial(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_SubShapeID subShapeID) {
    return ToC(ToCpp(bodyInterface)->GetMaterial(JPH::BodyID(bodyID), *reinterpret_cast<JPH::SubShapeID *>(&subShapeID)));
}

void JPH_BodyInterface_InvalidateContactCache(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    ToCpp(bodyInterface)->InvalidateContactCache(JPH::BodyID(bodyID));
}

void *JPH_BodyInterface_AddBodiesPrepare(JPH_BodyInterface *bodyInterface, JPH_BodyID *ioBodies, int count) {
    return ToCpp(bodyInterface)->AddBodiesPrepare(reinterpret_cast<JPH::BodyID *>(ioBodies), count);
}

void JPH_BodyInterface_AddBodiesFinalize(JPH_BodyInterface *bodyInterface, JPH_BodyID *ioBodies, int count, void *addState, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->AddBodiesFinalize(reinterpret_cast<JPH::BodyID *>(ioBodies), count, addState, static_cast<JPH::EActivation>(activationMode));
}

void JPH_BodyInterface_AddBodiesAbort(JPH_BodyInterface *bodyInterface, JPH_BodyID *ioBodies, int count, void *addState) {
    ToCpp(bodyInterface)->AddBodiesAbort(reinterpret_cast<JPH::BodyID *>(ioBodies), count, addState);
}

void JPH_BodyInterface_RemoveBodies(JPH_BodyInterface *bodyInterface, JPH_BodyID *ioBodies, int count) {
    ToCpp(bodyInterface)->RemoveBodies(reinterpret_cast<JPH::BodyID *>(ioBodies), count);
}

void JPH_BodyInterface_ActivateBody(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    ToCpp(bodyInterface)->ActivateBody(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_ActivateBodies(JPH_BodyInterface *bodyInterface, const JPH_BodyID *bodyIDs, int count) {
    ToCpp(bodyInterface)->ActivateBodies(reinterpret_cast<const JPH::BodyID *>(bodyIDs), count);
}

void JPH_BodyInterface_ActivateBodiesInAABox(JPH_BodyInterface *bodyInterface, JPH_AABox inBox, const JPH_BroadPhaseLayerFilter *broadPhaseLayerFilter, const JPH_ObjectLayerFilter *objectLayerFilter) {
    ToCpp(bodyInterface)->ActivateBodiesInAABox(ToCpp(inBox), *ToCpp(broadPhaseLayerFilter), *ToCpp(objectLayerFilter));
}

void JPH_BodyInterface_DeactivateBody(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    ToCpp(bodyInterface)->DeactivateBody(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_DeactivateBodies(JPH_BodyInterface *bodyInterface, const JPH_BodyID *bodyIDs, int count) {
    ToCpp(bodyInterface)->DeactivateBodies(reinterpret_cast<const JPH::BodyID *>(bodyIDs), count);
}

bool JPH_BodyInterface_IsActive(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToCpp(bodyInterface)->IsActive(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_ResetSleepTimer(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    ToCpp(bodyInterface)->ResetSleepTimer(JPH::BodyID(bodyID));
}

const JPH_Shape *JPH_BodyInterface_GetShape(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    auto ref = ToCpp(bodyInterface)->GetShape(JPH::BodyID(bodyID));

    auto shape = ref.GetPtr();
    if (shape) {
        shape->AddRef();
    }

    return ToC(shape);
}

void JPH_BodyInterface_SetShape(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, const JPH_Shape *shape, bool updateMassProperties, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->SetShape(JPH::BodyID(bodyID), ToCpp(shape), updateMassProperties, static_cast<JPH::EActivation>(activationMode));
}

void JPH_BodyInterface_NotifyShapeChanged(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 inPreviousCenterOfMass, bool updateMassProperties, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->NotifyShapeChanged(JPH::BodyID(bodyID), ToCpp(inPreviousCenterOfMass), updateMassProperties, static_cast<JPH::EActivation>(activationMode));
}

void JPH_BodyInterface_SetObjectLayer(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_ObjectLayer layer) {
    ToCpp(bodyInterface)->SetObjectLayer(JPH::BodyID(bodyID), layer);
}

JPH_ObjectLayer JPH_BodyInterface_GetObjectLayer(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToCpp(bodyInterface)->GetObjectLayer(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_SetPositionAndRotation(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 position, JPH_Quat rotation, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->SetPositionAndRotation(JPH::BodyID(bodyID), ToCpp(position), ToCpp(rotation), static_cast<JPH::EActivation>(activationMode));
}

void JPH_BodyInterface_SetPositionAndRotationWhenChanged(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 position, JPH_Quat rotation, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->SetPositionAndRotationWhenChanged(JPH::BodyID(bodyID), ToCpp(position), ToCpp(rotation), static_cast<JPH::EActivation>(activationMode));
}

void JPH_BodyInterface_GetPositionAndRotation(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 *outPosition, JPH_Quat *outRotation) {
    ToCpp(bodyInterface)->GetPositionAndRotation(JPH::BodyID(bodyID), *reinterpret_cast<JPH::RVec3 *>(outPosition), *reinterpret_cast<JPH::Quat *>(outRotation));
}

void JPH_BodyInterface_SetPosition(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 position, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->SetPosition(JPH::BodyID(bodyID), ToCpp(position), static_cast<JPH::EActivation>(activationMode));
}

JPH_RVec3 JPH_BodyInterface_GetPosition(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToC(ToCpp(bodyInterface)->GetPosition(JPH::BodyID(bodyID)));
}

JPH_RVec3 JPH_BodyInterface_GetCenterOfMassPosition(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToC(ToCpp(bodyInterface)->GetCenterOfMassPosition(JPH::BodyID(bodyID)));
}

void JPH_BodyInterface_SetRotation(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Quat rotation, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->SetRotation(JPH::BodyID(bodyID), ToCpp(rotation), static_cast<JPH::EActivation>(activationMode));
}

JPH_Quat JPH_BodyInterface_GetRotation(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToC(ToCpp(bodyInterface)->GetRotation(JPH::BodyID(bodyID)));
}

JPH_RMat44 JPH_BodyInterface_GetWorldTransform(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToC(ToCpp(bodyInterface)->GetWorldTransform(JPH::BodyID(bodyID)));
}

JPH_RMat44 JPH_BodyInterface_GetCenterOfMassTransform(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToC(ToCpp(bodyInterface)->GetCenterOfMassTransform(JPH::BodyID(bodyID)));
}

void JPH_BodyInterface_AddForce(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 force, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->AddForce(JPH::BodyID(bodyID), ToCpp(force), static_cast<JPH::EActivation>(activationMode));
}

void JPH_BodyInterface_AddForceAtPoint(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 force, JPH_RVec3 point, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->AddForce(JPH::BodyID(bodyID), ToCpp(force), ToCpp(point), static_cast<JPH::EActivation>(activationMode));
}

void JPH_BodyInterface_AddTorque(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 torque, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->AddTorque(JPH::BodyID(bodyID), ToCpp(torque), static_cast<JPH::EActivation>(activationMode));
}

void JPH_BodyInterface_AddForceAndTorque(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 force, JPH_Vec3 torque, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->AddForceAndTorque(JPH::BodyID(bodyID), ToCpp(force), ToCpp(torque), static_cast<JPH::EActivation>(activationMode));
}

void JPH_BodyInterface_AddImpulse(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 impulse) {
    ToCpp(bodyInterface)->AddImpulse(JPH::BodyID(bodyID), ToCpp(impulse));
}

void JPH_BodyInterface_AddImpulseAtPoint(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 impulse, JPH_RVec3 point) {
    ToCpp(bodyInterface)->AddImpulse(JPH::BodyID(bodyID), ToCpp(impulse), ToCpp(point));
}

void JPH_BodyInterface_AddAngularImpulse(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_Vec3 angularImpulse) {
    ToCpp(bodyInterface)->AddAngularImpulse(JPH::BodyID(bodyID), ToCpp(angularImpulse));
}

bool JPH_BodyInterface_ApplyBuoyancyImpulse(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_RVec3 surfacePosition, JPH_Vec3 surfaceNormal, float buoyancy, float linearDrag, float angularDrag, JPH_Vec3 fluidVelocity, JPH_Vec3 gravity, float deltaTime) {
    return ToCpp(bodyInterface)->ApplyBuoyancyImpulse(JPH::BodyID(bodyID), ToCpp(surfacePosition), ToCpp(surfaceNormal), buoyancy, linearDrag, angularDrag, ToCpp(fluidVelocity), ToCpp(gravity), deltaTime);
}

JPH_EBodyType JPH_BodyInterface_GetBodyType(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return static_cast<JPH_EBodyType>(ToCpp(bodyInterface)->GetBodyType(JPH::BodyID(bodyID)));
}

void JPH_BodyInterface_SetMotionType(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_EMotionType motionType, JPH_EActivation activationMode) {
    ToCpp(bodyInterface)->SetMotionType(JPH::BodyID(bodyID), static_cast<JPH::EMotionType>(motionType), static_cast<JPH::EActivation>(activationMode));
}

JPH_EMotionType JPH_BodyInterface_GetMotionType(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return static_cast<JPH_EMotionType>(ToCpp(bodyInterface)->GetMotionType(JPH::BodyID(bodyID)));
}

void JPH_BodyInterface_SetMotionQuality(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, JPH_EMotionQuality motionQuality) {
    ToCpp(bodyInterface)->SetMotionQuality(JPH::BodyID(bodyID), static_cast<JPH::EMotionQuality>(motionQuality));
}

JPH_EMotionQuality JPH_BodyInterface_GetMotionQuality(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return static_cast<JPH_EMotionQuality>(ToCpp(bodyInterface)->GetMotionQuality(JPH::BodyID(bodyID)));
}

void JPH_BodyInterface_SetRestitution(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, float restitution) {
    ToCpp(bodyInterface)->SetRestitution(JPH::BodyID(bodyID), restitution);
}

float JPH_BodyInterface_GetRestitution(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToCpp(bodyInterface)->GetRestitution(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_SetFriction(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, float friction) {
    ToCpp(bodyInterface)->SetFriction(JPH::BodyID(bodyID), friction);
}

float JPH_BodyInterface_GetFriction(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToCpp(bodyInterface)->GetFriction(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_SetGravityFactor(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, float gravityFactor) {
    ToCpp(bodyInterface)->SetGravityFactor(JPH::BodyID(bodyID), gravityFactor);
}

float JPH_BodyInterface_GetGravityFactor(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToCpp(bodyInterface)->GetGravityFactor(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_SetMaxLinearVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, float linearVelocity) {
    ToCpp(bodyInterface)->SetMaxLinearVelocity(JPH::BodyID(bodyID), linearVelocity);
}

float JPH_BodyInterface_GetMaxLinearVelocity(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToCpp(bodyInterface)->GetMaxLinearVelocity(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_SetMaxAngularVelocity(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, float angularVelocity) {
    ToCpp(bodyInterface)->SetMaxAngularVelocity(JPH::BodyID(bodyID), angularVelocity);
}

float JPH_BodyInterface_GetMaxAngularVelocity(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToCpp(bodyInterface)->GetMaxAngularVelocity(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_SetUseManifoldReduction(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, bool useReduction) {
    ToCpp(bodyInterface)->SetUseManifoldReduction(JPH::BodyID(bodyID), useReduction);
}

bool JPH_BodyInterface_GetUseManifoldReduction(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToCpp(bodyInterface)->GetUseManifoldReduction(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_SetIsSensor(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, bool isSensor) {
    ToCpp(bodyInterface)->SetIsSensor(JPH::BodyID(bodyID), isSensor);
}

bool JPH_BodyInterface_IsSensor(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return ToCpp(bodyInterface)->IsSensor(JPH::BodyID(bodyID));
}

void JPH_BodyInterface_SetCollisionGroup(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID, const JPH_CollisionGroup *collisionGroup) {
    ToCpp(bodyInterface)->SetCollisionGroup(JPH::BodyID(bodyID), *reinterpret_cast<const JPH::CollisionGroup *>(collisionGroup));
}

const JPH_CollisionGroup *JPH_BodyInterface_GetCollisionGroup(const JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID) {
    return reinterpret_cast<const JPH_CollisionGroup *>(&ToCpp(bodyInterface)->GetCollisionGroup(JPH::BodyID(bodyID)));
}

// BodyLockInterface

JPH_Body *JPH_BodyLockInterface_TryGetBody(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyID bodyID) {
    return ToC(ToCpp(bodyLockInterface)->TryGetBody(JPH::BodyID(bodyID)));
}

void JPH_BodyLockInterface_LockRead(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyID bodyID, JPH_BodyLockRead *outLock) {
    if (bodyID == JPH_cInvalidBodyID) {
        outLock->bodyLockMutex = nullptr;
        outLock->body = nullptr;
    } else {
        outLock->bodyLockMutex = ToC(ToCpp(bodyLockInterface)->LockRead(JPH::BodyID(bodyID)));
        outLock->body = ToC(ToCpp(bodyLockInterface)->TryGetBody(JPH::BodyID(bodyID)));
    }
}

void JPH_BodyLockInterface_UnlockRead(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyLockRead *outLock) {
    if (outLock->bodyLockMutex) {
        ToCpp(bodyLockInterface)->UnlockRead(ToCpp(outLock->bodyLockMutex));

        outLock->bodyLockMutex = nullptr;
        outLock->body = nullptr;
    }
}

void JPH_BodyLockInterface_LockWrite(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyID bodyID, JPH_BodyLockWrite *outLock) {
    if (bodyID == JPH_cInvalidBodyID) {
        outLock->bodyLockMutex = nullptr;
        outLock->body = nullptr;
    } else {
        outLock->bodyLockMutex = ToC(ToCpp(bodyLockInterface)->LockWrite(JPH::BodyID(bodyID)));
        outLock->body = ToC(ToCpp(bodyLockInterface)->TryGetBody(JPH::BodyID(bodyID)));
    }
}

void JPH_BodyLockInterface_UnlockWrite(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyLockWrite *outLock) {
    if (outLock->bodyLockMutex) {
        ToCpp(bodyLockInterface)->UnlockWrite(ToCpp(outLock->bodyLockMutex));

        outLock->bodyLockMutex = nullptr;
        outLock->body = nullptr;
    }
}

void JPH_BodyLockInterface_LockReadMulti(const JPH_BodyLockInterface *bodyLockInterface, const JPH_BodyID *bodyIDs, int numBodies, JPH_BodyLockMultiRead *outLock) {
    outLock->mutexMask = ToCpp(bodyLockInterface)->GetMutexMask(reinterpret_cast<const JPH::BodyID *>(bodyIDs), numBodies);

    if (outLock->mutexMask != 0) {
        outLock->bodyIDs = bodyIDs;
        outLock->numBodies = numBodies;

        ToCpp(bodyLockInterface)->LockRead(outLock->mutexMask);
    }
}

void JPH_BodyLockInterface_UnlockReadMulti(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyLockMultiRead *outLock) {
    if (outLock->mutexMask != 0) {
        ToCpp(bodyLockInterface)->UnlockRead(outLock->mutexMask);

        outLock->mutexMask = 0;
        outLock->bodyIDs = nullptr;
        outLock->numBodies = 0;
    }
}

void JPH_BodyLockInterface_LockWriteMulti(const JPH_BodyLockInterface *bodyLockInterface, const JPH_BodyID *bodyIDs, int numBodies, JPH_BodyLockMultiWrite *outLock) {
    outLock->mutexMask = ToCpp(bodyLockInterface)->GetMutexMask(reinterpret_cast<const JPH::BodyID *>(bodyIDs), numBodies);

    if (outLock->mutexMask != 0) {
        outLock->bodyIDs = bodyIDs;
        outLock->numBodies = numBodies;

        ToCpp(bodyLockInterface)->LockWrite(outLock->mutexMask);
    }
}

void JPH_BodyLockInterface_UnlockWriteMulti(const JPH_BodyLockInterface *bodyLockInterface, JPH_BodyLockMultiWrite *outLock) {
    if (outLock->mutexMask != 0) {
        ToCpp(bodyLockInterface)->UnlockWrite(outLock->mutexMask);

        outLock->mutexMask = 0;
        outLock->bodyIDs = nullptr;
        outLock->numBodies = 0;
    }
}

const JPH_Body *JPH_BodyLockMultiRead_GetBody(const JPH_BodyLockMultiRead *lock, const JPH_BodyLockInterface *bodyLockInterface, int bodyIndex) {
    if (bodyIndex < 0 || bodyIndex >= lock->numBodies) {
        return nullptr;
    }

    return JPH_BodyLockInterface_TryGetBody(bodyLockInterface, lock->bodyIDs[bodyIndex]);
}

JPH_Body *JPH_BodyLockMultiWrite_GetBody(const JPH_BodyLockMultiWrite *lock, const JPH_BodyLockInterface *bodyLockInterface, int bodyIndex) {
    if (bodyIndex < 0 || bodyIndex >= lock->numBodies) {
        return nullptr;
    }

    return JPH_BodyLockInterface_TryGetBody(bodyLockInterface, lock->bodyIDs[bodyIndex]);
}

void JPH_BodyLockInterface_LockReadAll(const JPH_BodyLockInterface *bodyLockInterface) {
    auto allMask = ToCpp(bodyLockInterface)->GetAllBodiesMutexMask();
    if (allMask != 0) {
        ToCpp(bodyLockInterface)->LockRead(allMask);
    }
}

void JPH_BodyLockInterface_UnlockReadAll(const JPH_BodyLockInterface *bodyLockInterface) {
    auto allMask = ToCpp(bodyLockInterface)->GetAllBodiesMutexMask();
    if (allMask != 0) {
        ToCpp(bodyLockInterface)->UnlockRead(allMask);
    }
}

void JPH_BodyLockInterface_LockWriteAll(const JPH_BodyLockInterface *bodyLockInterface) {
    auto allMask = ToCpp(bodyLockInterface)->GetAllBodiesMutexMask();
    if (allMask != 0) {
        ToCpp(bodyLockInterface)->LockWrite(allMask);
    }
}

void JPH_BodyLockInterface_UnlockWriteAll(const JPH_BodyLockInterface *bodyLockInterface) {
    auto allMask = ToCpp(bodyLockInterface)->GetAllBodiesMutexMask();
    if (allMask != 0) {
        ToCpp(bodyLockInterface)->UnlockWrite(allMask);
    }
}

