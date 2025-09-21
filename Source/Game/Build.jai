#import "Common";
#import "Compiler";
#import "File";

Core :: #import "Core/Build";

#load "../api_metaprogram.jai";

Module_Dependencies :: string.[
    "Source/Core/API",
    "Source/Core/module.jai",
];

WorkspaceBuildInfo :: struct {
    game_import : *Message_Import;
    core_import : *Message_Import;
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
            Println("Found Core import");

        case "Game";
            game_import = import;
            Println("Found Game import");
        }

    case .TYPECHECKED;
        typechecked := cast(*Message_Typechecked, msg);
        for typechecked.declarations {
            HandleDeclaration(msg.workspace, it.expression);
        }

    case .PHASE;
        phase := cast(*Message_Phase, msg);
        if phase.phase == .TYPECHECKED_ALL_WE_CAN {
            if core_import {
                Core.GenerateAssetCode(msg.workspace, core_import);
            }

            GenerateModuleAPICode(msg.workspace, game_import, "Game");
        }
    }
}

HandleDeclaration :: (workspace : Workspace, decl : *Code_Declaration) {
    for note : decl.notes {
        if note.text == "ModuleAPI" {
            AddModuleAPIProcedure(workspace, decl);
        }

        Core.HandleNoteOnDeclaration(workspace, decl, note);
    }
}
