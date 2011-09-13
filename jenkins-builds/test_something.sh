#! /bin/bash

version=v2.0-rc2
wsdir=/srv/www/jogamp.org/deployment/archive/gluegen_195-jogl_203-jocl_200
url=http://jogamp.org/deployment/archive/gluegen_195-jogl_203-jocl_200

sdir=`dirname $0`

. $sdir/../deployment/funcs_jnlp_relocate.sh

copy_relocate_jnlps_base  $version $url $wsdir
copy_relocate_jnlps_demos $version $url $wsdir joal-demos
copy_relocate_jnlps_demos $version $url $wsdir jogl-demos
copy_relocate_jnlps_demos $version $url $wsdir jocl-demos
remove_security_tag_jnlps $wsdir

