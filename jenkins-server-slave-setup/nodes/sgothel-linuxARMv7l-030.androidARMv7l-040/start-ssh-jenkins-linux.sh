#! /bin/bash

# Bug 1386: Mesa 18.3.6 hardware renderer (Intel/AMD) freezes after native parenting
export LIBGL_ALWAYS_SOFTWARE=true

cd ~/jenkins

JENKINS_NODE_STARTUP_DIR=`pwd`

#scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar .
curl -O https://jogamp.org/chuck/jnlpJars/agent.jar

function connect_31 {
  . ./profile.ant
  . ./profile.amd64.j2se11

  export SOURCE_LEVEL=1.8
  export TARGET_LEVEL=1.8
  export TARGET_RT_JAR=/opt-share/jre1.8.0_212/lib/rt.jar

  export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

  # arm-linux-gnueabi == armel triplet
  PATH=$JENKINS_NODE_STARTUP_DIR/toolchain/armhf-linux-gnueabi/bin:$PATH
  export PATH

  export TARGET_PLATFORM_SYSROOT=`gcc --print-sysroot`
  export TARGET_PLATFORM_USRROOT=/opt-linux-armv6-armhf
  export TARGET_PLATFORM_USRLIBS=$TARGET_PLATFORM_USRROOT/usr/lib
  export TARGET_JAVA_LIBS=$TARGET_PLATFORM_USRROOT/jre/lib/arm

  export GLUEGEN_CPPTASKS_FILE=make/lib/gluegen-cpptasks-linux-armv6hf.xml

  export JUNIT_RUN_ARG0="-Dnewt.test.Screen.disableScreenMode"

  java -version
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6031:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx512m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/linuxARMv7hf-jogamp-arm32hf-sgothel-031/slave-agent.jnlp
  done
}

function connect_32 {
  . ./profile.ant
  . ./profile.amd64.j2se11

  export SOURCE_LEVEL=1.8
  export TARGET_LEVEL=1.8
  export TARGET_RT_JAR=/opt-share/jre1.8.0_212/lib/rt.jar

  export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

  # arm-linux-gnueabi == armel triplet
  PATH=$JENKINS_NODE_STARTUP_DIR/toolchain/aarch64-linux-gnueabi/bin:$PATH
  export PATH

  export TARGET_PLATFORM_SYSROOT=`gcc --print-sysroot`
  export TARGET_PLATFORM_USRROOT=/opt-linux-arm64
  export TARGET_PLATFORM_USRLIBS=$TARGET_PLATFORM_USRROOT/usr/lib
  export TARGET_JAVA_LIBS=$TARGET_PLATFORM_USRROOT/jre/lib/aarch64

  export GLUEGEN_CPPTASKS_FILE=make/lib/gluegen-cpptasks-linux-aarch64.xml

  export JUNIT_RUN_ARG0="-Dnewt.test.Screen.disableScreenMode"

  java -version
  sshpid=
  while true ; do
    if [ ! -z "$sshpid" ] ; then
	kill -9 $sshpid
    fi
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6032:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx512m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/linuxARM64-jogamp-aarch64-sgothel-032/slave-agent.jnlp
  done
}

function connect_40 {
  . ./profile.ant
  . ./profile.amd64.j2se11

    export ANDROID_HOME=/opt-linux-x86_64/android-sdk-linux_x86_64
    export ANDROID_API_LEVEL=24
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
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6040:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx512m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/androidARMv7-jogamp-arm32-sgothel-040/slave-agent.jnlp
  done

}

function connect_41 {
  . ./profile.ant
  . ./profile.amd64.j2se11

    export ANDROID_HOME=/opt-linux-x86_64/android-sdk-linux_x86_64
    export ANDROID_API_LEVEL=24
    export ANDROID_HOST_TAG=linux-x86_64
    export ANDROID_ABI=arm64-v8a

    if [ -e ${JENKINS_NODE_STARTUP_DIR}/setenv-android-tools.sh ] ; then
        . ${JENKINS_NODE_STARTUP_DIR}/setenv-android-tools.sh
    else
        echo "${JENKINS_NODE_STARTUP_DIR}/setenv-android-tools.sh doesn't exist!"
        exit 1
    fi

    export GLUEGEN_CPPTASKS_FILE=make/lib/gluegen-cpptasks-android-aarch64.xml
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
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6041:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx512m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/androidArm64-jogamp-aarch64-sgothel-041/slave-agent.jnlp
  done
}

connect_31 > linuxARMv7hf-jogamp-arm32hf-sgothel-031.log 2>&1 &
disown $!

connect_32 > linuxARM64-jogamp-aarch64-sgothel-032.log 2>&1 &
disown $!

connect_40 > androidARMv7-jogamp-arm32-sgothel-040.log 2>&1 &
disown $!

connect_41 > androidArm64-jogamp-aarch64-sgothel-041.log 2>&1 &
disown $!

