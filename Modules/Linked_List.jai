#import "Common";

IsListNode :: (type : Type) -> bool
{
    IsPointerTo :: inline (type : *Type_Info, to : *Type_Info) -> bool
    {
        ptr_info := cast(*Type_Info_Pointer) type;

        return ptr_info.type == .POINTER && ptr_info.pointer_to == to;
    }

    info := cast(*Type_Info_Struct) type;
    if info.type != .STRUCT
        return false;

    prev_member, next_member : *Type_Info_Struct_Member;
    for * info.members
    {
        if it.name == "prev"
        {
            prev_member = it;
            if next_member
                break;
        }
        else if it.name == "next"
        {
            next_member = it;
            if prev_member
                break;
        }
    }

    if !prev_member || !next_member
        return false;

    return IsPointerTo(prev_member.type, info) && IsPointerTo(next_member.type, info);
}

ListPushFront :: (list : **$T, node : *T) -> *T
#modify { return IsListNode(T); }
{
    should_replace := !list.* || !list.*.prev;
    node.prev = null;
    node.next = null;

    if list.*
        ListInsertBefore(list.*, node);

    if should_replace
        list.* = node;

    return node;
}

ListRemove :: (list : **$T, node : *T)
#modify { return IsListNode(T); }
{
    prev := node.prev;
    next := node.next;
    ListNodeUnlink(node);

    if node == list.*
    {
        if next
            list.* = next;
        else
            list.* = prev;
    }
}

ListPopFront :: (list : **$T) -> *T
#modify { return IsListNode(T); }
{
    node := list.*;
    ListRemove(list, node);

    return node;
}

ListInsertBefore :: inline (before : *$T, node : *T)
#modify { return IsListNode(T); }
{
    node.prev = before.prev;
    node.next = before;

    if node.prev
        node.prev.next = node;

    node.next.prev = node;
}

ListInsertAfter :: inline (after : *$T, node : *T)
#modify { return IsListNode(T); }
{
    node.prev = after;
    node.next = after.next;
    node.prev.next = node;

    if node.next
        node.next.prev = node;
}

ListNodeUnlink :: inline (node : *$T)
#modify { return IsListNode(T); }
{
    if node.prev
        node.prev.next = node.next;

    if node.next
        node.next.prev = node.prev;

    node.prev = null;
    node.next = null;
}

for_expansion :: (list : *$T, body : Code, flags : For_Flags) #expand
#modify { return IsListNode(T); }
{
    `it := list;
    `it_index := 0;
    while it
    {
        #if flags & .REVERSE
            next := it.prev;
        else
            next := it.next;

        defer { it = next; it_index += 1; }

        #insert(
            remove = #assert false "Cannot remove an element because we only have a pointer to the first node, not the list itself. You can still use the pop routine to remove an element while iterating."
        ) body;
    }
}
