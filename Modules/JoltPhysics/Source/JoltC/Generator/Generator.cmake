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

set(GENERATOR_SRC_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/Generator/main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Generator/core.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Generator/database.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Generator/parse.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Generator/jai.cpp
)

add_executable(Generator ${GENERATOR_SRC_FILES})
target_include_directories(Generator PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/Generator)
target_include_directories(Generator PRIVATE ${LLVM_INCLUDE_DIRS})
target_link_libraries(Generator PRIVATE ${LIBCLANG_LIBRARY})
