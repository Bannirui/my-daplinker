#!/bin/sh

cmake \
  -DCMAKE_C_COMPILER_FORCED=ON \
  -DCMAKE_CXX_COMPILER_FORCED=ON \
  -S . \
  -B build