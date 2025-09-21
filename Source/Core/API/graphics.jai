// @Todo: limit the number of uploads per frame

Texture2D :: struct {
    // This needs to be the first member, because we want to cast *Texture2D to *GfxTexture
    #as texture : GfxTexture;
    using,only(width, height) texture.desc;
} @Asset

using _ :: struct {
    Num_Environment_Map_Levels :: 6;
} @ShaderType

EnvironmentMap :: struct {
    base_texture : *Asset(Texture2D);
    irradiance_map : GfxTexture;
    environment_map : GfxTexture;
    environment_levels : [Num_Environment_Map_Levels]GfxTexture;
} @Asset
