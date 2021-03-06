# TREZOR Core

![TREZOR Logo](docs/logo.png)

[![Build Status](https://travis-ci.org/trezor/trezor-core.svg?branch=master)](https://travis-ci.org/trezor/trezor-core)
[![Gitter](https://badges.gitter.im/trezor/community.svg)](https://gitter.im/trezor/community)

This is the core of the upcoming TREZOR v2.

## Documentation

* [Documentation](docs/)

## Build instructions for emulator

Run the following to checkout the project:

```sh
git clone --recursive https://github.com/trezor/trezor-core.git
cd trezor-core
```

### Linux

#### Debian/Ubuntu

```sh
sudo pip3 install --no-cache-dir pyblake2

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install scons libsdl2-dev:i386 libsdl2-image-dev:i386 gcc-multilib

make build_unix
```

#### Fedora

```sh
sudo pip3 install --no-cache-dir pyblake2

sudo yum install scons SDL2-devel.i686 SDL2_image-devel.i686

make build_unix
```

#### openSUSE

```sh
sudo pip3 install --no-cache-dir pyblake2

sudo zypper install scons libSDL2-devel-32bit libSDL2_image-devel-32bit

make build_unix
```

#### Arch

```sh
sudo pip3 install --no-cache-dir pyblake2

sudo pacman -S gcc-multilib scons lib32-sdl2 lib32-sdl2_image

make build_unix
```

### OS X

```sh
pip3 install --no-cache-dir pyblake2

brew install scons sdl2 sdl2_image

make build_unix
```

### Windows

Not supported yet ...

## Build instructions for ARM

### Linux

For flashing firmware to blank device (without bootloader) use `make flash`,
or `make flash STLINK_VER=v2-1` if using a ST-LINK/V2.1 interface.

#### Debian/Ubuntu

```sh
sudo pip3 install --no-cache-dir pyblake2

sudo apt-get install gcc-arm-none-eabi libnewlib-arm-none-eabi

make build_boardloader build_bootloader build_firmware
```

### OS X

1. Download [gcc-arm-none-eabi](https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q3-update/)
2. Follow the [install instructions](https://launchpadlibrarian.net/287100883/readme.txt)
3. To install stlink, run `brew install stlink`
4. Run `make build_boardloader build_bootloader build_firmware`
