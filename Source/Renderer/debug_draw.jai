DebugLine :: struct {
    start : Vec3f;
    end : Vec3f;
    color : Vec4f;
} @ShaderType

g_debug_lines : [..]DebugLine;

Max_Debug_Lines :: Frame_Data_Capacity / size_of(DebugLine) / 2;

DebugDrawLine :: (color : Vec4f, start : Vec3f, end : Vec3f) {
    if g_debug_lines.count >= Max_Debug_Lines {
        LogWarning("Exceeding maximum number of debug lines");
        return;
    }

    ArrayPush(*g_debug_lines, .{
        start=start,
        end=end,
        color=color,
    });
} @ModuleAPI

DebugDrawGrid :: (
    color : Vec4f,
    origin : Vec3f, right : Vec3f, forward : Vec3f,
    size : int,
    cell_size := 1.0
) {
    for i : -size..size {
        DebugDrawLine(
            color,
            origin + right * cell_size * i - forward * cell_size * size,
            origin + right * cell_size * i + forward * cell_size * size
        );
    }

    for i : -size..size {
        DebugDrawLine(
            color,
            origin + forward * cell_size * i - right * cell_size * size,
            origin + forward * cell_size * i + right * cell_size * size
        );
    }
} @ModuleAPI

DebugDrawCross :: (color : Vec4f, position : Vec3f, size : float) {
    DebugDrawLine(color, position - .{size * 0.5,0,0}, position + .{size * 0.5,0,0});
    DebugDrawLine(color, position - .{0,size * 0.5,0}, position + .{0,size * 0.5,0});
    DebugDrawLine(color, position - .{0,0,size * 0.5}, position + .{0,0,size * 0.5});
} @ModuleAPI

DebugDrawCircleOutline :: (
    color : Vec4f,
    center : Vec3f,
    tangent : Vec3f, bitangent : Vec3f,
    radius : float,
    resolution := 30,
    start_angle := 0.0, angle := Pi * 2
) {
    if radius <= 0 || resolution <= 0 {
        return;
    }

    theta := -angle / cast(float, resolution);
    tan_factor := Math.tan(theta);
    rad_factor := Math.cos(theta);
    p := Vec2f.{Math.cos(start_angle), Math.sin(start_angle)};

    for 0..resolution - 1 {
        p1 := p;

        t := Vec2f.{-p.y, p.x};

        p += t * tan_factor;
        p *= rad_factor;

        p2 := p;

        start := center + (tangent * p1.x + bitangent * p1.y) * radius;
        end   := center + (tangent * p2.x + bitangent * p2.y) * radius;
        DebugDrawLine(color, start, end);
    }
} @ModuleAPI

DebugDrawSphereOutline :: (color : Vec4f, center : Vec3f, radius : float, resolution := 30) {
    DebugDrawCircleOutline(color, center, .{1,0,0}, .{0,0,1}, radius, resolution);
    DebugDrawCircleOutline(color, center, .{1,0,0}, .{0,1,0}, radius, resolution);
    DebugDrawCircleOutline(color, center, .{0,1,0}, .{0,0,1}, radius, resolution);
} @ModuleAPI

DebugDrawConeOutline :: (color : Vec4f, base : Vec3f, tip : Vec3f, radius : float, resolution := 30, num_divisions := 6) {
    direction := Normalized(tip - base);
    tangent, bitangent := UpToOrthonormalBasis(direction);

    DebugDrawCircleOutline(color, base, tangent, bitangent, radius, resolution);

    theta := -(Pi * 2) / cast(float) num_divisions;
    tan_factor := Math.tan(theta);
    rad_factor := Math.cos(theta);
    p := Vec2f.{1, 0};

    for 0..num_divisions - 1 {
        start := base + (tangent * p.x + bitangent * p.y) * radius;
        DebugDrawLine(color, start, tip);

        t := Vec2f.{-p.y, p.x};

        p += t * tan_factor;
        p *= rad_factor;
    }
} @ModuleAPI

DebugDrawCylinderOutline :: (color : Vec4f, base : Vec3f, tip : Vec3f, radius : float, resolution := 30, num_divisions := 6) {
    direction := Normalized(tip - base);
    tangent, bitangent := UpToOrthonormalBasis(direction);

    DebugDrawCircleOutline(color, base, tangent, bitangent, radius, resolution);
    DebugDrawCircleOutline(color, tip, tangent, bitangent, radius, resolution);

    theta := -(Pi * 2) / cast(float) num_divisions;
    tan_factor := Math.tan(theta);
    rad_factor := Math.cos(theta);
    p := Vec2f.{1, 0};

    for 0..num_divisions - 1 {
        start := base + (tangent * p.x + bitangent * p.y) * radius;
        end   := tip  + (tangent * p.x + bitangent * p.y) * radius;
        DebugDrawLine(color, start, end);

        t := Vec2f.{-p.y, p.x};

        p += t * tan_factor;
        p *= rad_factor;
    }
} @ModuleAPI

DebugDrawCapsuleOutline :: (color : Vec4f, base : Vec3f, tip : Vec3f, radius : float, resolution := 30, num_divisions := 4) {
    direction := Normalized(tip - base);
    tangent, bitangent := UpToOrthonormalBasis(direction);

    a := base + direction * radius;
    b := tip  - direction * radius;
    DebugDrawCircleOutline(color, a, tangent, bitangent, radius, resolution);
    DebugDrawCircleOutline(color, b, tangent, bitangent, radius, resolution);

    DebugDrawCircleOutline(color, a, direction, tangent, radius, resolution / 2, -Pi * 0.5, Pi);
    DebugDrawCircleOutline(color, a, direction, bitangent, radius, resolution / 2, -Pi * 0.5, Pi);
    DebugDrawCircleOutline(color, b, -direction, tangent, radius, resolution / 2, -Pi * 0.5, Pi);
    DebugDrawCircleOutline(color, b, -direction, bitangent, radius, resolution / 2, -Pi * 0.5, Pi);

    theta := -(Pi * 2) / cast(float) num_divisions;
    tan_factor := Math.tan(theta);
    rad_factor := Math.cos(theta);
    p := Vec2f.{1, 0};

    for 0..num_divisions - 1 {
        start := a + (tangent * p.x + bitangent * p.y) * radius;
        end   := b + (tangent * p.x + bitangent * p.y) * radius;
        DebugDrawLine(color, start, end);

        t := Vec2f.{-p.y, p.x};

        p += t * tan_factor;
        p *= rad_factor;
    }
} @ModuleAPI

DebugDrawBoxOutline :: (color : Vec4f, center : Vec3f, half_extents : Vec3f, orientation := Quatf.{}) {
    right := RightVector(orientation);
    up := UpVector(orientation);
    forward := ForwardVector(orientation);

    a := center - right * half_extents.x - up * half_extents.y - forward * half_extents.z;
    b := center + right * half_extents.x - up * half_extents.y - forward * half_extents.z;
    c := center - right * half_extents.x + up * half_extents.y - forward * half_extents.z;
    d := center + right * half_extents.x + up * half_extents.y - forward * half_extents.z;
    e := center - right * half_extents.x - up * half_extents.y + forward * half_extents.z;
    f := center + right * half_extents.x - up * half_extents.y + forward * half_extents.z;
    g := center - right * half_extents.x + up * half_extents.y + forward * half_extents.z;
    h := center + right * half_extents.x + up * half_extents.y + forward * half_extents.z;

    DebugDrawLine(color, a, b);
    DebugDrawLine(color, c, d);
    DebugDrawLine(color, e, f);
    DebugDrawLine(color, g, h);
    DebugDrawLine(color, a, c);
    DebugDrawLine(color, b, d);
    DebugDrawLine(color, e, g);
    DebugDrawLine(color, f, h);
    DebugDrawLine(color, a, e);
    DebugDrawLine(color, b, f);
    DebugDrawLine(color, c, g);
    DebugDrawLine(color, d, h);
} @ModuleAPI

DebugDrawBoxOutline :: (color : Vec4f, center : Vec3f, half_extents : Vec3f, transform : Mat4f) {
    right := Vec3f.{1,0,0};
    up := Vec3f.{0,1,0};
    forward := Vec3f.{0,0,1};

    a := TransformPoint(transform, center - right * half_extents.x - up * half_extents.y - forward * half_extents.z);
    b := TransformPoint(transform, center + right * half_extents.x - up * half_extents.y - forward * half_extents.z);
    c := TransformPoint(transform, center - right * half_extents.x + up * half_extents.y - forward * half_extents.z);
    d := TransformPoint(transform, center + right * half_extents.x + up * half_extents.y - forward * half_extents.z);
    e := TransformPoint(transform, center - right * half_extents.x - up * half_extents.y + forward * half_extents.z);
    f := TransformPoint(transform, center + right * half_extents.x - up * half_extents.y + forward * half_extents.z);
    g := TransformPoint(transform, center - right * half_extents.x + up * half_extents.y + forward * half_extents.z);
    h := TransformPoint(transform, center + right * half_extents.x + up * half_extents.y + forward * half_extents.z);

    DebugDrawLine(color, a, b);
    DebugDrawLine(color, c, d);
    DebugDrawLine(color, e, f);
    DebugDrawLine(color, g, h);
    DebugDrawLine(color, a, c);
    DebugDrawLine(color, b, d);
    DebugDrawLine(color, e, g);
    DebugDrawLine(color, f, h);
    DebugDrawLine(color, a, e);
    DebugDrawLine(color, b, f);
    DebugDrawLine(color, c, g);
    DebugDrawLine(color, d, h);
} @ModuleAPI

DebugLinesBindingSet :: struct {
    viewpoint : GfxBindingUniformBuffer; @Binding(0) @VertexStage
    lines : GfxBindingStorageBuffer; @Binding(1) @VertexStage
} @BindingSet

g_debug_lines_pipeline : GfxGraphicsPipeline;

CreateDebugLinesPipeline :: () {
    desc : GfxGraphicsPipelineDesc;
    desc.vertex_shader = GetVertexShader("debug_line");
    desc.fragment_shader = GetFragmentShader("debug_line");
    desc.primitive_topology = .LineList;

    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.DebugLinesBindingSet,
    ];

    AddColorAttachment(*desc, .RGBA16Float);
    desc.depth_format = .Depth32Float;

    desc.blend_states[0] = .{enabled=true};
    desc.depth_state = .{test_enabled=true, write_enabled=true, compare_op=Depth_Compare_Op};

    g_debug_lines_pipeline = CreateGfxGraphicsPipeline("Debug Lines", desc);
    Assert(!IsNull(*g_debug_lines_pipeline), "Could not create debug lines pipeline");
}

DebugLinesPass :: (using ctx : *RenderContext) {
    if IsNull(*g_debug_lines_pipeline) {
        CreateDebugLinesPipeline();
    }

    defer ArrayClear(*g_debug_lines);

    if g_debug_lines.count <= 0 {
        return;
    }

    w, h := viewpoint.resolution.x, viewpoint.resolution.y;

    viewpoint_offset, viewpoint_size := AllocAndPackUniformFrameData(MakeViewpoint(viewpoint));

    lines_offset, lines_size := AllocAndPackStorageFrameData(g_debug_lines);

    bindings := DebugLinesBindingSet.{
        viewpoint=.{buffer=FrameDataBuffer(), offset=xx viewpoint_offset, size=xx viewpoint_size},
        lines=.{buffer=FrameDataBuffer(), offset=xx lines_offset, size=xx lines_size},
    };
    binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), bindings);

    pass_desc : GfxRenderPassDesc;
    AddColorAttachment(*pass_desc, *render_targets.hdr_color_texture);
    AddDepthAttachment(*pass_desc, *render_targets.depth_texture);

    pass := BeginGfxRenderPass(cmd_buffer, "Debug Lines", pass_desc);
    {
        BindGraphicsPipeline(*pass, *g_debug_lines_pipeline);
        SetViewport(*pass, .{width=xx w, height=xx h});
        SetScissor(*pass, .{w=xx w, h=xx h});

        BindGraphicsBindingSet(*pass, 1, *binding_set);

        Draw(*pass, vertex_count=2, instance_count=xx g_debug_lines.count);
    }
    EndGfxRenderPass(*pass);
}
