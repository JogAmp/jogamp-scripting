#! /bin/bash

branch=master
bname=gluegen_263-joal_113-jogl_292-jocl_268
tag=v2.0-dev-master

ssh jogl@jogamp.org "\
    cd /home/jogl ; \
    rm -rf jogamp-scripting ; \
    git clone file:///srv/scm/jogamp-scripting.git jogamp-scripting ; \
    cd jogamp-scripting ; \
    ls -la ; \
    ./hudson-builds/relocate-webstart-folder.sh \
        $tag \
        /srv/www/jogamp.org/deployment/archive/$branch/$bname-webstart \
        /srv/www/jogamp.org/deployment/webstart-next-new \
        http://jogamp.org/deployment/webstart-next ; \
    mv /srv/www/jogamp.org/deployment/webstart-next /srv/www/jogamp.org/deployment/webstart-next-old ; \
    mv /srv/www/jogamp.org/deployment/webstart-next-new /srv/www/jogamp.org/deployment/webstart-next ; \
    rm -rf /srv/www/jogamp.org/deployment/webstart-next-old ; \
"

