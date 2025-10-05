CVarType :: enum {
    Int;
    UInt;
    Float;
    String;
}

CVar :: struct {
    type : CVarType;
    value : union {
        s32_value : s32;
        u32_value : u32;
        float_value : float;
        string_value : string;
    };
}

g_cvars : HashMap(string, CVar);

GetCVar :: (name : string, $T : Type, default : T) -> T, exists : bool {
    cvar := HashMapGetPtr(*g_cvars, name);
    if !cvar {
        return default, false;
    }

    #if T == {
    case s32;
        if #complete cvar.type == {
        case .Int; #through;
        case .UInt; return cvar.value.s32_value, true;
        case .Float; return xx cvar.value.float_value, true;
        case .String; return default, true;
        }
    case u32;
        if #complete cvar.type == {
        case .Int; #through;
        case .UInt; return cvar.value.u32_value, true;
        case .Float; return xx cvar.value.float_value, true;
        case .String; return default, true;
        }
    case float;
        if #complete cvar.type == {
        case .Int; return xx cvar.value.s32_value, true;
        case .UInt; return xx cvar.value.u32_value, true;
        case .Float; return cvar.value.float_value, true;
        case .String; return default, true;
        }
    case bool;
        if #complete cvar.type == {
        case .Int; return cvar.value.u32_value != 0, true;
        case .UInt; return cvar.value.u32_value != 0, true;
        case .Float; return cvar.value.float_value != 0, true;
        case .String; return cvar.value.string_value.count > 0, true;
        }
    case string;
        if #complete cvar.type == {
        case .Int; return default, true;
        case .UInt; return default, true;
        case .Float; return default, true;
        case .String; return cvar.value.string_value, true;
        }
    }

    return default, true;
}

SetCVar :: (name : string, value : $T) {
    new_cvar, exists := HashMapInsert(*g_cvars, name);
    if exists && new_cvar.type == .String {
        Free(new_cvar.value.string_value.data);
    }

    new_cvar.* = .{};
    #if T == {
    case s32;
        new_cvar.type = .Int;
        new_cvar.value.s32_value = value;
    case u32;
        new_cvar.type = .UInt;
        new_cvar.value.u32_value = value;
    case float;
        new_cvar.type = .Float;
        new_cvar.value.float_value = value;
    case bool;
        new_cvar.type = .UInt;
        new_cvar.value.u32_value = cast(u32, value);
    case string;
        new_cvar.type = .String;
        new_cvar.value.string_value = StringClone(value);
    }
}

GetCVarUInt :: (name : string, default : u32 = 0) -> u32, exists : bool {
    value, exists := GetCVar(name, u32, default);
    return value, exists;
} @ModuleAPI

GetCVarInt :: (name : string, default : s32 = 0) -> s32, exists : bool {
    value, exists := GetCVar(name, s32, default);
    return value, exists;
} @ModuleAPI

GetCVarFloat :: (name : string, default := 0.0) -> float, exists : bool {
    value, exists := GetCVar(name, float, default);
    return value, exists;
} @ModuleAPI

GetCVarBool :: (name : string, default := false) -> bool, exists : bool {
    value, exists := GetCVar(name, bool, default);
    return value, exists;
} @ModuleAPI

GetCVarString :: (name : string, default := "") -> string, exists : bool {
    value, exists := GetCVar(name, string, default);
    return value, exists;
} @ModuleAPI

SetCVarUInt :: (name : string, value : u32) {
    SetCVar(name, value);
} @ModuleAPI

SetCVarInt :: (name : string, value : s32) {
    SetCVar(name, value);
} @ModuleAPI

SetCVarFloat :: (name : string, value : float) {
    SetCVar(name, value);
} @ModuleAPI

SetCVarBool :: (name : string, value : bool) {
    SetCVar(name, value);
} @ModuleAPI

SetCVarString :: (name : string, value : string) {
    SetCVar(name, value);
} @ModuleAPI
