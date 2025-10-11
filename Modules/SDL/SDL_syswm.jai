using SDL_SYSWM_TYPE :: enum s32 {
    SDL_SYSWM_UNKNOWN;
    SDL_SYSWM_WINDOWS;
    SDL_SYSWM_X11;
    SDL_SYSWM_DIRECTFB;
    SDL_SYSWM_COCOA;
    SDL_SYSWM_UIKIT;
}

SDL_SysWMinfo :: struct {
    version: SDL_version;
    subsystem: SDL_SYSWM_TYPE;
    info : union {
        #if OS == .WINDOWS {
            win : struct {
                //window: HWND;                // The window handle
                window: *void;               // The window handle
            };
        } else #if OS == .LINUX {
            x11 : struct {
                display: *Display;           // The X11 display
                window: Window;              // The X11 window
            };
        } else #if OS == .MACOS {
            cocoa : struct {
                //window: *NSWindow;           // The Cocoa window
                window: *void;
            };
        }
    };
}


SDL_GetWindowWMInfo :: (window: *SDL_Window, info: *SDL_SysWMinfo) -> SDL_bool #foreign SDL2;
