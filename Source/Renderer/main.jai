#import "SDL";
#import "Thread";

Module_ID :: ModuleID.Renderer;

g_module := RendererModule.{
    base.Initialize=InitializeRenderer,
    base.Shutdown=ShutdownRenderer,
    base.OnEvent=OnEvent,
    base.OnModuleUnload=OnModuleUnload,
    base.OnModuleLoad=OnModuleLoad,
};

g_render_thread : Thread;
g_render_thread_produced_semaphore : Semaphore;
g_render_thread_consume_semaphore : Semaphore;
g_render_thread_should_stop : bool;

g_meshes_to_render : [..]MeshToRender;
g_directional_lights_to_render : [..]DirectionalLightToRender;
g_point_lights_to_render : [..]PointLightToRender;

#program_export
ModuleHandshake :: (core : *CoreModule) -> *Module #c_call {
    g_Core = core;

    InitializeAPI(*g_module);

    return *g_module;
}

InitializeRenderer :: () {
    init(*g_render_thread_produced_semaphore);
    signal(*g_render_thread_produced_semaphore);
    init(*g_render_thread_consume_semaphore);

    thread_init(*g_render_thread, RenderThread);
    thread_start(*g_render_thread);
}

ShutdownRenderer :: () {
    WaitForRenderThread();
    StopRenderThread();

    thread_is_done(*g_render_thread, -1);
    thread_deinit(*g_render_thread);

    destroy(*g_render_thread_produced_semaphore);
    destroy(*g_render_thread_consume_semaphore);
}

OnEvent :: (event : SDL_Event) {
}

OnModuleLoad :: (id : ModuleID) {
}

OnModuleUnload :: (id : ModuleID) {
}

AddMeshToRender :: (mesh : MeshToRender) {
    ArrayPush(*g_meshes_to_render, mesh);
} @ModuleAPI

AddDirectionalLightToRender :: (light : DirectionalLightToRender) {
    ArrayPush(*g_directional_lights_to_render, light);
} @ModuleAPI

AddPointLightToRender :: (light : PointLightToRender) {
    ArrayPush(*g_point_lights_to_render, light);
} @ModuleAPI

WaitForRenderThread :: () {
    wait_for(*g_render_thread_produced_semaphore);
} @ModuleAPI

SubmitFrameToRenderThread :: () {
    signal(*g_render_thread_consume_semaphore);
} @ModuleAPI

StopRenderThread :: () {
    g_render_thread_should_stop = true;
    signal(*g_render_thread_consume_semaphore);
} @ModuleAPI

RenderThread :: (thread : *Thread) -> s64 {
    while true {
        wait_for(*g_render_thread_consume_semaphore);
        if g_render_thread_should_stop {
            signal(*g_render_thread_produced_semaphore);
            break;
        }

        ArrayClear(*g_meshes_to_render);
        ArrayClear(*g_directional_lights_to_render);
        ArrayClear(*g_point_lights_to_render);

        signal(*g_render_thread_produced_semaphore);
    }

    return 0;
}
