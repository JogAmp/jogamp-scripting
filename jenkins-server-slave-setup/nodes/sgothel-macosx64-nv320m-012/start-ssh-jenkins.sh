#! /bin/bash

cd /Users/jogamp/jenkins

scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar .

function connect_12 {
  . /opt-share/etc/profile.ant
  java -version
  which git
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6012:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx1024m -jar slave.jar -jnlpUrl https://jogamp.org/chuck/computer/macosx64-NV320M-10_6-jogamp-x64-sgothel-012/slave-agent.jnlp
  done
}

connect_12 > macosx64-NV320M-10_6-jogamp-x64-sgothel-012.log 2>&1 &
disown $!

