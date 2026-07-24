#include <JoltC.h>

#include <Jolt/Core/Core.h>

#include <Jolt/Jolt.h>
#include <Jolt/RegisterTypes.h>
#include <Jolt/Core/Factory.h>
#include <Jolt/Core/TempAllocator.h>
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

#define DEFINE_CONVERSION_FUNCTIONS(c_type, cpp_type) \
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

DEFINE_CONVERSION_FUNCTIONS(JPH_PhysicsSystem, JPH::PhysicsSystem);
DEFINE_CONVERSION_FUNCTIONS(JPH_BodyInterface, JPH::BodyInterface);
DEFINE_CONVERSION_FUNCTIONS(JPH_BodyLockInterface, JPH::BodyLockInterface);
DEFINE_CONVERSION_FUNCTIONS(JPH_BroadPhaseQuery, JPH::BroadPhaseQuery);
DEFINE_CONVERSION_FUNCTIONS(JPH_NarrowPhaseQuery, JPH::NarrowPhaseQuery);
DEFINE_CONVERSION_FUNCTIONS(JPH_TempAllocator, JPH::TempAllocator);
DEFINE_CONVERSION_FUNCTIONS(JPH_JobSystem, JPH::JobSystem);

DEFINE_CONVERSION_FUNCTIONS(JPH_BroadPhaseLayerInterface, JPH::BroadPhaseLayerInterface);
DEFINE_CONVERSION_FUNCTIONS(JPH_ObjectVsBroadPhaseLayerFilter, JPH::ObjectVsBroadPhaseLayerFilter);
DEFINE_CONVERSION_FUNCTIONS(JPH_ObjectLayerPairFilter, JPH::ObjectLayerPairFilter);
DEFINE_CONVERSION_FUNCTIONS(JPH_BroadPhaseLayerFilter, JPH::BroadPhaseLayerFilter);
DEFINE_CONVERSION_FUNCTIONS(JPH_ObjectLayerFilter, JPH::ObjectLayerFilter);

#ifdef JPH_DEBUG_RENDERER

DEFINE_CONVERSION_FUNCTIONS(JPH_DebugRenderer, JPH::DebugRenderer);
DEFINE_CONVERSION_FUNCTIONS(JPH_BodyDrawFilter, JPH::BodyDrawFilter);

#endif

// Shape settings

DEFINE_CONVERSION_FUNCTIONS(JPH_ShapeSettings, JPH::ShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_ConvexShapeSettings, JPH::ConvexShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_SphereShapeSettings, JPH::SphereShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_BoxShapeSettings, JPH::BoxShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_PlaneShapeSettings, JPH::PlaneShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_TriangleShapeSettings, JPH::TriangleShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_CapsuleShapeSettings, JPH::CapsuleShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_TaperedCapsuleShapeSettings, JPH::TaperedCapsuleShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_CylinderShapeSettings, JPH::CylinderShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_TaperedCylinderShapeSettings, JPH::TaperedCylinderShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_ConvexHullShapeSettings, JPH::ConvexHullShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_CompoundShapeSettings, JPH::CompoundShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_StaticCompoundShapeSettings, JPH::StaticCompoundShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_MutableCompoundShapeSettings, JPH::MutableCompoundShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_MeshShapeSettings, JPH::MeshShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_HeightFieldShapeSettings, JPH::HeightFieldShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_DecoratedShapeSettings, JPH::DecoratedShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_RotatedTranslatedShapeSettings, JPH::RotatedTranslatedShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_ScaledShapeSettings, JPH::ScaledShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_OffsetCenterOfMassShapeSettings, JPH::OffsetCenterOfMassShapeSettings);
DEFINE_CONVERSION_FUNCTIONS(JPH_EmptyShapeSettings, JPH::EmptyShapeSettings);

// Shapes

DEFINE_CONVERSION_FUNCTIONS(JPH_Shape, JPH::Shape);
DEFINE_CONVERSION_FUNCTIONS(JPH_ConvexShape, JPH::ConvexShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_SphereShape, JPH::SphereShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_BoxShape, JPH::BoxShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_PlaneShape, JPH::PlaneShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_TriangleShape, JPH::TriangleShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_CapsuleShape, JPH::CapsuleShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_TaperedCapsuleShape, JPH::TaperedCapsuleShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_CylinderShape, JPH::CylinderShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_TaperedCylinderShape, JPH::TaperedCylinderShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_ConvexHullShape, JPH::ConvexHullShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_CompoundShape, JPH::CompoundShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_StaticCompoundShape, JPH::StaticCompoundShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_MutableCompoundShape, JPH::MutableCompoundShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_MeshShape, JPH::MeshShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_HeightFieldShape, JPH::HeightFieldShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_DecoratedShape, JPH::DecoratedShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_RotatedTranslatedShape, JPH::RotatedTranslatedShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_ScaledShape, JPH::ScaledShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_OffsetCenterOfMassShape, JPH::OffsetCenterOfMassShape);
DEFINE_CONVERSION_FUNCTIONS(JPH_EmptyShape, JPH::EmptyShape);

DEFINE_CONVERSION_FUNCTIONS(JPH_PhysicsMaterial, JPH::PhysicsMaterial);

// Body

DEFINE_CONVERSION_FUNCTIONS(JPH_Body, JPH::Body);

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

