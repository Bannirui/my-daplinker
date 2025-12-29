#!/bin/sh

openocd \
-s /usr/share/openocd/scripts \
-f openocd.cfg \
-c "program build/my_demo.elf" \
-c "sleep 200" \
-c "reset run" \
-c exit