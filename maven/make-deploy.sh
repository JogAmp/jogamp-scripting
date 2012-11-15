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

PROJECTS=`./make-list-projects.sh` || exit 1
PLATFORMS=`cat make-platforms.txt | awk '{print $1}'` || exit 1

CURRENT_DIR=`pwd` || exit 1

# Set internal field separator to newlines so that ${PROJECTS} is
# tokenized per-line.
IFS="
"

for PROJECT_LINE in ${PROJECTS}
do
  # Determine project name
  NAME=`echo "${PROJECT_LINE}" | awk -F: '{print $1}'` || exit 1
  NAME=`echo "${NAME}"         | tr -d ' '`            || exit 1

  ./make-deploy-one.sh "${NAME}" "${VERSION}"
done

