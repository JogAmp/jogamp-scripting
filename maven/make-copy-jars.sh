#!/bin/sh

info()
{
  echo "make-copy-jars: info: $1" 1>&2
}

if [ $# -ne 1 ]
then
  info "usage: version"
  exit 1
fi

VERSION="$1"
shift

INPUT="input/jogamp-all-platforms"

if [ ! -d "${INPUT}" ]
then
  echo "make-copy-jars: error: ${INPUT} is not an existing directory" 1>&2
  echo "make-copy-jars: error: unpack jogamp-all-platforms.7z into 'input'" 1>&2
  exit 1
fi

PROJECTS=`ls projects` || exit 1
PLATFORMS=`cat make-platforms.txt | awk '{print $1}'` || exit 1

for PROJECT in ${PROJECTS}
do
  ./make-copy-jars-one.sh "${PROJECT}" "${VERSION}" || exit 1
done

