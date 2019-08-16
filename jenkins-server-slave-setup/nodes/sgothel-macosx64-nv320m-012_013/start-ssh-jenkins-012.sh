#! /bin/sh

cd /Users/jogamp/jenkins

#scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar slave-012.jar
curl -o agent-012.jar https://jogamp.org/chuck/jnlpJars/agent.jar

. ./profile.ant
JAVA_HOME=`/usr/libexec/java_home -version 11`
PATH=$JAVA_HOME/bin:$PATH
export JAVA_HOME PATH
export SOURCE_LEVEL=1.8
export TARGET_LEVEL=1.8
export TARGET_RT_JAR=/opt-share/jre1.8.0_212/lib/rt.jar

export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

export SDKROOT=macosx10.11
xcrun --show-sdk-path

java -version
which git
ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6012:localhost:5555 -N &
SSHPID=$!
echo Launched SSH $SSHPID
java -server -Xmx1024m -XX:+UseCompressedOops -jar agent-012.jar -jnlpUrl https://jogamp.org/chuck/computer/macosx64-NV320M-10_6-jogamp-x64-sgothel-012/slave-agent.jnlp

