// This file was auto generated

#ifndef SHADER_TYPES_GENERATED_GLSL
#define SHADER_TYPES_GENERATED_GLSL

struct Viewpoint {
    float3 position;
    float3 direction;
    float3 right;
    float3 up;
    float4x4 transform;
    float4x4 view;
    float4x4 projection;
    float4x4 view_projection;
    float2 viewport_size;
    float fov;
};

struct DirectionalLight {
    float3 direction;
    float3 color;
    float intensity;
    bool cast_shadows;
    uint shadow_map_resolution;
    float shadow_map_cascade_sizes[4];
    Viewpoint shadow_map_viewpoints[4];
};

struct ShadowMapParams {
    uint noise_resolution;
    float2 depth_bias_min_max;
    float normal_bias;
    float filter_radius;
};

struct FrameInfo {
    float time;
    float2 window_pixel_size;
    uint num_directional_lights;
    uint num_point_lights;
    ShadowMapParams shadow_map_params;
};

#define MaterialFlags int
#define MaterialFlags_HasMetallicRoughness 1

#define MaterialType int
#define MaterialType_Opaque 0

struct MaterialPerInstance {
    MaterialType type;
    MaterialFlags flags;
    float3 base_color_tint;
    float metallic;
    float roughness;
    float3 emissive_tint;
    float emissive_strength;
};

struct MeshInstance {
    uint4 entity_guid;
    float4x4 transform;
    float3x3 normal_transform;
    MaterialPerInstance material;
};

struct PointLight {
    float3 position;
    float3 color;
    float intensity;
};

#endif
