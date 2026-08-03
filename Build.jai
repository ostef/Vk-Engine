#import "Common";
#import "String";
#import "File";
#import "File_Utilities";
#import "Compiler";
Basic :: #import "Basic";
using,only(.["+","-","*","/","<",">","=="]) Basic;

ModuleID :: enum {
    Core;
    Renderer;
    Game;
    Editor;
}

Num_Modules :: #run type_info(ModuleID).values.count;

BindingsToGenerate :: struct {
    module_name : string;
    can_generate := true;
    extra_options : []string;
    windows_libs : []string;
    linux_libs : []string;
    macos_libs : []string;
}

Bindings_To_Generate :: BindingsToGenerate.[
    .{
        module_name="Modules/ImGui",
        windows_libs=.["Libs/Windows/ImGui.dll"],
        linux_libs=.["Libs/Linux/libImGui.so"],
        macos_libs=.["Libs/MacOS/libImGui.dylib"],
    },
    .{
        module_name="Modules/SDL",
        windows_libs=.["Libs/Windows/SDL2.dll"],
        linux_libs=.[], // Use system lib
        macos_libs=.[], // Use system lib
        can_generate=false,
    },
    .{
        module_name="Modules/Vulkan",
        windows_libs=.["Libs/Windows/VkMemAlloc.lib"],
        linux_libs=.["Libs/Linux/libVkMemAlloc.a"],
        macos_libs=.["Libs/MacOS/libVkMemAlloc.a"],
    },
    .{
        module_name="Modules/JoltPhysics",
        extra_options=.["combined_shared_libs"],
        windows_libs=.["Libs/Windows/JoltC.dll"],
        linux_libs=.["Libs/Linux/libJoltC.so"],
        macos_libs=.["Libs/MacOS/libJoltC.dylib"],
    },
];

#insert -> string {
    builder : StringBuilder;

    for type_info(ModuleID).names {
        Appendln(*builder, "%1Module :: #import \"%1/Build\";", it);
    }

    return StringBuilderBuild(*builder);
}

CopyFileIfOutOfDate :: (src_filename : string, dst_filename : string) -> ok : bool, copied : bool {
    src_modtime, _, src_exists := file_modtime_and_size(src_filename);
    if !src_exists {
        LogError("Could not copy file '%' because it does not exist", src_filename);
        return false, false;
    }

    dst_modtime, _, dst_exists := file_modtime_and_size(dst_filename);
    if !dst_exists || dst_modtime < src_modtime {
        ok := copy_file(src_filename, dst_filename);
        if ok {
            LogMessage("Copied file '%' to '%'", src_filename, dst_filename);
        }
        return ok, ok;
    }

    return true, false;
}

BuildModule :: ($module : ModuleID) -> bool {
    log_section := Log_Section.{#run SPrint("Build/%", module)};
    LogSectionScope(*log_section);

    LogMessage("Building module");

    compilation_failed := false;
    name := TPrint("%", module);

    start_time := Basic.current_time_monotonic();
    defer if compilation_failed {
        LogError("Compilation failed");
    } else {
        end_time := Basic.current_time_monotonic();
        total_time := end_time - start_time;
        LogMessage("Compiled module in % seconds", Basic.to_float64_seconds(total_time));
    }

    ws := compiler_create_workspace(name);

    options := get_build_options(ws);
    options.output_path = "Bin";
    if module == .Core {
        options.output_type = .EXECUTABLE;
        options.output_executable_name = "Vk";
    } else {
        options.output_type = .DYNAMIC_LIBRARY;
        options.output_executable_name = name;
    }
    options.import_path = get_build_options().import_path;
    options.Commonly_Propagated = get_build_options().Commonly_Propagated;
    options.write_added_strings = true;
    options.stack_trace = true;
    options.text_output_flags = 0;

    #if OS == .LINUX {
        #import "POSIX";

        options.additional_linker_arguments = .[
            TPrint("-L%/lib", MakeString(getenv("VULKAN_SDK"))),
        ];
    }

    set_build_options(options, ws);

    compiler_begin_intercept(ws);

    add_build_string(TPrint("#import \"%\"(.Main);", name), ws);
    if module == .Core {
        add_build_string("main :: () { LoaderMain(); }", ws);
    }

    while true {
        msg := compiler_wait_for_message();
        if msg.workspace == ws {
            #insert #run TPrint("#if #exists(%1Module.HandleCompilerMessage) { %1Module.HandleCompilerMessage(msg); }", module);

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

ListDirectories :: (path : string, recursive := false, follow_directory_symlinks := true) -> []string {
    files : [..]string;

    Visitor :: (info : *File_Visit_Info, user_data : *[..]string) {
        ArrayPush(user_data, StringClone(info.full_name));
    }

    visit_files(path, recursive, *files, Visitor, visit_files=false, visit_directories=true, follow_directory_symlinks=follow_directory_symlinks);

    return files;
}

ShouldBuildModule :: ($module : ModuleID) -> bool {
    #if OS == {
    case .WINDOWS; Lib_Ext :: "dll";
    case .LINUX;   Lib_Ext :: "so";
    case .MACOS;   Lib_Ext :: "dylib";
    }

    lib_file : string;
    source_dir := TPrint("Source/%", module);
    if module == .Core {
        lib_file = ifx OS == .WINDOWS then "Bin/Vk.exe" else "Bin/Vk";
    } else {
        lib_file = TPrint("Bin/%.%", module, Lib_Ext);
    }

    if CompareFileTimes(lib_file, source_dir) {
        return true;
    }

    dependencies := #insert #run TPrint("%Module.Module_Dependencies;", module);
    for dependencies {
        dirs := ListDirectories(TPrint("Source/%", it), recursive=true);
        for dir : dirs {
            if path_filename(dir) == "API" && CompareFileTimes(lib_file, dir) {
                return true;
            }
        }

        if CompareFileTimes(lib_file, TPrint("Source/%/module_api.jai", it)) {
            return true;
        }
        if CompareFileTimes(lib_file, TPrint("Source/%/module.jai", it)) {
            return true;
        }
    }

    return false;
}

GenerateBindings :: (using bindings : BindingsToGenerate, build : bool) {
    ws := compiler_create_workspace(module_name);

    options := get_build_options(ws);
    cmd_line_options : [..]string;
    if build {
        ArrayPush(*cmd_line_options, "build");
    }
    ArrayPushMultiple(*cmd_line_options, extra_options);
    options.compile_time_command_line = cmd_line_options;

    set_build_options(options, ws);

    compiler_begin_intercept(ws);

    add_build_file(SPrint("%/generate.jai", module_name), ws);

    working_dir := Basic.get_working_directory();
    defer Basic.set_working_directory(working_dir);

    Basic.set_working_directory(SPrint("%/%", working_dir, module_name));

    while true {
        msg := compiler_wait_for_message();
        if msg.workspace == ws && msg.kind == .COMPLETE {
            if cast(*Message_Complete, msg).error_code != .NONE {
                LogError("Could not generate bindings for %", module_name);
            } else {
                LogMessage("Generated bindings for %", module_name);
            }

            break;
        }
    }

    compiler_end_intercept(ws);
}

Build :: () {
    Log_Build :: Log_Section.{name="Build"};
    LogSectionScope(*Log_Build);

    console_logger : ConsoleLogger;
    InitConsoleLogger(*console_logger);
    SetContextLogger(*console_logger, ConsoleLoggerProc);

    auto_detect : bool;
    modules_to_build : u64;
    generate_bindings : bool;
    build_bindings : bool;

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
        case "generate_bindings";
            generate_bindings = true;
        case "build_bindings";
            generate_bindings = true;
            build_bindings = true;
        case;
            found_module := false;
            for type_info(ModuleID).names {
                if args[arg_index] == it {
                    modules_to_build |= cast(u64, 1 << it_index);
                    found_module = true;
                    break;
                }
            }

            if !found_module {
                LogError("Unknown argument '%'", args[arg_index]);
                Basic.exit(1);
            }
        }
    }

    if !auto_detect && !modules_to_build && !generate_bindings {
        LogError("Nothing to build");

        Println("Usage: % [default metaprogram option(s)] [- option(s) or module(s) to build]", ifx OS == .WINDOWS then "Build" else "./Build.sh");
        Print("\nModules: ");
        for type_info(ModuleID).names {
            if it_index > 0 {
                Print(", ");
            }
            Print("%", it);
        }
        Println("\n");

        Println("Valid options:");
        Println("  all:               build all modules");
        Println("  auto:              auto detect modules to build");
        Println("  generate_bindings: (re)generate all bindings");
        Println("  build_bindings:    (re)generate all bindings after building their source code (simply passes build to the bindings' generate.jai)");

        Basic.exit(1);
    }

    make_directory_if_it_does_not_exist("Bin");

    if generate_bindings {
        for Bindings_To_Generate {
            if !it.can_generate {
                continue;
            }

            GenerateBindings(it, build=build_bindings);
        }
    } else {
        for Bindings_To_Generate {
            if !it.can_generate {
                continue;
            }

            #if OS == {
            case .WINDOWS;
                libs := it.windows_libs;
            case .LINUX;
                libs := it.linux_libs;
            case .MACOS;
                libs := it.macos_libs;
            }

            for lib : libs {
                filename := SPrint("%/%", it.module_name, lib);
                if !file_exists(filename) {
                    GenerateBindings(it, build=true);
                }
            }
        }
    }

    #insert -> string {
        builder : StringBuilder;

        for i : 0..Num_Modules - 1 {
            Appendln(*builder, "if auto_detect && ShouldBuildModule(.%) {", cast(ModuleID, i));
            Appendln(*builder, "    modules_to_build |= cast(u64, 1 << %);", i);
            Appendln(*builder, "}");
            Appendln(*builder, "if modules_to_build & cast(u64, 1 << %) {", i);
            Appendln(*builder, "    if !BuildModule(.%) {", cast(ModuleID, i));
            Appendln(*builder, "        Basic.exit(1);");
            Appendln(*builder, "    }");
            Appendln(*builder, "} else if auto_detect {");
            Appendln(*builder, "    LogMessage(\"Module % is up to date\");", cast(ModuleID, i));
            Appendln(*builder, "}");
        }

        return StringBuilderBuild(*builder);
    }

    for Bindings_To_Generate {
        #if OS == {
        case .WINDOWS;
            libs := it.windows_libs;
        case .LINUX;
            libs := it.linux_libs;
        case .MACOS;
            libs := it.macos_libs;
        }

        for lib : libs {
            filename := SPrint("%/%", it.module_name, lib);
            if path_extension(filename) == {
            case "dll";
            case "so";
            case "dylib";
            case;
                continue;
            }

            CopyFileIfOutOfDate(filename, SPrint("Bin/%", path_filename(filename)));
        }
    }
}

#run,stallable Build();
