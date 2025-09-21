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

MeshToRender :: struct {
    entity_guid : GUID;
    transform : Mat4f;
    vertex_buffer, index_buffer : *GfxBuffer;
    vertex_count, index_count : u32;
    static_bounds : AABB;
    material : *Asset(Material);
    cast_shadows : bool;
    cast_point_shadows : bool;
    is_skinned : bool;
    skinning_matrices : []Mat4f;
}

PointLightToRender :: struct {
    position : Vec3f;
    color : Vec3f;
    intensity : float;
    intensity_radius : float;
    source_radius : float;
}

DirectionalLightToRender :: struct {
    direction : Vec3f;
    color : Vec3f;
    intensity : float;
}
