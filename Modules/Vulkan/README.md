Current version: Based on LunarG Vulkan SDK 1.3.250.1

#import this module into a jai program in order to use Vulkan v1-1.3 in your program. 'PFN_' functions need to be linked at runtime.

Extends the module provided with the compiler by providing 1.3 support as well as integrating Vulkan Memory Allocator. I did it this way rather than creating a separate module to decrease the possibility of borked dependency issues.

VMA generation has only been run and tested on windows. It will need some work to have a solution for linux.

## How to Use
1. download this repository into your project's local modules directory (or the global modules directory if you prefer).
2. you can optionally check that generation is working correctly (windows only) by running 'jai generate.jai'. there should be a lot of stripped functions in the print output. i believe these are all vulkan extension functions that aren't linked automatically via vulkan-1.lib.
3. add this code to your project's build script:
```
    // --- ADD THIS CODE ---
    linker_args: [..]string;
    for build_options.additional_linker_arguments {
        array_add(*linker_args, it);
    }
    // vulkan memory allocator depends on this
    array_add(*linker_args, "libcpmt.lib");
    build_options.additional_linker_arguments = linker_args;
    // --- ------------- ---

    // ... and later...

    // build your game
    set_build_options(build_options, w);
    add_build_file("src/game.jai", w);
```
4. add `#import "Vulkan_With_VMA"` to your project's code.
5. after having created the requisite vulkan devices, create the allocator:
```
    allocator_info := VmaAllocatorCreateInfo.{
        physicalDevice = physical_device,
        device = logical_device,
        instance = vk_instance,
        flags = .BUFFER_DEVICE_ADDRESS_BIT,
        vulkanApiVersion = VK_API_VERSION_1_3 // or whatever version you're using
    };
    vmaCreateAllocator(*allocator_info, *vk_allocator);
```
... and you should hopefully be set!

## Config
### Vulkan Memory Allocator Compile Time
there is a little bit of config available in generate.jai:
```
// compile vulkan memory allocator lib
VK_MEM_ALLOC_COMPILE            :: true;
// output binding for the vulkan memory allocator lib
VK_MEM_ALLOC_OUTPUT_BINDINGS    :: true;
```
### Project Compile Time
in module.jai there is also a module parameter, "MEMORY_ALLOCATOR_DEBUG", for deciding which .lib file (debug or not) to link against. the debug one has debug symbols and does validation and printing similar to vulkan validation layers.
```
#module_parameters(USE_VULKAN_1_1 := true)(MEMORY_ALLOCATOR_DEBUG := false);
```
you can set this via your import statement.
```
#import "Vulkan_With_VMA"()(MEMORY_ALLOCATOR_DEBUG=true);
```
