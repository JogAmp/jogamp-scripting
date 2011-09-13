#! /bin/bash

##
#
# Will relocate a webstart folder.
#   - copy wsdir1 -> wsdir2
#   - filters jnlp files (url)
#
# relocate-webstart-folder.sh <version> <wsdir1> <wsdir2> <url>
# eg.
#   relocate-webstart-folder.sh v2.0-rc2 \
#                               /srv/www/deployment/webstart-b3 \
#                               /srv/www/deployment/webstart-next \
#                               http://lala.lu/webstart-next 
#
##

version=$1
shift

abuild=$1
shift

wsdir=$1
shift

url=$1
shift

if [ -z "$version" -o -z "$abuild" -o -z "$wsdir" -o -z "$url" ] ; then
    echo "usage $0 version abuilddir webstartdir url"
    exit 1
fi

if [ ! -e $abuild ] ; then
    echo $abuild does not exist
    exit 1
fi

if [ -e $wsdir ] ; then
    echo $wsdir already exist
    exit 1
fi

sdir=`dirname $0`

. $sdir/../deployment/funcs_jnlp_relocate.sh

cp -a $abuild $wsdir

copy_relocate_jnlps_base  $version $url $wsdir
copy_relocate_jnlps_demos $version $url $wsdir joal-demos
copy_relocate_jnlps_demos $version $url $wsdir jogl-demos
copy_relocate_jnlps_demos $version $url $wsdir jocl-demos

