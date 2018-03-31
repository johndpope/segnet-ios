cmake_minimum_required(VERSION 2.8.7)
if(POLICY CMP0046)
    cmake_policy(SET CMP0046 NEW)
endif()
if(POLICY CMP0054)
    cmake_policy(SET CMP0054 NEW)
endif()

set(CAFFE_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories(${CAFFE_INCLUDE_DIRS})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

add_definitions(-DCPU_ONLY)
add_definitions(-DUSE_NEON_MATH)

include(./cmake/Utils.cmake)
include(./cmake/Misc.cmake)
include(./cmake/Targets.cmake)

if(NOT MSVC)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-sign-compare")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Wno-sign-compare")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -std=c++0x")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -std=c++0x")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fembed-bitcode")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fembed-bitcode")
endif()

list(INSERT CMAKE_FIND_ROOT_PATH 0 ${CMAKE_SOURCE_DIR}/third_party/ios-protobuf)

include(./cmake/ProtoBuf.cmake)
include(./cmake/Modules/FindvecLib.cmake)

if(VECLIB_FOUND)
    include_directories(${vecLib_INCLUDE_DIR})
    list(APPEND Caffe_LINKER_LIBS ${vecLib_LINKER_LIBS})
else()
    MESSAGE(FATAL_ERROR "BLAS (VecLib/OpenBLAS/Atlas) library not found.")
endif()

caffe_set_caffe_link()

add_subdirectory(src/caffe)

if(TOOLS)
    add_subdirectory(tools)
endif()
