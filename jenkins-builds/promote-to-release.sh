#! /bin/bash

##
#
# Will promote an aggregated/archived folder to a webstart folder.
#   - cd root-dir ; cp -a rel-aggregation-dir -> rel-storage-dir/version ; ln -s rel-storage-dir/version .
#
# promote-to-release.sh <version> <root-dir> <rel-aggregation-dir> <rel-storage-dir> <url-base>
# eg.
#   promote-to-release.sh v2.4.0-rc-20200104 \
#                          /srv/www/jogamp.org/deployment \
#                          archive/master/gluegen_930-joal_652-jogl_1493-jocl_1137 \
#                          archive/rc \
#                          https://jogamp.org/deployment \
#
##

version=$1
shift

rootdir=$1
shift

relaggregationdir=$1
shift

relstoragedir=$1
shift

urlbase=$1
shift

if [ -z "$version" -o -z "$rootdir" -o -z "$relaggregationdir" -o -z "$relstoragedir" -o -z "$urlbase" ] ; then
    echo "usage $0 version root-dir rel-aggregation-dir rel-storage-dir url-base"
    exit 1
fi

if [ ! -e "$rootdir" ] ; then
    echo root-dir $rootdir does not exist
    exit 1
fi

if [ ! -e "$rootdir/$relaggregationdir" ] ; then
    echo root-dir/rel-aggregation-dir $rootdir/$relaggregationdir does not exist
    exit 1
fi

if [ ! -e "$rootdir/$relstoragedir" ] ; then
    echo root-dir/rel-storage-dir $rootdir/$relstoragedir does not exist
    exit 1
fi

if [ -e "$rootdir/$relstoragedir/$version" ] ; then
    echo root-dir/rel-storage-dir/version $rootdir/$relstoragedir/$version already exists
    exit 1
fi

sdir=`dirname $0`

thisdir=`pwd`

logfile=$thisdir/`basename $0 .sh`.log

function echo_info() {
    echo
    echo "Promotion release jars"
    echo
    echo "  Version $version"
    echo "  Root $rootdir"
    echo "  Copy $relaggregationdir -> $relstoragedir"
    echo "  URL Base $urlbase"
    echo
    echo `date`
    echo
}

echo_info 2>&1 | tee $logfile

cd $rootdir

cp -a $relaggregationdir $relstoragedir/$version 2>&1 | tee $logfile
ln -s $relstoragedir/$version . 2>&1 | tee $logfile


