#ifndef COMMON_GLSL
#define COMMON_GLSL

#extension GL_EXT_shader_image_load_formatted : enable // Because GLSL sucks...
// We cannot pass image2D to functions unless this extension is enabled, because
// the GLSL spec does not handle it.

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

#define DECLARE_STATIC_VERTEX_ATTRIBUTES() \
    layout(location=0) in float3 in_position; \
    layout(location=1) in float3 in_normal; \
    layout(location=2) in float4 in_tangent; \
    layout(location=3) in float2 in_tex_coords

#define DECLARE_SKINNED_VERTEX_ATTRIBUTES() \
    layout(location=0) in float3 in_position; \
    layout(location=1) in float3 in_normal; \
    layout(location=2) in float4 in_tangent; \
    layout(location=3) in float2 in_tex_coords; \
    layout(location=4) in int4 in_joint_ids; \
    layout(location=5) in float3 in_joint_weights

#ifdef HAS_SKIN
#define DECLARE_VERTEX_ATTRIBUTES() DECLARE_SKINNED_VERTEX_ATTRIBUTES()
#else
#define DECLARE_VERTEX_ATTRIBUTES() DECLARE_STATIC_VERTEX_ATTRIBUTES()
#endif

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
    }; /*\
    layout(set=0, binding=1, std430) readonly buffer DirectionalLights { \
        DirectionalLight u_directional_lights[]; \
    }; \
    layout(set=0, binding=2, std430) readonly buffer PointLights { \
        PointLight u_point_lights[]; \
    }; \
    layout(set=0, binding=3) uniform sampler2D u_brdf_lut ; \
    layout(set=0, binding=4) uniform sampler2DArray u_shadow_map_noise_texture*/
#endif

#ifdef SHADER_STAGE_COMPUTE
#define DECLARE_PER_FRAME_PARAMS() \
    layout(set=0, binding=0, std140) uniform FrameData { \
        FrameInfo u_frame_info; \
    }; \
    layout(set=0, binding=1, std430) readonly buffer DirectionalLights { \
        DirectionalLight u_directional_lights[]; \
    }; \
    layout(set=0, binding=2, std430) readonly buffer PointLights { \
        PointLight u_point_lights[]; \
    }
#endif

#ifdef SHADER_STAGE_VERTEX
#define DECLARE_FORWARD_PASS_PARAMS() \
    layout(set=1, binding=0) uniform Viewpoints { \
        uint u_num_viewpoints; \
        Viewpoint u_viewpoints[Max_Viewpoints]; \
    }
#endif

#ifdef SHADER_STAGE_FRAGMENT
#define DECLARE_FORWARD_PASS_PARAMS() \
    layout(set=1, binding=0) uniform Viewpoints { \
        uint u_num_viewpoints; \
        Viewpoint u_viewpoints[Max_Viewpoints]; \
    }; /*\
    layout(set=1, binding=1) uniform sampler2DArrayShadow u_shadow_maps[Max_Shadow_Maps]; \
    layout(set=1, binding=2) uniform samplerCube u_point_shadow_maps[Max_Point_Shadow_Maps]; \
    layout(set=1, binding=3) uniform sampler2D u_irradiance_map; \
    layout(set=1, binding=4) uniform sampler2D u_environment_map; \
    layout(set=1, binding=5) readonly buffer Clusters { \
        LightCluster u_clusters[]; \
    }*/
#endif

#ifdef SHADER_STAGE_VERTEX
#define DECLARE_PER_DRAW_CALL_MESH_PARAMS() \
    layout(set=2, binding=0, std430) readonly buffer MeshData { \
        MeshInstance u_mesh_instances[]; \
    }; \
    layout(set=2, binding=1, std430) readonly buffer SkinningData { \
        float4x4 u_skinning_matrices[]; \
    }
#endif

#ifdef SHADER_STAGE_FRAGMENT
#define DECLARE_PER_DRAW_CALL_MESH_PARAMS() \
    layout(set=2, binding=0, std430) readonly buffer MeshData { \
        MeshInstance u_mesh_instances[]; \
    }; \
    layout(set=2, binding=2) uniform sampler2D u_base_color_texture; \
    layout(set=2, binding=3) uniform sampler2D u_normal_map_texture; \
    layout(set=2, binding=4) uniform sampler2D u_metallic_roughness_map_texture; \
    layout(set=2, binding=5) uniform sampler2D u_emissive_texture; \
    layout(set=2, binding=6) uniform sampler2D u_depth_map_texture
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

float LinearTosRGB(float x) {
    return pow(x, float(1.0 / 2.2));
}

float sRGBToLinear(float x) {
    return pow(x, float(2.2));
}

float InverseLerp(float a, float b, float t) {
    return (t - a) / (b - a);
}

float LinearRGBToLuminance(float3 rgb) {
    return dot(rgb, float3(0.2126729, 0.7151522, 0.0721750));
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

bool ApproxZero(float x, float epsilon) {
    return abs(x) < epsilon;
}

bool ApproxEquals(float a, float b, float epsilon) {
    return abs(a - b) < epsilon;
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

// [Jimenez14] https://www.iryoku.com/next-generation-post-processing-in-call-of-duty-advanced-warfare/
// . . . . . . .
// . A . B . C .
// . . D . E . .
// . F . G . H .
// . . I . J . .
// . K . L . M .
// . . . . . . .
float4 DownsampleBox13(sampler2D s, float2 uv, float2 texel_size) {
    float4 A = textureLod(s, uv + texel_size * float2(-2, -2), 0);
    float4 B = textureLod(s, uv + texel_size * float2( 0, -2), 0);
    float4 C = textureLod(s, uv + texel_size * float2( 2, -2), 0);
    float4 D = textureLod(s, uv + texel_size * float2(-1, -1), 0);
    float4 E = textureLod(s, uv + texel_size * float2( 1, -1), 0);
    float4 F = textureLod(s, uv + texel_size * float2(-2,  0), 0);
    float4 G = textureLod(s, uv, 0);
    float4 H = textureLod(s, uv + texel_size * float2( 2,  0), 0);
    float4 I = textureLod(s, uv + texel_size * float2(-1,  1), 0);
    float4 J = textureLod(s, uv + texel_size * float2( 1,  1), 0);
    float4 K = textureLod(s, uv + texel_size * float2(-2,  2), 0);
    float4 L = textureLod(s, uv + texel_size * float2( 0,  2), 0);
    float4 M = textureLod(s, uv + texel_size * float2( 2,  2), 0);

    float4 result = G * 0.125;
    result += (A + C + M + K) * 0.03125;
    result += (B + H + L + F) * 0.0625;
    result += (D + E + J + I) * 0.125;

    return result;
}

float4 DownsampleBox13(readonly image2D i, int2 uv, int2 image_size) {
    float4 A = imageLoad(i, clamp(uv + int2(-2, -2), int2(0), image_size - int2(1)));
    float4 B = imageLoad(i, clamp(uv + int2( 0, -2), int2(0), image_size - int2(1)));
    float4 C = imageLoad(i, clamp(uv + int2( 2, -2), int2(0), image_size - int2(1)));
    float4 D = imageLoad(i, clamp(uv + int2(-1, -1), int2(0), image_size - int2(1)));
    float4 E = imageLoad(i, clamp(uv + int2( 1, -1), int2(0), image_size - int2(1)));
    float4 F = imageLoad(i, clamp(uv + int2(-2,  0), int2(0), image_size - int2(1)));
    float4 G = imageLoad(i, clamp(uv,                int2(0), image_size - int2(1)));
    float4 H = imageLoad(i, clamp(uv + int2( 2,  0), int2(0), image_size - int2(1)));
    float4 I = imageLoad(i, clamp(uv + int2(-1,  1), int2(0), image_size - int2(1)));
    float4 J = imageLoad(i, clamp(uv + int2( 1,  1), int2(0), image_size - int2(1)));
    float4 K = imageLoad(i, clamp(uv + int2(-2,  2), int2(0), image_size - int2(1)));
    float4 L = imageLoad(i, clamp(uv + int2( 0,  2), int2(0), image_size - int2(1)));
    float4 M = imageLoad(i, clamp(uv + int2( 2,  2), int2(0), image_size - int2(1)));

    float4 result = G * 0.125;
    result += (A + C + M + K) * 0.03125;
    result += (B + H + L + F) * 0.0625;
    result += (D + E + J + I) * 0.125;

    return result;
}

float KarisAverage(float3 color) {
    float luma = LinearRGBToLuminance(color) * 0.25;

    return 1 / (1 + luma);
}

// . . . . . . .
// . A . B . C .
// . . D . E . .
// . F . G . H .
// . . I . J . .
// . K . L . M .
// . . . . . . .
float4 DownsampleBox13WithKarisAverage(sampler2D s, float2 uv, float2 texel_size) {
    float4 A = textureLod(s, uv + texel_size * float2(-2, -2), 0);
    float4 B = textureLod(s, uv + texel_size * float2( 0, -2), 0);
    float4 C = textureLod(s, uv + texel_size * float2( 2, -2), 0);
    float4 D = textureLod(s, uv + texel_size * float2(-1, -1), 0);
    float4 E = textureLod(s, uv + texel_size * float2( 1, -1), 0);
    float4 F = textureLod(s, uv + texel_size * float2(-2,  0), 0);
    float4 G = textureLod(s, uv, 0);
    float4 H = textureLod(s, uv + texel_size * float2( 2,  0), 0);
    float4 I = textureLod(s, uv + texel_size * float2(-1,  1), 0);
    float4 J = textureLod(s, uv + texel_size * float2( 1,  1), 0);
    float4 K = textureLod(s, uv + texel_size * float2(-2,  2), 0);
    float4 L = textureLod(s, uv + texel_size * float2( 0,  2), 0);
    float4 M = textureLod(s, uv + texel_size * float2( 2,  2), 0);

    float4 G1 = (A + B + F + G) * (0.125 / 4);
    float4 G2 = (B + C + G + H) * (0.125 / 4);
    float4 G3 = (F + G + K + L) * (0.125 / 4);
    float4 G4 = (G + H + L + M) * (0.125 / 4);
    float4 G5 = (D + E + I + J) * (0.5 / 4);
    G1.rgb *= KarisAverage(G1.rgb);
    G2.rgb *= KarisAverage(G2.rgb);
    G3.rgb *= KarisAverage(G3.rgb);
    G4.rgb *= KarisAverage(G4.rgb);
    G5.rgb *= KarisAverage(G5.rgb);

    return G1 + G2 + G3 + G4 + G5;
}

float4 DownsampleBox13WithKarisAverage(readonly image2D i, int2 uv, int2 image_size) {
    float4 A = imageLoad(i, clamp(uv + int2(-2, -2), int2(0), image_size - int2(1)));
    float4 B = imageLoad(i, clamp(uv + int2( 0, -2), int2(0), image_size - int2(1)));
    float4 C = imageLoad(i, clamp(uv + int2( 2, -2), int2(0), image_size - int2(1)));
    float4 D = imageLoad(i, clamp(uv + int2(-1, -1), int2(0), image_size - int2(1)));
    float4 E = imageLoad(i, clamp(uv + int2( 1, -1), int2(0), image_size - int2(1)));
    float4 F = imageLoad(i, clamp(uv + int2(-2,  0), int2(0), image_size - int2(1)));
    float4 G = imageLoad(i, clamp(uv,                int2(0), image_size - int2(1)));
    float4 H = imageLoad(i, clamp(uv + int2( 2,  0), int2(0), image_size - int2(1)));
    float4 I = imageLoad(i, clamp(uv + int2(-1,  1), int2(0), image_size - int2(1)));
    float4 J = imageLoad(i, clamp(uv + int2( 1,  1), int2(0), image_size - int2(1)));
    float4 K = imageLoad(i, clamp(uv + int2(-2,  2), int2(0), image_size - int2(1)));
    float4 L = imageLoad(i, clamp(uv + int2( 0,  2), int2(0), image_size - int2(1)));
    float4 M = imageLoad(i, clamp(uv + int2( 2,  2), int2(0), image_size - int2(1)));

    float4 G1 = (A + B + F + G) * (0.125 / 4);
    float4 G2 = (B + C + G + H) * (0.125 / 4);
    float4 G3 = (F + G + K + L) * (0.125 / 4);
    float4 G4 = (G + H + L + M) * (0.125 / 4);
    float4 G5 = (D + E + I + J) * (0.5 / 4);
    G1.rgb *= KarisAverage(G1.rgb);
    G2.rgb *= KarisAverage(G2.rgb);
    G3.rgb *= KarisAverage(G3.rgb);
    G4.rgb *= KarisAverage(G4.rgb);
    G5.rgb *= KarisAverage(G5.rgb);

    return G1 + G2 + G3 + G4 + G5;
}

// [Jimenez14] https://www.iryoku.com/next-generation-post-processing-in-call-of-duty-advanced-warfare/
float4 UpsampleTent9(sampler2D s, float2 uv, float2 texel_size) {
    float4 A = textureLod(s, uv + float2(-texel_size.x,  texel_size.y), 0);
    float4 B = textureLod(s, uv + float2(            0,  texel_size.y), 0);
    float4 C = textureLod(s, uv + float2( texel_size.x,  texel_size.y), 0);

    float4 D = textureLod(s, uv + float2(-texel_size.x,  0), 0);
    float4 E = textureLod(s, uv, 0);
    float4 F = textureLod(s, uv + float2( texel_size.x,  0), 0);

    float4 G = textureLod(s, uv + float2(-texel_size.x, -texel_size.y), 0);
    float4 H = textureLod(s, uv + float2(            0, -texel_size.y), 0);
    float4 I = textureLod(s, uv + float2( texel_size.x, -texel_size.y), 0);

    // Apply weighted distribution, by using a 3x3 tent filter:
    //  1   | 1 2 1 |
    // -- * | 2 4 2 |
    // 16   | 1 2 1 |
    float4 result = E * 4;
    result += (B + D + F + H) * 2;
    result += (A + C + G + I);
    result *= 1 / 16.0;

    return result;
}

float4 UpsampleTent9(readonly image2D i, int2 uv, int2 image_size) {
    float4 A = imageLoad(i, clamp(uv + int2(-1,  1), int2(0), image_size - int2(1)));
    float4 B = imageLoad(i, clamp(uv + int2( 0,  1), int2(0), image_size - int2(1)));
    float4 C = imageLoad(i, clamp(uv + int2( 1,  1), int2(0), image_size - int2(1)));

    float4 D = imageLoad(i, clamp(uv + int2(-1,  0), int2(0), image_size - int2(1)));
    float4 E = imageLoad(i, clamp(uv,                int2(0), image_size - int2(1)));
    float4 F = imageLoad(i, clamp(uv + int2( 1,  0), int2(0), image_size - int2(1)));

    float4 G = imageLoad(i, clamp(uv + int2(-1, -1), int2(0), image_size - int2(1)));
    float4 H = imageLoad(i, clamp(uv + int2( 0, -1), int2(0), image_size - int2(1)));
    float4 I = imageLoad(i, clamp(uv + int2( 1, -1), int2(0), image_size - int2(1)));

    // Apply weighted distribution, by using a 3x3 tent filter:
    //  1   | 1 2 1 |
    // -- * | 2 4 2 |
    // 16   | 1 2 1 |
    float4 result = E * 4;
    result += (B + D + F + H) * 2;
    result += (A + C + G + I);
    result *= 1 / 16.0;

    return result;
}

float4 SampleBox4(sampler2D s, float2 uv, float2 texel_size) {
    float4 A = textureLod(s, uv + float2(-texel_size.x,  texel_size.y), 0);
    float4 B = textureLod(s, uv + float2( texel_size.x,  texel_size.y), 0);
    float4 C = textureLod(s, uv + float2(-texel_size.x, -texel_size.y), 0);
    float4 D = textureLod(s, uv + float2( texel_size.x, -texel_size.y), 0);

    return (A + B + C + D) * (1 / 4.0);
}

float4 SampleBox4(readonly image2D i, int2 uv, int2 image_size) {
    float4 A = imageLoad(i, clamp(uv + int2(-1,  1), int2(0), image_size - int2(1)));
    float4 B = imageLoad(i, clamp(uv + int2( 1,  1), int2(0), image_size - int2(1)));
    float4 C = imageLoad(i, clamp(uv + int2(-1, -1), int2(0), image_size - int2(1)));
    float4 D = imageLoad(i, clamp(uv + int2( 1, -1), int2(0), image_size - int2(1)));

    return (A + B + C + D) * (1 / 4.0);
}

float LinearizeDepth(float d, float z_near, float z_far) {
    return z_near * z_far / (z_far + d * (z_near - z_far));
}

float3 BlendRGBPostMultipliedAlpha(float3 dst, float3 src, float alpha) {
    return src * alpha + dst * (1 - alpha);
}

float3 BlendRGBPreMultipliedAlpha(float3 dst, float3 src, float alpha) {
    return src + dst * (1 - alpha);
}

float2 IntegerToNormalizedTexCoords(int2 integer_coords, int2 size) {
    return float2((integer_coords + float2(0.5)) / float2(size));
}

// Inspired by https://lisyarus.github.io/blog/posts/point-light-attenuation.html, tweaked to match closely I/x^2
// Key differences:
//  * instead of smoothly settling as x < source_radius, we cut abruptly because physically nothing is supposed to be closer than source_radius
//  * the intensity parameter is not the max intensity at distance == 0, rather it tries to match closely I in the physically correct equation
//  * there is no parameter for the falloff, it is calculated automatically depending on the intensity_radius
// Parameters:
//  * source_radius: light sources are not infinitely small points; this describes to size of the light source as if it were a sphere.
// The lower it is, the closer objects need to be to the light source to receive a lot of light
//  * base_intensity: the same parameter as the physically correct equation, this is NOT the intensity at distance == 0
//  * intensity_radius: the distance at which the final intensity reaches 0, offseted by the source_radius
// https://www.desmos.com/calculator/4fs7w3qt2x
float GetPointLightIntensity(float source_radius, float base_intensity, float intensity_radius, float distance) {
    if (distance > source_radius + intensity_radius) {
        return 0;
    }

    const float Intensity_Factor = 100.0;

    source_radius = max(source_radius, 0);
    float max_intensity = Intensity_Factor * base_intensity;
    float d = max(distance - source_radius, 0);
    float s = d / intensity_radius;
    float falloff = Intensity_Factor * intensity_radius;
    float one_minus_s_s = 1 - s * s;

    return max_intensity * (one_minus_s_s * one_minus_s_s) / (1 + falloff * s);
}

uint GetLightClusterIndex(Viewpoint viewpoint, float3 world_position, float2 screen_position) {
    float3 view_space_position = (viewpoint.view * float4(world_position, 1)).xyz;
    float depth = abs(view_space_position.z);
    uint cluster_z_tile = uint((log(depth / viewpoint.z_near) * Num_Clusters_Z) / log(viewpoint.z_far / viewpoint.z_near));
    float2 cluster_tile_size = viewpoint.viewport_size / float2(Num_Clusters_X, Num_Clusters_Y);
    uint3 cluster_tile = uint3(screen_position / cluster_tile_size, cluster_z_tile);
    cluster_tile.y = Num_Clusters_Y - cluster_tile.y - 1;

    return cluster_tile.x
        + (cluster_tile.y * Num_Clusters_X)
        + (cluster_tile.z * Num_Clusters_X * Num_Clusters_Y);
}

float Log10(float x) {
    return log(x) / 2.30258509299;
}

#endif
