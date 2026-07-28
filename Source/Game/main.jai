#import "SDL";

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
    AssertContextMatchesCore();

    if id == {
    case .Renderer; g_Renderer = xx GetModule(.Renderer);
    }
}

InitializeGame :: (global_init : bool) {
    InitPhysics();
}

ShutdownGame :: (global_shutdown : bool) {
    ShutdownPhysics();
}

UpdateGame :: () {
    PhysicsDebugRendererNextFrame();
}
