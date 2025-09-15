#import "SDL";
#import "Linalg";

#load "API/input.jai";

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

CoreModule :: struct {
    #as base : Module;

    Quit : ();
    GetModule : (id : ModuleID) -> *Module;
    GetWindow : () -> *SDL_Window;

    using input : InputAPI;
}

#if Module_ID != .Core {

#insert -> string {
    dummy : *CoreModule; // Make sure the compiler understands that we want to wait on CoreModule
    return "using,except(base) g_core : *CoreModule;";
}

}
