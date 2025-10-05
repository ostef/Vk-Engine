#import "Common";

#scope_module

Basic :: #import "Basic";
ImGui :: #import "ImGui";

#scope_export

EnumCombo :: (label : *u8, current_item : *$T, ignore_last_value := false, popup_max_height_in_items: s32 = -1) -> bool
#modify { return (cast(*Type_Info) T).type == .ENUM, "T should be an enum type"; }
{
    enum_info := type_info(T);

    count := ifx ignore_last_value then enum_info.names.count - 1 else enum_info.names.count;
    names := AllocArray(*u8, count,, Temp);

    // @Todo: handle aliases
    for value_index : 0..count - 1
    {
        name := *names[value_index];
        name.* = StringCloneToCString(enum_info.names[value_index],, Temp);

        for i : 0..enum_info.names[value_index].count - 1
        {
            if (name.*)[i] == #char "_"
            {
                (name.*)[i] = #char " ";
            }
        }
    }

    s32_value := cast(s32) current_item.*;
    result := ImGui.Combo(label, *s32_value, names.data, xx names.count);
    current_item.* = cast(T) s32_value;

    return result;
}
