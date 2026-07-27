#import "SDL";
#import "Remap_Context"(false);

#load "world.jai";
#load "physics.jai";

g_module := GameModule.{
    base.OnModuleLoad=OnModuleLoad,
    base.Initialize=InitializeGame,
    base.Shutdown=ShutdownGame,
    base.MainLoop=UpdateGame,
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

InitializeGame :: (global_init : bool) {
    Remap_Context();

    InitPhysics();
}

ShutdownGame :: (global_shutdown : bool) {
    Remap_Context();

    ShutdownPhysics();
}

UpdateGame :: () {
    Remap_Context();

    PhysicsDebugRendererNextFrame();
}
