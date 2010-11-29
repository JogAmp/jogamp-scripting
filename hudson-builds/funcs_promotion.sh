#! /bin/bash


function prom_setup() {
    lrootdir=$1
    shift
    ldest=$1
    shift

    lthisdir=`pwd`
    cd $lrootdir

    rm -rf $ldest
    mkdir $ldest
    mkdir $ldest/javadoc
    mkdir $ldest/jnlp-files

    cd $lthisdir
}

function prom_lslatest() {
    pattern=$1
    shift
    ls -rt  | grep $pattern | tail -1
}

function prom_buildnumber_2() {
    folder=$1
    shift
    echo $folder | awk -F '-' ' { print substr($2, 2); } '
}

function prom_buildnumber_3() {
    folder=$1
    shift
    echo $folder | awk -F '-' ' { print substr($3, 2); } '
}

function prom_buildnumber_4() {
    folder=$1
    shift
    echo $folder | awk -F '-' ' { print substr($4, 2); } '
}

function prom_verify_artifacts() {
    name=$1
    shift
    artia=$1
    shift
    artib=$1
    shift

    OK=0
    diff -w $artia $artib && OK=1
    if [ $OK -eq 0 ] ; then
        echo "ERROR: $name artifacts differ $artia and $artib"
    fi
}

# 
# #1 module name, IE gluegen, jogl, jocl or joal
# #2 source folder of artifacts
# #3 destination folder of artifacts
# #4-n submodule name within the ZIP files
#
# Example:
# promote_files gluegen /builds/gluegen-b33 tmp-archive gluegen
# promote_files jogl    /builds/jogl-b211   tmp-archive nativewindow jogl newt
#
function prom_promote_files() {
    module=$1
    shift
    sourcedir=$1
    shift
    destdir=$1
    shift
    submodules=$*

    lthisdir=`pwd`

    echo "INFO: Promoting files: $module, submodules <$submodules>, from $sourcedir"
    # copy the platform zip files
    cp -a $sourcedir/$module*.zip $destdir/
    cp -a $sourcedir/artifact.properties $destdir/$module.artifact.properties
    cd $destdir
    # unpack the platform zip files
    for i in $os_and_archs ; do
        zfile=`find . -name $module\*$i.zip`
        if [ -z "$zfile" ] ; then
            echo "ERROR: No platform ZIP file for module $module, sub $sub, platform $i, sdir $sourcedir"
            exit 1
        fi
        zfolder=`basename $zfile .zip`
        echo "INFO: unzip $module $i - $zfile -> $zfolder"
        unzip -q $zfile
        prom_verify_artifacts $module $module.artifact.properties $zfolder/artifact.properties
    done
    # copy the platform JAR files from each platform zip folder
    for i in $os_and_archs_minus_one ; do
        # zip folder verfified above already
        zfile=`find . -name $module\*$i.zip`
        zfolder=`basename $zfile .zip`
        for sub in $submodules ; do
            jars=`find $zfolder -name $sub\*$i\*.jar`
            if [ -z "$jars" ] ; then
                echo "ERROR: No platform JAR file for module $module, sub $sub, platform $i, sdir $sourcedir"
                exit 1
            fi
            for j in $jars ; do 
                cp -av $j .
            done
        done
    done
    # copy the master pic JAR files
    # zip folder verfified above already
    zfile=`find . -name $module\*$masterpick.zip`
    zfolder=`basename $zfile .zip`
    for sub in $submodules ; do
        jars=`find $zfolder -name $sub\*$masterpick\*.jar`
        if [ -z "$jars" ] ; then
            echo "ERROR: No platform JAR file for module $module, sub $sub, masterpick platform $masterpick, sdir $sourcedir"
            exit 1
        fi
        jars=`find $zfolder -name $sub\*.jar`
        if [ -z "$jars" ] ; then
            echo "ERROR: No JAR files for module $module, sub $sub, masterpick $masterpick, sdir $sourcedir"
            exit 1
        fi
        for j in $jars ; do 
            cp -av $j .
        done
    done
    cp -av $zfolder/jnlp-files/* ./jnlp-files/

    cd $lthisdir
}

function prom_cleanup() {
    destdir=$1
    shift

    lthisdir=`pwd`
    cd $destdir

    for i in $os_and_archs ; do
        for j in *$i.zip ; do
            bname=`basename $j .zip`
            if [ -d $bname ] ; then
                echo "INFO: delete folder $bname"
                rm -rf $bname
            fi
        done
    done
    cd $lthisdir
}

function prom_integrity_check() {
    destdir=$1
    shift

    lthisdir=`pwd`
    cd $destdir

    mkdir dump
    cd dump
    for i in ../*.jar ; do
        bname=`basename $i`
        echo -n "INFO: integrity check - $bname - "
        OK=0
        jar xvf $i >& $bname.log && OK=1
        if [ $OK -eq 0 ] ; then
            echo ERROR
            cat $bname.log
        else
            echo OK
        fi
    done
    echo
    cd ..
    rm -rf dump
    cd $lthisdir
}

