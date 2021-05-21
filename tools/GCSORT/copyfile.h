/*
    Copyright (C) 2016-2020 Sauro Menna
    Copyright (C) 2009 Cedric ISSALY
 *
 *	This file is part of GCSORT.
 *
 *  GCSORT is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  GCSORT is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with GCSORT.  If not, see <http://www.gnu.org/licenses/>.

*/

#ifndef COPYFILE_H_INCLUDED
#define COPYFILE_H_INCLUDED


#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <errno.h>
// linux 

//#ifndef _WIN32

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	#include <io.h>
	#define _strtoll    _strtoi64
#else
	#include <limits.h>
	#include <sys/io.h>
	#include <time.h>
	#include <fcntl.h>
	#define _strtoll   strtoll
#endif


#include "utils.h"
#include "mmfioc.h"

#define MAX_FILES_INPUT 16	// Number of max files in input for merge and temporary files

// future use #define EM_MFSORT 1	// Emulate MFSORT

struct file_t;
struct sortField_t;
struct condField_t;
struct outrec_t;
struct inrec_t;
struct SumField_t;
struct mmfio_t;

struct job_t;


int job_copy (struct job_t* job);
int job_copyFile(struct job_t *job); 


#endif // COPYFILE_H_INCLUDED
