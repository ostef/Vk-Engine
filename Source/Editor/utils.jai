U32Color :: ImGui.ColorConvertFloat4ToU32;

InteractionState :: enum_flags {
    Started;
    Interacting;
    Cancelled;
    Submitted;
}

LastItemInteractionState :: inline () -> InteractionState {
    result : InteractionState;

    if ImGui.IsItemActive() {
        result |= .Interacting;
    }
    if ImGui.IsItemActivated() {
        result |= .Started;
    }
    if ImGui.IsItemDeactivatedAfterEdit() {
        result |= .Submitted;
    } else if ImGui.IsItemDeactivated() {
        result |= .Cancelled;
    }

    return result;
}

IsItemDoubleClicked :: (mouse_button : ImGui.MouseButton = .Left) -> bool {
    return ImGui.IsMouseDoubleClicked(mouse_button) && ImGui.IsItemHovered(.None);
}

LayoutHorizontal :: () {
    window := ImGui.GetCurrentWindow();
    window.DC.LayoutType_ = .Horizontal;
}
@NoProfile

LayoutVertical :: () {
    window := ImGui.GetCurrentWindow();

    if window.DC.LayoutType_ == .Horizontal {
        ImGui.NewLine();
    }

    window.DC.LayoutType_ = .Vertical;
}
@NoProfile

PushStyleCompact :: inline () {
    style := ImGui.GetStyle();
    ImGui.PushStyleVar(.FramePadding, .{style.FramePadding.x, Round(style.FramePadding.y * 0.5)});
    ImGui.PushStyleVar(.ItemSpacing, .{Round(style.ItemSpacing.x * 0.6), Round(style.ItemSpacing.y * 0.6)});
}
@NoProfile

PopStyleCompact :: inline () {
    ImGui.PopStyleVar(2);
}
@NoProfile

HelpMarker :: (fmt_str : string, args : ..Any) {
    ImGui.TextDisabled(Icon_Help_Circle_Outline_MDI);
    if ImGui.BeginItemTooltip() {
        ImGui.PushTextWrapPos(ImGui.GetFontSize() * 35);
        ImGui.Text(fmt_str, ..args);
        ImGui.PopTextWrapPos();
        ImGui.EndTooltip();
    }
}
@PrintLike
@NoProfile

SameLineSeparator :: () {
    window := ImGui.GImGui.CurrentWindow;
    if window.SkipItems {
        return;
    }

    same_line := window.DC.IsSameLine;

    flags := ifx same_line || window.DC.LayoutType_ == .Horizontal
        then ImGui.SeparatorFlags.Vertical
        else ImGui.SeparatorFlags.Horizontal;

    if window.DC.CurrentColumns {
        flags |= .SpanAllColumns;
    }

    ImGui.SeparatorEx(flags, 1);

    if same_line {
        ImGui.SameLine();
    }
}
@NoProfile

FilterTest :: (case_sensitive : bool, str : string, filter : string) -> bool {
    if filter.count > 0 {
        if case_sensitive && !contains(str, filter) {
            return false;
        }
        if !case_sensitive && !contains_nocase(str, filter) {
            return false;
        }
    }

    return true;
}
@NoProfile

IconCheckbox :: (
    label : string, value : *bool,
    unchecked := Icon_Checkbox_Blank_MDI,
    intermediate := Icon_Checkbox_Intermediate_MDI,
    checked := Icon_Checkbox_Marked_MDI
) -> bool {
    window := ImGui.GetCurrentWindow();
    if window.SkipItems {
        return false;
    }

    g := ImGui.GImGui;
    style := g.Style_;
    id := window.GetID(window, label);

    icon_size := ImGui.CalcTextSize(unchecked, true);
    label_size := ImGui.CalcTextSize(label, true);

    pos := window.DC.CursorPos;
    total_bb := ImGui.ImRect.{pos, pos};
    total_bb.Max.x += icon_size.x + ifx label_size.x > 0 then style.ItemInnerSpacing.x + label_size.x;
    total_bb.Max.y += label_size.y + style.FramePadding.y * 2;

    ImGui.ItemSize(total_bb.Max - total_bb.Min, style.FramePadding.y);
    if !ImGui.ItemAdd(total_bb, id) {
        return false;
    }

    hovered, held : bool;
    pressed := ImGui.ButtonBehavior(total_bb, id, *hovered, *held);
    if pressed {
        value.* = !value.*;
        ImGui.MarkItemEdited(id);
    }

    ImGui.RenderNavHighlight(total_bb, id);

    icon := unchecked;
    mixed_value := (g.LastItemData_.InFlags & .MixedValue) != 0;
    if mixed_value {
        icon = intermediate;
    } else if value.* {
        icon = checked;
    }

    check_pos := Vec2f.{pos.x, pos.y + style.FramePadding.y};

    ImGui.RenderText(check_pos, icon);

    label_pos := Vec2f.{pos.x + icon_size.x + style.ItemInnerSpacing.x, pos.y + style.FramePadding.y};

    if g.LogEnabled {
        ImGui.LogRenderedText(*label_pos, ifx mixed_value then "[~]" else ifx value.* then "[x]" else "[ ]");
    }

    if label_size.x > 0 {
        ImGui.RenderText(label_pos, label);
    }

    return pressed;
}
@NoProfile

Toggle :: (label : *u8, value : *bool) -> bool {
    Assert(value != null);

    frame_bg := ImGui.GetStyle().Colors[ImGui.Col.FrameBg];
    frame_bg_hovered := ImGui.GetStyle().Colors[ImGui.Col.FrameBgHovered];
    frame_bg_active := ImGui.GetStyle().Colors[ImGui.Col.FrameBgActive];

    if value.* {
        ImGui.PushStyleColor(.Button, frame_bg_active);
        ImGui.PushStyleColor(.ButtonActive, frame_bg_active);
    } else {
        ImGui.PushStyleColor(.Button, frame_bg);
        ImGui.PushStyleColor(.ButtonActive, frame_bg_active);
    }

    ImGui.PushStyleColor(.ButtonHovered, frame_bg_hovered);

    defer ImGui.PopStyleColor(3);

    pressed := ImGui.Button(label);
    if pressed {
        value.* = !value.*;
    }

    return pressed;
}
@NoProfile

SelectableButton :: (label : *u8, selected : bool, size := Vec2f.{0,0}) -> bool {
    frame_bg := ImGui.GetStyle().Colors[ImGui.Col.FrameBg];
    frame_bg_hovered := ImGui.GetStyle().Colors[ImGui.Col.FrameBgHovered];
    frame_bg_active := ImGui.GetStyle().Colors[ImGui.Col.FrameBgActive];

    if selected {
        ImGui.PushStyleColor(.Button, frame_bg_active);
        ImGui.PushStyleColor(.ButtonActive, frame_bg_active);
    } else {
        ImGui.PushStyleColor(.Button, frame_bg);
        ImGui.PushStyleColor(.ButtonActive, frame_bg_active);
    }

    ImGui.PushStyleColor(.ButtonHovered, frame_bg_hovered);

    defer ImGui.PopStyleColor(3);

    pressed := ImGui.Button(label, size);

    return pressed;
}
@NoProfile

ClickableText :: (text : string) -> bool {
    window := ImGui.GetCurrentWindow();
    if window.SkipItems {
        return false;
    }

    g := ImGui.GImGui;

    text_pos := Vec2f.{window.DC.CursorPos.x, window.DC.CursorPos.y + window.DC.CurrLineTextBaseOffset};

    id := ImGui.GetID(text);

    rendered_text := text;
    rendered_text.count = cast(s64) (ImGui.FindRenderedTextEnd(text) - text.data);

    text_size := ImGui.CalcTextSize(rendered_text, false);

    bb := ImGui.ImRect.{text_pos, text_pos + text_size};
    ImGui.ItemSize(text_size, 0);
    if !ImGui.ItemAdd(bb, id)
        return false;

    hovered : bool;
    held : bool;
    pressed := ImGui.ButtonBehavior(bb, id, *hovered, *held, 0);

    draw_list := ImGui.GetWindowDrawList();

    color : Vec4f = ---;
    if held && hovered {
        color = ImGui.GetStyle().Colors[ImGui.Col.ButtonActive];
    } else if hovered {
        color = ImGui.GetStyle().Colors[ImGui.Col.ButtonHovered];
    } else {
        color = ImGui.GetStyle().Colors[ImGui.Col.Text];
    }

    ucolor := ImGui.ColorConvertFloat4ToU32(color);

    draw_list.AddText(draw_list, bb.Min, ucolor, rendered_text);

    if hovered {
        p0 := Vec2f.{bb.Min.x, bb.Max.y};
        p1 := Vec2f.{bb.Max.x, bb.Max.y};

        draw_list.AddLine(draw_list, p0, p1, ucolor, 1);
    }

    return pressed;
}
@NoProfile

LabelTextButton :: (label : *u8, fmt : string, args : ..Any) -> bool {
    window := ImGui.GetCurrentWindow();
    if window.SkipItems {
        return false;
    }

    style := ImGui.GetStyle();
    w := ImGui.CalcItemWidth();

    value_text := TPrint(fmt, ..args);
    value_size := ifx value_text then ImGui.CalcTextSize(value_text, false);
    label_size := ImGui.CalcTextSize(label, null, true);

    pos := window.DC.CursorPos;
    value_bb := ImGui.ImRect.{
        pos,
        pos + .{w, value_size.y + style.FramePadding.y * 2}
    };
    total_bb := ImGui.ImRect.{
        pos,
        pos + .{
            w + ifx label_size.x > 0 then style.ItemInnerSpacing.x + label_size.x,
            Max(value_size.y, label_size.y) + style.FramePadding.y * 2
        }
    };

    ImGui.ItemSize(total_bb.Max - total_bb.Min, style.FramePadding.y);
    id := window.GetID(window, label, null);
    if !ImGui.ItemAdd(value_bb, id) {
        return false;
    }

    pressed := ImGui.ButtonBehavior(value_bb, id, null, null);
    ImGui.SetItemTooltip("%", value_text);

    if value_text {
        ImGui.RenderTextClipped(
            value_bb.Min + style.FramePadding, value_bb.Max,
            value_text,
            *value_size, .{0,0}
        );
    }

    if label_size.x > 0 {
        ImGui.RenderText(.{value_bb.Max.x + style.ItemInnerSpacing.x, value_bb.Min.y + style.FramePadding.y}, label);
    }

    return pressed;
}
@PrintLike
@NoProfile

TypeInfoToImGuiDataType :: inline (info : *Type_Info) -> ImGui.DataType {
    if info == type_info(u8) {
        return .U8;
    }
    if info == type_info(s8) {
        return .S8;
    }
    if info == type_info(u16) {
        return .U16;
    }
    if info == type_info(s16) {
        return .S16;
    }
    if info == type_info(u32) {
        return .U32;
    }
    if info == type_info(s32) {
        return .S32;
    }
    if info == type_info(u64) {
        return .U64;
    }
    if info == type_info(s64) {
        return .S64;
    }
    if info == type_info(float) {
        return .Float;
    }
    if info == type_info(float64) {
        return .Double;
    }

    Panic("Invalid type info");
    return 0;
}
@NoProfile

DragVector :: (label : *u8, values : []$T, step : float = 1, show_labels := false) -> InteractionState, activated : bool, edited_value : int
#modify { return TypeIsNumeric(T); } {
    #if T == {
    case u8;      Data_Type :: ImGui.DataType.U8;
    case s8;      Data_Type :: ImGui.DataType.S8;
    case u16;     Data_Type :: ImGui.DataType.U16;
    case s16;     Data_Type :: ImGui.DataType.S16;
    case u32;     Data_Type :: ImGui.DataType.U32;
    case s32;     Data_Type :: ImGui.DataType.S32;
    case u64;     Data_Type :: ImGui.DataType.U64;
    case s64;     Data_Type :: ImGui.DataType.S64;
    case float;   Data_Type :: ImGui.DataType.Float;
    case float64; Data_Type :: ImGui.DataType.Double;
    }

    state, activated, edited_value := DragVector(label, Data_Type, values.data, xx values.count, step, show_labels);

    return state, activated, edited_value;
}
@NoProfile

DragVector :: (label : *u8, data_type : ImGui.DataType, values : *void, count : s32, step : float = 1, show_labels := false) -> InteractionState, activated : bool, edited_value : int {
    Assert(count < 5);

    ImGui.PushID(label);
    defer ImGui.PopID();

    window := ImGui.GetCurrentWindow();
    style := ImGui.GetStyle();
    ImGui.PushMultiItemsWidths(count, ImGui.CalcItemWidth());

    line_height := ImGui.GetFrameHeight();
    label_size : Vec2f;
    if show_labels {
        label_size = .{line_height * 0.9, line_height};
    } else {
        label_size = .{Max(style.FrameRounding, 4), line_height};
    }

    Labels :: string.["X","Y","Z","W"];
    Invisible_Labels :: string.["##X","##Y","##Z","##W"];
    Colors :: Vec4f.[
        .{0.878, 0.102, 0.102, 1},
        .{0.243, 0.729, 0.078, 1},
        .{0.102, 0.125, 0.878, 1},
        .{0.831, 0.667, 0.114, 1},
    ];

    data_type_size := 0;
    if data_type == {
    case .U8; #through;
    case .S8;
        data_type_size = 1;
    case .U16; #through;
    case .S16;
        data_type_size = 2;
    case .U32; #through;
    case .S32;
        data_type_size = 4;
    case .U64; #through;
    case .S64;
        data_type_size = 8;
    case .Float;
        data_type_size = 4;
    case .Double;
        data_type_size = 8;
    }

    state : InteractionState;
    modified := false;
    activated := false;
    edited_value := -1;
    g := ImGui.GImGui;
    for i : 0..count - 1 {
        label_bb : ImGui.ImRect;
        label_bb.Min = window.DC.CursorPos;
        label_bb.Max = label_bb.Min + label_size;

        dummy_size := label_size - .{style.FrameRounding, 0};
        ImGui.ItemSize(dummy_size, style.FramePadding.y);

        ImGui.SameLine(spacing=0);

        ImGui.SetNextItemWidth(window.DC.ItemWidth - dummy_size.x);

        ImGui.DragScalar(Invisible_Labels[i].data, data_type, values + data_type_size * i, step);
        item_state := LastItemInteractionState();
        if item_state {
            edited_value = i;
        }

        state |= item_state;
        activated |= ImGui.IsItemActivated();

        col := ImGui.ColorConvertFloat4ToU32(Colors[i]);
        RenderFrameExt(label_bb.Min, label_bb.Max, col, true, style.FrameRounding, .RoundCornersLeft);
        if show_labels {
            ImGui.RenderTextClipped(
                label_bb.Min + style.FramePadding, label_bb.Max - style.FramePadding,
                Labels[i], null,
                style.ButtonTextAlign, *label_bb
            );
        }

        ImGui.SameLine();

        ImGui.PopItemWidth();
    }

    s := MakeString(label);
    hash := ImGui.FindRenderedTextEnd(label);
    if hash {
        s.count = hash - s.data;
    }

    if s.count > 0 {
        ImGui.Text("%", s);
    }

    return state, activated, edited_value;
}
@NoProfile

RenderFrameExt :: (min : Vec2f, max : Vec2f, fill_col : u32, border := true, rounding := 0.0, flags : ImGui.ImDrawFlags = 0) {
    window := ImGui.GetCurrentWindow();
    draw_list := window.DrawList;
    draw_list.AddRectFilled(draw_list, min, max, fill_col, rounding, flags);

    border_size := ImGui.GetStyle().FrameBorderSize;
    if border && border_size > 0 {
        draw_list.AddRect(draw_list,
            min + .{1,1}, max + .{1,1},
            ImGui.GetColorU32(.BorderShadow),
            rounding, flags, border_size
        );
        draw_list.AddRect(draw_list,
            min, max,
            ImGui.GetColorU32(.Border),
            rounding, flags, border_size
        );
    }
}
@NoProfile

AddDashedLine :: (
    draw_list : *ImGui.ImDrawList,
    a : Vec2f, b : Vec2f,
    line_len : float,
    spacing : float,
    color : u32,
    thickness : float
) {
    if thickness <= 0 || line_len <= 0 {
        return;
    }

    Assert(spacing > 0);

    len := Sqrt(Dot(b - a, b - a));
    dir := (b - a) / len;

    i := 0.0;
    while i < len {
        start := i;
        end := Min(i + line_len, len);

        draw_list.AddLine(draw_list, a + dir * start, a + dir * end, color, thickness);
        i += line_len + spacing;
    }
}

AddSelectionBox :: (
    draw_list : *ImGui.ImDrawList,
    min : Vec2f, max : Vec2f,
    bg_color := Vec4f.{1,1,1,0.2}, outline_color := Vec4f.{1,1,1,1},
    dash_length := 5.0, dash_space := 5.0, dash_thickness := 1.0
) {
    draw_list.AddRectFilled(draw_list, min, max, U32Color(bg_color));

    AddDashedLine(draw_list,
        .{xx min.x, xx min.y}, .{xx max.x, xx min.y},
        dash_length, dash_space,
        U32Color(outline_color),
        dash_thickness
    );
    AddDashedLine(draw_list,
        .{xx min.x, xx max.y}, .{xx max.x, xx max.y},
        dash_length, dash_space,
        U32Color(outline_color),
        dash_thickness
    );
    AddDashedLine(draw_list,
        .{xx min.x, xx min.y}, .{xx min.x, xx max.y},
        dash_length, dash_space,
        U32Color(outline_color),
        dash_thickness
    );
    AddDashedLine(draw_list,
        .{xx max.x, xx min.y}, .{xx max.x, xx max.y},
        dash_length, dash_space,
        U32Color(outline_color),
        dash_thickness
    );
}

SetEditorStyleBasic :: () {
    style := ImGui.GetStyle();
    style.Constructor(style);

    ImGui.StyleColorsDark();

    style.WindowRounding = 6;
    style.WindowMenuButtonPosition = .Right;
    style.ChildRounding = 3;
    style.FrameRounding = 4;
    style.PopupRounding = 3;
    style.GrabRounding = 4;
    style.TabRounding = 6;
    style.FramePadding = .{6, 6};
    style.SeparatorTextBorderSize = 1;
    style.FrameBorderSize = 1;
    style.ItemSpacing.y = 6;
    style.ItemInnerSpacing.x = 8;

    style.Colors[ImGui.Col.Border].w = 0.25;
    style.Colors[ImGui.Col.WindowBg].w = 1.0;
    style.Colors[ImGui.Col.PopupBg].w = 1.0;
}

// Based on Moonlight style by deathsu/madam-herta
// https://github.com/Madam-Herta/Moonlight/
SetEditorStyleMoonlight :: () {
    style := ImGui.GetStyle();
    style.Constructor(style);

    style.WindowMenuButtonPosition = .Right;
    style.WindowRounding = 4;
    style.ChildRounding = 3;
    style.FrameRounding = 3;
    style.PopupRounding = 2;
    style.GrabRounding = 4;
    style.TabRounding = 3;
    style.FramePadding = .{6, 6};
    style.SeparatorTextBorderSize = 1;
    style.FrameBorderSize = 1;
    style.WindowBorderSize = 1;
    style.PopupBorderSize = 1;
    style.ItemSpacing.y = 6;
    style.ItemInnerSpacing.x = 8;
    style.GrabMinSize = 5;

    style.Colors[ImGui.Col.Text] = .{1, 1, 1, 1};
    style.Colors[ImGui.Col.TextDisabled] = .{0.274, 0.317, 0.450, 1};
    style.Colors[ImGui.Col.WindowBg] = .{0.078, 0.086, 0.101, 1};
    style.Colors[ImGui.Col.ChildBg] = .{0.092, 0.100, 0.115, 1};
    style.Colors[ImGui.Col.PopupBg] = .{0.078, 0.086, 0.101, 1};
    style.Colors[ImGui.Col.Border] = .{0.156, 0.168, 0.192, 0.250};
    style.Colors[ImGui.Col.BorderShadow] = .{0.078, 0.086, 0.101, 0.250};
    style.Colors[ImGui.Col.FrameBg] = .{0.112, 0.126, 0.154, 1};
    style.Colors[ImGui.Col.FrameBgHovered] = .{0.156, 0.168, 0.192, 1};
    style.Colors[ImGui.Col.FrameBgActive] = .{0.156, 0.168, 0.192, 1};
    style.Colors[ImGui.Col.TitleBg] = .{0.047, 0.054, 0.070, 1};
    style.Colors[ImGui.Col.TitleBgActive] = .{0.047, 0.054, 0.070, 1};
    style.Colors[ImGui.Col.TitleBgCollapsed] = .{0.078, 0.086, 0.101, 1};
    style.Colors[ImGui.Col.MenuBarBg] = .{0.098, 0.105, 0.121, 1};
    style.Colors[ImGui.Col.ScrollbarBg] = .{0.047, 0.054, 0.070, 1};
    style.Colors[ImGui.Col.ScrollbarGrab] = .{0.117, 0.133, 0.149, 1};
    style.Colors[ImGui.Col.ScrollbarGrabHovered] = .{0.156, 0.168, 0.192, 1};
    style.Colors[ImGui.Col.ScrollbarGrabActive] = .{0.117, 0.133, 0.149, 1};
    style.Colors[ImGui.Col.CheckMark] = .{0.972, 1, 0.498, 1};
    style.Colors[ImGui.Col.SliderGrab] = .{0.971, 1, 0.498, 1};
    style.Colors[ImGui.Col.SliderGrabActive] = .{1, 0.795, 0.498, 1};
    style.Colors[ImGui.Col.Button] = .{0.117, 0.133, 0.149, 1};
    style.Colors[ImGui.Col.ButtonHovered] = .{0.182, 0.189, 0.197, 1};
    style.Colors[ImGui.Col.ButtonActive] = .{0.154, 0.154, 0.154, 1};
    style.Colors[ImGui.Col.Header] = .{0.049, 0.482, 0.863, 1};
    style.Colors[ImGui.Col.HeaderHovered] = .{0.038, 0.321, 0.715, 1};
    style.Colors[ImGui.Col.HeaderActive] = .{0.123, 0.551, 0.928, 1};
    style.Colors[ImGui.Col.Separator] = .{0.275, 0.318, 0.451, 0.78};
    style.Colors[ImGui.Col.SeparatorHovered] = .{0.275, 0.318, 0.451, 1};
    style.Colors[ImGui.Col.SeparatorActive] = .{1, 1, 1, 1};
    style.Colors[ImGui.Col.ResizeGrip] = .{0.145, 0.145, 0.145, 1};
    style.Colors[ImGui.Col.ResizeGripHovered] = .{0.972, 1, 0.498, 1};
    style.Colors[ImGui.Col.ResizeGripActive] = .{0.999, 1, 0.999, 1};
    style.Colors[ImGui.Col.Tab] = .{0, 0, 0, 0};
    style.Colors[ImGui.Col.TabHovered] = .{0.04, 0.32, 0.71, 0.78};
    style.Colors[ImGui.Col.TabActive] = .{0.05, 0.48, 0.86, 0.78};
    style.Colors[ImGui.Col.TabUnfocused] = .{0, 0, 0, 0};
    style.Colors[ImGui.Col.TabUnfocusedActive] = .{0.11, 0.13, 0.16, 0.39};
    style.Colors[ImGui.Col.PlotLines] = .{0.521, 0.600, 0.701, 1};
    style.Colors[ImGui.Col.PlotLinesHovered] = .{0.039, 0.980, 0.980, 1};
    style.Colors[ImGui.Col.PlotHistogram] = .{0.884, 0.794, 0.561, 1};
    style.Colors[ImGui.Col.PlotHistogramHovered] = .{0.957, 0.957, 0.957, 1};
    style.Colors[ImGui.Col.TableHeaderBg] = .{0.089, 0.100, 0.122, 1};
    style.Colors[ImGui.Col.TableBorderStrong] = .{0.047, 0.054, 0.070, 1};
    style.Colors[ImGui.Col.TableBorderLight] = .{0.141, 0.161, 0.208, 0.2};
    style.Colors[ImGui.Col.TableRowBg] = .{0.117, 0.133, 0.149, 1};
    style.Colors[ImGui.Col.TableRowBgAlt] = .{0.098, 0.105, 0.121, 1};
    style.Colors[ImGui.Col.TextSelectedBg] = .{0.935, 0.935, 0.935, 0.376};
    style.Colors[ImGui.Col.DragDropTarget] = .{0.498, 0.513, 1, 1};
    style.Colors[ImGui.Col.NavHighlight] = .{0.266, 0.289, 1, 1};
    style.Colors[ImGui.Col.NavWindowingHighlight] = .{0.498, 0.513, 1, 1};
    style.Colors[ImGui.Col.NavWindowingDimBg] = .{0.196, 0.176, 0.545, 0.501};
    style.Colors[ImGui.Col.ModalWindowDimBg] = .{0.239, 0.233, 0.342, 0.501};
    style.Colors[ImGui.Col.DockingPreview] = .{0.341, 0.341, 0.341, 0.78};
}

SetEditorStyleOpaque :: () {
    style := ImGui.GetStyle();

    style.Colors[ImGui.Col.WindowBg].a = 1;
    style.Colors[ImGui.Col.ChildBg].a = 1;
    style.Colors[ImGui.Col.PopupBg].a = 1;
    style.Colors[ImGui.Col.FrameBg].a = 1;
    style.Colors[ImGui.Col.FrameBgHovered].a = 1;
    style.Colors[ImGui.Col.FrameBgActive].a = 1;
    style.Colors[ImGui.Col.TitleBg].a = 1;
    style.Colors[ImGui.Col.TitleBgActive].a = 1;
    style.Colors[ImGui.Col.TitleBgCollapsed].a = 1;
    style.Colors[ImGui.Col.MenuBarBg].a = 1;
    style.Colors[ImGui.Col.Button].a = 1;
    style.Colors[ImGui.Col.ButtonHovered].a = 1;
    style.Colors[ImGui.Col.ButtonActive].a = 1;
    style.Colors[ImGui.Col.Header].a = 1;
    style.Colors[ImGui.Col.HeaderHovered].a = 1;
    style.Colors[ImGui.Col.HeaderActive].a = 1;
    style.Colors[ImGui.Col.ModalWindowDimBg].a = 0.501;
    style.Colors[ImGui.Col.Tab].a = 0;
    style.Colors[ImGui.Col.TabHovered].a = 1;
    style.Colors[ImGui.Col.TabActive].a = 1;
    style.Colors[ImGui.Col.TabUnfocused].a = 0;
    style.Colors[ImGui.Col.TabUnfocusedActive].a = 1;
    style.Colors[ImGui.Col.TableHeaderBg].a = 1;
    style.Colors[ImGui.Col.TableRowBg].a = 1;
    style.Colors[ImGui.Col.TableRowBgAlt].a = 1;
    style.Colors[ImGui.Col.ScrollbarBg].a = 1;
    style.Colors[ImGui.Col.ScrollbarGrab].a = 1;
    style.Colors[ImGui.Col.ScrollbarGrabHovered].a = 1;
    style.Colors[ImGui.Col.ScrollbarGrabActive].a = 1;
    style.Colors[ImGui.Col.DockingEmptyBg].a = 1;
}

SetEditorStyleForBlurredBackground :: () {
    style := ImGui.GetStyle();

    style.Colors[ImGui.Col.WindowBg].a = 0.78;
    style.Colors[ImGui.Col.ChildBg].a = 0.78;
    style.Colors[ImGui.Col.PopupBg].a = 0.78;
    style.Colors[ImGui.Col.FrameBg].a = 0.20;
    style.Colors[ImGui.Col.FrameBgHovered].a = 0.39;
    style.Colors[ImGui.Col.FrameBgActive].a = 0.59;
    style.Colors[ImGui.Col.TitleBg].a = 0.78;
    style.Colors[ImGui.Col.TitleBgActive].a = 0.78;
    style.Colors[ImGui.Col.TitleBgCollapsed].a = 0.78;
    style.Colors[ImGui.Col.MenuBarBg].a = 0.39;
    style.Colors[ImGui.Col.Button].a = 0.78;
    style.Colors[ImGui.Col.ButtonHovered].a = 0.78;
    style.Colors[ImGui.Col.ButtonActive].a = 0.78;
    style.Colors[ImGui.Col.Header].a = 0.78;
    style.Colors[ImGui.Col.HeaderHovered].a = 0.78;
    style.Colors[ImGui.Col.HeaderActive].a = 0.78;
    style.Colors[ImGui.Col.ModalWindowDimBg].a = 0.78;
    style.Colors[ImGui.Col.Tab].a = 0;
    style.Colors[ImGui.Col.TabHovered].a = 0.78;
    style.Colors[ImGui.Col.TabActive].a = 0.78;
    style.Colors[ImGui.Col.TabUnfocused].a = 0;
    style.Colors[ImGui.Col.TabUnfocusedActive].a = 0.78;
    style.Colors[ImGui.Col.TableHeaderBg].a = 0.78;
    style.Colors[ImGui.Col.TableRowBg].a = 0.78;
    style.Colors[ImGui.Col.TableRowBgAlt].a = 0.78;
    style.Colors[ImGui.Col.ScrollbarBg].a = 0.78;
    style.Colors[ImGui.Col.ScrollbarGrab].a = 0.78;
    style.Colors[ImGui.Col.ScrollbarGrabHovered].a = 0.78;
    style.Colors[ImGui.Col.ScrollbarGrabActive].a = 0.78;
    style.Colors[ImGui.Col.DockingEmptyBg].a = 0.78;
}

BeginButtonCombo :: (label : *u8, size : Vec2f = .{0,0}, flags : ImGui.ComboFlags = 0) -> bool {
    window := ImGui.GetCurrentWindow();

    backup_next_window_data_flags := ImGui.GImGui.NextWindowData_.Flags;
    ImGui.GImGui.NextWindowData_.Flags = 0; // We behave like Begin() and need to consume those values
    if window.SkipItems {
        return false;
    }

    id := ImGui.GetID(label);
    pressed := ImGui.Button(label, size=size);
    popup_id := ImGui.ImHashStr("##ComboPopup", 0, id);
    bb := ImGui.ImRect.{
        ImGui.GetItemRectMin(),
        ImGui.GetItemRectMax(),
    };

    popup_open := ImGui.IsPopupOpen(popup_id, 0);
    if pressed && !popup_open {
        ImGui.OpenPopupEx(popup_id, 0);
        popup_open = true;
    }

    if !popup_open {
        return false;
    }

    ImGui.GImGui.NextWindowData_.Flags = backup_next_window_data_flags;

    return ImGui.BeginComboPopup(popup_id, bb, flags);
}

EnumCombo :: (label : *u8, value : Any) -> InteractionState {
    type := Devariantize(value.type);
    ptr := value.value_pointer;

    enum_info := cast(*Type_Info_Enum, type);
    is_flags := enum_info.enum_type_flags & .FLAGS != 0;

    current_value := 0;
    if enum_info.runtime_size == {
    case 1; current_value = cast(s64, cast(*s8,  ptr).*);
    case 2; current_value = cast(s64, cast(*s16, ptr).*);
    case 4; current_value = cast(s64, cast(*s32, ptr).*);
    case 8; current_value = cast(s64, cast(*s64, ptr).*);
    }

    state : InteractionState;
    if ImGui.BeginCombo(label, CTPrint("%", value)) {
        for enum_info.values {
            name := enum_info.names[it_index];
            selected := ifx is_flags then current_value & it == it else current_value == it;
            if ImGui.MenuItem(CStringClone(name ,, Temp), selected=selected) {
                if enum_info.enum_type_flags & .FLAGS {
                    if !selected {
                        if enum_info.runtime_size == {
                        case 1; cast(*s8,  ptr).* |= xx it;
                        case 2; cast(*s16, ptr).* |= xx it;
                        case 4; cast(*s32, ptr).* |= xx it;
                        case 8; cast(*s64, ptr).* |= xx it;
                        }
                    } else {
                        if enum_info.runtime_size == {
                        case 1; cast(*s8,  ptr).* &= ~cast(s8,  it);
                        case 2; cast(*s16, ptr).* &= ~cast(s16, it);
                        case 4; cast(*s32, ptr).* &= ~cast(s32, it);
                        case 8; cast(*s64, ptr).* &= ~cast(s64, it);
                        }
                    }
                } else {
                    if enum_info.runtime_size == {
                    case 1; cast(*s8,  ptr).* = xx it;
                    case 2; cast(*s16, ptr).* = xx it;
                    case 4; cast(*s32, ptr).* = xx it;
                    case 8; cast(*s64, ptr).* = xx it;
                    }
                }
            }

            state |= LastItemInteractionState();
        }

        ImGui.EndCombo();
    }

    return state;
}
