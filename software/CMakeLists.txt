cmake_minimum_required(VERSION 3.25)

# 输出详细日志
set(CMAKE_VERBOSE_MAKEFILE ON)

# 项目信息
project(diy-daplink
        VERSION 1.0
        LANGUAGES NONE
)

# dep
set(lib_directory ${CMAKE_SOURCE_DIR}/cmake)
include(${lib_directory}/progen.cmake)
include(${lib_directory}/ArmNoneEabiGcc.cmake)
include(${lib_directory}/DAPLink.cmake)

set(BL_NAME stm32f103xb_bl.elf)
set(IF_NAME stm32f103xb_if.elf)
add_custom_target(copy_daplink
        COMMAND ${CMAKE_COMMAND} -E copy "${DAPLINK_BUILD_OUTPUT_DIR}/stm32f103xb_bl/build/${BL_NAME}" "${CMAKE_CURRENT_BINARY_DIR}/${BL_NAME}"
        COMMAND ${CMAKE_COMMAND} -E copy "${DAPLINK_BUILD_OUTPUT_DIR}/stm32f103xb_if/build/${IF_NAME}" "${CMAKE_CURRENT_BINARY_DIR}/${IF_NAME}"
        COMMENT "Copying DAPLink builds"
        DEPENDS stm32f103xb_bl stm32f103xb_if
)

# Optional: set default target to daplink-build
add_custom_target(all-daplink-build
        DEPENDS copy_daplink
        COMMENT "Build all DAPLink targets"
)