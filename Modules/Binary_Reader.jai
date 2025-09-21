BinaryReader :: struct
{
    data : *u8;
    size : s64;
    offset : s64;
}

MakeBinaryReader :: inline (data : []u8) -> BinaryReader
{
    return .{data = data.data, size = data.count, offset = 0};
}

IsAtEnd :: (reader : BinaryReader) -> bool
{
    return reader.offset >= reader.size;
}

ReadBytes :: (reader : *BinaryReader, data : *void, size : s64) -> bool
{
    if reader.offset + size > reader.size
        return false;

    memcpy(data, reader.data + reader.offset, size);
    reader.offset += size;

    return true;
}

EqualsString :: (reader : *BinaryReader, str : string) -> bool
{
    if reader.offset + str.count > reader.size
        return false;

    return string.{str.count, reader.data + reader.offset} == str;
}

ReadString :: (reader : *BinaryReader, count : s64) -> string, bool
{
    if reader.size - reader.offset < count
        return "", false;

    result : string = ---;
    result.data = reader.data + reader.offset;
    result.count = count;

    reader.offset += count;

    return result, true;
}

ReadNullTerminatedString :: (using reader : *BinaryReader) -> string, bool
{
    result : string = ---;
    result.data = data + offset;
    result.count = 0;

    while offset + result.count < size && data[offset + result.count] != 0
        result.count += 1;

    if offset + result.count >= size
        return result, false;

    offset += result.count + 1;

    return result, true;
}

ReadValue :: (reader : *BinaryReader, $T : Type) -> T, bool
{
    value : T = ---;
    if reader.offset + size_of(T) > reader.size
        return value, false;

    value = (cast(*T) (reader.data + reader.offset)).*;
    reader.offset += size_of(T);

    return value, true;
}

ReadArray :: (reader : *BinaryReader, data : []$T) -> bool
{
    if reader.offset + size_of(T) * data.count > reader.size
        return false;

    memcpy(data.data, reader.data + reader.offset, size_of(T) * data.count);
    reader.offset += size_of(T) * data.count;

    return true;
}
