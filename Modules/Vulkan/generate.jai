// MIT License - Copyright (c) 2022 Hamad Almamari
// Tested with vulkan 1.0 and 1.2
// You can use this file to generate any version of vulkan bindings.
// You only need to set the vulkan.h and vulkan lib paths.
// Modified by Ryan Capote for Vulkan 1.3
// Modified by Stefan Oumansour (misc and styling)

#run {
    set_build_options_dc(.{do_output=false});

    build := false;
    build_debug := true;

    args := get_build_options().compile_time_command_line;
    for args {
        if it == {
        case "build";
            build = true;
        case "release";
            build_debug = false;
        }
    }

    if build && !BuildVulkanMemoryAllocator(build_debug) {
        compiler_set_workspace_status(.FAILED);
        return;
    }

    if !GenerateBindings() {
        compiler_set_workspace_status(.FAILED);
        return;
    }
}

BuildVulkanMemoryAllocator :: (debug : bool) -> bool {
    cwd := get_working_directory();
    set_working_directory(#filepath);
    defer set_working_directory(cwd);

    src_path := "Source/VulkanMemoryAllocator/vk_mem_alloc.cpp";

    extra_args: [..]string;

    #if OS == .WINDOWS {
        make_directory_if_it_does_not_exist("Libs/Windows", recursive=true);

        array_add(*extra_args, "/DVMA_CALL_PRE=__declspec(dllexport)");
        array_add(*extra_args, "/ISource");
        array_add(*extra_args, "/std:c++17");

        if !debug {
            array_add(*extra_args, "-DNDEBUG");
        }

        return build_cpp_static_lib("Libs/Windows/VkMemAlloc", src_path, extra=extra_args, debug=debug);
    } else #if OS == .LINUX {
        make_directory_if_it_does_not_exist("Libs/Linux", recursive=true);

        array_add(*extra_args, "-ISource");
        array_add(*extra_args, "-std=c++17");
        array_add(*extra_args, "-fPIC");

        if !debug {
            array_add(*extra_args, "-DNDEBUG");
        }

        return build_cpp_static_lib("Libs/Linux/libVkMemAlloc", src_path, extra=extra_args, debug=debug);
    } else {
        #assert false "Unsupported platform";
        return false;
    }
}

Declarations_To_Omit :: string.[
    "VK_NULL_HANDLE",
    "VK_TRUE",
    "VK_FALSE",
    "VK_WHOLE_SIZE",
    "VK_ATTACHMENT_UNUSED",
    "VK_QUEUE_FAMILY_IGNORED",
    "VK_REMAINING_ARRAY_LAYERS",
    "VK_REMAINING_MIP_LEVELS",
    "VK_SUBPASS_EXTERNAL",
    "VK_MAX_PHYSICAL_DEVICE_NAME_SIZE",
    "VK_UUID_SIZE",
    "VK_MAX_MEMORY_TYPES",
    "VK_MAX_MEMORY_HEAPS",
    "VK_MAX_EXTENSION_NAME_SIZE",
    "VK_MAX_DESCRIPTION_SIZE",
    // Vulkan 1.3 functions that exist on Linux but are not part of our Windows version:
    "vkGetPhysicalDeviceSurfaceCapabilities2KHR",
    "vkGetPhysicalDeviceSurfaceFormats2KHR",
];

GenerateBindings :: () -> bool {
    cwd := get_working_directory();
    set_working_directory(#filepath);
    defer set_working_directory(cwd);

    output_filename: string;
    opts: Generate_Bindings_Options;
    {
        using opts;

        #if OS == .WINDOWS {
            array_add(*library_search_paths, "Libs/Windows");
            array_add(*libraries, .{filename="vulkan-1", identifier="libvulkan"});
            array_add(*libraries, .{filename="VkMemAlloc", identifier="vkmemalloc"});
            array_add(*extra_clang_arguments, "-DWIN32_LEAN_AND_MEAN");

            output_filename  = "vulkan_windows.jai";
        } else #if OS == .LINUX {
            array_add(*library_search_paths, "Libs/Linux");
            array_add(*libraries, .{filename="libvulkan.so.1", identifier="libvulkan"});
            array_add(*libraries, .{filename="libVkMemAlloc", identifier="vkmemalloc"});

            output_filename  = "vulkan_linux.jai";
        } else {
            #assert false "Unsupported platform";
        }

        array_add(*extra_clang_arguments, "-x", "c");

        array_add(*source_files, "Source/vulkan/vulkan.h");
        array_add(*source_files, "Source/VulkanMemoryAllocator/vk_mem_alloc.h");

        generate_library_declarations = false;
        omit_global_declarations = false;

        visitor     = VulkanDeclarationVisitor;
        generate_compile_time_struct_checks = false;
    }

    return generate_bindings(opts, output_filename);
}

available_flag_bits: Table(string, *Enum);
struct_type_decl: *Enum;

VulkanDeclarationVisitor :: (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result {
    // Omit header definitions (ex: VULKAN_H_)
    if decl.kind == .MACRO_DEFINITION && ends_with(decl.name, "_H_") {
        // print("MACRO_DEFINITION removed: %\n", decl.name);
        decl.decl_flags |= .OMIT_FROM_OUTPUT;
        return .STOP;
    }

    // Omit our Declarations_To_Omit
    if !parent_decl && array_find(Declarations_To_Omit, decl.name) {
        //print("Declarations_To_Omit: %\n", decl.name);
        decl.decl_flags |= .OMIT_FROM_OUTPUT;
        return .STOP;
    }

    if decl.kind == .ENUM {
        en := cast(*Enum)decl;
        if en.name == "VkStructureType" {
            struct_type_decl = en; // Save for later
        }

        // Almost all enums should be unsigned
        if en.type && decl.name != "VkResult" {
            if en.type.size == {
                case 1;
                    en.type = context.generator.type_def_u8;
                case 2;
                    en.type = context.generator.type_def_u16;
                case 4;
                    en.type = context.generator.type_def_u32;
                case 8;
                    en.type = context.generator.type_def_u64;
            }
        }

        if contains(decl.name, "FlagBits") {
            en.flags |= .IS_ENUM_FLAGS;
            en.flags |= .VALUES_IN_HEX;

            // Remember this so we can replace the generic VkFlags aliases with the actual enum_flag's type below. :VkFlags
            table_add(*available_flag_bits, decl.name, en);
        }
    }

    // Replace typedef which has "VkFlags" as value. :VkFlags
    // VkAccessFlags :: VkFlags   ->   VkAccessFlags :: VkAccessFlagBits;
    // We don't change the name of the FlagBits enum directly because both the ...FlagBits and the ...Flags aliases are used in declarations.
    if decl.kind == .TYPEDEF && decl.type.type_of_typedef &&  decl.type.type_of_typedef.name == "VkFlags" {
        //print("TYPEDEF(VkFlags):%\n", << decl.name);
        flags_name := replace(decl.name, "Flags", "FlagBits");
        found, enum_decl := table_find(*available_flag_bits, flags_name);
        if found {
            type := New(CType);
            type.type_of_enum = enum_decl;
            type.size = enum_decl.type.size;
            decl.type = type;
        }
    }

    // Set the default value for sType.
    if parent_decl && parent_decl.kind == .STRUCT && parent_decl.name != "VkBaseInStructure" && parent_decl.name != "VkBaseOutStructure" &&
            decl.kind == .DECLARATION && decl.name == "sType" {

        enum_value_name := GetsTypeDefaultValueFromStructName(parent_decl.name);

        // Vulkan has inconsisant naming for things, so the generator can't find these enum values because it splits or doesn't split
        // numbers correctly in newer cases. This manually changes the name of the enum so the generator can find it.
        if enum_value_name == "PHYSICAL_DEVICE_VULKAN_11_FEATURES" then enum_value_name = "PHYSICAL_DEVICE_VULKAN_1_1_FEATURES";
        if enum_value_name == "PHYSICAL_DEVICE_VULKAN_11_PROPERTIES" then enum_value_name = "PHYSICAL_DEVICE_VULKAN_1_1_PROPERTIES";
        if enum_value_name == "PHYSICAL_DEVICE_VULKAN_12_FEATURES" then enum_value_name = "PHYSICAL_DEVICE_VULKAN_1_2_FEATURES";
        if enum_value_name == "PHYSICAL_DEVICE_VULKAN_12_PROPERTIES" then enum_value_name = "PHYSICAL_DEVICE_VULKAN_1_2_PROPERTIES";
        if enum_value_name == "PHYSICAL_DEVICE_VULKAN_13_FEATURES" then enum_value_name = "PHYSICAL_DEVICE_VULKAN_1_3_FEATURES";
        if enum_value_name == "PHYSICAL_DEVICE_VULKAN_13_PROPERTIES" then enum_value_name = "PHYSICAL_DEVICE_VULKAN_1_3_PROPERTIES";
        if enum_value_name == "PHYSICAL_DEVICE_SHADER_ATOMIC_INT_64_FEATURES" then enum_value_name = "PHYSICAL_DEVICE_SHADER_ATOMIC_INT64_FEATURES";
        if enum_value_name == "PHYSICAL_DEVICE_SHADER_FLOAT_16_INT_8_FEATURES" then enum_value_name = "PHYSICAL_DEVICE_SHADER_FLOAT16_INT8_FEATURES";
        if enum_value_name == "PHYSICAL_DEVICE_TEXTURE_COMPRESSION_ASTCHDR_FEATURES" then enum_value_name = "PHYSICAL_DEVICE_TEXTURE_COMPRESSION_ASTC_HDR_FEATURES";
        if enum_value_name == "PHYSICAL_DEVICE_SHADER_IMAGE_ATOMIC_INT_64_FEATURES_EXT" then enum_value_name = "PHYSICAL_DEVICE_SHADER_IMAGE_ATOMIC_INT64_FEATURES_EXT";
        if enum_value_name == "PHYSICAL_DEVICE_INDEX_TYPE_UINT_8_FEATURES_EXT" then enum_value_name = "PHYSICAL_DEVICE_INDEX_TYPE_UINT8_FEATURES_EXT";
        if enum_value_name == "PHYSICAL_DEVICE_RGB_A_10_X_6_FORMATS_FEATURES_EXT" then enum_value_name = "PHYSICAL_DEVICE_RGBA10X6_FORMATS_FEATURES_EXT";
        if enum_value_name == "PHYSICAL_DEVICE_IMAGE_2_D_VIEW_OF_3_D_FEATURES_EXT" then enum_value_name = "PHYSICAL_DEVICE_IMAGE_2D_VIEW_OF_3D_FEATURES_EXT";
        if enum_value_name == "PHYSICAL_DEVICE_IMAGE_SLICED_VIEW_OF_3_D_FEATURES_EXT" then enum_value_name = "PHYSICAL_DEVICE_IMAGE_SLICED_VIEW_OF_3D_FEATURES_EXT";

        if enum_value_name == "VIDEO_DECODE_H_264_PROFILE_INFO_KHR" then enum_value_name = "VIDEO_DECODE_H264_PROFILE_INFO_KHR";
        if enum_value_name == "VIDEO_DECODE_H_264_CAPABILITIES_KHR" then enum_value_name = "VIDEO_DECODE_H264_CAPABILITIES_KHR";
        if enum_value_name == "VIDEO_DECODE_H_264_SESSION_PARAMETERS_ADD_INFO_KHR" then enum_value_name = "VIDEO_DECODE_H264_SESSION_PARAMETERS_ADD_INFO_KHR";
        if enum_value_name == "VIDEO_DECODE_H_264_SESSION_PARAMETERS_CREATE_INFO_KHR" then enum_value_name = "VIDEO_DECODE_H264_SESSION_PARAMETERS_CREATE_INFO_KHR";
        if enum_value_name == "VIDEO_DECODE_H_264_PICTURE_INFO_KHR" then enum_value_name = "VIDEO_DECODE_H264_PICTURE_INFO_KHR";
        if enum_value_name == "VIDEO_DECODE_H_264_DPB_SLOT_INFO_KHR" then enum_value_name = "VIDEO_DECODE_H264_DPB_SLOT_INFO_KHR";
        if enum_value_name == "VIDEO_DECODE_H_264_PROFILE_INFO_KHR" then enum_value_name = "VIDEO_DECODE_H264_PROFILE_INFO_KHR";
        if enum_value_name == "VIDEO_DECODE_H_265_PROFILE_INFO_KHR" then enum_value_name = "VIDEO_DECODE_H265_PROFILE_INFO_KHR";
        if enum_value_name == "VIDEO_DECODE_H_265_CAPABILITIES_KHR" then enum_value_name = "VIDEO_DECODE_H265_CAPABILITIES_KHR";
        if enum_value_name == "VIDEO_DECODE_H_265_SESSION_PARAMETERS_ADD_INFO_KHR" then enum_value_name = "VIDEO_DECODE_H265_SESSION_PARAMETERS_ADD_INFO_KHR";
        if enum_value_name == "VIDEO_DECODE_H_265_SESSION_PARAMETERS_CREATE_INFO_KHR" then enum_value_name = "VIDEO_DECODE_H265_SESSION_PARAMETERS_CREATE_INFO_KHR";
        if enum_value_name == "VIDEO_DECODE_H_265_PICTURE_INFO_KHR" then enum_value_name = "VIDEO_DECODE_H265_PICTURE_INFO_KHR";
        if enum_value_name == "VIDEO_DECODE_H_265_DPB_SLOT_INFO_KHR" then enum_value_name = "VIDEO_DECODE_H265_DPB_SLOT_INFO_KHR";
        if enum_value_name == "VIDEO_DECODE_H_265_PROFILE_INFO_KHR" then enum_value_name = "VIDEO_DECODE_H265_PROFILE_INFO_KHR";

        enum_value: *Declaration;
        for struct_type_decl.enumerates {
            if it.output_name == enum_value_name {
                enum_value = it;
                break;
            }
        }
        assert(enum_value != null, "Could not find % enum value for \"%\"", struct_type_decl.name, enum_value_name);

        literal := New(Literal);
        literal.literal_kind = .ENUM;
        literal.enum_type = struct_type_decl;
        literal.enum_value = enum_value;
        decl.expression = literal;
    }

    return .RECURSE;
}

GetsTypeDefaultValueFromStructName :: (name: string) -> string {
    assert(name.count >= 3);

    is_upper :: (byte: u8) -> bool {
        if byte >= #char "A" && byte <= #char "Z" return true;
        return false;
    }

    is_num :: (byte: u8) -> bool {
        if byte >= #char "0" && byte <= #char "9" return true;
        return false;
    }

    builder: String_Builder;
    append(*builder, name[2]);
    for i:3..name.count-1 {
        if is_upper(name[i]) {
            is_first_uppercase := !is_upper(name[i-1]);
            is_end_of_uppercase_word := (i != name.count-1 && !is_upper(name[i+1]));
            is_bit_count := is_num(name[i-1]) && slice(name, i, 3) == "Bit";
            if (is_first_uppercase || is_end_of_uppercase_word) && !is_bit_count {
                append(*builder, #char "_");
            } else if (i >= 4 && slice(name, i-4, 4) == "AABB") { // Special case hack for names involing AABB
                append(*builder, #char "_");
            }
            append(*builder, name[i]);
        } else if is_num(name[i]) {
            if !is_num(name[i-1]) {
                append(*builder, #char "_");
            }
            append(*builder, name[i]);
        } else {
            append(*builder, to_upper(name[i]));
        }
    }

    return builder_to_string(*builder);
}

#import "Basic";
#import "Compiler";
#import "Check";
#import "Bindings_Generator";
#import "File";
#import "String";
#import "Hash_Table";
#import "BuildCpp";
