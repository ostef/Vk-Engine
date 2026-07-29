#include <Core.hpp>
#include <Database.hpp>

Struct *Database::GetStruct(const String &name) const {
    for (int64_t i = 0; i < all_structs.count; i += 1) {
        if (all_structs[i]->name == name) {
            return all_structs[i];
        }
    }

    return nullptr;
}

Enum *Database::GetEnum(const String &name) const {
    for (int64_t i = 0; i < all_enums.count; i += 1) {
        if (all_enums[i]->name == name) {
            return all_enums[i];
        }
    }

    return nullptr;
}

Typedef *Database::GetTypedef(const String &name) const {
    for (int64_t i = 0; i < all_typedefs.count; i += 1) {
        if (all_typedefs[i]->name == name) {
            return all_typedefs[i];
        }
    }

    return nullptr;
}

Function *Database::GetFunction(const String &name) const {
    for (int64_t i = 0; i < all_functions.count; i += 1) {
        if (all_functions[i]->name == name) {
            return all_functions[i];
        }
    }

    return nullptr;
}

Type *Database::GetType(CXType type) const {
    CXType original_type = type;

    int64_t size = clang_Type_getSizeOf(type);
    int64_t alignment = clang_Type_getAlignOf(type);

    Type *result = nullptr;
    TypeFlags flags = 0;

    if (clang_isConstQualifiedType(type)) {
        flags |= TypeFlag_Const;
    }
    if (clang_isVolatileQualifiedType(type)) {
        flags |= TypeFlag_Volatile;
    }

    switch (type.kind) {
        default: {
            result = new Type(Type_Unknown, flags);
        } break;
        case CXType_Unexposed: {
            result = new Type(Type_Unknown, flags);
        } break;
        case CXType_Invalid: {
            result = new Type(Type_Invalid, flags);
        } break;
        case CXType_Void: {
            result = new Type(Type_Void, flags);
        } break;
        case CXType_Bool: {
            result = new Type(Type_Bool, flags);
        } break;
        case CXType_Char_U:
        case CXType_UChar:
        case CXType_UShort:
        case CXType_UInt:
        case CXType_ULong:
        case CXType_ULongLong:
        case CXType_UInt128: {
            switch (size) {
                case 1: {
                    result = new Type(Type_UInt8, flags);
                } break;
                case 2: {
                    result = new Type(Type_UInt16, flags);
                } break;
                case 4: {
                    result = new Type(Type_UInt32, flags);
                } break;
                case 8: {
                    result = new Type(Type_UInt64, flags);
                } break;
                case 16: {
                    result = new Type(Type_UInt128, flags);
                } break;
                default: {
                    result = new Type(Type_Invalid, flags);
                } break;
            }
        } break;
        case CXType_Char_S:
        case CXType_SChar:
        case CXType_Short:
        case CXType_Int:
        case CXType_Long:
        case CXType_LongLong:
        case CXType_Int128: {
            switch (size) {
                case 1: {
                    result = new Type(Type_Int8, flags);
                } break;
                case 2: {
                    result = new Type(Type_Int16, flags);
                } break;
                case 4: {
                    result = new Type(Type_Int32, flags);
                } break;
                case 8: {
                    result = new Type(Type_Int64, flags);
                } break;
                case 16: {
                    result = new Type(Type_Int128, flags);
                } break;
                default: {
                    result = new Type(Type_Invalid, flags);
                } break;
            }
        } break;
        case CXType_Float: {
            result = new Type(Type_Float, flags);
        } break;
        case CXType_Double: {
            result = new Type(Type_Double, flags);
        } break;
        case CXType_Pointer: {
            result = new TypePointer(flags, GetType(clang_getPointeeType(type)));
        } break;

        case CXType_FunctionNoProto:
        case CXType_FunctionProto: {
            Array<Type *> parameter_types;

            int num_parameters = clang_getNumArgTypes(type);
            parameter_types.Reserve(num_parameters);

            for (int i = 0; i < num_parameters; i += 1) {
                Type *param_type = GetType(clang_getArgType(type, i));
                parameter_types.Push(param_type);
            }

            result = new TypeFunction(flags, parameter_types, GetType(clang_getResultType(type)), clang_isFunctionTypeVariadic(type));
        } break;

        case CXType_IncompleteArray:
        case CXType_VariableArray:
        case CXType_DependentSizedArray:
        case CXType_ConstantArray: {
            result = new TypeArray(flags, GetType(clang_getElementType(type)), clang_getNumElements(type));
        } break;

        case CXType_Typedef: {
            String name = clang_getCString(clang_getTypedefName(type));
            result = new TypeNamed(flags, name);
        } break;

        case CXType_Elaborated:
            type = clang_Type_getNamedType(type);
            // fallthrough

        case CXType_Record:
        case CXType_Enum: {
            CXCursor cursor = clang_getCanonicalCursor(clang_getTypeDeclaration(type));
            result = new TypeNamed(flags, GetDeclName(cursor));
        } break;
    }

    return result;
}

Struct::Struct(CXCursor cursor)
    : name(GetDeclName(cursor)),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)) {}

EnumValue::EnumValue(CXCursor cursor)
    : name(GetDeclName(cursor)),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)),
      signed_value(clang_getEnumConstantDeclValue(cursor)),
      unsigned_value(clang_getEnumConstantDeclUnsignedValue(cursor)) {}

Enum::Enum(CXCursor cursor)
    : name(GetDeclName(cursor)),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)) {}

Typedef::Typedef(CXCursor cursor)
    : name(GetDeclName(cursor)),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)) {}

Variable::Variable(CXCursor cursor)
    : name(GetDeclName(cursor)),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)) {}

Function::Function(CXCursor cursor)
    : name(GetDeclName(cursor)),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)) {}

String GetDeclName(CXCursor cursor) {
    if (clang_Cursor_isAnonymous(cursor)) {
        return "";
    }

    CXString spelling = clang_getCursorSpelling(cursor);

    return String((char *)clang_getCString(spelling));
}

SourceCodeRange GetSourceCodeRange(CXCursor cursor) {
    CXSourceRange range = clang_getCursorExtent(cursor);
    CXSourceLocation range_start = clang_getRangeStart(range);
    CXSourceLocation range_end = clang_getRangeEnd(range);

    CXFile file;
    unsigned int start_line, start_character, start_offset;
    clang_getSpellingLocation(range_start, &file, &start_line, &start_character, &start_offset);

    unsigned int end_line, end_character, end_offset;
    clang_getSpellingLocation(range_end, NULL, &end_line, &end_character, &end_offset);

    const char *filename = clang_getCString(clang_getFileName(file));

    return (SourceCodeRange){
        .filename=filename,
        .start_line=start_line, .start_character=start_character, .start_offset=start_offset,
        .end_line=end_line, .end_character=end_character, .end_offset=end_offset,
    };
}
