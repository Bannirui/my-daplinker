cmake_minimum_required(VERSION 3.25)

option(USE_PROXY "Enable proxy for FetchContent for file download" ON)
if (USE_PROXY)
    message(STATUS "Proxy is enabled")
    set(ENV{http_proxy} "http://127.0.0.1:7890")
    set(ENV{https_proxy} "http://127.0.0.1:7890")
    set(CMAKE_TLS_VERIFY OFF)
    set(CMAKE_DOWNLOAD_AGENT "curl")
endif ()

# 项目信息
project(diy-daplink
        VERSION 1.0
        LANGUAGES NONE
)

# dep
set(lib_directory ${CMAKE_SOURCE_DIR}/lib)
include(${lib_directory}/progen.cmake)
include(${lib_directory}/ArmNoneEabiGcc.cmake)
include(${lib_directory}/DAPLink.cmake)

# Optional: set default target to daplink-build
add_custom_target(all-daplink-build
        DEPENDS daplink-bl daplink-if
        COMMENT "Build all DAPLink targets"
)