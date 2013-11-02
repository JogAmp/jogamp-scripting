#! /bin/bash

#
# one_zsync src_pool dest_pool dest_ssh data-set target-snapshot [incremental-start-snapshot]
#    Example: one_zsync jogamp_org jausoft_com root@jausoft.com data snap02 snap01
#
function one_zsync()
{
    src_pool=$1
    shift
    dest_pool=$1
    shift
    dest_ssh=$1
    shift
    dset=$1
    shift
    snap=$1
    shift
    snap0=$1
    shift
    if [ -z "$snap0" ] ; then
        zfs send -R -D $src_pool/$dset@$snap | ssh $dest_ssh "zfs receive -v -u -d $dest_pool/backup/$src_pool"
    else
        zfs send -R -D -I @$snap0 $src_pool/$dset@$snap | ssh $dest_ssh "zfs receive -v -u -d $dest_pool/backup/$src_pool"
    fi
}

#
# all_zsync src_pool dest_pool dest_ssh target-snapshot [incremental-start-snapshot]
#    Example: all_zsync jogamp_org jausoft_com root@jausoft.com snap02 snap01
#
function all_zsync()
{
    src_pool=$1
    shift
    dest_pool=$1
    shift
    dest_ssh=$1
    shift
    snap=$1
    shift
    snap0=$1
    shift
    one_zsync $src_pool $dest_pool $dest_ssh data $snap $snap0
    one_zsync $src_pool $dest_pool $dest_ssh services $snap $snap0
    one_zsync $src_pool $dest_pool $dest_ssh system $snap $snap0
    one_zsync $src_pool $dest_pool $dest_ssh users $snap $snap0
}

#
# do_zsync_initial src_pool dest_pool dest_ssh
#    Performs an initial sync of snapshot 'setup_complete'
#
#    Example: do_zsync_initial jogamp_org jausoft_com root@jausoft.com
#
function do_zsync_initial()
{
    src_pool=$1
    shift
    dest_pool=$1
    shift
    dest_ssh=$1
    shift

    all_zsync $src_pool $dest_pool $dest_ssh setup_complete

    echo DONE
}

#
# do_zsync_increment src_pool dest_pool dest_ssh snapshot
#    Performs an incremental sync from 'setup_complete' up until $snapshot
#
#    Example: do_zsync_increment jogamp_org jausoft_com root@jausoft.com 20131102
#
function do_zsync_increment()
{
    src_pool=$1
    shift
    dest_pool=$1
    shift
    dest_ssh=$1
    shift
    snapshot=$1
    shift

    all_zsync $src_pool $dest_pool $dest_ssh $snapshot setup_complete

    echo DONE
}


src_pool=jogamp_org
dest_pool=jausoft_com
dest_ssh=root@jausoft.com
snapshot=20131102
#
#src_pool=jausoft_com
#dest_pool=jogamp_org
#dest_ssh=root@jogamp.org

logfile=`basename $0 .sh`-"$src_pool"_2_"$dest_pool".log

#do_zsync_initial $src_pool $dest_pool $dest_ssh >& $logfile &
do_zsync_increment $src_pool $dest_pool $dest_ssh $snapshot >& $logfile &
disown $!
