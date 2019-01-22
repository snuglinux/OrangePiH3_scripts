#!/bin/sh

set -e
if [[ $EUID -ne 0 ]]; then
   whiptail --title "Orangepi Build System" --msgbox "Need to run as root" 8 30 0
   exit 1
fi

if hash apt-get 2>/dev/null; then
   apt-get -y --no-install-recommends --fix-missing install \
            bsdtar mtools u-boot-tools pv bc \
            gcc automake make \
            lib32z1 lib32z1-dev qemu-user-static \
            dosfstools libncurses5-dev lib32stdc++-5-dev debootstrap
elif hash pacman 2>/dev/null; then
     pacman -Sy mtools uboot-tools pv bc \
            qemu-user-static swig dtc \
            dosfstools libstdc++5 debootstrap --noconfirm
else
  whiptail --title "Orangepi Build System" --msgbox "This script requires a Debian or Archlinux based distribution. If you are using another distribution, install:[ bsdtar mtools u-boot-tools pv bc sunxi-tools gcc automake make qemu dosfstools ]" 10 50 0
  exit 1
fi

# Prepare toolchains
ROOT=`cd .. && pwd`
chmod 755 -R $ROOT/toolchain/*
