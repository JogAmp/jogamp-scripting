
. /opt-share/etc/profile.maven

export REPOSITORY_URL="scpexe://jordan/srv/www/jordan/deployment/maven/"
#export REPOSITORY_URL="file:///net/jordan/srv/www/jordan/deployment/maven/"
export REPOSITORY_ID="jordan-mirror"

time ./make-deploy.sh $*

#./make-deploy-one.sh gluegen $*
#./make-deploy-one.sh gluegen-rt $*
#./make-deploy-one.sh jogl-all-android $*
#./make-deploy-one.sh jogl-all $*
#./make-deploy-one.sh gluegen-rt-android $*

#for i in jogl-all jogl-all-main jogl-all-mobile jogl-all-mobile-main jogl-all-noawt jogl-all-noawt-main jogl-all-android ; do
#    ./make-deploy-one.sh $i $*
#done
