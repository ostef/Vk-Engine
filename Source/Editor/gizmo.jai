// @Todo: negative scaling
// @Todo: allow drawing meshes that are generated on the fly
// @Todo: use a different method to draw gizmo lines as we want to control the thickness

#import "Hash";

GizmoKey :: enum {
    XAxis;
    YAxis;
    ZAxis;

    Exclude; // example: press Translate then Exclude + XAxis means translate on Y and Z

    Translate;
    Rotate;
    Scale;

    Slow;
    Snap;

    Interact;
    Submit;
    Cancel;
}

GizmoInteractionType :: enum {
    None;
    TranslationAxis;
    TranslationPlane;
    ScaleAxis;
    ScalePlane;
    ScaleAll;
    RotationAxis;
    RotationTrackball;
}

KeyboardInteractionType :: enum {
    None;
    Translate;
    Scale;
    Rotate;
}

KeyboardInteractionFlags :: enum_flags {
    XAxis;
    YAxis;
    ZAxis;
}

GizmoPivot :: enum {
    Center;
    Origin;
    Active;
}

// Just in case we want to have multiple viewports in the future, we have this struct
GizmoContext :: struct {
    viewport : *EditorViewport;
    mouse_position : Vec2f;

    wants_to_hide_cursor : bool;

    widgets : [..]GizmoWidget;
    lines_to_draw : [..]DebugLine;

    hovered_id, active_id : u32;
    active_interaction : GizmoInteractionType;
    active_translation : Vec3f;

    keyboard_interaction : KeyboardInteractionType;
    keyboard_interaction_flags : KeyboardInteractionFlags;

    keyboard_focus_id, next_keyboard_focus_id : u32;

    global_size := 1.0;

    gizmo_type := GizmoType.Translate;
    gizmo_local := true;
    gizmo_pivot := GizmoPivot.Center;

    id_stack : [..]u32;
    transform_stack : [..]Mat4f;

    mouse_drag_start : Vec2f;

    drag_start_translation : Vec3f;
    drag_start_translation_offset : Vec3f;

    drag_start_scale : Vec3f;

    drag_start_rotation : Quatf;
    drag_start_rotation_axis : Vec3f;
    drag_start_rotation_point : Vec3f;

    // text_buffer : [..]u8;
    // texts_to_draw : [..]GizmoTextToDraw;

    meshes : struct {
        cube : *Asset(StaticMesh);
        sphere : *Asset(StaticMesh);
        sphere_quarter : *Asset(StaticMesh);
        plane : *Asset(StaticMesh);
        translate_plane : *Asset(StaticMesh);
        arrow : *Asset(StaticMesh);
        square_arrow : *Asset(StaticMesh);
        rotate_full_thin : *Asset(StaticMesh);
        rotate_full : *Asset(StaticMesh);
        rotate_half : *Asset(StaticMesh);
        rotate_quarter : *Asset(StaticMesh);

        #place cube;
        all : [11]*Asset(StaticMesh);
    };

    color_texture : GfxTexture;
    color_resolve : GfxTexture;
    depth_texture : GfxTexture;
}

GizmoContextState :: struct {
    global_size : float; @Serialize(1)
    gizmo_type : GizmoType; @Serialize(2)
    gizmo_local : bool; @Serialize(3)
    gizmo_pivot : GizmoPivot; @Serialize(4)
}

MakeGizmoContextState :: inline (ctx : *GizmoContext) -> GizmoContextState {
    return .{
        global_size=ctx.global_size,
        gizmo_type=ctx.gizmo_type,
        gizmo_local=ctx.gizmo_local,
        gizmo_pivot=ctx.gizmo_pivot,
    };
}

SetGizmoContextState :: inline (ctx : *GizmoContext, state : GizmoContextState) {
    ctx.global_size = state.global_size;
    ctx.gizmo_type = state.gizmo_type;
    ctx.gizmo_local = state.gizmo_local;
    ctx.gizmo_pivot = state.gizmo_pivot;
}

GizmoStyleColor :: enum {
    Origin;

    XAxis;
    YAxis;
    ZAxis;
    ViewAxis;
    RotationTrackball;

    XAxisActive;
    YAxisActive;
    ZAxisActive;
    ViewAxisActive;
    RotationTrackballActive;

    XAxisGuide;
    YAxisGuide;
    ZAxisGuide;
    ViewAxisGuide;

    Text;
    TextShadow;
    GhostGizmo;
    Cursor;

    Count;
}

GizmoStyle :: struct {
    using general : struct {
        global_size := 1.2; @ShowInInspector

        origin_circle_size := 0.1; @ShowInInspector
        guide_line_thickness := 2.0; @ShowInInspector

        line_interaction_threshold := 7.0; @ShowInInspector
        sensitivity_slow_factor := 0.1; @ShowInInspector
    }; @ShowInInspector

    using translation : struct {
        translation_snap_grid_size := 1.0; @ShowInInspector
        translation_drag_sensitivity := 0.01; @ShowInInspector
        translation_view_widget_size := 0.3; @ShowInInspector
        translation_plane_widget_distance := 0.6; @ShowInInspector
        translation_plane_widget_size := 0.3; @ShowInInspector
    }; @ShowInInspector

    using rotation : struct {
        rotation_snap_grid_size := 5.0 * Pi / 180.0; @ShowInInspector
        rotation_view_widget_size := 1.23; @ShowInInspector
        rotation_view_axis_thickness := 3.5; @ShowInInspector
    }; @ShowInInspector

    using scale : struct {
        scale_snap_grid_size := 0.1; @ShowInInspector
        scale_all_widget_size := 0.3; @ShowInInspector
        scale_plane_widget_distance := 0.6; @ShowInInspector
        scale_plane_widget_size := 0.3; @ShowInInspector
    }; @ShowInInspector

    using cursor : struct {
        cursor_line_thickness := 1.5; @ShowInInspector
        cursor_line_dash_length := 4.0; @ShowInInspector
        cursor_line_dash_spacing := 3.0; @ShowInInspector
        cursor_indicator_size := 17.0; @ShowInInspector
    }

    colors : struct {
        origin := Vec4f.{1,0.744,0.140,1}; @ShowInInspector @ColorEdit

        x_axis := Vec4f.{0.878,0.102,0.102,1}; @ShowInInspector @ColorEdit
        y_axis := Vec4f.{0.243,0.729,0.078,1}; @ShowInInspector @ColorEdit
        z_axis := Vec4f.{0.102,0.125,0.878,1}; @ShowInInspector @ColorEdit
        view_axis := Vec4f.{1,1,1,1}; @ShowInInspector @ColorEdit

        rotation_trackball := Vec4f.{0,0,0,0}; @ShowInInspector @ColorEdit
        x_axis_active := Vec4f.{1,0.871,0.275,1}; @ShowInInspector @ColorEdit
        y_axis_active := Vec4f.{1,0.871,0.275,1}; @ShowInInspector @ColorEdit
        z_axis_active := Vec4f.{1,0.871,0.275,1}; @ShowInInspector @ColorEdit
        view_axis_active := Vec4f.{1,0.871,0.275,1}; @ShowInInspector @ColorEdit
        rotation_trackball_active := Vec4f.{1,0.871,0.275,1}; @ShowInInspector @ColorEdit

        x_axis_guide := Vec4f.{1,0,0,1}; @ShowInInspector @ColorEdit
        y_axis_guide := Vec4f.{0,1,0.067,1}; @ShowInInspector @ColorEdit
        z_axis_guide := Vec4f.{0.217,0.317,1,1}; @ShowInInspector @ColorEdit
        view_axis_guide := Vec4f.{1,1,1,1}; @ShowInInspector @ColorEdit

        text := Vec4f.{1,1,1,1}; @ShowInInspector @ColorEdit
        text_shadow := Vec4f.{0,0,0,0.6}; @ShowInInspector @ColorEdit

        ghost_gizmo := Vec4f.{0.5,0.5,0.5,1}; @ShowInInspector @ColorEdit

        cursor := Vec4f.{0.117,0.117,0.117,1}; @ShowInInspector @ColorEdit

        #place origin;
        all : [GizmoStyleColor.Count]Vec4f = ---; @HideInInspector
    }; @ShowInInspector
}

g_gizmo_style : GizmoStyle;

GizmoMesh :: enum u8 {
    Cube;
    Sphere;
    SphereQuarter;
    Plane;
    TranslatePlane;
    Arrow;
    SquareArrow;
    RotateFullThin;
    RotateFull;
    RotateHalf;
    RotateQuarter;
} @ShaderType

InitGizmoContext :: (ctx : *GizmoContext, viewport : *EditorViewport) {
    using ctx.meshes;

    ctx.viewport = viewport;
    cube = LoadAsset(StaticMesh, "Editor/Gizmos/Cube.mesh");
    sphere = LoadAsset(StaticMesh, "Editor/Gizmos/Sphere.mesh");
    sphere_quarter = LoadAsset(StaticMesh, "Editor/Gizmos/SphereQuarter.mesh");
    plane = LoadAsset(StaticMesh, "Editor/Gizmos/Plane.mesh");
    translate_plane = LoadAsset(StaticMesh, "Editor/Gizmos/TranslatePlane.mesh");
    arrow = LoadAsset(StaticMesh, "Editor/Gizmos/Arrow.mesh");
    square_arrow = LoadAsset(StaticMesh, "Editor/Gizmos/SquareArrow.mesh");
    rotate_full_thin = LoadAsset(StaticMesh, "Editor/Gizmos/RotateFullThin.mesh");
    rotate_full = LoadAsset(StaticMesh, "Editor/Gizmos/RotateFull.mesh");
    rotate_half = LoadAsset(StaticMesh, "Editor/Gizmos/RotateHalf.mesh");
    rotate_quarter = LoadAsset(StaticMesh, "Editor/Gizmos/RotateQuarter.mesh");
}

DestroyGizmoContext :: (ctx : *GizmoContext) {
    QueueDestroyGfxTexture(*ctx.color_texture);
    QueueDestroyGfxTexture(*ctx.color_resolve);
    QueueDestroyGfxTexture(*ctx.depth_texture);

    for * ctx.meshes.all {
        DerefAsset(it);
    }

    ctx.* = .{};
}

SetGizmoKeyboardFocus :: inline (ctx : *GizmoContext, id : string) {
    SetGizmoKeyboardFocus(ctx, GetGizmoID(ctx, id));
}

SetGizmoKeyboardFocus :: inline (ctx : *GizmoContext, id : u32) {
    ctx.keyboard_focus_id = id;
    ctx.next_keyboard_focus_id = id;
}

GizmoType :: enum {
    None;
    Translate;
    Rotate;
    Scale;
}

GizmoFlags :: enum_flags {
    NoXAxis;
    NoYAxis;
    NoZAxis;
    NoViewAxis;
    NoTrackball;

    NoKeyboard;

    NoTranslation;
    NoScale;
    NoRotation;

    GlobalSpace;
}

GizmoWidget :: struct {
    id : u32;
    mesh_id : GizmoMesh;
    color : Vec4f;
    transform : Mat4f;
    shaded : bool;
} @ShaderType

GetGizmoID :: (ctx : *GizmoContext, str : string, hash_with_id_stack := true) -> u32 {
    id := get_hash(str);

    if hash_with_id_stack && ctx.id_stack.count > 0 {
        id = get_hash(id, ctx.id_stack[ctx.id_stack.count - 1]);
    }

    return id;
}

PushGizmoID :: (ctx : *GizmoContext, str : string, hash_with_id_stack := true) {
    PushGizmoID(ctx, GetGizmoID(ctx, str, false), hash_with_id_stack);
}

PushGizmoID :: (ctx : *GizmoContext, id : u32, hash_with_id_stack := true) {
    if hash_with_id_stack && ctx.id_stack.count > 0 {
        id = get_hash(id, ctx.id_stack[ctx.id_stack.count - 1]);
    }

    ArrayPush(*ctx.id_stack, id);
}

PopGizmoID :: (ctx : *GizmoContext) {
    ArrayPop(*ctx.id_stack);
}

GetGizmoTransform :: (ctx : *GizmoContext, peek := 0) -> Mat4f {
    if peek < ctx.transform_stack.count {
        return ctx.transform_stack[ctx.transform_stack.count - 1 - peek];
    }

    return .{};
}

PushGizmoTransform :: (ctx : *GizmoContext, mat : Mat4f, apply_previous_matrix := true) {
    m := mat;
    if ctx.transform_stack.count > 0 && apply_previous_matrix {
        m = ctx.transform_stack[ctx.transform_stack.count - 1] * mat;
    }

    ArrayPush(*ctx.transform_stack, m);
}

PopGizmoTransform :: (ctx : *GizmoContext) {
    ArrayPop(*ctx.transform_stack);
}

AddGizmoWidget :: (ctx : *GizmoContext, id : u32, mesh_id : GizmoMesh, color : Vec4f, transform : Mat4f, shaded := false) {
    ArrayPush(*ctx.widgets, GizmoWidget.{id, mesh_id, color, transform, shaded});
}

Max_Gizmo_Lines :: 1000;

// @Todo: control thickness
GizmoDrawLine :: (ctx : *GizmoContext, color : Vec3f, start : Vec3f, end : Vec3f, thickness : float) {
    if ctx.lines_to_draw.count >= Max_Gizmo_Lines {
        return;
    }

    ArrayPush(*ctx.lines_to_draw, .{
        start=start,
        end=end,
        color=.{color.r,color.g,color.b,1},
    });
}

DraggingBehavior :: (ctx : *GizmoContext, id : u32, interaction : GizmoInteractionType, translation : Vec3f) -> InteractionState {
    state : InteractionState;

    if ctx.hovered_id == id && IsMouseButtonPressed(.Left) {
        ctx.active_id = id;

        ctx.mouse_drag_start = ctx.mouse_position;

        state |= .Started;
    }

    if ctx.active_id == id {
        if !(state & .Started) && (IsKeyPressed(.Escape) || IsMouseButtonPressed(.Right)) {
            ctx.active_id = 0;
            state |= .Cancelled;
        } else if IsMouseButtonDown(.Left) {
            state |= .Interacting;
            ctx.active_interaction = interaction;
            ctx.active_translation = translation;
        } else {
            state |= .Submitted;
            ctx.active_id = 0;
        }
    }

    return state;
}

// @Todo: bring back this
KeyboardBehavior :: (ctx : *GizmoContext, id : u32, type : KeyboardInteractionType, translation : Vec3f) -> InteractionState {
    return 0;
    // if ctx.keyboard_focus_id != id
    //     return 0;

    // ctx.next_keyboard_focus_id = id;

    // if ctx.active_id != 0 && ctx.active_id != id
    //     return 0;

    // if ctx.keyboard_interaction == type && IsMouseButtonPressed(.Left)
    // {
    //     ctx.active_id = 0;
    //     return .Submitted;
    // }

    // state : InteractionState;
    // if ctx.keyboard_interaction != type
    // {
    //     if type == .Translate && IsKeyPressed(.G)
    // {
    //         ctx.keyboard_interaction = .Translate;
    //         ctx.mouse_drag_start = ctx.ctx.mouse_position;
    //         state |= .Started;
    //     }

    //     if type == .Scale && IsKeyPressed(.S)
    // {
    //         ctx.keyboard_interaction = .Scale;
    //         ctx.mouse_drag_start = ctx.ctx.mouse_position;
    //         state |= .Started;
    //     }

    //     if type == .Rotate && IsKeyPressed(.R)
    // {
    //         ctx.keyboard_interaction = .Rotate;
    //         ctx.mouse_drag_start = ctx.ctx.mouse_position;
    //         state |= .Started;
    //     }
    // }

    // if ctx.keyboard_interaction == type && !(state & .Started) && IsKeyPressed(.Escape)
    // {
    //     ctx.active_id = 0;
    //     return .Cancelled;
    // }

    // if ctx.keyboard_interaction == type
    // {
    //     state |= .Interacting;

    //     ctx.active_id = id;
    //     ctx.active_translation = translation;

    //     exclude := IsKeyDown(.Shift);
    //     if IsKeyPressed(.X)
    // {
    //         if exclude
    //             ctx.keyboard_interaction_flags = .YAxis | .ZAxis;
    // else if ctx.keyboard_interaction_flags == .XAxis
    //             ctx.keyboard_interaction_flags = 0;
    // else
    //             ctx.keyboard_interaction_flags = .XAxis;

    //         state |= .Started;
    //         state |= .Cancelled;
    //     }
    // else if IsKeyPressed(.Y)
    // {
    //         if exclude
    //             ctx.keyboard_interaction_flags = .XAxis | .ZAxis;
    // else if ctx.keyboard_interaction_flags == .YAxis
    //             ctx.keyboard_interaction_flags = 0;
    // else
    //             ctx.keyboard_interaction_flags = .YAxis;

    //         state |= .Started;
    //         state |= .Cancelled;
    //     }
    // else if IsKeyPressed(.Z)
    // {
    //         if exclude
    //             ctx.keyboard_interaction_flags = .XAxis | .YAxis;
    // else if ctx.keyboard_interaction_flags == .ZAxis
    //             ctx.keyboard_interaction_flags = 0;
    // else
    //             ctx.keyboard_interaction_flags = .ZAxis;

    //         state |= .Started;
    //         state |= .Cancelled;
    //     }
    // }

    // return state;
}

// This is event driven approach adds complexity for gizmos, because we have an immediate mode
// approach, and we don't necessarily know upon receiving an event what we want to do with said
// event. So we don't know if we want to capture it or not for example.
// We make the (sane) assumption that if a gizmo is hovered and a mouse button is pressed then
// we do want to capture the event. This may not be the case later on when we handle gizmo
// interactions in an immediate mode way, but I think it's probably not going to cause any major
// problem.
HandleEventForGizmos :: (world : *World, viewport : *EditorViewport, event : EditorViewportEvent) -> capture_event : bool {
    ctx := *viewport.gizmo_ctx;

    if event.kind == {
    case .MousePosition;
        closest_hit_dist := F32_Inf;

        ctx.hovered_id = 0;

        if ctx.active_id == 0 {
            ray_origin, ray_direction := RayFromMouse(viewport);
            for ctx.widgets {
                mesh := ctx.meshes.all[it.mesh_id];
                hit, point, dist, normal
                    := RayIntersectsMesh(ray_origin, ray_direction, F32_Inf, mesh, it.transform);

                if hit && dist < closest_hit_dist {
                    closest_hit_dist = dist;
                    ctx.hovered_id = it.id;
                }
            }
        }

        return ctx.hovered_id != 0;

    case .MouseButtonPress;
        if event.mouse_button == .Left {
            return ctx.hovered_id != 0; // Capture the event if we're hovering something
        }

    case .MouseButtonRelease;
        if ctx.active_id != 0 {
            return true;
        }
    }

    return false;
}

UpdateGizmos :: (world : *World, ctx : *GizmoContext) {
    ctx.mouse_position = ctx.viewport.mouse_position;

    // Make sure we set active_id to 0 if the widget does not exist this frame
    // Otherwise we won't be able to select anything else
    found_active := false;
    for ctx.widgets {
        if !it.id {
            continue;
        }

        if it.id == ctx.active_id {
            found_active = true;
            break;
        }
    }

    if !found_active {
        ctx.active_id = 0;
    }

    // Reset the widgets for this frame
    ArrayClear(*ctx.widgets);
    ArrayClear(*ctx.lines_to_draw);
}

CalculateGizmoWidgetSize :: inline (ctx : *GizmoContext, camera_transform : Mat4f, position : Vec3f) -> float {
    widget_size := Distance(position, TranslationVector(camera_transform));
    widget_size /= 1 / g_gizmo_style.global_size * ctx.global_size * 12.5;

    return widget_size;
}

DrawOrigin :: (ctx : *GizmoContext, camera_transform : Mat4f, position : Vec3f) {
    origin_size := g_gizmo_style.origin_circle_size * CalculateGizmoWidgetSize(ctx, camera_transform, position);
    origin_matrix := Mat4fTranslate(position) * Mat4fScale(.{origin_size,origin_size,origin_size});
    AddGizmoWidget(ctx, 0, .Sphere, g_gizmo_style.colors.origin, origin_matrix);
}

GizmoTranslate :: (world : *World, ctx : *GizmoContext, id : string, translation : *Vec3f, flags : GizmoFlags = 0) -> InteractionState {
    if flags & .NoTranslation {
        return 0;
    }

    gizmo_id := GetGizmoID(ctx, id);
    kb_state := KeyboardBehavior(ctx, gizmo_id, .Translate, translation.*);

    if kb_state & .Cancelled {
        translation.* = ctx.drag_start_translation;
    }
    if kb_state & .Started {
        ctx.drag_start_translation = translation.*;
    }

    result_state : InteractionState;

    result := translation.*;
    defer translation.* = result;

    PushGizmoID(ctx, id);
    defer PopGizmoID(ctx);

    transform := GetGizmoTransform(ctx);
    rotation := RotationMatrix(transform);

    camera_forward := ForwardVector(ctx.viewport.camera.transform);
    camera_right := RightVector(ctx.viewport.camera.transform);
    camera_up := UpVector(ctx.viewport.camera.transform);
    widget_size := CalculateGizmoWidgetSize(ctx, ctx.viewport.camera.transform, translation.*);

    axes_ids := u32.[
        GetGizmoID(ctx, "translate_x"),
        GetGizmoID(ctx, "translate_y"),
        GetGizmoID(ctx, "translate_z"),
    ];
    planes_ids := u32.[
        GetGizmoID(ctx, "translate_xy"),
        GetGizmoID(ctx, "translate_yz"),
        GetGizmoID(ctx, "translate_zx"),
    ];
    axes_vectors := Vec3f.[
        .{1,0,0},
        .{0,1,0},
        .{0,0,1},
    ];

    if !(flags & .GlobalSpace) {
        for * axes_vectors {
            it.* = TransformVector(rotation, it.*);
        }
    }

    axes_colors := Vec4f.[
        g_gizmo_style.colors.x_axis,
        g_gizmo_style.colors.y_axis,
        g_gizmo_style.colors.z_axis,
    ];
    axes_active_colors := Vec4f.[
        g_gizmo_style.colors.x_axis_active,
        g_gizmo_style.colors.y_axis_active,
        g_gizmo_style.colors.z_axis_active,
    ];
    axes_guide_colors := Vec4f.[
        g_gizmo_style.colors.x_axis_guide,
        g_gizmo_style.colors.y_axis_guide,
        g_gizmo_style.colors.z_axis_guide,
    ];
    ignore_axes := bool.[
        flags & .NoXAxis != 0,
        flags & .NoYAxis != 0,
        flags & .NoZAxis != 0,
    ];

    view_id := GetGizmoID(ctx, "translate_view");

    if ctx.active_id != view_id && ArrayFindFirst(axes_ids, ctx.active_id) < 0 {
        DrawOrigin(ctx, ctx.viewport.camera.transform, translation.*);
    }

    ignore_view := flags & .NoViewAxis != 0;
    ignore_view ||= ctx.active_id == gizmo_id && ctx.keyboard_interaction_flags != 0;
    ignore_view ||= ctx.active_id != view_id && (ArrayFindFirst(axes_ids, ctx.active_id) != -1 || ArrayFindFirst(planes_ids, ctx.active_id) != -1);

    if !ignore_view {
        drag_state : InteractionState;
        if !kb_state {
            drag_state = DraggingBehavior(ctx, view_id, .TranslationPlane, translation.*);
        } else if ctx.keyboard_interaction_flags == 0 {
            drag_state = kb_state;
        }

        if drag_state {
            result_state = drag_state;
        }

        if drag_state & .Cancelled {
            result = ctx.drag_start_translation;
        }

        if drag_state & .Interacting {
            ctx.active_interaction = .TranslationPlane;

            if drag_state & .Started {
                ctx.drag_start_translation = translation.*;
            }

            origin := ctx.drag_start_translation;
            ray_origin, ray_dir := RayFromMouse(ctx.viewport);
            intersects, point := RayIntersectsPlane(ray_origin, ray_dir, F32_Inf, origin, -camera_forward);

            if intersects {
                if drag_state & .Started {
                    ctx.drag_start_translation_offset = translation.* - point;
                }

                proj_point : Vec2f;
                _, proj_point.x = ProjectPointOnLine(point, origin, camera_right);
                _, proj_point.y = ProjectPointOnLine(point, origin, camera_up);

                if IsKeyDown(.Ctrl) {
                    proj_point.x = Snap(proj_point.x, g_gizmo_style.translation_snap_grid_size);
                    proj_point.y = Snap(proj_point.y, g_gizmo_style.translation_snap_grid_size);
                }

                point = origin + proj_point.x * camera_right + proj_point.y * camera_up;

                result = point + ctx.drag_start_translation_offset;
            }

            // _, proj_center := WorldToCamera(*ctx.viewport.camera, ctx.drag_start_translation);
            // DrawText(
            //     tprint("X: % Y: % Z: %", result.x, result.y, result.z),
            //     proj_center + .{10, 10},
            //     g_gizmo_style.colors[StyleColor.Text],
            //     g_gizmo_style.colors[StyleColor.TextShadow]
            // );
        }

        color := ifx ctx.hovered_id == view_id || ctx.active_id == view_id
            then g_gizmo_style.colors.view_axis_active else g_gizmo_style.colors.view_axis;

        size := widget_size * g_gizmo_style.translation_view_widget_size;
        tangent := axes_vectors[0];
        bitangent := axes_vectors[1];
        axis := axes_vectors[2];
        rotation2 := Mat4fFromRightUpForwardOrigin(tangent, axis, bitangent, .{0,0,0});
        widget_transform := Mat4fTranslate(translation.*) * rotation2 * Mat4fScale(.{size,size,size});

        AddGizmoWidget(ctx, view_id, .Cube, color, widget_transform, shaded=ctx.hovered_id != view_id && ctx.active_id != view_id);
    }

    for i : 0..2 {
        id := axes_ids[i];
        ignore_axis := ignore_axes[i];
        ignore_axis ||= ctx.active_id == gizmo_id && ctx.keyboard_interaction_flags != xx (1 << i);
        ignore_axis ||= ctx.active_id != id && (ArrayFindFirst(axes_ids, ctx.active_id) != -1 || ArrayFindFirst(planes_ids, ctx.active_id) != -1);

        if ignore_axis {
            continue;
        }

        drag_state : InteractionState;
        if !kb_state {
            drag_state = DraggingBehavior(ctx, id, .TranslationAxis, translation.*);
        } else if ctx.keyboard_interaction_flags == xx (1 << i) {
            drag_state = kb_state;
        }

        if drag_state {
            result_state = drag_state;
        }

        if drag_state & .Cancelled {
            result = ctx.drag_start_translation;
        }

        if drag_state & .Interacting {
            ctx.active_interaction = .TranslationAxis;

            if drag_state & .Started {
                ctx.drag_start_translation = translation.*;
            }

            center_behind, proj_center := WorldToCamera(*ctx.viewport.camera, ctx.drag_start_translation);
            axis_behind, proj_axis := WorldToCamera(*ctx.viewport.camera, ctx.drag_start_translation + axes_vectors[i]);
            if !center_behind && !axis_behind {
                mouse_offset := ctx.mouse_position - ctx.mouse_drag_start;
                proj_axis = Normalized(proj_axis - proj_center);
                mouse_dir := Normalized(ctx.mouse_position - ctx.mouse_drag_start);
                dist := Distance(ctx.mouse_drag_start, ctx.mouse_position);
                dist *= Dot(proj_axis, mouse_dir);
                dist *= g_gizmo_style.translation_drag_sensitivity;

                if IsKeyDown(.Shift) {
                    dist *= g_gizmo_style.sensitivity_slow_factor;
                }

                if IsKeyDown(.Ctrl) {
                    dist = Snap(dist, g_gizmo_style.translation_snap_grid_size);
                }

                result = ctx.drag_start_translation + axes_vectors[i] * dist;

                // DrawText(
                //     tprint("X: % Y: % Z: %", result.x, result.y, result.z),
                //     proj_center + .{10, 10},
                //     g_gizmo_style.colors[StyleColor.Text],
                //     g_gizmo_style.colors[StyleColor.TextShadow]
                // );
            }
        }

        color := ifx ctx.hovered_id == id || ctx.active_id == id
            then axes_active_colors[i] else axes_colors[i];

        if drag_state & .Interacting {
            GizmoDrawLine(
                ctx,
                axes_guide_colors[i].rgb,
                ctx.drag_start_translation - axes_vectors[i] * 500,
                ctx.drag_start_translation + axes_vectors[i] * 500,
                g_gizmo_style.guide_line_thickness
            );
        }

        axis := axes_vectors[i];
        tangent := axes_vectors[(i + 1) % 3];
        bitangent := axes_vectors[(i + 2) % 3];
        rotation2 := Mat4fFromRightUpForwardOrigin(tangent, axis, bitangent, .{0,0,0});
        origin := translation.* + axis * (widget_size * g_gizmo_style.translation_view_widget_size * 0.5 + 0.001);
        widget_transform := Mat4fTranslate(origin) * rotation2 * Mat4fScale(.{widget_size,widget_size,widget_size});
        AddGizmoWidget(ctx, id, .Arrow, color, widget_transform, shaded=ctx.hovered_id != id && ctx.active_id != id);
    }

    for i : 0..2 {
        axis0 := i;
        axis1 := (i + 1) % 3;
        axis2 := (i + 2) % 3;
        id := planes_ids[i];
        ignore_axis := ignore_axes[axis0] || ignore_axes[axis1];
        ignore_axis ||= ctx.active_id == gizmo_id && ctx.keyboard_interaction_flags != xx (1 << axis0) && ctx.keyboard_interaction_flags != xx (1 << axis1);
        ignore_axis ||= ctx.active_id != id && (ArrayFindFirst(axes_ids, ctx.active_id) != -1 || ArrayFindFirst(planes_ids, ctx.active_id) != -1);

        if ignore_axis {
            continue;
        }

        drag_state : InteractionState;
        if !kb_state {
            drag_state = DraggingBehavior(ctx, id, .TranslationPlane, translation.*);
        } else if ctx.keyboard_interaction_flags == xx (1 << axis0 | 1 << axis1) {
            drag_state = kb_state;
        }

        if drag_state {
            result_state = drag_state;
        }

        if drag_state & .Cancelled {
            result = ctx.drag_start_translation;
        }

        if drag_state & .Interacting {
            ctx.active_interaction = .TranslationPlane;

            if drag_state & .Started {
                ctx.drag_start_translation = translation.*;
            }

            origin := ctx.drag_start_translation;
            ray_origin, ray_dir := RayFromMouse(ctx.viewport);
            intersects, point := RayIntersectsPlane(ray_origin, ray_dir, F32_Inf, origin, axes_vectors[axis2]);

            if intersects {
                if drag_state & .Started {
                    ctx.drag_start_translation_offset = translation.* - point;
                }

                proj_point : Vec2f;
                _, proj_point.x = ProjectPointOnLine(point, origin, axes_vectors[axis0]);
                _, proj_point.y = ProjectPointOnLine(point, origin, axes_vectors[axis1]);

                if IsKeyDown(.Ctrl) {
                    proj_point.x = Snap(proj_point.x, g_gizmo_style.translation_snap_grid_size);
                    proj_point.y = Snap(proj_point.y, g_gizmo_style.translation_snap_grid_size);
                }

                point = origin + proj_point.x * axes_vectors[axis0] + proj_point.y * axes_vectors[axis1];

                result = point + ctx.drag_start_translation_offset;
            }

            // _, proj_center := WorldToCamera(ctx.camera, ctx.drag_start_translation);
            // DrawText(
            //     tprint("X: % Y: % Z: %", result.x, result.y, result.z),
            //     proj_center + .{10, 10},
            //     g_gizmo_style.colors[StyleColor.Text],
            //     g_gizmo_style.colors[StyleColor.TextShadow]
            // );
        }

        color := ifx ctx.hovered_id == id || ctx.active_id == id
            then axes_active_colors[axis2] else axes_colors[axis2];

        if drag_state & .Interacting {
            GizmoDrawLine(
                ctx,
                axes_guide_colors[axis0].rgb,
                ctx.drag_start_translation - axes_vectors[axis0] * 500,
                ctx.drag_start_translation + axes_vectors[axis0] * 500,
                g_gizmo_style.guide_line_thickness
            );
            GizmoDrawLine(
                ctx,
                axes_guide_colors[axis1].rgb,
                ctx.drag_start_translation - axes_vectors[axis1] * 500,
                ctx.drag_start_translation + axes_vectors[axis1] * 500,
                g_gizmo_style.guide_line_thickness
            );
        }

        axis := axes_vectors[axis2];
        tangent := axes_vectors[axis0];
        bitangent := axes_vectors[axis1];
        rotation2 := Mat4fFromRightUpForwardOrigin(tangent, axis, bitangent, .{0,0,0});
        origin := translation.* + (tangent + bitangent) * widget_size * g_gizmo_style.translation_plane_widget_distance;
        size := Vec3f.{widget_size,widget_size,widget_size} * g_gizmo_style.translation_plane_widget_size;
        widget_transform := Mat4fTranslate(origin) * rotation2 * Mat4fScale(size);
        AddGizmoWidget(ctx, id, .Plane, color, widget_transform);
    }

    return result_state;
}

GizmoRotate :: (world : *World, ctx : *GizmoContext, id : string, rotation : *Quatf, flags : GizmoFlags = 0) -> InteractionState {
    Assert(ctx != null);

    if flags & .NoRotation {
        return 0;
    }

    transform := GetGizmoTransform(ctx);
    translation := TranslationVector(transform);

    gizmo_id := GetGizmoID(ctx, id);
    kb_state := KeyboardBehavior(ctx, gizmo_id, .Rotate, translation);

    if kb_state & .Cancelled {
        rotation.* = ctx.drag_start_rotation;
    }
    if kb_state & .Started {
        ctx.drag_start_rotation = rotation.*;
    }

    result_state : InteractionState;

    result := rotation.*;
    defer rotation.* = result;

    PushGizmoID(ctx, id);
    defer PopGizmoID(ctx);

    camera_forward := ForwardVector(ctx.viewport.camera.transform);
    camera_right   := RightVector(ctx.viewport.camera.transform);
    camera_up      := UpVector(ctx.viewport.camera.transform);
    widget_size := CalculateGizmoWidgetSize(ctx, ctx.viewport.camera.transform, translation);
    gizmo_to_camera := Normalized(TranslationVector(ctx.viewport.camera.transform) - translation);

    trackball_id := GetGizmoID(ctx, "rotate_trackball");
    axes_ids := u32.[
        GetGizmoID(ctx, "rotate_x"),
        GetGizmoID(ctx, "rotate_y"),
        GetGizmoID(ctx, "rotate_z"),
        GetGizmoID(ctx, "rotate_view"),
        trackball_id,
    ];
    axes_vectors := Vec3f.[
        .{1,0,0},
        .{0,1,0},
        .{0,0,1},
        camera_forward,
    ];

    if !(flags & .GlobalSpace) {
        for i : 0..2 {
            axes_vectors[i] = Rotate(axes_vectors[i], rotation.*);
        }
    }

    axes_colors := Vec4f.[
        g_gizmo_style.colors.x_axis,
        g_gizmo_style.colors.y_axis,
        g_gizmo_style.colors.z_axis,
        g_gizmo_style.colors.view_axis,
    ];
    axes_active_colors := Vec4f.[
        g_gizmo_style.colors.x_axis_active,
        g_gizmo_style.colors.y_axis_active,
        g_gizmo_style.colors.z_axis_active,
        g_gizmo_style.colors.view_axis_active,
    ];
    axes_guide_colors := Vec4f.[
        g_gizmo_style.colors.x_axis_guide,
        g_gizmo_style.colors.y_axis_guide,
        g_gizmo_style.colors.z_axis_guide,
        g_gizmo_style.colors.view_axis_guide,
    ];
    ignore_axes := bool.[
        flags & .NoXAxis != 0,
        flags & .NoYAxis != 0,
        flags & .NoZAxis != 0,
        flags & .NoViewAxis != 0,
    ];

    if ctx.active_id != gizmo_id && ArrayFindFirst(axes_ids, ctx.active_id) < 0 {
        DrawOrigin(ctx, ctx.viewport.camera.transform, translation);
    }

    for i : 0..3 {
        keyboard_flags : KeyboardInteractionFlags;
        if i != 3 {
            keyboard_flags = xx (1 << i);
        }

        id := axes_ids[i];
        ignore_axis := ignore_axes[i];
        ignore_axis ||= ctx.active_id == gizmo_id && ctx.keyboard_interaction_flags != keyboard_flags;
        ignore_axis ||= ctx.active_id != id && ArrayFindFirst(axes_ids, ctx.active_id) != -1;

        if ignore_axis {
            continue;
        }

        axis := axes_vectors[i];
        tangent, bitangent : Vec3f;
        radius : float;
        if i == 3 {
            tangent = camera_right;
            bitangent = camera_up;
            radius = widget_size * g_gizmo_style.rotation_view_widget_size;
        } else {
            tangent = axes_vectors[(i + 1) % 3];
            bitangent = axes_vectors[(i + 2) % 3];
            radius = widget_size;
        }

        drag_state : InteractionState;
        if !kb_state {
            drag_state = DraggingBehavior(ctx, id, .RotationAxis, translation);
        } else if ctx.keyboard_interaction_flags == keyboard_flags {
            drag_state = kb_state;
        }

        if drag_state {
            result_state = drag_state;
        }

        if drag_state & .Cancelled {
            result = ctx.drag_start_rotation;
        }

        if drag_state & .Interacting {
            if drag_state & .Started {
                ctx.drag_start_rotation_axis = axes_vectors[i];
                ctx.drag_start_rotation = rotation.*;
            }

            origin := translation;
            ray_origin, ray_dir := RayFromMouse(ctx.viewport);
            intersects, point := RayIntersectsPlane(ray_origin, ray_dir, F32_Inf, origin, ctx.drag_start_rotation_axis);
            if drag_state & .Started {
                ctx.drag_start_rotation_point = point;
            }

            is_behind, proj_center := WorldToCamera(*ctx.viewport.camera, translation);
            if !is_behind {
                begin := Normalized(proj_center - ctx.mouse_drag_start);
                end := Normalized(proj_center - ctx.mouse_position);
                s := ifx Dot(camera_forward, axis) < 0 then -1.0 else 1.0;
                angle := SignedAngle(Vec3f.{xy=begin,z=0}, Vec3f.{xy=end,z=0}, .{0,0,-s});

                if IsKeyDown(.Shift) {
                    angle *= g_gizmo_style.sensitivity_slow_factor;
                }

                if IsKeyDown(.Ctrl) {
                    angle = Snap(angle, g_gizmo_style.rotation_snap_grid_size);
                }

                rotated := QuatfFromAxisAngle(ctx.drag_start_rotation_axis, angle);

                result = Normalized(rotated * ctx.drag_start_rotation);

                rotation_start_dir := Normalized(ctx.drag_start_rotation_point - translation);
                GizmoDrawLine(
                    ctx,
                    axes_active_colors[i].rgb,
                    translation,
                    translation + rotation_start_dir * radius,
                    g_gizmo_style.guide_line_thickness
                );

                GizmoDrawLine(
                    ctx,
                    axes_active_colors[i].rgb,
                    translation,
                    translation + Rotate(rotation_start_dir, rotated) * radius,
                    g_gizmo_style.guide_line_thickness
                );
            }
        }

        color := ifx ctx.hovered_id == id || ctx.active_id == id
            then axes_active_colors[i] else axes_colors[i];

        mesh_id : GizmoMesh;
        if i == 3 {
            mesh_id = GizmoMesh.RotateFullThin;
        } else if ctx.active_id == id {
            mesh_id = GizmoMesh.RotateFull;
        } else {
            mesh_id = GizmoMesh.RotateQuarter;
        }

        if Dot(tangent, gizmo_to_camera) < 0 {
            tangent = -tangent;
        }
        if Dot(bitangent, gizmo_to_camera) < 0 {
            bitangent = -bitangent;
        }

        widget_transform := Mat4fFromRightUpForwardOrigin(tangent, bitangent, axis, translation);
        widget_transform *= Mat4fScale(.{radius,radius,radius});

        AddGizmoWidget(ctx, id, mesh_id, color, widget_transform);
    }

    ignore_trackball := (flags & .NoTrackball) != 0;
    ignore_trackball ||= ctx.active_id == gizmo_id;
    ignore_trackball ||= ctx.active_id != trackball_id && ArrayFindFirst(axes_ids, ctx.active_id) != -1;

    if !ignore_trackball {
        // @Todo
    }

    return result_state;
}

GizmoScale :: (world : *World, ctx : *GizmoContext, id : string, scale : *Vec3f, flags : GizmoFlags = 0) -> InteractionState {
    if flags & .NoScale {
        return 0;
    }

    transform := GetGizmoTransform(ctx);
    translation := TranslationVector(transform);
    transform = RotationMatrix(transform);

    gizmo_id := GetGizmoID(ctx, id);
    kb_state := KeyboardBehavior(ctx, gizmo_id, .Scale, translation);

    if kb_state & .Cancelled {
        scale.* = ctx.drag_start_scale;
    }
    if kb_state & .Started {
        ctx.drag_start_scale = scale.*;
    }

    result_state : InteractionState;

    result := scale.*;
    defer scale.* = result;

    PushGizmoID(ctx, id);
    defer PopGizmoID(ctx);

    camera_forward := ForwardVector(ctx.viewport.camera.transform);
    camera_right := RightVector(ctx.viewport.camera.transform);
    camera_up := UpVector(ctx.viewport.camera.transform);
    widget_size := CalculateGizmoWidgetSize(ctx, ctx.viewport.camera.transform, translation);

    all_id := GetGizmoID(ctx, "scale_all");
    axes_ids := u32.[
        GetGizmoID(ctx, "scale_x"),
        GetGizmoID(ctx, "scale_y"),
        GetGizmoID(ctx, "scale_z"),
        all_id,
    ];
    planes_ids := u32.[
        GetGizmoID(ctx, "scale_xy"),
        GetGizmoID(ctx, "scale_yz"),
        GetGizmoID(ctx, "scale_zx"),
    ];

    axes_vectors := Vec3f.[
        .{1,0,0},
        .{0,1,0},
        .{0,0,1},
    ];
    local_axes_vectors := Vec3f.[
        .{1,0,0},
        .{0,1,0},
        .{0,0,1},
    ];

    if !(flags & .GlobalSpace) {
        for * axes_vectors {
            it.* = Normalized(TransformVector(transform, it.*));
        }
    }

    for * local_axes_vectors {
        it.* = Normalized(TransformVector(transform, it.*));
    }

    axes_colors := Vec4f.[
        g_gizmo_style.colors.x_axis,
        g_gizmo_style.colors.y_axis,
        g_gizmo_style.colors.z_axis,
    ];
    axes_active_colors := Vec4f.[
        g_gizmo_style.colors.x_axis_active,
        g_gizmo_style.colors.y_axis_active,
        g_gizmo_style.colors.z_axis_active,
    ];
    axes_guide_colors := Vec4f.[
        g_gizmo_style.colors.x_axis_guide,
        g_gizmo_style.colors.y_axis_guide,
        g_gizmo_style.colors.z_axis_guide,
    ];
    ignore_axes := bool.[
        flags & .NoXAxis != 0,
        flags & .NoYAxis != 0,
        flags & .NoZAxis != 0,
    ];

    if ArrayFindFirst(axes_ids, ctx.active_id) < 0 {
        DrawOrigin(ctx, ctx.viewport.camera.transform, translation);
    }

    for i : 0..2 {
        id := axes_ids[i];
        ignore_axis := ignore_axes[i];
        ignore_axis ||= ctx.active_id != id && (ArrayFindFirst(axes_ids, ctx.active_id) != -1 || ArrayFindFirst(planes_ids, ctx.active_id) != -1);
        ignore_axis ||= ctx.active_id == gizmo_id && ctx.keyboard_interaction_flags != xx (1 << i);
        if ignore_axis {
            continue;
        }

        drag_state : InteractionState;
        if !kb_state {
            drag_state = DraggingBehavior(ctx, id, .ScaleAxis, translation);
        } else if ctx.keyboard_interaction_flags == xx (1 << i) {
            drag_state = kb_state;
        }

        if drag_state {
            result_state = drag_state;
        }

        if drag_state & .Cancelled {
            result = ctx.drag_start_scale;
        }

        axis_widget_size := widget_size;

        if drag_state & .Interacting {
            if drag_state & .Started {
                ctx.drag_start_scale = scale.*;
            }

            is_behind, proj_center := WorldToCamera(*ctx.viewport.camera, translation);
            if !is_behind {
                t1 := Distance(proj_center, ctx.mouse_drag_start);
                t2 := Distance(proj_center, ctx.mouse_position);

                if IsKeyDown(.Shift) {
                    t2 = t1 + (t2 - t1) * g_gizmo_style.sensitivity_slow_factor;
                }

                s := Sign(ctx.drag_start_scale.n[i]);
                center_to_start := Normalized(ctx.mouse_drag_start - proj_center);
                center_to_curr := Normalized(ctx.mouse_position - proj_center);

                if Dot(center_to_start, center_to_curr) < 0 {
                    s = -s;
                }

                ratio := t2 / t1;
                additional_scale := s * Abs(ctx.drag_start_scale.n[i]) * ratio - ctx.drag_start_scale.n[i];

                if IsKeyDown(.Ctrl) {
                    additional_scale = Snap(additional_scale, g_gizmo_style.scale_snap_grid_size);
                }

                new_scale := Vec3f.{1,1,1};
                new_scale[i] += additional_scale;

                scale_matrix := Mat3fFromRightUpForward(axes_vectors[0], axes_vectors[1], axes_vectors[2]) * Mat3fScale(new_scale);

                new_local_axes := Vec3f.[
                    scale_matrix * (ctx.drag_start_scale[0] * local_axes_vectors[0]),
                    scale_matrix * (ctx.drag_start_scale[1] * local_axes_vectors[1]),
                    scale_matrix * (ctx.drag_start_scale[2] * local_axes_vectors[2]),
                ];

                result = .{
                    Dot(new_local_axes[0], local_axes_vectors[0]),
                    Dot(new_local_axes[1], local_axes_vectors[1]),
                    Dot(new_local_axes[2], local_axes_vectors[2]),
                };

                axis_widget_size *= s * ratio;

                // XYZ :: string.["X","Y","Z"];
                // scale_on_axis := ctx.drag_start_scale.n[i] + additional_scale;
                // DrawText(
                //     tprint("%: %", XYZ[i], scale_on_axis),
                //     proj_center + .{10, 10},
                //     g_gizmo_style.colors[StyleColor.Text],
                //     g_gizmo_style.colors[StyleColor.TextShadow]
                // );
            }
        }

        color := ifx ctx.hovered_id == id || ctx.active_id == id
            then axes_active_colors[i] else axes_colors[i];

        if drag_state & .Interacting {
            GizmoDrawLine(
                ctx,
                axes_guide_colors[i].rgb,
                translation - axes_vectors[i] * 500,
                translation + axes_vectors[i] * 500,
                g_gizmo_style.guide_line_thickness
            );
        }

        axis := axes_vectors[i];
        tangent := axes_vectors[(i + 1) % 3];
        bitangent := axes_vectors[(i + 2) % 3];
        rotation2 := Mat4fFromRightUpForwardOrigin(tangent, axis, bitangent, .{0,0,0});
        origin := translation + axis * (widget_size * g_gizmo_style.scale_all_widget_size * 0.5 + 0.001);
        widget_transform := Mat4fTranslate(origin) * rotation2 * Mat4fScale(.{widget_size,axis_widget_size,widget_size});
        AddGizmoWidget(ctx, id, .SquareArrow, color, widget_transform, shaded=ctx.hovered_id != id && ctx.active_id != id);
    }

    for i : 0..2 {
        axis0 := i;
        axis1 := (i + 1) % 3;
        axis2 := (i + 2) % 3;
        id := planes_ids[i];
        ignore_axis := ignore_axes[axis0] || ignore_axes[axis1];
        ignore_axis ||= ctx.active_id != id && (ArrayFindFirst(axes_ids, ctx.active_id) != -1 || ArrayFindFirst(planes_ids, ctx.active_id) != -1);
        ignore_axis ||= ctx.active_id == gizmo_id && ctx.keyboard_interaction_flags != xx (1 << axis0) && ctx.keyboard_interaction_flags != xx (1 << axis1);
        if ignore_axis {
            continue;
        }

        drag_state : InteractionState;
        if !kb_state {
            drag_state = DraggingBehavior(ctx, id, .ScalePlane, translation);
        } else if ctx.keyboard_interaction_flags == xx (1 << axis0 | 1 << axis1) {
            drag_state = kb_state;
        }

        if drag_state {
            result_state = drag_state;
        }

        if drag_state & .Cancelled {
            result = ctx.drag_start_scale;
        }

        axis_widget_size := Vec2f.{widget_size,widget_size};

        if drag_state & .Interacting {
            if drag_state & .Started {
                ctx.drag_start_scale = scale.*;
            }

            is_behind, proj_center := WorldToCamera(*ctx.viewport.camera, translation);
            if !is_behind {
                t1 := Distance(proj_center, ctx.mouse_drag_start);
                t2 := Distance(proj_center, ctx.mouse_position);

                if IsKeyDown(.Shift) {
                    t2 = t1 + (t2 - t1) * g_gizmo_style.sensitivity_slow_factor;
                }

                s := Vec2f.{
                    Sign(ctx.drag_start_scale.n[axis0]),
                    Sign(ctx.drag_start_scale.n[axis1]),
                };

                center_to_start := Normalized(ctx.mouse_drag_start - proj_center);
                center_to_curr := Normalized(ctx.mouse_position - proj_center);

                if Dot(center_to_start, center_to_curr) < 0 {
                    s = -s;
                }

                ratio := t2 / t1;
                additional_scale := Vec2f.{
                    s.x * Abs(ctx.drag_start_scale.n[axis0]) * ratio - ctx.drag_start_scale.n[axis0],
                    s.y * Abs(ctx.drag_start_scale.n[axis1]) * ratio - ctx.drag_start_scale.n[axis1],
                };

                if IsKeyDown(.Ctrl) {
                    additional_scale.x = Snap(additional_scale.x, g_gizmo_style.scale_snap_grid_size);
                    additional_scale.y = Snap(additional_scale.y, g_gizmo_style.scale_snap_grid_size);
                }

                new_scale := Vec3f.{1,1,1};
                new_scale[axis0] += additional_scale.x;
                new_scale[axis1] += additional_scale.y;

                scale_matrix := Mat3fFromRightUpForward(axes_vectors[0], axes_vectors[1], axes_vectors[2]) * Mat3fScale(new_scale);

                new_local_axes := Vec3f.[
                    scale_matrix * (ctx.drag_start_scale[0] * local_axes_vectors[0]),
                    scale_matrix * (ctx.drag_start_scale[1] * local_axes_vectors[1]),
                    scale_matrix * (ctx.drag_start_scale[2] * local_axes_vectors[2]),
                ];

                result = .{
                    Dot(new_local_axes[0], local_axes_vectors[0]),
                    Dot(new_local_axes[1], local_axes_vectors[1]),
                    Dot(new_local_axes[2], local_axes_vectors[2]),
                };

                axis_widget_size.x *= s.x * ratio;
                axis_widget_size.y *= s.y * ratio;

                // XYZ :: string.["X","Y","Z"];
                // DrawText(
                //     tprint("%: %", XYZ[i], scale_on_axis),
                //     proj_center + .{10, 10},
                //     g_gizmo_style.colors[StyleColor.Text],
                //     g_gizmo_style.colors[StyleColor.TextShadow]
                // );
            }
        }

        color := ifx ctx.hovered_id == id || ctx.active_id == id
            then axes_active_colors[axis2] else axes_colors[axis2];

        if drag_state & .Interacting {
            GizmoDrawLine(
                ctx,
                axes_guide_colors[axis0].rgb,
                translation - axes_vectors[axis0] * 500,
                translation + axes_vectors[axis0] * 500,
                g_gizmo_style.guide_line_thickness
            );
            GizmoDrawLine(
                ctx,
                axes_guide_colors[axis1].rgb,
                translation - axes_vectors[axis1] * 500,
                translation + axes_vectors[axis1] * 500,
                g_gizmo_style.guide_line_thickness
            );
        }

        axis := axes_vectors[axis2];
        tangent := axes_vectors[axis0];
        bitangent := axes_vectors[axis1];
        rotation2 := Mat4fFromRightUpForwardOrigin(tangent, axis, bitangent, .{0,0,0});
        origin := translation + (tangent + bitangent) * widget_size * g_gizmo_style.scale_plane_widget_distance;
        size := Vec3f.{axis_widget_size.x,widget_size,axis_widget_size.y} * g_gizmo_style.scale_plane_widget_size;
        widget_transform := Mat4fTranslate(origin) * rotation2 * Mat4fScale(size);
        AddGizmoWidget(ctx, id, .Plane, color, widget_transform);
    }

    ignore_all := flags & .NoViewAxis != 0;
    ignore_all ||= ctx.active_id == gizmo_id && ctx.keyboard_interaction_flags != 0;
    ignore_all ||= ctx.active_id != all_id && (ArrayFindFirst(axes_ids, ctx.active_id) != -1 || ArrayFindFirst(planes_ids, ctx.active_id) != -1);

    if !ignore_all {
        drag_state : InteractionState;
        if !kb_state {
            drag_state = DraggingBehavior(ctx, all_id, .ScaleAll, translation);
        } else if ctx.keyboard_interaction_flags == 0 {
            drag_state = kb_state;
        }

        if drag_state {
            result_state = drag_state;
        }

        if drag_state & .Cancelled {
            result = ctx.drag_start_scale;
        }

        if drag_state & .Interacting {
            if drag_state & .Started {
                ctx.drag_start_scale = scale;
            }

            is_behind, proj_center := WorldToCamera(*ctx.viewport.camera, translation);
            if !is_behind {
                t1 := Distance(proj_center, ctx.mouse_drag_start);
                t2 := Distance(proj_center, ctx.mouse_position);

                if IsKeyDown(.Shift) {
                    t2 = t1 + (t2 - t1) * g_gizmo_style.sensitivity_slow_factor;
                }

                s := Vec3f.{
                    Sign(ctx.drag_start_scale.x),
                    Sign(ctx.drag_start_scale.y),
                    Sign(ctx.drag_start_scale.z),
                };

                center_to_start := Normalized(ctx.mouse_drag_start - proj_center);
                center_to_curr := Normalized(ctx.mouse_position - proj_center);

                if Dot(center_to_start, center_to_curr) < 0 {
                    s = -s;
                }

                widget_size *= t2 / t1;

                ratio := t2 / t1;
                additional_scale := Scale(s, Abs(ctx.drag_start_scale) * ratio) - ctx.drag_start_scale;

                if IsKeyDown(.Ctrl) {
                    additional_scale.x = Snap(additional_scale.x, g_gizmo_style.scale_snap_grid_size);
                    additional_scale.y = Snap(additional_scale.y, g_gizmo_style.scale_snap_grid_size);
                    additional_scale.z = Snap(additional_scale.z, g_gizmo_style.scale_snap_grid_size);
                }

                result = ctx.drag_start_scale + additional_scale;

                if IsKeyDown(.Ctrl) {
                    result.x = Snap(result.x, g_gizmo_style.scale_snap_grid_size);
                    result.y = Snap(result.y, g_gizmo_style.scale_snap_grid_size);
                    result.z = Snap(result.z, g_gizmo_style.scale_snap_grid_size);
                }

                // DrawText(
                //     tprint("X: % Y: % Z: %", result.x, result.y, result.z),
                //     proj_center + .{10, 10},
                //     g_gizmo_style.colors[StyleColor.Text],
                //     g_gizmo_style.colors[StyleColor.TextShadow]
                // );
            }
        }

        color := ifx ctx.hovered_id == all_id || ctx.active_id == all_id
            then g_gizmo_style.colors.view_axis_active else g_gizmo_style.colors.view_axis;

        size := widget_size * g_gizmo_style.scale_all_widget_size;
        tangent := axes_vectors[0];
        bitangent := axes_vectors[1];
        axis := axes_vectors[2];
        rotation2 := Mat4fFromRightUpForwardOrigin(tangent, axis, bitangent, .{0,0,0});
        widget_transform := Mat4fTranslate(translation) * rotation2 * Mat4fScale(.{size,size,size});

        AddGizmoWidget(ctx, all_id, .Cube, color, widget_transform, shaded=ctx.hovered_id != all_id && ctx.active_id != all_id);
    }

    return result_state;
}

GizmoTransform :: (
    world : *World,
    ctx : *GizmoContext,
    id : string,
    translation : *Vec3f,
    rotation : *Quatf,
    scale : *Vec3f,
    type : GizmoType,
    flags : GizmoFlags = 0
) -> InteractionState {
    parent := GetGizmoTransform(ctx);
    inv_parent := Inverse(parent);

    matrix := Mat4fTranslate(translation.*)
        * Mat4fFromQuat(rotation.*)
        * Mat4fScale(scale.*);

    PushGizmoTransform(ctx, matrix);
    defer PopGizmoTransform(ctx);

    gizmo_id := GetGizmoID(ctx, id);
    // if ctx.keyboard_focus_id == gizmo_id && ctx.active_id == 0
    // {
    //     if IsKeyPressed(.G)
    //         type = .Translate;
    //     if IsKeyPressed(.R)
    //         type = .Rotate;
    //     if IsKeyPressed(.S)
    //         type = .Scale;
    // }

    if ctx.active_id == gizmo_id {
        if ctx.keyboard_interaction == {
        case .Translate;
            type = .Translate;
        case .Rotate;
            type = .Rotate;
        case .Scale;
            type = .Scale;
        }
    }

    if #complete type == {
    case .Translate;
        translation.* = TransformPoint(parent, translation.*);
        defer translation.* = TransformPoint(inv_parent, translation.*);

        return GizmoTranslate(world, ctx, id, translation, flags);

    case .Rotate;
        // Transform the quaternion to global space first
        // Transform back to local space afterwards
        q := QuatfFromMatrix(parent);
        inv_q := Conjugate(q);
        rotation.* = q * rotation.*;
        defer rotation.* = inv_q * rotation.*;

        return GizmoRotate(world, ctx, id, rotation, flags);

    case .Scale;
        return GizmoScale(world, ctx, id, scale, flags);

    case .None;
        translation := TranslationVector(GetGizmoTransform(ctx));
        DrawOrigin(ctx, ctx.viewport.camera.transform, translation);
    }

    return 0;
}

EntityGizmo :: (world : *World, ctx : *GizmoContext) {
    GetWorldRotationWithoutScale :: (world : *World, entity : *Entity) -> Quatf {
        rotation := entity.local_rotation;
        if entity.parent != Null_Entity_GUID {
            parent := GetEntity(world, entity.parent);
            if !parent {
                LogError("Could not find entity % parent %", entity.guid, entity.parent);
            } else {
                rotation = QuatfFromMatrix(parent.world_transform) * rotation;
            }
        }

        return rotation;
    }

    if g_editor_selected_entities.count <= 0 {
        return;
    }

    position : Vec3f;
    rotation : Quatf;
    scale : Vec3f;

    num_entities : int;
    affected_entities : [..]*Entity;
    affected_entities.allocator = Temp;

    main_entity : *Entity;
    for < it, i : g_editor_selected_entities {
        entity := GetEntity(world, it);

        num_entities += 1;

        is_affected := true;
        if entity.parent != Null_Entity_GUID {
            for other_guid, j : g_editor_selected_entities {
                if i == j {
                    continue;
                }

                other := GetEntity(world, other_guid);
                if EntityIsInHierarchy(world, entity, other) {
                    is_affected = false;
                    break;
                }
            }
        }

        if !main_entity && is_affected {
            main_entity = entity;

            rotation = GetWorldRotationWithoutScale(world, entity);
            scale = main_entity.local_scale;

            if ctx.gizmo_pivot == .Active {
                position = TranslationVector(entity.world_transform);
            }
        }

        if is_affected {
            ArrayPush(*affected_entities, entity);
        }

        entity_position := TranslationVector(entity.world_transform);

        if ctx.gizmo_pivot == .Center || ctx.gizmo_pivot == .Origin {
            position += entity_position;
        }

        DrawOrigin(ctx, ctx.viewport.camera.transform, entity_position);
    }

    if ctx.gizmo_pivot != .Active {
        position /= cast(float, num_entities);
    }

    if main_entity {
        SetGizmoKeyboardFocus(ctx, "entity_transform");

        original_position := position;
        original_rotation := rotation;
        original_scale := scale;

        gizmo_flags := GizmoFlags.NoTrackball;
        if !ctx.gizmo_local {
            gizmo_flags |= .GlobalSpace;
        }

        state := GizmoTransform(
            world,
            ctx,
            "entity_transform",
            *position, *rotation, *scale,
            ctx.gizmo_type,
            flags=gizmo_flags
        );

        if state {
            delta_position := position - original_position;
            delta_rotation := rotation * Inverse(original_rotation);

            right := RightVector(rotation);
            up := UpVector(rotation);
            forward := ForwardVector(rotation);

            ThreeAxes :: struct {
                x, y, z : Vec3f;
            }

            GetScaleOnAxis :: (scale : ThreeAxes, axis : Vec3f) -> float {
                return Abs(Dot(scale.x, axis)) + Abs(Dot(scale.y, axis)) + Abs(Dot(scale.z, axis));
            }

            original_world_scale := ThreeAxes.{
                Rotate(Vec3f.{original_scale.x, 0, 0}, rotation),
                Rotate(Vec3f.{0, original_scale.y, 0}, rotation),
                Rotate(Vec3f.{0, 0, original_scale.z}, rotation),
            };
            world_scale := ThreeAxes.{
                Rotate(Vec3f.{scale.x, 0, 0}, rotation),
                Rotate(Vec3f.{0, scale.y, 0}, rotation),
                Rotate(Vec3f.{0, 0, scale.z}, rotation),
            };
            delta_world_scale := ThreeAxes.{
                Rotate(Vec3f.{scale.x / original_scale.x, 0, 0}, rotation),
                Rotate(Vec3f.{0, scale.y / original_scale.y, 0}, rotation),
                Rotate(Vec3f.{0, 0, scale.z / original_scale.z}, rotation),
            };

            delta_scale_signs := Vec3f.{
                Sign(scale.x) * Sign(original_scale.x),
                Sign(scale.y) * Sign(original_scale.y),
                Sign(scale.z) * Sign(original_scale.z),
            };

            for entity : affected_entities {
                world_rotation := GetWorldRotationWithoutScale(world, entity);
                world_rotation = Normalized(delta_rotation * world_rotation);

                entity_right := RightVector(world_rotation);
                entity_up := UpVector(world_rotation);
                entity_forward := ForwardVector(world_rotation);

                original_local_scale := Vec3f.{
                    GetScaleOnAxis(original_world_scale, entity_right),
                    GetScaleOnAxis(original_world_scale, entity_up),
                    GetScaleOnAxis(original_world_scale, entity_forward),
                };
                local_scale := Vec3f.{
                    GetScaleOnAxis(world_scale, entity_right),
                    GetScaleOnAxis(world_scale, entity_up),
                    GetScaleOnAxis(world_scale, entity_forward),
                };
                delta_local_scale := Vec3f.{
                    local_scale.x / original_local_scale.x,
                    local_scale.y / original_local_scale.y,
                    local_scale.z / original_local_scale.z,
                };

                entity.local_scale = Scale(delta_scale_signs, Scale(entity.local_scale, delta_local_scale));

                world_position : Vec3f = TranslationVector(entity.world_transform);
                world_position += delta_position;

                // Rotate and scale around pivot by applying a translation
                // We could do that with a matrix transformation but that would require
                // extracting translation, rotation and scale which could be destructive
                pivot_relative_position := world_position - original_position;
                if ctx.gizmo_pivot != .Origin {
                    pivot_relative_position = Rotate(pivot_relative_position, delta_rotation);
                    pivot_relative_position =
                          Project(pivot_relative_position, right)   * Length(delta_world_scale.x) * delta_scale_signs.x
                        + Project(pivot_relative_position, up)      * Length(delta_world_scale.y) * delta_scale_signs.y
                        + Project(pivot_relative_position, forward) * Length(delta_world_scale.z) * delta_scale_signs.z;
                }

                world_position = original_position + pivot_relative_position;

                parent := ifx entity.parent != Null_Entity_GUID then GetEntity(world, entity.parent);
                if parent {
                    world_transform := Mat4fTranslate(world_position) * Mat4fFromQuat(world_rotation);
                    local_transform := Inverse(parent.world_transform) * world_transform;

                    entity.local_position = TranslationVector(local_transform);
                    entity.local_rotation = QuatfFromMatrix(local_transform);
                } else {
                    entity.local_position = world_position;
                    entity.local_rotation = world_rotation;
                }

                UpdateWorldTransform(world, entity);
            }
        }
    }
}

GizmoViewportMenu :: (world : *World, viewport : *EditorViewport) {
    ctx := *viewport.gizmo_ctx;

    ImGui.Separator();

    if ImGui.MenuItem(CTPrint("%##gizmo_none", Icon_Select_MDI), selected=ctx.gizmo_type == .None) {
        ctx.gizmo_type = .None;
    }

    ImGui.SetItemTooltip("No gizmo");

    if ImGui.MenuItem(CTPrint("%##gizmo_translate", Icon_Cursor_Move_MDI), selected=ctx.gizmo_type == .Translate) {
        ctx.gizmo_type = .Translate;
    }

    ImGui.SetItemTooltip("Translate");

    if ImGui.MenuItem(CTPrint("%##gizmo_rotate", Icon_Rotate_Orbit_MDI), selected=ctx.gizmo_type == .Rotate) {
        ctx.gizmo_type = .Rotate;
    }

    ImGui.SetItemTooltip("Rotate");

    if ImGui.MenuItem(CTPrint("%##gizmo_scale", Icon_Resize_MDI), selected=ctx.gizmo_type == .Scale) {
        ctx.gizmo_type = .Scale;
    }

    ImGui.SetItemTooltip("Scale");

    ImGui.Separator();

    ImGui.Checkbox("Local", *ctx.gizmo_local);

    ImGui.SetNextItemWidth(80);
    ImGui_Ext.EnumCombo("Pivot", *ctx.gizmo_pivot);
} @EditorViewportMenu
