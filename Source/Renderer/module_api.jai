// This file was auto-generated. Do not modify it

RendererModule :: struct {
    #as base : Module;
    AddDirectionalLightToRender : (light : DirectionalLightToRender);
    AddMeshToRender : (mesh : MeshToRender);
    AddPointLightToRender : (light : PointLightToRender);
    AddViewpointToRender : (viewpoint : ViewpointToRender);
    DestroyImGuiRenderer : ();
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
}

AddMeshToRender :: inline (mesh : MeshToRender) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.AddMeshToRender(mesh);
}

AddPointLightToRender :: inline (light : PointLightToRender) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.AddPointLightToRender(light);
}

AddViewpointToRender :: inline (viewpoint : ViewpointToRender) {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.AddViewpointToRender(viewpoint);
}

DestroyImGuiRenderer :: inline () {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.DestroyImGuiRenderer();
}

GetViewpointRenderTargets :: inline (id : u64, desired_resolution : Vector(N=2, T=u32)) -> *ViewpointRenderTargets {
    Assert(g_Renderer != null, "Renderer module is null");
    return g_Renderer.GetViewpointRenderTargets(id, desired_resolution);
}

InitImGuiRenderer :: inline () {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.InitImGuiRenderer();
}

StopRenderThread :: inline () {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.StopRenderThread();
}

SubmitFrameToRenderThread :: inline () {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.SubmitFrameToRenderThread();
}

WaitForRenderThread :: inline () {
    Assert(g_Renderer != null, "Renderer module is null");
    g_Renderer.WaitForRenderThread();
}

}
