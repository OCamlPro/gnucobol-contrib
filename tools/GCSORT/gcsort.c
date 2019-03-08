/*
    Copyright (C) 2016-2019 Sauro Menna
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

#include "libgcsort.h"
#include "gcsort.h"
#include "job.h"
#include "utils.h"
#include "file.h"


/* Module initialization indicator */
static unsigned int	initialized = 0;

/* Module structure pointer */
//
static cob_module	*module = NULL;
/* Global variable pointer */
cob_global		*cob_glob_ptr;
/* Call parameters */
cob_field		*cob_procedure_params[1];
/* Module path */
static const char		*cob_module_path = NULL;
/* Perform frame stack */
struct cob_frame	*frame_overflow;
struct cob_frame	*frame_ptr;
struct cob_frame	frame_stack[255];


extern int yydebug;
void yyset_debug(int ndbg);

int main_prod(int argc, char **argv);
int main(int argc, char **argv) 
{

	int rtc = 0;
	if (argc >= 2)
	{
		if (strstr(argv[1], "--help") != NULL) {
			GCSORT_Usage() ;
			return OC_RTC_OK;
		}
		if (strstr(argv[1], "--version") != NULL){
			GCSORT_Version() ;
			return OC_RTC_OK;
		}
		if (strstr(argv[1], "--config") != NULL){
			GCSORT_Config() ;
			return OC_RTC_OK;
		}
	}	
	if (argc < 2) {
		fprintf(stdout,"________________________________________________________________________\n");
		fprintf(stdout,"gcsort Version %s\n", GCSORT_VERSION); 
		fprintf(stdout,"Copyright (C) 2009-2019 Cedric ISSALY / Sauro Menna\n");
		fprintf(stdout,"________________________________________________________________________\n");
		fprintf(stdout,"gcsort. Nothing to do.\n");
		fprintf(stdout,"Usage: gcsort <command>\n");
		fprintf(stdout,"              Execute command\n");
		fprintf(stdout,"or   : gcsort TAKE <filename params>\n");
		fprintf(stdout,"              Read and execute command from filename params\n");
		fprintf(stdout,"or   : gcsort --help\n");
		fprintf(stdout,"              Print help\n");
		fprintf(stdout,"or   : gcsort --version\n");
		fprintf(stdout,"              Print version information\n");
		fprintf(stdout,"or   : gcsort --config\n");
		fprintf(stdout,"              Print values of environment variables\n");
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

	time_t timeStart;
	struct job_t *job; 
	int nRC = -2;
	time (&timeStart);
	yydebug=0; // no debug  // yydebug=1; // yes debug
	yyset_debug(0);	// set debug scanner off

	cob_init(argc, argv);
	cob_module_enter(&module, &cob_glob_ptr, 0);
	module->cob_procedure_params = cob_procedure_params;
	/* Set frame stack pointer */
	frame_ptr = frame_stack;
	frame_ptr->perform_through = 0;
	frame_overflow = frame_ptr + 255 - 1;
	cob_module_path = cob_glob_ptr->cob_main_argv0;
//-->>
/* Initialize module structure */
	module->module_name = "gcsort";
	module->module_formatted_date = NULL;     // COB_MODULE_FORMATTED_DATE;
	module->module_source = NULL;             // COB_SOURCE_FILE;
	module->module_entry.funcptr = NULL;      // (void *(*)())ioixpafix;
	module->module_cancel.funcptr = NULL;     // (void *(*)())ioixpafix_;
	module->collating_sequence = NULL;
	module->crt_status = NULL;
	module->cursor_pos = NULL;
	module->module_ref_count = NULL;
	module->module_path = &cob_module_path;
	module->module_active = 0;
	module->module_date = 0;                  //COB_MODULE_DATE;
	module->module_time = 0;                  //COB_MODULE_TIME;
	module->module_type = 0;
	module->module_param_cnt = 0;
	module->module_returning = 0;
	module->ebcdic_sign = 0;
	module->decimal_point = '.';
	module->currency_symbol = '$';
	module->numeric_separator = ',';
	module->flag_filename_mapping = 1;
	module->flag_binary_truncate = 0;
	module->flag_pretty_display = 0;
	module->flag_host_sign = 0;
	module->flag_no_phys_canc = 1;
	module->flag_main = 1;
	module->flag_fold_call = 0;
	module->flag_exit_program = 0;

	/* Initialize cancel callback */
	cob_set_cancel (module);
	/* Increment module active */
	module->module_active++;
	/* Save number of call params */
	module->module_num_params = cob_glob_ptr->cob_call_params;
	job=job_constructor();
	if (job != NULL)
	   	nRC = job_load(job, argc, argv);
	else	
    		nRC = -1;
    if (nRC == 0){
	// check SORT FIELDS=COPY
	// in this case force MERGE 
		if ((job_GetTypeOp(job) == 'S') && (job_GetFieldCopy() == 1)){
				job_SetTypeOP('M');
				printf("Forced command MERGE for SORT FIELDS=COPY\n");
		}
	//
		if (nRC >= 0) 	
			nRC = job_print(job);
		if (nRC >= 0) {
			nRC = job_check(job);
		}
		if (nRC >= 0)	
			job_ReviewMemeAlloc(job);
		if ((nRC >= 0) && (job_NormalOperations(job) == 1))   // 0 = Normal , 1 = Test command Line
				printf("GCSORT - TEST COMMAND LINE PARAMETERS \n");
		if ((nRC >= 0) && (job_NormalOperations(job) == 0)) {  // 0 = Normal , 1 = Test command Line
				// check typeOP  'S' for Sort e 'M' for Merge
				if (job_GetTypeOp(job) == 'M') 		
					nRC = job_merge_files(job);
				if (job_GetTypeOp(job) == 'S') 		
					nRC = job_sort(job);				
				if (nRC >= 0)	
					job_print_final(job, & timeStart);
		}
	}

	if (nRC == 0) {
        if (job_GetTypeOp(job) == 'M') 		
		    printf("GCSORT - Merge OK\n");
        else
		    printf("GCSORT - Sort OK\n");
    }
	else
	{
        if (job_GetTypeOp(job) == 'M') 		
		    printf("GCSORT - Merge ERROR\n");  
        else
		    printf("GCSORT - Sort ERROR\n");  
		nRC = OC_RTC_ERROR;
	}

//-->>	
	job_destroy(job);
//-->>		
    job_destructor(job);
    if (module->module_active) {
  	    module->module_active--;
    }
  /* Pop module stack */
    cob_module_leave (module);
    // new
	return nRC;
}


