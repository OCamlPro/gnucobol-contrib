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
#include <libcob.h>
#include <io.h> 
#include <fcntl.h> 
#include <share.h>
#include <string.h>
#include <stddef.h>
#include <string.h>
#include <math.h>
#include <windows.h>
#include <time.h>
#include <process.h>
//-->> #include "oclib.h"
#include "ocsort.h"
#include "job.h"
#include "file.h"
#include "sortfield.h"
#include "condfield.h"
#include "outrec.h"
#include "inrec.h"
#include "parser.h"
#include "scanner.h"
#include "sortfield.h"
#include "SumField.h"
#include "utils.h"
#include "outfil.h"
#include "mmfioc.h"
#include "bufferedreader.h"
#include "bufferedwriter.h"
//#include "RunLength.h"

#define _CRTDBG_MAP_ALLOC
#include <stdlib.h>

#ifdef _MSC_VER
	#include <crtdbg.h>
#endif

int g_lenRek = -1;

int nTypeFieldsCmd = 0;
unsigned char    szBufPK1[128];
unsigned char    szBufPK2[128];
unsigned int        SPK1, SPK2, SPK1x, SPK2x;
int 	bIsNegSPK1;
int 	bIsNegSPK2;
int64_t lPosA = 0;
int64_t lPosB = 0;
int result=0;
struct sortField_t *sortField;
int nSp=0;

char szHeaderOutMF[128];
long nSpread = 0;

int	nLenMemory=0;

HANDLE hEvent1, hEvent2;
static char * cobc_temp_name(const char * ext);


int yyparse ();

void job_SetCmdLine(struct job_t* job, char* strLine)
{
	// attention
	// check characters spacial  0x09
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
	char chPath[MAX_PATH1];

	int nOp;
	int nJ=0;

	job->ndeb = 0;
	job->nStatistics=1;
	job->outputFile=NULL;
	job->inputFile=NULL;
	job->sortField=NULL;
	job->includeCondField=NULL;
	job->omitCondField=NULL;
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
	job->bReUseSrtFile = 0;
	job->lPosAbsRead=0;
	job->lPositionFile=0;
	job->ulMemSizeRead=0;
	job->bIsPresentSegmentation=0;
	job->nIndextmp  = 0;
	job->nIndextmp2 = 0;
	job->nMaxHandle = 0;
	memset(job->array_FileTmpHandle, -1, sizeof(job->array_FileTmpHandle));
	for (nJ=0; nJ < MAX_HANDLE_TEMPFILE; nJ++)
		job->nCountSrt[nJ]=0;
	job->nSkipRec=0;
	job->nStopAft=0;
	job->strPathTempFile[0]=0x00; //NULL;
	memset(job->arrayFileInCmdLine, 0x00, (256*MAX_PATH1));
	job->nMaxFileIn=0;
	memset(job->arrayFileOutCmdLine, 0x00, (256*MAX_PATH1));
	job->nMaxFileOut=0;
	job->ulMemSizeAlloc		= OCSORT_ALLOCATE_MEMSIZE;
	job->ulMemSizeAllocSort = OCSORT_ALLOCATE_MEMSIZE/100*10;		// 
	job->nLastPosKey = 0;	// Last position of key
	job->nTestCmdLine=0;
	job->nSlot = MAX_SLOT_SEEK;
	job->nMlt  = MAX_MLTP_BYTE;
// verify Environment variable for emulation
// 0 = OCSORT normal operation
// 1 = OCSORT emulates MFSORT 
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

// verify Environment variable for memory allocation
	pEnvMemSize = getenv ("OCSORT_MEMSIZE");
	if (pEnvMemSize!=NULL)
	{
		job->ulMemSizeAlloc = atol(pEnvMemSize);
		if (job->ulMemSizeAlloc == 0) {
			job->ulMemSizeAlloc = OCSORT_ALLOCATE_MEMSIZE;
			job->ulMemSizeAllocSort = OCSORT_ALLOCATE_MEMSIZE/100*10;
		} 
		else
		{
			job->ulMemSizeAllocSort = job->ulMemSizeAlloc/100*10;
		}

	}

	pEnvEmule = getenv ("OCSORT_TESTCMD");
	if (pEnvEmule!=NULL)
	{
		job->nTestCmdLine = atol(pEnvEmule);
		if ((job->nTestCmdLine != 0) && (job->nTestCmdLine != 1)){
				fprintf(stderr,"OCSORT - Error on OCSORT_TESTCMD parameter. Value 0 for normal operations , 1 for ONLY test command line. Value Environment: %ld\n", job->nTestCmdLine );
				fprintf(stderr,"OCSORT - Forcing  OCSORT_TESTCMD = 0\n");
				job->nTestCmdLine = 0;
		}
	}
	pEnvEmule = getenv ("OCSORT_STATISTICS");
	if (pEnvEmule!=NULL)
	{
		job->nStatistics = atol(pEnvEmule);
		if ((job->nStatistics != 0) && (job->nStatistics != 1) && (job->nStatistics != 2)){
				fprintf(stderr,"OCSORT - Error on OCSORT_STATISTICS parameter. Value 0 for suppress info , 1 for Sumamry, 2 for Details. Value Environment: %ld\n", job->nStatistics);
				fprintf(stderr,"OCSORT - Forcing  OCSORT_STATISTICS = 0\n");
				job->nStatistics = 1;
		}
	}
	pEnvEmule = getenv ("OCSORT_DEBUG");
	if (pEnvEmule!=NULL)
	{
		job->ndeb = atol(pEnvEmule);
		if ((job->ndeb != 0) && (job->ndeb != 1) && (job->ndeb != 2)){
				fprintf(stderr,"OCSORT - Error on OCSORT_DEBUG parameter. Value 0 for normal operations , 1 for DEBUG, 2 for DEBUG Parser. Value Environment: %ld\n", job->nTestCmdLine );
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
		if (chPath[strlen(chPath)-1] != '\\')
			strcat(chPath, "\\");
		strcat(chPath, "OCSRTTMP.TMP");
		nOp=remove(chPath);
		nOp=open(chPath, O_CREAT | O_WRONLY | O_BINARY | _O_TRUNC,  _S_IREAD | _S_IWRITE);
		if (nOp<0){
			printf("OCSORT Warning : Path not found %s\n", job->strPathTempFile);
		}
		close(nOp);
		remove(chPath);
	}

//
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
	pEnvEmule = getenv ("OCSORT_MLT");
	if (pEnvEmule!=NULL)
	{
		job->nMlt = atol(pEnvEmule);
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
	double  nPerc = (nLenKey + 8 + 4 + 8 ) / nLenRek * 100;
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
	char szTakeFile[MAX_PATH1];
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
			if (nTakeCmd == 1)
				strcpy(szTakeFile, argv[i]);
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
		printf("==============================================================================\n");
		printf("SORT ERROR \n");
		printf("Command line : %s\n", buffer);
		printf("==============================================================================\n");
		printf("\n");
	}

//-->>	
	yylex_destroy ();
// 
//
// 
// Clone informations from GIVE File for all OUTFIL files.
	if (returnCode == 0)
		returnCode = job_CloneFileForOutfil(job); 
//
	if (returnCode != 0){
		printf("SORT ERROR \n");
		printf("Command line : %s\n", buffer);
		printf("\n");
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
					printf("*OCSort*S084* ERROR: Problem with file name input %s, %s, %ld\n",job->inputFile->name, job->arrayFileInCmdLine[nPos], nPos--);
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
					printf("*OCSort*S085* ERROR: Problem with file name output %s, %s, %ld\n",job->outputFile->name, job->arrayFileOutCmdLine[nPos], nPos--);
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
	// Priority Search
	// USE ---- GIVE  or   GIVE --- USE

	pchUse	= strstr(buffer, strUSE);
	pchGive = strstr(buffer, strGIVE);


	if ((pchUse == NULL) || (pchGive == NULL))
		return -1;

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
	
	while(*pszBufIn == ' ')	{
		pszBufIn++;
		nLength--;
	}
	
	strncpy(pszBufOut, pszBufIn, nLength);
	pszBufOut[nLength] = 0x00;
	return nLength;
}

int	job_FileInputBuffer (struct job_t *job, char* szSearch, char* bufnew, int nPosStart)
{
	char szFileName[1024];
	char strUSE[]  = " USE ";
	char strORG[] = " ORG ";
	char strRECORD[]  = " RECORD ";
	char * pch1;
	char * pch2;
	char * pch3;
	int  nSp1=1;
	int  nSp2=0;
	int  nSp3=0;
	int  nFirstRound=0;
	int  pk=0;
	int nPosNull=0;
	// file input
	pch1=szSearch+nPosStart;
	pch2=szSearch+nPosStart;
	pch3=szSearch+nPosStart;
	job->nMaxFileIn=0;
	while (pch1 != NULL){
		pch1 = strstr (pch1, strUSE);
		if (pch1 != NULL){
			nSp1 = pch1 - szSearch;
			if (nFirstRound == 1) {
				strncat(bufnew, pch2, pch1-pch2 );
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
					strncat(bufnew, szSearch, nSp1);
					nFirstRound=1;
				} 
				// in questo punto aggiungere il nome file 
				nSp2 = pch2 - pch1 - strlen(strUSE);
				nPosNull = job_PutIntoArrayFile(job->arrayFileInCmdLine[job->nMaxFileIn], pch1+strlen(strUSE), nSp2);
				job->arrayFileInCmdLine[job->nMaxFileIn][nPosNull]=0x00;
				job->nMaxFileIn++;
				memset(szFileName, 0x00, 1024);
				sprintf(szFileName, " USE FI%03ld", job->nMaxFileIn); // new file name
				// alloc same dimension of file input for string
				if (nSp2 > (int)(strlen(szFileName))) { 
					for (pk=strlen(szFileName); pk < nSp2;pk++)
						 szFileName[pk]='A';
				}
				strcat(bufnew,		szFileName);	// concat new file name
				pch1 = pch2 + nSp3;
			}
		}
	}
	if (job->nMaxFileIn <= 0) {
		printf("*OCSort*S086* ERROR: Problem NO file input\n");
		return -1;
	}
	if (pch2 != NULL)
		strcat(bufnew, pch2);
	return (nSp1);
}


int	job_FileOutputBuffer (struct job_t *job, char* szSearch, char* bufnew, int nPosStart)
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
	int  nFirstRound=0;
	int  pk=0;
	int nPosNull = 0;
	// file input
	pch1=szSearch+nPosStart;
	pch2=szSearch+nPosStart;
	pch3=szSearch+nPosStart;
	job->nMaxFileOut=0;
	while (pch1 != NULL){
		pch1 = strstr (pch1, strGIVE);
		if (pch1 != NULL){
			nSp1 = pch1 - szSearch;
			if (nFirstRound == 1) {
				strncat(bufnew, pch2, pch1-pch2 );
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
					strncat(bufnew, szSearch, nSp1);
					nFirstRound=1;
				} 
				// in questo punto aggiungere il nome file 
				nSp2 = pch2 - pch1 - strlen(strGIVE);
				nPosNull = job_PutIntoArrayFile(job->arrayFileOutCmdLine[job->nMaxFileOut],  pch1+strlen(strGIVE), nSp2);
				job->arrayFileOutCmdLine[job->nMaxFileOut][nPosNull] = 0x00;
				job->nMaxFileOut++;
				memset(szFileName, 0x00, 1024);
				sprintf(szFileName, " GIVE FO%03ld", job->nMaxFileOut); // new file name
				// alloc same dimension of file input for string
				if (nSp2 > (int)(strlen(szFileName))) {
					for (pk=strlen(szFileName); pk < nSp2;pk++)
						szFileName[pk]='A';
				}
				strcat(bufnew,		szFileName);	// concat new file name
				pch1 = pch2 + nSp3;
			}
		}
	}
	if (job->nMaxFileOut <= 0) {
		printf("*OCSort*S087* ERROR: Problem NO file output\n");
		return -1;
	}
	if (pch2 != NULL)
		strcat(bufnew, pch2);
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
		printf("========================================================\n");
		printf("OCSORT\nFile TAKE : %s\n", szF);
		printf("========================================================\n");
	}
	if((pFile=fopen(szF, "rt"))==NULL) {
		fprintf(stderr, "\nUnable t open file %s", (char*)szF);
		exit(OC_RTC_ERROR);
	}
	numread = 1;
	maxLen=-1;
	nComm=0;
	memset(buf, 0x00, sizeof (4096));
		do {
			  c = fgetc (pFile);
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
	char szNameTmp[MAX_PATH1];
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
				file_stat_win(szNameTmp);
			}
		}
	}
	//-->>if (job->nStatistics == 1) {
		//-->>fprintf(stdout,"\n");
		fprintf(stdout,"Record Number Total       : %ld\n", job->recordNumberTotal);
		fprintf(stdout,"Record Write Sort Total   : %ld\n", job->recordWriteSortTotal);
		fprintf(stdout,"Record Write Output Total : %ld\n", job->recordWriteOutTotal);
		fprintf(stdout,"========================================================\n");
	//-->>}
	if (job->nStatistics == 2)	{
		if (job->bIsPresentSegmentation == 1) {
			for (nIdx=0; nIdx<MAX_HANDLE_TEMPFILE; nIdx++) {
				//if (job->nCountSrt[nIdx] > 0)
					fprintf(stdout,"job->nCountSrt[%02ld] %ld\n", nIdx, job->nCountSrt[nIdx]);
			}
		}

		fprintf(stdout,"\n");
		fprintf(stdout,"Memory size for OCSort   : %10ld\n", job->ulMemSizeAlloc);
		fprintf(stdout,"Memory size for OCSort2  : %10ld\n", job->ulMemSizeAllocSort);
		fprintf(stdout,"MAX_SLOT_SEEK                   : %ld\n", job->nSlot);
		fprintf(stdout,"MAX_MLTP_BYTE                   : %ld\n", job->nMlt);
		fprintf(stdout,"BufferedReader MAX_BUFFER       : %ld\n", MAX_BUFFER);
		fprintf(stdout,"Job MAX_SIZE_CACHE_WRITE        : %ld\n", MAX_SIZE_CACHE_WRITE);
		fprintf(stdout,"Job MAX_SIZE_CACHE_WRITE_FINAL	: %ld\n", MAX_SIZE_CACHE_WRITE_FINAL);
		if (job->m_SeekOrder == 0)
			fprintf(stdout,"Seek Order before Read    : NO\n");
		else
			fprintf(stdout,"Seek Order before Read    : YES\n");
		fprintf(stdout,"===============================================\n");
		fprintf(stdout,"\n");


		if (job->outfil != NULL){
			fprintf(stdout,"OUTFIL\n");
			for (pOutfil=job->outfil; pOutfil != NULL; pOutfil=outfil_getNext(pOutfil)) {
				for (file=pOutfil->outfil_File; file != NULL; file=file_getNext(file)) {
					fprintf(stdout,"File: %s, Record Write Total : %ld\n", pOutfil->outfil_File->name, pOutfil->recordWriteOutTotal);
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
		fprintf(stdout,"Elapsed  Time %02ldhh %02ldmm %02ldss %03ldms\n\n", hh, mm, ss, ms);
	//-->>}

	return 0;
}
	

int job_print(struct job_t *job) {
	struct file_t *file;
	struct sortField_t *sortField;
	struct outrec_t *outrec;
	struct inrec_t *inrec;
	struct SumField_t *SumField;
	struct outfil_t *outfil;

	printf("========================================================\n");
	printf("OCSort Version %s\n", OCSORT_VERSION);
	printf("========================================================\n");

	if (job->ndeb > 0) {
		printf("Command line \n");
		printf("%s\n\n", job_GetCmdLine(job));
	}

	if (job->nStatistics == 1) {
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
			fprintf(stderr,"SKIPREC = %ld\n", job->nSkipRec);

		if (job->nStopAft > 0)
			fprintf(stderr,"STOPAFT = %ld\n", job->nStopAft);

		if (job->includeCondField!=NULL) {
			printf("INCLUDE COND : (");
			condField_print(job->includeCondField);
			printf(")\n");
			}
		if (job->omitCondField!=NULL) {
			printf("OMIT COND : (");
			condField_print(job->omitCondField);
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
					printf("\t\tSTARTREC = %ld\n", outfil->outfil_nStartRec);
				if (outfil->outfil_nEndRec >= 0)
					printf("\t\tENDREC = %ld\n", outfil->outfil_nEndRec);
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
	struct outrec_t*		fPOut[128];
	struct inrec_t*			fPIn[128];
	struct outfil_t*		fPOutfilrec[128];
	struct condField_t*		fPCond[128];
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
	int bEOF;
	int bIsFirstLoop=0;
	unsigned int  nPosCurrentSeek = 0;
	long nRecCount = 0;
	unsigned char szBuffRek[OCSORT_MAX_BUFF_REK];
	unsigned char szBuffKey[OCSORT_MAX_BUFF_REK];
	unsigned char szBuffRekNull[OCSORT_MAX_BUFF_REK];

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
		// debug
		//-->> debug printf("job->bSegmentation = 0\n");
		// debug

	}
	else
	{
		 job->recordNumber=0;
		 bIsFirstTime=0;
		 lPosSeqLS = job->lPosAbsRead;
	}

	job->ulMemSizeRead = 0;
	job->ulMemSizeSort = 0;
	nIdxFileIn = -1;
	job->nLastPosKey = job_GetLastPosKeys();
	for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
		nIdxFileIn++;
		if (job->bIsPresentSegmentation == 0) 
		{
			struct stat filestatus;
		    stat( file_getName(file), &filestatus );
			job->inputFile->nFileMaxSize = filestatus.st_size;
			if ((job->desc=open(file_getName(file),O_RDONLY | O_BINARY))<0){
				fprintf(stderr,"*OCSort*S003* Cannot open file %s : %s\n",file_getName(file),strerror(errno));
				file_stat_win (file_getName(file));
				return -1;
			}
			if (file_getOrganization(file) == FILE_ORGANIZATION_SEQUENTIALMF){
				file_SetMF(file);  //				file->bIsSeqMF = 1;
				file->pHeaderMF =(unsigned char *) malloc(HEADER_MF);
				nbyteRead = read(job->desc, file->pHeaderMF, 128);
				if (nbyteRead != 128){
					fprintf(stderr,"Error reading header file (128Byte) file %s : %s\n",file_getName(file),strerror(errno));
					return -1;
				}
				GetHeaderInfo(job, file->pHeaderMF); // Analyze header for file seq MF
			}
			job->reader = BufferedReaderConstructor();
			BufferedReader_SetFileType(job->reader, FORG_LINESEQ);
			BufferedReader_getsize_file(job->reader, job->desc);
		} 
		///-->> Attenzione File Variabile necessario leggere i primi 4 byte per la lunghezza
		// -->> inserire una funzione read_file che consideri la lughezza record in funzione della tipologia FIXED - VARIABILE
		bEOF = 0;
		nLenMemory = file_getMaxLength(file);
		nLenRek = file_getRecordLength(file);
		while (bEOF == 0)
		{
			// File Variable, get lenght but not for Line Sequential
			if ((file_getFormat(file) == FILE_TYPE_VARIABLE) && 
				(file_getOrganization(file) != FILE_ORGANIZATION_LINESEQUENTIAL))
			{
				BufferedReader_byn_next_record(job->reader, job->desc, 4, bIsFirstTime, (unsigned char*)&nLenRek);
				nbyteRead = (int)job->reader->nLenLastRecord;
				bIsFirstTime = 0;
				if (nbyteRead < 1) {
					nbyteRead=0;
					bEOF = 1;
					continue;
				}

				if (nbyteRead != 4){
					bEOF = 1;
					continue;
				}
				if (file_GetMF(file) == 1){
					nLenRek = Endian_DWord_Conversion(nLenRek);
					nLenRek = nLenRek << 4;
					nLenRek = nLenRek >> 4;
					nLenRek = nLenRek + utils_GenPadSize(nLenRek); // +n byte pad end of record
				}
				else
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
				//-->>> new if (job->bIsPresentSegmentation == 0) {
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

			if ((job->nSkipRec > 0) && (nRecCount <= job->nSkipRec)) 
					continue;
			// attenzione in questo punto bisogna chiamare la funzione getkeys per prelevare le chiavi di ordinamento !!!
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
			memmove((unsigned char*) job->buffertSort+(job->recordNumber)*(job->nLenKeys+8+4+8)					  , (unsigned char*) &szBuffKey, job->nLenKeys);
			//PosPnt
			memmove((unsigned char*) job->buffertSort+(job->recordNumber)*(job->nLenKeys+8+4+8)+job->nLenKeys	  , (unsigned char*) &job->lPosAbsRead,   8); // PosPnt
			// len
			memmove((unsigned char*) job->buffertSort+(job->recordNumber)*(job->nLenKeys+8+4+8)+job->nLenKeys+8   , (unsigned char*) &job->LenCurrRek ,   4); // len
			// Pointer Address Data
			memmove((unsigned char*) job->buffertSort+(job->recordNumber)*(job->nLenKeys+8+4+8)+job->nLenKeys+8+4 , &pAddress				        ,  	8); // Pointer Address Data
			
			job->ulMemSizeRead = job->ulMemSizeRead + nLenRek; // key + pointer record + record length
			job->ulMemSizeSort = job->ulMemSizeSort + job->nLenKeys + 8 + 4 + 8;
			useRecord=1;
			if (useRecord==1 && job->includeCondField!=NULL && condField_test(job->includeCondField,(unsigned char*) szBuffRek, job)==0) {
				useRecord=0;
			}
			if (useRecord==1 && job->omitCondField!=NULL && condField_test(job->omitCondField,(unsigned char*) szBuffRek, job)==1) {
				useRecord=0;
			}

			if (useRecord==1) {
				job->recordNumber++;
// check StopAft
				if ((job->nStopAft > 0) && (job->recordNumber >= job->nStopAft)) {
						nbyteRead=0;
						break;
				}
//
				// check for next read record  
				if (((job->ulMemSizeRead + ((job->nLenKeys + 8 + 4 + nLenMemory) * 2)) >= job->ulMemSizeAlloc) ||
					((job->ulMemSizeSort + ((job->nLenKeys + 8 + 4 + 8) * 2)) >= job->ulMemSizeAllocSort))	{
					// seek for reposition pointer file
					job->lPosAbsRead = job->lPosAbsRead + nLenRek;
					job->lPositionFile = job->lPosAbsRead;
					job->bIsPresentSegmentation = 1;
					return -2;
				}
			}
		}
		
		if (nbyteRead==0) {
			// End of file
            } else if (nbyteRead==-1) {
			fprintf(stderr,"*OCSort*S004* Cannot read file %s : %s\n",file_getName(file),strerror(errno));
			file_stat_win (file_getName(file));
			return -1;
		} else {
			fprintf(stderr,"Wrong record length in file %s\n",file_getName(file));
			file_stat_win (file_getName(file));
			return -1;
		}
		if (job->reader != NULL) {
			if (job->reader->file_EOF == 1) {
				BufferedReader_close_file(job->reader);
				BufferedReaderDestructor(job->reader);
				job->reader = NULL;
				bIsFirstTime=1;
			}
		}
	}

	return 0;
}

int read_textfile_buff(int nHandle, unsigned char* pBufRek, int nMaxRek, struct BufferedReader_t * reader, int bIsFirstTime, int nLastPosKey)
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
		qsort(job->buffertSort, (size_t) job->recordNumber, job->nLenKeys+8+4+8, job_compare_qsort);  // check record position
	return 0;
}
int job_save(struct job_t *job) {
	int			   retcode_func = 0;
	int* bufferwriteglobal; // pointer for write buffered 
	int  position_buf_write=0;
	int descTmp=-1;
	int desc=-1;
	int64_t i;
	int64_t previousRecord=-1;
	int useRecord;
	unsigned char *recordBuffer;
	int recordBufferLength;
	int  bTempEof=0;
	int  nCount;
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

	//int szLenSumFields= 0;
	int bIsWrited = 0;

	int   nLenRek = 0;
	int   nLenPrec = 0;
	int   nLenSave = 0;
	int	  nLenRecOut=0;

	unsigned char  szKeyCurr[1024+8];
	unsigned char  szKeyPrec[1024+8];
	unsigned char  szKeySave[1024+8];

	unsigned char  szCnvNum[10];

	int   bIsFirstSumFields = 0;
	unsigned int  lpntTemp = 0;

	int nLenInRec = 0;

	char  szNameTmp[MAX_PATH1];
	SYSTEMTIME st;
	struct mmfio_t* mmfTmp;
	int		nSplitPosPnt = 0;
	unsigned char* pAddress;
	int64_t	nReadTmpFile;
	FILE*  pFile = NULL;
	
	// recordBufferLength=(job->outputLength>job->inputLength?job->outputLength:job->inputLength);
	recordBufferLength=MAX_RECSIZE; 

	recordBufferLength = recordBufferLength + 8;

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

	bufferwriteglobal=(int *) malloc((int)MAX_SIZE_CACHE_WRITE);
	if (bufferwriteglobal == 0)
		fprintf(stderr,"*OCSort*S012* Cannot Allocate bufferwriteglobal : %s\n", strerror(errno));

// new
// Verify segmentation and if last section of file input
//

	if (job->bIsPresentSegmentation == 1)
	{
//		// s.m. 20151011 x1 
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
			strcpy(szNameTmp ,cobc_temp_name(".tmp"));
			strcpy(job->array_FileTmpName[job->nIndextmp], szNameTmp);
		} 

		job->nCountSrt[job->nIndextmp]=0;

		if (job->ndeb > 1)
			fprintf(stderr,"Sort Tmp file %s \n",szNameTmp);

		if ((desc=open(szNameTmp, _O_WRONLY | O_BINARY | _O_CREAT | _O_TRUNC, _S_IREAD | _S_IWRITE))<0) {
				fprintf(stderr,"*OCSort*S013* Cannot open file %s : %s\n",szNameTmp,strerror(errno));
				file_stat_win (szNameTmp);
				retcode_func = -1;
				goto job_save_exit;
		}
		job->array_FileTmpHandle[job->nIndextmp] = desc;
	}

	if (job->bIsPresentSegmentation == 0)
	{
		if (job->outfil == NULL) {
			if ((desc=open(file_getName(job->outputFile),_O_RDONLY | _O_WRONLY | O_BINARY | _O_CREAT | _O_TRUNC, _S_IREAD | _S_IWRITE))<0) {
				fprintf(stderr,"*OCSort*S014* Cannot open file %s : %s\n",file_getName(job->outputFile),strerror(errno));
				file_stat_win (file_getName(job->outputFile));
				retcode_func = -1;
				goto job_save_exit;
				}
			}
			if ((pFile=fopen (file_getName(job->inputFile),"rb"))==NULL){
					fprintf(stderr,"*OCSort*S015* Cannot write header to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
					retcode_func = -1;
					goto job_save_exit;
			}
			if (file_GetMF(job->outputFile) == 1) // for file FILE_ORGANIZATION_SEQUENTIALMF
			{
				if (write(desc, szHeaderOutMF, 128)<0) {
					fprintf(stderr,"*OCSort*S016* Cannot write header to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
					if ((close(desc))<0) {
						fprintf(stderr,"*OCSort*S017* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
					}
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

		nSplitPosPnt = 8;

		}

//-->> debug	printf("======================================= Write out final or sort temp\n");

	if (job->bIsPresentSegmentation == 1)
	{
		// Get previous file temp
		job->nIndextmp2 = job->nIndextmp+1;
		if (job->nIndextmp2 >= MAX_HANDLE_TEMPFILE) //   5)
		{
			job->nIndextmp2 = 0;
		}
		if (job->array_FileTmpHandle[job->nIndextmp2] == -1)
			descTmp = 0;
		else
		{
			// Temporary File in input
			mmfTmp = mmfio_constructor();
			strcpy(szNameTmp, job->array_FileTmpName[job->nIndextmp2]);
			if (mmfio_Open((const unsigned char*)szNameTmp, OPN_READ, 0, mmfTmp) == 0){
				fprintf(stderr,"*OCSort*S018* Cannot open file %s : %s\n",szNameTmp,strerror(errno));
				file_stat_win (szNameTmp);			
				retcode_func = -1;
				goto job_save_exit;
			}
			descTmp = (int)mmfTmp->m_hFile;
		}
		nSplitPosPnt = 8;
	}


	nCount = 0;
	bIsFirstSumFields = 0;
	bIsWrited = 0;
	nReadTmpFile=0;

	if (job->recordNumber > 0) {
		SumField_ResetTot(job); // reset totalizer
		bIsFirstSumFields = 1;
		memcpy(&nLenRek,			job->buffertSort+(0)*(job->nLenKeys+8+4+8)+job->nLenKeys+8,     4); // nLenRek
		memcpy(szKeyPrec,			job->buffertSort+(0)*(job->nLenKeys+8+4+8)+job->nLenKeys, 8);  //lPosPnt
		memcpy(szKeyPrec+8,			job->buffertSort+(0)*(job->nLenKeys+8+4+8),               job->nLenKeys);  //Key
		memcpy(szPrecSumFields,		&lPosPnt, 8); // PosPnt
		memcpy(szPrecSumFields,	(unsigned char*) job->buffertSort+(0)*(job->nLenKeys+8+4+8)+job->nLenKeys+8+4+8, nLenRek+8);
		nLenPrec = nLenRek;
		memcpy(szKeySave,		szKeyPrec, 8+job->nLenKeys);			   //lPosPnt + Key
		memcpy(szSaveSumFields, szPrecSumFields, nLenPrec+8);
		nLenSave = nLenPrec;

	}

	for(i=0;i<job->recordNumber;i++) 
	{
		useRecord=1;
		memcpy(&lPosPnt,  job->buffertSort+(i)*(job->nLenKeys+8+4+8)+job->nLenKeys,       8);  //lPosPnt
		memcpy(&nLenRek,  job->buffertSort+(i)*(job->nLenKeys+8+4+8)+job->nLenKeys+8,     4); // nLenRek
		memcpy(&pAddress, job->buffertSort+(i)*(job->nLenKeys+8+4+8)+job->nLenKeys+8+4,   8); // Pointer Data Area 
		memcpy(szBuffRek,     &lPosPnt, 8); // PosPnt
		memcpy(szBuffRek+8,  (unsigned char*) pAddress, nLenRek); // buffer

		// Verify condition for SumFields  == 0, == 1 (None), == 2 (P,L,T)
		if (job->sumFields==1) {
			if (previousRecord!=-1) {
				if (job_compare_rek((char*) job->recordData+(previousRecord)*(job->nLenKeys+8+4+nLenMemory), (char*) job->recordData+(i)*(job->nLenKeys+8+4+nLenMemory))==0) {
					useRecord=0;
				}
			}
			previousRecord=i;
		}
		// ATTENZIONE da verificare nLenMemory

		if (job->sumFields==2) {
			memcpy(szKeyCurr,    job->buffertSort+(i)*(job->nLenKeys+8+4+8)+job->nLenKeys, 8);  //lPosPnt
			memcpy(szKeyCurr+8,  job->buffertSort+(i)*(job->nLenKeys+8+4+8),               job->nLenKeys);  //Key
			if (job_compare_key(szKeyPrec, szKeyCurr) == 0) {	// Compare Keys
				// Get current record
				nLenPrec = nLenRek;
				SumField_SumField((unsigned char*)pAddress);
				memcpy(szPrecSumFields, &lPosPnt, 8);
				memcpy(szPrecSumFields+8, pAddress, nLenRek);
				useRecord=0;
				bIsWrited = 1;
			}
			else // Keys not equal write buffer to file
			{
				useRecord = 1;
				// Save
				memcpy(szKeySave,		szKeyPrec, 8+job->nLenKeys);			   //lPosPnt + Key
				memcpy(szSaveSumFields, szPrecSumFields, nLenPrec+8);
				nLenSave = nLenPrec;
				// Previous
				memcpy(szKeyPrec,		job->buffertSort+(i)*(job->nLenKeys+8+4+8)+job->nLenKeys, 8);			   //lPosPnt
				memcpy(szKeyPrec+8,		job->buffertSort+(i)*(job->nLenKeys+8+4+8),               job->nLenKeys);  //Key
				memcpy(szPrecSumFields,     &lPosPnt, 8); // PosPnt
				memcpy(szPrecSumFields+8,  (unsigned char*) pAddress, nLenRek); // buffer
				nLenPrec = nLenRek;
				//Current
				memcpy(szKeyCurr, szKeySave, job->nLenKeys+8);			   //lPosPnt + Key
				memcpy(szBuffRek, szSaveSumFields, nLenSave+8);
				nLenRek = nLenSave;
			}

		}

		if (useRecord==1) {
			byteRead = nLenRek + nSplitPosPnt;
			nNumBytes = nNumBytes + byteRead;
			memcpy(recordBuffer, szBuffRek, byteRead);
			//-->>  ATTENZIONE SI USA recordBuffer memcpy(recordBuffer, szBuffRek, byteRead);
			if (descTmp > 0){
				// attenzione   				bSkip = 0;
				while (bTempEof == 0){

					nReadTmpFile=nReadTmpFile+1;

					if (bSkip == 0){
						// 						byteReadTemp = read(descTmp, &nLenRekTemp, 4);
						//-->>
						byteReadTemp = mmfio_Read((unsigned char*) &nLenRekTemp, 4, &mmfTmp);
						if (byteReadTemp != 4) {
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
					nCompare = job_compare_rek(szBuffTmp, recordBuffer);
					
					if (nCompare < 0 )   // 
					{
						memcpy(szCnvNum, &nLenRekTemp, 4);
						write_buffered(desc, (int)&nLenRekTemp, 4, (int)bufferwriteglobal, &position_buf_write);
						if (write_buffered(desc, (int)szBuffTmp, nLenRekTemp+nSplitPosPnt, (int)bufferwriteglobal, &position_buf_write)<0) {
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
					else if (nCompare == 0)
					{
						bSkip = 1;
						break;
					}
					else if (nCompare > 0)
					{
						bSkip = 1;
						break;
					}
				}
			}

// INREC
			if (job->inrec!=NULL) {
				memset(szBuffRek, 0x20, sizeof(szBuffRek));
				nLenInRec = inrec_copy(job->inrec, szBuffRek, recordBuffer, job->outputLength, job->inputLength, file_getFormat(job->outputFile), file_GetMF(job->outputFile));
				if (recordBufferLength < nLenInRec)
					recordBuffer= (unsigned char*) realloc(recordBuffer,nLenInRec+1);
				memcpy(recordBuffer, szBuffRek, nLenInRec);
				byteRead = nLenInRec;
				nLenRek = byteRead;
			}
// OUTREC
			if (job->outrec!=NULL) {
				memset(szBuffRek, 0x20, sizeof(szBuffRek));
				nLenRek = outrec_copy(job->outrec, szBuffRek, recordBuffer, job->outputLength, byteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job);
				memcpy(recordBuffer, szBuffRek, nLenRek);
			}

			
			if (bTempEof == 1)
			{
				memcpy(recordBuffer, szBuffRek, nLenRek+nSplitPosPnt);
				// ?? nLenRek = nLenRek;
			}
			

			// Verify OUTFIL
			if ((nLenRek > 0) && (job->outfil == NULL)){
				// ATTENZIONE gestione sumfields
				if (job->sumFields==2) {
					bIsWrited = 1;
					SumField_SumFieldUpdateRek((unsigned char*)recordBuffer+8);		// Update record in  memory
					SumField_ResetTot(job);									// reset totalizer
					SumField_SumField((unsigned char*)szPrecSumFields+8);			// Sum record in  memory
				}				
//
/* 20150414 
ripristinato 20150518 */
				if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) &&
					(job->bIsPresentSegmentation == 0)) {
		#ifndef _WIN32
							recordBuffer[nLenRek] = 0x0a;
							nLenRek+=1;
		#else
						(recordBuffer+nSplitPosPnt)[nLenRek]   = 0x0d;
						(recordBuffer+nSplitPosPnt)[nLenRek+1] = 0x0a;
						nLenRek+=2;
		#endif
				}
 /**/ 
				//new lenRecOut
				nLenRecOut = nLenRek;
				if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_SEQUENTIAL) &&
					(file_getFormat(job->outputFile) == FILE_TYPE_FIXED) ) {						// attention for Variable
					if (nLenRek < job->outputLength) {
						memset(recordBuffer+nSplitPosPnt+nLenRek, 0x00, job->outputLength - nLenRek); // padding
						nLenRecOut = job->outputLength;
					}
					else
					{
						nLenRecOut = job->outputLength;
					}
				}

				// File Variable, get lenght but not for Line Sequential
				if ((file_getFormat(job->outputFile) == FILE_TYPE_VARIABLE) && 
					(file_getOrganization(job->outputFile) != FILE_ORGANIZATION_LINESEQUENTIAL))
				{
				// Write record len
					if (file_GetMF(job->outputFile) == 1) //->bIsSeqMF == 1)
						nEWC = Endian_DWord_Conversion(nLenRecOut);
					else
						nEWC = Endian_Word_Conversion(nLenRecOut);
					write_buffered(desc, (int)&nEWC, 4, (int)bufferwriteglobal, &position_buf_write);
					if (write_buffered(desc, (int)recordBuffer+nSplitPosPnt, nLenRecOut, (int)bufferwriteglobal, &position_buf_write)<0) {
						fprintf(stderr,"*OCSort*S023* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
						if ((close(desc))<0) {
							fprintf(stderr,"*OCSort*S024* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
						}
						retcode_func = -1;
						goto job_save_exit;
					}
				} 
				else
				{
					if (job->bIsPresentSegmentation == 1) {
						memcpy(szCnvNum, &nLenRek, 4);
						write_buffered(desc, (int)&nLenRek, 4, (int)bufferwriteglobal, &position_buf_write);

						// PosPnt for sort record position
						// Insert for every write file temp
						if (write_buffered(desc, (int)recordBuffer, nLenRek+nSplitPosPnt, (int)bufferwriteglobal, &position_buf_write)<0) {
							fprintf(stderr,"*OCSort*S021* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
							if ((close(desc))<0) {
								fprintf(stderr,"*OCSort*S022* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
							}
							retcode_func = -1;
							goto job_save_exit;
						}
						
					}
					else
					{
						// final output without len + pospnt
						if (write_buffered(desc, (int)recordBuffer+nSplitPosPnt, nLenRecOut, (int)bufferwriteglobal, &position_buf_write)<0) {
							fprintf(stderr,"*OCSort*S023* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
							if ((close(desc))<0) {
								fprintf(stderr,"*OCSort*S024* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
							}
							retcode_func = -1;
							goto job_save_exit;
						}
					}
				}

				if (job->bIsPresentSegmentation == 1) {
					job->recordWriteSortTotal++;
					job->nCountSrt[job->nIndextmp]++;
				}
				else
				{
					job->recordWriteOutTotal++;
				}


			}	// close if (nLenRek > 0) 

			// Verify OUTFIL
			// Make output for OUTFIL
			if ((nLenRek > 0) && (job->outfil != NULL)){
/* 20150414
*/
				if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) &&
					(job->bIsPresentSegmentation == 0)) {
		#ifndef _WIN32
								recordBuffer[nLenRek] = 0x0a;
								nLenRek+=1;
		#else
								recordBuffer[nLenRek]   = 0x0d;
								recordBuffer[nLenRek+1] = 0x0a;
								nLenRek+=2;
		#endif
				}
				if (outfil_write_buffer(job, recordBuffer, nLenRek, szBuffRek) < 0){
						retcode_func = -1;
						goto job_save_exit;
				}
				job->recordWriteOutTotal++;
			}
		}		// close (useRecord==1) 
		nCount++; 
	// debug
		if (job->ndeb > 0) {
			if ((nCount % 1000000) == 0) {
				printf("%ld\n",nCount);
				GetLocalTime(&st);
				printf("SAVE - Year:%d Month:%d Date:%d Hour:%d Min:%d Second:% d\n" ,
					st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond);
			}
		}
	//
	}

// 
	if ((job->sumFields==2) && (bIsWrited == 1)) {   // pending buffer
		SumField_SumFieldUpdateRek((char*)szPrecSumFields+8);				// Update record in  memory
		memcpy(recordBuffer, szPrecSumFields, nLenPrec+8);		// Substitute record for write
		nLenRek = nLenPrec;
		nLenRecOut = nLenRek;
		if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_SEQUENTIAL) &&
			(file_getFormat(job->outputFile) == FILE_TYPE_FIXED) ) {						// attention for Variable
			if (nLenRek < job->outputLength) {
				memset(recordBuffer+nSplitPosPnt+nLenRek, 0x00, job->outputLength - nLenRek); // padding
				nLenRecOut = job->outputLength;
			}
			else
			{
				nLenRecOut = job->outputLength;
			}
		}

		if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) &&
		     (job->bIsPresentSegmentation == 0)) {
		#ifndef _WIN32
							recordBuffer[nLenRecOut] = 0x0a;
							nLenRek+=1;
		#else
							(recordBuffer+nSplitPosPnt)[nLenRecOut]   = 0x0d;
							(recordBuffer+nSplitPosPnt)[nLenRecOut+1] = 0x0a;
							nLenRecOut+=2;
		#endif
				}
 /**/ 

	// File Variable, get lenght but not for Line Sequential
		if ((file_getFormat(job->outputFile) == FILE_TYPE_VARIABLE) && 
			(file_getOrganization(job->outputFile) != FILE_ORGANIZATION_LINESEQUENTIAL))
		{
			// Write record len
			if (file_GetMF(job->outputFile) == 1) //->bIsSeqMF == 1)
				nEWC = Endian_DWord_Conversion(nLenRecOut);
			else
				nEWC = Endian_Word_Conversion(nLenRecOut);
			write_buffered(desc, (int)&nEWC, 4, (int)bufferwriteglobal, &position_buf_write);
		}
		if (write_buffered(desc, (int) recordBuffer+8, nLenRecOut, (int)bufferwriteglobal, &position_buf_write)<0) {
			fprintf(stderr,"*OCSort*S025* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			if ((close(desc))<0) {
				fprintf(stderr,"*OCSort*S026* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			}
			retcode_func = -1;
			goto job_save_exit;
		}
		if (job->bIsPresentSegmentation == 1) {
			job->recordWriteSortTotal++;
			job->nCountSrt[job->nIndextmp]++;

		}
		else
			job->recordWriteOutTotal++;
	}

	// save record in buffer

	if (job->outfil == NULL) {
		if (write_buffered_final(desc, (int)recordBuffer, nLenRecOut, (int)bufferwriteglobal, &position_buf_write)<0) {
							fprintf(stderr,"*OCSort*S031* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
		}
	}

	while ((bTempEof == 0) && (descTmp > 0)){
		if (bSkip == 1)	{
			/*  ATTENZIONE */
			write_buffered(desc, (int) &nLenRekTemp, 4, (int)bufferwriteglobal, &position_buf_write);
			write_buffered(desc, (int) szBuffTmp, nLenRekTemp+8, (int)bufferwriteglobal, &position_buf_write);

			bSkip=0;
		}
		byteReadTemp = mmfio_Read((unsigned char*) &nLenRekTemp, 4, &mmfTmp);
		if (byteReadTemp != 4) 
		{
			bTempEof = 1;
			continue;
		}
		if (nLenRekTemp == 0){
			bTempEof = 1;
			continue;
		}
		// PosPnt
		//-->>
		byteReadTemp = mmfio_Read((unsigned char*) szBuffTmp, nLenRekTemp+8, &mmfTmp);
		if (byteReadTemp <= 0) 
		{
			bTempEof = 1;
			continue;
		}
		nNumBytesTemp = nNumBytesTemp + byteReadTemp;
		write_buffered(desc, (int) &nLenRekTemp, 4, (int)bufferwriteglobal, &position_buf_write);

		if (write_buffered(desc, (int) szBuffTmp, byteReadTemp, (int)bufferwriteglobal, &position_buf_write)<0) {
			fprintf(stderr,"*OCSort*S033* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			if ((close(desc))<0) {
				fprintf(stderr,"*OCSort*S034* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			}
			retcode_func = -1;
			goto job_save_exit;
		}

		job->nCountSrt[job->nIndextmp]++;
	}

	if (job->outfil == NULL) {
		if (write_buffered_final(desc, (int)recordBuffer, nLenRecOut, (int)bufferwriteglobal, &position_buf_write)<0) {
			fprintf(stderr,"*OCSort*S036* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
		}
	}

job_save_exit:

   	free(recordBuffer);
	free(szBuffRek);
	free(szBuffTmp);
	free(szPrecSumFields);
	free(szSaveSumFields);
	free(bufferwriteglobal);

	if (pFile != NULL)
		fclose(pFile);

	if (desc >= 0){
		if (close(desc)<0) {
			fprintf(stderr,"*OCSort*S037* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			return -1;
		}
	}
	if (descTmp > 0)
	{
		mmfio_Close(mmfTmp);
		mmfio_destructor(mmfTmp);
		free(mmfTmp);
		// reset file temporaneo
		// Temporary File in input
		if ((descTmp = open(szNameTmp,O_WRONLY | O_BINARY | O_TRUNC))<0)
		{
			fprintf(stderr,"*OCSort*S039* Cannot open file %s : %s\n",szNameTmp,strerror(errno));
			return -1;
		}
		close(descTmp);

		job->nCountSrt[job->nIndextmp2]=0;
	}

	if (job->outfil != NULL){
		if (outfil_close_files(job) < 0) {
				return -1;
		}
	}

	return retcode_func;
}

INLINE int job_IdentifyBuf(int* ptrBuf, int nMaxEle)
{
	int* ptr;
	int p=0;
	int posAr=0;
	ptr=(int*)ptrBuf[0];
	for (p=0; p<nMaxEle; p++) // search first buffer not null
	{
		if (ptrBuf[p] != 0) {
			ptr=(int*)ptrBuf[p];
			posAr = p;
			break;
		}
	}
	for (p=posAr+1; p<nMaxEle; p++)
	{
		if (ptrBuf[p] == 0)
			continue;
		if (job_compare_rek( ptr,  (int*)ptrBuf[p]) > 0){
			ptr = (int *)ptrBuf[p];
			posAr = p;
		}
	}
	// 
	return posAr;  
}


// job_saveFinal
int job_save_final(struct job_t *job) {


	int retcode_func=0;
	int desc=0;
	int previousRecord=-1;
	int useRecord;
	unsigned char *recordBuffer;
	unsigned char *recordBufferPrevious;  // for SUm Fileds NONE
	int* bufferwriteglobal; // pointer for write buffered 
	int  position_buf_write=0;
	unsigned char* szBufRekTmpFile[MAX_HANDLE_TEMPFILE];
	int  position_buf_read=0;
	DWORD startRead = 0; // program starts
	DWORD endRead = 0;
	DWORD totRead = 0;
	DWORD startIdentify = 0;
	DWORD endIdentify = 0;
	DWORD totIdentify = 0;
	DWORD startWrite = 0;
	DWORD endWrite = 0;
	DWORD totWrite = 0;
	DWORD startTotal = 0;
	DWORD endTotal = 0;
	DWORD totTotal = 0;
	int			bIsEof[MAX_HANDLE_TEMPFILE];
	int recordBufferLength;
	int  bTempEof=0;
	int  nCount;
	int  nCompare = 1;
	int64_t   lPosPnt = 0;
	unsigned int   nLenRek = 0;
	int nLastRead=0;
	int bFirstRound=0;
	int*	ptrBuf[MAX_HANDLE_TEMPFILE];
	int nPosPtr;
	int byteReadTmpFile[MAX_HANDLE_TEMPFILE];
	int kj=0;
	int nPosition = 0;
	int   nNumBytes = 0;
	int   byteRead = 0;
	int   nNumBytesTemp = 0;
	int   byteReadTemp = 0;
	int   nLenRekTemp = 0;
	unsigned char* szBuffRek; // 64000];
	int		handleTmpFile[MAX_HANDLE_TEMPFILE];
	int nIdx1, nIdx2, k;
	struct BufferedReader_t* ArrayFile[MAX_HANDLE_TEMPFILE];
	int		nSumEof;
	int nEWC=0;
	char  szNameTmp[MAX_PATH1];
	int		nSplitPosPnt = 8;
	int		iSeek=0;
	int		nMaxEle=0;
	int* ptr;
	int p=0;
	int posAr=0;
	int bIsFirstTime = 0;
	startTotal = GetTickCount();

	// D E B U G 
	// debug   
	//-->> debug 	unsigned char szBuffRekDebug[OCSORT_MAX_BUFF_REK];
	// debug

	if (job->bIsPresentSegmentation == 0)
		return 0;

	recordBufferLength=MAX_RECSIZE;   //(job->outputLength>job->inputLength?job->outputLength:job->inputLength);

	recordBufferLength = recordBufferLength + nSplitPosPnt;

	// onlyfor Line Sequential
	if (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL)
		recordBufferLength=recordBufferLength+2+1;  // (PosPnt)

	recordBuffer=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*OCSort*S041* Cannot Allocate recordBuffer : %s\n", strerror(errno));

	recordBufferPrevious=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*OCSort*S042* Cannot Allocate recordBuffer : %s\n", strerror(errno));

	for (kj=0; kj < MAX_HANDLE_TEMPFILE;kj++) {
		szBufRekTmpFile[kj] = (unsigned char *) malloc(recordBufferLength);
		if (szBufRekTmpFile[kj] == 0)
			fprintf(stderr,"*OCSort*S043* Cannot Allocate szBufRek1 : %s - id : %ld\n", strerror(errno), kj);
	}

	szBuffRek=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRek == 0)
		fprintf(stderr,"*OCSort*S044* Cannot Allocate szBuffRek : %s\n", strerror(errno));

	//recordCopyLength = recordBufferLength;  // (job->outputLength>job->inputLength?job->inputLength:job->outputLength);
	
	bufferwriteglobal=(int *) malloc((int)MAX_SIZE_CACHE_WRITE_FINAL);
	if (bufferwriteglobal == 0)
		fprintf(stderr,"*OCSort*S045* Cannot Allocate bufferwriteglobal : %s\n", strerror(errno));


// new
// Verify segmentation and if last section of file input
//

	if (job->outfil == NULL) {
		if ((desc=open(file_getName(job->outputFile),_O_WRONLY | O_BINARY | _O_CREAT | _O_TRUNC, _S_IREAD | _S_IWRITE))<0) {
				fprintf(stderr,"*OCSort*S046* Cannot open file %s : %s\n",file_getName(job->outputFile),strerror(errno));
				file_stat_win (file_getName(job->outputFile));
				retcode_func = -1;
				goto job_save_final_exit;
		}
	}
	if (job->outfil != NULL){
		if (outfil_open_files(job) < 0) {
				retcode_func = -1;
				goto job_save_final_exit;
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
		if (job->array_FileTmpHandle[k] == -1)			
			continue;
		bIsEof[k]=0;
		strcpy(szNameTmp, job->array_FileTmpName[k]);
		ArrayFile[k] = BufferedReaderConstructor();
		BufferedReader_SetFileType(ArrayFile[k], FORG_SEQUVAR);
		handleTmpFile[k] = BufferedReader_open_file(ArrayFile[k], szNameTmp);			
		if (handleTmpFile[k] < 0) {
			fprintf(stderr,"*OCSort*S047* Cannot open file %s : %s\n",szNameTmp,strerror(errno));
			file_stat_win (szNameTmp);
			retcode_func = -1;
			goto job_save_final_exit;
		}
		BufferedReader_getsize_file(ArrayFile[k], handleTmpFile[k]);
	}
	for (kj=0; kj < MAX_HANDLE_TEMPFILE;kj++) {
		if (handleTmpFile[kj] != 0)
			ptrBuf[kj] = (int*)szBufRekTmpFile[kj];
		else
			ptrBuf[kj] = 0;
	}


	nCount = 0;
	bFirstRound = 1;
	nPosition = 0;

	nSumEof = 0;
	bIsFirstTime = 1;
	for (kj=0; kj < MAX_HANDLE_TEMPFILE;kj++) {
		if (((bIsEof[kj] == 0) && (nLastRead == kj)) ||	((bFirstRound == 1) && (bIsEof[kj] == 0))) {
			bIsEof[kj] = job_ReadFileCobStr(ArrayFile[kj], &handleTmpFile[kj], &byteReadTmpFile[kj], szBufRekTmpFile[kj], &ptrBuf[kj], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
		}
		//
		nSumEof = nSumEof + bIsEof[kj];
	}
	bFirstRound = 0;
	bIsFirstTime = 0;

	nMaxEle = MAX_HANDLE_TEMPFILE;
	if (job->nNumTmpFile < MAX_HANDLE_TEMPFILE)
		nMaxEle = job->nNumTmpFile +1;	// element 0 can is empty


	while ((nSumEof) < MAX_HANDLE_TEMPFILE) //job->nNumTmpFile)
	{		
		startIdentify = GetTickCount();
		ptr=(int*)ptrBuf[0];
		for (p=0; p<nMaxEle; p++) {
			if (ptrBuf[p] != 0) {
				ptr=(int*)ptrBuf[p];
				nPosPtr = p;
				break;
			}
		}
		for (p=posAr+1; p<nMaxEle; p++)	{
			if (ptrBuf[p] == 0)
				continue;
			if (job_compare_rek( ptr,  (int*)ptrBuf[p]) > 0){
				ptr = (int *)ptrBuf[p];
				nPosPtr = p;
			}
		}
	// 	
	endIdentify = GetTickCount()-startIdentify;
	totIdentify = totIdentify + endIdentify;
		nLastRead = nPosPtr;
		byteRead=byteReadTmpFile[nPosPtr];
// Inserire la gestione delle opzioni:
		// - SUM FIELDS = NONE
		// - SUM FIELDS = (P,L,T)
		//  D E B U G 
		//-->> debug 				memcpy(szBuffRekDebug, (unsigned char*) recordBuffer+nSplitPosPnt, byteRead);
		//-->> debug 				szBuffRekDebug[job->LenCurrRek-1]='\0';
		//-->> debug 				printf("%s", szBuffRekDebug);
// new version for SUM FIELDS
		useRecord=1;

		if (job->sumFields==1) {
			if (previousRecord!=-1) {
				// check equal key
				if (job_compare_rek(recordBufferPrevious, szBufRekTmpFile[nPosPtr] )==0) 
					useRecord=0;
			}
			// enable check for sum fields
			previousRecord=1;
			//
			memcpy(recordBufferPrevious, szBufRekTmpFile[nPosPtr], byteRead); 
		}

		// Verify for OUTFIL
		if ((useRecord==1) && (job->outfil == NULL)) {
		// ATTENZIONE è necessario il controllo per outrec ???
			nPosition = nPosition + 4 + byteRead;
		// end of check
			if (byteRead > 0)
			{
				startWrite = GetTickCount();
				if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) &&
					(job->bIsPresentSegmentation == 1)) {
#ifndef _WIN32
						memset(szBufRekTmpFile[nPosPtr]+byteRead+nSplitPosPnt,   0x0a, 1);
						byteRead+=1;
#else
						memset(szBufRekTmpFile[nPosPtr]+byteRead+nSplitPosPnt,   0x0d, 1);
						memset(szBufRekTmpFile[nPosPtr]+byteRead+nSplitPosPnt+1, 0x0a, 1);
						byteRead+=2;
#endif
				}
				if ((file_getFormat(job->outputFile) == FILE_TYPE_VARIABLE) && 
					(file_getOrganization(job->outputFile) != FILE_ORGANIZATION_LINESEQUENTIAL))
				{
					nEWC = Endian_Word_Conversion(nLenRekTemp);
					write_buffered(desc, (int)&nEWC, 4, (int)bufferwriteglobal, &position_buf_write);
				}
				if ((write_buffered_save_final(desc, (int)szBufRekTmpFile[nPosPtr]+nSplitPosPnt, byteRead, (int)bufferwriteglobal, &position_buf_write)) < 0) {
					fprintf(stderr,"*OCSort*S048* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
					if ((close(desc))<0) {
						fprintf(stderr,"*OCSort*S049* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
					}
					retcode_func = -1;
					goto job_save_final_exit;
				}
				nCount++;
			//-->> debug	
				job->recordWriteOutTotal++;
				endWrite = GetTickCount()-startWrite;
				totWrite = totWrite + endWrite;
		//-->> debug 		printf("%ld;%ld;%ld;\n", job->recordWriteOutTotal, nPosition, byteRead);
			}
		}
		else
		{
	// Make output for OUTFIL
			if ((useRecord==1) && (job->outfil != NULL)) {
				outfil_write_buffer(job, szBufRekTmpFile[nPosPtr]+nSplitPosPnt, byteRead, szBuffRek);
				job->recordWriteOutTotal++;
			}
		}
		

		if (bIsEof[nLastRead] == 0){
			startRead = GetTickCount(); // program starts
			bIsEof[nLastRead] = job_ReadFileCobStr(ArrayFile[nLastRead], &handleTmpFile[nLastRead], &byteReadTmpFile[nLastRead], szBufRekTmpFile[nLastRead], &ptrBuf[nLastRead], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
			nSumEof = nSumEof + bIsEof[nLastRead];
			endRead = GetTickCount() - startRead ;
			totRead = totRead + endRead;
		}

	}

	for (iSeek=0; iSeek < MAX_HANDLE_TEMPFILE; iSeek++) { 
		if (job->array_FileTmpHandle[iSeek] == -1)			
			continue;
		//if (ArrayFile[iSeek] >= 0) 
		if (ArrayFile[iSeek] != NULL) 
			BufferedReader_close_file(ArrayFile[iSeek]);
	}

	// final
    write_buffered_final(desc, (int)recordBuffer, nLenRek, (int)bufferwriteglobal, &position_buf_write);
	// 
job_save_final_exit:

	free(bufferwriteglobal);
	free(recordBuffer);
	free(recordBufferPrevious); 
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
	if (retcode_func == 0) {
		if (job->ndeb > 0) {
			fprintf(stdout,"nCount %ld\n", nCount);
			fprintf(stdout,"job->recordWriteSortTotal : %ld\n", job->recordWriteSortTotal);
			fprintf(stdout,"job->recordWriteOutTotal  : %ld\n", job->recordWriteOutTotal);
			fprintf(stdout,"job->recordNumberTotal    : %ld\n", job->recordNumberTotal);
			endTotal = GetTickCount() - startTotal;
			fprintf(stdout,"=====================================================================\n");
			fprintf(stdout,"nTimer totTotal     %ld sec\n", endTotal/1000);
			fprintf(stdout,"nTimer totIdentify  %ld sec\n", totIdentify/1000);
			fprintf(stdout,"nTimer totalRead    %ld sec\n", totRead/1000);
			fprintf(stdout,"nTimer totWrite     %ld sec\n", totWrite/1000);
			fprintf(stdout,"=====================================================================\n");
		}
	}
	return retcode_func;
}

INLINE int job_ReadFileCobStr(struct BufferedReader_t * reader, int* descTmp, int* nLR, unsigned char* szBuffRek, int** ptrBuf, int nFirst)
{
	int byteReadTemp=0;
	unsigned int lenBE = 0;
	int bTempEof=0;
	BufferedReader_byn_next_record(reader, *descTmp, 4, nFirst, (unsigned char*) &lenBE);
	byteReadTemp = (int)reader->nLenLastRecord;
	if ((byteReadTemp != 4) || (lenBE <= 0)) {
		memset(szBuffRek, 0xFF, 4); //recordBufferLength
		bTempEof = 1;
		*ptrBuf=0;
		*nLR = 0;
		return bTempEof;
	}
 	BufferedReader_byn_next_record(reader, *descTmp, lenBE+8, 0, (unsigned char*) szBuffRek);
	byteReadTemp = (int)reader->nLenLastRecord;
	if (byteReadTemp <= 0) {
		bTempEof = 1;
		*nLR = 0;
		*ptrBuf=0;
		return bTempEof;
	}

	*nLR = byteReadTemp-8;
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
	nSp=8; // first 8 byte for PosPnt
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		switch (sortField_getType(sortField)) {
			case FIELD_TYPE_CHARACTER:
				result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
				break;
			case FIELD_TYPE_BINARY:
				result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
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
				result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
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
// check record pointer
	/*
	if (result == 0){
		// check value of record position
		memcpy(&lPosA, (unsigned char*)first, 8);
		memcpy(&lPosB, (unsigned char*)second,8);
		if(lPosA < lPosB)
			result = -1;
		if(lPosA > lPosB)
			result = 1;
		// debug fprintf(stdout,"lPosA = %16I64d - lPosB = %16I64d \n", lPosA, lPosB);
		return result;
	}
	*/
	return 0;
}
INLINE int job_compare_rek(const void *first, const void *second) {
	// attenzione considerare campi temporanei di dimensione maggiore per 
	// gestire anche campi pic 9(18) -->  int64_t
	lPosA = 0;
	lPosB = 0;
	result=0;
	//-->>
	nSp=8; // first 8 byte for PosPnt


	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		switch (sortField_getType(sortField)) {
			case FIELD_TYPE_CHARACTER:
				result=memcmp( (unsigned char*) first+sortField_getPosition(sortField)-1+nSp, (unsigned char*) second+sortField_getPosition(sortField)-1+nSp, sortField_getLength(sortField));
				break;
			case FIELD_TYPE_BINARY:
				result=memcmp( (unsigned char*) first+sortField_getPosition(sortField)-1+nSp, (unsigned char*) second+sortField_getPosition(sortField)-1+nSp, sortField_getLength(sortField));
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
				result=memcmp( (unsigned char*) first+sortField_getPosition(sortField)-1+nSp, (unsigned char*) second+sortField_getPosition(sortField)-1+nSp, sortField_getLength(sortField));
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
		// check value of record position
		memcpy(&lPosA, (unsigned char*)first, 8);
		memcpy(&lPosB, (unsigned char*)second,8);
		if(lPosA < lPosB)
			result = -1;
		if(lPosA > lPosB)
			result = 1;
		// debug fprintf(stdout,"lPosA = %16I64d - lPosB = %16I64d \n", lPosA, lPosB);
		return result;
	}

//
	return 0;
}


INLINE int job_compare_qsort(const void *first, const void *second) {
	// attenzione considerare campi temporanei di dimensione maggiore per 
	// gestire anche campi pic 9(18) -->  int64_t
	lPosA = 0;
	lPosB = 0;
	nSp=0;
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		switch (sortField_getType(sortField)) {
			case FIELD_TYPE_CHARACTER:
				result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
				break;
			case FIELD_TYPE_BINARY:
				result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
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
				result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
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
			memcpy(&lPosA, (unsigned char*)first+globalJob->nLenKeys,8);
			memcpy(&lPosB, (unsigned char*)second+globalJob->nLenKeys,8);
			if(lPosA < lPosB)
				result = -1;
			if(lPosA > lPosB)
				result = 1;
			// debug fprintf(stdout,"lPosA = %16I64d - lPosB = %16I64d \n", lPosA, lPosB);
			return result;
		}
	return 0;
}

static char *
cobc_temp_name(const char * ext)
{ 
#ifdef	_WIN32
//-->>	char	cob_tmp_buff[COB_MEDIUM_BUFF];
//-->>	char	cob_tmp_temp[MAX_PATH1];

	if (globalJob->strPathTempFile == NULL)
		GetTempPath(MAX_PATH1, cob_tmp_temp);
	else
		strcpy(cob_tmp_temp, globalJob->strPathTempFile);

	//-->>GetTempFileName(cob_tmp_temp, "cob", 0, cob_tmp_buff);
	GetTempFileName(cob_tmp_temp, "Srt", 0, cob_tmp_buff);
	DeleteFile(cob_tmp_buff);
	/* Replace ".tmp" by EXT */
	strcpy(cob_tmp_buff + strlen(cob_tmp_buff) - 4, ext);
//-->>warning	return buff;
	return cob_tmp_buff;
#else
	size_t size = strlen(cobc_tmpdir) + strlen(ext) + 16U;
	char * buff = (char *) cobc_main_malloc(size);
	sprintf(buff, "%s/Srt%d_%d%s", cobc_tmpdir, (int)cob_process_id,
			(int)cob_iteration, ext);
	return buff;
#endif
}

int GetHeaderInfo(struct job_t* job, unsigned char* szHead)
{
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

//-->>	memcpy(&nHeadLen, szHead, 4);
//-->>	nHeadLen = Endian_DWord_Conversion(nHeadLen);
//-->>	nHeadLen = nHeadLen - nSpread;

	memcpy(&nMaxRekLen, szHead+54, 4);
	nMaxRekLen = Endian_DWord_Conversion(nMaxRekLen);

	memcpy(&nMinRekLen, szHead+58, 4);
	nMinRekLen = Endian_DWord_Conversion(nMinRekLen);

	// nMaxRekLen = atoi(szTmp);
	// memmove(szTmp, pChar + 58, 4);
	// nMinRekLen = atoi(szTmp);

	return 0;
}

int SetHeaderInfo(struct job_t* job, unsigned char* szHead)
{
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

int job_IdentifyBufMerge(int* ptrBuf, int nMaxElements)
{
	int* ptr;
	int p=0;
	int posAr=0;
	int nRes = 0;
	ptr= (int*)ptrBuf[0];
	for (p=0; p<nMaxElements; p++) { // search first buffer not null
		if (ptrBuf[p] != 0) 	{
			ptr=(int*)ptrBuf[p];
			posAr = p;
			break;
		}
	}

	// check if FIELDS=COPY
	// For FIELDS=COPY get first pointer valid
	if (job_GetFieldCopy() == 0) // No Field Copy
	{
		for (p=p; p<nMaxElements; p++)
		{
			if (ptrBuf[p] == 0)
				continue;
			nRes = job_compare_rek( ptr,  (int*)ptrBuf[p]);
			if (nRes > 0) {
				ptr = (int*)ptrBuf[p];
				posAr = p;
			}
		}
	}
	return posAr;
}


int job_merge_files(struct job_t *job) 
{

	struct file_t *file;
	int retcode_func=0;
	int desc=0;
	int k;
	int previousRecord=-1;
	int useRecord;
	unsigned char *recordBuffer;
	unsigned char *recordBufferPrevious;  // for SUm Fileds NONE

	int  nMaxFiles = MAX_FILES_INPUT;		// size of elements
	unsigned char szBufRek[MAX_FILES_INPUT][32768];	// key
	unsigned char szBufKey[MAX_FILES_INPUT][1024];	// key
	int  ArrayIsEOF[MAX_FILES_INPUT];
	int  Arrayhandle[MAX_FILES_INPUT];
	struct file_t*  Arrayfile_s[MAX_FILES_INPUT];

	int recordBufferLength;
	//int recordCopyLength;

	int  bTempEof=0;
	int  nCount;
	int  nCompare = 1;
	int64_t   lPosPnt = 0;
	int   nLenRek = 0;
	int   nLenRecOut=0;

	int nLastRead=0;
	int bFirstRound=0;

	int bIsFirstTime = 0;

	int* ptrBuf[MAX_FILES_INPUT];
//	unsigned char szTmp1[5];
	
	int nPosPtr, nIsEOF;
	int nPosition = 0;
	int nbyteRead;

	struct BufferedReader_t* ArrayFile[MAX_FILES_INPUT];
	int	handleFile[MAX_FILES_INPUT];
	int byteReadFile[MAX_FILES_INPUT];
	int	bIsEof[MAX_FILES_INPUT];
	int kj;
	int nNumBytes = 0;
	int nIdxFileIn = 0;
	int   nLenInRec = 0;
	unsigned char* szBuffRek;
	int		nSumEof;
	int nIdx1; //, bIsEOF;
	int nEWC=0;
	int nSplitPosPnt = 0;		// for pospnt
	char  szNameTmp[MAX_PATH1];
	for (k=0; k<nMaxFiles; k++)
	{
		ArrayIsEOF[k] = 1;
		byteReadFile[k] = 0;
		Arrayhandle[k] = 0;
		memset(szBufKey[k], 0x00, 1024);
		memset(szBufRek[k], 0x00, 32768);
		ptrBuf[k] = (int*)szBufRek[k];
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

	// recordCopyLength=(job->outputLength>job->inputLength?job->inputLength:job->outputLength);
	//recordCopyLength=MAX_RECSIZE;

// new
// Verify segmentation and if last section of file input
//
	if (job->outfil == NULL) {
		if ((desc=open(file_getName(job->outputFile),_O_WRONLY | O_BINARY | _O_CREAT | _O_TRUNC, _S_IREAD | _S_IWRITE))<0) {
			fprintf(stderr,"*OCSort*S061* Cannot open file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			file_stat_win (file_getName(job->outputFile)); 
			retcode_func = -1;
			goto job_merge_files_exit;
		}
		// Generate Header MF and Write header
		if (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_SEQUENTIALMF) {
			file_SetMF(job->outputFile);
			job->outputFile->pHeaderMF = (unsigned char *) malloc(HEADER_MF);
			SetHeaderInfo(job, job->outputFile->pHeaderMF);
			write(desc, job->outputFile->pHeaderMF, HEADER_MF);  
		}
	}
	if (job->outfil != NULL) {
		if (outfil_open_files( job ) < 0) {
			retcode_func = -1;
			goto job_merge_files_exit;
		}
	}

	for (kj=0; kj < MAX_FILES_INPUT;kj++) {
		byteReadFile[kj] = 0;
		handleFile[kj] = 0;
		bIsEof[kj] = 1;
		ArrayFile[kj] = NULL;
	}

	bFirstRound = 1;
	bIsFirstTime = 1;
	nLastRead=0;
	// Open files for Merge
	nIdx1 = 0;
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
		if (file_getOrganization(file) == FILE_ORGANIZATION_SEQUENTIALMF)
		{
			file_SetMF(job->outputFile);
			file->pHeaderMF =(unsigned char *) malloc(HEADER_MF);
			nbyteRead = read(Arrayhandle[nIdx1], file->pHeaderMF, HEADER_MF);
			if (nbyteRead != 128)
			{
				fprintf(stderr,"Error reading header file (128Byte) file %s : %s\n",file_getName(file),strerror(errno));
				retcode_func = -1;
				goto job_merge_files_exit;
			}
			//-->>
			GetHeaderInfo(job, file->pHeaderMF); // Analyze header for file seq MF
		}
//
		if (((bIsEof[nIdx1] == 0) && (nLastRead == kj)) ||	((bFirstRound == 1) && (bIsEof[nIdx1] == 0))) {
			bIsEof[nIdx1] = job_ReadFileMerge(ArrayFile[nIdx1], Arrayfile_s[nIdx1], &handleFile[nIdx1], &byteReadFile[nIdx1], szBufRek[nIdx1], &ptrBuf[kj], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
		}
//
		nIdx1++;
		if (nIdx1 > nMaxFiles){
			fprintf(stderr,"Too many files input for MERGE Actual/Limit: %ld/%ld\n",nIdx1, nMaxFiles);
			retcode_func = -1;
			goto job_merge_files_exit;
		}
	}
// in this point nIdx1 is max for number of files input
// 
	nIsEOF = 0; // nMaxFiles;
	nCount = 0;
	nPosition = 0;
	 // bIsEof = 0 ok, 1 = eof
	nSumEof = 0;
	for (kj=0; kj < MAX_FILES_INPUT;kj++) {
		nSumEof = nSumEof + bIsEof[kj];
	}
	bFirstRound = 0;
	bIsFirstTime = 0;
	while ((nSumEof) < MAX_FILES_INPUT) //job->nNumTmpFile)
	{		
// start of check
// Identify buffer 
		nPosPtr = job_IdentifyBufMerge((int*) ptrBuf, nIdx1);
// Setting fields for next step (Record, Position, Len)	
// Setting buffer for type fle
//
		// Padding record output
		if (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) 
			memset(recordBuffer, 0x20, job->outputFile->maxLength);
		else
			memset(recordBuffer, 0x00, job->outputFile->maxLength);
		memcpy(recordBuffer, szBufRek[nPosPtr], byteReadFile[nPosPtr]);
		nLastRead = nPosPtr;
		nbyteRead = byteReadFile[nPosPtr];
		job->LenCurrRek = byteReadFile[nPosPtr];
		nLenRek = nbyteRead;
		job->recordNumberTotal++;
// INREC
		if (job->inrec!=NULL) {
			memset(szBuffRek, 0x20, recordBufferLength);
			nLenInRec = inrec_copy(job->inrec, szBuffRek, recordBuffer, job->outputLength, job->inputLength, file_getFormat(job->outputFile), file_GetMF(job->outputFile));
			if (recordBufferLength < nLenInRec)
				recordBuffer= (unsigned char*) realloc(recordBuffer,nLenInRec+1);
			memcpy(recordBuffer, szBuffRek, nLenInRec );
			job->LenCurrRek = nLenInRec;
		}
// INREC
		// Inserire la gestione delle opzioni:
		// - SUM FIELDS = NONE
		// - SUM FIELDS = (P,L,T)
// new version for SUM FIELDS
		useRecord=1;

// new new new  INCLUDE - OMIT
		if (useRecord==1 && job->includeCondField!=NULL && condField_test(job->includeCondField,(unsigned char*) recordBuffer, job)==0) 
			useRecord=0;
		if (useRecord==1 && job->omitCondField!=NULL && condField_test(job->omitCondField,(unsigned char*) recordBuffer, job)==1) 
			useRecord=0;
		// new new new 
		if (job->sumFields==1) {
			if (previousRecord!=-1) {
				// check equal key
				if (job_compare_rek(recordBufferPrevious, recordBuffer)==0) {
					useRecord=0;
				}
			}
			// enable check for sum fields
			previousRecord=1;
			//
			memcpy(recordBufferPrevious, recordBuffer, nbyteRead); 
		}
		if (useRecord==1) {
				nPosition = nPosition + nbyteRead;
				// Write record len
				if (file_GetMF(job->outputFile) == 1) //->bIsSeqMF == 1)
					nPosition+=4; 
//
				// ATTENZIONE gestione sumfields
				// da verificare OUTREC attenzione alla struttura
				// manca la parte di lettura da file
				if (job->outrec!=NULL) {
					memset(szBuffRek, 0x20, recordBufferLength);
					nbyteRead = outrec_copy(job->outrec, szBuffRek, recordBuffer+nSplitPosPnt, job->outputLength, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job);
					memcpy(recordBuffer, szBuffRek, nbyteRead);
					job->LenCurrRek = nbyteRead ;
					nLenRek = nbyteRead;
				}


				// original if (nbyteRead > 0){
				// Verify OUTFIL
				if ((nbyteRead > 0) && (job->outfil == NULL)){
// new
					//new lenRecOut
					nLenRecOut = nLenRek;
					if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_SEQUENTIAL) &&
						(file_getFormat(job->outputFile) == FILE_TYPE_FIXED) ) {						// attention for Variable
						if (nLenRek < job->outputLength) {
							memset(recordBuffer+nSplitPosPnt+nLenRek, 0x00, job->outputLength - nLenRek); // padding
							nLenRecOut = nLenRek;
						}
						else
						{
							nLenRecOut = job->outputLength;
						}
					}
					// File Variable, get lenght but not for Line Sequential
					if ((file_getFormat(job->outputFile) == FILE_TYPE_VARIABLE) && 
						(file_getOrganization(job->outputFile) != FILE_ORGANIZATION_LINESEQUENTIAL))
					{
					// Write record len
						if (file_GetMF(job->outputFile) == 1) //->bIsSeqMF == 1)
							nEWC = Endian_DWord_Conversion(nLenRecOut);
						else
							nEWC = Endian_Word_Conversion(nLenRecOut);
						write(desc, &nEWC, 4);  // len of record Big Endian
					}
					if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) &&
						(job->bIsPresentSegmentation == 0)) {
	#ifndef _WIN32
							recordBuffer[nLenRecOut+nSplitPosPnt] = 0x0a;
							nLenRecOut+=1;
	#else
							recordBuffer[nLenRecOut+nSplitPosPnt]   = 0x0d;
							recordBuffer[nLenRecOut+nSplitPosPnt+1] = 0x0a;
							nLenRecOut+=2;
	#endif
					}
					if (write(desc, recordBuffer+nSplitPosPnt, nLenRecOut)<0) {
						fprintf(stderr,"*OCSort*S065* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
						if ((close(desc))<0) {
							fprintf(stderr,"*OCSort*S066* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
						}
						retcode_func = -1;
						goto job_merge_files_exit;
					}
					nCount++;
				//-->> debug	
					job->recordWriteOutTotal++;
		//-->> debug 		printf("%ld;%ld;%ld;\n", job->recordWriteOutTotal, nPosition, byteRead);
				}
				// OUTFIL
				if ((job->LenCurrRek > 0) && (job->outfil != NULL)){
					if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) &&
					(job->bIsPresentSegmentation == 0)) {
	#ifndef _WIN32
							recordBuffer[job->LenCurrRek+nSplitPosPnt] = 0x0a;
							job->LenCurrRek+=1;
	#else
							recordBuffer[job->LenCurrRek+nSplitPosPnt]   = 0x0d;
							recordBuffer[job->LenCurrRek+nSplitPosPnt+1] = 0x0a;
							job->LenCurrRek+=2;
	#endif
					}

					if (outfil_write_buffer(job, recordBuffer+nSplitPosPnt, job->LenCurrRek, szBuffRek) < 0) { 
						retcode_func = -1;
						goto job_merge_files_exit;
					}
					job->recordWriteOutTotal++;
				}

		//-->>	}
			// in this point insert OutRek function
		}
		if (bIsEof[nLastRead] == 0){
 			bIsEof[nLastRead] = job_ReadFileMerge(ArrayFile[nLastRead], Arrayfile_s[nLastRead], &handleFile[nLastRead], &byteReadFile[nLastRead], szBufRek[nLastRead], &ptrBuf[nLastRead], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
			nSumEof = nSumEof + bIsEof[nLastRead];
		}

	}
job_merge_files_exit:

	free(szBuffRek);
	free(recordBuffer);
	free(recordBufferPrevious);

	for (kj=0; kj < MAX_HANDLE_TEMPFILE; kj++) { 
		if (ArrayFile[kj] != NULL) {
			BufferedReaderDestructor(ArrayFile[kj]);
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
int job_ReadFileMerge(struct BufferedReader_t * reader, struct file_t* file, int* descTmp, int* nLR, unsigned char* szBuffRek, int** ptrBuf, int nFirst)
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
    	fprintf(stderr,"*OCSort*S068* FileOrganization error  %ld\n",file->nOrgType);
		bTempEof = 1;
		nLenRek = 0;
		*nLR = 0;
		*ptrBuf=0;
		break;
//
	case FILE_ORGTYPE_SQFIX		:
		memset(szBuffRek, 0x00, 32768); 
		//BufferedReader_byn_next_record(reader, *descTmp, lenBE, nFirst, (unsigned char*) szBuffRek);
		BufferedReader_byn_next_record(reader, *descTmp, nLenRek, nFirst, (unsigned char*) szBuffRek);
		nbyteRead = (int)reader->nLenLastRecord;
		if (nbyteRead <= 0) {
			bTempEof = 1;
			*nLR = 0;
			*ptrBuf=0;
			return bTempEof;
		}
		nLenRek = nbyteRead; 
		break;
//
	case FILE_ORGTYPE_SQVAR		:
		BufferedReader_byn_next_record(reader, *descTmp, 4, nFirst, (unsigned char*) &lenBE);
		nbyteRead = (int)reader->nLenLastRecord;
		if ((nbyteRead != 4) || (lenBE <= 0)) {
			memset(szBuffRek, 0xFF, 4); 
			bTempEof = 1;
			*ptrBuf=0;
			*nLR = 0;
			return bTempEof;
		}
		nLenRek=Endian_Word_Conversion(lenBE);
		memset(szBuffRek, 0x00, 32768); 
		BufferedReader_byn_next_record(reader, *descTmp, nLenRek, 0, (unsigned char*) szBuffRek);
		nbyteRead = (int)reader->nLenLastRecord;
		if (nbyteRead <= 0) {
			bTempEof = 1;
			*nLR = 0;
			*ptrBuf=0;
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
			*ptrBuf=0;
			return bTempEof;
		}
		nLenRek = nbyteRead; // strlen(szBuffRek);
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


void cob_set_packedint64_t(cob_field * f, int64_t val)
{
	int sign = FALSE; 
	cob_u64_t n;
	unsigned char * p ;
	if(!val) {
		cob_set_packed_zero(f);
		return;
	}
	if(val < 0) {
		n = (cob_u64_t) -val;
		sign = TRUE;
	} else {
		n = (cob_u64_t)val;
	}
	memset(f->data, 0, f->size);
	p = f->data + f->size - 1;
	if(!COB_FIELD_NO_SIGN_NIBBLE(f)) {
		*p = (n % 10) << 4;
		if(!COB_FIELD_HAVE_SIGN(f)) {
			*p |= 0x0FU;
		} else if(sign) {
			*p |= 0x0DU;
		} else {
			*p |= 0x0CU;
		}
		n /= 10;
		p--;
	}
	for(; n && p >= f->data; n /= 100, p--) {
		*p = packed_bytes[n % 100];
	}
	if(COB_FIELD_NO_SIGN_NIBBLE(f)) {
		if((COB_FIELD_DIGITS(f) % 2) == 1) {
			*(f->data) &= 0x0FU;
		}
		return;
	}
	if((COB_FIELD_DIGITS(f) % 2) == 0) {
		*(f->data) &= 0x0FU;
	}
}

int job_SetOptionSortNum(char* optSort, int nNum) {
	if (strcasecmp(optSort,"SKIPREC")==0)
			globalJob->nSkipRec=nNum;
	if (strcasecmp(optSort,"STOPAFT")==0)
			globalJob->nStopAft=nNum;
	return 0;
};

int job_SetOptionSort(char* optSort) {

	if (!strcasecmp(optSort,"COPY")) {
			job_SetTypeOP('M');
			job_SetFieldCopy(1);
		return 0;
	} else if (!strcasecmp(optSort,"VLSCMP")) {
				globalJob->nVLSCMP = 1;
				return 0;
	} else if (!strcasecmp(optSort,"VLSHRT")) {
				globalJob->nVLSHRT = 1;
				return 0;
	} else {
		return -1;
	}
	return -1;
}

