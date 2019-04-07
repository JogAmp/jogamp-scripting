
http://crosstool-ng.org/

0) Install crosstool-ng 1.24.0[-rc3] for building crosstools

 apt-get install help2man python3-dev

 cd crosstool-ng-1.24.0[-rc3]
 ./configure --prefix=/usr/local
 make
 sudo make install

1) Some local preparations

 # where the cross-tools will be build, aka cross-tools projects
 mkdir /usr/local/projects/crosstool-ng-projects ; cd /usr/local/projects/crosstool-ng-projects

 # where the cross-tools will be installed and run from
 mkdir /usr/local/x-tools

 export CT_PREFIX=/usr/local/x-tools

2) Build for armv7-unknown-linux-gnueabihf

    mkdir armv7-unknown-linux-gnueabihf ; cd armv7-unknown-linux-gnueabihf
    
    ct-ng armv7-rpi2-linux-gnueabihf 
    ct-ng menuconfig
    Target          : arm; Def Instr arm; EABI; ** Append 'hf' to tuple; 'v7' arch suffix; ** Combing Libs Single Dir; 
                      MMU; Little-Endian; 32-bit; ** TUNE armv7; FPU ''; hardware FPU **
    Toolchain       : Sysroot, 'unknown' Tuple's vendor, 
    Languages       : C,C++
    OS              : linux-4.20.8; Check Headers, build libs
    Binutils        : binutils-2.32
    Compiler        : gcc-8.3.0; static libstdc++
    C library       : glibc-2.29
    Debug tools     : duma-2_5_15 gdb-8.2.1 ltrace-0.7.3 strace-4.26
    Companion libs  : expat-2.2.6 gettext-0.19.8.1 gmp-6.1.2 isl-0.20 libelf-0.8.13 libiconv-1.15 mpc-1.1.0 mpfr-4.0.2 ncurses-6.1
    Companion tools : automake-1.16.1

    ct-ng build

3) Build for aarch64-unknown-linux-gnu

    mkdir aarch64-unknown-linux-gnu ; cd aarch64-unknown-linux-gnu
    
    ct-ng aarch64-unknown-linux-gnu
    ct-ng build

