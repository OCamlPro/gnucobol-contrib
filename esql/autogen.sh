#!/bin/sh
# autogen.sh gnucobol-sql
# Note:  call as ./autogen.sh if you don't have readlink -f
#
# Copyright (C) 2017-2022 Free Software Foundation, Inc.
# Written by Simon Sobisch
#
# This file is part of ESQL for GnuCOBOL, originally distributed
# as build_aux/bootstrip with GnuCOBOL.
#
# The ESQL for GnuCOBOL is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# You should have received a copy of the GNU General Public License
# along with ESQL for GnuCOBOL.  If not, see <https://www.gnu.org/licenses/>.

me=autogen.sh

echo "start to bootstrap ESQL for GnuCOBOL"
if test "$0" = "./$me"; then
  MAINPATH=.
else
  MAINPATH=$(dirname $(readlink -f "$0"))
fi
if test ! -f $MAINPATH/$me; then
  echo; echo "ERROR - cannot set main directory [checked $MAINPATH/$me] - aborting $me" && exit 1
fi

echo; echo "ensure that we have executable scripts..."
scripts="compile config.guess config.sub depcomp install-sh ltmain.sh missing mkinstalldirs"
for file in $scripts ; do
  if test -f $MAINPATH/build_aux/$file; then
    chmod -f u+x $MAINPATH/build_aux/$file
  else
    echo "WARNING, file $MAINPATH/build-aux/$file is missing."
  fi
done

scripts="autogen.sh create_win_dist.sh"
for file in $scripts ; do
  if test -f $MAINPATH/$file; then
    chmod -f u+x $MAINPATH/$file
  else
    if test ! $file = "create_win_dist.sh"; then
      echo "WARNING, file $MAINPATH/$file is missing."
    fi
  fi
done

echo; echo "running autoreconf..."
ret=0

# changing build_aux scripts at large:
#autoreconf --verbose --force --install --include=m4 $MAINPATH; ret=$?

# changing files possibly needed for new systems:
#config_file_url="https://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=blob_plain;f=build-aux"
#for file in config.guess config.sub; do
#  echo "$0: getting $file..."
#  wget -q --timeout=5 -O $MAINPATH/build_aux/$file.tmp "${config_file_url}/${file};hb=HEAD" \
#    && mv $MAINPATH/build_aux/$file.tmp $MAINPATH/build_aux/$file \
#    && chmod a+x $MAINPATH/build_aux/$file
#  retval=$?
#  rm -f $MAINPATH/build_aux/$file.tmp
#  test $retval -eq 0 # || exit $retval
#done

# ensure the configure and Makefile parts are up-to-date:
autoreconf --verbose --force --include=m4 $MAINPATH; ret=$?

if test $ret -ne 0; then
  echo; echo "ERROR, autoreconf returned $ret - aborting bootstrap" && exit $ret
fi

echo; echo "bootstrap is finished"
echo; echo "now run configure with your desired options, for instance:"
echo "  ./configure CFLAGS='-g'  # in $MAINPATH"
echo "or, especially preferred for development:"
echo "  mkdir build && cd build \ "
echo "  && $MAINPATH/configure --enable-maintainer-mode"
