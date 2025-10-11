// SDL_mouse.h

SDL_Cursor :: void;

using SDL_SystemCursor :: enum s32 {
    ARROW;     // Arrow
    IBEAM;     // I-beam
    WAIT;      // Wait
    CROSSHAIR; // Crosshair
    WAITARROW; // Small wait cursor (or Wait if not available)
    SIZENWSE;  // Double arrow pointing northwest and southeast
    SIZENESW;  // Double arrow pointing northeast and southwest
    SIZEWE;    // Double arrow pointing west and east
    SIZENS;    // Double arrow pointing north and south
    SIZEALL;   // Four pointed arrow pointing north, south, east, and west
    NO;        // Slashed circle or crossbones
    HAND;      // Hand
    SDL_NUM_SYSTEM_CURSORS;
}

SDL_MouseWheelDirection :: enum s32 {
    SDL_MOUSEWHEEL_NORMAL;      // The scroll direction is normal
    SDL_MOUSEWHEEL_FLIPPED;     // The scroll direction is flipped / natural
}

SDL_GetMouseFocus :: () -> *SDL_Window #foreign SDL2;
SDL_GetMouseState :: (x: *s32, y: *s32) -> u32 #foreign SDL2;
SDL_GetGlobalMouseState :: (x: *s32, y: *s32) -> u32 #foreign SDL2;
SDL_GetRelativeMouseState :: (x: *s32, y: *s32) -> u32 #foreign SDL2;
SDL_WarpMouseInWindow :: (window: *SDL_Window, x: s32, y: s32) #foreign SDL2;
SDL_WarpMouseGlobal :: (x: s32, y: s32) -> s32 #foreign SDL2;
SDL_SetRelativeMouseMode :: (enabled: SDL_bool) -> s32 #foreign SDL2;
SDL_CaptureMouse :: (enabled: SDL_bool) -> s32 #foreign SDL2;
SDL_GetRelativeMouseMode :: () -> SDL_bool #foreign SDL2;
SDL_CreateCursor :: (data: *u8, mask: *u8, w: s32, h: s32, hot_x: s32, hot_y: s32) -> *SDL_Cursor #foreign SDL2;
SDL_CreateColorCursor :: (surface: *SDL_Surface, hot_x: s32, hot_y: s32) -> *SDL_Cursor #foreign SDL2;
SDL_CreateSystemCursor :: (id: SDL_SystemCursor) -> *SDL_Cursor #foreign SDL2;
SDL_SetCursor :: (cursor: *SDL_Cursor) #foreign SDL2;
SDL_GetCursor :: () -> *SDL_Cursor #foreign SDL2;
SDL_GetDefaultCursor :: () -> *SDL_Cursor #foreign SDL2;
SDL_FreeCursor :: (cursor: *SDL_Cursor) #foreign SDL2;
SDL_ShowCursor :: (toggle: s32) -> s32 #foreign SDL2;

SDL_BUTTON :: (x:int) -> int { return (1 << ((x)-1)); }
SDL_BUTTON_LEFT ::     1;
SDL_BUTTON_MIDDLE ::   2;
SDL_BUTTON_RIGHT ::    3;
SDL_BUTTON_X1 ::       4;
SDL_BUTTON_X2 ::       5;
//SDL_BUTTON_LMASK ::    SDL_BUTTON(SDL_BUTTON_LEFT);
//SDL_BUTTON_MMASK ::    SDL_BUTTON(SDL_BUTTON_MIDDLE);
//SDL_BUTTON_RMASK ::    SDL_BUTTON(SDL_BUTTON_RIGHT);
//SDL_BUTTON_X1MASK ::   SDL_BUTTON(SDL_BUTTON_X1);
//SDL_BUTTON_X2MASK ::   SDL_BUTTON(SDL_BUTTON_X2);

