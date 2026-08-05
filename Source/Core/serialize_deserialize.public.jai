#import "Lexer";

Serializer :: struct {
    #as builder : StringBuilder;
    indent_level : int;
}

DeserializeParser :: struct {
    lines : []string;
    line_index : int;
    byte_index : int;
    indent_level : int;
}

DeserializeResult :: struct {
    ok : bool;
    line_index : int;
    byte_index : int;
    location : Source_Code_Location;
    error_msg : string;
}

DeserializeError :: inline (parser : *DeserializeParser, error_msg : string, args : ..Any, location := #caller_location) -> DeserializeResult {
    return .{
        ok=false,
        line_index=parser.line_index,
        byte_index=parser.byte_index,
        location=location,
        error_msg=SPrint(error_msg, ..args ,, Temp),
    };
} @PrintLike

DeserializeOk :: inline (parser : *DeserializeParser, location := #caller_location) -> DeserializeResult {
    return .{
        ok=true,
        line_index=parser.line_index,
        byte_index=parser.byte_index,
        location=location,
    };
}

DeserializeWarning :: inline (parser : *DeserializeParser, msg : string, args : ..Any, location := #caller_location) -> DeserializeResult {
    return .{
        ok=true,
        line_index=parser.line_index,
        byte_index=parser.byte_index,
        location=location,
        error_msg=SPrint(msg, ..args ,, Temp)
    };
}

DeserializeCondition :: inline (parser : *DeserializeParser, ok : bool, error_msg : string, args : ..Any, location := #caller_location) -> DeserializeResult {
    return .{
        ok=ok,
        line_index=parser.line_index,
        byte_index=parser.byte_index,
        location=location,
        error_msg=SPrint(error_msg, ..args ,, Temp),
    };
} @PrintLike
