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

info "using repository: ${REPOSITORY_ID} ${REPOSITORY_URL}"

PLATFORMS=`cat make-platforms.txt | awk '{print $1}'` || exit 1
CURRENT_DIR=`pwd` || exit 1

PROJECT_LINE=`./make-list-projects.sh | egrep "^${NAME}\s+"` || exit 1

# Determine whether or not the project has native jars
NATIVES=`echo "${PROJECT_LINE}" | awk -F: '{print $2}'` || exit 1
NATIVES=`echo "${NATIVES}"      | tr -d ' '`            || exit 1

cd "output/${NAME}/${VERSION}" || exit 1

# Maintain a list of extra files, along with their classifiers, to deploy.
DEPLOY_EXTRA_FILES=""
DEPLOY_EXTRA_CLASSIFIERS=""
DEPLOY_EXTRA_TYPES=""

# Deploy javadoc jar
f="${NAME}-${VERSION}-javadoc.jar"
info "adding file ${f}"
DEPLOY_EXTRA_FILES="${f}"
DEPLOY_EXTRA_CLASSIFIERS="javadoc"
DEPLOY_EXTRA_TYPES="jar"

# Deploy source jar
f="${NAME}-${VERSION}-sources.jar"
info "adding file ${f}"
DEPLOY_EXTRA_FILES="${DEPLOY_EXTRA_FILES},${f}"
DEPLOY_EXTRA_CLASSIFIERS="${DEPLOY_EXTRA_CLASSIFIERS},sources"
DEPLOY_EXTRA_TYPES="${DEPLOY_EXTRA_TYPES},jar"

# Deploy native jars into repository, if necessary.
if [ "${NATIVES}" = "natives" ]
then
  for PLATFORM in ${PLATFORMS}
  do
    f="${NAME}-${VERSION}-natives-${PLATFORM}.jar"
    DEPLOY_EXTRA_FILES="${DEPLOY_EXTRA_FILES},${f}"
    DEPLOY_EXTRA_CLASSIFIERS="${DEPLOY_EXTRA_CLASSIFIERS},natives-${PLATFORM}"
    DEPLOY_EXTRA_TYPES="${DEPLOY_EXTRA_TYPES},jar"
    info "adding file ${f}"
  done
fi

# Deploy everything.
mvn gpg:sign-and-deploy-file                  \
  "-DpomFile=pom.xml"                         \
  "-Dfile=${NAME}.jar"                        \
  "-Dfiles=${DEPLOY_EXTRA_FILES}"             \
  "-Dclassifiers=${DEPLOY_EXTRA_CLASSIFIERS}" \
  "-Dtypes=${DEPLOY_EXTRA_TYPES}"             \
  "-Durl=${REPOSITORY_URL}"                   \
  "-DrepositoryId=${REPOSITORY_ID}"

