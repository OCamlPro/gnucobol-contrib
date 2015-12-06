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

#ifndef JOB_H_INCLUDED
#define JOB_H_INCLUDED

#include <io.h>
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>

#ifdef _MSC_VER
  #define INLINE __forceinline /* use __forceinline (VC++ specific) */
#else
  #define INLINE inline        /* use standard inline */
#endif

#define MAX_FILES_INPUT 16	// Number of max files in input for merge

#define EM_MFSORT 1	// Emulate MFSORT

struct file_t;
struct sortField_t;
struct condField_t;
struct outrec_t;
struct inrec_t;
struct SumField_t;

struct job_t;
/**/
static const unsigned char packed_bytes[] = {
	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,
	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,
	0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29,
	0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
	0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
	0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
	0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
	0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
	0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
	0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99
};
/**/

#define	COB_FILE_BUFF		4096
#define	COB_MEDIUM_BUFF		8192
#define	COB_LARGE_BUFF		16384
#ifndef _WIN32
	#define MAX_PATH1       MAX_PATH
#else
	#define MAX_PATH1       FILENAME_MAX
#endif
#define MAX_RECSIZE			32752 

#define	MAX_SIZE_CACHE_WRITE		65536*62
#define	MAX_SIZE_CACHE_WRITE_FINAL	65536*62
//#define MAX_READSAVE			4096

#define  MAX_HANDLE_TEMPFILE	16

char	cob_tmp_buff[COB_MEDIUM_BUFF];
char	cob_tmp_temp[MAX_PATH1];


struct job_t {

	int		ndeb; 
	int		nStatistics;
	struct file_t *outputFile;
	struct file_t *inputFile;
	char   szCmdLineCommand[8192];	// Copy from command line
	char   job_typeOP; // 'S' for sort, 'M' for Merge
	int	   array_FileTmpHandle[MAX_HANDLE_TEMPFILE];
	char   array_FileTmpName[MAX_HANDLE_TEMPFILE][MAX_PATH1];
	int    nIndextmp;
	int    nIndextmp2;  
	int	   nNumTmpFile;
	char   arrayFileInCmdLine[256][MAX_PATH1];
	int    nMaxFileIn;
	char   arrayFileOutCmdLine[256][MAX_PATH1];
	int    nMaxFileOut;
	int    nCountSrt[MAX_HANDLE_TEMPFILE];
	int    nMaxHandle;
	struct sortField_t *sortField;
	struct condField_t *includeCondField;
	struct condField_t *omitCondField;
	struct outrec_t *outrec;
	struct inrec_t	*inrec;
	int sumFields;
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
	int			m_SeekOrder;
	int inputLength;
	int outputLength;
	int nLastPosKey;
	int bReUseSrtFile;
	int64_t	lPositionFile;		// File pointer position 
	int64_t	lPosAbsRead;
	int64_t	ulMemSizeRead;		// Current size mem after read
	int64_t	ulMemSizeSort;
	int64_t	ulMemSizeAlloc;		// Max size mem 
	int64_t	ulMemSizeAllocSort;		// Max size mem 
	char   strPathTempFile[MAX_PATH1]; // path temporary file
	int				bIsPresentSegmentation;		// File segmentation
	int             desc;
	int             nLenKeys;
	unsigned long   LenCurrRek;
	int		nTypeEmul;		// 0 stardard OC, 1 emulate MFSORT
	int		nTestCmdLine;	// 0 normal, 1 test command line
	int		nSlot;
	int		nMlt;
	int		nSkipRec;
	int		nStopAft;
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
int job_save(struct job_t *job);
int job_merge(struct job_t *job);
int job_save_final(struct job_t *job);

INLINE int job_ReadFileCobStr(struct BufferedReader_t * reader, int* descTmp, int* nLR, unsigned char* szBuffRek, int** ptrBuf, int nFirst);
int job_print(struct job_t *job);
int job_GetTypeOp(struct job_t *job);

INLINE int job_GetKeys(const void *szBufferIn, void *szKeyOut);
int job_GetLenKeys( void );
int job_GetLastPosKeys( void);

INLINE int job_IdentifyBuf(int* ptrBuf, int nMaxEle);
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

int job_SetOptionSort(char* optSort);
int job_SetOptionSortNum(char* optSort, int nNum);

int	job_scanCmdSpecialChar(char* bufnew);
int	job_RescanCmdSpecialChar(char* bufnew);
int GetHeaderInfo(struct job_t* job, unsigned char* szHead);
int SetHeaderInfo(struct job_t* job, unsigned char* szHead);

void job_ReviewMemeAlloc ( struct job_t *job  );

INLINE int job_compare_key(const void *first, const void *second);
INLINE int job_compare_rek(const void *first, const void *second);
INLINE int job_compare_qsort(const void *first, const void *second);

int job_IdentifyBufMerge(int* ptrBuf, int nMaxElements);
int job_ReadFileMerge(struct BufferedReader_t * reader, struct file_t* file, int* descTmp, int* nLR, unsigned char* szBuffRek, int** ptrBuf, int nFirst);
int read_textfile_buff(int nHandle, unsigned char* szBuffRek, int nMaxRek, struct BufferedReader_t * reader, int bIsFirstTime, int nLastPosKey);


#endif // JOB_H_INCLUDED
