set(cmake_ver 3.25)
cmake_minimum_required(VERSION ${cmake_ver})
project(my-daplinker)

# subtree代码
find_package(Git QUIET)
if (GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
    # UPDATE SUBMODULES AS NEEDED 默认不要更新submodule代码
    option(git_subtree "Check subtree during build" OFF)
    if (git_subtree)
        message(STATUS "subtree update")
            execute_process(
                COMMAND ${GIT_EXECUTABLE} subtree pull -P software/my_daplink_v1 git@github.com:Bannirui/DAPLink.git my_daplink_v1
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                RESULT_VARIABLE git_subtree_result)
        if (NOT git_subtree_result EQUAL "0")
            message(FATAL_ERROR "git subtree pull failed with ${git_subtree_result}, pls check submodules.")
        endif ()
    endif ()
endif ()

# 检查subtree代码是否download
if (NOT EXISTS "${PROJECT_SOURCE_DIR}/software/my_daplink_v1/projects.yaml")
    message(FATAL_ERROR "The DAPlink submodules was not downloaded! ${git_subtree} was turned off or failed. pls check.")
endif ()

add_subdirectory(software)