g_environment_map_config : EnvironmentMapConfig;

GetEnvironmentMapConfig :: () -> *EnvironmentMapConfig {
    return *g_environment_map_config;
} @Public;

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
    desc.width = g_environment_map_config.irradiance_map_resolution;
    desc.height = cast(u32, desc.width * aspect_ratio);

    map.irradiance_map = CreateGfxTexture(TPrint("% irradiance", name), desc);
    if IsNull(*map.irradiance_map) {
        DerefAsset(*map.base_texture);
        return false;
    }

    desc.width = g_environment_map_config.environment_map_resolution;
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

GetEnvironmentMapsToGenerate :: () -> []*EnvironmentMap {
    return g_environment_maps_to_generate;
} @Public

ClearEnvironmentMapsToGenerate :: () {
    ArrayClear(*g_environment_maps_to_generate);
} @Public
