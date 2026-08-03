
// SDL2 bindings.

// SDL.h

using SDL_INIT_FLAGS :: enum_flags u32 {
    SDL_INIT_TIMER ::          0x00000001;
    SDL_INIT_AUDIO ::          0x00000010;
    SDL_INIT_VIDEO ::          0x00000020;
    SDL_INIT_JOYSTICK ::       0x00000200;
    SDL_INIT_HAPTIC ::         0x00001000;
    SDL_INIT_GAMECONTROLLER :: 0x00002000;
    SDL_INIT_EVENTS ::         0x00004000;
    SDL_INIT_NOPARACHUTE ::    0x00100000;
    SDL_INIT_EVERYTHING :: (SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER);
}


SDL_Init :: (flags: SDL_INIT_FLAGS) -> s32 #foreign SDL2;
SDL_InitSubSystem :: (flags: SDL_INIT_FLAGS) -> s32 #foreign SDL2;
SDL_QuitSubSystem :: (flags: SDL_INIT_FLAGS) #foreign SDL2;
SDL_WasInit :: (flags: SDL_INIT_FLAGS) -> SDL_INIT_FLAGS #foreign SDL2;
SDL_Quit :: () #foreign SDL2;

// SDL_platform.h

SDL_GetPlatform :: () -> *u8 #foreign SDL2;

// SDL_stdinc.h

using SDL_bool :: enum u32 {
    SDL_FALSE :: 0;
    SDL_TRUE :: 1;
}

// SDL_error.h

SDL_GetError :: () -> *u8 #foreign SDL2;
SDL_ClearError :: () #foreign SDL2;



#load "SDL_version.jai";
#load "SDL_video.jai";
#load "SDL_surface.jai";
#load "SDL_pixels.jai";
#load "SDL_blit.jai";
#load "SDL_syswm.jai";
#load "SDL_clipboard.jai";
#load "SDL_event.jai";
#load "SDL_keyboard.jai";
#load "SDL_scancode.jai";
#load "SDL_mouse.jai";
#load "SDL_joystick.jai";
#load "SDL_rect.jai";
#load "SDL_timer.jai";
#load "SDL_render.jai";
#load "SDL_hints.jai";
#load "SDL_blendmode.jai";
#load "SDL_audio.jai";
#load "SDL_gamecontroller.jai";


#scope_export // Export SDL2 library definition so that users can manually declare additional bindings we have omitted.

#if OS == .WINDOWS {
    SDL2 :: #library "Libs/Windows/SDL2";
} else #if OS == .MACOS {
    SDL2 :: #library "Libs/MacOS/libSDL2";
    #library,system,link_always "libdl";
    #library,system,link_always "libm";
} else #if OS == .LINUX {
    #import "X11";
    SDL2 :: #library,system "libSDL2";
    #library,system,link_always "libdl";
    #library,system,link_always "libm";
    #library,system,link_always "libpthread";
}
