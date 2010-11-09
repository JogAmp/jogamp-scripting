#! /bin/bash

wsdir=/srv/www/jogamp.org/deployment/archive/gluegen_195-jogl_203-jocl_200
url=http://jogamp.org/deployment/archive/gluegen_195-jogl_203-jocl_200

sdir=`dirname $0`

. $sdir/../deployment/funcs_jnlp_relocate.sh

copy_relocate_jnlps $url $wsdir
remove_security_tag_jnlps $wsdir

