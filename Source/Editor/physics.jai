g_show_physics_debug_draw_settings := false;

ShowPhysicsDebugDrawSettings :: () {
    if !g_show_physics_debug_draw_settings {
        return;
    }

    defer ImGui.End();

    ImGui.SetNextWindowSize(.{350, 500}, .FirstUseEver);
    if !ImGui.Begin("Physics Debug Draw Settings", *g_show_world_inspector) {
        return;
    }

    ShowInspector("", cast(*World, null), GetPhysicsDebugDrawSettings(), .["InspectorNoTree"]);
}

PhysicsMenu :: (world : *World) {
    if ImGui.BeginMenu("Physics") {
        defer ImGui.EndMenu();

        settings := GetPhysicsDebugDrawSettings();
        if ImGui.MenuItem("Debug Draw", selected=settings.enabled) {
            settings.enabled = !settings.enabled;
        }

        if ImGui.MenuItem("Debug Draw Settings", selected=g_show_physics_debug_draw_settings) {
            g_show_physics_debug_draw_settings = true;
        }
    }
} @EditorMainMenu
