// SDL_video.h

SDL_DisplayMode :: struct {
    format : u32;
    w : s32;
    h : s32;
    refresh_rate : s32;
    driverdata : *void;
}

SDL_Window :: void;

using SDL_WindowFlags :: enum_flags u32 {
    SDL_WINDOW_FULLSCREEN :: 0x00000001;
    SDL_WINDOW_OPENGL :: 0x00000002;
    SDL_WINDOW_SHOWN :: 0x00000004;
    SDL_WINDOW_HIDDEN :: 0x00000008;
    SDL_WINDOW_BORDERLESS :: 0x00000010;
    SDL_WINDOW_RESIZABLE :: 0x00000020;
    SDL_WINDOW_MINIMIZED :: 0x00000040;
    SDL_WINDOW_MAXIMIZED :: 0x00000080;
    SDL_WINDOW_INPUT_GRABBED :: 0x00000100;
    SDL_WINDOW_INPUT_FOCUS :: 0x00000200;
    SDL_WINDOW_MOUSE_FOCUS :: 0x00000400;
    SDL_WINDOW_FULLSCREEN_DESKTOP :: ((xx SDL_WINDOW_FULLSCREEN) | 0x00001000);
    SDL_WINDOW_FOREIGN :: 0x00000800;
    SDL_WINDOW_ALLOW_HIGHDPI :: 0x00002000;
    SDL_WINDOW_MOUSE_CAPTURE :: 0x00004000;
    SDL_WINDOW_ALWAYS_ON_TOP :: 0x00008000;
    SDL_WINDOW_SKIP_TASKBAR  :: 0x00010000;
    SDL_WINDOW_UTILITY       :: 0x00020000;
    SDL_WINDOW_TOOLTIP       :: 0x00040000;
    SDL_WINDOW_POPUP_MENU    :: 0x00080000;
    SDL_WINDOW_VULKAN        :: 0x10000000;
}

SDL_WINDOWPOS_UNDEFINED_MASK :s32: 0x1FFF0000;
SDL_WINDOWPOS_UNDEFINED_DISPLAY :: (x: s32) -> s32 { return (SDL_WINDOWPOS_UNDEFINED_MASK|x); }
SDL_WINDOWPOS_UNDEFINED :s32: 0x1FFF0000; // SDL_WINDOWPOS_UNDEFINED_DISPLAY(0);
SDL_WINDOWPOS_CENTERED_MASK :s32: 0x2FFF0000;
SDL_WINDOWPOS_CENTERED_DISPLAY :: (x: s32) -> s32 { return (SDL_WINDOWPOS_CENTERED_MASK|x); }
SDL_WINDOWPOS_CENTERED :s32: 0x2FFF0000; // SDL_WINDOWPOS_CENTERED_DISPLAY(0);

using SDL_WindowEventID :: enum u8 {
    SDL_WINDOWEVENT_NONE;
    SDL_WINDOWEVENT_SHOWN;
    SDL_WINDOWEVENT_HIDDEN;
    SDL_WINDOWEVENT_EXPOSED;
    SDL_WINDOWEVENT_MOVED;
    SDL_WINDOWEVENT_RESIZED;
    SDL_WINDOWEVENT_SIZE_CHANGED;
    SDL_WINDOWEVENT_MINIMIZED;
    SDL_WINDOWEVENT_MAXIMIZED;
    SDL_WINDOWEVENT_RESTORED;
    SDL_WINDOWEVENT_ENTER;
    SDL_WINDOWEVENT_LEAVE;
    SDL_WINDOWEVENT_FOCUS_GAINED;
    SDL_WINDOWEVENT_FOCUS_LOST;
    SDL_WINDOWEVENT_CLOSE;
    SDL_WINDOWEVENT_TAKE_FOCUS;
    SDL_WINDOWEVENT_HIT_TEST;
}

SDL_GLContext :: *void;

using SDL_GLattr :: enum u32 {
    SDL_GL_RED_SIZE;
    SDL_GL_GREEN_SIZE;
    SDL_GL_BLUE_SIZE;
    SDL_GL_ALPHA_SIZE;
    SDL_GL_BUFFER_SIZE;
    SDL_GL_DOUBLEBUFFER;
    SDL_GL_DEPTH_SIZE;
    SDL_GL_STENCIL_SIZE;
    SDL_GL_ACCUM_RED_SIZE;
    SDL_GL_ACCUM_GREEN_SIZE;
    SDL_GL_ACCUM_BLUE_SIZE;
    SDL_GL_ACCUM_ALPHA_SIZE;
    SDL_GL_STEREO;
    SDL_GL_MULTISAMPLEBUFFERS;
    SDL_GL_MULTISAMPLESAMPLES;
    SDL_GL_ACCELERATED_VISUAL;
    SDL_GL_RETAINED_BACKING;
    SDL_GL_CONTEXT_MAJOR_VERSION;
    SDL_GL_CONTEXT_MINOR_VERSION;
    SDL_GL_CONTEXT_EGL;
    SDL_GL_CONTEXT_FLAGS;
    SDL_GL_CONTEXT_PROFILE_MASK;
    SDL_GL_SHARE_WITH_CURRENT_CONTEXT;
    SDL_GL_FRAMEBUFFER_SRGB_CAPABLE;
    SDL_GL_CONTEXT_RELEASE_BEHAVIOR;
    SDL_GL_CONTEXT_RESET_NOTIFICATION;
    SDL_GL_CONTEXT_NO_ERROR;
}

using SDL_GLprofile :: enum_flags u32 {
    SDL_GL_CONTEXT_PROFILE_CORE           :: 0x0001;
    SDL_GL_CONTEXT_PROFILE_COMPATIBILITY  :: 0x0002;
    SDL_GL_CONTEXT_PROFILE_ES             :: 0x0004;
}

using SDL_GLcontextFlag :: enum_flags u32 {
    SDL_GL_CONTEXT_DEBUG_FLAG              :: 0x0001;
    SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG :: 0x0002;
    SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG      :: 0x0004;
    SDL_GL_CONTEXT_RESET_ISOLATION_FLAG    :: 0x0008;
}

using SDL_GLcontextReleaseFlag :: enum_flags u32 {
    SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE   :: 0x0000;
    SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH  :: 0x0001;
}

using SDL_GLContextResetNotification :: enum_flags u32 {
    SDL_GL_CONTEXT_RESET_NO_NOTIFICATION :: 0x0000;
    SDL_GL_CONTEXT_RESET_LOSE_CONTEXT    :: 0x0001;
}

using SDL_HitTestResult :: enum u32 {
    SDL_HITTEST_NORMAL;
    SDL_HITTEST_DRAGGABLE;
    SDL_HITTEST_RESIZE_TOPLEFT;
    SDL_HITTEST_RESIZE_TOP;
    SDL_HITTEST_RESIZE_TOPRIGHT;
    SDL_HITTEST_RESIZE_RIGHT;
    SDL_HITTEST_RESIZE_BOTTOMRIGHT;
    SDL_HITTEST_RESIZE_BOTTOM;
    SDL_HITTEST_RESIZE_BOTTOMLEFT;
    SDL_HITTEST_RESIZE_LEFT;
}

SDL_HitTest :: #type (win: *SDL_Window, area: *SDL_Point, data: *void) -> SDL_HitTestResult #c_call;


// @@ Some functions not found in libSDL2.dylib

SDL_GetNumVideoDrivers :: () -> s32 #foreign SDL2;
SDL_GetVideoDriver :: (index: s32) -> *u8 #foreign SDL2;
SDL_VideoInit :: (driver_name: *u8) -> s32 #foreign SDL2;
SDL_VideoQuit :: () #foreign SDL2;
SDL_GetCurrentVideoDriver :: () -> *u8 #foreign SDL2;
SDL_GetNumVideoDisplays :: () -> s32 #foreign SDL2;
SDL_GetDisplayName :: (displayIndex: s32) -> *u8 #foreign SDL2;
SDL_GetDisplayBounds :: (displayIndex: s32, rect: *SDL_Rect) -> s32 #foreign SDL2;
SDL_GetDisplayDPI :: (displayIndex: s32, ddpi: *float, hdpi: *float, vdpi: *float) -> s32 #foreign SDL2;
//SDL_GetDisplayUsableBounds :: (displayIndex: s32, rect: *SDL_Rect) -> s32 #foreign SDL2;
SDL_GetNumDisplayModes :: (displayIndex: s32) -> s32 #foreign SDL2;
SDL_GetDisplayMode :: (displayIndex: s32, modeIndex: s32, mode: *SDL_DisplayMode) -> s32 #foreign SDL2;
SDL_GetDesktopDisplayMode :: (displayIndex: s32, mode: *SDL_DisplayMode) -> s32 #foreign SDL2;
SDL_GetCurrentDisplayMode :: (displayIndex: s32, mode: *SDL_DisplayMode) -> s32 #foreign SDL2;
SDL_GetClosestDisplayMode :: (displayIndex: s32, mode: *SDL_DisplayMode, closest: *SDL_DisplayMode) -> *SDL_DisplayMode #foreign SDL2;
SDL_GetWindowDisplayIndex :: (window: *SDL_Window) -> s32 #foreign SDL2;
SDL_SetWindowDisplayMode :: (window: *SDL_Window, mode: *SDL_DisplayMode) -> s32 #foreign SDL2;
SDL_GetWindowDisplayMode :: (window: *SDL_Window, mode: *SDL_DisplayMode) -> s32 #foreign SDL2;
SDL_GetWindowPixelFormat :: (window: *SDL_Window) -> u32 #foreign SDL2;
SDL_CreateWindow :: (title: *u8, x: s32, y: s32, w: s32, h: s32, flags: SDL_WindowFlags) -> *SDL_Window #foreign SDL2;
SDL_CreateWindowFrom :: (data: *void) -> *SDL_Window #foreign SDL2;
SDL_GetWindowID :: (window: *SDL_Window) -> u32 #foreign SDL2;
SDL_GetWindowFromID :: (id: u32) -> *SDL_Window #foreign SDL2;
SDL_GetWindowFlags :: (window: *SDL_Window) -> SDL_WindowFlags #foreign SDL2;
SDL_SetWindowTitle :: (window: *SDL_Window, title: *u8) #foreign SDL2;
SDL_GetWindowTitle :: (window: *SDL_Window) -> *u8 #foreign SDL2;
SDL_SetWindowIcon :: (window: *SDL_Window, icon: *SDL_Surface) #foreign SDL2;
SDL_SetWindowData :: (window: *SDL_Window, name: *u8, userdata: *void) -> *void #foreign SDL2;
SDL_GetWindowData :: (window: *SDL_Window, name: *u8) -> *void #foreign SDL2;
SDL_SetWindowPosition :: (window: *SDL_Window, x: s32, y: s32) #foreign SDL2;
SDL_GetWindowPosition :: (window: *SDL_Window, x: *s32, y: *s32) #foreign SDL2;
SDL_SetWindowSize :: (window: *SDL_Window, w: s32, h: s32) #foreign SDL2;
SDL_GetWindowSize :: (window: *SDL_Window, w: *s32, h: *s32) #foreign SDL2;
//SDL_GetWindowBordersSize :: (window: *SDL_Window, top: *s32, left: *s32, bottom: *s32, right: *s32) -> s32 #foreign SDL2;
SDL_SetWindowMinimumSize :: (window: *SDL_Window, w: s32, h: s32) #foreign SDL2;
SDL_GetWindowMinimumSize :: (window: *SDL_Window, w: *s32, h: *s32) #foreign SDL2;
SDL_SetWindowMaximumSize :: (window: *SDL_Window, w: s32, h: s32) #foreign SDL2;
SDL_GetWindowMaximumSize :: (window: *SDL_Window, w: *s32, h: *s32) #foreign SDL2;
SDL_SetWindowBordered :: (window: *SDL_Window, bordered: SDL_bool) #foreign SDL2;
SDL_SetWindowResizable :: (window: *SDL_Window, resizable: SDL_bool) #foreign SDL2;
SDL_ShowWindow :: (window: *SDL_Window) #foreign SDL2;
SDL_HideWindow :: (window: *SDL_Window) #foreign SDL2;
SDL_RaiseWindow :: (window: *SDL_Window) #foreign SDL2;
SDL_MaximizeWindow :: (window: *SDL_Window) #foreign SDL2;
SDL_MinimizeWindow :: (window: *SDL_Window) #foreign SDL2;
SDL_RestoreWindow :: (window: *SDL_Window) #foreign SDL2;
SDL_SetWindowFullscreen :: (window: *SDL_Window, flags: u32 )-> s32 #foreign SDL2;
SDL_GetWindowSurface :: (window: *SDL_Window) -> *SDL_Surface #foreign SDL2;
SDL_UpdateWindowSurface :: (window: *SDL_Window) -> s32 #foreign SDL2;
SDL_UpdateWindowSurfaceRects :: (window: *SDL_Window, rects: *SDL_Rect, numrects: s32) -> s32 #foreign SDL2;
SDL_SetWindowGrab :: (window: *SDL_Window, grabbed: SDL_bool) #foreign SDL2;
SDL_GetWindowGrab :: (window: *SDL_Window) -> SDL_bool #foreign SDL2;
SDL_GetGrabbedWindow :: () -> *SDL_Window #foreign SDL2;
SDL_SetWindowBrightness :: (window: *SDL_Window, brightness: float) -> s32 #foreign SDL2;
SDL_GetWindowBrightness :: (window: *SDL_Window) -> float #foreign SDL2;
//SDL_SetWindowOpacity :: (window: *SDL_Window, opacity: float) -> s32 #foreign SDL2;
//SDL_GetWindowOpacity :: (window: *SDL_Window, out_opacity: *float) -> s32 #foreign SDL2;
//SDL_SetWindowModalFor :: (modal_window: *SDL_Window, parent_window: *SDL_Window) -> s32 #foreign SDL2;
//SDL_SetWindowInputFocus :: (window: *SDL_Window) -> s32 #foreign SDL2;
SDL_SetWindowGammaRamp :: (window: *SDL_Window, red: *u16, green: *u16, blue: *u16) -> s32 #foreign SDL2;
SDL_GetWindowGammaRamp :: (window: *SDL_Window, red: *u16, green: *u16, blue: *u16) -> s32 #foreign SDL2;
SDL_SetWindowHitTest :: (window: *SDL_Window, callback: SDL_HitTest, callback_data: *void) -> s32 #foreign SDL2;
SDL_DestroyWindow :: (window: *SDL_Window) #foreign SDL2;
SDL_IsScreenSaverEnabled :: () -> SDL_bool #foreign SDL2;
SDL_EnableScreenSaver :: () #foreign SDL2;
SDL_DisableScreenSaver :: () #foreign SDL2;
SDL_GL_LoadLibrary :: (path: *u8) -> s32 #foreign SDL2;
SDL_GL_GetProcAddress :: (proc: *u8) -> *void #foreign SDL2;
SDL_GL_UnloadLibrary :: () #foreign SDL2;
SDL_GL_ExtensionSupported :: (extension: *u8) -> SDL_bool #foreign SDL2;
SDL_GL_ResetAttributes :: () #foreign SDL2;
SDL_GL_SetAttribute :: (attr: SDL_GLattr, value: s32) -> s32 #foreign SDL2;
SDL_GL_GetAttribute :: (attr: SDL_GLattr, value: *s32) -> s32 #foreign SDL2;
SDL_GL_CreateContext :: (window: *SDL_Window) -> SDL_GLContext #foreign SDL2;
SDL_GL_MakeCurrent :: (window: *SDL_Window, ctx: SDL_GLContext) -> s32 #foreign SDL2;
SDL_GL_GetCurrentWindow :: () -> *SDL_Window #foreign SDL2;
SDL_GL_GetCurrentContext :: () -> SDL_GLContext #foreign SDL2;
SDL_GL_GetDrawableSize :: (window: *SDL_Window, w: *s32, h: *s32) #foreign SDL2;
SDL_GL_SetSwapInterval :: (interval: s32) -> s32 #foreign SDL2;
SDL_GL_GetSwapInterval :: () -> s32 #foreign SDL2;
SDL_GL_SwapWindow :: (window: *SDL_Window) #foreign SDL2;
SDL_GL_DeleteContext :: (ctx: SDL_GLContext) #foreign SDL2;
