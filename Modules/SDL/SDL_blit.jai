// SDL_blit.h

SDL_BlitInfo :: struct {
    src: *u8;
    src_w, src_h: s32;
    src_pitch: s32;
    src_skip: s32;
    dst: *u8;
    dst_w, dst_h: s32;
    dst_pitch: s32;
    dst_skip: s32;
    src_fmt: *SDL_PixelFormat;
    dst_fmt: *SDL_PixelFormat;
    table: *u8;
    flags: s32;
    colorkey: u32;
    r, g, b, a: u8;
}

SDL_blit :: #type (src: *SDL_Surface, srcrect: *SDL_Rect, dst: *SDL_Surface, dstrect: *SDL_Rect) -> s32 #c_call;

SDL_BlitMap :: struct {
    dst: *SDL_Surface;
    identity: s32;
    blit: SDL_blit;
    data: *void;
    info: SDL_BlitInfo;
    dst_palette_version : u32;
    src_palette_version : u32;
}
