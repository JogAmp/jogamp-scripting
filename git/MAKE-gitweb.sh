#
# git-1.7.3.2
#
# - To install gitweb to /src/www/git/ when git wrapper
#   is installed at /opt-linux-x86_64/bin/git and the repositories (projects)
#   we want to display are under /srv/scm, you can do
#
# Run this from the gitweb folder, which contains the gitweb source
#

gitinstall=/opt-linux-x86_64
wwwgitdir=/srv/www/jogamp.org/git
scmdir=/srv/scm

	make GITWEB_PROJECTROOT="$scmdir" \
	     GITWEB_JS="static/gitweb.js" \
	     GITWEB_CSS="static/gitweb.css" \
	     GITWEB_LOGO="static/git-logo.png" \
	     GITWEB_FAVICON="static/git-favicon.png" \
	     bindir=$gitinstall/bin \


    rm -rf $wwwgitdir/static
    cp -a  static $wwwgitdir
	cp -fv gitweb.{cgi,perl} gitweb_config.perl $wwwgitdir



