#scope_module

#import "Common";
#import "SDL";

SDL_free :: (ptr : *void) #foreign SDL2;

ImGui :: #import "ImGui";
Math :: #import "Math";

ImVec2 :: ImGui.ImVec2;

#scope_export

UserData :: struct
{
    jai_context : *#Context;
    window : *SDL_Window;
    time : u64;
    mouse_window_id : u32;
    mouse_buttons_down : int;
    mouse_cursors : [ImGui.MouseCursor.COUNT]*SDL_Cursor;
    pending_mouse_leave_frame : int;
    clipboard_text_data : *u8;
}

GetUserData :: inline () -> *UserData #no_context
{
    return ifx ImGui.GetCurrentContext() then cast(*UserData) ImGui.GetIO().BackendPlatformUserData else null;
}

InitForGL :: (window : *SDL_Window, gl_context : SDL_GLContext)
{
    io := ImGui.GetIO();

    if (io.ConfigFlags_ & .ViewportsEnable) && (io.BackendFlags_ & .PlatformHasViewports)
        InitPlatformInterfaceForGL(window, gl_context);
}

Init :: (window : *SDL_Window)
{
    io := ImGui.GetIO();
    Assert(io.BackendPlatformUserData == null, "Platform implementation already initialized");

    // @Todo: check if we support global mouse position

    data := Alloc(UserData);
    data.jai_context = *context;
    io.BackendPlatformUserData = data;

    #if OS == .WINDOWS
        io.BackendPlatformName = "SDL_Windows";
    else #if OS == .LINUX
        io.BackendPlatformName = "SDL_Linux";
    else #if OS == .MACOS
        io.BackendPlatformName = "SDL_MacOS";

    io.BackendFlags_ |= .HasMouseCursors;
    io.BackendFlags_ |= .HasSetMousePos;
    io.BackendFlags_ |= .PlatformHasViewports;
    #if OS != .MACOS
        io.BackendFlags_ |= .HasMouseHoveredViewport;

    io.SetClipboardTextFn = SetClipboardText;
    io.GetClipboardTextFn = GetClipboardText;
    io.ClipboardUserData = null;

    data.window = window;
    data.mouse_cursors[ImGui.MouseCursor.Arrow] = SDL_CreateSystemCursor(.ARROW);
    data.mouse_cursors[ImGui.MouseCursor.TextInput] = SDL_CreateSystemCursor(.IBEAM);
    data.mouse_cursors[ImGui.MouseCursor.ResizeAll] = SDL_CreateSystemCursor(.SIZEALL);
    data.mouse_cursors[ImGui.MouseCursor.ResizeNS] = SDL_CreateSystemCursor(.SIZENS);
    data.mouse_cursors[ImGui.MouseCursor.ResizeEW] = SDL_CreateSystemCursor(.SIZEWE);
    data.mouse_cursors[ImGui.MouseCursor.ResizeNESW] = SDL_CreateSystemCursor(.SIZENESW);
    data.mouse_cursors[ImGui.MouseCursor.ResizeNWSE] = SDL_CreateSystemCursor(.SIZENWSE);
    data.mouse_cursors[ImGui.MouseCursor.Hand] = SDL_CreateSystemCursor(.HAND);
    data.mouse_cursors[ImGui.MouseCursor.NotAllowed] = SDL_CreateSystemCursor(.NO);

    main_viewport := ImGui.GetMainViewport();
    main_viewport.PlatformHandle = window;
    info : SDL_SysWMinfo;
    SDL_VERSION(*info.version);
    if SDL_GetWindowWMInfo(window, *info)
    {
        #if OS == .WINDOWS
            main_viewport.PlatformHandleRaw = info.info.win.window;
        else #if OS == .MACOS
            main_viewport.PlatformHandleRaw = info.info.cocoa.window;
    }

    // Set SDL hint to receive mouse click events on window focus, otherwise SDL doesn't emit the event.
    // Without this, when clicking to gain focus, our widgets wouldn't activate even though they showed as hovered.
    // (This is unfortunately a global SDL setting, so enabling it might have a side-effect on your application.
    // It is unlikely to make a difference, but if your app absolutely needs to ignore the initial on-focus click:
    // you can ignore SDL_MOUSEBUTTONDOWN events coming right after a SDL_WINDOWEVENT_FOCUS_GAINED)
    SDL_SetHint(SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH, "1");

    UpdateMonitors();

    // We need SDL_CaptureMouse(), SDL_GetGlobalMouseState() from SDL 2.0.4+ to support multiple viewports.
    if (io.ConfigFlags_ & .ViewportsEnable) && (io.BackendFlags_ & .PlatformHasViewports)
        InitPlatformInterface(window);
}

Terminate :: ()
{
    data := GetUserData();
    Assert(data != null, "Backend not initialized or already terminated");

    io := ImGui.GetIO();

    TerminatePlatformInterface();

    if data.clipboard_text_data
        SDL_free(data.clipboard_text_data);

    for data.mouse_cursors
        SDL_FreeCursor(it);

    io.BackendPlatformName = null;
    io.BackendPlatformUserData = null;
    Free(data);
}

UpdateKeyModifiers :: inline (mods : SDL_Keymod)
{
    io := ImGui.GetIO();
    io.AddKeyEvent(io, .ModCtrl, (mods & KMOD_CTRL) != 0);
    io.AddKeyEvent(io, .ModShift, (mods & KMOD_SHIFT) != 0);
    io.AddKeyEvent(io, .ModAlt, (mods & KMOD_ALT) != 0);
    io.AddKeyEvent(io, .ModSuper, (mods & KMOD_GUI) != 0);
}

HandleWindowEvent :: (event : SDL_Event) -> handled : bool
{
    io := ImGui.GetIO();
    data := GetUserData();

    if event.type ==
    {
    case SDL_MOUSEMOTION;
        mouse_pos := ImVec2.{cast(float) event.motion.x, cast(float) event.motion.y};
        if io.ConfigFlags_ & .ViewportsEnable
        {
            window_x, window_y : s32;
            SDL_GetWindowPosition(SDL_GetWindowFromID(event.motion.windowID), *window_x, *window_y);
            mouse_pos.x += cast(float) window_x;
            mouse_pos.y += cast(float) window_y;
        }

        io.AddMousePosEvent(io, mouse_pos.x, mouse_pos.y);

        return true;

    case SDL_MOUSEWHEEL;
        wheel_x := cast(float) Sign(event.wheel.x);
        wheel_y := cast(float) Sign(event.wheel.y);
        io.AddMouseWheelEvent(io, wheel_x, wheel_y);

        return true;

    case SDL_MOUSEBUTTONDOWN; #through;
    case SDL_MOUSEBUTTONUP;
        mouse_button : s32 = -1;
        if event.button.button == SDL_BUTTON_LEFT then mouse_button = 0;
        if event.button.button == SDL_BUTTON_RIGHT then mouse_button = 1;
        if event.button.button == SDL_BUTTON_MIDDLE then mouse_button = 2;
        if event.button.button == SDL_BUTTON_X1 then mouse_button = 3;
        if event.button.button == SDL_BUTTON_X2 then mouse_button = 4;
        if mouse_button != -1
        {
            io.AddMouseButtonEvent(io, mouse_button, event.type == SDL_MOUSEBUTTONDOWN);
            if event.type == SDL_MOUSEBUTTONDOWN
                data.mouse_buttons_down |= 1 << mouse_button;
            else
                data.mouse_buttons_down &= ~(1 << mouse_button);

            return true;
        }

    case SDL_TEXTINPUT;
        io.AddInputCharactersUTF8(io, cast(*u8) event.text.text.data);

        return true;

    case SDL_KEYDOWN; #through;
    case SDL_KEYUP;
        UpdateKeyModifiers(event.key.keysym.mod);
        key := KeycodeToImGuiKey(event.key.keysym.sym);
        io.AddKeyEvent(io, key, event.type == SDL_KEYDOWN);
        io.SetKeyEventNativeData(io, key, xx event.key.keysym.sym, xx event.key.keysym.scancode, xx event.key.keysym.scancode);

        return true;

    case SDL_WINDOWEVENT;
        // - When capturing mouse, SDL will send a bunch of conflicting LEAVE/ENTER event on every mouse move, but the final ENTER tends to be right.
        // - However we won't get a correct LEAVE event for a captured window.
        // - In some cases, when detaching a window from main viewport SDL may send SDL_WINDOWEVENT_ENTER one frame too late,
        //   causing SDL_WINDOWEVENT_LEAVE on previous frame to interrupt drag operation by clear mouse position. This is why
        //   we delay process the SDL_WINDOWEVENT_LEAVE events by one frame. See issue #5012 for details.
        window_event := event.window.event;
        if window_event ==
        {
        case SDL_WINDOWEVENT_ENTER;
            data.mouse_window_id = event.window.windowID;
            data.pending_mouse_leave_frame = 0;

        case SDL_WINDOWEVENT_LEAVE;
            data.pending_mouse_leave_frame = ImGui.GetFrameCount() + 1;

        case SDL_WINDOWEVENT_FOCUS_GAINED;
            io.AddFocusEvent(io, true);

        case SDL_WINDOWEVENT_FOCUS_LOST;
            io.AddFocusEvent(io, false);

        case SDL_WINDOWEVENT_CLOSE; #through;
        case SDL_WINDOWEVENT_MOVED; #through;
        case SDL_WINDOWEVENT_RESIZED;
            viewport := ImGui.FindViewportByPlatformHandle(SDL_GetWindowFromID(event.window.windowID));
            if viewport
            {
                if window_event == SDL_WINDOWEVENT_CLOSE
                    viewport.PlatformRequestClose = true;
                if window_event == SDL_WINDOWEVENT_MOVED
                    viewport.PlatformRequestMove = true;
                if window_event == SDL_WINDOWEVENT_RESIZED
                    viewport.PlatformRequestResize = true;
            }
        }

        return true;
    }

    return false;
}

NewFrame :: (allow_mouse_input := true)
{
    data := GetUserData();
    Assert(data != null, "ImGui platform backend not initialized");

    io := ImGui.GetIO();

    w, h : s32;
    display_w, display_h : s32;
    SDL_GetWindowSize(data.window, *w, *h);
    if SDL_GetWindowFlags(data.window) & SDL_WINDOW_MINIMIZED
    {
        w = 0;
        h = 0;
    }

    SDL_GL_GetDrawableSize(data.window, *display_w, *display_h);

    io.DisplaySize = .{cast(float) w, cast(float) h};
    if w > 0 && h > 0
        io.DisplayFramebufferScale = .{display_w / cast(float) w, display_h / cast(float) h};

    freq := SDL_GetPerformanceFrequency();
    time := SDL_GetPerformanceCounter();

    if data.time > 0
        io.DeltaTime = cast(float) ((time - data.time) / cast(float64) freq);
    else
        io.DeltaTime = 1.0 / 60.0;

    data.time = time;

    if data.pending_mouse_leave_frame && data.pending_mouse_leave_frame >= ImGui.GetFrameCount() && data.mouse_buttons_down == 0
    {
        data.mouse_window_id = 0;
        data.pending_mouse_leave_frame = 0;
        io.AddMousePosEvent(io, -Math.FLOAT32_MAX, -Math.FLOAT32_MAX);
    }

    UpdateMouseData(allow_mouse_input);
    UpdateMouseCursor();
}

UpdateMouseData :: (allow_mouse_input : bool)
{
    data := GetUserData();
    io := ImGui.GetIO();

    if allow_mouse_input
        SDL_CaptureMouse(xx (data.mouse_buttons_down != 0));

    focused_window := SDL_GetKeyboardFocus();
    is_app_focused := focused_window && (data.window == focused_window || ImGui.FindViewportByPlatformHandle(focused_window));

    if !allow_mouse_input
    {
        io.AddMousePosEvent(io, -Math.FLOAT32_MAX, -Math.FLOAT32_MAX);
    }
    else if is_app_focused
    {
        if io.WantSetMousePos
        {
            if io.ConfigFlags_ & .ViewportsEnable
                SDL_WarpMouseGlobal(xx io.MousePos.x, xx io.MousePos.y);
            else
                SDL_WarpMouseInWindow(data.window, xx io.MousePos.x, xx io.MousePos.y);
        }

        if data.mouse_buttons_down == 0
        {
            mouse_x, mouse_y, window_x, window_y : s32;
            SDL_GetGlobalMouseState(*mouse_x, *mouse_y);

            if !(io.ConfigFlags_ & .ViewportsEnable)
            {
                SDL_GetWindowPosition(focused_window, *window_x, *window_y);
                mouse_x -= window_x;
                mouse_y -= window_y;
            }

            io.AddMousePosEvent(io, cast(float) mouse_x, cast(float) mouse_y);
        }
    }

    if io.BackendFlags_ & .HasMouseHoveredViewport
    {
        mouse_viewport_id : ImGui.ID;
        sdl_mouse_window := SDL_GetWindowFromID(data.mouse_window_id);
        if sdl_mouse_window
        {
            mouse_viewport := ImGui.FindViewportByPlatformHandle(sdl_mouse_window);
            if mouse_viewport
                mouse_viewport_id = mouse_viewport.ID_;
        }

        io.AddMouseViewportEvent(io, mouse_viewport_id);
    }
}

UpdateMouseCursor :: ()
{
    io := ImGui.GetIO();
    if io.ConfigFlags_ & .NoMouseCursorChange
        return;

    data := GetUserData();

    imgui_cursor := ImGui.GetMouseCursor();
    if io.MouseDrawCursor || imgui_cursor == .None
    {
        SDL_ShowCursor(0);
    }
    else
    {
        cursor := data.mouse_cursors[xx imgui_cursor];
        if cursor
            SDL_SetCursor(cursor);
        else
            SDL_SetCursor(data.mouse_cursors[xx ImGui.MouseCursor.Arrow]);
        SDL_ShowCursor(1);
    }
}

// FIXME-PLATFORM: SDL doesn't have an event to notify the application of display/monitor changes
UpdateMonitors :: ()
{
    platform_io := ImGui.GetPlatformIO();
    platform_io.Monitors.Size = 0;

    display_count := SDL_GetNumVideoDisplays();
    for n : 0..display_count - 1
    {
        monitor : ImGui.PlatformMonitor;
        r : SDL_Rect = ---;
        SDL_GetDisplayBounds(n, *r);
        monitor.MainPos = ImVec2.{cast(float) r.x, cast(float) r.y};
        monitor.WorkPos = monitor.MainPos;
        monitor.MainSize = ImVec2.{cast(float) r.w, cast(float) r.h};
        monitor.WorkSize = monitor.MainSize;

        dpi := 0.0;
        if !SDL_GetDisplayDPI(n, *dpi, null, null)
            monitor.DpiScale = dpi / 96.0;

        platform_io.Monitors.Push(*platform_io.Monitors, monitor);
    }
}

GetClipboardText :: inline (user_data : *void) -> *u8 #c_call
{
    data := GetUserData();
    if data.clipboard_text_data
        SDL_free(data.clipboard_text_data);

    data.clipboard_text_data = SDL_GetClipboardText();

    return data.clipboard_text_data;
}

SetClipboardText :: inline (user_data : *void, text : *u8) #c_call
{
    SDL_SetClipboardText(text);
}

KeycodeToImGuiKey :: inline (keycode : SDL_Keycode) -> ImGui.Key
{
    if keycode ==
    {
        case SDLK_TAB; return .Tab;
        case SDLK_LEFT; return .LeftArrow;
        case SDLK_RIGHT; return .RightArrow;
        case SDLK_UP; return .UpArrow;
        case SDLK_DOWN; return .DownArrow;
        case SDLK_PAGEUP; return .PageUp;
        case SDLK_PAGEDOWN; return .PageDown;
        case SDLK_HOME; return .Home;
        case SDLK_END; return .End;
        case SDLK_INSERT; return .Insert;
        case SDLK_DELETE; return .Delete;
        case SDLK_BACKSPACE; return .Backspace;
        case SDLK_SPACE; return .Space;
        case SDLK_RETURN; return .Enter;
        case SDLK_ESCAPE; return .Escape;
        case SDLK_QUOTE; return .Apostrophe;
        case SDLK_COMMA; return .Comma;
        case SDLK_MINUS; return .Minus;
        case SDLK_PERIOD; return .Period;
        case SDLK_SLASH; return .Slash;
        case SDLK_SEMICOLON; return .Semicolon;
        case SDLK_EQUALS; return .Equal;
        case SDLK_LEFTBRACKET; return .LeftBracket;
        case SDLK_BACKSLASH; return .Backslash;
        case SDLK_RIGHTBRACKET; return .RightBracket;
        case SDLK_BACKQUOTE; return .GraveAccent;
        case SDLK_CAPSLOCK; return .CapsLock;
        case SDLK_SCROLLLOCK; return .ScrollLock;
        case SDLK_NUMLOCKCLEAR; return .NumLock;
        case SDLK_PRINTSCREEN; return .PrintScreen;
        case SDLK_PAUSE; return .Pause;
        case SDLK_KP_0; return .Keypad0;
        case SDLK_KP_1; return .Keypad1;
        case SDLK_KP_2; return .Keypad2;
        case SDLK_KP_3; return .Keypad3;
        case SDLK_KP_4; return .Keypad4;
        case SDLK_KP_5; return .Keypad5;
        case SDLK_KP_6; return .Keypad6;
        case SDLK_KP_7; return .Keypad7;
        case SDLK_KP_8; return .Keypad8;
        case SDLK_KP_9; return .Keypad9;
        case SDLK_KP_PERIOD; return .KeypadDecimal;
        case SDLK_KP_DIVIDE; return .KeypadDivide;
        case SDLK_KP_MULTIPLY; return .KeypadMultiply;
        case SDLK_KP_MINUS; return .KeypadSubtract;
        case SDLK_KP_PLUS; return .KeypadAdd;
        case SDLK_KP_ENTER; return .KeypadEnter;
        case SDLK_KP_EQUALS; return .KeypadEqual;
        case SDLK_LCTRL; return .LeftCtrl;
        case SDLK_LSHIFT; return .LeftShift;
        case SDLK_LALT; return .LeftAlt;
        case SDLK_LGUI; return .LeftSuper;
        case SDLK_RCTRL; return .RightCtrl;
        case SDLK_RSHIFT; return .RightShift;
        case SDLK_RALT; return .RightAlt;
        case SDLK_RGUI; return .RightSuper;
        case SDLK_APPLICATION; return .Menu;
        case SDLK_0; return ._0;
        case SDLK_1; return ._1;
        case SDLK_2; return ._2;
        case SDLK_3; return ._3;
        case SDLK_4; return ._4;
        case SDLK_5; return ._5;
        case SDLK_6; return ._6;
        case SDLK_7; return ._7;
        case SDLK_8; return ._8;
        case SDLK_9; return ._9;
        case SDLK_a; return .A;
        case SDLK_b; return .B;
        case SDLK_c; return .C;
        case SDLK_d; return .D;
        case SDLK_e; return .E;
        case SDLK_f; return .F;
        case SDLK_g; return .G;
        case SDLK_h; return .H;
        case SDLK_i; return .I;
        case SDLK_j; return .J;
        case SDLK_k; return .K;
        case SDLK_l; return .L;
        case SDLK_m; return .M;
        case SDLK_n; return .N;
        case SDLK_o; return .O;
        case SDLK_p; return .P;
        case SDLK_q; return .Q;
        case SDLK_r; return .R;
        case SDLK_s; return .S;
        case SDLK_t; return .T;
        case SDLK_u; return .U;
        case SDLK_v; return .V;
        case SDLK_w; return .W;
        case SDLK_x; return .X;
        case SDLK_y; return .Y;
        case SDLK_z; return .Z;
        case SDLK_F1; return .F1;
        case SDLK_F2; return .F2;
        case SDLK_F3; return .F3;
        case SDLK_F4; return .F4;
        case SDLK_F5; return .F5;
        case SDLK_F6; return .F6;
        case SDLK_F7; return .F7;
        case SDLK_F8; return .F8;
        case SDLK_F9; return .F9;
        case SDLK_F10; return .F10;
        case SDLK_F11; return .F11;
        case SDLK_F12; return .F12;
    }

    return .None;
}


//--------------------------------------------------------------------------------------------------------
// MULTI-VIEWPORT / PLATFORM INTERFACE SUPPORT
// This is an _advanced_ and _optional_ feature, allowing the backend to create and handle multiple viewports simultaneously.
// If you are new to dear imgui or creating a new binding for dear imgui, it is recommended that you completely ignore this section first..
//--------------------------------------------------------------------------------------------------------

// Helper structure we store in the void* RenderUserData field of each ImGuiViewport to easily retrieve our backend data.
ViewportData :: struct
{
    window : *SDL_Window;
    window_id : u32;
    window_owned : bool;
    gl_context : SDL_GLContext;
}

CreateWindow :: (viewport : *ImGui.Viewport) #c_call
{
    data := GetUserData();

    ctx := data.jai_context.*;
    push_context ctx
    {
        vp_data := Alloc(ViewportData);
        viewport.PlatformUserData = vp_data;

        main_viewport := ImGui.GetMainViewport();
        main_viewport_data := cast(*ViewportData) main_viewport.PlatformUserData;

        // Share GL resources with main context
        backup_context := SDL_GL_GetCurrentContext();
        SDL_GL_SetAttribute(SDL_GL_SHARE_WITH_CURRENT_CONTEXT, 1);
        SDL_GL_MakeCurrent(main_viewport_data.window, main_viewport_data.gl_context);

        sdl_flags : SDL_WindowFlags;
        sdl_flags |= SDL_WINDOW_OPENGL;
        sdl_flags |= SDL_GetWindowFlags(data.window) & SDL_WINDOW_ALLOW_HIGHDPI;
        sdl_flags |= SDL_WINDOW_HIDDEN;
        if viewport.Flags & .NoDecoration
            sdl_flags |= SDL_WINDOW_BORDERLESS;
        else
            sdl_flags |= SDL_WINDOW_RESIZABLE;

        #if OS == .WINDOWS
        {
            if viewport.Flags & .NoTaskBarIcon
                sdl_flags |= SDL_WINDOW_SKIP_TASKBAR;
        }

        if viewport.Flags & .TopMost
            sdl_flags |= SDL_WINDOW_ALWAYS_ON_TOP;

        vp_data.window = SDL_CreateWindow("Untitled", xx viewport.Pos.x, xx viewport.Pos.y, xx viewport.Size.x, xx viewport.Size.y, sdl_flags);
        vp_data.window_owned = true;
        vp_data.gl_context = SDL_GL_CreateContext(vp_data.window);
        SDL_GL_SetSwapInterval(0);
        if backup_context
            SDL_GL_MakeCurrent(vp_data.window, backup_context);

        viewport.PlatformHandle = vp_data.window;
        info : SDL_SysWMinfo;
        SDL_VERSION(*info.version);
        if SDL_GetWindowWMInfo(vp_data.window, *info)
        {
            #if OS == .WINDOWS
                viewport.PlatformHandleRaw = info.info.win.window;
            else #if OS == .MACOS
                viewport.PlatformHandleRaw = info.info.cocoa.window;
        }
    }
}

DestroyWindow :: (viewport : *ImGui.Viewport) #c_call
{
    data := GetUserData();

    ctx := data.jai_context.*;
    push_context ctx
    {
        vp_data := cast(*ViewportData) viewport.PlatformUserData;
        if vp_data
        {
            if vp_data.gl_context && vp_data.window_owned
                SDL_GL_DeleteContext(vp_data.gl_context);
            if vp_data.window && vp_data.window_owned
                SDL_DestroyWindow(vp_data.window);

            vp_data.gl_context = null;
            vp_data.window = null;
            Free(vp_data);
        }

        viewport.PlatformUserData = null;
        viewport.PlatformHandle = null;
    }
}

ShowWindow :: (viewport : *ImGui.Viewport) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    SDL_ShowWindow(vp_data.window);
}

#if OS == .MACOS || OS == .LINUX // #cpp_return_type_is_non_pod is not set on MacOS for some reason
{

GetWindowPos :: (viewport : *ImGui.Viewport) -> ImVec2 #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    x, y : s32;
    SDL_GetWindowPosition(vp_data.window, *x, *y);

    return .{xx x, xx y};
}

GetWindowSize :: (viewport : *ImGui.Viewport) -> ImVec2 #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    w, h : s32;
    SDL_GetWindowSize(vp_data.window, *w, *h);

    return .{xx w, xx h};
}

}
else
{

GetWindowPos :: (viewport : *ImGui.Viewport) -> ImVec2 #c_call #cpp_return_type_is_non_pod
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    x, y : s32;
    SDL_GetWindowPosition(vp_data.window, *x, *y);

    return .{xx x, xx y};
}

GetWindowSize :: (viewport : *ImGui.Viewport) -> ImVec2 #c_call #cpp_return_type_is_non_pod
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    w, h : s32;
    SDL_GetWindowSize(vp_data.window, *w, *h);

    return .{xx w, xx h};
}

}

SetWindowPos :: (viewport : *ImGui.Viewport, pos : ImVec2) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    SDL_SetWindowPosition(vp_data.window, xx pos.x, xx pos.y);
}

SetWindowSize :: (viewport : *ImGui.Viewport, size : ImVec2) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    SDL_SetWindowSize(vp_data.window, xx size.x, xx size.y);
}

SetWindowTitle :: (viewport : *ImGui.Viewport, title : *u8) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    SDL_SetWindowTitle(vp_data.window, title);
}

SetWindowFocus :: (viewport : *ImGui.Viewport) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    SDL_RaiseWindow(vp_data.window);
}

GetWindowFocus :: (viewport : *ImGui.Viewport) -> bool #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    return (SDL_GetWindowFlags(vp_data.window) & SDL_WINDOW_INPUT_FOCUS) != 0;
}

GetWindowMinimized :: (viewport : *ImGui.Viewport) -> bool #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    return (SDL_GetWindowFlags(vp_data.window) & SDL_WINDOW_MINIMIZED) != 0;
}

RenderWindow :: (viewport : *ImGui.Viewport, *void) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    if vp_data.gl_context
        SDL_GL_MakeCurrent(vp_data.window, vp_data.gl_context);
}

SwapBuffers :: (viewport : *ImGui.Viewport, *void) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    if vp_data.gl_context
    {
        SDL_GL_MakeCurrent(vp_data.window, vp_data.gl_context);
        SDL_GL_SwapWindow(vp_data.window);
    }
}

InitPlatformInterfaceForGL :: inline (window : *SDL_Window, gl_context : SDL_GLContext)
{
    using platform_io := ImGui.GetPlatformIO();
    Platform_RenderWindow = RenderWindow;
    Platform_SwapBuffers = SwapBuffers;

    main_viewport := ImGui.GetMainViewport();
    vp_data := cast(*ViewportData, main_viewport.PlatformUserData);
    Assert(vp_data != null);

    vp_data.gl_context = gl_context;
}

InitPlatformInterface :: inline (window : *SDL_Window)
{
    using platform_io := ImGui.GetPlatformIO();
    Platform_CreateWindow = CreateWindow;
    Platform_DestroyWindow = DestroyWindow;
    Platform_ShowWindow = ShowWindow;
    Platform_SetWindowPos = SetWindowPos;
    Platform_GetWindowPos = GetWindowPos;
    Platform_SetWindowSize = SetWindowSize;
    Platform_GetWindowSize = GetWindowSize;
    Platform_SetWindowFocus = SetWindowFocus;
    Platform_GetWindowFocus = GetWindowFocus;
    Platform_GetWindowMinimized = GetWindowMinimized;
    Platform_SetWindowTitle = SetWindowTitle;

    vp_data := Alloc(ViewportData);
    vp_data.window = window;
    vp_data.window_id = SDL_GetWindowID(window);
    vp_data.window_owned = false;

    main_viewport := ImGui.GetMainViewport();
    main_viewport.PlatformUserData = vp_data;
    main_viewport.PlatformHandle = window;
}

TerminatePlatformInterface :: inline ()
{
    ImGui.DestroyPlatformWindows();

    using platform_io := ImGui.GetPlatformIO();
    Platform_CreateWindow = null;
    Platform_DestroyWindow = null;
    Platform_ShowWindow = null;
    Platform_SetWindowPos = null;
    Platform_GetWindowPos = null;
    Platform_SetWindowSize = null;
    Platform_GetWindowSize = null;
    Platform_SetWindowFocus = null;
    Platform_GetWindowFocus = null;
    Platform_GetWindowMinimized = null;
    Platform_SetWindowTitle = null;
    Platform_RenderWindow = null;
    Platform_SwapBuffers = null;

    main_viewport := ImGui.GetMainViewport();
    Free(main_viewport.PlatformUserData);
    main_viewport.PlatformUserData = null;
}

// Useful for hot-reloaded code, that needs to update function pointers to the newly loaded library
ReloadAllCallbacks :: () {
    io := ImGui.GetIO();

    io.SetClipboardTextFn = SetClipboardText;
    io.GetClipboardTextFn = GetClipboardText;

    if (io.ConfigFlags_ & .ViewportsEnable) && (io.BackendFlags_ & .PlatformHasViewports)
    {
        using platform_io := ImGui.GetPlatformIO();
        Platform_CreateWindow = CreateWindow;
        Platform_DestroyWindow = DestroyWindow;
        Platform_ShowWindow = ShowWindow;
        Platform_SetWindowPos = SetWindowPos;
        Platform_GetWindowPos = GetWindowPos;
        Platform_SetWindowSize = SetWindowSize;
        Platform_GetWindowSize = GetWindowSize;
        Platform_SetWindowFocus = SetWindowFocus;
        Platform_GetWindowFocus = GetWindowFocus;
        Platform_GetWindowMinimized = GetWindowMinimized;
        Platform_SetWindowTitle = SetWindowTitle;
    }
}
