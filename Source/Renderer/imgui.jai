ImGui :: #import "ImGui";

ImGuiRenderer :: struct {
    jai_context : *#Context;
    font_texture : GfxTexture;
    font_upload_buffer : GfxBuffer;
    should_upload_font_texture : bool;
}

GetImGuiRenderer :: () -> *ImGuiRenderer {
    return xx ImGui.GetIO().BackendRendererUserData;
}

InitImGuiRenderer :: () {
    io := ImGui.GetIO();
    Assert(io.BackendRendererUserData == null, "Renderer backend already initialized");

    renderer := Alloc(ImGuiRenderer);
    renderer.jai_context = *context;

    io.BackendRendererUserData = renderer;
    io.BackendRendererName = "Vulkan";

    io.BackendFlags_ |= .RendererHasVtxOffset;
    // io.BackendFlags_ |= .RendererHasViewports;

    // if io.ConfigFlags_ & .ViewportsEnable {
    //     InitPlatformInterface();
    // }

    CreateImGuiFontsTexture();
} @ModuleAPI

DestroyImGuiRenderer :: () {
    renderer := GetImGuiRenderer();

    DestroyImGuiFontsTexture();
    DestroyGfxBuffer(*renderer.font_upload_buffer);

    Free(renderer);

    io := ImGui.GetIO();
    io.BackendRendererUserData = null;
    io.BackendRendererName = "";
} @ModuleAPI

InitImGui :: () {
    for * g_imgui_binding_set_allocators {
        it.base_pool_desc = MakeGfxBindingPoolDesc(ImGuiDrawCallBindingSet, 20);
        it.new_pool_desc = it.base_pool_desc;
        ok := InitBindingSetAllocator(it, "ImGuiDrawCallBindingSet");
        Assert(ok, "Could not initialize ImGui binding set allocator");
    }

    InitImGuiPipeline();
}

DestroyImGui :: () {
    WaitForGPUIdle();

    DestroyGfxGraphicsPipeline(*g_imgui_pipeline);

    for * g_imgui_binding_set_allocators {
        DestroyBindingSetAllocator(it);
    }

    for * g_imgui_vertex_buffers {
        DestroyGfxBuffer(it);
    }

    for * g_imgui_index_buffers {
        DestroyGfxBuffer(it);
    }
}

CreateImGuiFontsTexture :: () {
    io := ImGui.GetIO();
    renderer := GetImGuiRenderer();

    if !IsNull(*renderer.font_texture) {
        QueueDestroyGfxTexture(*renderer.font_texture);
    }

    pixels : *u8;
    width, height : s32;
    io.Fonts.GetTexDataAsRGBA32(io.Fonts, *pixels, *width, *height);

    desc : GfxTextureDesc;
    desc.type = .Texture2D;
    desc.pixel_format = .RGBA8UNorm;
    desc.width = xx width;
    desc.height = xx height;
    desc.usage = .TransferDst | .Sampled;

    renderer.font_texture = CreateGfxTexture("ImGui Font", desc);
    Assert(!IsNull(*renderer.font_texture), "Could not create ImGui font texture");

    renderer.should_upload_font_texture = true;

    io.Fonts.TexID = *renderer.font_texture;
}

DestroyImGuiFontsTexture :: () {
    io := ImGui.GetIO();

    if io.Fonts.TexID {
        QueueDestroyGfxTexture(cast(*GfxTexture, io.Fonts.TexID));
    }

    io.Fonts.TexID = null;
}

ImGuiVertex :: struct {
    pos: Vec2f;
    uv:  Vec2f;
    col: Vec4ub; @Normalized
}

ImGuiPassBindingSet :: struct {
    projection_matrix : GfxBindingUniformBuffer; @Binding(0) @VertexStage
} @BindingSet

ImGuiDrawCallBindingSet :: struct {
    texture : GfxBindingCombinedTextureSampler; @Binding(0) @FragmentStage
} @BindingSet

g_imgui_color_texture : GfxTexture;

CreateImGuiColorTexture :: () {
    if !IsNull(*g_imgui_color_texture) {
        DestroyGfxTexture(*g_imgui_color_texture);
    }

    w, h := GetWindowPixelSize(g_window);

    desc : GfxTextureDesc;
    desc.type = .Texture2D;
    desc.pixel_format = .RGBA8UNorm;
    desc.width = xx w;
    desc.height = xx h;
    desc.usage = .ColorAttachment | .Sampled;

    g_imgui_color_texture = CreateGfxTexture("ImGui Color", desc);
    Assert(!IsNull(*g_imgui_color_texture), "Could not create ImGui color texture");
}

g_imgui_pipeline : GfxGraphicsPipeline;
g_imgui_vertex_buffers : [Gfx_Num_Frames_In_Flight]GfxBuffer;
g_imgui_index_buffers : [Gfx_Num_Frames_In_Flight]GfxBuffer;
g_imgui_vertex_buffer_sizes : [Gfx_Num_Frames_In_Flight]s64;
g_imgui_index_buffer_sizes : [Gfx_Num_Frames_In_Flight]s64;
g_imgui_vertex_buffer_ptrs : [Gfx_Num_Frames_In_Flight]*void;
g_imgui_index_buffer_ptrs : [Gfx_Num_Frames_In_Flight]*void;

g_imgui_binding_set_allocators : [Gfx_Num_Frames_In_Flight]BindingSetAllocator;

ImGuiBindingSetAllocator :: inline () -> *BindingSetAllocator {
    return *g_imgui_binding_set_allocators[GetFrameInFlight()];
}

InitImGuiPipeline :: () {
    pipeline_desc : GfxGraphicsPipelineDesc;
    pipeline_desc.vertex_shader = GetVertexShader("imgui");
    pipeline_desc.fragment_shader = GetFragmentShader("imgui");
    pipeline_desc.vertex_input = MakeVertexInputDesc(ImGuiVertex, 0);
    pipeline_desc.rasterizer_state = .{cull_face=.None};
    pipeline_desc.blend_states[0] = .{enabled=true};

    pipeline_desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.ImGuiPassBindingSet,
        g_binding_set_layouts.ImGuiDrawCallBindingSet,
    ];

    AddColorAttachment(*pipeline_desc, .RGBA8UNorm);

    g_imgui_pipeline = CreateGfxGraphicsPipeline("ImGui", pipeline_desc);
    Assert(!IsNull(*g_imgui_pipeline), "Could not create ImGui graphics pipeline");
}

g_imgui_draw_data : ImGui.ImDrawData;

CopyImGuiDrawList :: (dst : *ImGui.ImDrawList, src : *ImGui.ImDrawList) {
    dst.CmdBuffer.Reserve(*dst.CmdBuffer, src.CmdBuffer.Capacity);
    dst.CmdBuffer.Size = src.CmdBuffer.Size;
    memcpy(dst.CmdBuffer.Data, src.CmdBuffer.Data, size_of(ImGui.ImDrawCmd) * dst.CmdBuffer.Size);

    dst.IdxBuffer.Reserve(*dst.IdxBuffer, src.IdxBuffer.Capacity);
    dst.IdxBuffer.Size = src.IdxBuffer.Size;
    memcpy(dst.IdxBuffer.Data, src.IdxBuffer.Data, size_of(ImGui.ImDrawIdx) * dst.IdxBuffer.Size);

    dst.VtxBuffer.Reserve(*dst.VtxBuffer, src.VtxBuffer.Capacity);
    dst.VtxBuffer.Size = src.VtxBuffer.Size;
    memcpy(dst.VtxBuffer.Data, src.VtxBuffer.Data, size_of(ImGui.ImDrawVert) * dst.VtxBuffer.Size);

    dst.Flags = src.Flags;
}

CopyImGuiDrawData :: (dst : *ImGui.ImDrawData, src : *ImGui.ImDrawData) {
    for i : 0..dst.CmdLists.Size - 1 {
        list := dst.CmdLists.Data[i];
        list.CmdBuffer.Free(*list.CmdBuffer);
        list.IdxBuffer.Free(*list.IdxBuffer);
        list.VtxBuffer.Free(*list.VtxBuffer);
        Free(list);
    }

    dst.Clear(dst);

    dst.Valid = src.Valid;
    dst.TotalIdxCount = src.TotalIdxCount;
    dst.TotalVtxCount = src.TotalVtxCount;
    dst.DisplayPos = src.DisplayPos;
    dst.DisplaySize = src.DisplaySize;
    dst.FramebufferScale = src.FramebufferScale;
    dst.OwnerViewport = src.OwnerViewport;

    dst.CmdListsCount = src.CmdListsCount;
    dst.CmdLists.Reserve(*dst.CmdLists, src.CmdLists.Capacity);
    for i : 0..src.CmdLists.Size - 1 {
        list := Alloc(ImGui.ImDrawList);
        CopyImGuiDrawList(list, src.CmdLists.Data[i]);
        dst.CmdLists.Push(*dst.CmdLists, list);
    }
}

ImGuiPass :: (cmd_buffer : *GfxCommandBuffer, draw_data : *ImGui.ImDrawData) {
    if IsNull(*g_imgui_pipeline) {
        InitImGuiPipeline();
    }

    renderer := GetImGuiRenderer();
    if renderer.should_upload_font_texture {
        defer renderer.should_upload_font_texture = false;

        io := ImGui.GetIO();

        pixels : *u8;
        width, height : s32;
        io.Fonts.GetTexDataAsRGBA32(io.Fonts, *pixels, *width, *height);

        if !IsNull(*renderer.font_upload_buffer) {
            DestroyGfxBuffer(*renderer.font_upload_buffer);
        }

        buffer_desc : GfxBufferDesc;
        buffer_desc.size = xx (width * height * size_of(u32));
        buffer_desc.usage = .TransferSrc;
        buffer_desc.memory_usage = .Upload;
        renderer.font_upload_buffer = CreateGfxBuffer("ImGui Font Upload", buffer_desc);
        Assert(!IsNull(*renderer.font_upload_buffer), "Could not create ImGui font upload buffer");

        vmaCopyMemoryToAllocation(GetGfxContext().allocator, pixels, renderer.font_upload_buffer.allocation, 0, buffer_desc.size);

        pass := BeginGfxCopyPass(cmd_buffer, "ImGui Font Upload");
        {
            AddTextureBarrier(cmd_buffer, .Undefined, .TransferDst, *renderer.font_texture);
            CopyBufferToTexture(*pass, *renderer.font_upload_buffer, *renderer.font_texture);

            AddTextureBarrier(cmd_buffer, .TransferDst, .ShaderReadOnly, *renderer.font_texture);
        }
        EndGfxCopyPass(*pass);
    }

    ResetBindingSetAllocator(ImGuiBindingSetAllocator());

    if !draw_data || draw_data.TotalVtxCount == 0 || draw_data.TotalIdxCount == 0 {
        return;
    }

    fb_width  := cast(s32, draw_data.DisplaySize.x * draw_data.FramebufferScale.x);
    fb_height := cast(s32, draw_data.DisplaySize.y * draw_data.FramebufferScale.y);
    if fb_width <= 0 || fb_height <= 0 {
        return;
    }

    frame_in_flight := GetFrameInFlight();

    vertex_buffer := *g_imgui_vertex_buffers[frame_in_flight];
    index_buffer := *g_imgui_index_buffers[frame_in_flight];
    vtx_buffer_size := draw_data.TotalVtxCount * size_of(ImGui.ImDrawVert);
    idx_buffer_size := draw_data.TotalIdxCount * size_of(ImGui.ImDrawIdx);

    if vtx_buffer_size > g_imgui_vertex_buffer_sizes[frame_in_flight] {
        if !IsNull(vertex_buffer) {
            DestroyGfxBuffer(vertex_buffer);
        }

        desc : GfxBufferDesc;
        desc.size = xx vtx_buffer_size;
        desc.usage = .VertexBuffer;
        desc.memory_usage = .Upload;

        vertex_buffer.* = CreateGfxBuffer("ImGui Vertices", desc);
        Assert(!IsNull(vertex_buffer), "Could not create ImGui vertex buffer");

        alloc_info : VmaAllocationInfo;
        vmaGetAllocationInfo(GetGfxContext().allocator, vertex_buffer.allocation, *alloc_info);
        Assert(alloc_info.pMappedData != null);

        g_imgui_vertex_buffer_ptrs[frame_in_flight] = alloc_info.pMappedData;
        g_imgui_vertex_buffer_sizes[frame_in_flight] = vtx_buffer_size;
    }

    if idx_buffer_size > g_imgui_index_buffer_sizes[frame_in_flight] {
        if !IsNull(index_buffer) {
            DestroyGfxBuffer(index_buffer);
        }

        desc : GfxBufferDesc;
        desc.size = xx idx_buffer_size;
        desc.usage = .IndexBuffer;
        desc.memory_usage = .Upload;

        index_buffer.* = CreateGfxBuffer("ImGui Indices", desc);
        Assert(!IsNull(index_buffer), "Could not create ImGui vertex buffer");

        alloc_info : VmaAllocationInfo;
        vmaGetAllocationInfo(GetGfxContext().allocator, index_buffer.allocation, *alloc_info);
        Assert(alloc_info.pMappedData != null);

        g_imgui_index_buffer_ptrs[frame_in_flight] = alloc_info.pMappedData;
        g_imgui_index_buffer_sizes[frame_in_flight] = idx_buffer_size;
    }

    vtx_buffer_ptr := g_imgui_vertex_buffer_ptrs[frame_in_flight];
    idx_buffer_ptr := g_imgui_index_buffer_ptrs[frame_in_flight];

    vtx_buffer_offset := 0;
    idx_buffer_offset := 0;

    for n : 0..draw_data.CmdListsCount - 1 {
        list := draw_data.CmdLists.Data[n];

        memcpy(vtx_buffer_ptr + vtx_buffer_offset, list.VtxBuffer.Data, list.VtxBuffer.Size * size_of(ImGui.ImDrawVert));
        memcpy(idx_buffer_ptr + idx_buffer_offset, list.IdxBuffer.Data, list.IdxBuffer.Size * size_of(ImGui.ImDrawIdx));

        vtx_buffer_offset += list.VtxBuffer.Size * size_of(ImGui.ImDrawVert);
        idx_buffer_offset += list.IdxBuffer.Size * size_of(ImGui.ImDrawIdx);
    }

    // AddTextureBarrier(cmd_buffer, .Undefined, .ColorAttachment, *g_imgui_color_texture);

    using g_imgui_pipeline;

    L := draw_data.DisplayPos.x;
    R := draw_data.DisplayPos.x + draw_data.DisplaySize.x;
    T := draw_data.DisplayPos.y;
    B := draw_data.DisplayPos.y + draw_data.DisplaySize.y;
    projection_matrix := Mat4fOrthographicProjection(L, R, B, T, -1, 1);
    projection_matrix_offset := AllocAndPackUniformFrameData(projection_matrix);

    pass_bindings := ImGuiPassBindingSet.{
        projection_matrix=.{buffer=FrameDataBuffer(), offset=xx projection_matrix_offset, size=size_of(Mat4f)},
    };
    pass_binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), pass_bindings);

    pass_desc : GfxRenderPassDesc;
    AddColorAttachment(*pass_desc, *g_final_texture);
    // ClearColor(*pass_desc, 0, Vec4f.{0,0,0,0});

    global_vtx_offset := 0;
    global_idx_offset := 0;
    pass := BeginGfxRenderPass(cmd_buffer, "ImGui", pass_desc);
    {
        BindGraphicsPipeline(*pass, *g_imgui_pipeline);
        SetViewport(*pass, .{width=xx fb_width, height=xx fb_height});

        BindVertexBuffer(*pass, 0, vertex_buffer);
        BindIndexBuffer(*pass, ifx size_of(ImGui.ImDrawIdx) == 2 then .UInt16 else .UInt32, index_buffer);
        BindGraphicsBindingSet(*pass, 1, *pass_binding_set);

        current_texture : *GfxTexture;

        clip_off := draw_data.DisplayPos;
        clip_scale := draw_data.FramebufferScale;

        for n : 0..draw_data.CmdListsCount - 1 {
            list := draw_data.CmdLists.Data[n];
            for icmd : 0..list.CmdBuffer.Size - 1 {
                cmd := *list.CmdBuffer.Data[icmd];
                if cmd.UserCallback {
                    if cmd.UserCallback == xx ImGui.ImDrawCallback_ResetRenderState {
                        // SetupRenderState(draw_data, fb_width, fb_height, vao);
                    } else {
                        cmd.UserCallback(list, cmd);
                    }
                } else {
                    clip_min := Vec2f.{
                        (cmd.ClipRect.x - clip_off.x) * clip_scale.x,
                        (cmd.ClipRect.y - clip_off.y) * clip_scale.y,
                    };
                    clip_max := Vec2f.{
                        (cmd.ClipRect.z - clip_off.x) * clip_scale.x,
                        (cmd.ClipRect.w - clip_off.y) * clip_scale.y,
                    };

                    clip_min.x = Clamp(clip_min.x, 0.0, xx fb_width);
                    clip_max.x = Clamp(clip_max.x, 0.0, xx fb_width);
                    clip_min.y = Clamp(clip_min.y, 0.0, xx fb_height);
                    clip_max.y = Clamp(clip_max.y, 0.0, xx fb_height);

                    if clip_max.x <= clip_min.x || clip_max.y <= clip_min.y {
                        continue;
                    }

                    scissor_rect := Recti.{
                        x=xx clip_min.x, y=xx ifx Gfx_Viewport_Origin_Bottom_Left then fb_height - clip_max.y else clip_min.y,
                        w=xx (clip_max.x - clip_min.x), h=xx (clip_max.y - clip_min.y),
                    };

                    SetScissor(*pass, scissor_rect);

                    if cmd.TextureId != current_texture {
                        binding_set := CreateGfxBindingSet(ImGuiBindingSetAllocator(), ImGuiDrawCallBindingSet.{
                            texture=.{sampler=*g_linear_clamp_sampler, texture=xx cmd.TextureId},
                        });

                        BindGraphicsBindingSet(*pass, 2, *binding_set);
                        current_texture = xx cmd.TextureId;
                    }

                    DrawIndexed(
                        *pass,
                        index_count=xx cmd.ElemCount,
                        base_index=xx (cmd.IdxOffset + global_idx_offset),
                        base_vertex=xx (cmd.VtxOffset + global_vtx_offset),
                        instance_count=1
                    );
                }
            }

            global_idx_offset += list.IdxBuffer.Size;
            global_vtx_offset += list.VtxBuffer.Size;
        }
    }
    EndGfxRenderPass(*pass);

    // AddTextureBarrier(cmd_buffer, .ColorAttachment, .ShaderReadOnly, *g_imgui_color_texture);
}
