#import "File";

APIProcedure :: struct {
    overload_index : int;
    name : string;
    decl : *Code_Declaration;
}

ModuleAPIWorkspaceBuildInfo :: struct {
    api_procedures : [..]APIProcedure;
    generated_module_api_code : bool;
}

g_module_api_workspace_build_info : [15]ModuleAPIWorkspaceBuildInfo;

CompareTypes :: (a : *Type_Info, b : *Type_Info) -> int {
    i := cast(int, a.type) - cast(int, b.type);
    if i != 0 {
        return i;
    }

    if a.type == {
    case .ARRAY;
        a_array := cast(*Type_Info_Array, a);
        b_array := cast(*Type_Info_Array, b);
        i = cast(int, a_array.array_type) - cast(int, b_array.array_type);
        if i != 0 {
            return i;
        }

        i = CompareTypes(a_array.element_type, b_array.element_type);
        if i != 0 {
            return i;
        }

        return a_array.array_count - b_array.array_count;

    case .POINTER;
        a_pointer := cast(*Type_Info_Pointer, a);
        b_pointer := cast(*Type_Info_Pointer, b);

        return CompareTypes(a_pointer.pointer_to, b_pointer.pointer_to);

    case .ENUM;
        a_enum := cast(*Type_Info_Enum, a);
        b_enum := cast(*Type_Info_Enum, b);
        return StringCompare(a_enum.name, b_enum.name);

    case .STRUCT;
        a_struct := cast(*Type_Info_Struct, a);
        b_struct := cast(*Type_Info_Struct, b);
        return StringCompare(a_struct.name, b_struct.name);

    case .PROCEDURE;
        a_proc := cast(*Type_Info_Procedure, a);
        b_proc := cast(*Type_Info_Procedure, b);
        i = a_proc.argument_types.count - b_proc.argument_types.count;
        if i != 0 {
            return i;
        }

        i = a_proc.return_types.count - b_proc.return_types.count;
        if i != 0 {
            return i;
        }

        for j : 0..a_proc.argument_types.count - 1 {
            i = CompareTypes(a_proc.argument_types[j], b_proc.argument_types[j]);
            if i != 0 {
                return i;
            }
        }

        for j : 0..a_proc.return_types.count - 1 {
            i = CompareTypes(a_proc.return_types[j], b_proc.return_types[j]);
            if i != 0 {
                return i;
            }
        }

    case;
        i = a.runtime_size - b.runtime_size;
        if i != 0 {
            return i;
        }
    }

    return 0;
}

CompareAPIProcedures :: (a : APIProcedure, b : APIProcedure) -> int {
    i := StringCompare(a.decl.name, b.decl.name);
    if i != 0 {
        return i;
    }

    return CompareTypes(a.decl.type, b.decl.type);
}

AddModuleAPIProcedure :: (workspace : Workspace, decl : *Code_Declaration) -> bool {
    using info := *g_module_api_workspace_build_info[workspace];

    if !decl.expression || !(decl.flags & .IS_CONSTANT) || decl.expression.kind != .PROCEDURE_HEADER {
        return false;
    }

    // @Todo: make sure it is not polymorphic

    ArrayPush(*api_procedures, .{decl=decl});

    return true;
}

AppendExpression :: (builder : *StringBuilder, expr : *Code_Node) {
    if expr.node_flags & .IS_PARENTHESIZED {
        Append(builder, "(");
    }
    defer if expr.node_flags & .IS_PARENTHESIZED {
        Append(builder, ")");
    }

    if expr.kind == {
    case .LITERAL;
        lit := cast(*Code_Literal, expr);
        if lit.value_type == {
        case .UNINITIALIZED;
            Append(builder, "---");

        case .NUMBER;
            if lit.value_flags & .FLOAT {
                Append(builder, "%", lit._float64);
            } else {
                Append(builder, "%", lit._u64);
            }

        case .STRING;
            StringBuilderAppendStringLiteral(builder, lit._string);

        case .BOOLEAN;
            if lit.values._u64 {
                Append(builder, "true");
            } else {
                Append(builder, "false");
            }

        case .POINTER;
            if lit.pointer_literal_info.pointer_literal_type == .CONSTANT_VALUE && lit.pointer_literal_info.offset_from_symbol == 0 {
                Append(builder, "null");
            } else {
                compiler_report("Unhandled pointer literal", make_location(expr));
                Append(builder, "@Todo");
            }

        case .ARRAY;
            info := lit.array_literal_info;
            if !(info.array_literal_flags & .WAS_UNTYPED) && info.element_type {
                AppendType(builder, info.element_type.result);
            }

            Append(builder, ".[");

            for info.array_members {
                if it_index > 0 {
                    Append(builder, ", ");
                }
                AppendExpression(builder, it);
            }

            Append(builder, "]");

        case .STRUCT;
            info := lit.struct_literal_info;

            if info.type_expression {
                AppendType(builder, info.type_expression.result);
            }

            Append(builder, ".{");
            for info.arguments {
                if it_index > 0 {
                    Append(builder, ", ");
                }
                AppendExpression(builder, it);
            }
            Append(builder, "}");

        case;
            compiler_report(TPrint("Unhandled literal type %", lit.value_type), make_location(expr));
        }

    case .IDENT;
        ident := cast(*Code_Ident, expr);
        Append(builder, "%", ident.name);

    case .UNARY_OPERATOR;
        op := cast(*Code_Unary_Operator, expr);
        if op.operator_type == {
        case #char "-"; Append(builder, "-");
        case #char "~"; Append(builder, "~");
        case #char "*"; Append(builder, "*");
        }

        AppendExpression(builder, op.subexpression);

        if op.operator_type == {
        case xx Operator_Type.POSTFIX_DEREFERENCE; Append(builder, ".*");
        }

    case .BINARY_OPERATOR;
        op := cast(*Code_Binary_Operator, expr);
        AppendExpression(builder, op.left);

        if op.operator_type == {
        case #char "."; Append(builder, ".");
        case #char "+"; Append(builder, " + ");
        case #char "-"; Append(builder, " - ");
        case #char "*"; Append(builder, " * ");
        case #char "/"; Append(builder, " / ");
        case #char "%"; Append(builder, " % ");
        case #char "&"; Append(builder, " & ");
        case #char "|"; Append(builder, " | ");
        case #char "^"; Append(builder, " ^ ");
        case #char "~"; Append(builder, " ~ ");
        case #char "<"; Append(builder, " < ");
        case #char ">"; Append(builder, " > ");
        case xx Operator_Type.IS_EQUAL; Append(builder, " == ");
        case xx Operator_Type.IS_NOT_EQUAL;     Append(builder, " != ");
        case xx Operator_Type.LESS_OR_EQUAL;    Append(builder, " <= ");
        case xx Operator_Type.GREATER_OR_EQUAL; Append(builder, " >= ");
        case xx Operator_Type.LOGICAL_AND;      Append(builder, " && ");
        case xx Operator_Type.LOGICAL_OR;       Append(builder, " || ");
        case xx Operator_Type.SHIFT_LEFT;       Append(builder, " << ");
        case xx Operator_Type.SHIFT_RIGHT;      Append(builder, " >> ");
        case xx Operator_Type.ROTATE_LEFT;      Append(builder, " <<< ");
        case xx Operator_Type.ROTATE_RIGHT;     Append(builder, " >>> ");
        }

        AppendExpression(builder, op.right);

    case .CONTEXT;
        Append(builder, "context");

    case .CAST;
        cast_expr := cast(*Code_Cast, expr);
        if cast_expr.cast_flags & .IS_IMPLICIT {
            AppendExpression(builder, cast_expr.expression);
        } else {
            compiler_report("Non implicit casts are not handled", make_location(expr));
        }

    case;
        compiler_report(TPrint("Unhandled expression kind %", expr.kind), make_location(expr));
    }
}

AppendType :: (builder : *StringBuilder, type : *Type_Info) {
    if type.type == {
    case .VOID;
        Append(builder, "void");
    case .INTEGER;
        integer := cast(*Type_Info_Integer, type);
        if integer.signed {
            Append(builder, "s%", integer.runtime_size * 8);
        } else {
            Append(builder, "u%", integer.runtime_size * 8);
        }
    case .FLOAT;
        if type.runtime_size == 4 {
            Append(builder, "float");
        } else {
            Append(builder, "float64");
        }
    case .BOOL;
        Append(builder, "bool");

    case .STRING;
        Append(builder, "string");

    case .ARRAY;
        array := cast(*Type_Info_Array, type);
        Append(builder, "[");
        if array.array_type == {
        case .VIEW;
        case .FIXED;
            Append(builder, "%", array.array_count);
        case .RESIZABLE;
            Append(builder, "..");
        }
        Append(builder, "]");
        AppendType(builder, array.element_type);

    case .POINTER;
        pointer := cast(*Type_Info_Pointer, type);
        Append(builder, "*");
        AppendType(builder, pointer.pointer_to);

    case .STRUCT;
        struct_type := cast(*Type_Info_Struct, type);
        Append(builder, "%", struct_type.name);

        if struct_type.polymorph_source_struct {
            Append(builder, "(");

            for param : struct_type.specified_parameters {
                if it_index > 0 {
                    Append(builder, ", ");
                }

                value : Any;
                value.type = param.type;
                value.value_pointer = struct_type.constant_storage.data + param.offset_into_constant_storage;

                Append(builder, "%=%", param.name, value);
            }

            Append(builder, ")");
        }

    case .VARIANT;
        variant := cast(*Type_Info_Variant, type);
        if variant.name {
            Append(builder, "%", variant.name);
        } else {
            Append(builder, "#type");
            if variant.variant_flags & .DISTINCT {
                Append(builder, ",distinct");
            }
            if variant.variant_flags & .ISA {
                Append(builder, ",isa");
            }

            Append(builder, " ");
            AppendType(builder, variant.variant_of);
        }

    case .ENUM;
        enum_type := cast(*Type_Info_Enum, type);
        Append(builder, "%", enum_type.name);

    case .TYPE;
        Append(builder, "Type");

    case .ANY;
        Append(builder, "Any");

    case .PROCEDURE;
        proc := cast(*Type_Info_Procedure, type);
        Append(builder, "(");

        for proc.argument_types {
            if it_index > 0 {
                Append(builder, ", ");
            }

            AppendType(builder, it);
        }

        Append(builder, ")");

        if proc.return_types.count > 0 {
            Append(builder, " -> ");
        }

        for proc.return_types {
            if it_index > 0 {
                Append(builder, ", ");
            }

            AppendType(builder, it);
        }

        if proc.procedure_flags & .IS_C_CALL {
            Append(builder, " #c_call");
        }
        if proc.procedure_flags & .HAS_NO_CONTEXT {
            Append(builder, " #no_context");
        }
    }
}

AppendVariableDeclaration :: (builder : *StringBuilder, decl : *Code_Declaration) {
    Assert(decl.kind == .DECLARATION);

    if decl.name {
        Append(builder, "% : ", decl.name);
    }

    AppendType(builder, decl.type);

    if decl.expression {
        Append(builder, " = ");
        AppendExpression(builder, decl.expression);
    }
}

AppendProcedureHeader :: (builder : *StringBuilder, header : *Code_Procedure_Header) {
    Assert(header.kind == .PROCEDURE_HEADER);

    Append(builder, "(");

    for header.arguments {
        if it_index != 0 {
            Append(builder, ", ");
        }
        AppendVariableDeclaration(builder, it);
    }

    Append(builder, ")");

    if header.returns.count > 0 {
        Append(builder, " -> ");
    }

    for header.returns {
        if it_index != 0 {
            Append(builder, ", ");
        }
        AppendVariableDeclaration(builder, it);
    }
}

GenerateModuleAPICode :: (workspace : Workspace, target : *Message, name : string) {
    using info := *g_module_api_workspace_build_info[workspace];

    if !target || generated_module_api_code {
        return;
    }

    defer generated_module_api_code = true;

    QuickSort(api_procedures, CompareAPIProcedures);

    i := 0;
    while i < api_procedures.count - 1 {
        j := 1;
        while i + j < api_procedures.count - 1 {
            if api_procedures[i].decl.name == api_procedures[i + j].decl.name {
                api_procedures[i].overload_index = 1;
                api_procedures[i + j].overload_index = j + 1;
            } else {
                break;
            }

            j += 1;
        }

        i += j;
    }

    builder : StringBuilder;

    Appendln(*builder, "// This file was auto-generated. Do not modify it\n");

    Appendln(*builder, "%Module :: struct {", name);
    Appendln(*builder, "    #as base : Module;");
    for * api_procedures {
        if it.overload_index > 0 {
            it.name = TPrint("%_%", it.decl.name, it.overload_index);
        } else {
            it.name = it.decl.name;
        }

        Append(*builder, "    % : ", it.name);
        AppendProcedureHeader(*builder, xx it.decl.expression);
        Append(*builder, ";\n");
    }
    Appendln(*builder, "}");

    Append(*builder, "\n");

    Appendln(*builder, "#if Import_Mode == .Foreign {");
    Appendln(*builder, "g_%1 : *%1Module;", name);

    Append(*builder, "\n");

    for api_procedures {
        Append(*builder, "% :: inline ", it.decl.name);
        AppendProcedureHeader(*builder, xx it.decl.expression);
        Appendln(*builder, " {");

        header := cast(*Code_Procedure_Header, it.decl.expression);

        Appendln(*builder, "    Assert(g_%1 != null, \"%1 module is null\");", name);

        if header.returns.count == 0 {
            Append (*builder, "    ");
        } else if header.returns.count == 1 {
            Append (*builder, "    return ");
        } else {
            Append(*builder, "    ");
            for i : 0..header.returns.count - 1 {
                if i > 0 {
                    Append(*builder, ", ");
                }
                Append(*builder, "_ret%", i);
            }
            Append(*builder, " := ");
        }

        Append(*builder, "g_%.%(", name, it.name);

        for header.arguments {
            if it_index > 0 {
                Append(*builder, ", ");
            }

            Append(*builder, "%", it.name);
        }

        Appendln(*builder, ");");

        if header.returns.count > 1 {
            Append(*builder, "    return ");
            for i : 0..header.returns.count - 1 {
                if i > 0 {
                    Append(*builder, ", ");
                }
                Append(*builder, "_ret%", i);
            }
            Appendln(*builder, ";");
        }

        Appendln(*builder, "} @NoProfile");
        Append(*builder, "\n");
    }

    Appendln(*builder, "}");

    module_api := StringBuilderBuild(*builder);

    filename := TPrint("Source/%/module_api.jai", name);
    current_contents := read_entire_file(filename);
    // @Speed
    // Avoid writing the file if the result ends up being the same, so we
    // don't rebuild depending modules unnecessarily
    if module_api != current_contents {
        write_entire_file(filename, module_api);
    }

    Appendln(*builder, "InitializeAPI :: (module : *%Module) #c_call {", name);
    for api_procedures {
        Appendln(*builder, "    module.% = %;", it.name, it.decl.name);
    }
    Appendln(*builder, "} @NoProfile");

    initialize_api := StringBuilderBuild(*builder);

    add_build_string(module_api, workspace, target);
    add_build_string(initialize_api, workspace, target);

    LogMessage("Generated module API code");
}
