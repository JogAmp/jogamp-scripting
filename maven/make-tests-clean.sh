#!/bin/sh -ex

info()
{
  echo "make-tests-clean: info: $1" 1>&2
}

fatal()
{
  echo "make-tests-clean: fatal: $1" 1>&2
  exit 1
}

CURRENT_DIR=`pwd` ||
  fatal "could not save current working directory"

cd tests

rm -f pom.xml

for d in test-*
do
  rm -f "${d}/pom.xml"
done

