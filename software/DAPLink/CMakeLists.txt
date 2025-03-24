cmake_minimum_required(VERSION 3.25)
project(DAPLink)

# 检查py支持
find_package(Python3 REQUIRED)

set(my_pyvenv "${CMAKE_CURRENT_SOURCE_DIR}/venv")
if (NOT EXISTS ${my_pyvenv})
    message(STATUS "不存在py虚拟环境 开始创建 ${my_pyvenv}")
    execute_process(COMMAND python3 -m venv "${my_pyvenv}")
else ()
    message(STATUS "已经存在py虚拟环境 ${my_pyvenv}")
endif ()

# py虚拟环境的progen包
set(my_progen "${my_pyvenv}/bin/progen")
if (NOT EXISTS ${my_progen})
    message(STATUS "不存在progen ${my_progen} 开始安装")
    # 安装依赖
    execute_process(
            COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/venv/bin/pip install -r ${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt --upgrade
            TIMEOUT 300
    )
else ()
    message(STATUS "已经存在progen ${my_progen}")
    set(generate_src "${my_pyvenv}/lib/python3.13/site-packages/project_generator/commands/generate.py")
    file(READ ${generate_src} FILE_CONTENTS)
    string(FIND "${FILE_CONTENTS}" "timeout=20.0" FOUND_INDEX)
    if (FOUND_INDEX EQUAL -1)
        message(STATUS "generate.py文件中超时时间不是20s 不需要修改")
    else()
        message(STATUS "generate.py文件中超时时间是20s")
        message(STATUS "修改py generate文件的timeout值为300 ${generate_src}")
        # 读取文件内容
        file(READ ${generate_src} FILE_CONTENTS)
        # 替换
        string(REPLACE "timeout=20.0" "timeout=300.0" FILE_CONTENTS "${FILE_CONTENTS}")
        # 写回文件
        file(WRITE ${generate_src} "${FILE_CONTENTS}")
    endif()
endif ()

# arm-none-eabi-gcc支持
# https://github.com/ARMmbed/DAPLink/blob/main/docs/DEVELOPERS-GUIDE.md
# 官方文档特地指出arm交叉编译器要用10.x版本的 我试过了13.x的会编译报错找不到头文件
# 因此要对arm-none-eabi版本进行校验
find_program(my_arm_none_eabi_gcc arm-none-eabi-gcc)
if (${my_arm_none_eabi_gcc} STREQUAL "my-arm-none-eabi-gcc-NOTFOUND")
    message(FATAL_ERROR "缺少arm交叉编译器, as ${my_arm_none_eabi_gcc} ")
else ()
    message(STATUS "找到arm交叉编译器 ${my_arm_none_eabi_gcc} ")
endif ()

# 检测编译器版本号
set(arm_none_eabi_required 10.3)
execute_process(
        COMMAND sh -c "arm-none-eabi-gcc --version"
        OUTPUT_VARIABLE arm_none_eabi_succ
        ERROR_VARIABLE arm_none_eabi_err
        OUTPUT_STRIP_TRAILING_WHITESPACE
)

if (arm_none_eabi_err)
    message(FATAL_ERROR "检测arm-none-eabi版本号出错, ${arm_none_eabi_err}")
endif ()

if (NOT arm_none_eabi_succ)
    message(FATAL_ERROR "没有检测到arm-none-eabi版本信息")
endif ()

# 字符串处理提取版本号 找到x.x的字符串
string(REGEX MATCH "([0-9]+\.[0-9]+)" arm_none_eabi_ver ${arm_none_eabi_succ})
if (NOT ${arm_none_eabi_ver} EQUAL ${arm_none_eabi_required})
    message(FATAL_ERROR "arm-none-eabi版本号不符合要求:${arm_none_eabi_required}")
endif ()
message(STATUS "arm-none-eabi版本符合要求 版本是${arm_none_eabi_ver}")

# 使用openocd烧录
find_program(my_openocd openocd)
if (${my_openocd} STREQUAL "my_openocd-NOTFOUND")
    message(FATAL_ERROR "缺少openocd, as ${my_openocd}")
else ()
    message(STATUS "存在openocd环境")
endif ()

# 编译bootloader
# make: progen generate -t make_gcc_arm -p stm32f103xb_bl -b
# cmake: (venv) $ progen generate -t cmake_gcc_arm -o generator=<generator> -p <project> -b
add_custom_command(
        OUTPUT compile_bl
        DEPENDS ${my_progen}
        COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR} && source ./venv/bin/activate && progen generate -t cmake_gcc_arm -o generator=make -p stm32f103xb_bl -b
        COMMENT 编译daplink的bootloader
)

# 编译固件
# make: progen generate -t make_gcc_arm -p stm32f103xb_if -b
# cmake: (venv) $ progen generate -t cmake_gcc_arm -o generator=<generator> -p <project> -b
add_custom_command(
        OUTPUT compile_if
        DEPENDS ${my_progen}
        COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR} && source ./venv/bin/activate && progen generate -t cmake_gcc_arm -o generator=make -p stm32f103xb_if -b
        COMMENT 编译daplink的固件
)

add_custom_target(
        compile_daplink
        ALL
        DEPENDS compile_bl compile_if
        COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/projectfiles/cmake_gcc_arm/stm32f103xb_bl/build/stm32f103xb_bl.bin" "${CMAKE_CURRENT_BINARY_DIR}/stm32f103xb_bl.bin"
        COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/projectfiles/cmake_gcc_arm/stm32f103xb_if/build/stm32f103xb_if.bin" "${CMAKE_CURRENT_BINARY_DIR}/stm32f103xb_if.bin"
)