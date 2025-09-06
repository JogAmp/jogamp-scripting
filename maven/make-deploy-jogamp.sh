
. /opt-share/etc/profile.maven

export REPOSITORY_URL="scpexe://jogamp.org/srv/www/jogamp.org/deployment/maven/"
#export REPOSITORY_URL="scpexe://jogamp@jogamp.org/srv/www/jogamp.org/deployment/test/maven01/"
export REPOSITORY_ID="jogamp-mirror"

time ./make-deploy.sh $*
