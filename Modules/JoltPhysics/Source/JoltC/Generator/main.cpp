#include <Core.hpp>
#include <Parse.hpp>
#include <Database.hpp>
#include <Jai.hpp>

int main(int argc, char **argv) {
    (void)argc;
    (void)argv;

    ParseOptions options = {};
    options.defines.Push("JPH_DEBUG_RENDERER");
    options.include_dirs.Push("..");
    options.files.Push("../JoltC.h");

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

    builder.Append("// Defines\n\n");

    for (int64_t i = 0; i < db.all_defines.count; i += 1) {
        auto def = db.all_defines[i];
        if (def->parent_struct) {
            continue;
        }

        AppendJaiDefine(generate_options, builder, def, 0);
    }

    builder.Append("\n// Typedefs\n\n");

    for (int64_t i = 0; i < db.all_typedefs.count; i += 1) {
        auto t = db.all_typedefs[i];
        if (t->parent_struct || t->associated_enum || t->associated_struct) {
            continue;
        }

        AppendJaiTypedef(generate_options, builder, t, 0);
    }

    builder.Append("\n// Enums\n\n");

    for (int64_t i = 0; i < db.all_enums.count; i += 1) {
        auto e = db.all_enums[i];
        if (e->parent_struct) {
            continue;
        }

        AppendJaiEnum(generate_options, builder, e, 0);
        builder.Append("\n");
    }

    builder.Append("// Structs\n\n");

    for (int64_t i = 0; i < db.all_structs.count; i += 1) {
        auto s = db.all_structs[i];
        if (s->parent_struct) {
            continue;
        }

        AppendJaiStruct(generate_options, builder, s, 0);
        builder.Append("\n");
    }

    builder.Append("// Functions\n\n");

    for (int64_t i = 0; i < db.all_functions.count; i += 1) {
        auto func = db.all_functions[i];
        if (func->parent_struct) {
            continue;
        }

        AppendJaiFunction(generate_options, builder, func, 0);
    }

    auto str = builder.Build();
    // printf("%.*s", FStr(str));

    if (WriteEntireFile("../../../jolt_linux.jai", str.data, str.count) <= 0) {
        Error("Could not write file '../../../jolt_linux.jai'");
    }
}