#! /bin/bash

sdir=`dirname $0`

for i in gluegen jcpp joal joal-demos jogl oculusvr-sdk jogl-demos jocl jocl-demos ; do 
    cd $i
    echo
    echo MODULE $i
    echo
    . $sdir/git-jogamp-push.sh $*
    cd ..
done
