// @Todo: compile Jolt

#run {
    set_build_options_dc(.{do_output=false});

    if !GenerateBindings() {
        compiler_set_workspace_status(.FAILED);
        return;
    }
}

GenerateBindings :: () -> bool {
    output_filename: string;
    opts: Generate_Bindings_Options;
    {
        using opts;

        #if OS == .WINDOWS {
            output_filename = "jolt_windows.jai";
            // strip_flags = 0;
        } else #if OS == .LINUX {
            output_filename = "jolt_linux.jai";
            strip_flags = .INLINED_FUNCTIONS; // Inlined constructor doesn't exist in the library
        } else #if OS == .MACOS {
            output_filename = "jolt_macos.jai";
            strip_flags = .INLINED_FUNCTIONS; // Inlined constructor doesn't exist in the library
        } else {
            assert(false);
        }

        // @Todo: prefixes not stripped for global const declarations
        array_add(*strip_prefixes, "JPC_");

        array_add(*libraries, .{filename="Lib/Windows/joltc", identifier="JoltC"});
        array_add(*include_paths, "JoltC");
        array_add(*source_files, "JoltC/JoltC/JoltC.h");

        array_add(*extra_clang_arguments, "-x", "c++", "-DWIN32_LEAN_AND_MEAN");

        opts.generate_compile_time_struct_checks = false;

        // @Todo: handle enum flags
    }

    return generate_bindings(opts, output_filename);
}

#scope_file

#import "Basic";
#import "Compiler";
#import "BuildCpp";
#import "Check";
#import "Bindings_Generator";
#import "File";
