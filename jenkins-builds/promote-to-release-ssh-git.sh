#! /bin/bash

version=v2.4.0-rc-20200104
rootdir=/srv/www/jogamp.org/deployment
adir=archive/master/gluegen_930-joal_652-jogl_1493-jocl_1137
sdir=archive/rc
urlb=https://jogamp.org/deployment

ssh jogamp@jogamp.org "\
    cd /home/jogamp/builds ; \
    rm -rf jogamp-scripting ; \
    git clone file:///srv/scm/jogamp-scripting.git jogamp-scripting ; \
    cd jogamp-scripting ; \
    git status ; \
    ./jenkins-builds/promote-to-release.sh \
        $version \
        $rootdir \
        $adir $sdir $urlb ; \
"

scp jogamp@jogamp.org:$rootdir/$sdir/$version/sha512sum.txt .
gpg --output sha512sum.txt.sig --detach-sig sha512sum.txt
gpg --verify sha512sum.txt.sig sha512sum.txt && \
scp sha512sum.txt.sig jogamp@jogamp.org:$rootdir/$sdir/$version/
