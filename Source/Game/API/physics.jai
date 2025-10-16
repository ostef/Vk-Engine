Physics_Temp_Allocator_Capacity :: 10 * 1024 * 1024;
Physics_Max_Bodies :: 1024;
Physics_Num_Body_Mutexes :: 0;
Physics_Max_Body_Pairs :: 1024;
Physics_Max_Contact_Constraints :: 1024;
Physics_Num_Updates_Per_Second :: 60;
Physics_Delta_Time :: 1.0 / Physics_Num_Updates_Per_Second;
Physics_Num_Collision_Steps :: 1;

RaycastResult :: struct {
    hit : bool;
    point : Vec3f;
    normal : Vec3f;
    dist := F32_Inf;
    entity : *Entity;
    collider : *Component;
}

RigidBodyComponent :: struct {
    #as using _ : Component; @Serialize(1) @InspectorNoTree
} @Component @Category(Physics)

SphereColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    radius : float = 1; @Serialize(2)

    OnDebugDraw :: (world : *World, entity : *Entity, using sphere : *SphereColliderComponent) {
        center := TranslationVector(world_transform);
        DebugDrawSphereOutline(world, .{0,1,0,1}, center, radius);
    }
} @Component @Category(Physics/Colliders)

CapsuleColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    height : float = 2; @Serialize(2)
    radius : float = 0.5; @Serialize(3)

    OnDebugDraw :: (world : *World, entity : *Entity, using capsule : *CapsuleColliderComponent) {
        center := TranslationVector(world_transform);
        up := UpVector(world_transform);
        DebugDrawCapsuleOutline(world, .{0,1,0,1}, center - up * height * 0.5, center + up * height * 0.5, radius);
    }
} @Component @Category(Physics/Colliders)

BoxColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    half_extents : Vec3f = .{1,1,1}; @Serialize(2)

    OnDebugDraw :: (world : *World, entity : *Entity, using box : *BoxColliderComponent) {
        DebugDrawBoxOutline(world, .{0,1,0,1}, .{0,0,0}, half_extents, world_transform);
    }
} @Component @Category(Physics/Colliders)

MeshColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    mesh : *Asset(StaticMesh); @Serialize(2)
} @Component @Category(Physics/Colliders)
