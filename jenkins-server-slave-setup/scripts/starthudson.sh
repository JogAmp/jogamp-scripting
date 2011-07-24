#! /bin/sh

FLAGS="-server -Xms256m -Xmx512m -XX:MaxPermSize=128m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+UseCompressedOops"
HUDSON_HOME=/srv/hudson/config
export HUDSON_HOME

. /opt-linux-x86_64/etc/profile.jre6
. /opt-share/etc/profile.ant

/opt-linux-x86_64/jre6/bin/java ${FLAGS} -jar /srv/hudson/hudson.war 2>&1 | tee hudson.log
