//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



JPC_OBJECT_LAYER_BITS :: 16;

JPC_MAX_PHYSICS_JOBS: s32 : 2048;
JPC_MAX_PHYSICS_BARRIERS: s32 : 8;
JPC_DEFAULT_COLLISION_TOLERANCE: float : 0.0001;
JPC_DEFAULT_PENETRATION_TOLERANCE: float : 0.0001;
JPC_DEFAULT_CONVEX_RADIUS: float : 0.05;
JPC_CAPSULE_PROJECTION_SLOP: float : 0.02;

ShapeType :: enum u8 {
    CONVEX       :: 0;
    COMPOUND     :: 1;
    DECORATED    :: 2;
    MESH         :: 3;
    HEIGHT_FIELD :: 4;
    SOFTBODY     :: 5;
    USER1        :: 6;
    USER2        :: 7;
    USER3        :: 8;
    USER4        :: 9;

    JPC_SHAPE_TYPE_CONVEX       :: CONVEX;
    JPC_SHAPE_TYPE_COMPOUND     :: COMPOUND;
    JPC_SHAPE_TYPE_DECORATED    :: DECORATED;
    JPC_SHAPE_TYPE_MESH         :: MESH;
    JPC_SHAPE_TYPE_HEIGHT_FIELD :: HEIGHT_FIELD;
    JPC_SHAPE_TYPE_SOFTBODY     :: SOFTBODY;
    JPC_SHAPE_TYPE_USER1        :: USER1;
    JPC_SHAPE_TYPE_USER2        :: USER2;
    JPC_SHAPE_TYPE_USER3        :: USER3;
    JPC_SHAPE_TYPE_USER4        :: USER4;
}

ShapeSubType :: enum u8 {
    SPHERE                :: 0;
    BOX                   :: 1;
    TRIANGLE              :: 2;
    CAPSULE               :: 3;
    TAPEREDCAPSULE        :: 4;
    CYLINDER              :: 5;
    CONVEX_HULL           :: 6;
    STATIC_COMPOUND       :: 7;
    MUTABLE_COMPOUND      :: 8;
    ROTATED_TRANSLATED    :: 9;
    SCALED                :: 10;
    OFFSET_CENTER_OF_MASS :: 11;
    MESH                  :: 12;
    HEIGHT_FIELD          :: 13;
    SOFT_BODY             :: 14;
    USER1                 :: 15;
    USER2                 :: 16;
    USER3                 :: 17;
    USER4                 :: 18;
    USER5                 :: 19;
    USER6                 :: 20;
    USER7                 :: 21;
    USER8                 :: 22;
    USER_CONVEX1          :: 23;
    USER_CONVEX2          :: 24;
    USER_CONVEX3          :: 25;
    USER_CONVEX4          :: 26;
    USER_CONVEX5          :: 27;
    USER_CONVEX6          :: 28;
    USER_CONVEX7          :: 29;
    USER_CONVEX8          :: 30;

    JPC_SHAPE_SUB_TYPE_SPHERE                :: SPHERE;
    JPC_SHAPE_SUB_TYPE_BOX                   :: BOX;
    JPC_SHAPE_SUB_TYPE_TRIANGLE              :: TRIANGLE;
    JPC_SHAPE_SUB_TYPE_CAPSULE               :: CAPSULE;
    JPC_SHAPE_SUB_TYPE_TAPEREDCAPSULE        :: TAPEREDCAPSULE;
    JPC_SHAPE_SUB_TYPE_CYLINDER              :: CYLINDER;
    JPC_SHAPE_SUB_TYPE_CONVEX_HULL           :: CONVEX_HULL;
    JPC_SHAPE_SUB_TYPE_STATIC_COMPOUND       :: STATIC_COMPOUND;
    JPC_SHAPE_SUB_TYPE_MUTABLE_COMPOUND      :: MUTABLE_COMPOUND;
    JPC_SHAPE_SUB_TYPE_ROTATED_TRANSLATED    :: ROTATED_TRANSLATED;
    JPC_SHAPE_SUB_TYPE_SCALED                :: SCALED;
    JPC_SHAPE_SUB_TYPE_OFFSET_CENTER_OF_MASS :: OFFSET_CENTER_OF_MASS;
    JPC_SHAPE_SUB_TYPE_MESH                  :: MESH;
    JPC_SHAPE_SUB_TYPE_HEIGHT_FIELD          :: HEIGHT_FIELD;
    JPC_SHAPE_SUB_TYPE_SOFT_BODY             :: SOFT_BODY;
    JPC_SHAPE_SUB_TYPE_USER1                 :: USER1;
    JPC_SHAPE_SUB_TYPE_USER2                 :: USER2;
    JPC_SHAPE_SUB_TYPE_USER3                 :: USER3;
    JPC_SHAPE_SUB_TYPE_USER4                 :: USER4;
    JPC_SHAPE_SUB_TYPE_USER5                 :: USER5;
    JPC_SHAPE_SUB_TYPE_USER6                 :: USER6;
    JPC_SHAPE_SUB_TYPE_USER7                 :: USER7;
    JPC_SHAPE_SUB_TYPE_USER8                 :: USER8;
    JPC_SHAPE_SUB_TYPE_USER_CONVEX1          :: USER_CONVEX1;
    JPC_SHAPE_SUB_TYPE_USER_CONVEX2          :: USER_CONVEX2;
    JPC_SHAPE_SUB_TYPE_USER_CONVEX3          :: USER_CONVEX3;
    JPC_SHAPE_SUB_TYPE_USER_CONVEX4          :: USER_CONVEX4;
    JPC_SHAPE_SUB_TYPE_USER_CONVEX5          :: USER_CONVEX5;
    JPC_SHAPE_SUB_TYPE_USER_CONVEX6          :: USER_CONVEX6;
    JPC_SHAPE_SUB_TYPE_USER_CONVEX7          :: USER_CONVEX7;
    JPC_SHAPE_SUB_TYPE_USER_CONVEX8          :: USER_CONVEX8;
}

PhysicsUpdateError :: u32;
JPC_PHYSICS_UPDATE_ERROR_NONE: PhysicsUpdateError : 0;
JPC_PHYSICS_UPDATE_ERROR_MANIFOLD_CACHE_FULL: PhysicsUpdateError : 1 << 0;
JPC_PHYSICS_UPDATE_ERROR_BODY_PAIR_CACHE_FULL: PhysicsUpdateError : 1 << 1;
JPC_PHYSICS_UPDATE_ERROR_CONTACT_CONSTRAINTS_FULL: PhysicsUpdateError : 1 << 2;

ConstraintType :: enum u32 {
    CONSTRAINT          :: 0;
    TWO_BODY_CONSTRAINT :: 1;

    JPC_CONSTRAINT_TYPE_CONSTRAINT          :: CONSTRAINT;
    JPC_CONSTRAINT_TYPE_TWO_BODY_CONSTRAINT :: TWO_BODY_CONSTRAINT;
}

ConstraintSubType :: enum u32 {
    FIXED           :: 0;
    POINT           :: 1;
    HINGE           :: 2;
    SLIDER          :: 3;
    DISTANCE        :: 4;
    CONE            :: 5;
    SWING_TWIST     :: 6;
    SIX_DOF         :: 7;
    PATH            :: 8;
    VEHICLE         :: 9;
    RACK_AND_PINION :: 10;
    GEAR            :: 11;
    PULLEY          :: 12;
    USER1           :: 13;
    USER2           :: 14;
    USER3           :: 15;
    USER4           :: 16;

    JPC_CONSTRAINT_SUB_TYPE_FIXED           :: FIXED;
    JPC_CONSTRAINT_SUB_TYPE_POINT           :: POINT;
    JPC_CONSTRAINT_SUB_TYPE_HINGE           :: HINGE;
    JPC_CONSTRAINT_SUB_TYPE_SLIDER          :: SLIDER;
    JPC_CONSTRAINT_SUB_TYPE_DISTANCE        :: DISTANCE;
    JPC_CONSTRAINT_SUB_TYPE_CONE            :: CONE;
    JPC_CONSTRAINT_SUB_TYPE_SWING_TWIST     :: SWING_TWIST;
    JPC_CONSTRAINT_SUB_TYPE_SIX_DOF         :: SIX_DOF;
    JPC_CONSTRAINT_SUB_TYPE_PATH            :: PATH;
    JPC_CONSTRAINT_SUB_TYPE_VEHICLE         :: VEHICLE;
    JPC_CONSTRAINT_SUB_TYPE_RACK_AND_PINION :: RACK_AND_PINION;
    JPC_CONSTRAINT_SUB_TYPE_GEAR            :: GEAR;
    JPC_CONSTRAINT_SUB_TYPE_PULLEY          :: PULLEY;
    JPC_CONSTRAINT_SUB_TYPE_USER1           :: USER1;
    JPC_CONSTRAINT_SUB_TYPE_USER2           :: USER2;
    JPC_CONSTRAINT_SUB_TYPE_USER3           :: USER3;
    JPC_CONSTRAINT_SUB_TYPE_USER4           :: USER4;
}

ConstraintSpace :: enum u32 {
    LOCAL_TO_BODY_COM :: 0;
    WORLD_SPACE       :: 1;

    JPC_CONSTRAINT_SPACE_LOCAL_TO_BODY_COM :: LOCAL_TO_BODY_COM;
    JPC_CONSTRAINT_SPACE_WORLD_SPACE       :: WORLD_SPACE;
}

MotionType :: enum u8 {
    STATIC    :: 0;
    KINEMATIC :: 1;
    DYNAMIC   :: 2;

    JPC_MOTION_TYPE_STATIC    :: STATIC;
    JPC_MOTION_TYPE_KINEMATIC :: KINEMATIC;
    JPC_MOTION_TYPE_DYNAMIC   :: DYNAMIC;
}

MotionQuality :: enum u8 {
    DISCRETE    :: 0;
    LINEAR_CAST :: 1;

    JPC_MOTION_QUALITY_DISCRETE    :: DISCRETE;
    JPC_MOTION_QUALITY_LINEAR_CAST :: LINEAR_CAST;
}

OverrideMassProperties :: enum u8 {
    CALC_MASS_INERTIA     :: 0;
    CALC_INERTIA          :: 1;
    MASS_INERTIA_PROVIDED :: 2;

    JPC_OVERRIDE_MASS_PROPS_CALC_MASS_INERTIA     :: CALC_MASS_INERTIA;
    JPC_OVERRIDE_MASS_PROPS_CALC_INERTIA          :: CALC_INERTIA;
    JPC_OVERRIDE_MASS_PROPS_MASS_INERTIA_PROVIDED :: MASS_INERTIA_PROVIDED;
}

GroundState :: enum u32 {
    ON_GROUND       :: 0;
    ON_STEEP_GROUND :: 1;
    NOT_SUPPORTED   :: 2;
    IN_AIR          :: 3;

    JPC_CHARACTER_GROUND_STATE_ON_GROUND       :: ON_GROUND;
    JPC_CHARACTER_GROUND_STATE_ON_STEEP_GROUND :: ON_STEEP_GROUND;
    JPC_CHARACTER_GROUND_STATE_NOT_SUPPORTED   :: NOT_SUPPORTED;
    JPC_CHARACTER_GROUND_STATE_IN_AIR          :: IN_AIR;
}

// ENSURE_ENUM_EQ(JPC_CHARACTER_GROUND_STATE_ON_GROUND, JPH::EGroundState::OnGround)
// ENSURE_ENUM_EQ(JPC_CHARACTER_GROUND_STATE_ON_STEEP_GROUND, JPH::EGroundState::OnSteepGround)
// ENSURE_ENUM_EQ(JPC_CHARACTER_GROUND_STATE_NOT_SUPPORTED, JPH::EGroundState::NotSupported)
// ENSURE_ENUM_EQ(JPC_CHARACTER_GROUND_STATE_IN_AIR, JPH::EGroundState::InAir)
Activation :: enum u32 {
    ACTIVATE      :: 0;
    DONT_ACTIVATE :: 1;

    JPC_ACTIVATION_ACTIVATE      :: ACTIVATE;
    JPC_ACTIVATION_DONT_ACTIVATE :: DONT_ACTIVATE;
}

ValidateResult :: enum u32 {
    ACCEPT_ALL_CONTACTS :: 0;
    ACCEPT_CONTACT      :: 1;
    REJECT_CONTACT      :: 2;
    REJECT_ALL_CONTACTS :: 3;

    JPC_VALIDATE_RESULT_ACCEPT_ALL_CONTACTS :: ACCEPT_ALL_CONTACTS;
    JPC_VALIDATE_RESULT_ACCEPT_CONTACT      :: ACCEPT_CONTACT;
    JPC_VALIDATE_RESULT_REJECT_CONTACT      :: REJECT_CONTACT;
    JPC_VALIDATE_RESULT_REJECT_ALL_CONTACTS :: REJECT_ALL_CONTACTS;
}

// EBackFaceMode
BackFaceMode :: u8;
JPC_BACK_FACE_MODE_IGNORE: BackFaceMode : 0;
JPC_BACK_FACE_MODE_COLLIDE: BackFaceMode : 1;

BodyType :: enum u8 {
    RIGID_BODY :: 0;
    SOFT_BODY  :: 1;

    JPC_BODY_TYPE_RIGID_BODY :: RIGID_BODY;
    JPC_BODY_TYPE_SOFT_BODY  :: SOFT_BODY;
}

AllowedDOFs :: enum u8 {
    NONE         :: 0;
    ALL          :: 63;
    TRANSLATIONX :: 1;
    TRANSLATIONY :: 2;
    TRANSLATIONZ :: 4;
    ROTATIONX    :: 8;
    ROTATIONY    :: 16;
    ROTATIONZ    :: 32;
    PLANE2D      :: 35;

    JPC_ALLOWED_DOFS_NONE         :: NONE;
    JPC_ALLOWED_DOFS_ALL          :: ALL;
    JPC_ALLOWED_DOFS_TRANSLATIONX :: TRANSLATIONX;
    JPC_ALLOWED_DOFS_TRANSLATIONY :: TRANSLATIONY;
    JPC_ALLOWED_DOFS_TRANSLATIONZ :: TRANSLATIONZ;
    JPC_ALLOWED_DOFS_ROTATIONX    :: ROTATIONX;
    JPC_ALLOWED_DOFS_ROTATIONY    :: ROTATIONY;
    JPC_ALLOWED_DOFS_ROTATIONZ    :: ROTATIONZ;
    JPC_ALLOWED_DOFS_PLANE2D      :: PLANE2D;
}

Features :: enum u32 {
    DOUBLE_PRECISION          :: 1;
    NEON                      :: 2;
    SSE                       :: 4;
    SSE4_1                    :: 8;
    SSE4_2                    :: 16;
    AVX                       :: 32;
    AVX2                      :: 64;
    AVX512                    :: 128;
    F16C                      :: 256;
    LZCNT                     :: 512;
    TZCNT                     :: 1024;
    FMADD                     :: 2048;
    PLATFORM_DETERMINISTIC    :: 4096;
    FLOATING_POINT_EXCEPTIONS :: 8192;
    DEBUG                     :: 16384;

    JPC_FEATURE_DOUBLE_PRECISION          :: DOUBLE_PRECISION;
    JPC_FEATURE_NEON                      :: NEON;
    JPC_FEATURE_SSE                       :: SSE;
    JPC_FEATURE_SSE4_1                    :: SSE4_1;
    JPC_FEATURE_SSE4_2                    :: SSE4_2;
    JPC_FEATURE_AVX                       :: AVX;
    JPC_FEATURE_AVX2                      :: AVX2;
    JPC_FEATURE_AVX512                    :: AVX512;
    JPC_FEATURE_F16C                      :: F16C;
    JPC_FEATURE_LZCNT                     :: LZCNT;
    JPC_FEATURE_TZCNT                     :: TZCNT;
    JPC_FEATURE_FMADD                     :: FMADD;
    JPC_FEATURE_PLATFORM_DETERMINISTIC    :: PLATFORM_DETERMINISTIC;
    JPC_FEATURE_FLOATING_POINT_EXCEPTIONS :: FLOATING_POINT_EXCEPTIONS;
    JPC_FEATURE_DEBUG                     :: DEBUG;
}

ShapeColor :: s32;
JPC_SHAPE_COLOR_INSTANCE_COLOR: ShapeColor : 0;
JPC_SHAPE_COLOR_SHAPE_TYPE_COLOR: ShapeColor : 1;
JPC_SHAPE_COLOR_MOTION_TYPE_COLOR: ShapeColor : 2;
JPC_SHAPE_COLOR_SLEEP_COLOR: ShapeColor : 3;
JPC_SHAPE_COLOR_ISLAND_COLOR: ShapeColor : 4;
JPC_SHAPE_COLOR_MATERIAL_COLOR: ShapeColor : 5;

SoftBodyConstraintColor :: s32;
JPC_SOFT_BODY_CONSTRAINT_COLOR_CONSTRAINT_TYPE: SoftBodyConstraintColor : 0;
JPC_SOFT_BODY_CONSTRAINT_COLOR_CONSTRAINT_GROUP: SoftBodyConstraintColor : 1;
JPC_SOFT_BODY_CONSTRAINT_COLOR_CONSTRAINT_ORDER: SoftBodyConstraintColor : 2;

// EActiveEdgeMode
ActiveEdgeMode :: u8;
JPC_ACTIVE_EDGE_MODE_COLLIDE_ONLY_WITH_ACTIVE: ActiveEdgeMode : 0;
JPC_ACTIVE_EDGE_MODE_COLLIDE_WITH_ALL: ActiveEdgeMode : 1;

// ECollectFacesMode
CollectFacesMode :: u8;
JPC_COLLECT_FACES_MODE_COLLECT_FACES: CollectFacesMode : 0;
JPC_COLLECT_FACES_MODE_NO_FACES: CollectFacesMode : 1;

// ESwingType
SwingType :: u8;
JPC_SWING_TYPE_CONE: SwingType : 0;
JPC_SWING_TYPE_PYRAMID: SwingType : 1;

// SixDOFConstraint::EAxis
SixDOFConstraint_Axis :: u32;
JPC_SIX_DOF_CONSTRAINT_AXIS_TRANSLATION_X: SixDOFConstraint_Axis : 0;
JPC_SIX_DOF_CONSTRAINT_AXIS_TRANSLATION_Y: SixDOFConstraint_Axis : 1;
JPC_SIX_DOF_CONSTRAINT_AXIS_TRANSLATION_Z: SixDOFConstraint_Axis : 2;
JPC_SIX_DOF_CONSTRAINT_AXIS_ROTATION_X: SixDOFConstraint_Axis : 3;
JPC_SIX_DOF_CONSTRAINT_AXIS_ROTATION_Y: SixDOFConstraint_Axis : 4;
JPC_SIX_DOF_CONSTRAINT_AXIS_ROTATION_Z: SixDOFConstraint_Axis : 5;
JPC_SIX_DOF_CONSTRAINT_AXIS_NUM: SixDOFConstraint_Axis : 6;
JPC_SIX_DOF_CONSTRAINT_AXIS_NUM_TRANSLATION: SixDOFConstraint_Axis : JPC_SIX_DOF_CONSTRAINT_AXIS_TRANSLATION_Z + 1;

// ESpringMode
SpringMode :: enum u8 {
    FREQUENCY_AND_DAMPING :: 0;
    STIFFNESS_AND_DAMPING :: 1;

    JPC_SPRING_MODE_FREQUENCY_AND_DAMPING :: FREQUENCY_AND_DAMPING;
    JPC_SPRING_MODE_STIFFNESS_AND_DAMPING :: STIFFNESS_AND_DAMPING;
}

// EMotorState
MotorState :: enum u32 {
    OFF      :: 0;
    VELOCITY :: 1;
    POSITION :: 2;

    JPC_MOTOR_STATE_OFF      :: OFF;
    JPC_MOTOR_STATE_VELOCITY :: VELOCITY;
    JPC_MOTOR_STATE_POSITION :: POSITION;
}

RegisterDefaultAllocator :: () -> void #foreign JoltC "JPC_RegisterDefaultAllocator";
FactoryInit :: () -> void #foreign JoltC "JPC_FactoryInit";
FactoryDelete :: () -> void #foreign JoltC "JPC_FactoryDelete";
RegisterTypes :: () -> void #foreign JoltC "JPC_RegisterTypes";
UnregisterTypes :: () -> void #foreign JoltC "JPC_UnregisterTypes";

////////////////////////////////////////////////////////////////////////////////
// Primitive types
Float3 :: struct {
    x: float;
    y: float;
    z: float;
}

Vec3 :: struct {
    x:  float;
    y:  float;
    z:  float;
    _w: float;
    #place x; Vec3_alignment: u8 #align 16;
}

Vec4 :: struct {
    x: float;
    y: float;
    z: float;
    w: float;
    #place x; Vec4_alignment: u8 #align 16;
}

DVec3 :: struct {
    x:  float64;
    y:  float64;
    z:  float64;
    _w: float64;
    #place x; DVec3_alignment: u8 #align 32;
}

Quat :: struct {
    x: float;
    y: float;
    z: float;
    w: float;
    #place x; Quat_alignment: u8 #align 16;
}

Mat44 :: struct {
    col:  [3] Vec4;
    col3: Vec3;
}

DMat44 :: struct {
    col:  [3] Vec4;
    col3: DVec3;
}

Color :: struct {
    r: u8;
    g: u8;
    b: u8;
    a: u8;
    #place r; Color_alignment: u32;
}

RVec3 :: Vec3;
RMat44 :: Mat44;
Real :: float;

BodyID :: u32;

SubShapeID :: u32;

BroadPhaseLayer :: u8;

ObjectLayer :: u16;

IndexedTriangleNoMaterial :: struct {
    idx: [3] u32;
}

IndexedTriangle :: struct {
    idx:           [3] u32;
    materialIndex: u32;
    userData:      u32;
}

RayCast :: struct {
    Origin:    Vec3;
    Direction: Vec3;
}

RRayCast :: struct {
    Origin:    RVec3;
    Direction: Vec3;
}

RayCastResult :: struct {
    BodyID_:     BodyID;
    Fraction:    float;
    SubShapeID2: SubShapeID;
}

ShapeCastResult :: struct {
    // From CollideShapeResult
    ContactPointOn1:  Vec3;
    ContactPointOn2:  Vec3;
    PenetrationAxis:  Vec3;
    PenetrationDepth: float;
    SubShapeID1:      SubShapeID;
    SubShapeID2:      SubShapeID;
    BodyID2:          BodyID;

    // From ShapeCastResult
    Fraction:         float;
    IsBackFaceHit:    bool;
}

CollideShapeResult :: struct {
    ContactPointOn1:  Vec3;
    ContactPointOn2:  Vec3;
    PenetrationAxis:  Vec3;
    PenetrationDepth: float;
    SubShapeID1:      SubShapeID;
    SubShapeID2:      SubShapeID;
    BodyID2:          BodyID;
}

Body :: struct {}

VertexList :: struct {}

VertexList_new :: (storage: *Float3, len: u64) -> *VertexList #foreign JoltC "JPC_VertexList_new";
VertexList_delete :: (object: *VertexList) -> void #foreign JoltC "JPC_VertexList_delete";

IndexedTriangleList :: struct {}

IndexedTriangleList_new :: (storage: *IndexedTriangle, len: u64) -> *IndexedTriangleList #foreign JoltC "JPC_IndexedTriangleList_new";
IndexedTriangleList_delete :: (object: *IndexedTriangleList) -> void #foreign JoltC "JPC_IndexedTriangleList_delete";

Shape :: struct {}

Shape_GetRefCount :: (self: *Shape) -> u32 #foreign JoltC "JPC_Shape_GetRefCount";
Shape_AddRef :: (self: *Shape) -> void #foreign JoltC "JPC_Shape_AddRef";
Shape_Release :: (self: *Shape) -> void #foreign JoltC "JPC_Shape_Release";

Shape_GetUserData :: (self: *Shape) -> u64 #foreign JoltC "JPC_Shape_GetUserData";
Shape_SetUserData :: (self: *Shape, userData: u64) -> void #foreign JoltC "JPC_Shape_SetUserData";

Shape_GetType :: (self: *Shape) -> ShapeType #foreign JoltC "JPC_Shape_GetType";
Shape_GetSubType :: (self: *Shape) -> ShapeSubType #foreign JoltC "JPC_Shape_GetSubType";

Shape_GetSubShapeUserData :: (self: *Shape, inSubShapeID: SubShapeID) -> u64 #foreign JoltC "JPC_Shape_GetSubShapeUserData";

Shape_GetCenterOfMass :: (self: *Shape) -> Vec3 #foreign JoltC "JPC_Shape_GetCenterOfMass";
Shape_GetVolume :: (self: *Shape) -> float #foreign JoltC "JPC_Shape_GetVolume";

CompoundShape :: struct {}

// FIXME: The real API should return a new type, JPC_CompoundShape_SubShape*
CompoundShape_GetSubShape_Shape :: (self: *CompoundShape, inIdx: u32) -> *Shape #foreign JoltC "JPC_CompoundShape_GetSubShape_Shape";

CompoundShape_GetSubShapeIndexFromID :: (self: *CompoundShape, inSubShapeID: SubShapeID, outRemainder: *SubShapeID) -> u32 #foreign JoltC "JPC_CompoundShape_GetSubShapeIndexFromID";

TempAllocatorImpl :: struct {}

TempAllocatorImpl_new :: (size: u32) -> *TempAllocatorImpl #foreign JoltC "JPC_TempAllocatorImpl_new";
TempAllocatorImpl_delete :: (object: *TempAllocatorImpl) -> void #foreign JoltC "JPC_TempAllocatorImpl_delete";

JobSystem :: struct {}
JobSystemThreadPool :: struct {}
JobSystemSingleThreaded :: struct {}

JobSystemThreadPool_new2 :: (inMaxJobs: u32, inMaxBarriers: u32) -> *JobSystemThreadPool #foreign JoltC "JPC_JobSystemThreadPool_new2";

JobSystemThreadPool_new3 :: (inMaxJobs: u32, inMaxBarriers: u32, inNumThreads: s32) -> *JobSystemThreadPool #foreign JoltC "JPC_JobSystemThreadPool_new3";

JobSystemThreadPool_delete :: (object: *JobSystemThreadPool) -> void #foreign JoltC "JPC_JobSystemThreadPool_delete";

JobSystemSingleThreaded_new :: (inMaxJobs: u32) -> *JobSystemSingleThreaded #foreign JoltC "JPC_JobSystemSingleThreaded_new";
JobSystemSingleThreaded_delete :: (object: *JobSystemSingleThreaded) -> void #foreign JoltC "JPC_JobSystemSingleThreaded_delete";

////////////////////////////////////////////////////////////////////////////////
// CollisionGroup and GroupFilter
GroupID :: u32;
SubGroupID :: u32;
GroupFilter :: struct {}

CollisionGroup :: struct {
    GroupFilter_: *GroupFilter;
    GroupID_:     GroupID;
    SubGroupID_:  SubGroupID;
}

GroupFilterFns :: struct {
    CanCollide: #type (self: *void, inGroup1: *CollisionGroup, inGroup2: *CollisionGroup) -> bool #c_call;
}

GroupFilter_new :: (self: *void, fns: GroupFilterFns) -> *GroupFilter #foreign JoltC "JPC_GroupFilter_new";

GroupFilter_delete :: (object: *GroupFilter) -> void #foreign JoltC "JPC_GroupFilter_delete";

////////////////////////////////////////////////////////////////////////////////
// BroadPhaseLayerInterface
BroadPhaseLayerInterfaceFns :: struct {
    GetNumBroadPhaseLayers: #type (self: *void) -> u32 #c_call;
    GetBroadPhaseLayer:     #type (self: *void, inLayer: ObjectLayer) -> BroadPhaseLayer #c_call;
}

BroadPhaseLayerInterface :: struct {}

BroadPhaseLayerInterface_new :: (self: *void, fns: BroadPhaseLayerInterfaceFns) -> *BroadPhaseLayerInterface #foreign JoltC "JPC_BroadPhaseLayerInterface_new";

BroadPhaseLayerInterface_delete :: (object: *BroadPhaseLayerInterface) -> void #foreign JoltC "JPC_BroadPhaseLayerInterface_delete";

////////////////////////////////////////////////////////////////////////////////
// BroadPhaseLayerFilter
BroadPhaseLayerFilterFns :: struct {
    ShouldCollide: #type (self: *void, inLayer: BroadPhaseLayer) -> bool #c_call;
}

BroadPhaseLayerFilter :: struct {}

BroadPhaseLayerFilter_new :: (self: *void, fns: BroadPhaseLayerFilterFns) -> *BroadPhaseLayerFilter #foreign JoltC "JPC_BroadPhaseLayerFilter_new";

BroadPhaseLayerFilter_delete :: (object: *BroadPhaseLayerFilter) -> void #foreign JoltC "JPC_BroadPhaseLayerFilter_delete";

////////////////////////////////////////////////////////////////////////////////
// ObjectLayerFilter
ObjectLayerFilterFns :: struct {
    ShouldCollide: #type (self: *void, inLayer: ObjectLayer) -> bool #c_call;
}

ObjectLayerFilter :: struct {}

ObjectLayerFilter_new :: (self: *void, fns: ObjectLayerFilterFns) -> *ObjectLayerFilter #foreign JoltC "JPC_ObjectLayerFilter_new";

ObjectLayerFilter_delete :: (object: *ObjectLayerFilter) -> void #foreign JoltC "JPC_ObjectLayerFilter_delete";

////////////////////////////////////////////////////////////////////////////////
// BodyFilter
BodyFilterFns :: struct {
    ShouldCollide:       #type (self: *void, inBodyID: BodyID) -> bool #c_call;
    ShouldCollideLocked: #type (self: *void, inBodyID: *Body) -> bool #c_call;
}

BodyFilter :: struct {}

BodyFilter_new :: (self: *void, fns: BodyFilterFns) -> *BodyFilter #foreign JoltC "JPC_BodyFilter_new";

BodyFilter_delete :: (object: *BodyFilter) -> void #foreign JoltC "JPC_BodyFilter_delete";

////////////////////////////////////////////////////////////////////////////////
// ShapeFilter
ShapeFilterFns :: struct {
    ShouldCollide:          #type (self: *void, inShape2: *Shape, inSubShapeIDOfShape2: SubShapeID) -> bool #c_call;

    ShouldCollideTwoShapes: #type (self: *void, inShape1: *Shape, inSubShapeIDOfShape1: SubShapeID, inShape2: *Shape, inSubShapeIDOfShape2: SubShapeID) -> bool #c_call;
}

ShapeFilter :: struct {}

ShapeFilter_new :: (self: *void, fns: ShapeFilterFns) -> *ShapeFilter #foreign JoltC "JPC_ShapeFilter_new";

ShapeFilter_delete :: (object: *ShapeFilter) -> void #foreign JoltC "JPC_ShapeFilter_delete";

////////////////////////////////////////////////////////////////////////////////
// SimShapeFilter
SimShapeFilterFns :: struct {
    ShouldCollide: #type (self: *void, inBody1: *Body, inShape1: *Shape, inSubShapeIDOfShape1: SubShapeID, inBody2: *Body, inShape2: *Shape, inSubShapeIDOfShape2: SubShapeID) -> bool #c_call;
}

SimShapeFilter :: struct {}

SimShapeFilter_new :: (self: *void, fns: SimShapeFilterFns) -> *SimShapeFilter #foreign JoltC "JPC_SimShapeFilter_new";

SimShapeFilter_delete :: (object: *SimShapeFilter) -> void #foreign JoltC "JPC_SimShapeFilter_delete";

////////////////////////////////////////////////////////////////////////////////
// ObjectVsBroadPhaseLayerFilter
ObjectVsBroadPhaseLayerFilterFns :: struct {
    ShouldCollide: #type (self: *void, inLayer1: ObjectLayer, inLayer2: BroadPhaseLayer) -> bool #c_call;
}

ObjectVsBroadPhaseLayerFilter :: struct {}

ObjectVsBroadPhaseLayerFilter_new :: (self: *void, fns: ObjectVsBroadPhaseLayerFilterFns) -> *ObjectVsBroadPhaseLayerFilter #foreign JoltC "JPC_ObjectVsBroadPhaseLayerFilter_new";

ObjectVsBroadPhaseLayerFilter_delete :: (object: *ObjectVsBroadPhaseLayerFilter) -> void #foreign JoltC "JPC_ObjectVsBroadPhaseLayerFilter_delete";

////////////////////////////////////////////////////////////////////////////////
// ObjectLayerPairFilter
ObjectLayerPairFilterFns :: struct {
    ShouldCollide: #type (self: *void, inLayer1: ObjectLayer, inLayer2: ObjectLayer) -> bool #c_call;
}

ObjectLayerPairFilter :: struct {}

ObjectLayerPairFilter_new :: (self: *void, fns: ObjectLayerPairFilterFns) -> *ObjectLayerPairFilter #foreign JoltC "JPC_ObjectLayerPairFilter_new";

ObjectLayerPairFilter_delete :: (object: *ObjectLayerPairFilter) -> void #foreign JoltC "JPC_ObjectLayerPairFilter_delete";

////////////////////////////////////////////////////////////////////////////////
// ContactListener
ContactPoints :: struct {
    length: u32;
    points: [64] Vec3;
}

ContactManifold :: struct {
    BaseOffset:               RVec3;
    WorldSpaceNormal:         Vec3;
    PenetrationDepth:         float;
    SubShapeID1:              SubShapeID;
    SubShapeID2:              SubShapeID;
    RelativeContactPointsOn1: ContactPoints;
    RelativeContactPointsOn2: ContactPoints;
}

ContactSettings :: struct {
    CombinedFriction:               float;
    CombinedRestitution:            float;
    InvMassScale1:                  float;
    InvInertiaScale1:               float;
    InvMassScale2:                  float;
    InvInertiaScale2:               float;
    IsSensor:                       bool;
    RelativeLinearSurfaceVelocity:  Vec3;
    RelativeAngularSurfaceVelocity: Vec3;
}

SubShapeIDPair :: struct {
    Body1ID:     BodyID;
    SubShapeID1: SubShapeID;
    Body2ID:     BodyID;
    SubShapeID2: SubShapeID;
}

// These fields are private, so we can't test them directly!
// ENSURE_NORMAL_FIELD(  SubShapeIDPair, Body1ID)
// ENSURE_NORMAL_FIELD(  SubShapeIDPair, SubShapeID1)
// ENSURE_NORMAL_FIELD(  SubShapeIDPair, Body2ID)
// ENSURE_NORMAL_FIELD(  SubShapeIDPair, SubShapeID2)
ShapeCastSettings :: struct {
    // JPH::CollideSettingsBase
    ActiveEdgeMode_:                 ActiveEdgeMode;
    CollectFacesMode_:               CollectFacesMode;
    CollisionTolerance:              float;
    PenetrationTolerance:            float;
    ActiveEdgeMovementDirection:     Vec3;

    // JPH::ShapeCastSettings
    BackFaceModeTriangles:           BackFaceMode;
    BackFaceModeConvex:              BackFaceMode;
    UseShrunkenShapeAndConvexRadius: bool;
    ReturnDeepestPoint:              bool;
}

CollideShapeSettings :: struct {
    // CollideSettingsBase
    ActiveEdgeMode_:             ActiveEdgeMode;
    CollectFacesMode_:           CollectFacesMode;
    CollisionTolerance:          float;
    PenetrationTolerance:        float;
    ActiveEdgeMovementDirection: Vec3;

    // CollideShapeSettings
    MaxSeparationDistance:       float;
    BackFaceMode_:               BackFaceMode;
}

ContactListenerFns :: struct {
    OnContactValidate:  #type (self: *void, inBody1: *Body, inBody2: *Body, inBaseOffset: RVec3, inCollisionResult: *CollideShapeResult) -> ValidateResult #c_call;

    OnContactAdded:     #type (self: *void, inBody1: *Body, inBody2: *Body, inManifold: *ContactManifold, ioSettings: *ContactSettings) -> void #c_call;

    OnContactPersisted: #type (self: *void, inBody1: *Body, inBody2: *Body, inManifold: *ContactManifold, ioSettings: *ContactSettings) -> void #c_call;

    OnContactRemoved:   #type (self: *void, inSubShapePair: *SubShapeIDPair) -> void #c_call;
}

ContactListener :: struct {}

ContactListener_new :: (self: *void, fns: ContactListenerFns) -> *ContactListener #foreign JoltC "JPC_ContactListener_new";

ContactListener_delete :: (object: *ContactListener) -> void #foreign JoltC "JPC_ContactListener_delete";

JPC_ContactPointsCapacity: u32 : 64;

Impulse :: struct {
    ContactImpulse:   float; ///< Estimated contact impulses (kg m / s)
    FrictionImpulse1: float; ///< Estimated friction impulses in the direction of tangent 1 (kg m / s)
    FrictionImpulse2: float; ///< Estimated friction impulses in the direction of tangent 2 (kg m / s)
}

CollisionEstimationResult :: struct {
    LinearVelocity1:  Vec3; ///< The estimated linear velocity of body 1 after collision
    AngularVelocity1: Vec3; ///< The estimated angular velocity of body 1 after collision
    LinearVelocity2:  Vec3; ///< The estimated linear velocity of body 2 after collision
    AngularVelocity2: Vec3; ///< The estimated angular velocity of body 2 after collision

    Tangent1:         Vec3; ///< Normalized tangent of contact normal
    Tangent2:         Vec3; ///< Second normalized tangent of contact normal (forms a basis with mTangent1 and mWorldSpaceNormal)

    NumImpulses:      u32;
    Impulses:         [64] Impulse;
}

EstimateCollisionResponse :: (inBody1: *Body, inBody2: *Body, inManifold: *ContactManifold, outResult: *CollisionEstimationResult, inCombinedFriction: float, inCombinedRestitution: float, inMinVelocityForRestitution: float, inNumIterations: u32) -> void #foreign JoltC "JPC_EstimateCollisionResponse";

CastShapeCollector :: struct {}

CastShapeCollectorFns :: struct {
    Reset:  #type (self: *void) -> void #c_call;
    AddHit: #type (self: *void, base: *CastShapeCollector, Result: *ShapeCastResult) -> void #c_call;
}

CastShapeCollector_new :: (self: *void, fns: CastShapeCollectorFns) -> *CastShapeCollector #foreign JoltC "JPC_CastShapeCollector_new";

CastShapeCollector_delete :: (object: *CastShapeCollector) -> void #foreign JoltC "JPC_CastShapeCollector_delete";

CastShapeCollector_UpdateEarlyOutFraction :: (self: *CastShapeCollector, inFraction: float) -> void #foreign JoltC "JPC_CastShapeCollector_UpdateEarlyOutFraction";

CollideShapeCollector :: struct {}

CollideShapeCollectorFns :: struct {
    Reset:  #type (self: *void) -> void #c_call;
    AddHit: #type (self: *void, base: *CollideShapeCollector, Result: *CollideShapeResult) -> void #c_call;
}

CollideShapeCollector_new :: (self: *void, fns: CollideShapeCollectorFns) -> *CollideShapeCollector #foreign JoltC "JPC_CollideShapeCollector_new";

CollideShapeCollector_delete :: (object: *CollideShapeCollector) -> void #foreign JoltC "JPC_CollideShapeCollector_delete";

CollideShapeCollector_UpdateEarlyOutFraction :: (self: *CollideShapeCollector, inFraction: float) -> void #foreign JoltC "JPC_CollideShapeCollector_UpdateEarlyOutFraction";

////////////////////////////////////////////////////////////////////////////////
// DrawSettings
BodyManager_DrawSettings :: struct {
    mDrawGetSupportFunction:        bool;
    mDrawSupportDirection:          bool;
    mDrawGetSupportingFace:         bool;
    mDrawShape:                     bool;
    mDrawShapeWireframe:            bool;
    mDrawShapeColor:                ShapeColor;
    mDrawBoundingBox:               bool;
    mDrawCenterOfMassTransform:     bool;
    mDrawWorldTransform:            bool;
    mDrawVelocity:                  bool;
    mDrawMassAndInertia:            bool;
    mDrawSleepStats:                bool;
    mDrawSoftBodyVertices:          bool;
    mDrawSoftBodyVertexVelocities:  bool;
    mDrawSoftBodyEdgeConstraints:   bool;
    mDrawSoftBodyBendConstraints:   bool;
    mDrawSoftBodyVolumeConstraints: bool;
    mDrawSoftBodySkinConstraints:   bool;
    mDrawSoftBodyLRAConstraints:    bool;
    mDrawSoftBodyPredictedBounds:   bool;
    DrawSoftBodyConstraintColor:    SoftBodyConstraintColor;
}

BodyManager_DrawSettings_default :: (object: *BodyManager_DrawSettings) -> void #foreign JoltC "JPC_BodyManager_DrawSettings_default";

////////////////////////////////////////////////////////////////////////////////
// DebugRendererSimple
DebugRendererSimpleFns :: struct {
    DrawLine: #type (self: *void, inFrom: RVec3, inTo: RVec3, inColor: Color) -> void #c_call;
}

DebugRendererSimple :: struct {}

DebugRendererSimple_new :: (self: *void, fns: DebugRendererSimpleFns) -> *DebugRendererSimple #foreign JoltC "JPC_DebugRendererSimple_new";

DebugRendererSimple_delete :: (object: *DebugRendererSimple) -> void #foreign JoltC "JPC_DebugRendererSimple_delete";

String :: struct {}

String_delete :: (self: *String) -> void #foreign JoltC "JPC_String_delete";
String_c_str :: (self: *String) -> *u8 #foreign JoltC "JPC_String_c_str";

Constraint :: struct {}

Constraint_GetRefCount :: (self: *Constraint) -> u32 #foreign JoltC "JPC_Constraint_GetRefCount";
Constraint_AddRef :: (self: *Constraint) -> void #foreign JoltC "JPC_Constraint_AddRef";
Constraint_Release :: (self: *Constraint) -> void #foreign JoltC "JPC_Constraint_Release";

Constraint_delete :: (self: *Constraint) -> void #foreign JoltC "JPC_Constraint_delete";

// JPC_API JPC_ConstraintType JPC_Constraint_GetType(const JPC_Constraint* self);
// JPC_API JPC_ConstraintSubType JPC_Constraint_GetSubType(const JPC_Constraint* self);
Constraint_GetConstraintPriority :: (self: *Constraint) -> u32 #foreign JoltC "JPC_Constraint_GetConstraintPriority";
Constraint_SetConstraintPriority :: (self: *Constraint, inPriority: u32) -> void #foreign JoltC "JPC_Constraint_SetConstraintPriority";

Constraint_GetNumVelocityStepsOverride :: (self: *Constraint) -> u32 #foreign JoltC "JPC_Constraint_GetNumVelocityStepsOverride";
Constraint_SetNumVelocityStepsOverride :: (self: *Constraint, inN: u32) -> void #foreign JoltC "JPC_Constraint_SetNumVelocityStepsOverride";

Constraint_GetNumPositionStepsOverride :: (self: *Constraint) -> u32 #foreign JoltC "JPC_Constraint_GetNumPositionStepsOverride";
Constraint_SetNumPositionStepsOverride :: (self: *Constraint, inN: u32) -> void #foreign JoltC "JPC_Constraint_SetNumPositionStepsOverride";

Constraint_GetEnabled :: (self: *Constraint) -> bool #foreign JoltC "JPC_Constraint_GetEnabled";
Constraint_SetEnabled :: (self: *Constraint, inEnabled: bool) -> void #foreign JoltC "JPC_Constraint_SetEnabled";

Constraint_GetUserData :: (self: *Constraint) -> u64 #foreign JoltC "JPC_Constraint_GetUserData";
Constraint_SetUserData :: (self: *Constraint, inUserData: u64) -> void #foreign JoltC "JPC_Constraint_SetUserData";

Constraint_NotifyShapeChanged :: (self: *Constraint, inBodyID: BodyID, inDeltaCOM: Vec3) -> void #foreign JoltC "JPC_Constraint_NotifyShapeChanged";

TwoBodyConstraint :: struct {}

TwoBodyConstraint_GetBody1 :: (self: *TwoBodyConstraint) -> *Body #foreign JoltC "JPC_TwoBodyConstraint_GetBody1";
TwoBodyConstraint_GetBody2 :: (self: *TwoBodyConstraint) -> *Body #foreign JoltC "JPC_TwoBodyConstraint_GetBody2";

TwoBodyConstraint_GetConstraintToBody1Matrix :: (self: *TwoBodyConstraint) -> Mat44 #foreign JoltC "JPC_TwoBodyConstraint_GetConstraintToBody1Matrix";
TwoBodyConstraint_GetConstraintToBody2Matrix :: (self: *TwoBodyConstraint) -> Mat44 #foreign JoltC "JPC_TwoBodyConstraint_GetConstraintToBody2Matrix";

FixedConstraint :: struct {}

FixedConstraint_GetTotalLambdaPosition :: (self: *FixedConstraint) -> Vec3 #foreign JoltC "JPC_FixedConstraint_GetTotalLambdaPosition";
FixedConstraint_GetTotalLambdaRotation :: (self: *FixedConstraint) -> Vec3 #foreign JoltC "JPC_FixedConstraint_GetTotalLambdaRotation";

SixDOFConstraint :: struct {}

SixDOFConstraint_GetTranslationLimitsMin :: (self: *SixDOFConstraint) -> Vec3 #foreign JoltC "JPC_SixDOFConstraint_GetTranslationLimitsMin";
SixDOFConstraint_GetTranslationLimitsMax :: (self: *SixDOFConstraint) -> Vec3 #foreign JoltC "JPC_SixDOFConstraint_GetTranslationLimitsMax";
SixDOFConstraint_SetTranslationLimits :: (self: *SixDOFConstraint, inLimitMin: Vec3, inLimitMax: Vec3) -> void #foreign JoltC "JPC_SixDOFConstraint_SetTranslationLimits";

SixDOFConstraint_GetRotationLimitsMin :: (self: *SixDOFConstraint) -> Vec3 #foreign JoltC "JPC_SixDOFConstraint_GetRotationLimitsMin";
SixDOFConstraint_GetRotationLimitsMax :: (self: *SixDOFConstraint) -> Vec3 #foreign JoltC "JPC_SixDOFConstraint_GetRotationLimitsMax";
SixDOFConstraint_SetRotationLimits :: (self: *SixDOFConstraint, inLimitMin: Vec3, inLimitMax: Vec3) -> void #foreign JoltC "JPC_SixDOFConstraint_SetRotationLimits";

SixDOFConstraint_GetLimitsMin :: (self: *SixDOFConstraint, inAxis: SixDOFConstraint_Axis) -> float #foreign JoltC "JPC_SixDOFConstraint_GetLimitsMin";
SixDOFConstraint_GetLimitsMax :: (self: *SixDOFConstraint, inAxis: SixDOFConstraint_Axis) -> float #foreign JoltC "JPC_SixDOFConstraint_GetLimitsMax";

// const SpringSettings & GetLimitsSpringSettings(JPC_SixDOFConstraint_Axis inAxis) const { JPH_ASSERT(inAxis < JPC_SixDOFConstraint_Axis::NumTranslation); return mLimitsSpringSettings[inAxis]; }
// void SetLimitsSpringSettings(JPC_SixDOFConstraint_Axis inAxis, const SpringSettings& inLimitsSpringSettings) { JPH_ASSERT(inAxis < JPC_SixDOFConstraint_Axis::NumTranslation); mLimitsSpringSettings[inAxis] = inLimitsSpringSettings; CacheHasSpringLimits(); }
SixDOFConstraint_SetMaxFriction :: (self: *SixDOFConstraint, inAxis: SixDOFConstraint_Axis, inFriction: float) -> void #foreign JoltC "JPC_SixDOFConstraint_SetMaxFriction";
SixDOFConstraint_GetMaxFriction :: (self: *SixDOFConstraint, inAxis: SixDOFConstraint_Axis) -> float #foreign JoltC "JPC_SixDOFConstraint_GetMaxFriction";

SixDOFConstraint_GetRotationInConstraintSpace :: (self: *SixDOFConstraint) -> Quat #foreign JoltC "JPC_SixDOFConstraint_GetRotationInConstraintSpace";

// void SetMotorState(EAxis inAxis, EMotorState inState);
// EMotorState GetMotorState(EAxis inAxis) const
SixDOFConstraint_GetTargetVelocityCS :: (self: *SixDOFConstraint) -> Vec3 #foreign JoltC "JPC_SixDOFConstraint_GetTargetVelocityCS";
SixDOFConstraint_SetTargetVelocityCS :: (self: *SixDOFConstraint, inVelocity: Vec3) -> void #foreign JoltC "JPC_SixDOFConstraint_SetTargetVelocityCS";

SixDOFConstraint_GetTargetAngularVelocityCS :: (self: *SixDOFConstraint) -> Vec3 #foreign JoltC "JPC_SixDOFConstraint_GetTargetAngularVelocityCS";
SixDOFConstraint_SetTargetAngularVelocityCS :: (self: *SixDOFConstraint, inAngularVelocity: Vec3) -> void #foreign JoltC "JPC_SixDOFConstraint_SetTargetAngularVelocityCS";

SixDOFConstraint_GetTargetPositionCS :: (self: *SixDOFConstraint) -> Vec3 #foreign JoltC "JPC_SixDOFConstraint_GetTargetPositionCS";
SixDOFConstraint_SetTargetPositionCS :: (self: *SixDOFConstraint, inPosition: Vec3) -> void #foreign JoltC "JPC_SixDOFConstraint_SetTargetPositionCS";

SixDOFConstraint_GetTargetOrientationCS :: (self: *SixDOFConstraint) -> Quat #foreign JoltC "JPC_SixDOFConstraint_GetTargetOrientationCS";
SixDOFConstraint_SetTargetOrientationCS :: (self: *SixDOFConstraint, inOrientation: Quat) -> void #foreign JoltC "JPC_SixDOFConstraint_SetTargetOrientationCS";

SixDOFConstraint_SetTargetOrientationBS :: (self: *SixDOFConstraint, inOrientation: Quat) -> void #foreign JoltC "JPC_SixDOFConstraint_SetTargetOrientationBS";

SixDOFConstraint_GetTotalLambdaPosition :: (self: *SixDOFConstraint) -> Vec3 #foreign JoltC "JPC_SixDOFConstraint_GetTotalLambdaPosition";
SixDOFConstraint_GetTotalLambdaRotation :: (self: *SixDOFConstraint) -> Vec3 #foreign JoltC "JPC_SixDOFConstraint_GetTotalLambdaRotation";
SixDOFConstraint_GetTotalLambdaMotorTranslation :: (self: *SixDOFConstraint) -> Vec3 #foreign JoltC "JPC_SixDOFConstraint_GetTotalLambdaMotorTranslation";
SixDOFConstraint_GetTotalLambdaMotorRotation :: (self: *SixDOFConstraint) -> Vec3 #foreign JoltC "JPC_SixDOFConstraint_GetTotalLambdaMotorRotation";

HingeConstraint :: struct {}

HingeConstraint_SetMotorState :: (self: *HingeConstraint, inState: MotorState) -> void #foreign JoltC "JPC_HingeConstraint_SetMotorState";
HingeConstraint_GetMotorState :: (self: *HingeConstraint) -> MotorState #foreign JoltC "JPC_HingeConstraint_GetMotorState";
HingeConstraint_SetTargetAngularVelocity :: (self: *HingeConstraint, inAngularVelocity: float) -> void #foreign JoltC "JPC_HingeConstraint_SetTargetAngularVelocity";
HingeConstraint_GetTargetAngularVelocity :: (self: *HingeConstraint) -> float #foreign JoltC "JPC_HingeConstraint_GetTargetAngularVelocity";
HingeConstraint_SetTargetAngle :: (self: *HingeConstraint, inAngle: float) -> void #foreign JoltC "JPC_HingeConstraint_SetTargetAngle";
HingeConstraint_GetTargetAngle :: (self: *HingeConstraint) -> float #foreign JoltC "JPC_HingeConstraint_GetTargetAngle";

SliderConstraint :: struct {}

SliderConstraint_SetMotorState :: (self: *SliderConstraint, inState: MotorState) -> void #foreign JoltC "JPC_SliderConstraint_SetMotorState";
SliderConstraint_GetMotorState :: (self: *SliderConstraint) -> MotorState #foreign JoltC "JPC_SliderConstraint_GetMotorState";
SliderConstraint_SetTargetVelocity :: (self: *SliderConstraint, inVelocity: float) -> void #foreign JoltC "JPC_SliderConstraint_SetTargetVelocity";
SliderConstraint_GetTargetVelocity :: (self: *SliderConstraint) -> float #foreign JoltC "JPC_SliderConstraint_GetTargetVelocity";
SliderConstraint_SetTargetPosition :: (self: *SliderConstraint, inPosition: float) -> void #foreign JoltC "JPC_SliderConstraint_SetTargetPosition";
SliderConstraint_GetTargetPosition :: (self: *SliderConstraint) -> float #foreign JoltC "JPC_SliderConstraint_GetTargetPosition";

////////////////////////////////////////////////////////////////////////////////
// ConstraintSettings
ConstraintSettings :: struct {
    Enabled:                  bool;
    ConstraintPriority:       u32;
    NumVelocityStepsOverride: u32;
    NumPositionStepsOverride: u32;
    DrawConstraintSize:       float;
    UserData:                 u64;
}

ConstraintSettings_default :: (settings: *ConstraintSettings) -> void #foreign JoltC "JPC_ConstraintSettings_default";

////////////////////////////////////////////////////////////////////////////////
// SpringSettings
SpringSettings :: struct {
    Mode:                 SpringMode;
    FrequencyOrStiffness: float;
    Damping:              float;
}

SpringSettings_default :: (settings: *SpringSettings) -> void #foreign JoltC "JPC_SpringSettings_default";

////////////////////////////////////////////////////////////////////////////////
// MotorSettings
MotorSettings :: struct {
    SpringSettings_: SpringSettings;
    MinForceLimit:   float;
    MaxForceLimit:   float;
    MinTorqueLimit:  float;
    MaxTorqueLimit:  float;
}

MotorSettings_default :: (settings: *MotorSettings) -> void #foreign JoltC "JPC_MotorSettings_default";

////////////////////////////////////////////////////////////////////////////////
// FixedConstraintSettings -> TwoBodyConstraintSettings -> ConstraintSettings
FixedConstraintSettings :: struct {
    ConstraintSettings_: ConstraintSettings;

    // FixedConstraintSettings
    Space:               ConstraintSpace;
    AutoDetectPoint:     bool;

    Point1:              RVec3;
    AxisX1:              Vec3;
    AxisY1:              Vec3;

    Point2:              RVec3;
    AxisX2:              Vec3;
    AxisY2:              Vec3;
}

FixedConstraintSettings_default :: (settings: *FixedConstraintSettings) -> void #foreign JoltC "JPC_FixedConstraintSettings_default";
FixedConstraintSettings_Create :: (self: *FixedConstraintSettings, inBody1: *Body, inBody2: *Body) -> *Constraint #foreign JoltC "JPC_FixedConstraintSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// SixDOFConstraintSettings -> TwoBodyConstraintSettings -> ConstraintSettings
SixDOFConstraintSettings :: struct {
    ConstraintSettings_: ConstraintSettings;

    // SixDOFConstraintSettings
    Space:               ConstraintSpace;

    Position1:           RVec3;
    AxisX1:              Vec3;
    AxisY1:              Vec3;

    Position2:           RVec3;
    AxisX2:              Vec3;
    AxisY2:              Vec3;

    MaxFriction:         [6] float;

    LimitMin:            [6] float;
    LimitMax:            [6] float;
}

SixDOFConstraintSettings_default :: (settings: *SixDOFConstraintSettings) -> void #foreign JoltC "JPC_SixDOFConstraintSettings_default";
SixDOFConstraintSettings_Create :: (self: *SixDOFConstraintSettings, inBody1: *Body, inBody2: *Body) -> *Constraint #foreign JoltC "JPC_SixDOFConstraintSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// HingeConstraintSettings -> TwoBodyConstraintSettings -> ConstraintSettings
HingeConstraintSettings :: struct {
    ConstraintSettings_:  ConstraintSettings;

    // HingeConstraintSettings
    Space:                ConstraintSpace;

    Point1:               RVec3;
    HingeAxis1:           Vec3;
    NormalAxis1:          Vec3;

    Point2:               RVec3;
    HingeAxis2:           Vec3;
    NormalAxis2:          Vec3;

    LimitsMin:            float;
    LimitsMax:            float;

    LimitsSpringSettings: SpringSettings;

    MaxFrictionTorque:    float;

    MotorSettings_:       MotorSettings;
}

HingeConstraintSettings_default :: (settings: *HingeConstraintSettings) -> void #foreign JoltC "JPC_HingeConstraintSettings_default";
HingeConstraintSettings_Create :: (self: *HingeConstraintSettings, inBody1: *Body, inBody2: *Body) -> *HingeConstraint #foreign JoltC "JPC_HingeConstraintSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// DistanceConstraintSettings -> TwoBodyConstraintSettings -> ConstraintSettings
DistanceConstraintSettings :: struct {
    ConstraintSettings_:  ConstraintSettings;

    // DistanceConstraintSettings
    Space:                ConstraintSpace;

    Point1:               RVec3;
    Point2:               RVec3;

    MinDistance:          float;
    MaxDistance:          float;

    LimitsSpringSettings: SpringSettings;
}

DistanceConstraintSettings_default :: (settings: *DistanceConstraintSettings) -> void #foreign JoltC "JPC_DistanceConstraintSettings_default";
DistanceConstraintSettings_Create :: (self: *DistanceConstraintSettings, inBody1: *Body, inBody2: *Body) -> *Constraint #foreign JoltC "JPC_DistanceConstraintSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// SliderConstraintSettings -> TwoBodyConstraintSettings -> ConstraintSettings
SliderConstraintSettings :: struct {
    ConstraintSettings_:  ConstraintSettings;

    // SliderConstraintSettings
    Space:                ConstraintSpace;
    AutoDetectPoint:      bool;

    Point1:               RVec3;
    SliderAxis1:          Vec3;
    NormalAxis1:          Vec3;

    Point2:               RVec3;
    SliderAxis2:          Vec3;
    NormalAxis2:          Vec3;

    LimitsMin:            float;
    LimitsMax:            float;

    LimitsSpringSettings: SpringSettings;

    MaxFrictionForce:     float;

    MotorSettings_:       MotorSettings;
}

SliderConstraintSettings_default :: (settings: *SliderConstraintSettings) -> void #foreign JoltC "JPC_SliderConstraintSettings_default";
SliderConstraintSettings_Create :: (self: *SliderConstraintSettings, inBody1: *Body, inBody2: *Body) -> *SliderConstraint #foreign JoltC "JPC_SliderConstraintSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// TriangleShapeSettings
TriangleShapeSettings :: struct {
    // ShapeSettings
    UserData:     u64;

    // ConvexShapeSettings
    // TODO: Material
    Density:      float;

    // TriangleShapeSettings
    V1:           Vec3;
    V2:           Vec3;
    V3:           Vec3;
    ConvexRadius: float;
}

TriangleShapeSettings_default :: (object: *TriangleShapeSettings) -> void #foreign JoltC "JPC_TriangleShapeSettings_default";
TriangleShapeSettings_Create :: (self: *TriangleShapeSettings, outShape: **Shape, outError: **String) -> bool #foreign JoltC "JPC_TriangleShapeSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// MeshShapeSettings -> ShapeSettings
MeshShapeSettings :: struct {
    // ShapeSettings
    UserData:            u64;

    // MeshShapeSettings
    TriangleVertices:    *Float3;
    TriangleVerticesLen: u64;
    IndexedTriangles:    *IndexedTriangle;
    IndexedTrianglesLen: u64;
}

MeshShapeSettings_default :: (object: *MeshShapeSettings) -> void #foreign JoltC "JPC_MeshShapeSettings_default";
MeshShapeSettings_Create :: (self: *MeshShapeSettings, outShape: **Shape, outError: **String) -> bool #foreign JoltC "JPC_MeshShapeSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// BoxShapeSettings -> ConvexShapeSettings -> ShapeSettings
BoxShapeSettings :: struct {
    // ShapeSettings
    UserData:     u64;

    // ConvexShapeSettings
    // TODO: Material
    Density:      float;

    // BoxShapeSettings
    HalfExtent:   Vec3;
    ConvexRadius: float;
}

BoxShapeSettings_default :: (object: *BoxShapeSettings) -> void #foreign JoltC "JPC_BoxShapeSettings_default";
BoxShapeSettings_Create :: (self: *BoxShapeSettings, outShape: **Shape, outError: **String) -> bool #foreign JoltC "JPC_BoxShapeSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// SphereShapeSettings -> ConvexShapeSettings -> ShapeSettings
SphereShapeSettings :: struct {
    // ShapeSettings
    UserData: u64;

    // ConvexShapeSettings
    // TODO: Material
    Density:  float;

    // SphereShapeSettings
    Radius:   float;
}

SphereShapeSettings_default :: (object: *SphereShapeSettings) -> void #foreign JoltC "JPC_SphereShapeSettings_default";
SphereShapeSettings_Create :: (self: *SphereShapeSettings, outShape: **Shape, outError: **String) -> bool #foreign JoltC "JPC_SphereShapeSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// CapsuleShapeSettings -> ConvexShapeSettings -> ShapeSettings
CapsuleShapeSettings :: struct {
    // ShapeSettings
    UserData:             u64;

    // ConvexShapeSettings
    // TODO: Material
    Density:              float;

    // CapsuleShapeSettings
    Radius:               float;
    HalfHeightOfCylinder: float;
}

CapsuleShapeSettings_default :: (object: *CapsuleShapeSettings) -> void #foreign JoltC "JPC_CapsuleShapeSettings_default";
CapsuleShapeSettings_Create :: (self: *CapsuleShapeSettings, outShape: **Shape, outError: **String) -> bool #foreign JoltC "JPC_CapsuleShapeSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// CylinderShapeSettings -> ConvexShapeSettings -> ShapeSettings
CylinderShapeSettings :: struct {
    // ShapeSettings
    UserData:     u64;

    // ConvexShapeSettings
    // TODO: Material
    Density:      float;

    // CylinderShapeSettings
    HalfHeight:   float;
    Radius:       float;
    ConvexRadius: float;
}

CylinderShapeSettings_default :: (object: *CylinderShapeSettings) -> void #foreign JoltC "JPC_CylinderShapeSettings_default";
CylinderShapeSettings_Create :: (self: *CylinderShapeSettings, outShape: **Shape, outError: **String) -> bool #foreign JoltC "JPC_CylinderShapeSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// ConvexHullShapeSettings -> ConvexShapeSettings -> ShapeSettings
ConvexHullShapeSettings :: struct {
    // ShapeSettings
    UserData:             u64;

    // ConvexShapeSettings
    // TODO: Material
    Density:              float;

    // ConvexHullShapeSettings
    Points:               *Vec3;
    PointsLen:            u64;
    MaxConvexRadius:      float;
    MaxErrorConvexRadius: float;
    HullTolerance:        float;
}

ConvexHullShapeSettings_default :: (object: *ConvexHullShapeSettings) -> void #foreign JoltC "JPC_ConvexHullShapeSettings_default";
ConvexHullShapeSettings_Create :: (self: *ConvexHullShapeSettings, outShape: **Shape, outError: **String) -> bool #foreign JoltC "JPC_ConvexHullShapeSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// CompoundShape::SubShapeSettings
SubShapeSettings :: struct {
    Shape_:   *Shape;
    Position: Vec3;
    Rotation: Quat;
    UserData: u32;
}

SubShapeSettings_default :: (object: *SubShapeSettings) -> void #foreign JoltC "JPC_SubShapeSettings_default";

////////////////////////////////////////////////////////////////////////////////
// StaticCompoundShapeSettings -> CompoundShapeSettings -> ShapeSettings
StaticCompoundShapeSettings :: struct {
    // ShapeSettings
    UserData:     u64;

    // CompoundShapeSettings
    SubShapes:    *SubShapeSettings;
    SubShapesLen: u64;
}

StaticCompoundShapeSettings_default :: (object: *StaticCompoundShapeSettings) -> void #foreign JoltC "JPC_StaticCompoundShapeSettings_default";
StaticCompoundShapeSettings_Create :: (self: *StaticCompoundShapeSettings, outShape: **Shape, outError: **String) -> bool #foreign JoltC "JPC_StaticCompoundShapeSettings_Create";

MutableCompoundShape :: struct {}

MutableCompoundShape_AddShape :: (self: *MutableCompoundShape, inPosition: Vec3, inRotation: Quat, inShape: *Shape, inUserData: u32) -> u32 #foreign JoltC "JPC_MutableCompoundShape_AddShape";

MutableCompoundShape_RemoveShape :: (self: *MutableCompoundShape, inIndex: u32) -> void #foreign JoltC "JPC_MutableCompoundShape_RemoveShape";
MutableCompoundShape_ModifyShape :: (self: *MutableCompoundShape, inIndex: u32, inPosition: Vec3, inRotation: Quat) -> void #foreign JoltC "JPC_MutableCompoundShape_ModifyShape";
MutableCompoundShape_ModifyShape2 :: (self: *MutableCompoundShape, inIndex: u32, inPosition: Vec3, inRotation: Quat, inShape: *Shape) -> void #foreign JoltC "JPC_MutableCompoundShape_ModifyShape2";
MutableCompoundShape_AdjustCenterOfMass :: (self: *MutableCompoundShape) -> void #foreign JoltC "JPC_MutableCompoundShape_AdjustCenterOfMass";

////////////////////////////////////////////////////////////////////////////////
// MutableCompoundShapeSettings -> CompoundShapeSettings -> ShapeSettings
MutableCompoundShapeSettings :: struct {
    // ShapeSettings
    UserData:     u64;

    // CompoundShapeSettings
    SubShapes:    *SubShapeSettings;
    SubShapesLen: u64;
}

MutableCompoundShapeSettings_default :: (object: *MutableCompoundShapeSettings) -> void #foreign JoltC "JPC_MutableCompoundShapeSettings_default";
MutableCompoundShapeSettings_Create :: (self: *MutableCompoundShapeSettings, outShape: **MutableCompoundShape, outError: **String) -> bool #foreign JoltC "JPC_MutableCompoundShapeSettings_Create";

////////////////////////////////////////////////////////////////////////////////
// BodyCreationSettings
BodyCreationSettings :: struct {
    Position:                     RVec3;
    Rotation:                     Quat;
    LinearVelocity:               Vec3;
    AngularVelocity:              Vec3;
    UserData:                     u64;
    ObjectLayer_:                 ObjectLayer;

    // CollisionGroup CollisionGroup;
    MotionType_:                  MotionType;
    AllowedDOFs_:                 AllowedDOFs;
    AllowDynamicOrKinematic:      bool;
    IsSensor:                     bool;
    CollideKinematicVsNonDynamic: bool;
    UseManifoldReduction:         bool;
    ApplyGyroscopicForce:         bool;
    MotionQuality_:               MotionQuality;
    EnhancedInternalEdgeRemoval:  bool;
    AllowSleeping:                bool;
    Friction:                     float;
    Restitution:                  float;
    LinearDamping:                float;
    AngularDamping:               float;
    MaxLinearVelocity:            float;
    MaxAngularVelocity:           float;
    GravityFactor:                float;
    NumVelocityStepsOverride:     u32;
    NumPositionStepsOverride:     u32;
    OverrideMassProperties_:      OverrideMassProperties;
    InertiaMultiplier:            float;

    // MassProperties MassPropertiesOverride;
    Shape_:                       *Shape;
}

BodyCreationSettings_default :: (settings: *BodyCreationSettings) -> void #foreign JoltC "JPC_BodyCreationSettings_default";

////////////////////////////////////////////////////////////////////////////////
// Body
Body_GetID :: (self: *Body) -> BodyID #foreign JoltC "JPC_Body_GetID";
Body_GetBodyType :: (self: *Body) -> BodyType #foreign JoltC "JPC_Body_GetBodyType";
Body_IsRigidBody :: (self: *Body) -> bool #foreign JoltC "JPC_Body_IsRigidBody";
Body_IsSoftBody :: (self: *Body) -> bool #foreign JoltC "JPC_Body_IsSoftBody";
Body_IsActive :: (self: *Body) -> bool #foreign JoltC "JPC_Body_IsActive";
Body_IsStatic :: (self: *Body) -> bool #foreign JoltC "JPC_Body_IsStatic";
Body_IsKinematic :: (self: *Body) -> bool #foreign JoltC "JPC_Body_IsKinematic";
Body_IsDynamic :: (self: *Body) -> bool #foreign JoltC "JPC_Body_IsDynamic";
Body_CanBeKinematicOrDynamic :: (self: *Body) -> bool #foreign JoltC "JPC_Body_CanBeKinematicOrDynamic";
Body_SetIsSensor :: (self: *Body, inIsSensor: bool) -> void #foreign JoltC "JPC_Body_SetIsSensor";
Body_IsSensor :: (self: *Body) -> bool #foreign JoltC "JPC_Body_IsSensor";
Body_SetCollideKinematicVsNonDynamic :: (self: *Body, inCollide: bool) -> void #foreign JoltC "JPC_Body_SetCollideKinematicVsNonDynamic";
Body_GetCollideKinematicVsNonDynamic :: (self: *Body) -> bool #foreign JoltC "JPC_Body_GetCollideKinematicVsNonDynamic";
Body_SetUseManifoldReduction :: (self: *Body, inUseReduction: bool) -> void #foreign JoltC "JPC_Body_SetUseManifoldReduction";
Body_GetUseManifoldReduction :: (self: *Body) -> bool #foreign JoltC "JPC_Body_GetUseManifoldReduction";
Body_GetUseManifoldReductionWithBody :: (self: *Body, inBody2: *Body) -> bool #foreign JoltC "JPC_Body_GetUseManifoldReductionWithBody";
Body_SetApplyGyroscopicForce :: (self: *Body, inApply: bool) -> void #foreign JoltC "JPC_Body_SetApplyGyroscopicForce";
Body_GetApplyGyroscopicForce :: (self: *Body) -> bool #foreign JoltC "JPC_Body_GetApplyGyroscopicForce";
Body_SetEnhancedInternalEdgeRemoval :: (self: *Body, inApply: bool) -> void #foreign JoltC "JPC_Body_SetEnhancedInternalEdgeRemoval";
Body_GetEnhancedInternalEdgeRemoval :: (self: *Body) -> bool #foreign JoltC "JPC_Body_GetEnhancedInternalEdgeRemoval";
Body_GetEnhancedInternalEdgeRemovalWithBody :: (self: *Body, inBody2: *Body) -> bool #foreign JoltC "JPC_Body_GetEnhancedInternalEdgeRemovalWithBody";
Body_GetMotionType :: (self: *Body) -> MotionType #foreign JoltC "JPC_Body_GetMotionType";
Body_SetMotionType :: (self: *Body, inMotionType: MotionType) -> void #foreign JoltC "JPC_Body_SetMotionType";
Body_GetBroadPhaseLayer :: (self: *Body) -> BroadPhaseLayer #foreign JoltC "JPC_Body_GetBroadPhaseLayer";
Body_GetObjectLayer :: (self: *Body) -> ObjectLayer #foreign JoltC "JPC_Body_GetObjectLayer";

// JPC_API const CollisionGroup & JPC_Body_GetCollisionGroup(const JPC_Body* self);
// JPC_API CollisionGroup & JPC_Body_GetCollisionGroup(JPC_Body* self);
// JPC_API void JPC_Body_SetCollisionGroup(JPC_Body* self, const CollisionGroup &inGroup);
Body_GetAllowSleeping :: (self: *Body) -> bool #foreign JoltC "JPC_Body_GetAllowSleeping";
Body_SetAllowSleeping :: (self: *Body, inAllow: bool) -> void #foreign JoltC "JPC_Body_SetAllowSleeping";
Body_ResetSleepTimer :: (self: *Body) -> void #foreign JoltC "JPC_Body_ResetSleepTimer";
Body_GetFriction :: (self: *Body) -> float #foreign JoltC "JPC_Body_GetFriction";
Body_SetFriction :: (self: *Body, inFriction: float) -> void #foreign JoltC "JPC_Body_SetFriction";
Body_GetRestitution :: (self: *Body) -> float #foreign JoltC "JPC_Body_GetRestitution";
Body_SetRestitution :: (self: *Body, inRestitution: float) -> void #foreign JoltC "JPC_Body_SetRestitution";
Body_GetLinearVelocity :: (self: *Body) -> Vec3 #foreign JoltC "JPC_Body_GetLinearVelocity";
Body_SetLinearVelocity :: (self: *Body, inLinearVelocity: Vec3) -> void #foreign JoltC "JPC_Body_SetLinearVelocity";
Body_SetLinearVelocityClamped :: (self: *Body, inLinearVelocity: Vec3) -> void #foreign JoltC "JPC_Body_SetLinearVelocityClamped";
Body_GetAngularVelocity :: (self: *Body) -> Vec3 #foreign JoltC "JPC_Body_GetAngularVelocity";
Body_SetAngularVelocity :: (self: *Body, inAngularVelocity: Vec3) -> void #foreign JoltC "JPC_Body_SetAngularVelocity";
Body_SetAngularVelocityClamped :: (self: *Body, inAngularVelocity: Vec3) -> void #foreign JoltC "JPC_Body_SetAngularVelocityClamped";
Body_GetPointVelocityCOM :: (self: *Body, inPointRelativeToCOM: Vec3) -> Vec3 #foreign JoltC "JPC_Body_GetPointVelocityCOM";
Body_GetPointVelocity :: (self: *Body, inPoint: RVec3) -> Vec3 #foreign JoltC "JPC_Body_GetPointVelocity";
Body_AddForce :: (self: *Body, inForce: Vec3) -> void #foreign JoltC "JPC_Body_AddForce";

// overload of Body::AddForce
Body_AddForceAtPoint :: (self: *Body, inForce: Vec3, inPosition: RVec3) -> void #foreign JoltC "JPC_Body_AddForceAtPoint";
Body_AddTorque :: (self: *Body, inTorque: Vec3) -> void #foreign JoltC "JPC_Body_AddTorque";
Body_GetAccumulatedForce :: (self: *Body) -> Vec3 #foreign JoltC "JPC_Body_GetAccumulatedForce";
Body_GetAccumulatedTorque :: (self: *Body) -> Vec3 #foreign JoltC "JPC_Body_GetAccumulatedTorque";
Body_ResetForce :: (self: *Body) -> void #foreign JoltC "JPC_Body_ResetForce";
Body_ResetTorque :: (self: *Body) -> void #foreign JoltC "JPC_Body_ResetTorque";
Body_ResetMotion :: (self: *Body) -> void #foreign JoltC "JPC_Body_ResetMotion";
Body_GetInverseInertia :: (self: *Body, outMatrix: *Mat44) -> void #foreign JoltC "JPC_Body_GetInverseInertia";
Body_AddImpulse :: (self: *Body, inImpulse: Vec3) -> void #foreign JoltC "JPC_Body_AddImpulse";
Body_AddImpulse2 :: (self: *Body, inImpulse: Vec3, inPosition: RVec3) -> void #foreign JoltC "JPC_Body_AddImpulse2";
Body_AddAngularImpulse :: (self: *Body, inAngularImpulse: Vec3) -> void #foreign JoltC "JPC_Body_AddAngularImpulse";
Body_MoveKinematic :: (self: *Body, inTargetPosition: RVec3, inTargetRotation: Quat, inDeltaTime: float) -> void #foreign JoltC "JPC_Body_MoveKinematic";
Body_ApplyBuoyancyImpulse :: (self: *Body, inSurfacePosition: RVec3, inSurfaceNormal: Vec3, inBuoyancy: float, inLinearDrag: float, inAngularDrag: float, inFluidVelocity: Vec3, inGravity: Vec3, inDeltaTime: float) -> bool #foreign JoltC "JPC_Body_ApplyBuoyancyImpulse";
Body_IsInBroadPhase :: (self: *Body) -> bool #foreign JoltC "JPC_Body_IsInBroadPhase";
Body_IsCollisionCacheInvalid :: (self: *Body) -> bool #foreign JoltC "JPC_Body_IsCollisionCacheInvalid";
Body_GetShape :: (self: *Body) -> *Shape #foreign JoltC "JPC_Body_GetShape";
Body_GetPosition :: (self: *Body) -> RVec3 #foreign JoltC "JPC_Body_GetPosition";
Body_GetRotation :: (self: *Body) -> Quat #foreign JoltC "JPC_Body_GetRotation";
Body_GetWorldTransform :: (self: *Body) -> RMat44 #foreign JoltC "JPC_Body_GetWorldTransform";
Body_GetCenterOfMassPosition :: (self: *Body) -> RVec3 #foreign JoltC "JPC_Body_GetCenterOfMassPosition";

Body_GetCenterOfMassTransform :: (self: *Body) -> RMat44 #foreign JoltC "JPC_Body_GetCenterOfMassTransform";
Body_GetInverseCenterOfMassTransform :: (self: *Body) -> RMat44 #foreign JoltC "JPC_Body_GetInverseCenterOfMassTransform";

// JPC_API const AABox & JPC_Body_GetWorldSpaceBounds(const JPC_Body* self);
// JPC_API const MotionProperties *JPC_Body_GetMotionProperties(const JPC_Body* self)
// JPC_API MotionProperties * JPC_Body_GetMotionProperties(JPC_Body* self);
// JPC_API const MotionProperties *JPC_Body_GetMotionPropertiesUnchecked(const JPC_Body* self)
// JPC_API MotionProperties * JPC_Body_GetMotionPropertiesUnchecked(JPC_Body* self);
Body_GetUserData :: (self: *Body) -> u64 #foreign JoltC "JPC_Body_GetUserData";
Body_SetUserData :: (self: *Body, inUserData: u64) -> void #foreign JoltC "JPC_Body_SetUserData";

Body_GetWorldSpaceSurfaceNormal :: (self: *Body, inSubShapeID: SubShapeID, inPosition: RVec3) -> Vec3 #foreign JoltC "JPC_Body_GetWorldSpaceSurfaceNormal";

BodyLockInterface :: struct {}

BodyLockRead :: struct {}

BodyLockRead_new :: (_interface: *BodyLockInterface, bodyID: BodyID) -> *BodyLockRead #foreign JoltC "JPC_BodyLockRead_new";
BodyLockRead_delete :: (self: *BodyLockRead) -> void #foreign JoltC "JPC_BodyLockRead_delete";

BodyLockRead_Succeeded :: (self: *BodyLockRead) -> bool #foreign JoltC "JPC_BodyLockRead_Succeeded";
BodyLockRead_GetBody :: (self: *BodyLockRead) -> *Body #foreign JoltC "JPC_BodyLockRead_GetBody";

BodyLockWrite :: struct {}

BodyLockWrite_new :: (_interface: *BodyLockInterface, bodyID: BodyID) -> *BodyLockWrite #foreign JoltC "JPC_BodyLockWrite_new";
BodyLockWrite_delete :: (self: *BodyLockWrite) -> void #foreign JoltC "JPC_BodyLockWrite_delete";

BodyLockWrite_Succeeded :: (self: *BodyLockWrite) -> bool #foreign JoltC "JPC_BodyLockWrite_Succeeded";
BodyLockWrite_GetBody :: (self: *BodyLockWrite) -> *Body #foreign JoltC "JPC_BodyLockWrite_GetBody";

BodyLockMultiRead :: struct {}

BodyLockMultiRead_new :: (_interface: *BodyLockInterface, inBodyIDs: *BodyID, inNumber: s32) -> *BodyLockMultiRead #foreign JoltC "JPC_BodyLockMultiRead_new";

BodyLockMultiRead_delete :: (self: *BodyLockMultiRead) -> void #foreign JoltC "JPC_BodyLockMultiRead_delete";

BodyLockMultiRead_GetBody :: (self: *BodyLockMultiRead, inBodyIndex: s32) -> *Body #foreign JoltC "JPC_BodyLockMultiRead_GetBody";

BodyLockMultiWrite :: struct {}

BodyLockMultiWrite_new :: (_interface: *BodyLockInterface, inBodyIDs: *BodyID, inNumber: s32) -> *BodyLockMultiWrite #foreign JoltC "JPC_BodyLockMultiWrite_new";

BodyLockMultiWrite_delete :: (self: *BodyLockMultiWrite) -> void #foreign JoltC "JPC_BodyLockMultiWrite_delete";

BodyLockMultiWrite_GetBody :: (self: *BodyLockMultiWrite, inBodyIndex: s32) -> *Body #foreign JoltC "JPC_BodyLockMultiWrite_GetBody";

BodyInterface :: struct {}

BodyInterface_CreateBody :: (self: *BodyInterface, inSettings: *BodyCreationSettings) -> *Body #foreign JoltC "JPC_BodyInterface_CreateBody";
BodyInterface_CreateBodyWithID :: (self: *BodyInterface, inBodyID: BodyID, inSettings: *BodyCreationSettings) -> *Body #foreign JoltC "JPC_BodyInterface_CreateBodyWithID";
BodyInterface_CreateBodyWithoutID :: (self: *BodyInterface, inSettings: *BodyCreationSettings) -> *Body #foreign JoltC "JPC_BodyInterface_CreateBodyWithoutID";

// JPC_API JPC_Body* JPC_BodyInterface_CreateSoftBody(JPC_BodyInterface *self, const SoftBodyCreationSettings &inSettings);
// JPC_API JPC_Body* JPC_BodyInterface_CreateSoftBodyWithID(JPC_BodyInterface *self, JPC_BodyID inBodyID, const SoftBodyCreationSettings* inSettings);
// JPC_API JPC_Body* JPC_BodyInterface_CreateSoftBodyWithoutID(const JPC_BodyInterface *self, const SoftBodyCreationSettings* inSettings);
BodyInterface_DestroyBodyWithoutID :: (self: *BodyInterface, inBody: *Body) -> void #foreign JoltC "JPC_BodyInterface_DestroyBodyWithoutID";
BodyInterface_AssignBodyID :: (self: *BodyInterface, ioBody: *Body) -> bool #foreign JoltC "JPC_BodyInterface_AssignBodyID";

// JPC_API bool JPC_BodyInterface_AssignBodyID(JPC_BodyInterface *self, JPC_Body *ioBody, JPC_BodyID inBodyID);
BodyInterface_UnassignBodyID :: (self: *BodyInterface, inBodyID: BodyID) -> *Body #foreign JoltC "JPC_BodyInterface_UnassignBodyID";

BodyInterface_DestroyBody :: (self: *BodyInterface, inBodyID: BodyID) -> void #foreign JoltC "JPC_BodyInterface_DestroyBody";

BodyInterface_AddBody :: (self: *BodyInterface, inBodyID: BodyID, inActivationMode: Activation) -> void #foreign JoltC "JPC_BodyInterface_AddBody";
BodyInterface_RemoveBody :: (self: *BodyInterface, inBodyID: BodyID) -> void #foreign JoltC "JPC_BodyInterface_RemoveBody";
BodyInterface_IsAdded :: (self: *BodyInterface, inBodyID: BodyID) -> bool #foreign JoltC "JPC_BodyInterface_IsAdded";
BodyInterface_CreateAndAddBody :: (self: *BodyInterface, inSettings: *BodyCreationSettings, inActivationMode: Activation) -> BodyID #foreign JoltC "JPC_BodyInterface_CreateAndAddBody";

// JPC_API JPC_BodyID JPC_BodyInterface_CreateAndAddSoftBody(JPC_BodyInterface *self, const SoftBodyCreationSettings &inSettings, JPC_Activation inActivationMode);
BodyInterface_AddBodiesPrepare :: (self: *BodyInterface, ioBodies: *BodyID, inNumber: s32) -> *void #foreign JoltC "JPC_BodyInterface_AddBodiesPrepare";
BodyInterface_AddBodiesFinalize :: (self: *BodyInterface, ioBodies: *BodyID, inNumber: s32, inAddState: *void, inActivationMode: Activation) -> void #foreign JoltC "JPC_BodyInterface_AddBodiesFinalize";
BodyInterface_AddBodiesAbort :: (self: *BodyInterface, ioBodies: *BodyID, inNumber: s32, inAddState: *void) -> void #foreign JoltC "JPC_BodyInterface_AddBodiesAbort";
BodyInterface_RemoveBodies :: (self: *BodyInterface, ioBodies: *BodyID, inNumber: s32) -> void #foreign JoltC "JPC_BodyInterface_RemoveBodies";
BodyInterface_ActivateBody :: (self: *BodyInterface, inBodyID: BodyID) -> void #foreign JoltC "JPC_BodyInterface_ActivateBody";
BodyInterface_ActivateBodies :: (self: *BodyInterface, inBodyIDs: *BodyID, inNumber: s32) -> void #foreign JoltC "JPC_BodyInterface_ActivateBodies";

// JPC_API void JPC_BodyInterface_ActivateBodiesInAABox(JPC_BodyInterface *self, const AABox &inBox, const BroadPhaseLayerFilter &inBroadPhaseLayerFilter, const ObjectLayerFilter &inObjectLayerFilter);
BodyInterface_DeactivateBody :: (self: *BodyInterface, inBodyID: BodyID) -> void #foreign JoltC "JPC_BodyInterface_DeactivateBody";
BodyInterface_DeactivateBodies :: (self: *BodyInterface, inBodyIDs: *BodyID, inNumber: s32) -> void #foreign JoltC "JPC_BodyInterface_DeactivateBodies";
BodyInterface_IsActive :: (self: *BodyInterface, inBodyID: BodyID) -> bool #foreign JoltC "JPC_BodyInterface_IsActive";

// TwoBodyConstraint * JPC_BodyInterface_CreateConstraint(JPC_BodyInterface *self, const TwoBodyConstraintSettings *inSettings, JPC_BodyID inBodyID1, JPC_BodyID inBodyID2);
// JPC_API void JPC_BodyInterface_ActivateConstraint(JPC_BodyInterface *self, const TwoBodyConstraint *inConstraint);
BodyInterface_GetShape :: (self: *BodyInterface, inBodyID: BodyID) -> *Shape #foreign JoltC "JPC_BodyInterface_GetShape";

BodyInterface_SetShape :: (self: *BodyInterface, inBodyID: BodyID, inShape: *Shape, inUpdateMassProperties: bool, inActivationMode: Activation) -> void #foreign JoltC "JPC_BodyInterface_SetShape";
BodyInterface_NotifyShapeChanged :: (self: *BodyInterface, inBodyID: BodyID, inPreviousCenterOfMass: Vec3, inUpdateMassProperties: bool, inActivationMode: Activation) -> void #foreign JoltC "JPC_BodyInterface_NotifyShapeChanged";
BodyInterface_SetObjectLayer :: (self: *BodyInterface, inBodyID: BodyID, inLayer: ObjectLayer) -> void #foreign JoltC "JPC_BodyInterface_SetObjectLayer";
BodyInterface_GetObjectLayer :: (self: *BodyInterface, inBodyID: BodyID) -> ObjectLayer #foreign JoltC "JPC_BodyInterface_GetObjectLayer";
BodyInterface_SetPositionAndRotation :: (self: *BodyInterface, inBodyID: BodyID, inPosition: RVec3, inRotation: Quat, inActivationMode: Activation) -> void #foreign JoltC "JPC_BodyInterface_SetPositionAndRotation";
BodyInterface_SetPositionAndRotationWhenChanged :: (self: *BodyInterface, inBodyID: BodyID, inPosition: RVec3, inRotation: Quat, inActivationMode: Activation) -> void #foreign JoltC "JPC_BodyInterface_SetPositionAndRotationWhenChanged";
BodyInterface_GetPositionAndRotation :: (self: *BodyInterface, inBodyID: BodyID, outPosition: *RVec3, outRotation: *Quat) -> void #foreign JoltC "JPC_BodyInterface_GetPositionAndRotation";
BodyInterface_SetPosition :: (self: *BodyInterface, inBodyID: BodyID, inPosition: RVec3, inActivationMode: Activation) -> void #foreign JoltC "JPC_BodyInterface_SetPosition";
BodyInterface_GetPosition :: (self: *BodyInterface, inBodyID: BodyID) -> RVec3 #foreign JoltC "JPC_BodyInterface_GetPosition";
BodyInterface_GetCenterOfMassPosition :: (self: *BodyInterface, inBodyID: BodyID) -> RVec3 #foreign JoltC "JPC_BodyInterface_GetCenterOfMassPosition";
BodyInterface_SetRotation :: (self: *BodyInterface, inBodyID: BodyID, inRotation: Quat, inActivationMode: Activation) -> void #foreign JoltC "JPC_BodyInterface_SetRotation";
BodyInterface_GetRotation :: (self: *BodyInterface, inBodyID: BodyID) -> Quat #foreign JoltC "JPC_BodyInterface_GetRotation";
BodyInterface_GetWorldTransform :: (self: *BodyInterface, inBodyID: BodyID) -> RMat44 #foreign JoltC "JPC_BodyInterface_GetWorldTransform";
BodyInterface_GetCenterOfMassTransform :: (self: *BodyInterface, inBodyID: BodyID) -> RMat44 #foreign JoltC "JPC_BodyInterface_GetCenterOfMassTransform";
BodyInterface_MoveKinematic :: (self: *BodyInterface, inBodyID: BodyID, inTargetPosition: RVec3, inTargetRotation: Quat, inDeltaTime: float) -> void #foreign JoltC "JPC_BodyInterface_MoveKinematic";
BodyInterface_SetLinearAndAngularVelocity :: (self: *BodyInterface, inBodyID: BodyID, inLinearVelocity: Vec3, inAngularVelocity: Vec3) -> void #foreign JoltC "JPC_BodyInterface_SetLinearAndAngularVelocity";
BodyInterface_GetLinearAndAngularVelocity :: (self: *BodyInterface, inBodyID: BodyID, outLinearVelocity: *Vec3, outAngularVelocity: *Vec3) -> void #foreign JoltC "JPC_BodyInterface_GetLinearAndAngularVelocity";
BodyInterface_SetLinearVelocity :: (self: *BodyInterface, inBodyID: BodyID, inLinearVelocity: Vec3) -> void #foreign JoltC "JPC_BodyInterface_SetLinearVelocity";
BodyInterface_GetLinearVelocity :: (self: *BodyInterface, inBodyID: BodyID) -> Vec3 #foreign JoltC "JPC_BodyInterface_GetLinearVelocity";
BodyInterface_AddLinearVelocity :: (self: *BodyInterface, inBodyID: BodyID, inLinearVelocity: Vec3) -> void #foreign JoltC "JPC_BodyInterface_AddLinearVelocity";
BodyInterface_AddLinearAndAngularVelocity :: (self: *BodyInterface, inBodyID: BodyID, inLinearVelocity: Vec3, inAngularVelocity: Vec3) -> void #foreign JoltC "JPC_BodyInterface_AddLinearAndAngularVelocity";
BodyInterface_SetAngularVelocity :: (self: *BodyInterface, inBodyID: BodyID, inAngularVelocity: Vec3) -> void #foreign JoltC "JPC_BodyInterface_SetAngularVelocity";
BodyInterface_GetAngularVelocity :: (self: *BodyInterface, inBodyID: BodyID) -> Vec3 #foreign JoltC "JPC_BodyInterface_GetAngularVelocity";
BodyInterface_GetPointVelocity :: (self: *BodyInterface, inBodyID: BodyID, inPoint: RVec3) -> Vec3 #foreign JoltC "JPC_BodyInterface_GetPointVelocity";
BodyInterface_SetPositionRotationAndVelocity :: (self: *BodyInterface, inBodyID: BodyID, inPosition: RVec3, inRotation: Quat, inLinearVelocity: Vec3, inAngularVelocity: Vec3) -> void #foreign JoltC "JPC_BodyInterface_SetPositionRotationAndVelocity";
BodyInterface_AddForce :: (self: *BodyInterface, inBodyID: BodyID, inForce: Vec3) -> void #foreign JoltC "JPC_BodyInterface_AddForce";

// overload of BodyInterface::AddForce
BodyInterface_AddForceAtPoint :: (self: *BodyInterface, inBodyID: BodyID, inForce: Vec3, inPoint: RVec3) -> void #foreign JoltC "JPC_BodyInterface_AddForceAtPoint";
BodyInterface_AddTorque :: (self: *BodyInterface, inBodyID: BodyID, inTorque: Vec3) -> void #foreign JoltC "JPC_BodyInterface_AddTorque";
BodyInterface_AddForceAndTorque :: (self: *BodyInterface, inBodyID: BodyID, inForce: Vec3, inTorque: Vec3) -> void #foreign JoltC "JPC_BodyInterface_AddForceAndTorque";
BodyInterface_AddImpulse :: (self: *BodyInterface, inBodyID: BodyID, inImpulse: Vec3) -> void #foreign JoltC "JPC_BodyInterface_AddImpulse";
BodyInterface_AddImpulse3 :: (self: *BodyInterface, inBodyID: BodyID, inImpulse: Vec3, inPoint: RVec3) -> void #foreign JoltC "JPC_BodyInterface_AddImpulse3";
BodyInterface_AddAngularImpulse :: (self: *BodyInterface, inBodyID: BodyID, inAngularImpulse: Vec3) -> void #foreign JoltC "JPC_BodyInterface_AddAngularImpulse";
BodyInterface_GetBodyType :: (self: *BodyInterface, inBodyID: BodyID) -> BodyType #foreign JoltC "JPC_BodyInterface_GetBodyType";
BodyInterface_SetMotionType :: (self: *BodyInterface, inBodyID: BodyID, inMotionType: MotionType, inActivationMode: Activation) -> void #foreign JoltC "JPC_BodyInterface_SetMotionType";
BodyInterface_GetMotionType :: (self: *BodyInterface, inBodyID: BodyID) -> MotionType #foreign JoltC "JPC_BodyInterface_GetMotionType";
BodyInterface_SetMotionQuality :: (self: *BodyInterface, inBodyID: BodyID, inMotionQuality: MotionQuality) -> void #foreign JoltC "JPC_BodyInterface_SetMotionQuality";
BodyInterface_GetMotionQuality :: (self: *BodyInterface, inBodyID: BodyID) -> MotionQuality #foreign JoltC "JPC_BodyInterface_GetMotionQuality";
BodyInterface_GetInverseInertia :: (self: *BodyInterface, inBodyID: BodyID, outMatrix: *Mat44) -> void #foreign JoltC "JPC_BodyInterface_GetInverseInertia";
BodyInterface_SetRestitution :: (self: *BodyInterface, inBodyID: BodyID, inRestitution: float) -> void #foreign JoltC "JPC_BodyInterface_SetRestitution";
BodyInterface_GetRestitution :: (self: *BodyInterface, inBodyID: BodyID) -> float #foreign JoltC "JPC_BodyInterface_GetRestitution";
BodyInterface_SetFriction :: (self: *BodyInterface, inBodyID: BodyID, inFriction: float) -> void #foreign JoltC "JPC_BodyInterface_SetFriction";
BodyInterface_GetFriction :: (self: *BodyInterface, inBodyID: BodyID) -> float #foreign JoltC "JPC_BodyInterface_GetFriction";
BodyInterface_SetGravityFactor :: (self: *BodyInterface, inBodyID: BodyID, inGravityFactor: float) -> void #foreign JoltC "JPC_BodyInterface_SetGravityFactor";
BodyInterface_GetGravityFactor :: (self: *BodyInterface, inBodyID: BodyID) -> float #foreign JoltC "JPC_BodyInterface_GetGravityFactor";
BodyInterface_SetUseManifoldReduction :: (self: *BodyInterface, inBodyID: BodyID, inUseReduction: bool) -> void #foreign JoltC "JPC_BodyInterface_SetUseManifoldReduction";
BodyInterface_GetUseManifoldReduction :: (self: *BodyInterface, inBodyID: BodyID) -> bool #foreign JoltC "JPC_BodyInterface_GetUseManifoldReduction";

// TransformedShape JPC_BodyInterface_GetTransformedShape(const JPC_BodyInterface *self, JPC_BodyID inBodyID);
BodyInterface_GetUserData :: (self: *BodyInterface, inBodyID: BodyID) -> u64 #foreign JoltC "JPC_BodyInterface_GetUserData";
BodyInterface_SetUserData :: (self: *BodyInterface, inBodyID: BodyID, inUserData: u64) -> void #foreign JoltC "JPC_BodyInterface_SetUserData";

// const PhysicsMaterial* JPC_BodyInterface_GetMaterial(const JPC_BodyInterface *self, JPC_BodyID inBodyID, const SubShapeID &inSubShapeID);
BodyInterface_InvalidateContactCache :: (self: *BodyInterface, inBodyID: BodyID) -> void #foreign JoltC "JPC_BodyInterface_InvalidateContactCache";

NarrowPhaseQuery :: struct {}

NarrowPhaseQuery_CastRayArgs :: struct {
    Ray:                    RRayCast;
    Result:                 RayCastResult;
    BroadPhaseLayerFilter_: *BroadPhaseLayerFilter;
    ObjectLayerFilter_:     *ObjectLayerFilter;
    BodyFilter_:            *BodyFilter;
    ShapeFilter_:           *ShapeFilter;
}

NarrowPhaseQuery_CastRay :: (self: *NarrowPhaseQuery, args: *NarrowPhaseQuery_CastRayArgs) -> bool #foreign JoltC "JPC_NarrowPhaseQuery_CastRay";

RShapeCast :: struct {
    Shape_:            *Shape;
    Scale:             Vec3;
    CenterOfMassStart: RMat44;
    Direction:         Vec3;
}

ShapeCastSettings_default :: (object: *ShapeCastSettings) -> void #foreign JoltC "JPC_ShapeCastSettings_default";

NarrowPhaseQuery_CastShapeArgs :: struct {
    ShapeCast:              RShapeCast;
    Settings:               ShapeCastSettings;
    BaseOffset:             RVec3;
    Collector:              *CastShapeCollector;
    BroadPhaseLayerFilter_: *BroadPhaseLayerFilter;
    ObjectLayerFilter_:     *ObjectLayerFilter;
    BodyFilter_:            *BodyFilter;
    ShapeFilter_:           *ShapeFilter;
}

NarrowPhaseQuery_CastShape :: (self: *NarrowPhaseQuery, args: *NarrowPhaseQuery_CastShapeArgs) -> void #foreign JoltC "JPC_NarrowPhaseQuery_CastShape";

CollideShapeSettings_default :: (object: *CollideShapeSettings) -> void #foreign JoltC "JPC_CollideShapeSettings_default";

NarrowPhaseQuery_CollideShapeArgs :: struct {
    Shape_:                 *Shape;
    ShapeScale:             Vec3;
    CenterOfMassTransform:  RMat44;
    Settings:               CollideShapeSettings;
    BaseOffset:             RVec3;
    Collector:              *CollideShapeCollector;
    BroadPhaseLayerFilter_: *BroadPhaseLayerFilter;
    ObjectLayerFilter_:     *ObjectLayerFilter;
    BodyFilter_:            *BodyFilter;
    ShapeFilter_:           *ShapeFilter;
}

NarrowPhaseQuery_CollideShape :: (self: *NarrowPhaseQuery, args: *NarrowPhaseQuery_CollideShapeArgs) -> void #foreign JoltC "JPC_NarrowPhaseQuery_CollideShape";

PhysicsSystem :: struct {}

PhysicsSystem_new :: () -> *PhysicsSystem #foreign JoltC "JPC_PhysicsSystem_new";
PhysicsSystem_delete :: (object: *PhysicsSystem) -> void #foreign JoltC "JPC_PhysicsSystem_delete";
PhysicsSystem_Init :: (self: *PhysicsSystem, inMaxBodies: u32, inNumBodyMutexes: u32, inMaxBodyPairs: u32, inMaxContactConstraints: u32, inBroadPhaseLayerInterface: *BroadPhaseLayerInterface, inObjectVsBroadPhaseLayerFilter: *ObjectVsBroadPhaseLayerFilter, inObjectLayerPairFilter: *ObjectLayerPairFilter) -> void #foreign JoltC "JPC_PhysicsSystem_Init";

PhysicsSystem_OptimizeBroadPhase :: (self: *PhysicsSystem) -> void #foreign JoltC "JPC_PhysicsSystem_OptimizeBroadPhase";

PhysicsSystem_Update :: (self: *PhysicsSystem, inDeltaTime: float, inCollisionSteps: s32, inTempAllocator: *TempAllocatorImpl, inJobSystem: *JobSystem) -> PhysicsUpdateError #foreign JoltC "JPC_PhysicsSystem_Update";

PhysicsSystem_AddConstraint :: (self: *PhysicsSystem, constraint: *Constraint) -> void #foreign JoltC "JPC_PhysicsSystem_AddConstraint";
PhysicsSystem_RemoveConstraint :: (self: *PhysicsSystem, constraint: *Constraint) -> void #foreign JoltC "JPC_PhysicsSystem_RemoveConstraint";

PhysicsSystem_GetBodyInterface :: (self: *PhysicsSystem) -> *BodyInterface #foreign JoltC "JPC_PhysicsSystem_GetBodyInterface";
PhysicsSystem_GetBodyLockInterface :: (self: *PhysicsSystem) -> *BodyLockInterface #foreign JoltC "JPC_PhysicsSystem_GetBodyLockInterface";

PhysicsSystem_GetNarrowPhaseQuery :: (self: *PhysicsSystem) -> *NarrowPhaseQuery #foreign JoltC "JPC_PhysicsSystem_GetNarrowPhaseQuery";

PhysicsSystem_DrawBodies :: (self: *PhysicsSystem, inSettings: *BodyManager_DrawSettings, inRenderer: *DebugRendererSimple, inBodyFilter: *void) -> void #foreign JoltC "JPC_PhysicsSystem_DrawBodies";

PhysicsSystem_DrawConstraints :: (self: *PhysicsSystem, inRenderer: *DebugRendererSimple) -> void #foreign JoltC "JPC_PhysicsSystem_DrawConstraints";

PhysicsSystem_SetSimShapeFilter :: (self: *PhysicsSystem, inShapeFilter: *SimShapeFilter) -> void #foreign JoltC "JPC_PhysicsSystem_SetSimShapeFilter";

PhysicsSystem_SetContactListener :: (self: *PhysicsSystem, inContactListener: *ContactListener) -> void #foreign JoltC "JPC_PhysicsSystem_SetContactListener";

#scope_file

JoltC :: #library,no_dll "Lib/Linux/libjoltc";
