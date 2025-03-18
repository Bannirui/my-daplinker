#!/bin/sh

# is not able to compile a simple test program
# to avoid above err
cmake -DCMAKE_C_COMPILER_FORCED=ON -DCMAKE_CXX_COMPILER_FORCED=ON -S . -B build