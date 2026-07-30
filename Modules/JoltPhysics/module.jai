UVec4 :: struct {
    x: u32 #align VECTOR_ALIGNMENT;
    y: u32;
    z: u32;
    w: u32;

    #overlay(x)
    values: [4]u32;
}

Vec3 :: struct {
    x: float #align VECTOR_ALIGNMENT;
    y: float;
    z: float;

    #overlay(x)
    values: [4]float;

    Make :: (x : float, y : float, z : float) -> Vec3 #foreign JoltC "JPH_Vec3_Make";
}

Vec4 :: struct {
    x: float #align VECTOR_ALIGNMENT;
    y: float;
    z: float;
    w: float;

    #overlay(x)
    values: [4]float;
}

Mat44 :: struct {
    cols: [4] Vec4;
}

DVec3 :: union {
    x: float64 #align DVECTOR_ALIGNMENT;
    y: float64;
    z: float64;

    #overlay(x)
    values: [4] float64;

    Make :: (x : float64, y : float64, z : float64) -> DVec3 #foreign JoltC "JPH_DVec3_Make";
}

DMat44 :: struct {
    cols: [3] Vec4;
    col3: DVec3;
}

Quat :: struct {
    x: float #align VECTOR_ALIGNMENT;
    y: float;
    z: float;
    w: float = 1;

    #overlay(x)
    values: [4]float;
}

#if OS == .LINUX {
    JoltC :: #library "./Libs/Linux/libJoltC";

    #load "jolt_linux.jai";
} else #if OS == .WINDOWS {
    #load "jolt_windows.jai";
}

#if !#exists(DOUBLE_PRECISION) {
    DOUBLE_PRECISION :: 0;
}
#if !#exists(CROSS_PLATFORM_DETERMINISTIC) {
    CROSS_PLATFORM_DETERMINISTIC :: 0;
}
#if !#exists(FLOATING_POINT_EXCEPTIONS_ENABLED) {
    FLOATING_POINT_EXCEPTIONS_ENABLED :: 0;
}
#if !#exists(PROFILE_ENABLED) {
    PROFILE_ENABLED :: 0;
}
#if !#exists(EXTERNAL_PROFILE) {
    EXTERNAL_PROFILE :: 0;
}
#if !#exists(DEBUG_RENDERER) {
    DEBUG_RENDERER :: 0;
}
#if !#exists(DISABLE_TEMP_ALLOCATOR) {
    DISABLE_TEMP_ALLOCATOR :: 0;
}
#if !#exists(DISABLE_CUSTOM_ALLOCATOR) {
    DISABLE_CUSTOM_ALLOCATOR :: 0;
}
#if !#exists(OBJECT_LAYER_BITS) {
    OBJECT_LAYER_BITS :: 16;
}
#if !#exists(ENABLE_ASSERTS) {
    ENABLE_ASSERTS :: 0;
}
#if !#exists(OBJECT_STREAM) {
    OBJECT_STREAM :: 0;
}

VERSION_FEATURES :: cast(u64, VERSION_FEATURE_BIT_1) | (VERSION_FEATURE_BIT_2 << 1) | (VERSION_FEATURE_BIT_3 << 2) | (VERSION_FEATURE_BIT_4 << 3) | (VERSION_FEATURE_BIT_5 << 4) | (VERSION_FEATURE_BIT_6 << 5) | (VERSION_FEATURE_BIT_7 << 6) | (VERSION_FEATURE_BIT_8 << 7) | (VERSION_FEATURE_BIT_9 << 8) | (VERSION_FEATURE_BIT_10 << 9) | (VERSION_FEATURE_BIT_11 << 10);
