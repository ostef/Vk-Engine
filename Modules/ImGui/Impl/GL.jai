#import "Common";
#import "GL";
#import "GL_Utils";

#scope_file

ImGui :: #import "ImGui";

ImVec2 :: ImGui.ImVec2;
ImDrawVert :: ImGui.ImDrawVert;
ImDrawIdx :: ImGui.ImDrawIdx;

#scope_export

UserData :: struct
{
    jai_context : *#Context;
    gl_version : int;
    shader_handle : GLuint;
    font_texture : GLuint;
    attrib_location_tex : GLuint;
    attrib_location_proj_mtx : GLuint;
    attrib_location_vtx_pos : GLuint;
    attrib_location_vtx_uv : GLuint;
    attrib_location_vtx_color : GLuint;
    vbo_handle, ibo_handle : GLuint;
    vertex_buffer_size : s64;
    index_buffer_size : s64;
    use_buffer_sub_data : bool;
}

GetUserData :: inline () -> *UserData #no_context
{
    if ImGui.GetCurrentContext()
        return cast(*UserData) ImGui.GetIO().BackendRendererUserData;

    return null;
}

Init :: () -> bool
{
    io := ImGui.GetIO();
    Assert(io.BackendRendererUserData == null, "Renderer backend already initialized");

    data := Alloc(UserData);
    data.jai_context = *context;
    io.BackendRendererUserData = data;
    io.BackendRendererName = "OpenGL3";

    major, minor : GLint;
    glGetIntegerv(GL_MAJOR_VERSION, *major);
    glGetIntegerv(GL_MINOR_VERSION, *minor);
    data.gl_version = major * 100 + minor * 10;

    #if OS == .WINDOWS
    {
        vendor := MakeString(cast(*u8) glGetString(GL_VENDOR));
        data.use_buffer_sub_data = StringStartsWith(vendor, "Intel");
    }

    // if data.gl_version >= 320
    //     io.BackendFlags_ |= .RendererHasVtxOffset;
    io.BackendFlags_ |= .RendererHasViewports;

    if io.ConfigFlags_ & .ViewportsEnable
        InitPlatformInterface();

    return CreateDeviceObjects();
}

Terminate :: ()
{
    data := GetUserData();
    Assert(data != null, "Renderer backend not initialized or already shut down");

    io := ImGui.GetIO();

    DestroyDeviceObjects();
    io.BackendRendererName = null;
    io.BackendRendererUserData = null;
    Free(data);
}

#scope_file

SetupRenderState :: (draw_data : *ImGui.ImDrawData, fb_width : s32, fb_height : s32, vao : GLuint) #no_context
{
    data := GetUserData();

    glActiveTexture(GL_TEXTURE0);

    // Setup render state: alpha-blending enabled, no face culling, no depth testing, scissor enabled, polygon fill
    glEnable(GL_BLEND);
    glBlendEquation(GL_FUNC_ADD);
    glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

    glDisable(GL_CULL_FACE);
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_STENCIL_TEST);
    glEnable(GL_SCISSOR_TEST);

    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

    // Setup viewport, orthographic projection matrix
    // Our visible imgui space lies from draw_data->DisplayPos (top left) to draw_data->DisplayPos+data_data->DisplaySize (bottom right). DisplayPos is (0,0) for single viewport apps.
    glViewport(0, 0, xx fb_width, xx fb_height);
    L := draw_data.DisplayPos.x;
    R := draw_data.DisplayPos.x + draw_data.DisplaySize.x;
    T := draw_data.DisplayPos.y;
    B := draw_data.DisplayPos.y + draw_data.DisplaySize.y;

    ortho_projection : [4][4]float = .[
        .[ 2.0/(R-L),    0.0,          0.0,   0.0 ],
        .[ 0.0,          2.0/(T-B),    0.0,   0.0 ],
        .[ 0.0,          0.0,         -1.0,   0.0 ],
        .[ (R+L)/(L-R),  (T+B)/(B-T),  0.0,   1.0 ],
    ];

    glUseProgram(data.shader_handle);

    glUniform1i(xx data.attrib_location_tex, 0);
    glUniformMatrix4fv(xx data.attrib_location_proj_mtx, 1, GL_FALSE, ortho_projection.data.data);

    glBindVertexArray(vao);

    // Bind vertex/index buffers and setup attributes for ImDrawVert
    glBindBuffer(GL_ARRAY_BUFFER, data.vbo_handle);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, data.ibo_handle);
    glEnableVertexAttribArray(data.attrib_location_vtx_pos);
    glEnableVertexAttribArray(data.attrib_location_vtx_uv);
    glEnableVertexAttribArray(data.attrib_location_vtx_color);
    glVertexAttribPointer(data.attrib_location_vtx_pos,   2, GL_FLOAT,         GL_FALSE, size_of(ImDrawVert), cast(*void) OffsetOf(ImDrawVert, "pos"));
    glVertexAttribPointer(data.attrib_location_vtx_uv,    2, GL_FLOAT,         GL_FALSE, size_of(ImDrawVert), cast(*void) OffsetOf(ImDrawVert, "uv"));
    glVertexAttribPointer(data.attrib_location_vtx_color, 4, GL_UNSIGNED_BYTE, GL_TRUE,  size_of(ImDrawVert), cast(*void) OffsetOf(ImDrawVert, "col"));
}

#scope_export

RenderDrawData :: (draw_data : *ImGui.ImDrawData) #c_call
{
    fb_width  := cast(s32) (draw_data.DisplaySize.x * draw_data.FramebufferScale.x);
    fb_height := cast(s32) (draw_data.DisplaySize.y * draw_data.FramebufferScale.y);
    if fb_width <= 0 || fb_height <= 0
        return;

    data := GetUserData();

    ctx := data.jai_context.*;
    push_context ctx
    {

        // Backup GL state
        StateBlock(GL_ACTIVE_TEXTURE, (prev : GLenum) {glActiveTexture(prev);});
        StateBlock(GL_CURRENT_PROGRAM, (prev : GLuint) {glUseProgram(prev);});
        StateBlock(GL_ARRAY_BUFFER_BINDING, (prev : GLuint) {glBindBuffer(GL_ARRAY_BUFFER, prev);});
        StateBlock(GL_ELEMENT_ARRAY_BUFFER_BINDING, (prev : GLuint) {glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, prev);});
        StateBlock(GL_VERTEX_ARRAY_BINDING, (prev : GLuint) {glBindVertexArray(prev);});
        StateBlock(GL_POLYGON_MODE, 2, (prev : [2]GLenum) {glPolygonMode(GL_FRONT_AND_BACK, prev[0]);});
        StateBlock(GL_VIEWPORT, 4, (v : [4]GLint) {glViewport(v[0], v[1], xx v[2], xx v[3]);});
        StateBlock(GL_SCISSOR_BOX, 4, (v : [4]GLint) {glScissor(v[0], v[1], xx v[2], xx v[3]);});

        BlendFuncStateBlock();
        EnableBlock(GL_BLEND);
        DisableBlock(GL_CULL_FACE);
        DisableBlock(GL_DEPTH_TEST);
        DisableBlock(GL_STENCIL_TEST);
        EnableBlock(GL_SCISSOR_TEST);

        vao : GLuint;
        glGenVertexArrays(1, *vao);
        SetupRenderState(draw_data, fb_width, fb_height, vao);

        clip_off := draw_data.DisplayPos;
        clip_scale := draw_data.FramebufferScale;

        for n : 0..draw_data.CmdListsCount - 1
        {
            list := draw_data.CmdLists.Data[n];

            vtx_buffer_size := list.VtxBuffer.Size * size_of(ImDrawVert);
            idx_buffer_size := list.IdxBuffer.Size * size_of(ImDrawIdx);
            if data.use_buffer_sub_data
            {
                if data.vertex_buffer_size < vtx_buffer_size
                {
                    glBufferData(GL_ARRAY_BUFFER, vtx_buffer_size, null, GL_STREAM_DRAW);
                    data.vertex_buffer_size = vtx_buffer_size;
                }
                if data.index_buffer_size < idx_buffer_size
                {
                    glBufferData(GL_ELEMENT_ARRAY_BUFFER, idx_buffer_size, null, GL_STREAM_DRAW);
                    data.index_buffer_size = idx_buffer_size;
                }
                glBufferSubData(GL_ARRAY_BUFFER, 0, vtx_buffer_size, list.VtxBuffer.Data);
                glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, idx_buffer_size, list.IdxBuffer.Data);
            }
            else
            {
                glBufferData(GL_ARRAY_BUFFER, vtx_buffer_size, list.VtxBuffer.Data, GL_STREAM_DRAW);
                glBufferData(GL_ELEMENT_ARRAY_BUFFER, idx_buffer_size, list.IdxBuffer.Data, GL_STREAM_DRAW);
            }

            for icmd : 0..list.CmdBuffer.Size - 1
            {
                cmd := *list.CmdBuffer.Data[icmd];
                if cmd.UserCallback
                {
                    if cmd.UserCallback == xx ImGui.ImDrawCallback_ResetRenderState
                        SetupRenderState(draw_data, fb_width, fb_height, vao);
                    else
                        cmd.UserCallback(list, cmd);
                }
                else
                {
                    clip_min := ImVec2.{(cmd.ClipRect.x - clip_off.x) * clip_scale.x, (cmd.ClipRect.y - clip_off.y) * clip_scale.y};
                    clip_max := ImVec2.{(cmd.ClipRect.z - clip_off.x) * clip_scale.x, (cmd.ClipRect.w - clip_off.y) * clip_scale.y};
                    if clip_max.x <= clip_min.x || clip_max.y <= clip_min.y
                        continue;

                    glScissor(xx clip_min.x, xx (fb_height - clip_max.y), xx (clip_max.x - clip_min.x), xx (clip_max.y - clip_min.y));

                    glBindTexture(GL_TEXTURE_2D, cast(GLuint) cmd.TextureId);
                    glDrawElements(
                        GL_TRIANGLES,
                        xx cmd.ElemCount,
                        cast(u32) ifx size_of(ImDrawIdx) == 2 then GL_UNSIGNED_SHORT else GL_UNSIGNED_INT,
                        cast(*void) (cmd.IdxOffset * size_of(ImDrawIdx))
                    );
                }
            }
        }

        glDeleteVertexArrays(1, *vao);
    }
}

CreateFontsTexture :: ()
{
    io := ImGui.GetIO();
    data := GetUserData();

    pixels : *u8;
    width, height : s32;
    io.Fonts.GetTexDataAsRGBA32(io.Fonts, *pixels, *width, *height);

    StateBlock(GL_TEXTURE_BINDING_2D, (prev : GLuint) {glBindTexture(GL_TEXTURE_2D, prev);});

    glGenTextures(1, *data.font_texture);
    glBindTexture(GL_TEXTURE_2D, data.font_texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, xx width, xx height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);

    io.Fonts.TexID = cast(ImGui.ImTextureID) data.font_texture;
}

DestroyFontsTexture :: ()
{
    io := ImGui.GetIO();
    data := GetUserData();

    glDeleteTextures(1, *data.font_texture);
    data.font_texture = 0;
    io.Fonts.TexID = cast(ImGui.ImTextureID) 0;
}

CreateDeviceObjects :: () -> bool
{
    data := GetUserData();

    StateBlock(GL_TEXTURE_BINDING_2D, (prev : GLuint) {glBindTexture(GL_TEXTURE_2D, prev);});
    StateBlock(GL_ARRAY_BUFFER_BINDING, (prev : GLuint) {glBindBuffer(GL_ARRAY_BUFFER, prev);});
    StateBlock(GL_ELEMENT_ARRAY_BUFFER_BINDING, (prev : GLuint) {glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, prev);});

    Vertex_Shader :: #string GLSL
#version 330 core

layout(location = 0) in vec2 Position;
layout(location = 1) in vec2 UV;
layout(location = 2) in vec4 Color;
uniform mat4 ProjMtx;
out vec2 Frag_UV;
out vec4 Frag_Color;
void main()
{
    Frag_UV = UV;
    Frag_Color = Color;
    gl_Position = ProjMtx * vec4(Position.xy,0,1);
}
GLSL;

    Fragment_Shader :: #string GLSL
#version 330 core

uniform sampler2D Texture;
in vec2 Frag_UV;
in vec4 Frag_Color;
layout(location = 0) out vec4 Out_Color;
void main()
{
    Out_Color = Frag_Color * texture(Texture, Frag_UV.st);
}
GLSL

    data.shader_handle = CreateShaderProgram(Vertex_Shader, Fragment_Shader);
    if !data.shader_handle
        return false;

    data.attrib_location_tex = xx glGetUniformLocation(data.shader_handle, "Texture");
    data.attrib_location_proj_mtx = xx glGetUniformLocation(data.shader_handle, "ProjMtx");
    data.attrib_location_vtx_pos = xx glGetAttribLocation(data.shader_handle, "Position");
    data.attrib_location_vtx_uv = xx glGetAttribLocation(data.shader_handle, "UV");
    data.attrib_location_vtx_color = xx glGetAttribLocation(data.shader_handle, "Color");

    glGenBuffers(1, *data.vbo_handle);
    glGenBuffers(1, *data.ibo_handle);

    CreateFontsTexture();

    return true;
}

DestroyDeviceObjects :: ()
{
    using data := GetUserData();

    glDeleteBuffers(1, *vbo_handle);
    vbo_handle = 0;
    glDeleteBuffers(1, *ibo_handle);
    ibo_handle = 0;
    glDeleteProgram(shader_handle);
    shader_handle = 0;
    DestroyFontsTexture();
}

//--------------------------------------------------------------------------------------------------------
// MULTI-VIEWPORT / PLATFORM INTERFACE SUPPORT
// This is an _advanced_ and _optional_ feature, allowing the backend to create and handle multiple viewports simultaneously.
// If you are new to dear imgui or creating a new binding for dear imgui, it is recommended that you completely ignore this section first..
//--------------------------------------------------------------------------------------------------------

RenderWindow :: (viewport : *ImGui.Viewport, arg : *void) #c_call
{
    if !(viewport.Flags & .NoRendererClear)
    {
        glClearColor(0, 0, 0, 1);
        glClear(GL_COLOR_BUFFER_BIT);
    }

    RenderDrawData(viewport.DrawData);
}

InitPlatformInterface :: ()
{
    platform_io := ImGui.GetPlatformIO();
    platform_io.Renderer_RenderWindow = RenderWindow;
}
