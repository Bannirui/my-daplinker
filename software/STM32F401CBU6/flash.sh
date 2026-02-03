#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

TARGET_NAME="STM32F401CBU6.elf"
TARGET_PATH="$SCRIPT_DIR/build/Debug/$TARGET_NAME"

if [ ! -f "$TARGET_PATH" ]; then
    echo "ERROR: $TARGET_NAME ELF not found:"
    exit 1
fi

echo "the target is: $TARGET_PATH"

openocd \
  -s /usr/share/openocd/scripts \
  -f openocd.cfg \
  -c "program $TARGET_PATH verify reset exit"