#import "Common";
#import "Compiler";
#import "File";

#import "Build_Utils";
Core :: #import "Core/Build";
Game :: #import "Game/Build";

Module_Dependencies :: string.[
    "Core",
    "Game",
];

WorkspaceBuildInfo :: struct {
    core_import : *Message_Import;
    game_import : *Message_Import;
    editor_import : *Message_Import;
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
        case "Game";
            game_import = import;
        case "Editor";
            editor_import = import;
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
            Game.GenerateEntityCode(msg.workspace, game_import);
            GenerateModuleAPICode(msg.workspace, editor_import, "Editor");
        }
    }
}

HandleDeclaration :: (workspace : Workspace, decl : *Code_Declaration) {
    Game.HandleDeclarationForEntity(workspace, decl);

    for note : decl.notes {
        if note.text == "ModuleAPI" {
            AddModuleAPIProcedure(workspace, decl);
        }

        Core.HandleNoteOnDeclaration(workspace, decl, note);
        Game.HandleNoteOnDeclaration(workspace, decl, note);
    }
}
