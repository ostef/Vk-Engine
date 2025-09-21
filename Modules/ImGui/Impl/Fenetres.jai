#module_parameters(Graphics_Backend := GraphicsBackend.OpenGL) {
    GraphicsBackend :: enum
    {
        None;
        OpenGL;
    }
}

#import "Common";

#scope_module

Fenetres :: #import "Fenetres";

#if Graphics_Backend == .OpenGL
    Fenetres_GL :: #import "Fenetres/GL";

ImGui :: #import "ImGui";
Math :: #import "Math";

ImVec2 :: ImGui.ImVec2;

#scope_export

UserData :: struct
{
    jai_context : *#Context;
    window : *Fenetres.Window;
    mouse_window : *Fenetres.Window;
    mouse_buttons_down : int;
    pending_mouse_leave_frame : int;
    clipboard_text : string;
    want_update_monitors : bool;
}

GetUserData :: inline () -> *UserData #no_context
{
    return ifx ImGui.GetCurrentContext() then cast(*UserData) ImGui.GetIO().BackendPlatformUserData else null;
}

#if Graphics_Backend == .OpenGL
{

InitForGL :: (window : *Fenetres.Window, gl_context : Fenetres_GL.GLContext)
{
    Init(window);

    // @Todo: make sure Fenetres behaves correctly for this:
    // Set SDL hint to receive mouse click events on window focus, otherwise SDL doesn't emit the event.
    // Without this, when clicking to gain focus, our widgets wouldn't activate even though they showed as hovered.
    // (This is unfortunately a global SDL setting, so enabling it might have a side-effect on your application.
    // It is unlikely to make a difference, but if your app absolutely needs to ignore the initial on-focus click:
    // you can ignore SDL_MOUSEBUTTONDOWN events coming right after a SDL_WINDOWEVENT_FOCUS_GAINED)
    // SDL_SetHint(SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH, "1");

    // if (io.ConfigFlags_ & .ViewportsEnable) && (io.BackendFlags_ & .PlatformHasViewports)
        InitPlatformInterfaceForGL(window, gl_context);
}

}

Init :: (window : *Fenetres.Window)
{
    io := ImGui.GetIO();
    Assert(io.BackendPlatformUserData == null, "Platform implementation already initialized");

    data := Alloc(UserData);
    data.jai_context = *context;
    io.BackendPlatformUserData = data;

    #if OS == .WINDOWS
        io.BackendPlatformName = "Fenetres_Windows";
    else #if OS == .LINUX
        io.BackendPlatformName = "Fenetres_Linux";
    else #if OS == .MACOS
        io.BackendPlatformName = "Fenetres_MacOS";

    io.BackendFlags_ |= .HasMouseCursors;
    io.BackendFlags_ |= .HasSetMousePos;
    io.BackendFlags_ |= .PlatformHasViewports;
    #if OS != .MACOS
        io.BackendFlags_ |= .HasMouseHoveredViewport;

    io.SetClipboardTextFn = SetClipboardText;
    io.GetClipboardTextFn = GetClipboardText;
    io.ClipboardUserData = null;

    data.window = window;
    data.want_update_monitors = true;

    main_viewport := ImGui.GetMainViewport();
    main_viewport.PlatformHandle = window;
    main_viewport.PlatformHandleRaw = xx Fenetres.GetPlatformHandle(window);
    InitPlatformInterfaceNoGraphicsBackend(window);
}

Terminate :: ()
{
    data := GetUserData();
    Assert(data != null, "Backend not initialized or already terminated");

    io := ImGui.GetIO();

    TerminatePlatformInterface();

    if data.clipboard_text.data
        Free(data.clipboard_text.data);

    io.BackendPlatformName = null;
    io.BackendPlatformUserData = null;
    Free(data);
}

UpdateKeyModifiers :: inline (mods : Fenetres.KeyMods)
{
    io := ImGui.GetIO();
    io.AddKeyEvent(io, .ModCtrl, (mods & .Ctrl) != 0);
    io.AddKeyEvent(io, .ModShift, (mods & .Shift) != 0);
    io.AddKeyEvent(io, .ModAlt, (mods & .Alt) != 0);
}

HandleWindowMessage :: (msg : Fenetres.Message, ignore_mouse_move := false) -> handled : bool
{
    io := ImGui.GetIO();
    data := GetUserData();

    if msg.kind ==
    {
    case .Mouse_Moved;
        if !ignore_mouse_move
        {
            mouse_pos := ImVec2.{cast(float) msg.mouse_x, cast(float) msg.mouse_y};
            if io.ConfigFlags_ & .ViewportsEnable
            {
                window_x, window_y := Fenetres.GetViewportPosition(msg.window);
                mouse_pos.x += cast(float) window_x;
                mouse_pos.y += cast(float) window_y;
            }

            io.AddMousePosEvent(io, mouse_pos.x, mouse_pos.y);

            return true;
        }

    case .Mouse_Wheel;
        io.AddMouseWheelEvent(io, msg.mouse_wheel_x, msg.mouse_wheel_y);

        return true;

    case .Mouse_Button_Pressed; #through;
    case .Mouse_Button_Repeated; #through;
    case .Mouse_Button_Released;
        mouse_button : ImGui.MouseButton;
        if msg.mouse_button ==
        {
        case .Left; mouse_button = .Left;
        case .Right; mouse_button = .Right;
        case .Middle; mouse_button = .Middle;
        }

        io.AddMouseButtonEvent(io, xx mouse_button, msg.kind != .Mouse_Button_Released);
        if msg.kind == .Mouse_Button_Released
            data.mouse_buttons_down &= ~(1 << mouse_button);
        else
            data.mouse_buttons_down |= 1 << mouse_button;

        return true;

    case .Text_Input;
        io.AddInputCharacter(io, msg.codepoint);

        return true;

    case .Key_Pressed; #through;
    case .Key_Released;
        UpdateKeyModifiers(msg.mods);
        io.AddKeyEvent(io, KeycodeToImGuiKey(msg.key_code), msg.kind != .Key_Released);

        return true;

    // - When capturing mouse, SDL will send a bunch of conflicting LEAVE/ENTER msg on every mouse move, but the final ENTER tends to be right.
    // - However we won't get a correct LEAVE msg for a captured window.
    // - In some cases, when detaching a window from main viewport SDL may send SDL_WINDOWEVENT_ENTER one frame too late,
    //   causing SDL_WINDOWEVENT_LEAVE on previous frame to interrupt drag operation by clear mouse position. This is why
    //   we delay process the SDL_WINDOWEVENT_LEAVE msgs by one frame. See issue #5012 for details.
    case .Mouse_Entered_Window;
        data.mouse_window = msg.window;
        data.pending_mouse_leave_frame = 0;
        return true;

    case .Mouse_Left_Window;
        data.pending_mouse_leave_frame = ImGui.GetFrameCount() + 1;
        return true;

    case .Window_Received_Focus;
        io.AddFocusEvent(io, true);

        return true;

    case .Window_Lost_Focus;
        io.AddFocusEvent(io, false);
        return true;

    case .Window_Closed; #through;
    case .Window_Moved; #through;
    case .Window_Resized;
        viewport := ImGui.FindViewportByPlatformHandle(msg.window);
        if viewport
        {
            if msg.kind == .Window_Closed
                viewport.PlatformRequestClose = true;
            if msg.kind == .Window_Moved
                viewport.PlatformRequestMove = true;
            if msg.kind == .Window_Resized
                viewport.PlatformRequestResize = true;
        }

        return true;

    case .Display_Changed;
        data.want_update_monitors = true;

        return true;
    }

    return false;
}

NewFrame :: (delta_time : float, allow_mouse_input := true)
{
    data := GetUserData();
    Assert(data != null, "ImGui platform backend not initialized");

    io := ImGui.GetIO();

    if data.want_update_monitors
        UpdateMonitors();

    display_w, display_h := Fenetres.GetViewportSize(data.window);
    display_px_w, display_px_h := Fenetres.GetViewportSizeInPixels(data.window);

    if Fenetres.IsMinimized(data.window)
    {
        display_w = 0;
        display_h = 0;
    }

    io.DisplaySize = .{cast(float) display_w, cast(float) display_h};
    if display_w > 0 && display_h > 0
    {
        io.DisplayFramebufferScale = .{
            display_px_w / cast(float) display_w,
            display_px_h / cast(float) display_h,
        };
    }

    if delta_time <= 0
        io.DeltaTime = 1.0 / 60.0;
    else
        io.DeltaTime = delta_time;

    if data.pending_mouse_leave_frame && data.pending_mouse_leave_frame >= ImGui.GetFrameCount() && data.mouse_buttons_down == 0
    {
        data.mouse_window = null;
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

    focused_window := Fenetres.GetFocusedWindow();
    is_app_focused := focused_window && (data.window == focused_window || ImGui.FindViewportByPlatformHandle(focused_window));

    if !allow_mouse_input
    {
        io.AddMousePosEvent(io, -Math.FLOAT32_MAX, -Math.FLOAT32_MAX);
    }
    else if is_app_focused
    {
        Fenetres.SetMouseCapture(focused_window, xx (data.mouse_buttons_down != 0));

        if io.WantSetMousePos
        {
            if io.ConfigFlags_ & .ViewportsEnable
                Fenetres.SetMousePosition(xx io.MousePos.x, xx io.MousePos.y);
            else
                Fenetres.SetMousePosition(data.window, xx io.MousePos.x, xx io.MousePos.y);
        }

        if data.mouse_buttons_down == 0
        {
            mouse_x, mouse_y : s32;

            if io.ConfigFlags_ & .ViewportsEnable
                mouse_x, mouse_y = Fenetres.GetMousePosition();
            else
                mouse_x, mouse_y = Fenetres.GetMousePosition(focused_window);

            io.AddMousePosEvent(io, cast(float) mouse_x, cast(float) mouse_y);
        }
    }

    if io.BackendFlags_ & .HasMouseHoveredViewport
    {
        mouse_viewport_id : ImGui.ID;
        if data.mouse_window
        {
            mouse_viewport := ImGui.FindViewportByPlatformHandle(data.mouse_window);
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
        Fenetres.SetCursor(data.window, .None);
    }
    else
    {
        Fenetres.SetCursor(data.window, ImGuiCursorToSystemCursor(imgui_cursor));
    }
}

UpdateMonitors :: ()
{
    data := GetUserData();
    defer data.want_update_monitors = false;

    platform_io := ImGui.GetPlatformIO();
    platform_io.Monitors.Size = 0;

    for Fenetres.GetDisplays(,,Temp)
    {
        monitor : ImGui.PlatformMonitor;
        monitor.MainPos = ImVec2.{cast(float) it.x, cast(float) it.y};
        monitor.WorkPos = monitor.MainPos;
        monitor.MainSize = ImVec2.{cast(float) it.w, cast(float) it.h};
        monitor.WorkSize = monitor.MainSize;
        monitor.DpiScale = it.dpi / 96.0;

        platform_io.Monitors.Push(*platform_io.Monitors, monitor);
    }
}

GetClipboardText :: inline (user_data : *void) -> *u8 #c_call
{
    data := GetUserData();
    ctx := data.jai_context.*;
    push_context ctx
    {
        if data.clipboard_text.data
            Free(data.clipboard_text.data);

        data.clipboard_text = Fenetres.GetClipboardTextData();

        return data.clipboard_text.data;
    }
}

SetClipboardText :: inline (user_data : *void, text : *u8) #c_call
{
    data := GetUserData();
    ctx := data.jai_context.*;
    push_context ctx
    {
        Fenetres.SetClipboardTextData(MakeString(text));
    }
}

ImGuiCursorToSystemCursor :: (cursor : ImGui.MouseCursor) -> Fenetres.SystemCursor
{
    if cursor ==
    {
    case .Arrow;
        return .Arrow;
    case .TextInput;
        return .IBeam;
    case .ResizeAll;
        return .Size;
    case .ResizeNS;
        return .Size_Vertical;
    case .ResizeEW;
        return .Size_Horizontal;
    case .ResizeNESW;
        return .Size_NESW;
    case .ResizeNWSE;
        return .Size_NWSE;
    case .Hand;
        return .Hand;
    case .NotAllowed;
        return .Not_Allowed;
    }

    return .Arrow;
}

KeycodeToImGuiKey :: inline (keycode : Fenetres.KeyCode) -> ImGui.Key
{
    if keycode ==
    {
        case .Tab; return .Tab;
        case .Left; return .LeftArrow;
        case .Right; return .RightArrow;
        case .Up; return .UpArrow;
        case .Down; return .DownArrow;
        case .Page_Up; return .PageUp;
        case .Page_Down; return .PageDown;
        case .Home; return .Home;
        case .End; return .End;
        case .Insert; return .Insert;
        case .Delete; return .Delete;
        case .Backspace; return .Backspace;
        case .Space; return .Space;
        case .Return; return .Enter;
        case .Escape; return .Escape;
        case .Quote; return .Apostrophe;
        case .OEM_Comma; return .Comma;
        case .OEM_Minus; return .Minus;
        case .OEM_Period; return .Period;
        case .Slash; return .Slash;
        case .Semicolon; return .Semicolon;
        case .OEM_Plus; return .Equal;
        case .Open_Bracket; return .LeftBracket;
        case .Backslash; return .Backslash;
        case .Close_Bracket; return .RightBracket;
        case .Backtick; return .GraveAccent;
        case .Caps_Lock; return .CapsLock;
        case .Scroll_Lock; return .ScrollLock;
        case .Num_Lock; return .NumLock;
        case .Print_Screen; return .PrintScreen;
        case .Numpad0; return .Keypad0;
        case .Numpad1; return .Keypad1;
        case .Numpad2; return .Keypad2;
        case .Numpad3; return .Keypad3;
        case .Numpad4; return .Keypad4;
        case .Numpad5; return .Keypad5;
        case .Numpad6; return .Keypad6;
        case .Numpad7; return .Keypad7;
        case .Numpad8; return .Keypad8;
        case .Numpad9; return .Keypad9;
        case .Decimal; return .KeypadDecimal;
        case .Divide; return .KeypadDivide;
        case .Multiply; return .KeypadMultiply;
        case .Subtract; return .KeypadSubtract;
        case .Add; return .KeypadAdd;
        // case .KP_ENTER; return .KeypadEnter;
        // case .KP_EQUALS; return .KeypadEqual;
        case .Ctrl; return .LeftCtrl;
        case .Shift; return .LeftShift;
        case .Alt; return .LeftAlt;
        case .Left_Ctrl; return .LeftCtrl;
        case .Left_Shift; return .LeftShift;
        case .Left_Alt; return .LeftAlt;
        case .Left_Super; return .LeftSuper;
        case .Right_Ctrl; return .RightCtrl;
        case .Right_Shift; return .RightShift;
        case .Right_Alt; return .RightAlt;
        case .Right_Super; return .RightSuper;
        // case .APPLICATION; return .Menu;
        case .Zero; return ._0;
        case .One; return ._1;
        case .Two; return ._2;
        case .Three; return ._3;
        case .Four; return ._4;
        case .Five; return ._5;
        case .Six; return ._6;
        case .Seven; return ._7;
        case .Eight; return ._8;
        case .Nine; return ._9;
        case .A; return .A;
        case .B; return .B;
        case .C; return .C;
        case .D; return .D;
        case .E; return .E;
        case .F; return .F;
        case .G; return .G;
        case .H; return .H;
        case .I; return .I;
        case .J; return .J;
        case .K; return .K;
        case .L; return .L;
        case .M; return .M;
        case .N; return .N;
        case .O; return .O;
        case .P; return .P;
        case .Q; return .Q;
        case .R; return .R;
        case .S; return .S;
        case .T; return .T;
        case .U; return .U;
        case .V; return .V;
        case .W; return .W;
        case .X; return .X;
        case .Y; return .Y;
        case .Z; return .Z;
        case .F1; return .F1;
        case .F2; return .F2;
        case .F3; return .F3;
        case .F4; return .F4;
        case .F5; return .F5;
        case .F6; return .F6;
        case .F7; return .F7;
        case .F8; return .F8;
        case .F9; return .F9;
        case .F10; return .F10;
        case .F11; return .F11;
        case .F12; return .F12;
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
    window : *Fenetres.Window;
    window_owned : bool;

    #if Graphics_Backend == .OpenGL
        gl_context : Fenetres_GL.GLContext;
}

GetWindowFlagsFromViewportFlags :: inline (flags : ImGui.ViewportFlags) -> Fenetres.WindowFlags #no_context
{
    result : Fenetres.WindowFlags;
    if flags & .NoDecoration
        result |= .Borderless;
    if flags & .NoTaskBarIcon
        result |= .No_Taskbar_Icon;
    if flags & .TopMost
        result |= .Topmost;

    return result;
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

        create_flags : Fenetres.WindowFlags;
        // @Todo:
        // create_flags |= SDL_GetWindowFlags(data.window) & SDL_WINDOW_ALLOW_HIGHDPI;
        create_flags |= .Hidden;
        create_flags |= GetWindowFlagsFromViewportFlags(viewport.Flags);

        parent_window : *Fenetres.Window;
        if viewport.ParentViewportId
        {
            parent_viewport := ImGui.FindViewportByID(viewport.ParentViewportId);
            if parent_viewport
                parent_window = parent_viewport.PlatformHandle;
        }

        vp_data.window = Fenetres.CreateWindow(
            "Untitled",
            xx viewport.Size.x, xx viewport.Size.y,
            xx viewport.Pos.x, xx viewport.Pos.y,
            create_flags,
            parent_window
        );

        {
            x, y := Fenetres.GetViewportPosition(vp_data.window);
            w, h := Fenetres.GetViewportSize(vp_data.window);
            Assert(x == xx viewport.Pos.x && y == xx viewport.Pos.y);
            Assert(w == xx viewport.Size.x && h == xx viewport.Size.y);
        }

        vp_data.window_owned = true;

        #if Graphics_Backend == .OpenGL
        {
            vp_data.gl_context = Fenetres_GL.CreateContext(vp_data.window, share_context=main_viewport_data.gl_context);

            backup_window := Fenetres_GL.GetCurrentWindow();
            backup_context := Fenetres_GL.GetCurrentContext();

            Fenetres_GL.MakeCurrent(vp_data.window, vp_data.gl_context);

            Fenetres_GL.SetSwapInterval(0);

            Fenetres_GL.MakeCurrent(backup_window, backup_context);
        }

        viewport.PlatformHandle = vp_data.window;
        viewport.PlatformHandleRaw = xx Fenetres.GetPlatformHandle(vp_data.window);
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
            #if Graphics_Backend == .OpenGL
            {
                if vp_data.gl_context && vp_data.window_owned
                    Fenetres_GL.DestroyContext(vp_data.gl_context);
            }

            if vp_data.window && vp_data.window_owned
                Fenetres.DestroyWindow(vp_data.window);

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
    if viewport.Flags & .NoFocusOnAppearing
        Fenetres.SetWindowVisibility(vp_data.window, true);
    else
        Fenetres.ShowAndFocusWindow(vp_data.window);
}

// Why does the binding generator not put #cpp_return_type_is_non_pod? I don't know
#if OS == .MACOS || OS == .LINUX
{
    GetWindowPos :: (viewport : *ImGui.Viewport) -> ImVec2 #c_call
    {

        vp_data := cast(*ViewportData) viewport.PlatformUserData;
        x, y := Fenetres.GetViewportPosition(vp_data.window);

        return .{xx x, xx y};
    }
}
else
{
    GetWindowPos :: (viewport : *ImGui.Viewport) -> ImVec2 #c_call #cpp_return_type_is_non_pod
    {

        vp_data := cast(*ViewportData) viewport.PlatformUserData;
        x, y := Fenetres.GetViewportPosition(vp_data.window);

        return .{xx x, xx y};
    }
}

SetWindowPos :: (viewport : *ImGui.Viewport, pos : ImVec2) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    Fenetres.SetViewportPosition(vp_data.window, xx pos.x, xx pos.y);
}

#if OS == .MACOS || OS == .LINUX
{

GetWindowSize :: (viewport : *ImGui.Viewport) -> ImVec2 #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    w, h := Fenetres.GetViewportSize(vp_data.window);

    return .{xx w, xx h};
}

}
else
{

GetWindowSize :: (viewport : *ImGui.Viewport) -> ImVec2 #c_call #cpp_return_type_is_non_pod
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    w, h := Fenetres.GetViewportSize(vp_data.window);

    return .{xx w, xx h};
}

}

SetWindowSize :: (viewport : *ImGui.Viewport, size : ImVec2) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    Fenetres.SetViewportSize(vp_data.window, xx size.x, xx size.y);
}

SetWindowTitle :: (viewport : *ImGui.Viewport, title : *u8) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;

    ctx : #Context;
    push_context ctx
    {
        Fenetres.SetWindowTitle(vp_data.window, MakeString(title));
    }
}

SetWindowFocus :: (viewport : *ImGui.Viewport) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    Fenetres.SetFocusedWindow(vp_data.window);
}

GetWindowFocus :: (viewport : *ImGui.Viewport) -> bool #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    return Fenetres.IsFocused(vp_data.window);
}

GetWindowMinimized :: (viewport : *ImGui.Viewport) -> bool #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;
    return Fenetres.IsMinimized(vp_data.window);
}

RenderWindow :: (viewport : *ImGui.Viewport, *void) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;

    #if Graphics_Backend == .OpenGL
    {
        if vp_data.gl_context
            Fenetres_GL.MakeCurrent(vp_data.window, vp_data.gl_context);
    }
}

SwapBuffers :: (viewport : *ImGui.Viewport, *void) #c_call
{
    vp_data := cast(*ViewportData) viewport.PlatformUserData;

    #if Graphics_Backend == .OpenGL
        Fenetres_GL.SwapBuffers(vp_data.window);
}

#if Graphics_Backend == .OpenGL
{

InitPlatformInterfaceForGL :: inline (window : *Fenetres.Window, gl_context : Fenetres_GL.GLContext)
{
    InitPlatformInterfaceNoGraphicsBackend(window);

    vp_data := cast(*ViewportData) ImGui.GetMainViewport().PlatformUserData;
    vp_data.gl_context = gl_context;
}

}

InitPlatformInterfaceNoGraphicsBackend :: inline (window : *Fenetres.Window)
{
    main_viewport := ImGui.GetMainViewport();
    if main_viewport.PlatformUserData // Already initialized
        return;

    vp_data := Alloc(ViewportData);
    vp_data.window = window;
    vp_data.window_owned = false;

    main_viewport.PlatformUserData = vp_data;
    main_viewport.PlatformHandle = window;

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
    Platform_RenderWindow = RenderWindow;
    Platform_SwapBuffers = SwapBuffers;
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
