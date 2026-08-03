UpdateWorld :: (world : *World) {
    Assert(world.initialized, "World has not been initialized");

    DestroyKilledEntities(world);

    ExecuteEntityCallback(world, "OnUpdate");
    ExecuteComponentCallback(world, "OnUpdate");

    UpdatePhysicsWorld(world);

    ExecuteEntityCallback(world, "OnDebugDraw");
    ExecuteComponentCallback(world, "OnDebugDraw");
} @ModuleAPI

InitWorld :: (world : *World) {
    defer world.initialized = true;

    InitPhysicsWorld(world);
} @ModuleAPI

DestroyWorld :: (using world : *World) {
    FreeEntity :: (world : *World, using entity : *Entity) {
        Free(name.data ,, world.entities_by_name.allocator);
        ArrayFree(*children);
    }

    DerefAsset(*skybox);

    Free(loaded_from_directory.data);

    #insert -> string {
        builder : StringBuilder;

        for i : 1..Entity_Types.count - 1 {
            type := Entity_Types[i];

            Appendln(*builder, "for * %_storage {", type);
            Appendln(*builder, "    it.parent = Null_Entity_ID;");
            Appendln(*builder, "    ArrayFree(*it.children);");

            Appendln(*builder, "    while it.components.count > 0 {");
            Appendln(*builder, "        DestroyComponent(world, it.components[it.components.count - 1]);");
            Appendln(*builder, "        ArrayPop(*it.components);");
            Appendln(*builder, "    }");
            Appendln(*builder, "    ArrayFree(*it.components);");

            Appendln(*builder, "    #if #exists(%1.OnDestroy) {", type);
            Appendln(*builder, "        it.OnDestroy(world, it);");
            Appendln(*builder, "    }");

            Appendln(*builder, "    UnreferenceAllAssets(it);");

            Appendln(*builder, "    HashMapRemove(*world.entities_by_id, it.id);");
            Appendln(*builder, "    if it.name {");
            Appendln(*builder, "        HashMapRemove(*world.entities_by_name, it.name);");
            Appendln(*builder, "    }");

            Appendln(*builder, "    PagedArrayFreeSlot(*%_storage, GetSlotInfo(it.index));", type);
            Appendln(*builder, "}\n");

        }

        for i : 1..Entity_Types.count - 1 {
            Appendln(*builder, "PagedArrayReset(*%_storage);", Entity_Types[i]);
        }

        for i : 1..Component_Types.count - 1 {
            type := Component_Types[i];

            Appendln(*builder, "if %_storage.count > 0 {", type);
            Appendln(*builder, "    LogWarning(\"When destroying world, component storage %1 has \% components that were not destroyed\", %1_storage.count);", type);
            Appendln(*builder, "    #if #exists(%.OnDestroy) {", type);
            Appendln(*builder, "        for * %_storage {", type);
            Appendln(*builder, "            %.OnDestroy(world, it);", type);
            Appendln(*builder, "        }");
            Appendln(*builder, "    }");
            Appendln(*builder, "}");

            Appendln(*builder, "PagedArrayReset(*%_storage);", type);
        }

        return StringBuilderBuild(*builder);
    }

    HashMapFree(*entities_by_id);
    HashMapFree(*entities_by_name);
    ArrayFree(*entities_killed_this_frame);

    DestroyPhysicsWorld(world);

    world.* = .{};
} @ModuleAPI

CopyWorld :: (dest : *World, src : *World) {
    CopyEntityOver :: (dest_world : *World, src_world : *World, entity : *Entity) -> *Entity {
        TemporaryStorageScope();

        serializer : Serializer;
        serializer.builder.allocator = Temp;

        SerializeEntity(*serializer, entity);

        str := StringBuilderBuild(*serializer.builder ,, Temp);

        new_entity := CreateAndDeserializeEntity(dest_world, str, GetEntityTypeId(entity.index), attach_to_parent=false, name=entity.name, id=entity.id);

        return new_entity;
    }

    LogSectionScope(*Log_Entities);

    DestroyWorld(dest);
    InitWorld(dest);

    dest.skybox = AddRef(src.skybox);
    dest.skybox_light_intensity = src.skybox_light_intensity;
    dest.bloom_params = src.bloom_params;

    for :AllEntities entity : src {
        CopyEntityOver(dest, src, entity);
    }

    // Attach all entities to their parent correctly
    for :AllEntities entity : dest {
        if entity.parent != Null_Entity_ID {
            parent_id := entity.parent;
            entity.parent = Null_Entity_ID;

            parent, err := GetEntity(dest, parent_id);
            if !parent {
                LogError("Entity does not exist %", parent_id);
                continue;
            }

            AttachEntity(dest, entity, parent);
        }
    }

    for :AllEntities entity : dest {
        ExecuteEntityCallback(dest, entity, "OnSpawn");

        for :AllEntityComponents entity {
            ExecuteComponentCallback(dest, entity, it, "OnSpawn");
        }
    }
} @ModuleAPI

LoadWorldFromDirectory :: (world : *World, directory : string) {
    LogSectionScope(*Log_Entities);

    start_time := Basic.current_time_monotonic();
    loaded_entities := 0;

    DestroyWorld(world);
    InitWorld(world);

    world.loaded_from_directory = StringClone(directory);

    DeferNextAssetLoadsForAllCaches();

    defer {
        end_time := Basic.current_time_monotonic();
        total_time_ms := Basic.to_float64_seconds(end_time - start_time) * 1000;

        asset_start_time := Basic.current_time_monotonic();

        LoadPendingAssets();

        asset_end_time := Basic.current_time_monotonic();
        asset_total_time_ms := Basic.to_float64_seconds(asset_end_time - asset_start_time) * 1000;

        LogContentMessage("Loaded world from directory '%' (% entities) in % ms",
            directory, loaded_entities, total_time_ms);
        LogMessage("Loaded assets for scene in % ms", asset_total_time_ms);
    }

    files : []string;

    // No logging please!
    {
        LoggerScope(null, IgnoreLogger);
        files = file_list(directory ,, Temp);
    }

    found_world_file := false;
    for files {
        if path_extension(it) == "world" {
            if found_world_file {
                LogContentError("Found multiple .world files in directory '%'", directory);
                continue;
            }

            found_world_file = true;

            file_contents, file_ok := read_entire_file(it, log_errors=false);
            if !file_ok {
                LogContentError("Could not read file '%'", it);
                continue;
            }

            defer Free(file_contents.data);

            result := DeserializeAny(file_contents, world);
            if !result.ok {
                LogContentError("There were errors when deserializing world settings:\n%:%:%: %",
                    it, result.line_index + 1, result.byte_index + 1, result.error_msg);
            }
        } else if path_extension(it) == "entity" {
            basename := path_basename(it);
            id_str := string.{0, basename.data};
            for i : 0..basename.count - 1 {
                if basename[i] == #char "_" {
                    break;
                }

                id_str.count += 1;
            }

            type_str := StringAdvance(basename, id_str.count + 1);

            id:, ok:, id_str = ParseUUID(id_str);
            if !ok || id_str.count != 0 {
                LogContentError("Invalid entity filename '%' (invalid ID)", it);
                continue;
            }

            type := void;
            type_id := EntityTypeId.Invalid;
            for i : 1..Entity_Types.count - 1 {
                info_struct := cast(*Type_Info_Struct) Entity_Types[i];
                if info_struct.name == type_str {
                    type = Entity_Types[i];
                    type_id = cast(EntityTypeId) i;
                    break;
                }
            }

            if type == void {
                LogContentError("Invalid entity filename '%' (invalid type name '%')", it, type_str);
                continue;
            }

            file_contents, file_ok := read_entire_file(it, log_errors=false);
            if !file_ok {
                LogContentError("Could not read file '%'", it);
                continue;
            }

            defer Free(file_contents.data);

            entity := CreateAndDeserializeEntity(world, file_contents, type_id, attach_to_parent=false, id=xx id);

            loaded_entities += 1;
        }
    }

    Jolt.PhysicsSystem.OptimizeBroadPhase(world.physics.system);

    // Attach all entities to their parent now that all entities have been loaded
    for :AllEntities entity : world {
        if entity.parent != Null_Entity_ID {
            parent_id := entity.parent;
            entity.parent = Null_Entity_ID;

            parent, err := GetEntity(world, parent_id);
            if !parent {
                LogError("Entity does not exist %", parent_id);
                continue;
            }

            AttachEntity(world, entity, parent);
        }
    }

    for :AllEntities entity : world {
        ExecuteEntityCallback(world, entity, "OnSpawn");

        for :AllEntityComponents entity {
            ExecuteComponentCallback(world, entity, it, "OnSpawn");
        }
    }
} @ModuleAPI

SaveWorldToDirectory :: (world : *World, output_directory : string) {
    LogSectionScope(*Log_Entities);

    start_time := Basic.current_time_monotonic();

    // No logging please!
    {
        LoggerScope(null, IgnoreLogger);

        files := file_list(output_directory ,, Temp);
        for files {
            if path_extension(it) == "entity" || path_extension(it) == "world" {
                file_delete(it);
            }
        }
    }

    make_directory_if_it_does_not_exist(output_directory, recursive=true);

    saved_entities := 0;

    for :AllEntities world {
        serializer : Serializer;
        serializer.builder.allocator = Temp;

        SerializeEntity(*serializer, it);

        filename := TPrint("%/%_%.entity", output_directory, it.id, GetEntityType(it.index));
        ok := write_entire_file(filename, *serializer.builder);
        if !ok {
            LogContentError("Could not save entity to file '%'", filename);
        } else {
            saved_entities += 1;
        }
    }

    old_dir := world.loaded_from_directory; // Just in case output_directory.data == world.loaded_from_directory.data
    world.loaded_from_directory = StringClone(output_directory);
    Free(old_dir.data);

    serializer : Serializer;
    serializer.builder.allocator = Temp;

    SerializeAny(*serializer, world);

    world_filename := TPrint("%/%.world", output_directory, path_basename(output_directory));

    ok := write_entire_file(world_filename, *serializer.builder);
    if !ok {
        LogContentError("Could not save world to file '%'", world_filename);
    }

    end_time := Basic.current_time_monotonic();
    total_time_ms := Basic.to_float64_seconds(end_time - start_time) * 1000;

    LogContentMessage("Saved world to directory '%' (% entities) in % ms",
        output_directory, saved_entities, total_time_ms);
} @ModuleAPI

DestroyKilledEntities :: (using world : *World) {
    DestroyEntity :: (using world : *World, entity : *Entity) {
        type_id := GetEntityTypeId(entity.index);

        if entity.parent != Null_Entity_ID {
            DetachEntity(world, entity, keep_same_world_transform=true);
        }

        while entity.children.count > 0 {
            child := GetEntity(world, entity.children[entity.children.count - 1]);
            if child {
                if !DetachEntity(world, child, keep_same_world_transform=true) {
                    ArrayPop(*entity.children);
                }
            } else {
                ArrayPop(*entity.children);
            }
        }

        ArrayFree(*entity.children);

        while entity.components.count > 0 {
            DestroyComponent(world, entity.components[entity.components.count - 1]);
            ArrayPop(*entity.components);
        }

        ArrayFree(*entity.components);

        ExecuteEntityCallback(world, entity, "OnDestroy");

        if entity.name {
            Free(entity.name.data ,, entities_by_name.allocator);
            HashMapRemove(*entities_by_name, entity.name);
        }

        HashMapRemove(*entities_by_id, entity.id);

        slot_info := GetSlotInfo(entity.index);

        #insert -> string {
            builder : StringBuilder;

            Appendln(*builder, "if type_id == {");

            for i : 1..Entity_Types.count - 1 {
                Appendln(*builder, "case .%;", Entity_Types[i]);
                Appendln(*builder, "    UnreferenceAllAssets(cast(*%, entity));", Entity_Types[i]);
                Appendln(*builder, "    PagedArrayFreeSlot(*%_storage, slot_info);", Entity_Types[i]);
            }

            Appendln(*builder, "}");

            return StringBuilderBuild(*builder);
        }
    }

    LogSectionScope(*Log_Entities);

    // Sorted by memory proximity and type
    QuickSort(entities_killed_this_frame, CompareEntityIndex);

    for index : entities_killed_this_frame {
        entity := GetEntity(world, index);
        if entity {
            DestroyEntity(world, entity);
        }
    }

    ArrayClear(*entities_killed_this_frame);
} @ModuleAPI

g_default_material : *Asset(Material);

GetDefaultMaterial :: inline () -> *Asset(Material) {
    if !g_default_material {
        g_default_material = LoadAsset(Material, "Default_Material.mat");
    }

    return g_default_material;
} @ModuleAPI

SubmitWorldToRenderer :: (world_to_render : *WorldToRender, world : *World) {
    world_to_render.debug_renderer = world.debug_renderer;
    world.debug_renderer = .{};

    world_to_render.skybox = world.skybox;
    world_to_render.skybox_light_intensity = world.skybox_light_intensity;

    world_to_render.bloom_params = world.bloom_params;

    for :AllMeshesToRender world {
        AddMeshToRender(world_to_render, it);
    }

    for * world.DirectionalLightComponent_storage {
        entity := GetEntity(world, it.entity_index);
        if !entity || entity.flags & .Hidden {
            continue;
        }

        shadow_map_index := -1;
        direction := ForwardVector(it.world_transform);
        if it.cast_shadows {
            shadow_map := ShadowMapToRender.{
                resolution=Default_Shadow_Map_Resolution,
                direction=direction,
                target_transform=Mat4f.{},
            };
            shadow_map_index = AddShadowMapToRender(world_to_render, shadow_map);
        }

        to_render := DirectionalLightToRender.{
            direction=direction,
            color=it.color,
            intensity=it.intensity,
            shadow_map_index=shadow_map_index,
        };
        AddDirectionalLightToRender(world_to_render, to_render);
    }

    for * world.PointLightComponent_storage {
        entity := GetEntity(world, it.entity_index);
        if !entity || entity.flags & .Hidden {
            continue;
        }

        shadow_map_index := -1;
        position := TranslationVector(it.world_transform);
        if it.cast_shadows {
            shadow_map := PointShadowMapToRender.{
                resolution=Default_Point_Shadow_Map_Resolution,
                position=position,
                z_near=it.source_radius,
                z_far=GetPointLightAttenuationDistance(it),
            };
            shadow_map_index = AddPointShadowMapToRender(world_to_render, shadow_map);
        }

        to_render := PointLightToRender.{
            position=position,
            color=it.color,
            intensity=it.intensity,
            intensity_radius=GetPointLightAttenuationDistance(it) - it.source_radius,
            source_radius=it.source_radius,
            shadow_map_index=shadow_map_index,
        };
        AddPointLightToRender(world_to_render, to_render);
    }
} @ModuleAPI
