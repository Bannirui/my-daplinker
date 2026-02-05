pyocd flash \
  -t stm32f401cb \
  --frequency 100000 \
  --connect under-reset \
  --erase chip \
  build/Debug/STM32F401CBU6.elf
