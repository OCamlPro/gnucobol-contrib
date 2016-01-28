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

#ifndef JOB_H_INCLUDED
#define JOB_H_INCLUDED


#include <stdio.h>
#include <stddef.h>
#include <stdint.h>

// linux 

//#ifndef _WIN32

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	#include <io.h>
#else
	#include <limits.h>
	#include <sys/io.h>
	#include <time.h>
	#include <fcntl.h>
#endif

#include "utils.h"
#include "mmfioc.h"

#define MAX_FILES_INPUT 16	// Number of max files in input for merge and temporary files

// future use #define EM_MFSORT 1	// Emulate MFSORT

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
#define SIZEINT				4
#define SIZEINT64			8

char	cob_tmp_buff[COB_MEDIUM_BUFF];
char	cob_tmp_temp[FILENAME_MAX];


struct job_t {

	int		ndeb; 
	int		nStatistics;
	struct file_t *outputFile;
	struct file_t *inputFile;
	char   szCmdLineCommand[8192];	// Copy from command line
	int    bIsTake;
	char   szTakeFileName[8192];	// Take FileName
	char   job_typeOP; // 'S' for sort, 'M' for Merge
	int	   array_FileTmpHandle[MAX_HANDLE_TEMPFILE];
	char   array_FileTmpName[MAX_HANDLE_TEMPFILE][FILENAME_MAX];
	int    nIndextmp;
	int    nIndextmp2;  
	int	   nNumTmpFile;
	char   arrayFileInCmdLine[256][FILENAME_MAX];
	int    nMaxFileIn;
	char   arrayFileOutCmdLine[256][FILENAME_MAX];
	int    nMaxFileOut;
	int    nCountSrt[MAX_HANDLE_TEMPFILE];
	int    nMaxHandle;
	int	   nCurrFileInput;
	int	   nByteOrder;							// 0 = Native - 1 = BigEndian
	struct sortField_t *sortField;
	struct condField_t *includeCondField;
	struct condField_t *omitCondField;
	struct condField_t *tmpCondField;
	struct outrec_t *outrec;
	struct inrec_t	*inrec;
	int		sumFields;
	struct SumField_t *SumField;
	int		bIsFieldCopy;		// SORT-MERGE FIELDS=COPY
	int64_t		recordNumberTotal;
	int64_t		recordWriteSortTotal;
	int64_t		recordWriteOutTotal;
	int64_t		file_length;
	int64_t recordNumber;
	int64_t recordNumberAllocated;
	unsigned char*  recordData;
	unsigned char*  buffertSort;
	struct BufferedReader_t* reader;
	int	m_SeekOrder;
	unsigned int inputLength;
	unsigned int outputLength;
	int nLastPosKey;
	int bReUseSrtFile;
	int64_t	lPositionFile;		// File pointer position 
	int64_t	lPosAbsRead;
	int64_t	ulMemSizeRead;		// Current size mem after read
	int64_t	ulMemSizeSort;
	int64_t	ulMemSizeAlloc;		// Max size mem 
	int64_t	ulMemSizeAllocSort;		// Max size mem 
	char    strPathTempFile[FILENAME_MAX]; // path temporary file
	int		bIsPresentSegmentation;		// File segmentation
	int     desc;
	int     nLenKeys;
	unsigned long   LenCurrRek;
	int		nTypeEmul;		// 0 stardard OC, 1 emulate MFSORT
	int		nTestCmdLine;	// 0 normal, 1 test command line
	// int		nSlot;
	int		nMlt;
	int64_t	nSkipRec;
	int64_t	nStopAft;
// Outfil
	struct outfil_t*	outfil;
	int		nOutfil_Split;		// Flag for split
	int     nOutfil_Copy;		// Flag for copy
	struct outfil_t*	pLastOutfil_Split;
	struct outfil_t*	pSaveOutfil;

// Option
	int		nVLSCMP;   // 0 disabled , 1 = enabled -- temporarily replace any missing compare field bytes with binary zeros
	int		nVLSHRT;   // 0 disabled , 1 = enabled -- treat any comparison involving a short field as false

};

struct job_t *globalJob;

struct job_t *job_constructor( void );
void job_destructor(struct job_t *job);
int job_destroy(struct job_t *job);
int job_load(struct job_t *job, int argc, char **argv);
int job_check(struct job_t *job);
int job_loadFiles(struct job_t *job);
int job_sort(struct job_t *job);
int job_save_out(struct job_t *job);
int job_save_tempfile(struct job_t *job);
int job_save_tempfinal(struct job_t *job);

INLINE int job_ReadFileTemp(struct mmfio_t* descTmp, int* nLR, unsigned char* szBuffRek, int nFirst);

int job_print(struct job_t *job);
int job_GetTypeOp(struct job_t *job);

INLINE int job_GetKeys(const void *szBufferIn, void *szKeyOut);
int job_GetLenKeys( void );
int job_GetLastPosKeys( void);

INLINE int job_IdentifyBuf(unsigned char** ptrBuf, int nMaxEle);
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
int	job_FileInputBuffer (struct job_t *job, char* szSearch, char* bufnew, int nPosStart);
int	job_FileOutputBuffer (struct job_t *job, char* szSearch, char* bufnew, int nPosStart);
int job_PutIntoArrayFile(char* pszBufOut, char* pszBufIn, int nLength);
int job_RedefinesFileName( struct job_t *job); 
int job_NormalOperations(struct job_t *job);
int job_CloneFileForOutfil( struct job_t *job);

int	job_scanCmdSpecialChar(char* bufnew);
int	job_RescanCmdSpecialChar(char* bufnew);
// int GetHeaderInfo(struct job_t* job, unsigned char* szHead);
// int SetHeaderInfo(struct job_t* job, unsigned char* szHead);

void job_ReviewMemeAlloc ( struct job_t *job  );
INLINE int64_t utils_GetValueRekBIFI(unsigned char* pRek, int nLenField, int nType);

INLINE int job_compare_key(const void *first, const void *second);
INLINE int job_compare_rek(const void *first, const void *second, int bCheckPosPnt);
INLINE int job_compare_qsort(const void *first, const void *second);

INLINE int job_IdentifyBufMerge(unsigned char** ptrBuf, int nMaxElements);
INLINE int job_ReadFileMerge(struct BufferedReader_t * reader, struct file_t* file, int* descTmp, int* nLR, unsigned char* szBuffRek, int nFirst);
INLINE int read_textfile_buff(int nHandle, unsigned char* szBuffRek, int nMaxRek, struct BufferedReader_t * reader, int bIsFirstTime, int nLastPosKey);
INLINE int job_write_output( unsigned int nLenRecOut, unsigned int nLenRek, struct job_t* job, int desc, int nSplitPosPnt, unsigned char* recordBuffer, unsigned char* bufferwriteglobal, int* position_buf_write);

#endif // JOB_H_INCLUDED
