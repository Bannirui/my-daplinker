pyocd flash \
  -t stm32f103c8 \
  --frequency 100000 \
  --connect under-reset \
  --erase chip \
  build/linux-gcc-debug/stm32f103xb_bl.elf
