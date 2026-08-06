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
#load "jolt.jai";
#load "serialize_deserialize.jai";
#load "config.jai";

#load "Graphics/Vulkan/vulkan.jai";
#load "Graphics/gpu_frame_profiler.jai";
#load "Graphics/texture2d.jai";
#load "Graphics/environment_map.jai";
#load "Graphics/material.jai";
#load "Graphics/mesh.jai";
#load "Graphics/animation.jai";

#load "Physics/intersection.jai";
#load "Physics/collision_mesh.jai";

Top_Level_Scope :: #code();

GenerateContextProxyType :: () {
    #insert,scope(Top_Level_Scope) -> string {
        builder : StringBuilder;

        Appendln(*builder, "ContextProxy :: struct {");

        info := type_info(#Context);
        for info.members {
            Appendln(*builder, "    % : %;", it.name, get_type(it.type));
        }

        Appendln(*builder, "} @ModuleContext");

        return StringBuilderBuild(*builder);
    }
}

g_module := CoreModule.{
    base.Initialize=InitializeCore,
    base.Shutdown=ShutdownCore,
    base.MainLoop=CoreLoop,
    base.OnEvent=OnEvent,
    base.OnModuleUnload=OnModuleUnload,
};

ModuleHandshake :: (core : *CoreModule) -> *Module #c_call {
    InitializeAPI(*g_module);

    return *g_module;
}

OnModuleUnload :: (id : ModuleID) {
    // Prevent DCE from removing these
    random_get();
    GenerateContextProxyType();

    // Profiling data potentially includes Source_Code_Locations from other modules,
    // so we need to clear it to avoid a potential crash
    ClearProfilingData(*g_cpu_profiler);
}

g_window : *SDL_Window;
g_gfx_context : GfxContext;
g_cpu_profiler : CPUFrameProfiler;

GetModule :: (id : ModuleID) -> *Module {
    return g_modules[id];
} @Public

GetWindow :: () -> *SDL_Window {
    return g_window;
} @Public

GetGfxContext :: () -> *GfxContext {
    return *g_gfx_context;
} @Public

GetCPUFrameProfiler :: () -> *CPUFrameProfiler {
    return *g_cpu_profiler;
} @Public

Quit :: () {
    g_quit = true;
} @Public

#scope_file

g_num_cpus : s32;
g_default_num_worker_threads : s32;

#scope_export

GetNumCPUs :: inline () -> s32 {
    return g_num_cpus;
} @Public

GetDefaultNumWorkerThreads :: inline () -> s32 {
    return g_default_num_worker_threads;
} @Public

InitializeCore :: (global_init : bool) {
    context.print_style.struct_printer = CoreStructPrinter;

    LoadConfigFromFile(GetEngineConfig());
    RegisterConfigEntry(GetEngineConfig(), "environment_map", g_environment_map_config);

    g_num_cpus = get_number_of_processors(.ALL_LOGICAL);
    g_num_cpus = Clamp(g_num_cpus, 1, 200);
    g_default_num_worker_threads = Max(g_num_cpus - 1, 2);
    LogMessage("CPU Information: % logical CPUs, default worker thread count: %", g_num_cpus, g_default_num_worker_threads);

    g_window = SDL_CreateWindow("Engine", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 1600, 900, SDL_WINDOW_VULKAN | SDL_WINDOW_RESIZABLE);

    InitGfxContext(g_window);

    InitFrameProfiler(*g_cpu_profiler);

    InitGPUFrameProfiler(*g_gpu_frame_profiler, 1000);

    InitTextureUpload();

    InitAssets();

    InitJolt();
}

ShutdownCore :: (global_shutdown : bool) {
    ShutdownJolt();

    DestroyAllAssetCaches();

    CleanupTextureUpload();

    DestroyGPUFrameProfiler(*g_gpu_frame_profiler);

    DestroyGfxContext();

    SDL_DestroyWindow(g_window);

    UnregisterConfigEntry(GetEngineConfig(), "environment_map");
}

g_last_frame_start_time : Basic.Apollo_Time;
g_frame_times : [120]float;
g_frame_time_index : int;

g_avg_frame_time : float = 1 / 60.0;
g_min_frame_time : float = 1 / 60.0;
g_max_frame_time : float = 1 / 60.0;
g_last_frame_time : float = 1 / 60.0;

GetFrameTimes :: inline () -> min : float, max : float, avg : float {
    return g_min_frame_time, g_max_frame_time, g_avg_frame_time;
} @Public

GetDeltaTime :: inline () -> float {
    return g_last_frame_time;
} @Public

UpdateFrameTimes :: () {
    if g_last_frame_start_time != .{} {
        frame_end := Basic.current_time_monotonic();
        frame_time := Basic.to_float64_seconds(frame_end - g_last_frame_start_time);

        g_last_frame_time = xx frame_time;

        g_frame_times[g_frame_time_index] = xx frame_time;

        if g_frame_time_index == g_frame_times.count - 1 {
            g_frame_time_index = 0;

            min := F32_Inf;
            max := -F32_Inf;
            avg : float;
            for g_frame_times {
                min = Min(min, it);
                max = Max(max, it);
                avg += it;
            }

            avg /= g_frame_times.count;

            g_min_frame_time = min;
            g_max_frame_time = max;
            g_avg_frame_time = avg;
        } else {
            g_frame_time_index += 1;
        }
    };

    g_last_frame_start_time = Basic.current_time_monotonic();
}

CoreLoop :: () {
    UpdateFrameTimes();

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
