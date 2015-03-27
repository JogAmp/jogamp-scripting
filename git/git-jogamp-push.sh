#! /bin/sh

set -x

#GIT_ARGS="--mirror"
#GIT_ARGS="--all"

echo origin
git push $GIT_ARGS origin $*
echo jausoft
git push $GIT_ARGS jausoft $*
echo jogamp
git push $GIT_ARGS jogamp $*
echo github-jogamp
git push $GIT_ARGS github-jogamp $*
