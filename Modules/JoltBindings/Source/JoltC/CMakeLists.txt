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
    set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
    set(CMAKE_POSITION_INDEPENDENT_CODE ON)
    set(JOLTC_BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)
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
	# Enable warnings
	if (ENABLE_ALL_WARNINGS)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Wall /WX")
	endif()
else()
	# Enable warnings
	if (ENABLE_ALL_WARNINGS)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")
	endif()
endif()

if(NOT CPP_RTTI_ENABLED)
    target_compile_options(JoltC PRIVATE
        $<$<CXX_COMPILER_ID:MSVC>:/GR->
        $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-fno-rtti>
    )
endif()

if (NOT CPP_EXCEPTIONS_ENABLED)
    target_compile_options(JoltC PRIVATE
        $<$<CXX_COMPILER_ID:MSVC>:/EHs-c->
        $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-fno-exceptions>
    )
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
