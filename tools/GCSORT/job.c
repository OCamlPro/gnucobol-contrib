/*
    Copyright (C) 2016-2021 Sauro Menna
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
    #include <sys/types.h>
    #include <unistd.h>
    #include <inttypes.h>
#endif

#include <stdlib.h>
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

#include "exitroutines.h"

#define MAIN_FILE
#include "gcshare.h"
//--> #undef  MAIN_FILE

// #include "bufferedreader.h"
// #include "bufferedwriter.h"

#define _CRTDBG_MAP_ALLOC
#include <stdlib.h>

#ifdef _MSC_VER
	#include <crtdbg.h>
#endif
 

char  szHeaderOutMF[128];
cob_field*      g_fd1;      // field for compare key
cob_field*      g_fd2;      // field for compare key

cob_field*		g_fdate1;
cob_field*      g_fdate2;
cob_field*		g_ckfdate1;
cob_field*		g_ckfdate2;

int	nLenMemory=0;
int g_lenRek = -1;
int nSp=0;
int nTypeFieldsCmd = 0;
int result=0;
int64_t lPosA = 0;
int64_t lPosB = 0;
long nSpread = 0;
struct sortField_t *sortField;
int g_nTypeGC;
int g_nType;
int g_nLen;
int g_nFlags;
int g_idx;
int g_idx_max=0;
cob_field* cob_field_key[100];
unsigned char* g_pdata[100];

int g_nSp=0;
int g_result=0;
int g_first_sort=0;

const uint8_t *g_src;
uint8_t *g_dst;
size_t g_i;

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
	job->nOutFileSameOutFile=0;
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
	// job->ulMemSizeAlloc		= GCSORT_ALLOCATE_MEMSIZE;
	// job->ulMemSizeAllocSort = GCSORT_ALLOCATE_MEMSIZE/100*10;		//
    job->ulMemSizeAllocSort = GCSORT_ALLOCATE_MEMSIZE/100*10;
    job->ulMemSizeAlloc = GCSORT_ALLOCATE_MEMSIZE - job->ulMemSizeAllocSort;
	job->nLastPosKey = 0;	// Last position of key
	job->nTestCmdLine=0;
	job->nMlt  = MAX_MLTP_BYTE;

	job->job_typeOP = 'C';  // default Sort operation (Copy)

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
				fprintf(stderr,"GCSORT - Error on GCSORT_STATISTICS parameter. Value 0 for suppress info , 1 for Summary, 2 for Details. Value Environment: %d\n", job->nStatistics);
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
	// GC_YEAR = set year 4 digits
	job->nY2Year = 0;
	time_t t = time(NULL);
	struct tm tm = *localtime(&t);
	job->nY2Year = tm.tm_year + 1900;
	job->nY2Past = 0;
	job->nY2PastLimInf = 0;
	job->nY2PastLimSup = 0;
	pEnvEmule = getenv("GC_YEAR");
	if (pEnvEmule != NULL)
	{
		job->nY2Year = atol(pEnvEmule);  
		// check errors
		if ((job->nY2Year < 1000) || (job->nY2Year > 3000)) {
			fprintf(stderr, "GCSORT Warning : Value of Year error, set current year %d\n", job->nY2Year);
			time_t t = time(NULL);
			struct tm tm = *localtime(&t);
			job->nY2Year = tm.tm_year + 1900;
		}
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
	memset(job->strCallNameE15, 0x00, FILENAME_MAX);
	memset(job->strCallNameE35, 0x00, FILENAME_MAX);
	job->nExitRoutine = 0;
	job->E15Routine = NULL;
	job->E35Routine = NULL;
	//
	g_fd1 = NULL;   
	g_fd2 = NULL; 
	g_fdate1 = NULL;
	g_fdate2 = NULL;
	g_ckfdate1 = NULL;
	g_ckfdate2 = NULL;

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

void job_ReviewMemAlloc ( struct job_t *job  ) 
{
	double  nLenKey = job_GetLenKeys();
	double  nLenRek = job->inputLength;
	double  nPerc = (nLenKey + SIZESRTBUFF ) / nLenRek * 100;
	// in the case where nLenRek too big or too small
	if (nPerc > 50) //perform. 50)
		nPerc = 50;
	if (nPerc < 15)
		nPerc = 15;
	job->ulMemSizeAllocSort = (job->ulMemSizeAlloc*(int64_t)nPerc)/100;
	job->ulMemSizeAlloc = job->ulMemSizeAlloc - job->ulMemSizeAllocSort;

	//	printf(" file_length %I64d \n", job->file_length);
//	printf(" job->ulMemSizeAlloc     %I64d \n", job->ulMemSizeAlloc);
//	printf(" job->ulMemSizeAllocSort %I64d \n", job->ulMemSizeAllocSort);


// Allocate field for compare
	g_fd1 = job_cob_field_create();
	g_fd2 = job_cob_field_create();

	// Date field for compare values - Allocated 
	g_ckfdate1 = util_MakeAttrib_call(COB_TYPE_NUMERIC_DISPLAY, 8, 0, 0, 8, ALLOCATE_DATA);
	cob_set_int(g_ckfdate1, 0);
	g_ckfdate2 = util_MakeAttrib_call(COB_TYPE_NUMERIC_DISPLAY, 8, 0, 0, 8, ALLOCATE_DATA);
	cob_set_int(g_ckfdate2, 0);

	// field for date (only reference)
	g_fdate1 = util_MakeAttrib_call(COB_TYPE_NUMERIC_DISPLAY, 8, 0, 0, 8, NOALLOCATE_DATA);

	// field for date (only reference)
	g_fdate2 = util_MakeAttrib_call(COB_TYPE_NUMERIC_DISPLAY, 8, 0, 0, 8, NOALLOCATE_DATA);
	// cob_set_int(g_fdate2, 0);
//
	return;
}

int job_sort (struct job_t* job) 
{
	int nContinueSrtTmp=0;
	int nRC=0;

	do {
        if (job->nStatistics == 2)
                util_print_time_elap("Before  job_loadFiles     ");
		nContinueSrtTmp = 0;
		nRC = job_loadFiles(job);
		if (job->nStatistics == 2) 
				util_print_time_elap("After   job_loadFiles     ");
		if (nRC == -2)
			nContinueSrtTmp = 1;
		if (nRC == -1)
			break;
        if (job->nStatistics == 2)
                util_print_time_elap("Before  job_sort          ");
		nRC = job_sort_data(job); 
		if (job->nStatistics == 2) 
				util_print_time_elap("After   job_sort          ");
		if (nRC == -1)
			break;
        if (job->nStatistics == 2)
                util_print_time_elap("Before  job_save          ");
		if (job->bIsPresentSegmentation == 0)
			nRC = job_save_out(job);
		else
			nRC = job_save_tempfile(job);
		if (job->nStatistics == 2) 				
                util_print_time_elap("After   job_save          ");
		if (nRC == -1)
				break;
	} while (nContinueSrtTmp == 1);
	if ((nRC >= 0) && (job->bIsPresentSegmentation == 1)){
		if ((job->nStatistics == 2) && (job->bIsPresentSegmentation == 1))
			    util_print_time_elap("Before  job_save_tempfinal");
		nRC = job_save_tempfinal(job);
		if ((job->nStatistics == 2) &&  (job->bIsPresentSegmentation == 1))
				util_print_time_elap("After   job_save_tempfinal");
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
	int   returnCode=-1;

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
            // s.m. 20201015
            // skip option
            if (!(strcasecmp(argv[i],"-fsign=EBCDIC")==0) && !(strcasecmp(argv[i],"-fsign=ASCII")==0)) {
				strcpy(buffer+bufferLength+1,argv[i]);
			    bufferLength+=argvLength;
		    }
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
	if (returnCode == 0) {
		returnCode = job_CloneFileForOutfil(job); 
	}
//
// 
// Clone informations from GIVE File for all OUTFIL files.
	if (returnCode == 0) {
		returnCode = job_MakeExitRoutines(job);
	}
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


// Exit Routines definition
int job_MakeExitRoutines(struct job_t* job)
{
	if (job->nExitRoutine == 1) {
		job->E15Routine = E15Call_constructor(job->inputFile->maxLength);
		E15Call_SetCallName(job->E15Routine, job->strCallNameE15);
		if (job->E15Routine == NULL)
			utl_abend_terminate(EXITROUTINE, 16, ABEND_EXEC);
	}
	if (job->nExitRoutine == 2) {
		job->E35Routine = E35Call_constructor(job->outputFile->maxLength);
	    E35Call_SetCallName(job->E35Routine, job->strCallNameE35);
		if (job->E35Routine == NULL)
			utl_abend_terminate(EXITROUTINE, 16, ABEND_EXEC);
	}
	if (job->nExitRoutine == 3) {
		job->E15Routine = E15Call_constructor(job->inputFile->maxLength);
		E15Call_SetCallName(job->E15Routine, job->strCallNameE15);
		if (job->E15Routine == NULL)
			utl_abend_terminate(EXITROUTINE, 16, ABEND_EXEC);
		job->E35Routine = E35Call_constructor(job->outputFile->maxLength);
		E35Call_SetCallName(job->E35Routine, job->strCallNameE35);
		if (job->E35Routine == NULL)
			utl_abend_terminate(EXITROUTINE, 16, ABEND_EXEC);
	}
	return 0;
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

void job_checkslash(char* str)
{
	int nL = strlen(str);
	for (int k=0;k<nL;k++) {
		if (str[k] == '/')
			str[k] = '\\';
	}
}

int job_RedefinesFileName( struct job_t *job) 
{
	struct file_t *file;
	char szExt[5];
	
	int nPos=-1;
	if (job->inputFile!=NULL) {
		for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
			nPos++;
			if (nPos > job->nMaxFileIn) {
					fprintf(stderr,"*GCSORT*S002*ERROR: Problem with file name input %s, %s, %d\n",job->inputFile->name, job->arrayFileInCmdLine[nPos], nPos--);
					return -1;
			}
			memcpy(file->name, job->arrayFileInCmdLine[nPos], strlen(job->arrayFileInCmdLine[nPos]));
#if _WIN32    // all commands for linux, change for windows
			job_checkslash(file->name);
#endif
			if (file->stFileDef != NULL) {
				memset(file->stFileDef->assign->data, 0x00, strlen(job->arrayFileInCmdLine[nPos])+1);
				memcpy(file->stFileDef->assign->data, job->arrayFileInCmdLine[nPos], strlen(job->arrayFileInCmdLine[nPos]));
//#if CONFIGURED_ISAM == VBISAM
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
#if _WIN32    // all commands for linux, change for windows
			job_checkslash(file->name);
#endif
			if (file->stFileDef != NULL) {
				//-->>free(file->stFileDef->assign->data);
				//-->>file->stFileDef->assign->data = _strdup(job->arrayFileOutCmdLine[nPos]);
				memset(file->stFileDef->assign->data, 0x00, strlen(job->arrayFileOutCmdLine[nPos]) + 1);
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
	char  szFileName[GCSORT_SIZE_FILENAME];
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
				exit(GC_RTC_ERROR);
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
				memset(szFileName, 0x00, GCSORT_SIZE_FILENAME);
				sprintf(szFileName, " USE FI%03d", job->nMaxFileIn); // new file name
				// alloc same dimension of file input for string
				if (nSp2 > (int)(strlen(szFileName)-strlen(strUSE))) { 
					nSp9= strlen(szFileName);
					//-->> s.m. 202105 for (pk=nSp9-strlen(strUSE); pk < nPosNull;pk++) {
					// -5 FInnn
					for (pk = nSp9 - strlen(strUSE); pk < nPosNull; pk++) {
						strcat(szFileName, "A");
					}
				}
				strcat(bufnew,		szFileName);	// concat new file name
				pch1 = pch2 + nSp3;
			}
			else
			{
				fprintf(stderr,"*GCSORT*S005*ERROR: Command ORG not found or lower case, use uppercase\n");
				exit(GC_RTC_ERROR);
			}
		}
		else
		{
			if (bFound == 0) {
				fprintf(stderr,"*GCSORT*S006*ERROR: Command USE not found or lower case, use uppercase\n");
				exit(GC_RTC_ERROR);
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
	char  szFileName[GCSORT_SIZE_FILENAME];
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
				memset(szFileName, 0x00, GCSORT_SIZE_FILENAME);
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
				exit(GC_RTC_ERROR);
			}
		}
		else
		{
			if (bFound == 0) {
				fprintf(stderr,"*GCSORT*S009*ERROR: Command USE not found or lower case, use uppercase\n");
				exit(GC_RTC_ERROR);
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
		exit(GC_RTC_ERROR); 
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
			if (job->outputLength != file_getMaxLength(job->outputFile) && file_getMaxLength(job->outputFile)!=0) {
				fprintf(stderr,"*GCSORT*W003* WARNING : Outrec clause define a file with a different length than give record clause\n");
				g_retWarn=4;
            } 
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
				fprintf(stderr,"*GCSORT*W001* WARNING : Cannot remove file %s : %s\n", szNameTmp,strerror(errno));
				g_retWarn=4;
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
				if (job->nCountSrt[nIdx] > 0)
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
		switch (job->job_typeOP) {
		case ('C'):
			printf("Operation  : COPY\n\n");
			break;
		case ('M'):
			printf("Operation  : MERGE\n\n");
			break;
		case ('S'):
			printf("Operation  : SORT\n\n");
			break;
		}

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
			if (job->job_typeOP == 'C')
				printf(" FIELDS = COPY ");
			else {
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
	// OPTION Y2PAST
		if (job->nY2Past != 0) {
			fprintf(stderr, "Y2PAST = %d \n", job->nY2Past);
			fprintf(stderr, "    Current date : %d \n", job->nY2Year);
			fprintf(stderr, "    Range Date   : %d (min) - %d (max)\n", job->nY2PastLimInf, job->nY2PastLimSup);
			fprintf(stderr, "    Min Date     : %d (2 digits) \n", job->nY2PastLimInfyy2);
		}
	//
	// OPTION MODS
		if (job->E15Routine != 0) {
			fprintf(stderr, "MODS E15 (%s)\n", job->E15Routine->pCallE15->data);
		}
		if (job->E35Routine != 0) {
			fprintf(stderr, "MODS E35 (%s)\n", job->E35Routine->pCallE35->data);
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
	job_cob_field_destroy(g_ckfdate1);
	job_cob_field_destroy(g_ckfdate2);

	//-->> only reference no allocation   
	job_cob_field_destroy(g_fd1);
	//-->> only reference no allocation   
	job_cob_field_destroy(g_fd2);

	/*
	job_cob_field_destroy(g_fdate1D);
	job_cob_field_destroy(g_fdate2D);
	job_cob_field_destroy(g_fDateLimInf);
	*/
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
	 
	// verify Exit Routine
	if (job->nExitRoutine > 0) { 
		if (job->E15Routine) 
			E15Call_destructor(job->E15Routine);
		if (job->E35Routine)
			E35Call_destructor(job->E35Routine);
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
	unsigned int nbyteRead;
	int nk=0;
	int useRecord;
//	int     lrecordNumber=0;
	int64_t lPosSeqLS = 0;
	int64_t lPosBuf=0;
	long int nMemAllocate = 0;
	long nRecCount = 0;
	struct file_t* file;
	int nIsFileVariable = 0;

	int arSrtFldPosLen[MAXFIELDSORT*2];

	//perf2. 	unsigned char  recordBuffer[GCSORT_MAX_BUFF_REK];
	//perf2. 	unsigned char  szBuffKey[GCSORT_MAX_BUFF_REK];
	//perf2. 	unsigned char  szBuffRekNull[GCSORT_MAX_BUFF_REK];
	//perf2. 	unsigned char  szBuffRek[GCSORT_MAX_BUFF_REK];
	
	unsigned char* pAddress;
	unsigned int   nLenRek;
	unsigned int   nPosCurrentSeek = 0;

	unsigned char* pBufRek;
	unsigned char* pBufData;

	unsigned char* vSortBuf; // [GCSORT_MAX_BUFF_REK] ;
	vSortBuf = (unsigned char*)malloc((size_t)GCSORT_MAX_BUFF_REK);
	if (vSortBuf == 0)
		fprintf(stderr, "*GCSORT*S320a*ERROR: Cannot Allocate vSortBuf : %s\n", strerror(errno));

	//pAddress = (unsigned char*)malloc(SZPNTDATA+1);
	//if (pAddress == 0)
	//	fprintf(stderr, "*GCSORT*S030A*ERROR: Cannot Allocate pAddress : %s\n", strerror(errno));

 	unsigned char*  recordBuffer;
 	unsigned char* szBuffKey;
 	unsigned char* szBuffRekNull;
 	unsigned char* szBuffRek;
	unsigned char* szBuffReceive;
	unsigned char* szVectorRead1;		// record input file 
	unsigned char* szVectorRead2;		// record input file 

 	recordBuffer = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	//-->>//recordBuffer = (unsigned char*)malloc((size_t)GCSORT_MAX_BUFF_REK);
 	if (recordBuffer == 0)
 		fprintf(stderr, "*GCSORT*S320*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));
 	szBuffKey  = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	//-->>//szBuffKey = (unsigned char*)malloc((size_t)GCSORT_MAX_BUFF_REK);
 	if (szBuffKey == 0)
 		fprintf(stderr, "*GCSORT*S321*ERROR: Cannot Allocate szBuffKey : %s\n", strerror(errno));
 	szBuffRekNull = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	//-->>//szBuffRekNull = (unsigned char*)malloc((size_t)GCSORT_MAX_BUFF_REK);
 	if (szBuffRekNull == 0)
 		fprintf(stderr, "*GCSORT*S322*ERROR: Cannot Allocate szBuffRekNull : %s\n", strerror(errno));
 	szBuffRek = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	//-->>//szBuffRek = (unsigned char*)malloc((size_t)GCSORT_MAX_BUFF_REK);
 	if (szBuffRek == 0)
 		fprintf(stderr, "*GCSORT*S323*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));

	
	szBuffReceive = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	if (szBuffReceive == 0)
		fprintf(stderr, "*GCSORT*S324*ERROR: Cannot Allocate szBuffReceive : %s\n", strerror(errno));


	szVectorRead1 = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	if (szVectorRead1 == 0)
		fprintf(stderr, "*GCSORT*S325*ERROR: Cannot Allocate szVectorRead1 : %s\n", strerror(errno));
	memset(szVectorRead1, 0x00, GCSORT_MAX_BUFF_REK);
	szVectorRead2 = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	if (szVectorRead2 == 0)
		fprintf(stderr, "*GCSORT*S326*ERROR: Cannot Allocate szVectorRead2 : %s\n", strerror(errno));
	memset(szVectorRead2, 0x00, GCSORT_MAX_BUFF_REK);

	memset(vSortBuf, 0x00, GCSORT_MAX_BUFF_REK);

	memset(szBuffRekNull, 0x00, GCSORT_MAX_BUFF_REK);
	if (job->bIsPresentSegmentation == 0) {
		job->recordNumber=0;
		job->recordNumberAllocated=GCSORT_ALLOCATE;
//				
		// 				job->recordData=(unsigned char *)malloc((size_t)job->ulMemSizeAlloc);
		// 		job->buffertSort=(unsigned char *)malloc((size_t)job->ulMemSizeAllocSort);
//				
// perf.		
			// 
		job->recordData=(unsigned char *)calloc((size_t)job->ulMemSizeAlloc, sizeof(unsigned char));
			// 
		job->buffertSort=(unsigned char *)calloc((size_t)job->ulMemSizeAllocSort, sizeof(unsigned char));
// perf.	
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
// perf.
/*
        printf (" ------------------------------------- job->inputFile->nFileMaxSize %d \n", job->inputFile->nFileMaxSize );
        if ( (job->inputFile->nFileMaxSize > 0) && (job->inputFile->nFileMaxSize*2+1 < job->ulMemSizeAlloc) ){
           //  job->ulMemSizeAlloc = job->inputFile->nFileMaxSize * 2,5;
            job->ulMemSizeAllocSort = job->ulMemSizeAlloc / 3;
		// perf. original
            job->recordData=(unsigned char *)malloc((size_t)job->ulMemSizeAlloc, sizeof(unsigned char));
		// perf. original
            job->buffertSort=(unsigned char *)malloc((size_t)job->ulMemSizeAllocSort, sizeof(unsigned char));
            //job->recordData = realloc((unsigned char *)job->recordData, (size_t)job->ulMemSizeAlloc);
            //job->buffertSort = realloc((unsigned char *)job->buffertSort,(size_t)job->ulMemSizeAllocSort);
        }
    */
// perf.
            // perf.
            // perf. job_ReviewMemAlloc(job);
            // perf

			cob_open(file->stFileDef,  COB_OPEN_INPUT, 0, NULL);
			if (atol((char *)file->stFileDef->file_status) != 0) {
				fprintf(stderr,"*GCSORT*S017*ERROR: Cannot open file %s - File Status (%c%c) \n",file_getName(file),
					file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
				return -1;
			}
			nEOFFileIn=0;
			if (file->stFileDef->variable_record)
				nIsFileVariable = 1; // File is Variable Length
		}
		bEOF = 0;
		nLenMemory = file_getMaxLength(file);
		nLenRek = file_getRecordLength(file);
		nbyteRead=0;

		// lrecordNumber=job->recordNumber;
		// precordNumber=&job->recordNumber;
// perf.
		// perf.
		pBufRek=job->buffertSort;
		// perf.

        pBufData = job->recordData;
// perf.

		int nNumFiledSort = job_SetPosLenKeys(arSrtFldPosLen);
		int np = 0;
		int retc = 0;
		short ninrec = 0;
		short nomitcondfield = 0;
		short includecondfield = 0;
		int rcE15 = 0;
		int nrekE15 = 0;
		int nrekFlagE15 = 0;
		int rc = 0;
		if (job->includeCondField != NULL)
			includecondfield = 1;
		if (job->omitCondField != NULL)
			nomitcondfield = 1;
		if (job->inrec != NULL)
			ninrec = 1;

		//
		// ======================================================================================= //
		// Record buffered 
		//  for E15
		int nFS = 0;
		int nLastRecord = 0;  // 0 no, 1 yes is last record input
		int nInsE15 = 0;      // 0 no record from E15, 1 record from E15
		int nState = 0;
		int nPosArray = 0;	  // 1 = Position 1(szVectorRead1) 
		                      // 2 = Position 2(szVectorRead2)
		int nLenVR1 = 0;
		int nLenVR2 = 0;
		int nFSRead = 0;
		int nNewLen = 0;
		if (job->inputFile->nFileMaxSize == 0) {
				bEOF = 1;
		}
		// ======================================================================================= //
		while (bEOF == 0)
		{
			//-->>start = GetTickCount64(); // program starts

			if ((job->nExitRoutine == 0) || (job->nExitRoutine == 2)) {		// 0=normal , 1=E15, 2=E35 , 3=E15+E35 only with 1 call read for E15
				// Read normal without exit routines
				cob_read_next(file->stFileDef, NULL, COB_READ_NEXT);
				nFSRead = job_checkFS(file->stFileDef);
				if (nFSRead != 0) {
					if (nFSRead == 1) {
						bEOF = 1;
						nbyteRead = 0;
						continue;
					}
					if (nFSRead == -1)
						return -1; //exit(GC_RTC_ERROR);
				}				
			}
			else 
			{
				nFS = job_Verify_EOF(&nState, job, file->stFileDef, szVectorRead1, &nLenVR1, szVectorRead2, &nLenVR2);
				if ((nFS == 99) && (nLastRecord == 1)) {
					bEOF = 1;
					nbyteRead = 0;
					continue;
				}
				if (nFS != 0)
					nLastRecord = 1;
			}
			nLenRek = file->stFileDef->record->size;
			// perf. memcpy(szBuffRek, file->stFileDef->record->data, file->stFileDef->record->size);
			gc_memcpy(szBuffRek, file->stFileDef->record->data, file->stFileDef->record->size);

			nRecCount++;
			job->recordNumberTotal++;
			job->LenCurrRek = nLenRek;
// check SKIPREC

			if (job->nSkipRec > 0)
                if (nRecCount <= job->nSkipRec)
					continue;

			useRecord=1;

			// Start Exit Routine E15
			/*
			Return Code	Meaning
				0	No action required.
				4	Delete the current record.For E15, the record is not sorted.For E35, the record is not written to the output data set.
				8	Do not call this exit again; exit processing is no longer required.
				12	Insert the current record.For E15, the record is inserted for sorting.For E35, the record is written to the output data set.
				16	Terminate sort operation.The job step is terminated with the condition code set to 16.
				20	Alter the current record.For E15, the altered record is passed to the sort.For E35, the altered record is written to the output data set.
			*/
			if ((job->nExitRoutine == 1) || (job->nExitRoutine == 3)) {		// Call E15			
				if (rc != 12 ) {				// is rc = 12 last call for insert record
					E15ResetParams(&nrekE15, &nrekFlagE15, nLastRecord);
					if (nrekE15 != 8) {
						rc = E15Run(0, job->E15Routine, nrekFlagE15, nLenRek, szBuffRek, szBuffReceive, &nNewLen, nIsFileVariable);
						switch (rc) {
						case 0:			// Nothing
							break;
						case 4:			// Skip record
							useRecord = 0;
							break;
						case 8:			// No call again E15
							nrekE15 = 8;
							break;
						case 12:		// Insert new Record into buffer before record readed
							memmove(szBuffRek, szBuffReceive, nLenRek);
							nState = nState + 5;   // Set nState to +5 value to skip next read and move saved buffer 
							break;
						case 16:		// Abend
							utl_abend_terminate(EXITROUTINE, 16, ABEND_EXEC);
							break;
						case 20:		// Use record received from E15
							memmove(szBuffRek, szBuffReceive, nLenRek);
							break;
						}
					}
				}
				else 
				{
					rc = 0;
				}
			}
			// End   Exit Routine E15 check skip record
			if (useRecord == 0)
				continue;

			// if (job->includeCondField!=NULL)
			if (includecondfield == 1)
				// s.m. 20210516
                //if  (condField_test(job->includeCondField,(unsigned char*) szBuffRek, job)==0) {
				//if  (condField_test(job->includeCondField,(unsigned char*) szBuffRek, job)!=0) {
				if  (condField_test(job->includeCondField,(unsigned char*) szBuffRek, job)== FALSE) {
					useRecord=0;	// if condition for include is false skip record
			}
			// if (job->omitCondField!=NULL)
			if (nomitcondfield == 1) {
				if (condField_test(job->omitCondField,(unsigned char*) szBuffRek, job)==TRUE) {	
					useRecord = 0;	// if condition for omit is true skip record
				}
			}
			if (useRecord==0)
				continue;

// check STOPAFT
			if (job->nStopAft > 0)
                if (job->recordNumber >= job->nStopAft) {
					nbyteRead=0;
					break;
			}
//

// INREC
// If INREC is present made a new area record.
// Only in this point
// Before all command
			//if (job->inrec!=NULL) {
			if (ninrec == 1) {
				if (job->inrec->nIsOverlay == 0) {
					memset(recordBuffer, 0x20, sizeof(recordBuffer));
					nbyteRead = inrec_copy(job->inrec, recordBuffer, szBuffRek, job->outputLength, file_getMaxLength(file), file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, 0);
					memmove(szBuffRek, recordBuffer, nbyteRead);
					nLenRek = nbyteRead;
				}
				else
				{		// Overlay
					memset(recordBuffer, 0x20, sizeof(recordBuffer));
					memmove(recordBuffer, szBuffRek, file_getMaxLength(file));	// copy input record
					nbyteRead = inrec_copy_overlay(job->inrec, recordBuffer, szBuffRek, job->outputLength, file_getMaxLength(file), file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, 0);
					nbyteRead++;
					// copy all data record
					if (nbyteRead < job->inputLength)
						nbyteRead = job->inputLength;
					memmove(szBuffRek, recordBuffer, nbyteRead);
					nLenRek = nbyteRead;
				}
			}
//
			//In this point extract key from record
			// Most important IF INREC present all commands get record from INREC definition
			//-->> 
			job_GetKeys(szBuffRek, szBuffKey);

			// Area = Buffer Key + Absolute Position from biginning file + Recorld Length
			// Buffer Key + 2 len record + 2 position key

			job->LenCurrRek = nLenRek;
// perf.
            lPosBuf = (job->recordNumber)*((int64_t)job->nLenKeys+ (int64_t)SIZESRTBUFF);
// perf.
			pAddress = (unsigned char*)job->recordData + job->ulMemSizeRead;
			// perf.
			gc_memcpy(job->recordData+job->ulMemSizeRead	, szBuffRek, job->LenCurrRek);
	       // pBufData = memcpy((unsigned char*) pBufData	, (unsigned char*) szBuffRek, job->LenCurrRek);
		
			// Key, PosPnt, Len , Pointer
			// nn , 8     , 4   , 8
			//Key
			/**/
		
			gc_memmove((unsigned char*) vSortBuf, (unsigned char*)szBuffKey, job->nLenKeys);
			gc_memmove((unsigned char*)vSortBuf+job->nLenKeys, (unsigned char*)&job->lPosAbsRead, SZPOSPNT); // PosPnt
			gc_memmove((unsigned char*)vSortBuf+job->nLenKeys+SZPOSPNT, (unsigned char*)&job->LenCurrRek,  SZLENREC); // len
			gc_memmove((unsigned char*)vSortBuf+job->nLenKeys+SZPOSPNT+SZLENREC, (unsigned char*)&pAddress, SZPNTDATA); // Pointer Address Data
		
			gc_memmove((unsigned char*)job->buffertSort + lPosBuf, (unsigned char*)vSortBuf, job->nLenKeys + SZPOSPNT + SZLENREC + SZPNTDATA);
		
			job->ulMemSizeRead += (int64_t) nLenRek; // key + pointer record + record length
			job->ulMemSizeSort += (int64_t)job->nLenKeys + (int64_t)SIZESRTBUFF;

            job->lPosAbsRead = job->lPosAbsRead + (int64_t)nLenRek;  // Setting value of Position Record

            job->recordNumber++;

			// check for next read record
			if (((int64_t)(job->ulMemSizeRead + (((int64_t)nLenMemory ) * 2)) >= job->ulMemSizeAlloc) ||
				((int64_t)(job->ulMemSizeSort + (((int64_t)job->nLenKeys + (int64_t)SIZESRTBUFF) * 2))  >= job->ulMemSizeAllocSort))	{
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

	free(recordBuffer);
	free(szBuffKey);
	free(szBuffRekNull);
	free(szBuffRek);
	free(vSortBuf);
	free(szBuffReceive);
	free(szVectorRead1);
	free(szVectorRead2);
	// free(pAddress);

	return 0;
}

// Routine for E15 call
// Verify last record 
// Read record and swap with state value
//
int job_Verify_EOF(int* nState, struct job_t* job, cob_file* stFileDef, unsigned char* szVectorRead1, int* nLenVR1, unsigned char* szVectorRead2, int* nLenVR2)
{
	// nState
	// 0 - Initial
	// 1 - save buffer 1 and get buffer 2
	// 2 - save buffer 2 and get buffer 1
	// 5 - (0 + 5) -
	// 6 - (1 + 5) -  after E15 with return code 12 - Get Buffer 2
	// 7 - (2 + 5) -  after E15 with return code 12 - Get Buffer 1  

	int nFS = 0;
	switch (*nState) {
		case(0): {		// First call
			cob_read_next(stFileDef, NULL, COB_READ_NEXT);
			nFS = job_checkFS(stFileDef);
			if (nFS > 0) {
				*nState = 99;
				return nFS;
			}
			*nLenVR1 = stFileDef->record->size;
			gc_memcpy(szVectorRead1, stFileDef->record->data, stFileDef->record->size);
			//
			cob_read_next(stFileDef, NULL, COB_READ_PREVIOUS);
			nFS = job_checkFS(stFileDef);
			if (nFS > 0) {
				stFileDef->record->size = *nLenVR1;
				gc_memcpy(stFileDef->record->data, szVectorRead1, stFileDef->record->size);
				*nState = 99;
				return nFS;
			}
			*nLenVR2 = stFileDef->record->size;
			gc_memcpy(szVectorRead2, stFileDef->record->data, *nLenVR2);
			*nState = 1;
			// reset record
			stFileDef->record->size = *nLenVR1;
			gc_memcpy(stFileDef->record->data, szVectorRead1, stFileDef->record->size);
			break;
		}
		   //
		case(1): {		// Get buffer2, save buffer1
			*nState = 2;
			cob_read_next(stFileDef, NULL, COB_READ_NEXT);
			nFS = job_checkFS(stFileDef);
			if (nFS > 0) {
				stFileDef->record->size = *nLenVR2;
				gc_memcpy(stFileDef->record->data, szVectorRead2, stFileDef->record->size);
				*nState = 99;
				return nFS;
			}
			*nLenVR1 = stFileDef->record->size;
			gc_memcpy(szVectorRead1, stFileDef->record->data, stFileDef->record->size);
		//
			stFileDef->record->size = *nLenVR2;
			gc_memcpy(stFileDef->record->data, szVectorRead2, stFileDef->record->size);
			//
			break;
		}
		   //
		case(2): {		// Get buffer1, save buffer2
			*nState = 1;
			cob_read_next(stFileDef, NULL, COB_READ_NEXT);
			nFS = job_checkFS(stFileDef);
			if (nFS > 0) {
				stFileDef->record->size = *nLenVR1;
				gc_memcpy(stFileDef->record->data, szVectorRead1, stFileDef->record->size);
				*nState = 99;
				return nFS;
			}
			*nLenVR2 = stFileDef->record->size;
			gc_memcpy(szVectorRead2, stFileDef->record->data, stFileDef->record->size);
			//
			stFileDef->record->size = *nLenVR1;
			gc_memcpy(stFileDef->record->data, szVectorRead1, stFileDef->record->size);
			//
			break;
		}
		case(6): {		// Get buffer2, not read file for previous call E15 with return code 12
		//
			*nState = 1;
			stFileDef->record->size = *nLenVR1;
			gc_memcpy(stFileDef->record->data, szVectorRead1, stFileDef->record->size);
			//
			break;
		}
		case(7): {		// Get buffer1, not read file for previous call E15 with return code 12
			*nState = 2;
			stFileDef->record->size = *nLenVR2;
			gc_memcpy(stFileDef->record->data, szVectorRead2, stFileDef->record->size);
			//
			break;
		}
		case(99): {
			nFS = 99;
			return nFS;
		}
		default: {
			fprintf(stderr, "*GCSORT*E918* ERROR : Case in job_Verify_EOF not present - Value (%d) \n" , *nState);
		}
	}
	//

	return nFS;
}

int job_checkFS(cob_file* stFileDef)
{
	int rcode = 0;
	if (memcmp((unsigned char*)stFileDef->file_status , "00", 2)) {	// Check
		if (atol((char*)stFileDef->file_status) == 10) {	// EOF
			rcode = 1;
			return rcode;
		}
		if (atol((char*)stFileDef->file_status) > 10) {
			fprintf(stderr,"*GCSORT*S018*ERROR: Cannot read file %s - File Status (%c%c) \n",stFileDef->assign->data,
					stFileDef->file_status[0], stFileDef->file_status[1]);
			rcode = -1; //exit(GC_RTC_ERROR);
			return rcode;
		}
		else
		{
			fprintf(stderr,"*GCSORT*W968* WARNING : Warning reading file %s - File Status (%c%c) \n",stFileDef->assign->data,
					stFileDef->file_status[0], stFileDef->file_status[1]);
			rcode = 4;
			return rcode;
		}
	}
	return rcode;
}


#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	int job_sort_data(struct job_t *job)
#else
	static INLINE2 int job_sort_data(struct job_t* job)
#endif
{
	int i=0;
	globalJob=job;
	g_first_sort=0;
	//
	// Date
	//
	g_idx=0;
//#if	!defined(_MSC_VER) && !defined(__MINGW32__) && !defined(__MINGW64__)
	struct sortField_t* sortField;
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
        g_nLen = sortField->length;
        g_nTypeGC=sortField->type;
        if (g_nTypeGC != FIELD_TYPE_CHARACTER) {
            job_getTypeFlags (g_nTypeGC, &g_nType, &g_nFlags, g_nLen);
            job_cob_field_set(g_fd1, g_nType, g_nLen, 0, g_nFlags, g_nLen);
            job_cob_field_set(g_fd2, g_nType, g_nLen, 0, g_nFlags, g_nLen);
            cob_field_key[g_idx]=(cob_field*)util_cob_field_make(g_fd1->attr->type, g_fd1->attr->digits, g_fd1->attr->scale, g_fd1->attr->flags,g_fd1->size, ALLOCATE_DATA);
			g_pdata[g_idx] = (unsigned char*) cob_field_key[g_idx]->data;
            g_idx++;
            cob_field_key[g_idx]=(cob_field*)util_cob_field_make(g_fd2->attr->type, g_fd2->attr->digits, g_fd2->attr->scale, g_fd2->attr->flags,g_fd2->size, ALLOCATE_DATA);
			g_pdata[g_idx] = (unsigned char*) cob_field_key[g_idx]->data;
			g_idx++;
		}
    }
    g_idx_max=g_idx-1;
// #endif
	//
	if (job->sortField!=NULL) {
		qsort(job->buffertSort, (size_t)job->recordNumber, job->nLenKeys + SIZESRTBUFF, job_compare_qsort);  // check record position
    }
//#if	!defined(_MSC_VER) && !defined(__MINGW32__) && !defined(__MINGW64__)
	for (int k=0;k<g_idx_max;k++) {
		cob_field_key[k]->data = g_pdata[k];
        util_cob_field_del(cob_field_key[k], ALLOCATE_DATA);
    }
//#endif
    g_first_sort=0;
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
	unsigned int nLenInRec = 0;
	int nNumBytes = 0;
	int nNumBytesTemp = 0;
	int position_buf_write=0;
	unsigned int recordBufferLength;
	int useRecord;
	int64_t	nReadTmpFile;
	int64_t i;
	int64_t lPosPnt = 0;
	int64_t previousRecord=-1;
	unsigned char  szKeyCurr[GCSORT_KEY_MAX+SZPOSPNT];
	unsigned char  szKeyPrec[GCSORT_KEY_MAX+SZPOSPNT];
	unsigned char  szKeySave[GCSORT_KEY_MAX+SZPOSPNT];
	// unsigned char  szKeyFirst[1024+SZPOSPNT];
	unsigned char* pAddress;
	unsigned char* recordBuffer;
	unsigned char* recordBufferPrevious;  // for Sum Fileds NONE
	unsigned char* szBuffRek;
	unsigned char* szBuffOut;
	unsigned char* szBuffRekE35;
	unsigned char* szPrecSumFields;	// Prec
	unsigned char* szSaveSumFields; // save
	unsigned char* szFirstRek;
	unsigned char* szBuffReceive;
	unsigned int   byteRead = 0;
	unsigned int   lpntTemp = 0;
	unsigned int   nLenPrec = 0;
	unsigned int   nLenRecOut=0;
	unsigned int   nLenRek = 0;
	unsigned int   nLenRekTemp = 0;
	unsigned int   nLenSave = 0;	// recordBufferLength=(job->outputLength>job->inputLength?job->outputLength:job->inputLength);
    unsigned int   bIsFirstKeySumField = 0;
	unsigned int   nbyteOvl = 0;
	//
	// ======================================================================================= //
	// Record buffered 
	//  for E35
	int nFS = 0;
	int nLastRecord = 0;  // 0 no, 1 yes is last record input
	int nInsE35 = 0;      // 0 no record from E35, 1 record from E35
	int nState = 0;
	int nPosArray = 0;	  // 1 = Position 1(szVectorRead1) 
						  // 2 = Position 2(szVectorRead2)
	int nLenVR1 = 0;
	int nLenVR2 = 0;
	int nFSRead = 0;
	int nNewLen = 0;
	int rcE35 = 0;
	int nrekE35 = 0;
	int nrekFlagE35 = 0;
	int rc = 0;
	int nIsFileVariable = 0;
	int nOutLen = 0;
	// ======================================================================================= //
	recordBufferLength=MAX_RECSIZE;
	recordBufferLength = recordBufferLength + SZPOSPNT;

//	recordBuffer=(unsigned char *) calloc( (size_t)recordBufferLength, sizeof(unsigned char));
 	recordBuffer=(unsigned char *) malloc( (size_t)recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*GCSORT*S020*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

//	recordBufferPrevious=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	recordBufferPrevious=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*GCSORT*S021*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

//	szBuffRek=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	szBuffRek=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRek == 0)
		fprintf(stderr,"*GCSORT*S022*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));

//	szBuffOut=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	szBuffOut=(unsigned char *) malloc(recordBufferLength);
	if (szBuffOut == 0)
		fprintf(stderr,"*GCSORT*S023*ERROR: Cannot Allocate szBuffOut : %s\n", strerror(errno));
	memset(szBuffOut, 0x00, recordBufferLength);

//	szPrecSumFields=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	szPrecSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szPrecSumFields == 0)
		fprintf(stderr,"*GCSORT*S024*ERROR: Cannot Allocate szPrecSumFields : %s\n", strerror(errno));

//	szSaveSumFields=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	szSaveSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szSaveSumFields == 0)
		fprintf(stderr,"*GCSORT*S025*ERROR: Cannot Allocate szSaveSumFields : %s\n", strerror(errno));

//	szFirstRek = (unsigned char*)calloc(recordBufferLength, sizeof(unsigned char));
	szFirstRek = (unsigned char*)malloc(recordBufferLength);
	if (szFirstRek == 0)
		fprintf(stderr, "*GCSORT*S025A*ERROR: Cannot Allocate szFirstRek : %s\n", strerror(errno));

	szBuffReceive = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	if (szBuffReceive == 0)
		fprintf(stderr, "*GCSORT*S025B*ERROR: Cannot Allocate szBuffReceive : %s\n", strerror(errno));


	szBuffRekE35 = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	if (szBuffRekE35 == 0)
		fprintf(stderr, "*GCSORT*S025C*ERROR: Cannot Allocate szBuffRekE35 : %s\n", strerror(errno));


	if (job->outfil != NULL) {
		if (outfil_open_files(job) < 0) {
			retcode_func = -1;
			goto job_save_exit;
		}
	}
	// Outfil == NULL, standard output file
    //if (job->outfil == NULL) {
	if ((job->outputFile != NULL) && (job->nOutFileSameOutFile == 0)) {
		cob_open(job->outputFile->stFileDef,  COB_OPEN_OUTPUT, 0, NULL);
		if (atol((char *)job->outputFile->stFileDef->file_status) != 0) {
			fprintf(stderr,"*GCSORT*S026*ERROR: Cannot open file %s - File Status (%c%c)\n",file_getName(job->outputFile),
				job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
			retcode_func = -1;
			goto job_save_exit;
		}
		if (job->outputFile->stFileDef->variable_record)
			nIsFileVariable = 1; // File is Variable Length
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
		//
		gc_memcpy(&lPosPnt, job->buffertSort + (i) * ((int64_t)job->nLenKeys + SIZESRTBUFF) + job->nLenKeys, SZPOSPNT);  // lPosPnt
		gc_memcpy(&nLenRek, job->buffertSort + (i) * ((int64_t)job->nLenKeys + SIZESRTBUFF) + job->nLenKeys + SZPOSPNT, SZLENREC);  // nLenRek
		//-->>
		gc_memcpy(&pAddress, job->buffertSort + (i) * ((int64_t)job->nLenKeys + SIZESRTBUFF) + job->nLenKeys + SZPOSPNT + SZLENREC, SZPNTDATA); // Pointer Data Area
		//-->> 202101 new pAddress=job->buffertSort+(i)*((int64_t)job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SZPOSPNT+SZLENREC; // Pointer Data Area

		gc_memcpy(szBuffRek, &lPosPnt, SZPOSPNT); // PosPnt
		gc_memcpy(szBuffRek + SZPOSPNT, pAddress, nLenRek); // buffer


// SUMFIELDS Verify condition for SumFields  == 0, == 1 (None), == 2 (P,L,T)
		// 1  SUM FIELDS = NONE
		if (job->sumFields==1) {
			if (previousRecord!=-1) {
				if (job_compare_rek(recordBufferPrevious, szBuffRek, 0)==0) // no check pospnt
					useRecord=0;
			}
			previousRecord=1;
			memcpy(recordBufferPrevious, szBuffRek, nLenRek+nSplitPosPnt);
		}
// SUMFIELD
		// 2  SUM FIELDS = (P,L,T,....)
		if (job->sumFields==2) {
			memcpy(szKeyCurr,            job->buffertSort+(i)*(job->nLenKeys+SIZESRTBUFF)+job->nLenKeys, SZPOSPNT);  //lPosPnt
			memcpy(szKeyCurr + SZPOSPNT, job->buffertSort+(i)*(job->nLenKeys+SIZESRTBUFF), job->nLenKeys);  //Key

		// s.m. 202012
			if (bIsFirstKeySumField == 0) {			// Save first key for sum field, use this for write
		    	memcpy(szFirstRek, szBuffRek, nLenRek + nSplitPosPnt);  //PosPnt + First Record
		    	bIsFirstKeySumField = 1;
		   }
			useRecord = SumFields_KeyCheck(job, &bIsWrited, szKeyPrec, &nLenPrec, szKeyCurr,  &nLenRek, szKeySave,  &nLenSave,
                                           szPrecSumFields, szSaveSumFields, szBuffRek, SZPOSPNT);
		}

		if (useRecord==0)	// skip record
			continue;

		byteRead = nLenRek + nSplitPosPnt;
		nNumBytes = nNumBytes + byteRead;
		gc_memcpy(recordBuffer, szBuffRek, byteRead);
		// s.m. 202012
		if (bIsFirstKeySumField == 1) {
			bIsFirstKeySumField = 0;
			gc_memcpy(recordBuffer, szFirstRek, nLenRek + nSplitPosPnt);
		}
		//

		if (job->outrec != NULL) {
			// check overlay
			if (job->outrec->nIsOverlay == 0) {
				memset(szBuffRek, 0x20, recordBufferLength);
				nLenRek = outrec_copy(job->outrec, szBuffRek, recordBuffer, job->outputLength, byteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
				memset(recordBuffer, 0x20, recordBufferLength); // s.m. 202101
				gc_memcpy(recordBuffer, szBuffRek, nLenRek + nSplitPosPnt);
				nLenRecOut = nLenRek;
			}
			else
			{		// Overlay
				memset(szBuffRek, 0x20, recordBufferLength);
				gc_memcpy((unsigned char*)szBuffRek, recordBuffer, nLenRek + nSplitPosPnt);	// s.m. 202101 copy record
				nbyteOvl = outrec_copy_overlay(job->outrec, szBuffRek, recordBuffer, job->outputLength, byteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
				nbyteOvl++;
				if (nbyteOvl < nLenRek)
					nbyteOvl = nLenRek;
				if (recordBufferLength < nbyteOvl)
					recordBuffer = (unsigned char*)realloc(recordBuffer, nbyteOvl + 1);
				memset(recordBuffer, 0x20, recordBufferLength); // s.m. 202101
				gc_memcpy(recordBuffer + nSplitPosPnt, szBuffRek + nSplitPosPnt, nbyteOvl);
				nLenRecOut = nbyteOvl;
			}
		}

		if (bTempEof == 1)
			memcpy(recordBuffer, szBuffRek, nLenRek+nSplitPosPnt);

		// recordBuffer contains record
		// E35 Start
		/*
		Return Code	Meaning
			0	No action required.
			4	Delete the current record. For E35, the record is not written to the output data set.
			8	Do not call this exit again; exit processing is no longer required.
			12	Insert the current record. For E35, the record is written to the output data set.
			16	Terminate sort operation.The job step is terminated with the condition code set to 16.
			20	Alter the current record. For E35, the altered record is written to the output data set.
		*/
		if ((job->nExitRoutine == 2) || (job->nExitRoutine == 3)) {		// Call E35		
			gc_memmove(szBuffRekE35, recordBuffer + SZPOSPNT, nLenRek);
			if (i + 1 == job->recordNumber)
				nLastRecord = 1;			// set EOF for sorted data
			if (rc != 12) {					// is rc = 12 last call for insert record
				E35ResetParams(&nrekE35, &nrekFlagE35, nLastRecord);
				if (nrekE35 != 8) {
					rc = E35Run(0, job->E35Routine, nrekFlagE35, nLenRek, szBuffRekE35, szBuffReceive, szBuffOut, &nNewLen, &nOutLen, nIsFileVariable);
					switch (rc) {
					case 0:			// Nothing
						break;
					case 4:			// Skip record
						useRecord = 0;
						break;
					case 8:			// No call again E35
						nrekE35 = 8;
						break;
					case 12:		// Insert new Record into buffer before record readed
						memmove(recordBuffer + SZPOSPNT, szBuffReceive, nLenRek);
						//
						i = i - 1; // insert record and reset pointer record
						//
						break;
					case 16:		// Abend
						utl_abend_terminate(EXITROUTINE, 16, ABEND_EXEC);
						break;
					case 20:		// Use record received from E35
						memmove(recordBuffer + SZPOSPNT, szBuffReceive, nLenRek);
						break;
					}
				}
			}
			else
			{
				rc = 0;
			}
		}
		// End   Exit Routine E35 check skip record
		if (useRecord == 0)
			continue;

		// E35 End
		gc_memmove(szBuffOut, recordBuffer + SZPOSPNT, nLenRek);		// save previous record for E35
		nOutLen = nLenRek;											// save len


// NORMAL
		if ((nLenRek > 0) && (job->outfil == NULL)){
			if (job->sumFields==2) {
				bIsWrited = 1;
				// s.m. 202012 store first key for buffer
				// memcpy(recordBuffer, szKeyFirst, job->nLenKeys + SZPOSPNT);  //Key
				// s.m. 202012 store first key for buffer
				SumField_SumFieldUpdateRek((unsigned char*)recordBuffer+SZPOSPNT);	    // Update record in  memory
				SumField_ResetTot(job);									                // reset totalizer
				SumField_SumField((unsigned char*)szPrecSumFields+SZPOSPNT);		    // Sum record in  memory
			}
			job_set_area(job, job->outputFile, recordBuffer+nSplitPosPnt, nLenRecOut);	// Len output
			cob_write (job->outputFile->stFileDef, job->outputFile->stFileDef->record, job->outputFile->opt, NULL, 0);
			if (atol((char *)job->outputFile->stFileDef->file_status) != 0) {
			    fprintf(stderr,"*GCSORT*S027*ERROR: Cannot write to file %s - File Status (%c%c)\n",file_getName(job->outputFile),
					job->outputFile->stFileDef->file_status[0],job->outputFile->stFileDef->file_status[1]);
            	retcode_func = -1;
				goto job_save_exit;
			}
			// s.m. 202012
			if (job->sumFields == 2) {
				memcpy(szFirstRek, szPrecSumFields, nLenRek + nSplitPosPnt);
				bIsFirstKeySumField = 1;
			}
			// s.m. 202012

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
		SumField_SumFieldUpdateRek((char*)szFirstRek +SZPOSPNT);	// Update record in  memory
		memcpy(recordBuffer, szFirstRek, nLenPrec+SZPOSPNT);		// Substitute record for write
		// s.m. 202012
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
	free(szBuffOut);
	free(szPrecSumFields);
	free(szSaveSumFields);
	free(recordBufferPrevious);
	free(szFirstRek);
	free(szBuffReceive);
	free(szBuffRekE35);
//	free(pAddress);

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

/*
#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
INLINE int job_set_area(struct job_t* job, struct file_t* file, unsigned char* szBuf, int nLen)
#else
INLINE2 int job_set_area(struct job_t* job, struct file_t* file, unsigned char* szBuf, int nLen)
#endif
*/
int job_set_area(struct job_t* job, struct file_t* file, unsigned char* szBuf, int nLen)
{
// 20180511 s.m. start
    // s.m. 20201226 int nLenRek = job->inputFile->stFileDef->record->size;
	int nLenRek = job->outputFile->stFileDef->record->size;
// 20180511 s.m. end
// set area data
	gc_memcpy(file->stFileDef->record->data, szBuf, nLen);

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
	unsigned char  szKeyPrec[GCSORT_KEY_MAX+SZPOSPNT];
	unsigned char  szKeySave[GCSORT_KEY_MAX+SZPOSPNT];
	unsigned char* bufferwriteglobal; // pointer for write buffered
	unsigned char* pAddress;
	unsigned char* recordBuffer;
	unsigned char* szBuffRek;
	unsigned char* szBuffTmp;
	unsigned char* szPrecSumFields;	// Prec
	unsigned char* szSaveSumFields; // save
	unsigned char* szFirstRek;
	unsigned int   byteRead = 0;
	unsigned int   lpntTemp = 0;
	unsigned int   nLenRekTemp = 0;

//	pAddress = (unsigned char*)malloc(SZPNTDATA + 1);
//	if (pAddress == 0)
//		fprintf(stderr, "*GCSORT*S030C*ERROR: Cannot Allocate pAddress : %s\n", strerror(errno));


    recordBufferLength=MAX_RECSIZE;
	recordBufferLength = recordBufferLength + SZPOSPNT;

//	recordBuffer=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	recordBuffer=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*GCSORT*S030*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));
//	szBuffRek=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	szBuffRek=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRek == 0)
		fprintf(stderr,"*GCSORT*S031*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));
//	szBuffTmp=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	szBuffTmp=(unsigned char *) malloc(recordBufferLength);
	if (szBuffTmp == 0)
		fprintf(stderr,"*GCSORT*S032*ERROR: Cannot Allocate szBuffTmp : %s\n", strerror(errno));
//	szPrecSumFields=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	szPrecSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szPrecSumFields == 0)
		fprintf(stderr,"*GCSORT*S033*ERROR: Cannot Allocate szPrecSumFields : %s\n", strerror(errno));

//	szSaveSumFields=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	szSaveSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szSaveSumFields == 0)
		fprintf(stderr,"*GCSORT*S034*ERROR: Cannot Allocate szSaveSumFields : %s\n", strerror(errno));

//	szFirstRek = (unsigned char*)calloc(recordBufferLength, sizeof(unsigned char));
	szFirstRek = (unsigned char*)malloc(recordBufferLength);
	if (szFirstRek == 0)
		fprintf(stderr, "*GCSORT*S034A*ERROR: Cannot Allocate szFirstRek : %s\n", strerror(errno));

//	bufferwriteglobal=(unsigned char*) calloc(MAX_SIZE_CACHE_WRITE, sizeof(unsigned char));
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
		gc_memcpy((unsigned char*)&lPosPnt,  job->buffertSort+(i)*((int64_t)job->nLenKeys+SIZESRTBUFF)+job->nLenKeys,                   SZPOSPNT);  //lPosPnt
		gc_memcpy((unsigned char*)&nLenRek,  job->buffertSort+(i)*((int64_t)job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SZPOSPNT,          SZLENREC); // nLenRek
		// s.m. 202101
		gc_memcpy((unsigned char*)&pAddress, job->buffertSort+(i)*((int64_t)job->nLenKeys+SIZESRTBUFF)+job->nLenKeys+SZPOSPNT+SZLENREC, SZPNTDATA); // Pointer Data Area
		gc_memcpy((unsigned char*)szBuffRek, (unsigned char*) &lPosPnt, SZPOSPNT); // PosPnt
		gc_memcpy((unsigned char*)szBuffRek+SZPOSPNT,  (unsigned char*) pAddress, nLenRek); // buffer

		byteRead = nLenRek + nSplitPosPnt;
		nNumBytes = nNumBytes + byteRead;
		gc_memcpy(recordBuffer, szBuffRek, byteRead);
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
					write_buffered(desc, (unsigned char*)&nLenRekTemp, SIZEINT, bufferwriteglobal, &position_buf_write);
					if (write_buffered(desc, (unsigned char*)szBuffTmp, nLenRekTemp+nSplitPosPnt, bufferwriteglobal, &position_buf_write)<0) {
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
            write_buffered(desc, (unsigned char*)&nLenRek, SIZEINT, bufferwriteglobal, &position_buf_write);
            // PosPnt for sort record position
            // Insert for every write file temp
            if (write_buffered(desc, (unsigned char*)recordBuffer, nLenRek+nSplitPosPnt, bufferwriteglobal, &position_buf_write)<0) {
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

    if (write_buffered_final(desc, bufferwriteglobal, &position_buf_write)<0) {
            fprintf(stderr,"*GCSORT*S042*ERROR: Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
            retcode_func = -1;
            goto job_save_exit;

    }

	while ((bTempEof == 0) && (descTmp >= 0)){
		if (bSkip == 1)	{
			/*   */
			write_buffered(desc, (unsigned char*) &nLenRekTemp, SIZEINT, bufferwriteglobal, &position_buf_write);
			write_buffered(desc, (unsigned char*) szBuffTmp, nLenRekTemp+SZPOSPNT, bufferwriteglobal, &position_buf_write);
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
		write_buffered(desc, (unsigned char*) &nLenRekTemp, SIZEINT, bufferwriteglobal, &position_buf_write);

		if (write_buffered(desc, (unsigned char*) szBuffTmp, byteReadTemp, bufferwriteglobal, &position_buf_write)<0) {
			fprintf(stderr,"*GCSORT*S043*ERROR: Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			if ((close(desc))<0) {
				fprintf(stderr,"*GCSORT*S044*ERROR: Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			}
			retcode_func = -1;
			goto job_save_exit;
		}

		job->nCountSrt[job->nIndextmp]++;
	}

    if (write_buffered_final(desc, bufferwriteglobal, &position_buf_write)<0) {
        fprintf(stderr,"*GCSORT*S045*ERROR: Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
    }

job_save_exit:

   	free(recordBuffer);
	free(szBuffRek);
	free(szBuffTmp);
	free(szPrecSumFields);
	free(szSaveSumFields);
	free(bufferwriteglobal);
	free(szFirstRek);
	//free(pAddress);



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

static INLINE int job_IdentifyBuf(unsigned char** ptrBuf, int nMaxEle)
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
	unsigned char  szKeyCurr[GCSORT_KEY_MAX+SZPOSPNT];
	unsigned char  szKeyPrec[GCSORT_KEY_MAX+SZPOSPNT];
	unsigned char  szKeySave[GCSORT_KEY_MAX+SZPOSPNT];
	unsigned char  szKeyTemp[GCSORT_KEY_MAX+SZPOSPNT];
	unsigned char* ptrBuf[MAX_HANDLE_TEMPFILE];
	unsigned char* recordBuffer;
	unsigned char* recordBufferPrevious;  // for SUm Fileds NONE
	unsigned char* szBufRekTmpFile[MAX_HANDLE_TEMPFILE];
	unsigned char* szBuffRek;
	unsigned char* szBuffRekOutRec;
	unsigned char* szPrecSumFields;	// Prec
	unsigned char* szSaveSumFields; // save
	unsigned char* szFirstRek;
	unsigned int   nLenRek = 0;
	unsigned int   nLenPrec = 0;
	unsigned int   nLenRecOut = 0;
	unsigned int   nLenSave=0;
	unsigned int   bIsFirstKeySumField = 0;

    if (job->bIsPresentSegmentation == 0)
		return 0;

	recordBufferLength=MAX_RECSIZE;   //(job->outputLength>job->inputLength?job->outputLength:job->inputLength);
	recordBufferLength = recordBufferLength + nSplitPosPnt + NUMCHAREOL;
//	recordBuffer=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	recordBuffer=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*GCSORT*S048*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

//	recordBufferPrevious=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	recordBufferPrevious=(unsigned char *) malloc(recordBufferLength);
	if (recordBuffer == 0)
 		fprintf(stderr,"*GCSORT*S049*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

	for (kj=0; kj < MAX_HANDLE_TEMPFILE;kj++) {
//		szBufRekTmpFile[kj] = (unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
		szBufRekTmpFile[kj] = (unsigned char *) malloc(recordBufferLength);
		if (szBufRekTmpFile[kj] == 0)
			fprintf(stderr,"*GCSORT*S050*ERROR: Cannot Allocate szBufRek1 : %s - id : %d\n", strerror(errno), kj);
	}

//	szBuffRek=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	szBuffRek=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRek == 0)
		fprintf(stderr,"*GCSORT*S051*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));

//	szBuffRekOutRec=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	szBuffRekOutRec=(unsigned char *) malloc(recordBufferLength);
	if (szBuffRekOutRec == 0)
		fprintf(stderr,"*GCSORT*S052*ERROR: Cannot Allocate szBuffRekOutRec : %s\n", strerror(errno));

//	szPrecSumFields=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	szPrecSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szPrecSumFields == 0)
		fprintf(stderr,"*GCSORT*S053*ERROR: Cannot Allocate szPrecSumFields : %s\n", strerror(errno));

//	szSaveSumFields=(unsigned char *) calloc(recordBufferLength, sizeof(unsigned char));
	szSaveSumFields=(unsigned char *) malloc(recordBufferLength);
	if (szSaveSumFields == 0)
		fprintf(stderr,"*GCSORT*S054*ERROR: Cannot Allocate szSaveSumFields : %s\n", strerror(errno));

//	szFirstRek = (unsigned char*)calloc(recordBufferLength, sizeof(unsigned char));
	szFirstRek = (unsigned char*)malloc(recordBufferLength);
	if (szFirstRek == 0)
		fprintf(stderr, "*GCSORT*S054A*ERROR: Cannot Allocate szFirstRek : %s\n", strerror(errno));


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
		memmove(szPrecSumFields, szBufRekTmpFile[nPosPtr], nLenRek+SZPOSPNT);
		nLenPrec = nLenRek;
		memmove(szKeySave,		szKeyPrec, job->nLenKeys+SZPOSPNT);			   //lPosPnt + Key
		memmove(szSaveSumFields, szPrecSumFields, nLenPrec+SZPOSPNT);
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
			memmove(recordBufferPrevious, szBufRekTmpFile[nPosPtr], byteRead);
		}
// SUMFIELD			2 = FIELDS

		if (job->sumFields==2) {
			job_GetKeys(szBufRekTmpFile[nPosPtr]+SZPOSPNT, szKeyTemp);
			memmove(szKeyCurr,    szBufRekTmpFile[nPosPtr], SZPOSPNT);			//lPosPnt
			memmove(szKeyCurr+SZPOSPNT,  szKeyTemp, job->nLenKeys+SZPOSPNT);		//Key
		// s.m. 202012
			if (bIsFirstKeySumField == 0) {			// Save first key for sum field, use this for write
				memcpy(szFirstRek, szBuffRek, nLenRek + nSplitPosPnt);  //PosPnt + First Record
				bIsFirstKeySumField = 1;
			}
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

		// s.m. 202012
		if (bIsFirstKeySumField == 1) {
			bIsFirstKeySumField = 0;
			gc_memcpy(recordBuffer, szFirstRek, nLenRek + nSplitPosPnt);
		}
		//
// OUTREC
		if ((useRecord == 1) && (job->outrec != NULL)) {
			// check overlay
			if (job->outrec->nIsOverlay == 0) {
				memset((unsigned char*)szBuffRekOutRec, 0x20, recordBufferLength);
				nLenRek = outrec_copy(job->outrec, szBuffRekOutRec, szBufRekTmpFile[nPosPtr], job->outputLength, byteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
				memset(szBufRekTmpFile[nPosPtr], 0x20, recordBufferLength); // s.m. 202101
				memcpy(szBufRekTmpFile[nPosPtr], szBuffRekOutRec, nLenRek + nSplitPosPnt);
				byteReadTmpFile[nPosPtr] = nLenRek;
				byteRead = nLenRek;
				nLenRecOut = nLenRek; // for Outrec force length of record
			}
			else
			{		// Overlay
				memset(szBuffRek, 0x20, recordBufferLength);
				memmove(szBuffRek, recordBuffer, byteRead + nSplitPosPnt);	// s.m. 202101 copy record
				nLenRek = outrec_copy_overlay(job->outrec, szBuffRekOutRec, szBufRekTmpFile[nPosPtr], job->outputLength, byteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
				nLenRek++;
				if (nLenRek < job->outputLength)
					nLenRek = job->outputLength;
				memset(szBufRekTmpFile[nPosPtr], 0x20, recordBufferLength); // s.m. 202101
				memcpy(szBufRekTmpFile[nPosPtr], szBuffRekOutRec, nLenRek + nSplitPosPnt);
				byteReadTmpFile[nPosPtr] = nLenRek;
				byteRead = nLenRek;
				nLenRecOut = nLenRek;
			}
		}


// NORMAL
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
				// s.m. 202012
				if (job->sumFields == 2) {
					memcpy(szFirstRek, szPrecSumFields, nLenRek + nSplitPosPnt);
					bIsFirstKeySumField = 1;
				}
				// s.m. 202012
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
		SumField_SumFieldUpdateRek((char*)szFirstRek + SZPOSPNT);				// Update record in  memory
		memcpy(recordBuffer, szFirstRek, nLenPrec + SZPOSPNT);		// Substitute record for write
		//s.m. 202012
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
	free(szFirstRek);
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


int job_SetPosLenKeys(int* arPosLen) {
	int k = 0;
	struct sortField_t* sortField;
	for (k = 0; k < MAXFIELDSORT*2; k++) {
		*(&arPosLen[k]) = 0;
		//*(&arPosLen[k]) = 0;
	}
	k = 0;
	for (sortField = globalJob->sortField; sortField != NULL; sortField = sortField_getNext(sortField)) {
		*(&arPosLen[k]) = sortField->position; //sortField_getPosition(sortField);
		k++;
		*(&arPosLen[k]) = sortField->length;   //sortField_getLength(sortField);
		k++;
	}
	return k/2; // Number of sort field
}

//INLINE2 int job_GetKeys(const void *szBufferIn, void *szKeyOut) {
#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	static INLINE int job_GetKeys(unsigned char* szBufferIn, unsigned char* szKeyOut) {
#else
	static INLINE2 int job_GetKeys(unsigned char* szBufferIn, unsigned char* szKeyOut) {
#endif
	int nSp=0;
	int nPos=0;
	int nLen=0;
	struct sortField_t *sortField;
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
        nPos=sortField->position; //sortField_getPosition(sortField);
        nLen=sortField->length;   //sortField_getLength(sortField);

		gc_memcpy((unsigned char*)szKeyOut + nSp,
			      (unsigned char*)szBufferIn + nPos - 1,
			      nLen);

		/*
        memmove((unsigned char*) szKeyOut+nSp,
                    (unsigned char*) szBufferIn+nPos-1,
                    nLen);
*/
		/*
		switch (sortField->type){  //(sortField_getType(sortField)) {
			case FIELD_TYPE_CHARACTER:
				memmove((unsigned char*) szKeyOut+nSp,
                        (unsigned char*) szBufferIn+nPos-1,
							nLen);
				// position file pointer
				break;
			case FIELD_TYPE_BINARY:
				memmove((unsigned char*) szKeyOut+nSp,
                        (unsigned char*) szBufferIn+nPos-1,
							nLen);
				break;
			case FIELD_TYPE_FIXED:
				memmove((unsigned char*) szKeyOut+nSp,
                        (unsigned char*) szBufferIn+nPos-1,
							nLen);
				break;
			case FIELD_TYPE_FLOAT:
				memmove((unsigned char*) szKeyOut+nSp,
                        (unsigned char*) szBufferIn+nPos-1,
							nLen);
				break;
			case FIELD_TYPE_PACKED:
				memmove((unsigned char*) szKeyOut+nSp,
                        (unsigned char*)szBufferIn+nPos-1,
							nLen);
				break;
			case FIELD_TYPE_ZONED:
			case FIELD_TYPE_NUMERIC_CLO:
			case FIELD_TYPE_NUMERIC_CSL:
			case FIELD_TYPE_NUMERIC_CST:
				memmove((unsigned char*) szKeyOut+nSp,
						(unsigned char*)szBufferIn+nLen-1,
							nPos);
				break;
			default:
				break;
		}
		*/
		nSp = nSp + nLen;
	}
	return 0;
}

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	void job_getTypeFlags (int nTypeField, int* nType, int* nFlags, int nLen ) {
#else
	static INLINE2 void job_getTypeFlags(int nTypeField, int* nType, int* nFlags, int nLen) {
#endif
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
			//	if (sortField_getLength(sortField) > 4)
                if (nLen > 4)
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
           // s.m. 20201015      *nType = COB_TYPE_NUMERIC_DISPLAY;
                *nType = COB_TYPE_NUMERIC;
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
// Date
			case FIELD_TYPE_NUMERIC_Y2T:
				*nType = COB_TYPE_NUMERIC_DISPLAY;
				// s.m. 20210513 *nFlags = COB_FLAG_HAVE_SIGN ;
				break;
			case FIELD_TYPE_NUMERIC_Y2B:
				*nType = COB_TYPE_NUMERIC_BINARY;
				*nFlags = COB_FLAG_BINARY_SWAP;
				break;
			case FIELD_TYPE_NUMERIC_Y2C:
				*nType = COB_TYPE_NUMERIC;
				*nFlags = COB_FLAG_HAVE_SIGN;
				break;
			case FIELD_TYPE_NUMERIC_Y2D:
				*nType = COB_TYPE_NUMERIC_PACKED;
				*nFlags = COB_FLAG_NO_SIGN_NIBBLE;	// new
				break;
			case FIELD_TYPE_NUMERIC_Y2P:
				*nType = COB_TYPE_NUMERIC_PACKED;
				*nFlags = 0;
				break;
			case FIELD_TYPE_NUMERIC_Y2S:
				*nType = COB_TYPE_NUMERIC_DISPLAY;
				*nFlags = 0; // COB_FLAG_HAVE_SIGN;
				break;
			case FIELD_TYPE_NUMERIC_Y2U:
				*nType = COB_TYPE_NUMERIC_PACKED;
				// *nFlags = COB_FLAG_NO_SIGN_NIBBLE; // COB_FLAG_HAVE_SIGN;
				*nFlags = 0;
				break;
			case FIELD_TYPE_NUMERIC_Y2V:
				*nType = COB_TYPE_NUMERIC_PACKED;
				// *nFlags = COB_FLAG_NO_SIGN_NIBBLE; // COB_FLAG_HAVE_SIGN;
				*nFlags = 0;
				break;
			case FIELD_TYPE_NUMERIC_Y2X:
				*nType = COB_TYPE_NUMERIC_PACKED;
				// *nFlags = COB_FLAG_NO_SIGN_NIBBLE; // COB_FLAG_HAVE_SIGN;
				*nFlags = 0;
				break;
			case FIELD_TYPE_NUMERIC_Y2Y:
				*nType = COB_TYPE_NUMERIC_PACKED;
				// *nFlags = COB_FLAG_NO_SIGN_NIBBLE; // COB_FLAG_HAVE_SIGN;
				*nFlags = 0;
				break;
			case FIELD_TYPE_NUMERIC_Y2Z:
				*nType = COB_TYPE_NUMERIC_DISPLAY;
				// *nFlags = COB_FLAG_NO_SIGN_NIBBLE; // COB_FLAG_HAVE_SIGN;
				*nFlags = 0;
				break;

			default:
				fprintf(stdout, "* job_getTypeFlags*  : %d\n", nTypeField);
				exit(GC_RTC_ERROR);
				break;
		}
    return ;
}
#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	int job_compare_key(const void *first, const void *second)
#else
	INLINE2 int job_compare_key(const void* first, const void* second)
#endif
{
    int nType, nLen, nFlags;
	result=0;
	nSp=SZPOSPNT; // first 8 byte for PosPnt
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {

        if (sortField_getType(sortField) == FIELD_TYPE_CHARACTER)
            result=memcmp((unsigned char*) first+nSp, (unsigned char*) second+nSp, sortField_getLength(sortField));
        else {
			nLen = sortField_getLength(sortField);
			job_getTypeFlags (sortField_getType(sortField), &nType, &nFlags, nLen);
			if (IsDateType(sortField->type)) {
				g_fdate1->data = (unsigned char*)first + nSp;
				g_fdate2->data = (unsigned char*)second + nSp;
				job_cob_field_reset(g_fdate1, COB_TYPE_NUMERIC_DISPLAY, nLen, nLen);
				job_cob_field_reset(g_fdate2, COB_TYPE_NUMERIC_DISPLAY, nLen, nLen);
				result = job_CheckTypeDate(sortField->type, (cob_field*)g_fdate1, g_fdate2);
			}
			else 
			{
				g_fd1->data = (unsigned char*)first + nSp;
				g_fd2->data = (unsigned char*)second + nSp;
				job_cob_field_set(g_fd1, nType, nLen, 0, nFlags, nLen);
				job_cob_field_set(g_fd2, nType, nLen, 0, nFlags, nLen);
				result = cob_numeric_cmp(g_fd1, g_fd2);
			}
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
    int nType, nLen, nFlags, nTipo;
	lPosA = 0;
	lPosB = 0;
	result=0;
	nSp=SZPOSPNT; // first 8 byte for PosPnt
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		nTipo = sortField->type;
		nLen = sortField->length;
		//        if (sortField_getType(sortField) == FIELD_TYPE_CHARACTER)
		if (nTipo == FIELD_TYPE_CHARACTER) {
			// s.m. 20210216	result=memcmp( (unsigned char*) first+sortField_getPosition(sortField)-1+nSp, (unsigned char*) second+sortField_getPosition(sortField)-1+nSp, sortField_getLength(sortField));
			result = memcmp((unsigned char*)first + sortField->position - 1 + nSp, (unsigned char*)second + sortField->position - 1 + nSp, sortField->length);
		}
        else
		{
            job_getTypeFlags (sortField_getType(sortField), &nType, &nFlags, nLen);
			if (IsDateType(nType)) {
				g_fdate1->data = (unsigned char*)first + nSp;
				g_fdate2->data = (unsigned char*)second + nSp;
				job_cob_field_reset(g_fdate1, COB_TYPE_NUMERIC_DISPLAY, nLen, nLen);
				job_cob_field_reset(g_fdate2, COB_TYPE_NUMERIC_DISPLAY, nLen, nLen);
				result = job_CheckTypeDate(sortField->type, (cob_field*)g_fdate1, (cob_field*)g_fdate2);
			}
			else
			{
				g_fd1->data = (unsigned char*)first + sortField->position - 1 + nSp;
				g_fd2->data = (unsigned char*)second + sortField->position - 1 + nSp;
				job_cob_field_set(g_fd1, nType, nLen, 0, nFlags, nLen);
				job_cob_field_set(g_fd2, nType, nLen, 0, nFlags, nLen);
				result = cob_numeric_cmp(g_fd1, g_fd2);  //cob_cmp(g_fd1, g_fd2);
			}
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

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
static INLINE  int job_compare_qsort(const void* first, const void* second)
#else
static INLINE2 int job_compare_qsort(const void* first, const void* second)
#endif
{
    //int nTypeGC, nType, nLen, nFlags;
	lPosA = 0;
	lPosB = 0;
	g_nSp=0;
	g_result=0;
	g_idx=0;
    for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
        //g_nLen = sortField_getLength(sortField);
        g_nLen = sortField->length;
        //g_nTypeGC=sortField_getType(sortField);
        g_nTypeGC=sortField->type;
        if (g_nTypeGC == FIELD_TYPE_CHARACTER)
            g_result=memcmp((unsigned char*) first+g_nSp, (unsigned char*) second+g_nSp, g_nLen);
        else
        {
			cob_field_key[g_idx]->data=(unsigned char*) first+g_nSp;
			g_idx++;
			cob_field_key[g_idx]->data=(unsigned char*) second+g_nSp;
			g_idx++;
			// check if datatype is DATE
			if IsDateType(g_nTypeGC)
				g_result = job_CheckTypeDate(g_nTypeGC, (cob_field*)cob_field_key[g_idx - 2], (cob_field*)cob_field_key[g_idx - 1]);
			else
				g_result = cob_numeric_cmp((cob_field*)cob_field_key[g_idx - 2], (cob_field*)cob_field_key[g_idx - 1]);
        }

        if (g_result) {
            // perf. if (sortField_getDirection(sortField)==SORT_DIRECTION_ASCENDING) {
            if (sortField->direction == SORT_DIRECTION_ASCENDING) {
                return  g_result;
            } else {
                return -g_result;
            }
        }
        g_nSp = g_nSp + g_nLen;
    }
// only for SUM FIELDS=NONE
    if (g_result == 0){
        // check value of record position
		gc_memcpy((unsigned char*)&lPosA, (unsigned char*)first+globalJob->nLenKeys,SZPOSPNT);
		gc_memcpy((unsigned char*)&lPosB, (unsigned char*)second+globalJob->nLenKeys,SZPOSPNT);
        if(lPosA < lPosB)
            g_result = -1;
        if(lPosA > lPosB)
            g_result =  1;
        g_first_sort=1;
        // debug             fprintf(stdout,"lPosA = %16I64d - lPosB = %16I64d \n", lPosA, lPosB);
        return g_result;
    }
    g_first_sort=1;

	return 0;
}


int job_CheckTypeDate(int nTypeGC, cob_field* fk1, cob_field* fk2)
{
		int result = 0;
	/*
* Y2T8 = Y4T8(? ) C'ccyymmdd' or Z'ccyymmdd'		05 Y2T8   pic 9(8).
* Y2T4 : C'yyxx' or Z'yyxx'							05 Y2T4   pic 9(4).
* Y2T2 'yy'											05 Y2T2   pic 9(2).
* Y2T2 'yyx'  (? ? ? )								05 Y2T3   pic 9(3).
* 5, Y2T: C'yyddd' or Z'yyddd'						05 Y2T5   pic 9(5).
* 6, Y2T : C'yymmdd' or Z'yymmdd'					05 Y2T6   pic 9(6).
* 7, Y4T : C'ccyyddd' or Z'ccyyddd'					05 Y4T7   pic 9(7).
													05 Y2B    pic 99 comp.
													05 Y2C    pic 99.
													05 Y2D    pic 99 comp - 6.
													05 Y2P    pic 99 comp - 3.
													05 Y2S    pic 99.
* 3, Y2U P'yyddd'									05 Y2U	  pic s9(5) comp - 3.
* 4, Y2V P'yymmdd'									05 Y2V    pic s9(6) comp - 3.
* 3, Y2X P'dddyy'									05 Y2X    pic s9(5) comp - 3.
* 4, Y2Y P'mmddyy'									05 Y2Y    pic  9(6) comp - 3.
	* 2, Y2Z YY										05 Y2Z    pic 99.
	*/
	switch (nTypeGC) {
	case FIELD_TYPE_NUMERIC_Y2B:						 // YY
	case FIELD_TYPE_NUMERIC_Y2C:						 // YY
	case FIELD_TYPE_NUMERIC_Y2D:						 // YY
	case FIELD_TYPE_NUMERIC_Y2P:						 // YY
	case FIELD_TYPE_NUMERIC_Y2S:						 // YY
	case FIELD_TYPE_NUMERIC_Y2Z:						 // YY
		result = job_compare_date_YY((cob_field*)fk1, (cob_field*)fk2);			//OK
		break;
	case FIELD_TYPE_NUMERIC_Y2V:						// YYMMDD
		result = job_compare_date_YYMMDD((cob_field*)fk1, (cob_field*)fk2);		//OK
		break;
	case FIELD_TYPE_NUMERIC_Y2U:
		result = job_compare_date_YYDDD((cob_field*)fk1, (cob_field*)fk2);		// OK
		break;
	case FIELD_TYPE_NUMERIC_Y2T:
		// case FIELD_TYPE_NUMERIC_Y4T:
		result = job_compare_date_Y2T((cob_field*)fk1, (cob_field*)fk2);
		break;
	case FIELD_TYPE_NUMERIC_Y2X:		// dddyy
		result = job_compare_date_Y2X((cob_field*)fk1, (cob_field*)fk2);
		break;
	case FIELD_TYPE_NUMERIC_Y2Y:		// mmddyy
		result = job_compare_date_Y2Y((cob_field*)fk1, (cob_field*)fk2);
		break;
	}
	return result;
}

// Format : 
int job_compare_date_Y2T(cob_field* fk2, cob_field* fk1)
{

	// check limit and Y2PAST elements
	// use two variables for check value
	// Field nn (two digits)  
	// if field < limit inferior ---> date major, add liminf to field or subtract liminf to field

	int ndate1 = cob_get_int(fk1);
	int ndate2 = cob_get_int(fk2);

	int nLenDate = fk1->attr->digits; 
	int ndivisor = 1;
	int ncent = 0;

	int nLimit = globalJob->nY2PastLimInfyy2;
    int nYYVal = globalJob->nY2PastLimInfyy2;

	switch (nLenDate) {
	case 2:			// YY
		return (job_compare_date_YY( fk2, fk1));
		break;
	case 3:			// YYM
		ndivisor = 10; 
		nYYVal = globalJob->nY2PastLimInfyy2;
		break;
	case 4:			// YYMM
		ndivisor = 100;
		nYYVal = globalJob->nY2PastLimInfyy2;
		break;
	case 5:			// YYDDD
		ndivisor = 1000;
		nYYVal = globalJob->nY2PastLimInfyy2;
		break;
	case 6:			// YYMMDD
		ndivisor = 10000;
		ncent = 1;
		nLimit = globalJob->nY2PastLimInfyy2;
		nYYVal = globalJob->nY2PastLimInfyy2;
		break;
	case 7:			// YYYMMDD
		ndivisor = 10000;
		ncent = 1;
		nLimit = globalJob->nY2PastLimInfyy2;
		nYYVal = globalJob->nY2PastLimInfyy2;
		break;
	case 8:			// YYYYMMDD
		ndivisor = 10000;
		ncent = 2;
		nLimit = globalJob->nY2PastLimInf;
		nYYVal = globalJob->nY2PastLimInfyy2;
		break;
	}
	
	int nyear1 = ndate1 / ndivisor;
	int nyear2 = ndate2 / ndivisor;

	int nddd1 = ndate1 - (nyear1 * ndivisor);
	int nddd2 = ndate2 - (nyear2 * ndivisor);

	if (nyear1  < nLimit)
		nyear1 += nYYVal;
	else
		nyear1 -= nYYVal;
	//
	if (nyear2  < nLimit)
		nyear2 += nYYVal;
	else
		nyear2 -= nYYVal;

	nyear1 = (nyear1 * ndivisor) + nddd1;
	nyear2 = (nyear2 * ndivisor) + nddd2;

	if (nyear2 < nyear1)
		return -1;
	else
		if (nyear2 > nyear1)
			return 1;
	return 0;
}

// Format : YYDDD
int job_compare_date_YYDDD(cob_field* fk2, cob_field* fk1)
{
	int result = 0;
	// check limit and Y2PAST elements
	// use two variables for check value
	// Field nn (two digits)  
	// if field < limit inferior ---> date major, add liminf to field or subtract liminf to field

	int ndate1 = cob_get_int(fk1);
	int ndate2 = cob_get_int(fk2);
	int nyear1 = ndate1 / 1000;
	int nyear2 = ndate2 / 1000;

	int nddd1 = ndate1 - (nyear1 * 1000);
	int nddd2 = ndate2 - (nyear2 * 1000);

	if (nyear1 < globalJob->nY2PastLimInfyy2)
		nyear1 += globalJob->nY2PastLimInfyy2;
	else
		nyear1 -= globalJob->nY2PastLimInfyy2;
	//
	if (nyear2 < globalJob->nY2PastLimInfyy2)
		nyear2 += globalJob->nY2PastLimInfyy2;
	else
		nyear2 -= globalJob->nY2PastLimInfyy2;

	nyear1 = (nyear1 * 1000) + nddd1;
	nyear2 = (nyear2 * 1000) + nddd2;

	if (nyear2 < nyear1)
		return -1;
	else
		if (nyear2 > nyear1)
			return 1;
	return 0;
}
// Format : YYMMDD
int job_compare_date_YYMMDD(cob_field* fk2, cob_field* fk1)
{
	int result = 0;
	// check limit and Y2PAST elements
	// use two variables for check value
	// Field nn (two digits)  
	// if field < limit inferior ---> date major, add liminf to field or subtract liminf to field

	int ndate1 = cob_get_int(fk1);
	int ndate2 = cob_get_int(fk2);
	int nyear1 = ndate1 / 10000;
	int nyear2 = ndate2 / 10000;

	int nmmdd1 = ndate1 - (nyear1 * 10000);
	int nmmdd2 = ndate2 - (nyear2 * 10000);

	if (nyear1 < globalJob->nY2PastLimInfyy2)
		nyear1 += globalJob->nY2PastLimInfyy2;
	else
		nyear1 -= globalJob->nY2PastLimInfyy2;
	//
	if (nyear2 < globalJob->nY2PastLimInfyy2)
		nyear2 += globalJob->nY2PastLimInfyy2;
	else
		nyear2 -= globalJob->nY2PastLimInfyy2;

	nyear1 = (nyear1 * 10000) + nmmdd1;
	nyear2 = (nyear2 * 10000) + nmmdd2;

	if (nyear2 < nyear1)
		return -1;
	else
		if (nyear2 > nyear1)
			return 1;
	return 0;
}
// Format : YY
int job_compare_date_YY(cob_field* fk2, cob_field* fk1)
{
	int result = 0;
	// check limit and Y2PAST elements
	// use two variables for check value
	// Field nn (two digits)  
	// if field < limit inferior ---> date major, add liminf to field or subtract liminf to field

	int ndate1 = cob_get_int(fk1);
	int ndate2 = cob_get_int(fk2);

	if (ndate1 < globalJob->nY2PastLimInfyy2)
		ndate1 += globalJob->nY2PastLimInfyy2;
	else
		ndate1 -= globalJob->nY2PastLimInfyy2;
	//
	if (ndate2 < globalJob->nY2PastLimInfyy2)
		ndate2 += globalJob->nY2PastLimInfyy2;
	else
		ndate2 -= globalJob->nY2PastLimInfyy2;

	if (ndate2 < ndate1)
		return -1;
	else
		if (ndate2 > ndate1)
			return 1;
	return 0;
}
// Format :  P'dddyy'
int job_compare_date_Y2X(cob_field* fk2, cob_field* fk1)
{
	int result = 0;
	// check limit and Y2PAST elements
	// use two variables for check value
	// Field nn (two digits)  
	// if field < limit inferior ---> date major, add liminf to field or subtract liminf to field

	int ndate1 = cob_get_int(fk1);
	int ndate2 = cob_get_int(fk2);
	int ndays1 = ndate1 / 100;
	int ndays2 = ndate2 / 100;
	int nyear1 = ndate1 - ndays1 * 100;
	int nyear2 = ndate2 - ndays2 * 100;



	if (nyear1 < globalJob->nY2PastLimInfyy2)
		nyear1 += globalJob->nY2PastLimInfyy2;
	else
		nyear1 -= globalJob->nY2PastLimInfyy2;
//
	if (nyear2 < globalJob->nY2PastLimInfyy2)
		nyear2 += globalJob->nY2PastLimInfyy2;
	else
		nyear2 -= globalJob->nY2PastLimInfyy2;

	int nfk1 = (nyear1 * 1000) + ndays1;
	int nfk2 = (nyear2 * 1000) + ndays2;

	if (nfk2 < nfk1)
		return -1;
	else
		if (nfk2 > nfk1)
			return 1;
	return 0;
}
// Format : P'mmddyy'	
int job_compare_date_Y2Y(cob_field* fk2, cob_field* fk1)
{
	// Format : P'mmddyy'	
	int result = 0;
	// check limit and Y2PAST elements
	// use two variables for check value
	// Field nn (two digits)  
	// if field < limit inferior ---> date major, add liminf to field or subtract liminf to field

	int ndate1 = cob_get_int(fk1);
	int ndate2 = cob_get_int(fk2);
	int nmmdd1 = ndate1 / 100;
	int nmmdd2 = ndate2 / 100;
	int nyear1 = ndate1 - nmmdd1 * 100;
	int nyear2 = ndate2 - nmmdd2 * 100;

	if (nyear1 < globalJob->nY2PastLimInfyy2)
		nyear1 += globalJob->nY2PastLimInfyy2;
	else
		nyear1 -= globalJob->nY2PastLimInfyy2;
	//
	if (nyear2 < globalJob->nY2PastLimInfyy2)
		nyear2 += globalJob->nY2PastLimInfyy2;
	else
		nyear2 -= globalJob->nY2PastLimInfyy2;

	int nfk1 = nyear1 * 10000 + nmmdd1;
	int nfk2 = nyear2 * 10000 + nmmdd2;

	if (nfk2 < nfk1)
		return -1;
	else
		if (nfk2 > nfk1)
			return 1;
	return 0;
}

void sort_temp_name(const char * ext)
{
// #ifdef	_WIN32
#if defined(_MSC_VER)  ||  defined(__MINGW32__) || defined(__MINGW64__)
	// s.m. 202101 if (globalJob->strPathTempFile == NULL)
	if (strlen(globalJob->strPathTempFile) == 0) {
		GetTempPath(FILENAME_MAX, cob_tmp_temp);
		if (strlen(cob_tmp_temp) == 0) {
			cob_tmp_temp[0] = '.';
			cob_tmp_temp[1] = '\\';
			cob_tmp_temp[2]= 0x00;
		}
	}
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
	char*			cob_tmpdir=NULL;
	char*			p=NULL;
	pid_t			cob_process_id = 0;
	int                  cob_iteration;
	cob_process_id = getpid ();
	cob_iteration = globalJob->nIndextmp;
    memset(cob_tmp_temp, 0x00, sizeof(cob_tmp_temp));
	//-->>printf("globalJob->strPathTempFile %s \n", globalJob->strPathTempFile);

//linux 	if (globalJob->strPathTempFile == NULL){
	if (strlen(globalJob->strPathTempFile) == 0){
		if ((p = getenv ("TMPDIR")) != NULL) {
			cob_tmpdir = p;
		} else if ((p = getenv ("TMP")) != NULL) {
			cob_tmpdir = p;
		}
		if (p == NULL)
		//	sprintf(cob_tmp_temp, "./");
			sprintf(cob_tmp_temp, "./Srt%d_%d%s", (int)cob_process_id,
				(int)cob_iteration, ext);
		else
		sprintf(cob_tmp_temp, "%s/Srt%d_%d%s", cob_tmpdir, (int)cob_process_id,
			(int)cob_iteration, ext);

	}
	else
		sprintf(cob_tmp_temp, "%s/Srt%d_%d%s", globalJob->strPathTempFile, (int)cob_process_id, (int)cob_iteration, ext);

	//-->>	printf(" Temporary File \n%s\n", cob_tmp_temp );

	return;
	//return buff;
#endif
	printf("cob_tmp_temp : \n%s\n", cob_tmp_temp);
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
    unsigned int	recordBufferLength;
    int bFirstRound=0;
    int bIsFirstTime = 1;
    int bIsWrited = 0;
    int byteReadFile[MAX_FILES_INPUT];
    int k;
    int kj;
    int nIdx1; //, bIsEOF;
    int nIdxFileIn = 0;
    int nLastRead=0;
    unsigned int nLenInRec = 0;
    int nMaxEle;
    int nMaxFiles = MAX_FILES_INPUT;		// size of elements
    int nNumBytes = 0;
    int nPosPtr, nIsEOF;
    int nPosition = 0;
    int nSplitPosPnt = SZPOSPNT;		// for pospnt
    unsigned int nbyteRead;
    int previousRecord=-1;
    int retcode_func=0;
    int useRecord;
    int64_t			lPosPnt = 0;
    struct file_t *file;
    struct file_t*  Arrayfile_s[MAX_FILES_INPUT];
    unsigned char	szBufKey[MAX_FILES_INPUT][GCSORT_KEY_MAX+SZPOSPNT];	// key
    unsigned char	szBufRek[MAX_FILES_INPUT][GCSORT_MAX_BUFF_REK];	// key
    unsigned char	szKeyCurr[GCSORT_KEY_MAX+SZPOSPNT];
    unsigned char	szKeyPrec[GCSORT_KEY_MAX+SZPOSPNT];
    unsigned char	szKeySave[GCSORT_KEY_MAX+SZPOSPNT];
    unsigned char	szKeyTemp[GCSORT_KEY_MAX+SZPOSPNT];
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
		memset(szBufKey[k], 0x00, GCSORT_KEY_MAX);
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
	if (job->outfil != NULL) {
		if (outfil_open_files(job) < 0) {
			retcode_func = -1;
			goto job_merge_files_exit;
		}
	}
	// If Outfile is not null and OutFil not present or OutFil present without FNAME
	if ((job->outputFile != NULL) && (job->nOutFileSameOutFile == 0)) { // new
		cob_open(job->outputFile->stFileDef,  COB_OPEN_OUTPUT, 0, NULL);
		if (atol((char *)job->outputFile->stFileDef->file_status) != 0) {
			fprintf(stderr,"*GCSORT*S065*ERROR: Cannot open file %s - File Status (%c%c)\n",file_getName(job->outputFile),
				job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
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
		gc_memcpy(recordBuffer, szBufRek[nPosPtr], byteReadFile[nPosPtr]+nSplitPosPnt);
		nLastRead = nPosPtr;
		nbyteRead = byteReadFile[nPosPtr];
		job->LenCurrRek = byteReadFile[nPosPtr];
		nLenRek = nbyteRead;
		job->recordNumberTotal++;
// new version for SUM FIELDS
		useRecord=1;
// new new new  INCLUDE - OMIT
		//if (useRecord==1 && job->includeCondField!=NULL && condField_test(job->includeCondField,(unsigned char*) recordBuffer+nSplitPosPnt, job)!=0)
		if (useRecord==1 && job->includeCondField!=NULL && condField_test(job->includeCondField,(unsigned char*) recordBuffer+nSplitPosPnt, job)==FALSE)
			useRecord=0;
		// s.m. 20210513 verify if (useRecord==1 && job->omitCondField!=NULL && condField_test(job->omitCondField,(unsigned char*) recordBuffer+nSplitPosPnt, job)==1)
		// if (useRecord==1 && job->omitCondField!=NULL && condField_test(job->omitCondField,(unsigned char*) recordBuffer+nSplitPosPnt, job)==0)
		if (useRecord==1 && job->omitCondField!=NULL && condField_test(job->omitCondField,(unsigned char*) recordBuffer+nSplitPosPnt, job)==TRUE)
			useRecord=0;
// INREC
		if (useRecord == 1) {
			if (job->inrec!=NULL) {
				// check overlay
				if (job->inrec->nIsOverlay == 0) {
					memset(szBuffRek, 0x20, recordBufferLength);
					nLenInRec = inrec_copy(job->inrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
					if (recordBufferLength < nLenInRec)
						recordBuffer= (unsigned char*) realloc(recordBuffer,nLenInRec+1);
					memcpy(recordBuffer + nSplitPosPnt, szBuffRek + nSplitPosPnt, nLenInRec);
					job->LenCurrRek = nLenInRec;
					nLenRek = nLenInRec;
				}
				else
				{		// Overlay
					memset(szBuffRek, 0x20, recordBufferLength);
					// memmove(recordBuffer, szBuffRek, file_getMaxLength(file));	// copy input record
					memmove(szBuffRek, recordBuffer, nLenRek + nSplitPosPnt);	// s.m. 202101 copy input record
					nLenInRec = inrec_copy_overlay(job->inrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
					nLenInRec++;
					if (nLenInRec < nLenRek)
						nLenInRec = nLenRek;
					if (recordBufferLength < nLenInRec)
						recordBuffer = (unsigned char*)realloc(recordBuffer, nLenInRec + 1);
					memcpy(recordBuffer + nSplitPosPnt, szBuffRek + nSplitPosPnt, nLenInRec);
					job->LenCurrRek = nLenInRec;
					nLenRek = nLenInRec;

				}
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
			if (job->outrec != NULL) {
				// check overlay
				if (job->outrec->nIsOverlay == 0) {
					memset(szBuffRek, 0x20, recordBufferLength);
					nbyteRead = outrec_copy(job->outrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
					memset(recordBuffer, 0x20, recordBufferLength); // s.m. 202101
					memcpy(recordBuffer, szBuffRek, nbyteRead + nSplitPosPnt);
					job->LenCurrRek = nbyteRead;
					nLenRek = nbyteRead;
				}
				else
				{		// Overlay
					memset(szBuffRek, 0x20, recordBufferLength);
					memmove(szBuffRek, recordBuffer, nLenRek + nSplitPosPnt);	// s.m. 202101 copy input record
					nbyteRead = outrec_copy_overlay(job->outrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
					nbyteRead++;
					if (nbyteRead < nLenRek)
						nbyteRead = nLenRek;
					if (recordBufferLength < nbyteRead)
						recordBuffer = (unsigned char*)realloc(recordBuffer, nLenInRec + 1);
					memset(recordBuffer, 0x20, recordBufferLength); // s.m. 202101
					memcpy(recordBuffer + nSplitPosPnt, szBuffRek + nSplitPosPnt, nbyteRead);
					job->LenCurrRek = nbyteRead;
					nLenRek = nbyteRead;
				}
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
   //  unsigned int lenBE = 0;
	//int bTempEof=0;
	// int nLenRek=0;
	// int nbyteRead=0;
	// nLenRek = file_getMaxLength(file);

// LIBCOB for all files
	cob_read_next(file->stFileDef,  NULL, COB_READ_NEXT);
	if (atol((char *)file->stFileDef->file_status) != 0) {	// Check
		if (atol((char *)file->stFileDef->file_status) == 10) {	// EOF
			// bTempEof = 1;
			// nLenRek = 0;
			*nLR = 0;
			//return bTempEof;
			return 1;
		}
		if (atol((char *)file->stFileDef->file_status) > 10) {
			fprintf(stderr,"*GCSORT*S069*ERROR: Cannot read file %s - File Status (%c%c) \n",file_getName(file),
					file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
				exit(GC_RTC_ERROR);
		}
		else
		{
			fprintf(stderr,"*GCSORT*W967a* WARNING : Warning reading file %s - File Status (%c%c) \n",file_getName(file),
					file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
			g_retWarn=4;
		}
	}
	// nLenRek = file->stFileDef->record->size;
    gc_memcpy(szBuffRek+SZPOSPNT, file->stFileDef->record->data, file->stFileDef->record->size);

	// *nLR = nLenRek;
	*nLR = file->stFileDef->record->size;
	//return bTempEof;
	return 0;
}

cob_field* job_cob_field_create ( void )
{
	cob_field       *field_ret;
	cob_field_attr	*attrArea;
	attrArea = (cob_field_attr*) malloc(sizeof(cob_field_attr));
	field_ret = (cob_field*)malloc(sizeof(cob_field));
	field_ret->attr = attrArea;
	field_ret->data = NULL;
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
// if parameter is -1 value not changed
void job_cob_field_reset(cob_field* field_ret, int type, int nsize, int digits)
{
	cob_field_attr* attrArea;
	attrArea = (cob_field_attr*)field_ret->attr;
	util_resetAttrib(attrArea, type,  digits); // Only reset flags
	if (nsize >0 )
		field_ret->size = nsize;		// reset len for date
	return;
}
void job_cob_field_destroy ( cob_field* field_ret)
{
	if (field_ret!=NULL) {
		if (field_ret->attr!=NULL)
				free((void*)field_ret->attr);
		if (field_ret->data != NULL)
			free((void*)field_ret->data);
		free(field_ret);
		field_ret = NULL;
	}
}
void job_print_error_file(cob_file* cobF, int nLenOut) {
	fprintf(stderr,"*GCSORT* record write          : %d \n", nLenOut);
	fprintf(stderr,"*GCSORT* record defition min   : %zu \n", cobF->record_min);
	fprintf(stderr,"*GCSORT* record defition max   : %zu \n", cobF->record_max);
	return;
}
