// @Cleanup: factor the code that is common from Hash_Map and Hash_Set

#import "Common";
#import "Hash";

HashMap :: struct (
    Key : Type,
    Value : Type,
    HashType := u64,
    hash_func : (Key) -> HashType = null,
    comp_func : (Key, Key) -> bool = null,
    Load_Factor := 70
)
{
    #assert Load_Factor > 0 && Load_Factor < 100;

    Entry :: struct
    {
        hash  : HashType;
        key   : Key;
        value : Value;
    }

    count     : s64;
    allocated : s64;
    occupied  : s64;
    entries   : *Entry;
    allocator : Allocator;

    #if hash_func
        HashKey :: hash_func;
    else
        HashKey :: (key) => get_hash(key);

    #if comp_func
        CompareKeys :: comp_func;
    else
        CompareKeys :: (a, b) => a == b;
}

Hash_Map_Min_Capacity :: 32;
Hash_Map_Never_Occupied_Hash :: 0;
Hash_Map_Removed_Hash        :: 1;
Hash_Map_First_Occupied_Hash :: 2;

HashMapGetMinCapacityForElementCount :: inline (map : HashMap, count : s64) -> s64
{
    return HashMapGetMinCapacityForElementCount(map.Load_Factor, count);
}

HashMapGetMinCapacityForElementCount :: inline (load_factor : s64, count : s64) -> s64
{
    capacity := count + (count * (100 - load_factor)) / 100 + 1;
    capacity = Max(capacity, Hash_Map_Min_Capacity);

    pow := 1;
    while capacity > pow
        pow += pow;
    capacity = pow;

    return capacity;
}

HashMapInit :: inline (map : *HashMap, capacity : s64)
{
    Initialize(map);

    capacity = Max(capacity, Hash_Map_Min_Capacity);

    pow := 1;
    while capacity > pow
        pow += pow;
    capacity = pow;

    map.allocated = capacity;
    map.allocator = context.allocator;
    map.entries = Alloc(map.Entry, capacity);

    for i : 0..map.allocated - 1
        map.entries[i].hash = Hash_Map_Never_Occupied_Hash;
}

HashMapInitFromPreallocatedMemory :: inline (map : *HashMap, data : *void, capacity : s64, allocator : Allocator)
{
    Initialize(map);

    map.allocated = capacity;
    map.allocator = allocator;
    map.entries = data;

    for i : 0..map.allocated - 1
        map.entries[i].hash = Hash_Map_Never_Occupied_Hash;
}

HashMapFree :: inline (using map : *HashMap)
{
    Free(entries,, allocator);
    entries = null;
    count = 0;
    occupied = 0;
    allocated = 0;
}

HashMapClear :: inline (using map : *HashMap)
{
    count = 0;
    occupied = 0;

    for i : 0..allocated - 1
        entries[i].hash = Hash_Map_Never_Occupied_Hash;
}

HashMapGrow :: (map : *HashMap)
{
    if !map.allocator.proc
        map.allocator = context.allocator;

    old_entries : []map.Entry;
    old_entries.data = map.entries;
    old_entries.count = map.allocated;

    defer Free(old_entries.data,, map.allocator);

    new_capacity := Max(map.allocated * 2, Hash_Map_Min_Capacity);

    map.entries = Alloc(map.Entry, new_capacity,, map.allocator);
    map.count = 0;
    map.occupied = 0;
    map.allocated = new_capacity;

    for i : 0..map.allocated - 1
        map.entries[i].hash = Hash_Map_Never_Occupied_Hash;

    for entry : old_entries
    {
        if entry.hash >= Hash_Map_First_Occupied_Hash
            HashMapInsert(map, entry.key, entry.value);
    }
}

HashMapProbe :: (map : HashMap, key : map.Key) -> h : map.HashType, index : s64, is_present : bool
{
    Assert(map.allocated != 0);

    mask := cast, trunc(map.HashType) (map.allocated - 1);
    hash := map.HashKey(key);
    if hash < Hash_Map_First_Occupied_Hash
        hash += Hash_Map_First_Occupied_Hash;

    index := hash & mask;
    increment := 1 + (hash >> 27);
    while map.entries[index].hash != Hash_Map_Never_Occupied_Hash
    {
        entry := *map.entries[index];

        if entry.hash == hash && map.CompareKeys(entry.key, key)
            return hash, cast(s64) index, true;

        index += increment;
        index &= mask;
        increment += 1;
    }

    return hash, cast(s64) index, false;
}

HashMapInsert :: (map : *HashMap, key : map.Key, $initialize_if_new := true) -> *map.Value, was_present : bool
{
    if (map.occupied + 1) * 100 >= map.allocated * map.Load_Factor
        HashMapGrow(map);

    Assert(map.occupied <= map.allocated);
    hash, index, is_present := HashMapProbe(map, key);

    entry := *map.entries[index];
    if is_present
        return *entry.value, true;

    #if initialize_if_new
        Initialize(*entry.value);

    entry.hash = hash;
    entry.key = key;
    map.occupied += 1;
    map.count += 1;

    return *entry.value, false;
}

HashMapInsert :: inline (map : *HashMap, key : map.Key, value : map.Value) -> *map.Value, was_present : bool
{
    ptr, was_present := HashMapInsert(map, key, initialize_if_new = false);
    ptr.* = value;

    return ptr, was_present;
}

HashMapRemove :: inline (map : *HashMap, key : map.Key) -> found : bool, removed : map.Value
{
    if map.count == 0
        return false, DefaultValue(map.Value);

    hash, index, is_present := HashMapProbe(map, key);
    if !is_present
        return false, DefaultValue(map.Value);

    entry := *map.entries[index];
    entry.hash = Hash_Map_Removed_Hash;
    map.count -= 1;

    return true, entry.value;
}

HashMapSet :: inline (map : *HashMap, key : map.Key, value : map.Value)
{
    ptr := HashMapGetPtr(map, key);
    if ptr
        ptr.* = value;
}

HashMapGetPtr :: inline (map : *HashMap, key : map.Key) -> *map.Value
{
    if map.count == 0
        return null;

    hash, index, is_present := HashMapProbe(map, key);
    if is_present
        return *map.entries[index].value;

    return null;
}

HashMapGet :: inline (map : *HashMap, key : map.Key, fallback : map.Value) -> map.Value, found : bool
{
    ptr := HashMapGetPtr(map, key);
    if ptr
        return ptr.*, true;

    return fallback, false;
}

HashMapGet :: inline (map : *HashMap, key : map.Key) -> map.Value, found : bool
{
    ptr := HashMapGetPtr(map, key);
    if ptr
        return ptr.*, true;

    return DefaultValue(map.Value), false;
}

for_expansion :: (map : *HashMap, body : Code, flags : For_Flags) #expand
{
    entries : []map.Entry = ---;
    entries.data = map.entries;
    entries.count = map.allocated;

    for * <=((flags & .REVERSE) != 0) entry, i : entries
    {
        if entry.hash < Hash_Map_First_Occupied_Hash
            continue;

        `it_index := entry.key;
        #if (flags & .POINTER)
            `it := *entry.value;
        else
            `it := entry.value;

        #insert(remove = { entry.hash = Hash_Map_Removed_Hash; map.count -= 1; }) body;
    }
}
