#!/bin/sh

info()
{
  echo "make-copy-jars-one: info: ${NAME}: $1" 1>&2
}

copy()
{
  SOURCE="$1"
  TARGET="$2"

  info "copy $1 $2.tmp" 1>&2
  cp -n "$1" "$2.tmp" || exit 1
  info "rename $2.tmp $2" 1>&2
  mv -n "$2.tmp" "$2" || exit 1
}

if [ $# -ne 2 ]
then
  info "usage: project version"
  exit 1
fi

NAME="$1"
shift
VERSION="$1"
shift

INPUT="input/jogamp-all-platforms"

if [ ! -d "${INPUT}" ]
then
  echo "make-copy-jars-one: error: ${INPUT} is not an existing directory" 1>&2
  echo "make-copy-jars-one: error: unpack jogamp-all-platforms.7z into 'input'" 1>&2
  exit 1
fi

if [ ! -d "projects/${NAME}" ]
then
  echo "make-copy-jars-one: error: unknown project ${NAME}" 1>&2
  exit 1
fi

# Produce platform list
PLATFORMS=`cat make-platforms.txt | awk '{print $1}'` || exit 1

# Keep a list of all files copied, for deployment later
MANIFEST_FILE="output/${NAME}/${VERSION}/manifest.txt"

#------------------------------------------------------------------------
# Copy all native jars, if necessary
#

NATIVES=`cat projects/${NAME}/natives` || exit 1
if [ "${NATIVES}" = "natives" ]
then
  info "natives: ${NATIVES}"

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
    info "natives: ${NATIVES}"

    for PLATFORM in ${PLATFORMS}
    do
      OUTPUT_NAME="${NAME}-${VERSION}-natives-${PLATFORM}.jar"
      SOURCE="${INPUT}/jar/atomic/${NAME}-natives-${PLATFORM}.jar"
      TARGET="output/${NAME}/${VERSION}/${OUTPUT_NAME}"
      copy "${SOURCE}" "${TARGET}"
      echo "${OUTPUT_NAME}" >> "${MANIFEST_FILE}"
    done
  else
    info "natives: not required"
  fi
fi

#------------------------------------------------------------------------
# Copy dummy code jars, if necessary.
#

DUMMY=`cat projects/${NAME}/dummy-jar` || exit 1
if [ "${DUMMY}" = "dummy-jar" ]
then
  info "dummy-jar: required"
  OUTPUT_NAME="${NAME}.jar"
  SOURCE="empty.jar"
else
  info "dummy-jar: not required (copying main jar)"
  # Copy main jar
  OUTPUT_NAME="${NAME}.jar"
  SOURCE="${INPUT}/jar/${OUTPUT_NAME}"
fi
TARGET="output/${NAME}/${VERSION}/${OUTPUT_NAME}"
copy "${SOURCE}" "${TARGET}"
echo "${OUTPUT_NAME}" >> "${MANIFEST_FILE}"

#------------------------------------------------------------------------
# Copy dummy source code jars, if necessary
#

SRC_ZIP=`cat projects/${NAME}/source-zip` || exit 1
if [ "${SRC_ZIP}" = "dummy-src" ]
then
  info "source-zip: dummy source zip required"
  OUTPUT_NAME="${NAME}-${VERSION}-sources.jar"
  SOURCE="empty.jar"
else
  info "source-zip: ${INPUT}/${SRC_ZIP}"
  OUTPUT_NAME="${NAME}-${VERSION}-sources.jar"
  SOURCE="${INPUT}/${SRC_ZIP}"
fi
TARGET="output/${NAME}/${VERSION}/${OUTPUT_NAME}"
copy "${SOURCE}" "${TARGET}"
echo "${OUTPUT_NAME}" >> "${MANIFEST_FILE}"

#------------------------------------------------------------------------
# Copy dummy jars to 'javadoc' jars, as we don't publish real versions of these yet.
#

OUTPUT_NAME="${NAME}-${VERSION}-javadoc.jar"
SOURCE="empty.jar"
TARGET="output/${NAME}/${VERSION}/${OUTPUT_NAME}"
copy "${SOURCE}" "${TARGET}"
echo "${OUTPUT_NAME}" >> "${MANIFEST_FILE}"

#------------------------------------------------------------------------
# Copy atomics, if necessary
#

ATOMICS=`cat projects/${NAME}/atomics` || exit 1
if [ ! -z "${ATOMICS}" ]
then
  info "atomics: ${ATOMICS}"
  for ATOMIC in ${ATOMICS}
  do
    JAR_NAME="${NAME}-${VERSION}-${ATOMIC}.jar"
    SOURCE="${INPUT}/jar/atomic/${NAME}-${ATOMIC}.jar"
    TARGET="output/${NAME}/${VERSION}/${JAR_NAME}"
    copy "${SOURCE}" "${TARGET}"
    echo "${JAR_NAME}" >> "${MANIFEST_FILE}"
  done
else
  info "atomics: no atomics required"
fi

