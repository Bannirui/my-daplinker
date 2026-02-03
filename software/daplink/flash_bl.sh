#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

TARGET_NAME="stm32f103xb_bl.elf"
TARGET_PATH="$SCRIPT_DIR/../build/linux-gcc-debug/$TARGET_NAME"

if [ ! -f "$TARGET_PATH" ]; then
    echo "ERROR: $TARGET_NAME ELF not found:"
    exit 1
fi

echo "the target is: $TARGET_PATH"

openocd \
  -s /usr/share/openocd/scripts \
  -f openocd.cfg \
  -c "init" \
  -c "reset halt" \
  -c "program $TARGET_PATH verify reset exit"