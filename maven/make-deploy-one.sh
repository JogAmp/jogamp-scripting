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
  REPOSITORY_ID="jogamp-sonatype"
  # REPOSITORY_URL="scpexe://jogamp.org/srv/www/jogamp.org/deployment/maven/"
  # REPOSITORY_ID="jogamp-mirror"
fi

info "using repository: ${REPOSITORY_ID} ${REPOSITORY_URL}"

CURRENT_DIR=`pwd` || exit 1

cd "output/${NAME}/${VERSION}" || exit 1

# Maintain a list of extra files, along with their classifiers, to deploy.
DEPLOY_FILES=""
DEPLOY_CLASSIFIERS=""
DEPLOY_TYPES=""

for LINE in `cat manifest.txt`
do
  if [ "${LINE}" = "${NAME}.jar" ]
  then
    true
  else
    CLASS=`echo ${LINE} | sed "s/^${NAME}-${VERSION}-//g; s/\.jar$//g"`

    if [ ! -z "${DEPLOY_FILES}" ]
    then
      DEPLOY_FILES="${DEPLOY_FILES},${LINE}"
      DEPLOY_CLASSIFIERS="${DEPLOY_CLASSIFIERS},${CLASS}"
      DEPLOY_TYPES="${DEPLOY_TYPES},jar"
    else
      DEPLOY_FILES="${LINE}"
      DEPLOY_CLASSIFIERS="${CLASS}"
      DEPLOY_TYPES="jar"
    fi
  fi
done

# Deploy everything.

which mvn
mvn --version

# echo "NAME: ${NAME}"
# echo "DEPLOY_FILES: ${DEPLOY_FILES}"
# echo "REPOSITORY_URL: ${REPOSITORY_URL}"
# echo "REPOSITORY_ID: ${REPOSITORY_ID}"

mvn gpg:sign-and-deploy-file            \
  "-DpomFile=pom.xml"                   \
  "-Dfile=${NAME}.jar"                  \
  "-Dfiles=${DEPLOY_FILES}"             \
  "-Dclassifiers=${DEPLOY_CLASSIFIERS}" \
  "-Dtypes=${DEPLOY_TYPES}"             \
  "-Durl=${REPOSITORY_URL}"             \
  "-DrepositoryId=${REPOSITORY_ID}"

