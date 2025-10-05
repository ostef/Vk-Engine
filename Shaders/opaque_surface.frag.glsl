#include "common.glsl"
#include "pbr.glsl"
#include "shadow.glsl"

DECLARE_PER_FRAME_PARAMS();
DECLARE_FORWARD_PASS_PARAMS();
DECLARE_PER_DRAW_CALL_MESH_PARAMS();

layout(location=0) in float3 in_viewpoint_position;
layout(location=1) in flat uint in_instance_index;
layout(location=2) in float3 in_position;
layout(location=3) in float3 in_normal;
layout(location=4) in float3 in_tangent;
layout(location=5) in float3 in_bitangent;
layout(location=6) in float2 in_tex_coords;

layout(location=0) out float4 out_color;

#define Min_Parallax_Layers 20
#define Max_Parallax_Layers 60
#define Parallax_Shadow_Attenuation_Cos_Angle 0.1

// https://learnopengl.com/Advanced-Lighting/Parallax-Mapping
float2 ParallaxOcclusionMapping(sampler2D depth_map, float height_scale, float2 tex_coords, float3 view_dir) {
    float num_layers = lerp(Max_Parallax_Layers, Min_Parallax_Layers, abs(dot(float3(0,0,1), view_dir)));
    num_layers = clamp(num_layers, Min_Parallax_Layers, Max_Parallax_Layers);
    float layer_step = 1 / num_layers;

    float2 current_uv = tex_coords;
    float current_depth = texture(depth_map, current_uv).r;
    float current_layer = 0;

    float2 delta_uv = (view_dir.xy / view_dir.z * height_scale) / num_layers;
    delta_uv.y = -delta_uv.y;

    int i = 0;
    while (current_layer < current_depth && i < Max_Parallax_Layers) {
        current_uv -= delta_uv;
        current_depth = texture(depth_map, current_uv).r;
        current_layer += layer_step;
        i += 1;
    }

    float2 previous_uv = current_uv + delta_uv;
    float after_depth = current_depth - current_layer;
    float before_depth = texture(depth_map, previous_uv).r - current_layer + layer_step;

    float weight = after_depth / (after_depth - before_depth);
    float2 final_uv = lerp(current_uv, previous_uv, weight);

    return final_uv;
}

// https://godotshaders.com/shader/parallax-occlusion-mapping-with-self-shadowing/
float ParallaxOcclusionSelfShadow(sampler2D depth_map, float height_scale, float2 tex_coords, float3 view_dir) {
    float num_layers = lerp(Max_Parallax_Layers, Min_Parallax_Layers, abs(dot(float3(0,0,1), view_dir)));
    num_layers = clamp(num_layers, Min_Parallax_Layers, Max_Parallax_Layers);
    float layer_step = 1 / num_layers;

    float2 current_uv = tex_coords;
    float current_depth = texture(depth_map, current_uv).r;
    float current_layer = current_depth;

    float2 delta_uv = (view_dir.xy / view_dir.z * height_scale) / num_layers;
    delta_uv.y = -delta_uv.y;

    int i = 0;
    while (current_layer <= current_depth && current_layer > 0 && i < Max_Parallax_Layers) {
        current_uv += delta_uv;
        current_depth = texture(depth_map, current_uv).r;
        current_layer -= layer_step;
        i += 1;
    }

    return float(current_layer > current_depth);
}

void main() {
    MeshInstance mesh = u_mesh_instances[in_instance_index];
    Viewpoint viewpoint = u_viewpoints[0];

    float3 view_space_position = (viewpoint.view * float4(in_position, 1)).xyz;

    float3x3 TBN = float3x3(
        normalize(in_tangent),
        normalize(in_bitangent),
        normalize(in_normal)
    );
    float3x3 inv_TBN = transpose(TBN);

    float3 V = normalize(in_viewpoint_position - in_position);

    float2 tex_coords = in_tex_coords;
    if ((mesh.material.flags & MaterialFlags_HasDepthMap) != 0) {
        float3 tangent_view_dir = inv_TBN * V;
        tex_coords = ParallaxOcclusionMapping(u_depth_map_texture, mesh.material.depth_map_scale, in_tex_coords, tangent_view_dir);
    }

    float3 N = texture(u_normal_map_texture, tex_coords).xyz;
    N = N * 2 - float3(1);
    N = normalize(TBN * N);

    float3 base_color = texture(u_base_color_texture, tex_coords).rgb;
    base_color *= sRGBToLinear(mesh.material.base_color_tint);

    float3 emissive = texture(u_emissive_texture, tex_coords).rgb;
    emissive *= sRGBToLinear(mesh.material.emissive_tint);
    emissive *= mesh.material.emissive_strength;

    float metallic, roughness;
    if ((mesh.material.flags & MaterialFlags_HasMetallicRoughness) != 0) {
        float4 metallic_roughness = texture(u_metallic_roughness_map_texture, tex_coords);
        metallic = metallic_roughness.b;
        roughness = metallic_roughness.g;
    } else {
        metallic = mesh.material.metallic;
        roughness = mesh.material.roughness;
    }
    metallic = clamp(metallic, 0, 1);
    roughness = clamp(roughness, 0, 1);

    uint cluster_index = GetLightClusterIndex(viewpoint, in_position, gl_FragCoord.xy);
    LightCluster cluster = u_clusters[cluster_index];

    float3 Lo = float3(0);

    for (int i = 0; i < u_frame_info.num_directional_lights; i += 1) {
        DirectionalLight light = u_directional_lights[i];
        float3 light_color = sRGBToLinear(light.color);

        float3 L = -light.direction;
        float NdotL = max(dot(N, L), 0.0);

        float shadow;
        if (light.shadow_map_index >= 0) {
            ShadowMap shadow_map = u_shadow_maps[light.shadow_map_index];
            shadow = 1 - SampleShadowMap(u_frame_info.shadow_map_params, shadow_map, u_shadow_map_noise_texture, u_shadow_map_textures[light.shadow_map_index], in_position, N, gl_FragCoord.xy);
        } else {
            shadow = 1;
        }

        if ((mesh.material.flags & MaterialFlags_HasDepthMap) != 0) {
            float3 tangent_light_dir = inv_TBN * L;
            // Remove all light contribution when the light is behind the plane (we assume depth map materials are mostly applied on flat surfaces)
            if (dot(in_normal, L) < 0) {
                shadow = 0;
            } else {
                shadow *= 1 - ParallaxOcclusionSelfShadow(u_depth_map_texture, mesh.material.depth_map_scale, tex_coords, tangent_light_dir);

                // Shadow don't look good at steep angles, so we attenuate
                float shadow_attenuation = InverseLerp(0, Parallax_Shadow_Attenuation_Cos_Angle, dot(in_normal, L));
                shadow_attenuation = clamp(shadow_attenuation, 0, 1);
                shadow *= shadow_attenuation;
            }
        }

        Lo += CalculateBRDF(base_color, metallic, roughness, N, V, L, light_color * light.intensity * shadow);
    }

    // if (cluster.num_lights >= Max_Lights_Per_Clusters) {
    //     out_color = float4(1, 0, 0, 1);
    // } else {
    //     out_color = float4(0, cluster.num_lights / float(Max_Lights_Per_Clusters), 0, 1);
    // }
    // return;

    for (uint i = 0; i < cluster.num_lights; i += 1) {
        uint light_index = cluster.lights[i];
        PointLight light = u_point_lights[light_index];
        float3 light_color = sRGBToLinear(light.color);

        float3 L = light.position - in_position;
        float distance_sqrd = dot(L, L);
        float distance = sqrt(distance_sqrd);
        L /= distance;

        float intensity = GetPointLightIntensity(light.source_radius, light.intensity, light.intensity_radius, distance);

        float shadow;
        if (light.shadow_map_index >= 0) {
            PointShadowMap shadow_map = u_point_shadow_maps[light.shadow_map_index];
            shadow = 1 - SamplePointShadowMap(u_frame_info.shadow_map_params, shadow_map, u_shadow_map_noise_texture, u_point_shadow_map_textures[light.shadow_map_index], in_position, N, gl_FragCoord.xy);
        } else {
            shadow = 1;
        }

        if ((mesh.material.flags & MaterialFlags_HasDepthMap) != 0) {
            float3 tangent_light_dir = inv_TBN * L;

            // Remove all light contribution when the light is behind the plane
            if (dot(in_normal, L) < 0) {
                shadow = 0;
            } else {
                // Because we use in_position to calculate the light direction, the shadow is not 100% correct
                // and it changes when the view position changes, because the view position affects tex_coords
                // Ideally we would have a way to modify the vertex position based on the result of parallax mapping,
                // and I am not sure there is a simple performant way to do so
                // Of course in addition to the shadow, it makes any light calculation a bit off, though it is more
                // visible with self shadowing
                shadow *= 1 - ParallaxOcclusionSelfShadow(u_depth_map_texture, mesh.material.depth_map_scale, tex_coords, tangent_light_dir);

                // Shadow don't look good at steep angles, so we attenuate
                float shadow_attenuation = InverseLerp(0, Parallax_Shadow_Attenuation_Cos_Angle, dot(in_normal, L));
                shadow_attenuation = clamp(shadow_attenuation, 0, 1);
                shadow *= shadow_attenuation;
            }
        }

        Lo += CalculateBRDF(base_color, metallic, roughness, N, V, L, light_color * intensity * shadow);
    }

    float3 R = reflect(-V, N);

    float2 irradiance_uv = CartesianToSphericalUV(N);
    #ifndef TEXTURE_ORIGIN_BOTTOM_LEFT
        irradiance_uv.y = 1 - irradiance_uv.y;
    #endif
    float3 irradiance = textureLod(u_irradiance_map, irradiance_uv, 0).rgb;
    irradiance *= u_frame_info.skybox_light_intensity;

    float2 environment_uv = CartesianToSphericalUV(R);
    #ifndef TEXTURE_ORIGIN_BOTTOM_LEFT
        environment_uv.y = 1 - environment_uv.y;
    #endif
    float3 environment = textureLod(u_environment_map, environment_uv, roughness * (Num_Environment_Map_Levels - 1)).rgb;
    environment *= u_frame_info.skybox_light_intensity;

    float3 ambient = CalculateAmbientBRDF(base_color, metallic, roughness, N, V, irradiance, environment, u_brdf_lut);
    float3 color = ambient + Lo + emissive;

    out_color.rgb = color;
    out_color.a = 1;
}
