// Jolt v5.6.0 via C wrapper

// To compile do `jai generate.jai - build` or do it manually:
// > cd Source/JoltC
// > cmake -B .build
// > cmake --build .build

#run {
    set_build_options_dc(.{do_output=false});

    build_joltc := false;
    shared_libs := false;
    combined_shared_libs := false;
    build_type := "Debug";

    args := get_build_options().compile_time_command_line;
    for args {
        if it == {
        case "build";
            build_joltc = true;
        case "shared_libs";
            shared_libs = true;
        case "combined_shared_libs";
            combined_shared_libs = true;
        case "build_debug";
            build_type = "Debug";
        case "build_release";
            build_type = "Release";
        case "build_distribution";
            build_type = "Distribution";
        }
    }

    if build_joltc && !BuildJoltC(shared_libs, combined_shared_libs, build_type) {
        compiler_set_workspace_status(.FAILED);
        return;
    }

    if !GenerateBindings(shared_libs, combined_shared_libs) {
        compiler_set_workspace_status(.FAILED);
        return;
    }
}

Declarations_To_Omit :: string.[
    "JPH_UVec4", "JPH_Vec3", "JPH_Vec4", "JPH_Mat44", "JPH_DVec3", "JPH_DMat44", "JPH_Quat", "JPH_AABox", "JPH_Plane", "JOLTC_VERSION_FEATURES"
];

GenerateBindings :: (shared_libs : bool, combined_shared_libs : bool) -> bool {
    using opts : Generate_Bindings_Options;

    visitor = Visitor;
    auto_detect_enum_prefixes = false;
    generate_compile_time_struct_checks = false;

    output_filename: string;
    #if OS == .LINUX {
        output_filename = "jolt_linux.jai";

        if !combined_shared_libs {
            array_add(*libraries, .{filename="Libs/Linux/libJolt", identifier="Jolt"});
        }
        array_add(*libraries, .{filename="Libs/Linux/libJoltC", identifier="JoltC"});
    } else {
        assert(false);
    }

    array_add(*strip_prefixes, "JPH_");
    array_add(*strip_prefixes, "JOLTC_");

    array_add(*include_paths, "Source/JoltC");
    array_add(*source_files, "Source/JoltC/JoltC.h");

    // @Todo: get these reliably based on the compile options
    // array_add(*extra_clang_arguments, "-DJPH_DOUBLE_PRECISION");
    // array_add(*extra_clang_arguments, "-DJPH_CROSS_PLATFORM_DETERMINISTIC");
    // array_add(*extra_clang_arguments, "-DJPH_FLOATING_POINT_EXCEPTIONS_ENABLED");
    array_add(*extra_clang_arguments, "-DJPH_PROFILE_ENABLED");
    // array_add(*extra_clang_arguments, "-DJPH_EXTERNAL_PROFILE");
    array_add(*extra_clang_arguments, "-DJPH_DEBUG_RENDERER");
    // array_add(*extra_clang_arguments, "-DJPH_DISABLE_TEMP_ALLOCATOR");
    // array_add(*extra_clang_arguments, "-DJPH_DISABLE_CUSTOM_ALLOCATOR");
    // array_add(*extra_clang_arguments, "-DJPH_OBJECT_LAYER_BITS=32");
    array_add(*extra_clang_arguments, "-DJPH_ENABLE_ASSERTS");
    array_add(*extra_clang_arguments, "-DJPH_OBJECT_STREAM");

    array_add(*extra_clang_arguments, "-x", "c++", "-DWIN32_LEAN_AND_MEAN");

    // @Todo: handle enum flags

    return generate_bindings(opts, output_filename);
}

BuildJoltC :: (build_shared_libs : bool, build_combined_shared_libs : bool, build_type : string) -> bool {
    {
        working_dir := get_working_directory();
        defer set_working_directory(working_dir);

        set_working_directory(tprint("%/Source/JoltC", working_dir));

        if run_command("rm", "-rf", ".build").exit_code != 0 {
            return false;
        }

        configure : [..]string;
        array_add(*configure, "cmake", "-B", ".build");
        array_add(*configure, tprint("-DBUILD_SHARED_LIBS=%", ifx build_shared_libs then "ON" else "OFF"));
        array_add(*configure, tprint("-DJOLTC_BUILD_COMBINED_SHARED_LIBS=%", ifx build_combined_shared_libs then "ON" else "OFF"));
        array_add(*configure, tprint("-DCMAKE_BUILD_TYPE=%", build_type));

        configure_str : string;
        for configure {
            if it_index > 0 {
                configure_str = sprint("% ", configure_str);
            }
            configure_str = sprint("%%", configure_str, it);
        }

        log("Running: %", configure_str);

        if run_command(..configure).exit_code != 0 {
            return false;
        }

        num_jobs := max(get_number_of_processors(.ALL_LOGICAL) - 1, 2);

        build : [..]string;
        array_add(*build, "cmake", "--build", ".build", tprint("-j%", num_jobs));

        build_str : string;
        for build {
            if it_index > 0 {
                build_str = sprint("% ", build_str);
            }
            build_str = sprint("%%", build_str, it);
        }

        log("Running: %", build_str);

        if run_command(..build).exit_code != 0 {
            return false;
        }
    }

    log("Copying library files");

    #if OS == .LINUX {
        // Purge the lib directory because files with different configuration conflict each other
        if run_command("rm", "-rf", "Libs/Linux").exit_code != 0 {
            return false;
        }

        make_directory_if_it_does_not_exist("Libs/Linux", recursive=true);

        if !build_shared_libs && !build_combined_shared_libs {
            if !copy_file("Source/JoltC/.build/_deps/joltphysics-build/libJolt.a", "Libs/Linux/libJolt.a") {
                return false;
            }
            if !copy_file("Source/JoltC/.build/libJoltC.a", "Libs/Linux/libJoltC.a") {
                return false;
            }
        } else {
            if !build_combined_shared_libs {
                if !copy_file("Source/JoltC/.build/_deps/joltphysics-build/libJolt.so", "Libs/Linux/libJolt.so") {
                    return false;
                }
            }

            if !copy_file("Source/JoltC/.build/libJoltC.so", "Libs/Linux/libJoltC.so") {
                return false;
            }
        }
    } else {
        #assert false "@Todo";
    }

    return true;
}

Visitor :: (decl : *Declaration, parent_decl : *Declaration) -> Declaration_Visit_Result {
    GetAssociatedEnumName :: (name : string) -> string {
        if name.count > 1 && name[name.count - 1] != #char "_" {
            return tprint("%_", name);
        }

        return name;
    }

    FixupEnumDecl :: (type : *CType) -> bool {
        if !type.type_of_typedef {
            return false;
        }

        old_name := type.type_of_typedef.name;
        if !old_name {
            return false;
        }

        new_name := GetAssociatedEnumName(old_name);

        for context.generator.global_scope.members {
            if it.kind != .ENUM || it.name != new_name {
                continue;
            }

            enum_decl := cast(*Enum) it;

            // Don't output the integer typedef
            type.type_of_typedef.decl_flags |= .OMIT_FROM_OUTPUT;

            // Make sure the enums like 'Focus_Flags_' get outputted as 'FocusFlags'
            if enum_decl.output_name.count > 2 && enum_decl.output_name[enum_decl.output_name.count - 1] == #char "_" {
                enum_decl.output_name.count -= 1;
            }

            // Swap in the enum for the typedef
            enum_decl.type = type.type_of_typedef.type;

            type.type_of_typedef = null;
            type.type_of_enum = enum_decl;

            return true;
        }

        return false;
    }

    FixupEnumDecl :: (decl : *Declaration) {
        if decl.kind == .DECLARATION && FixupEnumDecl(decl.type) {
            decl.decl_flags |= .NEEDS_DEFAULT_ARGUMENT_CAST;
        }
    }

    if array_find(Declarations_To_Omit, decl.name) {
        decl.decl_flags |= .OMIT_FROM_OUTPUT;
        return .STOP;
    }

    // We want to generate the correct strongly typed enum,
    // so each time we have an argument, return type or a struct member that
    // is a typedef, we search all the members we've compiled
    // so far to find the correct enum type
    if parent_decl
    && (parent_decl.kind == .FUNCTION || parent_decl.kind == .STRUCT) {
        FixupEnumDecl(decl);
    } else if decl.type && decl.type.type_of_function {
        FixupEnumDecl(decl.type.type_of_function.return_type);
    }

    return .RECURSE;
}

#import "System";
#import "Basic";
#import "Compiler";
#import "Process";
#import "Check";
#import "Bindings_Generator";
#import "File";
#import "File_Utilities";
