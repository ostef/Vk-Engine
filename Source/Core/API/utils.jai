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
    if any.type == type_info(GUID)
    || (TypeIsStruct(any.type) && cast(*Type_Info_Struct, any.type).name == "GUID") {
        guid := cast(*GUID, any.value_pointer);
        if guid.* == .{} {
            Append(builder, "(null entity)");
        } else {
            Append(builder, "%1%2", FormatIntHex(guid.high), FormatIntHex(guid.low));
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
