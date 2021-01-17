cmake_minimum_required(VERSION 3.10)
project(glm.clawed)

set(LIBRARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/glm)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if (MSVC)
    add_compile_options(/O2)
    if (NOT ANDROID_ABI)
      add_compile_options(/arch:AVX)
    endif()
else()
    add_compile_options(-O2)
    if (NOT ANDROID_ABI)
      set(TARGET_TRIPLE x86_64-pc-linux-gnu)
      add_compile_options(-mavx)
    else()
      set(TARGET_TRIPLE aarch64-linux-android)
      add_compile_options(-mfpu=neon)
    endif()
endif()

add_subdirectory("${LIBRARY_DIR}")
option(BUILD_STATIC_LIBS ON)
option(BUILD_SHARED_LIBS OFF)

#
# MAIN
#
set(TARGET glm.clawed)
set(ADAPTER "adapter.${TARGET_TRIPLE}.cxx")

add_library(${TARGET} SHARED ${ADAPTER})
set_source_files_properties(${ADAPTER} PROPERTIES LANGUAGE CXX)

target_include_directories(${TARGET}
  PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../"
  PRIVATE "${LIBRARY_DIR}/")

target_link_libraries(${TARGET}
  PRIVATE glm)
