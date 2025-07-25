#ifndef COMMON_GLSL
#define COMMON_GLSL

#define float2 vec2
#define float3 vec3
#define float4 vec4
#define float3x3 mat3
#define float4x4 mat4
#define double2 dvec2
#define double3 dvec3
#define double4 dvec4
#define double3x3 dmat3
#define double4x4 dmat4
#define int2 ivec2
#define int3 ivec3
#define int4 ivec4
#define uint2 uvec2
#define uint3 uvec3
#define uint4 uvec4

#include "shader_types.generated.glsl"

#define Max_Shadow_Maps 2

#define DECLARE_STATIC_VERTEX_ATTRIBUTES() \
    layout(location=0) in float3 v_position; \
    layout(location=1) in float3 v_normal; \
    layout(location=2) in float4 v_tangent; \
    layout(location=3) in float2 v_tex_coords

#ifdef SHADER_STAGE_VERTEX
#define DECLARE_PER_FRAME_PARAMS() \
    layout(set=0, binding=0, std140) uniform FrameData { \
        FrameInfo u_frame_info; \
    }
#endif

#ifdef SHADER_STAGE_FRAGMENT
#define DECLARE_PER_FRAME_PARAMS() \
    layout(set=0, binding=0, std140) uniform FrameData { \
        FrameInfo u_frame_info; \
    }; \
    layout(set=0, binding=1, std430) readonly buffer DirectionalLights { \
        DirectionalLight u_directional_lights[]; \
    }; \
    layout(set=0, binding=2, std430) readonly buffer PointLights { \
        PointLight u_point_lights[]; \
    }; \
    layout(set=0, binding=3) uniform sampler2D u_brdf_lut ; \
    layout(set=0, binding=4) uniform sampler2DArray u_shadow_map_noise_texture
#endif

#define Max_Viewpoints 4

#ifdef SHADER_STAGE_VERTEX
#define DECLARE_FORWARD_PASS_PARAMS() \
    layout(set=1, binding=0) uniform Viewpoints { \
        Viewpoint u_viewpoints[Max_Viewpoints]; \
    }
#endif

#ifdef SHADER_STAGE_FRAGMENT
#define DECLARE_FORWARD_PASS_PARAMS() \
    layout(set=1, binding=0) uniform Viewpoints { \
        Viewpoint u_viewpoints[Max_Viewpoints]; \
    }; \
    layout(set=1, binding=1) uniform sampler2DArrayShadow u_shadow_maps[Max_Shadow_Maps]; \
    layout(set=1, binding=2) uniform sampler2D u_irradiance_map; \
    layout(set=1, binding=3) uniform sampler2D u_environment_map
#endif

#ifdef SHADER_STAGE_VERTEX
#define DECLARE_PER_DRAW_CALL_MESH_PARAMS() \
    layout(set=2, binding=0, std430) readonly buffer MeshData { \
        MeshInstance u_mesh_instances[]; \
    }
#endif

#ifdef SHADER_STAGE_FRAGMENT
#define DECLARE_PER_DRAW_CALL_MESH_PARAMS() \
    layout(set=2, binding=0, std430) readonly buffer MeshData { \
        MeshInstance u_mesh_instances[]; \
    }; \
    layout(set=2, binding=1) uniform sampler2D u_base_color_texture; \
    layout(set=2, binding=2) uniform sampler2D u_normal_map_texture; \
    layout(set=2, binding=3) uniform sampler2D u_metallic_roughness_map_texture; \
    layout(set=2, binding=4) uniform sampler2D u_emissive_texture
#endif

#define Pi 3.14159265359
#define Tau Pi * 2
#define To_Rads Pi / 180.0
#define To_Degs 180.0 / Pi

#define lerp mix

float Acos(float x) {
    return acos(clamp(x, -1.0, 1.0));
}

float Asin(float x) {
    return asin(clamp(x, -1.0, 1.0));
}

#define ApplyToneMapping ApplyACESToneMapping

float3 ApplyReinhardToneMapping(float3 color) {
    return color / (color + float3(1.0));
}

float3 ApplyJodieReinhardToneMapping(float3 color) {
    // From: https://www.shadertoy.com/view/tdSXzD
    float l = dot(color, float3(0.2126, 0.7152, 0.0722));
    float3 tc = color / (color + 1);

    return lerp(color / (l + 1), tc, tc);
}

float3 ApplyACESToneMapping(float3 x) {
    float a = 2.51;
    float b = 0.03;
    float c = 2.43;
    float d = 0.59;
    float e = 0.14;

    return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0, 1);
}

float3 LinearTosRGB(float3 color) {
    return pow(color, float3(1.0 / 2.2));
}

float3 sRGBToLinear(float3 color) {
    return pow(color, float3(2.2));
}

float InverseLerp(float a, float b, float t) {
    return (t - a) / (b - a);
}

float LinearRGBToLuminance(float3 rgb) {
    return dot(clamp(rgb, 0, 1), float3(0.2126729, 0.7151522, 0.0721750));
}

float Random(float seed) {
    return fract(sin(seed * 91.3458) * 47453.5453);
}

float3 RandomColor(float seed) {
    float3 result;
    result.r = Random(seed);
    result.g = Random(result.r);
    result.b = Random(result.g);

    return result;
}

float3 RandomEntityColor(uint4 entity_guid) {
    return RandomColor((entity_guid.x + entity_guid.y + entity_guid.z + entity_guid.w) * 0.0000000001);
}

// Azimuth: 0 = positive Z
// Polar: 0 = horizon, Pi/2 = North, -Pi/2 = South

float2 CartesianToSpherical(float3 direction) {
    float polar = Asin(direction.y);
    float azimuth = Acos(direction.z / length(direction.xz));
    // Cannot use sign because it can return 0, and I'm not sure it handles -0.0
    azimuth *= direction.x < -0.0 ? -1.0 : 1.0;

    return float2(azimuth, polar);
}

float2 CartesianToSphericalUV(float3 direction) {
    float polar = Asin(direction.y);
    float azimuth = Acos(direction.z / length(direction.xz));
    // Cannot use sign because it can return 0, and I'm not sure it handles -0.0
    azimuth *= direction.x < -0.0 ? -1.0 : 1.0;

    float u = InverseLerp(-Pi, Pi, azimuth);
    float v = InverseLerp(-Pi * 0.5, Pi * 0.5, polar);

    return float2(u, v);
}

float2 UVToSpherical(float2 uv) {
    float u = uv.x;
    float v = uv.y;

    float azimuth = lerp(-Pi, Pi, u);
    float polar = lerp(-Pi * 0.5, Pi * 0.5, v);

    return float2(azimuth, polar);
}

float2 SphericalToUV(float azimuth, float polar) {
    float u = InverseLerp(-Pi, Pi, azimuth);
    float v = InverseLerp(-Pi * 0.5, Pi * 0.5, polar);

    return float2(u, v);
}

float3 SphericalToCartesian(float azimuth, float polar) {
    float cosa = cos(azimuth);
    float sina = sin(azimuth);
    float cosp = cos(polar);
    float sinp = sin(polar);

    return float3(sina * cosp, sinp, cosa * cosp);
}

#endif
