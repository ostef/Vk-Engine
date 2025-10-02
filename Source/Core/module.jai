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
#import "String";
#import "File";
#import "Remap_Context"(VERBOSE=false);
Math :: #import "Math";
Basic :: #import "Basic";
using,only(.["+","-","*","/","<",">","=="]) Basic;

#load "API/asset.jai";
#load "API/input.jai";
#load "API/cpu_frame_profiler.jai";
#load "API/serialize_deserialize.jai";
#load "API/utils.jai";

#load "Graphics/API/gfx.jai";
#load "Graphics/API/gpu_frame_profiler.jai";
#load "Graphics/API/texture2d.jai";
#load "Graphics/API/environment_map.jai";
#load "Graphics/API/material.jai";
#load "Graphics/API/mesh.jai";
#load "Graphics/API/animation.jai";

#load "Physics/API/types.jai";
#load "Physics/API/collision_mesh.jai";

#if Import_Mode == .Foreign {
    #load "module_api.jai";
} else {
    #load "main.jai";
}

ModuleID :: enum {
    Core;
    Renderer;
    Game;
    Editor;
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
