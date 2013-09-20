#! /bin/bash

function one_zsync()
{
    dset=$1
    shift
    snap=$1
    shift
    zfs send -R -D jogamp_org/$dset@$snap | ssh root@jausoft.com "zfs receive -v -u -d jausoft_com/backup/jogamp.org"
}
function all_zsync()
{
    snap=$1
    shift
    one_zsync data $snap
    one_zsync services $snap
    one_zsync system $snap
    one_zsync users $snap
}
function do_zsync()
{
    all_zsync setup_complete

    echo DONE
}

do_zsync >& zsync-jogamp2jausoft.log &
disown $!
