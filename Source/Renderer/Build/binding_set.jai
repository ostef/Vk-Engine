BindingSetWorkspaceBuildInfo :: struct {
    shader_binding_set_types : [..]*Type_Info_Struct;
    generated_renderer_code : bool;
}

g_binding_set_workspace_build_info : [15]BindingSetWorkspaceBuildInfo;

AddBindingSetType :: (workspace : Workspace, decl : *Code_Declaration) {
    using _ := *g_binding_set_workspace_build_info[workspace];

    location := make_location(decl);

    struct_type : *Type_Info_Struct;
    if decl.expression && decl.expression.kind == .STRUCT {
        struct_type = cast(*Code_Struct, decl.expression).defined_type;
    }

    if struct_type {
        ArrayPushUnique(*shader_binding_set_types, struct_type);
    } else {
        compiler_report(
            "Adding binding set type but declaration is not a struct.",
            location
        );
    }
}

GenerateBindingSetCode :: (workspace : Workspace, target : *Message) {
    using _ := *g_binding_set_workspace_build_info[workspace];

    if !target || generated_renderer_code {
        return;
    }

    defer generated_renderer_code = true;

    builder : StringBuilder;

    Appendln(*builder, "Shader_Binding_Set_Types :: Type.[");
    for shader_binding_set_types {
        Appendln(*builder, "    %,", it.name);
    }
    Appendln(*builder, "];");

    add_build_string(StringBuilderBuild(*builder), workspace, target);

    LogMessage("Generated binding set code");
}
