@echo off
rem listings-sed=c.cmd gnucobol/tests
rem
rem Copyright (C) 2016-2017 Free Software Foundation, Inc.
rem Written by Sergey Kashyrin
rem
rem This file is part of GnuCOBOL.
rem
rem The GnuCOBOL compiler is free software: you can redistribute it
rem and/or modify it under the terms of the GNU General Public License
rem as published by the Free Software Foundation, either version 3 of the
rem License, or (at your option) any later version.
rem
rem GnuCOBOL is distributed in the hope that it will be useful,
rem but WITHOUT ANY WARRANTY; without even the implied warranty of
rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
rem GNU General Public License for more details.
rem
rem You should have received a copy of the GNU General Public License
rem along with GnuCOBOL.  If not, see <http://www.gnu.org/licenses/>.

rem Necessary sed replacements for unifying a listing

rem Note: We cater for a maximum version string of 14:
rem       Mayor (2) '.' Minor (2) '.' Patchlevel (8 - as some people place a date here)
rem Note: We replace the date two times, as not all systems have %e modifier in C
rem       and use %E in this case ("Mon Feb 04" instead of "Mon Feb  4").

if "%3" == "once" (
	sed -f %testpath%\1c.sed < %1 > %2
) else (
	sed -f %testpath%\2c.sed < %1 > %2
)
