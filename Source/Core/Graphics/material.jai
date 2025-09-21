LoadMaterialFromMemory :: (material : *Material, data : []u8, name : string) -> bool {
    any : Any;
    any.value_pointer = material;
    any.type = type_info(Material);
    result := DeserializeAny(cast(string, data), any);
    if !result.ok {
        LogError("There were errors when loading material '%'\nAt line %: %", name, result.line_index + 1, result.error_msg);
    }

    return true;
}

WriteMaterial :: (builder : *StringBuilder, material : *Material) -> bool {
    serializer : Serializer;
    serializer.builder = builder.*;
    defer builder.* = serializer.builder;

    SerializeAny(*serializer, material.*);

    return true;
}

DestroyMaterial :: (material : *Material) {
    DerefAsset(*material.base_color);
    DerefAsset(*material.normal_map);
    DerefAsset(*material.metallic_roughness_map);
    DerefAsset(*material.emissive);
    DerefAsset(*material.depth_map);
    material.* = .{};
}
