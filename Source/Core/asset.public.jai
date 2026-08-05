#import "Hash_Map";
#import "Paged_Array";
#import "Type_Utils";
#import "File_Watcher";

Track_Asset_Reference_Locations :: false; // @Todo: this causes a crash when reporting the locations
Default_Number_Of_Frames_Before_Unloading_Unreferenced_Assets :: 60;
Max_Assets_To_Unload_Per_Frame :: 2;

Assets :: struct {
    #insert -> string {
        builder : StringBuilder;

        for Asset_Types {
            Appendln(*builder, "%1_cache : AssetCache(%1);", it);
        }

        return StringBuilderBuild(*builder);
    }
}

AssetCache :: struct(T : Type) {
    AssetType :: Asset(T);
    LoadProc :: #type (*T, data : []u8, name : string) -> bool;
    PostLoadProc :: #type (*T, name : string) -> bool;
    UnloadProc :: #type (*T);
    WriteProc :: #type (*StringBuilder, *T) -> bool;

    UnreferencedAsset :: struct {
        unreferenced_at_frame : int;
        asset : *AssetType;
    }

    initialized : bool;

    log_section : Log_Section;
    name : string;

    load_proc : LoadProc;
    post_load_proc : PostLoadProc;
    unload_proc : UnloadProc;
    write_proc : WriteProc;

    frame_counter : int;
    number_of_frames_before_unloading_unreferenced_assets := Default_Number_Of_Frames_Before_Unloading_Unreferenced_Assets;

    assets_by_name : HashMap(string, *AssetType);
    unreferenced_assets : HashMap(string, UnreferencedAsset);
    storage : PagedArray(AssetType, 20);

    defer_next_asset_loads : bool;
    pending_asset_loads : [..]*AssetType;
    parallel_load_group : Thread_Group;
}

AssetFlags :: enum_flags u8 {
    FromMemory;
    Permanent; // Ref count is ignored and the asset is never freed
    DeferredLoad;
    LoadFailed;
}

AssetCommonData :: struct {
    asset_name : string; @NotEditable @Serialize(1)
    asset_flags : AssetFlags; @NotEditable
    ref_count : s32; @NotEditable
}

Asset :: struct(DataType : Type) {
    #as using _ : AssetCommonData; @Serialize(1)
    asset_cache : *AssetCache(DataType);
    #as using asset_data : DataType;

    #if Track_Asset_Reference_Locations {
        asset_reference_locations : [..]Source_Code_Location;
    }
}

// @Todo: make sure this function works across module boundaries
GetAssetType :: (info : *Type_Info_Struct) -> *Type_Info {
    if info.type != .STRUCT {
        return null;
    }

    if !IsStruct(TypeGetSourcePolymorph(info), "Asset") {
        return null;
    }

    for info.specified_parameters {
        if !(it.flags & .CONSTANT) {
            continue;
        }

        ptr := info.constant_storage.data + it.offset_into_constant_storage;
        if it.name == "DataType" {
            return (cast(**Type_Info) ptr).*;
        }
    }

    return null;
}

MakeVersionNumber :: inline (major : u32, minor : u32, patch : u32) -> u32 {
    Assert(minor < 100);
    Assert(patch < 100);

    return patch + minor * 100 + major * 10000;
}

GetVersionNumbers :: inline (version : u32) -> major : u32, minor : u32, patch : u32 {
    return version / 10000, (version / 100) % 10, version % 10;
}

DataDirectoryChangeCallback :: struct {
    proc : (*File_Watcher(void), *File_Change, *void);
    data : *void;
}

// After this function is called, when requesting an asset load, the asset will be flagged
// as DeferredLoad and will be loaded when LoadPendingAssetsInParallel is called
DeferNextAssetLoads :: (cache : *AssetCache) {
    cache.defer_next_asset_loads = true;
}

AddRef :: (using asset : *Asset, location := #caller_location) -> type_of(asset) {
    if asset_flags & .Permanent {
        return asset;
    }

    if ref_count == 0 {
        HashMapRemove(*asset_cache.unreferenced_assets, asset_name);
    }

    ref_count += 1;

    #if Track_Asset_Reference_Locations {
        tracked_location := false;
        for asset_reference_locations {
            if it.fully_pathed_filename == location.fully_pathed_filename
            && it.line_number == location.line_number
            && it.character_number == location.character_number {
                tracked_location = true;
                break;
            }
        }

        if !tracked_location {
            ArrayPush(*asset_reference_locations, location);
        }
    }

    return asset;
}

RemoveRef :: (using asset : *Asset) {
    if !asset {
        return;
    }

    if asset_flags & .Permanent {
        return;
    }

    Assert(ref_count > 0);

    ref_count -= 1;

    if ref_count == 0 {
        unreferenced := asset_cache.UnreferencedAsset.{
            unreferenced_at_frame=asset_cache.frame_counter,
            asset=asset
        };

        HashMapInsert(*asset_cache.unreferenced_assets, asset_name, unreferenced);
    }
}

DerefAsset :: (asset : **Asset) {
    RemoveRef(asset.*);
    asset.* = null;
}

LoadAsset :: inline ($T : Type, name : string, location := #caller_location) -> *Asset(T) {
    cache := #insert #run SPrint("*GetAssets().%_cache;", T);
    return LoadAsset(cache, name, location);
} @NoProfile

LoadAssetDynamic :: (data_type : Type, name : string, location := #caller_location) -> *void {
    data_type_name := ifx cast(*Type_Info_Struct, data_type).type == .STRUCT then cast(*Type_Info_Struct, data_type).name;
    #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "if data_type_name == {");
        for Asset_Types {
            Appendln(*builder, "case \"%1\"; return LoadAsset(*GetAssets().%1_cache, name, location);", it);
        }
        Appendln(*builder, "}");

        return StringBuilderBuild(*builder);
    }

    LogError("Unhandled type % when attempting to load asset of a type known only at runtime", data_type);

    return null;
}

AddRefDynamic :: (data_type : Type, asset : *void, location := #caller_location) {
    data_type_name := ifx cast(*Type_Info_Struct, data_type).type == .STRUCT then cast(*Type_Info_Struct, data_type).name;
    #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "if data_type_name == {");
        for Asset_Types {
            Appendln(*builder, "case \"%1\"; AddRef(cast(*Asset(%1), asset), location);", it);
        }
        Appendln(*builder, "case; LogError(\"AddRefDynamic does not handle asset type \%\", data_type);");
        Appendln(*builder, "}");

        return StringBuilderBuild(*builder);
    }
}

RemoveRefDynamic :: (data_type : Type, asset : *void) {
    data_type_name := ifx cast(*Type_Info_Struct, data_type).type == .STRUCT then cast(*Type_Info_Struct, data_type).name;
    #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "if data_type_name == {");
        for Asset_Types {
            Appendln(*builder, "case \"%1\"; RemoveRef(cast(*Asset(%1), asset));", it);
        }
        Appendln(*builder, "case; LogError(\"RemoveRefDynamic does not handle asset type \%\", data_type);");
        Appendln(*builder, "}");

        return StringBuilderBuild(*builder);
    }
}

GetLoadedAsset :: (cache : *AssetCache, name : string, location := #caller_location) -> *cache.AssetType {
    Assert(cache.initialized, "Asset cache % is not initialized", cache.AssetType);

    asset := HashMapGet(*cache.assets_by_name, name);
    if asset {
        AddRef(asset, location);
        return asset;
    }

    return null;
}

#scope_module

AllocAsset :: (cache : *AssetCache, name : string, flags : AssetFlags = 0, location := #caller_location) -> *cache.AssetType {
    Assert(cache.initialized, "Asset cache % is not initialized", cache.AssetType);

    asset := PagedArrayFindSlot(*cache.storage);
    asset.asset_name = StringClone(name ,, cache.assets_by_name.allocator);
    asset.asset_cache = cache;
    asset.asset_flags = flags;

    _, was_present := HashMapInsert(*cache.assets_by_name, asset.asset_name, asset);
    Assert(!was_present, "Overriding existing asset '%'", asset.asset_name);

    AddRef(asset, location);

    return asset;
}

FreeAsset :: (cache : *AssetCache, asset : *cache.AssetType, free_referenced := false, free_permanent := false) {
    Assert(cache.initialized, "Asset cache % is not initialized", cache.AssetType);
    Assert(cache == asset.asset_cache);
    Assert(free_referenced || asset.ref_count == 0, "Freeing asset '%' but it is still referenced", asset.asset_name);
    Assert(free_permanent || asset.asset_flags & .Permanent == 0, "Freeing permanent asset '%'", asset.asset_name);

    asset_name := asset.asset_name;
    defer Free(asset.asset_name.data ,, cache.assets_by_name.allocator);

    #if Track_Asset_Reference_Locations {
        ArrayFree(*asset.asset_reference_locations);
    }

    PagedArrayFreeSlot(*cache.storage, asset);
    HashMapRemove(*cache.assets_by_name, asset.asset_name);
    HashMapRemove(*cache.unreferenced_assets, asset.asset_name);
}

UnloadAsset :: (cache : *AssetCache, asset : *cache.AssetType, unload_referenced := false, unload_permanent := false) {
    Assert(cache.initialized, "Asset cache % is not initialized", cache.AssetType);
    Assert(cache.unload_proc != null);
    Assert(cache == asset.asset_cache);

    if !unload_referenced && asset.ref_count > 0 {
        LogError("Unloading asset '%' but it is still referenced", asset.asset_name);
        return;
    }

    if !unload_permanent && asset.asset_flags & .Permanent {
        LogError("Unloading permanent asset '%'", asset.asset_name);
        return;
    }

    start_time := Basic.current_time_monotonic();
    cache.unload_proc(asset);
    end_time := Basic.current_time_monotonic();
    LogContentMessage("Unloaded asset '%' in % ms", asset.asset_name, Basic.to_float64_seconds(end_time - start_time) * 1000);

    FreeAsset(cache, asset, unload_referenced, unload_permanent);
}

#scope_export

AllocNewAssetDynamic :: inline (data_type : Type, name : string, flags : AssetFlags = 0, location := #caller_location) -> *void, is_new : bool  {
    #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "if data_type == {");
        for Asset_Types {
            Appendln(*builder, "case %1; asset, is_new := AllocNewAsset(%1, name, flags, location); return asset, is_new;", it);
        }
        Appendln(*builder, "case; LogError(\"AllocNewAssetDynamic does not handle asset type \%\", data_type);");
        Appendln(*builder, "}");
        Appendln(*builder, "return null, false;");

        return StringBuilderBuild(*builder);
    }
}

AllocNewAsset :: inline ($T : Type, name : string, flags : AssetFlags = 0, location := #caller_location) -> *Asset(T), is_new : bool  {
    cache := #insert #run SPrint("*GetAssets().%_cache;", T);
    asset, is_new := AllocNewAsset(cache, name, flags, location);

    return asset, is_new;
}

AllocNewAsset :: (cache : *AssetCache, name : string, flags : AssetFlags = 0, location := #caller_location) -> *cache.AssetType, is_new : bool {
    Assert(cache.initialized, "Asset cache % is not initialized", cache.AssetType);

    asset := GetLoadedAsset(cache, name, location);
    if asset {
        return asset, false;
    }

    return AllocAsset(cache, name, flags, location), true;
}

#scope_module

LoadPreallocatedAssetFromMemory :: (cache : *AssetCache, asset : *cache.AssetType, data : []u8) -> bool {
    Assert(cache.initialized, "Asset cache % is not initialized", cache.AssetType);

    ok := cache.load_proc(asset, data, asset.asset_name);

    if !ok {
        LogContentError("Could not load asset '%'", asset.asset_name);

        asset.asset_flags |= .LoadFailed;
        cache.unload_proc(asset);

        return false;
    }

    return true;
}

#scope_export

AllocAndLoadAssetFromMemory :: (cache : *AssetCache, name : string, data : []u8, flags : AssetFlags = 0, location := #caller_location) -> *cache.AssetType {
    Assert(cache.initialized, "Asset cache % is not initialized", cache.AssetType);
    Assert(cache.load_proc != null);

    start_time := Basic.current_time_monotonic();

    asset := AllocAsset(cache, name, flags | .FromMemory, location);
    if !LoadPreallocatedAssetFromMemory(cache, asset, data) {
        RemoveRef(asset);
        FreeAsset(cache, asset);

        return null;
    }

    if cache.post_load_proc {
        cache.post_load_proc(asset, name);
    }

    total_time := Basic.current_time_monotonic() - start_time;
    total_time_ms := Basic.to_float64_seconds(total_time) * 1000.0;

    LogContentMessage("Loaded asset '%' in % ms", asset.asset_name, total_time_ms);

    return asset;
}

LoadAsset :: (cache : *AssetCache, name : string, location := #caller_location) -> *cache.AssetType {
    Assert(cache.initialized, "Asset cache % is not initialized", cache.AssetType);
    Assert(cache.load_proc != null);

    LogSectionScope(*cache.log_section);

    if cache.defer_next_asset_loads {
        asset, is_new := AllocNewAsset(cache, name, .DeferredLoad, location);
        if is_new {
            ArrayPushUnique(*cache.pending_asset_loads, asset);
        }

        return asset;
    }

    asset := GetLoadedAsset(cache, name, location);
    if asset {
        return asset;
    }

    filename := StringJoin("Data/", name,, Temp);

    file_contents, file_ok := read_entire_file(filename);
    defer Free(file_contents.data);

    if !file_ok {
        LogContentError("Failed to load asset '%' because of a file error", name);

        return null;
    }

    asset = AllocAndLoadAssetFromMemory(cache, name, xx file_contents, 0, location);
    if !asset {
        return null;
    }

    asset.asset_flags &= ~.FromMemory;

    return asset;
} @NoProfile

LoadAssetPermanent :: inline ($T : Type, name : string, location := #caller_location) -> *Asset(T) {
    cache := #insert #run SPrint("*GetAssets().%_cache;", T);
    return LoadAssetPermanent(cache, name, location);
} @NoProfile

LoadAssetPermanent :: (cache : *AssetCache, name : string, location := #caller_location) -> *cache.AssetType {
    asset := LoadAsset(cache, name, location);
    if !asset {
        return null;
    }

    asset.asset_flags |= .Permanent;

    return asset;
} @NoProfile

TryReloadAsset :: (cache : *AssetCache, name : string, location := #caller_location) -> bool, *cache.AssetType {
    Assert(cache.initialized, "Asset cache % is not initialized", cache.AssetType);

    LogSectionScope(*cache.log_section);

    asset := GetLoadedAsset(cache, name, location);
    if !asset {
        return false, null;
    }

    if asset.asset_flags & .FromMemory {
        LogContentError("Cannot reload asset '%' because it was not loaded from a file", name);

        return false, asset;
    }

    filename := StringJoin("Data/", name,, Temp);
    file_contents, file_ok := read_entire_file(filename);
    defer Free(file_contents.data);

    if !file_ok {
        LogContentError("Failed to reload asset '%' because of a file error", name);

        return false, asset;
    }

    old_data := asset.asset_data;

    asset.asset_data = .{};
    ok := cache.load_proc(*asset.asset_data, xx file_contents, name);

    if !ok {
        cache.unload_proc(*asset.asset_data);
        asset.asset_data = old_data;

        LogContentError("Failed to reload asset '%'", name);

        return false, asset;
    }

    if cache.post_load_proc {
        cache.post_load_proc(*asset.asset_data, name);
    }

    new_data := asset.asset_data;
    asset.asset_data = old_data;

    cache.unload_proc(*asset.asset_data);

    asset.asset_data = new_data;

    LogContentMessage("Reloaded asset '%'", name);

    return true, asset;
}

SaveAsset :: (asset : *Asset) -> bool {
    if !asset {
        return false;
    }

    cache := asset.asset_cache;

    LogSectionScope(*cache.log_section);

    if !cache.write_proc {
        LogError("No write proc in asset cache");
        return false;
    }

    filename := StringJoin("Data/", asset.asset_name,, Temp);

    builder : StringBuilder;
    ok := cache.write_proc(*builder, asset);
    if !ok {
        StringBuilderFree(*builder);
        return false;
    }

    return write_entire_file(filename, *builder);
}

SaveAssetDynamic :: (data_type : Type, asset : *void) -> bool {
    #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "if data_type == {");
        for Asset_Types {
            Appendln(*builder, "case %1; return SaveAsset(cast(*Asset(%1), asset));", it);
        }
        Appendln(*builder, "case; LogError(\"SaveAssetDynamic does not handle asset type \%\", data_type);");
        Appendln(*builder, "}");

        return StringBuilderBuild(*builder);
    }

    return false;
}

UnreferenceAllAssets :: (value : *$T)
#modify { return cast(*Type_Info, T).type == .STRUCT; } {
    #insert -> string {
        builder : StringBuilder;

        Appendln(*builder, "// UnreferenceAllAssets(%)", T);

        info := type_info(T);
        for info.members {
            if it.type.type == .STRUCT {
                Appendln(*builder, "UnreferenceAllAssets(*value.%);", it.name);
                continue;
            }

            if it.type.type != .POINTER {
                continue;
            }

            pointed_type := cast(*Type_Info_Pointer, it.type).pointer_to;
            if pointed_type.type != .STRUCT {
                continue;
            }

            if IsStruct(pointed_type, "Asset") {
                Appendln(*builder, "DerefAsset(*value.%);", it.name);
            } else {
                Appendln(*builder, "if value.% {", it.name);
                Appendln(*builder, "    UnreferenceAllAssets(value.%);", it.name);
                Appendln(*builder, "}");
            }
        }

        return StringBuilderBuild(*builder);
    }
}
