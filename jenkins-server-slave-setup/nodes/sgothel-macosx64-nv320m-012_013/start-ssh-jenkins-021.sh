#! /bin/sh

cd /Users/jogamp/jenkins

#scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar slave-021.jar
curl -o agent-021.jar https://jogamp.org/chuck/jnlpJars/agent.jar

. ./profile.ant
JAVA_HOME=`/usr/libexec/java_home -version 11`
PATH=$JAVA_HOME/bin:/usr/local/bin:$PATH
export JAVA_HOME PATH
export SOURCE_LEVEL=1.8
export TARGET_LEVEL=1.8
export TARGET_RT_JAR=/usr/local/jre1.8.0_212/lib/rt.jar

export GLUEGEN_CPPTASKS_FILE=make/lib/gluegen-cpptasks-ios-aarch64.xml

export SDKROOT=iphoneos13.2
xcrun --show-sdk-path

export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

java -version
which git
ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6021:localhost:5555 -N &
SSHPID=$!
echo Launched SSH $SSHPID
java -server -Xmx1024m -XX:+UseCompressedOops -jar agent-021.jar -jnlpUrl https://jogamp.org/chuck/computer/iOSArm64-jogamp-aarch64-sgothel-021/slave-agent.jnlp

