// Dear ImGui v1.90.4 with docking

#import "Basic";
#import "File";
#import "File_Utilities";
#import "String";
#import "Compiler";
#import "Process";
#import "BuildCpp";
#import "Bindings_Generator";

#if OS != .WINDOWS && OS != .LINUX && OS != .MACOS {
    #assert false "Only Windows, Linux and MacOS are supported for now.";
}

FlagsForSpecificDeclaration :: struct {
    name : string;
    flags : Declaration_Flags;
}

Global_Declarations_Flags :: FlagsForSpecificDeclaration.[
    .{"ImRect", .OMIT_FROM_OUTPUT},
    .{"ImVec2", .OMIT_FROM_OUTPUT},
    .{"ImVec4", .OMIT_FROM_OUTPUT},
    .{"ImColor", .OMIT_FROM_OUTPUT},
    .{"ImVector", .OMIT_FROM_OUTPUT},
    .{"ImBitArray", .OMIT_FROM_OUTPUT},
    .{"ImBitArrayForNamedKeys", .OMIT_FROM_OUTPUT},
    .{"ImDrawCallback", .OMIT_FROM_OUTPUT},
    .{"ImDrawCallback_ResetRenderState", .OMIT_FROM_OUTPUT},
    .{"ImGuiContext", .TYPE_INFO_NONE},
];

Defines :: string.[];

#run {
    set_build_options_dc(.{do_output=false});

    build_imgui := false;
    build_debug := true;

    args := get_build_options().compile_time_command_line;
    for args {
        if it == {
        case "build";
            build_imgui = true;

        case "release";
            build_debug = false;
        }
    }

    copy_file("imconfig.h", "Source/imconfig.h");

    if build_imgui && !BuildImGui(build_debug) {
        compiler_set_workspace_status(.FAILED);
        return;
    }

    if !GenerateBindings() {
        compiler_set_workspace_status(.FAILED);
        return;
    }
}

BuildImGui :: (debug : bool) -> bool {
    cwd := get_working_directory();
    set_working_directory(#filepath);
    defer set_working_directory(cwd);

    src_files : [..]string;
    array_add(*src_files, "Source/imgui.cpp");
    array_add(*src_files, "Source/imgui_widgets.cpp");
    array_add(*src_files, "Source/imgui_draw.cpp");
    array_add(*src_files, "Source/imgui_tables.cpp");
    array_add(*src_files, "Source/imgui_demo.cpp");

    #if OS == .WINDOWS {
        // Purge the lib directory because files with different configuration conflict each other
        if run_command("rm", "-rf", "Libs/Windows").exit_code != 0 {
            return false;
        }

        make_directory_if_it_does_not_exist("Libs/Windows", recursive=true);

        extra : [..]string;
        array_add(*extra, "/ISource");
        array_add(*extra, "-DIMGUI_API=__declspec(dllexport)");
        for Defines {
            array_add(*extra, tprint("-D%", it));
        }

        success := build_cpp_dynamic_lib("Libs/Windows/ImGui", ..src_files, extra=extra, debug=debug);
    } else #if OS == .LINUX {
        // Purge the lib directory because files with different configuration conflict each other
        if run_command("rm", "-rf", "Libs/Linux").exit_code != 0 {
            return false;
        }

        make_directory_if_it_does_not_exist("Libs/Linux", recursive=true);

        extra : [..]string;
        for Defines {
            array_add(*extra, tprint("-D%", it));
        }

        array_add(*extra, "-fPIC");

        success := build_cpp_dynamic_lib("Libs/Linux/libImGui", ..src_files, extra=extra, debug=debug);
    } else {
        #assert false "Unsupported platform";
        success := false;
    }

    return success;
}

g_begin_end_string_args : [..]*Declaration;

GenerateBindings :: () -> bool {
    cwd := get_working_directory();
    set_working_directory(#filepath);
    defer set_working_directory(cwd);

    #if OS == .WINDOWS {
        output_filename := "imgui_windows.jai";
    } else #if OS == .LINUX {
        output_filename := "imgui_linux.jai";
    } else #if OS == .MACOS {
        output_filename := "imgui_macos.jai";
    }

    opts : Generate_Bindings_Options;
    opts.generate_library_declarations = false;

    #if OS == .WINDOWS {
        array_add(*opts.libraries, .{filename="Libs/Windows/ImGui", identifier="ImGui"});
    } else #if OS == .LINUX {
        array_add(*opts.libraries, .{filename="Libs/Linux/libImGui", identifier="ImGui"});
    } else {
        #assert false "Unsupported platform";
    }

    array_add(*opts.include_paths, "Source");
    array_add(*opts.source_files, "Source/imgui.h",);
    array_add(*opts.source_files, "Source/imgui_internal.h");

    array_add(*opts.extra_clang_arguments, "-x", "c++");

    for Defines {
        array_add(*opts.extra_clang_arguments, tprint("-D%", it));
    }

    array_add(*opts.flatten_namespaces, "ImGui");
    array_add(*opts.strip_prefixes, "ImGui");
    opts.auto_detect_enum_prefixes = false;
    opts.generate_compile_time_struct_checks = false;

    opts.visitor = HandleDeclaration;
    opts.get_func_args_for_printing = GetFuncArgsForPrinting;

    return generate_bindings(opts, output_filename);
}

// This is a function that is called for each declaration, so the user
// fine tune how to bindings are generated.
// For ImGui, we handle enum types and const char * function argument pairs that
// ends with _begin and _end.
HandleDeclaration :: (decl : *Declaration, parent_decl : *Declaration) -> Declaration_Visit_Result {
    GetAssociatedEnumName :: (name : string) -> string {
        if name.count > 1 && name[name.count - 1] != #char "_" {
            return tprint("%_", name);
        }

        return name;
    }

    if !parent_decl {
        for Global_Declarations_Flags {
            if decl.name == it.name {
                decl.decl_flags |= it.flags;

                print("% : %\n", decl.name, decl.decl_flags);

                if decl.decl_flags | .OMIT_FROM_OUTPUT {
                    return .STOP;
                }
            }
        }
    }

    // TypeContainsNamedType :: (type : *CType, name : string) -> bool {
    //     decl : *Declaration;

    //     while true {
    //         if type.pointer_to {
    //             type = type.pointer_to;
    //         } else if type.array_element_type {
    //             type = type.array_element_type;
    //         } else {
    //             break;
    //         }
    //     }

    //     if type.type_of_enum {
    //         decl = type.type_of_enum;
    //     } else if type.type_of_struct {
    //         decl = type.type_of_struct;
    //     } else if type.type_of_typedef {
    //         decl = type.type_of_typedef;
    //     }

    //     for type.template_instantiation_params {
    //         if TypeContainsNamedType(it, name) {
    //             return true;
    //         }
    //     }

    //     if !decl {
    //         return false;
    //     }

    //     return name == decl.output_name;
    // }

    // Avoid name clashing in a more sophisticated way that the default thing
    // if decl.kind == .DECLARATION && decl.type {
    //     if TypeContainsNamedType(decl.type, decl.output_name) {
    //         decl.output_name = sprint("%_", decl.output_name);
    //     }
    // }

    // We want to generate the correct strongly typed enum,
    // so each time we have an argument or a struct member that
    // is a typedef, we search all the members we've compiled
    // so far to find the correct enum type
    if parent_decl
    && (parent_decl.kind == .FUNCTION || parent_decl.kind == .STRUCT)
    && decl.kind == .DECLARATION && decl.type.type_of_typedef {
        old_name := decl.type.type_of_typedef.name;
        if !old_name {
            return .RECURSE;
        }

        new_name := GetAssociatedEnumName(old_name);

        for context.generator.global_scope.members {
            if it.kind != .ENUM || it.name != new_name {
                continue;
            }

            enum_decl := cast(*Enum) it;

            // Don't output the integer typedef
            decl.type.type_of_typedef.decl_flags |= .OMIT_FROM_OUTPUT;

            // Make sure the enums like 'Focus_Flags_' get outputted as 'FocusFlags'
            if enum_decl.output_name.count > 2 && enum_decl.output_name[enum_decl.output_name.count - 1] == #char "_" {
                enum_decl.output_name.count -= 1;
            }

            // Swap in the enum for the typedef
            decl.type.type_of_typedef = null;
            decl.type.type_of_enum = enum_decl;

            decl.decl_flags |= .NEEDS_DEFAULT_ARGUMENT_CAST;

            break;
        }
    }

    if decl.kind == {
    case .ENUM;
        // ImGui has lots of enums that should be enum flags. Luckily, they all end with "Flags_".
        if ends_with(decl.name, "Flags_") {
            enum_decl := cast(*Enum) decl;
            enum_decl.flags |= .IS_ENUM_FLAGS;
            enum_decl.flags |= .VALUES_IN_HEX;
        }

    case .FUNCTION;
        func := cast(*Function) decl;
        type := func.type.type_of_function;

        // ImGui also has functions with pairs of arguments like "text_begin" and "text_end"
        // for the pointers to the beginning and end of a string. We'll generate wrappers for
        // those function which take a jai string.
        //
        // Here we collect pointers to "_begin" arguments, and use them in
        // GetFuncArgsForPrinting below.
        for type.arguments {
            if it_index == 0 || !ends_with(it.name, "_end") {
                continue;
            }

            // Ignore non string types
            if !it.type.pointer_to || !(it.type.pointer_to.number_flags & ._8BIT) {
                continue;
            }

            basename := slice(it.name, 0, it.name.count - "_end".count);
            if !basename {
                continue;
            }

            // The first arg may appear as "text_begin" or just "text"
            name_with_begin := tprint("%_begin", basename);
            prev_arg := type.arguments[it_index - 1];
            if prev_arg.name == basename || prev_arg.name == name_with_begin {
                array_add(*g_begin_end_string_args, prev_arg);
                func.decl_flags |= .NEEDS_ARGUMENT_WRAPPER;
            }
        }
    }

    return .RECURSE;
}

GetFuncArgsForPrinting :: (func : *Function, type : *Function_Type, mode : Arg_Print_Mode) -> []*Declaration {
    args : [..]*Declaration;

    for type.arguments {
        if array_find(g_begin_end_string_args, it) {
            if mode == {
            case .OUTER_WRAPPER;
                // For the outer wrapper, remove any "_begin" part of the argument, and
                // change its type to a jai string
                new_arg := New(Declaration);
                new_arg.* = it.*;
                new_arg.type = context.generator.type_def_jai_string;

                if ends_with(it.name, "_begin") {
                    new_arg.output_name = slice(it.name, 0, it.name.count - "_begin".count);
                }

                array_add(*args, new_arg);

                it_index += 1;	// Skip the next arg since we merged the _begin and _end pairs

                continue;

            case .INNER_WRAPPER_CALL;
                basename := it.name;
                if ends_with(basename, "_begin") {
                    basename = slice(basename, 0, basename.count - "_begin".count);
                }

                first_arg := New(Declaration);
                first_arg.* = it.*;
                first_arg.output_name = tprint("%.data", basename);
                array_add(*args, first_arg);

                second_arg := New(Declaration);
                second_arg.* = it.*;
                second_arg.output_name = tprint("%.data + %.count", basename, basename);
                array_add(*args, second_arg);

                it_index += 1;	// Skip the next arg since we already added the second one

                continue;
            }
        }

        array_add(*args, it);
    }

    return args;
}
