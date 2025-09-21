#import "Basic";
#import "File";
#import "File_Utilities";
#import "String";
#import "Bindings_Generator";

#if OS != .WINDOWS && OS != .LINUX && OS != .MACOS
    #assert false "Only Windows, Linux and MacOS are supported for now.";

Cpp_Source_Path :: "source";

FlagsForSpecificDeclaration :: struct
{
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

Always_Compile_Cpp_Source :: false;
Compile_Debug :: true;
Include_Demo  :: true;

g_begin_end_string_args : [..]*Declaration;

#run
{
    #import "Compiler";

    set_build_options_dc(.{do_output = false});

#if OS == .WINDOWS
    compile_source := Always_Compile_Cpp_Source
        || !file_exists("win/ImGui.dll") || !file_exists("win/ImGui.lib");
else #if OS == .LINUX
    compile_source := Always_Compile_Cpp_Source
        || !file_exists("linux/ImGui.so") || !file_exists("linux/ImGui.a");
else #if OS == .MACOS
    compile_source := Always_Compile_Cpp_Source
        || !file_exists("macos/ImGui.dylib") || !file_exists("macos/ImGui.a");

    copy_file("imconfig.h", "source/imconfig.h");

    if compile_source
    {
        if !CompileCppSource()
        {
            compiler_set_workspace_status(.FAILED);
            return;
        }
    }

    if !GenerateBindings()
    {
        compiler_set_workspace_status(.FAILED);
        return;
    }
}

CompileCppSource :: () -> bool
{
    #import "BuildCpp";

    src_files : [..]string;
    array_add(*src_files, tprint("%/imgui.cpp", Cpp_Source_Path));
    array_add(*src_files, tprint("%/imgui_widgets.cpp", Cpp_Source_Path));
    array_add(*src_files, tprint("%/imgui_draw.cpp", Cpp_Source_Path));
    array_add(*src_files, tprint("%/imgui_tables.cpp", Cpp_Source_Path));

    #if Include_Demo
        array_add(*src_files, tprint("%/imgui_demo.cpp", Cpp_Source_Path));

    success := true;
    #if OS == .WINDOWS
    {
        make_directory_if_it_does_not_exist("win");

        extra : [..]string;
        array_add(*extra, tprint("/I%", Cpp_Source_Path));
        array_add(*extra, "/DIMGUI_API=__declspec(dllexport)");
        for Defines
            array_add(*extra, tprint("/D%", it));

        success &&= build_cpp_dynamic_lib("win/ImGui", ..src_files, extra = extra, debug = Compile_Debug);

        // We set IMGUI_DISABLE_WIN32_DEFAULT_IME_FUNCTIONS. Otherwise all users of the ImGui module have to link against "imm32".
        array_add(*extra, "/DIMGUI_DISABLE_WIN32_DEFAULT_IME_FUNCTIONS");
        success &&= build_cpp_static_lib("win/ImGui", ..src_files, extra = extra, debug = Compile_Debug);
    }
    else #if OS == .LINUX
    {
        make_directory_if_it_does_not_exist("linux");

        extra : [..]string;
        for Defines
            array_add(*extra, tprint("-D%", it));

        success &&= build_cpp_dynamic_lib("linux/ImGui", ..src_files, extra = extra, debug = Compile_Debug);

        array_add(*extra, "-fno-exceptions", "-fno-rtti", "-fno-threadsafe-statics");
        success &&= build_cpp_static_lib("linux/ImGui", ..src_files, extra = extra, debug = Compile_Debug);
    }
    else #if OS == .MACOS
    {
        #import "Process";

        make_directory_if_it_does_not_exist("macos");

        // x86_64 version
        {
            extra : [..]string;

            for Defines
                array_add(*extra, tprint("-D%", it));

            array_add(*extra, "-arch", "x86_64", "-std=c++20", "-mmacos-version-min=10.13");

            success &&= build_cpp_dynamic_lib("macos/ImGui_x64", ..src_files, extra = extra, debug = Compile_Debug);

            array_add(*extra, "-fno-exceptions", "-fno-rtti", "-fno-threadsafe-statics");
            success &&= build_cpp_static_lib("macos/ImGui_x64", ..src_files, extra = extra, debug = Compile_Debug);
        }

        // arm64 version
        {
            extra : [..]string;

            for Defines
                array_add(*extra, tprint("-D%", it));

            array_add(*extra, "-arch", "arm64", "-std=c++20", "-mmacos-version-min=11.0");

            success &&= build_cpp_dynamic_lib("macos/ImGui_arm64", ..src_files, extra = extra, debug = Compile_Debug);

            array_add(*extra, "-fno-exceptions", "-fno-rtti", "-fno-threadsafe-statics");
            success &&= build_cpp_static_lib("macos/ImGui_arm64", ..src_files, extra = extra, debug = Compile_Debug);
        }

        // Create universal lib
        success &&= run_command("lipo", "-create", "macos/ImGui_x64.dylib", "macos/ImGui_arm64.dylib", "-output", "macos/ImGui.dylib").exit_code == 0;
        success &&= run_command("lipo", "-create", "macos/ImGui_x64.a", "macos/ImGui_arm64.a", "-output", "macos/ImGui.a").exit_code == 0;
    }

    return success;
}

GenerateBindings :: () -> bool
{
    #if OS == .WINDOWS
        output_filename := "imgui_windows.jai";
    else #if OS == .LINUX
        output_filename := "imgui_linux.jai";
    else #if OS == .MACOS
        output_filename := "imgui_macos.jai";

    opts : Generate_Bindings_Options;

    #if OS == .WINDOWS
        array_add(*opts.libpaths, "win");
    else #if OS == .LINUX
        array_add(*opts.libpaths, "linux");
    else #if OS == .MACOS
        array_add(*opts.libpaths, "macos");

    array_add(*opts.libnames, "ImGui");
    array_add(*opts.include_paths, Cpp_Source_Path);
    array_add(*opts.source_files, tprint("%/imgui.h", Cpp_Source_Path));
    array_add(*opts.source_files, tprint("%/imgui_internal.h", Cpp_Source_Path));

    array_add(*opts.extra_clang_arguments, "-x", "c++");
    for Defines
        array_add(*opts.extra_clang_arguments, tprint("-D%", it));

    array_add(*opts.flatten_namespaces, "ImGui");
    array_add(*opts.strip_prefixes, "ImGui");
    opts.auto_detect_enum_prefixes = false;
    opts.generate_compile_time_struct_checks = false;
    // opts.strip_flags |= .INLINED_FUNCTIONS;

    opts.visitor = HandleDeclaration;
    opts.get_func_args_for_printing = GetFuncArgsForPrinting;

    return generate_bindings(opts, output_filename);
}

// This is a function that is called for each declaration, so the user
// fine tune how to bindings are generated.
// For ImGui, we handle enum types and const char * function argument pairs that
// ends with _begin and _end.
HandleDeclaration :: (decl : *Declaration, parent_decl : *Declaration) -> Declaration_Visit_Result
{
    GetAssociatedEnumName :: (name : string) -> string
    {
        if name.count > 1 && name[name.count - 1] != #char "_"
            return tprint("%_", name);

        return name;
    }

    if !parent_decl
    {
        for Global_Declarations_Flags
        {
            if decl.name == it.name
            {
                decl.decl_flags |= it.flags;

                print("% : %\n", decl.name, decl.decl_flags);

                if decl.decl_flags | .OMIT_FROM_OUTPUT
                    return .STOP;
            }
        }
    }

    TypeContainsNamedType :: (type : *CType, name : string) -> bool
    {
        decl : *Declaration;

        while true
        {
            if type.pointer_to
                type = type.pointer_to;
            else if type.array_element_type
                type = type.array_element_type;
            else
                break;
        }

        if type.type_of_enum
            decl = type.type_of_enum;
        else if type.type_of_struct
            decl = type.type_of_struct;
        else if type.type_of_typedef
            decl = type.type_of_typedef;

        for type.template_instantiation_params
        {
            if TypeContainsNamedType(it, name)
                return true;
        }

        if !decl
            return false;

        return name == decl.output_name;
    }

    // Avoid name clashing in a more sophisticated way that the default thing
    if decl.kind == .DECLARATION && decl.type
    {
        if TypeContainsNamedType(decl.type, decl.output_name)
            decl.output_name = sprint("%_", decl.output_name);
    }

    // We want to generate the correct strongly typed enum,
    // so each time we have an argument or a struct member that
    // is a typedef, we search all the members we've compiled
    // so far to find the correct enum type
    if parent_decl
    && (parent_decl.kind == .FUNCTION || parent_decl.kind == .STRUCT)
    && decl.kind == .DECLARATION && decl.type.type_of_typedef
    {
        old_name := decl.type.type_of_typedef.name;
        if !old_name
            return .RECURSE;
        new_name := GetAssociatedEnumName(old_name);

        for context.generator.global_scope.members
        {
            if it.kind != .ENUM || it.name != new_name
                continue;

            enum_decl := cast(*Enum) it;

            // Don't output the integer typedef
            decl.type.type_of_typedef.decl_flags |= .OMIT_FROM_OUTPUT;

            // Make sure the enums like 'Focus_Flags_' get outputted as 'FocusFlags'
            if enum_decl.output_name.count > 2 && enum_decl.output_name[enum_decl.output_name.count - 1] == #char "_"
                enum_decl.output_name.count -= 1;

            // Swap in the enum for the typedef
            decl.type.type_of_typedef = null;
            decl.type.type_of_enum = enum_decl;

            decl.decl_flags |= .NEEDS_DEFAULT_ARGUMENT_CAST;

            break;
        }
    }

    if decl.kind ==
    {
    case .ENUM;
        // ImGui has lots of enums that should be enum flags. Luckily, they all end with "Flags_".
        if ends_with(decl.name, "Flags_")
        {
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
        for type.arguments
        {
            if it_index == 0 || !ends_with(it.name, "_end")
                continue;

            // Ignore non string types
            if !it.type.pointer_to || !(it.type.pointer_to.number_flags & ._8BIT)
                continue;

            basename := slice(it.name, 0, it.name.count - "_end".count);
            if !basename
                continue;

            // The first arg may appear as "text_begin" or just "text"
            name_with_begin := tprint("%_begin", basename);
            prev_arg := type.arguments[it_index - 1];
            if prev_arg.name == basename || prev_arg.name == name_with_begin
            {
                array_add(*g_begin_end_string_args, prev_arg);
                func.decl_flags |= .NEEDS_ARGUMENT_WRAPPER;
            }
        }
    }

    return .RECURSE;
}

GetFuncArgsForPrinting :: (func : *Function, type : *Function_Type, mode : Arg_Print_Mode) -> []*Declaration
{
    args : [..]*Declaration;

    for type.arguments
    {
        if array_find(g_begin_end_string_args, it)
        {
            if mode ==
            {
            case .OUTER_WRAPPER;
                // For the outer wrapper, remove any "_begin" part of the argument, and
                // change its type to a jai string
                new_arg := New(Declaration);
                <<new_arg = <<it;
                new_arg.type = context.generator.type_def_jai_string;

                if ends_with(it.name, "_begin")
                    new_arg.output_name = slice(it.name, 0, it.name.count - "_begin".count);

                array_add(*args, new_arg);

                it_index += 1;	// Skip the next arg since we merged the _begin and _end pairs

                continue;

            case .INNER_WRAPPER_CALL;
                basename := it.name;
                if ends_with(basename, "_begin")
                    basename = slice(basename, 0, basename.count - "_begin".count);

                first_arg := New(Declaration);
                <<first_arg = <<it;
                first_arg.output_name = tprint("%.data", basename);
                array_add(*args, first_arg);

                second_arg := New(Declaration);
                <<second_arg = <<it;
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
