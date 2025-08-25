#! /bin/sh

set -x

# mysqldump --max-allowed-packet=16M --user=root --password=PASSWORD --all-databases > $fname

mysql -u root --password=PASSWORD <<EOF

SHOW STATUS LIKE 'Connections';
-- SHOW STATUS LIKE 'perf%';
-- SHOW GLOBAL STATUS;
select @@datadir;
SHOW VARIABLES;

EOF

