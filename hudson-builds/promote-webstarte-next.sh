#! /bin/bash

abuild=/srv/www/jogamp.org/deployment/archive/gluegen_195-jogl_203-jocl_200
wsdir=/srv/www/jogamp.org/deployment/webstart-next
url=http://jogamp.org/deployment/webstart-next

sdir=`dirname $0`

. $sdir/../deployment/funcs_jnlp_relocate.sh

cp -a $abuild $wsdir

copy_relocate_jnlps $url $wsdir

