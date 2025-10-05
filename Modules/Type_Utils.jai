TypeIsString :: inline (type : Type) -> bool
{
    return TypeIsString(cast(*Type_Info) type);
}

TypeIsString :: inline (info : *Type_Info) -> bool
{
    return info != null && info.type == .STRING;
}

TypeIsBool :: inline (type : Type) -> bool
{
    return TypeIsBool(cast(*Type_Info) type);
}

TypeIsBool :: inline (info : *Type_Info) -> bool
{
    return info != null && info.type == .BOOL;
}

TypeIsInteger :: inline (type : Type) -> bool
{
    return TypeIsInteger(cast(*Type_Info) type);
}

TypeIsInteger :: inline (info : *Type_Info) -> bool
{
    return info != null && info.type == .INTEGER;
}

TypeIsFloat :: inline (type : Type) -> bool
{
    return TypeIsFloat(cast(*Type_Info) type);
}

TypeIsFloat :: inline (info : *Type_Info) -> bool
{
    return info != null && info.type == .FLOAT;
}

TypeIsNumeric :: inline (type : Type) -> bool
{
    return TypeIsNumeric(cast(*Type_Info) type);
}

TypeIsNumeric :: inline (info : *Type_Info) -> bool
{
    return info != null && (info.type == .INTEGER || info.type == .FLOAT);
}

TypeIsSigned :: inline (type : Type) -> bool
{
    return TypeIsSigned(cast(*Type_Info) type);
}

TypeIsSigned :: (info : *Type_Info) -> bool
{
    if !TypeIsNumeric(info)
        return false;

    if info.type == .INTEGER
        return (cast(*Type_Info_Integer) info).signed;

    return true;
}

TypeIsUnsigned :: inline (type : Type) -> bool
{
    return TypeIsUnsigned(cast(*Type_Info) type);
}

TypeIsUnsigned :: (info : *Type_Info) -> bool
{
    if !TypeIsInteger(info)
        return false;

    return !(cast(*Type_Info_Integer) info).signed;
}

TypeIsPointer :: inline (type : Type) -> bool
{
    return TypeIsPointer(cast(*Type_Info) type);
}

TypeIsPointer :: inline (info : *Type_Info) -> bool
{
    return info != null && info.type == .POINTER;
}

TypeIsPointerTo :: inline (type : Type, to : Type) -> bool
{
    return TypeIsPointerTo(cast(*Type_Info) type, cast(*Type_Info) to);
}

TypeIsPointerTo :: (info : *Type_Info, to : *Type_Info) -> bool
{
    if !to || !TypeIsPointer(info)
        return false;

    return (cast(*Type_Info_Pointer) info).pointer_to == to;
}

TypeIsArray :: inline (type : Type) -> bool
{
    return TypeIsArray(cast(*Type_Info) type);
}

TypeIsArray :: inline (info : *Type_Info) -> bool
{
    return info != null && info.type == .ARRAY;
}

TypeIsFixedArray :: inline (type : Type) -> bool
{
    return TypeIsFixedArray(cast(*Type_Info) type);
}

TypeIsFixedArray :: inline (info : *Type_Info) -> bool
{
    return TypeIsArray(info)
        && (cast(*Type_Info_Array) info).array_type == .FIXED;
}

TypeIsArrayView :: inline (type : Type) -> bool
{
    return TypeIsArrayView(cast(*Type_Info) type);
}

TypeIsArrayView :: inline (info : *Type_Info) -> bool
{
    return TypeIsArray(info)
        && (cast(*Type_Info_Array) info).array_type == .VIEW;
}

TypeIsResizableArray :: inline (type : Type) -> bool
{
    return TypeIsResizableArray(cast(*Type_Info) type);
}

TypeIsResizableArray :: inline (info : *Type_Info) -> bool
{
    return TypeIsArray(info)
        && (cast(*Type_Info_Array) info).array_type == .RESIZABLE;
}

TypeIsArrayOf :: inline (type : Type, of : Type) -> bool
{
    return TypeIsArrayOf(cast(*Type_Info) type, cast(*Type_Info) of);
}

TypeIsArrayOf :: inline (info : *Type_Info, of : *Type_Info) -> bool
{
    if !of || !TypeIsArray(info)
        return false;

    return (cast(*Type_Info_Array) info).element_type == of;
}

TypeIsStructOrUnion :: inline (type : Type) -> bool
{
    return TypeIsStructOrUnion(cast(*Type_Info) type);
}

TypeIsStructOrUnion :: inline (info : *Type_Info) -> bool
{
    return info != null && info.type == .STRUCT;
}

TypeIsStruct :: inline (type : Type) -> bool
{
    return TypeIsStruct(cast(*Type_Info) type);
}

TypeIsStruct :: inline (info : *Type_Info) -> bool
{
    if !TypeIsStructOrUnion(info)
        return false;

    return (cast(*Type_Info_Struct) info).textual_flags & .UNION != .UNION;
}

TypeIsUnion :: inline (type : Type) -> bool
{
    return TypeIsUnion(cast(*Type_Info) type);
}

TypeIsUnion :: inline (info : *Type_Info) -> bool
{
    if !TypeIsStructOrUnion(info)
        return false;

    return (cast(*Type_Info_Struct) info).textual_flags & .UNION == .UNION;
}

GetStructMemberType :: inline (type : Type, name : string, flags : Type_Info_Struct_Member.Flags = 0) -> *Type_Info
{
    return GetStructMemberType(cast(*Type_Info) type, name, flags);
}

GetStructMemberType :: (info : *Type_Info, name : string, flags : Type_Info_Struct_Member.Flags = 0) -> *Type_Info
{
    if !TypeIsStructOrUnion(info)
        return null;

    info_struct := cast(*Type_Info_Struct) info;
    for member : info_struct.members
    {
        if member.name == name && (member.flags & flags) == flags
            return member.type;
    }

    return null;
}

GetNonConstantStructMember :: (info : *Type_Info, index : s64) -> *Type_Info_Struct_Member
{
    if !TypeIsStructOrUnion(info)
        return null;

    non_constant_index := -1;
    info_struct := cast(*Type_Info_Struct) info;
    for * member : info_struct.members
    {
        if !(member.flags & .CONSTANT)
        {
            non_constant_index += 1;

            if non_constant_index == index
                return member;
        }
    }

    return null;
}

TypeIsVariant :: inline (type : Type) -> bool
{
    return TypeIsVariant(cast(*Type_Info) type);
}

TypeIsVariant :: inline (info : *Type_Info) -> bool
{
    return info != null && info.type == .VARIANT;
}

TypeIsVariantOf :: inline (type : Type, of : Type) -> bool
{
    return TypeIsVariantOf(cast(*Type_Info) type, cast(*Type_Info) of);
}

TypeIsVariantOf :: inline (info : *Type_Info, of : *Type_Info) -> bool
{
    if !of || !TypeIsVariant(info)
        return false;

    return (cast(*Type_Info_Variant) info).variant_of == of;
}

TypeDevariantize :: inline (type : Type, recursive := true) -> *Type_Info
{
    return TypeDevariantize(cast(*Type_Info) type, recursive);
}

TypeDevariantize :: (info : *Type_Info, recursive := true) -> *Type_Info
{
    if !recursive
    {
        if info
            return null;

        if info.type == .VARIANT
            return (cast(*Type_Info_Variant) info).variant_of;

        return info;
    }

    while info && info.type == .VARIANT
    {
        info = (cast(*Type_Info_Variant) info).variant_of;
    }

    return info;
}

TypeIsProcedure :: inline (type : Type) -> bool
{
    return TypeIsProcedure(cast(*Type_Info) type);
}

TypeIsProcedure :: inline (info : *Type_Info) -> bool
{
    return info != null && info.type == .PROCEDURE;
}

GetProcedureParamType :: inline (type : Type, index : s64) -> *Type_Info
{
    return GetProcedureParamType(cast(*Type_Info) type, index);
}

GetProcedureParamType :: (info : *Type_Info, index : s64) -> *Type_Info
{
    if !TypeIsProcedure(info)
        return null;

    proc_info := cast(*Type_Info_Procedure) info;

    if index < 0
        return null;

    if index >= proc_info.argument_types.count
        return null;

    return proc_info.argument_types[index];
}

GetProcedureReturnType :: inline (type : Type, index := 0) -> *Type_Info
{
    return GetProcedureReturnType(cast(*Type_Info) type, index);
}

GetProcedureReturnType :: (info : *Type_Info, index := 0) -> *Type_Info
{
    if !TypeIsProcedure(info)
        return null;

    proc_info := cast(*Type_Info_Procedure) info;

    if index < 0
        return null;

    if index >= proc_info.return_types.count
        return null;

    return proc_info.return_types[index];
}

TypeIsEnum :: inline (type : Type) -> bool
{
    return TypeIsEnum(cast(*Type_Info) type);
}

TypeIsEnum :: inline (info : *Type_Info) -> bool
{
    return info != null && info.type == .ENUM
        && (cast(*Type_Info_Enum) info).enum_type_flags & .FLAGS != .FLAGS;
}

TypeIsEnumFlags :: inline (type : Type) -> bool
{
    return TypeIsEnumFlags(cast(*Type_Info) type);
}

TypeIsEnumFlags :: inline (info : *Type_Info) -> bool
{
    return info != null && info.type == .ENUM
        && (cast(*Type_Info_Enum) info).enum_type_flags & .FLAGS == .FLAGS;
}

TypeIsSubstructOf :: inline (type : Type, of : Type) -> bool
{
    return TypeIsSubstructOf(cast(*Type_Info) type, cast(*Type_Info) of);
}

TypeIsSubstructOf :: (info : *Type_Info, of : *Type_Info, first_call := true) -> bool
{
    if !TypeIsStruct(info) {
        return false;
    }

    if info == of {
        return !first_call;
    }

    member := GetNonConstantStructMember(info, 0);
    if !member || !(member.flags & .AS) || !(member.flags & .USING) {
        return false;
    }

    if !TypeIsSubstructOf(member.type, of, false) {
        return false;
    }

    return true;
}

TypeGetSourcePolymorph :: (info : *Type_Info_Struct) -> *Type_Info_Struct
{
    if !info.polymorph_source_struct
        return null;

    while info && info.polymorph_source_struct
        info = info.polymorph_source_struct;

    return info;
}
