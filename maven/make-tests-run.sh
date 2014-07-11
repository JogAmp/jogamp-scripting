#!/bin/sh

CACHE_PATH=`realpath tests-cache` || exit 1

cd tests || exit 1

rm -f maven-settings.xml || exit 1

cat > maven-settings.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<settings
  xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <localRepository>${CACHE_PATH}</localRepository>
</settings>
EOF

exec mvn --settings maven-settings.xml -U -C clean test
