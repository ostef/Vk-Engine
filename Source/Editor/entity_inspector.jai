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

    if ImGui.Button("Add Component", size=.{-1,0}) {
        OpenAddComponentPopup(world, entity);
    }

    PopButtonColor();
    ImGui.PopFont();
}

g_add_component_popup : struct {
    request_open : bool;
    selected_component_type : ComponentTypeId;
    world : *World;
    entity : *Entity;
}

#insert -> string {
    builder : StringBuilder;

    unique_entity_categories : [..]string;
    for Entity_Categories {
        if it {
            ArrayPushUnique(*unique_entity_categories, it);
        }
    }

    QuickSort(unique_entity_categories, StringCompare);

    unique_component_categories : [..]string;
    for Component_Categories {
        if it {
            ArrayPushUnique(*unique_component_categories, it);
        }
    }

    QuickSort(unique_component_categories, StringCompare);

    Appendln(*builder, "Unique_Entity_Categories :: string.[");

    for unique_entity_categories {
        Append(*builder, "    ");
        StringBuilderAppendStringLiteral(*builder, it);
        Append(*builder, ",\n");
    }

    Appendln(*builder, "];");

    Appendln(*builder, "Unique_Component_Categories :: string.[");

    for unique_component_categories {
        Append(*builder, "    ");
        StringBuilderAppendStringLiteral(*builder, it);
        Append(*builder, ",\n");
    }

    Appendln(*builder, "];");

    return StringBuilderBuild(*builder);
}

OpenAddComponentPopup :: (world : *World, entity : *Entity) {
    g_add_component_popup.request_open = true;
    g_add_component_popup.world = world;
    g_add_component_popup.entity = entity;
}

ShowAddComponentPopup :: () {
    using g_add_component_popup;

    if request_open {
        ImGui.OpenPopup("###add_component_popup");
        request_open = false;
    }

    window_w, window_h := GetWindowPointSize(GetWindow());

    popup_size := Vec2f.{
        Min(500.0, window_w * 0.5),
        Min(500.0, window_h * 0.8)
    };
    display_size := ImGui.GetIO().DisplaySize;
    ImGui.SetNextWindowPos((display_size - popup_size) * 0.5, .Appearing);
    ImGui.SetNextWindowSize(popup_size, .Appearing);
    ImGui.PushStyleVar(.WindowTitleAlign, .{0.5, 0.5});
    defer ImGui.PopStyleVar();

    if !ImGui.BeginPopupModal("Add Component###add_component_popup") {
        return;
    }

    defer ImGui.EndPopup();

    if IsKeyPressed(.Escape) {
        ImGui.CloseCurrentPopup();
    }

    ShowComponentCategory :: (category : string, selected : *ComponentTypeId) {
        actual_name := path_filename(category);
        if ImGui.TreeNode(CTPrint("%##%", actual_name, category)) {
            defer ImGui.TreePop();

            for Unique_Component_Categories {
                parent_category := path_strip_filename(it);
                if parent_category.count > 0 && parent_category[parent_category.count - 1] == #char "/" {
                    parent_category.count -= 1;
                }

                if parent_category == category {
                    ShowComponentCategory(it, selected);
                }
            }

            for i : 1..Component_Types.count - 1 {
                type := cast(ComponentTypeId, i);
                component_category := Component_Categories[i];
                if component_category != category {
                    continue;
                }

                name := GetNiceComponentTypeName(type);

                node_flags := ImGui.TreeNodeFlags.Leaf;
                if selected.* == type {
                    node_flags |= .Selected;
                }

                if ImGui.TreeNodeEx(CStringClone(name ,, Temp), node_flags) {
                    ImGui.TreePop();

                    if ImGui.IsItemClicked() {
                        selected.* = type;
                    }
                }
            }
        }
    }

    {
        ImGui.PushFont(g_editor_medium_font);
        size := ImGui.GetContentRegionAvail();
        size.y -= ImGui.GetFrameHeightWithSpacing();
        ImGui.PopFont();

        defer ImGui.EndChild();
        if !ImGui.BeginChild("component_list_tiles", size=size) {
            return;
        }

        for Unique_Component_Categories {
            if path_strip_filename(it) == "" {
                ShowComponentCategory(it, *selected_component_type);
            }
        }
    }

    ImGui.PushFont(g_editor_medium_font);
    PushButtonColor(.EmphasisButton);

    ImGui.BeginDisabled(selected_component_type == .Invalid);

    add_name := ifx selected_component_type
        then CTPrint("Add % Component###add_component", GetNiceComponentTypeName(selected_component_type))
        else "Add Component###add_component";

    if ImGui.Button(add_name, size=.{-1,0}) {
        AddComponent(world, selected_component_type, entity);
        ImGui.CloseCurrentPopup();
    }

    ImGui.EndDisabled();

    PopButtonColor();
    ImGui.PopFont();
}
