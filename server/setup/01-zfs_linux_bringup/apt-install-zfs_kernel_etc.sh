#! /bin/sh

wget http://archive.zfsonlinux.org/debian/pool/main/z/zfsonlinux/zfsonlinux_1%7Ewheezy_all.deb
dpkg -i zfsonlinux_1~wheezy_all.deb
apt-get update
apt-get upgrade
apt-get install linux-base linux-image-amd64 linux-headers-amd64 util-linux
apt-get install debian-zfs libzfs-dev
apt-get install zfs-initramfs
apt-get install vim

