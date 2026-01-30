# 依赖FetchContent管理三方库
include(FetchContent)

FetchContent_Declare(
        daplink
        GIT_REPOSITORY https://github.com/ARMmbed/DAPLink.git
        GIT_TAG main
)
# 下载依赖的源码 不加入主工程
FetchContent_MakeAvailable(daplink)

# ========== patch DAPLink python ==========
add_custom_target(pre_build_script
        WORKING_DIRECTORY ${daplink_SOURCE_DIR}
        COMMAND ${MY_PYTHON} ${CMAKE_SOURCE_DIR}/lib/pre_build_script.py
        COMMENT "Patch DAPLink pre_build_script.py"
)
add_custom_target(post_build_script_gcc
        WORKING_DIRECTORY ${daplink_SOURCE_DIR}
        COMMAND ${MY_PYTHON} ${CMAKE_SOURCE_DIR}/lib/post_build_script_gcc.py
        COMMENT "Patch DAPLink post_build_script_gcc.py"
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

set(DAPLINK_BUILD_OUTPUT_DIR "${daplink_SOURCE_DIR}/projectfiles/cmake_gcc_arm")