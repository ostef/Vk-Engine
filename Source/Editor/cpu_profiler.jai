CPUProfilerWindowState :: struct {
    opened := false; @Serialize(1)
    shown_events : [..]EditorProfilingEvent;
    sorted_events : []EditorProfilingEvent;
    max_events : s32 = 15; @Serialize(2)
}

g_cpu_profiler_window : CPUProfilerWindowState;

EditorProfilingEvent :: struct {
    start_time : Basic.Apollo_Time;
    end_time : Basic.Apollo_Time;
    name : string;
    filename : string;
    line_number : u32;
    thread_index : u32;
    parent : s32;
    children : [..]u32;
}

GetTotalTime :: (event : EditorProfilingEvent) -> Basic.Apollo_Time {
    return event.end_time - event.start_time;
}

GetSelfTime :: (event : EditorProfilingEvent) -> Basic.Apollo_Time {
    total_time := event.end_time - event.start_time;
    children_time : Basic.Apollo_Time;
    for event.children {
        child := g_cpu_profiler_window.shown_events[it];
        children_time += child.end_time - child.start_time;
    }

    return total_time - children_time;
}

ClearCPUProfilerWindowEventList :: () {
    for * g_cpu_profiler_window.shown_events {
        Free(it.name.data);
        ArrayFree(*it.children);
    }

    ArrayClear(*g_cpu_profiler_window.shown_events);

    Free(g_cpu_profiler_window.sorted_events.data);
    g_cpu_profiler_window.sorted_events = .[];
}

#scope_file

BuildEventList :: () {
    SetParent :: (event : *EditorProfilingEvent, index : int) {
        if index < 0 {
            event.parent = -1;
            return;
        }

        parent := *g_cpu_profiler_window.shown_events[index];
        ArrayPush(*parent.children, xx ArrayGetIndex(g_cpu_profiler_window.shown_events, event));
        event.parent = xx index;
    }

    profiler := GetCPUFrameProfiler();

    for * g_cpu_profiler_window.shown_events {
        Free(it.name.data);
        ArrayFree(*it.children);
    }

    ArrayClear(*g_cpu_profiler_window.shown_events);

    for profiler.profiled_threads {
        if it.frames.count <= 0 {
            continue;
        }

        thread_event_index := g_cpu_profiler_window.shown_events.count;
        frame := it.frames[it.frames.count - 1];
        for i : frame.first_event_index..frame.last_event_index {
            it := profiler.all_events[i];
            event := ArrayPush(*g_cpu_profiler_window.shown_events);
            event.name = StringClone(it.name);
            event.filename = it.filename;
            event.line_number = it.line_number;
            event.start_time = it.start_time;
            event.end_time = it.end_time;
            event.thread_index = it.thread_index;
            SetParent(event, thread_event_index + it.parent_index_relative_to_thread);
        }
    }

    Free(g_cpu_profiler_window.sorted_events.data);
    g_cpu_profiler_window.sorted_events = ArrayClone(g_cpu_profiler_window.shown_events);
}

Column_Name :: 0;
Column_Self_Time :: 1;
Column_Total_Time :: 2;
Column_Location :: 3;

SortEvents :: (specs : ImGui.TableSortSpecs) {
    Compare :: (a : EditorProfilingEvent, b : EditorProfilingEvent, specs : ImGui.TableSortSpecs) -> int {
        for i : 0..specs.SpecsCount - 1 {
            column_spec := specs.Specs[i];
            delta := 0;
            if column_spec.ColumnUserID == {
            case Column_Name;
                delta = StringCompare(a.name, b.name);

            case Column_Self_Time;
                time_a := GetSelfTime(a);
                time_b := GetSelfTime(b);
                delta = Basic.compare_apollo_times(time_a, time_b);

            case Column_Total_Time;
                time_a := GetTotalTime(a);
                time_b := GetTotalTime(b);
                delta = Basic.compare_apollo_times(time_a, time_b);

            case Column_Location;
                delta = StringCompare(
                    a.filename,
                    b.filename
                );

                if !delta {
                    delta = a.line_number - b.line_number;
                }
            }

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

        return Basic.compare_apollo_times(a.start_time, b.start_time);
    } @NoProfile

    QuickSort(g_cpu_profiler_window.sorted_events, specs, Compare);
}

#scope_export

ShowCPUProfiler :: () {
    if !g_cpu_profiler_window.opened {
        return;
    }

    defer ImGui.End();

    ImGui.SetNextWindowSize(.{450, 700}, .FirstUseEver);
    if !ImGui.Begin("CPU Profiler", *g_cpu_profiler_window.opened, flags=.HorizontalScrollbar) {
        return;
    }

    profiler := GetCPUFrameProfiler();

    if !profiler.paused {
        BuildEventList();
    }

    if profiler.paused {
        PushButtonColor(.EmphasisButton);
        if ImGui.Button("Start") {
            ClearProfilingData(profiler);
            ResumeProfiler(profiler);
        }
        PopButtonColor();
    } else {
        PushButtonColor(.EmphasisButton);
        if ImGui.Button("Stop") {
            PauseProfiler(profiler);
        }
        PopButtonColor();
    }

    ImGui.SameLine();

    ImGui.SetNextItemWidth(150);
    ImGui.SliderInt("Max Events", *g_cpu_profiler_window.max_events, 1, 100);

    table_flags := ImGui.TableFlags.Resizable | .RowBg | .ScrollX | .ScrollY
        | .Sortable | .SortMulti | .Hideable | .Reorderable;
    if ImGui.BeginTable("Events", 3, table_flags) {
        defer ImGui.EndTable();

        ImGui.TableSetupColumn("Name", .NoHide | .WidthStretch, 0.5, user_id=Column_Name);
        ImGui.TableSetupColumn("Self Time", .DefaultSort | .PreferSortDescending | .WidthStretch, 0.25, user_id=Column_Self_Time);
        ImGui.TableSetupColumn("Total Time", .PreferSortDescending | .WidthStretch, 0.25, user_id=Column_Total_Time);
        // ImGui.TableSetupColumn("Location", user_id=Column_Location);
        ImGui.TableSetupScrollFreeze(0, 1); // Keep headers visible when scrolling
        ImGui.TableHeadersRow();

        sort_specs := ImGui.TableGetSortSpecs();
        if !profiler.paused || sort_specs && sort_specs.SpecsDirty {
            SortEvents(sort_specs);
            sort_specs.SpecsDirty = false;
        }

        for i : 0..Min(g_cpu_profiler_window.sorted_events.count, g_cpu_profiler_window.max_events) - 1 {
            event := *g_cpu_profiler_window.sorted_events[i];
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(Column_Name);
            ImGui.Text("%", event.name);

            ImGui.TableSetColumnIndex(Column_Self_Time);
            ImGui.Text("% ms", Basic.to_float64_seconds(GetSelfTime(event)) * 1000);

            ImGui.TableSetColumnIndex(Column_Total_Time);
            ImGui.Text("% ms", Basic.to_float64_seconds(GetTotalTime(event)) * 1000);

            // @Todo: location is almost always wrong, and set to Build/profiler.jai
            // ImGui.TableSetColumnIndex(Column_Location);
            // ImGui.Text("%:%", event.filename, event.line_number);
        }
    }

    ClearProfilingData(profiler); // We only use the last frame data, so clear it all
}
