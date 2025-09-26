#import "File_Watcher";

Log_Shaders :: Log_Section.{name="Graphics/Shaders"};

LoadedShader :: struct {
    name : string;
    dependencies : [..]string;
    vertex_shader : GfxShader;
    fragment_shader : GfxShader;
    compute_shader : GfxShader;
    failed_to_reload : bool;
}

g_shader_file_watcher : File_Watcher;
g_shaders := LoadedShader.[
    // .{name="infinite_grid"},
    // .{name="alpha_cutoff_entity_guid"},
    // .{name="alpha_cutoff_depth_only"},
    // .{name="build_cluster_grid"},
    // .{name="populate_cluster_grid"},
    // .{name="kawase_blur_downsample"},
    // .{name="kawase_blur_upsample"},
    // .{name="gizmo"},
    // .{name="debug_line"},
    // .{name="point_shadow_map"},
    // .{name="bloom_filter"},
    // .{name="bloom_downsample"},
    // .{name="bloom_upsample"},
    // .{name="entity_guid"},
    .{name="imgui"},
    // .{name="screen_effect"},
    // .{name="background_screen_effect"},
    // .{name="irradiance_map"},
    // .{name="environment_map"},
    // .{name="skybox"},
    // .{name="brdf_lut"},
    // .{name="compositing"},
    .{name="mesh_geometry"},
    .{name="skinned_mesh_geometry"},
    // .{name="opaque_surface"},
    .{name="unlit"},
];

ShaderReloadCallback :: struct {
    proc : #type (shader : *LoadedShader, data : *void);
    data : *void;
}

operator== :: (a : ShaderReloadCallback, b : ShaderReloadCallback) -> bool {
    return a.proc == b.proc && a.data == b.data;
}

GetVertexShader :: (name : string) -> *GfxShader {
    for * g_shaders {
        if it.name == name {
            if !IsNull(*it.vertex_shader) {
                return *it.vertex_shader;
            }

            Panic("No vertex shader named '%'", name);
            return null;
        }
    }

    Panic("No shader named '%'", name);
    return null;
}

GetFragmentShader :: (name : string) -> *GfxShader {
    for * g_shaders {
        if it.name == name {
            if !IsNull(*it.fragment_shader) {
                return *it.fragment_shader;
            }

            Panic("No fragment shader named '%'", name);
            return null;
        }
    }

    Panic("No shader named '%'", name);
    return null;
}

GetComputeShader :: (name : string) -> *GfxShader {
    for * g_shaders {
        if it.name == name {
            if !IsNull(*it.compute_shader) {
                return *it.compute_shader;
            }

            Panic("No compute shader named '%'", name);
            return null;
        }
    }

    Panic("No shader named '%'", name);
    return null;
}

CleanupSPIRVFiles :: () {
    for file_list("Shaders" ,, Temp) {
        if path_extension(it) == "spv" {
            file_delete(it);
        }
    }
}

LoadAllShaders :: () -> bool {
    LogSectionScope(*Log_Shaders);

    CleanupSPIRVFiles();

    init(*g_shader_file_watcher, ShaderFileChangeCallback, events_to_watch=.MODIFIED);

    if !add_directories(*g_shader_file_watcher, "Shaders") {
        LogError("Could not watch Shaders directory for changes");
    }

    start_time := Basic.current_time_monotonic();

    for * g_shaders {
        if !ReloadShader(it) {
            return false;
        }
    }

    end_time := Basic.current_time_monotonic();

    CleanupSPIRVFiles();

    LogMessage("Loaded all shaders in % s", Basic.to_float64_seconds(end_time - start_time));

    return true;
}

DestroyAllShaders :: () {
    CleanupSPIRVFiles();

    for * g_shaders {
        if !IsNull(*it.vertex_shader) {
            DestroyGfxShader(*it.vertex_shader);
        }

        if !IsNull(*it.fragment_shader) {
            DestroyGfxShader(*it.fragment_shader);
        }

        if !IsNull(*it.compute_shader) {
            DestroyGfxShader(*it.compute_shader);
        }

        for it.dependencies {
            Free(it.data);
        }

        ArrayFree(*it.dependencies);
    }
}

ProcessShaderDirectoryChanges :: () {
    process_changes(*g_shader_file_watcher);
}

ShaderFileChangeCallback :: (watcher : *File_Watcher(void), change : *File_Change, user_data : *void) {
    LogSectionScope(*Log_Shaders);

    filename := get_absolute_path(change.full_path,, Temp);
    path_overwrite_separators(filename, #char "/");

    for * g_shaders {
        if ArrayFindFirst(it.dependencies, filename) != -1 {
            ReloadShader(it);
        }
    }

    CleanupSPIRVFiles();
}

ReloadShader :: (shader : *LoadedShader) -> bool {
    LogSectionScope(*Log_Shaders);

    WaitForGPUIdle();

    dependencies : [..]string;
    defer {
        for dependencies {
            Free(it.data);
        }

        ArrayFree(*dependencies);
    }

    shader.failed_to_reload = false;

    vertex_filename := TPrint("Shaders/%.vert.glsl", shader.name);
    vertex_filename = get_absolute_path(vertex_filename ,, Temp, logger=IgnoreLogger);
    path_overwrite_separators(vertex_filename, #char "/");

    fragment_filename := TPrint("Shaders/%.frag.glsl", shader.name);
    fragment_filename = get_absolute_path(fragment_filename ,, Temp, logger=IgnoreLogger);
    path_overwrite_separators(fragment_filename, #char "/");

    compute_filename := TPrint("Shaders/%.comp.glsl", shader.name);
    compute_filename = get_absolute_path(compute_filename ,, Temp, logger=IgnoreLogger);
    path_overwrite_separators(compute_filename, #char "/");

    has_vertex_shader := file_exists(vertex_filename);
    has_fragment_shader := file_exists(fragment_filename);
    has_compute_shader := file_exists(compute_filename);

    if !has_vertex_shader && !has_fragment_shader && !has_compute_shader {
        LogError("No shader file for shader '%'", shader.name);
        shader.failed_to_reload = true;
        return false;
    }

    vertex_shader : GfxShader;
    defer if !IsNull(*vertex_shader) then DestroyGfxShader(*vertex_shader);

    fragment_shader : GfxShader;
    defer if !IsNull(*fragment_shader) then DestroyGfxShader(*fragment_shader);

    compute_shader : GfxShader;
    defer if !IsNull(*compute_shader) then DestroyGfxShader(*compute_shader);

    extra := string.[
        TPrint("-DNum_Environment_Map_Samples=%", GetCVarUInt("environment_map_num_samples", 128)),
        TPrint("-DIrradiance_Map_Sample_Delta=%", GetCVarFloat("irradiance_map_sample_delta", 0.025)),
    ];

    if has_vertex_shader {
        vertex_shader = LoadGfxShader(TPrint("%.vert", shader.name), extra, dependencies=*dependencies);

        if IsNull(*vertex_shader) {
            shader.failed_to_reload = true;
            return false;
        }
    }

    if has_fragment_shader {
        fragment_shader = LoadGfxShader(TPrint("%.frag", shader.name), extra, dependencies=*dependencies);

        if IsNull(*fragment_shader) {
            shader.failed_to_reload = true;
            return false;
        }
    }

    if has_compute_shader {
        compute_shader = LoadGfxShader(TPrint("%.comp", shader.name), extra, dependencies=*dependencies);

        if IsNull(*compute_shader) {
            shader.failed_to_reload = true;
            return false;
        }
    }

    Swap(*shader.dependencies, *dependencies);
    Swap(*shader.vertex_shader, *vertex_shader);
    Swap(*shader.fragment_shader, *fragment_shader);
    Swap(*shader.compute_shader, *compute_shader);

    LogMessage("Loaded shader '%'", shader.name);

    return true;
}
