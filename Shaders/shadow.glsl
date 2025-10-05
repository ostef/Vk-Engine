#ifndef SHADOW_GLSL
#define SHADOW_GLSL

#include "common.glsl"

int GetShadowCascadeIndex(ShadowMapParams params, ShadowMap shadow_map, float3 position, float3 normal, out float3 coords) {
    float3 normal_offset = normal / float(shadow_map.resolution) * params.normal_bias;
    #if Shadow_Map_Reverse_Depth_Range
        normal_offset = -normal_offset;
    #endif

    int cascade_index = 0;
    for (; cascade_index < Num_Shadow_Map_Cascades; cascade_index += 1) {
        float4 light_space_pos = shadow_map.viewpoints[cascade_index].view_projection * float4(position + normal_offset, 1);
        coords = light_space_pos.xyz / light_space_pos.w;
        coords.xy = coords.xy * 0.5 + float2(0.5);

        if (coords.x > 0 && coords.x < 1
         && coords.y > 0 && coords.y < 1
         && coords.z > 0 && coords.z < 1) {
            return cascade_index;
        }
    }

    return -1;
}

float4 GetShadowCascadeColor(ShadowMapParams params, ShadowMap shadow_map, float3 position, float3 normal) {
    float3 coords;
    int cascade_index = GetShadowCascadeIndex(params, shadow_map, position, normal, coords);
    if (cascade_index < 0) {
        return float4(0);
    }

    return float4(RandomColor((cascade_index + 1) * 1234.5678), 1);
}

float SampleShadowMap(
    ShadowMapParams params,
    ShadowMap shadow_map,
    sampler2DArray noise_texture,
    sampler2DArrayShadow shadow_map_texture,
    float3 world_position, float3 world_normal,
    float2 screen_position
) {
    float2 shadow_map_texel_size = 1 / float2(shadow_map.resolution);
    float2 noise_texel_size = 1 / float2(params.noise_resolution);

    float3 coords;
    int cascade_index = GetShadowCascadeIndex(params, shadow_map, world_position, world_normal, coords);
    if (cascade_index < 0) {
        return 0;
    }

#ifndef TEXTURE_ORIGIN_BOTTOM_LEFT
    coords.y = 1 - coords.y;
#endif

    float2 shadow_map_size = float2(shadow_map.cascade_sizes[cascade_index]);

    float NdotL = dot(world_normal, -shadow_map.direction);
    float bias_factor = clamp(1.0 - NdotL, 0.0, 1.0);
    float depth_bias = lerp(params.depth_bias_min_max.x, params.depth_bias_min_max.y, bias_factor);
    depth_bias *= shadow_map_texel_size.x;
    depth_bias /= shadow_map.cascade_sizes[cascade_index] / 20;
    #if Shadow_Map_Reverse_Depth_Range
        depth_bias = -depth_bias;
    #endif

    float3 forward = float3(0,0,1);
    float3 right = cross(world_normal, forward);
    forward = cross(right, world_normal);

    float filter_radius = shadow_map_texel_size.x * params.filter_radius / shadow_map.cascade_sizes[cascade_index] * 20;

    float shadow_value = 0;
    for (int x = 0; x < Num_Shadow_Map_Sqrt_Samples; x += 1) {
        for (int y = 0; y < Num_Shadow_Map_Sqrt_Samples; y += 1) {
            float3 noise_coords = float3(screen_position * noise_texel_size, x * Num_Shadow_Map_Sqrt_Samples + y);

            float2 offset = texture(noise_texture, noise_coords).xy;
            offset *= filter_radius;

            float3 uvw = float3(coords.xy + offset, cascade_index);
            shadow_value += texture(shadow_map_texture, float4(uvw, coords.z - depth_bias));
        }
    }

    return shadow_value / float(Num_Shadow_Map_Samples);
}

float SamplePointShadowMap(
    ShadowMapParams params,
    PointShadowMap shadow_map,
    sampler2DArray noise_texture,
    samplerCube shadow_map_texture,
    float3 world_position, float3 world_normal,
    float2 screen_position
) {
    float2 shadow_map_texel_size = 1 / float2(shadow_map.resolution / 6);
    float2 noise_texel_size = 1 / float2(params.noise_resolution);

    float filter_radius = shadow_map_texel_size.x * params.filter_radius / 10;

    float3 L = world_position - shadow_map.position;
    float current_depth = length(L);
    L /= current_depth;

    float NdotL = dot(world_normal, -L);
    float bias_factor = clamp(1.0 - NdotL, 0.0, 1.0);
    float depth_bias = lerp(params.depth_bias_min_max.x, params.depth_bias_min_max.y, bias_factor);
    depth_bias *= shadow_map_texel_size.x;

    float shadow = 0;
    for (int x = 0; x < Num_Point_Shadow_Map_Cbrt_Samples; x += 1) {
        for (int y = 0; y < Num_Point_Shadow_Map_Cbrt_Samples; y += 1) {
            for (int z = 0; z < Num_Point_Shadow_Map_Cbrt_Samples; z += 1) {
                float3 noise_coords = float3(screen_position * noise_texel_size, x * Num_Point_Shadow_Map_Cbrt_Samples * Num_Point_Shadow_Map_Cbrt_Samples + y * Num_Point_Shadow_Map_Cbrt_Samples + z);

                float3 offset = texture(noise_texture, noise_coords).xyz;
                offset *= filter_radius;

                float closest_depth = texture(shadow_map_texture, L + offset).r;
                closest_depth *= shadow_map.viewpoints[0].z_far;

                shadow += float(closest_depth < shadow_map.viewpoints[0].z_far && current_depth - depth_bias > closest_depth);
            }
        }
    }

    shadow /= float(Num_Point_Shadow_Map_Samples);

    return shadow;
}

#endif
