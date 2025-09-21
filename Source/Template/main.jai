Module_ID :: ModuleID.Template;

g_module := TemplateModule.{
    base.Initialize=InitializeTemplate,
    base.Shutdown=ShutdownTemplate,
    base.MainLoop=TemplateLoop,
    base.OnEvent=OnEvent,
};

#program_export
ModuleHandshake :: (core : *CoreModule) -> *Module #c_call {
    g_Core = core;
    //g_SomeModule = GetModule(.SomeModule);

    InitializeAPI(*g_module);

    return *g_module;
}

InitializeGame :: () {
}

ShutdownGame :: () {
}

GameLoop :: () {
}

OnEvent :: (event : SDL_Event) {
}
