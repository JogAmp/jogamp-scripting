#! /bin/sh

cd /Users/jogamp/jenkins

#scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar slave-020.jar
curl -o agent-020.jar https://jogamp.org/chuck/jnlpJars/agent.jar

. ./profile.ant
JAVA_HOME=`/usr/libexec/java_home -version 17`
PATH=$JAVA_HOME/bin:/usr/local/bin:$PATH
export JAVA_HOME PATH

export GLUEGEN_CPPTASKS_FILE=make/lib/gluegen-cpptasks-ios-amd64.xml

export SDKROOT=iphonesimulator13.2
xcrun --show-sdk-path

export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

java -version
which git
ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6020:localhost:5555 -N &
SSHPID=$!
echo Launched SSH $SSHPID
java -server -Xmx1024m -XX:+UseCompressedOops -jar agent-020.jar -jnlpUrl https://jogamp.org/chuck/computer/ios-x86_64-amd64-jau-020/slave-agent.jnlp

