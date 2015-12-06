/*
 *  Copyright (C) 2009 Cedric ISSALY 
 *  Copyright (C) 2015 Sauro Menna
 *
 *	This file is part of OCSort.
 *
 *  OCSort is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  OCSort is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with OCSort.  If not, see <http://www.gnu.org/licenses/>.

*/

#define NOMINMAX
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <math.h> 
#ifdef _MSC_VER
	#include <crtdbg.h>
#endif
#include <Windows.h>

//.-->> #define  COB_KEYWORD_INLINE inline
//-->> 
#include <libcob.h>

/* i64 ini
#include <libcob\byteswap.h>
#include <libcob\call.h>
#include <libcob\common.h>
#include <libcob\fileio.h>
#include <libcob\move.h>
#include <libcob\numeric.h>
#include <libcob\screenio.h>
#include <libcob\strings.h>
#include <libcob\termio.h>
#include <libcob\intrinsic.h>
#include <libcob\codegen.h>
*/

//-->> #include "oclib.h"
#include "ocsort.h"
#include "job.h"


/* Module initialization indicator */
static unsigned int	initialized = 0;

/* Module structure pointer */
static cob_module	*module = NULL;

/* Global variable pointer */
cob_global		*cob_glob_ptr;


extern int yydebug;
void yyset_debug(int ndbg);

int main_prod(int argc, char **argv);
int main_test(int argc, char **argv);

int main(int argc, char **argv) {

	int rtc = 0;

	if (argc >= 2)
	{
		if (strstr(argv[1], "--help") != NULL) {
			OCSort_Usage() ;
			return OC_RTC_OK;
		}
		if (strstr(argv[1], "--version") != NULL){
			OCSort_Version() ;
			return OC_RTC_OK;
		}
	}	
	if (argc < 2) {
		printf ("ocsort. Nothing to do.\n");
		printf ("Usage: ocsort <command>\n");
		printf ("       Execute command\n");
		printf ("or   : ocsort TAKE <filename params>\n");
		printf ("       Read and execute command from filename params\n");
		printf ("or   : --help\n");
		printf ("       Print help\n");
		printf ("or   : --version\n");
		printf ("       Print version information\n");
		return OC_RTC_ERROR;
	}

	rtc = main_prod(argc,argv);
//
//-->>		
#ifdef _DEBUG
	#ifdef _MSC_VER
		_CrtDumpMemoryLeaks();
	#endif
#endif
//
	return rtc;
}

int foo(int *pValue) 
{
    *pValue = 6;
	return 0;
}
int foo2(int *pValue)
{
    *pValue = 6;
	return 0;
}
 
int main_prod(int argc, char **argv) {

// debug	
	SYSTEMTIME st;

	struct job_t *job;
	int nRC = -2;
	int nContinueSrtTmp=0;

	time_t timeStart;
	time (&timeStart);

	// s.m. 	
	yydebug=0; // no debug  
	// yydebug=1; // yes debug
	
	//-->>
	yyset_debug(0);	// set debug scanner off
	// -->> yyset_debug(1);	// set debug scanner on

	cob_init(argc, argv);
	cob_module_enter(&module, &cob_glob_ptr, 0);

	nContinueSrtTmp = 0;
	job=job_constructor();
	if (job != NULL)
		nRC = job_load(job, argc, argv);
	else	
		nRC = -1;
	if (nRC == 0)
	{
	// check SORT FIELDS=COPY
	// in this case force MERGE 
		if ((job_GetTypeOp(job) == 'S') && (job_GetFieldCopy() == 1)){
				job_SetTypeOP('M');
				printf("Command MERGE force for SORT FIELDS=COPY\n");
		}
	//
		if (nRC >= 0)
			nRC = job_print(job);
		if (nRC >= 0)
			nRC = job_check(job);

		job_ReviewMemeAlloc(job);


		if (job_NormalOperations(job) == 0)   // 0 = Normal , 1 = Test command Line
		{
			// check typeOP  'S' for Sort e 'M' for Merge
			if (nRC >= 0)
			{
				if (job_GetTypeOp(job) == 'S')   
				{
					do {
						nContinueSrtTmp = 0;

	// debug
		if (job->nStatistics == 2) {
			GetLocalTime(&st);
			printf("Before job_loadFiles - %04d-%02d-%02d %02d:%02d:%02d:%03d\n" ,
				st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
		} 		
							

						nRC = job_loadFiles(job);

	// debug
		if (job->nStatistics == 2) {
 			GetLocalTime(&st);
 			printf("After  job_loadFiles - %04d-%02d-%02d %02d:%02d:%02d:%03d\n" ,
 				st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
		}

						if (nRC == -2)
							nContinueSrtTmp = 1;
						if (nRC == -1)
							break;

	// debug
		if (job->nStatistics == 2) {
 			GetLocalTime(&st);
 			printf("Before job_sort      - %04d-%02d-%02d %02d:%02d:%02d:%03d\n" ,
 				st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
		}

						nRC = job_sort(job); 

	// debug
		if (job->nStatistics == 2) {
	 		GetLocalTime(&st);
 			printf("After  job_sort      - %04d-%02d-%02d %02d:%02d:%02d:%03d\n" ,
	 			st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
		}

							if (nRC == -1)
								break;

	// debug
		if (job->nStatistics == 2) {
		 	GetLocalTime(&st);
		 	printf("Before job_save      - %04d-%02d-%02d %02d:%02d:%02d:%03d\n" ,
		 		st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
		}

						nRC = job_save(job);

	// debug
		if (job->nStatistics == 2) {
		 	GetLocalTime(&st);
		 	printf("After  job_save      - %04d-%02d-%02d %02d:%02d:%02d:%03d\n" ,
		 		st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
		}

						if (nRC == -1)
								break;
					} while (nContinueSrtTmp == 1);

				// in questo punto inserire la parte di SAVE con il supporto dei file temporanei
		if (job->nStatistics == 2) {
		 	GetLocalTime(&st);
			printf("Before job_save_final- %04d-%02d-%02d %02d:%02d:%02d:%03d\n" ,
				st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
		}
					if (nRC >= 0)
						job_save_final(job);
	// debug
		if (job->nStatistics == 2) {
		 	GetLocalTime(&st);
		 	printf("After  job_save_final- %04d-%02d-%02d %02d:%02d:%02d:%03d\n" ,
		 		st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
		}
				}
				else
				{
					nRC = job_merge_files(job);
				}
			}
			if (nRC >= 0)				
				job_print_final(job, & timeStart);
		}
		else
		{
			printf("OCSort - TEST COMMAND LINE PARAMETERS \n");
		}
	}
//-->>	
	job_destroy(job);
//-->>		
	job_destructor(job);


//-->>    cob_module_leave(module);
	// cob_terminate_routines();
	cob_tidy();

	if (nRC == 0)
		printf("Sort OK\n");
	else
	{
		printf("Sort ERROR\n");  
		nRC = OC_RTC_ERROR;
	}
	return nRC;
}


#define BUFFER_SIZE 4096
int main_test(int argc, char **argv) {
	FILE *f;
	char buffer[BUFFER_SIZE+1];
	char *fbuffer[2];
	struct job_t *job;
	int i=0;
	fbuffer[1]=buffer;

	if (argc!=2) {
		printf("parameter error\n");
		return 0;
	}

	if ((f=fopen(argv[1],"r"))==NULL) {
		perror("Cannot open file");
		return 0;
	}
	yydebug=0;
	while (fgets(buffer,BUFFER_SIZE, f)!=NULL) {

		job=job_constructor();
		printf("Trying line %d : '%s'\n",i++,buffer);
		if (job_load(job, 2, fbuffer)) {
			printf("Error on load\n");
		} else {
			job_print(job);
		}
		if (job_check(job)) {
			printf("Error on check\n");
		}
	}
	fclose(f);
	return 0;
}
