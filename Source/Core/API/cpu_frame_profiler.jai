#import "Atomics";
#import "Thread";

Log_Profiling :: Log_Section.{name="CPU Frame Profiler"};

Max_CPU_Profiling_Event_Depth :: 100;
Max_CPU_Profiling_Events_Per_Frame :: 10000;

CPUProfilingEvent :: struct {
    start_time : Basic.Apollo_Time;
    end_time : Basic.Apollo_Time;
    name : string;
    filename : string;
    line_number : u32;
    thread_index : u32;
    depth : u32;
    parent_index_relative_to_thread : s32 = -1;
}

CPUProfiledThread :: struct {
    thread_name : string;
    thread_index : u32;
    max_depth : u32;
    frames : [..]CPUProfiledFrame;
}

CPUProfiledFrame :: struct {
    frame_index : int;
    start_time : Basic.Apollo_Time;
    end_time : Basic.Apollo_Time;
    first_event_index : int;
    last_event_index : int;
    max_depth : u32;
}

CPUFrameProfiler :: struct {
    thread_mutex : Mutex;
    thread_contexts : [..]*ProfilingThreadContext;

    profiled_threads : [..]CPUProfiledThread;
    all_events : [..]CPUProfilingEvent;
    num_profiled_frames : int;

    logged_warning_for_too_many_events : bool;

    frame_index : int;
    pause_next_frame := true;
    paused := true;
    frame_opened := false;
    opened_events : u32;
    num_events_this_frame : u32;
    events_this_frame : [Max_CPU_Profiling_Events_Per_Frame]CPUProfilingEvent;
}

ProfilingThreadContext :: struct {
    thread_name : string;
    thread_index : u32;
    thread_sequencial_event_index : u32;
    current_depth : u32;
    event_stack : [Max_CPU_Profiling_Event_Depth]u32;
}

#add_context profiling : ProfilingThreadContext;

InitFrameProfiler :: (using prof : *CPUFrameProfiler) {
    init(*thread_mutex);
    thread_contexts.allocator = context.allocator;

    profiled_threads.allocator = context.allocator;
    all_events.allocator = context.allocator;

    ProfilerRegisterThread(prof, "Main Thread");
}
@NoProfile

ProfilerRegisterThread :: (prof : *CPUFrameProfiler, name : string) {
    lock(*prof.thread_mutex);
    defer unlock(*prof.thread_mutex);

    context.profiling.thread_name = name;
    context.profiling.thread_index = context.thread_index;

    ArrayPush(*prof.thread_contexts, *context.profiling);
}
@NoProfile

ProfilerUnregisterThread :: (prof : *CPUFrameProfiler) {
    lock(*prof.thread_mutex);
    defer unlock(*prof.thread_mutex);

    index := ArrayFindFirst(prof.thread_contexts, *context.profiling);
    Assert(index != -1);

    ArrayRemove(*prof.thread_contexts, index);
}
@NoProfile

PauseProfiler :: inline (prof : *CPUFrameProfiler) {
    prof.logged_warning_for_too_many_events = false;
    prof.pause_next_frame = true;
    LogMessage("Paused profiling" ,, log_section=*Log_Profiling);
}
@NoProfile

ResumeProfiler :: inline (prof : *CPUFrameProfiler) {
    prof.pause_next_frame = false;
    LogMessage("Resumed profiling" ,, log_section=*Log_Profiling);
}
@NoProfile

ClearProfilingData :: (prof : *CPUFrameProfiler) {
    prof.logged_warning_for_too_many_events = false;

    for prof.profiled_threads {
        ArrayFree(*it.frames);
    }

    // Reduce the memory footprint if we have recorded many frames
    if prof.num_profiled_frames > 1000 {
        avg_events_per_frame := prof.all_events.count / prof.num_profiled_frames;
        ArrayFree(*prof.all_events);
        ArrayReserve(*prof.all_events, avg_events_per_frame * size_of(CPUProfilingEvent));
    } else {
        ArrayClear(*prof.all_events);
    }

    prof.num_profiled_frames = 0;

    ArrayClear(*prof.profiled_threads);
}
@NoProfile

GetProfiledTimeRange :: inline (using prof : *CPUFrameProfiler) -> start : Basic.Apollo_Time, end : Basic.Apollo_Time {
    if profiled_threads.count == 0 {
        return .{}, .{};
    }

    thread := profiled_threads[0];
    if thread.frames.count == 0 {
        return .{}, .{};
    }

    return thread.frames[0].start_time, thread.frames[thread.frames.count - 1].end_time;
}
@NoProfile

ProfilerBeginFrame :: inline (prof : *CPUFrameProfiler, location := #caller_location) -> *CPUProfilingEvent {
    Assert(!prof.frame_opened, "Called ProfilerBeginFrame before calling ProfilerEndFrame");

    prof.frame_opened = true;

    return ProfilerBeginEvent(prof, "CPU Frame", location);
}
@NoProfile

ProfilerEndFrame :: (prof : *CPUFrameProfiler, frame_event : *CPUProfilingEvent) {
    defer {
        prof.paused = prof.pause_next_frame;
        prof.num_events_this_frame = 0;
        prof.frame_index += 1;
        prof.frame_opened = false;
    };

    if prof.paused {
        Assert(frame_event == null);
        return;
    }

    if prof.num_events_this_frame > Max_CPU_Profiling_Events_Per_Frame {
        if !prof.logged_warning_for_too_many_events {
            LogWarning("Too many profiling events this frame (%, max is %)", prof.num_events_this_frame, Max_CPU_Profiling_Events_Per_Frame);
            prof.logged_warning_for_too_many_events = true;
        }

        prof.num_events_this_frame = Max_CPU_Profiling_Events_Per_Frame;
    }

    prof.num_profiled_frames += 1;

    ProfilerEndEvent(prof, frame_event);

    Assert(prof.opened_events == 0, "All profiling events must occur within a frame boundary");

    // This shouldn't be necessary, but just in case
    lock(*prof.thread_mutex);
    defer unlock(*prof.thread_mutex);

    added_new_thread := false;
    for prof.thread_contexts {
        it.thread_sequencial_event_index = 0;

        exists := false;
        for profiled_thread : prof.profiled_threads {
            if it.thread_index == profiled_thread.thread_index {
                exists = true;
                break;
            }
        }

        if !exists {
            new_thread := ArrayPush(*prof.profiled_threads);
            new_thread.thread_name = it.thread_name;
            new_thread.thread_index = it.thread_index;
            added_new_thread = true;
        }
    }

    if added_new_thread {
        QuickSort(prof.profiled_threads, (a, b) => cast(int, a.thread_index) - cast(int, b.thread_index));
    }

    // Save this before the quick sort
    current_frame_event := frame_event.*;

    CompareEventThreadIndex :: (a : CPUProfilingEvent, b : CPUProfilingEvent) -> int {
        thread_comp := cast(int, a.thread_index) - cast(int, b.thread_index);
        if thread_comp != 0 {
            return thread_comp;
        }

        return Basic.compare_apollo_times(a.start_time, b.start_time);
    }

    all_events_this_frame := ([]CPUProfilingEvent).{prof.num_events_this_frame, prof.events_this_frame.data};
    QuickSort(all_events_this_frame, CompareEventThreadIndex);

    event_index := prof.all_events.count;
    ArrayPushMultiple(*prof.all_events, all_events_this_frame);

    for * prof.profiled_threads {
        frame := ArrayPush(*it.frames);
        frame.frame_index = prof.frame_index;
        frame.start_time = current_frame_event.start_time;
        frame.end_time = current_frame_event.end_time;

        while event_index < prof.all_events.count
        && prof.all_events[event_index].thread_index < it.thread_index {
            event_index += 1;
        }

        frame.first_event_index = event_index;

        while event_index < prof.all_events.count
        && prof.all_events[event_index].thread_index == it.thread_index {
            frame.max_depth = Max(frame.max_depth, prof.all_events[event_index].depth);
            event_index += 1;
        }

        frame.last_event_index = event_index - 1;

        it.max_depth = Max(it.max_depth, frame.max_depth);
    }
}
@NoProfile

ProfilerBeginEvent :: (prof : *CPUFrameProfiler, name := "", location := #caller_location) -> *CPUProfilingEvent #expand {
    if prof.paused || !prof.frame_opened {
        return null;
    }

    index := atomic_add(*prof.num_events_this_frame, 1);

    if index >= Max_CPU_Profiling_Events_Per_Frame {
        return null;
    }

    atomic_increment(*prof.opened_events);

    event := *prof.events_this_frame[index];
    event.name = ifx name then name else #procedure_name();
    event.filename = location.fully_pathed_filename;
    event.line_number = xx location.line_number;
    event.thread_index = context.thread_index;

    if context.profiling.current_depth > 0 {
        event.parent_index_relative_to_thread = xx context.profiling.event_stack[context.profiling.current_depth - 1];
    } else {
        event.parent_index_relative_to_thread = -1;
    }

    context.profiling.event_stack[context.profiling.current_depth] = context.profiling.thread_sequencial_event_index;
    context.profiling.current_depth += 1;
    event.depth = context.profiling.current_depth;

    context.profiling.thread_sequencial_event_index += 1;

    event.start_time = Basic.current_time_monotonic();

    return event;
}
@NoProfile

ProfilerEndEvent :: inline (prof : *CPUFrameProfiler, event : *CPUProfilingEvent) {
    if !event {
        return;
    }

    event.end_time = Basic.current_time_monotonic();

    Assert(context.profiling.current_depth == event.depth, "Mismatching depth current is %, event is %", context.profiling.current_depth, event.depth);
    context.profiling.current_depth -= 1;

    atomic_decrement(*prof.opened_events);
}
@NoProfile

ProfileBlock :: (prof : *CPUFrameProfiler, name := "", location := #caller_location) #expand {
    event := ProfilerBeginEvent(prof, name, location);
    `defer ProfilerEndEvent(prof, event);
}
@NoProfile
