#!/bin/sh
set -e

openocd -f openocd.cfg \
  -c "init; reset halt; stm32f1x mass_erase 0; exit"
