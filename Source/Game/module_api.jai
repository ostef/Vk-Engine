// This file was auto-generated. Do not modify it

GameModule :: struct {
    #as base : Module;
    CastRay : (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32)) -> RayCastResult;
    CopyWorld : (dest : *World, src : *World);
    DestroyKilledEntities : (world : *World);
    DestroyWorld : (world : *World);
    DisablePhysicsCollisionLayersCollision : (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer);
    EnablePhysicsCollisionLayersCollision : (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer);
    GetDefaultMaterial : () -> *Asset(DataType=Material);
    GetPhysicsDebugDrawSettings : () -> *PhysicsDebugDrawSettings;
    GetPhysicsGlobals : () -> *PhysicsGlobals;
    GetPhysicsSettings : () -> *PhysicsSettings;
    InitWorld : (world : *World);
    LoadWorldFromDirectory : (world : *World, directory : string);
    RayIntersection_1 : (world : *World, box : *BoxColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RayCastResult;
    RayIntersection_2 : (world : *World, capsule : *CapsuleColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RayCastResult;
    RayIntersection_3 : (world : *World, mesh : *MeshColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RayCastResult;
    RayIntersection_4 : (world : *World, sphere : *SphereColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RayCastResult;
    Raycast : (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RayCastResult;
    RaycastAll : (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float, results : *[..]RayCastResult) -> bool;
    SaveWorldToDirectory : (world : *World, output_directory : string);
    ShouldPhysicsCollisionLayersCollide : (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) -> bool;
    SubmitWorldToRenderer : (world_to_render : *WorldToRender, world : *World);
    UpdatePhysicsCollisionLayerMatrix : ();
    UpdatePhysicsWorld : (world : *World);
    UpdateWorld : (world : *World);
}

#if Import_Mode == .Foreign {
g_Game : *GameModule;

CastRay :: inline (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32)) -> RayCastResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.CastRay(world, ray_origin, ray_direction);
} @NoProfile

CopyWorld :: inline (dest : *World, src : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.CopyWorld(dest, src);
} @NoProfile

DestroyKilledEntities :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.DestroyKilledEntities(world);
} @NoProfile

DestroyWorld :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.DestroyWorld(world);
} @NoProfile

DisablePhysicsCollisionLayersCollision :: inline (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) {
    Assert(g_Game != null, "Game module is null");
    g_Game.DisablePhysicsCollisionLayersCollision(a, b);
} @NoProfile

EnablePhysicsCollisionLayersCollision :: inline (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) {
    Assert(g_Game != null, "Game module is null");
    g_Game.EnablePhysicsCollisionLayersCollision(a, b);
} @NoProfile

GetDefaultMaterial :: inline () -> *Asset(DataType=Material) {
    Assert(g_Game != null, "Game module is null");
    return g_Game.GetDefaultMaterial();
} @NoProfile

GetPhysicsDebugDrawSettings :: inline () -> *PhysicsDebugDrawSettings {
    Assert(g_Game != null, "Game module is null");
    return g_Game.GetPhysicsDebugDrawSettings();
} @NoProfile

GetPhysicsGlobals :: inline () -> *PhysicsGlobals {
    Assert(g_Game != null, "Game module is null");
    return g_Game.GetPhysicsGlobals();
} @NoProfile

GetPhysicsSettings :: inline () -> *PhysicsSettings {
    Assert(g_Game != null, "Game module is null");
    return g_Game.GetPhysicsSettings();
} @NoProfile

InitWorld :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.InitWorld(world);
} @NoProfile

LoadWorldFromDirectory :: inline (world : *World, directory : string) {
    Assert(g_Game != null, "Game module is null");
    g_Game.LoadWorldFromDirectory(world, directory);
} @NoProfile

RayIntersection :: inline (world : *World, box : *BoxColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RayCastResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.RayIntersection_1(world, box, ray_origin, ray_direction, ray_length);
} @NoProfile

RayIntersection :: inline (world : *World, capsule : *CapsuleColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RayCastResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.RayIntersection_2(world, capsule, ray_origin, ray_direction, ray_length);
} @NoProfile

RayIntersection :: inline (world : *World, mesh : *MeshColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RayCastResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.RayIntersection_3(world, mesh, ray_origin, ray_direction, ray_length);
} @NoProfile

RayIntersection :: inline (world : *World, sphere : *SphereColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RayCastResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.RayIntersection_4(world, sphere, ray_origin, ray_direction, ray_length);
} @NoProfile

Raycast :: inline (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RayCastResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.Raycast(world, ray_origin, ray_direction, ray_length);
} @NoProfile

RaycastAll :: inline (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float, results : *[..]RayCastResult) -> bool {
    Assert(g_Game != null, "Game module is null");
    return g_Game.RaycastAll(world, ray_origin, ray_direction, ray_length, results);
} @NoProfile

SaveWorldToDirectory :: inline (world : *World, output_directory : string) {
    Assert(g_Game != null, "Game module is null");
    g_Game.SaveWorldToDirectory(world, output_directory);
} @NoProfile

ShouldPhysicsCollisionLayersCollide :: inline (a : PhysicsCollisionLayer, b : PhysicsCollisionLayer) -> bool {
    Assert(g_Game != null, "Game module is null");
    return g_Game.ShouldPhysicsCollisionLayersCollide(a, b);
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

}
