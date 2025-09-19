#import "String";
#import "File";

#load "api.jai";
#load "Vulkan/vulkan.jai";
#load "input.jai";

Module_ID :: ModuleID.Core;

g_module := CoreModule.{
    base.Initialize=InitializeCore,
    base.Shutdown=ShutdownCore,
    base.MainLoop=CoreLoop,
    base.OnEvent=OnEvent,
};

ModuleHandshake :: (core : *CoreModule) -> *Module #c_call {
    InitializeAPI(*g_module);

    return *g_module;
}

g_window : *SDL_Window;
g_gfx_context : GfxContext;
g_gpu_profiler : GPUFrameProfiler;
g_cpu_profiler : CPUFrameProfiler;

GetWindow :: () -> *SDL_Window {
    return g_window;
} @ModuleAPI

GetGfxContext :: () -> *GfxContext {
    return *g_gfx_context;
} @ModuleAPI

GetGPUFrameProfiler :: () -> *GPUFrameProfiler {
    return *g_gpu_profiler;
} @ModuleAPI

GetCPUFrameProfiler :: () -> *CPUFrameProfiler {
    return *g_cpu_profiler;
} @ModuleAPI

InitializeCore :: () {
    g_window = SDL_CreateWindow("Hot Reload", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 1600, 900, 0);

    InitGfxContext(g_window);
}

ShutdownCore :: () {
    DestroyGfxContext();

    SDL_DestroyWindow(g_window);
}

CoreLoop :: () {
    UpdateInputState();

    event : SDL_Event;
    while SDL_PollEvent(*event) {
        // for g_modules {
        //     if it && it.OnEvent {
        //         it.OnEvent(event);
        //     }
        // }

        if event.type == SDL_QUIT {
            Quit();
        }
    }
}

OnEvent :: (event : SDL_Event) {
    HandleInputEvent(event);
}

Quit :: () {
    // g_quit = true;
} @ModuleAPI

