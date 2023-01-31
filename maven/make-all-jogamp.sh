#! /bin/bash

# e.g. /srv/www/jogamp.org/deployment/archive/master/gluegen_950-joal_668-jogl_1514-jocl_1154/archive/jogamp-all-platforms.7z
archive=$1
shift

# e.g. 2.4.0-rc-20230123
version=$1
shift

if [ -z "${archive}" -o -z "${version}" ] ; then
    echo "Usage $0 <full-path/jogamp-all-platforms.7z> <version>"
    exit 1
fi

if [ ! -e ${archive} ] ; then
    echo "Archive ${archive} not existing"
    exit 1
fi

logfile=`basename $0 .sh`.log

function maven_it() {
    echo "Using archive ${archive}"
    echo "Using version ${version}"
    echo "Using logfile ${logfile}"

    cd
    cd jogamp-scripting
    git pull
    cd maven

    mkdir -p input
    cd input
    rm -rf *
    ln -s $archive .
    7z x jogamp-all-platforms.7z 
    cd ..

    ./make.sh ${version} && ./make-deploy-jogamp2.sh ${version}
}

maven_it 2>&1 | tee ${logfile}

