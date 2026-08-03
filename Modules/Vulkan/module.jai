// On lib/dll usage in windows:
//  -   vulkan-1.dll is your program's interface with the vulkan runtime, which interacts with graphics drivers.
//  -   vulkan-1.dll is distributed via at least graphics driver installations and vc++ redistributables. not sure what
//  else.
//  -   vulkan-1.lib is a convenience binary. it loads functions from vulkan-1.dll so you don't have to do it in your
//  program. it might have some other stuff in it, like maybe validation layers (?)
//  -   vulkan-1.lib is distributed via the vulkan SDK.
//  -   you can use vulkan-1.lib in two configurations, exposed by module parameter USE_LOCAL_VULKAN_DYNAMIC_LIB:
//          1. load from the local dll file.
//          2. load from the system dll file.
//  -   if you want to swap in a different local .dll, you can find it in your system folders (syswow64 should have it),
//  and drop it into the Libs/ folder. If you want to swap in a different local .lib, download the vulkan sdk and
//  copy it from there.

VK_NULL_HANDLE                    :: null;

VK_TRUE:                   VkBool32: 1;
VK_FALSE:                  VkBool32: 0;

VK_WHOLE_SIZE:             u64: xx ~0;
VK_ATTACHMENT_UNUSED:      u32: 0xffff_ffff;
VK_QUEUE_FAMILY_IGNORED:   u32: 0xffff_ffff;
VK_REMAINING_ARRAY_LAYERS: u32: 0xffff_ffff;
VK_REMAINING_MIP_LEVELS:   u32: 0xffff_ffff;
VK_SUBPASS_EXTERNAL:       u32: 0xffff_ffff;

VK_MAX_PHYSICAL_DEVICE_NAME_SIZE: u32: 256;
VK_UUID_SIZE:                     u32: 16;
VK_MAX_MEMORY_TYPES:              u32: 32;
VK_MAX_MEMORY_HEAPS:              u32: 16;
VK_MAX_EXTENSION_NAME_SIZE:       u32: 256;
VK_MAX_DESCRIPTION_SIZE:          u32: 256;

// These defines are deprecated by vulkan 1.2:
VK_MAKE_VERSION :: (major: u32, minor: u32, patch: u32) -> u32 {
    return (major << 22) | (minor << 12) | patch;
}
VK_VERSION_MAJOR :: (version: u32) -> u32 { return version >> 22; }
VK_VERSION_MINOR :: (version: u32) -> u32 { return (version >> 12) & 0x3ff; }
VK_VERSION_PATCH :: (version: u32) -> u32 { return version & 0xfff; }

VK_API_VERSION_1_0 :: #run VK_MAKE_VERSION(1, 0, 0);
VK_API_VERSION_1_1 :: #run VK_MAKE_VERSION(1, 1, 0);
VK_API_VERSION_1_2 :: #run VK_MAKE_VERSION(1, 2, 0);
VK_API_VERSION_1_3 :: #run VK_MAKE_VERSION(1, 3, 0);

// These are the new versions:
VK_MAKE_API_VERSION :: (variant:u32, major: u32, minor: u32, patch: u32) -> u32 {
    return (variant << 22) | (major << 22) | (minor << 12) | patch;
}

VK_API_VERSION_VARIANT :: (version: u32) -> u32 { return (version >> 29); }
VK_API_VERSION_MAJOR   :: (version: u32) -> u32 { return (version >> 22) & 0x3ff; }
VK_API_VERSION_MINOR   :: (version: u32) -> u32 { return (version >> 12) & 0x3ff; }
VK_API_VERSION_PATCH   :: (version: u32) -> u32 { return version & 0xfff; }

#if OS == .WINDOWS {
    #load "vulkan_windows.jai";
    #load "windows_extras.jai";

    libvulkan :: #library,no_static_library "Libs/Windows/vulkan-1";
    vkmemalloc :: #library,no_dll "Libs/Windows/VkMemAlloc";

    // Needed by VkMemAlloc
    cprt :: #system_library,link_always "msvcprt";
} else #if OS == .LINUX {
    #load "vulkan_linux.jai";

    libvulkan :: #system_library "libvulkan";
    vkmemalloc :: #library,no_dll "Libs/Linux/libVkMemAlloc";

    // Needed by VkMemAlloc
    libstdcpp :: #system_library,link_always "libstdc++.so.6";
    libunwind :: #system_library,link_always "libunwind";
}

#scope_module

size_t  :: u64;
