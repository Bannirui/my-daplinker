#!/bin/sh
# daplink固件升级之后
# 通过daplink烧录程序

openocd \
-s /usr/share/openocd/scripts \
-f ./cfg/openocdconfig/daplink_stm32f103c8t6.cfg \
-c "program ./build/software/my_demo/my_demo.elf verify reset exit"
