#pragma once

#include <Core.hpp>
#include <Database.hpp>

struct JaiGenerateOptions {
    Array<String> strip_prefixes;
    Array<String> strip_declarations;
};

void AppendJaiType(const JaiGenerateOptions &options, StringBuilder &builder, Type *type, int indentation);
void AppendJaiStruct(const JaiGenerateOptions &options, StringBuilder &builder, Struct *s, int indentation);
void AppendJaiEnum(const JaiGenerateOptions &options, StringBuilder &builder, Enum *e, int indentation);
void AppendJaiTypedef(const JaiGenerateOptions &options, StringBuilder &builder, Typedef *t, int indentation);
void AppendJaiFunction(const JaiGenerateOptions &options, StringBuilder &builder, Function *func, int indentation);
void AppendJaiFullName(const JaiGenerateOptions &options, StringBuilder &builder, Struct *s);
void AppendJaiFullName(const JaiGenerateOptions &options, StringBuilder &builder, Enum *e);
void AppendJaiFullName(const JaiGenerateOptions &options, StringBuilder &builder, Typedef *t);
void AppendJaiFullName(const JaiGenerateOptions &options, StringBuilder &builder, Define *t);
void AppendJaiDefine(const JaiGenerateOptions &options, StringBuilder &builder, Define *def, int indentation);
