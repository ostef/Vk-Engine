// @Todo: compile Jolt

#run {
    set_build_options_dc(.{do_output=false});

    if !GenerateBindings() {
        compiler_set_workspace_status(.FAILED);
        return;
    }
}

GenerateBindings :: () -> bool {
    using opts : Generate_Bindings_Options;

    // strip_flags = 0;
    generate_compile_time_struct_checks = false;

    output_filename: string;
    #if OS == .WINDOWS {
        output_filename = "jolt_windows.jai";
        array_add(*libraries, .{filename="Lib/Windows/joltc", identifier="JoltC"});
    } else #if OS == .LINUX {
        output_filename = "jolt_linux.jai";
        array_add(*libraries, .{filename="Lib/Linux/libjoltc", identifier="JoltC"});
    } else #if OS == .MACOS {
        output_filename = "jolt_macos.jai";
    } else {
        assert(false);
    }

    // @Todo: prefixes not stripped for global const declarations
    array_add(*strip_prefixes, "JPC_");

    array_add(*include_paths, "JoltC");
    array_add(*source_files, "JoltC/JoltC/JoltC.h");

    array_add(*extra_clang_arguments, "-x", "c++", "-DWIN32_LEAN_AND_MEAN");

    // @Todo: handle enum flags

    return generate_bindings(opts, output_filename);
}

#scope_file

#import "Basic";
#import "Compiler";
#import "BuildCpp";
#import "Check";
#import "Bindings_Generator";
#import "File";
