#! /bin/sh

cd /Users/jogamp/jenkins

scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar slave-013.jar

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
ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6013:localhost:5555 -N &
SSHPID=$!
echo Launched SSH $SSHPID
java -server -Xmx1024m -jar slave-013.jar -jnlpUrl https://jogamp.org/chuck/computer/macosx64-NV320M-10_7-jogamp-x64-jre7-sgothel-013/slave-agent.jnlp


