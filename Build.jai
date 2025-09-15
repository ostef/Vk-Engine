#import "Common";
Basic :: #import "Basic";
using,only(.["+","-","*","/","<",">","=="]) Basic;
#import "String";
#import "File";
#import "File_Utilities";
#import "Compiler";

ModuleID :: enum {
    Core;
}

Num_Modules :: #run type_info(ModuleID).values.count;

#run {
    for type_info(ModuleID).names {
        add_build_file(TPrint("Source/%/build.jai", it), -1);
    }
}

Max_Workspaces :: 20;

BuildModule :: ($module : ModuleID) -> bool {
    compilation_failed := false;
    name := TPrint("%", module);

    start_time := Basic.current_time_monotonic();
    defer if compilation_failed {
        LogError("Compilation failed for module %", name);
    } else {
        end_time := Basic.current_time_monotonic();
        total_time := end_time - start_time;
        Println("  Compiled module % in % seconds", name, Basic.to_float64_seconds(total_time));
    }

    ws := compiler_create_workspace(name);

    options := get_build_options(ws);
    if module == .Core {
        options.output_type = .EXECUTABLE;
        options.output_executable_name = "Vk";
    } else {
        options.output_type = .DYNAMIC_LIBRARY;
        options.output_path = "Libs";
        options.output_executable_name = name;
    }
    options.import_path = get_build_options().import_path;
    options.Commonly_Propagated = get_build_options().Commonly_Propagated;
    options.write_added_strings = true;
    options.stack_trace = true;
    options.text_output_flags = 0;
    set_build_options(options, ws);

    compiler_begin_intercept(ws);

    filename := ifx module == .Core then "Source/main.jai" else TPrint("Source/%/module.jai", name);
    add_build_file(filename, ws);

    while true {
        msg := compiler_wait_for_message();
        if msg.workspace == ws {
            #insert #run TPrint("#if #exists(%1HandleCompilerMessage) { %1HandleCompilerMessage(msg); }", module);

            if msg.kind == .COMPLETE {
                complete := cast(*Message_Complete, msg);
                if complete.error_code != .NONE {
                    compilation_failed = true;
                }

                break;
            }
        }
    }

    compiler_end_intercept(ws);

    return !compilation_failed;
}

CompareFileTimes :: (a : string, b : string) -> bool {
    a_modtime, _, a_exists := file_modtime_and_size(a);
    if !a_exists {
        return true;
    }

    if !is_directory(b) {
        b_modtime, _, b_exists := file_modtime_and_size(b);
        if !b_exists {
            return true;
        }

        return a_modtime < b_modtime;
    } else {
        files := file_list(b, recursive=true);
        for files {
            modtime := file_modtime_and_size(it);
            if a_modtime < modtime {
                return true;
            }
        }

        return false;
    }
}

Build :: () {
    auto_detect : bool;
    modules_to_build : u64;

    start_time := Basic.current_time_monotonic();
    defer if modules_to_build {
        end_time := Basic.current_time_monotonic();
        total_time := end_time - start_time;
        Println("  Total time: % seconds", Basic.to_float64_seconds(total_time));
    }

    set_build_options_dc(.{do_output=false, write_added_strings=false});

    args := get_build_options().compile_time_command_line;
    arg_index := 0;

    while arg_index < args.count {
        defer arg_index += 1;

        if args[arg_index] == {
        case "auto";
            auto_detect = true;
        case "all";
            modules_to_build = 0xffffffffffffffff;
        case;
            for type_info(ModuleID).names {
                if args[arg_index] == it {
                    modules_to_build |= cast(u64, 1 << it_index);
                    continue;
                }
            }

            LogError("Unknown argument '%'", args[arg_index]);
            Basic.exit(1);
        }
    }

    if !auto_detect && !modules_to_build {
        LogError("Nothing to build");
        Basic.exit(1);
    }

    // Compare file times so we know if we should rebuild a module
    if auto_detect {
        #if OS == {
        case .WINDOWS; Lib_Ext :: "dll";
        case .LINUX;   Lib_Ext :: "so";
        case .MACOS;   Lib_Ext :: "dylib";
        }

        for type_info(ModuleID).names {

            lib_file : string;
            source_dir := TPrint("Source/%", it);
            if it_index == 0 {
                lib_file = ifx OS == .WINDOWS then "Vk.exe" else "Vk";
            } else {
                lib_file = TPrint("Libs/%.%", it, Lib_Ext);
            }

            if it_index == 0 && CompareFileTimes(lib_file, "Source/main.jai") {
                modules_to_build |= cast(u64, 1 << it_index);
            }
            if CompareFileTimes(lib_file, source_dir) {
                modules_to_build |= cast(u64, 1 << it_index);
            }
        }

        #insert -> string {
            builder : StringBuilder;
            for i : 1..Num_Modules - 1 {
                lib_file := TPrint("Libs/%.%", cast(ModuleID, i), Lib_Ext);
                Appendln(*builder, "for %_Module_Dependencies {", cast(ModuleID, i));
                Appendln(*builder, "    if CompareFileTimes(\"%\", it) {", lib_file);
                Appendln(*builder, "        modules_to_build |= cast(u64, 1 << %);", i);
                Appendln(*builder, "    }");
                Appendln(*builder, "}");
            }

            return StringBuilderBuild(*builder);
        }
    }

    make_directory_if_it_does_not_exist("Libs");

    #insert -> string {
        builder : StringBuilder;

        for i : 0..Num_Modules - 1 {
            Appendln(*builder, "if modules_to_build & cast(u64, 1 << %) {", i);
            Appendln(*builder, "    if !BuildModule(.%) {", cast(ModuleID, i));
            Appendln(*builder, "        Basic.exit(1);");
            Appendln(*builder, "    }");
            Appendln(*builder, "}");
        }

        return StringBuilderBuild(*builder);
    }
}

#run,stallable Build();
