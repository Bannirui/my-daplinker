#!/bin/bash
#Author: dingrui
#Time: 2023-12-18 15:36:58
#Name: configure.sh
#Version: V1.0
#Description: This is a protuction script.

# git_subtree
# ON-每次编译都去pull最新的daplink代码
# OFF-编译的时候不去pull最新的daplink代码 就用本地版本
cmake \
    -DCMAKE_C_COMPILER_FORCED=ON \
    -DCMAKE_CXX_COMPILER_FORCED=ON \
    -Dgit_subtree=ON \
    -S . \
    -B build

