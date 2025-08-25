#! /bin/sh

fname="/data/backup/backup-mysqldb-jogamp-`date +%Y%m%d%H%M%S`.sql"
fname_bugs="/data/backup/backup-mysql.jogamp-bugs-`date +%Y%m%d%H%M%S`.sql"
fname_wiki="/data/backup/backup-mysql.jogamp-wiki-`date +%Y%m%d%H%M%S`.sql"

mysqldump --max-allowed-packet=16M --user=root --password=PASSWORD --all-databases > $fname
echo dumped to $fname

mysqldump --max-allowed-packet=16M -u root --password=PASSWORD bugs > $fname_bugs
echo dumped to $fname_bugs

mysqldump --max-allowed-packet=16M -u root --password=PASSWORD wikidb > $fname_wiki
echo dumped to $fname_wiki

