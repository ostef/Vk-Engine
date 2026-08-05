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

#load "asset.public.jai";
#load "input.public.jai";
#load "cpu_frame_profiler.public.jai";
#load "serialize_deserialize.public.jai";
#load "utils.public.jai";

#load "Graphics/abstraction_layer.public.jai";
#load "Graphics/gpu_frame_profiler.public.jai";
#load "Graphics/texture2d.public.jai";
#load "Graphics/environment_map.public.jai";
#load "Graphics/material.public.jai";
#load "Graphics/mesh.public.jai";
#load "Graphics/animation.public.jai";

#load "Physics/types.public.jai";
#load "Physics/collision_mesh.public.jai";

#if Import_Mode == .Foreign {
    #load "module_api.public.jai";
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
