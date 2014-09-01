set J2RE_HOME=c:\jre1.8.0_20_x32
set JAVA_HOME=c:\jdk1.8.0_20_x32
set ANT_PATH=C:\apache-ant-1.9.4
set GIT_PATH=C:\cygwin\bin
set SEVENZIP=C:\Program Files\7-Zip

set CMAKE_PATH=C:\cmake-2.8.10.2-win32-x86
set CMAKE_C_COMPILER=c:\mingw\bin\gcc

set PATH=%JAVA_HOME%\bin;%ANT_PATH%\bin;c:\mingw\bin;%CMAKE_PATH%\bin;%GIT_PATH%;%SEVENZIP%;%PATH%

set SOURCE_LEVEL=1.6
set TARGET_LEVEL=1.6
set TARGET_RT_JAR=C:\jre1.6.0_30\lib\rt.jar

set JOGAMP_JAR_CODEBASE=Codebase: *.jogamp.org

REM    -Dc.compiler.debug=true 
REM    -DuseOpenMAX=true 
REM    -DuseKD=true
REM    -Djogl.cg=1 -D-Dwindows.cg.lib=C:\Cg-2.2
REM    -Dbuild.noarchives=true

java -server -Xmx1024m -jar slave.jar -jnlpUrl https://jogamp.org/chuck/computer/win64-nvgtx460-win7-jogamp-x32-sgothel-010/slave-agent.jnlp
