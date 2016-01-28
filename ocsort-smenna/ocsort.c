/*
 *  Copyright (C) 2009 Cedric ISSALY
 *  Copyright (C) 2016 Sauro Menna
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

//#ifdef	_WIN32
#ifdef _MSC_VER
	#include <Windows.h>
#else
	#include <time.h>
#endif

#include "libocsort.h"
#include "ocsort.h"
#include "job.h"
#include "utils.h"

/* Module initialization indicator */
static unsigned int	initialized = 0;

/* Module structure pointer */
//
static cob_module	*module = NULL;
/* Global variable pointer */
cob_global		*cob_glob_ptr;
extern int yydebug;
void yyset_debug(int ndbg);

int main_prod(int argc, char **argv);
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
		if (strstr(argv[1], "--config") != NULL){
			OCSort_Config() ;
			return OC_RTC_OK;
		}
	}	
	if (argc < 2) {
		fprintf(stdout,"________________________________________________________________________\n");
		fprintf(stdout,"ocsort Version %s\n", OCSORT_VERSION); 
		fprintf(stdout,"Copyright (C) 2009-2016 Cedric ISSALY / Sauro Menna\n");
		fprintf(stdout,"________________________________________________________________________\n");
		fprintf(stdout,"ocsort. Nothing to do.\n");
		fprintf(stdout,"Usage: ocsort <command>\n");
		fprintf(stdout,"       Execute command\n");
		fprintf(stdout,"or   : ocsort TAKE <filename params>\n");
		fprintf(stdout,"       Read and execute command from filename params\n");
		fprintf(stdout,"or   : --help\n");
		fprintf(stdout,"       Print help\n");
		fprintf(stdout,"or   : --version\n");
		fprintf(stdout,"       Print version information\n");
		fprintf(stdout,"or   : --config\n");
		fprintf(stdout,"       Print values of environment variables\n");
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

int main_prod(int argc, char **argv) {

// debug	
//	SYSTEMTIME st;
	time_t timeStart;
	struct job_t *job;
	int nRC = -2;
	int nContinueSrtTmp=0;

	time (&timeStart);
	yydebug=0; // no debug  
	// yydebug=1; // yes debug
	
	//-->>
	yyset_debug(0);	// set debug scanner off
	// -->> yyset_debug(1);	// set debug scanner on

	cob_init(argc, argv);
	//
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
						nRC = job_loadFiles(job);
						if (job->nStatistics == 2) 
								util_print_time_elap("After  job_loadFiles     ");
						if (nRC == -2)
							nContinueSrtTmp = 1;
						if (nRC == -1)
							break;
						nRC = job_sort(job); 
						if (job->nStatistics == 2) 
								util_print_time_elap("After  job_sort          ");
						if (nRC == -1)
							break;
						if (job->bIsPresentSegmentation == 0)
							nRC = job_save_out(job);
						else
							nRC = job_save_tempfile(job);
						if (job->nStatistics == 2) 				
							util_print_time_elap("After  job_save          ");
					
						if (nRC == -1)
								break;
					} while (nContinueSrtTmp == 1);

					if (nRC >= 0) {
						job_save_tempfinal(job);
						if ((job->nStatistics == 2) &&  (job->bIsPresentSegmentation == 1))
							util_print_time_elap("After  job_save_tempfinal");
					}
				}
					else
						nRC = job_merge_files(job);
			
				if (nRC >= 0)				
					job_print_final(job, & timeStart);
				}
				else
				{
					printf("OCSort - TEST COMMAND LINE PARAMETERS \n");
				}
			}
		}
//-->>	
	job_destroy(job);
//-->>		
	job_destructor(job);

	cobtidy();

	if (nRC == 0)
		printf("Sort OK\n");
	else
	{
		printf("Sort ERROR\n");  
		nRC = OC_RTC_ERROR;
	}
	return nRC;
}


