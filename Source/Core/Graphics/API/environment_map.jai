using _ :: struct {
    Num_Environment_Map_Levels :: 6;
} @ShaderType

EnvironmentMap :: struct {
    base_texture : *Asset(Texture2D);
    irradiance_map : GfxTexture;
    environment_map : GfxTexture;
    environment_levels : [Num_Environment_Map_Levels]GfxTexture;
} @Asset
