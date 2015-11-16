#! /bin/sh

cd ~/jenkins

scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar .

function connect_1 {
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6016:localhost:5555 -N &
    sshpid=$!
    ./win64-amd-win7-jogamp-x32-sgothel-016.bat
  done
}

function connect_2 {
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6017:localhost:5555 -N &
    sshpid=$!
    ./win64-amd-win7-jogamp-x64-sgothel-017.bat
  done
}


connect_1 > win64-amd-win7-jogamp-x32-sgothel-016.log 2>&1 &
disown $!

connect_2 > win64-amd-win7-jogamp-x64-sgothel-017.log 2>&1 &
disown $!

