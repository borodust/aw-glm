cmake_minimum_required(VERSION 3.10)
project(glm.clawed)

set(LIBRARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/glm)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_STANDARD 17)

# setup rpath
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_INSTALL_RPATH "$\{ORIGIN\}")

if (MSVC)
    set(TARGET_TRIPLE x86_64-w64-mingw32)

    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
      set(CMAKE_MSVC_RUNTIME_LIBRARY MultiThreadedDebugDLL)
    elseif()
      set(CMAKE_MSVC_RUNTIME_LIBRARY MultiThreadedDLL)
    endif()

    if (NOT ANDROID_ABI)
      add_compile_options(/arch:AVX)
    endif()
else()
    add_compile_options(-O2)
    if (NOT ANDROID_ABI)
      set(TARGET_TRIPLE x86_64-pc-linux-gnu)
      add_compile_options(-mavx2)
      option(GLM_ENABLE_SIMD_AVX2 ON)
    else()
      set(TARGET_TRIPLE aarch64-linux-android)
      add_compile_options(-mfpu=neon)
      option(GLM_ENABLE_SIMD_NEON ON)
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
  PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/../"
  PUBLIC "${LIBRARY_DIR}/")

target_link_libraries(${TARGET}
  PUBLIC glm)
