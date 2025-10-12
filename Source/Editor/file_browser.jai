// @Todo: replace get_absolute_directory with one that is actually consistent wrt allocation
// @Todo: make sure RefreshDirectoryTree actually refreshes added/removed directories

// After trying to make Win32 file browser work for opening directories, realizing
// that I have to use some obscure and overly-complicated COM interface stuff for
// this, I have come to the conclusion that having custom ImGui based file browsers
// is better for my sanity.

File_Browser_Tile_Size :: Vec2f.{100, 130};

FileBrowserEntry :: struct {
    filename : string;
    is_directory : bool;
    size : s64;
    date_modified : Basic.Apollo_Time;
}

DirectoryTreeNode :: struct {
    filename : string;
    parent_index := -1;
    children_indices : [..]s64;
    children_loaded : bool;
    opened : bool;
    request_focus : bool;
}

FileBrowser :: struct {
    callback : FileBrowserCallback;
    user_data : *void;
    request_open : bool;

    title : *u8;
    using params : FileBrowserParams;

    directory_tree_view := true;
    directory_tree_nodes : [..]DirectoryTreeNode;
    directory_tree_roots : [..]s64;

    tile_view := true;
    tile_view_scale := 1.0;

    selected_filter := -1;
    current_directory : string;
    entries : [..]FileBrowserEntry;
    entries_modified : bool;
    last_refreshed : Basic.Apollo_Time;

    directory_text_buffer : [1000]u8 = ---;
    filename_text_buffer : [200]u8 = ---;
}

FileBrowserParams :: struct {
    accept_button_text : *u8 = "OK";
    initial_directory := ".";
    root_directories : []string;
    show_system_roots : bool; // Show logical drives on Windows and / on Unix in addition to root_directories
    filters : []FileBrowserFilter;
    flags : FileBrowserFlags;
    refresh_rate_in_seconds := 5; // 0 means refresh every update, < 0 means don't refresh automatically
}

FileBrowserFilter :: struct {
    description : string;
    extensions : string;
}

FileBrowserFlags :: enum_flags {
    DisallowNonExisting;
    SelectDirectory;
    DisallowSelectingCurrentDirectory;
}

g_big_file_icon_font : *ImGui.ImFont;
g_declared_file_browsers : [..]FileBrowser;

InitBigFileIconsFont :: () {
    if g_big_file_icon_font {
        return;
    }

    Font_Size :: 45.0;

    // Init :: (builder : *ImGui.ImFontGlyphRangesBuilder)
    // {
    //     size_in_bytes : s32 = (ImGui.IM_UNICODE_CODEPOINT_MAX + 1) / 8;
    //     builder.UsedChars.Reserve(*builder.UsedChars, size_in_bytes / size_of(u32));
    //     builder.UsedChars.Size = builder.UsedChars.Capacity;
    //     memset(builder.UsedChars.Data, 0, size_in_bytes);
    // }

    // ranges : ImGui.ImVector(ImGui.ImWchar);
    // builder : ImGui.ImFontGlyphRangesBuilder;
    // Init(*builder);

    // file_type := type_info(FileType);
    // for file_type.values
    // {
    //     icon_text := GetFileIconByType(cast(FileType) it);
    //     builder.AddText(*builder, icon_text);
    // }

    // builder.BuildRanges(*builder, *ranges);

    MDI_Ranges :: ImGui.ImWchar.[Icon_Min_MDI, Icon_Max_MDI, 0];

    io := ImGui.GetIO();

    scale_factor := GetWindowScaleFactor(GetWindow());
    g_big_file_icon_font = io.Fonts.AddFontFromFileTTF(io.Fonts, Font_Icon_Filename_MDI, Font_Size * scale_factor, null, MDI_Ranges.data);

    g_big_file_icon_font.Scale = 1 / scale_factor;
}

FileBrowserEvent :: struct {
    Kind :: enum {
        SetDirectory;
        SelectFile;
        Refresh;
        Submit;
        Cancel;
    }

    kind : Kind;
    filename : string;
    exists : bool;
}

FileBrowserCallback :: #type (browser : *FileBrowser, event : FileBrowserEvent, user_data : *void);

OpenFileBrowser :: (name : *u8, params : FileBrowserParams, callback : FileBrowserCallback, user_data := null, apply_params_once := true) {
    browser := GetFileBrowser(name);

    if !browser {
        browser = ArrayPush(*g_declared_file_browsers);
        browser.title = name;
        browser.directory_text_buffer[0] = 0;
        browser.filename_text_buffer[0] = 0;
        browser.params = params;
        browser.initial_directory = StringClone(get_absolute_path(browser.initial_directory));
        path_overwrite_separators(browser.initial_directory, #char "/");

        browser.root_directories = AllocArray(string, params.root_directories.count);
        for params.root_directories {
            browser.root_directories[it_index] = StringClone(get_absolute_path(it));
            path_overwrite_separators(browser.root_directories[it_index], #char "/");
        }
    } else if !apply_params_once {
        browser.params = params;
    }

    browser.request_open = true;
    browser.callback = callback;
    browser.user_data = user_data;

    SDL_CaptureMouse(SDL_FALSE);
}

GetFileBrowser :: inline (name : *u8) -> *FileBrowser {
    for * g_declared_file_browsers {
        if it.title == name {
            return it;
        }
    }

    return null;
}

RefreshFileBrowser :: (using browser : *FileBrowser) {
    VisitCallback :: (info : *File_Visit_Info, using browser : *FileBrowser) {
        entry := ArrayPush(*entries);
        entry.filename = StringClone(get_absolute_path(info.full_name));
        path_overwrite_separators(entry.filename, #char "/");

        entry.is_directory = info.is_directory;
        entry.date_modified = info.modification_time;

        _, size, ok := file_modtime_and_size(entry.filename);
        if !ok {
            entry.size = -1;
        } else {
            entry.size = size;
        }
    }

    ArrayClear(*entries);

    visit_files(current_directory, false, browser, VisitCallback, visit_directories=true);
    entries_modified = true;
    last_refreshed = Basic.current_time_monotonic();

    if callback {
        callback(browser, .{kind=.Refresh}, user_data);
    }

    RefreshDirectoryTree(browser);
}

FindDirectoryTreeNode :: (using browser : *FileBrowser, filename : string) -> *DirectoryTreeNode, index : s64 {
    for * directory_tree_nodes {
        if StripTrailingSlash(it.filename) == StripTrailingSlash(filename) {
            return it, it_index;
        }
    }

    return null, -1;
}

RefreshDirectoryTree :: (using browser : *FileBrowser) {
    // Setup root directories as passed in the params or
    if !directory_tree_roots.count {
        for root_directories {
            index := directory_tree_nodes.count;
            node := ArrayPush(*directory_tree_nodes);
            node.filename = StringClone(it);

            ArrayPush(*directory_tree_roots, index);
        }

        if show_system_roots || root_directories.count <= 0 {
            #if OS == .WINDOWS {
                Win32 :: #import "Win32"(File_System=true);
                drives := Win32.GetLogicalDrives();
                for i : 0..size_of(u32) - 1 {
                    exists := drives & (1 << i);
                    letter : u8 = xx (#char "A" + i);

                    if exists {
                        index := directory_tree_nodes.count;
                        drive := ArrayPush(*directory_tree_nodes);
                        drive.filename = SPrint("%:/", string.{1, *letter});

                        ArrayPush(*directory_tree_roots, index);
                    }
                }
            } else {
                index := directory_tree_nodes.count;
                root := ArrayPush(*directory_tree_nodes);
                root.filename = StringClone("/");

                ArrayPush(*directory_tree_roots, index);
            }
        }
    }

    current_filename := StripTrailingSlash(current_directory);
    if !current_filename {
        return;
    }

    slash_index := find_index_from_left(current_filename, #char "/");
    while true {
        if slash_index == 0 {
            break;
        }

        node_filename := current_filename;
        if slash_index > 0 {
            node_filename.count = slash_index;
        }

        parent_node, parent_index := FindDirectoryTreeNode(browser, PathGetParentDir(node_filename));
        if parent_node {
            LoadDirectoryTreeChildren(browser, parent_index);
            parent_node = *directory_tree_nodes[parent_index];
            parent_node.opened = true;

            node, node_index := FindDirectoryTreeNode(browser, node_filename);
            if !node {
                node_index = directory_tree_nodes.count;
                node = ArrayPush(*directory_tree_nodes);
                node.filename = StringClone(node_filename);
                node.parent_index = parent_index;
            }

            node.opened = true;
            LoadDirectoryTreeChildren(browser, node_index);
        }

        if slash_index < 0 {
            break;
        }

        slash_index = find_index_from_left(current_filename, #char "/", slash_index + 1);
    }
}

StripTrailingSlash :: (str : string) -> string {
    if str.count <= 0 {
        return str;
    }

    s := str;
    if s[s.count - 1] == #char "/" || s[s.count - 1] == #char "\\" {
        s.count -= 1;
    }

    return s;
}

PathGetParentDir :: (path : string) -> string {
    if path.count == 0 {
        return "";
    }

    str := path;
    if str[str.count - 1] == #char "/" || str[str.count - 1] == #char "\\" {
        str.count -= 1;
    }

    return path_strip_filename(str);
}

SetDirectory :: (using browser : *FileBrowser, directory : string) -> bool {
    defer {
        len := Min(directory_text_buffer.count - 1, current_directory.count);
        memcpy(directory_text_buffer.data, current_directory.data, len);
        directory_text_buffer[len] = 0;
    }

    if !file_exists(directory) {
        return false;
    }

    prev := current_directory.data;
    defer Free(prev);

    current_directory = StringClone(get_absolute_path(directory));
    path_overwrite_separators(browser.current_directory, #char "/");

    // Clear selected file
    filename_text_buffer[0] = 0;

    if callback {
        callback(browser, .{kind=.SetDirectory, filename=current_directory}, user_data);
    }

    RefreshFileBrowser(browser);

    tree_node := FindDirectoryTreeNode(browser, current_directory);
    if tree_node {
        tree_node.request_focus = true;
    }

    return true;
}

GetSelectedFile :: (using browser : *FileBrowser) -> string {
    filename_input := MakeString(filename_text_buffer.data);
    if filename_input.count == 0 {
        if flags & .SelectDirectory && !(flags & .DisallowSelectingCurrentDirectory) {
            return current_directory;
        }

        return "";
    }

    result := StringJoin(current_directory, "/", filename_input ,, Temp);
    absolute := get_absolute_path(result ,, Temp, logger=IgnoreLogger);
    if !absolute {
        absolute = result;
    }

    path_overwrite_separators(absolute, #char "/");

    return absolute;
}

SetSelectedFile :: (using browser : *FileBrowser, filename : string) {
    basename := path_filename(filename);
    len := Min(basename.count, filename_text_buffer.count - 1);
    memcpy(filename_text_buffer.data, basename.data, len);
    filename_text_buffer[len] = 0;

    if callback {
        callback(browser, .{kind=.SelectFile, filename=basename}, user_data);
    }
}

#scope_file

Column_Name :: 0;
Column_Type :: 1;
Column_Date_Modified :: 2;
Column_Size :: 3;

SortEntriesDefault :: (using browser : *FileBrowser) {
    SortEntries(browser, .{Specs=null, SpecsCount=0});
}

SortEntries :: (using browser : *FileBrowser, specs : ImGui.TableSortSpecs) {
    Compare :: (a : FileBrowserEntry, b : FileBrowserEntry, specs : ImGui.TableSortSpecs) -> int {
        for i : 0..specs.SpecsCount - 1 {
            column_spec := specs.Specs[i];
            delta := 0;
            if column_spec.ColumnUserID == {
            case Column_Name;
                delta = StringCompare(a.filename, b.filename);

            case Column_Type;
                if a.is_directory == b.is_directory {
                    delta = 0;
                } else if a.is_directory {
                    delta = 1;
                } else if b.is_directory {
                    delta = -1;
                } else {
                    a_ext := path_extension(a.filename);
                    b_ext := path_extension(b.filename);
                    a_type := GetFileType(a_ext, a.is_directory);
                    b_type := GetFileType(b_ext, a.is_directory);
                    if a_type != b_type {
                        delta = cast(int) a_type - cast(int) b_type;
                    } else {
                        delta = StringCompare(a_ext, b_ext);
                    }
                }

            case Column_Date_Modified;
                delta = ifx a.date_modified > b.date_modified then 1
                    else ifx a.date_modified < b.date_modified then -1
                    else 0;

            case Column_Size;
                delta = a.size - b.size;

            case;
                Panic("Unknown column entry %", column_spec.ColumnUserID);
            }

            // @Todo @Fix:
            // For some reason the bindings generator does not generate the same name for SortDirection...
            #if OS == .WINDOWS {
                if delta > 0 {
                    return ifx column_spec.SortDirection_ == xx ImGui.SortDirection.Ascending
                        then 1 else -1;
                }
                if delta < 0 {
                    return ifx column_spec.SortDirection_ == xx ImGui.SortDirection.Ascending
                        then -1 else 1;
                }
            } else {
                if delta > 0 {
                    return ifx column_spec.SortDirection == xx ImGui.SortDirection.Ascending
                        then 1 else -1;
                }
                if delta < 0 {
                    return ifx column_spec.SortDirection == xx ImGui.SortDirection.Ascending
                        then -1 else 1;
                }
            }
        }

        // Default
        if a.is_directory && !b.is_directory {
            return -1;
        }
        if !a.is_directory && b.is_directory {
            return 1;
        }
        return StringCompare(a.filename, b.filename);
    }

    QuickSort(entries, specs, Compare);
}

#scope_export

UpdateAllFileBrowsers :: () {
    for * g_declared_file_browsers {
        if it.request_open {
            ImGui.OpenPopup(it.title);
            RefreshFileBrowser(it);
        }

        FileBrowserPopup(it);
        it.request_open = false;
    }
}

FileBrowserPopup :: (using browser : *FileBrowser) {
    if !current_directory {
        SetDirectory(browser, params.initial_directory);
    }

    window_w, window_h := GetWindowPointSize(GetWindow());

    popup_size := Vec2f.{
        Min(700.0, window_w * 0.8),
        Min(500.0, window_h * 0.8)
    };
    display_size := ImGui.GetIO().DisplaySize;
    ImGui.SetNextWindowPos((display_size - popup_size) * 0.5, .Appearing);
    ImGui.SetNextWindowSize(popup_size, .Appearing);
    ImGui.PushStyleVar(.WindowTitleAlign, .{0.5, 0.5});
    defer ImGui.PopStyleVar();

    if !ImGui.BeginPopupModal(title) {
        return;
    }

    defer ImGui.EndPopup();

    LayoutHorizontal();

    list_view := !tile_view;
    Toggle(Icon_View_List_MDI, *list_view);
    tile_view = !list_view;

    if tile_view {
        ImGui.SetItemTooltip("List View");
    } else {
        ImGui.SetItemTooltip("Tile View");
    }

    refreshed_since := Basic.current_time_monotonic() - last_refreshed;
    if ImGui.Button(Icon_Refresh_MDI)
    || refresh_rate_in_seconds >= 0 && Basic.to_seconds(refreshed_since) >= refresh_rate_in_seconds {
        RefreshFileBrowser(browser);
    }

    ImGui.BeginDisabled(PathGetParentDir(current_directory) == "");
    if ImGui.Button(Icon_Arrow_Up_MDI) {
        parent := PathGetParentDir(current_directory);
        if parent {
            SetDirectory(browser, parent);
        }
    }
    ImGui.EndDisabled();

    if ImGui.InputText("##directory_input", directory_text_buffer.data, directory_text_buffer.count) {
        SetDirectory(browser, MakeString(directory_text_buffer.data));
    }

    ImGui.Text("% entries", entries.count);

    LayoutVertical();

    if selected_filter >= filters.count {
        selected_filter = -1;
    }

    avail := ImGui.GetContentRegionAvail();
    file_list_size := Vec2f.{-1, avail.y - 2 * ImGui.GetFrameHeightWithSpacing()};
    should_submit := false;
    new_directory : string;

    if ImGui.BeginChild("main_view", file_list_size) {
        if directory_tree_view {
            ImGui.Columns(2);

            if request_open {
                ImGui.SetColumnWidth(0, 200);
            }

            new_directory = ShowDirectoryTreeView(browser, file_list_size);

            ImGui.NextColumn();
        }

        if !tile_view {
            list_new_directory:, should_submit
                = ShowFileListTable(browser, file_list_size);

            if !new_directory {
                new_directory = list_new_directory;
            }
        } else {
            list_new_directory:, should_submit
                = ShowFileListTiles(browser, file_list_size);

            if !new_directory {
                new_directory = list_new_directory;
            }
        }
    }
    ImGui.EndChild();

    ImGui.Columns(2, border=false);
    Second_Column_Width :: 250;
    width := ImGui.GetWindowContentRegionMax().x - ImGui.GetWindowContentRegionMin().x;
    ImGui.SetColumnWidth(0, width - Second_Column_Width);
    ImGui.SetColumnWidth(1, Second_Column_Width);

    ImGui.SetNextItemWidth(width - Second_Column_Width - 50);
    ImGui.InputText("##filename_input", filename_text_buffer.data, filename_text_buffer.count);

    selected_file := GetSelectedFile(browser);
    if selected_file {
        ImGui.Text("Full filename: %", selected_file);
    }

    ImGui.NextColumn();

    ImGui.BeginDisabled(flags & .SelectDirectory != 0);

    preview : *u8 = ifx selected_filter == -1
        then "All files (.*)".data
        else CTPrint("% (%)", filters[selected_filter].description, filters[selected_filter].extensions);

    ImGui.SetNextItemWidth(-1);
    if ImGui.BeginCombo("##filetype_combo", preview) {
        for i : -1..filters.count - 1 {
            if i == -1 {
                if ImGui.MenuItem("All files (.*)", selected=selected_filter == i) {
                    selected_filter = i;
                }
            } else {
                filter := filters[i];
                if ImGui.MenuItem(CTPrint("% (%)", filter.description, filter.extensions), selected=selected_filter == i) {
                    selected_filter = i;
                }
            }
        }

        ImGui.EndCombo();
    }
    ImGui.EndDisabled();

    exists := file_exists(selected_file);
    can_submit := selected_file.count > 0;
    if flags & .DisallowNonExisting && !exists {
        can_submit = false;
    } else if flags & .SelectDirectory {
        can_submit &&= !exists || is_directory(selected_file);
    } else {
        can_submit &&= !exists || !is_directory(selected_file);
    }

    ImGui.BeginDisabled(!can_submit);

    accept_text := ifx selected_file == current_directory
        then CTPrint("% (current)", MakeString(accept_button_text))
        else ifx !exists && MakeString(browser.filename_text_buffer.data).count > 0
        then CTPrint("% (new)", MakeString(accept_button_text))
        else accept_button_text;

    PushButtonColor(.SubmitGoodButton);
    if ImGui.Button(accept_text) || (can_submit && should_submit) {
        submitted_filename := StringClone(selected_file ,, Temp);
        if callback {
            callback(browser, .{kind=.Submit, filename=submitted_filename, exists=exists}, user_data);
        }

        ImGui.CloseCurrentPopup();
    }
    PopButtonColor();

    ImGui.EndDisabled();

    ImGui.SameLine();

    PushButtonColor(.CancelButton);
    if ImGui.Button("Cancel") || ImGui.IsKeyPressed(.Escape) {
        if callback {
            callback(browser, .{kind=.Cancel}, user_data);
        }

        ImGui.CloseCurrentPopup();
    }
    PopButtonColor();

    ImGui.Columns(1);

    if new_directory {
        SetDirectory(browser, new_directory);
    }

    return;
}

LoadDirectoryTreeChildren :: (using browser : *FileBrowser, index : s64) {
    UserData :: struct {
        using browser : *FileBrowser;
        node_index : s64;
    }

    VisitCallback :: (info : *File_Visit_Info, using data : UserData) {
        if !info.is_directory {
            return;
        }

        child_index := directory_tree_nodes.count;
        child_node := ArrayPush(*directory_tree_nodes);
        child_node.parent_index = node_index;
        child_node.filename = StringClone(get_absolute_path(info.full_name));
        path_overwrite_separators(child_node.filename, #char "/");

        node := *directory_tree_nodes[node_index];
        ArrayPush(*node.children_indices, child_index);
    }

    node := directory_tree_nodes[index];
    if node.children_loaded {
        return;
    }

    visit_data := UserData.{browser, index};
    visit_files(node.filename, false, visit_data, xx VisitCallback, visit_directories=true);
    directory_tree_nodes[index].children_loaded = true;
}

ShowDirectoryTreeView :: (using browser : *FileBrowser, size : Vec2f) -> new_directory : string {
    TreeNode :: (using browser : *FileBrowser, index : s64) {
        node := *directory_tree_nodes[index];
        basename := path_filename(node.filename);
        if !basename {
            basename = node.filename;
        }

        if !basename {
            return;
        }

        if basename[basename.count - 1] == #char "/" {
            basename.count -= 1;
        }

        tree_node_flags := ImGui.TreeNodeFlags.OpenOnArrow;
        if node.children_loaded && node.children_indices.count == 0 {
            tree_node_flags |= .Leaf;
        }

        if StripTrailingSlash(current_directory) == StripTrailingSlash(node.filename) {
            tree_node_flags |= .Selected;
        }

        ImGui.SetNextItemOpen(node.opened, .Always);

        icon := ifx node.opened then Icon_Folder_Open_MDI else Icon_Folder_MDI;
        node_title := CTPrint("% %###%", icon, basename, node.filename);

        opened := ImGui.TreeNodeEx(node_title, flags=tree_node_flags);
        node.opened = opened;

        ImGui.SetItemTooltip(node.filename);

        if !ImGui.IsItemToggledOpen() && IsItemDoubleClicked() {
            SetDirectory(browser, node.filename);
        }

        if node.request_focus {
            ImGui.ScrollToItem();
        }

        if opened {
            if !node.children_loaded {
                LoadDirectoryTreeChildren(browser, index);
                node = *directory_tree_nodes[index];
            }

            for node.children_indices {
                TreeNode(browser, it);
            }

            ImGui.TreePop();
        }
    }

    defer ImGui.EndChild();

    if !ImGui.BeginChild("tree_view", size=size) {
        return "";
    }

    style := ImGui.GetStyle();
    ImGui.PushStyleVar(.IndentSpacing, style.IndentSpacing * 0.5);
    defer ImGui.PopStyleVar();

    for directory_tree_roots {
        TreeNode(browser, it);
    }

    for * directory_tree_nodes {
        it.request_focus = false;
    }

    return "";
}

ShowFileListTable :: (using browser : *FileBrowser, size : Vec2f) -> new_directory : string, should_submit : bool {
    filter_extensions : []string;
    if selected_filter >= 0 {
        filter_extensions = StringSplit(filters[selected_filter].extensions, #char ";" ,, Temp);
        for * filter_extensions {
            // Skip leading .
            it.* = StringAdvance(it.*, 1);
        }
    }

    should_submit := false;
    new_directory : string;

    table_flags := ImGui.TableFlags.None | .Resizable | .RowBg
        | .ScrollY | .ScrollX | .Sortable | .SortMulti | .Reorderable;
    if ImGui.BeginTable("Files", 4, table_flags, size) {
        ImGui.TableSetupColumn("Name", .NoHide, user_id=Column_Name);
        ImGui.TableSetupColumn("Type", .DefaultSort | .PreferSortDescending, user_id=Column_Type);
        ImGui.TableSetupColumn("Date Modified", .PreferSortDescending, user_id=Column_Date_Modified);
        ImGui.TableSetupColumn("Size", .PreferSortDescending, user_id=Column_Size);
        ImGui.TableSetupScrollFreeze(0, 1); // Keep headers visible when scrolling
        ImGui.TableHeadersRow();

        sort_specs := ImGui.TableGetSortSpecs();
        if sort_specs && sort_specs.SpecsDirty || entries_modified {
            SortEntries(browser, sort_specs);
            sort_specs.SpecsDirty = false;
            entries_modified = false;
        }

        for entries {
            ext := path_extension(it.filename);

            if !it.is_directory && filter_extensions.count > 0 {
                pass_filter := false;
                for filter_extensions {
                    if ext == it {
                        pass_filter = true;
                        break;
                    }
                }

                if !pass_filter {
                    continue;
                }
            }

            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);

            file_icon := GetFileIconByType(ext, it.is_directory);
            short_filename := path_filename(it.filename);
            selected := GetSelectedFile(browser) == it.filename;
            if ImGui.Selectable(CTPrint("% %", file_icon, short_filename), selected, flags=.SpanAllColumns | .AllowDoubleClick) {
                SetSelectedFile(browser, it.filename);
            }

            ImGui.SetItemTooltip("%", it.filename);

            if IsItemDoubleClicked() {
                if it.is_directory {
                    new_directory = it.filename;
                } else if !(flags & .SelectDirectory) {
                    SetSelectedFile(browser, it.filename);
                    should_submit = true;
                }
            }

            ImGui.TableNextColumn();

            type_string := GetFileTypeString(ext, it.is_directory);
            if type_string {
                if ext {
                    ImGui.Text(".% (%)", ext, type_string);
                } else {
                    ImGui.Text("%", type_string);
                }
            } else if ext {
                ImGui.Text(".%", ext);
            } else {
                ImGui.TextUnformatted("No extension");
            }

            ImGui.TableNextColumn();

            date_modified := Basic.to_calendar(it.date_modified, .LOCAL);
            year   := date_modified.year;
            month  := date_modified.month_starting_at_0 + 1;
            day    := date_modified.day_of_month_starting_at_0 + 1;
            hour   := FormatInt.{value=date_modified.hour, minimum_digits=2};
            minute := FormatInt.{value=date_modified.minute, minimum_digits=2};

            ImGui.Text("%/%/% %:%", month, day, year, hour, minute);

            ImGui.TableNextColumn();

            if it.size < 0 {
                ImGui.TextUnformatted("???");
            } else if it.size >= 1024 * 1024 * 1024 {
                ImGui.Text("% GB", it.size / (1024 * 1024 * 1024));
            } else if it.size >= 1024 * 1024 {
                ImGui.Text("% MB", it.size / (1024 * 1024));
            } else if it.size >= 1024 {
                ImGui.Text("% KB", it.size / 1024);
            } else {
                ImGui.Text("% B", it.size);
            }
        }

        ImGui.EndTable();
    }

    return new_directory, should_submit;
}

ShowFileListTiles :: (using browser : *FileBrowser, size : Vec2f) -> new_directory : string, should_submit : bool {
    defer ImGui.EndChild();

    if !ImGui.BeginChild("file_list_tiles", size) {
        return "", false;
    }

    filter_extensions : []string;
    if selected_filter >= 0 {
        filter_extensions = StringSplit(filters[selected_filter].extensions, #char ";" ,, Temp);
        for * filter_extensions {
            // Skip leading .
            it.* = StringAdvance(it.*, 1);
        }
    }

    if entries_modified {
        SortEntriesDefault(browser);
        entries_modified = false;
    }

    should_submit := false;
    new_directory : string;

    style := ImGui.GetStyle();
    button_size := tile_view_scale * File_Browser_Tile_Size;

    tile_on_line := false;
    for entries {
        ext := path_extension(it.filename);

        if !it.is_directory && filter_extensions.count > 0 {
            pass_filter := false;
            for filter_extensions {
                if ext == it {
                    pass_filter = true;
                    break;
                }
            }

            if !pass_filter {
                continue;
            }
        }

        avail := ImGui.GetContentRegionAvail();
        if avail.x < button_size.x && tile_on_line {
            ImGui.NewLine();
            tile_on_line = false;
        }

        if FileTileButton(browser, it, button_size) {
            SetSelectedFile(browser, it.filename);
        }

        tile_on_line = true;

        ImGui.SetItemTooltip("%", it.filename);

        if IsItemDoubleClicked() {
            if it.is_directory {
                new_directory = it.filename;
            } else if !(flags & .SelectDirectory) {
                SetSelectedFile(browser, it.filename);
                should_submit = true;
            }
        }

        ImGui.SameLine();
    }

    return new_directory, should_submit;
}

FileTileButton :: (browser : *FileBrowser, using entry : FileBrowserEntry, button_size : Vec2f) -> bool {
    style := ImGui.GetStyle();
    inner_size := button_size - style.FramePadding * 2;

    short_filename := path_filename(filename);
    ext := path_extension(filename);
    rect_min := ImGui.GetCursorScreenPos() + style.FramePadding;
    rect_max := rect_min + inner_size;

    selected := GetSelectedFile(browser) == filename;
    pressed := SelectableButton(CTPrint("##%", short_filename), selected, size=button_size);

    icon_area_size := Vec2f.{inner_size.x, inner_size.y * 0.6};
    icon_position := rect_min;

    filetype_text := GetFileTypeString(ext, is_directory);

    if ext {
        if filetype_text {
            filetype_text = TPrint("% (.%)", filetype_text, ext);
        } else {
            filetype_text = TPrint("(.%)", ext);
        }
    }

    filetype_text_size := ImGui.CalcTextSize(filetype_text);
    filetype_text_position := icon_position + .{0, inner_size.y - filetype_text_size.y};

    filename_text_size := ImGui.CalcTextSize(short_filename);
    filename_position := filetype_text_position - .{0, filename_text_size.y + style.ItemInnerSpacing.y};
    if filename_text_size.x < inner_size.x {
        filename_position.x += (inner_size.x - filename_text_size.x) * 0.5;
    }

    ImGui.PushFont(g_big_file_icon_font);

    icon_text := GetFileIconByType(ext, is_directory);
    icon_text_size := ImGui.CalcTextSize(icon_text);
    icon_position.x += (icon_area_size.x - icon_text_size.x) * 0.5;
    icon_position.y += (icon_area_size.y - icon_text_size.y) * 0.3;

    text_color := ImGui.GetColorU32(.Text);

    draw_list := ImGui.GetWindowDrawList();
    draw_list.PushClipRect(draw_list, rect_min, rect_max, true);
    draw_list.AddText(draw_list, icon_position, text_color, icon_text);

    ImGui.PopFont();

    draw_list.AddText(draw_list, filename_position, text_color, short_filename);
    if filetype_text {
        draw_list.AddText(draw_list,
            ImGui.GetFont(), ImGui.GetFontSize() * 0.8,
            filetype_text_position, text_color,
            filetype_text
        );
    }

    draw_list.AddLine(draw_list,
        rect_min + .{0, icon_area_size.y},
        rect_min + icon_area_size,
        text_color
    );

    draw_list.PopClipRect(draw_list);

    return pressed;
}

FileType :: enum {
    Unknown;
    Folder;
    Text;
    Config;
    SourceCode;
    Script;
    DLL;
    Executable;
    Image;
    Audio;
    Video;
    Mesh;
    Animation;
    Material;
    Archive;
    Font;
    Scene;
}

GetFileTypeString :: (ext : string, directory : bool) -> string {
    type := GetFileType(ext, directory);
    if #complete type == {
    case .Unknown;
        return "";
    case .Folder;
        return "Folder";
    case .Text;
        return "Text";
    case .Config;
        return "Config";
    case .SourceCode;
        return "Source Code";
    case .Script;
        return "Script";
    case .DLL;
        return "DLL";
    case .Executable;
        return "Executable";
    case .Image;
        return "Image";
    case .Audio;
        return "Audio";
    case .Video;
        return "Video";
    case .Mesh;
        return "Mesh";
    case .Animation;
        return "Animation";
    case .Material;
        return "Material";
    case .Archive;
        return "Archive";
    case .Font;
        return "Font";
    case .Scene;
        return "Scene";
    }
}

GetFileType :: (ext : string, directory : bool) -> FileType {
    if ext == {
    case "scene";
        return .Scene;

    case "png"; #through;
    case "jpg"; #through;
    case "jpeg"; #through;
    case "tga"; #through;
    case "hdr";
        return .Image;

    case "ttf"; #through;
    case "eot"; #through;
    case "otf"; #through;
    case "woff";
        return .Font;

    case "zip"; #through;
    case "rar"; #through;
    case "tar"; #through;
    case "tgz"; #through;
    case "gz"; #through;
    case "lz"; #through;
    case "rz"; #through;
    case "xz"; #through;
    case "7z"; #through;
    case "cab"; #through;
    case "pak"; #through;
    case "dmg"; #through;
    case "jar"; #through;
    case "a"; #through;
    case "ar"; #through;
    case "iso";
        return .Archive;

    case "blend"; #through;
    case "blend1"; #through;
    case "obj"; #through;
    case "mtl"; #through;
    case "fbx"; #through;
    case "gltf"; #through;
    case "glb"; #through;
    case "dae";
        return .Unknown;
    case "mesh";
        return .Mesh;

    case "anim";
        return .Animation;

    case "mat";
        return .Material;

    case "txt"; #through;
    case "log";
        return .Text;

    case "yaml"; #through;
    case "toml"; #through;
    case "json"; #through;
    case "md"; #through;
    case "jai"; #through;
    case "cpp"; #through;
    case "c"; #through;
    case "cs"; #through;
    case "js"; #through;
    case "java"; #through;
    case "py"; #through;
    case "frag"; #through;
    case "vert"; #through;
    case "geom"; #through;
    case "glsl"; #through;
    case "hlsl"; #through;
    case "hlsli"; #through;
    case "hlslv"; #through;
    case "hlslg"; #through;
    case "hlslp"; #through;
    case "metal"; #through;
    case "slang"; #through;
    case "go"; #through;
    case "rs"; #through;
    case "lua"; #through;
    case "h"; #through;
    case "hpp";
        return .SourceCode;

    case "m4a"; #through;
    case "flac"; #through;
    case "mp3"; #through;
    case "wav"; #through;
    case "wma"; #through;
    case "aac";
        return .Audio;

    case "mp4"; #through;
    case "wmv"; #through;
    case "mov"; #through;
    case "avchd"; #through;
    case "webm"; #through;
    case "avi";
        return .Video;

    case "dll"; #through;
    case "dylib";
    case "so";
        return .DLL;

    case "ini"; #through;
    case "conf"; #through;
    case "config"; #through;
    case "ld";
        return .Config;

    case "bat"; #through;
    case "sh";
        return .Script;

    case "exe";
        return .Executable;
    }

    if directory {
        return .Folder;
    }

    return .Unknown;
}

GetFileIconByType :: (ext : string, directory : bool) -> string {
    return GetFileIconByType(GetFileType(ext, directory));
}

GetFileIconByType :: (type : FileType) -> string {
    if #complete type == {
    case .Unknown;
        return Icon_File_Outline_MDI;
    case .Folder;
        return Icon_Folder_MDI;
    case .Text;
        return Icon_File_Document_Outline_MDI;
    case .Config;
        return Icon_File_Cog_Outline_MDI;
    case .SourceCode;
        return Icon_File_Code_Outline_MDI;
    case .Script;
        return Icon_Application_Braces_Outline_MDI;
    case .DLL;
        return Icon_Cogs_MDI;
    case .Executable;
        return Icon_Application_Outline_MDI;
    case .Image;
        return Icon_File_Image_Outline_MDI;
    case .Audio;
        return Icon_File_Music_Outline_MDI;
    case .Video;
        return Icon_File_Video_Outline_MDI;
    case .Mesh;
        return Icon_File_Outline_MDI;
    case .Animation;
        return Icon_File_Outline_MDI;
    case .Material;
        return Icon_File_Outline_MDI;
    case .Archive;
        return Icon_Zip_Box_Outline_MDI;
    case .Font;
        return Icon_Format_Font_MDI;
    case .Scene;
        return Icon_Archive_MDI;
    }
}
