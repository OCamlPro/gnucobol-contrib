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
#ifndef EXT_EXPORT    /* define from outside if you don't want to
                         include libcob.h and/or possibly don't want
                         to link against libcob */
	#include <libcob.h>
	#ifdef COB_EXT_EXPORT	/* GC3+ */
		#define EXT_EXPORT COB_EXT_EXPORT
	#else
		#define EXT_EXPORT extern
	#endif
#endif

static int process_reopen (FILE *stream, const char *file_namem);

/* Example use with a zero-terminated literal and a variable:
   CALL "REOPEN" USING Z'FILENAME' STERR-NAME

   If no name is passed, then the stream is flushed.

   Names must be zero terminated
   If the name starts with '+' the file is opened for append,
   otherwise (re-)created.

   When compiled and linked with GnuCOBOL 3+ the filename is additional
   extended like COB_TRACE_FILE is (see its documentation or
   runtime.cfg for details)
   special meaning in the name parameters:
      "CLOSE" --> close stream, may end pipe and prevent normal output
   for WIN32 (at least MinGW based) only:
      "CONOUT$" to reopen to the process' console [handled by 
   for non WIN32 you may append to a tty, too
*/
EXT_EXPORT int REOPEN (const char* stdout_name, const char* stderr_name)
{
	if (process_reopen(stdout, stdout_name)) return 1;
	if (process_reopen(stderr, stderr_name)) return 2;
	return 0;
}

static int process_reopen (FILE *stream, const char *file_name)
{
	int ret;
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
#ifdef COB_EXT_IMPORT
		file_name = cob_expand_env_string ((char *)file_name);
#endif
		stream = freopen (file_name, mode, stream);
		if (stream == NULL) {
			/* should be catched by the caller as old stream is closed! */
			ret = 1;
		}
		ret = 0;
#ifdef COB_EXT_IMPORT
		cob_free ((void *)file_name);
#endif
	} else {
		ret = fflush (stream);
	}
	return ret;
}
