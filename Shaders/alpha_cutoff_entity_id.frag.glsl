#include "common.glsl"

DECLARE_PER_FRAME_PARAMS();
DECLARE_PER_DRAW_CALL_MESH_PARAMS();

layout(location=0) in float3 in_viewpoint_position;
layout(location=1) in flat uint in_instance_index;
layout(location=2) in float3 in_position;
layout(location=3) in float3 in_normal;
layout(location=4) in float3 in_tangent;
layout(location=5) in float3 in_bitangent;
layout(location=6) in float2 in_tex_coords;

layout(location=0) out uint4 out_color;

void main() {
    MeshInstance mesh = u_mesh_instances[in_instance_index];

    float4 base_color = texture(u_base_color_texture, in_tex_coords);
    // Offset the alpha cutoff so we can better select icons that appear transparent
    if (base_color.a < mesh.material.alpha_cutoff - 0.1) {
        discard;
    }

    out_color = u_mesh_instances[in_instance_index].entity_id;
}
