# glad的代码生成依赖py和glad
find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(MY_VENV "${CMAKE_BINARY_DIR}/.venv")
if (WIN32)
    set(MY_PYTHON "${MY_VENV}/bin/python.exe")
else ()
    set(MY_PYTHON "${MY_VENV}/bin/python")
endif ()

# py虚拟环境
if(NOT EXISTS "${MY_PYTHON}")
    message(STATUS "Creating virtualenv at ${MY_VENV}")
    # 创建.venv
    execute_process(
        COMMAND ${Python3_EXECUTABLE} -m venv "${MY_VENV}"
        RESULT_VARIABLE VENV_CREATE_RESULT
    )

    if(NOT VENV_CREATE_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to create virtual environment at ${MY_VENV}")
    endif()
else()
    message(STATUS "Found existing virtualenv: ${MY_PYTHON}")
endif()

# 依赖FetchContent管理三方库
include(FetchContent)

FetchContent_Declare(
        daplink
        GIT_REPOSITORY https://github.com/Bannirui/DAPLink.git
        GIT_TAG a668f798700573c5a4fbc0db6186efed04ef9df2
)
# 下载依赖的源码
FetchContent_MakeAvailable(daplink)

# 检查progen命令
execute_process(
    COMMAND ${MY_PYTHON} -m progen --help
    RESULT_VARIABLE PROGEN_RET
    OUTPUT_QUIET
    ERROR_QUIET
)

if(NOT PROGEN_RET EQUAL 0)
    message(STATUS "Installing progen in venv...")
    # 安装progen到虚拟环境中
    execute_process(COMMAND ${MY_PYTHON} -m pip install --upgrade pip)
    execute_process(
        COMMAND ${MY_PYTHON} -m pip install -r ${daplink_SOURCE_DIR}/requirements.txt --timeout 60 -i https://pypi.tuna.tsinghua.edu.cn/simple
        RESULT_VARIABLE PROGEN_INSTALL_RET
        ERROR_VARIABLE PROGEN_INSTALL_ERR
    )
    if(NOT PROGEN_INSTALL_RET EQUAL 0)
        message(FATAL_ERROR "Failed to install progen in virtualenv:\n${PROGEN_INSTALL_ERR}")
    endif()
        message(STATUS "progen installed successfully in ${MY_VENV}")

        set(generate_src_path "${MY_VENV}/lib/python3.10/site-packages/project_generator/commands/generate.py")
        file(READ ${generate_src_path} FILE_CONTENTS)
        string(FIND "${FILE_CONTENTS}" "timeout=20.0" FOUND_INDEX)
        if (FOUND_INDEX EQUAL -1)
            message(STATUS "generate.py文件中超时时间不是20s 不需要修改")
        else()
            message(STATUS "generate.py文件中超时时间是20s")
            message(STATUS "修改py generate文件的timeout值为300 ${generate_src_path}")
            # 读取文件内容
            file(READ ${generate_src_path} FILE_CONTENTS)
            # 替换
            string(REPLACE "timeout=20.0" "timeout=300.0" FILE_CONTENTS "${FILE_CONTENTS}")
            # 写回文件
            file(WRITE ${generate_src_path} "${FILE_CONTENTS}")
        endif()
    else ()
        message(STATUS "progen already exist in ${MY_VENV}")
endif()

add_custom_target(daplink-build
        WORKING_DIRECTORY ${daplink_SOURCE_DIR}
        COMMAND bash -c "source ${MY_VENV}/bin/activate && python3 -m progen generate -t cmake_gcc_arm -o generator=make -p stm32f103xb_bl -b"
        COMMAND bash -c "source ${MY_VENV}/bin/activate && python3 -m progen generate -t cmake_gcc_arm -o generator=make -p stm32f103xb_if -b"
        COMMENT "Generate DAPLink bootloader and firmware"
)