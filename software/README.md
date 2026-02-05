software
---

### 1 [DAPLink](./DAPLink)

编译DAPLink固件

- 1 加载cmake
- 2 执行make目标all-daplink-build
- 3 查看build目录下的.bin文件
- 4 查看固件大小`ls -lh`

### 2 pyocd

#### 2.1 install python and USB rules dep

```shell
sudo apt update

sudo apt install -y python3 python3-pip python3-venv libusb-1.0-0 libusb-1.0-0-dev udev
```

#### 2.2 install pyocd

my host is debian, cannot install it via `pip install pyocd`, so i create a venv for my system and then add it into PATH

```shell
cd ~/MyApp
python3 -m venv MyPyPackage

pyocd --version
```

#### 2.3 pyocd commands

```shell
pyocd list
pyocd list --targets
pyocd pack update
pyocd pack install stm32f1
pyocd flash -t <mcu> --erase chip <hex>
```

### 3 [my_demo](./my_demo)

> 点灯代码 用来验证DAPLink下载器可以正常工作

### 4 [web-view](./web-view)

> 实现远程/无线烧录的前台