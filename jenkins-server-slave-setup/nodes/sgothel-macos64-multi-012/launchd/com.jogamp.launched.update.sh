#! /bin/sh

mkdir -p ~/Library/LaunchAgents

launchctl unload -w ~/Library/LaunchAgents/com.jogamp.launched.start-ssh-jenkins-012.plist
#launchctl unload -w ~/Library/LaunchAgents/com.jogamp.launched.start-ssh-jenkins-020.plist
#launchctl unload -w ~/Library/LaunchAgents/com.jogamp.launched.start-ssh-jenkins-021.plist

sleep 5
cp com.jogamp.launched.start-ssh-jenkins-012.plist ~/Library/LaunchAgents/
#cp com.jogamp.launched.start-ssh-jenkins-020.plist ~/Library/LaunchAgents/
#cp com.jogamp.launched.start-ssh-jenkins-021.plist ~/Library/LaunchAgents/

launchctl load -w ~/Library/LaunchAgents/com.jogamp.launched.start-ssh-jenkins-012.plist
#launchctl load -w ~/Library/LaunchAgents/com.jogamp.launched.start-ssh-jenkins-020.plist
#launchctl load -w ~/Library/LaunchAgents/com.jogamp.launched.start-ssh-jenkins-021.plist

