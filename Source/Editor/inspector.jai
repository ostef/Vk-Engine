// @Todo: IntRange

CustomInspector :: struct {
    proc : CustomInspectorProc;
    data : *void;
}

InspectorContext :: struct {
    world : *World;
    toplevel_struct_type : *Type_Info_Struct;
    toplevel_struct_default_init_ptr : *void;
    absolute_offset : s64;
}

InitInspectorContext :: (using ctx : *InspectorContext, type : *Type_Info) {
    absolute_offset = 0;

    if type.type == .STRUCT {
        toplevel_struct_type = xx type;

        if toplevel_struct_type.initializer {
            toplevel_struct_default_init_ptr = Alloc(toplevel_struct_type.runtime_size ,, Temp);
            toplevel_struct_type.initializer(toplevel_struct_default_init_ptr);
        }
    }
}

ResetInspectorContext :: (using ctx : *InspectorContext) {
    toplevel_struct_type = null;
    toplevel_struct_default_init_ptr = null;
    absolute_offset = 0;
}

IsDefaultValue :: (using ctx : *InspectorContext, value : Any) -> bool {
    if !toplevel_struct_default_init_ptr {
        for i : 0..value.type.runtime_size - 1 {
            if cast(*u8, value.value_pointer)[i] != 0 {
                return false;
            }
        }

        return true;
    }

    return memcmp(value.value_pointer, toplevel_struct_default_init_ptr + absolute_offset, value.type.runtime_size) == 0;
}

ResetValue :: (using ctx : *InspectorContext, value : Any) {
    if !toplevel_struct_default_init_ptr {
        memset(value.value_pointer, 0, value.type.runtime_size);
        return;
    }

    memcpy(value.value_pointer, toplevel_struct_default_init_ptr + absolute_offset, value.type.runtime_size);
}

ResetButton :: (using ctx : *InspectorContext, value : Any) -> InteractionState {
    if IsDefaultValue(ctx, value) {
        return 0;
    }

    state : InteractionState;
    if ImGui.Button(Icon_Refresh_MDI) {
        ResetValue(ctx, value);

        state |= .Started;
        state |= .Submitted;
    }

    ImGui.SetItemTooltip("Reset value to default");

    return state;
}

// @Todo: move notes array to InspectorContext
CustomInspectorProc :: #type (label : *u8, ctx : *InspectorContext, any : Any, notes : []string, data : *void) -> InteractionState;

g_custom_inspectors_initialized : bool;
g_custom_inspectors : HashMap(*Type_Info, CustomInspector);

GetCustomInspectorForType :: inline (type : *Type_Info) -> *CustomInspector {
    result := HashMapGetPtr(*g_custom_inspectors, type);
    if result {
        return result;
    }

    if type.type == .STRUCT {
        poly_source := TypeGetSourcePolymorph(xx type);
        if poly_source {
            return HashMapGetPtr(*g_custom_inspectors, poly_source);
        }
    }

    return null;
}

RegisterCustomInspector :: (type : Type, proc : CustomInspectorProc, data : *void) -> bool {
    return RegisterCustomInspector(cast(*Type_Info) type, proc, data);
}

RegisterCustomInspector :: (type : *Type_Info, proc : CustomInspectorProc, data : *void) -> bool {
    inspector, exists := HashMapInsert(*g_custom_inspectors, type);
    if exists {
        return false;
    }

    inspector.proc = proc;
    inspector.data = data;

    return true;
}

UnregisterCustomInspector :: (type : Type) -> bool {
    return UnregisterCustomInspector(cast(*Type_Info) type);
}

UnregisterCustomInspector :: (type : *Type_Info) -> bool {
    return HashMapRemove(*g_custom_inspectors, type);
}

InspectEntityGUID :: (label : *u8, using ctx : *InspectorContext, any : Any, notes : []string, data : *void) -> InteractionState {
    guid := cast(*EntityGUID) any.value_pointer;

    g := ImGui.GetCurrentContext();

    not_editable := ArrayFindFirst(notes, "NotEditable") != -1;

    BeginInspectorLine(label);

    LabelTextButton(CTPrint("###inspector.%", MakeString(label)), "%", guid.*);

    state := LastItemInteractionState();

    if !not_editable {
        ImGui.SetItemTooltip("Drag and drop EntityGUID");
    }

    if ImGui.BeginDragDropSource() {
        ImGui.Text("Entity %", guid.*);

        ImGui.SetDragDropPayload("EntityGUID", guid, size_of(EntityGUID));
        ImGui.EndDragDropSource();
    }

    if !not_editable && !(g.LastItemData_.InFlags & .Disabled) && ImGui.BeginDragDropTarget() {
        payload := ImGui.AcceptDragDropPayload("EntityGUID");
        if payload {
            Assert(payload.DataSize == size_of(EntityGUID));
            guid.* = (cast(*EntityGUID) payload.Data).*;

            state |= .Started;
            state |= .Submitted;
        }

        ImGui.EndDragDropTarget();
    }

    if ImGui.BeginPopupContextItem(CTPrint("Entity %###context_menu", guid.*)) {
        defer ImGui.EndPopup();

        ImGui.BeginDisabled(guid.* == Null_Entity_GUID);
        if ImGui.MenuItem("Open In Inspector") {
            SelectEntity(guid, focus=false);
        }
        ImGui.EndDisabled();

        if ImGui.MenuItem("Copy entity GUID") {
            EditorCopyEntityGUID(guid.*);
        }

        if !not_editable {
            ImGui.BeginDisabled(!g_editor_has_copied_entity_guid);
            if ImGui.MenuItem("Paste entity GUID") {
                guid.* = g_editor_last_copied_entity_guid;
                state |= .Started;
                state |= .Submitted;
            }
            ImGui.EndDisabled();

            if ImGui.MenuItem("Clear") {
                guid.* = .{};
                state |= .Started;
                state |= .Submitted;
            }
        }
    }

    if !not_editable {
        state |= EndInspectorLineWithReset(ctx, any);
    } else {
        EndInspectorLine();
    }

    return state;
}

InspectSpatialComponent :: (label : *u8, using ctx : *InspectorContext, any : Any, notes : []string, data : *void) -> InteractionState {
    spatial := cast(*SpatialComponent, any.value_pointer);
    prev_local_position := spatial.local_position;
    prev_local_rotation := spatial.local_rotation;
    prev_local_scale := spatial.local_scale;

    state := ShowInspector(label, ctx, any, notes, use_custom_inspector=false);

    if !world {
        LogError("Inspecting spatial component but world is null");
        return state;
    }

    if spatial.local_position != prev_local_position
    || spatial.local_rotation != prev_local_rotation
    || spatial.local_scale    != prev_local_scale {
        entity := GetEntity(world, spatial.entity_index);
        if entity {
            UpdateWorldTransform(entity, spatial);
        }
    }

    return state;
}

InspectAssetPointer :: (label : *u8, using ctx : *InspectorContext, any : Any, notes : []string, data : *void) -> InteractionState {
    imgui_ctx := ImGui.GetCurrentContext();
    info_pointer := cast(*Type_Info_Pointer, Devariantize(any.type));
    info_asset := cast(*Type_Info_Struct, info_pointer.pointer_to);
    asset_type := cast(*Type, *GetAssetType(info_asset)).*;
    value := cast(**AssetCommonData, any.value_pointer).*;

    if !label {
        label = "<unnamed field>";
    }

    BeginInspectorLine(label);

    if !value {
        LabelTextButton(CTPrint("###inspector.%", MakeString(label)), "(null % asset)", asset_type);
    } else {
        LabelTextButton(CTPrint("###inspector.%", MakeString(label)), "%", value.asset_name);
    }

    if IsItemDoubleClicked() {
        allow_create := GetNote(notes, "AllowCreateAsset");
        OpenAssetBrowserPopupFor(asset_type, cast(**void, any.value_pointer), allow_create);
    }

    if ImGui.BeginDragDropSource() {
        if !value {
            ImGui.Text("% asset (null)", asset_type);
        } else {
            ImGui.Text("% asset '%'", asset_type, value.asset_name);
        }

        payload_type := CTPrint("%", asset_type);
        ImGui.SetDragDropPayload(payload_type, any.value_pointer, size_of(*void));
        ImGui.EndDragDropSource();
    }

    state := LastItemInteractionState();

    not_editable := ArrayFindFirst(notes, "NotEditable") != -1;
    if !not_editable && !(imgui_ctx.LastItemData_.InFlags & .Disabled) && ImGui.BeginDragDropTarget() {
        payload_type := CTPrint("%", asset_type);
        asset_payload := ImGui.AcceptDragDropPayload(payload_type);
        if asset_payload {
            Assert(asset_payload.DataSize == size_of(*void));

            RemoveRefDynamic(asset_type, value);

            cast(**void, any.value_pointer).* = cast(**void, asset_payload.Data).*;

            new_asset := cast(**void, any.value_pointer).*;
            if new_asset {
                AddRefDynamic(asset_type, new_asset);
            }

            state |= .Started;
            state |= .Submitted;
        }

        asset_name_payload := ImGui.AcceptDragDropPayload("Asset Name");
        if asset_name_payload {
            asset_name := MakeString(cast(*u8) asset_name_payload.Data);

            RemoveRefDynamic(asset_type, value);

            new_asset := LoadAssetDynamic(asset_type, asset_name);
            cast(**void, any.value_pointer).* = new_asset;

            state |= .Started;
            state |= .Submitted;
        }

        ImGui.EndDragDropTarget();
    }

    if ImGui.BeginPopupContextItem(CTPrint("Asset %###context_menu", asset_type)) {
        if !not_editable && ImGui.MenuItem("Clear") {
            RemoveRefDynamic(asset_type, value);
            cast(**void, any.value_pointer).* = null;

            state |= .Started;
            state |= .Submitted;
        }

        if ImGui.MenuItem("Re-export asset", enabled=value != null) {
            if !SaveAssetDynamic(asset_type, value) {
                LogError("Could not save asset '%'", value.asset_name);
            }
        }

        if asset_type == Material {
            if ImGui.MenuItem("Open In Material Editor", enabled=value != null) {
                OpenMaterialEditor(xx value);
            }
        }

        ImGui.EndPopup();
    }

    if !not_editable {
        old_asset := cast(**void, any.value_pointer).*;

        state |= EndInspectorLineWithReset(ctx, any);

        new_asset := cast(**void, any.value_pointer).*;

        if old_asset && old_asset != new_asset {
            RemoveRefDynamic(asset_type, old_asset);
        }

        if new_asset && old_asset != new_asset {
            AddRefDynamic(asset_type, new_asset);
        }
    } else {
        EndInspectorLine();
    }

    return state;
}

InspectAsset :: (label : *u8, using ctx : *InspectorContext, any : Any, notes : []string, data : *void) -> InteractionState {
    BeginInspectorLine(label);

    asset := cast(*AssetCommonData) any.value_pointer;
    if label {
        ImGui.Text("%", asset.asset_name);
    } else {
        ImGui.Text("%", asset.asset_name);
    }

    EndInspectorLine();

    return 0;
}

InspectQuatfAsEulerAngles :: (label : *u8, using ctx : *InspectorContext, any : Any, notes : []string, data : *void) -> InteractionState {
    return InspectQuaternionAsEulerAngles(label, ctx, cast(*Quatf) any.value_pointer, notes, data);
}

InspectQuatdAsEulerAngles :: (label : *u8, using ctx : *InspectorContext, any : Any, notes : []string, data : *void) -> InteractionState {
    return InspectQuaternionAsEulerAngles(label, ctx, cast(*Quatd) any.value_pointer, notes, data);
}

InspectQuaternionAsEulerAngles :: (label : *u8, using ctx : *InspectorContext, q : *$Q/Quat, notes : []string, data : *void) -> InteractionState {
    storage := ImGui.GetStateStorage();
    current_euler_x_store := ImGui.GetID(CTPrint("%.current.x", label));
    current_euler_y_store := ImGui.GetID(CTPrint("%.current.y", label));
    current_euler_z_store := ImGui.GetID(CTPrint("%.current.z", label));
    dragging_store := ImGui.GetID(CTPrint("%.dragging", label));

    Rotation_Order :: EulerAnglesRotationOrder.YXZ;

    euler_angles : Vec3(Q.T);
    if storage.GetBool(storage, dragging_store, false) {
        euler_angles = .{
            xx storage.GetFloat(storage, current_euler_x_store),
            xx storage.GetFloat(storage, current_euler_y_store),
            xx storage.GetFloat(storage, current_euler_z_store),
        };
    } else {
        euler_angles = ToEulerAngles(q, Rotation_Order);
        euler_angles = ToDegs(euler_angles);
    }

    // Just for aesthetic
    for * euler_angles.n {
        if it.* == -0.0 {
            it.* = 0.0;
        }
    }

    BeginInspectorLine(label);

    state, _, edited_value := DragVector(CTPrint("###inspector.%", MakeString(label)), euler_angles.n, step=0.1);

    EndInspectorLine();
    ImGui.TableSetColumnIndex(2);

    if ImGui.Button(Icon_Refresh_MDI) {
        q.* = .{};
        return .Started | .Submitted;
    }

    if edited_value >= 0 {
        storage.SetBool(storage, dragging_store, true);
        storage.SetFloat(storage, current_euler_x_store, xx euler_angles.x);
        storage.SetFloat(storage, current_euler_y_store, xx euler_angles.y);
        storage.SetFloat(storage, current_euler_z_store, xx euler_angles.z);

        q.* = QuatFromEulerAnglesOrdered(ToRads(euler_angles), Rotation_Order);
    } else {
        storage.SetBool(storage, dragging_store, false);
    }

    return state;
}

InitCustomInspectors :: () {
    RegisterCustomInspector(EntityGUID, InspectEntityGUID, null);
    RegisterCustomInspector(SpatialComponent, InspectSpatialComponent, null);
    RegisterCustomInspector(TypeGetSourcePolymorph(type_info(Asset(struct{}))), InspectAsset, null);
    RegisterCustomInspector(Quatf, InspectQuatfAsEulerAngles, null);
    RegisterCustomInspector(Quatd, InspectQuatdAsEulerAngles, null);

    g_custom_inspectors_initialized = true;
}

Capitalize :: (str : string) -> string {
    first_letter := true;
    for i : 0..str.count - 1 {
        if Basic.is_alpha(str[i]) {
            if first_letter {
                str[i] = Basic.to_upper(str[i]);
                first_letter = false;
            }
        }

        if str[i] == #char "_" {
            str[i] = #char " ";
            first_letter = true;
        }
    }

    return str;
}

NewInspectorLine :: () {
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(0);
}

BeginInspectorLine :: (label : *u8) {
    ImGui.TableNextRow();

    ImGui.TableSetColumnIndex(0);

    // Do the label logic ourselves so we can center it
    window := ImGui.GetCurrentWindow();
    style := ImGui.GetStyle();

    label_size := ImGui.CalcTextSize(label, null, true);

    pos := window.DC.CursorPos;
    bb := ImGui.ImRect.{
        pos,
        pos + label_size + style.FramePadding * 2
    };

    ImGui.ItemSize(bb.Max - bb.Min, style.FramePadding.y);

    if label_size.x > 0 {
        ImGui.RenderTextClipped(bb.Min + .{0, style.FramePadding.y}, bb.Max, MakeString(label), *label_size);
    }

    ImGui.TableSetColumnIndex(1);
    ImGui.PushItemWidth(-1);
}

EndInspectorLine :: () {
    ImGui.PopItemWidth();
}

EndInspectorLineWithReset :: (ctx : *InspectorContext, any : Any) -> InteractionState {
    ImGui.PopItemWidth();

    ImGui.TableSetColumnIndex(2);

    return ResetButton(ctx, any);
}

InspectorTableFlags :: enum_flags {
    NoReset;
}

Default_Inspector_Table_Flags :: ImGui.TableFlags.Resizable | .RowBg | .PadOuterX | .NoBordersInBodyUntilResize;

BeginInspectorTable :: (id : *u8, flags : InspectorTableFlags = 0, table_flags := Default_Inspector_Table_Flags) -> bool {
    if ImGui.BeginTable(id, 3, table_flags | .Hideable) {
        ImGui.TableSetupColumn("Name", .WidthStretch, 0.4);
        ImGui.TableSetupColumn("Value", .WidthStretch | .NoResize, 0.6);

        reset_button_width := ImGui.CalcTextSize(Icon_Refresh_MDI).x + ImGui.GetStyle().ItemInnerSpacing.x + ImGui.GetStyle().FramePadding.x;
        column_flags := ImGui.TableColumnFlags.WidthFixed | .NoResize;
        if flags & .NoReset {
            column_flags |= .DefaultHide;
        }

        ImGui.TableSetupColumn("Reset", column_flags, reset_button_width);

        return true;
    }

    return false;
}

ShowInspector :: (label : *u8, world : *World, any : Any, notes : []string = .[], use_custom_inspector := true) -> InteractionState {
    type := Devariantize(any.type);

    ctx : InspectorContext;
    ctx.world = world;
    InitInspectorContext(*ctx, any.type);

    if BeginInspectorTable("inspector") {
        defer ImGui.EndTable();

        return ShowInspector(label, *ctx, any, notes, use_custom_inspector);
    }

    return 0;
}

ShowInspector :: (label : *u8, using ctx : *InspectorContext, any : Any, notes : []string = .[], use_custom_inspector := true) -> InteractionState {
    if !g_custom_inspectors_initialized {
        InitCustomInspectors();
    }

    ImGui.PushID(any.value_pointer);
    defer ImGui.PopID();

    old_ctx := ctx.*;
    defer ctx.* = old_ctx;

    if !label {
        label = "<unnamed field>";
    }

    custom_inspector := ifx use_custom_inspector then GetCustomInspectorForType(any.type);
    if custom_inspector {
        return custom_inspector.proc(label, ctx, any, notes, custom_inspector.data);
    }

    type := Devariantize(any.type);
    ptr := any.value_pointer;

    no_tree := ArrayFindFirst(notes, "InspectorNoTree") != -1;

    custom_inspector = ifx use_custom_inspector then GetCustomInspectorForType(any.type);
    if custom_inspector {
        return custom_inspector.proc(label, ctx, any, notes, custom_inspector.data);
    }

    if (type == type_info(Vec3f) || type == type_info(Vec4f))
    && ArrayFindFirst(notes, "ColorEdit") != -1 {
        BeginInspectorLine(label);
        id := CTPrint("###inspector.%", MakeString(label));

        if type == type_info(Vec3f) {
            ImGui.ColorEdit3(id, cast(*[3]float, ptr));
        } else {
            ImGui.ColorEdit4(id, cast(*[4]float, ptr));
        }

        state := LastItemInteractionState();
        state |= EndInspectorLineWithReset(ctx, any);

        return state;
    }

    if #complete type.type == {
    case .BOOL;
        BeginInspectorLine(label);
        id := CTPrint("###inspector.%", MakeString(label));

        ImGui.Checkbox(id, cast(*bool) ptr);

        state := LastItemInteractionState();
        state |= EndInspectorLineWithReset(ctx, any);

        return state;

    case .INTEGER;
        BeginInspectorLine(label);
        id := CTPrint("###inspector.%", MakeString(label));

        int_info := cast(*Type_Info_Integer) type;
        if int_info.signed {
            if type.runtime_size == {
            case 1; ImGui.DragScalar(id, .S8, ptr);
            case 2; ImGui.DragScalar(id, .S16, ptr);
            case 4; ImGui.DragScalar(id, .S32, ptr);
            case 8; ImGui.DragScalar(id, .S64, ptr);
            }
        } else {
            if type.runtime_size == {
            case 1; ImGui.DragScalar(id, .U8, ptr);
            case 2; ImGui.DragScalar(id, .U16, ptr);
            case 4; ImGui.DragScalar(id, .U32, ptr);
            case 8; ImGui.DragScalar(id, .U64, ptr);
            }
        }

        state := LastItemInteractionState();
        state |= EndInspectorLineWithReset(ctx, any);

        return state;

    case .FLOAT;
        min, max : float64;
        has_range := false;
        speed := 0.1;

        for notes {
            // @Todo: Use GetNote/ParseNote
            if StringStartsWith(it, "FloatRange(") && it[it.count - 1] == #char ")" {
                str := StringAdvance(it, "FloatRange(".count);
                str.count -= 1;

                val, ok, remainder := Basic.string_to_float64(str);
                if !ok || remainder.count == 0 || remainder[0] != #char "," {
                    break;
                }

                str = StringAdvance(remainder, 1);
                val2:, ok, remainder = Basic.string_to_float64(str);
                if !ok || remainder.count > 0 {
                    break;
                }

                min = val;
                max = val2;
                has_range = true;

                break;
            }

            speed_note, speed_value := ParseNote(it, "Step", float);
            if speed_note {
                speed = speed_value;
            }
        }

        BeginInspectorLine(label);
        id := CTPrint("###inspector.%", MakeString(label));

        if type.runtime_size == 4 {
            min32 := cast(float) min;
            max32 := cast(float) max;
            p_min, p_max : *float;
            if has_range {
                p_min = *min32;
                p_max = *max32;
            }

            ImGui.DragScalar(id, .Float, ptr, v_speed=speed, p_min=p_min, p_max=p_max);
        } else {
            p_min, p_max : *float64;
            if has_range {
                p_min = *min;
                p_max = *max;
            }

            ImGui.DragScalar(id, .Double, ptr, p_min=p_min, p_max=p_max);
        }

        state := LastItemInteractionState();
        state |= EndInspectorLineWithReset(ctx, any);

        return state;

    case .STRUCT;
        struct_info := cast(*Type_Info_Struct) type;
        if struct_info.textual_flags & .UNION {
            return 0;
        }

        ImGui.PushID(ptr);
        defer ImGui.PopID();

        if !toplevel_struct_type {
            InitInspectorContext(ctx, struct_info);
        }

        state : InteractionState;
        is_vector, vector_T, vector_N := GetVectorTypeInfo(struct_info);
        if is_vector {
            has_speed, speed := GetNote(notes, "Step", float);
            if !has_speed {
                speed = 0.01;
            }

            BeginInspectorLine(label);
            id := CTPrint("###inspector.%", MakeString(label));

            state = DragVector(id, TypeInfoToImGuiDataType(vector_T), ptr, xx vector_N, speed);

            state |= EndInspectorLineWithReset(ctx, any);

            return state;
        }

        opened := true;
        if !no_tree {
            NewInspectorLine();
            opened = ImGui.TreeNodeEx(label, .SpanAllColumns);
        }

        if opened {
            highest_offset := -1;
            for struct_info.members {
                if it.flags & .CONSTANT || it.offset_in_bytes <= highest_offset {
                    continue;
                }

                no_custom_inspector := false;
                not_editable := false;
                member_no_tree := false;
                color_edit := false;
                found_serialize_note := false;
                show_in_inspector := false;
                for note : it.notes {
                    if StringStartsWith(note, "Serialize(") {
                        found_serialize_note = true;
                    }

                    if note == {
                    case "ShowInInspector";
                        show_in_inspector = true;
                    case "HideInInspector";
                        continue it;
                    case "NoCustomInspector";
                        no_custom_inspector = true;
                    case "NotEditable";
                        not_editable = true;
                    case "InspectorNoTree";
                        member_no_tree = true;
                    case "ColorEdit";
                        color_edit = true;
                    }
                }

                if !found_serialize_note && !show_in_inspector {
                    continue it;
                }

                highest_offset = it.offset_in_bytes;

                ImGui.BeginDisabled(not_editable);
                defer ImGui.EndDisabled();

                item : Any;
                item.type = it.type;
                item.value_pointer = ptr + it.offset_in_bytes;

                member_label : *u8;
                if it.type.type == .POINTER && IsInComponentTypesArray(cast(*Type, *cast(*Type_Info_Pointer, it.type).pointer_to).*) {
                    component_type := cast(*Type, *cast(*Type_Info_Pointer, it.type).pointer_to).*;
                    component_name := GetNiceComponentTypeName(GetComponentTypeId(component_type));
                    member_label = ifx it.name && it.name != "_" then CTPrint("% (% component)", it.name, component_name);
                } else {
                    member_label = ifx it.name && it.name != "_" then CStringClone(it.name ,, Temp);
                }

                member_label = Capitalize(MakeString(member_label)).data;

                absolute_offset = old_ctx.absolute_offset + it.offset_in_bytes;

                state |= ShowInspector(member_label, ctx, item, notes=it.notes, use_custom_inspector=!no_custom_inspector);
            }
        }

        if !no_tree && opened {
            ImGui.TreePop();
        }

        return state;

    case .POINTER;
        info_pointer := cast(*Type_Info_Pointer, type);
        value := cast(**void, ptr).*;

        ResetInspectorContext(ctx); // Reset context, ResetValue assumes data to be continuous so we cannot go through pointers

        // Special case for *Asset types
        if info_pointer.pointer_to.type == .STRUCT
        && TypeGetSourcePolymorph(xx info_pointer.pointer_to) == TypeGetSourcePolymorph(type_info(DummyAsset)) {
            return InspectAssetPointer(label, ctx, any, notes, null);
        } else if !value {
            BeginInspectorLine(label);
            ImGui.Text("(null)");
            EndInspectorLine();

            return 0;
        }

        pointer : Any;
        pointer.type = info_pointer.pointer_to;
        pointer.value_pointer = value;

        return ShowInspector(label, ctx, pointer, notes=notes, use_custom_inspector=use_custom_inspector);

    case .STRING;
        BeginInspectorLine(label);
        ImGui.Text("%", any);
        EndInspectorLine();

    case .ARRAY;
        array_info := cast(*Type_Info_Array) type;
        array_data := null;
        array_count := -1;
        resizable := false;

        if array_info.array_type == {
        case .FIXED;
            array_data = ptr;
            array_count = array_info.array_count;
        case .VIEW;
            array_data = (cast(*Array_View_64) ptr).data;
            array_count = (cast(*Array_View_64) ptr).count;
            ResetInspectorContext(ctx); // Reset context, ResetValue assumes data to be continuous so we cannot go through pointers
        case .RESIZABLE;
            array_data = (cast(*Resizable_Array) ptr).data;
            array_count = (cast(*Resizable_Array) ptr).count;
            resizable = true;
            ResetInspectorContext(ctx); // Reset context, ResetValue assumes data to be continuous so we cannot go through pointers
        }

        state : InteractionState;

        opened := true;
        if !no_tree {
            NewInspectorLine();
            opened = ImGui.TreeNodeEx(label);
        }

        if opened {
            for i : 0..array_info.array_count - 1 {
                item : Any;
                item.value_pointer = ptr + i * array_info.element_type.runtime_size;
                item.type = array_info.element_type;
                item_label : *u8;

                if no_tree {
                    if !label {
                        item_label = CTPrint("<unnamed field> [%]", i);
                    } else {
                        item_label = CTPrint("% [%]", MakeString(label), i);
                    }
                } else {
                    item_label = CTPrint("[%]", i);
                }

                absolute_offset = old_ctx.absolute_offset + i * array_info.element_type.runtime_size;

                state |= ShowInspector(item_label, ctx, item, notes=notes, use_custom_inspector=use_custom_inspector);
            }
        }

        if !no_tree && opened {
            ImGui.TreePop();
        }

        return state;

    case .ENUM;
        enum_info := cast(*Type_Info_Enum, type);
        is_flags := enum_info.enum_type_flags & .FLAGS != 0;

        current_value := 0;
        if enum_info.runtime_size == {
        case 1; current_value = cast(s64) (cast(*s8)  ptr).*;
        case 2; current_value = cast(s64) (cast(*s16) ptr).*;
        case 4; current_value = cast(s64) (cast(*s32) ptr).*;
        case 8; current_value = cast(s64) (cast(*s64) ptr).*;
        }

        BeginInspectorLine(label);
        id := CTPrint("###inspector.%", MakeString(label));

        state : InteractionState;
        if ImGui.BeginCombo(id, CTPrint("%", any)) {
            for enum_info.values {
                name := enum_info.names[it_index];
                selected := ifx is_flags then current_value & it == it else current_value == it;
                if ImGui.MenuItem(CStringClone(name ,, Temp), selected=selected) {
                    if enum_info.enum_type_flags & .FLAGS {
                        if !selected {
                            if enum_info.runtime_size == {
                            case 1; cast(*s8,  ptr).* |= xx it;
                            case 2; cast(*s16, ptr).* |= xx it;
                            case 4; cast(*s32, ptr).* |= xx it;
                            case 8; cast(*s64, ptr).* |= xx it;
                            }
                        } else {
                            if enum_info.runtime_size == {
                            case 1; cast(*s8,  ptr).* &= ~cast(s8,  it);
                            case 2; cast(*s16, ptr).* &= ~cast(s16, it);
                            case 4; cast(*s32, ptr).* &= ~cast(s32, it);
                            case 8; cast(*s64, ptr).* &= ~cast(s64, it);
                            }
                        }
                    } else {
                        if enum_info.runtime_size == {
                        case 1; cast(*s8,  ptr).* = xx it;
                        case 2; cast(*s16, ptr).* = xx it;
                        case 4; cast(*s32, ptr).* = xx it;
                        case 8; cast(*s64, ptr).* = xx it;
                        }
                    }
                }

                state |= LastItemInteractionState();
            }

            ImGui.EndCombo();
        }

        state |= EndInspectorLineWithReset(ctx, any);

        return state;

    // Below are the types we cannot inspect
    case .ANY;
    case .VARIANT;
    case .PROCEDURE;
    case .OVERLOAD_SET;
    case .POLYMORPHIC_VARIABLE;
    case .TYPE;
    case .CODE;
    case .VOID;
    case .UNTYPED_ENUM;
    case .UNTYPED_LITERAL;
    }

    return 0;
}
