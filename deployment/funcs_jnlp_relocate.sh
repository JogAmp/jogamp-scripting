#! /bin/bash

function copy_relocate_jnlps_base() {

local version=$1
shift

local url=$1
shift

local wsdir=$1
shift 

if [ -z "$version" -o -z "$url" -o -z "$wsdir" ] ; then
    echo usage $0 version codebase-url webstartdir
    echo Examples
    echo    sh $0 v2.0-rc2 file:////usr/local/projects/JOGL/webstart ../../webstart
    echo    sh $0 v2.0-rc2 http://domain.org/jogl/webstart /srv/www/webstart-next
    exit 1
fi

if [ ! -e $wsdir ] ; then
    echo $wsdir does not exist
    exit 1
fi

local jnlpdir=$wsdir/jnlp-files

if [ ! -e $jnlpdir ] ; then
    echo $jnlpdir does not exist
    exit 1
fi

cp -v $jnlpdir/*.html $wsdir

local uri_esc=`echo $url | sed 's/\//\\\\\//g'`
for j in $jnlpdir/*.jnlp ; do
    local jb=`basename $j`
    echo "processing $j to $wsdir/$jb"

    sed \
        -e "s/JOGAMP_VERSION/$version/g" \
        -e "s/GLUEGEN_CODEBASE_TAG/$uri_esc/g" \
        -e "s/JOAL_CODEBASE_TAG/$uri_esc/g" \
        -e "s/JOGL_CODEBASE_TAG/$uri_esc/g" \
        -e "s/JOCL_CODEBASE_TAG/$uri_esc/g" \
        $j > $wsdir/$jb
done

}

function copy_relocate_jnlps_demos() {

local version=$1
shift

local url=$1
shift

local wsdir=$1
shift 

local demos_rel=$1
shift

if [ -z "$version" -o -z "$url" -o -z "$wsdir" -o -z "$demos_rel" ] ; then
    echo usage $0 version codebase-url webstartdir demos_rel
    echo Examples
    echo    sh $0 v2.0-rc2 file:////usr/local/projects/JOGL/webstart ../../webstart demos
    echo    sh $0 v2.0-rc2 http://domain.org/jogl/webstart /srv/www/webstart-next demos
    exit 1
fi

if [ ! -e $wsdir ] ; then
    echo $wsdir does not exist
    exit 1
fi

local demos=$wsdir/$demos_rel

if [ ! -e $demos ] ; then
    echo $demos does not exist
    exit 1
fi

local url_demos=$url/$demos_rel
local jnlpdir=$demos/jnlp-files

if [ ! -e $jnlpdir ] ; then
    echo $jnlpdir does not exist
    exit 1
fi

cp -v $jnlpdir/*.html $demos

local uri_esc=`echo $url | sed 's/\//\\\\\//g'`
local uri_demos_esc=`echo $url_demos | sed 's/\//\\\\\//g'`
for j in $jnlpdir/*.jnlp ; do
    local jb=`basename $j`
    echo "processing $j to $demos/$jb"

    sed \
        -e "s/JOGAMP_VERSION/$version/g" \
        -e "s/GLUEGEN_CODEBASE_TAG/$uri_esc/g" \
        -e "s/JOAL_CODEBASE_TAG/$uri_esc/g" \
        -e "s/JOGL_CODEBASE_TAG/$uri_esc/g" \
        -e "s/JOCL_CODEBASE_TAG/$uri_esc/g" \
        -e "s/DEMO_CODEBASE_TAG/$uri_demos_esc/g" \
        $j > $demos/$jb
done

}

function remove_security_tag_jnlps() {

local wsdir=$1
shift 

if [ -z "$wsdir" ] ; then
    echo usage $0 webstartdir
    exit 1
fi

if [ ! -e $wsdir ] ; then
    echo $wsdir does not exist
    exit 1
fi

cd $wsdir

for i in *.jnlp ; do
    sed -i -e 's/<security>//g' -e 's/<\/security>//g' -e 's/<all-permissions\/>//g' $i
done

}

