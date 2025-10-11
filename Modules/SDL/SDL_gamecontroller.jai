SDL_GameController :: struct {}

using SDL_GameControllerBindType :: enum u32 {
    SDL_CONTROLLER_BINDTYPE_NONE :: 0;
    SDL_CONTROLLER_BINDTYPE_BUTTON :: 1;
    SDL_CONTROLLER_BINDTYPE_AXIS :: 2;
    SDL_CONTROLLER_BINDTYPE_HAT :: 3;
}

SDL_GameControllerButtonBind :: struct {
    bindType: SDL_GameControllerBindType;
    value: union {
        button: s32;
        axis: s32;
        hat: struct {
            hat: s32;
            hat_mask: s32;
        };
    };
}


//SDL_GameControllerAddMappingsFromRW :: (rw: *SDL_RWops, freerw: s32) -> s32 #foreign SDL2;
SDL_GameControllerAddMapping :: (mappingString: *s8) -> s32 #foreign SDL2;
SDL_GameControllerNumMappings :: () -> s32 #foreign SDL2;
SDL_GameControllerMappingForIndex :: (mapping_index: s32) -> *s8 #foreign SDL2;
SDL_GameControllerMappingForGUID :: (guid: SDL_JoystickGUID) -> *s8 #foreign SDL2;
SDL_GameControllerMapping :: (gamecontroller: *SDL_GameController) -> *s8 #foreign SDL2;
SDL_IsGameController :: (joystick_index: s32) -> SDL_bool #foreign SDL2;
SDL_GameControllerNameForIndex :: (joystick_index: s32) -> *s8 #foreign SDL2;
//SDL_GameControllerMappingForDeviceIndex :: (joystick_index: s32) -> *s8 #foreign SDL2;
SDL_GameControllerOpen :: (joystick_index: s32) -> *SDL_GameController #foreign SDL2;
SDL_GameControllerFromInstanceID :: (joyid: SDL_JoystickID) -> *SDL_GameController #foreign SDL2;
SDL_GameControllerName :: (gamecontroller: *SDL_GameController) -> *s8 #foreign SDL2;
//SDL_GameControllerGetPlayerIndex :: (gamecontroller: *SDL_GameController) -> s32 #foreign SDL2;
SDL_GameControllerGetVendor :: (gamecontroller: *SDL_GameController) -> u16 #foreign SDL2;
SDL_GameControllerGetProduct :: (gamecontroller: *SDL_GameController) -> u16 #foreign SDL2;
SDL_GameControllerGetProductVersion :: (gamecontroller: *SDL_GameController) -> u16 #foreign SDL2;
SDL_GameControllerGetAttached :: (gamecontroller: *SDL_GameController) -> SDL_bool #foreign SDL2;
SDL_GameControllerGetJoystick :: (gamecontroller: *SDL_GameController) -> *SDL_Joystick #foreign SDL2;
SDL_GameControllerEventState :: (state: s32) -> s32 #foreign SDL2;
SDL_GameControllerUpdate :: () -> void #foreign SDL2;

using SDL_GameControllerAxis :: enum s32 {
    SDL_CONTROLLER_AXIS_INVALID :: -1;
    SDL_CONTROLLER_AXIS_LEFTX :: 0;
    SDL_CONTROLLER_AXIS_LEFTY :: 1;
    SDL_CONTROLLER_AXIS_RIGHTX :: 2;
    SDL_CONTROLLER_AXIS_RIGHTY :: 3;
    SDL_CONTROLLER_AXIS_TRIGGERLEFT :: 4;
    SDL_CONTROLLER_AXIS_TRIGGERRIGHT :: 5;
    SDL_CONTROLLER_AXIS_MAX :: 6;
}

SDL_GameControllerGetAxisFromString :: (pchString: *s8) -> SDL_GameControllerAxis #foreign SDL2;
SDL_GameControllerGetStringForAxis :: (axis: SDL_GameControllerAxis) -> *s8 #foreign SDL2;
SDL_GameControllerGetBindForAxis :: (gamecontroller: *SDL_GameController, axis: SDL_GameControllerAxis) -> SDL_GameControllerButtonBind #foreign SDL2;
SDL_GameControllerGetAxis :: (gamecontroller: *SDL_GameController, axis: SDL_GameControllerAxis) -> s16 #foreign SDL2;

using SDL_GameControllerButton :: enum s32 {
    SDL_CONTROLLER_BUTTON_INVALID :: -1;
    SDL_CONTROLLER_BUTTON_A :: 0;
    SDL_CONTROLLER_BUTTON_B :: 1;
    SDL_CONTROLLER_BUTTON_X :: 2;
    SDL_CONTROLLER_BUTTON_Y :: 3;
    SDL_CONTROLLER_BUTTON_BACK :: 4;
    SDL_CONTROLLER_BUTTON_GUIDE :: 5;
    SDL_CONTROLLER_BUTTON_START :: 6;
    SDL_CONTROLLER_BUTTON_LEFTSTICK :: 7;
    SDL_CONTROLLER_BUTTON_RIGHTSTICK :: 8;
    SDL_CONTROLLER_BUTTON_LEFTSHOULDER :: 9;
    SDL_CONTROLLER_BUTTON_RIGHTSHOULDER :: 10;
    SDL_CONTROLLER_BUTTON_DPAD_UP :: 11;
    SDL_CONTROLLER_BUTTON_DPAD_DOWN :: 12;
    SDL_CONTROLLER_BUTTON_DPAD_LEFT :: 13;
    SDL_CONTROLLER_BUTTON_DPAD_RIGHT :: 14;
    SDL_CONTROLLER_BUTTON_MAX :: 15;
}


SDL_GameControllerGetButtonFromString :: (pchString: *s8) -> SDL_GameControllerButton #foreign SDL2;
SDL_GameControllerGetStringForButton :: (button: SDL_GameControllerButton) -> *s8 #foreign SDL2;
SDL_GameControllerGetBindForButton :: (gamecontroller: *SDL_GameController, button: SDL_GameControllerButton) -> SDL_GameControllerButtonBind #foreign SDL2;
SDL_GameControllerGetButton :: (gamecontroller: *SDL_GameController, button: SDL_GameControllerButton) -> u8 #foreign SDL2;
//SDL_GameControllerRumble :: (gamecontroller: *SDL_GameController, low_frequency_rumble: u16, high_frequency_rumble: u16, duration_ms: u32) -> s32 #foreign SDL2;
SDL_GameControllerClose :: (gamecontroller: *SDL_GameController) -> void #foreign SDL2;

