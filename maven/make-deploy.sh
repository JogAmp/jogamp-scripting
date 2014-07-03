#!/bin/sh

info()
{
  echo "make-deploy: info: $1" 1>&2
}

if [ $# -ne 1 ]
then
  info "usage: version"
  exit 1
fi

VERSION="$1"
shift

PROJECTS=`ls projects` || exit 1
PLATFORMS=`cat make-platforms.txt | awk '{print $1}'` || exit 1

for NAME in ${PROJECTS}
do
  ./make-deploy-one.sh "${NAME}" "${VERSION}"
done

