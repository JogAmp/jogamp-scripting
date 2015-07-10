#! /bin/bash

cd /Users/jogamp/jenkins

scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar .

function connect_12 {
  . /opt-share/etc/profile.ant
  JAVA_HOME=`/usr/libexec/java_home -version 1.6`
  PATH=$JAVA_HOME/bin:$PATH
  export JAVA_HOME PATH
  #JAVA7_EXE=`/usr/libexec/java_home -version 1.7.0_12`/bin/java
  #export JAVA7_EXE
  export SOURCE_LEVEL=1.6
  export TARGET_LEVEL=1.6
  export TARGET_RT_JAR=/opt-share/jre1.6.0_30/lib/rt.jar
  
  export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

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

function connect_13 {
  . /opt-share/etc/profile.ant
  JAVA_HOME=`/usr/libexec/java_home -version 1.8`
  PATH=$JAVA_HOME/bin:$PATH
  export JAVA_HOME PATH
  export SOURCE_LEVEL=1.6
  export TARGET_LEVEL=1.6
  export TARGET_RT_JAR=/opt-share/jre1.6.0_30/lib/rt.jar

  export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

  java -version
  which git
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6013:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx1024m -jar slave.jar -jnlpUrl https://jogamp.org/chuck/computer/macosx64-NV320M-10_7-jogamp-x64-jre7-sgothel-013/slave-agent.jnlp
  done
}

connect_12 > macosx64-NV320M-10_6-jogamp-x64-sgothel-012.log 2>&1 &
connect_13 > macosx64-NV320M-10_6-jogamp-x64-jre7-sgothel-013.log 2>&1 &
disown $!

