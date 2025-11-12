g_show_world_inspector := false;

#scope_file

g_quick_load_scene_files : [..]string;
g_quick_load_last_refreshed : Basic.Apollo_Time;
g_quick_load_refresh_frequency := 5.0;

#scope_export

ListDirectories :: (path : string, recursive := false, follow_directory_symlinks := true) -> []string {
    files : [..]string;

    Visitor :: (info : *File_Visit_Info, user_data : *[..]string) {
        ArrayPush(user_data, StringClone(info.full_name));
    }

    visit_files(path, recursive, *files, Visitor, visit_files=false, visit_directories=true, follow_directory_symlinks=follow_directory_symlinks);

    return files;
}

WorldMenu :: (world : *World) {
    if ImGui.BeginMenu("World") {
        defer ImGui.EndMenu();

        if ImGui.MenuItem("New", enabled=g_game_state == .Editor) {
            DestroyWorld(world);
            InitWorld(world);
        }

        if ImGui.MenuItem("Load", enabled=g_game_state == .Editor) {
            Callback :: (browser : *FileBrowser, event : FileBrowserEvent, user_data : *void) {
                if event.kind == .Submit {
                    LoadWorldFromDirectory(xx user_data, event.filename);
                }
            }

            OpenFileBrowser("Load World", params=.{
                accept_button_text="Open Folder",
                initial_directory="Data/Scenes/",
                root_directories=.["Data"],
                flags=.SelectDirectory | .DisallowNonExisting
            }, Callback, world);
        }

        if ImGui.BeginMenu("Quick Load", enabled=g_game_state == .Editor) {
            defer ImGui.EndMenu();

            if g_quick_load_last_refreshed == .{}
            || Basic.to_float64_seconds(Basic.current_time_monotonic() - g_quick_load_last_refreshed) > g_quick_load_refresh_frequency {
                for g_quick_load_scene_files {
                    Free(it.data);
                }
                ArrayClear(*g_quick_load_scene_files);

                files := ListDirectories(GetDataDirectoryAbsolutePath(), recursive=true ,, Temp);
                for files {
                    if path_extension(it) == "scene" {
                        ArrayPush(*g_quick_load_scene_files, StringClone(it));
                    }
                }

                QuickSort(g_quick_load_scene_files, (a, b) => StringCompare(a, b));
            }

            for g_quick_load_scene_files {
                label := it;
                if StringStartsWith(label, GetDataDirectoryAbsolutePath()) {
                    StringAdvance(*label, GetDataDirectoryAbsolutePath().count);

                    if label.count > 0 && label[0] == #char "/" {
                        StringAdvance(*label, 1);
                    }
                }

                if ImGui.MenuItem(CStringClone(label ,, Temp)) {
                    LoadWorldFromDirectory(world, it);
                }
            }
        } else {
            g_quick_load_last_refreshed = .{};
        }

        if ImGui.MenuItem("Save", enabled=world.loaded_from_directory != "" && g_game_state == .Editor) {
            SaveWorldToDirectory(world, world.loaded_from_directory);
        }
        if ImGui.MenuItem("Save As", enabled=g_game_state == .Editor) {
            Callback :: (browser : *FileBrowser, event : FileBrowserEvent, user_data : *void) {
                if event.kind == .Submit {
                    SaveWorldToDirectory(xx user_data, event.filename);
                }
            }

            OpenFileBrowser("Save World", params=.{
                accept_button_text="Save To Folder",
                initial_directory="Data/Scenes/",
                root_directories=.["Data"],
                flags=.SelectDirectory
            }, Callback, world);
        }
    }
} @EditorMainMenu

AllEntitiesWithEditorIcon :: #bake_arguments AllEntitiesWithCallback(Callback="GetEditorIcon");
AllComponentsWithEditorIcon :: #bake_arguments AllComponentsWithCallback(Callback="GetEditorIcon");

g_entity_hide_editor_icon : [Entity_Types.count]bool;
g_component_hide_editor_icon : [Component_Types.count]bool;

WorldShowMenu :: (world : *World) {
    if ImGui.BeginMenu("Show") {
        defer ImGui.EndMenu();

        if ImGui.BeginMenu("Icons") {
            defer ImGui.EndMenu();

            if ImGui.MenuItem("All") {
                for * g_entity_hide_editor_icon {
                    it.* = false;
                }
                for * g_component_hide_editor_icon {
                    it.* = false;
                }
            }

            if ImGui.MenuItem("None") {
                for * g_entity_hide_editor_icon {
                    it.* = true;
                }
                for * g_component_hide_editor_icon {
                    it.* = true;
                }
            }

            ImGui.Separator();

            for i : 1..Entity_Types.count - 1 {
                info := cast(*Type_Info_Struct, Entity_Types[i]);
                has_icon := false;
                for info.members {
                    if it.name == "GetEditorIcon" {
                        has_icon = true;
                        break;
                    }
                }

                name := GetNiceEntityTypeName(cast(EntityTypeId, i));
                if ImGui.MenuItem(CStringClone(name ,, Temp), selected=!g_entity_hide_editor_icon[i], enabled=has_icon) {
                    g_entity_hide_editor_icon[i] = !g_entity_hide_editor_icon[i];
                }
            }

            ImGui.Separator();

            for i : 1..Component_Types.count - 1 {
                info := cast(*Type_Info_Struct, Component_Types[i]);
                has_icon := false;
                for info.members {
                    if it.name == "GetEditorIcon" {
                        has_icon = true;
                        break;
                    }
                }

                name := GetNiceComponentTypeName(cast(ComponentTypeId, i));
                if ImGui.MenuItem(CStringClone(name ,, Temp), selected=!g_component_hide_editor_icon[i], enabled=has_icon) {
                    g_component_hide_editor_icon[i] = !g_component_hide_editor_icon[i];
                }
            }
        }
    }
} @EditorMainMenu

WorldEditMenu :: (world : *World) {
    if ImGui.BeginMenu("Edit") {
        defer ImGui.EndMenu();

        if ImGui.MenuItem("Select All Entities") {
            ArrayClear(*g_editor_selected_entities);

            for _, guid : world.entities_by_guid {
                ArrayPush(*g_editor_selected_entities, guid);
            }
        }

        if ImGui.MenuItem("Invert Selection") {
            new_selected_entities : [..]EntityGUID;
            new_selected_entities.allocator = g_editor_selected_entities.allocator;

            for _, guid : world.entities_by_guid {
                if ArrayFindFirst(g_editor_selected_entities, guid, CompareEntityGUIDs) < 0 {
                    ArrayPush(*new_selected_entities, guid);
                }
            }

            Swap(*new_selected_entities, *g_editor_selected_entities);
            ArrayFree(*new_selected_entities);
        }
    }
} @EditorMainMenu

ShouldShowEntityEditorIcon :: inline (type : EntityTypeId) -> bool {
    return !g_entity_hide_editor_icon[type];
}

ShouldShowComponentEditorIcon :: inline (type : ComponentTypeId) -> bool {
    return !g_component_hide_editor_icon[type];
}

ShowWorldInspector :: (world : *World) {
    if !g_show_world_inspector {
        return;
    }

    defer ImGui.End();

    ImGui.SetNextWindowSize(.{350, 500}, .FirstUseEver);
    if !ImGui.Begin("World Settings", *g_show_world_inspector) {
        return;
    }

    ImGui.SeparatorText(CStringClone(world.loaded_from_directory));

    ShowInspector("", world, world, .["InspectorNoTree"]);
}
