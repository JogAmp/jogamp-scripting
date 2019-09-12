@echo off
c:
chdir c:\cygwin64\bin
REM bash --login -c "/usr/sbin/sshd ; /home/jogamp/jenkins/start-ssh-jenkins.sh"
bash --login -c "/usr/sbin/sshd"

