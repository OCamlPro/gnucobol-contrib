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
/*
Environment Variables Configuration
The naming convention remains completely clean. Since the library filename (EXTSM) does not conflict with the internal entry points (EXTFH and gcs), the runtime avoids any recursive 
short-circuits.

On Windows (Targeting .dll)
:: Preload the unified library into memory
set COB_PRELOAD=C:\path\to\libraries\EXTSM.dll

:: 1. Diciamo a GnuCOBOL quale libreria ospita il gestore dei verbi nativi
set COB_FILE_HANDLER=all_io

:: 2. Inseriamo la cartella corrente nel PATH per fare in modo che le 
::    chiamate esplicite CALL "EXTFH" e CALL "gcs" trovino la stessa DLL
set PATH=.;%PATH%

:: 3. Avviamo il programma COBOL
il_tuo_programma.exe


*/

#ifndef LIBGCS_EXPORTS_H
#define LIBGCS_EXPORTS_H

/* --- BLOCCO DI PORTABILITÀ UNIVERSALE --- */
#if defined(_WIN32) || defined(__WIN32__) || defined(__CYGWIN__)
#define GCS_API  __declspec(dllexport)
#else
#if defined(__GNUC__) && __GNUC__ >= 4
#define GCS_API __attribute__((visibility("default")))
#else
#define GCS_API
#endif
#endif

#if defined(snprintf) && defined(_MSC_VER) 
#undef snprintf
#endif

/* Enable debug */
#define EXTSM_DEBUG    /* 0 no (#undef), 1 active */
/* */
#undef EXTSM_DEBUG 
/* */

#if defined(_WIN32) || defined(__MINGW32__)
#define GCSORT_API __declspec(dllexport)
#else
#define GCSORT_API
#endif

enum cb_colseq {
	CB_COLSEQ_NATIVE = 0,
	CB_COLSEQ_ASCII = 1,
	CB_COLSEQ_EBCDIC = 2
};

#define  LIBGCS_VERSION "01.00.00"

#define  EXTSM_VERSION  "01.00.00"

#define  COB_SOURCE_FILE		"gcsort.c"
#define  COB_MODULE_FORMATTED_DATE	"oct 02 2026 20:00:00"
#define  COB_MODULE_DATE		20261002
#define  COB_MODULE_TIME		200000


#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include <libcob.h> 

#ifdef _MSC_VER
#define _CRTDBG_MAP_ALLOC
#include <crtdbg.h>
#endif

struct job_t;
static int g_cb_ebcdic_sign = 0;

#define MAX_HANDLE_TEMPFILE  16 

struct Job_tmpfile_t {
    int  bIsEof[MAX_HANDLE_TEMPFILE];
    int  handleTmpFile[MAX_HANDLE_TEMPFILE];
    int  byteReadTmpFile[MAX_HANDLE_TEMPFILE];
    struct mmfio_t* ArrayFile[MAX_HANDLE_TEMPFILE];
    unsigned char* ptrBuf[MAX_HANDLE_TEMPFILE];
    unsigned char* recordBuffer;
    unsigned char* szBufRekTmpFile[MAX_HANDLE_TEMPFILE];
    int  nLastRead;
    int  nSumEof;

};

#if __LIBCOB_RELEASE >= 30200
	const cob_u8_t * get_collation(enum cb_colseq colseq);
#else
	 #define get_collation(cs) NULL

#endif /* __LIBCOB_RELEASE >= 30200 */



GCS_API  void* gcs_get_job(void);

/* Job Init */
GCS_API int gcs_sort_init(void);         /* Initialize environment */
/* Init Cobol Environment */
GCS_API int gcs_init_cob(void);
/* Enable MultiThread */
GCS_API int gcs_sort_enable_multithread(int nThread);

/* Check jon definition */
GCS_API int gcs_sort_check(struct job_t* job);

/* Clear Job definitioin */
GCS_API int gcs_sort_cleanup(void);      /* Cleaning environemnt */
/* Set operation to sort/merge */
GCS_API int gcs_sort_set_oper(char c);  /* (sort / merge)*/

/* define command sort key : Sort, Merge, Copy */
/* Sort key definition (Call multiple times if there are multiple keys) */
GCS_API int gcs_sort_init_key(int position, int length, const char* ctype, const char* cdirection);  
/* Use statement */
 /* file/files definitio USE statement */
GCS_API int gcs_sort_use(char* name, const char* org, char* fix_var, int rec_len, int rec_maxlen);  
/* Give file definition */
GCS_API int gcs_sort_give(char* name, const char* org, char* fix_var, int rec_len, int rec_maxlen);  
/* Add key definition for Index file */
GCS_API int gcs_sort_add_key(int position, int length, char* keyType, char* keyCollating);


/* Sign    ns=0 -> ASCII, ns=1 -> EBCDIC */
GCS_API int gcs_cb_sign(int ns);
/* - fcolseq = [NATIVE = 0 | ASCII = 1 | EBCDIC = 2] collating sequence to use */
GCS_API int gcs_colseq(int ns);
/* - febcdic - table  */
GCS_API int gcs_ebcdic_table(unsigned char* etab);

/* ================ */
/* Inrec functions  */
/* ================ */
/* Inrec _  DIGIT ',' DIGIT  */
GCS_API int gcs_inrec_range(int pos, int len);
/* DIGIT ':' CHARTYPE STRING */
/*  Char Type  CharType = C(char) | X(hexdical) |Z(zero binary) <String>    */
GCS_API int gcs_inrec_substnchar(int nPosAbs, unsigned char* sType, unsigned char* strValue);
/* DIGIT ':' DIGIT ',' DIGIT */
GCS_API int gcs_inrec_range_position(int nPosAbs, int nPos, int nLen);
/* OCCURFILL = <n><Type> - Type = C|X|Z  */
GCS_API int gcs_inrec_subst(int nOccur, unsigned char* p1);

/* DIGIT ':' CHARTYPE  - case 80:X  */
/* nPosAbsRec is last position previous function */
/* nPosAbsRec must be major of nPosAbs */
GCS_API int gcs_inrec_padding(int nPosAbs, int nOccur, unsigned char* p1, int nPosAbsRec);

/* ================ */
/* Outrec functions */
/* ================ */
/* outrec _  DIGIT ',' DIGIT  */
GCS_API int gcs_outrec_range(int pos, int len);
/* DIGIT ':' CHARTYPE STRING */
/*  Char Type  CharType = C(char) | X(hexdical) |Z(zero binary) <String>    */
GCS_API int gcs_outrec_substnchar(int nPosAbs, unsigned char* sType, unsigned char* strValue);
/* DIGIT ':' DIGIT ',' DIGIT */
GCS_API int gcs_outrec_range_position(int nPosAbs, int nPos, int nLen);
/* OCCURFILL = <n><Type> - Type = C|X|Z  */
GCS_API int gcs_outrec_subst(int nOccur, unsigned char* p1);
/* DIGIT ':' CHARTYPE  - case 80:X  */
/* nPosAbsRec is last position previous function */
/* nPosAbsRec must be major of nPosAbs */
GCS_API int gcs_outrec_padding(int nPosAbs, int nOccur, unsigned char* p1, int nPosAbsRec);

/* Run command statement (Job) */
/* Run read input, sort data, write output */
GCS_API int gcs_sort_run(void);

/* =================== */
/* Include/Omit functions   */
/* =================== */
/* (156,15,CH,LT,141,15,CH)   */
GCS_API struct condField_t* gcs_cond_fields(int pos1, int len1, char* type1, char* opcond, int pos2, int len2, char* type2);
/* 1,6,CH,EQ,C'String'  */
GCS_API struct condField_t* gcs_cond_value(int pos1, int len1, const char* type1, char* opcond, char* cType, char* value);
/* Add OR to conditions */
GCS_API struct condField_t* gcs_cond_OR(struct condField_t* cf1, struct condField_t* cf2);
/* Add AND to conditions */
GCS_API struct condField_t* gcs_cond_AND(struct condField_t* cf1, struct condField_t* cf2);

GCS_API int gcs_addInclude(struct condField_t* cf);
GCS_API int gcs_addOmit(struct condField_t* cf);

/* ========== */
/* Statistics */
/* ========== */
GCS_API int64_t gcs_stats_rec_total(void);
GCS_API int64_t gcs_stats_rec_writesort(void);
GCS_API int64_t gcs_stats_rec_writeout(void);
GCS_API int64_t gcs_stats_rec_omitinclude(void);
GCS_API int64_t gcs_stats_rec_discardXSUM(void);
/*  */

/* Return Code */
GCS_API int gcs_get_returncode(void);

/* Initialize temporary file */
GCS_API struct Job_tmpfile_t* gcs_tmpfile_init(struct job_t* job);


/* Internal function */
GCS_API int gcs_sort_review_name(void);
GCS_API int gcs_sort_LoadFile(void);
GCS_API int gcs_sort_data(struct job_t* job);
GCS_API int gcs_save_out(struct job_t* job);

GCS_API struct job_t* gcs_job_constructor(void);
GCS_API void gcs_job_destructor(struct job_t* job);
GCS_API int  gcs_job_destroy(struct job_t* job);

GCS_API int  gcs_LoadInMemory(struct job_t* job, char* szBuffRek, char* szBuffKey, int nLenRek, int nSplitBuf, int nIdxFileIn, int64_t nLim01, int64_t nLim02);

GCS_API int gcs_save_tempfile(struct job_t* job);
GCS_API int  gcs_tmpfile_get(struct job_t* job, struct Job_tmpfile_t* tmpf, FCD3* fcd);
GCS_API void gcs_tmpfile_cleanup(struct job_t* job, struct Job_tmpfile_t* tmpf);
GCS_API int  gcs_save_tempfinal(struct job_t* job);

/* Check if caller is COBOL or others */
int gcs_check_cobol_runtime(void);

//GCS_API const char* utils_getFileOrganizationName(int organization);
GCS_API const char* gcs_sort_getFileOrgName(int organization);
GCS_API const char* gcs_sort_FileTypeFCD2GCS(int organization);
GCS_API int gcs_sort_DataTypeFCD2GCS(int nInteralType, int nLen);

#endif // LIBGCS_EXPORTS_H

