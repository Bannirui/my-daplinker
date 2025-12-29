#!/bin/sh

openocd \
-c "set CPUTAPID 0" \
-f /usr/share/openocd/scripts/interface/stlink.cfg \
-c "transport select hla_swd" \
-f /usr/share/openocd/scripts/target/stm32f1x.cfg \
-c "program build/my_demo.bin" \
-c "sleep 200" \
-c "reset run" \
-c exit