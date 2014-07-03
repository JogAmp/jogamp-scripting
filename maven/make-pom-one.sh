#!/bin/sh

if [ $# -ne 2 ]
then
  echo "make-pom-one: usage: project version" 1>&2
  exit 1
fi

PROJECT="$1"
shift
VERSION="$1"
shift

PLATFORMS=`cat make-platforms.txt | awk '{print $1}'` || exit 1

cd "projects/${PROJECT}" || exit 1
exec ./pom.sh "${VERSION}" ${PLATFORMS}
