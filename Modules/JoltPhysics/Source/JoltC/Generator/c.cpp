#include <Core.hpp>
#include <Database.hpp>

void AppendTypePrefix(StringBuilder &builder, Type *t, int indentation);
void AppendTypePostfix(StringBuilder &builder, Type *type, int indentation);
void AppendType(StringBuilder &builder, Type *type, int indentation);
void AppendStruct(StringBuilder &builder, Struct *s, int indentation);
void AppendEnum(StringBuilder &builder, Enum *e, int indentation);
void AppendVariable(StringBuilder &builder, Variable *var, int indentation);
void AppendFunctionSignature(StringBuilder &builder, Function *func, int indentation);

static
bool ShouldPrintSpaceAfterType(Type *type) {
    return type->kind != Type_Pointer;
}

void AppendType(StringBuilder &builder, Type *type, int indentation) {
    AppendTypePrefix(builder, type, indentation);
    AppendTypePostfix(builder, type, indentation);
}

void AppendTypePrefix(StringBuilder &builder, Type *type, int indentation) {
    static const char *TypeKind_Str[] = {
        "invalid",
        "unknown",
        "void",
        "bool",
        "char",
        "uint8_t",
        "uint16_t",
        "uint32_t",
        "uint64_t",
        "uint128_t",
        "int8_t",
        "int16_t",
        "int32_t",
        "int64_t",
        "int128_t",
        "float",
        "double",
        "pointer",
        "array",
        "struct",
        "enum",
        "function",
        "typedef",
        "named",
    };

    if (!type) {
        builder.AppendString("<null>");
        return;
    }

    if (type->flags & TypeFlag_Const) {
        builder.AppendString("const ");
    }

    switch (type->kind) {
        default: {
            builder.AppendString(TypeKind_Str[type->kind]);
        } break;
        case Type_Invalid: {
            builder.AppendString("<invalid>");
        } break;
        case Type_Unknown: {
            builder.Append("<unknown>");
        } break;
        case Type_Pointer: {
            auto pointer = reinterpret_cast<TypePointer *>(type);

            AppendTypePrefix(builder, pointer->pointer_to, indentation);

            bool space;
            if (pointer->pointer_to->kind == Type_Function) {
                auto func = reinterpret_cast<TypeFunction *>(pointer->pointer_to);
                space = ShouldPrintSpaceAfterType(func->return_type);
            } else {
                space = ShouldPrintSpaceAfterType(pointer->pointer_to);
            }

            if (space) {
                builder.AppendString(" ");
            }

            if (pointer->pointer_to->kind == Type_Function) {
                builder.AppendString("(");
            }
            builder.AppendString("*");
        } break;
        case Type_Array: {
            auto arr = reinterpret_cast<TypeArray *>(type);
            AppendTypePrefix(builder, arr->element_type, indentation);
        } break;
        case Type_Enum: {
            auto e = reinterpret_cast<TypeEnum *>(type);
            AppendEnum(builder, e->e, indentation);
        } break;
        case Type_Struct: {
            auto s = reinterpret_cast<TypeStruct *>(type);
            AppendStruct(builder, s->s, indentation);
        } break;
        case Type_Named: {
            auto named = reinterpret_cast<TypeNamed *>(type);
            builder.AppendString(named->name);
        } break;
        case Type_Function: {
            auto func = reinterpret_cast<TypeFunction *>(type);
            AppendType(builder, func->return_type, indentation);
        } break;
    }
}

void AppendTypePostfix(StringBuilder &builder, Type *type, int indentation) {
    switch (type->kind) {
        case Type_Function: {
            auto func = reinterpret_cast<TypeFunction *>(type);

            builder.AppendString("(");
            for (int64_t i = 0; i < func->parameter_types.count; i += 1) {
                Type *param = func->parameter_types[i];

                if (i > 0) {
                    builder.AppendString(", ");
                }

                AppendType(builder, param, indentation);
            }
            builder.AppendString(")");
        } break;
        case Type_Pointer: {
            auto pointer = reinterpret_cast<TypePointer *>(type);

            if (pointer->pointer_to->kind == Type_Function) {
                builder.AppendString(")");
            }
            AppendTypePostfix(builder, pointer->pointer_to, indentation);
        } break;
        case Type_Array: {
            auto arr = reinterpret_cast<TypeArray *>(type);

            AppendTypePostfix(builder, arr->element_type, indentation);

            if (arr->num_elements >= 0) {
                builder.Append("[%u]", arr->num_elements);
            } else {
                builder.AppendString("[]");
            }
        } break;
    }
}

void AppendVariable(StringBuilder &builder, Variable *var, int indentation) {
    AppendTypePrefix(builder, var->type, indentation);
    if (ShouldPrintSpaceAfterType(var->type)) {
        builder.Append(" ");
    }

    builder.AppendString(var->name);

    AppendTypePostfix(builder, var->type, indentation);
}

void AppendStruct(StringBuilder &builder, Struct *s, int indentation) {
    if (s->is_union) {
        builder.Append("union ");
    } else {
        builder.Append("struct ");
    }

    builder.Append("%.*s {\n", FStr(s->name));
    for (int64_t i = 0; i < s->fields.count; i += 1) {
        auto field = s->fields[i];

        builder.AppendIndentation(indentation + 1);
        AppendVariable(builder, field, indentation + 1);
        builder.Append(";\n");
    }

    builder.AppendIndentation(indentation);
    builder.Append("};\n");
}

void AppendEnum(StringBuilder &builder, Enum *e, int indentation) {
    builder.Append("enum %.*s {\n", FStr(e->name));

    for (int64_t i = 0; i < e->values.count; i += 1) {
        auto value = e->values[i];

        builder.AppendIndentation(indentation + 1);
        builder.Append("%.*s = ", FStr(value.name));
        if (e->base_type && e->base_type->kind >= Type_UInt8 && e->base_type->kind <= Type_UInt64) {
            builder.Append("%llu,\n", value.unsigned_value);
        } else {
            builder.Append("%lli,\n", value.signed_value);
        }
    }

    builder.AppendIndentation(indentation);
    builder.Append("};\n");
}

void AppendTypedef(StringBuilder &builder, Typedef *t, int indentation) {
    builder.Append("typedef ");

    AppendTypePrefix(builder, t->type, indentation);
    if (ShouldPrintSpaceAfterType(t->type)) {
        builder.Append(" ");
    }

    builder.AppendString(t->name);

    AppendTypePostfix(builder, t->type, indentation);

    builder.Append(";\n");
}

void AppendFunctionSignature(StringBuilder &builder, Function *func, int indentation) {
    AppendType(builder, func->return_type, indentation);

    if (ShouldPrintSpaceAfterType(func->return_type)) {
        builder.AppendString(" ");
    }

    builder.AppendString(func->name);

    builder.AppendString("(");

    for (int64_t i = 0; i < func->parameters.count; i += 1) {
        if (i > 0) {
            builder.AppendString(", ");
        }

        auto param = func->parameters[i];
        AppendVariable(builder, param, indentation + 1);
    }

    builder.AppendString(")");
}
