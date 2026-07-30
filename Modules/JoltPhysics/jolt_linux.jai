// Defines

CALL :: 1;
DEBUG_RENDERER :: 1;
VERSION_FEATURE_BIT_1 :: 0;
VERSION_FEATURE_BIT_2 :: 0;
VERSION_FEATURE_BIT_3 :: 0;
VERSION_FEATURE_BIT_4 :: 0;
VERSION_FEATURE_BIT_5 :: 0;
VERSION_FEATURE_BIT_6 :: 1;
VERSION_FEATURE_BIT_7 :: 0;
VERSION_FEATURE_BIT_8 :: 0;
VERSION_FEATURE_BIT_9 :: 0;
VERSION_FEATURE_BIT_10 :: 0;
VERSION_FEATURE_BIT_11 :: 0;
DEBUG :: 1;
ENABLE_ASSERTS :: 1;
VECTOR_ALIGNMENT :: 16;
DVECTOR_ALIGNMENT :: 32;
cDefaultCollisionTolerance :: 1.0e-4;
cDefaultPenetrationTolerance :: 1.0e-4;
cDefaultConvexRadius :: 0.05;
cCapsuleProjectionSlop :: 0.02;
cDefaultInternalEdgeRemovalVertexToleranceSq :: 1.0e-8;
cMaxPhysicsJobs :: 2048;
cMaxPhysicsBarriers :: 8;
cInvalidBodyID :: 0xfffffff;

// Typedefs

RVec3 :: Vec3;
RMat44 :: Mat44;
Real :: float;
Color :: u32;
AllocateFunction :: *#type (u64) -> *void #c_call;
ReallocateFunction :: *#type (*void, u64, u64) -> *void #c_call;
FreeFunction :: *#type (*void) -> void #c_call;
AlignedAllocateFunction :: *#type (u64, u64) -> *void #c_call;
AlignedFreeFunction :: *#type (*void) -> void #c_call;
TraceHandler :: *#type (*s8) -> void #c_call;
AssertFailedHandler :: *#type (*s8, *s8, *s8, u32) -> bool #c_call;
BodyID :: u32;
SubShapeID :: u32;
BroadPhaseLayer :: u8;
ObjectLayer :: u16;

// Enums

EShapeType :: enum u8 {
    Convex :: 0;
    Compound :: 1;
    Decorated :: 2;
    Mesh :: 3;
    HeightField :: 4;
    SoftBody :: 5;
    User1 :: 6;
    User2 :: 7;
    User3 :: 8;
    User4 :: 9;
    Plane :: 10;
    Empty :: 11;
}

EShapeSubType :: enum u8 {
    Sphere :: 0;
    Box :: 1;
    Triangle :: 2;
    Capsule :: 3;
    TaperedCapsule :: 4;
    Cylinder :: 5;
    ConvexHull :: 6;
    StaticCompound :: 7;
    MutableCompound :: 8;
    RotatedTranslated :: 9;
    Scaled :: 10;
    OffsetCenterOfMass :: 11;
    Mesh :: 12;
    HeightField :: 13;
    SoftBody :: 14;
    User1 :: 15;
    User2 :: 16;
    User3 :: 17;
    User4 :: 18;
    User5 :: 19;
    User6 :: 20;
    User7 :: 21;
    User8 :: 22;
    UserConvex1 :: 23;
    UserConvex2 :: 24;
    UserConvex3 :: 25;
    UserConvex4 :: 26;
    UserConvex5 :: 27;
    UserConvex6 :: 28;
    UserConvex7 :: 29;
    UserConvex8 :: 30;
    Plane :: 31;
    TaperedCylinder :: 32;
    Empty :: 33;
}

EBackFaceMode :: enum u8 {
    IgnoreBackFaces :: 0;
    CollideWithBackFaces :: 1;
}

ECollisionCollectorType :: enum u32 {
    AnyHit :: 0;
    ClosestHit :: 1;
    AllHitsSorted :: 2;
    AllHits :: 3;
}

EBodyType :: enum u8 {
    RigidBody :: 0;
    SoftBody :: 1;
}

ECanSleep :: enum u32 {
    CannotSleep :: 0;
    CanSleep :: 1;
}

EMotionQuality :: enum u8 {
    Discrete :: 0;
    LinearCast :: 1;
}

EMotionType :: enum u8 {
    Static :: 0;
    Kinematic :: 1;
    Dynamic :: 2;
}

EAllowedDOFs :: enum_flags u8 {
    None :: 0;
    All :: 255;
    TranslationX :: 1;
    TranslationY :: 2;
    TranslationZ :: 4;
    RotationX :: 8;
    RotationY :: 16;
    RotationZ :: 32;
    Plane2D :: 7;
}

EOverrideMassProperties :: enum u8 {
    CalculateMassAndInertia :: 0;
    CalculateInertia :: 1;
    MassAndInertiaProvided :: 2;
}

EActivation :: enum u32 {
    Activate :: 0;
    DontActivate :: 1;
}

ESoftBodyConstraintColor :: enum u32 {
    ConstraintType :: 0;
    ConstraintGroup :: 1;
    ConstraintOrder :: 2;
}

EPhysicsUpdateError :: enum_flags u32 {
    None :: 0;
    ManifoldCacheFull :: 1;
    BodyPairCacheFull :: 2;
    ContactConstraintsFull :: 4;
}

// Structs

TempAllocator :: struct {
    opaque : s8;

    Destroy :: (allocator : *TempAllocator) -> void #foreign JoltC "JPH_TempAllocator_Destroy";
    Allocate :: (allocator : *TempAllocator, size : u32) -> *void #foreign JoltC "JPH_TempAllocator_Allocate";
    Free :: (allocator : *TempAllocator, ptr : *void, size : u32) -> void #foreign JoltC "JPH_TempAllocator_Free";
}

TempAllocatorImpl :: struct {
    #as using,except(base) base : TempAllocator;

    Create :: (size : u64) -> *TempAllocator #foreign JoltC "JPH_TempAllocatorImpl_Create";
}

TempAllocatorImplWithMallocFallback :: struct {
    #as using,except(base) base : TempAllocator;

    Create :: (size : u32) -> *TempAllocator #foreign JoltC "JPH_TempAllocatorImplWithMallocFallback_Create";
}

TempAllocatorMalloc :: struct {
    #as using,except(base) base : TempAllocator;

    Create :: () -> *TempAllocator #foreign JoltC "JPH_TempAllocatorMalloc_Create";
}

JobSystem :: struct {
    opaque : s8;

    Destroy :: (job_system : *JobSystem) -> void #foreign JoltC "JPH_JobSystem_Destroy";
}

JobSystemSingleThreaded :: struct {
    #as using,except(base) base : JobSystem;

    Create :: (maxJobs : u32) -> *JobSystem #foreign JoltC "JPH_JobSystemSingleThreaded_Create";
}

JobSystemThreadPool :: struct {
    #as using,except(base) base : JobSystem;

    Create :: (maxJobs : u32, maxBarriers : u32, numThreads : s32) -> *JobSystem #foreign JoltC "JPH_JobSystemThreadPool_Create";
}

SharedMutex :: struct {}

Float3 :: struct {
    x : float;
    y : float;
    z : float;
}








AABox :: struct {
    min : Vec3;
    max : Vec3;
}

Plane :: struct {
    normalAndConstant : Vec4;

    Make :: (normal : Vec3, constant : float) -> Plane #foreign JoltC "JPH_Plane_Make";
    Offset :: (plane : Plane, distance : float) -> Plane #foreign JoltC "JPH_Plane_Offset";
    Scaled :: (plane : Plane, scale : Vec3) -> Plane #foreign JoltC "JPH_Plane_Scaled";
    GetTransformed :: (plane : Plane, transform : Mat44) -> Plane #foreign JoltC "JPH_Plane_GetTransformed";
    SignedDistance :: (plane : Plane, point : Vec3) -> float #foreign JoltC "JPH_Plane_SignedDistance";
    ProjectPointOnPlane :: (plane : Plane, point : Vec3) -> Vec3 #foreign JoltC "JPH_Plane_ProjectPointOnPlane";
    FromPointAndNormal :: (point : Vec3, normal : Vec3) -> Plane #foreign JoltC "JPH_Plane_FromPointAndNormal";
}

OrientedBox :: struct {
    orientation : Mat44;
    halfExtents : Vec3;

    OverlapsAABox :: (box : *OrientedBox, otherBox : AABox, epsilon : float) -> bool #foreign JoltC "JPH_OrientedBox_OverlapsAABox";
    OverlapsOrientedBox :: (box : *OrientedBox, otherBox : OrientedBox, epsilon : float) -> bool #foreign JoltC "JPH_OrientedBox_OverlapsOrientedBox";
}

PhysicsSettings :: struct {
    maxInFlightBodyPairs : s32;
    stepListenersBatchSize : s32;
    stepListenerBatchesPerJob : s32;
    baumgarte : float;
    speculativeContactDistance : float;
    penetrationSlop : float;
    linearCastThreshold : float;
    linearCastMaxPenetration : float;
    manifoldTolerance : float;
    maxPenetrationDistance : float;
    bodyPairCacheMaxDeltaPositionSq : float;
    bodyPairCacheCosMaxDeltaRotationDiv2 : float;
    contactNormalCosMaxDeltaRotation : float;
    contactPointPreserveLambdaMaxDistSq : float;
    internalEdgeRemovalVertexToleranceSq : float;
    numVelocitySteps : u32;
    numPositionSteps : u32;
    minVelocityForRestitution : float;
    timeBeforeSleep : float;
    pointVelocitySleepThreshold : float;
    deterministicSimulation : bool;
    constraintWarmStart : bool;
    useBodyPairContactCache : bool;
    useManifoldReduction : bool;
    useLargeIslandSplitter : bool;
    allowSleeping : bool;
    checkActiveEdges : bool;
}

JoltCAllocator :: struct {
    data : *void;
    AllocateFunc : *#type (*void, u64) -> *void #c_call;
    FreeFunc : *#type (*void, *void) -> void #c_call;

    Allocate :: (allocator : JoltCAllocator, size : u64) -> *void #foreign JoltC "JPH_JoltCAllocator_Allocate";
    Free :: (allocator : JoltCAllocator, ptr : *void) -> void #foreign JoltC "JPH_JoltCAllocator_Free";
}

PhysicsMaterial :: struct {}

ShapeSettings :: struct {
    opaque : s8;

    Destroy :: (settings : *ShapeSettings) -> void #foreign JoltC "JPH_ShapeSettings_Destroy";
    CreateShape :: (settings : *ShapeSettings) -> *Shape #foreign JoltC "JPH_ShapeSettings_CreateShape";
    ClearCachedResult :: (settings : *ShapeSettings) -> void #foreign JoltC "JPH_ShapeSettings_ClearCachedResult";
    SetUserData :: (settings : *ShapeSettings, userData : u64) -> void #foreign JoltC "JPH_ShapeSettings_SetUserData";
    GetUserData :: (settings : *ShapeSettings) -> u64 #foreign JoltC "JPH_ShapeSettings_GetUserData";
}

EmptyShapeSettings :: struct {
    #as using,except(base) base : ShapeSettings;

    Create :: () -> *EmptyShapeSettings #foreign JoltC "JPH_EmptyShapeSettings_Create";

    SetCenterOfMass :: (settings : *EmptyShapeSettings, centerOfMass : Vec3) -> void #foreign JoltC "JPH_EmptyShapeSettings_SetCenterOfMass";
    GetCenterOfMass :: (settings : *EmptyShapeSettings) -> Vec3 #foreign JoltC "JPH_EmptyShapeSettings_GetCenterOfMass";
}

PlaneShapeSettings :: struct {
    #as using,except(base) base : ShapeSettings;

    Create :: () -> *PlaneShapeSettings #foreign JoltC "JPH_PlaneShapeSettings_Create";

    SetPlane :: (settings : *PlaneShapeSettings, plane : Plane) -> void #foreign JoltC "JPH_PlaneShapeSettings_SetPlane";
    GetPlane :: (settings : *PlaneShapeSettings) -> Plane #foreign JoltC "JPH_PlaneShapeSettings_GetPlane";
    SetPhysicsMaterial :: (settings : *PlaneShapeSettings, material : *PhysicsMaterial) -> void #foreign JoltC "JPH_PlaneShapeSettings_SetPhysicsMaterial";
    GetPhysicsMaterial :: (settings : *PlaneShapeSettings) -> *PhysicsMaterial #foreign JoltC "JPH_PlaneShapeSettings_GetPhysicsMaterial";
    SetHalfExtent :: (settings : *PlaneShapeSettings, halfExtent : float) -> void #foreign JoltC "JPH_PlaneShapeSettings_SetHalfExtent";
    GetHalfExtent :: (settings : *PlaneShapeSettings) -> float #foreign JoltC "JPH_PlaneShapeSettings_GetHalfExtent";
}

MeshShapeSettings :: struct {
    EBuildQuality :: enum u32 {
        FavorRuntimePerformance :: 0;
        FavorBuildSpeed :: 1;
    }

    #as using,except(base) base : ShapeSettings;

    Create :: () -> *MeshShapeSettings #foreign JoltC "JPH_MeshShapeSettings_Create";

    Sanitize :: (settings : *MeshShapeSettings) -> void #foreign JoltC "JPH_MeshShapeSettings_Sanitize";
    AddVertex :: (settings : *MeshShapeSettings, vertex : Float3) -> void #foreign JoltC "JPH_MeshShapeSettings_AddVertex";
    AddVertices :: (settings : *MeshShapeSettings, vertices : *Float3, count : u32) -> void #foreign JoltC "JPH_MeshShapeSettings_AddVertices";
    GetNumVertices :: (settings : *MeshShapeSettings) -> u32 #foreign JoltC "JPH_MeshShapeSettings_GetNumVertices";
    GetVertices :: (settings : *MeshShapeSettings) -> *Float3 #foreign JoltC "JPH_MeshShapeSettings_GetVertices";
    AddIndexedTriangle :: (settings : *MeshShapeSettings, triangle : IndexedTriangle) -> void #foreign JoltC "JPH_MeshShapeSettings_AddIndexedTriangle";
    AddIndexedTriangles :: (settings : *MeshShapeSettings, triangles : *IndexedTriangle, count : u32) -> void #foreign JoltC "JPH_MeshShapeSettings_AddIndexedTriangles";
    GetNumIndexedTriangles :: (settings : *MeshShapeSettings) -> u32 #foreign JoltC "JPH_MeshShapeSettings_GetNumIndexedTriangles";
    GetIndexedTriangles :: (settings : *MeshShapeSettings) -> *IndexedTriangle #foreign JoltC "JPH_MeshShapeSettings_GetIndexedTriangles";
    AddMaterial :: (settings : *MeshShapeSettings, material : *PhysicsMaterial) -> void #foreign JoltC "JPH_MeshShapeSettings_AddMaterial";
    AddMaterials :: (settings : *MeshShapeSettings, materials : **PhysicsMaterial, count : u32) -> void #foreign JoltC "JPH_MeshShapeSettings_AddMaterials";
    GetNumMaterials :: (settings : *MeshShapeSettings) -> u32 #foreign JoltC "JPH_MeshShapeSettings_GetNumMaterials";
    GetMaterial :: (settings : *MeshShapeSettings, index : u32) -> *PhysicsMaterial #foreign JoltC "JPH_MeshShapeSettings_GetMaterial";
    SetMaxTrianglesPerLeaf :: (settings : *MeshShapeSettings, maxTrianglesPerLeaf : u32) -> void #foreign JoltC "JPH_MeshShapeSettings_SetMaxTrianglesPerLeaf";
    GetMaxTrianglesPerLeaf :: (settings : *MeshShapeSettings) -> u32 #foreign JoltC "JPH_MeshShapeSettings_GetMaxTrianglesPerLeaf";
    SetActiveEdgeCosThresholdAngle :: (settings : *MeshShapeSettings, activeEdgeCosThresholdAngle : float) -> void #foreign JoltC "JPH_MeshShapeSettings_SetActiveEdgeCosThresholdAngle";
    GetActiveEdgeCosThresholdAngle :: (settings : *MeshShapeSettings) -> float #foreign JoltC "JPH_MeshShapeSettings_GetActiveEdgeCosThresholdAngle";
    SetPerTriangleUserData :: (settings : *MeshShapeSettings, perTriangleUserData : bool) -> void #foreign JoltC "JPH_MeshShapeSettings_SetPerTriangleUserData";
    GetPerTriangleUserData :: (settings : *MeshShapeSettings) -> bool #foreign JoltC "JPH_MeshShapeSettings_GetPerTriangleUserData";
    SetBuildQuality :: (settings : *MeshShapeSettings, buildQuality : MeshShapeSettings.EBuildQuality) -> void #foreign JoltC "JPH_MeshShapeSettings_SetBuildQuality";
    GetBuildQuality :: (settings : *MeshShapeSettings) -> MeshShapeSettings.EBuildQuality #foreign JoltC "JPH_MeshShapeSettings_GetBuildQuality";
}

HeightFieldShapeSettings :: struct {
    #as using,except(base) base : ShapeSettings;

    Create :: () -> *HeightFieldShapeSettings #foreign JoltC "JPH_HeightFieldShapeSettings_Create";

    DetermineMinAndMaxSample :: (settings : *HeightFieldShapeSettings, outMinValue : *float, outMaxValue : *float, outQuantizationScale : *float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_DetermineMinAndMaxSample";
    CalculateBitsPerSampleForError :: (settings : *HeightFieldShapeSettings, maxError : float) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_CalculateBitsPerSampleForError";
    AddHeightSample :: (settings : *HeightFieldShapeSettings, sample : float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_AddHeightSample";
    AddHeightSamples :: (settings : *HeightFieldShapeSettings, samples : *float, count : u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_AddHeightSamples";
    GetNumHeightSamples :: (settings : *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetNumHeightSamples";
    GetHeightSamples :: (settings : *HeightFieldShapeSettings) -> *float #foreign JoltC "JPH_HeightFieldShapeSettings_GetHeightSamples";
    AddMaterialIndex :: (settings : *HeightFieldShapeSettings, materialIndex : u8) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_AddMaterialIndex";
    AddMaterialIndices :: (settings : *HeightFieldShapeSettings, materialIndices : *u8, count : u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_AddMaterialIndices";
    GetNumMaterialIndices :: (settings : *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetNumMaterialIndices";
    GetMaterialIndices :: (settings : *HeightFieldShapeSettings) -> *u8 #foreign JoltC "JPH_HeightFieldShapeSettings_GetMaterialIndices";
    AddMaterial :: (settings : *HeightFieldShapeSettings, material : *PhysicsMaterial) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_AddMaterial";
    AddMaterials :: (settings : *HeightFieldShapeSettings, materials : **PhysicsMaterial, count : u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_AddMaterials";
    GetNumMaterials :: (settings : *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetNumMaterials";
    GetMaterial :: (settings : *HeightFieldShapeSettings, index : u32) -> *PhysicsMaterial #foreign JoltC "JPH_HeightFieldShapeSettings_GetMaterial";
    SetOffset :: (settings : *HeightFieldShapeSettings, offset : Vec3) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetOffset";
    GetOffset :: (settings : *HeightFieldShapeSettings) -> Vec3 #foreign JoltC "JPH_HeightFieldShapeSettings_GetOffset";
    SetScale :: (settings : *HeightFieldShapeSettings, scale : Vec3) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetScale";
    GetScale :: (settings : *HeightFieldShapeSettings) -> Vec3 #foreign JoltC "JPH_HeightFieldShapeSettings_GetScale";
    SetSampleCount :: (settings : *HeightFieldShapeSettings, sampleCount : u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetSampleCount";
    GetSampleCount :: (settings : *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetSampleCount";
    SetMinHeightValue :: (settings : *HeightFieldShapeSettings, minHeightValue : float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetMinHeightValue";
    GetMinHeightValue :: (settings : *HeightFieldShapeSettings) -> float #foreign JoltC "JPH_HeightFieldShapeSettings_GetMinHeightValue";
    SetMaxHeightValue :: (settings : *HeightFieldShapeSettings, maxHeightValue : float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetMaxHeightValue";
    GetMaxHeightValue :: (settings : *HeightFieldShapeSettings) -> float #foreign JoltC "JPH_HeightFieldShapeSettings_GetMaxHeightValue";
    SetMaterialsCapacity :: (settings : *HeightFieldShapeSettings, materialsCapacity : u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetMaterialsCapacity";
    GetMaterialsCapacity :: (settings : *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetMaterialsCapacity";
    SetBlockSize :: (settings : *HeightFieldShapeSettings, blockSize : u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetBlockSize";
    GetBlockSize :: (settings : *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetBlockSize";
    SetBitsPerSample :: (settings : *HeightFieldShapeSettings, bitsPerSample : u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetBitsPerSample";
    GetBitsPerSample :: (settings : *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetBitsPerSample";
    SetActiveEdgeCosThresholdAngle :: (settings : *HeightFieldShapeSettings, activeEdgeCosThresholdAngle : float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetActiveEdgeCosThresholdAngle";
    GetActiveEdgeCosThresholdAngle :: (settings : *HeightFieldShapeSettings) -> float #foreign JoltC "JPH_HeightFieldShapeSettings_GetActiveEdgeCosThresholdAngle";
}

ConvexShapeSettings :: struct {
    #as using,except(base) base : ShapeSettings;

    SetPhysicsMaterial :: (settings : *ConvexShapeSettings, material : *PhysicsMaterial) -> void #foreign JoltC "JPH_ConvexShapeSettings_SetPhysicsMaterial";
    GetPhysicsMaterial :: (settings : *ConvexShapeSettings) -> *PhysicsMaterial #foreign JoltC "JPH_ConvexShapeSettings_GetPhysicsMaterial";
    SetDensity :: (settings : *ConvexShapeSettings, density : float) -> void #foreign JoltC "JPH_ConvexShapeSettings_SetDensity";
    GetDensity :: (settings : *ConvexShapeSettings) -> float #foreign JoltC "JPH_ConvexShapeSettings_GetDensity";
}

SphereShapeSettings :: struct {
    #as using,except(base) base : ConvexShapeSettings;

    Create :: () -> *SphereShapeSettings #foreign JoltC "JPH_SphereShapeSettings_Create";

    SetRadius :: (settings : *SphereShapeSettings, radius : float) -> void #foreign JoltC "JPH_SphereShapeSettings_SetRadius";
    GetRadius :: (settings : *SphereShapeSettings) -> float #foreign JoltC "JPH_SphereShapeSettings_GetRadius";
}

BoxShapeSettings :: struct {
    #as using,except(base) base : ConvexShapeSettings;

    Create :: () -> *BoxShapeSettings #foreign JoltC "JPH_BoxShapeSettings_Create";

    SetHalfExtent :: (settings : *BoxShapeSettings, halfExtent : Vec3) -> void #foreign JoltC "JPH_BoxShapeSettings_SetHalfExtent";
    GetHalfExtent :: (settings : *BoxShapeSettings) -> Vec3 #foreign JoltC "JPH_BoxShapeSettings_GetHalfExtent";
    SetConvexRadius :: (settings : *BoxShapeSettings, convexRadius : float) -> void #foreign JoltC "JPH_BoxShapeSettings_SetConvexRadius";
    GetConvexRadius :: (settings : *BoxShapeSettings) -> float #foreign JoltC "JPH_BoxShapeSettings_GetConvexRadius";
}

TriangleShapeSettings :: struct {
    #as using,except(base) base : ConvexShapeSettings;

    Create :: () -> *TriangleShapeSettings #foreign JoltC "JPH_TriangleShapeSettings_Create";

    SetV1 :: (settings : *TriangleShapeSettings, v1 : Vec3) -> void #foreign JoltC "JPH_TriangleShapeSettings_SetV1";
    GetV1 :: (settings : *TriangleShapeSettings) -> Vec3 #foreign JoltC "JPH_TriangleShapeSettings_GetV1";
    SetV2 :: (settings : *TriangleShapeSettings, v2 : Vec3) -> void #foreign JoltC "JPH_TriangleShapeSettings_SetV2";
    GetV2 :: (settings : *TriangleShapeSettings) -> Vec3 #foreign JoltC "JPH_TriangleShapeSettings_GetV2";
    SetV3 :: (settings : *TriangleShapeSettings, v3 : Vec3) -> void #foreign JoltC "JPH_TriangleShapeSettings_SetV3";
    GetV3 :: (settings : *TriangleShapeSettings) -> Vec3 #foreign JoltC "JPH_TriangleShapeSettings_GetV3";
    SetPoints :: (settings : *TriangleShapeSettings, v1 : Vec3, v2 : Vec3, v3 : Vec3) -> void #foreign JoltC "JPH_TriangleShapeSettings_SetPoints";
    GetPoints :: (settings : *TriangleShapeSettings, outV1 : *Vec3, outV2 : *Vec3, outV3 : *Vec3) -> void #foreign JoltC "JPH_TriangleShapeSettings_GetPoints";
    SetConvexRadius :: (settings : *TriangleShapeSettings, convexRadius : float) -> void #foreign JoltC "JPH_TriangleShapeSettings_SetConvexRadius";
    GetConvexRadius :: (settings : *TriangleShapeSettings) -> float #foreign JoltC "JPH_TriangleShapeSettings_GetConvexRadius";
}

CapsuleShapeSettings :: struct {
    #as using,except(base) base : ConvexShapeSettings;

    Create :: () -> *CapsuleShapeSettings #foreign JoltC "JPH_CapsuleShapeSettings_Create";

    SetRadius :: (settings : *CapsuleShapeSettings, radius : float) -> void #foreign JoltC "JPH_CapsuleShapeSettings_SetRadius";
    GetRadius :: (settings : *CapsuleShapeSettings) -> float #foreign JoltC "JPH_CapsuleShapeSettings_GetRadius";
    SetHalfHeightOfCylinder :: (settings : *CapsuleShapeSettings, halfHeightOfCylinder : float) -> void #foreign JoltC "JPH_CapsuleShapeSettings_SetHalfHeightOfCylinder";
    GetHalfHeightOfCylinder :: (settings : *CapsuleShapeSettings) -> float #foreign JoltC "JPH_CapsuleShapeSettings_GetHalfHeightOfCylinder";
    IsValid :: (settings : *CapsuleShapeSettings) -> bool #foreign JoltC "JPH_CapsuleShapeSettings_IsValid";
    IsSphere :: (settings : *CapsuleShapeSettings) -> bool #foreign JoltC "JPH_CapsuleShapeSettings_IsSphere";
}

TaperedCapsuleShapeSettings :: struct {
    #as using,except(base) base : ConvexShapeSettings;

    Create :: () -> *TaperedCapsuleShapeSettings #foreign JoltC "JPH_TaperedCapsuleShapeSettings_Create";

    SetHalfHeightOfTaperedCylinder :: (settings : *TaperedCapsuleShapeSettings, halfHeightOfTaperedCylinder : float) -> void #foreign JoltC "JPH_TaperedCapsuleShapeSettings_SetHalfHeightOfTaperedCylinder";
    GetHalfHeightOfTaperedCylinder :: (settings : *TaperedCapsuleShapeSettings) -> float #foreign JoltC "JPH_TaperedCapsuleShapeSettings_GetHalfHeightOfTaperedCylinder";
    SetTopRadius :: (settings : *TaperedCapsuleShapeSettings, topRadius : float) -> void #foreign JoltC "JPH_TaperedCapsuleShapeSettings_SetTopRadius";
    GetTopRadius :: (settings : *TaperedCapsuleShapeSettings) -> float #foreign JoltC "JPH_TaperedCapsuleShapeSettings_GetTopRadius";
    SetBottomRadius :: (settings : *TaperedCapsuleShapeSettings, bottomRadius : float) -> void #foreign JoltC "JPH_TaperedCapsuleShapeSettings_SetBottomRadius";
    GetBottomRadius :: (settings : *TaperedCapsuleShapeSettings) -> float #foreign JoltC "JPH_TaperedCapsuleShapeSettings_GetBottomRadius";
    IsValid :: (settings : *TaperedCapsuleShapeSettings) -> bool #foreign JoltC "JPH_TaperedCapsuleShapeSettings_IsValid";
    IsSphere :: (settings : *TaperedCapsuleShapeSettings) -> bool #foreign JoltC "JPH_TaperedCapsuleShapeSettings_IsSphere";
}

CylinderShapeSettings :: struct {
    #as using,except(base) base : ConvexShapeSettings;

    Create :: () -> *CylinderShapeSettings #foreign JoltC "JPH_CylinderShapeSettings_Create";

    SetHalfHeight :: (settings : *CylinderShapeSettings, halfHeight : float) -> void #foreign JoltC "JPH_CylinderShapeSettings_SetHalfHeight";
    GetHalfHeight :: (settings : *CylinderShapeSettings) -> float #foreign JoltC "JPH_CylinderShapeSettings_GetHalfHeight";
    SetRadius :: (settings : *CylinderShapeSettings, radius : float) -> void #foreign JoltC "JPH_CylinderShapeSettings_SetRadius";
    GetRadius :: (settings : *CylinderShapeSettings) -> float #foreign JoltC "JPH_CylinderShapeSettings_GetRadius";
    SetConvexRadius :: (settings : *CylinderShapeSettings, convexRadius : float) -> void #foreign JoltC "JPH_CylinderShapeSettings_SetConvexRadius";
    GetConvexRadius :: (settings : *CylinderShapeSettings) -> float #foreign JoltC "JPH_CylinderShapeSettings_GetConvexRadius";
}

TaperedCylinderShapeSettings :: struct {
    #as using,except(base) base : ConvexShapeSettings;

    Create :: () -> *TaperedCylinderShapeSettings #foreign JoltC "JPH_TaperedCylinderShapeSettings_Create";

    SetHalfHeight :: (settings : *TaperedCylinderShapeSettings, halfHeight : float) -> void #foreign JoltC "JPH_TaperedCylinderShapeSettings_SetHalfHeight";
    GetHalfHeight :: (settings : *TaperedCylinderShapeSettings) -> float #foreign JoltC "JPH_TaperedCylinderShapeSettings_GetHalfHeight";
    SetTopRadius :: (settings : *TaperedCylinderShapeSettings, topRadius : float) -> void #foreign JoltC "JPH_TaperedCylinderShapeSettings_SetTopRadius";
    GetTopRadius :: (settings : *TaperedCylinderShapeSettings) -> float #foreign JoltC "JPH_TaperedCylinderShapeSettings_GetTopRadius";
    SetBottomRadius :: (settings : *TaperedCylinderShapeSettings, bottomRadius : float) -> void #foreign JoltC "JPH_TaperedCylinderShapeSettings_SetBottomRadius";
    GetBottomRadius :: (settings : *TaperedCylinderShapeSettings) -> float #foreign JoltC "JPH_TaperedCylinderShapeSettings_GetBottomRadius";
    SetConvexRadius :: (settings : *TaperedCylinderShapeSettings, convexRadius : float) -> void #foreign JoltC "JPH_TaperedCylinderShapeSettings_SetConvexRadius";
    GetConvexRadius :: (settings : *TaperedCylinderShapeSettings) -> float #foreign JoltC "JPH_TaperedCylinderShapeSettings_GetConvexRadius";
}

ConvexHullShapeSettings :: struct {
    #as using,except(base) base : ConvexShapeSettings;

    Create :: () -> *ConvexHullShapeSettings #foreign JoltC "JPH_ConvexHullShapeSettings_Create";

    AddPoints :: (settings : *ConvexHullShapeSettings, points : *Vec3, count : u32) -> void #foreign JoltC "JPH_ConvexHullShapeSettings_AddPoints";
    GetNumPoints :: (settings : *ConvexHullShapeSettings) -> u32 #foreign JoltC "JPH_ConvexHullShapeSettings_GetNumPoints";
    GetPoints :: (settings : *ConvexHullShapeSettings) -> *Vec3 #foreign JoltC "JPH_ConvexHullShapeSettings_GetPoints";
    SetMaxConvexRadius :: (settings : *ConvexHullShapeSettings, maxConvexRadius : float) -> void #foreign JoltC "JPH_ConvexHullShapeSettings_SetMaxConvexRadius";
    GetMaxConvexRadius :: (settings : *ConvexHullShapeSettings) -> float #foreign JoltC "JPH_ConvexHullShapeSettings_GetMaxConvexRadius";
    SetMaxErrorConvexRadius :: (settings : *ConvexHullShapeSettings, maxErrorConvexRadius : float) -> void #foreign JoltC "JPH_ConvexHullShapeSettings_SetMaxErrorConvexRadius";
    GetMaxErrorConvexRadius :: (settings : *ConvexHullShapeSettings) -> float #foreign JoltC "JPH_ConvexHullShapeSettings_GetMaxErrorConvexRadius";
    SetHullTolerance :: (settings : *ConvexHullShapeSettings, hullTolerance : float) -> void #foreign JoltC "JPH_ConvexHullShapeSettings_SetHullTolerance";
    GetHullTolerance :: (settings : *ConvexHullShapeSettings) -> float #foreign JoltC "JPH_ConvexHullShapeSettings_GetHullTolerance";
}

CompoundShapeSettings :: struct {
    #as using,except(base) base : ShapeSettings;

    AddShape :: (settings : *CompoundShapeSettings, position : Vec3, rotation : Quat, subShape : *Shape, userData : u32) -> void #foreign JoltC "JPH_CompoundShapeSettings_AddShape";
    AddShapeSettings :: (settings : *CompoundShapeSettings, position : Vec3, rotation : Quat, subShapeSettings : *ShapeSettings, userData : u32) -> void #foreign JoltC "JPH_CompoundShapeSettings_AddShapeSettings";
}

StaticCompoundShapeSettings :: struct {
    #as using,except(base) base : CompoundShapeSettings;

    Create :: () -> *StaticCompoundShapeSettings #foreign JoltC "JPH_StaticCompoundShapeSettings_Create";
}

MutableCompoundShapeSettings :: struct {
    #as using,except(base) base : CompoundShapeSettings;

    Create :: () -> *MutableCompoundShapeSettings #foreign JoltC "JPH_MutableCompoundShapeSettings_Create";
}

DecoratedShapeSettings :: struct {
    #as using,except(base) base : ShapeSettings;
}

RotatedTranslatedShapeSettings :: struct {
    #as using,except(base) base : DecoratedShapeSettings;

    Create :: () -> *RotatedTranslatedShapeSettings #foreign JoltC "JPH_RotatedTranslatedShapeSettings_Create";

    SetInnerShape :: (settings : *RotatedTranslatedShapeSettings, innerShape : *Shape) -> void #foreign JoltC "JPH_RotatedTranslatedShapeSettings_SetInnerShape";
    GetInnerShape :: (settings : *RotatedTranslatedShapeSettings) -> *Shape #foreign JoltC "JPH_RotatedTranslatedShapeSettings_GetInnerShape";
    SetInnerShapeSettings :: (settings : *RotatedTranslatedShapeSettings, innerShapeSettings : *ShapeSettings) -> void #foreign JoltC "JPH_RotatedTranslatedShapeSettings_SetInnerShapeSettings";
    GetInnerShapeSettings :: (settings : *RotatedTranslatedShapeSettings) -> *ShapeSettings #foreign JoltC "JPH_RotatedTranslatedShapeSettings_GetInnerShapeSettings";
    SetPosition :: (settings : *RotatedTranslatedShapeSettings, position : Vec3) -> void #foreign JoltC "JPH_RotatedTranslatedShapeSettings_SetPosition";
    GetPosition :: (settings : *RotatedTranslatedShapeSettings) -> Vec3 #foreign JoltC "JPH_RotatedTranslatedShapeSettings_GetPosition";
    SetRotation :: (settings : *RotatedTranslatedShapeSettings, rotation : Quat) -> void #foreign JoltC "JPH_RotatedTranslatedShapeSettings_SetRotation";
    GetRotation :: (settings : *RotatedTranslatedShapeSettings) -> Quat #foreign JoltC "JPH_RotatedTranslatedShapeSettings_GetRotation";
}

ScaledShapeSettings :: struct {
    #as using,except(base) base : DecoratedShapeSettings;

    Create :: () -> *ScaledShapeSettings #foreign JoltC "JPH_ScaledShapeSettings_Create";

    SetInnerShape :: (settings : *ScaledShapeSettings, innerShape : *Shape) -> void #foreign JoltC "JPH_ScaledShapeSettings_SetInnerShape";
    GetInnerShape :: (settings : *ScaledShapeSettings) -> *Shape #foreign JoltC "JPH_ScaledShapeSettings_GetInnerShape";
    SetInnerShapeSettings :: (settings : *ScaledShapeSettings, innerShapeSettings : *ShapeSettings) -> void #foreign JoltC "JPH_ScaledShapeSettings_SetInnerShapeSettings";
    GetInnerShapeSettings :: (settings : *ScaledShapeSettings) -> *ShapeSettings #foreign JoltC "JPH_ScaledShapeSettings_GetInnerShapeSettings";
    SetScale :: (settings : *ScaledShapeSettings, scale : Vec3) -> void #foreign JoltC "JPH_ScaledShapeSettings_SetScale";
    GetScale :: (settings : *ScaledShapeSettings) -> Vec3 #foreign JoltC "JPH_ScaledShapeSettings_GetScale";
}

OffsetCenterOfMassShapeSettings :: struct {
    #as using,except(base) base : DecoratedShapeSettings;

    Create :: () -> *OffsetCenterOfMassShapeSettings #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_Create";

    SetInnerShape :: (settings : *OffsetCenterOfMassShapeSettings, innerShape : *Shape) -> void #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_SetInnerShape";
    GetInnerShape :: (settings : *OffsetCenterOfMassShapeSettings) -> *Shape #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_GetInnerShape";
    SetInnerShapeSettings :: (settings : *OffsetCenterOfMassShapeSettings, innerShapeSettings : *ShapeSettings) -> void #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_SetInnerShapeSettings";
    GetInnerShapeSettings :: (settings : *OffsetCenterOfMassShapeSettings) -> *ShapeSettings #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_GetInnerShapeSettings";
    SetOffset :: (settings : *OffsetCenterOfMassShapeSettings, offset : Vec3) -> void #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_SetOffset";
    GetOffset :: (settings : *OffsetCenterOfMassShapeSettings) -> Vec3 #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_GetOffset";
}

Shape :: struct {
    SupportingFace :: struct {
        size : u32;
        elements : [32]Vec3;
    }

    GetTrianglesContext :: struct {
        data : [4288]u8;
    }

    Stats :: struct {
        sizeBytes : u64;
        numTriangles : u32;
    }

    opaque : s8;

    AddRef :: (shape : *Shape) -> void #foreign JoltC "JPH_Shape_AddRef";
    Release :: (shape : *Shape) -> void #foreign JoltC "JPH_Shape_Release";
    GetType :: (shape : *Shape) -> EShapeType #foreign JoltC "JPH_Shape_GetType";
    GetSubType :: (shape : *Shape) -> EShapeSubType #foreign JoltC "JPH_Shape_GetSubType";
    GetUserData :: (shape : *Shape) -> u64 #foreign JoltC "JPH_Shape_GetUserData";
    SetUserData :: (shape : *Shape, userData : u64) -> void #foreign JoltC "JPH_Shape_SetUserData";
    MustBeStatic :: (shape : *Shape) -> bool #foreign JoltC "JPH_Shape_MustBeStatic";
    GetCenterOfMass :: (shape : *Shape) -> Vec3 #foreign JoltC "JPH_Shape_GetCenterOfMass";
    GetLocalBounds :: (shape : *Shape) -> AABox #foreign JoltC "JPH_Shape_GetLocalBounds";
    GetSubShapeIDBitsRecursive :: (shape : *Shape) -> u32 #foreign JoltC "JPH_Shape_GetSubShapeIDBitsRecursive";
    GetWorldSpaceBounds :: (shape : *Shape, centerOfMassTransform : Mat44, scale : Vec3) -> AABox #foreign JoltC "JPH_Shape_GetWorldSpaceBounds";
    GetInnerRadius :: (shape : *Shape) -> float #foreign JoltC "JPH_Shape_GetInnerRadius";
    GetMassProperties :: (shape : *Shape) -> MassProperties #foreign JoltC "JPH_Shape_GetMassProperties";
    GetLeafShape :: (shape : *Shape, subShapeID : SubShapeID, outRemainder : *SubShapeID) -> *Shape #foreign JoltC "JPH_Shape_GetLeafShape";
    GetMaterial :: (shape : *Shape, subShapeID : SubShapeID) -> *PhysicsMaterial #foreign JoltC "JPH_Shape_GetMaterial";
    GetSurfaceNormal :: (shape : *Shape, subShapeID : SubShapeID, localSurfacePosition : Vec3) -> Vec3 #foreign JoltC "JPH_Shape_GetSurfaceNormal";
    GetSupportingFace :: (shape : *Shape, subShapeID : SubShapeID, direction : Vec3, scale : Vec3, centerOfMassTransform : Mat44, outVertices : *Shape.SupportingFace) -> void #foreign JoltC "JPH_Shape_GetSupportingFace";
    GetSubShapeUserData :: (shape : *Shape, subShapeID : SubShapeID) -> u64 #foreign JoltC "JPH_Shape_GetSubShapeUserData";
    GetSubmergedVolume :: (shape : *Shape, centerOfMassTransform : Mat44, scale : Vec3, surface : Plane, outTotalVolume : *float, outSubmergedVolume : *float, outCenterOfBuoyancy : *Vec3) -> void #foreign JoltC "JPH_Shape_GetSubmergedVolume";
    GetTrianglesStart :: (shape : *Shape, ioContext : *Shape.GetTrianglesContext, box : AABox, positionCOM : Vec3, rotation : Quat, scale : Vec3) -> void #foreign JoltC "JPH_Shape_GetTrianglesStart";
    GetTrianglesNext :: (shape : *Shape, ioContext : *Shape.GetTrianglesContext, maxTrianglesRequested : u32, outTriangleVertices : *Float3, outMaterials : **PhysicsMaterial) -> u32 #foreign JoltC "JPH_Shape_GetTrianglesNext";
    GetStats :: (shape : *Shape) -> Shape.Stats #foreign JoltC "JPH_Shape_GetStats";
    GetVolume :: (shape : *Shape) -> float #foreign JoltC "JPH_Shape_GetVolume";
    IsValidScale :: (shape : *Shape, scale : Vec3) -> bool #foreign JoltC "JPH_Shape_IsValidScale";
    MakeScaleValid :: (shape : *Shape, scale : Vec3) -> Vec3 #foreign JoltC "JPH_Shape_MakeScaleValid";
    ScaleShape :: (shape : *Shape, scale : Vec3) -> *Shape #foreign JoltC "JPH_Shape_ScaleShape";
}

EmptyShape :: struct {
    #as using,except(base) base : Shape;
}

PlaneShape :: struct {
    #as using,except(base) base : Shape;

    GetPlane :: (shape : *PlaneShape) -> Plane #foreign JoltC "JPH_PlaneShape_GetPlane";
    GetHalfExtent :: (shape : *PlaneShape) -> float #foreign JoltC "JPH_PlaneShape_GetHalfExtent";
    SetMaterial :: (shape : *PlaneShape, material : *PhysicsMaterial) -> void #foreign JoltC "JPH_PlaneShape_SetMaterial";
    GetMaterial :: (shape : *PlaneShape) -> *PhysicsMaterial #foreign JoltC "JPH_PlaneShape_GetMaterial";
}

MeshShape :: struct {
    #as using,except(base) base : Shape;

    GetMaterialIndex :: (shape : *MeshShape, subShapeID : SubShapeID) -> u32 #foreign JoltC "JPH_MeshShape_GetMaterialIndex";
    GetTriangleUserData :: (shape : *MeshShape, subShapeID : SubShapeID) -> u32 #foreign JoltC "JPH_MeshShape_GetTriangleUserData";
}

HeightFieldShape :: struct {
    #as using,except(base) base : Shape;

    GetSampleCount :: (shape : *HeightFieldShape) -> u32 #foreign JoltC "JPH_HeightFieldShape_GetSampleCount";
    GetBlockSize :: (shape : *HeightFieldShape) -> u32 #foreign JoltC "JPH_HeightFieldShape_GetBlockSize";
    GetMaterial :: (shape : *HeightFieldShape, x : u32, y : u32) -> *PhysicsMaterial #foreign JoltC "JPH_HeightFieldShape_GetMaterial";
    GetPosition :: (shape : *HeightFieldShape, x : u32, y : u32) -> Vec3 #foreign JoltC "JPH_HeightFieldShape_GetPosition";
    IsNoCollision :: (shape : *HeightFieldShape, x : u32, y : u32) -> bool #foreign JoltC "JPH_HeightFieldShape_IsNoCollision";
    ProjectOntoSurface :: (shape : *HeightFieldShape, localPosition : Vec3, outSurfacePosition : *Vec3, outSubShapeID : *SubShapeID) -> bool #foreign JoltC "JPH_HeightFieldShape_ProjectOntoSurface";
    GetSubShapeCoordinates :: (shape : *HeightFieldShape, subShapeID : SubShapeID, outX : *u32, outY : *u32, outTriangleIndex : *u32) -> void #foreign JoltC "JPH_HeightFieldShape_GetSubShapeCoordinates";
    GetMinHeightValue :: (shape : *HeightFieldShape) -> float #foreign JoltC "JPH_HeightFieldShape_GetMinHeightValue";
    GetMaxHeightValue :: (shape : *HeightFieldShape) -> float #foreign JoltC "JPH_HeightFieldShape_GetMaxHeightValue";
    GetHeights :: (shape : *HeightFieldShape, x : u32, y : u32, sizeX : u32, sizeY : u32, outHeights : *float, heightsStride : s64) -> void #foreign JoltC "JPH_HeightFieldShape_GetHeights";
    SetHeights :: (shape : *HeightFieldShape, x : u32, y : u32, sizeX : u32, sizeY : u32, inHeights : *float, heightsStride : s64, allocator : *TempAllocator, activeEdgeCosThresholdAngle : float) -> void #foreign JoltC "JPH_HeightFieldShape_SetHeights";
}

ConvexShape :: struct {
    #as using,except(base) base : Shape;

    SetMaterial :: (shape : *ConvexShape, material : *PhysicsMaterial) -> void #foreign JoltC "JPH_ConvexShape_SetMaterial";
    GetMaterial :: (shape : *ConvexShape) -> *PhysicsMaterial #foreign JoltC "JPH_ConvexShape_GetMaterial";
    SetDensity :: (shape : *ConvexShape, density : float) -> void #foreign JoltC "JPH_ConvexShape_SetDensity";
    GetDensity :: (shape : *ConvexShape) -> float #foreign JoltC "JPH_ConvexShape_GetDensity";
}

SphereShape :: struct {
    #as using,except(base) base : ConvexShape;

    GetRadius :: (shape : *SphereShape) -> float #foreign JoltC "JPH_SphereShape_GetRadius";
}

BoxShape :: struct {
    #as using,except(base) base : ConvexShape;

    GetHalfExtent :: (shape : *BoxShape) -> Vec3 #foreign JoltC "JPH_BoxShape_GetHalfExtent";
    GetConvexRadius :: (shape : *BoxShape) -> float #foreign JoltC "JPH_BoxShape_GetConvexRadius";
}

TriangleShape :: struct {
    #as using,except(base) base : ConvexShape;

    GetVertex1 :: (shape : *TriangleShape) -> Vec3 #foreign JoltC "JPH_TriangleShape_GetVertex1";
    GetVertex2 :: (shape : *TriangleShape) -> Vec3 #foreign JoltC "JPH_TriangleShape_GetVertex2";
    GetVertex3 :: (shape : *TriangleShape) -> Vec3 #foreign JoltC "JPH_TriangleShape_GetVertex3";
    GetVertices :: (shape : *TriangleShape, outV1 : *Vec3, outV2 : *Vec3, outV3 : *Vec3) -> void #foreign JoltC "JPH_TriangleShape_GetVertices";
    GetConvexRadius :: (shape : *TriangleShape) -> float #foreign JoltC "JPH_TriangleShape_GetConvexRadius";
}

CapsuleShape :: struct {
    #as using,except(base) base : ConvexShape;

    GetRadius :: (shape : *CapsuleShape) -> float #foreign JoltC "JPH_CapsuleShape_GetRadius";
    GetHalfHeightOfCylinder :: (shape : *CapsuleShape) -> float #foreign JoltC "JPH_CapsuleShape_GetHalfHeightOfCylinder";
}

TaperedCapsuleShape :: struct {
    #as using,except(base) base : ConvexShape;

    GetTopRadius :: (shape : *TaperedCapsuleShape) -> float #foreign JoltC "JPH_TaperedCapsuleShape_GetTopRadius";
    GetBottomRadius :: (shape : *TaperedCapsuleShape) -> float #foreign JoltC "JPH_TaperedCapsuleShape_GetBottomRadius";
    GetHalfHeight :: (shape : *TaperedCapsuleShape) -> float #foreign JoltC "JPH_TaperedCapsuleShape_GetHalfHeight";
}

CylinderShape :: struct {
    #as using,except(base) base : ConvexShape;

    GetHalfHeight :: (shape : *CylinderShape) -> float #foreign JoltC "JPH_CylinderShape_GetHalfHeight";
    GetRadius :: (shape : *CylinderShape) -> float #foreign JoltC "JPH_CylinderShape_GetRadius";
    GetConvexRadius :: (shape : *CylinderShape) -> float #foreign JoltC "JPH_CylinderShape_GetConvexRadius";
}

TaperedCylinderShape :: struct {
    #as using,except(base) base : ConvexShape;

    GetTopRadius :: (shape : *TaperedCylinderShape) -> float #foreign JoltC "JPH_TaperedCylinderShape_GetTopRadius";
    GetBottomRadius :: (shape : *TaperedCylinderShape) -> float #foreign JoltC "JPH_TaperedCylinderShape_GetBottomRadius";
    GetConvexRadius :: (shape : *TaperedCylinderShape) -> float #foreign JoltC "JPH_TaperedCylinderShape_GetConvexRadius";
    GetHalfHeight :: (shape : *TaperedCylinderShape) -> float #foreign JoltC "JPH_TaperedCylinderShape_GetHalfHeight";
}

ConvexHullShape :: struct {
    #as using,except(base) base : ConvexShape;

    GetConvexRadius :: (shape : *ConvexHullShape) -> float #foreign JoltC "JPH_ConvexHullShape_GetConvexRadius";
    GetNumPoints :: (shape : *ConvexHullShape) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetNumPoints";
    GetPoint :: (shape : *ConvexHullShape, index : u32) -> Vec3 #foreign JoltC "JPH_ConvexHullShape_GetPoint";
    GetNumFaces :: (shape : *ConvexHullShape) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetNumFaces";
    GetNumVerticesInFace :: (shape : *ConvexHullShape, faceIndex : u32) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetNumVerticesInFace";
    GetFaceVertices :: (shape : *ConvexHullShape, faceIndex : u32, maxVertices : u32, outVertices : *u32) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetFaceVertices";
    GetNumPlanes :: (shape : *ConvexHullShape) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetNumPlanes";
    GetPlanes :: (shape : *ConvexHullShape) -> *Plane #foreign JoltC "JPH_ConvexHullShape_GetPlanes";
}

CompoundShape :: struct {
    #as using,except(base) base : Shape;

    GetNumSubShapes :: (shape : *CompoundShape) -> u32 #foreign JoltC "JPH_CompoundShape_GetNumSubShapes";
    GetCompoundUserData :: (shape : *CompoundShape, index : u32) -> u32 #foreign JoltC "JPH_CompoundShape_GetCompoundUserData";
    SetCompoundUserData :: (shape : *CompoundShape, index : u32, userData : u32) -> void #foreign JoltC "JPH_CompoundShape_SetCompoundUserData";
    IsSubShapeIDValid :: (shape : *CompoundShape, subShapeID : SubShapeID) -> bool #foreign JoltC "JPH_CompoundShape_IsSubShapeIDValid";
    GetSubShapeIndexFromID :: (shape : *CompoundShape, subShapeID : SubShapeID, outRemainder : *SubShapeID) -> u32 #foreign JoltC "JPH_CompoundShape_GetSubShapeIndexFromID";
}

StaticCompoundShape :: struct {
    #as using,except(base) base : CompoundShape;
}

MutableCompoundShape :: struct {
    #as using,except(base) base : CompoundShape;

    AddShape :: (shape : *MutableCompoundShape, position : Vec3, rotation : Quat, inShape : *Shape, userData : u32, index : u32) -> u32 #foreign JoltC "JPH_MutableCompoundShape_AddShape";
    RemoveShape :: (shape : *MutableCompoundShape, index : u32) -> void #foreign JoltC "JPH_MutableCompoundShape_RemoveShape";
    ModifyShape :: (shape : *MutableCompoundShape, index : u32, position : Vec3, rotation : Quat) -> void #foreign JoltC "JPH_MutableCompoundShape_ModifyShape";
    ModifyShapeWithShape :: (shape : *MutableCompoundShape, index : u32, position : Vec3, rotation : Quat, inShape : *Shape) -> void #foreign JoltC "JPH_MutableCompoundShape_ModifyShapeWithShape";
    ModifyShapes :: (shape : *MutableCompoundShape, startIndex : u32, number : u32, positions : *Vec3, rotations : *Quat, positionStride : u32, rotationStride : u32) -> void #foreign JoltC "JPH_MutableCompoundShape_ModifyShapes";
    AdjustCenterOfMass :: (shape : *MutableCompoundShape) -> void #foreign JoltC "JPH_MutableCompoundShape_AdjustCenterOfMass";
}

DecoratedShape :: struct {
    #as using,except(base) base : Shape;

    GetInnerShape :: (shape : *DecoratedShape) -> *Shape #foreign JoltC "JPH_DecoratedShape_GetInnerShape";
}

RotatedTranslatedShape :: struct {
    #as using,except(base) base : DecoratedShape;

    GetRotation :: (shape : *RotatedTranslatedShape) -> Quat #foreign JoltC "JPH_RotatedTranslatedShape_GetRotation";
    GetPosition :: (shape : *RotatedTranslatedShape) -> Vec3 #foreign JoltC "JPH_RotatedTranslatedShape_GetPosition";
    TransformScale :: (shape : *RotatedTranslatedShape, scale : Vec3) -> Vec3 #foreign JoltC "JPH_RotatedTranslatedShape_TransformScale";
}

ScaledShape :: struct {
    #as using,except(base) base : DecoratedShape;

    GetScale :: (shape : *ScaledShape) -> Vec3 #foreign JoltC "JPH_ScaledShape_GetScale";
}

OffsetCenterOfMassShape :: struct {
    #as using,except(base) base : DecoratedShape;

    GetOffset :: (shape : *OffsetCenterOfMassShape) -> Vec3 #foreign JoltC "JPH_OffsetCenterOfMassShape_GetOffset";
}

IndexedTriangle :: struct {
    idx : [3]u32;
    materialIndex : u32;
    userData : u32;
}

MassProperties :: struct {
    mass : float;
    inertia : Mat44;

    GetEquivalentSolidBoxSize :: (mass : float, inertiaDiagonal : Vec3) -> Vec3 #foreign JoltC "JPH_MassProperties_GetEquivalentSolidBoxSize";

    DecomposePrincipalMomentsOfInertia :: (massProperties : *MassProperties, outRotation : *Mat44, outDiagonal : *Vec3) -> bool #foreign JoltC "JPH_MassProperties_DecomposePrincipalMomentsOfInertia";
    SetMassAndInertiaOfSolidBox :: (massProperties : *MassProperties, boxSize : Vec3, density : float) -> void #foreign JoltC "JPH_MassProperties_SetMassAndInertiaOfSolidBox";
    ScaleToMass :: (massProperties : *MassProperties, mass : float) -> void #foreign JoltC "JPH_MassProperties_ScaleToMass";
    Rotate :: (massProperties : *MassProperties, rotation : Mat44) -> void #foreign JoltC "JPH_MassProperties_Rotate";
    Translate :: (massProperties : *MassProperties, translation : Vec3) -> void #foreign JoltC "JPH_MassProperties_Translate";
    Scale :: (massProperties : *MassProperties, scale : Vec3) -> void #foreign JoltC "JPH_MassProperties_Scale";
}

Body :: struct {
    GetID :: (body : *Body) -> BodyID #foreign JoltC "JPH_Body_GetID";
    GetBodyType :: (body : *Body) -> EBodyType #foreign JoltC "JPH_Body_GetBodyType";
    IsRigidBody :: (body : *Body) -> bool #foreign JoltC "JPH_Body_IsRigidBody";
    IsSoftBody :: (body : *Body) -> bool #foreign JoltC "JPH_Body_IsSoftBody";
    IsActive :: (body : *Body) -> bool #foreign JoltC "JPH_Body_IsActive";
    IsStatic :: (body : *Body) -> bool #foreign JoltC "JPH_Body_IsStatic";
    IsKinematic :: (body : *Body) -> bool #foreign JoltC "JPH_Body_IsKinematic";
    IsDynamic :: (body : *Body) -> bool #foreign JoltC "JPH_Body_IsDynamic";
    CanBeKinematicOrDynamic :: (body : *Body) -> bool #foreign JoltC "JPH_Body_CanBeKinematicOrDynamic";
    SetIsSensor :: (body : *Body, isSensor : bool) -> void #foreign JoltC "JPH_Body_SetIsSensor";
    IsSensor :: (body : *Body) -> bool #foreign JoltC "JPH_Body_IsSensor";
    SetCollideKinematicVsNonDynamic :: (body : *Body, collide : bool) -> void #foreign JoltC "JPH_Body_SetCollideKinematicVsNonDynamic";
    GetCollideKinematicVsNonDynamic :: (body : *Body) -> bool #foreign JoltC "JPH_Body_GetCollideKinematicVsNonDynamic";
    SetUseManifoldReduction :: (body : *Body, useReduction : bool) -> void #foreign JoltC "JPH_Body_SetUseManifoldReduction";
    GetUseManifoldReduction :: (body : *Body) -> bool #foreign JoltC "JPH_Body_GetUseManifoldReduction";
    GetUseManifoldReductionWithBody :: (body : *Body, body2 : *Body) -> bool #foreign JoltC "JPH_Body_GetUseManifoldReductionWithBody";
    SetApplyGyroscopicForce :: (body : *Body, apply : bool) -> void #foreign JoltC "JPH_Body_SetApplyGyroscopicForce";
    GetApplyGyroscopicForce :: (body : *Body) -> bool #foreign JoltC "JPH_Body_GetApplyGyroscopicForce";
    SetEnhancedInternalEdgeRemoval :: (body : *Body, apply : bool) -> void #foreign JoltC "JPH_Body_SetEnhancedInternalEdgeRemoval";
    GetEnhancedInternalEdgeRemoval :: (body : *Body) -> bool #foreign JoltC "JPH_Body_GetEnhancedInternalEdgeRemoval";
    GetEnhancedInternalEdgeRemovalWithBody :: (body : *Body, body2 : *Body) -> bool #foreign JoltC "JPH_Body_GetEnhancedInternalEdgeRemovalWithBody";
    GetMotionType :: (body : *Body) -> EMotionType #foreign JoltC "JPH_Body_GetMotionType";
    SetMotionType :: (body : *Body, motionType : EMotionType) -> void #foreign JoltC "JPH_Body_SetMotionType";
    GetBroadPhaseLayer :: (body : *Body) -> BroadPhaseLayer #foreign JoltC "JPH_Body_GetBroadPhaseLayer";
    GetObjectLayer :: (body : *Body) -> ObjectLayer #foreign JoltC "JPH_Body_GetObjectLayer";
    GetCollisionGroupConst :: (body : *Body) -> *CollisionGroup #foreign JoltC "JPH_Body_GetCollisionGroupConst";
    GetCollisionGroup :: (body : *Body) -> *CollisionGroup #foreign JoltC "JPH_Body_GetCollisionGroup";
    SetCollisionGroup :: (body : *Body, group : *CollisionGroup) -> void #foreign JoltC "JPH_Body_SetCollisionGroup";
    GetAllowSleeping :: (body : *Body) -> bool #foreign JoltC "JPH_Body_GetAllowSleeping";
    SetAllowSleeping :: (body : *Body, allow : bool) -> void #foreign JoltC "JPH_Body_SetAllowSleeping";
    ResetSleepTimer :: (body : *Body) -> void #foreign JoltC "JPH_Body_ResetSleepTimer";
    GetFriction :: (body : *Body) -> float #foreign JoltC "JPH_Body_GetFriction";
    SetFriction :: (body : *Body, friction : float) -> void #foreign JoltC "JPH_Body_SetFriction";
    GetRestitution :: (body : *Body) -> float #foreign JoltC "JPH_Body_GetRestitution";
    SetRestitution :: (body : *Body, restitution : float) -> void #foreign JoltC "JPH_Body_SetRestitution";
    GetLinearVelocity :: (body : *Body) -> Vec3 #foreign JoltC "JPH_Body_GetLinearVelocity";
    SetLinearVelocity :: (body : *Body, linearVelocity : Vec3) -> void #foreign JoltC "JPH_Body_SetLinearVelocity";
    SetLinearVelocityClamped :: (body : *Body, linearVelocity : Vec3) -> void #foreign JoltC "JPH_Body_SetLinearVelocityClamped";
    GetAngularVelocity :: (body : *Body) -> Vec3 #foreign JoltC "JPH_Body_GetAngularVelocity";
    SetAngularVelocity :: (body : *Body, angularVelocity : Vec3) -> void #foreign JoltC "JPH_Body_SetAngularVelocity";
    SetAngularVelocityClamped :: (body : *Body, angularVelocity : Vec3) -> void #foreign JoltC "JPH_Body_SetAngularVelocityClamped";
    GetPointVelocityCOM :: (body : *Body, pointRelativeToCOM : Vec3) -> Vec3 #foreign JoltC "JPH_Body_GetPointVelocityCOM";
    GetPointVelocity :: (body : *Body, point : RVec3) -> Vec3 #foreign JoltC "JPH_Body_GetPointVelocity";
    AddForce :: (body : *Body, force : Vec3) -> void #foreign JoltC "JPH_Body_AddForce";
    AddForceAtPoint :: (body : *Body, force : Vec3, position : RVec3) -> void #foreign JoltC "JPH_Body_AddForceAtPoint";
    AddTorque :: (body : *Body, torque : Vec3) -> void #foreign JoltC "JPH_Body_AddTorque";
    GetAccumulatedForce :: (body : *Body) -> Vec3 #foreign JoltC "JPH_Body_GetAccumulatedForce";
    GetAccumulatedTorque :: (body : *Body) -> Vec3 #foreign JoltC "JPH_Body_GetAccumulatedTorque";
    ResetForce :: (body : *Body) -> void #foreign JoltC "JPH_Body_ResetForce";
    ResetTorque :: (body : *Body) -> void #foreign JoltC "JPH_Body_ResetTorque";
    ResetMotion :: (body : *Body) -> void #foreign JoltC "JPH_Body_ResetMotion";
    GetInverseInertia :: (body : *Body) -> Mat44 #foreign JoltC "JPH_Body_GetInverseInertia";
    AddImpulse :: (body : *Body, impulse : Vec3) -> void #foreign JoltC "JPH_Body_AddImpulse";
    AddImpulseAtPoint :: (body : *Body, impulse : Vec3, position : RVec3) -> void #foreign JoltC "JPH_Body_AddImpulseAtPoint";
    AddAngularImpulse :: (body : *Body, angularImpulse : Vec3) -> void #foreign JoltC "JPH_Body_AddAngularImpulse";
    MoveKinematic :: (body : *Body, targetPosition : RVec3, targetRotation : Quat, deltaTime : float) -> void #foreign JoltC "JPH_Body_MoveKinematic";
    GetSubmergedVolume :: (body : *Body, surfacePosition : RVec3, surfaceNormal : Vec3, outTotalVolume : *float, outSubmergedVolume : *float, outRelativeCenterOfBuoyancy : *Vec3) -> void #foreign JoltC "JPH_Body_GetSubmergedVolume";
    ApplyBuoyancyImpulseWithSurface :: (body : *Body, surfacePosition : RVec3, surfaceNormal : Vec3, buoyancy : float, linearDrag : float, angularDrag : float, fluidVelocity : Vec3, gravity : Vec3, deltaTime : float) -> bool #foreign JoltC "JPH_Body_ApplyBuoyancyImpulseWithSurface";
    ApplyBuoyancyImpulse :: (body : *Body, totalVolume : float, submergedVolume : float, relativeCenterOfBuoyancy : Vec3, buoyancy : float, linearDrag : float, angularDrag : float, fluidVelocity : Vec3, gravity : Vec3, deltaTime : float) -> bool #foreign JoltC "JPH_Body_ApplyBuoyancyImpulse";
    IsInBroadPhase :: (body : *Body) -> bool #foreign JoltC "JPH_Body_IsInBroadPhase";
    IsCollisionCacheInvalid :: (body : *Body) -> bool #foreign JoltC "JPH_Body_IsCollisionCacheInvalid";
    GetShape :: (body : *Body) -> *Shape #foreign JoltC "JPH_Body_GetShape";
    GetPosition :: (body : *Body) -> RVec3 #foreign JoltC "JPH_Body_GetPosition";
    GetRotation :: (body : *Body) -> Quat #foreign JoltC "JPH_Body_GetRotation";
    GetWorldTransform :: (body : *Body) -> RMat44 #foreign JoltC "JPH_Body_GetWorldTransform";
    GetCenterOfMassPosition :: (body : *Body) -> RVec3 #foreign JoltC "JPH_Body_GetCenterOfMassPosition";
    GetCenterOfMassTransform :: (body : *Body) -> RMat44 #foreign JoltC "JPH_Body_GetCenterOfMassTransform";
    GetInverseCenterOfMassTransform :: (body : *Body) -> RMat44 #foreign JoltC "JPH_Body_GetInverseCenterOfMassTransform";
    GetWorldSpaceBounds :: (body : *Body) -> AABox #foreign JoltC "JPH_Body_GetWorldSpaceBounds";
    GetMotionPropertiesConst :: (body : *Body) -> *MotionProperties #foreign JoltC "JPH_Body_GetMotionPropertiesConst";
    GetMotionProperties :: (body : *Body) -> *MotionProperties #foreign JoltC "JPH_Body_GetMotionProperties";
    GetMotionPropertiesUncheckedConst :: (body : *Body) -> *MotionProperties #foreign JoltC "JPH_Body_GetMotionPropertiesUncheckedConst";
    GetMotionPropertiesUnchecked :: (body : *Body) -> *MotionProperties #foreign JoltC "JPH_Body_GetMotionPropertiesUnchecked";
    GetUserData :: (body : *Body) -> u64 #foreign JoltC "JPH_Body_GetUserData";
    SetUserData :: (body : *Body, userData : u64) -> void #foreign JoltC "JPH_Body_SetUserData";
    GetWorldSpaceSurfaceNormal :: (body : *Body, subShapeID : SubShapeID, position : RVec3) -> Vec3 #foreign JoltC "JPH_Body_GetWorldSpaceSurfaceNormal";
    GetBodyCreationSettings :: (body : *Body) -> BodyCreationSettings #foreign JoltC "JPH_Body_GetBodyCreationSettings";
    ApplyBodyCreationSettings :: (body : *Body, bodyCreationSettings : *BodyCreationSettings, bplInterface : *BroadPhaseLayerInterface) -> void #foreign JoltC "JPH_Body_ApplyBodyCreationSettings";
    GetSoftBodyCreationSettings :: (body : *Body) -> SoftBodyCreationSettings #foreign JoltC "JPH_Body_GetSoftBodyCreationSettings";
    ApplySoftBodyCreationSettings :: (body : *Body, softBodyCreationSettings : *SoftBodyCreationSettings, bplInterface : *BroadPhaseLayerInterface) -> void #foreign JoltC "JPH_Body_ApplySoftBodyCreationSettings";
}

BroadPhaseLayerInterface :: struct {
    Funcs :: struct {
        Destruct : *#type (*void) -> void #c_call;
        GetNumBroadPhaseLayers : *#type (*void) -> u32 #c_call;
        GetBroadPhaseLayer : *#type (*void, ObjectLayer) -> BroadPhaseLayer #c_call;
    }

    opaque : s8;

    Create :: (data : *void, funcs : BroadPhaseLayerInterface.Funcs, allocator : JoltCAllocator) -> *BroadPhaseLayerInterface #foreign JoltC "JPH_BroadPhaseLayerInterface_Create";

    Destroy :: (self : *BroadPhaseLayerInterface) -> void #foreign JoltC "JPH_BroadPhaseLayerInterface_Destroy";
    GetNumBroadPhaseLayers :: (bplInterface : *BroadPhaseLayerInterface) -> u32 #foreign JoltC "JPH_BroadPhaseLayerInterface_GetNumBroadPhaseLayers";
    GetBroadPhaseLayer :: (bplInterface : *BroadPhaseLayerInterface, objectLayer : ObjectLayer) -> BroadPhaseLayer #foreign JoltC "JPH_BroadPhaseLayerInterface_GetBroadPhaseLayer";
}

BroadPhaseLayerInterfaceTable :: struct {
    #as using,except(base) base : BroadPhaseLayerInterface;

    Create :: (numObjectLayers : u32, numBroadPhaseLayers : u32) -> *BroadPhaseLayerInterfaceTable #foreign JoltC "JPH_BroadPhaseLayerInterfaceTable_Create";

    MapObjectToBroadPhaseLayer :: (table : *BroadPhaseLayerInterfaceTable, objectLayer : ObjectLayer, broadPhaseLayer : BroadPhaseLayer) -> void #foreign JoltC "JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer";
}

BroadPhaseLayerInterfaceMask :: struct {
    #as using,except(base) base : BroadPhaseLayerInterface;

    Create :: (numBroadPhaseLayers : u32) -> *BroadPhaseLayerInterfaceMask #foreign JoltC "JPH_BroadPhaseLayerInterfaceMask_Create";

    ConfigureLayer :: (mask : *BroadPhaseLayerInterfaceMask, broadPhaseLayer : BroadPhaseLayer, groupsToInclude : u32, groupsToExclude : u32) -> void #foreign JoltC "JPH_BroadPhaseLayerInterfaceMask_ConfigureLayer";
}

ObjectLayerPairFilter :: struct {
    Funcs :: struct {
        Destruct : *#type (*void) -> void #c_call;
        ShouldCollide : *#type (*void, ObjectLayer, ObjectLayer) -> bool #c_call;
    }

    opaque : s8;

    Create :: (data : *void, funcs : ObjectLayerPairFilter.Funcs, allocator : JoltCAllocator) -> *ObjectLayerPairFilter #foreign JoltC "JPH_ObjectLayerPairFilter_Create";

    Destroy :: (self : *ObjectLayerPairFilter) -> void #foreign JoltC "JPH_ObjectLayerPairFilter_Destroy";
    ShouldCollide :: (filter : *ObjectLayerPairFilter, layer1 : ObjectLayer, layer2 : ObjectLayer) -> bool #foreign JoltC "JPH_ObjectLayerPairFilter_ShouldCollide";
}

ObjectLayerPairFilterTable :: struct {
    #as using,except(base) base : ObjectLayerPairFilter;

    Create :: (numObjectLayers : u32) -> *ObjectLayerPairFilterTable #foreign JoltC "JPH_ObjectLayerPairFilterTable_Create";

    GetNumObjectLayers :: (table : *ObjectLayerPairFilterTable) -> u32 #foreign JoltC "JPH_ObjectLayerPairFilterTable_GetNumObjectLayers";
    EnableCollision :: (table : *ObjectLayerPairFilterTable, layer1 : ObjectLayer, layer2 : ObjectLayer) -> void #foreign JoltC "JPH_ObjectLayerPairFilterTable_EnableCollision";
    DisableCollision :: (table : *ObjectLayerPairFilterTable, layer1 : ObjectLayer, layer2 : ObjectLayer) -> void #foreign JoltC "JPH_ObjectLayerPairFilterTable_DisableCollision";
}

ObjectLayerPairFilterMask :: struct {
    cNumBits :: (OBJECT_LAYER_BITS/2);
    cMask :: ((1<<ObjectLayerPairFilterMask.cNumBits)-1);

    #as using,except(base) base : ObjectLayerPairFilter;

    Create :: () -> *ObjectLayerPairFilterMask #foreign JoltC "JPH_ObjectLayerPairFilterMask_Create";
    GetGroup :: (objectLayer : ObjectLayer) -> u32 #foreign JoltC "JPH_ObjectLayerPairFilterMask_GetGroup";
    GetMask :: (objectLayer : ObjectLayer) -> u32 #foreign JoltC "JPH_ObjectLayerPairFilterMask_GetMask";
    GetObjectLayer :: (group : u32, mask : u32) -> ObjectLayer #foreign JoltC "JPH_ObjectLayerPairFilterMask_GetObjectLayer";
}

ObjectVsBroadPhaseLayerFilter :: struct {
    Funcs :: struct {
        Destruct : *#type (*void) -> void #c_call;
        ShouldCollide : *#type (*void, ObjectLayer, BroadPhaseLayer) -> bool #c_call;
    }

    opaque : s8;

    Create :: (data : *void, funcs : ObjectVsBroadPhaseLayerFilter.Funcs, allocator : JoltCAllocator) -> *ObjectVsBroadPhaseLayerFilter #foreign JoltC "JPH_ObjectVsBroadPhaseLayerFilter_Create";

    Destroy :: (self : *ObjectVsBroadPhaseLayerFilter) -> void #foreign JoltC "JPH_ObjectVsBroadPhaseLayerFilter_Destroy";
    ShouldCollide :: (filter : *ObjectVsBroadPhaseLayerFilter, objectLayer : ObjectLayer, broadPhaseLayer : BroadPhaseLayer) -> bool #foreign JoltC "JPH_ObjectVsBroadPhaseLayerFilter_ShouldCollide";
}

ObjectVsBroadPhaseLayerFilterTable :: struct {
    #as using,except(base) base : ObjectVsBroadPhaseLayerFilter;

    Create :: (bplInterface : *BroadPhaseLayerInterface, numBroadPhaseLayers : u32, objectLayerPairFilter : *ObjectLayerPairFilter, numObjectLayers : u32) -> *ObjectVsBroadPhaseLayerFilterTable #foreign JoltC "JPH_ObjectVsBroadPhaseLayerFilterTable_Create";
}

ObjectVsBroadPhaseLayerFilterMask :: struct {
    #as using,except(base) base : ObjectVsBroadPhaseLayerFilter;

    Create :: (bplInterface : *BroadPhaseLayerInterfaceMask) -> *ObjectVsBroadPhaseLayerFilterMask #foreign JoltC "JPH_ObjectVsBroadPhaseLayerFilterMask_Create";
}

BroadPhaseLayerFilter :: struct {
    Funcs :: struct {
        Destruct : *#type (*void) -> void #c_call;
        ShouldCollide : *#type (*void, BroadPhaseLayer) -> bool #c_call;
    }

    opaque : s8;

    Create :: (data : *void, funcs : BroadPhaseLayerFilter.Funcs, allocator : JoltCAllocator) -> *BroadPhaseLayerFilter #foreign JoltC "JPH_BroadPhaseLayerFilter_Create";

    Destroy :: (self : *BroadPhaseLayerFilter) -> void #foreign JoltC "JPH_BroadPhaseLayerFilter_Destroy";
}

ObjectLayerFilter :: struct {
    Funcs :: struct {
        Destruct : *#type (*void) -> void #c_call;
        ShouldCollide : *#type (*void, ObjectLayer) -> bool #c_call;
    }

    opaque : s8;

    Create :: (data : *void, funcs : ObjectLayerFilter.Funcs, allocator : JoltCAllocator) -> *ObjectLayerFilter #foreign JoltC "JPH_ObjectLayerFilter_Create";

    Destroy :: (self : *ObjectLayerFilter) -> void #foreign JoltC "JPH_ObjectLayerFilter_Destroy";
}

GroupFilter :: struct {
    opaque : s8;
}

BodyFilter :: struct {
    Funcs :: struct {
        Destruct : *#type (*void) -> void #c_call;
        ShouldCollide : *#type (*void, BodyID) -> bool #c_call;
        ShouldCollideLocked : *#type (*void, *Body) -> bool #c_call;
    }

    opaque : s8;

    Create :: (data : *void, funcs : BodyFilter.Funcs, allocator : JoltCAllocator) -> *BodyFilter #foreign JoltC "JPH_BodyFilter_Create";

    Destroy :: (self : *BodyFilter) -> void #foreign JoltC "JPH_BodyFilter_Destroy";
}

IgnoreMultipleBodiesFilter :: struct {
    #as using,except(base) base : BodyFilter;

    Create :: (bodyIDs : *BodyID, numBodies : s32, allocator : JoltCAllocator) -> *IgnoreMultipleBodiesFilter #foreign JoltC "JPH_IgnoreMultipleBodiesFilter_Create";
}

IgnoreSingleBodyFilter :: struct {
    #as using,except(base) base : BodyFilter;

    Create :: (bodyID : BodyID, allocator : JoltCAllocator) -> *IgnoreSingleBodyFilter #foreign JoltC "JPH_IgnoreSingleBodyFilter_Create";
}

IgnoreSingleBodyFilterChained :: struct {
    #as using,except(base) base : BodyFilter;

    Create :: (bodyID : BodyID, otherFilter : *BodyFilter, allocator : JoltCAllocator) -> *IgnoreSingleBodyFilterChained #foreign JoltC "JPH_IgnoreSingleBodyFilterChained_Create";
}

ShapeFilter :: struct {
    Funcs :: struct {
        Destruct : *#type (*void) -> void #c_call;
        ShouldCollide : *#type (*void, *Shape, SubShapeID) -> bool #c_call;
        ShapesShouldCollide : *#type (*void, *Shape, SubShapeID, *Shape, SubShapeID) -> bool #c_call;
    }

    opaque : s8;

    Create :: (data : *void, funcs : ShapeFilter.Funcs, allocator : JoltCAllocator) -> *ShapeFilter #foreign JoltC "JPH_ShapeFilter_Create";

    Destroy :: (self : *ShapeFilter) -> void #foreign JoltC "JPH_ShapeFilter_Destroy";
}

ReversedShapeFilter :: struct {
    #as using,except(base) base : ShapeFilter;

    Create :: (other : *ShapeFilter, allocator : JoltCAllocator) -> *ReversedShapeFilter #foreign JoltC "JPH_ReversedShapeFilter_Create";
}

BroadPhaseQuery :: struct {
    CastRayHitCallback :: *#type (*void, *BroadPhaseCastResult) -> void #c_call;
    CastRayCollectCallback :: *#type (*void, *BroadPhaseCastResult) -> float #c_call;

    GetBounds :: (query : *BroadPhaseQuery) -> AABox #foreign JoltC "JPH_BroadPhaseQuery_GetBounds";
    CastRay :: (query : *BroadPhaseQuery, ray : RayCast, collectorType : ECollisionCollectorType, data : *void, callback : BroadPhaseQuery.CastRayHitCallback, broadPhaseLayerFilter : *BroadPhaseLayerFilter, objectLayerFilter : *ObjectLayerFilter) -> bool #foreign JoltC "JPH_BroadPhaseQuery_CastRay";
}

NarrowPhaseQuery :: struct {
    CastRay :: (query : *NarrowPhaseQuery, ray : RRayCast, ioHit : *RayCastResult, broadPhaseLayerFilter : *BroadPhaseLayerFilter, objectLayerFilter : *ObjectLayerFilter, bodyFilter : *BodyFilter) -> bool #foreign JoltC "JPH_NarrowPhaseQuery_CastRay";
}

CollisionGroup :: struct {
    GroupID :: u32;
    SubGroupID :: u32;

    groupFilter : *GroupFilter;
    groupID : CollisionGroup.GroupID;
    subGroupID : CollisionGroup.SubGroupID;
}

DefaultBroadPhaseLayerFilter :: struct {
    objectVsBroadPhaseLayerFilter : *ObjectVsBroadPhaseLayerFilter;
    layer : ObjectLayer;

    ShouldCollide :: (data : *void, layer : BroadPhaseLayer) -> bool #foreign JoltC "JPH_DefaultBroadPhaseLayerFilter_ShouldCollide";

    CreateFilter :: (filter : *DefaultBroadPhaseLayerFilter, allocator : JoltCAllocator) -> *BroadPhaseLayerFilter #foreign JoltC "JPH_DefaultBroadPhaseLayerFilter_CreateFilter";
}

DefaultObjectLayerFilter :: struct {
    objectLayerPairFilter : *ObjectLayerPairFilter;
    layer : ObjectLayer;

    ShouldCollide :: (data : *void, layer : ObjectLayer) -> bool #foreign JoltC "JPH_DefaultObjectLayerFilter_ShouldCollide";

    CreateFilter :: (filter : *DefaultObjectLayerFilter, allocator : JoltCAllocator) -> *ObjectLayerFilter #foreign JoltC "JPH_DefaultObjectLayerFilter_CreateFilter";
}

RayCast :: struct {
    origin : Vec3;
    direction : Vec3;

    Transformed :: (ray : *RayCast, transform : Mat44) -> RayCast #foreign JoltC "JPH_RayCast_Transformed";
    Translated :: (ray : *RayCast, translation : Vec3) -> RayCast #foreign JoltC "JPH_RayCast_Translated";
    GetPointOnRay :: (ray : *RayCast, fraction : float) -> Vec3 #foreign JoltC "JPH_RayCast_GetPointOnRay";
}

RRayCast :: struct {
    origin : RVec3;
    direction : Vec3;

    Transformed :: (ray : *RRayCast, transform : RMat44) -> RRayCast #foreign JoltC "JPH_RRayCast_Transformed";
    Translated :: (ray : *RRayCast, translation : RVec3) -> RRayCast #foreign JoltC "JPH_RRayCast_Translated";
    GetPointOnRay :: (ray : *RRayCast, fraction : float) -> RVec3 #foreign JoltC "JPH_RRayCast_GetPointOnRay";
}

RayCastSettings :: struct {
    backFaceModeTriangles : EBackFaceMode;
    backFaceModeConvex : EBackFaceMode;
    treatConvexAsSolid : bool;

    Default :: () -> RayCastSettings #foreign JoltC "JPH_RayCastSettings_Default";
}

AABoxCast :: struct {
    box : AABox;
    direction : Vec3;
}

BroadPhaseCastResult :: struct {
    bodyID : BodyID;
    fraction : float;
}

RayCastResult :: struct {
    bodyID : BodyID;
    fraction : float;
    subShapeID2 : SubShapeID;

    Default :: () -> RayCastResult #foreign JoltC "JPH_RayCastResult_Default";
}

BodyInterface :: struct {
    CreateBody :: (bodyInterface : *BodyInterface, settings : *BodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateBody";
    CreateSoftBody :: (bodyInterface : *BodyInterface, settings : *SoftBodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateSoftBody";
    CreateBodyWithID :: (bodyInterface : *BodyInterface, bodyID : BodyID, settings : *BodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateBodyWithID";
    CreateSoftBodyWithID :: (bodyInterface : *BodyInterface, bodyID : BodyID, settings : *SoftBodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateSoftBodyWithID";
    CreateBodyWithoutID :: (bodyInterface : *BodyInterface, settings : *BodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateBodyWithoutID";
    CreateSoftBodyWithoutID :: (bodyInterface : *BodyInterface, settings : *SoftBodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateSoftBodyWithoutID";
    DestroyBodyWithoutID :: (bodyInterface : *BodyInterface, body : *Body) -> void #foreign JoltC "JPH_BodyInterface_DestroyBodyWithoutID";
    AssignBodyID :: (bodyInterface : *BodyInterface, ioBody : *Body) -> bool #foreign JoltC "JPH_BodyInterface_AssignBodyID";
    SetBodyID :: (bodyInterface : *BodyInterface, ioBody : *Body, bodyID : BodyID) -> bool #foreign JoltC "JPH_BodyInterface_SetBodyID";
    UnassignBodyID :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> *Body #foreign JoltC "JPH_BodyInterface_UnassignBodyID";
    UnassignBodyIDs :: (bodyInterface : *BodyInterface, bodyIDs : *BodyID, count : s32, outBodies : **Body) -> void #foreign JoltC "JPH_BodyInterface_UnassignBodyIDs";
    DestroyBody :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> void #foreign JoltC "JPH_BodyInterface_DestroyBody";
    DestroyBodies :: (bodyInterface : *BodyInterface, bodyIDs : *BodyID, count : s32) -> void #foreign JoltC "JPH_BodyInterface_DestroyBodies";
    AddBody :: (bodyInterface : *BodyInterface, bodyID : BodyID, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_AddBody";
    RemoveBody :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> void #foreign JoltC "JPH_BodyInterface_RemoveBody";
    IsAdded :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> bool #foreign JoltC "JPH_BodyInterface_IsAdded";
    CreateAndAddBody :: (bodyInterface : *BodyInterface, settings : *BodyCreationSettings, activationMode : EActivation) -> BodyID #foreign JoltC "JPH_BodyInterface_CreateAndAddBody";
    CreateAndAddSoftBody :: (bodyInterface : *BodyInterface, settings : *SoftBodyCreationSettings, activationMode : EActivation) -> BodyID #foreign JoltC "JPH_BodyInterface_CreateAndAddSoftBody";
    MoveKinematic :: (bodyInterface : *BodyInterface, bodyID : BodyID, targetPosition : RVec3, targetRotation : Quat, deltaTime : float) -> void #foreign JoltC "JPH_BodyInterface_MoveKinematic";
    SetLinearAndAngularVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID, linearVelocity : Vec3, angularVelocity : Vec3) -> void #foreign JoltC "JPH_BodyInterface_SetLinearAndAngularVelocity";
    GetLinearAndAngularVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID, outLinearVelocity : *Vec3, outAngularVelocity : *Vec3) -> void #foreign JoltC "JPH_BodyInterface_GetLinearAndAngularVelocity";
    SetLinearVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID, linearVelocity : Vec3) -> void #foreign JoltC "JPH_BodyInterface_SetLinearVelocity";
    GetLinearVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> Vec3 #foreign JoltC "JPH_BodyInterface_GetLinearVelocity";
    AddLinearVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID, linearVelocity : Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddLinearVelocity";
    AddLinearAndAngularVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID, linearVelocity : Vec3, angularVelocity : Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddLinearAndAngularVelocity";
    SetAngularVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID, angularVelocity : Vec3) -> void #foreign JoltC "JPH_BodyInterface_SetAngularVelocity";
    GetAngularVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> Vec3 #foreign JoltC "JPH_BodyInterface_GetAngularVelocity";
    GetPointVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID, point : RVec3) -> Vec3 #foreign JoltC "JPH_BodyInterface_GetPointVelocity";
    SetPositionRotationAndVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID, position : RVec3, rotation : Quat, linearVelocity : Vec3, angularVelocity : Vec3) -> void #foreign JoltC "JPH_BodyInterface_SetPositionRotationAndVelocity";
    GetInverseInertia :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> Mat44 #foreign JoltC "JPH_BodyInterface_GetInverseInertia";
    GetUserData :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> u64 #foreign JoltC "JPH_BodyInterface_GetUserData";
    SetUserData :: (bodyInterface : *BodyInterface, bodyID : BodyID, userData : u64) -> void #foreign JoltC "JPH_BodyInterface_SetUserData";
    GetMaterial :: (bodyInterface : *BodyInterface, bodyID : BodyID, subShapeID : SubShapeID) -> *PhysicsMaterial #foreign JoltC "JPH_BodyInterface_GetMaterial";
    InvalidateContactCache :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> void #foreign JoltC "JPH_BodyInterface_InvalidateContactCache";
    AddBodiesPrepare :: (bodyInterface : *BodyInterface, ioBodies : *BodyID, count : s32) -> *void #foreign JoltC "JPH_BodyInterface_AddBodiesPrepare";
    AddBodiesFinalize :: (bodyInterface : *BodyInterface, ioBodies : *BodyID, count : s32, addState : *void, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_AddBodiesFinalize";
    AddBodiesAbort :: (bodyInterface : *BodyInterface, ioBodies : *BodyID, count : s32, addState : *void) -> void #foreign JoltC "JPH_BodyInterface_AddBodiesAbort";
    RemoveBodies :: (bodyInterface : *BodyInterface, ioBodies : *BodyID, count : s32) -> void #foreign JoltC "JPH_BodyInterface_RemoveBodies";
    ActivateBody :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> void #foreign JoltC "JPH_BodyInterface_ActivateBody";
    ActivateBodies :: (bodyInterface : *BodyInterface, bodyIDs : *BodyID, count : s32) -> void #foreign JoltC "JPH_BodyInterface_ActivateBodies";
    ActivateBodiesInAABox :: (bodyInterface : *BodyInterface, inBox : AABox, broadPhaseLayerFilter : *BroadPhaseLayerFilter, objectLayerFilter : *ObjectLayerFilter) -> void #foreign JoltC "JPH_BodyInterface_ActivateBodiesInAABox";
    DeactivateBody :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> void #foreign JoltC "JPH_BodyInterface_DeactivateBody";
    DeactivateBodies :: (bodyInterface : *BodyInterface, bodyIDs : *BodyID, count : s32) -> void #foreign JoltC "JPH_BodyInterface_DeactivateBodies";
    IsActive :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> bool #foreign JoltC "JPH_BodyInterface_IsActive";
    ResetSleepTimer :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> void #foreign JoltC "JPH_BodyInterface_ResetSleepTimer";
    GetShape :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> *Shape #foreign JoltC "JPH_BodyInterface_GetShape";
    SetShape :: (bodyInterface : *BodyInterface, bodyID : BodyID, shape : *Shape, updateMassProperties : bool, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_SetShape";
    NotifyShapeChanged :: (bodyInterface : *BodyInterface, bodyID : BodyID, inPreviousCenterOfMass : Vec3, updateMassProperties : bool, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_NotifyShapeChanged";
    SetObjectLayer :: (bodyInterface : *BodyInterface, bodyID : BodyID, layer : ObjectLayer) -> void #foreign JoltC "JPH_BodyInterface_SetObjectLayer";
    GetObjectLayer :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> ObjectLayer #foreign JoltC "JPH_BodyInterface_GetObjectLayer";
    SetPositionAndRotation :: (bodyInterface : *BodyInterface, bodyID : BodyID, position : RVec3, rotation : Quat, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_SetPositionAndRotation";
    SetPositionAndRotationWhenChanged :: (bodyInterface : *BodyInterface, bodyID : BodyID, position : RVec3, rotation : Quat, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_SetPositionAndRotationWhenChanged";
    GetPositionAndRotation :: (bodyInterface : *BodyInterface, bodyID : BodyID, outPosition : *RVec3, outRotation : *Quat) -> void #foreign JoltC "JPH_BodyInterface_GetPositionAndRotation";
    SetPosition :: (bodyInterface : *BodyInterface, bodyID : BodyID, position : RVec3, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_SetPosition";
    GetPosition :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> RVec3 #foreign JoltC "JPH_BodyInterface_GetPosition";
    GetCenterOfMassPosition :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> RVec3 #foreign JoltC "JPH_BodyInterface_GetCenterOfMassPosition";
    SetRotation :: (bodyInterface : *BodyInterface, bodyID : BodyID, rotation : Quat, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_SetRotation";
    GetRotation :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> Quat #foreign JoltC "JPH_BodyInterface_GetRotation";
    GetWorldTransform :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> RMat44 #foreign JoltC "JPH_BodyInterface_GetWorldTransform";
    GetCenterOfMassTransform :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> RMat44 #foreign JoltC "JPH_BodyInterface_GetCenterOfMassTransform";
    AddForce :: (bodyInterface : *BodyInterface, bodyID : BodyID, force : Vec3, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_AddForce";
    AddForceAtPoint :: (bodyInterface : *BodyInterface, bodyID : BodyID, force : Vec3, point : RVec3, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_AddForceAtPoint";
    AddTorque :: (bodyInterface : *BodyInterface, bodyID : BodyID, torque : Vec3, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_AddTorque";
    AddForceAndTorque :: (bodyInterface : *BodyInterface, bodyID : BodyID, force : Vec3, torque : Vec3, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_AddForceAndTorque";
    AddImpulse :: (bodyInterface : *BodyInterface, bodyID : BodyID, impulse : Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddImpulse";
    AddImpulseAtPoint :: (bodyInterface : *BodyInterface, bodyID : BodyID, impulse : Vec3, point : RVec3) -> void #foreign JoltC "JPH_BodyInterface_AddImpulseAtPoint";
    AddAngularImpulse :: (bodyInterface : *BodyInterface, bodyID : BodyID, angularImpulse : Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddAngularImpulse";
    ApplyBuoyancyImpulse :: (bodyInterface : *BodyInterface, bodyID : BodyID, surfacePosition : RVec3, surfaceNormal : Vec3, buoyancy : float, linearDrag : float, angularDrag : float, fluidVelocity : Vec3, gravity : Vec3, deltaTime : float) -> bool #foreign JoltC "JPH_BodyInterface_ApplyBuoyancyImpulse";
    GetBodyType :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> EBodyType #foreign JoltC "JPH_BodyInterface_GetBodyType";
    SetMotionType :: (bodyInterface : *BodyInterface, bodyID : BodyID, motionType : EMotionType, activationMode : EActivation) -> void #foreign JoltC "JPH_BodyInterface_SetMotionType";
    GetMotionType :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> EMotionType #foreign JoltC "JPH_BodyInterface_GetMotionType";
    SetMotionQuality :: (bodyInterface : *BodyInterface, bodyID : BodyID, motionQuality : EMotionQuality) -> void #foreign JoltC "JPH_BodyInterface_SetMotionQuality";
    GetMotionQuality :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> EMotionQuality #foreign JoltC "JPH_BodyInterface_GetMotionQuality";
    SetRestitution :: (bodyInterface : *BodyInterface, bodyID : BodyID, restitution : float) -> void #foreign JoltC "JPH_BodyInterface_SetRestitution";
    GetRestitution :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetRestitution";
    SetFriction :: (bodyInterface : *BodyInterface, bodyID : BodyID, friction : float) -> void #foreign JoltC "JPH_BodyInterface_SetFriction";
    GetFriction :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetFriction";
    SetGravityFactor :: (bodyInterface : *BodyInterface, bodyID : BodyID, gravityFactor : float) -> void #foreign JoltC "JPH_BodyInterface_SetGravityFactor";
    GetGravityFactor :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetGravityFactor";
    SetMaxLinearVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID, linearVelocity : float) -> void #foreign JoltC "JPH_BodyInterface_SetMaxLinearVelocity";
    GetMaxLinearVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetMaxLinearVelocity";
    SetMaxAngularVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID, angularVelocity : float) -> void #foreign JoltC "JPH_BodyInterface_SetMaxAngularVelocity";
    GetMaxAngularVelocity :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetMaxAngularVelocity";
    SetUseManifoldReduction :: (bodyInterface : *BodyInterface, bodyID : BodyID, useReduction : bool) -> void #foreign JoltC "JPH_BodyInterface_SetUseManifoldReduction";
    GetUseManifoldReduction :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> bool #foreign JoltC "JPH_BodyInterface_GetUseManifoldReduction";
    SetIsSensor :: (bodyInterface : *BodyInterface, bodyID : BodyID, isSensor : bool) -> void #foreign JoltC "JPH_BodyInterface_SetIsSensor";
    IsSensor :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> bool #foreign JoltC "JPH_BodyInterface_IsSensor";
    SetCollisionGroup :: (bodyInterface : *BodyInterface, bodyID : BodyID, collisionGroup : *CollisionGroup) -> void #foreign JoltC "JPH_BodyInterface_SetCollisionGroup";
    GetCollisionGroup :: (bodyInterface : *BodyInterface, bodyID : BodyID) -> *CollisionGroup #foreign JoltC "JPH_BodyInterface_GetCollisionGroup";
}

BodyLockInterface :: struct {
    TryGetBody :: (bodyLockInterface : *BodyLockInterface, bodyID : BodyID) -> *Body #foreign JoltC "JPH_BodyLockInterface_TryGetBody";
    LockRead :: (bodyLockInterface : *BodyLockInterface, bodyID : BodyID, outLock : *BodyLockRead) -> void #foreign JoltC "JPH_BodyLockInterface_LockRead";
    UnlockRead :: (bodyLockInterface : *BodyLockInterface, outLock : *BodyLockRead) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockRead";
    LockWrite :: (bodyLockInterface : *BodyLockInterface, bodyID : BodyID, outLock : *BodyLockWrite) -> void #foreign JoltC "JPH_BodyLockInterface_LockWrite";
    UnlockWrite :: (bodyLockInterface : *BodyLockInterface, outLock : *BodyLockWrite) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockWrite";
    LockReadMulti :: (bodyLockInterface : *BodyLockInterface, bodyIDs : *BodyID, numBodies : s32, outLock : *BodyLockMultiRead) -> void #foreign JoltC "JPH_BodyLockInterface_LockReadMulti";
    UnlockReadMulti :: (bodyLockInterface : *BodyLockInterface, outLock : *BodyLockMultiRead) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockReadMulti";
    LockWriteMulti :: (bodyLockInterface : *BodyLockInterface, bodyIDs : *BodyID, numBodies : s32, outLock : *BodyLockMultiWrite) -> void #foreign JoltC "JPH_BodyLockInterface_LockWriteMulti";
    UnlockWriteMulti :: (bodyLockInterface : *BodyLockInterface, outLock : *BodyLockMultiWrite) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockWriteMulti";
    LockReadAll :: (bodyLockInterface : *BodyLockInterface) -> void #foreign JoltC "JPH_BodyLockInterface_LockReadAll";
    UnlockReadAll :: (bodyLockInterface : *BodyLockInterface) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockReadAll";
    LockWriteAll :: (bodyLockInterface : *BodyLockInterface) -> void #foreign JoltC "JPH_BodyLockInterface_LockWriteAll";
    UnlockWriteAll :: (bodyLockInterface : *BodyLockInterface) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockWriteAll";
}

MotionProperties :: struct {}

SoftBodyMotionProperties :: struct {}

SoftBodySharedSettings :: struct {}

BodyManager :: struct {
    MutexMask :: u64;

    EShapeColor :: enum u32 {
        InstanceColor :: 0;
        ShapeTypeColor :: 1;
        MotionTypeColor :: 2;
        SleepColor :: 3;
        IslandColor :: 4;
        MaterialColor :: 5;
    }

    BodyStats :: struct {
        numBodies : u32;
        maxBodies : u32;
        numBodiesStatic : u32;
        numBodiesDynamic : u32;
        numActiveBodiesDynamic : u32;
        numBodiesKinematic : u32;
        numActiveBodiesKinematic : u32;
        numSoftBodies : u32;
        numActiveSoftBodies : u32;
    }

    DrawSettings :: struct {
        drawGetSupportFunction : bool;
        drawSupportDirection : bool;
        drawGetSupportingFace : bool;
        drawShape : bool;
        drawShapeWireframe : bool;
        drawShapeColor : BodyManager.EShapeColor;
        drawBoundingBox : bool;
        drawCenterOfMassTransform : bool;
        drawWorldTransform : bool;
        drawVelocity : bool;
        drawMassAndInertia : bool;
        drawSleepStats : bool;
        drawSoftBodyVertices : bool;
        drawSoftBodyVertexVelocities : bool;
        drawSoftBodyEdgeConstraints : bool;
        drawSoftBodyBendConstraints : bool;
        drawSoftBodyVolumeConstraints : bool;
        drawSoftBodySkinConstraints : bool;
        drawSoftBodyLRAConstraints : bool;
        drawSoftBodyRods : bool;
        drawSoftBodyRodStates : bool;
        drawSoftBodyRodBendTwistConstraints : bool;
        drawSoftBodyPredictedBounds : bool;
        drawSoftBodyConstraintColor : ESoftBodyConstraintColor;
    }
}

BodyCreationSettings :: struct {
    position : RVec3;
    rotation : Quat;
    linearVelocity : Vec3;
    angularVelocity : Vec3;
    userData : u64;
    objectLayer : ObjectLayer;
    collisionGroup : CollisionGroup;
    motionType : EMotionType;
    allowedDOFs : EAllowedDOFs;
    allowDynamicOrKinematic : bool;
    isSensor : bool;
    collideKinematicVsNonDynamic : bool;
    useManifoldReduction : bool;
    applyGyroscopicForce : bool;
    motionQuality : EMotionQuality;
    enhancedInternalEdgeRemoval : bool;
    allowSleeping : bool;
    friction : float;
    restitution : float;
    linearDamping : float;
    angularDamping : float;
    maxLinearVelocity : float;
    maxAngularVelocity : float;
    gravityFactor : float;
    numVelocityStepsOverride : u32;
    numPositionStepsOverride : u32;
    overrideMassProperties : EOverrideMassProperties;
    inertiaMultiplier : float;
    massPropertiesOverride : MassProperties;
    shape : *ShapeSettings;
    shapePtr : *Shape;

    Default :: () -> BodyCreationSettings #foreign JoltC "JPH_BodyCreationSettings_Default";

    ConvertShapeSettings :: (settings : *BodyCreationSettings) -> *Shape #foreign JoltC "JPH_BodyCreationSettings_ConvertShapeSettings";
    HasMassProperties :: (settings : *BodyCreationSettings) -> bool #foreign JoltC "JPH_BodyCreationSettings_HasMassProperties";
    GetMassProperties :: (settings : *BodyCreationSettings) -> MassProperties #foreign JoltC "JPH_BodyCreationSettings_GetMassProperties";
}

SoftBodyCreationSettings :: struct {
    settings : *SoftBodySharedSettings;
    position : RVec3;
    rotation : Quat;
    userData : u64;
    objectLayer : ObjectLayer;
    collisionGroup : CollisionGroup;
    numIterations : u32;
    linearDamping : float;
    maxLinearVelocity : float;
    restitution : float;
    friction : float;
    pressure : float;
    gravityFactor : float;
    vertexRadius : float;
    updatePosition : bool;
    makeRotationIdentity : bool;
    allowSleeping : bool;
    facesDoubleSided : bool;

    Default :: () -> SoftBodyCreationSettings #foreign JoltC "JPH_SoftBodyCreationSettings_Default";
}

BodyLockRead :: struct {
    bodyLockMutex : *SharedMutex;
    body : *Body;
}

BodyLockWrite :: struct {
    bodyLockMutex : *SharedMutex;
    body : *Body;
}

BodyLockMultiRead :: struct {
    mutexMask : BodyManager.MutexMask;
    bodyIDs : *BodyID;
    numBodies : s32;

    GetBody :: (lock : *BodyLockMultiRead, bodyLockInterface : *BodyLockInterface, bodyIndex : s32) -> *Body #foreign JoltC "JPH_BodyLockMultiRead_GetBody";
}

BodyLockMultiWrite :: struct {
    mutexMask : BodyManager.MutexMask;
    bodyIDs : *BodyID;
    numBodies : s32;

    GetBody :: (lock : *BodyLockMultiWrite, bodyLockInterface : *BodyLockInterface, bodyIndex : s32) -> *Body #foreign JoltC "JPH_BodyLockMultiWrite_GetBody";
}

DebugRenderer :: struct {
    ECastShadow :: enum u32 {
        On :: 0;
        Off :: 1;
    }

    EDrawMode :: enum u32 {
        Solid :: 0;
        Wireframe :: 1;
    }

    ECullMode :: enum u32 {
        CullBackFace :: 0;
        CullFrontFace :: 1;
        Off :: 2;
    }

    opaque : s8;

    Destroy :: (self : *DebugRenderer) -> void #foreign JoltC "JPH_DebugRenderer_Destroy";
    NextFrame :: (self : *DebugRenderer) -> void #foreign JoltC "JPH_DebugRenderer_NextFrame";
}

DebugRendererSimple :: struct {
    Funcs :: struct {
        Destruct : *#type (*void) -> void #c_call;
        DrawLine : *#type (*void, RVec3, RVec3, Color) -> void #c_call;
        DrawTriangle : *#type (*void, RVec3, RVec3, RVec3, Color, DebugRenderer.ECastShadow) -> void #c_call;
        DrawText3D : *#type (*void, RVec3, *s8, u64, Color, float) -> void #c_call;
    }

    #as using,except(base) base : DebugRenderer;

    Create :: (data : *void, funcs : DebugRendererSimple.Funcs, allocator : JoltCAllocator) -> *DebugRenderer #foreign JoltC "JPH_DebugRendererSimple_Create";
}

BodyDrawFilter :: struct {
    Funcs :: struct {
        Destruct : *#type (*void) -> void #c_call;
        ShouldDraw : *#type (*void, *Body) -> bool #c_call;
    }

    Create :: (data : *void, funcs : BodyDrawFilter.Funcs, allocator : JoltCAllocator) -> *BodyDrawFilter #foreign JoltC "JPH_BodyDrawFilter_Create";

    Destroy :: (self : *BodyDrawFilter) -> void #foreign JoltC "JPH_BodyDrawFilter_Destroy";
}

PhysicsSystem :: struct {
    Create :: (settings : PhysicsSystemSettings) -> *PhysicsSystem #foreign JoltC "JPH_PhysicsSystem_Create";

    Destroy :: (system : *PhysicsSystem) -> void #foreign JoltC "JPH_PhysicsSystem_Destroy";
    SetPhysicsSettings :: (system : *PhysicsSystem, settings : PhysicsSettings) -> void #foreign JoltC "JPH_PhysicsSystem_SetPhysicsSettings";
    GetPhysicsSettings :: (system : *PhysicsSystem) -> PhysicsSettings #foreign JoltC "JPH_PhysicsSystem_GetPhysicsSettings";
    SetGravity :: (system : *PhysicsSystem, gravity : Vec3) -> void #foreign JoltC "JPH_PhysicsSystem_SetGravity";
    GetGravity :: (system : *PhysicsSystem) -> Vec3 #foreign JoltC "JPH_PhysicsSystem_GetGravity";
    GetNumBodies :: (system : *PhysicsSystem) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetNumBodies";
    GetNumActiveBodies :: (system : *PhysicsSystem, type : EBodyType) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetNumActiveBodies";
    GetMaxBodies :: (system : *PhysicsSystem) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetMaxBodies";
    GetBodyStats :: (system : *PhysicsSystem) -> BodyManager.BodyStats #foreign JoltC "JPH_PhysicsSystem_GetBodyStats";
    GetBodies :: (system : *PhysicsSystem, outIDs : **BodyID, allocator : JoltCAllocator) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetBodies";
    GetActiveBodies :: (system : *PhysicsSystem, type : EBodyType, outIDs : **BodyID, allocator : JoltCAllocator) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetActiveBodies";
    GetActiveBodiesUnsafe :: (system : *PhysicsSystem, type : EBodyType) -> *BodyID #foreign JoltC "JPH_PhysicsSystem_GetActiveBodiesUnsafe";
    WereBodiesInContact :: (system : *PhysicsSystem, body1ID : BodyID, body2ID : BodyID) -> bool #foreign JoltC "JPH_PhysicsSystem_WereBodiesInContact";
    GetBounds :: (system : *PhysicsSystem) -> AABox #foreign JoltC "JPH_PhysicsSystem_GetBounds";
    GetBodyInterface :: (system : *PhysicsSystem) -> *BodyInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyInterface";
    GetBodyInterfaceConst :: (system : *PhysicsSystem) -> *BodyInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyInterfaceConst";
    GetBodyInterfaceNoLock :: (system : *PhysicsSystem) -> *BodyInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyInterfaceNoLock";
    GetBodyInterfaceNoLockConst :: (system : *PhysicsSystem) -> *BodyInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyInterfaceNoLockConst";
    GetBroadPhaseQuery :: (system : *PhysicsSystem) -> *BroadPhaseQuery #foreign JoltC "JPH_PhysicsSystem_GetBroadPhaseQuery";
    GetNarrowPhaseQuery :: (system : *PhysicsSystem) -> *NarrowPhaseQuery #foreign JoltC "JPH_PhysicsSystem_GetNarrowPhaseQuery";
    GetNarrowPhaseQueryNoLock :: (system : *PhysicsSystem) -> *NarrowPhaseQuery #foreign JoltC "JPH_PhysicsSystem_GetNarrowPhaseQueryNoLock";
    GetBodyLockInterface :: (system : *PhysicsSystem) -> *BodyLockInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyLockInterface";
    GetBodyLockInterfaceNoLock :: (system : *PhysicsSystem) -> *BodyLockInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyLockInterfaceNoLock";
    GetBroadPhaseLayerInterface :: (system : *PhysicsSystem) -> *BroadPhaseLayerInterface #foreign JoltC "JPH_PhysicsSystem_GetBroadPhaseLayerInterface";
    GetObjectVsBroadPhaseLayerFilter :: (system : *PhysicsSystem) -> *ObjectVsBroadPhaseLayerFilter #foreign JoltC "JPH_PhysicsSystem_GetObjectVsBroadPhaseLayerFilter";
    GetObjectLayerPairFilter :: (system : *PhysicsSystem) -> *ObjectLayerPairFilter #foreign JoltC "JPH_PhysicsSystem_GetObjectLayerPairFilter";
    GetDefaultBroadPhaseLayerFilter :: (system : *PhysicsSystem, layer : ObjectLayer) -> DefaultBroadPhaseLayerFilter #foreign JoltC "JPH_PhysicsSystem_GetDefaultBroadPhaseLayerFilter";
    GetDefaultLayerFilter :: (system : *PhysicsSystem, layer : ObjectLayer) -> DefaultObjectLayerFilter #foreign JoltC "JPH_PhysicsSystem_GetDefaultLayerFilter";
    OptimizeBroadPhase :: (system : *PhysicsSystem) -> void #foreign JoltC "JPH_PhysicsSystem_OptimizeBroadPhase";
    Update :: (system : *PhysicsSystem, deltaTime : float, collisionSteps : s32, tempAllocator : *TempAllocator, jobSystem : *JobSystem) -> EPhysicsUpdateError #foreign JoltC "JPH_PhysicsSystem_Update";
    DrawBodies :: (system : *PhysicsSystem, settings : *BodyManager.DrawSettings, renderer : *DebugRenderer, bodyFilter : *BodyDrawFilter) -> void #foreign JoltC "JPH_PhysicsSystem_DrawBodies";
    DrawConstraints :: (system : *PhysicsSystem, renderer : *DebugRenderer) -> void #foreign JoltC "JPH_PhysicsSystem_DrawConstraints";
    DrawConstraintLimits :: (system : *PhysicsSystem, renderer : *DebugRenderer) -> void #foreign JoltC "JPH_PhysicsSystem_DrawConstraintLimits";
    DrawConstraintReferenceFrame :: (system : *PhysicsSystem, renderer : *DebugRenderer) -> void #foreign JoltC "JPH_PhysicsSystem_DrawConstraintReferenceFrame";
}

PhysicsSystemSettings :: struct {
    maxBodies : u32;
    numBodyMutexes : u32;
    maxBodyPairs : u32;
    maxContactConstraints : u32;
    broadPhaseLayerInterface : *BroadPhaseLayerInterface;
    objectVsBroadPhaseLayerFilter : *ObjectVsBroadPhaseLayerFilter;
    objectLayerPairFilter : *ObjectLayerPairFilter;
}

// Functions

RVec3_Make :: (x : Real, y : Real, z : Real) -> RVec3 #foreign JoltC "JPH_RVec3_Make";
RegisterDefaultAllocator :: () -> void #foreign JoltC "JPH_RegisterDefaultAllocator";
RegisterDefaultTraceHandler :: () -> void #foreign JoltC "JPH_RegisterDefaultTraceHandler";
RegisterDefaultAssertFailedHandler :: () -> void #foreign JoltC "JPH_RegisterDefaultAssertFailedHandler";
SetAllocatorFunctions :: (allocate : AllocateFunction, reallocate : ReallocateFunction, free : FreeFunction, alignedAllocate : AlignedAllocateFunction, alignedFree : AlignedFreeFunction) -> void #foreign JoltC "JPH_SetAllocatorFunctions";
SetTraceHandler :: (handler : TraceHandler) -> void #foreign JoltC "JPH_SetTraceHandler";
SetAssertFailedHandler :: (handler : AssertFailedHandler) -> void #foreign JoltC "JPH_SetAssertFailedHandler";
CreateFactory :: () -> void #foreign JoltC "JPH_CreateFactory";
DestroyFactory :: () -> void #foreign JoltC "JPH_DestroyFactory";
RegisterTypes :: () -> void #foreign JoltC "JPH_RegisterTypes";
UnregisterTypes :: () -> void #foreign JoltC "JPH_UnregisterTypes";
Allocate :: (size : u64) -> *void #foreign JoltC "JPH_Allocate";
Reallocate :: (block : *void, oldSize : u64, newSize : u64) -> *void #foreign JoltC "JPH_Reallocate";
Free :: (block : *void) -> void #foreign JoltC "JPH_Free";
AlignedAllocate :: (size : u64, alignment : u64) -> *void #foreign JoltC "JPH_AlignedAllocate";
AlignedFree :: (block : *void) -> void #foreign JoltC "JPH_AlignedFree";
GetJoltVersionID :: () -> u64 #foreign JoltC "JPH_GetJoltVersionID";
