#include "common.glsl"

DECLARE_PER_FRAME_PARAMS();

layout(set=1, binding=0) uniform ViewpointData {
    Viewpoint u_viewpoint;
};
layout(set=1, binding=1) uniform sampler2D u_skybox;

layout(location=0) in float2 in_position;

layout(location=0) out float4 out_color;

void main() {
    float cam_width_scale = 2 * tan(u_viewpoint.fov * 0.5);
    float cam_height_scale = cam_width_scale * u_viewpoint.viewport_size.y / u_viewpoint.viewport_size.x;

    float2 xy = 2 * in_position - float2(1);
    xy.y = -xy.y;
    float3 ray_direction = normalize(
        u_viewpoint.direction
        + u_viewpoint.right * xy.x * cam_width_scale
        + u_viewpoint.up * xy.y * cam_height_scale
    );

    float2 uv = CartesianToSphericalUV(ray_direction);
    uv.y = 1 - uv.y;

    float3 color = textureLod(u_skybox, uv, 0).rgb;
    color *= u_frame_info.skybox_light_intensity;

    out_color = float4(color, 1);
}
