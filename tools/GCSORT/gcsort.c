/*
    Copyright (C) 2016-2026 Sauro Menna
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
	#define _CRTDBG_MAP_ALLOC
	#include <crtdbg.h>
#endif

/* #ifdef	_WIN32  */
#ifdef _MSC_VER
	#include <Windows.h>
#else
	#include <time.h>
#endif

#include<signal.h> 
#include "libgcs/libgcs.h"
#include "gcsort.h"
#include "job.h"
#include "utils.h"
#include "file.h"
#include "gcshare.h"
#include "exitroutines.h"
#include "copyfile.h"
#include "datediff.h"
#include "join.h"
#include "gcthread.h"

#if __LIBCOB_RELEASE >= 30200
static char		ebcdic_table[1024] = "default";
#endif

#if __LIBCOB_RELEASE >= 30200
 const cob_u8_t* get_collation(enum cb_colseq colseq);
#else
#define get_collation(cs) NULL
#endif /* __LIBCOB_RELEASE >= 30200 */

/* Module initialization indicator */
static unsigned int	initialized = 0;

/* Global variable pointer */
cob_global*		cob_glob_ptr;

/* Call parameters */
//cob_field*		cob_procedure_params[1];
/* Module path */
static const char		*cob_module_path = NULL;
/* Perform frame stack */
static struct cob_frame	*frame_overflow;
static struct cob_frame	*frame_ptr;
static struct cob_frame	frame_stack[255];

/* Macro di fallback se non definite dall'ambiente */
#ifndef COB_MODULE_FORMATTED_DATE
#define COB_MODULE_FORMATTED_DATE "2026-09-10"
#endif
#ifndef COB_SOURCE_FILE
#define COB_SOURCE_FILE "gcsort.c"
#endif
#ifndef COB_MODULE_DATE
#define COB_MODULE_DATE "20260910"
#endif
#ifndef COB_MODULE_TIME
#define COB_MODULE_TIME "114000"
#endif


/* MultiThread */
int gcMultiThreadIsFirst = 0;
int gcMultiThread = 0;	
int gcMaxThread = 0;	


int g_nMaxlogicalcpucount = 1;

extern int yydebug;
void yyset_debug(int ndbg);

int main_prod(int argc, char **argv);

#ifdef GCSORT_EXE
int main(int argc, char **argv) 
{
	int rtc = 0;
	g_retWarn = 0;


	/* flush stdout immediately */
	setvbuf(stdout, NULL, _IONBF, 0);

	/* Get system info */
	/* Set num of thread default */
	g_nMaxlogicalcpucount = utl_GetCpuCount();

	/* fprintf(stdout, " Max logical cpu count=%d\n", g_nMaxlogicalcpucount); */

	/* new data type
	unsigned char szBOut[45];
	unsigned char pBOut;
	memset(szBOut, 0x00, 45);
	unsigned char szData[45] = { "A12B)34" };
	unsigned char* pData = szData;
	int nFieldLen = 7;
	int nUS = 0;
	util_UFFSFF(pData, nFieldLen, nUS);
	*/

#if defined(GCSORT_NEWFEATURES) 

	int in1 = 20210520;
	int in2 = 20200522;
	int sRes = 0;
	int retCode = 0;
	int sDays = 0;
	retCode = gcDateDiff(in1, in2, &sRes);
	retCode = gcDateDiff(in2, in1, &sRes);
	in1 = 20210520;
	retCode = gcDate2Ord(in1, &sRes);
	in1 = sRes;
	gcOrd2Date(in1, &sRes);

	in1 = 20210120;
	retCode = gcDate2Ord(in1, &sRes);

	in1 = sRes;
	gcOrd2Date(in1, &sRes);

	in1 = 20210520;
	sRes = 0;
	gcDateAddMonths(in1, &sRes, -3);

	in1 = 20210520;
	sRes = 0;
	gcDateAddMonths(in1, &sRes, -27);

	in1 = 20210820;
	sRes = 0;
	gcDateAddYears(in1, &sRes, -5);

	in1 = 20210820;
	sRes = 0;
	gcDateAddYears(in1, &sRes, +15);

 
	/* aggiunge giorni alla data    */
	in1 = 20210520;
	sDays = 1;
	retCode = gcDateAddDays(in1, &in2, sDays);
	sDays = 30;
	retCode = gcDateAddDays(in1, &in2, sDays);
	sDays = -21;
	retCode = gcDateAddDays(in1, &in2, sDays);

#endif	/* GCSORT_NEWFEATURES 	*/

	/*
	 check date - End
	*/

	if (argc >= 2)  
	{
		if (strstr(argv[1], "--help") != NULL) {
			GCSORT_Usage(argv[2]) ;
			return GC_RTC_OK;
		}
		if (strstr(argv[1], "--version") != NULL){
			GCSORT_Version() ;
			return GC_RTC_OK;
		}
		if (strstr(argv[1], "--config") != NULL){
			GCSORT_Config() ;
			return GC_RTC_OK;
		}
       	/* -fsign=<ASCII/EBCDIC> : Specify display sign */
		verify_options(argc, argv);
     }

	if (argc < 2) {
		fprintf(stdout,"________________________________________________________________________\n");
		fprintf(stdout,"gcsort Version %s\n", GCSORT_VERSION); 
		fprintf(stdout, "Copyright (C) 2016-2026 Sauro Menna\n");
		fprintf(stdout, "                   2009 Cedric ISSALY\n");
		fprintf(stdout,"________________________________________________________________________\n");
		fprintf(stdout,"gcsort. Nothing to do.\n");
		fprintf(stdout,"Usage: gcsort <option> <command>\n");
		fprintf(stdout,"              Execute command\n");
		fprintf(stdout,"or   : gcsort TAKE <filename params>\n");
		fprintf(stdout,"              Read and execute command from filename params\n");
		fprintf(stdout,"or   : gcsort --help\n");
		fprintf(stdout,"              Print help\n");
		fprintf(stdout, "or   : gcsort --help  SORT | MERGE | COPY | JOIN \n");
		fprintf(stdout, "              Print help for specific control statement\n");
		fprintf(stdout,"or   : gcsort --version\n");
		fprintf(stdout,"              Print version information\n");
		fprintf(stdout,"or   : gcsort --config\n");
		fprintf(stdout,"              Print values of environment variables\n");
		return GC_RTC_ERROR;
	}
	rtc = main_prod(argc,argv);
#ifdef _DEBUG
	#ifdef _MSC_VER
		_CrtDumpMemoryLeaks();
	#endif
#endif 
	if (rtc == 0)
		rtc = rtc + g_retWarn;	/* verify warning   */
  	return rtc;
}
#endif


int main_prod(int argc, char **argv) {	 
	time_t timeStart;
	struct job_t *job;
	int nRC = -2;
	char szMex[10];
	time (&timeStart);

	yydebug = 0;            /* 0;   // no debug  // yydebug=1; // yes debug    */
	yyset_debug(0);         /* 0);	// set debug scanner off                   */
	 
	GCSORT_Init();

	/* s.m. 20240302 */
	/* MultiThread */
	if (gcMultiThread == 0) {
		job = job_constructor();
		if (job != NULL)
 			nRC = job_load(job, argc, argv);
		else
			nRC = -1;
		if (nRC == 0) {
			/* check SORT FIELDS=COPY in this case force MERGE */
			/*
			if ((job_GetTypeOp(job) == 'S') && (job_GetFieldCopy() == 1)){
					job_SetTypeOP('M');
					printf("Forced command MERGE for SORT FIELDS=COPY\n");
			}
			*/
			if (job_GetFieldCopy() == 1)
				job_SetTypeOP('C');		/* Copy */
			if (nRC >= 0)
				nRC = job_print(job);
			if (nRC >= 0) {
				nRC = job_check(job);
			}
			if (nRC >= 0) {
				job_ReviewMemAlloc(job);
				job_AllocateField(job);
			}
			if ((nRC >= 0) && (job_NormalOperations(job) == 1))         /* 0 = Normal , 1 = Test command Line   */
				printf("GCSORT - TEST COMMAND LINE PARAMETERS \n");
			if ((nRC >= 0) && (job_NormalOperations(job) == 0)) {       /* 0 = Normal , 1 = Test command Line   */
					/* check typeOP  'S' for Sort , 'M' for Merge and 'C' for Copy  */
				switch (job_GetTypeOp(job)) {
				case ('C'):
					sprintf(szMex, "Copy");
					nRC = job_copy(job);
					break;
				case ('M'):
					sprintf(szMex, "Merge");
					nRC = job_merge_files(job);
					break;
				case ('S'):
					sprintf(szMex, "Sort");
						nRC = job_sort(job);
					break;
				case ('J'):
					sprintf(szMex, "Join");
					nRC = job_joiner(job);
					break;
				}
				if (nRC >= 0)
					job_print_final(job, &timeStart);
			}
		}

		if (nRC == 0) {
			if (globalJob->nStatistics != 5) 
				fprintf(stdout, "GCSORT - %s OK\n\n", szMex);
		}
		else {
			if (globalJob->nStatistics != 5)
				fprintf(stdout, "GCSORT - %s KO\n\n", szMex);
			nRC = GC_RTC_ERROR;
		}

		/* new from Chuck */
		 //cob_tidy();

		job_destroy(job);
		job_destructor(job);
		if (module->module_active) {
			module->module_active--;
		}
		//cob_module_free(&module);

		cob_tidy();

	}
	else
	{
		sprintf(szMex, "Sort");
		/* s.m. 20240302 */
		nRC = gcthread_start(argc, argv, gcMaxThread, &timeStart);
		if (nRC == 0) {
			fprintf(stdout, "GCSORT - %s OK\n\n", szMex);
		}
		else {
			fprintf(stdout, "GCSORT - %s KO\n\n", szMex);
			nRC = GC_RTC_ERROR;
		}
	}
	return nRC;
}

/* Get global point job structure */
void* gcs_get_job(void)
{
	return globalJob;
}

// ============================================================================
// FUNCTION: GCSORT_Init
// ============================================================================

int GCSORT_Init(void)
{
	char szMex[10];
	
	cob_init(0, NULL);
	cob_module_enter(&module, &cob_glob_ptr, 0);
	
	cob_glob_ptr->cob_call_params = 0;
	cob_glob_ptr->cob_stmt_exception = 0;
	
	memset(szMex, 0x00, 10);

	/* Set frame stack pointer */
	frame_ptr = frame_stack;
	frame_ptr->perform_through = 0;

	frame_overflow = frame_ptr + 255 - 1;
	cob_module_path = cob_glob_ptr->cob_main_argv0;

/* CORREZIONE: Assegnazione diretta senza allocazione Heap dinamica */
	module->module_name = "gcsort";
	module->module_formatted_date = COB_MODULE_FORMATTED_DATE;
	module->module_source = COB_SOURCE_FILE;

	module->module_entry.funcptr = NULL;
	module->module_cancel.funcptr = NULL;
	module->module_ref_count = NULL;
	module->module_path = &cob_module_path;
	module->module_active = 0;
	module->module_date = COB_MODULE_DATE;
	module->module_time = COB_MODULE_TIME;
	module->module_type = 0;
	module->module_param_cnt = 0;

	module->ebcdic_sign = g_cb_ebcdic_sign;
	module->collating_sequence = get_collation(g_cb_colseq);
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

#if defined (__LIBCOB_VERSION)
	module->flag_debug_trace = 0;
	module->flag_dump_ready = 0;
	module->module_stmt = 0;
	module->module_sources = NULL;
#if __LIBCOB_RELEASE >= 30200
	module->gc_version = COB_PACKAGE_VERSION;
	module->xml_mode = 1;
#endif
#endif

	module->crt_status = NULL;
	module->cursor_pos = NULL;
	module->module_returning = 0;

	/* Initialize cancel callback */
	cob_set_cancel(module);

	/* Increment module active */
	module->module_active++;

	/* Save number of call params */
	module->module_num_params = cob_glob_ptr->cob_call_params;

	return 0;
}

// ============================================================================
// FUNCTION: GCSORT_Cleanup (Rilascio speculare e pulizia anti-leak)
// ============================================================================
int GCSORT_Cleanup(int nSource)
{
	if (nSource == 0)
		return 0;

	if (module != NULL) {
		if (module->module_active > 0) {
			module->module_active--;
		}

		/* CORREZIONE: Resetta il puntatore logico senza invocare free() */
		module->module_name = NULL;
	
	 #if defined (__LIBCOB_VERSION)


		if (module->module_sources != NULL) {
			free((void*)module->module_sources);
			module->module_sources = NULL;

		}
	 #endif
	}
	
	  /* Decrement module active count */
 	if (module->module_active) {
 		module->module_active--;
 	}
 
 	/* Pop module stack */
 	cob_module_free(&module);
 	cob_module_leave(module);
 
 	 cob_tidy();


	return 0;
}

void verify_options(int numargs, char** args)
{
	char* pch;
	char szOpt[1024];
	char cBufNum[10];
	int bcommandjoin = 0;
	szOpt[sizeof(szOpt) - 1] = '\0';
	for (int i = 1; i < numargs; ++i) {
		strncpy(szOpt, args[i], sizeof(szOpt) - 1);
		pch = strtok(szOpt, "=");
		if (pch != NULL) {
			if (!strcasecmp(pch, "-fsign")) {
				pch = strtok(NULL, "=");
				if (pch != NULL) {
					if (!strcasecmp(pch, "EBCDIC"))
						g_cb_ebcdic_sign = 1;
					else
						if (!strcasecmp(pch, "ASCII"))
							g_cb_ebcdic_sign = 0;
						else {
							fprintf(stdout, "*GCSORT* ERROR: Problem with option -fsign, correct values are ASCII/EBCDIC\n");
							exit(GC_RTC_ERROR);
						}
				}
				else
				{
					fprintf(stdout, "*GCSORT* ERROR: invalid parameter in command line with option -fsign\n");
					exit(GC_RTC_ERROR);
				}

			}
#if __LIBCOB_RELEASE >= 30200
			if (pch == NULL) {
				fprintf(stdout, "*GCSORT* ERROR: invalid parameter in command line\n");
				exit(GC_RTC_ERROR);
			}
			if (!strcasecmp(pch, "-fcolseq")) {
				/* s.m. 20230207 pch = strtok(NULL, " ="); */
				/*  s.m. 20230207 */
				pch = strtok(NULL, "=");
				if (pch != NULL) {
					if (!strcasecmp(pch, "NATIVE"))
						g_cb_colseq = CB_COLSEQ_NATIVE;
					else
						if (!strcasecmp(pch, "ASCII"))
							g_cb_colseq = CB_COLSEQ_ASCII;
						else
							if (!strcasecmp(pch, "EBCDIC"))
								g_cb_colseq = CB_COLSEQ_EBCDIC;
							else {
								fprintf(stdout, "*GCSORT* ERROR: Problem with option -fcolseq, correct values are ASCII/EBCDIC/NATIVE\n");
								exit(GC_RTC_ERROR);
							}
				}
				else
				{
					fprintf(stdout, "*GCSORT* ERROR: invalid parameter in command line with option -fcolseq\n");
					exit(GC_RTC_ERROR);
				}
			}

			if (!strcasecmp(pch, "-febcdic-table")) {
				/* s.m. 20230207 pch = strtok(NULL, " ="); */
				/* s.m. 20230207 */
				pch = strtok(NULL, "=");
				if (pch != NULL) {
					strncpy(ebcdic_table, pch, sizeof(ebcdic_table) - 1);
				}
				else {
					fprintf(stdout, "*GCSORT* ERROR: invalid parameter in command line with option -febcdic-table\n");
					exit(GC_RTC_ERROR);
				}

			}
#endif /* __LIBCOB_RELEASE >= 30200 */
			/* s.m. 20240302 */
			if (!strcasecmp(pch, "-mt")) {
				pch = strtok(NULL, "=");
				if (pch != NULL) {
					memset(cBufNum, 0x00, sizeof(cBufNum));
					strcpy(cBufNum, pch);
					gcMaxThread = atol((char*)cBufNum);		/* numbers of threads*/
					gcMultiThreadIsFirst = 0;				/* first */
					gcMultiThread = 1;						/* multithread enabled*/
					if ((gcMaxThread < 1) || (gcMaxThread > GC_MAX_THREADS))
					{
						fprintf(stdout, "*GCSORT* ERROR: invalid parameter in command line with option -mt (MultiThread), value is incorrect. -mt=<n> - <n> from 1 to 16\n");
						exit(GC_RTC_ERROR);
					}
				}
				else {
					/* use default 
					fprintf(stdout, "*GCSORT* ERROR: invalid parameter in command line with option -mt (MultiThread)\n");
					exit(GC_RTC_ERROR);
					*/
					gcMultiThreadIsFirst = 0;				/* first */
					gcMultiThread = 1;						/* multithread enabled*/
					gcMaxThread = g_nMaxlogicalcpucount; /* reserve 1 for system ? */
				}
			}
		}
	}
}

#if __LIBCOB_RELEASE >= 30200
const cob_u8_t * get_collation(enum cb_colseq colseq)
{
	static cob_u8_t coltab[256];
	static int coltab_loaded = 0;

	/* Load the translation table only if actually useful */
#ifdef COB_EBCDIC_MACHINE
	 if (colseq == CB_COLSEQ_ASCII) {
#else
	 if (colseq == CB_COLSEQ_EBCDIC) {
#endif
		if (coltab_loaded) {
			 return coltab;
		 }
#ifdef GCSORT_EXE
	#ifdef COB_EBCDIC_MACHINE
		if (cob_load_collation(ebcdic_table, coltab, NULL) < 0) {
	#else
		if (cob_load_collation(ebcdic_table, NULL, coltab) < 0) {
	#endif
			fprintf(stdout, "*GCSORT* ERROR: Problem with option -febcdic-table, could not load the given table\n");
			exit(GC_RTC_ERROR);
		}
#else
#ifdef COB_EBCDIC_MACHINE
		if (cob_load_collation(g_ebcdic_table, coltab, NULL) < 0) {
#else
		if (cob_load_collation(g_ebcdic_table, NULL, coltab) < 0) {
#endif
			fprintf(stdout, "*GCSORT* ERROR: Problem with option -febcdic-table, could not load the given table\n");
			exit(GC_RTC_ERROR);
		}

#endif
		coltab_loaded = 1;
		return coltab;
	}
	return NULL;
}
#endif /* __LIBCOB_RELEASE >= 30200 */
