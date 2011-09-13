#! /bin/bash

tag=v2.0-rc2

ssh jogl@jogamp.org "\
    cd /home/jogl ; \
    rm -rf jogamp-scripting ; \
    git clone file:///srv/scm/jogamp-scripting.git jogamp-scripting ; \
    cd jogamp-scripting ; \
    ls -la ; \
    ./jenkins-builds/relocate-webstart-folder.sh \
        $tag \
        /srv/www/jogamp.org/deployment/webstart-next \
        /srv/www/jogamp.org/deployment/webstart-new \
        http://jogamp.org/deployment/webstart ; \
    mv /srv/www/jogamp.org/deployment/webstart /srv/www/jogamp.org/deployment/webstart-old ; \
    mv /srv/www/jogamp.org/deployment/webstart-new /srv/www/jogamp.org/deployment/webstart ; \
    rm -rf /srv/www/jogamp.org/deployment/webstart-old ; \
"

