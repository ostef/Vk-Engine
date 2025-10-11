Required_Extensions :: (*u8).[
    "VK_EXT_debug_utils",
];

Wanted_Layers :: (*u8).[
    "VK_LAYER_KHRONOS_validation",
];

InitGfxContext :: (window : *SDL_Window) {
    LogSectionScope(*Log_Vulkan);

    ctx := *g_gfx_context;

    result : VkResult;

    ctx.window = window;

    for * ctx.texture_view_collectors {
        it.destroy_func = DestroyGfxTextureView;
    }
    for * ctx.texture_collectors {
        it.destroy_func = DestroyGfxTexture;
    }
    for * ctx.sampler_collectors {
        it.destroy_func = DestroyGfxSampler;
    }
    for * ctx.buffer_collectors {
        it.destroy_func = DestroyGfxBuffer;
    }

    // Setup allocation callbacks
    #if Debug_Vulkan_Allocations {
        ctx.allocation_callbacks.pUserData = *context;
        ctx.allocation_callbacks.pfnAllocation = (data : *void, size : u64, alignment : u64, scope : VkSystemAllocationScope) -> *void #c_call {
            push_context, defer_pop;

            ptr := Alloc(xx size);
            memset(ptr, 0, xx size);

            return ptr;
        };
        ctx.allocation_callbacks.pfnReallocation = (data : *void, original_ptr : *void, size : u64, alignment : u64, scope : VkSystemAllocationScope) -> *void #c_call {
            push_context, defer_pop;

            return Realloc(original_ptr, 0, xx size);
        };
        ctx.allocation_callbacks.pfnFree = (data : *void, ptr : *void) #c_call {
            push_context, defer_pop;

            Free(ptr);
        };

        g_vk_alloc_callbacks = *ctx.allocation_callbacks;
    }

    // Create instance
    app_info : VkApplicationInfo;
    app_info.pApplicationName = "Vk";
    app_info.applicationVersion = VK_MAKE_VERSION(0,0,1);
    app_info.pEngineName = "VkEngine";
    app_info.engineVersion = VK_MAKE_VERSION(0,0,1);
    app_info.apiVersion = VK_API_VERSION_1_3;

    SDL_Vulkan_GetInstanceExtensions :: (window : *SDL_Window, num_extensions : *u32, extensions : **u8) -> SDL_bool #foreign SDL2;

    extensions : [..]*u8;
    extensions.allocator = Temp;

    num_extensions : u32;
    SDL_Vulkan_GetInstanceExtensions(ctx.window, *num_extensions, null);

    ArrayReserve(*extensions, num_extensions);
    SDL_Vulkan_GetInstanceExtensions(ctx.window, *num_extensions, extensions.data);
    extensions.count += num_extensions;

    for Required_Extensions {
        ArrayPush(*extensions, it);
    }

    // Make sure validation layers are available
    num_available_layers : u32;
    vkEnumerateInstanceLayerProperties(*num_available_layers, null);

    available_layers := AllocArray(VkLayerProperties, num_available_layers ,, Temp);
    vkEnumerateInstanceLayerProperties(*num_available_layers, available_layers.data);

    layers : [..]*u8;
    layers.allocator = Temp;

    for Wanted_Layers {
        found_layer := false;
        for available : available_layers {
            if MakeString(available.layerName.data) == MakeString(it) {
                found_layer = true;
                break;
            }
        }

        if !found_layer {
            LogWarning("Could not find validation layer '%'", MakeString(it));
        } else {
            ArrayPush(*layers, it);
        }
    }

    for layers {
        LogMessage("Layer '%'", MakeString(it));
    }

    inst_info : VkInstanceCreateInfo;
    inst_info.pApplicationInfo = *app_info;
    inst_info.enabledLayerCount = xx layers.count;
    inst_info.ppEnabledLayerNames = layers.data;
    inst_info.enabledExtensionCount = xx extensions.count;
    inst_info.ppEnabledExtensionNames = extensions.data;

    debug_info : VkDebugUtilsMessengerCreateInfoEXT;
    debug_info.messageSeverity = .VERBOSE_BIT_EXT | .WARNING_BIT_EXT | .ERROR_BIT_EXT;
    debug_info.messageType = .GENERAL_BIT_EXT | .VALIDATION_BIT_EXT | .PERFORMANCE_BIT_EXT;
    debug_info.pfnUserCallback = VulkanDebugCallback;
    debug_info.pUserData = *context;

    inst_info.pNext = *debug_info;

    for extensions {
        LogMessage("Extension '%'", MakeString(it));
    }

    result = vkCreateInstance(*inst_info, g_vk_alloc_callbacks, *ctx.instance);
    Assert(result == .SUCCESS, "vkCreateInstance failed");

    // Setup debug messenger
    vkCreateDebugUtilsMessengerEXT := cast(PFN_vkCreateDebugUtilsMessengerEXT, vkGetInstanceProcAddr(ctx.instance, "vkCreateDebugUtilsMessengerEXT"));
    if vkCreateDebugUtilsMessengerEXT {
        result = vkCreateDebugUtilsMessengerEXT(ctx.instance, *debug_info, g_vk_alloc_callbacks, *ctx.debug_messenger);
        Assert(result == .SUCCESS, "vkCreateDebugUtilsMessengerEXT failed");
    }

    // Get function pointers
    for type_info(GfxContext).members {
        if it.type.type != .PROCEDURE {
            continue;
        }

        if !StringStartsWith(it.name, "vk") {
            continue;
        }

        ptr := vkGetInstanceProcAddr(ctx.instance, CStringClone(it.name ,, Temp));
        if !ptr {
            LogError("Could not get function pointer of %", it.name);
            Basic.exit(1);
        }

        cast(**void, cast(*void, ctx) + it.offset_in_bytes).* = xx ptr;
    }

    // Create surface
    SDL_Vulkan_CreateSurface :: (window : *SDL_Window, instance : VkInstance, surface : *VkSurfaceKHR) -> SDL_bool #foreign SDL2;

    if !SDL_Vulkan_CreateSurface(ctx.window, ctx.instance, *ctx.surface) {
        LogError("Could not create window surface");
        Basic.exit(1);
    }

    // Choose physical device
    num_physical_devices : u32;
    vkEnumeratePhysicalDevices(ctx.instance, *num_physical_devices, null);
    Assert(num_physical_devices > 0, "No GPU");

    physical_devices := AllocArray(VkPhysicalDevice, num_physical_devices ,, Temp);
    vkEnumeratePhysicalDevices(ctx.instance, *num_physical_devices, physical_devices.data);

    best_score := -1;
    best_device : VkPhysicalDevice;
    for physical_devices {
        score := GetPhysicalDeviceScore(it);
        if score > 0 && score > best_score {
            best_device = it;
            best_score = score;
        }
    }

    if best_device == VK_NULL_HANDLE {
        LogError("Could not find a suitable device");
        Basic.exit(1);
    }

    props : VkPhysicalDeviceProperties;
    vkGetPhysicalDeviceProperties(best_device, *props);

    ctx.limits = MakeGfxLimits(props.limits);

    LogMessage("Using device '%'", MakeString(props.deviceName.data));
    ctx.physical_device = best_device;

    // Create logical device
    queue_family_indices := FindQueueFamilies(ctx.physical_device);
    ctx.general_purpose_queue_index = xx queue_family_indices.general_purpose;
    ctx.present_queue_index = xx queue_family_indices.present;

    families_to_create := u32.[xx queue_family_indices.general_purpose, xx queue_family_indices.present];
    queue_create_info : [families_to_create.count]VkDeviceQueueCreateInfo;
    queue_priority := 1.0;
    for * queue_create_info {
        it.queueFamilyIndex = families_to_create[it_index];
        it.queueCount = 1;
        it.pQueuePriorities = *queue_priority;
    }

    device_features : VkPhysicalDeviceFeatures;
    device_features.fillModeNonSolid = VK_TRUE;
    device_features.samplerAnisotropy = VK_TRUE;
    // Make out of bounds reads return 0s and out of bounds writes a noop
    device_features.robustBufferAccess = VK_TRUE;
    // Allow passing image2D to functions (not possible otherwise as the standard
    // does not define a way to declare an argument with the image format)
    device_features.shaderStorageImageReadWithoutFormat = VK_TRUE;
    device_features.shaderStorageImageWriteWithoutFormat = VK_TRUE;

    device_info : VkDeviceCreateInfo;
    device_info.pQueueCreateInfos = queue_create_info.data;
    device_info.queueCreateInfoCount = queue_create_info.count;
    device_info.pEnabledFeatures = *device_features;

    device_info.ppEnabledExtensionNames = Required_Device_Extensions.data;
    device_info.enabledExtensionCount = Required_Device_Extensions.count;
    device_info.enabledLayerCount = xx layers.count;
    device_info.ppEnabledLayerNames = layers.data;

    vulkan12_features : VkPhysicalDeviceVulkan12Features;
    vulkan12_features.shaderOutputLayer = VK_TRUE;
    vulkan12_features.descriptorBindingPartiallyBound = VK_TRUE;
    vulkan12_features.hostQueryReset = VK_TRUE;
    device_info.pNext = *vulkan12_features;

    vulkan13_features : VkPhysicalDeviceVulkan13Features;
    vulkan13_features.dynamicRendering = VK_TRUE;
    vulkan13_features.shaderDemoteToHelperInvocation = VK_TRUE;
    vulkan12_features.pNext = *vulkan13_features;

    if vkCreateDevice(ctx.physical_device, *device_info, g_vk_alloc_callbacks, *ctx.device) != .SUCCESS {
        LogError("Could not create logical device");
        Basic.exit(1);
    }

    vkGetDeviceQueue(ctx.device, xx queue_family_indices.general_purpose, 0, *ctx.general_purpose_queue);
    vkGetDeviceQueue(ctx.device, xx queue_family_indices.present, 0, *ctx.present_queue);

    CreateSwapchain();

    ctx.frame_command_pools = AllocArray(GfxCommandPool, Gfx_Num_Frames_In_Flight);
    for * ctx.frame_command_pools {
        it.* = CreateGfxCommandPool(TPrint("Frame In Flight %", it_index));
        Assert(!IsNull(it), "Could not create command pool");
    }

    ctx.frame_in_flight_fences = AllocArray(VkFence, Gfx_Num_Frames_In_Flight);
    for * ctx.frame_in_flight_fences {
        create_info : VkFenceCreateInfo;
        create_info.flags = .SIGNALED_BIT;
        vkCreateFence(ctx.device, *create_info, g_vk_alloc_callbacks, it);

        SetDebugName(it.*, TPrint("Fence 'Frame % rendered'", it_index));
    }

    ctx.swapchain_image_acquired_semaphores = AllocArray(VkSemaphore, Gfx_Num_Frames_In_Flight);
    for * ctx.swapchain_image_acquired_semaphores {
        create_info : VkSemaphoreCreateInfo;
        vkCreateSemaphore(ctx.device, *create_info, g_vk_alloc_callbacks, it);

        SetDebugName(it.*, TPrint("Semaphore 'Frame % swapchain image available'", it_index));
    }

    allocator_info : VmaAllocatorCreateInfo;
    allocator_info.physicalDevice = ctx.physical_device;
    allocator_info.device = ctx.device;
    allocator_info.instance = ctx.instance;
    allocator_info.vulkanApiVersion = VK_API_VERSION_1_3;
    if vmaCreateAllocator(*allocator_info, *ctx.allocator) != .SUCCESS {
        LogError("Could not create VMA allocator");
        Basic.exit(1);
    }

    LogMessage("Initialized Vulkan 1.3 context");

    ScopeLongFormStructFormat();
    LogMessage("Limits: %", g_gfx_context.limits);
}

DestroyGfxContext :: () {
    LogSectionScope(*Log_Vulkan);

    ctx := *g_gfx_context;

    for * ctx.texture_view_collectors {
        DestroyGfxGarbageCollector(it);
    }
    for * ctx.texture_collectors {
        DestroyGfxGarbageCollector(it);
    }
    for * ctx.sampler_collectors {
        DestroyGfxGarbageCollector(it);
    }
    for * ctx.buffer_collectors {
        DestroyGfxGarbageCollector(it);
    }

    vmaDestroyAllocator(ctx.allocator);

    vkDeviceWaitIdle(ctx.device);

    for ctx.frame_in_flight_fences {
        vkDestroyFence(ctx.device, it, g_vk_alloc_callbacks);
    }
    Free(ctx.frame_in_flight_fences.data);

    for ctx.swapchain_image_acquired_semaphores {
        vkDestroySemaphore(ctx.device, it, g_vk_alloc_callbacks);
    }
    Free(ctx.swapchain_image_acquired_semaphores.data);

    for * ctx.frame_command_pools {
        DestroyGfxCommandPool(it);
    }
    Free(ctx.frame_command_pools.data);

    DestroySwapchain();

    vkDestroyDevice(ctx.device, g_vk_alloc_callbacks);

    vkDestroySurfaceKHR(ctx.instance, ctx.surface, g_vk_alloc_callbacks);

    vkDestroyDebugUtilsMessengerEXT := cast(PFN_vkDestroyDebugUtilsMessengerEXT, vkGetInstanceProcAddr(ctx.instance, "vkDestroyDebugUtilsMessengerEXT"));
    if vkDestroyDebugUtilsMessengerEXT && ctx.debug_messenger != VK_NULL_HANDLE {
        vkDestroyDebugUtilsMessengerEXT(ctx.instance, ctx.debug_messenger, g_vk_alloc_callbacks);
    }

    vkDestroyInstance(ctx.instance, g_vk_alloc_callbacks);
}

GetPhysicalDeviceScore :: (device : VkPhysicalDevice) -> int {
    LogSectionScope(*Log_Vulkan);

    ctx := *g_gfx_context;

    props : VkPhysicalDeviceProperties;
    vkGetPhysicalDeviceProperties(device, *props);

    features : VkPhysicalDeviceFeatures;
    vkGetPhysicalDeviceFeatures(device, *features);

    // For systems with multiple discrete GPU, we could look at individual features to account for the score

    score := 1;
    if props.deviceType == .DISCRETE_GPU {
        score += 1000;
    }
    if props.deviceType == .INTEGRATED_GPU {
        score += 10;
    }

    queue_families := FindQueueFamilies(device);
    if queue_families.general_purpose < 0 {
        score = 0;
    }
    if queue_families.present < 0 {
        score = 0;
    }

    if !CheckDeviceExtensionSupport(device) {
        score = 0;
    } else {
        swapchain_support := QuerySwapchainSupportDetails(device);
        if swapchain_support.formats.count == 0 || swapchain_support.present_modes.count == 0 {
            score = 0;
        }
    }

    types := string.[
        "other",
        "integrated GPU",
        "discrete GPU",
        "virtual GPU",
        "CPU",
    ];

    LogMessage("Device: % '%', score: %", types[props.deviceType], MakeString(props.deviceName.data), score);

    return score;
}

QueueFamilyIndices :: struct {
    general_purpose : int = -1;
    present : int = -1;
}

FindQueueFamilies :: (device : VkPhysicalDevice) -> QueueFamilyIndices {
    LogSectionScope(*Log_Vulkan);

    ctx := *g_gfx_context;

    indices : QueueFamilyIndices;

    queue_family_count : u32;
    vkGetPhysicalDeviceQueueFamilyProperties(device, *queue_family_count, null);

    queue_families := AllocArray(VkQueueFamilyProperties, queue_family_count ,, Temp);
    vkGetPhysicalDeviceQueueFamilyProperties(device, *queue_family_count, queue_families.data);

    for queue_families {
        // LogMessage("Family %, count=%", it.queueFlags, it.queueCount);

        if it.queueFlags & (.GRAPHICS_BIT | .TRANSFER_BIT | .COMPUTE_BIT) == .GRAPHICS_BIT | .TRANSFER_BIT | .COMPUTE_BIT {
            indices.general_purpose = it_index;
        }

        present_supported : VkBool32;
        vkGetPhysicalDeviceSurfaceSupportKHR(device, xx it_index, ctx.surface, *present_supported);

        if present_supported {
            indices.present = it_index;
        }
    }

    return indices;
}

Required_Device_Extensions :: (*u8).[
    VK_KHR_SWAPCHAIN_EXTENSION_NAME,
];

CheckDeviceExtensionSupport :: (device : VkPhysicalDevice) -> bool {
    LogSectionScope(*Log_Vulkan);

    ctx := *g_gfx_context;

    num_extensions : u32;
    vkEnumerateDeviceExtensionProperties(device, null, *num_extensions, null);

    available_extensions := AllocArray(VkExtensionProperties, num_extensions ,, Temp);
    vkEnumerateDeviceExtensionProperties(device, null, *num_extensions, available_extensions.data);

    for Required_Device_Extensions {
        found := false;
        for avail : available_extensions {
            if MakeString(avail.extensionName.data) == MakeString(it) {
                found = true;
                break;
            }
        }

        if !found {
            return false;
        }
    }

    return true;
}

SwapchainSupportDetails :: struct {
    capabilities : VkSurfaceCapabilitiesKHR;
    formats : []VkSurfaceFormatKHR;
    present_modes : []VkPresentModeKHR;
}

QuerySwapchainSupportDetails :: (device : VkPhysicalDevice) -> SwapchainSupportDetails {
    LogSectionScope(*Log_Vulkan);

    ctx := *g_gfx_context;

    details : SwapchainSupportDetails;

    vkGetPhysicalDeviceSurfaceCapabilitiesKHR(device, ctx.surface, *details.capabilities);

    num_formats : u32;
    vkGetPhysicalDeviceSurfaceFormatsKHR(device, ctx.surface, *num_formats, null);

    details.formats = AllocArray(VkSurfaceFormatKHR, num_formats ,, Temp);
    vkGetPhysicalDeviceSurfaceFormatsKHR(device, ctx.surface, *num_formats, details.formats.data);

    num_present_modes : u32;
    vkGetPhysicalDeviceSurfacePresentModesKHR(device, ctx.surface, *num_present_modes, null);

    details.present_modes = AllocArray(VkPresentModeKHR, num_present_modes ,, Temp);
    vkGetPhysicalDeviceSurfacePresentModesKHR(device, ctx.surface, *num_present_modes, details.present_modes.data);

    return details;
}

ChooseSwapchainSurfaceFormat :: (available : []VkSurfaceFormatKHR) -> int {
    for available {
        if it.format == .B8G8R8A8_UNORM && it.colorSpace == .COLOR_SPACE_SRGB_NONLINEAR_KHR {
            return it_index;
        }
    }

    return -1;
}

ChooseSwapchainPresentMode :: (available : []VkPresentModeKHR) -> VkPresentModeKHR {
    if ArrayFindFirst(available, .FIFO_RELAXED_KHR) != -1 {
        return .FIFO_RELAXED_KHR;
    }

    return .FIFO_KHR;
}

ChooseSwapchainExtent :: (capabilities : VkSurfaceCapabilitiesKHR) -> VkExtent2D {
    ctx := *g_gfx_context;

    result : VkExtent2D;

    if capabilities.currentExtent.width != 0xffffffff {
        result = capabilities.currentExtent;
    } else {
        w, h := GetWindowPixelSize(ctx.window);

        result.width = xx w;
        result.height = xx h;
    }

    result.width = Clamp(result.width, capabilities.minImageExtent.width, capabilities.maxImageExtent.width);
    result.height = Clamp(result.height, capabilities.minImageExtent.height, capabilities.maxImageExtent.height);

    return result;
}

RecreateSwapchain :: () {
    LogSectionScope(*Log_Vulkan);

    ctx := *g_gfx_context;

    vkDeviceWaitIdle(ctx.device);

    DestroySwapchain();
    CreateSwapchain();
}

DestroySwapchain :: () {
    LogSectionScope(*Log_Vulkan);

    ctx := *g_gfx_context;

    for ctx.swapchain_image_ready_for_present_semaphores {
        vkDestroySemaphore(ctx.device, it, g_vk_alloc_callbacks);
    }
    Free(ctx.swapchain_image_ready_for_present_semaphores.data);

    for ctx.swapchain_textures {
        vkDestroyImageView(ctx.device, it.image_view, g_vk_alloc_callbacks);
    }

    Free(ctx.swapchain_textures.data);
    ctx.swapchain_textures = .[];

    vkDestroySwapchainKHR(ctx.device, ctx.swapchain, g_vk_alloc_callbacks);
    ctx.swapchain = VK_NULL_HANDLE;

    Free(ctx.swapchain_textures.data);
    ctx.swapchain_textures = .[];
}

CreateSwapchain :: () {
    LogSectionScope(*Log_Vulkan);

    ctx := *g_gfx_context;

    swapchain_support := QuerySwapchainSupportDetails(ctx.physical_device);
    caps := swapchain_support.capabilities;

    surface_format_index := ChooseSwapchainSurfaceFormat(swapchain_support.formats);
    if surface_format_index < 0 {
        LogError("No suitable swapchain surface format found");
        Basic.exit(1);
    }

    surface_format := swapchain_support.formats[surface_format_index];
    present_mode := ChooseSwapchainPresentMode(swapchain_support.present_modes);
    extent := ChooseSwapchainExtent(caps);
    image_count : u32 = 2;
    if caps.maxImageCount > 0 && image_count > caps.maxImageCount {
        image_count = caps.maxImageCount;
    }
    if image_count < caps.minImageCount {
        image_count = caps.minImageCount;
    }

    swapchain_create_info : VkSwapchainCreateInfoKHR;
    swapchain_create_info.surface = ctx.surface;
    swapchain_create_info.minImageCount = image_count;
    swapchain_create_info.imageFormat = surface_format.format;
    swapchain_create_info.imageColorSpace = surface_format.colorSpace;
    swapchain_create_info.imageExtent = extent;
    swapchain_create_info.imageArrayLayers = 1;
    swapchain_create_info.imageUsage = .COLOR_ATTACHMENT_BIT | .TRANSFER_DST_BIT;

    swapchain_queue_families : [2]u32 = .[ctx.general_purpose_queue_index, ctx.present_queue_index];
    if ctx.general_purpose_queue_index != ctx.present_queue_index {
        // Let Vulkan manage ownership if the queues differ, because we don't want to bother for now
        swapchain_create_info.imageSharingMode = .CONCURRENT;
        swapchain_create_info.queueFamilyIndexCount = 2;
        swapchain_create_info.pQueueFamilyIndices = swapchain_queue_families.data;
    } else {
        swapchain_create_info.imageSharingMode = .EXCLUSIVE;
    }

    swapchain_create_info.preTransform = caps.currentTransform;
    swapchain_create_info.compositeAlpha = .OPAQUE_BIT_KHR;

    swapchain_create_info.presentMode = present_mode;
    swapchain_create_info.clipped = VK_TRUE;

    if vkCreateSwapchainKHR(ctx.device, *swapchain_create_info, g_vk_alloc_callbacks, *ctx.swapchain) != .SUCCESS {
        LogError("Could not create swapchain");
        Basic.exit(1);
    }

    LogMessage("Created swapchain: %, %x%", MakeGfxPixelFormat(swapchain_create_info.imageFormat), swapchain_create_info.imageExtent.width, swapchain_create_info.imageExtent.height);

    ctx.swapchain_format = MakeGfxPixelFormat(surface_format.format);
    ctx.swapchain_extent = extent;

    num_images : u32;
    vkGetSwapchainImagesKHR(ctx.device, ctx.swapchain, *num_images, null);

    images := AllocArray(VkImage, num_images ,, Temp);
    vkGetSwapchainImagesKHR(ctx.device, ctx.swapchain, *num_images, images.data);

    ctx.swapchain_textures = AllocArray(GfxTexture, num_images, initialize=true);
    for * ctx.swapchain_textures {
        it.image = images[it_index];

        create_info : VkImageViewCreateInfo;
        create_info.image = it.image;
        create_info.viewType = ._2D;
        create_info.format = MakeVkFormat(ctx.swapchain_format);
        create_info.subresourceRange.aspectMask = .COLOR_BIT;
        create_info.subresourceRange.baseMipLevel = 0;
        create_info.subresourceRange.levelCount = 1;
        create_info.subresourceRange.baseArrayLayer = 0;
        create_info.subresourceRange.layerCount = 1;

        if vkCreateImageView(ctx.device, *create_info, g_vk_alloc_callbacks, *it.image_view) != .SUCCESS {
            Panic("Could not create swapchain image view %", it_index);
        }

        it.desc.type = .Texture2D;
        it.desc.pixel_format = ctx.swapchain_format;
        it.desc.width = ctx.swapchain_extent.width;
        it.desc.height = ctx.swapchain_extent.height;
        it.desc.usage = .ColorAttachment;

        SetDebugName(it.image, TPrint("Image 'Swapchain %'", it_index));
        SetDebugName(it.image_view, TPrint("Image View 'Swapchain %'", it_index));
    }

    ctx.swapchain_image_ready_for_present_semaphores = AllocArray(VkSemaphore, num_images);
    for * ctx.swapchain_image_ready_for_present_semaphores {
        create_info : VkSemaphoreCreateInfo;
        vkCreateSemaphore(ctx.device, *create_info, g_vk_alloc_callbacks, it);

        SetDebugName(it.*, TPrint("Semaphore 'Swapchain image % ready for present'", it_index));
    }
}
