#pragma once

struct Struct;
struct Enum;
struct Typedef;
struct Variable;
struct Function;
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

    Struct *GetStruct(const String &name) const;
    Enum *GetEnum(const String &name) const;
    Typedef *GetTypedef(const String &name) const;
    Function *GetFunction(const String &name) const;
    Type *GetType(CXType type) const;
};

struct Struct {
    SourceCodeRange source_code_range;
    String name;
    CXCursor cursor;
    bool is_union;

    Array<Variable *> fields;

    Struct(CXCursor cursor);
};

struct EnumValue {
    SourceCodeRange source_code_range;
    String name;
    CXCursor cursor;
    int64_t signed_value = 0;
    uint64_t unsigned_value = 0;

    EnumValue(CXCursor cursor);
};

struct Enum {
    SourceCodeRange source_code_range;
    String name;
    CXCursor cursor;
    Array<EnumValue> values;
    Type *base_type = nullptr;

    Enum(CXCursor cursor);
};

struct Typedef {
    SourceCodeRange source_code_range;
    String name;
    CXCursor cursor;
    Type *type;

    Typedef(CXCursor cursor);
};

struct Variable {
    SourceCodeRange source_code_range;
    String name;
    CXCursor cursor;

    Type *type = nullptr;

    Variable(CXCursor cursor);
};

struct Function {
    SourceCodeRange source_code_range;
    String name;
    CXCursor cursor;

    TypeFunction *type = nullptr;
    Array<Variable *> parameters;
    Type *return_type = nullptr;

    Function(CXCursor cursor);
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

    TypeNamed(TypeFlags flags, const String &name) : Type(Type_Named, flags), name(name) {}
};

String GetDeclName(CXCursor cursor);
SourceCodeRange GetSourceCodeRange(CXCursor cursor);
