AllocOrNull :: inline (size : s64) -> *void
{
    if size <= 0
        return null;

    return context.allocator.proc(.ALLOCATE, size, 0, null, context.allocator.data);
}

Alloc :: inline (size : s64) -> *void
{
    if size <= 0
        return null;

    ptr := context.allocator.proc(.ALLOCATE, size, 0, null, context.allocator.data);
    Assert(ptr != null, "Allocator % could not allocate % bytes", GetAllocatorName(context.allocator), size);

    #if Basic.MEMORY_DEBUGGER
        Basic.Memory_Debugger.check_alloc(context.allocator, ptr, size);

    return ptr;
}

Alloc :: inline ($T : Type, $initialize := true) -> *T
{
    ptr := cast(*T) Alloc(size_of(T));
    #if initialize
        Initialize(ptr);

    return ptr;
}

Alloc :: inline ($T : Type, count : s64, $initialize := false) -> *T
{
    ptr := cast(*T) Alloc(size_of(T) * count);
    #if initialize
        Initialize(ptr, count);

    return ptr;
}

AllocArray :: inline ($T : Type, count : s64, $initialize := false) -> []T
{
    result : []T = ---;
    result.data = Alloc(T, count, initialize);
    result.count = count;

    return result;
}

Free :: inline (ptr : *void)
{
    if !ptr
        return;

    #if Basic.MEMORY_DEBUGGER
        Basic.Memory_Debugger.check_free(context.allocator, ptr);

    context.allocator.proc(.FREE, 0, 0, ptr, context.allocator.data);
}

Realloc :: inline (ptr : *void, old_size : s64, size : s64) -> *void
{
    new_ptr := context.allocator.proc(.RESIZE, size, old_size, ptr, context.allocator.data);
    Assert(new_ptr != null, "Allocator % failed to reallocate % bytes (previous size was %)", GetAllocatorName(context.allocator), size, old_size);

    #if Basic.MEMORY_DEBUGGER
        Basic.Memory_Debugger.check_realloc(context.allocator, ptr, old_size, new_ptr, size);

    return new_ptr;
}

GetAllocatorName :: inline (allocator : Allocator) -> string
{
    name : string;
    allocator.proc(.CAPS, 0, 0, *name, allocator.data);

    return name;
}

GetAllocatorSpecs :: inline (allocator : Allocator) -> Allocator_Caps
{
    return cast, no_check(Allocator_Caps) allocator.proc(.CAPS, 0, 0, null, allocator.data);
}

Trap :: Allocator.{ proc = TrapAllocatorProc, data = null };

TrapAllocator :: inline (message : *u8) -> Allocator
{
    return .{data = message, proc = TrapAllocatorProc };
}

TrapAllocatorProc :: (mode : Allocator_Mode, requested_size : s64, old_size : s64, ptr : *void, allocator_data : *void) -> *void
{
    if mode == .CAPS
    {
        name_ptr := cast(*string) ptr;
        name_ptr.* = "Trap Allocator";
    }
    else if mode == .ALLOCATE || mode == .RESIZE
    {
        message := MakeString(cast(*u8) allocator_data);
        if message
            Panic("Triggered an allocation trap: %", message);
        else
            Panic("Triggered an allocation trap");
    }

    return null;
}

AllocatorScope :: (allocator : Allocator) #expand
{
    prev := context.allocator;
    context.allocator = allocator;
    `defer context.allocator = prev;
}

#scope_module

Basic :: #import "Basic";

#scope_export

Temp :: Basic.temp;

Temporary_Storage_State :: Basic.Temporary_Storage_State;

TemporaryAlloc :: Basic.temporary_allocator_proc;
GetTemporaryStorageState :: Basic.get_temporary_storage_mark;
SetTemporaryStorageState :: Basic.set_temporary_storage_mark;
ResetTemporaryStorage :: Basic.reset_temporary_storage;

TemporaryStorageScope :: () #expand
{
    state := GetTemporaryStorageState();
    `defer SetTemporaryStorageState(state);
}
