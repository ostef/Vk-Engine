// SDL_event.h

SDL_RELEASED :: 0;
SDL_PRESSED :: 1;

using SDL_EventType :: enum u32 {
    SDL_FIRSTEVENT     :: 0;

    /* Application events */
    SDL_QUIT           :: 0x100;

    /* iOS events */
    SDL_APP_TERMINATING;
    SDL_APP_LOWMEMORY;
    SDL_APP_WILLENTERBACKGROUND;
    SDL_APP_DIDENTERBACKGROUND;
    SDL_APP_WILLENTERFOREGROUND;
    SDL_APP_DIDENTERFOREGROUND;

    SDL_WINDOWEVENT    :: 0x200;
    SDL_SYSWMEVENT;

    /* Keyboard events */
    SDL_KEYDOWN        :: 0x300;
    SDL_KEYUP;
    SDL_TEXTEDITING;
    SDL_TEXTINPUT;
    SDL_KEYMAPCHANGED;

    /* Mouse events */
    SDL_MOUSEMOTION    :: 0x400;
    SDL_MOUSEBUTTONDOWN;
    SDL_MOUSEBUTTONUP;
    SDL_MOUSEWHEEL;

    /* Joystick events */
    SDL_JOYAXISMOTION  :: 0x600;
    SDL_JOYBALLMOTION;
    SDL_JOYHATMOTION;
    SDL_JOYBUTTONDOWN;
    SDL_JOYBUTTONUP;
    SDL_JOYDEVICEADDED;
    SDL_JOYDEVICEREMOVED;

    /* Game controller events */
    SDL_CONTROLLERAXISMOTION  :: 0x650;
    SDL_CONTROLLERBUTTONDOWN;
    SDL_CONTROLLERBUTTONUP;
    SDL_CONTROLLERDEVICEADDED;
    SDL_CONTROLLERDEVICEREMOVED;
    SDL_CONTROLLERDEVICEREMAPPED;

    /* Touch events */
    SDL_FINGERDOWN      :: 0x700;
    SDL_FINGERUP;
    SDL_FINGERMOTION;

    /* Gesture events */
    SDL_DOLLARGESTURE   :: 0x800;
    SDL_DOLLARRECORD;
    SDL_MULTIGESTURE;

    /* Clipboard events */
    SDL_CLIPBOARDUPDATE :: 0x900;

    /* Drag and drop events */
    SDL_DROPFILE        :: 0x1000;
    SDL_DROPTEXT;
    SDL_DROPBEGIN;
    SDL_DROPCOMPLETE;

    /* Audio hotplug events */
    SDL_AUDIODEVICEADDED :: 0x1100;
    SDL_AUDIODEVICEREMOVED;

    /* Render events */
    SDL_RENDER_TARGETS_RESET :: 0x2000;
    SDL_RENDER_DEVICE_RESET;

    /** Events ::SDL_USEREVENT through ::SDL_LASTEVENT are for your use;
     *  and should be allocated with SDL_RegisterEvents()
     */
    SDL_USEREVENT    :: 0x8000;
    SDL_LASTEVENT    :: 0xFFFF;
}


SDL_CommonEvent :: struct {
    type: SDL_EventType;
    timestamp: u32;   // In milliseconds, populated using SDL_GetTicks() 
}

SDL_WindowEvent :: struct {
    type: SDL_EventType;        // SDL_WINDOWEVENT
    timestamp: u32;
    windowID: u32;              // The associated window 
    event: SDL_WindowEventID;   // SDL_WindowEventID 
    padding1: u8;
    padding2: u8;
    padding3: u8;
    data1: s32;             // event dependent data 
    data2: s32;             // event dependent data 
}

SDL_KeyboardEvent :: struct {
    type: SDL_EventType;    // SDL_KEYDOWN or SDL_KEYUP
    timestamp: u32;         // In milliseconds, populated using SDL_GetTicks()
    windowID: u32;          // The window with keyboard focus, if any
    state: u8;              // SDL_PRESSED or SDL_RELEASED
    repeat: u8;             // Non-zero if this is a key repeat
    padding2: u8;
    padding3: u8;
    keysym: SDL_Keysym;     // The key that was pressed or released
}


SDL_TEXTEDITINGEVENT_TEXT_SIZE :: 32;

SDL_TextEditingEvent :: struct {
    type: SDL_EventType;    // SDL_TEXTEDITING
    timestamp: u32;
    windowID: u32;
    text: [SDL_TEXTEDITINGEVENT_TEXT_SIZE] u8;  // The editing text 
    start: s32;                                 // The start cursor of selected editing text 
    length: s32;                                // The length of selected editing text 
}

SDL_TEXTINPUTEVENT_TEXT_SIZE :: 32;

SDL_TextInputEvent :: struct {
    type: SDL_EventType;    // SDL_TEXTINPUT
    timestamp: u32;
    windowID: u32;
    text: [SDL_TEXTINPUTEVENT_TEXT_SIZE] s8;  // The input text 
}

SDL_MouseMotionEvent :: struct {
    type: SDL_EventType;    // SDL_MOUSEMOTION
    timestamp: u32;
    windowID: u32;
    which: u32;             // The mouse instance id, or SDL_TOUCH_MOUSEID 
    state: u32;             // The current button state 
    x: s32;                 // X coordinate, relative to window 
    y: s32;                 // Y coordinate, relative to window 
    xrel: s32;              // The relative motion in the X direction 
    yrel: s32;              // The relative motion in the Y direction 
}

SDL_MouseButtonEvent :: struct {
    type: SDL_EventType;    // SDL_MOUSEBUTTONDOWN or SDL_MOUSEBUTTONUP
    timestamp: u32;
    windowID: u32;
    which: u32;             // The mouse instance id, or SDL_TOUCH_MOUSEID 
    button: u8;             // The mouse button index 
    state: u8;              // ::SDL_PRESSED or ::SDL_RELEASED 
    clicks: u8;             // 1 for single-click, 2 for double-click, etc. 
    padding1: u8;
    x: s32;                 // X coordinate, relative to window 
    y: s32;                 // Y coordinate, relative to window 
}

SDL_MouseWheelEvent :: struct {
    type: SDL_EventType;    // SDL_MOUSEWHEEL
    timestamp: u32;
    windowID: u32;
    which: u32;             // The mouse instance id, or SDL_TOUCH_MOUSEID 
    x: s32;                 // The amount scrolled horizontally, positive to the right and negative to the left 
    y: s32;                 // The amount scrolled vertically, positive away from the user and negative toward the user 
    direction: u32;         // Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back 
}

SDL_JoyAxisEvent :: struct {
    type: SDL_EventType;    // SDL_JOYAXISMOTION
    timestamp: u32;
    which: SDL_JoystickID;  // The joystick instance id 
    axis: u8;               // The joystick axis index 
    padding1: u8;
    padding2: u8;
    padding3: u8;
    value: s16;             // The axis value (range: -32768 to 32767) 
    padding4: u16;    
}

SDL_JoyBallEvent :: struct {
    type: SDL_EventType;    // SDL_JOYBALLMOTION
    timestamp: u32;
    which: SDL_JoystickID;  // The joystick instance id 
    ball: u8;               // The joystick trackball index 
    padding1: u8;
    padding2: u8;
    padding3: u8;
    xrel: s16;              // The relative motion in the X direction 
    yrel: s16;              // The relative motion in the Y direction 
}

SDL_JoyHatEvent :: struct {
    type: SDL_EventType;    // SDL_JOYHATMOTION
    timestamp: u32;
    which: SDL_JoystickID;  // The joystick instance id 
    hat: u8;                // The joystick hat index 
    value: u8;              // The hat position value.
    padding1: u8;
    padding2: u8;
}

SDL_JoyButtonEvent :: struct {
    type: SDL_EventType;    //SDL_JOYBUTTONDOWN or SDL_JOYBUTTONUP
    timestamp: u32;
    which: SDL_JoystickID;  // The joystick instance id 
    button: u8;             // The joystick button index 
    state: u8;              // SDL_PRESSED or SDL_RELEASED 
    padding1: u8;
    padding2: u8;
}

SDL_JoyDeviceEvent :: struct {
    type: SDL_EventType;    // SDL_JOYDEVICEADDED or SDL_JOYDEVICEREMOVED
    timestamp: u32;
    which: s32;             // The joystick device index for the ADDED event, instance id for the REMOVED event 
}

SDL_ControllerAxisEvent :: struct {
    type: SDL_EventType;    // SDL_CONTROLLERAXISMOTION
    timestamp: u32;
    which: SDL_JoystickID;  // The joystick instance id 
    axis: u8;               // The controller axis (SDL_GameControllerAxis) 
    padding1: u8;
    padding2: u8;
    padding3: u8;
    value: s16;             // The axis value (range: -32768 to 32767) 
    padding4: u16;    
}

SDL_ControllerButtonEvent :: struct {
    type: SDL_EventType;    // SDL_CONTROLLERBUTTONDOWN or SDL_CONTROLLERBUTTONUP
    timestamp: u32;
    which: SDL_JoystickID;  // The joystick instance id 
    button: u8;             // The controller button (SDL_GameControllerButton) 
    state: u8;              // SDL_PRESSED or SDL_RELEASED 
    padding1: u8;
    padding2: u8;
}

SDL_ControllerDeviceEvent :: struct {
    type: SDL_EventType;    // SDL_CONTROLLERDEVICEADDED, SDL_CONTROLLERDEVICEREMOVED, or SDL_CONTROLLERDEVICEREMAPPED
    timestamp: u32;
    which: s32;             // The joystick device index for the ADDED event, instance id for the REMOVED or REMAPPED event 
}

SDL_AudioDeviceEvent :: struct {
    type: SDL_EventType;
    timestamp: u32;
    // @@
}

SDL_QuitEvent :: struct {
    type: SDL_EventType;
    timestamp: u32;
    // @@
}

SDL_UserEvent :: struct {
    type: SDL_EventType;
    timestamp: u32;
    // @@
}

SDL_SysWMEvent :: struct {
    type: SDL_EventType;
    timestamp: u32;
    // @@
}

SDL_TouchFingerEvent :: struct {
    type: SDL_EventType;
    timestamp: u32;
    // @@
}

SDL_MultiGestureEvent :: struct {
    type: SDL_EventType;
    timestamp: u32;
    // @@
}

SDL_DollarGestureEvent :: struct {
    type: SDL_EventType;
    timestamp: u32;
    // @@
}

SDL_DropEvent :: struct {
    type:      SDL_EventType; // SDL_DROPBEGIN or SDL_DROPFILE or SDL_DROPTEXT or SDL_DROPCOMPLETE
    timestamp: u32;           // In milliseconds, populated using SDL_GetTicks()
    file:      *u8;           // The file name, which should be freed with SDL_free(), is NULL on begin/complete
    windowID:  u32;           // The window that was dropped on, if any
}


SDL_Event :: union {
    type: SDL_EventType;
    common : SDL_CommonEvent;         // Common event data 
    window : SDL_WindowEvent;         // Window event data 
    key : SDL_KeyboardEvent;          // Keyboard event data 
    edit : SDL_TextEditingEvent;      // Text editing event data 
    text : SDL_TextInputEvent;        // Text input event data 
    motion : SDL_MouseMotionEvent;    // Mouse motion event data 
    button : SDL_MouseButtonEvent;    // Mouse button event data 
    wheel : SDL_MouseWheelEvent;      // Mouse wheel event data 
    jaxis : SDL_JoyAxisEvent;         // Joystick axis event data 
    jball : SDL_JoyBallEvent;         // Joystick ball event data 
    jhat : SDL_JoyHatEvent;           // Joystick hat event data 
    jbutton : SDL_JoyButtonEvent;     // Joystick button event data 
    jdevice : SDL_JoyDeviceEvent;     // Joystick device change event data 
    caxis : SDL_ControllerAxisEvent;      // Game Controller axis event data 
    cbutton : SDL_ControllerButtonEvent;  // Game Controller button event data 
    cdevice : SDL_ControllerDeviceEvent;  // Game Controller device event data 
    adevice : SDL_AudioDeviceEvent;   // Audio device event data 
    quit : SDL_QuitEvent;             // Quit request event data 
    user : SDL_UserEvent;             // Custom event data 
    syswm : SDL_SysWMEvent;           // System dependent window event data 
    tfinger : SDL_TouchFingerEvent;   // Touch finger event data 
    mgesture : SDL_MultiGestureEvent; // Gesture event data 
    dgesture : SDL_DollarGestureEvent; // Gesture event data 
    drop : SDL_DropEvent;             // Drag and drop event data 

    /* This is necessary for ABI compatibility between Visual C++ and GCC
       Visual C++ will respect the push pack pragma and use 52 bytes for
       this structure, and GCC will use the alignment of the largest datatype
       within the union, which is 8 bytes.

       So... we'll add padding to force the size to be 56 bytes for both.
    */
    padding: [56]u8;
}
#assert(size_of(SDL_Event) == 56);


using SDL_eventaction :: enum u32 {
    SDL_ADDEVENT;
    SDL_PEEKEVENT;
    SDL_GETEVENT;
}

SDL_PumpEvents :: () #foreign SDL2;
SDL_PeepEvents :: (events: *SDL_Event, numevents: s32, action: SDL_eventaction, minType: u32, maxType: u32) -> s32 #foreign SDL2;
SDL_HasEvent :: (type: u32) -> SDL_bool #foreign SDL2;
SDL_HasEvents :: (minType: u32, maxType: u32) -> SDL_bool #foreign SDL2;
SDL_FlushEvent :: (type: u32) #foreign SDL2;
SDL_FlushEvents :: (minType: u32, maxType: u32) #foreign SDL2;
SDL_PollEvent :: (event: *SDL_Event) -> s32 #foreign SDL2;
SDL_WaitEvent :: (event: *SDL_Event) -> s32 #foreign SDL2;
SDL_WaitEventTimeout :: (event: *SDL_Event, timeout: s32) -> s32 #foreign SDL2;
SDL_PushEvent :: (event: *SDL_Event) -> s32 #foreign SDL2;

