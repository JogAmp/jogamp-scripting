#! /bin/bash

archivedir=/srv/www/jogamp.org/deployment/archive
rootdir=/srv/www/jogamp.org/deployment/autobuilds

os_and_archs_minus_one="linux-i586 macosx-universal windows-amd64 windows-i586"
masterpick="linux-amd64"
os_and_archs="$masterpick linux-i586 macosx-universal windows-amd64 windows-i586"

thisdir=`pwd`
cd $rootdir

dest=tmp-archive

rm -rf $dest
mkdir $dest
mkdir $dest/javadoc

function lslatest() {
    pattern=$1
    shift
    ls -rt  | grep $pattern | tail -1
}

function buildnumber_2() {
    folder=$1
    shift
    echo $folder | awk -F '-' ' { print substr($2, 2); } '
}

function buildnumber_3() {
    folder=$1
    shift
    echo $folder | awk -F '-' ' { print substr($3, 2); } '
}

function buildnumber_4() {
    folder=$1
    shift
    echo $folder | awk -F '-' ' { print substr($4, 2); } '
}

gluegenslave=`lslatest gluegen-b`
bgluegenslave=`buildnumber_2 $gluegenslave`
gluegenmaster=`lslatest gluegen-master-b`
bgluegenmaster=`buildnumber_3 $gluegenmaster`
echo
echo GLUEGEN
echo
echo slave  build $bgluegenslave - $gluegenslave
echo master build $bgluegenmaster - $gluegenmaster
echo
echo "gluegen.build.number=$bgluegenslave" >> $dest/aggregated.artifact.properties

cp -a $gluegenslave/build/gluegen*jar $dest/
cp -a $gluegenslave/build/artifact.properties $dest/gluegen.artifact.properties

cp -a $gluegenmaster/build/artifact.properties $dest/javadoc/gluegen-master.artifact.properties
mkdir $dest/javadoc/gluegen
cp -a $gluegenmaster/build/javadoc.zip $dest/javadoc/gluegen
cd $dest/javadoc/gluegen
unzip -q javadoc.zip
cd $rootdir

joglslave=`lslatest jogl-b`
bjoglslave=`buildnumber_2 $joglslave`
joglmaster=`lslatest jogl-master-b`
bjoglmaster=`buildnumber_3 $joglmaster`
echo
echo JOGL
echo
echo slave  build $bjoglslave - $joglslave
echo master build $bjoglmaster - $joglmaster
echo
echo "jogl.build.number=$bjoglslave" >> $dest/aggregated.artifact.properties

cp -a $joglslave/build/jogl*zip $dest/
cd $dest
for i in *"$os_and_archs_minus_one".zip ; do
    unzip -q $i
done
unzip -q *"$masterpick".zip
cd $rootdir
cp -a $joglslave/build/artifact.properties $dest/jogl.artifact.properties

cp -a $joglmaster/build/artifact.properties $dest/javadoc/jogl-master.artifact.properties
mkdir $dest/javadoc/jogl
cp -a $joglmaster/build/javadoc*.zip $dest/javadoc/jogl
cd $dest/javadoc/jogl
for i in *.zip ; do 
    unzip -q $i
done
cd $rootdir

jogldemosmaster=`lslatest jogl-demos-master-b`
bjogldemosmaster=`buildnumber_4 $jogldemosmaster`
echo
echo JOGL DEMOS
echo
echo master  build $bjogldemosmaster - $jogldemosmaster
echo
echo "jogl-demos.build.number=$bjogldemosmaster" >> $dest/aggregated.artifact.properties

cp -a $jogldemosmaster/build/jogl-demos*jar $dest/
cp -a $jogldemosmaster/build/artifact.properties $dest/jogl-demos.artifact.properties
cd dest


joclslave=`lslatest jocl-b`
bjoclslave=`buildnumber_2 $joclslave`
joclmaster=`lslatest jocl-master-b`
bjoclmaster=`buildnumber_3 $joclmaster`
echo
echo JOCL
echo
echo slave  build $bjoclslave - $joclslave
echo master build $bjoclmaster - $joclmaster
echo
echo "jocl.build.number=$bjoclslave" >> $dest/aggregated.artifact.properties

cp -a $joclslave/jocl*jar $dest/
cp -a $joclslave/artifact.properties $dest/jocl.artifact.properties

cp -a $joclmaster/artifact.properties $dest/javadoc/jocl-master.artifact.properties
mkdir $dest/javadoc/jocl
cp -a $joclmaster/jocl-javadoc.zip $dest/javadoc/jocl/
cd $dest/javadoc/jocl
unzip -q jocl-javadoc.zip
cd $rootdir

jocldemosslave=`lslatest jocl-demos-b`
bjocldemosslave=`buildnumber_3 $jocldemosslave`
echo
echo JOCL DEMOS
echo
echo slave  build $bjocldemosslave - $jocldemosslave
echo
echo "jocl-demos.build.number=$bjocldemosslave" >> $dest/aggregated.artifact.properties

cp -a $jocldemosslave/jocl-demos*jar $dest/
cp -a $jocldemosslave/artifact.properties $dest/jocl-demos.artifact.properties

rm -rf $archivedir/gluegen_$bgluegenslave-jogl_$bjoglslave-jocl_$bjoclslave
mv $dest $archivedir/gluegen_$bgluegenslave-jogl_$bjoglslave-jocl_$bjoclslave

echo
echo Aggregation folder $archivedir/gluegen_$bgluegenslave-jogl_$bjoglslave-jocl_$bjoclslave
echo

cd $archivedir/gluegen_$bgluegenslave-jogl_$bjoglslave-jocl_$bjoclslave

echo
echo aggregation.properties
echo
cat jocl-demos.artifact.properties jogl-demos.artifact.properties | sort -u > jocl-demos-jogl-demos.artifact.properties.sorted
sort -u aggregated.artifact.properties > aggregated.artifact.properties.sorted
diff -Nurb aggregated.artifact.properties.sorted jocl-demos-jogl-demos.artifact.properties.sorted

