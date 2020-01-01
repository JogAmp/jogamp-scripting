#! /bin/sh

mkdir -p ~/Library/LaunchAgents
cp com.jogamp.launched.start-ssh-jenkins-012.plist ~/Library/LaunchAgents/
#cp com.jogamp.launched.start-ssh-jenkins-013.plist ~/Library/LaunchAgents/
cp com.jogamp.launched.start-ssh-jenkins-020.plist ~/Library/LaunchAgents/
cp com.jogamp.launched.start-ssh-jenkins-021.plist ~/Library/LaunchAgents/

#launchctl load -w ~/Library/LaunchAgents/com.jogamp.launched.start-ssh-jenkins-012.plist
#launchctl load -w ~/Library/LaunchAgents/com.jogamp.launched.start-ssh-jenkins-013.plist
#launchctl load -w ~/Library/LaunchAgents/com.jogamp.launched.start-ssh-jenkins-020.plist
#launchctl load -w ~/Library/LaunchAgents/com.jogamp.launched.start-ssh-jenkins-021.plist

