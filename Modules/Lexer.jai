#scope_file

#import "Common";
Basic :: #import "Basic";
String :: #import "String";

#scope_export

Lexer :: struct
{
    name : string;

    #overlay(name)
    filename : string;

    text : string;
    byte_index : s64;
    column := 1;
    line := 1;

    has_errors : bool;
}

LexerIsAtEnd :: inline (using lexer : Lexer) -> bool
{
    return byte_index >= text.count;
}

LexerAdvance :: (using lexer : *Lexer, count := 1) -> int
{
    i := 0;
    while !LexerIsAtEnd(lexer) && i < count
    {
        str_to_check := string.{text.count - byte_index, text.data + byte_index};
        if str_to_check.count > count
            str_to_check.count = count;

        newline_index := String.find_index_from_left(str_to_check, #char "\n");
        if newline_index != -1
        {
            byte_index += newline_index + 1;
            i += newline_index + 1;
            column = 1;
            line += 1;
        }
        else
        {
            byte_index += str_to_check.count;
            column += str_to_check.count;
            i += str_to_check.count;

            return i;
        }
    }

    return i;
}

LexerRemainingBytesString :: inline (using lexer : Lexer) -> string
{
    return string.{text.count - byte_index, text.data + byte_index};
}

LexerRemainingBytes :: inline (using lexer : Lexer) -> int
{
    return Max(text.count - byte_index, 0);
}

LexerGetLine :: inline (using lexer : Lexer) -> string
{
    remaining := LexerRemainingBytesString(lexer);

    newline_index := String.find_index_from_left(remaining, #char "\n");
    if newline_index != -1
        remaining.count = newline_index;

    return remaining;
}

LexerEqualsString :: inline (using lexer : Lexer, str : string) -> bool
{
    if LexerRemainingBytes(lexer) < str.count
        return false;

    remaining_str : string = ---;
    remaining_str.data = text.data + byte_index;
    remaining_str.count = str.count;

    return remaining_str == str;
}

// This function uses String.find_index_from_left which is SIMD optimized
LexerAdvanceUntilMatches :: inline (using lexer : *Lexer, str : string) -> bool
{
    if str.count == 0
        return false;

    while !LexerIsAtEnd(lexer)
    {
        remaining := string.{text.count - byte_index, text.data + byte_index};
        index := String.find_index_from_left(remaining, str[0]);
        if index < 0
        {
            LexerAdvance(lexer, remaining.count);

            return false;
        }

        LexerAdvance(lexer, index);

        if LexerEqualsString(lexer, str)
            return true;

        LexerAdvance(lexer);
    }

    return false;
}

LexerMatchString :: inline (using lexer : *Lexer, str : string) -> bool
{
    if LexerEqualsString(lexer, str)
    {
        LexerAdvance(lexer, str.count);
        return true;
    }

    return false;
}

LexerEqualsAlphaNumeric :: inline (using lexer : Lexer, str : string) -> bool
{
    if !LexerEqualsString(lexer, str)
        return false;

    return LexerRemainingBytes(lexer) == str.count || !Basic.is_alnum(text[byte_index + str.count]);
}

LexerMatchAlphaNumeric :: inline (using lexer : *Lexer, str : string) -> bool
{
    if LexerEqualsAlphaNumeric(lexer, str)
    {
        LexerAdvance(lexer, str.count);
        return true;
    }

    return false;
}

LexerSkipSpacesUntilNewline :: inline (using lexer : *Lexer)
{
    while !LexerIsAtEnd(lexer)
    {
        if text[byte_index] == #char "\n"
            return;

        if Basic.is_space(text[byte_index])
            LexerAdvance(lexer);
        else
            break;
    }
}

LexerSkipWhitespacesAndComments :: inline (using lexer : *Lexer)
{
    while !LexerIsAtEnd(lexer)
    {
        if Basic.is_space(text[byte_index])
        {
            LexerAdvance(lexer);
        }
        else if LexerMatchString(lexer, "//")
        {
            while !LexerIsAtEnd(lexer) && text[byte_index] != #char "\n" && text[byte_index] != #char "\r"
                LexerAdvance(lexer);
        }
        else if LexerEqualsString(lexer, "/*")
        {
            LexerAdvance(lexer, 2);

            level := 1;
            while !LexerIsAtEnd(lexer) && level > 0
            {
                if LexerMatchString(lexer, "/*")
                    level += 1;
                else if LexerMatchString(lexer, "*/")
                    level -= 1;
                else
                    LexerAdvance(lexer);
            }

            // if level != 0
            //     syntax_error(tok, "unclosed comment");
        }
        else
            break;
    }
}

LexerScanQuotedString :: (using lexer : *Lexer, allowed_quotes := "\"") -> string, bool
{
    if LexerIsAtEnd(lexer)
        return "", false;

    quote : u8;
    for i : 0..allowed_quotes.count - 1
    {
        if text[byte_index] == allowed_quotes[i]
        {
            quote = allowed_quotes[i];
            break;
        }
    }

    if !quote
        return "", false;

    LexerAdvance(lexer);

    builder : StringBuilder;
    builder.allocator = Temp;

    while !LexerIsAtEnd(lexer) && text[byte_index] != quote
    {
        if text[byte_index] == #char "\\"
        {
            LexerAdvance(lexer);

            if LexerIsAtEnd(lexer)
                break;

            if text[byte_index] == quote
            {
                StringBuilderAppendByte(*builder, quote);
            }
            else if text[byte_index] ==
            {
            case #char "n";  StringBuilderAppendByte(*builder, #char "\n");
            case #char "\\"; StringBuilderAppendByte(*builder, #char "\\");
            case #char "r";  StringBuilderAppendByte(*builder, #char "\r");
            case #char "t";  StringBuilderAppendByte(*builder, #char "\t");
            }

            LexerAdvance(lexer);
        }
        else
        {
            StringBuilderAppendByte(*builder, text[byte_index]);
            LexerAdvance(lexer);
        }
    }

    if LexerIsAtEnd(lexer)
        return "", false;

    LexerAdvance(lexer);

    return StringBuilderBuild(*builder), true;
}

SyntaxError :: (using lexer : *Lexer, fmt_str : string, args : ..Any)
{
    has_errors = true;
    msg := SPrint(fmt_str, ..args,, Temp);
    LogError("%:%:%, syntax error: %", name, line, column, msg);
}
