#module_parameters(Import_Mode := ImportMode.Foreign) {
    ImportMode :: enum {
        Foreign;
        Main;
    }
}

#import "Common";
#import "SDL";
#import "Linalg";
#import "Compiler";
Math :: #import "Math";
Basic :: #import "Basic";

#load "API/asset.jai";
#load "API/input.jai";
#load "API/gfx.jai";
#load "API/gpu_frame_profiler.jai";
#load "API/cpu_frame_profiler.jai";
#load "API/utils.jai";

#if Import_Mode == .Foreign {
    #load "module_api.jai";
} else {
    #load "main.jai";
}

ModuleID :: enum {
    Core;
    Game;
}

Num_Modules :: #run type_info(ModuleID).values.count;

Module :: struct {
    Initialize : ();
    Shutdown : ();
    MainLoop : ();
    OnEvent : (event : SDL_Event);
    SaveState : () -> []u8;
    LoadState : (state : []u8);

    OnModuleUnload : (id : ModuleID);
    OnModuleLoad : (id : ModuleID);
}

ModuleHandshakeProc :: #type (core : *CoreModule) -> *Module #c_call;

GUID :: struct {
    low, high : u64;
}

operator== :: inline (a : GUID, b : GUID) -> bool {
    return a.low == b.low && a.high == b.high;
}

EntityGUID :: #type,distinct GUID;

Null_Entity_GUID :: EntityGUID.{0,0};

operator== :: inline (a : EntityGUID, b : EntityGUID) -> bool {
    return a.low == b.low && a.high == b.high;
}
