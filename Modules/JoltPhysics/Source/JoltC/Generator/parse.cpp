#include <Core.hpp>
#include <Parse.hpp>

struct ParseContext {
    const ParseOptions &options;
    CXTranslationUnit tu;
    Database &db;
    Struct *parent_struct = nullptr;
    Enum *parent_enum = nullptr;
    Function *parent_func = nullptr;
};

Enum *ParseEnum(ParseContext &ctx, CXCursor cursor);
Struct *ParseStruct(ParseContext &ctx, CXCursor cursor);
Function *ParseFunction(ParseContext &ctx, CXCursor cursor);
Variable *ParseVariable(ParseContext &ctx, CXCursor cursor);
Typedef *ParseTypedef(ParseContext &ctx, CXCursor cursor);

#define VISITOR_PREAMBLE() \
    auto &ctx = *reinterpret_cast<ParseContext *>(client_data); \
    bool in_system_header = clang_Location_isInSystemHeader(clang_getCursorLocation(cursor)); \
    if (in_system_header) { \
        return CXChildVisit_Continue; \
    } \
    enum CXCursorKind kind = clang_getCursorKind(cursor);

static
enum CXChildVisitResult StructVisitor(CXCursor cursor, CXCursor parent, CXClientData client_data) {
    VISITOR_PREAMBLE();

    switch (kind) {
        case CXCursor_VarDecl:
        case CXCursor_FieldDecl: {
            ParseVariable(ctx, cursor);
        } break;
        default: break;
    }

    return CXChildVisit_Continue;
}

Struct *ParseStruct(ParseContext &ctx, CXCursor cursor) {
    enum CXCursorKind kind = clang_getCursorKind(cursor);

    Struct *s = new Struct(cursor);
    s->is_union = kind == CXCursor_UnionDecl;

    if (clang_Cursor_isAnonymous(cursor)) {
        Variable *var = new Variable(cursor);
        var->type = new TypeStruct(0, s);

        ctx.db.all_variables.Push(var);
    } else {
        ctx.db.all_structs.Push(s);
    }

    auto prev_struct = ctx.parent_struct;
    ctx.parent_struct = s;
    clang_visitChildren(cursor, StructVisitor, &ctx);
    ctx.parent_struct = prev_struct;

    return s;
}

Variable *ParseVariable(ParseContext &ctx, CXCursor cursor) {
    Variable *var = new Variable(cursor);

    if (ctx.parent_struct) {
        ctx.parent_struct->fields.Push(var);
    }

    var->type = ctx.db.GetType(clang_getCursorType(cursor));

    return var;
}

static
enum CXChildVisitResult EnumVisitor(CXCursor cursor, CXCursor parent, CXClientData client_data) {
    VISITOR_PREAMBLE();

    switch (kind) {
        case CXCursor_EnumConstantDecl: {
            ctx.parent_enum->values.Push(EnumValue(cursor));
        } break;
        default: break;
    }

    return CXChildVisit_Continue;
}

Enum *ParseEnum(ParseContext &ctx, CXCursor cursor) {
    Enum *e = new Enum(cursor);
    CXType base_type = clang_getEnumDeclIntegerType(cursor);
    base_type = clang_getCanonicalType(base_type);
    e->base_type = ctx.db.GetType(base_type);

    ctx.db.all_enums.Push(e);

    auto prev_enum = ctx.parent_enum;
    ctx.parent_enum = e;
    clang_visitChildren(cursor, EnumVisitor, &ctx);
    ctx.parent_enum = prev_enum;

    return e;
}

static
enum CXChildVisitResult FunctionVisitor(CXCursor cursor, CXCursor parent, CXClientData client_data) {
    VISITOR_PREAMBLE();

    // printf("%s(%d) %s\n", clang_getCString(clang_getCursorKindSpelling(kind)), kind, clang_getCString(clang_getCursorSpelling(cursor)));
    switch (kind) {
        case CXCursor_ParmDecl: {
            Variable *var = ParseVariable(ctx, cursor);
            ctx.parent_func->parameters.Push(var);
        } break;
        default: break;
    }

    return CXChildVisit_Continue;
}

Function *ParseFunction(ParseContext &ctx, CXCursor cursor) {
    Function *func = new Function(cursor);
    ctx.db.all_functions.Push(func);

    Type *type = ctx.db.GetType(clang_getCursorType(cursor));
    Assert(type->kind == Type_Function);

    func->type = reinterpret_cast<TypeFunction *>(type);
    func->return_type = func->type->return_type;

    auto prev_func = ctx.parent_func;
    ctx.parent_func = func;
    clang_visitChildren(cursor, FunctionVisitor, &ctx);
    ctx.parent_func = prev_func;

    return func;
}

Typedef *ParseTypedef(ParseContext &ctx, CXCursor cursor) {
    Typedef *ty = new Typedef(cursor);
    ctx.db.all_typedefs.Push(ty);

    CXType cx_type = clang_getCursorType(cursor);
    cx_type = clang_getCanonicalType(cx_type);
    ty->type = ctx.db.GetType(cx_type);

    return ty;
}

Define *ParseDefine(ParseContext &ctx, CXCursor cursor) {
    if (clang_Cursor_isMacroFunctionLike(cursor)) {
        return nullptr;
    }

    auto range = clang_getCursorExtent(cursor);
    CXToken *tokens = nullptr;
    uint32_t num_tokens = 0;
    clang_tokenize(ctx.tu, range, &tokens, &num_tokens);
    if (!tokens) {
        Error("Could not tokenize #define");
        return nullptr;
    }

    Define *def = new Define(cursor);
    ctx.db.all_defines.Push(def);

    tokens += 1;
    num_tokens -= 1;

    for (uint32_t i = 0; i < num_tokens; i += 1) {
        auto clang_tok = tokens[i];

        auto tok = def->tokens.Push();
        tok->source_code_range = GetSourceCodeRange(clang_getTokenExtent(ctx.tu, clang_tok));
        tok->text = strdup(clang_getCString(clang_getTokenSpelling(ctx.tu, clang_tok)));

        switch (clang_getTokenKind(clang_tok)) {
            case CXToken_Punctuation: {
                tok->kind = Token_Punctuation;
            } break;
            case CXToken_Keyword: {
                tok->kind = Token_Keyword;
            } break;
            case CXToken_Identifier: {
                tok->kind = Token_Identifier;
            } break;
            case CXToken_Literal: {
                tok->kind = Token_Literal;
            } break;
            case CXToken_Comment: {
                tok->kind = Token_Comment;
            } break;
        }
    }

    return def;
}

static
enum CXChildVisitResult TopLevelVisitor(CXCursor cursor, CXCursor parent, CXClientData client_data) {
    VISITOR_PREAMBLE();

    switch (kind) {
        case CXCursor_MacroDefinition: {
            ParseDefine(ctx, cursor);
        } break;
        // case CXCursor_MacroExpansion: {
        //     SourceCodeRange range = GetSourceCodeRange(cursor);
        //     const char *name = clang_getCString(clang_getCursorSpelling(cursor));
        //     printf("%s(%d) %s::%s at %s:%d:%d\n", clang_getCString(clang_getCursorKindSpelling(kind)), kind, GetDeclName(parent), name, range.filename, (int)range.start_line, (int)range.start_character);
        // } break;

        case CXCursor_InclusionDirective: {
            return CXChildVisit_Recurse;
        } break;

        case CXCursor_EnumDecl: {
            ParseEnum(ctx, cursor);
        } break;

        case CXCursor_StructDecl:
        case CXCursor_UnionDecl: {
            ParseStruct(ctx, cursor);
        } break;

        case CXCursor_TypedefDecl: {
            ParseTypedef(ctx, cursor);
        } break;

        case CXCursor_FunctionDecl: {
            ParseFunction(ctx, cursor);
        } break;

        default: break;
    }

    return CXChildVisit_Continue;
}

struct ParseIncludeContext {
    Array<String> &inclusions;
    CXTranslationUnit unit;
};

void InclusionVisitor(CXFile included_file, CXSourceLocation *inclusion_stack, unsigned include_len, CXClientData client_data) {
    auto &ctx = *reinterpret_cast<ParseIncludeContext *>(client_data);

    if (included_file == nullptr) {
        return;
    }

    if (!clang_isFileMultipleIncludeGuarded(ctx.unit, included_file)) {
        return;
    }

    if (clang_Location_isInSystemHeader(clang_getLocation(ctx.unit, included_file, 1, 1))) {
        return;
    }

    CXString cx_path = clang_getFileName(included_file);
    auto path = String(clang_getCString(cx_path));

    if (!path.EndsWith(".h") && !path.EndsWith(".hpp")) {
        return;
    }

    bool found = false;
    for (int64_t i = 0; i < ctx.inclusions.count; i += 1) {
        auto header = ctx.inclusions[i];
        if (header == path) {
            found = true;
            break;
        }
    }

    if (!found) {
        printf("%.*s\n", FStr(path));
        ctx.inclusions.Push(path);
    }
}

void PreParseFilesForIncludes(Array<String> *inclusions, const ParseOptions &options) {
    Array<char *> args = {};

    for (int64_t i = 0; i < options.include_dirs.count; i += 1) {
        auto dir = options.include_dirs[i];
        args.Push(String("-I").Join(dir).ToCStr());
    }

    for (int64_t i = 0; i < options.defines.count; i += 1) {
        auto def = options.defines[i];
        args.Push(String("-D").Join(def).ToCStr());
    }

    for (int64_t i = 0; i < options.extra_options.count; i += 1) {
        auto opt = options.extra_options[i];
        args.Push(opt.ToCStr());
    }

    CXIndex index = clang_createIndex(0, 0);

    for (int64_t i = 0; i < options.files.count; i += 1) {
        CXTranslationUnit unit = clang_parseTranslationUnit(index, options.files[i].ToCStr(), args.data, args.count, nullptr, 0, 0);
        if (!unit) {
            ErrorExit("Could not parse translation unit");
        }

        ParseIncludeContext ctx = {
            .inclusions=*inclusions,
            .unit=unit,
        };

        clang_getInclusions(unit, InclusionVisitor, &ctx);
    }
}

void ParseFiles(const ParseOptions &options, Database &db) {
    Array<String> files;
    if (options.preparse_files_for_correct_include_order) {
        PreParseFilesForIncludes(&files, options);
        for (int64_t i = 0; i < files.count; i += 1) {
            printf("%.*s\n", FStr(files[i]));
        }

        StringBuilder builder = {};
        for (int64_t i = 0; i < files.count; i += 1) {
            auto file = files[i];
            for (int64_t i = 0; i < options.include_dirs.count; i += 1) {
                auto include_dir = options.include_dirs[i];
                if (file.StartsWith(include_dir)) {
                    file = file.TrimLeft(include_dir.count);
                    if (file[0] == '/' || file[0] == '\\') {
                        file = file.TrimLeft(1);
                    }

                    break;
                }
            }

            builder.Append("#include \"%s\"\n", file);
        }

        String str = builder.Build();
        WriteEntireFile("Source/JoltHeaders.h", str.data, str.count);
    } else {
        files = options.files;
    }

    CXIndex index = clang_createIndex(0, 0);

    Array<const char *> args = {};
    for (int64_t i = 0; i < options.include_dirs.count; i += 1) {
        auto dir = options.include_dirs[i];
        args.Push(String("-I").Join(dir).ToCStr());
    }
    for (int64_t i = 0; i < options.defines.count; i += 1) {
        auto def = options.defines[i];
        args.Push(String("-D").Join(def).ToCStr());
    }
    for (int64_t i = 0; i < options.extra_options.count; i += 1) {
        args.Push(options.extra_options[i].ToCStr());
    }

    if (!options.strip_comments) {
        args.Push("-fparse-all-comments");
    }

    args.Push("temp.h");

    struct CXUnsavedFile temp_file = {};
    temp_file.Filename = "temp.h";

    StringBuilder builder = {};
    for (int64_t i = 0; i < files.count; i += 1) {
        auto file = files[i];
        builder.Append("#include \"%.*s\"\n", FStr(file));
    }

    auto contents = builder.Build();
    temp_file.Contents = contents.data;
    temp_file.Length = contents.count;

    CXTranslationUnit unit;
    enum CXErrorCode error_code = clang_parseTranslationUnit2(index, nullptr, args.data, args.count, &temp_file, 1, CXTranslationUnit_DetailedPreprocessingRecord, &unit);
    if (error_code != CXError_Success) {
        ErrorExit("Could not parse translation unit (error code %d)", error_code);
    }

    int num_diagnostics = clang_getNumDiagnostics(unit);
    if (num_diagnostics > 0) {
        printf("Clang diagnostics:\n");

        for (int i = 0; i < num_diagnostics; i += 1) {
            CXDiagnostic diag = clang_getDiagnostic(unit, i);
            enum CXDiagnosticSeverity severity = clang_getDiagnosticSeverity(diag);
            switch (severity) {
                case CXDiagnostic_Fatal:
                case CXDiagnostic_Error:
                case CXDiagnostic_Warning: {
                    CXString str = clang_formatDiagnostic(diag, clang_defaultDiagnosticDisplayOptions());
                    const char *cstr = clang_getCString(str);
                    printf("%s\n", cstr);
                } break;
                default: break;
            }
        }
    }

    CXCursor cursor = clang_getTranslationUnitCursor(unit);

    ParseContext ctx = {
        .options=options,
        .tu=unit,
        .db=db,
    };
    clang_visitChildren(cursor, TopLevelVisitor, &ctx);

    clang_disposeTranslationUnit(unit);
    clang_disposeIndex(index);
}
