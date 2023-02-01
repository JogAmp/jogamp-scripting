#! /bin/bash

version=v2.4.0-rc-20230201
rootdir=/srv/www/jogamp.org/deployment
adir=archive/master/gluegen_951-joal_669-jogl_1518-jocl_1158
sdir=archive/rc
urlb=https://jogamp.org/deployment

logfile=`basename $0 .sh`.log

function deploy_it() {

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

ssh jogamp@jogamp.org "\
    cd /home/jogamp/builds/jogamp-scripting/maven ; \
    ./make-all-jogamp.sh $rootdir/$sdir/$version/archive/jogamp-all-platforms.7z $version ; \
"

}

deploy_it 2>&1 | tee ${logfile}
