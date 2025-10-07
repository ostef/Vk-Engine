MaterialEditorState :: struct {
    opened := false; @Serialize(1)
    preview_visible : bool;
    selected_material : *Asset(Material); @Serialize(2)
    preview_mesh : *Asset(StaticMesh); @Serialize(3)
    preview_use_world_skybox := true; @Serialize(4)
    preview_size : Vec2f;
    preview_camera : EditorOrbitCamera; @Serialize(5)
    preview_mesh_rotation : Quatf; @Serialize(6)
}

EditorOrbitCamera :: struct {
    #as using _ : EditorCamera; @Serialize(1)

    target : Vec3f; @Serialize(2)
    distance_from_target := 1.0; @Serialize(3)
    has_mouse_input : bool;
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
    g_material_editor.preview_visible = false;

    if !g_material_editor.opened {
        return;
    }

    defer ImGui.End();

    ImGui.SetNextWindowSize(.{350, 500}, .FirstUseEver);
    if !ImGui.Begin("Material Editor", *g_material_editor.opened) {
        return;
    }

    world : *World;
    ShowInspector("Selected Material", world, g_material_editor.selected_material, .["AllowCreateAsset"]);

    if !g_material_editor.selected_material {
        ImGui.Text("No material selected");
        return;
    }

    available := ImGui.GetContentRegionAvail();
    size := available;
    size.y -= 2 * ImGui.GetFrameHeightWithSpacing();
    size.x = Max(size.x, 0);
    size.y = Max(size.y, 0);

    if ImGui.BeginChild("main", size=size) {
        if ImGui.BeginChild("material", child_flags=.Border | .ResizeY) {
            ShowInspector("", world, g_material_editor.selected_material.asset_data, .["InspectorNoTree"]);
        }
        ImGui.EndChild();

        ShowMaterialPreview();
    }
    ImGui.EndChild();

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
}

ShowMaterialPreview :: () {
    g_material_editor.preview_visible = false;

    defer ImGui.EndChild();
    if ImGui.BeginChild("material_preview", child_flags=.Border) {
        world : *World;
        ShowInspector("Preview Mesh", world, g_material_editor.preview_mesh);
        ShowInspector("Use World Skybox", world, g_material_editor.preview_use_world_skybox);

        available := ImGui.GetContentRegionAvail();
        width := Min(available.x, available.y);
        g_material_editor.preview_size = Vec2f.{width, width};

        uv0 := Vec2f.{0,0};
        uv1 := Vec2f.{1,1};
        // #if Gfx_Texture_Origin_Bottom_Left {
        //     uv0.y = 1 - uv0.y;
        //     uv1.y = 1 - uv1.y;
        // }

        window := ImGui.GetCurrentWindow();
        if window.SkipItems {
            return;
        }

        content_id := ImGui.GetID("viewport_content");
        position := ImGui.GetCursorScreenPos();
        bb := ImGui.ImRect.{position, position + g_material_editor.preview_size};
        bb.Min += (available - g_material_editor.preview_size) * 0.5;
        bb.Max += (available - g_material_editor.preview_size) * 0.5;

        ImGui.ItemSize(g_material_editor.preview_size);
        if !ImGui.ItemAdd(bb, content_id) {
            return;
        }

        is_hovered, has_mouse_input : bool;
        ImGui.ButtonBehavior(bb, content_id, *is_hovered, *has_mouse_input, .MouseButtonLeft | .MouseButtonRight);

        if has_mouse_input {
            ImGui.SetItemKeyOwner(.MouseWheelY);
        }

        g_material_editor.preview_visible = true;

        UpdateOrbitCamera(*g_material_editor.preview_camera, has_mouse_input);

        draw_list := ImGui.GetWindowDrawList();
        render_targets : *ViewpointRenderTargets;
        if g_material_editor.selected_material && g_material_editor.preview_mesh {
            render_targets = GetViewpointRenderTargets(Material_Editor_Preview_Viewport_ID, .{xx Max(g_material_editor.preview_size.x, 0), xx Max(g_material_editor.preview_size.y, 0)});
        }

        if render_targets {
            draw_list.AddImage(draw_list, *render_targets.final_color_texture, bb.Min, bb.Max, uv0, uv1, 0xffffffff);
        }
    }
}

UpdateOrbitCamera :: (camera : *EditorOrbitCamera, has_mouse_input : bool) {
    defer CalculateCameraTransforms(camera, g_material_editor.preview_size);

    had_mouse_input := camera.has_mouse_input;
    camera.has_mouse_input = has_mouse_input;

    if has_mouse_input {
        SDL_SetRelativeMouseMode(SDL_TRUE);

        if IsMouseButtonDown(.Left) {
            rotation_delta := GetRawMouseDelta() * camera.rotation_speed;

            camera.target_yaw += ToRads(rotation_delta.x);
            camera.target_pitch += ToRads(rotation_delta.y);
            camera.target_pitch = Clamp(camera.target_pitch, ToRads(-90), ToRads(90));
        } else if IsMouseButtonDown(.Right) {
            rotation_delta := GetRawMouseDelta() * 0.1;
            rotation := QuatFromAxisAngle(Vec3f.{0,1,0}, ToRads(rotation_delta.x));
            g_material_editor.preview_mesh_rotation *= rotation;
        }

        mouse_wheel := GetMouseWheel();
        camera.distance_from_target -= mouse_wheel.y * 0.1;
        camera.distance_from_target = Max(camera.distance_from_target, 0.1);
    } else if had_mouse_input {
        SDL_SetRelativeMouseMode(SDL_FALSE);
    }

    yaw := Lerp(camera.yaw, camera.target_yaw, camera.rotation_smoothing);
    pitch := Lerp(camera.pitch, camera.target_pitch, camera.rotation_smoothing);

    rotation := QuatfFromEulerAnglesYXZ(.{x=pitch,y=yaw});

    camera.position = camera.target - ForwardVector(rotation) * camera.distance_from_target;
}
