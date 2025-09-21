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

#program_export
ModuleHandshake :: (core : *CoreModule) -> *Module #c_call {
    push_context,defer_pop;

    g_Core = core;
    g_Renderer = xx GetModule(.Renderer);

    InitializeAPI(*g_module);

    return *g_module;
}

OnModuleLoad :: (id : ModuleID) {
    if id == {
    case .Renderer; g_Renderer = xx GetModule(.Renderer);
    }
}

g_world : World;

InitializeGame :: () {
}

ShutdownGame :: () {
    DestroyWorld(*g_world);
}

GameLoop :: () {
    // Update world
    SubmitWorldToRenderer(*g_world);
}

OnEvent :: (event : SDL_Event) {
}

SubmitWorldToRenderer :: (world : *World) {
    WaitForRenderThread();

    SubmitFrameToRenderThread();
} @ModuleAPI
