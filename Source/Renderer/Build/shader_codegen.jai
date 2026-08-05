#import "Linalg";

g_shader_types : [..]*Type_Info;

RemoveShaderSuffix :: (str : string) -> string {
    return ifx StringEndsWith(str, "ShaderData")
        then .{count=str.count - "ShaderData".count, data=str.data}
        else str;
}

AddShaderType :: (decl : *Code_Declaration) {
    if !decl.expression {
        return;
    }

    if decl.expression.kind == .STRUCT {
        ArrayPush(*g_shader_types, cast(*Code_Struct, decl.expression).defined_type);
    } else if decl.expression.kind == .ENUM {
        ArrayPush(*g_shader_types, cast(*Code_Enum, decl.expression).external_type);
    }
}

GenerateShaderCode :: () {
    CompareTypeNames :: (a : *Type_Info, b : *Type_Info) -> int {
        a_name := ifx a.type == .STRUCT
            then cast(*Type_Info_Struct, a).name
            else cast(*Type_Info_Enum, a).name;
        b_name := ifx b.type == .STRUCT
            then cast(*Type_Info_Struct, b).name
            else cast(*Type_Info_Enum, b).name;

        return StringCompare(a_name, b_name);
    }

    QuickSort(g_shader_types, CompareTypeNames);

    GenerateGLSLShaderCode();

    ArrayClear(*g_shader_types);
}

#scope_file

StructAndMember :: struct {
    struct_info : *Type_Info_Struct;
    member : *Type_Info_Struct_Member;
}

#scope_export

GenerateGLSLShaderCode :: () {
    // Make sure types are generated in order to respect C declaration rules
    PushType :: (types : *[..]*Type_Info, type : *Type_Info) {
        if type.type == .STRUCT {
            info_struct := cast(*Type_Info_Struct, type);
            for info_struct.members {
                if it.type.type == {
                case .STRUCT; #through;
                case .ENUM;
                    PushType(types, it.type);

                case .ARRAY;
                    elem_type := cast(*Type_Info_Array, it.type).element_type;
                    PushType(types, elem_type);
                }
            }
        }

        for g_shader_types {
            if type == it {
                ArrayPushUnique(types, type);
                break;
            }
        }
    }

    shader_types_in_order : [..]*Type_Info;
    shader_constants : [..]StructAndMember;

    for g_shader_types {
        if it.type != .STRUCT {
            continue;
        }

        for * member : cast(*Type_Info_Struct, it).members {
            if !(member.flags & .CONSTANT) || member.offset_into_constant_storage < 0 {
                continue;
            }

            if member.name == "_" || !member.name {
                continue;
            }

            ArrayPush(*shader_constants, .{struct_info=xx it, member=member});
        }
    }

    QuickSort(shader_constants, (a, b) => StringCompare(a.member.name, b.member.name));

    for g_shader_types {
        PushType(*shader_types_in_order, it);
    }

    defer LogMessage("Generated GLSL type definitions");

    builder : StringBuilder;

    if StringBuilderLength(*builder) == 0 {
        Appendln(*builder, "// This file was auto generated\n");
    }

    Appendln(*builder, "#ifndef SHADER_TYPES_GENERATED_GLSL");
    Appendln(*builder, "#define SHADER_TYPES_GENERATED_GLSL\n");

    for shader_constants {
        GenerateGLSLConstant(*builder, it);
    }

    if shader_constants.count > 0 {
        Append(*builder, "\n");
    }

    for shader_types_in_order {
        if it.type == .ENUM {
            GenerateGLSLEnumDefinition(*builder, xx it);
            Append(*builder, "\n");
        } else if it.type == .STRUCT {
            if GenerateGLSLStructDefinition(*builder, xx it) {
                Append(*builder, ";\n\n");
            }
        }
    }

    Appendln(*builder, "#endif");

    write_entire_file("Shaders/shader_types.generated.glsl", *builder);
}

GenerateGLSLEnumDefinition :: (builder : *StringBuilder, info : *Type_Info_Enum, indent := 0) {
    name := RemoveShaderSuffix(info.name);
    if info.name {
        Appendln(builder, "#define % int", name);
    }

    for i : 0..info.values.count - 1 {
        Appendln(builder, "#define %_% %", name, info.names[i], info.values[i]);
    }
}

AppendGLSLTypePrefix :: (builder : *StringBuilder, info : *Type_Info, indent := 0) {
    if info.type == {
    case .INTEGER;
        int_info := cast(*Type_Info_Integer, info);
        if int_info.signed {
            Append(builder, "int ");
        } else {
            Append(builder, "uint ");
        }
    case .BOOL;
        Append(builder, "bool ");
    case .FLOAT;
        if info.runtime_size == 4 {
            Append(builder, "float ");
        } else {
            Append(builder, "double ");
        }
    case .STRUCT;
        struct_info := cast(*Type_Info_Struct, info);
        if !struct_info.name {
            GenerateGLSLStructDefinition(builder, struct_info, indent);
            Append(builder, " ");
            return;
        }

        is_matrix_type, matrix_T, matrix_M, matrix_N := GetMatrixTypeInfoByName(info);
        is_vector_type, vector_T, vector_N := GetVectorTypeInfoByName(info);
        if is_vector_type {
            if vector_T.type == .INTEGER {
                if cast(*Type_Info_Integer, vector_T).signed {
                    Append(builder, "int% ", vector_N);
                } else {
                    Append(builder, "uint% ", vector_N);
                }
            } else if vector_T.type == .FLOAT {
                if vector_T.runtime_size == 4 {
                    Append(builder, "float% ", vector_N);
                } else {
                    Append(builder, "double% ", vector_N);
                }
            } else {
                Append(builder, "% ", RemoveShaderSuffix(struct_info.name));
            }
        } else if is_matrix_type {
            if matrix_T.type == .FLOAT {
                if matrix_T.runtime_size == 4 {
                    Append(builder, "float");
                } else {
                    Append(builder, "double");
                }

                Append(builder, "%x% ", matrix_M, matrix_N);
            } else {
                Append(builder, "% ", RemoveShaderSuffix(struct_info.name));
            }
        } else {
            Append(builder, "% ", RemoveShaderSuffix(struct_info.name));
        }

    case .ENUM;
        enum_info := cast(*Type_Info_Enum, info);
        if enum_info.name {
            Append(builder, "% ", RemoveShaderSuffix(enum_info.name));
        } else {
            Append(builder, "int ");
        }

    case .ARRAY;
        array_info := cast(*Type_Info_Array, info);
        AppendGLSLTypePrefix(builder, array_info.element_type, indent);
    }
}

AppendGLSLTypePostfix :: (builder : *StringBuilder, info : *Type_Info, indent := 0) {
    if info.type == {
    case .ARRAY;
        array_info := cast(*Type_Info_Array, info);
        if array_info.array_type == .FIXED {
            Append(builder, "[%]", array_info.array_count);
        } else {
            Append(builder, "[]");
        }

        AppendGLSLTypePostfix(builder, array_info.element_type, indent);
    }
}

GenerateGLSLConstant :: (builder : *StringBuilder, using struct_and_member : StructAndMember) {
    ptr := struct_info.constant_storage.data + member.offset_into_constant_storage;

    if member.type.type == {
    case .BOOL;
        Appendln(builder, "#define % %", member.name, cast(*u8, ptr).*);
    case .FLOAT;
        if member.type.runtime_size == {
        case 4; Appendln(builder, "#define % %", member.name, cast(*float32, ptr).*);
        case 8; Appendln(builder, "#define % %", member.name, cast(*float64, ptr).*);
        }
    case .INTEGER;
        info_int := cast(*Type_Info_Integer, member.type);
        if info_int.signed {
            if info_int.runtime_size == {
            case 1; Appendln(builder, "#define % %", member.name, cast(*s8, ptr).*);
            case 2; Appendln(builder, "#define % %", member.name, cast(*s16, ptr).*);
            case 4; Appendln(builder, "#define % %", member.name, cast(*s32, ptr).*);
            case 8; Appendln(builder, "#define % %", member.name, cast(*s64, ptr).*);
            }
        } else {
            if info_int.runtime_size == {
            case 1; Appendln(builder, "#define % %", member.name, cast(*u8, ptr).*);
            case 2; Appendln(builder, "#define % %", member.name, cast(*u16, ptr).*);
            case 4; Appendln(builder, "#define % %", member.name, cast(*u32, ptr).*);
            case 8; Appendln(builder, "#define % %", member.name, cast(*u64, ptr).*);
            }
        }
    }
}

GenerateGLSLStructDefinition :: (builder : *StringBuilder, info : *Type_Info_Struct, indent := 0) -> bool {
    found_non_constant_members := false;
    for info.members {
        if !(it.flags & .CONSTANT) {
            found_non_constant_members = true;
            break;
        }
    }

    if !found_non_constant_members {
        return false;
    }

    if info.name && info.name != "_" {
        Appendln(builder, "struct % {", RemoveShaderSuffix(info.name));
    } else {
        Appendln(builder, "struct {");
    }

    highest_offset := -1;
    for info.members {
        if it.flags & .CONSTANT || it.offset_in_bytes <= highest_offset {
            continue;
        }

        highest_offset = it.offset_in_bytes;

        for i : 1..indent + 1 {
            Append(builder, "    ");
        }

        AppendGLSLTypePrefix(builder, it.type, indent + 1);
        Append(builder, it.name);
        AppendGLSLTypePostfix(builder, it.type, indent + 1);
        Appendln(builder, ";");
    }

    for i : 1..indent {
        Append(builder, "    ");
    }

    Append(builder, "}");

    return true;
}

