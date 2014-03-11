#!/bin/sh

if [ $# -ne 1 ]
then
  echo "make-directories: usage: version" 1>&2
  exit 1
fi

VERSION="$1"
shift

PROJECTS=`ls projects` || exit 1

for PROJECT in ${PROJECTS}
do
  echo "make-directories: info: creating output/${PROJECT}/${VERSION}" 2>&1
  mkdir -p "output/${PROJECT}/${VERSION}"         || exit 1
done

