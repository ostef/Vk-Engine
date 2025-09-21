#import "Common";
#import "Win32/DXGI";
#import "Win32/DXC";
#import "Win32/Direct3D";
#import "Win32/Direct3D12";

#scope_file

Win32 :: #import "Win32" (Threads = true);
ImGui :: #import "ImGui";

ImVec2 :: ImGui.ImVec2;
ImDrawVert :: ImGui.ImDrawVert;
ImDrawIdx :: ImGui.ImDrawIdx;

#scope_export

Log_ImGui_D3D12 :: Log_Section.{name="ImGui/Direct3D12"};

UserData :: struct
{
    jai_context : *Context;
    device : *ID3D12Device;
    root_signature : *ID3D12RootSignature;
    pipeline_state : *ID3D12PipelineState;
    rtv_format : DXGI_FORMAT;
    font_texture_resource : *ID3D12Resource;
    font_srv_cpu_handle : D3D12_CPU_DESCRIPTOR_HANDLE;
    font_srv_gpu_handle : D3D12_GPU_DESCRIPTOR_HANDLE;
    srv_heap : *ID3D12DescriptorHeap;
    num_frames_in_flight : u32;
}

RenderBuffers :: struct
{
    vertex_buffer : *ID3D12Resource;
    vertex_buffer_size : s64;
    index_buffer : *ID3D12Resource;
    index_buffer_size : s64;
}

FrameContext :: struct
{
    command_allocator : *ID3D12CommandAllocator;
    render_target : *ID3D12Resource;
    render_target_cpu_handle : D3D12_CPU_DESCRIPTOR_HANDLE;
}

ViewportData :: struct
{
    command_queue : *ID3D12CommandQueue;
    command_list : *ID3D12GraphicsCommandList;
    rtv_heap : *ID3D12DescriptorHeap;
    swap_chain : *IDXGISwapChain3;
    fence : *ID3D12Fence;
    fence_value : u64;
    fence_event : Win32.HANDLE;
    num_frames_in_flight : u32;
    frame_ctx : []FrameContext;

    frame_index : u32;
    frame_render_buffers : []RenderBuffers;
}

ShaderConstantBuffer :: struct
{
    model_view_projection : [4][4]float;
}

GetUserData :: inline () -> *UserData #no_context
{
    if ImGui.GetCurrentContext()
        return cast(*UserData) ImGui.GetIO().BackendRendererUserData;

    return null;
}

#scope_module

LogSystemError :: (function_name : string, error_code : u32, location := #caller_location)
{
    wide_buffer : [1000]u16 = ---;
    utf8_buffer : [2000]u8 = ---;

    wide_count := Win32.FormatMessageW (
        Win32.FORMAT_MESSAGE_FROM_SYSTEM | Win32.FORMAT_MESSAGE_IGNORE_INSERTS,
        null,
        error_code,
        Win32.MAKELANGID(0, 1),
        wide_buffer.data,
        wide_buffer.count,
        null
    );

    utf8_count := Win32.WideCharToMultiByte(
        Win32.CP_UTF8,
        0,
        wide_buffer.data,
        cast(s32) wide_count,
        cast(*u8) utf8_buffer.data,
        utf8_buffer.count,
        null,
        null
    );

    error_string := string.{xx utf8_count, utf8_buffer.data};

    msg : string;
    if error_string
        msg = SPrint("% failed: %", function_name, error_string,, Temp);
    else
        msg = SPrint("% failed (%)", function_name, error_code,, Temp);

    info : Log_Info;
    info.location     = location;
    info.common_flags = .ERROR;
    info.section      = context.log_section;

    context.logger(msg, context.logger_data, info);
}

LogLastD3D12Error :: (function_name : string, error_code : Win32.HRESULT, location := #caller_location)
{
    LogSectionScope(*Log_ImGui_D3D12);

    data := GetUserData();
    if !data
    {
        LogSystemError(function_name, Win32.HRESULT_CODE(error_code), location);
        return;
    }

    info_queue : *ID3D12InfoQueue;
    defer Win32.SafeRelease(info_queue);

    result := data.device.QueryInterface(data.device, *info_queue.UUID, xx *info_queue);

    if result < 0
    {
        LogSystemError(function_name, Win32.HRESULT_CODE(error_code), location);
        return;
    }

    number_of_messages := info_queue.GetNumStoredMessagesAllowedByRetrievalFilter(info_queue);

    if number_of_messages == 0
    {
        LogSystemError(function_name, Win32.HRESULT_CODE(error_code), location);
        return;
    }

    length : u64;
    result = info_queue.GetMessage(info_queue, 0, null, *length);
    if result < 0
    {
        LogSystemError(function_name, Win32.HRESULT_CODE(error_code), location);
        return;
    }

    msg := cast(*D3D12_MESSAGE) Alloc(xx length,, Temp);
    result = info_queue.GetMessage(info_queue, 0, msg, *length);
    if result < 0
    {
        LogSystemError(function_name, Win32.HRESULT_CODE(error_code), location);
        return;
    }

    msg_string := string.{xx msg.DescriptionByteLength, msg.pDescription};
    if msg.Severity ==
    {
    case .CORRUPTION; #through;
    case .ERROR;
        LogError("%, %: %", msg.Severity, msg.Category, msg_string, location=location);

    case .WARNING;
        LogWarning("%, %: %", msg.Severity, msg.Category, msg_string, location=location);

    case .INFO; #through;
    case .MESSAGE;
        LogMessage("%, %: %", msg.Severity, msg.Category, msg_string, location=location);
    }
}

#scope_export

Init :: (
    device : *ID3D12Device,
    num_frames_in_flight : u32,
    rtv_format : DXGI_FORMAT,
    srv_heap : *ID3D12DescriptorHeap,
    font_srv_cpu_handle : D3D12_CPU_DESCRIPTOR_HANDLE,
    font_srv_gpu_handle : D3D12_GPU_DESCRIPTOR_HANDLE
) -> bool
{
    io := ImGui.GetIO();
    Assert(io.BackendRendererUserData == null, "Renderer backend already initialized");

    data := Alloc(UserData);
    data.jai_context = *context;
    io.BackendRendererUserData = data;
    io.BackendRendererName = "Direct3D12";

    io.BackendFlags_ |= .RendererHasVtxOffset;
    // io.BackendFlags_ |= .RendererHasViewports;

    if (io.BackendFlags_ & .RendererHasViewports) && (io.ConfigFlags_ & .ViewportsEnable)
        InitPlatformInterface();

    data.device = device;
    data.rtv_format = rtv_format;
    data.num_frames_in_flight = num_frames_in_flight;
    data.srv_heap = srv_heap;
    data.font_srv_cpu_handle = font_srv_cpu_handle;
    data.font_srv_gpu_handle = font_srv_gpu_handle;

    viewport_data := Alloc(ViewportData);
    viewport_data.num_frames_in_flight = num_frames_in_flight;
    viewport_data.frame_ctx = AllocArray(FrameContext, xx num_frames_in_flight, initialize = true);
    viewport_data.frame_render_buffers = AllocArray(RenderBuffers, xx num_frames_in_flight, initialize = true);

    ImGui.GetMainViewport().RendererUserData = viewport_data;

    return CreateDeviceObjects();
}

Terminate :: ()
{
    data := GetUserData();
    Assert(data != null, "Renderer backend not initialized or already shut down");

    io := ImGui.GetIO();

    main_viewport := ImGui.GetMainViewport();
    if main_viewport.RendererUserData
    {
        viewport_data := cast(*ViewportData) main_viewport.RendererUserData;

        for * viewport_data.frame_render_buffers
            DestroyRenderBuffers(it);

        Free(viewport_data);
        main_viewport.RendererUserData = null;
    }

    TerminatePlatformInterface();

    DestroyDeviceObjects();
    io.BackendRendererName = null;
    io.BackendRendererUserData = null;
    Free(data);
}

#scope_file

SetupRenderState :: (draw_data : *ImGui.ImDrawData, cmd_list : *ID3D12GraphicsCommandList, using buffers : *RenderBuffers) #no_context
{
    data := GetUserData();

    L := draw_data.DisplayPos.x;
    R := draw_data.DisplayPos.x + draw_data.DisplaySize.x;
    T := draw_data.DisplayPos.y;
    B := draw_data.DisplayPos.y + draw_data.DisplaySize.y;

    shader_constant_buffer : ShaderConstantBuffer;
    shader_constant_buffer.model_view_projection = .[
        .[ 2.0/(R-L),    0.0,          0.0,   0.0 ],
        .[ 0.0,          2.0/(T-B),    0.0,   0.0 ],
        .[ 0.0,          0.0,          0.5,   0.0 ],
        .[ (R+L)/(L-R),  (T+B)/(B-T),  0.5,   1.0 ],
    ];

    viewport : D3D12_VIEWPORT;
    viewport.Width = draw_data.DisplaySize.x;
    viewport.Height = draw_data.DisplaySize.y;
    viewport.MinDepth = 0;
    viewport.MaxDepth = 1;
    viewport.TopLeftX = 0;
    viewport.TopLeftY = 0;
    cmd_list.RSSetViewports(cmd_list, 1, *viewport);

    offset : u64 = 0;

    vb_view : D3D12_VERTEX_BUFFER_VIEW;
    vb_view.BufferLocation = vertex_buffer.GetGPUVirtualAddress(vertex_buffer) + offset;
    vb_view.SizeInBytes = xx (vertex_buffer_size * size_of(ImDrawVert));
    vb_view.StrideInBytes = size_of(ImDrawVert);
    cmd_list.IASetVertexBuffers(cmd_list, 0, 1, *vb_view);

    ib_view : D3D12_INDEX_BUFFER_VIEW;
    ib_view.BufferLocation = index_buffer.GetGPUVirtualAddress(index_buffer);
    ib_view.SizeInBytes = xx (index_buffer_size * size_of(ImDrawIdx));
    ib_view.Format = ifx size_of(ImDrawIdx) == 2 then .R16_UINT else .R32_UINT;
    cmd_list.IASetIndexBuffer(cmd_list, *ib_view);

    cmd_list.IASetPrimitiveTopology(cmd_list, .TRIANGLELIST);
    cmd_list.SetPipelineState(cmd_list, data.pipeline_state);
    cmd_list.SetGraphicsRootSignature(cmd_list, data.root_signature);
    cmd_list.SetGraphicsRoot32BitConstants(cmd_list, 0, 16, xx *shader_constant_buffer, 0);
    cmd_list.SetDescriptorHeaps(cmd_list, 1, *data.srv_heap);

    blend_factor : [4]float = .[0,0,0,0];
    cmd_list.OMSetBlendFactor(cmd_list, xx *blend_factor);
}

#scope_export

RenderDrawData :: (draw_data : *ImGui.ImDrawData, cmd_list : *ID3D12GraphicsCommandList)
{
    if draw_data.DisplaySize.x <= 0 || draw_data.DisplaySize.y <= 0
        return;

    data := GetUserData();

    viewport_data := cast(*ViewportData) draw_data.OwnerViewport.RendererUserData;
    viewport_data.frame_index += 1;

    using buffers := *viewport_data.frame_render_buffers[viewport_data.frame_index % data.num_frames_in_flight];

    if !vertex_buffer || vertex_buffer_size < draw_data.TotalVtxCount
    {
        Win32.SafeRelease(vertex_buffer);

        vertex_buffer_size = draw_data.TotalVtxCount + 5000;
        desc : D3D12_RESOURCE_DESC;
        desc.Dimension = .BUFFER;
        desc.Width = xx (vertex_buffer_size * size_of(ImDrawVert));
        desc.Height = 1;
        desc.DepthOrArraySize = 1;
        desc.MipLevels = 1;
        desc.SampleDesc.Count = 1;
        desc.Layout = .ROW_MAJOR;

        result := data.device.CreateCommittedResource(
            data.device,
            *(D3D12_HEAP_PROPERTIES.{_Type=.UPLOAD}),
            .NONE,
            *desc,
            .GENERIC_READ,
            null,
            *vertex_buffer.UUID, xx *vertex_buffer
        );

        if result < 0
        {
            LogLastD3D12Error("device.CreateCommittedResource", result);
            return;
        }
    }

    if !index_buffer || index_buffer_size < draw_data.TotalIdxCount
    {
        Win32.SafeRelease(index_buffer);

        index_buffer_size = draw_data.TotalIdxCount + 10000;
        desc : D3D12_RESOURCE_DESC;
        desc.Dimension = .BUFFER;
        desc.Width = xx (index_buffer_size * size_of(ImDrawIdx));
        desc.Height = 1;
        desc.DepthOrArraySize = 1;
        desc.MipLevels = 1;
        desc.SampleDesc.Count = 1;
        desc.Layout = .ROW_MAJOR;

        result := data.device.CreateCommittedResource(
            data.device,
            *(D3D12_HEAP_PROPERTIES.{_Type=.UPLOAD}),
            .NONE,
            *desc,
            .GENERIC_READ,
            null,
            *index_buffer.UUID, xx *index_buffer
        );


        if result < 0
        {
            LogLastD3D12Error("device.CreateCommittedResource", result);
            return;
        }
    }

    vtx_ptr : *ImDrawVert;
    idx_ptr : *ImDrawIdx;
    if vertex_buffer.Map(vertex_buffer, 0, *(D3D12_RANGE.{0,0}), xx *vtx_ptr) < 0
        return;
    if index_buffer.Map(index_buffer, 0, *(D3D12_RANGE.{0,0}), xx *idx_ptr) < 0
        return;

    for i : 0..draw_data.CmdListsCount - 1
    {
        list := draw_data.CmdLists.Data[i];
        memcpy(vtx_ptr, list.VtxBuffer.Data, list.VtxBuffer.Size * size_of(ImDrawVert));
        memcpy(idx_ptr, list.IdxBuffer.Data, list.IdxBuffer.Size * size_of(ImDrawIdx));

        vtx_ptr += list.VtxBuffer.Size;
        idx_ptr += list.IdxBuffer.Size;
    }

    vertex_buffer.Unmap(vertex_buffer, 0, *(D3D12_RANGE.{0,0}));
    index_buffer.Unmap(index_buffer, 0, *(D3D12_RANGE.{0,0}));

    SetupRenderState(draw_data, cmd_list, buffers);

    global_vtx_offset := 0;
    global_idx_offset := 0;
    clip_off := draw_data.DisplayPos;
    for i : 0..draw_data.CmdListsCount - 1
    {
        list := draw_data.CmdLists.Data[i];
        for cmd_i : 0..list.CmdBuffer.Size - 1
        {
            cmd := *list.CmdBuffer.Data[cmd_i];
            if cmd.UserCallback
            {
                if cmd.UserCallback == xx ImGui.ImDrawCallback_ResetRenderState
                    SetupRenderState(draw_data, cmd_list, buffers);
                else
                    cmd.UserCallback(list, cmd);
            }
            else
            {
                clip_min := ImVec2.{cmd.ClipRect.x - clip_off.x, cmd.ClipRect.y - clip_off.y};
                clip_max := ImVec2.{cmd.ClipRect.z - clip_off.x, cmd.ClipRect.w - clip_off.y};
                if clip_max.x <= clip_min.x || clip_max.y <= clip_min.y
                    continue;

                rect := Win32.RECT.{xx clip_min.x, xx clip_min.y, xx clip_max.x, xx clip_max.y};
                texture_handle : D3D12_GPU_DESCRIPTOR_HANDLE;
                texture_handle.ptr = cast(u64) cmd.TextureId;

                cmd_list.SetGraphicsRootDescriptorTable(cmd_list, 1, texture_handle);
                cmd_list.RSSetScissorRects(cmd_list, 1, *rect);
                cmd_list.DrawIndexedInstanced(cmd_list, cmd.ElemCount, 1, xx (cmd.IdxOffset + global_idx_offset), xx (cmd.VtxOffset + global_vtx_offset), 0);
            }
        }

        global_idx_offset += list.IdxBuffer.Size;
        global_vtx_offset += list.VtxBuffer.Size;
    }
}

CreateFontsTexture :: ()
{
    io := ImGui.GetIO();
    data := GetUserData();

    pixels : *u8;
    width, height : s32;
    io.Fonts.GetTexDataAsRGBA32(io.Fonts, *pixels, *width, *height);

    // Upload texture
    desc : D3D12_RESOURCE_DESC;
    desc.Dimension = .TEXTURE2D;
    desc.Width = xx width;
    desc.Height = xx height;
    desc.DepthOrArraySize = 1;
    desc.MipLevels = 1;
    desc.Format = .R8G8B8A8_UNORM;
    desc.SampleDesc.Count = 1;
    desc.Layout = .UNKNOWN;
    texture_desc := desc;

    texture : *ID3D12Resource;
    data.device.CreateCommittedResource(
        data.device,
        *(D3D12_HEAP_PROPERTIES.{_Type=.DEFAULT}),
        .NONE,
        *desc,
        .COPY_DEST,
        null,
        *texture.UUID, xx *texture
    );

    upload_size: u64;
    footprint: D3D12_PLACED_SUBRESOURCE_FOOTPRINT;

    data.device.GetCopyableFootprints(data.device,
        *desc, 0, 1, 0, *footprint, null, null, *upload_size);

    desc = .{};
    desc.Dimension = .BUFFER;
    desc.Width = upload_size;
    desc.Height = 1;
    desc.DepthOrArraySize = 1;
    desc.MipLevels = 1;
    desc.SampleDesc.Count = 1;
    desc.Layout = .ROW_MAJOR;

    upload_buffer: *ID3D12Resource;
    data.device.CreateCommittedResource(
        data.device,
        *(D3D12_HEAP_PROPERTIES.{_Type=.UPLOAD}),
        0,
        *desc,
        .GENERIC_READ,
        null,
        *upload_buffer.UUID, xx *upload_buffer
    );

    mapped : *u8;
    upload_buffer.Map(upload_buffer, 0, *(D3D12_RANGE.{0,0}), xx *mapped);

    for y : 0..footprint.Footprint.Height - 1 {
        memcpy(
            mapped + y * footprint.Footprint.RowPitch,
            pixels + y * cast(u32) width * 4,
            4 * width
        );
    }

    upload_buffer.Unmap(upload_buffer, 0, *(D3D12_RANGE.{0,0}));

    {
        src_location : D3D12_TEXTURE_COPY_LOCATION;
        src_location.pResource = upload_buffer;
        src_location._Type = .PLACED_FOOTPRINT;
        src_location.PlacedFootprint = footprint;

        dst_location : D3D12_TEXTURE_COPY_LOCATION;
        dst_location.pResource = texture;
        dst_location._Type = .SUBRESOURCE_INDEX;

        barrier : D3D12_RESOURCE_BARRIER;
        barrier._Type = .TRANSITION;
        barrier.Transition.pResource = texture;
        barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
        barrier.Transition.StateBefore = .COPY_DEST;
        barrier.Transition.StateAfter = .PIXEL_SHADER_RESOURCE;

        fence : *ID3D12Fence;
        data.device.CreateFence(data.device, 0, .NONE, *fence.UUID, xx *fence);

        event := Win32.CreateEventW(null, 0, 0, null);

        queue_desc : D3D12_COMMAND_QUEUE_DESC;
        queue_desc._Type = .DIRECT;
        queue_desc.NodeMask = 1;

        cmd_queue : *ID3D12CommandQueue;
        data.device.CreateCommandQueue(data.device, *queue_desc, *cmd_queue.UUID, xx *cmd_queue);

        cmd_alloc : *ID3D12CommandAllocator;
        data.device.CreateCommandAllocator(data.device ,.DIRECT, *cmd_alloc.UUID, xx *cmd_alloc);

        cmd_list : *ID3D12GraphicsCommandList;
        data.device.CreateCommandList(data.device, 0, .DIRECT, cmd_alloc, null, *cmd_list.UUID, xx *cmd_list);

        cmd_list.CopyTextureRegion(cmd_list, *dst_location, 0, 0, 0, *src_location, null);
        cmd_list.ResourceBarrier(cmd_list, 1, *barrier);

        cmd_list.Close(cmd_list);

        cmd_queue.ExecuteCommandLists(cmd_queue, 1, xx *cmd_list);
        cmd_queue.Signal(cmd_queue, fence, 1);

        fence.SetEventOnCompletion(fence, 1, event);
        Win32.WaitForSingleObject(event, Win32.INFINITE);

        Win32.SafeRelease(cmd_list);
        Win32.SafeRelease(cmd_alloc);
        Win32.SafeRelease(cmd_queue);
        Win32.CloseHandle(event);
        Win32.SafeRelease(fence);
        Win32.SafeRelease(upload_buffer);
    }

    srv_desc : D3D12_SHADER_RESOURCE_VIEW_DESC;
    srv_desc.Format = texture_desc.Format;
    srv_desc.ViewDimension = .TEXTURE2D;
    srv_desc.Texture2D.MipLevels = texture_desc.MipLevels;
    srv_desc.Texture2D.MostDetailedMip = 0;
    srv_desc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
    data.device.CreateShaderResourceView(data.device, texture, *srv_desc, data.font_srv_cpu_handle);

    Win32.SafeRelease(data.font_texture_resource);
    data.font_texture_resource = texture;

    // Store our identifier
    // READ THIS IF THE STATIC_ASSERT() TRIGGERS:
    // - Important: to compile on 32-bit systems, this backend requires code to be compiled with '#define ImTextureID ImU64'.
    // - This is because we need ImTextureID to carry a 64-bit value and by default ImTextureID is defined as void*.
    // [Solution 1] IDE/msbuild: in "Properties/C++/Preprocessor Definitions" add 'ImTextureID=ImU64' (this is what we do in the 'example_win32_direct12/example_win32_direct12.vcxproj' project file)
    // [Solution 2] IDE/msbuild: in "Properties/C++/Preprocessor Definitions" add 'IMGUI_USER_CONFIG="my_imgui_config.h"' and inside 'my_imgui_config.h' add '#define ImTextureID ImU64' and as many other options as you like.
    // [Solution 3] IDE/msbuild: edit imconfig.h and add '#define ImTextureID ImU64' (prefer solution 2 to create your own config file!)
    // [Solution 4] command-line: add '/D ImTextureID=ImU64' to your cl.exe command-line(this is what we do in the example_win32_direct12/build_win32.bat file)
    #assert size_of(ImGui.ImTextureID) >= size_of(D3D12_GPU_DESCRIPTOR_HANDLE);

    io.Fonts.TexID = cast(ImGui.ImTextureID) data.font_srv_gpu_handle.ptr;
}

CreateDeviceObjects :: () -> bool
{
    data := GetUserData();
    if !data || !data.device
        return false;

    if data.pipeline_state
        DestroyDeviceObjects();

    result : Win32.HRESULT;

    // Create root signature
    {
        desc_range : D3D12_DESCRIPTOR_RANGE;
        desc_range.RangeType = .SRV;
        desc_range.NumDescriptors = 1;
        desc_range.BaseShaderRegister = 0;
        desc_range.OffsetInDescriptorsFromTableStart = 0;

        params : [2]D3D12_ROOT_PARAMETER;
        params[0].ParameterType = ._32BIT_CONSTANTS;
        params[0].Constants.ShaderRegister = 0;
        params[0].Constants.Num32BitValues = 16;
        params[0].ShaderVisibility = .VERTEX;

        params[1].ParameterType = .DESCRIPTOR_TABLE;
        params[1].DescriptorTable.NumDescriptorRanges = 1;
        params[1].DescriptorTable.pDescriptorRanges = *desc_range;
        params[1].ShaderVisibility = .PIXEL;

        // Bilinear sampling is required by default. Set 'io.Fonts->Flags |= ImFontAtlasFlags_NoBakedLines' or 'style.AntiAliasedLinesUseTex = false' to allow point/nearest sampling.
        static_sampler : D3D12_STATIC_SAMPLER_DESC;
        static_sampler.Filter = .MIN_MAG_MIP_LINEAR;
        static_sampler.AddressU = .WRAP;
        static_sampler.AddressV = .WRAP;
        static_sampler.AddressW = .WRAP;
        static_sampler.MipLODBias = 0;
        static_sampler.MaxAnisotropy = 0;
        static_sampler.ComparisonFunc = .ALWAYS;
        static_sampler.BorderColor = D3D12_STATIC_BORDER_COLOR_TRANSPARENT_BLACK;
        static_sampler.MinLOD = 0;
        static_sampler.MaxLOD = 0;
        static_sampler.ShaderRegister = 0;
        static_sampler.ShaderVisibility = .PIXEL;

        desc : D3D12_ROOT_SIGNATURE_DESC;
        desc.NumParameters = params.count;
        desc.pParameters = params.data;
        desc.NumStaticSamplers = 1;
        desc.pStaticSamplers = *static_sampler;
        desc.Flags = .ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT
            | .DENY_HULL_SHADER_ROOT_ACCESS
            | .DENY_DOMAIN_SHADER_ROOT_ACCESS
            | .DENY_GEOMETRY_SHADER_ROOT_ACCESS;

        blob : *ID3DBlob;
        defer Win32.SafeRelease(blob);

        result = D3D12SerializeRootSignature(*desc, D3D_ROOT_SIGNATURE_VERSION_1, *blob, null);
        if result < 0
        {
            LogLastD3D12Error("D3D12SerializeRootSignature", result);
            return false;
        }

        data.device.CreateRootSignature(
            data.device, 0,
            blob.GetBufferPointer(blob), blob.GetBufferSize(blob),
            *data.root_signature.UUID, xx *data.root_signature
        );
    }

    pso_desc : D3D12_GRAPHICS_PIPELINE_STATE_DESC;
    pso_desc.NodeMask = 1;
    pso_desc.PrimitiveTopologyType = .TRIANGLE;
    pso_desc.pRootSignature = data.root_signature;
    pso_desc.SampleMask = 0xffffffff;
    pso_desc.NumRenderTargets = 1;
    pso_desc.RTVFormats[0] = data.rtv_format;
    pso_desc.SampleDesc.Count = 1;

    DXCCompile :: (
        dxc_utils : *IDxcUtils, dxc_compiler : *IDxcCompiler3,
        $name : string, $source : string, $entry_point : string, $version : string
    ) -> *IDxcBlob
    {
        AllocatorScope(Temp);

        arguments : [..]string;
        ArrayPush(*arguments, name);
        ArrayPush(*arguments, "-E");
        ArrayPush(*arguments, entry_point);
        ArrayPush(*arguments, "-T");
        ArrayPush(*arguments, version);
        ArrayPush(*arguments, "-HV 2021");
        ArrayPush(*arguments, "-Od");           // Disable optimizations

        arguments_wide : [..]*u16;

        for arguments
            ArrayPush(*arguments_wide, Win32.Utf8ToWide(it));

        blob_encoding: *IDxcBlobEncoding;
        defer Win32.SafeRelease(blob_encoding);

        result := dxc_utils.CreateBlobFromPinned(dxc_utils, source.data, xx source.count, .UTF8, *blob_encoding);
        if result < 0
            return null;

        shader_buffer : DxcBuffer;
        shader_buffer.Ptr      = blob_encoding.GetBufferPointer(blob_encoding);
        shader_buffer.Size     = blob_encoding.GetBufferSize(blob_encoding);
        shader_buffer.Encoding = 0;

        dxc_result: *IDxcResult;
        defer Win32.SafeRelease(dxc_result);

        result = dxc_compiler.Compile(
            dxc_compiler,
            *shader_buffer,
            cast(**u16) arguments_wide.data, xx arguments_wide.count,
            null,
            *dxc_result.UUID, xx *dxc_result
        );

        if result < 0
        {
            LogLastD3D12Error("dxc_compiler.Compile", result);
            return null;
        }

        // Check the compiler status and printing out any errors
        dxc_result.GetStatus(dxc_result, *result);
        if result < 0
        {
            error_blob : *IDxcBlobUtf8;
            defer Win32.SafeRelease(error_blob);

            dxc_result.GetOutput(dxc_result, .DXC_OUT_ERRORS, *error_blob.UUID, xx *error_blob, null);

            if error_blob && error_blob.GetStringLength(error_blob) > 0
            {
                error_string := MakeString(error_blob.GetStringPointer(error_blob));
                LogError(error_string);
            }

            return null;
        }

        blob : *IDxcBlob;

        result = dxc_result.GetResult(dxc_result, *blob);
        if result < 0
        {
            LogLastD3D12Error("dxc_result.GetResult", result);
            return null;
        }

        return blob;
    }

Shader_Source :: #string HLSL
cbuffer VSConstants : register(b0)
{
    float4x4 projection_matrix;
};

struct VSInput
{
    float2 position   : POSITION;
    float4 color      : COLOR;
    float2 tex_coords : TEX_COORDS;
};

struct PSInput
{
    float4 position   : SV_POSITION;
    float4 color      : COLOR;
    float2 tex_coords : TEX_COORDS;
};

PSInput VSMain(VSInput input)
{
    PSInput output;
    output.position = mul(projection_matrix, float4(input.position.xy, 0.0, 1.0));
    output.color = input.color;
    output.tex_coords = input.tex_coords;

    return output;
}

SamplerState sampler0 : register(s0);
Texture2D texture0 : register(t0);

float4 PSMain(PSInput input) : SV_TARGET
{
    return input.color * texture0.Sample(sampler0, input.tex_coords);
}
HLSL

    dxc_utils : *IDxcUtils;
    defer Win32.SafeRelease(dxc_utils);

    result = DxcCreateInstance(*CLSID_DxcUtils, *dxc_utils.UUID, xx *dxc_utils);
    if result < 0
    {
        LogLastD3D12Error("DxcCreateInstance(IDxcUtils)", result);
        return false;
    }

    dxc_compiler : *IDxcCompiler3;
    defer Win32.SafeRelease(dxc_compiler);

    result = DxcCreateInstance(*CLSID_DxcCompiler, *dxc_compiler.UUID, xx *dxc_compiler);
    if result < 0
    {
        LogLastD3D12Error("DxcCreateInstance(IDxcCompiler3)", result);
        return false;
    }

    vertex_shader_blob := DXCCompile(
        dxc_utils, dxc_compiler,
        "ImGui_Vertex_Shader", Shader_Source, "VSMain", "vs_6_0"
    );

    if !vertex_shader_blob
        return false;

    defer Win32.SafeRelease(vertex_shader_blob);

    pso_desc.VS = .{
        vertex_shader_blob.GetBufferPointer(vertex_shader_blob),
        vertex_shader_blob.GetBufferSize(vertex_shader_blob)
    };

    pixel_shader_blob := DXCCompile(
        dxc_utils, dxc_compiler,
        "ImGui_Pixel_Shader", Shader_Source, "PSMain", "ps_6_0"
    );

    if !pixel_shader_blob
        return false;

    defer Win32.SafeRelease(pixel_shader_blob);

    pso_desc.PS = .{
        pixel_shader_blob.GetBufferPointer(pixel_shader_blob),
        pixel_shader_blob.GetBufferSize(pixel_shader_blob)
    };

    input_layout := D3D12_INPUT_ELEMENT_DESC.[
        .{"POSITION", 0, .R32G32_FLOAT, 0, xx OffsetOf(ImDrawVert, "pos"), .PER_VERTEX_DATA, 0},
        .{"TEX_COORDS", 0, .R32G32_FLOAT, 0, xx OffsetOf(ImDrawVert, "uv"), .PER_VERTEX_DATA, 0},
        .{"COLOR", 0, .R8G8B8A8_UNORM, 0, xx OffsetOf(ImDrawVert, "col"), .PER_VERTEX_DATA, 0},
    ];

    pso_desc.InputLayout = .{input_layout.data, input_layout.count};

    {
        using pso_desc.BlendState;
        RenderTarget[0].BlendEnable = 1;
        RenderTarget[0].LogicOpEnable = 0;
        RenderTarget[0].SrcBlend = .SRC_ALPHA;
        RenderTarget[0].DestBlend = .INV_SRC_ALPHA;
        RenderTarget[0].BlendOp = .ADD;
        RenderTarget[0].SrcBlendAlpha = .ONE;
        RenderTarget[0].DestBlendAlpha = .INV_SRC_ALPHA;
        RenderTarget[0].BlendOpAlpha = .ADD;
        RenderTarget[0].LogicOp = .NOOP;
        RenderTarget[0].RenderTargetWriteMask = D3D12_COLOR_WRITE_ENABLE_ALL;
    }

    {
        using pso_desc.RasterizerState;
        FillMode = .SOLID;
        CullMode = .NONE;
        FrontCounterClockwise = 0;
        DepthBias = D3D12_DEFAULT_DEPTH_BIAS;
        DepthBiasClamp = D3D12_DEFAULT_DEPTH_BIAS_CLAMP;
        SlopeScaledDepthBias = D3D12_DEFAULT_SLOPE_SCALED_DEPTH_BIAS;
        DepthClipEnable = 1;
        ConservativeRaster = .OFF;
    }

    {
        using pso_desc.DepthStencilState;
        DepthEnable = 0;
        DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ALL;
        DepthFunc = .ALWAYS;
        StencilEnable = 0;
        FrontFace.StencilFailOp = .KEEP;
        FrontFace.StencilDepthFailOp = .KEEP;
        FrontFace.StencilPassOp = .KEEP;
        FrontFace.StencilFunc = .ALWAYS;
        BackFace = FrontFace;
    }

    result = data.device.CreateGraphicsPipelineState(data.device, *pso_desc, *data.pipeline_state.UUID, xx *data.pipeline_state);
    if result < 0
    {
        LogLastD3D12Error("device.CreateGraphicsPipelineState", result);
        return false;
    }

    CreateFontsTexture();

    return true;
}

DestroyDeviceObjects :: ()
{
    using data := GetUserData();
    if !data || !data.device
        return;

    Win32.SafeRelease(data.root_signature);
    Win32.SafeRelease(data.pipeline_state);
    Win32.SafeRelease(data.font_texture_resource);

    io := ImGui.GetIO();
    io.Fonts.TexID = cast(ImGui.ImTextureID) 0;
}

DestroyRenderBuffers :: (buffers : *RenderBuffers)
{
    Win32.SafeRelease(buffers.index_buffer);
    Win32.SafeRelease(buffers.vertex_buffer);
    buffers.* = .{};
}

//--------------------------------------------------------------------------------------------------------
// MULTI-VIEWPORT / PLATFORM INTERFACE SUPPORT
// This is an _advanced_ and _optional_ feature, allowing the backend to create and handle multiple viewports simultaneously.
// If you are new to dear imgui or creating a new binding for dear imgui, it is recommended that you completely ignore this section first..
//--------------------------------------------------------------------------------------------------------

InitPlatformInterface :: ()
{
    platform_io := ImGui.GetPlatformIO();
    platform_io.Renderer_CreateWindow = null; //CreateWindow;
    platform_io.Renderer_DestroyWindow = null; //DestroyWindow;
    platform_io.Renderer_SetWindowSize = null; //SetWindowSize;
    platform_io.Renderer_RenderWindow = null; //RenderWindow;
    platform_io.Renderer_SwapBuffers = null; //SwapBuffers;
}

TerminatePlatformInterface :: ()
{
    ImGui.DestroyPlatformWindows();
}
