#pragma once

#include <Core.hpp>
#include <Database.hpp>

struct JaiGenerateOptions {
    Array<String> strip_prefixes;
    Array<String> strip_declarations;
};

void AppendJaiType(const JaiGenerateOptions &options, StringBuilder &builder, Type *type, int indentation);
void AppendJaiFullName(const JaiGenerateOptions &options, StringBuilder &builder, Struct *s);
void AppendJaiFullName(const JaiGenerateOptions &options, StringBuilder &builder, Enum *e);
void AppendJaiFullName(const JaiGenerateOptions &options, StringBuilder &builder, Typedef *t);
void AppendJaiFullName(const JaiGenerateOptions &options, StringBuilder &builder, Define *t);
bool AppendJaiStruct(const JaiGenerateOptions &options, StringBuilder &builder, Struct *s, int indentation);
bool AppendJaiEnum(const JaiGenerateOptions &options, StringBuilder &builder, Enum *e, int indentation);
bool AppendJaiTypedef(const JaiGenerateOptions &options, StringBuilder &builder, Typedef *t, int indentation);
bool AppendJaiFunction(const JaiGenerateOptions &options, StringBuilder &builder, Function *func, int indentation);
bool AppendJaiDefine(const JaiGenerateOptions &options, StringBuilder &builder, Define *def, int indentation);

void AppendJaiCode(const JaiGenerateOptions &options, const Database &db, StringBuilder &builder);
