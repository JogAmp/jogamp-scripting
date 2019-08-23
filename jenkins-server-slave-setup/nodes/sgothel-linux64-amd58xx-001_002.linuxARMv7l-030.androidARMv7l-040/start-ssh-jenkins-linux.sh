#! /bin/bash

# Bug 1386: Mesa 18.3.6 hardware renderer (Intel/AMD) freezes after native parenting
export LIBGL_ALWAYS_SOFTWARE=true

cd ~/jenkins

JENKINS_NODE_STARTUP_DIR=`pwd`

#scp chuckslave@jogamp.org:/srv/jenkins/war/WEB-INF/slave.jar .
curl -O https://jogamp.org/chuck/jnlpJars/agent.jar

function connect_1 {
  . ./profile.ant
  . ./profile.i386.j2se11

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
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6001:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx512m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/linux64-AMD58xx-debian7-jogamp-x32-sgothel-001/slave-agent.jnlp
  done
}

function connect_2 {
  . ./profile.ant
  . ./profile.amd64.j2se11

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
    ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 5" -o "TCPKeepAlive yes" chuckslave@jogamp.org -L 6002:localhost:5555 -N &
    sshpid=$!
    java -server -Xmx512m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/linux64-AMD58xx-debian7-jogamp-x64-sgothel-002/slave-agent.jnlp 
  done
}

function connect_31 {
  . ./profile.ant
  . ./profile.amd64.j2se11

  export SOURCE_LEVEL=1.8
  export TARGET_LEVEL=1.8
  export TARGET_RT_JAR=/opt-share/jre1.8.0_212/lib/rt.jar

  export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

    export NODE_LABEL=label/linux-armv7hf-img
    HOST_ROOT=/home/jogamp/JogAmpSlaveARMv7hf
    JENKINS_WS=$HOST_ROOT/workspace

    # arm-linux-gnueabi == armel triplet
    PATH=$JENKINS_NODE_STARTUP_DIR/toolchain/armhf-linux-gnueabi/bin:$PATH
    export PATH

    export HOST_UID=jogamp
    export HOST_IP=jogamp02
    export HOST_RSYNC_ROOT=ROOTDIR/$JENKINS_WS

    export TARGET_UID=jogamp
    export TARGET_IP=panda01
    export TARGET_ROOT=/home/jogamp/JogAmpSlaveARMv7hf
    export TARGET_ANT_HOME=/usr/share/ant

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

    export NODE_LABEL=label/linux-armv7hf-img
    HOST_ROOT=/home/jogamp/JogAmpSlaveARM64
    JENKINS_WS=$HOST_ROOT/workspace

    # arm-linux-gnueabi == armel triplet
    PATH=$JENKINS_NODE_STARTUP_DIR/toolchain/aarch64-linux-gnueabi/bin:$PATH
    export PATH

    export HOST_UID=jogamp
    export HOST_IP=jogamp02
    export HOST_RSYNC_ROOT=ROOTDIR/$JENKINS_WS

    export TARGET_UID=jogamp
    export TARGET_IP=panda01
    export TARGET_ROOT=/home/jogamp/JogAmpSlaveARMv7hf
    export TARGET_ANT_HOME=/usr/share/ant

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

    export NODE_LABEL=label/android-armv7-img
    HOST_ROOT=/home/jogamp/JogAmpSlaveARMv7_Android
    JENKINS_WS=$HOST_ROOT/workspace

    export HOST_UID=jogamp
    # jogamp02 - 10.1.0.122
    export HOST_IP=10.1.0.122
    export HOST_RSYNC_ROOT=ROOTDIR/$JENKINS_WS

    export TARGET_UID=jogamp
    export TARGET_IP=panda02
    #export TARGET_IP=jautab03
    #export TARGET_IP=jauphone04
    export TARGET_ADB_PORT=5555
    # needs executable bit (probably su)
    export TARGET_ROOT=/data/projects
    export TARGET_ANT_HOME=/usr/share/ant

    export NDK_ROOT=/opt-linux-x86_64/android-ndk
    export ANDROID_HOME=/opt-linux-x86_64/android-sdk-linux_x86_64
    export ANDROID_BUILD_TOOLS_VERSION=21.1.2

    echo NDK_ROOT $NDK_ROOT
    echo ANDROID_HOME $ANDROID_HOME
    echo ANDROID_BUILD_TOOLS_VERSION $ANDROID_BUILD_TOOLS_VERSION

    export ANDROID_VERSION=24
    export SOURCE_LEVEL=1.8
    export TARGET_LEVEL=1.8
    export TARGET_RT_JAR=/opt-share/jre1.8.0_212/lib/rt.jar

    export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

    export GCC_VERSION=4.9
    export HOST_ARCH=linux-x86_64
    export TARGET_TRIPLE=arm-linux-androideabi

    export NDK_TOOLCHAIN_ROOT=$NDK_ROOT/toolchains/${TARGET_TRIPLE}-${GCC_VERSION}/prebuilt/${HOST_ARCH}
    export TARGET_PLATFORM_SYSROOT=${NDK_ROOT}/platforms/android-${ANDROID_VERSION}/arch-arm

    # Need to add toolchain bins to the PATH. 
    export PATH_VANILLA=$PATH
    # TODO: Check/Replace $ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION for aapt, dx, dexdump, zipalign etc
    export PATH="$NDK_TOOLCHAIN_ROOT/$TARGET_TRIPLE/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$PATH"

    export GLUEGEN_CPPTASKS_FILE=make/lib/gluegen-cpptasks-android-armv6.xml
    export GLUEGEN_PROPERTIES_FILE=/home/jogamp/android/gluegen.properties # for key signing props

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

    export NODE_LABEL=label/android-aarch64
    HOST_ROOT=/home/jogamp/JogAmpSlaveArm64_Android
    JENKINS_WS=$HOST_ROOT/workspace

    export HOST_UID=jogamp
    # jogamp02 - 10.1.0.122
    export HOST_IP=10.1.0.122
    export HOST_RSYNC_ROOT=ROOTDIR/$JENKINS_WS

    export TARGET_UID=jogamp
    export TARGET_IP=panda02
    #export TARGET_IP=jautab03
    #export TARGET_IP=jauphone04
    export TARGET_ADB_PORT=5555
    # needs executable bit (probably su)
    export TARGET_ROOT=/data/projects
    export TARGET_ANT_HOME=/usr/share/ant

    export NDK_ROOT=/opt-linux-x86_64/android-ndk
    export ANDROID_HOME=/opt-linux-x86_64/android-sdk-linux_x86_64
    export ANDROID_BUILD_TOOLS_VERSION=21.1.2

    echo NDK_ROOT $NDK_ROOT
    echo ANDROID_HOME $ANDROID_HOME
    echo ANDROID_BUILD_TOOLS_VERSION $ANDROID_BUILD_TOOLS_VERSION

    export ANDROID_VERSION=24
    export SOURCE_LEVEL=1.8
    export TARGET_LEVEL=1.8
    export TARGET_RT_JAR=/opt-share/jre1.8.0_212/lib/rt.jar

    export JOGAMP_JAR_CODEBASE="Codebase: *.jogamp.org"

    export GCC_VERSION=4.9
    export HOST_ARCH=linux-x86_64
    export TARGET_TRIPLE=aarch64-linux-android

    export NDK_TOOLCHAIN_ROOT=$NDK_ROOT/toolchains/${TARGET_TRIPLE}-${GCC_VERSION}/prebuilt/${HOST_ARCH}
    export TARGET_PLATFORM_SYSROOT=${NDK_ROOT}/platforms/android-${ANDROID_VERSION}/arch-arm64

    # Need to add toolchain bins to the PATH. 
    export PATH_VANILLA=$PATH
    # TODO: Check/Replace $ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION for aapt, dx, dexdump, zipalign etc
    export PATH="$NDK_TOOLCHAIN_ROOT/$TARGET_TRIPLE/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$PATH"

    export GLUEGEN_CPPTASKS_FILE=make/lib/gluegen-cpptasks-android-aarch64.xml
    export GLUEGEN_PROPERTIES_FILE=/home/jogamp/android/gluegen.properties # for key signing props

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

#connect_1 > linux64-AMD58xx-debian7-jogamp-x32-sgothel-001.log 2>&1 &
#disown $!

connect_2 > linux64-AMD58xx-debian7-jogamp-x64-sgothel-002.log 2>&1 &
disown $!

connect_31 > linuxARMv7hf-jogamp-arm32hf-sgothel-031.log 2>&1 &
disown $!

connect_32 > linuxARM64-jogamp-aarch64-sgothel-032.log 2>&1 &
disown $!

connect_40 > androidARMv7-jogamp-arm32-sgothel-040.log 2>&1 &
disown $!

connect_41 > androidArm64-jogamp-aarch64-sgothel-041.log 2>&1 &
disown $!

