#!/bin/sh

info()
{
  echo "make-copy-poms: info: $1" 1>&2
}

copy()
{
  SOURCE="$1"
  TARGET="$2"

  info "copy $1 $2.tmp" 1>&2
  cp "$1" "$2.tmp" || exit 1
  info "rename $2.tmp $2" 1>&2
  mv "$2.tmp" "$2" || exit 1
}

if [ $# -ne 1 ]
then
  echo "make-copy-poms: usage: version" 1>&2
  exit 1
fi

VERSION="$1"
shift

PROJECTS=`ls projects` || exit 1

for PROJECT in ${PROJECTS}
do
  SOURCE="output/${PROJECT}.pom"
  TARGET="output/${PROJECT}/${VERSION}/${PROJECT}-${VERSION}.pom"
  copy "${SOURCE}" "${TARGET}"
  TARGET="output/${PROJECT}/${VERSION}/pom.xml"
  copy "${SOURCE}" "${TARGET}"
done

