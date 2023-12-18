#!/bin/sh
# 烧录daplink的bootloader

openocd \
-s /usr/share/openocd/scripts \
-f ./cfg/openocdconfig/stlink_stm32f103c8t6.cfg \
-c "program build/stm32f103xb_bl.elf verify reset exit"