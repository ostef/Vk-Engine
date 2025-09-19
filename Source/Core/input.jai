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
} @ModuleAPI

GetRawMouseDelta :: inline () -> Vec2f {
    return g_raw_mouse_delta;
} @ModuleAPI

GetKeyAxisValue :: inline (negative : KeyCode, positive : KeyCode) -> float {
    return cast(float, IsKeyDown(positive))
        - cast(float, IsKeyDown(negative));
} @ModuleAPI

WasKeyDown :: inline (key : KeyCode) -> bool {
    return g_prev_keyboard_state[key];
} @ModuleAPI

IsKeyDown :: inline (key : KeyCode) -> bool {
    return g_keyboard_state[key];
} @ModuleAPI

IsKeyPressed :: inline (key : KeyCode) -> bool {
    return !WasKeyDown(key) && IsKeyDown(key);
} @ModuleAPI

IsKeyReleased :: inline (key : KeyCode) -> bool {
    return WasKeyDown(key) && !IsKeyDown(key);
} @ModuleAPI

WasMouseButtonDown :: inline (button : MouseButton) -> bool {
    return g_prev_mouse_buttons_state[button];
} @ModuleAPI

IsMouseButtonDown :: inline (button : MouseButton) -> bool {
    return g_mouse_buttons_state[button];
} @ModuleAPI

IsMouseButtonPressed :: inline (button : MouseButton) -> bool {
    return !WasMouseButtonDown(button) && IsMouseButtonDown(button);
} @ModuleAPI

IsMouseButtonReleased :: inline (button : MouseButton) -> bool {
    return WasMouseButtonDown(button) && !IsMouseButtonDown(button);
} @ModuleAPI

GetModState :: inline () -> KeyMods {
    result : KeyMods;

    if IsKeyDown(.Shift) {
        result |= .Shift;
    }
    if IsKeyDown(.Ctrl) {
        result |= .Ctrl;
    }
    if IsKeyDown(.Alt) {
        result |= .Alt;
    }
    if IsKeyDown(.Cmd) {
        result |= .Cmd;
    }

    return result;
} @ModuleAPI

GetMousePointPosition :: (window : *SDL_Window) -> x : s32, y : s32 {
    x, y : s32;
    SDL_GetGlobalMouseState(*x, *y);

    win_x, win_y : s32;
    SDL_GetWindowPosition(window, *win_x, *win_y);

    return x - win_x, y - win_y;
} @ModuleAPI

GetMousePixelPosition :: (window : *SDL_Window) -> x : s32, y : s32 {
    x, y := GetMousePointPosition(window);
    scale_factor := GetWindowScaleFactor(window);

    return xx (x * scale_factor), xx (y * scale_factor);
} @ModuleAPI

GetMousePointPositionVector :: (window : *SDL_Window) -> Vec2f {
    x, y := GetMousePointPosition(window);
    return .{xx x, xx y};
} @ModuleAPI

GetMousePixelPositionVector :: (window : *SDL_Window) -> Vec2f {
    x, y := GetMousePixelPosition(window);
    return .{xx x, xx y};
} @ModuleAPI

GetWindowPointSize :: (window : *SDL_Window) -> width : s32, height : s32 {
    w, h : s32;
    SDL_GetWindowSize(window, *w, *h);

    return w, h;
} @ModuleAPI

GetWindowPixelSize :: (window : *SDL_Window) -> width : s32, height : s32 {
    w, h : s32;
    SDL_GetWindowSizeInPixels(window, *w, *h);

    return w, h;
} @ModuleAPI

GetWindowScaleFactor :: (window : *SDL_Window) -> float {
    #if #exists(Window_Scale_Factor_Override) {
        return Window_Scale_Factor_Override;
    } else {
        w := GetWindowPointSize(window);
        w_px := GetWindowPixelSize(window);

        return w_px / cast(float, w);
    }
} @ModuleAPI
