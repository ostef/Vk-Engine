#include <Core.hpp>
#include <Parse.hpp>
#include <Database.hpp>
#include <Jai.hpp>

int main(int argc, char **argv) {
    if (argc == 1) {
        printf("Usage: Generator files... -l {output_language} [options...]\n");
        printf("Valid options are:\n");
        printf("  -I {include_dir}: set an include directory\n");
        printf("  -D {definition}: set a compiler define\n");
        printf("  -o {output_file}: set the output file (default is stdout)\n");
        exit(1);
    }

    ParseOptions options = {};

    String output_filename;
    String output_language;
    for (int i = 1; i < argc; i += 1) {
        String arg = argv[i];
        if (arg == "-o") {
            if (i == argc - 1) {
                ErrorExit("Expected argument to -o option");
            }

            i += 1;
            output_filename = argv[i];
        } else if (arg == "-I") {
            if (i == argc - 1) {
                ErrorExit("Expected argument to -I option");
            }

            i += 1;
            options.include_dirs.Push(argv[i]);
        } else if (arg == "-D") {
            if (i == argc - 1) {
                ErrorExit("Expected argument to -D option");
            }

            i += 1;
            options.defines.Push(argv[i]);
        } else if (arg == "-l") {
            if (i == argc - 1) {
                ErrorExit("Expected argument to -l option");
            }

            i += 1;
            output_language = argv[i];
        } else {
            options.files.Push(arg);
        }
    }

    if (output_language == "") {
        ErrorExit("You need to set the output language with to -l option");
    }

    Database db = {};
    ParseFiles(options, db);

    Database::PostProcessOptions post_process_options = {};
    post_process_options.strip_prefixes.Push("JPH");
    post_process_options.strip_prefixes.Push("JOLTC");
    db.PostProcess(post_process_options);

    JaiGenerateOptions generate_options;
    generate_options.strip_prefixes = post_process_options.strip_prefixes;
    generate_options.strip_declarations.Push("__GCC_HAVE_DWARF2_CFI_ASM");
    generate_options.strip_declarations.Push("JOLTC_EXPORT");
    generate_options.strip_declarations.Push("JOLTC_EXTERN");
    generate_options.strip_declarations.Push("JOLTC_API");
    generate_options.strip_declarations.Push("JOLTC_VERSION_FEATURES");

    // Only pick-up the JOLTC #defines
    generate_options.strip_declarations.Push("JPH_DOUBLE_PRECISION");
    generate_options.strip_declarations.Push("JPH_CROSS_PLATFORM_DETERMINISTIC");
    generate_options.strip_declarations.Push("JPH_FLOATING_POINT_EXCEPTIONS_ENABLED");
    generate_options.strip_declarations.Push("JPH_PROFILE_ENABLED");
    generate_options.strip_declarations.Push("JPH_EXTERNAL_PROFILE");
    generate_options.strip_declarations.Push("JPH_DEBUG_RENDERER");
    generate_options.strip_declarations.Push("JPH_DISABLE_TEMP_ALLOCATOR");
    generate_options.strip_declarations.Push("JPH_DISABLE_CUSTOM_ALLOCATOR");
    generate_options.strip_declarations.Push("JPH_OBJECT_LAYER_BITS");
    generate_options.strip_declarations.Push("JPH_ENABLE_ASSERTS");
    generate_options.strip_declarations.Push("JPH_OBJECT_STREAM");

    generate_options.strip_declarations.Push("JPH_UVec4");
    generate_options.strip_declarations.Push("JPH_Vec3");
    generate_options.strip_declarations.Push("JPH_Vec4");
    generate_options.strip_declarations.Push("JPH_Mat44");
    generate_options.strip_declarations.Push("JPH_DVec3");
    generate_options.strip_declarations.Push("JPH_DMat44");
    generate_options.strip_declarations.Push("JPH_Quat");

    generate_options.strip_declarations.Push("JPH_Quat_sIdentity");

    StringBuilder builder;

    if (output_language == "jai") {
        AppendJaiCode(generate_options, db, builder);
    } else {
        ErrorExit("Invalid language %*s", FStr(output_language));
    }

    auto str = builder.Build();
    if (output_filename == "") {
        printf("%.*s", FStr(str));
    } else if (WriteEntireFile(output_filename.ToCStr(), str.data, str.count) <= 0) {
        Error("Could not write file '%.*s'", FStr(output_filename));
    }
}