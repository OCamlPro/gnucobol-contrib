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
#include "sortfield.h"
#include "sumfield.h"
#include "outfil.h"
#include "exitroutines.h"
#include "copyfile.h"
#include "gcshare.h"


int job_copy (struct job_t* job) 
{
	int nContinueSrtTmp=0;
	int nRC=0;

	do {
        if (job->nStatistics == 2)
                util_print_time_elap("Before  job_copyFile     ");
		nContinueSrtTmp = 0;
		nRC = job_copyFile(job);
		if (job->nStatistics == 2) 
				util_print_time_elap("After   job_copyFile     ");
		if (nRC == -2)
			nContinueSrtTmp = 1;
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


  

int job_copyFile(struct job_t *job) 
{
/* -------------------- */
	int	bSkip = 0;
	int	nSplitPosPnt = 0;
	int	retcode_func = 0;
	int desc=-1;
	int nNumBytes = 0;
	unsigned int recordBufferLength;
	int useRecord;
	unsigned char* recordBuffer;			
	unsigned char* szBuffRek;				
	unsigned char* szBuffOut;				
	unsigned char* szBuffRekE35;			
	unsigned char* szFirstRek;				
	unsigned char* szBuffReceive;			
	unsigned int   byteRead = 0;			
	unsigned int   nLenRecOut=0;
	unsigned int   nLenRek = 0;
	unsigned int   nbyteOvl = 0;
	/*
	 ======================================================================================= 
	 Record buffered 
	  for E35
    */
	int nFS = 0;
	int nLastRecord = 0;  /* 0 no, 1 yes is last record input           */
	int nInsE35 = 0;      /* 0 no record from E35, 1 record from E35    */
	int nState = 0;
	int nPosArray = 0;	  /* 1 = Position 1(szVectorRead1)              */
						  /* 2 = Position 2(szVectorRead2)              */
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

	int bEOF, nEOFFileIn;
	int bIsFirstTime=1;
    int bIsFirstLoop=0;    
	int nIdxFileIn = 0;
	unsigned int nbyteRead;
	int nk=0;
	int64_t lPosSeqLS = 0;							
	int64_t lPosBuf=0;
	long int nMemAllocate = 0;
	long nRecCount = 0;
	struct file_t* file;
	unsigned int   nPosCurrentSeek = 0;

	unsigned char* pBufRek;
	unsigned char* pBufData;

	unsigned char* szVectorRead1;		/* record input file    */
	unsigned char* szVectorRead2;		/* record input file    */
    
 	recordBuffer = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
 	if (recordBuffer == 0)
 		fprintf(stdout,"*GCSORT*S720*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

	szBuffRek = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
 	if (szBuffRek == 0)
 		fprintf(stdout,"*GCSORT*S723*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));
	szBuffReceive = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	if (szBuffReceive == 0)
		fprintf(stdout,"*GCSORT*S724*ERROR: Cannot Allocate szBuffReceive : %s\n", strerror(errno));
	recordBufferLength=MAX_RECSIZE;
	recordBufferLength = recordBufferLength;

	szBuffOut=(unsigned char *) malloc(recordBufferLength);
	if (szBuffOut == 0)
		fprintf(stdout,"*GCSORT*S623*ERROR: Cannot Allocate szBuffOut : %s\n", strerror(errno));
	memset(szBuffOut, 0x00, recordBufferLength);

	szFirstRek = (unsigned char*)malloc(recordBufferLength);
	if (szFirstRek == 0)
		fprintf(stdout,"*GCSORT*S625A*ERROR: Cannot Allocate szFirstRek : %s\n", strerror(errno));

	szBuffRekE35 = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	if (szBuffRekE35 == 0)
		fprintf(stdout,"*GCSORT*S625C*ERROR: Cannot Allocate szBuffRekE35 : %s\n", strerror(errno));

	szVectorRead1 = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	if (szVectorRead1 == 0)
		fprintf(stdout,"*GCSORT*S725*ERROR: Cannot Allocate szVectorRead1 : %s\n", strerror(errno));
	memset(szVectorRead1, 0x00, GCSORT_MAX_BUFF_REK);

	szVectorRead2 = (unsigned char*)calloc((size_t)GCSORT_MAX_BUFF_REK, sizeof(unsigned char));
	if (szVectorRead2 == 0)
		fprintf(stdout,"*GCSORT*S726*ERROR: Cannot Allocate szVectorRead2 : %s\n", strerror(errno));
	memset(szVectorRead2, 0x00, GCSORT_MAX_BUFF_REK);


	if (job->bIsPresentSegmentation == 0) {
		job->recordNumber=0;
		job->recordNumberAllocated=GCSORT_ALLOCATE;
		job->recordData=(unsigned char *)calloc((size_t)job->ulMemSizeAlloc, sizeof(unsigned char));
		job->buffertSort=(unsigned char *)calloc((size_t)job->ulMemSizeAllocSort, sizeof(unsigned char));
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
		job->nLastPosKey = NUMCHAREOL;	/* problem into memchr */
	nEOFFileIn = 0;
    
	if (job->outfil != NULL) {
		if (outfil_open_files(job) < 0) {
			retcode_func = -1;
			goto job_save_exit;
		}
	}
	/* Outfil == NULL, standard output file */
	if ((job->outputFile != NULL) && (job->nOutFileSameOutFile == 0)) {
		cob_open(job->outputFile->stFileDef,  COB_OPEN_OUTPUT, 0, NULL);
		if (atol((char*)job->outputFile->stFileDef->file_status) != 0) {
			fprintf(stdout,"*GCSORT*S626*ERROR: Cannot open file %s - File Status (%c%c)\n", file_getName(job->outputFile),
				job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
			retcode_func = -1;
			goto job_save_exit;
		}
		if (job->outputFile->stFileDef->variable_record)
			nIsFileVariable = 1; /* File is Variable Length */
	}    
    
	for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
		nIdxFileIn++;
		if (job->nCurrFileInput > nIdxFileIn)	/* bypass previous file readed  */
			continue;

		if ((job->bIsPresentSegmentation == 0) || (nEOFFileIn == 1))
		{
			struct stat filestatus;
		    stat( file_getName(file), &filestatus );
			job->inputFile->nFileMaxSize = filestatus.st_size;
			/* check if filename is a environment variable */
			if (job->inputFile->nFileMaxSize == 0)
				job->inputFile->nFileMaxSize=utl_GetFileSizeEnvName(file);
			cob_open(file->stFileDef,  COB_OPEN_INPUT, 0, NULL);
 			if (atol((char*)file->stFileDef->file_status) != 0) {
				fprintf(stdout,"*GCSORT*S617*ERROR: Cannot open file %s - File Status (%c%c) \n",file_getName(file),
					file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
				return -1;
			}
			nEOFFileIn=0;
			if (file->stFileDef->variable_record)
				nIsFileVariable = 1; /* File is Variable Length */
		}
		bEOF = 0;
		nLenRek = file_getRecordLength(file);
		nbyteRead=0;
		pBufRek=job->buffertSort;
        pBufData = job->recordData;
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

		/*
		 ======================================================================================= 
		 Record buffered 
		  for E15
        */
		int nFS = 0;
		int nLastRecord = 0;  /* 0 no, 1 yes is last record input           */
		int nInsE15 = 0;      /* 0 no record from E15, 1 record from E15    */
		int nState = 0;
		int nPosArray = 0;	  /* 1 = Position 1(szVectorRead1)              */
		                      /* 2 = Position 2(szVectorRead2)              */
		int nLenVR1 = 0;
		int nLenVR2 = 0;
		int nFSRead = 0;
		int nNewLen = 0;
		/* ======================================================================================= */
		while (bEOF == 0)
		{
 			if (job->nExitRoutine == 0) {					/* 0=normal , 1=E15, 2=E35 , 3=E15+E35 only with 1 call read for E15  */
				/* Read normal without exit routines */
				cob_read_next(file->stFileDef, NULL, COB_READ_NEXT);
				nFSRead = job_checkFS(file->stFileDef);
				if (nFSRead != 0) {
					if (nFSRead == 1) {
						bEOF = 1;
						nbyteRead = 0;
						continue;
					}
					if (nFSRead == -1)
						return -1; /*   exit(GC_RTC_ERROR); */
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
			gc_memcpy(szBuffRek, file->stFileDef->record->data, file->stFileDef->record->size);

			nRecCount++;
			job->recordNumberTotal++;
			job->LenCurrRek = nLenRek;
/* check SKIPREC */
			if (job->nSkipRec > 0)
                if (nRecCount <= job->nSkipRec)
					continue;

			useRecord=1;

			/* Start Exit Routine E15
			Return Code	Meaning
				0	No action required.
				4	Delete the current record.For E15, the record is not sorted.For E35, the record is not written to the output data set.
				8	Do not call this exit again; exit processing is no longer required.
				12	Insert the current record.For E15, the record is inserted for sorting.For E35, the record is written to the output data set.
				16	Terminate sort operation.The job step is terminated with the condition code set to 16.
				20	Alter the current record.For E15, the altered record is passed to the sort.For E35, the altered record is written to the output data set.
			*/
			if ((job->nExitRoutine == 1) || (job->nExitRoutine == 3)) {		/* Call E15			*/
				if (rc != 12 ) {				/* is rc = 12 last call for insert record */
					E15ResetParams(&nrekE15, &nrekFlagE15, nLastRecord);
					if (nrekE15 != 8) {
						rc = E15Run(0, job->E15Routine, nrekFlagE15, nLenRek, szBuffRek, szBuffReceive, &nNewLen, nIsFileVariable);
						switch (rc) {
						case 0:			/* Nothing */
							break;
						case 4:			/* Skip record */
							useRecord = 0;
							break;
						case 8:			/* No call again E15 */
							nrekE15 = 8;
							break;
						case 12:		/* Insert new Record into buffer before record readed */
							memmove(szBuffRek, szBuffReceive, nLenRek);
							nState = nState + 5;   /* Set nState to +5 value to skip next read and move saved buffer */
							break;
						case 16:		/* Abend */
							utl_abend_terminate(EXITROUTINE, 16, ABEND_EXEC);
							break;
						case 20:		/* Use record received from E15 */
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
			/* End   Exit Routine E15 check skip record */
			if (useRecord == 0)
				continue;

			if (includecondfield == 1)
				if  (condField_test(job->includeCondField,(unsigned char*) szBuffRek, job)== FALSE) {
					useRecord=0;	/* if condition for include is false skip record  */
			}
			if (nomitcondfield == 1) {
				if (condField_test(job->omitCondField,(unsigned char*) szBuffRek, job)==TRUE) {	
					useRecord = 0;	/* if condition for omit is true skip record */
				}
			}
			if (useRecord==0)
				continue;

            /* check STOPAFT */
			if (job->nStopAft > 0)
                if (job->recordNumber >= job->nStopAft) {
					nbyteRead=0;
					break;
			}
/* INREC
 If INREC is present made a new area record.
 Only in this point
 Before all command
*/
			if (ninrec == 1) {
				if (job->inrec->nIsOverlay == 0) {
					memset(recordBuffer, 0x20, GCSORT_MAX_BUFF_REK);
					nbyteRead = inrec_copy(job->inrec, recordBuffer, szBuffRek, job->outputLength, file_getMaxLength(file), file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, 0);
					memmove(szBuffRek, recordBuffer, nbyteRead);
					nLenRek = nbyteRead;
				}
				else
				{	/* Overlay */
					memset(recordBuffer, 0x20, GCSORT_MAX_BUFF_REK);
					memmove(recordBuffer, szBuffRek, file_getMaxLength(file));	/* copy input record    */
					nbyteRead = inrec_copy_overlay(job->inrec, recordBuffer, szBuffRek, job->outputLength, file_getMaxLength(file), file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, 0);
					nbyteRead++;
					/* copy all data record */
					if (nbyteRead < job->inputLength)
						nbyteRead = job->inputLength;
					memmove(szBuffRek, recordBuffer, nbyteRead);
					nLenRek = nbyteRead;
				}
			}
			job->LenCurrRek = nLenRek;
            job->recordNumber++;
/* End of input read */

/* Start output */
		/* E35 End  */
		gc_memmove(szBuffOut, szBuffRek, nLenRek );		/* save previous record for E35    */
		nOutLen = nLenRek;								/* save len                        */

		byteRead = nLenRek + nSplitPosPnt;
		nNumBytes = nNumBytes + byteRead;
		gc_memcpy(recordBuffer, szBuffRek, byteRead);
		nLenRecOut = job->outputLength;

		if (job->outrec != NULL) {
			/* check overlay    */
			if (job->outrec->nIsOverlay == 0) {
				memset(szBuffRek, 0x20, recordBufferLength);
				nLenRek = outrec_copy(job->outrec, szBuffRek, recordBuffer, job->outputLength, byteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
				memset(recordBuffer, 0x20, recordBufferLength); /* s.m. 202101  */
				gc_memcpy(recordBuffer, szBuffRek, nLenRek + nSplitPosPnt);
				nLenRecOut = nLenRek;
			}
			else
			{		/* Overlay  */
				memset(szBuffRek, 0x20, recordBufferLength);
				gc_memcpy((unsigned char*)szBuffRek, recordBuffer, nLenRek + nSplitPosPnt);	/* s.m. 202101 copy record  */
				nbyteOvl = outrec_copy_overlay(job->outrec, szBuffRek, recordBuffer, job->outputLength, byteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
				nbyteOvl++;
				if (nbyteOvl < nLenRek)
					nbyteOvl = nLenRek;
				if (recordBufferLength < nbyteOvl)
					recordBuffer = (unsigned char*)realloc(recordBuffer, nbyteOvl + 1);
				memset(recordBuffer, 0x20, recordBufferLength); /* s.m. 202101  */
				gc_memcpy(recordBuffer + nSplitPosPnt, szBuffRek + nSplitPosPnt, nbyteOvl);
				nLenRecOut = nbyteOvl;
			}
		}
        /* E35 Start after OUTREC */
		/* E35 Start
		Return Code	Meaning
			0	No action required.
			4	Delete the current record. For E35, the record is not written to the output data set.
			8	Do not call this exit again; exit processing is no longer required.
			12	Insert the current record. For E35, the record is written to the output data set.
			16	Terminate sort operation.The job step is terminated with the condition code set to 16.
			20	Alter the current record. For E35, the altered record is written to the output data set.
		*/
		if ((job->nExitRoutine == 2) || (job->nExitRoutine == 3)) {		/* Call E35		*/
			gc_memmove(szBuffRekE35, recordBuffer, nLenRek);
			if (rc != 12) {					/* is rc = 12 last call for insert record */
				E35ResetParams(&nrekE35, &nrekFlagE35, nLastRecord);
				if (nrekE35 != 8) {
					rc = E35Run(0, job->E35Routine, nrekFlagE35, nLenRek, szBuffRekE35, szBuffReceive, szBuffOut, &nNewLen, &nOutLen, nIsFileVariable);
					switch (rc) {
					case 0:			/* Nothing */
						break;
					case 4:			/* Skip record */
						useRecord = 0;
						break;
					case 8:			/* No call again E35 */
						nrekE35 = 8;
						break;
					case 12:		/* Insert new Record into buffer before record readed */
						memmove(recordBuffer, szBuffReceive, nLenRek);
						/* Check - Is ok for E15 , verify for E35 */
						nState = nState + 5;   /* Set nState to +5 value to skip next read and move saved buffer */
						break;
					case 16:		/* Abend  */
						utl_abend_terminate(EXITROUTINE, 16, ABEND_EXEC);
						break;
					case 20:		/* Use record received from E35 */
						memmove(recordBuffer, szBuffReceive, nLenRek);
						break;
					}
				}
			}
			else
			{
				rc = 0;
			}
		}
		/* End   Exit Routine E35 check skip record */
		if (useRecord == 0)
			continue;
/* E35 End */
		if ((nLenRek > 0) && (job->outfil == NULL)){
			job_set_area(job, job->outputFile, recordBuffer+nSplitPosPnt, nLenRecOut, nLenRek);	/* Len output   */
			cob_write (job->outputFile->stFileDef, job->outputFile->stFileDef->record, job->outputFile->opt, NULL, 0);
			switch (atol((char *)job->outputFile->stFileDef->file_status))
			{
			case 0: 
				break;
			case  4:		/* record successfully read, but too short or too long */
				fprintf(stdout,"*GCSORT*S627*ERROR:record successfully read, but too short or too long. %s - File Status (%c%c)\n", job->outputFile->stFileDef->assign->data,
					job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
				util_view_numrek();
				job_print_error_file(job->inputFile->stFileDef, nLenRek);
				job_print_error_file(job->outputFile->stFileDef, nLenRecOut);
				retcode_func = -1;	/* Error stop execution */
				goto job_save_exit;
				break;
			case 71 :
				fprintf(stdout,"*GCSORT*S627*ERROR: Record contains bad character %s - File Status (%c%c)\n",file_getName(job->outputFile),
					job->outputFile->stFileDef->file_status[0],job->outputFile->stFileDef->file_status[1]);
				util_view_numrek();
				job_print_error_file(job->inputFile->stFileDef, nLenRek);
				job_print_error_file(job->outputFile->stFileDef, nLenRecOut);
				retcode_func = -1;	/* Error stop execution */
				goto job_save_exit;
				break;
			default :
				fprintf(stdout,"*GCSORT*S627*ERROR: Cannot write to file %s - File Status (%c%c)\n",file_getName(job->outputFile),
					job->outputFile->stFileDef->file_status[0],job->outputFile->stFileDef->file_status[1]);
				util_view_numrek();
				job_print_error_file(job->inputFile->stFileDef, nLenRek);
				job_print_error_file(job->outputFile->stFileDef, nLenRecOut);
				retcode_func = -1;
				goto job_save_exit;
			}
            job->recordWriteOutTotal++;
		}

/* OUTFIL */
/* Make output for OUTFIL */
		if ((nLenRek > 0) && (job->outfil != NULL)){
			if (outfil_write_buffer(job, recordBuffer, nLenRek, szBuffRek, nSplitPosPnt) < 0){
					retcode_func = -1;
					goto job_save_exit;
			}
			job->recordWriteOutTotal++;
		}
	}	/*  end of cycle    */


	/* s.m. 20230216 */
	cob_close(file->stFileDef, NULL, COB_CLOSE_NORMAL, 0);

/* End output */ 

		if (nbyteRead==0) {
			/* End of file */
            } else if (nbyteRead==-1) {
			fprintf(stdout,"*GCSORT*S719*ERROR: Cannot read file %s : %s\n",file_getName(file),strerror(errno));
			return -1;
		} else {
			fprintf(stderr,"Wrong record length in file %s\n",file_getName(file));
			return -1;
		}
		nEOFFileIn=1;
        
	} /*for (file=job->inputFile; file!=NULL; file=file_getNext(file)) */
job_save_exit:

	if ((job->outputFile != NULL) && (job->nOutFileSameOutFile == 0))
		cob_close (job->outputFile->stFileDef, NULL, COB_CLOSE_NORMAL, 0);

	if (desc >= 0){
		if (close(desc)<0) {
			fprintf(stdout,"*GCSORT*S629*ERROR: Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
			return -1;
		}
	}
	if (job->outfil != NULL){
		if (outfil_close_files(job) < 0) {
				return -1;
		}
	}

	free(recordBuffer);
	free(szBuffRek);
	free(szBuffReceive);
	free(szBuffOut);
	free(szFirstRek);
	free(szBuffRekE35);
	free(szVectorRead1);
	free(szVectorRead2);

	/* return 0;  */
	return retcode_func;	
}



