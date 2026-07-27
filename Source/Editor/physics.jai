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

g_show_physics_global_settings := false;

ShowPhysicsGlobalSettings :: () {
    if !g_show_physics_global_settings {
        return;
    }

    defer ImGui.End();

    ImGui.SetNextWindowSize(.{350, 500}, .FirstUseEver);
    if !ImGui.Begin("Physics Global Settings", *g_show_physics_global_settings) {
        return;
    }

    if !ImGui.BeginTabBar("categories") {
        return;
    }

    defer ImGui.EndTabBar();

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

                    collide := ShouldPhysicsCollisionLayersCollide(xx i, xx j);

                    if ImGui.Checkbox(CTPrint("##%_%", i, j), *collide) {
                        if collide {
                            EnablePhysicsCollisionLayersCollision(xx i, xx j);
                        } else {
                            DisablePhysicsCollisionLayersCollision(xx i, xx j);
                        }
                    }
                }
            }
        }
    }
}

PhysicsMenu :: (world : *World) {
    if ImGui.BeginMenu("Physics") {
        defer ImGui.EndMenu();

        settings := GetPhysicsGlobalSettings();
        if ImGui.MenuItem("Global Settings", selected=g_show_physics_global_settings) {
            g_show_physics_global_settings = true;
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
