#import "Hash_Map";
#import "Paged_Array";
#import "Type_Utils";
#import "File_Watcher";

Track_Asset_Reference_Locations :: true;
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

DummyAsset :: Asset(struct {});

// @Todo: make sure this function works across module boundaries
GetAssetType :: (info : *Type_Info_Struct) -> *Type_Info {
    if info.type != .STRUCT {
        return null;
    }

    if TypeGetSourcePolymorph(info) != TypeGetSourcePolymorph(type_info(DummyAsset)) {
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

LoadAsset :: inline ($T : Type, name : string, location := #caller_location) -> *Asset(T) {
    cache := #insert #run SPrint("*g_assets.%_cache;", T);
    return LoadAsset(cache, name, location);
} @NoProfile

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
