#include <JoltC.hpp>

JPH_BodyCreationSettings JPH_BodyCreationSettings_Default() {
    auto result = JPH::BodyCreationSettings();
    return *reinterpret_cast<JPH_BodyCreationSettings *>(&result);
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

JPH_SoftBodyCreationSettings JPH_SoftBodyCreationSettings_Default() {
    auto result = JPH::SoftBodyCreationSettings();
    return *reinterpret_cast<JPH_SoftBodyCreationSettings *>(&result);
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

// Body

JPH_BodyID JPH_Body_GetID(const JPH_Body *body) {
    return ToCpp(body)->GetID().GetIndexAndSequenceNumber();
}

JPH_EBodyType JPH_Body_GetBodyType(const JPH_Body *body) {
    return static_cast<JPH_EBodyType>(ToCpp(body)->GetBodyType());
}

bool JPH_Body_IsRigidBody(const JPH_Body *body) {
    return ToCpp(body)->IsRigidBody();
}

bool JPH_Body_IsSoftBody(const JPH_Body *body) {
    return ToCpp(body)->IsSoftBody();
}

bool JPH_Body_IsActive(const JPH_Body *body) {
    return ToCpp(body)->IsActive();
}

bool JPH_Body_IsStatic(const JPH_Body *body) {
    return ToCpp(body)->IsStatic();
}

bool JPH_Body_IsKinematic(const JPH_Body *body) {
    return ToCpp(body)->IsKinematic();
}

bool JPH_Body_IsDynamic(const JPH_Body *body) {
    return ToCpp(body)->IsDynamic();
}

bool JPH_Body_CanBeKinematicOrDynamic(const JPH_Body *body) {
    return ToCpp(body)->CanBeKinematicOrDynamic();
}

void JPH_Body_SetIsSensor(JPH_Body *body, bool isSensor) {
    ToCpp(body)->SetIsSensor(isSensor);
}

bool JPH_Body_IsSensor(const JPH_Body *body) {
    return ToCpp(body)->IsSensor();
}

void JPH_Body_SetCollideKinematicVsNonDynamic(JPH_Body *body, bool collide) {
    ToCpp(body)->SetCollideKinematicVsNonDynamic(collide);
}

bool JPH_Body_GetCollideKinematicVsNonDynamic(const JPH_Body *body) {
    return ToCpp(body)->GetCollideKinematicVsNonDynamic();
}

void JPH_Body_SetUseManifoldReduction(JPH_Body *body, bool useReduction) {
    ToCpp(body)->SetUseManifoldReduction(useReduction);
}

bool JPH_Body_GetUseManifoldReduction(const JPH_Body *body) {
    return ToCpp(body)->GetUseManifoldReduction();
}

bool JPH_Body_GetUseManifoldReductionWithBody(const JPH_Body *body, const JPH_Body *body2) {
    return ToCpp(body)->GetUseManifoldReductionWithBody(*ToCpp(body2));
}

void JPH_Body_SetApplyGyroscopicForce(JPH_Body *body, bool apply) {
    ToCpp(body)->SetApplyGyroscopicForce(apply);
}

bool JPH_Body_GetApplyGyroscopicForce(const JPH_Body *body) {
    return ToCpp(body)->GetApplyGyroscopicForce();
}

void JPH_Body_SetEnhancedInternalEdgeRemoval(JPH_Body *body, bool apply) {
    ToCpp(body)->SetEnhancedInternalEdgeRemoval(apply);
}

bool JPH_Body_GetEnhancedInternalEdgeRemoval(const JPH_Body *body) {
    return ToCpp(body)->GetEnhancedInternalEdgeRemoval();
}

bool JPH_Body_GetEnhancedInternalEdgeRemovalWithBody(const JPH_Body *body, const JPH_Body *body2) {
    return ToCpp(body)->GetEnhancedInternalEdgeRemovalWithBody(*ToCpp(body2));
}

JPH_EMotionType JPH_Body_GetMotionType(const JPH_Body *body) {
    return static_cast<JPH_EMotionType>(ToCpp(body)->GetMotionType());
}

void JPH_Body_SetMotionType(JPH_Body *body, JPH_EMotionType motionType) {
    ToCpp(body)->SetMotionType(static_cast<JPH::EMotionType>(motionType));
}

JPH_BroadPhaseLayer JPH_Body_GetBroadPhaseLayer(const JPH_Body *body) {
    return ToCpp(body)->GetBroadPhaseLayer().GetValue();
}

JPH_ObjectLayer JPH_Body_GetObjectLayer(const JPH_Body *body) {
    return ToCpp(body)->GetObjectLayer();
}

const JPH_CollisionGroup *JPH_Body_GetCollisionGroupConst(const JPH_Body *body) {
    return reinterpret_cast<const JPH_CollisionGroup *>(&ToCpp(body)->GetCollisionGroup());
}

JPH_CollisionGroup *JPH_Body_GetCollisionGroup(JPH_Body *body) {
    return reinterpret_cast<JPH_CollisionGroup *>(&ToCpp(body)->GetCollisionGroup());
}

void JPH_Body_SetCollisionGroup(JPH_Body *body, const JPH_CollisionGroup *group) {
    ToCpp(body)->SetCollisionGroup(*reinterpret_cast<const JPH::CollisionGroup *>(group));
}

bool JPH_Body_GetAllowSleeping(const JPH_Body *body) {
    return ToCpp(body)->GetAllowSleeping();
}

void JPH_Body_SetAllowSleeping(JPH_Body *body, bool allow) {
    ToCpp(body)->SetAllowSleeping(allow);
}

void JPH_Body_ResetSleepTimer(JPH_Body *body) {
    ToCpp(body)->ResetSleepTimer();
}

float JPH_Body_GetFriction(const JPH_Body *body) {
    return ToCpp(body)->GetFriction();
}

void JPH_Body_SetFriction(JPH_Body *body, float friction) {
    ToCpp(body)->SetFriction(friction);
}

float JPH_Body_GetRestitution(const JPH_Body *body) {
    return ToCpp(body)->GetRestitution();
}

void JPH_Body_SetRestitution(JPH_Body *body, float restitution) {
    ToCpp(body)->SetRestitution(restitution);
}

JPH_Vec3 JPH_Body_GetLinearVelocity(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetLinearVelocity());
}

void JPH_Body_SetLinearVelocity(JPH_Body *body, JPH_Vec3 linearVelocity) {
    ToCpp(body)->SetLinearVelocity(ToCpp(linearVelocity));
}

void JPH_Body_SetLinearVelocityClamped(JPH_Body *body, JPH_Vec3 linearVelocity) {
    ToCpp(body)->SetLinearVelocityClamped(ToCpp(linearVelocity));
}

JPH_Vec3 JPH_Body_GetAngularVelocity(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetAngularVelocity());
}

void JPH_Body_SetAngularVelocity(JPH_Body *body, JPH_Vec3 angularVelocity) {
    ToCpp(body)->SetAngularVelocity(ToCpp(angularVelocity));
}

void JPH_Body_SetAngularVelocityClamped(JPH_Body *body, JPH_Vec3 angularVelocity) {
    ToCpp(body)->SetAngularVelocityClamped(ToCpp(angularVelocity));
}

JPH_Vec3 JPH_Body_GetPointVelocityCOM(const JPH_Body *body, JPH_Vec3 pointRelativeToCOM) {
    return ToC(ToCpp(body)->GetPointVelocityCOM(ToCpp(pointRelativeToCOM)));
}

JPH_Vec3 JPH_Body_GetPointVelocity(const JPH_Body *body, JPH_RVec3 point) {
    return ToC(ToCpp(body)->GetPointVelocity(ToCpp(point)));
}

void JPH_Body_AddForce(JPH_Body *body, JPH_Vec3 force) {
    ToCpp(body)->AddForce(ToCpp(force));
}

void JPH_Body_AddForceAtPoint(JPH_Body *body, JPH_Vec3 force, JPH_RVec3 position) {
    ToCpp(body)->AddForce(ToCpp(force), ToCpp(position));
}

void JPH_Body_AddTorque(JPH_Body *body, JPH_Vec3 torque) {
    ToCpp(body)->AddTorque(ToCpp(torque));
}

JPH_Vec3 JPH_Body_GetAccumulatedForce(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetAccumulatedForce());
}

JPH_Vec3 JPH_Body_GetAccumulatedTorque(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetAccumulatedTorque());
}

void JPH_Body_ResetForce(JPH_Body *body) {
    ToCpp(body)->ResetForce();
}

void JPH_Body_ResetTorque(JPH_Body *body) {
    ToCpp(body)->ResetTorque();
}

void JPH_Body_ResetMotion(JPH_Body *body) {
    ToCpp(body)->ResetMotion();
}

JPH_Mat44 JPH_Body_GetInverseInertia(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetInverseInertia());
}

void JPH_Body_AddImpulse(JPH_Body *body, JPH_Vec3 impulse) {
    ToCpp(body)->AddImpulse(ToCpp(impulse));
}

void JPH_Body_AddImpulseAtPoint(JPH_Body *body, JPH_Vec3 impulse, JPH_RVec3 position) {
    ToCpp(body)->AddImpulse(ToCpp(impulse), ToCpp(position));
}

void JPH_Body_AddAngularImpulse(JPH_Body *body, JPH_Vec3 angularImpulse) {
    ToCpp(body)->AddAngularImpulse(ToCpp(angularImpulse));
}

void JPH_Body_MoveKinematic(JPH_Body *body, JPH_RVec3 targetPosition, JPH_Quat targetRotation, float deltaTime) {
    ToCpp(body)->MoveKinematic(ToCpp(targetPosition), ToCpp(targetRotation), deltaTime);
}

void JPH_Body_GetSubmergedVolume(const JPH_Body *body, JPH_RVec3 surfacePosition, JPH_Vec3 surfaceNormal, float *outTotalVolume, float *outSubmergedVolume, JPH_Vec3 *outRelativeCenterOfBuoyancy) {
    ToCpp(body)->GetSubmergedVolume(ToCpp(surfacePosition), ToCpp(surfaceNormal), *outTotalVolume, *outSubmergedVolume, *reinterpret_cast<JPH::Vec3 *>(outRelativeCenterOfBuoyancy));
}

bool JPH_Body_ApplyBuoyancyImpulseWithSurface(JPH_Body *body, JPH_RVec3 surfacePosition, JPH_Vec3 surfaceNormal, float buoyancy, float linearDrag, float angularDrag, JPH_Vec3 fluidVelocity, JPH_Vec3 gravity, float deltaTime) {
    return ToCpp(body)->ApplyBuoyancyImpulse(ToCpp(surfacePosition), ToCpp(surfaceNormal), buoyancy, linearDrag, angularDrag, ToCpp(fluidVelocity), ToCpp(gravity), deltaTime);
}

bool JPH_Body_ApplyBuoyancyImpulse(JPH_Body *body, float totalVolume, float submergedVolume, JPH_Vec3 relativeCenterOfBuoyancy, float buoyancy, float linearDrag, float angularDrag, JPH_Vec3 fluidVelocity, JPH_Vec3 gravity, float deltaTime) {
    return ToCpp(body)->ApplyBuoyancyImpulse(totalVolume, submergedVolume, ToCpp(relativeCenterOfBuoyancy), buoyancy, linearDrag, angularDrag, ToCpp(fluidVelocity), ToCpp(gravity), deltaTime);
}

bool JPH_Body_IsInBroadPhase(const JPH_Body *body) {
    return ToCpp(body)->IsInBroadPhase();
}

bool JPH_Body_IsCollisionCacheInvalid(const JPH_Body *body) {
    return ToCpp(body)->IsCollisionCacheInvalid();
}

const JPH_Shape *JPH_Body_GetShape(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetShape());
}

JPH_RVec3 JPH_Body_GetPosition(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetPosition());
}

JPH_Quat JPH_Body_GetRotation(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetRotation());
}

JPH_RMat44 JPH_Body_GetWorldTransform(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetWorldTransform());
}

JPH_RVec3 JPH_Body_GetCenterOfMassPosition(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetCenterOfMassPosition());
}

JPH_RMat44 JPH_Body_GetCenterOfMassTransform(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetCenterOfMassTransform());
}

JPH_RMat44 JPH_Body_GetInverseCenterOfMassTransform(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetInverseCenterOfMassTransform());
}

JPH_AABox JPH_Body_GetWorldSpaceBounds(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetWorldSpaceBounds());
}

const JPH_MotionProperties *JPH_Body_GetMotionPropertiesConst(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetMotionProperties());
}

JPH_MotionProperties *JPH_Body_GetMotionProperties(JPH_Body *body) {
    return ToC(ToCpp(body)->GetMotionProperties());
}

const JPH_MotionProperties *JPH_Body_GetMotionPropertiesUncheckedConst(const JPH_Body *body) {
    return ToC(ToCpp(body)->GetMotionPropertiesUnchecked());
}

JPH_MotionProperties *JPH_Body_GetMotionPropertiesUnchecked(JPH_Body *body) {
    return ToC(ToCpp(body)->GetMotionPropertiesUnchecked());
}

uint64_t JPH_Body_GetUserData(const JPH_Body *body) {
    return ToCpp(body)->GetUserData();
}

void JPH_Body_SetUserData(JPH_Body *body, uint64_t userData) {
    ToCpp(body)->SetUserData(userData);
}

JPH_Vec3 JPH_Body_GetWorldSpaceSurfaceNormal(const JPH_Body *body, JPH_SubShapeID subShapeID, JPH_RVec3 position) {
    return ToC(ToCpp(body)->GetWorldSpaceSurfaceNormal(*reinterpret_cast<const JPH::SubShapeID *>(&subShapeID), ToCpp(position)));
}

JPH_BodyCreationSettings JPH_Body_GetBodyCreationSettings(const JPH_Body *body) {
    auto result = ToCpp(body)->GetBodyCreationSettings();
    return *reinterpret_cast<JPH_BodyCreationSettings *>(&result);
}

void JPH_Body_ApplyBodyCreationSettings(JPH_Body *body, const JPH_BodyCreationSettings *bodyCreationSettings, const JPH_BroadPhaseLayerInterface *bplInterface) {
    ToCpp(body)->ApplyBodyCreationSettings(*ToCpp(bodyCreationSettings), *ToCpp(bplInterface));
}

JPH_SoftBodyCreationSettings JPH_Body_GetSoftBodyCreationSettings(const JPH_Body *body) {
    auto result = ToCpp(body)->GetSoftBodyCreationSettings();
    return *reinterpret_cast<JPH_SoftBodyCreationSettings *>(&result);
}

void JPH_Body_ApplySoftBodyCreationSettings(JPH_Body *body, const JPH_SoftBodyCreationSettings *softBodyCreationSettings, const JPH_BroadPhaseLayerInterface *bplInterface) {
    ToCpp(body)->ApplySoftBodyCreationSettings(*ToCpp(softBodyCreationSettings), *ToCpp(bplInterface));
}
