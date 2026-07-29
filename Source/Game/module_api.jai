// This file was auto-generated. Do not modify it

GameModule :: struct {
    #as base : Module;
    AttachEntity : (world : *World, entity : *Entity, to : *Entity, keep_same_world_transform : bool = true) -> bool;
    CastRay : (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RayCastResult;
    CopyWorld : (dest : *World, src : *World);
    CreateAndDeserializeEntity : (world : *World, text : string, type_id : EntityTypeId, attach_to_parent : bool, name : string = "", guid : EntityGUID = Null_Entity_GUID) -> *Entity;
    CreateEntity : (world : *World, type : EntityTypeId, name : string = "", guid : EntityGUID = Null_Entity_GUID) -> *Entity;
    DebugDrawPhysicsBodies : (world : *World, settings : PhysicsDebugDrawSettings);
    DeserializeEntity : (text : string, world : *World, entity : *Entity) -> DeserializeResult;
    DestroyKilledEntities : (world : *World);
    DestroyWorld : (world : *World);
    DetachEntity : (world : *World, entity : *Entity, keep_same_world_transform : bool = true) -> bool;
    DisablePhysicsCollisionLayersCollision : (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer);
    EnablePhysicsCollisionLayersCollision : (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer);
    EntityIsInHierarchy : (world : *World, entity : *Entity, of : *Entity) -> bool;
    GenerateEntityGUID : () -> EntityGUID;
    GetDefaultMaterial : () -> *Asset(DataType=Material);
    GetEntity_1 : (world : *World, index : EntityIndex) -> *Entity, GetEntityError;
    GetEntity_2 : (world : *World, guid : EntityGUID) -> *Entity, GetEntityError;
    GetPhysicsDebugDrawSettings : () -> *PhysicsDebugDrawSettings;
    GetPhysicsGlobalSettings : () -> *PhysicsGlobalSettings;
    GetPhysicsGlobals : () -> *PhysicsGlobals;
    GetWorldScale : (world : *World, entity : *Entity, component : *SpatialComponent = null) -> Vector(N=3, T=float32);
    InitWorld : (world : *World);
    KillEntity_1 : (world : *World, index : EntityIndex);
    KillEntity_2 : (world : *World, guid : EntityGUID);
    LoadWorldFromDirectory : (world : *World, directory : string);
    PhysicsDebugRendererNextFrame : ();
    SaveWorldToDirectory : (world : *World, output_directory : string);
    SerializeEntity : (serializer : *Serializer, entity : *Entity);
    SetEntityName : (world : *World, entity : *Entity, new_name : string) -> set_same_name : bool;
    SetPhysicsDebugRendererTarget : (world : *World);
    SetWorldTransformNoScale : (world : *World, entity : *Entity, transform : Matrix(M=4, N=4, T=float32));
    ShouldPhysicsCollisionLayersCollide : (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) -> bool;
    SpawnEntity : (world : *World, type : EntityTypeId, name : string = "", guid : EntityGUID = Null_Entity_GUID) -> *Entity;
    SubmitWorldToRenderer : (world_to_render : *WorldToRender, world : *World);
    UpdatePhysicsCollisionLayerMatrix : ();
    UpdatePhysicsWorld : (world : *World);
    UpdateWorld : (world : *World);
    UpdateWorldTransform : (world : *World, entity : *Entity, update_children : bool = true, update_components : bool = true);
}

#if Import_Mode == .Foreign {
g_Game : *GameModule;

AttachEntity :: inline (world : *World, entity : *Entity, to : *Entity, keep_same_world_transform : bool = true) -> bool {
    Assert(g_Game != null, "Game module is null");
    return g_Game.AttachEntity(world, entity, to, keep_same_world_transform);
} @NoProfile

CastRay :: inline (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RayCastResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.CastRay(world, ray_origin, ray_direction, ray_length);
} @NoProfile

CopyWorld :: inline (dest : *World, src : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.CopyWorld(dest, src);
} @NoProfile

CreateAndDeserializeEntity :: inline (world : *World, text : string, type_id : EntityTypeId, attach_to_parent : bool, name : string = "", guid : EntityGUID = Null_Entity_GUID) -> *Entity {
    Assert(g_Game != null, "Game module is null");
    return g_Game.CreateAndDeserializeEntity(world, text, type_id, attach_to_parent, name, guid);
} @NoProfile

CreateEntity :: inline (world : *World, type : EntityTypeId, name : string = "", guid : EntityGUID = Null_Entity_GUID) -> *Entity {
    Assert(g_Game != null, "Game module is null");
    return g_Game.CreateEntity(world, type, name, guid);
} @NoProfile

DebugDrawPhysicsBodies :: inline (world : *World, settings : PhysicsDebugDrawSettings) {
    Assert(g_Game != null, "Game module is null");
    g_Game.DebugDrawPhysicsBodies(world, settings);
} @NoProfile

DeserializeEntity :: inline (text : string, world : *World, entity : *Entity) -> DeserializeResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.DeserializeEntity(text, world, entity);
} @NoProfile

DestroyKilledEntities :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.DestroyKilledEntities(world);
} @NoProfile

DestroyWorld :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.DestroyWorld(world);
} @NoProfile

DetachEntity :: inline (world : *World, entity : *Entity, keep_same_world_transform : bool = true) -> bool {
    Assert(g_Game != null, "Game module is null");
    return g_Game.DetachEntity(world, entity, keep_same_world_transform);
} @NoProfile

DisablePhysicsCollisionLayersCollision :: inline (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) {
    Assert(g_Game != null, "Game module is null");
    g_Game.DisablePhysicsCollisionLayersCollision(a, b);
} @NoProfile

EnablePhysicsCollisionLayersCollision :: inline (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) {
    Assert(g_Game != null, "Game module is null");
    g_Game.EnablePhysicsCollisionLayersCollision(a, b);
} @NoProfile

EntityIsInHierarchy :: inline (world : *World, entity : *Entity, of : *Entity) -> bool {
    Assert(g_Game != null, "Game module is null");
    return g_Game.EntityIsInHierarchy(world, entity, of);
} @NoProfile

GenerateEntityGUID :: inline () -> EntityGUID {
    Assert(g_Game != null, "Game module is null");
    return g_Game.GenerateEntityGUID();
} @NoProfile

GetDefaultMaterial :: inline () -> *Asset(DataType=Material) {
    Assert(g_Game != null, "Game module is null");
    return g_Game.GetDefaultMaterial();
} @NoProfile

GetEntity :: inline (world : *World, index : EntityIndex) -> *Entity, GetEntityError {
    Assert(g_Game != null, "Game module is null");
    _ret0, _ret1 := g_Game.GetEntity_1(world, index);
    return _ret0, _ret1;
} @NoProfile

GetEntity :: inline (world : *World, guid : EntityGUID) -> *Entity, GetEntityError {
    Assert(g_Game != null, "Game module is null");
    _ret0, _ret1 := g_Game.GetEntity_2(world, guid);
    return _ret0, _ret1;
} @NoProfile

GetPhysicsDebugDrawSettings :: inline () -> *PhysicsDebugDrawSettings {
    Assert(g_Game != null, "Game module is null");
    return g_Game.GetPhysicsDebugDrawSettings();
} @NoProfile

GetPhysicsGlobalSettings :: inline () -> *PhysicsGlobalSettings {
    Assert(g_Game != null, "Game module is null");
    return g_Game.GetPhysicsGlobalSettings();
} @NoProfile

GetPhysicsGlobals :: inline () -> *PhysicsGlobals {
    Assert(g_Game != null, "Game module is null");
    return g_Game.GetPhysicsGlobals();
} @NoProfile

GetWorldScale :: inline (world : *World, entity : *Entity, component : *SpatialComponent = null) -> Vector(N=3, T=float32) {
    Assert(g_Game != null, "Game module is null");
    return g_Game.GetWorldScale(world, entity, component);
} @NoProfile

InitWorld :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.InitWorld(world);
} @NoProfile

KillEntity :: inline (world : *World, index : EntityIndex) {
    Assert(g_Game != null, "Game module is null");
    g_Game.KillEntity_1(world, index);
} @NoProfile

KillEntity :: inline (world : *World, guid : EntityGUID) {
    Assert(g_Game != null, "Game module is null");
    g_Game.KillEntity_2(world, guid);
} @NoProfile

LoadWorldFromDirectory :: inline (world : *World, directory : string) {
    Assert(g_Game != null, "Game module is null");
    g_Game.LoadWorldFromDirectory(world, directory);
} @NoProfile

PhysicsDebugRendererNextFrame :: inline () {
    Assert(g_Game != null, "Game module is null");
    g_Game.PhysicsDebugRendererNextFrame();
} @NoProfile

SaveWorldToDirectory :: inline (world : *World, output_directory : string) {
    Assert(g_Game != null, "Game module is null");
    g_Game.SaveWorldToDirectory(world, output_directory);
} @NoProfile

SerializeEntity :: inline (serializer : *Serializer, entity : *Entity) {
    Assert(g_Game != null, "Game module is null");
    g_Game.SerializeEntity(serializer, entity);
} @NoProfile

SetEntityName :: inline (world : *World, entity : *Entity, new_name : string) -> set_same_name : bool {
    Assert(g_Game != null, "Game module is null");
    return g_Game.SetEntityName(world, entity, new_name);
} @NoProfile

SetPhysicsDebugRendererTarget :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.SetPhysicsDebugRendererTarget(world);
} @NoProfile

SetWorldTransformNoScale :: inline (world : *World, entity : *Entity, transform : Matrix(M=4, N=4, T=float32)) {
    Assert(g_Game != null, "Game module is null");
    g_Game.SetWorldTransformNoScale(world, entity, transform);
} @NoProfile

ShouldPhysicsCollisionLayersCollide :: inline (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) -> bool {
    Assert(g_Game != null, "Game module is null");
    return g_Game.ShouldPhysicsCollisionLayersCollide(a, b);
} @NoProfile

SpawnEntity :: inline (world : *World, type : EntityTypeId, name : string = "", guid : EntityGUID = Null_Entity_GUID) -> *Entity {
    Assert(g_Game != null, "Game module is null");
    return g_Game.SpawnEntity(world, type, name, guid);
} @NoProfile

SubmitWorldToRenderer :: inline (world_to_render : *WorldToRender, world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.SubmitWorldToRenderer(world_to_render, world);
} @NoProfile

UpdatePhysicsCollisionLayerMatrix :: inline () {
    Assert(g_Game != null, "Game module is null");
    g_Game.UpdatePhysicsCollisionLayerMatrix();
} @NoProfile

UpdatePhysicsWorld :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.UpdatePhysicsWorld(world);
} @NoProfile

UpdateWorld :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.UpdateWorld(world);
} @NoProfile

UpdateWorldTransform :: inline (world : *World, entity : *Entity, update_children : bool = true, update_components : bool = true) {
    Assert(g_Game != null, "Game module is null");
    g_Game.UpdateWorldTransform(world, entity, update_children, update_components);
} @NoProfile

}
