#! /bin/bash

artifacts=$1
shift

if [ -z "$artifacts" ] ; then
    echo Usage $0 artifacts file
    exit 1
fi

branch=master
tag_old=v2.1.0
tag=v2.1.1

sdir=`dirname $0`
thisdir=`pwd`

. $sdir/funcs_git.sh

for i in gluegen joal joal-demos jogl jogl-demos jocl jocl-demos ; do
    sha=`grep $i.build.commit $artifacts | awk --field-separator "=" ' { print $2 } ' `
    echo $i sha $sha
    cd $i
    git checkout $branch
    git pull jogamp $branch
    #git tag -d $tag
    git tag -s -u 0x8ED60127 -m "$tag" $tag $sha
    git-new-milestone $i $tag_old $tag
    git checkout master
    cd $thisdir
    echo done $i
    echo
done
