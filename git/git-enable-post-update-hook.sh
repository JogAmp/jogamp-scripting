#! /bin/bash

gitinstall=/opt-linux-x86_64
thisdir=`pwd`

for i in *.git ; do 
    echo $i 
    cp -av $gitinstall/share/git-core/templates/hooks/post-update.sample $i/hooks/post-update
    cd $i
    git update-server-info
    cd $thisdir
done
