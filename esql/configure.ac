#                                                       -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
#
# Copyright (C) 2006-2013 Sergey Kashyrin <ska@kiska.net>
#                    2017 Simon Sobisch <simonsobisch@gnu.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this software; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA 02111-1307 USA
#

AC_PREREQ(2.68)

AC_INIT([ESQL for GnuCOBOL],
	[2.0],
	[gnucobol-users@gnu.org],
	[gnu-cobol-sql],
	[http://www.kiska.net/opencobol/esql]) 
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_TESTDIR([tests])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([build_aux])

AC_CONFIG_FILES([Makefile esqlOC/Makefile ocsql/Makefile])
AM_CONDITIONAL([DISABLE_ESQL],  [test "$enable_esql" = no])
AM_CONDITIONAL([DISABLE_OCSQL], [test "$enable_ocsql" = no])

# Note for SUN Solaris (gcc)
# export/setenv CFLAGS "-m64 -mptr64"
# export/setenv LDFLAGS "-m64 -mptr64 -L/usr/local/lib/sparcv9"
# ./configure --libdir=/usr/local/lib/sparcv9
#
# Hack for AIX 64 bit (gcc)
# Required -
# export/setenv CFLAGS=-maix64
# export/setenv LDFLAGS=-maix64

if echo $CFLAGS | grep 'aix64' 1>/dev/null 2>&1
then
	if test -f /usr/ccs/bin/ar
	then
		AR="/usr/ccs/bin/ar -X64"
	else
		AR="ar -X64"
	fi
	NM="/usr/ccs/bin/nm -X64 -B"
fi

AM_INIT_AUTOMAKE([gnu no-texinfo.tex])
AM_MAINTAINER_MODE

# Autoheader templates
AH_TEMPLATE([MSSQL], [Database is Microsoft SQL Server])
AH_TEMPLATE([ESQL_DB2], [Database is DB2])
AH_TEMPLATE([USE_NOT_USED], [Use multiple schemas/databases (default)])
AH_TEMPLATE([EXTERNAL_LOG], [Use external log functions])
AH_TEMPLATE([_DEBUG], [Turn on debugging mode])
AH_TEMPLATE([LOGLEVEL], [Debugging log level])

# Basic capability tests

AC_PROG_CXX([xlc++_r xlc++ CC aCC c++ g++])
AC_USE_SYSTEM_EXTENSIONS

LT_INIT([dlopen win32-dll])
AC_ARG_ENABLE(esql,
  [AS_HELP_STRING([--disable-esql], 	[do not build ESQL preparser])])

AC_ARG_ENABLE(ocsql,
  [AS_HELP_STRING([--disable-ocsql],	[do not build ESQL library])])

AC_ARG_WITH(mssql,
  [AS_HELP_STRING([--with-mssql],	[database is Microsoft SQL Server])])

AC_ARG_WITH(db2,
  [AS_HELP_STRING([--with-db2],		[database is DB2])])

if test "$enable_ocsql" = no; then
    if "$enable_esql" = no; then
		AC_MSG_ERROR([[At least one of ESQL / OCSQL must be active]])
	fi
	if test "$with_mssql" = yes -o "$with_db2" = yes; then
		AC_MSG_WARN([[MSSQL or DB2 specified but deactivated through --disable-ocsql]])
		with_mssql=no; with_db2=no
	fi
else
	if test "$with_mssql" = yes; then
		if test "$with_db2" = yes; then
			AC_MSG_ERROR([[Both MSSQL and DB2 can not be defined]])
		fi
		AC_CHECK_HEADERS([msodbcsql.h], [],
			AC_MSG_ERROR([msodbcsql.h is required for MSSQL]))
		AC_DEFINE(MSSQL)
	fi
	if test "$with_db2" = yes; then
		AC_CHECK_HEADERS([sqlcli1.h], [],
			AC_MSG_ERROR([sqlcli1.h is required for DB2]))
		AC_DEFINE(ESQL_DB2)
	fi
fi
	
if test "$with_db2" != yes -a "$enable_ocsql" != no; then
# Checks for unixODBC.
	AC_CHECK_HEADERS([sqlext.h], [], AC_MSG_ERROR([sqlext.h (unixODBC) is required for ocsql]), [])

	AC_CHECK_LIB([odbc], [SQLConnect],
		[],
		AC_MSG_ERROR([unixODBC is required for ESQL library]), [])
fi

USE_MULTI=yes
AC_ARG_WITH(multidb,
  [  --with-multidb          Use multiple schemas/databases (default)],
  [ if test "$with_multidb" = no; then
	USE_MULTI=no
	AC_DEFINE(USE_NOT_USED)
	fi ])

AC_ARG_WITH(external-log,
  [  --with-external-log     Use external log functions],
  [ if test "$with_external_log" = yes; then
	AC_DEFINE(EXTERNAL_LOG)
	fi ])

USE_DEBUG=no
AC_ARG_WITH(debug,
  [  --with-debug            Turn on debugging mode with level (default 999)],
  [case $with_debug in
	yes)		AC_DEFINE(_DEBUG)
				USE_DEBUG="999"
				;;
	no)
				;;
	[[0-9]]*)	AC_DEFINE(_DEBUG)
				AC_DEFINE_UNQUOTED([LOGLEVEL], [$with_debug])
				USE_DEBUG="$with_debug"
				;;
	*)			AC_MSG_ERROR([[You must use a numeric level value]])
				;;
  esac])

# Checks for programs.
AC_DEFUN([AC_PROG_F77], [])
with_tags=
AC_PROG_LN_S
AC_PROG_INSTALL
AC_PROG_MAKE_SET

# Checks for header files.
AC_CHECK_HEADERS([unistd.h string.h strings.h])

# Checks
AC_C_BIGENDIAN

# Checks for library functions.
AC_CHECK_FUNCS([strupr])

# Special stuff

AH_VERBATIM([_XOPEN_SOURCE_EXTENDED],
[/* Define to 1 if on HPUX.  */
#ifndef _XOPEN_SOURCE_EXTENDED
# undef _XOPEN_SOURCE_EXTENDED
#endif])dnl 

case $host_os in
  hpux*)
	if test "$CXX" != "g++"
	then
		AC_DEFINE([_XOPEN_SOURCE_EXTENDED], [1])
		rm -f hptest*
		echo 'int main(int ac, char **av) { return 0; }' > hptest.cpp
		${CXX} ${CXXFLAGS} +Olit=all -o hptest hptest.cpp > hptest.out 2>&1
		if test $? -ne 0 -o -s hptest.out; then
			CXXFLAGS="$CXXFLAGS +ESlit +O2"
			COB_CFLAGS="$COB_CFLAGS +ESlit -w"
		else
			CXXFLAGS="$CXXFLAGS +Olit=all +O2"
			COB_CFLAGS="$COB_CFLAGS +Olit=all -w"
		fi
	fi
	;;
  aix*)
	if test "$CXX" != "g++"
	then
		CXXFLAGS="$CXXFLAGS -O2 -Q -qro -qroconst"
	fi
	;;
esac

if test "`basename $CXX`" = "g++"
then
	CXXFLAGS="$CXXFLAGS -fsigned-char -Wall -Wwrite-strings -Wmissing-prototypes -Wno-format-y2k"
fi

AC_OUTPUT

echo ""
echo "GnuCOBOL ESQL Configuration:"
echo " CXX               ${CXX}"
echo " CXXFLAGS          ${CXXFLAGS}"
echo " LDFLAGS           ${LDFLAGS}"
if test "$with_mssql" = yes; then
  echo " Use Microsoft SQL Server         YES"
else
  echo " Use Microsoft SQL Server         NO"
fi
if test "$USE_MULTI" = yes; then
  echo " Use multiple schemas/databases   YES"
else
  echo " Use multiple schemas/databases   NO"
fi
if test "$with_external_log" = yes; then
  echo " Use external log functions       YES"
else
  echo " Use external log functions       NO"
fi
if test "$USE_DEBUG" != no; then
  echo " Use Debug Mode                   YES, Level ${USE_DEBUG}"
else
  echo " Use Debug Mode                   NO"
fi
echo ""
if test "$enable_ocsql" = no; then
  echo " ESQL library                     DISABLED"
  echo "";
fi
if test "$enable_esql" = no; then
  echo " ESQL preparser                   DISABLED"
  echo "";
fi
