EntityOutlinerState :: struct {
    opened := true; @Serialize(1)

    filter_text : [100]u8; @Serialize(2)
    filter_case_sensitive : bool; @Serialize(3)
}

g_entity_outliner : EntityOutlinerState;

EditorCopyEntityGUID :: inline (guid : EntityGUID) {
    g_editor_last_copied_entity_guid = guid;
    g_editor_has_copied_entity_guid = true;

    SDL_SetClipboardText(CTPrint("%", guid));
}

EditorDeleteEntity :: (world : *World, guid : EntityGUID) {
    entity := GetEntity(world, guid);
    if entity {
        for entity.children {
            child := GetEntity(world, it);
            if child {
                EditorDeleteEntity(world, child);
            }
        }
    }

    KillEntity(world, guid);
}

EditorDuplicateEntity :: (world : *World, entity : *Entity, location := #caller_location) -> *Entity {
    serializer : Serializer;
    serializer.builder.allocator = Temp;

    SerializeEntity(*serializer, entity);

    str := StringBuilderBuild(*serializer ,, Temp);

    new_entity := SpawnEntity(world, GetEntityTypeId(entity.index));
    cached_guid := new_entity.guid;

    result := DeserializeEntity(str, world, new_entity);
    if !result.ok {
        LogError("There were errors when deserializing for duplicating entity:\n%:%: %",
            result.line_index, result.byte_index, result.error_msg);
    }

    new_entity.guid = cached_guid;
    UpdateWorldTransform(world, new_entity);

    if new_entity.name {
        name := new_entity.name;
        new_entity.name = "";
        SetEntityName(world, new_entity, name);
        Free(name.data);
    }

    if new_entity.parent != Null_Entity_GUID {
        parent_id := entity.parent;
        new_entity.parent = .{};

        parent, err := GetEntity(world, *parent_id);
        if !parent {
            LogError("Entity does not exist %", parent_id);
        } else {
            AttachEntity(world, new_entity, parent);
        }
    }

    return new_entity;
}

AppendPascalCaseToCapitalized :: (builder : *StringBuilder, str : string) {
    for curr : str {
        Case :: enum {
            NotAlpha;
            Lower;
            Upper;
        }

        GetCase :: (char : u8) -> Case {
            if char >= #char "A" && char <= #char "Z" {
                return .Upper;
            }

            if char >= #char "a" && char <= #char "z" {
                return .Lower;
            }

            return .NotAlpha;
        }

        if it_index > 0 {
            prev := str[it_index - 1];
            if GetCase(prev) == .Lower && GetCase(curr) != .Lower {
                Append(builder, " ");
            }
        }

        c := string.{data=*curr, count=1};
        Append(builder, "%", c);
    }
}

GetNiceEntityTypeName :: inline (entity : *Entity) -> string {
    return GetNiceEntityTypeName(GetEntityTypeId(entity.index));
}

GetNiceEntityTypeName :: (type_id : EntityTypeId) -> string {
    #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "Entity_Nice_Type_Names :: string.[");
        Appendln(*builder, "    \"Invalid\",");

        for i : 1..Entity_Types.count - 1 {
            name := type_info(EntityTypeId).names[i];
            if StringEndsWith(name, "Entity") {
                name.count -= "Entity".count;
                if name.count > 0 && name[name.count - 1] == #char "_" {
                    name.count -= 1;
                }
            }

            Append(*builder, "    \"");
            AppendPascalCaseToCapitalized(*builder, name);
            Appendln(*builder, "\",");
        }

        Appendln(*builder, "];");

        return StringBuilderBuild(*builder);
    }

    return Entity_Nice_Type_Names[type_id];
}

GetNiceComponentTypeName :: (type_id : ComponentTypeId) -> string {
    #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "Component_Nice_Type_Names :: string.[");
        Appendln(*builder, "    \"Invalid\",");

        for i : 1..Component_Types.count - 1 {
            name := type_info(ComponentTypeId).names[i];
            if StringEndsWith(name, "Component") {
                name.count -= "Component".count;
                if name.count > 0 && name[name.count - 1] == #char "_" {
                    name.count -= 1;
                }
            }

            Append(*builder, "    \"");
            AppendPascalCaseToCapitalized(*builder, name);
            Appendln(*builder, "\",");
        }

        Appendln(*builder, "];");

        return StringBuilderBuild(*builder);
    }

    return Component_Nice_Type_Names[type_id];
}

ShowEntityOutliner :: (world : *World) {
    if !g_entity_outliner.opened {
        return;
    }

    defer ImGui.End();

    ImGui.SetNextWindowSize(.{350, 700}, .FirstUseEver);
    if !ImGui.Begin("Entity Outliner", *g_entity_outliner.opened) {
        return;
    }

    ImGui.InputText("Filter", g_entity_outliner.filter_text.data, xx g_entity_outliner.filter_text.count);
    ImGui.SameLine();
    Toggle("Aa", *g_entity_outliner.filter_case_sensitive);

    ImGui.SetItemTooltip(ifx g_entity_outliner.filter_case_sensitive
        then "Disable case sensitive filter"
        else "Enable case sensitive filter"
    );

    ImGui.PushFont(g_editor_medium_font);
    PushButtonColor(.EmphasisButton);
    if BeginButtonCombo("Add Entity", size=.{-1,0}) {
        defer ImGui.EndCombo();

        ImGui.PushFont(g_editor_base_font);
        defer ImGui.PopFont();
        for i : 1..Entity_Types.count - 1 {
            type_id := cast(EntityTypeId, i);
            name := GetNiceEntityTypeName(type_id);

            if ImGui.MenuItem(CStringClone(name ,, Temp)) {
                entity := SpawnEntity(world, type_id);
                SelectEntity(entity.guid);
            }
        }
    }
    PopButtonColor();
    ImGui.PopFont();

    defer ImGui.EndChild();
    if !ImGui.BeginChild("Outliner", child_flags=.Border, window_flags=.HorizontalScrollbar) {
        return;
    }

    EntityGUIDSet :: HashSet(
        EntityGUID,
        hash_func = HashEntityGUID,
        comp_func = CompareEntityGUIDs
    );

    already_shown_entities : EntityGUIDSet;
    already_shown_entities.allocator = Temp;

    VisitEntity :: (world : *World, entity : *Entity, already_shown_entities : *EntityGUIDSet) {
        HashSetInsert(already_shown_entities, entity.guid);

        for entity.children {
            child := GetEntity(world, it);
            VisitEntity(world, child, already_shown_entities);
        }
    }

    ShowEntity :: (world : *World, entity : *Entity, already_shown_entities : *EntityGUIDSet) {
        if HashSetGetPtr(already_shown_entities, entity.guid) {
            return;
        }

        HashSetInsert(already_shown_entities, entity.guid);

        label := ifx entity.name
            then CStringClone(entity.name ,, Temp)
            else CTPrint("<%>##%", GetNiceEntityTypeName(entity), entity.guid);

        flags := ImGui.TreeNodeFlags.OpenOnArrow | .SpanFullWidth;
        if entity.children.count == 0 {
            flags |= .Leaf;
        }

        if EntityIsSelected(entity.guid) {
            flags |= .Selected;
        }

        filter := MakeString(g_entity_outliner.filter_text.data);
        pass_filter := FilterTest(g_entity_outliner.filter_case_sensitive, entity.name, filter);
        pass_filter ||= FilterTest(g_entity_outliner.filter_case_sensitive, TPrint("%", GetNiceEntityTypeName(entity)), filter);
        pass_filter ||= FilterTest(g_entity_outliner.filter_case_sensitive, TPrint("%", entity.guid), filter);

        opened : bool;
        if pass_filter {
            opened = ImGui.TreeNodeEx(label, flags);
            if entity.name {
                ImGui.SetItemTooltip("<%> % %", GetNiceEntityTypeName(entity), entity.name, entity.guid);
            } else {
                ImGui.SetItemTooltip("<%> %", GetNiceEntityTypeName(entity), entity.guid);
            }

            if ImGui.BeginPopupContextItem(CTPrint("%##context_menu", MakeString(label))) {
                if ImGui.MenuItem("Detach", enabled=entity.parent != Null_Entity_GUID) {
                    DetachEntity(world, entity);
                }

                if ImGui.MenuItem("Duplicate") {
                    entity = EditorDuplicateEntity(world, entity);
                    SelectEntity(entity.guid);
                }

                if ImGui.MenuItem("Delete") {
                    EditorDeleteEntity(world, entity.guid);
                }

                if ImGui.MenuItem("Copy entity GUID") {
                    EditorCopyEntityGUID(entity.guid);
                }

                ImGui.EndPopup();
            }

            if !ImGui.IsItemToggledOpen() && IsItemDoubleClicked() {
                SelectEntity(entity.guid);
                //FocusEntity(world, entity);
            }

            if ImGui.BeginDragDropSource() {
                if entity.name {
                    ImGui.Text("<%> % %", GetNiceEntityTypeName(entity), entity.name, entity.guid);
                } else {
                    ImGui.Text("<%> %", GetNiceEntityTypeName(entity), entity.guid);
                }

                ImGui.SetDragDropPayload("EntityGUID", *entity.guid, size_of(EntityGUID));
                ImGui.EndDragDropSource();
            }

            if ImGui.BeginDragDropTarget() {
                payload := ImGui.AcceptDragDropPayload("EntityGUID");
                if payload {
                    Assert(payload.DataSize == size_of(EntityGUID));
                    to_attach_guid := cast(*EntityGUID, payload.Data).*;

                    if to_attach_guid != entity.guid && to_attach_guid != Null_Entity_GUID {
                        to_attach := GetEntity(world, to_attach_guid);
                        AttachEntity(world, to_attach, entity);
                    }
                }

                ImGui.EndDragDropTarget();
            }
        }

        if opened {
            defer ImGui.TreePop();

            for entity.children {
                child := GetEntity(world, it);
                ShowEntity(world, child, already_shown_entities);
            }
        } else {
            // Make sure we still update the already_shown set so
            // entities don't show up later
            for entity.children {
                child := GetEntity(world, it);
                VisitEntity(world, child, already_shown_entities);
            }
        }
    }

    for :AllEntities entity : world {
        if entity.parent != Null_Entity_GUID {
            continue;
        }

        ShowEntity(world, entity, *already_shown_entities);
    }
}
