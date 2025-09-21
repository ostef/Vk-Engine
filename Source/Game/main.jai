#import "SDL";

#load "world.jai";
// #load "entity.jai";
// #load "component.jai";

Module_ID :: ModuleID.Game;

g_module := GameModule.{
    base.Initialize=InitializeGame,
    base.Shutdown=ShutdownGame,
    base.MainLoop=GameLoop,
    base.OnEvent=OnEvent,
    base.OnModuleLoad=OnModuleLoad,
};
g_context : #Context;

#program_export
ModuleHandshake :: (core : *CoreModule) -> *Module #c_call {
    push_context,defer_pop;

    g_Core = core;
    g_Renderer = xx GetModule(.Renderer);

    InitializeAPI(*g_module);

    return *g_module;
}

OnModuleLoad :: (id : ModuleID) {
    push_context,defer_pop g_context;

    if id == {
    case .Renderer; g_Renderer = xx GetModule(.Renderer);
    }
}

g_world : World;

InitializeGame :: () {
    g_context = remap_context();
    push_context,defer_pop g_context;
}

ShutdownGame :: () {
    push_context,defer_pop g_context;

    DestroyWorld(*g_world);
}

GameLoop :: () {
    push_context,defer_pop g_context;

    // Update world
    SubmitWorldToRenderer(*g_world);
}

OnEvent :: (event : SDL_Event) {
    push_context,defer_pop g_context;

}

SubmitWorldToRenderer :: (world : *World) {
    push_context,defer_pop g_context;

    WaitForRenderThread();

    SubmitFrameToRenderThread();
} @ModuleAPI
