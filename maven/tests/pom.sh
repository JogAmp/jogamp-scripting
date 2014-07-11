#!/bin/sh

if [ $# -ne 2 ]
then
  echo "usage: pom.in version" 1>&2
  exit 1
fi

POM_IN="$1"
shift
VERSION="$1"
shift

if [ -z "${REPOSITORY_URL}" ]
then
  echo "REPOSITORY_URL is unset" 1>&2
  exit 1
fi

exec m4 \
  -DJOGAMP_VERSION="${VERSION}" -DREPOSITORY_URL="${REPOSITORY_URL}" < "${POM_IN}"
