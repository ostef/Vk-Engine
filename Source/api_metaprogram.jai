APIProcedure :: struct {
    overload_index : int;
    name : string;
    decl : *Code_Declaration;
}

g_api_procedures : [..]APIProcedure;
g_generated_module_api_code : bool;

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

AddModuleAPIProcedure :: (decl : *Code_Declaration) -> bool {
    if !decl.expression || !(decl.flags & .IS_CONSTANT) || decl.expression.kind != .PROCEDURE_HEADER {
        return false;
    }

    // @Todo: make sure it is not polymorphic

    ArrayPush(*g_api_procedures, .{decl=decl});

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
                Append(builder, "%", get_type(info.element_type.result));
            }

            Append(builder, ".[");

            for info.array_members {
                if it_index > 0 {
                    Append(builder, ", ");
                }
                AppendExpression(builder, it);
            }

            Append(builder, "]");

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

AppendVariableDeclaration :: (builder : *StringBuilder, decl : *Code_Declaration) {
    Assert(decl.kind == .DECLARATION);

    if decl.name {
        Append(builder, "% : ", decl.name);
    }

    Append(builder, "%", get_type(decl.type));

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

GenerateModuleAPICode :: (workspace : Workspace, name : string) {
    if g_generated_module_api_code {
        return;
    }

    defer g_generated_module_api_code = true;

    QuickSort(g_api_procedures, CompareAPIProcedures);

    i := 0;
    while i < g_api_procedures.count - 1 {
        j := 1;
        while i + j < g_api_procedures.count - 1 {
            if g_api_procedures[i].decl.name == g_api_procedures[i + j].decl.name {
                g_api_procedures[i].overload_index = 1;
                g_api_procedures[i + j].overload_index = j + 1;
            } else {
                break;
            }

            j += 1;
        }

        i += j;
    }

    builder : StringBuilder;

    Appendln(*builder, "%Module :: struct {", name);
    Appendln(*builder, "    #as base : Module;");
    for * g_api_procedures {
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

    Appendln(*builder, "#if #exists(Import_Mode) {");
    Appendln(*builder, "g_%1 : *%1Module;", name);

    Append(*builder, "\n");

    for g_api_procedures {
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

        Appendln(*builder, "}");
        Append(*builder, "\n");
    }

    Appendln(*builder, "}");

    result := StringBuilderBuild(*builder);
    write_entire_file(TPrint("Source/%/module_api.jai", name), result);

    Appendln(*builder, "InitializeAPI :: (module : *%Module) #c_call {", name);
    for g_api_procedures {
        Appendln(*builder, "    module.% = %;", it.name, it.decl.name);
    }
    Appendln(*builder, "}");

    result = StringBuilderBuild(*builder);

    add_build_file(TPrint("%/module_api.jai", name), workspace);
    add_build_string(result, workspace);
}
