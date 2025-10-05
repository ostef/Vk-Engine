GPUFrameProfiler :: struct {
    query_pools : [Gfx_Num_Frames_In_Flight]VkQueryPool;
    query_results : []u64;
    query_pool_capacity : u32;
    events_for_frame : [Gfx_Num_Frames_In_Flight][]GPUProfilingEvent;
    num_events_for_frame : [Gfx_Num_Frames_In_Flight]int;
    latest_frame : []GPUProfilingEvent;
    frame_index : int;

    current_event : *GPUProfilingEvent;
}

GPUProfilingEvent :: struct {
    name : string;
    index : int;
    start_gpu_tick : u64 = 0xffffffffffffffff;
    end_gpu_tick : u64 = 0xffffffffffffffff;
    elapsed_time_ms : float64;

    parent : *GPUProfilingEvent;
    first_child : *GPUProfilingEvent;
    last_child : *GPUProfilingEvent;
    next_sibling : *GPUProfilingEvent;
}

ProfileGPUZone :: (cmd_buffer : *GfxCommandBuffer, profiler : *GPUFrameProfiler, name : string) #expand {
    event := ProfilerBeginEvent(cmd_buffer, profiler, name);
    `defer ProfilerEndEvent(cmd_buffer, profiler, event);
} @NoProfile
