#! /bin/bash

#
# one_zsync pool dest data-set target-snapshot [incremental-start-snapshot]
#
function one_zsync()
{
    pool=$1
    shift
    dest=$1
    shift
    dset=$1
    shift
    snap=$1
    shift
    snap0=$1
    shift
    if[ -z "$snap0" ] ; then
        zfs send -R -D $pool/$dset@$snap | ssh $dest "zfs receive -v -u -d jausoft_com/backup/jogamp.org"
    else
        zfs send -R -D -I @$snap0 $pool/$dset@$snap | ssh $dest "zfs receive -v -u -d jausoft_com/backup/jogamp.org"
    fi
}

#
# all_zsync pool dest target-snapshot [incremental-start-snapshot]
#
function all_zsync()
{
    pool=$1
    shift
    dest=$1
    shift
    snap=$1
    shift
    snap0=$1
    shift
    one_zsync $pool $dest data $snap $snap0
    one_zsync $pool $dest services $snap $snap0
    one_zsync $pool $dest system $snap $snap0
    one_zsync $pool $dest users $snap $snap0
}

#
# do_zsync_initial pool dest
#   Performs an initial sync of snapshot 'setup_complete'
#
function do_zsync_initial()
{
    pool=$1
    shift
    dest=$1
    shift

    all_zsync $pool $dest setup_complete

    echo DONE
}

#
# do_zsync_increment pool dest
#   Performs an incremental sync from 'setup_complete' up until '20130920'
#
function do_zsync_increment()
{
    pool=$1
    shift
    dest=$1
    shift

    all_zsync $pool $dest 20130920 setup_complete

    echo DONE
}

pool=jogamp_org
dest=root@jausoft.com

logfile=`basename $0 .sh`-$pool_2_$dest.log

#do_zsync_initial $pool $dest >& $logfile &
do_zsync_increment $pool $dest >& $logfile &
disown $!
