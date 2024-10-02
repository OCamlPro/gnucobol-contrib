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

#ifndef GCTHREAD_H_INCLUDED
#define GCTHREAD_H_INCLUDED

#include <stdint.h>
#define MAX_THREAD 16


#if _MSC_VER>=1200
#include <windows.h>
#include <process.h>
#elif __GNUC__>3 || (__GNUC__==3 && __GNUC_MINOR__>3)
#include <pthread.h>
#include <unistd.h>
#include <string.h>
#endif


#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
#define _THREAD_WIN_ENV_
#else
#define _THREAD_LINUX_ENV
#endif

struct sortField_t;

struct pParam {
    struct job_t* thJob;
    int nRet;
};


#ifdef  _THREAD_WIN_ENV_
unsigned __stdcall gcthread_run(void* pArguments);
#else
void* gcthread_run(void* pArguments);
#endif

int gcthread_start(int argc, char** argv, int nMaxThread, time_t* timeStart);
struct job_t* gcthread_CreateJob(int argc, char** argv, int* nRC);
int gcthreadSkipStop(struct job_t* job);
int gcthread_save_final(struct job_t* jobArray[]);
int gcthread_print_final(struct job_t* jobArray[], time_t* timeStart);
void gcthread_ReviewMemAlloc(struct job_t* job);
INLINE int gcthread_ReadFileMem(struct job_t* job, int* nLR, unsigned char* szBuffRek);

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	INLINE  int  gcthread_GetKeys(struct job_t* job, unsigned char* szBufferIn, unsigned char* szKeyOut);
#else
 	INLINE  int  gcthread_GetKeys(struct job_t* job, unsigned char* szBufferIn, unsigned char* szKeyOut);
#endif

#endif /* GCTHREAD_H_INCLUDED   */
