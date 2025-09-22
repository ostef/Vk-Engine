// This file was auto-generated. Do not modify it

RendererModule :: struct {
    #as base : Module;
    AddDirectionalLightToRender : (light : DirectionalLightToRender);
    AddMeshToRender : (mesh : MeshToRender);
    AddPointLightToRender : (light : PointLightToRender);
    AddViewpointToRender : (viewpoint : ViewpointToRender);
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
