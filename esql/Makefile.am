#
# Makefile gnu-cobol-sql
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

include_HEADERS =
if ! DISABLE_ESQL
  ESQLDIR = esqlOC
endif
if ! DISABLE_OCSQL
  OCSQLDIR = ocsql
endif
SUBDIRS = $(ESQLDIR) $(OCSQLDIR)
#DIST_SUBDIRS = esqlOC ocsql
ACLOCAL_AMFLAGS = -I m4 --install

BUILT_SOURCES =
DISTCLEANFILES = $(BUILT_SOURCES)
EXTRA_DIST =
