EditorViewport :: struct {
    unique_id : u64;

    position : Vec2f;
    size : Vec2f;
    mouse_position : Vec2f;

    is_hovered : bool;

    had_mouse_input_previous_frame : bool;
    has_mouse_input : bool;
    has_keyboard_input : bool;

    event_callbacks : [..]EditorViewportEventCallback;

    render_targets : *ViewpointRenderTargets;

    camera : EditorCamera;
    gizmo_ctx : GizmoContext;

    is_box_selecting : bool;
    box_selection_start : Vec2i;
}

g_editor_viewports : [..]*EditorViewport;

EditorCamera :: struct {
    viewport : *EditorViewport;

    is_moving : bool;

    position := #run Normalized(Vec3f.{-1,1,-1}) * 10;
    rotation : Quatf;

    target_yaw := #run ToRads(30.0);
    target_pitch := #run ToRads(30.0);

    yaw := #run ToRads(30.0);
    pitch := #run ToRads(30.0);

    fov_in_degrees := 80.0;
    z_near := 0.1;
    z_far := 1000.0;

    speed_mult := 1.0;
    base_speed := 0.1;
    fast_speed := 1.0;
    rotation_speed := 0.2;
    rotation_smoothing := 0.3;

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

CreateEditorViewport :: () -> *EditorViewport {
    #import "Random";

    viewport := Alloc(EditorViewport);
    viewport.unique_id = random_get();

    viewport.camera.viewport = viewport;
    InitGizmoContext(*viewport.gizmo_ctx, viewport);

    ArrayPush(*g_editor_viewports, viewport);

    RegisterEventCallback(viewport, HandleEventForCameraMovement);
    RegisterEventCallback(viewport, HandleEventForGizmos);
    RegisterEventCallback(viewport, HandleEventForEntitySelection);

    return viewport;
}

DestroyEditorViewport :: (viewport : *EditorViewport) {
    index := ArrayFindFirst(g_editor_viewports, viewport);
    if index >= 0 {
        ArrayOrderedRemove(*g_editor_viewports, index);
    }

    DestroyGizmoContext(*viewport.gizmo_ctx);

    Free(viewport);
}

UpdateEditorViewports :: (world : *World, delta_time : float) {
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

    ImGui.PushStyleVar(.WindowPadding, Vec2f.{0,0});
    defer ImGui.PopStyleVar();

    defer ImGui.End();

    id := CTPrint("Viewport###viewport_%", unique_id);

    ImGui.SetNextWindowSize(.{1000, 700}, .FirstUseEver);
    if !ImGui.Begin(id, *opened) {
        return opened;
    }

    has_keyboard_input = ImGui.IsWindowFocused();

    size = ImGui.GetContentRegionAvail();
    render_targets = GetViewpointRenderTargets(unique_id, .{xx size.x, xx size.y});

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

        x1 := Min(box_selection_start.x + cast(s32, position.x), mouse_x);
        y1 := Min(box_selection_start.y + cast(s32, position.y), mouse_y);
        x2 := Max(box_selection_start.x + cast(s32, position.x), mouse_x);
        y2 := Max(box_selection_start.y + cast(s32, position.y), mouse_y);

        Bg_Color :: Vec4f.{1,1,1,0.2};
        Outline_Color :: Vec4f.{1,1,1,1};
        Outline_Dash_Length :: 5.0;
        Outline_Dash_Space :: 5.0;
        Outline_Dash_Thickness :: 1.0;

        draw_list.AddRectFilled(draw_list, .{xx x1, xx y1}, .{xx x2, xx y2}, U32Color(Bg_Color));

        AddDashedLine(draw_list,
            .{xx x1, xx y1}, .{xx x2, xx y1},
            Outline_Dash_Length, Outline_Dash_Space,
            U32Color(Outline_Color),
            Outline_Dash_Thickness
        );
        AddDashedLine(draw_list,
            .{xx x1, xx y2}, .{xx x2, xx y2},
            Outline_Dash_Length, Outline_Dash_Space,
            U32Color(Outline_Color),
            Outline_Dash_Thickness
        );
        AddDashedLine(draw_list,
            .{xx x1, xx y1}, .{xx x1, xx y2},
            Outline_Dash_Length, Outline_Dash_Space,
            U32Color(Outline_Color),
            Outline_Dash_Thickness
        );
        AddDashedLine(draw_list,
            .{xx x2, xx y1}, .{xx x2, xx y2},
            Outline_Dash_Length, Outline_Dash_Space,
            U32Color(Outline_Color),
            Outline_Dash_Thickness
        );
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

    CalculateCameraTransforms(*camera);

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

CalculateCameraTransforms :: (camera : *EditorCamera) {
    camera.yaw = Lerp(camera.yaw, camera.target_yaw, camera.rotation_smoothing);
    camera.pitch = Lerp(camera.pitch, camera.target_pitch, camera.rotation_smoothing);

    camera.rotation = QuatfFromEulerAnglesYXZ(.{x=camera.pitch,y=camera.yaw});

    camera.transform = Mat4fTranslate(camera.position) * Mat4fFromQuat(camera.rotation);
    camera.view = Inverse(camera.transform);

    aspect := camera.viewport.size.x / cast(float, camera.viewport.size.y);

    if Reverse_Depth_Range {
        camera.projection = Mat4fPerspectiveProjection(camera.fov_in_degrees, aspect, camera.z_far, camera.z_near);
    } else {
        camera.projection = Mat4fPerspectiveProjection(camera.fov_in_degrees, aspect, camera.z_near, camera.z_far);
    }

    camera.inv_projection = Inverse(camera.projection);

    camera.ortho_projection = Mat4fOrthographicProjection(0, camera.viewport.size.x, camera.viewport.size.y, 0, -1, 1);
    camera.inv_ortho_projection = Inverse(camera.ortho_projection);
}

HandleEventForCameraMovement :: (world : *World, using viewport : *EditorViewport, event : EditorViewportEvent) -> capture_event : bool {
    defer CalculateCameraTransforms(*camera);

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
        if event.mouse_button == .Right {
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
        && (Abs(mouse_position.x - viewport.box_selection_start.x) > xx GetCVarUInt("editor.box_selection_threshold")
        || Abs(mouse_position.y - viewport.box_selection_start.y) > xx GetCVarUInt("editor.box_selection_threshold"));
}

HandleEventForEntitySelection :: (world : *World, using viewport : *EditorViewport, event : EditorViewportEvent) -> capture_event : bool {
    if event.kind == {
    case .MousePosition;
        if is_box_selecting {
            return true;
        }

    case .MouseButtonPress;
        if event.mouse_button == .Left {
            is_box_selecting = true;
            box_selection_start = .{xx event.mouse_position.x, xx event.mouse_position.y};
        }

        // Also capture mouse right and middle buttons when selecting
        return is_box_selecting;

    case .MouseButtonRelease;
        was_box_selecting := is_box_selecting;
        if is_box_selecting && event.mouse_button == .Left {
            x1, y1, x2, y2 : s32;

            if IsBoxSelecting(viewport, event.mouse_position) {
                x1 = Min(box_selection_start.x, xx event.mouse_position.x);
                y1 = Min(box_selection_start.y, xx event.mouse_position.y);
                x2 = Max(box_selection_start.x, xx event.mouse_position.x);
                y2 = Max(box_selection_start.y, xx event.mouse_position.y);
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
                    guid := GetEntityGUIDAtPoint(viewport, xx x, xx y);
                    if guid != Null_Entity_GUID {
                        if GetModState() == (.Ctrl | .Shift) {
                            DeselectEntity(guid);
                        } else {
                            SelectEntity(guid, add_to_selection=true);
                        }
                    }
                }
            }

            is_box_selecting = false;
        }

        return was_box_selecting;
    }

    return false;
}

MakeViewpointToRender :: (using viewport : EditorViewport) -> ViewpointToRender {
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
        resolution=.{cast(u32, size.x), cast(u32, size.y)},
        frustum=MakePerspectiveFrustum(camera.transform, camera.fov_in_degrees, size.x / cast(float, size.y), camera.z_near, camera.z_far),
    };
}
