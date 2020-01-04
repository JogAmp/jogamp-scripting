#! /bin/bash

# Bug 1386: Mesa 18.3.6 hardware renderer (Intel/AMD) freezes after native parenting
export LIBGL_ALWAYS_SOFTWARE=true

cd ~/jenkins

JENKINS_NODE_STARTUP_DIR=`pwd`

#scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar .
curl -O https://jogamp.org/chuck/jnlpJars/agent.jar

function connect_1 {
  . ./profile.ant
  . ./profile.i386.j2se11

  export LIBGL_ALWAYS_SOFTWARE=true

  export SOURCE_LEVEL=1.8
  export TARGET_LEVEL=1.8
  export TARGET_RT_JAR=/opt-share/jre1.8.0_212/lib/rt.jar

  export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

  java -version
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6001:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx512m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/linux32-debian-jogamp-x32-sgothel-001/slave-agent.jnlp
  done
}

function connect_2 {
  . ./profile.ant
  . ./profile.amd64.j2se11

  export LIBGL_ALWAYS_SOFTWARE=true

  export SOURCE_LEVEL=1.8
  export TARGET_LEVEL=1.8
  export TARGET_RT_JAR=/opt-share/jre1.8.0_212/lib/rt.jar

  export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

  java -version
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6002:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx512m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/linux64-AMD58xx-debian7-jogamp-x64-sgothel-002/slave-agent.jnlp 
  done
}

connect_1 > linux32-debian-jogamp-x32-sgothel-001.log 2>&1 &
disown $!

connect_2 > linux64-AMD58xx-debian7-jogamp-x64-sgothel-002.log 2>&1 &
disown $!

