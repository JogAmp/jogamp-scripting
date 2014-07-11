#!/bin/sh -ex

info()
{
  echo "make-tests: info: $1" 1>&2
}

fatal()
{
  echo "make-tests: fatal: $1" 1>&2
  exit 1
}

if [ $# -ne 1 ]
then
  echo "usage: version" 1>&2
  exit 1
fi

VERSION="$1"
shift

CURRENT_DIR=`pwd` ||
  fatal "could not save current working directory"

export REPOSITORY_URL="file://${PWD}/tests-repository"

cd tests

./pom.sh pom.in "${VERSION}" > pom.xml.tmp ||
  fatal "could not generate pom.xml"
mv pom.xml.tmp pom.xml ||
  fatal "could not rename pom.xml"

CURRENT_TEST_DIR=`pwd` ||
  fatal "could not save current working directory"

for d in test-*
do
  ./pom.sh "${d}/pom.in" "${VERSION}" > "${d}/pom.xml.tmp" ||
    fatal "could not generate pom.xml"
  mv "${d}/pom.xml.tmp" "${d}/pom.xml" ||
    fatal "could not rename pom.xml"
done

