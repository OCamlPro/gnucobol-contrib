/*
    Copyright (C) 2016-2017 Sauro Menna
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
// linux 

//#ifndef _WIN32

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	#include <io.h>
	#define _strtoll    _strtoi64
#else
	#include <limits.h>
	#include <sys/io.h>
	#include <time.h>
	#include <fcntl.h>
	#define _strtoll   strtoll
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
#define SIZEINT				sizeof(int)     // 4
#define SIZEINT64			sizeof(int64_t) // 8

#define SZPOSPNT            SIZEINT64
#define SZLENREC            SIZEINT
#define SZPNTDATA           SIZEINT64
#define SIZESRTBUFF         SIZEINT64+SIZEINT+SIZEINT64



#define	MAX_SIZE_CACHE_WRITE		65536*62 //65536*62*2   //62
#define	MAX_SIZE_CACHE_WRITE_FINAL	65536*62 //65536*62*2   //62

#define MAXFILEIN 100

char	cob_tmp_buff[COB_MEDIUM_BUFF];
char	cob_tmp_temp[FILENAME_MAX];


struct job_t {
//-->>	char arrayFileInCmdLine[256][FILENAME_MAX];
//-->>		char arrayFileOutCmdLine[256][FILENAME_MAX];
	char arrayFileInCmdLine[MAXFILEIN][FILENAME_MAX];
    char arrayFileOutCmdLine[MAXFILEIN][FILENAME_MAX];
	char array_FileTmpName[MAX_HANDLE_TEMPFILE][FILENAME_MAX];
	char job_typeOP;				// 'S' for sort, 'M' for Merge
	char strPathTempFile[FILENAME_MAX]; // path temporary file
	char szCmdLineCommand[8192];	// Copy from command line
	char szTakeFileName[8192];	// Take FileName
	int	 array_FileTmpHandle[MAX_HANDLE_TEMPFILE];
	int	 bIsFieldCopy;		// SORT-MERGE FIELDS=COPY
	int	 bIsPresentSegmentation;		// File segmentation
	int	 m_SeekOrder;
	int	 nCurrFileInput;
	int	 nMlt;
	int	 nNumTmpFile;
	int	 nStatistics;
	int	 nTestCmdLine;	// 0 normal, 1 test command line
	int	 nTypeEmul;		// 0 stardard OC, 1 emulate MFSORT
// Option
	int	 nVLSCMP;   // 0 disabled , 1 = enabled -- temporarily replace any missing compare field bytes with binary zeros
	int	 nVLSHRT;   // 0 disabled , 1 = enabled -- treat any comparison involving a short field as false
	int	 ndeb; 
	int	 sumFields;
	int  bIsTake;
	int  bReUseSrtFile;
	int  nCountSrt[MAX_HANDLE_TEMPFILE];
	int  nIndextmp2;  
	int  nIndextmp;
	int  nLastPosKey;
	int  nLenKeys;
	int  nMaxFileIn;
	int  nMaxFileOut;
	int  nMaxHandle;
	int64_t	file_length;
	int64_t	lPosAbsRead;
	int64_t	nSkipRec;
	int64_t	nStopAft;
	int64_t	recordNumberTotal;
	int64_t	recordWriteOutTotal;
	int64_t	recordWriteSortTotal;
	int64_t	ulMemSizeAlloc;		// Max size mem 
	int64_t	ulMemSizeAllocSort;		// Max size mem 
	int64_t	ulMemSizeRead;		// Current size mem after read
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
// Outfil
	struct outfil_t*	outfil;
	struct outfil_t*	pLastOutfil_Split;
	struct outfil_t*	pSaveOutfil;

	struct outrec_t*    outrec;
	struct sortField_t* sortField;
	unsigned char*  buffertSort;
	unsigned char*  recordData;
	unsigned int inputLength;
	unsigned int ncob_varseq_type;		// 0   means 2 byte record length (big-endian),			1   means 4 byte record length (big-endian)        
	                                 	// 2   means 4 byte record length (local machine int),  3   means 2 byte record length (local machine short)
	unsigned int outputLength;
	unsigned long   LenCurrRek;
};

struct job_t *globalJob;

struct job_t *job_constructor( void );
void job_destructor(struct job_t *job);
int job_destroy(struct job_t *job);
int job_sort(struct job_t* job);
int job_load(struct job_t *job, int argc, char **argv);
int job_check(struct job_t *job);
int job_loadFiles(struct job_t *job);
int job_sort_data(struct job_t *job);
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
int	job_FileInputBuffer (struct job_t *job, char* szBuffIn, char* bufnew, int nPosStart);
int	job_FileOutputBuffer (struct job_t *job, char* szBuffIn, char* bufnew, int nPosStart);
int job_PutIntoArrayFile(char* pszBufOut, char* pszBufIn, int nLength);
int job_RedefinesFileName( struct job_t *job); 
int job_NormalOperations(struct job_t *job);
int job_CloneFileForOutfil( struct job_t *job);
void job_CloneFileForOutfilSet(struct job_t *job, struct file_t* file);
int job_set_area (struct job_t* job, struct file_t* file, unsigned char* szBuf, int nLen );
int	job_scanCmdSpecialChar(char* bufnew);
int	job_RescanCmdSpecialChar(char* bufnew);
void job_SetRecLen(struct job_t *job, int recordsize, unsigned char* szHR);
void job_ReviewMemeAlloc ( struct job_t *job  );

void job_getTypeFlags (int nTypeField, int* nType, int* nFlags );

INLINE int job_compare_key(const void *first, const void *second);
INLINE int job_compare_rek(const void *first, const void *second, int bCheckPosPnt);
INLINE int job_compare_qsort(const void *first, const void *second);

INLINE int job_IdentifyBufMerge(unsigned char** ptrBuf, int nMaxElements);
INLINE int job_ReadFileMerge(struct file_t* file, int* descTmp, int* nLR, unsigned char* szBuffRek, int nFirst);
cob_field* job_cob_field_create ( void );
void job_cob_field_set (cob_field* field_ret, int type, int digits, int scale, int flags, int nLen);
void job_cob_field_destroy ( cob_field* field_ret);
void job_print_error_file(cob_file* stFileDef, int nLenRecOut);

static INLINE int write_buffered (int		desc, 
						   unsigned char*	buffer_pointer, 
						   int				nLenRek, 
						   unsigned char**	bufferwriteglobal,
						   int*				position_buf_write
						  )
{
	int nSplit;
    int tempPosition = *position_buf_write + nLenRek;  
    if (tempPosition > MAX_SIZE_CACHE_WRITE) {
		if (_write(desc, (unsigned char*)(*bufferwriteglobal), (unsigned int) *position_buf_write) < 0) 
		{
    		fprintf(stderr,"*GCSORT*S090*ERROR: Cannot write output file  %s\n",strerror(errno));
    		return -1;
		}
    	*position_buf_write=0;
    }
	nSplit = *position_buf_write;
	memmove((unsigned char*)(*bufferwriteglobal+nSplit), (unsigned char*)buffer_pointer, nLenRek);
   *position_buf_write=*position_buf_write+nLenRek;
    return 0;
}

static INLINE int write_buffered_save_final (int		desc, 
									 unsigned char*		buffer_pointer, 
										     int		nLenRek, 
								    unsigned char**		bufferwriteglobal,
											 int*		position_buf_write
											)
{
    if (*position_buf_write + nLenRek > MAX_SIZE_CACHE_WRITE_FINAL) {
    	if (_write(desc, (unsigned char*)(*bufferwriteglobal), (unsigned int) *position_buf_write) < 0) 
    	{
    		fprintf(stderr,"*GCSORT*S091*ERROR: Cannot write output file  %s\n",strerror(errno));
    		return -1;
    	}
    	*position_buf_write=0;
    }
	memmove((unsigned char*)(*bufferwriteglobal+(*position_buf_write)), (unsigned char*)buffer_pointer, nLenRek);
   *position_buf_write=*position_buf_write+nLenRek;
    return 0;
}

static INLINE int write_buffered_final (int  desc, 
						unsigned char**  bufferwriteglobal,
						int*	position_buf_write
					)
{
	if (*position_buf_write == 0)
		return 0;
    if (write(desc, (unsigned char*)*bufferwriteglobal , *position_buf_write) < 0) 
    {
    	fprintf(stderr,"*GCSORT*S092*ERROR: Cannot write output file  %s\n",strerror(errno));
    	return -1;
    }
	*position_buf_write=0;
    return 0;
}


#endif // JOB_H_INCLUDED
