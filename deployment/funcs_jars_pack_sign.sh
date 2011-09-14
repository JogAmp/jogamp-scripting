#! /bin/bash

#
# wsdir_jars_repack  <wsdir>
# wsdir_jars_pack200 <wsdir>
# wsdir_jars_sign    <wsdir> <pkcs12-keystore> <storepass> [signarg]
#

function wsdir_jars_repack() {

local wsdir=$1
shift 

if [ -z "$wsdir" ] ; then
    echo usage $0 webstartdir
    exit 1
fi

if [ ! -e $wsdir/jar ] ; then
    echo $wsdir/jar does not exist
    exit 1
fi

local THISDIR=`pwd`

cd $wsdir/jar

if [ -z "$JOGAMP_DEPLOYMENT_NO_REPACK" ] ; then
  mkdir orig
  cp -a *jar orig/

  for i in *.jar ; do
    echo pack200 --repack $i
    pack200 --repack $i
  done
fi

if [ -e atomic ] ; then
    cd atomic
    if [ -z "$JOGAMP_DEPLOYMENT_NO_REPACK" ] ; then
      mkdir orig
      cp -a *jar orig/

      for i in *.jar ; do
        echo pack200 --repack $i
        pack200 --repack $i
      done
    fi

fi

cd $THISDIR

}

function wsdir_jars_pack200() {

local wsdir=$1
shift 

if [ -z "$wsdir" ] ; then
    echo usage $0 webstartdir
    exit 1
fi

if [ ! -e $wsdir/jar ] ; then
    echo $wsdir/jar does not exist
    exit 1
fi

local THISDIR=`pwd`

cd $wsdir/jar

if [ -z "$JOGAMP_DEPLOYMENT_NO_REPACK" ] ; then
  mkdir -p DLLS
  mv *natives*.jar DLLS/

  for i in *.jar ; do
    echo gzip -9 $i to $i.gz
    gzip -9 -cv $i > $i.gz
    echo pack200 -E9 $i.pack.gz $i
    pack200 -E9 $i.pack.gz $i
  done

  mv DLLS/* .
  rm -rf DLLS
fi

if [ -e atomic ] ; then
    cd atomic
    if [ -z "$JOGAMP_DEPLOYMENT_NO_REPACK" ] ; then
      mkdir -p DLLS
      mv *natives*.jar DLLS/

      for i in *.jar ; do
        echo gzip -9 $i to $i.gz
        gzip -9 -cv $i > $i.gz
        echo pack200 -E9 $i.pack.gz $i
        pack200 -E9 $i.pack.gz $i
      done

      mv DLLS/* .
      rm -rf DLLS
    fi
fi

cd $THISDIR

}


function wsdir_jars_sign() {

local wsdir=$1
shift 

local keystore=$1
shift 

local storepass=$1
shift 

local signarg="$*"

if [ -z "$wsdir" -o -z "$keystore" -o -z "$storepass" ] ; then
    echo "usage $0 webstartdir pkcs12-keystore storepass [signarg]"
    exit 1
fi

if [ ! -e $wsdir/jar ] ; then
    echo $wsdir/jar does not exist
    exit 1
fi

if [ ! -e $keystore ] ; then
    echo $keystore does not exist
    exit 1
fi

local THISDIR=`pwd`

cd $wsdir/jar

rm -rf util-jars
mkdir -p util-jars
mv jogl.test.jar junit.jar util-jars/

for i in *.jar ; do
    echo jarsigner -storetype pkcs12 -keystore $keystore $i \"$signarg\"
    jarsigner -storetype pkcs12 -keystore $keystore -storepass $storepass $i "$signarg"
done

mv util-jars/* .
rm -rf util-jars

if [ -e atomic ] ; then
    cd atomic
    for i in *.jar ; do
        echo jarsigner -storetype pkcs12 -keystore $keystore $i \"$signarg\"
        jarsigner -storetype pkcs12 -keystore $keystore -storepass $storepass $i "$signarg"
    done
fi

cd $THISDIR

}

