#! /bin/bash

branch=rc
tag_old=v2.0-rc9
tag=v2.0-rc10

sdir=`dirname $0`
thisdir=`pwd`

. $sdir/funcs_git.sh

for i in gluegen joal joal-demos jogl jogl-demos jocl jocl-demos ; do
    cd $i
    git checkout $branch
    git pull jogamp $branch
    git-new-milestone $i $tag_old $tag
    cd $thisdir
    echo done $i
    echo
done
