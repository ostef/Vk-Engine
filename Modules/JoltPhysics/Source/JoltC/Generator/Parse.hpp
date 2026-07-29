#pragma once

#include <Core.hpp>
#include <Database.hpp>

struct ParseOptions {
    Array<String> include_dirs;
    Array<String> defines;
    Array<String> files;
    Array<String> extra_options;
    bool preparse_files_for_correct_include_order;
    bool strip_comments;
};

void ParseFiles(const ParseOptions &options, Database &db);
