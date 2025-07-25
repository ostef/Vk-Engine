#scope_file

g_prev_keyboard_state : [KeyCode.Count]bool;
g_keyboard_state : [KeyCode.Count]bool;
g_prev_mouse_buttons_state : [MouseButton.Count]bool;
g_mouse_buttons_state : [MouseButton.Count]bool;
g_raw_mouse_delta : Vec2f;
g_mouse_wheel : Vec2f;

#scope_export

UpdateInputState :: () {
    memcpy(g_prev_keyboard_state.data, g_keyboard_state.data, g_prev_keyboard_state.count);
    memcpy(g_prev_mouse_buttons_state.data, g_mouse_buttons_state.data, g_prev_mouse_buttons_state.count);

    g_raw_mouse_delta = .{};
    g_mouse_wheel = .{};
}

HandleInputEvent :: (using event : SDL_Event) {
    if type == {
    case SDL_KEYDOWN; #through;
    case SDL_KEYUP;
        key_code := SDLScancodeToKeyCode(key.keysym.scancode);
        if key_code == .LeftCtrl || key_code == .RightCtrl {
            g_keyboard_state[KeyCode.Ctrl] = key.state == SDL_PRESSED;
        } else if key_code == .LeftShift || key_code == .RightShift {
            g_keyboard_state[KeyCode.Shift] = key.state == SDL_PRESSED;
        } else if key_code == .LeftAlt || key_code == .RightAlt {
            g_keyboard_state[KeyCode.Alt] = key.state == SDL_PRESSED;
        }

        g_keyboard_state[key_code] = key.state == SDL_PRESSED;

    case SDL_MOUSEMOTION;
        g_raw_mouse_delta.x += xx motion.xrel;
        g_raw_mouse_delta.y += xx motion.yrel;

    case SDL_MOUSEBUTTONDOWN;
        g_mouse_buttons_state[SDLMouseButtonToMouseButton(button.button)] = true;

    case SDL_MOUSEBUTTONUP;
        g_mouse_buttons_state[SDLMouseButtonToMouseButton(button.button)] = false;

    case SDL_MOUSEWHEEL;
        g_mouse_wheel.x += xx wheel.x;
        g_mouse_wheel.y += xx wheel.y;
    }
}

GetMouseWheel :: inline () -> Vec2f {
    return g_mouse_wheel;
}

GetRawMouseDelta :: inline () -> Vec2f {
    return g_raw_mouse_delta;
}

GetKeyAxisValue :: inline (negative : KeyCode, positive : KeyCode) -> float {
    return cast(float, IsKeyDown(positive))
        - cast(float, IsKeyDown(negative));
}

WasKeyDown :: inline (key : KeyCode) -> bool {
    return g_prev_keyboard_state[key];
}

IsKeyDown :: inline (key : KeyCode) -> bool {
    return g_keyboard_state[key];
}

IsKeyPressed :: inline (key : KeyCode) -> bool {
    return !WasKeyDown(key) && IsKeyDown(key);
}

IsKeyReleased :: inline (key : KeyCode) -> bool {
    return WasKeyDown(key) && !IsKeyDown(key);
}

WasMouseButtonDown :: inline (button : MouseButton) -> bool {
    return g_prev_mouse_buttons_state[button];
}

IsMouseButtonDown :: inline (button : MouseButton) -> bool {
    return g_mouse_buttons_state[button];
}

IsMouseButtonPressed :: inline (button : MouseButton) -> bool {
    return !WasMouseButtonDown(button) && IsMouseButtonDown(button);
}

IsMouseButtonReleased :: inline (button : MouseButton) -> bool {
    return WasMouseButtonDown(button) && !IsMouseButtonDown(button);
}

KeyCode :: enum u8 {
    Invalid;

    Backspace;
    Tab;
    Return;
    Shift;
    Ctrl;
    Alt;
    Cmd;
    LeftShift;
    RightShift;
    LeftCtrl;
    RightCtrl;
    LeftAlt;
    RightAlt;
    LeftSuper;
    RightSuper;
    LeftCmd;
    RightCmd;
    CapsLock;
    Escape;
    Space;
    Left;
    Up;
    Right;
    Down;
    Insert;
    Delete;
    PageUp;
    PageDown;
    Home;
    End;
    Help;
    PrintScreen;
    ScrollLock;
    Pause;
    Number0;
    Number1;
    Number2;
    Number3;
    Number4;
    Number5;
    Number6;
    Number7;
    Number8;
    Number9;
    A; B; C; D; E; F; G; H; I; J; K; L; M;
    N; O; P; Q; R; S; T; U; V; W; X; Y; Z;
    F1; F2; F3; F4; F5; F6; F7; F8; F9; F10; F11; F12;

    Semicolon;

    Minus;
    Equals;
    Comma;
    Period;
    Slash;
    Backtick;

    OpenBracket;
    CloseBracket;
    Backslash;

    Quote;

    OEM8;
    OEM102;

    Count;
}

SDLScancodeToKeyCode :: (scancode : SDL_Scancode) -> KeyCode {
    if scancode == {
    case .SDL_SCANCODE_UNKNOWN; return .Invalid;
    case .SDL_SCANCODE_A; return .A;
    case .SDL_SCANCODE_B; return .B;
    case .SDL_SCANCODE_C; return .C;
    case .SDL_SCANCODE_D; return .D;
    case .SDL_SCANCODE_E; return .E;
    case .SDL_SCANCODE_F; return .F;
    case .SDL_SCANCODE_G; return .G;
    case .SDL_SCANCODE_H; return .H;
    case .SDL_SCANCODE_I; return .I;
    case .SDL_SCANCODE_J; return .J;
    case .SDL_SCANCODE_K; return .K;
    case .SDL_SCANCODE_L; return .L;
    case .SDL_SCANCODE_M; return .M;
    case .SDL_SCANCODE_N; return .N;
    case .SDL_SCANCODE_O; return .O;
    case .SDL_SCANCODE_P; return .P;
    case .SDL_SCANCODE_Q; return .Q;
    case .SDL_SCANCODE_R; return .R;
    case .SDL_SCANCODE_S; return .S;
    case .SDL_SCANCODE_T; return .T;
    case .SDL_SCANCODE_U; return .U;
    case .SDL_SCANCODE_V; return .V;
    case .SDL_SCANCODE_W; return .W;
    case .SDL_SCANCODE_X; return .X;
    case .SDL_SCANCODE_Y; return .Y;
    case .SDL_SCANCODE_Z; return .Z;
    case .SDL_SCANCODE_1; return .Number1;
    case .SDL_SCANCODE_2; return .Number2;
    case .SDL_SCANCODE_3; return .Number3;
    case .SDL_SCANCODE_4; return .Number4;
    case .SDL_SCANCODE_5; return .Number5;
    case .SDL_SCANCODE_6; return .Number6;
    case .SDL_SCANCODE_7; return .Number7;
    case .SDL_SCANCODE_8; return .Number8;
    case .SDL_SCANCODE_9; return .Number9;
    case .SDL_SCANCODE_0; return .Number0;
    case .SDL_SCANCODE_RETURN; return .Return;
    case .SDL_SCANCODE_ESCAPE; return .Escape;
    case .SDL_SCANCODE_BACKSPACE; return .Backspace;
    case .SDL_SCANCODE_TAB; return .Tab;
    case .SDL_SCANCODE_SPACE; return .Space;
    case .SDL_SCANCODE_MINUS; return .Minus;
    case .SDL_SCANCODE_EQUALS; return .Equals;
    case .SDL_SCANCODE_LEFTBRACKET; return .OpenBracket;
    case .SDL_SCANCODE_RIGHTBRACKET; return .CloseBracket;
    case .SDL_SCANCODE_BACKSLASH; return .Backslash;
    case .SDL_SCANCODE_SEMICOLON; return .Semicolon;
    case .SDL_SCANCODE_APOSTROPHE; return .Quote;
    case .SDL_SCANCODE_GRAVE; return .Backtick;
    case .SDL_SCANCODE_COMMA; return .Comma;
    case .SDL_SCANCODE_PERIOD; return .Period;
    case .SDL_SCANCODE_SLASH; return .Slash;
    case .SDL_SCANCODE_CAPSLOCK; return .CapsLock;
    case .SDL_SCANCODE_F1; return .F1;
    case .SDL_SCANCODE_F2; return .F2;
    case .SDL_SCANCODE_F3; return .F3;
    case .SDL_SCANCODE_F4; return .F4;
    case .SDL_SCANCODE_F5; return .F5;
    case .SDL_SCANCODE_F6; return .F6;
    case .SDL_SCANCODE_F7; return .F7;
    case .SDL_SCANCODE_F8; return .F8;
    case .SDL_SCANCODE_F9; return .F9;
    case .SDL_SCANCODE_F10; return .F10;
    case .SDL_SCANCODE_F11; return .F11;
    case .SDL_SCANCODE_F12; return .F12;
    case .SDL_SCANCODE_PRINTSCREEN; return .PrintScreen;
    case .SDL_SCANCODE_SCROLLLOCK; return .ScrollLock;
    case .SDL_SCANCODE_PAUSE; return .Pause;
    case .SDL_SCANCODE_INSERT; return .Insert;
    case .SDL_SCANCODE_HOME; return .Home;
    case .SDL_SCANCODE_PAGEUP; return .PageUp;
    case .SDL_SCANCODE_DELETE; return .Delete;
    case .SDL_SCANCODE_END; return .End;
    case .SDL_SCANCODE_PAGEDOWN; return .PageDown;
    case .SDL_SCANCODE_RIGHT; return .Right;
    case .SDL_SCANCODE_LEFT; return .Left;
    case .SDL_SCANCODE_DOWN; return .Down;
    case .SDL_SCANCODE_UP; return .Up;
    case .SDL_SCANCODE_LCTRL; return .LeftCtrl;
    case .SDL_SCANCODE_LSHIFT; return .LeftShift;
    case .SDL_SCANCODE_LALT; return .LeftAlt;
    case .SDL_SCANCODE_LGUI; return .LeftSuper;
    case .SDL_SCANCODE_RCTRL; return .RightCtrl;
    case .SDL_SCANCODE_RSHIFT; return .RightShift;
    case .SDL_SCANCODE_RALT; return .RightAlt;
    case .SDL_SCANCODE_RGUI; return .RightSuper;
    case .SDL_SCANCODE_HELP; return .Help;
    }

    return .Invalid;
}

KeyMods :: enum_flags u8 {
    Ctrl;
    Shift;
    Alt;
    Cmd;
    CapsLock;
}

MouseButton :: enum u8 {
    Invalid;
    Left;
    Right;
    Middle;

    Count;
}

SDLMouseButtonToMouseButton :: (button : u8) -> MouseButton {
    if button == {
    case SDL_BUTTON_LEFT; return .Left;
    case SDL_BUTTON_RIGHT; return .Right;
    case SDL_BUTTON_MIDDLE; return .Middle;
    }

    return .Invalid;
}
