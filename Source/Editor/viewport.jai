g_editor_viewport_config : struct {
    box_selection_threshold : u32 = 20;
};

EditorViewport :: struct {
    unique_id : u64;

    visible : bool;
    position : Vec2f;
    size : Vec2f;
    mouse_position : Vec2f;

    is_hovered : bool;

    had_mouse_input_previous_frame : bool;
    has_mouse_input : bool;
    has_keyboard_input : bool;

    event_callbacks : [..]EditorViewportEventCallback;

    render_targets : *ViewpointRenderTargets;

    camera : EditorViewportCamera;
    gizmo_ctx : GizmoContext;

    show_debug_drawings := true;
    show_grid := true;
    show_wireframe := false;

    is_box_selecting : bool;
    is_lasso_selecting : bool;
    selection_start : Vec2i;
    lasso_points : [..]Vec2i;
    lasso_min, lasso_max : Vec2i;
}

g_editor_viewport_id_counter : u64 = 1;
g_editor_viewports : [..]*EditorViewport;
g_main_editor_viewport : *EditorViewport;

EditorViewportState :: struct {
    unique_id : u64; @Serialize(1)
    camera : EditorViewportCamera; @Serialize(2)
    gizmo_ctx : GizmoContextState; @Serialize(3)
    show_grid : bool; @Serialize(4)
    show_debug_drawings : bool; @Serialize(5)
    show_wireframe : bool; @Serialize(6)
}

MakeEditorViewportState :: inline (viewport : *EditorViewport) -> EditorViewportState {
    return .{
        unique_id=viewport.unique_id,
        camera=viewport.camera,
        gizmo_ctx=MakeGizmoContextState(*viewport.gizmo_ctx),
        show_grid=viewport.show_grid,
        show_debug_drawings=viewport.show_debug_drawings,
        show_wireframe=viewport.show_wireframe,
    };
}

CreateEditorViewport :: (state : EditorViewportState) -> *EditorViewport {
    LogSectionScope(*Log_Editor);

    viewport := CreateEditorViewport();
    viewport.unique_id = state.unique_id;

    viewport.camera = state.camera;
    viewport.camera.viewport = viewport;

    viewport.show_grid = state.show_grid;
    viewport.show_debug_drawings = state.show_debug_drawings;
    viewport.show_wireframe = state.show_wireframe;

    SetGizmoContextState(*viewport.gizmo_ctx, state.gizmo_ctx);

    return viewport;
}

CreateEditorViewport :: () -> *EditorViewport {
    LogSectionScope(*Log_Editor);

    viewport := Alloc(EditorViewport);
    viewport.unique_id = g_editor_viewport_id_counter;
    g_editor_viewport_id_counter += 1;

    viewport.camera.viewport = viewport;
    InitGizmoContext(*viewport.gizmo_ctx, viewport);

    ArrayPush(*g_editor_viewports, viewport);

    RegisterEventCallback(viewport, HandleEventForCameraMovement);
    RegisterEventCallback(viewport, HandleEventForGizmos);
    RegisterEventCallback(viewport, HandleEventForEntitySelection);

    if !g_main_editor_viewport {
        g_main_editor_viewport = viewport;
    }

    LogMessage("Created editor viewport %", viewport.unique_id);

    return viewport;
}

DestroyEditorViewport :: (viewport : *EditorViewport) {
    LogSectionScope(*Log_Editor);

    index := ArrayFindFirst(g_editor_viewports, viewport);
    if index >= 0 {
        ArrayOrderedRemove(*g_editor_viewports, index);
    }

    if g_main_editor_viewport == viewport {
        if g_editor_viewports.count > 0 {
            g_main_editor_viewport = g_editor_viewports[0];
        } else {
            g_main_editor_viewport = null;
        }
    }

    DestroyGizmoContext(*viewport.gizmo_ctx);

    ArrayFree(*viewport.event_callbacks);

    LogMessage("Destroyed editor viewport %", viewport.unique_id);

    Free(viewport);
}

EditorViewportCamera :: struct {
    #as using _ : EditorCamera; @Serialize(1)

    viewport : *EditorViewport;

    is_moving : bool;
    speed_mult := 1.0; @Serialize(10)
    base_speed := 0.1; @Serialize(11)
    fast_speed := 1.0; @Serialize(12)
}

EditorCamera :: struct {
    position := #run Normalized(Vec3f.{-1,1,-1}) * 10; @Serialize(1)
    rotation : Quatf; @Serialize(2)

    target_yaw := #run ToRads(30.0); @Serialize(3)
    target_pitch := #run ToRads(30.0); @Serialize(4)

    yaw := #run ToRads(30.0); @Serialize(5)
    pitch := #run ToRads(30.0); @Serialize(6)

    rotation_speed := 0.2; @Serialize(13)
    rotation_smoothing := 0.3; @Serialize(14)

    fov_in_degrees := 80.0; @Serialize(7)
    z_near := 0.1; @Serialize(8)
    z_far := 1000.0; @Serialize(9)

    transform : Mat4f;
    view : Mat4f;
    projection : Mat4f;
    inv_projection : Mat4f;
    ortho_projection : Mat4f;
    inv_ortho_projection : Mat4f;
}

RayFromViewportPoint :: (camera : *EditorCamera, point : Vec2f) -> origin : Vec3f, direction : Vec3f {
    clip_space := (camera.ortho_projection * Vec4f.{point.x , point.y, 0, 1}).xy;

    view_space := camera.inv_projection * Vec4f.{xy=clip_space,z=0,w=1};
    view_space.z = 1;
    view_space.w = 0;

    origin := TranslationVector(camera.transform);
    direction := Normalized((camera.transform * view_space).xyz);

    return origin, direction;
}

RayFromMouse :: inline (viewport : *EditorViewport) -> origin : Vec3f, direction : Vec3f {
    origin, direction := RayFromViewportPoint(*viewport.camera, viewport.mouse_position);

    return origin, direction;
}

WorldToCamera :: (camera : *EditorCamera, point : Vec3f) -> is_behind : bool, Vec2f {
    proj := camera.projection * camera.view * Vec4f.{xyz=point,w=1};
    if proj.w < 0 {
        return true, .{};
    }

    proj /= proj.w;
    proj = camera.inv_ortho_projection * proj;

    return false, proj.xy;
}

UpdateEditorViewports :: (world : *World, delta_time : float) {
    LogSectionScope(*Log_Editor);

    for g_editor_viewports {
        UpdateEditorViewport(world, it, delta_time);
    }
}

RegisterEventCallback :: (viewport : *EditorViewport, callback : EditorViewportEventCallback) {
    ArrayPushUnique(*viewport.event_callbacks, callback);
}

UnregisterEventCallback :: (viewport : *EditorViewport, callback : EditorViewportEventCallback) {
    index := ArrayFindFirst(viewport.event_callbacks, callback);
    if index >= 0 {
        ArrayOrderedRemove(*viewport.event_callbacks, index);
    }
}

EditorViewportEvent :: struct {
    Kind :: enum {
        MousePosition;
        MouseButtonPress;
        MouseButtonRelease;
        MouseWheel;

        Keyboard;
    }

    kind : Kind;
    mouse_position : Vec2f;
    mouse_button : MouseButton;
    mouse_wheel : Vec2f;
    key_mods : KeyMods;
}

EditorViewportEventCallback :: #type (world : *World, viewport : *EditorViewport, event : EditorViewportEvent) -> capture_event : bool;

ShowEditorViewportWindow :: (world : *World, using viewport : *EditorViewport) -> opened : bool {
    opened := true;

    defer ImGui.End();

    {
        id := ifx g_main_editor_viewport == viewport
            then CTPrint("Viewport (Main)###viewport_%", unique_id)
            else CTPrint("Viewport###viewport_%", unique_id);

        ImGui.PushStyleVar(.WindowPadding, Vec2f.{0,0});
        defer ImGui.PopStyleVar();

        ImGui.SetNextWindowSize(.{1000, 700}, .FirstUseEver);
        visible = ImGui.Begin(id, *opened, flags=.MenuBar);
        if !visible {
            return opened;
        }
    }

    has_keyboard_input = ImGui.IsWindowFocused();

    if ImGui.BeginMenuBar() {
        defer ImGui.EndMenuBar();

        for g_editor_viewport_menus {
            if it_index != 0  {
                ImGui.Separator();
            }

            it(world, viewport);
        }
    }

    size = ImGui.GetContentRegionAvail();
    render_targets = GetViewpointRenderTargets(unique_id);

    uv0 := Vec2f.{0,0};
    uv1 := Vec2f.{1,1};
    // #if Gfx_Texture_Origin_Bottom_Left {
    //     uv0.y = 1 - uv0.y;
    //     uv1.y = 1 - uv1.y;
    // }

    window := ImGui.GetCurrentWindow();
    if window.SkipItems {
        return opened;
    }

    content_id := ImGui.GetID("viewport_content");
    position = ImGui.GetCursorScreenPos();
    mouse_position = ImGui.GetMousePos() - position;
    bb := ImGui.ImRect.{position, position + size};
    ImGui.ItemSize(size);
    if !ImGui.ItemAdd(bb, content_id) {
        return opened;
    }

    ImGui.ButtonBehavior(bb, content_id, *is_hovered, *has_mouse_input, .MouseButtonLeft | .MouseButtonRight | .MouseButtonMiddle);

    draw_list := ImGui.GetWindowDrawList();
    if render_targets {
        draw_list.AddImage(draw_list, *render_targets.final_color_texture, bb.Min, bb.Max, uv0, uv1, 0xffffffff);
    }

    if IsBoxSelecting(viewport, mouse_position) {
        mouse_x := cast(s32, mouse_position.x + position.x);
        mouse_y := cast(s32, mouse_position.y + position.y);

        x1 := Min(selection_start.x + cast(s32, position.x), mouse_x);
        y1 := Min(selection_start.y + cast(s32, position.y), mouse_y);
        x2 := Max(selection_start.x + cast(s32, position.x), mouse_x);
        y2 := Max(selection_start.y + cast(s32, position.y), mouse_y);

        AddSelectionBox(draw_list, .{xx x1, xx y1}, .{xx x2, xx y2});
    }

    if is_lasso_selecting {
        points := AllocArray(Vec2f, lasso_points.count ,, Temp);
        for lasso_points {
            points[it_index] = .{xx it.x, xx it.y};
            points[it_index] += position;
        }

        // @Todo: triangulate the polygon (concave and self intersecting, so a bit hard)
        draw_list.AddPolyline(draw_list, points.data, xx points.count, U32Color(.{1,1,1,1}), .Closed, 1);
    }

    return opened;
}

UpdateEditorViewport :: (world : *World, using viewport : *EditorViewport, delta_time : float) {
    had_mouse_input_previous_frame = has_mouse_input;

    if !ShowEditorViewportWindow(world, viewport) {
        DestroyEditorViewport(viewport);
        return;
    }

    SendEditorViewportEvents(world, viewport);

    CalculateCameraTransforms(*camera, .{xx size.x, xx size.y});

    UpdateGizmos(world, *gizmo_ctx);

    EntityGizmo(world, *gizmo_ctx);
}

SendEditorViewportEvents :: (world : *World, viewport : *EditorViewport) {
    MouseButtonEventHelper :: (button : MouseButton, event : EditorViewportEvent.Kind, $func : (MouseButton) -> bool) #expand {
        if func(button) {
            HandleEditorViewportEvent(world, viewport, .{
                kind=event,
                mouse_position=viewport.mouse_position,
                mouse_button=button,
                key_mods=GetModState(),
            });
        }
    }

    if viewport.is_hovered || viewport.has_mouse_input {
        HandleEditorViewportEvent(world, viewport, .{
            kind=.MousePosition,
            mouse_position=viewport.mouse_position,
        });

        MouseButtonEventHelper(.Left, .MouseButtonPress, IsMouseButtonPressed);
        MouseButtonEventHelper(.Right, .MouseButtonPress, IsMouseButtonPressed);
        MouseButtonEventHelper(.Middle, .MouseButtonPress, IsMouseButtonPressed);

        if GetMouseWheel() != .{} {
            HandleEditorViewportEvent(world, viewport, .{
                kind=.MouseWheel,
                mouse_position=viewport.mouse_position,
                mouse_wheel=GetMouseWheel(),
                key_mods=GetModState(),
            });
        }
    }

    if viewport.is_hovered || viewport.has_mouse_input || viewport.had_mouse_input_previous_frame {
        MouseButtonEventHelper(.Left, .MouseButtonRelease, IsMouseButtonReleased);
        MouseButtonEventHelper(.Right, .MouseButtonRelease, IsMouseButtonReleased);
        MouseButtonEventHelper(.Middle, .MouseButtonRelease, IsMouseButtonReleased);
    }

    if viewport.has_keyboard_input {
        HandleEditorViewportEvent(world, viewport, .{
            kind=.Keyboard,
            key_mods=GetModState(),
        });
    }
}

HandleEditorViewportEvent :: (world : *World, viewport : *EditorViewport, event : EditorViewportEvent) -> captured : bool {
    for viewport.event_callbacks {
        callback := it;
        capture := callback(world, viewport, event);

        if capture {
            ArrayOrderedRemove(*viewport.event_callbacks, it_index);
            ArrayOrderedInsert(*viewport.event_callbacks, 0, callback);

            return true;
        }
    }

    return false;
}

CalculateCameraTransforms :: (camera : *EditorCamera, size : Vec2f) {
    camera.yaw = Lerp(camera.yaw, camera.target_yaw, camera.rotation_smoothing);
    camera.pitch = Lerp(camera.pitch, camera.target_pitch, camera.rotation_smoothing);

    camera.rotation = QuatfFromEulerAnglesYXZ(.{x=camera.pitch,y=camera.yaw});

    camera.transform = Mat4fTranslate(camera.position) * Mat4fFromQuat(camera.rotation);
    camera.view = Inverse(camera.transform);

    if Reverse_Depth_Range {
        camera.projection = Mat4fPerspectiveProjection(camera.fov_in_degrees, size.x / size.y, camera.z_far, camera.z_near);
    } else {
        camera.projection = Mat4fPerspectiveProjection(camera.fov_in_degrees, size.x / size.y, camera.z_near, camera.z_far);
    }

    camera.inv_projection = Inverse(camera.projection);

    camera.ortho_projection = Mat4fOrthographicProjection(0, size.x, size.y, 0, -1, 1);
    camera.inv_ortho_projection = Inverse(camera.ortho_projection);
}

HandleEventForCameraMovement :: (world : *World, using viewport : *EditorViewport, event : EditorViewportEvent) -> capture_event : bool {
    defer CalculateCameraTransforms(*camera, .{xx size.x, xx size.y});

    if event.kind == {
    case .Keyboard;
        if camera.is_moving && !IsKeyDown(.Ctrl) {
            movement_input : Vec3f;
            movement_input.x = GetKeyAxisValue(.A, .D);
            movement_input.y = GetKeyAxisValue(.Q, .E);
            movement_input.z = GetKeyAxisValue(.S, .W);
            movement_input = Normalized(movement_input);

            speed := ifx IsKeyDown(.Shift)
                then camera.fast_speed
                else camera.base_speed;

            speed *= camera.speed_mult;

            // @Todo: delta timing
            camera.position += speed * (
                RightVector(camera.rotation) * movement_input.x +
                UpVector(camera.rotation) * movement_input.y +
                ForwardVector (camera.rotation) * movement_input.z
            );

            return true;
        }

    case .MousePosition;
        if camera.is_moving {
            SDL_SetRelativeMouseMode(SDL_TRUE);

            rotation_delta := GetRawMouseDelta() * camera.rotation_speed;

            camera.target_yaw += ToRads(rotation_delta.x);
            camera.target_pitch += ToRads(rotation_delta.y);
            camera.target_pitch = Clamp(camera.target_pitch, ToRads(-90), ToRads(90));

            return true;
        }

    case .MouseWheel;
        if camera.is_moving {
            if event.mouse_wheel.y < 0 {
                camera.speed_mult -= 0.2;
            } else if event.mouse_wheel.y > 0 {
                camera.speed_mult += 0.2;
            }
            camera.speed_mult = Clamp(camera.speed_mult, 0.2, 100);

            return true;
        }

    case .MouseButtonPress;
        if event.mouse_button == .Right && !(GetModState() & .Ctrl) {
            camera.is_moving = true;
        }

        return camera.is_moving;

    case .MouseButtonRelease;
        was_moving_camera := camera.is_moving;
        if event.mouse_button == .Right {
            camera.is_moving = false;

            if was_moving_camera {
                SDL_SetRelativeMouseMode(SDL_FALSE);
            }
        }

        // Just in case, if we were moving the camera then don't propagate event this time
        return was_moving_camera;
    }

    return false;
}

IsBoxSelecting :: inline (viewport : *EditorViewport, mouse_position : Vec2f) -> bool {
    return viewport.is_box_selecting
        && (Abs(mouse_position.x - viewport.selection_start.x) > xx g_editor_viewport_config.box_selection_threshold
        || Abs(mouse_position.y - viewport.selection_start.y) > xx g_editor_viewport_config.box_selection_threshold);
}

PushLassoPoint :: (using viewport : *EditorViewport, point : Vec2i) {
    if lasso_points.count > 0 && Length(lasso_points[lasso_points.count - 1] - point) < 2 {
        return;
    }

    ArrayPush(*lasso_points, point);
    lasso_min = .{Min(lasso_min.x, point.x), Min(lasso_min.y, point.y)};
    lasso_max = .{Max(lasso_max.x, point.x), Max(lasso_max.y, point.y)};
}

PointIsInsideLasso :: (using viewport : *EditorViewport, point : Vec2i) -> bool {
    if !is_lasso_selecting {
        return false;
    }

    intersections := 0;
    for i : 0..lasso_points.count - 1 {
        p0 := lasso_points[i];
        p1 := lasso_points[(i + 1) % lasso_points.count];

        crosses := (p0.y > point.y) != (p1.y > point.y);
        if crosses {
            t := (point.y - p0.y) / cast(float, p1.y - p0.y);
            x_at_y := p0.x + t * (p1.x - p0.x);
            if x_at_y < cast(float, point.x) {
                intersections += 1;
            }
        }
    }

    return (intersections % 2) != 0;
}

HandleEventForEntitySelection :: (world : *World, using viewport : *EditorViewport, event : EditorViewportEvent) -> capture_event : bool {
    if event.kind == {
    case .MousePosition;
        if is_lasso_selecting {
            PushLassoPoint(viewport, .{xx event.mouse_position.x, xx event.mouse_position.y});
            return true;
        }

        if is_box_selecting {
            return true;
        }

    case .MouseButtonPress;
        if event.mouse_button == .Left {
            is_box_selecting = true;
            is_lasso_selecting = false;
            selection_start = .{xx event.mouse_position.x, xx event.mouse_position.y};
        }

        if event.mouse_button == .Right && GetModState() & .Ctrl {
            is_lasso_selecting = true;
            is_box_selecting = false;
            ArrayClear(*lasso_points);
            selection_start = .{xx event.mouse_position.x, xx event.mouse_position.y};
            lasso_min = selection_start;
            lasso_max = selection_start;
        }

        // Also capture mouse right and middle buttons when selecting
        return is_box_selecting || is_lasso_selecting;

    case .MouseButtonRelease;
        was_selecting := is_box_selecting || is_lasso_selecting;
        if is_box_selecting && event.mouse_button == .Left {
            x1, y1, x2, y2 : s32;

            if IsBoxSelecting(viewport, event.mouse_position) {
                x1 = Min(selection_start.x, xx event.mouse_position.x);
                y1 = Min(selection_start.y, xx event.mouse_position.y);
                x2 = Max(selection_start.x, xx event.mouse_position.x);
                y2 = Max(selection_start.y, xx event.mouse_position.y);
            } else {
                x1 = xx event.mouse_position.x;
                x2 = xx event.mouse_position.x;
                y1 = xx event.mouse_position.y;
                y2 = xx event.mouse_position.y;
            }

            scale_factor := GetWindowScaleFactor(GetWindow());
            x1 = xx (x1 * scale_factor);
            x2 = xx (x2 * scale_factor);
            y1 = xx (y1 * scale_factor);
            y2 = xx (y2 * scale_factor);

            if GetModState() != .Shift && GetModState() != (.Ctrl | .Shift) {
                ArrayClear(*g_editor_selected_entities);
            }

            for y : y1..y2 {
                for x : x1..x2 {
                    id := GetEntityIDAtPoint(viewport, xx x, xx y);
                    if id != Null_Entity_ID {
                        if GetModState() == (.Ctrl | .Shift) {
                            DeselectEntity(id);
                        } else {
                            SelectEntity(id, add_to_selection=true);
                        }
                    }
                }
            }

            is_box_selecting = false;
        }

        if is_lasso_selecting && event.mouse_button == .Right {
            x1 := Min(lasso_min.x, lasso_max.x);
            y1 := Min(lasso_min.y, lasso_max.y);
            x2 := Max(lasso_min.x, lasso_max.x);
            y2 := Max(lasso_min.y, lasso_max.y);

            scale_factor := GetWindowScaleFactor(GetWindow());
            x1 = xx (x1 * scale_factor);
            x2 = xx (x2 * scale_factor);
            y1 = xx (y1 * scale_factor);
            y2 = xx (y2 * scale_factor);

            if !(GetModState() & .Shift) {
                ArrayClear(*g_editor_selected_entities);
            }

            for y : y1..y2 {
                for x : x1..x2 {
                    if !PointIsInsideLasso(viewport, .{x, y}) {
                        continue;
                    }

                    id := GetEntityIDAtPoint(viewport, xx x, xx y);
                    if id != Null_Entity_ID {
                        SelectEntity(id, add_to_selection=true);
                    }
                }
            }

            ArrayClear(*lasso_points);
            is_lasso_selecting = false;
        }

        return was_selecting;
    }

    return false;
}

MakeViewpointToRender :: (camera : *EditorCamera, size : Vec2u) -> ViewpointToRender {
    view_projection := camera.projection * camera.view;

    return .{
        position=camera.position,
        right=RightVector(camera.transform),
        up=UpVector(camera.transform),
        direction=ForwardVector(camera.transform),
        transform=camera.transform,
        view=camera.view,
        projection=camera.projection,
        inv_projection=camera.inv_projection,
        view_projection=view_projection,
        inv_view_projection=Inverse(view_projection),
        fov=ToRads(camera.fov_in_degrees),
        z_near=camera.z_near,
        z_far=camera.z_far,
        resolution=size,
        frustum=MakePerspectiveFrustum(camera.transform, camera.fov_in_degrees, size.x / cast(float, size.y), camera.z_near, camera.z_far),
    };
}

MakeViewpointToRender :: (using viewport : EditorViewport) -> ViewpointToRender {
    viewpoint := MakeViewpointToRender(*camera, .{xx Max(size.x, 0), xx Max(size.y, 0)});
    viewpoint.unique_id = unique_id;

    if show_wireframe {
        viewpoint.flags |= .ShowWireframe;
    }

    if !show_debug_drawings {
        viewpoint.flags |= .NoDebugLines;
    }

    if !show_grid {
        viewpoint.flags |= .NoGrids;
    }

    for widget : gizmo_ctx.widgets {
        mesh := gizmo_ctx.meshes.all[widget.mesh_id];

        to_render := GizmoWidgetToRender.{
            transform=widget.transform,
            color=widget.color,
            shaded=widget.shaded,
            vertex_buffer=*mesh.vertex_buffer,
            index_buffer=*mesh.index_buffer,
            vertex_count=mesh.vertex_count,
            index_count=mesh.index_count,
        };

        ArrayPush(*viewpoint.gizmo_widgets, to_render);
    }

    for line : gizmo_ctx.lines_to_draw {
        ArrayPush(*viewpoint.gizmo_lines, line);
    }

    return viewpoint;
}

DefaultViewportMenu :: (world : *World, viewport : *EditorViewport) {
    if ImGui.BeginMenu("Options") {
        defer ImGui.EndMenu();

        if ImGui.MenuItem("Show Debug Lines", selected=viewport.show_debug_drawings) {
            viewport.show_debug_drawings = !viewport.show_debug_drawings;
        }

        if ImGui.MenuItem("Show Grid", selected=viewport.show_grid) {
            viewport.show_grid = !viewport.show_grid;
        }

        if ImGui.MenuItem("Show Wireframe", selected=viewport.show_wireframe) {
            viewport.show_wireframe = !viewport.show_wireframe;
        }
    }

    if ImGui.MenuItem(CTPrint("%###play_stop", ifx g_game_state == .Editor then Icon_Play_MDI else Icon_Stop_MDI)) {
        if g_game_state == {
        case .Editor;
            EnterPlayMode();
        case .Playing;
            ExitPlayMode();
        }
    }

    if ImGui.MenuItem(CTPrint("%###show_grid", ifx viewport.show_grid then Icon_Grid_MDI else Icon_Grid_Off_MDI), selected=viewport.show_grid) {
        viewport.show_grid = !viewport.show_grid;
    }

    ImGui.SetItemTooltip(ifx viewport.show_grid then "Hide grid" else "Show grid");

    if ImGui.MenuItem(CTPrint("%##show_debug_drawings", Icon_Shape_Outline_MDI), selected=viewport.show_debug_drawings) {
        viewport.show_debug_drawings = !viewport.show_debug_drawings;
    }

    ImGui.SetItemTooltip(ifx viewport.show_debug_drawings then "Hide debug drawings" else "Show debug drawings");
} @EditorViewportMenu
