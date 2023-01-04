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
/* 
 Shared variables
*/ 
#include "gcsort.h"
#include "job.h"
#ifndef SHAREFILE_INCLUDED
	#define SHAREFILE_INCLUDED
	#ifdef  MAIN_FILE
		cob_module *module = NULL;
		char	szMexToken[260]; 
		char	cob_tmp_buff[COB_MEDIUM_BUFF];
		char	cob_tmp_temp[FILENAME_MAX+8];
		struct job_t* globalJob;
		int     g_retWarn;

	#else
		extern cob_module *module;
		extern char szMexToken[260];
		extern char	cob_tmp_buff[COB_MEDIUM_BUFF];
		extern char	cob_tmp_temp[FILENAME_MAX+8];
		extern struct job_t* globalJob;
		extern int  g_retWarn;

	#endif
#endif  /* SHAREFILE_INCLUDED   */
