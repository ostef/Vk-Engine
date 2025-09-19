#load "initialization.jai";
#load "buffer.jai";
#load "texture.jai";
#load "render_pass.jai";
#load "compute_pass.jai";
#load "copy_pass.jai";
#load "pipelines.jai";
#load "binding_set.jai";
#load "barriers.jai";

Log_Vulkan :: Log_Section.{name="Graphics/Vulkan"};

Debug_Vulkan_Allocations :: false;
Vulkan_Break_On_Error :: true;

Frame_Max_Wait :: Second_To_Nano * 4;

g_vk_alloc_callbacks : *VkAllocationCallbacks;

GetGfxLimits :: inline () -> GfxLimits {
    return g_gfx_context.limits;
} @ModuleAPI @NoProfile

BeginFrame :: () {
    ctx := *g_gfx_context;

    ctx.last_frame_statistics = ctx.frame_statistics;
    ctx.frame_statistics = .{};

    ctx.frame_in_flight += 1;
    ctx.frame_in_flight %= Gfx_Num_Frames_In_Flight;
    ctx.frame_index += 1;

    {
        ProfileBlock(*g_cpu_profiler, "WaitForFrameFence");

        wait_result := vkWaitForFences(ctx.device, 1, *ctx.frame_in_flight_fences[ctx.frame_in_flight], VK_TRUE, Frame_Max_Wait);
        Assert(wait_result == .SUCCESS, "vkWaitForFences failed: %", wait_result);
    }

    while true {
        acquire_result := vkAcquireNextImageKHR(ctx.device, ctx.swapchain, Frame_Max_Wait, ctx.swapchain_image_acquired_semaphores[ctx.frame_in_flight], null, *ctx.frame_swapchain_image_index);

        // If we get SUBOPTIMAL_KHR then semaphore has been signaled so we cannot
        // ask again with the same semaphore.
        // Continue rendering as normal, we'll recreate the swapchain later
        if acquire_result == .ERROR_OUT_OF_DATE_KHR {
            RecreateSwapchain();
        } else {
            Assert(acquire_result == .SUCCESS || acquire_result == .SUBOPTIMAL_KHR, "vkAcquireNextImageKHR failed: %", acquire_result);
            break;
        }
    }

    vkResetFences(ctx.device, 1, *ctx.frame_in_flight_fences[ctx.frame_in_flight]);

    cmd_pool := *ctx.frame_command_pools[ctx.frame_in_flight];
    ResetGfxCommandPool(cmd_pool);

    BeginGfxDebugMarker(TPrint("Frame %", ctx.frame_index));

    CollectGarbage(*ctx.texture_view_collectors[ctx.frame_in_flight]);
    CollectGarbage(*ctx.texture_collectors[ctx.frame_in_flight]);
    CollectGarbage(*ctx.sampler_collectors[ctx.frame_in_flight]);
    CollectGarbage(*ctx.buffer_collectors[ctx.frame_in_flight]);
} @ModuleAPI

SubmitFrame :: () {
    ctx := *g_gfx_context;

    EndGfxDebugMarker();

    submit_stage_mask := VkPipelineStageFlags.COLOR_ATTACHMENT_OUTPUT_BIT;
    submit_info : VkSubmitInfo;
    submit_info.waitSemaphoreCount = 1;
    submit_info.pWaitSemaphores = *ctx.swapchain_image_acquired_semaphores[ctx.frame_in_flight];
    submit_info.pWaitDstStageMask = *submit_stage_mask;
    submit_info.signalSemaphoreCount = 1;
    submit_info.pSignalSemaphores = *ctx.swapchain_image_ready_for_present_semaphores[ctx.frame_swapchain_image_index];
    submit_info.commandBufferCount = xx ctx.command_buffers_to_submit.count;
    submit_info.pCommandBuffers = ctx.command_buffers_to_submit.data;
    vkQueueSubmit(ctx.general_purpose_queue, 1, *submit_info, ctx.frame_in_flight_fences[ctx.frame_in_flight]);

    ArrayClear(*ctx.command_buffers_to_submit);

    present_info : VkPresentInfoKHR;
    present_info.swapchainCount = 1;
    present_info.pSwapchains = *ctx.swapchain;
    present_info.waitSemaphoreCount = 1;
    present_info.pWaitSemaphores = *ctx.swapchain_image_ready_for_present_semaphores[ctx.frame_swapchain_image_index];
    present_info.pImageIndices = *ctx.frame_swapchain_image_index;
    present_result := vkQueuePresentKHR(ctx.present_queue, *present_info);
    if present_result == .ERROR_OUT_OF_DATE_KHR || present_result == .SUBOPTIMAL_KHR {
        RecreateSwapchain();
    } else {
        Assert(present_result == .SUCCESS, "Failed to present swapchain image");
    }
} @ModuleAPI

WaitForGPUIdle :: () {
    vkDeviceWaitIdle(g_gfx_context.device);
} @ModuleAPI @Profile

CreateGfxCommandPool :: (name : string) -> GfxCommandPool {
    ctx := *g_gfx_context;

    pool_info : VkCommandPoolCreateInfo;
    pool_info.queueFamilyIndex = ctx.general_purpose_queue_index;

    pool : VkCommandPool;
    if vkCreateCommandPool(ctx.device, *pool_info, g_vk_alloc_callbacks, *pool) != .SUCCESS {
        return .{};
    }

    SetDebugName(pool, TPrint("Command Pool '%'", name));

    return .{pool=pool, name=StringClone(name)};
}

DestroyGfxCommandPool :: (pool : *GfxCommandPool) {
    ArrayFree(*pool.free_cmd_buffers);
    ArrayFree(*pool.used_cmd_buffers);

    Free(pool.name.data);
    vkDestroyCommandPool(g_gfx_context.device, pool.pool, g_vk_alloc_callbacks);
    pool.* = .{};
} @ModuleAPI

ResetGfxCommandPool :: (pool : *GfxCommandPool) {
    for pool.used_cmd_buffers {
        ArrayPush(*pool.free_cmd_buffers, it);
    }

    ArrayClear(*pool.used_cmd_buffers);

    vkResetCommandPool(g_gfx_context.device, pool.pool, 0);
} @ModuleAPI

CreateGfxCommandBuffer :: (name : string) -> GfxCommandBuffer {
    ctx := *g_gfx_context;
    pool := *ctx.frame_command_pools[ctx.frame_in_flight];

    if pool.free_cmd_buffers.count > 0 {
        cmd_buffer := pool.free_cmd_buffers[pool.free_cmd_buffers.count - 1];
        ArrayPop(*pool.free_cmd_buffers);
        ArrayPush(*pool.used_cmd_buffers, cmd_buffer);

        begin_info : VkCommandBufferBeginInfo;
        begin_info.flags = .ONE_TIME_SUBMIT_BIT;
        vkBeginCommandBuffer(cmd_buffer.cmd_buffer, *begin_info);

        SetDebugName(cmd_buffer.cmd_buffer, TPrint("Command Buffer '%'", name));

        return cmd_buffer;
    }

    create_info : VkCommandBufferAllocateInfo;
    create_info.commandPool = pool.pool;
    create_info.level = .PRIMARY;
    create_info.commandBufferCount = 1;

    cmd_buffer : VkCommandBuffer;
    if vkAllocateCommandBuffers(ctx.device, *create_info, *cmd_buffer) != .SUCCESS {
        return .{};
    }

    begin_info : VkCommandBufferBeginInfo;
    begin_info.flags = .ONE_TIME_SUBMIT_BIT;
    vkBeginCommandBuffer(cmd_buffer, *begin_info);

    SetDebugName(cmd_buffer, TPrint("Command Buffer '%'", name));

    result := GfxCommandBuffer.{cmd_buffer=cmd_buffer};

    ArrayPush(*pool.used_cmd_buffers, result);

    return result;
} @ModuleAPI

SubmitGfxCommandBuffer :: (cmd_buffer : GfxCommandBuffer) {
    ctx := *g_gfx_context;

    vkEndCommandBuffer(cmd_buffer.cmd_buffer);
    ArrayPush(*ctx.command_buffers_to_submit, cmd_buffer.cmd_buffer);
} @ModuleAPI

// @Todo: integrate libshaderc instead of launching a child process
LoadGfxShader :: (name : string, extra_compiler_args : []string = .[], dependencies : *[..]string = null) -> GfxShader {
    #import "Process";

    stage := ifx StringEndsWith(name, ".vert")
        then "vert"
        else ifx StringEndsWith(name, ".frag")
        then "frag"
        else ifx StringEndsWith(name, ".comp")
        then "comp";

    if !stage {
        LogError("Could not detect shader stage for shader '%'", name);
        return .{};
    }

    stage_define := ifx stage == "vert"
        then "SHADER_STAGE_VERTEX"
        else ifx stage == "frag"
        then "SHADER_STAGE_FRAGMENT"
        else ifx stage == "comp"
        then "SHADER_STAGE_COMPUTE";

    filename := TPrint("Shaders/%.glsl", name);
    output_filename := TPrint("Shaders/%.spv", name);

    args : [..]string;
    args.allocator = Temp;
    ArrayPush(*args, "glslc");
    ArrayPush(*args, "-g");
    ArrayPush(*args, "-std=460");
    ArrayPush(*args, "--target-env=vulkan1.3");
    ArrayPush(*args, TPrint("-fshader-stage=%", stage));
    ArrayPush(*args, TPrint("-D%", stage_define));
    ArrayPushMultiple(*args, extra_compiler_args);
    ArrayPush(*args, filename);

    ArrayPush(*args, TPrint("-o%", output_filename));

    result, stdout, stderr := run_command(..args, capture_and_return_output=true);

    defer {
        Free(stdout.data);
        Free(stderr.data);
    }

    if result.exit_code != 0 {
        LogError("Could not compile shader '%':\n%", filename, stderr);
        return .{};
    }

    if dependencies {
        ArrayPop(*args);
        ArrayPush(*args, "-M");

        _, stdout, stderr := run_command(..args, capture_and_return_output=true);
        defer Free(stdout.data);
        defer Free(stderr.data);

        dependencies_str := stdout;
        colon_index := find_index_from_left(dependencies_str, ":");
        if colon_index >= 0 {
            dependencies_str = StringAdvance(dependencies_str, colon_index + 1);
        }

        splits := split(dependencies_str, " " ,, Temp);
        for splits {
            if it.count <= 0 {
                continue;
            }

            dep := trim(it);
            dep = get_absolute_path(dep ,, Temp);
            path_overwrite_separators(dep, #char "/");

            ArrayPush(dependencies, StringClone(dep));
        }
    }

    code, ok := read_entire_file(output_filename);
    if !ok {
        LogError("Could not read file '%'", output_filename);
        return .{};
    }

    defer Free(code.data);

    create_info : VkShaderModuleCreateInfo;
    create_info.sType = .SHADER_MODULE_CREATE_INFO;
    create_info.codeSize = xx code.count;
    create_info.pCode = cast(*u32, code.data);

    module : VkShaderModule;
    if vkCreateShaderModule(g_gfx_context.device, *create_info, g_vk_alloc_callbacks, *module) != .SUCCESS {
        LogError("Could not create shader module");
        return .{};
    }

    SetDebugName(module, TPrint("Shader '%'", name));

    return .{module=module};
} @ModuleAPI

DestroyGfxShader :: (shader : *GfxShader) {
    vkDestroyShaderModule(g_gfx_context.device, shader.module, g_vk_alloc_callbacks);
    shader.* = .{};
} @ModuleAPI

BeginGfxDebugMarker :: (cmd_buffer : *GfxCommandBuffer, name : string) {
    LogSectionScope(*Log_Vulkan);

    if !g_gfx_context.vkCmdBeginDebugUtilsLabelEXT || !g_gfx_context.vkCmdEndDebugUtilsLabelEXT {
        return;
    }

    label : VkDebugUtilsLabelEXT;
    label.pLabelName = CStringClone(name ,, Temp);
    g_gfx_context.vkCmdBeginDebugUtilsLabelEXT(cmd_buffer.cmd_buffer, *label);
} @ModuleAPI @NoProfile

EndGfxDebugMarker :: (cmd_buffer : *GfxCommandBuffer) {
    LogSectionScope(*Log_Vulkan);

    if !g_gfx_context.vkCmdBeginDebugUtilsLabelEXT || !g_gfx_context.vkCmdEndDebugUtilsLabelEXT {
        return;
    }

    g_gfx_context.vkCmdEndDebugUtilsLabelEXT(cmd_buffer.cmd_buffer);
} @ModuleAPI @NoProfile

BeginGfxDebugMarker :: (name : string) {
    LogSectionScope(*Log_Vulkan);

    if !g_gfx_context.vkQueueBeginDebugUtilsLabelEXT || !g_gfx_context.vkQueueEndDebugUtilsLabelEXT {
        return;
    }

    label : VkDebugUtilsLabelEXT;
    label.pLabelName = CStringClone(name ,, Temp);
    g_gfx_context.vkQueueBeginDebugUtilsLabelEXT(g_gfx_context.general_purpose_queue, *label);
} @ModuleAPI @NoProfile

EndGfxDebugMarker :: () {
    LogSectionScope(*Log_Vulkan);

    if !g_gfx_context.vkQueueBeginDebugUtilsLabelEXT || !g_gfx_context.vkQueueEndDebugUtilsLabelEXT {
        return;
    }

    g_gfx_context.vkQueueEndDebugUtilsLabelEXT(g_gfx_context.general_purpose_queue);
} @ModuleAPI @NoProfile

SetDebugName :: (obj : $T, name : string) {
    ctx := *g_gfx_context;
    if !ctx.vkSetDebugUtilsObjectNameEXT {
        return;
    }

    Object_Types :: (struct{type : Type; vk_type : VkObjectType;}).[
        .{VkPhysicalDevice, .PHYSICAL_DEVICE},
        .{VkDevice, .DEVICE},
        .{VkQueue, .QUEUE},
        .{VkSemaphore, .SEMAPHORE},
        .{VkFence, .FENCE},
        .{VkBuffer, .BUFFER},
        .{VkBufferView, .BUFFER_VIEW},
        .{VkImage, .IMAGE},
        .{VkImageView, .IMAGE_VIEW},
        .{VkShaderModule, .SHADER_MODULE},
        .{VkPipelineCache, .PIPELINE_CACHE},
        .{VkPipelineLayout, .PIPELINE_LAYOUT},
        .{VkRenderPass, .RENDER_PASS},
        .{VkPipeline, .PIPELINE},
        .{VkDescriptorSetLayout, .DESCRIPTOR_SET_LAYOUT},
        .{VkSampler, .SAMPLER},
        .{VkDescriptorPool, .DESCRIPTOR_POOL},
        .{VkDescriptorSet, .DESCRIPTOR_SET},
        .{VkFramebuffer, .FRAMEBUFFER},
        .{VkCommandPool, .COMMAND_POOL},
        .{VkCommandBuffer, .COMMAND_BUFFER},
        .{VkSurfaceKHR, .SURFACE_KHR},
        .{VkSwapchainKHR, .SWAPCHAIN_KHR},
        .{VkDebugReportCallbackEXT, .DEBUG_REPORT_CALLBACK_EXT},
        .{VkDisplayKHR, .DISPLAY_KHR},
        .{VkDisplayModeKHR, .DISPLAY_MODE_KHR},
        .{VkValidationCacheEXT, .VALIDATION_CACHE_EXT},
    ];

    name_info : VkDebugUtilsObjectNameInfoEXT;
    name_info.objectType = #run -> VkObjectType {
        for Object_Types {
            if it.type == T {
                return it.vk_type;
            }
        }

        Panic("Unhandled object type %", T);
        return .UNKNOWN;
    }

    name_info.objectHandle = xx obj;
    name_info.pObjectName = CStringClone(name ,, Temp);
    ctx.vkSetDebugUtilsObjectNameEXT(ctx.device, *name_info);
} @NoProfile

VulkanDebugCallback :: (
    severity : VkDebugUtilsMessageSeverityFlagBitsEXT,
    type : VkDebugUtilsMessageTypeFlagsEXT,
    callback_data : *VkDebugUtilsMessengerCallbackDataEXT,
    user_data : *void
) -> VkBool32 #c_call {
    if callback_data.messageIdNumber == {
    case 0xc81ad50e; // WARNING-Shader-OutputNotConsumed
        return VK_FALSE;
    }

    ctx := cast(*#Context, user_data).*;
    push_context,defer_pop ctx;

    LogSectionScope(*Log_Vulkan);

    msg := MakeString(callback_data.pMessage);
    msg=, spec, verbose := MakeVulkanDebugMessageLessVerbose(msg);

    if verbose {
        LogMessage("messageId=0x%, %", FormatIntHex(callback_data.messageIdNumber), verbose, flags=.VERBOSE_ONLY);
    } else {
        LogMessage("messageId=0x%", FormatIntHex(callback_data.messageIdNumber), flags=.VERBOSE_ONLY);
    }

    if severity & .ERROR_BIT_EXT {
        LogError("%\n%", msg, spec);
        #if Vulkan_Break_On_Error {
            Panic("Vulkan error");
        }
    } else if severity & .WARNING_BIT_EXT {
        LogWarning("%\n%", msg, spec);
    } else {
        LogMessage("%\n%", msg, spec);
    }

    return VK_FALSE;
}

MakeVulkanDebugMessageLessVerbose :: (msg : string) -> msg : string, spec : string, verbose : string {
    i := find_index_from_left(msg, "MessageID = 0x");
    if i < 0 {
        return msg, "", "";
    }

    result := StringAdvance(msg, i + "MessageID = 0x".count);
    _, _, result = Basic.string_to_int(result, base=16);
    result = StringAdvance(result, " | ".count);

    spec : string;

    i2 := find_index_from_left(result, "The Vulkan spec states: ");
    if i2 >= 0 {
        spec = StringAdvance(result, i2 + "The Vulkan spec states: ".count);
        result.count = i2;
    }

    verbose := msg;
    verbose.count = i;

    return result, spec, verbose;
}
