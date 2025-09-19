#import "Common";
#import "Compiler";
#import "File";

#load "../api_metaprogram.jai";

Module_Dependencies :: string.[];

HandleCompilerMessage :: (msg : *Message) {
    if msg.kind == {
    case .TYPECHECKED;
        typechecked := cast(*Message_Typechecked, msg);
        for typechecked.declarations {
            HandleDeclaration(it.expression);
        }

    case .PHASE;
        phase := cast(*Message_Phase, msg);
        if phase.phase == .TYPECHECKED_ALL_WE_CAN {
            GenerateModuleAPICode(msg.workspace, "Core");
        }
    }
}

HandleDeclaration :: (decl : *Code_Declaration) {
    for note : decl.notes {
        if note.text == "ModuleAPI" {
            AddModuleAPIProcedure(decl);
        }
    }
}
