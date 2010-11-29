#! /bin/bash

wsdir=/srv/www/jogamp.org/deployment/archive/gluegen_195-jogl_203-jocl_200
url=http://jogamp.org/deployment/archive/gluegen_195-jogl_203-jocl_200

sdir=`dirname $0`

. $sdir/../deployment/funcs_jnlp_relocate.sh

copy_relocate_jnlps_base $url $wsdir
copy_relocate_jnlps_demos $url $wsdir jogl-demos
copy_relocate_jnlps_demos $url $wsdir jocl-demos
remove_security_tag_jnlps $wsdir

