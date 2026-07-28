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
Math :: #import "Math";
Basic :: #import "Basic";
using,only(.["+","-","*","/","<",">","=="]) Basic;

Print_Style :: Basic.Print_Style; // Needed for CoreContext

#import "Random"; // Adds random_state to the context, needed to keep the same context between modules

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
    Initialize : (global_init : bool);
    Shutdown : (global_shutdown : bool);
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

#if Import_Mode == .Foreign {

AssertContextMatchesCore :: () {
    LogSectionScope(*(Log_Section.{name="ModuleLoader"}));

    context_info := type_info(#Context);
    core_info := type_info(CoreContext);

    matches := true;
    defer if !matches {
        builder : StringBuilder;

        LogError("Context type mismatch");

        Appendln(*builder, "struct {");
        for core_info.members {
            Appendln(*builder, "    % : %;", it.name, cast(*Type, *it.type).*);
        }
        Appendln(*builder, "}");

        LogError("Core context:\n%", StringBuilderBuild(*builder));

        Appendln(*builder, "struct {");
        for context_info.members {
            Appendln(*builder, "    % : %;", it.name, cast(*Type, *it.type).*);
        }
        Appendln(*builder, "}");

        LogError("Current context:\n%", StringBuilderBuild(*builder));

        Panic("Context type mismatch");
    }

    if context_info.members.count != core_info.members.count {
        matches = false;
        return;
    }

    for i : 0..context_info.members.count - 1 {
        a := context_info.members[i];
        b := core_info.members[i];

        if a.offset_in_bytes != b.offset_in_bytes {
            matches = false;
            return;
        }

        if a.name != b.name {
            matches = false;
            return;
        }

        if a.type != b.type {
            matches = false;
            return;
        }
    }
}

}
