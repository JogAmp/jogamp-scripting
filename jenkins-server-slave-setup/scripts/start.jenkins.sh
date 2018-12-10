#!/bin/bash
export JENKINS_HOME=/srv/jenkins
export JENKINS_WAR=$JENKINS_HOME/jenkins.war
export JENKINS_LOG=$JENKINS_HOME/jenkins.log

#export JAVAC_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
export JRE_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
#export JRE_HOME=/opt-linux-x86_64/jre8
JAVA=$JRE_HOME/bin/java

cd $JENKINS_HOME
rm -rf war
mkdir -p war
cd war
unzip $JENKINS_WAR
cd $JENKINS_HOME

nohup nice $JAVA -server -Xmx1024m -jar $JENKINS_WAR --httpPort=8080 --prefix=/chuck > $JENKINS_LOG 2>&1 &
# nohup nice $JAVA -server -Xmx1024m -jar $JENKINS_WAR --httpPort=-1 --httpsPort=8080 --prefix=/chuck > $JENKINS_LOG 2>&1 &

