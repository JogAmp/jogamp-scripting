#! /bin/sh

USESSH="-e ssh"

SOURCE=root@jogamp.org:
DEST1=/
DEST2=/data/backup/jogamp.org/fs

function my_rsync()
{
    src=$1
    shift
    dst=$1
    shift

    mkdir -p $dst
    rsync $USESSH -apv --delete-after $* $SOURCE/$src $dst
}

function do_rsync()
{
    my_rsync opt-share          $DEST1/
    my_rsync opt-linux-x86      $DEST1/
    my_rsync opt-linux-x86_64   $DEST1/

    my_rsync srv/glassfish      $DEST1/srv/
    my_rsync srv/hudson         $DEST1/srv/
    my_rsync srv/www/jogamp.org $DEST1/srv/www/

    my_rsync srv/scm            $DEST2/srv/

    my_rsync home               $DEST2/
    my_rsync root               $DEST2/

    my_rsync etc                $DEST2/ --exclude='selinux/' --exclude='gconf/' --exclude='firmware/'

    my_rsync var/lib/mysql      $DEST2/var/lib/
    my_rsync var/spool/mail     $DEST2/var/spool/
    my_rsync var/log            $DEST2/var/

    my_rsync var/lib/awstats    $DEST2/var/lib/
    my_rsync usr/local/awstats  $DEST2/usr/local/
}

do_rsync >& rsync-jogamp2here.log &
disown $!

