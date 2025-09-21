#import "Type_Utils";
#import "Sort";
#import "String";
#import "Hash_Set";

EntityWorkspaceBuildInfo :: struct {
    generated_entity_code := false;
    entity_type : *Type_Info;
    entity_types_set : HashSet(*Type_Info_Struct);
    entity_types : [..]*Type_Info_Struct;
    entity_decls : [..]*Code_Declaration;

    component_type : *Type_Info;
    component_types_set : HashSet(*Type_Info_Struct);
    component_types : [..]*Type_Info_Struct;
    component_decls : [..]*Code_Declaration;
}

g_entity_workspace_build_info : [15]EntityWorkspaceBuildInfo;

AddEntityType :: (workspace : Workspace, decl : *Code_Declaration) {
    using _ := *g_entity_workspace_build_info[workspace];

    location := make_location(decl);

    struct_type : *Type_Info_Struct;
    if decl.expression && decl.expression.kind == .STRUCT {
        struct_type = cast(*Code_Struct, decl.expression).defined_type;
    }

    if struct_type {
        _, was_present := HashSetInsert(*entity_types_set, struct_type);
        if !was_present {
            ArrayPush(*entity_types, struct_type);
            ArrayPush(*entity_decls, decl);
        }
    } else {
        compiler_report(
            "Adding Entity type but declaration is not a struct.",
            location
        );
    }
}

AddComponentType :: (workspace : Workspace, decl : *Code_Declaration) {
    using _ := *g_entity_workspace_build_info[workspace];

    location := make_location(decl);

    struct_type : *Type_Info_Struct;
    if decl.expression && decl.expression.kind == .STRUCT {
        struct_type = cast(*Code_Struct, decl.expression).defined_type;
    }

    if struct_type {
        _, was_present := HashSetInsert(*component_types_set, struct_type);
        if !was_present {
            ArrayPush(*component_types, struct_type);
            ArrayPush(*component_decls, decl);
        }
    } else {
        compiler_report(
            "Adding Component type but declaration is not a struct.",
            location
        );
    }
}

HandleDeclarationForEntity :: (workspace : Workspace, decl : *Code_Declaration) {
    using _ := *g_entity_workspace_build_info[workspace];

    struct_type : *Type_Info_Struct;
    if decl.expression && decl.expression.kind == .STRUCT {
        struct_type = cast(*Code_Struct, decl.expression).defined_type;
    }

    if decl.name == "Entity" {// && decl.enclosing_load.fully_pathed_filename == StringJoin(GetRootDirectory(), "Source/Game/API/entity.jai") {
        Println("%", decl.enclosing_load.fully_pathed_filename);
        entity_type = struct_type;
        LogMessage("Found Entity type");
    }

    if decl.name == "Component" {// && decl.enclosing_load.fully_pathed_filename == StringJoin(GetRootDirectory(), "Source/Game/API/component.jai") {
        Println("%", decl.enclosing_load.fully_pathed_filename);
        component_type = struct_type;
        LogMessage("Found Component type");
    }
}

GenerateEntityCode :: (workspace : Workspace, target : *Message) {
    using _ := *g_entity_workspace_build_info[workspace];

    if !target || !entity_type || !component_type || generated_entity_code {
        return;
    }

    defer generated_entity_code = true;

    if !entity_type {
        // ReportErrorsForUnresolvedIdentifiersInAllFiles(workspace);
        compiler_report("Entity type is null when calling GenerateEntityCode.", mode=.ERROR_CONTINUABLE);
        return;
    }

    if !component_type {
        // ReportErrorsForUnresolvedIdentifiersInAllFiles(workspace);
        compiler_report("Component type is null when calling GenerateEntityCode.", mode=.ERROR_CONTINUABLE);
        return;
    }

    for entity_decls {
        TypecheckEntityStruct(workspace, cast(*Code_Struct) it.expression);
    }

    QuickSort(entity_types, (a, b) => StringCompare(a.name, b.name));
    QuickSort(entity_decls, (a, b) => StringCompare(a.name, b.name));

    for component_decls {
        TypecheckComponentStruct(workspace, cast(*Code_Struct) it.expression);
    }

    QuickSort(component_types, (a, b) => StringCompare(a.name, b.name));
    QuickSort(component_decls, (a, b) => StringCompare(a.name, b.name));

    builder : StringBuilder;

    Appendln(*builder, "Entity_Types :: Type.[");
    Appendln(*builder, "    void,");

    for entity_types {
        Appendln(*builder, "    %,", it.name);
    }

    Appendln(*builder, "];");

    Appendln(*builder, "Component_Types :: Type.[");
    Appendln(*builder, "    void,");

    for component_types {
        Appendln(*builder, "    %,", it.name);
    }

    Appendln(*builder, "];");

    add_build_string(StringBuilderBuild(*builder), workspace, target);

    LogMessage("Generated entity code");
}

ContainsPointerTo :: (
    info : *Type_Info,
    predicate : (*Type_Info, *void) -> bool,
    predicate_data : *void,
    typecheck_stack : *[..]*Type_Info = null
) -> bool {
    stack : [..]*Type_Info;
    if !typecheck_stack {
        typecheck_stack = *stack;
    }

    if ArrayFindLast(typecheck_stack.*, info) != -1 {
        return false;
    }

    prev_typecheck_stack_count := typecheck_stack.count;
    ArrayPush(typecheck_stack, info);

    defer {
        ArrayPop(typecheck_stack);
        Assert(typecheck_stack.count == prev_typecheck_stack_count);
    }

    if info.type == {
    case .STRUCT;
        info_struct := cast(*Type_Info_Struct, info);
        for info_struct.members {
            if ContainsPointerTo(it.type, predicate, predicate_data, typecheck_stack) {
                return true;
            }
        }

        return false;

    case .ARRAY;
        info_array := cast(*Type_Info_Array, info);
        return ContainsPointerTo(info_array.element_type, predicate, predicate_data, typecheck_stack);

    case .POINTER;
        info_pointer := cast(*Type_Info_Pointer, info);

        if predicate(info_pointer.pointer_to, predicate_data) {
            return true;
        }

        return ContainsPointerTo(info_pointer.pointer_to, predicate, predicate_data, typecheck_stack);

    case;
        return false;
    }
}

ContainsPointerToEntity :: (workspace : Workspace, info : *Type_Info) -> bool {
    Predicate :: (info : *Type_Info, data : *void) -> bool {
        using _ := cast(*EntityWorkspaceBuildInfo, data);
        return info == entity_type || ArrayFindFirst(entity_types, xx info);
    }

    build_info := *g_entity_workspace_build_info[workspace];
    return ContainsPointerTo(info, predicate=Predicate, build_info);
}

ContainsPointerToComponent :: (workspace : Workspace, info : *Type_Info) -> bool {
    Predicate :: (info : *Type_Info, data : *void) -> bool {
        using _ := cast(*EntityWorkspaceBuildInfo, data);
        return info == component_type || ArrayFindFirst(component_types, xx info);
    }

    build_info := *g_entity_workspace_build_info[workspace];
    return ContainsPointerTo(info, predicate=Predicate, build_info);
}

TypecheckEntityStruct :: (workspace : Workspace, struct_node : *Code_Struct) {
    using _ := *g_entity_workspace_build_info[workspace];

    struct_type := struct_node.defined_type;

    if !TypeIsSubstructOf(struct_type, entity_type) {
        compiler_report("@Entity struct is not a substruct of type Entity.", make_location(struct_node));
    }

    // for struct_node.block.members {
    //     decl := cast(*Code_Declaration) it;

    //     if !(decl.flags & .IS_CONSTANT) && ContainsPointerToEntity(workspace, it.type) {
    //         compiler_report("Entity struct contains a pointer to an entity, which is forbidden. An EntityGUID should be used to reference another entity.", loc = make_location(it));
    //     }
    // }
}

TypecheckComponentStruct :: (workspace : Workspace, struct_node : *Code_Struct) {
    using _ := *g_entity_workspace_build_info[workspace];

    struct_type := struct_node.defined_type;

    if !TypeIsSubstructOf(struct_type, component_type) {
        compiler_report("@Component struct is not a substruct of type Component.", make_location(struct_node));
    }

    // for struct_node.block.members {
    //     decl := cast(*Code_Declaration) it;

    //     if !(decl.flags & .IS_CONSTANT) && ContainsPointerToEntity(workspace, it.type) {
    //         compiler_report("Entity struct contains a pointer to an entity, which is forbidden. An EntityGUID should be used to reference another entity.", loc = make_location(it));
    //     }

    //     // if !(decl.flags & .IS_CONSTANT) && ContainsPointerToComponent(it.type) {
    //     //     compiler_report("Component struct contains a pointer to a component, which is forbidden. An ComponentGUID should be used to reference another component.", loc = make_location(it));
    //     // }
    // }
}
