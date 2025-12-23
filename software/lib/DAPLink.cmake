# 依赖FetchContent管理三方库
include(FetchContent)

FetchContent_Declare(
        daplink
        GIT_REPOSITORY https://github.com/Bannirui/DAPLink.git
        GIT_TAG a668f798700573c5a4fbc0db6186efed04ef9df2
)
# 下载依赖的源码 不加入主工程
FetchContent_MakeAvailable(daplink)

message(STATUS "progen路径${MY_PROGEN}")
message(STATUS "python路径${MY_PYTHON}")

# ========== patch DAPLink python shebang ==========
add_custom_target(pre_build_script
        WORKING_DIRECTORY ${daplink_SOURCE_DIR}
        COMMAND ${MY_PYTHON} ${CMAKE_SOURCE_DIR}/lib/pre_build_script.py
        COMMENT "Patch DAPLink pre_build_script.py shebang"
)
add_custom_target(post_build_script_gcc
        WORKING_DIRECTORY ${daplink_SOURCE_DIR}
        COMMAND ${MY_PYTHON} ${CMAKE_SOURCE_DIR}/lib/post_build_script_gcc.py
        COMMENT "Patch DAPLink post_build_script_gcc.py shebang"
)

# ========== Bootloader ==========
add_custom_target(daplink-bl
        WORKING_DIRECTORY ${daplink_SOURCE_DIR}
        COMMAND ${CMAKE_COMMAND} -E env
            PYTHON=${MY_PYTHON}
            PATH=${ARM_GCC_BIN}:${MY_VENV}/bin:$ENV{PATH}
            ${MY_PROGEN} generate -t cmake_gcc_arm -o generator=make -p stm32f103xb_bl -b
        DEPENDS pre_build_script post_build_script_gcc
        COMMENT "Build DAPLink bootloader"
)

# ========== Interface ==========
add_custom_target(daplink-if
        WORKING_DIRECTORY ${daplink_SOURCE_DIR}
        COMMAND ${CMAKE_COMMAND} -E env
            PYTHON=${MY_PYTHON}
            PATH=${ARM_GCC_BIN}:${MY_VENV}/bin:$ENV{PATH}
            ${MY_PROGEN} generate -t cmake_gcc_arm -o generator=make -p stm32f103xb_if -b
        DEPENDS pre_build_script post_build_script_gcc
        COMMENT "Build DAPLink interface"
)
