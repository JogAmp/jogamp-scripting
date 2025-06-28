#! /bin/bash

sdir=`readlink -f $0`
sdir=`dirname $sdir`

for i in gluegen jcpp joal joal-demos jogl oculusvr-sdk jogl-demos jocl jocl-demos ; do 
    cd $i
    echo
    echo MODULE $i
    echo
    . $sdir/git-jogamp-push.sh $*
    cd ..
done
