MaterialEditorState :: struct {
    opened := false; @Serialize(1)
    visible : bool;
    selected_material : *Asset(Material); @Serialize(2)
    preview_mesh : *Asset(StaticMesh); @Serialize(3)
}

using g_material_editor : MaterialEditorState;

Material_Editor_Preview_Viewport_ID : u64 : 0xcafe;

OpenMaterialEditor :: (material : *Asset(Material)) {
    g_material_editor.opened = true;

    DerefAsset(*g_material_editor.selected_material);
    g_material_editor.selected_material = AddRef(material);

    window := ImGui.FindWindowByName("Material Editor");
    if window {
        ImGui.FocusWindow(window);
    }
}

ShowMaterialEditor :: () {
    g_material_editor.visible = false;

    if !g_material_editor.opened {
        return;
    }

    defer ImGui.End();

    ImGui.SetNextWindowSize(.{350, 500}, .FirstUseEver);
    if !ImGui.Begin("Material Editor", *g_material_editor.opened) {
        return;
    }

    g_material_editor.visible = true;

    world : *World;
    ShowInspector("Selected Material", world, g_material_editor.selected_material, .["AllowCreateAsset"]);
    ShowInspector("Preview Mesh", world, g_material_editor.preview_mesh);

    if g_material_editor.selected_material {
        available := ImGui.GetContentRegionAvail();
        size := available;
        size.y -= 2 * ImGui.GetFrameHeightWithSpacing();
        size.x = Max(size.x, 0);
        size.y = Max(size.y, 0);

        if ImGui.BeginChild("material", size=size, child_flags=.Border) {
            ShowInspector("", world, g_material_editor.selected_material.asset_data, .["InspectorNoTree"]);

            render_targets := GetViewpointRenderTargets(Material_Editor_Preview_Viewport_ID, .{300,300});
            if render_targets {
                ImGui.Image(*render_targets.final_color_texture, Vec2f.{300,300});
            }

            ImGui.EndChild();
        } else {
            ImGui.EndChild();
            return;
        }

        PushButtonColor(.CancelButton);
        if ImGui.Button("Reload", size=.{-1, 0}) {
            reloaded, asset := TryReloadAsset(*GetAssets().Material_cache, g_material_editor.selected_material.asset_name);
            RemoveRef(asset); // TryReloadAsset adds a ref
        }
        PopButtonColor();

        PushButtonColor(.SubmitGoodButton);
        if ImGui.Button("Save", size=.{-1, 0}) {
            SaveAsset(g_material_editor.selected_material);
        }
        PopButtonColor();
    } else {
        ImGui.Text("No material selected");
    }
}
