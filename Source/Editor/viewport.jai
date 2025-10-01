EditorCamera :: struct {
    position := #run Normalized(Vec3f.{-1,1,-1}) * 10;
    target_yaw := #run ToRads(30.0);
    target_pitch := #run ToRads(30.0);
    yaw := #run ToRads(30.0);
    pitch := #run ToRads(30.0);
    rotation : Quatf;
    fov_in_degrees := 80.0;
    z_near := 0.1;
    z_far := 1000.0;
    transform : Mat4f;
    view : Mat4f;
    projection : Mat4f;
    inv_projection : Mat4f;
    ortho_projection : Mat4f;
    inv_ortho_projection : Mat4f;
    viewport_size : Vec2u;

    speed_mult := 1.0;
    base_speed := 0.1;
    fast_speed := 1.0;
    rotation_speed := 0.2;
    rotation_smoothing := 0.3;
}

EditorViewport :: struct {
    camera : EditorCamera;
    render_targets : *ViewpointRenderTargets;
}

g_main_viewport : EditorViewport;

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
        resolution=camera.viewport_size,
        frustum=MakePerspectiveFrustum(camera.transform, camera.fov_in_degrees, camera.viewport_size.x / cast(float, camera.viewport_size.y), camera.z_near, camera.z_far),
    };
}

UpdateCamera :: (using camera : *EditorCamera) {
    is_moving_camera := IsMouseButtonDown(.Right) && !IsMouseButtonDown(.Left);
    is_moving_camera &= !ImGui.GetIO().WantCaptureMouse;
    is_moving_camera &= !ImGui.GetIO().WantCaptureKeyboard;
    // is_moving_camera &= g_gizmo_ctx.active_id == 0;
    if is_moving_camera {
        SDL_SetRelativeMouseMode(SDL_TRUE);

        if !IsKeyDown(.Ctrl) {
            movement_input : Vec3f;
            movement_input.x = GetKeyAxisValue(.A, .D);
            movement_input.y = GetKeyAxisValue(.Q, .E);
            movement_input.z = GetKeyAxisValue(.S, .W);
            movement_input = Normalized(movement_input);

            speed := ifx IsKeyDown(.Shift) then fast_speed else base_speed;

            speed *= speed_mult;

            // @Todo: delta timing
            position += speed * (
                RightVector(rotation) * movement_input.x +
                UpVector(rotation) * movement_input.y +
                ForwardVector(rotation) * movement_input.z
            );
        }

        rotation_delta := GetRawMouseDelta() * rotation_speed;

        target_yaw += ToRads(rotation_delta.x);
        target_pitch += ToRads(rotation_delta.y);
    } else {
        SDL_SetRelativeMouseMode(SDL_FALSE);
    }

    target_pitch = Clamp(target_pitch, ToRads(-90), ToRads(90));
    yaw = Lerp(yaw, target_yaw, rotation_smoothing);
    pitch = Lerp(pitch, target_pitch, rotation_smoothing);

    rotation = QuatfFromEulerAnglesYXZ(.{x=pitch,y=yaw});

    transform = Mat4fTranslate(position) * Mat4fFromQuat(rotation);
    view = Inverse(transform);

    aspect := camera.viewport_size.x / cast(float, camera.viewport_size.y);

    if Reverse_Depth_Range {
        projection = Mat4fPerspectiveProjection(fov_in_degrees, aspect, z_far, z_near);
    } else {
        projection = Mat4fPerspectiveProjection(fov_in_degrees, aspect, z_near, z_far);
    }

    inv_projection = Inverse(projection);

    ortho_projection = Mat4fOrthographicProjection(0, xx camera.viewport_size.x, xx camera.viewport_size.y, 0, -1, 1);
    inv_ortho_projection = Inverse(ortho_projection);
}
