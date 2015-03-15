GNU/Linux Debian Wheezy Server Bringup w/ ZFS

2013 May 30th

Sven Gothel
JogAmp Community
Creative Commons Attribution 3.0 License. http://creativecommons.org/licenses/by/3.0/

+++

Small Pool:
        1x ZPool
            1x VDEV 2x n TB raidz1 ( 1 + 1 )

    or better

        1x Mirror
            1x VDEV 2x n TB mirror ( 1 + 1 )


Big Pool:
    1x ZPool
        2x VDEV 3x n TB raidz1 ( 2 + 1 )

+++

Tuning:
    - no dedup (huge memory consumption / performance)
    - no compression (cheap .. but why ?)
    - max ARC cache .. 50/50 ?
         - http://www.solarisinternals.com/wiki/index.php/ZFS_Evil_Tuning_Guide#Limiting_the_ARC_Cache
               arc_c_min= (16MB?)
               arc_c_max= 17179869184 (16GB)  (50% of 32GB)
               arc.c = arc.c_max
               arc.p = arc.c / 2
           or
               # ARC: 0 - 12 GB
               echo options zfs zfs_arc_max=12884901888 >> /etc/modprobe.d/zfs.conf
               echo zfs zfs_arc_max=12884901888 >> /etc/initramfs-tools/modules

               17179869184 # 0x400000000 (16 GB)
               12884901888 # 0x300000000 (12 GB)
                8589934592 # 0x200000000 ( 8 GB)
                4294967296 # 0x100000000 ( 4 GB)
                1073741824 # 0x040000000 ( 1 GB)
                 536870912 # 0x020000000 (.5 GB)

            Note: 'cat /sys/module/zfs/parameters/zfs_arc_max' shows you the current value on a running system!

    - Dedup Ram: 5GB of RAM per Terrabyte of storage ?
    - Advanced Format 4096 byte blocks -> ashift=12 ?!

+++

Install:

  1 Boot in Debian Rescue mode
    1.0 Install on USB drive
        - No DESKTOP, ..
        - Leave 1-2GB available for extra ext4 boot partition
          to mitigate grub's lack of ZFS support!!

          /dev/sdc USB drive
          /dev/sdc1 root
          /dev/sdc2 boot2

    1.1 Network Setup ..
        1.1.1 Manual Setup /etc/network/interfaces 
            auto lo
            iface lo inet loopback

            auto eth0
            iface eth0 inet static
              address a.b.c.d
              netmask 255.255.255.255
              dns-nameservers a.b.c.d 1.2.3.4 5.6.7.8
              gateway 1.2.3.4
            iface eth0 inet6 static
              address a:b:c:d:::1:1
              netmask 64
              up ip -6 route add fe80::1 dev eth0
              down ip -6 route del fe80::1 dev eth0
              up ip -6 route add default via fe80::1 dev eth0
              down ip -6 route del default via fe80::1 dev eth0

            - echo jogamp.org > /etc/hostname
              /etc/init.d/hostname.sh start


  2 Boot USB drive
        2.0 Old md superblock ?
            Example: /dev/sdb is autodetected as md0:
            - mdadm --manage --stop /dev/md0
            - mdadm --zero-superblock /dev/sdb

        2.1 Fix /etc/apt/sources.list
            - remove dvd driver
            - add 'wheezy main contrib non-free' net source
            - cp -a apt-sources.list /etc/apt/sources.list

        'apt-sources.list':
            deb http://ftp.debian.org/debian/ wheezy main contrib non-free
            deb-src http://ftp.debian.org/debian/ wheezy main contrib non-free

            deb http://security.debian.org/ wheezy/updates main contrib
            deb-src http://security.debian.org/ wheezy/updates main contrib

            deb http://ftp.de.debian.org/debian/ wheezy-updates main contrib non-free
            deb-src http://ftp.de.debian.org/debian/ wheezy-updates main contrib non-free

        2.2 Install ZFS on USB drive (Script './apt-install-zfs_kernel_etc.sh'):
            - wget http://archive.zfsonlinux.org/debian/pool/main/z/zfsonlinux/zfsonlinux_1%7Ewheezy_all.deb
            - dpkg -i zfsonlinux_1~wheezy_all.deb
            - apt-get update
            - apt-get upgrade
            - apt-get install linux-base linux-image-amd64 linux-headers-amd64 util-linux
            - apt-get install debian-zfs libzfs-dev
            - apt-get install zfs-initramfs
            - apt-get install vim

            - Edit /etc/default/zfs 
                - ZFS_MOUNT='no'
                + ZFS_MOUNT='yes'

            - Fix /usr/share/initramfs-tools/scripts/zfs issues:
                --- /usr/share/initramfs-tools/scripts/zfs      2013-03-27 04:14:41.000000000 +0100
                +++ initramfs-tools.scripts.zfs 2013-06-04 04:20:23.278131866 +0200
                @@ -104,7 +104,7 @@
                                echo ""
                                echo "Manually import the root pool at the command prompt and then exit."
                                echo "Hint: Try:  zpool import -f -R / -N $ZFS_RPOOL"
                -               /bin/sh
                +               # /bin/sh
                        fi
                 
                        if [ -z "$ZFS_BOOTFS" ]
    
            - ARC Mem config (assume 32GB ram)
              # ARC: 0 - 12 GB
              echo options zfs zfs_arc_max=12884901888 >> /etc/modprobe.d/zfs.conf
              echo zfs zfs_arc_max=12884901888 >> /etc/initramfs-tools/modules
              depmod -a

            Note: 'cat /sys/module/zfs/parameters/zfs_arc_max' shows you the current value on a running system!

        2.3 Gather some specs ..
            - Gather hdd UUIDs
                - $ ls -l /dev/disk/by-uuid
                  lrwxrwxrwx 1 root root 10 11. Okt 18:02 53cdad3b-4b01-4a6c-a099-be1cdf1acf6d -> ../../sda2

            - Check whether hdd uses Advanced Formating, i.e. blk size 4096 instead of 512.
                - apt-get install smartmontools 
                - smartctl -a /dev/sda, .. etc .. see whether (Adv. Format) is listed
                - if any disk uses Adv. Format -> "zfs create -o ashift=12 jogamp07 .."

                However, to be future-proof, it is recommended to always use 4096 block size for ZFS.
                You won't be able to change your pool later.

        2.4 Config zfs on sda sdb
            - Below we use 'jogamp07' as the zfs pool name, 
              it's best to replace it w/ a meaningful name, i.e. your hostname.

            Below is scripted in './zfs01-create_config-pool.sh' (using jogamp07 as pool name)

            - Create zpool
                - mirror: if cheap redundancy is more important than size and disks == 2
                    - zpool create -f -o ashift=12 jogamp07 mirror /dev/disk/by-id/uuid1 /dev/disk/by-id/uuid2
                - .. else zraid:
                    - zpool create -f -o ashift=12 jogamp07 raidz1 /dev/disk/by-id/ata...
                - -f -> overwrite existing partition table / data
                - ashift=12 -> blocksize 2096

            - Config zpool
                - zpool autoexpand=on jogamp07
                - zpool autoreplace=on jogamp07
                - zpool listsnapshots=off jogamp07

            - Config root dataset (for all datasets)
                - zfs set dedup=off jogamp07
                - zfs set compression=off jogamp07
                - zfs set atime=off jogamp07
                - zfs set mountpoint=none jogamp07

            - Swap (Ram 32G, CPU x86_64 == 4k page size)
                - zfs create jogamp07/swap -V 33G -b 4K
                - zfs set checksum=off jogamp07/swap
                ZVOL should be either:
                    /dev/zvol/jogamp07/swap -> ../../zd0
                    /dev/zvol/swap
                    /dev/jogamp07/swap

                - mkswap -f /dev/zvol/jogamp07/swap

            Below is scripted in './zfs02-create-datasets.sh' (using jogamp07 as pool name)

            - Create Datasets
                Separation of system/* and the other (users, ..)
                allows moving onto another OS/distri while maintaining the data.

                - zfs create -o mountpoint=none  jogamp07/system
                - zfs create -o mountpoint=/     jogamp07/system/debian7_01
                # Skip: Will fail w/ zfs-initramfs, mount of /var is too late
                # Skip: zfs create                     jogamp07/system/debian7_01/var

                - zfs create -o mountpoint=/home jogamp07/users
                - zfs create -o mountpoint=/root jogamp07/users/root
                - zfs create -o mountpoint=/data jogamp07/data
                - zfs create -o compression=gzip jogamp07/data/backup
                - zfs create -o mountpoint=/srv  jogamp07/services
                - zfs create -o mountpoint=/data jogamp07/backup

                - zfs set readonly=on jogamp07/backup

                - zfs list -o name,readonly,compression

            Below is scripted in './zfs03-export_import.sh' (using jogamp07 as pool name)

            - Set zfs pool bootfs
                - zpool set bootfs=jogamp07/system/debian7_01 jogamp07

            - Export zfs pool
                - zpool export jogamp07

            - Import zfs pool
                - zpool import -f -R /mnt/new jogamp07

            - Ensure zpool.cache exists:
                - zpool set cachefile=/etc/zfs/zpool.cache jogamp07

            - Copy zpool.cache:
                - mkdir -p /mnt/new/etc/zfs
                - cp -a /etc/zfs/zpool.cache /mnt/new/etc/zfs

        2.5 Grub Config
            - cp grub_custom.cfg /boot/grub/custom.cfg 
            - edit /boot/grub/custom.cfg to match your partitions / UUID, e.g.:
                    menuentry "zfs_01" {
                            load_video
                            insmod gzio
                            insmod part_msdos
                            insmod ext2
                            set root='(hd2,msdos1)'
                            search --no-floppy --fs-uuid --set=root 187bf74d-d4c3-4138-a61a-d4bfb4bc5052
                            linux   /boot/vmlinuz-3.2.0-4-amd64 boot=zfs rpool=jogamp07 bootfs=jogamp07/system/debian7_01 ro
                            initrd  /boot/initrd.img-3.2.0-4-amd64
                    }

              - If not yet installed:
                - grub-install --no-floppy /dev/sdc (the USB device!)

            - Edit /etc/default/grub:
                #GRUB_DEFAULT=0
                GRUB_DEFAULT="zfs_01"

            - update-grub

        2.6 Populate ZFS rootfs
            Below is scripted in './zfs04-system-populate.sh'

            - See [C1]
            - apt-get install debootstrap
            - debootstrap --arch amd64 stable /mnt/new ftp://ftp.de.debian.org/debian/

            - Setup /mnt/new/etc/network/interfaces
                - In case you use same /etc/network/interfaces (scripted):
                  mv /mnt/new/etc/network/interfaces /mnt/new/etc/network/interfaces.orig
                  cp -a /etc/network/interfaces /mnt/new/etc/network/interfaces
                  cp -a /etc/udev/rules.d/70-persistent-net.rules /mnt/new/etc/udev/rules.d/

                - Or redo 1.1.1 (Mind that you do it for rootfs on /mnt/new)

            - Redo: 2.1 Fix /etc/apt/sources.list (probably just the servers)
                -In case you use same apt sources (scripted):
                  mv /mnt/new/etc/apt/source.list /mnt/new/etc/apt/sources.list.orig
                  cp -a /etc/apt/sources.list /mnt/new/etc/apt/source.list
                - Or redo 2.1

        2.6 Chroot ZFS rootfs
            - Mount essentials # './chroot-mount.sh':
                mount --bind /dev  /mnt/new/dev
                mount --bind /proc /mnt/new/proc
                mount --bind /sys  /mnt/new/sys
            - chroot /mnt/new /bin/bash # './chroot-chroot.sh'

        2.7 Refine / Config System
            - Root passord: passwd

            - apt-get update
            - apt-get upgrade

            - apt-get install vim locales
            - dpkg-reconfigure locales tzdata
                LANG: en_US.UTF-8, LANGUAGE=en_US:en
                TZ: your choice

            - apt-get install ssh ntp htop iotop rsync xz-utils p7zip-full

        2.8 ZFS on new System
            - Redo: 2.2 Install ZFS on USB drive (Script './apt-install-zfs_kernel_etc.sh')

        2.9 Leave New System / Final Touches

            - Mount USB rootfs in new system
                - mkdir -p /mnt/usbroot
                - Use root partition on USB stick (-> 1.0)
                - Edit /etc/fstab, i.e.:
                    UUID=187bf74d-d4c3-4138-a61a-d4bfb4bc5052 /mnt/usbroot     ext4    errors=remount-ro 0       2
                - mount /mnt/usbroot
                - rm -rf /boot
                - ln -s /mnt/usbroot/boot /boot
                - umount /mnt/usbroot

            - Exit from chroot
            - umount proc/dev/sys './chroot-umount.sh'
                You may need to:
                - umount -l /mnt/new/dev

            Reset zfs pool cache ..
            - zpool export jogamp07
            - zpool import -N jogamp07
            - zpool set cachefile=/etc/zfs/zpool.cache jogamp07
            - update-initramfs -u -k all
            - 

            # zpool export jogamp07
            : now export all other pools too
            # zpool import -f -N jogamp07
            : now import all other pools too
            # zpool set cachefile=/etc/zfs/zpool.cache jogamp07
            # mount -t zfs -o zfsutil jogamp07/system/debian7_01 /mnt/new
            : do not mount any other filesystem
            # cp /etc/zfs/zpool.cache /mnt/new/etc/zfs/zpool.cache
            # umount /mnt/new
            # update-initramfs -u -k all

            # zpool export rpool
            : now export all other pools too
            # zpool import -d /dev/disk/by-id -f -N rpool
            : now import all other pools too
            # mount -t zfs -o zfsutil rpool/ROOT/debian-1 /root
            : do not mount any other filesystem
            # cp /etc/zfs/zpool.cache /root/etc/zfs/zpool.cache
            # exit

        2.10 Grub on target
            cp -a /mnt/usbroot/etc/default/grub /etc/default/grub
            apt-get install grub-pc grub-common grub-pc-bin grub2-common


        X.1 Skip: Grub 2.00 Derivates / Boot 
            Note: All failed detecting ZFS rootfs properly!

            - Manually build grub 2.00 (ZFS support) [C2]
                - dpkg -P grub2 grub-pc grub-common grub-pc-bin grub2-common
                - Build Grub 
                  - apt-get install bzr
                  - apt-get install gettext bison flex libdevmapper-dev
                  - apt-get install python autoconf automake autogen

                  Do the following from a user account:

                  - Skip: Grub 2.00 (not working .. zfs 'unknown filesystem')
                      wget ftp://ftp.gnu.org/gnu/grub/grub-2.00.tar.gz
                      tar xzf grub-2.00.tar.gz
                      cd grub-2.00

                  - Skip Using bazar repo revno: 5022
                      bzr branch http://bzr.savannah.gnu.org/r/grub/trunk/grub
                      git clone --branch snapshot/ubuntu/raring https://github.com/zfsonlinux/grub.git zfs-grub
                      cd grub
                      ./autogen.sh
                      ./configure --disable-werror --enable-libzfs --enable-device-mapper --enable-efiemu
                      make
                      sudo make install

                  - Skip Using zfs-grub (or ubuntu grub)
                      git clone --branch snapshot/ubuntu/raring https://github.com/zfsonlinux/grub.git zfs-grub
                      cd zfs-grub

                      for i in `cat debian/patches/series`; do patch -p1 < debian/patches/$i 2>&1 | tee -a patch.log ; done
                      ./autogen.sh
                      ./configure --disable-werror --enable-libzfs --enable-device-mapper --enable-efiemu
                      make
                      sudo make install

            - Install ..
                update-initramfs -u -k all
                grub-install --no-floppy /dev/sdc (the USB device!)

                +++
                set timeout=3
                set default=0

                # Funtoo
                menuentry "JogAmp 01" {  
                  insmod zfs
                  linux /vmlinuz-3.2.0-4-rt-amd64 root=jogamp07/system/debian7_01
                  initrd /initrd.img-3.2.0-4-rt-amd64
                }
                +++


References:

[A1] https://en.wikipedia.org/wiki/ZFS
[A2] http://wiki.illumos.org/display/illumos/ZFS
[A3] http://docs.huihoo.com/opensolaris/solaris-zfs-administration-guide/html/index.html
[A4] http://cuddletech.com/ZFSNinja-Slides.pdf
[A5] http://www.solarisinternals.com/wiki/index.php/ZFS_Best_Practices_Guide
[A6] http://www.solarisinternals.com/wiki/index.php/ZFS_Evil_Tuning_Guide
[A7] http://www.cuddletech.com/blog/pivot/entry.php?id=983 (ZFS Compression)
[A8] https://blogs.oracle.com/dap/entry/zfs_compression

[B1] http://zfsonlinux.org/
[B2] http://pthree.org/2012/04/17/install-zfs-on-debian-gnulinux/
[B3] https://wiki.freebsd.org/ZFSTuningGuide
[B4] http://stoneyforest.net/~chris/blog/freebsd/zfs/maint.html
[B5] http://www.funtoo.org/wiki/ZFS_Install_Guide

[C1] http://www.howtoforge.com/installing-debian-wheezy-testing-with-debootstrap-from-a-grml-live-linux-p2
[C2] http://www.gnu.org/software/grub/manual/grub.html

[_1] http://wiki.debian.org/AptPreferences#Pinning
