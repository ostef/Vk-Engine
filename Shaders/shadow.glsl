#ifndef SHADOW_GLSL
#define SHADOW_GLSL

#include "common.glsl"

#define Num_Shadow_Map_Cascades 4
#define Num_Shadow_Map_Sqrt_Samples 8
#define Num_Shadow_Map_Samples (Num_Shadow_Map_Sqrt_Samples * Num_Shadow_Map_Sqrt_Samples)

int GetShadowCascadeIndex(ShadowMapParams params, DirectionalLight light, float3 position, float3 normal, out float3 coords) {
    float3 normal_offset = normal / float(light.shadow_map_resolution) * params.normal_bias;

    int cascade_index = 0;
    for (; cascade_index < Num_Shadow_Map_Cascades; cascade_index += 1) {
        float4 light_space_pos = light.shadow_map_viewpoints[cascade_index].view_projection * float4(position + normal_offset, 1);
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

float4 GetShadowCascadeColor(ShadowMapParams params, DirectionalLight light, float3 position, float3 normal) {
    float3 coords;
    int cascade_index = GetShadowCascadeIndex(params, light, position, normal, coords);
    if (cascade_index < 0) {
        return float4(0);
    }

    return float4(RandomColor((cascade_index + 1) * 1234.5678), 1);
}

float SampleShadowMap(
    ShadowMapParams params,
    DirectionalLight light,
    sampler2DArray noise_texture,
    sampler2DArrayShadow shadow_map_texture,
    float3 world_position, float3 world_normal,
    float2 screen_position
) {
    float2 shadow_map_texel_size = 1 / float2(light.shadow_map_resolution);
    float2 noise_texel_size = 1 / float2(params.noise_resolution);

    float3 coords;
    int cascade_index = GetShadowCascadeIndex(params, light, world_position, world_normal, coords);
    if (cascade_index < 0) {
        return 0;
    }

#ifndef TEXTURE_ORIGIN_BOTTOM_LEFT
    coords.y = 1 - coords.y;
#endif

    float2 shadow_map_size = float2(light.shadow_map_cascade_sizes[cascade_index]);

    float NdotL = dot(world_normal, -light.direction);
    float bias_factor = clamp(1.0 - NdotL, 0.0, 1.0);
    float depth_bias = lerp(params.depth_bias_min_max.x, params.depth_bias_min_max.y, bias_factor);
    depth_bias *= shadow_map_texel_size.x;
    depth_bias /= light.shadow_map_cascade_sizes[cascade_index] / 20;

    float3 forward = float3(0,0,1);
    float3 right = cross(world_normal, forward);
    forward = cross(right, world_normal);

    float filter_radius = shadow_map_texel_size.x * params.filter_radius / light.shadow_map_cascade_sizes[cascade_index] * 20;

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

#endif
