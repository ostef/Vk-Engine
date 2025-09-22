#import "Compiler";

GLSLPacking :: enum {
    Std140;
    Std430;
}

GLSLStd140Size :: ($T : Type) -> u64 {
    return xx GLSLTypeSize(T, .Std140);
}

GLSLStd430Size :: ($T : Type) -> u64 {
    return xx GLSLTypeSize(T, .Std430);
}

GLSLTypeSize :: ($T : Type, $Packing : GLSLPacking) -> size : s64, alignment : s64, array_stride : s64, matrix_stride : s64 {
    size, alignment, array_stride, matrix_stride := #run GLSLTypeSize(type_info(T), Packing);

    return size, alignment, array_stride, matrix_stride;
}

GLSLTypeSize :: (type : *Type_Info, packing : GLSLPacking) -> size : s64, alignment : s64, array_stride : s64, matrix_stride : s64 {
    Assert(type.runtime_size != -1, "Type % is not sized when calling GLSLTypeSize", cast(*Type, *type).*);

    is_vector, vector_T, vector_N := GetVectorTypeInfo(type);
    if is_vector {
        if vector_N == 2 || vector_N == 4 {
            return xx (vector_N * vector_T.runtime_size), xx (vector_N * vector_T.runtime_size), 0, 0;
        } else if vector_N == 3 {
            return xx (vector_N * vector_T.runtime_size), xx (4 * vector_T.runtime_size), 0, 0;
        }
    }

    is_matrix, matrix_T, matrix_R, matrix_C := GetMatrixTypeInfo(type);
    if is_matrix {
        vector_alignment, vector_size : s64;

        if matrix_R == 2 || matrix_R == 4 {
            vector_alignment = matrix_R * matrix_T.runtime_size;
            vector_size = matrix_R * matrix_T.runtime_size;
        } else if matrix_R == 3 {
            vector_alignment = 4 * matrix_T.runtime_size;
            vector_size = matrix_R * matrix_T.runtime_size;
        }

        alignment := ifx packing == .Std140 then AlignForward(vector_alignment, 16) else vector_alignment;
        matrix_stride := AlignForward(vector_size, alignment);
        size := matrix_C * matrix_stride;

        return xx size, xx alignment, 0, xx matrix_stride;
    }

    if type.type == {
    case .ENUM; #through;
    case .INTEGER;
        return 4, 4, 0, 0;
    case .FLOAT;
        return xx type.runtime_size, xx type.runtime_size, 0, 0;
    case .BOOL;
        return 4, 4, 0, 0;

    case .STRUCT;
        struct_type := cast(*Type_Info_Struct, type);

        alignment : s64 = 0;
        size : s64 = 0;
        highest_offset := 0;
        for struct_type.members {
            if it.flags & .CONSTANT || it.offset_in_bytes < highest_offset {
                continue;
            }

            highest_offset = it.offset_in_bytes + it.type.runtime_size;

            member_size, member_alignment := GLSLTypeSize(it.type, packing);
            alignment = Max(alignment, member_alignment);
            size = AlignForward(size, member_alignment);
            size += member_size;
        }

        if packing == .Std140 {
            alignment = AlignForward(alignment, 16);
        }

        size = AlignForward(size, alignment);

        return xx size, xx alignment, 0, 0;

    case .ARRAY;
        array_type := cast(*Type_Info_Array, type);

        element_size, element_alignment := GLSLTypeSize(array_type.element_type, packing);
        alignment := ifx packing == .Std140 then AlignForward(element_alignment, 16) else element_alignment;
        array_stride := AlignForward(element_size, alignment);
        size : s64 = ifx array_type.array_type == .FIXED
            then xx array_type.array_count * array_stride
            else array_stride;

        return xx size, xx alignment, xx array_stride, 0;

    case;
        Panic("Unhandled type %", get_type(type));
    }

    return 0, 0, 0, 0;
}

PackToGLSLStd :: (value : $T, buffer : *void, $Packing : GLSLPacking) -> size : u32
#modify { return cast(*Type_Info, T).type == .STRUCT || cast(*Type_Info, T).type == .ARRAY; } {
    ptr := cast(*void, *value);

    #insert -> string {
        builder : StringBuilder;

        Append(*builder, "// PackToGLSLStd(%, %)\n", T, Packing);
        buffer_offset := AppendPackToGLSLStd(*builder, type_info(T), Packing, 0, 0);
        Append(*builder, "return %;\n", buffer_offset);

        return StringBuilderBuild(*builder);
    }
}

UnpackFromGLSLStd :: (result : *$T, buffer : *void, size : u32, $Packing : GLSLPacking) -> size : u32
#modify { return cast(*Type_Info, T).type == .STRUCT || cast(*Type_Info, T).type == .ARRAY; } {
    ptr := cast(*void, result);

    #insert -> string {
        builder : StringBuilder;

        Append(*builder, "// UnpackFromGLSLStd(%, %)\n", T, Packing);
        buffer_offset := AppendUnpackFromGLSLStd(*builder, type_info(T), Packing, 0, 0);
        Append(*builder, "return %;\n", buffer_offset);

        return StringBuilderBuild(*builder);
    }
}

#scope_file

AppendPackToGLSLStd :: (builder : *StringBuilder, type : *Type_Info, packing : GLSLPacking, buffer_offset : s64, ptr_offset : s64) -> buffer_offset: s64, ptr_offset: s64 {
    is_vector, vector_T, vector_N := GetVectorTypeInfo(type);
    if is_vector {
        size, alignment, array_stride := GLSLTypeSize(type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);

        Append(builder, "memcpy(buffer + %, ptr + %, %);\n", buffer_offset, ptr_offset, type.runtime_size);

        ptr_offset += type.runtime_size;
        buffer_offset += size;

        return buffer_offset, ptr_offset;
    }

    is_matrix, matrix_T, matrix_M, matrix_N := GetMatrixTypeInfo(type);
    if is_matrix {
        size, alignment, array_stride, matrix_stride := GLSLTypeSize(type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);

        for i : 0..matrix_M - 1 {
            for j : 0..matrix_N - 1 {
                Append(builder, "cast(*float, buffer + %)[%] = cast(*float, ptr + %)[%];\n", buffer_offset, j, ptr_offset, j * matrix_M + i);
            }

            buffer_offset += matrix_stride;
        }

        ptr_offset += type.runtime_size;

        return buffer_offset, ptr_offset;
    }

    if type.type == {
    case .FLOAT;
        size, alignment := GLSLTypeSize(type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);

        if type.runtime_size == 4 {
            Append(builder, "cast(*float, buffer + %).* = cast(*float, ptr + %).*;\n", buffer_offset, ptr_offset);
        } else {
            Append(builder, "cast(*float64, buffer + %).* = cast(*float64, ptr + %).*;\n", buffer_offset, ptr_offset);
        }

        ptr_offset += type.runtime_size;
        buffer_offset += size;

    case .BOOL;
        size, alignment := GLSLTypeSize(type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);

        Append(builder, "cast(*u32, buffer + %).* = xx cast,no_check(*bool, ptr + %).*;\n", buffer_offset, ptr_offset);

        ptr_offset += type.runtime_size;
        buffer_offset += size;

    case .ENUM; #through;
    case .INTEGER;
        size, alignment := GLSLTypeSize(type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);

        int_type : *Type_Info_Integer;
        if type.type == .ENUM {
            int_type = cast(*Type_Info_Enum, type).internal_type;
        } else {
            int_type = cast(*Type_Info_Integer, type);
        }

        if int_type.signed {
            if int_type.runtime_size == {
            case 1; Append(builder, "cast(*s32, buffer + %).* = xx,no_check (cast,no_check(*s8, ptr + %)).*;\n", buffer_offset, ptr_offset);
            case 2; Append(builder, "cast(*s32, buffer + %).* = xx,no_check (cast,no_check(*s16, ptr + %)).*;\n", buffer_offset, ptr_offset);
            case 4; Append(builder, "cast(*s32, buffer + %).* = xx,no_check (cast,no_check(*s32, ptr + %)).*;\n", buffer_offset, ptr_offset);
            case 8; Append(builder, "cast(*s32, buffer + %).* = xx,no_check (cast,no_check(*s64, ptr + %)).*;\n", buffer_offset, ptr_offset);
            }
        } else {
            if int_type.runtime_size == {
            case 1; Append(builder, "cast(*u32, buffer + %).* = xx,no_check (cast,no_check(*u8, ptr + %)).*;\n", buffer_offset, ptr_offset);
            case 2; Append(builder, "cast(*u32, buffer + %).* = xx,no_check (cast,no_check(*u16, ptr + %)).*;\n", buffer_offset, ptr_offset);
            case 4; Append(builder, "cast(*u32, buffer + %).* = xx,no_check (cast,no_check(*u32, ptr + %)).*;\n", buffer_offset, ptr_offset);
            case 8; Append(builder, "cast(*u32, buffer + %).* = xx,no_check (cast,no_check(*u64, ptr + %)).*;\n", buffer_offset, ptr_offset);
            }
        }

        ptr_offset += type.runtime_size;
        buffer_offset += size;

    case .STRUCT;
        struct_type := cast(*Type_Info_Struct, type);

        size, alignment := GLSLTypeSize(type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);
        original_buffer_offset := buffer_offset;

        highest_offset := 0;
        for struct_type.members {
            if it.flags & .CONSTANT || it.offset_in_bytes < highest_offset {
                continue;
            }

            highest_offset = it.offset_in_bytes + it.type.runtime_size;

            size, alignment := GLSLTypeSize(it.type, packing);
            buffer_offset = AlignForward(buffer_offset, alignment);
            Append(builder, "// AppendPackToGLSLStd(%: %, %)\n", it.name, (cast(*Type) *it.type).*, packing);
            buffer_offset = AppendPackToGLSLStd(builder, it.type, packing, buffer_offset, ptr_offset + it.offset_in_bytes);
        }

        buffer_offset = original_buffer_offset + size;
        ptr_offset = highest_offset;

    case .ARRAY;
        array_type := cast(*Type_Info_Array, type);

        _, alignment, array_stride := GLSLTypeSize(array_type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);

        if array_type.array_type == .FIXED {
            for i : 0..array_type.array_count - 1 {
                AppendPackToGLSLStd(builder, array_type.element_type, packing, buffer_offset, ptr_offset);
                ptr_offset += array_type.element_type.runtime_size;
                buffer_offset += array_stride;
            }
        } else {
            Append(builder, "for i : 0..cast(*Array_View_64, ptr + %).count - 1 {\n", ptr_offset);
            Append(builder, "    array_data := cast(*%, cast(*Array_View_64, ptr + %).data);\n", (cast(*Type) *array_type.element_type).*, ptr_offset);
            Append(builder, "    PackToGLSLStd(array_data[i], buffer + i * %, .%);\n", array_stride, packing);
            Append(builder, "}\n");

            ptr_offset += array_type.runtime_size;
        }

    case;
        Panic("Unhandled type %", cast(*Type, *type).*);
    }

    return buffer_offset, ptr_offset;
}

AppendUnpackFromGLSLStd :: (builder : *StringBuilder, type : *Type_Info, packing : GLSLPacking, buffer_offset : s64, ptr_offset : s64) -> buffer_offset: s64, ptr_offset: s64 {
    is_vector, vector_T, vector_N := GetVectorTypeInfo(type);
    if is_vector {
        size, alignment, array_stride := GLSLTypeSize(type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);

        Append(builder, "memcpy(ptr + %, buffer + %, %);\n", ptr_offset, buffer_offset, type.runtime_size);

        ptr_offset += type.runtime_size;
        buffer_offset += size;

        return buffer_offset, ptr_offset;
    }

    is_matrix, matrix_T, matrix_M, matrix_N := GetMatrixTypeInfo(type);
    if is_matrix {
        size, alignment, array_stride, matrix_stride := GLSLTypeSize(type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);

        for i : 0..matrix_M - 1 {
            for j : 0..matrix_N - 1 {
                Append(builder, "cast(*float, ptr + %)[%] = cast(*float, buffer + %)[%];\n", ptr_offset, j * matrix_M + i, buffer_offset, j);
            }

            buffer_offset += matrix_stride;
        }

        ptr_offset += type.runtime_size;

        return buffer_offset, ptr_offset;
    }

    if type.type == {
    case .FLOAT;
        size, alignment := GLSLTypeSize(type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);

        if type.runtime_size == 4 {
            Append(builder, "cast(*float, ptr + %).* = cast(*float, buffer + %).*;\n", ptr_offset, buffer_offset);
        } else {
            Append(builder, "cast(*float64, ptr + %).* = cast(*float64, buffer + %).*;\n", ptr_offset, buffer_offset);
        }

        ptr_offset += type.runtime_size;
        buffer_offset += size;

    case .BOOL;
        size, alignment := GLSLTypeSize(type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);

        Append(builder, "cast,no_check(*bool, ptr + %).* = xx cast(*u32, buffer + %).*;\n", ptr_offset, buffer_offset);

        ptr_offset += type.runtime_size;
        buffer_offset += size;

    case .ENUM; #through;
    case .INTEGER;
        size, alignment := GLSLTypeSize(type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);

        int_type : *Type_Info_Integer;
        if type.type == .ENUM {
            int_type = cast(*Type_Info_Enum, type).internal_type;
        } else {
            int_type = cast(*Type_Info_Integer, type);
        }

        if int_type.signed {
            if int_type.runtime_size == {
            case 1; Append(builder, "cast,no_check(*s8, ptr + %).* = xx,no_check(cast(*s32, buffer + %)).*;\n", ptr_offset, buffer_offset);
            case 2; Append(builder, "cast,no_check(*s16, ptr + %).* = xx,no_check(cast(*s32, buffer + %)).*;\n", ptr_offset, buffer_offset);
            case 4; Append(builder, "cast,no_check(*s32, ptr + %).* = xx,no_check(cast(*s32, buffer + %)).*;\n", ptr_offset, buffer_offset);
            case 8; Append(builder, "cast,no_check(*s64, ptr + %).* = xx,no_check(cast(*s32, buffer + %)).*;\n", ptr_offset, buffer_offset);
            }
        } else {
            if int_type.runtime_size == {
            case 1; Append(builder, "cast,no_check(*u8, ptr + %).* = xx,no_check(cast(*u32, buffer + %).*);\n", ptr_offset, buffer_offset);
            case 2; Append(builder, "cast,no_check(*u16, ptr + %).* = xx,no_check(cast(*u32, buffer + %).*);\n", ptr_offset, buffer_offset);
            case 4; Append(builder, "cast,no_check(*u32, ptr + %).* = xx,no_check(cast(*u32, buffer + %).*);\n", ptr_offset, buffer_offset);
            case 8; Append(builder, "cast,no_check(*u64, ptr + %).* = xx,no_check(cast(*u32, buffer + %).*);\n", ptr_offset, buffer_offset);
            }
        }

        ptr_offset += type.runtime_size;
        buffer_offset += size;

    case .STRUCT;
        struct_type := cast(*Type_Info_Struct, type);

        size, alignment := GLSLTypeSize(type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);
        original_buffer_offset := buffer_offset;

        highest_offset := 0;
        for struct_type.members {
            if it.flags & .CONSTANT || it.offset_in_bytes < highest_offset {
                continue;
            }

            highest_offset = it.offset_in_bytes + it.type.runtime_size;

            size, alignment := GLSLTypeSize(it.type, packing);
            buffer_offset = AlignForward(buffer_offset, alignment);
            Append(builder, "// AppendUnpackFromGLSLStd(%: %, %)\n", it.name, (cast(*Type) *it.type).*, packing);
            buffer_offset = AppendUnpackFromGLSLStd(builder, it.type, packing, buffer_offset, ptr_offset + it.offset_in_bytes);
        }

        buffer_offset = original_buffer_offset + size;
        ptr_offset = highest_offset;

    case .ARRAY;
        array_type := cast(*Type_Info_Array, type);

        _, alignment, array_stride := GLSLTypeSize(array_type, packing);
        buffer_offset = AlignForward(buffer_offset, alignment);

        if array_type.array_type == .FIXED {
            for i : 0..array_type.array_count - 1 {
                AppendUnpackFromGLSLStd(builder, array_type.element_type, packing, buffer_offset, ptr_offset);
                ptr_offset += array_type.element_type.runtime_size;
                buffer_offset += array_stride;
            }
        } else {
            Append(builder, "if % / (size - %) > 0 {\n", array_stride, buffer_offset);
            Append(builder, "    for i : 0..(% / (size - %)) - 1 {\n", array_stride, buffer_offset);
            Append(builder, "        array_data := cast(*%, cast(*Array_View_64, ptr + %).data);\n", (cast(*Type) *array_type.element_type).*, ptr_offset);
            Append(builder, "        UnpackFromGLSLStd(*array_data[i], buffer + %1 + i * %2, size - (%1 + i * %2), .%3);\n", buffer_offset, array_stride, packing);
            Append(builder, "    }\n");
            Append(builder, "}\n");

            ptr_offset += array_type.runtime_size;
        }

    case;
        Panic("Unhandled type %", cast(*Type, *type).*);
    }

    return buffer_offset, ptr_offset;
}
