VK_KHR_win32_surface :: 1;
VK_KHR_WIN32_SURFACE_SPEC_VERSION :: 5;
VK_KHR_WIN32_SURFACE_EXTENSION_NAME :: "VK_KHR_win32_surface";

VkWin32SurfaceCreateFlagsKHR :: VkFlags;
VkWin32SurfaceCreateInfoKHR :: struct {
    sType:     VkStructureType = .WIN32_SURFACE_CREATE_INFO_KHR;
    pNext:     *void;
    flags:     VkWin32SurfaceCreateFlagsKHR;
    hinstance: HINSTANCE;
    hwnd:      HWND;
}

PFN_vkCreateWin32SurfaceKHR :: #type (a0: VkInstance, a1: *VkWin32SurfaceCreateInfoKHR, a2: *VkAllocationCallbacks, a3: *VkSurfaceKHR) -> VkResult #c_call;
PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR :: #type (a0: VkPhysicalDevice, a1: u32) -> VkBool32 #c_call;

VkImportMemoryWin32HandleInfoKHR :: struct {
    sType:      VkStructureType = .IMPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
    pNext:      *void;
    handleType: VkExternalMemoryHandleTypeFlagBits;
    handle:     HANDLE;
    name:       *s16;
}

VkExportMemoryWin32HandleInfoKHR :: struct {
    sType:       VkStructureType = .EXPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
    pNext:       *void;
    pAttributes: *SECURITY_ATTRIBUTES;
    dwAccess:    u32;
    name:        *s16;
}

VkMemoryWin32HandlePropertiesKHR :: struct {
    sType:          VkStructureType = .MEMORY_WIN32_HANDLE_PROPERTIES_KHR;
    pNext:          *void;
    memoryTypeBits: u32;
}

VkMemoryGetWin32HandleInfoKHR :: struct {
    sType:      VkStructureType = .MEMORY_GET_WIN32_HANDLE_INFO_KHR;
    pNext:      *void;
    memory:     VkDeviceMemory;
    handleType: VkExternalMemoryHandleTypeFlagBits;
}

PFN_vkGetMemoryWin32HandleKHR :: #type (a0: VkDevice, a1: *VkMemoryGetWin32HandleInfoKHR, a2: *HANDLE) -> VkResult #c_call;
PFN_vkGetMemoryWin32HandlePropertiesKHR :: #type (a0: VkDevice, a1: VkExternalMemoryHandleTypeFlagBits, a2: HANDLE, a3: *VkMemoryWin32HandlePropertiesKHR) -> VkResult #c_call;

VkWin32KeyedMutexAcquireReleaseInfoKHR :: struct {
    sType:            VkStructureType = .WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_KHR;
    pNext:            *void;
    acquireCount:     u32;
    pAcquireSyncs:    *VkDeviceMemory;
    pAcquireKeys:     *u64;
    pAcquireTimeouts: *u32;
    releaseCount:     u32;
    pReleaseSyncs:    *VkDeviceMemory;
    pReleaseKeys:     *u64;
}

VkImportSemaphoreWin32HandleInfoKHR :: struct {
    sType:      VkStructureType = .IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
    pNext:      *void;
    semaphore:  VkSemaphore;
    flags:      VkSemaphoreImportFlags;
    handleType: VkExternalSemaphoreHandleTypeFlagBits;
    handle:     HANDLE;
    name:       *s16;
}

VkExportSemaphoreWin32HandleInfoKHR :: struct {
    sType:       VkStructureType = .EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
    pNext:       *void;
    pAttributes: *SECURITY_ATTRIBUTES;
    dwAccess:    u32;
    name:        *s16;
}

VkD3D12FenceSubmitInfoKHR :: struct {
    sType:                      VkStructureType = .D3D12_FENCE_SUBMIT_INFO_KHR;
    pNext:                      *void;
    waitSemaphoreValuesCount:   u32;
    pWaitSemaphoreValues:       *u64;
    signalSemaphoreValuesCount: u32;
    pSignalSemaphoreValues:     *u64;
}

VkSemaphoreGetWin32HandleInfoKHR :: struct {
    sType:      VkStructureType = .SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR;
    pNext:      *void;
    semaphore:  VkSemaphore;
    handleType: VkExternalSemaphoreHandleTypeFlagBits;
}

PFN_vkImportSemaphoreWin32HandleKHR :: #type (a0: VkDevice, a1: *VkImportSemaphoreWin32HandleInfoKHR) -> VkResult #c_call;
PFN_vkGetSemaphoreWin32HandleKHR :: #type (a0: VkDevice, a1: *VkSemaphoreGetWin32HandleInfoKHR, a2: *HANDLE) -> VkResult #c_call;

VkImportFenceWin32HandleInfoKHR :: struct {
    sType:      VkStructureType = .IMPORT_FENCE_WIN32_HANDLE_INFO_KHR;
    pNext:      *void;
    fence:      VkFence;
    flags:      VkFenceImportFlags;
    handleType: VkExternalFenceHandleTypeFlagBits;
    handle:     HANDLE;
    name:       *s16;
}

VkExportFenceWin32HandleInfoKHR :: struct {
    sType:       VkStructureType = .EXPORT_FENCE_WIN32_HANDLE_INFO_KHR;
    pNext:       *void;
    pAttributes: *SECURITY_ATTRIBUTES;
    dwAccess:    u32;
    name:        *s16;
}

VkFenceGetWin32HandleInfoKHR :: struct {
    sType:      VkStructureType = .FENCE_GET_WIN32_HANDLE_INFO_KHR;
    pNext:      *void;
    fence:      VkFence;
    handleType: VkExternalFenceHandleTypeFlagBits;
}

PFN_vkImportFenceWin32HandleKHR :: #type (a0: VkDevice, a1: *VkImportFenceWin32HandleInfoKHR) -> VkResult #c_call;
PFN_vkGetFenceWin32HandleKHR :: #type (a0: VkDevice, a1: *VkFenceGetWin32HandleInfoKHR, a2: *HANDLE) -> VkResult #c_call;

VkImportMemoryWin32HandleInfoNV :: struct {
    sType:      VkStructureType = .IMPORT_MEMORY_WIN32_HANDLE_INFO_NV;
    pNext:      *void;
    handleType: VkExternalMemoryHandleTypeFlagsNV;
    handle:     HANDLE;
}

VkExportMemoryWin32HandleInfoNV :: struct {
    sType:       VkStructureType = .EXPORT_MEMORY_WIN32_HANDLE_INFO_NV;
    pNext:       *void;
    pAttributes: *SECURITY_ATTRIBUTES;
    dwAccess:    u32;
}

PFN_vkGetMemoryWin32HandleNV :: #type (a0: VkDevice, a1: VkDeviceMemory, a2: VkExternalMemoryHandleTypeFlagsNV, a3: *HANDLE) -> VkResult #c_call;

VkWin32KeyedMutexAcquireReleaseInfoNV :: struct {
    sType:                       VkStructureType = .WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_NV;
    pNext:                       *void;
    acquireCount:                u32;
    pAcquireSyncs:               *VkDeviceMemory;
    pAcquireKeys:                *u64;
    pAcquireTimeoutMilliseconds: *u32;
    releaseCount:                u32;
    pReleaseSyncs:               *VkDeviceMemory;
    pReleaseKeys:                *u64;
}

// Those will be in Vulkan.jai
// vkCreateWin32SurfaceKHR :: (instance: VkInstance, pCreateInfo: *VkWin32SurfaceCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pSurface: *VkSurfaceKHR) -> VkResult #foreign vulkan_1;
// vkGetPhysicalDeviceWin32PresentationSupportKHR :: (physicalDevice: VkPhysicalDevice, queueFamilyIndex: u32) -> VkBool32 #foreign vulkan_1;

#scope_module
wchar_t :: s16;

#scope_file
#import "Windows";
