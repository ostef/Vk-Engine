// How does bloom work:
// 1- render the image onto a lower resolution image, filter the pixels so that
// dark areas don't contribute much and bright areas contribute a lot
// 2- downsample the image using a filter from mipmap level N to N+1, until the last mipmap level
// 3- progressively upsample the result and add the downsample of the same resolution
// The more downsample iterations there are the brighter the result is, so we divide the blend intensity by the number of
// iterations to keep consistent results

// See: Kawase blur filter

BloomParams :: struct {
    resolution_factor := Bloom_Resolution_Factor;
    brightness_threshold := 1.4; @ShowInInspector @FloatRange(0,10) @Step(0.01)
    brightness_soft_threshold := 0.5; @ShowInInspector @FloatRange(0,1) @Step(0.01)
    blend_intensity := 0.5; @ShowInInspector @FloatRange(0,10) @Step(0.01)
    filter_radius := 1.0; @ShowInInspector @FloatRange(0,10) @Step(0.01)
} @ShaderType

g_bloom_params : BloomParams;

CreateBloomTextures :: (using bloom : *BloomTextures, desired_resolution : Vec2u) {
    ShouldRecreate :: inline (texture : *GfxTexture, desired_resolution : Vec2u) -> bool {
        return IsNull(texture) || texture.desc.width != desired_resolution.x || texture.desc.height != desired_resolution.y;
    }

    resolution := desired_resolution * g_bloom_params.resolution_factor;
    resolution.x = Max(resolution.x, 1);
    resolution.y = Max(resolution.y, 1);

    if ShouldRecreate(*downsample_texture, resolution) {
        if !IsNull(*downsample_texture) {
            WaitForGPUIdle();
            DestroyBloomTextures(bloom);
        }

        num_downsample_passes := GetNumMipmapLevelsForTextureSize(resolution.x, resolution.y);
        num_downsample_passes = Min(num_downsample_passes, Bloom_Max_Downsample_Passes + 1);

        // Special case for very small resolution: we cannot create more than one downsample texture so kawase
        // blur cannot be done. We'll create only one texture and compute the bloom using a different method
        if num_downsample_passes <= 1 {
            desc : GfxTextureDesc;
            desc.type = .Texture2D;
            desc.width = resolution.x;
            desc.height = resolution.y;
            desc.pixel_format = .RGBA16Float;
            desc.usage = .Sampled | .Storage;

            downsample_texture = CreateGfxTexture("Bloom", desc);
            Assert(!IsNull(*downsample_texture), "Could not create bloom texture");

            view_desc : GfxTextureViewDesc;
            view_desc.type = .Texture2D;
            view_desc.pixel_format = .RGBA16Float;
            view_desc.first_mipmap_level = 0;
            view_desc.num_mipmap_levels = 1;

            downsample_levels = AllocArray(GfxTexture, desc.num_mipmap_levels);
            downsample_levels[0] = CreateGfxTextureView("Bloom", view_desc, *downsample_texture);
            Assert(!IsNull(*downsample_levels[0]), "Could not create bloom texture view");

            return;
        }

        desc : GfxTextureDesc;
        desc.type = .Texture2D;
        desc.width = resolution.x;
        desc.height = resolution.y;
        desc.num_mipmap_levels = xx num_downsample_passes;

        desc.pixel_format = .RGBA16Float;
        desc.usage = .Sampled | .Storage;

        downsample_texture = CreateGfxTexture("Bloom Downsample", desc);
        Assert(!IsNull(*downsample_texture), "Could not create bloom downsample texture");

        downsample_levels = AllocArray(GfxTexture, desc.num_mipmap_levels);
        for * downsample_levels {
            view_desc : GfxTextureViewDesc;
            view_desc.type = .Texture2D;
            view_desc.pixel_format = .RGBA16Float;
            view_desc.first_mipmap_level = xx it_index;
            view_desc.num_mipmap_levels = 1;

            it.* = CreateGfxTextureView(TPrint("Bloom Downsample %", it_index), view_desc, *downsample_texture);
            Assert(!IsNull(it), "Could not create bloom downsample texture view for level %", it_index);
        }

        desc.num_mipmap_levels -= 1;

        upsample_texture = CreateGfxTexture("Bloom Upsample", desc);
        Assert(!IsNull(*upsample_texture), "Could not create bloom upsample texture");

        upsample_levels = AllocArray(GfxTexture, desc.num_mipmap_levels);
        for * upsample_levels {
            view_desc : GfxTextureViewDesc;
            view_desc.type = .Texture2D;
            view_desc.pixel_format = .RGBA16Float;
            view_desc.first_mipmap_level = xx it_index;
            view_desc.num_mipmap_levels = 1;

            it.* = CreateGfxTextureView(TPrint("Bloom Upsample %", it_index), view_desc, *upsample_texture);
            Assert(!IsNull(it), "Could not create bloom upsample texture view for level %", it_index);
        }
    }
}

DestroyBloomTextures :: (using bloom : *BloomTextures) {
    for * downsample_levels {
        DestroyGfxTextureView(it);
    }
    Free(downsample_levels.data);

    DestroyGfxTexture(*downsample_texture);

    for * upsample_levels {
        DestroyGfxTextureView(it);
    }
    Free(upsample_levels.data);

    DestroyGfxTexture(*upsample_texture);

    bloom.* = .{};
}

using _ :: struct {
    Bloom_Compute_Work_Group_Size :: 16;
} @ShaderType

BloomComputeBindingSet :: struct {
    src_texture : GfxBindingCombinedTextureSampler; @Binding(0) @ComputeStage
    dst_image : GfxBindingStorageImage; @Binding(1) @ComputeStage
} @BindingSet

BloomUpsampleComputeBindingSet :: struct {
    previous_upsampled_texture : GfxBindingCombinedTextureSampler; @Binding(0) @ComputeStage
    same_size_downsampled_texture : GfxBindingCombinedTextureSampler; @Binding(1) @ComputeStage
    dst_image : GfxBindingStorageImage; @Binding(2) @ComputeStage
} @BindingSet

g_bloom_filter_compute_pipeline : GfxComputePipeline;
g_bloom_downsample_compute_pipeline : GfxComputePipeline;
g_bloom_upsample_compute_pipeline : GfxComputePipeline;

CreateBloomFilterComputePipeline :: () {
    desc : GfxComputePipelineDesc;
    desc.shader = GetComputeShader("bloom_filter");
    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.BloomComputeBindingSet,
    ];

    CreateGfxComputePipeline(*g_bloom_filter_compute_pipeline, "Bloom Filter", desc);
}

CreateBloomDownsampleComputePipeline :: () {
    desc : GfxComputePipelineDesc;
    desc.shader = GetComputeShader("bloom_downsample");
    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.BloomComputeBindingSet,
    ];

    CreateGfxComputePipeline(*g_bloom_downsample_compute_pipeline, "Bloom Downsample", desc);
}

CreateBloomUpsampleComputePipeline :: () {
    desc : GfxComputePipelineDesc;
    desc.shader = GetComputeShader("bloom_upsample");
    desc.layout.binding_sets = .[
        g_binding_set_layouts.FrameBindingSet,
        g_binding_set_layouts.BloomUpsampleComputeBindingSet,
    ];

    CreateGfxComputePipeline(*g_bloom_upsample_compute_pipeline, "Bloom Upsample", desc);
}

ComputeBloom :: (using ctx : *RenderContext) {
    BeginGfxDebugMarker(cmd_buffer, "Bloom");
    defer EndGfxDebugMarker(cmd_buffer);

    ProfileGPUZone(cmd_buffer, GetGPUFrameProfiler(), "Bloom");

    if IsNull(*g_bloom_filter_compute_pipeline) {
        CreateBloomFilterComputePipeline();
    }
    if IsNull(*g_bloom_downsample_compute_pipeline) {
        CreateBloomDownsampleComputePipeline();
    }
    if IsNull(*g_bloom_upsample_compute_pipeline) {
        CreateBloomUpsampleComputePipeline();
    }

    using render_targets.bloom_textures;

    if upsample_levels.count > 0 {
        AddTextureBarriers(cmd_buffer, .Undefined, .General, .[*downsample_texture, *upsample_texture]);
    } else {
        AddTextureBarrier(cmd_buffer, .Undefined, .General, *downsample_texture);
    }

    pass := BeginGfxComputePass(cmd_buffer, "Bloom Filter");
    {
        BindComputePipeline(*pass, *g_bloom_filter_compute_pipeline);

        AddTextureBarrier(cmd_buffer, .Undefined, .General, *downsample_levels[0]);

        bindings := BloomComputeBindingSet.{
            src_texture=.{texture=*render_targets.hdr_color_texture, sampler=*g_linear_clamp_sampler},
            dst_image=.{*downsample_levels[0]},
        };

        num_groups_x, num_groups_y := GetNumComputeWorkGroupsForTexture(downsample_texture.desc, 0, Bloom_Compute_Work_Group_Size);

        binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), bindings);
        BindComputeBindingSet(*pass, 1, *binding_set);
        Dispatch(*pass, num_groups_x, num_groups_y, num_groups_z=1);

        AddTextureBarrier(cmd_buffer, .General, .ShaderReadOnly, *downsample_levels[0]);
    }
    EndGfxComputePass(*pass);

    if downsample_levels.count == 1 {
        return;
    }

    pass = BeginGfxComputePass(cmd_buffer, "Bloom Downsample");
    {
        BindComputePipeline(*pass, *g_bloom_downsample_compute_pipeline);

        for i : 0..downsample_levels.count - 2 {
            AddTextureBarrier(cmd_buffer, .Undefined, .General, *downsample_levels[i + 1]);

            bindings := BloomComputeBindingSet.{
                src_texture=.{texture=*downsample_levels[i], sampler=*g_linear_clamp_sampler},
                dst_image=.{*downsample_levels[i + 1]},
            };

            binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), bindings);
            BindComputeBindingSet(*pass, 1, *binding_set);

            num_groups_x, num_groups_y := GetNumComputeWorkGroupsForTexture(downsample_texture.desc, i + 1, Bloom_Compute_Work_Group_Size);

            Dispatch(*pass, num_groups_x, num_groups_y, num_groups_z=1);

            AddTextureBarrier(cmd_buffer, .General, .ShaderReadOnly, *downsample_levels[i + 1]);
        }
    }
    EndGfxComputePass(*pass);

    pass = BeginGfxComputePass(cmd_buffer, "Bloom Upsample");
    {
        BindComputePipeline(*pass, *g_bloom_upsample_compute_pipeline);

        for #v2 < i : 0..upsample_levels.count - 1 {
            AddTextureBarrier(cmd_buffer, .Undefined, .General, *upsample_levels[i]);

            bindings := BloomUpsampleComputeBindingSet.{
                same_size_downsampled_texture=.{texture=*downsample_levels[i], sampler=*g_linear_clamp_sampler},
                dst_image=.{*upsample_levels[i]},
            };

            if i == upsample_levels.count - 1 {
                bindings.previous_upsampled_texture = .{texture=*downsample_levels[i + 1], sampler=*g_linear_clamp_sampler};
            } else {
                bindings.previous_upsampled_texture = .{texture=*upsample_levels[i + 1], sampler=*g_linear_clamp_sampler};
            }

            binding_set := CreateGfxBindingSet(GlobalBindingSetAllocator(), bindings);
            BindComputeBindingSet(*pass, 1, *binding_set);

            num_groups_x, num_groups_y := GetNumComputeWorkGroupsForTexture(upsample_texture.desc, i, Bloom_Compute_Work_Group_Size);

            Dispatch(*pass, num_groups_x, num_groups_y, num_groups_z=1);

            AddTextureBarrier(cmd_buffer, .General, .ShaderReadOnly, *upsample_levels[i]);
        }
    }
    EndGfxComputePass(*pass);
}
