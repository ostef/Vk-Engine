LoadEnvironmentMapFromMemory :: (map : *EnvironmentMap, data : []u8, name : string) -> bool {
    map.base_texture = LoadAsset(Texture2D, name);
    if !map.base_texture {
        return false;
    }

    aspect_ratio := map.base_texture.height / cast(float, map.base_texture.width);

    desc : GfxTextureDesc;
    desc.type = .Texture2D;
    desc.pixel_format = .RGBA16Float;
    desc.usage = .Sampled | .ColorAttachment;
    desc.width = GetCVarUInt("irradiance_map_resolution", 64);
    desc.height = cast(u32, desc.width * aspect_ratio);

    map.irradiance_map = CreateGfxTexture(TPrint("% irradiance", name), desc);
    if IsNull(*map.irradiance_map) {
        DerefAsset(*map.base_texture);
        return false;
    }

    desc.width = GetCVarUInt("environment_map_resolution", 1024);
    desc.height = cast(u32, desc.width * aspect_ratio);
    desc.num_mipmap_levels = Num_Environment_Map_Levels;
    desc.usage = .Sampled | .ColorAttachment | .TransferSrc | .TransferDst;

    map.environment_map = CreateGfxTexture(TPrint("% environment", name), desc);
    if IsNull(*map.environment_map) {
        DerefAsset(*map.base_texture);
        DestroyGfxTexture(*map.irradiance_map);

        return false;
    }

    for i : 0..Num_Environment_Map_Levels - 1 {
        view_desc : GfxTextureViewDesc;
        view_desc.type = desc.type;
        view_desc.pixel_format = desc.pixel_format;
        view_desc.first_mipmap_level = xx i;

        map.environment_levels[i] = CreateGfxTextureView(TPrint("% environment %", name, i), view_desc, *map.environment_map);
        if IsNull(*map.environment_map) {
            DerefAsset(*map.base_texture);
            DestroyGfxTexture(*map.irradiance_map);
            for j : 0..i - 1 {
                DestroyGfxTextureView(*map.environment_levels[j]);
            }
            DestroyGfxTexture(*map.environment_map);

            return false;
        }
    }

    ArrayPush(*g_environment_maps_to_generate, map);

    return true;
}

DestroyEnvironmentMap :: (map : *EnvironmentMap) {
    for g_environment_maps_to_generate {
        if it == map {
            remove it;
        }
    }

    DerefAsset(*map.base_texture);

    for * map.environment_levels {
        QueueDestroyGfxTextureView(it);
    }

    QueueDestroyGfxTexture(*map.environment_map);

    QueueDestroyGfxTexture(*map.irradiance_map);

    map.* = .{};
}

g_environment_maps_to_generate : [..]*EnvironmentMap;

g_irradiance_map_pipeline : GfxGraphicsPipeline;
g_environment_map_pipeline : GfxGraphicsPipeline;

EnvironmentMapBindingSet :: struct {
    texture : GfxBindingCombinedTextureSampler; @Binding(0) @FragmentStage
} @BindingSet

CreateIrradianceMapPipeline :: () {
    desc : GfxGraphicsPipelineDesc;
    desc.vertex_shader = GetVertexShader("screen_effect");
    desc.fragment_shader = GetFragmentShader("irradiance_map");
    AddColorAttachment(*desc, .RGBA16Float);

    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.EnvironmentMapBindingSet,
    ];

    ok := CreateGfxGraphicsPipeline(*g_irradiance_map_pipeline, "Irradiance Map", desc);
    Assert(ok, "Could not create irradiance map pipeline");
}

CreateEnvironmentMapPipeline :: () {
    desc : GfxGraphicsPipelineDesc;
    desc.vertex_shader = GetVertexShader("environment_map");
    desc.fragment_shader = GetFragmentShader("environment_map");
    AddColorAttachment(*desc, .RGBA16Float);

    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.EnvironmentMapBindingSet,
    ];

    ok := CreateGfxGraphicsPipeline(*g_environment_map_pipeline, "Environment Map", desc);
    Assert(ok, "Could not create environment map pipeline");
}

GenerateEnvironmentMaps :: (cmd_buffer : *GfxCommandBuffer) {
    defer ArrayClear(*g_environment_maps_to_generate);

    if g_environment_maps_to_generate.count <= 0 {
        return;
    }

    if IsNull(*g_environment_map_pipeline) {
        CreateEnvironmentMapPipeline();
    }

    if IsNull(*g_irradiance_map_pipeline) {
        CreateIrradianceMapPipeline();
    }

    BeginGfxDebugMarker(cmd_buffer, "Generate Environment Maps");
    defer EndGfxDebugMarker(cmd_buffer);

    for g_environment_maps_to_generate {
        bindings := EnvironmentMapBindingSet.{
            texture=.{texture=it.base_texture, sampler=*g_skybox_sampler},
        };
        binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), bindings);

        AddTextureBarriers(cmd_buffer, .Undefined, .ColorAttachment, .[*it.irradiance_map, *it.environment_map]);

        pass_desc : GfxRenderPassDesc;
        AddColorAttachment(*pass_desc, *it.irradiance_map, load_op=.DontCare);

        pass := BeginGfxRenderPass(cmd_buffer, "Generate Irradiance Map", pass_desc);
        {
            BindGraphicsPipeline(*pass, *g_irradiance_map_pipeline);
            SetViewport(*pass, .{width=xx it.irradiance_map.desc.width, height=xx it.irradiance_map.desc.height});
            SetScissor(*pass, .{w=xx it.irradiance_map.desc.width, h=xx it.irradiance_map.desc.height});

            BindGraphicsBindingSet(*pass, 1, *binding_set);

            Draw(*pass, vertex_count=6, instance_count=1);
        }
        EndGfxRenderPass(*pass);

        w := it.environment_map.desc.width;
        h := it.environment_map.desc.height;
        for level : 0..Num_Environment_Map_Levels - 1 {
            pass_desc : GfxRenderPassDesc;
            AddColorAttachment(*pass_desc, *it.environment_levels[level], load_op=.DontCare);

            pass := BeginGfxRenderPass(cmd_buffer, TPrint("Generate Environment Map %", level), pass_desc);
            {
                BindGraphicsPipeline(*pass, *g_environment_map_pipeline);
                SetViewport(*pass, .{width=xx w, height=xx h});
                SetScissor(*pass, .{w=xx w, h=xx h});

                Draw(*pass, vertex_count=6, instance_count=1, base_instance=xx level);
            }
            EndGfxRenderPass(*pass);

            w /= 2;
            h /= 2;
        }

        AddTextureBarriers(cmd_buffer, .ColorAttachment, .ShaderReadOnly, .[*it.irradiance_map, *it.environment_map]);
    }
}

g_brdf_lut : GfxTexture;
g_brdf_lut_compute_pipeline : GfxComputePipeline;

BRDF_LUT_Resolution : u32 : 512;

using _ :: struct {
    BRDF_LUT_Compute_Work_Group_Size :: 16;
} @ShaderType

BRDFLUTBindingSet :: struct {
    dst_image : GfxBindingStorageImage; @Binding(0) @ComputeStage
} @BindingSet

RenderBRDFLUT :: (cmd_buffer : *GfxCommandBuffer) {
    texture_desc : GfxTextureDesc;
    texture_desc.type = .Texture2D;
    texture_desc.pixel_format = .RGBA16Float;
    texture_desc.width = BRDF_LUT_Resolution;
    texture_desc.height = BRDF_LUT_Resolution;
    texture_desc.usage = .Storage | .Sampled;

    g_brdf_lut = CreateGfxTexture("BRDF LUT", texture_desc);
    Assert(!IsNull(*g_brdf_lut), "Could not create BRDF LUT texture");

    pipeline_desc : GfxComputePipelineDesc;
    pipeline_desc.shader = GetComputeShader("brdf_lut");
    pipeline_desc.layout.binding_sets = .[
        g_binding_set_layouts.BRDFLUTBindingSet,
    ];

    g_brdf_lut_compute_pipeline = CreateGfxComputePipeline("BRDF LUT", pipeline_desc);
    Assert(!IsNull(*g_brdf_lut_compute_pipeline), "Could not create BRDF LUT pipeline");

    AddTextureBarrier(cmd_buffer, .Undefined, .General, *g_brdf_lut);

    pass := BeginGfxComputePass(cmd_buffer, "BRDF LUT");
    {
        BindComputePipeline(*pass, *g_brdf_lut_compute_pipeline);

        bindings := BRDFLUTBindingSet.{
            dst_image=.{*g_brdf_lut},
        };
        binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), bindings);
        BindComputeBindingSet(*pass, 0, *binding_set);

        num_groups_x, num_groups_y := GetNumComputeWorkGroupsForTexture(g_brdf_lut.desc, 0, BRDF_LUT_Compute_Work_Group_Size);

        Dispatch(*pass, num_groups_x, num_groups_y, num_groups_z=1);
    }
    EndGfxComputePass(*pass);

    AddTextureBarrier(cmd_buffer, .General, .ShaderReadOnly, *g_brdf_lut);
}
