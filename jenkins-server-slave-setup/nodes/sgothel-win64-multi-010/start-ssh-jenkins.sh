#! /bin/sh

cd ~/jenkins

#scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar .
curl -O https://jogamp.org/chuck/jnlpJars/agent.jar

function connect_2 {
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
        kill -9 $sshpid
    fi
    if [ -e stop_node ] ; then
        exit 1
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6011:localhost:5555 -N &
    sshpid=$!
    ./windows-x86_64-jau-011.bat
  done
}


connect_2 > windows-x86_64-jau-011.log 2>&1 &
disown $!

