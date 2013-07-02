#! /bin/sh

apt-get install debootstrap
debootstrap --arch amd64 stable /mnt/new ftp://ftp.de.debian.org/debian/

touch /mnt/new/etc/network/interfaces
mv /mnt/new/etc/network/interfaces /mnt/new/etc/network/interfaces.orig
cp -a /etc/network/interfaces /mnt/new/etc/network/interfaces
cp -a /etc/udev/rules.d/70-persistent-net.rules /mnt/new/etc/udev/rules.d/

touch /mnt/new/etc/apt/source.list
mv /mnt/new/etc/apt/source.list /mnt/new/etc/apt/source.list.orig
cp -a /etc/apt/sources.list /mnt/new/etc/apt/source.list

cp -a /etc/default/grub /mnt/new/etc/default/grub

mkdir -p /mnt/new/mnt/usbroot

#Optional stuff
#cp -a /root/zfs_linux_bringup /mnt/new/root/
#cp -a /root/.ssh /mnt/new/root/
#cp -a /root/.exrc /mnt/new/root/

