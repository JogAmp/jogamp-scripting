#! /bin/sh

for j in gluegen  joal  joal-demos  jocl  jocl-demos  jogl  jogl-demos ; do
    cd $j
    echo 
    echo MODULE $j
    echo
    git clone -o jogamp -b master file:///srv/scm/$j.git
done
