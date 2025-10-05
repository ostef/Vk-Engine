// @Cleanup: factor the code that is common from Hash_Map and Hash_Set

#import "Common";
#import "Hash";

HashSet :: struct (
    T : Type,
    HashType := u64,
    hash_func : (T) -> HashType = null,
    comp_func : (T, T) -> bool = null,
    Load_Factor := 70
)
{
    #assert Load_Factor > 0 && Load_Factor < 100;

    Entry :: struct
    {
        hash  : HashType;
        value : T;
    }

    count     : s64;
    allocated : s64;
    occupied  : s64;
    entries   : *Entry;
    allocator : Allocator;

    #if hash_func
        HashValue :: hash_func;
    else
        HashValue :: (key) => get_hash(key);

    #if comp_func
        CompareKeys :: comp_func;
    else
        CompareKeys :: (a, b) => a == b;
}

Hash_Set_Min_Capacity :: 32;
Hash_Set_Never_Occupied_Hash :: 0;
Hash_Set_Removed_Hash        :: 1;
Hash_Set_First_Occupied_Hash :: 2;

HashSetGetMinCapacityForElementCount :: inline (set : HashSet, count : s64) -> s64
{
    return HashSetGetMinCapacityForElementCount(set.Load_Factor, count);
}

HashSetGetMinCapacityForElementCount :: inline (load_factor : s64, count : s64) -> s64
{
    capacity := count + (count * (100 - load_factor)) / 100 + 1;
    capacity = Max(capacity, Hash_Set_Min_Capacity);

    pow := 1;
    while capacity > pow
        pow += pow;
    capacity = pow;

    return capacity;
}

HashSetInit :: inline (set : *HashSet, capacity : s64)
{
    Initialize(set);

    capacity = Max(capacity, Hash_Set_Min_Capacity);

    pow := 1;
    while capacity > pow
        pow += pow;
    capacity = pow;

    set.allocated = capacity;
    set.allocator = context.allocator;
    set.entries = Alloc(set.Entry, capacity);

    for i : 0..set.allocated - 1
        set.entries[i].hash = Hash_Set_Never_Occupied_Hash;
}

HashSetInitFromPreallocatedMemory :: inline (set : *HashSet, data : *void, capacity : s64, allocator : Allocator)
{
    Initialize(set);

    set.allocated = capacity;
    set.allocator = allocator;
    set.entries = data;

    for i : 0..set.allocated - 1
        set.entries[i].hash = Hash_Set_Never_Occupied_Hash;
}

HashSetFree :: inline (using set : *HashSet)
{
    Free(entries,, allocator);
    entries = null;
    count = 0;
    occupied = 0;
    allocated = 0;
}

HashSetClear :: inline (using set : *HashSet)
{
    count = 0;
    occupied = 0;

    for i : 0..allocated - 1
        entries[i].hash = Hash_Set_Never_Occupied_Hash;
}

HashSetGrow :: (set : *HashSet)
{
    if !set.allocator.proc
        set.allocator = context.allocator;

    old_entries : []set.Entry;
    old_entries.data = set.entries;
    old_entries.count = set.allocated;

    defer Free(old_entries.data,, set.allocator);

    new_capacity := Max(set.allocated * 2, Hash_Set_Min_Capacity);

    set.entries = Alloc(set.Entry, new_capacity,, set.allocator);
    set.count = 0;
    set.occupied = 0;
    set.allocated = new_capacity;

    for i : 0..set.allocated - 1
        set.entries[i].hash = Hash_Set_Never_Occupied_Hash;

    for entry : old_entries
    {
        if entry.hash >= Hash_Set_First_Occupied_Hash
            HashSetInsert(set, entry.value);
    }
}

HashSetProbe :: (set : HashSet, value : set.T) -> h : set.HashType, index : s64, is_present : bool
{
    mask := cast, trunc(set.HashType) (set.allocated - 1);
    hash := set.HashValue(value);
    if hash < Hash_Set_First_Occupied_Hash
        hash += Hash_Set_First_Occupied_Hash;

    index := hash & mask;
    increment := 1 + (hash >> 27);
    while set.entries[index].hash != Hash_Set_Never_Occupied_Hash
    {
        entry := *set.entries[index];

        if entry.hash == hash && set.CompareKeys(entry.value, value)
            return hash, cast(s64) index, true;

        index += increment;
        index &= mask;
        increment += 1;
    }

    return hash, cast(s64) index, false;
}

HashSetInsert :: (set : *HashSet, value : set.T) -> *set.T, was_present : bool
{
    if (set.occupied + 1) * 100 >= set.allocated * set.Load_Factor
        HashSetGrow(set);

    Assert(set.occupied <= set.allocated);
    hash, index, is_present := HashSetProbe(set, value);

    entry := *set.entries[index];
    entry.value = value;
    if is_present
        return *entry.value, true;

    entry.hash = hash;
    set.occupied += 1;
    set.count += 1;

    return *entry.value, false;
}

HashSetRemove :: inline (set : *HashSet, value : set.T) -> found : bool
{
    hash, index, is_present := HashSetProbe(set, value);
    if !is_present
        return false;

    entry := *set.entries[index];
    entry.hash = Hash_Set_Removed_Hash;
    set.count -= 1;

    return true;
}

HashSetGetPtr :: inline (set : *HashSet, value : set.T) -> *set.T
{
    if set.count == 0
        return null;

    hash, index, is_present := HashSetProbe(set, value);
    if is_present
        return *set.entries[index].value;

    return null;
}

for_expansion :: (set : *HashSet, body : Code, flags : For_Flags) #expand
{
    entries : []set.Entry = ---;
    entries.data = set.entries;
    entries.count = set.allocated;

    for * <=((flags & .REVERSE) != 0) entry, i : entries
    {
        if entry.hash < Hash_Set_First_Occupied_Hash
            continue;

        `it_index := i;
        #if (flags & .POINTER)
            `it := *entry.value;
        else
            `it := entry.value;

        #insert(remove = { entry.hash = Hash_Set_Removed_Hash; set.count -= 1; }) body;
    }
}
