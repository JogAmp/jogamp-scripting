#! /bin/sh

set -x

mysqladmin -u wikiuser --password=PASSWORD drop wikidb
mysqladmin -u wikiuser --password=PASSWORD create wikidb
mysql --max-allowed-packet=16M --user=wikiuser --password=PASSWORD wikidb < backup-mysql.wiki-20250824134719.sql
