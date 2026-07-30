#include <Jai.hpp>

void AppendJaiFullName(StringBuilder &builder, Struct *s) {
    if (s->parent_struct) {
        AppendJaiFullName(builder, s->parent_struct);
        builder.Append(".");
    }

    builder.Append("%.*s", FStr(s->basename));
}

void AppendJaiFullName(StringBuilder &builder, Enum *e) {
    if (e->parent_struct) {
        AppendJaiFullName(builder, e->parent_struct);
        builder.Append(".");
    }

    builder.Append("%.*s", FStr(e->basename));
}

void AppendJaiFullName(StringBuilder &builder, Typedef *t) {
    if (t->parent_struct) {
        AppendJaiFullName(builder, t->parent_struct);
        builder.Append(".");
    }

    builder.Append("%.*s", FStr(t->basename));
}

void AppendJaiType(StringBuilder &builder, Type *type, int indentation) {
    if (!type) {
        builder.AppendString("<null>");
        return;
    }

    switch (type->kind) {
        default:
        case Type_Unknown: {
            builder.Append("<unknown>");
        } break;
        case Type_Invalid: {
            builder.AppendString("<invalid>");
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
            AppendJaiType(builder, pointer->pointer_to, indentation);
        } break;
        case Type_Array: {
            auto arr = reinterpret_cast<TypeArray *>(type);
            builder.Append("[%lld]", arr->num_elements);
            AppendJaiType(builder, arr->element_type, indentation);
        } break;
        case Type_Enum: {
            auto e = reinterpret_cast<TypeEnum *>(type);
            AppendJaiEnum(builder, e->e, indentation);
        } break;
        case Type_Struct: {
            auto s = reinterpret_cast<TypeStruct *>(type);
            AppendJaiStruct(builder, s->s, indentation);
        } break;
        case Type_Named: {
            auto named = reinterpret_cast<TypeNamed *>(type);
            if (named->resolved_struct) {
                AppendJaiFullName(builder, named->resolved_struct);
            } else if (named->resolved_enum) {
                AppendJaiFullName(builder, named->resolved_enum);
            } else if (named->resolved_typedef) {
                AppendJaiFullName(builder, named->resolved_typedef);
            } else {
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

                AppendJaiType(builder, param, indentation + 1);
            }

            builder.Append(") -> ");

            AppendJaiType(builder, func->return_type, indentation);

            builder.Append(" #c_call");
        } break;
    }
}

void AppendJaiStruct(StringBuilder &builder, Struct *s, int indentation) {
    builder.Append("%.*s :: struct {\n", FStr(s->basename));

    auto bytes_written_so_far = builder.count;

    for (int64_t i = 0; i < s->sub_typedefs.count; i += 1) {
        auto t = s->sub_typedefs[i];
        if (t->associated_enum || t->associated_struct) {
            continue;
        }

        builder.AppendIndentation(indentation + 1);
        AppendJaiTypedef(builder, t, indentation + 1);
    }

    for (int64_t i = 0; i < s->sub_enums.count; i += 1) {
        if (builder.count != bytes_written_so_far) {
            builder.Append("\n");
        }

        builder.AppendIndentation(indentation + 1);
        AppendJaiEnum(builder, s->sub_enums[i], indentation + 1);
    }

    for (int64_t i = 0; i < s->sub_structs.count; i += 1) {
        if (builder.count != bytes_written_so_far) {
            builder.Append("\n");
        }

        builder.AppendIndentation(indentation + 1);
        AppendJaiStruct(builder, s->sub_structs[i], indentation + 1);
    }

    if (builder.count != bytes_written_so_far && s->fields.count > 0) {
        builder.Append("\n");
    }

    for (int64_t i = 0; i < s->fields.count; i += 1) {
        auto field = s->fields[i];

        builder.AppendIndentation(indentation + 1);

        if (i == 0 && s->base_struct != nullptr) {
            builder.Append("#as using ");
        }

        builder.Append("%.*s : ", FStr(field->name));
        AppendJaiType(builder, field->type, indentation + 1);
        builder.Append(";\n");
    }

    if (builder.count != bytes_written_so_far && s->functions.count > 0) {
        builder.Append("\n");
    }

    for (int64_t i = 0; i < s->functions.count; i += 1) {
        auto func = s->functions[i];

        builder.AppendIndentation(indentation + 1);
        AppendJaiFunction(builder, func, indentation + 1);
    }

    if (builder.count != bytes_written_so_far && s->methods.count > 0) {
        builder.Append("\n");
    }

    for (int64_t i = 0; i < s->methods.count; i += 1) {
        auto func = s->methods[i];

        builder.AppendIndentation(indentation + 1);
        AppendJaiFunction(builder, func, indentation + 1);
    }

    if (builder.count == bytes_written_so_far) {
        builder.Erase();
    } else {
        builder.AppendIndentation(indentation);
    }

    builder.Append("}\n");
}

void AppendJaiEnum(StringBuilder &builder, Enum *e, int indentation) {
    auto real_name = e->associated_typedef ? e->associated_typedef->basename : e->basename;
    builder.Append("%.*s :: enum ", FStr(real_name));

    auto base_type = e->associated_typedef ? e->associated_typedef->type : e->base_type;
    if (base_type) {
        AppendJaiType(builder, base_type, indentation);
        builder.Append(" ");
    }

    builder.Append("{\n");

    for (int64_t i = 0; i < e->values.count; i += 1) {
        auto value = e->values[i];

        builder.AppendIndentation(indentation + 1);
        builder.Append("%.*s :: ", FStr(value.basename));

        if (base_type && base_type->kind >= Type_UInt8 && base_type->kind <= Type_UInt64) {
            builder.Append("%llu,\n", value.unsigned_value);
        } else {
            builder.Append("%lli,\n", value.signed_value);
        }
    }

    builder.AppendIndentation(indentation);
    builder.Append("}\n");
}

void AppendJaiTypedef(StringBuilder &builder, Typedef *t, int indentation) {
    builder.Append("%.*s :: ", FStr(t->basename));
    AppendJaiType(builder, t->type, indentation);
    builder.Append(";\n");
}

void AppendJaiFunction(StringBuilder &builder, Function *func, int indentation) {
    builder.Append("%.*s :: (", FStr(func->basename));

    for (int64_t i = 0; i < func->parameters.count; i += 1) {
        auto param = func->parameters[i];
        if (i > 0) {
            builder.Append(", ");
        }

        builder.Append("%.*s : ", FStr(param->name));
        AppendJaiType(builder, param->type, indentation + 1);
    }

    builder.Append(") -> ");

    AppendJaiType(builder, func->return_type, indentation);

    builder.Append(" #foreign JoltC \"%.*s\";\n", FStr(func->name));
}
