#import "Parser";

Log_Config :: Log_Section.{name="Config"};

ConfigParser :: Parser(
    Punctuation=.["[", "]", "=", ",", ".", "-"],
    Keywords=.["true", "false"],
    String_Literal_Quotes="\"",
    Single_Line_Comment_Str="#",
    Multi_Line_Comment_Start_Str="",
    Multi_Line_Comment_End_Str="",
);

#import "Lexer";

g_engine_config := ConfigRegistry.{
    filename="engine.toml",
};

GetEngineConfig :: inline () -> *ConfigRegistry {
    return *g_engine_config;
} @Public

RegisterConfigEntry :: (registry : *ConfigRegistry, name : string, entry : Any) -> bool {
    LogSectionScope(*Log_Config);

    if entry.type.type != .STRUCT {
        return false;
    }

    if name.count <= 0 {
        LogError("Config entry name invalid");
        return false;
    }

    if !Basic.is_alpha(name[0]) && name[0] != "_" {
        LogError("Config entry name must be an alpha numeric identifier");
        return false;
    }

    for name {
        if !Basic.is_alnum(it) {
            LogError("Config entry name must be an alpha numeric identifier");
            return false;
        }
    }

    ptr, exists := HashMapInsert(*registry.entries, name);
    if exists {
        if ptr.value_pointer != entry.value_pointer || ptr.type != entry.type {
            LogError("A config with the same name but with a different value pointer or type already exists");
            return false;
        }

        return true;
    }

    ptr.* = entry;
    FillConfigEntry(registry, name, entry);
    WriteConfigToFile(registry);

    return true;
} @Public

UnregisterConfigEntry :: (registry : *ConfigRegistry, name : string) -> bool {
    LogSectionScope(*Log_Config);
    return HashMapRemove(*registry.entries, name);
} @Public

AppendValue :: (builder : *StringBuilder, value : Any, indentation := 0) {
    if value.type.type == {
    case .INTEGER;
        info_int := cast(*Type_Info_Integer, value.type);
        if info_int.signed {
            if info_int.runtime_size == {
            case 1; Append(builder, "%", cast(*s8,  value.value_pointer).*);
            case 2; Append(builder, "%", cast(*s16, value.value_pointer).*);
            case 4; Append(builder, "%", cast(*s32, value.value_pointer).*);
            case 8; Append(builder, "%", cast(*s64, value.value_pointer).*);
            }
        } else {
            if info_int.runtime_size == {
            case 1; Append(builder, "%", cast(*u8,  value.value_pointer).*);
            case 2; Append(builder, "%", cast(*u16, value.value_pointer).*);
            case 4; Append(builder, "%", cast(*u32, value.value_pointer).*);
            case 8; Append(builder, "%", cast(*u64, value.value_pointer).*);
            }
        }

    case .FLOAT;
        if value.type.runtime_size == {
        case 4; Append(builder, "%", cast(*float32, value.value_pointer).*);
        case 8; Append(builder, "%", cast(*float64, value.value_pointer).*);
        }

    case .BOOL;
        Append(builder, "%", cast(*bool, value.value_pointer).*);

    case .STRING;
        StringBuilderAppendStringLiteral(builder, cast(*string, value.value_pointer).*);

    case .ARRAY;
        array_info := cast(*Type_Info_Array, value.type);
        Append(builder, "[");

        for i : 0..array_info.array_count - 1 {
            if array_info.element_type.type == .ARRAY {
                Append(builder, "\n");

                for i : 0..indentation {
                    Append(builder, "    ");
                }
            }

            elem := Any.{
                value_pointer=value.value_pointer + i * array_info.element_type.runtime_size,
                type=array_info.element_type,
            };

            AppendValue(builder, elem, indentation + 1);
            Append(builder, ",");
        }

        if array_info.element_type.type == .ARRAY {
            Append(builder, "\n");

            for i : 0..indentation - 1 {
                Append(builder, "    ");
            }
        }

        Append(builder, "]");
    }
}

AppendConfig :: (builder : *StringBuilder, name : string, value : Any) {
    Appendln(builder, "[%]", name);

    info_struct := cast(*Type_Info_Struct, value.type);
    for info_struct.members {
        if it.type.type != .FLOAT
        && it.type.type != .INTEGER
        && it.type.type != .BOOL
        && it.type.type != .STRING
        && it.type.type != .ARRAY {
            continue;
        }

        Append(builder, "% = ", it.name);
        AppendValue(builder, Any.{value_pointer=value.value_pointer + it.offset_in_bytes, type=it.type});
        Append(builder, "\n");
    }
}

WriteConfigToFile :: (registry : *ConfigRegistry) {
    LogSectionScope(*Log_Config);

    if !registry.filename {
        LogError("Config registry filename is not set");
        return;
    }

    builder : StringBuilder;
    for cfg, name : registry.entries {
        AppendConfig(*builder, name, cfg);
        Append(*builder, "\n");
    }

    str := StringBuilderBuild(*builder);
    write_entire_file(registry.filename, str);
} @Public

ParseConfigValue :: (parser : *ConfigParser) -> bool, ConfigValue {
    if MatchToken(parser, .OpenSquare) {
        values : [..]ConfigValue;

        while !NextTokenIs(parser, .EOF) && !NextTokenIs(parser, .CloseSquare) {
            ok, val := ParseConfigValue(parser);
            if !ok {
                ArrayFree(*values);
                return false, .{};
            }

            ArrayPush(*values, val);

            if !MatchToken(parser, .Comma) {
                if !NextTokenIs(parser, .CloseSquare) {
                    ExpectedError(parser, PrevToken(parser), NextToken(parser), .Comma, .CloseSquare);
                    ArrayFree(*values);
                    return false, .{};
                }
            }
        }

        if !MatchExpect(parser, .CloseSquare) {
            ArrayFree(*values);
            return false, .{};
        }

        return true, .{kind=.Array, values=values};
    }

    if MatchToken(parser, .True) {
        return true, .{kind=.Bool, bool_value=true};
    }

    if MatchToken(parser, .False) {
        return true, .{kind=.Bool, bool_value=false};
    }

    if MatchToken(parser, .StringLiteral) {
        str, ok := ParseStringLiteral(parser, PrevToken(parser));
        return true, .{kind=.String, string_value=str};
    }

    // @Todo: range check
    minus := MatchToken(parser, .Minus);
    if MatchToken(parser, .IntLiteral) {
        val := ParseIntLiteral(parser, PrevToken(parser));
        if minus {
            return true, .{kind=.Int, s64_value=-val};
        } else {
            return true, .{kind=.UInt, u64_value=xx,no_check val};
        }
    }

    if MatchToken(parser, .FloatLiteral) {
        val := ParseFloatLiteral(parser, PrevToken(parser));
        if minus {
            return true, .{kind=.Float, float_value=-cast(float, val)};
        } else {
            return true, .{kind=.Float, float_value=cast(float, val)};
        }
    }

    if minus {
        ExpectedError(parser, PrevToken(parser), NextToken(parser), .IntLiteral, .FloatLiteral);
        return false, .{};
    }

    ExpectedError(parser, PrevToken(parser), NextToken(parser), .OpenSquare, .True, .False, .IntLiteral, .FloatLiteral, .StringLiteral);

    return false, .{};
}

ParseConfigEntry :: (parser : *ConfigParser, registry : *ConfigRegistry) -> bool {
    // Entry header
    if !MatchExpect(parser, .OpenSquare) {
        return false;
    }
    if !MatchExpect(parser, .Identifier) {
        return false;
    }

    entry_name := TokenRangeToString(parser, PrevToken(parser).range);

    while !NextTokenIs(parser, .EOF) && !NextTokenIs(parser, .CloseSquare) {
        if !MatchExpect(parser, .Dot) {
            return false;
        }

        if !MatchExpect(parser, .Identifier) {
            return false;
        }

        entry_name = TPrint("%.%", entry_name, TokenRangeToString(parser, PrevToken(parser).range));
    }

    if !MatchExpect(parser, .CloseSquare) {
        return false;
    }

    // Parse values
    while !NextTokenIs(parser, .EOF) && !NextTokenIs(parser, .OpenSquare) {
        if !MatchExpect(parser, .Identifier) {
            return false;
        }

        identifier := TokenRangeToString(parser, PrevToken(parser).range);
        if !MatchExpect(parser, .Equal) {
            return false;
        }

        ok, value := ParseConfigValue(parser);
        if !ok {
            return false;
        }

        identifier = SPrint("%.%", entry_name, identifier);
        HashMapInsert(*registry.parsed_values, identifier, value);
    }

    return true;
}

ParseConfigFile :: (parser : *ConfigParser, registry : *ConfigRegistry) -> bool {
    while !MatchToken(parser, .EOF) {
        if !ParseConfigEntry(parser, registry) {
            return false;
        }
    }

    return true;
}

LoadConfigFromFile :: (registry : *ConfigRegistry) {
    LogSectionScope(*Log_Config);

    if !registry.filename {
        LogError("Config registry filename is not set");
        return;
    }

    if !file_exists(registry.filename) {
        return;
    }

    contents, ok := read_entire_file(registry.filename);
    if !ok {
        return;
    }

    parser : ConfigParser;
    parser.output_colors = true;
    InitParser(*parser, registry.filename, contents);

    ParseConfigFile(*parser, registry);

    for entry, name : registry.entries {
        FillConfigEntry(registry, name, entry);
    }
} @Public

FillConfigValue :: (value : ConfigValue, name : string, type : *Type_Info, ptr : *void) {
    if type.type == {
    case .INTEGER;
        if value.kind != .Int && value.kind != .UInt {
            LogError("%: config value type mismatch, expected Int or UInt, got %", name, value.kind);
            return;
        }

        val := ifx value.kind == .Int then value.s64_value else xx value.u64_value;
        int_info := cast(*Type_Info_Integer, type);
        if int_info.signed {
            if int_info.runtime_size == {
            case 1; cast(*s8,  ptr).* = xx,no_check val;
            case 2; cast(*s16, ptr).* = xx,no_check val;
            case 4; cast(*s32, ptr).* = xx,no_check val;
            case 8; cast(*s64, ptr).* = xx,no_check val;
            }
        } else {
            if int_info.runtime_size == {
            case 1; cast(*u8,  ptr).* = xx,no_check val;
            case 2; cast(*u16, ptr).* = xx,no_check val;
            case 4; cast(*u32, ptr).* = xx,no_check val;
            case 8; cast(*u64, ptr).* = xx,no_check val;
            }
        }

    case .FLOAT;
        if value.kind != .Float && value.kind != .Int && value.kind != .UInt {
            LogError("%: config value type mismatch, expected Float, Int or UInt, got %", name, value.kind);
            return;
        }

        val := ifx value.kind == .Int then cast(float, value.s64_value) else ifx value.kind == .UInt then cast(float, value.u64_value) else value.float_value;
        if type.runtime_size == 4 {
            cast(*float32, ptr).* = val;
        } else if type.runtime_size == 8 {
            cast(*float64, ptr).* = val;
        }

    case .BOOL;
        if value.kind != .Bool {
            LogError("%: config value type mismatch, expected Bool, got %", name, value.kind);
            return;
        }

        cast(*bool, ptr).* = value.bool_value;

    case .STRING;
        if value.kind != .String {
            LogError("%: config value type mismatch, expected String, got %", name, value.kind);
            return;
        }

        Free(cast(*string, ptr).data);
        cast(*string, ptr).* = StringClone(value.string_value);

    case .ENUM;
        if value.kind != .String {
            LogError("%: config value type mismatch, expected String, got %", name, value.kind);
            return;
        }

        enum_info := cast(*Type_Info_Enum, type);
        for enum_info.names {
            if it == value.string_value {
                if enum_info.runtime_size == {
                case 1; cast(*u8,  ptr).* = xx,no_check enum_info.values[it_index];
                case 2; cast(*u16, ptr).* = xx,no_check enum_info.values[it_index];
                case 4; cast(*u32, ptr).* = xx,no_check enum_info.values[it_index];
                case 8; cast(*u64, ptr).* = xx,no_check enum_info.values[it_index];
                }

                break;
            }
        }

    case .ARRAY;
        array_info := cast(*Type_Info_Array, type);
        if array_info.array_count <= 0 {
            LogError("%: only fix sized arrays are supported", name);
            return;
        }

        if value.kind != .Array {
            LogError("%: config value type mismatch, expected Array, got %", name, value.kind);
            return;
        }

        if value.values.count != array_info.array_count {
            LogError("%: number of elements in the array mismatch", name);
        }

        for i : 0..Min(value.values.count, array_info.array_count) - 1 {
            FillConfigValue(value.values[i], TPrint("%[%]", name, i), array_info.element_type, ptr + i * array_info.element_type.runtime_size);
        }

    case;
        LogError("%: unhandled type %", name, cast(*Type, *type).*);
    }
}

FillConfigEntry :: (registry : *ConfigRegistry, name : string, entry : Any) {
    Assert(entry.type.type == .STRUCT);

    type := cast(*Type_Info_Struct, entry.type);
    for type.members {
        member_name := TPrint("%.%", name, it.name);

        val := HashMapGetPtr(*registry.parsed_values, member_name);
        if !val {
            continue;
        }

        FillConfigValue(val, member_name, it.type, entry.value_pointer + it.offset_in_bytes);
    }
}
