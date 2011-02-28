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

sdir=`dirname $0`

thisdir=`pwd`

logfile=$thisdir/`basename $0 .sh`.log

. $sdir/funcs_promotion.sh
. $sdir/../deployment/funcs_jnlp_relocate.sh

archivedir=/srv/www/jogamp.org/deployment/archive/$branch
rootdir=/srv/www/jogamp.org/deployment/autobuilds/$branch

os_and_archs_minus_one="linux-i586 macosx-universal windows-amd64 windows-i586"
masterpick="linux-amd64"
os_and_archs="$masterpick linux-i586 macosx-universal windows-amd64 windows-i586"

dest=tmp-archive

cd $rootdir

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
    prom_setup $rootdir $dest

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
    echo "gluegen.build.number=$bgluegenslave" >> $dest/aggregated.artifact.properties

    prom_promote_files gluegen $gluegenslave $dest gluegen

    cp -a $gluegenmaster/artifact.properties $dest/javadoc/gluegen-master.artifact.properties
    cp -a $gluegenmaster/javadoc.7z $dest/gluegen-javadoc.7z
    cd $dest/javadoc
    echo "INFO: gluegen master gluegen-javadoc 7z"
    prom_extract ../gluegen-javadoc.7z gluegen
    cd $rootdir

    joalslave=`prom_lslatest joal-b`
    bjoalslave=`prom_buildnumber_2 $joalslave`
    echo
    echo JOAL
    echo
    echo slave  build $bjoalslave - $joalslave
    echo
    echo "joal.build.number=$bjoalslave" >> $dest/aggregated.artifact.properties

    prom_promote_files joal $joalslave $dest joal
    
    cp -a $joalslave/javadoc.7z $dest/joal-javadoc.7z
    cd $dest/javadoc
    prom_extract ../joal-javadoc.7z joal
    cd $rootdir

    joaldemosslave=`prom_lslatest joal-demos-b`
    bjoaldemosslave=`prom_buildnumber_3 $joaldemosslave`
    echo
    echo JOAL DEMOS
    echo
    echo slave   build $bjoaldemosslave - $joaldemosslave
    echo
    echo "joal-demos.build.number=$bjoaldemosslave" >> $dest/aggregated.artifact.properties

    cp -a $joaldemosslave/joal-demos*.7z $dest/
    cp -a $joaldemosslave/artifact.properties $dest/joal-demos.artifact.properties
    cd $dest

    fname=`find . -name joal-demos\*$masterpick.7z`
    bname=`basename $fname .7z`
    mkdir joal-demos
    cd joal-demos
    echo "INFO: extract $fname -> $bname"
    prom_extract ../$bname.7z $bname
    mv $bname/jar/* .
    mv $bname/jnlp-files .
    mv $bname/www .
    echo "INFO: delete folder $bname"
    rm -rf $bname
    cd $rootdir

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
    echo "jogl.build.number=$bjoglslave" >> $dest/aggregated.artifact.properties

    prom_promote_files jogl $joglslave $dest nativewindow jogl newt

    cp -a $joglmaster/artifact.properties $dest/javadoc/jogl-master.artifact.properties
    cp -a $joglmaster/javadoc.7z $dest/jogl-javadoc.7z
    cd $dest/javadoc
    prom_extract ../jogl-javadoc.7z jogl
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
    echo "jogl-demos.build.number=$bjogldemosslave" >> $dest/aggregated.artifact.properties
    echo "jogl-demos.build.number=$bjogldemosmaster" >> $dest/aggregated.artifact.properties

    cp -a $jogldemosmaster/jogl-demos*.7z $dest/
    cp -a $jogldemosslave/artifact.properties $dest/jogl-demos.artifact.properties
    grep jogl-demos.build.branch $jogldemosmaster/artifact.properties >> jogl-demos.artifact.properties
    grep jogl-demos.build.commit $jogldemosmaster/artifact.properties >> jogl-demos.artifact.properties
    cd $dest

    fname=`find . -name jogl-demos\*$masterpick.7z`
    bname=`basename $fname .7z`
    mkdir jogl-demos
    cd jogl-demos
    echo "INFO: extract $fname -> $bname"
    prom_extract ../$bname.7z $bname
    mv $bname/jar/* .
    mv $bname/jnlp-files .
    mv $bname/www .
    echo "INFO: delete folder $bname"
    rm -rf $bname
    cd $rootdir

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
    echo "jocl.build.number=$bjoclslave" >> $dest/aggregated.artifact.properties

    prom_promote_files jocl $joclslave $dest jocl
    
    cp -a $joclmaster/artifact.properties $dest/javadoc/jocl-master.artifact.properties
    cp -a $joclmaster/jocl-javadoc.7z $dest/jocl-javadoc.7z
    cd $dest/javadoc
    prom_extract ../jocl-javadoc.7z jocl
    cd $rootdir

    jocldemosslave=`prom_lslatest jocl-demos-b`
    bjocldemosslave=`prom_buildnumber_3 $jocldemosslave`
    echo
    echo JOCL DEMOS
    echo
    echo slave  build $bjocldemosslave - $jocldemosslave
    echo
    echo "jocl-demos.build.number=$bjocldemosslave" >> $dest/aggregated.artifact.properties

    cp -a $jocldemosslave/jocl-demos*7z $dest/
    cp -a $jocldemosslave/artifact.properties $dest/jocl-demos.artifact.properties
    cd $dest

    fname=`find . -name jocl-demos\*$masterpick.7z`
    bname=`basename $fname .7z`
    mkdir jocl-demos
    cd jocl-demos
    echo "INFO: extract $fname -> $bname"
    prom_extract ../$bname.7z $bname
    mv $bname/jar/* .
    mv $bname/jnlp-files .
    mv $bname/www .
    echo "INFO: delete folder $bname"
    rm -rf $bname
    cd $rootdir


    #########################################################
    ## Integrity Check, Cleanup, aggregation.properties
    #########################################################

    prom_integrity_check $dest
    prom_integrity_check $dest/joal-demos
    prom_integrity_check $dest/jogl-demos
    prom_integrity_check $dest/jocl-demos

    prom_cleanup $dest

    uri=gluegen_$bgluegenslave-joal_$bjoalslave-jogl_$bjoglslave-jocl_$bjoclslave
    url=http://jogamp.org/deployment/archive/$branch/gluegen_$bgluegenslave-joal_$bjoalslave-jogl_$bjoglslave-jocl_$bjoclslave
    wsdir=$archivedir/gluegen_$bgluegenslave-joal_$bjoalslave-jogl_$bjoglslave-jocl_$bjoclslave

    rm -rf $wsdir
    mv $dest $wsdir

    cd $wsdir

    echo
    echo aggregation.properties
    echo
    dos2unix gluegen.artifact.properties
    dos2unix joal.artifact.properties
    dos2unix joal-demos.artifact.properties
    dos2unix jogl.artifact.properties
    dos2unix jogl-demos.artifact.properties
    dos2unix jocl.artifact.properties
    dos2unix jocl-demos.artifact.properties
    cat gluegen.artifact.properties    \
        joal.artifact.properties       \
        joal-demos.artifact.properties \
        jogl.artifact.properties       \
        jogl-demos.artifact.properties \
        jocl.artifact.properties       \
        jocl-demos.artifact.properties \
        | sort -u > all.artifact.properties.sorted

    dos2unix aggregated.artifact.properties
    sort -u aggregated.artifact.properties > aggregated.artifact.properties.sorted

    diff -Nurbw aggregated.artifact.properties.sorted all.artifact.properties.sorted | tee all.artifact.properties.diff

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

    local OK=1
    grep ERROR $logfile && OK=0
    if [ $OK -eq 0 ] ; then
        echo ERRORS occured - please check $logfile for ERROR
    else
        echo NO ERRORS detected
    fi

    cp -av $logfile $wsdir
}

promote-latest-builds 2>&1 | tee $logfile


