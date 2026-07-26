#include <JoltC.hpp>

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

JPH_EShapeType JPH_Shape_GetType(const JPH_Shape *shape) {
    return static_cast<JPH_EShapeType>(ToCpp(shape)->GetType());
}

JPH_EShapeSubType JPH_Shape_GetSubType(const JPH_Shape *shape) {
    return static_cast<JPH_EShapeSubType>(ToCpp(shape)->GetSubType());
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

void JPH_Shape_GetSupportingFace(const JPH_Shape *shape, JPH_SubShapeID subShapeID, JPH_Vec3 direction, JPH_Vec3 scale, JPH_Mat44 centerOfMassTransform, JPH_Shape_SupportingFace *outVertices) {
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

JPH_Shape *JPH_Shape_ScaleShape(const JPH_Shape *shape, JPH_Vec3 scale) {
    auto result = ToCpp(shape)->ScaleShape(ToCpp(scale));
    if (!result.IsValid()) {
        return nullptr;
    }

    auto scaledShape = result.Get().GetPtr();
    scaledShape->AddRef();

    return ToC(scaledShape);
}

// ConvexShape

void JPH_ConvexShape_SetMaterial(JPH_ConvexShape *shape, const JPH_PhysicsMaterial *material) {
    ToCpp(shape)->SetMaterial(ToCpp(material));
}

const JPH_PhysicsMaterial *JPH_ConvexShape_GetMaterial(const JPH_ConvexShape *shape) {
    return ToC(ToCpp(shape)->GetMaterial());
}

void JPH_ConvexShape_SetDensity(JPH_ConvexShape *shape, float density) {
    ToCpp(shape)->SetDensity(density);
}

float JPH_ConvexShape_GetDensity(const JPH_ConvexShape *shape) {
    return ToCpp(shape)->GetDensity();
}

// SphereShape

float JPH_SphereShape_GetRadius(const JPH_SphereShape *shape) {
    return ToCpp(shape)->GetRadius();
}

// BoxShape

JPH_Vec3 JPH_BoxShape_GetHalfExtent(const JPH_BoxShape *shape) {
    return ToC(ToCpp(shape)->GetHalfExtent());
}

float JPH_BoxShape_GetConvexRadius(const JPH_BoxShape *shape) {
    return ToCpp(shape)->GetConvexRadius();
}

// PlaneShape

JPH_Plane JPH_PlaneShape_GetPlane(const JPH_PlaneShape *shape) {
    return ToC(ToCpp(shape)->GetPlane());
}

float JPH_PlaneShape_GetHalfExtent(const JPH_PlaneShape *shape) {
    return ToCpp(shape)->GetHalfExtent();
}

void JPH_PlaneShape_SetMaterial(JPH_PlaneShape *shape, const JPH_PhysicsMaterial *material) {
    ToCpp(shape)->SetMaterial(ToCpp(material));
}

const JPH_PhysicsMaterial *JPH_PlaneShape_GetMaterial(const JPH_PlaneShape *shape) {
    return ToC(ToCpp(shape)->GetMaterial());
}

// TriangleShape

JPH_Vec3 JPH_TriangleShape_GetVertex1(const JPH_TriangleShape *shape) {
    return ToC(ToCpp(shape)->GetVertex1());
}

JPH_Vec3 JPH_TriangleShape_GetVertex2(const JPH_TriangleShape *shape) {
    return ToC(ToCpp(shape)->GetVertex2());
}

JPH_Vec3 JPH_TriangleShape_GetVertex3(const JPH_TriangleShape *shape) {
    return ToC(ToCpp(shape)->GetVertex3());
}

void JPH_TriangleShape_GetVertices(const JPH_TriangleShape *shape, JPH_Vec3 *outV1, JPH_Vec3 *outV2, JPH_Vec3 *outV3) {
    *outV1 = ToC(ToCpp(shape)->GetVertex1());
    *outV2 = ToC(ToCpp(shape)->GetVertex2());
    *outV3 = ToC(ToCpp(shape)->GetVertex3());
}

float JPH_TriangleShape_GetConvexRadius(const JPH_TriangleShape *shape) {
    return ToCpp(shape)->GetConvexRadius();
}

// CapsuleShape

float JPH_CapsuleShape_GetRadius(const JPH_CapsuleShape *shape) {
    return ToCpp(shape)->GetRadius();
}

float JPH_CapsuleShape_GetHalfHeightOfCylinder(const JPH_CapsuleShape *shape) {
    return ToCpp(shape)->GetHalfHeightOfCylinder();
}

// TaperedCapsuleShape

float JPH_TaperedCapsuleShape_GetTopRadius(const JPH_TaperedCapsuleShape *shape) {
    return ToCpp(shape)->GetTopRadius();
}

float JPH_TaperedCapsuleShape_GetBottomRadius(const JPH_TaperedCapsuleShape *shape) {
    return ToCpp(shape)->GetBottomRadius();
}

float JPH_TaperedCapsuleShape_GetHalfHeight(const JPH_TaperedCapsuleShape *shape) {
    return ToCpp(shape)->GetHalfHeight();
}

// CylinderShape

float JPH_CylinderShape_GetHalfHeight(const JPH_CylinderShape *shape) {
    return ToCpp(shape)->GetHalfHeight();
}

float JPH_CylinderShape_GetRadius(const JPH_CylinderShape *shape) {
    return ToCpp(shape)->GetRadius();
}

float JPH_CylinderShape_GetConvexRadius(const JPH_CylinderShape *shape) {
    return ToCpp(shape)->GetConvexRadius();
}

// TaperedCylinderShape

float JPH_TaperedCylinderShape_GetTopRadius(const JPH_TaperedCylinderShape *shape) {
    return ToCpp(shape)->GetTopRadius();
}

float JPH_TaperedCylinderShape_GetBottomRadius(const JPH_TaperedCylinderShape *shape) {
    return ToCpp(shape)->GetBottomRadius();
}

float JPH_TaperedCylinderShape_GetConvexRadius(const JPH_TaperedCylinderShape *shape) {
    return ToCpp(shape)->GetConvexRadius();
}

float JPH_TaperedCylinderShape_GetHalfHeight(const JPH_TaperedCylinderShape *shape) {
    return ToCpp(shape)->GetHalfHeight();
}

// ConvexHullShape

float JPH_ConvexHullShape_GetConvexRadius(const JPH_ConvexHullShape *shape) {
    return ToCpp(shape)->GetConvexRadius();
}

uint32_t JPH_ConvexHullShape_GetNumPoints(const JPH_ConvexHullShape *shape) {
    return static_cast<uint32_t>(ToCpp(shape)->GetNumPoints());
}

JPH_Vec3 JPH_ConvexHullShape_GetPoint(const JPH_ConvexHullShape *shape, uint32_t index) {
    return ToC(ToCpp(shape)->GetPoint(index));
}

uint32_t JPH_ConvexHullShape_GetNumFaces(const JPH_ConvexHullShape *shape) {
    return static_cast<uint32_t>(ToCpp(shape)->GetNumFaces());
}

uint32_t JPH_ConvexHullShape_GetNumVerticesInFace(const JPH_ConvexHullShape *shape, uint32_t faceIndex) {
    return static_cast<uint32_t>(ToCpp(shape)->GetNumVerticesInFace(faceIndex));
}

uint32_t JPH_ConvexHullShape_GetFaceVertices(const JPH_ConvexHullShape *shape, uint32_t faceIndex, uint32_t maxVertices, uint32_t *outVertices) {
    return static_cast<uint32_t>(ToCpp(shape)->GetFaceVertices(faceIndex, maxVertices, outVertices));
}

uint32_t JPH_ConvexHullShape_GetNumPlanes(const JPH_ConvexHullShape *shape) {
    return static_cast<uint32_t>(ToCpp(shape)->GetPlanes().size());
}

const JPH_Plane *JPH_ConvexHullShape_GetPlanes(const JPH_ConvexHullShape *shape) {
    return reinterpret_cast<const JPH_Plane *>(ToCpp(shape)->GetPlanes().data());
}

// DecoratedShape

const JPH_Shape *JPH_DecoratedShape_GetInnerShape(const JPH_DecoratedShape *shape) {
    return ToC(ToCpp(shape)->GetInnerShape());
}

// RotatedTranslatedShape

JPH_Quat JPH_RotatedTranslatedShape_GetRotation(const JPH_RotatedTranslatedShape *shape) {
    return ToC(ToCpp(shape)->GetRotation());
}

JPH_Vec3 JPH_RotatedTranslatedShape_GetPosition(const JPH_RotatedTranslatedShape *shape) {
    return ToC(ToCpp(shape)->GetPosition());
}

JPH_Vec3 JPH_RotatedTranslatedShape_TransformScale(const JPH_RotatedTranslatedShape *shape, JPH_Vec3 scale) {
    return ToC(ToCpp(shape)->TransformScale(ToCpp(scale)));
}

// ScaledShape

JPH_Vec3 JPH_ScaledShape_GetScale(const JPH_ScaledShape *shape) {
    return ToC(ToCpp(shape)->GetScale());
}

// OffsetCenterOfMassShape

JPH_Vec3 JPH_OffsetCenterOfMassShape_GetOffset(const JPH_OffsetCenterOfMassShape *shape) {
    return ToC(ToCpp(shape)->GetOffset());
}

// CompoundShape

uint32_t JPH_CompoundShape_GetNumSubShapes(const JPH_CompoundShape *shape) {
    return static_cast<uint32_t>(ToCpp(shape)->GetNumSubShapes());
}

uint32_t JPH_CompoundShape_GetCompoundUserData(const JPH_CompoundShape *shape, uint32_t index) {
    return ToCpp(shape)->GetCompoundUserData(index);
}

void JPH_CompoundShape_SetCompoundUserData(JPH_CompoundShape *shape, uint32_t index, uint32_t userData) {
    ToCpp(shape)->SetCompoundUserData(index, userData);
}

bool JPH_CompoundShape_IsSubShapeIDValid(const JPH_CompoundShape *shape, JPH_SubShapeID subShapeID) {
    return ToCpp(shape)->IsSubShapeIDValid(*reinterpret_cast<const JPH::SubShapeID *>(&subShapeID));
}

uint32_t JPH_CompoundShape_GetSubShapeIndexFromID(const JPH_CompoundShape *shape, JPH_SubShapeID subShapeID, JPH_SubShapeID *outRemainder) {
    JPH::SubShapeID remainder;
    uint32_t result = ToCpp(shape)->GetSubShapeIndexFromID(*reinterpret_cast<const JPH::SubShapeID *>(&subShapeID), remainder);
    *outRemainder = *reinterpret_cast<JPH_SubShapeID *>(&remainder);
    return result;
}

// MutableCompoundShape

uint32_t JPH_MutableCompoundShape_AddShape(JPH_MutableCompoundShape *shape, JPH_Vec3 position, JPH_Quat rotation, const JPH_Shape *inShape, uint32_t userData, uint32_t index) {
    return static_cast<uint32_t>(ToCpp(shape)->AddShape(ToCpp(position), ToCpp(rotation), ToCpp(inShape), userData, index));
}

void JPH_MutableCompoundShape_RemoveShape(JPH_MutableCompoundShape *shape, uint32_t index) {
    ToCpp(shape)->RemoveShape(index);
}

void JPH_MutableCompoundShape_ModifyShape(JPH_MutableCompoundShape *shape, uint32_t index, JPH_Vec3 position, JPH_Quat rotation) {
    ToCpp(shape)->ModifyShape(index, ToCpp(position), ToCpp(rotation));
}

void JPH_MutableCompoundShape_ModifyShapeWithShape(JPH_MutableCompoundShape *shape, uint32_t index, JPH_Vec3 position, JPH_Quat rotation, const JPH_Shape *inShape) {
    ToCpp(shape)->ModifyShape(index, ToCpp(position), ToCpp(rotation), ToCpp(inShape));
}

void JPH_MutableCompoundShape_ModifyShapes(JPH_MutableCompoundShape *shape, uint32_t startIndex, uint32_t number, const JPH_Vec3 *positions, const JPH_Quat *rotations, uint32_t positionStride, uint32_t rotationStride) {
    ToCpp(shape)->ModifyShapes(startIndex, number, reinterpret_cast<const JPH::Vec3 *>(positions), reinterpret_cast<const JPH::Quat *>(rotations), positionStride, rotationStride);
}

void JPH_MutableCompoundShape_AdjustCenterOfMass(JPH_MutableCompoundShape *shape) {
    ToCpp(shape)->AdjustCenterOfMass();
}

// MeshShape

uint32_t JPH_MeshShape_GetMaterialIndex(const JPH_MeshShape *shape, JPH_SubShapeID subShapeID) {
    return ToCpp(shape)->GetMaterialIndex(*reinterpret_cast<const JPH::SubShapeID *>(&subShapeID));
}

uint32_t JPH_MeshShape_GetTriangleUserData(const JPH_MeshShape *shape, JPH_SubShapeID subShapeID) {
    return ToCpp(shape)->GetTriangleUserData(*reinterpret_cast<const JPH::SubShapeID *>(&subShapeID));
}

// HeightFieldShape

uint32_t JPH_HeightFieldShape_GetSampleCount(const JPH_HeightFieldShape *shape) {
    return ToCpp(shape)->GetSampleCount();
}

uint32_t JPH_HeightFieldShape_GetBlockSize(const JPH_HeightFieldShape *shape) {
    return ToCpp(shape)->GetBlockSize();
}

const JPH_PhysicsMaterial *JPH_HeightFieldShape_GetMaterial(const JPH_HeightFieldShape *shape, uint32_t x, uint32_t y) {
    return ToC(ToCpp(shape)->GetMaterial(x, y));
}

JPH_Vec3 JPH_HeightFieldShape_GetPosition(const JPH_HeightFieldShape *shape, uint32_t x, uint32_t y) {
    return ToC(ToCpp(shape)->GetPosition(x, y));
}

bool JPH_HeightFieldShape_IsNoCollision(const JPH_HeightFieldShape *shape, uint32_t x, uint32_t y) {
    return ToCpp(shape)->IsNoCollision(x, y);
}

bool JPH_HeightFieldShape_ProjectOntoSurface(const JPH_HeightFieldShape *shape, JPH_Vec3 localPosition, JPH_Vec3 *outSurfacePosition, JPH_SubShapeID *outSubShapeID) {
    JPH::Vec3 surfacePosition;
    JPH::SubShapeID subShapeID;
    bool result = ToCpp(shape)->ProjectOntoSurface(ToCpp(localPosition), surfacePosition, subShapeID);
    *outSurfacePosition = ToC(surfacePosition);
    *outSubShapeID = *reinterpret_cast<JPH_SubShapeID *>(&subShapeID);
    return result;
}

void JPH_HeightFieldShape_GetSubShapeCoordinates(const JPH_HeightFieldShape *shape, JPH_SubShapeID subShapeID, uint32_t *outX, uint32_t *outY, uint32_t *outTriangleIndex) {
    ToCpp(shape)->GetSubShapeCoordinates(*reinterpret_cast<const JPH::SubShapeID *>(&subShapeID), *outX, *outY, *outTriangleIndex);
}

float JPH_HeightFieldShape_GetMinHeightValue(const JPH_HeightFieldShape *shape) {
    return ToCpp(shape)->GetMinHeightValue();
}

float JPH_HeightFieldShape_GetMaxHeightValue(const JPH_HeightFieldShape *shape) {
    return ToCpp(shape)->GetMaxHeightValue();
}

void JPH_HeightFieldShape_GetHeights(const JPH_HeightFieldShape *shape, uint32_t x, uint32_t y, uint32_t sizeX, uint32_t sizeY, float *outHeights, intptr_t heightsStride) {
    ToCpp(shape)->GetHeights(x, y, sizeX, sizeY, outHeights, heightsStride);
}

void JPH_HeightFieldShape_SetHeights(JPH_HeightFieldShape *shape, uint32_t x, uint32_t y, uint32_t sizeX, uint32_t sizeY, const float *inHeights, intptr_t heightsStride, JPH_TempAllocator *allocator, float activeEdgeCosThresholdAngle) {
    ToCpp(shape)->SetHeights(x, y, sizeX, sizeY, inHeights, heightsStride, *ToCpp(allocator), activeEdgeCosThresholdAngle);
}
