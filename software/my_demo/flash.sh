#!/bin/sh

openocd \
-s /usr/local/Cellar/open-ocd/0.12.0_1/share/openocd/scripts \
-f openocd.cfg \
-c "program build/my_demo.elf" \
-c "sleep 200" \
-c "reset run" \
-c exit