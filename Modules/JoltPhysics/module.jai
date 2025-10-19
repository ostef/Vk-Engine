// Jolt v5.3.0

#import "Math";

Vec3 :: Vector3;
Vec4 :: Vector4;
Quat :: Quaternion;

#if OS == .WINDOWS {
    #load "jolt_windows.jai";

    #scope_module
    Jolt :: #library,link_always "Lib/Windows/Jolt";
    #scope_export
} else #if OS == .LINUX {
    #load "jolt_linux.jai";

    #scope_module
    Jolt :: #library,no_static_library,link_always "Lib/Linux/libJolt";
    #scope_export
} else #if OS == .MACOS {
    #load "jolt_macos.jai";

    #scope_module
    Jolt :: #library,no_static_library,link_always "Lib/MacOS/libJolt";
    #scope_export
}
