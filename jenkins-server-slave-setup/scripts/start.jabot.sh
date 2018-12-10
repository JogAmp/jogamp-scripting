#!/bin/bash

export JABOT_HOME=/srv/jabot/jabot
export JABOT_LOG=$JABOT_HOME/irc_jogamp_CatOut_`date -u +%Y%m%d%H%M`.log
# export JRE_HOME=/opt-linux-x86_64/jre8
export JRE_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")

# -testPongTO
# -verbose

JAVA=$JRE_HOME/bin/java
nohup nice $JAVA \
    -cp $JABOT_HOME/build/jabot.jar org.jogamp.jabot.irc.CatOut \
        -login srvlogin -nick ircnickname -nickpwd nickserv_id_password \
        -server irc.freenode.net -channel jogamp \
        -logrotate 86400000 \
        -logrotateStart 0505 \
        -logprefix "/srv/www/jogamp.org/log/irc/" \
        -urlprefix "http://jogamp.org/log/irc/" \
        -htmlHeader $JABOT_HOME/assets/header.html \
        -htmlFooter $JABOT_HOME/assets/footer.html \
        > $JABOT_LOG 2>&1 &

# 1day = 24 * 60 * 60 * 1000 = 86400000
