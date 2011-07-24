#!/bin/bash
export JENKINS_HOME=/srv/jenkins
export JENKINS_WAR=$JENKINS_HOME/jenkins.war
export JENKINS_LOG=$JENKINS_HOME/jenkins.log
JAVA=$JAVA_HOME/bin/java
nohup nice $JAVA -jar $JENKINS_WAR --httpPort=8080 --prefix=/chuck > $JENKINS_LOG 2>&1 &

