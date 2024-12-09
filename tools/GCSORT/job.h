/*
    Copyright (C) 2016-2024 Sauro Menna
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

#ifndef JOB_H_INCLUDED
#define JOB_H_INCLUDED


#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <errno.h>

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	#include <io.h>
	#define _strtoll    _strtoi64
	/* #define GCThread __declspec( thread ) */
#else
	#include <limits.h>
	#include <sys/io.h>
	#include <time.h>
	#include <fcntl.h>
	#define _strtoll   strtoll
	/* #define GCThread __thread */
#endif

#if	defined(_MSC_VER)
	#define GCThread __declspec( thread )
#else
	#define GCThread __thread 
#endif




#include "utils.h"
#include "mmfioc.h"


#define MAX_FILES_INPUT 16	/* Number of max files in input for merge and temporary files   */

/* future use #define EM_MFSORT 1	// Emulate MFSORT   */

struct file_t;
struct sortField_t;
struct condField_t;
struct outrec_t;
struct inrec_t;
struct SumField_t;
struct mmfio_t;

struct job_t;


#define	COB_FILE_BUFF		4096
#define	COB_MEDIUM_BUFF		8192
#define	COB_LARGE_BUFF		16384

#define MAX_RECSIZE			32752 
#define MAX_HANDLE_TEMPFILE	16
#define MAX_HANDLE_THREAD   16*16
#define SIZEINT				sizeof(int)     /* 4    */
#define SIZEINT64			sizeof(int64_t) /* 8    */

#define MAX_FIELDSIZE		4092  /* DFSort limits */

#define SZPOSPNT            SIZEINT64
#define SZLENREC            SIZEINT
#define SZPNTDATA           SIZEINT64
#define SIZESRTBUFF         SIZEINT64+SIZEINT+SIZEINT64

#define MAXFIELDSORT        50

#define	MAX_SIZE_CACHE_WRITE		65536*62 /* 65536*62*2   //62   */
#define	MAX_SIZE_CACHE_WRITE_FINAL	65536*62 /* 65536*62*2   //62   */

#define MAXFILEIN 100

#define  READ_BLOCK_CHUNK	10
#define  READ_ROUND_ROBIN	21

#define CHECK_RECORD_POSITION_NO	0
#define CHECK_RECORD_POSITION_YES	1


struct hSrtMem_t {
	int64_t lPosPnt;			/* Pointer RRN file*/
	unsigned char* pAddress;	/* Pointer memory record area */
	unsigned int   nLenRek;		/* Record len */
};

struct job_t {
	char arrayFileInCmdLine[MAXFILEIN][FILENAME_MAX];
    char arrayFileOutCmdLine[MAXFILEIN][FILENAME_MAX];
	char arrayFileOutFilCmdLine[MAXFILEIN][FILENAME_MAX];
	char array_FileTmpName[MAX_HANDLE_THREAD][FILENAME_MAX];
	char FileNameXSUM[FILENAME_MAX];
	char job_typeOP;				        /* 'S' for sort, 'M' for Merge, 'C' for Copy, 'J' for Join    */
	char strPathTempFile[FILENAME_MAX];     /* path temporary file                          */
	char szCmdLineCommand[8192];	        /* Copy from command line                       */
	char szTakeFileName[8192];	            /* Take FileName                                */
	int	 array_FileTmpHandle[MAX_HANDLE_THREAD];
	int	 bIsFieldCopy;		                /* SORT-MERGE FIELDS=COPY                       */
	int	 bIsPresentSegmentation;		    /* File segmentation                            */
	int	 m_SeekOrder;
	int	 nCurrFileInput;
	int	 nMlt;
	int	 nNumTmpFile;
	int	 nStatistics;
	int	 nTestCmdLine;	/* 0 normal, 1 test command line    */
	int	 nTypeEmul;		/* 0 stardard OC, 1 emulate MFSORT  */
/* Option   */
	int	 nVLSCMP;   /* 0 disabled , 1 = enabled -- temporarily replace any missing compare field bytes with binary zeros    */
	int	 nVLSHRT;   /* 0 disabled , 1 = enabled -- treat any comparison involving a short field as false                    */
	/* Date */
	int  nY2Year;
	int  nY2Past;
	int  nY2PastLimInf;
	int  nY2PastLimSup;
	int  nY2PastLimInfyy2;		/* 2 digit yy               */
	int  nY2PastLimInfyy3;		/* 3 digit yyy              */
	int  nOutFileSameOutFile;	/* when OutFil use OutFile  */
	int	 ndeb; 
	int	 sumFields;
	int  nXSumFilePresent;				/* 0= no XSUM File, 1=yes XSUM File */
	int  bIsTake;
	int  bReUseSrtFile;
	int  nCountSrt[MAX_HANDLE_TEMPFILE];
	int  nIndextmp2;  
	int  nIndextmp;
	int  nLastPosKey;
	int  nLenKeys;
	int  nMaxFileIn;
	int  nMaxFileOut;
	int  nMaxFileOutFil;		/* Number of file in OutFIL, used in SAVE option*/
	int  nMaxHandle;
	/* not 202409 used int64_t	file_length;*/
	int64_t	lPosAbsRead;
	int64_t	nSkipRec;
	int64_t	nStopAft;
	int64_t	recordNumberTotal;
	int64_t recordReadInCurrent;
	int64_t	recordWriteOutTotal;
	int64_t	recordWriteSortTotal;
	int64_t	recordDiscardXSUMTotal;
	int64_t	ulMemSizeAllocData;		        /* Max size mem                 */
	int64_t	ulMemSizeAllocSort;		    /* Max size mem                 */
	int64_t	ulMemSizeRead;		        /* Current size mem after read  */
	int64_t	ulMemSizeSort;
	int64_t recordNumber;
	int64_t recordNumberAllocated;
	struct SumField_t*  SumField;
	struct condField_t* includeCondField;
	struct condField_t* omitCondField;
	struct condField_t* tmpCondField;
	struct file_t*      inputFile;
	struct file_t*      outputFile;
	struct inrec_t*     inrec;
/* Outfil   */
	struct outfil_t*	outfil;
	struct outfil_t*	pLastOutfil_Split;
	struct outfil_t*	pSaveOutfil;

	struct file_t*		XSUMfile;

	struct outrec_t*    outrec;
	struct sortField_t* sortField;
	unsigned char*  buffertSort;
	unsigned char*  recordData;
	unsigned int inputLength;
	unsigned int ncob_varseq_type;		/* 0   means 2 byte record length (big-endian),			1   means 4 byte record length (big-endian)             */      
	                                 	/* 2   means 4 byte record length (local machine int),  3   means 2 byte record length (local machine short)    */
	unsigned int	outputLength;
	unsigned long   LenCurrRek;

	char strCallNameE15[FILENAME_MAX];  /* Call Name E15                        */
	char strCallNameE35[FILENAME_MAX];  /* Call Name E35                        */
	unsigned int   nExitRoutine;	    /* code  0= no routine, 1=E15, 2=E35    */
	struct E15Call_t* E15Routine;
	struct E35Call_t* E35Routine;
	/*  Record Control Statement*/
	int		nTypeRecordFormat;		/* TYPE Record Format */
	int		nLenInputL1;
	int		nLenE15L2;
	int		nLenOutputL3;
	int		nLenMinLenL4;
	int		nLenAvgLenL5;
	int		nLenFutureUseL6;
	int		nLenFutureUseL7;

	int     nTypeIndexHandler;		/* Type Index file handler */

	int     nMultiThread;		/* flag MultiThread 0=no, 1=yes*/
	int     nCurrThread;		/* current Thread */
	int		nMaxThread;			/* num max Thread */
	int     nTypeLoadThread;	/* READ_BLOCK_CHUNK = 10 = block/chunk, READ_ROUND_ROBIN = 21 = round robin */

	struct join_t* join;

/* s.m. 20240302 */

	cob_field* g_fd1;
	cob_field* g_fd2;
	cob_field* g_fdate1;
	cob_field* g_fdate2;
	cob_field* g_ckfdate1;
	cob_field* g_ckfdate2;
	struct sortField_t* srtF;

	int g_lenRek;
	int nSp ;
	int nTypeFieldsCmd;
	int result;
	int64_t lPosA;
	int64_t lPosB;
	long nSpread;
	struct sortField_t* gcsortField;
	int g_nTypeGC;
	int g_nType;
	int g_nLen;
	int g_nFlags;
	int g_idx;
	int g_idx_max;
	int64_t g_fld1;
	int64_t g_fld2;
	cob_field* cob_field_key[100];
	unsigned char* g_pdata[100];

	int g_nSp;	
	int g_nPos;
	int g_result;
	int g_first_sort;

	const uint8_t* g_src;
	uint8_t* g_dst;
	size_t g_i;
	int	nLenMemory;

	struct hSrtMem_t* phSrt;
	int bThreadIsFirstRound;

	int64_t	nCountRecThread;
	struct file_t* fileLoad;
	int64_t nMTSkipRec;
	int64_t nMTStopAft;

	int64_t nRecCount;

	/* 20240927 */
	int nContinueSrtTmp;
	int nRC;
};

/* ok ok ok struct job_t* globalJob;    */

struct job_t *job_constructor( void );
void job_destructor(struct job_t *job);
int job_destroy(struct job_t *job);
int job_sort(struct job_t* job);
int job_load(struct job_t *job, int argc, char **argv);
int job_check(struct job_t *job);
int job_loadFiles(struct job_t *job);

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	INLINE int job_sort_data(struct job_t *job);
#else
	INLINE int job_sort_data(struct job_t* job); 
#endif
int job_save_out(struct job_t *job);
int job_save_tempfile(struct job_t *job);
int job_save_tempfinal(struct job_t *job);

INLINE2 int job_ReadFileTemp(struct mmfio_t* descTmp, int* nLR, unsigned char* szBuffRek);

int job_print(struct job_t *job);
int job_GetTypeOp(struct job_t *job);


#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	INLINE  int job_GetKeys(struct job_t* job, unsigned char* szBufferIn, unsigned char* szKeyOut);
#else
	INLINE2 int job_GetKeys(struct job_t* job, unsigned char* szBufferIn, unsigned char* szKeyOut);
#endif


int job_GetLenKeys( struct job_t* job );
int job_GetLastPosKeys( struct job_t* job );

int job_Verify_EOF(int* nState, struct file_t* stFileDef, unsigned char* szVectorRead1, int* nLenVR1, unsigned char* szVectorRead2, int* nLenVR2);

/* static INLINE */

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	INLINE2 int job_IdentifyBuf(struct job_t* job, unsigned char** ptrBuf, int nMaxEle);
#else
	INLINE2 int job_IdentifyBuf(struct job_t* job, unsigned char** ptrBuf, int nMaxEle);
#endif
 /* NO Inline */
#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	int job_compare_rek_sort(const void* first, const void* second);
#else
	int job_compare_rek_sort(const void* first, const void* second);
#endif

int job_print_final(struct job_t *job, time_t* timeStart);
int job_SetTypeOP (char typeOP);
int job_merge_files(struct job_t *job);
int job_SetFieldCopy (int nFC);
int job_GetFieldCopy ( void );
int job_MakeCmdLine(char* szF, char* buf);
int job_EmuleMFSort( void );

void job_SetCmdLine(struct job_t* job, char* strLine);
char* job_GetCmdLine( struct job_t* job ) ;
int	job_scanCmdLineFile(struct job_t *job, char* buffer, char* bufnew);
int	job_scanPrioritySearch(char* buffer);
int	job_FileInputBuffer (struct job_t *job, char* szBuffIn, char* bufnew, int nPosStart);
int	job_FileOutputBuffer (struct job_t *job, char* szBuffIn, char* bufnew, int nPosStart);
int	job_XSUMFileOutputBuffer(struct job_t* job, char* szBuffIn, char* bufnew, int nPosStart);
int	job_FileOutFilBuffer(struct job_t* job, char* szBuffIn, char* bufnew, int nPosStart, char* strtoken);
int job_PutIntoArrayFile(char* pszBufOut, char* pszBufIn, int nLength);
int job_RedefinesFileName( struct job_t *job);
int job_NormalOperations(struct job_t *job);
int job_CloneFileForOutfil( struct job_t *job);
void job_CloneFileForOutfilSet(struct file_t* file);
int job_CloneFileForXSUMFile(struct job_t* job);

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	INLINE int job_set_area(struct job_t* job, struct file_t* file, unsigned char* szBuf, int nLenOut, int nLenRek);
#else
	INLINE2 int job_set_area(struct job_t* job, struct file_t* file, unsigned char* szBuf, int nLenOut, int nLenRek);
#endif

	int	job_scanCmdSpecialChar(char* bufnew);
int	job_RescanCmdSpecialChar(char* bufnew);
/* void job_SetRecLen(struct job_t *job, int recordsize, unsigned char* szHR);  */
void job_ReviewMemAlloc ( struct job_t *job  );
void job_AllocateField(struct job_t* job);
void job_DestroyField(struct job_t* job);
int job_MakeExitRoutines(struct job_t* job);

int job_skip_record_LS_LSF(struct job_t* job, struct file_t* file, int64_t* nRec);
int job_skip_record(struct job_t* job, struct file_t* file, int64_t* nRec);

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	void job_getTypeFlags(int nTypeField, int* nType, int* nFlags, int nLen);
#else
	void job_getTypeFlags (int nTypeField, int* nType, int* nFlags, int nLen );
#endif

	/* INLINE int job_compare_key(struct job_t* job, const void* first, const void* second); */

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	INLINE int job_compare_key(struct job_t* job, const void* first, const void* second, int nSplit);
#else
	INLINE  int job_compare_key(struct job_t* job, const void* first, const void* second, int nSplit);
#endif


INLINE int job_compare_rek(struct job_t* job, const void *first, const void *second, int bCheckPosPnt, int nSplit);

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	 INLINE  int job_compare_qsort(void* jobparam, const void* first, const void* second);
#else
	 INLINE  int job_compare_qsort(const void* first, const void* second, void* jobparam);
#endif

int job_IdentifyBufMerge(struct job_t* job, unsigned char** ptrBuf, int nMaxElements, int* nCmp);

INLINE int job_ReadFileMerge(struct file_t* file, int* nLR, unsigned char* szBuffRek);
INLINE cob_field* job_cob_field_create ( void );
void job_cob_field_set (cob_field* field_ret, int type, int digits, int scale, int flags, int nLen);
INLINE void job_cob_field_reset(cob_field* field_ret, int type, int size, int digits);
void job_cob_field_destroy ( cob_field* field_ret);
void job_cob_field_destroy_NOData(cob_field* field_ret);
void job_print_error_file(cob_file* stFileDef, int nLenRecOut);

void job_checkslash(char* str);	
/* Date */
int job_CheckTypeDate(int nTypeGC, cob_field* fk1, cob_field* fk2);
int job_compare_date_YY(cob_field* fk2, cob_field* fk1);
int job_compare_date_YYMMDD(cob_field* fk2, cob_field* fk1);
int job_compare_date_YYDDD(cob_field* fk2, cob_field* fk1);
int job_compare_date_Y2T(cob_field* fk2, cob_field* fk1);
int job_compare_date_Y2X(cob_field* fk2, cob_field* fk1);
int job_compare_date_Y2Y(cob_field* fk2, cob_field* fk1);

char* job_GetLastCharPath(char* sz, int* pNum, int* nSkipped);
char* job_GetNextToken(char* sz, int* nSkipped);

int job_SetPosLenKeys(struct job_t* job, int* arPosLen);
int job_AllocateDataKey(struct job_t* job);

INLINE int write_buffered(int desc, unsigned char* buffer_pointer, int nLenRek, unsigned char* bufferwriteglobal, int* position_buf_write);
INLINE int write_buffered_final(int  desc, unsigned char* bufferwriteglobal, int* position_buf_write);
INLINE int write_buffered_save_final(int		desc, unsigned char* buffer_pointer, int nLenRek, unsigned char* bufferwriteglobal, int* position_buf_write);

int SumFields_KeyCheck(struct job_t* job, int* bIsWrited, unsigned char* szKeyPrec, unsigned int* nLenPrec, 
                        unsigned char* szKeyCurr,  unsigned int* nLenRek, unsigned char* szKeySave,  unsigned int* nLenSave, 
                        unsigned char* szPrecSumFields, unsigned char* szSaveSumFields, unsigned char* szBuffRek, int nSplit);
int SumFields_KeyCheckMT(struct job_t* job, int* bIsWrited, unsigned char* szKeyPrec, unsigned int* nLenPrec,
	unsigned char* szKeyCurr, unsigned int* nLenRek, unsigned char* szKeySave, unsigned int* nLenSave,
	unsigned char* szPrecSumFields, unsigned char* szSaveSumFields, unsigned char* szBuffRek, int nSplit);

/*  #if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)   */
/*
#else
*/
#define FASTCOPY
/* #undef FASTCOPY */
#ifdef FASTCOPY
  #define gc_memcpy  memcpy   /* // memmove //memcpy  */
  #define gc_memmove memcpy   /* // memmove //memcpy  */
#else
unsigned int i_idx;
/*  static INLINE2 unsigned char* gc_memcpy(unsigned char* dst, unsigned char* src, size_t n)   */
#define gc_memmove gc_memcpy
static INLINE2 void gc_memcpy(unsigned char* dst, unsigned char* src, size_t n)
{
	/* g_src = src;         */
	/* g_dst = dst;         */
	/* unsigned int i;      */
	for (i_idx = 0; i_idx < n; ++i_idx)
		dst[i_idx] = src[i_idx];
	return; /*  dst;    */
}
#endif

#endif /* JOB_H_INCLUDED    */
