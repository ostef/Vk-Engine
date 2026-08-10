UUID :: struct {
    high : u64;
    low : u64;

    #overlay(high)
    bytes : [16]u8;
}

Null_UUID :: UUID.{};

operator== :: inline (a : UUID, b : UUID) -> bool {
    return memcmp(*a, *b, size_of(UUID)) == 0;
}

operator!= :: inline (a : UUID, b : UUID) -> bool {
    return memcmp(*a, *b, size_of(UUID)) != 0;
}

CompareUUIDs :: inline (a : UUID, b : UUID) -> bool {
    return memcmp(*a, *b, size_of(UUID)) == 0;
}

HashUUID :: inline (uuid : UUID) -> u64 {
    #import "Hash";
    return fnv1a_hash(*uuid, size_of(UUID));
}

#add_context uuid_random_state : Random_State;

RandomUUID :: () -> UUID {
    if context.uuid_random_state.low == 0 && context.uuid_random_state.high == 0 {
        time := Basic.current_time_monotonic();

        random_seed(*context.uuid_random_state, Random_State.{high=xx,no_check time.high, low=time.low});
    }

    r1 := random_get(*context.uuid_random_state);
    r2 := random_get(*context.uuid_random_state);

    uuid : UUID = ---;
    memcpy(*uuid.bytes[0], *r1, 8);
    memcpy(*uuid.bytes[8], *r2, 8);

    // Set version to 4 (0100) in the high nibble of byte 6
    uuid.bytes[6] = (uuid.bytes[6] & 0x0f) | 0x40;
    // Set variant to RFC 4122 (10xx) in the high bits of byte 8
    uuid.bytes[8] = (uuid.bytes[8] & 0x3f) | 0x80;

    return uuid;
}

ParseUUID :: (str : string) -> UUID, ok : bool, remaining : string {
    ParseByte :: (str : string) -> u8, bool, string #no_abc {
        IsHexDigit :: inline (c : u8) -> bool {
            return (c >= #char "a" && c <= #char "f")
                || (c >= #char "A" && c <= #char "F")
                || (c >= #char "0" && c <= #char "9");
        }

        if str.count < 2 {
            return 0, false, str;
        }

        if !IsHexDigit(str[0]) || !IsHexDigit(str[1]) {
            return 0, false, str;
        }

        byte : u8;
        if str[0] >= "0" && str[0] <= "9" {
            byte = str[0] - #char "0";
        } else if str[0] >= "a" && str[0] <= "f" {
            byte = str[0] - #char "a" + 10;
        } else if str[0] >= "A" && str[0] <= "F" {
            byte = str[0] - #char "A" + 10;
        }

        byte *= 16;

        if str[1] >= "0" && str[1] <= "9" {
            byte += str[1] - #char "0";
        } else if str[1] >= "a" && str[1] <= "f" {
            byte += str[1] - #char "a" + 10;
        } else if str[1] >= "A" && str[1] <= "F" {
            byte += str[1] - #char "A" + 10;
        }

        return byte, true, StringAdvance(str, 2);
    }

    uuid : UUID = ---;
    ok : bool;
    s := str;

    uuid.bytes[0], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }
    uuid.bytes[1], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }
    uuid.bytes[2], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }
    uuid.bytes[3], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }

    if s.count > 0 && s[0] == "-" {
        s = StringAdvance(s, 1);
    }

    uuid.bytes[4], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }
    uuid.bytes[5], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }

    if s.count > 0 && s[0] == "-" {
        s = StringAdvance(s, 1);
    }

    uuid.bytes[6], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }
    uuid.bytes[7], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }

    if s.count > 0 && s[0] == "-" {
        s = StringAdvance(s, 1);
    }

    uuid.bytes[8], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }
    uuid.bytes[9], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }

    if s.count > 0 && s[0] == "-" {
        s = StringAdvance(s, 1);
    }

    uuid.bytes[10], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }
    uuid.bytes[11], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }
    uuid.bytes[12], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }
    uuid.bytes[13], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }
    uuid.bytes[14], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }
    uuid.bytes[15], ok, s = ParseByte(s);
    if !ok {
        return uuid, false, s;
    }

    return uuid, true, s;
}

AppendUUID :: (builder : *StringBuilder, uuid : UUID) {
    prev_format_int := context.print_style.default_format_int;
    context.print_style.default_format_int = FormatIntHex(0, 2);
    defer context.print_style.default_format_int = prev_format_int;

    Append(builder, "%%%%-%%-%%-%%-%%%%%%",
        uuid.bytes[0], uuid.bytes[1], uuid.bytes[2], uuid.bytes[3],
        uuid.bytes[4], uuid.bytes[5],
        uuid.bytes[6], uuid.bytes[7],
        uuid.bytes[8], uuid.bytes[9],
        uuid.bytes[10], uuid.bytes[11], uuid.bytes[12],
        uuid.bytes[13], uuid.bytes[14], uuid.bytes[15]
    );
}

#run {
    builder : StringBuilder;

    for i : 0..100 {
        uuid := RandomUUID();
        AppendUUID(*builder, uuid);

        str := StringBuilderBuild(*builder);

        uuid2, ok, str2 := ParseUUID(str);
        Assert(ok && str2.count == 0, "'%' => '%'", str, str2);
        Assert(uuid == uuid2);
    }
}

Cos :: Math.cos;
Sin :: Math.sin;
Tan :: Math.tan;
Acos :: Math.acos;
Asin :: Math.asin;
Atan :: Math.atan;
Atan2 :: Math.atan2;
Sqrt :: Math.sqrt;
Floor :: Math.floor;
Ceil :: Math.ceil;

Tau :: Math.TAU;
Tau64 :: Math.TAU64;

Pi :: Math.PI;
Pi64 :: Math.PI64;

Pow :: Math.pow;
Log :: Math.log;

Log10 :: inline (x : float) -> float {
    return Log(x) / #run Log(10);
}

Log2 :: inline (x : float) -> float {
    return Log(x) / #run Log(2);
}

F32_Min :: Math.FLOAT32_MIN;
F32_Max :: Math.FLOAT32_MAX;
F32_Inf :: Math.FLOAT32_INFINITY;
F32_NaN :: Math.FLOAT32_NAN;
F64_Min :: Math.FLOAT64_MIN;
F64_Max :: Math.FLOAT64_MAX;
F64_Inf :: Math.FLOAT64_INFINITY;
F64_NaN :: Math.FLOAT64_NAN;
S8_Min :: Math.S8_MIN;
S8_Max :: Math.S8_MAX;
U8_Max :: Math.U8_MAX;
S16_Min :: Math.S16_MIN;
S16_Max :: Math.S16_MAX;
U16_Max :: Math.U16_MAX;
S32_Min :: Math.S32_MIN;
S32_Max :: Math.S32_MAX;
U32_Max :: Math.U32_MAX;
S64_Min :: Math.S64_MIN;
S64_Max :: Math.S64_MAX;
U64_Max :: Math.U64_MAX;

Second_To_Nano :: 1000000000;

Rect :: struct (T : Type) {
    x, y, w, h : T;

    #overlay(x)
    position : Vec2(T) = ---;
    #overlay(w)
    size : Vec2(T) = ---;
}

operator == :: inline (a : $T/Rect, b : Rect) -> bool {
    return a.position == b.position && a.size == b.size;
}

Recti :: Rect(s32);
Rectf :: Rect(float);

ToRads :: inline (angle_in_degrees : float) -> float {
    return angle_in_degrees * Math.PI / 180.0;
} @NoProfile

ToDegs :: inline (angle_in_radians : float) -> float {
    return angle_in_radians * 180.0 / Math.PI;
} @NoProfile

AlignForward :: (x : u64, alignment : u64) -> u64 {
    Assert(alignment > 0, "Invalid alignment: %", alignment);

    return ((x + alignment - 1) / alignment) * alignment;
} @NoProfile

AlignForward :: (x : s64, alignment : s64) -> s64 {
    Assert(alignment > 0, "Invalid alignment: %", alignment);

    return ((x + alignment - 1) / alignment) * alignment;
} @NoProfile

CoreStructPrinter :: (builder : *StringBuilder, any : Any, data : *void) -> bool {
    if any.type == type_info(UUID)
    || (TypeIsStruct(any.type) && cast(*Type_Info_Struct, any.type).name == "UUID") {
        uuid := cast(*UUID, any.value_pointer).*;
        if uuid == Null_UUID {
            Append(builder, "(null UUID)");
        } else {
            AppendUUID(builder, uuid);
        }

        return true;
    }

    type := Devariantize(any.type);
    if type != any.type {
        devariantized := Any.{value_pointer=any.value_pointer, type=type};
        return CoreStructPrinter(builder, devariantized, data);
    }

    return false;
} @NoProfile

ScopeLongFormStructFormat :: () #expand {
    prev := context.print_style.default_format_struct;
    `defer context.print_style.default_format_struct = prev;

    context.print_style.default_format_struct.use_long_form_if_more_than_this_many_members = 0;
    context.print_style.default_format_struct.use_newlines_if_long_form = true;
}

CartesianToSpherical :: (direction : Vec3f) -> azmiuth : float, polar : float {
    polar := Math.asin(direction.y);
    azimuth := Math.acos(direction.z / Math.sqrt(direction.x * direction.x + direction.z * direction.z));
    azimuth *= ifx direction.x < -0.0 then -1.0 else 1.0;

    return azimuth, polar;
}

SphericalToCartesian :: (azimuth : float, polar : float) -> Vec3f {
    cosa := Math.cos(azimuth);
    sina := Math.sin(azimuth);
    cosp := Math.cos(polar);
    sinp := Math.sin(polar);

    return Normalized(Vec3f.{sina * cosp, sinp, cosa * cosp});
}

IsStruct :: (info : *Type_Info, struct_name : string) -> bool {
    if !info {
        return false;
    }
    if info.type != .STRUCT {
        return false;
    }
    return cast(*Type_Info_Struct, info).name == struct_name;
}

Devariantize :: (type : *Type_Info) -> *Type_Info {
    while type.type == .VARIANT {
        type = (cast(*Type_Info_Variant) type).variant_of;
    }

    return type;
}

DecomposeTaggedUnion :: (ptr : *void, type : *Type_Info_Struct) -> tag_value : u64, tag_member : *Type_Info_Struct_Member, active_member : *Type_Info_Struct_Member, active_member_index : s32 {
    Assert(type.members.count > 0, "Empty tagged union");

    tag_member := *type.members[0];
    tag_value : u64;
    if tag_member.type.runtime_size == {
    case 1; tag_value = cast(*u8,  ptr + tag_member.offset_in_bytes).*;
    case 2; tag_value = cast(*u16, ptr + tag_member.offset_in_bytes).*;
    case 4; tag_value = cast(*u32, ptr + tag_member.offset_in_bytes).*;
    case 8; tag_value = cast(*u64, ptr + tag_member.offset_in_bytes).*;
    case;
        Panic("Corrupt union tag member info");
        return 0, null, null, -1;
    }

    active_member_index : s32 = -1;
    for type.tagged_union_bindings {
        if it.constant_value == tag_value {
            active_member_index = it.member_index;
            break;
        }
    }

    active_member := ifx active_member_index >= 0 then *type.members[active_member_index];

    return tag_value, tag_member, active_member, active_member_index;
}
