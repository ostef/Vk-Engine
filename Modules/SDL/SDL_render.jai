// SDL_render.h

SDL_RendererFlags :: enum_flags u32 {
    SOFTWARE      :: 1;
    ACCELERATED   :: 2;
    PRESENTVSYNC  :: 4;
    TARGETTEXTURE :: 8;
}

SDL_RendererInfo :: struct {
    name:                *s8;
    flags:               u32;
    num_texture_formats: u32;
    texture_formats:     [16] u32;
    max_texture_width:   s32;
    max_texture_height:  s32;
}

SDL_TextureAccess :: enum u32 {
    STATIC    :: 0;
    STREAMING :: 1;
    TARGET    :: 2;
}

SDL_TextureModulate :: enum u32 {
    NONE  :: 0;
    COLOR :: 1;
    ALPHA :: 2;
}

SDL_RendererFlip :: enum u32 {
    NONE       :: 0;
    HORIZONTAL :: 1;
    VERTICAL   :: 2;
}


SDL_Renderer :: struct {}

SDL_Texture  :: struct {}


SDL_GetNumRenderDrivers :: () -> s32 #foreign SDL2;
SDL_GetRenderDriverInfo :: (index: s32, info: *SDL_RendererInfo) -> s32 #foreign SDL2;
SDL_CreateWindowAndRenderer :: (width: s32, height: s32, window_flags: u32, window: **SDL_Window, renderer: **SDL_Renderer) -> s32 #foreign SDL2;
SDL_CreateRenderer :: (window: *SDL_Window, index: s32, flags: SDL_RendererFlags) -> *SDL_Renderer #foreign SDL2;
SDL_CreateSoftwareRenderer :: (surface: *SDL_Surface) -> *SDL_Renderer #foreign SDL2;
SDL_GetRenderer :: (window: *SDL_Window) -> *SDL_Renderer #foreign SDL2;
SDL_GetRendererInfo :: (renderer: *SDL_Renderer, info: *SDL_RendererInfo) -> s32 #foreign SDL2;
SDL_GetRendererOutputSize :: (renderer: *SDL_Renderer, w: *s32, h: *s32) -> s32 #foreign SDL2;
SDL_CreateTexture :: (renderer: *SDL_Renderer, format: u32, access: s32, w: s32, h: s32) -> *SDL_Texture #foreign SDL2;
SDL_CreateTextureFromSurface :: (renderer: *SDL_Renderer, surface: *SDL_Surface) -> *SDL_Texture #foreign SDL2;
SDL_QueryTexture :: (texture: *SDL_Texture, format: *u32, access: *s32, w: *s32, h: *s32) -> s32 #foreign SDL2;
SDL_SetTextureColorMod :: (texture: *SDL_Texture, r: u8, g: u8, b: u8) -> s32 #foreign SDL2;
SDL_GetTextureColorMod :: (texture: *SDL_Texture, r: *u8, g: *u8, b: *u8) -> s32 #foreign SDL2;
SDL_SetTextureAlphaMod :: (texture: *SDL_Texture, alpha: u8) -> s32 #foreign SDL2;
SDL_GetTextureAlphaMod :: (texture: *SDL_Texture, alpha: *u8) -> s32 #foreign SDL2;
SDL_SetTextureBlendMode :: (texture: *SDL_Texture, blendMode: SDL_BlendMode) -> s32 #foreign SDL2;
SDL_GetTextureBlendMode :: (texture: *SDL_Texture, blendMode: *SDL_BlendMode) -> s32 #foreign SDL2;
SDL_UpdateTexture :: (texture: *SDL_Texture, rect: *SDL_Rect, pixels: *void, pitch: s32) -> s32 #foreign SDL2;
SDL_UpdateYUVTexture :: (texture: *SDL_Texture, rect: *SDL_Rect, Yplane: *u8, Ypitch: s32, Uplane: *u8, Upitch: s32, Vplane: *u8, Vpitch: s32) -> s32 #foreign SDL2;
SDL_LockTexture :: (texture: *SDL_Texture, rect: *SDL_Rect, pixels: **void, pitch: *s32) -> s32 #foreign SDL2;
SDL_UnlockTexture :: (texture: *SDL_Texture) #foreign SDL2;
SDL_RenderTargetSupported :: (renderer: *SDL_Renderer) -> SDL_bool #foreign SDL2;
SDL_SetRenderTarget :: (renderer: *SDL_Renderer, texture: *SDL_Texture) -> s32 #foreign SDL2;
SDL_GetRenderTarget :: (renderer: *SDL_Renderer) -> *SDL_Texture #foreign SDL2;
SDL_RenderSetLogicalSize :: (renderer: *SDL_Renderer, w: s32, h: s32) -> s32 #foreign SDL2;
SDL_RenderGetLogicalSize :: (renderer: *SDL_Renderer, w: *s32, h: *s32) #foreign SDL2;
SDL_RenderSetIntegerScale :: (renderer: *SDL_Renderer, enable: SDL_bool) -> s32 #foreign SDL2;
SDL_RenderGetIntegerScale :: (renderer: *SDL_Renderer) -> SDL_bool #foreign SDL2;
SDL_RenderSetViewport :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> s32 #foreign SDL2;
SDL_RenderGetViewport :: (renderer: *SDL_Renderer, rect: *SDL_Rect) #foreign SDL2;
SDL_RenderSetClipRect :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> s32 #foreign SDL2;
SDL_RenderGetClipRect :: (renderer: *SDL_Renderer, rect: *SDL_Rect) #foreign SDL2;
SDL_RenderIsClipEnabled :: (renderer: *SDL_Renderer) -> SDL_bool #foreign SDL2;
SDL_RenderSetScale :: (renderer: *SDL_Renderer, scaleX: float32, scaleY: float32) -> s32 #foreign SDL2;
SDL_RenderGetScale :: (renderer: *SDL_Renderer, scaleX: *float32, scaleY: *float32) #foreign SDL2;
SDL_SetRenderDrawColor :: (renderer: *SDL_Renderer, r: u8, g: u8, b: u8, a: u8) -> s32 #foreign SDL2;
SDL_GetRenderDrawColor :: (renderer: *SDL_Renderer, r: *u8, g: *u8, b: *u8, a: *u8) -> s32 #foreign SDL2;
SDL_SetRenderDrawBlendMode :: (renderer: *SDL_Renderer, blendMode: SDL_BlendMode) -> s32 #foreign SDL2;
SDL_GetRenderDrawBlendMode :: (renderer: *SDL_Renderer, blendMode: *SDL_BlendMode) -> s32 #foreign SDL2;
SDL_RenderClear :: (renderer: *SDL_Renderer) -> s32 #foreign SDL2;
SDL_RenderDrawPoint :: (renderer: *SDL_Renderer, x: s32, y: s32) -> s32 #foreign SDL2;
SDL_RenderDrawPoints :: (renderer: *SDL_Renderer, points: *SDL_Point, count: s32) -> s32 #foreign SDL2;
SDL_RenderDrawLine :: (renderer: *SDL_Renderer, x1: s32, y1: s32, x2: s32, y2: s32) -> s32 #foreign SDL2;
SDL_RenderDrawLines :: (renderer: *SDL_Renderer, points: *SDL_Point, count: s32) -> s32 #foreign SDL2;
SDL_RenderDrawRect :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> s32 #foreign SDL2;
SDL_RenderDrawRects :: (renderer: *SDL_Renderer, rects: *SDL_Rect, count: s32) -> s32 #foreign SDL2;
SDL_RenderFillRect :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> s32 #foreign SDL2;
SDL_RenderFillRects :: (renderer: *SDL_Renderer, rects: *SDL_Rect, count: s32) -> s32 #foreign SDL2;
SDL_RenderCopy :: (renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: *SDL_Rect, dstrect: *SDL_Rect) -> s32 #foreign SDL2;
SDL_RenderCopyEx :: (renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: *SDL_Rect, dstrect: *SDL_Rect, angle: float64, center: *SDL_Point, flip: SDL_RendererFlip) -> s32 #foreign SDL2;
SDL_RenderReadPixels :: (renderer: *SDL_Renderer, rect: *SDL_Rect, format: u32, pixels: *void, pitch: s32) -> s32 #foreign SDL2;
SDL_RenderPresent :: (renderer: *SDL_Renderer) #foreign SDL2;
SDL_DestroyTexture :: (texture: *SDL_Texture) #foreign SDL2;
SDL_DestroyRenderer :: (renderer: *SDL_Renderer) #foreign SDL2;
SDL_GL_BindTexture :: (texture: *SDL_Texture, texw: *float32, texh: *float32) -> s32 #foreign SDL2;
SDL_GL_UnbindTexture :: (texture: *SDL_Texture) -> s32 #foreign SDL2;

#if OS == .MACOS {
    SDL_RenderGetMetalLayer :: (renderer: *SDL_Renderer) -> *void #foreign SDL2;
    SDL_RenderGetMetalCommandEncoder :: (renderer: *SDL_Renderer) -> *void #foreign SDL2;
}
