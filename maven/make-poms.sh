#!/bin/sh

if [ $# -ne 1 ]
then
  echo "make-poms: usage: version" 1>&2
  exit 1
fi

VERSION="$1"
shift

PROJECTS=`ls projects` || exit 1

for PROJECT in ${PROJECTS}
do
  echo "make-poms: info: generating pom for ${PROJECT}" 1>&2
  ./make-pom-one.sh "${PROJECT}" "${VERSION}" > "output/${PROJECT}.pom.tmp" || exit 1
  mv -n "output/${PROJECT}.pom.tmp" "output/${PROJECT}.pom" || exit 1
done

