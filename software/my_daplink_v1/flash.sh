#!/bin/sh
# 烧录daplink的bootloader

openocd \
-s /usr/share/openocd/scripts \
-f ./openocd.cfg \
-c "program ./projectfiles/make_gcc_arm/stm32f103xb_bl/build/stm32f103xb_bl.elf verify reset exit"
