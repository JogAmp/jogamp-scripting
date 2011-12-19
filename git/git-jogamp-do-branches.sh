#! /bin/sh

branchfile=$1
shift
remote=$1
shift

if [ -z "$branchfile" -o -z "$remote" ] ; then 
    echo Usage $0 branchfile remote
    echo branchfile containing branchnames without ref path
    echo remote is your remote repo
    exit 1
fi

for j in gluegen  joal  joal-demos  jocl  jocl-demos  jogl  jogl-demos ; do
    cd $j
    echo 
    echo MODULE $j
    echo
    for i in `cat $branchfile` ; do 
        git checkout --track -b $i $remote/$i 
        git checkout master 
    #    git branch -r -D $i 
    done
    cd ..
done
