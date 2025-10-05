g_profile_modules : bool;
g_profile_min_num_statements := 10;
g_profile_code : *Code_Node;

Profile_Code :: #code ProfileBlock(GetCPUFrameProfiler());

HandleCompilerTypecheckedMessageForProfiling :: (msg : *Message_Typechecked, target_module : *Message_Import) {
    if !g_profile_code {
        g_profile_code = compiler_get_nodes(Profile_Code);
    }

    for * msg.procedure_bodies {
        body := it.expression;

        if body.body_flags & .ALREADY_MODIFIED {
            continue;
        }

        if !body.header {
            continue;
        }

        allow_flags : type_of(body.header.procedure_flags);
        allow_flags |= .DEBUG_DUMP | .SYMMETRIC | .SYNTACTICALLY_MARKED_AS_INLINE_NO | .POLYMORPHIC;
        if body.header.procedure_flags & ~allow_flags {
            continue;
        }

        always_profile := false;
        for note : body.header.notes {
            if note.text == "NoProfile" {
                continue it;
            } else if note.text == "Profile" {
                always_profile = true;
            }
        }

        if !always_profile && body.block.statements.count < g_profile_min_num_statements {
            continue;
        }

        file := body.enclosing_load;
        if file && file.enclosing_import {
            import := file.enclosing_import;
            if import.module_type == {
            // Do not profile Preload or Runtime_Support
            case .PRELOAD; #through;
            case .RUNTIME_SUPPORT;
                continue;

            case .MAIN_PROGRAM;

            case;
                if !g_profile_modules && import != target_module {
                    continue;
                }
            }
        }

        new_statements : [..]*Code_Node;
        ArrayReserve(*new_statements, body.block.statements.count + 1);
        ArrayPush(*new_statements, g_profile_code);
        ArrayPushMultiple(*new_statements, body.block.statements);

        body.block.statements = new_statements;

        compiler_modify_procedure(msg.workspace, body);
    }
}
