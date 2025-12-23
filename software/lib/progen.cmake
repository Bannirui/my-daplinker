# 编译DAPLink需要使用progen 这是python的包 创建venv隔离环境
find_package(Python3 REQUIRED COMPONENTS Interpreter)
# 在DAPLink.cmake中也要用这个路径执行py虚拟环境
set(MY_VENV "${CMAKE_BINARY_DIR}/.venv")
if (WIN32)
    set(MY_PYTHON "${MY_VENV}/Scripts/python.exe")
    set(MY_PROGEN "${MY_VENV}/Scripts/progen.exe")
else ()
    set(MY_PYTHON "${MY_VENV}/bin/python")
    set(MY_PROGEN "${MY_VENV}/bin/progen")
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

# 检查progen命令
execute_process(
        COMMAND bash -c "source ${MY_VENV}/bin/activate && progen --version"
        RESULT_VARIABLE PROGEN_RET
        OUTPUT_QUIET
        ERROR_QUIET
)

if(NOT PROGEN_RET EQUAL 0)
    message(STATUS "Installing progen in venv...")
    # 安装progen到虚拟环境中
    execute_process(COMMAND ${MY_PYTHON} -m pip install --upgrade pip)
    execute_process(
            COMMAND ${MY_PYTHON} -m pip install --upgrade pip setuptools wheel --timeout 60 -i https://pypi.tuna.tsinghua.edu.cn/simple
            COMMAND ${MY_PYTHON} -m pip install -r ${CMAKE_CURRENT_LIST_DIR}/requirements.txt --timeout 60 -i https://pypi.tuna.tsinghua.edu.cn/simple
            RESULT_VARIABLE PROGEN_INSTALL_RET
            ERROR_VARIABLE PROGEN_INSTALL_ERR
    )
    if(NOT PROGEN_INSTALL_RET EQUAL 0)
        message(FATAL_ERROR "Failed to install progen in virtualenv:\n${PROGEN_INSTALL_ERR}")
    endif()
    message(STATUS "progen installed successfully in ${MY_VENV}")
    # python包progen的源码
    set(generate_src_path "${MY_VENV}/lib/python${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}/site-packages/project_generator/commands/generate.py")
    if(EXISTS "${generate_src_path}")
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
    endif()
else ()
    message(STATUS "progen already exist in ${MY_VENV}")
endif()

set(MY_VENV "${MY_VENV}")
set(MY_PYTHON "${MY_PYTHON}")
set(MY_PROGEN "${MY_PROGEN}")