#! /bin/bash

if [ -z "$1" ] ; then
  archive=/srv/www/jogamp.org/deployment/jogamp-next
else
  archive=$1
fi

logfile=`basename $0 .sh`.log

rm -rf zips
mkdir zips
cd zips
for i in  $archive/*.zip ; do 
    bname=`basename $i .zip`
    unzip -q $i
    if [ -e $bname ] ; then
        cd $bname
        ls > ../$bname.lst
        cd ..
    else
        echo "Error: No folder $bname in $i"
    fi
done
cd ..

rm -rf plain
mkdir plain
cd plain
cp -a $archive/*.jar .
ls > ../plain.lst
cd ..

rm -rf dump
mkdir dump

echo "Verifying all files in $archive"
ls -la $archive
echo

function integrity_check() {
    cd dump
    for i in ../plain/*.jar ; do
        bname=`basename $i`
        echo -n "$bname integrity - "
        OK=0
        jar xvf $i >& $i.log && OK=1
        if [ $OK -eq 0 ] ; then
            echo ERROR
        else
            echo OK
            rm $i.log
        fi
    done
    echo
    cd ..
}

function identity_check() {
    mkdir plain/natives
    mv plain/*-natives-*jar plain/natives
    mkdir plain/demos
    mv plain/jogl-demos*jar plain/demos

    cd zips

    for i in ../plain/*.jar ; do
        bname=`basename $i`
        echo -n "$bname identity - "
        OK=0
        for j in `find . -name $bname` ; do 
            if cmp -s $i $j ; then
                OK=1
                echo -n "$j "
            fi
        done
        if [ $OK -eq 0 ] ; then
            echo "NONE"
            echo "Error: verbose comparison of $bname" 
            for j in `find . -name $bname` ; do 
                cmp $i $j
            done
        else
            echo
        fi
    done
    echo

    cd ..

    mv plain/natives/* plain/
    rm -rf plain/natives
    mv plain/demos/* plain/
    rm -rf plain/demos
}

integrity_check 2>&1 | tee $logfile
identity_check 2>&1 | tee $logfile

