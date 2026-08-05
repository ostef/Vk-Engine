MaterialType :: enum u8 {
    Opaque;
    Unlit;
} @ShaderType

Num_Material_Types :: #run type_info(MaterialType).values.count;

Material :: struct {
    type : MaterialType; @Serialize(1)
    base_color_tint : Vec3f = .{1,1,1}; @Serialize(2) @ColorEdit
    base_color : *Asset(Texture2D); @Serialize(3)
    normal_map : *Asset(Texture2D); @Serialize(4)
    metallic : float; @Serialize(5) @FloatRange(0,1)
    roughness : float; @Serialize(6) @FloatRange(0,1)
    metallic_roughness_map : *Asset(Texture2D); @Serialize(7)
    emissive_tint : Vec3f = .{1,1,1}; @Serialize(8) @ColorEdit
    emissive : *Asset(Texture2D); @Serialize(9)
    emissive_strength : float; @Serialize(10)
    depth_map : *Asset(Texture2D); @Serialize(11)
    depth_map_scale : float; @Serialize(12)
    alpha_cutoff := 0.5; @Serialize(13) @FloatRange(0,1)
} @Asset

MaterialFlags :: enum_flags {
    HasMetallicRoughness;
    HasDepthMap;
} @ShaderType

MakeMaterialFlags :: inline (material : Material) -> MaterialFlags {
    result : MaterialFlags;
    if material.metallic_roughness_map {
        result |= .HasMetallicRoughness;
    }
    if material.depth_map {
        result |= .HasDepthMap;
    }

    return result;
}
