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
#load "lights.jai";
#load "shadow_map.jai";
#load "point_shadow_map.jai";

#load "entity_selection.jai";
#load "forward_pass.jai";

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

#if Reverse_Depth_Range {
    Depth_Compare_Op :: GfxCompareOp.GreaterEqual;
    Depth_Clear :: 0.0;
} else {
    Depth_Compare_Op :: GfxCompareOp.LessEqual;
    Depth_Clear :: 1.0;
}

g_viewpoint_render_targets : HashMap(u64, *ViewpointRenderTargets);
g_viewpoints_to_render : [..]ViewpointToRender;
g_meshes_to_render : [..]MeshToRender;
g_selected_meshes_to_render : [..]MeshToRender;
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

    if !LoadAllShaders() {
        Basic.exit(1);
    }

    RecreateRenderTargets();

    CreateAllBindingSetLayouts();

    InitFrameDataAllocators();
    InitBindingSetAllocators();

    InitImGui();

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
    WaitForGPUIdle();

    DestroyGPUFrameProfiler(GetGPUFrameProfiler());

    DestroyGfxPipelineLayout(*g_dummy_frame_pipeline_layout);

    DestroyGfxSampler(*g_linear_clamp_sampler);
    DestroyGfxSampler(*g_nearest_clamp_sampler);
    DestroyGfxSampler(*g_material_texture_sampler);

    for * g_frame_data_allocators {
        DestroyFrameDataAllocator(it);
    }

    DestroyImGui();

    DestroyBindingSetAllocators();

    DestroyAllBindingSetLayouts();

    for g_viewpoint_render_targets {
        DestroyViewpointRenderTargets(it);
        Free(it);
        remove it;
    }

    HashMapFree(*g_viewpoint_render_targets);

    DestroyRenderTargets();

    DestroyAllShaders();
}

g_should_recreate_render_targets : bool;

OnEvent :: (event : SDL_Event) {
    push_context,defer_pop g_context;

    if event.type == SDL_WINDOWEVENT {
        if event.window.event == SDL_WINDOWEVENT_RESIZED
        || event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED {
            g_should_recreate_render_targets = true;
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

AddSelectedMeshToRender :: (mesh : MeshToRender) {
    push_context,defer_pop g_context;

    ArrayPush(*g_selected_meshes_to_render, mesh);
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
} @ModuleAPI

SubmitFrameToRenderThread :: () {
    push_context,defer_pop g_context;

    imgui_draw_data := ImGui.GetDrawData();
    CopyImGuiDrawData(*g_imgui_draw_data, imgui_draw_data);

    if g_should_recreate_render_targets {
        RecreateRenderTargets();
        g_should_recreate_render_targets = false;
    }

    RenderFrame();
} @ModuleAPI

StopRenderThread :: () {
    push_context,defer_pop g_context;
} @ModuleAPI

DestroyRenderTargets :: () {
    DestroyGfxTexture(*g_final_texture);
}

RecreateRenderTargets :: () {
    WaitForGPUIdle();

    DestroyRenderTargets();

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
    frame_info : GfxBindingUniformBuffer; @Binding(0) @VertexStage @FragmentStage @ComputeStage
    directional_lights : GfxBindingStorageBuffer; @Binding(1) @FragmentStage @AllowNull @ComputeStage
    point_lights : GfxBindingStorageBuffer; @Binding(2) @FragmentStage @AllowNull @ComputeStage
    // brdf_lut : GfxBindingCombinedTextureSampler; @Binding(3) @FragmentStage
    // shadow_map_noise : GfxBindingCombinedTextureSampler; @Binding(4) @FragmentStage
} @BindingSet

FrameInfo :: struct {
    time : float;
    window_pixel_size : Vec2f;
    num_directional_lights : u32;
    num_point_lights : u32;
    skybox_light_intensity := 1.0;
    // shadow_map_params : ShadowMapParams;
    // bloom_params : BloomParams;
    // editor_settings : EditorSettings;
} @ShaderType

using _ :: struct {
    Max_Viewpoints :: 6;
} @ShaderType

Viewpoint :: struct {
    position : Vec3f;
    direction : Vec3f;
    right : Vec3f;
    up : Vec3f;
    transform : Mat4f;
    view : Mat4f;
    projection : Mat4f;
    inv_projection : Mat4f;
    view_projection : Mat4f;
    inv_view_projection : Mat4f;
    viewport_size : Vec2f;
    fov : float;
    z_near : float;
    z_far : float;
} @ShaderType

MakeViewpoint :: inline (viewpoint : ViewpointToRender) -> Viewpoint {
    return .{
        position=viewpoint.position,
        direction=viewpoint.direction,
        right=viewpoint.right,
        up=viewpoint.up,
        transform=viewpoint.transform,
        view=viewpoint.view,
        projection=viewpoint.projection,
        inv_projection=viewpoint.inv_projection,
        view_projection=viewpoint.view_projection,
        inv_view_projection=viewpoint.inv_view_projection,
        viewport_size=.{xx viewpoint.resolution.x, xx viewpoint.resolution.y},
        fov=viewpoint.fov,
        z_near=viewpoint.z_near,
        z_far=viewpoint.z_far,
    };
}

ViewpointsData :: struct {
    num_viewpoints : u32 = 1;
    viewpoints : [Max_Viewpoints]Viewpoint;
} @ShaderType

RenderContext :: struct {
    cmd_buffer : *GfxCommandBuffer;

    viewpoint : *ViewpointToRender;
    render_targets : *ViewpointRenderTargets;

    frame_binding_set : GfxBindingSet;
    directional_lights : []DirectionalLight;
    point_lights : []PointLight;
    clusters_offset : u32;
    clusters_size : u32;
}

RenderFrame :: () {
    BeginGfxFrame();

    ProfilerBeginFrame(GetGPUFrameProfiler());

    ResetFrameDataAllocator();
    ResetBindingSetAllocators();

    cmd_buffer := CreateGfxCommandBuffer("Main");

    ctx : RenderContext;
    ctx.cmd_buffer = *cmd_buffer;

    w, h := GetWindowPixelSize(GetWindow());
    frame_info := FrameInfo.{
        time=xx Basic.to_float64_seconds(Basic.current_time_monotonic()),
        window_pixel_size=.{xx w, xx h},
        num_directional_lights=xx g_directional_lights_to_render.count,
        num_point_lights=xx g_point_lights_to_render.count,
    };
    frame_info_offset, frame_info_size := AllocAndPackUniformFrameData(frame_info);

    directional_lights := AllocArray(DirectionalLight, g_directional_lights_to_render.count ,, Temp);
    for g_directional_lights_to_render {
        directional_lights[it_index] = .{
            direction=it.direction,
            color=it.color,
            intensity=it.intensity,
        };
    }
    directional_lights_offset, directional_lights_size := AllocAndPackStorageFrameData(directional_lights);

    point_lights := AllocArray(PointLight, g_point_lights_to_render.count ,, Temp);
    for g_point_lights_to_render {
        point_lights[it_index] = .{
            position=it.position,
            color=it.color,
            intensity=it.intensity,
            intensity_radius=it.intensity_radius,
            source_radius=it.source_radius,
        };
    }

    point_lights_offset, point_lights_size := AllocAndPackStorageFrameData(point_lights);

    frame_bindings := FrameBindingSet.{
        frame_info=.{buffer=FrameDataBuffer(), offset=xx frame_info_offset, size=xx frame_info_size},
        directional_lights=.{buffer=FrameDataBuffer(), offset=xx directional_lights_offset, size=xx directional_lights_size},
        point_lights=.{buffer=FrameDataBuffer(), offset=xx point_lights_offset, size=xx point_lights_size},
    };
    ctx.frame_binding_set = CreateGfxBindingSet(GlobalBindingSetAllocator(), frame_bindings);

    BindGraphicsBindingSet(*cmd_buffer, *g_dummy_frame_pipeline_layout, 0, *ctx.frame_binding_set);
    BindComputeBindingSet(*cmd_buffer, *g_dummy_frame_pipeline_layout, 0, *ctx.frame_binding_set);

    TextureUploadPass(*cmd_buffer);
    // GenerateEnvironmentMaps(*cmd_buffer);

    AddTextureBarrier(*cmd_buffer, .Undefined, .ColorAttachment, *g_final_texture);

    for * g_viewpoints_to_render {
        RenderViewpoint(*ctx, it);
    }

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
    ArrayClear(*g_selected_meshes_to_render);
    ArrayClear(*g_directional_lights_to_render);
    ArrayClear(*g_point_lights_to_render);
}

DestroyViewpointRenderTargets :: (render_targets : *ViewpointRenderTargets) {
    WaitForGPUIdle();

    DestroyGfxTexture(*render_targets.color_texture);
    DestroyGfxTexture(*render_targets.depth_texture);
    DestroyGfxTexture(*render_targets.entity_guids_texture);
    DestroyGfxTexture(*render_targets.selected_entity_guids_texture);

    for * render_targets.entity_guids_readback_buffers {
        DestroyGfxBuffer(it);
    }
}

GetViewpointRenderTargets :: (id : u64, desired_resolution : Vec2u) -> *ViewpointRenderTargets {
    ShouldRecreate :: inline (texture : *GfxTexture, desired_resolution : Vec2u) -> bool {
        return IsNull(texture) || texture.desc.width != desired_resolution.x || texture.desc.height != desired_resolution.y;
    }

    ptr := HashMapInsert(*g_viewpoint_render_targets, id);
    if !ptr.* {
        ptr.* = Alloc(ViewpointRenderTargets);
    }

    using rt := ptr.*;

    if ShouldRecreate(*color_texture, desired_resolution) {
        if !IsNull(*color_texture) {
            WaitForGPUIdle();
            DestroyGfxTexture(*color_texture);
        }

        desc : GfxTextureDesc;
        desc.type = .Texture2D;
        desc.pixel_format = .RGBA16Float;
        desc.width = desired_resolution.x;
        desc.height = desired_resolution.y;
        desc.usage = .ColorAttachment | .Sampled;

        color_texture = CreateGfxTexture(TPrint("Viewpoint %, Color", id), desc);
        Assert(!IsNull(*color_texture), "Could not create viewpoint render target with resolution=%", desired_resolution);
    }

    if ShouldRecreate(*depth_texture, desired_resolution) {
        if !IsNull(*depth_texture) {
            WaitForGPUIdle();
            DestroyGfxTexture(*depth_texture);
        }

        desc : GfxTextureDesc;
        desc.type = .Texture2D;
        desc.pixel_format = .Depth32Float;
        desc.width = desired_resolution.x;
        desc.height = desired_resolution.y;
        desc.usage = .DepthStencilAttachment;

        depth_texture = CreateGfxTexture(TPrint("Viewpoint %, Depth", id), desc);
        Assert(!IsNull(*depth_texture), "Could not create viewpoint render target with resolution=%", desired_resolution);
    }

    if ShouldRecreate(*entity_guids_texture, desired_resolution) {
        if !IsNull(*entity_guids_texture) {
            WaitForGPUIdle();
            DestroyGfxTexture(*entity_guids_texture);
        }

        desc : GfxTextureDesc;
        desc.type = .Texture2D;
        desc.pixel_format = .RGBA32UInt;
        desc.width = desired_resolution.x;
        desc.height = desired_resolution.y;
        desc.usage = .ColorAttachment | .Sampled | .TransferSrc;

        entity_guids_texture = CreateGfxTexture(TPrint("Viewpoint %, Entity GUIDs", id), desc);
        Assert(!IsNull(*entity_guids_texture), "Could not create viewpoint render target with resolution=%", desired_resolution);
    }

    if ShouldRecreate(*selected_entity_guids_texture, desired_resolution) {
        if !IsNull(*selected_entity_guids_texture) {
            WaitForGPUIdle();
            DestroyGfxTexture(*selected_entity_guids_texture);
        }

        desc : GfxTextureDesc;
        desc.type = .Texture2D;
        desc.pixel_format = .RGBA32UInt;
        desc.width = desired_resolution.x;
        desc.height = desired_resolution.y;
        desc.usage = .ColorAttachment | .Sampled;

        selected_entity_guids_texture = CreateGfxTexture(TPrint("Viewpoint %, Selected Entity GUIDs", id), desc);
        Assert(!IsNull(*selected_entity_guids_texture), "Could not create viewpoint render target with resolution=%", desired_resolution);
    }

    return rt;
} @ModuleAPI

RenderViewpoint :: (ctx : *RenderContext, viewpoint : *ViewpointToRender) {
    prev_ctx := ctx.*;
    defer ctx.* = prev_ctx;

    ctx.viewpoint = viewpoint;
    ctx.render_targets = GetViewpointRenderTargets(viewpoint.unique_id, viewpoint.resolution);

    mesh_buffer : MeshBuffer;
    mesh_buffer.meshes.allocator = Temp;
    mesh_buffer.draw_calls.allocator = Temp;

    selected_mesh_buffer : MeshBuffer;
    selected_mesh_buffer.meshes.allocator = Temp;
    selected_mesh_buffer.draw_calls.allocator = Temp;

    for g_meshes_to_render {
        if !it.is_skinned {
            aabb := GetTransformedAABB(it.transform, it.static_bounds);
            if !AABBIsInFrustum(aabb, viewpoint.frustum) {
                continue;
            }
        }

        depth := TransformPoint(viewpoint.view, TranslationVector(it.transform)).z;
        key := MakeMeshBufferKey(it, depth);
        PushMesh(*mesh_buffer, key, it);
    }

    for g_selected_meshes_to_render {
        if !it.is_skinned {
            aabb := GetTransformedAABB(it.transform, it.static_bounds);
            if !AABBIsInFrustum(aabb, viewpoint.frustum) {
                continue;
            }
        }

        depth := TransformPoint(viewpoint.view, TranslationVector(it.transform)).z;
        key := MakeMeshBufferKey(it, depth);
        PushMesh(*selected_mesh_buffer, key, it);
    }

    SortMeshBuffer(*mesh_buffer);
    AllocDrawData(*mesh_buffer);

    SortMeshBuffer(*selected_mesh_buffer);
    AllocDrawData(*selected_mesh_buffer);

    AddTextureBarriers(ctx.cmd_buffer, .Undefined, .ColorAttachment, .[
        *ctx.render_targets.color_texture,
        *ctx.render_targets.entity_guids_texture,
        *ctx.render_targets.selected_entity_guids_texture
    ]);
    AddTextureBarrier(ctx.cmd_buffer, .Undefined, .DepthStencilAttachment, *ctx.render_targets.depth_texture);

    if !(viewpoint.flags & .NoEntitySelection) {
        EntityGUIDsPass(ctx, *ctx.render_targets.entity_guids_texture, *ctx.render_targets.depth_texture, *mesh_buffer);
        EntityGUIDsPass(ctx, *ctx.render_targets.selected_entity_guids_texture, *ctx.render_targets.depth_texture, *selected_mesh_buffer);

        AddTextureBarrier(ctx.cmd_buffer, .ColorAttachment, .TransferSrc, *ctx.render_targets.entity_guids_texture);
        TransferEntityGUIDsForReadback(ctx);
    }

    // DepthPrepass(ctx, *mesh_buffer);
    PrepareClusters(ctx);
    ForwardPass(ctx, *mesh_buffer);
    // SkyboxPass(ctx);

    // if !(viewpoint.flags & .NoDebugLines) {
    //     DebugLinesPass(ctx);
    // }

    // if !(viewpoint.flags & .NoGrids) {
    //     GridPass(ctx);
    // }

    // if !(viewpoint.flags & .NoGizmos) {
    //     GizmoPass(ctx);
    // }

    AddTextureBarrier(ctx.cmd_buffer, .ColorAttachment, .ShaderReadOnly, *ctx.render_targets.color_texture);
}
