#import "SDL";
#import "Remap_Context"(false);

#load "world.jai";

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
    Remap_Context();

    if id == {
    case .Renderer; g_Renderer = xx GetModule(.Renderer);
    }
}

InitializeGame :: () {
    Remap_Context();
}

ShutdownGame :: () {
    Remap_Context();
}

GameLoop :: () {
    Remap_Context();
}

OnEvent :: (event : SDL_Event) {
    Remap_Context();
}
