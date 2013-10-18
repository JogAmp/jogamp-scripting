set J2RE_HOME=c:\jre1.7.0_45_x32
set JAVA_HOME=c:\jdk1.7.0_45_x32
set ANT_PATH=C:\apache-ant-1.8.2
set GIT_PATH=C:\cygwin\bin
set SEVENZIP=C:\Program Files\7-Zip

set PATH=%JAVA_HOME%\bin;%ANT_PATH%\bin;c:\mingw\bin;%GIT_PATH%;%SEVENZIP%;%PATH%

set SOURCE_LEVEL=1.6
set TARGET_LEVEL=1.6
set TARGET_RT_JAR=C:\jre1.6.0_30\lib\rt.jar

set JOGAMP_JAR_CODEBASE=Codebase: *.jogamp.org

REM    -Dc.compiler.debug=true 
REM    -DuseOpenMAX=true 
REM    -DuseKD=true
REM    -Djogl.cg=1 -D-Dwindows.cg.lib=C:\Cg-2.2
REM    -Dbuild.noarchives=true

java -server -Xmx1024m -jar slave.jar -jnlpUrl https://jogamp.org/chuck/computer/win64-amd58xx-win7-jogamp-x32-c3d-001/slave-agent.jnlp
