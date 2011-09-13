#! /bin/bash


function prom_setup() {
    local lrootdir=$1
    shift
    local ldest=$1
    shift

    local lthisdir=`pwd`
    cd $lrootdir

    rm -rf $ldest
    mkdir $ldest
    mkdir $ldest/archive
    for i in $os_and_archs ; do
        mkdir $ldest/archive/$i
        mkdir $ldest/archive/$i/test-results/
    done
    mkdir $ldest/jar
    mkdir $ldest/javadoc
    mkdir $ldest/jnlp-files
    mkdir $ldest/log
    mkdir $ldest/tmp

    cd $lthisdir
}

function prom_lslatest() {
    local pattern=$1
    shift
    ls -rt  | grep $pattern | tail -1
}

function prom_buildnumber_2() {
    local folder=$1
    shift
    echo $folder | awk -F '-' ' { print substr($2, 2); } '
}

function prom_buildnumber_3() {
    local folder=$1
    shift
    echo $folder | awk -F '-' ' { print substr($3, 2); } '
}

function prom_buildnumber_4() {
    local folder=$1
    shift
    echo $folder | awk -F '-' ' { print substr($4, 2); } '
}

function prom_verify_artifacts() {
    local name=$1
    shift
    local artia=$1
    shift
    local artib=$1
    shift

    local OK=0
    diff -w $artia $artib && OK=1
    if [ $OK -eq 0 ] ; then
        echo "ERROR: $name artifacts differ $artia and $artib"
    fi
}

# 
# #1 module name, IE gluegen, jogl, jocl or joal
# #2 source folder of artifacts
# #3 destination folder of artifacts
# #4-n submodule name within the 7z files
#
# Example:
# promote_files gluegen /builds/gluegen-b33 tmp-archive gluegen
# promote_files jogl    /builds/jogl-b211   tmp-archive nativewindow jogl newt
#
function prom_promote_files() {
    local module=$1
    shift
    local sourcedir=$1
    shift
    local destdir=$1
    shift
    local submodules=$*

    local lthisdir=`pwd`

    echo "INFO: Promoting files: $module, submodules <$submodules>, from $sourcedir"
    # copy the platform 7z files
    cp -a $sourcedir/artifact.properties $destdir/log/$module.artifact.properties
    cd $destdir
    # unpack the platform 7z files
    for i in $os_and_archs ; do
        cp -a $sourcedir/$module*$i.7z                archive/$i/
        cp -a $sourcedir/$module*$i-test-results-*.7z archive/$i/test-results/
        local zfile=`find . -name archive/$i/$module\*$i.7z`
        if [ -z "$zfile" ] ; then
            echo "ERROR: No platform 7z file for module $module, sub $sub, platform $i, sdir $sourcedir"
            exit 1
        fi
        local zfolder=tmp/`basename $zfile .7z`
        echo "INFO: extract $module $i - $zfile -> $zfolder"
        prom_extract $zfile $zfolder
        prom_verify_artifacts $module log/$module.artifact.properties $zfolder/artifact.properties
    done
    # copy the platform JAR files from each platform 7z folder
    for i in $os_and_archs_minus_one ; do
        # 7z folder verfified above already
        local zfile=`find archive/$i -name $module\*$i.7z`
        local zfolder=tmp/`basename $zfile .7z`
        for sub in $submodules ; do
            jars=`find $zfolder -name $sub\*$i\*.jar`
            if [ -z "$jars" ] ; then
                echo "ERROR: No platform JAR file for module $module, sub $sub, platform $i, sdir $sourcedir"
                exit 1
            fi
            for j in $jars ; do 
                cp -av $j ./jar/
            done
        done
    done
    # copy the master pic JAR files
    # 7z folder verfified above already
    local zfile=`find archive/$masterpick -name $module\*$masterpick.7z`
    local zfolder=tmp/`basename $zfile .7z`
    for sub in $submodules ; do
        local jars=`find $zfolder -name $sub\*$masterpick\*.jar`
        if [ -z "$jars" ] ; then
            echo "ERROR: No platform JAR file for module $module, sub $sub, masterpick platform $masterpick, sdir $sourcedir"
            exit 1
        fi
        local jars=`find $zfolder -name $sub\*.jar`
        if [ -z "$jars" ] ; then
            echo "ERROR: No JAR files for module $module, sub $sub, masterpick $masterpick, sdir $sourcedir"
            exit 1
        fi
        for j in $jars ; do 
            cp -av $j ./jar/
        done
    done
    cp -av $zfolder/jnlp-files/* ./jnlp-files/

    cd $lthisdir
}

function prom_extract() {
    local zfile=$1
    shift

    local OK=0
    7z x $zfile $* && OK=1
    if [ $OK -eq 0 ] ; then
        echo ERROR in 7z file $zfile $*
    else
        echo OK 7z file $zfile $*
        if [ ! -z "$*" ] ; then
            chmod 755 $*
        fi
    fi
}

function prom_cleanup() {
    local destdir=$1
    shift

    local lthisdir=`pwd`
    cd $destdir

    echo "INFO: delete tmp folder"
    # rm -rf tmp
    cd $lthisdir
}

function prom_integrity_check() {
    local jardir=$1
    shift
    local destdir=$1
    shift

    local lthisdir=`pwd`
    cd $destdir

    mkdir tmp/dump
    cd tmp/dump
    for i in $lthisdir/$jardir/*.jar ; do
        local bname=`basename $i`
        echo -n "INFO: integrity check - $bname - "
        local OK=0
        jar xvf $i >& $bname.log && OK=1
        if [ $OK -eq 0 ] ; then
            echo ERROR
            cat $bname.log
        else
            echo OK
        fi
    done
    echo
    cd $lthisdir
}

