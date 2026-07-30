#include <Jai.hpp>

void AppendJaiType(const JaiGenerateOptions &options, StringBuilder &builder, Type *type, int indentation) {
    if (!type) {
        builder.AppendString("<null>");
        return;
    }

    static const char *Typedef_Replacements[][2] = {
        {"uint8_t",   "u8"},
        {"uint16_t",  "u16"},
        {"uint32_t",  "u32"},
        {"uint64_t",  "u64"},
        {"int8_t",    "s8"},
        {"int16_t",   "s16"},
        {"int32_t",   "s32"},
        {"int64_t",   "s64"},
        {"size_t",    "u64"},
        {"intptr_t",  "s64"},
        {"uintptr_t", "u64"},
    };

    switch (type->kind) {
        default:
        case Type_Unknown: {
            builder.Append("<unknown>");
        } break;
        case Type_Invalid: {
            builder.Append("<invalid>");
        } break;
        case Type_Void: {
            builder.Append("void");
        } break;
        case Type_Bool: {
            builder.Append("bool");
        } break;
        case Type_Char: {
            builder.Append("s8");
        } break;
        case Type_UInt8: {
            builder.Append("u8");
        } break;
        case Type_UInt16: {
            builder.Append("u16");
        } break;
        case Type_UInt32: {
            builder.Append("u32");
        } break;
        case Type_UInt64: {
            builder.Append("u64");
        } break;
        case Type_UInt128: {
            builder.Append("U128");
        } break;
        case Type_Int8: {
            builder.Append("s8");
        } break;
        case Type_Int16: {
            builder.Append("s16");
        } break;
        case Type_Int32: {
            builder.Append("s32");
        } break;
        case Type_Int64: {
            builder.Append("s64");
        } break;
        case Type_Int128: {
            builder.Append("s128");
        } break;
        case Type_Float: {
            builder.Append("float");
        } break;
        case Type_Double: {
            builder.Append("float64");
        } break;
        case Type_Pointer: {
            auto pointer = reinterpret_cast<TypePointer *>(type);

            builder.Append("*");
            AppendJaiType(options, builder, pointer->pointer_to, indentation);
        } break;
        case Type_Array: {
            auto arr = reinterpret_cast<TypeArray *>(type);
            builder.Append("[%lld]", arr->num_elements);
            AppendJaiType(options, builder, arr->element_type, indentation);
        } break;
        case Type_Enum: {
            auto e = reinterpret_cast<TypeEnum *>(type);
            AppendJaiEnum(options, builder, e->e, indentation);
        } break;
        case Type_Struct: {
            auto s = reinterpret_cast<TypeStruct *>(type);
            AppendJaiStruct(options, builder, s->s, indentation);
        } break;
        case Type_Named: {
            auto named = reinterpret_cast<TypeNamed *>(type);
            if (named->resolved_struct) {
                AppendJaiFullName(options, builder, named->resolved_struct);
            } else if (named->resolved_enum) {
                AppendJaiFullName(options, builder, named->resolved_enum);
            } else if (named->resolved_typedef) {
                AppendJaiFullName(options, builder, named->resolved_typedef);
            } else {
                const int num_typedef_replacements = sizeof(Typedef_Replacements) / sizeof(Typedef_Replacements[0]);
                for (int i = 0; i < num_typedef_replacements; i += 1) {
                    auto replacement = Typedef_Replacements[i];
                    if (named->name == String(replacement[0])) {
                        builder.Append("%s", replacement[1]);
                        return;
                    }
                }

                builder.AppendString(named->name);
            }
        } break;
        case Type_Function: {
            auto func = reinterpret_cast<TypeFunction *>(type);

            builder.Append("#type (");

            for (int64_t i = 0; i < func->parameter_types.count; i += 1) {
                auto param = func->parameter_types[i];
                if (i > 0) {
                    builder.Append(", ");
                }

                AppendJaiType(options, builder, param, indentation + 1);
            }

            builder.Append(") -> ");

            AppendJaiType(options, builder, func->return_type, indentation);

            builder.Append(" #c_call");
        } break;
    }
}

void AppendJaiFullName(const JaiGenerateOptions &options, StringBuilder &builder, Struct *s) {
    if (s->parent_struct) {
        AppendJaiFullName(options, builder, s->parent_struct);
        builder.Append(".");
    }

    builder.Append("%.*s", FStr(s->basename));
}

void AppendJaiFullName(const JaiGenerateOptions &options, StringBuilder &builder, Enum *e) {
    if (e->parent_struct) {
        AppendJaiFullName(options, builder, e->parent_struct);
        builder.Append(".");
    }

    builder.Append("%.*s", FStr(e->basename));
}

void AppendJaiFullName(const JaiGenerateOptions &options, StringBuilder &builder, Typedef *t) {
    if (t->parent_struct) {
        AppendJaiFullName(options, builder, t->parent_struct);
        builder.Append(".");
    }

    builder.Append("%.*s", FStr(t->basename));
}

void AppendJaiFullName(const JaiGenerateOptions &options, StringBuilder &builder, Define *def) {
    if (def->parent_struct) {
        AppendJaiFullName(options, builder, def->parent_struct);
        builder.Append(".");
    }

    builder.Append("%.*s", FStr(def->basename));
}

bool AppendJaiStruct(const JaiGenerateOptions &options, StringBuilder &builder, Struct *s, int indentation) {
    if (options.strip_declarations.Contains(s->name)) {
        return false;
    }

    builder.Append("%.*s :: struct {\n", FStr(s->basename));

    auto bytes_written_so_far = builder.count;

    for (int64_t i = 0; i < s->sub_defines.count; i += 1) {
        auto def = s->sub_defines[i];

        builder.AppendIndentation(indentation + 1);
        AppendJaiDefine(options, builder, def, indentation + 1);
    }

    if (builder.count != bytes_written_so_far && s->sub_typedefs.count > 0) {
        builder.Append("\n");
    }

    for (int64_t i = 0; i < s->sub_typedefs.count; i += 1) {
        auto t = s->sub_typedefs[i];
        if (t->associated_enum || t->associated_struct) {
            continue;
        }

        builder.AppendIndentation(indentation + 1);
        AppendJaiTypedef(options, builder, t, indentation + 1);
    }

    for (int64_t i = 0; i < s->sub_enums.count; i += 1) {
        if (builder.count != bytes_written_so_far) {
            builder.Append("\n");
        }

        builder.AppendIndentation(indentation + 1);
        AppendJaiEnum(options, builder, s->sub_enums[i], indentation + 1);
    }

    for (int64_t i = 0; i < s->sub_structs.count; i += 1) {
        if (builder.count != bytes_written_so_far) {
            builder.Append("\n");
        }

        builder.AppendIndentation(indentation + 1);
        AppendJaiStruct(options, builder, s->sub_structs[i], indentation + 1);
    }

    if (builder.count != bytes_written_so_far && s->fields.count > 0) {
        builder.Append("\n");
    }

    for (int64_t i = 0; i < s->fields.count; i += 1) {
        auto field = s->fields[i];

        builder.AppendIndentation(indentation + 1);

        if (i == 0 && s->base_struct != nullptr) {
            builder.Append("#as using,except(base) ");
        }

        builder.Append("%.*s : ", FStr(field->name));
        AppendJaiType(options, builder, field->type, indentation + 1);
        builder.Append(";\n");
    }

    if (builder.count != bytes_written_so_far && s->functions.count > 0) {
        builder.Append("\n");
    }

    for (int64_t i = 0; i < s->functions.count; i += 1) {
        auto func = s->functions[i];

        builder.AppendIndentation(indentation + 1);
        AppendJaiFunction(options, builder, func, indentation + 1);
    }

    if (builder.count != bytes_written_so_far && s->methods.count > 0) {
        builder.Append("\n");
    }

    for (int64_t i = 0; i < s->methods.count; i += 1) {
        auto func = s->methods[i];

        builder.AppendIndentation(indentation + 1);
        AppendJaiFunction(options, builder, func, indentation + 1);
    }

    if (builder.count == bytes_written_so_far) {
        builder.Erase();
    } else {
        builder.AppendIndentation(indentation);
    }

    builder.Append("}\n");

    return true;
}

bool AppendJaiEnum(const JaiGenerateOptions &options, StringBuilder &builder, Enum *e, int indentation) {
    if (options.strip_declarations.Contains(e->name)) {
        return false;
    }

    auto real_name = e->associated_typedef ? e->associated_typedef->basename : e->basename;
    builder.Append("%.*s :: %s ", FStr(real_name), e->is_flags ? "enum_flags" : "enum");

    auto base_type = e->associated_typedef ? e->associated_typedef->type : e->base_type;
    if (base_type) {
        AppendJaiType(options, builder, base_type, indentation);
        builder.Append(" ");
    }

    builder.Append("{\n");

    for (int64_t i = 0; i < e->values.count; i += 1) {
        auto value = e->values[i];

        builder.AppendIndentation(indentation + 1);
        builder.Append("%.*s :: ", FStr(value.basename));

        if (base_type && base_type->kind >= Type_UInt8 && base_type->kind <= Type_UInt64) {
            builder.Append("%llu;\n", value.unsigned_value);
        } else {
            builder.Append("%lli;\n", value.signed_value);
        }
    }

    builder.AppendIndentation(indentation);
    builder.Append("}\n");

    return true;
}

bool AppendJaiTypedef(const JaiGenerateOptions &options, StringBuilder &builder, Typedef *t, int indentation) {
    if (options.strip_declarations.Contains(t->name)) {
        return false;
    }

    builder.Append("%.*s :: ", FStr(t->basename));
    AppendJaiType(options, builder, t->type, indentation);
    builder.Append(";\n");

    return true;
}

bool AppendJaiFunction(const JaiGenerateOptions &options, StringBuilder &builder, Function *func, int indentation) {
    if (options.strip_declarations.Contains(func->name)) {
        return false;
    }

    builder.Append("%.*s :: (", FStr(func->basename));

    for (int64_t i = 0; i < func->parameters.count; i += 1) {
        auto param = func->parameters[i];
        if (i > 0) {
            builder.Append(", ");
        }

        builder.Append("%.*s : ", FStr(param->name));
        AppendJaiType(options, builder, param->type, indentation + 1);
    }

    builder.Append(") -> ");

    AppendJaiType(options, builder, func->return_type, indentation);

    builder.Append(" #foreign JoltC \"%.*s\";\n", FStr(func->name));

    return true;
}

bool AppendJaiDefine(const JaiGenerateOptions &options, StringBuilder &builder, Define *def, int indentation) {
    if (options.strip_declarations.Contains(def->name)) {
        return false;
    }

    builder.Append("%.*s :: ", FStr(def->basename));

    if (def->tokens.count == 0) {
        builder.Append("1");
    }

    for (int64_t i = 0; i < def->tokens.count; i += 1) {
        auto tok = def->tokens[i];
        switch (tok.kind) {
        case Token_Literal: {
            auto lit = tok.text;
            if (lit.EndsWith("f")) {
                lit = lit.TrimRight(1);
            }

            builder.Append("%.*s", FStr(lit));
        } break;
        case Token_Identifier: {
            if (tok.resolved_define) {
                AppendJaiFullName(options, builder, tok.resolved_define);
            } else {
                auto name = StripPrefix(tok.text, options.strip_prefixes);
                builder.Append("%.*s", FStr(name));
            }
        } break;
        default: {
            builder.Append("%.*s", FStr(tok.text));
        } break;
        }
    }

    builder.Append(";\n");

    return true;
}

void AppendJaiCode(const JaiGenerateOptions &options, const Database &db, StringBuilder &builder) {
    builder.Append("// Defines\n\n");

    for (int64_t i = 0; i < db.all_defines.count; i += 1) {
        auto def = db.all_defines[i];
        if (def->parent_struct) {
            continue;
        }

        AppendJaiDefine(options, builder, def, 0);
    }

    builder.Append("\n// Typedefs\n\n");

    for (int64_t i = 0; i < db.all_typedefs.count; i += 1) {
        auto t = db.all_typedefs[i];
        if (t->parent_struct || t->associated_enum || t->associated_struct) {
            continue;
        }

        AppendJaiTypedef(options, builder, t, 0);
    }

    builder.Append("\n// Enums\n\n");

    for (int64_t i = 0; i < db.all_enums.count; i += 1) {
        auto e = db.all_enums[i];
        if (e->parent_struct) {
            continue;
        }

        if (AppendJaiEnum(options, builder, e, 0)) {
            builder.Append("\n");
        }
    }

    builder.Append("// Structs\n\n");

    for (int64_t i = 0; i < db.all_structs.count; i += 1) {
        auto s = db.all_structs[i];
        if (s->parent_struct) {
            continue;
        }

        if (AppendJaiStruct(options, builder, s, 0)) {
            builder.Append("\n");
        }
    }

    builder.Append("// Functions\n\n");

    for (int64_t i = 0; i < db.all_functions.count; i += 1) {
        auto func = db.all_functions[i];
        if (func->parent_struct) {
            continue;
        }

        AppendJaiFunction(options, builder, func, 0);
    }
}
