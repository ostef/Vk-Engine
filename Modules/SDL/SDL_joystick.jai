// SDL_joystick.h

SDL_Joystick :: void;

SDL_JoystickGUID :: struct {
    data: [16]u8;
}

SDL_JoystickID :: s32;

SDL_JoystickType :: enum s32 {
    SDL_JOYSTICK_TYPE_UNKNOWN;
    SDL_JOYSTICK_TYPE_GAMECONTROLLER;
    SDL_JOYSTICK_TYPE_WHEEL;
    SDL_JOYSTICK_TYPE_ARCADE_STICK;
    SDL_JOYSTICK_TYPE_FLIGHT_STICK;
    SDL_JOYSTICK_TYPE_DANCE_PAD;
    SDL_JOYSTICK_TYPE_GUITAR;
    SDL_JOYSTICK_TYPE_DRUM_KIT;
    SDL_JOYSTICK_TYPE_ARCADE_PAD;
    SDL_JOYSTICK_TYPE_THROTTLE;
}

SDL_JoystickPowerLevel :: enum s32 {
    SDL_JOYSTICK_POWER_UNKNOWN :: -1;
    SDL_JOYSTICK_POWER_EMPTY;
    SDL_JOYSTICK_POWER_LOW;
    SDL_JOYSTICK_POWER_MEDIUM;
    SDL_JOYSTICK_POWER_FULL;
    SDL_JOYSTICK_POWER_WIRED;
    SDL_JOYSTICK_POWER_MAX;
}


//SDL_LockJoysticks :: () #foreign SDL2;
//SDL_UnlockJoysticks :: () #foreign SDL2;
SDL_NumJoysticks :: () -> s32 #foreign SDL2;
SDL_JoystickNameForIndex :: (device_index: s32) -> *s8 #foreign SDL2;
SDL_JoystickGetDeviceGUID :: (device_index: s32) -> SDL_JoystickGUID #foreign SDL2;
//SDL_JoystickGetDeviceVendor :: (device_index: s32) -> u16 #foreign SDL2;
//SDL_JoystickGetDeviceProduct :: (device_index: s32) -> u16 #foreign SDL2;
//SDL_JoystickGetDeviceProductVersion :: (device_index: s32) -> u16 #foreign SDL2;
//SDL_JoystickGetDeviceType :: (device_index: s32) -> SDL_JoystickType #foreign SDL2;
//SDL_JoystickGetDeviceInstanceID :: (device_index: s32) -> SDL_JoystickID #foreign SDL2;
SDL_JoystickOpen :: (device_index: s32) -> *SDL_Joystick #foreign SDL2;
SDL_JoystickFromInstanceID :: (joyid: SDL_JoystickID) -> *SDL_Joystick #foreign SDL2;
SDL_JoystickName :: (joystick: *SDL_Joystick) -> *s8 #foreign SDL2;
SDL_JoystickGetGUID :: (joystick: *SDL_Joystick) -> SDL_JoystickGUID #foreign SDL2;
//SDL_JoystickGetVendor :: (joystick: *SDL_Joystick) -> u16 #foreign SDL2;
//SDL_JoystickGetProduct :: (joystick: *SDL_Joystick) -> u16 #foreign SDL2;
//SDL_JoystickGetProductVersion :: (joystick: *SDL_Joystick) -> u16 #foreign SDL2;
//SDL_JoystickGetType :: (joystick: *SDL_Joystick) -> SDL_JoystickType #foreign SDL2;
SDL_JoystickGetGUIDString :: (guid: SDL_JoystickGUID, pszGUID: *s8, cbGUID: s32) #foreign SDL2;
SDL_JoystickGetGUIDFromString :: (pchGUID: *s8) -> SDL_JoystickGUID #foreign SDL2;
SDL_JoystickGetAttached :: (joystick: *SDL_Joystick) -> SDL_bool #foreign SDL2;
SDL_JoystickInstanceID :: (joystick: *SDL_Joystick) -> SDL_JoystickID #foreign SDL2;
SDL_JoystickNumAxes :: (joystick: *SDL_Joystick) -> s32 #foreign SDL2;
SDL_JoystickNumBalls :: (joystick: *SDL_Joystick) -> s32 #foreign SDL2;
SDL_JoystickNumHats :: (joystick: *SDL_Joystick) -> s32 #foreign SDL2;
SDL_JoystickNumButtons :: (joystick: *SDL_Joystick) -> s32 #foreign SDL2;
SDL_JoystickUpdate :: () #foreign SDL2;
SDL_JoystickEventState :: (state: s32) -> s32 #foreign SDL2;

SDL_JOYSTICK_AXIS_MAX ::   32767;
SDL_JOYSTICK_AXIS_MIN ::   -32768;

SDL_JoystickGetAxis :: (joystick: *SDL_Joystick, axis: s32) -> s16 #foreign SDL2;
//SDL_JoystickGetAxisInitialState :: (joystick: *SDL_Joystick, axis: s32, state: *s16) -> SDL_bool #foreign SDL2;

SDL_HAT_CENTERED ::    0x00;
SDL_HAT_UP ::          0x01;
SDL_HAT_RIGHT ::       0x02;
SDL_HAT_DOWN ::        0x04;
SDL_HAT_LEFT ::        0x08;
SDL_HAT_RIGHTUP ::     (SDL_HAT_RIGHT|SDL_HAT_UP);
SDL_HAT_RIGHTDOWN ::   (SDL_HAT_RIGHT|SDL_HAT_DOWN);
SDL_HAT_LEFTUP ::      (SDL_HAT_LEFT|SDL_HAT_UP);
SDL_HAT_LEFTDOWN ::    (SDL_HAT_LEFT|SDL_HAT_DOWN);

SDL_JoystickGetHat :: (joystick: *SDL_Joystick, hat: s32) -> u8 #foreign SDL2;
SDL_JoystickGetBall :: (joystick: *SDL_Joystick, ball: s32, dx: *s32, dy: *s32) -> s32 #foreign SDL2;
SDL_JoystickGetButton :: (joystick: *SDL_Joystick, button: s32) -> u8 #foreign SDL2;
SDL_JoystickClose :: (joystick: *SDL_Joystick) #foreign SDL2;
SDL_JoystickCurrentPowerLevel :: (joystick: *SDL_Joystick) -> SDL_JoystickPowerLevel #foreign SDL2;
