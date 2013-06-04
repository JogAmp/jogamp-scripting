#! /bin/sh

zpool set bootfs=jogamp07/system/debian7_01 jogamp07

zpool export jogamp07
zpool import -R /mnt/new jogamp07

zpool set cachefile=/etc/zfs/zpool.cache jogamp07

mkdir -p /mnt/new/etc/zfs
cp -a /etc/zfs/zpool.cache /mnt/new/etc/zfs
