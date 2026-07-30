#include <Core.hpp>
#include <Parse.hpp>
#include <Database.hpp>
#include <Jai.hpp>

int main(int argc, char **argv) {
    (void)argc;
    (void)argv;

    ParseOptions options = {};
    options.include_dirs.Push("..");
    options.files.Push("../JoltC.h");

    Database db = {};
    ParseFiles(options, db);

    Database::PostProcessOptions post_process_options = {};
    post_process_options.strip_prefixes.Push("JPH");
    db.PostProcess(post_process_options);

    StringBuilder builder;

    for (int64_t i = 0; i < db.all_typedefs.count; i += 1) {
        auto t = db.all_typedefs[i];
        if (t->parent_struct || t->associated_enum || t->associated_struct) {
            continue;
        }

        AppendJaiTypedef(builder, t, 0);
    }

    for (int64_t i = 0; i < db.all_enums.count; i += 1) {
        auto e = db.all_enums[i];
        if (e->parent_struct) {
            continue;
        }

        AppendJaiEnum(builder, e, 0);
        builder.Append("\n");
    }

    for (int64_t i = 0; i < db.all_structs.count; i += 1) {
        auto s = db.all_structs[i];
        if (s->parent_struct) {
            continue;
        }

        AppendJaiStruct(builder, s, 0);
        builder.Append("\n");
    }

    for (int64_t i = 0; i < db.all_functions.count; i += 1) {
        auto func = db.all_functions[i];
        if (func->parent_struct) {
            continue;
        }

        AppendJaiFunction(builder, func, 0);
    }

    auto str = builder.Build();
    printf("%.*s", FStr(str));
}