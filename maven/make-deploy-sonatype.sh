
. /opt-share/etc/profile.maven

export REPOSITORY_URL="https://oss.sonatype.org/service/local/staging/deploy/maven2/"
export REPOSITORY_ID="jogamp-sonatype"

time ./make-deploy.sh $*
