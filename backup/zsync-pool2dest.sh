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
    snapNow=$1
    shift
    snapPre=$1
    shift
    #
    # Due to issue 2210 <https://github.com/zfsonlinux/zfs/issues/2210>
    # Cannot use deduplication reliably!
    #
    if [ -z "$snapPre" ] ; then
        #zfs send -R -D $src_pool/$dset@$snapNow | ssh $dest_ssh "zfs receive -v -u -d $dest_pool/backup/$src_pool"
        zfs send -R $src_pool/$dset@$snapNow | ssh $dest_ssh "zfs receive -v -u -d $dest_pool/backup/$src_pool"
    else
        #zfs send -R -D -I @$snapPre $src_pool/$dset@$snapNow | ssh $dest_ssh "zfs receive -v -u -d $dest_pool/backup/$src_pool"
        zfs send -R -I @$snapPre $src_pool/$dset@$snapNow | ssh $dest_ssh "zfs receive -v -u -d $dest_pool/backup/$src_pool"
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
    snapNow=$1
    shift
    snapPre=$1
    shift
    one_zsync $src_pool $dest_pool $dest_ssh data $snapNow $snapPre
    one_zsync $src_pool $dest_pool $dest_ssh services $snapNow $snapPre
    one_zsync $src_pool $dest_pool $dest_ssh system $snapNow $snapPre
    one_zsync $src_pool $dest_pool $dest_ssh users $snapNow $snapPre
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
    snapshot_now=$1
    shift
    snapshot_pre=$1
    shift

    all_zsync $src_pool $dest_pool $dest_ssh $snapshot_now $snapshot_pre

    echo DONE
}


src_pool=jogamp_org
dest_pool=jausoft_com
dest_ssh=root@jausoft.com
#
#src_pool=jausoft_com
#dest_pool=jogamp_org
#dest_ssh=root@jogamp.org

# 
# zfs set readonly=on $dest_pool/backup
# zfs list -o name,readonly,compression $dest_pool
#
#

#snapshot_pre=setup_complete
#snapshot_now=20130920

#snapshot_pre=20130920
#snapshot_now=20131102

#snapshot_pre=20131102
#snapshot_now=20140225

#snapshot_pre=20140225
#snapshot_now=20140311

#snapshot_pre=20140311
#snapshot_now=20140411

snapshot_pre=20140411
snapshot_now=20150315

logfile=`basename $0 .sh`-"$src_pool"_2_"$dest_pool".log

#do_zsync_initial $src_pool $dest_pool $dest_ssh >& $logfile &
#do_zsync_increment $src_pool $dest_pool $dest_ssh $snapshot_now $snapshot_pre >& $logfile &
#disown $!

#do_zsync_initial $src_pool $dest_pool $dest_ssh 2>&1 | tee $logfile
do_zsync_increment $src_pool $dest_pool $dest_ssh $snapshot_now $snapshot_pre 2>&1 | tee $logfile

