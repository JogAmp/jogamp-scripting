#! /bin/bash

# Bug 1386: Mesa 18.3.6 hardware renderer (Intel/AMD) freezes after native parenting
export LIBGL_ALWAYS_SOFTWARE=true

cd ~/jenkins

JENKINS_NODE_STARTUP_DIR=`pwd`

#scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar .
curl -O https://jogamp.org/chuck/jnlpJars/agent.jar

function connect_1 {
  . ./profile.ant
  . ./profile.i386.java17

  export LIBGL_ALWAYS_SOFTWARE=true

  export SOURCE_LEVEL=1.8
  export TARGET_LEVEL=1.8
  export TARGET_RT_JAR=/opt-share/jre1.8.0_212/lib/rt.jar

  export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

  java -version
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
        kill -9 $sshpid
    fi
    if [ -e stop_node ] ; then
        exit 1
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6001:localhost:5555 -N &
    sshpid=$!
    # java -server -Xmx512m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/linux32-debian-jogamp-x32-sgothel-001/slave-agent.jnlp
    java -server -Xmx512m -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/linux-x86_32-jau-001/slave-agent.jnlp
  done
}

function connect_40 {
  . ./profile.ant
  . ./profile.amd64.j2se11

    export ANDROID_HOME=/opt-linux-x86_64/android-sdk-linux_x86_64
    export ANDROID_HOST_TAG=linux-x86_64
    export ANDROID_ABI=armeabi-v7a

    if [ -e ${JENKINS_NODE_STARTUP_DIR}/setenv-android-tools.sh ] ; then
        . ${JENKINS_NODE_STARTUP_DIR}/setenv-android-tools.sh
    else
        echo "${JENKINS_NODE_STARTUP_DIR}/setenv-android-tools.sh doesn't exist!"
        exit 1
    fi

    export GLUEGEN_CPPTASKS_FILE=make/lib/gluegen-cpptasks-android-armv6.xml
    export GLUEGEN_PROPERTIES_FILE=/home/jogamp/android/gluegen.properties # for key signing props

    export PATH_VANILLA=$PATH
    export PATH=${ANDROID_TOOLCHAIN_ROOT}/${ANDROID_TOOLCHAIN_NAME}/bin:${ANDROID_TOOLCHAIN_ROOT}/bin:${ANDROID_HOME}/platform-tools:${ANDROID_BUILDTOOLS_ROOT}:${PATH}
    echo PATH ${PATH} 2>&1 | tee -a ${LOGF}
    echo clang `which clang` 2>&1 | tee -a ${LOGF}

    export SOURCE_LEVEL=1.8
    export TARGET_LEVEL=1.8
    export TARGET_RT_JAR=/opt-share/jre1.8.0_212/lib/rt.jar

    export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

    #export JUNIT_DISABLED="true"
    #export JUNIT_RUN_ARG0="-Dnewt.test.Screen.disableScreenMode"

  java -version
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
        kill -9 $sshpid
    fi
    if [ -e stop_node ] ; then
        exit 1
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6040:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx512m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/android-arm32-armv7-jau-040/slave-agent.jnlp
  done

}

function connect_42 {
  . ./profile.ant
  . ./profile.amd64.j2se11

    export ANDROID_HOME=/opt-linux-x86_64/android-sdk-linux_x86_64
    export ANDROID_HOST_TAG=linux-x86_64
    export ANDROID_ABI=x86

    if [ -e ${JENKINS_NODE_STARTUP_DIR}/setenv-android-tools.sh ] ; then
        . ${JENKINS_NODE_STARTUP_DIR}/setenv-android-tools.sh
    else
        echo "${JENKINS_NODE_STARTUP_DIR}/setenv-android-tools.sh doesn't exist!"
        exit 1
    fi

    export GLUEGEN_CPPTASKS_FILE=make/lib/gluegen-cpptasks-android-x86.xml
    export GLUEGEN_PROPERTIES_FILE=/home/jogamp/android/gluegen.properties # for key signing props

    export PATH_VANILLA=$PATH
    export PATH=${ANDROID_TOOLCHAIN_ROOT}/${ANDROID_TOOLCHAIN_NAME}/bin:${ANDROID_TOOLCHAIN_ROOT}/bin:${ANDROID_HOME}/platform-tools:${ANDROID_BUILDTOOLS_ROOT}:${PATH}
    echo PATH ${PATH} 2>&1 | tee -a ${LOGF}
    echo clang `which clang` 2>&1 | tee -a ${LOGF}

    export SOURCE_LEVEL=1.8
    export TARGET_LEVEL=1.8
    export TARGET_RT_JAR=/opt-share/jre1.8.0_212/lib/rt.jar

    export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

    #export JUNIT_DISABLED="true"
    #export JUNIT_RUN_ARG0="-Dnewt.test.Screen.disableScreenMode"

  java -version
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
        kill -9 $sshpid
    fi
    if [ -e stop_node ] ; then
        exit 1
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6042:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx512m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/android-x86-i686-jau-042/slave-agent.jnlp
  done
}

connect_1 > linux-x86_32-jau-001.log 2>&1 &
disown $!

connect_40 > android-arm32-armv7-jau-040.log 2>&1 &
disown $!

connect_42 > android-x86-i686-jau-042.log 2>&1 &
disown $!


