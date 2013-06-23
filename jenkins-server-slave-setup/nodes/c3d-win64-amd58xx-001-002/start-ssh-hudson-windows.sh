#! /bin/sh

cd ~/hudson

scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar .

function connect_1 {
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 5701:localhost:5555 -N &
    sshpid=$!
    ./win64-amd58xx-win7-jogamp-x32-c3d-001.bat
  done
}

function connect_2 {
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 5702:localhost:5555 -N &
    sshpid=$!
    ./win64-amd58xx-win7-jogamp-x64-c3d-002.bat
  done
}


connect_1 > win64-amd58xx-win7-jogamp-x32-c3d-001.log 2>&1 &
disown $!

connect_2 > win64-amd58xx-win7-jogamp-x64-c3d-002.log 2>&1 &
disown $!
