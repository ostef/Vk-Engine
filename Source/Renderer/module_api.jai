// This file was auto-generated. Do not modify it

RendererModule :: struct {
    #as base : Module;
    AddDirectionalLightToRender : (light : DirectionalLightToRender);
    AddMeshToRender : (mesh : MeshToRender);
    AddPointLightToRender : (light : PointLightToRender);
    AddPointShadowMapToRender : (shadow_map : PointShadowMapToRender) -> s64;
    AddSelectedMeshToRender : (mesh : MeshToRender);
    AddShadowMapToRender : (shadow_map : ShadowMapToRender) -> s64;
    AddViewpointToRender : (viewpoint : ViewpointToRender);
    DebugDrawBoxOutline_1 : (color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), half_extents : Vector(N=3, T=float32), transform : Matrix(M=4, N=4, T=float32));
    DebugDrawBoxOutline_2 : (color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), half_extents : Vector(N=3, T=float32), orientation : Quat(T=float32) = Quat(T=float32).{});
    DebugDrawCapsuleOutline : (color : Vector(N=4, T=float32), base : Vector(N=3, T=float32), tip : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, num_divisions : s64 = 4);
    DebugDrawCircleOutline : (color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), tangent : Vector(N=3, T=float32), bitangent : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, start_angle : float = 0, angle : float = Pi * 2);
    DebugDrawConeOutline : (color : Vector(N=4, T=float32), base : Vector(N=3, T=float32), tip : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, num_divisions : s64 = 6);
    DebugDrawCross : (color : Vector(N=4, T=float32), position : Vector(N=3, T=float32), size : float);
    DebugDrawCylinderOutline : (color : Vector(N=4, T=float32), base : Vector(N=3, T=float32), tip : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, num_divisions : s64 = 6);
    DebugDrawGrid : (color : Vector(N=4, T=float32), origin : Vector(N=3, T=float32), right : Vector(N=3, T=float32), forward : Vector(N=3, T=float32), size : s64, cell_size : float = 1);
    DebugDrawLine : (color : Vector(N=4, T=float32), start : Vector(N=3, T=float32), end : Vector(N=3, T=float32));
    DebugDrawSphereOutline : (color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), radius : float, resolution : s64 = 30);
    DestroyImGuiRenderer : ();
    GetShadersThatFailedToReload : () -> []string;
    GetViewpointRenderTargets : (id : u64, desired_resolution : Vector(N=2, T=u32)) -> *ViewpointRenderTargets;
    InitImGuiRenderer : ();
    StopRenderThread : ();
    SubmitFrameToRenderThread : ();
    WaitForRenderThread : ();
}

#if Import_Mode == .Foreign {
g_Renderer : *RendererModule;

AddDirectionalLightToRender :: inline (light : DirectionalLightToRender) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.AddDirectionalLightToRender(light);
} @NoProfile

AddMeshToRender :: inline (mesh : MeshToRender) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.AddMeshToRender(mesh);
} @NoProfile

AddPointLightToRender :: inline (light : PointLightToRender) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.AddPointLightToRender(light);
} @NoProfile

AddPointShadowMapToRender :: inline (shadow_map : PointShadowMapToRender) -> s64 {
    Assert(g_Renderer != null, "Renderer module is null");
    return g_Renderer.AddPointShadowMapToRender(shadow_map);
} @NoProfile

AddSelectedMeshToRender :: inline (mesh : MeshToRender) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.AddSelectedMeshToRender(mesh);
} @NoProfile

AddShadowMapToRender :: inline (shadow_map : ShadowMapToRender) -> s64 {
    Assert(g_Renderer != null, "Renderer module is null");
    return g_Renderer.AddShadowMapToRender(shadow_map);
} @NoProfile

AddViewpointToRender :: inline (viewpoint : ViewpointToRender) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.AddViewpointToRender(viewpoint);
} @NoProfile

DebugDrawBoxOutline :: inline (color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), half_extents : Vector(N=3, T=float32), transform : Matrix(M=4, N=4, T=float32)) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.DebugDrawBoxOutline_1(color, center, half_extents, transform);
} @NoProfile

DebugDrawBoxOutline :: inline (color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), half_extents : Vector(N=3, T=float32), orientation : Quat(T=float32) = Quat(T=float32).{}) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.DebugDrawBoxOutline_2(color, center, half_extents, orientation);
} @NoProfile

DebugDrawCapsuleOutline :: inline (color : Vector(N=4, T=float32), base : Vector(N=3, T=float32), tip : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, num_divisions : s64 = 4) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.DebugDrawCapsuleOutline(color, base, tip, radius, resolution, num_divisions);
} @NoProfile

DebugDrawCircleOutline :: inline (color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), tangent : Vector(N=3, T=float32), bitangent : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, start_angle : float = 0, angle : float = Pi * 2) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.DebugDrawCircleOutline(color, center, tangent, bitangent, radius, resolution, start_angle, angle);
} @NoProfile

DebugDrawConeOutline :: inline (color : Vector(N=4, T=float32), base : Vector(N=3, T=float32), tip : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, num_divisions : s64 = 6) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.DebugDrawConeOutline(color, base, tip, radius, resolution, num_divisions);
} @NoProfile

DebugDrawCross :: inline (color : Vector(N=4, T=float32), position : Vector(N=3, T=float32), size : float) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.DebugDrawCross(color, position, size);
} @NoProfile

DebugDrawCylinderOutline :: inline (color : Vector(N=4, T=float32), base : Vector(N=3, T=float32), tip : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, num_divisions : s64 = 6) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.DebugDrawCylinderOutline(color, base, tip, radius, resolution, num_divisions);
} @NoProfile

DebugDrawGrid :: inline (color : Vector(N=4, T=float32), origin : Vector(N=3, T=float32), right : Vector(N=3, T=float32), forward : Vector(N=3, T=float32), size : s64, cell_size : float = 1) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.DebugDrawGrid(color, origin, right, forward, size, cell_size);
} @NoProfile

DebugDrawLine :: inline (color : Vector(N=4, T=float32), start : Vector(N=3, T=float32), end : Vector(N=3, T=float32)) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.DebugDrawLine(color, start, end);
} @NoProfile

DebugDrawSphereOutline :: inline (color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), radius : float, resolution : s64 = 30) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.DebugDrawSphereOutline(color, center, radius, resolution);
} @NoProfile

DestroyImGuiRenderer :: inline () {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.DestroyImGuiRenderer();
} @NoProfile

GetShadersThatFailedToReload :: inline () -> []string {
    Assert(g_Renderer != null, "Renderer module is null");
    return g_Renderer.GetShadersThatFailedToReload();
} @NoProfile

GetViewpointRenderTargets :: inline (id : u64, desired_resolution : Vector(N=2, T=u32)) -> *ViewpointRenderTargets {
    Assert(g_Renderer != null, "Renderer module is null");
    return g_Renderer.GetViewpointRenderTargets(id, desired_resolution);
} @NoProfile

InitImGuiRenderer :: inline () {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.InitImGuiRenderer();
} @NoProfile

StopRenderThread :: inline () {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.StopRenderThread();
} @NoProfile

SubmitFrameToRenderThread :: inline () {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.SubmitFrameToRenderThread();
} @NoProfile

WaitForRenderThread :: inline () {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.WaitForRenderThread();
} @NoProfile

}
