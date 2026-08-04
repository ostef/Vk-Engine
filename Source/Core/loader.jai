// @Todo: better handling of module load failure

DefaultAllocator :: #import "Default_Allocator";
#import "File_Watcher";

#scope_file

#if OS == {
case .WINDOWS; Lib_Ext :: "dll";
case .LINUX;   Lib_Ext :: "so";
case .MACOS;   Lib_Ext :: "dylib";
}

#scope_export

Log_Loader :: Log_Section.{name="ModuleLoader"};

g_quit : bool;
g_module_libraries : [Num_Modules]*void;
g_modules : [Num_Modules]*Module;
g_modules_watcher : File_Watcher;
g_console_logger : ConsoleLogger;

g_last_module_change_time : Basic.Apollo_Time;
g_one_module_was_modified : bool;
g_modified_modules : [Num_Modules]bool;

Module_Reload_Threshold_Seconds :: 0.6;

ReloadModifiedModules :: () -> bool {
    LogSectionScope(*Log_Loader);

    defer {
        for * g_modified_modules {
            it.* = false;
        }

        g_one_module_was_modified = false;
    }

    module_states : [Num_Modules][]u8;

    // Save states
    for g_modified_modules {
        if !it {
            continue;
        }

        if g_modules[it_index].SaveState {
            module_states[it_index] = g_modules[it_index].SaveState();
            LogMessage("Saved state for module %", cast(ModuleID, it_index));
        }
    }

    // Unload modules
    for g_modified_modules {
        if !it {
            continue;
        }

        UnloadModule(xx it_index, false);
    }

    // Load modules
    for g_modified_modules {
        if !it {
            continue;
        }

        if !LoadModule(xx it_index, false) {
            return false;
        }
    }

    // Restore states
    for g_modified_modules {
        if !it {
            continue;
        }

        if g_modules[it_index].LoadState {
            g_modules[it_index].LoadState(module_states[it_index]);
            LogMessage("Restored state for module %", cast(ModuleID, it_index));
        }
    }

    return true;
} @NoProfile

LoadModule :: (id : ModuleID, first_time : bool) -> bool {
    LogSectionScope(*Log_Loader);

    handshake : ModuleHandshakeProc;

    if id == .Core {
        handshake = ModuleHandshake;
    } else {
        src_lib_path := TPrint("Bin/%.%", id, Lib_Ext);
        dst_lib_path := TPrint("Bin/%.copy.%", id, Lib_Ext);
        if !copy_file(src_lib_path, dst_lib_path) {
            Panic("Could not copy module library '%' to '%'", src_lib_path, dst_lib_path);
            return false;
        }

        g_module_libraries[id] = LoadLibrary(CStringClone(dst_lib_path ,, Temp));

        if !g_module_libraries[id] {
            error := get_error_value();
            error_msg := get_error_string(error);
            Panic("Could not load '%': %", dst_lib_path, error_msg);

            return false;
        }

        handshake = cast(ModuleHandshakeProc, GetProcAddress(g_module_libraries[id], "ModuleHandshake"));
        if !handshake {
            FreeLibrary(g_module_libraries[id]);
            g_module_libraries[id] = null;

            Panic("Could not load ModuleHandshake procedure of module %", id);
            return false;
        }
    }

    g_modules[id] = handshake(xx g_modules[ModuleID.Core]);
    if !g_modules[id] {
        FreeLibrary(g_module_libraries[id]);
        g_module_libraries[id] = null;
        Panic("Could not load module %", id);

        return false;
    }

    if first_time {
        LogMessage("Loaded module %", id);
    } else {
        LogMessage("Reloaded module %", id);
    }

    if g_modules[id].Initialize {
        g_modules[id].Initialize(first_time,, log_section=null);
        LogMessage("Initialized module %", id);
    }

    for g_modules {
        if it && it.OnModuleLoad {
            it.OnModuleLoad(id ,, log_section=null);
        }
    }

    return true;
} @NoProfile

UnloadModule :: (id : ModuleID, last_time : bool) {
    LogSectionScope(*Log_Loader);

    for g_modules {
        if it && it.OnModuleUnload {
            it.OnModuleUnload(id ,, log_section=null);
        }
    }

    if g_modules[id].Shutdown {
        g_modules[id].Shutdown(last_time,, log_section=null);
        LogMessage("Shut down module %", id);
    }

    if g_module_libraries[id] {
        FreeLibrary(g_module_libraries[id]);

        lib_path := TPrint("Bin/%.copy.%", id, Lib_Ext);
        if file_exists(lib_path) {
            if !file_delete(lib_path) {
                LogError("Could not delete file '%'", lib_path);
            }
        }

        g_module_libraries[id] = null;
    }

    g_modules[id] = null;

    LogMessage("Unloaded module %", id);
} @NoProfile

ModulesChangeCallback :: (watcher : *File_Watcher(void), change : *File_Change, data : *void) {
    LogSectionScope(*Log_Loader);

    filename := path_filename(change.full_path);
    for i : 0..Num_Modules - 1 {
        id := cast(ModuleID, i);
        if filename == TPrint("%.%", id, Lib_Ext) {
            g_modified_modules[i] = true;
            g_one_module_was_modified = true;
            g_last_module_change_time = Basic.current_time_monotonic();
        }
    }
} @NoProfile

LoaderMain :: () {
    InitConsoleLogger(*g_console_logger);
    SetContextLogger(*g_console_logger, ConsoleLoggerProc);
    g_console_logger.print_stack_trace = false;

    // Make sure the modules use the same allocator heap
    DefaultAllocator.initialize_if_needed();
    context.allocator.data = DefaultAllocator.allocator_default_heap;

    for i : 0..Num_Modules - 1 {
        if !LoadModule(cast(ModuleID, i), true) {
            Basic.exit(1);
        }
    }

    defer for < i : 0..Num_Modules - 1 {
        UnloadModule(cast(ModuleID, i), true);
    }

    random_get();

    init(*g_modules_watcher, ModulesChangeCallback, merge_window_seconds=1);
    defer deinit(g_modules_watcher);
    add_directories(*g_modules_watcher, "Bin");

    while !g_quit {
        ResetTemporaryStorage();

        process_changes(*g_modules_watcher);

        current_time := Basic.current_time_monotonic();
        if Basic.to_float64_seconds(current_time - g_last_module_change_time) >= Module_Reload_Threshold_Seconds {
            if !ReloadModifiedModules() {
                return;
            }
        }

        frame_event := ProfilerBeginFrame(*g_cpu_profiler);
        defer ProfilerEndFrame(*g_cpu_profiler, frame_event);

        for g_modules {
            if it.MainLoop {
                it.MainLoop(,, log_section=null);
            }
        }
    }
} @NoProfile

#scope_file

#if OS == .WINDOWS {
    Kernel32 :: #library,system "Kernel32";

    LibraryHandle :: *void;

    LoadLibrary :: LoadLibraryA;

    LoadLibraryA :: (filename : *u8) -> LibraryHandle #foreign Kernel32;
    FreeLibrary :: (library : LibraryHandle) -> s32 #foreign Kernel32;
    GetProcAddress :: (library : LibraryHandle, name : *u8) -> *void #foreign Kernel32;
} else {
    Posix :: #import "POSIX";

    LibraryHandle :: *void;

    LoadLibrary :: (filename : *u8) -> LibraryHandle {
        return Posix.dlopen(filename, Posix.RTLD_NOW | Posix.RTLD_GLOBAL);
    } @NoProfile

    FreeLibrary :: (library : LibraryHandle) {
        Posix.dlclose(library);
    } @NoProfile

    GetProcAddress :: (library : LibraryHandle, name : *u8) -> *void {
        return Posix.dlsym(library, name);
    } @NoProfile
}
