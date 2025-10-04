#module_parameters(Import_Mode := ImportMode.Foreign) {
    ImportMode :: enum {
        Foreign;
        Main;
    }
}

#import "Core";

#import "Common";
#import "Linalg";
#import "Hash_Map";
#import "Paged_Array";
#import "Random";
#import "String";
#import "Remap_Context"(VERBOSE=false);
#import "Compiler";
#import "Type_Utils";
#import "File";
#import "File_Utilities";

#if Import_Mode == .Foreign {
    #load "module_api.jai";
} else {
    #load "main.jai";
}

using _ :: struct {
    Reverse_Depth_Range :: true;
} @ShaderType

ViewpointToRender :: struct {
    Flags :: enum_flags {
        NoShadowMap;
        NoDebugLines;
        NoGrids;
        NoEntitySelection;
        NoGizmos;
    }

    unique_id : u64;
    flags : Flags;

    position : Vec3f;
    right, up, direction : Vec3f;
    transform : Mat4f;
    view : Mat4f;
    projection : Mat4f;
    inv_projection : Mat4f;
    view_projection : Mat4f;
    inv_view_projection : Mat4f;
    resolution : Vec2u;
    fov : float;
    z_near : float;
    z_far : float;

    frustum : Frustum;

    skybox : *Asset(EnvironmentMap);
    skybox_light_intensity : float;

    gizmo_widgets : [..]GizmoWidgetToRender;
    gizmo_lines : [..]DebugLine;
}

MakeViewpointID :: inline (str : string) -> u64 {
    #import "Hash";

    return fnv1a_hash(str.data, str.count);
}

ViewpointRenderTargets :: struct {
    final_color_texture : GfxTexture;
    hdr_color_texture : GfxTexture;
    depth_texture : GfxTexture;
    entity_guids_texture : GfxTexture;
    selected_entity_guids_texture : GfxTexture;
    entity_guids_readback_buffers : [Gfx_Num_Frames_In_Flight]GfxBuffer;
    bloom_textures : BloomTextures;
    gizmo_color_texture : GfxTexture;
    gizmo_color_resolve : GfxTexture;
    gizmo_depth_texture : GfxTexture;
}

Bloom_Resolution_Factor :: 0.75;
Bloom_Num_Downsample_Passes :: 7;

BloomTextures :: struct {
    downsample_texture : GfxTexture;
    downsample_levels : [Bloom_Num_Downsample_Passes + 1]GfxTexture;
    upsample_texture : GfxTexture;
    upsample_levels : [Bloom_Num_Downsample_Passes]GfxTexture;
}

GetFinalBloomTexture :: inline (using bloom : *BloomTextures) -> *GfxTexture {
    return *upsample_levels[0];
}

MeshToRender :: struct {
    entity_guid : GUID;
    transform : Mat4f;
    vertex_buffer, index_buffer : *GfxBuffer;
    vertex_count, index_count : u32;
    static_bounds : AABB;
    material : *Asset(Material);
    cast_shadows : bool;
    cast_point_shadows : bool;
    is_billboard : bool;
    is_skinned : bool;
    skinning_matrices : []Mat4f;
}

DirectionalLightToRender :: struct {
    direction : Vec3f;
    color : Vec3f;
    intensity : float;
    shadow_map_index := -1;
}

PointLightToRender :: struct {
    position : Vec3f;
    color : Vec3f;
    intensity : float;
    intensity_radius : float;
    source_radius : float;
    shadow_map_index := -1;
}

Default_Shadow_Map_Resolution :: 2048;

Shadow_Map_Cascade_Sizes : [Num_Shadow_Map_Cascades]float : .[5,20,50,200];
Shadow_Map_Forward_Offset :: 1.0;
Shadow_Map_Depth_Extent_Factor :: 6.0;

using _ :: struct {
    Shadow_Map_Reverse_Depth_Range :: true;
    Num_Shadow_Map_Cascades :: 4;
    Shadow_Map_Noise_Size :: 32;
    Num_Shadow_Map_Sqrt_Samples :: 8;
    Num_Shadow_Map_Samples :: Num_Shadow_Map_Sqrt_Samples * Num_Shadow_Map_Sqrt_Samples;
} @ShaderType

ShadowMapToRender :: struct {
    direction : Vec3f;
    target_transform : Mat4f;
    cascade_sizes : [Num_Shadow_Map_Cascades]float = Shadow_Map_Cascade_Sizes;
    resolution : u32;
}

Default_Point_Shadow_Map_Resolution :: 1024;

PointShadowMapToRender :: struct {
    position : Vec3f;
    z_near, z_far : float;
    resolution : u32;
}

GizmoWidgetToRender :: struct {
    transform : Mat4f;
    vertex_buffer, index_buffer : *GfxBuffer;
    vertex_count, index_count : u32;
    shaded : bool;
    color : Vec4f;
}

DebugLine :: struct {
    start : Vec3f;
    end : Vec3f;
    color : Vec4f;
} @ShaderType
