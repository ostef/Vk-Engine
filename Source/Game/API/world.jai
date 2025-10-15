World :: struct {
    initialized : bool;
    loaded_from_directory : string;

    #insert -> string {
        builder : StringBuilder;

        for type_id : 1..Entity_Types.count - 1 {
            Appendln(*builder, "%1_storage : EntityStorage(%1);", Entity_Types[type_id]);
        }

        for type_id : 1..Component_Types.count - 1 {
            Appendln(*builder, "%1_storage : ComponentStorage(%1);", Component_Types[type_id]);
        }

        return StringBuilderBuild(*builder);
    }

    entities_by_name : HashMap(string, *Entity);
    entities_by_guid : HashMap(
        EntityGUID, *Entity,
        hash_func = HashEntityGUID,
        comp_func = (a, b) => a == b
    );

    entities_killed_this_frame : [..]EntityIndex;

    physics : *void;

    skybox : *Asset(EnvironmentMap); @Serialize(1)
    skybox_light_intensity := 1.0; @Serialize(2) @FloatRange(0,10) @Step(0.01)

    bloom_params : BloomParams; @Serialize(3)
}

// for_expansion
AllEntities :: (world : *World, body : Code, flags : For_Flags) #expand {
    `it : *Entity;
    `it_index : EntityIndex;
    should_break := false;

    #insert -> string {
        builder : StringBuilder;

        for i : 1..Entity_Types.count - 1 {
            if i != 1 {
                Appendln(*builder, "\nif should_break {\n    return;\n}\n");
            }

            Appendln(*builder, "for * entity, index : world.%_storage {", Entity_Types[i]);
            Appendln(*builder, "    it = entity;");
            Appendln(*builder, "    it_index = entity.index;");
            Appendln(*builder, "    #insert(break={should_break=true;break;}) body;");
            Appendln(*builder, "}");
        }

        return StringBuilderBuild(*builder);
    }
}

// for_expansion
AllEntitiesWithCallback :: ($Callback : string, world : *World, body : Code, flags : For_Flags) #expand {
    `it : *Entity;
    `it_index : EntityIndex;
    should_break := false;

    #insert -> string {
        builder : StringBuilder;

        for i : 1..Entity_Types.count - 1 {
            info := cast(*Type_Info_Struct, Entity_Types[i]);

            has_callback := false;
            for info.members {
                if it.name == Callback {
                    has_callback = true;
                    break;
                }
            }

            if !has_callback {
                continue;
            }

            if i != 1 {
                Appendln(*builder, "\nif should_break {\n    return;\n}\n");
            }

            Appendln(*builder, "for * entity, index : world.%_storage {", Entity_Types[i]);
            Appendln(*builder, "    it = entity;");
            Appendln(*builder, "    it_index = entity.index;");
            Appendln(*builder, "    #insert(break={should_break=true;break;}) body;");
            Appendln(*builder, "}");
        }

        return StringBuilderBuild(*builder);
    }
}

// for_expansion
AllVisibleEntities :: (world : *World, body : Code, flags : For_Flags) #expand {
    for :AllEntities `it, `it_index : world {
        if it.flags & .Hidden {
            continue;
        }

        #insert body;
    }
}

// for_expansion
AllComponents :: (world : *World, body : Code, flags : For_Flags) #expand {
    Index :: struct {
        type : Type;
        index : int;
    }

    `it : *Component;
    `it_index : Index;
    should_break := false;

    #insert -> string {
        builder : StringBuilder;

        for i : 1..Component_Types.count - 1 {
            if i != 1 {
                Appendln(*builder, "\nif should_break {\n    return;\n}\n");
            }

            Appendln(*builder, "it_index = .{type=%};", Component_Types[i]);
            Appendln(*builder, "for * component, index : world.%_storage {", Component_Types[i]);
            Appendln(*builder, "    it = component;");
            Appendln(*builder, "    it_index.index += 1;");
            Appendln(*builder, "    #insert(break={should_break=true;break;}) body;");
            Appendln(*builder, "}");
        }

        return StringBuilderBuild(*builder);
    }
}

// for_expansion
AllComponentsWithCallback :: ($Callback : string, world : *World, body : Code, flags : For_Flags) #expand {
    Index :: struct {
        type : Type;
        index : int;
    }

    `it : *Component;
    `it_index : Index;
    should_break := false;

    #insert -> string {
        builder : StringBuilder;

        for i : 1..Component_Types.count - 1 {
            info := cast(*Type_Info_Struct, Component_Types[i]);

            has_callback := false;
            for info.members {
                if it.name == Callback {
                    has_callback = true;
                    break;
                }
            }

            if !has_callback {
                continue;
            }

            if i != 1 {
                Appendln(*builder, "\nif should_break {\n    return;\n}\n");
            }

            Appendln(*builder, "it_index = .{type=%};", Component_Types[i]);
            Appendln(*builder, "for * component, index : world.%_storage {", Component_Types[i]);
            Appendln(*builder, "    it = component;");
            Appendln(*builder, "    it_index.index += 1;");
            Appendln(*builder, "    #insert(break={should_break=true;break;}) body;");
            Appendln(*builder, "}");
        }

        return StringBuilderBuild(*builder);
    }
}
