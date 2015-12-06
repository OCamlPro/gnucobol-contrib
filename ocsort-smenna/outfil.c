/*
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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <math.h>
#include <limits.h>

#include <malloc.h>

#include <time.h>
//-->> 
#include <libcob.h>


// s.m. insert
#include <io.h> 
#include <fcntl.h> 
#include <share.h>
#include <string.h>
#include <stddef.h>
#include <string.h>
#include <math.h>
#include <windows.h>

//
//-->> #include "oclib.h"
#include "ocsort.h"
#include "job.h"
#include "file.h"
#include "sortfield.h"
#include "condfield.h"
#include "outrec.h"
#include "parser.h"
#include "scanner.h"
#include "sortfield.h"
#include "SumField.h"
#include "utils.h"
#include "outfil.h"

#include <stdlib.h>

#ifdef _MSC_VER
	#include <crtdbg.h>
#endif


struct outfil_t *outfil_constructor( void) {
//-->>	
	struct outfil_t *outfil=(struct outfil_t *)malloc(sizeof(struct outfil_t));

	// in questa parte � da creare il riferimento al file o ai files
	// creazione della struttura file_t per poi assegnare il nome del file
	// la tipologia di flusso dove � dichiarata ?
	outfil->outfil_File=NULL;
	outfil->outfil_nStartRec=-1;		// StartRek for outfil
	outfil->outfil_nEndRec=-1;			// EndRek for outfil
	outfil->outfil_includeCond=NULL;
	outfil->outfil_omitCond=NULL;
	outfil->nSave=0;

	outfil->outfil_outrec=NULL;

	outfil->nSplit=0;			// (SPLIT SPLITBY -SPLIT1R=n-)	
    outfil->nMaxFileSplit=0;
    outfil->nLastFileSplit=0;	
	// new
	outfil->bIsCopy=0;		// SORT-MERGE FIELDS=COPY
	outfil->recordWriteOutTotal=0;
	outfil->recordNumber=0;
	outfil->next=NULL;

return outfil;
}
void outfil_destructor(struct outfil_t *outfil) {

	if (outfil->outfil_includeCond != NULL)
		free(outfil->outfil_includeCond);
	if (outfil->outfil_omitCond != NULL)
		free(outfil->outfil_omitCond);
	if (outfil->outfil_outrec != NULL)
		free(outfil->outfil_outrec);
//	free(file);
}

int outfil_SetStartRec(struct outfil_t *outfil, int nStartRec) {
	
	outfil->outfil_nStartRec = nStartRec;
	return 0;
}

int  outfil_SetEndRec(struct outfil_t *outfil, int nEndRec) {
	
	outfil->outfil_nEndRec = nEndRec;
	return 0;
}
 
int setOutfilIncludeCondField(struct outfil_t* outfil, struct condField_t * condfield){
	outfil->outfil_includeCond = condfield;
	return 0;
}

void setOutfilOmitCondField(struct outfil_t* outfil, struct condField_t * condfield){
	outfil->outfil_omitCond = condfield;
	return;
}

void setOutfilOutRecField(struct outfil_t* outfil, struct outrec_t * outrec){
	outfil->outfil_outrec = outrec;
	return;
}


struct outfil_t *outfil_getNext(struct outfil_t *outfil) {
	if (outfil==NULL) {
		return NULL;
	} else {
		return outfil->next;
	}
}
 
int outfil_addQueue(struct outfil_t **outfil, struct outfil_t *outfilToAdd) {
	struct outfil_t *f;
	if (*outfil==NULL) {
		*outfil=outfilToAdd;
	} else {
		for (f=*outfil;f->next!=NULL;f=f->next);
		f->next=outfilToAdd;
	}
	return 0;
}

int setOutfilFiles(struct outfil_t *outfil, struct file_t * file) {
	outfil->outfil_File = file;
	return 0;
}

// Save insert into output record that don't satisfy prec conditions
int outfil_SetSave(struct outfil_t *outfil) {
	outfil->nSave = 1;		// Save
	return 0;
}

//int job_addoutfil(struct outfil_t *outfil) {
int outfil_addDefinition(struct outfil_t* outfil) {
	outfil_addQueue(&(globalJob->outfil), outfil);
	return 0;
}

//int job_addoutfilrec(struct outrec_t *outrec) {
int outfil_addoutfilrec(struct outrec_t *outrec) {
	outrec_addQueue(&(globalJob->outfil->outfil_outrec), outrec);
	return 0;
}


//int job_setOutfilFiles(struct outfil_t *outfil, struct file_t * file) {
int outfil_setOutfilFiles(struct outfil_t *outfil, struct file_t * file) {
	outfil->outfil_File = file;
	return 0;
}
int outfil_open_files( struct job_t *job ) {
	// check if present SAVE e memorize pointer
	struct outfil_t *pOutfil;
	struct file_t  *file;
	char* pEnvFileName = NULL;
	char szFileName[MAX_PATH1];
	char szFileNameEnv[MAX_PATH1];

	int nbyteRead=0;
	for (pOutfil=job->outfil; pOutfil != NULL; pOutfil=outfil_getNext(pOutfil)) {
		for (file=pOutfil->outfil_File; file != NULL; file=file_getNext(file)) {
			pEnvFileName = NULL;
			memset(szFileName, 0x00, MAX_PATH1);
			memset(szFileNameEnv, 0x00, MAX_PATH1);
			sprintf(szFileName, "%s", file_getName(file));	// Environment Variable
			sprintf(szFileNameEnv, "%s", file_getName(file));	// Environment Variable
		// Retry name from Environment
			pEnvFileName = getenv (szFileName); 
			if (pEnvFileName!=NULL)
			{
				strcpy(szFileNameEnv, pEnvFileName);
			}
			else
			{
				fprintf(stderr,"*OCSort*W005* OUTFIL Warning Environment variable %s for file. NOT FOUND\n",file_getName(job->outputFile));
				fprintf(stderr,"*OCSort*W005* OUTFIL Force %s into file name.\n",file_getName(job->outputFile));
			}
			file->handleFile = open(szFileNameEnv,_O_WRONLY | O_BINARY | _O_CREAT | _O_TRUNC, _S_IREAD | _S_IWRITE);
			if (file->handleFile <= 0){
				fprintf(stderr,"*OCSort*S051* Cannot open file %s : %s\n",szFileNameEnv,strerror(errno));
				file_stat_win (szFileNameEnv);
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
		}
	}

	return 0;
}
	
int outfil_close_files(  struct job_t *job  ) {
	// check if present SAVE e memorize pointer
	struct outfil_t *pOutfil;
	struct file_t  *file;
	int nbyteRead=0;
	for (pOutfil=job->outfil; pOutfil != NULL; pOutfil=outfil_getNext(pOutfil)) {
		for (file=pOutfil->outfil_File; file != NULL; file=file_getNext(file)) {
			if ((close(file->handleFile))<0) {
				fprintf(stderr,"*OCSort*S052* Cannot close file input %s : %s\n", file->name,strerror(errno));
			}
		}
	}
	return 0;
}

// Write for OUTFIL
// don't use buffered
int outfil_write_buffer ( struct job_t *job, unsigned char* recordBuffer, int  byteRead, unsigned char* szBuffRek ) {

	struct outfil_t *pOutfil;
	int useRecord;
	int nNumWrite;
	int nEWC;

	// check if present SAVE e memorize pointer
	if (job->pSaveOutfil == NULL){
		for (pOutfil=job->outfil; pOutfil != NULL; pOutfil=outfil_getNext(pOutfil)) 
		{
			if (pOutfil->nSave != 0){
				job->pSaveOutfil = pOutfil;
				break;
			}
		}
	}

	if ((job->nOutfil_Split > 0) && (job->pLastOutfil_Split != NULL))
			pOutfil = job->pLastOutfil_Split;
	else
			pOutfil=job->outfil;	
	
	nNumWrite=0;
	for (pOutfil=job->outfil; pOutfil != NULL; pOutfil=outfil_getNext(pOutfil)) 
	{
		useRecord = 1;
		// 
		if (job->pSaveOutfil == pOutfil)	// skip
			continue;

		if (pOutfil->outfil_nStartRec >= 0)
			if (job->recordNumberTotal < pOutfil->outfil_nStartRec)
				continue;
		if (pOutfil->outfil_nEndRec >= 0)
			if (job->recordNumberTotal > pOutfil->outfil_nEndRec)
				continue;

		// check Include
		if (pOutfil->outfil_includeCond !=NULL && condField_test(pOutfil->outfil_includeCond,(char*) recordBuffer, job)==0) 
				useRecord=0;
		// check Omit
		if (pOutfil->outfil_omitCond != NULL && condField_test(pOutfil->outfil_omitCond,(char*) recordBuffer, job)==1) 
				useRecord=0;
		
		
// Verifi Outfil- Outrek
		if (pOutfil->outfil_outrec != NULL) {
			memset(szBuffRek, 0x00, pOutfil->outfil_File->maxLength);
			byteRead = outrec_copy(pOutfil->outfil_outrec, szBuffRek, recordBuffer, pOutfil->outfil_File->maxLength, byteRead, file_getFormat(pOutfil->outfil_File), file_GetMF(pOutfil->outfil_File), job);
			memcpy(recordBuffer, szBuffRek, byteRead);
		}
		// write record
		if (useRecord == 1)
		{
			if (byteRead > 0)
			{
				// Write record len
				// File Variable, get lenght but not for Line Sequential
				if ((file_getFormat(pOutfil->outfil_File) == FILE_TYPE_VARIABLE) && 
					(file_getOrganization(pOutfil->outfil_File) != FILE_ORGANIZATION_LINESEQUENTIAL))
				{
					nEWC = Endian_Word_Conversion(byteRead);
					write(pOutfil->outfil_File->handleFile, &nEWC, 4);  // len of record Big Endian
				}
		#ifndef _WIN32
						if (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL){
							recordBuffer[nLenRek] = 0x0a;
							nLenRek+=1;
						}
		#else
//-->>	warning					if (((recordBuffer+byteRead-2) != 0x0d) || ((recordBuffer+byteRead-1) != 0x0a)) {
						if ((recordBuffer[byteRead-2] != 0x0d) || (recordBuffer[byteRead-1] != 0x0a)) {
							recordBuffer[byteRead]   = 0x0d;
							recordBuffer[byteRead+1] = 0x0a;
							byteRead+=2;
						}
		#endif
				//}

				// write record 
				if (write(pOutfil->outfil_File->handleFile, recordBuffer, byteRead)<0) {
					fprintf(stderr,"*OCSort*S053* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
					if ((close(pOutfil->outfil_File->handleFile))<0) {
						fprintf(stderr,"*OCSort*S054* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
					}
					return -1;
				}
				pOutfil->recordWriteOutTotal++;
				nNumWrite++;
			}
		}

		// split record
		if ((pOutfil->nSplit != 0) && (useRecord == 1))
			break;
		
	}

	if ((job->pSaveOutfil != 0) && (nNumWrite == 0))
	{
		if (byteRead > 0)
		{
			// Write record len
			// File Variable, get lenght but not for Line Sequential
			if ((file_getFormat(job->pSaveOutfil->outfil_File) == FILE_TYPE_VARIABLE) && 
				(file_getOrganization(job->pSaveOutfil->outfil_File) != FILE_ORGANIZATION_LINESEQUENTIAL))
			{
				nEWC = Endian_Word_Conversion(byteRead);
				write(job->pSaveOutfil->outfil_File->handleFile, &nEWC, 4);  // len of record Big Endian
			}
			// write record 
			if (write(job->pSaveOutfil->outfil_File->handleFile, recordBuffer, byteRead)<0) {
				fprintf(stderr,"*OCSort*S055* Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
				if ((close(job->pSaveOutfil->outfil_File->handleFile))<0) {
					fprintf(stderr,"*OCSort*S056* Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
				}
				return -1;
			}
			job->pSaveOutfil->recordWriteOutTotal++;
		}
	}

	return 0;
}

