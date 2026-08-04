RandomEntityID :: inline () -> EntityID {
    return xx RandomUUID();
} @ModuleAPI

EntityIsInHierarchy :: (world : *World, entity : *Entity, of : *Entity) -> bool {
    if !entity {
        return false;
    }

    if entity == of {
        return true;
    }

    if of.children.count == 0 {
        return false;
    }

    for of.children {
        child := GetEntity(world, it);
        if entity == child {
            return true;
        }
    }

    for of.children {
        child := GetEntity(world, it);

        if EntityIsInHierarchy(world, entity, child) {
            return true;
        }
    }

    return false;
} @ModuleAPI

SetEntityName :: inline (using world : *World, entity : *Entity, new_name : string) -> set_same_name : bool {
    LogSectionScope(*Log_Entities);

    SeparatePostfixNumber :: (str : string) -> postfix : int, name_without_postfix : string {
        dot_index := find_index_from_right(str, #char ".");
        if dot_index == -1 || dot_index == str.count - 1 {
            return -1, str;
        }

        for i : dot_index + 1..str.count - 1 {
            if !Basic.is_digit(str[i]) {
                return -1, str;
            }
        }

        str_without_postfix := str;
        str_without_postfix.count = dot_index;
        postfix_str := StringAdvance(str, dot_index + 1);
        postfix := Basic.string_to_int(postfix_str);

        return postfix, str_without_postfix;
    }

    if entity.name {
        HashMapRemove(*entities_by_name, entity.name);
        Free(entity.name.data ,, entities_by_name.allocator);
        entity.name = "";
    }

    if !new_name {
        return true;
    }

    number_postfix := -1;

    // Try to prevent .0.0.0.0 postfix by parsing the name and trimming the .NUMBER at the end
    first_number_postfix, name_without_postfix := SeparatePostfixNumber(new_name);
    while true {
        if number_postfix == -1 {
            entity.name = StringClone(new_name ,, entities_by_name.allocator);
        } else {
            entity.name = SPrint("%.%", name_without_postfix, number_postfix ,, entities_by_name.allocator);
        }

        entity_ptr, already_exists := HashMapInsert(*entities_by_name, entity.name);
        if already_exists {
            if number_postfix == -1 {
                number_postfix = first_number_postfix + 1;
            } else {
                number_postfix += 1;
            }

            // LogError("Entity with name '%' already exists", entity.name);

            Free(entity.name.data ,, entities_by_name.allocator);
            entity.name = "";
        } else {
            entity_ptr.* = entity;
            break;
        }
    }

    return number_postfix == -1;
} @ModuleAPI

GetEntity :: (using world : *World, id : EntityID) -> *Entity, GetEntityError {
    if id == Null_Entity_ID {
        return null, .NullEntity;
    }

    entity, err := HashMapGet(*entities_by_id, id);
    if !entity {
        return null, .EntityKilledOrNeverSpawned;
    }

    return entity, .Ok;
} @ModuleAPI

GetEntity :: (using world : *World, index : EntityIndex) -> *Entity, GetEntityError {
    LogSectionScope(*Log_Entities);

    if index == 0 {
        return null, .NullEntity;
    }

    type_id := GetEntityTypeId(index);
    slot_info := GetSlotInfo(index);

    #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "if #complete type_id == {");
        Appendln(*builder, "case .Invalid; LogError(\"Requesting entity with invalid type id(\%)\", type_id); return null, .InvalidEntityIndex;");

        for i : 1..Entity_Types.count - 1
        {
            it := Entity_Types[i];
            Appendln(*builder, "case .%;", it);
            Appendln(*builder, "    valid, corrupt, not_occupied, version_mismatch := PagedArrayIsSlotValid(%_storage, slot_info);", it);
            Appendln(*builder, "    if not_occupied || version_mismatch {");
            Appendln(*builder, "        return null, .EntityKilled;");
            Appendln(*builder, "    }");
            Appendln(*builder, "    if !valid {");
            Appendln(*builder, "        return null, .InvalidEntityIndex;");
            Appendln(*builder, "    }");
            Appendln(*builder, "    return PagedArrayGetItem(*%_storage, slot_info), .Ok;", it);
        }

        Appendln(*builder, "}");

        return StringBuilderBuild(*builder);
    }

    return null, .InvalidEntityIndex;
} @ModuleAPI

AttachEntity :: (using world : *World, entity : *Entity, to : *Entity, keep_same_world_transform := true) -> bool {
    LogSectionScope(*Log_Entities);

    Assert(entity != null);
    Assert(to != null);

    if entity == to {
        LogError("Trying to attach entity to itself");
        return false;
    }

    // Detect entity attaching itself to one of its descendants
    #if Detect_Entity_Recursive_Attachment {
        if EntityIsInHierarchy(world, to, entity) {
            LogError("Trying to recursively attach entity to one of its descendants");
            return false;
        }
    }

    if entity.parent != Null_Entity_ID {
        DetachEntity(world, entity);
    }

    ArrayPush(*to.children, entity.index);

    entity.parent = to.id;

    if keep_same_world_transform {
        local_transform := Inverse(to.world_transform) * entity.world_transform;

        entity.local_position = TranslationVector(local_transform);
        entity.local_rotation = QuatfFromMatrix(local_transform);

        // Extracting scale from a matrix does not give good results, walk the hierarchy instead
        // @Todo: orientations may not be the same between a parent and its child, so X axis scale of parent
        // may not be X axis scale of child. Use GetScaleOnAxis like we do in EntityGizmo procedure.
        parent_for_scale := to;
        while parent_for_scale {
            entity.local_scale = InvScale(entity.local_scale, parent_for_scale.local_scale);
            parent_for_scale = GetEntity(world, parent_for_scale.parent);
        }
    }

    UpdateWorldTransform(world, entity);
    ExecuteEntityCallback(world, entity, "OnAttached");

    LogMessage("Attached entity % to %", entity.id, to.id, flags=.VERBOSE_ONLY);

    return true;
} @ModuleAPI

DetachEntity :: (using world : *World, entity : *Entity, keep_same_world_transform := true) -> bool {
    LogSectionScope(*Log_Entities);

    if entity.parent == Null_Entity_ID {
        return false;
    }

    ExecuteEntityCallback(world, entity, "OnDetach");

    parent := GetEntity(world, entity.parent);
    Assert(parent != null);

    child_index := ArrayFindFirst(parent.children, entity.index);
    Assert(child_index != -1);

    ArrayRemove(*parent.children, child_index);

    entity.parent = Null_Entity_ID;

    if keep_same_world_transform {
        entity.local_position = TranslationVector(entity.world_transform);
        entity.local_rotation = QuatfFromMatrix(entity.world_transform);

        // Extracting scale from a matrix does not give good results, walk the hierarchy instead
        parent_for_scale := parent;
        while parent_for_scale {
            entity.local_scale = Scale(entity.local_scale, parent_for_scale.local_scale);
            parent_for_scale = GetEntity(world, parent_for_scale.parent);
        }
    }

    UpdateWorldTransform(world, entity);

    LogMessage("Detached entity % from %", entity.id, parent.id, flags=.VERBOSE_ONLY);

    return true;
} @ModuleAPI

// Walk up the hierarchy, applying scale to the world space axes of entity
GetWorldScale :: (world : *World, entity : *Entity, component : *SpatialComponent = null) -> Vec3f {
    AllocatorScope(Temp);

    if !component && entity.parent == Null_Entity_ID {
        return entity.local_scale;
    }

    hierarchy : [..]*Entity;
    if component {
        ArrayPush(*hierarchy, xx component); // @Hack: the cast is not valid, but we do a check later to avoid reading incorrect data
    }

    ArrayPush(*hierarchy, entity);

    parent := ifx entity.parent != Null_Entity_ID then GetEntity(world, entity.parent);
    while parent {
        ArrayPush(*hierarchy, parent);
        parent = GetEntity(world, parent.parent);
    }

    world_rotation : Mat4f;
    scale := Vec3f.{1,1,1};
    for < hierarchy {
        local_rotation : Quatf = ---;
        local_scale : Vec3f = ---;
        if it_index == 0 && component {
            local_rotation = component.local_rotation;
            local_scale = component.local_scale;
        } else {
            local_rotation = it.local_rotation;
            local_scale = it.local_scale;
        }

        scale_x := world_rotation * Mat4fScale(.{scale.x,1,1});
        scale_y := world_rotation * Mat4fScale(.{1,scale.y,1});
        scale_z := world_rotation * Mat4fScale(.{1,1,scale.z});

        world_rotation = world_rotation * Mat4fFromQuat(local_rotation);

        right   := RightVector(world_rotation);
        up      := UpVector(world_rotation);
        forward := ForwardVector(world_rotation);
        scaled_right   := TransformVector(scale_x, local_scale.x * right);
        scaled_up      := TransformVector(scale_y, local_scale.y * up);
        scaled_forward := TransformVector(scale_z, local_scale.z * forward);

        scale = .{
            Dot(right, scaled_right),
            Dot(up, scaled_up),
            Dot(forward, scaled_forward),
        };
    }

    return scale;
} @ModuleAPI

SetWorldTransformNoScale :: (world : *World, entity : *Entity, transform : Mat4f) {
    local_transform : Mat4f = ---;
    if entity.parent != Null_Entity_ID {
        parent := GetEntity(world, entity.parent);
        if parent {
            local_transform = parent.inv_world_transform * transform;
        } else {
            local_transform = transform;
        }
    } else {
        local_transform = transform;
    }

    entity.local_position = TranslationVector(local_transform);
    entity.local_rotation = QuatfFromMatrix(local_transform);

    UpdateWorldTransform(world, entity);
} @ModuleAPI

UpdateWorldTransform :: (world : *World, entity : *Entity, update_children := true, update_components := true) {
    parent := ifx entity.parent != Null_Entity_ID then GetEntity(world, entity.parent);

    local_transform := Mat4fTransformSRT(entity.local_position, entity.local_rotation, entity.local_scale);

    if parent {
        entity.world_transform = parent.world_transform * local_transform;

        // Remove skewing from world transform
        Q, S := PolarDecompose(entity.world_transform);
        S2 := Mat4f.{r0c0=S.r0c0, r1c1=S.r1c1, r2c2=S.r2c2, r3c3=1};

        T := Mat4fTranslate(TranslationVector(entity.world_transform));

        entity.world_transform = T * ToMat4f(Q) * S2;
    } else {
        entity.world_transform = local_transform;
    }

    entity.inv_world_transform = Inverse(entity.world_transform);

    if update_components {
        for :AllEntityComponents entity {
            if ComponentIsSpatial(it) {
                spatial := cast(*SpatialComponent, it);
                UpdateWorldTransform(entity, spatial);
            } else if GetComponentTypeId(it) == .RigidBodyComponent {
                rigidbody := cast(*RigidBodyComponent, it);
                UpdateWorldTransform(world, entity, rigidbody);
            }
        }
    }

    if update_children {
        for entity.children {
            child := GetEntity(world, it);
            Assert(child != null);

            UpdateWorldTransform(world, child, update_components=update_components);
        }
    }
} @ModuleAPI

SpawnEntity :: (using world : *World, type : EntityTypeId, name := "", id := Null_Entity_ID) -> *Entity {
    entity := CreateEntity(world, type, name, id);

    ExecuteEntityCallback(world, entity, "OnSpawn");

    for :AllEntityComponents entity {
        ExecuteComponentCallback(world, entity, it, "OnSpawn");
    }

    if name {
        LogMessage("Spawned entity % (%, %)",
            name, type, entity.id,
            flags=.VERBOSE_ONLY
        );
    } else {
        LogMessage("Spawned entity (%, %)",
            type, entity.id,
            flags=.VERBOSE_ONLY
        );
    }

    return entity;
} @ModuleAPI

CreateEntity :: (using world : *World, type : EntityTypeId, name := "", id := Null_Entity_ID) -> *Entity {
    LogSectionScope(*Log_Entities);

    if type == .Invalid {
        return null;
    }

    entity : *Entity;
    slot_info : PagedArraySlotInfo;
    #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "if type == {");

        for i : 1..Entity_Types.count - 1 {
            Appendln(*builder, "case .%;", Entity_Types[i]);
            Appendln(*builder, "    entity, slot_info = PagedArrayFindSlot(*%_storage);", Entity_Types[i]);
        }

        Appendln(*builder, "}");

        return StringBuilderBuild(*builder);
    }

    entity.index = MakeEntityIndex(type, slot_info);

    if id.low || id.high {
        entity.id = id;
    } else {
        entity.id = RandomEntityID();
    }

    entity_ptr, already_exists := HashMapInsert(*entities_by_id, entity.id);
    if already_exists {
        LogError("Entity with ID % already exists", entity.id);
    } else {
        entity_ptr.* = entity;
    }

    if name {
        SetEntityName(world, entity, name);
    }

    ExecuteEntityCallback(world, entity, "OnCreate");

    return entity;
} @ModuleAPI

CreateAndDeserializeEntity :: (using world : *World, text : string, type_id : EntityTypeId, attach_to_parent : bool, name := "", id := Null_Entity_ID) -> *Entity {
    entity := CreateEntity(world, type_id, id=id, name=name);
    cached_name := entity.name;

    result := DeserializeEntity(text, world, entity);
    if !result.ok {
        LogContentError("There were errors when deserializing entity:\n%_%:%:%: %",
            type_id, id, result.line_index + 1, result.byte_index + 1, result.error_msg);
    }

    UpdateWorldTransform(world, entity);

    if cached_name {
        Assert(cached_name == entity.name);
        Free(entity.name.data);
        entity.name = cached_name;
    } else if entity.name {
        name := entity.name;
        entity.name = "";
        SetEntityName(world, entity, name);
        Free(name.data);
    }

    if entity.parent != Null_Entity_ID && attach_to_parent {
        parent, err := GetEntity(world, entity.parent);
        if parent {
            // AttachEntity detaches from previous parent, so clear entity.parent beforehand
            entity.parent = .{};
            AttachEntity(world, entity, parent);
        } else {
            LogError("In CreateAndDeserializeEntity, when trying to attach entity, GetEntity failed for parent % (%)", entity.parent, err);
            entity.parent = .{};
        }
    }

    return entity;
} @ModuleAPI

SerializeEntity :: inline (serializer : *Serializer, entity : *Entity) {
    any : Any = ---;
    any.type = cast(*Type_Info, GetEntityType(GetEntityTypeId(entity.index)));
    any.value_pointer = entity;

    SerializeAny(serializer, any);

    for entity.components {
        type_id := GetComponentTypeId(it);

        Appendln(serializer, "\n[%]", type_id);

        any : Any;
        any.type = cast(*Type_Info, GetComponentType(type_id));
        any.value_pointer = it;
        SerializeAny(serializer, any);
    }
} @ModuleAPI

DeserializeEntity :: inline (text : string, world : *World, entity : *Entity) -> DeserializeResult {
    cached_id := entity.id;
    cached_index := entity.index;

    parser : DeserializeParser;
    InitParser(*parser, text ,, Temp);

    all_lines := parser.lines;
    parser.lines.count = 0;

    parsing_entity_properties := true;
    while parser.lines.count < all_lines.count {
        defer parsing_entity_properties = false;

        any : Any = ---;

        if parsing_entity_properties {
            any.type = cast(*Type_Info, GetEntityType(GetEntityTypeId(entity.index)));
            any.value_pointer = entity;
        } else {
            parser.lines.count = all_lines.count;

            component_line := all_lines[parser.line_index];
            if component_line[0] != #char "[" || component_line[component_line.count - 1] != #char "]" {
                return DeserializeError(*parser, "Expected line in the format '[component type]'");
            }

            StringAdvance(*component_line, 1);
            component_line.count -= 1;

            type_id_index := ArrayFindFirst(type_info(ComponentTypeId).names, component_line);
            if type_id_index <= 0 {
                return DeserializeError(*parser, "Invalid component type '%'", component_line);
            }

            AdvanceToNextLine(*parser);

            type_id := cast(ComponentTypeId, type_id_index);
            component := AddComponent(world, type_id, entity);

            any.type = cast(*Type_Info, GetComponentType(type_id));
            any.value_pointer = component;
        }

        // Make sure the parser only sees up to the next [Component]
        parser.lines.count = parser.line_index;
        for i : parser.line_index..all_lines.count - 1 {
            line := all_lines[i];
            if line[0] == #char "[" {
                break;
            }

            parser.lines.count += 1;
        }

        result := DeserializeAny(*parser, any);

        if parsing_entity_properties {
            entity.id = cached_id;
            entity.index = cached_index;

            ExecuteEntityCallback(world, entity, "OnValidate");
        } else {
            ExecuteComponentCallback(world, entity, cast(*Component, any.value_pointer), "OnValidate");
        }

        if !result.ok {
            return result;
        }
    }

    return DeserializeOk(*parser);
} @ModuleAPI

KillEntity :: (using world : *World, id : EntityID) {
    LogSectionScope(*Log_Entities);

    entity := GetEntity(world, id);
    if !entity {
        LogError("Killing entity with ID % but it does not exist", id);
        return;
    }

    for entities_killed_this_frame {
        if it == entity.index {
            return;
        }
    }

    ArrayPush(*entities_killed_this_frame, entity.index);

    ExecuteEntityCallback(world, entity, "OnKilled");
    for :AllEntityComponents entity {
        ExecuteComponentCallback(world, entity, it, "OnKilled");
    }
} @ModuleAPI

KillEntity :: (using world : *World, index : EntityIndex) {
    LogSectionScope(*Log_Entities);

    entity := GetEntity(world, index);
    if !entity {
        LogError("Killing entity with index % but it does not exist", index);
        return;
    }

    for entities_killed_this_frame {
        if it == index {
            return;
        }
    }

    ArrayPush(*entities_killed_this_frame, index);

    ExecuteEntityCallback(world, entity, "OnKilled");
    for :AllEntityComponents entity {
        ExecuteComponentCallback(world, entity, it, "OnKilled");
    }

} @ModuleAPI
