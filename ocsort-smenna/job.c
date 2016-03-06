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
 
#include <sys/stat.h>
#include <malloc.h>
#include <time.h>
#include <ctype.h>

#include "libocsort.h"

//#ifdef	_WIN32
#if defined(_MSC_VER) ||  defined(__MINGW32__) || defined(__MINGW64__)
	#include <share.h>
	#include <fcntl.h> 
	#include <process.h>
	#include <windows.h>
#endif


#include <string.h>
#include <stddef.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include "ocsort.h"
#include "utils.h"
#include "job.h"
#include "file.h"
#include "sortfield.h"
#include "condfield.h"
#include "outrec.h"
#include "inrec.h"
#include "parser.h"
#include "scanner.h"
#include "sortfield.h"
#include "sumfield.h"

#include "outfil.h"
#include "mmfioc.h"

#include "bufferedreader.h"
#include "bufferedwriter.h"

#define _CRTDBG_MAP_ALLOC
#include <stdlib.h>

#ifdef _MSC_VER
	#include <crtdbg.h>
#endif
 

int g_lenRek = -1;
int nTypeFieldsCmd = 0;
unsigned char    szBufPK1[128];
unsigned char    szBufPK2[128];
unsigned int     SPK1, SPK2, SPK1x, SPK2x;
int 	bIsNegSPK1;
int 	bIsNegSPK2;
int64_t lPosA = 0;
int64_t lPosB = 0;
int64_t n64Tmp1 = 0;
int64_t n64Tmp2 = 0;
char*	pEnd;

int64_t	n64Var;
unsigned char ucSignField;
unsigned char szBufBIFI[32];



int result=0;
struct sortField_t *sortField;
int nSp=0;

char szHeaderOutMF[128];
long nSpread = 0;

int	nLenMemory=0;

HANDLE hEvent1, hEvent2;
void sort_temp_name(const char * ext);
int yyparse ( void );

extern int job_compare_key(const void *first, const void *second);

void job_SetCmdLine(struct job_t* job, char* strLine)
{
	// attention
	// check characters special  0x09
	int n=0;
	for (n=0; strLine[n] > 0x00;n++) {
		if (strLine[n] == 0x09)
			strLine[n] = ' ';
	}
	strcpy(job->szCmdLineCommand, strLine);
}

char* job_GetCmdLine(struct job_t* job)
{
	return job->szCmdLineCommand;
}

int job_SetTypeOP (char typeOP)
{
	globalJob->job_typeOP = typeOP;
	return 0;
}

int job_SetFieldCopy (int nFC)
{
	globalJob->bIsFieldCopy = nFC;
	return 0;
}

int job_GetFieldCopy ( void )
{
	return globalJob->bIsFieldCopy;
}

int job_EmuleMFSort( void ) {
	return globalJob->nTypeEmul;
}


struct job_t *job_constructor( void ) {
	struct job_t *job=(struct job_t *)malloc(sizeof(struct job_t));

	char* pEnvMemSize;
	char* pEnvEmule;
	char chPath[FILENAME_MAX];

	int nOp;
	int nJ=0;

	job->ndeb = 0;
	job->nStatistics=1;
	job->outputFile=NULL;
	job->inputFile=NULL;
	job->sortField=NULL;
	job->includeCondField=NULL;
	job->omitCondField=NULL;
	job->tmpCondField=NULL;
	job->outrec=NULL;
	job->inrec=NULL;
	job->sumFields=0;
	job->SumField=NULL;
	job->reader=NULL;
	job->recordNumberTotal=0;
	job->recordWriteSortTotal=0;
	job->recordWriteOutTotal=0;
	job->recordNumber=0;
	job->recordNumberAllocated=0;
	job->bIsFieldCopy=0;
	job->recordData=NULL;
	job->buffertSort= NULL;
	job->inputLength=0;
	job->outputLength=0;
	job->m_SeekOrder=0;
	job->nNumTmpFile=0;
	job->nCurrFileInput=-1;
	job->bReUseSrtFile = 0;
	job->lPosAbsRead=0;
	job->lPositionFile=0;
	job->ulMemSizeRead=0;
	job->bIsPresentSegmentation=0;
	job->nIndextmp  = 0;
	job->nIndextmp2 = 0;
	job->nMaxHandle = 0;
	job->nByteOrder = 0;
	memset(job->array_FileTmpHandle, -1, sizeof(job->array_FileTmpHandle));
	for (nJ=0; nJ < MAX_HANDLE_TEMPFILE; nJ++)
		job->nCountSrt[nJ]=0;
	job->nSkipRec=0;
	job->nStopAft=0;
	job->strPathTempFile[0]=0x00; //NULL;
	memset(job->arrayFileInCmdLine, 0x00, (256*FILENAME_MAX));
	memset(job->szTakeFileName, 0x20, sizeof(job->szTakeFileName));
	job->bIsTake=0;
	job->nMaxFileIn=0;
	memset(job->arrayFileOutCmdLine, 0x00, (256*FILENAME_MAX));
	job->nMaxFileOut=0;
	job->ulMemSizeAlloc		= OCSORT_ALLOCATE_MEMSIZE;
	job->ulMemSizeAllocSort = OCSORT_ALLOCATE_MEMSIZE/100*10;		// 
	job->nLastPosKey = 0;	// Last position of key
	job->nTestCmdLine=0;
	//job->nSlot = MAX_SLOT_SEEK;
	job->nMlt  = MAX_MLTP_BYTE;
// verify Environment variable for emulation
// 0 = OCSORT normal operation
// 1 = OCSORT emulates MFSORT 
/*
	pEnvEmule = getenv ("OCSORT_EMULATE");
	if (pEnvEmule!=NULL)
	{
		job->nTypeEmul = atol(pEnvEmule);
		if ((job->nTypeEmul != 0) && (job->nTypeEmul != 1)){
				fprintf(stderr,"OCSORT - Error on OCSORT_EMULATE parameter. Value 0 for OCSORT, 1 for MF Emulator, 2 for DFSort. Value Environment%ld\n", job->nTypeEmul );
				fprintf(stderr,"OCSORT - Forcing  OCSORT_EMULATE = 0\n");
				job->nTypeEmul = 0;
		}
	}
*/
// verify Environment variable for memory allocation
	pEnvMemSize = getenv ("OCSORT_MEMSIZE");
	if (pEnvMemSize!=NULL)
	{
		job->ulMemSizeAlloc = atol(pEnvMemSize);
		if (job->ulMemSizeAlloc == 0) {
			job->ulMemSizeAllocSort = OCSORT_ALLOCATE_MEMSIZE/100*10;
			job->ulMemSizeAlloc = OCSORT_ALLOCATE_MEMSIZE - job->ulMemSizeAllocSort;
		} 
		else
		{
			job->ulMemSizeAllocSort = job->ulMemSizeAlloc/100*10;
			job->ulMemSizeAlloc = job->ulMemSizeAlloc - job->ulMemSizeAllocSort ;
		}
	}

	pEnvEmule = getenv ("OCSORT_TESTCMD");
	if (pEnvEmule!=NULL)
	{
		job->nTestCmdLine = atol(pEnvEmule);
		if ((job->nTestCmdLine != 0) && (job->nTestCmdLine != 1)){
				fprintf(stderr,"OCSORT - Error on OCSORT_TESTCMD parameter. Value 0 for normal operations , 1 for ONLY test command line. Value Environment: %d\n", job->nTestCmdLine );
				fprintf(stderr,"OCSORT - Forcing  OCSORT_TESTCMD = 0\n");
				job->nTestCmdLine = 0;
		}
	}
	pEnvEmule = getenv ("OCSORT_STATISTICS");
	if (pEnvEmule!=NULL)
	{
		job->nStatistics = atol(pEnvEmule);
		if ((job->nStatistics != 0) && (job->nStatistics != 1) && (job->nStatistics != 2)){
				fprintf(stderr,"OCSORT - Error on OCSORT_STATISTICS parameter. Value 0 for suppress info , 1 for Sumamry, 2 for Details. Value Environment: %d\n", job->nStatistics);
				fprintf(stderr,"OCSORT - Forcing  OCSORT_STATISTICS = 0\n");
				job->nStatistics = 1;
		}
	}
	pEnvEmule = getenv ("OCSORT_DEBUG");
	if (pEnvEmule!=NULL)
	{
		job->ndeb = atol(pEnvEmule);
		if ((job->ndeb != 0) && (job->ndeb != 1) && (job->ndeb != 2)){
				fprintf(stderr,"OCSORT - Error on OCSORT_DEBUG parameter. Value 0 for normal operations , 1 for DEBUG, 2 for DEBUG Parser. Value Environment: %d\n", job->nTestCmdLine );
				fprintf(stderr,"OCSORT - Forcing  OCSORT_DEBUG = 0\n");
				job->ndeb= 0;
		}
		else
		{
			//-->>yydebug=job->ndeb; 
			if (job->ndeb == 1) {
				yyset_debug(0);	
			}
			if (job->ndeb == 2) {
				yydebug=1; 
				yyset_debug(2);	
			}
		}
	}

	pEnvEmule = getenv ("OCSORT_PATHTMP");
	if (pEnvEmule!=NULL)
	{
		strcpy(job->strPathTempFile, pEnvEmule);
		strcpy(chPath, job->strPathTempFile);

		if (chPath[strlen(chPath)-1] != charSep)
			strcat(chPath, (const char*) strSep);
	
		strcat(chPath, "OCSRTTMP.TMP");
		nOp=remove(chPath);
		nOp=open(chPath, O_CREAT | O_WRONLY | O_BINARY | _O_TRUNC,  _S_IREAD | _S_IWRITE);
		if (nOp<0){
			fprintf(stderr, "OCSORT Warning : Path not found %s\n", job->strPathTempFile);
		}
		else 
		{
			close(nOp);
			remove(chPath);
		}
	}

//
/*
	pEnvEmule = getenv ("OCSORT_SLOT");
	if (pEnvEmule!=NULL)
	{
		job->nSlot = atol(pEnvEmule);
		if (job->nSlot > MAX_SLOT_SEEKENV) {
				fprintf(stderr,"OCSORT - Error on OCSORT_SLOT parameter. Value major of MAX_SLOT_SEEK. Value Environment - MAX_SLOT_SEEK: %ld-%ld\n", job->nSlot, MAX_SLOT_SEEKENV );
				fprintf(stderr,"OCSORT - Force MAX_SLOT_SEEK\n");
				job->nSlot= MAX_SLOT_SEEK;
		}
	}
*/
	pEnvEmule = getenv ("OCSORT_MLT");
	if (pEnvEmule!=NULL)
	{
		job->nMlt = atol(pEnvEmule);
	}

	pEnvEmule = getenv ("OCSORT_BYTEORDER");
	if (pEnvEmule!=NULL)
	{
		job->nByteOrder = atol(pEnvEmule);
		if ((job->nByteOrder != 0) && (job->nByteOrder != 1)){
				fprintf(stderr,"OCSORT - Error on OCSORT_BYTEORDER parameter. Value 0 for Native , 1 for BigEndian. Value Environment: %d\n", job->nByteOrder );
				fprintf(stderr,"OCSORT - Forcing  OCSORT_BYTEORDER = 0\n");
				job->nByteOrder = 0;
		}
	}


// Outfil
	job->nOutfil_Split=0;		// Flag for split
	job->nOutfil_Copy=0;		// Flag for copy
	job->outfil=NULL;
	job->pLastOutfil_Split = NULL;
	job->pSaveOutfil = NULL;
// Option
	job->nVLSCMP = 0;   // 0 disabled , 1 = enabled -- temporarily replace any missing compare field bytes with binary zeros
	job->nVLSHRT = 0;   // 0 disabled , 1 = enabled -- treat any comparison involving a short field as false
//
	return job;
}
void job_destructor(struct job_t *job) {

	if (job->recordData != NULL) {
		free(job->recordData);
		job->recordData=NULL;
	}

	if (job->buffertSort != NULL) {
		free(job->buffertSort);
		job->buffertSort=NULL;
	}
	free(job);
}

void job_ReviewMemeAlloc ( struct job_t *job  ) {

	double  nLenKey = job_GetLenKeys();
	double  nLenRek = job->inputLength;
	double  nPerc = (nLenKey + SIZEINT64 + SIZEINT + SIZEINT64 ) / nLenRek * 100;
	// in the case where nLenRek too big or too small
	if (nPerc > 50)
		nPerc = 50;
	if (nPerc < 15) 
		nPerc = 15;
	job->ulMemSizeAllocSort = (job->ulMemSizeAlloc*(int64_t)nPerc)/100;
	job->ulMemSizeAlloc = job->ulMemSizeAlloc - job->ulMemSizeAllocSort;

	return;
}


int job_load(struct job_t *job, int argc, char **argv) {
	int i;
	int bufferLength=0;
	int argvLength;
	char *buffer=NULL;
	int returnCode;
	int nTakeCmd = 0;
	char szTakeFile[FILENAME_MAX];
	char bufnew[COB_MEDIUM_BUFF];

	globalJob=job;
 	buffer=(char *) malloc(COB_MEDIUM_BUFF);	// COmmandLine
	if (buffer == 0)
 		fprintf(stderr,"*OCSort*S001* Cannot Allocate buffer : %s\n", strerror(errno));
	memset(buffer, 0x00, COB_MEDIUM_BUFF);
	//  controllo del token TAKE Filename
	for (i=1;i<argc;i++) {
		if (argv[i]!=NULL) {
			//
			if (nTakeCmd == 1) {
				strcpy(szTakeFile, argv[i]);
				strcpy(job->szTakeFileName, szTakeFile);
				job->bIsTake = 1;
			}
			if (strcmp(argv[i], "TAKE")== 0) 
				nTakeCmd = 1;
			//
			argvLength=strlen(argv[i])+1;
			if (bufferLength+argvLength+1 > COB_MEDIUM_BUFF)	
				buffer=(char *)realloc(buffer,bufferLength+argvLength+1);
			buffer[bufferLength]=' ';
			// controllo se i parametri sono raggruppati tra doppi apici (2° parametro riga comando)
			strcpy(buffer+bufferLength+1,argv[i]);
			bufferLength+=argvLength;
		}
	}
	if (buffer==NULL) {
		fprintf(stderr,"No parameter\n");
		return -1;
	}

	if (nTakeCmd == 1) {   // Take command present
		buffer=(char *)realloc(buffer, 10240); // allocate 
		memset(buffer, 0x00, 10240);
		job_MakeCmdLine(szTakeFile, buffer);
	}

	job_SetCmdLine(job, buffer);
	
	if (0==1) // version normal
	{
		yy_scan_string(buffer);
		returnCode=yyparse();
	}
	else
	{  // version with modify name
		if (job_scanCmdLineFile(job, buffer, bufnew) != -1) {
			job_scanCmdSpecialChar(bufnew);  
			yy_scan_string(bufnew);
			returnCode=yyparse();
			if (returnCode == 0)
				returnCode = job_RedefinesFileName(job); 
		} 
		else
		{
			fprintf(stderr, "\nMissing Command USE or GIVE\n");
		}
	}



//new	
	if (returnCode != 0)
	{
		fprintf(stdout,"==============================================================================\n");
		fprintf(stdout,"SORT ERROR \n");
		//printf("Command line : %s\n", buffer);
		fprintf(stdout,"==============================================================================\n");
		fprintf(stdout,"\n");
	}

//-->>	
	yylex_destroy ();

// 
// Clone informations from GIVE File for all OUTFIL files.
	if (returnCode == 0)
		returnCode = job_CloneFileForOutfil(job); 
//
	if (returnCode != 0){
		fprintf(stdout,"SORT ERROR \n");
		fprintf(stdout,"Command line : %s\n", buffer);
		fprintf(stdout,"\n");
	}
//
	free(buffer);

	return returnCode;
}

int job_CloneFileForOutfil( struct job_t *job) {

	struct file_t *file;
	struct outfil_t *outfil;
	struct file_t *fileJob;

	fileJob = job->outputFile;

	if ((job->outfil != NULL) && (fileJob != NULL)){
		if (job->outfil->outfil_File == NULL){
			file = (struct file_t*) file_constructor(fileJob->name);
			file->format=fileJob->format;
			file->organization=fileJob->organization;
			file->recordLength=fileJob->recordLength;
			file->maxLength=fileJob->maxLength;
			file->pHeaderMF=NULL;
			file->bIsSeqMF =fileJob->bIsSeqMF;
			file->nFileMaxSize=fileJob->nFileMaxSize;
			file->next=NULL;	
			job->outfil->outfil_File = file;
		}
		else
		{
			for (outfil=job->outfil; outfil!=NULL; outfil=outfil_getNext(outfil)) {
				for (file=outfil->outfil_File; file!=NULL; file=file_getNext(file)) {
					file->format = fileJob->format;
					file->organization = fileJob->organization ;
					file->recordLength = fileJob->recordLength ;
					file->maxLength = fileJob->maxLength ;
					file->bIsSeqMF = fileJob->bIsSeqMF ;
				}
			}
		}
	}
	return 0;
}
int job_RedefinesFileName( struct job_t *job) 
{
	struct file_t *file;
	int nPos=-1;
	if (job->inputFile!=NULL) {
		for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
			nPos++;
			if (nPos > job->nMaxFileIn) {
					fprintf(stderr,"*OCSort*S084* ERROR: Problem with file name input %s, %s, %d\n",job->inputFile->name, job->arrayFileInCmdLine[nPos], nPos--);
					return -1;
			}
			free(file->name);
			file->name = strdup(job->arrayFileInCmdLine[nPos]);
		}
	}
	nPos=-1;
	if (job->outputFile!=NULL) {
		for (file=job->outputFile; file!=NULL; file=file_getNext(file)) {
			nPos++;
			if (nPos > job->nMaxFileOut) {
					fprintf(stderr,"*OCSort*S085* ERROR: Problem with file name output %s, %s, %d\n",job->outputFile->name, job->arrayFileOutCmdLine[nPos], nPos--);
					return -1;
			}
			free(file->name);
			file->name = strdup(job->arrayFileOutCmdLine[nPos]);
		}
	}
	return 0;
}

int	job_scanPrioritySearch(char* buffer)
{
	char strUSE[]  = " USE ";
	char strGIVE[] = " GIVE ";
	char * pchUse  = NULL;
	char * pchGive = NULL;

	char*  pBufUpp;

	pBufUpp = (char*) malloc(sizeof(char)*(strlen(buffer) + 1));
	util_covertToUpper(buffer, pBufUpp);

	// Priority Search
	// USE ---- GIVE  or   GIVE --- USE

	pchUse	= strstr(pBufUpp, strUSE);
	pchGive = strstr(pBufUpp, strGIVE);


	if ((pchUse == NULL) || (pchGive == NULL))
		return -1;

	free(pBufUpp);
	if (pchUse <= pchGive)	
		return 0;			// Before USE, after GIVE
	return 1;				// Before GIVE, after USE
}


int	job_scanCmdLineFile(struct job_t *job, char* buffer, char* bufnew)
{
	char szSearch[COB_MEDIUM_BUFF+5];
	char szBufNew2[COB_MEDIUM_BUFF+5];
 	int  nSearchType = 0;
	int  nPosStart=0;
	int n=0;
	// copy buffer for first char of command for token find
	memset(szSearch, 0x00, COB_MEDIUM_BUFF+1);
	memset(bufnew,   0x00, COB_MEDIUM_BUFF);
	memset(szBufNew2, 0x00, COB_MEDIUM_BUFF+1);
	// problem with " USE "
	memset(szSearch, 0x20, 5);
	memcpy(szSearch+5, buffer, COB_MEDIUM_BUFF);

	for (n=0; szSearch[n] > 0x00;n++) {
		if (szSearch[n] == 0x09)
			szSearch[n] = ' ';
	}

	// -- only debug printf("\nCommand line input : %s\n", szSearch);

	nSearchType = job_scanPrioritySearch( szSearch );
	if (nSearchType == -1) 
		return -1;
	if (nSearchType == 0) {
		nPosStart = job_FileInputBuffer(job, szSearch, bufnew, nPosStart);
		strcpy(szBufNew2, bufnew);
		nPosStart = 0; // forzature
		memset(bufnew,   0x00, COB_MEDIUM_BUFF);
		job_FileOutputBuffer(job, szBufNew2, bufnew, nPosStart);
	}
	else
	{
		nPosStart = job_FileOutputBuffer(job, szSearch, bufnew, nPosStart);
		strcpy(szBufNew2, bufnew);
		nPosStart = 0; // forzature
		memset(bufnew,   0x00, COB_MEDIUM_BUFF);
		job_FileInputBuffer(job, szBufNew2, bufnew, nPosStart);
	}
	// -- only debug printf("\nNew Command Line : %s\n", bufnew);

	return 0;
}
int	job_scanCmdSpecialChar(char* bufnew)
{
	int nP = 0;
	int nB=0;
	do {
		// verify sequence '' 
		if ((bufnew[nP] == 0x27)) {
			nP++;
			nB=0;
			do {
				// insert special char for char '
				if ((bufnew[nP] == 0x27) && (bufnew[nP+1] == 0x27)) {
					bufnew[nP+0] = 0x1f;
					bufnew[nP+1] = 0x1f;
					nB=1;
				}
				if (bufnew[nP] == 0x27) { 
					break;
				}
				if (bufnew[nP] == 0x00)
					break;
				nP++;
			} while (1);
		}
		nP++;
	} while (bufnew[nP] != 0x00);
	return 0;
}

int	job_RescanCmdSpecialChar(char* bufnew)
{
	int nP = 0;
	int nN = 0;
	int nF = 0;
	char* pNewBuf = (char*) malloc(strlen(bufnew)+1);
	memset(pNewBuf, 0x00, strlen(bufnew)+1);
	do {
		// verify sequence ''
		if ((bufnew[nP] == 0x1f) && (bufnew[nP+1] == 0x1f)) {
			bufnew[nP+0] = 0x27;
			bufnew[nP+1] = 0x27;
			nF=1;
			pNewBuf[nN] = bufnew[nP];
			//-->> nP++;
		}
		if (nF == 1) {
			nF=0;
		}
		else
		{
			pNewBuf[nN] = bufnew[nP];
			nN++;
		}
		nP++;
	} while (bufnew[nP] != 0x00);
	strcpy(bufnew, pNewBuf);
	free(pNewBuf);
	return 0;
}


int job_PutIntoArrayFile( char* pszBufOut,  char* pszBufIn, int nLength)
{
	int nSplit=0;
	while(*pszBufIn == 0x20)	{
		pszBufIn++;
		nLength--;
	}
	while(*(pszBufIn+nLength-nSplit) == 0x20)	{
		nSplit++;
	}
	nSplit--;
	strncpy(pszBufOut, pszBufIn, nLength-nSplit);
	pszBufOut[nLength-nSplit] = 0x00;
	return nLength-nSplit;
}

int	job_FileInputBuffer (struct job_t *job, char* szBuffIn, char* bufnew, int nPosStart)
{
	char szFileName[1024];
	char strUSE[]  = " USE ";
	char strORG[] = " ORG ";
	char strRECORD[]  = " RECORD ";
	char * pch1;
	char * pch2;
	char * pch3;
	char * szSearch;
	int  nSp1=1;
	int  nSp2=0;
	int  nSp3=0;
	int  nFirstRound=0;
	int  pk=0;
	int  nPosNull=0;
	int  bFound = 0;
	// file input

	szSearch = (char*) malloc(sizeof(char)*(strlen(szBuffIn) + 1));
	util_covertToUpper(szBuffIn, szSearch);

	pch1=szSearch+nPosStart;
	pch2=szSearch+nPosStart;
	pch3=szSearch+nPosStart;
	job->nMaxFileIn=0;
	while (pch1 != NULL){
		pch1 = strstr (pch1, strUSE);
		if (pch1 != NULL){
			bFound = 1;
			nSp1 = pch1 - szSearch;
			if (nFirstRound == 1) {
				// strncat(bufnew, pch2, pch1-pch2 );
				strncat(bufnew, szBuffIn+(pch2-szSearch), pch1-pch2 );
				pch2 = pch2 + (pch1 - pch2);
			}
			pch2 = strstr (szSearch+nSp1-1, strORG);
			pch3 = strstr (szSearch+nSp1-1, strRECORD);
			if (pch3 == NULL){
				fprintf(stderr,"*OCSort*S203* ERROR : Command RECORD not found or lower case, use uppercase\n");
				exit(OC_RTC_ERROR);
			}

			nSp3 = sizeof(strORG);
			if (pch3 < pch2){
				pch2 = pch3;  // pch2 pointer to first element RECORD o GIVE
				nSp3 = strlen(strRECORD);
			}
			if (pch2 != NULL){
				nSp2 = pch2 - szSearch;
				if (nFirstRound == 0) {
					strncat(bufnew, szBuffIn, nSp1);
					nFirstRound=1;
				} 
				// in questo punto aggiungere il nome file 
				nSp2 = pch2 - pch1 - strlen(strUSE);
				//nPosNull = job_PutIntoArrayFile(job->arrayFileInCmdLine[job->nMaxFileIn], pch1+strlen(strUSE), nSp2);
				nPosNull = job_PutIntoArrayFile(job->arrayFileInCmdLine[job->nMaxFileIn], szBuffIn+(pch1-szSearch)+strlen(strUSE), nSp2);
				job->arrayFileInCmdLine[job->nMaxFileIn][nPosNull]=0x00;
				job->nMaxFileIn++;
				memset(szFileName, 0x00, 1024);
				sprintf(szFileName, " USE FI%03d", job->nMaxFileIn); // new file name
				// alloc same dimension of file input for string
				if (nSp2 > (int)(strlen(szFileName))) { 
					for (pk=strlen(szFileName); pk < nSp2;pk++)
						 szFileName[pk]='A';
				}
				strcat(bufnew,		szFileName);	// concat new file name
				pch1 = pch2 + nSp3;
			}
			else
			{
				fprintf(stderr,"*OCSort*S202* ERROR : Command ORG not found or lower case, use uppercase\n");
				exit(OC_RTC_ERROR);
			}
		}
		else
		{
			if (bFound == 0) {
				fprintf(stderr,"*OCSort*S201* ERROR : Command USE not found or lower case, use uppercase\n");
				exit(OC_RTC_ERROR);
			}
		}
	}
	if (job->nMaxFileIn <= 0) {
		fprintf(stderr,"*OCSort*S086* ERROR: Problem NO file input\n");
		free(szSearch);
		return -1;
	}
	if (pch2 != NULL)
//-->>		strcat(bufnew, pch2);
		strcat(bufnew, szBuffIn+(pch2-szSearch));
	free(szSearch);
	return (nSp1);
}


int	job_FileOutputBuffer (struct job_t *job, char* szBuffIn, char* bufnew, int nPosStart)

{
	char szFileName[1024];
	char strGIVE[]	 = " GIVE ";
	char strORG[]	 = " ORG ";
	char strRECORD[] = " RECORD ";
	char * pch1;
	char * pch2;
	char * pch3;
	int  nSp1=1;
	int  nSp2=0;
	int  nSp3=0;
	char * szSearch;
	int  nFirstRound=0;
	int  pk=0;
	int nPosNull = 0;
	int  bFound = 0;
	// file input

	szSearch = (char*) malloc(sizeof(char)*(strlen(szBuffIn) + 1));
	util_covertToUpper(szBuffIn, szSearch);

	pch1=szSearch+nPosStart;
	pch2=szSearch+nPosStart;
	pch3=szSearch+nPosStart;
	job->nMaxFileOut=0;
	while (pch1 != NULL){
		pch1 = strstr (pch1, strGIVE);
		if (pch1 != NULL){
			bFound = 1;
			nSp1 = pch1 - szSearch;
			if (nFirstRound == 1) {
				//strncat(bufnew, pch2, pch1-pch2 );
				strncat(bufnew, szBuffIn+(pch2-szSearch), pch1-pch2 );
				pch2 = pch2 + (pch1 - pch2);
			}
			pch2 = strstr (szSearch+nSp1-1, strORG);
			pch3 = strstr (szSearch+nSp1-1, strRECORD);
			nSp3 = sizeof(strORG);
			if (pch3 < pch2){
				pch2 = pch3;  // pch2 pointer to first element RECORD o GIVE
				nSp3 = strlen(strRECORD);
			}
			if (pch2 != NULL){
				nSp2 = pch2 - szSearch;
				if (nFirstRound == 0) {
					strncat(bufnew, szBuffIn, nSp1);
					nFirstRound=1;
				} 
				// 
				nSp2 = pch2 - pch1 - strlen(strGIVE);
				//nPosNull = job_PutIntoArrayFile(job->arrayFileOutCmdLine[job->nMaxFileOut],  pch1+strlen(strGIVE), nSp2);
				nPosNull = job_PutIntoArrayFile(job->arrayFileOutCmdLine[job->nMaxFileOut], szBuffIn+(pch1-szSearch)+strlen(strGIVE), nSp2);
				job->arrayFileOutCmdLine[job->nMaxFileOut][nPosNull] = 0x00;
				job->nMaxFileOut++;
				memset(szFileName, 0x00, 1024);
				sprintf(szFileName, " GIVE FO%03d", job->nMaxFileOut); // new file name
				// alloc same dimension of file input for string
				if (nSp2 > (int)(strlen(szFileName))) {
					for (pk=strlen(szFileName); pk < nSp2;pk++)
						szFileName[pk]='A';
				}
				strcat(bufnew,		szFileName);	// concat new file name
				pch1 = pch2 + nSp3;
			}
			else
			{
				fprintf(stderr,"*OCSort*S212* ERROR : Command ORG not found or lower case, use uppercase\n");
				exit(OC_RTC_ERROR);
			}
		}
		else
		{
			if (bFound == 0) {
				fprintf(stderr,"*OCSort*S211* ERROR : Command USE not found or lower case, use uppercase\n");
				exit(OC_RTC_ERROR);
			}
		}
	}
//			}
//		}
//	}
	if (job->nMaxFileOut <= 0) {
		fprintf(stderr,"*OCSort*S087* ERROR: Problem NO file output\n");
		free(szSearch);
		return -1; 
	}
	if (pch2 != NULL)
	//	strcat(bufnew, pch2);
		strcat(bufnew, szBuffIn+(pch2-szSearch));
	free(szSearch);
	return (nSp1);
}

int job_MakeCmdLine(char* szF, char* buf) 
{
	int numread, maxLen;
	int c;
	int nComm;
	int nNewLine;
	FILE *pFile;
	maxLen=0;
	nNewLine=1;

	if (globalJob->nStatistics > 0) {
		fprintf(stdout,"========================================================\n");
		fprintf(stdout,"OCSORT\nFile TAKE : %s\n", szF);
		fprintf(stdout,"========================================================\n");
	}
	if((pFile=fopen(szF, "rt"))==NULL) {
		fprintf(stderr, "\n*OCSort* ERROR Unable to open file %s", (char*)szF);
		exit(OC_RTC_ERROR); 
	}
	numread = 1;
	maxLen=-1;
	nComm=0;
	memset(buf, 0x00, sizeof (4096));
		do {
			  c = fgetc (pFile);
			  if( feof(pFile) )
				 break ;
			  printf("%c", c);
			  //-->>if (c == '*')  	// skip for carriage return or line feed
			  if ((c == '*') && (nNewLine == 1))
				  nComm=1;
			  if ((c == 0x0a) || (c == 0x0d)) {	// skip for carriage return or line feed
				  buf[maxLen+1] = ' ';
				  maxLen+=1;
				  nComm=0;
				  nNewLine = 1;
				  continue;
			  }
			  if (nComm == 0) {
				  buf[maxLen+1] = c;
				  maxLen+=1;
				  nNewLine = 0;
			  }
			} while (c != EOF);

		buf[maxLen+1] = 0x00;
	//-->>	}
	fclose(pFile);
	return 0;
}
int job_GetTypeOp(struct job_t *job) {
	return job->job_typeOP;
}

int job_NormalOperations(struct job_t *job) {
	return job->nTestCmdLine;
}


int job_check(struct job_t *job) {
	struct file_t *file;
	if (job->includeCondField!=NULL && job->omitCondField!=NULL) {
		fprintf(stderr,"*OCSort*S088* OCSORT - ERROR : INCLUDE COND and OMIT are mutually exclusive\n");
		return -1;
	}
	if (job->inputFile==NULL) {
		fprintf(stderr,"*OCSort*S089* OCSORT - ERROR : No input file specified\n");
		return -1;
	}
	if (job->outputFile==NULL) {
		fprintf(stderr,"*OCSort*S090* OCSORT - ERROR : No output file specified\n");
		return -1;
	}

	for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
		if (job->inputLength<file_getMaxLength(file)) {
			job->inputLength=file_getMaxLength(file);
		}
	}

	if (job->outrec!=NULL) {
		job->outputLength=outrec_getLength(job->outrec);
		if (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) {
			if (job->outputLength != file_getMaxLength(job->outputFile) && file_getMaxLength(job->outputFile)!=0) 
				fprintf(stderr,"*OCSort*W003* WARNING : Outrec clause define a file with a different length than give record clause\n");
		} 
		else
		{
			if (file_getOrganization(job->outputFile) == FILE_TYPE_FIXED) {
				if (job->outputLength != file_getMaxLength(job->outputFile) && file_getMaxLength(job->outputFile)!=0) {
					fprintf(stderr,"*OCSort*S083* ERROR : Outrec clause define a file with a different length than give record clause\n");
					return -1;
				}
			}
		}
	} else {
		job->outputLength=file_getMaxLength(job->outputFile);
		if (job->outputLength==0) {
			job->outputLength=job->inputLength;
		}
	}
	return 0;
}

int job_print_final(struct job_t *job, time_t* timeStart) 
{
	char szNameTmp[FILENAME_MAX];
	// time_t timeStartNew;
	time_t timeEnd;
	struct tm *		timeinfoStart;
	struct tm *		timeinfoEnd;
	struct outfil_t *pOutfil;
	struct file_t	*file;
	int seconds;
	int hh,mm,ss,ms;
	int nIdx;
	int desc=0;

	for (nIdx=0; nIdx < MAX_HANDLE_TEMPFILE; nIdx++) {
		if (job->array_FileTmpHandle[nIdx] != -1) {
			strcpy(szNameTmp, job->array_FileTmpName[nIdx]);
				
			desc=remove(szNameTmp);
			if (desc != 0) {
				fprintf(stderr,"*OCSort*W001* Cannot remove file %s : %s\n", szNameTmp,strerror(errno));
			}
		}
	}
	//-->>if (job->nStatistics == 1) {
		//-->>fprintf(stdout,"\n");
		fprintf(stdout,"========================================================\n");
		fprintf(stdout,"Record Number Total       : %lld\n", job->recordNumberTotal);
		fprintf(stdout,"Record Write Sort Total   : %lld\n", job->recordWriteSortTotal);
		fprintf(stdout,"Record Write Output Total : %lld\n", job->recordWriteOutTotal);
		fprintf(stdout,"========================================================\n");
	//-->>}
	if (job->nStatistics == 2)	{
		if (job->bIsPresentSegmentation == 1) {
			for (nIdx=0; nIdx<MAX_HANDLE_TEMPFILE; nIdx++) {
					fprintf(stdout,"job->nCountSrt[%02d] %d\n", nIdx, job->nCountSrt[nIdx]);
			}
		}

		fprintf(stdout,"\n");
		fprintf(stdout,"Memory size for OCSort data     : %10lld\n", job->ulMemSizeAlloc);
		fprintf(stdout,"Memory size for OCSort key      : %10lld\n", job->ulMemSizeAllocSort);
		fprintf(stdout,"BufferedReader MAX_BUFFER       : %10d\n", MAX_BUFFER);
		fprintf(stdout,"MAX_SIZE_CACHE_WRITE            : %10d\n", MAX_SIZE_CACHE_WRITE);
		fprintf(stdout,"MAX_SIZE_CACHE_WRITE_FINAL      : %10d\n", MAX_SIZE_CACHE_WRITE_FINAL);
		//fprintf(stdout,"MAX_SLOT_SEEK                   : %10ld\n", job->nSlot);
		fprintf(stdout,"MAX_MLTP_BYTE                   : %10d\n", job->nMlt);
		fprintf(stdout,"BYTEORDER                       : %10d\n", job->nByteOrder);
//future use		if (job->m_SeekOrder == 0)
//future use			fprintf(stdout,"Seek Order before Read    : NO\n");
//future use		else
//future use			fprintf(stdout,"Seek Order before Read    : YES\n");
		fprintf(stdout,"===============================================\n");
		fprintf(stdout,"\n");


		if (job->outfil != NULL){
			fprintf(stdout,"OUTFIL\n");
			for (pOutfil=job->outfil; pOutfil != NULL; pOutfil=outfil_getNext(pOutfil)) {
				for (file=pOutfil->outfil_File; file != NULL; file=file_getNext(file)) {
					fprintf(stdout,"File: %s, Record Write Total : %d\n", pOutfil->outfil_File->name, pOutfil->recordWriteOutTotal);
				}
			}
			fprintf(stdout,"\n");
		}
	}	
	//-->>if (job->nStatistics == 1) {
		time (&timeEnd);
		timeinfoStart = localtime(timeStart); // localtime (&timeStart);
		fprintf(stdout,"Start    : %s", asctime(timeinfoStart));
		timeinfoEnd   = localtime(&timeEnd);
		fprintf(stdout,"End      : %s", asctime(timeinfoEnd));
		seconds = (int) difftime(timeEnd, *timeStart);
		hh = seconds/3600;
		mm = (seconds - hh*3600)/60;
		ss = seconds - ((hh*3600) + mm*60);
		ms = seconds - ((hh*3600) + mm*60 + ss);
		fprintf(stdout,"Elapsed  Time %02dhh %02dmm %02dss %03dms\n\n", hh, mm, ss, ms);
	//-->>}

	return 0;
}
	

int job_print(struct job_t *job) {
	struct file_t		*file;
	struct sortField_t	*sortField;
	struct outrec_t		*outrec;
	struct inrec_t		*inrec;
	struct SumField_t	*SumField;
	struct outfil_t		*outfil;
	struct condField_t	*condField;

	printf("\n========================================================\n");
	printf("OCSort Version %s\n", OCSORT_VERSION);
	printf("========================================================\n");


	if (job->bIsTake == 1) {
		printf("TAKE file name\n");
		printf("%s\n", job->szTakeFileName);
		printf("========================================================\n");
	}

// only debug 	if (job->ndeb > 0) { 
// only debug 		printf("Command line \n");
// only debug 		printf("%s\n\n", job_GetCmdLine(job));
// only debug 	}

	if (job->nStatistics > 0) {
		if (job->job_typeOP == 'S')
			printf("Operation  : SORT\n\n");
		else
			printf("Operation  : MERGE\n\n");

		if (job->inputFile!=NULL) {
			printf("INPUT FILE :\n");
			for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
				printf("\t");
				file_print(file);
			}
		}
		if (job->outputFile!=NULL) {
			printf("OUTPUT FILE :\n");
			printf("\t");
			file_print(job->outputFile);
		}
		if (job->sortField!=NULL) {
			if (job->job_typeOP == 'S')
				printf("SORT FIELDS : (");
			else
				printf("MERGE FIELDS : (");
			for (sortField=job->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
				if (sortField!=job->sortField) {
					printf(",");
				}
				sortField_print(sortField);
			}
			printf(")\n");
		}

		// Nel caso di SORT FIELDS=COPY  o MERGE FIELDS=COPY
		if (job->bIsFieldCopy == 1)
			printf("FIELDS = COPY \n");

		if (job->nSkipRec > 0)
			fprintf(stderr,"SKIPREC = %lld\n", job->nSkipRec);

		if (job->nStopAft > 0)
			fprintf(stderr,"STOPAFT = %lld\n", job->nStopAft);

		if (job->includeCondField!=NULL) {
			printf("INCLUDE COND : (");
			//condField_print(job->includeCondField);
			for (condField=job->includeCondField; condField!=NULL; condField=condField_getNext(condField)) {
				if (condField!=job->includeCondField) {
					printf(",");
				}
				condField_print(condField);
			}
			printf(")\n");
		}
		if (job->omitCondField!=NULL) {
			printf("OMIT COND : (");
			// condField_print(job->omitCondField);
			for (condField=job->omitCondField; condField!=NULL; condField=condField_getNext(condField)) {
				if (condField!=job->omitCondField) {
					printf(",");
				}
				condField_print(condField);
			}
			
			printf(")\n");
		}
		if (job->outrec!=NULL) {
			printf("OUTREC FIELDS : (");
			for (outrec=job->outrec; outrec!=NULL; outrec=outrec_getNext(outrec)) {
				if (outrec!=job->outrec) {
					printf(",");
				}
				outrec_print(outrec);
			}
			printf(")\n");
		}
		if (job->inrec!=NULL) {
			printf("INREC FIELDS : (");
			for (inrec=job->inrec; inrec!=NULL; inrec=inrec_getNext(inrec)) {
				if (inrec!=job->inrec) {
					printf(",");
				}
				inrec_print(inrec);

			}
			printf(")\n");
		}

		if (job->sumFields==1) {
			printf("SUM FIELDS = NONE\n");
		}
		if (job->sumFields==2) {
			printf("SUM  FIELDS : (");
			for (SumField=job->SumField; SumField!=NULL; SumField=SumField_getNext(SumField)) {
				if (SumField!=job->SumField) {
					printf(",");
				}
				SumField_print(SumField);
			}
			printf(")\n");
		}
	//
	// OPTION
		if ((job->nVLSCMP!=0) || (job->nVLSHRT!=0) ) {
			printf("OPTION ");
			if (job->nVLSCMP==1) 
				printf(" VLSCMP");
			if (job->nVLSHRT==1) 
				printf(" VLSHRT");
			printf("\n");
		}

	//
	//	OUTFIL
		if (job->outfil != NULL) {
			printf("OUTFIL : \n");
			for (outfil=job->outfil; outfil!=NULL; outfil=outfil_getNext(outfil)) {
				printf("\tFNAMES/FILES:\n");
				for (file=outfil->outfil_File; file!=NULL; file=file_getNext(file)) {
					printf("\t\t");
					file_print(file);
				}
				if (outfil->outfil_includeCond!=NULL) {
					printf("\t\tINCLUDE : (");
					condField_print(outfil->outfil_includeCond);
					printf(")\n");
				}
				if (outfil->outfil_omitCond!=NULL) {
					printf("\t\tOMIT : (");
					condField_print(outfil->outfil_omitCond);
					printf(")\n");
				}
				if (outfil->outfil_outrec!=NULL) {
					printf("\t\tOUTREC : (");
					for (outrec=outfil->outfil_outrec; outrec!=NULL; outrec=outrec_getNext(outrec)) {
						if (outrec!=job->outfil->outfil_outrec) {
							printf(",");
						}
						outrec_print(outrec);
					}
					printf(")\n");
				}
				if (outfil->nSplit > 0)
					printf("\t\tSPLIT \n");
				if (outfil->outfil_nStartRec >= 0)
					printf("\t\tSTARTREC = %lld\n", outfil->outfil_nStartRec);
				if (outfil->outfil_nEndRec >= 0)
					printf("\t\tENDREC = %lld\n", outfil->outfil_nEndRec);
			}
	//--		printf(")\n");
		}
	//
		printf("========================================================\n");
	}
	return 0;
}


int job_destroy(struct job_t *job) {
	struct file_t			*file;
	struct sortField_t		*sortField;
	struct outrec_t			*outrec;
	struct inrec_t			*inrec;
	struct SumField_t		*SumField;
	struct file_t*			fPFile[128];
	struct sortField_t*		fPSF[128];
	struct SumField_t*		fPSum[128];
	struct condField_t*		fPCond[128];
	struct outrec_t*		fPOut[128];
	struct inrec_t*			fPIn[128];
	struct outfil_t*		fPOutfilrec[128];
	// outfil
	struct outfil_t			*outfil;
	struct condField_t		*outfil_includeCond;
	struct condField_t		*outfil_omitCond;
	struct outrec_t 		*outfil_outrec;
	int nIdx = 0;
	int nIdy = 0;
	int nIdxMaster=0;
	int nIdyMaster=0;

	if (job->inputFile!=NULL) {
		for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
			fPFile[nIdx] = file;
			nIdx++;
		}
		for (nIdy=0; nIdy < nIdx; nIdy++){
			file_destructor(fPFile[nIdy]);
		}

	}
	if (job->outputFile!=NULL) {
		file_destructor(job->outputFile);
	}
	if (job->sortField!=NULL) {
		nIdx=0;
		for (sortField=job->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
			fPSF[nIdx] = sortField;
			nIdx++;
		}
		for (nIdy=0; nIdy < nIdx; nIdy++){
			sortField_destructor(fPSF[nIdy]);
		}
	}
	if (job->includeCondField!=NULL) {
		condField_destructor(job->includeCondField);
	}
	if (job->omitCondField!=NULL) {
		condField_destructor(job->omitCondField);
	} 
	if (job->outrec!=NULL) {
		nIdx=0;
		for (outrec=job->outrec; outrec!=NULL; outrec=outrec_getNext(outrec)) {
			fPOut[nIdx] = outrec;
			nIdx++;
		}
		for (nIdy=0; nIdy < nIdx; nIdy++){
			outrec_destructor(fPOut[nIdy]);
		}
	}
	if (job->inrec!=NULL) {
		nIdx=0;
		for (inrec=job->inrec; inrec != NULL; inrec=inrec_getNext(inrec)) {
			fPIn[nIdx] = inrec;
			nIdx++;
		}
		for (nIdy=0; nIdy < nIdx; nIdy++){
			inrec_destructor(fPIn[nIdy]);
		}
	}

	if (job->sumFields>0) {
		nIdx=0;
		for (SumField=job->SumField; SumField!=NULL; SumField=SumField_getNext(SumField)) {
			fPSum[nIdx] = SumField;
			nIdx++;
		}
		for (nIdy=0; nIdy < nIdx; nIdy++){
			SumField_destructor(fPSum[nIdy]);
		}

	}

	if (job->outfil != NULL) {
		nIdxMaster=0;
		for (outfil=job->outfil; outfil!=NULL; outfil=outfil_getNext(outfil)) {
			fPOutfilrec[nIdxMaster] = outfil;
			nIdxMaster++;
		}
		for (nIdyMaster=0; nIdyMaster < nIdxMaster; nIdyMaster++){
			nIdx=0;
			if (fPOutfilrec[nIdyMaster]->outfil_File != NULL)
				file_destructor(fPOutfilrec[nIdyMaster]->outfil_File);

			for (outfil_includeCond=fPOutfilrec[nIdyMaster]->outfil_includeCond; outfil_includeCond!=NULL; outfil_includeCond=outfil_includeCond->next) {
				fPCond[nIdx] = outfil_includeCond;
				nIdx++;
			}
			for (nIdy=0; nIdy < nIdx; nIdy++){
				condField_destructor(fPCond[nIdy]);
			}
			nIdx=0;
			for (outfil_omitCond=fPOutfilrec[nIdyMaster]->outfil_omitCond; outfil_omitCond!=NULL; outfil_omitCond=outfil_omitCond->next) {
				fPCond[nIdx] = outfil_omitCond;
				nIdx++;
			}
			for (nIdy=0; nIdy < nIdx; nIdy++){
				condField_destructor(fPCond[nIdy]);
			}

			nIdx=0;
			for (outfil_outrec=fPOutfilrec[nIdyMaster]->outfil_outrec;outfil_outrec!=NULL; outfil_outrec=outrec_getNext(outfil_outrec)) {
				fPOut[nIdx] = outfil_outrec;
				nIdx++;
			}
			for (nIdy=0; nIdy < nIdx; nIdy++){
				outrec_destructor(fPOut[nIdy]);
			}
			free(fPOutfilrec[nIdyMaster]);
		}
	}

	if (job->reader != NULL)
		BufferedReaderDestructor(job->reader);
	return 0;
}

 

int job_loadFiles(struct job_t *job) {

	int nk=0;
	struct file_t *file;
	int  nbyteRead;
	int nIdxFileIn = 0;
	int useRecord;
	unsigned int  nLenRek;
	int bEOF, nEOFFileIn;
 	int bIsFirstLoop=0;
	unsigned int  nPosCurrentSeek = 0;
	long nRecCount = 0;
	unsigned char szBuffRek[OCSORT_MAX_BUFF_REK];
	unsigned char szBuffKey[OCSORT_MAX_BUFF_REK];
	unsigned char szBuffRekNull[OCSORT_MAX_BUFF_REK];
	unsigned char recordBuffer[OCSORT_MAX_BUFF_REK];

// debug	unsigned char szBuffRekDebug[OCSORT_MAX_BUFF_REK];
	int bIsFirstTime=1;
	int64_t lPosSeqLS = 0;
	long int nMemAllocate = 0;
	unsigned char * pAddress;
	memset(szBuffRekNull, 0x00, OCSORT_MAX_BUFF_REK);
	if (job->bIsPresentSegmentation == 0) {
		job->recordNumber=0;
		job->recordNumberAllocated=OCSORT_ALLOCATE;
		job->recordData=(unsigned char *)malloc((size_t)job->ulMemSizeAlloc);
		job->buffertSort=(unsigned char *)malloc((size_t)job->ulMemSizeAllocSort);
		job->nLenKeys = job_GetLenKeys();
		job->lPosAbsRead = 0;
		bIsFirstTime=1;
	}
	else
	{
		 job->recordNumber=0;
		 lPosSeqLS = job->lPosAbsRead;
		 bIsFirstTime=0;
	}

	job->ulMemSizeRead = 0;
	job->ulMemSizeSort = 0;
	nIdxFileIn = -1;
	job->nLastPosKey = job_GetLastPosKeys();
	if (job->nLastPosKey <= NUMCHAREOL)
		job->nLastPosKey = NUMCHAREOL;	// problem into memchr
	nEOFFileIn = 0;
	for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
		nIdxFileIn++;
		if (job->nCurrFileInput > nIdxFileIn)	// bypass previous file readed
			continue;

		if ((job->bIsPresentSegmentation == 0) || (nEOFFileIn == 1))
		{
			struct stat filestatus;
		    stat( file_getName(file), &filestatus );
			job->inputFile->nFileMaxSize = filestatus.st_size;
			if ((job->desc=open(file_getName(file),O_RDONLY | O_BINARY))<0){
				fprintf(stderr,"*OCSort*S003* Cannot open file %s : %s\n",file_getName(file),strerror(errno));
				return -1;
			}
			job->reader = (struct BufferedReader_t*) BufferedReaderConstructor();
			BufferedReader_SetFileType(job->reader, file->nOrgType);
			job->reader->internal_handle = job->desc;
			file->handleFile = job->desc;
			BufferedReader_getsize_filefromName(job->reader, file_getName(file));
			nEOFFileIn=0;
		} 
		///-->> Attenzione File Variabile necessario leggere i primi 4 byte per la lunghezza
		// -->> inserire una funzione read_file che consideri la lughezza record in funzione della tipologia FIXED - VARIABILE
		bEOF = 0;
		nLenMemory = file_getMaxLength(file);
		nLenRek = file_getRecordLength(file);
		//bIsFirstTime=1;

		while (bEOF == 0)
		{
			// File Variable, get lenght but not for Line Sequential
			if ((file_getFormat(file) == FILE_TYPE_VARIABLE) && 
				(file_getOrganization(file) != FILE_ORGANIZATION_LINESEQUENTIAL))
			{
				BufferedReader_byn_next_record(job->reader, job->desc, SIZEINT, bIsFirstTime, (unsigned char*)&nLenRek);
				nbyteRead = (int)job->reader->nLenLastRecord;
				bIsFirstTime = 0;
				if (nbyteRead < 1) {
					nbyteRead=0;
					bEOF = 1;
					continue;
				}

				if (nbyteRead != SIZEINT){
					bEOF = 1;
					continue;
				}
				nLenRek = Endian_Word_Conversion(nLenRek); // ATTENZIONE bigendian
			}
// Check File Type  for Line Sequential
			if (file_getOrganization(file) == FILE_ORGANIZATION_LINESEQUENTIAL){
				nbyteRead=read_textfile_buff(job->desc, szBuffRek, nLenRek, job->reader, bIsFirstTime, job->nLastPosKey);
				bIsFirstTime = 0;
				if (nbyteRead < 1) {
					nbyteRead=0;
					bEOF = 1;
					continue;
				}
				nLenRek = nbyteRead;
				job->lPosAbsRead = lPosSeqLS; 
				lPosSeqLS = lPosSeqLS + nLenRek;
			}
			else
			{
				// File sequntial fixed
					BufferedReader_byn_next_record(job->reader, job->desc, nLenRek, bIsFirstTime, szBuffRek);
					nbyteRead = (int)job->reader->nLenLastRecord;
					bIsFirstTime = 0;
					if (nbyteRead < 1) {
						nbyteRead=0;
						bEOF = 1;
						continue;
					}
					nLenRek = nbyteRead;
					job->lPosAbsRead = lPosSeqLS; 
					lPosSeqLS = lPosSeqLS + nLenRek;
			}
		
			nRecCount++;
			job->recordNumberTotal++;
			job->LenCurrRek = nLenRek;
// check SKIPREC
			if ((job->nSkipRec > 0) && (nRecCount <= job->nSkipRec)) 
					continue;

			useRecord=1;
			if (job->includeCondField!=NULL && condField_test(job->includeCondField,(unsigned char*) szBuffRek, job)==0) {
				useRecord=0;
			}
			if (job->omitCondField!=NULL && condField_test(job->omitCondField,(unsigned char*) szBuffRek, job)==1) {
				useRecord=0;
			}
			if (useRecord==0)
				continue;

// check STOPAFT
			if ((job->nStopAft > 0) && (job->recordNumber >= job->nStopAft)) {
					nbyteRead=0;
					break;
			}
//

// INREC
// If INREC is present made a new area record.
// Only in this point
// Before all command
			if (job->inrec!=NULL) {
				memset(recordBuffer, 0x20, sizeof(recordBuffer));
				nbyteRead = inrec_copy(job->inrec, recordBuffer, szBuffRek, job->outputLength, file_getMaxLength(file), file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, 0);
				memmove(szBuffRek, recordBuffer, nbyteRead);
				nLenRek = nbyteRead;
			}
//

			//In this point extract key from record
			// Most important IF INREC present all commands get record from INREC definition
			job_GetKeys(szBuffRek, szBuffKey);
			// 
			// Area = Buffer Key + Absolute Position from biginning file + Recorld Length
			// Buffer Key + 2 len record + 2 position key 
			job->LenCurrRek = nLenRek;

			memmove((unsigned char*) job->recordData+job->ulMemSizeRead	, (unsigned char*) szBuffRek, job->LenCurrRek);
			// Key, PosPnt, Len , Order
			// nn , 8     , 4   , 8
			pAddress = (unsigned char*) (unsigned char*) job->recordData+job->ulMemSizeRead;
			//Key
			memmove((unsigned char*) job->buffertSort+(job->recordNumber)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)					  , (unsigned char*) &szBuffKey, job->nLenKeys);
			//PosPnt
			memmove((unsigned char*) job->buffertSort+(job->recordNumber)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys	  , (unsigned char*) &job->lPosAbsRead,   SIZEINT64); // PosPnt
			// len
			memmove((unsigned char*) job->buffertSort+(job->recordNumber)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys+SIZEINT64   , (unsigned char*) &job->LenCurrRek ,   SIZEINT); // len
			// Pointer Address Data
			memmove((unsigned char*) job->buffertSort+(job->recordNumber)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys+SIZEINT64+SIZEINT , &pAddress				        ,  	SIZEINT64); // Pointer Address Data
			
			job->ulMemSizeRead = job->ulMemSizeRead + nLenRek; // key + pointer record + record length
			job->ulMemSizeSort = job->ulMemSizeSort + job->nLenKeys + SIZEINT64 + SIZEINT + SIZEINT64;

			job->recordNumber++;
			// check for next read record  
			if (((job->ulMemSizeRead + ((job->nLenKeys + SIZEINT64 + SIZEINT + nLenMemory) * 2)) >= job->ulMemSizeAlloc) ||
				((job->ulMemSizeSort + ((job->nLenKeys + SIZEINT64 + SIZEINT + SIZEINT64) * 2)) >= job->ulMemSizeAllocSort))	{
					job->lPosAbsRead = job->lPosAbsRead + nLenRek;
					job->lPositionFile = job->lPosAbsRead;
					job->bIsPresentSegmentation = 1;
					job->nCurrFileInput = nIdxFileIn; // last file input read
					return -2;
			}
		}
		
		if (nbyteRead==0) {
			// End of file
            } else if (nbyteRead==-1) {
			fprintf(stderr,"*OCSort*S004* Cannot read file %s : %s\n",file_getName(file),strerror(errno));
			return -1;
		} else {
			fprintf(stderr,"Wrong record length in file %s\n",file_getName(file));
			return -1;
		}
		if (job->desc >= 0)
			close (job->desc);
		if (job->reader != NULL) {
			if (job->reader->file_EOF == 1) {
				//-->>BufferedReader_close_file(job->reader);
				BufferedReaderDestructor(job->reader);
				job->reader = NULL;
				bIsFirstTime=1;
			}
		}
		nEOFFileIn=1;
	}

	return 0;
}

INLINE int read_textfile_buff(int nHandle, unsigned char* pBufRek, int nMaxRek, struct BufferedReader_t * reader, int bIsFirstTime, int nLastPosKey)
{
	 BufferedReader_next_record(reader, nHandle, -1, bIsFirstTime, pBufRek, nLastPosKey);
	 if (*pBufRek == 0x00)
		 return -1;
	 return (int) reader->nLenLastRecord; // return length of record
}

int job_sort(struct job_t *job) {
	int i=0;
	globalJob=job;
	if (job->sortField!=NULL) 
		//qsort((unsigned char*) job->buffertSort, (size_t) job->recordNumber, job->nLenKeys+8+4+8, job_compare_qsort);  // check record position
		qsort(job->buffertSort, (size_t) job->recordNumber, job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64, job_compare_qsort);  // check record position
return 0;
}



int job_save_out(struct job_t *job) {
	int			   retcode_func = 0;
	unsigned char*	bufferwriteglobal; // pointer for write buffered 
	int  position_buf_write=0;
	int desc=-1;
	int64_t i;
	int64_t previousRecord=-1;
	int useRecord;
	unsigned char *recordBuffer;
	int recordBufferLength;
	int  bTempEof=0;
	int  nCompare = 1;
	int64_t lPosPnt = 0;
	int64_t lPosPntRel = 0;
	int	  bSkip = 0;
	int	  nEWC=0;
	int   nNumBytes = 0;
	unsigned int  byteRead = 0;
	int   nNumBytesTemp = 0;
	int   byteReadTemp = 0;
	unsigned int  nLenRekTemp = 0;
	
	unsigned char* szBuffRek;
	unsigned char* szBuffTmp;
	unsigned char *recordBufferPrevious;  // for Sum Fileds NONE

	
	unsigned char* szPrecSumFields;	// Prec
	unsigned char* szSaveSumFields; // save

	//int szLenSumFields= 0;
	int bIsWrited = 0;
	unsigned int   nLenRek = 0;
	unsigned int   nLenPrec = 0;
	unsigned int   nLenSave = 0;
	unsigned int   nLenRecOut=0;
	unsigned char  szKeyCurr[1024+SIZEINT64];
	unsigned char  szKeyPrec[1024+SIZEINT64];
	unsigned char  szKeySave[1024+SIZEINT64];
	int   bIsFirstSumFields = 0;
	unsigned int  lpntTemp = 0;
	int nLenInRec = 0;
	int		nSplitPosPnt = 0;
	unsigned char* pAddress;
	int64_t	nReadTmpFile;
	// recordBufferLength=(job->outputLength>job->inputLength?job->outputLength:job->inputLength);
	recordBufferLength=MAX_RECSIZE; 

	recordBufferLength = recordBufferLength + SIZEINT64;

	recordBuffer=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*OCSort*S005* Cannot Allocate recordBuffer : %s\n", strerror(errno));

	recordBufferPrevious=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*OCSort*S005B* Cannot Allocate recordBuffer : %s\n", strerror(errno));

	szBuffRek=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRek == 0)
		fprintf(stderr,"*OCSort*S006* Cannot Allocate szBuffRek : %s\n", strerror(errno));
	szBuffTmp=(unsigned char *) malloc(recordBufferLength);
	if (szBuffTmp == 0)
		fprintf(stderr,"*OCSort*S007* Cannot Allocate szBuffTmp : %s\n", strerror(errno));
	szPrecSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szPrecSumFields == 0)
		fprintf(stderr,"*OCSort*S008* Cannot Allocate szPrecSumFields : %s\n", strerror(errno));
	szSaveSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szSaveSumFields == 0)
		fprintf(stderr,"*OCSort*S009* Cannot Allocate szSaveSumFields : %s\n", strerror(errno));

	bufferwriteglobal=(unsigned char*) malloc(MAX_SIZE_CACHE_WRITE);
	if (bufferwriteglobal == 0)
		fprintf(stderr,"*OCSort*S012* Cannot Allocate bufferwriteglobal : %s\n", strerror(errno));

	// Outfill == NULL, staandard output file
    if (job->outfil == NULL) {
        if ((desc=open(file_getName(job->outputFile), _O_WRONLY | _O_BINARY | _O_CREAT | _O_TRUNC, _S_IREAD | _S_IWRITE))<0) {
            fprintf(stderr,"*OCSort*S014* Cannot open file %s : %s\n",file_getName(job->outputFile),strerror(errno));
            retcode_func = -1;
            goto job_save_exit;
            }
    }
    if (job->outfil != NULL){
        if (outfil_open_files(job) < 0) {
                retcode_func = -1;
                goto job_save_exit;
        }
    }

    nSplitPosPnt = SIZEINT64;
//-->> debug	printf("======================================= Write out final or sort temp\n");

	bIsFirstSumFields = 0;
	bIsWrited = 0;
	nReadTmpFile=0;

	if (job->recordNumber > 0) {
		SumField_ResetTot(job); // reset totalizer
		bIsFirstSumFields = 1;
		memcpy(&nLenRek,			job->buffertSort+(0)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys+SIZEINT64,     SIZEINT); // nLenRek
		memcpy(szKeyPrec,			job->buffertSort+(0)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys, SIZEINT64);  //lPosPnt
		memcpy(szKeyPrec+SIZEINT64,			job->buffertSort+(0)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64),               job->nLenKeys);  //Key
		memcpy(szPrecSumFields,		&lPosPnt, SIZEINT64); // PosPnt
		memcpy(szPrecSumFields,	(unsigned char*) job->buffertSort+(0)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64, nLenRek+SIZEINT64);
		nLenPrec = nLenRek;
		memcpy(szKeySave,		szKeyPrec, job->nLenKeys+SIZEINT64);			   //lPosPnt + Key
		memcpy(szSaveSumFields, szPrecSumFields, nLenPrec+SIZEINT64);
		nLenSave = nLenPrec;

	}

	for(i=0;i<job->recordNumber;i++) 
	{
		useRecord=1;
		nLenRecOut = job->outputLength;

		memcpy(&lPosPnt,  job->buffertSort+(i)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys,       SIZEINT64);  //lPosPnt
		memcpy(&nLenRek,  job->buffertSort+(i)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys+SIZEINT64,     SIZEINT); // nLenRek
		memcpy(&pAddress, job->buffertSort+(i)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys+SIZEINT64+SIZEINT,   SIZEINT64); // Pointer Data Area 
		memcpy(szBuffRek,     &lPosPnt, SIZEINT64); // PosPnt
		memcpy(szBuffRek+SIZEINT64,  (unsigned char*) pAddress, nLenRek); // buffer

// SUMFIELDS Verify condition for SumFields  == 0, == 1 (None), == 2 (P,L,T)
		// 1  SUM FIELDS = NONE
		if (job->sumFields==1) {
			if (previousRecord!=-1) {
				//if (job_compare_rek((unsigned char*) job->recordData+(previousRecord)*(job->nLenKeys+8+4+nLenMemory), (unsigned char*) job->recordData+(i)*(job->nLenKeys+8+4+nLenMemory))==0) {
				if (job_compare_rek(recordBufferPrevious, szBuffRek, 0)==0) // no check pospnt
					useRecord=0;
			}
			previousRecord=1;
			memcpy(recordBufferPrevious, szBuffRek, nLenRek+nSplitPosPnt); 
		}
// SUMFIELD
		// 2  SUM FIELDS = (P,L,T,....)
		if (job->sumFields==2) {
			memcpy(szKeyCurr,    job->buffertSort+(i)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys, SIZEINT64);  //lPosPnt
			memcpy(szKeyCurr+SIZEINT64,  job->buffertSort+(i)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64),               job->nLenKeys);  //Key
			useRecord = SumFields_KeyCheck(job, &bIsWrited, szKeyPrec, &nLenPrec, szKeyCurr,  &nLenRek, szKeySave,  &nLenSave, 
                                           szPrecSumFields, szSaveSumFields, szBuffRek, SIZEINT64);

		}

		if (useRecord==0)	// skip record
			continue;

		byteRead = nLenRek + nSplitPosPnt;
		nNumBytes = nNumBytes + byteRead;
		memcpy(recordBuffer, szBuffRek, byteRead);
		
// OUTREC
		if (job->outrec!=NULL) {
			memset(szBuffRek, 0x20, sizeof(szBuffRek));
			memcpy(szBuffRek, recordBuffer, nSplitPosPnt);
			nLenRek = outrec_copy(job->outrec, szBuffRek, recordBuffer, job->outputLength, byteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
			memcpy(recordBuffer, szBuffRek, nLenRek+nSplitPosPnt);
            nLenRecOut = nLenRek ;
		}
			
		if (bTempEof == 1)
			memcpy(recordBuffer, szBuffRek, nLenRek+nSplitPosPnt);

/**/ 

// NORMAL
		if ((nLenRek > 0) && (job->outfil == NULL)){
			if (job->sumFields==2) {
				bIsWrited = 1;
				SumField_SumFieldUpdateRek((unsigned char*)recordBuffer+SIZEINT64);		// Update record in  memory
				SumField_ResetTot(job);									// reset totalizer
				SumField_SumField((unsigned char*)szPrecSumFields+SIZEINT64);			// Sum record in  memory
			}				
            if (job_write_output(nLenRecOut, nLenRek, job, desc, nSplitPosPnt, recordBuffer, bufferwriteglobal, &position_buf_write) != 0) {
            				retcode_func = -1;
				goto job_save_exit;
            }
            job->recordWriteOutTotal++;
		}		// close if (nLenRek > 0) 

// OUTFIL
// Make output for OUTFIL
		if ((nLenRek > 0) && (job->outfil != NULL)){
			if (outfil_write_buffer(job, recordBuffer, nLenRek, szBuffRek, nSplitPosPnt) < 0){
					retcode_func = -1;
					goto job_save_exit;
			}
			job->recordWriteOutTotal++;
		}
	
	}	//end of cycle

// 
	if ((job->sumFields==2) && (bIsWrited == 1)) {   // pending buffer
		SumField_SumFieldUpdateRek((char*)szPrecSumFields+SIZEINT64);				// Update record in  memory
		memcpy(recordBuffer, szPrecSumFields, nLenPrec+SIZEINT64);		// Substitute record for write
		nLenRek = nLenPrec;
		nLenRecOut = job->outputLength;
        if (job_write_output(nLenRecOut, nLenRek, job, desc, nSplitPosPnt, recordBuffer, bufferwriteglobal, &position_buf_write) != 0) {
            retcode_func = -1;
			goto job_save_exit;
        }
        job->recordWriteOutTotal++;
	}

	// save record in buffer

	if (job->outfil == NULL) {
		if (write_buffered_final(desc, &bufferwriteglobal, &position_buf_write)<0) {
            fprintf(stderr,"*OCSort*S031* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
            retcode_func = -1;
            goto job_save_exit;
		}
	}



job_save_exit:

   	free(recordBuffer);
	free(szBuffRek);
	free(szBuffTmp);
	free(szPrecSumFields);
	free(szSaveSumFields);
	free(bufferwriteglobal);
	free(recordBufferPrevious);


	if (desc >= 0){
		if (close(desc)<0) {
			fprintf(stderr,"*OCSort*S037* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			return -1;
		}
	}
	if (job->outfil != NULL){
		if (outfil_close_files(job) < 0) {
				return -1;
		}
	}

	return retcode_func;
}
int job_save_tempfile(struct job_t *job) {
	int			   retcode_func = 0;
	unsigned char*	bufferwriteglobal; // pointer for write buffered 
	int  position_buf_write=0;
	int descTmp=-1;
	int desc=-1;
	int64_t i;
	int64_t previousRecord=-1;
	int useRecord;
	unsigned char *recordBuffer;
	int recordBufferLength;
	int  bTempEof=0;
	int  nCompare = 1;
	int64_t lPosPnt = 0;
	int64_t lPosPntRel = 0;
	int	  bSkip = 0;
	int	  nEWC=0;
	int   nNumBytes = 0;
	unsigned int  byteRead = 0;
	int   nNumBytesTemp = 0;
	int   byteReadTemp = 0;
	unsigned int  nLenRekTemp = 0;
	
	unsigned char* szBuffRek;
	unsigned char* szBuffTmp;
	
	unsigned char* szPrecSumFields;	// Prec
	unsigned char* szSaveSumFields; // save
	int bIsWrited = 0;
	int   nLenRek = 0;
	int   nLenPrec = 0;
	int   nLenSave = 0;
	int	  nLenRecOut=0;
	unsigned char  szKeyPrec[1024+SIZEINT64];
	unsigned char  szKeySave[1024+SIZEINT64];
	int   bIsFirstSumFields = 0;
	unsigned int  lpntTemp = 0;
	int nLenInRec = 0;
	char  szNameTmp[FILENAME_MAX];
	struct mmfio_t* mmfTmp;
	int		nSplitPosPnt = 0;
	unsigned char* pAddress;
	int64_t	nReadTmpFile;
	// recordBufferLength=(job->outputLength>job->inputLength?job->outputLength:job->inputLength);
	recordBufferLength=MAX_RECSIZE; 

	recordBufferLength = recordBufferLength + SIZEINT64;

	recordBuffer=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*OCSort*S005* Cannot Allocate recordBuffer : %s\n", strerror(errno));
	szBuffRek=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRek == 0)
		fprintf(stderr,"*OCSort*S006* Cannot Allocate szBuffRek : %s\n", strerror(errno));
	szBuffTmp=(unsigned char *) malloc(recordBufferLength);
	if (szBuffTmp == 0)
		fprintf(stderr,"*OCSort*S007* Cannot Allocate szBuffTmp : %s\n", strerror(errno));
	szPrecSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szPrecSumFields == 0)
		fprintf(stderr,"*OCSort*S008* Cannot Allocate szPrecSumFields : %s\n", strerror(errno));
	szSaveSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szSaveSumFields == 0)
		fprintf(stderr,"*OCSort*S009* Cannot Allocate szSaveSumFields : %s\n", strerror(errno));

	// bufferwriteglobal=(int *) malloc((int)MAX_SIZE_CACHE_WRITE);
	bufferwriteglobal=(unsigned char*) malloc(MAX_SIZE_CACHE_WRITE);
	if (bufferwriteglobal == 0)
		fprintf(stderr,"*OCSort*S012* Cannot Allocate bufferwriteglobal : %s\n", strerror(errno));

// new
// Verify segmentation and if last section of file input
//

    job->nIndextmp++;
    if (job->nIndextmp >= MAX_HANDLE_TEMPFILE) {        // sizeof(job->array_FileTmpHandle))
        job->nIndextmp=0;
    }
    if (job->nMaxHandle >=  MAX_HANDLE_TEMPFILE)
        strcpy(szNameTmp, job->array_FileTmpName[job->nIndextmp]);
    else
    { 
        job->nNumTmpFile++;
        job->nMaxHandle++;
        sort_temp_name(".tmp");
        strcpy(szNameTmp, cob_tmp_temp);
        strcpy(job->array_FileTmpName[job->nIndextmp], szNameTmp);
    } 

    job->nCountSrt[job->nIndextmp]=0;

    if (job->ndeb > 1)
        fprintf(stderr,"Sort Tmp file name %s \n",szNameTmp);

    if ((desc=open(szNameTmp, _O_WRONLY | O_BINARY | _O_CREAT | _O_TRUNC, _S_IREAD | _S_IWRITE))<0) {
            fprintf(stderr,"*OCSort*S013* Cannot open file %s : %s\n",szNameTmp,strerror(errno));
            retcode_func = -1;
            goto job_save_exit;
    }
    job->array_FileTmpHandle[job->nIndextmp] = desc;

    // Get previous file temp
    job->nIndextmp2 = job->nIndextmp+1;
    if (job->nIndextmp2 >= MAX_HANDLE_TEMPFILE) 
        job->nIndextmp2 = 0;

    if (job->array_FileTmpHandle[job->nIndextmp2] == -1)
        //descTmp = 0;
        descTmp=-1;
    else
    {
        // Temporary File in input
        strcpy(szNameTmp, job->array_FileTmpName[job->nIndextmp2]);
        mmfTmp = mmfio_constructor();
        strcpy(szNameTmp, job->array_FileTmpName[job->nIndextmp2]);
        if (mmfio_Open((const unsigned char*)szNameTmp, OPN_READ, 0, mmfTmp) == 0){
            fprintf(stderr,"*OCSort*S018* Cannot open file %s : %s\n",szNameTmp,strerror(errno));
            retcode_func = -1;
            goto job_save_exit;
        }
// buffered vs mmf	
        descTmp = (int)mmfTmp->m_hFile;
    }
    nSplitPosPnt = SIZEINT64;
	bIsFirstSumFields = 0;
	bIsWrited = 0;
	nReadTmpFile=0;

	if (job->recordNumber > 0) {
		SumField_ResetTot(job); // reset totalizer
		bIsFirstSumFields = 1;
		memcpy(&nLenRek,			job->buffertSort+(0)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys+SIZEINT64,     SIZEINT); // nLenRek
		memcpy(szKeyPrec,			job->buffertSort+(0)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys, SIZEINT64);  //lPosPnt
		memcpy(szKeyPrec+SIZEINT64,	job->buffertSort+(0)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64),               job->nLenKeys);  //Key
		memcpy(szPrecSumFields,		&lPosPnt, SIZEINT64); // PosPnt
		memcpy(szPrecSumFields,	(unsigned char*) job->buffertSort+(0)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64, nLenRek+SIZEINT64);
		nLenPrec = nLenRek;
		memcpy(szKeySave,		szKeyPrec, job->nLenKeys+SIZEINT64);			   //lPosPnt + Key
		memcpy(szSaveSumFields, szPrecSumFields, nLenPrec+SIZEINT64);
		nLenSave = nLenPrec;

	}

	for(i=0;i<job->recordNumber;i++) 
	{
		useRecord=1;
		memcpy(&lPosPnt,  job->buffertSort+(i)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys,       SIZEINT64);  //lPosPnt
		memcpy(&nLenRek,  job->buffertSort+(i)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys+SIZEINT64,     SIZEINT); // nLenRek
		memcpy(&pAddress, job->buffertSort+(i)*(job->nLenKeys+SIZEINT64+SIZEINT+SIZEINT64)+job->nLenKeys+SIZEINT64+SIZEINT,   SIZEINT64); // Pointer Data Area 
		memcpy(szBuffRek,     &lPosPnt, SIZEINT64); // PosPnt
		memcpy(szBuffRek+SIZEINT64,  (unsigned char*) pAddress, nLenRek); // buffer

		byteRead = nLenRek + nSplitPosPnt;
		nNumBytes = nNumBytes + byteRead;
		memcpy(recordBuffer, szBuffRek, byteRead);
		if (descTmp > 0){
			while (bTempEof == 0){
				nReadTmpFile=nReadTmpFile+1;
				if (bSkip == 0){
					byteReadTemp = mmfio_Read((unsigned char*) &nLenRekTemp, SIZEINT, &mmfTmp);
					if (byteReadTemp != SIZEINT) {
						bTempEof = 1;
						break;
					}
					else
					{
						if (nLenRekTemp == 0){
							bTempEof = 1;
							break;
						}
						else
						{
							byteReadTemp = mmfio_Read((unsigned char*) szBuffTmp, nLenRekTemp+nSplitPosPnt, &mmfTmp);
							if (byteReadTemp <= 0) {
								bTempEof = 1;
								break;
							}
							nNumBytesTemp = nNumBytesTemp + byteReadTemp;
						}
					}
				}
				// ATTENZIONE CONTROLLO IN ABBINAMENTO
				nCompare = job_compare_rek(szBuffTmp, recordBuffer, 1);	// check pospnt
					
				if (nCompare < 0 )   // 
				{
					write_buffered(desc, (unsigned char*)&nLenRekTemp, SIZEINT, &bufferwriteglobal, &position_buf_write);
					if (write_buffered(desc, (unsigned char*)szBuffTmp, nLenRekTemp+nSplitPosPnt, &bufferwriteglobal, &position_buf_write)<0) {
						fprintf(stderr,"*OCSort*S019* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
						if ((close(desc))<0) {
							fprintf(stderr,"*OCSort*S020* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
						}
						retcode_func = -1;
						goto job_save_exit;
					}
					job->bReUseSrtFile = 1; // Reuse 
					job->nCountSrt[job->nIndextmp]++;
					bSkip = 0;
				}
				else if (nCompare >= 0)
				{
					bSkip = 1;
					break;
				}
			}
		}
		if (bTempEof == 1)
			memcpy(recordBuffer, szBuffRek, nLenRek+nSplitPosPnt);

		// 
		if (nLenRek > 0){
            // memcpy(szCnvNum, &nLenRek, 4);
            write_buffered(desc, (unsigned char*)&nLenRek, SIZEINT, &bufferwriteglobal, &position_buf_write);
            // PosPnt for sort record position
            // Insert for every write file temp
            if (write_buffered(desc, (unsigned char*)recordBuffer, nLenRek+nSplitPosPnt, &bufferwriteglobal, &position_buf_write)<0) {
                fprintf(stderr,"*OCSort*S021* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
                if ((close(desc))<0) {
                    fprintf(stderr,"*OCSort*S022* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
                }
                retcode_func = -1;
                goto job_save_exit;
            }
        }

        job->recordWriteSortTotal++;
        job->nCountSrt[job->nIndextmp]++;

	}		//

    if (write_buffered_final(desc, &bufferwriteglobal, &position_buf_write)<0) {
            fprintf(stderr,"*OCSort*S031* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
            retcode_func = -1;
            goto job_save_exit;
                    
    }

	while ((bTempEof == 0) && (descTmp >= 0)){
		if (bSkip == 1)	{
			/*   */
			write_buffered(desc, (unsigned char*) &nLenRekTemp, SIZEINT, &bufferwriteglobal, &position_buf_write);
			write_buffered(desc, (unsigned char*) szBuffTmp, nLenRekTemp+SIZEINT64, &bufferwriteglobal, &position_buf_write);
			bSkip=0;
		}
		byteReadTemp = mmfio_Read((unsigned char*) &nLenRekTemp, SIZEINT, &mmfTmp);

		if (byteReadTemp != SIZEINT) {
			bTempEof = 1;
			continue;
		}
		if (nLenRekTemp == 0) {
			bTempEof = 1;
			continue;
		}
		// PosPnt
		byteReadTemp = mmfio_Read((unsigned char*) szBuffTmp, nLenRekTemp+SIZEINT64, &mmfTmp);
		if (byteReadTemp <= 0) {
			bTempEof = 1;
			continue;
		}
		nNumBytesTemp = nNumBytesTemp + byteReadTemp;
		write_buffered(desc, (unsigned char*) &nLenRekTemp, SIZEINT, &bufferwriteglobal, &position_buf_write);

		if (write_buffered(desc, (unsigned char*) szBuffTmp, byteReadTemp, &bufferwriteglobal, &position_buf_write)<0) {
			fprintf(stderr,"*OCSort*S033* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			if ((close(desc))<0) {
				fprintf(stderr,"*OCSort*S034* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			}
			retcode_func = -1;
			goto job_save_exit;
		}

		job->nCountSrt[job->nIndextmp]++;
	}

    if (write_buffered_final(desc, &bufferwriteglobal, &position_buf_write)<0) {
        fprintf(stderr,"*OCSort*S036* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
    }

job_save_exit:

   	free(recordBuffer);
	free(szBuffRek);
	free(szBuffTmp);
	free(szPrecSumFields);
	free(szSaveSumFields);
	free(bufferwriteglobal);

	if (desc >= 0){
		if (close(desc)<0) {
			fprintf(stderr,"*OCSort*S037* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			return -1;
		}
	}
	if (descTmp >= 0) {
		mmfio_Close(mmfTmp);
		mmfio_destructor(mmfTmp);
		free(mmfTmp);
		// reset file temp
		// Temporary File in input
		if ((descTmp = open(szNameTmp,O_WRONLY | O_BINARY | O_TRUNC))<0)
		{
			fprintf(stderr,"*OCSort*S039* Cannot open file %s : %s\n",szNameTmp,strerror(errno));
			return -1;
		}
		close(descTmp);

		job->nCountSrt[job->nIndextmp2]=0;
	}
	return retcode_func;
}

INLINE int job_IdentifyBuf(unsigned char** ptrBuf, int nMaxEle)
{
	unsigned char* ptr;
	int p=0;
	int posAr=-1;
	ptr=ptrBuf[0];
	for (p=0; p<MAX_HANDLE_TEMPFILE; p++) // search first buffer not null
	{
		if (ptrBuf[p] != 0x00) {
			ptr=ptrBuf[p];
				posAr = p;
				break;
		}
	}
	for (p=posAr+1; p<MAX_HANDLE_TEMPFILE; p++) {
		if (ptrBuf[p] == 0x00) 
			continue;
		if (job_compare_rek( ptr,  ptrBuf[p], 1) > 0){		// check pospnt enable
			ptr = ptrBuf[p];
			posAr = p;
		}
	}
	return posAr;  
}


// job_save_Final
int job_save_tempfinal(struct job_t *job) {


	int retcode_func=0;
	int desc=0;
	int previousRecord=-1;
	int useRecord;
	unsigned char *recordBuffer;
	unsigned char *recordBufferPrevious;  // for SUm Fileds NONE
	unsigned char* bufferwriteglobal;
	unsigned char* szBuffRekOutRec;

	int  position_buf_write=0;
	unsigned char* szBufRekTmpFile[MAX_HANDLE_TEMPFILE];
	int  position_buf_read=0;
//only debug 	unsigned long startRead = 0; // program starts
//only debug 	unsigned long endRead = 0;
//only debug 	unsigned long totRead = 0;
//only debug 	unsigned long startIdentify = 0;
//only debug 	unsigned long endIdentify = 0;
//only debug 	unsigned long totIdentify = 0;
//only debug 	unsigned long startWrite = 0;
//only debug 	unsigned long endWrite = 0;
//only debug 	unsigned long totWrite = 0;
//only debug 	unsigned long startTotal = 0;
//only debug 	unsigned long endTotal = 0;
//only debug 	unsigned long totTotal = 0;
	unsigned char  szKeyTemp[1024+SIZEINT64];
	unsigned char  szKeyCurr[1024+SIZEINT64];
	unsigned char  szKeyPrec[1024+SIZEINT64];
	unsigned char  szKeySave[1024+SIZEINT64];
	unsigned char* szPrecSumFields;	// Prec
	unsigned char* szSaveSumFields; // save
	unsigned int nLenSave=0;
	unsigned int nLenPrec = 0;
	int bIsWrited = 0;

	int	bIsFirstSumFields = 0;
	int	bIsEof[MAX_HANDLE_TEMPFILE];
	int recordBufferLength;
	int bTempEof=0;
	int nCompare = 1;
	int64_t   lPosPnt = 0;
	unsigned int   nLenRek = 0;
	unsigned int nLenRecOut = 0;
	int nLastRead=0;
	int bFirstRound=0;
	unsigned char*	ptrBuf[MAX_HANDLE_TEMPFILE];
	int nPosPtr;
	int byteReadTmpFile[MAX_HANDLE_TEMPFILE];
	int kj=0;
	//int nPosition = 0;
	int   nNumBytes = 0;
	int   byteRead = 0;
	int   nNumBytesTemp = 0;
	int   byteReadTemp = 0;
	int   nLenRekTemp = 0;
	unsigned char* szBuffRek;  
	int		handleTmpFile[MAX_HANDLE_TEMPFILE];
	int nIdx1, nIdx2, k;
	struct mmfio_t* ArrayFile[MAX_HANDLE_TEMPFILE];
	int		nSumEof;
	int nEWC=0;
	char  szNameTmp[FILENAME_MAX];
	int		nSplitPosPnt = SIZEINT64;
	int		iSeek=0;
	int		nMaxEle=0;
	int p=0;
	int posAr=0;
	int bIsFirstTime = 0;
//only debug		startTotal = GetTickCount();

	if (job->bIsPresentSegmentation == 0)
		return 0;

	recordBufferLength=MAX_RECSIZE;   //(job->outputLength>job->inputLength?job->outputLength:job->inputLength);
	recordBufferLength = recordBufferLength + nSplitPosPnt + NUMCHAREOL;
	recordBuffer=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*OCSort*S041* Cannot Allocate recordBuffer : %s\n", strerror(errno));

	recordBufferPrevious=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*OCSort*S042* Cannot Allocate recordBuffer : %s\n", strerror(errno));

	for (kj=0; kj < MAX_HANDLE_TEMPFILE;kj++) {
		szBufRekTmpFile[kj] = (unsigned char *) malloc(recordBufferLength);
		if (szBufRekTmpFile[kj] == 0)
			fprintf(stderr,"*OCSort*S043* Cannot Allocate szBufRek1 : %s - id : %d\n", strerror(errno), kj);
	}

	szBuffRek=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRek == 0)
		fprintf(stderr,"*OCSort*S044* Cannot Allocate szBuffRek : %s\n", strerror(errno));

	szBuffRekOutRec=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRekOutRec == 0)
		fprintf(stderr,"*OCSort*S098* Cannot Allocate szBuffRekOutRec : %s\n", strerror(errno));

	szPrecSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szPrecSumFields == 0)
		fprintf(stderr,"*OCSort*S098a* Cannot Allocate szPrecSumFields : %s\n", strerror(errno));

	szSaveSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szSaveSumFields == 0)
		fprintf(stderr,"*OCSort*S098b* Cannot Allocate szSaveSumFields : %s\n", strerror(errno));

	bufferwriteglobal=(unsigned char*) malloc(MAX_SIZE_CACHE_WRITE_FINAL);
	if (bufferwriteglobal == 0)
		fprintf(stderr,"*OCSort*S045* Cannot Allocate bufferwriteglobal : %s\n", strerror(errno));

// new
// Verify segmentation and if last section of file input
//

	if (job->outfil == NULL) {
		if ((desc=open(file_getName(job->outputFile),_O_WRONLY | O_BINARY | _O_CREAT | _O_TRUNC, _S_IREAD | _S_IWRITE))<0) {
				fprintf(stderr,"*OCSort*S046* Cannot open file %s : %s\n",file_getName(job->outputFile),strerror(errno));
				retcode_func = -1;
				goto job_save_tempfinal_exit;
		}
	}
	if (job->outfil != NULL){
		if (outfil_open_files(job) < 0) {
				retcode_func = -1;
				goto job_save_tempfinal_exit;
		}
	}
//-->> debug 	printf("=======================================Write Final \n");
// individuazione dei file da aprire
	nIdx1 = job->nIndextmp;
	nIdx2 = job->nIndextmp2;

	for (kj=0; kj < MAX_HANDLE_TEMPFILE;kj++) {
		byteReadTmpFile[kj] = 0;
		handleTmpFile[kj] = 0;
		bIsEof[kj] = 1;
	}
	nLastRead=0;

	// Open files Tmp
	for (k = 0; k < MAX_HANDLE_TEMPFILE; k++)
	{
		if (job->nCountSrt[k] == 0)
			continue;

		 bIsEof[k]=0;
		strcpy(szNameTmp, job->array_FileTmpName[k]);
		ArrayFile[k] = mmfio_constructor();
		if ( mmfio_Open((const unsigned char*) szNameTmp, OPN_READ, 0, ArrayFile[k]) == 0) {
			fprintf(stderr,"*OCSort*S047* Cannot open file %s : %s\n",szNameTmp,strerror(errno));
			retcode_func = -1;
			goto job_save_tempfinal_exit;
		}
		handleTmpFile[k] = (int)ArrayFile[k]->m_hFile; // new
	}
	for (kj=0; kj < MAX_HANDLE_TEMPFILE;kj++) {
		if (handleTmpFile[kj] != 0)
			ptrBuf[kj] = (unsigned char*)szBufRekTmpFile[kj];
		else
			ptrBuf[kj] = 0x00; //0;
	}
	bFirstRound = 1;
	//nPosition = 0;
	nSumEof = 0;
	bIsFirstTime = 1;
	for (kj=0; kj < MAX_HANDLE_TEMPFILE;kj++) {
		if (bIsEof[kj] == 0) {
			bIsEof[kj] = job_ReadFileTemp(ArrayFile[kj], &byteReadTmpFile[kj], szBufRekTmpFile[kj], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
			if (bIsEof[kj] == 1) {
				ptrBuf[kj] = 0x00;
			}
		}
		//
		nSumEof = nSumEof + bIsEof[kj];
	}
	bFirstRound = 0;
	bIsFirstTime = 0;

	nMaxEle = MAX_HANDLE_TEMPFILE;
	if (job->nNumTmpFile < MAX_HANDLE_TEMPFILE)
		nMaxEle = job->nNumTmpFile + 1;	// element 0 can is empty

	nPosPtr = job_IdentifyBuf(ptrBuf, nMaxEle);

	if (nPosPtr >= 0) {
		job_GetKeys(szBufRekTmpFile[nPosPtr]+SIZEINT64, szKeyTemp); 
		SumField_ResetTot(job); // reset totalizer
		bIsFirstSumFields = 1;
		nLenRek = byteReadTmpFile[nPosPtr];
		memmove(szKeyPrec, szBufRekTmpFile[nPosPtr], SIZEINT64);
		memmove(szKeyPrec+SIZEINT64, szKeyTemp, job->nLenKeys);
		memcpy(szPrecSumFields, szBufRekTmpFile[nPosPtr], nLenRek+SIZEINT64);
		nLenPrec = nLenRek;
		memcpy(szKeySave,		szKeyPrec, job->nLenKeys+SIZEINT64);			   //lPosPnt + Key
		memcpy(szSaveSumFields, szPrecSumFields, nLenPrec+SIZEINT64);
		nLenSave = nLenPrec;
	}

	while ((nSumEof) < MAX_HANDLE_TEMPFILE) //job->nNumTmpFile)
	{		
		nLenRecOut = job->outputLength;

//only for debug	startIdentify = GetTickCount();
		nPosPtr = job_IdentifyBuf(ptrBuf, nMaxEle);
//only for debug	endIdentify = GetTickCount()-startIdentify;
//only for debug	totIdentify = totIdentify + endIdentify;
		nLastRead = nPosPtr;
		byteRead=byteReadTmpFile[nPosPtr];
		useRecord=1;

// SUMFIELD			1 = NONE
		if (job->sumFields==1) {
			if (previousRecord!=-1) {
				// check equal key
				if (job_compare_rek(recordBufferPrevious, szBufRekTmpFile[nPosPtr], 0)==0) 
					useRecord=0;
			}
			// enable check for sum fields
			previousRecord=1;
			//
			memcpy(recordBufferPrevious, szBufRekTmpFile[nPosPtr], byteRead); 
		}
// SUMFIELD			2 = FIELDS

		if (job->sumFields==2) {
			job_GetKeys(szBufRekTmpFile[nPosPtr]+SIZEINT64, szKeyTemp); 
			memcpy(szKeyCurr,    szBufRekTmpFile[nPosPtr], SIZEINT64);			//lPosPnt
			memcpy(szKeyCurr+SIZEINT64,  szKeyTemp, job->nLenKeys+SIZEINT64);				//Key
			useRecord = SumFields_KeyCheck(job, &bIsWrited, szKeyPrec, &nLenPrec, szKeyCurr,  &nLenRek, szKeySave,  &nLenSave, 
                                           szPrecSumFields, szSaveSumFields, szBufRekTmpFile[nPosPtr], SIZEINT64);
		}

		if (useRecord==0){	// skip record 
			if (bIsEof[nLastRead] == 0){
				bIsEof[nLastRead] = job_ReadFileTemp(ArrayFile[nLastRead], &byteReadTmpFile[nLastRead], szBufRekTmpFile[nLastRead], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
				if (bIsEof[nLastRead] == 1) {
					ptrBuf[nLastRead] = 0x00;
					nSumEof = nSumEof + bIsEof[nLastRead];
				}
			}
			continue;
		}

// OUTREC  
		if ((useRecord==1) && (job->outrec!=NULL)) {
			memset((unsigned char*)szBuffRekOutRec, 0x20, byteRead);
			nLenRek = outrec_copy(job->outrec, szBuffRekOutRec, szBufRekTmpFile[nPosPtr], job->outputLength, byteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
			memcpy(szBufRekTmpFile[nPosPtr], szBuffRekOutRec, nLenRek+nSplitPosPnt);
			byteReadTmpFile[nPosPtr]=nLenRek;
			byteRead=nLenRek;
			nLenRecOut=nLenRek; // for Outrec force length of record
		}

// NORNAL
		if ((useRecord==1) && (job->outfil == NULL)) {
			//nPosition = nPosition + 4 + byteRead;
			if (job->sumFields==2) {
				bIsWrited = 1;
				SumField_SumFieldUpdateRek((unsigned char*)szBufRekTmpFile[nPosPtr]+SIZEINT64);		// Update record in  memory
				SumField_ResetTot(job);														// reset totalizer
				SumField_SumField((unsigned char*)szPrecSumFields+SIZEINT64);						// Sum record in  memory
			}				
//
			if (byteRead > 0) 
			{
				//??nLenRecOut = nLenRek;
				//if (job_write_output(nLenRecOut, nLenRekTemp, job, desc, nSplitPosPnt, szBufRekTmpFile[nPosPtr], bufferwriteglobal, &position_buf_write) != 0) {
				if (job_write_output(nLenRecOut, byteReadTmpFile[nPosPtr], job, desc, nSplitPosPnt, szBufRekTmpFile[nPosPtr], bufferwriteglobal, &position_buf_write) != 0) {
					retcode_func = -1;
					goto job_save_tempfinal_exit;
				}
				job->recordWriteOutTotal++;
//only for debug		endWrite = GetTickCount()-startWrite;
//only for debug		totWrite = totWrite + endWrite;
			}
			else
			{
					printf("error - nPosPtr &%d\n", nPosPtr);
			}
			
		}
		else
		{
	// Make output for OUTFIL
			if ((useRecord==1) && (job->outfil != NULL)) {
				outfil_write_buffer(job, szBufRekTmpFile[nPosPtr]+nSplitPosPnt, byteRead, szBuffRek, nSplitPosPnt);
				job->recordWriteOutTotal++;
			}
		}
		if (bIsEof[nLastRead] == 0){
//only for debug			startRead = GetTickCount(); // program starts
			bIsEof[nLastRead] = job_ReadFileTemp(ArrayFile[nLastRead], &byteReadTmpFile[nLastRead], szBufRekTmpFile[nLastRead], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
			if (bIsEof[nLastRead] == 1) {
				ptrBuf[nLastRead] = 0x00;
				nSumEof = nSumEof + bIsEof[nLastRead];
			}
//only for debug			endRead = GetTickCount() - startRead ;
//only for debug			totRead = totRead + endRead;
		}
	}


	if ((job->sumFields==2) && (bIsWrited == 1)) {   // pending buffer
		SumField_SumFieldUpdateRek((char*)szPrecSumFields+SIZEINT64);				// Update record in  memory
		memcpy(recordBuffer, szPrecSumFields, nLenPrec+SIZEINT64);		// Substitute record for write
		nLenRek = nLenPrec;
        nLenRecOut = job->outputLength;
        if (job_write_output(nLenRecOut, nLenRek, job, desc, nSplitPosPnt, szBufRekTmpFile[nPosPtr], bufferwriteglobal, &position_buf_write) != 0) {
            retcode_func = -1;
			goto job_save_tempfinal_exit;
        }
        job->recordWriteOutTotal++;
	}


	for (iSeek=0; iSeek < MAX_HANDLE_TEMPFILE; iSeek++) { 
		if (job->nCountSrt[iSeek] == 0)
			continue;
		if (ArrayFile[iSeek]->m_pbFile != NULL) {
			mmfio_Close(ArrayFile[iSeek]);
			mmfio_destructor(ArrayFile[iSeek]);	
			free(ArrayFile[iSeek]);
		}
	}

	// final
    write_buffered_final(desc, &bufferwriteglobal, &position_buf_write);
	// 
job_save_tempfinal_exit:

	free(bufferwriteglobal);
	free(recordBuffer);
	free(recordBufferPrevious); 
	free(szSaveSumFields);
	free(szPrecSumFields);
	free(szBuffRekOutRec);
	free(szBuffRek);
	for (kj=0; kj < MAX_HANDLE_TEMPFILE;kj++) {
		if (szBufRekTmpFile[kj] != NULL)
			free(szBufRekTmpFile[kj]);				
	}
	if (desc > 0){
		if ((close(desc))<0) {
			fprintf(stderr,"*OCSort*S050* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			return -1;
		}
	}
	if (job->outfil != NULL){
		if (outfil_close_files(job) < 0) 
				return -1;
	}
	// only for debugif (retcode_func == 0) {
		// only for debugif (job->ndeb > 0) {
		// only for debug	fprintf(stdout,"job->recordWriteSortTotal : %ld\n", job->recordWriteSortTotal);
		// only for debug	fprintf(stdout,"job->recordWriteOutTotal  : %ld\n", job->recordWriteOutTotal);
		// only for debug	fprintf(stdout,"job->recordNumberTotal    : %ld\n", job->recordNumberTotal);
			// only for debug 			endTotal = GetTickCount() - startTotal;
			// only for debug 			fprintf(stdout,"=====================================================================\n");
			// only for debug 			fprintf(stdout,"nTimer totTotal     %ld sec\n", endTotal/1000);
			// only for debug 			fprintf(stdout,"nTimer totIdentify  %ld sec\n", totIdentify/1000);
			// only for debug 			fprintf(stdout,"nTimer totalRead    %ld sec\n", totRead/1000);
			// only for debug 			fprintf(stdout,"nTimer totWrite     %ld sec\n", totWrite/1000);
			// only for debug 			fprintf(stdout,"=====================================================================\n");
		// only for debug}
	// only for debug}
	return retcode_func;
}

INLINE int job_ReadFileTemp(struct mmfio_t* descTmp, int* nLR, unsigned char* szBuffRek, int nFirst)
{
	int byteReadTemp=0;
	unsigned int lenBE = 0;
	int bTempEof=0;
	byteReadTemp = mmfio_Read((unsigned char*) &lenBE, SIZEINT, &descTmp);
	if (byteReadTemp != SIZEINT) {
		memset(szBuffRek, 0xFF, SIZEINT); //recordBufferLength
		bTempEof = 1;
		*nLR = 0;
		return bTempEof;
	}
	if (lenBE == 0)	{
		memset(szBuffRek, 0xFF, SIZEINT); //recordBufferLength
		bTempEof = 1;
		*nLR = 0;
		return bTempEof;
	}
	byteReadTemp = mmfio_Read((unsigned char*) szBuffRek, lenBE+SIZEINT64, &descTmp);
	if (byteReadTemp <= 0) {
		bTempEof = 1;
		*nLR = 0;
		return bTempEof;
	}

	*nLR = byteReadTemp-SIZEINT64;
	return bTempEof;
}


int job_GetLastPosKeys( void)
{
	int result=0;
	struct sortField_t *sortField;
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		if (result < (sortField_getPosition(sortField) + sortField_getLength(sortField))) 
			result = sortField_getPosition(sortField) + sortField_getLength(sortField);
	}
	return result;
}


int job_GetLenKeys( void)
{
	int result=0;
	struct sortField_t *sortField;
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		result = result + sortField_getLength(sortField);
	}
	return result;
}
INLINE int job_GetKeys(const void *szBufferIn, void *szKeyOut) {
	
	int nSp=0;
	struct sortField_t *sortField;
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		switch (sortField_getType(sortField)) {
			case FIELD_TYPE_CHARACTER:
				memmove((unsigned char*) szKeyOut+nSp, 
							(unsigned char*) szBufferIn+sortField_getPosition(sortField)-1, 
							sortField_getLength(sortField));
				// position file pointer
				break;
			case FIELD_TYPE_BINARY:
				memmove((unsigned char*) szKeyOut+nSp, 
							(unsigned char*) szBufferIn+sortField_getPosition(sortField)-1, 
							sortField_getLength(sortField));
				break;
			case FIELD_TYPE_FIXED:
				memmove((unsigned char*) szKeyOut+nSp, 
							(unsigned char*) szBufferIn+sortField_getPosition(sortField)-1, 
							sortField_getLength(sortField));
				break;
			case FIELD_TYPE_PACKED:
				memmove((unsigned char*) szKeyOut+nSp,  
							(unsigned char *)szBufferIn+sortField_getPosition(sortField)-1, 
							sortField_getLength(sortField));
				break;
			case FIELD_TYPE_ZONED:
				memmove((unsigned char*) szKeyOut+nSp,  
							(unsigned char *)szBufferIn+sortField_getPosition(sortField)-1, 
							sortField_getLength(sortField));
				break;
			default:
				break;
		}
		nSp = nSp + sortField_getLength(sortField);
	}
	return 0;
}

INLINE int job_compare_key(const void *first, const void *second) {
	// attenzione considerare campi temporanei di dimensione maggiore per 
	// gestire anche campi pic 9(18) -->  int64_t
	lPosA = 0;
	lPosB = 0;
	result=0;
	nSp=SIZEINT64; // first 8 byte for PosPnt
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		n64Tmp1 = 0;
		n64Tmp2 = 0;
		switch (sortField_getType(sortField)) {
			case FIELD_TYPE_CHARACTER:
				result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
				break;
			case FIELD_TYPE_BINARY:
				n64Tmp1 = utils_GetValueRekBIFI((unsigned char*)first+nSp,  sortField_getLength(sortField), FIELD_TYPE_BINARY) ;
				n64Tmp2 = utils_GetValueRekBIFI((unsigned char*)second+nSp, sortField_getLength(sortField), FIELD_TYPE_BINARY) ;

				// 201602 if (llabs(n64Tmp1) < llabs(n64Tmp2))		// Unsigned
				if (n64Tmp1 < n64Tmp2)		// Unsigned
					result = -1;
				else
					if (n64Tmp1 > n64Tmp2)
						result=1;
				break;
			case FIELD_TYPE_FIXED:
				n64Tmp1 = utils_GetValueRekBIFI((unsigned char*)first+nSp,  sortField_getLength(sortField), FIELD_TYPE_FIXED) ;
				n64Tmp2 = utils_GetValueRekBIFI((unsigned char*)second+nSp, sortField_getLength(sortField), FIELD_TYPE_FIXED) ;

				if (n64Tmp1 < n64Tmp2)		//
					result = -1;
				else
					if (n64Tmp1 > n64Tmp2)
						result=1;
				break;
			case FIELD_TYPE_PACKED:
				memcpy(szBufPK1, (unsigned char*) first+nSp, sortField_getLength(sortField));
				memcpy(szBufPK2, (unsigned char*) second+nSp, sortField_getLength(sortField));
				SPK1x = szBufPK1[sortField_getLength(sortField)-1] >> 4;				// shift left for sign first  packed
				SPK1 = SPK1x << 4;				// shift left for sign second packed
				SPK1 = (int)szBufPK1[sortField_getLength(sortField)-1] - (int)SPK1;
				SPK2x = szBufPK2[sortField_getLength(sortField)-1] >> 4;				// shift left for sign first  packed
				SPK2 = SPK2x << 4;				// shift left for sign second packed
				SPK2 = (int)szBufPK2[sortField_getLength(sortField)-1] - (int)SPK2;

				bIsNegSPK1 = 0;
				bIsNegSPK2 = 0;
				if ((SPK1 == 0x0B) || (SPK1 == 0x0D) )  // negative
					bIsNegSPK1 = 1;
				if ((SPK2 == 0x0B) || (SPK2 == 0x0D) )  // negative
					bIsNegSPK2 = 1;
				if ((bIsNegSPK1 == 0) && (bIsNegSPK2 == 0)) // SPK1 and SPK2 are Positive
				{
					result=memcmp((unsigned char*) szBufPK1, szBufPK2, sortField_getLength(sortField));
				} else 
				if ((bIsNegSPK1 == 0) && (bIsNegSPK2 == 1)) // SPK1 is Positive and SPK2 is Negative 
				{	
					result=1;
				} else 
				if ((bIsNegSPK1 == 1) && (bIsNegSPK2 == 0)) // SPK1 is Negative and SPK2 is Positive 
				{	
					result=-1;
				} else 
				if ((bIsNegSPK1 == 1) && (bIsNegSPK2 == 1)) // SPK1 and SPK2 are Negative
				{	// attenction 
					result=memcmp((unsigned char*) szBufPK1, szBufPK2, sortField_getLength(sortField));
					result= result*-1;
				}
				break;
			case FIELD_TYPE_ZONED:
				// problems result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
				// first field
				memcpy(szBufPK1, (unsigned char*) first+nSp, sortField_getLength(sortField));
				szBufPK1[sortField_getLength(sortField)] = 0x00;
				bIsNegSPK1 = 1;
				if (szBufPK1[sortField_getLength(sortField)-1] > 0x39) {
					szBufPK1[sortField_getLength(sortField)-1] -= 0x40;
					bIsNegSPK1 = -1;
				}
				n64Tmp1 = _strtoll((const char*)szBufPK1, &pEnd, 10);
				n64Tmp1 *= bIsNegSPK1;
				
				// second field
				memcpy(szBufPK2, (unsigned char*) second+nSp, sortField_getLength(sortField));
				szBufPK2[sortField_getLength(sortField)] = 0x00;
				bIsNegSPK2 = 1;
				if (szBufPK2[sortField_getLength(sortField)-1] > 0x39) {
					szBufPK2[sortField_getLength(sortField)-1] -= 0x40;
					bIsNegSPK2 = -1;
				}
				n64Tmp2 = _strtoll((const char*)szBufPK2, &pEnd, 10);
				n64Tmp2 *= bIsNegSPK2;
				
				if (n64Tmp1 < n64Tmp2)		//
					result = -1;
				else
					if (n64Tmp1 > n64Tmp2)
						result=1;
				break;
			default:
				break;
		}
		if (result) {
			if (sortField_getDirection(sortField)==SORT_DIRECTION_ASCENDING) {
				return result;
			} else {
				return -result;
			}
		}
		nSp = nSp + sortField_getLength(sortField);
	}

	return 0;
}
INLINE int job_compare_rek(const void *first, const void *second, int bCheckPosPnt) {
	// attenzione considerare campi temporanei di dimensione maggiore per 
	// gestire anche campi pic 9(18) -->  int64_t
	lPosA = 0;
	lPosB = 0;
	result=0;
	//-->>
	nSp=SIZEINT64; // first 8 byte for PosPnt


	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		switch (sortField_getType(sortField)) {
			case FIELD_TYPE_CHARACTER:
				result=memcmp( (unsigned char*) first+sortField_getPosition(sortField)-1+nSp, (unsigned char*) second+sortField_getPosition(sortField)-1+nSp, sortField_getLength(sortField));
				break;
			case FIELD_TYPE_BINARY:
				/*
				n64Tmp1 = utils_GetValueRekBIFI((unsigned char*)first+nSp,  sortField_getLength(sortField), FIELD_TYPE_BINARY) ;
				n64Tmp2 = utils_GetValueRekBIFI((unsigned char*)second+nSp, sortField_getLength(sortField), FIELD_TYPE_BINARY) ;
				*/
				n64Tmp1 = utils_GetValueRekBIFI((unsigned char*)first+sortField_getPosition(sortField)-1+nSp,  sortField_getLength(sortField), FIELD_TYPE_BINARY) ;
				n64Tmp2 = utils_GetValueRekBIFI((unsigned char*)second+sortField_getPosition(sortField)-1+nSp, sortField_getLength(sortField), FIELD_TYPE_BINARY) ;
				// 20160207 if (llabs(n64Tmp1) < llabs(n64Tmp2))		// Unsigned
				if (n64Tmp1 < n64Tmp2)		// Unsigned
						result = -1;
				else
					if (n64Tmp1 > n64Tmp2)
						result=1;
				break;
			case FIELD_TYPE_FIXED:
				// n64Tmp1 = utils_GetValueRekBIFI((unsigned char*)first+nSp,  sortField_getLength(sortField), FIELD_TYPE_FIXED) ;
				// n64Tmp2 = utils_GetValueRekBIFI((unsigned char*)second+nSp, sortField_getLength(sortField), FIELD_TYPE_FIXED) ;
				n64Tmp1 = utils_GetValueRekBIFI((unsigned char*)first+sortField_getPosition(sortField)-1+nSp,  sortField_getLength(sortField), FIELD_TYPE_FIXED) ;
				n64Tmp2 = utils_GetValueRekBIFI((unsigned char*)second+sortField_getPosition(sortField)-1+nSp, sortField_getLength(sortField), FIELD_TYPE_FIXED) ;
				if (n64Tmp1 < n64Tmp2)		//
					result = -1;
				else
					if (n64Tmp1 > n64Tmp2)
						result=1;
				break;
			case FIELD_TYPE_PACKED:
				memcpy(szBufPK1, (unsigned char*) first+sortField_getPosition(sortField)-1+nSp, sortField_getLength(sortField));
				memcpy(szBufPK2, (unsigned char*) second+sortField_getPosition(sortField)-1+nSp, sortField_getLength(sortField));
				SPK1x = szBufPK1[sortField_getLength(sortField)-1] >> 4;				// shift left for sign first  packed
				SPK1 = SPK1x << 4;				// shift left for sign second packed
				SPK1 = (int)szBufPK1[sortField_getLength(sortField)-1] - (int)SPK1;
				SPK2x = szBufPK2[sortField_getLength(sortField)-1] >> 4;				// shift left for sign first  packed
				SPK2 = SPK2x << 4;				// shift left for sign second packed
				SPK2 = (int)szBufPK2[sortField_getLength(sortField)-1] - (int)SPK2;

				bIsNegSPK1 = 0;
				bIsNegSPK2 = 0;
				if ((SPK1 == 0x0B) || (SPK1 == 0x0D) )  // negative
					bIsNegSPK1 = 1;
				if ((SPK2 == 0x0B) || (SPK2 == 0x0D) )  // negative
					bIsNegSPK2 = 1;
				if ((bIsNegSPK1 == 0) && (bIsNegSPK2 == 0)) // SPK1 and SPK2 are Positive
				{
					result=memcmp((unsigned char*) szBufPK1, szBufPK2, sortField_getLength(sortField));
				} else 
				if ((bIsNegSPK1 == 0) && (bIsNegSPK2 == 1)) // SPK1 is Positive and SPK2 is Negative 
				{	
					result=1;
				} else 
				if ((bIsNegSPK1 == 1) && (bIsNegSPK2 == 0)) // SPK1 is Negative and SPK2 is Positive 
				{	
					result=-1;
				} else 
				if ((bIsNegSPK1 == 1) && (bIsNegSPK2 == 1)) // SPK1 and SPK2 are Negative
				{	// attenction 
					result=memcmp((unsigned char*) szBufPK1, szBufPK2, sortField_getLength(sortField));
					result= result*-1;
				}
				break;
			case FIELD_TYPE_ZONED:
// s.m. original 
//				result=memcmp( (unsigned char*) first+sortField_getPosition(sortField)-1+nSp, (unsigned char*) second+sortField_getPosition(sortField)-1+nSp, sortField_getLength(sortField));
				// first field
				memcpy(szBufPK1, (unsigned char*) first+nSp, sortField_getLength(sortField));
				szBufPK1[sortField_getLength(sortField)] = 0x00;
				bIsNegSPK1 = 1;
				if (szBufPK1[sortField_getLength(sortField)-1] > 0x39) {
					szBufPK1[sortField_getLength(sortField)-1] -= 0x40;
					bIsNegSPK1 = -1;
				}
				n64Tmp1 = _strtoll((const char*)szBufPK1, &pEnd, 10);
				n64Tmp1 *= bIsNegSPK1;
				
				// second field
				memcpy(szBufPK2, (unsigned char*) second+nSp, sortField_getLength(sortField));
				szBufPK2[sortField_getLength(sortField)] = 0x00;
				bIsNegSPK2 = 1;
				if (szBufPK2[sortField_getLength(sortField)-1] > 0x39) {
					szBufPK2[sortField_getLength(sortField)-1] -= 0x40;
					bIsNegSPK2 = -1;
				}
				n64Tmp2 = _strtoll((const char*)szBufPK2, &pEnd, 10);
				n64Tmp2 *= bIsNegSPK2;
				
				if (n64Tmp1 < n64Tmp2)		//
					result = -1;
				else
					if (n64Tmp1 > n64Tmp2)
						result=1;
				break;
			default:
				break;
		}
		if (result) {
			if (sortField_getDirection(sortField)==SORT_DIRECTION_ASCENDING) {
				return result;
			} else {
				return -result;
			}
		}
	}
// check record pointer
	if (result == 0){
		if(bCheckPosPnt == 1) {			// check pospnt
			// check value of record position
			memcpy(&lPosA, (unsigned char*)first, SIZEINT64);
			memcpy(&lPosB, (unsigned char*)second,SIZEINT64);
			if(lPosA < lPosB)
				result = -1;
			if(lPosA > lPosB)
				result = 1;
			// debug fprintf(stdout,"lPosA = %16I64d - lPosB = %16I64d \n", lPosA, lPosB);
			return result;
		}
	}
//
	return 0;
}


INLINE int job_compare_qsort(const void *first, const void *second) {
	// attenzione considerare campi temporanei di dimensione maggiore per 
	// gestire anche campi pic 9(18) -->  int64_t
	//unsigned char ucSign;
	lPosA = 0;
	lPosB = 0;
	nSp=0;
	result=0;
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		n64Tmp1 = 0;
		n64Tmp2 = 0;
		switch (sortField_getType(sortField)) {
			case FIELD_TYPE_CHARACTER:
				result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
				break;
			case FIELD_TYPE_BINARY:
				n64Tmp1 = utils_GetValueRekBIFI((unsigned char*)first+nSp,  sortField_getLength(sortField), FIELD_TYPE_BINARY) ;
				n64Tmp2 = utils_GetValueRekBIFI((unsigned char*)second+nSp, sortField_getLength(sortField), FIELD_TYPE_BINARY) ;
				// 201602 if (llabs(n64Tmp1) < llabs(n64Tmp2))		// Unsigned
				if (n64Tmp1 < n64Tmp2)		// Unsigned
					result = -1;
				else
					if (n64Tmp1 > n64Tmp2)
						result=1;
					
				break;
			case FIELD_TYPE_FIXED:
				n64Tmp1 = utils_GetValueRekBIFI((unsigned char*)first+nSp,  sortField_getLength(sortField), FIELD_TYPE_FIXED) ;
				n64Tmp2 = utils_GetValueRekBIFI((unsigned char*)second+nSp, sortField_getLength(sortField), FIELD_TYPE_FIXED) ;

				if (n64Tmp1 < n64Tmp2)		//
					result = -1;
				else
					if (n64Tmp1 > n64Tmp2)
						result=1;
				break;
			case FIELD_TYPE_PACKED:
				memcpy(szBufPK1, (unsigned char*) first+nSp, sortField_getLength(sortField));
				memcpy(szBufPK2, (unsigned char*) second+nSp, sortField_getLength(sortField));
				SPK1x = szBufPK1[sortField_getLength(sortField)-1] >> 4;				// shift left for sign first  packed
				SPK1 = SPK1x << 4;				// shift left for sign second packed
				SPK1 = (int)szBufPK1[sortField_getLength(sortField)-1] - (int)SPK1;
				SPK2x = szBufPK2[sortField_getLength(sortField)-1] >> 4;				// shift left for sign first  packed
				SPK2 = SPK2x << 4;				// shift left for sign second packed
				SPK2 = (int)szBufPK2[sortField_getLength(sortField)-1] - (int)SPK2;

				bIsNegSPK1 = 0;
				bIsNegSPK2 = 0;
				if ((SPK1 == 0x0B) || (SPK1 == 0x0D) )  // negative
					bIsNegSPK1 = 1;
				if ((SPK2 == 0x0B) || (SPK2 == 0x0D) )  // negative
					bIsNegSPK2 = 1;
				if ((bIsNegSPK1 == 0) && (bIsNegSPK2 == 0)) // SPK1 and SPK2 are Positive
				{
					result=memcmp((unsigned char*) szBufPK1, szBufPK2, sortField_getLength(sortField));
				} else 
				if ((bIsNegSPK1 == 0) && (bIsNegSPK2 == 1)) // SPK1 is Positive and SPK2 is Negative 
				{	
					result=1;
				} else 
				if ((bIsNegSPK1 == 1) && (bIsNegSPK2 == 0)) // SPK1 is Negative and SPK2 is Positive 
				{	
					result=-1;
				} else 
				if ((bIsNegSPK1 == 1) && (bIsNegSPK2 == 1)) // SPK1 and SPK2 are Negative
				{	// attenction 
					result=memcmp((unsigned char*) szBufPK1, szBufPK2, sortField_getLength(sortField));
					result= result*-1;
				}
				break;
			case FIELD_TYPE_ZONED:
				//result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
				// problems result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
				// first field
				memcpy(szBufPK1, (unsigned char*) first+nSp, sortField_getLength(sortField));
				szBufPK1[sortField_getLength(sortField)] = 0x00;
				bIsNegSPK1 = 1;
				if (szBufPK1[sortField_getLength(sortField)-1] > 0x39) {
					szBufPK1[sortField_getLength(sortField)-1] -= 0x40;
					bIsNegSPK1 = -1;
				}
				n64Tmp1 = _strtoll((const char*)szBufPK1, &pEnd, 10);
				n64Tmp1 *= bIsNegSPK1;
				
				// second field
				memcpy(szBufPK2, (unsigned char*) second+nSp, sortField_getLength(sortField));
				szBufPK2[sortField_getLength(sortField)] = 0x00;
				bIsNegSPK2 = 1;
				if (szBufPK2[sortField_getLength(sortField)-1] > 0x39) {
					szBufPK2[sortField_getLength(sortField)-1] -= 0x40;
					bIsNegSPK2 = -1;
				}
				n64Tmp2 = _strtoll((const char*)szBufPK2, &pEnd, 10);
				n64Tmp2 *= bIsNegSPK2;
				
				if (n64Tmp1 < n64Tmp2)		//
					result = -1;
				else
					if (n64Tmp1 > n64Tmp2)
						result=1;
				break;
				break;
			default:
				break;
		}


		if (result) {
			if (sortField_getDirection(sortField)==SORT_DIRECTION_ASCENDING) {
				return result;
			} else {
				return -result;
			}
		}
		nSp = nSp + sortField_getLength(sortField);
	}

	// only for SUM FIELDS=NONE
		if (result == 0){
			// check value of record position
			memcpy(&lPosA, (unsigned char*)first+globalJob->nLenKeys,SIZEINT64);
			memcpy(&lPosB, (unsigned char*)second+globalJob->nLenKeys,SIZEINT64);
			if(lPosA < lPosB)
				result = -1;
			if(lPosA > lPosB)
				result = 1;
			// debug fprintf(stdout,"lPosA = %16I64d - lPosB = %16I64d \n", lPosA, lPosB);
			return result;
		}
		
	return 0;
}
//static char *
void sort_temp_name(const char * ext)
{ 
// #ifdef	_WIN32
#ifdef _MSC_VER
	if (globalJob->strPathTempFile == NULL)
		GetTempPath(FILENAME_MAX, cob_tmp_temp);
	else
		strcpy(cob_tmp_temp, globalJob->strPathTempFile);
	GetTempFileName(cob_tmp_temp, "Srt", 0, cob_tmp_buff);
	DeleteFile(cob_tmp_buff);
	//strcpy(cob_tmp_buff + strlen(cob_tmp_buff) - 4, ext);
	strcpy(cob_tmp_temp, cob_tmp_buff); 
	strcpy(cob_tmp_temp + strlen(cob_tmp_temp) - 4, ext);
	return ;
#else
	char*			buff; 
	//char 			cob_tmp_temp[FILENAME_MAX];
	char*			cob_tmpdir; 
	char*			p=NULL;
	pid_t			cob_process_id = 0;
	int                  cob_iteration;
	cob_process_id = getpid ();
	cob_iteration = globalJob->nIndextmp;

	//-->>printf("globalJob->strPathTempFile %s \n", globalJob->strPathTempFile);

//linux 	if (globalJob->strPathTempFile == NULL){
	if (strlen(globalJob->strPathTempFile) == 0){
		if ((p = getenv ("TMPDIR")) != NULL) {
			cob_tmpdir = p;
		} else if ((p = getenv ("TMP")) != NULL) {
			cob_tmpdir = p;
		}
		if (cob_tmpdir == NULL)
		//	sprintf(cob_tmp_temp, "./");
			sprintf(cob_tmp_temp, "./Srt%d_%d%s", (int)cob_process_id,
				(int)cob_iteration, ext);
		else
		sprintf(cob_tmp_temp, "%s/Srt%d_%d%s", cob_tmpdir, (int)cob_process_id,
			(int)cob_iteration, ext);

	}
	else
		sprintf(cob_tmp_temp, "%s/Srt%d_%d%s", globalJob->strPathTempFile, (int)cob_process_id, (int)cob_iteration, ext);

	//-->>printf("\n%s\n", cob_tmp_temp);

	return;
	//return buff;
#endif
}

/* FILE HEADER 
Offset	Size	Description
0	4	Length of the file header. The first 4 bits are always set to 3 (0011 in binary) indicating that 
		this is a system record. The remaining bits contain the length of the file header record. 
		If the maximum record length is less than 4095 bytes, the length is 126 and is held in the next 12 bits; 
		otherwise it is 124 and is held in the next 28 bits. Hence, in a file where the maximum record length is less 
		than 4095 bytes, this field contains x"30 7E 00 00". Otherwise, this field contains x"30 00 00 7C". 
4	2	Database sequence number, used by add-on products.
6	2	Integrity flag. Indexed files only. If this is non-zero when the header is read, it indicates that 
		the file is corrupt.
8	14	Creation date and time in YYMMDDHHMMSSCC format. Indexed files only.
22	14	Reserved
36	2	Reserved. Value 62 decimal; x"00 3E".
38	1	Not used. Set to zeros.
39	1	Organization.
		1=Sequential
		2=Indexed
		3=Relative.
40	1	Not used. Set to zeros.
41	1	Data compression routine number.
		0 = No compression
		1 = CBLDC001
42-127 = Reserved for internal use
128-255 = User-defined compression routine number
42	1	Not used. Set to zeros.
43	1	Indexed files only - type of indexed file. See the section Indexed Files for a list of indexed file types.
44	4	Reserved
48	1	Recording mode.
		0 = Fixed format
		1 = Variable format
		For indexed files, the recording mode field of the .idx file takes precedence.
49	5	Not used. Set to zeros.
54	4	Maximum record length. Example: with a maximum record of length 80 characters, 
		this field will contain x"00 00 00 50".
58	4	Minimum record length. Example: with a minimum record length of 2 characters, 
		this field will contain x"00 00 00 02".
62	46	Not used. Set to zeros.
108	4	Version and build data for the indexed file handler creating the file. Indexed files only.
112	16	Not used. Set to zeros.
*/

// Get len of header

// Verify max len of record  < 4095 or >= 4095
/*
int GetHeaderInfo(struct job_t* job, unsigned char* szHead)
{


	unsigned int nHeadLen = 0;
	unsigned int nMaxRekLen = 0;
	unsigned int nMinRekLen = 0;
	int nLen = 0;  // 1 < 4095 , 2 >= 4095
;

//	pChar = szHead;

	memcpy(&nHeadLen, szHead, 4);
	nHeadLen = Endian_DWord_Conversion(nHeadLen);
	nHeadLen = nHeadLen << 4;
	nHeadLen = nHeadLen >> 4;
//	nHeadLen = Endian_DWord_Conversion(nHeadLen);


	if (nHeadLen==124)	// >= 4095
	{
		nLen = 2;
		nSpread = 805306492;
	}
	else
	{
		nLen = 1;
		nSpread = 813563904;
	}


	memcpy(&nMaxRekLen, szHead+54, 4);
	nMaxRekLen = Endian_DWord_Conversion(nMaxRekLen);

	memcpy(&nMinRekLen, szHead+58, 4);
	nMinRekLen = Endian_DWord_Conversion(nMinRekLen);


	return 0;
}
*/
/* FILE HEADER 
Offset	Size	Description
0	4	Length of the file header. The first 4 bits are always set to 3 (0011 in binary) indicating that 
		this is a system record. The remaining bits contain the length of the file header record. 
		If the maximum record length is less than 4095 bytes, the length is 126 and is held in the next 12 bits; 
		otherwise it is 124 and is held in the next 28 bits. Hence, in a file where the maximum record length is less 
		than 4095 bytes, this field contains x"30 7E 00 00". Otherwise, this field contains x"30 00 00 7C". 
4	2	Database sequence number, used by add-on products.
6	2	Integrity flag. Indexed files only. If this is non-zero when the header is read, it indicates that 
		the file is corrupt.
8	14	Creation date and time in YYMMDDHHMMSSCC format. Indexed files only.
22	14	Reserved
36	2	Reserved. Value 62 decimal; x"00 3E".
38	1	Not used. Set to zeros.
39	1	Organization.
		1=Sequential
		2=Indexed
		3=Relative.
40	1	Not used. Set to zeros.
41	1	Data compression routine number.
		0 = No compression
		1 = CBLDC001
42-127 = Reserved for internal use
128-255 = User-defined compression routine number
42	1	Not used. Set to zeros.
43	1	Indexed files only - type of indexed file. See the section Indexed Files for a list of indexed file types.
44	4	Reserved
48	1	Recording mode.
		0 = Fixed format
		1 = Variable format
		For indexed files, the recording mode field of the .idx file takes precedence.
49	5	Not used. Set to zeros.
54	4	Maximum record length. Example: with a maximum record of length 80 characters, 
		this field will contain x"00 00 00 50".
58	4	Minimum record length. Example: with a minimum record length of 2 characters, 
		this field will contain x"00 00 00 02".
62	46	Not used. Set to zeros.
108	4	Version and build data for the indexed file handler creating the file. Indexed files only.
112	16	Not used. Set to zeros.
*/

// Get len of header

// Verify max len of record  < 4095 or >= 4095
/*
int SetHeaderInfo(struct job_t* job, unsigned char* szHead)
{


	unsigned int nHeadLen = 0;
	unsigned int nMaxRekLen = 0;
	unsigned int nMinRekLen = 0;
	int nLen = 0;  // 1 < 4095 , 2 >= 4095
	char szTmp[10];

	memset(szHead, 0x00, HEADER_MF);  // set 0x00 to Header
	nLen = job->outputFile->maxLength;

	if (nLen < 4095){ // x"30 7E 00 00"
		szHead[0] = 0x30;
		szHead[1] = 0x7E;
		szHead[2] = 0x00;
		szHead[3] = 0x00;
	}
	else			  // x"30 00 00 7C".
	{
		szHead[0] = 0x30;
		szHead[1] = 0x00;
		szHead[2] = 0x00;
		szHead[3] = 0x7C;
	}
	//
	szHead[36] = 0x00;
	szHead[37] = 0x3E;

	szHead[39] = 0x01;

	szHead[48] = 0x01;	// Variable


	memset(szTmp, 0x00, 10);

	nMinRekLen = file_getRecordLength(job->outputFile);
	nMaxRekLen = file_getMaxLength(job->outputFile);

	nMinRekLen = Endian_DWord_Conversion(nMinRekLen);
	nMaxRekLen = Endian_DWord_Conversion(nMaxRekLen);

	memcpy(szHead+58, &nMinRekLen, 4);
	memcpy(szHead+54, &nMaxRekLen, 4);

	return 0;
}
*/
INLINE int job_IdentifyBufMerge(unsigned char** ptrBuf, int nMaxElements)
{
	unsigned char* ptr;
	int p=0;
	int posAr=-1;
	int nRes = 0;
	ptr= ptrBuf[0];
	
	for (p=0; p<nMaxElements; p++) { // search first buffer not null
		if (ptrBuf[p] != 0x00) { 
			ptr=ptrBuf[p];
			posAr = p;
			break;
		}
	}

	// check if FIELDS=COPY
	// For FIELDS=COPY get first pointer valid
	if (job_GetFieldCopy() == 0) // No Field Copy
	{
		for (p=posAr+1; p<nMaxElements; p++)
		{
			if (ptrBuf[p] == 0x00)
				continue;
			nRes = job_compare_rek( ptr,  ptrBuf[p], 0);	// No check pospnt
			if (nRes > 0) {
				ptr = ptrBuf[p];
				posAr = p;
			}
		}
	}
	return posAr;
}


int job_merge_files(struct job_t *job) {

	struct file_t *file;
	int  position_buf_write=0;
	int retcode_func=0;
	int desc=0;
	int k;
	int previousRecord=-1;
	int useRecord;
	unsigned char	*recordBuffer;
	unsigned char	*recordBufferPrevious;  // for SUm Fileds NONE
	int  nMaxFiles = MAX_FILES_INPUT;		// size of elements
	unsigned char	szBufRek[MAX_FILES_INPUT][32768];	// key
	unsigned char	szBufKey[MAX_FILES_INPUT][1024];	// key
	int				ArrayIsEOF[MAX_FILES_INPUT];
	int				Arrayhandle[MAX_FILES_INPUT];
	struct file_t*  Arrayfile_s[MAX_FILES_INPUT];
	int				recordBufferLength;
	int				bTempEof=0;
	int				nCompare = 1;
	int64_t			lPosPnt = 0;
	unsigned int	nLenRek = 0;
	unsigned int	nLenRecOut=0;

	int nLastRead=0;
	int bFirstRound=0;

	int bIsFirstTime = 1;
	unsigned char* ptrBuf[MAX_FILES_INPUT];

	int nPosPtr, nIsEOF;
	int nPosition = 0;
	int nbyteRead;

	struct BufferedReader_t* ArrayFile[MAX_FILES_INPUT];
	int	handleFile[MAX_FILES_INPUT];
	int byteReadFile[MAX_FILES_INPUT];
	int	bIsEof[MAX_FILES_INPUT];
	int kj;
	int nMaxEle;
	int nNumBytes = 0;
	int nIdxFileIn = 0;
	int  nLenInRec = 0;
	unsigned char* szBuffRek;
	int	nSumEof;
	int nIdx1; //, bIsEOF;
	int nEWC=0;
	int nSplitPosPnt = 0;		// for pospnt
	char  szNameTmp[FILENAME_MAX];
	unsigned char* bufferwriteglobal;

	unsigned char	szKeyTemp[1024+SIZEINT64];
	unsigned char	szKeyCurr[1024+SIZEINT64];
	unsigned char	szKeyPrec[1024+SIZEINT64];
	unsigned char	szKeySave[1024+SIZEINT64];
	unsigned char*	szPrecSumFields;	// Prec
	unsigned char*	szSaveSumFields; // save
	unsigned int	nLenSave=0;
	unsigned int	nLenPrec = 0;
	int bIsWrited = 0;
	int	bIsFirstSumFields = 0;

	recordBufferLength=MAX_RECSIZE;   //(job->outputLength>job->inputLength?job->outputLength:job->inputLength);


	bufferwriteglobal=(unsigned char*) malloc(MAX_SIZE_CACHE_WRITE);
	if (bufferwriteglobal == 0)
		fprintf(stderr,"*OCSort*S091* Cannot Allocate bufferwriteglobal : %s\n", strerror(errno));


	szPrecSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szPrecSumFields == 0)
		fprintf(stderr,"*OCSort*S098K* Cannot Allocate szPrecSumFields : %s\n", strerror(errno));

	szSaveSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szSaveSumFields == 0)
		fprintf(stderr,"*OCSort*S098R* Cannot Allocate szSaveSumFields : %s\n", strerror(errno));


	job->nLenKeys = job_GetLenKeys();
	job->nLastPosKey = job_GetLastPosKeys();

	if (job->nLastPosKey <= NUMCHAREOL)
		job->nLastPosKey = NUMCHAREOL;	// problem into memchr

	for (k=0; k<nMaxFiles; k++)
	{
		ArrayIsEOF[k] = 1;
		byteReadFile[k] = 0;
		Arrayhandle[k] = 0;
		memset(szBufKey[k], 0x00, 1024);
		memset(szBufRek[k], 0x00, 32768);
		ptrBuf[k] = 0x00;   //(unsigned char*)szBufRek[k];
	}
	recordBufferLength=MAX_RECSIZE;    //(job->outputLength>job->inputLength?job->outputLength:job->inputLength);
	// onlyfor Line Sequential
	if (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL)
		recordBufferLength=recordBufferLength+2+1;

	recordBuffer=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*OCSort*S057* Cannot Allocate recordBuffer : %s\n", strerror(errno));

	recordBufferPrevious=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*OCSort*S058* Cannot Allocate recordBuffer : %s\n", strerror(errno));

	szBuffRek=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRek == 0)
		fprintf(stderr,"*OCSort*S059* Cannot Allocate szBuffRek : %s\n", strerror(errno));

	for (kj=0; kj < MAX_FILES_INPUT;kj++) {
		byteReadFile[kj] = 0;
		handleFile[kj] = 0;
		bIsEof[kj] = 1;
		ArrayFile[kj] = NULL;
	}

// new
// Verify segmentation and if last section of file input
//
	if (job->outfil == NULL) {
		if ((desc=open(file_getName(job->outputFile),_O_WRONLY | O_BINARY | _O_CREAT | _O_TRUNC, _S_IREAD | _S_IWRITE))<0) {
			fprintf(stderr,"*OCSort*S061* Cannot open file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			retcode_func = -1;
			goto job_merge_files_exit;
		}
		// Generate Header MF and Write header
//future use		if (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_SEQUENTIALMF) {
//future use			file_SetMF(job->outputFile);
//future use			job->outputFile->pHeaderMF = (unsigned char *) malloc(HEADER_MF);
//future use			SetHeaderInfo(job, job->outputFile->pHeaderMF);
//future use			write(desc, job->outputFile->pHeaderMF, HEADER_MF);  
//future use		}
	}
	if (job->outfil != NULL) {
		if (outfil_open_files( job ) < 0) {
			retcode_func = -1;
			goto job_merge_files_exit;
		}
	}


	bFirstRound = 1;
	bIsFirstTime = 1;
	nLastRead=0;
	// Open files for Merge
	nIdx1 = 0;
	nSumEof = 0;
	for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
		strcpy(szNameTmp, file_getName(file));
// Save reference for file 
		Arrayfile_s[nIdx1] = file;
		bIsEof[nIdx1]=0;
// Attenzione prevedere la tipologia di open e l'eventuale presenza di header MF		
		ArrayFile[nIdx1] = BufferedReaderConstructor();
		BufferedReader_SetFileType(ArrayFile[nIdx1], job->inputFile->nOrgType);
		handleFile[nIdx1] = BufferedReader_open_file(ArrayFile[nIdx1], szNameTmp);
		
		file->handleFile=handleFile[nIdx1];
		if (handleFile[nIdx1] < 0){
			fprintf(stderr,"*OCSort*S062* Cannot open file %s : %s\n",szNameTmp,strerror(errno));
			retcode_func = -1;
			goto job_merge_files_exit;
		}
// -- //
//future use		if (file_getOrganization(file) == FILE_ORGANIZATION_SEQUENTIALMF)
//future use		{
//future use			file_SetMF(job->outputFile);
//future use			file->pHeaderMF =(unsigned char *) malloc(HEADER_MF);
//future use			nbyteRead = read(Arrayhandle[nIdx1], file->pHeaderMF, HEADER_MF);
//future use			if (nbyteRead != 128)
//future use			{
//future use				fprintf(stderr,"Error reading header file (128Byte) file %s : %s\n",file_getName(file),strerror(errno));
//future use				retcode_func = -1;
//future use				goto job_merge_files_exit;
//future use			}
//future use			//-->>
//future use			GetHeaderInfo(job, file->pHeaderMF); // Analyze header for file seq MF
//future use		}
//
			bIsEof[nIdx1] = job_ReadFileMerge(ArrayFile[nIdx1], Arrayfile_s[nIdx1], &handleFile[nIdx1], &byteReadFile[nIdx1], szBufRek[nIdx1], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
			if (bIsEof[nIdx1] == 0)
				ptrBuf[nIdx1] = (unsigned char*)szBufRek[nIdx1];
		//}
//
		nIdx1++;
		if (nIdx1 > nMaxFiles){
			fprintf(stderr,"Too many files input for MERGE Actual/Limit: %d/%d\n",nIdx1, nMaxFiles);
			retcode_func = -1;
			goto job_merge_files_exit;
		}
	}
// in this point nIdx1 is max for number of files input
// 
	nIsEOF = 0; // nMaxFiles;
//onlydebug 	nCount = 0;
	nPosition = 0;
	 // bIsEof = 0 ok, 1 = eof
	

	nSumEof = 0;
	for (kj=0; kj < MAX_FILES_INPUT;kj++) {
		nSumEof = nSumEof + bIsEof[kj];
	}

	bFirstRound = 0;
	bIsFirstTime = 0;

	nMaxEle = MAX_FILES_INPUT;
	if (nIdx1 < MAX_FILES_INPUT)
		nMaxEle = nIdx1;
		//nMaxEle = nIdx1 + 1;	// element 0 can is empty

	nPosPtr = job_IdentifyBuf(ptrBuf, nMaxEle);

	if (nPosPtr >= 0) {
		job_GetKeys(szBufRek[nPosPtr], szKeyTemp);		// for merge no POSPNT
		SumField_ResetTot(job); // reset totalizer
		bIsFirstSumFields = 1;
		nLenRek = byteReadFile[nPosPtr];
		memset(szKeyPrec, 0x00, SIZEINT64);
		memmove(szKeyPrec+SIZEINT64, szKeyTemp, job->nLenKeys);
		memmove(szPrecSumFields, szBufRek[nPosPtr], nLenRek);
		nLenPrec = nLenRek;
		memset(szKeySave, 0x00, SIZEINT64);
		memcpy(szKeySave+SIZEINT64,		szKeyPrec, job->nLenKeys);			   //lPosPnt + Key
		memcpy(szSaveSumFields, szPrecSumFields, nLenPrec);
		nLenSave = nLenPrec;
	}


	while ((nSumEof) < MAX_FILES_INPUT) //job->nNumTmpFile)
	{		

			// nLenRecOut = job->outputLength;
			nLenRecOut = file_getMaxLength(job->outputFile);

// start of check
// Identify buffer 
		nPosPtr = job_IdentifyBufMerge(ptrBuf, nMaxEle);

// Setting fields for next step (Record, Position, Len)	
// Setting buffer for type fle
//
		// Padding record output
		if (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) 
			memset(recordBuffer, 0x20, job->outputFile->maxLength+SIZEINT64);
		else
			memset(recordBuffer, 0x00, job->outputFile->maxLength+SIZEINT64);
		
		memcpy(recordBuffer, szBufRek[nPosPtr], byteReadFile[nPosPtr]);

		nLastRead = nPosPtr;
		nbyteRead = byteReadFile[nPosPtr];
		job->LenCurrRek = byteReadFile[nPosPtr];
		nLenRek = nbyteRead;
		job->recordNumberTotal++;

//-->>printf("%s\n", recordBuffer);


// new version for SUM FIELDS
		useRecord=1;

// new new new  INCLUDE - OMIT
		if (useRecord==1 && job->includeCondField!=NULL && condField_test(job->includeCondField,(unsigned char*) recordBuffer, job)==0) 
			useRecord=0;
		if (useRecord==1 && job->omitCondField!=NULL && condField_test(job->omitCondField,(unsigned char*) recordBuffer, job)==1) 
			useRecord=0;
// INREC
		if (useRecord == 1) {
			if (job->inrec!=NULL) {
				memset(szBuffRek, 0x20, recordBufferLength);
				// nLenInRec = inrec_copy(job->inrec, szBuffRek, recordBuffer, job->outputLength, job->inputLength, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, 0);
				nLenInRec = inrec_copy(job->inrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, 0);
				if (recordBufferLength < nLenInRec)
					recordBuffer= (unsigned char*) realloc(recordBuffer,nLenInRec+1);
				memcpy(recordBuffer, szBuffRek, nLenInRec );
				job->LenCurrRek = nLenInRec;
				nLenRek = nLenInRec;
			}
		}
// INREC
		if (useRecord==1) {
// SUMFIELD			1 = NONE
			if (job->sumFields==1) {
				if (previousRecord!=-1) {
					// check equal key
					if (job_compare_rek(recordBufferPrevious, recordBuffer, 0)==0)  // sumfield no check pospnt
						useRecord=0;
				}
				// enable check for sum fields
				previousRecord=1;
				memcpy(recordBufferPrevious, recordBuffer, job->LenCurrRek); 
			}
// SUMFIELD			2 = FIELDS
			if (job->sumFields==2) {
				job_GetKeys(recordBuffer, szKeyTemp); 
				// MERGE NO CHECK FOR POSPNT memcpy(szKeyCurr,    szBufRek[nPosPtr], 8);			//lPosPnt
				memset(szKeyCurr,  0x00, SIZEINT64);				//Key
				memcpy(szKeyCurr+SIZEINT64,  szKeyTemp, job->nLenKeys);				//Key
				useRecord = SumFields_KeyCheck(job, &bIsWrited, szKeyPrec, &nLenPrec, szKeyCurr,  &nLenRek, szKeySave,  &nLenSave, 
                                           szPrecSumFields, szSaveSumFields, recordBuffer, 0);
			}

			if (useRecord==0){	// skip record 
				if (bIsEof[nLastRead] == 0){
 					bIsEof[nLastRead] = job_ReadFileMerge(ArrayFile[nLastRead], Arrayfile_s[nLastRead], &handleFile[nLastRead], &byteReadFile[nLastRead], szBufRek[nLastRead], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
					if (bIsEof[nLastRead] == 1) {
						ptrBuf[nLastRead] = 0x00;
						nSumEof = nSumEof + bIsEof[nLastRead];
					}
				}
				continue;
			}

			job->LenCurrRek = nLenRek;
			
			// Write record len
//future use				if (file_GetMF(job->outputFile) == 1) //->bIsSeqMF == 1)
//future use					nPosition+=4; 
			if (job->outrec!=NULL) {
				memset(szBuffRek, 0x20, recordBufferLength);
				//-->>nbyteRead = outrec_copy(job->outrec, szBuffRek, recordBuffer, job->outputLength, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
				nbyteRead = outrec_copy(job->outrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
				memcpy(recordBuffer, szBuffRek, nbyteRead);
				job->LenCurrRek = nbyteRead ;
				nLenRek = nbyteRead;
				nLenRecOut = nLenRek; // Force record length 

			}
			if ((nbyteRead > 0) && (job->outfil == NULL)){
//
				if (job->sumFields==2) {
					bIsWrited = 1;
					SumField_SumFieldUpdateRek((unsigned char*)recordBuffer);		// Update record in  memory
					SumField_ResetTot(job);									// reset totalizer
					SumField_SumField((unsigned char*)szPrecSumFields);			// Sum record in  memory
				}				
//
		// ?? nLenRecOut = nLenRek;
			if (job_write_output(nLenRecOut, nLenRek, job, desc, nSplitPosPnt, recordBuffer, bufferwriteglobal, &position_buf_write) != 0) {
				retcode_func = -1;
				goto job_merge_files_exit;
			}
			job->recordWriteOutTotal++;
	//-->> debug 		printf("%ld;%ld;%ld;\n", job->recordWriteOutTotal, nPosition, byteRead);
			}
			// OUTFIL
			if ((job->LenCurrRek > 0) && (job->outfil != NULL)){
				if (outfil_write_buffer(job, recordBuffer, job->LenCurrRek, szBuffRek, nSplitPosPnt) < 0) { 
					retcode_func = -1;
					goto job_merge_files_exit;
				}
				job->recordWriteOutTotal++;
			}
		}
		if (bIsEof[nLastRead] == 0){
 			bIsEof[nLastRead] = job_ReadFileMerge(ArrayFile[nLastRead], Arrayfile_s[nLastRead], &handleFile[nLastRead], &byteReadFile[nLastRead], szBufRek[nLastRead], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
			if (bIsEof[nLastRead] == 1) {
				ptrBuf[nLastRead] = 0x00;
				nSumEof = nSumEof + bIsEof[nLastRead];
			}
		}

	}

// 
	if ((job->sumFields==2) && (bIsWrited == 1)) {   // pending buffer
		SumField_SumFieldUpdateRek((char*)szPrecSumFields);				// Update record in  memory
		memcpy(recordBuffer, szPrecSumFields, nLenPrec);		// Substitute record for write
		nLenRek = nLenPrec;
		//-->>nLenRecOut = job->outputLength;
        if (job_write_output(nLenRecOut, nLenRek, job, desc, nSplitPosPnt, recordBuffer, bufferwriteglobal, &position_buf_write) != 0) {
            retcode_func = -1;
			goto job_merge_files_exit;
        }
        job->recordWriteOutTotal++;
	}

	if (job->outfil == NULL) {
		if (write_buffered_final(desc, &bufferwriteglobal, &position_buf_write)<0) {
            fprintf(stderr,"*OCSort*S095* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
            retcode_func = -1;
            goto job_merge_files_exit;
		}
	}

job_merge_files_exit:

	free(bufferwriteglobal);
	free(szBuffRek);
	free(recordBuffer);
	free(recordBufferPrevious);
	free(szPrecSumFields);
	free(szSaveSumFields);

	for (kj=0; kj < MAX_HANDLE_TEMPFILE; kj++) { 
		if (ArrayFile[kj] != NULL) {
			BufferedReaderDestructor(ArrayFile[kj]);
			if(Arrayfile_s[kj]->handleFile != -1)
				close(Arrayfile_s[kj]->handleFile);
		}
	}

	if (desc > 0) {
		if ((close(desc))<0) {
			fprintf(stderr,"*OCSort*S067* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			return -1;
		}
	}
	return retcode_func;
//	return 0;
//}
}
INLINE int job_ReadFileMerge(struct BufferedReader_t * reader, struct file_t* file, int* descTmp, int* nLR, unsigned char* szBuffRek, int nFirst)
{
    unsigned int lenBE = 0;
	int bTempEof=0;
	int nLenRek=0;
	int nbyteRead=0; 
	nLenRek = file_getMaxLength(file);

	switch (file->nOrgType) {
//
	case FILE_ORGTYPE_IXFIX		: 
	case FILE_ORGTYPE_IXVAR		: 
	case FILE_ORGTYPE_RLFIX		:
	case FILE_ORGTYPE_RLVAR		:
    	fprintf(stderr,"*OCSort*S068* FileOrganization error  %d\n",file->nOrgType);
		bTempEof = 1;
		nLenRek = 0;
		*nLR = 0;
		//*ptrBuf=0;
		break;
//
	case FILE_ORGTYPE_SQFIX		:
		//-->>          memset(szBuffRek, 0x00, 32768); 
		BufferedReader_byn_next_record(reader, *descTmp, nLenRek, nFirst, (unsigned char*) szBuffRek);
		nbyteRead = (int)reader->nLenLastRecord;
		if (nbyteRead <= 0) {
			bTempEof = 1;
			*nLR = 0;
			// *ptrBuf=0;
			return bTempEof;
		}
		nLenRek = nbyteRead; 
		break;
//
	case FILE_ORGTYPE_SQVAR		:
		BufferedReader_byn_next_record(reader, *descTmp, SIZEINT, nFirst, (unsigned char*) &lenBE);
		nbyteRead = (int)reader->nLenLastRecord;
		if ((nbyteRead != SIZEINT) || (lenBE <= 0)) {
			memset(szBuffRek, 0xFF, SIZEINT); 
			bTempEof = 1;
			// *ptrBuf=0;
			*nLR = 0;
			return bTempEof;
		}
		nLenRek=Endian_Word_Conversion(lenBE);
		//-->>memset(szBuffRek, 0x00, 32768); 
		BufferedReader_byn_next_record(reader, *descTmp, nLenRek, 0, (unsigned char*) szBuffRek);
		nbyteRead = (int)reader->nLenLastRecord;
		if (nbyteRead <= 0) {
			bTempEof = 1;
			*nLR = 0;
			// *ptrBuf=0;
			return bTempEof;
		}
		nLenRek = nbyteRead; 
		break;
//
	case FILE_ORGTYPE_LSFIX		:
	case FILE_ORGTYPE_LSVAR		:
		nbyteRead=read_textfile_buff(file->handleFile, szBuffRek, nLenRek, reader, nFirst, globalJob->nLastPosKey);
		if ((nbyteRead < 1)) {
			bTempEof = 1;
			*nLR = 0;
			// *ptrBuf=0;
			return bTempEof;
		}
		nLenRek = nbyteRead; 
		break;
//
	case FILE_ORGTYPE_SQFIXMF	:
		break;
//
	case FILE_ORGTYPE_SQVARMF	:
		break;
	}
	*nLR = nLenRek;
	return bTempEof;
}

/*
--------------------------------------------------------------------------------------------------------------------
PADDING / TRUNCATING
--------------------------------------------------------------------------------------------------------------------
Line Sequential
--------------------------------------------------------------------------------------------------------------------
LenIn = LenOut      |	Input	Fixed		| Output	Fixed		| Use LenOut + Append EOL  
LenIn < LenOut		|	Input   Fixed		| Output	Fixed		| Use LenOut + PADDING with space + append EOL
LenIn > LenOut		|	Input   Fixed		| Output	Fixed		| Use LenOut + TRUNCATE + append EOL
--------------------------------------------------------------------------------------------------------------------
LenIn = LenOut      |	Input	Fixed		| Output	Variable	| Force LenIn into LenOut + append EOL
LenIn < LenOut		|	Input   Fixed		| Output	Variable	| Force LenIn into LenOut + append EOL
LenIn > LenOut		|	Input   Fixed		| Output	Variable	| Use LenOut + TRUNCATE + append EOL
--------------------------------------------------------------------------------------------------------------------
LenIn = LenOut      |	Input	Variable	| Output	Fixed		| Use LenOut + Append EOL 
LenIn < LenOut		|	Input   Variable	| Output	Fixed		| Use LenOut + PADDING with space + append EOL
LenIn > LenOut		|	Input   Variable	| Output	Fixed		| Use LenOut + TRUNCATE + append EOL
--------------------------------------------------------------------------------------------------------------------
LenIn = LenOut      |	Input	Variable	| Output	Variable	| Force LenIn into LenOut + append EOL
LenIn < LenOut		|	Input   Variable	| Output	Variable	| Force LenIn into LenOut + append EOL
LenIn > LenOut		|	Input   Variable	| Output	Variable	| Use LenOut + TRUNCATE + append EOL
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
Sequential
--------------------------------------------------------------------------------------------------------------------
LenIn = LenOut      |	Input	Fixed		| Output	Fixed		| Use LenOut
LenIn < LenOut		|	Input   Fixed		| Output	Fixed		| Use LenOut + PADDING with null
LenIn > LenOut		|	Input   Fixed		| Output	Fixed		| Use LenOut + TRUNCATE 
--------------------------------------------------------------------------------------------------------------------
LenIn = LenOut      |	Input	Fixed		| Output	Variable	| Force LenIn into LenOut 
LenIn < LenOut		|	Input   Fixed		| Output	Variable	| Force LenIn into LenOut 
LenIn > LenOut		|	Input   Fixed		| Output	Variable	| Use LenOut + TRUNCATE 
--------------------------------------------------------------------------------------------------------------------
LenIn = LenOut      |	Input	Variable	| Output	Fixed		| Use LenOut 
LenIn < LenOut		|	Input   Variable	| Output	Fixed		| Use LenOut + PADDING with null 
LenIn > LenOut		|	Input   Variable	| Output	Fixed		| Use LenOut + TRUNCATE 
--------------------------------------------------------------------------------------------------------------------
LenIn = LenOut      |	Input	Variable	| Output	Variable	| Force LenIn into LenOut 
LenIn < LenOut		|	Input   Variable	| Output	Variable	| Force LenIn into LenOut 
LenIn > LenOut		|	Input   Variable	| Output	Variable	| Use LenOut + TRUNCATE 
--------------------------------------------------------------------------------------------------------------------

*/
INLINE int job_write_output( unsigned int nLenRecOut, unsigned int nLenRek, struct job_t* job, int desc, int nSplitPosPnt, unsigned char* recordBuffer, unsigned char* bufferwriteglobal, int* position_buf_write)
{
    int retcode_func=0;
    int nEWC=0;

	//nLenRecOut = job->outputLength;
	// For File Variable force input length in output len
	if  ((file_getFormat(job->outputFile) == FILE_TYPE_VARIABLE) &&	 (nLenRek < nLenRecOut))
			nLenRecOut = nLenRek;

	// Padding or truncate record output
	// Only for FIXED and when length not equal for input/output
    if ((nLenRek < nLenRecOut) && (file_getFormat(job->outputFile) == FILE_TYPE_FIXED)) {
        if (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_SEQUENTIAL) 
			memset(recordBuffer+nSplitPosPnt+nLenRek, 0x00, nLenRecOut - nLenRek); // padding
        if (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) 
            memset(recordBuffer+nSplitPosPnt+nLenRek, 0x20, nLenRecOut - nLenRek); // padding
    }
	
//    if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) &&
//        (job->bIsPresentSegmentation == 0)) {

	// Insert terminator EndOfLine for Line Sequential
    if (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) { 
#ifndef _WIN32
            (recordBuffer+nSplitPosPnt)[nLenRecOut] = 0x0a;
                nLenRecOut+=1;
#else
            (recordBuffer+nSplitPosPnt)[nLenRecOut]   = 0x0d;
            (recordBuffer+nSplitPosPnt)[nLenRecOut+1] = 0x0a;
            nLenRecOut+=2;
#endif
    }
	// Check for insert record length
    // File Variable, get lenght but not for Line Sequential
    if ((file_getFormat(job->outputFile) == FILE_TYPE_VARIABLE) && 
        (file_getOrganization(job->outputFile) != FILE_ORGANIZATION_LINESEQUENTIAL))
    {
        nEWC = Endian_Word_Conversion(nLenRecOut);
        write_buffered(desc, (unsigned char*)&nEWC, SIZEINT, &bufferwriteglobal, position_buf_write);
    }
    if (write_buffered(desc, (unsigned char*)recordBuffer+nSplitPosPnt, nLenRecOut, &bufferwriteglobal, position_buf_write)<0) {
        fprintf(stderr,"*OCSort*S023* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
        if ((close(desc))<0) {
            fprintf(stderr,"*OCSort*S024* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
        }
        retcode_func = -1;
    }

    return retcode_func;
}

INLINE int64_t utils_GetValueRekBIFI(unsigned char* pRek, int nLenField, int nType) {

	n64Var=0;
	if (globalJob->nByteOrder == 1)
		ucSignField = ((unsigned char*) pRek) [0];
	else
		ucSignField = ((unsigned char*) pRek)[nLenField-1];// byte for sign littel endian
	if ((ucSignField & (1 << 7))) 
		memset(szBufBIFI,0xff, sizeof(szBufBIFI));
	else
		memset(szBufBIFI,0x00, sizeof(szBufBIFI));
	memcpy((unsigned char*) szBufBIFI+SIZEINT64-nLenField, (unsigned char*) pRek, nLenField);
	if (globalJob->nByteOrder == 1)
		memcpy(&n64Var, (unsigned char*) szBufBIFI, SIZEINT64);
	else
		memcpy((unsigned char*)&n64Var, (unsigned char*) pRek, nLenField);
	if (globalJob->nByteOrder == 1) 
		n64Var = COB_BSWAP_64(n64Var);
//-->>20160207	if (nType == FIELD_TYPE_BINARY)	// BI 
//-->>20160207		if (n64Var < 0)		// only unsigned
//-->>20160207			n64Var *=-1;
	return n64Var;
}


