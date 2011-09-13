#! /bin/bash

branch=master
bname=gluegen_263-joal_113-jogl_292-jocl_268
tag=v2.0-dev-master

ssh jogl@jogamp.org "\
    cd /home/jogl/sgothel ; \
    rm -rf jogamp-scripting ; \
    git clone file:///srv/scm/jogamp-scripting.git jogamp-scripting ; \
    cd jogamp-scripting ; \
    ls -la ; \
    ./jenkins-builds/promote-to-webstart.sh \
        $tag \
        /srv/www/jogamp.org/deployment/archive/$branch/$bname \
        /srv/www/jogamp.org/deployment/archive/$branch/$bname-webstart \
        http://jogamp.org/deployment/archive/$branch/$bname-webstart \
        keystore.p12 \
        PASSWORD \
        \"some tag for the key\" ; \
"

