#load "api.jai";
#load "input.jai";

Module_ID :: ModuleID.Core;

g_module := CoreModule.{
    base.Initialize=InitializeCore,
    base.Shutdown=ShutdownCore,
    base.MainLoop=CoreLoop,
    base.OnEvent=OnEvent,

    Quit=Quit,
    GetModule=GetModule,
    GetWindow=GetWindow,

    input.GetMouseWheel=GetMouseWheel,
    input.GetRawMouseDelta=GetRawMouseDelta,
    input.GetKeyAxisValue=GetKeyAxisValue,
    input.WasKeyDown=WasKeyDown,
    input.IsKeyDown=IsKeyDown,
    input.IsKeyPressed=IsKeyPressed,
    input.IsKeyReleased=IsKeyReleased,
    input.WasMouseButtonDown=WasMouseButtonDown,
    input.IsMouseButtonDown=IsMouseButtonDown,
    input.IsMouseButtonPressed=IsMouseButtonPressed,
    input.IsMouseButtonReleased=IsMouseButtonReleased,
    input.GetModState=GetModState,
    input.GetMousePointPosition=GetMousePointPosition,
    input.GetMousePixelPosition=GetMousePixelPosition,
    input.GetMousePointPositionVector=GetMousePointPositionVector,
    input.GetMousePixelPositionVector=GetMousePixelPositionVector,
    input.GetWindowPointSize=GetWindowPointSize,
    input.GetWindowPixelSize=GetWindowPixelSize,
    input.GetWindowScaleFactor=GetWindowScaleFactor,
};

ModuleHandshake :: (core : *CoreModule) -> *Module #c_call {
    return *g_module;
}

g_window : *SDL_Window;

GetModule :: inline (id : ModuleID) -> *Module {
    return g_modules[id];
}

GetWindow :: inline () -> *SDL_Window {
    return g_window;
}

InitializeCore :: () {
    g_window = SDL_CreateWindow("Hot Reload", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 1600, 900, 0);
}

ShutdownCore :: () {
    SDL_DestroyWindow(g_window);
}

CoreLoop :: () {
    UpdateInputState();

    event : SDL_Event;
    while SDL_PollEvent(*event) {
        for g_modules {
            if it && it.OnEvent {
                it.OnEvent(event);
            }
        }

        if event.type == SDL_QUIT {
            Quit();
        }
    }
}

OnEvent :: (event : SDL_Event) {
    HandleInputEvent(event);
}

Quit :: () {
    g_quit = true;
}

