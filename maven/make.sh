#!/bin/sh

if [ $# -ne 1 ]
then
  echo "usage: version" 1>&2
  exit 1
fi

VERSION="$1"
shift

INPUT="input/jogamp-all-platforms"
if [ ! -d "${INPUT}" ]
then
  echo "make: error: ${INPUT} is not an existing directory" 1>&2
  echo "make: error: unpack jogamp-all-platforms.7z into 'input'" 1>&2
  exit 1
fi

./clean.sh                         || exit 1
./make-directories.sh "${VERSION}" || exit 1
./make-copy-jars.sh   "${VERSION}" || exit 1
./make-poms.sh        "${VERSION}" || exit 1
./make-copy-poms.sh   "${VERSION}" || exit 1

