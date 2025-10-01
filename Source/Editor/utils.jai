U32Color :: ImGui.ColorConvertFloat4ToU32;

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
