#! /bin/bash

##
#
# Will relocate a webstart folder.
#   - copy wsdir1 -> wsdir2
#   - filters jnlp files (url)
#
# relocate-webstart-folder.sh <wsdir1> <wsdir2> <url>
# eg.
#   relocate-webstart-folder.sh /srv/www/deployment/webstart-b3 \
#                               /srv/www/deployment/webstart-next \
#                               http://lala.lu/webstart-next 
#
##

abuild=$1
shift

wsdir=$1
shift

url=$1
shift

if [ -z "$abuild" -o -z "$wsdir" -o -z "$url" ] ; then
    echo "usage $0 abuilddir webstartdir url"
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

sdir=`dirname $0`

. $sdir/../deployment/funcs_jnlp_relocate.sh

cp -a $abuild $wsdir

copy_relocate_jnlps $url $wsdir

