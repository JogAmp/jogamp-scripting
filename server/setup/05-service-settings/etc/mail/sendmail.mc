divert(-1)dnl
#-----------------------------------------------------------------------------
# $Sendmail: debproto.mc,v 8.14.4 2013-02-11 11:12:33 cowboy Exp $
#
# Copyright (c) 1998-2010 Richard Nelson.  All Rights Reserved.
#
# cf/debian/sendmail.mc.  Generated from sendmail.mc.in by configure.
#
# sendmail.mc prototype config file for building Sendmail 8.14.4
#
# Note: the .in file supports 8.7.6 - 9.0.0, but the generated
#	file is customized to the version noted above.
#
# This file is used to configure Sendmail for use with Debian systems.
#
# If you modify this file, you will have to regenerate /etc/mail/sendmail.cf
# by running this file through the m4 preprocessor via one of the following:
#	* make   (or make -C /etc/mail)
#	* sendmailconfig 
#	* m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf
# The first two options are preferred as they will also update other files
# that depend upon the contents of this file.
#
# The best documentation for this .mc file is:
# /usr/share/doc/sendmail-doc/cf.README.gz
#
#-----------------------------------------------------------------------------
divert(0)dnl
#
#   Copyright (c) 1998-2005 Richard Nelson.  All Rights Reserved.
#
#  This file is used to configure Sendmail for use with Debian systems.
#
define(`_USE_ETC_MAIL_')dnl
include(`/usr/share/sendmail/cf/m4/cf.m4')dnl
VERSIONID(`$Id: sendmail.mc, v 8.14.4-4 2013-02-11 11:12:33 cowboy Exp $')
OSTYPE(`debian')dnl
DOMAIN(`debian-mta')dnl
dnl # Items controlled by /etc/mail/sendmail.conf - DO NOT TOUCH HERE
undefine(`confHOST_STATUS_DIRECTORY')dnl        #DAEMON_HOSTSTATS=
dnl # Items controlled by /etc/mail/sendmail.conf - DO NOT TOUCH HERE
dnl #

dnl # default logging level is 9, you might want to set it higher to
dnl # debug the configuration
dnl #
dnl define(`confLOG_LEVEL', `9')dnl
dnl define(`confLOG_LEVEL', `22')dnl
dnl #

dnl #
dnl # Uncomment and edit the following line if your outgoing mail needs to
dnl # be sent out through an external mail server:
dnl #
dnl define(`SMART_HOST', `smtp.your.provider')dnl
dnl define(`SMART_HOST',	`smtp:mail.jogamp.org')dnl
dnl define(`RELAY_MAILER_ARGS', `TCP $h 26')dnl
dnl #
define(`confDEF_USER_ID', ``8:12'')dnl
dnl define(`confAUTO_REBUILD')dnl
define(`confTO_CONNECT', `1m')dnl
define(`confTO_COMMAND', `2m')dnl
define(`confTRY_NULL_MX_LIST', `True')dnl
define(`confDONT_PROBE_INTERFACES', `True')dnl
define(`UUCP_MAILER_MAX', `2000000')dnl
define(`confUSERDB_SPEC', `/etc/mail/userdb.db')dnl
dnl #
define(`ALIAS_FILE', `/etc/aliases')dnl
define(`STATUS_FILE', `/var/log/mail/statistics')dnl

dnl # General defines
dnl #
dnl # SAFE_FILE_ENV: [undefined] If set, sendmail will do a chroot()
dnl #	into this directory before writing files.
dnl #	If *all* your user accounts are under /home then use that
dnl #	instead - it will prevent any writes outside of /home !
dnl #   define(`confSAFE_FILE_ENV',             `')dnl
dnl #
dnl # Daemon options - restrict to servicing LOCALHOST ONLY !!!
dnl # Remove `, Addr=' clauses to receive from any interface
dnl # If you want to support IPv6, switch the commented/uncommentd lines
dnl #

FEATURE(`no_default_msa')dnl

DAEMON_OPTIONS(`Family=inet6, Name=MTA-v6, Port=smtp, Addr=::1')dnl
DAEMON_OPTIONS(`Family=inet6, Name=MTA-v6, Port=smtp, Addr=2a01:4f8:192:1164::2')dnl
DAEMON_OPTIONS(`Family=inet,  Name=MTA-v4, Port=smtp, Addr=127.0.0.1')dnl
DAEMON_OPTIONS(`Family=inet,  Name=MTA-v4, Port=smtp, Addr=144.76.84.101')dnl

DAEMON_OPTIONS(`Family=inet6, Name=MSP-v6, Port=submission, M=Ea, Addr=::1')dnl
DAEMON_OPTIONS(`Family=inet,  Name=MSP-v4, Port=submission, M=Ea, Addr=127.0.0.1')dnl

DAEMON_OPTIONS(`Family=inet6, Name=TLSMTA-v6, Port=smtps, M=Eas, Addr=::1')dnl
DAEMON_OPTIONS(`Family=inet6, Name=TLSMTA-v6, Port=smtps, M=Eas, Addr=2a01:4f8:192:1164::2')dnl
DAEMON_OPTIONS(`Family=inet,  Name=TLSMTA-v4, Port=smtps, M=Eas, Addr=127.0.0.1')dnl
DAEMON_OPTIONS(`Family=inet,  Name=TLSMTA-v4, Port=smtps, M=Eas, Addr=144.76.84.101')dnl

dnl #
dnl # Be somewhat anal in what we allow
define(`confPRIVACY_FLAGS',dnl
`needmailhelo,needexpnhelo,needvrfyhelo,restrictqrun,restrictexpand,nobodyreturn,authwarnings')dnl
dnl # define(`confPRIVACY_FLAGS', `authwarnings,needmailhelo,novrfy,noexpn,noetrn,noverb,restrictqrun')dnl

include(`/etc/mail/tls/starttls.m4')dnl

dnl define(`confAUTH_OPTIONS', `A')dnl
dnl #
dnl # The following allows relaying if the user authenticates, and disallows
dnl # plaintext authentication (PLAIN/LOGIN) on non-TLS links
dnl #
dnl define(`confAUTH_OPTIONS', `A p')dnl
define(`confAUTH_OPTIONS', `Apy')dnl
dnl # 
dnl # PLAIN is the preferred plaintext authentication method and used by
dnl # Mozilla Mail and Evolution, though Outlook Express and other MUAs do
dnl # use LOGIN. Other mechanisms should be used if the connection is not
dnl # guaranteed secure.
dnl # Please remember that saslauthd needs to be running for AUTH. 
dnl #
dnl TRUST_AUTH_MECH(`EXTERNAL DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl
dnl define(`confAUTH_MECHANISMS', `EXTERNAL GSSAPI DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl
TRUST_AUTH_MECH(`GSSAPI DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl
define(`confAUTH_MECHANISMS', `GSSAPI LOGIN PLAIN')dnl

dnl #
dnl # Rudimentary information on creating certificates for sendmail TLS:
dnl #     cd /usr/share/ssl/certs; make sendmail.pem
dnl # Complete usage:
dnl #     make -C /usr/share/ssl/certs usage
dnl #
define(`confCACERT_PATH', `/etc/ssl/certs')dnl
define(`confDH_PARAMETERS',`/etc/ssl/local/dhparams-4096.pem')dnl
dnl define(`confCACERT', `/etc/ssl/local/ca-my.crt')dnl
dnl define(`confCRL', `/etc/ssl/local/ca-my.crl')dnl
dnl define(`confSERVER_CERT', `/etc/pki/tls/certs/sendmail.pem')dnl
dnl define(`confSERVER_KEY', `/etc/pki/tls/certs/sendmail.pem')dnl
dnl define(`confCACERT', `/etc/ssl/local/thawte-ca-cert5-20181102.pem')dnl
define(`confCACERT', `/etc/ssl/local/jogamp2025a.org.ca.pem')dnl
define(`confSERVER_CERT', `/etc/ssl/local/jogamp2025a.org.crt.pem')dnl
define(`confSERVER_KEY', `/etc/ssl/local/jogamp2025a.org.key.mail.pem')dnl
define(`confCLIENT_CERT', `/etc/ssl/local/jogamp2025a.org.crt.pem')dnl
define(`confCLIENT_KEY', `/etc/ssl/local/jogamp2025a.org.key.mail.pem')dnl
dnl #
dnl define(`confTO_QUEUEWARN', `4h')dnl
dnl define(`confTO_QUEUERETURN', `5d')dnl
dnl define(`confQUEUE_LA', `12')dnl
dnl define(`confREFUSE_LA', `18')dnl
define(`confQUEUE_LA', `12')dnl
define(`confREFUSE_LA', `18')dnl
define(`confTO_IDENT', `0')dnl

dnl #
dnl # Define connection throttling and window length
define(`confCONNECTION_RATE_THROTTLE', `15')dnl
define(`confCONNECTION_RATE_WINDOW_SIZE',`10m')dnl
dnl #
dnl # Features
dnl #

dnl FEATURE(`mailertable', `hash -o /etc/mail/mailertable.db')dnl
FEATURE(`virtusertable', `hash -o /etc/mail/virtusertable.db')dnl
FEATURE(redirect)dnl
FEATURE(always_add_domain)dnl
dnl # Masquerading options
MASQUERADE_AS(`jogamp.org')dnl
dnl FEATURE(`allmasquerade')dnl
FEATURE(`masquerade_envelope')dnl
FEATURE(`masquerade_entire_domain')dnl

dnl # use /etc/mail/local-host-names
FEATURE(`use_cw_file')dnl
dnl
dnl # use /etc/mail/trusted-users
dnl
FEATURE(use_ct_file)dnl
dnl #

# define(`PROCMAIL_MAILER_PATH', `/usr/bin/procmail')dnl
# FEATURE(local_procmail, `', `/usr/bin/procmail -t -Y -a $h -d $u')dnl
dnl #
dnl # dovecot
dnl #
dnl FEATURE(local_procmail, `/usr/lib/dovecot/dovecot-lda', `/usr/lib/dovecot/dovecot-lda -d $u')dnl
dnl MODIFY_MAILER_FLAGS(`LOCAL', `-f')dnl
 
INPUT_MAIL_FILTER(`opendkim', `S=inet:8891@localhost')

dnl #
dnl # The access db is the basis for most of sendmail's checking
dnl # FEATURE(`access_db', , `skip')dnl
FEATURE(`access_db', `hash -T<TMPF> -o /etc/mail/access.db')dnl
dnl #
dnl # The greet_pause feature stops some automail bots - but check the
dnl # provided access db for details on excluding localhosts...
dnl # configured in file: access
dnl FEATURE(`greet_pause', `1000')dnl 1 seconds
FEATURE(`blacklist_recipients')dnl
dnl #
dnl # Delay_checks allows sender<->recipient checking
FEATURE(`delay_checks', `friend', `n')dnl
dnl #
dnl # If we get too many bad recipients, slow things down...
define(`confBAD_RCPT_THROTTLE',`3')dnl
dnl #
dnl # Stop connections that overflow our concurrent and time connection rates
FEATURE(`conncontrol', `nodelay', `terminate')dnl
FEATURE(`ratecontrol', `nodelay', `terminate')dnl
dnl #
dnl # If you're on a dialup link, you should enable this - so sendmail
dnl # will not bring up the link (it will queue mail for later)
dnl define(`confCON_EXPENSIVE',`True')dnl
dnl #
dnl # Dialup/LAN connection overrides
dnl #
include(`/etc/mail/m4/dialup.m4')dnl
include(`/etc/mail/m4/provider.m4')dnl
dnl #
dnl # The following example makes mail from this host and any additional
dnl # specified domains appear to be sent from mydomain.com
dnl #
dnl # Default Mailer setup
MAILER_DEFINITIONS
MAILER(`local')dnl
MAILER(`smtp')dnl
MAILER(`procmail')dnl

dnl define(`FAX_MAILER_PATH',`/usr/bin/faxmail')dnl
dnl define(`FAX_MAILER_ARGS',`faxmail -d -n -t done -R -s a4 -p 12pt $u@$h $f')dnl
dnl define(`FAX_MAILER_MAX',`100000000')dnl
dnl MAILER(`fax')dnl
