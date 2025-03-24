#!/bin/sh
# 烧录DAPLink的bootloader
openocd \
-c "set CPUTAPID 0x2ba01477" \
-f /usr/local/Cellar/open-ocd/0.12.0_1/share/openocd/scripts/interface/stlink.cfg \
-c "transport select hla_swd" \
-f /usr/local/Cellar/open-ocd/0.12.0_1/share/openocd/scripts/target/stm32f1x.cfg \
-c "init" \
-c "reset halt" \
-c "stm32f1x unlock 0" \
-c "reset halt" \
-c "flash erase_address 0x08002000 0x2000" \
-c "flash write_image erase ./build/stm32f103xb_bl.bin 0x08002000" \
-c "verify_image ./build/stm32f103xb_bl.bin 0x08002000" \
-c "reset run" \
-c "shutdown"