
. /opt-share/etc/profile.maven

export REPOSITORY_URL="file:///srv/www/jogamp.org/deployment/maven/"
#export REPOSITORY_URL="file:///srv/www/jogamp.org/deployment/test/maven01/"
#export REPOSITORY_URL="scpexe://jogamp.org/srv/www/jogamp.org/deployment/maven/"
#export REPOSITORY_URL="scpexe://jogamp.org/srv/www/jogamp.org/deployment/test/maven01/"
export REPOSITORY_ID="jogamp-mirror"

time ./make-deploy.sh $*
#./make-deploy-one.sh jogl-all-android $*
#./make-deploy-one.sh gluegen-rt-android $*
