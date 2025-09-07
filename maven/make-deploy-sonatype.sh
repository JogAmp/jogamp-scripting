#!/bin/sh

. /opt-share/etc/profile.maven

sdir_0=`dirname $0`
sdir=`readlink -f $sdir_0`
. $sdir/sonatype_api.sh

export REPOSITORY_URL="https://ossrh-staging-api.central.sonatype.com/service/local/staging/deploy/maven2/"
export REPOSITORY_ID="jogamp-sonatype"

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

#PROJECTS="gluegen gluegen-rt gluegen-rt-android gluegen-rt-main joal joal-android joal-main jocl jocl-android jocl-main jogl jogl-all jogl-all-android jogl-all-main jogl-all-mobile jogl-all-mobile-main jogl-all-noawt jogl-all-noawt-main jogl-main nativewindow nativewindow-main newt newt-main"
PROJECTS=`ls projects` || exit 1

for NAME in ${PROJECTS}
do
    echo "Sonatype Drop Staging"
    sonatype_drop_staging "${api_repository_key}"
    if [ $? -ne 0 ] ; then
      echo "Failure: sonatype_upload_staging" >&2
      exit 1
    fi
    sonatype_search_repos
    echo
    echo
    sleep 2s

    ./make-deploy-one.sh "${NAME}" "${VERSION}"
    if [ $? -ne 0 ] ; then
      echo "Failure: ./make-deploy-one.sh" >&2
      exit 1
    fi

    echo
    echo "Sonatype Upload"
    sleep 2s
    sonatype_upload_staging "${api_repository_key}"
    if [ $? -ne 0 ] ; then
      echo "Failure: sonatype_upload_staging" >&2
      exit 1
    fi
    echo
    echo
    echo "Sonatype Repos Post Upload"
    sonatype_search_repos
    echo
    echo
    sleep 2s
done

