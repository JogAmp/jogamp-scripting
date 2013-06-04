#! /bin/sh

zpool create -f -o ashift=12 jogamp07 mirror /dev/disk/by-id/ata-WDC_WD15EADS-00P8B0_WD-WMAVU0880750 /dev/disk/by-id/ata-WDC_WD20EARS-00S8B1_WD-WCAVY4733652

zpool autoexpand=on jogamp07
zpool autoreplace=on jogamp07
zpool listsnapshots=on jogamp07

zfs set dedup=off jogamp07
zfs set compression=off jogamp07
zfs set atime=off jogamp07
zfs set mountpoint=none jogamp07

# Swap ZVOL
zfs create jogamp07/swap -V 33G -b 4K
zfs set checksum=off jogamp07/swap
mkswap -f /dev/zvol/jogamp07/swap
