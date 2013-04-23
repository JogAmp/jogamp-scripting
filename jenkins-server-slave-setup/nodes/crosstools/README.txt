
http://crosstool-ng.org/

1) Install crosstool-ng 1.18.0 for building crosstools

 cd crosstool-ng-1.18.0/
 ./configure --prefix=/usr/local/cross
 ./configure --prefix=/usr/local/x-tools
 make
 make install

2) Build gcc 4.6.3 for armhf-unknown-linux-gnueabi  and armsf-unknown-linux-gnueabi
    We assume the cross toolchain to be install in "/usr/local/x-tools/", i.e.
        /usr/local/x-tools/armhf-unknown-linux-gnueabi
        /usr/local/x-tools/armsf-unknown-linux-gnueabi

    mkdir armhf-unknown-linux-gnueabi ; cd armhf-unknown-linux-gnueabi
    ct-ng arm-unknown-linux-gnueabi
    ct-ng menuconfig (copy/read the provided .config files)
       - disable compiler: gcj, fortran
       - target: suffix=hf
       - target: float=hardware
    ct-ng build

    mkdir armsf-unknown-linux-gnueabi ; cd armsf-unknown-linux-gnueabi
    ct-ng arm-unknown-linux-gnueabi
    ct-ng menuconfig (copy/read the provided .config files)
       - disable compiler: gcj, fortran
       - target: suffix=sf
       - target: float=softfp
    ct-ng build

