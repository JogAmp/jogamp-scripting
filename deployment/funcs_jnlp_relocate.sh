#! /bin/bash

function copy_relocate_jnlps() {

url=$1
shift

wsdir=$1
shift 

if [ -z "$url" -o -z "$wsdir" ] ; then
    echo usage $0 codebase-url webstartdir
    echo Examples
    echo    sh $0 file:////usr/local/projects/JOGL/webstart ../../webstart
    echo    sh $0 http://domain.org/jogl/webstart /srv/www/webstart-next
    exit 1
fi

if [ ! -e $wsdir ] ; then
    echo $wsdir does not exist
    exit 1
fi

jnlpdir=$wsdir/jnlp-files

if [ ! -e $jnlpdir ] ; then
    echo $jnlpdir does not exist
    exit 1
fi

cp -v $jnlpdir/*.html $wsdir

uri_esc=`echo $url | sed 's/\//\\\\\//g'`
for j in $jnlpdir/*.jnlp ; do
    jb=`basename $j`
    echo "processing $j to $wsdir/$jb"

    sed -e "s/JOGL_CODEBASE_TAG/$uri_esc/g" \
        -e "s/GLUEGEN_CODEBASE_TAG/$uri_esc/g" \
        -e "s/DEMO_CODEBASE_TAG/$uri_esc/g" \
        $j > $wsdir/$jb
done

}

function remove_security_tag_jnlps() {

wsdir=$1
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

