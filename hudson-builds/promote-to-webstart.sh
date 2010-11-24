#! /bin/bash

##
#
# Will promote an aggregated/archived folder to a webstart folder.
#   - copy adir -> wsdir
#   - filters jnlp files (url)
#   - repack
#   - sign
#   - pack200
#
# promote-to-webstart.sh <adir> <wsdir> <url> <pkcs12-keystore> <storepass> [signarg]
# eg.
#   promote-to-webstart.sh /srv/www/deployment/b3 \
#                          /srv/www/deployment/webstart-b3 \
#                          http://lala.lu/webstart-b3 \
#                          secret.p12 \
#                          PassWord "something"
#
##

abuild=$1
shift

wsdir=$1
shift

url=$1
shift

keystore=$1
shift

storepass=$1
shift

signarg=$1
shift

if [ -z "$abuild" -o -z "$wsdir" -o -z "$url" -o -z "$keystore" -o -z "$storepass" ] ; then
    echo "usage $0 abuilddir webstartdir url pkcs12-keystore storepass [signarg]"
    exit 1
fi

if [ ! -e $abuild ] ; then
    echo $abuild does not exist
    exit 1
fi

if [ ! -e $wsdir ] ; then
    echo $wsdir does not exist
    exit 1
fi

if [ ! -e $keystore ] ; then
    echo $keystore does not exist
    exit 1
fi

sdir=`dirname $0`

thisdir=`pwd`

logfile=$thisdir/`basename $0 .sh`.log

. $sdir/../deployment/funcs_jnlp_relocate.sh
. $sdir/../deployment/funcs_jars_pack_sign.sh

function promote-webstart-jars() {
    echo
    echo "Promotion of latest files"
    echo
    echo "  branch: $branch"
    echo "  option: $option"
    echo "    secure: $secure"
    echo
    echo `date`
    echo
    prom_setup $rootdir $dest

#
# repack it .. so the signed jars can be pack200'ed
#
wsdir_jars_repack  $wsdir


#
# sign it
#
wsdir_jars_sign    $wsdir $keystore $storepass $signarg

#
# pack200
#
wsdir_jars_pack200 $wsdir

cp -av $logfile $wsdir

}

cp -a $abuild $wsdir 2>&1 | tee $logfile

copy_relocate_jnlps $url $wsdir 2>&1 | tee $logfile

promote-webstart-next 2>&1 | tee $logfile

