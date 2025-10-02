#import "File_Watcher";
#import "Thread";

g_assets : Assets;

GetAssets :: () -> *Assets {
    return *g_assets;
} @ModuleAPI

InitAssets :: () {
    InitAssetCache(
        *g_assets.StaticMesh_cache,
        load_proc=LoadStaticMeshFromMemory,
        post_load_proc=null,
        unload_proc=DestroyStaticMesh,
        write_proc=null
    );
    InitAssetCache(
        *g_assets.SkinnedMesh_cache,
        load_proc=LoadSkinnedMeshFromMemory,
        post_load_proc=null,
        unload_proc=DestroySkinnedMesh,
        write_proc=null
    );
    InitAssetCache(
        *g_assets.ArmatureAnimation_cache,
        load_proc=LoadArmatureAnimationFromMemory,
        post_load_proc=null,
        unload_proc=DestroyArmatureAnimation,
        write_proc=null
    );
    InitAssetCache(
        *g_assets.Material_cache,
        load_proc=LoadMaterialFromMemory,
        post_load_proc=null,
        unload_proc=DestroyMaterial,
        write_proc=WriteMaterial
    );
    InitAssetCache(
        *g_assets.Texture2D_cache,
        load_proc=LoadTexture2DFromMemory,
        post_load_proc=null,
        unload_proc=DestroyTexture2D,
        write_proc=null
    );
    InitAssetCache(
        *g_assets.EnvironmentMap_cache,
        load_proc=LoadEnvironmentMapFromMemory,
        post_load_proc=null,
        unload_proc=DestroyEnvironmentMap,
        write_proc=null
    );
}

g_data_directory_absolute_path : string;
g_data_directory_watcher : File_Watcher;
g_data_directory_change_callbacks : [..]DataDirectoryChangeCallback;

FileWatcherCallback :: (watcher : *File_Watcher(void), change : *File_Change, data : *void) {
    for g_data_directory_change_callbacks {
        it.proc(watcher, change, it.data);
    }
}

RegisterDataDirectoryChangeCallback :: (proc : type_of(DataDirectoryChangeCallback.proc), data : *void) -> int {
    if !g_data_directory_watcher.callback {
        init(*g_data_directory_watcher, FileWatcherCallback, null, .ALL_EVENTS);

        if !add_directories(*g_data_directory_watcher, "Data") {
            LogError("Could not watch directory 'Data' for changes");
        }
    }

    cb := ArrayPush(*g_data_directory_change_callbacks);
    cb.data = data;
    cb.proc = proc;

    return g_data_directory_change_callbacks.count - 1;
} @ModuleAPI

UnregisterDataDirectoryChangeCallback :: (index : int) {
    ArrayOrderedRemove(*g_data_directory_change_callbacks, index);
} @ModuleAPI

ProcessDataDirectoryChanges :: () {
    process_changes(*g_data_directory_watcher);
}

GetDataDirectoryAbsolutePath :: () -> string {
    if !g_data_directory_absolute_path {
        g_data_directory_absolute_path = StringClone(get_absolute_path("Data"));
        path_overwrite_separators(g_data_directory_absolute_path, #char "/");
    }

    return g_data_directory_absolute_path;
} @ModuleAPI

InitAssetCache :: (
    cache : *$T/AssetCache,
    load_proc : cache.LoadProc,
    post_load_proc : cache.PostLoadProc,
    unload_proc : cache.UnloadProc,
    write_proc : cache.WriteProc
) {
    Assert(!cache.initialized, "Asset cache % is already initialized", T);

    defer cache.initialized = true;

    cache.load_proc = load_proc;
    cache.post_load_proc = post_load_proc;
    cache.unload_proc = unload_proc;
    cache.write_proc = write_proc;
    cache.log_section.name = SPrint("Assets/%", T.T);

    LogSectionScope(*cache.log_section);

    init(*cache.parallel_load_group, GetDefaultNumWorkerThreads(), #bake_arguments LoadAssetWorker(T=cache.T));
    cache.parallel_load_group.name = #run SPrint("Parallel Asset Loading (%)", cache.T);
    cache.parallel_load_group.logging = false;

    start(*cache.parallel_load_group);

    AssetCacheFileChangeCallback :: (watcher : *File_Watcher(void), change : *File_Change, data : *void) {
        using cache := cast(*T) data;
        asset_name := change.full_path;
        asset_name.data += "Data/".count;
        asset_name.count -= "Data/".count;

        ok, asset := TryReloadAsset(cache, asset_name);
        RemoveRef(asset);
    }

    RegisterDataDirectoryChangeCallback(AssetCacheFileChangeCallback, cache);
}

DestroyAllAssetCaches :: () {
    #insert -> string {
        builder : StringBuilder;

        for Asset_Types {
            Appendln(*builder, "DestroyAssetCache(*g_assets.%_cache);", it);
        }

        return StringBuilderBuild(*builder);
    }
}

DestroyAssetCache :: (using cache : *AssetCache) {
    Assert(cache.initialized, "Asset cache % is not initialized", T);

    LogSectionScope(*log_section);

    start_time := Basic.current_time_monotonic();

    leaks := 0;
    for * storage {
        if !(it.asset_flags & .Permanent) && it.ref_count > 0  {
            LogWarning("Asset '%' is still referenced when destroying asset cache.", it.asset_name);
            leaks += 1;

            #if Track_Asset_Reference_Locations {
                builder : StringBuilder;
                builder.allocator = Temp;

                for loc : it.asset_reference_locations {
                    Appendln(*builder, "    %:%:%",
                        loc.fully_pathed_filename, loc.line_number, loc.character_number);
                }

                LogMessage("Here are all the places where this asset was referenced:\n%", StringBuilderBuild(*builder,, Temp));
            }
        }

        UnloadAsset(cache, it, unload_referenced=true, unload_permanent=true);
    }

    if leaks != 0 && !Track_Asset_Reference_Locations {
        LogMessage("Set Track_Asset_Reference_Locations to true to get more info about where these assets were used.");
    }

    end_time := Basic.current_time_monotonic();
    LogMessage("Unloaded all % assets in % ms", T, Basic.to_float64_seconds(end_time - start_time) * 1000);

    PagedArrayReset(*storage);
    HashMapFree(*unreferenced_assets);
    HashMapFree(*assets_by_name);
    ArrayFree(*pending_asset_loads);
    shutdown(*parallel_load_group);

    Free(log_section.name.data);

    cache.* = .{};
}

UnloadAllUnreferencedAssets :: () {
    num_unloaded_assets := 0;

    #insert -> string {
        builder : StringBuilder;

        for Asset_Types {
            Appendln(*builder, "if Max_Assets_To_Unload_Per_Frame > 0 && num_unloaded_assets < Max_Assets_To_Unload_Per_Frame {");
            Appendln(*builder, "    num_unloaded_assets += UnloadAllUnreferencedAssets(*g_assets.%_cache, Max_Assets_To_Unload_Per_Frame - num_unloaded_assets);", it);
            Appendln(*builder, "}");
        }

        return StringBuilderBuild(*builder);
    }
}

UnloadAllUnreferencedAssets :: (using cache : *AssetCache, max_assets_to_unload := 0) -> int {
    Assert(cache.initialized, "Asset cache % is not initialized", T);

    LogSectionScope(*log_section);

    defer frame_counter += 1;

    start_time := Basic.current_time_monotonic();

    num_unloaded_assets := 0;

    for unreferenced_assets {
        if max_assets_to_unload > 0 && num_unloaded_assets >= max_assets_to_unload {
            break;
        }

        if it.asset.asset_flags & .Permanent {
            LogError("Permanent asset is in unreferenced_assets map. This is not a fatal error but it still shouldn't happen.");
            remove it;
            continue;
        }

        if frame_counter - it.unreferenced_at_frame >= number_of_frames_before_unloading_unreferenced_assets {
            UnloadAsset(cache, it.asset);
            num_unloaded_assets += 1;
        }
    }

    end_time := Basic.current_time_monotonic();
    if num_unloaded_assets > 1 {
        LogMessage("Unloaded all unreferenced % assets in % ms", T, Basic.to_float64_seconds(end_time - start_time) * 1000);
    }

    return num_unloaded_assets;
}

DeferNextAssetLoadsForAllCaches :: () {
    #insert -> string {
        builder : StringBuilder;

        for Asset_Types {
            Appendln(*builder, "DeferNextAssetLoads(*g_assets.%_cache);", it);
        }

        return StringBuilderBuild(*builder);
    }
} @ModuleAPI

LoadAssetWorkerData :: struct ($T : Type) {
    elapsed_time : Basic.Apollo_Time;
    asset : *Asset(T);
}

LoadAssetWorker :: (group : *Thread_Group, thread : *Thread, work : *void, $T : Type) -> Thread_Continue_Status {
    using _ := cast(*LoadAssetWorkerData(T)) work;
    cache := asset.asset_cache;

    LogSectionScope(*cache.log_section);

    start_time := Basic.current_time_monotonic();

    asset.asset_flags &= ~.DeferredLoad;

    filename := StringJoin("Data/", asset.asset_name,, Temp);

    file_contents, file_ok := read_entire_file(filename);
    defer Free(file_contents.data);

    if !file_ok {
        asset.asset_flags |= .LoadFailed;
        LogContentError("Failed to load asset '%' because of a file error", asset.asset_name);
        return .CONTINUE;
    }

    _ := LoadPreallocatedAssetFromMemory(cache, asset, xx file_contents);

    elapsed_time = Basic.current_time_monotonic() - start_time;

    return .CONTINUE;
}

LoadPendingAssets :: () {
    LoadPendingAssetsSynchronously(*g_assets.Material_cache);

    #insert -> string {
        builder : StringBuilder;

        for Asset_Types {
            if it == Material {
                continue;
            }

            Appendln(*builder, "LoadPendingAssetsInParallel(*g_assets.%_cache);", it);
        }

        return StringBuilderBuild(*builder);
    }
} @ModuleAPI

LoadPendingAssetsSynchronously :: (using cache : *AssetCache) {
    LogSectionScope(*log_section);

    if !defer_next_asset_loads {
        LogError("Called LoadPendingAssetsSynchronously but DeferNextAssetLoads wasn't called before");
        return;
    }

    defer_next_asset_loads = false;

    for asset : pending_asset_loads {
        asset.asset_flags &= ~.DeferredLoad;

        filename := StringJoin("Data/", asset.asset_name,, Temp);

        file_contents, file_ok := read_entire_file(filename);
        defer Free(file_contents.data);

        if !file_ok {
            LogContentError("Failed to load asset '%' because of a file error", asset.asset_name);
            continue;
        }

        start_time := Basic.current_time_monotonic();

        ok := LoadPreallocatedAssetFromMemory(cache, asset, xx file_contents);
        if ok && cache.post_load_proc {
            cache.post_load_proc(asset, asset.asset_name);
        }

        total_time := Basic.current_time_monotonic() - start_time;
        total_time_ms := Basic.to_float64_seconds(total_time) * 1000.0;

        LogContentMessage("Loaded asset '%' in % ms", asset.asset_name, total_time_ms);

    }

    ArrayClear(*pending_asset_loads);
}

// Load all assets that have been requested after the call to DeferNextAssetLoads
// This just fires up all the threads in the thread group and waits for everything to be
// completed
LoadPendingAssetsInParallel :: (using cache : *AssetCache) {
    Assert(cache.initialized, "Asset cache % is not initialized", T);

    LogSectionScope(*log_section);

    if !defer_next_asset_loads {
        LogError("Called LoadPendingAssetsInParallel but DeferNextAssetLoads wasn't called before");
        return;
    }

    defer_next_asset_loads = false;

    work : [..]LoadAssetWorkerData(T);
    work.allocator = Temp;
    ArrayReserve(*work, pending_asset_loads.count);

    for pending_asset_loads {
        w := ArrayPush(*work);
        w.asset = it;
        add_work(*parallel_load_group, w);
    }

    finished := 0;
    while finished < pending_asset_loads.count {
        results := get_completed_work(*parallel_load_group);
        finished += results.count;

        if cache.post_load_proc {
            for results {
                using _ := cast(*LoadAssetWorkerData(T)) it;
                if !(asset.asset_flags & .LoadFailed) {
                    start_time := Basic.current_time_monotonic();

                    cache.post_load_proc(asset, asset.asset_name);

                    elapsed_post_load := Basic.current_time_monotonic() - start_time;
                    total_time := elapsed_time + elapsed_post_load;
                    total_time_ms := Basic.to_float64_seconds(total_time) * 1000.0;

                    load_time_ms := Basic.to_float64_seconds(elapsed_time) * 1000.0;
                    post_load_time_ms := Basic.to_float64_seconds(elapsed_post_load) * 1000.0;

                    LogContentMessage("Loaded asset '%' in % ms (% parallel, % synchronous)",
                        asset.asset_name, total_time_ms, load_time_ms, post_load_time_ms);
                }
            }
        } else {
            for results {
                using _ := cast(*LoadAssetWorkerData(T)) it;
                if !(asset.asset_flags & .LoadFailed) {
                    total_time_ms := Basic.to_float64_seconds(elapsed_time) * 1000.0;
                    LogContentMessage("Loaded asset '%' in % ms", asset.asset_name, total_time_ms);
                }
            }
        }
    }

    ArrayClear(*pending_asset_loads);
}
