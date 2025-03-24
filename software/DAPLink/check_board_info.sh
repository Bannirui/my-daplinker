#!/bin/sh
# 查看板子flash布局
openocd \
-c "set CPUTAPID 0x2ba01477" \
-f /usr/local/Cellar/open-ocd/0.12.0_1/share/openocd/scripts/interface/stlink.cfg \
-c "transport select hla_swd" \
-f /usr/local/Cellar/open-ocd/0.12.0_1/share/openocd/scripts/target/stm32f1x.cfg \
-c "init" \
-c "reset halt" \
-c "flash info 0"
