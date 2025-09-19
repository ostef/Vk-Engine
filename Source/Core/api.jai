#import "Common";
#import "SDL";
#import "Linalg";
Math :: #import "Math";
#import "Compiler";
Basic :: #import "Basic";

#load "API/input.jai";
#load "API/gfx.jai";
#load "API/gpu_frame_profiler.jai";
#load "API/cpu_frame_profiler.jai";
#load "API/utils.jai";

ModuleID :: enum {
    Core;
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
