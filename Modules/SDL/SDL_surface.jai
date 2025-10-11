// SDL_surface.h

SDL_Surface :: struct {
    flags: u32;
    format: *SDL_PixelFormat;
    w, h: s32;
    pitch: s32;
    pixels: *void;
    userdata: *void;
    locked: s32;
    lock_data: *void;
    clip_rect: SDL_Rect;
    map: *SDL_BlitMap;
    refcount: s32;
}


SDL_RWops :: struct {
    size  : (*SDL_RWops) -> s64;
    seek  : (*SDL_RWops, s64, int) -> s64;
    read  : (*SDL_RWops, *void, int, int) -> int;
    write : (*SDL_RWops, *void, int, int) -> int;
    close : (*SDL_RWops) -> int;
    type  : u32;
}

SDL_RWFromFile :: (path: *u8, mode: *u8) -> *SDL_RWops #foreign SDL2;
SDL_LoadBMP_RW :: (src: *SDL_RWops, freesrc: int) -> *SDL_Surface #foreign SDL2;
SDL_FreeSurface :: (surface: *SDL_Surface) #foreign SDL2;
SDL_CreateRGBSurfaceFrom :: (pixels: *void, width: int, height: int, depth: int, pitch: int, rmask: u32, gmask: u32, bmask: u32, amask: u32) -> *SDL_Surface #foreign SDL2;
SDL_CreateRGBSurfaceWithFormatFrom :: (pixels: *void, width: int, height: int, depth: int, pitch: int, format: u32) -> *SDL_Surface #foreign SDL2;

SDL_LoadBMP :: inline (path: *u8) -> *SDL_Surface {
    return SDL_LoadBMP_RW(SDL_RWFromFile(path, "rb"), 1);
}

SDL_ShowSimpleMessageBox :: (flags: u32, title: *u8, msg: *u8, parent: *SDL_Window) -> int #foreign SDL2;

