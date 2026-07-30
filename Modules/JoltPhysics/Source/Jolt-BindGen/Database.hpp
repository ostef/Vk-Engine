#pragma once

struct Struct;
struct Enum;
struct Typedef;
struct Variable;
struct Function;
struct Define;
struct Type;
struct TypePointer;
struct TypeArray;
struct TypeFunction;
struct TypeStruct;
struct TypeEnum;
struct TypeTypedef;
struct TypeNamed;

struct SourceCodeLocation {
    String filename;
    int64_t line = 0;
    int64_t character = 0;
    int64_t offset = 0;
};

struct SourceCodeRange {
    String filename;
    int64_t start_line = 0;
    int64_t start_character = 0;
    int64_t start_offset = 0;
    int64_t end_line = 0;
    int64_t end_character = 0;
    int64_t end_offset = 0;
};

struct Database {
    Array<Struct *> all_structs;
    Array<Enum *> all_enums;
    Array<Typedef *> all_typedefs;
    Array<Variable *> all_variables;
    Array<Function *> all_functions;
    Array<Define *> all_defines;
    Array<Type *> all_types;

    Struct *GetStruct(const String &name) const;
    Enum *GetEnum(const String &name) const;
    Typedef *GetTypedef(const String &name) const;
    Function *GetFunction(const String &name) const;
    Define *GetDefine(const String &name) const;
    Type *GetType(CXType type);

    struct PostProcessOptions {
        Array<String> strip_prefixes;
    };

    void PostProcess(const PostProcessOptions &options);
};

struct Struct {
    SourceCodeRange source_code_range;
    String name;
    String basename;
    CXCursor cursor;
    bool is_union;

    Array<Variable *> fields;

    // Filled in after everything has been parsed
    Struct *parent_struct = nullptr;
    Struct *base_struct = nullptr;
    Array<Struct *> sub_structs;
    Array<Enum *> sub_enums;
    Array<Typedef *> sub_typedefs;
    Array<Function *> methods;
    Array<Function *> functions;
    Array<Define *> sub_defines;

    Struct(CXCursor cursor);
};

struct EnumValue {
    SourceCodeRange source_code_range;
    String name;
    String basename;
    CXCursor cursor;
    int64_t signed_value = 0;
    uint64_t unsigned_value = 0;

    EnumValue(CXCursor cursor);
};

struct Enum {
    SourceCodeRange source_code_range;
    String name;
    String basename;
    CXCursor cursor;
    Array<EnumValue> values;
    Type *base_type = nullptr;

    // Filled in after everything has been parsed
    bool is_flags = false;
    Typedef *associated_typedef = nullptr;
    Struct *parent_struct = nullptr;

    Enum(CXCursor cursor);
};

struct Typedef {
    SourceCodeRange source_code_range;
    String name;
    String basename;
    CXCursor cursor;
    Type *type;

    // Filled in after everything has been parsed
    Struct *parent_struct = nullptr;
    Enum *associated_enum = nullptr;
    Struct *associated_struct = nullptr;

    Typedef(CXCursor cursor);
};

struct Variable {
    SourceCodeRange source_code_range;
    String name;
    String basename;
    CXCursor cursor;

    Type *type = nullptr;

    Variable(CXCursor cursor);
};

typedef uint8_t FunctionFlags;
enum {
    FunctionFlag_Method = 1 << 0,
    FunctionFlag_Const  = 1 << 1,
};

struct Function {
    SourceCodeRange source_code_range;
    String name;
    String basename;
    CXCursor cursor;

    TypeFunction *type = nullptr;
    Array<Variable *> parameters;
    Type *return_type = nullptr;

    // Filled in after everything has been parsed
    Struct *parent_struct = nullptr;
    FunctionFlags flags = 0;

    Function(CXCursor cursor);
};

typedef uint8_t TokenKind;
enum {
    Token_Punctuation,
    Token_Literal,
    Token_Keyword,
    Token_Identifier,
    Token_Comment,
};

struct Token {
    SourceCodeRange source_code_range;
    TokenKind kind = 0;
    String text;

    // Filled in after everything has been parsed
    Define *resolved_define = nullptr; // We only handle identifiers that reference defines for now
};

struct Define {
    SourceCodeRange source_code_range;
    String name;
    String basename;
    CXCursor cursor;

    Array<Token> tokens;

    // Filled in after everything has been parsed
    Struct *parent_struct = nullptr;

    Define(CXCursor cursor);
};

typedef uint8_t TypeKind;
enum {
    Type_Invalid,
    Type_Unknown,
    Type_Void,
    Type_Bool,
    Type_Char,
    Type_UInt8,
    Type_UInt16,
    Type_UInt32,
    Type_UInt64,
    Type_UInt128,
    Type_Int8,
    Type_Int16,
    Type_Int32,
    Type_Int64,
    Type_Int128,
    Type_Float,
    Type_Double,
    Type_Pointer,
    Type_Array,
    Type_Struct,
    Type_Enum,
    Type_Function,
    Type_Typedef,
    Type_Named,
};

typedef uint8_t TypeFlags;
enum {
    TypeFlag_Const    = 1 << 0,
    TypeFlag_Volatile = 1 << 1,
};

struct Type {
    TypeKind kind = Type_Invalid;
    TypeFlags flags = 0;

    Type(TypeKind kind, TypeFlags flags) : kind(kind), flags(flags) {}
};

struct TypePointer : Type {
    Type *pointer_to = nullptr;

    TypePointer(TypeFlags flags, Type *pointer_to) : Type(Type_Pointer, flags), pointer_to(pointer_to) {}
};

struct TypeArray : Type {
    Type *element_type = nullptr;
    int64_t num_elements = 0;

    TypeArray(TypeFlags flags, Type *element_type, int64_t num_elements) : Type(Type_Array, flags), element_type(element_type), num_elements(num_elements) {}
};

struct TypeStruct : Type {
    Struct *s = nullptr;

    TypeStruct(TypeFlags flags, Struct *s) : Type(Type_Struct, flags), s(s) {}
};

struct TypeFunction : Type {
    Array<Type *> parameter_types;
    Type *return_type = nullptr;
    bool is_variadic;

    TypeFunction(TypeFlags flags, const Array<Type *> &parameter_types, Type *return_type, bool is_variadic) : Type(Type_Function, flags), parameter_types(parameter_types), return_type(return_type), is_variadic(is_variadic) {}
};

struct TypeEnum : Type {
    Enum *e = nullptr;

    TypeEnum(TypeFlags flags, Enum *e) : Type(Type_Enum, flags), e(e) {}
};

struct TypeTypedef : Type {
    Typedef *t = nullptr;

    TypeTypedef(TypeFlags flags, Typedef *t) : Type(Type_Typedef, flags), t(t) {}
};

struct TypeNamed : Type {
    String name;

    // Filled in after everything has been parsed
    Struct *resolved_struct = nullptr;
    Enum *resolved_enum = nullptr;
    Typedef *resolved_typedef = nullptr;

    TypeNamed(TypeFlags flags, const String &name) : Type(Type_Named, flags), name(name) {}
};

String GetDeclName(CXCursor cursor);
SourceCodeRange GetSourceCodeRange(CXSourceRange range);
SourceCodeRange GetSourceCodeRange(CXCursor cursor);

String GetParentName(const String &str);

String StripPrefix(const String &str, const Array<String> &prefixes);
