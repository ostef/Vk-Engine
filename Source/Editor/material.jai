g_show_material_editor := true;
g_material_editor_selected_material : *Asset(Material);

OpenMaterialEditor :: (material : *Asset(Material)) {
    g_show_material_editor = true;

    DerefAsset(*g_material_editor_selected_material);
    g_material_editor_selected_material = AddRef(material);

    window := ImGui.FindWindowByName("Material Editor");
    if window {
        ImGui.FocusWindow(window);
    }
}

ShowMaterialEditor :: () {
    if !g_show_material_editor {
        return;
    }

    defer ImGui.End();

    ImGui.SetNextWindowSize(.{350, 500}, .FirstUseEver);
    if !ImGui.Begin("Material Editor", *g_show_material_editor) {
        return;
    }

    world : *World;
    ShowInspector("Selected Material", world, g_material_editor_selected_material, .["AllowCreateAsset"]);

    if g_material_editor_selected_material {
        available := ImGui.GetContentRegionAvail();
        size := available;
        size.y -= 2 * ImGui.GetFrameHeightWithSpacing();
        size.x = Max(size.x, 0);
        size.y = Max(size.y, 0);

        if ImGui.BeginChild("material", size=size, child_flags=.Border) {
            ShowInspector("", world, g_material_editor_selected_material.asset_data, .["InspectorNoTree"]);
            ImGui.EndChild();
        } else {
            ImGui.EndChild();
            return;
        }

        PushButtonColor(.CancelButton);
        if ImGui.Button("Reload", size=.{-1, 0}) {
            reloaded, asset := TryReloadAsset(*GetAssets().Material_cache, g_material_editor_selected_material.asset_name);
            RemoveRef(asset); // TryReloadAsset adds a ref
        }
        PopButtonColor();

        PushButtonColor(.SubmitGoodButton);
        if ImGui.Button("Save", size=.{-1, 0}) {
            SaveAsset(g_material_editor_selected_material);
        }
        PopButtonColor();
    } else {
        ImGui.Text("No material selected");
    }
}
