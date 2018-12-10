#! /bin/bash

##
#
# Will end up with an aggregated folder, webstart enabled,
# but not pack200 compressed and not signed.
#
# promote-latest-builds.sh <branch-name> [secure]
#
##

branch=$1
shift
if [ ! -z "$1" ] ; then
    option=$1
    shift
fi
let secure=0
if [ "$option" == "secure" ] ; then
    let secure=1
fi

version=autobuild

sdir_0=`dirname $0`
sdir=`readlink -f $sdir_0`

thisdir=`pwd`

logfile=$thisdir/`basename $0 .sh`.log

. $sdir/funcs_promotion.sh
. $sdir/../deployment/funcs_jnlp_relocate.sh

archivedir=/srv/www/jogamp.org/deployment/archive/$branch
rootdir=/srv/www/jogamp.org/deployment/autobuilds/$branch

#os_and_archs_minus_master_android="linux-i586 linux-armv6 linux-armv6hf macosx-universal windows-amd64 windows-i586 solaris-i586 solaris-amd64"
os_and_archs_minus_master_android="linux-armv6hf macosx-universal windows-amd64"
os_and_archs_android="android-armv6 android-aarch64"
masterpick="linux-amd64"
os_and_archs_minus_one="$os_and_archs_minus_master_android $os_and_archs_android"
os_and_archs_minus_android="$masterpick $os_and_archs_minus_master_android"
os_and_archs="$masterpick $os_and_archs_minus_one"

cd $rootdir

dest=tmp-archive
rm -rf $dest

function promote-latest-builds() {
    echo
    echo "Promotion of latest files"
    echo
    echo "  branch: $branch"
    echo "  option: $option"
    echo "    secure: $secure"
    echo
    echo `date`
    echo
    prom_setup $dest

    gluegenslave=`prom_lslatest gluegen-b`
    bgluegenslave=`prom_buildnumber_2 $gluegenslave`
    gluegenmaster=`prom_lslatest gluegen-master-b`
    bgluegenmaster=`prom_buildnumber_3 $gluegenmaster`
    echo
    echo GLUEGEN
    echo
    echo slave  build $bgluegenslave - $gluegenslave
    echo master build $bgluegenmaster - $gluegenmaster
    echo
    echo "gluegen.build.number=$bgluegenslave" >> $dest/log/aggregated.artifact.properties

    prom_promote_module gluegen $gluegenslave $dest

    cp -a $gluegenmaster/artifact.properties $dest/log/gluegen-master.artifact.properties
    cp -a $gluegenmaster/javadoc.7z $dest/archive/gluegen-javadoc.7z
    cd $dest/javadoc
    echo "INFO: gluegen master gluegen-javadoc 7z"
    prom_extract ../archive/gluegen-javadoc.7z gluegen
    cd $rootdir

    joalslave=`prom_lslatest joal-b`
    bjoalslave=`prom_buildnumber_2 $joalslave`
    joalmaster=`prom_lslatest joal-master-b`
    bjoalmaster=`prom_buildnumber_3 $joalmaster`
    echo
    echo JOAL
    echo
    echo slave  build $bjoalslave - $joalslave
    echo master build $bjoalmaster - $joalmaster
    echo
    echo "joal.build.number=$bjoalslave" >> $dest/log/aggregated.artifact.properties

    prom_promote_module joal $joalslave $dest
    
    cp -a $joalmaster/artifact.properties $dest/log/joal-master.artifact.properties
    cp -a $joalmaster/javadoc.7z $dest/archive/joal-javadoc.7z
    cd $dest/javadoc
    prom_extract ../archive/joal-javadoc.7z joal
    cd $rootdir

    joaldemosslave=`prom_lslatest joal-demos-b`
    bjoaldemosslave=`prom_buildnumber_3 $joaldemosslave`
    joaldemosmaster=`prom_lslatest joal-demos-master-b`
    bjoaldemosmaster=`prom_buildnumber_4 $joaldemosmaster`
    echo
    echo JOAL DEMOS
    echo
    echo slave   build $bjoaldemosslave - $joaldemosslave
    echo
    echo "joal-demos.build.number=$bjoaldemosslave" >> $dest/log/aggregated.artifact.properties

    cp -a $joaldemosslave/artifact.properties $dest/log/joal-demos.artifact.properties

    prom_promote_demos joal-demos slave $joaldemosslave $dest

    joglslave=`prom_lslatest jogl-b`
    bjoglslave=`prom_buildnumber_2 $joglslave`
    joglmaster=`prom_lslatest jogl-master-b`
    bjoglmaster=`prom_buildnumber_3 $joglmaster`
    echo
    echo JOGL
    echo
    echo slave  build $bjoglslave - $joglslave
    echo master build $bjoglmaster - $joglmaster
    echo
    echo "jogl.build.number=$bjoglslave" >> $dest/log/aggregated.artifact.properties

    prom_promote_module jogl $joglslave $dest

    cp -a $joglmaster/artifact.properties $dest/log/jogl-master.artifact.properties
    cp -a $joglmaster/javadoc.7z $dest/archive/jogl-javadoc.7z
    cd $dest/javadoc
    prom_extract ../archive/jogl-javadoc.7z jogl
    cd $rootdir

    jogldemosslave=`prom_lslatest jogl-demos-b`
    bjogldemosslave=`prom_buildnumber_3 $jogldemosslave`
    jogldemosmaster=`prom_lslatest jogl-demos-master-b`
    bjogldemosmaster=`prom_buildnumber_4 $jogldemosmaster`
    echo
    echo JOGL DEMOS
    echo
    echo slave   build $bjogldemosslave - $jogldemosslave
    echo master  build $bjogldemosmaster - $jogldemosmaster
    echo
    echo "jogl-demos.build.number=$bjogldemosslave" >> $dest/log/aggregated.artifact.properties
    echo "jogl-demos.build.number=$bjogldemosmaster" >> $dest/log/aggregated.artifact.properties

    cp -a $jogldemosslave/artifact.properties $dest/log/jogl-demos.artifact.properties
    grep jogl-demos.build.branch $jogldemosmaster/artifact.properties >> $dest/log/jogl-demos.artifact.properties
    grep jogl-demos.build.commit $jogldemosmaster/artifact.properties >> $dest/log/jogl-demos.artifact.properties

    prom_promote_demos jogl-demos master $jogldemosmaster $dest

    joclslave=`prom_lslatest jocl-b`
    bjoclslave=`prom_buildnumber_2 $joclslave`
    joclmaster=`prom_lslatest jocl-master-b`
    bjoclmaster=`prom_buildnumber_3 $joclmaster`
    echo
    echo JOCL
    echo
    echo slave  build $bjoclslave - $joclslave
    echo master build $bjoclmaster - $joclmaster
    echo
    echo "jocl.build.number=$bjoclslave" >> $dest/log/aggregated.artifact.properties

    prom_promote_module jocl $joclslave $dest
    
    cp -a $joclmaster/artifact.properties $dest/log/jocl-master.artifact.properties
    cp -a $joclmaster/javadoc.7z $dest/archive/jocl-javadoc.7z
    cd $dest/javadoc
    prom_extract ../archive/jocl-javadoc.7z jocl
    cd $rootdir

    jocldemosslave=`prom_lslatest jocl-demos-b`
    bjocldemosslave=`prom_buildnumber_3 $jocldemosslave`
    echo
    echo JOCL DEMOS
    echo
    echo slave  build $bjocldemosslave - $jocldemosslave
    echo
    echo "jocl-demos.build.number=$bjocldemosslave" >> $dest/log/aggregated.artifact.properties

    cp -a $jocldemosslave/artifact.properties $dest/log/jocl-demos.artifact.properties

    prom_promote_demos jocl-demos slave $jocldemosslave $dest

    echo
    echo FAT JAR
    echo
    prom_make_fatjar $dest

    #########################################################
    ## Integrity Check, Cleanup, aggregation.properties
    #########################################################

    prom_integrity_check $dest jar            tmp/dump
    prom_integrity_check $dest jar/atomic     tmp/dump
    prom_integrity_check $dest apk            tmp/dump
    prom_integrity_check $dest joal-demos/jar tmp/dump
    prom_integrity_check $dest jogl-demos/jar tmp/dump
    prom_integrity_check $dest jocl-demos/jar tmp/dump

    cd $dest

    echo
    echo aggregation.properties
    echo
    dos2unix log/gluegen.artifact.properties
    dos2unix log/joal.artifact.properties
    dos2unix log/joal-demos.artifact.properties
    dos2unix log/jogl.artifact.properties
    dos2unix log/jogl-demos.artifact.properties
    dos2unix log/jocl.artifact.properties
    dos2unix log/jocl-demos.artifact.properties
    cat log/gluegen.artifact.properties    \
        log/joal.artifact.properties       \
        log/joal-demos.artifact.properties \
        log/jogl.artifact.properties       \
        log/jogl-demos.artifact.properties \
        log/jocl.artifact.properties       \
        log/jocl-demos.artifact.properties \
        | sort -u > log/all.artifact.properties.sorted

    dos2unix log/aggregated.artifact.properties
    sort -u log/aggregated.artifact.properties > log/aggregated.artifact.properties.sorted

    diff -Nurbw log/aggregated.artifact.properties.sorted log/all.artifact.properties.sorted | tee log/all.artifact.properties.diff

    cd $rootdir

    prom_merge_modules $dest gluegen joal jogl jocl

    prom_cleanup $dest

    uri=gluegen_$bgluegenslave-joal_$bjoalslave-jogl_$bjoglslave-jocl_$bjoclslave
    url=http://jogamp.org/deployment/archive/$branch/gluegen_$bgluegenslave-joal_$bjoalslave-jogl_$bjoglslave-jocl_$bjoclslave
    wsdir=$archivedir/gluegen_$bgluegenslave-joal_$bjoalslave-jogl_$bjoglslave-jocl_$bjoclslave

    rm -rf $wsdir
    mv $dest $wsdir

    cd $wsdir

    copy_relocate_jnlps_base  $version $url $wsdir
    copy_relocate_jnlps_demos $version $url $wsdir joal-demos
    copy_relocate_jnlps_demos $version $url $wsdir jogl-demos
    copy_relocate_jnlps_demos $version $url $wsdir jocl-demos

    if [ $secure -ne 1 ] ; then
        remove_security_tag_jnlps $wsdir
    fi

    echo
    echo Aggregation folder $wsdir for URL $url
    echo

    cp -av ../util/unsigned/applet-launcher.jar jar/
    cp -av ../util/unsigned/junit.* jar/

    local OK=1
    grep ERROR $logfile && OK=0
    if [ $OK -eq 0 ] ; then
        echo ERRORS occured - please check $logfile for ERROR
    else
        echo NO ERRORS detected
    fi

    mv $logfile $wsdir/log/
}

rm -f $logfile
promote-latest-builds 2>&1 | tee $logfile


