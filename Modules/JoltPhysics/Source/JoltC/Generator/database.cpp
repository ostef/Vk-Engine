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

Define *Database::GetDefine(const String &name) const {
    for (int64_t i = 0; i < all_defines.count; i += 1) {
        if (all_defines[i]->name == name) {
            return all_defines[i];
        }
    }

    return nullptr;
}

Type *Database::GetType(CXType type) {
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

    if (result) {
        all_types.Push(result);
    }

    return result;
}

String GetParentName(const String &str) {
    for (int64_t i = str.count - 1; i >= 0; i -= 1) {
        if (str[i] == '_') {
            return String(str.data, i);
        }
    }

    return "";
}

static
String GetBaseName(const String &str, const String &parent_name) {
    if (str.StartsWith(parent_name)) {
        String result = str.TrimLeft(parent_name.count);
        if (result.StartsWith("_")) {
            result = result.TrimLeft(1);
        }

        return result.count > 0 ? result : str;
    }

    return str;
}

String StripPrefix(const String &str, const Array<String> &prefixes) {
    for (int64_t i = 0; i < prefixes.count; i += 1) {
        auto prefix = prefixes[i];

        if (str.StartsWith(prefix)) {
            auto result = str.TrimLeft(prefix.count);

            if (result.StartsWith("_")) {
                result = result.TrimLeft(1);
            }

            return result.count > 0 ? result : str;
        }
    }

    return str;
}

void Database::PostProcess(const PostProcessOptions &options) {
    for (int64_t i = 0; i < all_types.count; i += 1) {
        auto type = all_types[i];
        if (type->kind != Type_Named) {
            continue;
        }

        auto named = reinterpret_cast<TypeNamed *>(type);

        auto s = GetStruct(named->name);
        if (s) {
            named->resolved_struct = s;
            continue;
        }

        auto e = GetEnum(named->name);
        if (e) {
            named->resolved_enum = e;
            continue;
        }

        auto t = GetTypedef(named->name);
        if (t) {
            named->resolved_typedef = t;
            continue;
        }
    }

    for (int64_t i = 0; i < all_structs.count; i += 1) {
        auto s = all_structs[i];

        auto parent_name = GetParentName(s->name);
        if (parent_name.count > 0) {
            auto parent_struct = GetStruct(parent_name);
            if (parent_struct) {
                s->basename = GetBaseName(s->name, parent_name);
                s->parent_struct = parent_struct;
                parent_struct->sub_structs.Push(s);
            }
        }

        s->basename = StripPrefix(s->basename, options.strip_prefixes);

        auto first_field = s->fields.count > 0 ? s->fields[0] : nullptr;
        if (first_field && first_field->name == "base" && first_field->type->kind == Type_Named) {
            auto type_named = reinterpret_cast<TypeNamed *>(first_field->type);
            s->base_struct = GetStruct(type_named->name);
        }
    }

    for (int64_t i = 0; i < all_enums.count; i += 1) {
        auto e = all_enums[i];

        String real_name = e->name;
        if (e->name.EndsWith("Flags_")) {
            e->is_flags = true;

            real_name = e->name.TrimRight(strlen("Flags_"));

            e->associated_typedef = GetTypedef(real_name);
            if (e->associated_typedef) {
                e->associated_typedef->associated_enum = e;
            }
        } else if (e->name.EndsWith("_")) {
            real_name = e->name.TrimRight(1);

            e->associated_typedef = GetTypedef(real_name);
            if (e->associated_typedef) {
                e->associated_typedef->associated_enum = e;
            }
        }

        auto parent_name = GetParentName(real_name);
        if (parent_name.count > 0) {
            auto parent_struct = GetStruct(parent_name);
            if (parent_struct) {
                e->basename = GetBaseName(real_name, parent_name);
                e->parent_struct = parent_struct;
                parent_struct->sub_enums.Push(e);
            }
        }

        e->basename = StripPrefix(e->basename, options.strip_prefixes);

        for (int64_t i = 0; i < e->values.count; i += 1) {
            auto &value = e->values[i];

            value.basename = GetBaseName(value.name, real_name);
        }
    }

    for (int64_t i = 0; i < all_typedefs.count; i += 1) {
        auto t = all_typedefs[i];

        auto parent_name = GetParentName(t->name);
        if (parent_name.count > 0) {
            auto parent_struct = GetStruct(parent_name);
            if (parent_struct) {
                t->basename = GetBaseName(t->name, parent_name);
                t->parent_struct = parent_struct;
                parent_struct->sub_typedefs.Push(t);
            }
        }

        t->basename = StripPrefix(t->basename, options.strip_prefixes);
        t->associated_struct = GetStruct(t->name);
    }

    for (int64_t i = 0; i < all_functions.count; i += 1) {
        auto func = all_functions[i];

        auto parent_name = GetParentName(func->name);
        if (parent_name.count > 0) {
            auto parent_struct = GetStruct(parent_name);
            if (parent_struct) {
                func->basename = GetBaseName(func->name, parent_name);
                func->parent_struct = parent_struct;
            }
        }

        func->basename = StripPrefix(func->basename, options.strip_prefixes);

        if (func->parent_struct) {
            bool is_method = false;
            bool is_const = false;

            auto first_param = func->parameters.count > 0 ? func->parameters[0] : nullptr;
            if (first_param && first_param->type->kind == Type_Pointer) {
                auto pointer = reinterpret_cast<TypePointer *>(first_param->type);
                if (pointer->pointer_to->kind == Type_Named) {
                    auto named = reinterpret_cast<TypeNamed *>(pointer->pointer_to);
                    auto s = GetStruct(named->name);

                    if (s == func->parent_struct) {
                        is_method = true;
                        is_const = (pointer->flags & TypeFlag_Const) != 0;
                    }
                }
            }

            if (is_method) {
                func->flags |= FunctionFlag_Method;
                if (is_const) {
                    func->flags |= FunctionFlag_Const;
                }

                func->parent_struct->methods.Push(func);
            } else {
                func->parent_struct->functions.Push(func);
            }
        }
    }

    for (int64_t i = 0; i < all_defines.count; i += 1) {
        auto def = all_defines[i];

        auto parent_name = GetParentName(def->name);
        if (parent_name.count > 0) {
            auto parent_struct = GetStruct(parent_name);
            if (parent_struct) {
                def->basename = GetBaseName(def->name, parent_name);
                def->parent_struct = parent_struct;
                parent_struct->sub_defines.Push(def);
            }
        }

        def->basename = StripPrefix(def->basename, options.strip_prefixes);

        for (int64_t i = 0; i < def->tokens.count; i += 1) {
            auto &tok = def->tokens[i];
            if (tok.kind == Token_Identifier) {
                tok.resolved_define = GetDefine(tok.text);
            }
        }
    }
}

Struct::Struct(CXCursor cursor)
    : name(GetDeclName(cursor)),
      basename(name),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)) {}

EnumValue::EnumValue(CXCursor cursor)
    : name(GetDeclName(cursor)),
      basename(name),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)),
      signed_value(clang_getEnumConstantDeclValue(cursor)),
      unsigned_value(clang_getEnumConstantDeclUnsignedValue(cursor)) {}

Enum::Enum(CXCursor cursor)
    : name(GetDeclName(cursor)),
      basename(name),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)) {}

Typedef::Typedef(CXCursor cursor)
    : name(GetDeclName(cursor)),
      basename(name),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)) {}

Variable::Variable(CXCursor cursor)
    : name(GetDeclName(cursor)),
      basename(name),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)) {}

Function::Function(CXCursor cursor)
    : name(GetDeclName(cursor)),
      basename(name),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)) {}

Define::Define(CXCursor cursor)
    : name(GetDeclName(cursor)),
      basename(name),
      source_code_range(GetSourceCodeRange(cursor)),
      cursor(clang_getCanonicalCursor(cursor)) {}

String GetDeclName(CXCursor cursor) {
    if (clang_Cursor_isAnonymous(cursor)) {
        return "";
    }

    CXString spelling = clang_getCursorSpelling(cursor);
    const char *str = clang_getCString(spelling);

    return String(strdup(str));
}

SourceCodeRange GetSourceCodeRange(CXSourceRange range) {
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

SourceCodeRange GetSourceCodeRange(CXCursor cursor) {
    CXSourceRange range = clang_getCursorExtent(cursor);

    return GetSourceCodeRange(range);
}
