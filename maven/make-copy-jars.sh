#!/bin/sh

info()
{
  echo "make-copy-jars: info: $1" 1>&2
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

PROJECTS=`cat make-projects.txt` || exit 1
PLATFORMS=`cat make-platforms.txt | awk '{print $1}'` || exit 1

IFS="
"

for PROJECT_LINE in ${PROJECTS}
do
  # Determine project name
  NAME=`echo "${PROJECT_LINE}" | awk -F: '{print $1}'` || exit 1
  NAME=`echo "${NAME}"         | tr -d ' '`            || exit 1

  # Determine whether or not the project has native jars
  NATIVES=`echo "${PROJECT_LINE}" | awk -F: '{print $2}'` || exit 1
  NATIVES=`echo "${NATIVES}"      | tr -d ' '`            || exit 1

  # Determine whether or not the project uses an empty "dummy" jar
  DUMMY=`echo "${PROJECT_LINE}" | awk -F: '{print $3}'` || exit 1
  DUMMY=`echo "${DUMMY}"        | tr -d ' '`            || exit 1

  # Determine the source zip file, may be dummy-src
  SRC_ZIP=`echo "${PROJECT_LINE}" | awk -F: '{print $4}'` || exit 1
  SRC_ZIP=`echo "${SRC_ZIP}"      | tr -d ' '`            || exit 1

  # Copy all native jars, if necessary
  if [ "${NATIVES}" = "natives" ]
  then
    for PLATFORM in ${PLATFORMS}
    do
      SOURCE="${INPUT}/jar/${NAME}-natives-${PLATFORM}.jar"
      TARGET="output/${NAME}/${VERSION}/${NAME}-${VERSION}-natives-${PLATFORM}.jar"
      copy "${SOURCE}" "${TARGET}"
    done
  fi

  # Copy dummy jar, if necessary
  if [ "${DUMMY}" = "dummy-jar" ]
  then
    SOURCE="empty.jar"
  else
    # Copy main jar
    SOURCE="${INPUT}/jar/${NAME}.jar"
  fi
  TARGET="output/${NAME}/${VERSION}/${NAME}.jar"
  copy "${SOURCE}" "${TARGET}"

  # Copy dummy jars, if necessary
  if [ "${SRC_ZIP}" = "dummy-src" ]
  then
      SOURCE="empty.jar"
  else
      SOURCE="${INPUT}/${SRC_ZIP}"
  fi
  TARGET="output/${NAME}/${VERSION}/${NAME}-${VERSION}-sources.jar"
  copy "${SOURCE}" "${TARGET}"
 
  # Copy dummy jars to 'javadoc' jars, as we
  # don't publish real versions of these yet.
  SOURCE="empty.jar"
  TARGET="output/${NAME}/${VERSION}/${NAME}-${VERSION}-javadoc.jar"
  copy "${SOURCE}" "${TARGET}"
done

