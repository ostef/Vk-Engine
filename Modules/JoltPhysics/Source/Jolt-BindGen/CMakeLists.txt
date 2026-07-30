cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(Jolt-BindGen LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD          17)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS        OFF)

find_package(LLVM REQUIRED CONFIG
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
)

if(LLVM_VERSION_MAJOR LESS 20)
    message(FATAL_ERROR
        "LLVM >= 20 required, but found LLVM ${LLVM_PACKAGE_VERSION} "
        "(LLVM_DIR=${LLVM_DIR}).")
endif()

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "LLVM include dirs: ${LLVM_INCLUDE_DIRS}")
message(STATUS "LLVM library dirs: ${LLVM_LIBRARY_DIRS}")

add_definitions(${LLVM_DEFINITIONS})

find_library(LIBCLANG_LIBRARY
    NAMES clang libclang
    HINTS ${LLVM_LIBRARY_DIRS}
    DOC "Path to the libclang shared library"
)

if(NOT LIBCLANG_LIBRARY)
    message(FATAL_ERROR
        "libclang not found under ${LLVM_LIBRARY_DIRS}. "
        "Pass -DLLVM_DIR=/path/to/llvm-20/lib/cmake/llvm to help CMake find it.")
endif()

message(STATUS "Found libclang: ${LIBCLANG_LIBRARY}")

set(JOLT_BINDGEN_SRC_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/database.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/parse.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/jai.cpp
)

add_executable(Jolt-BindGen ${JOLT_BINDGEN_SRC_FILES})

target_include_directories(Jolt-BindGen PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(Jolt-BindGen PRIVATE ${LLVM_INCLUDE_DIRS})
target_link_libraries(Jolt-BindGen PRIVATE ${LIBCLANG_LIBRARY})
