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
  cp -n "$1" "$2.tmp" || exit 1
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

PROJECTS=`./make-list-projects.sh` || exit 1
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

  # Determine whether or not the project has atomic jars
  ATOMICS=`echo "${PROJECT_LINE}" | awk -F: '{print $5}'` || exit 1

  # Keep a list of all files copied, for deployment later
  MANIFEST_FILE="output/${NAME}/${VERSION}/manifest.txt"

  # Copy all native jars, if necessary
  if [ "${NATIVES}" = "natives" ]
  then
    for PLATFORM in ${PLATFORMS}
    do
      OUTPUT_NAME="${NAME}-${VERSION}-natives-${PLATFORM}.jar"
      SOURCE="${INPUT}/jar/${NAME}-natives-${PLATFORM}.jar"
      TARGET="output/${NAME}/${VERSION}/${OUTPUT_NAME}"
      copy "${SOURCE}" "${TARGET}"
      echo "${OUTPUT_NAME}" >> "${MANIFEST_FILE}"
    done
  else
    if [ "${NATIVES}" = "atomic-natives" ]
    then
      for PLATFORM in ${PLATFORMS}
      do
        OUTPUT_NAME="${NAME}-${VERSION}-natives-${PLATFORM}.jar"
        SOURCE="${INPUT}/jar/atomic/${NAME}-natives-${PLATFORM}.jar"
        TARGET="output/${NAME}/${VERSION}/${OUTPUT_NAME}"
        copy "${SOURCE}" "${TARGET}"
        echo "${OUTPUT_NAME}" >> "${MANIFEST_FILE}"
      done
    fi
  fi

  # Copy dummy jar, if necessary
  if [ "${DUMMY}" = "dummy-jar" ]
  then
    OUTPUT_NAME="${NAME}.jar"
    SOURCE="empty.jar"
  else
    # Copy main jar
    OUTPUT_NAME="${NAME}.jar"
    SOURCE="${INPUT}/jar/${OUTPUT_NAME}"
  fi
  TARGET="output/${NAME}/${VERSION}/${OUTPUT_NAME}"
  copy "${SOURCE}" "${TARGET}"
  echo "${OUTPUT_NAME}" >> "${MANIFEST_FILE}"

  # Copy dummy jars, if necessary
  if [ "${SRC_ZIP}" = "dummy-src" ]
  then
    OUTPUT_NAME="${NAME}-${VERSION}-sources.jar"
    SOURCE="empty.jar"
  else
    SOURCE="${INPUT}/${SRC_ZIP}"
  fi
  TARGET="output/${NAME}/${VERSION}/${OUTPUT_NAME}"
  copy "${SOURCE}" "${TARGET}"
  echo "${OUTPUT_NAME}" >> "${MANIFEST_FILE}"

  # Copy dummy jars to 'javadoc' jars, as we
  # don't publish real versions of these yet.
  OUTPUT_NAME="${NAME}-${VERSION}-javadoc.jar"
  SOURCE="empty.jar"
  TARGET="output/${NAME}/${VERSION}/${OUTPUT_NAME}"
  copy "${SOURCE}" "${TARGET}"
  echo "${OUTPUT_NAME}" >> "${MANIFEST_FILE}"

  # Copy atomics, if necessary
  if [ ! -z "${ATOMICS}" ]
  then
    info "atomics: ${ATOMICS}"
    IFS=" "
    for ATOMIC in ${ATOMICS}
    do
      JAR_NAME="${NAME}-${VERSION}-${ATOMIC}.jar"
      SOURCE="${INPUT}/jar/atomic/${NAME}-${ATOMIC}.jar"
      TARGET="output/${NAME}/${VERSION}/${JAR_NAME}"
      copy "${SOURCE}" "${TARGET}"
      echo "${JAR_NAME}" >> "${MANIFEST_FILE}"
    done
    IFS="
"
  fi
done

