#!/bin/sh

if [ $# -ne 1 ]
then
  echo "make-poms: usage: version" 1>&2
  exit 1
fi

VERSION="$1"
shift

PROJECTS=`cat make-projects.txt | awk -F: '{print $1}'` || exit 1

for PROJECT in ${PROJECTS}
do
  echo "make-poms: info: generating pom for ${PROJECT}" 1>&2 
  "./${PROJECT}.pom.sh" "${VERSION}" > "${PROJECT}.pom.tmp" || exit 1
  mv "${PROJECT}.pom.tmp" "${PROJECT}.pom" || exit 1
done

