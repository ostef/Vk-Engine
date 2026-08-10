// WARNING: if this file is renamed or moved, or if the Component struct is moved to
// another file, Build/entity.jai must be updated accordingly

#placeholder Component_Types;
#placeholder ComponentTypeId;
#placeholder Component_Categories;

#insert -> string {
    builder : StringBuilder;

    Appendln(*builder, "ComponentTypeId :: enum {");
    Appendln(*builder, "    Invalid :: 0;");

    for i : 1..Component_Types.count - 1 {
        Appendln(*builder, "    % :: %;", Component_Types[i], i);
    }

    Appendln(*builder, "}");

    return StringBuilderBuild(*builder);
};

Components_Per_Page :: 300;

ComponentStorage :: #bake_arguments PagedArray(Page_Size=Components_Per_Page);

Component :: struct {
    entity_index : EntityIndex;
    index : PagedArraySlotInfo;
    type_id : int;
}

SpatialComponent :: struct {
    #as using _ : Component; @Serialize(1) @InspectorNoTree

    local_position : Vec3f; @Serialize(2)
    local_rotation : Quatf; @Serialize(3)
    local_scale : Vec3f = .{1,1,1}; @Serialize(4)

    world_transform : Mat4f;
    inv_world_transform : Mat4f;
}

#insert -> string {
    builder : StringBuilder;

    Appendln(*builder, "Component_Is_Spatial :: bool.[");
    Appendln(*builder, "    false,");
    for i : 1..Component_Types.count - 1 {
        info := cast(*Type_Info_Struct, Component_Types[i]);
        Appendln(*builder, "    %,", TypeIsSubstructOf(info, type_info(SpatialComponent)));
    }
    Appendln(*builder, "];");

    return StringBuilderBuild(*builder);
}

ComponentIsSpatial :: inline (type_id : ComponentTypeId) -> bool {
    return Component_Is_Spatial[type_id];
}

ComponentIsSpatial :: inline (component : *Component) -> bool {
    return Component_Is_Spatial[GetComponentTypeId(component)];
}

UpdateWorldTransform :: (entity : *Entity, using spatial : *SpatialComponent) {
    local_transform := Mat4fTransformSRT(local_position, local_rotation, local_scale);
    world_transform = entity.world_transform * local_transform;
    inv_world_transform = Inverse(world_transform);
}

IsInComponentTypesArray :: (type : Type) -> bool {
    for i : 1..Component_Types.count - 1 {
        if Component_Types[i] == type {
            return true;
        }
    }

    return false;
}

GetComponentTypeId :: (type : Type) -> ComponentTypeId {
    for Component_Types {
        if it == type {
            return cast(ComponentTypeId, it_index);
        }
    }

    return .Invalid;
}

GetComponentTypeId :: inline (component : *Component) -> ComponentTypeId {
    return cast(ComponentTypeId, component.type_id);
}

GetComponentType :: inline (type_id : ComponentTypeId) -> Type {
    return Component_Types[type_id];
}

GetComponentType :: inline (component : *Component) -> Type {
    return GetComponentType(GetComponentTypeId(component));
}

CreateComponent :: (world : *World, storage : *ComponentStorage($T), entity : *Entity) -> *T {
    component, index := PagedArrayFindSlot(storage);
    Assert(component != null, "Could not create component %", T);
    component.entity_index = entity.index;
    component.index = index;
    component.type_id = #run cast(int, GetComponentTypeId(T));

    #if #run ComponentIsSpatial(GetComponentTypeId(T)) {
        UpdateWorldTransform(entity, component);
    }

    #if #exists(T.OnCreate) {
        T.OnCreate(world, entity, component);
    }

    return component;
}

DestroyComponent :: (world : *World, storage : *ComponentStorage($T), component : *T) {
    if !component {
        return;
    }

    UnreferenceAllAssets(component);

    #if #exists(T.OnDestroy) {
        T.OnDestroy(world, component);
    }

    PagedArrayFreeSlot(storage, component.index);
}

CreateComponent :: (world : *World, $T : Type, entity : *Entity) -> *T
#modify { return IsInComponentTypesArray(T); } {
    storage := #insert #run TPrint("*world.%_storage;", T);
    return CreateComponent(world, storage, entity);
}

DestroyComponent :: (world : *World, component : *$T)
#modify { return T == Component || IsInComponentTypesArray(T); } {
    #if T == Component {
        #insert -> string {
            builder : StringBuilder;

            Appendln(*builder, "if GetComponentTypeId(component) == {");
            for i : 1..Component_Types.count - 1 {
                Appendln(*builder, "case .%1; inline DestroyComponent(world, cast(*%1, component));", Component_Types[i]);
            }
            Appendln(*builder, "}");

            return StringBuilderBuild(*builder);
        }
    } else {
        storage := #insert #run TPrint("*world.%_storage;", T);
        DestroyComponent(world, storage, component);
    }
}

AddComponent :: (world : *World, $T : Type, entity : *Entity) -> *T
#modify { return IsInComponentTypesArray(T); } {
    component := CreateComponent(world, T, entity);
    ArrayPush(*entity.components, component);

    // @Todo: call OnComponentAdded

    return component;
}

AddComponent :: (world : *World, type_id : ComponentTypeId, entity : *Entity) -> *Component {
    #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "if type_id == {");
        for i : 1..Component_Types.count - 1 {
            Appendln(*builder, "case .%1; return inline AddComponent(world, %1, entity);", Component_Types[i]);
        }
        Appendln(*builder, "case; LogError(\"Invalid component type\");");
        Appendln(*builder, "}");

        return StringBuilderBuild(*builder);
    }

    return null;
}

RemoveComponent :: (world : *World, component : *$T, entity : *Entity)
#modify { return T == Component || IsInComponentTypesArray(T); } {
    if component.entity_index != entity.index {
        LogError("Component does not belong to entity %", entity.id);
        return;
    }

    index := ArrayFindFirst(entity.components, component);
    if index < 0 {
        LogError("Component is static and has not been added using AddComponent");
        return;
    }

    ArrayOrderedRemove(*entity.components, index);

    // @Todo: call OnComponentRemoved

    DestroyComponent(world, component);
}

// If you want all the components consider using AllEntityComponents iterator
GetComponent :: inline (entity : *$E, $T : Type) -> *T
#modify { return (E == Entity || IsInEntityTypesArray(E)) && IsInComponentTypesArray(T); } {
    #if E == Entity {
        #insert -> string {
            builder : StringBuilder;

            Appendln(*builder, "if GetEntityTypeId(entity.index) == {");

            for i : 1..Entity_Types.count - 1 {
                Appendln(*builder, "case .%1; return GetComponent(entity, %1);", Entity_Types[i]);
            }

            Appendln(*builder, "}");

            return StringBuilderBuild(*builder);
        }

        return null;
    } else {
        Code :: #run -> string {
            found := false;
            for entity.members {
                // @Todo: handle array of components, structs containing components
                if it.type.type != .POINTER {
                    continue;
                }

                type := cast(*Type_Info_Pointer, it.type).pointer_to;
                if type == component {
                    return TPrint("return %.%;", name, it.name);
                }
            }

            return "";
        }

        #if Code.count > 0 {
            #insert Code;
        } else {
            Type_Id :: #run GetComponentTypeId(T);
            for entity.components {
                if GetComponentTypeId(it) == Type_Id {
                    return it;
                }
            }

            return null;
        }
    }
}

ExecuteComponentCallback :: (world : *World, $Callback : string) {
    #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "ProfileBlock(GetCPUFrameProfiler(), \"Component.%\");", Callback);

        for i : 1..Component_Types.count - 1 {
            type := Component_Types[i];
            Appendln(*builder, "#if #exists(%1.%2) {", type, Callback);
            Appendln(*builder, "    for * world.%1_storage {", type);
            Appendln(*builder, "        entity := GetEntity(world, it.entity_index);");
            Appendln(*builder, "        if !entity {");
            Appendln(*builder, "            continue;");
            Appendln(*builder, "        }");
            Appendln(*builder, "        it.%1(world, entity, it);", Callback);
            Appendln(*builder, "    }");
            Appendln(*builder, "}");
        }

        return StringBuilderBuild(*builder);
    }
}

ExecuteComponentCallback :: inline (world : *World, component : *$T, $Callback : string)
#modify { return T == Component || IsInComponentTypesArray(T); } {
    #if T == Component {
        #insert -> string {
            builder : StringBuilder;

            Appendln(*builder, "if GetComponentTypeId(component) == {");
            for i : 1..Component_Types.count - 1 {
                type := Component_Types[i];
                Appendln(*builder, "case .%1; #if #exists(%1.%2) { entity := GetEntity(world, component.entity_index); if entity { %1.%2(world, entity, xx component); } }", type, Callback);
            }
            Appendln(*builder, "}");

            return StringBuilderBuild(*builder);
        }
    } else {
        #insert #run TPrint("#if #exists(T.%1) { T.%1(world, component); }", Callback);
    }
}

ExecuteComponentCallback :: inline (world : *World, entity : *Entity, component : *$T, $Callback : string)
#modify { return T == Component || IsInComponentTypesArray(T); } {
    #if T == Component {
        #insert -> string {
            builder : StringBuilder;

            Appendln(*builder, "if GetComponentTypeId(component) == {");
            for i : 1..Component_Types.count - 1 {
                type := Component_Types[i];
                Appendln(*builder, "case .%1; #if #exists(%1.%2) { %1.%2(world, entity, xx component); }", type, Callback);
            }
            Appendln(*builder, "}");

            return StringBuilderBuild(*builder);
        }
    } else {
        #insert #run TPrint("#if #exists(T.%1) { T.%1(world, entity, component); }", Callback);
    }
}

AllEntityComponents :: (entity : *$E, body : Code, flags : For_Flags, $T : Type = Component)
#modify { return (E == Entity || IsInEntityTypesArray(E)) && (T == Component || IsInComponentTypesArray(T)); } #expand {
    `it : *T;
    `it_index := 0;

    #if E == Entity {
        #insert -> string {
            builder : StringBuilder;

            Appendln(*builder, "// AllEntityComponents(T=%, E=%)", T, E);
            Appendln(*builder, "if GetEntityTypeId(entity.index) == {");

            comp := type_info(T);
            for i : 1..Entity_Types.count - 1 {
                Appendln(*builder, "case .%1;", Entity_Types[i]);

                info := cast(*Type_Info_Struct, Entity_Types[i]);
                for info.members {
                    if it.type.type != .POINTER {
                        continue;
                    }

                    type := cast(*Type_Info_Pointer, it.type).pointer_to;
                    if type == comp || (T == Component && IsInComponentTypesArray(get_type(type))) {
                        Appendln(*builder, "    it = cast(*%1, entity).%2;", Entity_Types[i], it.name);
                        Appendln(*builder, "    while it {");
                        Appendln(*builder, "        defer it_index += 1;");
                        Appendln(*builder, "        #insert(break=return, continue=break) body;");
                        Appendln(*builder, "        break;");
                        Appendln(*builder, "    }");
                    }
                }
            }

            Appendln(*builder, "}");

            return StringBuilderBuild(*builder);
        }
    } else {
        #insert -> string {
            builder : StringBuilder;

            Appendln(*builder, "// AllEntityComponents(T=%, E=%)", T, E);

            comp := type_info(T);
            info := type_info(E);
            for info.members {
                if it.type.type != .POINTER {
                    continue;
                }

                type := cast(*Type_Info_Pointer, it.type).pointer_to;
                if T == Component || type == comp {
                    Appendln(*builder, "it = entity.%;", it.name);
                    Appendln(*builder, "while it {");
                    Appendln(*builder, "    defer it_index += 1;");
                    Appendln(*builder, "    #insert(break=return, continue=break) body;");
                    Appendln(*builder, "    break;");
                    Appendln(*builder, "}");
                }
            }

            return StringBuilderBuild(*builder);
        }
    }

    Type_Id :: #run GetComponentTypeId(T);
    for comp, index : entity.components {
        defer it_index += 1;
        if T != Component && GetComponentTypeId(comp) != Type_Id {
            continue;
        }

        it = cast(*T, comp);
        #insert body;
    }
}

GetEditorIcon :: inline (world : *World, entity : *Entity, component : *$T) -> *Asset(Texture2D), *Asset(Material)
#modify { return T == Component || IsInComponentTypesArray(T); } {
    icon : *Asset(Texture2D);
    #if T == Component {
        #insert -> string {
            builder : StringBuilder;

            Appendln(*builder, "if GetComponentTypeId(component) == {");
            for i : 1..Component_Types.count - 1 {
                type := Component_Types[i];
                Appendln(*builder, "case .%1; #if #exists(%1.GetEditorIcon) { icon = %1.GetEditorIcon(world, entity, xx component); }", type);
            }
            Appendln(*builder, "}");

            return StringBuilderBuild(*builder);
        }
    } else {
        #if #exists(T.GetEdiorIcon) {
            icon = T.GetEditorIcon(world, entity, component);
        }
    }

    if !icon {
        return null, null;
    }

    material, is_new := AllocNewAsset(Material, TPrint("%.mat", icon.asset_name), .FromMemory | .Permanent);
    if is_new {
        material.type = .Unlit;
        material.base_color = icon;
    }

    return icon, material;
}
