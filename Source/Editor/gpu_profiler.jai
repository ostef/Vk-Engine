g_show_gpu_profiler := false;

ShowGPUProfilerTimings :: () {
    ShowEvent :: (event : *GPUProfilingEvent) {
        label := CTPrint("% - % ms###%", event.name, event.elapsed_time_ms, event.index);
        flags := ImGui.TreeNodeFlags.DefaultOpen | .OpenOnArrow | .SpanFullWidth;
        if !event.first_child {
            flags |= .Leaf;
        }

        opened := ImGui.TreeNodeEx(label, flags);
        ImGui.SetItemTooltip("%:%:%", event.location.fully_pathed_filename, event.location.line_number, event.location.character_number);

        if opened {
            defer ImGui.TreePop();

            child := event.first_child;
            while child
            {
                ShowEvent(child);
                child = child.next_sibling;
            }
        }
    }

    prev_format_float := context.print_style.default_format_float;
    defer context.print_style.default_format_float = prev_format_float;
    context.print_style.default_format_float.width = 6;
    context.print_style.default_format_float.trailing_width = 3;
    context.print_style.default_format_float.zero_removal = .NO;

    start_gpu_tick : u64 = 0xffffffffffffffff;
    end_gpu_tick : u64 = 0;
    for GetGPUFrameProfiler().latest_frame {
        start_gpu_tick = Min(start_gpu_tick, it.start_gpu_tick);
        end_gpu_tick = Max(end_gpu_tick, it.end_gpu_tick);
    }

    total_frame_time := (end_gpu_tick - start_gpu_tick) * GetGfxLimits().timestamp_tick_period / 1000000.0;

    if ImGui.TreeNodeEx(CTPrint("Frame - % ms###profiler_frame_time", total_frame_time), .DefaultOpen | .OpenOnArrow | .SpanFullWidth) {
        for * GetGPUFrameProfiler().latest_frame {
            if it.parent {
                continue;
            }

            ShowEvent(it);
        }

        ImGui.TreePop();
    }
}

ShowGPUFrameStatistics :: () {
    stats := GetGfxFrameStatistics();
    if BeginInspectorTable("gpu_frame_statistics", .NoReset) {
        defer ImGui.EndTable();

        BeginInspectorLine("Draw Calls");
        ImGui.Text("%", stats.num_draw_calls);
        EndInspectorLine();

        BeginInspectorLine("Dispatch Calls");
        ImGui.Text("%", stats.num_dispatch_calls);
        EndInspectorLine();

        BeginInspectorLine("Render Passes");
        ImGui.Text("%", stats.num_render_passes);
        EndInspectorLine();

        BeginInspectorLine("Compute Passes");
        ImGui.Text("%", stats.num_compute_passes);
        EndInspectorLine();

        BeginInspectorLine("Graphics Binding Set Binds");
        ImGui.Text("%", stats.num_graphics_binding_set_binds);
        EndInspectorLine();

        BeginInspectorLine("Compute Binding Set Binds");
        ImGui.Text("%", stats.num_compute_binding_set_binds);
        EndInspectorLine();

        BeginInspectorLine("Graphics Pipeline Binds");
        ImGui.Text("%", stats.num_graphics_pipeline_binds);
        EndInspectorLine();

        BeginInspectorLine("Compute Pipeline Binds");
        ImGui.Text("%", stats.num_compute_pipeline_binds);
        EndInspectorLine();

        BeginInspectorLine("Texture Barriers");
        ImGui.Text("%", stats.num_texture_barriers);
        EndInspectorLine();

        BeginInspectorLine("Memory Barriers");
        ImGui.Text("%", stats.num_memory_barriers);
        EndInspectorLine();

        BeginInspectorLine("Execution Barriers");
        ImGui.Text("%", stats.num_execution_barriers);
        EndInspectorLine();
    }
}

ShowGPUProfiler :: () {
    if !g_show_gpu_profiler {
        return;
    }

    defer ImGui.End();

    ImGui.SetNextWindowSize(.{450, 700}, .FirstUseEver);
    if !ImGui.Begin("GPU Profiler", *g_show_gpu_profiler, flags=.HorizontalScrollbar) {
        return;
    }

    if ImGui.BeginTabBar("gpu_profiler") {
        if ImGui.BeginTabItem("Timings") {
            ShowGPUProfilerTimings();
            ImGui.EndTabItem();
        }

        if ImGui.BeginTabItem("Statistics") {
            ShowGPUFrameStatistics();
            ImGui.EndTabItem();
        }

        ImGui.EndTabBar();
    }
}
