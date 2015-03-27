#! /bin/bash

branch=master
tag_old=v2.3.0
tag=v2.3.1

sdir=`dirname $0`
thisdir=`pwd`

. $sdir/funcs_git.sh

for i in gluegen jcpp joal joal-demos jogl oculusvr-sdk jogl-demos jocl jocl-demos ; do
    cd $i
    git checkout $branch
    git pull jogamp $branch
    git-new-milestone $i $tag_old $tag
    cd $thisdir
    echo done $i
    echo
done
