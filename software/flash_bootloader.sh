#!/bin/sh
# 烧录DAPLink的bootloader

openocd \
-c "set CPUTAPID 0" \
-f /usr/local/Cellar/open-ocd/0.12.0_1/share/openocd/scripts/interface/stlink.cfg \
-c "transport select hla_swd" \
-f /usr/local/Cellar/open-ocd/0.12.0_1/share/openocd/scripts/target/stm32f1x.cfg \
-c "program ./DAPLink/build/stm32f103xb_bl.elf" \
-c "sleep 200" \
-c "reset run" \
-c exit
