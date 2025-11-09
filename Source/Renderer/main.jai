#import "Vulkan";
#import "SDL";
#import "Thread";
#import "Remap_Context"(false);

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
#load "image_based_lighting.jai";
#load "skybox.jai";
#load "entity_selection.jai";
#load "forward_pass.jai";
#load "depth_prepass.jai";
#load "compositing.jai";
#load "bloom.jai";
#load "debug_draw.jai";
#load "infinite_grid.jai";
#load "gizmo.jai";

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

#if Reverse_Depth_Range {
    Depth_Compare_Op :: GfxCompareOp.GreaterEqual;
    Depth_Clear :: 0.0;
} else {
    Depth_Compare_Op :: GfxCompareOp.LessEqual;
    Depth_Clear :: 1.0;
}

g_viewpoint_render_targets : HashMap(u64, *ViewpointRenderTargets);
g_viewpoints_to_render : [..]ViewpointToRender;
g_worlds_to_render : [..]WorldToRender;

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

InitializeRenderer :: (global_init : bool) {
    Remap_Context();

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
    sampler_desc.anisotropy_enabled = true;
    sampler_desc.max_anisotropy = 8;

    g_material_texture_sampler = CreateGfxSampler("Material Texture", sampler_desc);
    Assert(!IsNull(*g_material_texture_sampler), "Could not create material texture sampler");

    sampler_desc = .{};
    sampler_desc.min_filter = .Linear;
    sampler_desc.mag_filter = .Linear;
    sampler_desc.mipmap_filter = .Linear;
    sampler_desc.u_address_mode = .Repeat;
    sampler_desc.v_address_mode = .ClampToEdge;

    g_skybox_sampler = CreateGfxSampler("Skybox", sampler_desc);
    Assert(!IsNull(*g_skybox_sampler), "Could not create skybox sampler");

    frame_layout_desc : GfxPipelineLayoutDesc;
    frame_layout_desc.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
    ];
    g_dummy_frame_pipeline_layout = CreateGfxPipelineLayout("Dummy Frame", frame_layout_desc);
    Assert(!IsNull(*g_dummy_frame_pipeline_layout), "Could not create dummy frame pipeline layout");

    CreateGlobalShadowMapObjects();

    LoadDefaultAssets();
}

ShutdownRenderer :: (global_shutdown : bool) {
    Remap_Context();

    WaitForRenderThread();
    StopRenderThread();
    WaitForGPUIdle();

    ClearGPUFrameProfiler(GetGPUFrameProfiler());

    DestroyGlobalShadowMapObjects();

    DestroyGfxSampler(*g_linear_clamp_sampler);
    DestroyGfxSampler(*g_nearest_clamp_sampler);
    DestroyGfxSampler(*g_material_texture_sampler);
    DestroyGfxSampler(*g_entity_guid_sampler);
    DestroyGfxSampler(*g_skybox_sampler);

    DestroyGfxTexture(*g_brdf_lut);

    for g_graphics_pipelines {
        DestroyGfxGraphicsPipeline(it);
    }
    ArrayFree(*g_graphics_pipelines);

    for g_compute_pipelines {
        DestroyGfxComputePipeline(it);
    }
    ArrayFree(*g_compute_pipelines);

    DestroyMaterialRenderPass(*g_forward_material_pass);
    DestroyMaterialRenderPass(*g_depth_only_material_pass);
    DestroyMaterialRenderPass(*g_shadow_map_material_pass);
    DestroyMaterialRenderPass(*g_point_shadow_map_material_pass);
    DestroyMaterialRenderPass(*g_entity_guid_material_pass);

    for * g_frame_data_allocators {
        DestroyFrameDataAllocator(it);
    }

    DestroyImGui();

    DestroyBindingSetAllocators();

    DestroyAllBindingSetLayouts();

    DestroyGfxPipelineLayout(*g_dummy_frame_pipeline_layout);

    DerefAsset(*g_default_base_color);
    DerefAsset(*g_default_normal_map);
    DerefAsset(*g_default_metallic_roughness_map);
    DerefAsset(*g_default_emissive);
    DerefAsset(*g_default_environment_map);
    DerefAsset(*g_default_material);

    ArrayFree(*g_worlds_to_render);
    ArrayFree(*g_viewpoints_to_render);

    for g_viewpoint_render_targets {
        DestroyViewpointRenderTargets(it);
        Free(it);
        remove it;
    }

    HashMapFree(*g_viewpoint_render_targets);

    for * g_unused_shadow_map_render_targets {
        DestroyGfxTexture(it);
    }
    ArrayFree(*g_unused_shadow_map_render_targets);

    for * g_used_shadow_map_render_targets {
        DestroyGfxTexture(it);
    }
    ArrayFree(*g_used_shadow_map_render_targets);

    for * g_unused_point_shadow_map_render_targets {
        DestroyPointShadowMapRenderTargets(it);
    }
    ArrayFree(*g_unused_point_shadow_map_render_targets);

    for * g_used_point_shadow_map_render_targets {
        DestroyPointShadowMapRenderTargets(it);
    }
    ArrayFree(*g_used_point_shadow_map_render_targets);

    DestroyRenderTargets();

    DestroyAllShaders();
}

g_should_recreate_render_targets : bool;

OnEvent :: (event : SDL_Event) {
    Remap_Context();

    if event.type == SDL_WINDOWEVENT {
        if event.window.event == SDL_WINDOWEVENT_RESIZED
        || event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED {
            g_should_recreate_render_targets = true;
        }
    }
}

RendererLoop :: () {
    Remap_Context();

    ProcessShaderDirectoryChanges();

    if !(SDL_GetWindowFlags(GetWindow()) & SDL_WINDOW_INPUT_FOCUS) {
        elapsed := GetDeltaTime();
        sleep_time := cast(s32, 1000 * (1 / 10.0 - elapsed));
        if sleep_time > 1 {
            Basic.sleep_milliseconds(sleep_time);
        }
    }
}

AddViewpointToRender :: (viewpoint : ViewpointToRender) {
    Remap_Context();

    ArrayPush(*g_viewpoints_to_render, viewpoint);
} @ModuleAPI

AddWorldToRender :: (world : WorldToRender) -> int {
    Remap_Context();

    ArrayPush(*g_worlds_to_render, world);

    return g_worlds_to_render.count - 1;
} @ModuleAPI

WaitForRenderThread :: () {
    Remap_Context();
} @ModuleAPI

SubmitFrameToRenderThread :: () {
    Remap_Context();

    imgui_draw_data := ImGui.GetDrawData();
    CopyImGuiDrawData(*g_imgui_draw_data, imgui_draw_data);

    if g_should_recreate_render_targets {
        RecreateRenderTargets();
        g_should_recreate_render_targets = false;
    }

    RenderFrame();
} @ModuleAPI

StopRenderThread :: () {
    Remap_Context();
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

GetNumComputeWorkGroupsForTexture :: (desc : GfxTextureAndViewDesc, mipmap_level : int, work_group_size : u32) -> x : u32, y : u32 {
    w, h := GetTextureMipSize(desc, mipmap_level);

    return (w  + work_group_size - 1) / work_group_size, (h + work_group_size - 1) / work_group_size;
}

FrameBindingSet :: struct {
    frame_info : GfxBindingUniformBuffer; @Binding(0) @VertexStage @FragmentStage @ComputeStage
    directional_lights : GfxBindingStorageBuffer; @Binding(1) @FragmentStage @AllowNull @ComputeStage
    point_lights : GfxBindingStorageBuffer; @Binding(2) @FragmentStage @AllowNull @ComputeStage
    brdf_lut : GfxBindingCombinedTextureSampler; @Binding(3) @FragmentStage
    shadow_map_noise : GfxBindingCombinedTextureSampler; @Binding(4) @FragmentStage
    shadow_maps : GfxBindingStorageBuffer; @Binding(5) @AllowNull @FragmentStage
    shadow_map_textures : [Max_Shadow_Maps]GfxBindingCombinedTextureSampler; @Binding(6) @AllowNull @FragmentStage
    point_shadow_maps : GfxBindingStorageBuffer; @Binding(7) @AllowNull @FragmentStage
    point_shadow_map_textures : [Max_Point_Shadow_Maps]GfxBindingCombinedTextureSampler; @Binding(8) @AllowNull @FragmentStage
} @BindingSet

EntityOutlineParams :: struct {
    thickness : float = 2; @ShowInInspector @FloatRange(1,5)
    covered_alpha : float = 0.4; @ShowInInspector @FloatRange(0,1)
    color : Vec4f = .{0.972, 1, 0.498, 1}; @ShowInInspector @ColorEdit
} @ShaderType

ShadowMapParams :: struct {
    noise_resolution : u32;
    depth_bias_min_max : Vec2f;
    normal_bias : float;
    filter_radius : float;
} @ShaderType

FrameInfo :: struct {
    time : float;
    num_directional_lights : u32;
    num_point_lights : u32;
    skybox_light_intensity := 1.0;
    shadow_map_params : ShadowMapParams;
    bloom_params : BloomParams;
    entity_outline_params : EntityOutlineParams;
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

    world : *WorldToRender;
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

    if IsNull(*g_brdf_lut) {
        GenerateBRDFLUT(*cmd_buffer);
    }

    TextureUploadPass(*cmd_buffer);
    GenerateEnvironmentMaps(*cmd_buffer);

    AddTextureBarrier(*cmd_buffer, .Undefined, .ColorAttachment, *g_final_texture);

    for * g_worlds_to_render {
        RenderWorld(*cmd_buffer, it);
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

    for * g_viewpoints_to_render {
        ArrayFree(*it.gizmo_widgets);
        ArrayFree(*it.gizmo_lines);
    }

    ArrayClear(*g_viewpoints_to_render);

    ArrayClear(*g_worlds_to_render);

    RecycleShadowMapRenderTargets();
    RecyclePointShadowMapRenderTargets();
}

RenderWorld :: (cmd_buffer : *GfxCommandBuffer, world : *WorldToRender) {
    BeginGfxDebugMarker(cmd_buffer, "RenderWorld");
    defer EndGfxDebugMarker(cmd_buffer);

    ProfileGPUZone(cmd_buffer, GetGPUFrameProfiler(), "RenderWorld");

    ctx : RenderContext;
    ctx.cmd_buffer = cmd_buffer;
    ctx.world = world;

    frame_info := FrameInfo.{
        time=xx Basic.to_float64_seconds(Basic.current_time_monotonic()),
        num_directional_lights=xx world.directional_lights.count,
        num_point_lights=xx world.point_lights.count,
        skybox_light_intensity=world.skybox_light_intensity,
        shadow_map_params=.{
            noise_resolution=Shadow_Map_Noise_Size,
            depth_bias_min_max=.{1, 5},
            normal_bias=10,
            filter_radius=1,
        },
        bloom_params=world.bloom_params,
    };
    frame_info_offset, frame_info_size := AllocAndPackUniformFrameData(frame_info);

    directional_lights := AllocArray(DirectionalLight, world.directional_lights.count ,, Temp);
    for world.directional_lights {
        directional_lights[it_index] = .{
            direction=it.direction,
            color=it.color,
            intensity=it.intensity,
            shadow_map_index=xx it.shadow_map_index,
        };
    }
    directional_lights_offset, directional_lights_size := AllocAndPackStorageFrameData(directional_lights);

    point_lights := AllocArray(PointLight, world.point_lights.count ,, Temp);
    for world.point_lights {
        point_lights[it_index] = .{
            position=it.position,
            color=it.color,
            intensity=it.intensity,
            intensity_radius=it.intensity_radius,
            source_radius=it.source_radius,
            shadow_map_index=xx it.shadow_map_index,
        };
    }

    point_lights_offset, point_lights_size := AllocAndPackStorageFrameData(point_lights);

    shadow_maps := AllocArray(ShadowMap, world.shadow_maps.count ,, Temp);
    for * world.shadow_maps {
        shadow_maps[it_index] = .{
            resolution=it.resolution,
            direction=it.direction,
        };

        for * size, level : shadow_maps[it_index].cascade_sizes {
            size.* = it.cascade_sizes[level];
        }

        for * viewpoint, level : shadow_maps[it_index].viewpoints {
            viewpoint.* = GetShadowMapViewpoint(it, level);
        }
    }

    shadow_maps_offset, shadow_maps_size := AllocAndPackStorageFrameData(shadow_maps);

    for world.shadow_maps {
        texture := GetShadowMapRenderTarget(it.resolution);
        ArrayPush(*world.shadow_map_render_targets, texture);
    }

    point_shadow_maps := AllocArray(PointShadowMap, world.point_shadow_maps.count ,, Temp);
    for * world.point_shadow_maps {
        point_shadow_maps[it_index] = .{
            resolution=it.resolution,
            position=it.position,
            z_near=it.z_near,
            z_far=it.z_far,
        };

        for * viewpoint, face : point_shadow_maps[it_index].viewpoints {
            viewpoint.* = GetPointShadowMapViewpoint(it, xx face);
        }
    }

    point_shadow_maps_offset, point_shadow_maps_size := AllocAndPackStorageFrameData(point_shadow_maps);

    for world.point_shadow_maps {
        render_targets := GetPointShadowMapRenderTarget(it.resolution);
        ArrayPush(*world.point_shadow_map_render_targets, render_targets);
    }

    frame_bindings := FrameBindingSet.{
        frame_info=.{buffer=FrameDataBuffer(), offset=xx frame_info_offset, size=xx frame_info_size},
        directional_lights=.{buffer=FrameDataBuffer(), offset=xx directional_lights_offset, size=xx directional_lights_size},
        point_lights=.{buffer=FrameDataBuffer(), offset=xx point_lights_offset, size=xx point_lights_size},
        brdf_lut=.{texture=*g_brdf_lut, sampler=*g_linear_clamp_sampler},
        shadow_map_noise=.{texture=*g_shadow_map_noise_texture, sampler=*g_shadow_map_noise_sampler},
        shadow_maps=.{buffer=FrameDataBuffer(), offset=xx shadow_maps_offset, size=xx shadow_maps_size},
        point_shadow_maps=.{buffer=FrameDataBuffer(), offset=xx point_shadow_maps_offset, size=xx point_shadow_maps_size},
    };

    for * world.shadow_map_render_targets {
        frame_bindings.shadow_map_textures[it_index] = .{texture=it, sampler=*g_shadow_map_sampler};
    }

    for * world.point_shadow_map_render_targets {
        frame_bindings.point_shadow_map_textures[it_index] = .{texture=*it.texture, sampler=*g_shadow_map_sampler};
    }

    ctx.frame_binding_set = CreateGfxBindingSet(GlobalBindingSetAllocator(), frame_bindings);

    BindGraphicsBindingSet(cmd_buffer, *g_dummy_frame_pipeline_layout, 0, *ctx.frame_binding_set);
    BindComputeBindingSet(cmd_buffer, *g_dummy_frame_pipeline_layout, 0, *ctx.frame_binding_set);

    for * world.shadow_maps {
        RenderShadowMap(*ctx, it, *world.shadow_map_render_targets[it_index]);
    }

    for * world.point_shadow_maps {
        RenderPointShadowMap(*ctx, it, *world.point_shadow_map_render_targets[it_index]);
    }

    for * g_viewpoints_to_render {
        if it.world_index != ArrayGetIndex(g_worlds_to_render, world) {
            continue;
        }

        RenderViewpoint(*ctx, it);
    }

    ArrayFree(*world.debug_renderer.lines);
    ArrayFree(*world.meshes);
    ArrayFree(*world.selected_meshes);
    ArrayFree(*world.directional_lights);
    ArrayFree(*world.point_lights);
    ArrayFree(*world.shadow_maps);
    ArrayFree(*world.shadow_map_render_targets);
    ArrayFree(*world.point_shadow_maps);
    ArrayFree(*world.point_shadow_map_render_targets);
}

DestroyViewpointRenderTargets :: (render_targets : *ViewpointRenderTargets) {
    WaitForGPUIdle();

    DestroyBloomTextures(*render_targets.bloom_textures);

    DestroyGfxTexture(*render_targets.final_color_texture);
    DestroyGfxTexture(*render_targets.hdr_color_texture);
    DestroyGfxTexture(*render_targets.depth_texture);
    DestroyGfxTexture(*render_targets.entity_guids_texture);
    DestroyGfxTexture(*render_targets.selected_entity_guids_texture);
    DestroyGfxTexture(*render_targets.gizmo_color_texture);
    DestroyGfxTexture(*render_targets.gizmo_color_resolve);
    DestroyGfxTexture(*render_targets.gizmo_depth_texture);

    for * render_targets.entity_guids_readback_buffers {
        DestroyGfxBuffer(it);
    }
}

GetViewpointRenderTargets :: (id : u64) -> *ViewpointRenderTargets {
    return HashMapGet(*g_viewpoint_render_targets, id);
} @ModuleAPI

CreateViewpointRenderTargets :: (id : u64, desired_resolution : Vec2u, bloom_params : BloomParams) -> *ViewpointRenderTargets {
    ShouldRecreate :: inline (texture : *GfxTexture, desired_resolution : Vec2u) -> bool {
        return IsNull(texture) || texture.desc.width != desired_resolution.x || texture.desc.height != desired_resolution.y;
    }

    if desired_resolution.x == 0 || desired_resolution.y == 0 {
        return null;
    }

    ptr := HashMapInsert(*g_viewpoint_render_targets, id);
    if !ptr.* {
        ptr.* = Alloc(ViewpointRenderTargets);
    }

    using rt := ptr.*;

    CreateBloomTextures(*bloom_textures, desired_resolution, bloom_params);

    if ShouldRecreate(*final_color_texture, desired_resolution) {
        if !IsNull(*final_color_texture) {
            WaitForGPUIdle();
            DestroyGfxTexture(*final_color_texture);
        }

        desc : GfxTextureDesc;
        desc.type = .Texture2D;
        desc.pixel_format = .RGBA8UNorm;
        desc.width = desired_resolution.x;
        desc.height = desired_resolution.y;
        desc.usage = .ColorAttachment | .Sampled;

        final_color_texture = CreateGfxTexture(TPrint("Viewpoint %, Final Color", id), desc);
        Assert(!IsNull(*final_color_texture), "Could not create viewpoint render target with resolution=%", desired_resolution);
    }

    if ShouldRecreate(*hdr_color_texture, desired_resolution) {
        if !IsNull(*hdr_color_texture) {
            WaitForGPUIdle();
            DestroyGfxTexture(*hdr_color_texture);
        }

        desc : GfxTextureDesc;
        desc.type = .Texture2D;
        desc.pixel_format = .RGBA16Float;
        desc.width = desired_resolution.x;
        desc.height = desired_resolution.y;
        desc.usage = .ColorAttachment | .Sampled;

        hdr_color_texture = CreateGfxTexture(TPrint("Viewpoint %, HDR Color", id), desc);
        Assert(!IsNull(*hdr_color_texture), "Could not create viewpoint render target with resolution=%", desired_resolution);
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

    if ShouldRecreate(*gizmo_color_texture, desired_resolution) {
        if !IsNull(*gizmo_color_texture) {
            WaitForGPUIdle();
            DestroyGfxTexture(*gizmo_color_texture);
        }

        desc : GfxTextureDesc;
        desc.type = .Texture2D;
        desc.pixel_format = .RGBA8UNorm;
        desc.width = desired_resolution.x;
        desc.height = desired_resolution.y;
        desc.usage = .ColorAttachment;
        desc.num_samples = Gizmo_Texture_Num_Samples;

        gizmo_color_texture = CreateGfxTexture(TPrint("Viewpoint %, Gizmo Color MS", id), desc);
        Assert(!IsNull(*gizmo_color_texture), "Could not create viewpoint render target with resolution=%", desired_resolution);
    }

    if ShouldRecreate(*gizmo_color_resolve, desired_resolution) {
        if !IsNull(*gizmo_color_resolve) {
            WaitForGPUIdle();
            DestroyGfxTexture(*gizmo_color_resolve);
        }

        desc : GfxTextureDesc;
        desc.type = .Texture2D;
        desc.pixel_format = .RGBA8UNorm;
        desc.width = desired_resolution.x;
        desc.height = desired_resolution.y;
        desc.usage = .ColorAttachment | .Sampled;

        gizmo_color_resolve = CreateGfxTexture(TPrint("Viewpoint %, Gizmo Color", id), desc);
        Assert(!IsNull(*gizmo_color_resolve), "Could not create viewpoint render target with resolution=%", desired_resolution);
    }

    if ShouldRecreate(*gizmo_depth_texture, desired_resolution) {
        if !IsNull(*gizmo_depth_texture) {
            WaitForGPUIdle();
            DestroyGfxTexture(*gizmo_depth_texture);
        }

        desc : GfxTextureDesc;
        desc.type = .Texture2D;
        desc.pixel_format = .Depth32Float;
        desc.width = desired_resolution.x;
        desc.height = desired_resolution.y;
        desc.usage = .DepthStencilAttachment;
        desc.num_samples = Gizmo_Texture_Num_Samples;

        gizmo_depth_texture = CreateGfxTexture(TPrint("Viewpoint %, Gizmo Depth MS", id), desc);
        Assert(!IsNull(*gizmo_depth_texture), "Could not create viewpoint render target with resolution=%", desired_resolution);
    }

    return rt;
} @ModuleAPI

RenderViewpoint :: (ctx : *RenderContext, viewpoint : *ViewpointToRender) {
    BeginGfxDebugMarker(ctx.cmd_buffer, "RenderViewpoint");
    defer EndGfxDebugMarker(ctx.cmd_buffer);

    ProfileGPUZone(ctx.cmd_buffer, GetGPUFrameProfiler(), "RenderViewpoint");

    prev_ctx := ctx.*;
    defer ctx.* = prev_ctx;

    billboard_rotation := Mat4fFromRightUpForwardOrigin(-viewpoint.right, viewpoint.up, -viewpoint.direction, .{});
    ctx.viewpoint = viewpoint;
    ctx.render_targets = CreateViewpointRenderTargets(viewpoint.unique_id, viewpoint.resolution, ctx.world.bloom_params);

    if !ctx.render_targets {
        return;
    }

    mesh_buffer : MeshBuffer;
    mesh_buffer.meshes.allocator = Temp;
    mesh_buffer.draw_calls.allocator = Temp;

    selected_mesh_buffer : MeshBuffer;
    selected_mesh_buffer.meshes.allocator = Temp;
    selected_mesh_buffer.draw_calls.allocator = Temp;

    for ctx.world.meshes {
        mesh := it;

        if mesh.is_billboard {
            mesh.transform *= billboard_rotation;
        }

        if !mesh.is_skinned {
            aabb := GetTransformedAABB(mesh.transform, mesh.static_bounds);
            if !AABBIsInFrustum(aabb, viewpoint.frustum) {
                continue;
            }
        }

        depth := TransformPoint(viewpoint.view, TranslationVector(mesh.transform)).z;
        key := MakeMeshBufferKey(mesh, depth);

        PushMesh(*mesh_buffer, key, mesh);
    }

    for ctx.world.selected_meshes {
        mesh := it;

        if mesh.is_billboard {
            mesh.transform *= billboard_rotation;
        }

        if !mesh.is_skinned {
            aabb := GetTransformedAABB(mesh.transform, mesh.static_bounds);
            if !AABBIsInFrustum(aabb, viewpoint.frustum) {
                continue;
            }
        }

        depth := TransformPoint(viewpoint.view, TranslationVector(mesh.transform)).z;
        key := MakeMeshBufferKey(mesh, depth);

        PushMesh(*selected_mesh_buffer, key, mesh);
    }

    SortMeshBuffer(*mesh_buffer);
    AllocDrawData(*mesh_buffer);

    SortMeshBuffer(*selected_mesh_buffer);
    AllocDrawData(*selected_mesh_buffer);

    AddTextureBarriers(ctx.cmd_buffer, .Undefined, .ColorAttachment, .[
        *ctx.render_targets.final_color_texture,
        *ctx.render_targets.hdr_color_texture,
        *ctx.render_targets.entity_guids_texture,
        *ctx.render_targets.selected_entity_guids_texture
    ]);
    AddTextureBarrier(ctx.cmd_buffer, .Undefined, .DepthStencilAttachment, *ctx.render_targets.depth_texture);

    if !(viewpoint.flags & .NoEntitySelection) {
        RenderEntitySelection(ctx, *mesh_buffer, *selected_mesh_buffer);
    }

    PrepareClusters(ctx);
    DepthPrepass(ctx, *mesh_buffer);
    ForwardPass(ctx, *mesh_buffer);
    SkyboxPass(ctx, ifx ctx.world.skybox && ctx.world.skybox.base_texture then *ctx.world.skybox.base_texture.texture);

    if !(viewpoint.flags & .NoDebugLines) {
        DebugLinesPass(ctx);
    }

    if !(viewpoint.flags & .NoGrids) {
        InfiniteGridPass(ctx);
    }

    if !(viewpoint.flags & .NoGizmos) {
        GizmoPass(ctx);
    }

    AddTextureBarriers(ctx.cmd_buffer, .ColorAttachment, .ShaderReadOnly, .[
        *ctx.render_targets.selected_entity_guids_texture,
        *ctx.render_targets.hdr_color_texture
    ]);

    ComputeBloom(ctx);

    CompositingPass(ctx);

    AddTextureBarrier(ctx.cmd_buffer, .ColorAttachment, .ShaderReadOnly, *ctx.render_targets.final_color_texture);
}
