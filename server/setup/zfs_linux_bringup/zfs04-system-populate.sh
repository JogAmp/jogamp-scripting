#! /bin/sh

apt-get install debootstrap
debootstrap --arch amd64 stable /mnt/new ftp://ftp.de.debian.org/debian/

touch /mnt/new/etc/network/interfaces
mv /mnt/new/etc/network/interfaces /mnt/new/etc/network/interfaces.orig

touch /mnt/new/etc/apt/source.list
mv /mnt/new/etc/apt/source.list /mnt/new/etc/apt/source.list.orig
cp -a /etc/apt/sources.list /mnt/new/etc/apt/source.list

mkdir -p /mnt/new/mnt/usbroot

