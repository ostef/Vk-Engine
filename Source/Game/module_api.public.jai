// This file was auto-generated. Do not modify it

GameModule :: struct {
    #as base : Module;
    AttachEntity : (world : *World, entity : *Entity, to : *Entity, keep_same_world_transform : bool = true) -> bool;
    CopyWorld : (dest : *World, src : *World);
    CreateAndDeserializeEntity : (world : *World, text : string, type_id : EntityTypeId, attach_to_parent : bool, name : string = "", id : EntityID = Null_Entity_ID) -> *Entity;
    CreateEntity : (world : *World, type : EntityTypeId, name : string = "", id : EntityID = Null_Entity_ID) -> *Entity;
    DebugDrawPhysicsBodies : (world : *World, settings : PhysicsDebugDrawSettings);
    DeserializeEntity : (text : string, world : *World, entity : *Entity) -> DeserializeResult;
    DestroyKilledEntities : (world : *World);
    DestroyWorld : (world : *World);
    DetachEntity : (world : *World, entity : *Entity, keep_same_world_transform : bool = true) -> bool;
    EntityIsInHierarchy : (world : *World, entity : *Entity, of : *Entity) -> bool;
    GetDefaultMaterial : () -> *Asset(DataType=Material);
    GetEntity_1 : (world : *World, index : EntityIndex) -> *Entity, GetEntityError;
    GetEntity_2 : (world : *World, id : EntityID) -> *Entity, GetEntityError;
    GetJoltSettings : () -> *JoltSettings;
    GetPhysicsDebugDrawSettings : () -> *PhysicsDebugDrawSettings;
    GetPhysicsGlobals : () -> *PhysicsGlobals;
    GetPhysicsSettings : () -> *PhysicsSettings;
    GetWorldScale : (world : *World, entity : *Entity, component : *SpatialComponent = null) -> Vector(N=3, T=float32);
    InitWorld : (world : *World);
    KillEntity_1 : (world : *World, index : EntityIndex);
    KillEntity_2 : (world : *World, id : EntityID);
    LoadWorldFromDirectory : (world : *World, directory : string);
    PhysicsCastRay_1 : (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float, settings : RayCastSettings = .{}) -> RayCastResult;
    PhysicsCastRay_2 : (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float, results : *[..]RayCastResult, settings : RayCastSettings = .{}) -> bool;
    PhysicsDebugRendererNextFrame : ();
    RandomEntityID : () -> EntityID;
    SaveWorldToDirectory : (world : *World, output_directory : string);
    SerializeEntity : (serializer : *Serializer, entity : *Entity);
    SetEntityName : (world : *World, entity : *Entity, new_name : string) -> set_same_name : bool;
    SetPhysicsDebugRendererTarget : (world : *World);
    SetWorldTransformNoScale : (world : *World, entity : *Entity, transform : Matrix(M=4, N=4, T=float32));
    SortByDistance : (results : []RayCastResult);
    SpawnEntity : (world : *World, type : EntityTypeId, name : string = "", id : EntityID = Null_Entity_ID) -> *Entity;
    SubmitWorldToRenderer : (world_to_render : *WorldToRender, world : *World);
    UpdatePhysicsWorld : (world : *World);
    UpdateWorld : (world : *World);
    UpdateWorldTransform_1 : (world : *World, entity : *Entity, rigid_body : *RigidBodyComponent);
    UpdateWorldTransform_2 : (world : *World, entity : *Entity, update_children : bool = true, update_components : bool = true);
}

#if Import_Mode == .Foreign {
g_Game : *GameModule;

AttachEntity :: inline (world : *World, entity : *Entity, to : *Entity, keep_same_world_transform : bool = true) -> bool {
    return g_Game.AttachEntity(world, entity, to, keep_same_world_transform);
} @NoProfile

CopyWorld :: inline (dest : *World, src : *World) {
    g_Game.CopyWorld(dest, src);
} @NoProfile

CreateAndDeserializeEntity :: inline (world : *World, text : string, type_id : EntityTypeId, attach_to_parent : bool, name : string = "", id : EntityID = Null_Entity_ID) -> *Entity {
    return g_Game.CreateAndDeserializeEntity(world, text, type_id, attach_to_parent, name, id);
} @NoProfile

CreateEntity :: inline (world : *World, type : EntityTypeId, name : string = "", id : EntityID = Null_Entity_ID) -> *Entity {
    return g_Game.CreateEntity(world, type, name, id);
} @NoProfile

DebugDrawPhysicsBodies :: inline (world : *World, settings : PhysicsDebugDrawSettings) {
    g_Game.DebugDrawPhysicsBodies(world, settings);
} @NoProfile

DeserializeEntity :: inline (text : string, world : *World, entity : *Entity) -> DeserializeResult {
    return g_Game.DeserializeEntity(text, world, entity);
} @NoProfile

DestroyKilledEntities :: inline (world : *World) {
    g_Game.DestroyKilledEntities(world);
} @NoProfile

DestroyWorld :: inline (world : *World) {
    g_Game.DestroyWorld(world);
} @NoProfile

DetachEntity :: inline (world : *World, entity : *Entity, keep_same_world_transform : bool = true) -> bool {
    return g_Game.DetachEntity(world, entity, keep_same_world_transform);
} @NoProfile

EntityIsInHierarchy :: inline (world : *World, entity : *Entity, of : *Entity) -> bool {
    return g_Game.EntityIsInHierarchy(world, entity, of);
} @NoProfile

GetDefaultMaterial :: inline () -> *Asset(DataType=Material) {
    return g_Game.GetDefaultMaterial();
} @NoProfile

GetEntity :: inline (world : *World, index : EntityIndex) -> *Entity, GetEntityError {
    _ret0, _ret1 := g_Game.GetEntity_1(world, index);
    return _ret0, _ret1;
} @NoProfile

GetEntity :: inline (world : *World, id : EntityID) -> *Entity, GetEntityError {
    _ret0, _ret1 := g_Game.GetEntity_2(world, id);
    return _ret0, _ret1;
} @NoProfile

GetJoltSettings :: inline () -> *JoltSettings {
    return g_Game.GetJoltSettings();
} @NoProfile

GetPhysicsDebugDrawSettings :: inline () -> *PhysicsDebugDrawSettings {
    return g_Game.GetPhysicsDebugDrawSettings();
} @NoProfile

GetPhysicsGlobals :: inline () -> *PhysicsGlobals {
    return g_Game.GetPhysicsGlobals();
} @NoProfile

GetPhysicsSettings :: inline () -> *PhysicsSettings {
    return g_Game.GetPhysicsSettings();
} @NoProfile

GetWorldScale :: inline (world : *World, entity : *Entity, component : *SpatialComponent = null) -> Vector(N=3, T=float32) {
    return g_Game.GetWorldScale(world, entity, component);
} @NoProfile

InitWorld :: inline (world : *World) {
    g_Game.InitWorld(world);
} @NoProfile

KillEntity :: inline (world : *World, index : EntityIndex) {
    g_Game.KillEntity_1(world, index);
} @NoProfile

KillEntity :: inline (world : *World, id : EntityID) {
    g_Game.KillEntity_2(world, id);
} @NoProfile

LoadWorldFromDirectory :: inline (world : *World, directory : string) {
    g_Game.LoadWorldFromDirectory(world, directory);
} @NoProfile

PhysicsCastRay :: inline (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float, settings : RayCastSettings = .{}) -> RayCastResult {
    return g_Game.PhysicsCastRay_1(world, ray_origin, ray_direction, ray_length, settings);
} @NoProfile

PhysicsCastRay :: inline (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float, results : *[..]RayCastResult, settings : RayCastSettings = .{}) -> bool {
    return g_Game.PhysicsCastRay_2(world, ray_origin, ray_direction, ray_length, results, settings);
} @NoProfile

PhysicsDebugRendererNextFrame :: inline () {
    g_Game.PhysicsDebugRendererNextFrame();
} @NoProfile

RandomEntityID :: inline () -> EntityID {
    return g_Game.RandomEntityID();
} @NoProfile

SaveWorldToDirectory :: inline (world : *World, output_directory : string) {
    g_Game.SaveWorldToDirectory(world, output_directory);
} @NoProfile

SerializeEntity :: inline (serializer : *Serializer, entity : *Entity) {
    g_Game.SerializeEntity(serializer, entity);
} @NoProfile

SetEntityName :: inline (world : *World, entity : *Entity, new_name : string) -> set_same_name : bool {
    return g_Game.SetEntityName(world, entity, new_name);
} @NoProfile

SetPhysicsDebugRendererTarget :: inline (world : *World) {
    g_Game.SetPhysicsDebugRendererTarget(world);
} @NoProfile

SetWorldTransformNoScale :: inline (world : *World, entity : *Entity, transform : Matrix(M=4, N=4, T=float32)) {
    g_Game.SetWorldTransformNoScale(world, entity, transform);
} @NoProfile

SortByDistance :: inline (results : []RayCastResult) {
    g_Game.SortByDistance(results);
} @NoProfile

SpawnEntity :: inline (world : *World, type : EntityTypeId, name : string = "", id : EntityID = Null_Entity_ID) -> *Entity {
    return g_Game.SpawnEntity(world, type, name, id);
} @NoProfile

SubmitWorldToRenderer :: inline (world_to_render : *WorldToRender, world : *World) {
    g_Game.SubmitWorldToRenderer(world_to_render, world);
} @NoProfile

UpdatePhysicsWorld :: inline (world : *World) {
    g_Game.UpdatePhysicsWorld(world);
} @NoProfile

UpdateWorld :: inline (world : *World) {
    g_Game.UpdateWorld(world);
} @NoProfile

UpdateWorldTransform :: inline (world : *World, entity : *Entity, rigid_body : *RigidBodyComponent) {
    g_Game.UpdateWorldTransform_1(world, entity, rigid_body);
} @NoProfile

UpdateWorldTransform :: inline (world : *World, entity : *Entity, update_children : bool = true, update_components : bool = true) {
    g_Game.UpdateWorldTransform_2(world, entity, update_children, update_components);
} @NoProfile

}
