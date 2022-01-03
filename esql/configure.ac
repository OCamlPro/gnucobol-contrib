dnl                                                       -*- Autoconf -*-
dnl Process this file with autoconf to produce a configure script.
dnl
dnl Copyright (C) 2015      Sergey Kashyrin <ska@kiska.net>
dnl               2017,2022 Simon Sobisch <simonsobisch@gnu.org>
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2, or (at your option)
dnl any later version.
dnl 
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl 
dnl You should have received a copy of the GNU General Public License
dnl along with this software; see the file COPYING.  If not, write to
dnl the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
dnl Boston, MA 02111-1307 USA
dnl

AC_PREREQ(2.68)

AC_INIT([ESQL for GnuCOBOL],
	[3.0],
	[gnucobol-users@gnu.org],
	[gnucobol-sql],
	[http://www.kiska.net/opencobol/esql]) 
AC_REVISION([GnuCOBOL ESQL snapshot $Revision: 988 $])
AC_COPYRIGHT([This file is part of ESQL for GnuCOBOL.

Copyright (C) 2015           Sergey Kashyrin <ska@kiska.net>
              2017,2021-2022 Simon Sobisch <simonsobisch@gnu.org>
])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_TESTDIR([tests])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([build_aux])

AC_CONFIG_FILES([Makefile esqlOC/Makefile ocsql/Makefile])
AM_CONDITIONAL([DISABLE_ESQL],  [test "$enable_esql" = no])
AM_CONDITIONAL([DISABLE_OCSQL], [test "$enable_ocsql" = no])

# Note for SUN Solaris (gcc)
#  option to configure/export/setenv: CXX="g++ -m64 --libdir=/usr/local/lib/sparcv9"
# or:
#  option to configure/export/setenv: CXXFLAGS=-m64 and LDFLAGS="-m64 -L/usr/local/lib/sparcv9"
#
# Hack for AIX 64 bit (gcc)
# Required -
#  option to configure/export/setenv: CXX=g++ -maix64
# or:
#  option to configure/export/setenv: CXXFLAGS=-maix64 and LDFLAGS=-maix64
# Note: AIX commonly uses -Lpath like GNU/Linux would use -Lpath -Rpath

if echo "$CXX$CXXFLAGS" | grep 'aix64' 1>/dev/null 2>&1; then
	if test -f /usr/ccs/bin/ar; then
		AR="/usr/ccs/bin/ar -X64"
	else
		AR="ar -X64"
	fi
	NM="/usr/ccs/bin/nm -X64 -B"
fi

dnl We don't want to have the full list of automatic defines from automake,
dnl and take care of the one we want explicit AC_DEFINE_UNQUOTED.
AM_INIT_AUTOMAKE([gnu no-texinfo.tex no-define])
AC_DEFINE_UNQUOTED([PACKAGE], ["$PACKAGE"], [Name of package])  # used in .rc-files
AM_MAINTAINER_MODE

# Autoheader templates
AH_TEMPLATE([MSSQL], [Database is Microsoft SQL Server])
AH_TEMPLATE([ESQL_DB2], [Database is DB2])
AH_TEMPLATE([USE_NOT_USED], [Use multiple schemas/databases (default)])
AH_TEMPLATE([EXTERNAL_LOG], [Use external log functions])
AH_TEMPLATE([NO_LOG], [Disable debug log])
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
	yes)		USE_DEBUG="999"
				;;
	no)			AC_DEFINE(NO_LOG)
				
				;;
	[[0-9]]*)	AC_DEFINE_UNQUOTED([LOGLEVEL], [$with_debug])
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
