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
        mkdir $ldest/archive/jogamp-$i
        mkdir $ldest/archive/jogamp-$i/test-results/
    done
    mkdir $ldest/jar
    mkdir $ldest/jar/atomic
    mkdir $ldest/javadoc
    mkdir $ldest/jnlp-files
    mkdir $ldest/log
    mkdir $ldest/resources
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

function prom_merge_modules() {
    local destdir=$1
    shift
    local modules=$*

    local lthisdir=`pwd`

    echo "INFO: Mergin modules <$modules>"
    cd $destdir

    for i in $os_and_archs ; do
        local mergefolder=jogamp-$i
        cd tmp
        mkdir $mergefolder
        for j in $modules ; do
            local modulefolder=`find . -name $j\*$i`
            if [ -z "$modulefolder" ] ; then
                echo "ERROR: No module/platform extracted folder module $j, platform $i"
                exit 1
            fi
            cd $modulefolder
            for k in artifact.properties LICENSE.txt README.txt ; do
                if [ -e $k ] ; then
                    mv -v $k ../$mergefolder/$j.$k
                fi
            done
            for k in \*-java-src.zip ; do
                if [ -e $k ] ; then
                    mv -v $k ../$mergefolder/
                fi
            done
            for k in etc jar jnlp-files lib ; do
                if [ -e $k ] ; then
                    mkdir -p ../$mergefolder/$k
                    mv -v $k/* ../$mergefolder/$k/
                fi
            done
            cd ..
        done
        cp -av ../log/aggregated.artifact.properties.sorted ../log/all.artifact.properties.sorted $mergefolder/
        echo "INFO: Create merged jogamp archive $mergefolder.7z"
        7z a -r ../archive/$mergefolder.7z $mergefolder
        cd ..
    done

    cd $lthisdir
}

# 
# #1 module name, IE gluegen, jogl, jocl or joal
# #2 source folder of artifacts
# #3 destination folder of artifacts
#
# Example:
# promote_files gluegen /builds/gluegen-b33 tmp-archive
# promote_files jogl    /builds/jogl-b211   tmp-archive
#
function prom_promote_module() {
    local module=$1
    shift
    local sourcedir=$1
    shift
    local destdir=$1

    local lthisdir=`pwd`

    echo "INFO: Promoting files: $module, from $sourcedir"
    # copy the platform 7z files
    cp -a $sourcedir/artifact.properties $destdir/log/$module.artifact.properties
    cd $destdir
    # unpack the platform 7z files
    for i in $os_and_archs ; do
        local sfile=`find $lthisdir/$sourcedir -name $module\*$i.7z`
        if [ -z "$sfile" ] ; then
            echo "ERROR: No platform 7z file for module $module, platform $i, sdir $sourcedir"
            exit 1
        fi
        local zfile=archive/jogamp-$i/$module-$i.7z

        cp -a $sfile $zfile
        cp -a $lthisdir/$sourcedir/$module*$i-test-results-*.7z archive/jogamp-$i/test-results/
        local sfolder=`basename $sfile .7z`
        local zfolder=`basename $zfile .7z`
        echo "INFO: extract $module $i - $zfile -> tmp/$zfolder"
        cd tmp
        prom_extract ../$zfile $sfolder
        mv -v $sfolder $zfolder
        cd ..
        prom_verify_artifacts $module log/$module.artifact.properties tmp/$zfolder/artifact.properties
    done
    # copy the platform JAR files from each platform 7z folder
    for i in $os_and_archs_minus_one ; do
        # 7z folder verfified above already
        local zfile=archive/jogamp-$i/$module-$i.7z
        local zfolder=tmp/`basename $zfile .7z`
        for j in $zfolder/jar/*.jar ; do
            cp -av $j ./jar/
        done
        if [ -e $zfolder/jar/atomic ] ; then
            for j in $zfolder/jar/atomic/*.jar ; do
                cp -av $j ./jar/atomic/
            done
        fi
    done
    # copy the master pic JAR files
    # 7z folder verfified above already
    local zfile=archive/jogamp-$masterpick/$module-$masterpick.7z
    local zfolder=tmp/`basename $zfile .7z`
    for j in $zfolder/jar/*.jar ; do
        cp -av $j ./jar/
        if [ -e $zfolder/jar/atomic ] ; then
            for j in $zfolder/jar/atomic/*.jar ; do
                cp -av $j ./jar/atomic/
            done
        fi
    done
    cp -av $zfolder/jnlp-files/* ./jnlp-files/
    if [ -e $zfolder/resources ] ; then
        cp -av $zfolder/resources/* ./resources/
    fi

    cd $lthisdir
}

function prom_promote_demos() {
    local module=$1
    shift
    local sourcetype=$1
    shift
    local sourcedir=$1
    shift
    local destdir=$1

    local lthisdir=`pwd`

    local fromslave=false
    [ "$sourcetype" = "slave" ] && local fromslave=true

    echo "INFO: Promoting files: $module from $sourcedir (from-slave $fromslave)"
    # copy the platform 7z files
    cd $destdir
    # unpack the 7z files
    local sfile=`find $lthisdir/$sourcedir -name $module\*$masterpick.7z`
    local zfile=archive/$module.7z
    if [ -z "$sfile" ] ; then
        echo "ERROR: No 7z file for module $module, sdir $sourcedir"
        exit 1
    fi
    cp -av $sfile $zfile
    local sfolder=`basename $sfile .7z`
    local zfolder=`basename $zfile .7z`
    echo "INFO: extract $module - $zfile -> tmp/$zfolder"
    cd tmp
    prom_extract ../$zfile $sfolder
    mv -v $sfolder $zfolder
    cd ..
    if $fromslave ; then
        prom_verify_artifacts $module log/$module.artifact.properties tmp/$zfolder/artifact.properties
    fi

    # copy the JAR files
    mkdir $module
    cp -av tmp/$zfolder/jar        ./$module/
    cp -av tmp/$zfolder/jnlp-files ./$module/
    cp -av tmp/$zfolder/www        ./$module/
    if [ -e tmp/$zfolder/resources ] ; then
        cp -av tmp/$zfolder/resources ./$module/
    fi

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
    rm -rf tmp
    cd $lthisdir
}

function prom_integrity_check() {
    local destdir=$1
    shift
    local jardir=$1
    shift
    local tmpdir=$1
    shift

    local lthisdir=`pwd`
    cd $destdir

    mkdir -p $tmpdir
    cd $tmpdir
    for i in $lthisdir/$destdir/$jardir/*.jar ; do
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

