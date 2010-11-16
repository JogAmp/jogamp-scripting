#! /bin/bash

##
#
# Will end up with an aggregated folder, webstart enabled,
# but not pack200 compressed and not signed.
#
##

sdir=`dirname $0`

thisdir=`pwd`

logfile=$thisdir/`basename $0 .sh`.log

. $sdir/funcs_promotion.sh
. $sdir/../deployment/funcs_jnlp_relocate.sh

archivedir=/srv/www/jogamp.org/deployment/archive
rootdir=/srv/www/jogamp.org/deployment/autobuilds

os_and_archs_minus_one="linux-i586 macosx-universal windows-amd64 windows-i586"
masterpick="linux-amd64"
os_and_archs="$masterpick linux-i586 macosx-universal windows-amd64 windows-i586"

dest=tmp-archive

cd $rootdir

function promote-latest-builds() {
    echo
    echo "Promotion of latest files"
    echo `date`
    echo
    prom_setup $rootdir $dest

    mkdir $dest/javadoc

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
    cp -a $gluegenmaster/javadoc.zip $dest/javadoc/gluegen-javadoc.zip
    cd $dest/javadoc
    echo "INFO: gluegen master gluegen-javadoc zip"
    unzip -q gluegen-javadoc.zip
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
    cp -a $joglmaster/javadoc.zip $dest/javadoc/jogl-javadoc.zip
    cd $dest/javadoc
    unzip -q jogl-javadoc.zip
    cd $rootdir

    jogldemosmaster=`prom_lslatest jogl-demos-master-b`
    bjogldemosmaster=`prom_buildnumber_4 $jogldemosmaster`
    echo
    echo JOGL DEMOS
    echo
    echo master  build $bjogldemosmaster - $jogldemosmaster
    echo
    echo "jogl-demos.build.number=$bjogldemosmaster" >> $dest/aggregated.artifact.properties

    cp -a $jogldemosmaster/jogl-demos*.zip $dest/
    cp -a $jogldemosmaster/artifact.properties $dest/jogl-demos.artifact.properties
    cd $dest

    fname=`find . -name jogl-demos*.zip`
    bname=`basename $fname .zip`
    echo "INFO: unzip $fname -> $bname"
    unzip -q $bname.zip
    prom_verify_artifacts jogl-demos jogl-demos.artifact.properties $bname/artifact.properties
    cp -a $bname/jar/*.jar .
    cp -a $bname/jnlp-files/* ./jnlp-files/
    cp -a $bname/www/* ./www/

    cd $rootdir

    #########################################################
    ####### FIXME : JOCL, adapt to the new archive structure 
    #########################################################

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

    #
    #prom_promote_files jocl $joglslave $dest jocl
    #

    cp -a $joclslave/jocl*jar $dest/
    cp -a $joclslave/artifact.properties $dest/jocl.artifact.properties

    cp -a $joclmaster/artifact.properties $dest/javadoc/jocl-master.artifact.properties
    mkdir $dest/javadoc/jocl
    cp -a $joclmaster/jocl-javadoc.zip $dest/javadoc/jocl/
    cd $dest/javadoc/jocl
    echo "INFO: unzip jocl-javadoc zip"
    unzip -q jocl-javadoc.zip
    cd $rootdir

    jocldemosslave=`prom_lslatest jocl-demos-b`
    bjocldemosslave=`prom_buildnumber_3 $jocldemosslave`
    echo
    echo JOCL DEMOS
    echo
    echo slave  build $bjocldemosslave - $jocldemosslave
    echo
    echo "jocl-demos.build.number=$bjocldemosslave" >> $dest/aggregated.artifact.properties

    cp -a $jocldemosslave/jocl-demos*jar $dest/
    cp -a $jocldemosslave/artifact.properties $dest/jocl-demos.artifact.properties

    prom_integrity_check $dest

    prom_cleanup $dest

    uri=gluegen_$bgluegenslave-jogl_$bjoglslave-jocl_$bjoclslave
    url=http://jogamp.org/deployment/archive/gluegen_$bgluegenslave-jogl_$bjoglslave-jocl_$bjoclslave
    wsdir=$archivedir/gluegen_$bgluegenslave-jogl_$bjoglslave-jocl_$bjoclslave

    rm -rf $wsdir
    mv $dest $wsdir

    cd $wsdir

    echo
    echo aggregation.properties
    echo
    cat jocl-demos.artifact.properties jogl-demos.artifact.properties | sort -u > jocl-demos-jogl-demos.artifact.properties.sorted
    sort -u aggregated.artifact.properties > aggregated.artifact.properties.sorted
    diff -Nurbw aggregated.artifact.properties.sorted jocl-demos-jogl-demos.artifact.properties.sorted

    copy_relocate_jnlps $url $wsdir

    remove_security_tag_jnlps $wsdir

    echo
    echo Aggregation folder $wsdir for URL $url
    echo

    cp -av $logfile $wsdir
}

promote-latest-builds 2>&1 | tee $logfile


