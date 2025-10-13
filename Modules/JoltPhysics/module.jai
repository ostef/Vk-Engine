// Jolt v5.3.0

#if OS == {
case .WINDOWS;
    #load "jolt_windows.jai";

    Jolt :: #library,no_dll,link_always "Lib/Windows/Jolt";

case .LINUX;
    #load "jolt_linux.jai";
case .MACOS;
    #load "jolt_macos.jai";
}
