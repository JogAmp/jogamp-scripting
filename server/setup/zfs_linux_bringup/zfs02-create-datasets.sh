#! /bin/sh

zfs create -o mountpoint=none  jogamp07/system
zfs create -o mountpoint=/     jogamp07/system/debian7_01
# Will fail w/ zfs-initramfs, mount of /var is too late
# zfs create                     jogamp07/system/debian7_01/var

zfs create -o mountpoint=/home jogamp07/users
zfs create -o mountpoint=/root jogamp07/users/root
zfs create -o mountpoint=/data jogamp07/data
zfs create -o mountpoint=/srv  jogamp07/services

