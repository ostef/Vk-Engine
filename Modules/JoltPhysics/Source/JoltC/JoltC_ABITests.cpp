#include <JoltC.hpp>

JOLTC_SUPPRESS_WARNINGS()

// @Todo: test enum values

#define ABI_TEST(c_type, cpp_type) \
    JPH_ASSERT(sizeof(c_type) == sizeof(cpp_type)); \
    JPH_ASSERT(alignof(c_type) == alignof(cpp_type));

#define OFFSET_OF(T, field) ((uint64_t)&((const T *)(0))->field)

#define ABI_TEST_OFFSET_OF(c_type, c_field, cpp_type, cpp_field) \
    JPH_ASSERT(OFFSET_OF(c_type, c_field) == OFFSET_OF(cpp_type, cpp_field));

void ABITests() {
    using uint64 = uint64_t;

    JPH_ASSERT(JOLTC_VERSION_FEATURES == JPH_VERSION_FEATURES, "JoltC and Jolt feature bits mismatch");

    ABI_TEST(JPH_Float3, JPH::Float3);
    ABI_TEST_OFFSET_OF(JPH_Float3, x, JPH::Float3, x);
    ABI_TEST_OFFSET_OF(JPH_Float3, y, JPH::Float3, y);
    ABI_TEST_OFFSET_OF(JPH_Float3, z, JPH::Float3, z);

    ABI_TEST(JPH_UVec4, JPH::UVec4);
    ABI_TEST_OFFSET_OF(JPH_UVec4, x, JPH::UVec4, mU32[0]);
    ABI_TEST_OFFSET_OF(JPH_UVec4, y, JPH::UVec4, mU32[1]);
    ABI_TEST_OFFSET_OF(JPH_UVec4, z, JPH::UVec4, mU32[2]);
    ABI_TEST_OFFSET_OF(JPH_UVec4, w, JPH::UVec4, mU32[3]);

    ABI_TEST(JPH_Vec3, JPH::Vec3);
    ABI_TEST_OFFSET_OF(JPH_Vec3, x, JPH::Vec3, mF32[0]);
    ABI_TEST_OFFSET_OF(JPH_Vec3, y, JPH::Vec3, mF32[1]);
    ABI_TEST_OFFSET_OF(JPH_Vec3, z, JPH::Vec3, mF32[2]);
    ABI_TEST_OFFSET_OF(JPH_Vec3, z2, JPH::Vec3, mF32[3]);

    ABI_TEST(JPH_Vec4, JPH::Vec4);
    ABI_TEST_OFFSET_OF(JPH_Vec4, x, JPH::Vec4, mF32[0]);
    ABI_TEST_OFFSET_OF(JPH_Vec4, y, JPH::Vec4, mF32[1]);
    ABI_TEST_OFFSET_OF(JPH_Vec4, z, JPH::Vec4, mF32[2]);
    ABI_TEST_OFFSET_OF(JPH_Vec4, w, JPH::Vec4, mF32[3]);

    ABI_TEST(JPH_Mat44, JPH::Mat44);

    ABI_TEST(JPH_DVec3, JPH::DVec3);
    ABI_TEST_OFFSET_OF(JPH_DVec3, x, JPH::DVec3, mF64[0]);
    ABI_TEST_OFFSET_OF(JPH_DVec3, y, JPH::DVec3, mF64[1]);
    ABI_TEST_OFFSET_OF(JPH_DVec3, z, JPH::DVec3, mF64[2]);
    ABI_TEST_OFFSET_OF(JPH_DVec3, z2, JPH::DVec3, mF64[3]);

    ABI_TEST(JPH_DMat44, JPH::DMat44);

    ABI_TEST(JPH_Quat, JPH::Quat);

    ABI_TEST(JPH_AABox, JPH::AABox);
    ABI_TEST(JPH_Plane, JPH::Plane);
    ABI_TEST(JPH_OrientedBox, JPH::OrientedBox);
    ABI_TEST(JPH_PhysicsSettings, JPH::PhysicsSettings);

    ABI_TEST(JPH_BroadPhaseLayer, JPH::BroadPhaseLayer);
    ABI_TEST(JPH_CollisionGroup_GroupID, JPH::CollisionGroup::GroupID);
    ABI_TEST(JPH_CollisionGroup_SubGroupID, JPH::CollisionGroup::SubGroupID);
    ABI_TEST(JPH_CollisionGroup, JPH::CollisionGroup);
    ABI_TEST(JPH_RayCast, JPH::RayCast);
    ABI_TEST(JPH_RRayCast, JPH::RRayCast);
    ABI_TEST(JPH_EBackFaceMode, JPH::EBackFaceMode);
    ABI_TEST(JPH_RayCastSettings, JPH::RayCastSettings);
    ABI_TEST(JPH_AABoxCast, JPH::AABoxCast);
    ABI_TEST(JPH_BroadPhaseCastResult, JPH::BroadPhaseCastResult);
    ABI_TEST_OFFSET_OF(JPH_BroadPhaseCastResult, bodyID, JPH::BroadPhaseCastResult, mBodyID);
    ABI_TEST_OFFSET_OF(JPH_BroadPhaseCastResult, fraction, JPH::BroadPhaseCastResult, mFraction);

    ABI_TEST(JPH_RayCastResult, JPH::RayCastResult);
    ABI_TEST_OFFSET_OF(JPH_RayCastResult, bodyID, JPH::RayCastResult, mBodyID);
    ABI_TEST_OFFSET_OF(JPH_RayCastResult, fraction, JPH::RayCastResult, mFraction);
    ABI_TEST_OFFSET_OF(JPH_RayCastResult, subShapeID2, JPH::RayCastResult, mSubShapeID2);

    ABI_TEST(JPH_IndexedTriangle, JPH::IndexedTriangle);
    ABI_TEST(JPH_MeshShapeSettings_EBuildQuality, JPH::MeshShapeSettings::EBuildQuality);
    ABI_TEST(JPH_SubShapeID, JPH::SubShapeID);
    ABI_TEST(JPH_EShapeType, JPH::EShapeType);
    ABI_TEST(JPH_EShapeSubType, JPH::EShapeSubType);
    ABI_TEST(JPH_MassProperties, JPH::MassProperties);
    ABI_TEST(JPH_Shape_SupportingFace, JPH::Shape::SupportingFace);
    ABI_TEST(JPH_Shape_GetTrianglesContext, JPH::Shape::GetTrianglesContext);
    ABI_TEST(JPH_Shape_Stats, JPH::Shape::Stats);

    ABI_TEST(JPH_BodyManager_BodyStats, JPH::BodyManager::BodyStats);
    ABI_TEST(JPH_EBodyType, JPH::EBodyType);
    ABI_TEST(JPH_ECanSleep, JPH::ECanSleep);
    ABI_TEST(JPH_EMotionQuality, JPH::EMotionQuality);
    ABI_TEST(JPH_EMotionType, JPH::EMotionType);
    ABI_TEST(JPH_EAllowedDOFs, JPH::EAllowedDOFs);
    ABI_TEST(JPH_EOverrideMassProperties, JPH::EOverrideMassProperties);
    ABI_TEST(JPH_BodyCreationSettings, JPH::BodyCreationSettings);
    ABI_TEST(JPH_SoftBodyCreationSettings, JPH::SoftBodyCreationSettings);
    ABI_TEST(JPH_EActivation, JPH::EActivation);
    ABI_TEST(JPH_BodyManager_MutexMask, JPH::BodyManager::MutexMask);

    ABI_TEST(JPH_EPhysicsUpdateError, JPH::EPhysicsUpdateError);

#ifdef JPH_DEBUG_RENDERER
    ABI_TEST(JPH_DebugRenderer_ECastShadow, JPH::DebugRenderer::ECastShadow);
    ABI_TEST(JPH_DebugRenderer_EDrawMode, JPH::DebugRenderer::EDrawMode);
    ABI_TEST(JPH_DebugRenderer_ECullMode, JPH::DebugRenderer::ECullMode);
    ABI_TEST(JPH_ESoftBodyConstraintColor, JPH::ESoftBodyConstraintColor);
    ABI_TEST(JPH_BodyManager_EShapeColor, JPH::BodyManager::EShapeColor);
    ABI_TEST(JPH_BodyManager_DrawSettings, JPH::BodyManager::DrawSettings);
#endif
}

JOLTC_POP_WARNINGS()
