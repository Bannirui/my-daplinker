# 只负责下载编译器 不要碰CMAKE_C_COMPILER 防止污染全局
include(FetchContent)

set(ARM_GCC_NAME_PREFIX "gcc-arm-none-eabi-${ARM_GCC_VERSION}")
set(ARM_GCC_NAME "${ARM_GCC_NAME_PREFIX}-${ARM_NONE_EABI_DOWNLOAD_SUFIX}")
set(ARM_GCC_ROOT "${CMAKE_BINARY_DIR}/${ARM_GCC_NAME_PREFIX}")
set(ARM_GCC_BIN  "${ARM_GCC_ROOT}/bin")

# 下载工具链
# https://developer.arm.com/-/media/files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-mac.tar.bz2
# https://developer.arm.com/-/media/files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2
set(ARM_GCC_URL "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${ARM_GCC_VERSION}/${ARM_GCC_NAME}.tar.bz2")
set(ARM_GCC_ARCHIVE "${CMAKE_BINARY_DIR}/${ARM_GCC_NAME}.tar.bz2")

if(NOT EXISTS "${ARM_GCC_ARCHIVE}")
    message(STATUS "Downloading ARM GCC via proxy")

    execute_process(
            COMMAND
            ${CMAKE_COMMAND} -E env
            http_proxy=${CMAKE_HTTP_PROXY}
            https_proxy=${CMAKE_HTTPS_PROXY}
            curl -L
            --progress-bar
            -o ${ARM_GCC_ARCHIVE}
            ${ARM_GCC_URL}
            RESULT_VARIABLE ret
    )

    if(NOT ret EQUAL 0)
        message(FATAL_ERROR "ARM GCC download failed")
    endif()
endif()

if(NOT EXISTS "${ARM_GCC_BIN}")
    message(STATUS "Extracting ARM GCC")
    execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xf ${ARM_GCC_ARCHIVE}
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )
endif()

# 只导出变量 不碰CMAKE_C_COMPILER
set(ARM_NONE_EABI_GCC_BIN "${ARM_GCC_BIN}")
