//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



JOLT_C_H_ :: 1;

JPH_DEFAULT_COLLISION_TOLERANCE :: 1.0e-4;
JPH_DEFAULT_PENETRATION_TOLERANCE :: 1.0e-4;
JPH_DEFAULT_CONVEX_RADIUS :: 0.05;
JPH_CAPSULE_PROJECTION_SLOP :: 0.02;
JPH_MAX_PHYSICS_JOBS :: 2048;
JPH_MAX_PHYSICS_BARRIERS :: 8;
JPH_INVALID_COLLISION_GROUP_ID :: ~0;
JPH_INVALID_COLLISION_SUBGROUP_ID :: ~0;
JPH_M_PI :: 3.14159265358979323846;

Bool :: u32;
BodyID :: u32;
SubShapeID :: u32;
ObjectLayer :: u32;
BroadPhaseLayer :: u8;
CollisionGroupID :: u32;
CollisionSubGroupID :: u32;
CharacterID :: u32;

BroadPhaseLayerInterface :: struct {}
ObjectVsBroadPhaseLayerFilter :: struct {}
ObjectLayerPairFilter :: struct {}

BroadPhaseLayerFilter :: struct {}
ObjectLayerFilter :: struct {}
BodyFilter :: struct {}
ShapeFilter :: struct {}

SimShapeFilter :: struct {}

PhysicsStepListener :: struct {}
PhysicsSystem :: struct {}
PhysicsMaterial :: struct {}

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
RotatedTranslatedShapeSettings :: struct {}
ScaledShapeSettings :: struct {}
OffsetCenterOfMassShapeSettings :: struct {}
EmptyShapeSettings :: struct {}

Shape :: struct {}
ConvexShape :: struct {}
SphereShape :: struct {}
BoxShape :: struct {}
PlaneShape :: struct {}
CapsuleShape :: struct {}
CylinderShape :: struct {}
TaperedCylinderShape :: struct {}
TriangleShape :: struct {}
TaperedCapsuleShape :: struct {}
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

BodyCreationSettings :: struct {}
SoftBodyCreationSettings :: struct {}
BodyInterface :: struct {}
BodyLockInterface :: struct {}
BroadPhaseQuery :: struct {}
NarrowPhaseQuery :: struct {}
MotionProperties :: struct {}

Body :: struct {}

ContactListener :: struct {}
ContactManifold :: struct {}

GroupFilter :: struct {}
GroupFilterTable :: struct {}

/* Enums */
PhysicsUpdateError :: enum u32 {
    None                           :: 0;
    ManifoldCacheFull              :: 1;
    BodyPairCacheFull              :: 2;
    ContactConstraintsFull         :: 4;

    JPH_PhysicsUpdateError_Count   :: 5;
    JPH_PhysicsUpdateError_Force32 :: 2147483647;

    JPH_PhysicsUpdateError_None                   :: None;
    JPH_PhysicsUpdateError_ManifoldCacheFull      :: ManifoldCacheFull;
    JPH_PhysicsUpdateError_BodyPairCacheFull      :: BodyPairCacheFull;
    JPH_PhysicsUpdateError_ContactConstraintsFull :: ContactConstraintsFull;

    _JPH_PhysicsUpdateError_Count                 :: JPH_PhysicsUpdateError_Count;
    _JPH_PhysicsUpdateError_Force32               :: JPH_PhysicsUpdateError_Force32;
}

BodyType :: enum u32 {
    Rigid                :: 0;
    Soft                 :: 1;

    JPH_BodyType_Count   :: 2;
    JPH_BodyType_Force32 :: 2147483647;

    JPH_BodyType_Rigid    :: Rigid;
    JPH_BodyType_Soft     :: Soft;

    _JPH_BodyType_Count   :: JPH_BodyType_Count;
    _JPH_BodyType_Force32 :: JPH_BodyType_Force32;
}

MotionType :: enum u32 {
    Static                 :: 0;
    Kinematic              :: 1;
    Dynamic                :: 2;

    JPH_MotionType_Count   :: 3;
    JPH_MotionType_Force32 :: 2147483647;

    JPH_MotionType_Static    :: Static;
    JPH_MotionType_Kinematic :: Kinematic;
    JPH_MotionType_Dynamic   :: Dynamic;

    _JPH_MotionType_Count    :: JPH_MotionType_Count;
    _JPH_MotionType_Force32  :: JPH_MotionType_Force32;
}

Activation :: enum u32 {
    Activate               :: 0;
    DontActivate           :: 1;

    JPH_Activation_Count   :: 2;
    JPH_Activation_Force32 :: 2147483647;

    JPH_Activation_Activate     :: Activate;
    JPH_Activation_DontActivate :: DontActivate;

    _JPH_Activation_Count       :: JPH_Activation_Count;
    _JPH_Activation_Force32     :: JPH_Activation_Force32;
}

ValidateResult :: enum u32 {
    AcceptAllContactsForThisBodyPair :: 0;
    AcceptContact                    :: 1;
    RejectContact                    :: 2;
    RejectAllContactsForThisBodyPair :: 3;

    JPH_ValidateResult_Count         :: 4;
    JPH_ValidateResult_Force32       :: 2147483647;

    JPH_ValidateResult_AcceptAllContactsForThisBodyPair :: AcceptAllContactsForThisBodyPair;
    JPH_ValidateResult_AcceptContact                    :: AcceptContact;
    JPH_ValidateResult_RejectContact                    :: RejectContact;
    JPH_ValidateResult_RejectAllContactsForThisBodyPair :: RejectAllContactsForThisBodyPair;

    _JPH_ValidateResult_Count                           :: JPH_ValidateResult_Count;
    _JPH_ValidateResult_Force32                         :: JPH_ValidateResult_Force32;
}

ShapeType :: enum u32 {
    Convex                :: 0;
    Compound              :: 1;
    Decorated             :: 2;
    Mesh                  :: 3;
    HeightField           :: 4;
    SoftBody              :: 5;

    User1                 :: 6;
    User2                 :: 7;
    User3                 :: 8;
    User4                 :: 9;

    JPH_ShapeType_Count   :: 10;
    JPH_ShapeType_Force32 :: 2147483647;

    JPH_ShapeType_Convex      :: Convex;
    JPH_ShapeType_Compound    :: Compound;
    JPH_ShapeType_Decorated   :: Decorated;
    JPH_ShapeType_Mesh        :: Mesh;
    JPH_ShapeType_HeightField :: HeightField;
    JPH_ShapeType_SoftBody    :: SoftBody;

    JPH_ShapeType_User1       :: User1;
    JPH_ShapeType_User2       :: User2;
    JPH_ShapeType_User3       :: User3;
    JPH_ShapeType_User4       :: User4;

    _JPH_ShapeType_Count      :: JPH_ShapeType_Count;
    _JPH_ShapeType_Force32    :: JPH_ShapeType_Force32;
}

ShapeSubType :: enum u32 {
    Sphere                   :: 0;
    Box                      :: 1;
    Triangle                 :: 2;
    Capsule                  :: 3;
    TaperedCapsule           :: 4;
    Cylinder                 :: 5;
    ConvexHull               :: 6;
    StaticCompound           :: 7;
    MutableCompound          :: 8;
    RotatedTranslated        :: 9;
    Scaled                   :: 10;
    OffsetCenterOfMass       :: 11;
    Mesh                     :: 12;
    HeightField              :: 13;
    SoftBody                 :: 14;

    JPH_ShapeSubType_Count   :: 15;
    JPH_ShapeSubType_Force32 :: 2147483647;

    JPH_ShapeSubType_Sphere             :: Sphere;
    JPH_ShapeSubType_Box                :: Box;
    JPH_ShapeSubType_Triangle           :: Triangle;
    JPH_ShapeSubType_Capsule            :: Capsule;
    JPH_ShapeSubType_TaperedCapsule     :: TaperedCapsule;
    JPH_ShapeSubType_Cylinder           :: Cylinder;
    JPH_ShapeSubType_ConvexHull         :: ConvexHull;
    JPH_ShapeSubType_StaticCompound     :: StaticCompound;
    JPH_ShapeSubType_MutableCompound    :: MutableCompound;
    JPH_ShapeSubType_RotatedTranslated  :: RotatedTranslated;
    JPH_ShapeSubType_Scaled             :: Scaled;
    JPH_ShapeSubType_OffsetCenterOfMass :: OffsetCenterOfMass;
    JPH_ShapeSubType_Mesh               :: Mesh;
    JPH_ShapeSubType_HeightField        :: HeightField;
    JPH_ShapeSubType_SoftBody           :: SoftBody;

    _JPH_ShapeSubType_Count             :: JPH_ShapeSubType_Count;
    _JPH_ShapeSubType_Force32           :: JPH_ShapeSubType_Force32;
}

ConstraintType :: enum u32 {
    Constraint                 :: 0;
    TwoBodyConstraint          :: 1;

    JPH_ConstraintType_Count   :: 2;
    JPH_ConstraintType_Force32 :: 2147483647;

    JPH_ConstraintType_Constraint        :: Constraint;
    JPH_ConstraintType_TwoBodyConstraint :: TwoBodyConstraint;

    _JPH_ConstraintType_Count            :: JPH_ConstraintType_Count;
    _JPH_ConstraintType_Force32          :: JPH_ConstraintType_Force32;
}

ConstraintSubType :: enum u32 {
    Fixed                         :: 0;
    Point                         :: 1;
    Hinge                         :: 2;
    Slider                        :: 3;
    Distance                      :: 4;
    Cone                          :: 5;
    SwingTwist                    :: 6;
    SixDOF                        :: 7;
    Path                          :: 8;
    Vehicle                       :: 9;
    RackAndPinion                 :: 10;
    Gear                          :: 11;
    Pulley                        :: 12;

    User1                         :: 13;
    User2                         :: 14;
    User3                         :: 15;
    User4                         :: 16;

    JPH_ConstraintSubType_Count   :: 17;
    JPH_ConstraintSubType_Force32 :: 2147483647;

    JPH_ConstraintSubType_Fixed         :: Fixed;
    JPH_ConstraintSubType_Point         :: Point;
    JPH_ConstraintSubType_Hinge         :: Hinge;
    JPH_ConstraintSubType_Slider        :: Slider;
    JPH_ConstraintSubType_Distance      :: Distance;
    JPH_ConstraintSubType_Cone          :: Cone;
    JPH_ConstraintSubType_SwingTwist    :: SwingTwist;
    JPH_ConstraintSubType_SixDOF        :: SixDOF;
    JPH_ConstraintSubType_Path          :: Path;
    JPH_ConstraintSubType_Vehicle       :: Vehicle;
    JPH_ConstraintSubType_RackAndPinion :: RackAndPinion;
    JPH_ConstraintSubType_Gear          :: Gear;
    JPH_ConstraintSubType_Pulley        :: Pulley;

    JPH_ConstraintSubType_User1         :: User1;
    JPH_ConstraintSubType_User2         :: User2;
    JPH_ConstraintSubType_User3         :: User3;
    JPH_ConstraintSubType_User4         :: User4;

    _JPH_ConstraintSubType_Count        :: JPH_ConstraintSubType_Count;
    _JPH_ConstraintSubType_Force32      :: JPH_ConstraintSubType_Force32;
}

ConstraintSpace :: enum u32 {
    LocalToBodyCOM              :: 0;
    WorldSpace                  :: 1;

    JPH_ConstraintSpace_Count   :: 2;
    JPH_ConstraintSpace_Force32 :: 2147483647;

    JPH_ConstraintSpace_LocalToBodyCOM :: LocalToBodyCOM;
    JPH_ConstraintSpace_WorldSpace     :: WorldSpace;

    _JPH_ConstraintSpace_Count         :: JPH_ConstraintSpace_Count;
    _JPH_ConstraintSpace_Force32       :: JPH_ConstraintSpace_Force32;
}

MotionQuality :: enum u32 {
    Discrete                  :: 0;
    LinearCast                :: 1;

    JPH_MotionQuality_Count   :: 2;
    JPH_MotionQuality_Force32 :: 2147483647;

    JPH_MotionQuality_Discrete   :: Discrete;
    JPH_MotionQuality_LinearCast :: LinearCast;

    _JPH_MotionQuality_Count     :: JPH_MotionQuality_Count;
    _JPH_MotionQuality_Force32   :: JPH_MotionQuality_Force32;
}

OverrideMassProperties :: enum u32 {
    CalculateMassAndInertia                :: 0;
    CalculateInertia                       :: 1;
    MassAndInertiaProvided                 :: 2;

    JPH_JPH_OverrideMassProperties_Count   :: 3;
    JPH_JPH_OverrideMassProperties_Force32 :: 2147483647;

    JPH_OverrideMassProperties_CalculateMassAndInertia :: CalculateMassAndInertia;
    JPH_OverrideMassProperties_CalculateInertia        :: CalculateInertia;
    JPH_OverrideMassProperties_MassAndInertiaProvided  :: MassAndInertiaProvided;

    _JPH_JPH_OverrideMassProperties_Count              :: JPH_JPH_OverrideMassProperties_Count;
    _JPH_JPH_OverrideMassProperties_Force32            :: JPH_JPH_OverrideMassProperties_Force32;
}

AllowedDOFs :: enum u32 {
    All                     :: 63;
    TranslationX            :: 1;
    TranslationY            :: 2;
    TranslationZ            :: 4;
    RotationX               :: 8;
    RotationY               :: 16;
    RotationZ               :: 32;
    Plane2D                 :: 35;

    JPH_AllowedDOFs_Count   :: 36;
    JPH_AllowedDOFs_Force32 :: 2147483647;

    JPH_AllowedDOFs_All          :: All;
    JPH_AllowedDOFs_TranslationX :: TranslationX;
    JPH_AllowedDOFs_TranslationY :: TranslationY;
    JPH_AllowedDOFs_TranslationZ :: TranslationZ;
    JPH_AllowedDOFs_RotationX    :: RotationX;
    JPH_AllowedDOFs_RotationY    :: RotationY;
    JPH_AllowedDOFs_RotationZ    :: RotationZ;
    JPH_AllowedDOFs_Plane2D      :: Plane2D;

    _JPH_AllowedDOFs_Count       :: JPH_AllowedDOFs_Count;
    _JPH_AllowedDOFs_Force32     :: JPH_AllowedDOFs_Force32;
}

GroundState :: enum u32 {
    OnGround                :: 0;
    OnSteepGround           :: 1;
    NotSupported            :: 2;
    InAir                   :: 3;

    JPH_GroundState_Count   :: 4;
    JPH_GroundState_Force32 :: 2147483647;

    JPH_GroundState_OnGround      :: OnGround;
    JPH_GroundState_OnSteepGround :: OnSteepGround;
    JPH_GroundState_NotSupported  :: NotSupported;
    JPH_GroundState_InAir         :: InAir;

    _JPH_GroundState_Count        :: JPH_GroundState_Count;
    _JPH_GroundState_Force32      :: JPH_GroundState_Force32;
}

BackFaceMode :: enum u32 {
    IgnoreBackFaces          :: 0;
    CollideWithBackFaces     :: 1;

    JPH_BackFaceMode_Count   :: 2;
    JPH_BackFaceMode_Force32 :: 2147483647;

    JPH_BackFaceMode_IgnoreBackFaces      :: IgnoreBackFaces;
    JPH_BackFaceMode_CollideWithBackFaces :: CollideWithBackFaces;

    _JPH_BackFaceMode_Count               :: JPH_BackFaceMode_Count;
    _JPH_BackFaceMode_Force32             :: JPH_BackFaceMode_Force32;
}

ActiveEdgeMode :: enum u32 {
    CollideOnlyWithActive      :: 0;
    CollideWithAll             :: 1;

    JPH_ActiveEdgeMode_Count   :: 2;
    JPH_ActiveEdgeMode_Force32 :: 2147483647;

    JPH_ActiveEdgeMode_CollideOnlyWithActive :: CollideOnlyWithActive;
    JPH_ActiveEdgeMode_CollideWithAll        :: CollideWithAll;

    _JPH_ActiveEdgeMode_Count                :: JPH_ActiveEdgeMode_Count;
    _JPH_ActiveEdgeMode_Force32              :: JPH_ActiveEdgeMode_Force32;
}

CollectFacesMode :: enum u32 {
    CollectFaces                 :: 0;
    NoFaces                      :: 1;

    JPH_CollectFacesMode_Count   :: 2;
    JPH_CollectFacesMode_Force32 :: 2147483647;

    JPH_CollectFacesMode_CollectFaces :: CollectFaces;
    JPH_CollectFacesMode_NoFaces      :: NoFaces;

    _JPH_CollectFacesMode_Count       :: JPH_CollectFacesMode_Count;
    _JPH_CollectFacesMode_Force32     :: JPH_CollectFacesMode_Force32;
}

MotorState :: enum u32 {
    Off                    :: 0;
    Velocity               :: 1;
    Position               :: 2;

    JPH_MotorState_Count   :: 3;
    JPH_MotorState_Force32 :: 2147483647;

    JPH_MotorState_Off      :: Off;
    JPH_MotorState_Velocity :: Velocity;
    JPH_MotorState_Position :: Position;

    _JPH_MotorState_Count   :: JPH_MotorState_Count;
    _JPH_MotorState_Force32 :: JPH_MotorState_Force32;
}

CollisionCollectorType :: enum u32 {
    AllHit                             :: 0;
    AllHitSorted                       :: 1;
    ClosestHit                         :: 2;
    AnyHit                             :: 3;

    JPH_CollisionCollectorType_Count   :: 4;
    JPH_CollisionCollectorType_Force32 :: 2147483647;

    JPH_CollisionCollectorType_AllHit       :: AllHit;
    JPH_CollisionCollectorType_AllHitSorted :: AllHitSorted;
    JPH_CollisionCollectorType_ClosestHit   :: ClosestHit;
    JPH_CollisionCollectorType_AnyHit       :: AnyHit;

    _JPH_CollisionCollectorType_Count       :: JPH_CollisionCollectorType_Count;
    _JPH_CollisionCollectorType_Force32     :: JPH_CollisionCollectorType_Force32;
}

SwingType :: enum u32 {
    Cone                  :: 0;
    Pyramid               :: 1;

    JPH_SwingType_Count   :: 2;
    JPH_SwingType_Force32 :: 2147483647;

    JPH_SwingType_Cone     :: Cone;
    JPH_SwingType_Pyramid  :: Pyramid;

    _JPH_SwingType_Count   :: JPH_SwingType_Count;
    _JPH_SwingType_Force32 :: JPH_SwingType_Force32;
}

SixDOFConstraintAxis :: enum u32 {
    TranslationX                            :: 0;
    TranslationY                            :: 1;
    TranslationZ                            :: 2;

    RotationX                               :: 3;
    RotationY                               :: 4;
    RotationZ                               :: 5;

    JPH_SixDOFConstraintAxis_Num            :: 6;
    JPH_SixDOFConstraintAxis_NumTranslation :: 3;
    JPH_SixDOFConstraintAxis_Force32        :: 2147483647;

    JPH_SixDOFConstraintAxis_TranslationX    :: TranslationX;
    JPH_SixDOFConstraintAxis_TranslationY    :: TranslationY;
    JPH_SixDOFConstraintAxis_TranslationZ    :: TranslationZ;

    JPH_SixDOFConstraintAxis_RotationX       :: RotationX;
    JPH_SixDOFConstraintAxis_RotationY       :: RotationY;
    JPH_SixDOFConstraintAxis_RotationZ       :: RotationZ;

    _JPH_SixDOFConstraintAxis_Num            :: JPH_SixDOFConstraintAxis_Num;
    _JPH_SixDOFConstraintAxis_NumTranslation :: JPH_SixDOFConstraintAxis_NumTranslation;
    _JPH_SixDOFConstraintAxis_Force32        :: JPH_SixDOFConstraintAxis_Force32;
}

SpringMode :: enum u32 {
    FrequencyAndDamping    :: 0;
    StiffnessAndDamping    :: 1;

    JPH_SpringMode_Count   :: 2;
    JPH_SpringMode_Force32 :: 2147483647;

    JPH_SpringMode_FrequencyAndDamping :: FrequencyAndDamping;
    JPH_SpringMode_StiffnessAndDamping :: StiffnessAndDamping;

    _JPH_SpringMode_Count              :: JPH_SpringMode_Count;
    _JPH_SpringMode_Force32            :: JPH_SpringMode_Force32;
}

/// Defines how to color soft body constraints
SoftBodyConstraintColor :: enum u32 {
    ConstraintType                      :: 0;
    ConstraintGroup                     :: 1;
    ConstraintOrder                     :: 2;

    JPH_SoftBodyConstraintColor_Count   :: 3;
    JPH_SoftBodyConstraintColor_Force32 :: 2147483647;

    JPH_SoftBodyConstraintColor_ConstraintType  :: ConstraintType;
    JPH_SoftBodyConstraintColor_ConstraintGroup :: ConstraintGroup;
    JPH_SoftBodyConstraintColor_ConstraintOrder :: ConstraintOrder;

    _JPH_SoftBodyConstraintColor_Count          :: JPH_SoftBodyConstraintColor_Count;
    _JPH_SoftBodyConstraintColor_Force32        :: JPH_SoftBodyConstraintColor_Force32;
}

BodyManager_ShapeColor :: enum u32 {
    InstanceColor                      :: 0;
    ShapeTypeColor                     :: 1;
    MotionTypeColor                    :: 2;
    SleepColor                         :: 3;
    IslandColor                        :: 4;
    MaterialColor                      :: 5;

    JPH_BodyManager_ShapeColor_Count   :: 6;
    JPH_BodyManager_ShapeColor_Force32 :: 2147483647;

    JPH_BodyManager_ShapeColor_InstanceColor   :: InstanceColor;
    JPH_BodyManager_ShapeColor_ShapeTypeColor  :: ShapeTypeColor;
    JPH_BodyManager_ShapeColor_MotionTypeColor :: MotionTypeColor;
    JPH_BodyManager_ShapeColor_SleepColor      :: SleepColor;
    JPH_BodyManager_ShapeColor_IslandColor     :: IslandColor;
    JPH_BodyManager_ShapeColor_MaterialColor   :: MaterialColor;

    _JPH_BodyManager_ShapeColor_Count          :: JPH_BodyManager_ShapeColor_Count;
    _JPH_BodyManager_ShapeColor_Force32        :: JPH_BodyManager_ShapeColor_Force32;
}

DebugRenderer_CastShadow :: enum u32 {
    On                                   :: 0;
    Off                                  :: 1;

    JPH_DebugRenderer_CastShadow_Count   :: 2;
    JPH_DebugRenderer_CastShadow_Force32 :: 2147483647;

    JPH_DebugRenderer_CastShadow_On       :: On;
    JPH_DebugRenderer_CastShadow_Off      :: Off;

    _JPH_DebugRenderer_CastShadow_Count   :: JPH_DebugRenderer_CastShadow_Count;
    _JPH_DebugRenderer_CastShadow_Force32 :: JPH_DebugRenderer_CastShadow_Force32;
}

DebugRenderer_DrawMode :: enum u32 {
    Solid                              :: 0;
    Wireframe                          :: 1;

    JPH_DebugRenderer_DrawMode_Count   :: 2;
    JPH_DebugRenderer_DrawMode_Force32 :: 2147483647;

    JPH_DebugRenderer_DrawMode_Solid     :: Solid;
    JPH_DebugRenderer_DrawMode_Wireframe :: Wireframe;

    _JPH_DebugRenderer_DrawMode_Count    :: JPH_DebugRenderer_DrawMode_Count;
    _JPH_DebugRenderer_DrawMode_Force32  :: JPH_DebugRenderer_DrawMode_Force32;
}

Mesh_Shape_BuildQuality :: enum u32 {
    FavorRuntimePerformance             :: 0;
    FavorBuildSpeed                     :: 1;

    JPH_Mesh_Shape_BuildQuality_Count   :: 2;
    JPH_Mesh_Shape_BuildQuality_Force32 :: 2147483647;

    JPH_Mesh_Shape_BuildQuality_FavorRuntimePerformance :: FavorRuntimePerformance;
    JPH_Mesh_Shape_BuildQuality_FavorBuildSpeed         :: FavorBuildSpeed;

    _JPH_Mesh_Shape_BuildQuality_Count                  :: JPH_Mesh_Shape_BuildQuality_Count;
    _JPH_Mesh_Shape_BuildQuality_Force32                :: JPH_Mesh_Shape_BuildQuality_Force32;
}

TransmissionMode :: enum u32 {
    Auto                         :: 0;
    Manual                       :: 1;

    JPH_TransmissionMode_Count   :: 2;
    JPH_TransmissionMode_Force32 :: 2147483647;

    JPH_TransmissionMode_Auto     :: Auto;
    JPH_TransmissionMode_Manual   :: Manual;

    _JPH_TransmissionMode_Count   :: JPH_TransmissionMode_Count;
    _JPH_TransmissionMode_Force32 :: JPH_TransmissionMode_Force32;
}

Plane :: struct {
    normal:   Vec3;
    distance: float;
}

Mat4 :: struct {
    column: [4] Vec4;
}

RVec3 :: Vec3;
RMat4 :: Mat4;

Color :: u32;

AABox :: struct {
    min: Vec3;
    max: Vec3;
}

Triangle :: struct {
    v1:            Vec3;
    v2:            Vec3;
    v3:            Vec3;
    materialIndex: u32;
}

IndexedTriangleNoMaterial :: struct {
    i1: u32;
    i2: u32;
    i3: u32;
}

IndexedTriangle :: struct {
    i1:            u32;
    i2:            u32;
    i3:            u32;
    materialIndex: u32;
    userData:      u32;
}

MassProperties :: struct {
    mass:    float;
    inertia: Mat4;
}

ContactSettings :: struct {
    combinedFriction:               float;
    combinedRestitution:            float;
    invMassScale1:                  float;
    invInertiaScale1:               float;
    invMassScale2:                  float;
    invInertiaScale2:               float;
    isSensor:                       Bool;
    relativeLinearSurfaceVelocity:  Vec3;
    relativeAngularSurfaceVelocity: Vec3;
}

CollideSettingsBase :: struct {
    activeEdgeMode:              ActiveEdgeMode; /* = JPH_ActiveEdgeMode_CollideOnlyWithActive*/

    collectFacesMode:            CollectFacesMode; /* = JPH_CollectFacesMode_NoFaces*/

    collisionTolerance:          float; /* = JPH_DEFAULT_COLLISION_TOLERANCE*/

    penetrationTolerance:        float; /* = JPH_DEFAULT_PENETRATION_TOLERANCE*/

    activeEdgeMovementDirection: Vec3; /* = Vec3::sZero()*/
}

/* CollideShapeSettings */
CollideShapeSettings :: struct {
    base:                  CollideSettingsBase; /* Inherits JPH_CollideSettingsBase */

    maxSeparationDistance: float; /* = 0.0f*/

    backFaceMode:          BackFaceMode; /* = JPH_BackFaceMode_IgnoreBackFaces*/
}

/* ShapeCastSettings */
ShapeCastSettings :: struct {
    base:                            CollideSettingsBase; /* Inherits JPH_CollideSettingsBase */

    backFaceModeTriangles:           BackFaceMode; /* = JPH_BackFaceMode_IgnoreBackFaces*/

    backFaceModeConvex:              BackFaceMode; /* = JPH_BackFaceMode_IgnoreBackFaces*/

    useShrunkenShapeAndConvexRadius: bool; /* = false*/

    returnDeepestPoint:              bool; /* = false*/
}

RayCastSettings :: struct {
    backFaceModeTriangles: BackFaceMode; /* = JPH_BackFaceMode_IgnoreBackFaces*/

    backFaceModeConvex:    BackFaceMode; /* = JPH_BackFaceMode_IgnoreBackFaces*/

    treatConvexAsSolid:    bool; /* = true*/
}

SpringSettings :: struct {
    mode:                 SpringMode;
    frequencyOrStiffness: float;
    damping:              float;
}

MotorSettings :: struct {
    springSettings: SpringSettings;
    minForceLimit:  float;
    maxForceLimit:  float;
    minTorqueLimit: float;
    maxTorqueLimit: float;
}

SubShapeIDPair :: struct {
    Body1ID:     BodyID;
    subShapeID1: SubShapeID;
    Body2ID:     BodyID;
    subShapeID2: SubShapeID;
}

BroadPhaseCastResult :: struct {
    bodyID:   BodyID;
    fraction: float;
}

RayCastResult :: struct {
    bodyID:      BodyID;
    fraction:    float;
    subShapeID2: SubShapeID;
}

CollidePointResult :: struct {
    bodyID:      BodyID;
    subShapeID2: SubShapeID;
}

CollideShapeResult :: struct {
    contactPointOn1:  Vec3;
    contactPointOn2:  Vec3;
    penetrationAxis:  Vec3;
    penetrationDepth: float;
    subShapeID1:      SubShapeID;
    subShapeID2:      SubShapeID;
    bodyID2:          BodyID;
    shape1FaceCount:  u32;
    shape1Faces:      *Vec3;
    shape2FaceCount:  u32;
    shape2Faces:      *Vec3;
}

ShapeCastResult :: struct {
    contactPointOn1:  Vec3;
    contactPointOn2:  Vec3;
    penetrationAxis:  Vec3;
    penetrationDepth: float;
    subShapeID1:      SubShapeID;
    subShapeID2:      SubShapeID;
    bodyID2:          BodyID;
    fraction:         float;
    isBackFaceHit:    bool;
}

DrawSettings :: struct {
    drawGetSupportFunction:        bool; ///< Draw the GetSupport() function, used for convex collision detection
    drawSupportDirection:          bool; ///< When drawing the support function, also draw which direction mapped to a specific support point
    drawGetSupportingFace:         bool; ///< Draw the faces that were found colliding during collision detection
    drawShape:                     bool; ///< Draw the shapes of all bodies
    drawShapeWireframe:            bool; ///< When mDrawShape is true and this is true, the shapes will be drawn in wireframe instead of solid.
    drawShapeColor:                BodyManager_ShapeColor; ///< Coloring scheme to use for shapes
    drawBoundingBox:               bool; ///< Draw a bounding box per body
    drawCenterOfMassTransform:     bool; ///< Draw the center of mass for each body
    drawWorldTransform:            bool; ///< Draw the world transform (which may differ from its center of mass) of each body
    drawVelocity:                  bool; ///< Draw the velocity vector for each body
    drawMassAndInertia:            bool; ///< Draw the mass and inertia (as the box equivalent) for each body
    drawSleepStats:                bool; ///< Draw stats regarding the sleeping algorithm of each body
    drawSoftBodyVertices:          bool; ///< Draw the vertices of soft bodies
    drawSoftBodyVertexVelocities:  bool; ///< Draw the velocities of the vertices of soft bodies
    drawSoftBodyEdgeConstraints:   bool; ///< Draw the edge constraints of soft bodies
    drawSoftBodyBendConstraints:   bool; ///< Draw the bend constraints of soft bodies
    drawSoftBodyVolumeConstraints: bool; ///< Draw the volume constraints of soft bodies
    drawSoftBodySkinConstraints:   bool; ///< Draw the skin constraints of soft bodies
    drawSoftBodyLRAConstraints:    bool; ///< Draw the LRA constraints of soft bodies
    drawSoftBodyPredictedBounds:   bool; ///< Draw the predicted bounds of soft bodies
    drawSoftBodyConstraintColor:   SoftBodyConstraintColor; ///< Coloring scheme to use for soft body constraints
}

SupportingFace :: struct {
    count:    u32;
    vertices: [32] Vec3;
}

CollisionGroup :: struct {
    groupFilter: *GroupFilter;
    groupID:     CollisionGroupID;
    subGroupID:  CollisionSubGroupID;
}

CastRayResultCallback :: #type (_context: *void, result: *RayCastResult) -> void #c_call;
RayCastBodyResultCallback :: #type (_context: *void, result: *BroadPhaseCastResult) -> void #c_call;
CollideShapeBodyResultCallback :: #type (_context: *void, result: BodyID) -> void #c_call;
CollidePointResultCallback :: #type (_context: *void, result: *CollidePointResult) -> void #c_call;
CollideShapeResultCallback :: #type (_context: *void, result: *CollideShapeResult) -> void #c_call;
CastShapeResultCallback :: #type (_context: *void, result: *ShapeCastResult) -> void #c_call;

CastRayCollectorCallback :: #type (_context: *void, result: *RayCastResult) -> float #c_call;
RayCastBodyCollectorCallback :: #type (_context: *void, result: *BroadPhaseCastResult) -> float #c_call;
CollideShapeBodyCollectorCallback :: #type (_context: *void, result: BodyID) -> float #c_call;
CollidePointCollectorCallback :: #type (_context: *void, result: *CollidePointResult) -> float #c_call;
CollideShapeCollectorCallback :: #type (_context: *void, result: *CollideShapeResult) -> float #c_call;
CastShapeCollectorCallback :: #type (_context: *void, result: *ShapeCastResult) -> float #c_call;

CollisionEstimationResultImpulse :: struct {
    contactImpulse:   float;
    frictionImpulse1: float;
    frictionImpulse2: float;
}

CollisionEstimationResult :: struct {
    linearVelocity1:  Vec3;
    angularVelocity1: Vec3;
    linearVelocity2:  Vec3;
    angularVelocity2: Vec3;

    tangent1:         Vec3;
    tangent2:         Vec3;

    impulseCount:     u32;
    impulses:         *CollisionEstimationResultImpulse;
}

BodyActivationListener :: struct {}
BodyDrawFilter :: struct {}

SharedMutex :: struct {}

DebugRenderer :: struct {}

Constraint :: struct {}
TwoBodyConstraint :: struct {}
FixedConstraint :: struct {}
DistanceConstraint :: struct {}
PointConstraint :: struct {}
HingeConstraint :: struct {}
SliderConstraint :: struct {}
ConeConstraint :: struct {}
SwingTwistConstraint :: struct {}
SixDOFConstraint :: struct {}
GearConstraint :: struct {}

CharacterBase :: struct {}
Character :: struct {}
CharacterVirtual :: struct {}
CharacterContactListener :: struct {}
CharacterVsCharacterCollision :: struct {}

Skeleton :: struct {}
RagdollSettings :: struct {}
Ragdoll :: struct {}

ConstraintSettings :: struct {
    enabled:                  bool;
    constraintPriority:       u32;
    numVelocityStepsOverride: u32;
    numPositionStepsOverride: u32;
    drawConstraintSize:       float;
    userData:                 u64;
}

FixedConstraintSettings :: struct {
    base:            ConstraintSettings; /* Inherits JPH_ConstraintSettings */

    space:           ConstraintSpace;
    autoDetectPoint: bool;
    point1:          RVec3;
    axisX1:          Vec3;
    axisY1:          Vec3;
    point2:          RVec3;
    axisX2:          Vec3;
    axisY2:          Vec3;
}

DistanceConstraintSettings :: struct {
    base:                 ConstraintSettings; /* Inherits JPH_ConstraintSettings */

    space:                ConstraintSpace;
    point1:               RVec3;
    point2:               RVec3;
    minDistance:          float;
    maxDistance:          float;
    limitsSpringSettings: SpringSettings;
}

PointConstraintSettings :: struct {
    base:   ConstraintSettings; /* Inherits JPH_ConstraintSettings */

    space:  ConstraintSpace;
    point1: RVec3;
    point2: RVec3;
}

HingeConstraintSettings :: struct {
    base:                 ConstraintSettings; /* Inherits JPH_ConstraintSettings */

    space:                ConstraintSpace;
    point1:               RVec3;
    hingeAxis1:           Vec3;
    normalAxis1:          Vec3;
    point2:               RVec3;
    hingeAxis2:           Vec3;
    normalAxis2:          Vec3;
    limitsMin:            float;
    limitsMax:            float;
    limitsSpringSettings: SpringSettings;
    maxFrictionTorque:    float;
    motorSettings:        MotorSettings;
}

SliderConstraintSettings :: struct {
    base:                 ConstraintSettings; /* Inherits JPH_ConstraintSettings */

    space:                ConstraintSpace;
    autoDetectPoint:      bool;
    point1:               RVec3;
    sliderAxis1:          Vec3;
    normalAxis1:          Vec3;
    point2:               RVec3;
    sliderAxis2:          Vec3;
    normalAxis2:          Vec3;
    limitsMin:            float;
    limitsMax:            float;
    limitsSpringSettings: SpringSettings;
    maxFrictionForce:     float;
    motorSettings:        MotorSettings;
}

ConeConstraintSettings :: struct {
    base:          ConstraintSettings; /* Inherits JPH_ConstraintSettings */

    space:         ConstraintSpace;
    point1:        RVec3;
    twistAxis1:    Vec3;
    point2:        RVec3;
    twistAxis2:    Vec3;
    halfConeAngle: float;
}

SwingTwistConstraintSettings :: struct {
    base:                ConstraintSettings; /* Inherits JPH_ConstraintSettings */

    space:               ConstraintSpace;
    position1:           RVec3;
    twistAxis1:          Vec3;
    planeAxis1:          Vec3;
    position2:           RVec3;
    twistAxis2:          Vec3;
    planeAxis2:          Vec3;
    swingType:           SwingType;
    normalHalfConeAngle: float;
    planeHalfConeAngle:  float;
    twistMinAngle:       float;
    twistMaxAngle:       float;
    maxFrictionTorque:   float;
    swingMotorSettings:  MotorSettings;
    twistMotorSettings:  MotorSettings;
}

SixDOFConstraintSettings :: struct {
    base:                 ConstraintSettings; /* Inherits JPH_ConstraintSettings */

    space:                ConstraintSpace;
    position1:            RVec3;
    axisX1:               Vec3;
    axisY1:               Vec3;
    position2:            RVec3;
    axisX2:               Vec3;
    axisY2:               Vec3;
    maxFriction:          [6] float;
    swingType:            SwingType;
    limitMin:             [6] float;
    limitMax:             [6] float;

    limitsSpringSettings: [3] SpringSettings;
    motorSettings:        [6] MotorSettings;
}

GearConstraintSettings :: struct {
    base:       ConstraintSettings; /* Inherits JPH_ConstraintSettings */

    space:      ConstraintSpace;
    hingeAxis1: Vec3;
    hingeAxis2: Vec3;
    ratio:      float;
}

BodyLockRead :: struct {
    lockInterface: *BodyLockInterface;
    mutex:         *SharedMutex;
    body:          *Body;
}

BodyLockWrite :: struct {
    lockInterface: *BodyLockInterface;
    mutex:         *SharedMutex;
    body:          *Body;
}

BodyLockMultiRead :: struct {}
BodyLockMultiWrite :: struct {}

ExtendedUpdateSettings :: struct {
    stickToFloorStepDown:             Vec3;
    walkStairsStepUp:                 Vec3;
    walkStairsMinStepForward:         float;
    walkStairsStepForwardTest:        float;
    walkStairsCosAngleForwardContact: float;
    walkStairsStepDownExtra:          Vec3;
}

CharacterBaseSettings :: struct {
    up:                          Vec3;
    supportingVolume:            Plane;
    maxSlopeAngle:               float;
    enhancedInternalEdgeRemoval: bool;
    shape:                       *Shape;
}

/* Character */
CharacterSettings :: struct {
    base:          CharacterBaseSettings; /* Inherits JPH_CharacterBaseSettings */
    layer:         ObjectLayer;
    mass:          float;
    friction:      float;
    gravityFactor: float;
    allowedDOFs:   AllowedDOFs;
}

/* CharacterVirtual */
CharacterVirtualSettings :: struct {
    base:                      CharacterBaseSettings; /* Inherits JPH_CharacterBaseSettings */
    ID:                        CharacterID;
    mass:                      float;
    maxStrength:               float;
    shapeOffset:               Vec3;
    backFaceMode:              BackFaceMode;
    predictiveContactDistance: float;
    maxCollisionIterations:    u32;
    maxConstraintIterations:   u32;
    minTimeRemaining:          float;
    collisionTolerance:        float;
    characterPadding:          float;
    maxNumHits:                u32;
    hitReductionCosMaxAngle:   float;
    penetrationRecoverySpeed:  float;
    innerBodyShape:            *Shape;
    innerBodyIDOverride:       BodyID;
    innerBodyLayer:            ObjectLayer;
}

CharacterContactSettings :: struct {
    canPushCharacter:   bool;
    canReceiveImpulses: bool;
}

CharacterVirtualContact :: struct {
    hash:             u64;
    bodyB:            BodyID;
    characterIDB:     CharacterID;
    subShapeIDB:      SubShapeID;
    position:         RVec3;
    linearVelocity:   Vec3;
    contactNormal:    Vec3;
    surfaceNormal:    Vec3;
    distance:         float;
    fraction:         float;
    motionTypeB:      MotionType;
    isSensorB:        bool;
    characterB:       *CharacterVirtual;
    userData:         u64;
    material:         *PhysicsMaterial;
    hadCollision:     bool;
    wasDiscarded:     bool;
    canPushCharacter: bool;
}

TraceFunc :: #type (message: *u8) -> void #c_call;
AssertFailureFunc :: #type (expression: *u8, message: *u8, file: *u8, line: u32) -> bool #c_call;

JobFunction :: #type (arg: *void) -> void #c_call;
QueueJobCallback :: #type (_context: *void, job: JobFunction, arg: *void) -> void #c_call;
QueueJobsCallback :: #type (_context: *void, job: JobFunction, args: **void, count: u32) -> void #c_call;

JobSystemThreadPoolConfig :: struct {
    maxJobs:     u32;
    maxBarriers: u32;
    numThreads:  s32;
}

JobSystemConfig :: struct {
    _context:       *void;
    queueJob:       QueueJobCallback;
    queueJobs:      QueueJobsCallback;
    maxConcurrency: u32;
    maxBarriers:    u32;
}

JobSystem :: struct {}

JobSystemThreadPool_Create :: (config: *JobSystemThreadPoolConfig) -> *JobSystem #foreign JoltC "JPH_JobSystemThreadPool_Create";
JobSystemCallback_Create :: (config: *JobSystemConfig) -> *JobSystem #foreign JoltC "JPH_JobSystemCallback_Create";
JobSystem_Destroy :: (jobSystem: *JobSystem) -> void #foreign JoltC "JPH_JobSystem_Destroy";

Init :: () -> bool #foreign JoltC "JPH_Init";
Shutdown :: () -> void #foreign JoltC "JPH_Shutdown";
SetTraceHandler :: (handler: TraceFunc) -> void #foreign JoltC "JPH_SetTraceHandler";
SetAssertFailureHandler :: (handler: AssertFailureFunc) -> void #foreign JoltC "JPH_SetAssertFailureHandler";

/* Structs free members */
CollideShapeResult_FreeMembers :: (result: *CollideShapeResult) -> void #foreign JoltC "JPH_CollideShapeResult_FreeMembers";
CollisionEstimationResult_FreeMembers :: (result: *CollisionEstimationResult) -> void #foreign JoltC "JPH_CollisionEstimationResult_FreeMembers";

/* JPH_BroadPhaseLayerInterface */
BroadPhaseLayerInterfaceMask_Create :: (numBroadPhaseLayers: u32) -> *BroadPhaseLayerInterface #foreign JoltC "JPH_BroadPhaseLayerInterfaceMask_Create";
BroadPhaseLayerInterfaceMask_ConfigureLayer :: (bpInterface: *BroadPhaseLayerInterface, broadPhaseLayer: BroadPhaseLayer, groupsToInclude: u32, groupsToExclude: u32) -> void #foreign JoltC "JPH_BroadPhaseLayerInterfaceMask_ConfigureLayer";

BroadPhaseLayerInterfaceTable_Create :: (numObjectLayers: u32, numBroadPhaseLayers: u32) -> *BroadPhaseLayerInterface #foreign JoltC "JPH_BroadPhaseLayerInterfaceTable_Create";
BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer :: (bpInterface: *BroadPhaseLayerInterface, objectLayer: ObjectLayer, broadPhaseLayer: BroadPhaseLayer) -> void #foreign JoltC "JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer";

/* JPH_ObjectLayerPairFilter */
ObjectLayerPairFilterMask_Create :: () -> *ObjectLayerPairFilter #foreign JoltC "JPH_ObjectLayerPairFilterMask_Create";
ObjectLayerPairFilterMask_GetObjectLayer :: (group: u32, mask: u32) -> ObjectLayer #foreign JoltC "JPH_ObjectLayerPairFilterMask_GetObjectLayer";
ObjectLayerPairFilterMask_GetGroup :: (layer: ObjectLayer) -> u32 #foreign JoltC "JPH_ObjectLayerPairFilterMask_GetGroup";
ObjectLayerPairFilterMask_GetMask :: (layer: ObjectLayer) -> u32 #foreign JoltC "JPH_ObjectLayerPairFilterMask_GetMask";

ObjectLayerPairFilterTable_Create :: (numObjectLayers: u32) -> *ObjectLayerPairFilter #foreign JoltC "JPH_ObjectLayerPairFilterTable_Create";
ObjectLayerPairFilterTable_DisableCollision :: (objectFilter: *ObjectLayerPairFilter, layer1: ObjectLayer, layer2: ObjectLayer) -> void #foreign JoltC "JPH_ObjectLayerPairFilterTable_DisableCollision";
ObjectLayerPairFilterTable_EnableCollision :: (objectFilter: *ObjectLayerPairFilter, layer1: ObjectLayer, layer2: ObjectLayer) -> void #foreign JoltC "JPH_ObjectLayerPairFilterTable_EnableCollision";
ObjectLayerPairFilterTable_ShouldCollide :: (objectFilter: *ObjectLayerPairFilter, layer1: ObjectLayer, layer2: ObjectLayer) -> bool #foreign JoltC "JPH_ObjectLayerPairFilterTable_ShouldCollide";

/* JPH_ObjectVsBroadPhaseLayerFilter */
ObjectVsBroadPhaseLayerFilterMask_Create :: (broadPhaseLayerInterface: *BroadPhaseLayerInterface) -> *ObjectVsBroadPhaseLayerFilter #foreign JoltC "JPH_ObjectVsBroadPhaseLayerFilterMask_Create";

ObjectVsBroadPhaseLayerFilterTable_Create :: (broadPhaseLayerInterface: *BroadPhaseLayerInterface, numBroadPhaseLayers: u32, objectLayerPairFilter: *ObjectLayerPairFilter, numObjectLayers: u32) -> *ObjectVsBroadPhaseLayerFilter #foreign JoltC "JPH_ObjectVsBroadPhaseLayerFilterTable_Create";

DrawSettings_InitDefault :: (settings: *DrawSettings) -> void #foreign JoltC "JPH_DrawSettings_InitDefault";

/* JPH_PhysicsSystem */
PhysicsSystemSettings :: struct {
    maxBodies:                     u32; /* 10240 */
    numBodyMutexes:                u32; /* 0 */
    maxBodyPairs:                  u32; /* 65536 */
    maxContactConstraints:         u32; /* 10240 */
    _padding:                      u32;
    broadPhaseLayerInterface:      *BroadPhaseLayerInterface;
    objectLayerPairFilter:         *ObjectLayerPairFilter;
    objectVsBroadPhaseLayerFilter: *ObjectVsBroadPhaseLayerFilter;
}

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

PhysicsSystem_Create :: (settings: *PhysicsSystemSettings) -> *PhysicsSystem #foreign JoltC "JPH_PhysicsSystem_Create";
PhysicsSystem_Destroy :: (system: *PhysicsSystem) -> void #foreign JoltC "JPH_PhysicsSystem_Destroy";

PhysicsSystem_SetPhysicsSettings :: (system: *PhysicsSystem, settings: *PhysicsSettings) -> void #foreign JoltC "JPH_PhysicsSystem_SetPhysicsSettings";
PhysicsSystem_GetPhysicsSettings :: (system: *PhysicsSystem, result: *PhysicsSettings) -> void #foreign JoltC "JPH_PhysicsSystem_GetPhysicsSettings";

PhysicsSystem_OptimizeBroadPhase :: (system: *PhysicsSystem) -> void #foreign JoltC "JPH_PhysicsSystem_OptimizeBroadPhase";
PhysicsSystem_Update :: (system: *PhysicsSystem, deltaTime: float, collisionSteps: s32, jobSystem: *JobSystem) -> PhysicsUpdateError #foreign JoltC "JPH_PhysicsSystem_Update";

PhysicsSystem_GetBodyInterface :: (system: *PhysicsSystem) -> *BodyInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyInterface";
PhysicsSystem_GetBodyInterfaceNoLock :: (system: *PhysicsSystem) -> *BodyInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyInterfaceNoLock";

PhysicsSystem_GetBodyLockInterface :: (system: *PhysicsSystem) -> *BodyLockInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyLockInterface";
PhysicsSystem_GetBodyLockInterfaceNoLock :: (system: *PhysicsSystem) -> *BodyLockInterface #foreign JoltC "JPH_PhysicsSystem_GetBodyLockInterfaceNoLock";

PhysicsSystem_GetBroadPhaseQuery :: (system: *PhysicsSystem) -> *BroadPhaseQuery #foreign JoltC "JPH_PhysicsSystem_GetBroadPhaseQuery";

PhysicsSystem_GetNarrowPhaseQuery :: (system: *PhysicsSystem) -> *NarrowPhaseQuery #foreign JoltC "JPH_PhysicsSystem_GetNarrowPhaseQuery";
PhysicsSystem_GetNarrowPhaseQueryNoLock :: (system: *PhysicsSystem) -> *NarrowPhaseQuery #foreign JoltC "JPH_PhysicsSystem_GetNarrowPhaseQueryNoLock";

PhysicsSystem_SetContactListener :: (system: *PhysicsSystem, listener: *ContactListener) -> void #foreign JoltC "JPH_PhysicsSystem_SetContactListener";
PhysicsSystem_SetBodyActivationListener :: (system: *PhysicsSystem, listener: *BodyActivationListener) -> void #foreign JoltC "JPH_PhysicsSystem_SetBodyActivationListener";
PhysicsSystem_SetSimShapeFilter :: (system: *PhysicsSystem, filter: *SimShapeFilter) -> void #foreign JoltC "JPH_PhysicsSystem_SetSimShapeFilter";

PhysicsSystem_WereBodiesInContact :: (system: *PhysicsSystem, body1: BodyID, body2: BodyID) -> bool #foreign JoltC "JPH_PhysicsSystem_WereBodiesInContact";

PhysicsSystem_GetNumBodies :: (system: *PhysicsSystem) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetNumBodies";
PhysicsSystem_GetNumActiveBodies :: (system: *PhysicsSystem, type: BodyType) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetNumActiveBodies";
PhysicsSystem_GetMaxBodies :: (system: *PhysicsSystem) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetMaxBodies";
PhysicsSystem_GetNumConstraints :: (system: *PhysicsSystem) -> u32 #foreign JoltC "JPH_PhysicsSystem_GetNumConstraints";

PhysicsSystem_SetGravity :: (system: *PhysicsSystem, value: *Vec3) -> void #foreign JoltC "JPH_PhysicsSystem_SetGravity";
PhysicsSystem_GetGravity :: (system: *PhysicsSystem, result: *Vec3) -> void #foreign JoltC "JPH_PhysicsSystem_GetGravity";

PhysicsSystem_AddConstraint :: (system: *PhysicsSystem, constraint: *Constraint) -> void #foreign JoltC "JPH_PhysicsSystem_AddConstraint";
PhysicsSystem_RemoveConstraint :: (system: *PhysicsSystem, constraint: *Constraint) -> void #foreign JoltC "JPH_PhysicsSystem_RemoveConstraint";

PhysicsSystem_AddConstraints :: (system: *PhysicsSystem, constraints: **Constraint, count: u32) -> void #foreign JoltC "JPH_PhysicsSystem_AddConstraints";
PhysicsSystem_RemoveConstraints :: (system: *PhysicsSystem, constraints: **Constraint, count: u32) -> void #foreign JoltC "JPH_PhysicsSystem_RemoveConstraints";

PhysicsSystem_AddStepListener :: (system: *PhysicsSystem, listener: *PhysicsStepListener) -> void #foreign JoltC "JPH_PhysicsSystem_AddStepListener";
PhysicsSystem_RemoveStepListener :: (system: *PhysicsSystem, listener: *PhysicsStepListener) -> void #foreign JoltC "JPH_PhysicsSystem_RemoveStepListener";

PhysicsSystem_GetBodies :: (system: *PhysicsSystem, ids: *BodyID, count: u32) -> void #foreign JoltC "JPH_PhysicsSystem_GetBodies";
PhysicsSystem_GetConstraints :: (system: *PhysicsSystem, constraints: **Constraint, count: u32) -> void #foreign JoltC "JPH_PhysicsSystem_GetConstraints";

PhysicsSystem_ActivateBodiesInAABox :: (system: *PhysicsSystem, box: *AABox, layer: ObjectLayer) -> void #foreign JoltC "JPH_PhysicsSystem_ActivateBodiesInAABox";

PhysicsSystem_DrawBodies :: (system: *PhysicsSystem, settings: *DrawSettings, renderer: *DebugRenderer, bodyFilter: *BodyDrawFilter) -> void #foreign JoltC "JPH_PhysicsSystem_DrawBodies";
PhysicsSystem_DrawConstraints :: (system: *PhysicsSystem, renderer: *DebugRenderer) -> void #foreign JoltC "JPH_PhysicsSystem_DrawConstraints";
PhysicsSystem_DrawConstraintLimits :: (system: *PhysicsSystem, renderer: *DebugRenderer) -> void #foreign JoltC "JPH_PhysicsSystem_DrawConstraintLimits";
PhysicsSystem_DrawConstraintReferenceFrame :: (system: *PhysicsSystem, renderer: *DebugRenderer) -> void #foreign JoltC "JPH_PhysicsSystem_DrawConstraintReferenceFrame";

/* PhysicsStepListener */
PhysicsStepListenerContext :: struct {
    deltaTime:     float;
    isFirstStep:   Bool;
    isLastStep:    Bool;
    physicsSystem: *PhysicsSystem;
}

PhysicsStepListener_Procs :: struct {
    OnStep: #type (userData: *void, _context: *PhysicsStepListenerContext) -> void #c_call;
}

PhysicsStepListener_SetProcs :: (procs: *PhysicsStepListener_Procs) -> void #foreign JoltC "JPH_PhysicsStepListener_SetProcs";
PhysicsStepListener_Create :: (userData: *void) -> *PhysicsStepListener #foreign JoltC "JPH_PhysicsStepListener_Create";
PhysicsStepListener_Destroy :: (listener: *PhysicsStepListener) -> void #foreign JoltC "JPH_PhysicsStepListener_Destroy";

/* Math */
Math_Sin :: (value: float) -> float #foreign JoltC "JPH_Math_Sin";
Math_Cos :: (value: float) -> float #foreign JoltC "JPH_Math_Cos";

Quat_FromTo :: (from: *Vec3, to: *Vec3, quat: *Quat) -> void #foreign JoltC "JPH_Quat_FromTo";
Quat_GetAxisAngle :: (quat: *Quat, outAxis: *Vec3, outAngle: *float) -> void #foreign JoltC "JPH_Quat_GetAxisAngle";
Quat_GetEulerAngles :: (quat: *Quat, result: *Vec3) -> void #foreign JoltC "JPH_Quat_GetEulerAngles";
Quat_RotateAxisX :: (quat: *Quat, result: *Vec3) -> void #foreign JoltC "JPH_Quat_RotateAxisX";
Quat_RotateAxisY :: (quat: *Quat, result: *Vec3) -> void #foreign JoltC "JPH_Quat_RotateAxisY";
Quat_RotateAxisZ :: (quat: *Quat, result: *Vec3) -> void #foreign JoltC "JPH_Quat_RotateAxisZ";
Quat_Inversed :: (quat: *Quat, result: *Quat) -> void #foreign JoltC "JPH_Quat_Inversed";
Quat_GetPerpendicular :: (quat: *Quat, result: *Quat) -> void #foreign JoltC "JPH_Quat_GetPerpendicular";
Quat_GetRotationAngle :: (quat: *Quat, axis: *Vec3) -> float #foreign JoltC "JPH_Quat_GetRotationAngle";
Quat_FromEulerAngles :: (angles: *Vec3, result: *Quat) -> void #foreign JoltC "JPH_Quat_FromEulerAngles";

Quat_Add :: (q1: *Quat, q2: *Quat, result: *Quat) -> void #foreign JoltC "JPH_Quat_Add";
Quat_Subtract :: (q1: *Quat, q2: *Quat, result: *Quat) -> void #foreign JoltC "JPH_Quat_Subtract";
Quat_Multiply :: (q1: *Quat, q2: *Quat, result: *Quat) -> void #foreign JoltC "JPH_Quat_Multiply";
Quat_MultiplyScalar :: (q: *Quat, scalar: float, result: *Quat) -> void #foreign JoltC "JPH_Quat_MultiplyScalar";
Quat_DivideScalar :: (q: *Quat, scalar: float, result: *Quat) -> void #foreign JoltC "JPH_Quat_DivideScalar";
Quat_Dot :: (q1: *Quat, q2: *Quat, result: *float) -> void #foreign JoltC "JPH_Quat_Dot";

Quat_Conjugated :: (quat: *Quat, result: *Quat) -> void #foreign JoltC "JPH_Quat_Conjugated";
Quat_GetTwist :: (quat: *Quat, axis: *Vec3, result: *Quat) -> void #foreign JoltC "JPH_Quat_GetTwist";
Quat_GetSwingTwist :: (quat: *Quat, outSwing: *Quat, outTwist: *Quat) -> void #foreign JoltC "JPH_Quat_GetSwingTwist";
Quat_Lerp :: (from: *Quat, to: *Quat, fraction: float, result: *Quat) -> void #foreign JoltC "JPH_Quat_Lerp";
Quat_Slerp :: (from: *Quat, to: *Quat, fraction: float, result: *Quat) -> void #foreign JoltC "JPH_Quat_Slerp";
Quat_Rotate :: (quat: *Quat, vec: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Quat_Rotate";
Quat_InverseRotate :: (quat: *Quat, vec: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Quat_InverseRotate";

Vec3_AxisX :: (result: *Vec3) -> void #foreign JoltC "JPH_Vec3_AxisX";
Vec3_AxisY :: (result: *Vec3) -> void #foreign JoltC "JPH_Vec3_AxisY";
Vec3_AxisZ :: (result: *Vec3) -> void #foreign JoltC "JPH_Vec3_AxisZ";
Vec3_IsClose :: (v1: *Vec3, v2: *Vec3, maxDistSq: float) -> bool #foreign JoltC "JPH_Vec3_IsClose";
Vec3_IsNearZero :: (v: *Vec3, maxDistSq: float) -> bool #foreign JoltC "JPH_Vec3_IsNearZero";
Vec3_IsNormalized :: (v: *Vec3, tolerance: float) -> bool #foreign JoltC "JPH_Vec3_IsNormalized";
Vec3_IsNaN :: (v: *Vec3) -> bool #foreign JoltC "JPH_Vec3_IsNaN";

Vec3_Negate :: (v: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Vec3_Negate";
Vec3_Normalized :: (v: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Vec3_Normalized";
Vec3_Cross :: (v1: *Vec3, v2: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Vec3_Cross";
Vec3_Abs :: (v: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Vec3_Abs";

Vec3_Length :: (v: *Vec3) -> float #foreign JoltC "JPH_Vec3_Length";
Vec3_LengthSquared :: (v: *Vec3) -> float #foreign JoltC "JPH_Vec3_LengthSquared";

Vec3_DotProduct :: (v1: *Vec3, v2: *Vec3, result: *float) -> void #foreign JoltC "JPH_Vec3_DotProduct";
Vec3_Normalize :: (v: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Vec3_Normalize";

Vec3_Add :: (v1: *Vec3, v2: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Vec3_Add";
Vec3_Subtract :: (v1: *Vec3, v2: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Vec3_Subtract";
Vec3_Multiply :: (v1: *Vec3, v2: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Vec3_Multiply";
Vec3_MultiplyScalar :: (v: *Vec3, scalar: float, result: *Vec3) -> void #foreign JoltC "JPH_Vec3_MultiplyScalar";
Vec3_MultiplyMatrix :: (left: *Mat4, right: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Vec3_MultiplyMatrix";

Vec3_Divide :: (v1: *Vec3, v2: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Vec3_Divide";
Vec3_DivideScalar :: (v: *Vec3, scalar: float, result: *Vec3) -> void #foreign JoltC "JPH_Vec3_DivideScalar";

Mat4_Add :: (m1: *Mat4, m2: *Mat4, result: *Mat4) -> void #foreign JoltC "JPH_Mat4_Add";
Mat4_Subtract :: (m1: *Mat4, m2: *Mat4, result: *Mat4) -> void #foreign JoltC "JPH_Mat4_Subtract";
Mat4_Multiply :: (m1: *Mat4, m2: *Mat4, result: *Mat4) -> void #foreign JoltC "JPH_Mat4_Multiply";
Mat4_MultiplyScalar :: (m: *Mat4, scalar: float, result: *Mat4) -> void #foreign JoltC "JPH_Mat4_MultiplyScalar";

Mat4_Zero :: (result: *Mat4) -> void #foreign JoltC "JPH_Mat4_Zero";
Mat4_Identity :: (result: *Mat4) -> void #foreign JoltC "JPH_Mat4_Identity";
Mat4_Rotation :: (result: *Mat4, rotation: *Quat) -> void #foreign JoltC "JPH_Mat4_Rotation";
Mat4_Rotation2 :: (result: *Mat4, axis: *Vec3, angle: float) -> void #foreign JoltC "JPH_Mat4_Rotation2";
Mat4_Translation :: (result: *Mat4, translation: *Vec3) -> void #foreign JoltC "JPH_Mat4_Translation";
Mat4_RotationTranslation :: (result: *Mat4, rotation: *Quat, translation: *Vec3) -> void #foreign JoltC "JPH_Mat4_RotationTranslation";
Mat4_InverseRotationTranslation :: (result: *Mat4, rotation: *Quat, translation: *Vec3) -> void #foreign JoltC "JPH_Mat4_InverseRotationTranslation";
Mat4_Scale :: (result: *Mat4, scale: *Vec3) -> void #foreign JoltC "JPH_Mat4_Scale";
Mat4_Transposed :: (m: *Mat4, result: *Mat4) -> void #foreign JoltC "JPH_Mat4_Transposed";
Mat4_Inversed :: (matrix: *Mat4, result: *Mat4) -> void #foreign JoltC "JPH_Mat4_Inversed";

Mat4_GetAxisX :: (matrix: *Mat4, result: *Vec3) -> void #foreign JoltC "JPH_Mat4_GetAxisX";
Mat4_GetAxisY :: (matrix: *Mat4, result: *Vec3) -> void #foreign JoltC "JPH_Mat4_GetAxisY";
Mat4_GetAxisZ :: (matrix: *Mat4, result: *Vec3) -> void #foreign JoltC "JPH_Mat4_GetAxisZ";
Mat4_GetTranslation :: (matrix: *Mat4, result: *Vec3) -> void #foreign JoltC "JPH_Mat4_GetTranslation";
Mat4_GetQuaternion :: (matrix: *Mat4, result: *Quat) -> void #foreign JoltC "JPH_Mat4_GetQuaternion";

/* Material */
PhysicsMaterial_Create :: (name: *u8, color: u32) -> *PhysicsMaterial #foreign JoltC "JPH_PhysicsMaterial_Create";
PhysicsMaterial_Destroy :: (material: *PhysicsMaterial) -> void #foreign JoltC "JPH_PhysicsMaterial_Destroy";
PhysicsMaterial_GetDebugName :: (material: *PhysicsMaterial) -> *u8 #foreign JoltC "JPH_PhysicsMaterial_GetDebugName";
PhysicsMaterial_GetDebugColor :: (material: *PhysicsMaterial) -> u32 #foreign JoltC "JPH_PhysicsMaterial_GetDebugColor";

/* GroupFilter/GroupFilterTable */
GroupFilter_Destroy :: (groupFilter: *GroupFilter) -> void #foreign JoltC "JPH_GroupFilter_Destroy";
GroupFilter_CanCollide :: (groupFilter: *GroupFilter, group1: *CollisionGroup, group2: *CollisionGroup) -> bool #foreign JoltC "JPH_GroupFilter_CanCollide";

GroupFilterTable_Create :: (numSubGroups: u32) -> *GroupFilterTable #foreign JoltC "JPH_GroupFilterTable_Create";
GroupFilterTable_DisableCollision :: (table: *GroupFilterTable, subGroup1: CollisionSubGroupID, subGroup2: CollisionSubGroupID) -> void #foreign JoltC "JPH_GroupFilterTable_DisableCollision";
GroupFilterTable_EnableCollision :: (table: *GroupFilterTable, subGroup1: CollisionSubGroupID, subGroup2: CollisionSubGroupID) -> void #foreign JoltC "JPH_GroupFilterTable_EnableCollision";
GroupFilterTable_IsCollisionEnabled :: (table: *GroupFilterTable, subGroup1: CollisionSubGroupID, subGroup2: CollisionSubGroupID) -> bool #foreign JoltC "JPH_GroupFilterTable_IsCollisionEnabled";

/* ShapeSettings */
ShapeSettings_Destroy :: (settings: *ShapeSettings) -> void #foreign JoltC "JPH_ShapeSettings_Destroy";
ShapeSettings_GetUserData :: (settings: *ShapeSettings) -> u64 #foreign JoltC "JPH_ShapeSettings_GetUserData";
ShapeSettings_SetUserData :: (settings: *ShapeSettings, userData: u64) -> void #foreign JoltC "JPH_ShapeSettings_SetUserData";

/* Shape */
Shape_Destroy :: (shape: *Shape) -> void #foreign JoltC "JPH_Shape_Destroy";
Shape_GetType :: (shape: *Shape) -> ShapeType #foreign JoltC "JPH_Shape_GetType";
Shape_GetSubType :: (shape: *Shape) -> ShapeSubType #foreign JoltC "JPH_Shape_GetSubType";
Shape_GetUserData :: (shape: *Shape) -> u64 #foreign JoltC "JPH_Shape_GetUserData";
Shape_SetUserData :: (shape: *Shape, userData: u64) -> void #foreign JoltC "JPH_Shape_SetUserData";
Shape_MustBeStatic :: (shape: *Shape) -> bool #foreign JoltC "JPH_Shape_MustBeStatic";
Shape_GetCenterOfMass :: (shape: *Shape, result: *Vec3) -> void #foreign JoltC "JPH_Shape_GetCenterOfMass";
Shape_GetLocalBounds :: (shape: *Shape, result: *AABox) -> void #foreign JoltC "JPH_Shape_GetLocalBounds";
Shape_GetSubShapeIDBitsRecursive :: (shape: *Shape) -> u32 #foreign JoltC "JPH_Shape_GetSubShapeIDBitsRecursive";
Shape_GetWorldSpaceBounds :: (shape: *Shape, centerOfMassTransform: *RMat4, scale: *Vec3, result: *AABox) -> void #foreign JoltC "JPH_Shape_GetWorldSpaceBounds";
Shape_GetInnerRadius :: (shape: *Shape) -> float #foreign JoltC "JPH_Shape_GetInnerRadius";
Shape_GetMassProperties :: (shape: *Shape, result: *MassProperties) -> void #foreign JoltC "JPH_Shape_GetMassProperties";
Shape_GetLeafShape :: (shape: *Shape, subShapeID: SubShapeID, remainder: *SubShapeID) -> *Shape #foreign JoltC "JPH_Shape_GetLeafShape";
Shape_GetMaterial :: (shape: *Shape, subShapeID: SubShapeID) -> *PhysicsMaterial #foreign JoltC "JPH_Shape_GetMaterial";
Shape_GetSurfaceNormal :: (shape: *Shape, subShapeID: SubShapeID, localPosition: *Vec3, normal: *Vec3) -> void #foreign JoltC "JPH_Shape_GetSurfaceNormal";
Shape_GetSupportingFace :: (shape: *Shape, subShapeID: SubShapeID, direction: *Vec3, scale: *Vec3, centerOfMassTransform: *Mat4, outVertices: *SupportingFace) -> void #foreign JoltC "JPH_Shape_GetSupportingFace";
Shape_GetVolume :: (shape: *Shape) -> float #foreign JoltC "JPH_Shape_GetVolume";
Shape_IsValidScale :: (shape: *Shape, scale: *Vec3) -> bool #foreign JoltC "JPH_Shape_IsValidScale";
Shape_MakeScaleValid :: (shape: *Shape, scale: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_Shape_MakeScaleValid";
Shape_ScaleShape :: (shape: *Shape, scale: *Vec3) -> *Shape #foreign JoltC "JPH_Shape_ScaleShape";
Shape_CastRay :: (shape: *Shape, origin: *Vec3, direction: *Vec3, hit: *RayCastResult) -> bool #foreign JoltC "JPH_Shape_CastRay";
Shape_CastRay2 :: (shape: *Shape, origin: *Vec3, direction: *Vec3, rayCastSettings: *RayCastSettings, collectorType: CollisionCollectorType, callback: CastRayResultCallback, userData: *void, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_Shape_CastRay2";
Shape_CollidePoint :: (shape: *Shape, point: *Vec3, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_Shape_CollidePoint";
Shape_CollidePoint2 :: (shape: *Shape, point: *Vec3, collectorType: CollisionCollectorType, callback: CollidePointResultCallback, userData: *void, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_Shape_CollidePoint2";

/* JPH_ConvexShape */
ConvexShapeSettings_GetDensity :: (shape: *ConvexShapeSettings) -> float #foreign JoltC "JPH_ConvexShapeSettings_GetDensity";
ConvexShapeSettings_SetDensity :: (shape: *ConvexShapeSettings, value: float) -> void #foreign JoltC "JPH_ConvexShapeSettings_SetDensity";
ConvexShape_GetDensity :: (shape: *ConvexShape) -> float #foreign JoltC "JPH_ConvexShape_GetDensity";
ConvexShape_SetDensity :: (shape: *ConvexShape, inDensity: float) -> void #foreign JoltC "JPH_ConvexShape_SetDensity";

/* BoxShape */
BoxShapeSettings_Create :: (halfExtent: *Vec3, convexRadius: float) -> *BoxShapeSettings #foreign JoltC "JPH_BoxShapeSettings_Create";
BoxShapeSettings_CreateShape :: (settings: *BoxShapeSettings) -> *BoxShape #foreign JoltC "JPH_BoxShapeSettings_CreateShape";

BoxShape_Create :: (halfExtent: *Vec3, convexRadius: float) -> *BoxShape #foreign JoltC "JPH_BoxShape_Create";
BoxShape_GetHalfExtent :: (shape: *BoxShape, halfExtent: *Vec3) -> void #foreign JoltC "JPH_BoxShape_GetHalfExtent";
BoxShape_GetConvexRadius :: (shape: *BoxShape) -> float #foreign JoltC "JPH_BoxShape_GetConvexRadius";

/* SphereShape */
SphereShapeSettings_Create :: (radius: float) -> *SphereShapeSettings #foreign JoltC "JPH_SphereShapeSettings_Create";
SphereShapeSettings_CreateShape :: (settings: *SphereShapeSettings) -> *SphereShape #foreign JoltC "JPH_SphereShapeSettings_CreateShape";

SphereShapeSettings_GetRadius :: (settings: *SphereShapeSettings) -> float #foreign JoltC "JPH_SphereShapeSettings_GetRadius";
SphereShapeSettings_SetRadius :: (settings: *SphereShapeSettings, radius: float) -> void #foreign JoltC "JPH_SphereShapeSettings_SetRadius";
SphereShape_Create :: (radius: float) -> *SphereShape #foreign JoltC "JPH_SphereShape_Create";
SphereShape_GetRadius :: (shape: *SphereShape) -> float #foreign JoltC "JPH_SphereShape_GetRadius";

/* PlaneShape */
PlaneShapeSettings_Create :: (plane: *Plane, material: *PhysicsMaterial, halfExtent: float) -> *PlaneShapeSettings #foreign JoltC "JPH_PlaneShapeSettings_Create";
PlaneShapeSettings_CreateShape :: (settings: *PlaneShapeSettings) -> *PlaneShape #foreign JoltC "JPH_PlaneShapeSettings_CreateShape";
PlaneShape_Create :: (plane: *Plane, material: *PhysicsMaterial, halfExtent: float) -> *PlaneShape #foreign JoltC "JPH_PlaneShape_Create";
PlaneShape_GetPlane :: (shape: *PlaneShape, result: *Plane) -> void #foreign JoltC "JPH_PlaneShape_GetPlane";
PlaneShape_GetHalfExtent :: (shape: *PlaneShape) -> float #foreign JoltC "JPH_PlaneShape_GetHalfExtent";

/* TriangleShape */
TriangleShapeSettings_Create :: (v1: *Vec3, v2: *Vec3, v3: *Vec3, convexRadius: float) -> *TriangleShapeSettings #foreign JoltC "JPH_TriangleShapeSettings_Create";
TriangleShapeSettings_CreateShape :: (settings: *TriangleShapeSettings) -> *TriangleShape #foreign JoltC "JPH_TriangleShapeSettings_CreateShape";

TriangleShape_Create :: (v1: *Vec3, v2: *Vec3, v3: *Vec3, convexRadius: float) -> *TriangleShape #foreign JoltC "JPH_TriangleShape_Create";
TriangleShape_GetConvexRadius :: (shape: *TriangleShape) -> float #foreign JoltC "JPH_TriangleShape_GetConvexRadius";
TriangleShape_GetVertex1 :: (shape: *TriangleShape, result: *Vec3) -> void #foreign JoltC "JPH_TriangleShape_GetVertex1";
TriangleShape_GetVertex2 :: (shape: *TriangleShape, result: *Vec3) -> void #foreign JoltC "JPH_TriangleShape_GetVertex2";
TriangleShape_GetVertex3 :: (shape: *TriangleShape, result: *Vec3) -> void #foreign JoltC "JPH_TriangleShape_GetVertex3";

/* CapsuleShape */
CapsuleShapeSettings_Create :: (halfHeightOfCylinder: float, radius: float) -> *CapsuleShapeSettings #foreign JoltC "JPH_CapsuleShapeSettings_Create";
CapsuleShapeSettings_CreateShape :: (settings: *CapsuleShapeSettings) -> *CapsuleShape #foreign JoltC "JPH_CapsuleShapeSettings_CreateShape";
CapsuleShape_Create :: (halfHeightOfCylinder: float, radius: float) -> *CapsuleShape #foreign JoltC "JPH_CapsuleShape_Create";
CapsuleShape_GetRadius :: (shape: *CapsuleShape) -> float #foreign JoltC "JPH_CapsuleShape_GetRadius";
CapsuleShape_GetHalfHeightOfCylinder :: (shape: *CapsuleShape) -> float #foreign JoltC "JPH_CapsuleShape_GetHalfHeightOfCylinder";

/* CylinderShape */
CylinderShapeSettings_Create :: (halfHeight: float, radius: float, convexRadius: float) -> *CylinderShapeSettings #foreign JoltC "JPH_CylinderShapeSettings_Create";
CylinderShapeSettings_CreateShape :: (settings: *CylinderShapeSettings) -> *CylinderShape #foreign JoltC "JPH_CylinderShapeSettings_CreateShape";

CylinderShape_Create :: (halfHeight: float, radius: float) -> *CylinderShape #foreign JoltC "JPH_CylinderShape_Create";
CylinderShape_GetRadius :: (shape: *CylinderShape) -> float #foreign JoltC "JPH_CylinderShape_GetRadius";
CylinderShape_GetHalfHeight :: (shape: *CylinderShape) -> float #foreign JoltC "JPH_CylinderShape_GetHalfHeight";

/* TaperedCylinderShape */
TaperedCylinderShapeSettings_Create :: (halfHeightOfTaperedCylinder: float, topRadius: float, bottomRadius: float, convexRadius: float, material: *PhysicsMaterial) -> *TaperedCylinderShapeSettings #foreign JoltC "JPH_TaperedCylinderShapeSettings_Create";
TaperedCylinderShapeSettings_CreateShape :: (settings: *TaperedCylinderShapeSettings) -> *TaperedCylinderShape #foreign JoltC "JPH_TaperedCylinderShapeSettings_CreateShape";
TaperedCylinderShape_GetTopRadius :: (shape: *TaperedCylinderShape) -> float #foreign JoltC "JPH_TaperedCylinderShape_GetTopRadius";
TaperedCylinderShape_GetBottomRadius :: (shape: *TaperedCylinderShape) -> float #foreign JoltC "JPH_TaperedCylinderShape_GetBottomRadius";
TaperedCylinderShape_GetConvexRadius :: (shape: *TaperedCylinderShape) -> float #foreign JoltC "JPH_TaperedCylinderShape_GetConvexRadius";
TaperedCylinderShape_GetHalfHeight :: (shape: *TaperedCylinderShape) -> float #foreign JoltC "JPH_TaperedCylinderShape_GetHalfHeight";

/* ConvexHullShape */
ConvexHullShapeSettings_Create :: (points: *Vec3, pointsCount: u32, maxConvexRadius: float) -> *ConvexHullShapeSettings #foreign JoltC "JPH_ConvexHullShapeSettings_Create";
ConvexHullShapeSettings_CreateShape :: (settings: *ConvexHullShapeSettings) -> *ConvexHullShape #foreign JoltC "JPH_ConvexHullShapeSettings_CreateShape";
ConvexHullShape_GetNumPoints :: (shape: *ConvexHullShape) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetNumPoints";
ConvexHullShape_GetPoint :: (shape: *ConvexHullShape, index: u32, result: *Vec3) -> void #foreign JoltC "JPH_ConvexHullShape_GetPoint";
ConvexHullShape_GetNumFaces :: (shape: *ConvexHullShape) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetNumFaces";
ConvexHullShape_GetNumVerticesInFace :: (shape: *ConvexHullShape, faceIndex: u32) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetNumVerticesInFace";
ConvexHullShape_GetFaceVertices :: (shape: *ConvexHullShape, faceIndex: u32, maxVertices: u32, vertices: *u32) -> u32 #foreign JoltC "JPH_ConvexHullShape_GetFaceVertices";

/* MeshShape */
MeshShapeSettings_Create :: (triangles: *Triangle, triangleCount: u32) -> *MeshShapeSettings #foreign JoltC "JPH_MeshShapeSettings_Create";
MeshShapeSettings_Create2 :: (vertices: *Vec3, verticesCount: u32, triangles: *IndexedTriangle, triangleCount: u32) -> *MeshShapeSettings #foreign JoltC "JPH_MeshShapeSettings_Create2";
MeshShapeSettings_GetMaxTrianglesPerLeaf :: (settings: *MeshShapeSettings) -> u32 #foreign JoltC "JPH_MeshShapeSettings_GetMaxTrianglesPerLeaf";
MeshShapeSettings_SetMaxTrianglesPerLeaf :: (settings: *MeshShapeSettings, value: u32) -> void #foreign JoltC "JPH_MeshShapeSettings_SetMaxTrianglesPerLeaf";
MeshShapeSettings_GetActiveEdgeCosThresholdAngle :: (settings: *MeshShapeSettings) -> float #foreign JoltC "JPH_MeshShapeSettings_GetActiveEdgeCosThresholdAngle";
MeshShapeSettings_SetActiveEdgeCosThresholdAngle :: (settings: *MeshShapeSettings, value: float) -> void #foreign JoltC "JPH_MeshShapeSettings_SetActiveEdgeCosThresholdAngle";
MeshShapeSettings_GetPerTriangleUserData :: (settings: *MeshShapeSettings) -> bool #foreign JoltC "JPH_MeshShapeSettings_GetPerTriangleUserData";
MeshShapeSettings_SetPerTriangleUserData :: (settings: *MeshShapeSettings, value: bool) -> void #foreign JoltC "JPH_MeshShapeSettings_SetPerTriangleUserData";
MeshShapeSettings_GetBuildQuality :: (settings: *MeshShapeSettings) -> Mesh_Shape_BuildQuality #foreign JoltC "JPH_MeshShapeSettings_GetBuildQuality";
MeshShapeSettings_SetBuildQuality :: (settings: *MeshShapeSettings, value: Mesh_Shape_BuildQuality) -> void #foreign JoltC "JPH_MeshShapeSettings_SetBuildQuality";

MeshShapeSettings_Sanitize :: (settings: *MeshShapeSettings) -> void #foreign JoltC "JPH_MeshShapeSettings_Sanitize";
MeshShapeSettings_CreateShape :: (settings: *MeshShapeSettings) -> *MeshShape #foreign JoltC "JPH_MeshShapeSettings_CreateShape";
MeshShape_GetTriangleUserData :: (shape: *MeshShape, id: SubShapeID) -> u32 #foreign JoltC "JPH_MeshShape_GetTriangleUserData";

/* HeightFieldShape */
HeightFieldShapeSettings_Create :: (samples: *float, offset: *Vec3, scale: *Vec3, sampleCount: u32, materialIndices: *u8) -> *HeightFieldShapeSettings #foreign JoltC "JPH_HeightFieldShapeSettings_Create";
HeightFieldShapeSettings_DetermineMinAndMaxSample :: (settings: *HeightFieldShapeSettings, pOutMinValue: *float, pOutMaxValue: *float, pOutQuantizationScale: *float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_DetermineMinAndMaxSample";
HeightFieldShapeSettings_CalculateBitsPerSampleForError :: (settings: *HeightFieldShapeSettings, maxError: float) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_CalculateBitsPerSampleForError";
HeightFieldShapeSettings_GetOffset :: (shape: *HeightFieldShapeSettings, result: *Vec3) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_GetOffset";
HeightFieldShapeSettings_SetOffset :: (settings: *HeightFieldShapeSettings, value: *Vec3) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetOffset";
HeightFieldShapeSettings_GetScale :: (shape: *HeightFieldShapeSettings, result: *Vec3) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_GetScale";
HeightFieldShapeSettings_SetScale :: (settings: *HeightFieldShapeSettings, value: *Vec3) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetScale";
HeightFieldShapeSettings_GetSampleCount :: (settings: *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetSampleCount";
HeightFieldShapeSettings_SetSampleCount :: (settings: *HeightFieldShapeSettings, value: u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetSampleCount";
HeightFieldShapeSettings_GetMinHeightValue :: (settings: *HeightFieldShapeSettings) -> float #foreign JoltC "JPH_HeightFieldShapeSettings_GetMinHeightValue";
HeightFieldShapeSettings_SetMinHeightValue :: (settings: *HeightFieldShapeSettings, value: float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetMinHeightValue";
HeightFieldShapeSettings_GetMaxHeightValue :: (settings: *HeightFieldShapeSettings) -> float #foreign JoltC "JPH_HeightFieldShapeSettings_GetMaxHeightValue";
HeightFieldShapeSettings_SetMaxHeightValue :: (settings: *HeightFieldShapeSettings, value: float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetMaxHeightValue";
HeightFieldShapeSettings_GetBlockSize :: (settings: *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetBlockSize";
HeightFieldShapeSettings_SetBlockSize :: (settings: *HeightFieldShapeSettings, value: u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetBlockSize";
HeightFieldShapeSettings_GetBitsPerSample :: (settings: *HeightFieldShapeSettings) -> u32 #foreign JoltC "JPH_HeightFieldShapeSettings_GetBitsPerSample";
HeightFieldShapeSettings_SetBitsPerSample :: (settings: *HeightFieldShapeSettings, value: u32) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetBitsPerSample";
HeightFieldShapeSettings_GetActiveEdgeCosThresholdAngle :: (settings: *HeightFieldShapeSettings) -> float #foreign JoltC "JPH_HeightFieldShapeSettings_GetActiveEdgeCosThresholdAngle";
HeightFieldShapeSettings_SetActiveEdgeCosThresholdAngle :: (settings: *HeightFieldShapeSettings, value: float) -> void #foreign JoltC "JPH_HeightFieldShapeSettings_SetActiveEdgeCosThresholdAngle";
HeightFieldShapeSettings_CreateShape :: (settings: *HeightFieldShapeSettings) -> *HeightFieldShape #foreign JoltC "JPH_HeightFieldShapeSettings_CreateShape";

HeightFieldShape_GetSampleCount :: (shape: *HeightFieldShape) -> u32 #foreign JoltC "JPH_HeightFieldShape_GetSampleCount";
HeightFieldShape_GetBlockSize :: (shape: *HeightFieldShape) -> u32 #foreign JoltC "JPH_HeightFieldShape_GetBlockSize";
HeightFieldShape_GetMaterial :: (shape: *HeightFieldShape, x: u32, y: u32) -> *PhysicsMaterial #foreign JoltC "JPH_HeightFieldShape_GetMaterial";
HeightFieldShape_GetPosition :: (shape: *HeightFieldShape, x: u32, y: u32, result: *Vec3) -> void #foreign JoltC "JPH_HeightFieldShape_GetPosition";
HeightFieldShape_IsNoCollision :: (shape: *HeightFieldShape, x: u32, y: u32) -> bool #foreign JoltC "JPH_HeightFieldShape_IsNoCollision";
HeightFieldShape_ProjectOntoSurface :: (shape: *HeightFieldShape, localPosition: *Vec3, outSurfacePosition: *Vec3, outSubShapeID: *SubShapeID) -> bool #foreign JoltC "JPH_HeightFieldShape_ProjectOntoSurface";
HeightFieldShape_GetMinHeightValue :: (shape: *HeightFieldShape) -> float #foreign JoltC "JPH_HeightFieldShape_GetMinHeightValue";
HeightFieldShape_GetMaxHeightValue :: (shape: *HeightFieldShape) -> float #foreign JoltC "JPH_HeightFieldShape_GetMaxHeightValue";

/* TaperedCapsuleShape */
TaperedCapsuleShapeSettings_Create :: (halfHeightOfTaperedCylinder: float, topRadius: float, bottomRadius: float) -> *TaperedCapsuleShapeSettings #foreign JoltC "JPH_TaperedCapsuleShapeSettings_Create";
TaperedCapsuleShapeSettings_CreateShape :: (settings: *TaperedCapsuleShapeSettings) -> *TaperedCapsuleShape #foreign JoltC "JPH_TaperedCapsuleShapeSettings_CreateShape";

TaperedCapsuleShape_GetTopRadius :: (shape: *TaperedCapsuleShape) -> float #foreign JoltC "JPH_TaperedCapsuleShape_GetTopRadius";
TaperedCapsuleShape_GetBottomRadius :: (shape: *TaperedCapsuleShape) -> float #foreign JoltC "JPH_TaperedCapsuleShape_GetBottomRadius";
TaperedCapsuleShape_GetHalfHeight :: (shape: *TaperedCapsuleShape) -> float #foreign JoltC "JPH_TaperedCapsuleShape_GetHalfHeight";

/* CompoundShape */
CompoundShapeSettings_AddShape :: (settings: *CompoundShapeSettings, position: *Vec3, rotation: *Quat, shapeSettings: *ShapeSettings, userData: u32) -> void #foreign JoltC "JPH_CompoundShapeSettings_AddShape";
CompoundShapeSettings_AddShape2 :: (settings: *CompoundShapeSettings, position: *Vec3, rotation: *Quat, shape: *Shape, userData: u32) -> void #foreign JoltC "JPH_CompoundShapeSettings_AddShape2";
CompoundShape_GetNumSubShapes :: (shape: *CompoundShape) -> u32 #foreign JoltC "JPH_CompoundShape_GetNumSubShapes";
CompoundShape_GetSubShape :: (shape: *CompoundShape, index: u32, subShape: **Shape, positionCOM: *Vec3, rotation: *Quat, userData: *u32) -> void #foreign JoltC "JPH_CompoundShape_GetSubShape";
CompoundShape_GetSubShapeIndexFromID :: (shape: *CompoundShape, id: SubShapeID, remainder: *SubShapeID) -> u32 #foreign JoltC "JPH_CompoundShape_GetSubShapeIndexFromID";

/* StaticCompoundShape */
StaticCompoundShapeSettings_Create :: () -> *StaticCompoundShapeSettings #foreign JoltC "JPH_StaticCompoundShapeSettings_Create";
StaticCompoundShape_Create :: (settings: *StaticCompoundShapeSettings) -> *StaticCompoundShape #foreign JoltC "JPH_StaticCompoundShape_Create";

/* MutableCompoundShape */
MutableCompoundShapeSettings_Create :: () -> *MutableCompoundShapeSettings #foreign JoltC "JPH_MutableCompoundShapeSettings_Create";
MutableCompoundShape_Create :: (settings: *MutableCompoundShapeSettings) -> *MutableCompoundShape #foreign JoltC "JPH_MutableCompoundShape_Create";

MutableCompoundShape_AddShape :: (shape: *MutableCompoundShape, position: *Vec3, rotation: *Quat, child: *Shape, userData: u32, index: u32) -> u32 #foreign JoltC "JPH_MutableCompoundShape_AddShape";
MutableCompoundShape_RemoveShape :: (shape: *MutableCompoundShape, index: u32) -> void #foreign JoltC "JPH_MutableCompoundShape_RemoveShape";
MutableCompoundShape_ModifyShape :: (shape: *MutableCompoundShape, index: u32, position: *Vec3, rotation: *Quat) -> void #foreign JoltC "JPH_MutableCompoundShape_ModifyShape";
MutableCompoundShape_ModifyShape2 :: (shape: *MutableCompoundShape, index: u32, position: *Vec3, rotation: *Quat, newShape: *Shape) -> void #foreign JoltC "JPH_MutableCompoundShape_ModifyShape2";
MutableCompoundShape_AdjustCenterOfMass :: (shape: *MutableCompoundShape) -> void #foreign JoltC "JPH_MutableCompoundShape_AdjustCenterOfMass";

/* DecoratedShape */
DecoratedShape_GetInnerShape :: (shape: *DecoratedShape) -> *Shape #foreign JoltC "JPH_DecoratedShape_GetInnerShape";

/* RotatedTranslatedShape */
RotatedTranslatedShapeSettings_Create :: (position: *Vec3, rotation: *Quat, shapeSettings: *ShapeSettings) -> *RotatedTranslatedShapeSettings #foreign JoltC "JPH_RotatedTranslatedShapeSettings_Create";
RotatedTranslatedShapeSettings_Create2 :: (position: *Vec3, rotation: *Quat, shape: *Shape) -> *RotatedTranslatedShapeSettings #foreign JoltC "JPH_RotatedTranslatedShapeSettings_Create2";
RotatedTranslatedShapeSettings_CreateShape :: (settings: *RotatedTranslatedShapeSettings) -> *RotatedTranslatedShape #foreign JoltC "JPH_RotatedTranslatedShapeSettings_CreateShape";
RotatedTranslatedShape_Create :: (position: *Vec3, rotation: *Quat, shape: *Shape) -> *RotatedTranslatedShape #foreign JoltC "JPH_RotatedTranslatedShape_Create";
RotatedTranslatedShape_GetPosition :: (shape: *RotatedTranslatedShape, position: *Vec3) -> void #foreign JoltC "JPH_RotatedTranslatedShape_GetPosition";
RotatedTranslatedShape_GetRotation :: (shape: *RotatedTranslatedShape, rotation: *Quat) -> void #foreign JoltC "JPH_RotatedTranslatedShape_GetRotation";

/* ScaledShape */
ScaledShapeSettings_Create :: (shapeSettings: *ShapeSettings, scale: *Vec3) -> *ScaledShapeSettings #foreign JoltC "JPH_ScaledShapeSettings_Create";
ScaledShapeSettings_Create2 :: (shape: *Shape, scale: *Vec3) -> *ScaledShapeSettings #foreign JoltC "JPH_ScaledShapeSettings_Create2";
ScaledShapeSettings_CreateShape :: (settings: *ScaledShapeSettings) -> *ScaledShape #foreign JoltC "JPH_ScaledShapeSettings_CreateShape";
ScaledShape_Create :: (shape: *Shape, scale: *Vec3) -> *ScaledShape #foreign JoltC "JPH_ScaledShape_Create";
ScaledShape_GetScale :: (shape: *ScaledShape, result: *Vec3) -> void #foreign JoltC "JPH_ScaledShape_GetScale";

/* OffsetCenterOfMassShape */
OffsetCenterOfMassShapeSettings_Create :: (offset: *Vec3, shapeSettings: *ShapeSettings) -> *OffsetCenterOfMassShapeSettings #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_Create";
OffsetCenterOfMassShapeSettings_Create2 :: (offset: *Vec3, shape: *Shape) -> *OffsetCenterOfMassShapeSettings #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_Create2";
OffsetCenterOfMassShapeSettings_CreateShape :: (settings: *OffsetCenterOfMassShapeSettings) -> *OffsetCenterOfMassShape #foreign JoltC "JPH_OffsetCenterOfMassShapeSettings_CreateShape";

OffsetCenterOfMassShape_Create :: (offset: *Vec3, shape: *Shape) -> *OffsetCenterOfMassShape #foreign JoltC "JPH_OffsetCenterOfMassShape_Create";
OffsetCenterOfMassShape_GetOffset :: (shape: *OffsetCenterOfMassShape, result: *Vec3) -> void #foreign JoltC "JPH_OffsetCenterOfMassShape_GetOffset";

/* EmptyShape */
EmptyShapeSettings_Create :: (centerOfMass: *Vec3) -> *EmptyShapeSettings #foreign JoltC "JPH_EmptyShapeSettings_Create";
EmptyShapeSettings_CreateShape :: (settings: *EmptyShapeSettings) -> *EmptyShape #foreign JoltC "JPH_EmptyShapeSettings_CreateShape";

/* JPH_BodyCreationSettings */
BodyCreationSettings_Create :: () -> *BodyCreationSettings #foreign JoltC "JPH_BodyCreationSettings_Create";
BodyCreationSettings_Create2 :: (settings: *ShapeSettings, position: *RVec3, rotation: *Quat, motionType: MotionType, objectLayer: ObjectLayer) -> *BodyCreationSettings #foreign JoltC "JPH_BodyCreationSettings_Create2";

BodyCreationSettings_Create3 :: (shape: *Shape, position: *RVec3, rotation: *Quat, motionType: MotionType, objectLayer: ObjectLayer) -> *BodyCreationSettings #foreign JoltC "JPH_BodyCreationSettings_Create3";

BodyCreationSettings_Destroy :: (settings: *BodyCreationSettings) -> void #foreign JoltC "JPH_BodyCreationSettings_Destroy";

BodyCreationSettings_GetPosition :: (settings: *BodyCreationSettings, result: *RVec3) -> void #foreign JoltC "JPH_BodyCreationSettings_GetPosition";
BodyCreationSettings_SetPosition :: (settings: *BodyCreationSettings, value: *RVec3) -> void #foreign JoltC "JPH_BodyCreationSettings_SetPosition";

BodyCreationSettings_GetRotation :: (settings: *BodyCreationSettings, result: *Quat) -> void #foreign JoltC "JPH_BodyCreationSettings_GetRotation";
BodyCreationSettings_SetRotation :: (settings: *BodyCreationSettings, value: *Quat) -> void #foreign JoltC "JPH_BodyCreationSettings_SetRotation";

BodyCreationSettings_GetLinearVelocity :: (settings: *BodyCreationSettings, velocity: *Vec3) -> void #foreign JoltC "JPH_BodyCreationSettings_GetLinearVelocity";
BodyCreationSettings_SetLinearVelocity :: (settings: *BodyCreationSettings, velocity: *Vec3) -> void #foreign JoltC "JPH_BodyCreationSettings_SetLinearVelocity";

BodyCreationSettings_GetAngularVelocity :: (settings: *BodyCreationSettings, velocity: *Vec3) -> void #foreign JoltC "JPH_BodyCreationSettings_GetAngularVelocity";
BodyCreationSettings_SetAngularVelocity :: (settings: *BodyCreationSettings, velocity: *Vec3) -> void #foreign JoltC "JPH_BodyCreationSettings_SetAngularVelocity";

BodyCreationSettings_GetUserData :: (settings: *BodyCreationSettings) -> u64 #foreign JoltC "JPH_BodyCreationSettings_GetUserData";
BodyCreationSettings_SetUserData :: (settings: *BodyCreationSettings, value: u64) -> void #foreign JoltC "JPH_BodyCreationSettings_SetUserData";

BodyCreationSettings_GetObjectLayer :: (settings: *BodyCreationSettings) -> ObjectLayer #foreign JoltC "JPH_BodyCreationSettings_GetObjectLayer";
BodyCreationSettings_SetObjectLayer :: (settings: *BodyCreationSettings, value: ObjectLayer) -> void #foreign JoltC "JPH_BodyCreationSettings_SetObjectLayer";

BodyCreationSettings_GetCollisionGroup :: (settings: *BodyCreationSettings, result: *CollisionGroup) -> void #foreign JoltC "JPH_BodyCreationSettings_GetCollisionGroup";
BodyCreationSettings_SetCollisionGroup :: (settings: *BodyCreationSettings, value: *CollisionGroup) -> void #foreign JoltC "JPH_BodyCreationSettings_SetCollisionGroup";

BodyCreationSettings_GetMotionType :: (settings: *BodyCreationSettings) -> MotionType #foreign JoltC "JPH_BodyCreationSettings_GetMotionType";
BodyCreationSettings_SetMotionType :: (settings: *BodyCreationSettings, value: MotionType) -> void #foreign JoltC "JPH_BodyCreationSettings_SetMotionType";

BodyCreationSettings_GetAllowedDOFs :: (settings: *BodyCreationSettings) -> AllowedDOFs #foreign JoltC "JPH_BodyCreationSettings_GetAllowedDOFs";
BodyCreationSettings_SetAllowedDOFs :: (settings: *BodyCreationSettings, value: AllowedDOFs) -> void #foreign JoltC "JPH_BodyCreationSettings_SetAllowedDOFs";

BodyCreationSettings_GetAllowDynamicOrKinematic :: (settings: *BodyCreationSettings) -> bool #foreign JoltC "JPH_BodyCreationSettings_GetAllowDynamicOrKinematic";
BodyCreationSettings_SetAllowDynamicOrKinematic :: (settings: *BodyCreationSettings, value: bool) -> void #foreign JoltC "JPH_BodyCreationSettings_SetAllowDynamicOrKinematic";

BodyCreationSettings_GetIsSensor :: (settings: *BodyCreationSettings) -> bool #foreign JoltC "JPH_BodyCreationSettings_GetIsSensor";
BodyCreationSettings_SetIsSensor :: (settings: *BodyCreationSettings, value: bool) -> void #foreign JoltC "JPH_BodyCreationSettings_SetIsSensor";

BodyCreationSettings_GetCollideKinematicVsNonDynamic :: (settings: *BodyCreationSettings) -> bool #foreign JoltC "JPH_BodyCreationSettings_GetCollideKinematicVsNonDynamic";
BodyCreationSettings_SetCollideKinematicVsNonDynamic :: (settings: *BodyCreationSettings, value: bool) -> void #foreign JoltC "JPH_BodyCreationSettings_SetCollideKinematicVsNonDynamic";

BodyCreationSettings_GetUseManifoldReduction :: (settings: *BodyCreationSettings) -> bool #foreign JoltC "JPH_BodyCreationSettings_GetUseManifoldReduction";
BodyCreationSettings_SetUseManifoldReduction :: (settings: *BodyCreationSettings, value: bool) -> void #foreign JoltC "JPH_BodyCreationSettings_SetUseManifoldReduction";

BodyCreationSettings_GetApplyGyroscopicForce :: (settings: *BodyCreationSettings) -> bool #foreign JoltC "JPH_BodyCreationSettings_GetApplyGyroscopicForce";
BodyCreationSettings_SetApplyGyroscopicForce :: (settings: *BodyCreationSettings, value: bool) -> void #foreign JoltC "JPH_BodyCreationSettings_SetApplyGyroscopicForce";

BodyCreationSettings_GetMotionQuality :: (settings: *BodyCreationSettings) -> MotionQuality #foreign JoltC "JPH_BodyCreationSettings_GetMotionQuality";
BodyCreationSettings_SetMotionQuality :: (settings: *BodyCreationSettings, value: MotionQuality) -> void #foreign JoltC "JPH_BodyCreationSettings_SetMotionQuality";

BodyCreationSettings_GetEnhancedInternalEdgeRemoval :: (settings: *BodyCreationSettings) -> bool #foreign JoltC "JPH_BodyCreationSettings_GetEnhancedInternalEdgeRemoval";
BodyCreationSettings_SetEnhancedInternalEdgeRemoval :: (settings: *BodyCreationSettings, value: bool) -> void #foreign JoltC "JPH_BodyCreationSettings_SetEnhancedInternalEdgeRemoval";

BodyCreationSettings_GetAllowSleeping :: (settings: *BodyCreationSettings) -> bool #foreign JoltC "JPH_BodyCreationSettings_GetAllowSleeping";
BodyCreationSettings_SetAllowSleeping :: (settings: *BodyCreationSettings, value: bool) -> void #foreign JoltC "JPH_BodyCreationSettings_SetAllowSleeping";

BodyCreationSettings_GetFriction :: (settings: *BodyCreationSettings) -> float #foreign JoltC "JPH_BodyCreationSettings_GetFriction";
BodyCreationSettings_SetFriction :: (settings: *BodyCreationSettings, value: float) -> void #foreign JoltC "JPH_BodyCreationSettings_SetFriction";

BodyCreationSettings_GetRestitution :: (settings: *BodyCreationSettings) -> float #foreign JoltC "JPH_BodyCreationSettings_GetRestitution";
BodyCreationSettings_SetRestitution :: (settings: *BodyCreationSettings, value: float) -> void #foreign JoltC "JPH_BodyCreationSettings_SetRestitution";

BodyCreationSettings_GetLinearDamping :: (settings: *BodyCreationSettings) -> float #foreign JoltC "JPH_BodyCreationSettings_GetLinearDamping";
BodyCreationSettings_SetLinearDamping :: (settings: *BodyCreationSettings, value: float) -> void #foreign JoltC "JPH_BodyCreationSettings_SetLinearDamping";

BodyCreationSettings_GetAngularDamping :: (settings: *BodyCreationSettings) -> float #foreign JoltC "JPH_BodyCreationSettings_GetAngularDamping";
BodyCreationSettings_SetAngularDamping :: (settings: *BodyCreationSettings, value: float) -> void #foreign JoltC "JPH_BodyCreationSettings_SetAngularDamping";

BodyCreationSettings_GetMaxLinearVelocity :: (settings: *BodyCreationSettings) -> float #foreign JoltC "JPH_BodyCreationSettings_GetMaxLinearVelocity";
BodyCreationSettings_SetMaxLinearVelocity :: (settings: *BodyCreationSettings, value: float) -> void #foreign JoltC "JPH_BodyCreationSettings_SetMaxLinearVelocity";

BodyCreationSettings_GetMaxAngularVelocity :: (settings: *BodyCreationSettings) -> float #foreign JoltC "JPH_BodyCreationSettings_GetMaxAngularVelocity";
BodyCreationSettings_SetMaxAngularVelocity :: (settings: *BodyCreationSettings, value: float) -> void #foreign JoltC "JPH_BodyCreationSettings_SetMaxAngularVelocity";

BodyCreationSettings_GetGravityFactor :: (settings: *BodyCreationSettings) -> float #foreign JoltC "JPH_BodyCreationSettings_GetGravityFactor";
BodyCreationSettings_SetGravityFactor :: (settings: *BodyCreationSettings, value: float) -> void #foreign JoltC "JPH_BodyCreationSettings_SetGravityFactor";

BodyCreationSettings_GetNumVelocityStepsOverride :: (settings: *BodyCreationSettings) -> u32 #foreign JoltC "JPH_BodyCreationSettings_GetNumVelocityStepsOverride";
BodyCreationSettings_SetNumVelocityStepsOverride :: (settings: *BodyCreationSettings, value: u32) -> void #foreign JoltC "JPH_BodyCreationSettings_SetNumVelocityStepsOverride";

BodyCreationSettings_GetNumPositionStepsOverride :: (settings: *BodyCreationSettings) -> u32 #foreign JoltC "JPH_BodyCreationSettings_GetNumPositionStepsOverride";
BodyCreationSettings_SetNumPositionStepsOverride :: (settings: *BodyCreationSettings, value: u32) -> void #foreign JoltC "JPH_BodyCreationSettings_SetNumPositionStepsOverride";

BodyCreationSettings_GetOverrideMassProperties :: (settings: *BodyCreationSettings) -> OverrideMassProperties #foreign JoltC "JPH_BodyCreationSettings_GetOverrideMassProperties";
BodyCreationSettings_SetOverrideMassProperties :: (settings: *BodyCreationSettings, value: OverrideMassProperties) -> void #foreign JoltC "JPH_BodyCreationSettings_SetOverrideMassProperties";

BodyCreationSettings_GetInertiaMultiplier :: (settings: *BodyCreationSettings) -> float #foreign JoltC "JPH_BodyCreationSettings_GetInertiaMultiplier";
BodyCreationSettings_SetInertiaMultiplier :: (settings: *BodyCreationSettings, value: float) -> void #foreign JoltC "JPH_BodyCreationSettings_SetInertiaMultiplier";

BodyCreationSettings_GetMassPropertiesOverride :: (settings: *BodyCreationSettings, result: *MassProperties) -> void #foreign JoltC "JPH_BodyCreationSettings_GetMassPropertiesOverride";
BodyCreationSettings_SetMassPropertiesOverride :: (settings: *BodyCreationSettings, massProperties: *MassProperties) -> void #foreign JoltC "JPH_BodyCreationSettings_SetMassPropertiesOverride";

/* JPH_SoftBodyCreationSettings */
SoftBodyCreationSettings_Create :: () -> *SoftBodyCreationSettings #foreign JoltC "JPH_SoftBodyCreationSettings_Create";
SoftBodyCreationSettings_Destroy :: (settings: *SoftBodyCreationSettings) -> void #foreign JoltC "JPH_SoftBodyCreationSettings_Destroy";

/* JPH_Constraint */
Constraint_Destroy :: (constraint: *Constraint) -> void #foreign JoltC "JPH_Constraint_Destroy";
Constraint_GetType :: (constraint: *Constraint) -> ConstraintType #foreign JoltC "JPH_Constraint_GetType";
Constraint_GetSubType :: (constraint: *Constraint) -> ConstraintSubType #foreign JoltC "JPH_Constraint_GetSubType";
Constraint_GetConstraintPriority :: (constraint: *Constraint) -> u32 #foreign JoltC "JPH_Constraint_GetConstraintPriority";
Constraint_SetConstraintPriority :: (constraint: *Constraint, priority: u32) -> void #foreign JoltC "JPH_Constraint_SetConstraintPriority";
Constraint_GetNumVelocityStepsOverride :: (constraint: *Constraint) -> u32 #foreign JoltC "JPH_Constraint_GetNumVelocityStepsOverride";
Constraint_SetNumVelocityStepsOverride :: (constraint: *Constraint, value: u32) -> void #foreign JoltC "JPH_Constraint_SetNumVelocityStepsOverride";
Constraint_GetNumPositionStepsOverride :: (constraint: *Constraint) -> u32 #foreign JoltC "JPH_Constraint_GetNumPositionStepsOverride";
Constraint_SetNumPositionStepsOverride :: (constraint: *Constraint, value: u32) -> void #foreign JoltC "JPH_Constraint_SetNumPositionStepsOverride";
Constraint_GetEnabled :: (constraint: *Constraint) -> bool #foreign JoltC "JPH_Constraint_GetEnabled";
Constraint_SetEnabled :: (constraint: *Constraint, enabled: bool) -> void #foreign JoltC "JPH_Constraint_SetEnabled";
Constraint_GetUserData :: (constraint: *Constraint) -> u64 #foreign JoltC "JPH_Constraint_GetUserData";
Constraint_SetUserData :: (constraint: *Constraint, userData: u64) -> void #foreign JoltC "JPH_Constraint_SetUserData";
Constraint_NotifyShapeChanged :: (constraint: *Constraint, bodyID: BodyID, deltaCOM: *Vec3) -> void #foreign JoltC "JPH_Constraint_NotifyShapeChanged";
Constraint_ResetWarmStart :: (constraint: *Constraint) -> void #foreign JoltC "JPH_Constraint_ResetWarmStart";
Constraint_IsActive :: (constraint: *Constraint) -> bool #foreign JoltC "JPH_Constraint_IsActive";
Constraint_SetupVelocityConstraint :: (constraint: *Constraint, deltaTime: float) -> void #foreign JoltC "JPH_Constraint_SetupVelocityConstraint";
Constraint_WarmStartVelocityConstraint :: (constraint: *Constraint, warmStartImpulseRatio: float) -> void #foreign JoltC "JPH_Constraint_WarmStartVelocityConstraint";
Constraint_SolveVelocityConstraint :: (constraint: *Constraint, deltaTime: float) -> bool #foreign JoltC "JPH_Constraint_SolveVelocityConstraint";
Constraint_SolvePositionConstraint :: (constraint: *Constraint, deltaTime: float, baumgarte: float) -> bool #foreign JoltC "JPH_Constraint_SolvePositionConstraint";

/* JPH_TwoBodyConstraint */
TwoBodyConstraint_GetBody1 :: (constraint: *TwoBodyConstraint) -> *Body #foreign JoltC "JPH_TwoBodyConstraint_GetBody1";
TwoBodyConstraint_GetBody2 :: (constraint: *TwoBodyConstraint) -> *Body #foreign JoltC "JPH_TwoBodyConstraint_GetBody2";
TwoBodyConstraint_GetConstraintToBody1Matrix :: (constraint: *TwoBodyConstraint, result: *Mat4) -> void #foreign JoltC "JPH_TwoBodyConstraint_GetConstraintToBody1Matrix";
TwoBodyConstraint_GetConstraintToBody2Matrix :: (constraint: *TwoBodyConstraint, result: *Mat4) -> void #foreign JoltC "JPH_TwoBodyConstraint_GetConstraintToBody2Matrix";

/* JPH_FixedConstraint */
FixedConstraintSettings_Init :: (settings: *FixedConstraintSettings) -> void #foreign JoltC "JPH_FixedConstraintSettings_Init";
FixedConstraint_Create :: (settings: *FixedConstraintSettings, body1: *Body, body2: *Body) -> *FixedConstraint #foreign JoltC "JPH_FixedConstraint_Create";
FixedConstraint_GetSettings :: (constraint: *FixedConstraint, settings: *FixedConstraintSettings) -> void #foreign JoltC "JPH_FixedConstraint_GetSettings";
FixedConstraint_GetTotalLambdaPosition :: (constraint: *FixedConstraint, result: *Vec3) -> void #foreign JoltC "JPH_FixedConstraint_GetTotalLambdaPosition";
FixedConstraint_GetTotalLambdaRotation :: (constraint: *FixedConstraint, result: *Vec3) -> void #foreign JoltC "JPH_FixedConstraint_GetTotalLambdaRotation";

/* JPH_DistanceConstraint */
DistanceConstraintSettings_Init :: (settings: *DistanceConstraintSettings) -> void #foreign JoltC "JPH_DistanceConstraintSettings_Init";
DistanceConstraint_Create :: (settings: *DistanceConstraintSettings, body1: *Body, body2: *Body) -> *DistanceConstraint #foreign JoltC "JPH_DistanceConstraint_Create";
DistanceConstraint_GetSettings :: (constraint: *DistanceConstraint, settings: *DistanceConstraintSettings) -> void #foreign JoltC "JPH_DistanceConstraint_GetSettings";
DistanceConstraint_SetDistance :: (constraint: *DistanceConstraint, minDistance: float, maxDistance: float) -> void #foreign JoltC "JPH_DistanceConstraint_SetDistance";
DistanceConstraint_GetMinDistance :: (constraint: *DistanceConstraint) -> float #foreign JoltC "JPH_DistanceConstraint_GetMinDistance";
DistanceConstraint_GetMaxDistance :: (constraint: *DistanceConstraint) -> float #foreign JoltC "JPH_DistanceConstraint_GetMaxDistance";
DistanceConstraint_GetLimitsSpringSettings :: (constraint: *DistanceConstraint, result: *SpringSettings) -> void #foreign JoltC "JPH_DistanceConstraint_GetLimitsSpringSettings";
DistanceConstraint_SetLimitsSpringSettings :: (constraint: *DistanceConstraint, settings: *SpringSettings) -> void #foreign JoltC "JPH_DistanceConstraint_SetLimitsSpringSettings";
DistanceConstraint_GetTotalLambdaPosition :: (constraint: *DistanceConstraint) -> float #foreign JoltC "JPH_DistanceConstraint_GetTotalLambdaPosition";

/* JPH_PointConstraint */
PointConstraintSettings_Init :: (settings: *PointConstraintSettings) -> void #foreign JoltC "JPH_PointConstraintSettings_Init";
PointConstraint_Create :: (settings: *PointConstraintSettings, body1: *Body, body2: *Body) -> *PointConstraint #foreign JoltC "JPH_PointConstraint_Create";
PointConstraint_GetSettings :: (constraint: *PointConstraint, settings: *PointConstraintSettings) -> void #foreign JoltC "JPH_PointConstraint_GetSettings";
PointConstraint_SetPoint1 :: (constraint: *PointConstraint, space: ConstraintSpace, value: *RVec3) -> void #foreign JoltC "JPH_PointConstraint_SetPoint1";
PointConstraint_SetPoint2 :: (constraint: *PointConstraint, space: ConstraintSpace, value: *RVec3) -> void #foreign JoltC "JPH_PointConstraint_SetPoint2";
PointConstraint_GetLocalSpacePoint1 :: (constraint: *PointConstraint, result: *Vec3) -> void #foreign JoltC "JPH_PointConstraint_GetLocalSpacePoint1";
PointConstraint_GetLocalSpacePoint2 :: (constraint: *PointConstraint, result: *Vec3) -> void #foreign JoltC "JPH_PointConstraint_GetLocalSpacePoint2";
PointConstraint_GetTotalLambdaPosition :: (constraint: *PointConstraint, result: *Vec3) -> void #foreign JoltC "JPH_PointConstraint_GetTotalLambdaPosition";

/* JPH_HingeConstraint */
HingeConstraintSettings_Init :: (settings: *HingeConstraintSettings) -> void #foreign JoltC "JPH_HingeConstraintSettings_Init";
HingeConstraint_Create :: (settings: *HingeConstraintSettings, body1: *Body, body2: *Body) -> *HingeConstraint #foreign JoltC "JPH_HingeConstraint_Create";
HingeConstraint_GetSettings :: (constraint: *HingeConstraint, settings: *HingeConstraintSettings) -> void #foreign JoltC "JPH_HingeConstraint_GetSettings";
HingeConstraint_GetLocalSpacePoint1 :: (constraint: *HingeConstraint, result: *Vec3) -> void #foreign JoltC "JPH_HingeConstraint_GetLocalSpacePoint1";
HingeConstraint_GetLocalSpacePoint2 :: (constraint: *HingeConstraint, result: *Vec3) -> void #foreign JoltC "JPH_HingeConstraint_GetLocalSpacePoint2";
HingeConstraint_GetLocalSpaceHingeAxis1 :: (constraint: *HingeConstraint, result: *Vec3) -> void #foreign JoltC "JPH_HingeConstraint_GetLocalSpaceHingeAxis1";
HingeConstraint_GetLocalSpaceHingeAxis2 :: (constraint: *HingeConstraint, result: *Vec3) -> void #foreign JoltC "JPH_HingeConstraint_GetLocalSpaceHingeAxis2";
HingeConstraint_GetLocalSpaceNormalAxis1 :: (constraint: *HingeConstraint, result: *Vec3) -> void #foreign JoltC "JPH_HingeConstraint_GetLocalSpaceNormalAxis1";
HingeConstraint_GetLocalSpaceNormalAxis2 :: (constraint: *HingeConstraint, result: *Vec3) -> void #foreign JoltC "JPH_HingeConstraint_GetLocalSpaceNormalAxis2";
HingeConstraint_GetCurrentAngle :: (constraint: *HingeConstraint) -> float #foreign JoltC "JPH_HingeConstraint_GetCurrentAngle";
HingeConstraint_SetMaxFrictionTorque :: (constraint: *HingeConstraint, frictionTorque: float) -> void #foreign JoltC "JPH_HingeConstraint_SetMaxFrictionTorque";
HingeConstraint_GetMaxFrictionTorque :: (constraint: *HingeConstraint) -> float #foreign JoltC "JPH_HingeConstraint_GetMaxFrictionTorque";
HingeConstraint_SetMotorSettings :: (constraint: *HingeConstraint, settings: *MotorSettings) -> void #foreign JoltC "JPH_HingeConstraint_SetMotorSettings";
HingeConstraint_GetMotorSettings :: (constraint: *HingeConstraint, result: *MotorSettings) -> void #foreign JoltC "JPH_HingeConstraint_GetMotorSettings";
HingeConstraint_SetMotorState :: (constraint: *HingeConstraint, state: MotorState) -> void #foreign JoltC "JPH_HingeConstraint_SetMotorState";
HingeConstraint_GetMotorState :: (constraint: *HingeConstraint) -> MotorState #foreign JoltC "JPH_HingeConstraint_GetMotorState";
HingeConstraint_SetTargetAngularVelocity :: (constraint: *HingeConstraint, angularVelocity: float) -> void #foreign JoltC "JPH_HingeConstraint_SetTargetAngularVelocity";
HingeConstraint_GetTargetAngularVelocity :: (constraint: *HingeConstraint) -> float #foreign JoltC "JPH_HingeConstraint_GetTargetAngularVelocity";
HingeConstraint_SetTargetAngle :: (constraint: *HingeConstraint, angle: float) -> void #foreign JoltC "JPH_HingeConstraint_SetTargetAngle";
HingeConstraint_GetTargetAngle :: (constraint: *HingeConstraint) -> float #foreign JoltC "JPH_HingeConstraint_GetTargetAngle";
HingeConstraint_SetLimits :: (constraint: *HingeConstraint, inLimitsMin: float, inLimitsMax: float) -> void #foreign JoltC "JPH_HingeConstraint_SetLimits";
HingeConstraint_GetLimitsMin :: (constraint: *HingeConstraint) -> float #foreign JoltC "JPH_HingeConstraint_GetLimitsMin";
HingeConstraint_GetLimitsMax :: (constraint: *HingeConstraint) -> float #foreign JoltC "JPH_HingeConstraint_GetLimitsMax";
HingeConstraint_HasLimits :: (constraint: *HingeConstraint) -> bool #foreign JoltC "JPH_HingeConstraint_HasLimits";
HingeConstraint_GetLimitsSpringSettings :: (constraint: *HingeConstraint, result: *SpringSettings) -> void #foreign JoltC "JPH_HingeConstraint_GetLimitsSpringSettings";
HingeConstraint_SetLimitsSpringSettings :: (constraint: *HingeConstraint, settings: *SpringSettings) -> void #foreign JoltC "JPH_HingeConstraint_SetLimitsSpringSettings";
HingeConstraint_GetTotalLambdaPosition :: (constraint: *HingeConstraint, result: *Vec3) -> void #foreign JoltC "JPH_HingeConstraint_GetTotalLambdaPosition";
HingeConstraint_GetTotalLambdaRotation :: (constraint: *HingeConstraint, rotation: *[2] float) -> void #foreign JoltC "JPH_HingeConstraint_GetTotalLambdaRotation";
HingeConstraint_GetTotalLambdaRotationLimits :: (constraint: *HingeConstraint) -> float #foreign JoltC "JPH_HingeConstraint_GetTotalLambdaRotationLimits";
HingeConstraint_GetTotalLambdaMotor :: (constraint: *HingeConstraint) -> float #foreign JoltC "JPH_HingeConstraint_GetTotalLambdaMotor";

/* JPH_SliderConstraint */
SliderConstraintSettings_Init :: (settings: *SliderConstraintSettings) -> void #foreign JoltC "JPH_SliderConstraintSettings_Init";
SliderConstraintSettings_SetSliderAxis :: (settings: *SliderConstraintSettings, axis: *Vec3) -> void #foreign JoltC "JPH_SliderConstraintSettings_SetSliderAxis";

SliderConstraint_Create :: (settings: *SliderConstraintSettings, body1: *Body, body2: *Body) -> *SliderConstraint #foreign JoltC "JPH_SliderConstraint_Create";
SliderConstraint_GetSettings :: (constraint: *SliderConstraint, settings: *SliderConstraintSettings) -> void #foreign JoltC "JPH_SliderConstraint_GetSettings";
SliderConstraint_GetCurrentPosition :: (constraint: *SliderConstraint) -> float #foreign JoltC "JPH_SliderConstraint_GetCurrentPosition";
SliderConstraint_SetMaxFrictionForce :: (constraint: *SliderConstraint, frictionForce: float) -> void #foreign JoltC "JPH_SliderConstraint_SetMaxFrictionForce";
SliderConstraint_GetMaxFrictionForce :: (constraint: *SliderConstraint) -> float #foreign JoltC "JPH_SliderConstraint_GetMaxFrictionForce";
SliderConstraint_SetMotorSettings :: (constraint: *SliderConstraint, settings: *MotorSettings) -> void #foreign JoltC "JPH_SliderConstraint_SetMotorSettings";
SliderConstraint_GetMotorSettings :: (constraint: *SliderConstraint, result: *MotorSettings) -> void #foreign JoltC "JPH_SliderConstraint_GetMotorSettings";
SliderConstraint_SetMotorState :: (constraint: *SliderConstraint, state: MotorState) -> void #foreign JoltC "JPH_SliderConstraint_SetMotorState";
SliderConstraint_GetMotorState :: (constraint: *SliderConstraint) -> MotorState #foreign JoltC "JPH_SliderConstraint_GetMotorState";
SliderConstraint_SetTargetVelocity :: (constraint: *SliderConstraint, velocity: float) -> void #foreign JoltC "JPH_SliderConstraint_SetTargetVelocity";
SliderConstraint_GetTargetVelocity :: (constraint: *SliderConstraint) -> float #foreign JoltC "JPH_SliderConstraint_GetTargetVelocity";
SliderConstraint_SetTargetPosition :: (constraint: *SliderConstraint, position: float) -> void #foreign JoltC "JPH_SliderConstraint_SetTargetPosition";
SliderConstraint_GetTargetPosition :: (constraint: *SliderConstraint) -> float #foreign JoltC "JPH_SliderConstraint_GetTargetPosition";
SliderConstraint_SetLimits :: (constraint: *SliderConstraint, inLimitsMin: float, inLimitsMax: float) -> void #foreign JoltC "JPH_SliderConstraint_SetLimits";
SliderConstraint_GetLimitsMin :: (constraint: *SliderConstraint) -> float #foreign JoltC "JPH_SliderConstraint_GetLimitsMin";
SliderConstraint_GetLimitsMax :: (constraint: *SliderConstraint) -> float #foreign JoltC "JPH_SliderConstraint_GetLimitsMax";
SliderConstraint_HasLimits :: (constraint: *SliderConstraint) -> bool #foreign JoltC "JPH_SliderConstraint_HasLimits";
SliderConstraint_GetLimitsSpringSettings :: (constraint: *SliderConstraint, result: *SpringSettings) -> void #foreign JoltC "JPH_SliderConstraint_GetLimitsSpringSettings";
SliderConstraint_SetLimitsSpringSettings :: (constraint: *SliderConstraint, settings: *SpringSettings) -> void #foreign JoltC "JPH_SliderConstraint_SetLimitsSpringSettings";
SliderConstraint_GetTotalLambdaPosition :: (constraint: *SliderConstraint, position: *[2] float) -> void #foreign JoltC "JPH_SliderConstraint_GetTotalLambdaPosition";
SliderConstraint_GetTotalLambdaPositionLimits :: (constraint: *SliderConstraint) -> float #foreign JoltC "JPH_SliderConstraint_GetTotalLambdaPositionLimits";
SliderConstraint_GetTotalLambdaRotation :: (constraint: *SliderConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SliderConstraint_GetTotalLambdaRotation";
SliderConstraint_GetTotalLambdaMotor :: (constraint: *SliderConstraint) -> float #foreign JoltC "JPH_SliderConstraint_GetTotalLambdaMotor";

/* JPH_ConeConstraint */
ConeConstraintSettings_Init :: (settings: *ConeConstraintSettings) -> void #foreign JoltC "JPH_ConeConstraintSettings_Init";
ConeConstraint_Create :: (settings: *ConeConstraintSettings, body1: *Body, body2: *Body) -> *ConeConstraint #foreign JoltC "JPH_ConeConstraint_Create";
ConeConstraint_GetSettings :: (constraint: *ConeConstraint, settings: *ConeConstraintSettings) -> void #foreign JoltC "JPH_ConeConstraint_GetSettings";
ConeConstraint_SetHalfConeAngle :: (constraint: *ConeConstraint, halfConeAngle: float) -> void #foreign JoltC "JPH_ConeConstraint_SetHalfConeAngle";
ConeConstraint_GetCosHalfConeAngle :: (constraint: *ConeConstraint) -> float #foreign JoltC "JPH_ConeConstraint_GetCosHalfConeAngle";
ConeConstraint_GetTotalLambdaPosition :: (constraint: *ConeConstraint, result: *Vec3) -> void #foreign JoltC "JPH_ConeConstraint_GetTotalLambdaPosition";
ConeConstraint_GetTotalLambdaRotation :: (constraint: *ConeConstraint) -> float #foreign JoltC "JPH_ConeConstraint_GetTotalLambdaRotation";

/* JPH_SwingTwistConstraint */
SwingTwistConstraintSettings_Init :: (settings: *SwingTwistConstraintSettings) -> void #foreign JoltC "JPH_SwingTwistConstraintSettings_Init";
SwingTwistConstraint_Create :: (settings: *SwingTwistConstraintSettings, body1: *Body, body2: *Body) -> *SwingTwistConstraint #foreign JoltC "JPH_SwingTwistConstraint_Create";
SwingTwistConstraint_GetSettings :: (constraint: *SwingTwistConstraint, settings: *SwingTwistConstraintSettings) -> void #foreign JoltC "JPH_SwingTwistConstraint_GetSettings";
SwingTwistConstraint_GetNormalHalfConeAngle :: (constraint: *SwingTwistConstraint) -> float #foreign JoltC "JPH_SwingTwistConstraint_GetNormalHalfConeAngle";
SwingTwistConstraint_GetTotalLambdaPosition :: (constraint: *SwingTwistConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SwingTwistConstraint_GetTotalLambdaPosition";
SwingTwistConstraint_GetTotalLambdaTwist :: (constraint: *SwingTwistConstraint) -> float #foreign JoltC "JPH_SwingTwistConstraint_GetTotalLambdaTwist";
SwingTwistConstraint_GetTotalLambdaSwingY :: (constraint: *SwingTwistConstraint) -> float #foreign JoltC "JPH_SwingTwistConstraint_GetTotalLambdaSwingY";
SwingTwistConstraint_GetTotalLambdaSwingZ :: (constraint: *SwingTwistConstraint) -> float #foreign JoltC "JPH_SwingTwistConstraint_GetTotalLambdaSwingZ";
SwingTwistConstraint_GetTotalLambdaMotor :: (constraint: *SwingTwistConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SwingTwistConstraint_GetTotalLambdaMotor";

/* JPH_SixDOFConstraint */
SixDOFConstraintSettings_Init :: (settings: *SixDOFConstraintSettings) -> void #foreign JoltC "JPH_SixDOFConstraintSettings_Init";
SixDOFConstraintSettings_MakeFreeAxis :: (settings: *SixDOFConstraintSettings, axis: SixDOFConstraintAxis) -> void #foreign JoltC "JPH_SixDOFConstraintSettings_MakeFreeAxis";
SixDOFConstraintSettings_IsFreeAxis :: (settings: *SixDOFConstraintSettings, axis: SixDOFConstraintAxis) -> bool #foreign JoltC "JPH_SixDOFConstraintSettings_IsFreeAxis";
SixDOFConstraintSettings_MakeFixedAxis :: (settings: *SixDOFConstraintSettings, axis: SixDOFConstraintAxis) -> void #foreign JoltC "JPH_SixDOFConstraintSettings_MakeFixedAxis";
SixDOFConstraintSettings_IsFixedAxis :: (settings: *SixDOFConstraintSettings, axis: SixDOFConstraintAxis) -> bool #foreign JoltC "JPH_SixDOFConstraintSettings_IsFixedAxis";
SixDOFConstraintSettings_SetLimitedAxis :: (settings: *SixDOFConstraintSettings, axis: SixDOFConstraintAxis, min: float, max: float) -> void #foreign JoltC "JPH_SixDOFConstraintSettings_SetLimitedAxis";

SixDOFConstraint_Create :: (settings: *SixDOFConstraintSettings, body1: *Body, body2: *Body) -> *SixDOFConstraint #foreign JoltC "JPH_SixDOFConstraint_Create";
SixDOFConstraint_GetSettings :: (constraint: *SixDOFConstraint, settings: *SixDOFConstraintSettings) -> void #foreign JoltC "JPH_SixDOFConstraint_GetSettings";
SixDOFConstraint_GetLimitsMin :: (constraint: *SixDOFConstraint, axis: SixDOFConstraintAxis) -> float #foreign JoltC "JPH_SixDOFConstraint_GetLimitsMin";
SixDOFConstraint_GetLimitsMax :: (constraint: *SixDOFConstraint, axis: SixDOFConstraintAxis) -> float #foreign JoltC "JPH_SixDOFConstraint_GetLimitsMax";
SixDOFConstraint_GetTotalLambdaPosition :: (constraint: *SixDOFConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_GetTotalLambdaPosition";
SixDOFConstraint_GetTotalLambdaRotation :: (constraint: *SixDOFConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_GetTotalLambdaRotation";
SixDOFConstraint_GetTotalLambdaMotorTranslation :: (constraint: *SixDOFConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_GetTotalLambdaMotorTranslation";
SixDOFConstraint_GetTotalLambdaMotorRotation :: (constraint: *SixDOFConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_GetTotalLambdaMotorRotation";
SixDOFConstraint_GetTranslationLimitsMin :: (constraint: *SixDOFConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_GetTranslationLimitsMin";
SixDOFConstraint_GetTranslationLimitsMax :: (constraint: *SixDOFConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_GetTranslationLimitsMax";
SixDOFConstraint_GetRotationLimitsMin :: (constraint: *SixDOFConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_GetRotationLimitsMin";
SixDOFConstraint_GetRotationLimitsMax :: (constraint: *SixDOFConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_GetRotationLimitsMax";
SixDOFConstraint_IsFixedAxis :: (constraint: *SixDOFConstraint, axis: SixDOFConstraintAxis) -> bool #foreign JoltC "JPH_SixDOFConstraint_IsFixedAxis";
SixDOFConstraint_IsFreeAxis :: (constraint: *SixDOFConstraint, axis: SixDOFConstraintAxis) -> bool #foreign JoltC "JPH_SixDOFConstraint_IsFreeAxis";
SixDOFConstraint_GetLimitsSpringSettings :: (constraint: *SixDOFConstraint, result: *SpringSettings, axis: SixDOFConstraintAxis) -> void #foreign JoltC "JPH_SixDOFConstraint_GetLimitsSpringSettings";
SixDOFConstraint_SetLimitsSpringSettings :: (constraint: *SixDOFConstraint, settings: *SpringSettings, axis: SixDOFConstraintAxis) -> void #foreign JoltC "JPH_SixDOFConstraint_SetLimitsSpringSettings";
SixDOFConstraint_SetMaxFriction :: (constraint: *SixDOFConstraint, axis: SixDOFConstraintAxis, inFriction: float) -> void #foreign JoltC "JPH_SixDOFConstraint_SetMaxFriction";
SixDOFConstraint_GetMaxFriction :: (constraint: *SixDOFConstraint, axis: SixDOFConstraintAxis) -> float #foreign JoltC "JPH_SixDOFConstraint_GetMaxFriction";
SixDOFConstraint_GetRotationInConstraintSpace :: (constraint: *SixDOFConstraint, result: *Quat) -> void #foreign JoltC "JPH_SixDOFConstraint_GetRotationInConstraintSpace";
SixDOFConstraint_GetMotorSettings :: (constraint: *SixDOFConstraint, axis: SixDOFConstraintAxis, settings: *MotorSettings) -> void #foreign JoltC "JPH_SixDOFConstraint_GetMotorSettings";
SixDOFConstraint_SetMotorState :: (constraint: *SixDOFConstraint, axis: SixDOFConstraintAxis, state: MotorState) -> void #foreign JoltC "JPH_SixDOFConstraint_SetMotorState";
SixDOFConstraint_GetMotorState :: (constraint: *SixDOFConstraint, axis: SixDOFConstraintAxis) -> MotorState #foreign JoltC "JPH_SixDOFConstraint_GetMotorState";
SixDOFConstraint_SetTargetVelocityCS :: (constraint: *SixDOFConstraint, inVelocity: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_SetTargetVelocityCS";
SixDOFConstraint_GetTargetVelocityCS :: (constraint: *SixDOFConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_GetTargetVelocityCS";
SixDOFConstraint_SetTargetAngularVelocityCS :: (constraint: *SixDOFConstraint, inAngularVelocity: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_SetTargetAngularVelocityCS";
SixDOFConstraint_GetTargetAngularVelocityCS :: (constraint: *SixDOFConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_GetTargetAngularVelocityCS";
SixDOFConstraint_SetTargetPositionCS :: (constraint: *SixDOFConstraint, inPosition: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_SetTargetPositionCS";
SixDOFConstraint_GetTargetPositionCS :: (constraint: *SixDOFConstraint, result: *Vec3) -> void #foreign JoltC "JPH_SixDOFConstraint_GetTargetPositionCS";
SixDOFConstraint_SetTargetOrientationCS :: (constraint: *SixDOFConstraint, inOrientation: *Quat) -> void #foreign JoltC "JPH_SixDOFConstraint_SetTargetOrientationCS";
SixDOFConstraint_GetTargetOrientationCS :: (constraint: *SixDOFConstraint, result: *Quat) -> void #foreign JoltC "JPH_SixDOFConstraint_GetTargetOrientationCS";
SixDOFConstraint_SetTargetOrientationBS :: (constraint: *SixDOFConstraint, inOrientation: *Quat) -> void #foreign JoltC "JPH_SixDOFConstraint_SetTargetOrientationBS";

/* JPH_GearConstraint */
GearConstraintSettings_Init :: (settings: *GearConstraintSettings) -> void #foreign JoltC "JPH_GearConstraintSettings_Init";
GearConstraint_Create :: (settings: *GearConstraintSettings, body1: *Body, body2: *Body) -> *GearConstraint #foreign JoltC "JPH_GearConstraint_Create";
GearConstraint_GetSettings :: (constraint: *GearConstraint, settings: *GearConstraintSettings) -> void #foreign JoltC "JPH_GearConstraint_GetSettings";
GearConstraint_SetConstraints :: (constraint: *GearConstraint, gear1: *Constraint, gear2: *Constraint) -> void #foreign JoltC "JPH_GearConstraint_SetConstraints";
GearConstraint_GetTotalLambda :: (constraint: *GearConstraint) -> float #foreign JoltC "JPH_GearConstraint_GetTotalLambda";

/* BodyInterface */
BodyInterface_DestroyBody :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> void #foreign JoltC "JPH_BodyInterface_DestroyBody";
BodyInterface_CreateAndAddBody :: (bodyInterface: *BodyInterface, settings: *BodyCreationSettings, activationMode: Activation) -> BodyID #foreign JoltC "JPH_BodyInterface_CreateAndAddBody";
BodyInterface_CreateBody :: (bodyInterface: *BodyInterface, settings: *BodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateBody";
BodyInterface_CreateBodyWithID :: (bodyInterface: *BodyInterface, bodyID: BodyID, settings: *BodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateBodyWithID";
BodyInterface_CreateBodyWithoutID :: (bodyInterface: *BodyInterface, settings: *BodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateBodyWithoutID";
BodyInterface_DestroyBodyWithoutID :: (bodyInterface: *BodyInterface, body: *Body) -> void #foreign JoltC "JPH_BodyInterface_DestroyBodyWithoutID";
BodyInterface_AssignBodyID :: (bodyInterface: *BodyInterface, body: *Body) -> bool #foreign JoltC "JPH_BodyInterface_AssignBodyID";
BodyInterface_AssignBodyID2 :: (bodyInterface: *BodyInterface, body: *Body, bodyID: BodyID) -> bool #foreign JoltC "JPH_BodyInterface_AssignBodyID2";
BodyInterface_UnassignBodyID :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> *Body #foreign JoltC "JPH_BodyInterface_UnassignBodyID";

BodyInterface_CreateSoftBody :: (bodyInterface: *BodyInterface, settings: *SoftBodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateSoftBody";
BodyInterface_CreateSoftBodyWithID :: (bodyInterface: *BodyInterface, bodyID: BodyID, settings: *SoftBodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateSoftBodyWithID";
BodyInterface_CreateSoftBodyWithoutID :: (bodyInterface: *BodyInterface, settings: *SoftBodyCreationSettings) -> *Body #foreign JoltC "JPH_BodyInterface_CreateSoftBodyWithoutID";
BodyInterface_CreateAndAddSoftBody :: (bodyInterface: *BodyInterface, settings: *SoftBodyCreationSettings, activationMode: Activation) -> BodyID #foreign JoltC "JPH_BodyInterface_CreateAndAddSoftBody";

BodyInterface_AddBody :: (bodyInterface: *BodyInterface, bodyID: BodyID, activationMode: Activation) -> void #foreign JoltC "JPH_BodyInterface_AddBody";
BodyInterface_RemoveBody :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> void #foreign JoltC "JPH_BodyInterface_RemoveBody";
BodyInterface_RemoveAndDestroyBody :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> void #foreign JoltC "JPH_BodyInterface_RemoveAndDestroyBody";
BodyInterface_IsAdded :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> bool #foreign JoltC "JPH_BodyInterface_IsAdded";
BodyInterface_GetBodyType :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> BodyType #foreign JoltC "JPH_BodyInterface_GetBodyType";

BodyInterface_SetLinearVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID, velocity: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_SetLinearVelocity";
BodyInterface_GetLinearVelocity :: (bodyInterface: *BodyInterface, bodyID: BodyID, velocity: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_GetLinearVelocity";
BodyInterface_GetCenterOfMassPosition :: (bodyInterface: *BodyInterface, bodyID: BodyID, position: *RVec3) -> void #foreign JoltC "JPH_BodyInterface_GetCenterOfMassPosition";

BodyInterface_GetMotionType :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> MotionType #foreign JoltC "JPH_BodyInterface_GetMotionType";
BodyInterface_SetMotionType :: (bodyInterface: *BodyInterface, bodyID: BodyID, motionType: MotionType, activationMode: Activation) -> void #foreign JoltC "JPH_BodyInterface_SetMotionType";

BodyInterface_GetRestitution :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetRestitution";
BodyInterface_SetRestitution :: (bodyInterface: *BodyInterface, bodyID: BodyID, restitution: float) -> void #foreign JoltC "JPH_BodyInterface_SetRestitution";

BodyInterface_GetFriction :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetFriction";
BodyInterface_SetFriction :: (bodyInterface: *BodyInterface, bodyID: BodyID, friction: float) -> void #foreign JoltC "JPH_BodyInterface_SetFriction";

BodyInterface_SetPosition :: (bodyInterface: *BodyInterface, bodyId: BodyID, position: *RVec3, activationMode: Activation) -> void #foreign JoltC "JPH_BodyInterface_SetPosition";
BodyInterface_GetPosition :: (bodyInterface: *BodyInterface, bodyId: BodyID, result: *RVec3) -> void #foreign JoltC "JPH_BodyInterface_GetPosition";

BodyInterface_SetRotation :: (bodyInterface: *BodyInterface, bodyId: BodyID, rotation: *Quat, activationMode: Activation) -> void #foreign JoltC "JPH_BodyInterface_SetRotation";
BodyInterface_GetRotation :: (bodyInterface: *BodyInterface, bodyId: BodyID, result: *Quat) -> void #foreign JoltC "JPH_BodyInterface_GetRotation";

BodyInterface_SetPositionAndRotation :: (bodyInterface: *BodyInterface, bodyId: BodyID, position: *RVec3, rotation: *Quat, activationMode: Activation) -> void #foreign JoltC "JPH_BodyInterface_SetPositionAndRotation";
BodyInterface_SetPositionAndRotationWhenChanged :: (bodyInterface: *BodyInterface, bodyId: BodyID, position: *RVec3, rotation: *Quat, activationMode: Activation) -> void #foreign JoltC "JPH_BodyInterface_SetPositionAndRotationWhenChanged";
BodyInterface_GetPositionAndRotation :: (bodyInterface: *BodyInterface, bodyId: BodyID, position: *RVec3, rotation: *Quat) -> void #foreign JoltC "JPH_BodyInterface_GetPositionAndRotation";
BodyInterface_SetPositionRotationAndVelocity :: (bodyInterface: *BodyInterface, bodyId: BodyID, position: *RVec3, rotation: *Quat, linearVelocity: *Vec3, angularVelocity: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_SetPositionRotationAndVelocity";

BodyInterface_GetCollisionGroup :: (bodyInterface: *BodyInterface, bodyId: BodyID, result: *CollisionGroup) -> void #foreign JoltC "JPH_BodyInterface_GetCollisionGroup";
BodyInterface_SetCollisionGroup :: (bodyInterface: *BodyInterface, bodyId: BodyID, group: *CollisionGroup) -> void #foreign JoltC "JPH_BodyInterface_SetCollisionGroup";

BodyInterface_GetShape :: (bodyInterface: *BodyInterface, bodyId: BodyID) -> *Shape #foreign JoltC "JPH_BodyInterface_GetShape";
BodyInterface_SetShape :: (bodyInterface: *BodyInterface, bodyId: BodyID, shape: *Shape, updateMassProperties: bool, activationMode: Activation) -> void #foreign JoltC "JPH_BodyInterface_SetShape";
BodyInterface_NotifyShapeChanged :: (bodyInterface: *BodyInterface, bodyId: BodyID, previousCenterOfMass: *Vec3, updateMassProperties: bool, activationMode: Activation) -> void #foreign JoltC "JPH_BodyInterface_NotifyShapeChanged";

BodyInterface_ActivateBody :: (bodyInterface: *BodyInterface, bodyId: BodyID) -> void #foreign JoltC "JPH_BodyInterface_ActivateBody";
BodyInterface_ActivateBodies :: (bodyInterface: *BodyInterface, bodyIDs: *BodyID, count: u32) -> void #foreign JoltC "JPH_BodyInterface_ActivateBodies";
BodyInterface_ActivateBodiesInAABox :: (bodyInterface: *BodyInterface, box: *AABox, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter) -> void #foreign JoltC "JPH_BodyInterface_ActivateBodiesInAABox";
BodyInterface_DeactivateBody :: (bodyInterface: *BodyInterface, bodyId: BodyID) -> void #foreign JoltC "JPH_BodyInterface_DeactivateBody";
BodyInterface_DeactivateBodies :: (bodyInterface: *BodyInterface, bodyIDs: *BodyID, count: u32) -> void #foreign JoltC "JPH_BodyInterface_DeactivateBodies";
BodyInterface_IsActive :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> bool #foreign JoltC "JPH_BodyInterface_IsActive";
BodyInterface_ResetSleepTimer :: (bodyInterface: *BodyInterface, bodyID: BodyID) -> void #foreign JoltC "JPH_BodyInterface_ResetSleepTimer";

BodyInterface_GetObjectLayer :: (bodyInterface: *BodyInterface, bodyId: BodyID) -> ObjectLayer #foreign JoltC "JPH_BodyInterface_GetObjectLayer";
BodyInterface_SetObjectLayer :: (bodyInterface: *BodyInterface, bodyId: BodyID, layer: ObjectLayer) -> void #foreign JoltC "JPH_BodyInterface_SetObjectLayer";

BodyInterface_GetWorldTransform :: (bodyInterface: *BodyInterface, bodyId: BodyID, result: *RMat4) -> void #foreign JoltC "JPH_BodyInterface_GetWorldTransform";
BodyInterface_GetCenterOfMassTransform :: (bodyInterface: *BodyInterface, bodyId: BodyID, result: *RMat4) -> void #foreign JoltC "JPH_BodyInterface_GetCenterOfMassTransform";

BodyInterface_MoveKinematic :: (bodyInterface: *BodyInterface, bodyId: BodyID, targetPosition: *RVec3, targetRotation: *Quat, deltaTime: float) -> void #foreign JoltC "JPH_BodyInterface_MoveKinematic";
BodyInterface_ApplyBuoyancyImpulse :: (bodyInterface: *BodyInterface, bodyId: BodyID, surfacePosition: *RVec3, surfaceNormal: *Vec3, buoyancy: float, linearDrag: float, angularDrag: float, fluidVelocity: *Vec3, gravity: *Vec3, deltaTime: float) -> bool #foreign JoltC "JPH_BodyInterface_ApplyBuoyancyImpulse";

BodyInterface_SetLinearAndAngularVelocity :: (bodyInterface: *BodyInterface, bodyId: BodyID, linearVelocity: *Vec3, angularVelocity: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_SetLinearAndAngularVelocity";
BodyInterface_GetLinearAndAngularVelocity :: (bodyInterface: *BodyInterface, bodyId: BodyID, linearVelocity: *Vec3, angularVelocity: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_GetLinearAndAngularVelocity";

BodyInterface_AddLinearVelocity :: (bodyInterface: *BodyInterface, bodyId: BodyID, linearVelocity: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddLinearVelocity";
BodyInterface_AddLinearAndAngularVelocity :: (bodyInterface: *BodyInterface, bodyId: BodyID, linearVelocity: *Vec3, angularVelocity: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddLinearAndAngularVelocity";

BodyInterface_SetAngularVelocity :: (bodyInterface: *BodyInterface, bodyId: BodyID, angularVelocity: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_SetAngularVelocity";
BodyInterface_GetAngularVelocity :: (bodyInterface: *BodyInterface, bodyId: BodyID, angularVelocity: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_GetAngularVelocity";

BodyInterface_GetPointVelocity :: (bodyInterface: *BodyInterface, bodyId: BodyID, point: *RVec3, velocity: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_GetPointVelocity";

BodyInterface_AddForce :: (bodyInterface: *BodyInterface, bodyId: BodyID, force: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddForce";
BodyInterface_AddForce2 :: (bodyInterface: *BodyInterface, bodyId: BodyID, force: *Vec3, point: *RVec3) -> void #foreign JoltC "JPH_BodyInterface_AddForce2";
BodyInterface_AddTorque :: (bodyInterface: *BodyInterface, bodyId: BodyID, torque: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddTorque";
BodyInterface_AddForceAndTorque :: (bodyInterface: *BodyInterface, bodyId: BodyID, force: *Vec3, torque: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddForceAndTorque";

BodyInterface_AddImpulse :: (bodyInterface: *BodyInterface, bodyId: BodyID, impulse: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddImpulse";
BodyInterface_AddImpulse2 :: (bodyInterface: *BodyInterface, bodyId: BodyID, impulse: *Vec3, point: *RVec3) -> void #foreign JoltC "JPH_BodyInterface_AddImpulse2";
BodyInterface_AddAngularImpulse :: (bodyInterface: *BodyInterface, bodyId: BodyID, angularImpulse: *Vec3) -> void #foreign JoltC "JPH_BodyInterface_AddAngularImpulse";

BodyInterface_SetMotionQuality :: (bodyInterface: *BodyInterface, bodyId: BodyID, quality: MotionQuality) -> void #foreign JoltC "JPH_BodyInterface_SetMotionQuality";
BodyInterface_GetMotionQuality :: (bodyInterface: *BodyInterface, bodyId: BodyID) -> MotionQuality #foreign JoltC "JPH_BodyInterface_GetMotionQuality";

BodyInterface_GetInverseInertia :: (bodyInterface: *BodyInterface, bodyId: BodyID, result: *Mat4) -> void #foreign JoltC "JPH_BodyInterface_GetInverseInertia";

BodyInterface_SetGravityFactor :: (bodyInterface: *BodyInterface, bodyId: BodyID, value: float) -> void #foreign JoltC "JPH_BodyInterface_SetGravityFactor";
BodyInterface_GetGravityFactor :: (bodyInterface: *BodyInterface, bodyId: BodyID) -> float #foreign JoltC "JPH_BodyInterface_GetGravityFactor";

BodyInterface_SetUseManifoldReduction :: (bodyInterface: *BodyInterface, bodyId: BodyID, value: bool) -> void #foreign JoltC "JPH_BodyInterface_SetUseManifoldReduction";
BodyInterface_GetUseManifoldReduction :: (bodyInterface: *BodyInterface, bodyId: BodyID) -> bool #foreign JoltC "JPH_BodyInterface_GetUseManifoldReduction";

BodyInterface_SetUserData :: (bodyInterface: *BodyInterface, bodyId: BodyID, inUserData: u64) -> void #foreign JoltC "JPH_BodyInterface_SetUserData";
BodyInterface_GetUserData :: (bodyInterface: *BodyInterface, bodyId: BodyID) -> u64 #foreign JoltC "JPH_BodyInterface_GetUserData";

BodyInterface_SetIsSensor :: (bodyInterface: *BodyInterface, bodyId: BodyID, value: bool) -> void #foreign JoltC "JPH_BodyInterface_SetIsSensor";
BodyInterface_IsSensor :: (bodyInterface: *BodyInterface, bodyId: BodyID) -> bool #foreign JoltC "JPH_BodyInterface_IsSensor";

BodyInterface_GetMaterial :: (bodyInterface: *BodyInterface, bodyId: BodyID, subShapeID: SubShapeID) -> *PhysicsMaterial #foreign JoltC "JPH_BodyInterface_GetMaterial";

BodyInterface_InvalidateContactCache :: (bodyInterface: *BodyInterface, bodyId: BodyID) -> void #foreign JoltC "JPH_BodyInterface_InvalidateContactCache";

//--------------------------------------------------------------------------------------------------
// JPH_BodyLockInterface
//--------------------------------------------------------------------------------------------------
BodyLockInterface_LockRead :: (lockInterface: *BodyLockInterface, bodyID: BodyID, outLock: *BodyLockRead) -> void #foreign JoltC "JPH_BodyLockInterface_LockRead";
BodyLockInterface_UnlockRead :: (lockInterface: *BodyLockInterface, ioLock: *BodyLockRead) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockRead";

BodyLockInterface_LockWrite :: (lockInterface: *BodyLockInterface, bodyID: BodyID, outLock: *BodyLockWrite) -> void #foreign JoltC "JPH_BodyLockInterface_LockWrite";
BodyLockInterface_UnlockWrite :: (lockInterface: *BodyLockInterface, ioLock: *BodyLockWrite) -> void #foreign JoltC "JPH_BodyLockInterface_UnlockWrite";

BodyLockInterface_LockMultiRead :: (lockInterface: *BodyLockInterface, bodyIDs: *BodyID, count: u32) -> *BodyLockMultiRead #foreign JoltC "JPH_BodyLockInterface_LockMultiRead";
BodyLockMultiRead_Destroy :: (ioLock: *BodyLockMultiRead) -> void #foreign JoltC "JPH_BodyLockMultiRead_Destroy";
BodyLockMultiRead_GetBody :: (ioLock: *BodyLockMultiRead, bodyIndex: u32) -> *Body #foreign JoltC "JPH_BodyLockMultiRead_GetBody";

BodyLockInterface_LockMultiWrite :: (lockInterface: *BodyLockInterface, bodyIDs: *BodyID, count: u32) -> *BodyLockMultiWrite #foreign JoltC "JPH_BodyLockInterface_LockMultiWrite";
BodyLockMultiWrite_Destroy :: (ioLock: *BodyLockMultiWrite) -> void #foreign JoltC "JPH_BodyLockMultiWrite_Destroy";
BodyLockMultiWrite_GetBody :: (ioLock: *BodyLockMultiWrite, bodyIndex: u32) -> *Body #foreign JoltC "JPH_BodyLockMultiWrite_GetBody";

//--------------------------------------------------------------------------------------------------
// JPH_MotionProperties
//--------------------------------------------------------------------------------------------------
MotionProperties_GetAllowedDOFs :: (properties: *MotionProperties) -> AllowedDOFs #foreign JoltC "JPH_MotionProperties_GetAllowedDOFs";
MotionProperties_SetLinearDamping :: (properties: *MotionProperties, damping: float) -> void #foreign JoltC "JPH_MotionProperties_SetLinearDamping";
MotionProperties_GetLinearDamping :: (properties: *MotionProperties) -> float #foreign JoltC "JPH_MotionProperties_GetLinearDamping";
MotionProperties_SetAngularDamping :: (properties: *MotionProperties, damping: float) -> void #foreign JoltC "JPH_MotionProperties_SetAngularDamping";
MotionProperties_GetAngularDamping :: (properties: *MotionProperties) -> float #foreign JoltC "JPH_MotionProperties_GetAngularDamping";
MotionProperties_SetMassProperties :: (properties: *MotionProperties, allowedDOFs: AllowedDOFs, massProperties: *MassProperties) -> void #foreign JoltC "JPH_MotionProperties_SetMassProperties";
MotionProperties_GetInverseMassUnchecked :: (properties: *MotionProperties) -> float #foreign JoltC "JPH_MotionProperties_GetInverseMassUnchecked";
MotionProperties_SetInverseMass :: (properties: *MotionProperties, inverseMass: float) -> void #foreign JoltC "JPH_MotionProperties_SetInverseMass";
MotionProperties_GetInverseInertiaDiagonal :: (properties: *MotionProperties, result: *Vec3) -> void #foreign JoltC "JPH_MotionProperties_GetInverseInertiaDiagonal";
MotionProperties_GetInertiaRotation :: (properties: *MotionProperties, result: *Quat) -> void #foreign JoltC "JPH_MotionProperties_GetInertiaRotation";
MotionProperties_SetInverseInertia :: (properties: *MotionProperties, diagonal: *Vec3, rot: *Quat) -> void #foreign JoltC "JPH_MotionProperties_SetInverseInertia";
MotionProperties_ScaleToMass :: (properties: *MotionProperties, mass: float) -> void #foreign JoltC "JPH_MotionProperties_ScaleToMass";

//--------------------------------------------------------------------------------------------------
// JPH_RayCast
//--------------------------------------------------------------------------------------------------
RayCast_GetPointOnRay :: (origin: *Vec3, direction: *Vec3, fraction: float, result: *Vec3) -> void #foreign JoltC "JPH_RayCast_GetPointOnRay";
RRayCast_GetPointOnRay :: (origin: *RVec3, direction: *Vec3, fraction: float, result: *RVec3) -> void #foreign JoltC "JPH_RRayCast_GetPointOnRay";

//--------------------------------------------------------------------------------------------------
// JPH_MassProperties
//--------------------------------------------------------------------------------------------------
MassProperties_DecomposePrincipalMomentsOfInertia :: (properties: *MassProperties, rotation: *Mat4, diagonal: *Vec3) -> void #foreign JoltC "JPH_MassProperties_DecomposePrincipalMomentsOfInertia";
MassProperties_ScaleToMass :: (properties: *MassProperties, mass: float) -> void #foreign JoltC "JPH_MassProperties_ScaleToMass";
MassProperties_GetEquivalentSolidBoxSize :: (mass: float, inertiaDiagonal: *Vec3, result: *Vec3) -> void #foreign JoltC "JPH_MassProperties_GetEquivalentSolidBoxSize";

//--------------------------------------------------------------------------------------------------
// JPH_CollideShapeSettings
//--------------------------------------------------------------------------------------------------
CollideShapeSettings_Init :: (settings: *CollideShapeSettings) -> void #foreign JoltC "JPH_CollideShapeSettings_Init";

//--------------------------------------------------------------------------------------------------
// JPH_ShapeCastSettings
//--------------------------------------------------------------------------------------------------
ShapeCastSettings_Init :: (settings: *ShapeCastSettings) -> void #foreign JoltC "JPH_ShapeCastSettings_Init";

//--------------------------------------------------------------------------------------------------
// JPH_BroadPhaseQuery
//--------------------------------------------------------------------------------------------------
BroadPhaseQuery_CastRay :: (query: *BroadPhaseQuery, origin: *Vec3, direction: *Vec3, callback: RayCastBodyCollectorCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter) -> bool #foreign JoltC "JPH_BroadPhaseQuery_CastRay";

BroadPhaseQuery_CastRay2 :: (query: *BroadPhaseQuery, origin: *Vec3, direction: *Vec3, collectorType: CollisionCollectorType, callback: RayCastBodyResultCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter) -> bool #foreign JoltC "JPH_BroadPhaseQuery_CastRay2";

BroadPhaseQuery_CollideAABox :: (query: *BroadPhaseQuery, box: *AABox, callback: CollideShapeBodyCollectorCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter) -> bool #foreign JoltC "JPH_BroadPhaseQuery_CollideAABox";

BroadPhaseQuery_CollideSphere :: (query: *BroadPhaseQuery, center: *Vec3, radius: float, callback: CollideShapeBodyCollectorCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter) -> bool #foreign JoltC "JPH_BroadPhaseQuery_CollideSphere";

BroadPhaseQuery_CollidePoint :: (query: *BroadPhaseQuery, point: *Vec3, callback: CollideShapeBodyCollectorCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter) -> bool #foreign JoltC "JPH_BroadPhaseQuery_CollidePoint";

//--------------------------------------------------------------------------------------------------
// JPH_NarrowPhaseQuery
//--------------------------------------------------------------------------------------------------
NarrowPhaseQuery_CastRay :: (query: *NarrowPhaseQuery, origin: *RVec3, direction: *Vec3, hit: *RayCastResult, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter, bodyFilter: *BodyFilter) -> bool #foreign JoltC "JPH_NarrowPhaseQuery_CastRay";

NarrowPhaseQuery_CastRay2 :: (query: *NarrowPhaseQuery, origin: *RVec3, direction: *Vec3, rayCastSettings: *RayCastSettings, callback: CastRayCollectorCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_NarrowPhaseQuery_CastRay2";

NarrowPhaseQuery_CastRay3 :: (query: *NarrowPhaseQuery, origin: *RVec3, direction: *Vec3, rayCastSettings: *RayCastSettings, collectorType: CollisionCollectorType, callback: CastRayResultCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_NarrowPhaseQuery_CastRay3";

NarrowPhaseQuery_CollidePoint :: (query: *NarrowPhaseQuery, point: *RVec3, callback: CollidePointCollectorCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_NarrowPhaseQuery_CollidePoint";

NarrowPhaseQuery_CollidePoint2 :: (query: *NarrowPhaseQuery, point: *RVec3, collectorType: CollisionCollectorType, callback: CollidePointResultCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_NarrowPhaseQuery_CollidePoint2";

NarrowPhaseQuery_CollideShape :: (query: *NarrowPhaseQuery, shape: *Shape, scale: *Vec3, centerOfMassTransform: *RMat4, settings: *CollideShapeSettings, baseOffset: *RVec3, callback: CollideShapeCollectorCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_NarrowPhaseQuery_CollideShape";

NarrowPhaseQuery_CollideShape2 :: (query: *NarrowPhaseQuery, shape: *Shape, scale: *Vec3, centerOfMassTransform: *RMat4, settings: *CollideShapeSettings, baseOffset: *RVec3, collectorType: CollisionCollectorType, callback: CollideShapeResultCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_NarrowPhaseQuery_CollideShape2";

NarrowPhaseQuery_CastShape :: (query: *NarrowPhaseQuery, shape: *Shape, worldTransform: *RMat4, direction: *Vec3, settings: *ShapeCastSettings, baseOffset: *RVec3, callback: CastShapeCollectorCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_NarrowPhaseQuery_CastShape";

NarrowPhaseQuery_CastShape2 :: (query: *NarrowPhaseQuery, shape: *Shape, worldTransform: *RMat4, direction: *Vec3, settings: *ShapeCastSettings, baseOffset: *RVec3, collectorType: CollisionCollectorType, callback: CastShapeResultCallback, userData: *void, broadPhaseLayerFilter: *BroadPhaseLayerFilter, objectLayerFilter: *ObjectLayerFilter, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_NarrowPhaseQuery_CastShape2";

//--------------------------------------------------------------------------------------------------
// JPH_Body
//--------------------------------------------------------------------------------------------------
Body_GetID :: (body: *Body) -> BodyID #foreign JoltC "JPH_Body_GetID";
Body_GetBodyType :: (body: *Body) -> BodyType #foreign JoltC "JPH_Body_GetBodyType";
Body_IsRigidBody :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsRigidBody";
Body_IsSoftBody :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsSoftBody";
Body_IsActive :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsActive";
Body_IsStatic :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsStatic";
Body_IsKinematic :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsKinematic";
Body_IsDynamic :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsDynamic";
Body_CanBeKinematicOrDynamic :: (body: *Body) -> bool #foreign JoltC "JPH_Body_CanBeKinematicOrDynamic";

Body_SetIsSensor :: (body: *Body, value: bool) -> void #foreign JoltC "JPH_Body_SetIsSensor";
Body_IsSensor :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsSensor";

Body_SetCollideKinematicVsNonDynamic :: (body: *Body, value: bool) -> void #foreign JoltC "JPH_Body_SetCollideKinematicVsNonDynamic";
Body_GetCollideKinematicVsNonDynamic :: (body: *Body) -> bool #foreign JoltC "JPH_Body_GetCollideKinematicVsNonDynamic";

Body_SetUseManifoldReduction :: (body: *Body, value: bool) -> void #foreign JoltC "JPH_Body_SetUseManifoldReduction";
Body_GetUseManifoldReduction :: (body: *Body) -> bool #foreign JoltC "JPH_Body_GetUseManifoldReduction";
Body_GetUseManifoldReductionWithBody :: (body: *Body, other: *Body) -> bool #foreign JoltC "JPH_Body_GetUseManifoldReductionWithBody";

Body_SetApplyGyroscopicForce :: (body: *Body, value: bool) -> void #foreign JoltC "JPH_Body_SetApplyGyroscopicForce";
Body_GetApplyGyroscopicForce :: (body: *Body) -> bool #foreign JoltC "JPH_Body_GetApplyGyroscopicForce";

Body_SetEnhancedInternalEdgeRemoval :: (body: *Body, value: bool) -> void #foreign JoltC "JPH_Body_SetEnhancedInternalEdgeRemoval";
Body_GetEnhancedInternalEdgeRemoval :: (body: *Body) -> bool #foreign JoltC "JPH_Body_GetEnhancedInternalEdgeRemoval";
Body_GetEnhancedInternalEdgeRemovalWithBody :: (body: *Body, other: *Body) -> bool #foreign JoltC "JPH_Body_GetEnhancedInternalEdgeRemovalWithBody";

Body_GetMotionType :: (body: *Body) -> MotionType #foreign JoltC "JPH_Body_GetMotionType";
Body_SetMotionType :: (body: *Body, motionType: MotionType) -> void #foreign JoltC "JPH_Body_SetMotionType";

Body_GetBroadPhaseLayer :: (body: *Body) -> BroadPhaseLayer #foreign JoltC "JPH_Body_GetBroadPhaseLayer";
Body_GetObjectLayer :: (body: *Body) -> ObjectLayer #foreign JoltC "JPH_Body_GetObjectLayer";

Body_GetCollisionGroup :: (body: *Body, result: *CollisionGroup) -> void #foreign JoltC "JPH_Body_GetCollisionGroup";
Body_SetCollisionGroup :: (body: *Body, value: *CollisionGroup) -> void #foreign JoltC "JPH_Body_SetCollisionGroup";

Body_GetAllowSleeping :: (body: *Body) -> bool #foreign JoltC "JPH_Body_GetAllowSleeping";
Body_SetAllowSleeping :: (body: *Body, allowSleeping: bool) -> void #foreign JoltC "JPH_Body_SetAllowSleeping";
Body_ResetSleepTimer :: (body: *Body) -> void #foreign JoltC "JPH_Body_ResetSleepTimer";

Body_GetFriction :: (body: *Body) -> float #foreign JoltC "JPH_Body_GetFriction";
Body_SetFriction :: (body: *Body, friction: float) -> void #foreign JoltC "JPH_Body_SetFriction";
Body_GetRestitution :: (body: *Body) -> float #foreign JoltC "JPH_Body_GetRestitution";
Body_SetRestitution :: (body: *Body, restitution: float) -> void #foreign JoltC "JPH_Body_SetRestitution";
Body_GetLinearVelocity :: (body: *Body, velocity: *Vec3) -> void #foreign JoltC "JPH_Body_GetLinearVelocity";
Body_SetLinearVelocity :: (body: *Body, velocity: *Vec3) -> void #foreign JoltC "JPH_Body_SetLinearVelocity";
Body_SetLinearVelocityClamped :: (body: *Body, velocity: *Vec3) -> void #foreign JoltC "JPH_Body_SetLinearVelocityClamped";
Body_GetAngularVelocity :: (body: *Body, velocity: *Vec3) -> void #foreign JoltC "JPH_Body_GetAngularVelocity";
Body_SetAngularVelocity :: (body: *Body, velocity: *Vec3) -> void #foreign JoltC "JPH_Body_SetAngularVelocity";
Body_SetAngularVelocityClamped :: (body: *Body, velocity: *Vec3) -> void #foreign JoltC "JPH_Body_SetAngularVelocityClamped";

Body_GetPointVelocityCOM :: (body: *Body, pointRelativeToCOM: *Vec3, velocity: *Vec3) -> void #foreign JoltC "JPH_Body_GetPointVelocityCOM";
Body_GetPointVelocity :: (body: *Body, point: *RVec3, velocity: *Vec3) -> void #foreign JoltC "JPH_Body_GetPointVelocity";

Body_AddForce :: (body: *Body, force: *Vec3) -> void #foreign JoltC "JPH_Body_AddForce";
Body_AddForceAtPosition :: (body: *Body, force: *Vec3, position: *RVec3) -> void #foreign JoltC "JPH_Body_AddForceAtPosition";
Body_AddTorque :: (body: *Body, force: *Vec3) -> void #foreign JoltC "JPH_Body_AddTorque";
Body_GetAccumulatedForce :: (body: *Body, force: *Vec3) -> void #foreign JoltC "JPH_Body_GetAccumulatedForce";
Body_GetAccumulatedTorque :: (body: *Body, force: *Vec3) -> void #foreign JoltC "JPH_Body_GetAccumulatedTorque";
Body_ResetForce :: (body: *Body) -> void #foreign JoltC "JPH_Body_ResetForce";
Body_ResetTorque :: (body: *Body) -> void #foreign JoltC "JPH_Body_ResetTorque";
Body_ResetMotion :: (body: *Body) -> void #foreign JoltC "JPH_Body_ResetMotion";

Body_GetInverseInertia :: (body: *Body, result: *Mat4) -> void #foreign JoltC "JPH_Body_GetInverseInertia";

Body_AddImpulse :: (body: *Body, impulse: *Vec3) -> void #foreign JoltC "JPH_Body_AddImpulse";
Body_AddImpulseAtPosition :: (body: *Body, impulse: *Vec3, position: *RVec3) -> void #foreign JoltC "JPH_Body_AddImpulseAtPosition";
Body_AddAngularImpulse :: (body: *Body, angularImpulse: *Vec3) -> void #foreign JoltC "JPH_Body_AddAngularImpulse";
Body_MoveKinematic :: (body: *Body, targetPosition: *RVec3, targetRotation: *Quat, deltaTime: float) -> void #foreign JoltC "JPH_Body_MoveKinematic";
Body_ApplyBuoyancyImpulse :: (body: *Body, surfacePosition: *RVec3, surfaceNormal: *Vec3, buoyancy: float, linearDrag: float, angularDrag: float, fluidVelocity: *Vec3, gravity: *Vec3, deltaTime: float) -> bool #foreign JoltC "JPH_Body_ApplyBuoyancyImpulse";

Body_IsInBroadPhase :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsInBroadPhase";
Body_IsCollisionCacheInvalid :: (body: *Body) -> bool #foreign JoltC "JPH_Body_IsCollisionCacheInvalid";

Body_GetShape :: (body: *Body) -> *Shape #foreign JoltC "JPH_Body_GetShape";

Body_GetPosition :: (body: *Body, result: *RVec3) -> void #foreign JoltC "JPH_Body_GetPosition";
Body_GetRotation :: (body: *Body, result: *Quat) -> void #foreign JoltC "JPH_Body_GetRotation";
Body_GetWorldTransform :: (body: *Body, result: *RMat4) -> void #foreign JoltC "JPH_Body_GetWorldTransform";
Body_GetCenterOfMassPosition :: (body: *Body, result: *RVec3) -> void #foreign JoltC "JPH_Body_GetCenterOfMassPosition";
Body_GetCenterOfMassTransform :: (body: *Body, result: *RMat4) -> void #foreign JoltC "JPH_Body_GetCenterOfMassTransform";
Body_GetInverseCenterOfMassTransform :: (body: *Body, result: *RMat4) -> void #foreign JoltC "JPH_Body_GetInverseCenterOfMassTransform";

Body_GetWorldSpaceBounds :: (body: *Body, result: *AABox) -> void #foreign JoltC "JPH_Body_GetWorldSpaceBounds";
Body_GetWorldSpaceSurfaceNormal :: (body: *Body, subShapeID: SubShapeID, position: *RVec3, normal: *Vec3) -> void #foreign JoltC "JPH_Body_GetWorldSpaceSurfaceNormal";

Body_GetMotionProperties :: (body: *Body) -> *MotionProperties #foreign JoltC "JPH_Body_GetMotionProperties";
Body_GetMotionPropertiesUnchecked :: (body: *Body) -> *MotionProperties #foreign JoltC "JPH_Body_GetMotionPropertiesUnchecked";

Body_SetUserData :: (body: *Body, userData: u64) -> void #foreign JoltC "JPH_Body_SetUserData";
Body_GetUserData :: (body: *Body) -> u64 #foreign JoltC "JPH_Body_GetUserData";

Body_GetFixedToWorldBody :: () -> *Body #foreign JoltC "JPH_Body_GetFixedToWorldBody";

/* JPH_BroadPhaseLayerFilter_Procs */
BroadPhaseLayerFilter_Procs :: struct {
    ShouldCollide: #type (userData: *void, layer: BroadPhaseLayer) -> bool #c_call;
}

BroadPhaseLayerFilter_SetProcs :: (procs: *BroadPhaseLayerFilter_Procs) -> void #foreign JoltC "JPH_BroadPhaseLayerFilter_SetProcs";
BroadPhaseLayerFilter_Create :: (userData: *void) -> *BroadPhaseLayerFilter #foreign JoltC "JPH_BroadPhaseLayerFilter_Create";
BroadPhaseLayerFilter_Destroy :: (filter: *BroadPhaseLayerFilter) -> void #foreign JoltC "JPH_BroadPhaseLayerFilter_Destroy";

/* JPH_ObjectLayerFilter */
ObjectLayerFilter_Procs :: struct {
    ShouldCollide: #type (userData: *void, layer: ObjectLayer) -> bool #c_call;
}

ObjectLayerFilter_SetProcs :: (procs: *ObjectLayerFilter_Procs) -> void #foreign JoltC "JPH_ObjectLayerFilter_SetProcs";
ObjectLayerFilter_Create :: (userData: *void) -> *ObjectLayerFilter #foreign JoltC "JPH_ObjectLayerFilter_Create";
ObjectLayerFilter_Destroy :: (filter: *ObjectLayerFilter) -> void #foreign JoltC "JPH_ObjectLayerFilter_Destroy";

/* JPH_BodyFilter */
BodyFilter_Procs :: struct {
    ShouldCollide:       #type (userData: *void, bodyID: BodyID) -> bool #c_call;
    ShouldCollideLocked: #type (userData: *void, bodyID: *Body) -> bool #c_call;
}

BodyFilter_SetProcs :: (procs: *BodyFilter_Procs) -> void #foreign JoltC "JPH_BodyFilter_SetProcs";
BodyFilter_Create :: (userData: *void) -> *BodyFilter #foreign JoltC "JPH_BodyFilter_Create";
BodyFilter_Destroy :: (filter: *BodyFilter) -> void #foreign JoltC "JPH_BodyFilter_Destroy";

/* JPH_ShapeFilter */
ShapeFilter_Procs :: struct {
    ShouldCollide:  #type (userData: *void, shape2: *Shape, subShapeIDOfShape2: *SubShapeID) -> bool #c_call;
    ShouldCollide2: #type (userData: *void, shape1: *Shape, subShapeIDOfShape1: *SubShapeID, shape2: *Shape, subShapeIDOfShape2: *SubShapeID) -> bool #c_call;
}

ShapeFilter_SetProcs :: (procs: *ShapeFilter_Procs) -> void #foreign JoltC "JPH_ShapeFilter_SetProcs";
ShapeFilter_Create :: (userData: *void) -> *ShapeFilter #foreign JoltC "JPH_ShapeFilter_Create";
ShapeFilter_Destroy :: (filter: *ShapeFilter) -> void #foreign JoltC "JPH_ShapeFilter_Destroy";
ShapeFilter_GetBodyID2 :: (filter: *ShapeFilter) -> BodyID #foreign JoltC "JPH_ShapeFilter_GetBodyID2";
ShapeFilter_SetBodyID2 :: (filter: *ShapeFilter, id: BodyID) -> void #foreign JoltC "JPH_ShapeFilter_SetBodyID2";

/* JPH_SimShapeFilter */
SimShapeFilter_Procs :: struct {
    ShouldCollide: #type (userData: *void, body1: *Body, shape1: *Shape, subShapeIDOfShape1: *SubShapeID, body2: *Body, shape2: *Shape, subShapeIDOfShape2: *SubShapeID) -> bool #c_call;
}

SimShapeFilter_SetProcs :: (procs: *SimShapeFilter_Procs) -> void #foreign JoltC "JPH_SimShapeFilter_SetProcs";
SimShapeFilter_Create :: (userData: *void) -> *SimShapeFilter #foreign JoltC "JPH_SimShapeFilter_Create";
SimShapeFilter_Destroy :: (filter: *SimShapeFilter) -> void #foreign JoltC "JPH_SimShapeFilter_Destroy";

/* Contact listener */
ContactListener_Procs :: struct {
    OnContactValidate:  #type (userData: *void, body1: *Body, body2: *Body, baseOffset: *RVec3, collisionResult: *CollideShapeResult) -> ValidateResult #c_call;

    OnContactAdded:     #type (userData: *void, body1: *Body, body2: *Body, manifold: *ContactManifold, settings: *ContactSettings) -> void #c_call;

    OnContactPersisted: #type (userData: *void, body1: *Body, body2: *Body, manifold: *ContactManifold, settings: *ContactSettings) -> void #c_call;

    OnContactRemoved:   #type (userData: *void, subShapePair: *SubShapeIDPair) -> void #c_call;
}

ContactListener_SetProcs :: (procs: *ContactListener_Procs) -> void #foreign JoltC "JPH_ContactListener_SetProcs";
ContactListener_Create :: (userData: *void) -> *ContactListener #foreign JoltC "JPH_ContactListener_Create";
ContactListener_Destroy :: (listener: *ContactListener) -> void #foreign JoltC "JPH_ContactListener_Destroy";

/* BodyActivationListener */
BodyActivationListener_Procs :: struct {
    OnBodyActivated:   #type (userData: *void, bodyID: BodyID, bodyUserData: u64) -> void #c_call;
    OnBodyDeactivated: #type (userData: *void, bodyID: BodyID, bodyUserData: u64) -> void #c_call;
}

BodyActivationListener_SetProcs :: (procs: *BodyActivationListener_Procs) -> void #foreign JoltC "JPH_BodyActivationListener_SetProcs";
BodyActivationListener_Create :: (userData: *void) -> *BodyActivationListener #foreign JoltC "JPH_BodyActivationListener_Create";
BodyActivationListener_Destroy :: (listener: *BodyActivationListener) -> void #foreign JoltC "JPH_BodyActivationListener_Destroy";

/* JPH_BodyDrawFilter */
BodyDrawFilter_Procs :: struct {
    ShouldDraw: #type (userData: *void, body: *Body) -> bool #c_call;
}

BodyDrawFilter_SetProcs :: (procs: *BodyDrawFilter_Procs) -> void #foreign JoltC "JPH_BodyDrawFilter_SetProcs";
BodyDrawFilter_Create :: (userData: *void) -> *BodyDrawFilter #foreign JoltC "JPH_BodyDrawFilter_Create";
BodyDrawFilter_Destroy :: (filter: *BodyDrawFilter) -> void #foreign JoltC "JPH_BodyDrawFilter_Destroy";

/* ContactManifold */
ContactManifold_GetWorldSpaceNormal :: (manifold: *ContactManifold, result: *Vec3) -> void #foreign JoltC "JPH_ContactManifold_GetWorldSpaceNormal";
ContactManifold_GetPenetrationDepth :: (manifold: *ContactManifold) -> float #foreign JoltC "JPH_ContactManifold_GetPenetrationDepth";
ContactManifold_GetSubShapeID1 :: (manifold: *ContactManifold) -> SubShapeID #foreign JoltC "JPH_ContactManifold_GetSubShapeID1";
ContactManifold_GetSubShapeID2 :: (manifold: *ContactManifold) -> SubShapeID #foreign JoltC "JPH_ContactManifold_GetSubShapeID2";
ContactManifold_GetPointCount :: (manifold: *ContactManifold) -> u32 #foreign JoltC "JPH_ContactManifold_GetPointCount";
ContactManifold_GetWorldSpaceContactPointOn1 :: (manifold: *ContactManifold, index: u32, result: *RVec3) -> void #foreign JoltC "JPH_ContactManifold_GetWorldSpaceContactPointOn1";
ContactManifold_GetWorldSpaceContactPointOn2 :: (manifold: *ContactManifold, index: u32, result: *RVec3) -> void #foreign JoltC "JPH_ContactManifold_GetWorldSpaceContactPointOn2";

/* CharacterBase */
CharacterBase_Destroy :: (character: *CharacterBase) -> void #foreign JoltC "JPH_CharacterBase_Destroy";
CharacterBase_GetCosMaxSlopeAngle :: (character: *CharacterBase) -> float #foreign JoltC "JPH_CharacterBase_GetCosMaxSlopeAngle";
CharacterBase_SetMaxSlopeAngle :: (character: *CharacterBase, maxSlopeAngle: float) -> void #foreign JoltC "JPH_CharacterBase_SetMaxSlopeAngle";
CharacterBase_GetUp :: (character: *CharacterBase, result: *Vec3) -> void #foreign JoltC "JPH_CharacterBase_GetUp";
CharacterBase_SetUp :: (character: *CharacterBase, value: *Vec3) -> void #foreign JoltC "JPH_CharacterBase_SetUp";
CharacterBase_IsSlopeTooSteep :: (character: *CharacterBase, value: *Vec3) -> bool #foreign JoltC "JPH_CharacterBase_IsSlopeTooSteep";
CharacterBase_GetShape :: (character: *CharacterBase) -> *Shape #foreign JoltC "JPH_CharacterBase_GetShape";

CharacterBase_GetGroundState :: (character: *CharacterBase) -> GroundState #foreign JoltC "JPH_CharacterBase_GetGroundState";
CharacterBase_IsSupported :: (character: *CharacterBase) -> bool #foreign JoltC "JPH_CharacterBase_IsSupported";
CharacterBase_GetGroundPosition :: (character: *CharacterBase, position: *RVec3) -> void #foreign JoltC "JPH_CharacterBase_GetGroundPosition";
CharacterBase_GetGroundNormal :: (character: *CharacterBase, normal: *Vec3) -> void #foreign JoltC "JPH_CharacterBase_GetGroundNormal";
CharacterBase_GetGroundVelocity :: (character: *CharacterBase, velocity: *Vec3) -> void #foreign JoltC "JPH_CharacterBase_GetGroundVelocity";
CharacterBase_GetGroundMaterial :: (character: *CharacterBase) -> *PhysicsMaterial #foreign JoltC "JPH_CharacterBase_GetGroundMaterial";
CharacterBase_GetGroundBodyId :: (character: *CharacterBase) -> BodyID #foreign JoltC "JPH_CharacterBase_GetGroundBodyId";
CharacterBase_GetGroundSubShapeId :: (character: *CharacterBase) -> SubShapeID #foreign JoltC "JPH_CharacterBase_GetGroundSubShapeId";
CharacterBase_GetGroundUserData :: (character: *CharacterBase) -> u64 #foreign JoltC "JPH_CharacterBase_GetGroundUserData";

/* CharacterSettings */
CharacterSettings_Init :: (settings: *CharacterSettings) -> void #foreign JoltC "JPH_CharacterSettings_Init";

/* Character */
Character_Create :: (settings: *CharacterSettings, position: *RVec3, rotation: *Quat, userData: u64, system: *PhysicsSystem) -> *Character #foreign JoltC "JPH_Character_Create";

Character_AddToPhysicsSystem :: (character: *Character, activationMode: Activation, lockBodies: bool) -> void #foreign JoltC "JPH_Character_AddToPhysicsSystem";
Character_RemoveFromPhysicsSystem :: (character: *Character, lockBodies: bool) -> void #foreign JoltC "JPH_Character_RemoveFromPhysicsSystem";
Character_Activate :: (character: *Character, lockBodies: bool) -> void #foreign JoltC "JPH_Character_Activate";
Character_PostSimulation :: (character: *Character, maxSeparationDistance: float, lockBodies: bool) -> void #foreign JoltC "JPH_Character_PostSimulation";
Character_SetLinearAndAngularVelocity :: (character: *Character, linearVelocity: *Vec3, angularVelocity: *Vec3, lockBodies: bool) -> void #foreign JoltC "JPH_Character_SetLinearAndAngularVelocity";
Character_GetLinearVelocity :: (character: *Character, result: *Vec3) -> void #foreign JoltC "JPH_Character_GetLinearVelocity";
Character_SetLinearVelocity :: (character: *Character, value: *Vec3, lockBodies: bool) -> void #foreign JoltC "JPH_Character_SetLinearVelocity";
Character_AddLinearVelocity :: (character: *Character, value: *Vec3, lockBodies: bool) -> void #foreign JoltC "JPH_Character_AddLinearVelocity";
Character_AddImpulse :: (character: *Character, value: *Vec3, lockBodies: bool) -> void #foreign JoltC "JPH_Character_AddImpulse";
Character_GetBodyID :: (character: *Character) -> BodyID #foreign JoltC "JPH_Character_GetBodyID";

Character_GetPositionAndRotation :: (character: *Character, position: *RVec3, rotation: *Quat, lockBodies: bool) -> void #foreign JoltC "JPH_Character_GetPositionAndRotation";
Character_SetPositionAndRotation :: (character: *Character, position: *RVec3, rotation: *Quat, activationMode: Activation, lockBodies: bool) -> void #foreign JoltC "JPH_Character_SetPositionAndRotation";
Character_GetPosition :: (character: *Character, position: *RVec3, lockBodies: bool) -> void #foreign JoltC "JPH_Character_GetPosition";
Character_SetPosition :: (character: *Character, position: *RVec3, activationMode: Activation, lockBodies: bool) -> void #foreign JoltC "JPH_Character_SetPosition";
Character_GetRotation :: (character: *Character, rotation: *Quat, lockBodies: bool) -> void #foreign JoltC "JPH_Character_GetRotation";
Character_SetRotation :: (character: *Character, rotation: *Quat, activationMode: Activation, lockBodies: bool) -> void #foreign JoltC "JPH_Character_SetRotation";
Character_GetCenterOfMassPosition :: (character: *Character, result: *RVec3, lockBodies: bool) -> void #foreign JoltC "JPH_Character_GetCenterOfMassPosition";
Character_GetWorldTransform :: (character: *Character, result: *RMat4, lockBodies: bool) -> void #foreign JoltC "JPH_Character_GetWorldTransform";
Character_GetLayer :: (character: *Character) -> ObjectLayer #foreign JoltC "JPH_Character_GetLayer";
Character_SetLayer :: (character: *Character, value: ObjectLayer, lockBodies: bool) -> void #foreign JoltC "JPH_Character_SetLayer";
Character_SetShape :: (character: *Character, shape: *Shape, maxPenetrationDepth: float, lockBodies: bool) -> void #foreign JoltC "JPH_Character_SetShape";

/* CharacterVirtualSettings */
CharacterVirtualSettings_Init :: (settings: *CharacterVirtualSettings) -> void #foreign JoltC "JPH_CharacterVirtualSettings_Init";

/* CharacterVirtual */
CharacterVirtual_Create :: (settings: *CharacterVirtualSettings, position: *RVec3, rotation: *Quat, userData: u64, system: *PhysicsSystem) -> *CharacterVirtual #foreign JoltC "JPH_CharacterVirtual_Create";

CharacterVirtual_GetID :: (character: *CharacterVirtual) -> CharacterID #foreign JoltC "JPH_CharacterVirtual_GetID";
CharacterVirtual_SetListener :: (character: *CharacterVirtual, listener: *CharacterContactListener) -> void #foreign JoltC "JPH_CharacterVirtual_SetListener";
CharacterVirtual_SetCharacterVsCharacterCollision :: (character: *CharacterVirtual, characterVsCharacterCollision: *CharacterVsCharacterCollision) -> void #foreign JoltC "JPH_CharacterVirtual_SetCharacterVsCharacterCollision";

CharacterVirtual_GetLinearVelocity :: (character: *CharacterVirtual, velocity: *Vec3) -> void #foreign JoltC "JPH_CharacterVirtual_GetLinearVelocity";
CharacterVirtual_SetLinearVelocity :: (character: *CharacterVirtual, velocity: *Vec3) -> void #foreign JoltC "JPH_CharacterVirtual_SetLinearVelocity";
CharacterVirtual_GetPosition :: (character: *CharacterVirtual, position: *RVec3) -> void #foreign JoltC "JPH_CharacterVirtual_GetPosition";
CharacterVirtual_SetPosition :: (character: *CharacterVirtual, position: *RVec3) -> void #foreign JoltC "JPH_CharacterVirtual_SetPosition";
CharacterVirtual_GetRotation :: (character: *CharacterVirtual, rotation: *Quat) -> void #foreign JoltC "JPH_CharacterVirtual_GetRotation";
CharacterVirtual_SetRotation :: (character: *CharacterVirtual, rotation: *Quat) -> void #foreign JoltC "JPH_CharacterVirtual_SetRotation";
CharacterVirtual_GetWorldTransform :: (character: *CharacterVirtual, result: *RMat4) -> void #foreign JoltC "JPH_CharacterVirtual_GetWorldTransform";
CharacterVirtual_GetCenterOfMassTransform :: (character: *CharacterVirtual, result: *RMat4) -> void #foreign JoltC "JPH_CharacterVirtual_GetCenterOfMassTransform";
CharacterVirtual_GetMass :: (character: *CharacterVirtual) -> float #foreign JoltC "JPH_CharacterVirtual_GetMass";
CharacterVirtual_SetMass :: (character: *CharacterVirtual, value: float) -> void #foreign JoltC "JPH_CharacterVirtual_SetMass";
CharacterVirtual_GetMaxStrength :: (character: *CharacterVirtual) -> float #foreign JoltC "JPH_CharacterVirtual_GetMaxStrength";
CharacterVirtual_SetMaxStrength :: (character: *CharacterVirtual, value: float) -> void #foreign JoltC "JPH_CharacterVirtual_SetMaxStrength";

CharacterVirtual_GetPenetrationRecoverySpeed :: (character: *CharacterVirtual) -> float #foreign JoltC "JPH_CharacterVirtual_GetPenetrationRecoverySpeed";
CharacterVirtual_SetPenetrationRecoverySpeed :: (character: *CharacterVirtual, value: float) -> void #foreign JoltC "JPH_CharacterVirtual_SetPenetrationRecoverySpeed";
CharacterVirtual_GetEnhancedInternalEdgeRemoval :: (character: *CharacterVirtual) -> bool #foreign JoltC "JPH_CharacterVirtual_GetEnhancedInternalEdgeRemoval";
CharacterVirtual_SetEnhancedInternalEdgeRemoval :: (character: *CharacterVirtual, value: bool) -> void #foreign JoltC "JPH_CharacterVirtual_SetEnhancedInternalEdgeRemoval";
CharacterVirtual_GetCharacterPadding :: (character: *CharacterVirtual) -> float #foreign JoltC "JPH_CharacterVirtual_GetCharacterPadding";
CharacterVirtual_GetMaxNumHits :: (character: *CharacterVirtual) -> u32 #foreign JoltC "JPH_CharacterVirtual_GetMaxNumHits";
CharacterVirtual_SetMaxNumHits :: (character: *CharacterVirtual, value: u32) -> void #foreign JoltC "JPH_CharacterVirtual_SetMaxNumHits";
CharacterVirtual_GetHitReductionCosMaxAngle :: (character: *CharacterVirtual) -> float #foreign JoltC "JPH_CharacterVirtual_GetHitReductionCosMaxAngle";
CharacterVirtual_SetHitReductionCosMaxAngle :: (character: *CharacterVirtual, value: float) -> void #foreign JoltC "JPH_CharacterVirtual_SetHitReductionCosMaxAngle";
CharacterVirtual_GetMaxHitsExceeded :: (character: *CharacterVirtual) -> bool #foreign JoltC "JPH_CharacterVirtual_GetMaxHitsExceeded";
CharacterVirtual_GetShapeOffset :: (character: *CharacterVirtual, result: *Vec3) -> void #foreign JoltC "JPH_CharacterVirtual_GetShapeOffset";
CharacterVirtual_SetShapeOffset :: (character: *CharacterVirtual, value: *Vec3) -> void #foreign JoltC "JPH_CharacterVirtual_SetShapeOffset";
CharacterVirtual_GetUserData :: (character: *CharacterVirtual) -> u64 #foreign JoltC "JPH_CharacterVirtual_GetUserData";
CharacterVirtual_SetUserData :: (character: *CharacterVirtual, value: u64) -> void #foreign JoltC "JPH_CharacterVirtual_SetUserData";
CharacterVirtual_GetInnerBodyID :: (character: *CharacterVirtual) -> BodyID #foreign JoltC "JPH_CharacterVirtual_GetInnerBodyID";

CharacterVirtual_CancelVelocityTowardsSteepSlopes :: (character: *CharacterVirtual, desiredVelocity: *Vec3, velocity: *Vec3) -> void #foreign JoltC "JPH_CharacterVirtual_CancelVelocityTowardsSteepSlopes";
CharacterVirtual_StartTrackingContactChanges :: (character: *CharacterVirtual) -> void #foreign JoltC "JPH_CharacterVirtual_StartTrackingContactChanges";
CharacterVirtual_FinishTrackingContactChanges :: (character: *CharacterVirtual) -> void #foreign JoltC "JPH_CharacterVirtual_FinishTrackingContactChanges";
CharacterVirtual_Update :: (character: *CharacterVirtual, deltaTime: float, layer: ObjectLayer, system: *PhysicsSystem, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> void #foreign JoltC "JPH_CharacterVirtual_Update";

CharacterVirtual_ExtendedUpdate :: (character: *CharacterVirtual, deltaTime: float, settings: *ExtendedUpdateSettings, layer: ObjectLayer, system: *PhysicsSystem, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> void #foreign JoltC "JPH_CharacterVirtual_ExtendedUpdate";

CharacterVirtual_RefreshContacts :: (character: *CharacterVirtual, layer: ObjectLayer, system: *PhysicsSystem, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> void #foreign JoltC "JPH_CharacterVirtual_RefreshContacts";

CharacterVirtual_CanWalkStairs :: (character: *CharacterVirtual, linearVelocity: *Vec3) -> bool #foreign JoltC "JPH_CharacterVirtual_CanWalkStairs";
CharacterVirtual_WalkStairs :: (character: *CharacterVirtual, deltaTime: float, stepUp: *Vec3, stepForward: *Vec3, stepForwardTest: *Vec3, stepDownExtra: *Vec3, layer: ObjectLayer, system: *PhysicsSystem, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_CharacterVirtual_WalkStairs";

CharacterVirtual_StickToFloor :: (character: *CharacterVirtual, stepDown: *Vec3, layer: ObjectLayer, system: *PhysicsSystem, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_CharacterVirtual_StickToFloor";

CharacterVirtual_UpdateGroundVelocity :: (character: *CharacterVirtual) -> void #foreign JoltC "JPH_CharacterVirtual_UpdateGroundVelocity";
CharacterVirtual_SetShape :: (character: *CharacterVirtual, shape: *Shape, maxPenetrationDepth: float, layer: ObjectLayer, system: *PhysicsSystem, bodyFilter: *BodyFilter, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_CharacterVirtual_SetShape";
CharacterVirtual_SetInnerBodyShape :: (character: *CharacterVirtual, shape: *Shape) -> void #foreign JoltC "JPH_CharacterVirtual_SetInnerBodyShape";

CharacterVirtual_GetNumActiveContacts :: (character: *CharacterVirtual) -> u32 #foreign JoltC "JPH_CharacterVirtual_GetNumActiveContacts";
CharacterVirtual_GetActiveContact :: (character: *CharacterVirtual, index: u32, result: *CharacterVirtualContact) -> void #foreign JoltC "JPH_CharacterVirtual_GetActiveContact";

CharacterVirtual_HasCollidedWithBody :: (character: *CharacterVirtual, body: BodyID) -> bool #foreign JoltC "JPH_CharacterVirtual_HasCollidedWithBody";
CharacterVirtual_HasCollidedWith :: (character: *CharacterVirtual, other: CharacterID) -> bool #foreign JoltC "JPH_CharacterVirtual_HasCollidedWith";
CharacterVirtual_HasCollidedWithCharacter :: (character: *CharacterVirtual, other: *CharacterVirtual) -> bool #foreign JoltC "JPH_CharacterVirtual_HasCollidedWithCharacter";

/* CharacterContactListener */
CharacterContactListener_Procs :: struct {
    OnAdjustBodyVelocity:        #type (userData: *void, character: *CharacterVirtual, body2: *Body, ioLinearVelocity: *Vec3, ioAngularVelocity: *Vec3) -> void #c_call;

    OnContactValidate:           #type (userData: *void, character: *CharacterVirtual, bodyID2: BodyID, subShapeID2: SubShapeID) -> bool #c_call;

    OnCharacterContactValidate:  #type (userData: *void, character: *CharacterVirtual, otherCharacter: *CharacterVirtual, subShapeID2: SubShapeID) -> bool #c_call;

    OnContactAdded:              #type (userData: *void, character: *CharacterVirtual, bodyID2: BodyID, subShapeID2: SubShapeID, contactPosition: *RVec3, contactNormal: *Vec3, ioSettings: *CharacterContactSettings) -> void #c_call;

    OnContactPersisted:          #type (userData: *void, character: *CharacterVirtual, bodyID2: BodyID, subShapeID2: SubShapeID, contactPosition: *RVec3, contactNormal: *Vec3, ioSettings: *CharacterContactSettings) -> void #c_call;

    OnContactRemoved:            #type (userData: *void, character: *CharacterVirtual, bodyID2: BodyID, subShapeID2: SubShapeID) -> void #c_call;

    OnCharacterContactAdded:     #type (userData: *void, character: *CharacterVirtual, otherCharacter: *CharacterVirtual, subShapeID2: SubShapeID, contactPosition: *RVec3, contactNormal: *Vec3, ioSettings: *CharacterContactSettings) -> void #c_call;

    OnCharacterContactPersisted: #type (userData: *void, character: *CharacterVirtual, otherCharacter: *CharacterVirtual, subShapeID2: SubShapeID, contactPosition: *RVec3, contactNormal: *Vec3, ioSettings: *CharacterContactSettings) -> void #c_call;

    OnCharacterContactRemoved:   #type (userData: *void, character: *CharacterVirtual, otherCharacterID: CharacterID, subShapeID2: SubShapeID) -> void #c_call;

    OnContactSolve:              #type (userData: *void, character: *CharacterVirtual, bodyID2: BodyID, subShapeID2: SubShapeID, contactPosition: *RVec3, contactNormal: *Vec3, contactVelocity: *Vec3, contactMaterial: *PhysicsMaterial, characterVelocity: *Vec3, newCharacterVelocity: *Vec3) -> void #c_call;

    OnCharacterContactSolve:     #type (userData: *void, character: *CharacterVirtual, otherCharacter: *CharacterVirtual, subShapeID2: SubShapeID, contactPosition: *RVec3, contactNormal: *Vec3, contactVelocity: *Vec3, contactMaterial: *PhysicsMaterial, characterVelocity: *Vec3, newCharacterVelocity: *Vec3) -> void #c_call;
}

CharacterContactListener_SetProcs :: (procs: *CharacterContactListener_Procs) -> void #foreign JoltC "JPH_CharacterContactListener_SetProcs";
CharacterContactListener_Create :: (userData: *void) -> *CharacterContactListener #foreign JoltC "JPH_CharacterContactListener_Create";
CharacterContactListener_Destroy :: (listener: *CharacterContactListener) -> void #foreign JoltC "JPH_CharacterContactListener_Destroy";

/* JPH_CharacterVsCharacterCollision */
CharacterVsCharacterCollision_Procs :: struct {
    CollideCharacter: #type (userData: *void, character: *CharacterVirtual, centerOfMassTransform: *RMat4, collideShapeSettings: *CollideShapeSettings, baseOffset: *RVec3) -> void #c_call;

    CastCharacter:    #type (userData: *void, character: *CharacterVirtual, centerOfMassTransform: *RMat4, direction: *Vec3, shapeCastSettings: *ShapeCastSettings, baseOffset: *RVec3) -> void #c_call;
}

CharacterVsCharacterCollision_SetProcs :: (procs: *CharacterVsCharacterCollision_Procs) -> void #foreign JoltC "JPH_CharacterVsCharacterCollision_SetProcs";
CharacterVsCharacterCollision_Create :: (userData: *void) -> *CharacterVsCharacterCollision #foreign JoltC "JPH_CharacterVsCharacterCollision_Create";
CharacterVsCharacterCollision_CreateSimple :: () -> *CharacterVsCharacterCollision #foreign JoltC "JPH_CharacterVsCharacterCollision_CreateSimple";
CharacterVsCharacterCollisionSimple_AddCharacter :: (characterVsCharacter: *CharacterVsCharacterCollision, character: *CharacterVirtual) -> void #foreign JoltC "JPH_CharacterVsCharacterCollisionSimple_AddCharacter";
CharacterVsCharacterCollisionSimple_RemoveCharacter :: (characterVsCharacter: *CharacterVsCharacterCollision, character: *CharacterVirtual) -> void #foreign JoltC "JPH_CharacterVsCharacterCollisionSimple_RemoveCharacter";
CharacterVsCharacterCollision_Destroy :: (listener: *CharacterVsCharacterCollision) -> void #foreign JoltC "JPH_CharacterVsCharacterCollision_Destroy";

/* CollisionDispatch */
CollisionDispatch_CollideShapeVsShape :: (shape1: *Shape, shape2: *Shape, scale1: *Vec3, scale2: *Vec3, centerOfMassTransform1: *Mat4, centerOfMassTransform2: *Mat4, collideShapeSettings: *CollideShapeSettings, callback: CollideShapeCollectorCallback, userData: *void, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_CollisionDispatch_CollideShapeVsShape";

CollisionDispatch_CastShapeVsShapeLocalSpace :: (direction: *Vec3, shape1: *Shape, shape2: *Shape, scale1InShape2LocalSpace: *Vec3, scale2: *Vec3, centerOfMassTransform1InShape2LocalSpace: *Mat4, centerOfMassWorldTransform2: *Mat4, shapeCastSettings: *ShapeCastSettings, callback: CastShapeCollectorCallback, userData: *void, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_CollisionDispatch_CastShapeVsShapeLocalSpace";

CollisionDispatch_CastShapeVsShapeWorldSpace :: (direction: *Vec3, shape1: *Shape, shape2: *Shape, scale1: *Vec3, inScale2: *Vec3, centerOfMassWorldTransform1: *Mat4, centerOfMassWorldTransform2: *Mat4, shapeCastSettings: *ShapeCastSettings, callback: CastShapeCollectorCallback, userData: *void, shapeFilter: *ShapeFilter) -> bool #foreign JoltC "JPH_CollisionDispatch_CastShapeVsShapeWorldSpace";

/* DebugRenderer */
DebugRenderer_Procs :: struct {
    DrawLine:     #type (userData: *void, from: *RVec3, to: *RVec3, color: Color) -> void #c_call;
    DrawTriangle: #type (userData: *void, v1: *RVec3, v2: *RVec3, v3: *RVec3, color: Color, castShadow: DebugRenderer_CastShadow) -> void #c_call;
    DrawText3D:   #type (userData: *void, position: *RVec3, str: *u8, color: Color, height: float) -> void #c_call;
}

DebugRenderer_SetProcs :: (procs: *DebugRenderer_Procs) -> void #foreign JoltC "JPH_DebugRenderer_SetProcs";
DebugRenderer_Create :: (userData: *void) -> *DebugRenderer #foreign JoltC "JPH_DebugRenderer_Create";
DebugRenderer_Destroy :: (renderer: *DebugRenderer) -> void #foreign JoltC "JPH_DebugRenderer_Destroy";
DebugRenderer_NextFrame :: (renderer: *DebugRenderer) -> void #foreign JoltC "JPH_DebugRenderer_NextFrame";
DebugRenderer_SetCameraPos :: (renderer: *DebugRenderer, position: *RVec3) -> void #foreign JoltC "JPH_DebugRenderer_SetCameraPos";

DebugRenderer_DrawLine :: (renderer: *DebugRenderer, from: *RVec3, to: *RVec3, color: Color) -> void #foreign JoltC "JPH_DebugRenderer_DrawLine";
DebugRenderer_DrawWireBox :: (renderer: *DebugRenderer, box: *AABox, color: Color) -> void #foreign JoltC "JPH_DebugRenderer_DrawWireBox";
DebugRenderer_DrawWireBox2 :: (renderer: *DebugRenderer, matrix: *RMat4, box: *AABox, color: Color) -> void #foreign JoltC "JPH_DebugRenderer_DrawWireBox2";
DebugRenderer_DrawMarker :: (renderer: *DebugRenderer, position: *RVec3, color: Color, size: float) -> void #foreign JoltC "JPH_DebugRenderer_DrawMarker";
DebugRenderer_DrawArrow :: (renderer: *DebugRenderer, from: *RVec3, to: *RVec3, color: Color, size: float) -> void #foreign JoltC "JPH_DebugRenderer_DrawArrow";
DebugRenderer_DrawCoordinateSystem :: (renderer: *DebugRenderer, matrix: *RMat4, size: float) -> void #foreign JoltC "JPH_DebugRenderer_DrawCoordinateSystem";
DebugRenderer_DrawPlane :: (renderer: *DebugRenderer, point: *RVec3, normal: *Vec3, color: Color, size: float) -> void #foreign JoltC "JPH_DebugRenderer_DrawPlane";
DebugRenderer_DrawWireTriangle :: (renderer: *DebugRenderer, v1: *RVec3, v2: *RVec3, v3: *RVec3, color: Color) -> void #foreign JoltC "JPH_DebugRenderer_DrawWireTriangle";
DebugRenderer_DrawWireSphere :: (renderer: *DebugRenderer, center: *RVec3, radius: float, color: Color, level: s32) -> void #foreign JoltC "JPH_DebugRenderer_DrawWireSphere";
DebugRenderer_DrawWireUnitSphere :: (renderer: *DebugRenderer, matrix: *RMat4, color: Color, level: s32) -> void #foreign JoltC "JPH_DebugRenderer_DrawWireUnitSphere";
DebugRenderer_DrawTriangle :: (renderer: *DebugRenderer, v1: *RVec3, v2: *RVec3, v3: *RVec3, color: Color, castShadow: DebugRenderer_CastShadow) -> void #foreign JoltC "JPH_DebugRenderer_DrawTriangle";
DebugRenderer_DrawBox :: (renderer: *DebugRenderer, box: *AABox, color: Color, castShadow: DebugRenderer_CastShadow, drawMode: DebugRenderer_DrawMode) -> void #foreign JoltC "JPH_DebugRenderer_DrawBox";
DebugRenderer_DrawBox2 :: (renderer: *DebugRenderer, matrix: *RMat4, box: *AABox, color: Color, castShadow: DebugRenderer_CastShadow, drawMode: DebugRenderer_DrawMode) -> void #foreign JoltC "JPH_DebugRenderer_DrawBox2";
DebugRenderer_DrawSphere :: (renderer: *DebugRenderer, center: *RVec3, radius: float, color: Color, castShadow: DebugRenderer_CastShadow, drawMode: DebugRenderer_DrawMode) -> void #foreign JoltC "JPH_DebugRenderer_DrawSphere";
DebugRenderer_DrawUnitSphere :: (renderer: *DebugRenderer, matrix: RMat4, color: Color, castShadow: DebugRenderer_CastShadow, drawMode: DebugRenderer_DrawMode) -> void #foreign JoltC "JPH_DebugRenderer_DrawUnitSphere";
DebugRenderer_DrawCapsule :: (renderer: *DebugRenderer, matrix: *RMat4, halfHeightOfCylinder: float, radius: float, color: Color, castShadow: DebugRenderer_CastShadow, drawMode: DebugRenderer_DrawMode) -> void #foreign JoltC "JPH_DebugRenderer_DrawCapsule";
DebugRenderer_DrawCylinder :: (renderer: *DebugRenderer, matrix: *RMat4, halfHeight: float, radius: float, color: Color, castShadow: DebugRenderer_CastShadow, drawMode: DebugRenderer_DrawMode) -> void #foreign JoltC "JPH_DebugRenderer_DrawCylinder";
DebugRenderer_DrawOpenCone :: (renderer: *DebugRenderer, top: *RVec3, axis: *Vec3, perpendicular: *Vec3, halfAngle: float, length: float, color: Color, castShadow: DebugRenderer_CastShadow, drawMode: DebugRenderer_DrawMode) -> void #foreign JoltC "JPH_DebugRenderer_DrawOpenCone";
DebugRenderer_DrawSwingConeLimits :: (renderer: *DebugRenderer, matrix: *RMat4, swingYHalfAngle: float, swingZHalfAngle: float, edgeLength: float, color: Color, castShadow: DebugRenderer_CastShadow, drawMode: DebugRenderer_DrawMode) -> void #foreign JoltC "JPH_DebugRenderer_DrawSwingConeLimits";
DebugRenderer_DrawSwingPyramidLimits :: (renderer: *DebugRenderer, matrix: *RMat4, minSwingYAngle: float, maxSwingYAngle: float, minSwingZAngle: float, maxSwingZAngle: float, edgeLength: float, color: Color, castShadow: DebugRenderer_CastShadow, drawMode: DebugRenderer_DrawMode) -> void #foreign JoltC "JPH_DebugRenderer_DrawSwingPyramidLimits";
DebugRenderer_DrawPie :: (renderer: *DebugRenderer, center: *RVec3, radius: float, normal: *Vec3, axis: *Vec3, minAngle: float, maxAngle: float, color: Color, castShadow: DebugRenderer_CastShadow, drawMode: DebugRenderer_DrawMode) -> void #foreign JoltC "JPH_DebugRenderer_DrawPie";
DebugRenderer_DrawTaperedCylinder :: (renderer: *DebugRenderer, inMatrix: *RMat4, top: float, bottom: float, topRadius: float, bottomRadius: float, color: Color, castShadow: DebugRenderer_CastShadow, drawMode: DebugRenderer_DrawMode) -> void #foreign JoltC "JPH_DebugRenderer_DrawTaperedCylinder";

/* Skeleton */
SkeletonJoint :: struct {
    name:             *u8;
    parentName:       *u8;
    parentJointIndex: s32;
}

Skeleton_Create :: () -> *Skeleton #foreign JoltC "JPH_Skeleton_Create";
Skeleton_Destroy :: (skeleton: *Skeleton) -> void #foreign JoltC "JPH_Skeleton_Destroy";

Skeleton_AddJoint :: (skeleton: *Skeleton, name: *u8) -> u32 #foreign JoltC "JPH_Skeleton_AddJoint";
Skeleton_AddJoint2 :: (skeleton: *Skeleton, name: *u8, parentIndex: s32) -> u32 #foreign JoltC "JPH_Skeleton_AddJoint2";
Skeleton_AddJoint3 :: (skeleton: *Skeleton, name: *u8, parentName: *u8) -> u32 #foreign JoltC "JPH_Skeleton_AddJoint3";
Skeleton_GetJointCount :: (skeleton: *Skeleton) -> s32 #foreign JoltC "JPH_Skeleton_GetJointCount";
Skeleton_GetJoint :: (skeleton: *Skeleton, index: s32, joint: *SkeletonJoint) -> void #foreign JoltC "JPH_Skeleton_GetJoint";
Skeleton_GetJointIndex :: (skeleton: *Skeleton, name: *u8) -> s32 #foreign JoltC "JPH_Skeleton_GetJointIndex";
Skeleton_CalculateParentJointIndices :: (skeleton: *Skeleton) -> void #foreign JoltC "JPH_Skeleton_CalculateParentJointIndices";
Skeleton_AreJointsCorrectlyOrdered :: (skeleton: *Skeleton) -> bool #foreign JoltC "JPH_Skeleton_AreJointsCorrectlyOrdered";

/* Ragdoll */
RagdollSettings_Create :: () -> *RagdollSettings #foreign JoltC "JPH_RagdollSettings_Create";
RagdollSettings_Destroy :: (settings: *RagdollSettings) -> void #foreign JoltC "JPH_RagdollSettings_Destroy";

RagdollSettings_GetSkeleton :: (character: *RagdollSettings) -> *Skeleton #foreign JoltC "JPH_RagdollSettings_GetSkeleton";
RagdollSettings_SetSkeleton :: (character: *RagdollSettings, skeleton: *Skeleton) -> void #foreign JoltC "JPH_RagdollSettings_SetSkeleton";
RagdollSettings_Stabilize :: (settings: *RagdollSettings) -> bool #foreign JoltC "JPH_RagdollSettings_Stabilize";
RagdollSettings_DisableParentChildCollisions :: (settings: *RagdollSettings, jointMatrices: *Mat4, minSeparationDistance: float) -> void #foreign JoltC "JPH_RagdollSettings_DisableParentChildCollisions";
RagdollSettings_CalculateBodyIndexToConstraintIndex :: (settings: *RagdollSettings) -> void #foreign JoltC "JPH_RagdollSettings_CalculateBodyIndexToConstraintIndex";
RagdollSettings_GetConstraintIndexForBodyIndex :: (settings: *RagdollSettings, bodyIndex: s32) -> s32 #foreign JoltC "JPH_RagdollSettings_GetConstraintIndexForBodyIndex";
RagdollSettings_CalculateConstraintIndexToBodyIdxPair :: (settings: *RagdollSettings) -> void #foreign JoltC "JPH_RagdollSettings_CalculateConstraintIndexToBodyIdxPair";

RagdollSettings_CreateRagdoll :: (settings: *RagdollSettings, system: *PhysicsSystem, collisionGroup: CollisionGroupID, userData: u64) -> *Ragdoll #foreign JoltC "JPH_RagdollSettings_CreateRagdoll";
Ragdoll_Destroy :: (ragdoll: *Ragdoll) -> void #foreign JoltC "JPH_Ragdoll_Destroy";
Ragdoll_AddToPhysicsSystem :: (ragdoll: *Ragdoll, activationMode: Activation, lockBodies: bool) -> void #foreign JoltC "JPH_Ragdoll_AddToPhysicsSystem";
Ragdoll_RemoveFromPhysicsSystem :: (ragdoll: *Ragdoll, lockBodies: bool) -> void #foreign JoltC "JPH_Ragdoll_RemoveFromPhysicsSystem";
Ragdoll_Activate :: (ragdoll: *Ragdoll, lockBodies: bool) -> void #foreign JoltC "JPH_Ragdoll_Activate";
Ragdoll_IsActive :: (ragdoll: *Ragdoll, lockBodies: bool) -> bool #foreign JoltC "JPH_Ragdoll_IsActive";
Ragdoll_ResetWarmStart :: (ragdoll: *Ragdoll) -> void #foreign JoltC "JPH_Ragdoll_ResetWarmStart";

/* JPH_EstimateCollisionResponse */
EstimateCollisionResponse :: (body1: *Body, body2: *Body, manifold: *ContactManifold, combinedFriction: float, combinedRestitution: float, minVelocityForRestitution: float, numIterations: u32, result: *CollisionEstimationResult) -> void #foreign JoltC "JPH_EstimateCollisionResponse";

WheelSettings :: struct {}
WheelSettingsWV :: struct {}
WheelSettingsTV :: struct {}

Wheel :: struct {}
WheelWV :: struct {}
WheelTV :: struct {}

VehicleTransmissionSettings :: struct {}
VehicleCollisionTester :: struct {}
VehicleCollisionTesterRay :: struct {}
VehicleCollisionTesterCastSphere :: struct {}
VehicleCollisionTesterCastCylinder :: struct {}
VehicleConstraint :: struct {}

VehicleControllerSettings :: struct {}
WheeledVehicleControllerSettings :: struct {}
MotorcycleControllerSettings :: struct {}
TrackedVehicleControllerSettings :: struct {}

WheeledVehicleController :: struct {}
MotorcycleController :: struct {}
TrackedVehicleController :: struct {}

VehicleController :: struct {}

VehicleAntiRollBar :: struct {
    leftWheel:  s32;
    rightWheel: s32;
    stiffness:  float;
}

VehicleConstraintSettings :: struct {
    base:              ConstraintSettings; /* Inherits JPH_ConstraintSettings */

    up:                Vec3;
    forward:           Vec3;
    maxPitchRollAngle: float;
    wheelsCount:       u32;
    wheels:            **WheelSettings;
    antiRollBarsCount: u32;
    antiRollBars:      *VehicleAntiRollBar;
    controller:        *VehicleControllerSettings;
}

VehicleEngineSettings :: struct {
    maxTorque:      float;
    minRPM:         float;
    maxRPM:         float;

    //LinearCurve			normalizedTorque;
    inertia:        float;
    angularDamping: float;
}

VehicleDifferentialSettings :: struct {
    leftWheel:         s32;
    rightWheel:        s32;
    differentialRatio: float;
    leftRightSplit:    float;
    limitedSlipRatio:  float;
    engineTorqueRatio: float;
}

VehicleConstraintSettings_Init :: (settings: *VehicleConstraintSettings) -> void #foreign JoltC "JPH_VehicleConstraintSettings_Init";

VehicleConstraint_Create :: (body: *Body, settings: *VehicleConstraintSettings) -> *VehicleConstraint #foreign JoltC "JPH_VehicleConstraint_Create";
VehicleConstraint_AsPhysicsStepListener :: (constraint: *VehicleConstraint) -> *PhysicsStepListener #foreign JoltC "JPH_VehicleConstraint_AsPhysicsStepListener";

VehicleConstraint_SetMaxPitchRollAngle :: (constraint: *VehicleConstraint, maxPitchRollAngle: float) -> void #foreign JoltC "JPH_VehicleConstraint_SetMaxPitchRollAngle";
VehicleConstraint_SetVehicleCollisionTester :: (constraint: *VehicleConstraint, tester: *VehicleCollisionTester) -> void #foreign JoltC "JPH_VehicleConstraint_SetVehicleCollisionTester";

VehicleConstraint_OverrideGravity :: (constraint: *VehicleConstraint, value: *Vec3) -> void #foreign JoltC "JPH_VehicleConstraint_OverrideGravity";
VehicleConstraint_IsGravityOverridden :: (constraint: *VehicleConstraint) -> bool #foreign JoltC "JPH_VehicleConstraint_IsGravityOverridden";
VehicleConstraint_GetGravityOverride :: (constraint: *VehicleConstraint, result: *Vec3) -> void #foreign JoltC "JPH_VehicleConstraint_GetGravityOverride";
VehicleConstraint_ResetGravityOverride :: (constraint: *VehicleConstraint) -> void #foreign JoltC "JPH_VehicleConstraint_ResetGravityOverride";

VehicleConstraint_GetLocalForward :: (constraint: *VehicleConstraint, result: *Vec3) -> void #foreign JoltC "JPH_VehicleConstraint_GetLocalForward";
VehicleConstraint_GetLocalUp :: (constraint: *VehicleConstraint, result: *Vec3) -> void #foreign JoltC "JPH_VehicleConstraint_GetLocalUp";
VehicleConstraint_GetWorldUp :: (constraint: *VehicleConstraint, result: *Vec3) -> void #foreign JoltC "JPH_VehicleConstraint_GetWorldUp";

VehicleConstraint_GetVehicleBody :: (constraint: *VehicleConstraint) -> *Body #foreign JoltC "JPH_VehicleConstraint_GetVehicleBody";
VehicleConstraint_GetController :: (constraint: *VehicleConstraint) -> *VehicleController #foreign JoltC "JPH_VehicleConstraint_GetController";
VehicleConstraint_GetWheelsCount :: (constraint: *VehicleConstraint) -> u32 #foreign JoltC "JPH_VehicleConstraint_GetWheelsCount";
VehicleConstraint_GetWheel :: (constraint: *VehicleConstraint, index: u32) -> *Wheel #foreign JoltC "JPH_VehicleConstraint_GetWheel";
VehicleConstraint_GetWheelLocalBasis :: (constraint: *VehicleConstraint, wheel: *Wheel, outForward: *Vec3, outUp: *Vec3, outRight: *Vec3) -> void #foreign JoltC "JPH_VehicleConstraint_GetWheelLocalBasis";
VehicleConstraint_GetWheelLocalTransform :: (constraint: *VehicleConstraint, wheelIndex: u32, wheelRight: *Vec3, wheelUp: *Vec3, result: *Mat4) -> void #foreign JoltC "JPH_VehicleConstraint_GetWheelLocalTransform";
VehicleConstraint_GetWheelWorldTransform :: (constraint: *VehicleConstraint, wheelIndex: u32, wheelRight: *Vec3, wheelUp: *Vec3, result: *RMat4) -> void #foreign JoltC "JPH_VehicleConstraint_GetWheelWorldTransform";

/* Wheel */
WheelSettings_Create :: () -> *WheelSettings #foreign JoltC "JPH_WheelSettings_Create";
WheelSettings_Destroy :: (settings: *WheelSettings) -> void #foreign JoltC "JPH_WheelSettings_Destroy";
WheelSettings_GetPosition :: (settings: *WheelSettings, result: *Vec3) -> void #foreign JoltC "JPH_WheelSettings_GetPosition";
WheelSettings_SetPosition :: (settings: *WheelSettings, value: *Vec3) -> void #foreign JoltC "JPH_WheelSettings_SetPosition";
WheelSettings_GetSuspensionForcePoint :: (settings: *WheelSettings, result: *Vec3) -> void #foreign JoltC "JPH_WheelSettings_GetSuspensionForcePoint";
WheelSettings_SetSuspensionForcePoint :: (settings: *WheelSettings, value: *Vec3) -> void #foreign JoltC "JPH_WheelSettings_SetSuspensionForcePoint";
WheelSettings_GetSuspensionDirection :: (settings: *WheelSettings, result: *Vec3) -> void #foreign JoltC "JPH_WheelSettings_GetSuspensionDirection";
WheelSettings_SetSuspensionDirection :: (settings: *WheelSettings, value: *Vec3) -> void #foreign JoltC "JPH_WheelSettings_SetSuspensionDirection";
WheelSettings_GetSteeringAxis :: (settings: *WheelSettings, result: *Vec3) -> void #foreign JoltC "JPH_WheelSettings_GetSteeringAxis";
WheelSettings_SetSteeringAxis :: (settings: *WheelSettings, value: *Vec3) -> void #foreign JoltC "JPH_WheelSettings_SetSteeringAxis";
WheelSettings_GetWheelUp :: (settings: *WheelSettings, result: *Vec3) -> void #foreign JoltC "JPH_WheelSettings_GetWheelUp";
WheelSettings_SetWheelUp :: (settings: *WheelSettings, value: *Vec3) -> void #foreign JoltC "JPH_WheelSettings_SetWheelUp";
WheelSettings_GetWheelForward :: (settings: *WheelSettings, result: *Vec3) -> void #foreign JoltC "JPH_WheelSettings_GetWheelForward";
WheelSettings_SetWheelForward :: (settings: *WheelSettings, value: *Vec3) -> void #foreign JoltC "JPH_WheelSettings_SetWheelForward";
WheelSettings_GetSuspensionMinLength :: (settings: *WheelSettings) -> float #foreign JoltC "JPH_WheelSettings_GetSuspensionMinLength";
WheelSettings_SetSuspensionMinLength :: (settings: *WheelSettings, value: float) -> void #foreign JoltC "JPH_WheelSettings_SetSuspensionMinLength";
WheelSettings_GetSuspensionMaxLength :: (settings: *WheelSettings) -> float #foreign JoltC "JPH_WheelSettings_GetSuspensionMaxLength";
WheelSettings_SetSuspensionMaxLength :: (settings: *WheelSettings, value: float) -> void #foreign JoltC "JPH_WheelSettings_SetSuspensionMaxLength";
WheelSettings_GetSuspensionPreloadLength :: (settings: *WheelSettings) -> float #foreign JoltC "JPH_WheelSettings_GetSuspensionPreloadLength";
WheelSettings_SetSuspensionPreloadLength :: (settings: *WheelSettings, value: float) -> void #foreign JoltC "JPH_WheelSettings_SetSuspensionPreloadLength";
WheelSettings_GetSuspensionSpring :: (settings: *WheelSettings, result: *SpringSettings) -> void #foreign JoltC "JPH_WheelSettings_GetSuspensionSpring";
WheelSettings_SetSuspensionSpring :: (settings: *WheelSettings, springSettings: *SpringSettings) -> void #foreign JoltC "JPH_WheelSettings_SetSuspensionSpring";
WheelSettings_GetRadius :: (settings: *WheelSettings) -> float #foreign JoltC "JPH_WheelSettings_GetRadius";
WheelSettings_SetRadius :: (settings: *WheelSettings, value: float) -> void #foreign JoltC "JPH_WheelSettings_SetRadius";
WheelSettings_GetWidth :: (settings: *WheelSettings) -> float #foreign JoltC "JPH_WheelSettings_GetWidth";
WheelSettings_SetWidth :: (settings: *WheelSettings, value: float) -> void #foreign JoltC "JPH_WheelSettings_SetWidth";
WheelSettings_GetEnableSuspensionForcePoint :: (settings: *WheelSettings) -> bool #foreign JoltC "JPH_WheelSettings_GetEnableSuspensionForcePoint";
WheelSettings_SetEnableSuspensionForcePoint :: (settings: *WheelSettings, value: bool) -> void #foreign JoltC "JPH_WheelSettings_SetEnableSuspensionForcePoint";

Wheel_Create :: (settings: *WheelSettings) -> *Wheel #foreign JoltC "JPH_Wheel_Create";
Wheel_Destroy :: (wheel: *Wheel) -> void #foreign JoltC "JPH_Wheel_Destroy";
Wheel_GetSettings :: (wheel: *Wheel) -> *WheelSettings #foreign JoltC "JPH_Wheel_GetSettings";
Wheel_GetAngularVelocity :: (wheel: *Wheel) -> float #foreign JoltC "JPH_Wheel_GetAngularVelocity";
Wheel_SetAngularVelocity :: (wheel: *Wheel, value: float) -> void #foreign JoltC "JPH_Wheel_SetAngularVelocity";
Wheel_GetRotationAngle :: (wheel: *Wheel) -> float #foreign JoltC "JPH_Wheel_GetRotationAngle";
Wheel_SetRotationAngle :: (wheel: *Wheel, value: float) -> void #foreign JoltC "JPH_Wheel_SetRotationAngle";
Wheel_GetSteerAngle :: (wheel: *Wheel) -> float #foreign JoltC "JPH_Wheel_GetSteerAngle";
Wheel_SetSteerAngle :: (wheel: *Wheel, value: float) -> void #foreign JoltC "JPH_Wheel_SetSteerAngle";
Wheel_HasContact :: (wheel: *Wheel) -> bool #foreign JoltC "JPH_Wheel_HasContact";
Wheel_GetContactBodyID :: (wheel: *Wheel) -> BodyID #foreign JoltC "JPH_Wheel_GetContactBodyID";
Wheel_GetContactSubShapeID :: (wheel: *Wheel) -> SubShapeID #foreign JoltC "JPH_Wheel_GetContactSubShapeID";
Wheel_GetContactPosition :: (wheel: *Wheel, result: *RVec3) -> void #foreign JoltC "JPH_Wheel_GetContactPosition";
Wheel_GetContactPointVelocity :: (wheel: *Wheel, result: *Vec3) -> void #foreign JoltC "JPH_Wheel_GetContactPointVelocity";
Wheel_GetContactNormal :: (wheel: *Wheel, result: *Vec3) -> void #foreign JoltC "JPH_Wheel_GetContactNormal";
Wheel_GetContactLongitudinal :: (wheel: *Wheel, result: *Vec3) -> void #foreign JoltC "JPH_Wheel_GetContactLongitudinal";
Wheel_GetContactLateral :: (wheel: *Wheel, result: *Vec3) -> void #foreign JoltC "JPH_Wheel_GetContactLateral";
Wheel_GetSuspensionLength :: (wheel: *Wheel) -> float #foreign JoltC "JPH_Wheel_GetSuspensionLength";
Wheel_GetSuspensionLambda :: (wheel: *Wheel) -> float #foreign JoltC "JPH_Wheel_GetSuspensionLambda";
Wheel_GetLongitudinalLambda :: (wheel: *Wheel) -> float #foreign JoltC "JPH_Wheel_GetLongitudinalLambda";
Wheel_GetLateralLambda :: (wheel: *Wheel) -> float #foreign JoltC "JPH_Wheel_GetLateralLambda";
Wheel_HasHitHardPoint :: (wheel: *Wheel) -> bool #foreign JoltC "JPH_Wheel_HasHitHardPoint";

/* VehicleAntiRollBar */
VehicleAntiRollBar_Init :: (antiRollBar: *VehicleAntiRollBar) -> void #foreign JoltC "JPH_VehicleAntiRollBar_Init";

/* VehicleEngine */
VehicleEngineSettings_Init :: (settings: *VehicleEngineSettings) -> void #foreign JoltC "JPH_VehicleEngineSettings_Init";

/* VehicleDifferentialSettings */
VehicleDifferentialSettings_Init :: (settings: *VehicleDifferentialSettings) -> void #foreign JoltC "JPH_VehicleDifferentialSettings_Init";

/* VehicleTransmission */
VehicleTransmissionSettings_Create :: () -> *VehicleTransmissionSettings #foreign JoltC "JPH_VehicleTransmissionSettings_Create";
VehicleTransmissionSettings_Destroy :: (settings: *VehicleTransmissionSettings) -> void #foreign JoltC "JPH_VehicleTransmissionSettings_Destroy";

VehicleTransmissionSettings_GetMode :: (settings: *VehicleTransmissionSettings) -> TransmissionMode #foreign JoltC "JPH_VehicleTransmissionSettings_GetMode";
VehicleTransmissionSettings_SetMode :: (settings: *VehicleTransmissionSettings, value: TransmissionMode) -> void #foreign JoltC "JPH_VehicleTransmissionSettings_SetMode";

VehicleTransmissionSettings_GetGearRatioCount :: (settings: *VehicleTransmissionSettings) -> u32 #foreign JoltC "JPH_VehicleTransmissionSettings_GetGearRatioCount";
VehicleTransmissionSettings_GetGearRatio :: (settings: *VehicleTransmissionSettings, index: u32) -> float #foreign JoltC "JPH_VehicleTransmissionSettings_GetGearRatio";
VehicleTransmissionSettings_SetGearRatio :: (settings: *VehicleTransmissionSettings, index: u32, value: float) -> void #foreign JoltC "JPH_VehicleTransmissionSettings_SetGearRatio";
VehicleTransmissionSettings_GetGearRatios :: (settings: *VehicleTransmissionSettings) -> *float #foreign JoltC "JPH_VehicleTransmissionSettings_GetGearRatios";
VehicleTransmissionSettings_SetGearRatios :: (settings: *VehicleTransmissionSettings, values: *float, count: u32) -> void #foreign JoltC "JPH_VehicleTransmissionSettings_SetGearRatios";

VehicleTransmissionSettings_GetReverseGearRatioCount :: (settings: *VehicleTransmissionSettings) -> u32 #foreign JoltC "JPH_VehicleTransmissionSettings_GetReverseGearRatioCount";
VehicleTransmissionSettings_GetReverseGearRatio :: (settings: *VehicleTransmissionSettings, index: u32) -> float #foreign JoltC "JPH_VehicleTransmissionSettings_GetReverseGearRatio";
VehicleTransmissionSettings_SetReverseGearRatio :: (settings: *VehicleTransmissionSettings, index: u32, value: float) -> void #foreign JoltC "JPH_VehicleTransmissionSettings_SetReverseGearRatio";
VehicleTransmissionSettings_GetReverseGearRatios :: (settings: *VehicleTransmissionSettings) -> *float #foreign JoltC "JPH_VehicleTransmissionSettings_GetReverseGearRatios";
VehicleTransmissionSettings_SetReverseGearRatios :: (settings: *VehicleTransmissionSettings, values: *float, count: u32) -> void #foreign JoltC "JPH_VehicleTransmissionSettings_SetReverseGearRatios";

VehicleTransmissionSettings_GetSwitchTime :: (settings: *VehicleTransmissionSettings) -> float #foreign JoltC "JPH_VehicleTransmissionSettings_GetSwitchTime";
VehicleTransmissionSettings_SetSwitchTime :: (settings: *VehicleTransmissionSettings, value: float) -> void #foreign JoltC "JPH_VehicleTransmissionSettings_SetSwitchTime";
VehicleTransmissionSettings_GetClutchReleaseTime :: (settings: *VehicleTransmissionSettings) -> float #foreign JoltC "JPH_VehicleTransmissionSettings_GetClutchReleaseTime";
VehicleTransmissionSettings_SetClutchReleaseTime :: (settings: *VehicleTransmissionSettings, value: float) -> void #foreign JoltC "JPH_VehicleTransmissionSettings_SetClutchReleaseTime";
VehicleTransmissionSettings_GetSwitchLatency :: (settings: *VehicleTransmissionSettings) -> float #foreign JoltC "JPH_VehicleTransmissionSettings_GetSwitchLatency";
VehicleTransmissionSettings_SetSwitchLatency :: (settings: *VehicleTransmissionSettings, value: float) -> void #foreign JoltC "JPH_VehicleTransmissionSettings_SetSwitchLatency";
VehicleTransmissionSettings_GetShiftUpRPM :: (settings: *VehicleTransmissionSettings) -> float #foreign JoltC "JPH_VehicleTransmissionSettings_GetShiftUpRPM";
VehicleTransmissionSettings_SetShiftUpRPM :: (settings: *VehicleTransmissionSettings, value: float) -> void #foreign JoltC "JPH_VehicleTransmissionSettings_SetShiftUpRPM";
VehicleTransmissionSettings_GetShiftDownRPM :: (settings: *VehicleTransmissionSettings) -> float #foreign JoltC "JPH_VehicleTransmissionSettings_GetShiftDownRPM";
VehicleTransmissionSettings_SetShiftDownRPM :: (settings: *VehicleTransmissionSettings, value: float) -> void #foreign JoltC "JPH_VehicleTransmissionSettings_SetShiftDownRPM";
VehicleTransmissionSettings_GetClutchStrength :: (settings: *VehicleTransmissionSettings) -> float #foreign JoltC "JPH_VehicleTransmissionSettings_GetClutchStrength";
VehicleTransmissionSettings_SetClutchStrength :: (settings: *VehicleTransmissionSettings, value: float) -> void #foreign JoltC "JPH_VehicleTransmissionSettings_SetClutchStrength";

/* VehicleCollisionTester */
VehicleCollisionTester_Destroy :: (tester: *VehicleCollisionTester) -> void #foreign JoltC "JPH_VehicleCollisionTester_Destroy";
VehicleCollisionTester_GetObjectLayer :: (tester: *VehicleCollisionTester) -> ObjectLayer #foreign JoltC "JPH_VehicleCollisionTester_GetObjectLayer";
VehicleCollisionTester_SetObjectLayer :: (tester: *VehicleCollisionTester, value: ObjectLayer) -> void #foreign JoltC "JPH_VehicleCollisionTester_SetObjectLayer";

VehicleCollisionTesterRay_Create :: (layer: ObjectLayer, up: *Vec3, maxSlopeAngle: float) -> *VehicleCollisionTesterRay #foreign JoltC "JPH_VehicleCollisionTesterRay_Create";
VehicleCollisionTesterCastSphere_Create :: (layer: ObjectLayer, radius: float, up: *Vec3, maxSlopeAngle: float) -> *VehicleCollisionTesterCastSphere #foreign JoltC "JPH_VehicleCollisionTesterCastSphere_Create";
VehicleCollisionTesterCastCylinder_Create :: (layer: ObjectLayer, convexRadiusFraction: float) -> *VehicleCollisionTesterCastCylinder #foreign JoltC "JPH_VehicleCollisionTesterCastCylinder_Create";

/* VehicleControllerSettings/VehicleController */
VehicleControllerSettings_Destroy :: (settings: *VehicleControllerSettings) -> void #foreign JoltC "JPH_VehicleControllerSettings_Destroy";
VehicleController_GetConstraint :: (controller: *VehicleController) -> *VehicleConstraint #foreign JoltC "JPH_VehicleController_GetConstraint";

/* ---- WheelSettingsWV - WheelWV - WheeledVehicleController ---- */
WheelSettingsWV_Create :: () -> *WheelSettingsWV #foreign JoltC "JPH_WheelSettingsWV_Create";
WheelSettingsWV_GetInertia :: (settings: *WheelSettingsWV) -> float #foreign JoltC "JPH_WheelSettingsWV_GetInertia";
WheelSettingsWV_SetInertia :: (settings: *WheelSettingsWV, value: float) -> void #foreign JoltC "JPH_WheelSettingsWV_SetInertia";
WheelSettingsWV_GetAngularDamping :: (settings: *WheelSettingsWV) -> float #foreign JoltC "JPH_WheelSettingsWV_GetAngularDamping";
WheelSettingsWV_SetAngularDamping :: (settings: *WheelSettingsWV, value: float) -> void #foreign JoltC "JPH_WheelSettingsWV_SetAngularDamping";
WheelSettingsWV_GetMaxSteerAngle :: (settings: *WheelSettingsWV) -> float #foreign JoltC "JPH_WheelSettingsWV_GetMaxSteerAngle";
WheelSettingsWV_SetMaxSteerAngle :: (settings: *WheelSettingsWV, value: float) -> void #foreign JoltC "JPH_WheelSettingsWV_SetMaxSteerAngle";

//JPH_CAPI JPH_LinearCurve* JPH_WheelSettingsWV_GetLongitudinalFriction(const JPH_WheelSettingsWV* settings);
//JPH_CAPI void JPH_WheelSettingsWV_SetLongitudinalFriction(JPH_WheelSettingsWV* settings, const JPH_LinearCurve* value);
//JPH_CAPI JPH_LinearCurve* JPH_WheelSettingsWV_GetLateralFriction(const JPH_WheelSettingsWV* settings);
//JPH_CAPI void JPH_WheelSettingsWV_SetLateralFriction(JPH_WheelSettingsWV* settings, const JPH_LinearCurve* value);
WheelSettingsWV_GetMaxBrakeTorque :: (settings: *WheelSettingsWV) -> float #foreign JoltC "JPH_WheelSettingsWV_GetMaxBrakeTorque";
WheelSettingsWV_SetMaxBrakeTorque :: (settings: *WheelSettingsWV, value: float) -> void #foreign JoltC "JPH_WheelSettingsWV_SetMaxBrakeTorque";
WheelSettingsWV_GetMaxHandBrakeTorque :: (settings: *WheelSettingsWV) -> float #foreign JoltC "JPH_WheelSettingsWV_GetMaxHandBrakeTorque";
WheelSettingsWV_SetMaxHandBrakeTorque :: (settings: *WheelSettingsWV, value: float) -> void #foreign JoltC "JPH_WheelSettingsWV_SetMaxHandBrakeTorque";

WheelWV_Create :: (settings: *WheelSettingsWV) -> *WheelWV #foreign JoltC "JPH_WheelWV_Create";
WheelWV_GetSettings :: (wheel: *WheelWV) -> *WheelSettingsWV #foreign JoltC "JPH_WheelWV_GetSettings";
WheelWV_ApplyTorque :: (wheel: *WheelWV, torque: float, deltaTime: float) -> void #foreign JoltC "JPH_WheelWV_ApplyTorque";

WheeledVehicleControllerSettings_Create :: () -> *WheeledVehicleControllerSettings #foreign JoltC "JPH_WheeledVehicleControllerSettings_Create";

WheeledVehicleControllerSettings_GetEngine :: (settings: *WheeledVehicleControllerSettings, result: *VehicleEngineSettings) -> void #foreign JoltC "JPH_WheeledVehicleControllerSettings_GetEngine";
WheeledVehicleControllerSettings_SetEngine :: (settings: *WheeledVehicleControllerSettings, value: *VehicleEngineSettings) -> void #foreign JoltC "JPH_WheeledVehicleControllerSettings_SetEngine";
WheeledVehicleControllerSettings_GetTransmission :: (settings: *WheeledVehicleControllerSettings) -> *VehicleTransmissionSettings #foreign JoltC "JPH_WheeledVehicleControllerSettings_GetTransmission";
WheeledVehicleControllerSettings_SetTransmission :: (settings: *WheeledVehicleControllerSettings, value: *VehicleTransmissionSettings) -> void #foreign JoltC "JPH_WheeledVehicleControllerSettings_SetTransmission";

WheeledVehicleControllerSettings_GetDifferentialsCount :: (settings: *WheeledVehicleControllerSettings) -> u32 #foreign JoltC "JPH_WheeledVehicleControllerSettings_GetDifferentialsCount";
WheeledVehicleControllerSettings_SetDifferentialsCount :: (settings: *WheeledVehicleControllerSettings, count: u32) -> void #foreign JoltC "JPH_WheeledVehicleControllerSettings_SetDifferentialsCount";
WheeledVehicleControllerSettings_GetDifferential :: (settings: *WheeledVehicleControllerSettings, index: u32, result: *VehicleDifferentialSettings) -> void #foreign JoltC "JPH_WheeledVehicleControllerSettings_GetDifferential";
WheeledVehicleControllerSettings_SetDifferential :: (settings: *WheeledVehicleControllerSettings, index: u32, value: *VehicleDifferentialSettings) -> void #foreign JoltC "JPH_WheeledVehicleControllerSettings_SetDifferential";
WheeledVehicleControllerSettings_SetDifferentials :: (settings: *WheeledVehicleControllerSettings, values: *VehicleDifferentialSettings, count: u32) -> void #foreign JoltC "JPH_WheeledVehicleControllerSettings_SetDifferentials";

WheeledVehicleControllerSettings_GetDifferentialLimitedSlipRatio :: (settings: *WheeledVehicleControllerSettings) -> float #foreign JoltC "JPH_WheeledVehicleControllerSettings_GetDifferentialLimitedSlipRatio";
WheeledVehicleControllerSettings_SetDifferentialLimitedSlipRatio :: (settings: *WheeledVehicleControllerSettings, value: float) -> void #foreign JoltC "JPH_WheeledVehicleControllerSettings_SetDifferentialLimitedSlipRatio";

WheeledVehicleController_SetDriverInput :: (controller: *WheeledVehicleController, forward: float, right: float, brake: float, handBrake: float) -> void #foreign JoltC "JPH_WheeledVehicleController_SetDriverInput";
WheeledVehicleController_SetForwardInput :: (controller: *WheeledVehicleController, forward: float) -> void #foreign JoltC "JPH_WheeledVehicleController_SetForwardInput";
WheeledVehicleController_GetForwardInput :: (controller: *WheeledVehicleController) -> float #foreign JoltC "JPH_WheeledVehicleController_GetForwardInput";
WheeledVehicleController_SetRightInput :: (controller: *WheeledVehicleController, rightRatio: float) -> void #foreign JoltC "JPH_WheeledVehicleController_SetRightInput";
WheeledVehicleController_GetRightInput :: (controller: *WheeledVehicleController) -> float #foreign JoltC "JPH_WheeledVehicleController_GetRightInput";
WheeledVehicleController_SetBrakeInput :: (controller: *WheeledVehicleController, brakeInput: float) -> void #foreign JoltC "JPH_WheeledVehicleController_SetBrakeInput";
WheeledVehicleController_GetBrakeInput :: (controller: *WheeledVehicleController) -> float #foreign JoltC "JPH_WheeledVehicleController_GetBrakeInput";
WheeledVehicleController_SetHandBrakeInput :: (controller: *WheeledVehicleController, handBrakeInput: float) -> void #foreign JoltC "JPH_WheeledVehicleController_SetHandBrakeInput";
WheeledVehicleController_GetHandBrakeInput :: (controller: *WheeledVehicleController) -> float #foreign JoltC "JPH_WheeledVehicleController_GetHandBrakeInput";
WheeledVehicleController_GetWheelSpeedAtClutch :: (controller: *WheeledVehicleController) -> float #foreign JoltC "JPH_WheeledVehicleController_GetWheelSpeedAtClutch";

/* WheelSettingsTV - WheelTV - TrackedVehicleController */
/* TODO: Add VehicleTrack and VehicleTrackSettings */
WheelSettingsTV_Create :: () -> *WheelSettingsTV #foreign JoltC "JPH_WheelSettingsTV_Create";
WheelSettingsTV_GetLongitudinalFriction :: (settings: *WheelSettingsTV) -> float #foreign JoltC "JPH_WheelSettingsTV_GetLongitudinalFriction";
WheelSettingsTV_SetLongitudinalFriction :: (settings: *WheelSettingsTV, value: float) -> void #foreign JoltC "JPH_WheelSettingsTV_SetLongitudinalFriction";
WheelSettingsTV_GetLateralFriction :: (settings: *WheelSettingsTV) -> float #foreign JoltC "JPH_WheelSettingsTV_GetLateralFriction";
WheelSettingsTV_SetLateralFriction :: (settings: *WheelSettingsTV, value: float) -> void #foreign JoltC "JPH_WheelSettingsTV_SetLateralFriction";

WheelTV_Create :: (settings: *WheelSettingsTV) -> *WheelTV #foreign JoltC "JPH_WheelTV_Create";
WheelTV_GetSettings :: (wheel: *WheelTV) -> *WheelSettingsTV #foreign JoltC "JPH_WheelTV_GetSettings";

TrackedVehicleControllerSettings_Create :: () -> *TrackedVehicleControllerSettings #foreign JoltC "JPH_TrackedVehicleControllerSettings_Create";

TrackedVehicleControllerSettings_GetEngine :: (settings: *TrackedVehicleControllerSettings, result: *VehicleEngineSettings) -> void #foreign JoltC "JPH_TrackedVehicleControllerSettings_GetEngine";
TrackedVehicleControllerSettings_SetEngine :: (settings: *TrackedVehicleControllerSettings, value: *VehicleEngineSettings) -> void #foreign JoltC "JPH_TrackedVehicleControllerSettings_SetEngine";
TrackedVehicleControllerSettings_GetTransmission :: (settings: *TrackedVehicleControllerSettings) -> *VehicleTransmissionSettings #foreign JoltC "JPH_TrackedVehicleControllerSettings_GetTransmission";
TrackedVehicleControllerSettings_SetTransmission :: (settings: *TrackedVehicleControllerSettings, value: *VehicleTransmissionSettings) -> void #foreign JoltC "JPH_TrackedVehicleControllerSettings_SetTransmission";

TrackedVehicleController_SetDriverInput :: (controller: *TrackedVehicleController, forward: float, leftRatio: float, rightRatio: float, brake: float) -> void #foreign JoltC "JPH_TrackedVehicleController_SetDriverInput";
TrackedVehicleController_GetForwardInput :: (controller: *TrackedVehicleController) -> float #foreign JoltC "JPH_TrackedVehicleController_GetForwardInput";
TrackedVehicleController_SetForwardInput :: (controller: *TrackedVehicleController, value: float) -> void #foreign JoltC "JPH_TrackedVehicleController_SetForwardInput";
TrackedVehicleController_GetLeftRatio :: (controller: *TrackedVehicleController) -> float #foreign JoltC "JPH_TrackedVehicleController_GetLeftRatio";
TrackedVehicleController_SetLeftRatio :: (controller: *TrackedVehicleController, value: float) -> void #foreign JoltC "JPH_TrackedVehicleController_SetLeftRatio";
TrackedVehicleController_GetRightRatio :: (controller: *TrackedVehicleController) -> float #foreign JoltC "JPH_TrackedVehicleController_GetRightRatio";
TrackedVehicleController_SetRightRatio :: (controller: *TrackedVehicleController, value: float) -> void #foreign JoltC "JPH_TrackedVehicleController_SetRightRatio";
TrackedVehicleController_GetBrakeInput :: (controller: *TrackedVehicleController) -> float #foreign JoltC "JPH_TrackedVehicleController_GetBrakeInput";
TrackedVehicleController_SetBrakeInput :: (controller: *TrackedVehicleController, value: float) -> void #foreign JoltC "JPH_TrackedVehicleController_SetBrakeInput";

/* MotorcycleController */
MotorcycleControllerSettings_Create :: () -> *MotorcycleControllerSettings #foreign JoltC "JPH_MotorcycleControllerSettings_Create";
MotorcycleControllerSettings_GetMaxLeanAngle :: (settings: *MotorcycleControllerSettings) -> float #foreign JoltC "JPH_MotorcycleControllerSettings_GetMaxLeanAngle";
MotorcycleControllerSettings_SetMaxLeanAngle :: (settings: *MotorcycleControllerSettings, value: float) -> void #foreign JoltC "JPH_MotorcycleControllerSettings_SetMaxLeanAngle";
MotorcycleControllerSettings_GetLeanSpringConstant :: (settings: *MotorcycleControllerSettings) -> float #foreign JoltC "JPH_MotorcycleControllerSettings_GetLeanSpringConstant";
MotorcycleControllerSettings_SetLeanSpringConstant :: (settings: *MotorcycleControllerSettings, value: float) -> void #foreign JoltC "JPH_MotorcycleControllerSettings_SetLeanSpringConstant";
MotorcycleControllerSettings_GetLeanSpringDamping :: (settings: *MotorcycleControllerSettings) -> float #foreign JoltC "JPH_MotorcycleControllerSettings_GetLeanSpringDamping";
MotorcycleControllerSettings_SetLeanSpringDamping :: (settings: *MotorcycleControllerSettings, value: float) -> void #foreign JoltC "JPH_MotorcycleControllerSettings_SetLeanSpringDamping";
MotorcycleControllerSettings_GetLeanSpringIntegrationCoefficient :: (settings: *MotorcycleControllerSettings) -> float #foreign JoltC "JPH_MotorcycleControllerSettings_GetLeanSpringIntegrationCoefficient";
MotorcycleControllerSettings_SetLeanSpringIntegrationCoefficient :: (settings: *MotorcycleControllerSettings, value: float) -> void #foreign JoltC "JPH_MotorcycleControllerSettings_SetLeanSpringIntegrationCoefficient";
MotorcycleControllerSettings_GetLeanSpringIntegrationCoefficientDecay :: (settings: *MotorcycleControllerSettings) -> float #foreign JoltC "JPH_MotorcycleControllerSettings_GetLeanSpringIntegrationCoefficientDecay";
MotorcycleControllerSettings_SetLeanSpringIntegrationCoefficientDecay :: (settings: *MotorcycleControllerSettings, value: float) -> void #foreign JoltC "JPH_MotorcycleControllerSettings_SetLeanSpringIntegrationCoefficientDecay";
MotorcycleControllerSettings_GetLeanSmoothingFactor :: (settings: *MotorcycleControllerSettings) -> float #foreign JoltC "JPH_MotorcycleControllerSettings_GetLeanSmoothingFactor";
MotorcycleControllerSettings_SetLeanSmoothingFactor :: (settings: *MotorcycleControllerSettings, value: float) -> void #foreign JoltC "JPH_MotorcycleControllerSettings_SetLeanSmoothingFactor";

MotorcycleController_GetWheelBase :: (controller: *MotorcycleController) -> float #foreign JoltC "JPH_MotorcycleController_GetWheelBase";
MotorcycleController_IsLeanControllerEnabled :: (controller: *MotorcycleController) -> bool #foreign JoltC "JPH_MotorcycleController_IsLeanControllerEnabled";
MotorcycleController_EnableLeanController :: (controller: *MotorcycleController, value: bool) -> void #foreign JoltC "JPH_MotorcycleController_EnableLeanController";
MotorcycleController_IsLeanSteeringLimitEnabled :: (controller: *MotorcycleController) -> bool #foreign JoltC "JPH_MotorcycleController_IsLeanSteeringLimitEnabled";
MotorcycleController_EnableLeanSteeringLimit :: (controller: *MotorcycleController, value: bool) -> void #foreign JoltC "JPH_MotorcycleController_EnableLeanSteeringLimit";
MotorcycleController_GetLeanSpringConstant :: (controller: *MotorcycleController) -> float #foreign JoltC "JPH_MotorcycleController_GetLeanSpringConstant";
MotorcycleController_SetLeanSpringConstant :: (controller: *MotorcycleController, value: float) -> void #foreign JoltC "JPH_MotorcycleController_SetLeanSpringConstant";
MotorcycleController_GetLeanSpringDamping :: (controller: *MotorcycleController) -> float #foreign JoltC "JPH_MotorcycleController_GetLeanSpringDamping";
MotorcycleController_SetLeanSpringDamping :: (controller: *MotorcycleController, value: float) -> void #foreign JoltC "JPH_MotorcycleController_SetLeanSpringDamping";
MotorcycleController_GetLeanSpringIntegrationCoefficient :: (controller: *MotorcycleController) -> float #foreign JoltC "JPH_MotorcycleController_GetLeanSpringIntegrationCoefficient";
MotorcycleController_SetLeanSpringIntegrationCoefficient :: (controller: *MotorcycleController, value: float) -> void #foreign JoltC "JPH_MotorcycleController_SetLeanSpringIntegrationCoefficient";
MotorcycleController_GetLeanSpringIntegrationCoefficientDecay :: (controller: *MotorcycleController) -> float #foreign JoltC "JPH_MotorcycleController_GetLeanSpringIntegrationCoefficientDecay";
MotorcycleController_SetLeanSpringIntegrationCoefficientDecay :: (controller: *MotorcycleController, value: float) -> void #foreign JoltC "JPH_MotorcycleController_SetLeanSpringIntegrationCoefficientDecay";
MotorcycleController_GetLeanSmoothingFactor :: (controller: *MotorcycleController) -> float #foreign JoltC "JPH_MotorcycleController_GetLeanSmoothingFactor";
MotorcycleController_SetLeanSmoothingFactor :: (controller: *MotorcycleController, value: float) -> void #foreign JoltC "JPH_MotorcycleController_SetLeanSmoothingFactor";

#scope_file

JoltC :: #library "./Lib/Linux/libjoltc";
