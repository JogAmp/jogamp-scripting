#! /bin/sh

fname="/data/backup/backup-mysqldb-`date +%Y%m%d%H%M%S`.sql"
mysqldump --verbose --user=root --password --all-databases > $fname
echo dumped to $fname

# 1076  mysql --user=root --password < bugzilla_db_clean.sql 

