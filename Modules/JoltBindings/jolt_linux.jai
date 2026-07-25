//
// This file was auto-generated using the following command:
//
// jai generate.jai - build
//



JOLTC_VECTOR_ALIGNMENT :: 16;
JOLTC_DVECTOR_ALIGNMENT :: 32;

JPH_cDefaultCollisionTolerance :: 1.0e-4;
JPH_cDefaultPenetrationTolerance :: 1.0e-4;
JPH_cDefaultConvexRadius :: 0.05;
JPH_cCapsuleProjectionSlop :: 0.02;
JPH_cDefaultInternalEdgeRemovalVertexToleranceSq :: 1.0e-8;
JPH_cMaxPhysicsJobs :: 2048;
JPH_cMaxPhysicsBarriers :: 8;

JPH_cInvalidBodyID :: 0xffffffff;

TempAllocator :: struct {}
JobSystem :: struct {}
SharedMutex :: struct {}

Bool :: u32;

// @Todo: ensure vector type alignment
Float3 :: struct {
    x: float;
    y: float;
    z: float;
}

UVec4 :: union {
    struct {
        x: u32;
        y: u32;
        z: u32;
        w: u32;
    }

    values: [4] u32;
}

Mat44 :: struct {
    cols: [4] Vec4 #align 16;
}

DVec3 :: union {
    struct {
        x: float64;
        y: float64;
        z: float64;
    }

    values: [4] float64;
}

DVec4 :: union {
    struct {
        x: float64;
        y: float64;
        z: float64;
        w: float64;
    }

    values: [4] float64;
}

DMat44 :: struct {
    cols: [3] Vec4 #align 16;
    col3: DVec3 #align 32;
}

RVec3 :: Vec3;
RMat44 :: Mat44;

Color :: u32;

AABox :: struct {
    min: Vec3;
    max: Vec3;

    _:   [0] u8 #align 16; // Force AABox alignment to match the C/C++ equivalent
}

Plane :: struct {
    normalAndConstant: Vec4;

    _:                 [0] u8 #align 16; // Force Plane alignment to match the C/C++ equivalent
}

Plane_Make :: (normal: Vec3, constant: float) -> Plane #foreign JoltC "JPH_Plane_Make";
Plane_Offset :: (plane: Plane, distance: float) -> Plane #foreign JoltC "JPH_Plane_Offset";
Plane_Scaled :: (plane: Plane, scale: Vec3) -> Plane #foreign JoltC "JPH_Plane_Scaled";
Plane_GetTransformed :: (plane: Plane, transform: Mat44) -> Plane #foreign JoltC "JPH_Plane_GetTransformed";
Plane_SignedDistance :: (plane: Plane, point: Vec3) -> float #foreign JoltC "JPH_Plane_SignedDistance";
Plane_ProjectPointOnPlane :: (plane: Plane, point: Vec3) -> Vec3 #foreign JoltC "JPH_Plane_ProjectPointOnPlane";
Plane_FromPointAndNormal :: (point: Vec3, normal: Vec3) -> Plane #foreign JoltC "JPH_Plane_FromPointAndNormal";

PhysicsSettings :: struct {
    maxInFlightBodyPairs:                 s32;
    stepListenersBatchSize:               s32;
    stepListenerBatchesPerJob:            s32;
    baumgarte:                            float;
    speculativeContactDistance:           float;
    penetrationSlop:                      float;
    linearCastThreshold:                  float;
    linearCastMaxPenetration:             float;
    manifoldTolerance:                    float;
    maxPenetrationDistance:               float;
    bodyPairCacheMaxDeltaPositionSq:      float;
    bodyPairCacheCosMaxDeltaRotationDiv2: float;
    contactNormalCosMaxDeltaRotation:     float;
    contactPointPreserveLambdaMaxDistSq:  float;
    internalEdgeRemovalVertexToleranceSq: float;
    numVelocitySteps:                     u32;
    numPositionSteps:                     u32;
    minVelocityForRestitution:            float;
    timeBeforeSleep:                      float;
    pointVelocitySleepThreshold:          float;
    deterministicSimulation:              bool;
    constraintWarmStart:                  bool;
    useBodyPairContactCache:              bool;
    useManifoldReduction:                 bool;
    useLargeIslandSplitter:               bool;
    allowSleeping:                        bool;
    checkActiveEdges:                     bool;
}

TempAllocatorImpl_Create :: (size: u64) -> *TempAllocator #foreign JoltC "JPH_TempAllocatorImpl_Create";
TempAllocatorImplWithMallocFallback_Create :: (size: u32) -> *TempAllocator #foreign JoltC "JPH_TempAllocatorImplWithMallocFallback_Create";
TempAllocatorMalloc_Create :: () -> *TempAllocator #foreign JoltC "JPH_TempAllocatorMalloc_Create";
TempAllocator_Destroy :: (allocator: *TempAllocator) -> void #foreign JoltC "JPH_TempAllocator_Destroy";
TempAllocator_Allocate :: (allocator: *TempAllocator, size: u32) -> *void #foreign JoltC "JPH_TempAllocator_Allocate";
TempAllocator_Free :: (allocator: *TempAllocator, ptr: *void, size: u32) -> void #foreign JoltC "JPH_TempAllocator_Free";

JobSystemSingleThreaded_Create :: (maxJobs: u32) -> *JobSystem #foreign JoltC "JPH_JobSystemSingleThreaded_Create";
JobSystemThreadPool_Create :: (maxJobs: u32, maxBarriers: u32, numThreads: s32) -> *JobSystem #foreign JoltC "JPH_JobSystemThreadPool_Create";
JobSystem_Destroy :: (job_system: *JobSystem) -> void #foreign JoltC "JPH_JobSystem_Destroy";

AllocateFunction :: #type (size: u64) -> *void #c_call;
ReallocateFunction :: #type (block: *void, oldSize: u64, newSize: u64) -> *void #c_call;
FreeFunction :: #type (block: *void) -> void #c_call;
AlignedAllocateFunction :: #type (size: u64, alignment: u64) -> *void #c_call;
AlignedFreeFunction :: #type (block: *void) -> void #c_call;

TraceHandler :: #type (fmt: *u8, __args: ..Any) -> void #c_call;
AssertFailedHandler :: #type (expression: *u8, message: *u8, file: *u8, line: u32) -> bool #c_call;

RegisterDefaultAllocator :: () -> void #foreign JoltC "JPH_RegisterDefaultAllocator";
SetAllocatorFunctions :: (allocate: AllocateFunction, reallocate: ReallocateFunction, free: FreeFunction, alignedAllocate: AlignedAllocateFunction, alignedFree: AlignedFreeFunction) -> void #foreign JoltC "JPH_SetAllocatorFunctions";
SetTraceHandler :: (handler: TraceHandler) -> void #foreign JoltC "JPH_SetTraceHandler";
SetAssertFailedHandler :: (handler: AssertFailedHandler) -> void #foreign JoltC "JPH_SetAssertFailedHandler";
CreateFactory :: () -> void #foreign JoltC "JPH_CreateFactory";
DestroyFactory :: () -> void #foreign JoltC "JPH_DestroyFactory";
RegisterTypes :: () -> void #foreign JoltC "JPH_RegisterTypes";
UnregisterTypes :: () -> void #foreign JoltC "JPH_UnregisterTypes";

Allocate :: (size: u64) -> *void #foreign JoltC "JPH_Allocate";
Reallocate :: (block: *void, oldSize: u64, newSize: u64) -> *void #foreign JoltC "JPH_Reallocate";
Free :: (block: *void) -> void #foreign JoltC "JPH_Free";
AlignedAllocate :: (size: u64, alignment: u64) -> *void #foreign JoltC "JPH_AlignedAllocate";
AlignedFree :: (block: *void) -> void #foreign JoltC "JPH_AlignedFree";

// The default empty allocator calls JPH::Allocate and JPH::Free
Allocator :: struct {
    data:     *void;
    Allocate: #type (data: *void, size: u64) -> *void #c_call;
    Free:     #type (data: *void, ptr: *void) -> void #c_call;
}

Allocator_Allocate :: (allocator: Allocator, size: u64) -> *void #foreign JoltC "JPH_Allocator_Allocate";
Allocator_Free :: (allocator: Allocator, ptr: *void) -> void #foreign JoltC "JPH_Allocator_Free";

PhysicsMaterial :: struct {}
BroadPhaseLayerInterface :: struct {}
ObjectVsBroadPhaseLayerFilter :: struct {}
ObjectLayerPairFilter :: struct {}
BroadPhaseLayerFilter :: struct {}
ObjectLayerFilter :: struct {}
GroupFilter :: struct {}
BroadPhaseQuery :: struct {}
NarrowPhaseQuery :: struct {}

BroadPhaseLayer :: u8;

ObjectLayer :: u16;

CollisionGroup_GroupID :: u32;
CollisionGroup_SubGroupID :: u32;

CollisionGroup :: struct {
    groupFilter: *GroupFilter;
    groupID:     CollisionGroup_GroupID;
    subGroupID:  CollisionGroup_SubGroupID;
}

BroadPhaseLayerInterface_Funcs :: struct {
    Destruct:               #type (data: *void) -> void #c_call;
    GetNumBroadPhaseLayers: #type (data: *void) -> u32 #c_call;
    GetBroadPhaseLayer:     #type (data: *void, layer: ObjectLayer) -> BroadPhaseLayer #c_call;
}

BroadPhaseLayerInterface_Create :: (data: *void, funcs: BroadPhaseLayerInterface_Funcs, allocator: Allocator) -> *BroadPhaseLayerInterface #foreign JoltC "JPH_BroadPhaseLayerInterface_Create";
BroadPhaseLayerInterface_Destroy :: (self: *BroadPhaseLayerInterface) -> void #foreign JoltC "JPH_BroadPhaseLayerInterface_Destroy";

ObjectVsBroadPhaseLayerFilter_Funcs :: struct {
    Destruct:      #type (data: *void) -> void #c_call;
    ShouldCollide: #type (data: *void, layer1: ObjectLayer, layer2: BroadPhaseLayer) -> bool #c_call;
}

ObjectVsBroadPhaseLayerFilter_Create :: (data: *void, funcs: ObjectVsBroadPhaseLayerFilter_Funcs, allocator: Allocator) -> *ObjectVsBroadPhaseLayerFilter #foreign JoltC "JPH_ObjectVsBroadPhaseLayerFilter_Create";
ObjectVsBroadPhaseLayerFilter_Destroy :: (self: *ObjectVsBroadPhaseLayerFilter) -> void #foreign JoltC "JPH_ObjectVsBroadPhaseLayerFilter_Destroy";

ObjectLayerPairFilter_Funcs :: struct {
    Destruct:      #type (data: *void) -> void #c_call;
    ShouldCollide: #type (data: *void, layer1: ObjectLayer, layer2: ObjectLayer) -> bool #c_call;
}

ObjectLayerPairFilter_Create :: (data: *void, funcs: ObjectLayerPairFilter_Funcs, allocator: Allocator) -> *ObjectLayerPairFilter #foreign JoltC "JPH_ObjectLayerPairFilter_Create";
ObjectLayerPairFilter_Destroy :: (self: *ObjectLayerPairFilter) -> void #foreign JoltC "JPH_ObjectLayerPairFilter_Destroy";

BroadPhaseLayerFilter_Funcs :: struct {
    Destruct:      #type (data: *void) -> void #c_call;
    ShouldCollide: #type (data: *void, layer: BroadPhaseLayer) -> bool #c_call;
}

BroadPhaseLayerFilter_Create :: (data: *void, funcs: BroadPhaseLayerFilter_Funcs, allocator: Allocator) -> *BroadPhaseLayerFilter #foreign JoltC "JPH_BroadPhaseLayerFilter_Create";
BroadPhaseLayerFilter_Destroy :: (self: *BroadPhaseLayerFilter) -> void #foreign JoltC "JPH_BroadPhaseLayerFilter_Destroy";

ObjectLayerFilter_Funcs :: struct {
    Destruct:      #type (data: *void) -> void #c_call;
    ShouldCollide: #type (data: *void, layer: ObjectLayer) -> bool #c_call;
}

ObjectLayerFilter_Create :: (data: *void, funcs: ObjectLayerFilter_Funcs, allocator: Allocator) -> *ObjectLayerFilter #foreign JoltC "JPH_ObjectLayerFilter_Create";
ObjectLayerFilter_Destroy :: (self: *ObjectLayerFilter) -> void #foreign JoltC "JPH_ObjectLayerFilter_Destroy";

// Default filters
DefaultBroadPhaseLayerFilter :: struct {
    objectVsBroadPhaseLayerFilter: *ObjectVsBroadPhaseLayerFilter;
    layer:                         ObjectLayer;
}

DefaultBroadPhaseLayerFilter_ShouldCollide :: (data: *void, layer: BroadPhaseLayer) -> bool #foreign JoltC "JPH_DefaultBroadPhaseLayerFilter_ShouldCollide";
DefaultBroadPhaseLayerFilter_CreateFilter :: (filter: *DefaultBroadPhaseLayerFilter, allocator: Allocator) -> *BroadPhaseLayerFilter #foreign JoltC "JPH_DefaultBroadPhaseLayerFilter_CreateFilter";

DefaultObjectLayerFilter :: struct {
    objectLayerPairFilter: *ObjectLayerPairFilter;
    layer:                 ObjectLayer;
}

DefaultObjectLayerFilter_ShouldCollide :: (data: *void, layer: ObjectLayer) -> bool #foreign JoltC "JPH_DefaultObjectLayerFilter_ShouldCollide";
DefaultObjectLayerFilter_CreateFilter :: (filter: *DefaultObjectLayerFilter, allocator: Allocator) -> *ObjectLayerFilter #foreign JoltC "JPH_DefaultObjectLayerFilter_CreateFilter";

ShapeSettings :: struct {}
ConvexShapeSettings :: struct {}
SphereShapeSettings :: struct {}
BoxShapeSettings :: struct {}
PlaneShapeSettings :: struct {}
TriangleShapeSettings :: struct {}
CapsuleShapeSettings :: struct {}
TaperedCapsuleShapeSettings :: struct {}
CylinderShapeSettings :: struct {}
TaperedCylinderShapeSettings :: struct {}
ConvexHullShapeSettings :: struct {}
CompoundShapeSettings :: struct {}
StaticCompoundShapeSettings :: struct {}
MutableCompoundShapeSettings :: struct {}
MeshShapeSettings :: struct {}
HeightFieldShapeSettings :: struct {}
DecoratedShapeSettings :: struct {}
RotatedTranslatedShapeSettings :: struct {}
ScaledShapeSettings :: struct {}
OffsetCenterOfMassShapeSettings :: struct {}
EmptyShapeSettings :: struct {}

Shape :: struct {}
ConvexShape :: struct {}
SphereShape :: struct {}
BoxShape :: struct {}
PlaneShape :: struct {}
TriangleShape :: struct {}
CapsuleShape :: struct {}
TaperedCapsuleShape :: struct {}
CylinderShape :: struct {}
TaperedCylinderShape :: struct {}
ConvexHullShape :: struct {}
CompoundShape :: struct {}
StaticCompoundShape :: struct {}
MutableCompoundShape :: struct {}
MeshShape :: struct {}
HeightFieldShape :: struct {}
DecoratedShape :: struct {}
RotatedTranslatedShape :: struct {}
ScaledShape :: struct {}
OffsetCenterOfMassShape :: struct {}
EmptyShape :: struct {}

// @Todo: add aliases for inherited methods
ShapeSettings_Destroy :: (settings: *ShapeSettings) -> void #foreign JoltC "JPH_ShapeSettings_Destroy";
ShapeSettings_CreateShape :: (settings: *ShapeSettings) -> *Shape #foreign JoltC "JPH_ShapeSettings_CreateShape";
ShapeSettings_ClearCachedResult :: (settings: *ShapeSettings) -> void #foreign JoltC "JPH_ShapeSettings_ClearCachedResult";
ShapeSettings_SetUserData :: (settings: *ShapeSettings, userData: u64) -> void #foreign JoltC "JPH_ShapeSettings_SetUserData";
ShapeSettings_GetUserData :: (settings: *ShapeSettings) -> u64 #foreign JoltC "JPH_ShapeSettings_GetUserData";

EmptyShapeSettings_Create :: () -> *EmptyShapeSettings #foreign JoltC "JPH_EmptyShapeSettings_Create";
EmptyShapeSettings_Destroy :: (settings: *EmptyShapeSettings) -> void #foreign JoltC "JPH_EmptyShapeSettings_Destroy";
EmptyShapeSettings_CreateShape :: (settings: *EmptyShapeSettings) -> *EmptyShape #foreign JoltC "JPH_EmptyShapeSettings_CreateShape";
EmptyShapeSettings_SetCenterOfMass :: (settings: *EmptyShapeSettings, centerOfMass: Vec3) -> void #foreign JoltC "JPH_EmptyShapeSettings_SetCenterOfMass";
EmptyShapeSettings_GetCenterOfMass :: (settings: *EmptyShapeSettings) -> Vec3 #foreign JoltC "JPH_EmptyShapeSettings_GetCenterOfMass";

PlaneShapeSettings_Create :: (plane: Plane, material: *PhysicsMaterial, halfExtent: float) -> *PlaneShapeSettings #foreign JoltC "JPH_PlaneShapeSettings_Create";
PlaneShapeSettings_Destroy :: (settings: *PlaneShapeSettings) -> void #foreign JoltC "JPH_PlaneShapeSettings_Destroy";
PlaneShapeSettings_CreateShape :: (settings: *PlaneShapeSettings) -> *PlaneShape #foreign JoltC "JPH_PlaneShapeSettings_CreateShape";
PlaneShapeSettings_SetPlane :: (settings: *PlaneShapeSettings, plane: Plane) -> void #foreign JoltC "JPH_PlaneShapeSettings_SetPlane";
PlaneShapeSettings_GetPlane :: (settings: *PlaneShapeSettings) -> Plane #foreign JoltC "JPH_PlaneShapeSettings_GetPlane";
PlaneShapeSettings_SetPhysicsMaterial :: (settings: *PlaneShapeSettings, material: *PhysicsMaterial) -> void #foreign JoltC "JPH_PlaneShapeSettings_SetPhysicsMaterial";
PlaneShapeSettings_GetPhysicsMaterial :: (settings: *PlaneShapeSettings) -> *PhysicsMaterial #foreign JoltC "JPH_PlaneShapeSettings_GetPhysicsMaterial";
PlaneShapeSettings_SetHalfExtent :: (settings: *PlaneShapeSettings, halfExtent: float) -> void #foreign JoltC "JPH_PlaneShapeSettings_SetHalfExtent";
PlaneShapeSettings_GetHalfExtent :: (settings: *PlaneShapeSettings) -> float #foreign JoltC "JPH_PlaneShapeSettings_GetHalfExtent";

OffsetCenterOfMassShapeSettings_Create :: () -> *OffsetCenterOfMassShapeSettings #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_Create";
OffsetCenterOfMassShapeSettings_Destroy :: (settings: *OffsetCenterOfMassShapeSettings) -> void #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_Destroy";
OffsetCenterOfMassShapeSettings_CreateShape :: (settings: *OffsetCenterOfMassShapeSettings) -> *OffsetCenterOfMassShape #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_CreateShape";
OffsetCenterOfMassShapeSettings_SetInnerShape :: (settings: *OffsetCenterOfMassShapeSettings, innerShape: *Shape) -> void #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_SetInnerShape";
OffsetCenterOfMassShapeSettings_GetInnerShape :: (settings: *OffsetCenterOfMassShapeSettings) -> *Shape #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_GetInnerShape";
OffsetCenterOfMassShapeSettings_SetInnerShapeSettings :: (settings: *OffsetCenterOfMassShapeSettings, innerShapeSettings: *ShapeSettings) -> void #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_SetInnerShapeSettings";
OffsetCenterOfMassShapeSettings_GetInnerShapeSettings :: (settings: *OffsetCenterOfMassShapeSettings) -> *ShapeSettings #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_GetInnerShapeSettings";
OffsetCenterOfMassShapeSettings_SetOffset :: (settings: *OffsetCenterOfMassShapeSettings, offset: Vec3) -> void #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_SetOffset";
OffsetCenterOfMassShapeSettings_GetOffset :: (settings: *OffsetCenterOfMassShapeSettings) -> Vec3 #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_GetOffset";

RotatedTranslatedShapeSettings_Create :: () -> *RotatedTranslatedShapeSettings #foreign JoltC "JPH_RotatedTranslatedShapeSettings_Create";
RotatedTranslatedShapeSettings_Destroy :: (settings: *RotatedTranslatedShapeSettings) -> void #foreign JoltC "JPH_RotatedTranslatedShapeSettings_Destroy";
RotatedTranslatedShapeSettings_CreateShape :: (settings: *RotatedTranslatedShapeSettings) -> *RotatedTranslatedShape #foreign JoltC "JPH_RotatedTranslatedShapeSettings_CreateShape";
RotatedTranslatedShapeSettings_SetInnerShape :: (settings: *RotatedTranslatedShapeSettings, innerShape: *Shape) -> void #foreign JoltC "JPH_RotatedTranslatedShapeSettings_SetInnerShape";
RotatedTranslatedShapeSettings_GetInnerShape :: (settings: *RotatedTranslatedShapeSettings) -> *Shape #foreign JoltC "JPH_RotatedTranslatedShapeSettings_GetInnerShape";
RotatedTranslatedShapeSettings_SetInnerShapeSettings :: (settings: *RotatedTranslatedShapeSettings, innerShapeSettings: *ShapeSettings) -> void #foreign JoltC "JPH_RotatedTranslatedShapeSettings_SetInnerShapeSettings";
RotatedTranslatedShapeSettings_GetInnerShapeSettings :: (settings: *RotatedTranslatedShapeSettings) -> *ShapeSettings #foreign JoltC "JPH_RotatedTranslatedShapeSettings_GetInnerShapeSettings";
RotatedTranslatedShapeSettings_SetPosition :: (settings: *RotatedTranslatedShapeSettings, position: Vec3) -> void #foreign JoltC "JPH_RotatedTranslatedShapeSettings_SetPosition";
RotatedTranslatedShapeSettings_GetPosition :: (settings: *RotatedTranslatedShapeSettings) -> Vec3 #foreign JoltC "JPH_RotatedTranslatedShapeSettings_GetPosition";
RotatedTranslatedShapeSettings_SetRotation :: (settings: *RotatedTranslatedShapeSettings, rotation: Quat) -> void #foreign JoltC "JPH_RotatedTranslatedShapeSettings_SetRotation";
RotatedTranslatedShapeSettings_GetRotation :: (settings: *RotatedTranslatedShapeSettings) -> Quat #foreign JoltC "JPH_RotatedTranslatedShapeSettings_GetRotation";

ScaledShapeSettings_Create :: () -> *ScaledShapeSettings #foreign JoltC "JPH_ScaledShapeSettings_Create";
ScaledShapeSettings_Destroy :: (settings: *ScaledShapeSettings) -> void #foreign JoltC "JPH_ScaledShapeSettings_Destroy";
ScaledShapeSettings_CreateShape :: (settings: *ScaledShapeSettings) -> *ScaledShape #foreign JoltC "JPH_ScaledShapeSettings_CreateShape";
ScaledShapeSettings_SetInnerShape :: (settings: *ScaledShapeSettings, innerShape: *Shape) -> void #foreign JoltC "JPH_ScaledShapeSettings_SetInnerShape";
ScaledShapeSettings_GetInnerShape :: (settings: *ScaledShapeSettings) -> *Shape #foreign JoltC "JPH_ScaledShapeSettings_GetInnerShape";
ScaledShapeSettings_SetInnerShapeSettings :: (settings: *ScaledShapeSettings, innerShapeSettings: *ShapeSettings) -> void #foreign JoltC "JPH_ScaledShapeSettings_SetInnerShapeSettings";
ScaledShapeSettings_GetInnerShapeSettings :: (settings: *ScaledShapeSettings) -> *ShapeSettings #foreign JoltC "JPH_ScaledShapeSettings_GetInnerShapeSettings";
ScaledShapeSettings_SetScale :: (settings: *ScaledShapeSettings, scale: Vec3) -> void #foreign JoltC "JPH_ScaledShapeSettings_SetScale";
ScaledShapeSettings_GetScale :: (settings: *ScaledShapeSettings) -> Vec3 #foreign JoltC "JPH_ScaledShapeSettings_GetScale";

CompoundShapeSettings_Destroy :: (settings: *CompoundShapeSettings) -> void #foreign JoltC "JPH_CompoundShapeSettings_Destroy";
CompoundShapeSettings_CreateShape :: (settings: *CompoundShapeSettings) -> *CompoundShape #foreign JoltC "JPH_CompoundShapeSettings_CreateShape";
CompoundShapeSettings_AddShape :: (settings: *CompoundShapeSettings, position: Vec3, rotation: Quat, subShape: *Shape, userData: u32) -> void #foreign JoltC "JPH_CompoundShapeSettings_AddShape";
CompoundShapeSettings_AddShapeSettings :: (settings: *CompoundShapeSettings, position: Vec3, rotation: Quat, subShapeSettings: *ShapeSettings, userData: u32) -> void #foreign JoltC "JPH_CompoundShapeSettings_AddShapeSettings";

StaticCompoundShapeSettings_Create :: () -> *StaticCompoundShapeSettings #foreign JoltC "JPH_StaticCompoundShapeSettings_Create";
StaticCompoundShapeSettings_Destroy :: (settings: *StaticCompoundShapeSettings) -> void #foreign JoltC "JPH_StaticCompoundShapeSettings_Destroy";
StaticCompoundShapeSettings_CreateShape :: (settings: *StaticCompoundShapeSettings) -> *StaticCompoundShape #foreign JoltC "JPH_StaticCompoundShapeSettings_CreateShape";

MutableCompoundShapeSettings_Create :: () -> *MutableCompoundShapeSettings #foreign JoltC "JPH_MutableCompoundShapeSettings_Create";
MutableCompoundShapeSettings_Destroy :: (settings: *MutableCompoundShapeSettings) -> void #foreign JoltC "JPH_MutableCompoundShapeSettings_Destroy";
MutableCompoundShapeSettings_CreateShape :: (settings: *MutableCompoundShapeSettings) -> *MutableCompoundShape #foreign JoltC "JPH_MutableCompoundShapeSettings_CreateShape";

ConvexShapeSettings_Destroy :: (settings: *ConvexShapeSettings) -> void #foreign JoltC "JPH_ConvexShapeSettings_Destroy";
ConvexShapeSettings_CreateShape :: (settings: *ConvexShapeSettings) -> *ConvexShape #foreign JoltC "JPH_ConvexShapeSettings_CreateShape";
ConvexShapeSettings_SetPhysicsMaterial :: (settings: *ConvexShapeSettings, material: *PhysicsMaterial) -> void #foreign JoltC "JPH_ConvexShapeSettings_SetPhysicsMaterial";
ConvexShapeSettings_GetPhysicsMaterial :: (settings: *ConvexShapeSettings) -> *PhysicsMaterial #foreign JoltC "JPH_ConvexShapeSettings_GetPhysicsMaterial";
ConvexShapeSettings_SetDensity :: (settings: *ConvexShapeSettings, density: float) -> void #foreign JoltC "JPH_ConvexShapeSettings_SetDensity";
ConvexShapeSettings_GetDensity :: (settings: *ConvexShapeSettings) -> float #foreign JoltC "JPH_ConvexShapeSettings_GetDensity";

BoxShapeSettings_Create :: () -> *BoxShapeSettings #foreign JoltC "JPH_BoxShapeSettings_Create";
BoxShapeSettings_Destroy :: (settings: *BoxShapeSettings) -> void #foreign JoltC "JPH_BoxShapeSettings_Destroy";
BoxShapeSettings_CreateShape :: (settings: *BoxShapeSettings) -> *BoxShape #foreign JoltC "JPH_BoxShapeSettings_CreateShape";
BoxShapeSettings_SetHalfExtent :: (settings: *BoxShapeSettings, halfExtent: Vec3) -> void #foreign JoltC "JPH_BoxShapeSettings_SetHalfExtent";
BoxShapeSettings_GetHalfExtent :: (settings: *BoxShapeSettings) -> Vec3 #foreign JoltC "JPH_BoxShapeSettings_GetHalfExtent";
BoxShapeSettings_SetConvexRadius :: (settings: *BoxShapeSettings, convexRadius: float) -> void #foreign JoltC "JPH_BoxShapeSettings_SetConvexRadius";
BoxShapeSettings_GetConvexRadius :: (settings: *BoxShapeSettings) -> float #foreign JoltC "JPH_BoxShapeSettings_GetConvexRadius";

SphereShapeSettings_Create :: () -> *SphereShapeSettings #foreign JoltC "JPH_SphereShapeSettings_Create";
SphereShapeSettings_Destroy :: (settings: *SphereShapeSettings) -> void #foreign JoltC "JPH_SphereShapeSettings_Destroy";
SphereShapeSettings_CreateShape :: (settings: *SphereShapeSettings) -> *SphereShape #foreign JoltC "JPH_SphereShapeSettings_CreateShape";
SphereShapeSettings_SetRadius :: (settings: *SphereShapeSettings, radius: float) -> void #foreign JoltC "JPH_SphereShapeSettings_SetRadius";
SphereShapeSettings_GetRadius :: (settings: *SphereShapeSettings) -> float #foreign JoltC "JPH_SphereShapeSettings_GetRadius";

CapsuleShapeSettings_Create :: () -> *CapsuleShapeSettings #foreign JoltC "JPH_CapsuleShapeSettings_Create";
CapsuleShapeSettings_Destroy :: (settings: *CapsuleShapeSettings) -> void #foreign JoltC "JPH_CapsuleShapeSettings_Destroy";
CapsuleShapeSettings_CreateShape :: (settings: *CapsuleShapeSettings) -> *CapsuleShape #foreign JoltC "JPH_CapsuleShapeSettings_CreateShape";
CapsuleShapeSettings_SetRadius :: (settings: *CapsuleShapeSettings, radius: float) -> void #foreign JoltC "JPH_CapsuleShapeSettings_SetRadius";
CapsuleShapeSettings_GetRadius :: (settings: *CapsuleShapeSettings) -> float #foreign JoltC "JPH_CapsuleShapeSettings_GetRadius";
CapsuleShapeSettings_SetHalfHeightOfCylinder :: (settings: *CapsuleShapeSettings, halfHeightOfCylinder: float) -> void #foreign JoltC "JPH_CapsuleShapeSettings_SetHalfHeightOfCylinder";
CapsuleShapeSettings_GetHalfHeightOfCylinder :: (settings: *CapsuleShapeSettings) -> float #foreign JoltC "JPH_CapsuleShapeSettings_GetHalfHeightOfCylinder";
CapsuleShapeSettings_IsValid :: (settings: *CapsuleShapeSettings) -> bool #foreign JoltC "JPH_CapsuleShapeSettings_IsValid";
CapsuleShapeSettings_IsSphere :: (settings: *CapsuleShapeSettings) -> bool #foreign JoltC "JPH_CapsuleShapeSettings_IsSphere";

TaperedCapsuleShapeSettings_Create :: () -> *TaperedCapsuleShapeSettings #foreign JoltC "JPH_TaperedCapsuleShapeSettings_Create";
TaperedCapsuleShapeSettings_Destroy :: (settings: *TaperedCapsuleShapeSettings) -> void #foreign JoltC "JPH_TaperedCapsuleShapeSettings_Destroy";
TaperedCapsuleShapeSettings_CreateShape :: (settings: *TaperedCapsuleShapeSettings) -> *TaperedCapsuleShape #foreign JoltC "JPH_TaperedCapsuleShapeSettings_CreateShape";
TaperedCapsuleShapeSettings_SetHalfHeightOfTaperedCylinder :: (settings: *TaperedCapsuleShapeSettings, halfHeightOfTaperedCylinder: float) -> void #foreign JoltC "JPH_TaperedCapsuleShapeSettings_SetHalfHeightOfTaperedCylinder";
TaperedCapsuleShapeSettings_GetHalfHeightOfTaperedCylinder :: (settings: *TaperedCapsuleShapeSettings) -> float #foreign JoltC "JPH_TaperedCapsuleShapeSettings_GetHalfHeightOfTaperedCylinder";
TaperedCapsuleShapeSettings_SetTopRadius :: (settings: *TaperedCapsuleShapeSettings, topRadius: float) -> void #foreign JoltC "JPH_TaperedCapsuleShapeSettings_SetTopRadius";
TaperedCapsuleShapeSettings_GetTopRadius :: (settings: *TaperedCapsuleShapeSettings) -> float #foreign JoltC "JPH_TaperedCapsuleShapeSettings_GetTopRadius";
TaperedCapsuleShapeSettings_SetBottomRadius :: (settings: *TaperedCapsuleShapeSettings, bottomRadius: float) -> void #foreign JoltC "JPH_TaperedCapsuleShapeSettings_SetBottomRadius";
TaperedCapsuleShapeSettings_GetBottomRadius :: (settings: *TaperedCapsuleShapeSettings) -> float #foreign JoltC "JPH_TaperedCapsuleShapeSettings_GetBottomRadius";
TaperedCapsuleShapeSettings_IsValid :: (settings: *TaperedCapsuleShapeSettings) -> bool #foreign JoltC "JPH_TaperedCapsuleShapeSettings_IsValid";
TaperedCapsuleShapeSettings_IsSphere :: (settings: *TaperedCapsuleShapeSettings) -> bool #foreign JoltC "JPH_TaperedCapsuleShapeSettings_IsSphere";

CylinderShapeSettings_Create :: () -> *CylinderShapeSettings #foreign JoltC "JPH_CylinderShapeSettings_Create";
CylinderShapeSettings_Destroy :: (settings: *CylinderShapeSettings) -> void #foreign JoltC "JPH_CylinderShapeSettings_Destroy";
CylinderShapeSettings_CreateShape :: (settings: *CylinderShapeSettings) -> *CylinderShape #foreign JoltC "JPH_CylinderShapeSettings_CreateShape";
CylinderShapeSettings_SetHalfHeight :: (settings: *CylinderShapeSettings, halfHeight: float) -> void #foreign JoltC "JPH_CylinderShapeSettings_SetHalfHeight";
CylinderShapeSettings_GetHalfHeight :: (settings: *CylinderShapeSettings) -> float #foreign JoltC "JPH_CylinderShapeSettings_GetHalfHeight";
CylinderShapeSettings_SetRadius :: (settings: *CylinderShapeSettings, radius: float) -> void #foreign JoltC "JPH_CylinderShapeSettings_SetRadius";
CylinderShapeSettings_GetRadius :: (settings: *CylinderShapeSettings) -> float #foreign JoltC "JPH_CylinderShapeSettings_GetRadius";
CylinderShapeSettings_SetConvexRadius :: (settings: *CylinderShapeSettings, convexRadius: float) -> void #foreign JoltC "JPH_CylinderShapeSettings_SetConvexRadius";
CylinderShapeSettings_GetConvexRadius :: (settings: *CylinderShapeSettings) -> float #foreign JoltC "JPH_CylinderShapeSettings_GetConvexRadius";

TaperedCylinderShapeSettings_Create :: () -> *TaperedCylinderShapeSettings #foreign JoltC "JPH_TaperedCylinderShapeSettings_Create";
TaperedCylinderShapeSettings_Destroy :: (settings: *TaperedCylinderShapeSettings) -> void #foreign JoltC "JPH_TaperedCylinderShapeSettings_Destroy";
TaperedCylinderShapeSettings_CreateShape :: (settings: *TaperedCylinderShapeSettings) -> *TaperedCylinderShape #foreign JoltC "JPH_TaperedCylinderShapeSettings_CreateShape";
TaperedCylinderShapeSettings_SetHalfHeight :: (settings: *TaperedCylinderShapeSettings, halfHeight: float) -> void #foreign JoltC "JPH_TaperedCylinderShapeSettings_SetHalfHeight";
TaperedCylinderShapeSettings_GetHalfHeight :: (settings: *TaperedCylinderShapeSettings) -> float #foreign JoltC "JPH_TaperedCylinderShapeSettings_GetHalfHeight";
TaperedCylinderShapeSettings_SetTopRadius :: (settings: *TaperedCylinderShapeSettings, topRadius: float) -> void #foreign JoltC "JPH_TaperedCylinderShapeSettings_SetTopRadius";
TaperedCylinderShapeSettings_GetTopRadius :: (settings: *TaperedCylinderShapeSettings) -> float #foreign JoltC "JPH_TaperedCylinderShapeSettings_GetTopRadius";
TaperedCylinderShapeSettings_SetBottomRadius :: (settings: *TaperedCylinderShapeSettings, bottomRadius: float) -> void #foreign JoltC "JPH_TaperedCylinderShapeSettings_SetBottomRadius";
TaperedCylinderShapeSettings_GetBottomRadius :: (settings: *TaperedCylinderShapeSettings) -> float #foreign JoltC "JPH_TaperedCylinderShapeSettings_GetBottomRadius";
TaperedCylinderShapeSettings_SetConvexRadius :: (settings: *TaperedCylinderShapeSettings, convexRadius: float) -> void #foreign JoltC "JPH_TaperedCylinderShapeSettings_SetConvexRadius";
TaperedCylinderShapeSettings_GetConvexRadius :: (settings: *TaperedCylinderShapeSettings) -> float #foreign JoltC "JPH_TaperedCylinderShapeSettings_GetConvexRadius";

TriangleShapeSettings_Create :: () -> *TriangleShapeSettings #foreign JoltC "JPH_TriangleShapeSettings_Create";
TriangleShapeSettings_Destroy :: (settings: *TriangleShapeSettings) -> void #foreign JoltC "JPH_TriangleShapeSettings_Destroy";
TriangleShapeSettings_CreateShape :: (settings: *TriangleShapeSettings) -> *TriangleShape #foreign JoltC "JPH_TriangleShapeSettings_CreateShape";
TriangleShapeSettings_SetV1 :: (settings: *TriangleShapeSettings, v1: Vec3) -> void #foreign JoltC "JPH_TriangleShapeSettings_SetV1";
TriangleShapeSettings_GetV1 :: (settings: *TriangleShapeSettings) -> Vec3 #foreign JoltC "JPH_TriangleShapeSettings_GetV1";
TriangleShapeSettings_SetV2 :: (settings: *TriangleShapeSettings, v2: Vec3) -> void #foreign JoltC "JPH_TriangleShapeSettings_SetV2";
TriangleShapeSettings_GetV2 :: (settings: *TriangleShapeSettings) -> Vec3 #foreign JoltC "JPH_TriangleShapeSettings_GetV2";
TriangleShapeSettings_SetV3 :: (settings: *TriangleShapeSettings, v3: Vec3) -> void #foreign JoltC "JPH_TriangleShapeSettings_SetV3";
TriangleShapeSettings_GetV3 :: (settings: *TriangleShapeSettings) -> Vec3 #foreign JoltC "JPH_TriangleShapeSettings_GetV3";
TriangleShapeSettings_SetPoints :: (settings: *TriangleShapeSettings, v1: Vec3, v2: Vec3, v3: Vec3) -> void #foreign JoltC "JPH_TriangleShapeSettings_SetPoints";
TriangleShapeSettings_GetPoints :: (settings: *TriangleShapeSettings, outV1: *Vec3, outV2: *Vec3, outV3: *Vec3) -> void #foreign JoltC "JPH_TriangleShapeSettings_GetPoints";
TriangleShapeSettings_SetConvexRadius :: (settings: *TriangleShapeSettings, convexRadius: float) -> void #foreign JoltC "JPH_TriangleShapeSettings_SetConvexRadius";
TriangleShapeSettings_GetConvexRadius :: (settings: *TriangleShapeSettings) -> float #foreign JoltC "JPH_TriangleShapeSettings_GetConvexRadius";

ConvexHullShapeSettings_Create :: () -> *ConvexHullShapeSettings #foreign JoltC "JPH_ConvexHullShapeSettings_Create";
ConvexHullShapeSettings_Destroy :: (settings: *ConvexHullShapeSettings) -> void #foreign JoltC "JPH_ConvexHullShapeSettings_Destroy";
ConvexHullShapeSettings_CreateShape :: (settings: *ConvexHullShapeSettings) -> *ConvexHullShape #foreign JoltC "JPH_ConvexHullShapeSettings_CreateShape";
ConvexHullShapeSettings_AddPoints :: (settings: *ConvexHullShapeSettings, points: *Vec3, count: u32) -> void #foreign JoltC "JPH_ConvexHullShapeSettings_AddPoints";
ConvexHullShapeSettings_GetNumPoints :: (settings: *ConvexHullShapeSettings) -> u32 #foreign JoltC "JPH_ConvexHullShapeSettings_GetNumPoints";
ConvexHullShapeSettings_GetPoints :: (settings: *ConvexHullShapeSettings) -> *Vec3 #foreign JoltC "JPH_ConvexHullShapeSettings_GetPoints";
ConvexHullShapeSettings_SetMaxConvexRadius :: (settings: *ConvexHullShapeSettings, maxConvexRadius: float) -> void #foreign JoltC "JPH_ConvexHullShapeSettings_SetMaxConvexRadius";
ConvexHullShapeSettings_GetMaxConvexRadius :: (settings: *ConvexHullShapeSettings) -> float #foreign JoltC "JPH_ConvexHullShapeSettings_GetMaxConvexRadius";
ConvexHullShapeSettings_SetMaxErrorConvexRadius :: (settings: *ConvexHullShapeSettings, maxErrorConvexRadius: float) -> void #foreign JoltC "JPH_ConvexHullShapeSettings_SetMaxErrorConvexRadius";
ConvexHullShapeSettings_GetMaxErrorConvexRadius :: (settings: *ConvexHullShapeSettings) -> float #foreign JoltC "JPH_ConvexHullShapeSettings_GetMaxErrorConvexRadius";
ConvexHullShapeSettings_SetHullTolerance :: (settings: *ConvexHullShapeSettings, hullTolerance: float) -> void #foreign JoltC "JPH_ConvexHullShapeSettings_SetHullTolerance";
ConvexHullShapeSettings_GetHullTolerance :: (settings: *ConvexHullShapeSettings) -> float #foreign JoltC "JPH_ConvexHullShapeSettings_GetHullTolerance";

IndexedTriangle :: struct {
    idx:           [3] u32;
    materialIndex: u32;
    userData:      u32;
}

MeshShapeSettings_EBuildQuality :: u32;
MeshShapeSettings_EBuildQuality_1 :: enum u32 {
    FavorRuntimePerformance :: 0;
    FavorBuildSpeed         :: 1;

    JPH_MeshShapeSettings_EBuildQuality_FavorRuntimePerformance :: FavorRuntimePerformance;
    JPH_MeshShapeSettings_EBuildQuality_FavorBuildSpeed         :: FavorBuildSpeed;
}

MeshShapeSettings_Create :: () -> *MeshShapeSettings #foreign JoltC "JPH_MeshShapeSettings_Create";
MeshShapeSettings_Destroy :: (settings: *MeshShapeSettings) -> void #foreign JoltC "JPH_MeshShapeSettings_Destroy";
MeshShapeSettings_CreateShape :: (settings: *MeshShapeSettings) -> *MeshShape #foreign JoltC "JPH_MeshShapeSettings_CreateShape";
MeshShapeSettings_Sanitize :: (settings: *MeshShapeSettings) -> void #foreign JoltC "JPH_MeshShapeSettings_Sanitize";
MeshShapeSettings_AddVertex :: (settings: *MeshShapeSettings, vertex: Float3) -> void #foreign JoltC "JPH_MeshShapeSettings_AddVertex";
MeshShapeSettings_AddVertices :: (settings: *MeshShapeSettings, vertices: *Float3, count: u32) -> void #foreign JoltC "JPH_MeshShapeSettings_AddVertices";
MeshShapeSettings_GetNumVertices :: (settings: *MeshShapeSettings) -> u32 #foreign JoltC "JPH_MeshShapeSettings_GetNumVertices";
MeshShapeSettings_GetVertices :: (settings: *MeshShapeSettings) -> *Float3 #foreign JoltC "JPH_MeshShapeSettings_GetVertices";
MeshShapeSettings_AddIndexedTriangle :: (settings: *MeshShapeSettings, triangle: IndexedTriangle) -> void #foreign JoltC "JPH_MeshShapeSettings_AddIndexedTriangle";
MeshShapeSettings_AddIndexedTriangles :: (settings: *MeshShapeSettings, triangles: *IndexedTriangle, count: u32) -> void #foreign JoltC "JPH_MeshShapeSettings_AddIndexedTriangles";
MeshShapeSettings_GetNumIndexedTriangles :: (settings: *MeshShapeSettings) -> u32 #foreign JoltC "JPH_MeshShapeSettings_GetNumIndexedTriangles";
MeshShapeSettings_GetIndexedTriangles :: (settings: *MeshShapeSettings) -> *IndexedTriangle #foreign JoltC "JPH_MeshShapeSettings_GetIndexedTriangles";
MeshShapeSettings_AddMaterial :: (settings: *MeshShapeSettings, material: *PhysicsMaterial) -> void #foreign JoltC "JPH_MeshShapeSettings_AddMaterial";
MeshShapeSettings_AddMaterials :: (settings: *MeshShapeSettings, materials: **PhysicsMaterial, count: u32) -> void #foreign JoltC "JPH_MeshShapeSettings_AddMaterials";
MeshShapeSettings_GetNumMaterials :: (settings: *MeshShapeSettings) -> u32 #foreign JoltC "JPH_MeshShapeSettings_GetNumMaterials";
MeshShapeSettings_GetMaterial :: (settings: *MeshShapeSettings, index: u32) -> *PhysicsMaterial #foreign JoltC "JPH_MeshShapeSettings_GetMaterial";
MeshShapeSettings_SetMaxTrianglesPerLeaf :: (settings: *MeshShapeSettings, maxTrianglesPerLeaf: u32) -> void #foreign JoltC "JPH_MeshShapeSettings_SetMaxTrianglesPerLeaf";
MeshShapeSettings_GetMaxTrianglesPerLeaf :: (settings: *MeshShapeSettings) -> u32 #foreign JoltC "JPH_MeshShapeSettings_GetMaxTrianglesPerLeaf";
MeshShapeSettings_SetActiveEdgeCosThresholdAngle :: (settings: *MeshShapeSettings, activeEdgeCosThresholdAngle: float) -> void #foreign JoltC "JPH_MeshShapeSettings_SetActiveEdgeCosThresholdAngle";
MeshShapeSettings_GetActiveEdgeCosThresholdAngle :: (settings: *MeshShapeSettings) -> float #foreign JoltC "JPH_MeshShapeSettings_GetActiveEdgeCosThresholdAngle";
MeshShapeSettings_SetPerTriangleUserData :: (settings: *MeshShapeSettings, perTriangleUserData: bool) -> void #foreign JoltC "JPH_MeshShapeSettings_SetPerTriangleUserData";
MeshShapeSettings_GetPerTriangleUserData :: (settings: *MeshShapeSettings) -> bool #foreign JoltC "JPH_MeshShapeSettings_GetPerTriangleUserData";
MeshShapeSettings_SetBuildQuality :: (settings: *MeshShapeSettings, buildQuality: MeshShapeSettings_EBuildQuality) -> void #foreign JoltC "JPH_MeshShapeSettings_SetBuildQuality";
MeshShapeSettings_GetBuildQuality :: (settings: *MeshShapeSettings) -> MeshShapeSettings_EBuildQuality #foreign JoltC "JPH_MeshShapeSettings_GetBuildQuality";

HeightFieldShapeSettings_Create :: () -> *HeightFieldShapeSettings #foreign JoltC "JPH_HeightFieldShapeSettings_Create";
HeightFieldShapeSettings_Destroy :: (settings: *HeightFieldShapeSettings) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_Destroy";
HeightFieldShapeSettings_CreateShape :: (settings: *HeightFieldShapeSettings) -> *HeightFieldShape #foreign JoltC "JPH_HeightFieldShapeSettings_CreateShape";
HeightFieldShapeSettings_DetermineMinAndMaxSample :: (settings: *HeightFieldShapeSettings, outMinValue: *float, outMaxValue: *float, outQuantizationScale: *float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_DetermineMinAndMaxSample";
HeightFieldShapeSettings_CalculateBitsPerSampleForError :: (settings: *HeightFieldShapeSettings, maxError: float) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_CalculateBitsPerSampleForError";
HeightFieldShapeSettings_AddHeightSample :: (settings: *HeightFieldShapeSettings, sample: float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_AddHeightSample";
HeightFieldShapeSettings_AddHeightSamples :: (settings: *HeightFieldShapeSettings, samples: *float, count: u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_AddHeightSamples";
HeightFieldShapeSettings_GetNumHeightSamples :: (settings: *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetNumHeightSamples";
HeightFieldShapeSettings_GetHeightSamples :: (settings: *HeightFieldShapeSettings) -> *float #foreign JoltC "JPH_HeightFieldShapeSettings_GetHeightSamples";
HeightFieldShapeSettings_AddMaterialIndex :: (settings: *HeightFieldShapeSettings, materialIndex: u8) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_AddMaterialIndex";
HeightFieldShapeSettings_AddMaterialIndices :: (settings: *HeightFieldShapeSettings, materialIndices: *u8, count: u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_AddMaterialIndices";
HeightFieldShapeSettings_GetNumMaterialIndices :: (settings: *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetNumMaterialIndices";
HeightFieldShapeSettings_GetMaterialIndices :: (settings: *HeightFieldShapeSettings) -> *u8 #foreign JoltC "JPH_HeightFieldShapeSettings_GetMaterialIndices";
HeightFieldShapeSettings_AddMaterial :: (settings: *HeightFieldShapeSettings, material: *PhysicsMaterial) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_AddMaterial";
HeightFieldShapeSettings_AddMaterials :: (settings: *HeightFieldShapeSettings, materials: **PhysicsMaterial, count: u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_AddMaterials";
HeightFieldShapeSettings_GetNumMaterials :: (settings: *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetNumMaterials";
HeightFieldShapeSettings_GetMaterial :: (settings: *HeightFieldShapeSettings, index: u32) -> *PhysicsMaterial #foreign JoltC "JPH_HeightFieldShapeSettings_GetMaterial";
HeightFieldShapeSettings_SetOffset :: (settings: *HeightFieldShapeSettings, offset: Vec3) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetOffset";
HeightFieldShapeSettings_GetOffset :: (settings: *HeightFieldShapeSettings) -> Vec3 #foreign JoltC "JPH_HeightFieldShapeSettings_GetOffset";
HeightFieldShapeSettings_SetScale :: (settings: *HeightFieldShapeSettings, scale: Vec3) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetScale";
HeightFieldShapeSettings_GetScale :: (settings: *HeightFieldShapeSettings) -> Vec3 #foreign JoltC "JPH_HeightFieldShapeSettings_GetScale";
HeightFieldShapeSettings_SetSampleCount :: (settings: *HeightFieldShapeSettings, sampleCount: u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetSampleCount";
HeightFieldShapeSettings_GetSampleCount :: (settings: *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetSampleCount";
HeightFieldShapeSettings_SetMinHeightValue :: (settings: *HeightFieldShapeSettings, minHeightValue: float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetMinHeightValue";
HeightFieldShapeSettings_GetMinHeightValue :: (settings: *HeightFieldShapeSettings) -> float #foreign JoltC "JPH_HeightFieldShapeSettings_GetMinHeightValue";
HeightFieldShapeSettings_SetMaxHeightValue :: (settings: *HeightFieldShapeSettings, maxHeightValue: float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetMaxHeightValue";
HeightFieldShapeSettings_GetMaxHeightValue :: (settings: *HeightFieldShapeSettings) -> float #foreign JoltC "JPH_HeightFieldShapeSettings_GetMaxHeightValue";
HeightFieldShapeSettings_SetMaterialsCapacity :: (settings: *HeightFieldShapeSettings, materialsCapacity: u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetMaterialsCapacity";
HeightFieldShapeSettings_GetMaterialsCapacity :: (settings: *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetMaterialsCapacity";
HeightFieldShapeSettings_SetBlockSize :: (settings: *HeightFieldShapeSettings, blockSize: u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetBlockSize";
HeightFieldShapeSettings_GetBlockSize :: (settings: *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetBlockSize";
HeightFieldShapeSettings_SetBitsPerSample :: (settings: *HeightFieldShapeSettings, bitsPerSample: u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetBitsPerSample";
HeightFieldShapeSettings_GetBitsPerSample :: (settings: *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetBitsPerSample";
HeightFieldShapeSettings_SetActiveEdgeCosThresholdAngle :: (settings: *HeightFieldShapeSettings, activeEdgeCosThresholdAngle: float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetActiveEdgeCosThresholdAngle";
HeightFieldShapeSettings_GetActiveEdgeCosThresholdAngle :: (settings: *HeightFieldShapeSettings) -> float #foreign JoltC "JPH_HeightFieldShapeSettings_GetActiveEdgeCosThresholdAngle";

// Shape
SubShapeID :: u32;

Shape_EShapeType :: u8;
Shape_EShapeType_1 :: enum u32 {
    Convex      :: 0;
    Compound    :: 1;
    Decorated   :: 2;
    Mesh        :: 3;
    HeightField :: 4;
    SoftBody    :: 5;
    User1       :: 6;
    User2       :: 7;
    User3       :: 8;
    User4       :: 9;
    Plane       :: 10;
    Empty       :: 11;

    JPH_Shape_EShapeType_Convex      :: Convex;
    JPH_Shape_EShapeType_Compound    :: Compound;
    JPH_Shape_EShapeType_Decorated   :: Decorated;
    JPH_Shape_EShapeType_Mesh        :: Mesh;
    JPH_Shape_EShapeType_HeightField :: HeightField;
    JPH_Shape_EShapeType_SoftBody    :: SoftBody;
    JPH_Shape_EShapeType_User1       :: User1;
    JPH_Shape_EShapeType_User2       :: User2;
    JPH_Shape_EShapeType_User3       :: User3;
    JPH_Shape_EShapeType_User4       :: User4;
    JPH_Shape_EShapeType_Plane       :: Plane;
    JPH_Shape_EShapeType_Empty       :: Empty;
}

Shape_EShapeSubType :: u8;
Shape_EShapeSubType_1 :: enum u32 {
    Sphere             :: 0;
    Box                :: 1;
    Triangle           :: 2;
    Capsule            :: 3;
    TaperedCapsule     :: 4;
    Cylinder           :: 5;
    ConvexHull         :: 6;
    StaticCompound     :: 7;
    MutableCompound    :: 8;
    RotatedTranslated  :: 9;
    Scaled             :: 10;
    OffsetCenterOfMass :: 11;
    Mesh               :: 12;
    HeightField        :: 13;
    SoftBody           :: 14;
    User1              :: 15;
    User2              :: 16;
    User3              :: 17;
    User4              :: 18;
    User5              :: 19;
    User6              :: 20;
    User7              :: 21;
    User8              :: 22;
    UserConvex1        :: 23;
    UserConvex2        :: 24;
    UserConvex3        :: 25;
    UserConvex4        :: 26;
    UserConvex5        :: 27;
    UserConvex6        :: 28;
    UserConvex7        :: 29;
    UserConvex8        :: 30;
    Plane              :: 31;
    TaperedCylinder    :: 32;
    Empty              :: 33;

    JPH_Shape_EShapeSubType_Sphere             :: Sphere;
    JPH_Shape_EShapeSubType_Box                :: Box;
    JPH_Shape_EShapeSubType_Triangle           :: Triangle;
    JPH_Shape_EShapeSubType_Capsule            :: Capsule;
    JPH_Shape_EShapeSubType_TaperedCapsule     :: TaperedCapsule;
    JPH_Shape_EShapeSubType_Cylinder           :: Cylinder;
    JPH_Shape_EShapeSubType_ConvexHull         :: ConvexHull;
    JPH_Shape_EShapeSubType_StaticCompound     :: StaticCompound;
    JPH_Shape_EShapeSubType_MutableCompound    :: MutableCompound;
    JPH_Shape_EShapeSubType_RotatedTranslated  :: RotatedTranslated;
    JPH_Shape_EShapeSubType_Scaled             :: Scaled;
    JPH_Shape_EShapeSubType_OffsetCenterOfMass :: OffsetCenterOfMass;
    JPH_Shape_EShapeSubType_Mesh               :: Mesh;
    JPH_Shape_EShapeSubType_HeightField        :: HeightField;
    JPH_Shape_EShapeSubType_SoftBody           :: SoftBody;
    JPH_Shape_EShapeSubType_User1              :: User1;
    JPH_Shape_EShapeSubType_User2              :: User2;
    JPH_Shape_EShapeSubType_User3              :: User3;
    JPH_Shape_EShapeSubType_User4              :: User4;
    JPH_Shape_EShapeSubType_User5              :: User5;
    JPH_Shape_EShapeSubType_User6              :: User6;
    JPH_Shape_EShapeSubType_User7              :: User7;
    JPH_Shape_EShapeSubType_User8              :: User8;
    JPH_Shape_EShapeSubType_UserConvex1        :: UserConvex1;
    JPH_Shape_EShapeSubType_UserConvex2        :: UserConvex2;
    JPH_Shape_EShapeSubType_UserConvex3        :: UserConvex3;
    JPH_Shape_EShapeSubType_UserConvex4        :: UserConvex4;
    JPH_Shape_EShapeSubType_UserConvex5        :: UserConvex5;
    JPH_Shape_EShapeSubType_UserConvex6        :: UserConvex6;
    JPH_Shape_EShapeSubType_UserConvex7        :: UserConvex7;
    JPH_Shape_EShapeSubType_UserConvex8        :: UserConvex8;
    JPH_Shape_EShapeSubType_Plane              :: Plane;
    JPH_Shape_EShapeSubType_TaperedCylinder    :: TaperedCylinder;
    JPH_Shape_EShapeSubType_Empty              :: Empty;
}

MassProperties :: struct {
    mass:    float;
    inertia: Mat44;
}

MassProperties_GetEquivalentSolidBoxSize :: (mass: float, inertiaDiagonal: Vec3) -> Vec3 #foreign JoltC "JPH_MassProperties_GetEquivalentSolidBoxSize";
MassProperties_DecomposePrincipalMomentsOfInertia :: (massProperties: *MassProperties, outRotation: *Mat44, outDiagonal: *Vec3) -> bool #foreign JoltC "JPH_MassProperties_DecomposePrincipalMomentsOfInertia";
MassProperties_SetMassAndInertiaOfSolidBox :: (massProperties: *MassProperties, boxSize: Vec3, density: float) -> void #foreign JoltC "JPH_MassProperties_SetMassAndInertiaOfSolidBox";
MassProperties_ScaleToMass :: (massProperties: *MassProperties, mass: float) -> void #foreign JoltC "JPH_MassProperties_ScaleToMass";
MassProperties_Rotate :: (massProperties: *MassProperties, rotation: Mat44) -> void #foreign JoltC "JPH_MassProperties_Rotate";
MassProperties_Translate :: (massProperties: *MassProperties, translation: Vec3) -> void #foreign JoltC "JPH_MassProperties_Translate";
MassProperties_Scale :: (massProperties: *MassProperties, scale: Vec3) -> void #foreign JoltC "JPH_MassProperties_Scale";

Shape_AddRef :: (shape: *Shape) -> void #foreign JoltC "JPH_Shape_AddRef";
Shape_Release :: (shape: *Shape) -> void #foreign JoltC "JPH_Shape_Release";

Shape_GetType :: (shape: *Shape) -> Shape_EShapeType #foreign JoltC "JPH_Shape_GetType";
Shape_GetSubType :: (shape: *Shape) -> Shape_EShapeSubType #foreign JoltC "JPH_Shape_GetSubType";

Shape_GetUserData :: (shape: *Shape) -> u64 #foreign JoltC "JPH_Shape_GetUserData";
Shape_SetUserData :: (shape: *Shape, userData: u64) -> void #foreign JoltC "JPH_Shape_SetUserData";

Shape_MustBeStatic :: (shape: *Shape) -> bool #foreign JoltC "JPH_Shape_MustBeStatic";
Shape_GetCenterOfMass :: (shape: *Shape) -> Vec3 #foreign JoltC "JPH_Shape_GetCenterOfMass";
Shape_GetLocalBounds :: (shape: *Shape) -> AABox #foreign JoltC "JPH_Shape_GetLocalBounds";
Shape_GetSubShapeIDBitsRecursive :: (shape: *Shape) -> u32 #foreign JoltC "JPH_Shape_GetSubShapeIDBitsRecursive";
Shape_GetWorldSpaceBounds :: (shape: *Shape, centerOfMassTransform: Mat44, scale: Vec3) -> AABox #foreign JoltC "JPH_Shape_GetWorldSpaceBounds";
Shape_GetInnerRadius :: (shape: *Shape) -> float #foreign JoltC "JPH_Shape_GetInnerRadius";

Shape_GetMassProperties :: (shape: *Shape) -> MassProperties #foreign JoltC "JPH_Shape_GetMassProperties";

Shape_GetLeafShape :: (shape: *Shape, subShapeID: SubShapeID, outRemainder: *SubShapeID) -> *Shape #foreign JoltC "JPH_Shape_GetLeafShape";
Shape_GetMaterial :: (shape: *Shape, subShapeID: SubShapeID) -> *PhysicsMaterial #foreign JoltC "JPH_Shape_GetMaterial";
Shape_GetSurfaceNormal :: (shape: *Shape, subShapeID: SubShapeID, localSurfacePosition: Vec3) -> Vec3 #foreign JoltC "JPH_Shape_GetSurfaceNormal";

SupportingFace :: struct {
    size:     u32;
    elements: [32] Vec3 #align 16;
}

Shape_GetSupportingFace :: (shape: *Shape, subShapeID: SubShapeID, direction: Vec3, scale: Vec3, centerOfMassTransform: Mat44, outVertices: *SupportingFace) -> void #foreign JoltC "JPH_Shape_GetSupportingFace";

Shape_GetSubShapeUserData :: (shape: *Shape, subShapeID: SubShapeID) -> u64 #foreign JoltC "JPH_Shape_GetSubShapeUserData";

Shape_GetSubmergedVolume :: (shape: *Shape, centerOfMassTransform: Mat44, scale: Vec3, surface: Plane, outTotalVolume: *float, outSubmergedVolume: *float, outCenterOfBuoyancy: *Vec3) -> void #foreign JoltC "JPH_Shape_GetSubmergedVolume";

// @Todo: Shape::CastRay
// @Todo: Shape::CollidePoint
Shape_GetTrianglesContext :: struct {
    data: [4288] u8;
}

Shape_GetTrianglesStart :: (shape: *Shape, ioContext: *Shape_GetTrianglesContext, box: AABox, positionCOM: Vec3, rotation: Quat, scale: Vec3) -> void #foreign JoltC "JPH_Shape_GetTrianglesStart";
Shape_GetTrianglesNext :: (shape: *Shape, ioContext: *Shape_GetTrianglesContext, maxTrianglesRequested: u32, outTriangleVertices: *Float3, outMaterials: **PhysicsMaterial) -> u32 #foreign JoltC "JPH_Shape_GetTrianglesNext";

Shape_Stats :: struct {
    sizeBytes:    u64;
    numTriangles: u32;
}

Shape_GetStats :: (shape: *Shape) -> Shape_Stats #foreign JoltC "JPH_Shape_GetStats";

Shape_GetVolume :: (shape: *Shape) -> float #foreign JoltC "JPH_Shape_GetVolume";
Shape_IsValidScale :: (shape: *Shape, scale: Vec3) -> bool #foreign JoltC "JPH_Shape_IsValidScale";
Shape_MakeScaleValid :: (shape: *Shape, scale: Vec3) -> Vec3 #foreign JoltC "JPH_Shape_MakeScaleValid";
Shape_ScaleShape :: (shape: *Shape, scale: Vec3) -> *Shape #foreign JoltC "JPH_Shape_ScaleShape";

// ConvexShape
ConvexShape_SetMaterial :: (shape: *ConvexShape, material: *PhysicsMaterial) -> void #foreign JoltC "JPH_ConvexShape_SetMaterial";
ConvexShape_GetMaterial :: (shape: *ConvexShape) -> *PhysicsMaterial #foreign JoltC "JPH_ConvexShape_GetMaterial";
ConvexShape_SetDensity :: (shape: *ConvexShape, density: float) -> void #foreign JoltC "JPH_ConvexShape_SetDensity";
ConvexShape_GetDensity :: (shape: *ConvexShape) -> float #foreign JoltC "JPH_ConvexShape_GetDensity";

// SphereShape
SphereShape_GetRadius :: (shape: *SphereShape) -> float #foreign JoltC "JPH_SphereShape_GetRadius";

// BoxShape
BoxShape_GetHalfExtent :: (shape: *BoxShape) -> Vec3 #foreign JoltC "JPH_BoxShape_GetHalfExtent";
BoxShape_GetConvexRadius :: (shape: *BoxShape) -> float #foreign JoltC "JPH_BoxShape_GetConvexRadius";

// PlaneShape
PlaneShape_GetPlane :: (shape: *PlaneShape) -> Plane #foreign JoltC "JPH_PlaneShape_GetPlane";
PlaneShape_GetHalfExtent :: (shape: *PlaneShape) -> float #foreign JoltC "JPH_PlaneShape_GetHalfExtent";
PlaneShape_SetMaterial :: (shape: *PlaneShape, material: *PhysicsMaterial) -> void #foreign JoltC "JPH_PlaneShape_SetMaterial";
PlaneShape_GetMaterial :: (shape: *PlaneShape) -> *PhysicsMaterial #foreign JoltC "JPH_PlaneShape_GetMaterial";

// TriangleShape
TriangleShape_GetVertex1 :: (shape: *TriangleShape) -> Vec3 #foreign JoltC "JPH_TriangleShape_GetVertex1";
TriangleShape_GetVertex2 :: (shape: *TriangleShape) -> Vec3 #foreign JoltC "JPH_TriangleShape_GetVertex2";
TriangleShape_GetVertex3 :: (shape: *TriangleShape) -> Vec3 #foreign JoltC "JPH_TriangleShape_GetVertex3";
TriangleShape_GetVertices :: (shape: *TriangleShape, outV1: *Vec3, outV2: *Vec3, outV3: *Vec3) -> void #foreign JoltC "JPH_TriangleShape_GetVertices";
TriangleShape_GetConvexRadius :: (shape: *TriangleShape) -> float #foreign JoltC "JPH_TriangleShape_GetConvexRadius";

// CapsuleShape
CapsuleShape_GetRadius :: (shape: *CapsuleShape) -> float #foreign JoltC "JPH_CapsuleShape_GetRadius";
CapsuleShape_GetHalfHeightOfCylinder :: (shape: *CapsuleShape) -> float #foreign JoltC "JPH_CapsuleShape_GetHalfHeightOfCylinder";

// TaperedCapsuleShape
TaperedCapsuleShape_GetTopRadius :: (shape: *TaperedCapsuleShape) -> float #foreign JoltC "JPH_TaperedCapsuleShape_GetTopRadius";
TaperedCapsuleShape_GetBottomRadius :: (shape: *TaperedCapsuleShape) -> float #foreign JoltC "JPH_TaperedCapsuleShape_GetBottomRadius";
TaperedCapsuleShape_GetHalfHeight :: (shape: *TaperedCapsuleShape) -> float #foreign JoltC "JPH_TaperedCapsuleShape_GetHalfHeight";

// CylinderShape
CylinderShape_GetHalfHeight :: (shape: *CylinderShape) -> float #foreign JoltC "JPH_CylinderShape_GetHalfHeight";
CylinderShape_GetRadius :: (shape: *CylinderShape) -> float #foreign JoltC "JPH_CylinderShape_GetRadius";
CylinderShape_GetConvexRadius :: (shape: *CylinderShape) -> float #foreign JoltC "JPH_CylinderShape_GetConvexRadius";

// TaperedCylinderShape
TaperedCylinderShape_GetTopRadius :: (shape: *TaperedCylinderShape) -> float #foreign JoltC "JPH_TaperedCylinderShape_GetTopRadius";
TaperedCylinderShape_GetBottomRadius :: (shape: *TaperedCylinderShape) -> float #foreign JoltC "JPH_TaperedCylinderShape_GetBottomRadius";
TaperedCylinderShape_GetConvexRadius :: (shape: *TaperedCylinderShape) -> float #foreign JoltC "JPH_TaperedCylinderShape_GetConvexRadius";
TaperedCylinderShape_GetHalfHeight :: (shape: *TaperedCylinderShape) -> float #foreign JoltC "JPH_TaperedCylinderShape_GetHalfHeight";

// ConvexHullShape
ConvexHullShape_GetConvexRadius :: (shape: *ConvexHullShape) -> float #foreign JoltC "JPH_ConvexHullShape_GetConvexRadius";
ConvexHullShape_GetNumPoints :: (shape: *ConvexHullShape) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetNumPoints";
ConvexHullShape_GetPoint :: (shape: *ConvexHullShape, index: u32) -> Vec3 #foreign JoltC "JPH_ConvexHullShape_GetPoint";
ConvexHullShape_GetNumFaces :: (shape: *ConvexHullShape) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetNumFaces";
ConvexHullShape_GetNumVerticesInFace :: (shape: *ConvexHullShape, faceIndex: u32) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetNumVerticesInFace";
ConvexHullShape_GetFaceVertices :: (shape: *ConvexHullShape, faceIndex: u32, maxVertices: u32, outVertices: *u32) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetFaceVertices";
ConvexHullShape_GetNumPlanes :: (shape: *ConvexHullShape) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetNumPlanes";
ConvexHullShape_GetPlanes :: (shape: *ConvexHullShape) -> *Plane #foreign JoltC "JPH_ConvexHullShape_GetPlanes";

// DecoratedShape
DecoratedShape_GetInnerShape :: (shape: *DecoratedShape) -> *Shape #foreign JoltC "JPH_DecoratedShape_GetInnerShape";

// RotatedTranslatedShape
RotatedTranslatedShape_GetRotation :: (shape: *RotatedTranslatedShape) -> Quat #foreign JoltC "JPH_RotatedTranslatedShape_GetRotation";
RotatedTranslatedShape_GetPosition :: (shape: *RotatedTranslatedShape) -> Vec3 #foreign JoltC "JPH_RotatedTranslatedShape_GetPosition";
RotatedTranslatedShape_TransformScale :: (shape: *RotatedTranslatedShape, scale: Vec3) -> Vec3 #foreign JoltC "JPH_RotatedTranslatedShape_TransformScale";

// ScaledShape
ScaledShape_GetScale :: (shape: *ScaledShape) -> Vec3 #foreign JoltC "JPH_ScaledShape_GetScale";

// OffsetCenterOfMassShape
OffsetCenterOfMassShape_GetOffset :: (shape: *OffsetCenterOfMassShape) -> Vec3 #foreign JoltC "JPH_OffsetCenterOfMassShape_GetOffset";

// CompoundShape
CompoundShape_GetNumSubShapes :: (shape: *CompoundShape) -> u32 #foreign JoltC "JPH_CompoundShape_GetNumSubShapes";
CompoundShape_GetCompoundUserData :: (shape: *CompoundShape, index: u32) -> u32 #foreign JoltC "JPH_CompoundShape_GetCompoundUserData";
CompoundShape_SetCompoundUserData :: (shape: *CompoundShape, index: u32, userData: u32) -> void #foreign JoltC "JPH_CompoundShape_SetCompoundUserData";
CompoundShape_IsSubShapeIDValid :: (shape: *CompoundShape, subShapeID: SubShapeID) -> bool #foreign JoltC "JPH_CompoundShape_IsSubShapeIDValid";
CompoundShape_GetSubShapeIndexFromID :: (shape: *CompoundShape, subShapeID: SubShapeID, outRemainder: *SubShapeID) -> u32 #foreign JoltC "JPH_CompoundShape_GetSubShapeIndexFromID";

// MutableCompoundShape
MutableCompoundShape_AddShape :: (shape: *MutableCompoundShape, position: Vec3, rotation: Quat, inShape: *Shape, userData: u32, index: u32) -> u32 #foreign JoltC "JPH_MutableCompoundShape_AddShape";
MutableCompoundShape_RemoveShape :: (shape: *MutableCompoundShape, index: u32) -> void #foreign JoltC "JPH_MutableCompoundShape_RemoveShape";
MutableCompoundShape_ModifyShape :: (shape: *MutableCompoundShape, index: u32, position: Vec3, rotation: Quat) -> void #foreign JoltC "JPH_MutableCompoundShape_ModifyShape";
MutableCompoundShape_ModifyShapeWithShape :: (shape: *MutableCompoundShape, index: u32, position: Vec3, rotation: Quat, inShape: *Shape) -> void #foreign JoltC "JPH_MutableCompoundShape_ModifyShapeWithShape";
MutableCompoundShape_ModifyShapes :: (shape: *MutableCompoundShape, startIndex: u32, number: u32, positions: *Vec3, rotations: *Quat, positionStride: u32, rotationStride: u32) -> void #foreign JoltC "JPH_MutableCompoundShape_ModifyShapes";
MutableCompoundShape_AdjustCenterOfMass :: (shape: *MutableCompoundShape) -> void #foreign JoltC "JPH_MutableCompoundShape_AdjustCenterOfMass";

// MeshShape
MeshShape_GetMaterialIndex :: (shape: *MeshShape, subShapeID: SubShapeID) -> u32 #foreign JoltC "JPH_MeshShape_GetMaterialIndex";
MeshShape_GetTriangleUserData :: (shape: *MeshShape, subShapeID: SubShapeID) -> u32 #foreign JoltC "JPH_MeshShape_GetTriangleUserData";

// HeightFieldShape
HeightFieldShape_GetSampleCount :: (shape: *HeightFieldShape) -> u32 #foreign JoltC "JPH_HeightFieldShape_GetSampleCount";
HeightFieldShape_GetBlockSize :: (shape: *HeightFieldShape) -> u32 #foreign JoltC "JPH_HeightFieldShape_GetBlockSize";
HeightFieldShape_GetMaterial :: (shape: *HeightFieldShape, x: u32, y: u32) -> *PhysicsMaterial #foreign JoltC "JPH_HeightFieldShape_GetMaterial";
HeightFieldShape_GetPosition :: (shape: *HeightFieldShape, x: u32, y: u32) -> Vec3 #foreign JoltC "JPH_HeightFieldShape_GetPosition";
HeightFieldShape_IsNoCollision :: (shape: *HeightFieldShape, x: u32, y: u32) -> bool #foreign JoltC "JPH_HeightFieldShape_IsNoCollision";
HeightFieldShape_ProjectOntoSurface :: (shape: *HeightFieldShape, localPosition: Vec3, outSurfacePosition: *Vec3, outSubShapeID: *SubShapeID) -> bool #foreign JoltC "JPH_HeightFieldShape_ProjectOntoSurface";
HeightFieldShape_GetSubShapeCoordinates :: (shape: *HeightFieldShape, subShapeID: SubShapeID, outX: *u32, outY: *u32, outTriangleIndex: *u32) -> void #foreign JoltC "JPH_HeightFieldShape_GetSubShapeCoordinates";
HeightFieldShape_GetMinHeightValue :: (shape: *HeightFieldShape) -> float #foreign JoltC "JPH_HeightFieldShape_GetMinHeightValue";
HeightFieldShape_GetMaxHeightValue :: (shape: *HeightFieldShape) -> float #foreign JoltC "JPH_HeightFieldShape_GetMaxHeightValue";
HeightFieldShape_GetHeights :: (shape: *HeightFieldShape, x: u32, y: u32, sizeX: u32, sizeY: u32, outHeights: *float, heightsStride: s64) -> void #foreign JoltC "JPH_HeightFieldShape_GetHeights";
HeightFieldShape_SetHeights :: (shape: *HeightFieldShape, x: u32, y: u32, sizeX: u32, sizeY: u32, inHeights: *float, heightsStride: s64, allocator: *TempAllocator, activeEdgeCosThresholdAngle: float) -> void #foreign JoltC "JPH_HeightFieldShape_SetHeights";

BodyInterface :: struct {}
BodyLockInterface :: struct {}
Body :: struct {}
MotionProperties :: struct {}
SoftBodyMotionProperties :: struct {}
SoftBodySharedSettings :: struct {}

BodyID :: u32;

BodyManager_BodyStats :: struct {
    numBodies:                u32;
    maxBodies:                u32;
    numBodiesStatic:          u32;
    numBodiesDynamic:         u32;
    numActiveBodiesDynamic:   u32;
    numBodiesKinematic:       u32;
    numActiveBodiesKinematic: u32;
    numSoftBodies:            u32;
    numActiveSoftBodies:      u32;
}

EBodyType :: u8;
EBodyType_1 :: enum u32 {
    RigidBody :: 0;
    SoftBody  :: 1;

    JPH_EBodyType_RigidBody :: RigidBody;
    JPH_EBodyType_SoftBody  :: SoftBody;
}

ECanSleep :: u32;
ECanSleep_1 :: enum u32 {
    CannotSleep :: 0;
    CanSleep    :: 1;

    JPH_ECanSleep_CannotSleep :: CannotSleep;
    JPH_ECanSleep_CanSleep    :: CanSleep;
}

EMotionQuality :: u8;
EMotionQuality_1 :: enum u32 {
    Discrete   :: 0;
    LinearCast :: 1;

    JPH_EMotionQuality_Discrete   :: Discrete;
    JPH_EMotionQuality_LinearCast :: LinearCast;
}

EMotionType :: u8;
EMotionType_1 :: enum u32 {
    Static    :: 0;
    Kinematic :: 1;
    Dynamic   :: 2;

    JPH_EMotionType_Static    :: Static;
    JPH_EMotionType_Kinematic :: Kinematic;
    JPH_EMotionType_Dynamic   :: Dynamic;
}

EAllowedDOFs :: u8;
EAllowedDOFs_1 :: enum u32 {
    None         :: 0;
    All          :: 255;
    TranslationX :: 1;
    TranslationY :: 2;
    TranslationZ :: 4;
    RotationX    :: 8;
    RotationY    :: 16;
    RotationZ    :: 32;
    Plane2D      :: 7;

    JPH_EAllowedDOFs_None         :: None;
    JPH_EAllowedDOFs_All          :: All;
    JPH_EAllowedDOFs_TranslationX :: TranslationX;
    JPH_EAllowedDOFs_TranslationY :: TranslationY;
    JPH_EAllowedDOFs_TranslationZ :: TranslationZ;
    JPH_EAllowedDOFs_RotationX    :: RotationX;
    JPH_EAllowedDOFs_RotationY    :: RotationY;
    JPH_EAllowedDOFs_RotationZ    :: RotationZ;
    JPH_EAllowedDOFs_Plane2D      :: Plane2D;
}

// BodyCreationSettings
EOverrideMassProperties :: u8;
anon_enum :: enum u32 {
    CalculateMassAndInertia :: 0;
    CalculateInertia        :: 1;
    MassAndInertiaProvided  :: 2;
}

BodyCreationSettings :: struct {
    position:                     RVec3;
    rotation:                     Quat;
    linearVelocity:               Vec3;
    angularVelocity:              Vec3;
    userData:                     u64;
    objectLayer:                  ObjectLayer;
    collisionGrou:                CollisionGroup;
    motionType:                   EMotionType;
    allowedDOFs:                  EAllowedDOFs;
    allowDynamicOrKinematic:      bool;
    isSensor:                     bool;
    collideKinematicVsNonDynamic: bool;
    useManifoldReduction:         bool;
    applyGyroscopicForce:         bool;
    motionQuality:                EMotionQuality;
    enhancedInternalEdgeRemoval:  bool;
    allowSleeping:                bool;
    friction:                     float;
    restitution:                  float;
    linearDamping:                float;
    angularDamping:               float;
    maxLinearVelocity:            float;
    maxAngularVelocity:           float;
    gravityFactor:                float;
    numVelocityStepsOverride:     u32;
    numPositionStepsOverride:     u32;
    overrideMassProperties:       EOverrideMassProperties;
    inertiaMultiplier:            float;
    massPropertiesOverride:       MassProperties;
    shape:                        *ShapeSettings;
    shapePtr:                     *Shape;
}

BodyCreationSettings_SetDefaults :: (settings: *BodyCreationSettings) -> void #foreign JoltC "JPH_BodyCreationSettings_SetDefaults";
BodyCreationSettings_ConvertShapeSettings :: (settings: *BodyCreationSettings) -> *Shape #foreign JoltC "JPH_BodyCreationSettings_ConvertShapeSettings";
BodyCreationSettings_HasMassProperties :: (settings: *BodyCreationSettings) -> bool #foreign JoltC "JPH_BodyCreationSettings_HasMassProperties";
BodyCreationSettings_GetMassProperties :: (settings: *BodyCreationSettings) -> MassProperties #foreign JoltC "JPH_BodyCreationSettings_GetMassProperties";

// SoftBodyCreationSettings
SoftBodyCreationSettings :: struct {
    settings:             *SoftBodySharedSettings;
    position:             RVec3 #align 16;
    rotation:             Quat;
    userData:             u64;
    objectLayer:          ObjectLayer;
    collisionGroup:       CollisionGroup;
    numIterations:        u32;
    linearDamping:        float;
    maxLinearVelocity:    float;
    restitution:          float;
    friction:             float;
    pressure:             float;
    gravityFactor:        float;
    vertexRadius:         float;
    updatePosition:       bool;
    makeRotationIdentity: bool;
    allowSleeping:        bool;
    facesDoubleSided:     bool;
}

SoftBodyCreationSettings_SetDefaults :: (settings: *SoftBodyCreationSettings) -> void #foreign JoltC "JPH_SoftBodyCreationSettings_SetDefaults";

// BodyInterface
EActivation :: u32;
EActivation_1 :: enum u32 {
    Activate     :: 0;
    DontActivate :: 1;

    JPH_EActivation_Activate     :: Activate;
    JPH_EActivation_DontActivate :: DontActivate;
}

BodyInterface_CreateBody :: (bodyInterface: *BodyInterface, settings: *BodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateBody";
BodyInterface_CreateSoftBody :: (bodyInterface: *BodyInterface, settings: *SoftBodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateSoftBody";
BodyInterface_CreateBodyWithID :: (bodyInterface: *BodyInterface, bodyID: BodyID, settings: *BodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateBodyWithID";
BodyInterface_CreateSoftBodyWithID :: (bodyInterface: *BodyInterface, bodyID: BodyID, settings: *SoftBodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateSoftBodyWithID";
BodyInterface_CreateBodyWithoutID :: (bodyInterface: *BodyInterface, settings: *BodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateBodyWithoutID";
BodyInterface_CreateSoftBodyWithoutID :: (bodyInterface: *BodyInterface, settings: *SoftBodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateSoftBodyWithoutID";
BodyInterface_DestroyBodyWithoutID :: (bodyInterface: *BodyInterface, body: *Body) -> void #foreign JoltC "JPH_BodyInterface_DestroyBodyWithoutID";
BodyInterface_AssignBodyID :: (bodyInterface: *BodyInterface, ioBody: *Body) -> bool #foreign JoltC "JPH_BodyInterface_AssignBodyID";
BodyInterface_SetBodyID :: (bodyInterface: *BodyInterface, ioBody: *Body, bodyID: BodyID) -> bool #foreign JoltC "JPH_BodyInterface_SetBodyID";
BodyInterface_UnassignBodyID :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> *Body #foreign JoltC "JPH_BodyInterface_UnassignBodyID";
BodyInterface_UnassignBodyIDs :: (bodyInterface: *BodyInterface, bodyIDs: *BodyID, count: s32, outBodies: **Body) -> void #foreign JoltC "JPH_BodyInterface_UnassignBodyIDs";
BodyInterface_DestroyBody :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> void #foreign JoltC "JPH_BodyInterface_DestroyBody";
BodyInterface_DestroyBodies :: (bodyInterface: *BodyInterface, bodyIDs: *BodyID, count: s32) -> void #foreign JoltC "JPH_BodyInterface_DestroyBodies";
BodyInterface_AddBody :: (bodyInterface: *BodyInterface, bodyID: BodyID, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_AddBody";
BodyInterface_RemoveBody :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> void #foreign JoltC "JPH_BodyInterface_RemoveBody";
BodyInterface_IsAdded :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> bool #foreign JoltC "JPH_BodyInterface_IsAdded";
BodyInterface_CreateAndAddBody :: (bodyInterface: *BodyInterface, settings: *BodyCreationSettings, activationMode: EActivation) -> BodyID #foreign JoltC "JPH_BodyInterface_CreateAndAddBody";
BodyInterface_CreateAndAddSoftBody :: (bodyInterface: *BodyInterface, settings: *SoftBodyCreationSettings, activationMode: EActivation) -> BodyID #foreign JoltC "JPH_BodyInterface_CreateAndAddSoftBody";

// JOLTC_API JPH_TwoBodyConstraint *JPH_BodyInterface_CreateConstraint(JPH_BodyInterface *bodyInterface, const TwoBodyConstraintSettings *settings, JPH_BodyID bodyID1, JPH_BodyID bodyID2);
// JOLTC_APIvoid JPH_BodyInterface_ActivateConstraint(JPH_BodyInterface *bodyInterface, const TwoBodyConstraint *constraint);
BodyInterface_MoveKinematic :: (bodyInterface: *BodyInterface, bodyID: BodyID, targetPosition: RVec3, targetRotation: Quat, deltaTime: float) -> void #foreign JoltC "JPH_BodyInterface_MoveKinematic";
BodyInterface_SetLinearAndAngularVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID, linearVelocity: Vec3, angularVelocity: Vec3) -> void #foreign JoltC "JPH_BodyInterface_SetLinearAndAngularVelocity";
BodyInterface_GetLinearAndAngularVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID, outLinearVelocity: *Vec3, outAngularVelocity: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_GetLinearAndAngularVelocity";
BodyInterface_SetLinearVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID, linearVelocity: Vec3) -> void #foreign JoltC "JPH_BodyInterface_SetLinearVelocity";
BodyInterface_GetLinearVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> Vec3 #foreign JoltC "JPH_BodyInterface_GetLinearVelocity";
BodyInterface_AddLinearVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID, linearVelocity: Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddLinearVelocity";
BodyInterface_AddLinearAndAngularVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID, linearVelocity: Vec3, angularVelocity: Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddLinearAndAngularVelocity";
BodyInterface_SetAngularVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID, angularVelocity: Vec3) -> void #foreign JoltC "JPH_BodyInterface_SetAngularVelocity";
BodyInterface_GetAngularVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> Vec3 #foreign JoltC "JPH_BodyInterface_GetAngularVelocity";
BodyInterface_GetPointVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID, point: RVec3) -> Vec3 #foreign JoltC "JPH_BodyInterface_GetPointVelocity";
BodyInterface_SetPositionRotationAndVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID, position: RVec3, rotation: Quat, linearVelocity: Vec3, angularVelocity: Vec3) -> void #foreign JoltC "JPH_BodyInterface_SetPositionRotationAndVelocity";
BodyInterface_GetInverseInertia :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> Mat44 #foreign JoltC "JPH_BodyInterface_GetInverseInertia";

// JOLTC_API TransformedShape const JPH_BodyInterface_GetTransformedShape(JPH_BodyInterface *bodyInterface, JPH_BodyID bodyID);
BodyInterface_GetUserData :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> u64 #foreign JoltC "JPH_BodyInterface_GetUserData";
BodyInterface_SetUserData :: (bodyInterface: *BodyInterface, bodyID: BodyID, userData: u64) -> void #foreign JoltC "JPH_BodyInterface_SetUserData";
BodyInterface_GetMaterial :: (bodyInterface: *BodyInterface, bodyID: BodyID, subShapeID: SubShapeID) -> *PhysicsMaterial #foreign JoltC "JPH_BodyInterface_GetMaterial";
BodyInterface_InvalidateContactCache :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> void #foreign JoltC "JPH_BodyInterface_InvalidateContactCache";
BodyInterface_AddBodiesPrepare :: (bodyInterface: *BodyInterface, ioBodies: *BodyID, count: s32) -> *void #foreign JoltC "JPH_BodyInterface_AddBodiesPrepare";
BodyInterface_AddBodiesFinalize :: (bodyInterface: *BodyInterface, ioBodies: *BodyID, count: s32, addState: *void, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_AddBodiesFinalize";
BodyInterface_AddBodiesAbort :: (bodyInterface: *BodyInterface, ioBodies: *BodyID, count: s32, addState: *void) -> void #foreign JoltC "JPH_BodyInterface_AddBodiesAbort";
BodyInterface_RemoveBodies :: (bodyInterface: *BodyInterface, ioBodies: *BodyID, count: s32) -> void #foreign JoltC "JPH_BodyInterface_RemoveBodies";
BodyInterface_ActivateBody :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> void #foreign JoltC "JPH_BodyInterface_ActivateBody";
BodyInterface_ActivateBodies :: (bodyInterface: *BodyInterface, bodyIDs: *BodyID, count: s32) -> void #foreign JoltC "JPH_BodyInterface_ActivateBodies";
BodyInterface_ActivateBodiesInAABox :: (bodyInterface: *BodyInterface, inBox: AABox, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter) -> void #foreign JoltC "JPH_BodyInterface_ActivateBodiesInAABox";
BodyInterface_DeactivateBody :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> void #foreign JoltC "JPH_BodyInterface_DeactivateBody";
BodyInterface_DeactivateBodies :: (bodyInterface: *BodyInterface, bodyIDs: *BodyID, count: s32) -> void #foreign JoltC "JPH_BodyInterface_DeactivateBodies";
BodyInterface_IsActive :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> bool #foreign JoltC "JPH_BodyInterface_IsActive";
BodyInterface_ResetSleepTimer :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> void #foreign JoltC "JPH_BodyInterface_ResetSleepTimer";
BodyInterface_GetShape :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> *Shape #foreign JoltC "JPH_BodyInterface_GetShape";
BodyInterface_SetShape :: (bodyInterface: *BodyInterface, bodyID: BodyID, shape: *Shape, updateMassProperties: bool, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_SetShape";
BodyInterface_NotifyShapeChanged :: (bodyInterface: *BodyInterface, bodyID: BodyID, inPreviousCenterOfMass: Vec3, updateMassProperties: bool, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_NotifyShapeChanged";
BodyInterface_SetObjectLayer :: (bodyInterface: *BodyInterface, bodyID: BodyID, layer: ObjectLayer) -> void #foreign JoltC "JPH_BodyInterface_SetObjectLayer";
BodyInterface_GetObjectLayer :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> ObjectLayer #foreign JoltC "JPH_BodyInterface_GetObjectLayer";
BodyInterface_SetPositionAndRotation :: (bodyInterface: *BodyInterface, bodyID: BodyID, position: RVec3, rotation: Quat, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_SetPositionAndRotation";
BodyInterface_SetPositionAndRotationWhenChanged :: (bodyInterface: *BodyInterface, bodyID: BodyID, position: RVec3, rotation: Quat, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_SetPositionAndRotationWhenChanged";
BodyInterface_GetPositionAndRotation :: (bodyInterface: *BodyInterface, bodyID: BodyID, outPosition: *RVec3, outRotation: *Quat) -> void #foreign JoltC "JPH_BodyInterface_GetPositionAndRotation";
BodyInterface_SetPosition :: (bodyInterface: *BodyInterface, bodyID: BodyID, position: RVec3, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_SetPosition";
BodyInterface_GetPosition :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> RVec3 #foreign JoltC "JPH_BodyInterface_GetPosition";
BodyInterface_GetCenterOfMassPosition :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> RVec3 #foreign JoltC "JPH_BodyInterface_GetCenterOfMassPosition";
BodyInterface_SetRotation :: (bodyInterface: *BodyInterface, bodyID: BodyID, rotation: Quat, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_SetRotation";
BodyInterface_GetRotation :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> Quat #foreign JoltC "JPH_BodyInterface_GetRotation";
BodyInterface_GetWorldTransform :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> RMat44 #foreign JoltC "JPH_BodyInterface_GetWorldTransform";
BodyInterface_GetCenterOfMassTransform :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> RMat44 #foreign JoltC "JPH_BodyInterface_GetCenterOfMassTransform";
BodyInterface_AddForce :: (bodyInterface: *BodyInterface, bodyID: BodyID, force: Vec3, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_AddForce";
BodyInterface_AddForceAtPoint :: (bodyInterface: *BodyInterface, bodyID: BodyID, force: Vec3, point: RVec3, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_AddForceAtPoint";
BodyInterface_AddTorque :: (bodyInterface: *BodyInterface, bodyID: BodyID, torque: Vec3, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_AddTorque";
BodyInterface_AddForceAndTorque :: (bodyInterface: *BodyInterface, bodyID: BodyID, force: Vec3, torque: Vec3, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_AddForceAndTorque";
BodyInterface_AddImpulse :: (bodyInterface: *BodyInterface, bodyID: BodyID, impulse: Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddImpulse";
BodyInterface_AddImpulseAtPoint :: (bodyInterface: *BodyInterface, bodyID: BodyID, impulse: Vec3, point: RVec3) -> void #foreign JoltC "JPH_BodyInterface_AddImpulseAtPoint";
BodyInterface_AddAngularImpulse :: (bodyInterface: *BodyInterface, bodyID: BodyID, angularImpulse: Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddAngularImpulse";
BodyInterface_ApplyBuoyancyImpulse :: (bodyInterface: *BodyInterface, bodyID: BodyID, surfacePosition: RVec3, surfaceNormal: Vec3, buoyancy: float, linearDrag: float, angularDrag: float, fluidVelocity: Vec3, gravity: Vec3, deltaTime: float) -> bool #foreign JoltC "JPH_BodyInterface_ApplyBuoyancyImpulse";
BodyInterface_GetBodyType :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> EBodyType #foreign JoltC "JPH_BodyInterface_GetBodyType";
BodyInterface_SetMotionType :: (bodyInterface: *BodyInterface, bodyID: BodyID, motionType: EMotionType, activationMode: EActivation) -> void #foreign JoltC "JPH_BodyInterface_SetMotionType";
BodyInterface_GetMotionType :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> EMotionType #foreign JoltC "JPH_BodyInterface_GetMotionType";
BodyInterface_SetMotionQuality :: (bodyInterface: *BodyInterface, bodyID: BodyID, motionQuality: EMotionQuality) -> void #foreign JoltC "JPH_BodyInterface_SetMotionQuality";
BodyInterface_GetMotionQuality :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> EMotionQuality #foreign JoltC "JPH_BodyInterface_GetMotionQuality";
BodyInterface_SetRestitution :: (bodyInterface: *BodyInterface, bodyID: BodyID, restitution: float) -> void #foreign JoltC "JPH_BodyInterface_SetRestitution";
BodyInterface_GetRestitution :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetRestitution";
BodyInterface_SetFriction :: (bodyInterface: *BodyInterface, bodyID: BodyID, friction: float) -> void #foreign JoltC "JPH_BodyInterface_SetFriction";
BodyInterface_GetFriction :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetFriction";
BodyInterface_SetGravityFactor :: (bodyInterface: *BodyInterface, bodyID: BodyID, gravityFactor: float) -> void #foreign JoltC "JPH_BodyInterface_SetGravityFactor";
BodyInterface_GetGravityFactor :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetGravityFactor";
BodyInterface_SetMaxLinearVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID, linearVelocity: float) -> void #foreign JoltC "JPH_BodyInterface_SetMaxLinearVelocity";
BodyInterface_GetMaxLinearVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetMaxLinearVelocity";
BodyInterface_SetMaxAngularVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID, angularVelocity: float) -> void #foreign JoltC "JPH_BodyInterface_SetMaxAngularVelocity";
BodyInterface_GetMaxAngularVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetMaxAngularVelocity";
BodyInterface_SetUseManifoldReduction :: (bodyInterface: *BodyInterface, bodyID: BodyID, useReduction: bool) -> void #foreign JoltC "JPH_BodyInterface_SetUseManifoldReduction";
BodyInterface_GetUseManifoldReduction :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> bool #foreign JoltC "JPH_BodyInterface_GetUseManifoldReduction";
BodyInterface_SetIsSensor :: (bodyInterface: *BodyInterface, bodyID: BodyID, isSensor: bool) -> void #foreign JoltC "JPH_BodyInterface_SetIsSensor";
BodyInterface_IsSensor :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> bool #foreign JoltC "JPH_BodyInterface_IsSensor";
BodyInterface_SetCollisionGroup :: (bodyInterface: *BodyInterface, bodyID: BodyID, collisionGroup: *CollisionGroup) -> void #foreign JoltC "JPH_BodyInterface_SetCollisionGroup";
BodyInterface_GetCollisionGroup :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> *CollisionGroup #foreign JoltC "JPH_BodyInterface_GetCollisionGroup";

// BodyLockInterface
BodyManager_MutexMask :: u64;

BodyLockInterface_TryGetBody :: (bodyLockInterface: *BodyLockInterface, bodyID: BodyID) -> *Body #foreign JoltC "JPH_BodyLockInterface_TryGetBody";

BodyLockRead :: struct {
    bodyLockMutex: *SharedMutex;
    body:          *Body;
}

BodyLockWrite :: struct {
    bodyLockMutex: *SharedMutex;
    body:          *Body;
}

BodyLockInterface_LockRead :: (bodyLockInterface: *BodyLockInterface, bodyID: BodyID, outLock: *BodyLockRead) -> void #foreign JoltC "JPH_BodyLockInterface_LockRead";
BodyLockInterface_UnlockRead :: (bodyLockInterface: *BodyLockInterface, outLock: *BodyLockRead) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockRead";
BodyLockInterface_LockWrite :: (bodyLockInterface: *BodyLockInterface, bodyID: BodyID, outLock: *BodyLockWrite) -> void #foreign JoltC "JPH_BodyLockInterface_LockWrite";
BodyLockInterface_UnlockWrite :: (bodyLockInterface: *BodyLockInterface, outLock: *BodyLockWrite) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockWrite";

BodyLockMultiRead :: struct {
    mutexMask: BodyManager_MutexMask;
    bodyIDs:   *BodyID;
    numBodies: s32;
}

BodyLockMultiWrite :: struct {
    mutexMask: BodyManager_MutexMask;
    bodyIDs:   *BodyID;
    numBodies: s32;
}

BodyLockInterface_LockReadMulti :: (bodyLockInterface: *BodyLockInterface, bodyIDs: *BodyID, numBodies: s32, outLock: *BodyLockMultiRead) -> void #foreign JoltC "JPH_BodyLockInterface_LockReadMulti";
BodyLockInterface_UnlockReadMulti :: (bodyLockInterface: *BodyLockInterface, outLock: *BodyLockMultiRead) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockReadMulti";
BodyLockInterface_LockWriteMulti :: (bodyLockInterface: *BodyLockInterface, bodyIDs: *BodyID, numBodies: s32, outLock: *BodyLockMultiWrite) -> void #foreign JoltC "JPH_BodyLockInterface_LockWriteMulti";
BodyLockInterface_UnlockWriteMulti :: (bodyLockInterface: *BodyLockInterface, outLock: *BodyLockMultiWrite) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockWriteMulti";

BodyLockMultiRead_GetBody :: (lock: *BodyLockMultiRead, bodyLockInterface: *BodyLockInterface, bodyIndex: s32) -> *Body #foreign JoltC "JPH_BodyLockMultiRead_GetBody";
BodyLockMultiWrite_GetBody :: (lock: *BodyLockMultiWrite, bodyLockInterface: *BodyLockInterface, bodyIndex: s32) -> *Body #foreign JoltC "JPH_BodyLockMultiWrite_GetBody";

BodyLockInterface_LockReadAll :: (bodyLockInterface: *BodyLockInterface) -> void #foreign JoltC "JPH_BodyLockInterface_LockReadAll";
BodyLockInterface_UnlockReadAll :: (bodyLockInterface: *BodyLockInterface) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockReadAll";

BodyLockInterface_LockWriteAll :: (bodyLockInterface: *BodyLockInterface) -> void #foreign JoltC "JPH_BodyLockInterface_LockWriteAll";
BodyLockInterface_UnlockWriteAll :: (bodyLockInterface: *BodyLockInterface) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockWriteAll";

// Body
Body_GetID :: (body: *Body) -> BodyID #foreign JoltC "JPH_Body_GetID";
Body_GetBodyType :: (body: *Body) -> EBodyType #foreign JoltC "JPH_Body_GetBodyType";
Body_IsRigidBody :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsRigidBody";
Body_IsSoftBody :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsSoftBody";
Body_IsActive :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsActive";
Body_IsStatic :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsStatic";
Body_IsKinematic :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsKinematic";
Body_IsDynamic :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsDynamic";
Body_CanBeKinematicOrDynamic :: (body: *Body) -> bool #foreign JoltC "JPH_Body_CanBeKinematicOrDynamic";
Body_SetIsSensor :: (body: *Body, isSensor: bool) -> void #foreign JoltC "JPH_Body_SetIsSensor";
Body_IsSensor :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsSensor";
Body_SetCollideKinematicVsNonDynamic :: (body: *Body, collide: bool) -> void #foreign JoltC "JPH_Body_SetCollideKinematicVsNonDynamic";
Body_GetCollideKinematicVsNonDynamic :: (body: *Body) -> bool #foreign JoltC "JPH_Body_GetCollideKinematicVsNonDynamic";
Body_SetUseManifoldReduction :: (body: *Body, useReduction: bool) -> void #foreign JoltC "JPH_Body_SetUseManifoldReduction";
Body_GetUseManifoldReduction :: (body: *Body) -> bool #foreign JoltC "JPH_Body_GetUseManifoldReduction";
Body_GetUseManifoldReductionWithBody :: (body: *Body, body2: *Body) -> bool #foreign JoltC "JPH_Body_GetUseManifoldReductionWithBody";
Body_SetApplyGyroscopicForce :: (body: *Body, apply: bool) -> void #foreign JoltC "JPH_Body_SetApplyGyroscopicForce";
Body_GetApplyGyroscopicForce :: (body: *Body) -> bool #foreign JoltC "JPH_Body_GetApplyGyroscopicForce";
Body_SetEnhancedInternalEdgeRemoval :: (body: *Body, apply: bool) -> void #foreign JoltC "JPH_Body_SetEnhancedInternalEdgeRemoval";
Body_GetEnhancedInternalEdgeRemoval :: (body: *Body) -> bool #foreign JoltC "JPH_Body_GetEnhancedInternalEdgeRemoval";
Body_GetEnhancedInternalEdgeRemovalWithBody :: (body: *Body, body2: *Body) -> bool #foreign JoltC "JPH_Body_GetEnhancedInternalEdgeRemovalWithBody";
Body_GetMotionType :: (body: *Body) -> EMotionType #foreign JoltC "JPH_Body_GetMotionType";
Body_SetMotionType :: (body: *Body, motionType: EMotionType) -> void #foreign JoltC "JPH_Body_SetMotionType";
Body_GetBroadPhaseLayer :: (body: *Body) -> BroadPhaseLayer #foreign JoltC "JPH_Body_GetBroadPhaseLayer";
Body_GetObjectLayer :: (body: *Body) -> ObjectLayer #foreign JoltC "JPH_Body_GetObjectLayer";
Body_GetCollisionGroupConst :: (body: *Body) -> *CollisionGroup #foreign JoltC "JPH_Body_GetCollisionGroupConst";
Body_GetCollisionGroup :: (body: *Body) -> *CollisionGroup #foreign JoltC "JPH_Body_GetCollisionGroup";
Body_SetCollisionGroup :: (body: *Body, group: *CollisionGroup) -> void #foreign JoltC "JPH_Body_SetCollisionGroup";
Body_GetAllowSleeping :: (body: *Body) -> bool #foreign JoltC "JPH_Body_GetAllowSleeping";
Body_SetAllowSleeping :: (body: *Body, allow: bool) -> void #foreign JoltC "JPH_Body_SetAllowSleeping";
Body_ResetSleepTimer :: (body: *Body) -> void #foreign JoltC "JPH_Body_ResetSleepTimer";
Body_GetFriction :: (body: *Body) -> float #foreign JoltC "JPH_Body_GetFriction";
Body_SetFriction :: (body: *Body, friction: float) -> void #foreign JoltC "JPH_Body_SetFriction";
Body_GetRestitution :: (body: *Body) -> float #foreign JoltC "JPH_Body_GetRestitution";
Body_SetRestitution :: (body: *Body, restitution: float) -> void #foreign JoltC "JPH_Body_SetRestitution";
Body_GetLinearVelocity :: (body: *Body) -> Vec3 #foreign JoltC "JPH_Body_GetLinearVelocity";
Body_SetLinearVelocity :: (body: *Body, linearVelocity: Vec3) -> void #foreign JoltC "JPH_Body_SetLinearVelocity";
Body_SetLinearVelocityClamped :: (body: *Body, linearVelocity: Vec3) -> void #foreign JoltC "JPH_Body_SetLinearVelocityClamped";
Body_GetAngularVelocity :: (body: *Body) -> Vec3 #foreign JoltC "JPH_Body_GetAngularVelocity";
Body_SetAngularVelocity :: (body: *Body, angularVelocity: Vec3) -> void #foreign JoltC "JPH_Body_SetAngularVelocity";
Body_SetAngularVelocityClamped :: (body: *Body, angularVelocity: Vec3) -> void #foreign JoltC "JPH_Body_SetAngularVelocityClamped";
Body_GetPointVelocityCOM :: (body: *Body, pointRelativeToCOM: Vec3) -> Vec3 #foreign JoltC "JPH_Body_GetPointVelocityCOM";
Body_GetPointVelocity :: (body: *Body, point: RVec3) -> Vec3 #foreign JoltC "JPH_Body_GetPointVelocity";
Body_AddForce :: (body: *Body, force: Vec3) -> void #foreign JoltC "JPH_Body_AddForce";
Body_AddForceAtPoint :: (body: *Body, force: Vec3, position: RVec3) -> void #foreign JoltC "JPH_Body_AddForceAtPoint";
Body_AddTorque :: (body: *Body, torque: Vec3) -> void #foreign JoltC "JPH_Body_AddTorque";
Body_GetAccumulatedForce :: (body: *Body) -> Vec3 #foreign JoltC "JPH_Body_GetAccumulatedForce";
Body_GetAccumulatedTorque :: (body: *Body) -> Vec3 #foreign JoltC "JPH_Body_GetAccumulatedTorque";
Body_ResetForce :: (body: *Body) -> void #foreign JoltC "JPH_Body_ResetForce";
Body_ResetTorque :: (body: *Body) -> void #foreign JoltC "JPH_Body_ResetTorque";
Body_ResetMotion :: (body: *Body) -> void #foreign JoltC "JPH_Body_ResetMotion";
Body_GetInverseInertia :: (body: *Body) -> Mat44 #foreign JoltC "JPH_Body_GetInverseInertia";
Body_AddImpulse :: (body: *Body, impulse: Vec3) -> void #foreign JoltC "JPH_Body_AddImpulse";
Body_AddImpulseAtPoint :: (body: *Body, impulse: Vec3, position: RVec3) -> void #foreign JoltC "JPH_Body_AddImpulseAtPoint";
Body_AddAngularImpulse :: (body: *Body, angularImpulse: Vec3) -> void #foreign JoltC "JPH_Body_AddAngularImpulse";
Body_MoveKinematic :: (body: *Body, targetPosition: RVec3, targetRotation: Quat, deltaTime: float) -> void #foreign JoltC "JPH_Body_MoveKinematic";
Body_GetSubmergedVolume :: (body: *Body, surfacePosition: RVec3, surfaceNormal: Vec3, outTotalVolume: *float, outSubmergedVolume: *float, outRelativeCenterOfBuoyancy: *Vec3) -> void #foreign JoltC "JPH_Body_GetSubmergedVolume";
Body_ApplyBuoyancyImpulseWithSurface :: (body: *Body, surfacePosition: RVec3, surfaceNormal: Vec3, buoyancy: float, linearDrag: float, angularDrag: float, fluidVelocity: Vec3, gravity: Vec3, deltaTime: float) -> bool #foreign JoltC "JPH_Body_ApplyBuoyancyImpulseWithSurface";
Body_ApplyBuoyancyImpulse :: (body: *Body, totalVolume: float, submergedVolume: float, relativeCenterOfBuoyancy: Vec3, buoyancy: float, linearDrag: float, angularDrag: float, fluidVelocity: Vec3, gravity: Vec3, deltaTime: float) -> bool #foreign JoltC "JPH_Body_ApplyBuoyancyImpulse";
Body_IsInBroadPhase :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsInBroadPhase";
Body_IsCollisionCacheInvalid :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsCollisionCacheInvalid";
Body_GetShape :: (body: *Body) -> *Shape #foreign JoltC "JPH_Body_GetShape";
Body_GetPosition :: (body: *Body) -> RVec3 #foreign JoltC "JPH_Body_GetPosition";
Body_GetRotation :: (body: *Body) -> Quat #foreign JoltC "JPH_Body_GetRotation";
Body_GetWorldTransform :: (body: *Body) -> RMat44 #foreign JoltC "JPH_Body_GetWorldTransform";
Body_GetCenterOfMassPosition :: (body: *Body) -> RVec3 #foreign JoltC "JPH_Body_GetCenterOfMassPosition";
Body_GetCenterOfMassTransform :: (body: *Body) -> RMat44 #foreign JoltC "JPH_Body_GetCenterOfMassTransform";
Body_GetInverseCenterOfMassTransform :: (body: *Body) -> RMat44 #foreign JoltC "JPH_Body_GetInverseCenterOfMassTransform";
Body_GetWorldSpaceBounds :: (body: *Body) -> AABox #foreign JoltC "JPH_Body_GetWorldSpaceBounds";
Body_GetMotionPropertiesConst :: (body: *Body) -> *MotionProperties #foreign JoltC "JPH_Body_GetMotionPropertiesConst";
Body_GetMotionProperties :: (body: *Body) -> *MotionProperties #foreign JoltC "JPH_Body_GetMotionProperties";
Body_GetMotionPropertiesUncheckedConst :: (body: *Body) -> *MotionProperties #foreign JoltC "JPH_Body_GetMotionPropertiesUncheckedConst";
Body_GetMotionPropertiesUnchecked :: (body: *Body) -> *MotionProperties #foreign JoltC "JPH_Body_GetMotionPropertiesUnchecked";
Body_GetUserData :: (body: *Body) -> u64 #foreign JoltC "JPH_Body_GetUserData";
Body_SetUserData :: (body: *Body, userData: u64) -> void #foreign JoltC "JPH_Body_SetUserData";
Body_GetWorldSpaceSurfaceNormal :: (body: *Body, subShapeID: SubShapeID, position: RVec3) -> Vec3 #foreign JoltC "JPH_Body_GetWorldSpaceSurfaceNormal";

// JOLTC_API TransformedShape JPH_Body_GetTransformedShape(const JPH_Body *body);
Body_GetBodyCreationSettings :: (body: *Body) -> BodyCreationSettings #foreign JoltC "JPH_Body_GetBodyCreationSettings";
Body_ApplyBodyCreationSettings :: (body: *Body, bodyCreationSettings: *BodyCreationSettings, bplInterface: *BroadPhaseLayerInterface) -> void #foreign JoltC "JPH_Body_ApplyBodyCreationSettings";
Body_GetSoftBodyCreationSettings :: (body: *Body) -> SoftBodyCreationSettings #foreign JoltC "JPH_Body_GetSoftBodyCreationSettings";
Body_ApplySoftBodyCreationSettings :: (body: *Body, softBodyCreationSettings: *SoftBodyCreationSettings, bplInterface: *BroadPhaseLayerInterface) -> void #foreign JoltC "JPH_Body_ApplySoftBodyCreationSettings";

PhysicsSystem :: struct {}

PhysicsSystemSettings :: struct {
    maxBodies:                     u32;
    numBodyMutexes:                u32;
    maxBodyPairs:                  u32;
    maxContactConstraints:         u32;
    broadPhaseLayerInterface:      *BroadPhaseLayerInterface;
    objectVsBroadPhaseLayerFilter: *ObjectVsBroadPhaseLayerFilter;
    objectLayerPairFilter:         *ObjectLayerPairFilter;
}

PhysicsSystem_Create :: (settings: PhysicsSystemSettings) -> *PhysicsSystem #foreign JoltC "JPH_PhysicsSystem_Create";
PhysicsSystem_Destroy :: (system: *PhysicsSystem) -> void #foreign JoltC "JPH_PhysicsSystem_Destroy";

PhysicsSystem_SetPhysicsSettings :: (system: *PhysicsSystem, settings: PhysicsSettings) -> void #foreign JoltC "JPH_PhysicsSystem_SetPhysicsSettings";
PhysicsSystem_GetPhysicsSettings :: (system: *PhysicsSystem) -> PhysicsSettings #foreign JoltC "JPH_PhysicsSystem_GetPhysicsSettings";
PhysicsSystem_SetGravity :: (system: *PhysicsSystem, gravity: Vec3) -> void #foreign JoltC "JPH_PhysicsSystem_SetGravity";
PhysicsSystem_GetGravity :: (system: *PhysicsSystem) -> Vec3 #foreign JoltC "JPH_PhysicsSystem_GetGravity";
PhysicsSystem_GetNumBodies :: (system: *PhysicsSystem) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetNumBodies";
PhysicsSystem_GetNumActiveBodies :: (system: *PhysicsSystem, type: EBodyType) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetNumActiveBodies";
PhysicsSystem_GetMaxBodies :: (system: *PhysicsSystem) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetMaxBodies";
PhysicsSystem_GetBodyStats :: (system: *PhysicsSystem) -> BodyManager_BodyStats #foreign JoltC "JPH_PhysicsSystem_GetBodyStats";
PhysicsSystem_GetBodies :: (system: *PhysicsSystem, outIDs: **BodyID, allocator: Allocator) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetBodies";
PhysicsSystem_GetActiveBodies :: (system: *PhysicsSystem, type: EBodyType, outIDs: **BodyID, allocator: Allocator) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetActiveBodies";
PhysicsSystem_GetActiveBodiesUnsafe :: (system: *PhysicsSystem, type: EBodyType) -> *BodyID #foreign JoltC "JPH_PhysicsSystem_GetActiveBodiesUnsafe";
PhysicsSystem_WereBodiesInContact :: (system: *PhysicsSystem, body1ID: BodyID, body2ID: BodyID) -> bool #foreign JoltC "JPH_PhysicsSystem_WereBodiesInContact";
PhysicsSystem_GetBounds :: (system: *PhysicsSystem) -> AABox #foreign JoltC "JPH_PhysicsSystem_GetBounds";

PhysicsSystem_GetBodyInterface :: (system: *PhysicsSystem) -> *BodyInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyInterface";
PhysicsSystem_GetBodyInterfaceConst :: (system: *PhysicsSystem) -> *BodyInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyInterfaceConst";
PhysicsSystem_GetBodyInterfaceNoLock :: (system: *PhysicsSystem) -> *BodyInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyInterfaceNoLock";
PhysicsSystem_GetBodyInterfaceNoLockConst :: (system: *PhysicsSystem) -> *BodyInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyInterfaceNoLockConst";
PhysicsSystem_GetBroadPhaseQuery :: (system: *PhysicsSystem) -> *BroadPhaseQuery #foreign JoltC "JPH_PhysicsSystem_GetBroadPhaseQuery";
PhysicsSystem_GetNarrowPhaseQuery :: (system: *PhysicsSystem) -> *NarrowPhaseQuery #foreign JoltC "JPH_PhysicsSystem_GetNarrowPhaseQuery";
PhysicsSystem_GetNarrowPhaseQueryNoLock :: (system: *PhysicsSystem) -> *NarrowPhaseQuery #foreign JoltC "JPH_PhysicsSystem_GetNarrowPhaseQueryNoLock";
PhysicsSystem_GetBodyLockInterface :: (system: *PhysicsSystem) -> *BodyLockInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyLockInterface";
PhysicsSystem_GetBodyLockInterfaceNoLock :: (system: *PhysicsSystem) -> *BodyLockInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyLockInterfaceNoLock";
PhysicsSystem_GetBroadPhaseLayerInterface :: (system: *PhysicsSystem) -> *BroadPhaseLayerInterface #foreign JoltC "JPH_PhysicsSystem_GetBroadPhaseLayerInterface";
PhysicsSystem_GetObjectVsBroadPhaseLayerFilter :: (system: *PhysicsSystem) -> *ObjectVsBroadPhaseLayerFilter #foreign JoltC "JPH_PhysicsSystem_GetObjectVsBroadPhaseLayerFilter";
PhysicsSystem_GetObjectLayerPairFilter :: (system: *PhysicsSystem) -> *ObjectLayerPairFilter #foreign JoltC "JPH_PhysicsSystem_GetObjectLayerPairFilter";
PhysicsSystem_GetDefaultBroadPhaseLayerFilter :: (system: *PhysicsSystem, layer: ObjectLayer) -> DefaultBroadPhaseLayerFilter #foreign JoltC "JPH_PhysicsSystem_GetDefaultBroadPhaseLayerFilter";
PhysicsSystem_GetDefaultLayerFilter :: (system: *PhysicsSystem, layer: ObjectLayer) -> DefaultObjectLayerFilter #foreign JoltC "JPH_PhysicsSystem_GetDefaultLayerFilter";

PhysicsSystem_OptimizeBroadPhase :: (system: *PhysicsSystem) -> void #foreign JoltC "JPH_PhysicsSystem_OptimizeBroadPhase";

EPhysicsUpdateError :: u32;
EPhysicsUpdateError_1 :: enum u32 {
    None                   :: 0;
    ManifoldCacheFull      :: 1;
    BodyPairCacheFull      :: 2;
    ContactConstraintsFull :: 4;

    JPH_EPhysicsUpdateError_None                   :: None;
    JPH_EPhysicsUpdateError_ManifoldCacheFull      :: ManifoldCacheFull;
    JPH_EPhysicsUpdateError_BodyPairCacheFull      :: BodyPairCacheFull;
    JPH_EPhysicsUpdateError_ContactConstraintsFull :: ContactConstraintsFull;
}

PhysicsSystem_Update :: (system: *PhysicsSystem, deltaTime: float, collisionSteps: s32, tempAllocator: *TempAllocator, jobSystem: *JobSystem) -> EPhysicsUpdateError #foreign JoltC "JPH_PhysicsSystem_Update";

#scope_file

JoltC :: #library,no_dll "./Libs/Linux/libJoltC";
