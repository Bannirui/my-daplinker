#!/bin/sh

openocd \
-c "set CPUTAPID 0" \
-f /usr/local/Cellar/open-ocd/0.12.0_1/share/openocd/scripts/interface/cmsis-dap.cfg \
-c "transport select swd" \
-f /usr/local/Cellar/open-ocd/0.12.0_1/share/openocd/scripts/target/stm32f1x.cfg \
-c "program build/my_demo.elf" \
-c "sleep 200" \
-c "reset run" \
-c exit
