ImGui :: #import "ImGui";
ImGui_SDL :: #import "ImGui/Impl/SDL";
#import "SDL";

#load "material_design_icons.jai";
#load "viewport.jai";

Log_Editor :: Log_Section.{name="Editor"};

g_module := EditorModule.{
    base.Initialize=InitializeEditor,
    base.Shutdown=ShutdownEditor,
    base.MainLoop=EditorLoop,
    base.OnEvent=OnEvent,
    base.OnModuleLoad=OnModuleLoad,
};
g_context : #Context;

#program_export
ModuleHandshake :: (core : *CoreModule) -> *Module #c_call {
    push_context,defer_pop;

    g_Core = core;
    g_Renderer = xx GetModule(.Renderer);
    g_Game = xx GetModule(.Game);

    InitializeAPI(*g_module);

    return *g_module;
}

OnModuleLoad :: (id : ModuleID) {
    push_context,defer_pop g_context;

    if id == {
    case .Renderer; g_Renderer = xx GetModule(.Renderer);
    case .Game; g_Game = xx GetModule(.Game);
    }
}

Editor_Base_Font_Size :: 16.0;
Editor_Medium_Font_Size :: 18.0;

g_editor_base_font : *ImGui.ImFont;
g_editor_medium_font : *ImGui.ImFont;

g_editor_world : World;

InitializeEditor :: () {
    LogSectionScope(*Log_Editor);

    g_context = remap_context();
    push_context,defer_pop g_context;

    ImGui.CreateContext();
    ImGui.GetIO().ConfigFlags_ |= .DockingEnable;

    ImGui_SDL.Init(GetWindow());
    io := ImGui.GetIO();

    SetEditorStyleMoonlight();
    SetEditorStyleForBlurredBackground();

    CreateBaseEditorFont :: (size : float) -> *ImGui.ImFont {
        io := ImGui.GetIO();
        io.Fonts.TexDesiredWidth = xx GetGfxLimits().max_texture_2d_dimension;

        scale_factor := GetWindowScaleFactor(GetWindow());
        font := io.Fonts.AddFontFromFileTTF(io.Fonts, "Data/Roboto-Regular.ttf", size * scale_factor, null, io.Fonts.GetGlyphRangesDefault(io.Fonts));
        font.Scale = 1 / scale_factor;

        icon_font_size := Round(size * 1.1);

        icons_config : ImGui.ImFontConfig;
        icons_config.Constructor(*icons_config);
        icons_config.MergeMode = true;
        icons_config.PixelSnapH = true;
        icons_config.GlyphOffset.y = 1.0;
        // icons_config.GlyphMinAdvanceX = Icon_Font_Size;

        Icon_Ranges :: ImGui.ImWchar.[Icon_Min_MDI, Icon_Max_MDI, 0];
        font = io.Fonts.AddFontFromFileTTF(io.Fonts, Font_Icon_Filename_MDI,
            icon_font_size * scale_factor, *icons_config, Icon_Ranges.data);
        font.Scale = 1 / scale_factor;

        return font;
    }

    g_editor_base_font   = CreateBaseEditorFont(Editor_Base_Font_Size);
    g_editor_medium_font = CreateBaseEditorFont(Editor_Medium_Font_Size);
    // InitBigFileIconsFont();

    InitImGuiRenderer();

    LoadWorldFromDirectory(*g_editor_world, "Data/Scenes/DamagedHelmet.scene");
}

ShutdownEditor :: () {
    push_context,defer_pop g_context;

    DestroyWorld(*g_editor_world);

    WaitForRenderThread();
    WaitForGPUIdle();

    DestroyImGuiRenderer();

    ImGui_SDL.Terminate();
    ImGui.DestroyContext();
}

OnEvent :: (event : SDL_Event) {
    ImGui_SDL.HandleWindowEvent(event);
}

EditorLoop :: () {
    push_context,defer_pop g_context;

    w, h := GetWindowPixelSize(GetWindow());
    g_main_viewport.camera.viewport_size = .{xx w, xx h};

    ImGui_SDL.NewFrame();
    ImGui.NewFrame();

    UpdateCamera(*g_main_viewport.camera);
    ImGui.ShowDemoWindow(null);

    ImGui.Render();

    WaitForRenderThread();

    SubmitWorldToRenderer(*g_editor_world);

    main_viewpoint := MakeViewpointToRender(g_main_viewport);
    main_viewpoint.skybox = g_editor_world.skybox;
    AddViewpointToRender(main_viewpoint);

    SubmitFrameToRenderThread();
}

SetEditorStyleBasic :: () {
    style := ImGui.GetStyle();
    style.Constructor(style);

    ImGui.StyleColorsDark();

    style.WindowRounding = 6;
    style.WindowMenuButtonPosition = .Right;
    style.ChildRounding = 3;
    style.FrameRounding = 4;
    style.PopupRounding = 3;
    style.GrabRounding = 4;
    style.TabRounding = 6;
    style.FramePadding = .{6, 6};
    style.SeparatorTextBorderSize = 1;
    style.FrameBorderSize = 1;
    style.ItemSpacing.y = 6;
    style.ItemInnerSpacing.x = 8;

    style.Colors[ImGui.Col.Border].w = 0.25;
    style.Colors[ImGui.Col.WindowBg].w = 1.0;
    style.Colors[ImGui.Col.PopupBg].w = 1.0;
}

// Based on Moonlight style by deathsu/madam-herta
// https://github.com/Madam-Herta/Moonlight/
SetEditorStyleMoonlight :: () {
    style := ImGui.GetStyle();
    style.Constructor(style);

    style.WindowMenuButtonPosition = .Right;
    style.WindowRounding = 4;
    style.ChildRounding = 3;
    style.FrameRounding = 3;
    style.PopupRounding = 2;
    style.GrabRounding = 4;
    style.TabRounding = 3;
    style.FramePadding = .{6, 6};
    style.SeparatorTextBorderSize = 1;
    style.FrameBorderSize = 1;
    style.WindowBorderSize = 1;
    style.PopupBorderSize = 1;
    style.ItemSpacing.y = 6;
    style.ItemInnerSpacing.x = 8;
    style.GrabMinSize = 5;

    style.Colors[ImGui.Col.Text] = .{1, 1, 1, 1};
    style.Colors[ImGui.Col.TextDisabled] = .{0.274, 0.317, 0.450, 1};
    style.Colors[ImGui.Col.WindowBg] = .{0.078, 0.086, 0.101, 1};
    style.Colors[ImGui.Col.ChildBg] = .{0.092, 0.100, 0.115, 1};
    style.Colors[ImGui.Col.PopupBg] = .{0.078, 0.086, 0.101, 1};
    style.Colors[ImGui.Col.Border] = .{0.156, 0.168, 0.192, 0.250};
    style.Colors[ImGui.Col.BorderShadow] = .{0.078, 0.086, 0.101, 0.250};
    style.Colors[ImGui.Col.FrameBg] = .{0.112, 0.126, 0.154, 1};
    style.Colors[ImGui.Col.FrameBgHovered] = .{0.156, 0.168, 0.192, 1};
    style.Colors[ImGui.Col.FrameBgActive] = .{0.156, 0.168, 0.192, 1};
    style.Colors[ImGui.Col.TitleBg] = .{0.047, 0.054, 0.070, 1};
    style.Colors[ImGui.Col.TitleBgActive] = .{0.047, 0.054, 0.070, 1};
    style.Colors[ImGui.Col.TitleBgCollapsed] = .{0.078, 0.086, 0.101, 1};
    style.Colors[ImGui.Col.MenuBarBg] = .{0.098, 0.105, 0.121, 1};
    style.Colors[ImGui.Col.ScrollbarBg] = .{0.047, 0.054, 0.070, 1};
    style.Colors[ImGui.Col.ScrollbarGrab] = .{0.117, 0.133, 0.149, 1};
    style.Colors[ImGui.Col.ScrollbarGrabHovered] = .{0.156, 0.168, 0.192, 1};
    style.Colors[ImGui.Col.ScrollbarGrabActive] = .{0.117, 0.133, 0.149, 1};
    style.Colors[ImGui.Col.CheckMark] = .{0.972, 1, 0.498, 1};
    style.Colors[ImGui.Col.SliderGrab] = .{0.971, 1, 0.498, 1};
    style.Colors[ImGui.Col.SliderGrabActive] = .{1, 0.795, 0.498, 1};
    style.Colors[ImGui.Col.Button] = .{0.117, 0.133, 0.149, 1};
    style.Colors[ImGui.Col.ButtonHovered] = .{0.182, 0.189, 0.197, 1};
    style.Colors[ImGui.Col.ButtonActive] = .{0.154, 0.154, 0.154, 1};
    style.Colors[ImGui.Col.Header] = .{0.049, 0.482, 0.863, 1};
    style.Colors[ImGui.Col.HeaderHovered] = .{0.038, 0.321, 0.715, 1};
    style.Colors[ImGui.Col.HeaderActive] = .{0.123, 0.551, 0.928, 1};
    style.Colors[ImGui.Col.Separator] = .{0.141, 0.161, 0.208, 0.2};
    style.Colors[ImGui.Col.SeparatorHovered] = .{0.156, 0.184, 0.250, 0.78};
    style.Colors[ImGui.Col.SeparatorActive] = .{0.156, 0.184, 0.250, 1};
    style.Colors[ImGui.Col.ResizeGrip] = .{0.145, 0.145, 0.145, 1};
    style.Colors[ImGui.Col.ResizeGripHovered] = .{0.972, 1, 0.498, 1};
    style.Colors[ImGui.Col.ResizeGripActive] = .{0.999, 1, 0.999, 1};
    style.Colors[ImGui.Col.Tab] = .{0, 0, 0, 0};
    style.Colors[ImGui.Col.TabHovered] = .{0.04, 0.32, 0.71, 0.78};
    style.Colors[ImGui.Col.TabActive] = .{0.05, 0.48, 0.86, 0.78};
    style.Colors[ImGui.Col.TabUnfocused] = .{0, 0, 0, 0};
    style.Colors[ImGui.Col.TabUnfocusedActive] = .{0.11, 0.13, 0.16, 0.39};
    style.Colors[ImGui.Col.PlotLines] = .{0.521, 0.600, 0.701, 1};
    style.Colors[ImGui.Col.PlotLinesHovered] = .{0.039, 0.980, 0.980, 1};
    style.Colors[ImGui.Col.PlotHistogram] = .{0.884, 0.794, 0.561, 1};
    style.Colors[ImGui.Col.PlotHistogramHovered] = .{0.957, 0.957, 0.957, 1};
    style.Colors[ImGui.Col.TableHeaderBg] = .{0.089, 0.100, 0.122, 1};
    style.Colors[ImGui.Col.TableBorderStrong] = .{0.047, 0.054, 0.070, 1};
    style.Colors[ImGui.Col.TableBorderLight] = .{0.141, 0.161, 0.208, 0.2};
    style.Colors[ImGui.Col.TableRowBg] = .{0.117, 0.133, 0.149, 1};
    style.Colors[ImGui.Col.TableRowBgAlt] = .{0.098, 0.105, 0.121, 1};
    style.Colors[ImGui.Col.TextSelectedBg] = .{0.935, 0.935, 0.935, 0.376};
    style.Colors[ImGui.Col.DragDropTarget] = .{0.498, 0.513, 1, 1};
    style.Colors[ImGui.Col.NavHighlight] = .{0.266, 0.289, 1, 1};
    style.Colors[ImGui.Col.NavWindowingHighlight] = .{0.498, 0.513, 1, 1};
    style.Colors[ImGui.Col.NavWindowingDimBg] = .{0.196, 0.176, 0.545, 0.501};
    style.Colors[ImGui.Col.ModalWindowDimBg] = .{0.239, 0.233, 0.342, 0.501};
    style.Colors[ImGui.Col.DockingPreview] = .{0.341, 0.341, 0.341, 0.78};
}

SetEditorStyleOpaque :: () {
    style := ImGui.GetStyle();

    style.Colors[ImGui.Col.WindowBg].a = 1;
    style.Colors[ImGui.Col.ChildBg].a = 1;
    style.Colors[ImGui.Col.PopupBg].a = 1;
    style.Colors[ImGui.Col.FrameBg].a = 1;
    style.Colors[ImGui.Col.FrameBgHovered].a = 1;
    style.Colors[ImGui.Col.FrameBgActive].a = 1;
    style.Colors[ImGui.Col.TitleBg].a = 1;
    style.Colors[ImGui.Col.TitleBgActive].a = 1;
    style.Colors[ImGui.Col.TitleBgCollapsed].a = 1;
    style.Colors[ImGui.Col.MenuBarBg].a = 1;
    style.Colors[ImGui.Col.Button].a = 1;
    style.Colors[ImGui.Col.ButtonHovered].a = 1;
    style.Colors[ImGui.Col.ButtonActive].a = 1;
    style.Colors[ImGui.Col.Header].a = 1;
    style.Colors[ImGui.Col.HeaderHovered].a = 1;
    style.Colors[ImGui.Col.HeaderActive].a = 1;
    style.Colors[ImGui.Col.ModalWindowDimBg].a = 0.501;
    style.Colors[ImGui.Col.Tab].a = 0;
    style.Colors[ImGui.Col.TabHovered].a = 1;
    style.Colors[ImGui.Col.TabActive].a = 1;
    style.Colors[ImGui.Col.TabUnfocused].a = 0;
    style.Colors[ImGui.Col.TabUnfocusedActive].a = 1;
    style.Colors[ImGui.Col.TableHeaderBg].a = 1;
    style.Colors[ImGui.Col.TableRowBg].a = 1;
    style.Colors[ImGui.Col.TableRowBgAlt].a = 1;
    style.Colors[ImGui.Col.ScrollbarBg].a = 1;
    style.Colors[ImGui.Col.ScrollbarGrab].a = 1;
    style.Colors[ImGui.Col.ScrollbarGrabHovered].a = 1;
    style.Colors[ImGui.Col.ScrollbarGrabActive].a = 1;
    style.Colors[ImGui.Col.DockingEmptyBg].a = 1;
}

SetEditorStyleForBlurredBackground :: () {
    style := ImGui.GetStyle();

    style.Colors[ImGui.Col.WindowBg].a = 0.78;
    style.Colors[ImGui.Col.ChildBg].a = 0.78;
    style.Colors[ImGui.Col.PopupBg].a = 0.78;
    style.Colors[ImGui.Col.FrameBg].a = 0.20;
    style.Colors[ImGui.Col.FrameBgHovered].a = 0.39;
    style.Colors[ImGui.Col.FrameBgActive].a = 0.59;
    style.Colors[ImGui.Col.TitleBg].a = 0.78;
    style.Colors[ImGui.Col.TitleBgActive].a = 0.78;
    style.Colors[ImGui.Col.TitleBgCollapsed].a = 0.78;
    style.Colors[ImGui.Col.MenuBarBg].a = 0.39;
    style.Colors[ImGui.Col.Button].a = 0.78;
    style.Colors[ImGui.Col.ButtonHovered].a = 0.78;
    style.Colors[ImGui.Col.ButtonActive].a = 0.78;
    style.Colors[ImGui.Col.Header].a = 0.78;
    style.Colors[ImGui.Col.HeaderHovered].a = 0.78;
    style.Colors[ImGui.Col.HeaderActive].a = 0.78;
    style.Colors[ImGui.Col.ModalWindowDimBg].a = 0.78;
    style.Colors[ImGui.Col.Tab].a = 0;
    style.Colors[ImGui.Col.TabHovered].a = 0.78;
    style.Colors[ImGui.Col.TabActive].a = 0.78;
    style.Colors[ImGui.Col.TabUnfocused].a = 0;
    style.Colors[ImGui.Col.TabUnfocusedActive].a = 0.78;
    style.Colors[ImGui.Col.TableHeaderBg].a = 0.78;
    style.Colors[ImGui.Col.TableRowBg].a = 0.78;
    style.Colors[ImGui.Col.TableRowBgAlt].a = 0.78;
    style.Colors[ImGui.Col.ScrollbarBg].a = 0.78;
    style.Colors[ImGui.Col.ScrollbarGrab].a = 0.78;
    style.Colors[ImGui.Col.ScrollbarGrabHovered].a = 0.78;
    style.Colors[ImGui.Col.ScrollbarGrabActive].a = 0.78;
    style.Colors[ImGui.Col.DockingEmptyBg].a = 0.78;
}
