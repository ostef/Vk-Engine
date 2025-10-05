EditorMenusWorkspaceBuildInfo :: struct {
    generated_editor_main_menu_code := false;
    editor_main_menus : [..]string;
    editor_viewport_menus : [..]string;
}

g_editor_menus_workspace_build_info : [15]EditorMenusWorkspaceBuildInfo;

AddEditorMainMenu :: (workspace : Workspace, decl : *Code_Declaration) {
    using info := *g_editor_menus_workspace_build_info[workspace];

    location := make_location(decl);

    if decl.expression && decl.expression.kind == .PROCEDURE_HEADER {
        ArrayPush(*editor_main_menus, decl.name);
    } else {
        compiler_report("Adding EditorMainMenu but is not a procedure declaration.", location);
    }
}

AddEditorViewportMenu :: (workspace : Workspace, decl : *Code_Declaration) {
    using info := *g_editor_menus_workspace_build_info[workspace];

    location := make_location(decl);

    if decl.expression && decl.expression.kind == .PROCEDURE_HEADER {
        ArrayPush(*editor_viewport_menus, decl.name);
    } else {
        compiler_report("Adding EditorViewportMenu but is not a procedure declaration.", location);
    }
}

GenerateEditorMenuCode :: (workspace : Workspace, target : *Message) {
    using info := *g_editor_menus_workspace_build_info[workspace];

    if !target || generated_editor_main_menu_code {
        return;
    }

    defer generated_editor_main_menu_code = true;

    builder : StringBuilder;

    QuickSort(editor_main_menus, StringCompare);
    QuickSort(editor_viewport_menus, StringCompare);

    Appendln(*builder, "InitEditorMainMenus :: () {");

    for editor_main_menus {
        Appendln(*builder, "    RegisterEditorMainMenu(%);", it);
    }

    Appendln(*builder, "}");

    Appendln(*builder, "InitEditorViewportMenus :: () {");

    for editor_viewport_menus {
        Appendln(*builder, "    RegisterEditorViewportMenu(%);", it);
    }

    Appendln(*builder, "}");

    add_build_string(StringBuilderBuild(*builder), workspace, target);

    LogMessage("Generated editor menus code");
}
