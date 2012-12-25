#!/bin/sh

if [ $# -ne 1 ]
then
  echo "usage: version" 1>&2
  exit 1
fi

VERSION="$1"
shift
PLATFORMS=`cat make-platforms.txt | awk -F: '{print $1}'` || exit 1

cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<project
  xmlns="http://maven.apache.org/POM/4.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">

  <!--                                                                 -->
  <!-- Auto generated by gluegen-rt-main.pom.sh, do not edit directly! -->
  <!--                                                                 -->

  <modelVersion>4.0.0</modelVersion>
  <groupId>org.jogamp.gluegen</groupId>
  <artifactId>gluegen-rt-main</artifactId>
  <version>${VERSION}</version>
  <packaging>jar</packaging>
  <name>GlueGen Runtime</name>
  <description>JNI binding generator (runtime)</description>
  <url>http://jogamp.org/gluegen/www/</url>

  <!--                                                                     -->
  <!-- Explicitly depend on gluegen-rt, and all of its native binary jars. -->
  <!--                                                                     -->

  <dependencies>
    <dependency>
      <groupId>\${project.groupId}</groupId>
      <artifactId>gluegen-rt</artifactId>
      <version>\${project.version}</version>
    </dependency>

EOF

for PLATFORM in ${PLATFORMS}
do
  cat <<EOF
    <dependency>
      <groupId>\${project.groupId}</groupId>
      <artifactId>gluegen-rt</artifactId>
      <version>\${project.version}</version>
      <classifier>natives-${PLATFORM}</classifier>
    </dependency>
EOF
done

cat <<EOF
  </dependencies>

EOF

cat gluegen.pom.in || exit 1
cat <<EOF
</project>
EOF