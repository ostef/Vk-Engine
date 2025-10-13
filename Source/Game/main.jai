#import "SDL";
#import "Remap_Context"(false);
Jolt :: #import "JoltPhysics";

#load "world.jai";
#load "physics.jai";

g_module := GameModule.{
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
