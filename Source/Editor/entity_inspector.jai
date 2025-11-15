g_show_entity_inspector := false;

ShowEntityInspector :: (world : *World, entity : *Entity) {
    if !g_show_entity_inspector {
        return;
    }

    defer ImGui.End();

    ImGui.SetNextWindowSize(.{450, 700}, .FirstUseEver);
    if !ImGui.Begin("Entity Inspector", *g_show_entity_inspector, flags=.HorizontalScrollbar | .NoFocusOnAppearing) {
        return;
    }

    if !entity {
        ImGui.Text("No entity selected");
        return;
    }

    ImGui.PushID(entity);
    defer ImGui.PopID();

    // Ugh...
    button_width := ImGui.GetContentRegionAvail().x * 0.5 - ImGui.GetStyle().FramePadding.x;

    PushButtonColor(.SubmitBadButton);
    if ImGui.Button("Delete", size=.{button_width,0}) {
        EditorDeleteEntity(world, entity.guid);
    }
    PopButtonColor();

    ImGui.SameLine();

    if ImGui.Button("Duplicate", size=.{button_width,0}) {
        entity = EditorDuplicateEntity(world, entity);
        SelectEntity(entity.guid);
    }

    ImGui.PushFont(g_editor_medium_font);
    available := ImGui.GetContentRegionAvail();
    size := available;
    size.y -= ImGui.GetFrameHeightWithSpacing();
    size.x = Max(size.x, 0);
    size.y = Max(size.y, 0);
    ImGui.PopFont();

    if ImGui.BeginChild("Properties", size=size, child_flags=.Border) {
        if BeginInspectorTable("entity_inspector") {
            defer ImGui.EndTable();

            BeginInspectorLine("Type");
            ImGui.Text("%", GetNiceEntityTypeName(entity));
            EndInspectorLine();

            name_buffer : [200]u8 = ---;
            name_len := Min(name_buffer.count - 1, entity.name.count);
            memcpy(name_buffer.data, entity.name.data, name_len);
            name_buffer[name_len] = 0;

            BeginInspectorLine("Name");

            if ImGui.InputTextWithHint("##entity_name", "Unnamed", name_buffer.data, name_buffer.count) {
                SetEntityName(world, entity, MakeString(name_buffer.data));
            }

            EndInspectorLine();

            ctx : InspectorContext;
            ctx.world = world;
            InitInspectorContext(*ctx, type_info(EntityGUID));

            ShowInspector("GUID", *ctx, entity.guid, notes=.["NotEditable"]);

            prev_parent := entity.parent;

            any : Any;
            any.type = cast(*Type_Info, GetEntityType(entity.index));
            any.value_pointer = entity;

            InitInspectorContext(*ctx, any.type);

            state := ShowInspector(null, *ctx, any, notes=.["InspectorNoTree"]);

            if prev_parent != entity.parent {
                new_parent_id := entity.parent;
                entity.parent = prev_parent;

                if new_parent_id == Null_Entity_GUID {
                    DetachEntity(world, entity);
                } else {
                    new_parent := GetEntity(world, new_parent_id);
                    if new_parent {
                        AttachEntity(world, entity, new_parent);
                    }
                }
            }

            if state {
                UpdateWorldTransform(world, entity);
            }
        }

        if entity.components.count > 0 {
            ImGui.PushStyleVar(.SeparatorTextAlign, .{0.5, 0.5});
            defer ImGui.PopStyleVar();

            ImGui.SeparatorText("Added Components");
        }

        for entity.components {
            any : Any;
            any.type = cast(*Type_Info, GetComponentType(it));
            any.value_pointer = it;

            label := CTPrint("%##%", GetNiceComponentTypeName(GetComponentTypeId(it)), it);
            opened := ImGui.CollapsingHeader(label);
            if ImGui.BeginPopupContextItem(CTPrint("%_context_menu", it)) {
                defer ImGui.EndPopup();

                if ImGui.MenuItem("Remove") {
                    RemoveComponent(world, it, entity);
                    continue;
                }
            }

            if opened {
                ShowInspector(null, world, any, notes=.["InspectorNoTree"]);
            }
        }
    }
    ImGui.EndChild();

    ImGui.PushFont(g_editor_medium_font);
    PushButtonColor(.EmphasisButton);
    if BeginButtonCombo("Add Component", size=.{-1,0}) {
        defer ImGui.EndCombo();

        ImGui.PushFont(g_editor_base_font);
        defer ImGui.PopFont();
        for i : 1..Component_Types.count - 1 {
            type_id := cast(ComponentTypeId, i);
            name := GetNiceComponentTypeName(type_id);

            if ImGui.MenuItem(CStringClone(name ,, Temp)) {
                AddComponent(world, type_id, entity);
            }
        }
    }
    PopButtonColor();
    ImGui.PopFont();
}
