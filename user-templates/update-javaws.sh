groot=/usr/local/projects/JOGL/gluegen
aroot=/usr/local/projects/JOGL/joal
jroot=/usr/local/projects/JOGL/jogl

rm -rf /srv/www/jogamp.org/deployment/test/jau01s

cp -av $groot/build-x86_64/gluegen-rt.jar $groot/build-x86_64/*natives*jar /srv/www/jogamp.org/deployment/archive/jau01/
cp -av $aroot/build-x86_64/joal.jar $aroot/build-x86_64/*natives*jar /srv/www/jogamp.org/deployment/archive/jau01/
cp -av $jroot/build-x86_64/jar/*all*jar $jroot/build-x86_64/jar/*natives*jar /srv/www/jogamp.org/deployment/archive/jau01/

cp -av $groot/jnlp-files/* /srv/www/jogamp.org/deployment/archive/jau01/jnlp-files/
cp -av $aroot/jnlp-files/* /srv/www/jogamp.org/deployment/archive/jau01/jnlp-files/
cp -av $jroot/jnlp-files/* /srv/www/jogamp.org/deployment/archive/jau01/jnlp-files/

cp -av /data/Incoming/windows/jogl/build-win64/jar/*natives* /srv/www/jogamp.org/deployment/archive/jau01/
cp -av /data/Incoming/windows/jogl/build-win32/jar/*natives* /srv/www/jogamp.org/deployment/archive/jau01/

rm /srv/www/jogamp.org/deployment/archive/jau01/*cdc.jar

export JOGAMP_DEPLOYMENT_NO_REPACK=1

sven/promote-to-webstart-local.sh
