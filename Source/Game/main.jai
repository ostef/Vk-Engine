#import "SDL";

Module_ID :: ModuleID.Game;

g_module := GameModule.{
    base.Initialize=InitializeGame,
    base.Shutdown=ShutdownGame,
    base.MainLoop=GameLoop,
    base.OnEvent=OnEvent,
};

#program_export
ModuleHandshake :: (core : *CoreModule) -> *Module #c_call {
    g_Core = core;

    InitializeAPI(*g_module);

    return *g_module;
}

InitializeGame :: () {
}

ShutdownGame :: () {
}

GameLoop :: () {
}

OnEvent :: (event : SDL_Event) {
}
