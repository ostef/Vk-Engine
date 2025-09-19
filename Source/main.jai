// @Todo: better handling of module load failure

#import "Common";
#import "System";
#import "String";
#import "File";
#import "File_Utilities";
#import "File_Watcher";

//#import "Core"(.Program);
#load "Core/main.jai";

#scope_file

#if OS == {
case .WINDOWS; Lib_Ext :: "dll";
case .LINUX;   Lib_Ext :: "so";
case .MACOS;   Lib_Ext :: "dylib";
}

#scope_export

g_quit : bool;
g_module_libraries : [Num_Modules]*void;
g_modules : [Num_Modules]*Module;
g_modules_watcher : File_Watcher;

ReloadModule :: (id : ModuleID) -> bool {
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

    for g_modules {
        if it && it.OnModuleLoad {
            it.OnModuleLoad(id);
        }
    }

    LogMessage("Loaded module %", id);

    return true;
}

UnloadModule :: (id : ModuleID) {
    for g_modules {
        if it && it.OnModuleUnload {
            it.OnModuleUnload(id);
        }
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

main :: () {
    for i : 0..Num_Modules - 1 {
        if !LoadModule(cast(ModuleID, i)) {
            Basic.exit(1);
        }
    }

    defer for #v2 < i : 0..Num_Modules - 1 {
        UnloadModule(cast(ModuleID, i));
    }

    for g_modules {
        if it.Initialize {
            it.Initialize();
        }
    }

    defer for < g_modules {
        if it.Shutdown {
            it.Shutdown();
        }
    }

    init(*g_modules_watcher, ModulesChangeCallback);
    defer deinit(*g_modules_watcher);
    add_directories(*g_modules_watcher, "Libs");

    while !g_quit {
        ResetTemporaryStorage();

        process_changes(*g_modules_watcher);

        for g_modules {
            if it.MainLoop {
                it.MainLoop();
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
