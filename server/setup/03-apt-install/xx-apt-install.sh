#! /bin/sh

rm -f xx-apt-install.log

for i in 01-apt-basics.lst \
         02-apt-java.lst \
         03-apt-perl.lst \
         04-apt-mysql.lst \
         05-apt-mail.txt \
         06-apt-web.lst \
         ; do
    apt-get --assume-yes -q install `cat $i` 2>&1 | tee -a xx-apt-install.log
done
