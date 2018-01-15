
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

3) Install crosstool-ng 1.23 (tested using pre-release 1.22+git 4042269de621e166235308f139e89c92e379040d )
   for building crosstools for aarch64

 git clone https://github.com/crosstool-ng/crosstool-ng
 cd crosstool-ng
 ./bootstrap
 ./configure --prefix=/usr/local/x-tools
 make
 make install

4) Build gcc 4.8.5 for aarch64-unknown-linux-gnueabi 
    We assume the cross toolchain to be install in "/usr/local/x-tools/", i.e.
        /usr/local/x-tools/aarch64-unknown-linux-gnueabi

    mkdir aarch64-unknown-linux-gnueabi ; cd aarch64-unknown-linux-gnueabi
    ct-ng aarch64-unknown-linux-gnueabi
    ct-ng menuconfig (copy/read the provided .config files)
    ct-ng build
