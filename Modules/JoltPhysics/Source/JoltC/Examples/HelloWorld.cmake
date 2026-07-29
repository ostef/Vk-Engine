set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_executable(HelloWorld ${CMAKE_CURRENT_SOURCE_DIR}/Examples/HelloWorld.c)
target_include_directories(HelloWorld PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/Examples)
target_link_libraries(HelloWorld PUBLIC JoltC)
