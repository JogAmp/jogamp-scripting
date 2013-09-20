#! /bin/bash

#
# one_zsync data-set target-snapshot [incremental-start-snapshot]
#
function one_zsync()
{
    dset=$1
    shift
    snap=$1
    shift
    snap0=$1
    shift
    if[ -z "$snap0" ] ; then
        zfs send -R -D jogamp_org/$dset@$snap | ssh root@jausoft.com "zfs receive -v -u -d jausoft_com/backup/jogamp.org"
    else
        zfs send -R -D -I @$snap0 jogamp_org/$dset@$snap | ssh root@jausoft.com "zfs receive -v -u -d jausoft_com/backup/jogamp.org"
    fi
}

#
# all_zsync target-snapshot [incremental-start-snapshot]
#
function all_zsync()
{
    snap=$1
    shift
    snap0=$1
    shift
    one_zsync data $snap $snap0
    one_zsync services $snap $snap0
    one_zsync system $snap $snap0
    one_zsync users $snap $snap0
}

#
# do_zsync_initial
#   Performs an initial sync of snapshot 'setup_complete'
#
function do_zsync_initial()
{
    all_zsync setup_complete

    echo DONE
}

#
# do_zsync_increment
#   Performs an incremental sync from 'setup_complete' up until '20130920'
#
function do_zsync_increment()
{
    all_zsync 20130920 setup_complete

    echo DONE
}

#do_zsync_initial >& zsync-jogamp2jausoft.log &
do_zsync_increment >& zsync-jogamp2jausoft.log &
disown $!
