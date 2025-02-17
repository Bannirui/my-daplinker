cmake_minimum_required(VERSION 3.25)
project(my_daplink_v1)

# 检查py支持
find_package(Python3 REQUIRED)

if (NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/venv")
    execute_process(COMMAND python3 -m venv "${CMAKE_CURRENT_SOURCE_DIR}/venv")
endif ()

# py虚拟环境的progen包
set(my_progen "${CMAKE_CURRENT_SOURCE_DIR}/venv/bin/progen")
if (NOT EXISTS ${my_progen})
    # 安装依赖
    execute_process(
            COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/venv/bin/pip install -r ${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt --upgrade
            TIMEOUT 300
    )
endif ()

# arm-none-eabi-gcc支持
# https://github.com/ARMmbed/DAPLink/blob/main/docs/DEVELOPERS-GUIDE.md
# 官方文档特地指出arm交叉编译器要用10.x版本的 我试过了13.x的会编译报错找不到头文件
# 因此要对arm-none-eabi版本进行校验
find_program(my_arm_none_eabi_gcc arm-none-eabi-gcc)
if (${my_arm_none_eabi_gcc} STREQUAL "my-arm-none-eabi-gcc-NOTFOUND")
    message(FATAL_ERROR "缺少arm交叉编译器, as ${my_arm_none_eabi_gcc} ")
endif ()

# 检测编译器版本号
set(arm_none_eabi_required 10.3)
execute_process(
        COMMAND sh -c "${my_arm_none_eabi_gcc} --version"
        OUTPUT_VARIABLE arm_none_eabi_succ
        ERROR_VARIABLE arm_none_eabi_err
        OUTPUT_STRIP_TRAILING_WHITESPACE
)

if (arm_none_eabi_err)
    message(FATAL_ERROR 检测arm-none-eabi版本号出错, ${arm_none_eabi_err})
endif ()

if (NOT arm_none_eabi_succ)
    message(FATAL_ERROR 没有检测到arm-none-eabi版本信息)
endif ()

# 字符串处理提取版本号 找到x.x的字符串
string(REGEX MATCH "([0-9]+\.[0-9]+)" arm_none_eabi_ver ${arm_none_eabi_succ})
if (NOT ${arm_none_eabi_ver} GREATER_EQUAL ${arm_none_eabi_required})
    message(FATAL_ERROR "arm-none-eabi版本号不符合要求:${arm_none_eabi_required}")
endif ()
message(STATUS "arm-none-eabi版本${arm_none_eabi_ver}")

# 编译bootloader
# progen generate -t make_gcc_arm -p stm32f103xb_bl -b
add_custom_command(
        OUTPUT compile_bl
        DEPENDS ${my_progen}
        COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR} && source ./venv/bin/activate && progen generate -t make_gcc_arm -p stm32f103xb_bl -b
        COMMENT 编译daplink的bootloader
)

# 编译固件
# progen generate -t make_gcc_arm -p stm32f103xb_if -b
add_custom_command(
        OUTPUT compile_if
        DEPENDS ${my_progen}
        COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR} && source ./venv/bin/activate && progen generate -t make_gcc_arm -p stm32f103xb_if -b
        COMMENT 编译daplink的固件
)

add_custom_target(
        compile_daplink
        ALL
        DEPENDS compile_bl compile_if
)

message(WARNING "切记修改一下py源码的timeout超时, ${CMAKE_CURRENT_SOURCE_DIR}/venv/lib/pythonx.x/site-packages/project_generator/commands/generate.py L70 建议值300s")