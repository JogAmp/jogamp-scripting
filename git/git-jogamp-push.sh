#! /bin/sh

set -x

#GIT_ARGS="--mirror"
#GIT_ARGS="--all"

echo jordan
git push $GIT_ARGS jordan $*
echo jogamp
git push $GIT_ARGS jogamp $*
echo jausoft
git push $GIT_ARGS jausoft $*
echo origin
git push $GIT_ARGS origin $*
echo github-jogamp
git push $GIT_ARGS github-jogamp $*
echo gitlab-jogamp
git push $GIT_ARGS gitlab-jogamp $*
