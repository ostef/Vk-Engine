AssetWorkspaceBuildInfo :: struct {
    asset_types : [..]*Type_Info_Struct;
    generated_asset_code : bool;
}

g_asset_workspace_build_info : [15]AssetWorkspaceBuildInfo;

AddAssetType :: (workspace : Workspace, decl : *Code_Declaration) {
    using info := *g_asset_workspace_build_info[workspace];

    if !decl.expression || decl.expression.kind != .STRUCT {
        return;
    }

    struct_expr := cast(*Code_Struct, decl.expression);
    ArrayPush(*asset_types, xx struct_expr.defined_type);
}

GenerateAssetCode :: (workspace : Workspace, target : *Message) -> bool {
    using info := *g_asset_workspace_build_info[workspace];

    if !target || generated_asset_code {
        return generated_asset_code;
    }

    defer generated_asset_code = true;

    QuickSort(asset_types, (a, b) => StringCompare(a.name, b.name));

    builder : StringBuilder;
    Appendln(*builder, "Asset_Types :: Type.[");

    for asset_types {
        Appendln(*builder, "    %,", it.name);
    }

    Appendln(*builder, "];");

    add_build_string(StringBuilderBuild(*builder), workspace, target);

    LogMessage("Generated asset code");

    return true;
}
