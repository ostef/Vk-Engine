ConfigRegistry :: struct {
    filename : string;
    parsed_values : HashMap(string, ConfigValue);
    entries : HashMap(string, Any);
}

ConfigValueKind :: enum u8 {
    Int;
    UInt;
    Bool;
    Float;
    String;
}

ConfigValue :: union kind : ConfigValueKind {
    .Int    ,, s64_value : s64;
    .UInt   ,, u64_value : u64;
    .Bool   ,, bool_value : bool;
    .Float  ,, float_value : float;
    .String ,, string_value : string;
}
