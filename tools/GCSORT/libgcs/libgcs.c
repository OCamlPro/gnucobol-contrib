/*
    Copyright (C) 2016-2026 Sauro Menna
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
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

#include <libcob.h>

#ifdef _MSC_VER
#define _CRTDBG_MAP_ALLOC
#include <crtdbg.h>
#endif


#include <time.h>

#include "../gcshare.h"
#include "../gcsort.h"
#include "../gcthread.h"
#include "../job.h"
#include "../sortfield.h"
#include "../file.h"
#include "../inrec.h"
#include "../outrec.h"
#include "../utils.h"
#include "../condfield.h"
#include "../fieldvalue.h"
#include "../copyfile.h"
#include "libgcs.h"

int g_nTypeFormat = 0;
int g_nTypeFile = 0;
struct file_t* g_current_file = NULL;

struct job_t* g_job = NULL;
int g_nRTC = 0;


int gruntime_status = 0;  /* 1 - COBOL Caller |  2 Others Caller */

#define GCS_CALLER_CBL  1
#define GCS_CALLER_C    2
#define GCS_CALLER_ERR  0

/* --- */
/* Global variable pointer */
cob_global* gcs_cob_glob_ptr;

/* Call parameters */
//cob_field* cob_procedure_params[1];
/* Module path */
static const char* cob_module_path = NULL;
/* Perform frame stack */
static struct cob_frame* frame_overflow;
static struct cob_frame* frame_ptr;
static struct cob_frame	frame_stack[255];

/* MultiThread */
static int gcMultiThreadIsFirst = 0;
static int gcMultiThread = 0;
static int gcMaxThread = 0;
/* MultiThread */

#if defined(_WIN32) || defined(__MINGW32__)  || defined(__MINGW64__)
#include <windows.h>
typedef HMODULE cob_handle_t;
#else
#include <dlfcn.h>
typedef void* cob_handle_t;
#endif
// Definiamo i puntatori di tipo per le funzioni di GnuCOBOL
typedef int (*fn_cob_is_initialized)(void);
typedef void (*fn_cob_init_nomain)(const int argc, char** argv);


extern int process_keyfield(int position, int length, char* keyType, char* keyCollating);

GCS_API int gcs_sort_init(void)
{
#pragma message ("--- ================================================================================== ---")
#pragma message ("-- Define how to enable the collating sequence >>> fcd->confFlags2 - Collating sequence ? ")
#pragma message ("--- ================================================================================== ---")
	int nRC = 0;
    struct job_t* job = gcs_job_constructor();
	if (job == NULL)
		return 1;
    globalJob = job;
	g_job = job;
	nRC = gcs_init_cob();
	if (nRC != 0) {
		printf("[Error: gcs_init_cob() error]. ReturnCode:%d\n", nRC);
		return 1;
	}
    job_ReviewMemAlloc(job);
    job_AllocateField(job);
    job_AllocateDataKey(job);
	return 0;
}

GCS_API struct job_t* gcs_job_constructor(void) 
{
	return ((struct job_t* ) job_constructor());
}
GCS_API void gcs_job_destructor(struct job_t* job)
{
	return; 
}


int gcs_check_cobol_runtime(void) {
	cob_handle_t handle = NULL;
	fn_cob_is_initialized dynamic_cob_is_initialized = NULL;
	fn_cob_init_nomain dynamic_cob_init_nomain = NULL;

	/* ATTEMPT TO BIND SYMBOLS (Cross-Platform) */
#if defined(_WIN32) || defined(__MINGW32__) || defined(__MINGW64__)
	char dll_name[32];

	for (int count = 20; count >= 1; count--) {
		memset(dll_name, 0x00, 32);
		sprintf(dll_name, "libcob-%d.dll", count);

		handle = GetModuleHandle(dll_name);
		if (!handle) {
			handle = LoadLibrary(dll_name);
		}

		if (handle) {
			printf("[libgcs] Found and loaded runtime: %s\n", dll_name);
			break; // Trovata! Esci dal ciclo
		}
	}


	/* 2. Fallback to legacy name if primary is not found */
	if (!handle) {
		handle = GetModuleHandle("libcob.dll");
		if (!handle) {
			handle = LoadLibrary("libcob.dll");
		}
	}

	/* Resolve symbols with intptr_t cast to prevent -Wcast-function-type on Win64 */
	if (handle) {
		dynamic_cob_is_initialized = (fn_cob_is_initialized)(intptr_t)GetProcAddress(handle, "cob_is_initialized");
		dynamic_cob_init_nomain = (fn_cob_init_nomain)(intptr_t)GetProcAddress(handle, "cob_init_nomain");
	}
#else
	/* On Linux, search the process's global namespace (RTLD_DEFAULT) */
	dynamic_cob_is_initialized = (fn_cob_is_initialized)dlsym(RTLD_DEFAULT, "cob_is_initialized");
	dynamic_cob_init_nomain = (fn_cob_init_nomain)dlsym(RTLD_DEFAULT, "cob_init_nomain");

	/* Fallback: try loading modern shared object explicitly */
	if (!dynamic_cob_is_initialized) {
		handle = dlopen("libcob.so.4", RTLD_LAZY | RTLD_GLOBAL);
		if (!handle) {
			/* Legacy fallback */
			handle = dlopen("libcob.so", RTLD_LAZY | RTLD_GLOBAL);
		}

		if (handle) {
			dynamic_cob_is_initialized = (fn_cob_is_initialized)dlsym(handle, "cob_is_initialized");
			dynamic_cob_init_nomain = (fn_cob_init_nomain)dlsym(handle, "cob_init_nomain");
		}
	}
#endif

	/* CONTROL LOGIC AND INITIALIZATION */
	if (dynamic_cob_is_initialized != NULL) {
		if (dynamic_cob_is_initialized()) {
			return 1; // Already initialized by the COBOL caller
		}
	}

	if (dynamic_cob_init_nomain != NULL) {
		printf("[libgcs] Pure C context detected. COBOL runtime initialization (nomain)...\n");
		dynamic_cob_init_nomain(0, NULL);
		return 2; // Successfully initialized
	}

	/* Fail-safe: GnuCOBOL is not installed or cannot be linked on the system */
	return 0;
}


GCS_API int gcs_init_cob(void)
{
	char szMex[10];
	/* Let's ACTUALLY run the function using parentheses () and save the result */
	gruntime_status = gcs_check_cobol_runtime();

	/* Case 1: The COBOL runtime was already running (calling COBOL) */
	if (gruntime_status == GCS_CALLER_CBL) {
		return 0;
	}

	/* Case 2: Irreversible error—libcob is not installed or is not accessible */
	if (gruntime_status == GCS_CALLER_ERR) {
		return -1;
	}

	/* Note: If gruntime_status == 2, gcs_check_cobol_runtime has ALREADY
	   successfully called cob_init_nomain(0, NULL). Therefore, we must NOT call cob_init(0, NULL). */

	/* Let's register the dummy module in the environment we just configured */
	cob_module_enter(&module, &gcs_cob_glob_ptr, 0);

	gcs_cob_glob_ptr->cob_call_params = 0;
	gcs_cob_glob_ptr->cob_stmt_exception = 0;

	memset(szMex, 0x00, 10);

	/* Set frame stack pointer */
	frame_ptr = frame_stack;
	frame_ptr->perform_through = 0;

	frame_overflow = frame_ptr + 255 - 1;
	cob_module_path = gcs_cob_glob_ptr->cob_main_argv0;

	/* Direct assignment without dynamic heap allocation */
	module->module_name = "extsm";
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
	module->module_num_params = gcs_cob_glob_ptr->cob_call_params;

	return 0;
}



GCS_API int gcs_sort_cleanup(void)
{
    int nRC = 0;

   job_destroy(g_job);
   job_destructor(g_job);  
   g_job = NULL;
   GCSORT_Cleanup(0);


	// VERIFICARE !!!!
	if (gruntime_status == 2)
		cob_tidy();

    return nRC;

}

/* define command operation: Sort, Merge, Copy */
GCS_API int gcs_sort_set_oper(char c)  /* (sort / merge / copy ???)*/
{
    job_SetTypeOP(c);
    return 0;
}

/* -fsign=[ASCII|EBCDIC] define display sign representation */
GCS_API int gcs_cb_sign(int ns)
{
	if (ns == 1)
		g_cb_ebcdic_sign = 1;  /*sign EBCDIC */
	return 0;
}

/* - fcolseq = [NATIVE | ASCII | EBCDIC] collating sequence to use */
GCS_API int gcs_colseq(int ns)
{
	if (ns == 1)
		g_cb_colseq = 1;  /*sign ASCII   */
	if (ns == 2)
		g_cb_colseq = 2;  /*sign EBCDIC  */
	return 0;
}

/* - febcdic - table  */
GCS_API int gcs_ebcdic_table(unsigned char* etab)
{
	if (strlen(etab) > 0)
		strncpy(g_ebcdic_table, etab, sizeof(g_ebcdic_table) - 1);
	return 0;
}

/* Enable MultiThread  - TO BE IMPLEMENTED */
GCS_API int gcs_sort_enable_multithread( int nThread )
{
	fprintf(stdout, "*GCSORT*S808*ERROR: Multithread not available. \n");
	exit(GC_RTC_ERROR);

	/* not implemented
	gcMultiThread = 1;
	gcMaxThread = nThread;
	return 0;
	*/
}

/* define command indexed key */
GCS_API int gcs_sort_init_key(int position, int length, const char* ctype, const char* cdirection)
{
    struct sortField_t* sortField;
    /* int position, int length, int type, int direction */
    sortField = sortField_constructor(position, length, utils_parseFieldType(ctype), utils_parseSortDirection(cdirection));
    if (sortField == NULL) {
        utl_abend_terminate(MEMORYALLOC, 108, ABEND_SKIP);
        return GC_RTC_ERROR;
    }
    sortField_addDefinition(sortField);
    g_nTypeFormat = 1; // 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields  */
    return 0;
}

GCS_API int gcs_sort_use(char* name, const char* org, char* fix_var, int rec_len, int rec_maxlen)
{
    int nrtc = 0;
    struct file_t* file = file_constructor(name);
    strcpy(szMexToken, "use clause");
    if (file == NULL) {
        utl_abend_terminate(MEMORYALLOC, 100, ABEND_SKIP);
        return GC_RTC_ERROR;
    }
    file_setInputFile(file);
    g_current_file = file;
    g_nTypeFile = 0;
    nrtc = file_setOrganization(g_current_file, utils_parseFileOrganization(org));
    if (nrtc == -1)
        exit(GC_RTC_ERROR);
    file_setFormat(g_current_file, utils_parseFileFormat(fix_var));
    file_setRecordLength(g_current_file, rec_len);
    file_setMaxLength(g_current_file, rec_maxlen);
    file_SetInfoForFile(g_current_file, COB_OPEN_INPUT); /* Input */
	job_PutIntoArrayFile(g_job->arrayFileInCmdLine[g_job->nMaxFileIn], name, (int)strlen(name));
	g_job->nMaxFileIn++;
    return nrtc;
}

GCS_API int gcs_sort_add_key(int position, int length, char* keyType, char* keyCollating)
{
    if (!ut_process_keyfield(g_current_file, position, length, keyType, keyCollating))
        return GC_RTC_ERROR;
    return 0;
}

GCS_API int gcs_sort_give(char* name, const char* org, char* fix_var, int rec_len, int rec_maxlen)
{
    int nrtc = 0;
    struct file_t* file = file_constructor(name);
    strcpy(szMexToken, " give clause ");
    if (file == NULL) {
        utl_abend_terminate(MEMORYALLOC, 101, ABEND_SKIP);
        return GC_RTC_ERROR;
    }
    file_setOutputFile(file);
    g_current_file = file;
    g_nTypeFile = 0;
    nrtc = file_setOrganization(g_current_file, utils_parseFileOrganization(org));
    if (nrtc == -1)
        return GC_RTC_ERROR;
    file_setFormat(g_current_file, utils_parseFileFormat(fix_var));
    file_setRecordLength(g_current_file, rec_len);
    file_setMaxLength(g_current_file, rec_maxlen);
    file_SetInfoForFile(g_current_file, COB_OPEN_OUTPUT); /*  Output  */
    g_current_file = NULL;
	job_PutIntoArrayFile(g_job->arrayFileOutCmdLine[g_job->nMaxFileOut], name, (int)strlen(name));
	g_job->nMaxFileOut++;
	g_job->outputLength = rec_maxlen;
	return nrtc;

}
GCS_API int gcs_sort_data(struct job_t* job)
{
	return job_sort_data(job);
}

GCS_API int gcs_save_tempfinal(struct job_t* job) 
{
	return job_save_tempfinal(job);
}

GCS_API  int gcs_save_out(struct job_t* job) 
{
	return job_save_out(job);

}
GCS_API int gcs_save_tempfile(struct job_t* job) 
{
	return job_save_tempfile(job);
}

GCS_API int gcs_job_destroy(struct job_t* job) 
{
	return job_destroy(job);
}
/* GCS_API const cob_u8_t* gcs_get_collation(enum cb_colseq colseq)    */
/* {                                                                   */
/* 	return (get_collation(colseq));                                    */
/* }                                                                   */
GCS_API int gcs_LoadInMemory(struct job_t* job, char* szBuffRek, char* szBuffKey, int nLenRek, int nSplitBuf, int nIdxFileIn, int64_t nLim01, int64_t nLim02)
{
	return job_LoadInMemory(job, szBuffRek, szBuffKey, nLenRek, nSplitBuf, nIdxFileIn, nLim01, nLim02);
}
GCS_API int gcs_sort_review_name(void)
{
	job_RedefinesFileName(g_job);
	return 0;
}

GCS_API int gcs_sort_check(struct job_t* job) 
{
	return job_check(job);

}


GCS_API int gcs_sort_LoadFile(void)
{
	time_t timeStart;
	int nRC = 0;
	int nContinueSrtTmp = 0;

	time(&timeStart);

	do {
		nRC = job_loadFiles(g_job);
		if (nRC == -2)
			nContinueSrtTmp = 1;
		if (nRC == -1)
			break;
		/* Sort data */
		nRC = job_sort_data(g_job);
		if (nRC == -1)
			break;
		if (g_job->bIsPresentSegmentation == 1) {
			nRC = job_save_tempfile(g_job);
		}
		if (nRC == -1)
			break;
	} while (nContinueSrtTmp == 1);

	return nRC;
}

GCS_API int gcs_sort_run( void )
{
	char szMex[10];
	int nRC = 0;
	gcs_sort_review_name();
	switch (job_GetTypeOp(g_job)) {
	case ('C'):
		sprintf(szMex, "Copy");
		g_nRTC = job_copy(g_job);
		break;
	case ('M'):
		sprintf(szMex, "Merge");
		nRC = job_merge_files(g_job);
		break;
	case ('S'):
		sprintf(szMex, "Sort");
		g_nRTC = gcs_sort_LoadFile();

		if (g_nRTC == 0) {
			if (g_job->bIsPresentSegmentation == 1)
				g_nRTC = gcs_save_tempfinal(g_job);
			else
				g_nRTC = gcs_save_out(g_job);
		}
		break;
	}
	return g_nRTC;
}
/* --------------------------*/
/* Inrec _  DIGIT ',' DIGIT  */
/* --------------------------*/
GCS_API int gcs_inrec_range(int pos, int len)
{
	struct inrec_t* inrec = inrec_constructor_range(pos, len);
	if (inrec == NULL) {
		utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
		exit(GC_RTC_ERROR);
	}
	inrec_addDefinition(inrec);
	return 0;
}

/* DIGIT ':' CHARTYPE STRING */
GCS_API int gcs_inrec_substnchar(int nPosAbs, unsigned char* sType, unsigned char* strValue )
{
	struct inrec_t* inrec = inrec_constructor_possubstnchar(nPosAbs, (unsigned char*)sType, (unsigned char*)strValue);
	if (inrec == NULL) {
		utl_abend_terminate(MEMORYALLOC, 125, ABEND_SKIP);
		exit(GC_RTC_ERROR);
	}
	inrec_addDefinition(inrec);
	return 0;
}

/* DIGIT ':' DIGIT ',' DIGIT */
GCS_API int gcs_inrec_range_position(int nPosAbs, int nPos, int nLen)
{
	struct inrec_t* inrec = inrec_constructor_range_position(nPosAbs, nPos, nLen);
	if (inrec == NULL) {
		utl_abend_terminate(MEMORYALLOC, 121, ABEND_SKIP);
		exit(GC_RTC_ERROR);
	}
	inrec_addDefinition(inrec);
	return 0;
}

/* OCCURFILL = <n><Type> - Type = C|X|Z  */
GCS_API int gcs_inrec_subst(int nOccur, unsigned char* p1)
{
	char* pBuf = malloc(COB_MINI_BUFF);
	memset(pBuf, 0x00, COB_MINI_BUFF);
	sprintf(pBuf, "%d%s", nOccur, p1);
	struct inrec_t* inrec = inrec_constructor_subst((unsigned char*)pBuf);
	if (inrec == NULL) {
		utl_abend_terminate(MEMORYALLOC, 123, ABEND_SKIP);
		free(pBuf);
		exit(GC_RTC_ERROR);
	}
	inrec_addDefinition(inrec);
	free(pBuf);
	return 0;
}

/* DIGIT ':' CHARTYPE  - case 80:X  */
/* nPosAbsRec is last position previous function */
/* nPosAbsRec must be major of nPosAbs */

GCS_API int gcs_inrec_padding(int nPosAbs, int nOccur, unsigned char* p1, int nPosAbsRec)
{
	char* pBuf = malloc(COB_MINI_BUFF);
	memset(pBuf, 0x00, COB_MINI_BUFF);
	sprintf(pBuf, "%d%s", nOccur, p1);
	struct inrec_t* inrec = inrec_constructor_padding(nPosAbs, (unsigned char*)pBuf, nPosAbsRec);
	if (inrec == NULL) {
		utl_abend_terminate(MEMORYALLOC, 127, ABEND_SKIP);
		free(pBuf);
		exit(GC_RTC_ERROR);
	}
	inrec_addDefinition(inrec);
	free(pBuf);
	return 0;
}

/* ---------------------------*/
/* outrec _  DIGIT ',' DIGIT  */
/* ---------------------------*/
GCS_API int gcs_outrec_range(int pos, int len)
{
	struct outrec_t* outrec = outrec_constructor_range(pos, len);
	if (outrec == NULL) {
		utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
		exit(GC_RTC_ERROR);
	}
	outrec_addDefinition(outrec);
	return 0;
}

/* DIGIT ':' CHARTYPE STRING */
GCS_API int gcs_outrec_substnchar(int nPosAbs, unsigned char* sType, unsigned char* strValue)
{
	struct outrec_t* outrec = outrec_constructor_possubstnchar(nPosAbs, (unsigned char*)sType, (unsigned char*)strValue);
	if (outrec == NULL) {
		utl_abend_terminate(MEMORYALLOC, 125, ABEND_SKIP);
		exit(GC_RTC_ERROR);
	}
	outrec_addDefinition(outrec);
	return 0;
}

/* DIGIT ':' DIGIT ',' DIGIT */
GCS_API int gcs_outrec_range_position(int nPosAbs, int nPos, int nLen)
{
	struct outrec_t* outrec = outrec_constructor_range_position(nPosAbs, nPos, nLen);
	if (outrec == NULL) {
		utl_abend_terminate(MEMORYALLOC, 121, ABEND_SKIP);
		exit(GC_RTC_ERROR);
	}
	outrec_addDefinition(outrec);
	return 0;
}

/* OCCURFILL = <n><Type> - Type = C|X|Z  */
GCS_API int gcs_outrec_subst(int nOccur, unsigned char* p1)
{
	char* pBuf = malloc(COB_MINI_BUFF);
	memset(pBuf, 0x00, COB_MINI_BUFF);
	sprintf(pBuf, "%d%s", nOccur, p1);
	struct outrec_t* outrec = outrec_constructor_subst((unsigned char*)pBuf);
	if (outrec == NULL) {
		utl_abend_terminate(MEMORYALLOC, 123, ABEND_SKIP);
		free(pBuf);
		exit(GC_RTC_ERROR);
	}
	outrec_addDefinition(outrec);
	free(pBuf);
	return 0;
}

/* DIGIT ':' CHARTYPE  - case 80:X  */
/* nPosAbsRec is last position previous function */
/* nPosAbsRec must be major of nPosAbs */

GCS_API int gcs_outrec_padding(int nPosAbs, int nOccur, unsigned char* p1, int nPosAbsRec)
{
	char* pBuf = malloc(COB_MINI_BUFF);
	memset(pBuf, 0x00, COB_MINI_BUFF);
	sprintf(pBuf, "%d%s", nOccur, p1);	struct outrec_t* outrec = outrec_constructor_padding(nPosAbs, (unsigned char*)pBuf, nPosAbsRec);
	if (outrec == NULL) {
		utl_abend_terminate(MEMORYALLOC, 127, ABEND_SKIP);
		free(pBuf);
		exit(GC_RTC_ERROR);
	}

	outrec_addDefinition(outrec);
	free(pBuf);
	return 0;
}
/* -------------*/
/* Include/Omit */
/* -------------*/
/* (156,15,CH,LT,141,15,CH)   */
GCS_API struct condField_t* gcs_cond_fields(int pos1, int len1, char* type1, char* opcond, int pos2, int len2, char* type2)
{
	struct condField_t* condField = condField_constructor_conditionfield(pos1, len1, utils_parseFieldType(type1), utils_parseCondCondition(opcond), pos2, len2, utils_parseFieldType(type2));
	if (condField == NULL) {
		utl_abend_terminate(MEMORYALLOC, 127, ABEND_SKIP);
		exit(GC_RTC_ERROR);
	}
	return condField;
}
/* 1,6,CH,EQ,C'String'  */
GCS_API struct condField_t* gcs_cond_value(int pos1, int len1, const char* type1, char* opcond, char* cType, char* value)
{
	struct fieldValue_t* fv1 = fieldValue_constructor(cType, value, TYPE_STRUCT_NEW, 0);
	if (fv1 == NULL) {
		utl_abend_terminate(MEMORYALLOC, 218, ABEND_SKIP);
		exit(GC_RTC_ERROR);
	}
	struct condField_t* condField = condField_constructor_condition(pos1, len1, utils_parseFieldType(type1), utils_parseCondCondition(opcond), (struct fieldValue_t*)fv1);
	if (condField == NULL) {
		utl_abend_terminate(MEMORYALLOC, 127, ABEND_SKIP);
		exit(GC_RTC_ERROR);
	}
	return condField;
}

GCS_API struct condField_t* gcs_cond_OR(struct condField_t* cf1, struct condField_t* cf2)
{
	return condField_constructor_operation(COND_OPERATION_OR, cf1, cf2);
}
GCS_API struct condField_t* gcs_cond_AND(struct condField_t* cf1, struct condField_t* cf2)
{
	return condField_constructor_operation(COND_OPERATION_AND, cf1, cf2);
}

GCS_API int gcs_addInclude(struct condField_t* cf)
{
	g_job->includeCondField = cf;
	return condField_addInclude(cf);
}

GCS_API int gcs_addOmit(struct condField_t* cf)
{
	g_job->omitCondField = cf;
	return condField_addOmit(cf);
}
/* -------------*/
/* Statistics */
/* -------------*/
GCS_API int64_t gcs_stats_rec_total(void)
{
	return (g_job->recordNumberTotal);
}
GCS_API int64_t gcs_stats_rec_writesort(void)
{
	return (g_job->recordWriteSortTotal);
}
GCS_API int64_t gcs_stats_rec_writeout(void)
{
	return (g_job->recordWriteOutTotal);
}
GCS_API int64_t gcs_stats_rec_omitinclude(void)
{
	return (g_job->recordOmitIncludeTotal);
}
GCS_API int64_t gcs_stats_rec_discardXSUM(void)
{
	return (g_job->recordDiscardXSUMTotal);
}
/* return code */
GCS_API int gcs_get_returncode(void)
{
	return (g_nRTC);
}
