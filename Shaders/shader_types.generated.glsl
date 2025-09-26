// This file was auto generated

#ifndef SHADER_TYPES_GENERATED_GLSL
#define SHADER_TYPES_GENERATED_GLSL

#define Max_Lights_Per_Clusters 100
#define Max_Viewpoints 6
#define Num_Clusters 3456
#define Num_Clusters_X 16
#define Num_Clusters_Y 9
#define Num_Clusters_Z 24
#define Num_Environment_Map_Levels 6
#define Num_Point_Shadow_Map_Cbrt_Samples 3
#define Num_Point_Shadow_Map_Samples 27
#define Num_Shadow_Map_Cascades 4
#define Num_Shadow_Map_Samples 64
#define Num_Shadow_Map_Sqrt_Samples 8
#define Populate_Cluster_Grid_Work_Group_Size 144
#define Reverse_Depth_Range 1
#define Shadow_Map_Noise_Size 32
#define Shadow_Map_Reverse_Depth_Range 1

struct Viewpoint {
    float3 position;
    float3 direction;
    float3 right;
    float3 up;
    float4x4 transform;
    float4x4 view;
    float4x4 projection;
    float4x4 inv_projection;
    float4x4 view_projection;
    float4x4 inv_view_projection;
    float2 viewport_size;
    float fov;
    float z_near;
    float z_far;
};

struct DirectionalLight {
    float3 direction;
    float3 color;
    float intensity;
    int shadow_map_index;
    uint shadow_map_resolution;
    float shadow_map_cascade_sizes[4];
    Viewpoint shadow_map_viewpoints[4];
};

struct FrameInfo {
    float time;
    float2 window_pixel_size;
    uint num_directional_lights;
    uint num_point_lights;
    float skybox_light_intensity;
};

struct LightCluster {
    float3 min;
    float3 max;
    uint num_lights;
    uint lights[100];
};

#define MaterialFlags int
#define MaterialFlags_HasMetallicRoughness 1
#define MaterialFlags_HasDepthMap 2

#define MaterialType int
#define MaterialType_Opaque 0
#define MaterialType_Unlit 1

struct MaterialPerInstance {
    MaterialType type;
    MaterialFlags flags;
    float3 base_color_tint;
    float metallic;
    float roughness;
    float3 emissive_tint;
    float emissive_strength;
    float depth_map_scale;
    float alpha_cutoff;
};

struct MeshInstance {
    uint4 entity_guid;
    float4x4 transform;
    float3x3 normal_transform;
    MaterialPerInstance material;
    uint skinning_matrices_offset;
};

struct PointLight {
    float3 position;
    float3 color;
    float intensity;
    float intensity_radius;
    float source_radius;
    int shadow_map_index;
    uint shadow_map_resolution;
    Viewpoint shadow_map_viewpoints[6];
};

struct ViewpointsData {
    uint num_viewpoints;
    Viewpoint viewpoints[6];
};

#endif
