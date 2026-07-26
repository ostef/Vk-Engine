UVec4 :: struct {
    x: u32 #align JOLTC_VECTOR_ALIGNMENT;
    y: u32;
    z: u32;
    w: u32;

    #overlay(x)
    values: [4]u32;
}

Vec3 :: struct {
    x: float #align JOLTC_VECTOR_ALIGNMENT;
    y: float;
    z: float;

    #overlay(x)
    values: [4]float;
}

Vec4 :: struct {
    x: float #align JOLTC_VECTOR_ALIGNMENT;
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
    x: float64 #align JOLTC_DVECTOR_ALIGNMENT;
    y: float64;
    z: float64;

    #overlay(x)
    values: [4] float64;
}

DMat44 :: struct {
    cols: [3] Vec4;
    col3: DVec3;
}

Quat :: struct {
    x: float #align JOLTC_VECTOR_ALIGNMENT;
    y: float;
    z: float;
    w: float;

    #overlay(x)
    values: [4]float;
}

AABox :: struct {
    min: Vec3;
    max: Vec3;
}

Plane :: struct {
    normalAndConstant: Vec4;
}

#if OS == .LINUX {
    #load "jolt_linux.jai";
}

#if #exists(JPH_DOUBLE_PRECISION) {
    DOUBLE_PRECISION :: JPH_DOUBLE_PRECISION == 1;
} else {
    DOUBLE_PRECISION :: false;
}
#if #exists(JPH_CROSS_PLATFORM_DETERMINISTIC) {
    CROSS_PLATFORM_DETERMINISTIC :: JPH_CROSS_PLATFORM_DETERMINISTIC == 1;
} else {
    CROSS_PLATFORM_DETERMINISTIC :: false;
}
#if #exists(JPH_FLOATING_POINT_EXCEPTIONS_ENABLED) {
    FLOATING_POINT_EXCEPTIONS_ENABLED :: JPH_FLOATING_POINT_EXCEPTIONS_ENABLED == 1;
} else {
    FLOATING_POINT_EXCEPTIONS_ENABLED :: false;
}
#if #exists(JPH_PROFILE_ENABLED) {
    PROFILE_ENABLED :: JPH_PROFILE_ENABLED == 1;
} else {
    PROFILE_ENABLED :: false;
}
#if #exists(JPH_EXTERNAL_PROFILE) {
    EXTERNAL_PROFILE :: JPH_EXTERNAL_PROFILE == 1;
} else {
    EXTERNAL_PROFILE :: false;
}
#if #exists(JPH_DEBUG_RENDERER) {
    DEBUG_RENDERER :: JPH_DEBUG_RENDERER == 1;
} else {
    DEBUG_RENDERER :: false;
}
#if #exists(JPH_DISABLE_TEMP_ALLOCATOR) {
    DISABLE_TEMP_ALLOCATOR :: JPH_DISABLE_TEMP_ALLOCATOR == 1;
} else {
    DISABLE_TEMP_ALLOCATOR :: false;
}
#if #exists(JPH_DISABLE_CUSTOM_ALLOCATOR) {
    DISABLE_CUSTOM_ALLOCATOR :: JPH_DISABLE_CUSTOM_ALLOCATOR == 1;
} else {
    DISABLE_CUSTOM_ALLOCATOR :: false;
}
#if #exists(JPH_OBJECT_LAYER_BITS) {
    OBJECT_LAYER_BITS :: JPH_OBJECT_LAYER_BITS;
} else {
    OBJECT_LAYER_BITS :: 16;
}
#if #exists(JPH_ENABLE_ASSERTS) {
    ENABLE_ASSERTS :: JPH_ENABLE_ASSERTS == 1;
} else {
    ENABLE_ASSERTS :: false;
}
#if #exists(JPH_OBJECT_STREAM) {
    OBJECT_STREAM :: JPH_OBJECT_STREAM == 1;
} else {
    OBJECT_STREAM :: false;
}

JOLTC_VERSION_FEATURES :: cast(u64, JOLTC_VERSION_FEATURE_BIT_1) | (JOLTC_VERSION_FEATURE_BIT_2 << 1) | (JOLTC_VERSION_FEATURE_BIT_3 << 2) | (JOLTC_VERSION_FEATURE_BIT_4 << 3) | (JOLTC_VERSION_FEATURE_BIT_5 << 4) | (JOLTC_VERSION_FEATURE_BIT_6 << 5) | (JOLTC_VERSION_FEATURE_BIT_7 << 6) | (JOLTC_VERSION_FEATURE_BIT_8 << 7) | (JOLTC_VERSION_FEATURE_BIT_9 << 8) | (JOLTC_VERSION_FEATURE_BIT_10 << 9) | (JOLTC_VERSION_FEATURE_BIT_11 << 10);
