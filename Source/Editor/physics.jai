g_show_physics_debug_draw_settings := false;

ShowPhysicsDebugDrawSettings :: () {
    if !g_show_physics_debug_draw_settings {
        return;
    }

    defer ImGui.End();

    ImGui.SetNextWindowSize(.{350, 500}, .FirstUseEver);
    if !ImGui.Begin("Physics Debug Draw Settings", *g_show_physics_debug_draw_settings) {
        return;
    }

    ShowInspector("", cast(*World, null), GetPhysicsDebugDrawSettings(), .["InspectorNoTree"]);
}

g_show_physics_settings := false;

ShowPhysicsSettings :: () {
    if !g_show_physics_settings {
        return;
    }

    defer ImGui.End();

    ImGui.SetNextWindowSize(.{350, 500}, .FirstUseEver);
    if !ImGui.Begin("Physics Settings", *g_show_physics_settings) {
        return;
    }

    if !ImGui.BeginTabBar("categories") {
        return;
    }

    defer ImGui.EndTabBar();

    settings := GetPhysicsSettings();
    if ImGui.BeginTabItem("Collision Layers") {
        defer ImGui.EndTabItem();

        if ImGui.BeginTable("Collision Layers", Physics_Num_Collision_Layers + 1, .Resizable) {
            defer ImGui.EndTable();

            ImGui.TableSetupColumn("");

            for i : 0..Physics_Num_Collision_Layers - 1 {
                name := PascalCaseToCapitalized(type_info(PhysicsCollisionLayer).names[i]);
                ImGui.TableSetupColumn(CTPrint("%", name));
            }

            ImGui.TableSetupScrollFreeze(1, 1);
            ImGui.TableHeadersRow();

            for i : 0..Physics_Num_Collision_Layers - 1 {
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(0);

                name := PascalCaseToCapitalized(type_info(PhysicsCollisionLayer).names[i]);
                ImGui.Text("%", name);

                for j : 0..Physics_Num_Collision_Layers - 1 {
                    ImGui.TableSetColumnIndex(xx (j + 1));

                    if ImGui.Checkbox(CTPrint("##%_%", i, j), *settings.collision_layer_matrix[i][j]) {
                        WriteConfigToFile(GetEngineConfig());
                    }
                }
            }
        }
    }
}

PhysicsMenu :: (world : *World) {
    if ImGui.BeginMenu("Physics") {
        defer ImGui.EndMenu();

        if ImGui.MenuItem("Settings", selected=g_show_physics_settings) {
            g_show_physics_settings = true;
        }

        debug_draw_settings := GetPhysicsDebugDrawSettings();
        if ImGui.MenuItem("Debug Draw", selected=debug_draw_settings.enabled) {
            debug_draw_settings.enabled = !debug_draw_settings.enabled;
        }

        if ImGui.MenuItem("Debug Draw Settings", selected=g_show_physics_debug_draw_settings) {
            g_show_physics_debug_draw_settings = true;
        }
    }
} @EditorMainMenu
