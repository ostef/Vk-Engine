ImGui :: #import "ImGui";
ImGui_Ext :: #import "ImGuiExt";
ImGui_SDL :: #import "ImGui/Impl/SDL";
#import "SDL";
#import "Hash_Set";
#import "Hash_Map";
#import "File";
#import "File_Utilities";
#import "Remap_Context"(false);

#load "utils.jai";
#load "material_design_icons.jai";
#load "render.jai";
#load "viewport.jai";
#load "gizmo.jai";
#load "file_browser.jai";
#load "inspector.jai";
#load "world.jai";
#load "entity_outliner.jai";
#load "entity_inspector.jai";
#load "material.jai";
#load "cpu_profiler.jai";
#load "gpu_profiler.jai";
#load "misc.jai";

Log_Editor :: Log_Section.{name="Editor"};

g_module := EditorModule.{
    base.Initialize=InitializeEditor,
    base.Shutdown=ShutdownEditor,
    base.MainLoop=UpdateEditor,
    base.SaveState=SaveState,
    base.LoadState=LoadState,
    base.OnEvent=OnEvent,
    base.OnModuleLoad=OnModuleLoad,
};

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
    Remap_Context();

    if id == {
    case .Renderer; g_Renderer = xx GetModule(.Renderer);
    case .Game; g_Game = xx GetModule(.Game);
    }
}

Editor_Base_Font_Size :: 16.0;
Editor_Medium_Font_Size :: 18.0;

EditorMainMenuCallback :: #type (*World);

g_editor_main_menus : [..]EditorMainMenuCallback;

RegisterEditorMainMenu :: (callback : EditorMainMenuCallback) -> bool {
    return ArrayPushUnique(*g_editor_main_menus, callback);
}

UnregisterEditorMainMenu :: (callback : EditorMainMenuCallback) -> bool {
    index := ArrayFindFirst(g_editor_main_menus, callback);
    if index < 0 {
        return false;
    }

    ArrayOrderedRemove(*g_editor_main_menus, index);
    return true;
}

EditorViewportMenuCallback :: #type (*World, *EditorViewport);

g_editor_viewport_menus : [..]EditorViewportMenuCallback;

RegisterEditorViewportMenu :: (callback : EditorViewportMenuCallback) -> bool {
    return ArrayPushUnique(*g_editor_viewport_menus, callback);
}

UnregisterEditorViewportMenu :: (callback : EditorViewportMenuCallback) -> bool {
    index := ArrayFindFirst(g_editor_viewport_menus, callback);
    if index < 0 {
        return false;
    }

    ArrayOrderedRemove(*g_editor_viewport_menus, index);
    return true;
}

g_editor_base_font : *ImGui.ImFont;
g_editor_medium_font : *ImGui.ImFont;

g_editor_world : World;

g_show_imgui_demo := false;

g_editor_selected_entities : [..]EntityGUID;

g_editor_last_copied_entity_guid : EntityGUID;
g_editor_has_copied_entity_guid : bool;

DeselectEntity :: (entity : EntityGUID) {
    index := ArrayFindFirst(g_editor_selected_entities, entity, CompareEntityGUIDs);
    if index >= 0 {
        ArrayRemove(*g_editor_selected_entities, index);
    }
}

SelectEntity :: (entity : EntityGUID, add_to_selection := false) {
    if !add_to_selection {
        ArrayClear(*g_editor_selected_entities);
    }

    if entity != Null_Entity_GUID {
        ArrayPushUnique(*g_editor_selected_entities, entity, CompareEntityGUIDs);
    }
}

EntityIsSelected :: inline (entity : EntityGUID) -> bool {
    return ArrayFindFirst(g_editor_selected_entities, entity, CompareEntityGUIDs) != -1;
}

EntityOrParentIsSelected :: (world : *World, entity : EntityGUID) -> bool {
    e := GetEntity(world, entity);
    while e {
        if EntityIsSelected(e.guid) {
            return true;
        }

        e = GetEntity(world, e.parent);
    }

    return false;
}

InitializeEditor :: (global_init : bool) {
    Remap_Context();

    LogSectionScope(*Log_Editor);

    SDL_SetRelativeMouseMode(SDL_FALSE);

    ImGui.CreateContext();
    ImGui.GetIO().ConfigFlags_ |= .DockingEnable;

    ImGui_SDL.Init(GetWindow());
    io := ImGui.GetIO();

    SetEditorStyleMoonlight();
    // SetEditorStyleForBlurredBackground();

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
        font = io.Fonts.AddFontFromFileTTF(io.Fonts, Font_Icon_Filename_MDI, icon_font_size * scale_factor, *icons_config, Icon_Ranges.data);
        font.Scale = 1 / scale_factor;

        return font;
    }

    g_editor_base_font   = CreateBaseEditorFont(Editor_Base_Font_Size);
    g_editor_medium_font = CreateBaseEditorFont(Editor_Medium_Font_Size);
    InitBigFileIconsFont();

    InitImGuiRenderer();

    InitBillboardVertexBuffer();

    InitCustomInspectors();
    InitEditorMainMenus();
    InitEditorViewportMenus();

    if global_init {
        if file_exists(".EditorState/editor.txt") {
            state := read_entire_file(".EditorState/editor.txt");
            LoadState(xx state);
        } else {
            CreateEditorViewport();
        }
    }
}

ShutdownEditor :: (global_shutdown : bool) {
    Remap_Context();

    if global_shutdown {
        state := SaveState();
        write_entire_file(".EditorState/editor.txt", cast(string, state));
        Free(state.data);
    }

    SDL_SetRelativeMouseMode(SDL_FALSE);

    WaitForRenderThread();
    WaitForGPUIdle();

    DestroyGfxBuffer(*g_billboard_vertex_buffer);

    while g_editor_viewports.count > 0 {
        DestroyEditorViewport(g_editor_viewports[0]);
    }

    DestroyWorld(*g_editor_world);

    DestroyImGuiRenderer();

    ImGui_SDL.Terminate();
    ImGui.DestroyContext();
}

AllEditorState :: struct {
    selected_entities : []EntityGUID; @Serialize(1)
    material_editor : MaterialEditorState; @Serialize(2)
    entity_outliner : EntityOutlinerState; @Serialize(3)
    last_copied_entity_guid : EntityGUID; @Serialize(4)
    has_copied_entity_guid : bool; @Serialize(5)
    show_imgui_demo : bool; @Serialize(6)
    show_entity_inspector : bool; @Serialize(7)
    show_world_inspector : bool; @Serialize(8)
    viewports : []EditorViewportState; @Serialize(9)
    focused_window : string; @Serialize(10)
    loaded_world : string; @Serialize(11)
    main_editor_viewport_id : u64; @Serialize(12)
    cpu_profiler_window : CPUProfilerWindowState; @Serialize(13)
    show_gpu_profiler : bool; @Serialize(14)
    entity_hide_editor_icon : [Entity_Types.count]bool; @Serialize(15)
    component_hide_editor_icon : [Component_Types.count]bool; @Serialize(16)
}

SaveState :: () -> []u8 {
    Remap_Context();

    all_state := AllEditorState.{
        selected_entities=g_editor_selected_entities,
        material_editor=g_material_editor,
        entity_outliner=g_entity_outliner,
        last_copied_entity_guid=g_editor_last_copied_entity_guid,
        has_copied_entity_guid=g_editor_has_copied_entity_guid,
        show_imgui_demo=g_show_imgui_demo,
        show_entity_inspector=g_show_entity_inspector,
        show_world_inspector=g_show_world_inspector,
        loaded_world=StringClone(g_editor_world.loaded_from_directory),
        main_editor_viewport_id=ifx g_main_editor_viewport.unique_id,
        cpu_profiler_window=g_cpu_profiler_window,
        show_gpu_profiler=g_show_gpu_profiler,
    };
    defer Free(all_state.loaded_world.data);

    memcpy(*all_state.entity_hide_editor_icon, *g_entity_hide_editor_icon, size_of(type_of(g_entity_hide_editor_icon)));
    memcpy(*all_state.component_hide_editor_icon, *g_component_hide_editor_icon, size_of(type_of(g_component_hide_editor_icon)));

    make_directory_if_it_does_not_exist(".EditorState");
    SaveWorldToDirectory(*g_editor_world, ".EditorState/World");

    all_state.viewports = AllocArray(EditorViewportState, g_editor_viewports.count ,, Temp);
    for g_editor_viewports {
        all_state.viewports[it_index] = MakeEditorViewportState(it);
    }

    serializer : Serializer;
    SerializeAny(*serializer, all_state);

    ImGui.SaveIniSettingsToDisk("imgui.ini");

    return xx StringBuilderBuild(*serializer);
}

LoadState :: (state : []u8) {
    Remap_Context();

    defer Free(state.data);

    using all_state : AllEditorState;
    DeserializeAny(cast(string, state), all_state);

    for selected_entities {
        ArrayPush(*g_editor_selected_entities, it);
    }
    Free(selected_entities.data);

    g_material_editor = material_editor;
    g_entity_outliner = entity_outliner;

    g_editor_last_copied_entity_guid = last_copied_entity_guid;
    g_editor_has_copied_entity_guid = has_copied_entity_guid;

    g_show_imgui_demo = show_imgui_demo;
    g_show_entity_inspector = show_entity_inspector;
    g_show_world_inspector = show_world_inspector;

    while g_editor_viewports.count > 0 {
        DestroyEditorViewport(g_editor_viewports[0]);
    }

    for viewports {
        viewport := CreateEditorViewport(it);
        if it.unique_id == main_editor_viewport_id {
            g_main_editor_viewport = viewport;
        }
    }
    Free(viewports.data);

    LoadWorldFromDirectory(*g_editor_world, ".EditorState/World");

    g_editor_world.loaded_from_directory = loaded_world;

    g_cpu_profiler_window = cpu_profiler_window;
    g_show_gpu_profiler = show_gpu_profiler;

    memcpy(*g_entity_hide_editor_icon, *entity_hide_editor_icon, size_of(type_of(entity_hide_editor_icon)));
    memcpy(*g_component_hide_editor_icon, *component_hide_editor_icon, size_of(type_of(component_hide_editor_icon)));}

OnEvent :: (event : SDL_Event) {
    ImGui_SDL.HandleWindowEvent(event);
}

UpdateEditor :: () {
    Remap_Context();

    DestroyKilledEntities(*g_editor_world);

    ImGui_SDL.NewFrame();
    ImGui.NewFrame();

    ImGui.DockSpaceOverViewport();

    if ImGui.BeginMainMenuBar() {
        defer ImGui.EndMainMenuBar();

        // Prepare basic menus so they appear in that specific order
        if ImGui.BeginMenu("World") {
            defer ImGui.EndMenu();
        }
        if ImGui.BeginMenu("Edit") {
            defer ImGui.EndMenu();
        }
        if ImGui.BeginMenu("Show") {
            defer ImGui.EndMenu();
        }
        if ImGui.BeginMenu("Window") {
            defer ImGui.EndMenu();
        }
        if ImGui.BeginMenu("Tools") {
            defer ImGui.EndMenu();
        }

        for g_editor_main_menus {
            it(*g_editor_world);
        }

        if g_editor_world.loaded_from_directory {
            ImGui.Separator();
            ImGui.Text("%", g_editor_world.loaded_from_directory);
        }

        ImGui.Separator();
        min_time, max_time, avg_time := GetFrameTimes();
        ImGui.Text("FPS: %/%/% (min/avg/max), % ms",
            cast(int, 1 / max_time),
            cast(int, 1 / avg_time),
            cast(int, 1 / min_time),
            cast(int, GetDeltaTime() * 1000)
        );

        shaders_that_failed_to_reload := GetShadersThatFailedToReload();

        if shaders_that_failed_to_reload.count > 0 {
            ImGui.Separator();

            ImGui.PushStyleColor(.Text, .{1,0,0,1});

            if shaders_that_failed_to_reload.count == 1 {
                ImGui.Text("There were errors reloading shader '%'", shaders_that_failed_to_reload[0]);
            } else {
                ImGui.Text("There were errors reloading multiple shaders");
            }

            ImGui.PopStyleColor();
        }

        if ImGui.BeginMenu("Window") {
            defer ImGui.EndMenu();

            if ImGui.MenuItem("New Viewport") {
                CreateEditorViewport();
            }
            if ImGui.MenuItem("World Inspector", selected=g_show_world_inspector) {
                g_show_world_inspector = true;
            }
            if ImGui.MenuItem("Entity Inspector", selected=g_show_entity_inspector) {
                g_show_entity_inspector = true;
            }
            if ImGui.MenuItem("Entity Outliner", selected=g_entity_outliner.opened) {
                g_entity_outliner.opened = true;
            }
            if ImGui.MenuItem("Material Editor", selected=g_material_editor.opened) {
                g_material_editor.opened = true;
            }
            // if ImGui.MenuItem("Engine Settings", selected=g_show_engine_settings) {
            //     g_show_engine_settings = true;
            // }
            if ImGui.MenuItem("CPU Profiler", selected=g_cpu_profiler_window.opened) {
                g_cpu_profiler_window.opened = true;
            }
            if ImGui.MenuItem("GPU Profiler", selected=g_show_gpu_profiler) {
                g_show_gpu_profiler = true;
            }
            // if ImGui.MenuItem("Debug", selected=g_show_debug_window) {
            //     g_show_debug_window = true;
            // }
            if ImGui.MenuItem("ImGui Demo", selected=g_show_imgui_demo) {
                g_show_imgui_demo = true;
            }
        }
    }

    if g_show_imgui_demo {
        ImGui.ShowDemoWindow(*g_show_imgui_demo);
    }

    // Make sure all selected entities are valid
    for * g_editor_selected_entities {
        if !GetEntity(*g_editor_world, it.*) {
            remove it;
        }
    }

    UpdateEditorViewports(*g_editor_world, GetDeltaTime());

    ShowCPUProfiler();
    ShowGPUProfiler();
    ShowWorldInspector(*g_editor_world);
    ShowEntityOutliner(*g_editor_world);
    ShowMaterialEditor();

    entity_to_inspect : *Entity;
    if g_editor_selected_entities.count == 1 {
        entity_to_inspect = GetEntity(*g_editor_world, g_editor_selected_entities[0]);
    }

    ShowEntityInspector(*g_editor_world, entity_to_inspect);

    {
        ProfileBlock(GetCPUFrameProfiler(), "Entity.OnEditorUpdate");

        AllEntitiesWithOnEditorUpdate :: #bake_arguments AllEntitiesWithCallback(Callback="OnEditorUpdate");

        for :AllEntitiesWithOnEditorUpdate entity : g_editor_world {
            CallEntityCallback(*g_editor_world, entity, "OnEditorUpdate");
        }
    }

    {
        ProfileBlock(GetCPUFrameProfiler(), "Component.OnEditorUpdate");

        AllComponentsWithOnEditorUpdate :: #bake_arguments AllComponentsWithCallback(Callback="OnEditorUpdate");

        for :AllComponentsWithOnEditorUpdate component : g_editor_world {
            entity := GetEntity(*g_editor_world, component.entity_index);
            if !entity {
                continue;
            }

            CallComponentCallback(*g_editor_world, entity, component, "OnEditorUpdate");
        }
    }

    // {
    //     ProfileBlock(GetCPUFrameProfiler(), "Entity.OnDebugDraw");

    //     AllEntitiesWithOnDebugDraw :: #bake_arguments AllEntitiesWithCallback(Callback="OnDebugDraw");

    //     for :AllEntitiesWithOnDebugDraw entity : g_editor_world {
    //         CallEntityCallback(*g_editor_world, entity, "OnDebugDraw");
    //     }
    // }

    // {
    //     ProfileBlock(GetCPUFrameProfiler(), "Component.OnDebugDraw");

    //     AllComponentsWithOnDebugDraw :: #bake_arguments AllComponentsWithCallback(Callback="OnDebugDraw");

    //     for :AllComponentsWithOnDebugDraw component : g_editor_world {
    //         entity := GetEntity(*g_editor_world, component.entity_index);
    //         if !entity {
    //             continue;
    //         }

    //         CallComponentCallback(*g_editor_world, null, component, "OnDebugDraw");
    //     }
    // }

    UpdateAllFileBrowsers();

    ImGui.Render();

    WaitForRenderThread();

    SubmitEditorWorldToRenderer(*g_editor_world);

    SubmitFrameToRenderThread();
}

g_open_asset_browser_for : struct {
    asset_type : Type;
    pointer_to_pointer : **void;
    allow_create : bool;
};

OpenAssetBrowserPopupFor :: (asset_type : Type, pointer_to_pointer : **void, allow_create : bool) {
    Callback :: (browser : *FileBrowser, event : FileBrowserEvent, user_data : *void) {
        if !g_open_asset_browser_for.pointer_to_pointer {
            return;
        }

        defer if event.kind == .Submit || event.kind == .Cancel {
            g_open_asset_browser_for = .{};
        }

        if event.kind == .Submit {
            asset_type := g_open_asset_browser_for.asset_type;
            value_ptr := g_open_asset_browser_for.pointer_to_pointer;
            asset_filename := event.filename;

            RemoveRefDynamic(asset_type, value_ptr.*);
            value_ptr.* = null;

            if !StringStartsWith(asset_filename, GetDataDirectoryAbsolutePath()) {
                LogError("Selected asset filename is not in the Data/ directory");
                return;
            }

            asset_filename = StringAdvance(asset_filename, GetDataDirectoryAbsolutePath().count);
            if asset_filename.count > 0 && asset_filename[0] == #char "/" {
                asset_filename = StringAdvance(asset_filename, 1);
            }

            if event.exists {
                value_ptr.* = LoadAssetDynamic(asset_type, asset_filename);
            } else {
                value_ptr.* = AllocNewAssetDynamic(asset_type, asset_filename);
                if value_ptr.* {
                    SaveAssetDynamic(asset_type, value_ptr.*);
                }
            }
        }
    }

    Asset_Type_Filters :: FileBrowserFilter.[
        .{"Meshes", ".mesh"},
        .{"Images", ".png;.jpg;.jpeg;.tga;.hdr"},
        .{"Images (HDR)", ".hdr"},
        .{"Materials", ".mat"},
        .{"Animations", ".anim"},

        // Additional filters
        .{"Images (Non HDR)", ".png;.jpg;.jpeg;.tga"},
    ];

    g_open_asset_browser_for.asset_type = asset_type;
    g_open_asset_browser_for.pointer_to_pointer = pointer_to_pointer;
    g_open_asset_browser_for.allow_create = allow_create;

    OpenFileBrowser("Select Asset", .{
        accept_button_text="Select Asset",
        initial_directory="Data",
        root_directories=.["Data"],
        filters=Asset_Type_Filters,
    }, Callback);

    browser := GetFileBrowser("Select Asset");

    if allow_create {
        browser.flags &= ~.DisallowNonExisting;
    } else {
        browser.flags |= .DisallowNonExisting;
    }

    if asset_type == {
    case StaticMesh; #through;
    case SkinnedMesh;
        browser.selected_filter = 0;
    case Texture2D;
        browser.selected_filter = 1;
    case EnvironmentMap;
        browser.selected_filter = 2;
    case Material;
        browser.selected_filter = 3;
    case ArmatureAnimation;
        browser.selected_filter = 4;
    case;
        browser.selected_filter = -1;
    }
}

GetEntityGUIDAtPoint :: (viewport : *EditorViewport, x : int, y : int) -> EntityGUID {
    if !viewport.render_targets {
        return Null_Entity_GUID;
    }

    if x < 0 || x >= xx viewport.size.x || y < 0 || y >= xx viewport.size.y {
        return Null_Entity_GUID;
    }

    frame_index := GetFrameInFlight();
    frame_index += Gfx_Num_Frames_In_Flight - 1;
    frame_index %= Gfx_Num_Frames_In_Flight;

    buffer := *viewport.render_targets.entity_guids_readback_buffers[frame_index];
    ptr := cast(*EntityGUID, GetMappedPtr(buffer));
    index := y * cast(u32, viewport.size.x) + x;
    if !ptr || index * size_of(EntityGUID) > xx buffer.desc.size {
        return Null_Entity_GUID;
    }

    return ptr[index];
}

EditorSettings :: struct {
    colors : EditorColors; @ShowInInspector
} @ShaderType

g_editor_settings : EditorSettings;

EditorColor :: enum {
    EmphasisButton;
    EmphasisButtonHovered;
    EmphasisButtonActive;
    SubmitGoodButton;
    SubmitGoodButtonHovered;
    SubmitGoodButtonActive;
    SubmitBadButton;
    SubmitBadButtonHovered;
    SubmitBadButtonActive;
    CancelButton;
    CancelButtonHovered;
    CancelButtonActive;
}

EditorColors :: struct {
    emphasis_button := Vec4f.{0.847, 0.58, 0.192, 0.78}; @ColorEdit @ShowInInspector
    emphasis_button_hovered := Vec4f.{0.9, 0.633, 0.244, 0.78}; @ColorEdit @ShowInInspector
    emphasis_button_active := Vec4f.{0.809, 0.519, 0.097, 0.78}; @ColorEdit @ShowInInspector
    submit_good_button := Vec4f.{0.847, 0.58, 0.192, 0.78}; @ColorEdit @ShowInInspector
    submit_good_button_hovered := Vec4f.{0.9, 0.633, 0.244, 0.78}; @ColorEdit @ShowInInspector
    submit_good_button_active := Vec4f.{0.809, 0.519, 0.097, 0.78}; @ColorEdit @ShowInInspector
    submit_bad_button := Vec4f.{0.926, 0.099, 0.099, 0.78}; @ColorEdit @ShowInInspector
    submit_bad_button_hovered := Vec4f.{0.977, 0.212, 0.212, 0.78}; @ColorEdit @ShowInInspector
    submit_bad_button_active := Vec4f.{0.990, 0, 0, 0.78}; @ColorEdit @ShowInInspector
    cancel_button := Vec4f.{0.117, 0.133, 0.149, 0.78}; @ColorEdit @ShowInInspector
    cancel_button_hovered := Vec4f.{0.182, 0.189, 0.197, 0.78}; @ColorEdit @ShowInInspector
    cancel_button_active := Vec4f.{0.154, 0.154, 0.154, 0.78}; @ColorEdit @ShowInInspector

    #place emphasis_button;
    all : [12]Vec4f = ---;
} @ShaderType

PushButtonColor :: (color : EditorColor) {
    normal := Clamp(cast(int, color), 0, g_editor_settings.colors.all.count - 1);
    hovered := Clamp(cast(int, color + 1), 0, g_editor_settings.colors.all.count - 1);
    active := Clamp(cast(int, color + 2), 0, g_editor_settings.colors.all.count - 1);

    ImGui.PushStyleColor(.Button, g_editor_settings.colors.all[normal]);
    ImGui.PushStyleColor(.ButtonHovered, g_editor_settings.colors.all[hovered]);
    ImGui.PushStyleColor(.ButtonActive, g_editor_settings.colors.all[active]);
}

PopButtonColor :: () {
    ImGui.PopStyleColor(3);
}

PushFrameBgColor :: (color : EditorColor) {
    normal := Clamp(cast(int, color), 0, g_editor_settings.colors.all.count - 1);
    hovered := Clamp(cast(int, color + 1), 0, g_editor_settings.colors.all.count - 1);
    active := Clamp(cast(int, color + 2), 0, g_editor_settings.colors.all.count - 1);

    ImGui.PushStyleColor(.FrameBg, g_editor_settings.colors.all[normal]);
    ImGui.PushStyleColor(.FrameBgHovered, g_editor_settings.colors.all[hovered]);
    ImGui.PushStyleColor(.FrameBgActive, g_editor_settings.colors.all[active]);
}

PopFrameBgColor :: () {
    ImGui.PopStyleColor(3);
}
