// This "script" currently only compiles the library but does not generate bindings since we have very nice hand-crafted bindings that I don't want to replace atm.
//  -rluba, 2024-04-19

AT_COMPILE_TIME :: true;

NUM_PARALLEL_CMAKE_JOBS :: 8;

// We don’t ship the source with the compiler. Download a release and update this path if you want to re-compile the library.
SOURCE_PATH :: "src/SDL2-2.30.2";

#if AT_COMPILE_TIME {
    #run,stallable {
        set_build_options_dc(.{do_output=false});
        root_options := get_build_options();
        args := root_options.compile_time_command_line;
        if !build_sdl(args) {
            compiler_set_workspace_status(.FAILED);
        }
    }
} else {
    #import "System";

    main :: () {
        set_working_directory(path_strip_filename(get_path_of_running_executable()));
        args := get_command_line_arguments();
        if !build_sdl(args) {
            exit(1);
        }
    }
}

#if OS == .WINDOWS {
    PLATFORM_NAME :: "windows";
} else #if OS == .LINUX {
    PLATFORM_NAME :: "linux";
} else #if OS == .MACOS {
    PLATFORM_NAME :: "macos";
} else {
    compiler_report(tprint("Unsupported platform: %", OS));
}

build_sdl :: (args: [] string) -> bool {
    #if OS == .MACOS {
        UNIVERSAL_DIR :: "macos";
        options := get_build_options();
        success := make_directory_if_it_does_not_exist(UNIVERSAL_DIR);
        // "-DSDL_STATIC=OFF" so we don’t build the static library because if any program links against the static library
        // it also needs to link against libclang_rt.osx.a to get the "__isPlatformVersionAtLeast" symbol (which is needed for @available/#available/__builtin_available checks in SDL).
        // Xcode automatically links against libclang_rt.osx.a if a project includes any availability checks. But I don’t know any way to automatically determine the path to this library!
        // (On my system it currently lives in "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/15.0.0/lib/darwin/libclang_rt.osx.a", so it depends on clang version used by your Xcode version.)
        //  -rluba, 2024-04-19
        success &&= build_sdl_variant(args, "_x64",   .["-DSDL_STATIC=OFF", "-DCMAKE_OSX_ARCHITECTURES=x86_64", "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13"]);
        success &&= build_sdl_variant(args, "_arm64", .["-DSDL_STATIC=OFF", "-DCMAKE_OSX_ARCHITECTURES=arm64",  "-DCMAKE_OSX_DEPLOYMENT_TARGET=11.0"]);
        if success {
            // Create a universal binary out of the two arch builds:
            universal_lib_path := tprint("%/libSDL2.dylib", UNIVERSAL_DIR);
            run_or_exit("lipo", "-create", "macos_x64/lib/libSDL2.dylib", "macos_arm64/lib/libSDL2.dylib", "-output", universal_lib_path);
            // Fix the dynamic library’s ID since we copied the symlinked short name variant. Otherwise the library still thinks it’s called "libSDL2-2.0.0.dylib" and anything you link against it will look for the versioned library name.
            run_or_exit("install_name_tool", "-id", "@rpath/libSDL2.dylib", universal_lib_path);
        }
    } else #if OS == .WINDOWS {
        success := build_sdl_variant(args, "", .["-DSDL_STATIC=OFF"]); // No static library since that will conflict with the .lib file for the dynamic library.
        success &&= copy_file("windows/bin/SDL2.dll", "windows/SDL2.dll");
        success &&= copy_file("windows/lib/SDL2.lib", "windows/SDL2.lib");
    } else #if OS == .LINUX {
        success := build_sdl_variant(args, "", .[]);
        success &&= copy_file("linux/lib/libSDL2.so", "linux/libSDL2.so");
        success &&= copy_file("linux/lib/libSDL2.a",  "linux/libSDL2.a");
    }
    return success;
}


build_sdl_variant :: (args: [] string, suffix: string, extra_config_args: [] string) -> bool {
    build_type := ifx array_find(args, "-debug") then "Debug" else "Release";

	install_dir := join(PLATFORM_NAME, suffix,, temp);
    success := make_directory_if_it_does_not_exist(install_dir);
    if !success {
        log_error("Could not create directory \"%\"\n", install_dir);
		return false;
    }

	absolute_install_dir := get_absolute_path(install_dir);
	assert(absolute_install_dir != "");

    absolute_build_dir := join(absolute_install_dir, "_build");
    log("Configuring SDL... \"%\" -> \"%\"", absolute_build_dir, absolute_install_dir);
	if file_exists(absolute_build_dir) {
		success := delete_directory(absolute_build_dir);
		if !success {
			log_error("Could not delete old build directory");
			return false;
		}
	}
    success = make_directory_if_it_does_not_exist(absolute_build_dir);
    if !success {
        log_error("Could not create directory \"%\"\n", absolute_build_dir);
		return false;
    }

	absolute_source_path := get_absolute_path(SOURCE_PATH);
    config_command: [..] string;
    array_add(*config_command,
		"cmake",
		absolute_source_path,
        tprint("-DCMAKE_INSTALL_PREFIX=%", absolute_install_dir),
        tprint("-DCMAKE_PREFIX_PATH=%",    install_dir),
	);
    array_add(*config_command, ..extra_config_args);

    array_add(*config_command, tprint("-DCMAKE_BUILD_TYPE=%", build_type));
    if OS == .WINDOWS {
        array_add(*config_command, tprint("-DCMAKE_CONFIGURATION_TYPES=%", build_type));
    }

    run_or_exit(..config_command, working_directory = absolute_build_dir);
    log("Done configuring SDL");

    log("Building SDL…");
    build_command: [..] string;
    array_add(*build_command, "cmake", "--build", absolute_build_dir, "--target", "install");
    if !array_find(args, "-no_parallel") {
        array_add(*build_command, "--parallel", tprint("%", NUM_PARALLEL_CMAKE_JOBS));
    }
    if OS == .WINDOWS {
        array_add(*build_command, tprint("--config=%", build_type));
    }

    run_or_exit(..build_command);
	log("Done building SDL");

	return true;
}

run_or_exit :: (command: .. string, working_directory := "") -> string {
    // Enable this to see the commands being executed.
    // Might be useful if, for example, you need to compile LLVM on a platform where we don’t have a Jai compiler yet and want to do it manually.
    // log("Executing command \"%\" in directory \"%\"\n", join(..command, separator = " "), working_directory);

    result, output_string, error_string := run_command(..command, working_directory = working_directory, capture_and_return_output = true, print_captured_output = true);
    defer {
        free(error_string);
    }
    if result.exit_code != 0 {
        log_error("Could not run command \"%\" in directory \"%\". Exit code: %\nError:\n%", get_quoted_command_string(command), working_directory, result.exit_code, error_string);
        // if !LIVE_OUTPUT {
        //     log_error("Output:\n%", output_string);
        // }
        exit(1);
    }
    return output_string;
}



#import "Basic";
#import "BuildCpp";
#import "Compiler";
#import "File";
#import "File_Utilities";
#import "String";
#import "Process";

