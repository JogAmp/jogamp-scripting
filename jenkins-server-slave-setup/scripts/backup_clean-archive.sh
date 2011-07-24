#! /bin/sh

bdir=$1
shift

echo TOTAL $bdir
du -hsc $bdir

echo
echo Cleaning Archives $bdir
rm -rf `find $bdir -name archive`

echo
echo Cleaned TOTAL $bdir
du -hsc $bdir

