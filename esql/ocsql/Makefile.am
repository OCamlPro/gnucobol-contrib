#
# Makefile gnu-cobol-sql/ocsql
#
#
# Copyright (C) 2006-2015 Sergey Kashyrin <ska@kiska.net>
#               2012 enhanced by Doug Vogel <dv11674@gmail.com>
#               2013 fixes and enhancements by Atilla Akarsular <030ati@gmail.com>
#
# This runtime library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.
# 

lib_LTLIBRARIES = libocsql.la
libocsql_la_SOURCES = ocsql2.cpp

libocsql_la_CFLAGS = $(AM_CFLAGS) -I$(top_srcdir)
libocsql_la_LDFLAGS = -version-info 2:0:0 -no-undefined
