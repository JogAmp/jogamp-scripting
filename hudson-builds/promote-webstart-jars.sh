#! /bin/bash

##
#
# Will modify all non jar file in the aggregated webstart folder.
#   - repack
#   - sign
#   - pack200
#
# promote-webstart-jars.sh <wsdir> <pkcs12-keystore> <storepass> [signarg]
#
##

wsdir=$1
shift

keystore=$1
shift

storepass=$1
shift

signarg=$1
shift

if [ -z "$wsdir" -o -z "$keystore" -o -z "$storepass" ] ; then
    echo "usage $0 webstartdir pkcs12-keystore storepass [signarg]"
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

. $sdir/../deployment/funcs_jars_pack_sign.sh

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

