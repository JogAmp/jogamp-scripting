#!/bin/sh

if [ $# -ne 1 ]
then
  echo "usage: version" 1>&2
  exit 1
fi

VERSION="$1"
shift

PWD=`pwd` || exit 1

export REPOSITORY_ID="tests"
export REPOSITORY_URL="file://${PWD}/tests-repository"

./make-deploy.sh "${VERSION}"
