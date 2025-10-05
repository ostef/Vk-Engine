// This file was auto-generated. Do not modify it

GameModule :: struct {
    #as base : Module;
    CopyWorld : (dest : *World, src : *World);
    DestroyKilledEntities : (world : *World);
    DestroyWorld : (world : *World);
    GetDefaultMaterial : () -> *Asset(DataType=Material);
    LoadWorldFromDirectory : (world : *World, directory : string);
    RayIntersection_1 : (world : *World, box : *BoxColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RaycastResult;
    RayIntersection_2 : (world : *World, capsule : *CapsuleColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RaycastResult;
    RayIntersection_3 : (world : *World, mesh : *MeshColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RaycastResult;
    RayIntersection_4 : (world : *World, sphere : *SphereColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RaycastResult;
    Raycast : (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RaycastResult;
    RaycastAll : (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float, results : *[..]RaycastResult) -> bool;
    SaveWorldToDirectory : (world : *World, output_directory : string);
    SubmitWorldToRenderer : (world : *World);
}

#if Import_Mode == .Foreign {
g_Game : *GameModule;

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

GetDefaultMaterial :: inline () -> *Asset(DataType=Material) {
    Assert(g_Game != null, "Game module is null");
    return g_Game.GetDefaultMaterial();
} @NoProfile

LoadWorldFromDirectory :: inline (world : *World, directory : string) {
    Assert(g_Game != null, "Game module is null");
    g_Game.LoadWorldFromDirectory(world, directory);
} @NoProfile

RayIntersection :: inline (world : *World, box : *BoxColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RaycastResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.RayIntersection_1(world, box, ray_origin, ray_direction, ray_length);
} @NoProfile

RayIntersection :: inline (world : *World, capsule : *CapsuleColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RaycastResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.RayIntersection_2(world, capsule, ray_origin, ray_direction, ray_length);
} @NoProfile

RayIntersection :: inline (world : *World, mesh : *MeshColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RaycastResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.RayIntersection_3(world, mesh, ray_origin, ray_direction, ray_length);
} @NoProfile

RayIntersection :: inline (world : *World, sphere : *SphereColliderComponent, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RaycastResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.RayIntersection_4(world, sphere, ray_origin, ray_direction, ray_length);
} @NoProfile

Raycast :: inline (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float) -> RaycastResult {
    Assert(g_Game != null, "Game module is null");
    return g_Game.Raycast(world, ray_origin, ray_direction, ray_length);
} @NoProfile

RaycastAll :: inline (world : *World, ray_origin : Vector(N=3, T=float32), ray_direction : Vector(N=3, T=float32), ray_length : float, results : *[..]RaycastResult) -> bool {
    Assert(g_Game != null, "Game module is null");
    return g_Game.RaycastAll(world, ray_origin, ray_direction, ray_length, results);
} @NoProfile

SaveWorldToDirectory :: inline (world : *World, output_directory : string) {
    Assert(g_Game != null, "Game module is null");
    g_Game.SaveWorldToDirectory(world, output_directory);
} @NoProfile

SubmitWorldToRenderer :: inline (world : *World) {
    Assert(g_Game != null, "Game module is null");
    g_Game.SubmitWorldToRenderer(world);
} @NoProfile

}
