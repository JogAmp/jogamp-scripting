#! /bin/bash

#    /srv/www/jogamp.org/deployment/archive/jau00 \
#    /srv/www/jogamp.org/deployment/test/jau01 \
#    http://localhost/deployment/test/jau01 \

./jenkins-builds/relocate-webstart-folder.sh \
    v2.0-rc2 \
    /srv/www/jogamp.org/deployment/archive/jau01 \
    /srv/www/jogamp.org/deployment/test/jau01s \
    http://risa/deployment/test/jau01s \

