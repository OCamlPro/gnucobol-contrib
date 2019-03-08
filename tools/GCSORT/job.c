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
 
#include <sys/stat.h>
#include <malloc.h>
#include <time.h>
#include <ctype.h>

#include "libgcsort.h"
//#ifdef	_WIN32
#if defined(_MSC_VER) ||  defined(__MINGW32__) || defined(__MINGW64__)
	#include <share.h>
	#include <fcntl.h> 
	#include <process.h>
	#include <windows.h>
#else
    #include <inttypes.h>
#endif


#include <string.h>
#include <stddef.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <errno.h>
#include "gcsort.h"
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

// #include "bufferedreader.h"
// #include "bufferedwriter.h"

#define _CRTDBG_MAP_ALLOC
#include <stdlib.h>

#ifdef _MSC_VER
	#include <crtdbg.h>
#endif
 

char  szHeaderOutMF[128];
char* pEnd;
cob_field*      g_fd1;      // field for compare key
cob_field*      g_fd2;      // field for compare key
int	nLenMemory=0;
int g_lenRek = -1;
int nSp=0;
int nTypeFieldsCmd = 0;
int result=0;
int64_t lPosA = 0;
int64_t lPosB = 0;
long nSpread = 0;
struct sortField_t *sortField;

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
    job->nStatistics=0;
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
	job->ulMemSizeRead=0;
	job->bIsPresentSegmentation=0;
	job->nIndextmp  = 0;
	job->nIndextmp2 = 0;
	job->nMaxHandle = 0;
	job->ncob_varseq_type=0;
//	job->nHeadRecSize = 2;
	memset(job->array_FileTmpHandle, -1, sizeof(job->array_FileTmpHandle));
	for (nJ=0; nJ < MAX_HANDLE_TEMPFILE; nJ++)
		job->nCountSrt[nJ]=0;
	job->nSkipRec=0;
	job->nStopAft=0;
	job->strPathTempFile[0]=0x00; //NULL;
	memset(job->arrayFileInCmdLine, 0x00, (MAXFILEIN*FILENAME_MAX));
	memset(job->szTakeFileName, 0x20, sizeof(job->szTakeFileName));
	job->bIsTake=0;
	job->nMaxFileIn=0;
	memset(job->arrayFileOutCmdLine, 0x00, (MAXFILEIN*FILENAME_MAX));
	job->nMaxFileOut=0;
	job->ulMemSizeAlloc		= GCSORT_ALLOCATE_MEMSIZE;
	job->ulMemSizeAllocSort = GCSORT_ALLOCATE_MEMSIZE/100*10;		// 
	job->nLastPosKey = 0;	// Last position of key
	job->nTestCmdLine=0;
	job->nMlt  = MAX_MLTP_BYTE;
// verify Environment variable for emulation
// 0 = GCSORT normal operation
// 1 = GCSORT emulates MFSORT 
/*
	pEnvEmule = getenv ("GCSORT_EMULATE");
	if (pEnvEmule!=NULL)
	{
		job->nTypeEmul = atol(pEnvEmule);
		if ((job->nTypeEmul != 0) && (job->nTypeEmul != 1)){
				fprintf(stderr,"GCSORT - Error on GCSORT_EMULATE parameter. Value 0 for GCSORT, 1 for MF Emulator, 2 for DFSort. Value Environment%ld\n", job->nTypeEmul );
				fprintf(stderr,"GCSORT - Forcing  GCSORT_EMULATE = 0\n");
				job->nTypeEmul = 0;
		}
	}
*/
// verify Environment variable for memory allocation
	pEnvMemSize = getenv ("GCSORT_MEMSIZE");
	if (pEnvMemSize!=NULL)
	{
		job->ulMemSizeAlloc = atol(pEnvMemSize);
		if (job->ulMemSizeAlloc == 0) {
			job->ulMemSizeAllocSort = GCSORT_ALLOCATE_MEMSIZE/100*10;
			job->ulMemSizeAlloc = GCSORT_ALLOCATE_MEMSIZE - job->ulMemSizeAllocSort;
		} 
		else
		{
			job->ulMemSizeAllocSort = job->ulMemSizeAlloc/100*10;
			job->ulMemSizeAlloc = job->ulMemSizeAlloc - job->ulMemSizeAllocSort ;
		}
	}

	pEnvEmule = getenv ("GCSORT_TESTCMD");
	if (pEnvEmule!=NULL)
	{
		job->nTestCmdLine = atol(pEnvEmule);
		if ((job->nTestCmdLine != 0) && (job->nTestCmdLine != 1)){
				fprintf(stderr,"GCSORT - Error on GCSORT_TESTCMD parameter. Value 0 for normal operations , 1 for ONLY test command line. Value Environment: %d\n", job->nTestCmdLine );
				fprintf(stderr,"GCSORT - Forcing  GCSORT_TESTCMD = 0\n");
				job->nTestCmdLine = 0;
		}
	}
	pEnvEmule = getenv ("GCSORT_STATISTICS");
	if (pEnvEmule!=NULL)
	{
		job->nStatistics = atol(pEnvEmule);
		if ((job->nStatistics != 0) && (job->nStatistics != 1) && (job->nStatistics != 2)){
				fprintf(stderr,"GCSORT - Error on GCSORT_STATISTICS parameter. Value 0 for suppress info , 1 for Sumamry, 2 for Details. Value Environment: %d\n", job->nStatistics);
				fprintf(stderr,"GCSORT - Forcing  GCSORT_STATISTICS = 0\n");
				job->nStatistics = 1;
		}
	}
	pEnvEmule = getenv ("GCSORT_DEBUG");
	if (pEnvEmule!=NULL)
	{
		job->ndeb = atol(pEnvEmule);
		if ((job->ndeb != 0) && (job->ndeb != 1) && (job->ndeb != 2)){
				fprintf(stderr,"GCSORT - Error on GCSORT_DEBUG parameter. Value 0 for normal operations , 1 for DEBUG, 2 for DEBUG Parser. Value Environment: %d\n", job->nTestCmdLine );
				fprintf(stderr,"GCSORT - Forcing  GCSORT_DEBUG = 0\n");
				job->ndeb= 0;
		}
		else
		{
			//-->>yydebug=job->ndeb; 
			if (job->ndeb == 1) {
				yyset_debug(0);	
			}
			if (job->ndeb == 2) {
// s.m. at 20190303				yydebug=1; 
				yyset_debug(2);	
			}
		}
	}

	pEnvEmule = getenv ("GCSORT_PATHTMP");
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
			fprintf(stderr, "GCSORT Warning : Path not found %s\n", job->strPathTempFile);
		}
		else 
		{
			close(nOp);
			remove(chPath);
		}
	}
	pEnvEmule = getenv ("GCSORT_MLT");
	if (pEnvEmule!=NULL)
	{
		job->nMlt = atol(pEnvEmule);
	}

	pEnvEmule = getenv ("COB_VARSEQ_FORMAT");
	if (pEnvEmule!=NULL)
	{
		job->ncob_varseq_type = atol(pEnvEmule);  // identically cob_varseq_type (libcob)
//		job->nHeadRecSize = job_defineHeaderRecSize(job);
	}

// Outfil
//-->>	job->nOutfil_Split=0;		// Flag for split
//-->>	job->nOutfil_Copy=0;		// Flag for copy
	job->outfil=NULL;
	job->pLastOutfil_Split = NULL;
	job->pSaveOutfil = NULL;
// Option
	job->nVLSCMP = 0;   // 0 disabled , 1 = enabled -- temporarily replace any missing compare field bytes with binary zeros
	job->nVLSHRT = 0;   // 0 disabled , 1 = enabled -- treat any comparison involving a short field as false
//
	return job;
}

/*
// Define size of bytes for len of record
unsigned int job_defineHeaderRecSize(struct job_t *job) {
	unsigned int nLen;
	switch (job->ncob_varseq_type) {
	case 1:
		nLen=4;
		break;
	case 2:
		nLen=4;
		break;
	case 3:											
		nLen=2;
		break;										
	default:
		nLen=2;
		break;
	}
	return nLen;
}
*/

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

void job_ReviewMemeAlloc ( struct job_t *job  ) 
{
	double  nLenKey = job_GetLenKeys();
	double  nLenRek = job->inputLength;
	double  nPerc = (nLenKey + SIZESRTBUFF ) / nLenRek * 100;
	// in the case where nLenRek too big or too small
	if (nPerc > 50)
		nPerc = 50;
	if (nPerc < 15) 
		nPerc = 15;
	job->ulMemSizeAllocSort = (job->ulMemSizeAlloc*(int64_t)nPerc)/100;
	job->ulMemSizeAlloc = job->ulMemSizeAlloc - job->ulMemSizeAllocSort;


// Allocate field for compare
	g_fd1 = job_cob_field_create();
	g_fd2 = job_cob_field_create();

	return;
}

int job_sort (struct job_t* job) 
{
	int nContinueSrtTmp=0;
	int nRC=0;
	do {
		nContinueSrtTmp = 0;
		nRC = job_loadFiles(job);
		if (job->nStatistics == 2) 
				util_print_time_elap("After  job_loadFiles     ");
		if (nRC == -2)
			nContinueSrtTmp = 1;
		if (nRC == -1)
			break;
		nRC = job_sort_data(job); 
		if (job->nStatistics == 2) 
				util_print_time_elap("After  job_sort          ");
		if (nRC == -1)
			break;
		if (job->bIsPresentSegmentation == 0)
			nRC = job_save_out(job);
		else
			nRC = job_save_tempfile(job);
		if (job->nStatistics == 2) 				
			util_print_time_elap("After  job_save          ");
		if (nRC == -1)
				break;
	} while (nContinueSrtTmp == 1);
	if ((nRC >= 0) && (job->bIsPresentSegmentation == 1)){
		nRC = job_save_tempfinal(job);
		if ((job->nStatistics == 2) &&  (job->bIsPresentSegmentation == 1))
				util_print_time_elap("After  job_save_tempfinal");
	}

	return nRC;
}


int job_load(struct job_t *job, int argc, char **argv) {
	char  bufnew[COB_MEDIUM_BUFF];
	char  szTakeFile[FILENAME_MAX];
	char* buffer=NULL;
	int   argvLength;
	int   bufferLength=0;
	int   i;
	int   nTakeCmd = 0;
	int   returnCode;

	globalJob=job;
 	buffer=(char *) malloc(COB_MEDIUM_BUFF);	// COmmandLine
	if (buffer == 0)
 		fprintf(stderr,"*GCSORT*S001*ERROR: Cannot Allocate buffer : %s\n", strerror(errno));
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
			//-->>if (strcmp(argv[i], "TAKE")== 0) 
            if (_stricmp(argv[i], "TAKE")== 0) 
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


void job_CloneFileForOutfilSet(struct job_t *job, struct file_t* file) 
{

    switch(file->organization) {
    case FILE_ORGANIZATION_SEQUENTIAL:		// 
		file->stFileDef->organization = COB_ORG_SEQUENTIAL;
		break;
    case FILE_ORGANIZATION_LINESEQUENTIAL:
		file->opt = COB_WRITE_BEFORE | COB_WRITE_LINES | 1;
	    file->stFileDef->organization = COB_ORG_LINE_SEQUENTIAL;
		break;
	case FILE_ORGANIZATION_RELATIVE:		// 
        file->stFileDef->organization = COB_ORG_RELATIVE;
		break;
	case FILE_ORGANIZATION_INDEXED:
        file->stFileDef->access_mode = COB_ACCESS_DYNAMIC;  
		file->stFileDef->organization = COB_ORG_INDEXED;
		break;
    }

    return;
}

int job_CloneFileForOutfil( struct job_t *job) 
{

	struct file_t *file;
	struct outfil_t *outfil;
	struct file_t *fileJob;

	fileJob = job->outputFile;

	if ((job->outfil != NULL) && (fileJob != NULL)){
		if (job->outfil->outfil_File == NULL){
			file = (struct file_t*) file_constructor(fileJob->name);
            if (file == NULL) 
                utl_abend_terminate(MEMORYALLOC, 4, ABEND_EXEC);
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
                    job_CloneFileForOutfilSet(job, file);
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
					fprintf(stderr,"*GCSORT*S002*ERROR: Problem with file name input %s, %s, %d\n",job->inputFile->name, job->arrayFileInCmdLine[nPos], nPos--);
					return -1;
			}
			memcpy(file->name, job->arrayFileInCmdLine[nPos], strlen(job->arrayFileInCmdLine[nPos]));

			if (file->stFileDef != NULL) {
				memcpy(file->stFileDef->assign->data, job->arrayFileInCmdLine[nPos], strlen(job->arrayFileInCmdLine[nPos]));
#ifdef VBISAM
				// check if file name from command line contains ".dat" for indexed file
				if (file->organization == FILE_ORGANIZATION_INDEXED) {
					memset(szExt, 0x00, sizeof(szExt));
					memcpy(szExt, file->stFileDef->assign->data+strlen((const char*)file->stFileDef->assign->data)-4, 4);
					cob_sys_tolower(szExt, 4);
					if (strcmp(szExt, ".dat") == 0)
						*(file->stFileDef->assign->data+strlen((const char*)file->stFileDef->assign->data)-4)='\0';
				}
#endif
            }
		}
	}
	nPos=-1;
	if (job->outputFile!=NULL) {
		for (file=job->outputFile; file!=NULL; file=file_getNext(file)) {
			nPos++;
			if (nPos > job->nMaxFileOut) {
					fprintf(stderr,"*GCSORT*S003*ERROR: Problem with file name output %s, %s, %d\n",job->outputFile->name, job->arrayFileOutCmdLine[nPos], nPos--);
					return -1;
			}
			//-->>free(file->name);
			//-->>file->name = strdup(job->arrayFileOutCmdLine[nPos]);
			memcpy(file->name, job->arrayFileOutCmdLine[nPos], strlen(job->arrayFileOutCmdLine[nPos]));
			if (file->stFileDef != NULL) {
				//-->>free(file->stFileDef->assign->data);
				//-->>file->stFileDef->assign->data = _strdup(job->arrayFileOutCmdLine[nPos]);
				memcpy(file->stFileDef->assign->data, job->arrayFileOutCmdLine[nPos], strlen(job->arrayFileOutCmdLine[nPos]));
#ifdef VBISAM
				// check if file name from command line contains ".dat" for indexed file
				if (file->organization == FILE_ORGANIZATION_INDEXED) {
					memset(szExt, 0x00, sizeof(szExt));
					memcpy(szExt, file->stFileDef->assign->data+strlen((const char*)file->stFileDef->assign->data)-4, 4);
					cob_sys_tolower(szExt, 4);
					if (strcmp(szExt, ".dat") == 0)
						*(file->stFileDef->assign->data+strlen((const char*)file->stFileDef->assign->data)-4)='\0';
				}
#endif
			}

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

	char  strORG[] = " ORG ";
	char  strRECORD[]  = " RECORD ";
	char  strUSE[]  = " USE ";
	char  szFileName[1024];
	char* pch1;
	char* pch2;
	char* pch3;
	char* szSearch;
	int   bFound = 0;
	int   nFirstRound=0;
	int   nPosNull=0;
	int   nSp1=1;
	int   nSp2=0;
	int   nSp3=0;
	int   nSp9 = 0;
	int   pk=0;
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
				strncat(bufnew, szBuffIn+(pch2-szSearch), pch1-pch2 );
				pch2 = pch2 + (pch1 - pch2);
			}
			pch2 = strstr (szSearch+nSp1-1, strORG);
			pch3 = strstr (szSearch+nSp1-1, strRECORD);
			if (pch3 == NULL){
				fprintf(stderr,"*GCSORT*S004*ERROR: Command RECORD not found or lower case, use uppercase\n");
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
				nPosNull = job_PutIntoArrayFile(job->arrayFileInCmdLine[job->nMaxFileIn], szBuffIn+(pch1-szSearch)+strlen(strUSE), nSp2);
				job->arrayFileInCmdLine[job->nMaxFileIn][nPosNull]=0x00;
				job->nMaxFileIn++;
				memset(szFileName, 0x00, 1024);
				sprintf(szFileName, " USE FI%03d", job->nMaxFileIn); // new file name
				// alloc same dimension of file input for string
				if (nSp2 > (int)(strlen(szFileName)-strlen(strUSE))) { 
					nSp9= strlen(szFileName);
					for (pk=nSp9-strlen(strUSE); pk < nPosNull;pk++) {
						strcat(szFileName, "A");
					}
				}
				strcat(bufnew,		szFileName);	// concat new file name
				pch1 = pch2 + nSp3;
			}
			else
			{
				fprintf(stderr,"*GCSORT*S005*ERROR: Command ORG not found or lower case, use uppercase\n");
				exit(OC_RTC_ERROR);
			}
		}
		else
		{
			if (bFound == 0) {
				fprintf(stderr,"*GCSORT*S006*ERROR: Command USE not found or lower case, use uppercase\n");
				exit(OC_RTC_ERROR);
			}
		}
	}
	if (job->nMaxFileIn <= 0) {
		fprintf(stderr,"*GCSORT*S007*ERROR: Problem NO file input\n");
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
	char  strGIVE[]	 = " GIVE ";
	char  strORG[]	 = " ORG ";
	char  strRECORD[] = " RECORD ";
	char  szFileName[1024];
	char* pch1;
	char* pch2;
	char* pch3;
	char* szSearch;
	int   bFound = 0;
	int   nFirstRound=0;
	int   nPosNull = 0;
	int   nSp1=1;
	int   nSp2=0;
	int   nSp3=0;
	int   nSp9;
	int   pk=0;	
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
				nPosNull = job_PutIntoArrayFile(job->arrayFileOutCmdLine[job->nMaxFileOut], szBuffIn+(pch1-szSearch)+strlen(strGIVE), nSp2);
				job->arrayFileOutCmdLine[job->nMaxFileOut][nPosNull] = 0x00;
				job->nMaxFileOut++;
				memset(szFileName, 0x00, 1024);
				sprintf(szFileName, " GIVE FO%03d", job->nMaxFileOut); // new file name
				// alloc same dimension of file input for string
				if (nSp2 > (int)(strlen(szFileName)-strlen(strGIVE))) {
					nSp9= strlen(szFileName);
					for (pk=nSp9-strlen(strGIVE); pk < nPosNull;pk++) {
						strcat(szFileName, "A");
					}
				}
				strcat(bufnew,		szFileName);	// concat new file name
				pch1 = pch2 + nSp3;
			}
			else
			{ 
				fprintf(stderr,"*GCSORT*S008*ERROR: Command ORG not found or lower case, use uppercase\n");
				exit(OC_RTC_ERROR);
			}
		}
		else
		{
			if (bFound == 0) {
				fprintf(stderr,"*GCSORT*S009*ERROR: Command USE not found or lower case, use uppercase\n");
				exit(OC_RTC_ERROR);
			}
		}
	}
	if (job->nMaxFileOut <= 0) {
		fprintf(stderr,"*GCSORT*S010*ERROR: Problem NO file output\n");
		free(szSearch);
		return -1; 
	}
	if (pch2 != NULL)
		strcat(bufnew, szBuffIn+(pch2-szSearch));
	free(szSearch);
	return (nSp1);
}

// Verify file take
int job_MakeCmdLine(char* szF, char* buf) 
{
	int numread, maxLen;
	int c;
	int nComm;
	int nNewLine;
	int nNumSQ=0;
	int nNlastCR=0;
	FILE *pFile;
	maxLen=0;
	nNewLine=1;

	if (globalJob->nStatistics > 1) {
		fprintf(stdout,"========================================================\n");
		fprintf(stdout,"GCSORT\nFile TAKE : %s\n", szF);
		fprintf(stdout,"========================================================\n");
	}
	if((pFile=fopen(szF, "rt"))==NULL) {
		fprintf(stderr, "\n*GCSORT* ERROR Unable to open file %s", (char*)szF);
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
			if (c == '\'')
				nNumSQ++;
			if ((c == '*') && (nNumSQ%2 == 0))	{ // check char * and num of char '
				nComm=1;
            }
			if ((c == 0x0a) || (c == 0x0d)) {	// skip for carriage return or line feed
				buf[maxLen+1] = ' ';
				maxLen+=1;
				nNewLine = 1;
				nNumSQ=0;
				if ((nNlastCR==0) && (nComm==0) && (c == 0x0a))
                    if (globalJob->nStatistics > 1)
	    				printf("\n");
				if (c == 0x0a)
					nNlastCR=1;
				nComm=0;
				continue;
			}
			if (nComm == 0) {
				buf[maxLen+1] = c;
				maxLen+=1;
				nNewLine = 0;
                if (globalJob->nStatistics > 1)
    				printf("%c", c);
				nNlastCR=0;
			}
		} while (c != EOF);

		buf[maxLen+1] = 0x00;
	//-->>	}
	fclose(pFile);
    if (globalJob->nStatistics > 1)
    	fprintf(stdout,"\n========================================================\n");
	return 0;
}
int job_GetTypeOp(struct job_t *job) {
	return job->job_typeOP;
}

int job_NormalOperations(struct job_t *job) {
	return job->nTestCmdLine;
}


int job_check(struct job_t *job) 
{
	struct file_t *file;
	int nErr=0;

	if (job->includeCondField!=NULL && job->omitCondField!=NULL) {
		fprintf(stderr,"*GCSORT*S011*ERROR: INCLUDE COND and OMIT are mutually exclusive\n");
		return -1;
	}
	if (job->inputFile==NULL) {
		fprintf(stderr,"*GCSORT*S012*ERROR: No input file specified\n");
		return -1;
	}
	if (job->outputFile==NULL) {
		fprintf(stderr,"*GCSORT*S013*ERROR: No output file specified\n");
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
				fprintf(stderr,"*GCSORT*W003* WARNING : Outrec clause define a file with a different length than give record clause\n");
		} 
		else
		{
			if (file_getOrganization(job->outputFile) == FILE_TYPE_FIXED) {
				if (job->outputLength != file_getMaxLength(job->outputFile) && file_getMaxLength(job->outputFile)!=0) {
					fprintf(stderr,"*GCSORT*S014*ERROR: Outrec clause define a file with a different length than give record clause\n");
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

	if (job_NormalOperations(job) == 0)  {  // Not for test command line
		for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
            // check file type
            if ((file->stFileDef->nkeys > 0) && (file->organization != FILE_ORGANIZATION_INDEXED)) {
                fprintf(stderr,"*GCSORT*S070*ERROR: KEY clause definition not allowed for file  %s - Type: %s\n", file->name, utils_getFileOrganizationName(file->organization));
				return -1;
            }
            //
			cob_open(file->stFileDef,  COB_OPEN_INPUT, 0, NULL);
			if (atol((char *)file->stFileDef->file_status) != 0) {
				fprintf(stderr,"*GCSORT*S015*ERROR: Cannot open file %s - File Status (%c%c)\n",file_getName(file), 
					file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
				nErr++;
			}
			cob_close(file->stFileDef, NULL, COB_CLOSE_NORMAL, 0);
		}
		for (file=job->outputFile; file!=NULL; file=file_getNext(file)) {
            // check file type
            if ((file->stFileDef->nkeys > 0) && (file->organization != FILE_ORGANIZATION_INDEXED)) {
                fprintf(stderr,"*GCSORT*S071*ERROR: KEY clause definition not allowed for file  %s - Type: %s\n", file->name, utils_getFileOrganizationName(file->organization));
				return -1;
            }
            //
			cob_open(file->stFileDef,  COB_OPEN_OUTPUT, 0, NULL);
			if (atol((char *)file->stFileDef->file_status) != 0) {
				fprintf(stderr,"*GCSORT*S016*ERROR: Cannot open file %s - File Status (%c%c)\n",file_getName(file), 
					file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
				nErr++;
			}
			cob_close(file->stFileDef, NULL, COB_CLOSE_NORMAL, 0);
		}
	}
	if (nErr>0)
		return -1;

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
				fprintf(stderr,"*GCSORT*W001* Cannot remove file %s : %s\n", szNameTmp,strerror(errno));
			}
		}
	}
	fprintf(stdout,"========================================================\n");
	fprintf(stdout," Total Records Number       : " CB_FMT_LLD "\n", (long long) job->recordNumberTotal);
	fprintf(stdout," Total Records Write Sort   : " CB_FMT_LLD "\n", (long long) job->recordWriteSortTotal);
	fprintf(stdout," Total Records Write Output : " CB_FMT_LLD "\n", (long long) job->recordWriteOutTotal);
	fprintf(stdout,"========================================================\n");
	if (job->nStatistics == 2)	{
		if (job->bIsPresentSegmentation == 1) {
			for (nIdx=0; nIdx<MAX_HANDLE_TEMPFILE; nIdx++) {
					fprintf(stdout,"job->nCountSrt[%02d] %d\n", nIdx, job->nCountSrt[nIdx]);
			}
		}

		fprintf(stdout,"\n");
		fprintf(stdout," Memory size for GCSORT data     :  " CB_FMT_LLD "\n", (long long) job->ulMemSizeAlloc);
		fprintf(stdout," Memory size for GCSORT key      :  " CB_FMT_LLD "\n", (long long) job->ulMemSizeAllocSort);
		fprintf(stdout," MAX_SIZE_CACHE_WRITE            : %10d\n", MAX_SIZE_CACHE_WRITE);
		fprintf(stdout," MAX_SIZE_CACHE_WRITE_FINAL      : %10d\n", MAX_SIZE_CACHE_WRITE_FINAL);
		fprintf(stdout," MAX_MLTP_BYTE                   : %10d\n", job->nMlt);
		fprintf(stdout,"===============================================\n");
		fprintf(stdout,"\n");
    }

	if (job->outfil != NULL){
		for (pOutfil=job->outfil; pOutfil != NULL; pOutfil=outfil_getNext(pOutfil)) {
    		fprintf(stdout,"OUTFIL Total Records Write     : %10d\n", pOutfil->recordWriteOutTotal);
			for (file=pOutfil->outfil_File; file != NULL; file=file_getNext(file)) {
                fprintf(stdout,"Record Write for file : %10d - File: %s\n", file->nCountRow, file->name);
			}
		}
		fprintf(stdout,"\n");
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
	

int job_print(struct job_t *job) 
{
    struct SumField_t*  SumField;
    struct condField_t* condField;
    struct file_t*      file;
    struct inrec_t*     inrec;
    struct outfil_t*    outfil;
    struct outrec_t*    outrec;
    struct sortField_t* sortField;

	printf("\n========================================================\n");
	printf("GCSORT Version %s\n", GCSORT_VERSION);
	printf("========================================================\n");


	if (job->bIsTake == 1) {
		printf("TAKE file name\n");
		printf("%s\n", job->szTakeFileName);
		printf("========================================================\n");
	}
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
			fprintf(stderr,"SKIPREC = " CB_FMT_LLD "\n", (long long) job->nSkipRec);

		if (job->nStopAft > 0)
			fprintf(stderr,"STOPAFT = " CB_FMT_LLD "\n", (long long) job->nStopAft);

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
					printf("\t\tSTARTREC = " CB_FMT_LLD "\n", (long long) outfil->outfil_nStartRec);
				if (outfil->outfil_nEndRec >= 0)
					printf("\t\tENDREC = " CB_FMT_LLD "\n", (long long) outfil->outfil_nEndRec);
			}
	//--		printf(")\n");
		}
	//
		printf("========================================================\n");
	}
	return 0;
}


int job_destroy(struct job_t *job) {
	int nIdx = 0;
	int nIdxMaster=0;
	int nIdy = 0;
	int nIdyMaster=0;
	struct SumField_t*		SumField;
	struct SumField_t*		fPSum[128];
	struct condField_t*		fPCond[128];
	struct condField_t*		outfil_includeCond;
	struct condField_t*		outfil_omitCond;
	struct file_t*			fPFile[128];
	struct file_t*			file;
	struct inrec_t*			fPIn[128];
	struct inrec_t*			inrec;
	struct outfil_t*		fPOutfilrec[128];
	struct outfil_t*		outfil;
	struct outrec_t*		fPOut[128];
	struct outrec_t*		outfil_outrec;
	struct outrec_t*		outrec;
	struct sortField_t*		fPSF[128];
	struct sortField_t* 	sortField;


// destroy filed for compare
	job_cob_field_destroy(g_fd1);
	job_cob_field_destroy(g_fd2);
//

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
		    for (file=fPOutfilrec[nIdyMaster]->outfil_File; file!=NULL; file=file->next) {
			    fPFile[nIdx] = file;
			    nIdx++;
		    }
		    for (nIdy=0; nIdy < nIdx; nIdy++){
			    file_destructor(fPFile[nIdy]);
		    }
            nIdx=0;
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

//-->>	if (job->reader != NULL)
//-->>		BufferedReaderDestructor(job->reader);
	return 0;
}

 

int job_loadFiles(struct job_t *job) {

	int bEOF, nEOFFileIn;
	int bIsFirstTime=1;
    int bIsFirstLoop=0;    
	int nIdxFileIn = 0;
	int nbyteRead;
	int nk=0;
	int useRecord;
	int64_t lPosSeqLS = 0;
	long int nMemAllocate = 0;
	long nRecCount = 0;
	struct file_t* file;
	unsigned char  recordBuffer[GCSORT_MAX_BUFF_REK];
	unsigned char  szBuffKey[GCSORT_MAX_BUFF_REK];
	unsigned char  szBuffRekNull[GCSORT_MAX_BUFF_REK];
	unsigned char  szBuffRek[GCSORT_MAX_BUFF_REK];
	unsigned char* pAddress;
	unsigned int   nLenRek;
	unsigned int   nPosCurrentSeek = 0;

	memset(szBuffRekNull, 0x00, GCSORT_MAX_BUFF_REK);
	if (job->bIsPresentSegmentation == 0) {
		job->recordNumber=0;
		job->recordNumberAllocated=GCSORT_ALLOCATE;
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

			cob_open(file->stFileDef,  COB_OPEN_INPUT, 0, NULL);
			if (atol((char *)file->stFileDef->file_status) != 0) {
				fprintf(stderr,"*GCSORT*S017*ERROR: Cannot open file %s - File Status (%c%c) \n",file_getName(file), 
					file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
				return -1;
			}
			nEOFFileIn=0;
		} 
		bEOF = 0;
		nLenMemory = file_getMaxLength(file);
		nLenRek = file_getRecordLength(file);
		nbyteRead=0;

		while (bEOF == 0)
		{
			cob_read_next(file->stFileDef,  NULL, COB_READ_NEXT );
			if (atol((char *)file->stFileDef->file_status) != 0) {	// Check 
				if (atol((char *)file->stFileDef->file_status) == 10) {	// EOF
					bEOF = 1;
					nbyteRead=0;
					continue;
				}

				if (atol((char *)file->stFileDef->file_status) > 10) {
					fprintf(stderr,"*GCSORT*S018*ERROR: Cannot read file %s - File Status (%c%c) \n",file_getName(file),
							file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
					return -1; //exit(OC_RTC_ERROR);
				}
				else
				{
					fprintf(stderr,"*GCSORT*W968* Warning reading file %s - File Status (%c%c) \n",file_getName(file), 
							file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
				}
			}
			nLenRek = file->stFileDef->record->size;
			memcpy(szBuffRek, file->stFileDef->record->data, file->stFileDef->record->size);
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
			// Key, PosPnt, Len , Pointer
			// nn , 8     , 4   , 8
			pAddress = (unsigned char*) (unsigned char*) job->recordData+job->ulMemSizeRead;
			//Key
			memmove((unsigned char*) job->buffertSort+(job->recordNumber)*(job->nLenKeys+SIZESRTBUFF), 
                            (unsigned char*) &szBuffKey, job->nLenKeys);
			//PosPnt
			memmove((unsigned char*) job->buffertSort+(job->recordNumber)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys, 
                            (unsigned char*) &job->lPosAbsRead,   SZPOSPNT); // PosPnt
			// len
			memmove((unsigned char*) job->buffertSort+(job->recordNumber)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SZPOSPNT, 
                            (unsigned char*) &job->LenCurrRek ,   SZLENREC); // len
			// Pointer Address Data
			memmove((unsigned char*) job->buffertSort+(job->recordNumber)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SZPOSPNT+SZLENREC , 
                            &pAddress, SZPNTDATA); // Pointer Address Data
			
			job->ulMemSizeRead = job->ulMemSizeRead + nLenRek; // key + pointer record + record length
			job->ulMemSizeSort = job->ulMemSizeSort + job->nLenKeys + SIZESRTBUFF;

            job->lPosAbsRead = job->lPosAbsRead + nLenRek;  // Setting value of Position Record

			job->recordNumber++;
			// check for next read record  
			if (((unsigned int)(job->ulMemSizeRead + ((job->nLenKeys + SIZESRTBUFF + nLenMemory) * 2)) >= job->ulMemSizeAlloc) ||
				((unsigned int)(job->ulMemSizeSort + ((job->nLenKeys + SIZESRTBUFF) * 2))  >= job->ulMemSizeAllocSort))	{
					job->bIsPresentSegmentation = 1;
					job->nCurrFileInput = nIdxFileIn; // last file input read
					return -2;
			}
		}
		
		if (nbyteRead==0) {
			// End of file
            } else if (nbyteRead==-1) {
			fprintf(stderr,"*GCSORT*S019*ERROR: Cannot read file %s : %s\n",file_getName(file),strerror(errno));
			return -1;
		} else {
			fprintf(stderr,"Wrong record length in file %s\n",file_getName(file));
			return -1;
		}

		cob_close (file->stFileDef, NULL, COB_CLOSE_NORMAL, 0);
		nEOFFileIn=1;
	}

	return 0;
}

int job_sort_data(struct job_t *job)
{
	int i=0;
	globalJob=job;
	if (job->sortField!=NULL) 
		qsort(job->buffertSort, (size_t) job->recordNumber, job->nLenKeys+SIZESRTBUFF, job_compare_qsort);  // check record position
return 0;
}


int job_save_out(struct job_t *job) 
{
	int	bSkip = 0;
	int	nSplitPosPnt = 0;
	int	retcode_func = 0;
	int bIsFirstSumFields = 0;
	int bIsWrited = 0;
	int bTempEof=0;
	int byteReadTemp = 0;
	int desc=-1;
	int nCompare = 1;
	int nLenInRec = 0;
	int nNumBytes = 0;
	int nNumBytesTemp = 0;
	int position_buf_write=0;
	int recordBufferLength;
	int useRecord;
	int64_t	nReadTmpFile;
	int64_t i;
	int64_t lPosPnt = 0;
	int64_t previousRecord=-1;
	unsigned char  szKeyCurr[1024+SZPOSPNT];
	unsigned char  szKeyPrec[1024+SZPOSPNT];
	unsigned char  szKeySave[1024+SZPOSPNT];
	unsigned char* pAddress;
	unsigned char* recordBuffer;
	unsigned char* recordBufferPrevious;  // for Sum Fileds NONE
	unsigned char* szBuffRek;
	unsigned char* szBuffTmp;
	unsigned char* szPrecSumFields;	// Prec
	unsigned char* szSaveSumFields; // save
	unsigned int   byteRead = 0;
	unsigned int   lpntTemp = 0;
	unsigned int   nLenPrec = 0;
	unsigned int   nLenRecOut=0;
	unsigned int   nLenRek = 0;
	unsigned int   nLenRekTemp = 0;
	unsigned int   nLenSave = 0;	// recordBufferLength=(job->outputLength>job->inputLength?job->outputLength:job->inputLength);
	recordBufferLength=MAX_RECSIZE; 

	recordBufferLength = recordBufferLength + SZPOSPNT;

	recordBuffer=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*GCSORT*S020*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

	recordBufferPrevious=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*GCSORT*S021*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

	szBuffRek=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRek == 0)
		fprintf(stderr,"*GCSORT*S022*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));
	szBuffTmp=(unsigned char *) malloc(recordBufferLength);
	if (szBuffTmp == 0)
		fprintf(stderr,"*GCSORT*S023*ERROR: Cannot Allocate szBuffTmp : %s\n", strerror(errno));
	szPrecSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szPrecSumFields == 0)
		fprintf(stderr,"*GCSORT*S024*ERROR: Cannot Allocate szPrecSumFields : %s\n", strerror(errno));
	szSaveSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szSaveSumFields == 0)
		fprintf(stderr,"*GCSORT*S025*ERROR: Cannot Allocate szSaveSumFields : %s\n", strerror(errno));

	// Outfill == NULL, staandard output file
    if (job->outfil == NULL) {
		cob_open(job->outputFile->stFileDef,  COB_OPEN_OUTPUT, 0, NULL);
		if (atol((char *)job->outputFile->stFileDef->file_status) != 0) {
			fprintf(stderr,"*GCSORT*S026*ERROR: Cannot open file %s - File Status (%c%c)\n",file_getName(job->outputFile), 
				job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
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

    nSplitPosPnt = SZPOSPNT;
	bIsFirstSumFields = 0;
	bIsWrited = 0;
	nReadTmpFile=0;

	if (job->recordNumber > 0) {
		SumField_ResetTot(job); // reset totalizer
		bIsFirstSumFields = 1;
		memcpy(&nLenRek,			job->buffertSort+(0)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SZPOSPNT,SZLENREC);  // nLenRek
		memcpy(szKeyPrec,			job->buffertSort+(0)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys,          SZPOSPNT); // lPosPnt
		memcpy(szKeyPrec+SZPOSPNT,	job->buffertSort+(0)*(job->nLenKeys+SIZESRTBUFF),job->nLenKeys);                    // Key
		memcpy(szPrecSumFields,		&lPosPnt, SZPOSPNT); // PosPnt        
        memcpy(szPrecSumFields,	(unsigned char*) job->buffertSort+(0)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SIZESRTBUFF, nLenRek+SZPOSPNT);        
		nLenPrec = nLenRek;
		memcpy(szKeySave,		szKeyPrec, job->nLenKeys+SZPOSPNT);			   //lPosPnt + Key
		memcpy(szSaveSumFields, szPrecSumFields, nLenPrec+SZPOSPNT);
		nLenSave = nLenPrec;

	}

	for(i=0;i<job->recordNumber;i++) 
	{
		useRecord=1;
		nLenRecOut = job->outputLength;
		memcpy(&lPosPnt,  job->buffertSort+(i)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys,                   SZPOSPNT);  //lPosPnt
		memcpy(&nLenRek,  job->buffertSort+(i)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SZPOSPNT,          SZLENREC);  // nLenRek
		memcpy(&pAddress, job->buffertSort+(i)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SZPOSPNT+SZLENREC, SZPNTDATA); // Pointer Data Area 

		memcpy(szBuffRek, &lPosPnt, SZPOSPNT); // PosPnt
		memcpy(szBuffRek+SZPOSPNT,  (unsigned char*) pAddress, nLenRek); // buffer

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
			memcpy(szKeyCurr,    job->buffertSort+(i)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys, SZPOSPNT);  //lPosPnt
			memcpy(szKeyCurr+SZPOSPNT,  job->buffertSort+(i)*(job->nLenKeys+SIZESRTBUFF),           job->nLenKeys);  //Key
			useRecord = SumFields_KeyCheck(job, &bIsWrited, szKeyPrec, &nLenPrec, szKeyCurr,  &nLenRek, szKeySave,  &nLenSave, 
                                           szPrecSumFields, szSaveSumFields, szBuffRek, SZPOSPNT);

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
// NORMAL
		if ((nLenRek > 0) && (job->outfil == NULL)){
			if (job->sumFields==2) {
				bIsWrited = 1;
				SumField_SumFieldUpdateRek((unsigned char*)recordBuffer+SZPOSPNT);	// Update record in  memory
				SumField_ResetTot(job);									            // reset totalizer
				SumField_SumField((unsigned char*)szPrecSumFields+SZPOSPNT);		// Sum record in  memory
			}			
			job_set_area(job, job->outputFile, recordBuffer+nSplitPosPnt, nLenRecOut);	// Len output
			cob_write (job->outputFile->stFileDef, job->outputFile->stFileDef->record, job->outputFile->opt, NULL, 0);
			if (atol((char *)job->outputFile->stFileDef->file_status) != 0) {
			    fprintf(stderr,"*GCSORT*S027*ERROR: Cannot write to file %s - File Status (%c%c)\n",file_getName(job->outputFile), 
					job->outputFile->stFileDef->file_status[0],job->outputFile->stFileDef->file_status[1]);
            	retcode_func = -1;
				goto job_save_exit;
			}
            job->recordWriteOutTotal++;
		}	

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
		SumField_SumFieldUpdateRek((char*)szPrecSumFields+SZPOSPNT);	// Update record in  memory
		memcpy(recordBuffer, szPrecSumFields, nLenPrec+SZPOSPNT);		// Substitute record for write
		nLenRek = nLenPrec;
		nLenRecOut = job->outputLength;
		job_set_area(job, job->outputFile, recordBuffer+nSplitPosPnt, nLenRecOut);	// Len output
    	cob_write (job->outputFile->stFileDef, job->outputFile->stFileDef->record, job->outputFile->opt, NULL, 0);
		if (atol((char *)job->outputFile->stFileDef->file_status) != 0) {
		    fprintf(stderr,"*GCSORT*S028*ERROR: Cannot write to file %s - File Status (%c%c)\n",file_getName(job->outputFile), 
				job->outputFile->stFileDef->file_status[0],job->outputFile->stFileDef->file_status[1]);
            retcode_func = -1;
			goto job_save_exit;
		}

        job->recordWriteOutTotal++;
	}
job_save_exit:

   	free(recordBuffer);
	free(szBuffRek);
	free(szBuffTmp);
	free(szPrecSumFields);
	free(szSaveSumFields);
	free(recordBufferPrevious);

	cob_close (job->outputFile->stFileDef, NULL, COB_CLOSE_NORMAL, 0);


	if (desc >= 0){
		if (close(desc)<0) {
			fprintf(stderr,"*GCSORT*S029*ERROR: Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
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

int job_set_area(struct job_t* job, struct file_t* file, unsigned char* szBuf, int nLen )
{
// 20180511 s.m. start
    int nLenRek = job->inputFile->stFileDef->record->size;
// 20180511 s.m. end
// set area data
	memcpy(file->stFileDef->record->data, szBuf, nLen);

// 20180511 s.m. start
    // 
	// Padding - Only for FILE_ORGANIZATION_LINESEQUENTIAL, Fixed and Variable Len, and when length not equal for input/output
    // 
    if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) && (nLenRek < nLen)) {
            memset(file->stFileDef->record->data+nLenRek, 0x20, nLen - nLenRek); // padding wirh blank (0x20)
    }
// 20180511 s.m. end
	if (job->outputFile->format == FILE_TYPE_VARIABLE){
		job->outputFile->stFileDef->record->size = nLen;
		cob_set_int(job->outputFile->stFileDef->variable_record, (int)nLen);
	}
	else
	{
		job->outputFile->stFileDef->record->size = nLen;
	}
	return 0 ;
}

int job_save_tempfile(struct job_t *job) 
{
	char szNameTmp[FILENAME_MAX];
	int	 bSkip = 0;
	int	 nLenRecOut=0;
	int	 nSplitPosPnt = 0;
	int	 retcode_func = 0;
	int  bIsFirstSumFields = 0;
	int  bIsWrited = 0;
	int  bTempEof=0;
	int  byteReadTemp = 0;
	int  desc=-1;
	int  descTmp=-1;
	int  nCompare = 1;
	int  nLenInRec = 0;
	int  nLenPrec = 0;
	int  nLenRek = 0;
	int  nLenSave = 0;
	int  nNumBytes = 0;
	int  nNumBytesTemp = 0;
	int  position_buf_write=0;
	int  recordBufferLength;
	int  useRecord;
	int64_t	nReadTmpFile;
	int64_t i;
	int64_t lPosPnt = 0;
	int64_t previousRecord=-1;
	struct mmfio_t* mmfTmp;
	unsigned char  szKeyPrec[1024+SZPOSPNT];
	unsigned char  szKeySave[1024+SZPOSPNT];
	unsigned char* bufferwriteglobal; // pointer for write buffered 
	unsigned char* pAddress;
	unsigned char* recordBuffer;
	unsigned char* szBuffRek;
	unsigned char* szBuffTmp;
	unsigned char* szPrecSumFields;	// Prec
	unsigned char* szSaveSumFields; // save
	unsigned int   byteRead = 0;
	unsigned int   lpntTemp = 0;
	unsigned int   nLenRekTemp = 0;	

    recordBufferLength=MAX_RECSIZE; 

	recordBufferLength = recordBufferLength + SZPOSPNT;

	recordBuffer=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*GCSORT*S030*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));
	szBuffRek=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRek == 0)
		fprintf(stderr,"*GCSORT*S031*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));
	szBuffTmp=(unsigned char *) malloc(recordBufferLength);
	if (szBuffTmp == 0)
		fprintf(stderr,"*GCSORT*S032*ERROR: Cannot Allocate szBuffTmp : %s\n", strerror(errno));
	szPrecSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szPrecSumFields == 0)
		fprintf(stderr,"*GCSORT*S033*ERROR: Cannot Allocate szPrecSumFields : %s\n", strerror(errno));
	szSaveSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szSaveSumFields == 0)
		fprintf(stderr,"*GCSORT*S034*ERROR: Cannot Allocate szSaveSumFields : %s\n", strerror(errno));
	bufferwriteglobal=(unsigned char*) malloc(MAX_SIZE_CACHE_WRITE);
	if (bufferwriteglobal == 0)
		fprintf(stderr,"*GCSORT*S035*ERROR: Cannot Allocate bufferwriteglobal : %s\n", strerror(errno));

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
            fprintf(stderr,"*GCSORT*S036*ERROR: Cannot open file %s : %s\n",szNameTmp,strerror(errno));
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
            fprintf(stderr,"*GCSORT*S037*ERROR: Cannot open file %s : %s\n",szNameTmp,strerror(errno));
            retcode_func = -1;
            goto job_save_exit;
        }
// buffered vs mmf	
        descTmp = (int)mmfTmp->m_hFile;
    }
    nSplitPosPnt = SZPOSPNT;
	bIsFirstSumFields = 0;
	bIsWrited = 0;
	nReadTmpFile=0;

	if (job->recordNumber > 0) {
		SumField_ResetTot(job); // reset totalizer
		bIsFirstSumFields = 1;
		memcpy(&nLenRek,			job->buffertSort+(0)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SZPOSPNT, SZLENREC); // nLenRek
		memcpy(szKeyPrec,			job->buffertSort+(0)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys, SZPOSPNT);  //lPosPnt
		memcpy(szKeyPrec+SZPOSPNT,	job->buffertSort+(0)*(job->nLenKeys+SIZESRTBUFF), job->nLenKeys);  //Key
		memcpy(szPrecSumFields,		&lPosPnt, SZPOSPNT); // PosPnt
		memcpy(szPrecSumFields,	(unsigned char*) job->buffertSort+(0)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SIZESRTBUFF, nLenRek+SZPOSPNT);
		nLenPrec = nLenRek;
		memcpy(szKeySave,		szKeyPrec,  job->nLenKeys+SZPOSPNT);			   //lPosPnt + Key
		memcpy(szSaveSumFields, szPrecSumFields, nLenPrec+SZPOSPNT);
		nLenSave = nLenPrec;

	}

	for(i=0;i<job->recordNumber;i++) 
	{
		useRecord=1;
		memcpy(&lPosPnt,  job->buffertSort+(i)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys,                   SZPOSPNT);  //lPosPnt
		memcpy(&nLenRek,  job->buffertSort+(i)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SZPOSPNT,          SZLENREC); // nLenRek
		memcpy(&pAddress, job->buffertSort+(i)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SZPOSPNT+SZLENREC, SZPNTDATA); // Pointer Data Area 
		memcpy(szBuffRek,     &lPosPnt, SZPOSPNT); // PosPnt
		memcpy(szBuffRek+SZPOSPNT,  (unsigned char*) pAddress, nLenRek); // buffer

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
						fprintf(stderr,"*GCSORT*S038*ERROR: Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
						if ((close(desc))<0) {
							fprintf(stderr,"*GCSORT*S039*ERROR: Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
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
                fprintf(stderr,"*GCSORT*S040*ERROR: Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
                if ((close(desc))<0) {
                    fprintf(stderr,"*GCSORT*S041*ERROR: Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
                }
                retcode_func = -1;
                goto job_save_exit;
            }
        }

        job->recordWriteSortTotal++;
        job->nCountSrt[job->nIndextmp]++;

	}		//

    if (write_buffered_final(desc, &bufferwriteglobal, &position_buf_write)<0) {
            fprintf(stderr,"*GCSORT*S042*ERROR: Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
            retcode_func = -1;
            goto job_save_exit;
                    
    }

	while ((bTempEof == 0) && (descTmp >= 0)){
		if (bSkip == 1)	{
			/*   */
			write_buffered(desc, (unsigned char*) &nLenRekTemp, SIZEINT, &bufferwriteglobal, &position_buf_write);
			write_buffered(desc, (unsigned char*) szBuffTmp, nLenRekTemp+SZPOSPNT, &bufferwriteglobal, &position_buf_write);
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
		byteReadTemp = mmfio_Read((unsigned char*) szBuffTmp, nLenRekTemp+SZPOSPNT, &mmfTmp);
		if (byteReadTemp <= 0) {
			bTempEof = 1;
			continue;
		}
		nNumBytesTemp = nNumBytesTemp + byteReadTemp;
		write_buffered(desc, (unsigned char*) &nLenRekTemp, SIZEINT, &bufferwriteglobal, &position_buf_write);

		if (write_buffered(desc, (unsigned char*) szBuffTmp, byteReadTemp, &bufferwriteglobal, &position_buf_write)<0) {
			fprintf(stderr,"*GCSORT*S043*ERROR: Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			if ((close(desc))<0) {
				fprintf(stderr,"*GCSORT*S044*ERROR: Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			}
			retcode_func = -1;
			goto job_save_exit;
		}

		job->nCountSrt[job->nIndextmp]++;
	}

    if (write_buffered_final(desc, &bufferwriteglobal, &position_buf_write)<0) {
        fprintf(stderr,"*GCSORT*S045*ERROR: Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
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
			fprintf(stderr,"*GCSORT*S046*ERROR: Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
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
			fprintf(stderr,"*GCSORT*S047*ERROR: Cannot open file %s : %s\n",szNameTmp,strerror(errno));
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

char szNameTmp[FILENAME_MAX];
	int	bIsEof[MAX_HANDLE_TEMPFILE];
	int	bIsFirstSumFields = 0;
	int	handleTmpFile[MAX_HANDLE_TEMPFILE];
	int	iSeek=0;
	int	nMaxEle=0;
	int	nSplitPosPnt = SZPOSPNT;
	int	nSumEof;
	int bFirstRound=0;
	int bIsFirstTime = 0;
	int bIsWrited = 0;
	int bTempEof=0;
	int byteRead = 0;
	int byteReadTemp = 0;
	int byteReadTmpFile[MAX_HANDLE_TEMPFILE];
	int desc=0;
	int kj=0;
	int nCompare = 1;
	int nIdx1, nIdx2, k;
	int nLastRead=0;
	int nLenRekTemp = 0;
	int nNumBytes = 0;
	int nNumBytesTemp = 0;
	int nPosPtr;
	int p=0;
	int posAr=0;
	int position_buf_read=0;
	int previousRecord=-1;
	int recordBufferLength;
	int retcode_func=0;
	int useRecord;
	int64_t   lPosPnt = 0;
	struct mmfio_t* ArrayFile[MAX_HANDLE_TEMPFILE];
	unsigned char  szKeyCurr[1024+SZPOSPNT];
	unsigned char  szKeyPrec[1024+SZPOSPNT];
	unsigned char  szKeySave[1024+SZPOSPNT];
	unsigned char  szKeyTemp[1024+SZPOSPNT];
	unsigned char* ptrBuf[MAX_HANDLE_TEMPFILE];
	unsigned char* recordBuffer;
	unsigned char* recordBufferPrevious;  // for SUm Fileds NONE
	unsigned char* szBufRekTmpFile[MAX_HANDLE_TEMPFILE];
	unsigned char* szBuffRek;  
	unsigned char* szBuffRekOutRec;
	unsigned char* szPrecSumFields;	// Prec
	unsigned char* szSaveSumFields; // save
	unsigned int   nLenRek = 0;
	unsigned int nLenPrec = 0;
	unsigned int nLenRecOut = 0;
	unsigned int nLenSave=0;

    if (job->bIsPresentSegmentation == 0)
		return 0;

	recordBufferLength=MAX_RECSIZE;   //(job->outputLength>job->inputLength?job->outputLength:job->inputLength);
	recordBufferLength = recordBufferLength + nSplitPosPnt + NUMCHAREOL;
	recordBuffer=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*GCSORT*S048*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

	recordBufferPrevious=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*GCSORT*S049*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

	for (kj=0; kj < MAX_HANDLE_TEMPFILE;kj++) {
		szBufRekTmpFile[kj] = (unsigned char *) malloc(recordBufferLength);
		if (szBufRekTmpFile[kj] == 0)
			fprintf(stderr,"*GCSORT*S050*ERROR: Cannot Allocate szBufRek1 : %s - id : %d\n", strerror(errno), kj);
	}

	szBuffRek=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRek == 0)
		fprintf(stderr,"*GCSORT*S051*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));

	szBuffRekOutRec=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRekOutRec == 0)
		fprintf(stderr,"*GCSORT*S052*ERROR: Cannot Allocate szBuffRekOutRec : %s\n", strerror(errno));

	szPrecSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szPrecSumFields == 0)
		fprintf(stderr,"*GCSORT*S053*ERROR: Cannot Allocate szPrecSumFields : %s\n", strerror(errno));

	szSaveSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szSaveSumFields == 0)
		fprintf(stderr,"*GCSORT*S054*ERROR: Cannot Allocate szSaveSumFields : %s\n", strerror(errno));
// new
// Verify segmentation and if last section of file input
//

	cob_open(job->outputFile->stFileDef,  COB_OPEN_OUTPUT, 0, NULL);
	if (atol((char *)job->outputFile->stFileDef->file_status) != 0) {
		fprintf(stderr,"*GCSORT*S055*ERROR: Cannot open file %s - File Status (%c%c)\n",file_getName(job->outputFile), 
			job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
		retcode_func = -1;
		goto job_save_tempfinal_exit;
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
			fprintf(stderr,"*GCSORT*S056*ERROR: Cannot open file %s : %s\n",szNameTmp,strerror(errno));
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
		job_GetKeys(szBufRekTmpFile[nPosPtr]+SZPOSPNT, szKeyTemp); 
		SumField_ResetTot(job); // reset totalizer
		bIsFirstSumFields = 1;
		nLenRek = byteReadTmpFile[nPosPtr];
		memmove(szKeyPrec, szBufRekTmpFile[nPosPtr], SZPOSPNT);
		memmove(szKeyPrec+SZPOSPNT, szKeyTemp, job->nLenKeys);
		memcpy(szPrecSumFields, szBufRekTmpFile[nPosPtr], nLenRek+SZPOSPNT);
		nLenPrec = nLenRek;
		memcpy(szKeySave,		szKeyPrec, job->nLenKeys+SZPOSPNT);			   //lPosPnt + Key
		memcpy(szSaveSumFields, szPrecSumFields, nLenPrec+SZPOSPNT);
		nLenSave = nLenPrec;
	}

	while ((nSumEof) < MAX_HANDLE_TEMPFILE) //job->nNumTmpFile)
	{		
		nLenRecOut = job->outputLength;

		nPosPtr = job_IdentifyBuf(ptrBuf, nMaxEle);
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
			job_GetKeys(szBufRekTmpFile[nPosPtr]+SZPOSPNT, szKeyTemp); 
			memcpy(szKeyCurr,    szBufRekTmpFile[nPosPtr], SZPOSPNT);			//lPosPnt
			memcpy(szKeyCurr+SZPOSPNT,  szKeyTemp, job->nLenKeys+SZPOSPNT);				//Key
			useRecord = SumFields_KeyCheck(job, &bIsWrited, szKeyPrec, &nLenPrec, szKeyCurr,  &nLenRek, szKeySave,  &nLenSave, 
                                           szPrecSumFields, szSaveSumFields, szBufRekTmpFile[nPosPtr], SZPOSPNT);
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
				SumField_SumFieldUpdateRek((unsigned char*)szBufRekTmpFile[nPosPtr]+SZPOSPNT);		// Update record in  memory
				SumField_ResetTot(job);														// reset totalizer
				SumField_SumField((unsigned char*)szPrecSumFields+SZPOSPNT);						// Sum record in  memory
			}				
//
			if (byteRead > 0) 
			{
				job_set_area(job, job->outputFile, szBufRekTmpFile[nPosPtr]+nSplitPosPnt, nLenRecOut);	// Len output
				cob_write (job->outputFile->stFileDef, job->outputFile->stFileDef->record, job->outputFile->opt, NULL, 0);
				if (atol((char *)job->outputFile->stFileDef->file_status) != 0) {
					fprintf(stderr,"*GCSORT*S057*ERROR: Cannot write to file %s - File Status (%c%c)\n",file_getName(job->outputFile),
						job->outputFile->stFileDef->file_status[0],job->outputFile->stFileDef->file_status[1]);
            		retcode_func = -1;
					goto job_save_tempfinal_exit;
				}
				job->recordWriteOutTotal++;
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
			bIsEof[nLastRead] = job_ReadFileTemp(ArrayFile[nLastRead], &byteReadTmpFile[nLastRead], szBufRekTmpFile[nLastRead], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
			if (bIsEof[nLastRead] == 1) {
				ptrBuf[nLastRead] = 0x00;
				nSumEof = nSumEof + bIsEof[nLastRead];
			}
		}
	}
	if ((job->sumFields==2) && (bIsWrited == 1)) {   // pending buffer
		SumField_SumFieldUpdateRek((char*)szPrecSumFields+SZPOSPNT);				// Update record in  memory
		memcpy(recordBuffer, szPrecSumFields, nLenPrec+SZPOSPNT);		// Substitute record for write
		nLenRek = nLenPrec;
        nLenRecOut = job->outputLength;
		job_set_area(job, job->outputFile, recordBuffer+nSplitPosPnt, nLenRecOut); // Len output
		cob_write (job->outputFile->stFileDef, job->outputFile->stFileDef->record, job->outputFile->opt, NULL, 0);
		if (atol((char *)job->outputFile->stFileDef->file_status) != 0) {
			fprintf(stderr,"*GCSORT*S058*ERROR: Cannot write to file %s - File Status (%c%c)\n",file_getName(job->outputFile),
					job->outputFile->stFileDef->file_status[0],job->outputFile->stFileDef->file_status[1]);
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
job_save_tempfinal_exit:
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
	cob_close (job->outputFile->stFileDef, NULL, COB_CLOSE_NORMAL, 0);

	if (desc > 0){
		if ((close(desc))<0) {
			fprintf(stderr,"*GCSORT*S059*ERROR: Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			return -1;
		}
	}
	if (job->outfil != NULL){
		if (outfil_close_files(job) < 0) 
				return -1;
	}
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
	byteReadTemp = mmfio_Read((unsigned char*) szBuffRek, lenBE+SZPOSPNT, &descTmp);
	if (byteReadTemp <= 0) {
		bTempEof = 1;
		*nLR = 0;
		return bTempEof;
	}

	*nLR = byteReadTemp-SZPOSPNT;
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
			case FIELD_TYPE_FLOAT:
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
			case FIELD_TYPE_NUMERIC_CLO:
			case FIELD_TYPE_NUMERIC_CSL:
			case FIELD_TYPE_NUMERIC_CST:
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

void job_getTypeFlags (int nTypeField, int* nType, int* nFlags ) {
		switch (nTypeField) {
// NO 	case FIELD_TYPE_CHARACTER:
			case FIELD_TYPE_BINARY:
                *nType = COB_TYPE_NUMERIC_BINARY;
                *nFlags = COB_FLAG_BINARY_SWAP;
				break;
			case FIELD_TYPE_FIXED:
                *nType = COB_TYPE_NUMERIC_BINARY;
                *nFlags = COB_FLAG_HAVE_SIGN | COB_FLAG_BINARY_SWAP;
				break;
			case FIELD_TYPE_FLOAT:
				if (sortField_getLength(sortField) > 4)
                    *nType = COB_TYPE_NUMERIC_DOUBLE;
				else
                    *nType = COB_TYPE_NUMERIC_FLOAT;
                *nFlags = COB_FLAG_HAVE_SIGN;
				break;
			case FIELD_TYPE_PACKED:
                *nType = COB_TYPE_NUMERIC_PACKED;
                *nFlags = COB_FLAG_HAVE_SIGN;
				break;
			case FIELD_TYPE_ZONED:
                *nType = COB_TYPE_NUMERIC_DISPLAY;
                *nFlags = COB_FLAG_HAVE_SIGN;
				break;
			case FIELD_TYPE_NUMERIC_CLO:
                *nType = COB_TYPE_NUMERIC_DISPLAY;
                *nFlags = COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_LEADING;
				break;
			case FIELD_TYPE_NUMERIC_CSL:
                *nType = COB_TYPE_NUMERIC_DISPLAY;
                *nFlags = COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_LEADING | COB_FLAG_SIGN_SEPARATE;
				break;
			case FIELD_TYPE_NUMERIC_CST:
                *nType = COB_TYPE_NUMERIC_DISPLAY;
                *nFlags = COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_SEPARATE;
				break;
			default:
				break;
		}
    return ;
}

INLINE int job_compare_key(const void *first, const void *second) 
{
    int nType, nLen, nFlags;
	result=0;
	nSp=SZPOSPNT; // first 8 byte for PosPnt
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		g_fd1->data = (unsigned char*) first+nSp;
		g_fd2->data = (unsigned char*) second+nSp;
        nLen = sortField_getLength(sortField);
        
        if (sortField_getType(sortField) == FIELD_TYPE_CHARACTER)
            result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
        else
            job_getTypeFlags (sortField_getType(sortField), &nType, &nFlags);
		if (sortField_getType(sortField) != FIELD_TYPE_CHARACTER) {
			job_cob_field_set(g_fd1, nType, nLen, 0, nFlags, nLen);
			job_cob_field_set(g_fd2, nType, nLen, 0, nFlags, nLen);
			result = cob_cmp(g_fd1, g_fd2);
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
INLINE int job_compare_rek(const void *first, const void *second, int bCheckPosPnt) 
{
    int nType, nLen, nFlags;
	lPosA = 0;
	lPosB = 0;
	result=0;
	nSp=SZPOSPNT; // first 8 byte for PosPnt
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		g_fd1->data = (unsigned char*) first+sortField_getPosition(sortField)-1+nSp;
		g_fd2->data = (unsigned char*) second+sortField_getPosition(sortField)-1+nSp;
		
        nLen = sortField_getLength(sortField);
        if (sortField_getType(sortField) == FIELD_TYPE_CHARACTER)
		    result=memcmp( (unsigned char*) first+sortField_getPosition(sortField)-1+nSp, (unsigned char*) second+sortField_getPosition(sortField)-1+nSp, sortField_getLength(sortField));
        else
            job_getTypeFlags (sortField_getType(sortField), &nType, &nFlags);

		if (sortField_getType(sortField) != FIELD_TYPE_CHARACTER) {
			job_cob_field_set(g_fd1, nType, nLen, 0, nFlags, nLen);
			job_cob_field_set(g_fd2, nType, nLen, 0, nFlags, nLen);
			result = cob_cmp(g_fd1, g_fd2);
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
			memcpy(&lPosA, (unsigned char*)first, SZPOSPNT);
			memcpy(&lPosB, (unsigned char*)second,SZPOSPNT);
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
INLINE int job_compare_qsort(const void *first, const void *second) 
{
    int nType, nLen, nFlags;
	lPosA = 0;
	lPosB = 0;
	nSp=0;
	result=0;
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		g_fd1->data = (unsigned char*) first+nSp;
		g_fd2->data = (unsigned char*) second+nSp;
        nLen = sortField_getLength(sortField);
        if (sortField_getType(sortField) == FIELD_TYPE_CHARACTER)
		    result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
        else
            job_getTypeFlags (sortField_getType(sortField), &nType, &nFlags);

		if (sortField_getType(sortField) != FIELD_TYPE_CHARACTER) {
			job_cob_field_set(g_fd1, nType, nLen, 0, nFlags, nLen);
			job_cob_field_set(g_fd2, nType, nLen, 0, nFlags, nLen);
			result = cob_cmp(g_fd1, g_fd2);
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
			memcpy(&lPosA, (unsigned char*)first+globalJob->nLenKeys,SZPOSPNT);
			memcpy(&lPosB, (unsigned char*)second+globalJob->nLenKeys,SZPOSPNT);
			if(lPosA < lPosB)
				result = -1;
			if(lPosA > lPosB)
				result = 1;
			// debug             fprintf(stdout,"lPosA = %16I64d - lPosB = %16I64d \n", lPosA, lPosB);
			return result;
		}
		
	return 0;
}

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
		if (strlen(cob_tmpdir) == 0)
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

    char szNameTmp[FILENAME_MAX];
    int	bIsEof[MAX_FILES_INPUT];
    int	bIsFirstSumFields = 0;
    int	bTempEof=0;
    int	handleFile[MAX_FILES_INPUT];
    int	nCompare = 1;
    int	nSumEof;
    int	recordBufferLength;
    int bFirstRound=0;
    int bIsFirstTime = 1;
    int bIsWrited = 0;
    int byteReadFile[MAX_FILES_INPUT];
    int k;
    int kj;
    int nIdx1; //, bIsEOF;
    int nIdxFileIn = 0;
    int nLastRead=0;
    int nLenInRec = 0;
    int nMaxEle;
    int nMaxFiles = MAX_FILES_INPUT;		// size of elements
    int nNumBytes = 0;
    int nPosPtr, nIsEOF;
    int nPosition = 0;
    int nSplitPosPnt = SZPOSPNT;		// for pospnt
    int nbyteRead;
    int previousRecord=-1;
    int retcode_func=0;
    int useRecord;
    int64_t			lPosPnt = 0;
    struct file_t *file;
    struct file_t*  Arrayfile_s[MAX_FILES_INPUT];
    unsigned char	szBufKey[MAX_FILES_INPUT][1024+SZPOSPNT];	// key
    unsigned char	szBufRek[MAX_FILES_INPUT][32768+SZPOSPNT];	// key
    unsigned char	szKeyCurr[1024+SZPOSPNT];
    unsigned char	szKeyPrec[1024+SZPOSPNT];
    unsigned char	szKeySave[1024+SZPOSPNT];
    unsigned char	szKeyTemp[1024+SZPOSPNT];
    unsigned char*	szPrecSumFields;	// Prec
    unsigned char*	szSaveSumFields; // save
    unsigned char*  ptrBuf[MAX_FILES_INPUT];
    unsigned char*  recordBuffer;
    unsigned char*  recordBufferPrevious;  // for SUm Fileds NONE
    unsigned char*  szBuffRek;
    unsigned int	nLenPrec = 0;
    unsigned int	nLenRecOut=0;
    unsigned int	nLenRek = 0;
    unsigned int	nLenSave=0;

	recordBufferLength=MAX_RECSIZE;

	szPrecSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szPrecSumFields == 0)
		fprintf(stderr,"*GCSORT*S060*ERROR: Cannot Allocate szPrecSumFields : %s\n", strerror(errno));

	szSaveSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szSaveSumFields == 0)
		fprintf(stderr,"*GCSORT*S061*ERROR: Cannot Allocate szSaveSumFields : %s\n", strerror(errno));


	job->nLenKeys = job_GetLenKeys();
	job->nLastPosKey = job_GetLastPosKeys();

	if (job->nLastPosKey <= NUMCHAREOL)
		job->nLastPosKey = NUMCHAREOL;	// problem into memchr

	for (k=0; k<nMaxFiles; k++)
	{
		byteReadFile[k] = 0;
		Arrayfile_s[k] = NULL;
		memset(szBufKey[k], 0x00, 1024);
		memset(szBufRek[k], 0x00, sizeof(szBufRek[k]));
		ptrBuf[k] = 0x00;   
	}
	recordBufferLength=MAX_RECSIZE;
	// onlyfor Line Sequential
	if (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL)
		recordBufferLength=recordBufferLength+2+1;

	recordBuffer=(unsigned char *) malloc(recordBufferLength+nSplitPosPnt);
	if (recordBuffer == 0)
 		fprintf(stderr,"*GCSORT*S062*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

	recordBufferPrevious=(unsigned char *) malloc(recordBufferLength+nSplitPosPnt);
	if (recordBuffer == 0)
 		fprintf(stderr,"*GCSORT*S063*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

	szBuffRek=(unsigned char *) malloc(recordBufferLength+nSplitPosPnt);
	if (szBuffRek == 0)
		fprintf(stderr,"*GCSORT*S064*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));

	for (kj=0; kj < MAX_FILES_INPUT;kj++) {
		byteReadFile[kj] = 0;
		handleFile[kj] = 0;
		bIsEof[kj] = 1;
	}

// new
// Verify segmentation and if last section of file input
//
	if (job->outputFile != NULL) { // new
		cob_open(job->outputFile->stFileDef,  COB_OPEN_OUTPUT, 0, NULL);
		if (atol((char *)job->outputFile->stFileDef->file_status) != 0) {
			fprintf(stderr,"*GCSORT*S065*ERROR: Cannot open file %s - File Status (%c%c)\n",file_getName(job->outputFile),
				job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
			retcode_func = -1;
			goto job_merge_files_exit;
		}
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
// LIBCOB for all files
		cob_open(Arrayfile_s[nIdx1]->stFileDef,  COB_OPEN_INPUT, 0, NULL);
		if (atol((char *)Arrayfile_s[nIdx1]->stFileDef->file_status) != 0) {
			fprintf(stderr,"*GCSORT*S066*ERROR: Cannot open file %s - File Status (%c%c)\n",file_getName(Arrayfile_s[nIdx1]),Arrayfile_s[nIdx1]->stFileDef->file_status[0], Arrayfile_s[nIdx1]->stFileDef->file_status[1]);
			retcode_func = -1;
			goto job_merge_files_exit;
		}
		bIsEof[nIdx1] = job_ReadFileMerge(Arrayfile_s[nIdx1], &handleFile[nIdx1], &byteReadFile[nIdx1], szBufRek[nIdx1], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
		if (bIsEof[nIdx1] == 0)
			ptrBuf[nIdx1] = (unsigned char*)szBufRek[nIdx1];
		nIdx1++;
		if (nIdx1 > nMaxFiles){
			fprintf(stderr,"Too many files input for MERGE Actual/Limit: %d/%d\n",nIdx1, nMaxFiles);
			retcode_func = -1;
			goto job_merge_files_exit;
		}
	}
// in this point nIdx1 is max for number of files input
// 
	nIsEOF = 0; 
	nPosition = 0;
	nSumEof = 0;
	for (kj=0; kj < MAX_FILES_INPUT;kj++) {
		nSumEof = nSumEof + bIsEof[kj];
	}

	bFirstRound = 0;
	bIsFirstTime = 0;

	nMaxEle = MAX_FILES_INPUT;
	if (nIdx1 < MAX_FILES_INPUT)
		nMaxEle = nIdx1;
	nPosPtr = job_IdentifyBuf(ptrBuf, nMaxEle);

	if (nPosPtr >= 0) {
		job_GetKeys(szBufRek[nPosPtr]+nSplitPosPnt, szKeyTemp);		// for merge no POSPNT
		SumField_ResetTot(job); // reset totalizer
		bIsFirstSumFields = 1;
		nLenRek = byteReadFile[nPosPtr];
		memset(szKeyPrec, 0x00, sizeof(szKeyPrec));
		memmove(szKeyPrec+nSplitPosPnt, szKeyTemp,        job->nLenKeys);
		memmove(szPrecSumFields,        szBufRek[nPosPtr], nLenRek+nSplitPosPnt);
		nLenPrec = nLenRek;
		memset(szKeySave, 0x00, sizeof(szKeySave));
		memcpy(szKeySave+nSplitPosPnt,		szKeyPrec,       job->nLenKeys);			   //lPosPnt + Key
		memcpy(szSaveSumFields,             szPrecSumFields, nLenPrec+nSplitPosPnt);
		nLenSave = nLenPrec;
	}


	while ((nSumEof) < MAX_FILES_INPUT) //job->nNumTmpFile)
	{		
		nLenRecOut = file_getMaxLength(job->outputFile);

// start of check
// Identify buffer 
		nPosPtr = job_IdentifyBufMerge(ptrBuf, nMaxEle);
// Setting fields for next step (Record, Position, Len)	
// Setting buffer for type fle
		memcpy(recordBuffer, szBufRek[nPosPtr], byteReadFile[nPosPtr]+nSplitPosPnt);
		nLastRead = nPosPtr;
		nbyteRead = byteReadFile[nPosPtr];
		job->LenCurrRek = byteReadFile[nPosPtr];
		nLenRek = nbyteRead;
		job->recordNumberTotal++;
// new version for SUM FIELDS
		useRecord=1;
// new new new  INCLUDE - OMIT
		if (useRecord==1 && job->includeCondField!=NULL && condField_test(job->includeCondField,(unsigned char*) recordBuffer+nSplitPosPnt, job)==0) 
			useRecord=0;
		if (useRecord==1 && job->omitCondField!=NULL && condField_test(job->omitCondField,(unsigned char*) recordBuffer+nSplitPosPnt, job)==1) 
			useRecord=0;
// INREC
		if (useRecord == 1) {
			if (job->inrec!=NULL) {
				memset(szBuffRek, 0x20, recordBufferLength);
				nLenInRec = inrec_copy(job->inrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
				if (recordBufferLength < nLenInRec)
					recordBuffer= (unsigned char*) realloc(recordBuffer,nLenInRec+1);
				memcpy(recordBuffer+nSplitPosPnt, szBuffRek, nLenInRec );
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
				memcpy(recordBufferPrevious, recordBuffer, job->LenCurrRek+nSplitPosPnt); 
			}
// SUMFIELD			2 = FIELDS
			if (job->sumFields==2) {
				job_GetKeys(recordBuffer+nSplitPosPnt, szKeyTemp); 
				// MERGE NO CHECK FOR POSPNT memcpy(szKeyCurr,    szBufRek[nPosPtr], 8);			//lPosPnt
				memset(szKeyCurr,  0x00, sizeof(szKeyCurr));				//Key
				memcpy(szKeyCurr+nSplitPosPnt,  szKeyTemp, job->nLenKeys);				//Key
				useRecord = SumFields_KeyCheck(job, &bIsWrited, szKeyPrec, &nLenPrec, szKeyCurr,  &nLenRek, szKeySave,  &nLenSave, 
                                           szPrecSumFields, szSaveSumFields, recordBuffer, nSplitPosPnt);
			}

			if (useRecord==0){	// skip record 
				if (bIsEof[nLastRead] == 0){
					bIsEof[nLastRead] = job_ReadFileMerge(Arrayfile_s[nLastRead], &handleFile[nLastRead], &byteReadFile[nLastRead], szBufRek[nLastRead], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
					if (bIsEof[nLastRead] == 1) {
						ptrBuf[nLastRead] = 0x00;
						nSumEof = nSumEof + bIsEof[nLastRead];
					}
				}
				continue;
			}

			job->LenCurrRek = nLenRek;
			if (job->outrec!=NULL) {
				memset(szBuffRek, 0x20, recordBufferLength);
				nbyteRead = outrec_copy(job->outrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
				memcpy(recordBuffer, szBuffRek, nbyteRead);
				job->LenCurrRek = nbyteRead ;
				nLenRek = nbyteRead;
			}
			if ((nbyteRead > 0) && (job->outfil == NULL)){
				if (job->sumFields==2) {
					bIsWrited = 1;
					SumField_SumFieldUpdateRek((unsigned char*)recordBuffer+nSplitPosPnt);		// Update record in  memory
					SumField_ResetTot(job);									// reset totalizer
					SumField_SumField((unsigned char*)szPrecSumFields+nSplitPosPnt);			// Sum record in  memory
				}				
				job_set_area(job, job->outputFile, recordBuffer+nSplitPosPnt, nLenRecOut);
				cob_write (job->outputFile->stFileDef, job->outputFile->stFileDef->record, job->outputFile->opt, NULL, 0);
				if (atol((char *)job->outputFile->stFileDef->file_status) != 0) {
					fprintf(stderr,"*GCSORT*S067*ERROR: Cannot open file %s - File Status (%c%c)\n",file_getName(job->outputFile), 
						job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
					job_print_error_file(job->outputFile->stFileDef, nLenRecOut);
            		retcode_func = -1;
					goto job_merge_files_exit;
				}
				job->recordWriteOutTotal++;
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
			bIsEof[nLastRead] = job_ReadFileMerge(Arrayfile_s[nLastRead], &handleFile[nLastRead], &byteReadFile[nLastRead], szBufRek[nLastRead], bIsFirstTime);  // bIsEof = 0 ok, 1 = eof
			if (bIsEof[nLastRead] == 1) {
				ptrBuf[nLastRead] = 0x00;
				nSumEof = nSumEof + bIsEof[nLastRead];
			}
		}

	}

// 
	if ((job->sumFields==2) && (bIsWrited == 1)) {   // pending buffer
		SumField_SumFieldUpdateRek((unsigned char*)szPrecSumFields+nSplitPosPnt);				// Update record in  memory
		memcpy(recordBuffer, szPrecSumFields, nLenPrec+nSplitPosPnt);		// Substitute record for write
		nLenRek = nLenPrec;
		job_set_area(job, job->outputFile, recordBuffer+nSplitPosPnt, nLenRecOut);	// Len output
		cob_write (job->outputFile->stFileDef, job->outputFile->stFileDef->record, job->outputFile->opt, NULL, 0);
		if (atol((char *)job->outputFile->stFileDef->file_status) != 0) {
			fprintf(stderr,"*GCSORT*S068*ERROR: Cannot write file %s - File Status (%c%c)\n",file_getName(job->outputFile), 
				job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
            retcode_func = -1;
			goto job_merge_files_exit;
		}
       job->recordWriteOutTotal++;
	}

job_merge_files_exit:
	free(szBuffRek);
	free(recordBuffer);
	free(recordBufferPrevious);
	free(szPrecSumFields);
	free(szSaveSumFields);

	for (kj=0; kj < MAX_HANDLE_TEMPFILE; kj++) { 
		if (Arrayfile_s[kj] != NULL) {
			if (Arrayfile_s[kj]->stFileDef != NULL) 
				cob_close (Arrayfile_s[kj]->stFileDef, NULL, COB_CLOSE_NORMAL, 0);
		}
	}
	return retcode_func;
}
//INLINE int job_ReadFileMerge(struct BufferedReader_t * reader, struct file_t* file, int* descTmp, int* nLR, unsigned char* szBuffRek, int nFirst)
INLINE int job_ReadFileMerge(struct file_t* file, int* descTmp, int* nLR, unsigned char* szBuffRek, int nFirst)
{
    unsigned int lenBE = 0;
	int bTempEof=0;
	int nLenRek=0;
	int nbyteRead=0; 
	nLenRek = file_getMaxLength(file);


// LIBCOB for all files
	cob_read_next(file->stFileDef,  NULL, COB_READ_NEXT);
	if (atol((char *)file->stFileDef->file_status) != 0) {	// Check 
		if (atol((char *)file->stFileDef->file_status) == 10) {	// EOF
			bTempEof = 1;
			nLenRek = 0;
			*nLR = 0;
			return bTempEof;
		}
		if (atol((char *)file->stFileDef->file_status) > 10) {
			fprintf(stderr,"*GCSORT*S069*ERROR: Cannot read file %s - File Status (%c%c) \n",file_getName(file), 
					file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
				exit(OC_RTC_ERROR);
		}
		else
		{
			fprintf(stderr,"*GCSORT*W967a* Warning reading file %s - File Status (%c%c) \n",file_getName(file), 
					file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
		}
	}
	nLenRek = file->stFileDef->record->size;
    memcpy(szBuffRek+SZPOSPNT, file->stFileDef->record->data, file->stFileDef->record->size);

	*nLR = nLenRek;
	return bTempEof;
}

cob_field* job_cob_field_create ( void )
{
	cob_field       *field_ret;
	cob_field_attr	*attrArea;
	attrArea = (cob_field_attr*) malloc(sizeof(cob_field_attr));
	field_ret = (cob_field*)malloc(sizeof(cob_field));
	field_ret->attr = attrArea;
	return field_ret;
}
void job_cob_field_set (cob_field* field_ret, int type, int digits, int scale, int flags, int nLen)
{
	cob_field_attr	*attrArea;
	attrArea = (cob_field_attr*)field_ret->attr;
	attrArea->type   = type;
	attrArea->digits = digits;
	attrArea->scale  = scale;
	attrArea->flags  = flags;
	attrArea->pic    = NULL;
	field_ret->size = nLen;

    util_setAttrib ( attrArea, type, nLen); // Fix value

	return ;
}
void job_cob_field_destroy ( cob_field* field_ret)
{
	if (field_ret!=NULL) {
		if (field_ret->attr!=NULL)
				free((void*)field_ret->attr); 
		free(field_ret);  
	}
}
void job_print_error_file(cob_file* cobF, int nLenOut) {
	fprintf(stderr,"*GCSORT* record write          : %d \n", nLenOut);
	fprintf(stderr,"*GCSORT* record defition min   : %zu \n", cobF->record_min);
	fprintf(stderr,"*GCSORT* record defition max   : %zu \n", cobF->record_max);
	return;
}