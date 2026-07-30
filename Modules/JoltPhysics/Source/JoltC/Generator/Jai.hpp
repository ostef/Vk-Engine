#pragma once

#include <Core.hpp>
#include <Database.hpp>

void AppendJaiType(StringBuilder &builder, Type *type, int indentation);
void AppendJaiStruct(StringBuilder &builder, Struct *s, int indentation);
void AppendJaiEnum(StringBuilder &builder, Enum *e, int indentation);
void AppendJaiTypedef(StringBuilder &builder, Typedef *t, int indentation);
void AppendJaiFunction(StringBuilder &builder, Function *func, int indentation);
void AppendJaiFullName(StringBuilder &builder, Struct *s);
void AppendJaiFullName(StringBuilder &builder, Enum *e);
void AppendJaiFullName(StringBuilder &builder, Typedef *t);
