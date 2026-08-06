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

GetValue :: (registry : *ConfigRegistry, name : string, $T : Type) -> T, exists : bool {
    default : T;

    value := HashMapGetPtr(*registry.parsed_values, name);
    if !value {
        return default, false;
    }

    #if T == {
    case s64;
        if value.kind == .Int {
            return value.s64_value, true;
        }
        if value.kind == .UInt {
            return xx value.u64_value, true;
        }
        return default, false;

    case u64;
        if value.kind == .Int {
            if value.s64_value < 0 {
                return default, false;
            }
            return xx value.s64_value, true;
        }
        if value.kind == .UInt {
            return value.u64_value, true;
        }
        return default, false;

    case float;
        if value.kind == .Float {
            return value.float_value, true;
        }
        return default, false;
    case bool;
        if value.kind == .Bool {
            return value.bool_value, true;
        }
        return default, false;
    case string;
        if value.kind == .String {
            return value.string_value, true;
        }
        return default, false;
    case;
        #assert false;
    }
}

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

AppendValue :: (builder : *StringBuilder, value : Any) {
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
    }
}

AppendConfig :: (builder : *StringBuilder, name : string, value : Any) {
    Appendln(builder, "[%]", name);

    info_struct := cast(*Type_Info_Struct, value.type);
    for info_struct.members {
        if it.type.type != .FLOAT
        && it.type.type != .INTEGER
        && it.type.type != .BOOL
        && it.type.type != .STRING {
            continue;
        }

        Append(builder, "% = ", it.name);
        AppendValue(builder, Any.{value_pointer=value.value_pointer + it.offset_in_bytes, type=it.type});
        Append(builder, "\n");
    }
}

WriteConfigToFile :: (registry : *ConfigRegistry) {
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

    ExpectedError(parser, PrevToken(parser), NextToken(parser), .True, .False, .IntLiteral, .FloatLiteral, .StringLiteral);

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

FillConfigEntry :: (registry : *ConfigRegistry, name : string, entry : Any) {
    Assert(entry.type.type == .STRUCT);

    type := cast(*Type_Info_Struct, entry.type);
    for type.members {
        ptr := entry.value_pointer + it.offset_in_bytes;

        if it.type.type == {
        case .INTEGER;
            int_info := cast(*Type_Info_Integer, type);
            // @Todo: range check
            if int_info.signed {
                val, ok := GetValue(registry, TPrint("%.%", name, it.name), s64);
                if ok {
                    if int_info.runtime_size == {
                    case 1; cast(*s8,  ptr).* = xx,no_check val;
                    case 2; cast(*s16, ptr).* = xx,no_check val;
                    case 4; cast(*s32, ptr).* = xx,no_check val;
                    case 8; cast(*s64, ptr).* = xx,no_check val;
                    }
                }
            } else {
                val, ok := GetValue(registry, TPrint("%.%", name, it.name), u64);
                if ok {
                    if int_info.runtime_size == {
                    case 1; cast(*u8,  ptr).* = xx,no_check val;
                    case 2; cast(*u16, ptr).* = xx,no_check val;
                    case 4; cast(*u32, ptr).* = xx,no_check val;
                    case 8; cast(*u64, ptr).* = xx,no_check val;
                    }
                }
            }

        case .FLOAT;
            val, ok := GetValue(registry, TPrint("%.%", name, it.name), float);
            if ok {
                cast(*float, ptr).* = val;
            }

        case .STRING;
            str, ok := GetValue(registry, TPrint("%.%", name, it.name), string);
            if ok {
                Free(cast(*string, ptr).data);
                cast(*string, ptr).* = StringClone(str);
            }

        case .BOOL;
            val, ok := GetValue(registry, TPrint("%.%", name, it.name), bool);
            if ok {
                cast(*bool, ptr).* = val;
            }

        case;
            LogError("Config entry '%' has member % of unhandled type %", name, it.name, cast(*Type, *type).*);
        }
    }
}
