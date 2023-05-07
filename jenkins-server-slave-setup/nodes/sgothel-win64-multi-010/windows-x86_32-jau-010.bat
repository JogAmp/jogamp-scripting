set J2RE_HOME=c:\jdk-17
set JAVA_HOME=c:\jdk-17
set ANT_PATH=C:\apache-ant-1.10.5
set GIT_PATH=C:\cygwin64\bin
set SEVENZIP=C:\Program Files\7-Zip

set CMAKE_PATH=C:\cmake-3.25.1-windows-x86_64
set CMAKE_C_COMPILER=c:\mingw64\bin\gcc

set PATH=%J2RE_HOME%\bin;%JAVA_HOME%\bin;%ANT_PATH%\bin;c:\mingw32\bin;%CMAKE_PATH%\bin;%GIT_PATH%;%SEVENZIP%;%PATH%

set SOURCE_LEVEL=1.8
set TARGET_LEVEL=1.8
set TARGET_RT_JAR=C:\jre1.8.0_212\lib\rt.jar

set JOGAMP_JAR_CODEBASE=Codebase: *.jogamp.org

REM    -Dc.compiler.debug=true 
REM    -DuseOpenMAX=true 
REM    -DuseKD=true
REM    -Djogl.cg=1 -D-Dwindows.cg.lib=C:\Cg-2.2
REM    -Dbuild.noarchives=true

REM java  -server -Xmx1024m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/win32-windows-jogamp-x32-sgothel-010/slave-agent.jnlp
java  -server -Xmx1024m -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/windows-x86_32-jau-010/slave-agent.jnlp
