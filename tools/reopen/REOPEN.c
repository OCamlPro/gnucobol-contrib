/*
   Copyright (C) 2022 Simon Sobisch

   This file is part of GnuCOBOL contribution "REOPEN".

   REOPEN is free software: you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License
   as published by the Free Software Foundation, either version 3 of the
   License, or (at your option) any later version.

   REOPEN is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with REOPEN.  If not, see <https://www.gnu.org/licenses/>.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libcob.h>	/* for COB_EXT_EXPORT */

static int process_reopen (FILE *stream, const char *file_namem);

/* CALL "REOPEN" USING Z'FILENAME' STERR-NAME
   names must be zero terminated; whe starting with '+' they are appended to,
   otherwise recreated.
   special names: "CLOSE" --> close stream, may end pipe and prevent normal output
                  for WIN32 (at least MinGW based):
                      "CONOUT$" to reopen to the process' console [handled by 
                  for non WIN32 you may append to a tty, too
*/
COB_EXT_EXPORT int REOPEN (const char* stdout_name, const char* stderr_name)
{
	if (process_reopen(stdout, stdout_name)) return 1;
	if (process_reopen(stderr, stderr_name)) return 2;
	return 0;
}

static int process_reopen (FILE *stream, const char *file_name)
{
	if (file_name && *file_name) {
		const char *mode;
		if (strcmp(file_name, "CLOSE") == 0) {
			return fclose (stream);
		}
		if (file_name[0] == '+') {
			file_name++;
			mode = "a";
		} else {
			mode = "w";
		}
		stream = freopen (file_name, mode, stream);
		if (stream == NULL) {
			/* should be catched by the caller as old stream is closed! */
			return 1;
		}
		return 0;
	} else {
		return fflush (stream);
	}
}

