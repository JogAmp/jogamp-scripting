#! /bin/bash

cd ~/jenkins

rm -f slave.jar
# wget --no-check-certificate https://jogamp.org/chuck/jnlpJars/slave.jar
scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar .

function connect_1 {
  # solaris-x86_32-nv
  . /opt-share/etc/profile.ant
  export PATH=/usr/java/bin:$PATH
  #. /opt-solaris-x86/etc/profile.jre6
  #. /opt-solaris-x86/etc/profile.j2se6
  java -d32 -version
  which java
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "KeepAlive yes" chuckslave@jogamp.org -L 6020:localhost:5555 -N &
    sshpid=$!
    java -d32 -server -jar slave.jar -jnlpUrl https://jogamp.org/chuck/computer/solaris-NVQUADRO-solaris10-jogamp-x32-sgothel-020/slave-agent.jnlp
  done
}

function connect_2 {
  # solaris-x86_64-nv
  . /opt-share/etc/profile.ant
  export PATH=/usr/java/bin/amd64:$PATH
  #. /opt-solaris-x86_64/etc/profile.jre6
  #. /opt-solaris-x86_64/etc/profile.j2se6
  java -d64 -version
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "KeepAlive yes" chuckslave@jogamp.org -L 6021:localhost:5555 -N &
    sshpid=$!
    java -d64 -server -Xmx1024m -jar slave.jar -jnlpUrl https://jogamp.org/chuck/computer/solaris-NVQUADRO-solaris10-jogamp-x64-sgothel-021/slave-agent.jnlp
  done
}

connect_1 > solaris-NVQUADRO-solaris10-jogamp-x32-sgothel-020.log 2>&1 &
disown $!

connect_2 > solaris-NVQUADRO-solaris10-jogamp-x64-sgothel-021.log 2>&1 &
disown $!

