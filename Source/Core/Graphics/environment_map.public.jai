EnvironmentMapConfig :: struct {
    environment_map_resolution : u32 = 1024;
    irradiance_map_resolution : u32 = 64;
    environment_map_num_samples : u32 = 128;
    irradiance_map_sample_delta := 0.025;
};

using _ :: struct {
    Num_Environment_Map_Levels :: 6;
} @ShaderType

EnvironmentMap :: struct {
    base_texture : *Asset(Texture2D);
    irradiance_map : GfxTexture;
    environment_map : GfxTexture;
    environment_levels : [Num_Environment_Map_Levels]GfxTexture;
} @Asset
