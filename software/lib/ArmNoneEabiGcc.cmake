# 只负责下载编译器 不要碰CMAKE_C_COMPILER 防止污染全局
include(FetchContent)

set(ARM_GCC_VERSION "10.3-2021.10")
set(ARM_GCC_NAME_PREFIX "gcc-arm-none-eabi-${ARM_GCC_VERSION}")
if(APPLE)
    set(ARM_GCC_NAME "${ARM_GCC_NAME_PREFIX}-mac")
elseif (UNIX)
    set(ARM_GCC_NAME "${ARM_GCC_NAME_PREFIX}-x86_64-linux")
else ()
    message(FATAL_ERROR "不知道当前平台对应的arm-none-eabi-gcc下载路径")
endif()
set(ARM_GCC_ROOT "${CMAKE_BINARY_DIR}/${ARM_GCC_NAME_PREFIX}")
set(ARM_GCC_BIN  "${ARM_GCC_ROOT}/bin")

# 下载工具链
# https://developer.arm.com/-/media/files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-mac.tar.bz2
# https://developer.arm.com/-/media/files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2
set(ARM_GCC_URL "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${ARM_GCC_VERSION}/${ARM_GCC_NAME}.tar.bz2")

if(NOT EXISTS "${ARM_GCC_BIN}")
    if(NOT EXISTS "${CMAKE_BINARY_DIR}/${ARM_GCC_NAME}.tar.bz2")
        message(STATUS "Downloading ARM toolchain ${ARM_GCC_VERSION}...")
        file(DOWNLOAD "${ARM_GCC_URL}" "${CMAKE_BINARY_DIR}/${ARM_GCC_NAME}.tar.bz2" SHOW_PROGRESS)
    endif ()
    message(STATUS "Extracting ARM toolchain...")
    execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar zxvf "${CMAKE_BINARY_DIR}/${ARM_GCC_NAME}.tar.bz2"
            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
            RESULT_VARIABLE TAR_RET
    )
    if(NOT TAR_RET EQUAL 0)
        message(FATAL_ERROR "ARM GCC extract failed")
    endif()
endif()
# 只导出变量 不碰CMAKE_C_COMPILER
set(ARM_NONE_EABI_GCC_ROOT "${ARM_GCC_ROOT}")
set(ARM_NONE_EABI_GCC_BIN "${ARM_GCC_BIN}")
