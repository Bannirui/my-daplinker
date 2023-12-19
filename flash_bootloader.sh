#!/bin/sh
# 烧录daplink的bootloader

openocd \
-s /usr/share/openocd/scripts \
-f ./cfg/openocdconfig/stlink_stm32f103c8t6.cfg \
-c "program ./software/my_daplink_v1/projectfiles/make_gcc_arm/stm32f103xb_bl/build/stm32f103xb_bl.elf verify reset exit"
