// SDL_pixels.h

SDL_Color :: struct {
    r : u8;
    g : u8;
    b : u8;
    a : u8;
}

SDL_Palette :: struct {
    ncolors: s32;
    colors: *SDL_Color;
    version: u32;
    refcount: s32;
}

SDL_PixelFormat :: struct {
    format: u32;
    palette: *SDL_Palette;
    BitsPerPixel: u8;
    BytesPerPixel: u8;
    padding: [2]u8;
    Rmask: u32;
    Gmask: u32;
    Bmask: u32;
    Amask: u32;
    Rloss: u8;
    Gloss: u8;
    Bloss: u8;
    Aloss: u8;
    Rshift: u8;
    Gshift: u8;
    Bshift: u8;
    Ashift: u8;
    refcount: s32;
    next: *SDL_PixelFormat;
}
