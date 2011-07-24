#! /bin/sh

bdir=$1
shift

echo TOTAL $bdir
du -hsc $bdir

echo
echo Cleaning workspace $bdir
rm -rf `find $bdir -name workspace`
rm -rf `find $bdir -name workspace-files`
rm -rf `find $bdir -name javadoc`

echo
echo Cleaned TOTAL $bdir
du -hsc $bdir

