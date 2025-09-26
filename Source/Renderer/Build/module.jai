#import "Common";
#import "Compiler";
#import "File";

#import "Build_Utils";
Core :: #import "Core/Build";

#load "shader_codegen.jai";
#load "binding_set.jai";

Module_Dependencies :: string.[
    "Core",
];

WorkspaceBuildInfo :: struct {
    core_import : *Message_Import;
    renderer_import : *Message_Import;
}

g_workspace_build_info : [15]WorkspaceBuildInfo;

HandleCompilerMessage :: (msg : *Message) {
    using info := *g_workspace_build_info[msg.workspace];

    if msg.kind == {
    case .IMPORT;
        import := cast(*Message_Import, msg);
        if import.module_name == {
        case "Core";
            core_import = import;
        case "Renderer";
            renderer_import = import;
        }

    case .TYPECHECKED;
        typechecked := cast(*Message_Typechecked, msg);
        for typechecked.declarations {
            HandleDeclaration(msg.workspace, it.expression);
        }

    case .PHASE;
        phase := cast(*Message_Phase, msg);
        if phase.phase == .TYPECHECKED_ALL_WE_CAN {
            Core.GenerateAssetCode(msg.workspace, core_import);
            GenerateBindingSetCode(msg.workspace, renderer_import);
            GenerateModuleAPICode(msg.workspace, renderer_import, "Renderer");
        }

    case .COMPLETE;
        GenerateShaderCode();
    }
}

HandleDeclaration :: (workspace : Workspace, decl : *Code_Declaration) {
    for note : decl.notes {
        if note.text == "ModuleAPI" {
            AddModuleAPIProcedure(workspace, decl);
        }
        if note.text == "BindingSet" {
            AddBindingSetType(workspace, decl);
        }
        if note.text == "ShaderType" {
            AddShaderType(decl);
        }

        Core.HandleNoteOnDeclaration(workspace, decl, note);
        HandleNoteOnDeclaration(workspace, decl, note);
    }
}

HandleNoteOnDeclaration :: (workspace : Workspace, decl : *Code_Declaration, note : *Code_Note) {
}
