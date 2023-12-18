业务代码
---

该业务代码是

- 通过Clion创建的嵌入式项目
- 之后通过STM32CubeMX加载该项目进行信息更新并保存
- 最后更新CMakeLists文件使之能够`add_subdirectory`到父级中
- 在顶层项目根目录下通过cmake维护整个软件工程

### 问题点

- 业务代码逻辑很简单就是设置led2闪烁，这样醒目的方式可以轻松判断是否烧录成功，但是怎么都不成功。之后用STM32CubeMX重新load项目，适配CMakeLists文件，之后便可以成功烧录
- 整个reload过程没有更改信息，迷之异常
- 其二，我手里还有一个板子的mcu好像是国产的，没有查到具体型号(拼多多上买的，商家标注的是和stm32f103c8t6完全一样)。在一切配置都相同的情况下，仅仅换一块板子，两个烧录时间天差地别，国产芯片耗时离谱