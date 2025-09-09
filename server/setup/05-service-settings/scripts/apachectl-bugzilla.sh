#!/bin/sh

export APACHE_CONFDIR=/etc/apache2-bugzilla
export APACHE_STATUSURL=http://127.0.0.1:8081/server-status
export APACHE_ENVVARS=${APACHE_CONFDIR}/envvars
export APACHE_PID_FILE=/var/run/apache2-bugzilla.pid
/usr/sbin/apachectl $*
