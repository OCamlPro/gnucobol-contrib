/*
    Copyright (C) 2016-2017 Sauro Menna
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
#include "libgcsort.h"
#include <string.h>
#include <stddef.h>
#include <string.h>
#include <math.h>

//#ifdef _WIN32
#ifdef _MSC_VER
	#include <io.h> 
	#include <windows.h>
	#include <fcntl.h> 
	#include <share.h>
#endif

//
//-->> #include "oclib.h"
#include "gcsort.h"
#include "job.h"
#include "file.h"
#include "sortfield.h"
#include "condfield.h"
#include "outrec.h"
#include "parser.h"
#include "scanner.h"
#include "sortfield.h"
#include "sumfield.h"
#include "utils.h"
#include "outfil.h"


#ifdef _MSC_VER
	#include <crtdbg.h>
#endif


struct outfil_t *outfil_constructor( void) 
{
//-->>	
	struct outfil_t *outfil=(struct outfil_t *)malloc(sizeof(struct outfil_t));
    if (outfil != NULL) {
	    // in questa parte è da creare il riferimento al file o ai files
	    // creazione della struttura file_t per poi assegnare il nome del file
	    // la tipologia di flusso dove è dichiarata ?
	    outfil->outfil_File=NULL;
	    outfil->outfil_nStartRec=-1;		// StartRek for outfil
	    outfil->outfil_nEndRec=-1;			// EndRek for outfil
	    outfil->outfil_includeCond=NULL;
	    outfil->outfil_omitCond=NULL;
	    outfil->nSave=0;

	    outfil->outfil_outrec=NULL;

	    outfil->nSplit=0;			// (SPLIT SPLITBY -SPLIT1R=n-)	
        outfil->nRecSplit=0;
        outfil->nRecTmp=1;
        outfil->pLastFileSplit= NULL;
	    // new
	    outfil->bIsCopy=0;		// SORT-MERGE FIELDS=COPY
	    outfil->recordWriteOutTotal=0;
	    outfil->recordNumber=0;
	    outfil->next=NULL;
    }
return outfil;
}
void outfil_destructor(struct outfil_t *outfil) 
{

	if (outfil->outfil_includeCond != NULL)
		free(outfil->outfil_includeCond);
	if (outfil->outfil_omitCond != NULL)
		free(outfil->outfil_omitCond);
	if (outfil->outfil_outrec != NULL)
		free(outfil->outfil_outrec);
//	free(file);
}

int outfil_SetStartRec(struct outfil_t *outfil, int64_t nStartRec) 
{
	
	outfil->outfil_nStartRec = nStartRec;
	return 0;
}

int  outfil_SetEndRec(struct outfil_t *outfil, int64_t nEndRec) 
{
	
	outfil->outfil_nEndRec = nEndRec;
	return 0;
}
 
int setOutfilIncludeCondField(struct outfil_t* outfil, struct condField_t * condfield)
{
	outfil->outfil_includeCond = condfield;
	return 0;
}

void setOutfilOmitCondField(struct outfil_t* outfil, struct condField_t * condfield){

	outfil->outfil_omitCond = condfield;
	return;
}

void setOutfilOutRecField(struct outfil_t* outfil, struct outrec_t * outrec)
{
	outfil->outfil_outrec = outrec;
	return;
}


struct outfil_t *outfil_getNext(struct outfil_t *outfil) 
{
	if (outfil==NULL) {
		return NULL;
	} else {
		return outfil->next;
	}
}
 
int outfil_addQueue(struct outfil_t **outfil, struct outfil_t *outfilToAdd) 
{
	struct outfil_t *f;
	if (*outfil==NULL) {
		*outfil=outfilToAdd;
	} else {
		for (f=*outfil;f->next!=NULL;f=f->next);
		f->next=outfilToAdd;
	}
	return 0;
}

int setOutfilFiles(struct outfil_t *outfil, struct file_t * file) 
{
	outfil->outfil_File = file;
	return 0;
}

// Save insert into output record that don't satisfy prec conditions
int outfil_SetSave(struct outfil_t *outfil) 
{
	outfil->nSave = 1;		// Save
	return 0;
}

int outfil_addDefinition(struct outfil_t* outfil) 
{
	outfil_addQueue(&(globalJob->outfil), outfil);
	return 0;
}

int outfil_addoutfilrec(struct outrec_t *outrec) 
{
	outrec_addQueue(&(globalJob->outfil->outfil_outrec), outrec);
	return 0;
}

int outfil_setOutfilFiles(struct outfil_t *outfil, struct file_t * file) 
{
	outfil->outfil_File = file;
	return 0;
}
int outfil_open_files( struct job_t *job ) 
{
	// check if present SAVE e memorize pointer
	struct outfil_t *pOutfil;
	struct file_t  *file;
	char* pEnvFileName = NULL;
	int nbyteRead=0;
	for (pOutfil=job->outfil; pOutfil != NULL; pOutfil=outfil_getNext(pOutfil)) {
		for (file=pOutfil->outfil_File; file != NULL; file=file_getNext(file)) {
			// clone info from GIVE outfile  
			outfile_clone_output(job, file);
            strcpy((char*) file->stFileDef->assign->data, (char*) file_getName(file));  //new
			cob_open(file->stFileDef,  COB_OPEN_OUTPUT, 0, NULL);
			if (atol((char *)file->stFileDef->file_status) != 0) {
				fprintf(stderr,"*GCSORT*S401*ERROR: Cannot open file %s - File Status (%c%c) \n",file_getName(file), 
					file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
				return -1;
			}
		}
	}

	return 0;
}

// Clone information for outfile from job outputfile
int outfile_clone_output(struct job_t* job, struct file_t* file)
{
	struct KeyIdx_t* tKeys;
	int nP=0;

	// check outfil without FNAME/FILE
	if (file->stFileDef == NULL) {
		// 
		file_SetInfoForFile(file, COB_OPEN_OUTPUT);
		fprintf(stderr,"*GCSORT*W680* OUTFIL without FILES/FNAMES, forced GIVE definition %s\n",file_getName(file));
		return 0;
	}
	file->nNumKeys = job->outputFile->nNumKeys;  
	file->stFileDef->record_min = job->outputFile->recordLength;                         
	file->stFileDef->record_max = job->outputFile->maxLength;            
	if (file->stFileDef->record != NULL)
		free(file->stFileDef->record->data);
	file->stFileDef->record->data = (unsigned char*) malloc((sizeof(unsigned char)*job->outputFile->maxLength)+1);
	if (file->format == FILE_TYPE_VARIABLE)
		file->stFileDef->variable_record = util_cob_field_make( COB_TYPE_NUMERIC_DISPLAY, 5, 0, 0, 5, ALLOCATE_DATA);
	else
		file->stFileDef->variable_record = NULL;
	if (job->outputFile->nNumKeys > 0)
		file->stFileDef->keys = (cob_file_key*)(malloc (sizeof (cob_file_key) * job->outputFile->nNumKeys));

	if (job->outputFile->organization == FILE_ORGANIZATION_INDEXED) {
		tKeys =  job->outputFile->stKeys;
		for(nP=0; nP< file->nNumKeys;nP++) {
				file->stFileDef->keys[nP].field = util_cob_field_make( tKeys->pCobFieldKey->attr->type, tKeys->pCobFieldKey->attr->digits, 
					tKeys->pCobFieldKey->attr->scale, tKeys->pCobFieldKey->attr->flags, tKeys->pCobFieldKey->size, NOALLOCATE_DATA);
				file->stFileDef->keys[nP].field->data = file->stFileDef->record->data+tKeys->position;
				file->stFileDef->keys[nP].flag = 0;
				if (tKeys->type == KEY_IDX_ALTERNATIVE_DUP)
					file->stFileDef->keys[nP].flag = 1;		// with duplicates
				file->stFileDef->keys[nP].offset = tKeys->position;
				tKeys =  tKeys->next;
		}
	}
	if (job->outputFile->organization == FILE_ORGANIZATION_RELATIVE) {
		tKeys =  job->outputFile->stKeys;
		tKeys =  file->stKeys;
		file->stFileDef->keys = (cob_file_key*)(malloc (sizeof (cob_file_key) * 1));
		file->stFileDef->keys[0].field = util_cob_field_make( COB_TYPE_NUMERIC_DISPLAY, 5, 0, 0, 5, ALLOCATE_DATA);
		file->stFileDef->keys[0].flag = 0;
		file->stFileDef->keys[0].offset = 0;
		file->stFileDef->organization = COB_ORG_RELATIVE;
	}
	return 0;
}
int outfil_close_files(  struct job_t *job  ) 
{
	// check if present SAVE e memorize pointer
	struct outfil_t *pOutfil;
	struct file_t  *file;
	int nbyteRead=0;
	for (pOutfil=job->outfil; pOutfil != NULL; pOutfil=outfil_getNext(pOutfil)) {
		for (file=pOutfil->outfil_File; file != NULL; file=file_getNext(file)) {
			cob_close (file->stFileDef, NULL, COB_CLOSE_NORMAL, 0);
		}
	}
	return 0;
}

// Write for OUTFIL NO Split
// don't use buffered
int outfil_write_buffer ( struct job_t *job, unsigned char* recordBuffer, unsigned int  byteRead, unsigned char* szBuffRek, int nSplitPosPnt) 
{

	struct outfil_t *pOutfil;
	int useRecord;
	int nNumWrite;
	unsigned int nLenRecOut=0;
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
    pOutfil=job->outfil;	
	nNumWrite=0;
	nLenRecOut = job->outputLength;
	for (pOutfil=job->outfil; pOutfil != NULL; pOutfil=outfil_getNext(pOutfil)) 
	{
		nLenRecOut = job->outputLength;
		useRecord = 1;
		// 
		if (job->pSaveOutfil == pOutfil)	// skip
			continue;

		if (pOutfil->outfil_nStartRec >= 0)
			// if (job->recordNumberTotal < pOutfil->outfil_nStartRec)
            if (job->recordWriteOutTotal+1 < pOutfil->outfil_nStartRec)
				continue;
		if (pOutfil->outfil_nEndRec >= 0)
			if (job->recordWriteOutTotal+1 > pOutfil->outfil_nEndRec)
				continue;

		// check Include
		if (pOutfil->outfil_includeCond !=NULL && condField_test(pOutfil->outfil_includeCond,(unsigned char*) recordBuffer+nSplitPosPnt, job)==0) 
				useRecord=0;
		// check Omit
		if (pOutfil->outfil_omitCond != NULL && condField_test(pOutfil->outfil_omitCond,(unsigned char*) recordBuffer+nSplitPosPnt, job)==1) 
				useRecord=0;
// Verify Outfil- Outrek
		if (pOutfil->outfil_outrec != NULL) {
			memset(szBuffRek, 0x00, pOutfil->outfil_File->maxLength);
			byteRead = outrec_copy(pOutfil->outfil_outrec, szBuffRek, recordBuffer, pOutfil->outfil_File->maxLength, byteRead, file_getFormat(pOutfil->outfil_File), file_GetMF(pOutfil->outfil_File), job, nSplitPosPnt);
            memcpy(recordBuffer, szBuffRek, byteRead+nSplitPosPnt);
			nLenRecOut = byteRead ;		// For outrec force length of record copy
		}
		// write record
		if (useRecord == 1)
		{
			if (byteRead > 0)
			{
	// Padding or truncate record output
    // From manual SORT
	// OUTFIL not check LRECL for padding and truncating
                if (pOutfil->nSplit == 0) {
				    outfil_set_area(pOutfil->outfil_File, recordBuffer+nSplitPosPnt, nLenRecOut);
				    cob_write (pOutfil->outfil_File->stFileDef, pOutfil->outfil_File->stFileDef->record, pOutfil->outfil_File->opt, NULL, 0);
				    if (atol((char *)pOutfil->outfil_File->stFileDef->file_status) != 0) {
					    fprintf(stderr,"*GCSORT*S402*ERROR: Cannot write to file %s - File Status (%c%c)\n",file_getName(pOutfil->outfil_File), 
						    pOutfil->outfil_File->stFileDef->file_status[0],pOutfil->outfil_File->stFileDef->file_status[1]);
					    job_print_error_file(pOutfil->outfil_File->stFileDef, nLenRecOut);
            		    return -1;
				    }
				    pOutfil->recordWriteOutTotal++;
				    nNumWrite++;
                }
                else
                {
                   outfil_write_buffer_split ( job, pOutfil, recordBuffer, byteRead, szBuffRek, nSplitPosPnt);
                }
			}
		}
	}

	if ((job->pSaveOutfil != 0) && (nNumWrite == 0))
	{
		if (byteRead > 0)
		{
			outfil_set_area(job->pSaveOutfil->outfil_File, recordBuffer+nSplitPosPnt, nLenRecOut);
			cob_write (job->pSaveOutfil->outfil_File->stFileDef, job->pSaveOutfil->outfil_File->stFileDef->record, job->pSaveOutfil->outfil_File->opt, NULL, 0);
			if (atol((char *)job->pSaveOutfil->outfil_File->stFileDef->file_status) != 0) {
				fprintf(stderr,"*GCSORT*S403*ERROR: Cannot write to file %s - File Status (%c%c)\n",file_getName(job->pSaveOutfil->outfil_File), 
					job->pSaveOutfil->outfil_File->stFileDef->file_status[0],job->pSaveOutfil->outfil_File->stFileDef->file_status[1]);
				job_print_error_file(job->pSaveOutfil->outfil_File->stFileDef, nLenRecOut);
            	return -1;
			}
			job->pSaveOutfil->recordWriteOutTotal++;
		}
	}

	return 0;
}

// Write for OUTFIL Split
// don't use buffered
int outfil_write_buffer_split ( struct job_t *job, struct outfil_t* outfil, unsigned char* recordBuffer, unsigned int  byteRead, unsigned char* szBuffRek, int nSplitPosPnt) 
{
    struct file_t* file;	
	int useRecord;
	int nNumWrite;
	unsigned int nLenRecOut=0;
    // get istance of file
	if (outfil->pLastFileSplit != NULL) {
		file = outfil->pLastFileSplit;
        outfil->nRecTmp++;
        if (outfil->nRecTmp > outfil->nRecSplit) {
            outfil->nRecTmp=1;
            file = file_getNext(file);
        }
    }
	else
		file = outfil->outfil_File;	
    if (file == NULL)        // reset first element
	    file = outfil->outfil_File;	

	nNumWrite=0;
	nLenRecOut = job->outputLength;
	useRecord = 1;

	outfil_set_area(file, recordBuffer+nSplitPosPnt, nLenRecOut);
	cob_write (file->stFileDef, file->stFileDef->record, file->opt, NULL, 0);
	if (atol((char *)file->stFileDef->file_status) != 0) {
		fprintf(stderr,"*GCSORT*S404*ERROR: Cannot write to file %s - File Status (%c%c)\n",file_getName(file), 
			file->stFileDef->file_status[0],file->stFileDef->file_status[1]);
		job_print_error_file(file->stFileDef, nLenRecOut);
        return -1;
	}
	outfil->recordWriteOutTotal++;
    file->nCountRow++;  // for single file
	nNumWrite++;
    outfil->pLastFileSplit = file;

	return 0;
}

int outfil_set_area (struct file_t* file, unsigned char* szBuf, int nLen )
{

	// set area data
	memcpy(file->stFileDef->record->data, szBuf, nLen);
	if (file->format == FILE_TYPE_VARIABLE){
		file->stFileDef->record->size = nLen;
		cob_set_int(file->stFileDef->variable_record, (int)nLen);
	}
	else
	{
		file->stFileDef->record->size = nLen;
	}
	return 0 ;
}
