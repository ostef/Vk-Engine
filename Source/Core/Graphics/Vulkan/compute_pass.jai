BeginGfxComputePass :: (cmd_buffer : *GfxCommandBuffer, name : string, location := #caller_location) -> GfxComputePass {
    LogSectionScope(*Log_Vulkan);

    BeginGfxDebugMarker(cmd_buffer, name);
    profiling_event := ProfilerBeginEvent(cmd_buffer, *g_gpu_frame_profiler, name, location);
    g_gfx_context.frame_statistics.num_compute_passes += 1;

    return .{cmd_buffer=cmd_buffer, profiling_event=profiling_event, name=name};
} @Public

EndGfxComputePass :: (pass : *GfxComputePass) {
    LogSectionScope(*Log_Vulkan);

    ProfilerEndEvent(pass.cmd_buffer, *g_gpu_frame_profiler, pass.profiling_event);
    EndGfxDebugMarker(pass.cmd_buffer);

    AddBarrier(pass.cmd_buffer);
} @Public

BindComputePipeline :: (pass : *GfxComputePass, pipeline : *GfxComputePipeline) {
    pass.current_pipeline = pipeline;
    vkCmdBindPipeline(pass.cmd_buffer.cmd_buffer, .COMPUTE, pipeline.pipeline);
    g_gfx_context.frame_statistics.num_compute_pipeline_binds += 1;
} @Public @NoProfile

BindComputeBindingSet :: (pass : *GfxComputePass, index : u32, set : *GfxBindingSet) {
    Assert(pass.current_pipeline != null, "Render pass has no pipeline bound yet. Use BindComputeBindingSet on a command buffer and specify pipeline layout or bind a pipeline first");

    BindComputeBindingSet(pass.cmd_buffer, *pass.current_pipeline.layout, index, set);
} @Public @NoProfile

Dispatch :: (pass : *GfxComputePass, num_groups_x : u32, num_groups_y : u32, num_groups_z : u32) {
    vkCmdDispatch(pass.cmd_buffer.cmd_buffer, num_groups_x, num_groups_y, num_groups_z);
    g_gfx_context.frame_statistics.num_dispatch_calls += 1;
} @Public @NoProfile
