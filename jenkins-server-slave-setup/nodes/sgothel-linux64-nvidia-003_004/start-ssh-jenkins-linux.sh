#! /bin/bash

cd ~/jenkins

JENKINS_NODE_STARTUP_DIR=`pwd`

scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar .

function connect_1 {
  . /opt-share/etc/profile.ant
  . /opt-linux-x86/etc/profile.jre8
  . /opt-linux-x86/etc/profile.j2se8

  export SOURCE_LEVEL=1.6
  export TARGET_LEVEL=1.6
  export TARGET_RT_JAR=/opt-share/jre1.6.0_30/lib/rt.jar

  export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

  java -version
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6003:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx512m -jar slave.jar -jnlpUrl https://jogamp.org/chuck/computer/linux64-nvidia-debian7-jogamp-x32-sgothel-003/slave-agent.jnlp
  done
}

function connect_2 {
  . /opt-share/etc/profile.ant
  . /opt-linux-x86_64/etc/profile.jre8
  . /opt-linux-x86_64/etc/profile.j2se8

  export SOURCE_LEVEL=1.6
  export TARGET_LEVEL=1.6
  export TARGET_RT_JAR=/opt-share/jre1.6.0_30/lib/rt.jar

  export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

  java -version
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6004:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx512m -jar slave.jar -jnlpUrl https://jogamp.org/chuck/computer/linux64-nvidia-debian7-jogamp-x64-sgothel-004/slave-agent.jnlp
  done
}

connect_1 > linux64-nvidia-debian7-jogamp-x32-sgothel-003.log 2>&1 &
disown $!

connect_2 > linux64-nvidia-debian7-jogamp-x64-sgothel-004.log 2>&1 &
disown $!

