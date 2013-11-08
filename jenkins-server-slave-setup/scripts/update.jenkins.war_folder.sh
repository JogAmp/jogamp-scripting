#!/bin/bash
export JENKINS_HOME=/srv/jenkins
export JENKINS_WAR=$JENKINS_HOME/jenkins.war

cd $JENKINS_HOME
rm -rf war
mkdir -p war
cd war
unzip $JENKINS_WAR
cd $JENKINS_HOME

