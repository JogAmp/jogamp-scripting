#!/bin/sh

info()
{
  echo "make-deploy-one: info: $1" 1>&2
}

if [ $# -ne 2 ]
then
  info "usage: name version"
  exit 1
fi

NAME="$1"
shift
VERSION="$1"
shift

if [ -z "${REPOSITORY_URL}" -o -z "${REPOSITORY_ID}" ] ; then
    REPOSITORY_URL="https://oss.sonatype.org/service/local/staging/deploy/maven2/"
    REPOSITORY_ID="sonatype-nexus-staging"
    # REPOSITORY_URL="scpexe://jogamp.org/home/mraynsford/repository/"
    # REPOSITORY_ID="jogamp-test-mirror"
    # REPOSITORY_URL="scpexe://jogamp.org/srv/www/jogamp.org/deployment/maven/"
    # REPOSITORY_ID="jogamp-mirror"
fi

PLATFORMS=`cat make-platforms.txt | awk '{print $1}'` || exit 1
CURRENT_DIR=`pwd` || exit 1

PROJECT_LINE=`./make-list-projects.sh | egrep "^${NAME}\s+"` || exit 1

# Determine whether or not the project has native jars
NATIVES=`echo "${PROJECT_LINE}" | awk -F: '{print $2}'` || exit 1
NATIVES=`echo "${NATIVES}"      | tr -d ' '`            || exit 1

cd "output/${NAME}/${VERSION}" || exit 1

# Deploy jar.
mvn gpg:sign-and-deploy-file        \
  "-DpomFile=pom.xml"               \
  "-Dfile=${NAME}.jar"              \
  "-Durl=${REPOSITORY_URL}"         \
  "-DrepositoryId=${REPOSITORY_ID}"

# Deploy native jars into repository, if necessary.
if [ "${NATIVES}" = "natives" ]
then
  for PLATFORM in ${PLATFORMS}
  do
    mvn gpg:sign-and-deploy-file                          \
      "-DpomFile=pom.xml"                                 \
      "-Dfile=${NAME}-${VERSION}-natives-${PLATFORM}.jar" \
      "-Dclassifier=natives-${PLATFORM}"                  \
      "-Durl=${REPOSITORY_URL}"                           \
      "-DrepositoryId=${REPOSITORY_ID}"
  done
fi

# Deploy empty 'sources' and 'javadoc' jars.
mvn gpg:sign-and-deploy-file              \
  "-DpomFile=pom.xml"                     \
  "-Dfile=${NAME}-${VERSION}-javadoc.jar" \
  "-Dclassifier=javadoc"                  \
  "-Durl=${REPOSITORY_URL}"               \
  "-DrepositoryId=${REPOSITORY_ID}"

mvn gpg:sign-and-deploy-file              \
  "-DpomFile=pom.xml"                     \
  "-Dfile=${NAME}-${VERSION}-sources.jar" \
  "-Dclassifier=sources"                  \
  "-Durl=${REPOSITORY_URL}"               \
  "-DrepositoryId=${REPOSITORY_ID}"

