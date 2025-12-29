#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

TARGET_NAME="stm32f103xb_if.hex"
TARGET_PATH="$SCRIPT_DIR/../cmake-build-debug/_deps/daplink-src/projectfiles/cmake_gcc_arm/stm32f103xb_if/build/$TARGET_NAME"
cp -f "$TARGET_PATH" "$SCRIPT_DIR/"

if [ ! -f "$TARGET_PATH" ]; then
    echo "ERROR: bootloader ELF not found:"
    echo "  $TARGET_NAME"
    exit 1
fi

echo "the target is: $TARGET_NAME"

openocd \
  -s /usr/share/openocd/scripts \
  -f openocd.cfg \
  -c "program $TARGET_NAME verify reset exit"