#import "Common";
#import "Compiler";
#import "File";

#import "Build_Utils";

#load "asset.jai";
#load "profiler.jai";

Module_Dependencies :: string.[];

WorkspaceBuildInfo :: struct {
    core_import : *Message_Import;
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

        HandleCompilerTypecheckedMessageForProfiling(typechecked, core_import);

    case .PHASE;
        phase := cast(*Message_Phase, msg);
        if phase.phase == .TYPECHECKED_ALL_WE_CAN {
            GenerateAssetCode(msg.workspace, core_import);

            GenerateModuleAPICode(msg.workspace, core_import, "Core");
            GenerateModuleContextType(msg.workspace, core_import, "Core");
        }

    case .COMPLETE;
        if !WriteModuleAPIFile(msg.workspace, core_import, "Core", with_context_type=true) {
            LogError("Could not write module API file");
            compiler_set_workspace_status(.FAILED);
        }
    }
}

HandleDeclaration :: (workspace : Workspace, decl : *Code_Declaration) {
    for note : decl.notes {
        if note.text == "ModuleContext" {
            SetContextType(workspace, decl);
        }
        if note.text == "Public" {
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
