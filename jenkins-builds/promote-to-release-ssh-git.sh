#! /bin/bash

#plain_version=2.6.0-rc-20250827
plain_version=2.6.0
version=v${plain_version}
rootdir=/srv/www/jogamp.org/deployment
adir=archive/master/gluegen_987-joal_698-jogl_1548-jocl_1191
sdir=archive/rc
urlb=https://jogamp.org/deployment

logfile=`basename $0 .sh`.${version}.log

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

# we deploy maven from our local workstation
# to maven central and jogamp.org mirror
#
#ssh jogamp@jogamp.org "\
#    cd /home/jogamp/builds/jogamp-scripting/maven ; \
#    ./make-all-jogamp.sh $rootdir/$sdir/$version/archive/jogamp-all-platforms.7z ${plain_version} ; \
#"

scp jogamp@jogamp.org:$rootdir/$sdir/$version/archive/jogamp-all-platforms.7z ../maven

cat <<EOF > deploy_maven.sh
#!/bin/sh
cd ../maven
./make-all-jogamp.sh jogamp-all-platforms.7z ${plain_version}
./make-deploy-sonatype.sh ${plain_version}
EOF

deploy_maven.sh generated, consider using it"
cat deploy_maven.sh

}

deploy_it 2>&1 | tee ${logfile}
