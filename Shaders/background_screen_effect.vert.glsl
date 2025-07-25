#include "common.glsl"

const float2 Positions[] = float2[](
    float2(0, 1), float2(1, 1), float2(1, 0),
    float2(0, 1), float2(1, 0), float2(0, 0)
);

layout(location=0) out float2 out_position;

void main() {
    out_position = Positions[gl_VertexIndex];

    gl_Position.xy = out_position * 2 - float2(1);
    gl_Position.z = 1;
    gl_Position.w = 1;
}
