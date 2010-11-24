#! /bin/bash

#
# wsdir_jars_repack  <wsdir>
# wsdir_jars_pack200 <wsdir>
# wsdir_jars_sign    <wsdir> <pkcs12-keystore> <storepass> [signarg]
#

function wsdir_jars_repack() {

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

THISDIR=`pwd`

cd $wsdir

for i in *.jar ; do
    echo pack200 --repack $i
    pack200 --repack $i
done

cd $THISDIR

}

function wsdir_jars_pack200() {

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

THISDIR=`pwd`

cd $wsdir

mkdir -p DLLS
mv *natives*.jar DLLS/

for i in *.jar ; do
    echo pack200 -E9 $i.pack.gz $i
    pack200 -E9 $i.pack.gz $i
done

mv DLLS/* .

rm -rf DLLS

cd $THISDIR

}


function wsdir_jars_sign() {

wsdir=$1
shift 

keystore=$1
shift 

storepass=$1
shift 

signarg="$*"

if [ -z "$wsdir" -o -z "$keystore" -o -z "$storepass" ] ; then
    echo "usage $0 webstartdir pkcs12-keystore storepass [signarg]"
    exit 1
fi

if [ ! -e $wsdir ] ; then
    echo $wsdir does not exist
    exit 1
fi

if [ ! -e $keystore ] ; then
    echo $keystore does not exist
    exit 1
fi

THISDIR=`pwd`

cd $wsdir

rm -rf demo-jars
mkdir -p demo-jars
mv jogl.test.jar jogl-demos*jar jocl-demos.jar demo-jars/

for i in *.jar ; do
    echo jarsigner -storetype pkcs12 -keystore $keystore $i \"$signarg\"
    jarsigner -storetype pkcs12 -keystore $keystore -storepass $storepass $i "$signarg"
done

mv demo-jars/* .
rm -rf demo-jars

cd $THISDIR

}

