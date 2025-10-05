#import "Common";
#import "Linked_List";

PagedArraySlotInfo :: struct
{
    version : u32;
    page_index : s32;
    slot_index : s32;
}

operator == :: inline (a : PagedArraySlotInfo, b : PagedArraySlotInfo) -> bool
{
    return a.version == b.version && a.page_index == b.page_index && a.slot_index == b.slot_index;
}

// @Todo: identify the access patterns of PagedArray (i.e. what slots are used
// when requesting sequentially, what slots are used after freeing a slot...)

// @Todo: review slot assignment, iteration is done in reverse order which is
// not ideal for cache friendliness

// @Todo @Memory: use smaller integer sizes where possible.
// Page_Size is supposed to be relatively small so we should
// make Page.count smaller than 8 bytes, as well as Slot.prev/next
// The integer type to use could be a struct parameter, and if it's
// void we use the smallest possible integer?
PagedArray :: struct (T : Type, Page_Size : int)
{
    Slot :: struct
    {
        // @Memory: could use relative pointers here
        prev : *Slot;
        next : *Slot;
        occupied : bool;
        version : u32;
    }

    Page :: struct
    {
        prev : *Page;
        next : *Page;
        index : s32;
        count : s64;
        slots : [Page_Size]Slot;
        items : [Page_Size]T = ---;
        free_slots : *Slot;
        occupied_slots : *Slot;
    }

    count : s64;
    all_pages : [..]*Page;
    free_pages : *Page;
    full_pages : *Page;
    allocator : Allocator;
}

#scope_file

EnsureInit :: inline (using array : *PagedArray)
{
    if !array.allocator.proc
    {
        array.allocator = context.allocator;
        array.all_pages.allocator = context.allocator;
    }
}

#scope_export

PagedArrayReset :: (using array : *PagedArray)
{
    EnsureInit(array);

    for page : all_pages
        Free(page,, allocator);

    ArrayFree(*all_pages);
    count = 0;
    free_pages = null;
    full_pages = null;
}

PagedArrayClearPage :: (using array : *PagedArray, page : *array.Page)
{
    EnsureInit(array);

    for * slot, si : page.slots
    {
        slot.occupied = false;

        if si != 0
            slot.prev = *page.slots[si - 1];
        else
            slot.prev = null;

        if si != Page_Size - 1
            slot.next = *page.slots[si + 1];
        else
            slot.next = null;
    }

    page.count = 0;
    page.free_slots = *page.slots[0];
    page.occupied_slots = null;
}

PagedArrayFindSlot :: (using array : *PagedArray, $initialize := true) -> *array.T, PagedArraySlotInfo, is_new_page : bool
{
    EnsureInit(array);

    is_new_page := false;

    page := free_pages;
    if !page
    {
        is_new_page = true;

        page = Alloc(Page,, allocator);

        ListPushFront(*free_pages, page);
        ArrayPush(*all_pages, page);

        page.index = cast(s32) (all_pages.count - 1);

        PagedArrayClearPage(array, page);
    }

    Assert(page.count < Page_Size, "Page is full even though it is in the free pages list");
    Assert(page.free_slots != null, "Could not find free slot even though the page is in the free pages list");

    slot := ListPopFront(*page.free_slots);
    Assert(!slot.occupied, "Slot is occupied");

    ListPushFront(*page.occupied_slots, slot);

    // If there are no more free slots, add the page to the full pages list
    if !page.free_slots
    {
        page = ListPopFront(*free_pages);
        ListPushFront(*full_pages, page);
    }

    slot.occupied = true;

    // We want version to never be 0 so handle overflow
    if slot.version == 0xffffffff
        slot.version = 1;
    else
        slot.version += 1;

    page.count += 1;

    count += 1;

    info : PagedArraySlotInfo;
    info.version = slot.version;
    info.page_index = page.index;
    info.slot_index = cast(s32) (slot - page.slots.data);

    item := *page.items[info.slot_index];

    #if initialize
        Initialize(item);

    return item, info, is_new_page;
}

PagedArrayFreeSlot :: (using array : *PagedArray, info : PagedArraySlotInfo, check_occupied := true, check_version := true)
{
    EnsureInit(array);

    page := all_pages[info.page_index];
    page_was_full := page.free_slots == null;

    slot := *page.slots[info.slot_index];
    Assert(!check_occupied || slot.occupied, "Freeing unoccupied slot %", info);
    Assert(!check_version || slot.version == info.version, "Mismatching version when freeing slot % (got %)", info, slot.version);

    slot.occupied = false;

    ListRemove(*page.occupied_slots, slot);
    ListPushFront(*page.free_slots, slot);

    // Add the page to the free pages list if it was full previously
    if page_was_full
    {
        ListRemove(*full_pages, page);
        ListPushFront(*free_pages, page);
    }

    page.count -= 1;
    count -= 1;
}

// This procedure cannot work for item sizes of 0
// The reason for this is that we cannot differentiate between items
// because they all have the same address.
PagedArrayFreeSlot :: inline (using array : *PagedArray($T, $N), item : *T)
#modify { return (cast(*Type_Info) T).runtime_size != 0, "This procedure cannot work for item sizes of 0"; }
{
    valid, info := PagedArrayGetSlotInfo(array, item);
    Assert(valid, "Item is not in paged array");

    PagedArrayFreeSlot(array, info);
}

PagedArrayFreeAllSlots :: (using array : *PagedArray)
{
    if count == 0 || all_pages.count == 0
        return;

    for page, i : all_pages
    {
        if i != 0
            page.prev = pages[i - 1];
        else
            page.prev = null;

        if i != pages.count - 1
            page.next = pages[i + 1];
        else
            page.next = null;

        PagedArrayClearPage(array, page);
    }

    free_pages = all_pages[0];
    full_pages = null;
}

// This procedure cannot work for item sizes of 0
// The reason for this is that we cannot differentiate between items
// because they all have the same address.
PagedArrayGetSlotInfo :: (using array : PagedArray($T, $N), item : *T) -> valid : bool, PagedArraySlotInfo, occupied : bool
#modify { return (cast(*Type_Info) T).runtime_size != 0, "This procedure cannot work for item sizes of 0"; }
{
    info : PagedArraySlotInfo;
    for page : all_pages
    {
        slot_index := ArrayGetIndex(page.items, item);

        if slot_index != -1
        {
            info.version = page.slots[slot_index].version;
            info.page_index = page.index;
            info.slot_index = cast(s32) slot_index;

            return true, info, page.slots[slot_index].occupied;
        }
    }

    return false, info, false;
}

PagedArrayIsSlotValid :: (using array : PagedArray, info : PagedArraySlotInfo) -> bool, invalid_indices : bool, not_occupied : bool, version_mismatch : bool
{
    if info.slot_index < 0 && info.slot_index >= Page_Size
        return false, true, false, false;

    if info.page_index < 0 || info.page_index >= all_pages.count
        return false, true, false, false;

    slot := *all_pages[info.page_index].slots[info.slot_index];

    if !slot.occupied || slot.version != info.version
        return false, false, !slot.occupied, slot.version != info.version;

    return true, false, false, false;
}

PagedArrayGetItem :: (using array : *PagedArray, info : PagedArraySlotInfo) -> *array.T
{
    Assert(info.slot_index >= 0 && info.slot_index < Page_Size, "Invalid slot index");
    Assert(info.page_index >= 0 && info.page_index < all_pages.count, "Invalid page index");

    slot := *all_pages[info.page_index].slots[info.slot_index];

    Assert(slot.occupied, "Slot is not occupied");
    Assert(slot.version == info.version, "Slot has different version (requested %, got %)", info.version, slot.version);

    return *all_pages[info.page_index].items[info.slot_index];
}

PagedArrayGetItemOrNull :: (using array : *PagedArray, info : PagedArraySlotInfo) -> *array.T
{
    Assert(info.slot_index >= 0 && info.slot_index < Page_Size, "Invalid slot index");
    Assert(info.page_index >= 0 && info.page_index < all_pages.count, "Invalid page index");

    slot := *all_pages[info.page_index].slots[info.slot_index];

    if !slot.occupied
        return null;

    if slot.version != info.version
        return null;

    return *all_pages[info.page_index].items[info.slot_index];
}

for_expansion :: (array : *PagedArray, body : Code, flags : For_Flags) #expand
{
    `it_index : PagedArraySlotInfo;

    for page, pi : array.all_pages
    {
        for slot, _ : page.occupied_slots
        {
            it_index.version = slot.version;
            it_index.page_index = cast(s32) pi;
            it_index.slot_index = cast(s32) (slot - page.slots.data);

            #if flags & .POINTER
                `it := *page.items[it_index.slot_index];
            else
                `it := page.items[it_index.slot_index];

            #insert(
                break = break page,
                remove = PagedArrayFreeSlot(array, it_index)
            ) body;
        }
    }
}
