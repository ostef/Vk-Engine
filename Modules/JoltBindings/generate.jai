// Jolt v5.6.0 via C wrapper

// To compile do `jai generate.jai - build`

#run {
    set_build_options_dc(.{do_output=false});

    build_jolt := false;

    args := get_build_options().compile_time_command_line;
    for args {
        if it == {
        case "build";
            build_jolt = true;
        }
    }

    if build_jolt && !BuildJolt() {
        compiler_set_workspace_status(.FAILED);
        return;
    }

    if !GenerateBindings() {
        compiler_set_workspace_status(.FAILED);
        return;
    }
}

Declarations_To_Omit :: string.[
    "JPH_Quat", "JPH_Vec3", "JPH_Vec4",
];

GenerateBindings :: () -> bool {
    using opts : Generate_Bindings_Options;

    // strip_flags = 0;
    visitor = Visitor;
    generate_compile_time_struct_checks = false;
    // generate_library_declarations = false;

    output_filename: string;
    #if OS == .LINUX {
        output_filename = "jolt_linux.jai";
        array_add(*libraries, .{filename="Libs/Linux/libJoltC", identifier="JoltC"});
    } else {
        assert(false);
    }

    array_add(*strip_prefixes, "JPH_");

    array_add(*include_paths, "Source/JoltC");
    array_add(*source_files, "Source/JoltC/JoltC.h");

    array_add(*extra_clang_arguments, "-x", "c++", "-DWIN32_LEAN_AND_MEAN");

    // @Todo: handle enum flags

    return generate_bindings(opts, output_filename);
}

BuildJolt :: () -> bool {
    {
        working_dir := get_working_directory();
        defer set_working_directory(working_dir);

        set_working_directory(tprint("%/Source/JoltC", working_dir));

        if run_command("rm", "-rf", ".build").exit_code != 0 {
            return false;
        }

        if run_command("make").exit_code != 0 {
            return false;
        }

        // if run_command("cmake", "-B", ".build", "-DJPH_TESTS=OFF", "-DJPH_SAMPLES=OFF").exit_code != 0 {
        //     return false;
        // }

        // if run_command("cmake", "--build", ".build").exit_code != 0 {
        //     return false;
        // }
    }

    #if OS == .LINUX {
        make_directory_if_it_does_not_exist("Libs/Linux", recursive=true);

        if !copy_file("Source/JoltC/libJoltC.a", "Libs/Linux/libJoltC.a") {
            return false;
        }
    } else {
        #assert false "@Todo";
    }

    return true;
}

Visitor :: (decl : *Declaration, parent_decl : *Declaration) -> Declaration_Visit_Result {
    if array_find(Declarations_To_Omit, decl.name) {
        decl.decl_flags |= .OMIT_FROM_OUTPUT;
        return .STOP;
    }

    return .RECURSE;
}

#import "Basic";
#import "Compiler";
#import "Process";
#import "Check";
#import "Bindings_Generator";
#import "File";
#import "File_Utilities";
