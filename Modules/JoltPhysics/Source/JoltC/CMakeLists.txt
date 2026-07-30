cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(JoltC LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD          17)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS        OFF)

# When turning this option on, JoltC and Jolt will be compiled as a single shared library
option(JOLTC_BUILD_COMBINED_SHARED_LIBS "Compile JoltC and Jolt as a single shared library" OFF)
# When turning this option on, JoltC will be compiled as a shared library and public symbols will be exported.
option(JOLTC_BUILD_SHARED_LIBS "Compile JoltC as a shared library" ${BUILD_SHARED_LIBS})

if(JOLTC_BUILD_COMBINED_SHARED_LIBS)
    set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)
    set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "" FORCE)
    set(USE_STATIC_MSVC_RUNTIME_LIBRARY OFF CACHE BOOL "" FORCE)
    set(JOLTC_BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)
    set(JPH_BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
endif()

include(FetchContent)

# Search for local JoltPhysics first
if(EXISTS "${CMAKE_SOURCE_DIR}/JoltPhysics/Build/CMakeLists.txt")
    message(STATUS "Using local JoltPhysics from ${CMAKE_SOURCE_DIR}/JoltPhysics")

    FetchContent_Declare(
        JoltPhysics
        SOURCE_DIR "${CMAKE_SOURCE_DIR}/JoltPhysics"
        SOURCE_SUBDIR "Build"
    )
elseif(EXISTS "${CMAKE_SOURCE_DIR}/../JoltPhysics/Build/CMakeLists.txt")
    message(STATUS "Using local JoltPhysics from ${CMAKE_SOURCE_DIR}/../JoltPhysics")

    FetchContent_Declare(
        JoltPhysics
        SOURCE_DIR "${CMAKE_SOURCE_DIR}/../JoltPhysics"
        SOURCE_SUBDIR "Build"
    )
else()
    message(STATUS "Local Jolt not found, download from remote")

    FetchContent_Declare(
        JoltPhysics
        GIT_REPOSITORY "https://github.com/jrouwe/JoltPhysics"
        GIT_TAG v5.6.0
        SOURCE_SUBDIR "Build"
    )
endif()

FetchContent_MakeAvailable(JoltPhysics)

if(JOLTC_BUILD_SHARED_LIBS)
    set(CMAKE_CXX_VISIBILITY_PRESET hidden)

    set(JOLTC_LIB_TYPE SHARED)
else()
    set(JOLTC_LIB_TYPE STATIC)
endif()

set(JOLTC_SRC_FILES
    ${CMAKE_SOURCE_DIR}/JoltC_ABITests.cpp
    ${CMAKE_SOURCE_DIR}/JoltC_Core.cpp
    ${CMAKE_SOURCE_DIR}/JoltC_Collision.cpp
    ${CMAKE_SOURCE_DIR}/JoltC_Body.cpp
    ${CMAKE_SOURCE_DIR}/JoltC_System.cpp
    ${CMAKE_SOURCE_DIR}/JoltC_Shapes.cpp
    ${CMAKE_SOURCE_DIR}/JoltC_DebugRenderer.cpp
)

add_library(JoltC ${JOLTC_LIB_TYPE} ${JOLTC_SRC_FILES})

if (MSVC)
    # 64 bit architecture
    set(CMAKE_VS_PLATFORM_TOOLSET_HOST_ARCHITECTURE "x64")

    # Set runtime library
    if (USE_STATIC_MSVC_RUNTIME_LIBRARY)
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    endif()

    # Set general compiler flags
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Zc:__cplusplus /Gm- /MP /nologo /diagnostics:classic /FC /fp:except- /Zc:inline")

    # Enable warnings
    if (ENABLE_ALL_WARNINGS)
        # Use W4 instead of Wall because it warns about bullshit things
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4 /WX")
    endif()

    # Optionally generate debug symbols
    if (GENERATE_DEBUG_SYMBOLS)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Zi")
    endif()

    if(NOT CPP_RTTI_ENABLED)
        # Set compiler flag for disabling RTTI
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /GR-")
    else()
        # Set compiler flag for enabling RTTI
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /GR")
    endif()

    if (NOT CPP_EXCEPTIONS_ENABLED)
        # Remove any existing compiler flag that enables exceptions
        string(REPLACE "/EHsc" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})

        # Disable warning about STL and compiler-generated types using noexcept when exceptions are disabled
        # Disable warning about C++ exception handler being used, but unwind semantics are not enabled
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4577 /wd4530")
    else()
        # Enable exceptions
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHsc")
    endif()

    # Set compiler flags for various configurations
    if (OVERRIDE_CXX_FLAGS)
        set(CMAKE_CXX_FLAGS_DEBUG "/GS /Od /Ob0 /RTC1")
        set(CMAKE_CXX_FLAGS_RELEASE "/GS- /Gy /O2 /Oi /Ot")
    endif()
    set(CMAKE_CXX_FLAGS_DISTRIBUTION "${CMAKE_CXX_FLAGS_RELEASE}")
    set(CMAKE_CXX_FLAGS_RELEASEASAN "-fsanitize=address /Od")
    set(CMAKE_CXX_FLAGS_RELEASEUBSAN "-fsanitize=undefined,implicit-conversion,float-divide-by-zero,local-bounds -fno-sanitize-recover=all")
    set(CMAKE_CXX_FLAGS_RELEASETSAN "${CMAKE_CXX_FLAGS_RELEASE} -fsanitize=thread")
    set(CMAKE_CXX_FLAGS_RELEASECOVERAGE "-fprofile-instr-generate -fcoverage-mapping")

    # Set linker flags
    set(CMAKE_EXE_LINKER_FLAGS "/ignore:4221")
    if (GENERATE_DEBUG_SYMBOLS)
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /DEBUG")
    endif()
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        if (CROSS_PLATFORM_DETERMINISTIC)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /fp:precise")
        else()
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /fp:fast") # Clang doesn't use fast math because it cannot be turned off inside a single compilation unit
        endif()
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        # Fill in the path to the asan libraries
        string(REGEX MATCH "^[0-9]+" CLANG_VERSION_MAJOR "${CMAKE_CXX_COMPILER_VERSION}")
        set(CLANG_LIB_PATH "\"$(VSInstallDir)\\VC\\Tools\\Llvm\\x64\\lib\\clang\\${CLANG_VERSION_MAJOR}\\lib\\windows\"")

        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /showFilenames")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Qunused-arguments") # Clang emits warnings about unused arguments such as /MP and /GL
        set(CMAKE_EXE_LINKER_FLAGS_RELEASEASAN "/LIBPATH:${CLANG_LIB_PATH} clang_rt.asan_dynamic-x86_64.lib clang_rt.asan_dynamic_runtime_thunk-x86_64.lib")
        set(CMAKE_EXE_LINKER_FLAGS_RELEASEUBSAN "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /LIBPATH:${CLANG_LIB_PATH}")
        set(CMAKE_EXE_LINKER_FLAGS_RELEASETSAN "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /LIBPATH:${CLANG_LIB_PATH}")
        set(CMAKE_EXE_LINKER_FLAGS_RELEASECOVERAGE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /LIBPATH:${CLANG_LIB_PATH}")
    endif()
else()
    # Enable warnings
    if (ENABLE_ALL_WARNINGS)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")
    endif()

    if (NOT CPP_RTTI_ENABLED)
        # Set compiler flag for disabling RTTI
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
    else()
        # Set compiler flag for enabling RTTI
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -frtti")
    endif()

    if (NOT CPP_EXCEPTIONS_ENABLED)
        # Set compiler flag for disabling exception-handling
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions")
    else()
        # Set compiler flag for enabling exception-handling
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fexceptions")
    endif()
endif()

if(JOLTC_BUILD_SHARED_LIBS)
    target_compile_definitions(JoltC PUBLIC JOLTC_SHARED_LIBRARY)
    target_compile_definitions(JoltC PRIVATE JOLTC_BUILD_SHARED_LIBRARY)
endif()

target_include_directories(JoltC PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

if(JOLTC_BUILD_COMBINED_SHARED_LIBS)
    target_link_libraries(JoltC PUBLIC Jolt)

    set_target_properties(JoltC PROPERTIES
        CXX_VISIBILITY_PRESET hidden
        VISIBILITY_INLINES_HIDDEN ON
    )
else()
    target_link_libraries(JoltC PUBLIC Jolt)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/Examples/HelloWorld.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/Generator/Generator.cmake)
