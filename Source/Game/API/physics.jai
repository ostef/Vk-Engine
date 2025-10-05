RaycastResult :: struct {
    hit : bool;
    point : Vec3f;
    normal : Vec3f;
    dist := F32_Inf;
    entity : *Entity;
    collider : *Component;
}

SphereColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    radius : float = 1; @Serialize(2)

    OnDebugDraw :: (world : *World, entity : *Entity, using sphere : *SphereColliderComponent) {
        center := TranslationVector(world_transform);
        DebugDrawSphereOutline(.{0,1,0,1}, center, radius);
    }
} @Component @Category(Colliders)

CapsuleColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    height : float = 2; @Serialize(2)
    radius : float = 0.5; @Serialize(3)

    OnDebugDraw :: (world : *World, entity : *Entity, using capsule : *CapsuleColliderComponent) {
        center := TranslationVector(world_transform);
        up := UpVector(world_transform);
        DebugDrawCapsuleOutline(.{0,1,0,1}, center - up * height * 0.5, center + up * height * 0.5, radius);
    }
} @Component @Category(Colliders)

BoxColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    half_extents : Vec3f = .{1,1,1}; @Serialize(2)

    OnDebugDraw :: (world : *World, entity : *Entity, using box : *BoxColliderComponent) {
        DebugDrawBoxOutline(.{0,1,0,1}, .{0,0,0}, half_extents, world_transform);
    }
} @Component @Category(Colliders)

MeshColliderComponent :: struct {
    #as using _ : SpatialComponent; @Serialize(1) @InspectorNoTree

    mesh : *Asset(StaticMesh); @Serialize(2)
} @Component @Category(Colliders)
