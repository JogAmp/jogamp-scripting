@echo off
c:
chdir c:\cygwin\bin
bash --login -c "/usr/sbin/sshd ; /home/jogamp/jenkins/start-ssh-jenkins.sh"
