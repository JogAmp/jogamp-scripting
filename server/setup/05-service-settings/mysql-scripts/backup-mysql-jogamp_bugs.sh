#! /bin/sh

fname_bugs="/data/backup/backup-mysql.jogamp-bugs-`date +%Y%m%d%H%M%S`.sql"

mysqldump --max-allowed-packet=16M -u root --password=PASSPWORD bugs > $fname_bugs
echo dumped to $fname_bugs

