#! /bin/sh

set -x

mysqladmin -u bugs --password=PASSWORD drop bugs
mysqladmin -u bugs --password=PASSWORD create bugs
# mysql --max-allowed-packet=16M --user=bugs --password=PASSWORD bugs < backup-mysql.jogamp-bugs-20250824134719.last.sql
mysql --max-allowed-packet=16M --user=bugs --password=PASSWORD bugs < backup-mysql.bugs-20250824134719.upgrading.v2.sql


