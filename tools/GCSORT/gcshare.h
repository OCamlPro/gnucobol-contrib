/*
	Copyright (C) 2016-2024 Sauro Menna
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
		char	cob_tmp_temp[COB_MEDIUM_BUFF];
		struct job_t* globalJob = NULL;
		int     g_retWarn = 0;
		#if __LIBCOB_RELEASE >= 30200
			enum cb_colseq g_cb_colseq = CB_COLSEQ_NATIVE;
		#endif
		static int gCreateMutex = 0;
		#if defined(_THREAD_LINUX_ENV)
			static pthread_mutex_t job_thread_mutex = PTHREAD_MUTEX_INITIALIZER;
		#else
			static HANDLE ghMutexJob;
		#endif 
	#else
		extern cob_module *module;
		extern char szMexToken[260];
		extern char	cob_tmp_buff[COB_MEDIUM_BUFF];
		extern char	cob_tmp_temp[COB_MEDIUM_BUFF];
		extern struct job_t* globalJob;
		extern int  g_retWarn;
		#if __LIBCOB_RELEASE >= 30200
			extern enum cb_colseq g_cb_colseq;
		#endif
		extern int gCreateMutex;
#if defined(_THREAD_LINUX_ENV)
		extern pthread_mutex_t job_thread_mutex;
#else
		extern HANDLE ghMutexJob;
#endif 


	#endif
#endif  /* SHAREFILE_INCLUDED   */
