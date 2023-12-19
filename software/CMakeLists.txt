cmake_minimum_required(VERSION 3.25)
project(software)

# 使用openocd烧录
find_program(my_openocd openocd)
if (${my_openocd} STREQUAL "my_openocd-NOTFOUND")
    message(FATAL_ERROR "缺少openocd, as ${my_openocd}")
endif ()

# DAPLink源码工程
add_subdirectory(my_daplink_v1)

# my_demo源码
add_subdirectory(my_demo)
