#import "Common";
#import "Linalg";
#import "SDL";
#import "String";
#import "File";
#import "File_Utilities";
#import "System";

#load "loader.jai";
#load "input.jai";
#load "asset.jai";
#load "cvar.jai";

#load "Graphics/Vulkan/vulkan.jai";
#load "Graphics/texture2d.jai";
#load "Graphics/environment_map.jai";
#load "Graphics/material.jai";
#load "Graphics/mesh.jai";

#load "Physics/intersection.jai";
#load "Physics/collision_mesh.jai";

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

GetModule :: (id : ModuleID) -> *Module {
    return g_modules[id];
} @ModuleAPI

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

Quit :: () {
    g_quit = true;
} @ModuleAPI

#scope_file

g_num_cpus : s32;
g_default_num_worker_threads : s32;

#scope_export

GetNumCPUs :: inline () -> s32 {
    return g_num_cpus;
}

GetDefaultNumWorkerThreads :: inline () -> s32 {
    return g_default_num_worker_threads;
}

InitializeCore :: () {
    g_num_cpus = get_number_of_processors(.ALL_LOGICAL);
    g_num_cpus = Clamp(g_num_cpus, 1, 200);
    g_default_num_worker_threads = Max(g_num_cpus - 1, 2);
    LogMessage("CPU Information: % logical CPUs, default worker thread count: %", g_num_cpus, g_default_num_worker_threads);

    g_window = SDL_CreateWindow("Engine", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 1600, 900, SDL_WINDOW_VULKAN | SDL_WINDOW_RESIZABLE);

    InitGfxContext(g_window);

    InitFrameProfiler(*g_cpu_profiler);

    InitAssets();
}

ShutdownCore :: () {
    DestroyAllAssetCaches();

    DestroyGfxContext();

    SDL_DestroyWindow(g_window);
}

CoreLoop :: () {
    UpdateInputState();

    should_recreate_swapchain := false;
    event : SDL_Event;
    while SDL_PollEvent(*event) {
        if event.type == SDL_WINDOWEVENT {
            if event.window.event == SDL_WINDOWEVENT_RESIZED
            || event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED
            || event.window.event == SDL_WINDOWEVENT_MINIMIZED {
                should_recreate_swapchain = true;
            }
        }

        if event.type == SDL_QUIT {
            Quit();
        }

        for g_modules {
            if it && it.OnEvent {
                it.OnEvent(event);
            }
        }
    }

    w, h := GetWindowPixelSize(g_window);

    if should_recreate_swapchain && w > 0 && h > 0 {
        RecreateSwapchain();
    }

    UnloadAllUnreferencedAssets();
    ProcessDataDirectoryChanges();
}

OnEvent :: (event : SDL_Event) {
    HandleInputEvent(event);
}
