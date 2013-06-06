All template files are .. underneath in ./etc

Debian 7.00 (Wheezy)

01 stop all running services ..
    /etc/init.d/apache2 stop
    /etc/init.d/sendmail stop
    /etc/init.d/dovecot stop
    /etc/init.d/mysql stop
    /etc/init.d/saslauthd stop

01 logging
    - firewall logging:
      /etc/rsyslog.conf: firewall rules, kern.debug / kern.=!debug
      /etc/init.d/rsyslog restart

    - logrotate
      /etc/logrotate.conf: compress, 48 weeks
      /etc/logrotate.d/rsyslog: Add /var/log/firewall and /var/log/dovecot.log
      
03 move all users
    - mv /data/backup/home/* /home/
    - for all groups: groupadd -g GID groupname
    - for all users:  useradd -M -N -u UID -g GID username
    - for all users:  usermod -a -G GID1,GID2,.. username
    - cd /data/backup/var/spool/mail ; (check names, remove unused ..) ; mv * /var/spool/mail/

04 move other stuff
    - Old Logs
        - mv /data/backup/var/log /var/log/old_logs

    - MySQL
        - old server: backup DB
          - run backup-mysql.sh on old server, result is e.g. backup-mysqldb-20130605162509.sql
          - !!! strip all system-DB's (schema's) from the backup,
            i.e. all which are not created for applications, e.g.: 
            - mysql
            - users
            - test
            - t_*

        - new server: import DB
          - get backup backup-mysqldb-20130605162509.sql
          - /etc/init.d/mysql start
          - backup-1: backup-mysql.sh
          - mysql --user=root --password  < backup-mysqldb-20130605162509.sql
          - backup-2: backup-mysql.sh
          - mysqlcheck --user=root --password --all-databases

        - if things go wrong: re-install mysql
          dpkg -P mysql-server mysql-server-5.5 mysql-server-core-5.5
          rm -rf /var/lib/mysql/*
          apt-get install mysql-server mysql-server-5.5 mysql-server-core-5.5

    - Services
        - mv /data/backup/srv/* /srv/

05 config procmail
    copy /etc/procmailrc

06 bogofilter
    copy /etc/bogofilter.cf
    Init empty wordlist.db:
        touch nope
        cat nope  | bogoutil -l /var/spool/bogofilter/wordlist.db
        rm nope

07 sasl2
    /etc/sasl2/Sendmail.conf
    /etc/default/saslauthd: start=yes
    /etc/init.d/saslauthd start

08 dovecot 2.1.7-7
    - features:
      - requires ssl
      - ipv4 / ipv6
      - smtps
      - pop3s
      - sieve (tls)

    - Sync config files in /etc/dovecot/
      with etc/dovecot/dovecot.conf.diff and etc/dovecot/conf.d.diff

    - mkdir -p /var/lib/dovecot/sieve/global/
    - chmod ugo+rx /var/lib/dovecot
    - copy /var/lib/dovecot/sieve/global/default.sieve
        - cd /var/lib/dovecot/sieve/global ; sievec default.sieve
    - copy /var/lib/dovecot/sieve/prologue.sieve
        - cd /var/lib/dovecot/sieve ; sievec prologue.sieve

    - migrate old INBOX:
        for each user:
          dsync mirror mbox:~/mail:INBOX=/var/mail/USERNAME
          su dstrohlein -c "dsync mirror mbox:~/mail:INBOX=/var/mail/dstrohlein ; echo OK"

    - /etc/init.d/dovecot start


09 sendmail 8.14.4-4
    - features:
      - requires ssl for auth
      - ipv4 / ipv6

    - /etc/mail
    - Sync config files in /etc/mail with: etc/mail/mail.diff
        - sendmail.mc
        - submit.mc
        - access
        - local-host-names
        - virtusertable

    - /etc
        - aliases

    - cd /etc/mail
        - make

    /etc/init.d/sendmail start
    
10 GIT
    xinetd for git
        apt-get install xinetd
        cp /etc/xinetd.d/git
        /etc/init.d/xinetd restart

    gitweb
        We use deployed gitweb now, and simply deploy gitweb.conf
        - ln -s /usr/share/gitweb DocumentRoot/git
        - cp srv/scm/gitweb.conf

11 apache2
    - php
        apt-get install php5-pgsql php5-ldap php5-imap php5-odbc php5-dev php5-common php5 php5-mysql php5-gd php5-xmlrpc \
                        php5-xsl php5-cli php5-intl php5-pspell php5-snmp php5-sasl

    - misc for perl/bugzilla
        - Perl: redo init (find closest mirror ..)
            - perl -MCPAN -e shell
                - o conf init
        - Packages
            - apt-get install libgd-gd2-perl libgd-graph-perl libgd-tools libgdal-perl libgdal-dev libgdata-dev libgd2-xpm-dev

    - Sync config files in /etc/apache2/ with: etc/apache2/apache2.diff
        - see also etc/apache2/mods-enabled.lst, etc ..

    /etc/init.d/apache2 start

12 jabot
    As user jabot:
        cd /srv/jabot ; git clone file:///srv/scm/users/sgothel/jabot.git
        cd jabot ; ant

    As user root:
        cp -a /srv/jabot/jabot/scripts/jabot-init-debian /etc/init.d/jabot
        update-rc.d jabot defaults

13 jenkins
    ..
