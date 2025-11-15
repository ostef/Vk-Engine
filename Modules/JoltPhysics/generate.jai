// Jolt v5.4.0
// @Todo: compile Jolt and JoltC automatically

// > cmake -B .build -DBUILD_SHARED_LIBS=ON
// > cmake --build .build

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
    generate_library_declarations = false;

    output_filename: string;
    #if OS == .WINDOWS {
        output_filename = "jolt_windows.jai";
        array_add(*libraries, .{filename="Lib/Windows/joltcd", identifier="JoltC"});
    } else #if OS == .LINUX {
        output_filename = "jolt_linux.jai";
        array_add(*libraries, .{filename="Lib/Linux/libjoltc", identifier="JoltC"});
    } else #if OS == .MACOS {
        output_filename = "jolt_macos.jai";
    } else {
        assert(false);
    }

    // @Todo: prefixes not stripped for global const declarations
    array_add(*strip_prefixes, "JPH_");

    array_add(*source_files, "JoltC/include/joltc.h");

    array_add(*extra_clang_arguments, "-x", "c++", "-DWIN32_LEAN_AND_MEAN");

    // @Todo: handle enum flags

    return generate_bindings(opts, output_filename);
}

BuildJolt :: () -> bool {
    {
        working_dir := get_working_directory();
        defer set_working_directory(working_dir);

        set_working_directory(tprint("%/JoltC", working_dir));

        if run_command("rm", "-rf", ".build").exit_code != 0 {
            return false;
        }

        if run_command("cmake", "-B", ".build", "-DBUILD_SHARED_LIBS=ON").exit_code != 0 {
            return false;
        }

        if run_command("cmake", "--build", ".build").exit_code != 0 {
            return false;
        }
    }

    #if OS == .WINDOWS {
        make_directory_if_it_does_not_exist("Lib/Windows", recursive=true);

        if !copy_file("JoltC/.build/bin/Debug/joltcd.dll", "Lib/Windows/joltcd.dll") {
            return false;
        }
        if !copy_file("JoltC/.build/bin/Debug/joltcd.pdb", "Lib/Windows/joltcd.pdb") {
            return false;
        }
        if !copy_file("JoltC/.build/lib/Debug/joltcd.lib", "Lib/Windows/joltcd.lib") {
            return false;
        }

        if !copy_file("JoltC/.build/bin/Debug/Joltd.dll", "Lib/Windows/Joltd.dll") {
            return false;
        }
        if !copy_file("JoltC/.build/bin/Debug/Joltd.pdb", "Lib/Windows/Joltd.pdb") {
            return false;
        }
        if !copy_file("JoltC/.build/lib/Debug/Joltd.lib", "Lib/Windows/Joltd.lib") {
            return false;
        }
    } else #if OS == .LINUX {
        make_directory_if_it_does_not_exist("Lib/Linux", recursive=true);

        if !copy_file("JoltC/.build/bin/Debug/libjoltcd.so", "Lib/Linux/libjoltcd.so") {
            return false;
        }

        if !copy_file("JoltC/.build/bin/Debug/libJoltd.so", "Lib/Linux/libJoltd.so") {
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

#scope_file

#import "Basic";
#import "Compiler";
#import "Process";
#import "Check";
#import "Bindings_Generator";
#import "File";
#import "File_Utilities";
