#! /bin/bash

cd ~/jenkins

scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar .

function connect_3 {
  . /opt-share/etc/profile.ant
  . /opt-linux-x86/etc/profile.jre7
  . /opt-linux-x86/etc/profile.j2se7

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
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 5703:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx1024m -jar slave.jar -jnlpUrl https://jogamp.org/chuck/computer/linux64-NVFX580-ubuntu10-jogamp-x32-c3d-003/slave-agent.jnlp
  done
}

function connect_4 {
  . /opt-share/etc/profile.ant
  . /opt-linux-x86_64/etc/profile.jre7
  . /opt-linux-x86_64/etc/profile.j2se7

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
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 5704:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx1024m -jar slave.jar -jnlpUrl https://jogamp.org/chuck/computer/linux64-NVFX580-ubuntu10-jogamp-x64-c3d-004/slave-agent.jnlp
  done
}


connect_3 > linux64-NVFX580-ubuntu10-jogamp-x32-c3d-003.log 2>&1 &
disown $!

connect_4 > linux64-NVFX580-ubuntu10-jogamp-x64-c3d-004.log 2>&1 &
disown $!

