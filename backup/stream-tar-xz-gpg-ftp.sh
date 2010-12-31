#! /bin/sh

# uid@backup-server.net

destproto=ftp
destserver=backup-server.net
destuid=user
destpwd=password

#
# gpg keys to encrypt to
# you need to import and sign those
# import:
#   gpg --import <file> 
#   gpg --recv-key 0x8ED60127
# sign:
#   gpg --sign-key 0x8ED60127
#
destencr1=0xB848A4B4
destencr2=0x8ED60127
destencr3=0x43681400

FOLDERS="\
 /opt-share \
 /opt-linux-x86 \
 /opt-linux-x86_64 \
 /srv \
 /home \
 /root \
 /etc \
 /var/lib/mysql \
 /var/spool/mail \
 /var/log \
 /var/lib/awstats \
 /usr/local/awstats"

bbname=backup-`hostname`-`date +%Y%m%d%H%M`

function do_ssh_tar() {

echo
echo BEGIN $bbname
date
echo

time nice -n 20 \
tar cf - $FOLDERS | \
xz --format=xz --check=crc64 --threads=4 -z -c - | \
gpg -e --recipient $destencr1 --recipient $destencr2 --recipient $destencr3 | \
curl -u $destuid:$destpwd $destproto://$destserver/$bbname.tar.xz.gpg -T -

echo target backup $destuid@$destserver:$bbname.tar.xz.gpg

echo
echo END $bbname
date
echo

}

do_ssh_tar >& $bbname.log &
disown $!
#do_ssh_tar 2>&1 | tee $bbname.log

