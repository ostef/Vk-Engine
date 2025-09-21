#module_parameters() (Enable_Asserts := true);

#load "memory.jai";
#load "array.jai";
#load "string.jai";
#load "string_builder.jai";
#load "logging.jai";
#load "unicode.jai";

InitContextBase :: ()
{
    #if OS == .WINDOWS
    {
        Win32 :: #import "Win32" (Threads = true);
        context.thread_index = xx Win32.GetCurrentThreadId();
    }
}

Formatter :: Basic.Formatter;
FormatInt :: Basic.FormatInt;
FormatFloat :: Basic.FormatFloat;
FormatStruct :: Basic.FormatStruct;
FormatArray :: Basic.FormatArray;

FormatIntHex :: inline (value : Any, digits := 16) -> FormatInt
{
    return .{value=value, base=16, minimum_digits=digits, padding=#char"0"};
}

FormatString :: (format_string : string, args : ..Any) -> string
#deprecated "The name of this function has been changed to SPrint"
{
    return SPrint(format_string, ..args);
}
@PrintLike

SPrint :: (format_string : string, args : ..Any) -> string
{
    builder : StringBuilder;
    builder.allocator = context.allocator;
    StringBuilderAppend(*builder, format_string, ..args);

    return StringBuilderBuild(*builder);
}
@PrintLike

TPrint :: (format_string : string, args : ..Any) -> string
{
    builder : StringBuilder;
    builder.allocator = Temp;
    StringBuilderAppend(*builder, format_string, ..args);

    return StringBuilderBuild(*builder ,, Temp);
}
@PrintLike

FormatString :: (allocator : Allocator, format_string : string, args : ..Any) -> string
#deprecated "Use a context argument instead: FormatString(\"...\", ... ,, allocator)"
{
    builder : StringBuilder;
    builder.allocator = allocator;
    StringBuilderAppend(*builder, format_string, ..args);

    return StringBuilderBuild(*builder,, allocator);
}
@PrintLike

FormatToCString :: (format_string : string, args : ..Any) -> *u8
#deprecated "The name of this function has been changed to CSPrint"
{
    return CSprint(format_string, ..args);
}
@PrintLike

CSPrint :: (format_string : string, args : ..Any) -> *u8
{
    builder : StringBuilder;
    builder.allocator = context.allocator;
    StringBuilderAppend(*builder, format_string, ..args);

    return StringBuilderBuildCstr(*builder);
}
@PrintLike

CTPrint :: (format_string : string, args : ..Any) -> *u8
{
    builder : StringBuilder;
    builder.allocator = Temp;
    StringBuilderAppend(*builder, format_string, ..args);

    return StringBuilderBuildCstr(*builder ,, Temp);
}
@PrintLike

FormatToCString :: (allocator : Allocator, format_string : string, args : ..Any) -> *u8
#deprecated "Use a context argument instead: FormatToCString(\"...\", ... ,, allocator)"
{
    builder : StringBuilder;
    builder.allocator = allocator;
    StringBuilderAppend(*builder, format_string, ..args);

    return StringBuilderBuildCstr(*builder,, allocator);
}
@PrintLike

Print :: Basic.print;

Print :: Basic.print;

Println :: inline (format_string : string, args : ..Any, to_standard_error := false) -> s64
{
    return Print(format_string, ..args, to_standard_error = to_standard_error)
        + Print("\n", to_standard_error = to_standard_error);
}
@PrintLike

#if Basic.MEMORY_DEBUGGER
{
    Common_Allocation_Leaves :: Basic.Procedure_To_Elide.[
        .{"AllocNonNull", "Common"},
        .{"Alloc", "Common"},
        .{"AllocArray", "Common"},
        .{"Realloc", "Common"},
        .{"StringClone", "Common"},
        .{"StringCloneToCString", "Common"},
        .{"StringJoin", "Common"},
        .{"FormatString", "Common"},
        .{"FormatToCString", "Common"},
        .{"ArrayReserve", "Common"},
        .{"HashMapInit", "Hash_Map"},
        .{"HashMapGrow", "Hash_Map"},
    ];
}

Assert :: (assertion : bool, format_string := "", args : ..Any, location := #caller_location) #expand
{
    #if Enable_Asserts
    {
        if !assertion && Basic.assert_helper(format_string, ..args, location)
            debug_break();
    }
}
@PrintLike
@NoProfile

#add_context panicking := false;

Panic :: (format_string := "", args : ..Any, location := #caller_location) #expand
{
    context.panicking = true;
    defer context.panicking = false;

    Assert(false, format_string, ..args, location = location);
}
@PrintLike
@NoProfile

Initialize :: inline (item : *$T)
{
    initializer :: initializer_of(T);
    #if initializer
        initializer(item);
    else
        memset(item, 0, size_of(T));
}
@NoProfile

Initialize :: inline (item : *$T, count : s64)
{
    initializer :: initializer_of(T);
    #if initializer
    {
        for i : 0..count - 1
            initializer(item + i);
    }
    else
    {
        memset(item, 0, size_of(T) * count);
    }
}
@NoProfile

OffsetOf :: inline ($T : Type, $member : string) -> s64 #no_context
{
    dummy := cast(*T) null;

    #insert #run SPrint("// OffsetOf %.%\nreturn cast(s64) *dummy.%;", T, member, member);
}
@NoProfile

DefaultValue :: inline ($T : Type) -> T #no_context
{
    val : T;

    return val;
}
@NoProfile

#scope_file

IsNumeric :: inline (type : Type) -> bool
{
    info := cast(*Type_Info) type;

    return info.type == .INTEGER || info.type == .FLOAT;
}
@NoProfile

#scope_export

Min :: inline (a : $T, b : T) -> T #no_context
#modify { return IsNumeric(T); }
{
    return ifx a < b then a else b;
}
@NoProfile

Max :: inline (a : $T, b : T) -> T #no_context
#modify { return IsNumeric(T); }
{
    return ifx a > b then a else b;
}
@NoProfile

MinMax :: inline (a : $T, b : T) -> min : T, max : T #no_context
#modify { return IsNumeric(T); }
{
    if a < b
        return a, b;
    else
        return b, a;
}
@NoProfile

Clamp :: inline (x : $T, min : T, max : T) -> T #no_context
#modify { return IsNumeric(T); }
{
    return Min(Max(x, min), max);
}
@NoProfile

Saturate :: inline (x : $T) -> T #no_context
#modify { return IsNumeric(T); }
{
    return Clamp(x, 0, 1);
}
@NoProfile

Abs :: inline (x : $T) -> T #no_context
#modify { return IsNumeric(T); }
{
    return ifx x < 0 then -x else x;
}
@NoProfile

Sign :: inline (x : $T) -> T #no_context
#modify { return IsNumeric(T); }
{
    return cast(T) ifx x < 0 then -1 else ifx x > 0 then 1 else 0;
}
@NoProfile

Lerp :: inline (a : float, b : float, t : float) -> float #no_context
{
    return a * (1 - t) + b * t;
}
@NoProfile

InverseLerp :: inline (a : float, b : float, t : float) -> float #no_context
{
    return (t - a) / (b - a);
}
@NoProfile

Round :: inline (value : float) -> float #no_context
{
    return cast(float) (cast(int) (value + Sign(value) * 0.5));
}
@NoProfile

SnapDown :: inline (value : float, grid_size : float) -> float #no_context
{
    Math :: #import "Math";

    push_context,defer_pop;

    return Math.floor(value / grid_size) * grid_size;
}
@NoProfile

Snap :: inline (value : float, grid_size : float) -> float #no_context
{
    return Round(value / grid_size) * grid_size;
}
@NoProfile

SnapUp :: inline (value : float, grid_size : float) -> float #no_context
{
    Math :: #import "Math";

    push_context,defer_pop;

    return Math.ceil(value / grid_size) * grid_size;
}
@NoProfile

Swap :: inline (a : *$T, b : *T) #no_context
{
    tmp := a.*;
    a.* = b.*;
    b.* = tmp;
}
@NoProfile

QuickSort :: inline (arr : []$T, user_data : $User, compare : (T, T, User) -> $R)
{
    QuickSortHelper :: (
        arr : []$T,
        left : s64, right : s64,
        user_data : $User,
        compare : (T, T, User) -> $R
    )
    #no_abc
    {
        if left < 0 || right <= left
            return;

        i := left;
        j := right;

        pivot := arr[(j + i) / 2];

        while true
        {
            while compare(arr[i], pivot, user_data) < 0
                i += 1;
            while compare(arr[j], pivot, user_data) > 0
                j -= 1;

            if i >= j
                break;

            tmp := arr[i];
            arr[i] = arr[j];
            arr[j] = tmp;

            i += 1;
            j -= 1;
        }

        QuickSortHelper(arr, left, j, user_data, compare);
        QuickSortHelper(arr, j + 1, right, user_data, compare);
    }

    if arr.count < 2
        return;

    QuickSortHelper(arr, 0, arr.count - 1, user_data, compare);
}

QuickSort :: inline (arr : []$T, compare : (T, T) -> $R)
{
    QuickSortHelper :: (
        arr : []$T,
        left : s64, right : s64,
        compare : (T, T) -> $R
    )
    #no_abc
    {
        if left < 0 || right <= left
            return;

        i := left;
        j := right;

        pivot := arr[(j + i) / 2];

        while true
        {
            while compare(arr[i], pivot) < 0
                i += 1;
            while compare(arr[j], pivot) > 0
                j -= 1;

            if i >= j
                break;

            tmp := arr[i];
            arr[i] = arr[j];
            arr[j] = tmp;

            i += 1;
            j -= 1;
        }

        QuickSortHelper(arr, left, j, compare);
        QuickSortHelper(arr, j + 1, right, compare);
    }

    if arr.count < 2
        return;

    QuickSortHelper(arr, 0, arr.count - 1, compare);
}
