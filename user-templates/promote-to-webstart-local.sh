#! /bin/bash

THISDIR=`pwd`

./hudson-builds/promote-to-webstart.sh \
    v2.0-rc2 \
    /srv/www/jogamp.org/deployment/archive/jau01 \
    /srv/www/jogamp.org/deployment/test/jau01s \
    http://risa/deployment/test/jau01s \
    keystore.p12 \
    PASSWORD \
    "some tag for the key"

