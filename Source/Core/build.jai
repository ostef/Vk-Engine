#import "Common";
#import "Compiler";
#import "File";

#load "../api_metaprogram.jai";

Module_Dependencies :: string.[];

WorkspaceBuildInfo :: struct {
    core_import : *Message_Import;

    asset_types : [..]*Type_Info_Struct;
    generated_asset_code : bool;
}

g_workspace_build_info : [15]WorkspaceBuildInfo;

HandleCompilerMessage :: (msg : *Message) {
    using info := *g_workspace_build_info[msg.workspace];

    if msg.kind == {
    case .IMPORT;
        import := cast(*Message_Import, msg);
        if import.module_name == "Core" {
            core_import = import;
        }

    case .TYPECHECKED;
        typechecked := cast(*Message_Typechecked, msg);
        for typechecked.declarations {
            HandleDeclaration(msg.workspace, it.expression);
        }

    case .PHASE;
        phase := cast(*Message_Phase, msg);
        if phase.phase == .TYPECHECKED_ALL_WE_CAN {
            GenerateAssetCode(msg.workspace, core_import);
            GenerateModuleAPICode(msg.workspace, core_import, "Core");
        }
    }
}

HandleDeclaration :: (workspace : Workspace, decl : *Code_Declaration) {
    for note : decl.notes {
        if note.text == "ModuleAPI" {
            AddModuleAPIProcedure(workspace, decl);
        }

        HandleNoteOnDeclaration(workspace, decl, note);
    }
}

HandleNoteOnDeclaration :: (workspace : Workspace, decl : *Code_Declaration, note : *Code_Note) {
    if note.text == "Asset" {
        AddAssetType(workspace, decl);
    }
}

AddAssetType :: (workspace : Workspace, decl : *Code_Declaration) {
    using info := *g_workspace_build_info[workspace];

    if !decl.expression || decl.expression.kind != .STRUCT {
        return;
    }

    struct_expr := cast(*Code_Struct, decl.expression);
    ArrayPush(*asset_types, xx struct_expr.defined_type);
}

GenerateAssetCode :: (workspace : Workspace, target : *Message) {
    using info := *g_workspace_build_info[workspace];

    if !target || generated_asset_code {
        return;
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
}
