// @Todo: better handling of module load failure

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

ReloadModule :: (id : ModuleID) -> bool {
    LogSectionScope(*Log_Loader);

    state : []u8;
    if g_modules[id].SaveState {
        state = g_modules[id].SaveState();
        LogMessage("Saved state for module %", id);
    }

    UnloadModule(id);
    if !LoadModule(id) {
        return false;
    }

    if g_modules[id].LoadState {
        g_modules[id].LoadState(state);
        LogMessage("Restored state for module %", id);
    }

    return true;
}

LoadModule :: (id : ModuleID) -> bool {
    LogSectionScope(*Log_Loader);

    handshake : ModuleHandshakeProc;

    if id == .Core {
        handshake = ModuleHandshake;
    } else {
        src_lib_path := TPrint("Libs/%.%", id, Lib_Ext);
        dst_lib_path := TPrint("Libs/%.copy.%", id, Lib_Ext);
        if !copy_file(src_lib_path, dst_lib_path) {
            LogError("Could not copy module library '%' to '%'", src_lib_path, dst_lib_path);
            return false;
        }

        g_module_libraries[id] = LoadLibrary(CStringClone(dst_lib_path ,, Temp));

        if !g_module_libraries[id] {
            error := get_error_value();
            error_msg := get_error_string(error);
            LogError("Could not load '%': %", dst_lib_path, error_msg);
            return false;
        }

        handshake = cast(ModuleHandshakeProc, GetProcAddress(g_module_libraries[id], "ModuleHandshake"));
        if !handshake {
            FreeLibrary(g_module_libraries[id]);
            g_module_libraries[id] = null;

            LogError("Could not load ModuleHandshake procedure of module %", id);
            return false;
        }
    }

    g_modules[id] = handshake(xx g_modules[ModuleID.Core]);
    if !g_modules[id] {
        FreeLibrary(g_module_libraries[id]);
        g_module_libraries[id] = null;

        LogError("Could not load module %", id);
        return false;
    }

    LogMessage("Loaded module %", id);

    if g_modules[id].Initialize {
        g_modules[id].Initialize(,, log_section=null);
        LogMessage("Initialized module %", id);
    }

    for g_modules {
        if it && it.OnModuleLoad {
            it.OnModuleLoad(id ,, log_section=null);
        }
    }

    return true;
}

UnloadModule :: (id : ModuleID) {
    LogSectionScope(*Log_Loader);

    for g_modules {
        if it && it.OnModuleUnload {
            it.OnModuleUnload(id ,, log_section=null);
        }
    }

    if g_modules[id].Shutdown {
        g_modules[id].Shutdown(,, log_section=null);
        LogMessage("Shut down module %", id);
    }

    if g_module_libraries[id] {
        FreeLibrary(g_module_libraries[id]);

        lib_path := TPrint("Libs/%.copy.%", id, Lib_Ext);
        if file_exists(lib_path) {
            file_delete(lib_path);
        }

        g_module_libraries[id] = null;
    }

    g_modules[id] = null;

    LogMessage("Unloaded module %", id);
}

ModulesChangeCallback :: (watcher : *File_Watcher(void), change : *File_Change, data : *void) {
    LogSectionScope(*Log_Loader);

    filename := path_filename(change.full_path);
    for i : 0..Num_Modules - 1 {
        id := cast(ModuleID, i);
        if filename == TPrint("%.%", id, Lib_Ext) {
            if !ReloadModule(id) {
                Basic.exit(1);
            }
        }
    }
}

LoaderMain :: () {
    InitConsoleLogger(*g_console_logger);
    SetContextLogger(*g_console_logger, ConsoleLoggerProc);
    g_console_logger.print_stack_trace = false;

    for i : 0..Num_Modules - 1 {
        if !LoadModule(cast(ModuleID, i)) {
            Basic.exit(1);
        }
    }

    defer for #v2 < i : 0..Num_Modules - 1 {
        UnloadModule(cast(ModuleID, i));
    }

    init(*g_modules_watcher, ModulesChangeCallback);
    defer deinit(*g_modules_watcher);
    add_directories(*g_modules_watcher, "Libs");

    while !g_quit {
        ResetTemporaryStorage();

        process_changes(*g_modules_watcher);

        for g_modules {
            if it.MainLoop {
                it.MainLoop(,, log_section=null);
            }
        }
    }
}

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
    }

    FreeLibrary :: (library : LibraryHandle) {
        Posix.dlclose(library);
    }

    GetProcAddress :: (library : LibraryHandle, name : *u8) -> *void {
        return Posix.dlsym(library, name);
    }
}
