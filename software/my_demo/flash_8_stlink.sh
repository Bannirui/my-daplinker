#!/bin/sh

openocd \
-c "set CPUTAPID 0" \
-f /usr/local/Cellar/open-ocd/0.12.0_1/share/openocd/scripts/interface/stlink.cfg \
-c "transport select hla_swd" \
-f /usr/local/Cellar/open-ocd/0.12.0_1/share/openocd/scripts/target/stm32f1x.cfg \
-c "program build/my_demo.elf" \
-c "sleep 200" \
-c "reset run" \
-c exit