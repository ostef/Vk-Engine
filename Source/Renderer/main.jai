#import "Vulkan";
#import "SDL";
#import "Thread";

#load "shader.jai";
#load "glsl_packing.jai";
#load "allocator.jai";
#load "binding_set.jai";
#load "mesh_buffer.jai";
#load "material.jai";
#load "imgui.jai";

g_module := RendererModule.{
    base.Initialize=InitializeRenderer,
    base.Shutdown=ShutdownRenderer,
    base.MainLoop=RendererLoop,
    base.OnEvent=OnEvent,
};

#program_export
ModuleHandshake :: (core : *CoreModule) -> *Module #c_call {
    g_Core = core;

    InitializeAPI(*g_module);

    return *g_module;
}

g_context : #Context;

g_render_thread : Thread;
g_render_thread_produced_semaphore : Semaphore;
g_render_thread_consume_semaphore : Semaphore;
g_render_thread_should_stop : bool;

g_viewpoints_to_render : [..]ViewpointToRender;
g_meshes_to_render : [..]MeshToRender;
g_directional_lights_to_render : [..]DirectionalLightToRender;
g_point_lights_to_render : [..]PointLightToRender;

g_final_texture : GfxTexture;

g_linear_clamp_sampler : GfxSampler;
g_nearest_clamp_sampler : GfxSampler;
g_material_texture_sampler : GfxSampler;

// Pipeline layout used to bind binding sets outside of any render pass at the beginning of the frame
g_dummy_frame_pipeline_layout : GfxPipelineLayout;

g_default_base_color : *Asset(Texture2D);
g_default_normal_map : *Asset(Texture2D);
g_default_metallic_roughness_map : *Asset(Texture2D);
g_default_emissive : *Asset(Texture2D);
g_default_environment_map : *Asset(EnvironmentMap);
g_default_material : *Asset(Material);

LoadDefaultAssets :: () {
    g_default_base_color = LoadAssetPermanent(Texture2D, "Default_BaseColor.png");
    g_default_normal_map = LoadAssetPermanent(Texture2D, "Default_Normal.png");
    g_default_metallic_roughness_map = LoadAssetPermanent(Texture2D, "Default_MetallicRoughness.png");
    g_default_emissive = LoadAssetPermanent(Texture2D, "Default_Emissive.png");
    g_default_environment_map = LoadAssetPermanent(EnvironmentMap, "Default_EnvironmentMap.png");
    g_default_material = LoadAssetPermanent(Material, "Default_Material.mat");
}

InitializeRenderer :: () {
    g_context = remap_context();
    push_context,defer_pop g_context;

    init(*g_render_thread_produced_semaphore);
    signal(*g_render_thread_produced_semaphore);
    init(*g_render_thread_consume_semaphore);

    init(*g_sould_recreate_render_targets_mutex);

    thread_init(*g_render_thread, RenderThread);
    thread_start(*g_render_thread);

    if !LoadAllShaders() {
        Basic.exit(1);
    }

    RecreateRenderTargets();

    CreateAllBindingSetLayouts();

    InitFrameDataAllocators();
    InitBindingSetAllocators();

    sampler_desc : GfxSamplerDesc;
    sampler_desc.min_filter = .Linear;
    sampler_desc.mag_filter = .Linear;
    g_linear_clamp_sampler = CreateGfxSampler("Linear Clamp", sampler_desc);
    Assert(!IsNull(*g_linear_clamp_sampler));

    sampler_desc = .{};
    sampler_desc.min_filter = .Nearest;
    sampler_desc.mag_filter = .Nearest;
    g_nearest_clamp_sampler = CreateGfxSampler("Nearest Clamp", sampler_desc);
    Assert(!IsNull(*g_nearest_clamp_sampler));

    sampler_desc = .{};
    sampler_desc.min_filter = .Linear;
    sampler_desc.mag_filter = .Linear;
    sampler_desc.mipmap_filter = .Linear;
    sampler_desc.u_address_mode = .Repeat;
    sampler_desc.v_address_mode = .Repeat;

    g_material_texture_sampler = CreateGfxSampler("Material Texture", sampler_desc);
    Assert(!IsNull(*g_material_texture_sampler), "Could not create material texture sampler");

    frame_layout_desc : GfxPipelineLayoutDesc;
    frame_layout_desc.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
    ];
    g_dummy_frame_pipeline_layout = CreateGfxPipelineLayout("Dummy Frame", frame_layout_desc);
    Assert(!IsNull(*g_dummy_frame_pipeline_layout), "Could not create dummy frame pipeline layout");

    LoadDefaultAssets();

    InitGPUFrameProfiler(GetGPUFrameProfiler(), 1000);
}

ShutdownRenderer :: () {
    push_context,defer_pop g_context;

    WaitForRenderThread();
    StopRenderThread();

    thread_is_done(*g_render_thread, -1);
    thread_deinit(*g_render_thread);

    destroy(*g_render_thread_produced_semaphore);
    destroy(*g_render_thread_consume_semaphore);

    destroy(*g_sould_recreate_render_targets_mutex);

    WaitForGPUIdle();

    DestroyGPUFrameProfiler(GetGPUFrameProfiler());

    DestroyGfxPipelineLayout(*g_dummy_frame_pipeline_layout);

    DestroyGfxSampler(*g_linear_clamp_sampler);
    DestroyGfxSampler(*g_nearest_clamp_sampler);
    DestroyGfxSampler(*g_material_texture_sampler);

    for * g_frame_data_allocators {
        DestroyFrameDataAllocator(it);
    }

    DestroyBindingSetAllocators();

    DestroyAllBindingSetLayouts();

    DestroyGfxTexture(*g_final_texture);

    DestroyAllShaders();
}

g_sould_recreate_render_targets_mutex : Mutex;
g_sould_recreate_render_targets : bool;

OnEvent :: (event : SDL_Event) {
    push_context,defer_pop g_context;

    if event.type == SDL_WINDOWEVENT {
        if event.window.event == SDL_WINDOWEVENT_RESIZED
        || event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED {
            lock(*g_sould_recreate_render_targets_mutex);
            defer unlock(*g_sould_recreate_render_targets_mutex);

            g_sould_recreate_render_targets = true;
        }
    }
}

RendererLoop :: () {
    push_context,defer_pop g_context;

    ProcessShaderDirectoryChanges();
}

AddViewpointToRender :: (viewpoint : ViewpointToRender) {
    push_context,defer_pop g_context;

    ArrayPush(*g_viewpoints_to_render, viewpoint);
} @ModuleAPI

AddMeshToRender :: (mesh : MeshToRender) {
    push_context,defer_pop g_context;

    ArrayPush(*g_meshes_to_render, mesh);
} @ModuleAPI

AddDirectionalLightToRender :: (light : DirectionalLightToRender) {
    push_context,defer_pop g_context;

    ArrayPush(*g_directional_lights_to_render, light);
} @ModuleAPI

AddPointLightToRender :: (light : PointLightToRender) {
    push_context,defer_pop g_context;

    ArrayPush(*g_point_lights_to_render, light);
} @ModuleAPI

WaitForRenderThread :: () {
    push_context,defer_pop g_context;

    wait_for(*g_render_thread_produced_semaphore);
} @ModuleAPI

SubmitFrameToRenderThread :: () {
    push_context,defer_pop g_context;

    imgui_draw_data := ImGui.GetDrawData();
    CopyImGuiDrawData(*g_imgui_draw_data, imgui_draw_data);

    signal(*g_render_thread_consume_semaphore);
} @ModuleAPI

StopRenderThread :: () {
    push_context,defer_pop g_context;

    g_render_thread_should_stop = true;
    signal(*g_render_thread_consume_semaphore);
} @ModuleAPI

RecreateRenderTargets :: () {
    WaitForGPUIdle();

    if !IsNull(*g_final_texture) {
        DestroyGfxTexture(*g_final_texture);
    }

    w, h := GetWindowPixelSize(GetWindow());

    desc : GfxTextureDesc;
    desc.type = .Texture2D;
    desc.width = xx w;
    desc.height = xx h;
    desc.pixel_format = .RGBA8UNorm;
    desc.usage = .ColorAttachment | .TransferSrc;

    g_final_texture = CreateGfxTexture("Final", desc);
    Assert(!IsNull(*g_final_texture), "Could not create final texture");
}

FrameBindingSet :: struct {
} @BindingSet

RenderThread :: (thread : *Thread) -> s64 {
    while true {
        wait_for(*g_render_thread_consume_semaphore);
        if g_render_thread_should_stop {
            signal(*g_render_thread_produced_semaphore);
            break;
        }

        lock(*g_sould_recreate_render_targets_mutex);
        if g_sould_recreate_render_targets {
            RecreateRenderTargets();
        }
        unlock(*g_sould_recreate_render_targets_mutex);

        RenderFrame();

        signal(*g_render_thread_produced_semaphore);
    }

    return 0;
}

RenderFrame :: () {
    BeginGfxFrame();

    ProfilerBeginFrame(GetGPUFrameProfiler());

    ResetFrameDataAllocator();
    ResetBindingSetAllocators();

    cmd_buffer := CreateGfxCommandBuffer("Main");

    for * g_viewpoints_to_render {
        RenderViewpoint(it);
    }

    AddTextureBarrier(*cmd_buffer, .Undefined, .ColorAttachment, *g_final_texture);

    ImGuiPass(*cmd_buffer, *g_imgui_draw_data);

    AddTextureBarrier(*cmd_buffer, .ColorAttachment, .TransferSrc, *g_final_texture);

    swapchain_texture := *GetGfxContext().swapchain_textures[GetGfxContext().frame_swapchain_image_index];
    AddTextureBarrier(*cmd_buffer, 0, 0, .AllGraphics, .AllWrites | .AllReads, .Undefined, .TransferDst, swapchain_texture);

    region : VkImageBlit;
    region.srcSubresource = MakeVkImageSubresourceLayers(g_final_texture.desc, 0);
    region.srcOffsets[1].x = xx g_final_texture.desc.width;
    region.srcOffsets[1].y = xx g_final_texture.desc.height;
    region.srcOffsets[1].z = 1;

    region.dstSubresource = MakeVkImageSubresourceLayers(swapchain_texture.desc, 0);
    region.dstOffsets[1].x = xx swapchain_texture.desc.width;
    region.dstOffsets[1].y = xx swapchain_texture.desc.height;
    region.dstOffsets[1].z = 1;

    vkCmdBlitImage(cmd_buffer.cmd_buffer, g_final_texture.image, .TRANSFER_SRC_OPTIMAL, swapchain_texture.image, .TRANSFER_DST_OPTIMAL, 1, *region, .LINEAR);

    AddTextureBarrier(*cmd_buffer, .AllGraphics, .AllWrites, 0, 0, .TransferDst, .PresentSrc, swapchain_texture);

    SubmitGfxCommandBuffer(*cmd_buffer);

    SubmitGfxFrame();

    ArrayClear(*g_viewpoints_to_render);
    ArrayClear(*g_meshes_to_render);
    ArrayClear(*g_directional_lights_to_render);
    ArrayClear(*g_point_lights_to_render);
}

RenderViewpoint :: (viewpoint : *ViewpointToRender) {
    AllocatorScope(Temp);

    mesh_buffer : MeshBuffer;

    for g_meshes_to_render {
        if !it.is_skinned {
            aabb := GetTransformedAABB(it.transform, it.static_bounds);
            if !AABBIsInFrustum(it.static_bounds, viewpoint.frustum) {
                continue;
            }
        }

        depth := TransformPoint(viewpoint.view, TranslationVector(it.transform)).z;
        key := MakeMeshBufferKey(it, depth);
        PushMesh(*mesh_buffer, key, it);
    }

    SortMeshBuffer(*mesh_buffer);
    AllocDrawData(*mesh_buffer);

    // DepthPrepass(viewpoint, *mesh_buffer);
    // PrepareClusters(viewpoint);
    // ForwardPass(viewpoint, *mesh_buffer);
    // SkyboxPass(viewpoint);

    // if !(viewpoint.flags & .NoDebugLines) {
    //     DebugLinesPass(viewpoint);
    // }

    // if !(viewpoint.flags & .NoGrids) {
    //     GridPass(viewpoint);
    // }

    // if !(viewpoint.flags & .NoGizmos) {
    //     GizmoPass(viewpoint);
    // }
}
