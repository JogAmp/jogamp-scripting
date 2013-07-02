#!/bin/bash

PERL=/usr/bin/perl

AWSTATS_HOME=/home/jogamp_web/awstats
AWSTATS_CONFIG=$AWSTATS_HOME/config
AWSTATS_LOGS=$AWSTATS_HOME/log
AWSTATS_INSTALL=$AWSTATS_HOME/installation
AWSTATS_PL=$AWSTATS_INSTALL/wwwroot/cgi-bin/awstats.pl
AWSTATS_TOOLS=$AWSTATS_INSTALL/tools

OUT_DIR=/srv/www/jogamp.org/log/stats

function doit() {

$PERL $AWSTATS_TOOLS/awstats_updateall.pl now -awstatsprog=$AWSTATS_PL -configdir=$AWSTATS_CONFIG

#Recover history !
#$PERL $AWSTATS_TOOLS/awstats_buildstaticpages.pl -awstatsprog=$AWSTATS_PL -configdir=$AWSTATS_CONFIG -config=jogamp.org -dir=$OUT_DIR -builddate=2010 -year=2010 -month=all
#$PERL $AWSTATS_TOOLS/awstats_buildstaticpages.pl -awstatsprog=$AWSTATS_PL -configdir=$AWSTATS_CONFIG -config=jogamp.org -dir=$OUT_DIR -builddate=2011 -year=2011 -month=all
#$PERL $AWSTATS_TOOLS/awstats_buildstaticpages.pl -awstatsprog=$AWSTATS_PL -configdir=$AWSTATS_CONFIG -config=jogamp.org -dir=$OUT_DIR -builddate=2012 -year=2012 -month=all
#$PERL $AWSTATS_TOOLS/awstats_buildstaticpages.pl -awstatsprog=$AWSTATS_PL -configdir=$AWSTATS_CONFIG -config=jogamp.org -dir=$OUT_DIR -builddate=201301 -year=2013 -month=01
#$PERL $AWSTATS_TOOLS/awstats_buildstaticpages.pl -awstatsprog=$AWSTATS_PL -configdir=$AWSTATS_CONFIG -config=jogamp.org -dir=$OUT_DIR -builddate=201302 -year=2013 -month=02
#$PERL $AWSTATS_TOOLS/awstats_buildstaticpages.pl -awstatsprog=$AWSTATS_PL -configdir=$AWSTATS_CONFIG -config=jogamp.org -dir=$OUT_DIR -builddate=201303 -year=2013 -month=03
#$PERL $AWSTATS_TOOLS/awstats_buildstaticpages.pl -awstatsprog=$AWSTATS_PL -configdir=$AWSTATS_CONFIG -config=jogamp.org -dir=$OUT_DIR -builddate=201304 -year=2013 -month=04
#$PERL $AWSTATS_TOOLS/awstats_buildstaticpages.pl -awstatsprog=$AWSTATS_PL -configdir=$AWSTATS_CONFIG -config=jogamp.org -dir=$OUT_DIR -builddate=201305 -year=2013 -month=05
#$PERL $AWSTATS_TOOLS/awstats_buildstaticpages.pl -awstatsprog=$AWSTATS_PL -configdir=$AWSTATS_CONFIG -config=jogamp.org -dir=$OUT_DIR -builddate=201306 -year=2013 -month=06

$PERL $AWSTATS_TOOLS/awstats_buildstaticpages.pl -awstatsprog=$AWSTATS_PL -configdir=$AWSTATS_CONFIG -config=jogamp.org -dir=$OUT_DIR -builddate=%YYYY -month=all
$PERL $AWSTATS_TOOLS/awstats_buildstaticpages.pl -awstatsprog=$AWSTATS_PL -configdir=$AWSTATS_CONFIG -config=jogamp.org -dir=$OUT_DIR -builddate=%YYYY%MM

cd $OUT_DIR

for i in awstats*html ; do
    if [ -f "$i" ] ; then
        mv $i `echo $i | sed 's/awstats\.//g'`
    fi
done

for i in *html ; do
    sed -i 's/awstats\.jogamp\.org\.2010/jogamp.org.2010/g' $i
done

}

doit 2>&1 | tee -a /var/lib/awstats/daily.log

exit 0
