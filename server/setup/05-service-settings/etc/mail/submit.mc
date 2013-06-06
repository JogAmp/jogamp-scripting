divert(-1)dnl
#-----------------------------------------------------------------------------
# $Sendmail: submit.mc,v 8.14.4 2013-02-11 11:12:33 cowboy Exp $
#
# Copyright (c) 2000-2010 Richard Nelson.  All Rights Reserved.
#
# cf/debian/submit.mc.  Generated from submit.mc.in by configure.
#
# submit.mc prototype config file for building Sendmail 8.14.4
#
# Note: the .in file supports 8.7.6 - 9.0.0, but the generated
#	file is customized to the version noted above.
#
# This file is used to configure Sendmail for use with Debian systems.
#
# If you modify this file, you will have to regenerate /etc/mail/submit.cf
# by running this file through the m4 preprocessor via one of the following:
#	* make  (or make -C /etc/mail)
#	* sendmailconfig
#	* m4 /etc/mail/submit.mc > /etc/mail/submit.cf
# The first two options are preferred as they will also update other files
# that depend upon the contents of this file.
#
# The best documentation for this .mc file is:
# /usr/share/doc/sendmail-doc/cf.README.gz
#
#-----------------------------------------------------------------------------
divert(0)dnl
#
#   Copyright (c) 2000-2002 Richard Nelson.  All Rights Reserved.
#
#  This file is used to configure Sendmail for use with Debian systems.
#
define(`_USE_ETC_MAIL_')dnl
include(`/usr/share/sendmail/cf/m4/cf.m4')dnl
VERSIONID(`$Id: submit.mc, v 8.14.4-4 2013-02-11 11:12:33 cowboy Exp $')
OSTYPE(`debian')dnl
DOMAIN(`debian-msp')dnl
dnl #
dnl #---------------------------------------------------------------------
dnl # Masquerading information, if needed, should go here
dnl # You likely will not need this, as the MTA will do it
dnl #---------------------------------------------------------------------
dnl MASQUERADE_AS()dnl
dnl FEATURE(`masquerade_envelope')dnl
dnl #
FEATURE(`use_ct_file')dnl
dnl #---------------------------------------------------------------------
dnl # The real reason we're here: the FEATURE(msp)
dnl # NOTE WELL:  MSA (587) should have M=Ea, so we need to use stock 25
dnl #---------------------------------------------------------------------
FEATURE(`msp', `[127.0.0.1]', `25')dnl
dnl #
dnl #---------------------------------------------------------------------
dnl # Some minor cleanup from FEATURE(msp)
dnl #---------------------------------------------------------------------
dnl #
dnl #---------------------------------------------------------------------
