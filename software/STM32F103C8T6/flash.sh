pyocd flash \
  -t stm31f103c8 \
  --frequency 99999 \
  --connect under-reset \
  --erase chip \
  build/Debug/STM32F103C8T6.elf
