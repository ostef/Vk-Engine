Texture2D :: struct {
    // This needs to be the first member, because we want to cast *Texture2D to *GfxTexture
    #as texture : GfxTexture;
    using,only(width, height) texture.desc;
} @Asset
