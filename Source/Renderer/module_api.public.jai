// This file was auto-generated. Do not modify it

RendererModule :: struct {
    #as base : Module;
    AddViewpointToRender : (viewpoint : ViewpointToRender);
    AddWorldToRender : (world : WorldToRender) -> s64;
    CreateViewpointRenderTargets : (id : u64, desired_resolution : Vector(N=2, T=u32), bloom_params : BloomParams) -> *ViewpointRenderTargets;
    DebugDrawBoxOutline_1 : (renderer : *DebugRenderer, color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), half_extents : Vector(N=3, T=float32), transform : Matrix(M=4, N=4, T=float32));
    DebugDrawBoxOutline_2 : (renderer : *DebugRenderer, color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), half_extents : Vector(N=3, T=float32), orientation : Quat(T=float32) = Quat(T=float32).{});
    DebugDrawCapsuleOutline : (renderer : *DebugRenderer, color : Vector(N=4, T=float32), base : Vector(N=3, T=float32), tip : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, num_divisions : s64 = 4);
    DebugDrawCircleOutline : (renderer : *DebugRenderer, color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), tangent : Vector(N=3, T=float32), bitangent : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, start_angle : float = 0, angle : float = Pi * 2);
    DebugDrawConeOutline : (renderer : *DebugRenderer, color : Vector(N=4, T=float32), base : Vector(N=3, T=float32), tip : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, num_divisions : s64 = 6);
    DebugDrawCross : (renderer : *DebugRenderer, color : Vector(N=4, T=float32), position : Vector(N=3, T=float32), size : float);
    DebugDrawCylinderOutline : (renderer : *DebugRenderer, color : Vector(N=4, T=float32), base : Vector(N=3, T=float32), tip : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, num_divisions : s64 = 6);
    DebugDrawGrid : (renderer : *DebugRenderer, color : Vector(N=4, T=float32), origin : Vector(N=3, T=float32), right : Vector(N=3, T=float32), forward : Vector(N=3, T=float32), size : s64, cell_size : float = 1);
    DebugDrawLine : (renderer : *DebugRenderer, color : Vector(N=4, T=float32), start : Vector(N=3, T=float32), end : Vector(N=3, T=float32));
    DebugDrawSphereOutline : (renderer : *DebugRenderer, color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, right : Vector(N=3, T=float32) = Vector(N=3, T=float32).{1, 0, 0}, up : Vector(N=3, T=float32) = Vector(N=3, T=float32).{0, 1, 0}, forward : Vector(N=3, T=float32) = Vector(N=3, T=float32).{0, 0, 1});
    DestroyImGuiRenderer : ();
    GetShadersThatFailedToReload : () -> []string;
    GetViewpointRenderTargets : (id : u64) -> *ViewpointRenderTargets;
    InitImGuiRenderer : ();
    StopRenderThread : ();
    SubmitFrameToRenderThread : ();
    WaitForRenderThread : ();
}

#if Import_Mode == .Foreign {
g_Renderer : *RendererModule;

AddViewpointToRender :: inline (viewpoint : ViewpointToRender) {
    g_Renderer.AddViewpointToRender(viewpoint);
} @NoProfile

AddWorldToRender :: inline (world : WorldToRender) -> s64 {
    return g_Renderer.AddWorldToRender(world);
} @NoProfile

CreateViewpointRenderTargets :: inline (id : u64, desired_resolution : Vector(N=2, T=u32), bloom_params : BloomParams) -> *ViewpointRenderTargets {
    return g_Renderer.CreateViewpointRenderTargets(id, desired_resolution, bloom_params);
} @NoProfile

DebugDrawBoxOutline :: inline (renderer : *DebugRenderer, color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), half_extents : Vector(N=3, T=float32), transform : Matrix(M=4, N=4, T=float32)) {
    g_Renderer.DebugDrawBoxOutline_1(renderer, color, center, half_extents, transform);
} @NoProfile

DebugDrawBoxOutline :: inline (renderer : *DebugRenderer, color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), half_extents : Vector(N=3, T=float32), orientation : Quat(T=float32) = Quat(T=float32).{}) {
    g_Renderer.DebugDrawBoxOutline_2(renderer, color, center, half_extents, orientation);
} @NoProfile

DebugDrawCapsuleOutline :: inline (renderer : *DebugRenderer, color : Vector(N=4, T=float32), base : Vector(N=3, T=float32), tip : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, num_divisions : s64 = 4) {
    g_Renderer.DebugDrawCapsuleOutline(renderer, color, base, tip, radius, resolution, num_divisions);
} @NoProfile

DebugDrawCircleOutline :: inline (renderer : *DebugRenderer, color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), tangent : Vector(N=3, T=float32), bitangent : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, start_angle : float = 0, angle : float = Pi * 2) {
    g_Renderer.DebugDrawCircleOutline(renderer, color, center, tangent, bitangent, radius, resolution, start_angle, angle);
} @NoProfile

DebugDrawConeOutline :: inline (renderer : *DebugRenderer, color : Vector(N=4, T=float32), base : Vector(N=3, T=float32), tip : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, num_divisions : s64 = 6) {
    g_Renderer.DebugDrawConeOutline(renderer, color, base, tip, radius, resolution, num_divisions);
} @NoProfile

DebugDrawCross :: inline (renderer : *DebugRenderer, color : Vector(N=4, T=float32), position : Vector(N=3, T=float32), size : float) {
    g_Renderer.DebugDrawCross(renderer, color, position, size);
} @NoProfile

DebugDrawCylinderOutline :: inline (renderer : *DebugRenderer, color : Vector(N=4, T=float32), base : Vector(N=3, T=float32), tip : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, num_divisions : s64 = 6) {
    g_Renderer.DebugDrawCylinderOutline(renderer, color, base, tip, radius, resolution, num_divisions);
} @NoProfile

DebugDrawGrid :: inline (renderer : *DebugRenderer, color : Vector(N=4, T=float32), origin : Vector(N=3, T=float32), right : Vector(N=3, T=float32), forward : Vector(N=3, T=float32), size : s64, cell_size : float = 1) {
    g_Renderer.DebugDrawGrid(renderer, color, origin, right, forward, size, cell_size);
} @NoProfile

DebugDrawLine :: inline (renderer : *DebugRenderer, color : Vector(N=4, T=float32), start : Vector(N=3, T=float32), end : Vector(N=3, T=float32)) {
    g_Renderer.DebugDrawLine(renderer, color, start, end);
} @NoProfile

DebugDrawSphereOutline :: inline (renderer : *DebugRenderer, color : Vector(N=4, T=float32), center : Vector(N=3, T=float32), radius : float, resolution : s64 = 30, right : Vector(N=3, T=float32) = Vector(N=3, T=float32).{1, 0, 0}, up : Vector(N=3, T=float32) = Vector(N=3, T=float32).{0, 1, 0}, forward : Vector(N=3, T=float32) = Vector(N=3, T=float32).{0, 0, 1}) {
    g_Renderer.DebugDrawSphereOutline(renderer, color, center, radius, resolution, right, up, forward);
} @NoProfile

DestroyImGuiRenderer :: inline () {
    g_Renderer.DestroyImGuiRenderer();
} @NoProfile

GetShadersThatFailedToReload :: inline () -> []string {
    return g_Renderer.GetShadersThatFailedToReload();
} @NoProfile

GetViewpointRenderTargets :: inline (id : u64) -> *ViewpointRenderTargets {
    return g_Renderer.GetViewpointRenderTargets(id);
} @NoProfile

InitImGuiRenderer :: inline () {
    g_Renderer.InitImGuiRenderer();
} @NoProfile

StopRenderThread :: inline () {
    g_Renderer.StopRenderThread();
} @NoProfile

SubmitFrameToRenderThread :: inline () {
    g_Renderer.SubmitFrameToRenderThread();
} @NoProfile

WaitForRenderThread :: inline () {
    g_Renderer.WaitForRenderThread();
} @NoProfile

}
