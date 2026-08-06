Detect_Infinite_Type_Recursion :: true; // @PossibleOptimization
Panic_On_Infinite_Type_Recursion :: false; // @PossibleOptimization

Serialize_Indent_String :: "  ";

IsVec2f :: inline (type : *Type_Info) -> bool {
    is_vector, data_type, dim := GetVectorTypeInfoByName(type);
    return is_vector && dim == 2 && data_type != null && data_type.type == .FLOAT && data_type.runtime_size == size_of(float);
}

IsVec3f :: inline (type : *Type_Info) -> bool {
    is_vector, data_type, dim := GetVectorTypeInfoByName(type);
    return is_vector && dim == 3 && data_type != null && data_type.type == .FLOAT && data_type.runtime_size == size_of(float);
}

IsVec4f :: inline (type : *Type_Info) -> bool {
    is_vector, data_type, dim := GetVectorTypeInfoByName(type);
    return is_vector && dim == 4 && data_type != null && data_type.type == .FLOAT && data_type.runtime_size == size_of(float);
}

IsQuatf :: inline (type : *Type_Info) -> bool {
    is_vector, data_type := GetQuaternionTypeInfoByName(type);
    return is_vector && data_type != null && data_type.type == .FLOAT && data_type.runtime_size == size_of(float);
}

IsTypeSerializable :: (type : *Type_Info, dependency_stack : *[..]*Type_Info = null) -> bool {
    type = Devariantize(type);

    if IsVec2f(type)
    || IsVec3f(type)
    || IsVec4f(type)
    || IsQuatf(type) {
        return true;
    }

    if IsStruct(type, "Vector2")
    || IsStruct(type, "Vector3")
    || IsStruct(type, "Vector4")
    || IsStruct(type, "Quaternion") {
        return true;
    }

    if IsStruct(type, "UUID") {
        return true;
    }

    if type.runtime_size <= 0 {
        return false;
    }

    #if Detect_Infinite_Type_Recursion {
        local_dependency_stack : [..]*Type_Info;
        local_dependency_stack.allocator = Temp;
        if !dependency_stack {
            dependency_stack = *local_dependency_stack;
        }

        if type.type == .STRUCT {
            for dependency_stack.* {
                if it == type {
                    builder : StringBuilder;
                    for dependency_stack.* {
                        if it_index != 0 {
                            Append(*builder, " <- ");
                        }
                        Append(*builder, "%", (cast(*Type) *it).*);
                    }

                    Msg :: "Called IsTypeSerializable for type % that points to itself. This will cause an infinite recursion. Dependency stack: %";

                    #if Panic_On_Infinite_Type_Recursion {
                        Panic(Msg, (cast(*Type) *type).*, StringBuilderBuild(*builder));
                    } else {
                        LogError(Msg, (cast(*Type) *type).*, StringBuilderBuild(*builder));
                    }

                    return false;
                }
            }

            ArrayPush(dependency_stack, type);
        }

        defer if type.type == .STRUCT {
            ArrayPop(dependency_stack);
        }
    }

    if type.type == {
    case .PROCEDURE; #through;
    // Technically a Type is serializable, but it isn't really deserializable
    case .TYPE; #through;
    case .VOID; #through;
    case .ANY;
        return false;

    case .ARRAY;
        return IsTypeSerializable((cast(*Type_Info_Array) type).element_type, dependency_stack);

    case .POINTER;
        return IsTypeSerializable((cast(*Type_Info_Pointer) type).pointer_to, dependency_stack);

    case .STRUCT;
        struct_info := cast(*Type_Info_Struct) type;
        if struct_info.textual_flags & .UNION {
            return false;
        }

        for struct_info.members {
            if !(it.flags & .CONSTANT) && GetSerializeFieldId(it.notes) > 0 && IsTypeSerializable(it.type, dependency_stack) {
                return true;
            }
        }

        return false;
    }

    return true;
}

IsTypeSerializeSingleLine :: (type : *Type_Info) -> bool {
    type = Devariantize(type);

    if IsVec2f(type)
    || IsVec3f(type)
    || IsVec4f(type)
    || IsQuatf(type) {
        return true;
    }

    if IsStruct(type, "Vector2")
    || IsStruct(type, "Vector3")
    || IsStruct(type, "Vector4")
    || IsStruct(type, "Quaternion") {
        return true;
    }

    if IsStruct(type, "UUID") {
        return true;
    }

    if type.type == {
    case .STRING; #through;
    case .INTEGER; #through;
    case .FLOAT; #through;
    case .BOOL; #through;
    case .TYPE; #through;
    case .ENUM;
        return true;

    case .POINTER;
        pointer_to := cast(*Type_Info_Pointer, type).pointer_to;
        if pointer_to.type == .STRUCT && IsStruct(TypeGetSourcePolymorph(xx pointer_to), "Asset") {
            return true;
        }

        return IsTypeSerializeSingleLine(pointer_to);
    }

    return false;
}

WalkPointer :: (val : *void, type : *Type_Info_Pointer) -> final_pointer : *void, final_type : *Type_Info {
    while Devariantize(type).type == .POINTER && val {
        type = xx type.pointer_to;
        val = (cast(**void) val).*;
    }

    return val, type;
}

GetArrayCountAndData :: (ptr : *void, array_info : *Type_Info_Array) -> int, *void {
    count : int;
    array_data : *void;
    if #complete array_info.array_type == {
    case .FIXED;
        count = array_info.array_count;
        array_data = ptr;

    case .RESIZABLE; #through;
    case .VIEW;
        count = (cast(*Array_View_64) ptr).count;
        array_data = (cast(*Array_View_64) ptr).data;
    }

    return count, array_data;
}

Indent :: (serializer : *Serializer) #expand {
    serializer.indent_level += 1;
    `defer serializer.indent_level -= 1;
}

GetSerializeFieldId :: (notes : []string) -> int {
    for note : notes {
        if StringStartsWith(note, "Serialize(") {
            version := StringAdvance(note, "Serialize(".count);
            value, ok, remainder := Basic.string_to_int(version);
            if ok && remainder == ")" {
                if value <= 0 {
                    LogError("Serialize note: invalid field id %", value);
                    return -1;
                } else {
                    return value;
                }
            } else {
                LogError("Error when parsing note Serialize: %", note);

                return -1;
            }
        }
    }

    return -1;
}

SerializeAny :: (serializer : *Serializer, value : Any) {
    ptr := value.value_pointer;
    type := Devariantize(value.type);

    if !IsTypeSerializable(type) {
        return;
    }

    if IsStruct(type, "UUID") {
        uuid := cast(*UUID, ptr);
        AppendUUID(serializer, uuid);

        return;
    }

    if IsVec2f(type)
    || IsVec3f(type)
    || IsVec4f(type)
    || IsQuatf(type)
    || IsStruct(type, "Vector2")
    || IsStruct(type, "Vector3")
    || IsStruct(type, "Vector4")
    || IsStruct(type, "Quaternion") {
        component_count := type.runtime_size / size_of(float);

        Append(serializer, "[");

        for i : 0..component_count - 1 {
            if i != 0 {
                Append(serializer, ", ");
            }

            Append(serializer, "%", cast(*float, ptr)[i]);
        }

        Append(serializer, "]");

        return;
    }

    if #complete type.type == {
    case .STRING;
        // @Todo: print UTF32 characters as \Uxxxxxxxx
        StringBuilderAppendStringLiteral(serializer, cast(*string, ptr).*);

    case .FLOAT;
        Append(serializer, "%", value);

    case .INTEGER; #through;
    case .BOOL;
        StringBuilderAppendAny(serializer, value);

    case .ENUM;
        enum_info := cast(*Type_Info_Enum, type);
        int_value := Basic.get_s64_from_void_pointer(ptr, enum_info.runtime_size);

        if enum_info.enum_type_flags & .FLAGS {
            StringBuilderAppend(serializer, "0x%", FormatIntHex(cast,no_check(u64, int_value), 1));
        } else {
            for enum_info.values {
                if it == int_value {
                    StringBuilderAppend(serializer, enum_info.names[it_index]);
                    return;
                }
            }

            StringBuilderAppend(serializer, "%", int_value);
        }

    case .STRUCT;
        struct_info := cast(*Type_Info_Struct, type);
        if struct_info.textual_flags & .UNION {
            LogError("Cannot serialize unions");
            return;
        }

        highest_byte_offset := -1;
        num_serialized_members := 0;

        for struct_info.members {
            if it.flags & .CONSTANT {
                continue;
            }

            if it.offset_in_bytes <= highest_byte_offset || it.type.runtime_size == 0 {
                continue;
            }

            if !IsTypeSerializable(it.type) {
                continue;
            }

            field_id := GetSerializeFieldId(it.notes);
            if field_id <= 0 {
                continue;
            }

            member_type := Devariantize(it.type);
            member_value := Any.{value_pointer=ptr + it.offset_in_bytes, type=member_type};

            // Only serialize pointers if they point to something
            if member_type.type == .POINTER && !WalkPointer(member_value.value_pointer, xx member_type) {
                highest_byte_offset = it.offset_in_bytes;
                continue;
            }

            defer {
                highest_byte_offset = it.offset_in_bytes;
                num_serialized_members += 1;
            }

            if num_serialized_members > 0 {
                for 1..serializer.indent_level
                    Append(serializer, Serialize_Indent_String);
            }

            if it.name {
                Append(serializer, "@% ", it.name);
            }

            Append(serializer, "%:", field_id);

            single_line := IsTypeSerializeSingleLine(member_type);

            empty_array := member_type.type == .ARRAY
                && GetArrayCountAndData(member_value.value_pointer, xx member_type) == 0;

            if single_line {
                Append(serializer, " ");
            } else if !empty_array {
                Append(serializer, "\n");
                for 1..serializer.indent_level + 1 {
                    Append(serializer, Serialize_Indent_String);
                }
            }

            Indent(serializer);
            SerializeAny(serializer, member_value);

            if single_line || empty_array {
                Append(serializer, "\n");
            }
        }

    case .ARRAY;
        array_info := cast(*Type_Info_Array, type);
        elem_type := Devariantize(array_info.element_type);

        if !IsTypeSerializable(elem_type) {
            LogError("Cannot serialize type %", cast(*Type, *elem_type).*);
            return;
        }

        array_type := array_info.array_type;
        count, array_data := GetArrayCountAndData(ptr, array_info);

        num_serialized_elems := 0;

        elem_single_line := IsTypeSerializeSingleLine(elem_type);
        for i : 0..count - 1 {
            defer num_serialized_elems += 1;

            if num_serialized_elems != 0 {
                for 1..serializer.indent_level {
                    Append(serializer, Serialize_Indent_String);
                }
            }

            Append(serializer, "* ");

            elem_ptr := array_data + elem_type.runtime_size * i;
            elem := Any.{value_pointer=elem_ptr, type=elem_type};

            Indent(serializer);
            SerializeAny(serializer, elem);

            if elem_single_line {
                Append(serializer, "\n");
            }
        }

    case .POINTER;
        pointer_to := cast(*Type_Info_Pointer, type).pointer_to;
        if pointer_to.type == .STRUCT && IsStruct(TypeGetSourcePolymorph(xx pointer_to), "Asset") {
            asset := cast(*AssetCommonData, WalkPointer(ptr, xx type));
            StringBuilderAppendStringLiteral(serializer, ifx asset then asset.asset_name else "");

            return;
        }

        final_pointer, final_type := WalkPointer(ptr, xx type);
        if !final_pointer {
            return;
        }

        item : Any;
        item.type = final_type;
        item.value_pointer = final_pointer;
        SerializeAny(serializer, item);

    case .VOID;
    case .VARIANT;
        Panic("Type should have been devariantized by now");
    case .ANY;
        LogError("Cannot serialize an any");
    case .PROCEDURE;
        LogError("Cannot serialize procedures");
    case .OVERLOAD_SET;
        LogError("Cannot serialize overload set");
    case .POLYMORPHIC_VARIABLE;
        LogError("Cannot serialize polymorphic variable");
    case .CODE;
        LogError("Cannot serialize code");
    case .TYPE;
        LogError("Cannot serialize type");
    case .UNTYPED_ENUM;
        LogError("Cannot serialize untyped enum");
    case .UNTYPED_LITERAL;
        LogError("Cannot serialize untyped literal");
    }
} @Public

InitParser :: (using parser : *DeserializeParser, contents : string) {
    lines_dynamic := StringSplit(contents, #char "\n");
    for * lines_dynamic {
        it.* = trim_right(it.*);
        no_indent := trim_left(it.*);
        if it.count == 0 || no_indent[0] == #char "#" {
            ArrayOrderedRemove(*lines_dynamic, it_index);
        }
    }

    lines = lines_dynamic;
    line_index = 0;
    byte_index = 0;
    indent_level = 0;

    UpdateIndentation(parser);
} @Public

CountIndentation :: (line : string) -> indent_level : int, byte_index : int {
    i := 0;
    indent_level := 0;
    while StringStartsWith(StringAdvance(line, i), Serialize_Indent_String) {
        i += Serialize_Indent_String.count;
        indent_level += 1;
    }

    return indent_level, i;
}

UpdateIndentation :: (using parser : *DeserializeParser) {
    if line_index >= lines.count {
        indent_level = 0;
        return;
    }

    indent_level=, i := CountIndentation(lines[line_index]);
    byte_index += i;
} @Public

TrimSpaces :: (line : string) -> int {
    i := 0;
    while i < line.count && Basic.is_space(line[i]) {
        i += 1;
    }

    return i;
}

TrimSpaces :: (using parser : *DeserializeParser) {
    line := lines[line_index];
    while byte_index < line.count && Basic.is_space(line[byte_index]) {
        byte_index += 1;
    }
} @Public

AdvanceToNextLine :: (using parser : *DeserializeParser) {
    line_index += 1;
    byte_index = 0;

    UpdateIndentation(parser);
} @Public

ParseInteger :: (str : string, $T : Type) -> T, ok : bool, remainder : string, base : int {
    _str := str;
    base := 10;
    if StringStartsWith(_str, "0x") {
        _str = StringAdvance(_str, 2);
        base = 16;
    } else if StringStartsWith(_str, "0b") {
        _str = StringAdvance(_str, 2);
        base = 2;
    }

    int_value, ok, remainder := Basic.string_to_int(_str, base, T);

    return int_value, ok, remainder, base;
}

ParseFloat :: (str : string, $T := float) -> T, ok : bool, remainder : string {
    _str := str;

    token := parse_token(*_str);
    if token == "Inf" || token == "+Inf" {
        return F32_Inf, true, _str;
    } else if token == "-Inf" {
        return -F32_Inf, true, _str;
    } else if token == "NaN" || token == "+NaN" {
        return F32_NaN, true, _str;
    } else if token == "-NaN" {
        return -F32_NaN, true, _str;
    }

    #if T == float {
        value, ok, remainder := Basic.string_to_float(str);
    } else #if T == float64 {
        value, ok, remainder := Basic.string_to_float64(str);
    }

    return value, ok, remainder;
}

DeserializeAny :: inline (str : string, value : Any) -> DeserializeResult {
    parser : DeserializeParser;
    InitParser(*parser, str ,, Temp);

    return DeserializeAny(*parser, value);
} @Public

DeserializeAny :: (using parser : *DeserializeParser, value : Any) -> DeserializeResult {
    ptr := value.value_pointer;
    type := Devariantize(value.type);

    // Special case for *Asset types, we want to get the asset name and load the asset
    if type.type == .POINTER {
        pointer_to := (cast(*Type_Info_Pointer) type).pointer_to;
        if pointer_to.type == .STRUCT && IsStruct(TypeGetSourcePolymorph(xx pointer_to), "Asset") {
            asset_name : string;
            result := DeserializeAny(parser, asset_name ,, Temp);
            if !result.ok {
                return result;
            }

            asset_type_info := GetAssetType(xx pointer_to);
            if asset_type_info == null {
                LogError("Could not get asset type (%)", cast(*Type, *pointer_to).*);
            }
            asset_type := cast(*Type, *asset_type_info).*;
            asset := LoadAssetDynamic((cast(*Type) *asset_type).*, asset_name);
            RemoveRefDynamic(asset_type, (cast(**void) value.value_pointer).*);
            (cast(**void) value.value_pointer).* = asset;

            return DeserializeOk(parser);
        }
    }

    if IsStruct(type, "UUID") {
        if line_index >= lines.count {
            return DeserializeError(parser, "Expected a UUID but got EOF");
        }

        TrimSpaces(parser);

        line := StringAdvance(lines[line_index], byte_index);

        uuid, ok, remaining := ParseUUID(line);
        if !ok {
            return DeserializeError(parser, "Expected a UUID");
        }

        cast(*UUID, ptr).* = uuid;

        byte_index += cast(int, remaining.data - line.data);
        line = remaining;

        return DeserializeOk(parser);
    }

    if IsVec2f(type)
    || IsVec3f(type)
    || IsVec4f(type)
    || IsQuatf(type)
    || IsStruct(type, "Vector2")
    || IsStruct(type, "Vector3")
    || IsStruct(type, "Vector4")
    || IsStruct(type, "Quaternion") {
        component_count := type.runtime_size / size_of(float);

        if line_index >= lines.count {
            return DeserializeError(parser, "Expected a % component vector but got EOF", component_count);
        }

        TrimSpaces(parser);

        line := StringAdvance(lines[line_index], byte_index);
        if line.count <= 0 || line[0] != #char "[" {
            return DeserializeError(parser, "Expected [ for % component vector", component_count);
        }

        byte_index += 1;

        for i : 0..component_count - 1 {
            component := Any.{
                type=type_info(float),
                value_pointer=ptr + i * size_of(float),
            };

            result := DeserializeAny(parser, component);
            if !result.ok {
                return result;
            }

            TrimSpaces(parser);

            line = StringAdvance(lines[line_index], byte_index);

            if i < component_count - 1 && (line.count <= 0 || line[0] != #char ",") {
                return DeserializeError(parser, "Expected , after vector float component % (vector has % components)", i + 1, component_count);
            }

            if line[0] == #char "," {
                byte_index += 1;
            }
        }

        TrimSpaces(parser);

        line = StringAdvance(lines[line_index], byte_index);
        if line.count <= 0 || line[0] != #char "]" {
            return DeserializeError(parser, "Expected ] when deserializing % component vector", component_count);
        }

        return DeserializeOk(parser);
    }

    if #complete type.type == {
    case .STRING;
        if line_index >= lines.count {
            return DeserializeError(parser, "Expected a string literal but got EOF");
        }

        TrimSpaces(parser);

        line := StringAdvance(lines[line_index], byte_index);
        if line.count < 2 || line[0] != #char "\"" {
            return DeserializeError(parser, "Expected a string literal");
        }

        result : [..]u8;
        ArrayReserve(*result, line.count - 2);

        i := 1;
        while i < line.count {
            defer i += 1;

            if line[i] == #char "\"" {
                i += 1;
                byte_index += i;

                (cast(*string) ptr).* = xx result;

                return DeserializeOk(parser);
            }

            if line[i] == #char "\\" {
                i += 1;

                if i == line.count {
                    break;
                }

                if line[i] == {
                case #char "\""; ArrayPush(*result, #char "\"");
                case #char "\\"; ArrayPush(*result, #char "\\");
                case #char "t"; ArrayPush(*result, #char "\t");
                case #char "r"; ArrayPush(*result, #char "\r");
                case #char "n"; ArrayPush(*result, #char "\n");
                case;
                    ArrayFree(*result);
                    return DeserializeError(parser, "Invalid escape sequence in string literal");
                }
            } else {
                ArrayPush(*result, line[i]);
            }
        }

        ArrayFree(*result);

        return DeserializeError(parser, "Unclosed string literal");

    case .INTEGER;
        if line_index >= lines.count {
            return DeserializeError(parser, "Expected an integer but got EOF");
        }

        TrimSpaces(parser);

        line := StringAdvance(lines[line_index], byte_index);
        int_info := cast(*Type_Info_Integer) type;
        remainder : string;
        if int_info.signed {
            ok : bool;
            if int_info.runtime_size == {
            case 1;
                value:, ok, remainder = Basic.string_to_int(line, T=s8);
                (cast(*s8) ptr).* = value;
            case 2;
                value:, ok, remainder = Basic.string_to_int(line, T=s16);
                (cast(*s16) ptr).* = value;
            case 4;
                value:, ok, remainder = Basic.string_to_int(line, T=s32);
                (cast(*s32) ptr).* = value;
            case 8;
                value:, ok, remainder = Basic.string_to_int(line, T=s64);
                (cast(*s64) ptr).* = value;
            }

            if !ok {
                return DeserializeError(parser, "Expected an integer");
            }
        } else {
            ok : bool;
            if int_info.runtime_size == {
            case 1;
                value:, ok, remainder = Basic.string_to_int(line, T=u8);
                (cast(*u8) ptr).* = value;
            case 2;
                value:, ok, remainder = Basic.string_to_int(line, T=u16);
                (cast(*u16) ptr).* = value;
            case 4;
                value:, ok, remainder = Basic.string_to_int(line, T=u32);
                (cast(*u32) ptr).* = value;
            case 8;
                value:, ok, remainder = Basic.string_to_int(line, T=u64);
                (cast(*u64) ptr).* = value;
            }

            if !ok {
                return DeserializeError(parser, "Expected an unsigned integer");
            }
        }

        byte_index = xx (remainder.data - line.data);

        return DeserializeOk(parser);

    case .FLOAT;
        if line_index >= lines.count {
            return DeserializeError(parser, "Expected a floating point number but got EOF");
        }

        TrimSpaces(parser);

        line := StringAdvance(lines[line_index], byte_index);
        value, ok, remainder := ParseFloat(line);
        if type.runtime_size == 4 {
            (cast(*float) ptr).* = value;
        } else {
            (cast(*float64) ptr).* = value;
        }

        if !ok {
            return DeserializeError(parser, "Expected a floating point number");
        }

        byte_index += remainder.data - line.data;

        return DeserializeOk(parser);

    case .BOOL;
        if line_index >= lines.count {
            return DeserializeError(parser, "Expected a boolean value but got EOF");
        }

        TrimSpaces(parser);

        line := StringAdvance(lines[line_index], byte_index);
        token, ok := parse_token(*line);
        if token == "true" || token == "True" {
            (cast(*bool) ptr).* = true;
            byte_index += "true".count;
        } else if token == "false" || token == "False" {
            (cast(*bool) ptr).* = false;
            byte_index += "false".count;
        } else {
            return DeserializeError(parser, "Expected a boolean value");
        }

        return DeserializeOk(parser);

    case .ENUM;
        if line_index >= lines.count {
            return DeserializeError(parser, "Expected an enum value of type % but got EOF", (cast(*Type) *type).*);
        }

        TrimSpaces(parser);

        int_value := 0;
        defer {
            if type.runtime_size == {
            case 1;
                (cast(*u8) ptr).* = xx,no_check int_value;
            case 2;
                (cast(*u16) ptr).* = xx,no_check int_value;
            case 4;
                (cast(*u32) ptr).* = xx,no_check int_value;
            case 8;
                (cast(*u64) ptr).* = xx,no_check int_value;
            }
        }

        enum_info := cast(*Type_Info_Enum) type;
        line := StringAdvance(lines[line_index], byte_index);

        int_value=, ok, remainder := ParseInteger(line, s64);
        if ok {
            byte_index += remainder.data - line.data;
            return DeserializeOk(parser);
        } else if enum_info.enum_type_flags & .FLAGS {
            return DeserializeError(parser, "Expected an integer value for enum flags type %", (cast(*Type) *type).*);
        }

        token:, ok = parse_token(*line);
        if !ok {
            return DeserializeError(parser, "Expected an enum value of type %", (cast(*Type) *type).*);
        }

        for enum_info.names {
            if it == token {
                int_value = enum_info.values[it_index];
                byte_index += token.data - line.data;
                byte_index += token.count;

                return DeserializeOk(parser);
            }
        }

        return DeserializeError(parser, "Expected an enum value of type %", (cast(*Type) *type).*);

    case .STRUCT;
        if line_index >= lines.count {
            return DeserializeError(parser, "Expected a struct of type % but got EOF", (cast(*Type) *type).*);
        }

        struct_info := cast(*Type_Info_Struct) type;
        if struct_info.textual_flags & .UNION {
            return DeserializeError(parser, "Cannot deserialize unions");
        }

        TrimSpaces(parser);

        original_indent_level := indent_level;

        while line_index < lines.count && indent_level >= original_indent_level {
            line := StringAdvance(lines[line_index], byte_index);
            if line.count == 0 {
                return DeserializeError(parser, "Expected field id or name annotation");
            }

            if line[0] == #char "@" {
                i := 1;
                while i < line.count && Basic.is_alnum(line[i]) {
                    i += 1;
                }

                if i == 1 {
                    return DeserializeError(parser, "Expected an identifier after @");
                }

                if i == line.count || line[i] != #char " " {
                    return DeserializeError(parser, "Expected a space after name annotation");
                }

                byte_index += i;
                line = StringAdvance(line, i);
            }

            field_id, ok, remainder := Basic.string_to_int(line, T=u32);
            if !ok {
                return DeserializeError(parser, "Expected field id");
            }

            byte_index += cast(int, remainder.data - line.data);
            line = remainder;

            if line.count == 0 || line[0] != #char ":" {
                return DeserializeError(parser, "Expected a colon after identifier");
            }

            byte_index += 1;

            member : *Type_Info_Struct_Member;
            for * struct_info.members {
                member_field_id := GetSerializeFieldId(it.notes);
                if member_field_id == field_id {
                    member = it;
                    break;
                }
            }

            if !member {
                AdvanceToNextLine(parser);

                while line_index < lines.count && indent_level > original_indent_level {
                    AdvanceToNextLine(parser);
                }

                continue;
            }

            member_offset := member.offset_in_bytes;

            single_line := IsTypeSerializeSingleLine(member.type);
            if !single_line {
                AdvanceToNextLine(parser);

                if indent_level <= original_indent_level {
                    continue;
                }
            }

            res := DeserializeAny(parser, Any.{value_pointer=ptr + member_offset, type=member.type});

            if !res.ok {
                return res;
            }

            if single_line {
                AdvanceToNextLine(parser);
            }

            while line_index < lines.count && indent_level > original_indent_level {
                AdvanceToNextLine(parser);
            }
        }

        return DeserializeOk(parser);

    case .ARRAY;
        array_info := cast(*Type_Info_Array) type;
        array_type := array_info.array_type;
        elem_type := Devariantize(array_info.element_type);

        if line_index >= lines.count {
            return DeserializeError(parser, "Expected an array of % but got EOF", (cast(*Type) *elem_type).*);
        }

        TrimSpaces(parser);

        original_indent_level := indent_level;

        // Count the number of lines with the same indentation
        count := 0;
        count_line_index := 0;
        while line_index + count_line_index < lines.count {
            defer count_line_index += 1;

            line := lines[line_index + count_line_index];
            indent_level: = CountIndentation(line);
            if indent_level > original_indent_level {
                continue;
            }

            if indent_level < original_indent_level {
                break;
            }

            count += 1;
        }

        array_data : *void;
        if #complete array_type == {
        case .FIXED;
            if array_info.array_count != count {
                return DeserializeError(parser, "Mismatching number of array elements (expected % but got %)",
                    array_info.array_count, count);
            }

            array_data = ptr;

        case .VIEW;
            array_data = Alloc(elem_type.runtime_size * count);
            cast(*Array_View_64, ptr).count = count;
            cast(*Array_View_64, ptr).data = array_data;

        case .RESIZABLE;
            allocator := cast(*Resizable_Array, ptr).allocator;
            if !allocator.proc {
                allocator = context.allocator;
            }

            array_data = Alloc(elem_type.runtime_size * count ,, allocator);
            cast(*Resizable_Array, ptr).count = count;
            cast(*Resizable_Array, ptr).data = array_data;
            cast(*Resizable_Array, ptr).allocated = count;
            cast(*Resizable_Array, ptr).allocator = allocator;
        }

        single_line := IsTypeSerializeSingleLine(elem_type);
        line := StringAdvance(lines[line_index], byte_index);
        array_index := 0;
        initializer := ifx elem_type.type == .STRUCT then cast(*Type_Info_Struct, elem_type).initializer;
        while line_index < lines.count && indent_level >= original_indent_level {
            line = StringAdvance(lines[line_index], byte_index);
            if line.count == 0 || line[0] != #char "*" {
                return DeserializeError(parser, "Expected an array element");
            }

            byte_index += 1;

            // Artificially increment the indent level because struct elements will be
            // indented but the first member will be on the same line as the *
            indent_level += 1;

            elem := Any.{
                type=elem_type,
                value_pointer=array_data + array_index * elem_type.runtime_size,
            };

            if initializer {
                initializer(elem.value_pointer);
            }

            result := DeserializeAny(parser, elem);

            if !result.ok {
                return result;
            }

            array_index += 1;

            if single_line {
                AdvanceToNextLine(parser);
            }

            while line_index < lines.count && indent_level > original_indent_level {
                AdvanceToNextLine(parser);
            }
        }

        Assert(array_index == count);

        return DeserializeOk(parser);

    case .POINTER;
        ptr, type = WalkPointer(ptr, xx type);
        if !ptr {
            return DeserializeWarning(parser, "Deserializing pointer but it is null");
        }

        item : Any;
        item.type = type;
        item.value_pointer = ptr;

        return DeserializeAny(parser, item);

    case .VOID;
    case .VARIANT;
        Panic("Type should have been devariantized by now");
    case .ANY;
        return DeserializeError(parser, "Cannot deserialize any");
    case .PROCEDURE;
        return DeserializeError(parser, "Cannot deserialize procedures");
    case .OVERLOAD_SET;
        return DeserializeError(parser, "Cannot deserialize overload set");
    case .POLYMORPHIC_VARIABLE;
        return DeserializeError(parser, "Cannot deserialize polymorphic variable");
    case .CODE;
        return DeserializeError(parser, "Cannot deserialize code");
    case .TYPE;
        return DeserializeError(parser, "Cannot deserialize type");
    case .UNTYPED_ENUM;
        return DeserializeError(parser, "Cannot deserialize untyped enum");
    case .UNTYPED_LITERAL;
        return DeserializeError(parser, "Cannot deserialize untyped literal");
    }

    Panic("Unreachable");
    return DeserializeError(parser, "Unreachable");
} @Public
