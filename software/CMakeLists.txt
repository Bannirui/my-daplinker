cmake_minimum_required(VERSION 3.25)
project(software)

# DAPLink源码工程
add_subdirectory(my_daplink_v1)

#[[
编译好的文件移动位置
要移动的文件
]]
# 编译好的daplink bootloader
set(daplink_bootloader ${CMAKE_CURRENT_SOURCE_DIR}/my_daplink_v1/projectfiles/make_gcc_arm/stm32f103xb_bl/build/stm32f103xb_bl.elf)
# 编译好的daplink 固件
set(daplink_if ${CMAKE_CURRENT_SOURCE_DIR}/my_daplink_v1/projectfiles/make_gcc_arm/stm32f103xb_if/build/stm32f103xb_if.elf)
add_custom_command(
        OUTPUT mv
        DEPENDS ${daplink_bootloader} ${daplink_if}
        COMMAND ${CMAKE_COMMAND} -E copy ${daplink_bootloader} ${CMAKE_CURRENT_BINARY_DIR}/stm32f103xb_bl.elf
        COMMAND ${CMAKE_COMMAND} -E copy ${daplink_if} ${CMAKE_CURRENT_BINARY_DIR}/stm32f103xb_if.elf
)

add_custom_target(
        ${PROJECT_NAME}
        ALL
        DEPENDS mv
)

# 使用openocd烧录
find_program(my_openocd openocd)
if (${my_openocd} STREQUAL "my_openocd-NOTFOUND")
    message(FATAL_ERROR "缺少openocd, as ${my_openocd}")
endif ()