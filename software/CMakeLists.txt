cmake_minimum_required(VERSION 3.25)

option(USE_PROXY "Enable proxy for FetchContent for file download" ON)
if (USE_PROXY)
    message(STATUS "Proxy is enabled")
    set(ENV{http_proxy} "http://127.0.0.1:7890")
    set(ENV{https_proxy} "http://127.0.0.1:7890")
    set(CMAKE_TLS_VERIFY OFF)
    set(CMAKE_DOWNLOAD_AGENT "curl")
endif ()

# 输出详细日志
set(CMAKE_VERBOSE_MAKEFILE ON)

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

add_custom_target(copy_daplink
        COMMAND ${CMAKE_COMMAND} -E copy "${DAPLINK_BUILD_OUTPUT_DIR}/stm32f103xb_bl/build/stm32f103xb_bl_crc.bin" "${CMAKE_CURRENT_BINARY_DIR}/stm32f103xb_bl_crc.bin"
        COMMAND ${CMAKE_COMMAND} -E copy "${DAPLINK_BUILD_OUTPUT_DIR}/stm32f103xb_if/build/stm32f103xb_if_crc.bin" "${CMAKE_CURRENT_BINARY_DIR}/stm32f103xb_if_crc.bin"
        COMMENT "Copying DAPLink builds"
        DEPENDS daplink-bl daplink-if
)

# Optional: set default target to daplink-build
add_custom_target(all-daplink-build
        DEPENDS copy_daplink
        COMMENT "Build all DAPLink targets"
)