//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



IMGUI_VERSION :: "1.90.4";
IMGUI_VERSION_NUM :: 19040;

IMGUI_PAYLOAD_TYPE_COLOR_3F :: "_COL3F";
IMGUI_PAYLOAD_TYPE_COLOR_4F :: "_COL4F";

IM_UNICODE_CODEPOINT_INVALID :: 0xFFFD;

IM_UNICODE_CODEPOINT_MAX :: 0x10FFFF;

IM_COL32_R_SHIFT :: 0;
IM_COL32_G_SHIFT :: 8;
IM_COL32_B_SHIFT :: 16;
IM_COL32_A_SHIFT :: 24;
IM_COL32_A_MASK :: 0xFF000000;

IM_DRAWLIST_TEX_LINES_WIDTH_MAX :: 63;

IMSTB_TEXTEDIT_STRING :: InputTextState;
IMSTB_TEXTEDIT_CHARTYPE :: ImWchar;
IMSTB_TEXTEDIT_GETWIDTH_NEWLINE :: -1.0;
IMSTB_TEXTEDIT_UNDOSTATECOUNT :: 99;
IMSTB_TEXTEDIT_UNDOCHARCOUNT :: 999;

IMSTB_TEXTEDIT_POSITIONTYPE :: s32;

IMGUI_PAYLOAD_TYPE_WINDOW :: "_IMWINDOW";

IM_PI :: 3.14159265358979323846;

IM_NEWLINE :: "\n";

IM_TABSIZE :: 4;

IM_PRId64 :: "lld";
IM_PRIu64 :: "llu";
IM_PRIX64 :: "llX";

IM_DRAWLIST_CIRCLE_AUTO_SEGMENT_MIN :: 4;
IM_DRAWLIST_CIRCLE_AUTO_SEGMENT_MAX :: 512;

IM_DRAWLIST_ARCFAST_TABLE_SIZE :: 48;

IM_DRAWLIST_ARCFAST_SAMPLE_MAX :: IM_DRAWLIST_ARCFAST_TABLE_SIZE;

ImGuiKey_LegacyNativeKey_BEGIN :: 0;
ImGuiKey_LegacyNativeKey_END :: 512;

ImGuiKeyOwner_Any :: cast(ID) 0;
ImGuiKeyOwner_None :: cast,trunc(ID) -1;

ImGuiSelectionUserData_Invalid :: cast,trunc(SelectionUserData) -1;

DOCKING_HOST_DRAW_CHANNEL_BG :: 0;
DOCKING_HOST_DRAW_CHANNEL_FG :: 1;

IMGUI_TABLE_MAX_COLUMNS :: 512;

// Enumerations
// - We don't use strongly typed enums much because they add constraints (can't extend in private code, can't store typed in bit fields, extra casting on iteration)
// - Tip: Use your programming IDE navigation facilities on the names in the _central column_ below to find the actual flags/enum lists!
//   In Visual Studio IDE: CTRL+comma ("Edit.GoToAll") can follow symbols in comments, whereas CTRL+F12 ("Edit.GoToImplementation") cannot.
//   With Visual Assist installed: ALT+G ("VAssistX.GoToImplementation") can also follow symbols in comments.
Key :: enum s32 {
    None                :: 0;
    Tab                 :: 512;
    LeftArrow           :: 513;
    RightArrow          :: 514;
    UpArrow             :: 515;
    DownArrow           :: 516;
    PageUp              :: 517;
    PageDown            :: 518;
    Home                :: 519;
    End                 :: 520;
    Insert              :: 521;
    Delete              :: 522;
    Backspace           :: 523;
    Space               :: 524;
    Enter               :: 525;
    Escape              :: 526;
    LeftCtrl            :: 527;
    LeftShift           :: 528;
    LeftAlt             :: 529;
    LeftSuper           :: 530;
    RightCtrl           :: 531;
    RightShift          :: 532;
    RightAlt            :: 533;
    RightSuper          :: 534;
    Menu                :: 535;
    _0                  :: 536;
    _1                  :: 537;
    _2                  :: 538;
    _3                  :: 539;
    _4                  :: 540;
    _5                  :: 541;
    _6                  :: 542;
    _7                  :: 543;
    _8                  :: 544;
    _9                  :: 545;
    A                   :: 546;
    B                   :: 547;
    C                   :: 548;
    D                   :: 549;
    E                   :: 550;
    F                   :: 551;
    G                   :: 552;
    H                   :: 553;
    I                   :: 554;
    J                   :: 555;
    K                   :: 556;
    L                   :: 557;
    M                   :: 558;
    N                   :: 559;
    O                   :: 560;
    P                   :: 561;
    Q                   :: 562;
    R                   :: 563;
    S                   :: 564;
    T                   :: 565;
    U                   :: 566;
    V                   :: 567;
    W                   :: 568;
    X                   :: 569;
    Y                   :: 570;
    Z                   :: 571;
    F1                  :: 572;
    F2                  :: 573;
    F3                  :: 574;
    F4                  :: 575;
    F5                  :: 576;
    F6                  :: 577;
    F7                  :: 578;
    F8                  :: 579;
    F9                  :: 580;
    F10                 :: 581;
    F11                 :: 582;
    F12                 :: 583;
    F13                 :: 584;
    F14                 :: 585;
    F15                 :: 586;
    F16                 :: 587;
    F17                 :: 588;
    F18                 :: 589;
    F19                 :: 590;
    F20                 :: 591;
    F21                 :: 592;
    F22                 :: 593;
    F23                 :: 594;
    F24                 :: 595;
    Apostrophe          :: 596;
    Comma               :: 597;
    Minus               :: 598;
    Period              :: 599;
    Slash               :: 600;
    Semicolon           :: 601;
    Equal               :: 602;
    LeftBracket         :: 603;
    Backslash           :: 604;
    RightBracket        :: 605;
    GraveAccent         :: 606;
    CapsLock            :: 607;
    ScrollLock          :: 608;
    NumLock             :: 609;
    PrintScreen         :: 610;
    Pause               :: 611;
    Keypad0             :: 612;
    Keypad1             :: 613;
    Keypad2             :: 614;
    Keypad3             :: 615;
    Keypad4             :: 616;
    Keypad5             :: 617;
    Keypad6             :: 618;
    Keypad7             :: 619;
    Keypad8             :: 620;
    Keypad9             :: 621;
    KeypadDecimal       :: 622;
    KeypadDivide        :: 623;
    KeypadMultiply      :: 624;
    KeypadSubtract      :: 625;
    KeypadAdd           :: 626;
    KeypadEnter         :: 627;
    KeypadEqual         :: 628;
    AppBack             :: 629;
    AppForward          :: 630;

    GamepadStart        :: 631;
    GamepadBack         :: 632;
    GamepadFaceLeft     :: 633;
    GamepadFaceRight    :: 634;
    GamepadFaceUp       :: 635;
    GamepadFaceDown     :: 636;
    GamepadDpadLeft     :: 637;
    GamepadDpadRight    :: 638;
    GamepadDpadUp       :: 639;
    GamepadDpadDown     :: 640;
    GamepadL1           :: 641;
    GamepadR1           :: 642;
    GamepadL2           :: 643;
    GamepadR2           :: 644;
    GamepadL3           :: 645;
    GamepadR3           :: 646;
    GamepadLStickLeft   :: 647;
    GamepadLStickRight  :: 648;
    GamepadLStickUp     :: 649;
    GamepadLStickDown   :: 650;
    GamepadRStickLeft   :: 651;
    GamepadRStickRight  :: 652;
    GamepadRStickUp     :: 653;
    GamepadRStickDown   :: 654;

    MouseLeft           :: 655;
    MouseRight          :: 656;
    MouseMiddle         :: 657;
    MouseX1             :: 658;
    MouseX2             :: 659;
    MouseWheelX         :: 660;
    MouseWheelY         :: 661;

    ReservedForModCtrl  :: 662;
    ReservedForModShift :: 663;
    ReservedForModAlt   :: 664;
    ReservedForModSuper :: 665;
    COUNT               :: 666;

    Mod_None            :: 0;
    Mod_Ctrl            :: 4096;
    Mod_Shift           :: 8192;
    Mod_Alt             :: 16384;
    Mod_Super           :: 32768;
    Mod_Shortcut        :: 2048;
    Mod_Mask_           :: 63488;

    NamedKey_BEGIN      :: 512;
    NamedKey_END        :: 666;
    NamedKey_COUNT      :: 154;

    KeysData_SIZE       :: 666;
    KeysData_OFFSET     :: 0;

    ModCtrl             :: 4096;
    ModShift            :: 8192;
    ModAlt              :: 16384;
    ModSuper            :: 32768;

    ImGuiKey_None                :: None;
    ImGuiKey_Tab                 :: Tab;
    ImGuiKey_LeftArrow           :: LeftArrow;
    ImGuiKey_RightArrow          :: RightArrow;
    ImGuiKey_UpArrow             :: UpArrow;
    ImGuiKey_DownArrow           :: DownArrow;
    ImGuiKey_PageUp              :: PageUp;
    ImGuiKey_PageDown            :: PageDown;
    ImGuiKey_Home                :: Home;
    ImGuiKey_End                 :: End;
    ImGuiKey_Insert              :: Insert;
    ImGuiKey_Delete              :: Delete;
    ImGuiKey_Backspace           :: Backspace;
    ImGuiKey_Space               :: Space;
    ImGuiKey_Enter               :: Enter;
    ImGuiKey_Escape              :: Escape;
    ImGuiKey_LeftCtrl            :: LeftCtrl;
    ImGuiKey_LeftShift           :: LeftShift;
    ImGuiKey_LeftAlt             :: LeftAlt;
    ImGuiKey_LeftSuper           :: LeftSuper;
    ImGuiKey_RightCtrl           :: RightCtrl;
    ImGuiKey_RightShift          :: RightShift;
    ImGuiKey_RightAlt            :: RightAlt;
    ImGuiKey_RightSuper          :: RightSuper;
    ImGuiKey_Menu                :: Menu;
    ImGuiKey_0                   :: _0;
    ImGuiKey_1                   :: _1;
    ImGuiKey_2                   :: _2;
    ImGuiKey_3                   :: _3;
    ImGuiKey_4                   :: _4;
    ImGuiKey_5                   :: _5;
    ImGuiKey_6                   :: _6;
    ImGuiKey_7                   :: _7;
    ImGuiKey_8                   :: _8;
    ImGuiKey_9                   :: _9;
    ImGuiKey_A                   :: A;
    ImGuiKey_B                   :: B;
    ImGuiKey_C                   :: C;
    ImGuiKey_D                   :: D;
    ImGuiKey_E                   :: E;
    ImGuiKey_F                   :: F;
    ImGuiKey_G                   :: G;
    ImGuiKey_H                   :: H;
    ImGuiKey_I                   :: I;
    ImGuiKey_J                   :: J;
    ImGuiKey_K                   :: K;
    ImGuiKey_L                   :: L;
    ImGuiKey_M                   :: M;
    ImGuiKey_N                   :: N;
    ImGuiKey_O                   :: O;
    ImGuiKey_P                   :: P;
    ImGuiKey_Q                   :: Q;
    ImGuiKey_R                   :: R;
    ImGuiKey_S                   :: S;
    ImGuiKey_T                   :: T;
    ImGuiKey_U                   :: U;
    ImGuiKey_V                   :: V;
    ImGuiKey_W                   :: W;
    ImGuiKey_X                   :: X;
    ImGuiKey_Y                   :: Y;
    ImGuiKey_Z                   :: Z;
    ImGuiKey_F1                  :: F1;
    ImGuiKey_F2                  :: F2;
    ImGuiKey_F3                  :: F3;
    ImGuiKey_F4                  :: F4;
    ImGuiKey_F5                  :: F5;
    ImGuiKey_F6                  :: F6;
    ImGuiKey_F7                  :: F7;
    ImGuiKey_F8                  :: F8;
    ImGuiKey_F9                  :: F9;
    ImGuiKey_F10                 :: F10;
    ImGuiKey_F11                 :: F11;
    ImGuiKey_F12                 :: F12;
    ImGuiKey_F13                 :: F13;
    ImGuiKey_F14                 :: F14;
    ImGuiKey_F15                 :: F15;
    ImGuiKey_F16                 :: F16;
    ImGuiKey_F17                 :: F17;
    ImGuiKey_F18                 :: F18;
    ImGuiKey_F19                 :: F19;
    ImGuiKey_F20                 :: F20;
    ImGuiKey_F21                 :: F21;
    ImGuiKey_F22                 :: F22;
    ImGuiKey_F23                 :: F23;
    ImGuiKey_F24                 :: F24;
    ImGuiKey_Apostrophe          :: Apostrophe;
    ImGuiKey_Comma               :: Comma;
    ImGuiKey_Minus               :: Minus;
    ImGuiKey_Period              :: Period;
    ImGuiKey_Slash               :: Slash;
    ImGuiKey_Semicolon           :: Semicolon;
    ImGuiKey_Equal               :: Equal;
    ImGuiKey_LeftBracket         :: LeftBracket;
    ImGuiKey_Backslash           :: Backslash;
    ImGuiKey_RightBracket        :: RightBracket;
    ImGuiKey_GraveAccent         :: GraveAccent;
    ImGuiKey_CapsLock            :: CapsLock;
    ImGuiKey_ScrollLock          :: ScrollLock;
    ImGuiKey_NumLock             :: NumLock;
    ImGuiKey_PrintScreen         :: PrintScreen;
    ImGuiKey_Pause               :: Pause;
    ImGuiKey_Keypad0             :: Keypad0;
    ImGuiKey_Keypad1             :: Keypad1;
    ImGuiKey_Keypad2             :: Keypad2;
    ImGuiKey_Keypad3             :: Keypad3;
    ImGuiKey_Keypad4             :: Keypad4;
    ImGuiKey_Keypad5             :: Keypad5;
    ImGuiKey_Keypad6             :: Keypad6;
    ImGuiKey_Keypad7             :: Keypad7;
    ImGuiKey_Keypad8             :: Keypad8;
    ImGuiKey_Keypad9             :: Keypad9;
    ImGuiKey_KeypadDecimal       :: KeypadDecimal;
    ImGuiKey_KeypadDivide        :: KeypadDivide;
    ImGuiKey_KeypadMultiply      :: KeypadMultiply;
    ImGuiKey_KeypadSubtract      :: KeypadSubtract;
    ImGuiKey_KeypadAdd           :: KeypadAdd;
    ImGuiKey_KeypadEnter         :: KeypadEnter;
    ImGuiKey_KeypadEqual         :: KeypadEqual;
    ImGuiKey_AppBack             :: AppBack;
    ImGuiKey_AppForward          :: AppForward;

    ImGuiKey_GamepadStart        :: GamepadStart;
    ImGuiKey_GamepadBack         :: GamepadBack;
    ImGuiKey_GamepadFaceLeft     :: GamepadFaceLeft;
    ImGuiKey_GamepadFaceRight    :: GamepadFaceRight;
    ImGuiKey_GamepadFaceUp       :: GamepadFaceUp;
    ImGuiKey_GamepadFaceDown     :: GamepadFaceDown;
    ImGuiKey_GamepadDpadLeft     :: GamepadDpadLeft;
    ImGuiKey_GamepadDpadRight    :: GamepadDpadRight;
    ImGuiKey_GamepadDpadUp       :: GamepadDpadUp;
    ImGuiKey_GamepadDpadDown     :: GamepadDpadDown;
    ImGuiKey_GamepadL1           :: GamepadL1;
    ImGuiKey_GamepadR1           :: GamepadR1;
    ImGuiKey_GamepadL2           :: GamepadL2;
    ImGuiKey_GamepadR2           :: GamepadR2;
    ImGuiKey_GamepadL3           :: GamepadL3;
    ImGuiKey_GamepadR3           :: GamepadR3;
    ImGuiKey_GamepadLStickLeft   :: GamepadLStickLeft;
    ImGuiKey_GamepadLStickRight  :: GamepadLStickRight;
    ImGuiKey_GamepadLStickUp     :: GamepadLStickUp;
    ImGuiKey_GamepadLStickDown   :: GamepadLStickDown;
    ImGuiKey_GamepadRStickLeft   :: GamepadRStickLeft;
    ImGuiKey_GamepadRStickRight  :: GamepadRStickRight;
    ImGuiKey_GamepadRStickUp     :: GamepadRStickUp;
    ImGuiKey_GamepadRStickDown   :: GamepadRStickDown;

    ImGuiKey_MouseLeft           :: MouseLeft;
    ImGuiKey_MouseRight          :: MouseRight;
    ImGuiKey_MouseMiddle         :: MouseMiddle;
    ImGuiKey_MouseX1             :: MouseX1;
    ImGuiKey_MouseX2             :: MouseX2;
    ImGuiKey_MouseWheelX         :: MouseWheelX;
    ImGuiKey_MouseWheelY         :: MouseWheelY;

    ImGuiKey_ReservedForModCtrl  :: ReservedForModCtrl;
    ImGuiKey_ReservedForModShift :: ReservedForModShift;
    ImGuiKey_ReservedForModAlt   :: ReservedForModAlt;
    ImGuiKey_ReservedForModSuper :: ReservedForModSuper;
    ImGuiKey_COUNT               :: COUNT;

    ImGuiMod_None                :: Mod_None;
    ImGuiMod_Ctrl                :: Mod_Ctrl;
    ImGuiMod_Shift               :: Mod_Shift;
    ImGuiMod_Alt                 :: Mod_Alt;
    ImGuiMod_Super               :: Mod_Super;
    ImGuiMod_Shortcut            :: Mod_Shortcut;
    ImGuiMod_Mask_               :: Mod_Mask_;

    ImGuiKey_NamedKey_BEGIN      :: NamedKey_BEGIN;
    ImGuiKey_NamedKey_END        :: NamedKey_END;
    ImGuiKey_NamedKey_COUNT      :: NamedKey_COUNT;

    ImGuiKey_KeysData_SIZE       :: KeysData_SIZE;
    ImGuiKey_KeysData_OFFSET     :: KeysData_OFFSET;

    ImGuiKey_ModCtrl             :: ModCtrl;
    ImGuiKey_ModShift            :: ModShift;
    ImGuiKey_ModAlt              :: ModAlt;
    ImGuiKey_ModSuper            :: ModSuper;
}

// Enumeration for AddMouseSourceEvent() actual source of Mouse Input data.
// Historically we use "Mouse" terminology everywhere to indicate pointer data, e.g. MousePos, IsMousePressed(), io.AddMousePosEvent()
// But that "Mouse" data can come from different source which occasionally may be useful for application to know about.
// You can submit a change of pointer type using io.AddMouseSourceEvent().
MouseSource :: enum s32 {
    Mouse       :: 0;
    TouchScreen :: 1;
    Pen         :: 2;
    COUNT       :: 3;

    ImGuiMouseSource_Mouse       :: Mouse;
    ImGuiMouseSource_TouchScreen :: TouchScreen;
    ImGuiMouseSource_Pen         :: Pen;
    ImGuiMouseSource_COUNT       :: COUNT;
}

KeyChord :: s32;

ImTextureID :: *void;

ImDrawIdx :: u16;

// Scalar data types
ID :: u32;
ImS8 :: s8;
ImU8 :: u8;
ImS16 :: s16;
ImU16 :: u16;
ImS32 :: s32;
ImU32 :: u32;
ImS64 :: s64;
ImU64 :: u64;

// Character types
// (we generally use UTF-8 encoded string in the API. This is storage specifically for a decoded character used for keyboard input and display)
ImWchar32 :: u32;
ImWchar16 :: u16;

ImWchar :: ImWchar32;

// Callback and functions types
InputTextCallback :: #type (data: *InputTextCallbackData) -> s32 #c_call;
SizeCallback :: #type (data: *SizeCallbackData) -> void #c_call;
MemAllocFunc :: #type (sz: u64, user_data: *void) -> *void #c_call;
MemFreeFunc :: #type (ptr: *void, user_data: *void) -> void #c_call;
//-----------------------------------------------------------------------------
// [SECTION] Dear ImGui end-user API functions
// (Note that ImGui:: being a namespace, you can add extra ImGui:: functions in your own separate file. Please don't modify imgui source files!)
//-----------------------------------------------------------------------------

// Context creation and access
// - Each context create its own ImFontAtlas by default. You may instance one yourself and pass it to CreateContext() to share a font atlas between contexts.
// - DLL users: heaps and globals are not shared across DLL boundaries! You will need to call SetCurrentContext() + SetAllocatorFunctions()
//   for each static/DLL boundary you are calling from. Read "Context and Memory Allocators" section of imgui.cpp for details.
CreateContext :: (shared_font_atlas: *ImFontAtlas = null) -> *Context #foreign imgui "_ZN5ImGui13CreateContextEP11ImFontAtlas";
DestroyContext :: (ctx: *Context = null) -> void #foreign imgui "_ZN5ImGui14DestroyContextEP12ImGuiContext";
GetCurrentContext :: () -> *Context #foreign imgui "_ZN5ImGui17GetCurrentContextEv";
SetCurrentContext :: (ctx: *Context) -> void #foreign imgui "_ZN5ImGui17SetCurrentContextEP12ImGuiContext";

// Main
GetIO :: () -> *IO #foreign imgui "_ZN5ImGui5GetIOEv";
GetStyle :: () -> *Style #foreign imgui "_ZN5ImGui8GetStyleEv";
NewFrame :: () -> void #foreign imgui "_ZN5ImGui8NewFrameEv";
EndFrame :: () -> void #foreign imgui "_ZN5ImGui8EndFrameEv";
Render :: () -> void #foreign imgui "_ZN5ImGui6RenderEv";
GetDrawData :: () -> *ImDrawData #foreign imgui "_ZN5ImGui11GetDrawDataEv";

// Demo, Debug, Information
ShowDemoWindow :: (p_open: *bool = null) -> void #foreign imgui "_ZN5ImGui14ShowDemoWindowEPb";
ShowMetricsWindow :: (p_open: *bool = null) -> void #foreign imgui "_ZN5ImGui17ShowMetricsWindowEPb";
ShowDebugLogWindow :: (p_open: *bool = null) -> void #foreign imgui "_ZN5ImGui18ShowDebugLogWindowEPb";
ShowIDStackToolWindow :: (p_open: *bool = null) -> void #foreign imgui "_ZN5ImGui21ShowIDStackToolWindowEPb";
ShowAboutWindow :: (p_open: *bool = null) -> void #foreign imgui "_ZN5ImGui15ShowAboutWindowEPb";
ShowStyleEditor :: (ref: *Style = null) -> void #foreign imgui "_ZN5ImGui15ShowStyleEditorEP10ImGuiStyle";
ShowStyleSelector :: (label: *u8) -> bool #foreign imgui "_ZN5ImGui17ShowStyleSelectorEPKc";
ShowFontSelector :: (label: *u8) -> void #foreign imgui "_ZN5ImGui16ShowFontSelectorEPKc";
ShowUserGuide :: () -> void #foreign imgui "_ZN5ImGui13ShowUserGuideEv";
GetVersion :: () -> *u8 #foreign imgui "_ZN5ImGui10GetVersionEv";

// Styles
StyleColorsDark :: (dst: *Style = null) -> void #foreign imgui "_ZN5ImGui15StyleColorsDarkEP10ImGuiStyle";
StyleColorsLight :: (dst: *Style = null) -> void #foreign imgui "_ZN5ImGui16StyleColorsLightEP10ImGuiStyle";
StyleColorsClassic :: (dst: *Style = null) -> void #foreign imgui "_ZN5ImGui18StyleColorsClassicEP10ImGuiStyle";

// Windows
// - Begin() = push window to the stack and start appending to it. End() = pop window from the stack.
// - Passing 'bool* p_open != NULL' shows a window-closing widget in the upper-right corner of the window,
//   which clicking will set the boolean to false when clicked.
// - You may append multiple times to the same window during the same frame by calling Begin()/End() pairs multiple times.
//   Some information such as 'flags' or 'p_open' will only be considered by the first call to Begin().
// - Begin() return false to indicate the window is collapsed or fully clipped, so you may early out and omit submitting
//   anything to the window. Always call a matching End() for each Begin() call, regardless of its return value!
//   [Important: due to legacy reason, Begin/End and BeginChild/EndChild are inconsistent with all other functions
//    such as BeginMenu/EndMenu, BeginPopup/EndPopup, etc. where the EndXXX call should only be called if the corresponding
//    BeginXXX function returned true. Begin and BeginChild are the only odd ones out. Will be fixed in a future update.]
// - Note that the bottom of window stack always contains a window called "Debug".
Begin :: (name: *u8, p_open: *bool = null, flags: WindowFlags = .None) -> bool #foreign imgui "_ZN5ImGui5BeginEPKcPbi";
End :: () -> void #foreign imgui "_ZN5ImGui3EndEv";

// Child Windows
// - Use child windows to begin into a self-contained independent scrolling/clipping regions within a host window. Child windows can embed their own child.
// - Before 1.90 (November 2023), the "ImGuiChildFlags child_flags = 0" parameter was "bool border = false".
//   This API is backward compatible with old code, as we guarantee that ImGuiChildFlags_Border == true.
//   Consider updating your old code:
//      BeginChild("Name", size, false)   -> Begin("Name", size, 0); or Begin("Name", size, ImGuiChildFlags_None);
//      BeginChild("Name", size, true)    -> Begin("Name", size, ImGuiChildFlags_Border);
// - Manual sizing (each axis can use a different setting e.g. ImVec2(0.0f, 400.0f)):
//     == 0.0f: use remaining parent window size for this axis.
//      > 0.0f: use specified size for this axis.
//      < 0.0f: right/bottom-align to specified distance from available content boundaries.
// - Specifying ImGuiChildFlags_AutoResizeX or ImGuiChildFlags_AutoResizeY makes the sizing automatic based on child contents.
//   Combining both ImGuiChildFlags_AutoResizeX _and_ ImGuiChildFlags_AutoResizeY defeats purpose of a scrolling region and is NOT recommended.
// - BeginChild() returns false to indicate the window is collapsed or fully clipped, so you may early out and omit submitting
//   anything to the window. Always call a matching EndChild() for each BeginChild() call, regardless of its return value.
//   [Important: due to legacy reason, Begin/End and BeginChild/EndChild are inconsistent with all other functions
//    such as BeginMenu/EndMenu, BeginPopup/EndPopup, etc. where the EndXXX call should only be called if the corresponding
//    BeginXXX function returned true. Begin and BeginChild are the only odd ones out. Will be fixed in a future update.]
BeginChild :: (str_id: *u8, size: *ImVec2, child_flags: ChildFlags = .None, window_flags: WindowFlags = .None) -> bool #foreign imgui "_ZN5ImGui10BeginChildEPKcRK6ImVec2ii";
BeginChild :: (str_id: *u8, size: ImVec2 = ImVec2.{0, 0}, child_flags: ChildFlags = .None, window_flags: WindowFlags = .None) -> bool #no_context {
    return BeginChild(str_id, *size, child_flags, window_flags);
}
BeginChild :: (id: ID, size: *ImVec2, child_flags: ChildFlags = .None, window_flags: WindowFlags = .None) -> bool #foreign imgui "_ZN5ImGui10BeginChildEjRK6ImVec2ii";
BeginChild :: (id: ID, size: ImVec2 = ImVec2.{0, 0}, child_flags: ChildFlags = .None, window_flags: WindowFlags = .None) -> bool #no_context {
    return BeginChild(id, *size, child_flags, window_flags);
}
EndChild :: () -> void #foreign imgui "_ZN5ImGui8EndChildEv";

// Windows Utilities
// - 'current window' = the window we are appending into while inside a Begin()/End() block. 'next window' = next window we will Begin() into.
IsWindowAppearing :: () -> bool #foreign imgui "_ZN5ImGui17IsWindowAppearingEv";
IsWindowCollapsed :: () -> bool #foreign imgui "_ZN5ImGui17IsWindowCollapsedEv";
IsWindowFocused :: (flags: FocusedFlags = .None) -> bool #foreign imgui "_ZN5ImGui15IsWindowFocusedEi";
IsWindowHovered :: (flags: HoveredFlags = .None) -> bool #foreign imgui "_ZN5ImGui15IsWindowHoveredEi";
GetWindowDrawList :: () -> *ImDrawList #foreign imgui "_ZN5ImGui17GetWindowDrawListEv";
GetWindowDpiScale :: () -> float #foreign imgui "_ZN5ImGui17GetWindowDpiScaleEv";
GetWindowPos :: () -> ImVec2 #foreign imgui "_ZN5ImGui12GetWindowPosEv";
GetWindowSize :: () -> ImVec2 #foreign imgui "_ZN5ImGui13GetWindowSizeEv";
GetWindowWidth :: () -> float #foreign imgui "_ZN5ImGui14GetWindowWidthEv";
GetWindowHeight :: () -> float #foreign imgui "_ZN5ImGui15GetWindowHeightEv";
GetWindowViewport :: () -> *Viewport #foreign imgui "_ZN5ImGui17GetWindowViewportEv";

// Window manipulation
// - Prefer using SetNextXXX functions (before Begin) rather that SetXXX functions (after Begin).
SetNextWindowPos :: (pos: *ImVec2, cond: Cond = .None, pivot: *ImVec2) -> void #foreign imgui "_ZN5ImGui16SetNextWindowPosERK6ImVec2iS2_";
SetNextWindowPos :: (pos: ImVec2, cond: Cond = .None, pivot: ImVec2 = ImVec2.{0, 0}) #no_context {
    SetNextWindowPos(*pos, cond, *pivot);
}
SetNextWindowSize :: (size: *ImVec2, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui17SetNextWindowSizeERK6ImVec2i";
SetNextWindowSize :: (size: ImVec2, cond: Cond = .None) #no_context {
    SetNextWindowSize(*size, cond);
}
SetNextWindowSizeConstraints :: (size_min: *ImVec2, size_max: *ImVec2, custom_callback: SizeCallback = null, custom_callback_data: *void = null) -> void #foreign imgui "_ZN5ImGui28SetNextWindowSizeConstraintsERK6ImVec2S2_PFvP21ImGuiSizeCallbackDataEPv";
SetNextWindowSizeConstraints :: (size_min: ImVec2, size_max: ImVec2, custom_callback: SizeCallback = null, custom_callback_data: *void = null) #no_context {
    SetNextWindowSizeConstraints(*size_min, *size_max, custom_callback, custom_callback_data);
}
SetNextWindowContentSize :: (size: *ImVec2) -> void #foreign imgui "_ZN5ImGui24SetNextWindowContentSizeERK6ImVec2";
SetNextWindowContentSize :: (size: ImVec2) #no_context {
    SetNextWindowContentSize(*size);
}
SetNextWindowCollapsed :: (collapsed: bool, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui22SetNextWindowCollapsedEbi";
SetNextWindowFocus :: () -> void #foreign imgui "_ZN5ImGui18SetNextWindowFocusEv";
SetNextWindowScroll :: (scroll: *ImVec2) -> void #foreign imgui "_ZN5ImGui19SetNextWindowScrollERK6ImVec2";
SetNextWindowScroll :: (scroll: ImVec2) #no_context {
    SetNextWindowScroll(*scroll);
}
SetNextWindowBgAlpha :: (alpha: float) -> void #foreign imgui "_ZN5ImGui20SetNextWindowBgAlphaEf";
SetNextWindowViewport :: (viewport_id: ID) -> void #foreign imgui "_ZN5ImGui21SetNextWindowViewportEj";
SetWindowPos :: (pos: *ImVec2, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui12SetWindowPosERK6ImVec2i";
SetWindowPos :: (pos: ImVec2, cond: Cond = .None) #no_context {
    SetWindowPos(*pos, cond);
}
SetWindowSize :: (size: *ImVec2, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui13SetWindowSizeERK6ImVec2i";
SetWindowSize :: (size: ImVec2, cond: Cond = .None) #no_context {
    SetWindowSize(*size, cond);
}
SetWindowCollapsed :: (collapsed: bool, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui18SetWindowCollapsedEbi";
SetWindowFocus :: () -> void #foreign imgui "_ZN5ImGui14SetWindowFocusEv";
SetWindowFontScale :: (scale: float) -> void #foreign imgui "_ZN5ImGui18SetWindowFontScaleEf";
SetWindowPos :: (name: *u8, pos: *ImVec2, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui12SetWindowPosEPKcRK6ImVec2i";
SetWindowPos :: (name: *u8, pos: ImVec2, cond: Cond = .None) #no_context {
    SetWindowPos(name, *pos, cond);
}
SetWindowSize :: (name: *u8, size: *ImVec2, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui13SetWindowSizeEPKcRK6ImVec2i";
SetWindowSize :: (name: *u8, size: ImVec2, cond: Cond = .None) #no_context {
    SetWindowSize(name, *size, cond);
}
SetWindowCollapsed :: (name: *u8, collapsed: bool, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui18SetWindowCollapsedEPKcbi";
SetWindowFocus :: (name: *u8) -> void #foreign imgui "_ZN5ImGui14SetWindowFocusEPKc";

// Content region
// - Retrieve available space from a given point. GetContentRegionAvail() is frequently useful.
// - Those functions are bound to be redesigned (they are confusing, incomplete and the Min/Max return values are in local window coordinates which increases confusion)
GetContentRegionAvail :: () -> ImVec2 #foreign imgui "_ZN5ImGui21GetContentRegionAvailEv";
GetContentRegionMax :: () -> ImVec2 #foreign imgui "_ZN5ImGui19GetContentRegionMaxEv";
GetWindowContentRegionMin :: () -> ImVec2 #foreign imgui "_ZN5ImGui25GetWindowContentRegionMinEv";
GetWindowContentRegionMax :: () -> ImVec2 #foreign imgui "_ZN5ImGui25GetWindowContentRegionMaxEv";

// Windows Scrolling
// - Any change of Scroll will be applied at the beginning of next frame in the first call to Begin().
// - You may instead use SetNextWindowScroll() prior to calling Begin() to avoid this delay, as an alternative to using SetScrollX()/SetScrollY().
GetScrollX :: () -> float #foreign imgui "_ZN5ImGui10GetScrollXEv";
GetScrollY :: () -> float #foreign imgui "_ZN5ImGui10GetScrollYEv";
SetScrollX :: (scroll_x: float) -> void #foreign imgui "_ZN5ImGui10SetScrollXEf";
SetScrollY :: (scroll_y: float) -> void #foreign imgui "_ZN5ImGui10SetScrollYEf";
GetScrollMaxX :: () -> float #foreign imgui "_ZN5ImGui13GetScrollMaxXEv";
GetScrollMaxY :: () -> float #foreign imgui "_ZN5ImGui13GetScrollMaxYEv";
SetScrollHereX :: (center_x_ratio: float = 0.5) -> void #foreign imgui "_ZN5ImGui14SetScrollHereXEf";
SetScrollHereY :: (center_y_ratio: float = 0.5) -> void #foreign imgui "_ZN5ImGui14SetScrollHereYEf";
SetScrollFromPosX :: (local_x: float, center_x_ratio: float = 0.5) -> void #foreign imgui "_ZN5ImGui17SetScrollFromPosXEff";
SetScrollFromPosY :: (local_y: float, center_y_ratio: float = 0.5) -> void #foreign imgui "_ZN5ImGui17SetScrollFromPosYEff";

// Parameters stacks (shared)
PushFont :: (font: *ImFont) -> void #foreign imgui "_ZN5ImGui8PushFontEP6ImFont";
PopFont :: () -> void #foreign imgui "_ZN5ImGui7PopFontEv";
PushStyleColor :: (idx: Col, col: ImU32) -> void #foreign imgui "_ZN5ImGui14PushStyleColorEij";
PushStyleColor :: (idx: Col, col: *ImVec4) -> void #foreign imgui "_ZN5ImGui14PushStyleColorEiRK6ImVec4";
PushStyleColor :: (idx: Col, col: ImVec4) #no_context {
    PushStyleColor(idx, *col);
}
PopStyleColor :: (count: s32 = 1) -> void #foreign imgui "_ZN5ImGui13PopStyleColorEi";
PushStyleVar :: (idx: StyleVar, val: float) -> void #foreign imgui "_ZN5ImGui12PushStyleVarEif";
PushStyleVar :: (idx: StyleVar, val: *ImVec2) -> void #foreign imgui "_ZN5ImGui12PushStyleVarEiRK6ImVec2";
PushStyleVar :: (idx: StyleVar, val: ImVec2) #no_context {
    PushStyleVar(idx, *val);
}
PopStyleVar :: (count: s32 = 1) -> void #foreign imgui "_ZN5ImGui11PopStyleVarEi";
PushTabStop :: (tab_stop: bool) -> void #foreign imgui "_ZN5ImGui11PushTabStopEb";
PopTabStop :: () -> void #foreign imgui "_ZN5ImGui10PopTabStopEv";
PushButtonRepeat :: (repeat: bool) -> void #foreign imgui "_ZN5ImGui16PushButtonRepeatEb";
PopButtonRepeat :: () -> void #foreign imgui "_ZN5ImGui15PopButtonRepeatEv";

// Parameters stacks (current window)
PushItemWidth :: (item_width: float) -> void #foreign imgui "_ZN5ImGui13PushItemWidthEf";
PopItemWidth :: () -> void #foreign imgui "_ZN5ImGui12PopItemWidthEv";
SetNextItemWidth :: (item_width: float) -> void #foreign imgui "_ZN5ImGui16SetNextItemWidthEf";
CalcItemWidth :: () -> float #foreign imgui "_ZN5ImGui13CalcItemWidthEv";
PushTextWrapPos :: (wrap_local_pos_x: float = 0.0) -> void #foreign imgui "_ZN5ImGui15PushTextWrapPosEf";
PopTextWrapPos :: () -> void #foreign imgui "_ZN5ImGui14PopTextWrapPosEv";

// Style read access
// - Use the ShowStyleEditor() function to interactively see/edit the colors.
GetFont :: () -> *ImFont #foreign imgui "_ZN5ImGui7GetFontEv";
GetFontSize :: () -> float #foreign imgui "_ZN5ImGui11GetFontSizeEv";
GetFontTexUvWhitePixel :: () -> ImVec2 #foreign imgui "_ZN5ImGui22GetFontTexUvWhitePixelEv";
GetColorU32 :: (idx: Col, alpha_mul: float = 1.0) -> ImU32 #foreign imgui "_ZN5ImGui11GetColorU32Eif";
GetColorU32 :: (col: *ImVec4) -> ImU32 #foreign imgui "_ZN5ImGui11GetColorU32ERK6ImVec4";
GetColorU32 :: (col: ImVec4) -> ImU32 #no_context {
    return GetColorU32(*col);
}
GetColorU32 :: (col: ImU32, alpha_mul: float = 1.0) -> ImU32 #foreign imgui "_ZN5ImGui11GetColorU32Ejf";
GetStyleColorVec4 :: (idx: Col) -> *ImVec4 #foreign imgui "_ZN5ImGui17GetStyleColorVec4Ei";

// Layout cursor positioning
// - By "cursor" we mean the current output position.
// - The typical widget behavior is to output themselves at the current cursor position, then move the cursor one line down.
// - You can call SameLine() between widgets to undo the last carriage return and output at the right of the preceding widget.
// - Attention! We currently have inconsistencies between window-local and absolute positions we will aim to fix with future API:
//    - Absolute coordinate:        GetCursorScreenPos(), SetCursorScreenPos(), all ImDrawList:: functions. -> this is the preferred way forward.
//    - Window-local coordinates:   SameLine(), GetCursorPos(), SetCursorPos(), GetCursorStartPos(), GetContentRegionMax(), GetWindowContentRegion*(), PushTextWrapPos()
// - GetCursorScreenPos() = GetCursorPos() + GetWindowPos(). GetWindowPos() is almost only ever useful to convert from window-local to absolute coordinates.
GetCursorScreenPos :: () -> ImVec2 #foreign imgui "_ZN5ImGui18GetCursorScreenPosEv";
SetCursorScreenPos :: (pos: *ImVec2) -> void #foreign imgui "_ZN5ImGui18SetCursorScreenPosERK6ImVec2";
SetCursorScreenPos :: (pos: ImVec2) #no_context {
    SetCursorScreenPos(*pos);
}
GetCursorPos :: () -> ImVec2 #foreign imgui "_ZN5ImGui12GetCursorPosEv";
GetCursorPosX :: () -> float #foreign imgui "_ZN5ImGui13GetCursorPosXEv";
GetCursorPosY :: () -> float #foreign imgui "_ZN5ImGui13GetCursorPosYEv";
SetCursorPos :: (local_pos: *ImVec2) -> void #foreign imgui "_ZN5ImGui12SetCursorPosERK6ImVec2";
SetCursorPos :: (local_pos: ImVec2) #no_context {
    SetCursorPos(*local_pos);
}
SetCursorPosX :: (local_x: float) -> void #foreign imgui "_ZN5ImGui13SetCursorPosXEf";
SetCursorPosY :: (local_y: float) -> void #foreign imgui "_ZN5ImGui13SetCursorPosYEf";
GetCursorStartPos :: () -> ImVec2 #foreign imgui "_ZN5ImGui17GetCursorStartPosEv";

// Other layout functions
Separator :: () -> void #foreign imgui "_ZN5ImGui9SeparatorEv";
SameLine :: (offset_from_start_x: float = 0.0, spacing: float = -1.0) -> void #foreign imgui "_ZN5ImGui8SameLineEff";
NewLine :: () -> void #foreign imgui "_ZN5ImGui7NewLineEv";
Spacing :: () -> void #foreign imgui "_ZN5ImGui7SpacingEv";
Dummy :: (size: *ImVec2) -> void #foreign imgui "_ZN5ImGui5DummyERK6ImVec2";
Dummy :: (size: ImVec2) #no_context {
    Dummy(*size);
}
Indent :: (indent_w: float = 0.0) -> void #foreign imgui "_ZN5ImGui6IndentEf";
Unindent :: (indent_w: float = 0.0) -> void #foreign imgui "_ZN5ImGui8UnindentEf";
BeginGroup :: () -> void #foreign imgui "_ZN5ImGui10BeginGroupEv";
EndGroup :: () -> void #foreign imgui "_ZN5ImGui8EndGroupEv";
AlignTextToFramePadding :: () -> void #foreign imgui "_ZN5ImGui23AlignTextToFramePaddingEv";
GetTextLineHeight :: () -> float #foreign imgui "_ZN5ImGui17GetTextLineHeightEv";
GetTextLineHeightWithSpacing :: () -> float #foreign imgui "_ZN5ImGui28GetTextLineHeightWithSpacingEv";
GetFrameHeight :: () -> float #foreign imgui "_ZN5ImGui14GetFrameHeightEv";
GetFrameHeightWithSpacing :: () -> float #foreign imgui "_ZN5ImGui25GetFrameHeightWithSpacingEv";

// ID stack/scopes
// Read the FAQ (docs/FAQ.md or http://dearimgui.com/faq) for more details about how ID are handled in dear imgui.
// - Those questions are answered and impacted by understanding of the ID stack system:
//   - "Q: Why is my widget not reacting when I click on it?"
//   - "Q: How can I have widgets with an empty label?"
//   - "Q: How can I have multiple widgets with the same label?"
// - Short version: ID are hashes of the entire ID stack. If you are creating widgets in a loop you most likely
//   want to push a unique identifier (e.g. object pointer, loop index) to uniquely differentiate them.
// - You can also use the "Label##foobar" syntax within widget label to distinguish them from each others.
// - In this header file we use the "label"/"name" terminology to denote a string that will be displayed + used as an ID,
//   whereas "str_id" denote a string that is only used as an ID and not normally displayed.
PushID :: (str_id: *u8) -> void #foreign imgui "_ZN5ImGui6PushIDEPKc";
PushID :: (str_id_begin: *u8, str_id_end: *u8) -> void #foreign imgui "_ZN5ImGui6PushIDEPKcS1_";
PushID :: (str_id: string) #no_context {
    PushID(str_id.data, str_id.data + str_id.count);
}
PushID :: (ptr_id: *void) -> void #foreign imgui "_ZN5ImGui6PushIDEPKv";
PushID :: (int_id: s32) -> void #foreign imgui "_ZN5ImGui6PushIDEi";
PopID :: () -> void #foreign imgui "_ZN5ImGui5PopIDEv";
GetID :: (str_id: *u8) -> ID #foreign imgui "_ZN5ImGui5GetIDEPKc";
GetID :: (str_id_begin: *u8, str_id_end: *u8) -> ID #foreign imgui "_ZN5ImGui5GetIDEPKcS1_";
GetID :: (str_id: string) -> ID #no_context {
    return GetID(str_id.data, str_id.data + str_id.count);
}
GetID :: (ptr_id: *void) -> ID #foreign imgui "_ZN5ImGui5GetIDEPKv";

// Widgets: Text
TextUnformatted :: (text: *u8, text_end: *u8 = null) -> void #foreign imgui "_ZN5ImGui15TextUnformattedEPKcS1_";
TextUnformatted :: (text: string) #no_context {
    TextUnformatted(text.data, text.data + text.count);
}
Text_CFormat :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "_ZN5ImGui4TextEPKcz";
Text :: (fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    Text_CFormat("%s", formatted_text.data);
} @PrintLike

TextColored_CFormat :: (col: *ImVec4, fmt: *u8, __args: ..Any) -> void #foreign imgui "_ZN5ImGui11TextColoredERK6ImVec4PKcz";
TextColored :: (col: ImVec4, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    TextColored_CFormat(*col, "%s", formatted_text.data);
} @PrintLike

TextDisabled_CFormat :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "_ZN5ImGui12TextDisabledEPKcz";
TextDisabled :: (fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    TextDisabled_CFormat("%s", formatted_text.data);
} @PrintLike

TextWrapped_CFormat :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "_ZN5ImGui11TextWrappedEPKcz";
TextWrapped :: (fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    TextWrapped_CFormat("%s", formatted_text.data);
} @PrintLike

LabelText_CFormat :: (label: *u8, fmt: *u8, __args: ..Any) -> void #foreign imgui "_ZN5ImGui9LabelTextEPKcS1_z";
LabelText :: (label: *u8, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    LabelText_CFormat(label, "%s", formatted_text.data);
} @PrintLike

BulletText_CFormat :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "_ZN5ImGui10BulletTextEPKcz";
BulletText :: (fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    BulletText_CFormat("%s", formatted_text.data);
} @PrintLike

SeparatorText :: (label: *u8) -> void #foreign imgui "_ZN5ImGui13SeparatorTextEPKc";

// Widgets: Main
// - Most widgets return true when the value has been changed or when pressed/selected
// - You may also use one of the many IsItemXXX functions (e.g. IsItemActive, IsItemHovered, etc.) to query widget state.
Button :: (label: *u8, size: *ImVec2) -> bool #foreign imgui "_ZN5ImGui6ButtonEPKcRK6ImVec2";
Button :: (label: *u8, size: ImVec2 = ImVec2.{0, 0}) -> bool #no_context {
    return Button(label, *size);
}
SmallButton :: (label: *u8) -> bool #foreign imgui "_ZN5ImGui11SmallButtonEPKc";
InvisibleButton :: (str_id: *u8, size: *ImVec2, flags: ButtonFlags = .None) -> bool #foreign imgui "_ZN5ImGui15InvisibleButtonEPKcRK6ImVec2i";
InvisibleButton :: (str_id: *u8, size: ImVec2, flags: ButtonFlags = .None) -> bool #no_context {
    return InvisibleButton(str_id, *size, flags);
}
ArrowButton :: (str_id: *u8, dir: Dir) -> bool #foreign imgui "_ZN5ImGui11ArrowButtonEPKci";
Checkbox :: (label: *u8, v: *bool) -> bool #foreign imgui "_ZN5ImGui8CheckboxEPKcPb";
CheckboxFlags :: (label: *u8, flags: *s32, flags_value: s32) -> bool #foreign imgui "_ZN5ImGui13CheckboxFlagsEPKcPii";
CheckboxFlags :: (label: *u8, flags: *u32, flags_value: u32) -> bool #foreign imgui "_ZN5ImGui13CheckboxFlagsEPKcPjj";
RadioButton :: (label: *u8, active: bool) -> bool #foreign imgui "_ZN5ImGui11RadioButtonEPKcb";
RadioButton :: (label: *u8, v: *s32, v_button: s32) -> bool #foreign imgui "_ZN5ImGui11RadioButtonEPKcPii";
ProgressBar :: (fraction: float, size_arg: *ImVec2, overlay: *u8 = null) -> void #foreign imgui "_ZN5ImGui11ProgressBarEfRK6ImVec2PKc";
ProgressBar :: (fraction: float, size_arg: ImVec2 = ImVec2.{-FLOAT32_MIN, 0}, overlay: *u8 = null) #no_context {
    ProgressBar(fraction, *size_arg, overlay);
}
Bullet :: () -> void #foreign imgui "_ZN5ImGui6BulletEv";

// Widgets: Images
// - Read about ImTextureID here: https://github.com/ocornut/imgui/wiki/Image-Loading-and-Displaying-Examples
// - 'uv0' and 'uv1' are texture coordinates. Read about them from the same link above.
// - Note that Image() may add +2.0f to provided size if a border is visible, ImageButton() adds style.FramePadding*2.0f to provided size.
Image :: (user_texture_id: ImTextureID, image_size: *ImVec2, uv0: *ImVec2, uv1: *ImVec2, tint_col: *ImVec4, border_col: *ImVec4) -> void #foreign imgui "_ZN5ImGui5ImageEPvRK6ImVec2S3_S3_RK6ImVec4S6_";
Image :: (user_texture_id: ImTextureID, image_size: ImVec2, uv0: ImVec2 = ImVec2.{0, 0}, uv1: ImVec2 = ImVec2.{1, 1}, tint_col: ImVec4 = ImVec4.{1, 1, 1, 1}, border_col: ImVec4 = ImVec4.{0, 0, 0, 0}) #no_context {
    Image(user_texture_id, *image_size, *uv0, *uv1, *tint_col, *border_col);
}
ImageButton :: (str_id: *u8, user_texture_id: ImTextureID, image_size: *ImVec2, uv0: *ImVec2, uv1: *ImVec2, bg_col: *ImVec4, tint_col: *ImVec4) -> bool #foreign imgui "_ZN5ImGui11ImageButtonEPKcPvRK6ImVec2S5_S5_RK6ImVec4S8_";
ImageButton :: (str_id: *u8, user_texture_id: ImTextureID, image_size: ImVec2, uv0: ImVec2 = ImVec2.{0, 0}, uv1: ImVec2 = ImVec2.{1, 1}, bg_col: ImVec4 = ImVec4.{0, 0, 0, 0}, tint_col: ImVec4 = ImVec4.{1, 1, 1, 1}) -> bool #no_context {
    return ImageButton(str_id, user_texture_id, *image_size, *uv0, *uv1, *bg_col, *tint_col);
}

// Widgets: Combo Box (Dropdown)
// - The BeginCombo()/EndCombo() api allows you to manage your contents and selection state however you want it, by creating e.g. Selectable() items.
// - The old Combo() api are helpers over BeginCombo()/EndCombo() which are kept available for convenience purpose. This is analogous to how ListBox are created.
BeginCombo :: (label: *u8, preview_value: *u8, flags: ComboFlags = .None) -> bool #foreign imgui "_ZN5ImGui10BeginComboEPKcS1_i";
EndCombo :: () -> void #foreign imgui "_ZN5ImGui8EndComboEv";
Combo :: (label: *u8, current_item: *s32, items: **u8, items_count: s32, popup_max_height_in_items: s32 = -1) -> bool #foreign imgui "_ZN5ImGui5ComboEPKcPiPKS1_ii";
Combo :: (label: *u8, current_item: *s32, items_separated_by_zeros: *u8, popup_max_height_in_items: s32 = -1) -> bool #foreign imgui "_ZN5ImGui5ComboEPKcPiS1_i";
Combo :: (label: *u8, current_item: *s32, getter: #type (user_data: *void, idx: s32) -> *u8 #c_call, user_data: *void, items_count: s32, popup_max_height_in_items: s32 = -1) -> bool #foreign imgui "_ZN5ImGui5ComboEPKcPiPFS1_PviES3_ii";

// Widgets: Drag Sliders
// - CTRL+Click on any drag box to turn them into an input box. Manually input values aren't clamped by default and can go off-bounds. Use ImGuiSliderFlags_AlwaysClamp to always clamp.
// - For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every function, note that a 'float v[X]' function argument is the same as 'float* v',
//   the array syntax is just a way to document the number of elements that are expected to be accessible. You can pass address of your first element out of a contiguous set, e.g. &myvector.x
// - Adjust format string to decorate the value with a prefix, a suffix, or adapt the editing and display precision e.g. "%.3f" -> 1.234; "%5.2f secs" -> 01.23 secs; "Biscuit: %.0f" -> Biscuit: 1; etc.
// - Format string may also be set to NULL or use the default format ("%f" or "%d").
// - Speed are per-pixel of mouse movement (v_speed=0.2f: mouse needs to move by 5 pixels to increase value by 1). For gamepad/keyboard navigation, minimum speed is Max(v_speed, minimum_step_at_given_precision).
// - Use v_min < v_max to clamp edits to given limits. Note that CTRL+Click manual input can override those limits if ImGuiSliderFlags_AlwaysClamp is not used.
// - Use v_max = FLT_MAX / INT_MAX etc to avoid clamping to a maximum, same with v_min = -FLT_MAX / INT_MIN to avoid clamping to a minimum.
// - We use the same sets of flags for DragXXX() and SliderXXX() functions as the features are the same and it makes it easier to swap them.
// - Legacy: Pre-1.78 there are DragXXX() function signatures that take a final `float power=1.0f' argument instead of the `ImGuiSliderFlags flags=0' argument.
//   If you get a warning converting a float to ImGuiSliderFlags, read https://github.com/ocornut/imgui/issues/3361
DragFloat :: (label: *u8, v: *float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui9DragFloatEPKcPffffS1_i";
DragFloat2 :: (label: *u8, v: *[2] float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui10DragFloat2EPKcPffffS1_i";
DragFloat3 :: (label: *u8, v: *[3] float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui10DragFloat3EPKcPffffS1_i";
DragFloat4 :: (label: *u8, v: *[4] float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui10DragFloat4EPKcPffffS1_i";
DragFloatRange2 :: (label: *u8, v_current_min: *float, v_current_max: *float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: *u8 = "%.3f", format_max: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui15DragFloatRange2EPKcPfS2_fffS1_S1_i";
DragInt :: (label: *u8, v: *s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui7DragIntEPKcPifiiS1_i";
DragInt2 :: (label: *u8, v: *[2] s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui8DragInt2EPKcPifiiS1_i";
DragInt3 :: (label: *u8, v: *[3] s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui8DragInt3EPKcPifiiS1_i";
DragInt4 :: (label: *u8, v: *[4] s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui8DragInt4EPKcPifiiS1_i";
DragIntRange2 :: (label: *u8, v_current_min: *s32, v_current_max: *s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: *u8 = "%d", format_max: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui13DragIntRange2EPKcPiS2_fiiS1_S1_i";
DragScalar :: (label: *u8, data_type: DataType, p_data: *void, v_speed: float = 1.0, p_min: *void = null, p_max: *void = null, format: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui10DragScalarEPKciPvfPKvS4_S1_i";
DragScalarN :: (label: *u8, data_type: DataType, p_data: *void, components: s32, v_speed: float = 1.0, p_min: *void = null, p_max: *void = null, format: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui11DragScalarNEPKciPvifPKvS4_S1_i";

// Widgets: Regular Sliders
// - CTRL+Click on any slider to turn them into an input box. Manually input values aren't clamped by default and can go off-bounds. Use ImGuiSliderFlags_AlwaysClamp to always clamp.
// - Adjust format string to decorate the value with a prefix, a suffix, or adapt the editing and display precision e.g. "%.3f" -> 1.234; "%5.2f secs" -> 01.23 secs; "Biscuit: %.0f" -> Biscuit: 1; etc.
// - Format string may also be set to NULL or use the default format ("%f" or "%d").
// - Legacy: Pre-1.78 there are SliderXXX() function signatures that take a final `float power=1.0f' argument instead of the `ImGuiSliderFlags flags=0' argument.
//   If you get a warning converting a float to ImGuiSliderFlags, read https://github.com/ocornut/imgui/issues/3361
SliderFloat :: (label: *u8, v: *float, v_min: float, v_max: float, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui11SliderFloatEPKcPfffS1_i";
SliderFloat2 :: (label: *u8, v: *[2] float, v_min: float, v_max: float, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui12SliderFloat2EPKcPfffS1_i";
SliderFloat3 :: (label: *u8, v: *[3] float, v_min: float, v_max: float, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui12SliderFloat3EPKcPfffS1_i";
SliderFloat4 :: (label: *u8, v: *[4] float, v_min: float, v_max: float, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui12SliderFloat4EPKcPfffS1_i";
SliderAngle :: (label: *u8, v_rad: *float, v_degrees_min: float = -360.0, v_degrees_max: float = +360.0, format: *u8 = "%.0f deg", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui11SliderAngleEPKcPfffS1_i";
SliderInt :: (label: *u8, v: *s32, v_min: s32, v_max: s32, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui9SliderIntEPKcPiiiS1_i";
SliderInt2 :: (label: *u8, v: *[2] s32, v_min: s32, v_max: s32, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui10SliderInt2EPKcPiiiS1_i";
SliderInt3 :: (label: *u8, v: *[3] s32, v_min: s32, v_max: s32, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui10SliderInt3EPKcPiiiS1_i";
SliderInt4 :: (label: *u8, v: *[4] s32, v_min: s32, v_max: s32, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui10SliderInt4EPKcPiiiS1_i";
SliderScalar :: (label: *u8, data_type: DataType, p_data: *void, p_min: *void, p_max: *void, format: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui12SliderScalarEPKciPvPKvS4_S1_i";
SliderScalarN :: (label: *u8, data_type: DataType, p_data: *void, components: s32, p_min: *void, p_max: *void, format: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui13SliderScalarNEPKciPviPKvS4_S1_i";
VSliderFloat :: (label: *u8, size: *ImVec2, v: *float, v_min: float, v_max: float, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui12VSliderFloatEPKcRK6ImVec2PfffS1_i";
VSliderFloat :: (label: *u8, size: ImVec2, v: *float, v_min: float, v_max: float, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #no_context {
    return VSliderFloat(label, *size, v, v_min, v_max, format, flags);
}
VSliderInt :: (label: *u8, size: *ImVec2, v: *s32, v_min: s32, v_max: s32, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui10VSliderIntEPKcRK6ImVec2PiiiS1_i";
VSliderInt :: (label: *u8, size: ImVec2, v: *s32, v_min: s32, v_max: s32, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #no_context {
    return VSliderInt(label, *size, v, v_min, v_max, format, flags);
}
VSliderScalar :: (label: *u8, size: *ImVec2, data_type: DataType, p_data: *void, p_min: *void, p_max: *void, format: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "_ZN5ImGui13VSliderScalarEPKcRK6ImVec2iPvPKvS7_S1_i";
VSliderScalar :: (label: *u8, size: ImVec2, data_type: DataType, p_data: *void, p_min: *void, p_max: *void, format: *u8 = null, flags: SliderFlags = .None) -> bool #no_context {
    return VSliderScalar(label, *size, data_type, p_data, p_min, p_max, format, flags);
}

// Widgets: Input with Keyboard
// - If you want to use InputText() with std::string or any custom dynamic string type, see misc/cpp/imgui_stdlib.h and comments in imgui_demo.cpp.
// - Most of the ImGuiInputTextFlags flags are only useful for InputText() and not for InputFloatX, InputIntX, InputDouble etc.
InputText :: (label: *u8, buf: *u8, buf_size: u64, flags: InputTextFlags = .None, callback: InputTextCallback = null, user_data: *void = null) -> bool #foreign imgui "_ZN5ImGui9InputTextEPKcPcmiPFiP26ImGuiInputTextCallbackDataEPv";
InputTextMultiline :: (label: *u8, buf: *u8, buf_size: u64, size: *ImVec2, flags: InputTextFlags = .None, callback: InputTextCallback = null, user_data: *void = null) -> bool #foreign imgui "_ZN5ImGui18InputTextMultilineEPKcPcmRK6ImVec2iPFiP26ImGuiInputTextCallbackDataEPv";
InputTextMultiline :: (label: *u8, buf: *u8, buf_size: u64, size: ImVec2 = ImVec2.{0, 0}, flags: InputTextFlags = .None, callback: InputTextCallback = null, user_data: *void = null) -> bool #no_context {
    return InputTextMultiline(label, buf, buf_size, *size, flags, callback, user_data);
}
InputTextWithHint :: (label: *u8, hint: *u8, buf: *u8, buf_size: u64, flags: InputTextFlags = .None, callback: InputTextCallback = null, user_data: *void = null) -> bool #foreign imgui "_ZN5ImGui17InputTextWithHintEPKcS1_PcmiPFiP26ImGuiInputTextCallbackDataEPv";
InputFloat :: (label: *u8, v: *float, step: float = 0.0, step_fast: float = 0.0, format: *u8 = "%.3f", flags: InputTextFlags = .None) -> bool #foreign imgui "_ZN5ImGui10InputFloatEPKcPfffS1_i";
InputFloat2 :: (label: *u8, v: *[2] float, format: *u8 = "%.3f", flags: InputTextFlags = .None) -> bool #foreign imgui "_ZN5ImGui11InputFloat2EPKcPfS1_i";
InputFloat3 :: (label: *u8, v: *[3] float, format: *u8 = "%.3f", flags: InputTextFlags = .None) -> bool #foreign imgui "_ZN5ImGui11InputFloat3EPKcPfS1_i";
InputFloat4 :: (label: *u8, v: *[4] float, format: *u8 = "%.3f", flags: InputTextFlags = .None) -> bool #foreign imgui "_ZN5ImGui11InputFloat4EPKcPfS1_i";
InputInt :: (label: *u8, v: *s32, step: s32 = 1, step_fast: s32 = 100, flags: InputTextFlags = .None) -> bool #foreign imgui "_ZN5ImGui8InputIntEPKcPiiii";
InputInt2 :: (label: *u8, v: *[2] s32, flags: InputTextFlags = .None) -> bool #foreign imgui "_ZN5ImGui9InputInt2EPKcPii";
InputInt3 :: (label: *u8, v: *[3] s32, flags: InputTextFlags = .None) -> bool #foreign imgui "_ZN5ImGui9InputInt3EPKcPii";
InputInt4 :: (label: *u8, v: *[4] s32, flags: InputTextFlags = .None) -> bool #foreign imgui "_ZN5ImGui9InputInt4EPKcPii";
InputDouble :: (label: *u8, v: *float64, step: float64 = 0.0, step_fast: float64 = 0.0, format: *u8 = "%.6f", flags: InputTextFlags = .None) -> bool #foreign imgui "_ZN5ImGui11InputDoubleEPKcPdddS1_i";
InputScalar :: (label: *u8, data_type: DataType, p_data: *void, p_step: *void = null, p_step_fast: *void = null, format: *u8 = null, flags: InputTextFlags = .None) -> bool #foreign imgui "_ZN5ImGui11InputScalarEPKciPvPKvS4_S1_i";
InputScalarN :: (label: *u8, data_type: DataType, p_data: *void, components: s32, p_step: *void = null, p_step_fast: *void = null, format: *u8 = null, flags: InputTextFlags = .None) -> bool #foreign imgui "_ZN5ImGui12InputScalarNEPKciPviPKvS4_S1_i";

// Widgets: Color Editor/Picker (tip: the ColorEdit* functions have a little color square that can be left-clicked to open a picker, and right-clicked to open an option menu.)
// - Note that in C++ a 'float v[X]' function argument is the _same_ as 'float* v', the array syntax is just a way to document the number of elements that are expected to be accessible.
// - You can pass the address of a first float element out of a contiguous structure, e.g. &myvector.x
ColorEdit3 :: (label: *u8, col: *[3] float, flags: ColorEditFlags = .None) -> bool #foreign imgui "_ZN5ImGui10ColorEdit3EPKcPfi";
ColorEdit4 :: (label: *u8, col: *[4] float, flags: ColorEditFlags = .None) -> bool #foreign imgui "_ZN5ImGui10ColorEdit4EPKcPfi";
ColorPicker3 :: (label: *u8, col: *[3] float, flags: ColorEditFlags = .None) -> bool #foreign imgui "_ZN5ImGui12ColorPicker3EPKcPfi";
ColorPicker4 :: (label: *u8, col: *[4] float, flags: ColorEditFlags = .None, ref_col: *float = null) -> bool #foreign imgui "_ZN5ImGui12ColorPicker4EPKcPfiPKf";
ColorButton :: (desc_id: *u8, col: *ImVec4, flags: ColorEditFlags = .None, size: *ImVec2) -> bool #foreign imgui "_ZN5ImGui11ColorButtonEPKcRK6ImVec4iRK6ImVec2";
ColorButton :: (desc_id: *u8, col: ImVec4, flags: ColorEditFlags = .None, size: ImVec2 = ImVec2.{0, 0}) -> bool #no_context {
    return ColorButton(desc_id, *col, flags, *size);
}
SetColorEditOptions :: (flags: ColorEditFlags) -> void #foreign imgui "_ZN5ImGui19SetColorEditOptionsEi";

// Widgets: Trees
// - TreeNode functions return true when the node is open, in which case you need to also call TreePop() when you are finished displaying the tree node contents.
TreeNode :: (label: *u8) -> bool #foreign imgui "_ZN5ImGui8TreeNodeEPKc";
TreeNode_CFormat :: (str_id: *u8, fmt: *u8, __args: ..Any) -> bool #foreign imgui "_ZN5ImGui8TreeNodeEPKcS1_z";
TreeNode :: (str_id: *u8, fmt: string, __args: ..Any) -> bool {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    return TreeNode_CFormat(str_id, "%s", formatted_text.data);
} @PrintLike
TreeNode_CFormat :: (ptr_id: *void, fmt: *u8, __args: ..Any) -> bool #foreign imgui "_ZN5ImGui8TreeNodeEPKvPKcz";
TreeNode :: (ptr_id: *void, fmt: string, __args: ..Any) -> bool {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    return TreeNode_CFormat(ptr_id, "%s", formatted_text.data);
} @PrintLike

TreeNodeEx :: (label: *u8, flags: TreeNodeFlags = .None) -> bool #foreign imgui "_ZN5ImGui10TreeNodeExEPKci";
TreeNodeEx_CFormat :: (str_id: *u8, flags: TreeNodeFlags, fmt: *u8, __args: ..Any) -> bool #foreign imgui "_ZN5ImGui10TreeNodeExEPKciS1_z";
TreeNodeEx :: (str_id: *u8, flags: TreeNodeFlags, fmt: string, __args: ..Any) -> bool {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    return TreeNodeEx_CFormat(str_id, flags, "%s", formatted_text.data);
} @PrintLike
TreeNodeEx_CFormat :: (ptr_id: *void, flags: TreeNodeFlags, fmt: *u8, __args: ..Any) -> bool #foreign imgui "_ZN5ImGui10TreeNodeExEPKviPKcz";
TreeNodeEx :: (ptr_id: *void, flags: TreeNodeFlags, fmt: string, __args: ..Any) -> bool {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    return TreeNodeEx_CFormat(ptr_id, flags, "%s", formatted_text.data);
} @PrintLike

TreePush :: (str_id: *u8) -> void #foreign imgui "_ZN5ImGui8TreePushEPKc";
TreePush :: (ptr_id: *void) -> void #foreign imgui "_ZN5ImGui8TreePushEPKv";
TreePop :: () -> void #foreign imgui "_ZN5ImGui7TreePopEv";
GetTreeNodeToLabelSpacing :: () -> float #foreign imgui "_ZN5ImGui25GetTreeNodeToLabelSpacingEv";
CollapsingHeader :: (label: *u8, flags: TreeNodeFlags = .None) -> bool #foreign imgui "_ZN5ImGui16CollapsingHeaderEPKci";
CollapsingHeader :: (label: *u8, p_visible: *bool, flags: TreeNodeFlags = .None) -> bool #foreign imgui "_ZN5ImGui16CollapsingHeaderEPKcPbi";
SetNextItemOpen :: (is_open: bool, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui15SetNextItemOpenEbi";

// Widgets: Selectables
// - A selectable highlights when hovered, and can display another color when selected.
// - Neighbors selectable extend their highlight bounds in order to leave no gap between them. This is so a series of selected Selectable appear contiguous.
Selectable :: (label: *u8, selected := false, flags: SelectableFlags = .None, size: *ImVec2) -> bool #foreign imgui "_ZN5ImGui10SelectableEPKcbiRK6ImVec2";
Selectable :: (label: *u8, selected := false, flags: SelectableFlags = .None, size: ImVec2 = ImVec2.{0, 0}) -> bool #no_context {
    return Selectable(label, selected, flags, *size);
}
Selectable :: (label: *u8, p_selected: *bool, flags: SelectableFlags = .None, size: *ImVec2) -> bool #foreign imgui "_ZN5ImGui10SelectableEPKcPbiRK6ImVec2";
Selectable :: (label: *u8, p_selected: *bool, flags: SelectableFlags = .None, size: ImVec2 = ImVec2.{0, 0}) -> bool #no_context {
    return Selectable(label, p_selected, flags, *size);
}

// Widgets: List Boxes
// - This is essentially a thin wrapper to using BeginChild/EndChild with the ImGuiChildFlags_FrameStyle flag for stylistic changes + displaying a label.
// - You can submit contents and manage your selection state however you want it, by creating e.g. Selectable() or any other items.
// - The simplified/old ListBox() api are helpers over BeginListBox()/EndListBox() which are kept available for convenience purpose. This is analoguous to how Combos are created.
// - Choose frame width:   size.x > 0.0f: custom  /  size.x < 0.0f or -FLT_MIN: right-align   /  size.x = 0.0f (default): use current ItemWidth
// - Choose frame height:  size.y > 0.0f: custom  /  size.y < 0.0f or -FLT_MIN: bottom-align  /  size.y = 0.0f (default): arbitrary default height which can fit ~7 items
BeginListBox :: (label: *u8, size: *ImVec2) -> bool #foreign imgui "_ZN5ImGui12BeginListBoxEPKcRK6ImVec2";
BeginListBox :: (label: *u8, size: ImVec2 = ImVec2.{0, 0}) -> bool #no_context {
    return BeginListBox(label, *size);
}
EndListBox :: () -> void #foreign imgui "_ZN5ImGui10EndListBoxEv";
ListBox :: (label: *u8, current_item: *s32, items: **u8, items_count: s32, height_in_items: s32 = -1) -> bool #foreign imgui "_ZN5ImGui7ListBoxEPKcPiPKS1_ii";
ListBox :: (label: *u8, current_item: *s32, getter: #type (user_data: *void, idx: s32) -> *u8 #c_call, user_data: *void, items_count: s32, height_in_items: s32 = -1) -> bool #foreign imgui "_ZN5ImGui7ListBoxEPKcPiPFS1_PviES3_ii";

// Widgets: Data Plotting
// - Consider using ImPlot (https://github.com/epezent/implot) which is much better!
PlotLines :: (label: *u8, values: *float, values_count: s32, values_offset: s32 = 0, overlay_text: *u8 = null, scale_min: float = FLOAT32_MAX, scale_max: float = FLOAT32_MAX, graph_size: ImVec2 = ImVec2.{0, 0}, stride: s32 = 4) -> void #foreign imgui "_ZN5ImGui9PlotLinesEPKcPKfiiS1_ff6ImVec2i";
PlotLines :: (label: *u8, values_getter: #type (data: *void, idx: s32) -> float #c_call, data: *void, values_count: s32, values_offset: s32 = 0, overlay_text: *u8 = null, scale_min: float = FLOAT32_MAX, scale_max: float = FLOAT32_MAX, graph_size: ImVec2 = ImVec2.{0, 0}) -> void #foreign imgui "_ZN5ImGui9PlotLinesEPKcPFfPviES2_iiS1_ff6ImVec2";
PlotHistogram :: (label: *u8, values: *float, values_count: s32, values_offset: s32 = 0, overlay_text: *u8 = null, scale_min: float = FLOAT32_MAX, scale_max: float = FLOAT32_MAX, graph_size: ImVec2 = ImVec2.{0, 0}, stride: s32 = 4) -> void #foreign imgui "_ZN5ImGui13PlotHistogramEPKcPKfiiS1_ff6ImVec2i";
PlotHistogram :: (label: *u8, values_getter: #type (data: *void, idx: s32) -> float #c_call, data: *void, values_count: s32, values_offset: s32 = 0, overlay_text: *u8 = null, scale_min: float = FLOAT32_MAX, scale_max: float = FLOAT32_MAX, graph_size: ImVec2 = ImVec2.{0, 0}) -> void #foreign imgui "_ZN5ImGui13PlotHistogramEPKcPFfPviES2_iiS1_ff6ImVec2";

// Widgets: Value() Helpers.
// - Those are merely shortcut to calling Text() with a format string. Output single value in "name: value" format (tip: freely declare more in your code to handle your types. you can add functions to the ImGui namespace)
Value :: (prefix: *u8, b: bool) -> void #foreign imgui "_ZN5ImGui5ValueEPKcb";
Value :: (prefix: *u8, v: s32) -> void #foreign imgui "_ZN5ImGui5ValueEPKci";
Value :: (prefix: *u8, v: u32) -> void #foreign imgui "_ZN5ImGui5ValueEPKcj";
Value :: (prefix: *u8, v: float, float_format: *u8 = null) -> void #foreign imgui "_ZN5ImGui5ValueEPKcfS1_";

// Widgets: Menus
// - Use BeginMenuBar() on a window ImGuiWindowFlags_MenuBar to append to its menu bar.
// - Use BeginMainMenuBar() to create a menu bar at the top of the screen and append to it.
// - Use BeginMenu() to create a menu. You can call BeginMenu() multiple time with the same identifier to append more items to it.
// - Not that MenuItem() keyboardshortcuts are displayed as a convenience but _not processed_ by Dear ImGui at the moment.
BeginMenuBar :: () -> bool #foreign imgui "_ZN5ImGui12BeginMenuBarEv";
EndMenuBar :: () -> void #foreign imgui "_ZN5ImGui10EndMenuBarEv";
BeginMainMenuBar :: () -> bool #foreign imgui "_ZN5ImGui16BeginMainMenuBarEv";
EndMainMenuBar :: () -> void #foreign imgui "_ZN5ImGui14EndMainMenuBarEv";
BeginMenu :: (label: *u8, enabled := true) -> bool #foreign imgui "_ZN5ImGui9BeginMenuEPKcb";
EndMenu :: () -> void #foreign imgui "_ZN5ImGui7EndMenuEv";
MenuItem :: (label: *u8, shortcut: *u8 = null, selected := false, enabled := true) -> bool #foreign imgui "_ZN5ImGui8MenuItemEPKcS1_bb";
MenuItem :: (label: *u8, shortcut: *u8, p_selected: *bool, enabled := true) -> bool #foreign imgui "_ZN5ImGui8MenuItemEPKcS1_Pbb";

// Tooltips
// - Tooltips are windows following the mouse. They do not take focus away.
// - A tooltip window can contain items of any types. SetTooltip() is a shortcut for the 'if (BeginTooltip()) { Text(...); EndTooltip(); }' idiom.
BeginTooltip :: () -> bool #foreign imgui "_ZN5ImGui12BeginTooltipEv";
EndTooltip :: () -> void #foreign imgui "_ZN5ImGui10EndTooltipEv";
SetTooltip_CFormat :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "_ZN5ImGui10SetTooltipEPKcz";
SetTooltip :: (fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SetTooltip_CFormat("%s", formatted_text.data);
} @PrintLike

// Tooltips: helpers for showing a tooltip when hovering an item
// - BeginItemTooltip() is a shortcut for the 'if (IsItemHovered(ImGuiHoveredFlags_ForTooltip) && BeginTooltip())' idiom.
// - SetItemTooltip() is a shortcut for the 'if (IsItemHovered(ImGuiHoveredFlags_ForTooltip)) { SetTooltip(...); }' idiom.
// - Where 'ImGuiHoveredFlags_ForTooltip' itself is a shortcut to use 'style.HoverFlagsForTooltipMouse' or 'style.HoverFlagsForTooltipNav' depending on active input type. For mouse it defaults to 'ImGuiHoveredFlags_Stationary | ImGuiHoveredFlags_DelayShort'.
BeginItemTooltip :: () -> bool #foreign imgui "_ZN5ImGui16BeginItemTooltipEv";
SetItemTooltip_CFormat :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "_ZN5ImGui14SetItemTooltipEPKcz";
SetItemTooltip :: (fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SetItemTooltip_CFormat("%s", formatted_text.data);
} @PrintLike

// Popups, Modals
//  - They block normal mouse hovering detection (and therefore most mouse interactions) behind them.
//  - If not modal: they can be closed by clicking anywhere outside them, or by pressing ESCAPE.
//  - Their visibility state (~bool) is held internally instead of being held by the programmer as we are used to with regular Begin*() calls.
//  - The 3 properties above are related: we need to retain popup visibility state in the library because popups may be closed as any time.
//  - You can bypass the hovering restriction by using ImGuiHoveredFlags_AllowWhenBlockedByPopup when calling IsItemHovered() or IsWindowHovered().
//  - IMPORTANT: Popup identifiers are relative to the current ID stack, so OpenPopup and BeginPopup generally needs to be at the same level of the stack.
//    This is sometimes leading to confusing mistakes. May rework this in the future.
//  - BeginPopup(): query popup state, if open start appending into the window. Call EndPopup() afterwards if returned true. ImGuiWindowFlags are forwarded to the window.
//  - BeginPopupModal(): block every interaction behind the window, cannot be closed by user, add a dimming background, has a title bar.
BeginPopup :: (str_id: *u8, flags: WindowFlags = .None) -> bool #foreign imgui "_ZN5ImGui10BeginPopupEPKci";
BeginPopupModal :: (name: *u8, p_open: *bool = null, flags: WindowFlags = .None) -> bool #foreign imgui "_ZN5ImGui15BeginPopupModalEPKcPbi";
EndPopup :: () -> void #foreign imgui "_ZN5ImGui8EndPopupEv";

// Popups: open/close functions
//  - OpenPopup(): set popup state to open. ImGuiPopupFlags are available for opening options.
//  - If not modal: they can be closed by clicking anywhere outside them, or by pressing ESCAPE.
//  - CloseCurrentPopup(): use inside the BeginPopup()/EndPopup() scope to close manually.
//  - CloseCurrentPopup() is called by default by Selectable()/MenuItem() when activated (FIXME: need some options).
//  - Use ImGuiPopupFlags_NoOpenOverExistingPopup to avoid opening a popup if there's already one at the same level. This is equivalent to e.g. testing for !IsAnyPopupOpen() prior to OpenPopup().
//  - Use IsWindowAppearing() after BeginPopup() to tell if a window just opened.
//  - IMPORTANT: Notice that for OpenPopupOnItemClick() we exceptionally default flags to 1 (== ImGuiPopupFlags_MouseButtonRight) for backward compatibility with older API taking 'int mouse_button = 1' parameter
OpenPopup :: (str_id: *u8, popup_flags: PopupFlags = .None) -> void #foreign imgui "_ZN5ImGui9OpenPopupEPKci";
OpenPopup :: (id: ID, popup_flags: PopupFlags = .None) -> void #foreign imgui "_ZN5ImGui9OpenPopupEji";
OpenPopupOnItemClick :: (str_id: *u8 = null, popup_flags: PopupFlags = .MouseButtonRight) -> void #foreign imgui "_ZN5ImGui20OpenPopupOnItemClickEPKci";
CloseCurrentPopup :: () -> void #foreign imgui "_ZN5ImGui17CloseCurrentPopupEv";

// Popups: open+begin combined functions helpers
//  - Helpers to do OpenPopup+BeginPopup where the Open action is triggered by e.g. hovering an item and right-clicking.
//  - They are convenient to easily create context menus, hence the name.
//  - IMPORTANT: Notice that BeginPopupContextXXX takes ImGuiPopupFlags just like OpenPopup() and unlike BeginPopup(). For full consistency, we may add ImGuiWindowFlags to the BeginPopupContextXXX functions in the future.
//  - IMPORTANT: Notice that we exceptionally default their flags to 1 (== ImGuiPopupFlags_MouseButtonRight) for backward compatibility with older API taking 'int mouse_button = 1' parameter, so if you add other flags remember to re-add the ImGuiPopupFlags_MouseButtonRight.
BeginPopupContextItem :: (str_id: *u8 = null, popup_flags: PopupFlags = .MouseButtonRight) -> bool #foreign imgui "_ZN5ImGui21BeginPopupContextItemEPKci";
BeginPopupContextWindow :: (str_id: *u8 = null, popup_flags: PopupFlags = .MouseButtonRight) -> bool #foreign imgui "_ZN5ImGui23BeginPopupContextWindowEPKci";
BeginPopupContextVoid :: (str_id: *u8 = null, popup_flags: PopupFlags = .MouseButtonRight) -> bool #foreign imgui "_ZN5ImGui21BeginPopupContextVoidEPKci";

// Popups: query functions
//  - IsPopupOpen(): return true if the popup is open at the current BeginPopup() level of the popup stack.
//  - IsPopupOpen() with ImGuiPopupFlags_AnyPopupId: return true if any popup is open at the current BeginPopup() level of the popup stack.
//  - IsPopupOpen() with ImGuiPopupFlags_AnyPopupId + ImGuiPopupFlags_AnyPopupLevel: return true if any popup is open.
IsPopupOpen :: (str_id: *u8, flags: PopupFlags = .None) -> bool #foreign imgui "_ZN5ImGui11IsPopupOpenEPKci";

// Tables
// - Full-featured replacement for old Columns API.
// - See Demo->Tables for demo code. See top of imgui_tables.cpp for general commentary.
// - See ImGuiTableFlags_ and ImGuiTableColumnFlags_ enums for a description of available flags.
// The typical call flow is:
// - 1. Call BeginTable(), early out if returning false.
// - 2. Optionally call TableSetupColumn() to submit column name/flags/defaults.
// - 3. Optionally call TableSetupScrollFreeze() to request scroll freezing of columns/rows.
// - 4. Optionally call TableHeadersRow() to submit a header row. Names are pulled from TableSetupColumn() data.
// - 5. Populate contents:
//    - In most situations you can use TableNextRow() + TableSetColumnIndex(N) to start appending into a column.
//    - If you are using tables as a sort of grid, where every column is holding the same type of contents,
//      you may prefer using TableNextColumn() instead of TableNextRow() + TableSetColumnIndex().
//      TableNextColumn() will automatically wrap-around into the next row if needed.
//    - IMPORTANT: Comparatively to the old Columns() API, we need to call TableNextColumn() for the first column!
//    - Summary of possible call flow:
//        - TableNextRow() -> TableSetColumnIndex(0) -> Text("Hello 0") -> TableSetColumnIndex(1) -> Text("Hello 1")  // OK
//        - TableNextRow() -> TableNextColumn()      -> Text("Hello 0") -> TableNextColumn()      -> Text("Hello 1")  // OK
//        -                   TableNextColumn()      -> Text("Hello 0") -> TableNextColumn()      -> Text("Hello 1")  // OK: TableNextColumn() automatically gets to next row!
//        - TableNextRow()                           -> Text("Hello 0")                                               // Not OK! Missing TableSetColumnIndex() or TableNextColumn()! Text will not appear!
// - 5. Call EndTable()
BeginTable :: (str_id: *u8, column: s32, flags: TableFlags = .None, outer_size: *ImVec2, inner_width: float = 0.0) -> bool #foreign imgui "_ZN5ImGui10BeginTableEPKciiRK6ImVec2f";
BeginTable :: (str_id: *u8, column: s32, flags: TableFlags = .None, outer_size: ImVec2 = ImVec2.{0.0, 0.0}, inner_width: float = 0.0) -> bool #no_context {
    return BeginTable(str_id, column, flags, *outer_size, inner_width);
}
EndTable :: () -> void #foreign imgui "_ZN5ImGui8EndTableEv";
TableNextRow :: (row_flags: TableRowFlags = .None, min_row_height: float = 0.0) -> void #foreign imgui "_ZN5ImGui12TableNextRowEif";
TableNextColumn :: () -> bool #foreign imgui "_ZN5ImGui15TableNextColumnEv";
TableSetColumnIndex :: (column_n: s32) -> bool #foreign imgui "_ZN5ImGui19TableSetColumnIndexEi";

// Tables: Headers & Columns declaration
// - Use TableSetupColumn() to specify label, resizing policy, default width/weight, id, various other flags etc.
// - Use TableHeadersRow() to create a header row and automatically submit a TableHeader() for each column.
//   Headers are required to perform: reordering, sorting, and opening the context menu.
//   The context menu can also be made available in columns body using ImGuiTableFlags_ContextMenuInBody.
// - You may manually submit headers using TableNextRow() + TableHeader() calls, but this is only useful in
//   some advanced use cases (e.g. adding custom widgets in header row).
// - Use TableSetupScrollFreeze() to lock columns/rows so they stay visible when scrolled.
TableSetupColumn :: (label: *u8, flags: TableColumnFlags = .None, init_width_or_weight: float = 0.0, user_id: ID = 0) -> void #foreign imgui "_ZN5ImGui16TableSetupColumnEPKcifj";
TableSetupScrollFreeze :: (cols: s32, rows: s32) -> void #foreign imgui "_ZN5ImGui22TableSetupScrollFreezeEii";
TableHeader :: (label: *u8) -> void #foreign imgui "_ZN5ImGui11TableHeaderEPKc";
TableHeadersRow :: () -> void #foreign imgui "_ZN5ImGui15TableHeadersRowEv";
TableAngledHeadersRow :: () -> void #foreign imgui "_ZN5ImGui21TableAngledHeadersRowEv";

// Tables: Sorting & Miscellaneous functions
// - Sorting: call TableGetSortSpecs() to retrieve latest sort specs for the table. NULL when not sorting.
//   When 'sort_specs->SpecsDirty == true' you should sort your data. It will be true when sorting specs have
//   changed since last call, or the first time. Make sure to set 'SpecsDirty = false' after sorting,
//   else you may wastefully sort your data every frame!
// - Functions args 'int column_n' treat the default value of -1 as the same as passing the current column index.
TableGetSortSpecs :: () -> *TableSortSpecs #foreign imgui "_ZN5ImGui17TableGetSortSpecsEv";
TableGetColumnCount :: () -> s32 #foreign imgui "_ZN5ImGui19TableGetColumnCountEv";
TableGetColumnIndex :: () -> s32 #foreign imgui "_ZN5ImGui19TableGetColumnIndexEv";
TableGetRowIndex :: () -> s32 #foreign imgui "_ZN5ImGui16TableGetRowIndexEv";
TableGetColumnName :: (column_n: s32 = -1) -> *u8 #foreign imgui "_ZN5ImGui18TableGetColumnNameEi";
TableGetColumnFlags :: (column_n: s32 = -1) -> TableColumnFlags #foreign imgui "_ZN5ImGui19TableGetColumnFlagsEi";
TableSetColumnEnabled :: (column_n: s32, v: bool) -> void #foreign imgui "_ZN5ImGui21TableSetColumnEnabledEib";
TableSetBgColor :: (target: TableBgTarget, color: ImU32, column_n: s32 = -1) -> void #foreign imgui "_ZN5ImGui15TableSetBgColorEiji";

// Legacy Columns API (prefer using Tables!)
// - You can also use SameLine(pos_x) to mimic simplified columns.
Columns :: (count: s32 = 1, id: *u8 = null, border := true) -> void #foreign imgui "_ZN5ImGui7ColumnsEiPKcb";
NextColumn :: () -> void #foreign imgui "_ZN5ImGui10NextColumnEv";
GetColumnIndex :: () -> s32 #foreign imgui "_ZN5ImGui14GetColumnIndexEv";
GetColumnWidth :: (column_index: s32 = -1) -> float #foreign imgui "_ZN5ImGui14GetColumnWidthEi";
SetColumnWidth :: (column_index: s32, width: float) -> void #foreign imgui "_ZN5ImGui14SetColumnWidthEif";
GetColumnOffset :: (column_index: s32 = -1) -> float #foreign imgui "_ZN5ImGui15GetColumnOffsetEi";
SetColumnOffset :: (column_index: s32, offset_x: float) -> void #foreign imgui "_ZN5ImGui15SetColumnOffsetEif";
GetColumnsCount :: () -> s32 #foreign imgui "_ZN5ImGui15GetColumnsCountEv";

// Tab Bars, Tabs
// - Note: Tabs are automatically created by the docking system (when in 'docking' branch). Use this to create tab bars/tabs yourself.
BeginTabBar :: (str_id: *u8, flags: TabBarFlags = .None) -> bool #foreign imgui "_ZN5ImGui11BeginTabBarEPKci";
EndTabBar :: () -> void #foreign imgui "_ZN5ImGui9EndTabBarEv";
BeginTabItem :: (label: *u8, p_open: *bool = null, flags: TabItemFlags = .None) -> bool #foreign imgui "_ZN5ImGui12BeginTabItemEPKcPbi";
EndTabItem :: () -> void #foreign imgui "_ZN5ImGui10EndTabItemEv";
TabItemButton :: (label: *u8, flags: TabItemFlags = .None) -> bool #foreign imgui "_ZN5ImGui13TabItemButtonEPKci";
SetTabItemClosed :: (tab_or_docked_window_label: *u8) -> void #foreign imgui "_ZN5ImGui16SetTabItemClosedEPKc";

// Docking
// [BETA API] Enable with io.ConfigFlags |= ImGuiConfigFlags_DockingEnable.
// Note: You can use most Docking facilities without calling any API. You DO NOT need to call DockSpace() to use Docking!
// - Drag from window title bar or their tab to dock/undock. Hold SHIFT to disable docking.
// - Drag from window menu button (upper-left button) to undock an entire node (all windows).
// - When io.ConfigDockingWithShift == true, you instead need to hold SHIFT to enable docking.
// About dockspaces:
// - Use DockSpaceOverViewport() to create an explicit dock node covering the screen or a specific viewport.
//   This is often used with ImGuiDockNodeFlags_PassthruCentralNode to make it transparent.
// - Use DockSpace() to create an explicit dock node _within_ an existing window. See Docking demo for details.
// - Important: Dockspaces need to be submitted _before_ any window they can host. Submit it early in your frame!
// - Important: Dockspaces need to be kept alive if hidden, otherwise windows docked into it will be undocked.
//   e.g. if you have multiple tabs with a dockspace inside each tab: submit the non-visible dockspaces with ImGuiDockNodeFlags_KeepAliveOnly.
DockSpace :: (id: ID, size: *ImVec2, flags: DockNodeFlags = .None, window_class: *WindowClass = null) -> ID #foreign imgui "_ZN5ImGui9DockSpaceEjRK6ImVec2iPK16ImGuiWindowClass";
DockSpace :: (id: ID, size: ImVec2 = ImVec2.{0, 0}, flags: DockNodeFlags = .None, window_class: *WindowClass = null) -> ID #no_context {
    return DockSpace(id, *size, flags, window_class);
}
DockSpaceOverViewport :: (viewport: *Viewport = null, flags: DockNodeFlags = .None, window_class: *WindowClass = null) -> ID #foreign imgui "_ZN5ImGui21DockSpaceOverViewportEPK13ImGuiViewportiPK16ImGuiWindowClass";
SetNextWindowDockID :: (dock_id: ID, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui19SetNextWindowDockIDEji";
SetNextWindowClass :: (window_class: *WindowClass) -> void #foreign imgui "_ZN5ImGui18SetNextWindowClassEPK16ImGuiWindowClass";
GetWindowDockID :: () -> ID #foreign imgui "_ZN5ImGui15GetWindowDockIDEv";
IsWindowDocked :: () -> bool #foreign imgui "_ZN5ImGui14IsWindowDockedEv";

// Logging/Capture
// - All text output from the interface can be captured into tty/file/clipboard. By default, tree nodes are automatically opened during logging.
LogToTTY :: (auto_open_depth: s32 = -1) -> void #foreign imgui "_ZN5ImGui8LogToTTYEi";
LogToFile :: (auto_open_depth: s32 = -1, filename: *u8 = null) -> void #foreign imgui "_ZN5ImGui9LogToFileEiPKc";
LogToClipboard :: (auto_open_depth: s32 = -1) -> void #foreign imgui "_ZN5ImGui14LogToClipboardEi";
LogFinish :: () -> void #foreign imgui "_ZN5ImGui9LogFinishEv";
LogButtons :: () -> void #foreign imgui "_ZN5ImGui10LogButtonsEv";
LogText_CFormat :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "_ZN5ImGui7LogTextEPKcz";
LogText :: (fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    LogText_CFormat("%s", formatted_text.data);
} @PrintLike

// Drag and Drop
// - On source items, call BeginDragDropSource(), if it returns true also call SetDragDropPayload() + EndDragDropSource().
// - On target candidates, call BeginDragDropTarget(), if it returns true also call AcceptDragDropPayload() + EndDragDropTarget().
// - If you stop calling BeginDragDropSource() the payload is preserved however it won't have a preview tooltip (we currently display a fallback "..." tooltip, see #1725)
// - An item can be both drag source and drop target.
BeginDragDropSource :: (flags: DragDropFlags = .None) -> bool #foreign imgui "_ZN5ImGui19BeginDragDropSourceEi";
SetDragDropPayload :: (type: *u8, data: *void, sz: u64, cond: Cond = .None) -> bool #foreign imgui "_ZN5ImGui18SetDragDropPayloadEPKcPKvmi";
EndDragDropSource :: () -> void #foreign imgui "_ZN5ImGui17EndDragDropSourceEv";
BeginDragDropTarget :: () -> bool #foreign imgui "_ZN5ImGui19BeginDragDropTargetEv";
AcceptDragDropPayload :: (type: *u8, flags: DragDropFlags = .None) -> *Payload #foreign imgui "_ZN5ImGui21AcceptDragDropPayloadEPKci";
EndDragDropTarget :: () -> void #foreign imgui "_ZN5ImGui17EndDragDropTargetEv";
GetDragDropPayload :: () -> *Payload #foreign imgui "_ZN5ImGui18GetDragDropPayloadEv";

// Disabling [BETA API]
// - Disable all user interactions and dim items visuals (applying style.DisabledAlpha over current colors)
// - Those can be nested but it cannot be used to enable an already disabled section (a single BeginDisabled(true) in the stack is enough to keep everything disabled)
// - BeginDisabled(false) essentially does nothing useful but is provided to facilitate use of boolean expressions. If you can avoid calling BeginDisabled(False)/EndDisabled() best to avoid it.
BeginDisabled :: (disabled := true) -> void #foreign imgui "_ZN5ImGui13BeginDisabledEb";
EndDisabled :: () -> void #foreign imgui "_ZN5ImGui11EndDisabledEv";

// Clipping
// - Mouse hovering is affected by ImGui::PushClipRect() calls, unlike direct calls to ImDrawList::PushClipRect() which are render only.
PushClipRect :: (clip_rect_min: *ImVec2, clip_rect_max: *ImVec2, intersect_with_current_clip_rect: bool) -> void #foreign imgui "_ZN5ImGui12PushClipRectERK6ImVec2S2_b";
PushClipRect :: (clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect: bool) #no_context {
    PushClipRect(*clip_rect_min, *clip_rect_max, intersect_with_current_clip_rect);
}
PopClipRect :: () -> void #foreign imgui "_ZN5ImGui11PopClipRectEv";

// Focus, Activation
// - Prefer using "SetItemDefaultFocus()" over "if (IsWindowAppearing()) SetScrollHereY()" when applicable to signify "this is the default item"
SetItemDefaultFocus :: () -> void #foreign imgui "_ZN5ImGui19SetItemDefaultFocusEv";
SetKeyboardFocusHere :: (offset: s32 = 0) -> void #foreign imgui "_ZN5ImGui20SetKeyboardFocusHereEi";

// Overlapping mode
SetNextItemAllowOverlap :: () -> void #foreign imgui "_ZN5ImGui23SetNextItemAllowOverlapEv";

// Item/Widgets Utilities and Query Functions
// - Most of the functions are referring to the previous Item that has been submitted.
// - See Demo Window under "Widgets->Querying Status" for an interactive visualization of most of those functions.
IsItemHovered :: (flags: HoveredFlags = .None) -> bool #foreign imgui "_ZN5ImGui13IsItemHoveredEi";
IsItemActive :: () -> bool #foreign imgui "_ZN5ImGui12IsItemActiveEv";
IsItemFocused :: () -> bool #foreign imgui "_ZN5ImGui13IsItemFocusedEv";
IsItemClicked :: (mouse_button: MouseButton = .Left) -> bool #foreign imgui "_ZN5ImGui13IsItemClickedEi";
IsItemVisible :: () -> bool #foreign imgui "_ZN5ImGui13IsItemVisibleEv";
IsItemEdited :: () -> bool #foreign imgui "_ZN5ImGui12IsItemEditedEv";
IsItemActivated :: () -> bool #foreign imgui "_ZN5ImGui15IsItemActivatedEv";
IsItemDeactivated :: () -> bool #foreign imgui "_ZN5ImGui17IsItemDeactivatedEv";
IsItemDeactivatedAfterEdit :: () -> bool #foreign imgui "_ZN5ImGui26IsItemDeactivatedAfterEditEv";
IsItemToggledOpen :: () -> bool #foreign imgui "_ZN5ImGui17IsItemToggledOpenEv";
IsAnyItemHovered :: () -> bool #foreign imgui "_ZN5ImGui16IsAnyItemHoveredEv";
IsAnyItemActive :: () -> bool #foreign imgui "_ZN5ImGui15IsAnyItemActiveEv";
IsAnyItemFocused :: () -> bool #foreign imgui "_ZN5ImGui16IsAnyItemFocusedEv";
GetItemID :: () -> ID #foreign imgui "_ZN5ImGui9GetItemIDEv";
GetItemRectMin :: () -> ImVec2 #foreign imgui "_ZN5ImGui14GetItemRectMinEv";
GetItemRectMax :: () -> ImVec2 #foreign imgui "_ZN5ImGui14GetItemRectMaxEv";
GetItemRectSize :: () -> ImVec2 #foreign imgui "_ZN5ImGui15GetItemRectSizeEv";

// Viewports
// - Currently represents the Platform Window created by the application which is hosting our Dear ImGui windows.
// - In 'docking' branch with multi-viewport enabled, we extend this concept to have multiple active viewports.
// - In the future we will extend this concept further to also represent Platform Monitor and support a "no main platform window" operation mode.
GetMainViewport :: () -> *Viewport #foreign imgui "_ZN5ImGui15GetMainViewportEv";

// Background/Foreground Draw Lists
GetBackgroundDrawList :: () -> *ImDrawList #foreign imgui "_ZN5ImGui21GetBackgroundDrawListEv";
GetForegroundDrawList :: () -> *ImDrawList #foreign imgui "_ZN5ImGui21GetForegroundDrawListEv";
GetBackgroundDrawList :: (viewport: *Viewport) -> *ImDrawList #foreign imgui "_ZN5ImGui21GetBackgroundDrawListEP13ImGuiViewport";
GetForegroundDrawList :: (viewport: *Viewport) -> *ImDrawList #foreign imgui "_ZN5ImGui21GetForegroundDrawListEP13ImGuiViewport";

// Miscellaneous Utilities
IsRectVisible :: (size: *ImVec2) -> bool #foreign imgui "_ZN5ImGui13IsRectVisibleERK6ImVec2";
IsRectVisible :: (size: ImVec2) -> bool #no_context {
    return IsRectVisible(*size);
}
IsRectVisible :: (rect_min: *ImVec2, rect_max: *ImVec2) -> bool #foreign imgui "_ZN5ImGui13IsRectVisibleERK6ImVec2S2_";
IsRectVisible :: (rect_min: ImVec2, rect_max: ImVec2) -> bool #no_context {
    return IsRectVisible(*rect_min, *rect_max);
}
GetTime :: () -> float64 #foreign imgui "_ZN5ImGui7GetTimeEv";
GetFrameCount :: () -> s32 #foreign imgui "_ZN5ImGui13GetFrameCountEv";
GetDrawListSharedData :: () -> *ImDrawListSharedData #foreign imgui "_ZN5ImGui21GetDrawListSharedDataEv";
GetStyleColorName :: (idx: Col) -> *u8 #foreign imgui "_ZN5ImGui17GetStyleColorNameEi";
SetStateStorage :: (storage: *Storage) -> void #foreign imgui "_ZN5ImGui15SetStateStorageEP12ImGuiStorage";
GetStateStorage :: () -> *Storage #foreign imgui "_ZN5ImGui15GetStateStorageEv";

// Text Utilities
CalcTextSize :: (text: *u8, text_end: *u8 = null, hide_text_after_double_hash := false, wrap_width: float = -1.0) -> ImVec2 #foreign imgui "_ZN5ImGui12CalcTextSizeEPKcS1_bf";
CalcTextSize :: (text: string, hide_text_after_double_hash := false, wrap_width: float = -1.0) -> ImVec2 #no_context {
    return CalcTextSize(text.data, text.data + text.count, hide_text_after_double_hash, wrap_width);
}

// Color Utilities
ColorConvertU32ToFloat4 :: (in: ImU32) -> ImVec4 #foreign imgui "_ZN5ImGui23ColorConvertU32ToFloat4Ej";
ColorConvertFloat4ToU32 :: (in: *ImVec4) -> ImU32 #foreign imgui "_ZN5ImGui23ColorConvertFloat4ToU32ERK6ImVec4";
ColorConvertFloat4ToU32 :: (in: ImVec4) -> ImU32 #no_context {
    return ColorConvertFloat4ToU32(*in);
}
ColorConvertRGBtoHSV :: (r: float, g: float, b: float, out_h: *float, out_s: *float, out_v: *float) -> void #foreign imgui "_ZN5ImGui20ColorConvertRGBtoHSVEfffRfS0_S0_";
ColorConvertHSVtoRGB :: (h: float, s: float, v: float, out_r: *float, out_g: *float, out_b: *float) -> void #foreign imgui "_ZN5ImGui20ColorConvertHSVtoRGBEfffRfS0_S0_";

// Inputs Utilities: Keyboard/Mouse/Gamepad
// - the ImGuiKey enum contains all possible keyboard, mouse and gamepad inputs (e.g. ImGuiKey_A, ImGuiKey_MouseLeft, ImGuiKey_GamepadDpadUp...).
// - before v1.87, we used ImGuiKey to carry native/user indices as defined by each backends. About use of those legacy ImGuiKey values:
//  - without IMGUI_DISABLE_OBSOLETE_KEYIO (legacy support): you can still use your legacy native/user indices (< 512) according to how your backend/engine stored them in io.KeysDown[], but need to cast them to ImGuiKey.
//  - with    IMGUI_DISABLE_OBSOLETE_KEYIO (this is the way forward): any use of ImGuiKey will assert with key < 512. GetKeyIndex() is pass-through and therefore deprecated (gone if IMGUI_DISABLE_OBSOLETE_KEYIO is defined).
IsKeyDown :: (key: Key) -> bool #foreign imgui "_ZN5ImGui9IsKeyDownE8ImGuiKey";
IsKeyPressed :: (key: Key, repeat := true) -> bool #foreign imgui "_ZN5ImGui12IsKeyPressedE8ImGuiKeyb";
IsKeyReleased :: (key: Key) -> bool #foreign imgui "_ZN5ImGui13IsKeyReleasedE8ImGuiKey";
IsKeyChordPressed :: (key_chord: KeyChord) -> bool #foreign imgui "_ZN5ImGui17IsKeyChordPressedEi";
GetKeyPressedAmount :: (key: Key, repeat_delay: float, rate: float) -> s32 #foreign imgui "_ZN5ImGui19GetKeyPressedAmountE8ImGuiKeyff";
GetKeyName :: (key: Key) -> *u8 #foreign imgui "_ZN5ImGui10GetKeyNameE8ImGuiKey";
SetNextFrameWantCaptureKeyboard :: (want_capture_keyboard: bool) -> void #foreign imgui "_ZN5ImGui31SetNextFrameWantCaptureKeyboardEb";

// Inputs Utilities: Mouse specific
// - To refer to a mouse button, you may use named enums in your code e.g. ImGuiMouseButton_Left, ImGuiMouseButton_Right.
// - You can also use regular integer: it is forever guaranteed that 0=Left, 1=Right, 2=Middle.
// - Dragging operations are only reported after mouse has moved a certain distance away from the initial clicking position (see 'lock_threshold' and 'io.MouseDraggingThreshold')
IsMouseDown :: (button: MouseButton) -> bool #foreign imgui "_ZN5ImGui11IsMouseDownEi";
IsMouseClicked :: (button: MouseButton, repeat := false) -> bool #foreign imgui "_ZN5ImGui14IsMouseClickedEib";
IsMouseReleased :: (button: MouseButton) -> bool #foreign imgui "_ZN5ImGui15IsMouseReleasedEi";
IsMouseDoubleClicked :: (button: MouseButton) -> bool #foreign imgui "_ZN5ImGui20IsMouseDoubleClickedEi";
GetMouseClickedCount :: (button: MouseButton) -> s32 #foreign imgui "_ZN5ImGui20GetMouseClickedCountEi";
IsMouseHoveringRect :: (r_min: *ImVec2, r_max: *ImVec2, clip := true) -> bool #foreign imgui "_ZN5ImGui19IsMouseHoveringRectERK6ImVec2S2_b";
IsMouseHoveringRect :: (r_min: ImVec2, r_max: ImVec2, clip := true) -> bool #no_context {
    return IsMouseHoveringRect(*r_min, *r_max, clip);
}
IsMousePosValid :: (mouse_pos: *ImVec2 = null) -> bool #foreign imgui "_ZN5ImGui15IsMousePosValidEPK6ImVec2";
IsAnyMouseDown :: () -> bool #foreign imgui "_ZN5ImGui14IsAnyMouseDownEv";
GetMousePos :: () -> ImVec2 #foreign imgui "_ZN5ImGui11GetMousePosEv";
GetMousePosOnOpeningCurrentPopup :: () -> ImVec2 #foreign imgui "_ZN5ImGui32GetMousePosOnOpeningCurrentPopupEv";
IsMouseDragging :: (button: MouseButton, lock_threshold: float = -1.0) -> bool #foreign imgui "_ZN5ImGui15IsMouseDraggingEif";
GetMouseDragDelta :: (button: MouseButton = .Left, lock_threshold: float = -1.0) -> ImVec2 #foreign imgui "_ZN5ImGui17GetMouseDragDeltaEif";
ResetMouseDragDelta :: (button: MouseButton = .Left) -> void #foreign imgui "_ZN5ImGui19ResetMouseDragDeltaEi";
GetMouseCursor :: () -> MouseCursor #foreign imgui "_ZN5ImGui14GetMouseCursorEv";
SetMouseCursor :: (cursor_type: MouseCursor) -> void #foreign imgui "_ZN5ImGui14SetMouseCursorEi";
SetNextFrameWantCaptureMouse :: (want_capture_mouse: bool) -> void #foreign imgui "_ZN5ImGui28SetNextFrameWantCaptureMouseEb";

// Clipboard Utilities
// - Also see the LogToClipboard() function to capture GUI into clipboard, or easily output text data to the clipboard.
GetClipboardText :: () -> *u8 #foreign imgui "_ZN5ImGui16GetClipboardTextEv";
SetClipboardText :: (text: *u8) -> void #foreign imgui "_ZN5ImGui16SetClipboardTextEPKc";

// Settings/.Ini Utilities
// - The disk functions are automatically called if io.IniFilename != NULL (default is "imgui.ini").
// - Set io.IniFilename to NULL to load/save manually. Read io.WantSaveIniSettings description about handling .ini saving manually.
// - Important: default value "imgui.ini" is relative to current working dir! Most apps will want to lock this to an absolute path (e.g. same path as executables).
LoadIniSettingsFromDisk :: (ini_filename: *u8) -> void #foreign imgui "_ZN5ImGui23LoadIniSettingsFromDiskEPKc";
LoadIniSettingsFromMemory :: (ini_data: *u8, ini_size: u64 = 0) -> void #foreign imgui "_ZN5ImGui25LoadIniSettingsFromMemoryEPKcm";
SaveIniSettingsToDisk :: (ini_filename: *u8) -> void #foreign imgui "_ZN5ImGui21SaveIniSettingsToDiskEPKc";
SaveIniSettingsToMemory :: (out_ini_size: *u64 = null) -> *u8 #foreign imgui "_ZN5ImGui23SaveIniSettingsToMemoryEPm";

// Debug Utilities
// - Your main debugging friend is the ShowMetricsWindow() function, which is also accessible from Demo->Tools->Metrics Debugger
DebugTextEncoding :: (text: *u8) -> void #foreign imgui "_ZN5ImGui17DebugTextEncodingEPKc";
DebugFlashStyleColor :: (idx: Col) -> void #foreign imgui "_ZN5ImGui20DebugFlashStyleColorEi";
DebugStartItemPicker :: () -> void #foreign imgui "_ZN5ImGui20DebugStartItemPickerEv";
DebugCheckVersionAndDataLayout :: (version_str: *u8, sz_io: u64, sz_style: u64, sz_vec2: u64, sz_vec4: u64, sz_drawvert: u64, sz_drawidx: u64) -> bool #foreign imgui "_ZN5ImGui30DebugCheckVersionAndDataLayoutEPKcmmmmmm";

// Memory Allocators
// - Those functions are not reliant on the current context.
// - DLL users: heaps and globals are not shared across DLL boundaries! You will need to call SetCurrentContext() + SetAllocatorFunctions()
//   for each static/DLL boundary you are calling from. Read "Context and Memory Allocators" section of imgui.cpp for more details.
SetAllocatorFunctions :: (alloc_func: MemAllocFunc, free_func: MemFreeFunc, user_data: *void = null) -> void #foreign imgui "_ZN5ImGui21SetAllocatorFunctionsEPFPvmS0_EPFvS0_S0_ES0_";
GetAllocatorFunctions :: (p_alloc_func: *MemAllocFunc, p_free_func: *MemFreeFunc, p_user_data: **void) -> void #foreign imgui "_ZN5ImGui21GetAllocatorFunctionsEPPFPvmS0_EPPFvS0_S0_EPS0_";
MemAlloc :: (size: u64) -> *void #foreign imgui "_ZN5ImGui8MemAllocEm";
MemFree :: (ptr: *void) -> void #foreign imgui "_ZN5ImGui7MemFreeEPv";

// (Optional) Platform/OS interface for multi-viewport support
// Read comments around the ImGuiPlatformIO structure for more details.
// Note: You may use GetWindowViewport() to get the current viewport of the current window.
GetPlatformIO :: () -> *PlatformIO #foreign imgui "_ZN5ImGui13GetPlatformIOEv";
UpdatePlatformWindows :: () -> void #foreign imgui "_ZN5ImGui21UpdatePlatformWindowsEv";
RenderPlatformWindowsDefault :: (platform_render_arg: *void = null, renderer_render_arg: *void = null) -> void #foreign imgui "_ZN5ImGui28RenderPlatformWindowsDefaultEPvS0_";
DestroyPlatformWindows :: () -> void #foreign imgui "_ZN5ImGui22DestroyPlatformWindowsEv";
FindViewportByID :: (id: ID) -> *Viewport #foreign imgui "_ZN5ImGui16FindViewportByIDEj";
FindViewportByPlatformHandle :: (platform_handle: *void) -> *Viewport #foreign imgui "_ZN5ImGui28FindViewportByPlatformHandleEPv";

GetKeyIndex :: (key: Key) -> Key #foreign imgui "_ZN5ImGui11GetKeyIndexE8ImGuiKey";

ListBox :: (label: *u8, current_item: *s32, old_callback: #type (user_data: *void, idx: s32, out_text: **u8) -> bool #c_call, user_data: *void, items_count: s32, height_in_items: s32 = -1) -> bool #foreign imgui "_ZN5ImGui7ListBoxEPKcPiPFbPviPS1_ES3_ii";
Combo :: (label: *u8, current_item: *s32, old_callback: #type (user_data: *void, idx: s32, out_text: **u8) -> bool #c_call, user_data: *void, items_count: s32, popup_max_height_in_items: s32 = -1) -> bool #foreign imgui "_ZN5ImGui5ComboEPKcPiPFbPviPS1_ES3_ii";

// OBSOLETED in 1.89.7 (from June 2023)
SetItemAllowOverlap :: () -> void #foreign imgui "_ZN5ImGui19SetItemAllowOverlapEv";

// OBSOLETED in 1.89 (from August 2022)
ImageButton :: (user_texture_id: ImTextureID, size: *ImVec2, uv0: *ImVec2, uv1: *ImVec2, frame_padding: s32 = -1, bg_col: *ImVec4, tint_col: *ImVec4) -> bool #foreign imgui "_ZN5ImGui11ImageButtonEPvRK6ImVec2S3_S3_iRK6ImVec4S6_";
ImageButton :: (user_texture_id: ImTextureID, size: ImVec2, uv0: ImVec2 = ImVec2.{0, 0}, uv1: ImVec2 = ImVec2.{1, 1}, frame_padding: s32 = -1, bg_col: ImVec4 = ImVec4.{0, 0, 0, 0}, tint_col: ImVec4 = ImVec4.{1, 1, 1, 1}) -> bool #no_context {
    return ImageButton(user_texture_id, *size, *uv0, *uv1, frame_padding, *bg_col, *tint_col);
}

FindWindowByID :: (id: ID) -> *Window #foreign imgui "_ZN5ImGui14FindWindowByIDEj";
FindWindowByName :: (name: *u8) -> *Window #foreign imgui "_ZN5ImGui16FindWindowByNameEPKc";
UpdateWindowParentAndRootLinks :: (window: *Window, flags: WindowFlags, parent_window: *Window) -> void #foreign imgui "_ZN5ImGui30UpdateWindowParentAndRootLinksEP11ImGuiWindowiS1_";
CalcWindowNextAutoFitSize :: (window: *Window) -> ImVec2 #foreign imgui "_ZN5ImGui25CalcWindowNextAutoFitSizeEP11ImGuiWindow";
IsWindowChildOf :: (window: *Window, potential_parent: *Window, popup_hierarchy: bool, dock_hierarchy: bool) -> bool #foreign imgui "_ZN5ImGui15IsWindowChildOfEP11ImGuiWindowS1_bb";
IsWindowWithinBeginStackOf :: (window: *Window, potential_parent: *Window) -> bool #foreign imgui "_ZN5ImGui26IsWindowWithinBeginStackOfEP11ImGuiWindowS1_";
IsWindowAbove :: (potential_above: *Window, potential_below: *Window) -> bool #foreign imgui "_ZN5ImGui13IsWindowAboveEP11ImGuiWindowS1_";
IsWindowNavFocusable :: (window: *Window) -> bool #foreign imgui "_ZN5ImGui20IsWindowNavFocusableEP11ImGuiWindow";
SetWindowPos :: (window: *Window, pos: *ImVec2, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui12SetWindowPosEP11ImGuiWindowRK6ImVec2i";
SetWindowPos :: (window: *Window, pos: ImVec2, cond: Cond = .None) #no_context {
    SetWindowPos(window, *pos, cond);
}
SetWindowSize :: (window: *Window, size: *ImVec2, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui13SetWindowSizeEP11ImGuiWindowRK6ImVec2i";
SetWindowSize :: (window: *Window, size: ImVec2, cond: Cond = .None) #no_context {
    SetWindowSize(window, *size, cond);
}
SetWindowCollapsed :: (window: *Window, collapsed: bool, cond: Cond = .None) -> void #foreign imgui "_ZN5ImGui18SetWindowCollapsedEP11ImGuiWindowbi";
SetWindowHitTestHole :: (window: *Window, pos: *ImVec2, size: *ImVec2) -> void #foreign imgui "_ZN5ImGui20SetWindowHitTestHoleEP11ImGuiWindowRK6ImVec2S4_";
SetWindowHitTestHole :: (window: *Window, pos: ImVec2, size: ImVec2) #no_context {
    SetWindowHitTestHole(window, *pos, *size);
}
SetWindowHiddenAndSkipItemsForCurrentFrame :: (window: *Window) -> void #foreign imgui "_ZN5ImGui42SetWindowHiddenAndSkipItemsForCurrentFrameEP11ImGuiWindow";

// Windows: Display Order and Focus Order
FocusWindow :: (window: *Window, flags: FocusRequestFlags = .None) -> void #foreign imgui "_ZN5ImGui11FocusWindowEP11ImGuiWindowi";
FocusTopMostWindowUnderOne :: (under_this_window: *Window, ignore_window: *Window, filter_viewport: *Viewport, flags: FocusRequestFlags) -> void #foreign imgui "_ZN5ImGui26FocusTopMostWindowUnderOneEP11ImGuiWindowS1_P13ImGuiViewporti";
BringWindowToFocusFront :: (window: *Window) -> void #foreign imgui "_ZN5ImGui23BringWindowToFocusFrontEP11ImGuiWindow";
BringWindowToDisplayFront :: (window: *Window) -> void #foreign imgui "_ZN5ImGui25BringWindowToDisplayFrontEP11ImGuiWindow";
BringWindowToDisplayBack :: (window: *Window) -> void #foreign imgui "_ZN5ImGui24BringWindowToDisplayBackEP11ImGuiWindow";
BringWindowToDisplayBehind :: (window: *Window, above_window: *Window) -> void #foreign imgui "_ZN5ImGui26BringWindowToDisplayBehindEP11ImGuiWindowS1_";
FindWindowDisplayIndex :: (window: *Window) -> s32 #foreign imgui "_ZN5ImGui22FindWindowDisplayIndexEP11ImGuiWindow";
FindBottomMostVisibleWindowWithinBeginStack :: (window: *Window) -> *Window #foreign imgui "_ZN5ImGui43FindBottomMostVisibleWindowWithinBeginStackEP11ImGuiWindow";

// Fonts, drawing
SetCurrentFont :: (font: *ImFont) -> void #foreign imgui "_ZN5ImGui14SetCurrentFontEP6ImFont";

AddDrawListToDrawDataEx :: (draw_data: *ImDrawData, out_list: *ImVector(*ImDrawList), draw_list: *ImDrawList) -> void #foreign imgui "_ZN5ImGui23AddDrawListToDrawDataExEP10ImDrawDataP8ImVectorIP10ImDrawListES4_";

// Init
Initialize :: () -> void #foreign imgui "_ZN5ImGui10InitializeEv";
Shutdown :: () -> void #foreign imgui "_ZN5ImGui8ShutdownEv";

// NewFrame
UpdateInputEvents :: (trickle_fast_inputs: bool) -> void #foreign imgui "_ZN5ImGui17UpdateInputEventsEb";
UpdateHoveredWindowAndCaptureFlags :: () -> void #foreign imgui "_ZN5ImGui34UpdateHoveredWindowAndCaptureFlagsEv";
StartMouseMovingWindow :: (window: *Window) -> void #foreign imgui "_ZN5ImGui22StartMouseMovingWindowEP11ImGuiWindow";
StartMouseMovingWindowOrNode :: (window: *Window, node: *DockNode, undock: bool) -> void #foreign imgui "_ZN5ImGui28StartMouseMovingWindowOrNodeEP11ImGuiWindowP13ImGuiDockNodeb";
UpdateMouseMovingWindowNewFrame :: () -> void #foreign imgui "_ZN5ImGui31UpdateMouseMovingWindowNewFrameEv";
UpdateMouseMovingWindowEndFrame :: () -> void #foreign imgui "_ZN5ImGui31UpdateMouseMovingWindowEndFrameEv";

// Generic context hooks
AddContextHook :: (_context: *Context, hook: *ContextHook) -> ID #foreign imgui "_ZN5ImGui14AddContextHookEP12ImGuiContextPK16ImGuiContextHook";
RemoveContextHook :: (_context: *Context, hook_to_remove: ID) -> void #foreign imgui "_ZN5ImGui17RemoveContextHookEP12ImGuiContextj";
CallContextHooks :: (_context: *Context, type: ContextHookType) -> void #foreign imgui "_ZN5ImGui16CallContextHooksEP12ImGuiContext20ImGuiContextHookType";

// Viewports
TranslateWindowsInViewport :: (viewport: *ViewportP, old_pos: *ImVec2, new_pos: *ImVec2) -> void #foreign imgui "_ZN5ImGui26TranslateWindowsInViewportEP14ImGuiViewportPRK6ImVec2S4_";
TranslateWindowsInViewport :: (viewport: *ViewportP, old_pos: ImVec2, new_pos: ImVec2) #no_context {
    TranslateWindowsInViewport(viewport, *old_pos, *new_pos);
}
ScaleWindowsInViewport :: (viewport: *ViewportP, scale: float) -> void #foreign imgui "_ZN5ImGui22ScaleWindowsInViewportEP14ImGuiViewportPf";
DestroyPlatformWindow :: (viewport: *ViewportP) -> void #foreign imgui "_ZN5ImGui21DestroyPlatformWindowEP14ImGuiViewportP";
SetWindowViewport :: (window: *Window, viewport: *ViewportP) -> void #foreign imgui "_ZN5ImGui17SetWindowViewportEP11ImGuiWindowP14ImGuiViewportP";
SetCurrentViewport :: (window: *Window, viewport: *ViewportP) -> void #foreign imgui "_ZN5ImGui18SetCurrentViewportEP11ImGuiWindowP14ImGuiViewportP";
GetViewportPlatformMonitor :: (viewport: *Viewport) -> *PlatformMonitor #foreign imgui "_ZN5ImGui26GetViewportPlatformMonitorEP13ImGuiViewport";
FindHoveredViewportFromPlatformWindowStack :: (mouse_platform_pos: *ImVec2) -> *ViewportP #foreign imgui "_ZN5ImGui42FindHoveredViewportFromPlatformWindowStackERK6ImVec2";
FindHoveredViewportFromPlatformWindowStack :: (mouse_platform_pos: ImVec2) -> *ViewportP #no_context {
    return FindHoveredViewportFromPlatformWindowStack(*mouse_platform_pos);
}

// Settings
MarkIniSettingsDirty :: () -> void #foreign imgui "_ZN5ImGui20MarkIniSettingsDirtyEv";
MarkIniSettingsDirty :: (window: *Window) -> void #foreign imgui "_ZN5ImGui20MarkIniSettingsDirtyEP11ImGuiWindow";
ClearIniSettings :: () -> void #foreign imgui "_ZN5ImGui16ClearIniSettingsEv";
AddSettingsHandler :: (handler: *SettingsHandler) -> void #foreign imgui "_ZN5ImGui18AddSettingsHandlerEPK20ImGuiSettingsHandler";
RemoveSettingsHandler :: (type_name: *u8) -> void #foreign imgui "_ZN5ImGui21RemoveSettingsHandlerEPKc";
FindSettingsHandler :: (type_name: *u8) -> *SettingsHandler #foreign imgui "_ZN5ImGui19FindSettingsHandlerEPKc";

// Settings - Windows
CreateNewWindowSettings :: (name: *u8) -> *WindowSettings #foreign imgui "_ZN5ImGui23CreateNewWindowSettingsEPKc";
FindWindowSettingsByID :: (id: ID) -> *WindowSettings #foreign imgui "_ZN5ImGui22FindWindowSettingsByIDEj";
FindWindowSettingsByWindow :: (window: *Window) -> *WindowSettings #foreign imgui "_ZN5ImGui26FindWindowSettingsByWindowEP11ImGuiWindow";
ClearWindowSettings :: (name: *u8) -> void #foreign imgui "_ZN5ImGui19ClearWindowSettingsEPKc";

// Localization
LocalizeRegisterEntries :: (entries: *LocEntry, count: s32) -> void #foreign imgui "_ZN5ImGui23LocalizeRegisterEntriesEPK13ImGuiLocEntryi";

// Scrolling
SetScrollX :: (window: *Window, scroll_x: float) -> void #foreign imgui "_ZN5ImGui10SetScrollXEP11ImGuiWindowf";
SetScrollY :: (window: *Window, scroll_y: float) -> void #foreign imgui "_ZN5ImGui10SetScrollYEP11ImGuiWindowf";
SetScrollFromPosX :: (window: *Window, local_x: float, center_x_ratio: float) -> void #foreign imgui "_ZN5ImGui17SetScrollFromPosXEP11ImGuiWindowff";
SetScrollFromPosY :: (window: *Window, local_y: float, center_y_ratio: float) -> void #foreign imgui "_ZN5ImGui17SetScrollFromPosYEP11ImGuiWindowff";

// Early work-in-progress API (ScrollToItem() will become public)
ScrollToItem :: (flags: ScrollFlags = .None) -> void #foreign imgui "_ZN5ImGui12ScrollToItemEi";
ScrollToRect :: (window: *Window, rect: *ImRect, flags: ScrollFlags = .None) -> void #foreign imgui "_ZN5ImGui12ScrollToRectEP11ImGuiWindowRK6ImRecti";
ScrollToRect :: (window: *Window, rect: ImRect, flags: ScrollFlags = .None) #no_context {
    ScrollToRect(window, *rect, flags);
}
ScrollToRectEx :: (window: *Window, rect: *ImRect, flags: ScrollFlags = .None) -> ImVec2 #foreign imgui "_ZN5ImGui14ScrollToRectExEP11ImGuiWindowRK6ImRecti";
ScrollToRectEx :: (window: *Window, rect: ImRect, flags: ScrollFlags = .None) -> ImVec2 #no_context {
    return ScrollToRectEx(window, *rect, flags);
}

SetActiveID :: (id: ID, window: *Window) -> void #foreign imgui "_ZN5ImGui11SetActiveIDEjP11ImGuiWindow";
SetFocusID :: (id: ID, window: *Window) -> void #foreign imgui "_ZN5ImGui10SetFocusIDEjP11ImGuiWindow";
ClearActiveID :: () -> void #foreign imgui "_ZN5ImGui13ClearActiveIDEv";
GetHoveredID :: () -> ID #foreign imgui "_ZN5ImGui12GetHoveredIDEv";
SetHoveredID :: (id: ID) -> void #foreign imgui "_ZN5ImGui12SetHoveredIDEj";
KeepAliveID :: (id: ID) -> void #foreign imgui "_ZN5ImGui11KeepAliveIDEj";
MarkItemEdited :: (id: ID) -> void #foreign imgui "_ZN5ImGui14MarkItemEditedEj";
PushOverrideID :: (id: ID) -> void #foreign imgui "_ZN5ImGui14PushOverrideIDEj";
GetIDWithSeed :: (str_id_begin: *u8, str_id_end: *u8, seed: ID) -> ID #foreign imgui "_ZN5ImGui13GetIDWithSeedEPKcS1_j";
GetIDWithSeed :: (str_id: string, seed: ID) -> ID #no_context {
    return GetIDWithSeed(str_id.data, str_id.data + str_id.count, seed);
}
GetIDWithSeed :: (n: s32, seed: ID) -> ID #foreign imgui "_ZN5ImGui13GetIDWithSeedEij";

// Basic Helpers for widget code
ItemSize :: (size: *ImVec2, text_baseline_y: float = -1.0) -> void #foreign imgui "_ZN5ImGui8ItemSizeERK6ImVec2f";
ItemSize :: (size: ImVec2, text_baseline_y: float = -1.0) #no_context {
    ItemSize(*size, text_baseline_y);
}

ItemAdd :: (bb: *ImRect, id: ID, nav_bb: *ImRect = null, extra_flags: ItemFlags = .None) -> bool #foreign imgui "_ZN5ImGui7ItemAddERK6ImRectjPS1_i";
ItemAdd :: (bb: ImRect, id: ID, nav_bb: *ImRect = null, extra_flags: ItemFlags = .None) -> bool #no_context {
    return ItemAdd(*bb, id, nav_bb, extra_flags);
}
ItemHoverable :: (bb: *ImRect, id: ID, item_flags: ItemFlags) -> bool #foreign imgui "_ZN5ImGui13ItemHoverableERK6ImRectji";
ItemHoverable :: (bb: ImRect, id: ID, item_flags: ItemFlags) -> bool #no_context {
    return ItemHoverable(*bb, id, item_flags);
}
IsWindowContentHoverable :: (window: *Window, flags: HoveredFlags = .None) -> bool #foreign imgui "_ZN5ImGui24IsWindowContentHoverableEP11ImGuiWindowi";
IsClippedEx :: (bb: *ImRect, id: ID) -> bool #foreign imgui "_ZN5ImGui11IsClippedExERK6ImRectj";
IsClippedEx :: (bb: ImRect, id: ID) -> bool #no_context {
    return IsClippedEx(*bb, id);
}
SetLastItemData :: (item_id: ID, in_flags: ItemFlags, status_flags: ItemStatusFlags, item_rect: *ImRect) -> void #foreign imgui "_ZN5ImGui15SetLastItemDataEjiiRK6ImRect";
SetLastItemData :: (item_id: ID, in_flags: ItemFlags, status_flags: ItemStatusFlags, item_rect: ImRect) #no_context {
    SetLastItemData(item_id, in_flags, status_flags, *item_rect);
}
CalcItemSize :: (size: ImVec2, default_w: float, default_h: float) -> ImVec2 #foreign imgui "_ZN5ImGui12CalcItemSizeE6ImVec2ff";
CalcWrapWidthForPos :: (pos: *ImVec2, wrap_pos_x: float) -> float #foreign imgui "_ZN5ImGui19CalcWrapWidthForPosERK6ImVec2f";
CalcWrapWidthForPos :: (pos: ImVec2, wrap_pos_x: float) -> float #no_context {
    return CalcWrapWidthForPos(*pos, wrap_pos_x);
}
PushMultiItemsWidths :: (components: s32, width_full: float) -> void #foreign imgui "_ZN5ImGui20PushMultiItemsWidthsEif";
IsItemToggledSelection :: () -> bool #foreign imgui "_ZN5ImGui22IsItemToggledSelectionEv";
GetContentRegionMaxAbs :: () -> ImVec2 #foreign imgui "_ZN5ImGui22GetContentRegionMaxAbsEv";
ShrinkWidths :: (items: *ShrinkWidthItem, count: s32, width_excess: float) -> void #foreign imgui "_ZN5ImGui12ShrinkWidthsEP20ImGuiShrinkWidthItemif";

// Parameter stacks (shared)
PushItemFlag :: (option: ItemFlags, enabled: bool) -> void #foreign imgui "_ZN5ImGui12PushItemFlagEib";
PopItemFlag :: () -> void #foreign imgui "_ZN5ImGui11PopItemFlagEv";
GetStyleVarInfo :: (idx: StyleVar) -> *DataVarInfo #foreign imgui "_ZN5ImGui15GetStyleVarInfoEi";

// Logging/Capture
LogBegin :: (type: LogType, auto_open_depth: s32) -> void #foreign imgui "_ZN5ImGui8LogBeginE12ImGuiLogTypei";
LogToBuffer :: (auto_open_depth: s32 = -1) -> void #foreign imgui "_ZN5ImGui11LogToBufferEi";
LogRenderedText :: (ref_pos: *ImVec2, text: *u8, text_end: *u8 = null) -> void #foreign imgui "_ZN5ImGui15LogRenderedTextEPK6ImVec2PKcS4_";
LogRenderedText :: (ref_pos: *ImVec2, text: string) #no_context {
    LogRenderedText(ref_pos, text.data, text.data + text.count);
}
LogSetNextTextDecoration :: (prefix: *u8, suffix: *u8) -> void #foreign imgui "_ZN5ImGui24LogSetNextTextDecorationEPKcS1_";

// Popups, Modals, Tooltips
BeginChildEx :: (name: *u8, id: ID, size_arg: *ImVec2, child_flags: ChildFlags, window_flags: WindowFlags) -> bool #foreign imgui "_ZN5ImGui12BeginChildExEPKcjRK6ImVec2ii";
BeginChildEx :: (name: *u8, id: ID, size_arg: ImVec2, child_flags: ChildFlags, window_flags: WindowFlags) -> bool #no_context {
    return BeginChildEx(name, id, *size_arg, child_flags, window_flags);
}
OpenPopupEx :: (id: ID, popup_flags: PopupFlags = .None) -> void #foreign imgui "_ZN5ImGui11OpenPopupExEji";
ClosePopupToLevel :: (remaining: s32, restore_focus_to_window_under_popup: bool) -> void #foreign imgui "_ZN5ImGui17ClosePopupToLevelEib";
ClosePopupsOverWindow :: (ref_window: *Window, restore_focus_to_window_under_popup: bool) -> void #foreign imgui "_ZN5ImGui21ClosePopupsOverWindowEP11ImGuiWindowb";
ClosePopupsExceptModals :: () -> void #foreign imgui "_ZN5ImGui23ClosePopupsExceptModalsEv";
IsPopupOpen :: (id: ID, popup_flags: PopupFlags) -> bool #foreign imgui "_ZN5ImGui11IsPopupOpenEji";
BeginPopupEx :: (id: ID, extra_flags: WindowFlags) -> bool #foreign imgui "_ZN5ImGui12BeginPopupExEji";
BeginTooltipEx :: (tooltip_flags: TooltipFlags, extra_window_flags: WindowFlags) -> bool #foreign imgui "_ZN5ImGui14BeginTooltipExEii";
BeginTooltipHidden :: () -> bool #foreign imgui "_ZN5ImGui18BeginTooltipHiddenEv";
GetPopupAllowedExtentRect :: (window: *Window) -> ImRect #foreign imgui "_ZN5ImGui25GetPopupAllowedExtentRectEP11ImGuiWindow";
GetTopMostPopupModal :: () -> *Window #foreign imgui "_ZN5ImGui20GetTopMostPopupModalEv";
GetTopMostAndVisiblePopupModal :: () -> *Window #foreign imgui "_ZN5ImGui30GetTopMostAndVisiblePopupModalEv";
FindBlockingModal :: (window: *Window) -> *Window #foreign imgui "_ZN5ImGui17FindBlockingModalEP11ImGuiWindow";
FindBestWindowPosForPopup :: (window: *Window) -> ImVec2 #foreign imgui "_ZN5ImGui25FindBestWindowPosForPopupEP11ImGuiWindow";
FindBestWindowPosForPopupEx :: (ref_pos: *ImVec2, size: *ImVec2, last_dir: *Dir, r_outer: *ImRect, r_avoid: *ImRect, policy: PopupPositionPolicy) -> ImVec2 #foreign imgui "_ZN5ImGui27FindBestWindowPosForPopupExERK6ImVec2S2_PiRK6ImRectS6_24ImGuiPopupPositionPolicy";
FindBestWindowPosForPopupEx :: (ref_pos: ImVec2, size: ImVec2, last_dir: *Dir, r_outer: ImRect, r_avoid: ImRect, policy: PopupPositionPolicy) -> ImVec2 #no_context {
    return FindBestWindowPosForPopupEx(*ref_pos, *size, last_dir, *r_outer, *r_avoid, policy);
}

// Menus
BeginViewportSideBar :: (name: *u8, viewport: *Viewport, dir: Dir, size: float, window_flags: WindowFlags) -> bool #foreign imgui "_ZN5ImGui20BeginViewportSideBarEPKcP13ImGuiViewportifi";
BeginMenuEx :: (label: *u8, icon: *u8, enabled := true) -> bool #foreign imgui "_ZN5ImGui11BeginMenuExEPKcS1_b";
MenuItemEx :: (label: *u8, icon: *u8, shortcut: *u8 = null, selected := false, enabled := true) -> bool #foreign imgui "_ZN5ImGui10MenuItemExEPKcS1_S1_bb";

// Combos
BeginComboPopup :: (popup_id: ID, bb: *ImRect, flags: ComboFlags) -> bool #foreign imgui "_ZN5ImGui15BeginComboPopupEjRK6ImRecti";
BeginComboPopup :: (popup_id: ID, bb: ImRect, flags: ComboFlags) -> bool #no_context {
    return BeginComboPopup(popup_id, *bb, flags);
}
BeginComboPreview :: () -> bool #foreign imgui "_ZN5ImGui17BeginComboPreviewEv";
EndComboPreview :: () -> void #foreign imgui "_ZN5ImGui15EndComboPreviewEv";

// Gamepad/Keyboard Navigation
NavInitWindow :: (window: *Window, force_reinit: bool) -> void #foreign imgui "_ZN5ImGui13NavInitWindowEP11ImGuiWindowb";
NavInitRequestApplyResult :: () -> void #foreign imgui "_ZN5ImGui25NavInitRequestApplyResultEv";
NavMoveRequestButNoResultYet :: () -> bool #foreign imgui "_ZN5ImGui28NavMoveRequestButNoResultYetEv";
NavMoveRequestSubmit :: (move_dir: Dir, clip_dir: Dir, move_flags: NavMoveFlags, scroll_flags: ScrollFlags) -> void #foreign imgui "_ZN5ImGui20NavMoveRequestSubmitEiiii";
NavMoveRequestForward :: (move_dir: Dir, clip_dir: Dir, move_flags: NavMoveFlags, scroll_flags: ScrollFlags) -> void #foreign imgui "_ZN5ImGui21NavMoveRequestForwardEiiii";
NavMoveRequestResolveWithLastItem :: (result: *NavItemData) -> void #foreign imgui "_ZN5ImGui33NavMoveRequestResolveWithLastItemEP16ImGuiNavItemData";
NavMoveRequestResolveWithPastTreeNode :: (result: *NavItemData, tree_node_data: *NavTreeNodeData) -> void #foreign imgui "_ZN5ImGui37NavMoveRequestResolveWithPastTreeNodeEP16ImGuiNavItemDataP20ImGuiNavTreeNodeData";
NavMoveRequestCancel :: () -> void #foreign imgui "_ZN5ImGui20NavMoveRequestCancelEv";
NavMoveRequestApplyResult :: () -> void #foreign imgui "_ZN5ImGui25NavMoveRequestApplyResultEv";
NavMoveRequestTryWrapping :: (window: *Window, move_flags: NavMoveFlags) -> void #foreign imgui "_ZN5ImGui25NavMoveRequestTryWrappingEP11ImGuiWindowi";
NavHighlightActivated :: (id: ID) -> void #foreign imgui "_ZN5ImGui21NavHighlightActivatedEj";
NavClearPreferredPosForAxis :: (axis: Axis) -> void #foreign imgui "_ZN5ImGui27NavClearPreferredPosForAxisE9ImGuiAxis";
NavRestoreHighlightAfterMove :: () -> void #foreign imgui "_ZN5ImGui28NavRestoreHighlightAfterMoveEv";
NavUpdateCurrentWindowIsScrollPushableX :: () -> void #foreign imgui "_ZN5ImGui39NavUpdateCurrentWindowIsScrollPushableXEv";
SetNavWindow :: (window: *Window) -> void #foreign imgui "_ZN5ImGui12SetNavWindowEP11ImGuiWindow";
SetNavID :: (id: ID, nav_layer: NavLayer, focus_scope_id: ID, rect_rel: *ImRect) -> void #foreign imgui "_ZN5ImGui8SetNavIDEj13ImGuiNavLayerjRK6ImRect";
SetNavID :: (id: ID, nav_layer: NavLayer, focus_scope_id: ID, rect_rel: ImRect) #no_context {
    SetNavID(id, nav_layer, focus_scope_id, *rect_rel);
}
SetNavFocusScope :: (focus_scope_id: ID) -> void #foreign imgui "_ZN5ImGui16SetNavFocusScopeEj";

// Focus/Activation
// This should be part of a larger set of API: FocusItem(offset = -1), FocusItemByID(id), ActivateItem(offset = -1), ActivateItemByID(id) etc. which are
// much harder to design and implement than expected. I have a couple of private branches on this matter but it's not simple. For now implementing the easy ones.
FocusItem :: () -> void #foreign imgui "_ZN5ImGui9FocusItemEv";
ActivateItemByID :: (id: ID) -> void #foreign imgui "_ZN5ImGui16ActivateItemByIDEj";

FixupKeyChord :: (ctx: *Context, key_chord: KeyChord) -> KeyChord #foreign imgui "_ZN5ImGui13FixupKeyChordEP12ImGuiContexti";

GetKeyData :: (ctx: *Context, key: Key) -> *KeyData #foreign imgui "_ZN5ImGui10GetKeyDataEP12ImGuiContext8ImGuiKey";

GetKeyChordName :: (key_chord: KeyChord) -> *u8 #foreign imgui "_ZN5ImGui15GetKeyChordNameEi";

IsMouseDragPastThreshold :: (button: MouseButton, lock_threshold: float = -1.0) -> bool #foreign imgui "_ZN5ImGui24IsMouseDragPastThresholdEif";
GetKeyMagnitude2d :: (key_left: Key, key_right: Key, key_up: Key, key_down: Key) -> ImVec2 #foreign imgui "_ZN5ImGui17GetKeyMagnitude2dE8ImGuiKeyS0_S0_S0_";
GetNavTweakPressedAmount :: (axis: Axis) -> float #foreign imgui "_ZN5ImGui24GetNavTweakPressedAmountE9ImGuiAxis";
CalcTypematicRepeatAmount :: (t0: float, t1: float, repeat_delay: float, repeat_rate: float) -> s32 #foreign imgui "_ZN5ImGui25CalcTypematicRepeatAmountEffff";
GetTypematicRepeatRate :: (flags: InputFlags, repeat_delay: *float, repeat_rate: *float) -> void #foreign imgui "_ZN5ImGui22GetTypematicRepeatRateEiPfS0_";
TeleportMousePos :: (pos: *ImVec2) -> void #foreign imgui "_ZN5ImGui16TeleportMousePosERK6ImVec2";
TeleportMousePos :: (pos: ImVec2) #no_context {
    TeleportMousePos(*pos);
}
SetActiveIdUsingAllKeyboardKeys :: () -> void #foreign imgui "_ZN5ImGui31SetActiveIdUsingAllKeyboardKeysEv";

// [EXPERIMENTAL] Low-Level: Key/Input Ownership
// - The idea is that instead of "eating" a given input, we can link to an owner id.
// - Ownership is most often claimed as a result of reacting to a press/down event (but occasionally may be claimed ahead).
// - Input queries can then read input by specifying ImGuiKeyOwner_Any (== 0), ImGuiKeyOwner_None (== -1) or a custom ID.
// - Legacy input queries (without specifying an owner or _Any or _None) are equivalent to using ImGuiKeyOwner_Any (== 0).
// - Input ownership is automatically released on the frame after a key is released. Therefore:
//   - for ownership registration happening as a result of a down/press event, the SetKeyOwner() call may be done once (common case).
//   - for ownership registration happening ahead of a down/press event, the SetKeyOwner() call needs to be made every frame (happens if e.g. claiming ownership on hover).
// - SetItemKeyOwner() is a shortcut for common simple case. A custom widget will probably want to call SetKeyOwner() multiple times directly based on its interaction state.
// - This is marked experimental because not all widgets are fully honoring the Set/Test idioms. We will need to move forward step by step.
//   Please open a GitHub Issue to submit your usage scenario or if there's a use case you need solved.
GetKeyOwner :: (key: Key) -> ID #foreign imgui "_ZN5ImGui11GetKeyOwnerE8ImGuiKey";
SetKeyOwner :: (key: Key, owner_id: ID, flags: InputFlags = .None) -> void #foreign imgui "_ZN5ImGui11SetKeyOwnerE8ImGuiKeyji";
SetKeyOwnersForKeyChord :: (key: KeyChord, owner_id: ID, flags: InputFlags = .None) -> void #foreign imgui "_ZN5ImGui23SetKeyOwnersForKeyChordEiji";
SetItemKeyOwner :: (key: Key, flags: InputFlags = .None) -> void #foreign imgui "_ZN5ImGui15SetItemKeyOwnerE8ImGuiKeyi";
TestKeyOwner :: (key: Key, owner_id: ID) -> bool #foreign imgui "_ZN5ImGui12TestKeyOwnerE8ImGuiKeyj";

// [EXPERIMENTAL] High-Level: Input Access functions w/ support for Key/Input Ownership
// - Important: legacy IsKeyPressed(ImGuiKey, bool repeat=true) _DEFAULTS_ to repeat, new IsKeyPressed() requires _EXPLICIT_ ImGuiInputFlags_Repeat flag.
// - Expected to be later promoted to public API, the prototypes are designed to replace existing ones (since owner_id can default to Any == 0)
// - Specifying a value for 'ImGuiID owner' will test that EITHER the key is NOT owned (UNLESS locked), EITHER the key is owned by 'owner'.
//   Legacy functions use ImGuiKeyOwner_Any meaning that they typically ignore ownership, unless a call to SetKeyOwner() explicitly used ImGuiInputFlags_LockThisFrame or ImGuiInputFlags_LockUntilRelease.
// - Binding generators may want to ignore those for now, or suffix them with Ex() until we decide if this gets moved into public API.
IsKeyDown :: (key: Key, owner_id: ID) -> bool #foreign imgui "_ZN5ImGui9IsKeyDownE8ImGuiKeyj";
IsKeyPressed :: (key: Key, owner_id: ID, flags: InputFlags = .None) -> bool #foreign imgui "_ZN5ImGui12IsKeyPressedE8ImGuiKeyji";
IsKeyReleased :: (key: Key, owner_id: ID) -> bool #foreign imgui "_ZN5ImGui13IsKeyReleasedE8ImGuiKeyj";
IsMouseDown :: (button: MouseButton, owner_id: ID) -> bool #foreign imgui "_ZN5ImGui11IsMouseDownEij";
IsMouseClicked :: (button: MouseButton, owner_id: ID, flags: InputFlags = .None) -> bool #foreign imgui "_ZN5ImGui14IsMouseClickedEiji";
IsMouseReleased :: (button: MouseButton, owner_id: ID) -> bool #foreign imgui "_ZN5ImGui15IsMouseReleasedEij";
IsMouseDoubleClicked :: (button: MouseButton, owner_id: ID) -> bool #foreign imgui "_ZN5ImGui20IsMouseDoubleClickedEij";

// [EXPERIMENTAL] Shortcut Routing
// - ImGuiKeyChord = a ImGuiKey optionally OR-red with ImGuiMod_Alt/ImGuiMod_Ctrl/ImGuiMod_Shift/ImGuiMod_Super.
//     ImGuiKey_C                 (accepted by functions taking ImGuiKey or ImGuiKeyChord)
//     ImGuiKey_C | ImGuiMod_Ctrl (accepted by functions taking ImGuiKeyChord)
//   ONLY ImGuiMod_XXX values are legal to 'OR' with an ImGuiKey. You CANNOT 'OR' two ImGuiKey values.
// - When using one of the routing flags (e.g. ImGuiInputFlags_RouteFocused): routes requested ahead of time given a chord (key + modifiers) and a routing policy.
// - Routes are resolved during NewFrame(): if keyboard modifiers are matching current ones: SetKeyOwner() is called + route is granted for the frame.
// - Route is granted to a single owner. When multiple requests are made we have policies to select the winning route.
// - Multiple read sites may use the same owner id and will all get the granted route.
// - For routing: when owner_id is 0 we use the current Focus Scope ID as a default owner in order to identify our location.
// - TL;DR;
//   - IsKeyChordPressed() compares mods + call IsKeyPressed() -> function has no side-effect.
//   - Shortcut() submits a route then if currently can be routed calls IsKeyChordPressed() -> function has (desirable) side-effects.
IsKeyChordPressed :: (key_chord: KeyChord, owner_id: ID, flags: InputFlags = .None) -> bool #foreign imgui "_ZN5ImGui17IsKeyChordPressedEiji";
SetNextItemShortcut :: (key_chord: KeyChord) -> void #foreign imgui "_ZN5ImGui19SetNextItemShortcutEi";
Shortcut :: (key_chord: KeyChord, owner_id: ID = 0, flags: InputFlags = .None) -> bool #foreign imgui "_ZN5ImGui8ShortcutEiji";
SetShortcutRouting :: (key_chord: KeyChord, owner_id: ID, flags: InputFlags = .None) -> bool #foreign imgui "_ZN5ImGui18SetShortcutRoutingEiji";
TestShortcutRouting :: (key_chord: KeyChord, owner_id: ID) -> bool #foreign imgui "_ZN5ImGui19TestShortcutRoutingEij";
GetShortcutRoutingData :: (key_chord: KeyChord) -> *KeyRoutingData #foreign imgui "_ZN5ImGui22GetShortcutRoutingDataEi";

// Docking
// (some functions are only declared in imgui.cpp, see Docking section)
DockContextInitialize :: (ctx: *Context) -> void #foreign imgui "_ZN5ImGui21DockContextInitializeEP12ImGuiContext";
DockContextShutdown :: (ctx: *Context) -> void #foreign imgui "_ZN5ImGui19DockContextShutdownEP12ImGuiContext";
DockContextClearNodes :: (ctx: *Context, root_id: ID, clear_settings_refs: bool) -> void #foreign imgui "_ZN5ImGui21DockContextClearNodesEP12ImGuiContextjb";
DockContextRebuildNodes :: (ctx: *Context) -> void #foreign imgui "_ZN5ImGui23DockContextRebuildNodesEP12ImGuiContext";
DockContextNewFrameUpdateUndocking :: (ctx: *Context) -> void #foreign imgui "_ZN5ImGui34DockContextNewFrameUpdateUndockingEP12ImGuiContext";
DockContextNewFrameUpdateDocking :: (ctx: *Context) -> void #foreign imgui "_ZN5ImGui32DockContextNewFrameUpdateDockingEP12ImGuiContext";
DockContextEndFrame :: (ctx: *Context) -> void #foreign imgui "_ZN5ImGui19DockContextEndFrameEP12ImGuiContext";
DockContextGenNodeID :: (ctx: *Context) -> ID #foreign imgui "_ZN5ImGui20DockContextGenNodeIDEP12ImGuiContext";
DockContextQueueDock :: (ctx: *Context, target: *Window, target_node: *DockNode, payload: *Window, split_dir: Dir, split_ratio: float, split_outer: bool) -> void #foreign imgui "_ZN5ImGui20DockContextQueueDockEP12ImGuiContextP11ImGuiWindowP13ImGuiDockNodeS3_ifb";
DockContextQueueUndockWindow :: (ctx: *Context, window: *Window) -> void #foreign imgui "_ZN5ImGui28DockContextQueueUndockWindowEP12ImGuiContextP11ImGuiWindow";
DockContextQueueUndockNode :: (ctx: *Context, node: *DockNode) -> void #foreign imgui "_ZN5ImGui26DockContextQueueUndockNodeEP12ImGuiContextP13ImGuiDockNode";
DockContextProcessUndockWindow :: (ctx: *Context, window: *Window, clear_persistent_docking_ref := true) -> void #foreign imgui "_ZN5ImGui30DockContextProcessUndockWindowEP12ImGuiContextP11ImGuiWindowb";
DockContextProcessUndockNode :: (ctx: *Context, node: *DockNode) -> void #foreign imgui "_ZN5ImGui28DockContextProcessUndockNodeEP12ImGuiContextP13ImGuiDockNode";
DockContextCalcDropPosForDocking :: (target: *Window, target_node: *DockNode, payload_window: *Window, payload_node: *DockNode, split_dir: Dir, split_outer: bool, out_pos: *ImVec2) -> bool #foreign imgui "_ZN5ImGui32DockContextCalcDropPosForDockingEP11ImGuiWindowP13ImGuiDockNodeS1_S3_ibP6ImVec2";
DockContextFindNodeByID :: (ctx: *Context, id: ID) -> *DockNode #foreign imgui "_ZN5ImGui23DockContextFindNodeByIDEP12ImGuiContextj";
DockNodeWindowMenuHandler_Default :: (ctx: *Context, node: *DockNode, tab_bar: *TabBar) -> void #foreign imgui "_ZN5ImGui33DockNodeWindowMenuHandler_DefaultEP12ImGuiContextP13ImGuiDockNodeP11ImGuiTabBar";
DockNodeBeginAmendTabBar :: (node: *DockNode) -> bool #foreign imgui "_ZN5ImGui24DockNodeBeginAmendTabBarEP13ImGuiDockNode";
DockNodeEndAmendTabBar :: () -> void #foreign imgui "_ZN5ImGui22DockNodeEndAmendTabBarEv";

GetWindowAlwaysWantOwnTabBar :: (window: *Window) -> bool #foreign imgui "_ZN5ImGui28GetWindowAlwaysWantOwnTabBarEP11ImGuiWindow";
BeginDocked :: (window: *Window, p_open: *bool) -> void #foreign imgui "_ZN5ImGui11BeginDockedEP11ImGuiWindowPb";
BeginDockableDragDropSource :: (window: *Window) -> void #foreign imgui "_ZN5ImGui27BeginDockableDragDropSourceEP11ImGuiWindow";
BeginDockableDragDropTarget :: (window: *Window) -> void #foreign imgui "_ZN5ImGui27BeginDockableDragDropTargetEP11ImGuiWindow";
SetWindowDock :: (window: *Window, dock_id: ID, cond: Cond) -> void #foreign imgui "_ZN5ImGui13SetWindowDockEP11ImGuiWindowji";

// Docking - Builder function needs to be generally called before the node is used/submitted.
// - The DockBuilderXXX functions are designed to _eventually_ become a public API, but it is too early to expose it and guarantee stability.
// - Do not hold on ImGuiDockNode* pointers! They may be invalidated by any split/merge/remove operation and every frame.
// - To create a DockSpace() node, make sure to set the ImGuiDockNodeFlags_DockSpace flag when calling DockBuilderAddNode().
//   You can create dockspace nodes (attached to a window) _or_ floating nodes (carry its own window) with this API.
// - DockBuilderSplitNode() create 2 child nodes within 1 node. The initial node becomes a parent node.
// - If you intend to split the node immediately after creation using DockBuilderSplitNode(), make sure
//   to call DockBuilderSetNodeSize() beforehand. If you don't, the resulting split sizes may not be reliable.
// - Call DockBuilderFinish() after you are done.
DockBuilderDockWindow :: (window_name: *u8, node_id: ID) -> void #foreign imgui "_ZN5ImGui21DockBuilderDockWindowEPKcj";
DockBuilderGetNode :: (node_id: ID) -> *DockNode #foreign imgui "_ZN5ImGui18DockBuilderGetNodeEj";

DockBuilderAddNode :: (node_id: ID = 0, flags: DockNodeFlags = .None) -> ID #foreign imgui "_ZN5ImGui18DockBuilderAddNodeEji";
DockBuilderRemoveNode :: (node_id: ID) -> void #foreign imgui "_ZN5ImGui21DockBuilderRemoveNodeEj";
DockBuilderRemoveNodeDockedWindows :: (node_id: ID, clear_settings_refs := true) -> void #foreign imgui "_ZN5ImGui34DockBuilderRemoveNodeDockedWindowsEjb";
DockBuilderRemoveNodeChildNodes :: (node_id: ID) -> void #foreign imgui "_ZN5ImGui31DockBuilderRemoveNodeChildNodesEj";
DockBuilderSetNodePos :: (node_id: ID, pos: ImVec2) -> void #foreign imgui "_ZN5ImGui21DockBuilderSetNodePosEj6ImVec2";
DockBuilderSetNodeSize :: (node_id: ID, size: ImVec2) -> void #foreign imgui "_ZN5ImGui22DockBuilderSetNodeSizeEj6ImVec2";
DockBuilderSplitNode :: (node_id: ID, split_dir: Dir, size_ratio_for_node_at_dir: float, out_id_at_dir: *ID, out_id_at_opposite_dir: *ID) -> ID #foreign imgui "_ZN5ImGui20DockBuilderSplitNodeEjifPjS0_";
DockBuilderCopyDockSpace :: (src_dockspace_id: ID, dst_dockspace_id: ID, in_window_remap_pairs: *ImVector(*u8)) -> void #foreign imgui "_ZN5ImGui24DockBuilderCopyDockSpaceEjjP8ImVectorIPKcE";
DockBuilderCopyNode :: (src_node_id: ID, dst_node_id: ID, out_node_remap_pairs: *ImVector(ID)) -> void #foreign imgui "_ZN5ImGui19DockBuilderCopyNodeEjjP8ImVectorIjE";
DockBuilderCopyWindowSettings :: (src_name: *u8, dst_name: *u8) -> void #foreign imgui "_ZN5ImGui29DockBuilderCopyWindowSettingsEPKcS1_";
DockBuilderFinish :: (node_id: ID) -> void #foreign imgui "_ZN5ImGui17DockBuilderFinishEj";

// [EXPERIMENTAL] Focus Scope
// This is generally used to identify a unique input location (for e.g. a selection set)
// There is one per window (automatically set in Begin), but:
// - Selection patterns generally need to react (e.g. clear a selection) when landing on one item of the set.
//   So in order to identify a set multiple lists in same window may each need a focus scope.
//   If you imagine an hypothetical BeginSelectionGroup()/EndSelectionGroup() api, it would likely call PushFocusScope()/EndFocusScope()
// - Shortcut routing also use focus scope as a default location identifier if an owner is not provided.
// We don't use the ID Stack for this as it is common to want them separate.
PushFocusScope :: (id: ID) -> void #foreign imgui "_ZN5ImGui14PushFocusScopeEj";
PopFocusScope :: () -> void #foreign imgui "_ZN5ImGui13PopFocusScopeEv";

// Drag and Drop
IsDragDropActive :: () -> bool #foreign imgui "_ZN5ImGui16IsDragDropActiveEv";
BeginDragDropTargetCustom :: (bb: *ImRect, id: ID) -> bool #foreign imgui "_ZN5ImGui25BeginDragDropTargetCustomERK6ImRectj";
BeginDragDropTargetCustom :: (bb: ImRect, id: ID) -> bool #no_context {
    return BeginDragDropTargetCustom(*bb, id);
}
ClearDragDrop :: () -> void #foreign imgui "_ZN5ImGui13ClearDragDropEv";
IsDragDropPayloadBeingAccepted :: () -> bool #foreign imgui "_ZN5ImGui30IsDragDropPayloadBeingAcceptedEv";
RenderDragDropTargetRect :: (bb: *ImRect, item_clip_rect: *ImRect) -> void #foreign imgui "_ZN5ImGui24RenderDragDropTargetRectERK6ImRectS2_";
RenderDragDropTargetRect :: (bb: ImRect, item_clip_rect: ImRect) #no_context {
    RenderDragDropTargetRect(*bb, *item_clip_rect);
}

// Typing-Select API
GetTypingSelectRequest :: (flags: TypingSelectFlags = .None) -> *TypingSelectRequest #foreign imgui "_ZN5ImGui22GetTypingSelectRequestEi";
TypingSelectFindMatch :: (req: *TypingSelectRequest, items_count: s32, get_item_name_func: #type (unknown0: *void, unknown1: s32) -> *u8 #c_call, user_data: *void, nav_item_idx: s32) -> s32 #foreign imgui "_ZN5ImGui21TypingSelectFindMatchEP24ImGuiTypingSelectRequestiPFPKcPviES4_i";
TypingSelectFindNextSingleCharMatch :: (req: *TypingSelectRequest, items_count: s32, get_item_name_func: #type (unknown0: *void, unknown1: s32) -> *u8 #c_call, user_data: *void, nav_item_idx: s32) -> s32 #foreign imgui "_ZN5ImGui35TypingSelectFindNextSingleCharMatchEP24ImGuiTypingSelectRequestiPFPKcPviES4_i";
TypingSelectFindBestLeadingMatch :: (req: *TypingSelectRequest, items_count: s32, get_item_name_func: #type (unknown0: *void, unknown1: s32) -> *u8 #c_call, user_data: *void) -> s32 #foreign imgui "_ZN5ImGui32TypingSelectFindBestLeadingMatchEP24ImGuiTypingSelectRequestiPFPKcPviES4_";

// Internal Columns API (this is not exposed because we will encourage transitioning to the Tables API)
SetWindowClipRectBeforeSetChannel :: (window: *Window, clip_rect: *ImRect) -> void #foreign imgui "_ZN5ImGui33SetWindowClipRectBeforeSetChannelEP11ImGuiWindowRK6ImRect";
SetWindowClipRectBeforeSetChannel :: (window: *Window, clip_rect: ImRect) #no_context {
    SetWindowClipRectBeforeSetChannel(window, *clip_rect);
}
BeginColumns :: (str_id: *u8, count: s32, flags: OldColumnFlags = .None) -> void #foreign imgui "_ZN5ImGui12BeginColumnsEPKcii";
EndColumns :: () -> void #foreign imgui "_ZN5ImGui10EndColumnsEv";
PushColumnClipRect :: (column_index: s32) -> void #foreign imgui "_ZN5ImGui18PushColumnClipRectEi";
PushColumnsBackground :: () -> void #foreign imgui "_ZN5ImGui21PushColumnsBackgroundEv";
PopColumnsBackground :: () -> void #foreign imgui "_ZN5ImGui20PopColumnsBackgroundEv";
GetColumnsID :: (str_id: *u8, count: s32) -> ID #foreign imgui "_ZN5ImGui12GetColumnsIDEPKci";
FindOrCreateColumns :: (window: *Window, id: ID) -> *OldColumns #foreign imgui "_ZN5ImGui19FindOrCreateColumnsEP11ImGuiWindowj";
GetColumnOffsetFromNorm :: (columns: *OldColumns, offset_norm: float) -> float #foreign imgui "_ZN5ImGui23GetColumnOffsetFromNormEPK15ImGuiOldColumnsf";
GetColumnNormFromOffset :: (columns: *OldColumns, offset: float) -> float #foreign imgui "_ZN5ImGui23GetColumnNormFromOffsetEPK15ImGuiOldColumnsf";

// Tables: Candidates for public API
TableOpenContextMenu :: (column_n: s32 = -1) -> void #foreign imgui "_ZN5ImGui20TableOpenContextMenuEi";
TableSetColumnWidth :: (column_n: s32, width: float) -> void #foreign imgui "_ZN5ImGui19TableSetColumnWidthEif";
TableSetColumnSortDirection :: (column_n: s32, sort_direction: SortDirection, append_to_sort_specs: bool) -> void #foreign imgui "_ZN5ImGui27TableSetColumnSortDirectionEiib";
TableGetHoveredColumn :: () -> s32 #foreign imgui "_ZN5ImGui21TableGetHoveredColumnEv";
TableGetHoveredRow :: () -> s32 #foreign imgui "_ZN5ImGui18TableGetHoveredRowEv";
TableGetHeaderRowHeight :: () -> float #foreign imgui "_ZN5ImGui23TableGetHeaderRowHeightEv";
TableGetHeaderAngledMaxLabelWidth :: () -> float #foreign imgui "_ZN5ImGui33TableGetHeaderAngledMaxLabelWidthEv";
TablePushBackgroundChannel :: () -> void #foreign imgui "_ZN5ImGui26TablePushBackgroundChannelEv";
TablePopBackgroundChannel :: () -> void #foreign imgui "_ZN5ImGui25TablePopBackgroundChannelEv";
TableAngledHeadersRowEx :: (angle: float, max_label_width: float = 0.0) -> void #foreign imgui "_ZN5ImGui23TableAngledHeadersRowExEff";

TableFindByID :: (id: ID) -> *Table #foreign imgui "_ZN5ImGui13TableFindByIDEj";
BeginTableEx :: (name: *u8, id: ID, columns_count: s32, flags: TableFlags = .None, outer_size: *ImVec2, inner_width: float = 0.0) -> bool #foreign imgui "_ZN5ImGui12BeginTableExEPKcjiiRK6ImVec2f";
BeginTableEx :: (name: *u8, id: ID, columns_count: s32, flags: TableFlags = .None, outer_size: ImVec2 = ImVec2.{0, 0}, inner_width: float = 0.0) -> bool #no_context {
    return BeginTableEx(name, id, columns_count, flags, *outer_size, inner_width);
}
TableBeginInitMemory :: (table: *Table, columns_count: s32) -> void #foreign imgui "_ZN5ImGui20TableBeginInitMemoryEP10ImGuiTablei";
TableBeginApplyRequests :: (table: *Table) -> void #foreign imgui "_ZN5ImGui23TableBeginApplyRequestsEP10ImGuiTable";
TableSetupDrawChannels :: (table: *Table) -> void #foreign imgui "_ZN5ImGui22TableSetupDrawChannelsEP10ImGuiTable";
TableUpdateLayout :: (table: *Table) -> void #foreign imgui "_ZN5ImGui17TableUpdateLayoutEP10ImGuiTable";
TableUpdateBorders :: (table: *Table) -> void #foreign imgui "_ZN5ImGui18TableUpdateBordersEP10ImGuiTable";
TableUpdateColumnsWeightFromWidth :: (table: *Table) -> void #foreign imgui "_ZN5ImGui33TableUpdateColumnsWeightFromWidthEP10ImGuiTable";
TableDrawBorders :: (table: *Table) -> void #foreign imgui "_ZN5ImGui16TableDrawBordersEP10ImGuiTable";
TableDrawDefaultContextMenu :: (table: *Table, flags_for_section_to_display: TableFlags) -> void #foreign imgui "_ZN5ImGui27TableDrawDefaultContextMenuEP10ImGuiTablei";
TableBeginContextMenuPopup :: (table: *Table) -> bool #foreign imgui "_ZN5ImGui26TableBeginContextMenuPopupEP10ImGuiTable";
TableMergeDrawChannels :: (table: *Table) -> void #foreign imgui "_ZN5ImGui22TableMergeDrawChannelsEP10ImGuiTable";

TableSortSpecsSanitize :: (table: *Table) -> void #foreign imgui "_ZN5ImGui22TableSortSpecsSanitizeEP10ImGuiTable";
TableSortSpecsBuild :: (table: *Table) -> void #foreign imgui "_ZN5ImGui19TableSortSpecsBuildEP10ImGuiTable";
TableGetColumnNextSortDirection :: (column: *TableColumn) -> SortDirection #foreign imgui "_ZN5ImGui31TableGetColumnNextSortDirectionEP16ImGuiTableColumn";
TableFixColumnSortDirection :: (table: *Table, column: *TableColumn) -> void #foreign imgui "_ZN5ImGui27TableFixColumnSortDirectionEP10ImGuiTableP16ImGuiTableColumn";
TableGetColumnWidthAuto :: (table: *Table, column: *TableColumn) -> float #foreign imgui "_ZN5ImGui23TableGetColumnWidthAutoEP10ImGuiTableP16ImGuiTableColumn";
TableBeginRow :: (table: *Table) -> void #foreign imgui "_ZN5ImGui13TableBeginRowEP10ImGuiTable";
TableEndRow :: (table: *Table) -> void #foreign imgui "_ZN5ImGui11TableEndRowEP10ImGuiTable";
TableBeginCell :: (table: *Table, column_n: s32) -> void #foreign imgui "_ZN5ImGui14TableBeginCellEP10ImGuiTablei";
TableEndCell :: (table: *Table) -> void #foreign imgui "_ZN5ImGui12TableEndCellEP10ImGuiTable";
TableGetCellBgRect :: (table: *Table, column_n: s32) -> ImRect #foreign imgui "_ZN5ImGui18TableGetCellBgRectEPK10ImGuiTablei";
TableGetColumnName :: (table: *Table, column_n: s32) -> *u8 #foreign imgui "_ZN5ImGui18TableGetColumnNameEPK10ImGuiTablei";
TableGetColumnResizeID :: (table: *Table, column_n: s32, instance_no: s32 = 0) -> ID #foreign imgui "_ZN5ImGui22TableGetColumnResizeIDEP10ImGuiTableii";
TableGetMaxColumnWidth :: (table: *Table, column_n: s32) -> float #foreign imgui "_ZN5ImGui22TableGetMaxColumnWidthEPK10ImGuiTablei";
TableSetColumnWidthAutoSingle :: (table: *Table, column_n: s32) -> void #foreign imgui "_ZN5ImGui29TableSetColumnWidthAutoSingleEP10ImGuiTablei";
TableSetColumnWidthAutoAll :: (table: *Table) -> void #foreign imgui "_ZN5ImGui26TableSetColumnWidthAutoAllEP10ImGuiTable";
TableRemove :: (table: *Table) -> void #foreign imgui "_ZN5ImGui11TableRemoveEP10ImGuiTable";
TableGcCompactTransientBuffers :: (table: *Table) -> void #foreign imgui "_ZN5ImGui30TableGcCompactTransientBuffersEP10ImGuiTable";
TableGcCompactTransientBuffers :: (table: *TableTempData) -> void #foreign imgui "_ZN5ImGui30TableGcCompactTransientBuffersEP18ImGuiTableTempData";
TableGcCompactSettings :: () -> void #foreign imgui "_ZN5ImGui22TableGcCompactSettingsEv";

// Tables: Settings
TableLoadSettings :: (table: *Table) -> void #foreign imgui "_ZN5ImGui17TableLoadSettingsEP10ImGuiTable";
TableSaveSettings :: (table: *Table) -> void #foreign imgui "_ZN5ImGui17TableSaveSettingsEP10ImGuiTable";
TableResetSettings :: (table: *Table) -> void #foreign imgui "_ZN5ImGui18TableResetSettingsEP10ImGuiTable";
TableGetBoundSettings :: (table: *Table) -> *TableSettings #foreign imgui "_ZN5ImGui21TableGetBoundSettingsEP10ImGuiTable";
TableSettingsAddSettingsHandler :: () -> void #foreign imgui "_ZN5ImGui31TableSettingsAddSettingsHandlerEv";
TableSettingsCreate :: (id: ID, columns_count: s32) -> *TableSettings #foreign imgui "_ZN5ImGui19TableSettingsCreateEji";
TableSettingsFindByID :: (id: ID) -> *TableSettings #foreign imgui "_ZN5ImGui21TableSettingsFindByIDEj";

BeginTabBarEx :: (tab_bar: *TabBar, bb: *ImRect, flags: TabBarFlags) -> bool #foreign imgui "_ZN5ImGui13BeginTabBarExEP11ImGuiTabBarRK6ImRecti";
BeginTabBarEx :: (tab_bar: *TabBar, bb: ImRect, flags: TabBarFlags) -> bool #no_context {
    return BeginTabBarEx(tab_bar, *bb, flags);
}
TabBarFindTabByID :: (tab_bar: *TabBar, tab_id: ID) -> *TabItem #foreign imgui "_ZN5ImGui17TabBarFindTabByIDEP11ImGuiTabBarj";
TabBarFindTabByOrder :: (tab_bar: *TabBar, order: s32) -> *TabItem #foreign imgui "_ZN5ImGui20TabBarFindTabByOrderEP11ImGuiTabBari";
TabBarFindMostRecentlySelectedTabForActiveWindow :: (tab_bar: *TabBar) -> *TabItem #foreign imgui "_ZN5ImGui48TabBarFindMostRecentlySelectedTabForActiveWindowEP11ImGuiTabBar";
TabBarGetCurrentTab :: (tab_bar: *TabBar) -> *TabItem #foreign imgui "_ZN5ImGui19TabBarGetCurrentTabEP11ImGuiTabBar";
TabBarGetTabOrder :: (tab_bar: *TabBar, tab: *TabItem) -> s32 #foreign imgui "_ZN5ImGui17TabBarGetTabOrderEP11ImGuiTabBarP12ImGuiTabItem";
TabBarGetTabName :: (tab_bar: *TabBar, tab: *TabItem) -> *u8 #foreign imgui "_ZN5ImGui16TabBarGetTabNameEP11ImGuiTabBarP12ImGuiTabItem";
TabBarAddTab :: (tab_bar: *TabBar, tab_flags: TabItemFlags, window: *Window) -> void #foreign imgui "_ZN5ImGui12TabBarAddTabEP11ImGuiTabBariP11ImGuiWindow";
TabBarRemoveTab :: (tab_bar: *TabBar, tab_id: ID) -> void #foreign imgui "_ZN5ImGui15TabBarRemoveTabEP11ImGuiTabBarj";
TabBarCloseTab :: (tab_bar: *TabBar, tab: *TabItem) -> void #foreign imgui "_ZN5ImGui14TabBarCloseTabEP11ImGuiTabBarP12ImGuiTabItem";
TabBarQueueFocus :: (tab_bar: *TabBar, tab: *TabItem) -> void #foreign imgui "_ZN5ImGui16TabBarQueueFocusEP11ImGuiTabBarP12ImGuiTabItem";
TabBarQueueReorder :: (tab_bar: *TabBar, tab: *TabItem, offset: s32) -> void #foreign imgui "_ZN5ImGui18TabBarQueueReorderEP11ImGuiTabBarP12ImGuiTabItemi";
TabBarQueueReorderFromMousePos :: (tab_bar: *TabBar, tab: *TabItem, mouse_pos: ImVec2) -> void #foreign imgui "_ZN5ImGui30TabBarQueueReorderFromMousePosEP11ImGuiTabBarP12ImGuiTabItem6ImVec2";
TabBarProcessReorder :: (tab_bar: *TabBar) -> bool #foreign imgui "_ZN5ImGui20TabBarProcessReorderEP11ImGuiTabBar";
TabItemEx :: (tab_bar: *TabBar, label: *u8, p_open: *bool, flags: TabItemFlags, docked_window: *Window) -> bool #foreign imgui "_ZN5ImGui9TabItemExEP11ImGuiTabBarPKcPbiP11ImGuiWindow";
TabItemCalcSize :: (label: *u8, has_close_button_or_unsaved_marker: bool) -> ImVec2 #foreign imgui "_ZN5ImGui15TabItemCalcSizeEPKcb";
TabItemCalcSize :: (window: *Window) -> ImVec2 #foreign imgui "_ZN5ImGui15TabItemCalcSizeEP11ImGuiWindow";
TabItemBackground :: (draw_list: *ImDrawList, bb: *ImRect, flags: TabItemFlags, col: ImU32) -> void #foreign imgui "_ZN5ImGui17TabItemBackgroundEP10ImDrawListRK6ImRectij";
TabItemBackground :: (draw_list: *ImDrawList, bb: ImRect, flags: TabItemFlags, col: ImU32) #no_context {
    TabItemBackground(draw_list, *bb, flags, col);
}
TabItemLabelAndCloseButton :: (draw_list: *ImDrawList, bb: *ImRect, flags: TabItemFlags, frame_padding: ImVec2, label: *u8, tab_id: ID, close_button_id: ID, is_contents_visible: bool, out_just_closed: *bool, out_text_clipped: *bool) -> void #foreign imgui "_ZN5ImGui26TabItemLabelAndCloseButtonEP10ImDrawListRK6ImRecti6ImVec2PKcjjbPbS8_";
TabItemLabelAndCloseButton :: (draw_list: *ImDrawList, bb: ImRect, flags: TabItemFlags, frame_padding: ImVec2, label: *u8, tab_id: ID, close_button_id: ID, is_contents_visible: bool, out_just_closed: *bool, out_text_clipped: *bool) #no_context {
    TabItemLabelAndCloseButton(draw_list, *bb, flags, frame_padding, label, tab_id, close_button_id, is_contents_visible, out_just_closed, out_text_clipped);
}

// Render helpers
// AVOID USING OUTSIDE OF IMGUI.CPP! NOT FOR PUBLIC CONSUMPTION. THOSE FUNCTIONS ARE A MESS. THEIR SIGNATURE AND BEHAVIOR WILL CHANGE, THEY NEED TO BE REFACTORED INTO SOMETHING DECENT.
// NB: All position are in absolute pixels coordinates (we are never using window coordinates internally)
RenderText :: (pos: ImVec2, text: *u8, text_end: *u8 = null, hide_text_after_hash := true) -> void #foreign imgui "_ZN5ImGui10RenderTextE6ImVec2PKcS2_b";
RenderText :: (pos: ImVec2, text: string, hide_text_after_hash := true) #no_context {
    RenderText(pos, text.data, text.data + text.count, hide_text_after_hash);
}
RenderTextWrapped :: (pos: ImVec2, text: *u8, text_end: *u8, wrap_width: float) -> void #foreign imgui "_ZN5ImGui17RenderTextWrappedE6ImVec2PKcS2_f";
RenderTextWrapped :: (pos: ImVec2, text: string, wrap_width: float) #no_context {
    RenderTextWrapped(pos, text.data, text.data + text.count, wrap_width);
}
RenderTextClipped :: (pos_min: *ImVec2, pos_max: *ImVec2, text: *u8, text_end: *u8, text_size_if_known: *ImVec2, align: *ImVec2, clip_rect: *ImRect = null) -> void #foreign imgui "_ZN5ImGui17RenderTextClippedERK6ImVec2S2_PKcS4_PS1_S2_PK6ImRect";
RenderTextClipped :: (pos_min: ImVec2, pos_max: ImVec2, text: string, text_size_if_known: *ImVec2, align: ImVec2 = ImVec2.{0, 0}, clip_rect: *ImRect = null) #no_context {
    RenderTextClipped(*pos_min, *pos_max, text.data, text.data + text.count, text_size_if_known, *align, clip_rect);
}
RenderTextClippedEx :: (draw_list: *ImDrawList, pos_min: *ImVec2, pos_max: *ImVec2, text: *u8, text_end: *u8, text_size_if_known: *ImVec2, align: *ImVec2, clip_rect: *ImRect = null) -> void #foreign imgui "_ZN5ImGui19RenderTextClippedExEP10ImDrawListRK6ImVec2S4_PKcS6_PS3_S4_PK6ImRect";
RenderTextClippedEx :: (draw_list: *ImDrawList, pos_min: ImVec2, pos_max: ImVec2, text: string, text_size_if_known: *ImVec2, align: ImVec2 = ImVec2.{0, 0}, clip_rect: *ImRect = null) #no_context {
    RenderTextClippedEx(draw_list, *pos_min, *pos_max, text.data, text.data + text.count, text_size_if_known, *align, clip_rect);
}
RenderTextEllipsis :: (draw_list: *ImDrawList, pos_min: *ImVec2, pos_max: *ImVec2, clip_max_x: float, ellipsis_max_x: float, text: *u8, text_end: *u8, text_size_if_known: *ImVec2) -> void #foreign imgui "_ZN5ImGui18RenderTextEllipsisEP10ImDrawListRK6ImVec2S4_ffPKcS6_PS3_";
RenderTextEllipsis :: (draw_list: *ImDrawList, pos_min: ImVec2, pos_max: ImVec2, clip_max_x: float, ellipsis_max_x: float, text: string, text_size_if_known: *ImVec2) #no_context {
    RenderTextEllipsis(draw_list, *pos_min, *pos_max, clip_max_x, ellipsis_max_x, text.data, text.data + text.count, text_size_if_known);
}
RenderFrame :: (p_min: ImVec2, p_max: ImVec2, fill_col: ImU32, border := true, rounding: float = 0.0) -> void #foreign imgui "_ZN5ImGui11RenderFrameE6ImVec2S0_jbf";
RenderFrameBorder :: (p_min: ImVec2, p_max: ImVec2, rounding: float = 0.0) -> void #foreign imgui "_ZN5ImGui17RenderFrameBorderE6ImVec2S0_f";
RenderColorRectWithAlphaCheckerboard :: (draw_list: *ImDrawList, p_min: ImVec2, p_max: ImVec2, fill_col: ImU32, grid_step: float, grid_off: ImVec2, rounding: float = 0.0, flags: ImDrawFlags = .None) -> void #foreign imgui "_ZN5ImGui36RenderColorRectWithAlphaCheckerboardEP10ImDrawList6ImVec2S2_jfS2_fi";
RenderNavHighlight :: (bb: *ImRect, id: ID, flags: NavHighlightFlags = .None) -> void #foreign imgui "_ZN5ImGui18RenderNavHighlightERK6ImRectji";
RenderNavHighlight :: (bb: ImRect, id: ID, flags: NavHighlightFlags = .None) #no_context {
    RenderNavHighlight(*bb, id, flags);
}
FindRenderedTextEnd :: (text: *u8, text_end: *u8 = null) -> *u8 #foreign imgui "_ZN5ImGui19FindRenderedTextEndEPKcS1_";
FindRenderedTextEnd :: (text: string) -> *u8 #no_context {
    return FindRenderedTextEnd(text.data, text.data + text.count);
}
RenderMouseCursor :: (pos: ImVec2, scale: float, mouse_cursor: MouseCursor, col_fill: ImU32, col_border: ImU32, col_shadow: ImU32) -> void #foreign imgui "_ZN5ImGui17RenderMouseCursorE6ImVec2fijjj";

// Render helpers (those functions don't access any ImGui state!)
RenderArrow :: (draw_list: *ImDrawList, pos: ImVec2, col: ImU32, dir: Dir, scale: float = 1.0) -> void #foreign imgui "_ZN5ImGui11RenderArrowEP10ImDrawList6ImVec2jif";
RenderBullet :: (draw_list: *ImDrawList, pos: ImVec2, col: ImU32) -> void #foreign imgui "_ZN5ImGui12RenderBulletEP10ImDrawList6ImVec2j";
RenderCheckMark :: (draw_list: *ImDrawList, pos: ImVec2, col: ImU32, sz: float) -> void #foreign imgui "_ZN5ImGui15RenderCheckMarkEP10ImDrawList6ImVec2jf";
RenderArrowPointingAt :: (draw_list: *ImDrawList, pos: ImVec2, half_sz: ImVec2, direction: Dir, col: ImU32) -> void #foreign imgui "_ZN5ImGui21RenderArrowPointingAtEP10ImDrawList6ImVec2S2_ij";
RenderArrowDockMenu :: (draw_list: *ImDrawList, p_min: ImVec2, sz: float, col: ImU32) -> void #foreign imgui "_ZN5ImGui19RenderArrowDockMenuEP10ImDrawList6ImVec2fj";
RenderRectFilledRangeH :: (draw_list: *ImDrawList, rect: *ImRect, col: ImU32, x_start_norm: float, x_end_norm: float, rounding: float) -> void #foreign imgui "_ZN5ImGui22RenderRectFilledRangeHEP10ImDrawListRK6ImRectjfff";
RenderRectFilledRangeH :: (draw_list: *ImDrawList, rect: ImRect, col: ImU32, x_start_norm: float, x_end_norm: float, rounding: float) #no_context {
    RenderRectFilledRangeH(draw_list, *rect, col, x_start_norm, x_end_norm, rounding);
}
RenderRectFilledWithHole :: (draw_list: *ImDrawList, outer: *ImRect, inner: *ImRect, col: ImU32, rounding: float) -> void #foreign imgui "_ZN5ImGui24RenderRectFilledWithHoleEP10ImDrawListRK6ImRectS4_jf";
RenderRectFilledWithHole :: (draw_list: *ImDrawList, outer: ImRect, inner: ImRect, col: ImU32, rounding: float) #no_context {
    RenderRectFilledWithHole(draw_list, *outer, *inner, col, rounding);
}
CalcRoundingFlagsForRectInRect :: (r_in: *ImRect, r_outer: *ImRect, threshold: float) -> ImDrawFlags #foreign imgui "_ZN5ImGui30CalcRoundingFlagsForRectInRectERK6ImRectS2_f";
CalcRoundingFlagsForRectInRect :: (r_in: ImRect, r_outer: ImRect, threshold: float) -> ImDrawFlags #no_context {
    return CalcRoundingFlagsForRectInRect(*r_in, *r_outer, threshold);
}

// Widgets
TextEx :: (text: *u8, text_end: *u8 = null, flags: TextFlags = .None) -> void #foreign imgui "_ZN5ImGui6TextExEPKcS1_i";
TextEx :: (text: string, flags: TextFlags = .None) #no_context {
    TextEx(text.data, text.data + text.count, flags);
}
ButtonEx :: (label: *u8, size_arg: *ImVec2, flags: ButtonFlags = .None) -> bool #foreign imgui "_ZN5ImGui8ButtonExEPKcRK6ImVec2i";
ButtonEx :: (label: *u8, size_arg: ImVec2 = ImVec2.{0, 0}, flags: ButtonFlags = .None) -> bool #no_context {
    return ButtonEx(label, *size_arg, flags);
}
ArrowButtonEx :: (str_id: *u8, dir: Dir, size_arg: ImVec2, flags: ButtonFlags = .None) -> bool #foreign imgui "_ZN5ImGui13ArrowButtonExEPKci6ImVec2i";
ImageButtonEx :: (id: ID, texture_id: ImTextureID, image_size: *ImVec2, uv0: *ImVec2, uv1: *ImVec2, bg_col: *ImVec4, tint_col: *ImVec4, flags: ButtonFlags = .None) -> bool #foreign imgui "_ZN5ImGui13ImageButtonExEjPvRK6ImVec2S3_S3_RK6ImVec4S6_i";
ImageButtonEx :: (id: ID, texture_id: ImTextureID, image_size: ImVec2, uv0: ImVec2, uv1: ImVec2, bg_col: ImVec4, tint_col: ImVec4, flags: ButtonFlags = .None) -> bool #no_context {
    return ImageButtonEx(id, texture_id, *image_size, *uv0, *uv1, *bg_col, *tint_col, flags);
}
SeparatorEx :: (flags: SeparatorFlags, thickness: float = 1.0) -> void #foreign imgui "_ZN5ImGui11SeparatorExEif";
SeparatorTextEx :: (id: ID, label: *u8, label_end: *u8, extra_width: float) -> void #foreign imgui "_ZN5ImGui15SeparatorTextExEjPKcS1_f";
SeparatorTextEx :: (id: ID, label: string, extra_width: float) #no_context {
    SeparatorTextEx(id, label.data, label.data + label.count, extra_width);
}
CheckboxFlags :: (label: *u8, flags: *ImS64, flags_value: ImS64) -> bool #foreign imgui "_ZN5ImGui13CheckboxFlagsEPKcPxx";
CheckboxFlags :: (label: *u8, flags: *ImU64, flags_value: ImU64) -> bool #foreign imgui "_ZN5ImGui13CheckboxFlagsEPKcPyy";

// Widgets: Window Decorations
CloseButton :: (id: ID, pos: *ImVec2) -> bool #foreign imgui "_ZN5ImGui11CloseButtonEjRK6ImVec2";
CloseButton :: (id: ID, pos: ImVec2) -> bool #no_context {
    return CloseButton(id, *pos);
}
CollapseButton :: (id: ID, pos: *ImVec2, dock_node: *DockNode) -> bool #foreign imgui "_ZN5ImGui14CollapseButtonEjRK6ImVec2P13ImGuiDockNode";
CollapseButton :: (id: ID, pos: ImVec2, dock_node: *DockNode) -> bool #no_context {
    return CollapseButton(id, *pos, dock_node);
}
Scrollbar :: (axis: Axis) -> void #foreign imgui "_ZN5ImGui9ScrollbarE9ImGuiAxis";
ScrollbarEx :: (bb: *ImRect, id: ID, axis: Axis, p_scroll_v: *ImS64, avail_v: ImS64, contents_v: ImS64, flags: ImDrawFlags) -> bool #foreign imgui "_ZN5ImGui11ScrollbarExERK6ImRectj9ImGuiAxisPxxxi";
ScrollbarEx :: (bb: ImRect, id: ID, axis: Axis, p_scroll_v: *ImS64, avail_v: ImS64, contents_v: ImS64, flags: ImDrawFlags) -> bool #no_context {
    return ScrollbarEx(*bb, id, axis, p_scroll_v, avail_v, contents_v, flags);
}
GetWindowScrollbarRect :: (window: *Window, axis: Axis) -> ImRect #foreign imgui "_ZN5ImGui22GetWindowScrollbarRectEP11ImGuiWindow9ImGuiAxis";
GetWindowScrollbarID :: (window: *Window, axis: Axis) -> ID #foreign imgui "_ZN5ImGui20GetWindowScrollbarIDEP11ImGuiWindow9ImGuiAxis";
GetWindowResizeCornerID :: (window: *Window, n: s32) -> ID #foreign imgui "_ZN5ImGui23GetWindowResizeCornerIDEP11ImGuiWindowi";
GetWindowResizeBorderID :: (window: *Window, dir: Dir) -> ID #foreign imgui "_ZN5ImGui23GetWindowResizeBorderIDEP11ImGuiWindowi";

// Widgets low-level behaviors
ButtonBehavior :: (bb: *ImRect, id: ID, out_hovered: *bool, out_held: *bool, flags: ButtonFlags = .None) -> bool #foreign imgui "_ZN5ImGui14ButtonBehaviorERK6ImRectjPbS3_i";
ButtonBehavior :: (bb: ImRect, id: ID, out_hovered: *bool, out_held: *bool, flags: ButtonFlags = .None) -> bool #no_context {
    return ButtonBehavior(*bb, id, out_hovered, out_held, flags);
}
DragBehavior :: (id: ID, data_type: DataType, p_v: *void, v_speed: float, p_min: *void, p_max: *void, format: *u8, flags: SliderFlags) -> bool #foreign imgui "_ZN5ImGui12DragBehaviorEjiPvfPKvS2_PKci";
SliderBehavior :: (bb: *ImRect, id: ID, data_type: DataType, p_v: *void, p_min: *void, p_max: *void, format: *u8, flags: SliderFlags, out_grab_bb: *ImRect) -> bool #foreign imgui "_ZN5ImGui14SliderBehaviorERK6ImRectjiPvPKvS5_PKciPS0_";
SliderBehavior :: (bb: ImRect, id: ID, data_type: DataType, p_v: *void, p_min: *void, p_max: *void, format: *u8, flags: SliderFlags, out_grab_bb: *ImRect) -> bool #no_context {
    return SliderBehavior(*bb, id, data_type, p_v, p_min, p_max, format, flags, out_grab_bb);
}
SplitterBehavior :: (bb: *ImRect, id: ID, axis: Axis, size1: *float, size2: *float, min_size1: float, min_size2: float, hover_extend: float = 0.0, hover_visibility_delay: float = 0.0, bg_col: ImU32 = 0) -> bool #foreign imgui "_ZN5ImGui16SplitterBehaviorERK6ImRectj9ImGuiAxisPfS4_ffffj";
SplitterBehavior :: (bb: ImRect, id: ID, axis: Axis, size1: *float, size2: *float, min_size1: float, min_size2: float, hover_extend: float = 0.0, hover_visibility_delay: float = 0.0, bg_col: ImU32 = 0) -> bool #no_context {
    return SplitterBehavior(*bb, id, axis, size1, size2, min_size1, min_size2, hover_extend, hover_visibility_delay, bg_col);
}
TreeNodeBehavior :: (id: ID, flags: TreeNodeFlags, label: *u8, label_end: *u8 = null) -> bool #foreign imgui "_ZN5ImGui16TreeNodeBehaviorEjiPKcS1_";
TreeNodeBehavior :: (id: ID, flags: TreeNodeFlags, label: string) -> bool #no_context {
    return TreeNodeBehavior(id, flags, label.data, label.data + label.count);
}
TreePushOverrideID :: (id: ID) -> void #foreign imgui "_ZN5ImGui18TreePushOverrideIDEj";
TreeNodeSetOpen :: (id: ID, open: bool) -> void #foreign imgui "_ZN5ImGui15TreeNodeSetOpenEjb";
TreeNodeUpdateNextOpen :: (id: ID, flags: TreeNodeFlags) -> bool #foreign imgui "_ZN5ImGui22TreeNodeUpdateNextOpenEji";
SetNextItemSelectionUserData :: (selection_user_data: SelectionUserData) -> void #foreign imgui "_ZN5ImGui28SetNextItemSelectionUserDataEx";

// Data type helpers
DataTypeGetInfo :: (data_type: DataType) -> *DataTypeInfo #foreign imgui "_ZN5ImGui15DataTypeGetInfoEi";
DataTypeFormatString :: (buf: *u8, buf_size: s32, data_type: DataType, p_data: *void, format: *u8) -> s32 #foreign imgui "_ZN5ImGui20DataTypeFormatStringEPciiPKvPKc";
DataTypeApplyOp :: (data_type: DataType, op: s32, output: *void, arg_1: *void, arg_2: *void) -> void #foreign imgui "_ZN5ImGui15DataTypeApplyOpEiiPvPKvS2_";
DataTypeApplyFromText :: (buf: *u8, data_type: DataType, p_data: *void, format: *u8) -> bool #foreign imgui "_ZN5ImGui21DataTypeApplyFromTextEPKciPvS1_";
DataTypeCompare :: (data_type: DataType, arg_1: *void, arg_2: *void) -> s32 #foreign imgui "_ZN5ImGui15DataTypeCompareEiPKvS1_";
DataTypeClamp :: (data_type: DataType, p_data: *void, p_min: *void, p_max: *void) -> bool #foreign imgui "_ZN5ImGui13DataTypeClampEiPvPKvS2_";

// InputText
InputTextEx :: (label: *u8, hint: *u8, buf: *u8, buf_size: s32, size_arg: *ImVec2, flags: InputTextFlags, callback: InputTextCallback = null, user_data: *void = null) -> bool #foreign imgui "_ZN5ImGui11InputTextExEPKcS1_PciRK6ImVec2iPFiP26ImGuiInputTextCallbackDataEPv";
InputTextEx :: (label: *u8, hint: *u8, buf: *u8, buf_size: s32, size_arg: ImVec2, flags: InputTextFlags, callback: InputTextCallback = null, user_data: *void = null) -> bool #no_context {
    return InputTextEx(label, hint, buf, buf_size, *size_arg, flags, callback, user_data);
}
InputTextDeactivateHook :: (id: ID) -> void #foreign imgui "_ZN5ImGui23InputTextDeactivateHookEj";
TempInputText :: (bb: *ImRect, id: ID, label: *u8, buf: *u8, buf_size: s32, flags: InputTextFlags) -> bool #foreign imgui "_ZN5ImGui13TempInputTextERK6ImRectjPKcPcii";
TempInputText :: (bb: ImRect, id: ID, label: *u8, buf: *u8, buf_size: s32, flags: InputTextFlags) -> bool #no_context {
    return TempInputText(*bb, id, label, buf, buf_size, flags);
}
TempInputScalar :: (bb: *ImRect, id: ID, label: *u8, data_type: DataType, p_data: *void, format: *u8, p_clamp_min: *void = null, p_clamp_max: *void = null) -> bool #foreign imgui "_ZN5ImGui15TempInputScalarERK6ImRectjPKciPvS4_PKvS7_";
TempInputScalar :: (bb: ImRect, id: ID, label: *u8, data_type: DataType, p_data: *void, format: *u8, p_clamp_min: *void = null, p_clamp_max: *void = null) -> bool #no_context {
    return TempInputScalar(*bb, id, label, data_type, p_data, format, p_clamp_min, p_clamp_max);
}

// Color
ColorTooltip :: (text: *u8, col: *float, flags: ColorEditFlags) -> void #foreign imgui "_ZN5ImGui12ColorTooltipEPKcPKfi";
ColorEditOptionsPopup :: (col: *float, flags: ColorEditFlags) -> void #foreign imgui "_ZN5ImGui21ColorEditOptionsPopupEPKfi";
ColorPickerOptionsPopup :: (ref_col: *float, flags: ColorEditFlags) -> void #foreign imgui "_ZN5ImGui23ColorPickerOptionsPopupEPKfi";

// Plot
PlotEx :: (plot_type: PlotType, label: *u8, values_getter: #type (data: *void, idx: s32) -> float #c_call, data: *void, values_count: s32, values_offset: s32, overlay_text: *u8, scale_min: float, scale_max: float, size_arg: *ImVec2) -> s32 #foreign imgui "_ZN5ImGui6PlotExE13ImGuiPlotTypePKcPFfPviES3_iiS2_ffRK6ImVec2";
PlotEx :: (plot_type: PlotType, label: *u8, values_getter: #type (data: *void, idx: s32) -> float #c_call, data: *void, values_count: s32, values_offset: s32, overlay_text: *u8, scale_min: float, scale_max: float, size_arg: ImVec2) -> s32 #no_context {
    return PlotEx(plot_type, label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, *size_arg);
}

// Shade functions (write over already created vertices)
ShadeVertsLinearColorGradientKeepAlpha :: (draw_list: *ImDrawList, vert_start_idx: s32, vert_end_idx: s32, gradient_p0: ImVec2, gradient_p1: ImVec2, col0: ImU32, col1: ImU32) -> void #foreign imgui "_ZN5ImGui38ShadeVertsLinearColorGradientKeepAlphaEP10ImDrawListii6ImVec2S2_jj";
ShadeVertsLinearUV :: (draw_list: *ImDrawList, vert_start_idx: s32, vert_end_idx: s32, a: *ImVec2, b: *ImVec2, uv_a: *ImVec2, uv_b: *ImVec2, clamp: bool) -> void #foreign imgui "_ZN5ImGui18ShadeVertsLinearUVEP10ImDrawListiiRK6ImVec2S4_S4_S4_b";
ShadeVertsLinearUV :: (draw_list: *ImDrawList, vert_start_idx: s32, vert_end_idx: s32, a: ImVec2, b: ImVec2, uv_a: ImVec2, uv_b: ImVec2, clamp: bool) #no_context {
    ShadeVertsLinearUV(draw_list, vert_start_idx, vert_end_idx, *a, *b, *uv_a, *uv_b, clamp);
}
ShadeVertsTransformPos :: (draw_list: *ImDrawList, vert_start_idx: s32, vert_end_idx: s32, pivot_in: *ImVec2, cos_a: float, sin_a: float, pivot_out: *ImVec2) -> void #foreign imgui "_ZN5ImGui22ShadeVertsTransformPosEP10ImDrawListiiRK6ImVec2ffS4_";
ShadeVertsTransformPos :: (draw_list: *ImDrawList, vert_start_idx: s32, vert_end_idx: s32, pivot_in: ImVec2, cos_a: float, sin_a: float, pivot_out: ImVec2) #no_context {
    ShadeVertsTransformPos(draw_list, vert_start_idx, vert_end_idx, *pivot_in, cos_a, sin_a, *pivot_out);
}

// Garbage collection
GcCompactTransientMiscBuffers :: () -> void #foreign imgui "_ZN5ImGui29GcCompactTransientMiscBuffersEv";
GcCompactTransientWindowBuffers :: (window: *Window) -> void #foreign imgui "_ZN5ImGui31GcCompactTransientWindowBuffersEP11ImGuiWindow";
GcAwakeTransientWindowBuffers :: (window: *Window) -> void #foreign imgui "_ZN5ImGui29GcAwakeTransientWindowBuffersEP11ImGuiWindow";

// Debug Log
DebugLog_CFormat :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "_ZN5ImGui8DebugLogEPKcz";
DebugLog :: (fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    DebugLog_CFormat("%s", formatted_text.data);
} @PrintLike

DebugAllocHook :: (info: *DebugAllocInfo, frame_count: s32, ptr: *void, size: u64) -> void #foreign imgui "_ZN5ImGui14DebugAllocHookEP19ImGuiDebugAllocInfoiPvm";

// Debug Tools
ErrorCheckEndFrameRecover :: (log_callback: ErrorLogCallback, user_data: *void = null) -> void #foreign imgui "_ZN5ImGui25ErrorCheckEndFrameRecoverEPFvPvPKczES0_";
ErrorCheckEndWindowRecover :: (log_callback: ErrorLogCallback, user_data: *void = null) -> void #foreign imgui "_ZN5ImGui26ErrorCheckEndWindowRecoverEPFvPvPKczES0_";
ErrorCheckUsingSetCursorPosToExtendParentBoundaries :: () -> void #foreign imgui "_ZN5ImGui51ErrorCheckUsingSetCursorPosToExtendParentBoundariesEv";
DebugDrawCursorPos :: (col: ImU32 = 4278190335) -> void #foreign imgui "_ZN5ImGui18DebugDrawCursorPosEj";
DebugDrawLineExtents :: (col: ImU32 = 4278190335) -> void #foreign imgui "_ZN5ImGui20DebugDrawLineExtentsEj";
DebugDrawItemRect :: (col: ImU32 = 4278190335) -> void #foreign imgui "_ZN5ImGui17DebugDrawItemRectEj";
DebugLocateItem :: (target_id: ID) -> void #foreign imgui "_ZN5ImGui15DebugLocateItemEj";
DebugLocateItemOnHover :: (target_id: ID) -> void #foreign imgui "_ZN5ImGui22DebugLocateItemOnHoverEj";
DebugLocateItemResolveWithLastItem :: () -> void #foreign imgui "_ZN5ImGui34DebugLocateItemResolveWithLastItemEv";
DebugBreakClearData :: () -> void #foreign imgui "_ZN5ImGui19DebugBreakClearDataEv";
DebugBreakButton :: (label: *u8, description_of_location: *u8) -> bool #foreign imgui "_ZN5ImGui16DebugBreakButtonEPKcS1_";
DebugBreakButtonTooltip :: (keyboard_only: bool, description_of_location: *u8) -> void #foreign imgui "_ZN5ImGui23DebugBreakButtonTooltipEbPKc";
ShowFontAtlas :: (atlas: *ImFontAtlas) -> void #foreign imgui "_ZN5ImGui13ShowFontAtlasEP11ImFontAtlas";
DebugHookIdInfo :: (id: ID, data_type: DataType, data_id: *void, data_id_end: *void) -> void #foreign imgui "_ZN5ImGui15DebugHookIdInfoEjiPKvS1_";
DebugNodeColumns :: (columns: *OldColumns) -> void #foreign imgui "_ZN5ImGui16DebugNodeColumnsEP15ImGuiOldColumns";
DebugNodeDockNode :: (node: *DockNode, label: *u8) -> void #foreign imgui "_ZN5ImGui17DebugNodeDockNodeEP13ImGuiDockNodePKc";
DebugNodeDrawList :: (window: *Window, viewport: *ViewportP, draw_list: *ImDrawList, label: *u8) -> void #foreign imgui "_ZN5ImGui17DebugNodeDrawListEP11ImGuiWindowP14ImGuiViewportPPK10ImDrawListPKc";
DebugNodeDrawCmdShowMeshAndBoundingBox :: (out_draw_list: *ImDrawList, draw_list: *ImDrawList, draw_cmd: *ImDrawCmd, show_mesh: bool, show_aabb: bool) -> void #foreign imgui "_ZN5ImGui38DebugNodeDrawCmdShowMeshAndBoundingBoxEP10ImDrawListPKS0_PK9ImDrawCmdbb";
DebugNodeFont :: (font: *ImFont) -> void #foreign imgui "_ZN5ImGui13DebugNodeFontEP6ImFont";
DebugNodeFontGlyph :: (font: *ImFont, glyph: *ImFontGlyph) -> void #foreign imgui "_ZN5ImGui18DebugNodeFontGlyphEP6ImFontPK11ImFontGlyph";
DebugNodeStorage :: (storage: *Storage, label: *u8) -> void #foreign imgui "_ZN5ImGui16DebugNodeStorageEP12ImGuiStoragePKc";
DebugNodeTabBar :: (tab_bar: *TabBar, label: *u8) -> void #foreign imgui "_ZN5ImGui15DebugNodeTabBarEP11ImGuiTabBarPKc";
DebugNodeTable :: (table: *Table) -> void #foreign imgui "_ZN5ImGui14DebugNodeTableEP10ImGuiTable";
DebugNodeTableSettings :: (settings: *TableSettings) -> void #foreign imgui "_ZN5ImGui22DebugNodeTableSettingsEP18ImGuiTableSettings";
DebugNodeInputTextState :: (state: *InputTextState) -> void #foreign imgui "_ZN5ImGui23DebugNodeInputTextStateEP19ImGuiInputTextState";
DebugNodeTypingSelectState :: (state: *TypingSelectState) -> void #foreign imgui "_ZN5ImGui26DebugNodeTypingSelectStateEP22ImGuiTypingSelectState";
DebugNodeWindow :: (window: *Window, label: *u8) -> void #foreign imgui "_ZN5ImGui15DebugNodeWindowEP11ImGuiWindowPKc";
DebugNodeWindowSettings :: (settings: *WindowSettings) -> void #foreign imgui "_ZN5ImGui23DebugNodeWindowSettingsEP19ImGuiWindowSettings";
DebugNodeWindowsList :: (windows: *ImVector(*Window), label: *u8) -> void #foreign imgui "_ZN5ImGui20DebugNodeWindowsListEP8ImVectorIP11ImGuiWindowEPKc";
DebugNodeWindowsListByBeginStackParent :: (windows: **Window, windows_size: s32, parent_in_begin_stack: *Window) -> void #foreign imgui "_ZN5ImGui38DebugNodeWindowsListByBeginStackParentEPP11ImGuiWindowiS1_";
DebugNodeViewport :: (viewport: *ViewportP) -> void #foreign imgui "_ZN5ImGui17DebugNodeViewportEP14ImGuiViewportP";
DebugRenderKeyboardPreview :: (draw_list: *ImDrawList) -> void #foreign imgui "_ZN5ImGui26DebugRenderKeyboardPreviewEP10ImDrawList";
DebugRenderViewportThumbnail :: (draw_list: *ImDrawList, viewport: *ViewportP, bb: *ImRect) -> void #foreign imgui "_ZN5ImGui28DebugRenderViewportThumbnailEP10ImDrawListP14ImGuiViewportPRK6ImRect";
DebugRenderViewportThumbnail :: (draw_list: *ImDrawList, viewport: *ViewportP, bb: ImRect) #no_context {
    DebugRenderViewportThumbnail(draw_list, viewport, *bb);
}

// Flags for ImGui::Begin()
// (Those are per-window flags. There are shared flags in ImGuiIO: io.ConfigWindowsResizeFromEdges and io.ConfigWindowsMoveFromTitleBarOnly)
WindowFlags :: enum_flags u32 {
    None                      :: 0x0;
    NoTitleBar                :: 0x1;
    NoResize                  :: 0x2;
    NoMove                    :: 0x4;
    NoScrollbar               :: 0x8;
    NoScrollWithMouse         :: 0x10;
    NoCollapse                :: 0x20;
    AlwaysAutoResize          :: 0x40;
    NoBackground              :: 0x80;
    NoSavedSettings           :: 0x100;
    NoMouseInputs             :: 0x200;
    MenuBar                   :: 0x400;
    HorizontalScrollbar       :: 0x800;
    NoFocusOnAppearing        :: 0x1000;
    NoBringToFrontOnFocus     :: 0x2000;
    AlwaysVerticalScrollbar   :: 0x4000;
    AlwaysHorizontalScrollbar :: 0x8000;
    NoNavInputs               :: 0x10000;
    NoNavFocus                :: 0x20000;
    UnsavedDocument           :: 0x40000;
    NoDocking                 :: 0x80000;
    NoNav                     :: 0x30000;
    NoDecoration              :: 0x2b;
    NoInputs                  :: 0x30200;

    NavFlattened              :: 0x800000;
    ChildWindow               :: 0x1000000;
    Tooltip                   :: 0x2000000;
    Popup                     :: 0x4000000;
    Modal                     :: 0x8000000;
    ChildMenu                 :: 0x10000000;
    DockNodeHost              :: 0x20000000;

    AlwaysUseWindowPadding    :: 0x40000000;

    ImGuiWindowFlags_None                      :: None;
    ImGuiWindowFlags_NoTitleBar                :: NoTitleBar;
    ImGuiWindowFlags_NoResize                  :: NoResize;
    ImGuiWindowFlags_NoMove                    :: NoMove;
    ImGuiWindowFlags_NoScrollbar               :: NoScrollbar;
    ImGuiWindowFlags_NoScrollWithMouse         :: NoScrollWithMouse;
    ImGuiWindowFlags_NoCollapse                :: NoCollapse;
    ImGuiWindowFlags_AlwaysAutoResize          :: AlwaysAutoResize;
    ImGuiWindowFlags_NoBackground              :: NoBackground;
    ImGuiWindowFlags_NoSavedSettings           :: NoSavedSettings;
    ImGuiWindowFlags_NoMouseInputs             :: NoMouseInputs;
    ImGuiWindowFlags_MenuBar                   :: MenuBar;
    ImGuiWindowFlags_HorizontalScrollbar       :: HorizontalScrollbar;
    ImGuiWindowFlags_NoFocusOnAppearing        :: NoFocusOnAppearing;
    ImGuiWindowFlags_NoBringToFrontOnFocus     :: NoBringToFrontOnFocus;
    ImGuiWindowFlags_AlwaysVerticalScrollbar   :: AlwaysVerticalScrollbar;
    ImGuiWindowFlags_AlwaysHorizontalScrollbar :: AlwaysHorizontalScrollbar;
    ImGuiWindowFlags_NoNavInputs               :: NoNavInputs;
    ImGuiWindowFlags_NoNavFocus                :: NoNavFocus;
    ImGuiWindowFlags_UnsavedDocument           :: UnsavedDocument;
    ImGuiWindowFlags_NoDocking                 :: NoDocking;
    ImGuiWindowFlags_NoNav                     :: NoNav;
    ImGuiWindowFlags_NoDecoration              :: NoDecoration;
    ImGuiWindowFlags_NoInputs                  :: NoInputs;

    ImGuiWindowFlags_NavFlattened              :: NavFlattened;
    ImGuiWindowFlags_ChildWindow               :: ChildWindow;
    ImGuiWindowFlags_Tooltip                   :: Tooltip;
    ImGuiWindowFlags_Popup                     :: Popup;
    ImGuiWindowFlags_Modal                     :: Modal;
    ImGuiWindowFlags_ChildMenu                 :: ChildMenu;
    ImGuiWindowFlags_DockNodeHost              :: DockNodeHost;

    ImGuiWindowFlags_AlwaysUseWindowPadding    :: AlwaysUseWindowPadding;
}

// Flags for ImGui::BeginChild()
// (Legacy: bit 0 must always correspond to ImGuiChildFlags_Border to be backward compatible with old API using 'bool border = false'.
// About using AutoResizeX/AutoResizeY flags:
// - May be combined with SetNextWindowSizeConstraints() to set a min/max size for each axis (see "Demo->Child->Auto-resize with Constraints").
// - Size measurement for a given axis is only performed when the child window is within visible boundaries, or is just appearing.
//   - This allows BeginChild() to return false when not within boundaries (e.g. when scrolling), which is more optimal. BUT it won't update its auto-size while clipped.
//     While not perfect, it is a better default behavior as the always-on performance gain is more valuable than the occasional "resizing after becoming visible again" glitch.
//   - You may also use ImGuiChildFlags_AlwaysAutoResize to force an update even when child window is not in view.
//     HOWEVER PLEASE UNDERSTAND THAT DOING SO WILL PREVENT BeginChild() FROM EVER RETURNING FALSE, disabling benefits of coarse clipping.
ChildFlags :: enum_flags u32 {
    None                   :: 0x0;
    Border                 :: 0x1;
    AlwaysUseWindowPadding :: 0x2;
    ResizeX                :: 0x4;
    ResizeY                :: 0x8;
    AutoResizeX            :: 0x10;
    AutoResizeY            :: 0x20;
    AlwaysAutoResize       :: 0x40;
    FrameStyle             :: 0x80;

    ImGuiChildFlags_None                   :: None;
    ImGuiChildFlags_Border                 :: Border;
    ImGuiChildFlags_AlwaysUseWindowPadding :: AlwaysUseWindowPadding;
    ImGuiChildFlags_ResizeX                :: ResizeX;
    ImGuiChildFlags_ResizeY                :: ResizeY;
    ImGuiChildFlags_AutoResizeX            :: AutoResizeX;
    ImGuiChildFlags_AutoResizeY            :: AutoResizeY;
    ImGuiChildFlags_AlwaysAutoResize       :: AlwaysAutoResize;
    ImGuiChildFlags_FrameStyle             :: FrameStyle;
}

// Flags for ImGui::InputText()
// (Those are per-item flags. There are shared flags in ImGuiIO: io.ConfigInputTextCursorBlink and io.ConfigInputTextEnterKeepActive)
InputTextFlags :: enum_flags u32 {
    None                :: 0x0;
    CharsDecimal        :: 0x1;
    CharsHexadecimal    :: 0x2;
    CharsUppercase      :: 0x4;
    CharsNoBlank        :: 0x8;
    AutoSelectAll       :: 0x10;
    EnterReturnsTrue    :: 0x20;
    CallbackCompletion  :: 0x40;
    CallbackHistory     :: 0x80;
    CallbackAlways      :: 0x100;
    CallbackCharFilter  :: 0x200;
    AllowTabInput       :: 0x400;
    CtrlEnterForNewLine :: 0x800;
    NoHorizontalScroll  :: 0x1000;
    AlwaysOverwrite     :: 0x2000;
    ReadOnly            :: 0x4000;
    Password            :: 0x8000;
    NoUndoRedo          :: 0x10000;
    CharsScientific     :: 0x20000;
    CallbackResize      :: 0x40000;
    CallbackEdit        :: 0x80000;
    EscapeClearsAll     :: 0x100000;

    ImGuiInputTextFlags_None                :: None;
    ImGuiInputTextFlags_CharsDecimal        :: CharsDecimal;
    ImGuiInputTextFlags_CharsHexadecimal    :: CharsHexadecimal;
    ImGuiInputTextFlags_CharsUppercase      :: CharsUppercase;
    ImGuiInputTextFlags_CharsNoBlank        :: CharsNoBlank;
    ImGuiInputTextFlags_AutoSelectAll       :: AutoSelectAll;
    ImGuiInputTextFlags_EnterReturnsTrue    :: EnterReturnsTrue;
    ImGuiInputTextFlags_CallbackCompletion  :: CallbackCompletion;
    ImGuiInputTextFlags_CallbackHistory     :: CallbackHistory;
    ImGuiInputTextFlags_CallbackAlways      :: CallbackAlways;
    ImGuiInputTextFlags_CallbackCharFilter  :: CallbackCharFilter;
    ImGuiInputTextFlags_AllowTabInput       :: AllowTabInput;
    ImGuiInputTextFlags_CtrlEnterForNewLine :: CtrlEnterForNewLine;
    ImGuiInputTextFlags_NoHorizontalScroll  :: NoHorizontalScroll;
    ImGuiInputTextFlags_AlwaysOverwrite     :: AlwaysOverwrite;
    ImGuiInputTextFlags_ReadOnly            :: ReadOnly;
    ImGuiInputTextFlags_Password            :: Password;
    ImGuiInputTextFlags_NoUndoRedo          :: NoUndoRedo;
    ImGuiInputTextFlags_CharsScientific     :: CharsScientific;
    ImGuiInputTextFlags_CallbackResize      :: CallbackResize;
    ImGuiInputTextFlags_CallbackEdit        :: CallbackEdit;
    ImGuiInputTextFlags_EscapeClearsAll     :: EscapeClearsAll;
}

// Flags for ImGui::TreeNodeEx(), ImGui::CollapsingHeader*()
TreeNodeFlags :: enum_flags u32 {
    None                 :: 0x0;
    Selected             :: 0x1;
    Framed               :: 0x2;
    AllowOverlap         :: 0x4;
    NoTreePushOnOpen     :: 0x8;
    NoAutoOpenOnLog      :: 0x10;
    DefaultOpen          :: 0x20;
    OpenOnDoubleClick    :: 0x40;
    OpenOnArrow          :: 0x80;
    Leaf                 :: 0x100;
    Bullet               :: 0x200;
    FramePadding         :: 0x400;
    SpanAvailWidth       :: 0x800;
    SpanFullWidth        :: 0x1000;
    SpanAllColumns       :: 0x2000;
    NavLeftJumpsBackHere :: 0x4000;

    CollapsingHeader     :: 0x1a;

    AllowItemOverlap     :: 0x4;

    ImGuiTreeNodeFlags_None                 :: None;
    ImGuiTreeNodeFlags_Selected             :: Selected;
    ImGuiTreeNodeFlags_Framed               :: Framed;
    ImGuiTreeNodeFlags_AllowOverlap         :: AllowOverlap;
    ImGuiTreeNodeFlags_NoTreePushOnOpen     :: NoTreePushOnOpen;
    ImGuiTreeNodeFlags_NoAutoOpenOnLog      :: NoAutoOpenOnLog;
    ImGuiTreeNodeFlags_DefaultOpen          :: DefaultOpen;
    ImGuiTreeNodeFlags_OpenOnDoubleClick    :: OpenOnDoubleClick;
    ImGuiTreeNodeFlags_OpenOnArrow          :: OpenOnArrow;
    ImGuiTreeNodeFlags_Leaf                 :: Leaf;
    ImGuiTreeNodeFlags_Bullet               :: Bullet;
    ImGuiTreeNodeFlags_FramePadding         :: FramePadding;
    ImGuiTreeNodeFlags_SpanAvailWidth       :: SpanAvailWidth;
    ImGuiTreeNodeFlags_SpanFullWidth        :: SpanFullWidth;
    ImGuiTreeNodeFlags_SpanAllColumns       :: SpanAllColumns;
    ImGuiTreeNodeFlags_NavLeftJumpsBackHere :: NavLeftJumpsBackHere;

    ImGuiTreeNodeFlags_CollapsingHeader     :: CollapsingHeader;

    ImGuiTreeNodeFlags_AllowItemOverlap     :: AllowItemOverlap;
}

// Flags for OpenPopup*(), BeginPopupContext*(), IsPopupOpen() functions.
// - To be backward compatible with older API which took an 'int mouse_button = 1' argument instead of 'ImGuiPopupFlags flags',
//   we need to treat small flags values as a mouse button index, so we encode the mouse button in the first few bits of the flags.
//   It is therefore guaranteed to be legal to pass a mouse button index in ImGuiPopupFlags.
// - For the same reason, we exceptionally default the ImGuiPopupFlags argument of BeginPopupContextXXX functions to 1 instead of 0.
//   IMPORTANT: because the default parameter is 1 (==ImGuiPopupFlags_MouseButtonRight), if you rely on the default parameter
//   and want to use another flag, you need to pass in the ImGuiPopupFlags_MouseButtonRight flag explicitly.
// - Multiple buttons currently cannot be combined/or-ed in those functions (we could allow it later).
PopupFlags :: enum_flags u32 {
    None                    :: 0x0;
    MouseButtonLeft         :: 0x0;
    MouseButtonRight        :: 0x1;
    MouseButtonMiddle       :: 0x2;
    MouseButtonMask_        :: 0x1f;
    MouseButtonDefault_     :: 0x1;
    NoReopen                :: 0x20;

    NoOpenOverExistingPopup :: 0x80;
    NoOpenOverItems         :: 0x100;
    AnyPopupId              :: 0x400;
    AnyPopupLevel           :: 0x800;
    AnyPopup                :: 0xc00;

    ImGuiPopupFlags_None                    :: None;
    ImGuiPopupFlags_MouseButtonLeft         :: MouseButtonLeft;
    ImGuiPopupFlags_MouseButtonRight        :: MouseButtonRight;
    ImGuiPopupFlags_MouseButtonMiddle       :: MouseButtonMiddle;
    ImGuiPopupFlags_MouseButtonMask_        :: MouseButtonMask_;
    ImGuiPopupFlags_MouseButtonDefault_     :: MouseButtonDefault_;
    ImGuiPopupFlags_NoReopen                :: NoReopen;

    ImGuiPopupFlags_NoOpenOverExistingPopup :: NoOpenOverExistingPopup;
    ImGuiPopupFlags_NoOpenOverItems         :: NoOpenOverItems;
    ImGuiPopupFlags_AnyPopupId              :: AnyPopupId;
    ImGuiPopupFlags_AnyPopupLevel           :: AnyPopupLevel;
    ImGuiPopupFlags_AnyPopup                :: AnyPopup;
}

// Flags for ImGui::Selectable()
SelectableFlags :: enum_flags u32 {
    None             :: 0x0;
    DontClosePopups  :: 0x1;
    SpanAllColumns   :: 0x2;
    AllowDoubleClick :: 0x4;
    Disabled         :: 0x8;
    AllowOverlap     :: 0x10;

    AllowItemOverlap :: 0x10;

    ImGuiSelectableFlags_None             :: None;
    ImGuiSelectableFlags_DontClosePopups  :: DontClosePopups;
    ImGuiSelectableFlags_SpanAllColumns   :: SpanAllColumns;
    ImGuiSelectableFlags_AllowDoubleClick :: AllowDoubleClick;
    ImGuiSelectableFlags_Disabled         :: Disabled;
    ImGuiSelectableFlags_AllowOverlap     :: AllowOverlap;

    ImGuiSelectableFlags_AllowItemOverlap :: AllowItemOverlap;
}

// Flags for ImGui::BeginCombo()
ComboFlags :: enum_flags u32 {
    None            :: 0x0;
    PopupAlignLeft  :: 0x1;
    HeightSmall     :: 0x2;
    HeightRegular   :: 0x4;
    HeightLarge     :: 0x8;
    HeightLargest   :: 0x10;
    NoArrowButton   :: 0x20;
    NoPreview       :: 0x40;
    WidthFitPreview :: 0x80;
    HeightMask_     :: 0x1e;

    ImGuiComboFlags_None            :: None;
    ImGuiComboFlags_PopupAlignLeft  :: PopupAlignLeft;
    ImGuiComboFlags_HeightSmall     :: HeightSmall;
    ImGuiComboFlags_HeightRegular   :: HeightRegular;
    ImGuiComboFlags_HeightLarge     :: HeightLarge;
    ImGuiComboFlags_HeightLargest   :: HeightLargest;
    ImGuiComboFlags_NoArrowButton   :: NoArrowButton;
    ImGuiComboFlags_NoPreview       :: NoPreview;
    ImGuiComboFlags_WidthFitPreview :: WidthFitPreview;
    ImGuiComboFlags_HeightMask_     :: HeightMask_;
}

// Flags for ImGui::BeginTabBar()
TabBarFlags :: enum_flags u32 {
    None                         :: 0x0;
    Reorderable                  :: 0x1;
    AutoSelectNewTabs            :: 0x2;
    TabListPopupButton           :: 0x4;
    NoCloseWithMiddleMouseButton :: 0x8;
    NoTabListScrollingButtons    :: 0x10;
    NoTooltip                    :: 0x20;
    FittingPolicyResizeDown      :: 0x40;
    FittingPolicyScroll          :: 0x80;
    FittingPolicyMask_           :: 0xc0;
    FittingPolicyDefault_        :: 0x40;

    ImGuiTabBarFlags_None                         :: None;
    ImGuiTabBarFlags_Reorderable                  :: Reorderable;
    ImGuiTabBarFlags_AutoSelectNewTabs            :: AutoSelectNewTabs;
    ImGuiTabBarFlags_TabListPopupButton           :: TabListPopupButton;
    ImGuiTabBarFlags_NoCloseWithMiddleMouseButton :: NoCloseWithMiddleMouseButton;
    ImGuiTabBarFlags_NoTabListScrollingButtons    :: NoTabListScrollingButtons;
    ImGuiTabBarFlags_NoTooltip                    :: NoTooltip;
    ImGuiTabBarFlags_FittingPolicyResizeDown      :: FittingPolicyResizeDown;
    ImGuiTabBarFlags_FittingPolicyScroll          :: FittingPolicyScroll;
    ImGuiTabBarFlags_FittingPolicyMask_           :: FittingPolicyMask_;
    ImGuiTabBarFlags_FittingPolicyDefault_        :: FittingPolicyDefault_;
}

// Flags for ImGui::BeginTabItem()
TabItemFlags :: enum_flags u32 {
    None                         :: 0x0;
    UnsavedDocument              :: 0x1;
    SetSelected                  :: 0x2;
    NoCloseWithMiddleMouseButton :: 0x4;
    NoPushId                     :: 0x8;
    NoTooltip                    :: 0x10;
    NoReorder                    :: 0x20;
    Leading                      :: 0x40;
    Trailing                     :: 0x80;
    NoAssumedClosure             :: 0x100;

    ImGuiTabItemFlags_None                         :: None;
    ImGuiTabItemFlags_UnsavedDocument              :: UnsavedDocument;
    ImGuiTabItemFlags_SetSelected                  :: SetSelected;
    ImGuiTabItemFlags_NoCloseWithMiddleMouseButton :: NoCloseWithMiddleMouseButton;
    ImGuiTabItemFlags_NoPushId                     :: NoPushId;
    ImGuiTabItemFlags_NoTooltip                    :: NoTooltip;
    ImGuiTabItemFlags_NoReorder                    :: NoReorder;
    ImGuiTabItemFlags_Leading                      :: Leading;
    ImGuiTabItemFlags_Trailing                     :: Trailing;
    ImGuiTabItemFlags_NoAssumedClosure             :: NoAssumedClosure;
}

// Flags for ImGui::IsWindowFocused()
FocusedFlags :: enum_flags u32 {
    None                :: 0x0;
    ChildWindows        :: 0x1;
    RootWindow          :: 0x2;
    AnyWindow           :: 0x4;
    NoPopupHierarchy    :: 0x8;
    DockHierarchy       :: 0x10;
    RootAndChildWindows :: 0x3;

    ImGuiFocusedFlags_None                :: None;
    ImGuiFocusedFlags_ChildWindows        :: ChildWindows;
    ImGuiFocusedFlags_RootWindow          :: RootWindow;
    ImGuiFocusedFlags_AnyWindow           :: AnyWindow;
    ImGuiFocusedFlags_NoPopupHierarchy    :: NoPopupHierarchy;
    ImGuiFocusedFlags_DockHierarchy       :: DockHierarchy;
    ImGuiFocusedFlags_RootAndChildWindows :: RootAndChildWindows;
}

// Flags for ImGui::IsItemHovered(), ImGui::IsWindowHovered()
// Note: if you are trying to check whether your mouse should be dispatched to Dear ImGui or to your app, you should use 'io.WantCaptureMouse' instead! Please read the FAQ!
// Note: windows with the ImGuiWindowFlags_NoInputs flag are ignored by IsWindowHovered() calls.
HoveredFlags :: enum_flags u32 {
    None                         :: 0x0;
    ChildWindows                 :: 0x1;
    RootWindow                   :: 0x2;
    AnyWindow                    :: 0x4;
    NoPopupHierarchy             :: 0x8;
    DockHierarchy                :: 0x10;
    AllowWhenBlockedByPopup      :: 0x20;

    AllowWhenBlockedByActiveItem :: 0x80;
    AllowWhenOverlappedByItem    :: 0x100;
    AllowWhenOverlappedByWindow  :: 0x200;
    AllowWhenDisabled            :: 0x400;
    NoNavOverride                :: 0x800;
    AllowWhenOverlapped          :: 0x300;
    RectOnly                     :: 0x3a0;
    RootAndChildWindows          :: 0x3;

    ForTooltip                   :: 0x1000;

    Stationary                   :: 0x2000;
    DelayNone                    :: 0x4000;
    DelayShort                   :: 0x8000;
    DelayNormal                  :: 0x10000;
    NoSharedDelay                :: 0x20000;

    ImGuiHoveredFlags_None                         :: None;
    ImGuiHoveredFlags_ChildWindows                 :: ChildWindows;
    ImGuiHoveredFlags_RootWindow                   :: RootWindow;
    ImGuiHoveredFlags_AnyWindow                    :: AnyWindow;
    ImGuiHoveredFlags_NoPopupHierarchy             :: NoPopupHierarchy;
    ImGuiHoveredFlags_DockHierarchy                :: DockHierarchy;
    ImGuiHoveredFlags_AllowWhenBlockedByPopup      :: AllowWhenBlockedByPopup;

    ImGuiHoveredFlags_AllowWhenBlockedByActiveItem :: AllowWhenBlockedByActiveItem;
    ImGuiHoveredFlags_AllowWhenOverlappedByItem    :: AllowWhenOverlappedByItem;
    ImGuiHoveredFlags_AllowWhenOverlappedByWindow  :: AllowWhenOverlappedByWindow;
    ImGuiHoveredFlags_AllowWhenDisabled            :: AllowWhenDisabled;
    ImGuiHoveredFlags_NoNavOverride                :: NoNavOverride;
    ImGuiHoveredFlags_AllowWhenOverlapped          :: AllowWhenOverlapped;
    ImGuiHoveredFlags_RectOnly                     :: RectOnly;
    ImGuiHoveredFlags_RootAndChildWindows          :: RootAndChildWindows;

    ImGuiHoveredFlags_ForTooltip                   :: ForTooltip;

    ImGuiHoveredFlags_Stationary                   :: Stationary;
    ImGuiHoveredFlags_DelayNone                    :: DelayNone;
    ImGuiHoveredFlags_DelayShort                   :: DelayShort;
    ImGuiHoveredFlags_DelayNormal                  :: DelayNormal;
    ImGuiHoveredFlags_NoSharedDelay                :: NoSharedDelay;
}

// Flags for ImGui::DockSpace(), shared/inherited by child nodes.
// (Some flags can be applied to individual nodes directly)
// FIXME-DOCK: Also see ImGuiDockNodeFlagsPrivate_ which may involve using the WIP and internal DockBuilder api.
DockNodeFlags :: enum_flags u32 {
    None                     :: 0x0;
    KeepAliveOnly            :: 0x1;

    NoDockingOverCentralNode :: 0x4;
    PassthruCentralNode      :: 0x8;
    NoDockingSplit           :: 0x10;
    NoResize                 :: 0x20;
    AutoHideTabBar           :: 0x40;
    NoUndocking              :: 0x80;

    NoSplit                  :: 0x10;
    NoDockingInCentralNode   :: 0x4;

    ImGuiDockNodeFlags_None                     :: None;
    ImGuiDockNodeFlags_KeepAliveOnly            :: KeepAliveOnly;

    ImGuiDockNodeFlags_NoDockingOverCentralNode :: NoDockingOverCentralNode;
    ImGuiDockNodeFlags_PassthruCentralNode      :: PassthruCentralNode;
    ImGuiDockNodeFlags_NoDockingSplit           :: NoDockingSplit;
    ImGuiDockNodeFlags_NoResize                 :: NoResize;
    ImGuiDockNodeFlags_AutoHideTabBar           :: AutoHideTabBar;
    ImGuiDockNodeFlags_NoUndocking              :: NoUndocking;

    ImGuiDockNodeFlags_NoSplit                  :: NoSplit;
    ImGuiDockNodeFlags_NoDockingInCentralNode   :: NoDockingInCentralNode;
}

// Flags for ImGui::BeginDragDropSource(), ImGui::AcceptDragDropPayload()
DragDropFlags :: enum_flags u32 {
    None                     :: 0x0;

    SourceNoPreviewTooltip   :: 0x1;
    SourceNoDisableHover     :: 0x2;
    SourceNoHoldToOpenOthers :: 0x4;
    SourceAllowNullID        :: 0x8;
    SourceExtern             :: 0x10;
    SourceAutoExpirePayload  :: 0x20;

    AcceptBeforeDelivery     :: 0x400;
    AcceptNoDrawDefaultRect  :: 0x800;
    AcceptNoPreviewTooltip   :: 0x1000;
    AcceptPeekOnly           :: 0xc00;

    ImGuiDragDropFlags_None                     :: None;

    ImGuiDragDropFlags_SourceNoPreviewTooltip   :: SourceNoPreviewTooltip;
    ImGuiDragDropFlags_SourceNoDisableHover     :: SourceNoDisableHover;
    ImGuiDragDropFlags_SourceNoHoldToOpenOthers :: SourceNoHoldToOpenOthers;
    ImGuiDragDropFlags_SourceAllowNullID        :: SourceAllowNullID;
    ImGuiDragDropFlags_SourceExtern             :: SourceExtern;
    ImGuiDragDropFlags_SourceAutoExpirePayload  :: SourceAutoExpirePayload;

    ImGuiDragDropFlags_AcceptBeforeDelivery     :: AcceptBeforeDelivery;
    ImGuiDragDropFlags_AcceptNoDrawDefaultRect  :: AcceptNoDrawDefaultRect;
    ImGuiDragDropFlags_AcceptNoPreviewTooltip   :: AcceptNoPreviewTooltip;
    ImGuiDragDropFlags_AcceptPeekOnly           :: AcceptPeekOnly;
}

// A primary data type
DataType :: enum u32 {
    S8     :: 0;
    U8     :: 1;
    S16    :: 2;
    U16    :: 3;
    S32    :: 4;
    U32    :: 5;
    S64    :: 6;
    U64    :: 7;
    Float  :: 8;
    Double :: 9;
    COUNT  :: 10;

    ImGuiDataType_S8     :: S8;
    ImGuiDataType_U8     :: U8;
    ImGuiDataType_S16    :: S16;
    ImGuiDataType_U16    :: U16;
    ImGuiDataType_S32    :: S32;
    ImGuiDataType_U32    :: U32;
    ImGuiDataType_S64    :: S64;
    ImGuiDataType_U64    :: U64;
    ImGuiDataType_Float  :: Float;
    ImGuiDataType_Double :: Double;
    ImGuiDataType_COUNT  :: COUNT;
}

// A cardinal direction
Dir :: enum s32 {
    None  :: -1;
    Left  :: 0;
    Right :: 1;
    Up    :: 2;
    Down  :: 3;
    COUNT :: 4;

    ImGuiDir_None  :: None;
    ImGuiDir_Left  :: Left;
    ImGuiDir_Right :: Right;
    ImGuiDir_Up    :: Up;
    ImGuiDir_Down  :: Down;
    ImGuiDir_COUNT :: COUNT;
}

// A sorting direction
SortDirection :: enum u32 {
    None       :: 0;
    Ascending  :: 1;
    Descending :: 2;

    ImGuiSortDirection_None       :: None;
    ImGuiSortDirection_Ascending  :: Ascending;
    ImGuiSortDirection_Descending :: Descending;
}

// OBSOLETED in 1.88 (from July 2022): ImGuiNavInput and io.NavInputs[].
// Official backends between 1.60 and 1.86: will keep working and feed gamepad inputs as long as IMGUI_DISABLE_OBSOLETE_KEYIO is not set.
// Custom backends: feed gamepad inputs via io.AddKeyEvent() and ImGuiKey_GamepadXXX enums.
NavInput :: enum u32 {
    Activate    :: 0;
    Cancel      :: 1;
    Input       :: 2;
    Menu        :: 3;
    DpadLeft    :: 4;
    DpadRight   :: 5;
    DpadUp      :: 6;
    DpadDown    :: 7;
    LStickLeft  :: 8;
    LStickRight :: 9;
    LStickUp    :: 10;
    LStickDown  :: 11;
    FocusPrev   :: 12;
    FocusNext   :: 13;
    TweakSlow   :: 14;
    TweakFast   :: 15;
    COUNT       :: 16;

    ImGuiNavInput_Activate    :: Activate;
    ImGuiNavInput_Cancel      :: Cancel;
    ImGuiNavInput_Input       :: Input;
    ImGuiNavInput_Menu        :: Menu;
    ImGuiNavInput_DpadLeft    :: DpadLeft;
    ImGuiNavInput_DpadRight   :: DpadRight;
    ImGuiNavInput_DpadUp      :: DpadUp;
    ImGuiNavInput_DpadDown    :: DpadDown;
    ImGuiNavInput_LStickLeft  :: LStickLeft;
    ImGuiNavInput_LStickRight :: LStickRight;
    ImGuiNavInput_LStickUp    :: LStickUp;
    ImGuiNavInput_LStickDown  :: LStickDown;
    ImGuiNavInput_FocusPrev   :: FocusPrev;
    ImGuiNavInput_FocusNext   :: FocusNext;
    ImGuiNavInput_TweakSlow   :: TweakSlow;
    ImGuiNavInput_TweakFast   :: TweakFast;
    ImGuiNavInput_COUNT       :: COUNT;
}

// Configuration flags stored in io.ConfigFlags. Set by user/application.
ConfigFlags :: enum_flags u32 {
    None                    :: 0x0;
    NavEnableKeyboard       :: 0x1;
    NavEnableGamepad        :: 0x2;
    NavEnableSetMousePos    :: 0x4;
    NavNoCaptureKeyboard    :: 0x8;
    NoMouse                 :: 0x10;
    NoMouseCursorChange     :: 0x20;

    DockingEnable           :: 0x40;

    ViewportsEnable         :: 0x400;
    DpiEnableScaleViewports :: 0x4000;
    DpiEnableScaleFonts     :: 0x8000;

    IsSRGB                  :: 0x100000;
    IsTouchScreen           :: 0x200000;

    ImGuiConfigFlags_None                    :: None;
    ImGuiConfigFlags_NavEnableKeyboard       :: NavEnableKeyboard;
    ImGuiConfigFlags_NavEnableGamepad        :: NavEnableGamepad;
    ImGuiConfigFlags_NavEnableSetMousePos    :: NavEnableSetMousePos;
    ImGuiConfigFlags_NavNoCaptureKeyboard    :: NavNoCaptureKeyboard;
    ImGuiConfigFlags_NoMouse                 :: NoMouse;
    ImGuiConfigFlags_NoMouseCursorChange     :: NoMouseCursorChange;

    ImGuiConfigFlags_DockingEnable           :: DockingEnable;

    ImGuiConfigFlags_ViewportsEnable         :: ViewportsEnable;
    ImGuiConfigFlags_DpiEnableScaleViewports :: DpiEnableScaleViewports;
    ImGuiConfigFlags_DpiEnableScaleFonts     :: DpiEnableScaleFonts;

    ImGuiConfigFlags_IsSRGB                  :: IsSRGB;
    ImGuiConfigFlags_IsTouchScreen           :: IsTouchScreen;
}

// Backend capabilities flags stored in io.BackendFlags. Set by imgui_impl_xxx or custom backend.
BackendFlags :: enum_flags u32 {
    None                    :: 0x0;
    HasGamepad              :: 0x1;
    HasMouseCursors         :: 0x2;
    HasSetMousePos          :: 0x4;
    RendererHasVtxOffset    :: 0x8;

    PlatformHasViewports    :: 0x400;
    HasMouseHoveredViewport :: 0x800;
    RendererHasViewports    :: 0x1000;

    ImGuiBackendFlags_None                    :: None;
    ImGuiBackendFlags_HasGamepad              :: HasGamepad;
    ImGuiBackendFlags_HasMouseCursors         :: HasMouseCursors;
    ImGuiBackendFlags_HasSetMousePos          :: HasSetMousePos;
    ImGuiBackendFlags_RendererHasVtxOffset    :: RendererHasVtxOffset;

    ImGuiBackendFlags_PlatformHasViewports    :: PlatformHasViewports;
    ImGuiBackendFlags_HasMouseHoveredViewport :: HasMouseHoveredViewport;
    ImGuiBackendFlags_RendererHasViewports    :: RendererHasViewports;
}

// Enumeration for PushStyleColor() / PopStyleColor()
Col :: enum u32 {
    Text                  :: 0;
    TextDisabled          :: 1;
    WindowBg              :: 2;
    ChildBg               :: 3;
    PopupBg               :: 4;
    Border                :: 5;
    BorderShadow          :: 6;
    FrameBg               :: 7;
    FrameBgHovered        :: 8;
    FrameBgActive         :: 9;
    TitleBg               :: 10;
    TitleBgActive         :: 11;
    TitleBgCollapsed      :: 12;
    MenuBarBg             :: 13;
    ScrollbarBg           :: 14;
    ScrollbarGrab         :: 15;
    ScrollbarGrabHovered  :: 16;
    ScrollbarGrabActive   :: 17;
    CheckMark             :: 18;
    SliderGrab            :: 19;
    SliderGrabActive      :: 20;
    Button                :: 21;
    ButtonHovered         :: 22;
    ButtonActive          :: 23;
    Header                :: 24;
    HeaderHovered         :: 25;
    HeaderActive          :: 26;
    Separator             :: 27;
    SeparatorHovered      :: 28;
    SeparatorActive       :: 29;
    ResizeGrip            :: 30;
    ResizeGripHovered     :: 31;
    ResizeGripActive      :: 32;
    Tab                   :: 33;
    TabHovered            :: 34;
    TabActive             :: 35;
    TabUnfocused          :: 36;
    TabUnfocusedActive    :: 37;
    DockingPreview        :: 38;
    DockingEmptyBg        :: 39;
    PlotLines             :: 40;
    PlotLinesHovered      :: 41;
    PlotHistogram         :: 42;
    PlotHistogramHovered  :: 43;
    TableHeaderBg         :: 44;
    TableBorderStrong     :: 45;
    TableBorderLight      :: 46;
    TableRowBg            :: 47;
    TableRowBgAlt         :: 48;
    TextSelectedBg        :: 49;
    DragDropTarget        :: 50;
    NavHighlight          :: 51;
    NavWindowingHighlight :: 52;
    NavWindowingDimBg     :: 53;
    ModalWindowDimBg      :: 54;
    COUNT                 :: 55;

    ImGuiCol_Text                  :: Text;
    ImGuiCol_TextDisabled          :: TextDisabled;
    ImGuiCol_WindowBg              :: WindowBg;
    ImGuiCol_ChildBg               :: ChildBg;
    ImGuiCol_PopupBg               :: PopupBg;
    ImGuiCol_Border                :: Border;
    ImGuiCol_BorderShadow          :: BorderShadow;
    ImGuiCol_FrameBg               :: FrameBg;
    ImGuiCol_FrameBgHovered        :: FrameBgHovered;
    ImGuiCol_FrameBgActive         :: FrameBgActive;
    ImGuiCol_TitleBg               :: TitleBg;
    ImGuiCol_TitleBgActive         :: TitleBgActive;
    ImGuiCol_TitleBgCollapsed      :: TitleBgCollapsed;
    ImGuiCol_MenuBarBg             :: MenuBarBg;
    ImGuiCol_ScrollbarBg           :: ScrollbarBg;
    ImGuiCol_ScrollbarGrab         :: ScrollbarGrab;
    ImGuiCol_ScrollbarGrabHovered  :: ScrollbarGrabHovered;
    ImGuiCol_ScrollbarGrabActive   :: ScrollbarGrabActive;
    ImGuiCol_CheckMark             :: CheckMark;
    ImGuiCol_SliderGrab            :: SliderGrab;
    ImGuiCol_SliderGrabActive      :: SliderGrabActive;
    ImGuiCol_Button                :: Button;
    ImGuiCol_ButtonHovered         :: ButtonHovered;
    ImGuiCol_ButtonActive          :: ButtonActive;
    ImGuiCol_Header                :: Header;
    ImGuiCol_HeaderHovered         :: HeaderHovered;
    ImGuiCol_HeaderActive          :: HeaderActive;
    ImGuiCol_Separator             :: Separator;
    ImGuiCol_SeparatorHovered      :: SeparatorHovered;
    ImGuiCol_SeparatorActive       :: SeparatorActive;
    ImGuiCol_ResizeGrip            :: ResizeGrip;
    ImGuiCol_ResizeGripHovered     :: ResizeGripHovered;
    ImGuiCol_ResizeGripActive      :: ResizeGripActive;
    ImGuiCol_Tab                   :: Tab;
    ImGuiCol_TabHovered            :: TabHovered;
    ImGuiCol_TabActive             :: TabActive;
    ImGuiCol_TabUnfocused          :: TabUnfocused;
    ImGuiCol_TabUnfocusedActive    :: TabUnfocusedActive;
    ImGuiCol_DockingPreview        :: DockingPreview;
    ImGuiCol_DockingEmptyBg        :: DockingEmptyBg;
    ImGuiCol_PlotLines             :: PlotLines;
    ImGuiCol_PlotLinesHovered      :: PlotLinesHovered;
    ImGuiCol_PlotHistogram         :: PlotHistogram;
    ImGuiCol_PlotHistogramHovered  :: PlotHistogramHovered;
    ImGuiCol_TableHeaderBg         :: TableHeaderBg;
    ImGuiCol_TableBorderStrong     :: TableBorderStrong;
    ImGuiCol_TableBorderLight      :: TableBorderLight;
    ImGuiCol_TableRowBg            :: TableRowBg;
    ImGuiCol_TableRowBgAlt         :: TableRowBgAlt;
    ImGuiCol_TextSelectedBg        :: TextSelectedBg;
    ImGuiCol_DragDropTarget        :: DragDropTarget;
    ImGuiCol_NavHighlight          :: NavHighlight;
    ImGuiCol_NavWindowingHighlight :: NavWindowingHighlight;
    ImGuiCol_NavWindowingDimBg     :: NavWindowingDimBg;
    ImGuiCol_ModalWindowDimBg      :: ModalWindowDimBg;
    ImGuiCol_COUNT                 :: COUNT;
}

// Enumeration for PushStyleVar() / PopStyleVar() to temporarily modify the ImGuiStyle structure.
// - The enum only refers to fields of ImGuiStyle which makes sense to be pushed/popped inside UI code.
//   During initialization or between frames, feel free to just poke into ImGuiStyle directly.
// - Tip: Use your programming IDE navigation facilities on the names in the _second column_ below to find the actual members and their description.
//   In Visual Studio IDE: CTRL+comma ("Edit.GoToAll") can follow symbols in comments, whereas CTRL+F12 ("Edit.GoToImplementation") cannot.
//   With Visual Assist installed: ALT+G ("VAssistX.GoToImplementation") can also follow symbols in comments.
// - When changing this enum, you need to update the associated internal table GStyleVarInfo[] accordingly. This is where we link enum values to members offset/type.
StyleVar :: enum u32 {
    Alpha                   :: 0;
    DisabledAlpha           :: 1;
    WindowPadding           :: 2;
    WindowRounding          :: 3;
    WindowBorderSize        :: 4;
    WindowMinSize           :: 5;
    WindowTitleAlign        :: 6;
    ChildRounding           :: 7;
    ChildBorderSize         :: 8;
    PopupRounding           :: 9;
    PopupBorderSize         :: 10;
    FramePadding            :: 11;
    FrameRounding           :: 12;
    FrameBorderSize         :: 13;
    ItemSpacing             :: 14;
    ItemInnerSpacing        :: 15;
    IndentSpacing           :: 16;
    CellPadding             :: 17;
    ScrollbarSize           :: 18;
    ScrollbarRounding       :: 19;
    GrabMinSize             :: 20;
    GrabRounding            :: 21;
    TabRounding             :: 22;
    TabBarBorderSize        :: 23;
    ButtonTextAlign         :: 24;
    SelectableTextAlign     :: 25;
    SeparatorTextBorderSize :: 26;
    SeparatorTextAlign      :: 27;
    SeparatorTextPadding    :: 28;
    DockingSeparatorSize    :: 29;
    COUNT                   :: 30;

    ImGuiStyleVar_Alpha                   :: Alpha;
    ImGuiStyleVar_DisabledAlpha           :: DisabledAlpha;
    ImGuiStyleVar_WindowPadding           :: WindowPadding;
    ImGuiStyleVar_WindowRounding          :: WindowRounding;
    ImGuiStyleVar_WindowBorderSize        :: WindowBorderSize;
    ImGuiStyleVar_WindowMinSize           :: WindowMinSize;
    ImGuiStyleVar_WindowTitleAlign        :: WindowTitleAlign;
    ImGuiStyleVar_ChildRounding           :: ChildRounding;
    ImGuiStyleVar_ChildBorderSize         :: ChildBorderSize;
    ImGuiStyleVar_PopupRounding           :: PopupRounding;
    ImGuiStyleVar_PopupBorderSize         :: PopupBorderSize;
    ImGuiStyleVar_FramePadding            :: FramePadding;
    ImGuiStyleVar_FrameRounding           :: FrameRounding;
    ImGuiStyleVar_FrameBorderSize         :: FrameBorderSize;
    ImGuiStyleVar_ItemSpacing             :: ItemSpacing;
    ImGuiStyleVar_ItemInnerSpacing        :: ItemInnerSpacing;
    ImGuiStyleVar_IndentSpacing           :: IndentSpacing;
    ImGuiStyleVar_CellPadding             :: CellPadding;
    ImGuiStyleVar_ScrollbarSize           :: ScrollbarSize;
    ImGuiStyleVar_ScrollbarRounding       :: ScrollbarRounding;
    ImGuiStyleVar_GrabMinSize             :: GrabMinSize;
    ImGuiStyleVar_GrabRounding            :: GrabRounding;
    ImGuiStyleVar_TabRounding             :: TabRounding;
    ImGuiStyleVar_TabBarBorderSize        :: TabBarBorderSize;
    ImGuiStyleVar_ButtonTextAlign         :: ButtonTextAlign;
    ImGuiStyleVar_SelectableTextAlign     :: SelectableTextAlign;
    ImGuiStyleVar_SeparatorTextBorderSize :: SeparatorTextBorderSize;
    ImGuiStyleVar_SeparatorTextAlign      :: SeparatorTextAlign;
    ImGuiStyleVar_SeparatorTextPadding    :: SeparatorTextPadding;
    ImGuiStyleVar_DockingSeparatorSize    :: DockingSeparatorSize;
    ImGuiStyleVar_COUNT                   :: COUNT;
}

// Flags for InvisibleButton() [extended in imgui_internal.h]
ButtonFlags :: enum_flags u32 {
    None                :: 0x0;
    MouseButtonLeft     :: 0x1;
    MouseButtonRight    :: 0x2;
    MouseButtonMiddle   :: 0x4;

    MouseButtonMask_    :: 0x7;
    MouseButtonDefault_ :: 0x1;

    ImGuiButtonFlags_None                :: None;
    ImGuiButtonFlags_MouseButtonLeft     :: MouseButtonLeft;
    ImGuiButtonFlags_MouseButtonRight    :: MouseButtonRight;
    ImGuiButtonFlags_MouseButtonMiddle   :: MouseButtonMiddle;

    ImGuiButtonFlags_MouseButtonMask_    :: MouseButtonMask_;
    ImGuiButtonFlags_MouseButtonDefault_ :: MouseButtonDefault_;
}

// Flags for ColorEdit3() / ColorEdit4() / ColorPicker3() / ColorPicker4() / ColorButton()
ColorEditFlags :: enum_flags u32 {
    None             :: 0x0;
    NoAlpha          :: 0x2;
    NoPicker         :: 0x4;
    NoOptions        :: 0x8;
    NoSmallPreview   :: 0x10;
    NoInputs         :: 0x20;
    NoTooltip        :: 0x40;
    NoLabel          :: 0x80;
    NoSidePreview    :: 0x100;
    NoDragDrop       :: 0x200;
    NoBorder         :: 0x400;

    AlphaBar         :: 0x10000;
    AlphaPreview     :: 0x20000;
    AlphaPreviewHalf :: 0x40000;
    HDR              :: 0x80000;
    DisplayRGB       :: 0x100000;
    DisplayHSV       :: 0x200000;
    DisplayHex       :: 0x400000;
    Uint8            :: 0x800000;
    Float            :: 0x1000000;
    PickerHueBar     :: 0x2000000;
    PickerHueWheel   :: 0x4000000;
    InputRGB         :: 0x8000000;
    InputHSV         :: 0x10000000;

    DefaultOptions_  :: 0xa900000;

    DisplayMask_     :: 0x700000;
    DataTypeMask_    :: 0x1800000;
    PickerMask_      :: 0x6000000;
    InputMask_       :: 0x18000000;

    ImGuiColorEditFlags_None             :: None;
    ImGuiColorEditFlags_NoAlpha          :: NoAlpha;
    ImGuiColorEditFlags_NoPicker         :: NoPicker;
    ImGuiColorEditFlags_NoOptions        :: NoOptions;
    ImGuiColorEditFlags_NoSmallPreview   :: NoSmallPreview;
    ImGuiColorEditFlags_NoInputs         :: NoInputs;
    ImGuiColorEditFlags_NoTooltip        :: NoTooltip;
    ImGuiColorEditFlags_NoLabel          :: NoLabel;
    ImGuiColorEditFlags_NoSidePreview    :: NoSidePreview;
    ImGuiColorEditFlags_NoDragDrop       :: NoDragDrop;
    ImGuiColorEditFlags_NoBorder         :: NoBorder;

    ImGuiColorEditFlags_AlphaBar         :: AlphaBar;
    ImGuiColorEditFlags_AlphaPreview     :: AlphaPreview;
    ImGuiColorEditFlags_AlphaPreviewHalf :: AlphaPreviewHalf;
    ImGuiColorEditFlags_HDR              :: HDR;
    ImGuiColorEditFlags_DisplayRGB       :: DisplayRGB;
    ImGuiColorEditFlags_DisplayHSV       :: DisplayHSV;
    ImGuiColorEditFlags_DisplayHex       :: DisplayHex;
    ImGuiColorEditFlags_Uint8            :: Uint8;
    ImGuiColorEditFlags_Float            :: Float;
    ImGuiColorEditFlags_PickerHueBar     :: PickerHueBar;
    ImGuiColorEditFlags_PickerHueWheel   :: PickerHueWheel;
    ImGuiColorEditFlags_InputRGB         :: InputRGB;
    ImGuiColorEditFlags_InputHSV         :: InputHSV;

    ImGuiColorEditFlags_DefaultOptions_  :: DefaultOptions_;

    ImGuiColorEditFlags_DisplayMask_     :: DisplayMask_;
    ImGuiColorEditFlags_DataTypeMask_    :: DataTypeMask_;
    ImGuiColorEditFlags_PickerMask_      :: PickerMask_;
    ImGuiColorEditFlags_InputMask_       :: InputMask_;
}

// Flags for DragFloat(), DragInt(), SliderFloat(), SliderInt() etc.
// We use the same sets of flags for DragXXX() and SliderXXX() functions as the features are the same and it makes it easier to swap them.
// (Those are per-item flags. There are shared flags in ImGuiIO: io.ConfigDragClickToInputText)
SliderFlags :: enum_flags u32 {
    None            :: 0x0;
    AlwaysClamp     :: 0x10;
    Logarithmic     :: 0x20;
    NoRoundToFormat :: 0x40;
    NoInput         :: 0x80;
    InvalidMask_    :: 0x7000000f;

    ImGuiSliderFlags_None            :: None;
    ImGuiSliderFlags_AlwaysClamp     :: AlwaysClamp;
    ImGuiSliderFlags_Logarithmic     :: Logarithmic;
    ImGuiSliderFlags_NoRoundToFormat :: NoRoundToFormat;
    ImGuiSliderFlags_NoInput         :: NoInput;
    ImGuiSliderFlags_InvalidMask_    :: InvalidMask_;
}

// Identify a mouse button.
// Those values are guaranteed to be stable and we frequently use 0/1 directly. Named enums provided for convenience.
MouseButton :: enum u32 {
    Left   :: 0;
    Right  :: 1;
    Middle :: 2;
    COUNT  :: 5;

    ImGuiMouseButton_Left   :: Left;
    ImGuiMouseButton_Right  :: Right;
    ImGuiMouseButton_Middle :: Middle;
    ImGuiMouseButton_COUNT  :: COUNT;
}

// Enumeration for GetMouseCursor()
// User code may request backend to display given cursor by calling SetMouseCursor(), which is why we have some cursors that are marked unused here
MouseCursor :: enum s32 {
    None       :: -1;
    Arrow      :: 0;
    TextInput  :: 1;
    ResizeAll  :: 2;
    ResizeNS   :: 3;
    ResizeEW   :: 4;
    ResizeNESW :: 5;
    ResizeNWSE :: 6;
    Hand       :: 7;
    NotAllowed :: 8;
    COUNT      :: 9;

    ImGuiMouseCursor_None       :: None;
    ImGuiMouseCursor_Arrow      :: Arrow;
    ImGuiMouseCursor_TextInput  :: TextInput;
    ImGuiMouseCursor_ResizeAll  :: ResizeAll;
    ImGuiMouseCursor_ResizeNS   :: ResizeNS;
    ImGuiMouseCursor_ResizeEW   :: ResizeEW;
    ImGuiMouseCursor_ResizeNESW :: ResizeNESW;
    ImGuiMouseCursor_ResizeNWSE :: ResizeNWSE;
    ImGuiMouseCursor_Hand       :: Hand;
    ImGuiMouseCursor_NotAllowed :: NotAllowed;
    ImGuiMouseCursor_COUNT      :: COUNT;
}

// Enumeration for ImGui::SetNextWindow***(), SetWindow***(), SetNextItem***() functions
// Represent a condition.
// Important: Treat as a regular enum! Do NOT combine multiple values using binary operators! All the functions above treat 0 as a shortcut to ImGuiCond_Always.
Cond :: enum u32 {
    None         :: 0;
    Always       :: 1;
    Once         :: 2;
    FirstUseEver :: 4;
    Appearing    :: 8;

    ImGuiCond_None         :: None;
    ImGuiCond_Always       :: Always;
    ImGuiCond_Once         :: Once;
    ImGuiCond_FirstUseEver :: FirstUseEver;
    ImGuiCond_Appearing    :: Appearing;
}

// Flags for ImGui::BeginTable()
// - Important! Sizing policies have complex and subtle side effects, much more so than you would expect.
//   Read comments/demos carefully + experiment with live demos to get acquainted with them.
// - The DEFAULT sizing policies are:
//    - Default to ImGuiTableFlags_SizingFixedFit    if ScrollX is on, or if host window has ImGuiWindowFlags_AlwaysAutoResize.
//    - Default to ImGuiTableFlags_SizingStretchSame if ScrollX is off.
// - When ScrollX is off:
//    - Table defaults to ImGuiTableFlags_SizingStretchSame -> all Columns defaults to ImGuiTableColumnFlags_WidthStretch with same weight.
//    - Columns sizing policy allowed: Stretch (default), Fixed/Auto.
//    - Fixed Columns (if any) will generally obtain their requested width (unless the table cannot fit them all).
//    - Stretch Columns will share the remaining width according to their respective weight.
//    - Mixed Fixed/Stretch columns is possible but has various side-effects on resizing behaviors.
//      The typical use of mixing sizing policies is: any number of LEADING Fixed columns, followed by one or two TRAILING Stretch columns.
//      (this is because the visible order of columns have subtle but necessary effects on how they react to manual resizing).
// - When ScrollX is on:
//    - Table defaults to ImGuiTableFlags_SizingFixedFit -> all Columns defaults to ImGuiTableColumnFlags_WidthFixed
//    - Columns sizing policy allowed: Fixed/Auto mostly.
//    - Fixed Columns can be enlarged as needed. Table will show a horizontal scrollbar if needed.
//    - When using auto-resizing (non-resizable) fixed columns, querying the content width to use item right-alignment e.g. SetNextItemWidth(-FLT_MIN) doesn't make sense, would create a feedback loop.
//    - Using Stretch columns OFTEN DOES NOT MAKE SENSE if ScrollX is on, UNLESS you have specified a value for 'inner_width' in BeginTable().
//      If you specify a value for 'inner_width' then effectively the scrolling space is known and Stretch or mixed Fixed/Stretch columns become meaningful again.
// - Read on documentation at the top of imgui_tables.cpp for details.
TableFlags :: enum_flags u32 {
    None                       :: 0x0;
    Resizable                  :: 0x1;
    Reorderable                :: 0x2;
    Hideable                   :: 0x4;
    Sortable                   :: 0x8;
    NoSavedSettings            :: 0x10;
    ContextMenuInBody          :: 0x20;

    RowBg                      :: 0x40;
    BordersInnerH              :: 0x80;
    BordersOuterH              :: 0x100;
    BordersInnerV              :: 0x200;
    BordersOuterV              :: 0x400;
    BordersH                   :: 0x180;
    BordersV                   :: 0x600;
    BordersInner               :: 0x280;
    BordersOuter               :: 0x500;
    Borders                    :: 0x780;
    NoBordersInBody            :: 0x800;
    NoBordersInBodyUntilResize :: 0x1000;

    SizingFixedFit             :: 0x2000;
    SizingFixedSame            :: 0x4000;
    SizingStretchProp          :: 0x6000;
    SizingStretchSame          :: 0x8000;

    NoHostExtendX              :: 0x10000;
    NoHostExtendY              :: 0x20000;
    NoKeepColumnsVisible       :: 0x40000;
    PreciseWidths              :: 0x80000;

    NoClip                     :: 0x100000;

    PadOuterX                  :: 0x200000;
    NoPadOuterX                :: 0x400000;
    NoPadInnerX                :: 0x800000;

    ScrollX                    :: 0x1000000;
    ScrollY                    :: 0x2000000;

    SortMulti                  :: 0x4000000;
    SortTristate               :: 0x8000000;

    HighlightHoveredColumn     :: 0x10000000;

    SizingMask_                :: 0xe000;

    ImGuiTableFlags_None                       :: None;
    ImGuiTableFlags_Resizable                  :: Resizable;
    ImGuiTableFlags_Reorderable                :: Reorderable;
    ImGuiTableFlags_Hideable                   :: Hideable;
    ImGuiTableFlags_Sortable                   :: Sortable;
    ImGuiTableFlags_NoSavedSettings            :: NoSavedSettings;
    ImGuiTableFlags_ContextMenuInBody          :: ContextMenuInBody;

    ImGuiTableFlags_RowBg                      :: RowBg;
    ImGuiTableFlags_BordersInnerH              :: BordersInnerH;
    ImGuiTableFlags_BordersOuterH              :: BordersOuterH;
    ImGuiTableFlags_BordersInnerV              :: BordersInnerV;
    ImGuiTableFlags_BordersOuterV              :: BordersOuterV;
    ImGuiTableFlags_BordersH                   :: BordersH;
    ImGuiTableFlags_BordersV                   :: BordersV;
    ImGuiTableFlags_BordersInner               :: BordersInner;
    ImGuiTableFlags_BordersOuter               :: BordersOuter;
    ImGuiTableFlags_Borders                    :: Borders;
    ImGuiTableFlags_NoBordersInBody            :: NoBordersInBody;
    ImGuiTableFlags_NoBordersInBodyUntilResize :: NoBordersInBodyUntilResize;

    ImGuiTableFlags_SizingFixedFit             :: SizingFixedFit;
    ImGuiTableFlags_SizingFixedSame            :: SizingFixedSame;
    ImGuiTableFlags_SizingStretchProp          :: SizingStretchProp;
    ImGuiTableFlags_SizingStretchSame          :: SizingStretchSame;

    ImGuiTableFlags_NoHostExtendX              :: NoHostExtendX;
    ImGuiTableFlags_NoHostExtendY              :: NoHostExtendY;
    ImGuiTableFlags_NoKeepColumnsVisible       :: NoKeepColumnsVisible;
    ImGuiTableFlags_PreciseWidths              :: PreciseWidths;

    ImGuiTableFlags_NoClip                     :: NoClip;

    ImGuiTableFlags_PadOuterX                  :: PadOuterX;
    ImGuiTableFlags_NoPadOuterX                :: NoPadOuterX;
    ImGuiTableFlags_NoPadInnerX                :: NoPadInnerX;

    ImGuiTableFlags_ScrollX                    :: ScrollX;
    ImGuiTableFlags_ScrollY                    :: ScrollY;

    ImGuiTableFlags_SortMulti                  :: SortMulti;
    ImGuiTableFlags_SortTristate               :: SortTristate;

    ImGuiTableFlags_HighlightHoveredColumn     :: HighlightHoveredColumn;

    ImGuiTableFlags_SizingMask_                :: SizingMask_;
}

// Flags for ImGui::TableSetupColumn()
TableColumnFlags :: enum_flags u32 {
    None                 :: 0x0;
    Disabled             :: 0x1;
    DefaultHide          :: 0x2;
    DefaultSort          :: 0x4;
    WidthStretch         :: 0x8;
    WidthFixed           :: 0x10;
    NoResize             :: 0x20;
    NoReorder            :: 0x40;
    NoHide               :: 0x80;
    NoClip               :: 0x100;
    NoSort               :: 0x200;
    NoSortAscending      :: 0x400;
    NoSortDescending     :: 0x800;
    NoHeaderLabel        :: 0x1000;
    NoHeaderWidth        :: 0x2000;
    PreferSortAscending  :: 0x4000;
    PreferSortDescending :: 0x8000;
    IndentEnable         :: 0x10000;
    IndentDisable        :: 0x20000;
    AngledHeader         :: 0x40000;

    IsEnabled            :: 0x1000000;
    IsVisible            :: 0x2000000;
    IsSorted             :: 0x4000000;
    IsHovered            :: 0x8000000;

    WidthMask_           :: 0x18;
    IndentMask_          :: 0x30000;
    StatusMask_          :: 0xf000000;
    NoDirectResize_      :: 0x40000000;

    ImGuiTableColumnFlags_None                 :: None;
    ImGuiTableColumnFlags_Disabled             :: Disabled;
    ImGuiTableColumnFlags_DefaultHide          :: DefaultHide;
    ImGuiTableColumnFlags_DefaultSort          :: DefaultSort;
    ImGuiTableColumnFlags_WidthStretch         :: WidthStretch;
    ImGuiTableColumnFlags_WidthFixed           :: WidthFixed;
    ImGuiTableColumnFlags_NoResize             :: NoResize;
    ImGuiTableColumnFlags_NoReorder            :: NoReorder;
    ImGuiTableColumnFlags_NoHide               :: NoHide;
    ImGuiTableColumnFlags_NoClip               :: NoClip;
    ImGuiTableColumnFlags_NoSort               :: NoSort;
    ImGuiTableColumnFlags_NoSortAscending      :: NoSortAscending;
    ImGuiTableColumnFlags_NoSortDescending     :: NoSortDescending;
    ImGuiTableColumnFlags_NoHeaderLabel        :: NoHeaderLabel;
    ImGuiTableColumnFlags_NoHeaderWidth        :: NoHeaderWidth;
    ImGuiTableColumnFlags_PreferSortAscending  :: PreferSortAscending;
    ImGuiTableColumnFlags_PreferSortDescending :: PreferSortDescending;
    ImGuiTableColumnFlags_IndentEnable         :: IndentEnable;
    ImGuiTableColumnFlags_IndentDisable        :: IndentDisable;
    ImGuiTableColumnFlags_AngledHeader         :: AngledHeader;

    ImGuiTableColumnFlags_IsEnabled            :: IsEnabled;
    ImGuiTableColumnFlags_IsVisible            :: IsVisible;
    ImGuiTableColumnFlags_IsSorted             :: IsSorted;
    ImGuiTableColumnFlags_IsHovered            :: IsHovered;

    ImGuiTableColumnFlags_WidthMask_           :: WidthMask_;
    ImGuiTableColumnFlags_IndentMask_          :: IndentMask_;
    ImGuiTableColumnFlags_StatusMask_          :: StatusMask_;
    ImGuiTableColumnFlags_NoDirectResize_      :: NoDirectResize_;
}

// Flags for ImGui::TableNextRow()
TableRowFlags :: enum_flags u32 {
    None    :: 0x0;
    Headers :: 0x1;

    ImGuiTableRowFlags_None    :: None;
    ImGuiTableRowFlags_Headers :: Headers;
}

// Enum for ImGui::TableSetBgColor()
// Background colors are rendering in 3 layers:
//  - Layer 0: draw with RowBg0 color if set, otherwise draw with ColumnBg0 if set.
//  - Layer 1: draw with RowBg1 color if set, otherwise draw with ColumnBg1 if set.
//  - Layer 2: draw with CellBg color if set.
// The purpose of the two row/columns layers is to let you decide if a background color change should override or blend with the existing color.
// When using ImGuiTableFlags_RowBg on the table, each row has the RowBg0 color automatically set for odd/even rows.
// If you set the color of RowBg0 target, your color will override the existing RowBg0 color.
// If you set the color of RowBg1 or ColumnBg1 target, your color will blend over the RowBg0 color.
TableBgTarget :: enum u32 {
    None   :: 0;
    RowBg0 :: 1;
    RowBg1 :: 2;
    CellBg :: 3;

    ImGuiTableBgTarget_None   :: None;
    ImGuiTableBgTarget_RowBg0 :: RowBg0;
    ImGuiTableBgTarget_RowBg1 :: RowBg1;
    ImGuiTableBgTarget_CellBg :: CellBg;
}

// Sorting specifications for a table (often handling sort specs for a single column, occasionally more)
// Obtained by calling TableGetSortSpecs().
// When 'SpecsDirty == true' you can sort your data. It will be true with sorting specs have changed since last call, or the first time.
// Make sure to set 'SpecsDirty = false' after sorting, else you may wastefully sort your data every frame!
TableSortSpecs :: struct {
    Specs:      *TableColumnSortSpecs; // Pointer to sort spec array.
    SpecsCount: s32; // Sort spec count. Most often 1. May be > 1 when ImGuiTableFlags_SortMulti is enabled. May be == 0 when ImGuiTableFlags_SortTristate is enabled.
    SpecsDirty: bool; // Set to true when specs have changed since last time! Use this to sort again, then clear the flag.
}

// Sorting specification for one column of a table (sizeof == 12 bytes)
TableColumnSortSpecs :: struct {
    ColumnUserID:  ID; // User id of the column (if specified by a TableSetupColumn() call)
    ColumnIndex:   ImS16; // Index of the column
    SortOrder:     ImS16; // Index within parent ImGuiTableSortSpecs (always stored in order starting from 0, tables sorted on a single criteria will always have a 0 here)
    SortDirection: u8; /* 8 bits */ // ImGuiSortDirection_Ascending or ImGuiSortDirection_Descending
}

//-----------------------------------------------------------------------------
// IM_MALLOC(), IM_FREE(), IM_NEW(), IM_PLACEMENT_NEW(), IM_DELETE()
// We call C++ constructor on own allocated memory via the placement "new(ptr) Type()" syntax.
// Defining a custom placement new() with a custom parameter allows us to bypass including <new> which on some platforms complains when user has disabled exceptions.
//-----------------------------------------------------------------------------
ImNewWrapper :: struct {
    using imnewwrapper__raw: ImNewWrapper__RAW;
    __empty_struct_padding:  u8; // C++ makes empty structs have length 1
}
// ImNewWrapper without empty struct padding. Needed to generate a C++-equivalent struct layout when "inheriting" from ImNewWrapper
ImNewWrapper__RAW :: struct {}

//-----------------------------------------------------------------------------
// [SECTION] ImGuiStyle
//-----------------------------------------------------------------------------
// You may modify the ImGui::GetStyle() main instance during initialization and before NewFrame().
// During the frame, use ImGui::PushStyleVar(ImGuiStyleVar_XXXX)/PopStyleVar() to alter the main style values,
// and ImGui::PushStyleColor(ImGuiCol_XXX)/PopStyleColor() for colors.
//-----------------------------------------------------------------------------
Style :: struct {
    Alpha:                      float; // Global alpha applies to everything in Dear ImGui.
    DisabledAlpha:              float; // Additional alpha multiplier applied by BeginDisabled(). Multiply over current value of Alpha.
    WindowPadding:              ImVec2; // Padding within a window.
    WindowRounding:             float; // Radius of window corners rounding. Set to 0.0f to have rectangular windows. Large values tend to lead to variety of artifacts and are not recommended.
    WindowBorderSize:           float; // Thickness of border around windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
    WindowMinSize:              ImVec2; // Minimum window size. This is a global setting. If you want to constrain individual windows, use SetNextWindowSizeConstraints().
    WindowTitleAlign:           ImVec2; // Alignment for title bar text. Defaults to (0.0f,0.5f) for left-aligned,vertically centered.
    WindowMenuButtonPosition:   Dir; // Side of the collapsing/docking button in the title bar (None/Left/Right). Defaults to ImGuiDir_Left.
    ChildRounding:              float; // Radius of child window corners rounding. Set to 0.0f to have rectangular windows.
    ChildBorderSize:            float; // Thickness of border around child windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
    PopupRounding:              float; // Radius of popup window corners rounding. (Note that tooltip windows use WindowRounding)
    PopupBorderSize:            float; // Thickness of border around popup/tooltip windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
    FramePadding:               ImVec2; // Padding within a framed rectangle (used by most widgets).
    FrameRounding:              float; // Radius of frame corners rounding. Set to 0.0f to have rectangular frame (used by most widgets).
    FrameBorderSize:            float; // Thickness of border around frames. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
    ItemSpacing:                ImVec2; // Horizontal and vertical spacing between widgets/lines.
    ItemInnerSpacing:           ImVec2; // Horizontal and vertical spacing between within elements of a composed widget (e.g. a slider and its label).
    CellPadding:                ImVec2; // Padding within a table cell. CellPadding.y may be altered between different rows.
    TouchExtraPadding:          ImVec2; // Expand reactive bounding box for touch-based system where touch position is not accurate enough. Unfortunately we don't sort widgets so priority on overlap will always be given to the first widget. So don't grow this too much!
    IndentSpacing:              float; // Horizontal indentation when e.g. entering a tree node. Generally == (FontSize + FramePadding.x*2).
    ColumnsMinSpacing:          float; // Minimum horizontal spacing between two columns. Preferably > (FramePadding.x + 1).
    ScrollbarSize:              float; // Width of the vertical scrollbar, Height of the horizontal scrollbar.
    ScrollbarRounding:          float; // Radius of grab corners for scrollbar.
    GrabMinSize:                float; // Minimum width/height of a grab box for slider/scrollbar.
    GrabRounding:               float; // Radius of grabs corners rounding. Set to 0.0f to have rectangular slider grabs.
    LogSliderDeadzone:          float; // The size in pixels of the dead-zone around zero on logarithmic sliders that cross zero.
    TabRounding:                float; // Radius of upper corners of a tab. Set to 0.0f to have rectangular tabs.
    TabBorderSize:              float; // Thickness of border around tabs.
    TabMinWidthForCloseButton:  float; // Minimum width for close button to appear on an unselected tab when hovered. Set to 0.0f to always show when hovering, set to FLT_MAX to never show close button unless selected.
    TabBarBorderSize:           float; // Thickness of tab-bar separator, which takes on the tab active color to denote focus.
    TableAngledHeadersAngle:    float; // Angle of angled headers (supported values range from -50.0f degrees to +50.0f degrees).
    ColorButtonPosition:        Dir; // Side of the color button in the ColorEdit4 widget (left/right). Defaults to ImGuiDir_Right.
    ButtonTextAlign:            ImVec2; // Alignment of button text when button is larger than text. Defaults to (0.5f, 0.5f) (centered).
    SelectableTextAlign:        ImVec2; // Alignment of selectable text. Defaults to (0.0f, 0.0f) (top-left aligned). It's generally important to keep this left-aligned if you want to lay multiple items on a same line.
    SeparatorTextBorderSize:    float; // Thickkness of border in SeparatorText()
    SeparatorTextAlign:         ImVec2; // Alignment of text within the separator. Defaults to (0.0f, 0.5f) (left aligned, center).
    SeparatorTextPadding:       ImVec2; // Horizontal offset of text from each edge of the separator + spacing on other axis. Generally small values. .y is recommended to be == FramePadding.y.
    DisplayWindowPadding:       ImVec2; // Window position are clamped to be visible within the display area or monitors by at least this amount. Only applies to regular windows.
    DisplaySafeAreaPadding:     ImVec2; // If you cannot see the edges of your screen (e.g. on a TV) increase the safe area padding. Apply to popups/tooltips as well regular windows. NB: Prefer configuring your TV sets correctly!
    DockingSeparatorSize:       float; // Thickness of resizing border between docked windows
    MouseCursorScale:           float; // Scale software rendered mouse cursor (when io.MouseDrawCursor is enabled). We apply per-monitor DPI scaling over this scale. May be removed later.
    AntiAliasedLines:           bool; // Enable anti-aliased lines/borders. Disable if you are really tight on CPU/GPU. Latched at the beginning of the frame (copied to ImDrawList).
    AntiAliasedLinesUseTex:     bool; // Enable anti-aliased lines/borders using textures where possible. Require backend to render with bilinear filtering (NOT point/nearest filtering). Latched at the beginning of the frame (copied to ImDrawList).
    AntiAliasedFill:            bool; // Enable anti-aliased edges around filled shapes (rounded rectangles, circles, etc.). Disable if you are really tight on CPU/GPU. Latched at the beginning of the frame (copied to ImDrawList).
    CurveTessellationTol:       float; // Tessellation tolerance when using PathBezierCurveTo() without a specific number of segments. Decrease for highly tessellated curves (higher quality, more polygons), increase to reduce quality.
    CircleTessellationMaxError: float; // Maximum error (in pixels) allowed when using AddCircle()/AddCircleFilled() or drawing rounded corner rectangles with no explicit segment count specified. Decrease for higher quality but more geometry.
    Colors:                     [55] ImVec4;

    HoverStationaryDelay:       float; // Delay for IsItemHovered(ImGuiHoveredFlags_Stationary). Time required to consider mouse stationary.
    HoverDelayShort:            float; // Delay for IsItemHovered(ImGuiHoveredFlags_DelayShort). Usually used along with HoverStationaryDelay.
    HoverDelayNormal:           float; // Delay for IsItemHovered(ImGuiHoveredFlags_DelayNormal). "
    HoverFlagsForTooltipMouse:  HoveredFlags; // Default flags when using IsItemHovered(ImGuiHoveredFlags_ForTooltip) or BeginItemTooltip()/SetItemTooltip() while using mouse.
    HoverFlagsForTooltipNav:    HoveredFlags; // Default flags when using IsItemHovered(ImGuiHoveredFlags_ForTooltip) or BeginItemTooltip()/SetItemTooltip() while using keyboard/gamepad.

    Constructor :: (this: *Style) -> void #cpp_method #foreign imgui "_ZN10ImGuiStyleC1Ev";
    ScaleAllSizes :: (this: *Style, scale_factor: float) -> void #cpp_method #foreign imgui "_ZN10ImGuiStyle13ScaleAllSizesEf";
}

// [Internal] Storage used by IsKeyDown(), IsKeyPressed() etc functions.
// If prior to 1.87 you used io.KeysDownDuration[] (which was marked as internal), you should use GetKeyData(key)->DownDuration and *NOT* io.KeysData[key]->DownDuration.
KeyData :: struct {
    Down:             bool; // True for if key is down
    DownDuration:     float; // Duration the key has been down (<0.0f: not pressed, 0.0f: just pressed, >0.0f: time held)
    DownDurationPrev: float; // Last frame duration the key has been down
    AnalogValue:      float; // 0.0f..1.0f for gamepad values
}

IO :: struct {
    ConfigFlags_:                      ConfigFlags; // = 0              // See ImGuiConfigFlags_ enum. Set by user/application. Gamepad/keyboard navigation options, etc.
    BackendFlags_:                     BackendFlags; // = 0              // See ImGuiBackendFlags_ enum. Set by backend (imgui_impl_xxx files or custom backend) to communicate features supported by the backend.
    DisplaySize:                       ImVec2; // <unset>          // Main display size, in pixels (generally == GetMainViewport()->Size). May change every frame.
    DeltaTime:                         float; // = 1.0f/60.0f     // Time elapsed since last frame, in seconds. May change every frame.
    IniSavingRate:                     float; // = 5.0f           // Minimum time between saving positions/sizes to .ini file, in seconds.
    IniFilename:                       *u8; // = "imgui.ini"    // Path to .ini file (important: default "imgui.ini" is relative to current working dir!). Set NULL to disable automatic .ini loading/saving or if you want to manually call LoadIniSettingsXXX() / SaveIniSettingsXXX() functions.
    LogFilename:                       *u8; // = "imgui_log.txt"// Path to .log file (default parameter to ImGui::LogToFile when no file is specified).
    UserData:                          *void; // = NULL           // Store your own data.

    Fonts:                             *ImFontAtlas; // <auto>           // Font atlas: load, rasterize and pack one or more fonts into a single texture.
    FontGlobalScale:                   float; // = 1.0f           // Global scale all fonts
    FontAllowUserScaling:              bool; // = false          // Allow user scaling text of individual window with CTRL+Wheel.
    FontDefault:                       *ImFont; // = NULL           // Font to use on NewFrame(). Use NULL to uses Fonts->Fonts[0].
    DisplayFramebufferScale:           ImVec2; // = (1, 1)         // For retina display or other situations where window coordinates are different from framebuffer coordinates. This generally ends up in ImDrawData::FramebufferScale.

    ConfigDockingNoSplit:              bool; // = false          // Simplified docking mode: disable window splitting, so docking is limited to merging multiple windows together into tab-bars.
    ConfigDockingWithShift:            bool; // = false          // Enable docking with holding Shift key (reduce visual noise, allows dropping in wider space)
    ConfigDockingAlwaysTabBar:         bool; // = false          // [BETA] [FIXME: This currently creates regression with auto-sizing and general overhead] Make every single floating window display within a docking node.
    ConfigDockingTransparentPayload:   bool; // = false          // [BETA] Make window or viewport transparent when docking and only display docking boxes on the target viewport. Useful if rendering of multiple viewport cannot be synced. Best used with ConfigViewportsNoAutoMerge.

    ConfigViewportsNoAutoMerge:        bool; // = false;         // Set to make all floating imgui windows always create their own viewport. Otherwise, they are merged into the main host viewports when overlapping it. May also set ImGuiViewportFlags_NoAutoMerge on individual viewport.
    ConfigViewportsNoTaskBarIcon:      bool; // = false          // Disable default OS task bar icon flag for secondary viewports. When a viewport doesn't want a task bar icon, ImGuiViewportFlags_NoTaskBarIcon will be set on it.
    ConfigViewportsNoDecoration:       bool; // = true           // Disable default OS window decoration flag for secondary viewports. When a viewport doesn't want window decorations, ImGuiViewportFlags_NoDecoration will be set on it. Enabling decoration can create subsequent issues at OS levels (e.g. minimum window size).
    ConfigViewportsNoDefaultParent:    bool; // = false          // Disable default OS parenting to main viewport for secondary viewports. By default, viewports are marked with ParentViewportId = <main_viewport>, expecting the platform backend to setup a parent/child relationship between the OS windows (some backend may ignore this). Set to true if you want the default to be 0, then all viewports will be top-level OS windows.

    MouseDrawCursor:                   bool; // = false          // Request ImGui to draw a mouse cursor for you (if you are on a platform without a mouse cursor). Cannot be easily renamed to 'io.ConfigXXX' because this is frequently used by backend implementations.
    ConfigMacOSXBehaviors:             bool; // = defined(__APPLE__) // OS X style: Text editing cursor movement using Alt instead of Ctrl, Shortcuts using Cmd/Super instead of Ctrl, Line/Text Start and End using Cmd+Arrows instead of Home/End, Double click selects by word instead of selecting whole text, Multi-selection in lists uses Cmd/Super instead of Ctrl.
    ConfigInputTrickleEventQueue:      bool; // = true           // Enable input queue trickling: some types of events submitted during the same frame (e.g. button down + up) will be spread over multiple frames, improving interactions with low framerates.
    ConfigInputTextCursorBlink:        bool; // = true           // Enable blinking cursor (optional as some users consider it to be distracting).
    ConfigInputTextEnterKeepActive:    bool; // = false          // [BETA] Pressing Enter will keep item active and select contents (single-line only).
    ConfigDragClickToInputText:        bool; // = false          // [BETA] Enable turning DragXXX widgets into text input with a simple mouse click-release (without moving). Not desirable on devices without a keyboard.
    ConfigWindowsResizeFromEdges:      bool; // = true           // Enable resizing of windows from their edges and from the lower-left corner. This requires (io.BackendFlags & ImGuiBackendFlags_HasMouseCursors) because it needs mouse cursor feedback. (This used to be a per-window ImGuiWindowFlags_ResizeFromAnySide flag)
    ConfigWindowsMoveFromTitleBarOnly: bool; // = false       // Enable allowing to move windows only when clicking on their title bar. Does not apply to windows without a title bar.
    ConfigMemoryCompactTimer:          float; // = 60.0f          // Timer (in seconds) to free transient windows/tables memory buffers when unused. Set to -1.0f to disable.

    MouseDoubleClickTime:              float; // = 0.30f          // Time for a double-click, in seconds.
    MouseDoubleClickMaxDist:           float; // = 6.0f           // Distance threshold to stay in to validate a double-click, in pixels.
    MouseDragThreshold:                float; // = 6.0f           // Distance threshold before considering we are dragging.
    KeyRepeatDelay:                    float; // = 0.275f         // When holding a key/button, time before it starts repeating, in seconds (for buttons in Repeat mode, etc.).
    KeyRepeatRate:                     float; // = 0.050f         // When holding a key/button, rate at which it repeats, in seconds.

    ConfigDebugIsDebuggerPresent:      bool; // = false          // Enable various tools calling IM_DEBUG_BREAK().

    ConfigDebugBeginReturnValueOnce:   bool; // = false          // First-time calls to Begin()/BeginChild() will return false. NEEDS TO BE SET AT APPLICATION BOOT TIME if you don't want to miss windows.
    ConfigDebugBeginReturnValueLoop:   bool; // = false          // Some calls to Begin()/BeginChild() will return false. Will cycle through window depths then repeat. Suggested use: add "io.ConfigDebugBeginReturnValue = io.KeyShift" in your main loop then occasionally press SHIFT. Windows should be flickering while running.

    ConfigDebugIgnoreFocusLoss:        bool; // = false          // Ignore io.AddFocusEvent(false), consequently not calling io.ClearInputKeys() in input processing.

    ConfigDebugIniSettings:            bool; // = false          // Save .ini data with extra comments (particularly helpful for Docking, but makes saving slower)

    BackendPlatformName:               *u8; // = NULL
    BackendRendererName:               *u8; // = NULL
    BackendPlatformUserData:           *void; // = NULL           // User data for platform backend
    BackendRendererUserData:           *void; // = NULL           // User data for renderer backend
    BackendLanguageUserData:           *void; // = NULL           // User data for non C++ programming language backend

    // Optional: Access OS clipboard
    // (default to use native Win32 clipboard on Windows, otherwise uses a private clipboard. Override to access OS clipboard on other architectures)
    GetClipboardTextFn:                #type (user_data: *void) -> *u8 #c_call;
    SetClipboardTextFn:                #type (user_data: *void, text: *u8) -> void #c_call;
    ClipboardUserData:                 *void;

    // Optional: Notify OS Input Method Editor of the screen position of your cursor for text input position (e.g. when using Japanese/Chinese IME on Windows)
    // (default to use native imm32 api on Windows)
    SetPlatformImeDataFn:              #type (viewport: *Viewport, data: *PlatformImeData) -> void #c_call;

    PlatformLocaleDecimalPoint:        ImWchar; // '.'              // [Experimental] Configure decimal point e.g. '.' or ',' useful for some languages (e.g. German), generally pulled from *localeconv()->decimal_point

    // Input Functions
    AddKeyEvent :: (this: *IO, key: Key, down: bool) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO11AddKeyEventE8ImGuiKeyb";
    AddKeyAnalogEvent :: (this: *IO, key: Key, down: bool, v: float) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO17AddKeyAnalogEventE8ImGuiKeybf";
    AddMousePosEvent :: (this: *IO, x: float, y: float) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO16AddMousePosEventEff";
    AddMouseButtonEvent :: (this: *IO, button: s32, down: bool) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO19AddMouseButtonEventEib";
    AddMouseWheelEvent :: (this: *IO, wheel_x: float, wheel_y: float) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO18AddMouseWheelEventEff";
    AddMouseSourceEvent :: (this: *IO, source: MouseSource) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO19AddMouseSourceEventE16ImGuiMouseSource";
    AddMouseViewportEvent :: (this: *IO, id: ID) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO21AddMouseViewportEventEj";
    AddFocusEvent :: (this: *IO, focused: bool) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO13AddFocusEventEb";
    AddInputCharacter :: (this: *IO, c: u32) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO17AddInputCharacterEj";
    AddInputCharacterUTF16 :: (this: *IO, c: ImWchar16) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO22AddInputCharacterUTF16Et";
    AddInputCharactersUTF8 :: (this: *IO, str: *u8) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO22AddInputCharactersUTF8EPKc";

    SetKeyEventNativeData :: (this: *IO, key: Key, native_keycode: s32, native_scancode: s32, native_legacy_index: s32 = -1) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO21SetKeyEventNativeDataE8ImGuiKeyiii";
    SetAppAcceptingEvents :: (this: *IO, accepting_events: bool) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO21SetAppAcceptingEventsEb";
    ClearEventsQueue :: (this: *IO) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO16ClearEventsQueueEv";
    ClearInputKeys :: (this: *IO) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO14ClearInputKeysEv";

    ClearInputCharacters :: (this: *IO) -> void #cpp_method #foreign imgui "_ZN7ImGuiIO20ClearInputCharactersEv";

    WantCaptureMouse:                  bool; // Set when Dear ImGui will use mouse inputs, in this case do not dispatch them to your main game/application (either way, always pass on mouse inputs to imgui). (e.g. unclicked mouse is hovering over an imgui window, widget is active, mouse was clicked over an imgui window, etc.).
    WantCaptureKeyboard:               bool; // Set when Dear ImGui will use keyboard inputs, in this case do not dispatch them to your main game/application (either way, always pass keyboard inputs to imgui). (e.g. InputText active, or an imgui window is focused and navigation is enabled, etc.).
    WantTextInput:                     bool; // Mobile/console: when set, you may display an on-screen keyboard. This is set by Dear ImGui when it wants textual keyboard input to happen (e.g. when a InputText widget is active).
    WantSetMousePos:                   bool; // MousePos has been altered, backend should reposition mouse on next frame. Rarely used! Set only when ImGuiConfigFlags_NavEnableSetMousePos flag is enabled.
    WantSaveIniSettings:               bool; // When manual .ini load/save is active (io.IniFilename == NULL), this will be set to notify your application that you can call SaveIniSettingsToMemory() and save yourself. Important: clear io.WantSaveIniSettings yourself after saving!
    NavActive:                         bool; // Keyboard/Gamepad navigation is currently allowed (will handle ImGuiKey_NavXXX events) = a window is focused and it doesn't use the ImGuiWindowFlags_NoNavInputs flag.
    NavVisible:                        bool; // Keyboard/Gamepad navigation is visible and allowed (will handle ImGuiKey_NavXXX events).
    Framerate:                         float; // Estimate of application framerate (rolling average over 60 frames, based on io.DeltaTime), in frame per second. Solely for convenience. Slow applications may not want to use a moving average or may want to reset underlying buffers occasionally.
    MetricsRenderVertices:             s32; // Vertices output during last call to Render()
    MetricsRenderIndices:              s32; // Indices output during last call to Render() = number of triangles * 3
    MetricsRenderWindows:              s32; // Number of visible windows
    MetricsActiveWindows:              s32; // Number of active windows
    MouseDelta:                        ImVec2; // Mouse delta. Note that this is zero if either current or previous position are invalid (-FLT_MAX,-FLT_MAX), so a disappearing/reappearing mouse won't have a huge delta.

    KeyMap:                            [666] s32; // [LEGACY] Input: map of indices into the KeysDown[512] entries array which represent your "native" keyboard state. The first 512 are now unused and should be kept zero. Legacy backend will write into KeyMap[] using ImGuiKey_ indices which are always >512.
    KeysDown:                          [666] bool; // [LEGACY] Input: Keyboard keys that are pressed (ideally left in the "native" order your engine has access to keyboard keys, so you can use your own defines/enums for keys). This used to be [512] sized. It is now ImGuiKey_COUNT to allow legacy io.KeysDown[GetKeyIndex(...)] to work without an overflow.
    NavInputs:                         [16] float; // [LEGACY] Since 1.88, NavInputs[] was removed. Backends from 1.60 to 1.86 won't build. Feed gamepad inputs via io.AddKeyEvent() and ImGuiKey_GamepadXXX enums.

    Ctx:                               *Context; // Parent UI context (needs to be set explicitly by parent).

    MousePos:                          ImVec2; // Mouse position, in pixels. Set to ImVec2(-FLT_MAX, -FLT_MAX) if mouse is unavailable (on another screen, etc.)
    MouseDown:                         [5] bool; // Mouse buttons: 0=left, 1=right, 2=middle + extras (ImGuiMouseButton_COUNT == 5). Dear ImGui mostly uses left and right buttons. Other buttons allow us to track if the mouse is being used by your application + available to user as a convenience via IsMouse** API.
    MouseWheel:                        float; // Mouse wheel Vertical: 1 unit scrolls about 5 lines text. >0 scrolls Up, <0 scrolls Down. Hold SHIFT to turn vertical scroll into horizontal scroll.
    MouseWheelH:                       float; // Mouse wheel Horizontal. >0 scrolls Left, <0 scrolls Right. Most users don't have a mouse with a horizontal wheel, may not be filled by all backends.
    MouseSource_:                      MouseSource; // Mouse actual input peripheral (Mouse/TouchScreen/Pen).
    MouseHoveredViewport:              ID; // (Optional) Modify using io.AddMouseViewportEvent(). With multi-viewports: viewport the OS mouse is hovering. If possible _IGNORING_ viewports with the ImGuiViewportFlags_NoInputs flag is much better (few backends can handle that). Set io.BackendFlags |= ImGuiBackendFlags_HasMouseHoveredViewport if you can provide this info. If you don't imgui will infer the value using the rectangles and last focused time of the viewports it knows about (ignoring other OS windows).
    KeyCtrl:                           bool; // Keyboard modifier down: Control
    KeyShift:                          bool; // Keyboard modifier down: Shift
    KeyAlt:                            bool; // Keyboard modifier down: Alt
    KeySuper:                          bool; // Keyboard modifier down: Cmd/Super/Windows

    KeyMods:                           KeyChord; // Key mods flags (any of ImGuiMod_Ctrl/ImGuiMod_Shift/ImGuiMod_Alt/ImGuiMod_Super flags, same as io.KeyCtrl/KeyShift/KeyAlt/KeySuper but merged into flags. DOES NOT CONTAINS ImGuiMod_Shortcut which is pretranslated). Read-only, updated by NewFrame()
    KeysData:                          [666] KeyData; // Key state for all known keys. Use IsKeyXXX() functions to access this.
    WantCaptureMouseUnlessPopupClose:  bool; // Alternative to WantCaptureMouse: (WantCaptureMouse == true && WantCaptureMouseUnlessPopupClose == false) when a click over void is expected to close a popup.
    MousePosPrev:                      ImVec2; // Previous mouse position (note that MouseDelta is not necessary == MousePos-MousePosPrev, in case either position is invalid)
    MouseClickedPos:                   [5] ImVec2; // Position at time of clicking
    MouseClickedTime:                  [5] float64; // Time of last click (used to figure out double-click)
    MouseClicked:                      [5] bool; // Mouse button went from !Down to Down (same as MouseClickedCount[x] != 0)
    MouseDoubleClicked:                [5] bool; // Has mouse button been double-clicked? (same as MouseClickedCount[x] == 2)
    MouseClickedCount:                 [5] ImU16; // == 0 (not clicked), == 1 (same as MouseClicked[]), == 2 (double-clicked), == 3 (triple-clicked) etc. when going from !Down to Down
    MouseClickedLastCount:             [5] ImU16; // Count successive number of clicks. Stays valid after mouse release. Reset after another click is done.
    MouseReleased:                     [5] bool; // Mouse button went from Down to !Down
    MouseDownOwned:                    [5] bool; // Track if button was clicked inside a dear imgui window or over void blocked by a popup. We don't request mouse capture from the application if click started outside ImGui bounds.
    MouseDownOwnedUnlessPopupClose:    [5] bool; // Track if button was clicked inside a dear imgui window.
    MouseWheelRequestAxisSwap:         bool; // On a non-Mac system, holding SHIFT requests WheelY to perform the equivalent of a WheelX event. On a Mac system this is already enforced by the system.
    MouseDownDuration:                 [5] float; // Duration the mouse button has been down (0.0f == just clicked)
    MouseDownDurationPrev:             [5] float; // Previous time the mouse button has been down
    MouseDragMaxDistanceAbs:           [5] ImVec2; // Maximum distance, absolute, on each axis, of how much mouse has traveled from the clicking point
    MouseDragMaxDistanceSqr:           [5] float; // Squared maximum distance of how much mouse has traveled from the clicking point (used for moving thresholds)
    PenPressure:                       float; // Touch/Pen pressure (0.0f to 1.0f, should be >0.0f only when MouseDown[0] == true). Helper storage currently unused by Dear ImGui.
    AppFocusLost:                      bool; // Only modify via AddFocusEvent()
    AppAcceptingEvents:                bool; // Only modify via SetAppAcceptingEvents()
    BackendUsingLegacyKeyArrays:       ImS8; // -1: unknown, 0: using AddKeyEvent(), 1: using legacy io.KeysDown[]
    BackendUsingLegacyNavInputArray:   bool; // 0: using AddKeyAnalogEvent(), 1: writing to legacy io.NavInputs[] directly
    InputQueueSurrogate:               ImWchar16; // For AddInputCharacterUTF16()
    InputQueueCharacters:              ImVector(ImWchar); // Queue of _characters_ input (obtained by platform backend). Fill using AddInputCharacter() helper.

    Constructor :: (this: *IO) -> void #cpp_method #foreign imgui "_ZN7ImGuiIOC1Ev";
}

// Shared state of InputText(), passed as an argument to your callback when a ImGuiInputTextFlags_Callback* flag is used.
// The callback function should return 0 by default.
// Callbacks (follow a flag name and see comments in ImGuiInputTextFlags_ declarations for more details)
// - ImGuiInputTextFlags_CallbackEdit:        Callback on buffer edit (note that InputText() already returns true on edit, the callback is useful mainly to manipulate the underlying buffer while focus is active)
// - ImGuiInputTextFlags_CallbackAlways:      Callback on each iteration
// - ImGuiInputTextFlags_CallbackCompletion:  Callback on pressing TAB
// - ImGuiInputTextFlags_CallbackHistory:     Callback on pressing Up/Down arrows
// - ImGuiInputTextFlags_CallbackCharFilter:  Callback on character inputs to replace or discard them. Modify 'EventChar' to replace or discard, or return 1 in callback to discard.
// - ImGuiInputTextFlags_CallbackResize:      Callback on buffer capacity changes request (beyond 'buf_size' parameter value), allowing the string to grow.
InputTextCallbackData :: struct {
    Ctx:            *Context; // Parent UI context
    EventFlag:      InputTextFlags; // One ImGuiInputTextFlags_Callback*    // Read-only
    Flags:          InputTextFlags; // What user passed to InputText()      // Read-only
    UserData:       *void; // What user passed to InputText()      // Read-only

    EventChar:      ImWchar; // Character input                      // Read-write   // [CharFilter] Replace character with another one, or set to zero to drop. return 1 is equivalent to setting EventChar=0;
    EventKey:       Key; // Key pressed (Up/Down/TAB)            // Read-only    // [Completion,History]
    Buf:            *u8; // Text buffer                          // Read-write   // [Resize] Can replace pointer / [Completion,History,Always] Only write to pointed data, don't replace the actual pointer!
    BufTextLen:     s32; // Text length (in bytes)               // Read-write   // [Resize,Completion,History,Always] Exclude zero-terminator storage. In C land: == strlen(some_text), in C++ land: string.length()
    BufSize:        s32; // Buffer size (in bytes) = capacity+1  // Read-only    // [Resize,Completion,History,Always] Include zero-terminator storage. In C land == ARRAYSIZE(my_char_array), in C++ land: string.capacity()+1
    BufDirty:       bool; // Set if you modify Buf/BufTextLen!    // Write        // [Completion,History,Always]
    CursorPos:      s32; //                                      // Read-write   // [Completion,History,Always]
    SelectionStart: s32; //                                      // Read-write   // [Completion,History,Always] == to SelectionEnd when no selection)
    SelectionEnd:   s32; //                                      // Read-write   // [Completion,History,Always]

    // Helper functions for text manipulation.
    // Use those function to benefit from the CallbackResize behaviors. Calling those function reset the selection.
    Constructor :: (this: *InputTextCallbackData) -> void #cpp_method #foreign imgui "_ZN26ImGuiInputTextCallbackDataC1Ev";
    DeleteChars :: (this: *InputTextCallbackData, pos: s32, bytes_count: s32) -> void #cpp_method #foreign imgui "_ZN26ImGuiInputTextCallbackData11DeleteCharsEii";
    InsertChars :: (this: *InputTextCallbackData, pos: s32, text: *u8, text_end: *u8 = null) -> void #cpp_method #foreign imgui "_ZN26ImGuiInputTextCallbackData11InsertCharsEiPKcS1_";
    InsertChars :: (this: *InputTextCallbackData, pos: s32, text: string) #no_context {
        InsertChars(this, pos, text.data, text.data + text.count);
    }
}

// Resizing callback data to apply custom constraint. As enabled by SetNextWindowSizeConstraints(). Callback is called during the next Begin().
// NB: For basic min/max size constraint on each axis you don't need to use the callback! The SetNextWindowSizeConstraints() parameters are enough.
SizeCallbackData :: struct {
    UserData:    *void; // Read-only.   What user passed to SetNextWindowSizeConstraints(). Generally store an integer or float in here (need reinterpret_cast<>).
    Pos:         ImVec2; // Read-only.   Window position, for reference.
    CurrentSize: ImVec2; // Read-only.   Current window size.
    DesiredSize: ImVec2; // Read-write.  Desired size, based on user's mouse position. Write to this field to restrain resizing.
}

// [ALPHA] Rarely used / very advanced uses only. Use with SetNextWindowClass() and DockSpace() functions.
// Important: the content of this class is still highly WIP and likely to change and be refactored
// before we stabilize Docking features. Please be mindful if using this.
// Provide hints:
// - To the platform backend via altered viewport flags (enable/disable OS decoration, OS task bar icons, etc.)
// - To the platform backend for OS level parent/child relationships of viewport.
// - To the docking system for various options and filtering.
WindowClass :: struct {
    ClassId:                    ID; // User data. 0 = Default class (unclassed). Windows of different classes cannot be docked with each others.
    ParentViewportId:           ID; // Hint for the platform backend. -1: use default. 0: request platform backend to not parent the platform. != 0: request platform backend to create a parent<>child relationship between the platform windows. Not conforming backends are free to e.g. parent every viewport to the main viewport or not.
    FocusRouteParentWindowId:   ID; // ID of parent window for shortcut focus route evaluation, e.g. Shortcut() call from Parent Window will succeed when this window is focused.
    ViewportFlagsOverrideSet:   ViewportFlags; // Viewport flags to set when a window of this class owns a viewport. This allows you to enforce OS decoration or task bar icon, override the defaults on a per-window basis.
    ViewportFlagsOverrideClear: ViewportFlags; // Viewport flags to clear when a window of this class owns a viewport. This allows you to enforce OS decoration or task bar icon, override the defaults on a per-window basis.
    TabItemFlagsOverrideSet:    TabItemFlags; // [EXPERIMENTAL] TabItem flags to set when a window of this class gets submitted into a dock node tab bar. May use with ImGuiTabItemFlags_Leading or ImGuiTabItemFlags_Trailing.
    DockNodeFlagsOverrideSet:   DockNodeFlags; // [EXPERIMENTAL] Dock node flags to set when a window of this class is hosted by a dock node (it doesn't have to be selected!)
    DockingAlwaysTabBar:        bool; // Set to true to enforce single floating windows of this class always having their own docking node (equivalent of setting the global io.ConfigDockingAlwaysTabBar)
    DockingAllowUnclassed:      bool; // Set to true to allow windows of this class to be docked/merged with an unclassed window. // FIXME-DOCK: Move to DockNodeFlags override?
}

// Data payload for Drag and Drop operations: AcceptDragDropPayload(), GetDragDropPayload()
Payload :: struct {
    Data:           *void; // Data (copied and owned by dear imgui)
    DataSize:       s32; // Data size

    SourceId:       ID; // Source item id
    SourceParentId: ID; // Source parent id (if available)
    DataFrameCount: s32; // Data timestamp
    DataType:       [33] u8; // Data type tag (short user-supplied string, 32 characters max)
    Preview:        bool; // Set when AcceptDragDropPayload() was called and mouse has been hovering the target item (nb: handle overlapping drag targets)
    Delivery:       bool; // Set when AcceptDragDropPayload() was called and mouse button is released over the target item.
}

// Helper: Execute a block of code at maximum once a frame. Convenient if you want to quickly create a UI within deep-nested code that runs multiple times every frame.
// Usage: static ImGuiOnceUponAFrame oaf; if (oaf) ImGui::Text("This will be called only once per frame");
OnceUponAFrame :: struct {
    RefFrame: s32;
}

// Helper: Parse and apply text filters. In format "aaaaa[,bbbb][,ccccc]"
TextFilter :: struct {
    Constructor :: (this: *TextFilter, default_filter: *u8 = "") -> void #cpp_method #foreign imgui "_ZN15ImGuiTextFilterC1EPKc";
    Draw :: (this: *TextFilter, label: *u8 = "Filter (inc,-exc)", width: float = 0.0) -> bool #cpp_method #foreign imgui "_ZN15ImGuiTextFilter4DrawEPKcf";
    PassFilter :: (this: *TextFilter, text: *u8, text_end: *u8 = null) -> bool #cpp_method #foreign imgui "_ZNK15ImGuiTextFilter10PassFilterEPKcS1_";
    PassFilter :: (this: *TextFilter, text: string) -> bool #no_context {
        return PassFilter(this, text.data, text.data + text.count);
    }
    Build :: (this: *TextFilter) -> void #cpp_method #foreign imgui "_ZN15ImGuiTextFilter5BuildEv";

    // [Internal]
    TextRange :: struct {
        b: *u8;
        e: *u8;

        split :: (this: *TextRange, separator: u8, out: *ImVector(TextRange)) -> void #cpp_method #foreign imgui "_ZNK15ImGuiTextFilter14ImGuiTextRange5splitEcP8ImVectorIS0_E";
    }

    InputBuf:  [256] u8;
    Filters:   ImVector(TextRange);
    CountGrep: s32;
}

// Helper: Growable text buffer for logging/accumulating text
// (this could be called 'ImGuiTextBuilder' / 'ImGuiStringBuilder')
TextBuffer :: struct {
    Buf: ImVector(u8);

    append :: (this: *TextBuffer, str: *u8, str_end: *u8 = null) -> void #cpp_method #foreign imgui "_ZN15ImGuiTextBuffer6appendEPKcS1_";
    append :: (this: *TextBuffer, str: string) #no_context {
        append(this, str.data, str.data + str.count);
    }
    appendf_CFormat :: (this: *TextBuffer, fmt: *u8, __args: ..Any) -> void #cpp_method #foreign imgui "_ZN15ImGuiTextBuffer7appendfEPKcz";
    appendf :: (this: *TextBuffer, fmt: string, __args: ..Any) {
        push_allocator(temp);
        formatted_text_builder: String_Builder;
        print_to_builder(*formatted_text_builder, fmt, ..__args);
        append(*formatted_text_builder, "\0");
        formatted_text := builder_to_string(*formatted_text_builder);
        appendf_CFormat(this, "%s", formatted_text.data);
    } @PrintLike
}

// Helper: Key->Value storage
// Typically you don't have to worry about this since a storage is held within each Window.
// We use it to e.g. store collapse state for a tree (Int 0/1)
// This is optimized for efficient lookup (dichotomy into a contiguous buffer) and rare insertion (typically tied to user interactions aka max once a frame)
// You can use it as custom user storage for temporary values. Declare your own storage if, for example:
// - You want to manipulate the open/close state of a particular sub-tree in your interface (tree node uses Int 0/1 to store their state).
// - You want to store custom debug data easily without adding or editing structures in your code (probably not efficient, but convenient)
// Types are NOT stored, so it is up to you to make sure your Key don't collide with different types.
Storage :: struct {
    // [Internal]
    StoragePair :: struct {
        key: ID;
        union {
            val_i: s32;
            val_f: float;
            val_p: *void;
        }
    }

    Data: ImVector(StoragePair);

    GetInt :: (this: *Storage, key: ID, default_val: s32 = 0) -> s32 #cpp_method #foreign imgui "_ZNK12ImGuiStorage6GetIntEji";
    SetInt :: (this: *Storage, key: ID, val: s32) -> void #cpp_method #foreign imgui "_ZN12ImGuiStorage6SetIntEji";
    GetBool :: (this: *Storage, key: ID, default_val := false) -> bool #cpp_method #foreign imgui "_ZNK12ImGuiStorage7GetBoolEjb";
    SetBool :: (this: *Storage, key: ID, val: bool) -> void #cpp_method #foreign imgui "_ZN12ImGuiStorage7SetBoolEjb";
    GetFloat :: (this: *Storage, key: ID, default_val: float = 0.0) -> float #cpp_method #foreign imgui "_ZNK12ImGuiStorage8GetFloatEjf";
    SetFloat :: (this: *Storage, key: ID, val: float) -> void #cpp_method #foreign imgui "_ZN12ImGuiStorage8SetFloatEjf";
    GetVoidPtr :: (this: *Storage, key: ID) -> *void #cpp_method #foreign imgui "_ZNK12ImGuiStorage10GetVoidPtrEj";
    SetVoidPtr :: (this: *Storage, key: ID, val: *void) -> void #cpp_method #foreign imgui "_ZN12ImGuiStorage10SetVoidPtrEjPv";

    // - Get***Ref() functions finds pair, insert on demand if missing, return pointer. Useful if you intend to do Get+Set.
    // - References are only valid until a new value is added to the storage. Calling a Set***() function or a Get***Ref() function invalidates the pointer.
    // - A typical use case where this is convenient for quick hacking (e.g. add storage during a live Edit&Continue session if you can't modify existing struct)
    //      float* pvar = ImGui::GetFloatRef(key); ImGui::SliderFloat("var", pvar, 0, 100.0f); some_var += *pvar;
    GetIntRef :: (this: *Storage, key: ID, default_val: s32 = 0) -> *s32 #cpp_method #foreign imgui "_ZN12ImGuiStorage9GetIntRefEji";
    GetBoolRef :: (this: *Storage, key: ID, default_val := false) -> *bool #cpp_method #foreign imgui "_ZN12ImGuiStorage10GetBoolRefEjb";
    GetFloatRef :: (this: *Storage, key: ID, default_val: float = 0.0) -> *float #cpp_method #foreign imgui "_ZN12ImGuiStorage11GetFloatRefEjf";
    GetVoidPtrRef :: (this: *Storage, key: ID, default_val: *void = null) -> **void #cpp_method #foreign imgui "_ZN12ImGuiStorage13GetVoidPtrRefEjPv";

    // Advanced: for quicker full rebuild of a storage (instead of an incremental one), you may add all your contents and then sort once.
    BuildSortByKey :: (this: *Storage) -> void #cpp_method #foreign imgui "_ZN12ImGuiStorage14BuildSortByKeyEv";

    // Obsolete: use on your own storage if you know only integer are being stored (open/close all tree nodes)
    SetAllInt :: (this: *Storage, val: s32) -> void #cpp_method #foreign imgui "_ZN12ImGuiStorage9SetAllIntEi";
}

// Helper: Manually clip large list of items.
// If you have lots evenly spaced items and you have random access to the list, you can perform coarse
// clipping based on visibility to only submit items that are in view.
// The clipper calculates the range of visible items and advance the cursor to compensate for the non-visible items we have skipped.
// (Dear ImGui already clip items based on their bounds but: it needs to first layout the item to do so, and generally
//  fetching/submitting your own data incurs additional cost. Coarse clipping using ImGuiListClipper allows you to easily
//  scale using lists with tens of thousands of items without a problem)
// Usage:
//   ImGuiListClipper clipper;
//   clipper.Begin(1000);         // We have 1000 elements, evenly spaced.
//   while (clipper.Step())
//       for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++)
//           ImGui::Text("line number %d", i);
// Generally what happens is:
// - Clipper lets you process the first element (DisplayStart = 0, DisplayEnd = 1) regardless of it being visible or not.
// - User code submit that one element.
// - Clipper can measure the height of the first element
// - Clipper calculate the actual range of elements to display based on the current clipping rectangle, position the cursor before the first visible element.
// - User code submit visible elements.
// - The clipper also handles various subtleties related to keyboard/gamepad navigation, wrapping etc.
ListClipper :: struct {
    Ctx:          *Context; // Parent UI context
    DisplayStart: s32; // First item to display, updated by each call to Step()
    DisplayEnd:   s32; // End of items to display (exclusive)
    ItemsCount:   s32; // [Internal] Number of items
    ItemsHeight:  float; // [Internal] Height of item after a first step and item submission can calculate it
    StartPosY:    float; // [Internal] Cursor position at the time of Begin() or after table frozen rows are all processed
    TempData:     *void; // [Internal] Internal data

    // items_count: Use INT_MAX if you don't know how many items you have (in which case the cursor won't be advanced in the final step)
    // items_height: Use -1.0f to be calculated automatically on first step. Otherwise pass in the distance between your items, typically GetTextLineHeightWithSpacing() or GetFrameHeightWithSpacing().
    Constructor :: (this: *ListClipper) -> void #cpp_method #foreign imgui "_ZN16ImGuiListClipperC1Ev";
    Destructor_Base :: (this: *ListClipper) -> void #cpp_method #foreign imgui "_ZN16ImGuiListClipperD2Ev";
    Destructor :: (this: *ListClipper) -> void #cpp_method #foreign imgui "_ZN16ImGuiListClipperD1Ev";
    Begin :: (this: *ListClipper, items_count: s32, items_height: float = -1.0) -> void #cpp_method #foreign imgui "_ZN16ImGuiListClipper5BeginEif";
    End :: (this: *ListClipper) -> void #cpp_method #foreign imgui "_ZN16ImGuiListClipper3EndEv";
    Step :: (this: *ListClipper) -> bool #cpp_method #foreign imgui "_ZN16ImGuiListClipper4StepEv";

    IncludeItemsByIndex :: (this: *ListClipper, item_begin: s32, item_end: s32) -> void #cpp_method #foreign imgui "_ZN16ImGuiListClipper19IncludeItemsByIndexEii";
}

// Typically, 1 command = 1 GPU draw call (unless command is a callback)
// - VtxOffset: When 'io.BackendFlags & ImGuiBackendFlags_RendererHasVtxOffset' is enabled,
//   this fields allow us to render meshes larger than 64K vertices while keeping 16-bit indices.
//   Backends made for <1.71. will typically ignore the VtxOffset fields.
// - The ClipRect/TextureId/VtxOffset fields must be contiguous as we memcmp() them together (this is asserted for).
ImDrawCmd :: struct {
    ClipRect:         ImVec4; // 4*4  // Clipping rectangle (x1, y1, x2, y2). Subtract ImDrawData->DisplayPos to get clipping rectangle in "viewport" coordinates
    TextureId:        ImTextureID; // 4-8  // User-provided texture ID. Set by user in ImfontAtlas::SetTexID() for fonts or passed to Image*() functions. Ignore if never using images or multiple fonts atlas.
    VtxOffset:        u32; // 4    // Start offset in vertex buffer. ImGuiBackendFlags_RendererHasVtxOffset: always 0, otherwise may be >0 to support meshes larger than 64K vertices with 16-bit indices.
    IdxOffset:        u32; // 4    // Start offset in index buffer.
    ElemCount:        u32; // 4    // Number of indices (multiple of 3) to be rendered as triangles. Vertices are stored in the callee ImDrawList's vtx_buffer[] array, indices in idx_buffer[].
    UserCallback:     ImDrawCallback; // 4-8  // If != NULL, call the function instead of rendering the vertices. clip_rect and texture_id will be set normally.
    UserCallbackData: *void; // 4-8  // The draw callback code can access this.
}

ImDrawVert :: struct {
    pos: ImVec2;
    uv:  ImVec2;
    col: ImU32;
}

// [Internal] For use by ImDrawList
ImDrawCmdHeader :: struct {
    ClipRect:  ImVec4;
    TextureId: ImTextureID;
    VtxOffset: u32;
}

// Forward declarations
ImDrawChannel :: struct {
    _CmdBuffer: ImVector(ImDrawCmd);
    _IdxBuffer: ImVector(ImDrawIdx);
}

// Split/Merge functions are used to split the draw list into different layers which can be drawn into out of order.
// This is used by the Columns/Tables API, so items of each column can be batched together in a same draw call.
ImDrawListSplitter :: struct {
    _Current:  s32; // Current channel number (0)
    _Count:    s32; // Number of active channels (1+)
    _Channels: ImVector(ImDrawChannel); // Draw channels (not resized down so _Count might be < Channels.Size)

    ClearFreeMemory :: (this: *ImDrawListSplitter) -> void #cpp_method #foreign imgui "_ZN18ImDrawListSplitter15ClearFreeMemoryEv";
    Split :: (this: *ImDrawListSplitter, draw_list: *ImDrawList, count: s32) -> void #cpp_method #foreign imgui "_ZN18ImDrawListSplitter5SplitEP10ImDrawListi";
    Merge :: (this: *ImDrawListSplitter, draw_list: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN18ImDrawListSplitter5MergeEP10ImDrawList";
    SetCurrentChannel :: (this: *ImDrawListSplitter, draw_list: *ImDrawList, channel_idx: s32) -> void #cpp_method #foreign imgui "_ZN18ImDrawListSplitter17SetCurrentChannelEP10ImDrawListi";
}

// Flags for ImDrawList functions
// (Legacy: bit 0 must always correspond to ImDrawFlags_Closed to be backward compatible with old API using a bool. Bits 1..3 must be unused)
ImDrawFlags :: enum_flags u32 {
    None                    :: 0x0;
    Closed                  :: 0x1;
    RoundCornersTopLeft     :: 0x10;
    RoundCornersTopRight    :: 0x20;
    RoundCornersBottomLeft  :: 0x40;
    RoundCornersBottomRight :: 0x80;
    RoundCornersNone        :: 0x100;
    RoundCornersTop         :: 0x30;
    RoundCornersBottom      :: 0xc0;
    RoundCornersLeft        :: 0x50;
    RoundCornersRight       :: 0xa0;
    RoundCornersAll         :: 0xf0;
    RoundCornersDefault_    :: 0xf0;
    RoundCornersMask_       :: 0x1f0;

    ImDrawFlags_None                    :: None;
    ImDrawFlags_Closed                  :: Closed;
    ImDrawFlags_RoundCornersTopLeft     :: RoundCornersTopLeft;
    ImDrawFlags_RoundCornersTopRight    :: RoundCornersTopRight;
    ImDrawFlags_RoundCornersBottomLeft  :: RoundCornersBottomLeft;
    ImDrawFlags_RoundCornersBottomRight :: RoundCornersBottomRight;
    ImDrawFlags_RoundCornersNone        :: RoundCornersNone;
    ImDrawFlags_RoundCornersTop         :: RoundCornersTop;
    ImDrawFlags_RoundCornersBottom      :: RoundCornersBottom;
    ImDrawFlags_RoundCornersLeft        :: RoundCornersLeft;
    ImDrawFlags_RoundCornersRight       :: RoundCornersRight;
    ImDrawFlags_RoundCornersAll         :: RoundCornersAll;
    ImDrawFlags_RoundCornersDefault_    :: RoundCornersDefault_;
    ImDrawFlags_RoundCornersMask_       :: RoundCornersMask_;
}

// Flags for ImDrawList instance. Those are set automatically by ImGui:: functions from ImGuiIO settings, and generally not manipulated directly.
// It is however possible to temporarily alter flags between calls to ImDrawList:: functions.
ImDrawListFlags :: enum_flags u32 {
    None                   :: 0x0;
    AntiAliasedLines       :: 0x1;
    AntiAliasedLinesUseTex :: 0x2;
    AntiAliasedFill        :: 0x4;
    AllowVtxOffset         :: 0x8;

    ImDrawListFlags_None                   :: None;
    ImDrawListFlags_AntiAliasedLines       :: AntiAliasedLines;
    ImDrawListFlags_AntiAliasedLinesUseTex :: AntiAliasedLinesUseTex;
    ImDrawListFlags_AntiAliasedFill        :: AntiAliasedFill;
    ImDrawListFlags_AllowVtxOffset         :: AllowVtxOffset;
}

// Draw command list
// This is the low-level list of polygons that ImGui:: functions are filling. At the end of the frame,
// all command lists are passed to your ImGuiIO::RenderDrawListFn function for rendering.
// Each dear imgui window contains its own ImDrawList. You can use ImGui::GetWindowDrawList() to
// access the current window draw list and draw custom primitives.
// You can interleave normal ImGui:: calls and adding primitives to the current draw list.
// In single viewport mode, top-left is == GetMainViewport()->Pos (generally 0,0), bottom-right is == GetMainViewport()->Pos+Size (generally io.DisplaySize).
// You are totally free to apply whatever transformation matrix to want to the data (depending on the use of the transformation you may want to apply it to ClipRect as well!)
// Important: Primitives are always added to the list and not culled (culling is done at higher-level by ImGui:: functions), if you use this API a lot consider coarse culling your drawn objects.
ImDrawList :: struct {
    CmdBuffer:       ImVector(ImDrawCmd); // Draw commands. Typically 1 command = 1 GPU draw call, unless the command is a callback.
    IdxBuffer:       ImVector(ImDrawIdx); // Index buffer. Each command consume ImDrawCmd::ElemCount of those
    VtxBuffer:       ImVector(ImDrawVert); // Vertex buffer.
    Flags:           ImDrawListFlags; // Flags, you may poke into these to adjust anti-aliasing settings per-primitive.

    _VtxCurrentIdx:  u32; // [Internal] generally == VtxBuffer.Size unless we are past 64K vertices, in which case this gets reset to 0.
    _Data:           *ImDrawListSharedData; // Pointer to shared draw data (you can use ImGui::GetDrawListSharedData() to get the one from current ImGui context)
    _OwnerName:      *u8; // Pointer to owner window's name for debugging
    _VtxWritePtr:    *ImDrawVert; // [Internal] point within VtxBuffer.Data after each add command (to avoid using the ImVector<> operators too much)
    _IdxWritePtr:    *ImDrawIdx; // [Internal] point within IdxBuffer.Data after each add command (to avoid using the ImVector<> operators too much)
    _ClipRectStack:  ImVector(ImVec4); // [Internal]
    _TextureIdStack: ImVector(ImTextureID); // [Internal]
    _Path:           ImVector(ImVec2); // [Internal] current path building
    _CmdHeader:      ImDrawCmdHeader; // [Internal] template of active commands. Fields should match those of CmdBuffer.back().
    _Splitter:       ImDrawListSplitter; // [Internal] for channels api (note: prefer using your own persistent instance of ImDrawListSplitter!)
    _FringeScale:    float; // [Internal] anti-alias fringe is scaled by this value, this helps to keep things sharp while zooming at vertex buffer content

    PushClipRect :: (this: *ImDrawList, clip_rect_min: *ImVec2, clip_rect_max: *ImVec2, intersect_with_current_clip_rect := false) -> void #cpp_method #foreign imgui "_ZN10ImDrawList12PushClipRectERK6ImVec2S2_b";
    PushClipRect :: (this: *ImDrawList, clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect := false) #no_context {
        PushClipRect(this, *clip_rect_min, *clip_rect_max, intersect_with_current_clip_rect);
    }
    PushClipRectFullScreen :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN10ImDrawList22PushClipRectFullScreenEv";
    PopClipRect :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN10ImDrawList11PopClipRectEv";
    PushTextureID :: (this: *ImDrawList, texture_id: ImTextureID) -> void #cpp_method #foreign imgui "_ZN10ImDrawList13PushTextureIDEPv";
    PopTextureID :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN10ImDrawList12PopTextureIDEv";

    // Primitives
    // - Filled shapes must always use clockwise winding order. The anti-aliasing fringe depends on it. Counter-clockwise shapes will have "inward" anti-aliasing.
    // - For rectangular primitives, "p_min" and "p_max" represent the upper-left and lower-right corners.
    // - For circle primitives, use "num_segments == 0" to automatically calculate tessellation (preferred).
    //   In older versions (until Dear ImGui 1.77) the AddCircle functions defaulted to num_segments == 12.
    //   In future versions we will use textures to provide cheaper and higher-quality circles.
    //   Use AddNgon() and AddNgonFilled() functions if you need to guarantee a specific number of sides.
    AddLine :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, col: ImU32, thickness: float = 1.0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList7AddLineERK6ImVec2S2_jf";
    AddLine :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, col: ImU32, thickness: float = 1.0) #no_context {
        AddLine(this, *p1, *p2, col, thickness);
    }
    AddRect :: (this: *ImDrawList, p_min: *ImVec2, p_max: *ImVec2, col: ImU32, rounding: float = 0.0, flags: ImDrawFlags = .None, thickness: float = 1.0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList7AddRectERK6ImVec2S2_jfif";
    AddRect :: (this: *ImDrawList, p_min: ImVec2, p_max: ImVec2, col: ImU32, rounding: float = 0.0, flags: ImDrawFlags = .None, thickness: float = 1.0) #no_context {
        AddRect(this, *p_min, *p_max, col, rounding, flags, thickness);
    }
    AddRectFilled :: (this: *ImDrawList, p_min: *ImVec2, p_max: *ImVec2, col: ImU32, rounding: float = 0.0, flags: ImDrawFlags = .None) -> void #cpp_method #foreign imgui "_ZN10ImDrawList13AddRectFilledERK6ImVec2S2_jfi";
    AddRectFilled :: (this: *ImDrawList, p_min: ImVec2, p_max: ImVec2, col: ImU32, rounding: float = 0.0, flags: ImDrawFlags = .None) #no_context {
        AddRectFilled(this, *p_min, *p_max, col, rounding, flags);
    }
    AddRectFilledMultiColor :: (this: *ImDrawList, p_min: *ImVec2, p_max: *ImVec2, col_upr_left: ImU32, col_upr_right: ImU32, col_bot_right: ImU32, col_bot_left: ImU32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList23AddRectFilledMultiColorERK6ImVec2S2_jjjj";
    AddRectFilledMultiColor :: (this: *ImDrawList, p_min: ImVec2, p_max: ImVec2, col_upr_left: ImU32, col_upr_right: ImU32, col_bot_right: ImU32, col_bot_left: ImU32) #no_context {
        AddRectFilledMultiColor(this, *p_min, *p_max, col_upr_left, col_upr_right, col_bot_right, col_bot_left);
    }
    AddQuad :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, col: ImU32, thickness: float = 1.0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList7AddQuadERK6ImVec2S2_S2_S2_jf";
    AddQuad :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32, thickness: float = 1.0) #no_context {
        AddQuad(this, *p1, *p2, *p3, *p4, col, thickness);
    }
    AddQuadFilled :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, col: ImU32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList13AddQuadFilledERK6ImVec2S2_S2_S2_j";
    AddQuadFilled :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32) #no_context {
        AddQuadFilled(this, *p1, *p2, *p3, *p4, col);
    }
    AddTriangle :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, col: ImU32, thickness: float = 1.0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList11AddTriangleERK6ImVec2S2_S2_jf";
    AddTriangle :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32, thickness: float = 1.0) #no_context {
        AddTriangle(this, *p1, *p2, *p3, col, thickness);
    }
    AddTriangleFilled :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, col: ImU32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList17AddTriangleFilledERK6ImVec2S2_S2_j";
    AddTriangleFilled :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32) #no_context {
        AddTriangleFilled(this, *p1, *p2, *p3, col);
    }
    AddCircle :: (this: *ImDrawList, center: *ImVec2, radius: float, col: ImU32, num_segments: s32 = 0, thickness: float = 1.0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList9AddCircleERK6ImVec2fjif";
    AddCircle :: (this: *ImDrawList, center: ImVec2, radius: float, col: ImU32, num_segments: s32 = 0, thickness: float = 1.0) #no_context {
        AddCircle(this, *center, radius, col, num_segments, thickness);
    }
    AddCircleFilled :: (this: *ImDrawList, center: *ImVec2, radius: float, col: ImU32, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList15AddCircleFilledERK6ImVec2fji";
    AddCircleFilled :: (this: *ImDrawList, center: ImVec2, radius: float, col: ImU32, num_segments: s32 = 0) #no_context {
        AddCircleFilled(this, *center, radius, col, num_segments);
    }
    AddNgon :: (this: *ImDrawList, center: *ImVec2, radius: float, col: ImU32, num_segments: s32, thickness: float = 1.0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList7AddNgonERK6ImVec2fjif";
    AddNgon :: (this: *ImDrawList, center: ImVec2, radius: float, col: ImU32, num_segments: s32, thickness: float = 1.0) #no_context {
        AddNgon(this, *center, radius, col, num_segments, thickness);
    }
    AddNgonFilled :: (this: *ImDrawList, center: *ImVec2, radius: float, col: ImU32, num_segments: s32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList13AddNgonFilledERK6ImVec2fji";
    AddNgonFilled :: (this: *ImDrawList, center: ImVec2, radius: float, col: ImU32, num_segments: s32) #no_context {
        AddNgonFilled(this, *center, radius, col, num_segments);
    }
    AddEllipse :: (this: *ImDrawList, center: *ImVec2, radius_x: float, radius_y: float, col: ImU32, rot: float = 0.0, num_segments: s32 = 0, thickness: float = 1.0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList10AddEllipseERK6ImVec2ffjfif";
    AddEllipse :: (this: *ImDrawList, center: ImVec2, radius_x: float, radius_y: float, col: ImU32, rot: float = 0.0, num_segments: s32 = 0, thickness: float = 1.0) #no_context {
        AddEllipse(this, *center, radius_x, radius_y, col, rot, num_segments, thickness);
    }
    AddEllipseFilled :: (this: *ImDrawList, center: *ImVec2, radius_x: float, radius_y: float, col: ImU32, rot: float = 0.0, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList16AddEllipseFilledERK6ImVec2ffjfi";
    AddEllipseFilled :: (this: *ImDrawList, center: ImVec2, radius_x: float, radius_y: float, col: ImU32, rot: float = 0.0, num_segments: s32 = 0) #no_context {
        AddEllipseFilled(this, *center, radius_x, radius_y, col, rot, num_segments);
    }
    AddText :: (this: *ImDrawList, pos: *ImVec2, col: ImU32, text_begin: *u8, text_end: *u8 = null) -> void #cpp_method #foreign imgui "_ZN10ImDrawList7AddTextERK6ImVec2jPKcS4_";
    AddText :: (this: *ImDrawList, pos: ImVec2, col: ImU32, text: string) #no_context {
        AddText(this, *pos, col, text.data, text.data + text.count);
    }
    AddText :: (this: *ImDrawList, font: *ImFont, font_size: float, pos: *ImVec2, col: ImU32, text_begin: *u8, text_end: *u8 = null, wrap_width: float = 0.0, cpu_fine_clip_rect: *ImVec4 = null) -> void #cpp_method #foreign imgui "_ZN10ImDrawList7AddTextEPK6ImFontfRK6ImVec2jPKcS7_fPK6ImVec4";
    AddText :: (this: *ImDrawList, font: *ImFont, font_size: float, pos: ImVec2, col: ImU32, text: string, wrap_width: float = 0.0, cpu_fine_clip_rect: *ImVec4 = null) #no_context {
        AddText(this, font, font_size, *pos, col, text.data, text.data + text.count, wrap_width, cpu_fine_clip_rect);
    }
    AddPolyline :: (this: *ImDrawList, points: *ImVec2, num_points: s32, col: ImU32, flags: ImDrawFlags, thickness: float) -> void #cpp_method #foreign imgui "_ZN10ImDrawList11AddPolylineEPK6ImVec2ijif";
    AddConvexPolyFilled :: (this: *ImDrawList, points: *ImVec2, num_points: s32, col: ImU32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList19AddConvexPolyFilledEPK6ImVec2ij";
    AddBezierCubic :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, col: ImU32, thickness: float, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList14AddBezierCubicERK6ImVec2S2_S2_S2_jfi";
    AddBezierCubic :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32, thickness: float, num_segments: s32 = 0) #no_context {
        AddBezierCubic(this, *p1, *p2, *p3, *p4, col, thickness, num_segments);
    }
    AddBezierQuadratic :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, col: ImU32, thickness: float, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList18AddBezierQuadraticERK6ImVec2S2_S2_jfi";
    AddBezierQuadratic :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32, thickness: float, num_segments: s32 = 0) #no_context {
        AddBezierQuadratic(this, *p1, *p2, *p3, col, thickness, num_segments);
    }

    // Image primitives
    // - Read FAQ to understand what ImTextureID is.
    // - "p_min" and "p_max" represent the upper-left and lower-right corners of the rectangle.
    // - "uv_min" and "uv_max" represent the normalized texture coordinates to use for those corners. Using (0,0)->(1,1) texture coordinates will generally display the entire texture.
    AddImage :: (this: *ImDrawList, user_texture_id: ImTextureID, p_min: *ImVec2, p_max: *ImVec2, uv_min: *ImVec2, uv_max: *ImVec2, col: ImU32 = 4294967295) -> void #cpp_method #foreign imgui "_ZN10ImDrawList8AddImageEPvRK6ImVec2S3_S3_S3_j";
    AddImage :: (this: *ImDrawList, user_texture_id: ImTextureID, p_min: ImVec2, p_max: ImVec2, uv_min: ImVec2 = ImVec2.{0, 0}, uv_max: ImVec2 = ImVec2.{1, 1}, col: ImU32 = 4294967295) #no_context {
        AddImage(this, user_texture_id, *p_min, *p_max, *uv_min, *uv_max, col);
    }
    AddImageQuad :: (this: *ImDrawList, user_texture_id: ImTextureID, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, uv1: *ImVec2, uv2: *ImVec2, uv3: *ImVec2, uv4: *ImVec2, col: ImU32 = 4294967295) -> void #cpp_method #foreign imgui "_ZN10ImDrawList12AddImageQuadEPvRK6ImVec2S3_S3_S3_S3_S3_S3_S3_j";
    AddImageQuad :: (this: *ImDrawList, user_texture_id: ImTextureID, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, uv1: ImVec2 = ImVec2.{0, 0}, uv2: ImVec2 = ImVec2.{1, 0}, uv3: ImVec2 = ImVec2.{1, 1}, uv4: ImVec2 = ImVec2.{0, 1}, col: ImU32 = 4294967295) #no_context {
        AddImageQuad(this, user_texture_id, *p1, *p2, *p3, *p4, *uv1, *uv2, *uv3, *uv4, col);
    }
    AddImageRounded :: (this: *ImDrawList, user_texture_id: ImTextureID, p_min: *ImVec2, p_max: *ImVec2, uv_min: *ImVec2, uv_max: *ImVec2, col: ImU32, rounding: float, flags: ImDrawFlags = .None) -> void #cpp_method #foreign imgui "_ZN10ImDrawList15AddImageRoundedEPvRK6ImVec2S3_S3_S3_jfi";
    AddImageRounded :: (this: *ImDrawList, user_texture_id: ImTextureID, p_min: ImVec2, p_max: ImVec2, uv_min: ImVec2, uv_max: ImVec2, col: ImU32, rounding: float, flags: ImDrawFlags = .None) #no_context {
        AddImageRounded(this, user_texture_id, *p_min, *p_max, *uv_min, *uv_max, col, rounding, flags);
    }

    PathArcTo :: (this: *ImDrawList, center: *ImVec2, radius: float, a_min: float, a_max: float, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList9PathArcToERK6ImVec2fffi";
    PathArcTo :: (this: *ImDrawList, center: ImVec2, radius: float, a_min: float, a_max: float, num_segments: s32 = 0) #no_context {
        PathArcTo(this, *center, radius, a_min, a_max, num_segments);
    }
    PathArcToFast :: (this: *ImDrawList, center: *ImVec2, radius: float, a_min_of_12: s32, a_max_of_12: s32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList13PathArcToFastERK6ImVec2fii";
    PathArcToFast :: (this: *ImDrawList, center: ImVec2, radius: float, a_min_of_12: s32, a_max_of_12: s32) #no_context {
        PathArcToFast(this, *center, radius, a_min_of_12, a_max_of_12);
    }
    PathEllipticalArcTo :: (this: *ImDrawList, center: *ImVec2, radius_x: float, radius_y: float, rot: float, a_min: float, a_max: float, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList19PathEllipticalArcToERK6ImVec2fffffi";
    PathEllipticalArcTo :: (this: *ImDrawList, center: ImVec2, radius_x: float, radius_y: float, rot: float, a_min: float, a_max: float, num_segments: s32 = 0) #no_context {
        PathEllipticalArcTo(this, *center, radius_x, radius_y, rot, a_min, a_max, num_segments);
    }
    PathBezierCubicCurveTo :: (this: *ImDrawList, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList22PathBezierCubicCurveToERK6ImVec2S2_S2_i";
    PathBezierCubicCurveTo :: (this: *ImDrawList, p2: ImVec2, p3: ImVec2, p4: ImVec2, num_segments: s32 = 0) #no_context {
        PathBezierCubicCurveTo(this, *p2, *p3, *p4, num_segments);
    }
    PathBezierQuadraticCurveTo :: (this: *ImDrawList, p2: *ImVec2, p3: *ImVec2, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "_ZN10ImDrawList26PathBezierQuadraticCurveToERK6ImVec2S2_i";
    PathBezierQuadraticCurveTo :: (this: *ImDrawList, p2: ImVec2, p3: ImVec2, num_segments: s32 = 0) #no_context {
        PathBezierQuadraticCurveTo(this, *p2, *p3, num_segments);
    }
    PathRect :: (this: *ImDrawList, rect_min: *ImVec2, rect_max: *ImVec2, rounding: float = 0.0, flags: ImDrawFlags = .None) -> void #cpp_method #foreign imgui "_ZN10ImDrawList8PathRectERK6ImVec2S2_fi";
    PathRect :: (this: *ImDrawList, rect_min: ImVec2, rect_max: ImVec2, rounding: float = 0.0, flags: ImDrawFlags = .None) #no_context {
        PathRect(this, *rect_min, *rect_max, rounding, flags);
    }

    // Advanced
    AddCallback :: (this: *ImDrawList, callback: ImDrawCallback, callback_data: *void) -> void #cpp_method #foreign imgui "_ZN10ImDrawList11AddCallbackEPFvPKS_PK9ImDrawCmdEPv";
    AddDrawCmd :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN10ImDrawList10AddDrawCmdEv";
    CloneOutput :: (this: *ImDrawList) -> *ImDrawList #cpp_method #foreign imgui "_ZNK10ImDrawList11CloneOutputEv";

    // Advanced: Primitives allocations
    // - We render triangles (three vertices)
    // - All primitives needs to be reserved via PrimReserve() beforehand.
    PrimReserve :: (this: *ImDrawList, idx_count: s32, vtx_count: s32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList11PrimReserveEii";
    PrimUnreserve :: (this: *ImDrawList, idx_count: s32, vtx_count: s32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList13PrimUnreserveEii";
    PrimRect :: (this: *ImDrawList, a: *ImVec2, b: *ImVec2, col: ImU32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList8PrimRectERK6ImVec2S2_j";
    PrimRect :: (this: *ImDrawList, a: ImVec2, b: ImVec2, col: ImU32) #no_context {
        PrimRect(this, *a, *b, col);
    }
    PrimRectUV :: (this: *ImDrawList, a: *ImVec2, b: *ImVec2, uv_a: *ImVec2, uv_b: *ImVec2, col: ImU32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList10PrimRectUVERK6ImVec2S2_S2_S2_j";
    PrimRectUV :: (this: *ImDrawList, a: ImVec2, b: ImVec2, uv_a: ImVec2, uv_b: ImVec2, col: ImU32) #no_context {
        PrimRectUV(this, *a, *b, *uv_a, *uv_b, col);
    }
    PrimQuadUV :: (this: *ImDrawList, a: *ImVec2, b: *ImVec2, c: *ImVec2, d: *ImVec2, uv_a: *ImVec2, uv_b: *ImVec2, uv_c: *ImVec2, uv_d: *ImVec2, col: ImU32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList10PrimQuadUVERK6ImVec2S2_S2_S2_S2_S2_S2_S2_j";
    PrimQuadUV :: (this: *ImDrawList, a: ImVec2, b: ImVec2, c: ImVec2, d: ImVec2, uv_a: ImVec2, uv_b: ImVec2, uv_c: ImVec2, uv_d: ImVec2, col: ImU32) #no_context {
        PrimQuadUV(this, *a, *b, *c, *d, *uv_a, *uv_b, *uv_c, *uv_d, col);
    }

    // [Internal helpers]
    _ResetForNewFrame :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN10ImDrawList17_ResetForNewFrameEv";
    _ClearFreeMemory :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN10ImDrawList16_ClearFreeMemoryEv";
    _PopUnusedDrawCmd :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN10ImDrawList17_PopUnusedDrawCmdEv";
    _TryMergeDrawCmds :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN10ImDrawList17_TryMergeDrawCmdsEv";
    _OnChangedClipRect :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN10ImDrawList18_OnChangedClipRectEv";
    _OnChangedTextureID :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN10ImDrawList19_OnChangedTextureIDEv";
    _OnChangedVtxOffset :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN10ImDrawList19_OnChangedVtxOffsetEv";
    _CalcCircleAutoSegmentCount :: (this: *ImDrawList, radius: float) -> s32 #cpp_method #foreign imgui "_ZNK10ImDrawList27_CalcCircleAutoSegmentCountEf";
    _PathArcToFastEx :: (this: *ImDrawList, center: *ImVec2, radius: float, a_min_sample: s32, a_max_sample: s32, a_step: s32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList16_PathArcToFastExERK6ImVec2fiii";
    _PathArcToFastEx :: (this: *ImDrawList, center: ImVec2, radius: float, a_min_sample: s32, a_max_sample: s32, a_step: s32) #no_context {
        _PathArcToFastEx(this, *center, radius, a_min_sample, a_max_sample, a_step);
    }
    _PathArcToN :: (this: *ImDrawList, center: *ImVec2, radius: float, a_min: float, a_max: float, num_segments: s32) -> void #cpp_method #foreign imgui "_ZN10ImDrawList11_PathArcToNERK6ImVec2fffi";
    _PathArcToN :: (this: *ImDrawList, center: ImVec2, radius: float, a_min: float, a_max: float, num_segments: s32) #no_context {
        _PathArcToN(this, *center, radius, a_min, a_max, num_segments);
    }
}

// All draw data to render a Dear ImGui frame
// (NB: the style and the naming convention here is a little inconsistent, we currently preserve them for backward compatibility purpose,
// as this is one of the oldest structure exposed by the library! Basically, ImDrawList == CmdList)
ImDrawData :: struct {
    Valid:            bool; // Only valid after Render() is called and before the next NewFrame() is called.
    CmdListsCount:    s32; // Number of ImDrawList* to render
    TotalIdxCount:    s32; // For convenience, sum of all ImDrawList's IdxBuffer.Size
    TotalVtxCount:    s32; // For convenience, sum of all ImDrawList's VtxBuffer.Size
    CmdLists:         ImVector(*ImDrawList); // Array of ImDrawList* to render. The ImDrawLists are owned by ImGuiContext and only pointed to from here.
    DisplayPos:       ImVec2; // Top-left position of the viewport to render (== top-left of the orthogonal projection matrix to use) (== GetMainViewport()->Pos for the main viewport, == (0.0) in most single-viewport applications)
    DisplaySize:      ImVec2; // Size of the viewport to render (== GetMainViewport()->Size for the main viewport, == io.DisplaySize in most single-viewport applications)
    FramebufferScale: ImVec2; // Amount of pixels for each unit of DisplaySize. Based on io.DisplayFramebufferScale. Generally (1,1) on normal display, (2,2) on OSX with Retina display.
    OwnerViewport:    *Viewport; // Viewport carrying the ImDrawData instance, might be of use to the renderer (generally not).

    Clear :: (this: *ImDrawData) -> void #cpp_method #foreign imgui "_ZN10ImDrawData5ClearEv";
    AddDrawList :: (this: *ImDrawData, draw_list: *ImDrawList) -> void #cpp_method #foreign imgui "_ZN10ImDrawData11AddDrawListEP10ImDrawList";
    DeIndexAllBuffers :: (this: *ImDrawData) -> void #cpp_method #foreign imgui "_ZN10ImDrawData17DeIndexAllBuffersEv";
    ScaleClipRects :: (this: *ImDrawData, fb_scale: *ImVec2) -> void #cpp_method #foreign imgui "_ZN10ImDrawData14ScaleClipRectsERK6ImVec2";
    ScaleClipRects :: (this: *ImDrawData, fb_scale: ImVec2) #no_context {
        ScaleClipRects(this, *fb_scale);
    }
}

//-----------------------------------------------------------------------------
// [SECTION] Font API (ImFontConfig, ImFontGlyph, ImFontAtlasFlags, ImFontAtlas, ImFontGlyphRangesBuilder, ImFont)
//-----------------------------------------------------------------------------
ImFontConfig :: struct {
    FontData:             *void; //          // TTF/OTF data
    FontDataSize:         s32; //          // TTF/OTF data size
    FontDataOwnedByAtlas: bool; // true     // TTF/OTF data ownership taken by the container ImFontAtlas (will delete memory itself).
    FontNo:               s32; // 0        // Index of font within TTF/OTF file
    SizePixels:           float; //          // Size in pixels for rasterizer (more or less maps to the resulting font height).
    OversampleH:          s32; // 2        // Rasterize at higher quality for sub-pixel positioning. Note the difference between 2 and 3 is minimal. You can reduce this to 1 for large glyphs save memory. Read https://github.com/nothings/stb/blob/master/tests/oversample/README.md for details.
    OversampleV:          s32; // 1        // Rasterize at higher quality for sub-pixel positioning. This is not really useful as we don't use sub-pixel positions on the Y axis.
    PixelSnapH:           bool; // false    // Align every glyph to pixel boundary. Useful e.g. if you are merging a non-pixel aligned font with the default font. If enabled, you can set OversampleH/V to 1.
    GlyphExtraSpacing:    ImVec2; // 0, 0     // Extra spacing (in pixels) between glyphs. Only X axis is supported for now.
    GlyphOffset:          ImVec2; // 0, 0     // Offset all glyphs from this font input.
    GlyphRanges:          *ImWchar; // NULL     // THE ARRAY DATA NEEDS TO PERSIST AS LONG AS THE FONT IS ALIVE. Pointer to a user-provided list of Unicode range (2 value per range, values are inclusive, zero-terminated list).
    GlyphMinAdvanceX:     float; // 0        // Minimum AdvanceX for glyphs, set Min to align font icons, set both Min/Max to enforce mono-space font
    GlyphMaxAdvanceX:     float; // FLT_MAX  // Maximum AdvanceX for glyphs
    MergeMode:            bool; // false    // Merge into previous ImFont, so you can combine multiple inputs font into one ImFont (e.g. ASCII font + icons + Japanese glyphs). You may want to use GlyphOffset.y when merge font of different heights.
    FontBuilderFlags:     u32; // 0        // Settings for custom font builder. THIS IS BUILDER IMPLEMENTATION DEPENDENT. Leave as zero if unsure.
    RasterizerMultiply:   float; // 1.0f     // Linearly brighten (>1.0f) or darken (<1.0f) font output. Brightening small fonts may be a good workaround to make them more readable. This is a silly thing we may remove in the future.
    RasterizerDensity:    float; // 1.0f     // DPI scale for rasterization, not altering other font metrics: make it easy to swap between e.g. a 100% and a 400% fonts for a zooming display. IMPORTANT: If you increase this it is expected that you increase font scale accordingly, otherwise quality may look lowered.
    EllipsisChar:         ImWchar; // -1       // Explicitly specify unicode codepoint of ellipsis character. When fonts are being merged first specified ellipsis will be used.

    Name:                 [40] u8; // Name (strictly to ease debugging)
    DstFont:              *ImFont;

    Constructor :: (this: *ImFontConfig) -> void #cpp_method #foreign imgui "_ZN12ImFontConfigC1Ev";
}

// Hold rendering data for one glyph.
// (Note: some language parsers may fail to convert the 31+1 bitfield members, in this case maybe drop store a single u32 or we can rework this)
ImFontGlyph :: struct {
    __bitfield: u32;
    /* 
        Colored: u32; /* 1 bits */ // Flag to indicate glyph is colored and should generally ignore tinting (make it usable with no shift on little-endian as this is used in loops)
        Visible: u32; /* 1 bits */ // Flag to indicate glyph has no visible pixels (e.g. space). Allow early out when rendering.
        Codepoint: u32; /* 30 bits */ // 0x0000..0x10FFFF;
    */

    AdvanceX:   float; // Distance to next character (= data from font + ImFontConfig::GlyphExtraSpacing.x baked in)
    X0:         float; // Glyph corners
    Y0:         float; // Glyph corners
    X1:         float; // Glyph corners
    Y1:         float; // Glyph corners
    U0:         float; // Texture coordinates
    V0:         float; // Texture coordinates
    U1:         float; // Texture coordinates
    V1:         float; // Texture coordinates
}

// Helper to build glyph ranges from text/string data. Feed your application strings/characters to it then call BuildRanges().
// This is essentially a tightly packed of vector of 64k booleans = 8KB storage.
ImFontGlyphRangesBuilder :: struct {
    UsedChars: ImVector(ImU32); // Store 1-bit per Unicode code point (0=unused, 1=used)

    AddText :: (this: *ImFontGlyphRangesBuilder, text: *u8, text_end: *u8 = null) -> void #cpp_method #foreign imgui "_ZN24ImFontGlyphRangesBuilder7AddTextEPKcS1_";
    AddText :: (this: *ImFontGlyphRangesBuilder, text: string) #no_context {
        AddText(this, text.data, text.data + text.count);
    }
    AddRanges :: (this: *ImFontGlyphRangesBuilder, ranges: *ImWchar) -> void #cpp_method #foreign imgui "_ZN24ImFontGlyphRangesBuilder9AddRangesEPKj";
    BuildRanges :: (this: *ImFontGlyphRangesBuilder, out_ranges: *ImVector(ImWchar)) -> void #cpp_method #foreign imgui "_ZN24ImFontGlyphRangesBuilder11BuildRangesEP8ImVectorIjE";
}

// See ImFontAtlas::AddCustomRectXXX functions.
ImFontAtlasCustomRect :: struct {
    Width:         u16; // Input    // Desired rectangle dimension
    Height:        u16; // Input    // Desired rectangle dimension
    X:             u16; // Output   // Packed position in Atlas
    Y:             u16; // Output   // Packed position in Atlas
    GlyphID:       u32; // Input    // For custom font glyphs only (ID < 0x110000)
    GlyphAdvanceX: float; // Input    // For custom font glyphs only: glyph xadvance
    GlyphOffset:   ImVec2; // Input    // For custom font glyphs only: glyph display offset
    Font:          *ImFont; // Input    // For custom font glyphs only: target font
}

// Flags for ImFontAtlas build
ImFontAtlasFlags :: enum_flags u32 {
    None               :: 0x0;
    NoPowerOfTwoHeight :: 0x1;
    NoMouseCursors     :: 0x2;
    NoBakedLines       :: 0x4;

    ImFontAtlasFlags_None               :: None;
    ImFontAtlasFlags_NoPowerOfTwoHeight :: NoPowerOfTwoHeight;
    ImFontAtlasFlags_NoMouseCursors     :: NoMouseCursors;
    ImFontAtlasFlags_NoBakedLines       :: NoBakedLines;
}

// Load and rasterize multiple TTF/OTF fonts into a same texture. The font atlas will build a single texture holding:
//  - One or more fonts.
//  - Custom graphics data needed to render the shapes needed by Dear ImGui.
//  - Mouse cursor shapes for software cursor rendering (unless setting 'Flags |= ImFontAtlasFlags_NoMouseCursors' in the font atlas).
// It is the user-code responsibility to setup/build the atlas, then upload the pixel data into a texture accessible by your graphics api.
//  - Optionally, call any of the AddFont*** functions. If you don't call any, the default font embedded in the code will be loaded for you.
//  - Call GetTexDataAsAlpha8() or GetTexDataAsRGBA32() to build and retrieve pixels data.
//  - Upload the pixels data into a texture within your graphics system (see imgui_impl_xxxx.cpp examples)
//  - Call SetTexID(my_tex_id); and pass the pointer/identifier to your texture in a format natural to your graphics API.
//    This value will be passed back to you during rendering to identify the texture. Read FAQ entry about ImTextureID for more details.
// Common pitfalls:
// - If you pass a 'glyph_ranges' array to AddFont*** functions, you need to make sure that your array persist up until the
//   atlas is build (when calling GetTexData*** or Build()). We only copy the pointer, not the data.
// - Important: By default, AddFontFromMemoryTTF() takes ownership of the data. Even though we are not writing to it, we will free the pointer on destruction.
//   You can set font_cfg->FontDataOwnedByAtlas=false to keep ownership of your data and it won't be freed,
// - Even though many functions are suffixed with "TTF", OTF data is supported just as well.
// - This is an old API and it is currently awkward for those and various other reasons! We will address them in the future!
ImFontAtlas :: struct {
    Constructor :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "_ZN11ImFontAtlasC1Ev";
    Destructor_Base :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "_ZN11ImFontAtlasD2Ev";
    Destructor :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "_ZN11ImFontAtlasD1Ev";
    AddFont :: (this: *ImFontAtlas, font_cfg: *ImFontConfig) -> *ImFont #cpp_method #foreign imgui "_ZN11ImFontAtlas7AddFontEPK12ImFontConfig";
    AddFontDefault :: (this: *ImFontAtlas, font_cfg: *ImFontConfig = null) -> *ImFont #cpp_method #foreign imgui "_ZN11ImFontAtlas14AddFontDefaultEPK12ImFontConfig";
    AddFontFromFileTTF :: (this: *ImFontAtlas, filename: *u8, size_pixels: float, font_cfg: *ImFontConfig = null, glyph_ranges: *ImWchar = null) -> *ImFont #cpp_method #foreign imgui "_ZN11ImFontAtlas18AddFontFromFileTTFEPKcfPK12ImFontConfigPKj";
    AddFontFromMemoryTTF :: (this: *ImFontAtlas, font_data: *void, font_data_size: s32, size_pixels: float, font_cfg: *ImFontConfig = null, glyph_ranges: *ImWchar = null) -> *ImFont #cpp_method #foreign imgui "_ZN11ImFontAtlas20AddFontFromMemoryTTFEPvifPK12ImFontConfigPKj";
    AddFontFromMemoryCompressedTTF :: (this: *ImFontAtlas, compressed_font_data: *void, compressed_font_data_size: s32, size_pixels: float, font_cfg: *ImFontConfig = null, glyph_ranges: *ImWchar = null) -> *ImFont #cpp_method #foreign imgui "_ZN11ImFontAtlas30AddFontFromMemoryCompressedTTFEPKvifPK12ImFontConfigPKj";
    AddFontFromMemoryCompressedBase85TTF :: (this: *ImFontAtlas, compressed_font_data_base85: *u8, size_pixels: float, font_cfg: *ImFontConfig = null, glyph_ranges: *ImWchar = null) -> *ImFont #cpp_method #foreign imgui "_ZN11ImFontAtlas36AddFontFromMemoryCompressedBase85TTFEPKcfPK12ImFontConfigPKj";
    ClearInputData :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "_ZN11ImFontAtlas14ClearInputDataEv";
    ClearTexData :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "_ZN11ImFontAtlas12ClearTexDataEv";
    ClearFonts :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "_ZN11ImFontAtlas10ClearFontsEv";
    Clear :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "_ZN11ImFontAtlas5ClearEv";

    // Build atlas, retrieve pixel data.
    // User is in charge of copying the pixels into graphics memory (e.g. create a texture with your engine). Then store your texture handle with SetTexID().
    // The pitch is always = Width * BytesPerPixels (1 or 4)
    // Building in RGBA32 format is provided for convenience and compatibility, but note that unless you manually manipulate or copy color data into
    // the texture (e.g. when using the AddCustomRect*** api), then the RGB pixels emitted will always be white (~75% of memory/bandwidth waste.
    Build :: (this: *ImFontAtlas) -> bool #cpp_method #foreign imgui "_ZN11ImFontAtlas5BuildEv";
    GetTexDataAsAlpha8 :: (this: *ImFontAtlas, out_pixels: **u8, out_width: *s32, out_height: *s32, out_bytes_per_pixel: *s32 = null) -> void #cpp_method #foreign imgui "_ZN11ImFontAtlas18GetTexDataAsAlpha8EPPhPiS2_S2_";
    GetTexDataAsRGBA32 :: (this: *ImFontAtlas, out_pixels: **u8, out_width: *s32, out_height: *s32, out_bytes_per_pixel: *s32 = null) -> void #cpp_method #foreign imgui "_ZN11ImFontAtlas18GetTexDataAsRGBA32EPPhPiS2_S2_";

    // Helpers to retrieve list of common Unicode ranges (2 value per range, values are inclusive, zero-terminated list)
    // NB: Make sure that your string are UTF-8 and NOT in your local code page.
    // Read https://github.com/ocornut/imgui/blob/master/docs/FONTS.md/#about-utf-8-encoding for details.
    // NB: Consider using ImFontGlyphRangesBuilder to build glyph ranges from textual data.
    GetGlyphRangesDefault :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "_ZN11ImFontAtlas21GetGlyphRangesDefaultEv";
    GetGlyphRangesGreek :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "_ZN11ImFontAtlas19GetGlyphRangesGreekEv";
    GetGlyphRangesKorean :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "_ZN11ImFontAtlas20GetGlyphRangesKoreanEv";
    GetGlyphRangesJapanese :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "_ZN11ImFontAtlas22GetGlyphRangesJapaneseEv";
    GetGlyphRangesChineseFull :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "_ZN11ImFontAtlas25GetGlyphRangesChineseFullEv";
    GetGlyphRangesChineseSimplifiedCommon :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "_ZN11ImFontAtlas37GetGlyphRangesChineseSimplifiedCommonEv";
    GetGlyphRangesCyrillic :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "_ZN11ImFontAtlas22GetGlyphRangesCyrillicEv";
    GetGlyphRangesThai :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "_ZN11ImFontAtlas18GetGlyphRangesThaiEv";
    GetGlyphRangesVietnamese :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "_ZN11ImFontAtlas24GetGlyphRangesVietnameseEv";

    // You can request arbitrary rectangles to be packed into the atlas, for your own purposes.
    // - After calling Build(), you can query the rectangle position and render your pixels.
    // - If you render colored output, set 'atlas->TexPixelsUseColors = true' as this may help some backends decide of prefered texture format.
    // - You can also request your rectangles to be mapped as font glyph (given a font + Unicode point),
    //   so you can render e.g. custom colorful icons and use them as regular glyphs.
    // - Read docs/FONTS.md for more details about using colorful icons.
    // - Note: this API may be redesigned later in order to support multi-monitor varying DPI settings.
    AddCustomRectRegular :: (this: *ImFontAtlas, width: s32, height: s32) -> s32 #cpp_method #foreign imgui "_ZN11ImFontAtlas20AddCustomRectRegularEii";
    AddCustomRectFontGlyph :: (this: *ImFontAtlas, font: *ImFont, id: ImWchar, width: s32, height: s32, advance_x: float, offset: *ImVec2) -> s32 #cpp_method #foreign imgui "_ZN11ImFontAtlas22AddCustomRectFontGlyphEP6ImFontjiifRK6ImVec2";
    AddCustomRectFontGlyph :: (this: *ImFontAtlas, font: *ImFont, id: ImWchar, width: s32, height: s32, advance_x: float, offset: ImVec2 = ImVec2.{0, 0}) -> s32 #no_context {
        return AddCustomRectFontGlyph(this, font, id, width, height, advance_x, *offset);
    }

    // [Internal]
    CalcCustomRectUV :: (this: *ImFontAtlas, rect: *ImFontAtlasCustomRect, out_uv_min: *ImVec2, out_uv_max: *ImVec2) -> void #cpp_method #foreign imgui "_ZNK11ImFontAtlas16CalcCustomRectUVEPK21ImFontAtlasCustomRectP6ImVec2S4_";
    GetMouseCursorTexData :: (this: *ImFontAtlas, cursor: MouseCursor, out_offset: *ImVec2, out_size: *ImVec2, out_uv_border: *[2] ImVec2, out_uv_fill: *[2] ImVec2) -> bool #cpp_method #foreign imgui "_ZN11ImFontAtlas21GetMouseCursorTexDataEiP6ImVec2S1_S1_S1_";

    Flags:              ImFontAtlasFlags; // Build flags (see ImFontAtlasFlags_)
    TexID:              ImTextureID; // User data to refer to the texture once it has been uploaded to user's graphic systems. It is passed back to you during rendering via the ImDrawCmd structure.
    TexDesiredWidth:    s32; // Texture width desired by user before Build(). Must be a power-of-two. If have many glyphs your graphics API have texture size restrictions you may want to increase texture width to decrease height.
    TexGlyphPadding:    s32; // Padding between glyphs within texture in pixels. Defaults to 1. If your rendering method doesn't rely on bilinear filtering you may set this to 0 (will also need to set AntiAliasedLinesUseTex = false).
    Locked:             bool; // Marked as Locked by ImGui::NewFrame() so attempt to modify the atlas will assert.
    UserData:           *void; // Store your own atlas related user-data (if e.g. you have multiple font atlas).

    TexReady:           bool; // Set when texture was built matching current font input
    TexPixelsUseColors: bool; // Tell whether our texture data is known to use colors (rather than just alpha channel), in order to help backend select a format.
    TexPixelsAlpha8:    *u8; // 1 component per pixel, each component is unsigned 8-bit. Total size = TexWidth * TexHeight
    TexPixelsRGBA32:    *u32; // 4 component per pixel, each component is unsigned 8-bit. Total size = TexWidth * TexHeight * 4
    TexWidth:           s32; // Texture width calculated during Build().
    TexHeight:          s32; // Texture height calculated during Build().
    TexUvScale:         ImVec2; // = (1.0f/TexWidth, 1.0f/TexHeight)
    TexUvWhitePixel:    ImVec2; // Texture coordinates to a white pixel
    Fonts:              ImVector(*ImFont); // Hold all the fonts returned by AddFont*. Fonts[0] is the default font upon calling ImGui::NewFrame(), use ImGui::PushFont()/PopFont() to change the current font.
    CustomRects:        ImVector(ImFontAtlasCustomRect); // Rectangles for packing custom texture data into the atlas.
    ConfigData:         ImVector(ImFontConfig); // Configuration data
    TexUvLines:         [64] ImVec4; // UVs for baked anti-aliased lines

    FontBuilderIO:      *ImFontBuilderIO; // Opaque interface to a font builder (default to stb_truetype, can be changed to use FreeType by defining IMGUI_ENABLE_FREETYPE).
    FontBuilderFlags:   u32; // Shared flags (for all fonts) for custom font builder. THIS IS BUILD IMPLEMENTATION DEPENDENT. Per-font override is also available in ImFontConfig.

    PackIdMouseCursors: s32; // Custom texture rectangle ID for white pixel and mouse cursors
    PackIdLines:        s32; // Custom texture rectangle ID for baked anti-aliased lines
}

// Font runtime data and rendering
// ImFontAtlas automatically loads a default embedded font for you when you call GetTexDataAsAlpha8() or GetTexDataAsRGBA32().
ImFont :: struct {
    IndexAdvanceX:       ImVector(float); // 12-16 // out //            // Sparse. Glyphs->AdvanceX in a directly indexable way (cache-friendly for CalcTextSize functions which only this this info, and are often bottleneck in large UI).
    FallbackAdvanceX:    float; // 4     // out // = FallbackGlyph->AdvanceX
    FontSize:            float; // 4     // in  //            // Height of characters/line, set during loading (don't change after loading)

    IndexLookup:         ImVector(ImWchar); // 12-16 // out //            // Sparse. Index glyphs by Unicode code-point.
    Glyphs:              ImVector(ImFontGlyph); // 12-16 // out //            // All glyphs.
    FallbackGlyph:       *ImFontGlyph; // 4-8   // out // = FindGlyph(FontFallbackChar)

    ContainerAtlas:      *ImFontAtlas; // 4-8   // out //            // What we has been loaded into
    ConfigData:          *ImFontConfig; // 4-8   // in  //            // Pointer within ContainerAtlas->ConfigData
    ConfigDataCount:     s16; // 2     // in  // ~ 1        // Number of ImFontConfig involved in creating this font. Bigger than 1 when merging multiple font sources into one ImFont.
    FallbackChar:        ImWchar; // 2     // out // = FFFD/'?' // Character used if a glyph isn't found.
    EllipsisChar:        ImWchar; // 2     // out // = '...'/'.'// Character used for ellipsis rendering.
    EllipsisCharCount:   s16; // 1     // out // 1 or 3
    EllipsisWidth:       float; // 4     // out               // Width
    EllipsisCharStep:    float; // 4     // out               // Step between characters when EllipsisCount > 0
    DirtyLookupTables:   bool; // 1     // out //
    Scale:               float; // 4     // in  // = 1.f      // Base font scale, multiplied by the per-window font scale which you can adjust with SetWindowFontScale()
    Ascent:              float; // 4+4   // out //            // Ascent: distance from top to bottom of e.g. 'A' [0..FontSize]
    Descent:             float; // 4+4   // out //            // Ascent: distance from top to bottom of e.g. 'A' [0..FontSize]
    MetricsTotalSurface: s32; // 4     // out //            // Total surface in pixels to get an idea of the font rasterization/texture cost (not exact, we approximate the cost of padding between glyphs)
    Used4kPagesMap:      [34] ImU8; // 2 bytes if ImWchar=ImWchar16, 34 bytes if ImWchar==ImWchar32. Store 1-bit for each block of 4K codepoints that has one active glyph. This is mainly used to facilitate iterations across all used codepoints.

    // Methods
    Constructor :: (this: *ImFont) -> void #cpp_method #foreign imgui "_ZN6ImFontC1Ev";
    Destructor_Base :: (this: *ImFont) -> void #cpp_method #foreign imgui "_ZN6ImFontD2Ev";
    Destructor :: (this: *ImFont) -> void #cpp_method #foreign imgui "_ZN6ImFontD1Ev";
    FindGlyph :: (this: *ImFont, c: ImWchar) -> *ImFontGlyph #cpp_method #foreign imgui "_ZNK6ImFont9FindGlyphEj";
    FindGlyphNoFallback :: (this: *ImFont, c: ImWchar) -> *ImFontGlyph #cpp_method #foreign imgui "_ZNK6ImFont19FindGlyphNoFallbackEj";

    // 'max_width' stops rendering after a certain width (could be turned into a 2d size). FLT_MAX to disable.
    // 'wrap_width' enable automatic word-wrapping across multiple lines to fit into given width. 0.0f to disable.
    CalcTextSizeA :: (this: *ImFont, size: float, max_width: float, wrap_width: float, text_begin: *u8, text_end: *u8 = null, remaining: **u8 = null) -> ImVec2 #cpp_method #foreign imgui "_ZNK6ImFont13CalcTextSizeAEfffPKcS1_PS1_";
    CalcTextSizeA :: (this: *ImFont, size: float, max_width: float, wrap_width: float, text: string, remaining: **u8 = null) -> ImVec2 #no_context {
        return CalcTextSizeA(this, size, max_width, wrap_width, text.data, text.data + text.count, remaining);
    }
    CalcWordWrapPositionA :: (this: *ImFont, scale: float, text: *u8, text_end: *u8, wrap_width: float) -> *u8 #cpp_method #foreign imgui "_ZNK6ImFont21CalcWordWrapPositionAEfPKcS1_f";
    CalcWordWrapPositionA :: (this: *ImFont, scale: float, text: string, wrap_width: float) -> *u8 #no_context {
        return CalcWordWrapPositionA(this, scale, text.data, text.data + text.count, wrap_width);
    }
    RenderChar :: (this: *ImFont, draw_list: *ImDrawList, size: float, pos: *ImVec2, col: ImU32, c: ImWchar) -> void #cpp_method #foreign imgui "_ZNK6ImFont10RenderCharEP10ImDrawListfRK6ImVec2jj";
    RenderChar :: (this: *ImFont, draw_list: *ImDrawList, size: float, pos: ImVec2, col: ImU32, c: ImWchar) #no_context {
        RenderChar(this, draw_list, size, *pos, col, c);
    }
    RenderText :: (this: *ImFont, draw_list: *ImDrawList, size: float, pos: *ImVec2, col: ImU32, clip_rect: *ImVec4, text_begin: *u8, text_end: *u8, wrap_width: float = 0.0, cpu_fine_clip := false) -> void #cpp_method #foreign imgui "_ZNK6ImFont10RenderTextEP10ImDrawListfRK6ImVec2jRK6ImVec4PKcS9_fb";
    RenderText :: (this: *ImFont, draw_list: *ImDrawList, size: float, pos: ImVec2, col: ImU32, clip_rect: ImVec4, text: string, wrap_width: float = 0.0, cpu_fine_clip := false) #no_context {
        RenderText(this, draw_list, size, *pos, col, *clip_rect, text.data, text.data + text.count, wrap_width, cpu_fine_clip);
    }

    // [Internal] Don't use!
    BuildLookupTable :: (this: *ImFont) -> void #cpp_method #foreign imgui "_ZN6ImFont16BuildLookupTableEv";
    ClearOutputData :: (this: *ImFont) -> void #cpp_method #foreign imgui "_ZN6ImFont15ClearOutputDataEv";
    GrowIndex :: (this: *ImFont, new_size: s32) -> void #cpp_method #foreign imgui "_ZN6ImFont9GrowIndexEi";
    AddGlyph :: (this: *ImFont, src_cfg: *ImFontConfig, c: ImWchar, x0: float, y0: float, x1: float, y1: float, u0: float, v0: float, u1: float, v1: float, advance_x: float) -> void #cpp_method #foreign imgui "_ZN6ImFont8AddGlyphEPK12ImFontConfigjfffffffff";
    AddRemapChar :: (this: *ImFont, dst: ImWchar, src: ImWchar, overwrite_dst := true) -> void #cpp_method #foreign imgui "_ZN6ImFont12AddRemapCharEjjb";
    SetGlyphVisible :: (this: *ImFont, c: ImWchar, visible: bool) -> void #cpp_method #foreign imgui "_ZN6ImFont15SetGlyphVisibleEjb";
    IsGlyphRangeUnused :: (this: *ImFont, c_begin: u32, c_last: u32) -> bool #cpp_method #foreign imgui "_ZN6ImFont18IsGlyphRangeUnusedEjj";
}

// Flags stored in ImGuiViewport::Flags, giving indications to the platform backends.
ViewportFlags :: enum_flags u32 {
    None                :: 0x0;
    IsPlatformWindow    :: 0x1;
    IsPlatformMonitor   :: 0x2;
    OwnedByApp          :: 0x4;
    NoDecoration        :: 0x8;
    NoTaskBarIcon       :: 0x10;
    NoFocusOnAppearing  :: 0x20;
    NoFocusOnClick      :: 0x40;
    NoInputs            :: 0x80;
    NoRendererClear     :: 0x100;
    NoAutoMerge         :: 0x200;
    TopMost             :: 0x400;
    CanHostOtherWindows :: 0x800;

    IsMinimized         :: 0x1000;
    IsFocused           :: 0x2000;

    ImGuiViewportFlags_None                :: None;
    ImGuiViewportFlags_IsPlatformWindow    :: IsPlatformWindow;
    ImGuiViewportFlags_IsPlatformMonitor   :: IsPlatformMonitor;
    ImGuiViewportFlags_OwnedByApp          :: OwnedByApp;
    ImGuiViewportFlags_NoDecoration        :: NoDecoration;
    ImGuiViewportFlags_NoTaskBarIcon       :: NoTaskBarIcon;
    ImGuiViewportFlags_NoFocusOnAppearing  :: NoFocusOnAppearing;
    ImGuiViewportFlags_NoFocusOnClick      :: NoFocusOnClick;
    ImGuiViewportFlags_NoInputs            :: NoInputs;
    ImGuiViewportFlags_NoRendererClear     :: NoRendererClear;
    ImGuiViewportFlags_NoAutoMerge         :: NoAutoMerge;
    ImGuiViewportFlags_TopMost             :: TopMost;
    ImGuiViewportFlags_CanHostOtherWindows :: CanHostOtherWindows;

    ImGuiViewportFlags_IsMinimized         :: IsMinimized;
    ImGuiViewportFlags_IsFocused           :: IsFocused;
}

// - Currently represents the Platform Window created by the application which is hosting our Dear ImGui windows.
// - With multi-viewport enabled, we extend this concept to have multiple active viewports.
// - In the future we will extend this concept further to also represent Platform Monitor and support a "no main platform window" operation mode.
// - About Main Area vs Work Area:
//   - Main Area = entire viewport.
//   - Work Area = entire viewport minus sections used by main menu bars (for platform windows), or by task bar (for platform monitor).
//   - Windows are generally trying to stay within the Work Area of their host viewport.
Viewport :: struct {
    ID_:                   ID; // Unique identifier for the viewport
    Flags:                 ViewportFlags; // See ImGuiViewportFlags_
    Pos:                   ImVec2; // Main Area: Position of the viewport (Dear ImGui coordinates are the same as OS desktop/native coordinates)
    Size:                  ImVec2; // Main Area: Size of the viewport.
    WorkPos:               ImVec2; // Work Area: Position of the viewport minus task bars, menus bars, status bars (>= Pos)
    WorkSize:              ImVec2; // Work Area: Size of the viewport minus task bars, menu bars, status bars (<= Size)
    DpiScale:              float; // 1.0f = 96 DPI = No extra scale.
    ParentViewportId:      ID; // (Advanced) 0: no parent. Instruct the platform backend to setup a parent/child relationship between platform windows.
    DrawData:              *ImDrawData; // The ImDrawData corresponding to this viewport. Valid after Render() and until the next call to NewFrame().

    RendererUserData:      *void; // void* to hold custom data structure for the renderer (e.g. swap chain, framebuffers etc.). generally set by your Renderer_CreateWindow function.
    PlatformUserData:      *void; // void* to hold custom data structure for the OS / platform (e.g. windowing info, render context). generally set by your Platform_CreateWindow function.
    PlatformHandle:        *void; // void* for FindViewportByPlatformHandle(). (e.g. suggested to use natural platform handle such as HWND, GLFWWindow*, SDL_Window*)
    PlatformHandleRaw:     *void; // void* to hold lower-level, platform-native window handle (under Win32 this is expected to be a HWND, unused for other platforms), when using an abstraction layer like GLFW or SDL (where PlatformHandle would be a SDL_Window*)
    PlatformWindowCreated: bool; // Platform window has been created (Platform_CreateWindow() has been called). This is false during the first frame where a viewport is being created.
    PlatformRequestMove:   bool; // Platform window requested move (e.g. window was moved by the OS / host window manager, authoritative position will be OS window position)
    PlatformRequestResize: bool; // Platform window requested resize (e.g. window was resized by the OS / host window manager, authoritative size will be OS window size)
    PlatformRequestClose:  bool; // Platform window requested closure (e.g. window was moved by the OS / host window manager, e.g. pressing ALT-F4)
}

// (Optional) Access via ImGui::GetPlatformIO()
PlatformIO :: struct {
    Platform_CreateWindow:       #type (vp: *Viewport) -> void #c_call; // . . U . .  // Create a new platform window for the given viewport
    Platform_DestroyWindow:      #type (vp: *Viewport) -> void #c_call; // N . U . D  //
    Platform_ShowWindow:         #type (vp: *Viewport) -> void #c_call; // . . U . .  // Newly created windows are initially hidden so SetWindowPos/Size/Title can be called on them before showing the window
    Platform_SetWindowPos:       #type (vp: *Viewport, pos: ImVec2) -> void #c_call; // . . U . .  // Set platform window position (given the upper-left corner of client area)
    Platform_GetWindowPos:       #type (vp: *Viewport) -> ImVec2 #c_call; // N . . . .  //
    Platform_SetWindowSize:      #type (vp: *Viewport, size: ImVec2) -> void #c_call; // . . U . .  // Set platform window client area size (ignoring OS decorations such as OS title bar etc.)
    Platform_GetWindowSize:      #type (vp: *Viewport) -> ImVec2 #c_call; // N . . . .  // Get platform window client area size
    Platform_SetWindowFocus:     #type (vp: *Viewport) -> void #c_call; // N . . . .  // Move window to front and set input focus
    Platform_GetWindowFocus:     #type (vp: *Viewport) -> bool #c_call; // . . U . .  //
    Platform_GetWindowMinimized: #type (vp: *Viewport) -> bool #c_call; // N . . . .  // Get platform window minimized state. When minimized, we generally won't attempt to get/set size and contents will be culled more easily
    Platform_SetWindowTitle:     #type (vp: *Viewport, str: *u8) -> void #c_call; // . . U . .  // Set platform window title (given an UTF-8 string)
    Platform_SetWindowAlpha:     #type (vp: *Viewport, alpha: float) -> void #c_call; // . . U . .  // (Optional) Setup global transparency (not per-pixel transparency)
    Platform_UpdateWindow:       #type (vp: *Viewport) -> void #c_call; // . . U . .  // (Optional) Called by UpdatePlatformWindows(). Optional hook to allow the platform backend from doing general book-keeping every frame.
    Platform_RenderWindow:       #type (vp: *Viewport, render_arg: *void) -> void #c_call; // . . . R .  // (Optional) Main rendering (platform side! This is often unused, or just setting a "current" context for OpenGL bindings). 'render_arg' is the value passed to RenderPlatformWindowsDefault().
    Platform_SwapBuffers:        #type (vp: *Viewport, render_arg: *void) -> void #c_call; // . . . R .  // (Optional) Call Present/SwapBuffers (platform side! This is often unused!). 'render_arg' is the value passed to RenderPlatformWindowsDefault().
    Platform_GetWindowDpiScale:  #type (vp: *Viewport) -> float #c_call; // N . . . .  // (Optional) [BETA] FIXME-DPI: DPI handling: Return DPI scale for this viewport. 1.0f = 96 DPI.
    Platform_OnChangedViewport:  #type (vp: *Viewport) -> void #c_call; // . F . . .  // (Optional) [BETA] FIXME-DPI: DPI handling: Called during Begin() every time the viewport we are outputting into changes, so backend has a chance to swap fonts to adjust style.
    Platform_CreateVkSurface:    #type (vp: *Viewport, vk_inst: ImU64, vk_allocators: *void, out_vk_surface: *ImU64) -> s32 #c_call; // (Optional) For a Vulkan Renderer to call into Platform code (since the surface creation needs to tie them both).

    Renderer_CreateWindow:       #type (vp: *Viewport) -> void #c_call; // . . U . .  // Create swap chain, frame buffers etc. (called after Platform_CreateWindow)
    Renderer_DestroyWindow:      #type (vp: *Viewport) -> void #c_call; // N . U . D  // Destroy swap chain, frame buffers etc. (called before Platform_DestroyWindow)
    Renderer_SetWindowSize:      #type (vp: *Viewport, size: ImVec2) -> void #c_call; // . . U . .  // Resize swap chain, frame buffers etc. (called after Platform_SetWindowSize)
    Renderer_RenderWindow:       #type (vp: *Viewport, render_arg: *void) -> void #c_call; // . . . R .  // (Optional) Clear framebuffer, setup render target, then render the viewport->DrawData. 'render_arg' is the value passed to RenderPlatformWindowsDefault().
    Renderer_SwapBuffers:        #type (vp: *Viewport, render_arg: *void) -> void #c_call; // . . . R .  // (Optional) Call Present/SwapBuffers. 'render_arg' is the value passed to RenderPlatformWindowsDefault().

    // (Optional) Monitor list
    // - Updated by: app/backend. Update every frame to dynamically support changing monitor or DPI configuration.
    // - Used by: dear imgui to query DPI info, clamp popups/tooltips within same monitor and not have them straddle monitors.
    Monitors:                    ImVector(PlatformMonitor);

    Viewports:                   ImVector(*Viewport); // Main viewports, followed by all secondary viewports.
}

// (Optional) This is required when enabling multi-viewport. Represent the bounds of each connected monitor/display and their DPI.
// We use this information for multiple DPI support + clamping the position of popups and tooltips so they don't straddle multiple monitors.
PlatformMonitor :: struct {
    MainPos:        ImVec2; // Coordinates of the area displayed on this monitor (Min = upper left, Max = bottom right)
    MainSize:       ImVec2; // Coordinates of the area displayed on this monitor (Min = upper left, Max = bottom right)
    WorkPos:        ImVec2; // Coordinates without task bars / side bars / menu bars. Used to avoid positioning popups/tooltips inside this region. If you don't have this info, please copy the value for MainPos/MainSize.
    WorkSize:       ImVec2; // Coordinates without task bars / side bars / menu bars. Used to avoid positioning popups/tooltips inside this region. If you don't have this info, please copy the value for MainPos/MainSize.
    DpiScale:       float; // 1.0f = 96 DPI
    PlatformHandle: *void; // Backend dependant data (e.g. HMONITOR, GLFWmonitor*, SDL Display Index, NSScreen*)
}

// (Optional) Support for IME (Input Method Editor) via the io.SetPlatformImeDataFn() function.
PlatformImeData :: struct {
    WantVisible:     bool; // A widget wants the IME to be visible
    InputPos:        ImVec2; // Position of the input cursor
    InputLineHeight: float; // Line height
}

// RENAMED and MERGED both ImGuiKey_ModXXX and ImGuiModFlags_XXX into ImGuiMod_XXX (from September 2022)
// RENAMED ImGuiKeyModFlags -> ImGuiModFlags in 1.88 (from April 2022). Exceptionally commented out ahead of obscolescence schedule to reduce confusion and because they were not meant to be used in the first place.
ModFlags :: KeyChord;
ModFlags_ :: enum_flags u32 {
    None  :: 0x0;
    Ctrl  :: 0x1000;
    Shift :: 0x2000;
    Alt   :: 0x4000;
    Super :: 0x8000;
    ImGuiModFlags_None  :: None;
    ImGuiModFlags_Ctrl  :: Ctrl;
    ImGuiModFlags_Shift :: Shift;
    ImGuiModFlags_Alt   :: Alt;
    ImGuiModFlags_Super :: Super;
}

DockRequest :: struct {}

DockNodeSettings :: struct {}

InputTextDeactivateData :: struct {}

TableColumnsSettings :: struct {}

// Enumerations
// Use your programming IDE "Go to definition" facility on the names of the center columns to find the actual flags/enum lists.
LocKey :: enum s32 {
    VersionStr                    :: 0;
    TableSizeOne                  :: 1;
    TableSizeAllFit               :: 2;
    TableSizeAllDefault           :: 3;
    TableResetOrder               :: 4;
    WindowingMainMenuBar          :: 5;
    WindowingPopup                :: 6;
    WindowingUntitled             :: 7;
    DockingHideTabBar             :: 8;
    DockingHoldShiftToDock        :: 9;
    DockingDragToUndockOrMoveNode :: 10;
    COUNT                         :: 11;

    ImGuiLocKey_VersionStr                    :: VersionStr;
    ImGuiLocKey_TableSizeOne                  :: TableSizeOne;
    ImGuiLocKey_TableSizeAllFit               :: TableSizeAllFit;
    ImGuiLocKey_TableSizeAllDefault           :: TableSizeAllDefault;
    ImGuiLocKey_TableResetOrder               :: TableResetOrder;
    ImGuiLocKey_WindowingMainMenuBar          :: WindowingMainMenuBar;
    ImGuiLocKey_WindowingPopup                :: WindowingPopup;
    ImGuiLocKey_WindowingUntitled             :: WindowingUntitled;
    ImGuiLocKey_DockingHideTabBar             :: DockingHideTabBar;
    ImGuiLocKey_DockingHoldShiftToDock        :: DockingHoldShiftToDock;
    ImGuiLocKey_DockingDragToUndockOrMoveNode :: DockingDragToUndockOrMoveNode;
    ImGuiLocKey_COUNT                         :: COUNT;
}

DataAuthority :: s32;

// Flags
ActivateFlags :: s32;
DebugLogFlags :: s32;

ErrorLogCallback :: #type (user_data: *void, fmt: *u8, __args: ..Any) -> void #c_call;

GImGui: *Context #elsewhere imgui; // Current implicit context pointer

//-------------------------------------------------------------------------
// [SECTION] STB libraries includes
//-------------------------------------------------------------------------
ImStb :: struct {
    StbUndoRecord :: struct {
        // private data
        where:         s32;
        insert_length: s32;
        delete_length: s32;
        char_storage:  s32;
    }

    StbUndoState :: struct {
        // private data
        undo_rec:        [99] StbUndoRecord;
        undo_char:       [999] ImWchar;
        undo_point:      s16;
        redo_point:      s16;
        undo_char_point: s32;
        redo_char_point: s32;
    }

    STB_TexteditState :: struct {
        /////////////////////
        //
        // public data
        //
        cursor:                s32;

        select_start:          s32; // selection start point
        select_end:            s32;

        // selection start and end point in characters; if equal, no selection.
        // note that start may be less than or greater than end (e.g. when
        // dragging the mouse, start is where the initial click was, and you
        // can drag in either direction)
        insert_mode:           u8;

        // each textfield keeps its own insert mode state. to keep an app-wide
        // insert mode, copy this value in/out of the app state
        row_count_per_page:    s32;

        cursor_at_end_of_line: u8; // not implemented yet
        initialized:           u8;
        has_preferred_x:       u8;
        single_line:           u8;
        padding1:              u8;
        padding2:              u8;
        padding3:              u8;
        preferred_x:           float; // this determines where the cursor up/down tries to seek to along x
        undostate:             StbUndoState;
    }

    // result of layout query
    StbTexteditRow :: struct {
        x0:               float; // starting x location, end x location (allows for align=right, etc)
        x1:               float; // starting x location, end x location (allows for align=right, etc)
        baseline_y_delta: float; // position of baseline relative to previous row's baseline
        ymin:             float; // height of row above and below baseline
        ymax:             float; // height of row above and below baseline
        num_chars:        s32;
    }
}

// Helpers: Hashing
ImHashData :: (data: *void, data_size: u64, seed: ID = 0) -> ID #foreign imgui "_Z10ImHashDataPKvmj";
ImHashStr :: (data: *u8, data_size: u64 = 0, seed: ID = 0) -> ID #foreign imgui "_Z9ImHashStrPKcmj";

// Helpers: Color Blending
ImAlphaBlendColors :: (col_a: ImU32, col_b: ImU32) -> ImU32 #foreign imgui "_Z18ImAlphaBlendColorsjj";

// Helpers: String
ImStricmp :: (str1: *u8, str2: *u8) -> s32 #foreign imgui "_Z9ImStricmpPKcS0_";
ImStrnicmp :: (str1: *u8, str2: *u8, count: u64) -> s32 #foreign imgui "_Z10ImStrnicmpPKcS0_m";
ImStrncpy :: (dst: *u8, src: *u8, count: u64) -> void #foreign imgui "_Z9ImStrncpyPcPKcm";
ImStrdup :: (str: *u8) -> *u8 #foreign imgui "_Z8ImStrdupPKc";
ImStrdupcpy :: (dst: *u8, p_dst_size: *u64, str: *u8) -> *u8 #foreign imgui "_Z11ImStrdupcpyPcPmPKc";
ImStrchrRange :: (str_begin: *u8, str_end: *u8, c: u8) -> *u8 #foreign imgui "_Z13ImStrchrRangePKcS0_c";
ImStrchrRange :: (str: string, c: u8) -> *u8 #no_context {
    return ImStrchrRange(str.data, str.data + str.count, c);
}
ImStreolRange :: (str: *u8, str_end: *u8) -> *u8 #foreign imgui "_Z13ImStreolRangePKcS0_";
ImStreolRange :: (str: string) -> *u8 #no_context {
    return ImStreolRange(str.data, str.data + str.count);
}
ImStristr :: (haystack: *u8, haystack_end: *u8, needle: *u8, needle_end: *u8) -> *u8 #foreign imgui "_Z9ImStristrPKcS0_S0_S0_";
ImStristr :: (haystack: string, needle: string) -> *u8 #no_context {
    return ImStristr(haystack.data, haystack.data + haystack.count, needle.data, needle.data + needle.count);
}
ImStrTrimBlanks :: (str: *u8) -> void #foreign imgui "_Z15ImStrTrimBlanksPc";
ImStrSkipBlank :: (str: *u8) -> *u8 #foreign imgui "_Z14ImStrSkipBlankPKc";
ImStrlenW :: (str: *ImWchar) -> s32 #foreign imgui "_Z9ImStrlenWPKj";
ImStrbolW :: (buf_mid_line: *ImWchar, buf_begin: *ImWchar) -> *ImWchar #foreign imgui "_Z9ImStrbolWPKjS0_";

// Helpers: Formatting
ImFormatString_CFormat :: (buf: *u8, buf_size: u64, fmt: *u8, __args: ..Any) -> s32 #foreign imgui "_Z14ImFormatStringPcmPKcz";
ImFormatString :: (buf: *u8, buf_size: u64, fmt: string, __args: ..Any) -> s32 {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    return ImFormatString_CFormat(buf, buf_size, "%s", formatted_text.data);
} @PrintLike

ImFormatStringToTempBuffer_CFormat :: (out_buf: **u8, out_buf_end: **u8, fmt: *u8, __args: ..Any) -> void #foreign imgui "_Z26ImFormatStringToTempBufferPPKcS1_S0_z";
ImFormatStringToTempBuffer :: (out_buf: **u8, out_buf_end: **u8, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    ImFormatStringToTempBuffer_CFormat(out_buf, out_buf_end, "%s", formatted_text.data);
} @PrintLike

ImParseFormatFindStart :: (format: *u8) -> *u8 #foreign imgui "_Z22ImParseFormatFindStartPKc";
ImParseFormatFindEnd :: (format: *u8) -> *u8 #foreign imgui "_Z20ImParseFormatFindEndPKc";
ImParseFormatTrimDecorations :: (format: *u8, buf: *u8, buf_size: u64) -> *u8 #foreign imgui "_Z28ImParseFormatTrimDecorationsPKcPcm";
ImParseFormatSanitizeForPrinting :: (fmt_in: *u8, fmt_out: *u8, fmt_out_size: u64) -> void #foreign imgui "_Z32ImParseFormatSanitizeForPrintingPKcPcm";
ImParseFormatSanitizeForScanning :: (fmt_in: *u8, fmt_out: *u8, fmt_out_size: u64) -> *u8 #foreign imgui "_Z32ImParseFormatSanitizeForScanningPKcPcm";
ImParseFormatPrecision :: (format: *u8, default_value: s32) -> s32 #foreign imgui "_Z22ImParseFormatPrecisionPKci";

// Helpers: UTF-8 <> wchar conversions
ImTextCharToUtf8 :: (out_buf: *[5] u8, c: u32) -> *u8 #foreign imgui "_Z16ImTextCharToUtf8Pcj";
ImTextStrToUtf8 :: (out_buf: *u8, out_buf_size: s32, in_text: *ImWchar, in_text_end: *ImWchar) -> s32 #foreign imgui "_Z15ImTextStrToUtf8PciPKjS1_";
ImTextCharFromUtf8 :: (out_char: *u32, in_text: *u8, in_text_end: *u8) -> s32 #foreign imgui "_Z18ImTextCharFromUtf8PjPKcS1_";
ImTextCharFromUtf8 :: (out_char: *u32, in_text: string) -> s32 #no_context {
    return ImTextCharFromUtf8(out_char, in_text.data, in_text.data + in_text.count);
}
ImTextStrFromUtf8 :: (out_buf: *ImWchar, out_buf_size: s32, in_text: *u8, in_text_end: *u8, in_remaining: **u8 = null) -> s32 #foreign imgui "_Z17ImTextStrFromUtf8PjiPKcS1_PS1_";
ImTextStrFromUtf8 :: (out_buf: *ImWchar, out_buf_size: s32, in_text: string, in_remaining: **u8 = null) -> s32 #no_context {
    return ImTextStrFromUtf8(out_buf, out_buf_size, in_text.data, in_text.data + in_text.count, in_remaining);
}
ImTextCountCharsFromUtf8 :: (in_text: *u8, in_text_end: *u8) -> s32 #foreign imgui "_Z24ImTextCountCharsFromUtf8PKcS0_";
ImTextCountCharsFromUtf8 :: (in_text: string) -> s32 #no_context {
    return ImTextCountCharsFromUtf8(in_text.data, in_text.data + in_text.count);
}
ImTextCountUtf8BytesFromChar :: (in_text: *u8, in_text_end: *u8) -> s32 #foreign imgui "_Z28ImTextCountUtf8BytesFromCharPKcS0_";
ImTextCountUtf8BytesFromChar :: (in_text: string) -> s32 #no_context {
    return ImTextCountUtf8BytesFromChar(in_text.data, in_text.data + in_text.count);
}
ImTextCountUtf8BytesFromStr :: (in_text: *ImWchar, in_text_end: *ImWchar) -> s32 #foreign imgui "_Z27ImTextCountUtf8BytesFromStrPKjS0_";
ImTextFindPreviousUtf8Codepoint :: (in_text_start: *u8, in_text_curr: *u8) -> *u8 #foreign imgui "_Z31ImTextFindPreviousUtf8CodepointPKcS0_";

ImFileHandle :: *FILE;
ImFileOpen :: (filename: *u8, mode: *u8) -> ImFileHandle #foreign imgui "_Z10ImFileOpenPKcS0_";
ImFileClose :: (file: ImFileHandle) -> bool #foreign imgui "_Z11ImFileCloseP8_IO_FILE";
ImFileGetSize :: (file: ImFileHandle) -> ImU64 #foreign imgui "_Z13ImFileGetSizeP8_IO_FILE";
ImFileRead :: (data: *void, size: ImU64, count: ImU64, file: ImFileHandle) -> ImU64 #foreign imgui "_Z10ImFileReadPvyyP8_IO_FILE";
ImFileWrite :: (data: *void, size: ImU64, count: ImU64, file: ImFileHandle) -> ImU64 #foreign imgui "_Z11ImFileWritePKvyyP8_IO_FILE";

ImFileLoadToMemory :: (filename: *u8, mode: *u8, out_file_size: *u64 = null, padding_bytes: s32 = 0) -> *void #foreign imgui "_Z18ImFileLoadToMemoryPKcS0_Pmi";

// Helpers: Geometry
ImBezierCubicCalc :: (p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, t: float) -> ImVec2 #foreign imgui "_Z17ImBezierCubicCalcRK6ImVec2S1_S1_S1_f";
ImBezierCubicCalc :: (p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, t: float) -> ImVec2 #no_context {
    return ImBezierCubicCalc(*p1, *p2, *p3, *p4, t);
}
ImBezierCubicClosestPoint :: (p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, p: *ImVec2, num_segments: s32) -> ImVec2 #foreign imgui "_Z25ImBezierCubicClosestPointRK6ImVec2S1_S1_S1_S1_i";
ImBezierCubicClosestPoint :: (p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, p: ImVec2, num_segments: s32) -> ImVec2 #no_context {
    return ImBezierCubicClosestPoint(*p1, *p2, *p3, *p4, *p, num_segments);
}
ImBezierCubicClosestPointCasteljau :: (p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, p: *ImVec2, tess_tol: float) -> ImVec2 #foreign imgui "_Z34ImBezierCubicClosestPointCasteljauRK6ImVec2S1_S1_S1_S1_f";
ImBezierCubicClosestPointCasteljau :: (p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, p: ImVec2, tess_tol: float) -> ImVec2 #no_context {
    return ImBezierCubicClosestPointCasteljau(*p1, *p2, *p3, *p4, *p, tess_tol);
}
ImBezierQuadraticCalc :: (p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, t: float) -> ImVec2 #foreign imgui "_Z21ImBezierQuadraticCalcRK6ImVec2S1_S1_f";
ImBezierQuadraticCalc :: (p1: ImVec2, p2: ImVec2, p3: ImVec2, t: float) -> ImVec2 #no_context {
    return ImBezierQuadraticCalc(*p1, *p2, *p3, t);
}
ImLineClosestPoint :: (a: *ImVec2, b: *ImVec2, p: *ImVec2) -> ImVec2 #foreign imgui "_Z18ImLineClosestPointRK6ImVec2S1_S1_";
ImLineClosestPoint :: (a: ImVec2, b: ImVec2, p: ImVec2) -> ImVec2 #no_context {
    return ImLineClosestPoint(*a, *b, *p);
}
ImTriangleContainsPoint :: (a: *ImVec2, b: *ImVec2, c: *ImVec2, p: *ImVec2) -> bool #foreign imgui "_Z23ImTriangleContainsPointRK6ImVec2S1_S1_S1_";
ImTriangleContainsPoint :: (a: ImVec2, b: ImVec2, c: ImVec2, p: ImVec2) -> bool #no_context {
    return ImTriangleContainsPoint(*a, *b, *c, *p);
}
ImTriangleClosestPoint :: (a: *ImVec2, b: *ImVec2, c: *ImVec2, p: *ImVec2) -> ImVec2 #foreign imgui "_Z22ImTriangleClosestPointRK6ImVec2S1_S1_S1_";
ImTriangleClosestPoint :: (a: ImVec2, b: ImVec2, c: ImVec2, p: ImVec2) -> ImVec2 #no_context {
    return ImTriangleClosestPoint(*a, *b, *c, *p);
}
ImTriangleBarycentricCoords :: (a: *ImVec2, b: *ImVec2, c: *ImVec2, p: *ImVec2, out_u: *float, out_v: *float, out_w: *float) -> void #foreign imgui "_Z27ImTriangleBarycentricCoordsRK6ImVec2S1_S1_S1_RfS2_S2_";
ImTriangleBarycentricCoords :: (a: ImVec2, b: ImVec2, c: ImVec2, p: ImVec2, out_u: *float, out_v: *float, out_w: *float) #no_context {
    ImTriangleBarycentricCoords(*a, *b, *c, *p, out_u, out_v, out_w);
}

// Helper: ImVec1 (1D vector)
// (this odd construct is used to facilitate the transition between 1D and 2D, and the maintenance of some branches/patches)
ImVec1 :: struct {
    x: float;
}

// Helper: ImVec2ih (2D vector, half-size integer, for long-term packed storage)
ImVec2ih :: struct {
    x: s16;
    y: s16;
}

ImBitArrayPtr :: *ImU32;

//-----------------------------------------------------------------------------
// [SECTION] Forward declarations
//-----------------------------------------------------------------------------
ImBitVector :: struct {
    Storage: ImVector(ImU32);
}

// Helper: ImSpan<>
// Pointing to a span of data we don't own.
ImSpan :: struct(T: Type) {
    Data:    *T;
    DataEnd: *T;
}

// Helper: ImSpanAllocator<>
// Facilitate storing multiple chunks into a single large block (the "arena")
// - Usage: call Reserve() N times, allocate GetArenaSizeInBytes() worth, pass it to SetArenaBasePtr(), call GetSpan() N times to retrieve the aligned ranges.
ImSpanAllocator :: struct(CHUNKS: s32) {
    BasePtr: *u8;
    CurrOff: s32;
    CurrIdx: s32;
    Offsets: [CHUNKS] s32;
    Sizes:   [CHUNKS] s32;
}

// Helper: ImPool<>
// Basic keyed storage for contiguous instances, slow/amortized insertion, O(1) indexable, O(Log N) queries by ID over a dense/hot buffer,
// Honor constructor/destructor. Add/remove invalidate all pointers. Indexes have the same lifetime as the associated object.
ImPoolIdx :: s32;

ImPool :: struct(T: Type) {
    Buf:        ImVector(T); // Contiguous data
    Map:        Storage; // ID->Index
    FreeIdx:    ImPoolIdx; // Next free idx to use
    AliveCount: ImPoolIdx; // Number of active/alive items (for display purpose)
}

// Helper: ImChunkStream<>
// Build and iterate a contiguous stream of variable-sized structures.
// This is used by Settings to store persistent data while reducing allocation count.
// We store the chunk size first, and align the final size on 4 bytes boundaries.
// The tedious/zealous amount of casting is to avoid -Wcast-align warnings.
ImChunkStream :: struct(T: Type) {
    Buf: ImVector(u8);
}

// Helper: ImGuiTextIndex<>
// Maintain a line index for a text buffer. This is a strong candidate to be moved into the public API.
TextIndex :: struct {
    LineOffsets: ImVector(s32);
    EndOffset:   s32 = 0; // Because we don't own text buffer we need to maintain EndOffset (may bake in LineOffsets?)

    append :: (this: *TextIndex, base: *u8, old_size: s32, new_size: s32) -> void #cpp_method #foreign imgui "_ZN14ImGuiTextIndex6appendEPKcii";
}

// Data shared between all ImDrawList instances
// You may want to create your own instance of this if you want to use ImDrawList completely without ImGui. In that case, watch out for future changes to this structure.
ImDrawListSharedData :: struct {
    TexUvWhitePixel:       ImVec2; // UV of white pixel in the atlas
    Font:                  *ImFont; // Current/default font (optional, for simplified AddText overload)
    FontSize:              float; // Current/default font size (optional, for simplified AddText overload)
    CurveTessellationTol:  float; // Tessellation tolerance when using PathBezierCurveTo()
    CircleSegmentMaxError: float; // Number of circle segments to use per pixel of radius for AddCircle() etc
    ClipRectFullscreen:    ImVec4; // Value for PushClipRectFullscreen()
    InitialFlags:          ImDrawListFlags; // Initial flags at the beginning of the frame (it is possible to alter flags on a per-drawlist basis afterwards)

    // [Internal] Temp write buffer
    TempBuffer:            ImVector(ImVec2);

    ArcFastVtx:            [48] ImVec2; // Sample points on the quarter of the circle.
    ArcFastRadiusCutoff:   float; // Cutoff radius after which arc drawing will fallback to slower PathArcTo()
    CircleSegmentCounts:   [64] ImU8; // Precomputed segment count for given radius before we calculate it dynamically (to avoid calculation overhead)
    TexUvLines:            *ImVec4; // UV of anti-aliased lines in the atlas

    Constructor :: (this: *ImDrawListSharedData) -> void #cpp_method #foreign imgui "_ZN20ImDrawListSharedDataC1Ev";
    SetCircleTessellationMaxError :: (this: *ImDrawListSharedData, max_error: float) -> void #cpp_method #foreign imgui "_ZN20ImDrawListSharedData29SetCircleTessellationMaxErrorEf";
}

ImDrawDataBuilder :: struct {
    Layers:     [2] *ImVector(*ImDrawList); // Pointers to global layers for: regular, tooltip. LayersP[0] is owned by DrawData.
    LayerData1: ImVector(*ImDrawList);
}

// Flags used by upcoming items
// - input: PushItemFlag() manipulates g.CurrentItemFlags, ItemAdd() calls may add extra flags.
// - output: stored in g.LastItemData.InFlags
// Current window shared by all windows.
// This is going to be exposed in imgui.h when stabilized enough.
ItemFlags :: enum_flags u32 {
    None                     :: 0x0;
    NoTabStop                :: 0x1;
    ButtonRepeat             :: 0x2;
    Disabled                 :: 0x4;
    NoNav                    :: 0x8;
    NoNavDefaultFocus        :: 0x10;
    SelectableDontClosePopup :: 0x20;
    MixedValue               :: 0x40;
    ReadOnly                 :: 0x80;
    NoWindowHoverableCheck   :: 0x100;
    AllowOverlap             :: 0x200;

    Inputable                :: 0x400;
    HasSelectionUserData     :: 0x800;

    ImGuiItemFlags_None                     :: None;
    ImGuiItemFlags_NoTabStop                :: NoTabStop;
    ImGuiItemFlags_ButtonRepeat             :: ButtonRepeat;
    ImGuiItemFlags_Disabled                 :: Disabled;
    ImGuiItemFlags_NoNav                    :: NoNav;
    ImGuiItemFlags_NoNavDefaultFocus        :: NoNavDefaultFocus;
    ImGuiItemFlags_SelectableDontClosePopup :: SelectableDontClosePopup;
    ImGuiItemFlags_MixedValue               :: MixedValue;
    ImGuiItemFlags_ReadOnly                 :: ReadOnly;
    ImGuiItemFlags_NoWindowHoverableCheck   :: NoWindowHoverableCheck;
    ImGuiItemFlags_AllowOverlap             :: AllowOverlap;

    ImGuiItemFlags_Inputable                :: Inputable;
    ImGuiItemFlags_HasSelectionUserData     :: HasSelectionUserData;
}

// Status flags for an already submitted item
// - output: stored in g.LastItemData.StatusFlags
ItemStatusFlags :: enum_flags u32 {
    None             :: 0x0;
    HoveredRect      :: 0x1;
    HasDisplayRect   :: 0x2;
    Edited           :: 0x4;
    ToggledSelection :: 0x8;
    ToggledOpen      :: 0x10;
    HasDeactivated   :: 0x20;
    Deactivated      :: 0x40;
    HoveredWindow    :: 0x80;
    Visible          :: 0x100;
    HasClipRect      :: 0x200;

    ImGuiItemStatusFlags_None             :: None;
    ImGuiItemStatusFlags_HoveredRect      :: HoveredRect;
    ImGuiItemStatusFlags_HasDisplayRect   :: HasDisplayRect;
    ImGuiItemStatusFlags_Edited           :: Edited;
    ImGuiItemStatusFlags_ToggledSelection :: ToggledSelection;
    ImGuiItemStatusFlags_ToggledOpen      :: ToggledOpen;
    ImGuiItemStatusFlags_HasDeactivated   :: HasDeactivated;
    ImGuiItemStatusFlags_Deactivated      :: Deactivated;
    ImGuiItemStatusFlags_HoveredWindow    :: HoveredWindow;
    ImGuiItemStatusFlags_Visible          :: Visible;
    ImGuiItemStatusFlags_HasClipRect      :: HasClipRect;
}

// Extend ImGuiHoveredFlags_
HoveredFlagsPrivate_ :: enum u32 {
    HoveredFlags_DelayMask_                    :: 245760;
    HoveredFlags_AllowedMaskForIsWindowHovered :: 12479;
    HoveredFlags_AllowedMaskForIsItemHovered   :: 262048;

    ImGuiHoveredFlags_DelayMask_                    :: HoveredFlags_DelayMask_;
    ImGuiHoveredFlags_AllowedMaskForIsWindowHovered :: HoveredFlags_AllowedMaskForIsWindowHovered;
    ImGuiHoveredFlags_AllowedMaskForIsItemHovered   :: HoveredFlags_AllowedMaskForIsItemHovered;
}

// Extend ImGuiInputTextFlags_
InputTextFlagsPrivate_ :: enum u32 {
    InputTextFlags_Multiline    :: 67108864;
    InputTextFlags_NoMarkEdited :: 134217728;
    InputTextFlags_MergedItem   :: 268435456;

    ImGuiInputTextFlags_Multiline    :: InputTextFlags_Multiline;
    ImGuiInputTextFlags_NoMarkEdited :: InputTextFlags_NoMarkEdited;
    ImGuiInputTextFlags_MergedItem   :: InputTextFlags_MergedItem;
}

// Extend ImGuiButtonFlags_
ButtonFlagsPrivate_ :: enum u32 {
    ButtonFlags_PressedOnClick                :: 16;
    ButtonFlags_PressedOnClickRelease         :: 32;
    ButtonFlags_PressedOnClickReleaseAnywhere :: 64;
    ButtonFlags_PressedOnRelease              :: 128;
    ButtonFlags_PressedOnDoubleClick          :: 256;
    ButtonFlags_PressedOnDragDropHold         :: 512;
    ButtonFlags_Repeat                        :: 1024;
    ButtonFlags_FlattenChildren               :: 2048;
    ButtonFlags_AllowOverlap                  :: 4096;
    ButtonFlags_DontClosePopups               :: 8192;

    ButtonFlags_AlignTextBaseLine             :: 32768;
    ButtonFlags_NoKeyModifiers                :: 65536;
    ButtonFlags_NoHoldingActiveId             :: 131072;
    ButtonFlags_NoNavFocus                    :: 262144;
    ButtonFlags_NoHoveredOnFocus              :: 524288;
    ButtonFlags_NoSetKeyOwner                 :: 1048576;
    ButtonFlags_NoTestKeyOwner                :: 2097152;
    ButtonFlags_PressedOnMask_                :: 1008;
    ButtonFlags_PressedOnDefault_             :: 32;

    ImGuiButtonFlags_PressedOnClick                :: ButtonFlags_PressedOnClick;
    ImGuiButtonFlags_PressedOnClickRelease         :: ButtonFlags_PressedOnClickRelease;
    ImGuiButtonFlags_PressedOnClickReleaseAnywhere :: ButtonFlags_PressedOnClickReleaseAnywhere;
    ImGuiButtonFlags_PressedOnRelease              :: ButtonFlags_PressedOnRelease;
    ImGuiButtonFlags_PressedOnDoubleClick          :: ButtonFlags_PressedOnDoubleClick;
    ImGuiButtonFlags_PressedOnDragDropHold         :: ButtonFlags_PressedOnDragDropHold;
    ImGuiButtonFlags_Repeat                        :: ButtonFlags_Repeat;
    ImGuiButtonFlags_FlattenChildren               :: ButtonFlags_FlattenChildren;
    ImGuiButtonFlags_AllowOverlap                  :: ButtonFlags_AllowOverlap;
    ImGuiButtonFlags_DontClosePopups               :: ButtonFlags_DontClosePopups;

    ImGuiButtonFlags_AlignTextBaseLine             :: ButtonFlags_AlignTextBaseLine;
    ImGuiButtonFlags_NoKeyModifiers                :: ButtonFlags_NoKeyModifiers;
    ImGuiButtonFlags_NoHoldingActiveId             :: ButtonFlags_NoHoldingActiveId;
    ImGuiButtonFlags_NoNavFocus                    :: ButtonFlags_NoNavFocus;
    ImGuiButtonFlags_NoHoveredOnFocus              :: ButtonFlags_NoHoveredOnFocus;
    ImGuiButtonFlags_NoSetKeyOwner                 :: ButtonFlags_NoSetKeyOwner;
    ImGuiButtonFlags_NoTestKeyOwner                :: ButtonFlags_NoTestKeyOwner;
    ImGuiButtonFlags_PressedOnMask_                :: ButtonFlags_PressedOnMask_;
    ImGuiButtonFlags_PressedOnDefault_             :: ButtonFlags_PressedOnDefault_;
}

// Extend ImGuiComboFlags_
ComboFlagsPrivate_ :: enum u32 {
    ComboFlags_CustomPreview :: 1048576;
    ImGuiComboFlags_CustomPreview :: ComboFlags_CustomPreview;
}

// Extend ImGuiSliderFlags_
SliderFlagsPrivate_ :: enum u32 {
    SliderFlags_Vertical :: 1048576;
    SliderFlags_ReadOnly :: 2097152;

    ImGuiSliderFlags_Vertical :: SliderFlags_Vertical;
    ImGuiSliderFlags_ReadOnly :: SliderFlags_ReadOnly;
}

// Extend ImGuiSelectableFlags_
SelectableFlagsPrivate_ :: enum u32 {
    SelectableFlags_NoHoldingActiveID    :: 1048576;
    SelectableFlags_SelectOnNav          :: 2097152;
    SelectableFlags_SelectOnClick        :: 4194304;
    SelectableFlags_SelectOnRelease      :: 8388608;
    SelectableFlags_SpanAvailWidth       :: 16777216;
    SelectableFlags_SetNavIdOnHover      :: 33554432;
    SelectableFlags_NoPadWithHalfSpacing :: 67108864;
    SelectableFlags_NoSetKeyOwner        :: 134217728;

    ImGuiSelectableFlags_NoHoldingActiveID    :: SelectableFlags_NoHoldingActiveID;
    ImGuiSelectableFlags_SelectOnNav          :: SelectableFlags_SelectOnNav;
    ImGuiSelectableFlags_SelectOnClick        :: SelectableFlags_SelectOnClick;
    ImGuiSelectableFlags_SelectOnRelease      :: SelectableFlags_SelectOnRelease;
    ImGuiSelectableFlags_SpanAvailWidth       :: SelectableFlags_SpanAvailWidth;
    ImGuiSelectableFlags_SetNavIdOnHover      :: SelectableFlags_SetNavIdOnHover;
    ImGuiSelectableFlags_NoPadWithHalfSpacing :: SelectableFlags_NoPadWithHalfSpacing;
    ImGuiSelectableFlags_NoSetKeyOwner        :: SelectableFlags_NoSetKeyOwner;
}

// Extend ImGuiTreeNodeFlags_
TreeNodeFlagsPrivate_ :: enum u32 {
    TreeNodeFlags_ClipLabelForTrailingButton :: 1048576;
    TreeNodeFlags_UpsideDownArrow            :: 2097152;

    ImGuiTreeNodeFlags_ClipLabelForTrailingButton :: TreeNodeFlags_ClipLabelForTrailingButton;
    ImGuiTreeNodeFlags_UpsideDownArrow            :: TreeNodeFlags_UpsideDownArrow;
}

SeparatorFlags :: enum_flags u32 {
    None           :: 0x0;
    Horizontal     :: 0x1;
    Vertical       :: 0x2;
    SpanAllColumns :: 0x4;

    ImGuiSeparatorFlags_None           :: None;
    ImGuiSeparatorFlags_Horizontal     :: Horizontal;
    ImGuiSeparatorFlags_Vertical       :: Vertical;
    ImGuiSeparatorFlags_SpanAllColumns :: SpanAllColumns;
}

// Flags for FocusWindow(). This is not called ImGuiFocusFlags to avoid confusion with public-facing ImGuiFocusedFlags.
// FIXME: Once we finishing replacing more uses of GetTopMostPopupModal()+IsWindowWithinBeginStackOf()
// and FindBlockingModal() with this, we may want to change the flag to be opt-out instead of opt-in.
FocusRequestFlags :: enum_flags u32 {
    None                :: 0x0;
    RestoreFocusedChild :: 0x1;
    UnlessBelowModal    :: 0x2;

    ImGuiFocusRequestFlags_None                :: None;
    ImGuiFocusRequestFlags_RestoreFocusedChild :: RestoreFocusedChild;
    ImGuiFocusRequestFlags_UnlessBelowModal    :: UnlessBelowModal;
}

TextFlags :: enum_flags u32 {
    None                       :: 0x0;
    NoWidthForLargeClippedText :: 0x1;

    ImGuiTextFlags_None                       :: None;
    ImGuiTextFlags_NoWidthForLargeClippedText :: NoWidthForLargeClippedText;
}

TooltipFlags :: enum_flags u32 {
    None             :: 0x0;
    OverridePrevious :: 0x2;

    ImGuiTooltipFlags_None             :: None;
    ImGuiTooltipFlags_OverridePrevious :: OverridePrevious;
}

// FIXME: this is in development, not exposed/functional as a generic feature yet.
// Horizontal/Vertical enums are fixed to 0/1 so they may be used to index ImVec2
LayoutType :: enum u32 {
    Horizontal :: 0;
    Vertical   :: 1;

    ImGuiLayoutType_Horizontal :: Horizontal;
    ImGuiLayoutType_Vertical   :: Vertical;
}

LogType :: enum u32 {
    None      :: 0;
    TTY       :: 1;
    File      :: 2;
    Buffer    :: 3;
    Clipboard :: 4;

    ImGuiLogType_None      :: None;
    ImGuiLogType_TTY       :: TTY;
    ImGuiLogType_File      :: File;
    ImGuiLogType_Buffer    :: Buffer;
    ImGuiLogType_Clipboard :: Clipboard;
}

// X/Y enums are fixed to 0/1 so they may be used to index ImVec2
Axis :: enum s32 {
    None :: -1;
    X    :: 0;
    Y    :: 1;

    ImGuiAxis_None :: None;
    ImGuiAxis_X    :: X;
    ImGuiAxis_Y    :: Y;
}

PlotType :: enum u32 {
    Lines     :: 0;
    Histogram :: 1;

    ImGuiPlotType_Lines     :: Lines;
    ImGuiPlotType_Histogram :: Histogram;
}

// Stacked color modifier, backup of modified data so we can restore it
ColorMod :: struct {
    Col_:        Col;
    BackupValue: ImVec4;
}

// Stacked style modifier, backup of modified data so we can restore it. Data type inferred from the variable.
StyleMod :: struct {
    VarIdx: StyleVar;
    union {
        BackupInt:   [2] s32;
        BackupFloat: [2] float;
    }
}

// Storage data for BeginComboPreview()/EndComboPreview()
ComboPreviewData :: struct {
    PreviewRect:                  ImRect;
    BackupCursorPos:              ImVec2;
    BackupCursorMaxPos:           ImVec2;
    BackupCursorPosPrevLine:      ImVec2;
    BackupPrevLineTextBaseOffset: float;
    BackupLayout:                 LayoutType;
}

// Stacked storage data for BeginGroup()/EndGroup()
GroupData :: struct {
    WindowID:                           ID;
    BackupCursorPos:                    ImVec2;
    BackupCursorMaxPos:                 ImVec2;
    BackupCursorPosPrevLine:            ImVec2;
    BackupIndent:                       ImVec1;
    BackupGroupOffset:                  ImVec1;
    BackupCurrLineSize:                 ImVec2;
    BackupCurrLineTextBaseOffset:       float;
    BackupActiveIdIsAlive:              ID;
    BackupActiveIdPreviousFrameIsAlive: bool;
    BackupHoveredIdIsAlive:             bool;
    BackupIsSameLine:                   bool;
    EmitItem:                           bool;
}

// Simple column measurement, currently used for MenuItem() only.. This is very short-sighted/throw-away code and NOT a generic helper.
MenuColumns :: struct {
    TotalWidth:     ImU32;
    NextTotalWidth: ImU32;
    Spacing:        ImU16;
    OffsetIcon:     ImU16; // Always zero for now
    OffsetLabel:    ImU16; // Offsets are locked in Update()
    OffsetShortcut: ImU16;
    OffsetMark:     ImU16;
    Widths:         [4] ImU16; // Width of:   Icon, Label, Shortcut, Mark  (accumulators for current frame)

    Update :: (this: *MenuColumns, spacing: float, window_reappearing: bool) -> void #cpp_method #foreign imgui "_ZN16ImGuiMenuColumns6UpdateEfb";
    DeclColumns :: (this: *MenuColumns, w_icon: float, w_label: float, w_shortcut: float, w_mark: float) -> float #cpp_method #foreign imgui "_ZN16ImGuiMenuColumns11DeclColumnsEffff";
    CalcNextTotalWidth :: (this: *MenuColumns, update_offsets: bool) -> void #cpp_method #foreign imgui "_ZN16ImGuiMenuColumns18CalcNextTotalWidthEb";
}

// Internal temporary state for deactivating InputText() instances.
InputTextDeactivatedState :: struct {
    ID_:   ID; // widget id owning the text state (which just got deactivated)
    TextA: ImVector(u8); // text buffer
}

// Internal state of the currently focused/edited text input box
// For a given item ID, access with ImGui::GetInputTextState()
InputTextState :: struct {
    Ctx:                  *Context; // parent UI context (needs to be set explicitly by parent).
    ID_:                  ID; // widget id owning the text state
    CurLenW:              s32; // we need to maintain our buffer length in both UTF-8 and wchar format. UTF-8 length is valid even if TextA is not.
    CurLenA:              s32; // we need to maintain our buffer length in both UTF-8 and wchar format. UTF-8 length is valid even if TextA is not.
    TextW:                ImVector(ImWchar); // edit buffer, we need to persist but can't guarantee the persistence of the user-provided buffer. so we copy into own buffer.
    TextA:                ImVector(u8); // temporary UTF8 buffer for callbacks and other operations. this is not updated in every code-path! size=capacity.
    InitialTextA:         ImVector(u8); // value to revert to when pressing Escape = backup of end-user buffer at the time of focus (in UTF-8, unaltered)
    TextAIsValid:         bool; // temporary UTF8 buffer is not initially valid before we make the widget active (until then we pull the data from user argument)
    BufCapacityA:         s32; // end-user buffer capacity
    ScrollX:              float; // horizontal scrolling/offset
    Stb:                  ImStb.STB_TexteditState; // state for stb_textedit.h
    CursorAnim:           float; // timer for cursor blink, reset on every user action so the cursor reappears immediately
    CursorFollow:         bool; // set when we want scrolling to follow the current cursor position (not always!)
    SelectedAllMouseLock: bool; // after a double-click to select all, we ignore further mouse drags to update selection
    Edited:               bool; // edited this frame
    Flags:                InputTextFlags; // copy of InputText() flags. may be used to check if e.g. ImGuiInputTextFlags_Password is set.
    ReloadUserBuf:        bool; // force a reload of user buf so it may be modified externally. may be automatic in future version.
    ReloadSelectionStart: s32; // POSITIONS ARE IN IMWCHAR units *NOT* UTF-8 this is why this is not exposed yet.
    ReloadSelectionEnd:   s32;

    ClearFreeMemory :: (this: *InputTextState) -> void #cpp_method #foreign imgui "_ZN19ImGuiInputTextState15ClearFreeMemoryEv";

    OnKeyPressed :: (this: *InputTextState, key: s32) -> void #cpp_method #foreign imgui "_ZN19ImGuiInputTextState12OnKeyPressedEi";
}

NextWindowDataFlags :: enum_flags u32 {
    None              :: 0x0;
    HasPos            :: 0x1;
    HasSize           :: 0x2;
    HasContentSize    :: 0x4;
    HasCollapsed      :: 0x8;
    HasSizeConstraint :: 0x10;
    HasFocus          :: 0x20;
    HasBgAlpha        :: 0x40;
    HasScroll         :: 0x80;
    HasChildFlags     :: 0x100;
    HasViewport       :: 0x200;
    HasDock           :: 0x400;
    HasWindowClass    :: 0x800;

    ImGuiNextWindowDataFlags_None              :: None;
    ImGuiNextWindowDataFlags_HasPos            :: HasPos;
    ImGuiNextWindowDataFlags_HasSize           :: HasSize;
    ImGuiNextWindowDataFlags_HasContentSize    :: HasContentSize;
    ImGuiNextWindowDataFlags_HasCollapsed      :: HasCollapsed;
    ImGuiNextWindowDataFlags_HasSizeConstraint :: HasSizeConstraint;
    ImGuiNextWindowDataFlags_HasFocus          :: HasFocus;
    ImGuiNextWindowDataFlags_HasBgAlpha        :: HasBgAlpha;
    ImGuiNextWindowDataFlags_HasScroll         :: HasScroll;
    ImGuiNextWindowDataFlags_HasChildFlags     :: HasChildFlags;
    ImGuiNextWindowDataFlags_HasViewport       :: HasViewport;
    ImGuiNextWindowDataFlags_HasDock           :: HasDock;
    ImGuiNextWindowDataFlags_HasWindowClass    :: HasWindowClass;
}

// Storage for SetNexWindow** functions
NextWindowData :: struct {
    Flags:                NextWindowDataFlags;
    PosCond:              Cond;
    SizeCond:             Cond;
    CollapsedCond:        Cond;
    DockCond:             Cond;
    PosVal:               ImVec2;
    PosPivotVal:          ImVec2;
    SizeVal:              ImVec2;
    ContentSizeVal:       ImVec2;
    ScrollVal:            ImVec2;
    ChildFlags_:          ChildFlags;
    PosUndock:            bool;
    CollapsedVal:         bool;
    SizeConstraintRect:   ImRect;
    SizeCallback_:        SizeCallback;
    SizeCallbackUserData: *void;
    BgAlphaVal:           float; // Override background alpha
    ViewportId:           ID;
    DockId:               ID;
    WindowClass_:         WindowClass;
    MenuBarOffsetMinVal:  ImVec2; // (Always on) This is not exposed publicly, so we don't clear it and it doesn't have a corresponding flag (could we? for consistency?)
}

// Multi-Selection item index or identifier when using SetNextItemSelectionUserData()/BeginMultiSelect()
// (Most users are likely to use this store an item INDEX but this may be used to store a POINTER as well.)
SelectionUserData :: ImS64;

NextItemDataFlags :: enum_flags u32 {
    None        :: 0x0;
    HasWidth    :: 0x1;
    HasOpen     :: 0x2;
    HasShortcut :: 0x4;

    ImGuiNextItemDataFlags_None        :: None;
    ImGuiNextItemDataFlags_HasWidth    :: HasWidth;
    ImGuiNextItemDataFlags_HasOpen     :: HasOpen;
    ImGuiNextItemDataFlags_HasShortcut :: HasShortcut;
}

NextItemData :: struct {
    Flags:              NextItemDataFlags;
    ItemFlags_:         ItemFlags; // Currently only tested/used for ImGuiItemFlags_AllowOverlap.

    SelectionUserData_: SelectionUserData; // Set by SetNextItemSelectionUserData() (note that NULL/0 is a valid value, we use -1 == ImGuiSelectionUserData_Invalid to mark invalid values)
    Width:              float; // Set by SetNextItemWidth()
    Shortcut:           KeyChord; // Set by SetNextItemShortcut()
    OpenVal:            bool; // Set by SetNextItemOpen()
    OpenCond:           u8; /* 8 bits */
}

// Status storage for the last submitted item
LastItemData :: struct {
    ID_:         ID;
    InFlags:     ItemFlags; // See ImGuiItemFlags_
    StatusFlags: ItemStatusFlags; // See ImGuiItemStatusFlags_
    Rect:        ImRect; // Full rectangle
    NavRect:     ImRect; // Navigation scoring rectangle (not displayed)

    DisplayRect: ImRect; // Display rectangle (ONLY VALID IF ImGuiItemStatusFlags_HasDisplayRect is set)
    ClipRect:    ImRect; // Clip rectangle at the time of submitting item (ONLY VALID IF ImGuiItemStatusFlags_HasClipRect is set)
}

// Store data emitted by TreeNode() for usage by TreePop() to implement ImGuiTreeNodeFlags_NavLeftJumpsBackHere.
// This is the minimum amount of data that we need to perform the equivalent of NavApplyItemToResult() and which we can't infer in TreePop()
// Only stored when the node is a potential candidate for landing on a Left arrow jump.
NavTreeNodeData :: struct {
    ID_:     ID;
    InFlags: ItemFlags;
    NavRect: ImRect;
}

StackSizes :: struct {
    SizeOfIDStack:         s16;
    SizeOfColorStack:      s16;
    SizeOfStyleVarStack:   s16;
    SizeOfFontStack:       s16;
    SizeOfFocusScopeStack: s16;
    SizeOfGroupStack:      s16;
    SizeOfItemFlagsStack:  s16;
    SizeOfBeginPopupStack: s16;
    SizeOfDisabledStack:   s16;

    SetToContextState :: (this: *StackSizes, ctx: *Context) -> void #cpp_method #foreign imgui "_ZN15ImGuiStackSizes17SetToContextStateEP12ImGuiContext";
    CompareWithContextState :: (this: *StackSizes, ctx: *Context) -> void #cpp_method #foreign imgui "_ZN15ImGuiStackSizes23CompareWithContextStateEP12ImGuiContext";
}

// Data saved for each window pushed into the stack
WindowStackData :: struct {
    Window_:                  *Window;
    ParentLastItemDataBackup: LastItemData;
    StackSizesOnBegin:        StackSizes; // Store size of various stacks for asserting
}

ShrinkWidthItem :: struct {
    Index:        s32;
    Width:        float;
    InitialWidth: float;
}

PtrOrIndex :: struct {
    Ptr:   *void; // Either field can be set, not both. e.g. Dock node tab bars are loose while BeginTabBar() ones are in a pool.
    Index: s32; // Usually index in a main pool.
}

//-----------------------------------------------------------------------------
// [SECTION] Data types support
//-----------------------------------------------------------------------------
DataVarInfo :: struct {
    Type:   DataType;
    Count:  ImU32; // 1+
    Offset: ImU32; // Offset in parent structure
}

DataTypeTempStorage :: struct {
    Data: [8] ImU8; // Can fit any data up to ImGuiDataType_COUNT
}

// Type information associated to one ImGuiDataType. Retrieve with DataTypeGetInfo().
DataTypeInfo :: struct {
    Size:     u64; // Size in bytes
    Name:     *u8; // Short descriptive name for the type, for debugging
    PrintFmt: *u8; // Default printf format for the type
    ScanFmt:  *u8; // Default scanf format for the type
}

// Extend ImGuiDataType_
DataTypePrivate_ :: enum u32 {
    DataType_String  :: 11;
    DataType_Pointer :: 12;
    DataType_ID      :: 13;

    ImGuiDataType_String  :: DataType_String;
    ImGuiDataType_Pointer :: DataType_Pointer;
    ImGuiDataType_ID      :: DataType_ID;
}

//-----------------------------------------------------------------------------
// [SECTION] Popup support
//-----------------------------------------------------------------------------
PopupPositionPolicy :: enum u32 {
    Default  :: 0;
    ComboBox :: 1;
    Tooltip  :: 2;

    ImGuiPopupPositionPolicy_Default  :: Default;
    ImGuiPopupPositionPolicy_ComboBox :: ComboBox;
    ImGuiPopupPositionPolicy_Tooltip  :: Tooltip;
}

// Storage for popup stacks (g.OpenPopupStack and g.BeginPopupStack)
PopupData :: struct {
    PopupId:         ID; // Set on OpenPopup()
    Window_:         *Window; // Resolved on BeginPopup() - may stay unresolved if user never calls OpenPopup()
    BackupNavWindow: *Window; // Set on OpenPopup(), a NavWindow that will be restored on popup close
    ParentNavLayer:  s32; // Resolved on BeginPopup(). Actually a ImGuiNavLayer type (declared down below), initialized to -1 which is not part of an enum, but serves well-enough as "not any of layers" value
    OpenFrameCount:  s32; // Set on OpenPopup()
    OpenParentId:    ID; // Set on OpenPopup(), we need this to differentiate multiple menu sets from each others (e.g. inside menu bar vs loose menu items)
    OpenPopupPos:    ImVec2; // Set on OpenPopup(), preferred popup position (typically == OpenMousePos when using mouse)
    OpenMousePos:    ImVec2; // Set on OpenPopup(), copy of mouse position at the time of opening popup
}

InputEventType :: enum u32 {
    None          :: 0;
    MousePos      :: 1;
    MouseWheel    :: 2;
    MouseButton   :: 3;
    MouseViewport :: 4;
    Key           :: 5;
    Text          :: 6;
    Focus         :: 7;
    COUNT         :: 8;

    ImGuiInputEventType_None          :: None;
    ImGuiInputEventType_MousePos      :: MousePos;
    ImGuiInputEventType_MouseWheel    :: MouseWheel;
    ImGuiInputEventType_MouseButton   :: MouseButton;
    ImGuiInputEventType_MouseViewport :: MouseViewport;
    ImGuiInputEventType_Key           :: Key;
    ImGuiInputEventType_Text          :: Text;
    ImGuiInputEventType_Focus         :: Focus;
    ImGuiInputEventType_COUNT         :: COUNT;
}

InputSource :: enum u32 {
    None      :: 0;
    Mouse     :: 1;
    Keyboard  :: 2;
    Gamepad   :: 3;
    Clipboard :: 4;
    COUNT     :: 5;

    ImGuiInputSource_None      :: None;
    ImGuiInputSource_Mouse     :: Mouse;
    ImGuiInputSource_Keyboard  :: Keyboard;
    ImGuiInputSource_Gamepad   :: Gamepad;
    ImGuiInputSource_Clipboard :: Clipboard;
    ImGuiInputSource_COUNT     :: COUNT;
}

// FIXME: Structures in the union below need to be declared as anonymous unions appears to be an extension?
// Using ImVec2() would fail on Clang 'union member 'MousePos' has a non-trivial default constructor'
InputEventMousePos :: struct {
    PosX:         float;
    PosY:         float;
    MouseSource_: MouseSource;
}
InputEventMouseWheel :: struct {
    WheelX:       float;
    WheelY:       float;
    MouseSource_: MouseSource;
}
InputEventMouseButton :: struct {
    Button:       s32;
    Down:         bool;
    MouseSource_: MouseSource;
}
InputEventMouseViewport :: struct {
    HoveredViewportID: ID;
}
InputEventKey :: struct {
    Key_:        Key;
    Down:        bool;
    AnalogValue: float;
}
InputEventText :: struct {
    Char: u32;
}
InputEventAppFocused :: struct {
    Focused: bool;
}

InputEvent :: struct {
    Type:              InputEventType;
    Source:            InputSource;
    EventId:           ImU32; // Unique, sequential increasing integer to identify an event (if you need to correlate them to other data).
    union {
        MousePos:      InputEventMousePos; // if Type == ImGuiInputEventType_MousePos
        MouseWheel:    InputEventMouseWheel; // if Type == ImGuiInputEventType_MouseWheel
        MouseButton:   InputEventMouseButton; // if Type == ImGuiInputEventType_MouseButton
        MouseViewport: InputEventMouseViewport; // if Type == ImGuiInputEventType_MouseViewport
        Key:           InputEventKey; // if Type == ImGuiInputEventType_Key
        Text:          InputEventText; // if Type == ImGuiInputEventType_Text
        AppFocused:    InputEventAppFocused; // if Type == ImGuiInputEventType_Focus
    }

    AddedByTestEngine: bool;
}

KeyRoutingIndex :: ImS16;

// Routing table entry (sizeof() == 16 bytes)
KeyRoutingData :: struct {
    NextEntryIndex:   KeyRoutingIndex;
    Mods:             ImU16; // Technically we'd only need 4-bits but for simplify we store ImGuiMod_ values which need 16-bits. ImGuiMod_Shortcut is already translated to Ctrl/Super.
    RoutingCurrScore: ImU8; // [DEBUG] For debug display
    RoutingNextScore: ImU8; // Lower is better (0: perfect score)
    RoutingCurr:      ID;
    RoutingNext:      ID;
}

// Routing table: maintain a desired owner for each possible key-chord (key + mods), and setup owner in NewFrame() when mods are matching.
// Stored in main context (1 instance)
KeyRoutingTable :: struct {
    Index:       [154] KeyRoutingIndex; // Index of first entry in Entries[]
    Entries:     ImVector(KeyRoutingData);
    EntriesNext: ImVector(KeyRoutingData); // Double-buffer to avoid reallocation (could use a shared buffer)

    Clear :: (this: *KeyRoutingTable) -> void #cpp_method #foreign imgui "_ZN20ImGuiKeyRoutingTable5ClearEv";
}

// This extends ImGuiKeyData but only for named keys (legacy keys don't support the new features)
// Stored in main context (1 per named key). In the future it might be merged into ImGuiKeyData.
KeyOwnerData :: struct {
    OwnerCurr:        ID;
    OwnerNext:        ID;
    LockThisFrame:    bool; // Reading this key requires explicit owner id (until end of frame). Set by ImGuiInputFlags_LockThisFrame.
    LockUntilRelease: bool; // Reading this key requires explicit owner id (until key is released). Set by ImGuiInputFlags_LockUntilRelease. When this is true LockThisFrame is always true as well.
}

// Flags for extended versions of IsKeyPressed(), IsMouseClicked(), Shortcut(), SetKeyOwner(), SetItemKeyOwner()
// Don't mistake with ImGuiInputTextFlags! (which is for ImGui::InputText() function)
InputFlags :: enum_flags u32 {
    None                             :: 0x0;

    Repeat                           :: 0x1;
    RepeatRateDefault                :: 0x2;
    RepeatRateNavMove                :: 0x4;
    RepeatRateNavTweak               :: 0x8;

    RepeatUntilRelease               :: 0x10;
    RepeatUntilKeyModsChange         :: 0x20;
    RepeatUntilKeyModsChangeFromNone :: 0x40;
    RepeatUntilOtherKeyPress         :: 0x80;

    CondHovered                      :: 0x100;
    CondActive                       :: 0x200;
    CondDefault_                     :: 0x300;

    LockThisFrame                    :: 0x400;
    LockUntilRelease                 :: 0x800;

    RouteFocused                     :: 0x1000;
    RouteGlobalLow                   :: 0x2000;
    RouteGlobal                      :: 0x4000;
    RouteGlobalHigh                  :: 0x8000;
    RouteAlways                      :: 0x10000;

    RouteUnlessBgFocused             :: 0x20000;

    RepeatRateMask_                  :: 0xe;
    RepeatUntilMask_                 :: 0xf0;
    RepeatMask_                      :: 0xff;
    CondMask_                        :: 0x300;
    RouteMask_                       :: 0xf000;
    SupportedByIsKeyPressed          :: 0xff;
    SupportedByIsMouseClicked        :: 0x1;
    SupportedByShortcut              :: 0x3f0ff;
    SupportedBySetKeyOwner           :: 0xc00;
    SupportedBySetItemKeyOwner       :: 0xf00;

    ImGuiInputFlags_None                             :: None;

    ImGuiInputFlags_Repeat                           :: Repeat;
    ImGuiInputFlags_RepeatRateDefault                :: RepeatRateDefault;
    ImGuiInputFlags_RepeatRateNavMove                :: RepeatRateNavMove;
    ImGuiInputFlags_RepeatRateNavTweak               :: RepeatRateNavTweak;

    ImGuiInputFlags_RepeatUntilRelease               :: RepeatUntilRelease;
    ImGuiInputFlags_RepeatUntilKeyModsChange         :: RepeatUntilKeyModsChange;
    ImGuiInputFlags_RepeatUntilKeyModsChangeFromNone :: RepeatUntilKeyModsChangeFromNone;
    ImGuiInputFlags_RepeatUntilOtherKeyPress         :: RepeatUntilOtherKeyPress;

    ImGuiInputFlags_CondHovered                      :: CondHovered;
    ImGuiInputFlags_CondActive                       :: CondActive;
    ImGuiInputFlags_CondDefault_                     :: CondDefault_;

    ImGuiInputFlags_LockThisFrame                    :: LockThisFrame;
    ImGuiInputFlags_LockUntilRelease                 :: LockUntilRelease;

    ImGuiInputFlags_RouteFocused                     :: RouteFocused;
    ImGuiInputFlags_RouteGlobalLow                   :: RouteGlobalLow;
    ImGuiInputFlags_RouteGlobal                      :: RouteGlobal;
    ImGuiInputFlags_RouteGlobalHigh                  :: RouteGlobalHigh;
    ImGuiInputFlags_RouteAlways                      :: RouteAlways;

    ImGuiInputFlags_RouteUnlessBgFocused             :: RouteUnlessBgFocused;

    ImGuiInputFlags_RepeatRateMask_                  :: RepeatRateMask_;
    ImGuiInputFlags_RepeatUntilMask_                 :: RepeatUntilMask_;
    ImGuiInputFlags_RepeatMask_                      :: RepeatMask_;
    ImGuiInputFlags_CondMask_                        :: CondMask_;
    ImGuiInputFlags_RouteMask_                       :: RouteMask_;
    ImGuiInputFlags_SupportedByIsKeyPressed          :: SupportedByIsKeyPressed;
    ImGuiInputFlags_SupportedByIsMouseClicked        :: SupportedByIsMouseClicked;
    ImGuiInputFlags_SupportedByShortcut              :: SupportedByShortcut;
    ImGuiInputFlags_SupportedBySetKeyOwner           :: SupportedBySetKeyOwner;
    ImGuiInputFlags_SupportedBySetItemKeyOwner       :: SupportedBySetItemKeyOwner;
}

// Note that Max is exclusive, so perhaps should be using a Begin/End convention.
ListClipperRange :: struct {
    Min:                 s32;
    Max:                 s32;
    PosToIndexConvert:   bool; // Begin/End are absolute position (will be converted to indices later)
    PosToIndexOffsetMin: ImS8; // Add to Min after converting to indices
    PosToIndexOffsetMax: ImS8; // Add to Min after converting to indices
}

// Temporary clipper data, buffers shared/reused between instances
ListClipperData :: struct {
    ListClipper_:    *ListClipper;
    LossynessOffset: float;
    StepNo:          s32;
    ItemsFrozen:     s32;
    Ranges:          ImVector(ListClipperRange);
}

//-----------------------------------------------------------------------------
// [SECTION] Navigation support
//-----------------------------------------------------------------------------
ActivateFlags_ :: enum_flags u32 {
    None               :: 0x0;
    PreferInput        :: 0x1;
    PreferTweak        :: 0x2;
    TryToPreserveState :: 0x4;
    FromTabbing        :: 0x8;
    FromShortcut       :: 0x10;

    ImGuiActivateFlags_None               :: None;
    ImGuiActivateFlags_PreferInput        :: PreferInput;
    ImGuiActivateFlags_PreferTweak        :: PreferTweak;
    ImGuiActivateFlags_TryToPreserveState :: TryToPreserveState;
    ImGuiActivateFlags_FromTabbing        :: FromTabbing;
    ImGuiActivateFlags_FromShortcut       :: FromShortcut;
}

// Early work-in-progress API for ScrollToItem()
ScrollFlags :: enum_flags u32 {
    None               :: 0x0;
    KeepVisibleEdgeX   :: 0x1;
    KeepVisibleEdgeY   :: 0x2;
    KeepVisibleCenterX :: 0x4;
    KeepVisibleCenterY :: 0x8;
    AlwaysCenterX      :: 0x10;
    AlwaysCenterY      :: 0x20;
    NoScrollParent     :: 0x40;
    MaskX_             :: 0x15;
    MaskY_             :: 0x2a;

    ImGuiScrollFlags_None               :: None;
    ImGuiScrollFlags_KeepVisibleEdgeX   :: KeepVisibleEdgeX;
    ImGuiScrollFlags_KeepVisibleEdgeY   :: KeepVisibleEdgeY;
    ImGuiScrollFlags_KeepVisibleCenterX :: KeepVisibleCenterX;
    ImGuiScrollFlags_KeepVisibleCenterY :: KeepVisibleCenterY;
    ImGuiScrollFlags_AlwaysCenterX      :: AlwaysCenterX;
    ImGuiScrollFlags_AlwaysCenterY      :: AlwaysCenterY;
    ImGuiScrollFlags_NoScrollParent     :: NoScrollParent;
    ImGuiScrollFlags_MaskX_             :: MaskX_;
    ImGuiScrollFlags_MaskY_             :: MaskY_;
}

NavHighlightFlags :: enum_flags u32 {
    None       :: 0x0;
    Compact    :: 0x2;
    AlwaysDraw :: 0x4;
    NoRounding :: 0x8;

    ImGuiNavHighlightFlags_None       :: None;
    ImGuiNavHighlightFlags_Compact    :: Compact;
    ImGuiNavHighlightFlags_AlwaysDraw :: AlwaysDraw;
    ImGuiNavHighlightFlags_NoRounding :: NoRounding;
}

NavMoveFlags :: enum_flags u32 {
    None                :: 0x0;
    LoopX               :: 0x1;
    LoopY               :: 0x2;
    WrapX               :: 0x4;
    WrapY               :: 0x8;
    WrapMask_           :: 0xf;
    AllowCurrentNavId   :: 0x10;
    AlsoScoreVisibleSet :: 0x20;
    ScrollToEdgeY       :: 0x40;
    Forwarded           :: 0x80;
    DebugNoResult       :: 0x100;
    FocusApi            :: 0x200;
    IsTabbing           :: 0x400;
    IsPageMove          :: 0x800;
    Activate            :: 0x1000;
    NoSelect            :: 0x2000;
    NoSetNavHighlight   :: 0x4000;

    ImGuiNavMoveFlags_None                :: None;
    ImGuiNavMoveFlags_LoopX               :: LoopX;
    ImGuiNavMoveFlags_LoopY               :: LoopY;
    ImGuiNavMoveFlags_WrapX               :: WrapX;
    ImGuiNavMoveFlags_WrapY               :: WrapY;
    ImGuiNavMoveFlags_WrapMask_           :: WrapMask_;
    ImGuiNavMoveFlags_AllowCurrentNavId   :: AllowCurrentNavId;
    ImGuiNavMoveFlags_AlsoScoreVisibleSet :: AlsoScoreVisibleSet;
    ImGuiNavMoveFlags_ScrollToEdgeY       :: ScrollToEdgeY;
    ImGuiNavMoveFlags_Forwarded           :: Forwarded;
    ImGuiNavMoveFlags_DebugNoResult       :: DebugNoResult;
    ImGuiNavMoveFlags_FocusApi            :: FocusApi;
    ImGuiNavMoveFlags_IsTabbing           :: IsTabbing;
    ImGuiNavMoveFlags_IsPageMove          :: IsPageMove;
    ImGuiNavMoveFlags_Activate            :: Activate;
    ImGuiNavMoveFlags_NoSelect            :: NoSelect;
    ImGuiNavMoveFlags_NoSetNavHighlight   :: NoSetNavHighlight;
}

NavLayer :: enum u32 {
    Main  :: 0;
    Menu  :: 1;
    COUNT :: 2;

    ImGuiNavLayer_Main  :: Main;
    ImGuiNavLayer_Menu  :: Menu;
    ImGuiNavLayer_COUNT :: COUNT;
}

NavItemData :: struct {
    Window_:            *Window; // Init,Move    // Best candidate window (result->ItemWindow->RootWindowForNav == request->Window)
    ID_:                ID; // Init,Move    // Best candidate item ID
    FocusScopeId:       ID; // Init,Move    // Best candidate focus scope ID
    RectRel:            ImRect; // Init,Move    // Best candidate bounding box in window relative space
    InFlags:            ItemFlags; // ????,Move    // Best candidate item flags
    SelectionUserData_: SelectionUserData; //I+Mov    // Best candidate SetNextItemSelectionData() value.
    DistBox:            float; //      Move    // Best candidate box distance to current NavId
    DistCenter:         float; //      Move    // Best candidate center distance to current NavId
    DistAxial:          float; //      Move    // Best candidate axial distance to current NavId
}

FocusScopeData :: struct {
    ID_:      ID;
    WindowID: ID;
}

// Flags for GetTypingSelectRequest()
TypingSelectFlags :: enum_flags u32 {
    None                :: 0x0;
    AllowBackspace      :: 0x1;
    AllowSingleCharMode :: 0x2;

    ImGuiTypingSelectFlags_None                :: None;
    ImGuiTypingSelectFlags_AllowBackspace      :: AllowBackspace;
    ImGuiTypingSelectFlags_AllowSingleCharMode :: AllowSingleCharMode;
}

// Returned by GetTypingSelectRequest(), designed to eventually be public.
TypingSelectRequest :: struct {
    Flags:           TypingSelectFlags; // Flags passed to GetTypingSelectRequest()
    SearchBufferLen: s32;
    SearchBuffer:    *u8; // Search buffer contents (use full string. unless SingleCharMode is set, in which case use SingleCharSize).
    SelectRequest:   bool; // Set when buffer was modified this frame, requesting a selection.
    SingleCharMode:  bool; // Notify when buffer contains same character repeated, to implement special mode. In this situation it preferred to not display any on-screen search indication.
    SingleCharSize:  ImS8; // Length in bytes of first letter codepoint (1 for ascii, 2-4 for UTF-8). If (SearchBufferLen==RepeatCharSize) only 1 letter has been input.
}

// Storage for GetTypingSelectRequest()
TypingSelectState :: struct {
    Request:            TypingSelectRequest; // User-facing data
    SearchBuffer:       [64] u8; // Search buffer: no need to make dynamic as this search is very transient.
    FocusScope:         ID;
    LastRequestFrame:   s32 = 0;
    LastRequestTime:    float = 0.0;
    SingleCharModeLock  := false; // After a certain single char repeat count we lock into SingleCharMode. Two benefits: 1) buffer never fill, 2) we can provide an immediate SingleChar mode without timer elapsing.
}

// Flags for internal's BeginColumns(). This is an obsolete API. Prefer using BeginTable() nowadays!
OldColumnFlags :: enum_flags u32 {
    None                   :: 0x0;
    NoBorder               :: 0x1;
    NoResize               :: 0x2;
    NoPreserveWidths       :: 0x4;
    NoForceWithinWindow    :: 0x8;
    GrowParentContentsSize :: 0x10;

    ImGuiOldColumnFlags_None                   :: None;
    ImGuiOldColumnFlags_NoBorder               :: NoBorder;
    ImGuiOldColumnFlags_NoResize               :: NoResize;
    ImGuiOldColumnFlags_NoPreserveWidths       :: NoPreserveWidths;
    ImGuiOldColumnFlags_NoForceWithinWindow    :: NoForceWithinWindow;
    ImGuiOldColumnFlags_GrowParentContentsSize :: GrowParentContentsSize;
}

OldColumnData :: struct {
    OffsetNorm:             float; // Column start offset, normalized 0.0 (far left) -> 1.0 (far right)
    OffsetNormBeforeResize: float;
    Flags:                  OldColumnFlags; // Not exposed
    ClipRect:               ImRect;
}

OldColumns :: struct {
    ID_:                      ID;
    Flags:                    OldColumnFlags;
    IsFirstFrame:             bool;
    IsBeingResized:           bool;
    Current:                  s32;
    Count:                    s32;
    OffMinX:                  float; // Offsets from HostWorkRect.Min.x
    OffMaxX:                  float; // Offsets from HostWorkRect.Min.x
    LineMinY:                 float;
    LineMaxY:                 float;
    HostCursorPosY:           float; // Backup of CursorPos at the time of BeginColumns()
    HostCursorMaxPosX:        float; // Backup of CursorMaxPos at the time of BeginColumns()
    HostInitialClipRect:      ImRect; // Backup of ClipRect at the time of BeginColumns()
    HostBackupClipRect:       ImRect; // Backup of ClipRect during PushColumnsBackground()/PopColumnsBackground()
    HostBackupParentWorkRect: ImRect; //Backup of WorkRect at the time of BeginColumns()
    Columns:                  ImVector(OldColumnData);
    Splitter:                 ImDrawListSplitter;
}

// Extend ImGuiDockNodeFlags_
DockNodeFlagsPrivate_ :: enum s32 {
    DockNodeFlags_DockSpace                 :: 1024;
    DockNodeFlags_CentralNode               :: 2048;
    DockNodeFlags_NoTabBar                  :: 4096;
    DockNodeFlags_HiddenTabBar              :: 8192;
    DockNodeFlags_NoWindowMenuButton        :: 16384;
    DockNodeFlags_NoCloseButton             :: 32768;
    DockNodeFlags_NoResizeX                 :: 65536;
    DockNodeFlags_NoResizeY                 :: 131072;
    DockNodeFlags_DockedWindowsInFocusRoute :: 262144;

    DockNodeFlags_NoDockingSplitOther       :: 524288;
    DockNodeFlags_NoDockingOverMe           :: 1048576;
    DockNodeFlags_NoDockingOverOther        :: 2097152;
    DockNodeFlags_NoDockingOverEmpty        :: 4194304;
    DockNodeFlags_NoDocking                 :: 7864336;

    DockNodeFlags_SharedFlagsInheritMask_   :: -1;
    DockNodeFlags_NoResizeFlagsMask_        :: 196640;

    DockNodeFlags_LocalFlagsTransferMask_   :: 260208;
    DockNodeFlags_SavedFlagsMask_           :: 261152;

    ImGuiDockNodeFlags_DockSpace                 :: DockNodeFlags_DockSpace;
    ImGuiDockNodeFlags_CentralNode               :: DockNodeFlags_CentralNode;
    ImGuiDockNodeFlags_NoTabBar                  :: DockNodeFlags_NoTabBar;
    ImGuiDockNodeFlags_HiddenTabBar              :: DockNodeFlags_HiddenTabBar;
    ImGuiDockNodeFlags_NoWindowMenuButton        :: DockNodeFlags_NoWindowMenuButton;
    ImGuiDockNodeFlags_NoCloseButton             :: DockNodeFlags_NoCloseButton;
    ImGuiDockNodeFlags_NoResizeX                 :: DockNodeFlags_NoResizeX;
    ImGuiDockNodeFlags_NoResizeY                 :: DockNodeFlags_NoResizeY;
    ImGuiDockNodeFlags_DockedWindowsInFocusRoute :: DockNodeFlags_DockedWindowsInFocusRoute;

    ImGuiDockNodeFlags_NoDockingSplitOther       :: DockNodeFlags_NoDockingSplitOther;
    ImGuiDockNodeFlags_NoDockingOverMe           :: DockNodeFlags_NoDockingOverMe;
    ImGuiDockNodeFlags_NoDockingOverOther        :: DockNodeFlags_NoDockingOverOther;
    ImGuiDockNodeFlags_NoDockingOverEmpty        :: DockNodeFlags_NoDockingOverEmpty;
    ImGuiDockNodeFlags_NoDocking                 :: DockNodeFlags_NoDocking;

    ImGuiDockNodeFlags_SharedFlagsInheritMask_   :: DockNodeFlags_SharedFlagsInheritMask_;
    ImGuiDockNodeFlags_NoResizeFlagsMask_        :: DockNodeFlags_NoResizeFlagsMask_;

    ImGuiDockNodeFlags_LocalFlagsTransferMask_   :: DockNodeFlags_LocalFlagsTransferMask_;
    ImGuiDockNodeFlags_SavedFlagsMask_           :: DockNodeFlags_SavedFlagsMask_;
}

// Store the source authority (dock node vs window) of a field
DataAuthority_ :: enum u32 {
    Auto     :: 0;
    DockNode :: 1;
    Window   :: 2;

    ImGuiDataAuthority_Auto     :: Auto;
    ImGuiDataAuthority_DockNode :: DockNode;
    ImGuiDataAuthority_Window   :: Window;
}

DockNodeState :: enum u32 {
    Unknown                                   :: 0;
    HostWindowHiddenBecauseSingleWindow       :: 1;
    HostWindowHiddenBecauseWindowsAreResizing :: 2;
    HostWindowVisible                         :: 3;

    ImGuiDockNodeState_Unknown                                   :: Unknown;
    ImGuiDockNodeState_HostWindowHiddenBecauseSingleWindow       :: HostWindowHiddenBecauseSingleWindow;
    ImGuiDockNodeState_HostWindowHiddenBecauseWindowsAreResizing :: HostWindowHiddenBecauseWindowsAreResizing;
    ImGuiDockNodeState_HostWindowVisible                         :: HostWindowVisible;
}

// sizeof() 156~192
DockNode :: struct {
    ID_:                    ID;
    SharedFlags:            DockNodeFlags; // (Write) Flags shared by all nodes of a same dockspace hierarchy (inherited from the root node)
    LocalFlags:             DockNodeFlags; // (Write) Flags specific to this node
    LocalFlagsInWindows:    DockNodeFlags; // (Write) Flags specific to this node, applied from windows
    MergedFlags:            DockNodeFlags; // (Read)  Effective flags (== SharedFlags | LocalFlagsInNode | LocalFlagsInWindows)
    State:                  DockNodeState;
    ParentNode:             *DockNode;
    ChildNodes:             [2] *DockNode; // [Split node only] Child nodes (left/right or top/bottom). Consider switching to an array.
    Windows:                ImVector(*Window); // Note: unordered list! Iterate TabBar->Tabs for user-order.
    TabBar_:                *TabBar;
    Pos:                    ImVec2; // Current position
    Size:                   ImVec2; // Current size
    SizeRef:                ImVec2; // [Split node only] Last explicitly written-to size (overridden when using a splitter affecting the node), used to calculate Size.
    SplitAxis:              Axis; // [Split node only] Split axis (X or Y)
    WindowClass_:           WindowClass; // [Root node only]
    LastBgColor:            ImU32;

    HostWindow:             *Window;
    VisibleWindow:          *Window; // Generally point to window which is ID is == SelectedTabID, but when CTRL+Tabbing this can be a different window.
    CentralNode:            *DockNode; // [Root node only] Pointer to central node.
    OnlyNodeWithWindows:    *DockNode; // [Root node only] Set when there is a single visible node within the hierarchy.
    CountNodeWithWindows:   s32; // [Root node only]
    LastFrameAlive:         s32; // Last frame number the node was updated or kept alive explicitly with DockSpace() + ImGuiDockNodeFlags_KeepAliveOnly
    LastFrameActive:        s32; // Last frame number the node was updated.
    LastFrameFocused:       s32; // Last frame number the node was focused.
    LastFocusedNodeId:      ID; // [Root node only] Which of our child docking node (any ancestor in the hierarchy) was last focused.
    SelectedTabId:          ID; // [Leaf node only] Which of our tab/window is selected.
    WantCloseTabId:         ID; // [Leaf node only] Set when closing a specific tab/window.
    RefViewportId:          ID; // Reference viewport ID from visible window when HostWindow == NULL.
    __bitfield:             u16;
    /* 
        AuthorityForPos: DataAuthority; /* 3 bits */
        AuthorityForSize: DataAuthority; /* 3 bits */
        AuthorityForViewport: DataAuthority; /* 3 bits */;
    */

    IsVisible:              bool #align 1; /* 1 bits */ // Set to false when the node is hidden (usually disabled as it has no active window)
    IsFocused:              bool #align 1; /* 1 bits */
    IsBgDrawnThisFrame:     bool #align 1; /* 1 bits */
    HasCloseButton:         bool #align 1; /* 1 bits */ // Provide space for a close button (if any of the docked window has one). Note that button may be hidden on window without one.
    HasWindowMenuButton:    bool #align 1; /* 1 bits */
    HasCentralNodeChild:    bool #align 1; /* 1 bits */
    WantCloseAll:           bool #align 1; /* 1 bits */ // Set when closing all tabs at once.
    WantLockSizeOnce:       bool; /* 1 bits */
    WantMouseMove:          bool #align 1; /* 1 bits */ // After a node extraction we need to transition toward moving the newly created host window
    WantHiddenTabBarUpdate: bool #align 1; /* 1 bits */
    WantHiddenTabBarToggle: bool #align 1; /* 1 bits */

    Constructor :: (this: *DockNode, id: ID) -> void #cpp_method #foreign imgui "_ZN13ImGuiDockNodeC1Ej";
    Destructor_Base :: (this: *DockNode) -> void #cpp_method #foreign imgui "_ZN13ImGuiDockNodeD2Ev";
    Destructor :: (this: *DockNode) -> void #cpp_method #foreign imgui "_ZN13ImGuiDockNodeD1Ev";
    #place ID_; DockNode_alignment: u64;
}

// List of colors that are stored at the time of Begin() into Docked Windows.
// We currently store the packed colors in a simple array window->DockStyle.Colors[].
// A better solution may involve appending into a log of colors in ImGuiContext + store offsets into those arrays in ImGuiWindow,
// but it would be more complex as we'd need to double-buffer both as e.g. drop target may refer to window from last frame.
WindowDockStyleCol :: enum u32 {
    Text               :: 0;
    Tab                :: 1;
    TabHovered         :: 2;
    TabActive          :: 3;
    TabUnfocused       :: 4;
    TabUnfocusedActive :: 5;
    COUNT              :: 6;

    ImGuiWindowDockStyleCol_Text               :: Text;
    ImGuiWindowDockStyleCol_Tab                :: Tab;
    ImGuiWindowDockStyleCol_TabHovered         :: TabHovered;
    ImGuiWindowDockStyleCol_TabActive          :: TabActive;
    ImGuiWindowDockStyleCol_TabUnfocused       :: TabUnfocused;
    ImGuiWindowDockStyleCol_TabUnfocusedActive :: TabUnfocusedActive;
    ImGuiWindowDockStyleCol_COUNT              :: COUNT;
}

WindowDockStyle :: struct {
    Colors: [6] ImU32;
}

DockContext :: struct {
    Nodes:           Storage; // Map ID -> ImGuiDockNode*: Active nodes
    Requests:        ImVector(DockRequest);
    NodesSettings:   ImVector(DockNodeSettings);
    WantFullRebuild: bool;
}

// ImGuiViewport Private/Internals fields (cardinal sin: we are using inheritance!)
// Every instance of ImGuiViewport is in fact a ImGuiViewportP.
ViewportP :: struct {
    #as using imguiviewport: Viewport;

    Window_:                 *Window; // Set when the viewport is owned by a window (and ImGuiViewportFlags_CanHostOtherWindows is NOT set)
    Idx:                     s32;
    LastFrameActive:         s32; // Last frame number this viewport was activated by a window
    LastFocusedStampCount:   s32; // Last stamp number from when a window hosted by this viewport was focused (by comparing this value between two viewport we have an implicit viewport z-order we use as fallback)
    LastNameHash:            ID;
    LastPos:                 ImVec2;
    Alpha:                   float; // Window opacity (when dragging dockable windows/viewports we make them transparent)
    LastAlpha:               float;
    LastFocusedHadNavWindow: bool; // Instead of maintaining a LastFocusedWindow (which may harder to correctly maintain), we merely store weither NavWindow != NULL last time the viewport was focused.
    PlatformMonitor:         s16;
    BgFgDrawListsLastFrame:  [2] s32; // Last frame number the background (0) and foreground (1) draw lists were used
    BgFgDrawLists:           [2] *ImDrawList; // Convenience background (0) and foreground (1) draw lists. We use them to draw software mouser cursor when io.MouseDrawCursor is set and to draw most debug overlays.
    DrawDataP:               ImDrawData;
    DrawDataBuilder:         ImDrawDataBuilder; // Temporary data while building final ImDrawData
    LastPlatformPos:         ImVec2;
    LastPlatformSize:        ImVec2;
    LastRendererSize:        ImVec2;
    WorkOffsetMin:           ImVec2; // Work Area: Offset from Pos to top-left corner of Work Area. Generally (0,0) or (0,+main_menu_bar_height). Work Area is Full Area but without menu-bars/status-bars (so WorkArea always fit inside Pos/Size!)
    WorkOffsetMax:           ImVec2; // Work Area: Offset from Pos+Size to bottom-right corner of Work Area. Generally (0,0) or (0,-status_bar_height).
    BuildWorkOffsetMin:      ImVec2; // Work Area: Offset being built during current frame. Generally >= 0.0f.
    BuildWorkOffsetMax:      ImVec2; // Work Area: Offset being built during current frame. Generally <= 0.0f.
}

// Windows data saved in imgui.ini file
// Because we never destroy or rename ImGuiWindowSettings, we can store the names in a separate buffer easily.
// (this is designed to be stored in a ImChunkStream buffer, with the variable-length Name following our structure)
WindowSettings :: struct {
    ID_:         ID;
    Pos:         ImVec2ih; // NB: Settings position are stored RELATIVE to the viewport! Whereas runtime ones are absolute positions.
    Size:        ImVec2ih;
    ViewportPos: ImVec2ih;
    ViewportId:  ID;
    DockId:      ID; // ID of last known DockNode (even if the DockNode is invisible because it has only 1 active window), or 0 if none.
    ClassId:     ID; // ID of window class if specified
    DockOrder:   s16; // Order of the last time the window was visible within its DockNode. This is used to reorder windows that are reappearing on the same frame. Same value between windows that were active and windows that were none are possible.
    Collapsed:   bool;
    IsChild:     bool;
    WantApply:   bool; // Set when loaded from .ini data (to enable merging/loading .ini data into an already running context)
    WantDelete:  bool; // Set to invalidate/delete the settings entry
}

SettingsHandler :: struct {
    TypeName:   *u8; // Short description stored in .ini file. Disallowed characters: '[' ']'
    TypeHash:   ID; // == ImHashStr(TypeName)
    ClearAllFn: #type (ctx: *Context, handler: *SettingsHandler) -> void #c_call; // Clear all settings data
    ReadInitFn: #type (ctx: *Context, handler: *SettingsHandler) -> void #c_call; // Read: Called before reading (in registration order)
    ReadOpenFn: #type (ctx: *Context, handler: *SettingsHandler, name: *u8) -> *void #c_call; // Read: Called when entering into a new ini entry e.g. "[Window][Name]"
    ReadLineFn: #type (ctx: *Context, handler: *SettingsHandler, entry: *void, line: *u8) -> void #c_call; // Read: Called for every line of text within an ini entry
    ApplyAllFn: #type (ctx: *Context, handler: *SettingsHandler) -> void #c_call; // Read: Called after reading (in registration order)
    WriteAllFn: #type (ctx: *Context, handler: *SettingsHandler, out_buf: *TextBuffer) -> void #c_call; // Write: Output every entries into 'out_buf'
    UserData:   *void;
}

LocEntry :: struct {
    Key:  LocKey;
    Text: *u8;
}

//-----------------------------------------------------------------------------
// [SECTION] Metrics, Debug Tools
//-----------------------------------------------------------------------------
DebugLogFlags_ :: enum_flags u32 {
    None               :: 0x0;
    EventActiveId      :: 0x1;
    EventFocus         :: 0x2;
    EventPopup         :: 0x4;
    EventNav           :: 0x8;
    EventClipper       :: 0x10;
    EventSelection     :: 0x20;
    EventIO            :: 0x40;
    EventInputRouting  :: 0x80;
    EventDocking       :: 0x100;
    EventViewport      :: 0x200;

    EventMask_         :: 0x3ff;
    OutputToTTY        :: 0x100000;
    OutputToTestEngine :: 0x200000;

    ImGuiDebugLogFlags_None               :: None;
    ImGuiDebugLogFlags_EventActiveId      :: EventActiveId;
    ImGuiDebugLogFlags_EventFocus         :: EventFocus;
    ImGuiDebugLogFlags_EventPopup         :: EventPopup;
    ImGuiDebugLogFlags_EventNav           :: EventNav;
    ImGuiDebugLogFlags_EventClipper       :: EventClipper;
    ImGuiDebugLogFlags_EventSelection     :: EventSelection;
    ImGuiDebugLogFlags_EventIO            :: EventIO;
    ImGuiDebugLogFlags_EventInputRouting  :: EventInputRouting;
    ImGuiDebugLogFlags_EventDocking       :: EventDocking;
    ImGuiDebugLogFlags_EventViewport      :: EventViewport;

    ImGuiDebugLogFlags_EventMask_         :: EventMask_;
    ImGuiDebugLogFlags_OutputToTTY        :: OutputToTTY;
    ImGuiDebugLogFlags_OutputToTestEngine :: OutputToTestEngine;
}

DebugAllocEntry :: struct {
    FrameCount: s32;
    AllocCount: ImS16;
    FreeCount:  ImS16;
}

DebugAllocInfo :: struct {
    TotalAllocCount: s32; // Number of call to MemAlloc().
    TotalFreeCount:  s32;
    LastEntriesIdx:  ImS16; // Current index in buffer
    LastEntriesBuf:  [6] DebugAllocEntry; // Track last 6 frames that had allocations
}

MetricsConfig :: struct {
    ShowDebugLog                  := false;
    ShowIDStackTool               := false;
    ShowWindowsRects              := false;
    ShowWindowsBeginOrder         := false;
    ShowTablesRects               := false;
    ShowDrawCmdMesh               := true;
    ShowDrawCmdBoundingBoxes      := true;
    ShowTextEncodingViewer        := false;
    ShowAtlasTintedWithTextColor  := false;
    ShowDockingNodes              := false;
    ShowWindowsRectsType:         s32 = -1;
    ShowTablesRectsType:          s32 = -1;
    HighlightMonitorIdx:          s32 = -1;
    HighlightViewportID:          ID = 0;
}

StackLevelInfo :: struct {
    ID_:             ID;
    QueryFrameCount: ImS8; // >= 1: Query in progress
    QuerySuccess:    bool; // Obtained result from DebugHookIdInfo()
    DataType:        u8; /* 8 bits */
    Desc:            [57] u8; // Arbitrarily sized buffer to hold a result (FIXME: could replace Results[] with a chunk stream?) FIXME: Now that we added CTRL+C this should be fixed.
}

// State for ID Stack tool queries
IDStackTool :: struct {
    LastActiveFrame:         s32;
    StackLevel:              s32; // -1: query stack and resize Results, >= 0: individual stack level
    QueryId:                 ID; // ID to query details for
    Results:                 ImVector(StackLevelInfo);
    CopyToClipboardOnCtrlC:  bool;
    CopyToClipboardLastTime: float;
}

//-----------------------------------------------------------------------------
// [SECTION] Generic context hooks
//-----------------------------------------------------------------------------
ContextHookCallback :: #type (ctx: *Context, hook: *ContextHook) -> void #c_call;
ContextHookType :: enum u32 {
    NewFramePre     :: 0;
    NewFramePost    :: 1;
    EndFramePre     :: 2;
    EndFramePost    :: 3;
    RenderPre       :: 4;
    RenderPost      :: 5;
    Shutdown        :: 6;
    PendingRemoval_ :: 7;
    ImGuiContextHookType_NewFramePre     :: NewFramePre;
    ImGuiContextHookType_NewFramePost    :: NewFramePost;
    ImGuiContextHookType_EndFramePre     :: EndFramePre;
    ImGuiContextHookType_EndFramePost    :: EndFramePost;
    ImGuiContextHookType_RenderPre       :: RenderPre;
    ImGuiContextHookType_RenderPost      :: RenderPost;
    ImGuiContextHookType_Shutdown        :: Shutdown;
    ImGuiContextHookType_PendingRemoval_ :: PendingRemoval_;
}

ContextHook :: struct {
    HookId:   ID; // A unique ID assigned by AddContextHook()
    Type:     ContextHookType;
    Owner:    ID;
    Callback: ContextHookCallback;
    UserData: *void;
}

//-----------------------------------------------------------------------------
// [SECTION] ImGuiContext (main Dear ImGui context)
//-----------------------------------------------------------------------------
Context :: struct #type_info_none {
    Initialized:                              bool;
    FontAtlasOwnedByContext:                  bool; // IO.Fonts-> is owned by the ImGuiContext and will be destructed along with it.
    IO_:                                      IO;
    PlatformIO_:                              PlatformIO;
    Style_:                                   Style;
    ConfigFlagsCurrFrame:                     ConfigFlags; // = g.IO.ConfigFlags at the time of NewFrame()
    ConfigFlagsLastFrame:                     ConfigFlags;
    Font:                                     *ImFont; // (Shortcut) == FontStack.empty() ? IO.Font : FontStack.back()
    FontSize:                                 float; // (Shortcut) == FontBaseSize * g.CurrentWindow->FontWindowScale == window->FontSize(). Text height for current window.
    FontBaseSize:                             float; // (Shortcut) == IO.FontGlobalScale * Font->Scale * Font->FontSize. Base text height.
    DrawListSharedData:                       ImDrawListSharedData;
    Time:                                     float64;
    FrameCount:                               s32;
    FrameCountEnded:                          s32;
    FrameCountPlatformEnded:                  s32;
    FrameCountRendered:                       s32;
    WithinFrameScope:                         bool; // Set by NewFrame(), cleared by EndFrame()
    WithinFrameScopeWithImplicitWindow:       bool; // Set by NewFrame(), cleared by EndFrame() when the implicit debug window has been pushed
    WithinEndChild:                           bool; // Set within EndChild()
    GcCompactAll:                             bool; // Request full GC
    TestEngineHookItems:                      bool; // Will call test engine hooks: ImGuiTestEngineHook_ItemAdd(), ImGuiTestEngineHook_ItemInfo(), ImGuiTestEngineHook_Log()
    TestEngine:                               *void; // Test engine user data

    InputEventsQueue:                         ImVector(InputEvent); // Input events which will be trickled/written into IO structure.
    InputEventsTrail:                         ImVector(InputEvent); // Past input events processed in NewFrame(). This is to allow domain-specific application to access e.g mouse/pen trail.
    InputEventsNextMouseSource:               MouseSource;
    InputEventsNextEventId:                   ImU32;

    Windows:                                  ImVector(*Window); // Windows, sorted in display order, back to front
    WindowsFocusOrder:                        ImVector(*Window); // Root windows, sorted in focus order, back to front.
    WindowsTempSortBuffer:                    ImVector(*Window); // Temporary buffer used in EndFrame() to reorder windows so parents are kept before their child
    CurrentWindowStack:                       ImVector(WindowStackData);
    WindowsById:                              Storage; // Map window's ImGuiID to ImGuiWindow*
    WindowsActiveCount:                       s32; // Number of unique windows submitted by frame
    WindowsHoverPadding:                      ImVec2; // Padding around resizable windows for which hovering on counts as hovering the window == ImMax(style.TouchExtraPadding, WINDOWS_HOVER_PADDING)
    DebugBreakInWindow:                       ID; // Set to break in Begin() call.
    CurrentWindow:                            *Window; // Window being drawn into
    HoveredWindow:                            *Window; // Window the mouse is hovering. Will typically catch mouse inputs.
    HoveredWindowUnderMovingWindow:           *Window; // Hovered window ignoring MovingWindow. Only set if MovingWindow is set.
    MovingWindow:                             *Window; // Track the window we clicked on (in order to preserve focus). The actual window that is moved is generally MovingWindow->RootWindowDockTree.
    WheelingWindow:                           *Window; // Track the window we started mouse-wheeling on. Until a timer elapse or mouse has moved, generally keep scrolling the same window even if during the course of scrolling the mouse ends up hovering a child window.
    WheelingWindowRefMousePos:                ImVec2;
    WheelingWindowStartFrame:                 s32; // This may be set one frame before WheelingWindow is != NULL
    WheelingWindowScrolledFrame:              s32;
    WheelingWindowReleaseTimer:               float;
    WheelingWindowWheelRemainder:             ImVec2;
    WheelingAxisAvg:                          ImVec2;

    DebugHookIdInfo:                          ID; // Will call core hooks: DebugHookIdInfo() from GetID functions, used by ID Stack Tool [next HoveredId/ActiveId to not pull in an extra cache-line]
    HoveredId:                                ID; // Hovered widget, filled during the frame
    HoveredIdPreviousFrame:                   ID;
    HoveredIdAllowOverlap:                    bool;
    HoveredIdDisabled:                        bool; // At least one widget passed the rect test, but has been discarded by disabled flag or popup inhibit. May be true even if HoveredId == 0.
    HoveredIdTimer:                           float; // Measure contiguous hovering time
    HoveredIdNotActiveTimer:                  float; // Measure contiguous hovering time where the item has not been active
    ActiveId:                                 ID; // Active widget
    ActiveIdIsAlive:                          ID; // Active widget has been seen this frame (we can't use a bool as the ActiveId may change within the frame)
    ActiveIdTimer:                            float;
    ActiveIdIsJustActivated:                  bool; // Set at the time of activation for one frame
    ActiveIdAllowOverlap:                     bool; // Active widget allows another widget to steal active id (generally for overlapping widgets, but not always)
    ActiveIdNoClearOnFocusLoss:               bool; // Disable losing active id if the active id window gets unfocused.
    ActiveIdHasBeenPressedBefore:             bool; // Track whether the active id led to a press (this is to allow changing between PressOnClick and PressOnRelease without pressing twice). Used by range_select branch.
    ActiveIdHasBeenEditedBefore:              bool; // Was the value associated to the widget Edited over the course of the Active state.
    ActiveIdHasBeenEditedThisFrame:           bool;
    ActiveIdFromShortcut:                     bool;
    ActiveIdMouseButton:                      u8; /* 8 bits */
    ActiveIdClickOffset:                      ImVec2; // Clicked offset from upper-left corner, if applicable (currently only set by ButtonBehavior)
    ActiveIdWindow:                           *Window;
    ActiveIdSource:                           InputSource; // Activating source: ImGuiInputSource_Mouse OR ImGuiInputSource_Keyboard OR ImGuiInputSource_Gamepad
    ActiveIdPreviousFrame:                    ID;
    ActiveIdPreviousFrameIsAlive:             bool;
    ActiveIdPreviousFrameHasBeenEditedBefore: bool;
    ActiveIdPreviousFrameWindow:              *Window;
    LastActiveId:                             ID; // Store the last non-zero ActiveId, useful for animation.
    LastActiveIdTimer:                        float; // Store the last non-zero ActiveId timer since the beginning of activation, useful for animation.

    LastKeyModsChangeTime:                    float64; // Record the last time key mods changed (affect repeat delay when using shortcut logic)
    LastKeyModsChangeFromNoneTime:            float64; // Record the last time key mods changed away from being 0 (affect repeat delay when using shortcut logic)
    LastKeyboardKeyPressTime:                 float64; // Record the last time a keyboard key (ignore mouse/gamepad ones) was pressed.
    KeysMayBeCharInput:                       ImBitArrayForNamedKeys; // Lookup to tell if a key can emit char input, see IsKeyChordPotentiallyCharInput(). sizeof() = 20 bytes
    KeysOwnerData:                            [154] KeyOwnerData;
    KeysRoutingTable:                         KeyRoutingTable;
    ActiveIdUsingNavDirMask:                  ImU32; // Active widget will want to read those nav move requests (e.g. can activate a button and move away from it)
    ActiveIdUsingAllKeyboardKeys:             bool; // Active widget will want to read all keyboard keys inputs. (FIXME: This is a shortcut for not taking ownership of 100+ keys but perhaps best to not have the inconsistency)
    DebugBreakInShortcutRouting:              KeyChord; // Set to break in SetShortcutRouting()/Shortcut() calls.

    ActiveIdUsingNavInputMask:                ImU32; // If you used this. Since (IMGUI_VERSION_NUM >= 18804) : 'g.ActiveIdUsingNavInputMask |= (1 << ImGuiNavInput_Cancel);' becomes 'SetKeyOwner(ImGuiKey_Escape, g.ActiveId) and/or SetKeyOwner(ImGuiKey_NavGamepadCancel, g.ActiveId);'

    CurrentFocusScopeId:                      ID; // Value for currently appending items == g.FocusScopeStack.back(). Not to be mistaken with g.NavFocusScopeId.
    CurrentItemFlags:                         ItemFlags; // Value for currently appending items == g.ItemFlagsStack.back()
    DebugLocateId:                            ID; // Storage for DebugLocateItemOnHover() feature: this is read by ItemAdd() so we keep it in a hot/cached location
    NextItemData_:                            NextItemData; // Storage for SetNextItem** functions
    LastItemData_:                            LastItemData; // Storage for last submitted item (setup by ItemAdd)
    NextWindowData_:                          NextWindowData; // Storage for SetNextWindow** functions
    DebugShowGroupRects:                      bool;

    DebugFlashStyleColorIdx:                  Col; // (Keep close to ColorStack to share cache line)
    ColorStack:                               ImVector(ColorMod); // Stack for PushStyleColor()/PopStyleColor() - inherited by Begin()
    StyleVarStack:                            ImVector(StyleMod); // Stack for PushStyleVar()/PopStyleVar() - inherited by Begin()
    FontStack:                                ImVector(*ImFont); // Stack for PushFont()/PopFont() - inherited by Begin()
    FocusScopeStack:                          ImVector(FocusScopeData); // Stack for PushFocusScope()/PopFocusScope() - inherited by BeginChild(), pushed into by Begin()
    ItemFlagsStack:                           ImVector(ItemFlags); // Stack for PushItemFlag()/PopItemFlag() - inherited by Begin()
    GroupStack:                               ImVector(GroupData); // Stack for BeginGroup()/EndGroup() - not inherited by Begin()
    OpenPopupStack:                           ImVector(PopupData); // Which popups are open (persistent)
    BeginPopupStack:                          ImVector(PopupData); // Which level of BeginPopup() we are in (reset every frame)
    NavTreeNodeStack:                         ImVector(NavTreeNodeData); // Stack for TreeNode() when a NavLeft requested is emitted.

    Viewports:                                ImVector(*ViewportP); // Active viewports (always 1+, and generally 1 unless multi-viewports are enabled). Each viewports hold their copy of ImDrawData.
    CurrentDpiScale:                          float; // == CurrentViewport->DpiScale
    CurrentViewport:                          *ViewportP; // We track changes of viewport (happening in Begin) so we can call Platform_OnChangedViewport()
    MouseViewport:                            *ViewportP;
    MouseLastHoveredViewport:                 *ViewportP; // Last known viewport that was hovered by mouse (even if we are not hovering any viewport any more) + honoring the _NoInputs flag.
    PlatformLastFocusedViewportId:            ID;
    FallbackMonitor:                          PlatformMonitor; // Virtual monitor used as fallback if backend doesn't provide monitor information.
    PlatformMonitorsFullWorkRect:             ImRect; // Bounding box of all platform monitors
    ViewportCreatedCount:                     s32; // Unique sequential creation counter (mostly for testing/debugging)
    PlatformWindowsCreatedCount:              s32; // Unique sequential creation counter (mostly for testing/debugging)
    ViewportFocusedStampCount:                s32; // Every time the front-most window changes, we stamp its viewport with an incrementing counter

    NavWindow:                                *Window; // Focused window for navigation. Could be called 'FocusedWindow'
    NavId:                                    ID; // Focused item for navigation
    NavFocusScopeId:                          ID; // Focused focus scope (e.g. selection code often wants to "clear other items" when landing on an item of the same scope)
    NavFocusRoute:                            ImVector(FocusScopeData); // Reversed copy focus scope stack for NavId (should contains NavFocusScopeId). This essentially follow the window->ParentWindowForFocusRoute chain.
    NavActivateId:                            ID; // ~~ (g.ActiveId == 0) && (IsKeyPressed(ImGuiKey_Space) || IsKeyDown(ImGuiKey_Enter) || IsKeyPressed(ImGuiKey_NavGamepadActivate)) ? NavId : 0, also set when calling ActivateItem()
    NavActivateDownId:                        ID; // ~~ IsKeyDown(ImGuiKey_Space) || IsKeyDown(ImGuiKey_Enter) || IsKeyDown(ImGuiKey_NavGamepadActivate) ? NavId : 0
    NavActivatePressedId:                     ID; // ~~ IsKeyPressed(ImGuiKey_Space) || IsKeyPressed(ImGuiKey_Enter) || IsKeyPressed(ImGuiKey_NavGamepadActivate) ? NavId : 0 (no repeat)
    NavActivateFlags:                         ActivateFlags;
    NavHighlightActivatedId:                  ID;
    NavHighlightActivatedTimer:               float;
    NavJustMovedToId:                         ID; // Just navigated to this id (result of a successfully MoveRequest).
    NavJustMovedToFocusScopeId:               ID; // Just navigated to this focus scope id (result of a successfully MoveRequest).
    NavJustMovedToKeyMods:                    KeyChord;
    NavNextActivateId:                        ID; // Set by ActivateItem(), queued until next frame.
    NavNextActivateFlags:                     ActivateFlags;
    NavInputSource:                           InputSource; // Keyboard or Gamepad mode? THIS CAN ONLY BE ImGuiInputSource_Keyboard or ImGuiInputSource_Mouse
    NavLayer_:                                NavLayer; // Layer we are navigating on. For now the system is hard-coded for 0=main contents and 1=menu/title bar, may expose layers later.
    NavLastValidSelectionUserData:            SelectionUserData; // Last valid data passed to SetNextItemSelectionUser(), or -1. For current window. Not reset when focusing an item that doesn't have selection data.
    NavIdIsAlive:                             bool; // Nav widget has been seen this frame ~~ NavRectRel is valid
    NavMousePosDirty:                         bool; // When set we will update mouse position if (io.ConfigFlags & ImGuiConfigFlags_NavEnableSetMousePos) if set (NB: this not enabled by default)
    NavDisableHighlight:                      bool; // When user starts using mouse, we hide gamepad/keyboard highlight (NB: but they are still available, which is why NavDisableHighlight isn't always != NavDisableMouseHover)
    NavDisableMouseHover:                     bool; // When user starts using gamepad/keyboard, we hide mouse hovering highlight until mouse is touched again.

    NavAnyRequest:                            bool; // ~~ NavMoveRequest || NavInitRequest this is to perform early out in ItemAdd()
    NavInitRequest:                           bool; // Init request for appearing window to select first item
    NavInitRequestFromMove:                   bool;
    NavInitResult:                            NavItemData; // Init request result (first item of the window, or one for which SetItemDefaultFocus() was called)
    NavMoveSubmitted:                         bool; // Move request submitted, will process result on next NewFrame()
    NavMoveScoringItems:                      bool; // Move request submitted, still scoring incoming items
    NavMoveForwardToNextFrame:                bool;
    NavMoveFlags_:                            NavMoveFlags;
    NavMoveScrollFlags:                       ScrollFlags;
    NavMoveKeyMods:                           KeyChord;
    NavMoveDir:                               Dir; // Direction of the move request (left/right/up/down)
    NavMoveDirForDebug:                       Dir;
    NavMoveClipDir:                           Dir; // FIXME-NAV: Describe the purpose of this better. Might want to rename?
    NavScoringRect:                           ImRect; // Rectangle used for scoring, in screen space. Based of window->NavRectRel[], modified for directional navigation scoring.
    NavScoringNoClipRect:                     ImRect; // Some nav operations (such as PageUp/PageDown) enforce a region which clipper will attempt to always keep submitted
    NavScoringDebugCount:                     s32; // Metrics for debugging
    NavTabbingDir:                            s32; // Generally -1 or +1, 0 when tabbing without a nav id
    NavTabbingCounter:                        s32; // >0 when counting items for tabbing
    NavMoveResultLocal:                       NavItemData; // Best move request candidate within NavWindow
    NavMoveResultLocalVisible:                NavItemData; // Best move request candidate within NavWindow that are mostly visible (when using ImGuiNavMoveFlags_AlsoScoreVisibleSet flag)
    NavMoveResultOther:                       NavItemData; // Best move request candidate within NavWindow's flattened hierarchy (when using ImGuiWindowFlags_NavFlattened flag)
    NavTabbingResultFirst:                    NavItemData; // First tabbing request candidate within NavWindow and flattened hierarchy

    ConfigNavWindowingKeyNext:                KeyChord; // = ImGuiMod_Ctrl | ImGuiKey_Tab, for reconfiguration (see #4828)
    ConfigNavWindowingKeyPrev:                KeyChord; // = ImGuiMod_Ctrl | ImGuiMod_Shift | ImGuiKey_Tab
    NavWindowingTarget:                       *Window; // Target window when doing CTRL+Tab (or Pad Menu + FocusPrev/Next), this window is temporarily displayed top-most!
    NavWindowingTargetAnim:                   *Window; // Record of last valid NavWindowingTarget until DimBgRatio and NavWindowingHighlightAlpha becomes 0.0f, so the fade-out can stay on it.
    NavWindowingListWindow:                   *Window; // Internal window actually listing the CTRL+Tab contents
    NavWindowingTimer:                        float;
    NavWindowingHighlightAlpha:               float;
    NavWindowingToggleLayer:                  bool;
    NavWindowingToggleKey:                    Key;
    NavWindowingAccumDeltaPos:                ImVec2;
    NavWindowingAccumDeltaSize:               ImVec2;

    DimBgRatio:                               float; // 0.0..1.0 animation when fading in a dimming background (for modal window and CTRL+TAB list)

    // Drag and Drop
    DragDropActive:                           bool;
    DragDropWithinSource:                     bool; // Set when within a BeginDragDropXXX/EndDragDropXXX block for a drag source.
    DragDropWithinTarget:                     bool; // Set when within a BeginDragDropXXX/EndDragDropXXX block for a drag target.
    DragDropSourceFlags:                      DragDropFlags;
    DragDropSourceFrameCount:                 s32;
    DragDropMouseButton:                      s32;
    DragDropPayload:                          Payload;
    DragDropTargetRect:                       ImRect; // Store rectangle of current target candidate (we favor small targets when overlapping)
    DragDropTargetClipRect:                   ImRect; // Store ClipRect at the time of item's drawing
    DragDropTargetId:                         ID;
    DragDropAcceptFlags:                      DragDropFlags;
    DragDropAcceptIdCurrRectSurface:          float; // Target item surface (we resolve overlapping targets by prioritizing the smaller surface)
    DragDropAcceptIdCurr:                     ID; // Target item id (set at the time of accepting the payload)
    DragDropAcceptIdPrev:                     ID; // Target item id from previous frame (we need to store this to allow for overlapping drag and drop targets)
    DragDropAcceptFrameCount:                 s32; // Last time a target expressed a desire to accept the source
    DragDropHoldJustPressedId:                ID; // Set when holding a payload just made ButtonBehavior() return a press.
    DragDropPayloadBufHeap:                   ImVector(u8); // We don't expose the ImVector<> directly, ImGuiPayload only holds pointer+size
    DragDropPayloadBufLocal:                  [16] u8; // Local buffer for small payloads

    // Clipper
    ClipperTempDataStacked:                   s32;
    ClipperTempData:                          ImVector(ListClipperData);

    // Tables
    CurrentTable:                             *Table;
    DebugBreakInTable:                        ID; // Set to break in BeginTable() call.
    TablesTempDataStacked:                    s32; // Temporary table data size (because we leave previous instances undestructed, we generally don't use TablesTempData.Size)
    TablesTempData:                           ImVector(TableTempData); // Temporary table data (buffers reused/shared across instances, support nesting)
    Tables:                                   ImPool(Table); // Persistent table data
    TablesLastTimeActive:                     ImVector(float); // Last used timestamp of each tables (SOA, for efficient GC)
    DrawChannelsTempMergeBuffer:              ImVector(ImDrawChannel);

    // Tab bars
    CurrentTabBar:                            *TabBar;
    TabBars:                                  ImPool(TabBar);
    CurrentTabBarStack:                       ImVector(PtrOrIndex);
    ShrinkWidthBuffer:                        ImVector(ShrinkWidthItem);

    // Hover Delay system
    HoverItemDelayId:                         ID;
    HoverItemDelayIdPreviousFrame:            ID;
    HoverItemDelayTimer:                      float; // Currently used by IsItemHovered()
    HoverItemDelayClearTimer:                 float; // Currently used by IsItemHovered(): grace time before g.TooltipHoverTimer gets cleared.
    HoverItemUnlockedStationaryId:            ID; // Mouse has once been stationary on this item. Only reset after departing the item.
    HoverWindowUnlockedStationaryId:          ID; // Mouse has once been stationary on this window. Only reset after departing the window.

    // Mouse state
    MouseCursor_:                             MouseCursor;
    MouseStationaryTimer:                     float; // Time the mouse has been stationary (with some loose heuristic)
    MouseLastValidPos:                        ImVec2;

    // Widget state
    InputTextState_:                          InputTextState;
    InputTextDeactivatedState_:               InputTextDeactivatedState;
    InputTextPasswordFont:                    ImFont;
    TempInputId:                              ID; // Temporary text input when CTRL+clicking on a slider, etc.
    BeginMenuDepth:                           s32;
    BeginComboDepth:                          s32;
    ColorEditOptions:                         ColorEditFlags; // Store user options for color edit widgets
    ColorEditCurrentID:                       ID; // Set temporarily while inside of the parent-most ColorEdit4/ColorPicker4 (because they call each others).
    ColorEditSavedID:                         ID; // ID we are saving/restoring HS for
    ColorEditSavedHue:                        float; // Backup of last Hue associated to LastColor, so we can restore Hue in lossy RGB<>HSV round trips
    ColorEditSavedSat:                        float; // Backup of last Saturation associated to LastColor, so we can restore Saturation in lossy RGB<>HSV round trips
    ColorEditSavedColor:                      ImU32; // RGB value with alpha set to 0.
    ColorPickerRef:                           ImVec4; // Initial/reference color at the time of opening the color picker.
    ComboPreviewData_:                        ComboPreviewData;
    WindowResizeBorderExpectedRect:           ImRect; // Expected border rect, switch to relative edit if moving
    WindowResizeRelativeMode:                 bool;
    SliderGrabClickOffset:                    float;
    SliderCurrentAccum:                       float; // Accumulated slider delta when using navigation controls.
    SliderCurrentAccumDirty:                  bool; // Has the accumulated slider delta changed since last time we tried to apply it?
    DragCurrentAccumDirty:                    bool;
    DragCurrentAccum:                         float; // Accumulator for dragging modification. Always high-precision, not rounded by end-user precision settings
    DragSpeedDefaultRatio:                    float; // If speed == 0.0f, uses (max-min) * DragSpeedDefaultRatio
    ScrollbarClickDeltaToGrabCenter:          float; // Distance between mouse and center of grab box, normalized in parent space. Use storage?
    DisabledAlphaBackup:                      float; // Backup for style.Alpha for BeginDisabled()
    DisabledStackSize:                        s16;
    LockMarkEdited:                           s16;
    TooltipOverrideCount:                     s16;
    ClipboardHandlerData:                     ImVector(u8); // If no custom clipboard handler is defined
    MenusIdSubmittedThisFrame:                ImVector(ID); // A list of menu IDs that were rendered at least once
    TypingSelectState_:                       TypingSelectState; // State for GetTypingSelectRequest()

    PlatformImeData_:                         PlatformImeData; // Data updated by current frame
    PlatformImeDataPrev:                      PlatformImeData; // Previous frame data (when changing we will call io.SetPlatformImeDataFn
    PlatformImeViewport:                      ID;

    // Extensions
    // FIXME: We could provide an API to register one slot in an array held in ImGuiContext?
    DockContext_:                             DockContext;
    DockNodeWindowMenuHandler:                #type (ctx: *Context, node: *DockNode, tab_bar: *TabBar) -> void #c_call;

    // Settings
    SettingsLoaded:                           bool;
    SettingsDirtyTimer:                       float; // Save .ini Settings to memory when time reaches zero
    SettingsIniData:                          TextBuffer; // In memory .ini settings
    SettingsHandlers:                         ImVector(SettingsHandler); // List of .ini settings handlers
    SettingsWindows:                          ImChunkStream(WindowSettings); // ImGuiWindow .ini settings entries
    SettingsTables:                           ImChunkStream(TableSettings); // ImGuiTable .ini settings entries
    Hooks:                                    ImVector(ContextHook); // Hooks for extensions (e.g. test engine)
    HookIdNext:                               ID; // Next available HookId

    // Localization
    LocalizationTable:                        [11] *u8;

    LogEnabled:                               bool; // Currently capturing
    LogType_:                                 LogType; // Capture target
    LogFile:                                  ImFileHandle; // If != NULL log to stdout/ file
    LogBuffer:                                TextBuffer; // Accumulation buffer when log to clipboard. This is pointer so our GImGui static constructor doesn't call heap allocators.
    LogNextPrefix:                            *u8;
    LogNextSuffix:                            *u8;
    LogLinePosY:                              float;
    LogLineFirstItem:                         bool;
    LogDepthRef:                              s32;
    LogDepthToExpand:                         s32;
    LogDepthToExpandDefault:                  s32; // Default/stored value for LogDepthMaxExpand if not specified in the LogXXX function call.

    // Debug Tools
    // (some of the highly frequently used data are interleaved in other structures above: DebugBreakXXX fields, DebugHookIdInfo, DebugLocateId etc.)
    DebugLogFlags_:                           DebugLogFlags;
    DebugLogBuf:                              TextBuffer;
    DebugLogIndex:                            TextIndex;
    DebugLogAutoDisableFlags:                 DebugLogFlags;
    DebugLogAutoDisableFrames:                ImU8;
    DebugLocateFrames:                        ImU8; // For DebugLocateItemOnHover(). This is used together with DebugLocateId which is in a hot/cached spot above.
    DebugBreakInLocateId:                     bool; // Debug break in ItemAdd() call for g.DebugLocateId.
    DebugBreakKeyChord:                       KeyChord; // = ImGuiKey_Pause
    DebugBeginReturnValueCullDepth:           ImS8; // Cycle between 0..9 then wrap around.
    DebugItemPickerActive:                    bool; // Item picker is active (started with DebugStartItemPicker())
    DebugItemPickerMouseButton:               ImU8;
    DebugItemPickerBreakId:                   ID; // Will call IM_DEBUG_BREAK() when encountering this ID
    DebugFlashStyleColorTime:                 float;
    DebugFlashStyleColorBackup:               ImVec4;
    DebugMetricsConfig:                       MetricsConfig;
    DebugIDStackTool:                         IDStackTool;
    DebugAllocInfo_:                          DebugAllocInfo;
    DebugHoveredDockNode:                     *DockNode; // Hovered dock node.

    FramerateSecPerFrame:                     [60] float; // Calculate estimate of framerate for user over the last 60 frames..
    FramerateSecPerFrameIdx:                  s32;
    FramerateSecPerFrameCount:                s32;
    FramerateSecPerFrameAccum:                float;
    WantCaptureMouseNextFrame:                s32; // Explicit capture override via SetNextFrameWantCaptureMouse()/SetNextFrameWantCaptureKeyboard(). Default to -1.
    WantCaptureKeyboardNextFrame:             s32; // "
    WantTextInputNextFrame:                   s32;
    TempBuffer:                               ImVector(u8); // Temporary text buffer
    TempKeychordName:                         [64] u8;
    #place Initialized; Context_alignment: u64;
}

// Transient per-window data, reset at the beginning of the frame. This used to be called ImGuiDrawContext, hence the DC variable name in ImGuiWindow.
// (That's theory, in practice the delimitation between ImGuiWindow and ImGuiWindowTempData is quite tenuous and could be reconsidered..)
// (This doesn't need a constructor because we zero-clear it as part of ImGuiWindow and all frame-temporary data are setup on Begin)
WindowTempData :: struct {
    CursorPos:                 ImVec2; // Current emitting position, in absolute coordinates.
    CursorPosPrevLine:         ImVec2;
    CursorStartPos:            ImVec2; // Initial position after Begin(), generally ~ window position + WindowPadding.
    CursorMaxPos:              ImVec2; // Used to implicitly calculate ContentSize at the beginning of next frame, for scrolling range and auto-resize. Always growing during the frame.
    IdealMaxPos:               ImVec2; // Used to implicitly calculate ContentSizeIdeal at the beginning of next frame, for auto-resize only. Always growing during the frame.
    CurrLineSize:              ImVec2;
    PrevLineSize:              ImVec2;
    CurrLineTextBaseOffset:    float; // Baseline offset (0.0f by default on a new line, generally == style.FramePadding.y when a framed item has been added).
    PrevLineTextBaseOffset:    float;
    IsSameLine:                bool;
    IsSetPos:                  bool;
    Indent:                    ImVec1; // Indentation / start position from left of window (increased by TreePush/TreePop, etc.)
    ColumnsOffset:             ImVec1; // Offset to the current column (if ColumnsCurrent > 0). FIXME: This and the above should be a stack to allow use cases like Tree->Column->Tree. Need revamp columns API.
    GroupOffset:               ImVec1;
    CursorStartPosLossyness:   ImVec2; // Record the loss of precision of CursorStartPos due to really large scrolling amount. This is used by clipper to compensate and fix the most common use case of large scroll area.

    NavLayerCurrent:           NavLayer; // Current layer, 0..31 (we currently only use 0..1)
    NavLayersActiveMask:       s16; // Which layers have been written to (result from previous frame)
    NavLayersActiveMaskNext:   s16; // Which layers have been written to (accumulator for current frame)
    NavIsScrollPushableX:      bool; // Set when current work location may be scrolled horizontally when moving left / right. This is generally always true UNLESS within a column.
    NavHideHighlightOneFrame:  bool;
    NavWindowHasScrollY:       bool; // Set per window when scrolling can be used (== ScrollMax.y > 0.0f)

    MenuBarAppending:          bool; // FIXME: Remove this
    MenuBarOffset:             ImVec2; // MenuBarOffset.x is sort of equivalent of a per-layer CursorPos.x, saved/restored as we switch to the menu bar. The only situation when MenuBarOffset.y is > 0 if when (SafeAreaPadding.y > FramePadding.y), often used on TVs.
    MenuColumns_:              MenuColumns; // Simplified columns storage for menu items measurement
    TreeDepth:                 s32; // Current tree depth.
    TreeJumpToParentOnPopMask: ImU32; // Store a copy of !g.NavIdIsAlive for TreeDepth 0..31.. Could be turned into a ImU64 if necessary.
    ChildWindows:              ImVector(*Window);
    StateStorage:              *Storage; // Current persistent per-window storage (store e.g. tree node open/close state)
    CurrentColumns:            *OldColumns; // Current columns set
    CurrentTableIdx:           s32; // Current table index (into g.Tables)
    LayoutType_:               LayoutType;
    ParentLayoutType:          LayoutType; // Layout type of parent window at the time of Begin()
    ModalDimBgColor:           ImU32;

    ItemWidth:                 float; // Current item width (>0.0: width in pixels, <0.0: align xx pixels to the right of window).
    TextWrapPos:               float; // Current text wrap pos.
    ItemWidthStack:            ImVector(float); // Store item widths to restore (attention: .back() is not == ItemWidth)
    TextWrapPosStack:          ImVector(float); // Store text wrap pos to restore (attention: .back() is not == TextWrapPos)
}

// Storage for one window
Window :: struct {
    Ctx:                                *Context; // Parent UI context (needs to be set explicitly by parent).
    Name:                               *u8; // Window name, owned by the window.
    ID_:                                ID; // == ImHashStr(Name)
    Flags:                              WindowFlags; // See enum ImGuiWindowFlags_
    FlagsPreviousFrame:                 WindowFlags; // See enum ImGuiWindowFlags_
    ChildFlags_:                        ChildFlags; // Set when window is a child window. See enum ImGuiChildFlags_
    WindowClass_:                       WindowClass; // Advanced users only. Set with SetNextWindowClass()
    Viewport:                           *ViewportP; // Always set in Begin(). Inactive windows may have a NULL value here if their viewport was discarded.
    ViewportId:                         ID; // We backup the viewport id (since the viewport may disappear or never be created if the window is inactive)
    ViewportPos:                        ImVec2; // We backup the viewport position (since the viewport may disappear or never be created if the window is inactive)
    ViewportAllowPlatformMonitorExtend: s32; // Reset to -1 every frame (index is guaranteed to be valid between NewFrame..EndFrame), only used in the Appearing frame of a tooltip/popup to enforce clamping to a given monitor
    Pos:                                ImVec2; // Position (always rounded-up to nearest pixel)
    Size:                               ImVec2; // Current size (==SizeFull or collapsed title bar size)
    SizeFull:                           ImVec2; // Size when non collapsed
    ContentSize:                        ImVec2; // Size of contents/scrollable client area (calculated from the extents reach of the cursor) from previous frame. Does not include window decoration or window padding.
    ContentSizeIdeal:                   ImVec2;
    ContentSizeExplicit:                ImVec2; // Size of contents/scrollable client area explicitly request by the user via SetNextWindowContentSize().
    WindowPadding:                      ImVec2; // Window padding at the time of Begin().
    WindowRounding:                     float; // Window rounding at the time of Begin(). May be clamped lower to avoid rendering artifacts with title bar, menu bar etc.
    WindowBorderSize:                   float; // Window border size at the time of Begin().
    DecoOuterSizeX1:                    float; // Left/Up offsets. Sum of non-scrolling outer decorations (X1 generally == 0.0f. Y1 generally = TitleBarHeight + MenuBarHeight). Locked during Begin().
    DecoOuterSizeY1:                    float; // Left/Up offsets. Sum of non-scrolling outer decorations (X1 generally == 0.0f. Y1 generally = TitleBarHeight + MenuBarHeight). Locked during Begin().
    DecoOuterSizeX2:                    float; // Right/Down offsets (X2 generally == ScrollbarSize.x, Y2 == ScrollbarSizes.y).
    DecoOuterSizeY2:                    float; // Right/Down offsets (X2 generally == ScrollbarSize.x, Y2 == ScrollbarSizes.y).
    DecoInnerSizeX1:                    float; // Applied AFTER/OVER InnerRect. Specialized for Tables as they use specialized form of clipping and frozen rows/columns are inside InnerRect (and not part of regular decoration sizes).
    DecoInnerSizeY1:                    float; // Applied AFTER/OVER InnerRect. Specialized for Tables as they use specialized form of clipping and frozen rows/columns are inside InnerRect (and not part of regular decoration sizes).
    NameBufLen:                         s32; // Size of buffer storing Name. May be larger than strlen(Name)!
    MoveId:                             ID; // == window->GetID("#MOVE")
    TabId:                              ID; // == window->GetID("#TAB")
    ChildId:                            ID; // ID of corresponding item in parent window (for navigation to return from child window to parent window)
    Scroll:                             ImVec2;
    ScrollMax:                          ImVec2;
    ScrollTarget:                       ImVec2; // target scroll position. stored as cursor position with scrolling canceled out, so the highest point is always 0.0f. (FLT_MAX for no change)
    ScrollTargetCenterRatio:            ImVec2; // 0.0f = scroll so that target position is at top, 0.5f = scroll so that target position is centered
    ScrollTargetEdgeSnapDist:           ImVec2; // 0.0f = no snapping, >0.0f snapping threshold
    ScrollbarSizes:                     ImVec2; // Size taken by each scrollbars on their smaller axis. Pay attention! ScrollbarSizes.x == width of the vertical scrollbar, ScrollbarSizes.y = height of the horizontal scrollbar.
    ScrollbarX:                         bool; // Are scrollbars visible?
    ScrollbarY:                         bool; // Are scrollbars visible?
    ViewportOwned:                      bool;
    Active:                             bool; // Set to true on Begin(), unless Collapsed
    WasActive:                          bool;
    WriteAccessed:                      bool; // Set to true when any widget access the current window
    Collapsed:                          bool; // Set when collapsing window to become only title-bar
    WantCollapseToggle:                 bool;
    SkipItems:                          bool; // Set when items can safely be all clipped (e.g. window not visible or collapsed)
    Appearing:                          bool; // Set during the frame where the window is appearing (or re-appearing)
    Hidden:                             bool; // Do not display (== HiddenFrames*** > 0)
    IsFallbackWindow:                   bool; // Set on the "Debug##Default" window.
    IsExplicitChild:                    bool; // Set when passed _ChildWindow, left to false by BeginDocked()
    HasCloseButton:                     bool; // Set when the window has a close button (p_open != NULL)
    ResizeBorderHovered:                s8; // Current border being hovered for resize (-1: none, otherwise 0-3)
    ResizeBorderHeld:                   s8; // Current border being held for resize (-1: none, otherwise 0-3)
    BeginCount:                         s16; // Number of Begin() during the current frame (generally 0 or 1, 1+ if appending via multiple Begin/End pairs)
    BeginCountPreviousFrame:            s16; // Number of Begin() during the previous frame
    BeginOrderWithinParent:             s16; // Begin() order within immediate parent window, if we are a child window. Otherwise 0.
    BeginOrderWithinContext:            s16; // Begin() order within entire imgui context. This is mostly used for debugging submission order related issues.
    FocusOrder:                         s16; // Order within WindowsFocusOrder[], altered when windows are focused.
    PopupId:                            ID; // ID in the popup stack when this window is used as a popup/menu (because we use generic Name/ID for recycling)
    AutoFitFramesX:                     ImS8;
    AutoFitFramesY:                     ImS8;
    AutoFitOnlyGrows:                   bool;
    AutoPosLastDirection:               Dir;
    HiddenFramesCanSkipItems:           ImS8; // Hide the window for N frames
    HiddenFramesCannotSkipItems:        ImS8; // Hide the window for N frames while allowing items to be submitted so we can measure their size
    HiddenFramesForRenderOnly:          ImS8; // Hide the window until frame N at Render() time only
    DisableInputsFrames:                ImS8; // Disable window interactions for N frames
    __bitfield:                         Cond;
    /* 
        SetWindowPosAllowFlags: Cond; /* 8 bits */ // store acceptable condition flags for SetNextWindowPos() use.
        SetWindowSizeAllowFlags: Cond; /* 8 bits */ // store acceptable condition flags for SetNextWindowSize() use.
        SetWindowCollapsedAllowFlags: Cond; /* 8 bits */ // store acceptable condition flags for SetNextWindowCollapsed() use.
        SetWindowDockAllowFlags: Cond; /* 8 bits */ // store acceptable condition flags for SetNextWindowDock() use.;
    */

    SetWindowPosVal:                    ImVec2; // store window position when using a non-zero Pivot (position set needs to be processed when we know the window size)
    SetWindowPosPivot:                  ImVec2; // store window pivot for positioning. ImVec2(0, 0) when positioning from top-left corner; ImVec2(0.5f, 0.5f) for centering; ImVec2(1, 1) for bottom right.

    IDStack:                            ImVector(ID); // ID stack. ID are hashes seeded with the value at the top of the stack. (In theory this should be in the TempData structure)
    DC:                                 WindowTempData; // Temporary per-window data, reset at the beginning of the frame. This used to be called ImGuiDrawContext, hence the "DC" variable name.

    OuterRectClipped:                   ImRect; // == Window->Rect() just after setup in Begin(). == window->Rect() for root window.
    InnerRect:                          ImRect; // Inner rectangle (omit title bar, menu bar, scroll bar)
    InnerClipRect:                      ImRect; // == InnerRect shrunk by WindowPadding*0.5f on each side, clipped within viewport or parent clip rect.
    WorkRect:                           ImRect; // Initially covers the whole scrolling region. Reduced by containers e.g columns/tables when active. Shrunk by WindowPadding*1.0f on each side. This is meant to replace ContentRegionRect over time (from 1.71+ onward).
    ParentWorkRect:                     ImRect; // Backup of WorkRect before entering a container such as columns/tables. Used by e.g. SpanAllColumns functions to easily access. Stacked containers are responsible for maintaining this. // FIXME-WORKRECT: Could be a stack?
    ClipRect:                           ImRect; // Current clipping/scissoring rectangle, evolve as we are using PushClipRect(), etc. == DrawList->clip_rect_stack.back().
    ContentRegionRect:                  ImRect; // FIXME: This is currently confusing/misleading. It is essentially WorkRect but not handling of scrolling. We currently rely on it as right/bottom aligned sizing operation need some size to rely on.
    HitTestHoleSize:                    ImVec2ih; // Define an optional rectangular hole where mouse will pass-through the window.
    HitTestHoleOffset:                  ImVec2ih;

    LastFrameActive:                    s32; // Last frame number the window was Active.
    LastFrameJustFocused:               s32; // Last frame number the window was made Focused.
    LastTimeActive:                     float; // Last timestamp the window was Active (using float as we don't need high precision there)
    ItemWidthDefault:                   float;
    StateStorage:                       Storage;
    ColumnsStorage:                     ImVector(OldColumns);
    FontWindowScale:                    float; // User scale multiplier per-window, via SetWindowFontScale()
    FontDpiScale:                       float;
    SettingsOffset:                     s32; // Offset into SettingsWindows[] (offsets are always valid as we only grow the array from the back)

    DrawList:                           *ImDrawList; // == &DrawListInst (for backward compatibility reason with code using imgui_internal.h we keep this a pointer)
    DrawListInst:                       ImDrawList;
    ParentWindow:                       *Window; // If we are a child _or_ popup _or_ docked window, this is pointing to our parent. Otherwise NULL.
    ParentWindowInBeginStack:           *Window;
    RootWindow:                         *Window; // Point to ourself or first ancestor that is not a child window. Doesn't cross through popups/dock nodes.
    RootWindowPopupTree:                *Window; // Point to ourself or first ancestor that is not a child window. Cross through popups parent<>child.
    RootWindowDockTree:                 *Window; // Point to ourself or first ancestor that is not a child window. Cross through dock nodes.
    RootWindowForTitleBarHighlight:     *Window; // Point to ourself or first ancestor which will display TitleBgActive color when this window is active.
    RootWindowForNav:                   *Window; // Point to ourself or first ancestor which doesn't have the NavFlattened flag.
    ParentWindowForFocusRoute:          *Window; // Set to manual link a window to its logical parent so that Shortcut() chain are honoerd (e.g. Tool linked to Document)

    NavLastChildNavWindow:              *Window; // When going to the menu bar, we remember the child window we came from. (This could probably be made implicit if we kept g.Windows sorted by last focused including child window.)
    NavLastIds:                         [2] ID; // Last known NavId for this window, per layer (0/1)
    NavRectRel:                         [2] ImRect; // Reference rectangle, in window relative space
    NavPreferredScoringPosRel:          [2] ImVec2; // Preferred X/Y position updated when moving on a given axis, reset to FLT_MAX.
    NavRootFocusScopeId:                ID; // Focus Scope ID at the time of Begin()

    MemoryDrawListIdxCapacity:          s32; // Backup of last idx/vtx count, so when waking up the window we can preallocate and avoid iterative alloc/copy
    MemoryDrawListVtxCapacity:          s32;
    MemoryCompacted:                    bool; // Set when window extraneous data have been garbage collected

    DockIsActive:                       bool; /* 1 bits */ // When docking artifacts are actually visible. When this is set, DockNode is guaranteed to be != NULL. ~~ (DockNode != NULL) && (DockNode->Windows.Size > 1).
    DockNodeIsVisible:                  bool #align 1; /* 1 bits */
    DockTabIsVisible:                   bool #align 1; /* 1 bits */ // Is our window visible this frame? ~~ is the corresponding tab selected?
    DockTabWantClose:                   bool #align 1; /* 1 bits */
    DockOrder:                          s16; // Order of the last time the window was visible within its DockNode. This is used to reorder windows that are reappearing on the same frame. Same value between windows that were active and windows that were none are possible.
    DockStyle:                          WindowDockStyle;
    DockNode_:                          *DockNode; // Which node are we docked into. Important: Prefer testing DockIsActive in many cases as this will still be set when the dock node is hidden.
    DockNodeAsHost:                     *DockNode; // Which node are we owning (for parent windows)
    DockId:                             ID; // Backup of last valid DockNode->ID, so single window remember their dock node id even when they are not bound any more
    DockTabItemStatusFlags:             ItemStatusFlags;
    DockTabItemRect:                    ImRect;

    Constructor :: (this: *Window, _context: *Context, name: *u8) -> void #cpp_method #foreign imgui "_ZN11ImGuiWindowC1EP12ImGuiContextPKc";
    Destructor_Base :: (this: *Window) -> void #cpp_method #foreign imgui "_ZN11ImGuiWindowD2Ev";
    Destructor :: (this: *Window) -> void #cpp_method #foreign imgui "_ZN11ImGuiWindowD1Ev";

    GetID :: (this: *Window, str: *u8, str_end: *u8 = null) -> ID #cpp_method #foreign imgui "_ZN11ImGuiWindow5GetIDEPKcS1_";
    GetID :: (this: *Window, str: string) -> ID #no_context {
        return GetID(this, str.data, str.data + str.count);
    }
    GetID :: (this: *Window, ptr: *void) -> ID #cpp_method #foreign imgui "_ZN11ImGuiWindow5GetIDEPKv";
    GetID :: (this: *Window, n: s32) -> ID #cpp_method #foreign imgui "_ZN11ImGuiWindow5GetIDEi";
    GetIDFromRectangle :: (this: *Window, r_abs: *ImRect) -> ID #cpp_method #foreign imgui "_ZN11ImGuiWindow18GetIDFromRectangleERK6ImRect";
    GetIDFromRectangle :: (this: *Window, r_abs: ImRect) -> ID #no_context {
        return GetIDFromRectangle(this, *r_abs);
    }

    TitleBarRect :: (this: *Window) -> ImRect #cpp_method #foreign imgui "_ZNK11ImGuiWindow12TitleBarRectEv";
}

// Extend ImGuiTabBarFlags_
TabBarFlagsPrivate_ :: enum u32 {
    TabBarFlags_DockNode     :: 1048576;
    TabBarFlags_IsFocused    :: 2097152;
    TabBarFlags_SaveSettings :: 4194304;

    ImGuiTabBarFlags_DockNode     :: TabBarFlags_DockNode;
    ImGuiTabBarFlags_IsFocused    :: TabBarFlags_IsFocused;
    ImGuiTabBarFlags_SaveSettings :: TabBarFlags_SaveSettings;
}

// Extend ImGuiTabItemFlags_
TabItemFlagsPrivate_ :: enum u32 {
    TabItemFlags_SectionMask_  :: 192;
    TabItemFlags_NoCloseButton :: 1048576;
    TabItemFlags_Button        :: 2097152;
    TabItemFlags_Unsorted      :: 4194304;

    ImGuiTabItemFlags_SectionMask_  :: TabItemFlags_SectionMask_;
    ImGuiTabItemFlags_NoCloseButton :: TabItemFlags_NoCloseButton;
    ImGuiTabItemFlags_Button        :: TabItemFlags_Button;
    ImGuiTabItemFlags_Unsorted      :: TabItemFlags_Unsorted;
}

// Storage for one active tab item (sizeof() 48 bytes)
TabItem :: struct {
    ID_:               ID;
    Flags:             TabItemFlags;
    Window_:           *Window; // When TabItem is part of a DockNode's TabBar, we hold on to a window.
    LastFrameVisible:  s32;
    LastFrameSelected: s32; // This allows us to infer an ordered list of the last activated tabs with little maintenance
    Offset:            float; // Position relative to beginning of tab
    Width:             float; // Width currently displayed
    ContentWidth:      float; // Width of label, stored during BeginTabItem() call
    RequestedWidth:    float; // Width optionally requested by caller, -1.0f is unused
    NameOffset:        ImS32; // When Window==NULL, offset to name within parent ImGuiTabBar::TabsNames
    BeginOrder:        ImS16; // BeginTabItem() order, used to re-order tabs after toggling ImGuiTabBarFlags_Reorderable
    IndexDuringLayout: ImS16; // Index only used during TabBarLayout(). Tabs gets reordered so 'Tabs[n].IndexDuringLayout == n' but may mismatch during additions.
    WantClose:         bool; // Marked as closed by SetTabItemClosed()
}

// Storage for a tab bar (sizeof() 152 bytes)
TabBar :: struct {
    Tabs:                            ImVector(TabItem);
    Flags:                           TabBarFlags;
    ID_:                             ID; // Zero for tab-bars used by docking
    SelectedTabId:                   ID; // Selected tab/window
    NextSelectedTabId:               ID; // Next selected tab/window. Will also trigger a scrolling animation
    VisibleTabId:                    ID; // Can occasionally be != SelectedTabId (e.g. when previewing contents for CTRL+TAB preview)
    CurrFrameVisible:                s32;
    PrevFrameVisible:                s32;
    BarRect:                         ImRect;
    CurrTabsContentsHeight:          float;
    PrevTabsContentsHeight:          float; // Record the height of contents submitted below the tab bar
    WidthAllTabs:                    float; // Actual width of all tabs (locked during layout)
    WidthAllTabsIdeal:               float; // Ideal width if all tabs were visible and not clipped
    ScrollingAnim:                   float;
    ScrollingTarget:                 float;
    ScrollingTargetDistToVisibility: float;
    ScrollingSpeed:                  float;
    ScrollingRectMinX:               float;
    ScrollingRectMaxX:               float;
    SeparatorMinX:                   float;
    SeparatorMaxX:                   float;
    ReorderRequestTabId:             ID;
    ReorderRequestOffset:            ImS16;
    BeginCount:                      ImS8;
    WantLayout:                      bool;
    VisibleTabWasSubmitted:          bool;
    TabsAddedNew:                    bool; // Set to true when a new tab item or button has been added to the tab bar during last frame
    TabsActiveCount:                 ImS16; // Number of tabs submitted this frame.
    LastTabItemIdx:                  ImS16; // Index of last BeginTabItem() tab for use by EndTabItem()
    ItemSpacingY:                    float;
    FramePadding:                    ImVec2; // style.FramePadding locked at the time of BeginTabBar()
    BackupCursorPos:                 ImVec2;
    TabsNames:                       TextBuffer; // For non-docking tab bar we re-append names in a contiguous buffer.

    Constructor :: (this: *TabBar) -> void #cpp_method #foreign imgui "_ZN11ImGuiTabBarC1Ev";
}

// Our current column maximum is 64 but we may raise that in the future.
TableColumnIdx :: ImS16;
TableDrawChannelIdx :: ImU16;

// [Internal] sizeof() ~ 112
// We use the terminology "Enabled" to refer to a column that is not Hidden by user/api.
// We use the terminology "Clipped" to refer to a column that is out of sight because of scrolling/clipping.
// This is in contrast with some user-facing api such as IsItemVisible() / IsRectVisible() which use "Visible" to mean "not clipped".
TableColumn :: struct {
    Flags:                    TableColumnFlags; // Flags after some patching (not directly same as provided by user). See ImGuiTableColumnFlags_
    WidthGiven:               float; // Final/actual width visible == (MaxX - MinX), locked in TableUpdateLayout(). May be > WidthRequest to honor minimum width, may be < WidthRequest to honor shrinking columns down in tight space.
    MinX:                     float; // Absolute positions
    MaxX:                     float;
    WidthRequest:             float; // Master width absolute value when !(Flags & _WidthStretch). When Stretch this is derived every frame from StretchWeight in TableUpdateLayout()
    WidthAuto:                float; // Automatic width
    StretchWeight:            float; // Master width weight when (Flags & _WidthStretch). Often around ~1.0f initially.
    InitStretchWeightOrWidth: float; // Value passed to TableSetupColumn(). For Width it is a content width (_without padding_).
    ClipRect:                 ImRect; // Clipping rectangle for the column
    UserID:                   ID; // Optional, value passed to TableSetupColumn()
    WorkMinX:                 float; // Contents region min ~(MinX + CellPaddingX + CellSpacingX1) == cursor start position when entering column
    WorkMaxX:                 float; // Contents region max ~(MaxX - CellPaddingX - CellSpacingX2)
    ItemWidth:                float; // Current item width for the column, preserved across rows
    ContentMaxXFrozen:        float; // Contents maximum position for frozen rows (apart from headers), from which we can infer content width.
    ContentMaxXUnfrozen:      float;
    ContentMaxXHeadersUsed:   float; // Contents maximum position for headers rows (regardless of freezing). TableHeader() automatically softclip itself + report ideal desired size, to avoid creating extraneous draw calls
    ContentMaxXHeadersIdeal:  float;
    NameOffset:               ImS16; // Offset into parent ColumnsNames[]
    DisplayOrder:             TableColumnIdx; // Index within Table's IndexToDisplayOrder[] (column may be reordered by users)
    IndexWithinEnabledSet:    TableColumnIdx; // Index within enabled/visible set (<= IndexToDisplayOrder)
    PrevEnabledColumn:        TableColumnIdx; // Index of prev enabled/visible column within Columns[], -1 if first enabled/visible column
    NextEnabledColumn:        TableColumnIdx; // Index of next enabled/visible column within Columns[], -1 if last enabled/visible column
    SortOrder:                TableColumnIdx; // Index of this column within sort specs, -1 if not sorting on this column, 0 for single-sort, may be >0 on multi-sort
    DrawChannelCurrent:       TableDrawChannelIdx; // Index within DrawSplitter.Channels[]
    DrawChannelFrozen:        TableDrawChannelIdx; // Draw channels for frozen rows (often headers)
    DrawChannelUnfrozen:      TableDrawChannelIdx; // Draw channels for unfrozen rows
    IsEnabled:                bool; // IsUserEnabled && (Flags & ImGuiTableColumnFlags_Disabled) == 0
    IsUserEnabled:            bool; // Is the column not marked Hidden by the user? (unrelated to being off view, e.g. clipped by scrolling).
    IsUserEnabledNextFrame:   bool;
    IsVisibleX:               bool; // Is actually in view (e.g. overlapping the host window clipping rectangle, not scrolled).
    IsVisibleY:               bool;
    IsRequestOutput:          bool; // Return value for TableSetColumnIndex() / TableNextColumn(): whether we request user to output contents or not.
    IsSkipItems:              bool; // Do we want item submissions to this column to be completely ignored (no layout will happen).
    IsPreserveWidthAuto:      bool;
    NavLayerCurrent:          ImS8; // ImGuiNavLayer in 1 byte
    AutoFitQueue:             ImU8; // Queue of 8 values for the next 8 frames to request auto-fit
    CannotSkipItemsQueue:     ImU8; // Queue of 8 values for the next 8 frames to disable Clipped/SkipItem
    __bitfield:               ImU8;
    /* 
        SortDirection: ImU8; /* 2 bits */ // ImGuiSortDirection_Ascending or ImGuiSortDirection_Descending
        SortDirectionsAvailCount: ImU8; /* 2 bits */ // Number of available sort directions (0 to 3)
        SortDirectionsAvailMask: ImU8; /* 4 bits */ // Mask of available sort directions (1-bit each);
    */

    SortDirectionsAvailList:  ImU8; // Ordered list of available sort directions (2-bits each, total 8-bits)
}

// Transient cell data stored per row.
// sizeof() ~ 6
TableCellData :: struct {
    BgColor: ImU32; // Actual color
    Column:  TableColumnIdx; // Column number
}

// Per-instance data that needs preserving across frames (seemingly most others do not need to be preserved aside from debug needs. Does that means they could be moved to ImGuiTableTempData?)
// sizeof() ~ 24 bytes
TableInstanceData :: struct {
    TableInstanceID:         ID;
    LastOuterHeight:         float; // Outer height from last frame
    LastTopHeadersRowHeight: float; // Height of first consecutive header rows from last frame (FIXME: this is used assuming consecutive headers are in same frozen set)
    LastFrozenHeight:        float; // Height of frozen section from last frame
    HoveredRowLast:          s32; // Index of row which was hovered last frame.
    HoveredRowNext:          s32; // Index of row hovered this frame, set after encountering it.
}

// FIXME-TABLE: more transient data could be stored in a stacked ImGuiTableTempData: e.g. SortSpecs, incoming RowData
// sizeof() ~ 580 bytes + heap allocs described in TableBeginInitMemory()
Table :: struct {
    ID_:                        ID;
    Flags:                      TableFlags;
    RawData:                    *void; // Single allocation to hold Columns[], DisplayOrderToIndex[] and RowCellData[]
    TempData:                   *TableTempData; // Transient data while table is active. Point within g.CurrentTableStack[]
    Columns:                    ImSpan(TableColumn); // Point within RawData[]
    DisplayOrderToIndex:        ImSpan(TableColumnIdx); // Point within RawData[]. Store display order of columns (when not reordered, the values are 0...Count-1)
    RowCellData:                ImSpan(TableCellData); // Point within RawData[]. Store cells background requests for current row.
    EnabledMaskByDisplayOrder:  ImBitArrayPtr; // Column DisplayOrder -> IsEnabled map
    EnabledMaskByIndex:         ImBitArrayPtr; // Column Index -> IsEnabled map (== not hidden by user/api) in a format adequate for iterating column without touching cold data
    VisibleMaskByIndex:         ImBitArrayPtr; // Column Index -> IsVisibleX|IsVisibleY map (== not hidden by user/api && not hidden by scrolling/cliprect)
    SettingsLoadedFlags:        TableFlags; // Which data were loaded from the .ini file (e.g. when order is not altered we won't save order)
    SettingsOffset:             s32; // Offset in g.SettingsTables
    LastFrameActive:            s32;
    ColumnsCount:               s32; // Number of columns declared in BeginTable()
    CurrentRow:                 s32;
    CurrentColumn:              s32;
    InstanceCurrent:            ImS16; // Count of BeginTable() calls with same ID in the same frame (generally 0). This is a little bit similar to BeginCount for a window, but multiple table with same ID look are multiple tables, they are just synched.
    InstanceInteracted:         ImS16; // Mark which instance (generally 0) of the same ID is being interacted with
    RowPosY1:                   float;
    RowPosY2:                   float;
    RowMinHeight:               float; // Height submitted to TableNextRow()
    RowCellPaddingY:            float; // Top and bottom padding. Reloaded during row change.
    RowTextBaseline:            float;
    RowIndentOffsetX:           float;
    __bitfield:                 TableRowFlags;
    /* 
        RowFlags: TableRowFlags; /* 16 bits */ // Current row flags, see ImGuiTableRowFlags_
        LastRowFlags: TableRowFlags; /* 16 bits */;
    */

    RowBgColorCounter:          s32; // Counter for alternating background colors (can be fast-forwarded by e.g clipper), not same as CurrentRow because header rows typically don't increase this.
    RowBgColor:                 [2] ImU32; // Background color override for current row.
    BorderColorStrong:          ImU32;
    BorderColorLight:           ImU32;
    BorderX1:                   float;
    BorderX2:                   float;
    HostIndentX:                float;
    MinColumnWidth:             float;
    OuterPaddingX:              float;
    CellPaddingX:               float; // Padding from each borders. Locked in BeginTable()/Layout.
    CellSpacingX1:              float; // Spacing between non-bordered cells. Locked in BeginTable()/Layout.
    CellSpacingX2:              float;
    InnerWidth:                 float; // User value passed to BeginTable(), see comments at the top of BeginTable() for details.
    ColumnsGivenWidth:          float; // Sum of current column width
    ColumnsAutoFitWidth:        float; // Sum of ideal column width in order nothing to be clipped, used for auto-fitting and content width submission in outer window
    ColumnsStretchSumWeights:   float; // Sum of weight of all enabled stretching columns
    ResizedColumnNextWidth:     float;
    ResizeLockMinContentsX2:    float; // Lock minimum contents width while resizing down in order to not create feedback loops. But we allow growing the table.
    RefScale:                   float; // Reference scale to be able to rescale columns on font/dpi changes.
    AngledHeadersHeight:        float; // Set by TableAngledHeadersRow(), used in TableUpdateLayout()
    AngledHeadersSlope:         float; // Set by TableAngledHeadersRow(), used in TableUpdateLayout()
    OuterRect:                  ImRect; // Note: for non-scrolling table, OuterRect.Max.y is often FLT_MAX until EndTable(), unless a height has been specified in BeginTable().
    InnerRect:                  ImRect; // InnerRect but without decoration. As with OuterRect, for non-scrolling tables, InnerRect.Max.y is
    WorkRect:                   ImRect;
    InnerClipRect:              ImRect;
    BgClipRect:                 ImRect; // We use this to cpu-clip cell background color fill, evolve during the frame as we cross frozen rows boundaries
    Bg0ClipRectForDrawCmd:      ImRect; // Actual ImDrawCmd clip rect for BG0/1 channel. This tends to be == OuterWindow->ClipRect at BeginTable() because output in BG0/BG1 is cpu-clipped
    Bg2ClipRectForDrawCmd:      ImRect; // Actual ImDrawCmd clip rect for BG2 channel. This tends to be a correct, tight-fit, because output to BG2 are done by widgets relying on regular ClipRect.
    HostClipRect:               ImRect; // This is used to check if we can eventually merge our columns draw calls into the current draw call of the current window.
    HostBackupInnerClipRect:    ImRect; // Backup of InnerWindow->ClipRect during PushTableBackground()/PopTableBackground()
    OuterWindow:                *Window; // Parent window for the table
    InnerWindow:                *Window; // Window holding the table data (== OuterWindow or a child window)
    ColumnsNames:               TextBuffer; // Contiguous buffer holding columns names
    DrawSplitter:               *ImDrawListSplitter; // Shortcut to TempData->DrawSplitter while in table. Isolate draw commands per columns to avoid switching clip rect constantly
    InstanceDataFirst:          TableInstanceData;
    InstanceDataExtra:          ImVector(TableInstanceData); // FIXME-OPT: Using a small-vector pattern would be good.
    SortSpecsSingle:            TableColumnSortSpecs;
    SortSpecsMulti:             ImVector(TableColumnSortSpecs); // FIXME-OPT: Using a small-vector pattern would be good.
    SortSpecs:                  TableSortSpecs; // Public facing sorts specs, this is what we return in TableGetSortSpecs()
    SortSpecsCount:             TableColumnIdx;
    ColumnsEnabledCount:        TableColumnIdx; // Number of enabled columns (<= ColumnsCount)
    ColumnsEnabledFixedCount:   TableColumnIdx; // Number of enabled columns (<= ColumnsCount)
    DeclColumnsCount:           TableColumnIdx; // Count calls to TableSetupColumn()
    AngledHeadersCount:         TableColumnIdx; // Count columns with angled headers
    HoveredColumnBody:          TableColumnIdx; // Index of column whose visible region is being hovered. Important: == ColumnsCount when hovering empty region after the right-most column!
    HoveredColumnBorder:        TableColumnIdx; // Index of column whose right-border is being hovered (for resizing).
    HighlightColumnHeader:      TableColumnIdx; // Index of column which should be highlighted.
    AutoFitSingleColumn:        TableColumnIdx; // Index of single column requesting auto-fit.
    ResizedColumn:              TableColumnIdx; // Index of column being resized. Reset when InstanceCurrent==0.
    LastResizedColumn:          TableColumnIdx; // Index of column being resized from previous frame.
    HeldHeaderColumn:           TableColumnIdx; // Index of column header being held.
    ReorderColumn:              TableColumnIdx; // Index of column being reordered. (not cleared)
    ReorderColumnDir:           TableColumnIdx; // -1 or +1
    LeftMostEnabledColumn:      TableColumnIdx; // Index of left-most non-hidden column.
    RightMostEnabledColumn:     TableColumnIdx; // Index of right-most non-hidden column.
    LeftMostStretchedColumn:    TableColumnIdx; // Index of left-most stretched column.
    RightMostStretchedColumn:   TableColumnIdx; // Index of right-most stretched column.
    ContextPopupColumn:         TableColumnIdx; // Column right-clicked on, of -1 if opening context menu from a neutral/empty spot
    FreezeRowsRequest:          TableColumnIdx; // Requested frozen rows count
    FreezeRowsCount:            TableColumnIdx; // Actual frozen row count (== FreezeRowsRequest, or == 0 when no scrolling offset)
    FreezeColumnsRequest:       TableColumnIdx; // Requested frozen columns count
    FreezeColumnsCount:         TableColumnIdx; // Actual frozen columns count (== FreezeColumnsRequest, or == 0 when no scrolling offset)
    RowCellDataCurrent:         TableColumnIdx; // Index of current RowCellData[] entry in current row
    DummyDrawChannel:           TableDrawChannelIdx; // Redirect non-visible columns here.
    Bg2DrawChannelCurrent:      TableDrawChannelIdx; // For Selectable() and other widgets drawing across columns after the freezing line. Index within DrawSplitter.Channels[]
    Bg2DrawChannelUnfrozen:     TableDrawChannelIdx;
    IsLayoutLocked:             bool; // Set by TableUpdateLayout() which is called when beginning the first row.
    IsInsideRow:                bool; // Set when inside TableBeginRow()/TableEndRow().
    IsInitializing:             bool;
    IsSortSpecsDirty:           bool;
    IsUsingHeaders:             bool; // Set when the first row had the ImGuiTableRowFlags_Headers flag.
    IsContextPopupOpen:         bool; // Set when default context menu is open (also see: ContextPopupColumn, InstanceInteracted).
    DisableDefaultContextMenu:  bool; // Disable default context menu contents. You may submit your own using TableBeginContextMenuPopup()/EndPopup()
    IsSettingsRequestLoad:      bool;
    IsSettingsDirty:            bool; // Set when table settings have changed and needs to be reported into ImGuiTableSetttings data.
    IsDefaultDisplayOrder:      bool; // Set when display order is unchanged from default (DisplayOrder contains 0...Count-1)
    IsResetAllRequest:          bool;
    IsResetDisplayOrderRequest: bool;
    IsUnfrozenRows:             bool; // Set when we got past the frozen row.
    IsDefaultSizingPolicy:      bool; // Set if user didn't explicitly set a sizing policy in BeginTable()
    IsActiveIdAliveBeforeTable: bool;
    IsActiveIdInTable:          bool;
    HasScrollbarYCurr:          bool; // Whether ANY instance of this table had a vertical scrollbar during the current frame.
    HasScrollbarYPrev:          bool; // Whether ANY instance of this table had a vertical scrollbar during the previous.
    MemoryCompacted:            bool;
    HostSkipItems:              bool; // Backup of InnerWindow->SkipItem at the end of BeginTable(), because we will overwrite InnerWindow->SkipItem on a per-column basis
}

// Transient data that are only needed between BeginTable() and EndTable(), those buffers are shared (1 per level of stacked table).
// - Accessing those requires chasing an extra pointer so for very frequently used data we leave them in the main table structure.
// - We also leave out of this structure data that tend to be particularly useful for debugging/metrics.
// sizeof() ~ 120 bytes.
TableTempData :: struct {
    TableIndex:                   s32; // Index in g.Tables.Buf[] pool
    LastTimeActive:               float; // Last timestamp this structure was used
    AngledHeadersExtraWidth:      float; // Used in EndTable()

    UserOuterSize:                ImVec2; // outer_size.x passed to BeginTable()
    DrawSplitter:                 ImDrawListSplitter;

    HostBackupWorkRect:           ImRect; // Backup of InnerWindow->WorkRect at the end of BeginTable()
    HostBackupParentWorkRect:     ImRect; // Backup of InnerWindow->ParentWorkRect at the end of BeginTable()
    HostBackupPrevLineSize:       ImVec2; // Backup of InnerWindow->DC.PrevLineSize at the end of BeginTable()
    HostBackupCurrLineSize:       ImVec2; // Backup of InnerWindow->DC.CurrLineSize at the end of BeginTable()
    HostBackupCursorMaxPos:       ImVec2; // Backup of InnerWindow->DC.CursorMaxPos at the end of BeginTable()
    HostBackupColumnsOffset:      ImVec1; // Backup of OuterWindow->DC.ColumnsOffset at the end of BeginTable()
    HostBackupItemWidth:          float; // Backup of OuterWindow->DC.ItemWidth at the end of BeginTable()
    HostBackupItemWidthStackSize: s32; //Backup of OuterWindow->DC.ItemWidthStack.Size at the end of BeginTable()
}

// sizeof() ~ 12
TableColumnSettings :: struct {
    WidthOrWeight: float;
    UserID:        ID;
    Index:         TableColumnIdx;
    DisplayOrder:  TableColumnIdx;
    SortOrder:     TableColumnIdx;
    __bitfield:    ImU8;
    /* 
        SortDirection: ImU8; /* 2 bits */
        IsEnabled: ImU8; /* 1 bits */ // "Visible" in ini file
        IsStretch: ImU8; /* 1 bits */;
    */
}

// This is designed to be stored in a single ImChunkStream (1 header followed by N ImGuiTableColumnSettings, etc.)
TableSettings :: struct {
    ID_:             ID; // Set to 0 to invalidate/delete the setting
    SaveFlags:       TableFlags; // Indicate data we want to save using the Resizable/Reorderable/Sortable/Hideable flags (could be using its own flags..)
    RefScale:        float; // Reference scale to be able to rescale columns on font/dpi changes.
    ColumnsCount:    TableColumnIdx;
    ColumnsCountMax: TableColumnIdx; // Maximum number of columns this settings instance can store, we can recycle a settings instance with lower number of columns but not higher
    WantApply:       bool; // Set when loaded from .ini data (to enable merging/loading .ini data into an already running context)
}

// This structure is likely to evolve as we add support for incremental atlas updates
ImFontBuilderIO :: struct {
    FontBuilder_Build: #type (atlas: *ImFontAtlas) -> bool #c_call;
}

ImFontAtlasGetBuilderForStbTruetype :: () -> *ImFontBuilderIO #foreign imgui "_Z35ImFontAtlasGetBuilderForStbTruetypev";

ImFontAtlasUpdateConfigDataPointers :: (atlas: *ImFontAtlas) -> void #foreign imgui "_Z35ImFontAtlasUpdateConfigDataPointersP11ImFontAtlas";
ImFontAtlasBuildInit :: (atlas: *ImFontAtlas) -> void #foreign imgui "_Z20ImFontAtlasBuildInitP11ImFontAtlas";
ImFontAtlasBuildSetupFont :: (atlas: *ImFontAtlas, font: *ImFont, font_config: *ImFontConfig, ascent: float, descent: float) -> void #foreign imgui "_Z25ImFontAtlasBuildSetupFontP11ImFontAtlasP6ImFontP12ImFontConfigff";
ImFontAtlasBuildPackCustomRects :: (atlas: *ImFontAtlas, stbrp_context_opaque: *void) -> void #foreign imgui "_Z31ImFontAtlasBuildPackCustomRectsP11ImFontAtlasPv";
ImFontAtlasBuildFinish :: (atlas: *ImFontAtlas) -> void #foreign imgui "_Z22ImFontAtlasBuildFinishP11ImFontAtlas";
ImFontAtlasBuildRender8bppRectFromString :: (atlas: *ImFontAtlas, x: s32, y: s32, w: s32, h: s32, in_str: *u8, in_marker_char: u8, in_marker_pixel_value: u8) -> void #foreign imgui "_Z40ImFontAtlasBuildRender8bppRectFromStringP11ImFontAtlasiiiiPKcch";
ImFontAtlasBuildRender32bppRectFromString :: (atlas: *ImFontAtlas, x: s32, y: s32, w: s32, h: s32, in_str: *u8, in_marker_char: u8, in_marker_pixel_value: u32) -> void #foreign imgui "_Z41ImFontAtlasBuildRender32bppRectFromStringP11ImFontAtlasiiiiPKccj";
ImFontAtlasBuildMultiplyCalcLookupTable :: (out_table: *[256] u8, in_multiply_factor: float) -> void #foreign imgui "_Z39ImFontAtlasBuildMultiplyCalcLookupTablePhf";
ImFontAtlasBuildMultiplyRectAlpha8 :: (table: *[256] u8, pixels: *u8, x: s32, y: s32, w: s32, h: s32, stride: s32) -> void #foreign imgui "_Z34ImFontAtlasBuildMultiplyRectAlpha8PKhPhiiiii";

#scope_file

#import "Basic"; // For push_context

imgui :: #library "linux/ImGui";
