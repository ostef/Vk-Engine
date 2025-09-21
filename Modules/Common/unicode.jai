Utf8String :: struct
{
    count : s64;
    data : *u8;

    #place count;
    as_string : string;
}

MakeUtf8String :: inline (str : string) -> Utf8String
{
    return .{str.count, str.data};
}

MakeUtf8String :: inline (count : s64, data : *u8) -> Utf8String
{
    return .{count, data};
}

for_expansion :: (str : Utf8String, body : Code, flags : For_Flags) #expand
{
    `it_index := 0;
    byte_index := 0;
    while byte_index < str.count
    {
        `it, len := DecodeUtf8Character(cast([]u8) str.as_string, byte_index);

        defer {
            it_index += 1;
            byte_index += len;
        }

        #insert body;
    }
}

// for_expansion
ByWord :: (str : Utf8String, body : Code, flags : For_Flags) #expand
{
    Word :: struct
    {
        start_byte_index, end_byte_index : s64;
        str : string;
        length : s64;
        spaces : bool;
    }

    `it : Word;
    `it_index := 0;
    if str.count != 0
        it.spaces == Basic.is_space(str.data[0]);

    while it.end_byte_index < str.count
    {
        codepoint, codepoint_len := DecodeUtf8Character(cast([]u8) str.as_string, it.end_byte_index);

        defer {
            it.end_byte_index += codepoint_len;
            it.length += 1;
            it_index += 1;
        }

        space := codepoint < 128 && Basic.is_space(xx codepoint);
        if it.spaces != space
        {
            it.str.data = str.data + it.start_byte_index;
            it.str.count = it.end_byte_index - it.start_byte_index;
            #insert body;

            it.start_byte_index = it.end_byte_index;
            it.length = 0;
            it.spaces = space;
        }
    }

    if it.start_byte_index != it.end_byte_index
    {
        it.str.data = str.data + it.start_byte_index;
        it.str.count = it.end_byte_index - it.start_byte_index;
        #insert body;
    }
}

Unicode_Replacement : u32 : 0xfffd;
Unicode_Max : u32 : 0x10ffff;

UnicodeResult :: enum
{
    Ok;
    Buffer_Too_Small;
    Source_Exhausted;
    Source_Illegal;
}

Utf8Length :: (str : string) -> s64, UnicodeResult
{
    len := 0;
    i := 0;
    while i < str.count
    {
        size := GetUtf8DecodingSize(str[i]);

        if size == 0
            return 0, .Source_Illegal;

        if i + size > str.count
            return len, .Source_Exhausted;

        i += size;
        len += 1;
    }

    return len, .Ok;
}

GetUtf8DecodingSize :: inline (first : u8) -> s64
{
    if first < 0x80
        return 1;
    else if (first & 0xe0) == 0xc0
        return 2;
    else if (first & 0xf0) == 0xe0
        return 3;
    else if (first & 0xf8) == 0xf0
        return 4;
    else
        return 0;
}

DecodeUtf8String :: (str : string) -> []u32, UnicodeResult
{
    length, result := Utf8Length(str);
    if result != .Ok
        return .[], result;

    buffer := AllocArray(u32, length, initialize=false);

    written:, result = DecodeUtf8String(str, buffer);
    Assert(written == buffer.count);

    return buffer, result;
}

DecodeUtf8String :: (str : string, buffer : []u32) -> written : s64, UnicodeResult
{
    i := 0;
    byte_offset := 0;
    while byte_offset < str.count
    {
        codepoint, size, result := DecodeUtf8Character(cast([]u8) str, byte_offset);
        if result != .Ok
            return i, result;

        if i == buffer.count
            return i, .Buffer_Too_Small;

        buffer[i] = codepoint;
        i += 1;
        byte_offset += size;
    }

    return i, .Ok;
}

// Should we change `buffer : []u8` to `str : string` ?
// Note: The encode functions take a []u8 as the output buffer
DecodeUtf8Character :: (buffer : []u8, byte_offset : s64) -> codepoint : u32, size : s64, UnicodeResult
{
    buff := buffer;
    buff.data += byte_offset;
    buff.count -= byte_offset;

    if buff.count <= 0
        return Unicode_Replacement, 0, .Source_Exhausted;

    first := buff[0];
    size := GetUtf8DecodingSize(first);

    if size == 0
        return Unicode_Replacement, 0, .Source_Illegal;

    if buff.count < size
        return Unicode_Replacement, size, .Source_Exhausted;

    First_Byte_Mask :: u8.[ 0x7f, 0x1f, 0x0f, 0x07 ];

    codepoint : u32 = first & First_Byte_Mask[size - 1];
    for i : 1..size - 1
    {
        codepoint <<= 6;
        codepoint |= buff[i] & 0x3f;
    }

    if codepoint > Unicode_Max
        return Unicode_Replacement, size, .Source_Illegal;

    return codepoint, size, .Ok;
}

GetUtf8EncodingSize :: inline (codepoint : u32) -> s64
{
    if codepoint <= 0x7f
        return 1;
    else if codepoint <= 0x7ff
        return 2;
    else if codepoint <= 0xffff
        return 3;
    else if codepoint <= 0x10ffff
        return 4;

    return 3; // Encoding size for Unicode_Replacement
}

GetUtf8EncodingSize :: inline (str : []u32) -> s64
{
    size := 0;
    for str
        size += GetUtf8EncodingSize(it);

    return size;
}

EncodeStringAsUtf8 :: (str : []u32) -> string, UnicodeResult
{
    length := GetUtf8EncodingSize(str);
    buffer := AllocArray(u8, length, initialize=false);

    written, result := EncodeStringAsUtf8(str, buffer);
    Assert(written == buffer.count);

    return cast(string) buffer, result;
}

EncodeStringAsUtf8 :: (str : []u32, buffer : []u8) -> written : s64, UnicodeResult
{
    byte_offset := 0;
    for i : 0..str.count - 1
    {
        size, result := EncodeCharacterAsUtf8(str[i], buffer, byte_offset);

        if result != .Ok
            return byte_offset, result;

        byte_offset += size;
    }

    return byte_offset, .Ok;
}

EncodeCharacterAsUtf8 :: (codepoint : u32, buffer : []u8, byte_offset : s64) -> s64, UnicodeResult
{
    // Should we return .Source_Illegal for this?
    if codepoint > Unicode_Max
        codepoint = Unicode_Replacement;

    size := GetUtf8EncodingSize(codepoint);
    if buffer.count < size
        return size, .Buffer_Too_Small;

    for #v2 < i : 1..size - 1
    {
        buffer[byte_offset + i] = xx (codepoint | 0x80) & 0xbf;
        codepoint >>= 6;
    }

    First_Byte_Mark :: u8.[ 0x00, 0x00, 0xc0, 0xe0 ];

    buffer[byte_offset] = xx (codepoint | First_Byte_Mark[size]);

    return size, .Ok;
}
