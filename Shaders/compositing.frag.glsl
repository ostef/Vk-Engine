#include "common.glsl"
#include "fxaa.glsl"

DECLARE_PER_FRAME_PARAMS();

layout(set=1, binding=0) uniform ViewpointData { \
    Viewpoint u_viewpoint; \
};

layout(set=1, binding=1) uniform sampler2D u_hdr_color_texture;
layout(set=1, binding=2) uniform sampler2D u_bloom_texture;
layout(set=1, binding=3) uniform usampler2D u_entity_guid_texture;
layout(set=1, binding=4) uniform usampler2D u_selected_entity_guid_texture;
// layout(set=1, binding=5) uniform sampler2D u_gizmo_texture;

layout(location=0) in float2 in_position;

layout(location=0) out float4 out_color;

float4 GetEntityOutline(float2 tex_coords, float2 texel_size) {
    float steps = u_frame_info.entity_outline_params.thickness * 3;
    float4 outline_color = float4(u_frame_info.entity_outline_params.color.rgb, 0);
    float2 inv_thickness = floor(u_frame_info.entity_outline_params.thickness) * texel_size;
    bool at_edge = ApproxEquals(tex_coords.x, 0, inv_thickness.x)
        || ApproxEquals(tex_coords.x, 1, inv_thickness.x)
        || ApproxEquals(tex_coords.y, 0, inv_thickness.y)
        || ApproxEquals(tex_coords.y, 1, inv_thickness.y);

    uint4 sampled_at_point = texture(u_selected_entity_guid_texture, tex_coords);
    if (at_edge || sampled_at_point == uint4(0)) {
        for (float i = 0; i < Tau; i += Tau / steps) {
            float2 offset = float2(sin(i), cos(i)) * texel_size * u_frame_info.entity_outline_params.thickness;
            uint4 sampled = texture(u_selected_entity_guid_texture, tex_coords + offset);
            if (sampled != uint4(0)) {
                // Render outline with a different alpha if it is covered by another mesh
                uint4 frontmost_entity = texture(u_entity_guid_texture, tex_coords + offset);
                if (frontmost_entity != uint4(0) && frontmost_entity != sampled) {
                    outline_color.a = u_frame_info.entity_outline_params.covered_alpha;
                } else {
                    outline_color.a = 1;
                }
                break;
            }
        }
    }

    return outline_color;
}

void main() {
    float3 color = FXAA(u_hdr_color_texture, in_position, 1 / u_viewpoint.viewport_size).rgb;

    int2 bloom_size = textureSize(u_bloom_texture, 0);
    float4 bloom = UpsampleTent9(u_bloom_texture, in_position, 1 / float2(bloom_size));
    color += bloom.rgb * u_frame_info.bloom_params.blend_intensity;

    color = ApplyToneMapping(color);
    color = LinearTosRGB(color);

    float4 entity_outline = GetEntityOutline(in_position, 1 / u_viewpoint.viewport_size);
    color = BlendRGBPostMultipliedAlpha(color, entity_outline.rgb, entity_outline.a);

    // float4 gizmo = texture(u_gizmo_texture, in_position);
    // color = BlendRGBPreMultipliedAlpha(color, gizmo.rgb, gizmo.a);

    out_color = float4(color, 1);
}
