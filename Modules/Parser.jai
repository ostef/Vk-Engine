#scope_file

Basic :: #import "Basic";
#import "Common";
#import "Lexer";

#scope_export

CircularBuffer :: struct(T : Type, N : int) {
    performed_one_loop : bool;
    read_index : int;
    write_index : int;
    elements : [N]T;
}

Push :: (using buff : *CircularBuffer, value : buff.T, allow_overwrite := true) {
    elements[write_index] = value;
    write_index = (write_index + 1) % N;
    performed_one_loop |= write_index == 0;

    if write_index == read_index {
        Assert(allow_overwrite, "Circular buffer overflow");
        read_index = (read_index + 1) % N;
    }
}

NumAvailableElements :: inline (using buff : CircularBuffer) -> int {
    if read_index <= write_index {
        return write_index - read_index;
    } else {
        return write_index + N - read_index;
    }
}

Consume :: (using buff : *CircularBuffer, count := 1) -> consumed : int {
    Assert(count > 0);

    count = Min(count, NumAvailableElements(buff));
    read_index = (read_index + count) % N;

    return count;
}

PeekForward :: (using buff : *CircularBuffer, peek := 0) -> *buff.T {
    Assert(peek >= 0);

    if peek >= NumAvailableElements(buff) {
        return null;
    }

    index := (read_index + peek) % N;

    return *elements[index];
}

PeekBackwards :: (using buff : *CircularBuffer, peek := 0) -> *buff.T {
    Assert(peek >= 0);

    allowed_peek : int;
    if performed_one_loop {
        allowed_peek = (ifx read_index <= write_index
            then read_index + (N - write_index)
            else read_index - write_index);
    } else {
        allowed_peek = read_index;
    }

    if peek >= allowed_peek {
        return null;
    }

    index := (read_index - peek - 1);
    if index < 0 {
        index += N;
    }

    Assert(index >= 0 && index < N);

    return *elements[index];
}

TokenRange :: struct {
    byte_offset : s64;
    line_start, line_end : s32;
    char_start, char_end : s32;
}

CompareLineColumnPairs :: inline (l0 : s32, c0 : s32, l1 : s32, c1 : s32) -> int {
    if l0 < l1 {
        return -1;
    }
    if l0 > l1 {
        return 1;
    }
    if c0 < c1 {
        return -1;
    }
    if c0 > c1 {
        return 1;
    }
    return 0;
}

TokenRangeJoin :: (a : TokenRange, b : TokenRange) -> TokenRange {
    result : TokenRange = ---;

    start, end : *TokenRange;
    if CompareLineColumnPairs(a.line_start, a.char_start, b.line_start, b.char_start) < 0 {
        start = *a;
    } else {
        start = *b;
    }

    if CompareLineColumnPairs(a.line_end, a.char_end, b.line_end, b.char_end) > 0 {
        end = *a;
    } else {
        end = *b;
    }

    result.line_start = start.line_start;
    result.char_start = start.char_start;
    result.line_end = end.line_end;
    result.char_end = end.char_end;
    result.byte_offset = start.byte_offset;

    return result;
}

TokenRangeToString :: (parser : Parser, using range : TokenRange) -> string {
    curr_line := line_start;
    curr_char := char_start;
    start := parser.text.data + byte_offset;
    end := start;
    while end < parser.text.data + parser.text.count {
        if curr_line == line_end && curr_char == char_end {
            break;
        }

        if end.* == #char "\n" {
            curr_line += 1;
            curr_char = 0;
        }

        curr_char += 1;
        end += 1;
    }

    return .{end - start, start};
}

TokenRangeToStringFirstLine :: (parser : Parser, range : TokenRange) -> string {
    str := TokenRangeToString(parser, range);
    nl := String.find_index_from_left(str, #char "\n");
    if nl >= 0 {
        str.count = nl;
    }

    return str;
}

Symbol_Names :: [2]string.[
    .["!", "Exclam"],
    .["\"", "DoubleQuote"],
    .["#", "Hash"],
    .["$", "Dollar"],
    .["%", "Percent"],
    .["&", "Ampersand"],
    .["'", "Quote"],
    .["(", "OpenParen"],
    .[")", "CloseParen"],
    .["*", "Asterisk"],
    .["+", "Plus"],
    .[",", "Comma"],
    .["-", "Minus"],
    .[".", "Dot"],
    .["/", "Slash"],
    .[":", "Colon"],
    .[";", "SemiColon"],
    .["<", "OpenAngle"],
    .["=", "Equal"],
    .[">", "CloseAngle"],
    .["?", "Question"],
    .["@", "At"],
    .["[", "OpenSquare"],
    .["\\", "Backslash"],
    .["]", "CloseSquare"],
    .["^", "Caret"],
    .["_", "Underscore"],
    .["`", "Backtick"],
    .["{", "OpenCurly"],
    .["|", "VertBar"],
    .["}", "CloseCurly"],
    .["~", "Tilde"],
];

Parser :: struct(
    Punctuation : []string,
    Keywords : []string,
    String_Literal_Quotes : string,
    Single_Line_Comment_Str : string,
    Multi_Line_Comment_Start_Str : string,
    Multi_Line_Comment_End_Str : string,
    Max_Token_Storage := 10
) {
    TokenKind :: enum u8 {
        Invalid;
        Comment;
        PunctuationBegin;

        #insert -> string {
            builder : StringBuilder;

            for punct : Punctuation {
                for char : punct {
                    name : string;
                    for names : Symbol_Names {
                        if names[0] == string.{data=*char, count=1} {
                            name = names[1];
                            break;
                        }
                    }

                    Assert(name != "", "Could not find alphanumeric name for punctuation symbol %", string.{data=*char, count=1});
                    Append(*builder, "%", name);
                }

                Appendln(*builder, ";");
            }

            return StringBuilderBuild(*builder);
        }

        PunctuationEnd;
        KeywordsBegin;

        #insert -> string {
            builder : StringBuilder;

            for kw : Keywords {
                capitalize := true;
                for i : 0..kw.count - 1 {
                    if !Basic.is_alnum(kw[i]) {
                        continue;
                    }

                    if kw[i] == #char "_" {
                        capitalize = true;
                    } else {
                        if capitalize {
                            StringBuilderAppendByte(*builder, Basic.to_upper(kw[i]));
                        } else {
                            StringBuilderAppendByte(*builder, kw[i]);
                        }

                        capitalize = false;
                    }
                }
                Appendln(*builder, ";");
            }

            return StringBuilderBuild(*builder);
        }

        KeywordsEnd;
        Identifier;
        IntLiteral;
        FloatLiteral;
        StringLiteral;
        EOF;

        Count;
    }

    Token_Lexemes :: #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "string.[");

        for i : 0..TokenKind.Count - 1 {
            if i != 0 {
                Appendln(*builder, ",\n");
            }

            if i > TokenKind.PunctuationBegin && i < TokenKind.PunctuationEnd {
                index := cast(int, i) - cast(int, TokenKind.PunctuationBegin) - 1;
                Append(*builder, "\"%\"", Punctuation[index]);
            } else if i > TokenKind.KeywordsBegin && i < TokenKind.KeywordsEnd {
                index := cast(int, i) - cast(int, TokenKind.KeywordsBegin) - 1;
                Append(*builder, "\"%\"", Keywords[index]);
            } else {
                Append(*builder, "\"\"");
            }
        }

        Appendln(*builder, "\n];");

        return StringBuilderBuild(*builder);
    }

    Token_Names :: #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "string.[");

        for i : 0..TokenKind.Count - 1 {
            if i != 0 {
                Append(*builder, ",\n");
            }

            if i == .EOF {
                Append(*builder, "\"end of file\"");
            } else if Token_Lexemes[i] {
                Append(*builder, "\"'%'\"", Token_Lexemes[i]);
            } else {
                Append(*builder, "\"");

                name_index := -1;
                for ii : 0..type_info(TokenKind).values.count {
                    if cast(int) i == type_info(TokenKind).values[ii] {
                        name_index = ii;
                        break;
                    }
                }

                Assert(name_index > -1);

                name := type_info (TokenKind).names[name_index];
                for ii : 0..name.count - 1 {
                    if name[ii] == #char "_" {
                        StringBuilderAppendByte(*builder, #char " ");
                    } else {
                        is_upper :: (byte : u8) -> bool {
                            if byte >= #char "A" && byte <= #char "Z" {
                                return true;
                            }

                            return false;
                        }

                        StringBuilderAppendByte(*builder, Basic.to_lower(name[ii]));

                        if ii != name.count - 1 && !is_upper(name[ii]) && is_upper(name[ii + 1]) {
                            StringBuilderAppendByte(*builder, #char " ");
                        }
                    }
                }

                Append(*builder, "\"");
            }
        }

        Appendln(*builder, "\n];");

        return StringBuilderBuild(*builder);
    }

    Token :: struct {
        #as using range : TokenRange;
        kind : TokenKind;
    }

    #as using base : Lexer;
    tokens : CircularBuffer(Token, Max_Token_Storage);
    output_colors : bool;
    color_sequences := string.[
        "\x1b[0;96m", // SourceCode
        "\x1b[0;91m", // SourceCodeHighlight
        "\x1b[1;32m", // Info
        "\x1b[1;33m", // Warning
        "\x1b[1;31m", // Error
    ];
    max_reported_lines := 10;
    tab_size := 4;
}

InitParser :: (parser : *Parser, name : string, text : string) {
    parser.name = name;
    parser.text = text;
}

PrevToken :: (using parser : Parser, peek := 0) -> parser.Token {
    tok := PeekBackwards(*tokens, peek);
    Assert(tok != null);

    return tok.*;
}

NextToken :: (using parser : *Parser, peek := 0) -> parser.Token {
    Assert(peek >= 0);

    while NumAvailableElements(tokens) < peek + 1 {
        tok := ScanNextToken(parser);
        if tok.kind == .EOF {
            return tok;
        }

        Push(*tokens, tok, allow_overwrite=false);
    }

    return PeekForward(*tokens, peek);
}

ConsumeToken :: inline (using parser : *Parser, count := 1) {
    Consume(*tokens, count);
}

NextTokenIs :: (using parser : *Parser, kinds : ..parser.TokenKind, peek := 0) -> bool {
    tok := NextToken(parser, peek);

    for kinds {
        if tok.kind == it {
            return true;
        }
    }

    return false;
}

MatchToken :: (using parser : *Parser, kinds : ..parser.TokenKind) -> bool {
    if NextTokenIs(parser, ..kinds) {
        ConsumeToken(parser);

        return true;
    }

    return false;
}

ScanNumber :: (using parser : *Parser, number_base : int) -> is_valid : bool, has_exponent : bool {
    is_valid := true;
    has_exponent := false;

    while !LexerIsAtEnd(parser) && Basic.is_alnum(text[byte_index]) {
        // Handle float exponent
        if number_base == 10 && text[byte_index] == #char "e" {
            has_exponent = true;

            LexerAdvance(parser);
            if LexerIsAtEnd(parser) {
                return false, true;
            }

            sign := 1;
            if text[byte_index] == #char "-" || text[byte_index] == #char "+" {
                sign := ifx text[byte_index] == #char "-" then -1 else 1;
                LexerAdvance(parser);
            }

            if LexerIsAtEnd(parser) {
                return false, has_exponent;
            }

            while !LexerIsAtEnd(parser) && Basic.is_alnum(text[byte_index]) {
                if !Basic.is_digit(text[byte_index]) {
                    is_valid = false;
                }

                LexerAdvance(parser);
            }

            break;
        }

        valid_digit : bool = ---;
        digit := text[byte_index];
        if number_base == 16 {
            valid_digit = digit >= #char "0" && digit <= #char "9"
                || digit >= #char "A" && digit <= #char "F"
                || digit >= #char "a" && digit <= #char "f"
                || digit == #char "_";
        } else {
            valid_digit = digit >= #char "0" && digit < #char "0" + number_base || digit == #char "_";
        }

        if !valid_digit {
            is_valid = false;
        }

        LexerAdvance(parser);
    }

    return is_valid, has_exponent;
}

SkipWhitespacesAndComments :: inline (using parser : *Parser) {
    while !LexerIsAtEnd(parser) {
        if Basic.is_space(text[byte_index]) {
            LexerAdvance(parser);
        } else if Single_Line_Comment_Str && LexerMatchString(parser, Single_Line_Comment_Str) {
            while !LexerIsAtEnd(parser) && text[byte_index] != #char "\n" && text[byte_index] != #char "\r" {
                LexerAdvance(parser);
            }
        } else if Multi_Line_Comment_Start_Str && LexerEqualsString(parser, Multi_Line_Comment_Start_Str) {
            LexerAdvance(parser, 2);

            level := 1;
            while !LexerIsAtEnd(parser) && level > 0 {
                if LexerMatchString(parser, Multi_Line_Comment_Start_Str) {
                    level += 1;
                } else if LexerMatchString(parser, Multi_Line_Comment_End_Str) {
                    level -= 1;
                } else {
                    LexerAdvance(parser);
                }
            }
        } else {
            break;
        }
    }
}

SetStart :: inline (parser : *Parser, using tok : *parser.Token) {
    line_start = xx parser.line;
    char_start = xx parser.column;
    byte_offset = parser.byte_index;
}

SetEnd :: inline (parser : *Parser, using tok : *parser.Token) {
    line_end = xx parser.line;
    char_end = xx parser.column;
}

ScanNextToken :: (using parser : *Parser) -> parser.Token {
    SkipWhitespacesAndComments(parser);

    tok : Token;
    SetStart(parser, *tok);

    if LexerIsAtEnd(parser) {
        tok.kind = .EOF;
        SetEnd(parser, *tok);
        return tok;
    }

    for i : TokenKind.PunctuationBegin + 1..TokenKind.PunctuationEnd - 1 {
        if LexerMatchString(parser, Token_Lexemes[i]) {
            tok.kind = i;
            SetEnd(parser, *tok);

            return tok;
        }
    }

    for quote : String_Literal_Quotes {
        if text[byte_index] == quote {
            LexerAdvance(parser);

            has_newline := false;
            while !LexerIsAtEnd(parser) && text[byte_index] != quote {
                if text[byte_index] == #char "\\" {
                    LexerAdvance(parser);
                    if LexerIsAtEnd(parser) {
                        break;
                    }
                }

                if text[byte_index] == #char "\n" {
                    has_newline = true;
                }

                LexerAdvance(parser);
            }

            unclosed := LexerIsAtEnd(parser);

            LexerAdvance(parser);

            tok.kind = .StringLiteral;

            SetEnd(parser, *tok);

            if unclosed {
                Error(parser, tok, "Unclosed string literal");
            } else if has_newline {
                Error(parser, tok, "Newline in string literal");
            }

            return tok;
        }
    }

    if Basic.is_digit(text[byte_index]) {
        base : int = ---;
        if LexerMatchString(parser, "0b") {
            base = 2;
        } else if LexerMatchString(parser, "0o") {
            base = 8;
        } else if LexerMatchString(parser, "0x") {
            base = 16;
        } else {
            base = 10;
        }

        decimal_valid, decimal_exp := ScanNumber(parser, base);
        if byte_index + 2 <= text.count && text[byte_index] == #char "." && Basic.is_digit(text[byte_index + 1]) {
            LexerAdvance(parser);

            fract_valid, fract_exp := ScanNumber(parser, 10);

            // Can't have a non base 10 number followed by a fractional part
            // Can't have a number with exponent followed by a fractional part
            if base != 10 || decimal_exp {
                fract_valid = false;
            }

            tok.kind = .FloatLiteral;
            SetEnd(parser, *tok);

            if !decimal_valid || !fract_valid {
                Error(parser, tok, "Invalid float literal");
            }
        } else {
            tok.kind = ifx decimal_exp
                then .FloatLiteral
                else .IntLiteral;

            SetEnd(parser, *tok);

            if !decimal_valid {
                Error(parser, tok, "Invalid %", Token_Names[tok.kind]);
            }
        }

        return tok;
    }

    if Basic.is_alpha(text[byte_index])
    || text[byte_index] == #char "_" {
        for i : TokenKind.KeywordsBegin + 1..TokenKind.KeywordsEnd - 1 {
            if LexerMatchAlphaNumeric(parser, Token_Lexemes[i]) {
                tok.kind = i;
                SetEnd(parser, *tok);

                return tok;
            }
        }

        tok.kind = .Identifier;

        while !LexerIsAtEnd(parser) && Basic.is_alnum(text[byte_index]) {
            LexerAdvance(parser);
        }

        SetEnd(parser, *tok);

        return tok;
    }

    if tok.kind == .Invalid {
        LexerAdvance(parser);
    }

    SetEnd(parser, *tok);

    return tok;
}

MatchExpect :: (using parser : *Parser, kinds : ..parser.TokenKind) -> bool {
    match := MatchToken(parser, ..kinds);
    if match {
        return true;
    }

    ExpectedError(parser, PrevToken(parser), NextToken(parser), ..kinds);

    return false;
}

AppendIndentation :: (builder : *StringBuilder, col : int, size : int, char : u8 = #char " ") -> int {
    count := size - (col % size);
    for i : 0..count - 1 {
        StringBuilderAppendByte(builder,  char);
    }

    return count;
}

GetLine :: (str : string, line_index : int) -> string {
    start := 0;
    end := String.find_index_from_left(str, #char "\n");
    if end < 0 {
        end = str.count;
    }

    i := 0;
    while i < line_index && end < str.count {
        start = end + 1;
        new_end := String.find_index_from_left(str, #char "\n", start);
        if new_end < 0 {
            end = str.count;
            break;
        } else {
            end = new_end;
        }

        i += 1;
    }

    return .{count=end-start, data=str.data+start};
}

ParserOutputColor :: enum {
    None;
    SourceCode;
    SourceCodeHighlight;
    Info;
    Warning;
    Error;
}

SetColor :: (builder : *StringBuilder, parser : Parser, color : ParserOutputColor) {
    if !parser.output_colors {
        return;
    }

    if color == {
    case .None;
        StringBuilderAppendString(builder, "\x1b[0m");
    case;
        StringBuilderAppendString(builder, parser.color_sequences[cast(int, color) - 1]);
    }
}

PrintTokenLine :: (builder : *StringBuilder, parser : Parser, range : TokenRange) {
    DecimalLength :: inline (val : u64) -> int {
        if !val {
            return 1;
        }

        i := 0;
        while val {
            i += 1;
            val /= 10;
        }

        return i;
    }

    range_length := TokenRangeToString(parser, range).count;

    str := parser.text;
    line_start := range.byte_offset;
    while line_start > 0 && str[line_start - 1] != #char "\n" {
        line_start -= 1;
    }

    printed_ellipsis := false;
    current_line := range.line_start;
    line_digits := DecimalLength(cast(u64, range.line_end));
    num_printed_lines := 0;

    while true {
        line_len := 0;

        defer {
            current_line += 1;

            line_start += line_len;

            if line_start >= range.byte_offset + range_length {
                break;
            }
        }

        empty_line := true;
        while line_start + line_len < str.count && str[line_start + line_len] != #char "\n" {
            if !Basic.is_space(str[line_start + line_len]) {
                empty_line = false;
            }

            line_len += 1;
        }

        if empty_line {
            if line_start + line_len < str.count && str[line_start + line_len] == #char "\n" {
                line_len += 1;
            }

            continue;
        }

        line_str := string.{line_len, str.data + line_start};

        if num_printed_lines < parser.max_reported_lines - 1 || current_line == range.line_end  {
            line_value := FormatInt.{value=current_line, minimum_digits=line_digits, padding=#char " "};
            Append(builder, " % | ", line_value);

            if line_start > range.byte_offset && line_start < range.byte_offset + range_length {
                SetColor(builder, parser, .SourceCodeHighlight);
            } else {
                SetColor(builder, parser, .SourceCode);
            }

            column := 0;
            for j : 0..line_len - 1 {
                if line_start + j == range.byte_offset {
                    SetColor(builder, parser, .SourceCodeHighlight);
                }

                if line_str[j] == #char "\t" {
                    column += AppendIndentation(builder, column, parser.tab_size);
                } else {
                    StringBuilderAppendByte(builder, line_str[j]);
                    column += 1;
                }

                if line_start + j == range.byte_offset + range_length - 1 {
                    SetColor(builder, parser, .SourceCode);
                }
            }

            Append(builder, "\n");
            SetColor(builder, parser, .None);
        } else if !printed_ellipsis {
            Append(builder, "(...)\n");
            printed_ellipsis = true;
        }

        if line_start + line_len < str.count && str[line_start + line_len] == #char "\n" {
            line_len += 1;
        }

        if !parser.output_colors {
            if num_printed_lines < parser.max_reported_lines - 1 || current_line == range.line_end {
                for j : 0..line_digits - 1 {
                    Append(builder, " ");
                }
                Append(builder, "    ");
                SetColor(builder, parser, .SourceCodeHighlight);

                column := 0;
                for j : 0..line_len - 1 {
                    if line_start + j >= range.byte_offset && line_start + j < range.byte_offset + range_length {
                        if j < line_str.count && line_str[j] == #char "\t" {
                            column += AppendIndentation(builder, column, parser.tab_size, #char "~");
                        } else {
                            Append(builder, "~");
                            column += 1;
                        }
                    } else if j < line_str.count && line_str[j] == #char "\t" {
                        column += AppendIndentation(builder, column, parser.tab_size);
                    } else {
                        Append(builder, " ");
                        column += 1;
                    }
                }

                Append(builder, "\n");
                SetColor(builder, parser, .None);
            }
        }

        num_printed_lines += 1;
    }

    if parser.output_colors {
        Append(builder, "\n");
    }
}

ParserReport :: (parser : Parser, range : TokenRange, color : ParserOutputColor, category : string, fmt_str : string, args : ..Any) {
    builder : StringBuilder;

    SetColor(*builder, parser, .None);
    Append(*builder, "%:%:%, ", parser.name, range.line_start, range.char_start);

    SetColor(*builder, parser, color);
    Append(*builder, "%: ", category);
    SetColor(*builder, parser, .None);

    Append(*builder, fmt_str, ..args);
    Append(*builder, "\n\n");

    PrintTokenLine(*builder, parser, range);

    if category == {
    case "Error";
        LogError("%", StringBuilderBuild(*builder));
    case "Warning";
        LogWarning("%", StringBuilderBuild(*builder));
    case;
        LogMessage("%", StringBuilderBuild(*builder));
    }
}
@PrintLike

ParserReportWithoutSourceCode :: (parser : Parser, range : TokenRange, color : ParserOutputColor, category : string, fmt_str : string, args : ..Any) {
    builder : StringBuilder;

    SetColor(*builder, parser, .None);
    Append(*builder, "%:%:%, ", parser.name, range.line_start, range.char_start);

    SetColor(*builder, parser, color);
    Append(*builder, "%: ", category);
    SetColor(*builder, parser, .None);

    Append(*builder, fmt_str, ..args);
    Append(*builder, "\n");

    if category == {
    case "Error";
        LogError("%", StringBuilderBuild(*builder));
    case "Warning";
        LogWarning("%", StringBuilderBuild(*builder));
    case;
        LogMessage("%", StringBuilderBuild(*builder));
    }
}
@PrintLike

Error :: inline (parser : Parser, range : TokenRange, fmt_str : string, args : ..Any) {
    ParserReport(parser, range, .Error, "Error", fmt_str, ..args);
}
@PrintLike

Warning :: inline (parser : Parser, range : TokenRange, fmt_str : string, args : ..Any) {
    ParserReport(parser, range, .Warning, "Warning", fmt_str, ..args);
}
@PrintLike

ExpectedError :: (parser : Parser, prev : parser.Token, tok : parser.Token, kinds : ..parser.TokenKind) {
    err_builder : StringBuilder;

    if kinds.count == 1 {
        Append(*err_builder, "Expected %", parser.Token_Names[kinds[0]]);
    } else {
        Append(*err_builder, "Expected one of ");

        for kinds {
            if it_index == kinds.count - 1 {
                Append(*err_builder, " or ");
            } else if it_index != 0 {
                Append(*err_builder, ", ");
            }

            Append(*err_builder, parser.Token_Names[it]);
        }
    }

    Append(*err_builder, " after %", parser.Token_Names[prev.kind]);

    lexeme := parser.Token_Lexemes[tok.kind];
    tok_string := TokenRangeToString(parser, tok);
    if !lexeme && tok_string.count > 0 && tok_string.count < 15 {
        Append(*err_builder, ", but got % '%' instead", parser.Token_Names[tok.kind], tok_string);
    } else {
        Append(*err_builder, ", but got % instead", parser.Token_Names[tok.kind]);
    }

    ParserReport(parser, TokenRangeJoin(prev, tok), .Error, "Error", "%", StringBuilderBuild(*err_builder));
}

Info :: inline (parser : Parser, range : TokenRange, fmt_str : string, args : ..Any) {
    ParserReport(parser, range, .Info, "Info", fmt_str, ..args);
}
@PrintLike

InfoWithoutSourceCode :: inline (parser : Parser, range : TokenRange, fmt_str : string, args : ..Any) {
    ParserReportWithoutSourceCode(parser, range, .Info, "Info", fmt_str, ..args);
}
@PrintLike

ParseIntLiteral :: (parser : Parser, token : parser.Token) -> s64 {
    Assert(token.kind == .IntLiteral);

    str := TokenRangeToString(parser, token.range);
    base := 10;
    if StringStartsWith(str, "0x") {
        base = 16;
        str = StringAdvance(str, 2);
    } else if StringStartsWith(str, "0b") {
        base = 2;
        str = StringAdvance(str, 2);
    }

    value, ok, remainder := Basic.string_to_int(str, base, s64);
    Assert(ok && remainder.count == 0, "Failed to parse int literal, this should not happen as validation happens during tokenization");

    return value;
}

ParseFloatLiteral :: (parser : Parser, token : parser.Token) -> float64 {
    Assert(token.kind == .FloatLiteral);

    str := TokenRangeToString(parser, token.range);

    value, ok, remainder := Basic.string_to_float64(str);
    Assert(ok && remainder.count == 0, "Failed to parse float literal, this should not happen as validation happens during tokenization");

    return value;
}

ParseEscapeSequence :: (parser : Parser, token : parser.Token, str : string, byte_offset : *int) -> bool, utf8 : [4]u8, utf8_length : int, utf32 : u32 {
    utf8 : [4]u8;

    if byte_offset.* == str.count {
        Error(parser, token, "Unfinished escape sequence at then end of this string literal");
        return false, utf8, 0, 0;
    }

    if str[byte_offset.*] == {
    case #char "\\";
        byte_offset.* += 1;
        utf8[0] = #char "\\";
        return true, utf8, 1, utf8[0];
    case #char "0";
        byte_offset.* += 1;
        utf8[0] = 0;
        return true, utf8, 1, utf8[0];
    case #char "t";
        byte_offset.* += 1;
        utf8[0] = #char "\t";
        return true, utf8, 1, utf8[0];
    case #char "n";
        byte_offset.* += 1;
        utf8[0] = #char "\n";
        return true, utf8, 1, utf8[0];
    case #char "r";
        byte_offset.* += 1;
        utf8[0] = #char "\r";
        return true, utf8, 1, utf8[0];
    case #char "'";
        byte_offset.* += 1;
        utf8[0] = #char "'";
        return true, utf8, 1, utf8[0];
    case #char "\"";
        byte_offset.* += 1;
        utf8[0] = #char "\"";
        return true, utf8, 1, utf8[0];

    case #char "x";
        byte_offset.* += 1;

        if byte_offset.* + 2 > str.count {
            Error(parser, token, "Unfinished escape sequence at then end of this string literal");
            return false, utf8, 0, 0;
        }

        digits := string.{2, str.data + byte_offset.*};
        byte_offset.* += 2;

        value, ok, remainder := Basic.string_to_int(digits, base=16, T=u8);
        if !ok || remainder.count > 0 {
            Error(parser, token, "Invalid \\x escape sequence in this string literal");
        }

        utf8[0] = value;
        return true, utf8, 1, utf8[0];

    case #char "u"; #through;
    case #char "U";
        escape := str[byte_offset.*];
        byte_offset.* += 1;

        num_digits := ifx escape == #char "u" then 4 else 8;
        if byte_offset.* + num_digits > str.count {
            Error(parser, token, "Unfinished escape sequence at then end of this string literal");
            return false, utf8, 0, 0;
        }

        digits := string.{num_digits, str.data + byte_offset.*};
        byte_offset.* += num_digits;

        utf32, ok, remainder := Basic.string_to_int(digits, base=16, T=u32);
        if !ok || remainder.count > 0 {
            Error(parser, token, "Invalid \\% escape sequence in this string literal", escape);
        }

        utf8_length := EncodeCharacterAsUtf8(utf32, utf8, 0);
        return true, utf8, utf8_length, utf32;

    case;
        Error(parser, token, "Invalid escape sequence in string literal");
        InfoWithoutSourceCode(parser, token, "Valid escape sequences are \\0, \\t, \\n, \\r, \\\\, \\', \\\", \\xhh, \\uhhhh, \\Uhhhhhhhh where h is a hexadecimal digit");
        return false, utf8, 0, 0;
    }
}

ParseStringLiteral :: (parser : Parser, token : parser.Token) -> string, bool {
    Assert(token.kind == .StringLiteral);

    str := TokenRangeToString(parser, token);
    buffer : [..]u8;
    ArrayReserve(*buffer, str.count);
    index := 0;

    str.data += 1;
    str.count -= 2;

    escape := false;
    i := 0;
    while i < str.count {
        if str[i] == #char "\\" {
            i += 1;

            ok, utf8, utf8_length := ParseEscapeSequence(parser, token, str, *i);
            if !ok {
                return cast(string, buffer), false;
            }

            for byte_index : 0..utf8_length - 1 {
                ArrayPush(*buffer, utf8[byte_index]);
            }
        } else {
            ArrayPush(*buffer, str[i]);
            i += 1;
        }
    }

    return cast(string, buffer), true;
}
