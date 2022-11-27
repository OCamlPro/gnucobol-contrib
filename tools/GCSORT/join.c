/*
	Copyright (C) 2016-2022 Sauro Menna
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
#include "job.h"
#include "join.h"
#include "sortfield.h"
#include "utils.h"
#include "gcshare.h"
#include "file.h"
#include "sumfield.h"
#include "outrec.h"

#define SIZE_CMD  3
char 	f1_cmd[SIZE_CMD];
char 	f2_cmd[SIZE_CMD];

int	g_nSkipReadF1 = 0;		/* Skip file read */
int g_nSkipReadF2 = 0;



struct join_t* join_constructor(void) {
	struct join_t* join = (struct join_t*)malloc(sizeof(struct join_t));
	if (join != NULL) {
		join->joinkeysF1 = (struct joinkeys_t*)malloc(sizeof(struct joinkeys_t));
		join->joinkeysF1->includeCondField = NULL;
		join->joinkeysF1->joinField = NULL;
		join->joinkeysF1->omitCondField = NULL;
		join->joinkeysF1->nIsSorted = 0;
		join->joinkeysF1->nNoseqck = 0;
		join->joinkeysF1->nFileType = 0;
		join->joinkeysF1->nStopAfter = 0;
		join->joinkeysF1->nNumRow = 0;
		join->joinkeysF1->nNumRowReadSort = 0;
		join->joinkeysF1->nNumRowWriteSort = 0;

		/* F2 */
		join->joinkeysF2 = (struct joinkeys_t*)malloc(sizeof(struct joinkeys_t));
		join->joinkeysF2->includeCondField = NULL;
		join->joinkeysF2->joinField = NULL;
		join->joinkeysF2->omitCondField = NULL;
		join->joinkeysF2->nIsSorted = 0;
		join->joinkeysF2->nNoseqck = 0;
		join->joinkeysF2->nFileType = 0;
		join->joinkeysF2->nStopAfter = 0;
		join->joinkeysF2->nNumRow = 0;
		join->joinkeysF2->nNumRowReadSort = 0;
		join->joinkeysF2->nNumRowWriteSort = 0;

		join->joinunpaired = (struct joinunpaired_t*)malloc(sizeof(struct joinunpaired_t));
		join->joinunpaired->cF1 = 'I';		/* default */
		join->joinunpaired->cF2 = 'I';		/* default */

		join->joinreformat = (struct joinreformat_t*)malloc(sizeof(struct joinreformat_t));
		join->joinreformat->joinreformatrec = NULL;

		/* file name */
		join->pNameFileF1 = malloc(GCSORT_SIZE_FILENAME);
		memset(join->pNameFileF1, 0x00, GCSORT_SIZE_FILENAME);
		join->pNameFileF2 = malloc(GCSORT_SIZE_FILENAME);
		memset(join->pNameFileF2, 0x00, GCSORT_SIZE_FILENAME);
		join->pNameTmpF1 = malloc(GCSORT_SIZE_FILENAME);
		memset(join->pNameTmpF1, 0x00, GCSORT_SIZE_FILENAME);
		join->pNameTmpF2 = malloc(GCSORT_SIZE_FILENAME);
		memset(join->pNameTmpF2, 0x00, GCSORT_SIZE_FILENAME);
		join->pNameTmpOut = malloc(GCSORT_SIZE_FILENAME);
		memset(join->pNameTmpOut, 0x00, GCSORT_SIZE_FILENAME);
		join->pNameFileOut = malloc(GCSORT_SIZE_FILENAME);
		memset(join->pNameFileOut, 0x00, GCSORT_SIZE_FILENAME);

		join->fileF1 = NULL;	/* malloc(sizeof(struct file_t)); */
		join->fileF2 = NULL;	/* malloc(sizeof(struct file_t)); */


		join->outsortField = NULL;

		join->fileTmpOut = NULL;		/* ALlocate file for sort after JOIN */

		/* data for F1 file and F2 file */
		/* Cartesian condition */
		join->pDataF1 = NULL;
		join->neleF1 = 0;
		join->pDataF2 = NULL;
		join->neleF2 = 0;

		join->cFill = ' ';			/* default */

	}
	return join;
}

int join_allocateData(struct join_t* join, struct job_t* job) {

	/* get length record F1 */

	/* get length record F2 */

	/* Use job->buffertSort to allocate area for files F1 and F2 */
	join->llMaxMemSize = (job->ulMemSizeAlloc + job->ulMemSizeAllocSort) / 2;
	/* max num record for file F1 */
	join->nMaxeleF1 = join->llMaxMemSize / job->inputFile->maxLength;
	/* max num record for file F1 */
	join->nMaxeleF2 = join->llMaxMemSize / job->inputFile->next->maxLength;
	join->neleF1 = 0;
	join->neleF2 = 0;

	join->pDataF1 = (unsigned char*)calloc((size_t)join->llMaxMemSize, sizeof(unsigned char));
	if (join->pDataF1 == 0) {
		fprintf(stdout,"*GCSORT*S825*ERROR: Cannot Allocate join->pDataF1, size "NUM_FMT_LLD" byte - %s\n", (long long)join->llMaxMemSize, strerror(errno));
		return -1;
	}
	join->pDataF2 = (unsigned char*)calloc((size_t)join->llMaxMemSize, sizeof(unsigned char));
	if (join->pDataF2 == 0) {
		fprintf(stdout,"*GCSORT*S825*ERROR: Cannot Allocate join->pDataF2, size "NUM_FMT_LLD" byte - %s\n", (long long)join->llMaxMemSize, strerror(errno));
		return -1;
	}

	return 0;
}

void join_destructor(struct join_t* join)
{
	int nIdx = 0;
	int nIdy = 0;
	struct inrec_t* inrec;
	struct inrec_t* fPIn[128];
	struct sortField_t* fPSF[128];
	struct sortField_t* sortField;
	if (join->joinkeysF1 != NULL)
	{
		nIdx = 0;
		for (sortField = join->joinkeysF1->joinField; sortField != NULL; sortField = sortField_getNext(sortField)) {
			fPSF[nIdx] = sortField;
			nIdx++;
		}
		for (nIdy = 0; nIdy < nIdx; nIdy++) {
			sortField_destructor(fPSF[nIdy]);
		}

		if (join->joinkeysF1->includeCondField != NULL)
			condField_destructor(join->joinkeysF1->includeCondField);
		if (join->joinkeysF1->omitCondField != NULL)
			condField_destructor(join->joinkeysF1->omitCondField);

	}

	if (join->joinkeysF2 != NULL)
	{
		nIdx = 0;
		for (sortField = join->joinkeysF2->joinField; sortField != NULL; sortField = sortField_getNext(sortField)) {
			fPSF[nIdx] = sortField;
			nIdx++;
		}
		for (nIdy = 0; nIdy < nIdx; nIdy++) {
			sortField_destructor(fPSF[nIdy]);
		}
		if (join->joinkeysF2->includeCondField != NULL)
			condField_destructor(join->joinkeysF2->includeCondField);
		if (join->joinkeysF2->omitCondField != NULL)
			condField_destructor(join->joinkeysF2->omitCondField);

	}


	if (join->joinreformat->joinreformatrec != NULL) {
		nIdx = 0;
		for (inrec = join->joinreformat->joinreformatrec; inrec != NULL; inrec = join_getNextRefo(inrec)) {
			fPIn[nIdx] = inrec;
			nIdx++;
		}
		for (nIdy = 0; nIdy < nIdx; nIdy++) {
			inrec_destructor(fPIn[nIdy]);
		}
	}
	if (join->pNameFileF1 != NULL)
		free(join->pNameFileF1);
	if (join->pNameFileF2 != NULL)
		free(join->pNameFileF2);
	if (join->pNameTmpF1 != NULL)
		free(join->pNameTmpF1);
	if (join->pNameTmpF2 != NULL)
		free(join->pNameTmpF2);
	if (join->pNameTmpOut != NULL)
		free(join->pNameTmpOut);
	if (join->pNameFileOut != NULL)
		free(join->pNameFileOut);

	if (join->fileTmpOut != NULL)
		file_destructor(join->fileTmpOut);

	free(join->joinkeysF1);
	free(join->joinkeysF2);
	free(join->joinunpaired);
	free(join->joinreformat);

	if (join->pDataF1 != NULL)
		free(join->pDataF1);
	if (join->pDataF2 != NULL)
		free(join->pDataF2);


	free(join);
}

int join_addDefinitionJoin(int njoin, struct sortField_t* sortField)
{
	if (njoin == 1)
		join_addQueue(&(globalJob->join->joinkeysF1->joinField), sortField);
	if (njoin == 2)
		join_addQueue(&(globalJob->join->joinkeysF2->joinField), sortField);
	return 0;
}
int join_addQueue(struct sortField_t** sortField, struct sortField_t* sortFieldToAdd)
{
	struct sortField_t* f;
	if (*sortField == NULL) {
		*sortField = sortFieldToAdd;
	}
	else {
		for (f = *sortField; f->next != NULL; f = f->next);
		f->next = sortFieldToAdd;
	}
	return 0;
}

void join_SetReferenceJob(struct join_t* join)
{
	if (join != NULL)
		globalJob->join = join;
}

int join_addQueueRefo(struct inrec_t** Field, struct inrec_t* FieldToAdd)
{
	struct inrec_t* f;
	if (*Field == NULL) {
		*Field = FieldToAdd;
	}
	else {
		for (f = *Field; f->next != NULL; f = f->next);
		f->next = FieldToAdd;
	}
	return 0;
}
int join_reformat_addDefinition(struct inrec_t* refo)
{
	if (refo != NULL) {
		join_addQueueRefo(&(globalJob->join->joinreformat->joinreformatrec), refo);
	}
	return 0;
}

int join_print(struct job_t* job, struct join_t* join)
{
	char szM1[50];
	struct sortField_t* sortField;
	struct inrec_t* inrec;
	struct joinunpaired_t* unp;
	struct outfil_t* outfil;
	struct outrec_t* outrec;
	struct file_t* file;
	if (join != NULL) {
		/* F1 */
		if (join->joinkeysF1->joinField != NULL) {
			printf("JOIN F1 FIELDS : (");
			for (sortField = join->joinkeysF1->joinField; sortField != NULL; sortField = sortField_getNext(sortField)) {
				if (sortField != join->joinkeysF1->joinField) {
					printf(",");
				}
				sortField_print(sortField);
			}
			printf(") ");
			if (join->joinkeysF1->nIsSorted == 1)
				printf(", SORTED\n");
			if (join->joinkeysF1->nStopAfter > 0)
				printf(", STOPAFT=" NUM_FMT_LLD "\n", (long long)join->joinkeysF1->nStopAfter);
			printf("\n");
		}
		if (join->joinkeysF1->includeCondField != NULL)
			condField_print(join->joinkeysF1->includeCondField);
		if (join->joinkeysF1->omitCondField != NULL)
			condField_print(join->joinkeysF1->omitCondField);
		/* F2 */
		if (join->joinkeysF2->joinField != NULL) {
			printf("JOIN F2 FIELDS : (");
			for (sortField = join->joinkeysF2->joinField; sortField != NULL; sortField = sortField_getNext(sortField)) {
				if (sortField != join->joinkeysF2->joinField) {
					printf(",");
				}
				sortField_print(sortField);
			}
			printf(") ");
			if (join->joinkeysF2->nIsSorted == 1)
				printf(", SORTED\n");
			if (join->joinkeysF2->nStopAfter > 0)
				printf(", STOPAFT=" NUM_FMT_LLD "\n", (long long)join->joinkeysF2->nStopAfter);
			printf("\n");
		}
		if (join->joinkeysF2->includeCondField != NULL)
			condField_print(join->joinkeysF2->includeCondField);
		if (join->joinkeysF2->omitCondField != NULL)
			condField_print(join->joinkeysF2->omitCondField);
		/* Reformat */
		if (join->joinreformat != NULL) {
			printf("REFORMAT FIELDS = (");
			for (inrec = join->joinreformat->joinreformatrec; inrec != NULL; inrec = inrec_getNext(inrec)) {
				if (inrec != join->joinreformat->joinreformatrec) {
					printf(",");
					if (inrec->joinCmd.nFileJoin == 1)
						printf("F1:");
					if (inrec->joinCmd.nFileJoin == 2)
						printf("F2:");
				}
				inrec_print(inrec);
			}
			printf(")\n");
		}
		/* Unpaired  */
		/*
		|=========================|===================|================|
		|       Command           | Join Type         | Flag           |
		|=========================|===================|================|
		| not specified (default) | Inner join        | F1 = I, F2 = I |
		| Unpaired, F1, F2        | Full outer join   | F1 = U, F2 = U |
		| Unpaired                | Full outer join   | F1 = U, F2 = U |
		| Unpaired, F1            | Left outer join   | F1 = U, F2 = I |
		| Unpaired, F2            | Right outer join  | F1 = I, F2 = U |
		| Unpaired, F1, F2, Only  | Only unpaired     | F1 = O, F2 = O |
		| Unpaired, Only          | Only unpaired     | F1 = O, F2 = O |
		| Unpaired, F1, Only      | Unpaired from F1  | F1 = O, F2 = S |
		| Unpaired, F2, Only      | Unpaired from F2  | F1 = S, F2 = O |
		|=========================|===================|=============== |
		*/
		if (join->joinunpaired != NULL) {
			memset(szM1, 0x00, 50);
			printf("JOIN UNPAIRED ");
			unp = join->joinunpaired;
			if (((unp->cF1 == 'I') && (unp->cF2 == 'I')) ||
				((unp->cF1 == ' ') && (unp->cF2 == ' ')))
				strcpy(szM1, " Inner Join (Default) ");

			if ((unp->cF1 == 'U') && (unp->cF2 == 'U'))
				strcpy(szM1, " Full outer join - Unpaired");

			if ((unp->cF1 == 'U') && (unp->cF2 == 'I'))
				strcpy(szM1, "  Left outer join - Unpaired, F1");

			if ((unp->cF1 == 'I') && (unp->cF2 == 'U'))
				strcpy(szM1, " Right outer join - Unpaired, F2");

			if ((unp->cF1 == 'O') && (unp->cF2 == 'O'))
				strcpy(szM1, " Unpaired from F1 - Unpaired, F1, F2, Only");

			if ((unp->cF1 == 'O') && (unp->cF2 == 'S'))
				strcpy(szM1, " Unpaired from F1 - Unpaired, F1, Only");

			if ((unp->cF1 == 'S') && (unp->cF2 == 'O'))
				strcpy(szM1, " Unpaired from F2 - Unpaired, F2, Only");

			printf("%s\n", szM1);
		}
		/*	OUTFIL  */
		if (job->outfil != NULL) {
			printf("OUTFIL : \n");
			for (outfil = job->outfil; outfil != NULL; outfil = outfil_getNext(outfil)) {
				printf("\tFNAMES/FILES:\n");
				for (file = outfil->outfil_File; file != NULL; file = file_getNext(file)) {
					printf("\t\t");
					file_print(file);
				}
				if (outfil->outfil_includeCond != NULL) {
					printf("\t\tINCLUDE : (");
					condField_print(outfil->outfil_includeCond);
					printf(")\n");
				}
				if (outfil->outfil_omitCond != NULL) {
					printf("\t\tOMIT : (");
					condField_print(outfil->outfil_omitCond);
					printf(")\n");
				}
				if (outfil->outfil_outrec != NULL) {
					printf("\t\tOUTREC : (");
					for (outrec = outfil->outfil_outrec; outrec != NULL; outrec = outrec_getNext(outrec)) {
						if (outrec != job->outfil->outfil_outrec) {
							printf(",");
						}
						outrec_print(outrec);
					}
					printf(")\n");
				}
				if (outfil->nSplit > 0)
					printf("\t\tSPLIT \n");
				if (outfil->outfil_nStartRec >= 0)
					printf("\t\tSTARTREC = " NUM_FMT_LLD "\n", (long long)outfil->outfil_nStartRec);
				if (outfil->outfil_nEndRec >= 0)
					printf("\t\tENDREC = " NUM_FMT_LLD "\n", (long long)outfil->outfil_nEndRec);
			}
		}
		if (job->outrec != NULL) {
			printf("OUTREC FIELDS : (");
			for (outrec = job->outrec; outrec != NULL; outrec = outrec_getNext(outrec)) {
				if (outrec != job->outrec) {
					printf(",");
				}
				outrec_print(outrec);
			}
			printf(")\n");
		}
		printf("========================================================\n");
	}
	return 0;
}

struct inrec_t* join_getNextRefo(struct inrec_t* field) {
	if (field == NULL) {
		return NULL;
	}
	else {
		return field->next;
	}
}

void join_IsSorted(int nFile, struct join_t* join)
{
	if (nFile == 1)
		join->joinkeysF1->nIsSorted = 1;
	if (nFile == 2)
		join->joinkeysF2->nIsSorted = 1;
	return;
}
int join_setUnpaired(int nFile, char cType)
{
	if (nFile == 1)
		globalJob->join->joinunpaired->cF1 = cType;
	if (nFile == 2)
		globalJob->join->joinunpaired->cF2 = cType;
	return 0;
}

void join_noSeqCk(int nFile, struct join_t* join)
{
	if (nFile == 1)
		join->joinkeysF1->nNoseqck = 1;
	if (nFile == 2)
		join->joinkeysF2->nNoseqck = 1;
	return;
}


void join_stopAfter(int nFile, struct join_t* join, int64_t nStop)
{
	if (nFile == 1)
		join->joinkeysF1->nStopAfter = nStop;
	if (nFile == 2)
		join->joinkeysF2->nStopAfter = nStop;
	return;
}

void join_SetFile(struct join_t* join, int nFile, char* pFile)
{
	switch (nFile) {
	case FILEF1:
		if (join->pNameFileF1 != NULL)
			strcpy(join->pNameFileF1, pFile);
		break;
	case FILEF2:
		if (join->pNameFileF2 != NULL)
			strcpy(join->pNameFileF2, pFile);
		break;
	case FILETMPF1:
		if (join->pNameTmpF1 != NULL)
			strcpy(join->pNameTmpF1, pFile);
		break;
	case FILETMPF2:
		if (join->pNameTmpF2 != NULL)
			strcpy(join->pNameTmpF2, pFile);
		break;
	case FILETMPOUT:
		if (join->pNameTmpOut != NULL)
			strcpy(join->pNameTmpOut, pFile);
		break;
	case FILEOUT:
		if (join->pNameFileOut != NULL)
			strcpy(join->pNameFileOut, pFile);
		break;
	}
}
/*
	F1 1° file --> Sort --> F1TMP				F1 2° file --> Sort --> F2TMP
		   |                  |                         |
		   | No Sort          |                         | No Sort
		   F1                 |                         F2
		   --------Input--------->|<--------Input----------
			join->pNameFileF1     |   join->pNameFileF2
								JOIN
			Sort Option <---------|---------> No Sort Option
				|									|
			 OutTMP (Input Sort)            FileOUT is result
				|
			  SORT
				|
			 OutFILE is result


*/
int job_joiner(struct job_t* job)
{
	int nF1Sorted = 1;
	int nF2Sorted = 1;
	int nFoutSort = 1;
	int ret = 0;
	int desc = 0;
	int bSortFinal = 0;
	if (job->sortField != NULL)
		bSortFinal = 1;
	struct join_t* join;
	join = job->join;
	/* Save file name */
	struct file_t* pFile = job->inputFile;			/* First File */
	/* join_clonefile(join->fileF1, pFile, 1); */

	join->fileF1 = pFile;			/* first file  */
	join->fileF2 = pFile->next;		/* second file */

	join->nStopAfterSave = job->nStopAft;

	/* save original pointers */
	join->fileSaveF1 = pFile;
	join->fileSaveF2 = pFile->next;

	join->outrec_save = job->outrec;	/* Save Outrec definition */
	job->outrec = NULL;

	join->outfil_save = job->outfil; 	/* Save Outfil definition */
	job->outfil = NULL;


	join->includeCondField_save = job->includeCondField;
	job->includeCondField = NULL;
	join->omitCondField_save = job->omitCondField;
	job->omitCondField = NULL;


	join->fileSaveOut = job->outputFile;

	if (job->sortField != NULL) {
		join->outsortField = job->sortField;	/* Save sort fields informations for final sort, if present */
		join->fileTmpOut = file_constructor(join->pNameTmpOut); /* Generate new file for sort output*/
		file_clone(join->fileTmpOut, job->outputFile);		    /*  Input file is output JOIN Phase */
	}

	utl_copy_realloc(join->pNameFileF1, pFile->name);

	pFile = job->inputFile->next;					/* Second File */
	utl_copy_realloc(join->pNameFileF2, pFile->name);

	pFile = job->outputFile;						/* Output File */
	utl_copy_realloc(join->pNameFileOut, pFile->name);

	globalJob->nIndextmp++;							/* Increment counter temporary file name */
	sort_temp_name(".tmp");
	utl_copy_realloc(join->pNameTmpF1, cob_tmp_temp);		/* Sort File Tmp F1  is input to JOIN*/
	globalJob->nIndextmp++;
	sort_temp_name(".tmp");
	utl_copy_realloc(join->pNameTmpF2, cob_tmp_temp);		/* Sort File Tmp F2  is input to JOIN */

	sort_temp_name(".tmp");
	utl_copy_realloc(join->pNameTmpOut, cob_tmp_temp);		/* Sort File Tmp out  is output from JOIN */



#if defined(GCSDEBUG) 
	sprintf(join->pNameTmpF1, "C:\\GCSORT\\GCSORT_relnew\\tests\\files\\srtF1.txt");		/* Sort File Tmp F1  is input to JOIN*/
	sprintf(join->pNameTmpF2, "C:\\GCSORT\\GCSORT_relnew\\tests\\files\\srtF2.txt");		/* Sort File Tmp F2  is input to JOIN*/
	sprintf(join->pNameTmpOut, "C:\\GCSORT\\GCSORT_relnew\\tests\\files\\srtOut.txt");		/* Sort File Tmp F2  is input to JOIN*/
#endif
	/* Review file name and define to do */


	/* Allocate Data for file (Inner Join problem with Cartesian case)*/
	ret = join_allocateData(join, job);

	if (ret == -1)		/* problem with allocation memory*/
		return ret;

	/* Review  Files in JOB  only 1 input and 1 output */

	/* reset next on first file (struct file_t) */
	job->inputFile->next = NULL;

	/*  Set pointer to first file   */
	pFile = job->inputFile;
	/* Check if file F1 is sorted */
	/* Include and Omit condition if presents mandatory sort step*/
	if ((join->joinkeysF1->nIsSorted == NOTSORTED) && (job->includeCondField == NULL) && (job->omitCondField == NULL)) {
		/* input */
		pFile = job->inputFile;
		utl_copy_realloc(pFile->name, join->pNameFileF1);
		pFile->stFileDef->assign->size = utl_copy_realloc(pFile->stFileDef->assign->data, join->pNameFileF1);
		/* strcpy(join->pNameFileOut, join->pNameTmpF1); */

		/* Set STOPAFTER */
		job->nStopAft = join->joinkeysF1->nStopAfter;
		/* output */
		pFile = job->outputFile;
		utl_copy_realloc(pFile->name, join->pNameTmpF1);
		pFile->stFileDef->assign->size = utl_copy_realloc(pFile->stFileDef->assign->data, join->pNameTmpF1);
		job->sortField = join->joinkeysF1->joinField;

		job->includeCondField = join->joinkeysF1->includeCondField;
		job->omitCondField = join->joinkeysF1->omitCondField;
		job->recordNumberTotal = 0;
		job->recordWriteSortTotal = 0;

		join_sortFile(job);

		join->joinkeysF1->nNumRowReadSort = job->recordNumberTotal;
		join->joinkeysF1->nNumRowWriteSort = job->recordWriteOutTotal;

		nF1Sorted = 0;
	}
	else 
		utl_copy_realloc(join->pNameTmpF1, join->pNameFileF1);

	/* Check if file F2 is sorted */
	/* Include and Omit condition if presents mandatory sort step*/
	if ((join->joinkeysF2->nIsSorted == NOTSORTED) && (job->includeCondField == NULL) && (job->omitCondField == NULL)) {
		/* input */
		pFile = job->inputFile;
		utl_copy_realloc(pFile->name, join->pNameFileF2);
		pFile->stFileDef->assign->size = utl_copy_realloc(pFile->stFileDef->assign->data, join->pNameFileF2);
		/* strcpy(join->pNameFileOut, join->pNameTmpF2); */
		/* Set STOPAFTER */
		job->nStopAft = join->joinkeysF2->nStopAfter;
		/* output */
		pFile = job->outputFile;
		utl_copy_realloc(job->outputFile->name, join->pNameTmpF2);
		pFile->stFileDef->assign->size = utl_copy_realloc(pFile->stFileDef->assign->data, join->pNameTmpF2);
		job->sortField = join->joinkeysF2->joinField;
		job->includeCondField = join->joinkeysF2->includeCondField;
		job->omitCondField = join->joinkeysF2->omitCondField;
		job->recordNumberTotal = 0;
		job->recordWriteSortTotal = 0;
		join_sortFile(job);
		join->joinkeysF2->nNumRowReadSort = job->recordNumberTotal;
		join->joinkeysF2->nNumRowWriteSort = job->recordWriteOutTotal;
		nF2Sorted = 0;
	}
	else
		utl_copy_realloc(join->pNameTmpF2, join->pNameFileF2);

	/* in this point TmpF1 and TmpF2 are sorted files name */

	/* Reset JOB File Out join */
	pFile = job->outputFile;
	if (join->outsortField == NULL) {			/* NO Sort output file from JOIN*/
		utl_copy_realloc(pFile->name, join->pNameFileOut);
		pFile->stFileDef->assign->size = utl_copy_realloc(pFile->stFileDef->assign->data, join->pNameFileOut);
	}
	else {										/* Sort output file from JOIN*/
		utl_copy_realloc(pFile->name, join->pNameTmpOut);
		pFile->stFileDef->assign->size = utl_copy_realloc(pFile->stFileDef->assign->data, join->pNameTmpOut);
	}

	/* First File Join */
	pFile = job->inputFile;
	utl_copy_realloc(job->inputFile->name, join->pNameTmpF1);
	pFile->stFileDef->assign->size = utl_copy_realloc(job->inputFile->stFileDef->assign->data, join->pNameTmpF1);

	/* last - reset next for first file */
	/* Second File Join */
	job->inputFile->next = join->fileF2;
	pFile = job->inputFile->next;
	utl_copy_realloc(pFile->name, join->pNameTmpF2);
	pFile->stFileDef->assign->size = utl_copy_realloc(pFile->stFileDef->assign->data, join->pNameTmpF2);


	/* set */
	job->outrec = join->outrec_save;	/* Restore Outrec */
	join->outrec_save = NULL;

	job->includeCondField = join->includeCondField_save;
	join->includeCondField_save = NULL;

	job->omitCondField = join->omitCondField_save;
	join->omitCondField_save = NULL;

	job->outfil = join->outfil_save; 	/* Save Outfil definition */
	join->outfil_save = NULL;

	/* Check F1,F2  empty file*/
	int64_t nSzF1 = utl_GetFileSize(job->inputFile);
	int64_t nSzF2 = utl_GetFileSize(job->inputFile->next);

	/* JOIN PHASE */

	if ((nSzF1 == 0) && (nSzF2 > 0))
		ret = join_empty_fileF1(job);
	else
		if ((nSzF1 > 0) && (nSzF2== 0))
			ret = join_empty_fileF2(job);
		else
		if ((nSzF1 > 0) && (nSzF2 > 0))
			ret = join_join_files(job);
		else
			ret = join_empty_fileF1F2(job);  /* File F1 and F2 empty */


	job->sortField = join->outsortField;	/* Restore sort fields informations for final sort, if present */
	job->nStopAft = join->nStopAfterSave;	/* Restore value for SORT cmd*/


	/* SORT OUTPUT JOIN FILE */
	if (job->sortField != NULL) {
		/* prepare file info (Input to sort is output from join */
		pFile = file_constructor(join->pNameTmpOut);
		file_clone(pFile, join->fileTmpOut);		/* Input file is output JOIN Phase */
		file_SetInfoForFile(pFile, COB_OPEN_INPUT);
		/* input */
		utl_copy_realloc(pFile->name, join->pNameTmpOut);
		pFile->stFileDef->assign->size = utl_copy_realloc(pFile->stFileDef->assign->data, join->pNameTmpOut);
		/* job->sortField = join->joinkeysF2->joinField; */
		/* reset next on first file (struct file_t) */
		pFile->next = NULL;
		job->inputFile = pFile;
		/* output */
		pFile = job->outputFile;
		utl_copy_realloc(pFile->name, join->pNameFileOut);
		pFile->stFileDef->assign->size = utl_copy_realloc(pFile->stFileDef->assign->data, join->pNameFileOut);

		job->includeCondField = NULL;		/* Reset Include */
		job->omitCondField = NULL;			/* Reset Omit */

		join_sortFile(job);
		/* TODO */
		pFile = job->inputFile;
		file_destructor(pFile);
		job->inputFile = join->fileSaveF1;
		/* reset file - free file ....*/
		job->inputFile->next = join->fileF2;

		nFoutSort = 0;

	}

	if (join->outsortField != NULL)
		job->sortField = join->outsortField;
	else
		job->sortField = NULL;


	/* Restore orinal pointers */
	/* save original pointers */
	job->inputFile = join->fileSaveF1;
	job->inputFile->next = join->fileSaveF2;
	/* reset  */
	job->outputFile = join->fileSaveOut;





	/* delete temporary files */
#if defined(_MSC_VER)  ||  defined(__MINGW32__) || defined(__MINGW64__)
#if !defined(GCSDEBUG)
	if (nF1Sorted == 0)
		DeleteFile(join->pNameTmpF1);
	if (nF2Sorted == 0)
		DeleteFile(join->pNameTmpF2);
	if (nFoutSort == 0)
		DeleteFile(join->pNameTmpOut);
#endif
#else
	if (nF1Sorted == 0) {
		desc = remove(join->pNameTmpF1);
		if (desc != 0) {
			fprintf(stdout,"*GCSORT*W801* WARNING : Cannot remove file %s : %s\n", join->pNameTmpF1, strerror(errno));
			g_retWarn = 4;
		}
	}
	if (nF2Sorted == 0) {
		desc = remove(join->pNameTmpF2);
		if (desc != 0) {
			fprintf(stdout,"*GCSORT*W802* WARNING : Cannot remove file %s : %s\n", join->pNameTmpF2, strerror(errno));
			g_retWarn = 4;
		}
	}
	if (nFoutSort == 0) {
		desc = remove(join->pNameTmpOut);
		if (desc != 0) {
			fprintf(stdout,"*GCSORT*W802* WARNING : Cannot remove file %s : %s\n", join->pNameTmpOut, strerror(errno));
			g_retWarn = 4;
		}

	}
#endif
	return ret;
}

int join_sortFile(struct job_t* job)
{
	/* Reset counter input - output */
	job->recordNumberTotal = 0;
	job->recordWriteOutTotal = 0;

	int ret = job_sort(job);
	return ret;
}



int join_join_files(struct job_t* job) {

	char szNameTmp[MAX_RECSIZE];
	int	bIsEof[MAX_FILES_INPUT];
	int	bIsFirstSumFields = 0;
	int	bTempEof = 0;
	int	handleFile[MAX_FILES_INPUT];
	int	nCompare = 1;
	int	nSumEof;
	unsigned int	recordBufferLength;
	int bFirstRound = 0;
	int bIsFirstTimeF1 = 1;
	int bIsFirstTimeF2 = 1;
	int bcheckF1 = 0;
	int bcheckF2 = 0;
	int bIsWrited = 0;
	int byteReadFile[MAX_RECSIZE];
	int k;
	int kj;
	int nIdx1;
	int nIdxFileIn = 0;
	int nLastRead = 0;
	unsigned int nLenInRec = 0;
	int nMaxEle;
	int nMaxFiles = MAX_FILES_INPUT;		/* size of elements */
	int nNumBytes = 0;
	int nPosPtr, nIsEOF;
	int nPosition = 0;
	int nSplitPosPnt = 0;	/* for pospnt   */
	unsigned int nbyteRead;
	int previousRecord = -1;
	int retcode_func = 0;
	int useRecord;
	int64_t			lPosPnt = 0;
	struct file_t* file;
	struct file_t* Arrayfile_s[MAX_FILES_INPUT];
	unsigned char	szBufKey[MAX_FILES_INPUT][GCSORT_KEY_MAX + SZPOSPNT];	/* key  */
	unsigned char	szBufRek[MAX_FILES_INPUT][GCSORT_MAX_BUFF_REK];	    /* key  */
	unsigned char	szKeyTemp[GCSORT_KEY_MAX + SZPOSPNT];
	unsigned char* ptrBuf[MAX_FILES_INPUT];
	unsigned char* recordBuffer;
	unsigned char* recordBufferF1;
	unsigned char* recordBufferF2;
	unsigned char* recordBufferPrevious;  /* for Sum Fileds NONE   */
	unsigned char* szBuffRek;
	unsigned int	nLenPrec = 0;
	unsigned int	nLenRecOut = 0;
	unsigned int	nLenRek = 0;
	unsigned int	nLenSave = 0;
	int				nCmp = 0;
	int				nFrom = 0;
	int				nFWrite = 0;
	int				nLenKey = 0;
	struct join_t* join;
	int				nSequenceRek = 0;

	join = job->join;

	recordBufferLength = MAX_RECSIZE;

	job->nLenKeys = job_GetLenKeys();
	job->nLastPosKey = job_GetLastPosKeys();

	if (job->nLastPosKey <= NUMCHAREOL)
		job->nLastPosKey = NUMCHAREOL;	/* problem into memchr  */

	for (k = 0; k < MAX_FILES_INPUT; k++)
	{
		byteReadFile[k] = 0;
		Arrayfile_s[k] = NULL;
		memset(szBufKey[k], 0x00, GCSORT_KEY_MAX);
		memset(szBufRek[k], 0x00, GCSORT_MAX_BUFF_REK);
		ptrBuf[k] = 0x00;
	}
	recordBufferLength = MAX_RECSIZE;
	/* onlyfor Line Sequential  */
	if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) || (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUFIXED))
		recordBufferLength = recordBufferLength + 2 + 1;

	recordBuffer = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (recordBuffer == 0)
		fprintf(stdout,"*GCSORT*S862*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

	recordBufferF1 = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (recordBufferF1 == 0)
		fprintf(stdout,"*GCSORT*S862*ERROR: Cannot Allocate recordBufferF1 : %s\n", strerror(errno));

	recordBufferF2 = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (recordBufferF2 == 0)
		fprintf(stdout,"*GCSORT*S862*ERROR: Cannot Allocate recordBufferF2 : %s\n", strerror(errno));

	recordBufferPrevious = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (recordBufferPrevious == 0)
		fprintf(stdout,"*GCSORT*S863*ERROR: Cannot Allocate recordBufferPrevious : %s\n", strerror(errno));

	szBuffRek = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (szBuffRek == 0)
		fprintf(stdout,"*GCSORT*S864*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));

	for (kj = 0; kj < MAX_FILES_INPUT; kj++) {
		byteReadFile[kj] = 0;
		handleFile[kj] = 0;
		bIsEof[kj] = 1;
	}
	/*  new
		Verify segmentation and if last section of file input
	*/
	if (job->outfil != NULL) {
		if (outfil_open_files(job) < 0) {
			retcode_func = -1;
			goto job_join_files_exit;
		}
	}
	/* If Outfile is not null and OutFil not present or OutFil present without FNAME    */
	if ((job->outputFile != NULL) && (job->nOutFileSameOutFile == 0)) { /* new  */
		cob_open(job->outputFile->stFileDef, COB_OPEN_OUTPUT, 0, NULL);
		if (atol((char*)job->outputFile->stFileDef->file_status) != 0) {
			fprintf(stdout,"*GCSORT*S865*ERROR: Cannot open file %s - File Status (%c%c)\n", file_getName(job->outputFile),
				job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
			retcode_func = -1;
			goto job_join_files_exit;
		}
	}

	bFirstRound = 1;
	bIsFirstTimeF1 = 1;
	bIsFirstTimeF2 = 1;
	nLastRead = 0;
	/* Open files for Join */
	nIdx1 = 0;
	nSumEof = 0;
	for (file = job->inputFile; file != NULL; file = file_getNext(file)) {
		strcpy(szNameTmp, file_getName(file));
		/* Save reference for file  */
		Arrayfile_s[nIdx1] = file;
		bIsEof[nIdx1] = 0;
		/* LIBCOB for all files */
		cob_open(Arrayfile_s[nIdx1]->stFileDef, COB_OPEN_INPUT, 0, NULL);
		if (atol((char*)Arrayfile_s[nIdx1]->stFileDef->file_status) != 0) {
			fprintf(stdout,"*GCSORT*S866*ERROR: Cannot open file %s - File Status (%c%c)\n", file_getName(Arrayfile_s[nIdx1]), Arrayfile_s[nIdx1]->stFileDef->file_status[0], Arrayfile_s[nIdx1]->stFileDef->file_status[1]);
			retcode_func = -1;
			goto job_join_files_exit;
		}
		bIsEof[nIdx1] = join_ReadFile(join, nIdx1, Arrayfile_s[nIdx1], &handleFile[nIdx1], &byteReadFile[nIdx1], szBufRek[nIdx1], bIsFirstTimeF1, bIsFirstTimeF2);  /* bIsEof = 0 ok, 1 = eof  */
		if (bIsEof[nIdx1] == 0) {
			ptrBuf[nIdx1] = (unsigned char*)szBufRek[nIdx1];
			if (nIdx1 == 0)
				join->joinkeysF1->nNumRow = 1;
			else
				join->joinkeysF2->nNumRow = 1;

		}
		nIdx1++;
		if (nIdx1 > nMaxFiles) {
			fprintf(stderr, "Too many files input for JOIN Actual/Limit: %d/%d\n", nIdx1, nMaxFiles);
			retcode_func = -1;
			goto job_join_files_exit;
		}
	}
	/* in this point nIdx1 is max for number of files input */

			/* Check for empty file */
	if ((join->neleF1 == 0) && (bIsEof[0] > 0)) {
		fprintf(stdout,"*GCSORT*S895*ERROR: File empty F1 %s\n", file_getName(Arrayfile_s[0]));
		retcode_func = -1;
		goto job_join_files_exit;
	}
	
	if ((join->neleF2 == 0) && (bIsEof[1] > 0)) {
		fprintf(stdout,"*GCSORT*S896*ERROR: File empty F2 %s\n", file_getName(Arrayfile_s[1]));
		retcode_func = -1;
		goto job_join_files_exit;
	}


	nIsEOF = 0;
	nPosition = 0;
	nSumEof = 0;
	for (kj = 0; kj < MAX_FILES_INPUT; kj++) {
		nSumEof = nSumEof + bIsEof[kj];
	}

	bFirstRound = 0;


	nMaxEle = MAX_FILES_INPUT;
	if (nIdx1 < MAX_FILES_INPUT)
		nMaxEle = nIdx1;
	nPosPtr = join_IdentifyBuf(ptrBuf, nMaxEle);

	if (nPosPtr >= 0) {
		/* in this point get len keys */
		nLenKey = join_GetKeys(szBufRek[nPosPtr] + nSplitPosPnt, szKeyTemp, nPosPtr, job->join);		/* for join no POSPNT  */
	}


	/* Reset counter input  */
	job->recordNumberTotal = 0;

	/* Reset counter output */
	job->recordWriteOutTotal = 0;


	int nCmd = 0;
	int nFirstRound = 1;

	while ((nSumEof) < MAX_FILES_INPUT + 2) /*  job->nNumTmpFile)   */
	{
		nLenRecOut = file_getMaxLength(job->outputFile);

		/* start of check   */
		/* Identify buffer  */
		/* nCmp result compare */
		/*
		   nCmp  = 0   same key value
		*/

		nLastRead = 0;
		if (join_F1_read() == 1)
			nCmd = 1;


		/* check if F2 is EOF */
		if ((nCmd == 0) && (bIsEof[1] == 1))
			 nCmd = 1;

		if (bIsEof[nLastRead] == 0) {
			if ((nCmd == 1) && (nFirstRound == 0)) {
				bIsEof[nLastRead] = join_ReadFile(join, nLastRead, Arrayfile_s[nLastRead], &handleFile[nLastRead], &byteReadFile[nLastRead], szBufRek[nLastRead], bIsFirstTimeF1, bIsFirstTimeF2);  /* bIsEof = 0 ok, 1 = eof  */
				if (bIsEof[nLastRead] == 1) {
					ptrBuf[nLastRead] = 0x00;
					nSumEof = nSumEof + bIsEof[nLastRead];
				}
			}
		}
		else {
			if ((nCmd == 1) && (nFirstRound == 0))
				f2_cmd[0] = 'R';
		}

		nLastRead = 1;
		nCmd = 0;

		if (join_F2_read() == 1)
			nCmd = 1;

		if (bIsEof[nLastRead] == 0) {
			if ((nCmd == 1) && (nFirstRound == 0)) {
				bIsEof[nLastRead] = join_ReadFile(join, nLastRead, Arrayfile_s[nLastRead], &handleFile[nLastRead], &byteReadFile[nLastRead], szBufRek[nLastRead], bIsFirstTimeF1, bIsFirstTimeF2);  /* bIsEof = 0 ok, 1 = eof  */
				if (bIsEof[nLastRead] == 1) {
					ptrBuf[nLastRead] = 0x00;
					nSumEof = nSumEof + bIsEof[nLastRead];
				}
			}
		}
		else {
			if ((nCmd == 1) && (nFirstRound == 0))
				f1_cmd[0] = 'R';
		}
		nCmd = 0;

		nSequenceRek = 0;
		nFirstRound = 0;

		bIsFirstTimeF1 = 0;
		bIsFirstTimeF2 = 0;


		/* -- */
		for (int iF1 = 0; iF1 < join->neleF1; iF1++) {
			for (int jF2 = 0; jF2 < join->neleF2; jF2++) {
				/* Set area record F1 and record F2 */
				/* F1 */
				gc_memcpy(szBufRek[0], join->pDataF1 + (iF1 * job->inputFile->maxLength), job->inputFile->maxLength);
				if (join->joinkeysF1->nIsSorted == SORTED) {  /* If file declare sorted, check sequence */
					if (bcheckF1 > 0) {
						nSequenceRek = join_compare_rek(recordBufferF1, szBufRek[0]);
						if (nSequenceRek > 0) {
							fprintf(stdout,"*GCSORT*S827*ERROR: Sequence error for file F1 record: " NUM_FMT_LLD  " - name: %s \n", (long long)join->joinkeysF1->nNumRow, file_getName(job->inputFile));
							utl_abend_terminate(SEQUENCE_ERR, 501, ABEND_EXEC);
						}
					}
					bcheckF1 = 1;
				}
				gc_memcpy(recordBufferF1, szBufRek[0], job->inputFile->next->maxLength);

				gc_memcpy(szBufRek[1], join->pDataF2 + (jF2 * job->inputFile->next->maxLength), job->inputFile->next->maxLength);
				/* F2 */
				if (join->joinkeysF2->nIsSorted == SORTED) {  /* If file declare sorted, check sequence */
					if (bcheckF2 > 0) {
						nSequenceRek = join_compare_rek(recordBufferF2, szBufRek[1]);
						if (nSequenceRek > 0) {
							fprintf(stdout,"*GCSORT*S828*ERROR: Sequence error for file F2 record: " NUM_FMT_LLD    " - name: %s \n", (long long)join->joinkeysF2->nNumRow, file_getName(job->inputFile->next));
							utl_abend_terminate(SEQUENCE_ERR, 501, ABEND_EXEC);
						}
					}
					bcheckF2 = 1;
				}
				gc_memcpy(recordBufferF2, szBufRek[1], job->inputFile->next->maxLength);

				job->recordNumberTotal++;

				memset(recordBuffer, 0x20, recordBufferLength + nSplitPosPnt);

				nPosPtr = 0;   /* F1 */
				if (bIsEof[nPosPtr] == 0) {
					nbyteRead = byteReadFile[nPosPtr];		/* Number of characters readed by COB_READ */
					nLenRek = nbyteRead;					/* Len of record */
				}

				useRecord = 1;
				/* Include - Omit condition */
				/* F1 */
				if (useRecord == 1 && job->includeCondField != NULL && condField_test(job->includeCondField, (unsigned char*)recordBufferF1 + nSplitPosPnt, job) == FALSE)
					useRecord = 0;
				if (useRecord == 1 && job->omitCondField != NULL && condField_test(job->omitCondField, (unsigned char*)recordBufferF1 + nSplitPosPnt, job) == TRUE)
					useRecord = 0;
				/* F2 */
				if (useRecord == 1 && job->includeCondField != NULL && condField_test(job->includeCondField, (unsigned char*)recordBufferF2 + nSplitPosPnt, job) == FALSE)
					useRecord = 0;
				if (useRecord == 1 && job->omitCondField != NULL && condField_test(job->omitCondField, (unsigned char*)recordBufferF2 + nSplitPosPnt, job) == TRUE)
					useRecord = 0;

				if (useRecord == 0)
					continue;

				/*   */

				/* */
				nCmp = join_compare_rek(recordBufferF1, recordBufferF2);	/* check key  */
				/* */
				useRecord = join_unpaired(job->join, nPosPtr, nCmp, recordBufferF1, recordBufferF2, nLenKey, &bIsEof[0], &bIsEof[1], &nSumEof);

				nFrom = 0;

				nFWrite = 0;

				if (join_F1_write() == 1) {
					nFrom += 1;
					nFWrite += 1;
				}
				if (join_F2_write() == 1) {
					nFrom += 2;
					nFWrite += 1;
				}


				/* //if ((useRecord == 0) || ((join_F1_read() == 1) && (join_F1_write() == 0))) { */
				if (((join_F1_read() == 1) && (join_F1_write() == 0))) {
					memset(szBuffRek, 0x00, join->fileSaveOut->maxLength);
					memcpy(szBuffRek, recordBufferF1, join->fileSaveOut->maxLength);
					fprintf(stderr, "Record F1 discarded: %.*s\n", join->fileSaveF1->maxLength, szBuffRek);
				}
				/* //if ((useRecord == 0) || ((join_F2_read() == 1) && (join_F2_write() == 0))) { */
				if (((join_F2_read() == 1) && (join_F2_write() == 0))) {
					memset(szBuffRek, 0x00, recordBufferLength);
					memcpy(szBuffRek, recordBufferF2, join->fileSaveOut->maxLength);
					fprintf(stderr, "Record F2 discarded: %.*s\n", join->fileSaveF2->maxLength, szBuffRek);
				}


				if ((nFWrite == 0) && (join_F2_read() == 0)) {
					break;
				}

				/* Verify compare result and break cycle F2 */
				if ((nCmp < 0) && (nFWrite == 0))
					break;
			   
				/*           REFORMAT   RECORD           */
				/* Verify if continue (UseRecord == 1)  or (Write from buffer F1 or F2)*/
				if ((useRecord == 0) || (nFWrite == 0)) {
					continue;
				}
				memset(szBuffRek, 0x20, recordBufferLength);
				/* Fill buffer with fill character ( blank default */
				memset(recordBuffer, join->cFill, join->fileSaveOut->maxLength);
				/* set len output */
				nbyteRead = join_reformat(job, recordBufferF1, recordBufferF2, recordBuffer, nSplitPosPnt, nFrom);

				/*                                       */
				/*                                       */
				job->LenCurrRek = nLenRek;
				/*  Outrec */
				if (job->outrec != NULL) {
					/* check overlay    */
					if (job->outrec->nIsOverlay == 0) {
						memset(szBuffRek, 0x20, recordBufferLength);
						nbyteRead = outrec_copy(job->outrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
						memset(recordBuffer, 0x20, recordBufferLength); /* s.m. 202101  */
						memcpy(recordBuffer, szBuffRek, nbyteRead + nSplitPosPnt);
						job->LenCurrRek = nbyteRead;
						nLenRek = nbyteRead;
					}
					else
					{		/* Overlay  */
						memset(szBuffRek, 0x20, recordBufferLength);
						memmove(szBuffRek, recordBuffer, nLenRek + nSplitPosPnt);	/* s.m. 202101 copy input record    */
						nbyteRead = outrec_copy_overlay(job->outrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
						nbyteRead++;
						if (nbyteRead < nLenRek)
							nbyteRead = nLenRek;
						if (recordBufferLength < nbyteRead)
							recordBuffer = (unsigned char*)realloc(recordBuffer, nLenInRec + 1);
						memset(recordBuffer, 0x20, recordBufferLength); /* s.m. 202101  */
						memcpy(recordBuffer + nSplitPosPnt, szBuffRek + nSplitPosPnt, nbyteRead);
						job->LenCurrRek = nbyteRead;
						nLenRek = nbyteRead;
					}
				}
				/*         */
				if ((nbyteRead > 0) && (job->outfil == NULL)) {
					job_set_area(job, job->outputFile, recordBuffer + nSplitPosPnt, nLenRecOut, nbyteRead);
					cob_write(job->outputFile->stFileDef, job->outputFile->stFileDef->record, job->outputFile->opt, NULL, 0);
					switch (atol((char*)job->outputFile->stFileDef->file_status))
					{
						case 0: 
							break;
						case  4:		/* record successfully read, but too short or too long */
							fprintf(stdout,"*GCSORT*S867*ERROR:record successfully read, but too short or too long. %s - File Status (%c%c)\n", job->outputFile->stFileDef->assign->data,
								job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
							util_view_numrek();
							retcode_func = -1;
							goto job_join_files_exit;
							break;
						case 71:
							fprintf(stdout,"*GCSORT*S867*ERROR: Record contains bad character %s - File Status (%c%c)\n", file_getName(job->outputFile),
								job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
							util_view_numrek();
							retcode_func = -1;
							goto job_join_files_exit;
							break;
						default:
							fprintf(stdout,"*GCSORT*S867*ERROR: Cannot write file %s - File Status (%c%c)\n", file_getName(job->outputFile),
								job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
							util_view_numrek();
							retcode_func = -1;
							goto job_join_files_exit;
					}
					job->recordWriteOutTotal++;
				}
				/* OUTFIL   */
				if ((job->LenCurrRek > 0) && (job->outfil != NULL)) {
					if (outfil_write_buffer(job, recordBuffer, job->LenCurrRek, szBuffRek, nSplitPosPnt) < 0) {
						retcode_func = -1;
						goto job_join_files_exit;
					}
					job->recordWriteOutTotal++;
				}
				if ((nCmp < 0) && (bIsEof[0] == 0)) {
					nCmp = 0;
					break;
				}
			}	/* for jF2 */
			/* Verify compare result and break cycle F2 */
			if ((join_F1_read() == 0) && (bIsEof[0] == 0)) 
				break;
			if ((nCmp > 0) && (bIsEof[1] == 0))
				break;
		}  /* for jF1 */
	}

job_join_files_exit:
	free(szBuffRek);
	free(recordBuffer);
	free(recordBufferF1);
	free(recordBufferF2);
	free(recordBufferPrevious);

	for (kj = 0; kj < MAX_HANDLE_TEMPFILE; kj++) {
		if (Arrayfile_s[kj] != NULL) {
			if (Arrayfile_s[kj]->stFileDef != NULL)
				cob_close(Arrayfile_s[kj]->stFileDef, NULL, COB_CLOSE_NORMAL, 0);
		}
	}
	cob_close(job->outputFile->stFileDef, NULL, COB_CLOSE_NORMAL, 0);
	return retcode_func;
}

int join_F1_read(void) {
	int res = 0;
	for (int ix = 0; ix < SIZE_CMD; ix++) {
		if (f1_cmd[ix] == 'R')
			return 1;
	}
	return 0;
}
int join_F1_write(void) {
	int res = 0;
	for (int ix = 0; ix < SIZE_CMD; ix++) {
		if (f1_cmd[ix] == 'W')
			return 1;
	}
	return 0;
}
int join_F2_read(void) {
	int res = 0;
	for (int ix = 0; ix < SIZE_CMD; ix++) {
		if (f2_cmd[ix] == 'R') 
			return 1;
	}
	return 0;
}
int join_F2_write(void) {
	int res = 0;
	for (int ix = 0; ix < SIZE_CMD; ix++) {
		if (f2_cmd[ix] == 'W')
			return 1;
	}
	return 0;
}

int join_reformat(struct job_t* job, unsigned char* rF1, unsigned char* rF2, unsigned char* sRek, int nSplitPos, int nFrom) {
	int len = 0;
	int nPos = 0;
	len = join_reformat_copy(job->join->joinreformat->joinreformatrec, rF1, rF2, sRek, job, nSplitPos, nFrom);
	return len;
}

int join_compare_rek(const void* first, const void* second)
{
	int result = 0;
	int nSp = 0;				/*-->> SZPOSPNT; */ /* first 8 byte for PosPnt    */
	struct sortField_t* sortFieldF1;
	struct sortField_t* sortFieldF2;
	sortFieldF1 = globalJob->join->joinkeysF1->joinField;
	sortFieldF2 = globalJob->join->joinkeysF2->joinField;
	if ((sortFieldF1 == NULL) || (sortFieldF2 == NULL)) {
		fprintf(stdout,"*GCSORT*S788*ERROR: Compare record error ( join_compare_rek) JoinKeys F1 or F2 is not defined\n");
		utl_abend_terminate(PARAM_ERR, 501, ABEND_EXEC);
	}

	for (sortFieldF1; sortFieldF1 != NULL; sortFieldF1 = sortField_getNext(sortFieldF1)) {

		/*  for F1 and F2 same len and binary compare */
		result = memcmp((unsigned char*)first + sortFieldF1->position - 1, (unsigned char*)second + sortFieldF2->position - 1, sortFieldF1->length);
		if (result) {
			/* Sort Direction is identical for F1 and F2 */
			if (sortField_getDirection(sortFieldF1) == SORT_DIRECTION_ASCENDING) {
				return result;
			}
			else {
				return -result;
			}
		}
		sortFieldF2 = sortField_getNext(sortFieldF2);
	}
	return 0;
}
int join_GetKeys(unsigned char* szBufferIn, unsigned char* szKeyOut, int nPosPnt, struct join_t* join) {
	int nSp = 0;
	int nPos = 0;
	int nLen = 0;
	struct sortField_t* sortField;
	if (nPosPnt == 0)
		sortField = join->joinkeysF1->joinField;
	else
		sortField = join->joinkeysF2->joinField;
	for (; sortField != NULL; sortField = sortField_getNext(sortField)) {
		nPos = sortField->position;   /*  sortField_getPosition(sortField);   */
		nLen = sortField->length;     /*  sortField_getLength(sortField);     */
		gc_memcpy((unsigned char*)szKeyOut + nSp,
			(unsigned char*)szBufferIn + nPos - 1,
			nLen);
		nSp = nSp + nLen;
	}
	return nSp;
}


int join_IdentifyBuf(unsigned char** ptrBuf, int nMaxEle)
{
	unsigned char* ptr;
	int p = 0;
	int posAr = -1;
	ptr = ptrBuf[0];
	for (p = 0; p < MAX_HANDLE_TEMPFILE; p++) /* search first buffer not null   */
	{
		if (ptrBuf[p] != 0x00) {
			ptr = ptrBuf[p];
			posAr = p;
			break;
		}
	}
	for (p = posAr + 1; p < MAX_HANDLE_TEMPFILE; p++) {
		if (ptrBuf[p] == 0x00)
			continue;
		if (join_compare_rek(ptr, ptrBuf[p]) > 0) {		/* check pospnt enable  */
			ptr = ptrBuf[p];
			posAr = p;
		}
	}
	return posAr;
}
/* JOIN Statement */
/* JOIN UNPAIRED,F1,F2,ONLY  */
/* I = Inner, U = Unpaired , O = Only,  S= Skip
|=========================|===================|============|=================================|=======================================|
|       Command           |   Join Type       |    Flag    |           Output                |             Record                    |
|=========================|===================|============|=================================|=======================================|
| not specified (default) | Inner join        | F1=I, F2=I | F1 matched, F2 matched          |  F1 + F2								 |
| Unpaired, F1, F2        | Full outer join   | F1=U, F2=U | All records                     |  F1 + F2								 |
| Unpaired                | Full outer join   | F1=U, F2=U | All records                     |  F1 + F2								 |
| Unpaired, F1            | Left outer join   | F1=U, F2=I | F1 all records and F2 matched   |  F1 + blank/fill or F1 + F2           |
| Unpaired, F2            | Right outer join  | F1=I, F2=U | F1 matched and F2 all records   |  F1 + F2  or  F2 + blank/fill		 |
| Unpaired, F1, F2, Only  | Only unpaired     | F1=O, F2=O | F1 no matched, F2 no matched    |  F1 + blank/fill  or  F2 + blank/fill |
| Unpaired, Only          | Only unpaired     | F1=O, F2=O | F1 no matched, F2 no matched    |  F1 + blank/fill  or  F2 + blank/fill |
| Unpaired, F1, Only      | Unpaired from F1  | F1=O, F2=S | F1 only no matched, F2 Skipped  |  F1 + blank/fill  					 |
| Unpaired, F2, Only      | Unpaired from F2  | F1=S, F2=O | F1 Skipped, F2 only no matched  |  F2 + blank/fill						 |
|=========================|===================|============|=================================|=======================================|
	(case A)
	JoinType    I  skip		    - read F1								 f1_cmd[0] = 'R';
				U  write out F1 - read F1	                             f1_cmd[0] = 'W'; f1_cmd[1] = 'R';
				O  write out F1 - read F1	                             f1_cmd[0] = 'W'; f1_cmd[1] = 'R';
				S  no action				                             f1_cmd[0] = '0x00';
	(case B)
	JoinType    I  write out F1 - write out F2 - read F1 - read F2	     f1_cmd[0] = 'W'; f1_cmd[1] = 'R'; f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
				U  write out F1 - write out F2 - read F1 - read F2       f1_cmd[0] = 'W'; f1_cmd[1] = 'R'; f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
				O  skip F1	- skip F2 - read F1 - read F2                f1_cmd[0] = 'R'; f2_cmd[0] = 'R';
				S  skip F1	- skip F2 - read F1 - read F2                f1_cmd[0] = 'R'; f2_cmd[0] = 'R';
	(case C)
	JoinType    I  skip         - read F2								 f2_cmd[0] = 'R';
				U  write out F2 - read F2                                f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
				O  write out F2 - read F2                                f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
				S  no action                                             f2_cmd[0] = '0x00';

				Return Code = 0 No action, 1 Reformat
*/
int join_unpaired(struct join_t* join, int nPosPtr, int nCmp, unsigned char* rF1, unsigned char* rF2, int lenkey, int* pbEofF1, int* pbEofF2, int* pnSumEof) {
	struct joinreformat_t* refo;
	struct joinunpaired_t* unp;

	refo = join->joinreformat;
	unp = join->joinunpaired;

	memset(f1_cmd, 0x00, SIZE_CMD);
	memset(f2_cmd, 0x00, SIZE_CMD);
	/* ------------------------------------------------- */
	/* Insert command 'W' write  before 'R' read command */
	/* ------------------------------------------------- */
	/*
	| Command			      | Join Type		  | Flag	   | Output						     |
	| not specified			  | Inner join		  | F1=I, F2=I | F1 matched, F2 matched          |
	*/
	if ((unp->cF1 == 'I') && (unp->cF2 == 'I')) {
		if (nCmp == 0) {
			if (*pbEofF1 == 1) {
				*pbEofF1 = *pbEofF1 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			if (*pbEofF2 == 1) {
				*pbEofF2 = *pbEofF2 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			f1_cmd[0] = 'W'; f1_cmd[1] = 'R'; f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
			return 1;
		}
		if (nCmp < 0) {
			if (*pbEofF1 == 2) {/* EOF File F1 */
				f2_cmd[0] = 'R';
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
			else {
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				f1_cmd[0] = 'R';
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
		}
		/* F1 Key is major of F2 Key */
		if (nCmp > 0) {
			f2_cmd[0] = 'R';
			if (*pbEofF2 == 1) {
				*pbEofF2 = *pbEofF2 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			if (*pbEofF1 == 1) {
				*pbEofF1 = *pbEofF1 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			return 1;
		}
		return 0;
	}
	/*
	|=========================|===================|============|=================================|
	| Command			      | Join Type		  | Flag	   | Output						     |
	|=========================|===================|============|=================================|
	| Unpaired                | Full outer join   | F1=U, F2=U | All records                     |
	| Unpaired                | Full outer join   | F1=U, F2=U | All records                     |
	*/
	if ((unp->cF1 == 'U') && (unp->cF2 == 'U')) {
		if (nCmp == 0) {
			if (*pbEofF1 == 1) {
				*pbEofF1 = *pbEofF1 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			if (*pbEofF2 == 1) {
				*pbEofF2 = *pbEofF2 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			f1_cmd[0] = 'W'; f1_cmd[1] = 'R'; f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
			return 1;
		}
		if (nCmp < 0) {
			if (*pbEofF1 == 2) {/* EOF File F1 */
				f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
				/* Fill F1 record */
				memset(rF1, join->cFill, join->fileF1->maxLength);
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
			else {
				f1_cmd[0] = 'W'; f1_cmd[1] = 'R';
				/* Fill F2 record */
				memset(rF2, join->cFill, join->fileF2->maxLength);
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
		}
		if (nCmp > 0) {
			if (*pbEofF2 == 2) {/* EOF File F2 */
				f1_cmd[0] = 'W'; f1_cmd[1] = 'R';
				/* Fill F2 record */
				memset(rF2, join->cFill, join->fileF2->maxLength);
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
			else {
				f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
				/* Fill F1 record */
				memset(rF1, join->cFill, join->fileF1->maxLength);
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
		}
		return 0;
	}

	/*
	|=========================|===================|============|=================================|
	| Command			      | Join Type		  | Flag	   | Output						     |
	|=========================|===================|============|=================================|
	| Unpaired, F1			  | Left outer join   | F1=U, F2=I | F1 all records and F2 matched	 |
	*/
	if ((unp->cF1 == 'U') && (unp->cF2 == 'I')) {
		if (nCmp == 0) {
			f1_cmd[0] = 'W'; f1_cmd[1] = 'R'; f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
			if (*pbEofF1 == 1) {
				*pbEofF1 = *pbEofF1 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			if (*pbEofF2 == 1) {
				*pbEofF2 = *pbEofF2 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			return 1;
		}
		if (nCmp < 0) {
			if (*pbEofF1 == 2) {/* EOF File F1 */
				f2_cmd[1] = 'R';
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
			else {
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				f1_cmd[0] = 'W'; f1_cmd[1] = 'R';
				/* Fill F2 record */
				memset(rF2, join->cFill, join->fileF2->maxLength);
				return 1;
			}
		}
		if (nCmp > 0) {
			if (*pbEofF2 == 2) {/* EOF File F2 */
				f1_cmd[0] = 'W'; f1_cmd[1] = 'R';
				/* Fill F2 record */
				memset(rF2, join->cFill, join->fileF2->maxLength);
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
			else {
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				f2_cmd[0] = 'R';
				return 0;
			}
		}
		return 0;
	}
	/*
	|=========================|===================|============|=================================|
	| Command			      | Join Type		  | Flag	   | Output						     |
	|=========================|===================|============|=================================|
	| Unpaired, F2            | Right outer join  | F1=I, F2=U | F1 matched and F2 all records   |
	*/
	if ((unp->cF1 == 'I') && (unp->cF2 == 'U')) {
		if (nCmp == 0) {
			f1_cmd[0] = 'W'; f1_cmd[1] = 'R'; f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
			if (*pbEofF1 == 1) {
				*pbEofF1 = *pbEofF1 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			if (*pbEofF2 == 1) {
				*pbEofF2 = *pbEofF2 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			return 1;
		}
		if (nCmp < 0) {
			if (*pbEofF1 == 2) {/* EOF File F1 */
				f2_cmd[0] = 'W';
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				/* Fill F2 record */
				memset(rF1, join->cFill, join->fileF1->maxLength);
				return 1;
			}
			else {
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				f1_cmd[0] = 'R';
			}
			return 1;
		}
		if (nCmp > 0) {
			if (*pbEofF2 == 2) {/* EOF File F2 */
				f1_cmd[0] = 'R';
				/* Fill F2 record */
				memset(rF2, join->cFill, join->fileF2->maxLength);
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
			else {
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
				/* Fill F1 record */
				memset(rF1, join->cFill, join->fileF1->maxLength);
				return 1;
			}
		}
		return 0;
	}
	/*
	|=========================|===================|============|=================================|
	| Command			      | Join Type		  | Flag	   | Output						     |
	|=========================|===================|============|=================================|
	| Unpaired, F1, F2, Only  | Only unpaired     | F1=O, F2=O | F1 no matched, F2 no matched    |
	| Unpaired, Only          | Only unpaired     | F1=O, F2=O | F1 no matched, F2 no matched    |
	*/
	if ((unp->cF1 == 'O') && (unp->cF2 == 'O')) {
		if (nCmp == 0) {
			f1_cmd[0] = 'R'; f2_cmd[0] = 'R';
			if (*pbEofF1 == 1) {
				*pbEofF1 = *pbEofF1 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			if (*pbEofF2 == 1) {
				*pbEofF2 = *pbEofF2 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			return 1;
		}
		if (nCmp < 0) {
			if (*pbEofF1 == 2) {	/* EOF File F1 */
				f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
				/* Fill F1 record */
				memset(rF1, join->cFill, join->fileF1->maxLength);
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
			else {
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				/* Fill F2 record */
				memset(rF2, join->cFill, join->fileF2->maxLength);
				f1_cmd[0] = 'W'; f1_cmd[1] = 'R';
			}
			return 1;
		}
		if (nCmp > 0) {
			if (*pbEofF2 == 2) {/* EOF File F2 */
				f1_cmd[0] = 'W'; f1_cmd[1] = 'R';
				/* Fill F2 record */
				memset(rF2, join->cFill, join->fileF2->maxLength);
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
			else {
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				/* Fill F1 record */
				memset(rF1, join->cFill, join->fileF1->maxLength);
				f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
				return 1;
			}
		}
		return 0;
	}
	/*
	|=========================|===================|============|=================================|
	| Command			      | Join Type		  | Flag	   | Output						     |
	|=========================|===================|============|=================================|
	| Unpaired, F1, Only      | Unpaired from F1  | F1=O, F2=S | F1 only no matched, F2 Skipped  |
	*/
	if ((unp->cF1 == 'O') && (unp->cF2 == 'S')) {
		if (nCmp == 0) {
			f1_cmd[0] = 'R'; f2_cmd[0] = 'R';
			if (*pbEofF1 == 1) {
				*pbEofF1 = *pbEofF1 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			if (*pbEofF2 == 1) {
				*pbEofF2 = *pbEofF2 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			return 0;
		}
		if (nCmp < 0) {
			if (*pbEofF1 == 2) {		/* EOF File F1 */
				f2_cmd[0] = 'R';
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
			else {
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				f1_cmd[0] = 'W'; f1_cmd[1] = 'R';
				/* Fill F2 record */
				memset(rF2, join->cFill, join->fileF2->maxLength);
			}
			return 1;
		}
		if (nCmp > 0) {
			if (*pbEofF2 == 2) {/* EOF File F2 */
				f1_cmd[0] = 'W'; f1_cmd[1] = 'R';
				/* Fill F2 record */
				memset(rF2, join->cFill, join->fileF2->maxLength);
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
			else {
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				/* Fill F1 record */
				memset(rF1, join->cFill, join->fileF1->maxLength);
				f2_cmd[0] = 'R';
				return 1;
			}
		}
		return 0;
	}
	/*
	|=========================|===================|============|=================================|
	| Command			      | Join Type		  | Flag	   | Output						     |
	|=========================|===================|============|=================================|
	| Unpaired, F2, Only      | Unpaired from F2  | F1=S, F2=O | F1 Skipped, F2 only no matched  |
	*/
	if ((unp->cF1 == 'S') && (unp->cF2 == 'O')) {
		if (nCmp == 0) {
			f1_cmd[0] = 'R'; f2_cmd[0] = 'R';
			if (*pbEofF1 == 1) {
				*pbEofF1 = *pbEofF1 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			if (*pbEofF2 == 1) {
				*pbEofF2 = *pbEofF2 + 1;
				*pnSumEof = *pnSumEof + 1;
			}
			return 0;
		}
		if (nCmp < 0) {
			if (*pbEofF1 == 2) {/* EOF File F1 */
				f2_cmd[0] = 'W';	f2_cmd[1] = 'R';
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
			else {
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				f1_cmd[0] = 'R';
			}
			return 1;
		}
		if (nCmp > 0) {
			if (*pbEofF2 == 2) { /* EOF File F2 */
				f1_cmd[0] = 'R';
				/* Fill F2 record */
				memset(rF2, join->cFill, join->fileF2->maxLength);
				if (*pbEofF1 == 1) {
					*pbEofF1 = *pbEofF1 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				return 1;
			}
			else {
				if (*pbEofF2 == 1) {
					*pbEofF2 = *pbEofF2 + 1;
					*pnSumEof = *pnSumEof + 1;
				}
				f2_cmd[0] = 'W'; f2_cmd[1] = 'R';
				/* Fill F1 record */
				memset(rF1, join->cFill, join->fileF1->maxLength);
				return 1;
			}
		}
		return 0;
	}

	return 0;
}
int join_reformat_copy(struct inrec_t* inrec, unsigned char* inputF1, unsigned char* inputF2, unsigned char* output, struct job_t* job, int nSplitPos, int nFrom) {
	int position = 0;
	int nSplit = 0;
	int inputLength = 0;
	struct inrec_t* i;
	int nIRangeLen = 0;
	unsigned char* pBuff = NULL;
	struct joinreformat_t* jref;
	jref = job->join->joinreformat;

	/* if not defined REFORMAT  copy all field from F1 or F2 */
	if (inrec) {

		for (i = inrec; i != NULL; i = i->next) {
			if (i->joinCmd.position == -100) {							/* field '?'											 */
				if (nFrom > 2)											/* - 'B' - the key was found in F1 and F2.				 */
					output[position + nSplitPos + nSplit] = 'B';		/* - '1' - the key was found in F1, but not in F2.		 */
				if (nFrom == 2)											/* - '2' - the key was found in F2, but not in F1.		 */
					output[position + nSplitPos + nSplit] = '2';
				if (nFrom == 1)
					output[position + nSplitPos + nSplit] = '1';
				position += 1;
				continue;
			}
			if (i->joinCmd.nFileJoin == 1) {   /* File F1*/
				pBuff = inputF1;
				inputLength = job->inputFile->maxLength;
			}
			if (i->joinCmd.nFileJoin == 2) {   /* File F2*/
				pBuff = inputF2;
				inputLength = job->inputFile->next->maxLength;
			}
			switch (i->type) {
			case INREC_TYPE_JOIN:
				nIRangeLen = i->range.length;
				if (nIRangeLen == -1)		/* outrec pos, -1  (for variable)   */
					nIRangeLen = inputLength - i->range.position - nSplit;
				if ((i->range.position + nSplit + nIRangeLen) <= inputLength)
					memcpy(output + position + nSplitPos + nSplit, pBuff + i->range.position + nSplitPos + nSplit, nIRangeLen);
				else
					/* copy only chars present in input for max len input   */
					memcpy(output + position + nSplitPos + nSplit, pBuff + i->range.position + nSplitPos + nSplit, abs(inputLength - (i->range.position + nSplit)));
				position += nIRangeLen;
				break;
			default:
				printf("ERROR problem in wtich Reformat \n");
				break;
			}
		}
	}
	else
	{
		if (nFrom == 1) {	/* File F1 */
			pBuff = inputF1;
			inputLength = job->inputFile->maxLength;
		}
		if (nFrom == 2) {   /* File F2*/
			pBuff = inputF2;
			inputLength = job->inputFile->next->maxLength;
		}
		if (nFrom > 2) {   /* File F1 and F2*/
			pBuff = inputF1;
			inputLength = job->inputFile->maxLength;
			memcpy(output + position + nSplitPos + nSplit, pBuff + nSplitPos + nSplit, inputLength);
			position += inputLength;
			pBuff = inputF2;
			inputLength = job->inputFile->next->maxLength;
			memcpy(output + position + nSplitPos + nSplit, pBuff + nSplitPos + nSplit, inputLength);
			pBuff = NULL;
		}
		if (pBuff) {
			memcpy(output + position + nSplitPos + nSplit, pBuff + nSplitPos + nSplit, inputLength);
			position += inputLength;
		}
	}
	/* return position - 1; */     /* position contains a first position of buffer */
	return position;
}
int join_ReadFileSingleRow(struct join_t* join, int nF, struct file_t* file, int* nLR, unsigned char* szBuffRek)
{
	unsigned char* pData = NULL;
	int nEle = 0;
	int nSkipRead = 0;
	int nLenKey = 0;
	int nLenRek = file->maxLength;
	int bIsFirst = 0;
	if (nF == 0) {
		pData = join->pDataF1;
		nSkipRead = g_nSkipReadF1;
	}
	if (nF == 1) {
		pData = join->pDataF2;
		nSkipRead = g_nSkipReadF2;
	}
	int KeyIsEqual = 0;
	int nNew = 1;
	int nRetCode = 0;
	/* LIBCOB for all files */
	cob_read_next(file->stFileDef, NULL, COB_READ_NEXT);
	/*
	if (atol((char*)file->stFileDef->file_status) != 0) {	    
		if (atol((char*)file->stFileDef->file_status) == 10) {	
			*nLR = 0;
			nRetCode = 1;
		}
		if (atol((char*)file->stFileDef->file_status) > 10) {
			fprintf(stdout,"*GCSORT*S069*ERROR: Cannot read file %s - File Status (%c%c) \n", file_getName(file),
				file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
			exit(GC_RTC_ERROR);
		}
	}
	*/
	switch (atol((char*)file->stFileDef->file_status))
	{
		case 0:
			break;
		case  4:		/* record successfully read, but too short or too long */
			fprintf(stdout,"*GCSORT*S069b*ERROR:record successfully read, but too short or too long. %s - File Status (%c%c)\n", file->stFileDef->assign->data,
				file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
			util_view_numrek();
			exit(GC_RTC_ERROR);	/* Error stop execution */
			break;
		case 10:
			*nLR = 0;
			nRetCode = 1;
		case 71:
			fprintf(stdout,"*GCSORT*S069b*ERROR: Record contains bad character %s - File Status (%c%c)\n", file_getName(file),
				file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
			util_view_numrek();
			exit(GC_RTC_ERROR);	/* Error stop execution */
			break;
		default:
			if (atol((char*)file->stFileDef->file_status) < 10) {
				fprintf(stdout, "*GCSORT*W967a* WARNING : Warning reading file %s - File Status (%c%c) \n", file_getName(file),
					file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
				util_view_numrek();
				nRetCode = 0;
			}
			else
			{
				fprintf(stdout, "*GCSORT*S069b*ERROR: Cannot open file %s - File Status (%c%c)\n", file_getName(file),
					file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
				util_view_numrek();
				exit(GC_RTC_ERROR);
			}
	}

	memset(szBuffRek, 0x20, nLenRek);
	gc_memcpy(szBuffRek, file->stFileDef->record->data, nLenRek);

	*nLR = file->stFileDef->record->size;

	if (nF == 0) {
		g_nSkipReadF1 = nSkipRead;
		join->neleF1 = nEle;
	}
	if (nF == 1) {
		g_nSkipReadF2 = nSkipRead;
		join->neleF2 = nEle;
	}
	return nRetCode;
}

/*
	Read input file and store records into pData area (F1 -> p1->pDataF1 or F2 -> p2->dataF2)
	Array record for same key
*/
int join_ReadFile(struct join_t* join, int nF, struct file_t* file, int* descTmp, int* nLR, unsigned char* szBuffRek, int nFirstF1, int nFirstF2)
{
	unsigned char* pData = NULL;
	int nEle = 0;
	int nSkipRead = 0;
	int nLenKey = 0;
	int nLenRek = file->maxLength;
	int bIsFirst = 0;
	if (nF == 0) {
		pData = join->pDataF1;
		nSkipRead = g_nSkipReadF1;
		bIsFirst = nFirstF1;
	}
	if (nF == 1) {
		pData = join->pDataF2;
		nSkipRead = g_nSkipReadF2;
		bIsFirst = nFirstF2;
	}
	int KeyIsEqual = 0;
	unsigned char	szKeyOut[GCSORT_KEY_MAX + SZPOSPNT];
	unsigned char	szKeyOutPrec[GCSORT_KEY_MAX + SZPOSPNT];
	int nNew = 1;
	int nRetCode = 0;
	while (KeyIsEqual == 0) {
		if (bIsFirst == 1) {
			nSkipRead = 0;
		}
		if (nSkipRead == 0) {
			/* LIBCOB for all files */
			cob_read_next(file->stFileDef, NULL, COB_READ_NEXT);
			/*
			if (atol((char*)file->stFileDef->file_status) != 0) {	    
				if (atol((char*)file->stFileDef->file_status) == 10) {	
					*nLR = 0;
					nRetCode = 1; 
				}
				if (atol((char*)file->stFileDef->file_status) > 10) {
					fprintf(stdout,"*GCSORT*S069*ERROR: Cannot read file %s - File Status (%c%c) \n", file_getName(file),
						file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
					exit(GC_RTC_ERROR);
				}
			}
			*/
			switch (atol((char*)file->stFileDef->file_status))
			{
				case 0:
					break;
				case  4:		/* record successfully read, but too short or too long */
					fprintf(stdout,"*GCSORT*S069c*ERROR:record successfully read, but too short or too long. %s - File Status (%c%c)\n", file->stFileDef->assign->data,
						file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
					util_view_numrek();
					exit(GC_RTC_ERROR);	/* Error stop execution */
					break;
				case 10:
					*nLR = 0;
					nRetCode = 1;
				case 71:
					fprintf(stdout,"*GCSORT*S069c*ERROR: Record contains bad character %s - File Status (%c%c)\n", file_getName(file),
						file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
					util_view_numrek();
					exit(GC_RTC_ERROR);	/* Error stop execution */
					break;
				default:
					if (atol((char*)file->stFileDef->file_status) < 10) {
						fprintf(stdout, "*GCSORT*W069a* WARNING : Warning reading file %s - File Status (%c%c) \n", file_getName(file),
							file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
						util_view_numrek();
						nRetCode = 0;
					}
					else
					{
						fprintf(stdout, "*GCSORT*S069c*ERROR: Cannot open file %s - File Status (%c%c)\n", file_getName(file),
							file->stFileDef->file_status[0], file->stFileDef->file_status[1]);
						util_view_numrek();
						exit(GC_RTC_ERROR);
					}
			}
			if (nF == 0)
				join->joinkeysF1->nNumRow++;
			else
				join->joinkeysF2->nNumRow++;
		}
		/* Check EOF */
		if (nRetCode == 1)
			break;
		memset(szBuffRek, 0x20, nLenRek);
		gc_memcpy(szBuffRek, file->stFileDef->record->data, nLenRek);

		*nLR = file->stFileDef->record->size;

		nLenKey = join_GetKeys(szBuffRek, szKeyOut, nF, join);
		if (nNew == 1)
			gc_memcpy(szKeyOutPrec, szKeyOut, nLenKey);
		if (memcmp(szKeyOut, szKeyOutPrec, nLenKey) == 0) {
			gc_memcpy(pData + nEle * nLenRek, szBuffRek, nLenRek);
			nEle++;
		}
		else {
			if (nEle == 0)	/* Data 1 record */
				nEle = 1;
			KeyIsEqual = 1;
		}
		nNew = 0;
		bIsFirst = 0;
		nSkipRead = 0;
	}

	nSkipRead = 1;

	if (nF == 0) {
		g_nSkipReadF1 = nSkipRead;
		join->neleF1 = nEle;
	}
	if (nF == 1) {
		g_nSkipReadF2 = nSkipRead;
		join->neleF2 = nEle;
	}
	return nRetCode;
}
int join_IncludeCondField(int nFile, struct join_t* join, struct condField_t* condfield)
{
	if (nFile == 1)
		join->joinkeysF1->includeCondField = condfield;
	if (nFile == 2)
		join->joinkeysF2->includeCondField = condfield;
	return 0;
}

void join_OmitCondField(int nFile, struct join_t* join, struct condField_t* condfield)
{

	if (nFile == 1)
		join->joinkeysF1->omitCondField = condfield;
	if (nFile == 2)
		join->joinkeysF2->omitCondField = condfield;
	return;
}
void join_fillbuff(int nFile, struct join_t* join, unsigned char* cType, unsigned char* cValue)
{
	char* pch;
	/* check if len = 1 */
	pch = &join->cFill;
	if (memcmp(cType, "X", 1) == 0)
		*pch = (int)strtol(cValue, NULL, 16);
	if (memcmp(cType, "C", 1) == 0)
		memcpy(pch, cValue, 1);

	return;
}
/* Case file F1 Empty */
int join_empty_fileF1(struct job_t* job) {

	char szNameTmp[MAX_RECSIZE];
	int	bIsEof[MAX_FILES_INPUT];
	int	bIsFirstSumFields = 0;
	int	bTempEof = 0;
	int	handleFile[MAX_FILES_INPUT];
	int	nCompare = 1;
	int	nSumEof;
	unsigned int	recordBufferLength;
	int bFirstRound = 0;
	int bIsFirstTimeF1 = 1;
	int bIsFirstTimeF2 = 1;
	int bcheckF1 = 0;
	int bcheckF2 = 0;
	int bIsWrited = 0;
	int byteReadFile[MAX_RECSIZE];
	int k;
	int kj;
	int nIdx1;
	int nIdxFileIn = 0;
	int nLastRead = 0;
	unsigned int nLenInRec = 0;
	int nMaxEle;
	int nMaxFiles = MAX_FILES_INPUT;		/* size of elements */
	int nNumBytes = 0;
	int nPosPtr, nIsEOF;
	int nPosition = 0;
	int nSplitPosPnt = 0;	/* for pospnt   */
	unsigned int nbyteRead;
	int previousRecord = -1;
	int retcode_func = 0;
	int64_t			lPosPnt = 0;
	struct file_t* file;
	struct file_t* Arrayfile_s[MAX_FILES_INPUT];
	unsigned char	szBufKey[MAX_FILES_INPUT][GCSORT_KEY_MAX + SZPOSPNT];	/* key  */
	unsigned char	szBufRek[MAX_FILES_INPUT][GCSORT_MAX_BUFF_REK];	    /* key  */
	unsigned char* ptrBuf[MAX_FILES_INPUT];
	unsigned char* recordBuffer;
	unsigned char* recordBufferF1;
	unsigned char* recordBufferF2;
	unsigned char* szBuffRek;
	unsigned int	nLenRecOut = 0;
	unsigned int	nLenRek = 0;
	int				nFrom = 0;
	int				nLenKey = 0;
	struct join_t* join;
	struct joinunpaired_t* unp;
	int				nSequenceRek = 0;

	join = job->join;

	recordBufferLength = MAX_RECSIZE;

	job->nLenKeys = job_GetLenKeys();
	job->nLastPosKey = job_GetLastPosKeys();

	if (job->nLastPosKey <= NUMCHAREOL)
		job->nLastPosKey = NUMCHAREOL;	/* problem into memchr  */

	for (k = 0; k < MAX_FILES_INPUT; k++)
	{
		byteReadFile[k] = 0;
		Arrayfile_s[k] = NULL;
		memset(szBufKey[k], 0x00, GCSORT_KEY_MAX);
		memset(szBufRek[k], 0x00, GCSORT_MAX_BUFF_REK);
		ptrBuf[k] = 0x00;
	}
	recordBufferLength = MAX_RECSIZE;
	/* onlyfor Line Sequential  */
	if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) || (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUFIXED))
		recordBufferLength = recordBufferLength + 2 + 1;

	recordBuffer = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (recordBuffer == 0)
		fprintf(stdout,"*GCSORT*S862*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

	recordBufferF1 = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (recordBufferF1 == 0)
		fprintf(stdout,"*GCSORT*S862*ERROR: Cannot Allocate recordBufferF1 : %s\n", strerror(errno));

	recordBufferF2 = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (recordBufferF2 == 0)
		fprintf(stdout,"*GCSORT*S862*ERROR: Cannot Allocate recordBufferF2 : %s\n", strerror(errno));

	szBuffRek = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (szBuffRek == 0)
		fprintf(stdout,"*GCSORT*S863*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));

	for (kj = 0; kj < MAX_FILES_INPUT; kj++) {
		byteReadFile[kj] = 0;
		handleFile[kj] = 0;
		bIsEof[kj] = 1;
	}
	/*  new
		Verify segmentation and if last section of file input
	*/
	if (job->outfil != NULL) {
		if (outfil_open_files(job) < 0) {
			retcode_func = -1;
			goto join_empty_fileF1_exit;
		}
	}
	/* If Outfile is not null and OutFil not present or OutFil present without FNAME    */
	if ((job->outputFile != NULL) && (job->nOutFileSameOutFile == 0)) { /* new  */
		cob_open(job->outputFile->stFileDef, COB_OPEN_OUTPUT, 0, NULL);
		if (atol((char*)job->outputFile->stFileDef->file_status) != 0) {
			fprintf(stdout,"*GCSORT*S865*ERROR: Cannot open file %s - File Status (%c%c)\n", file_getName(job->outputFile),
				job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
			retcode_func = -1;
			goto join_empty_fileF1_exit;
		}
	}

	/* Check unpaired */
	unp = join->joinunpaired;

	/*
	|=========================|===================|============|=================================|
	| Command			      | Join Type		  | Flag	   | Output						     |
	|=========================|===================|============|=================================|
	| not specified			  | Inner join		  | F1=I, F2=I | F1 matched, F2 matched          |
	*/
	if ((unp->cF1 == 'I') && (unp->cF2 == 'I')) {   /* Nothing todo */
		retcode_func = 0;
		goto join_empty_fileF1_exit;
	}
	/*
	|=========================|===================|============|=================================|
	| Command			      | Join Type		  | Flag	   | Output						     |
	|=========================|===================|============|=================================|
	| Unpaired, F1			  | Left outer join   | F1=U, F2=I | F1 all records and F2 matched	 |
	*/
	if ((unp->cF1 == 'U') && (unp->cF2 == 'I')) {  /* Nothing todo */
		retcode_func = 0;
		goto join_empty_fileF1_exit;
	}
	/*
	|=========================|===================|============|=================================|
	| Command			      | Join Type		  | Flag	   | Output						     |
	|=========================|===================|============|=================================|
	| Unpaired, F1, Only      | Unpaired from F1  | F1=O, F2=S | F1 only no matched, F2 Skipped  |
	*/
	if ((unp->cF1 == 'O') && (unp->cF2 == 'S')) {  /* Nothing todo */
		retcode_func = 0;
		goto join_empty_fileF1_exit;
	}

	bFirstRound = 1;
	bIsFirstTimeF1 = 1;
	bIsFirstTimeF2 = 1;
	nLastRead = 0;
	/* Open files for Join */
	nIdx1 = 0;
	nSumEof = 0;
	for (file = job->inputFile; file != NULL; file = file_getNext(file)) {
		strcpy(szNameTmp, file_getName(file));
		/* Save reference for file  */
		Arrayfile_s[nIdx1] = file;
		bIsEof[nIdx1] = 0;
		/* LIBCOB for all files */
		cob_open(Arrayfile_s[nIdx1]->stFileDef, COB_OPEN_INPUT, 0, NULL);
		if (atol((char*)Arrayfile_s[nIdx1]->stFileDef->file_status) != 0) {
			fprintf(stdout,"*GCSORT*S866*ERROR: Cannot open file %s - File Status (%c%c)\n", file_getName(Arrayfile_s[nIdx1]), Arrayfile_s[nIdx1]->stFileDef->file_status[0], Arrayfile_s[nIdx1]->stFileDef->file_status[1]);
			retcode_func = -1;
			goto join_empty_fileF1_exit;
		}
		/* Read a single line  not buffered (join_ReadFileSingleRow)  */
		bIsEof[nIdx1] = join_ReadFileSingleRow(join, nIdx1, Arrayfile_s[nIdx1], &byteReadFile[nIdx1], szBufRek[nIdx1]);

		if (bIsEof[nIdx1] == 0) {
			ptrBuf[nIdx1] = (unsigned char*)szBufRek[nIdx1];
			if (nIdx1 == 0)
				join->joinkeysF1->nNumRow = 1;
			else
				join->joinkeysF2->nNumRow = 1;

		}
		nIdx1++;
		if (nIdx1 > nMaxFiles) {
			fprintf(stderr, "Too many files input for JOIN Actual/Limit: %d/%d\n", nIdx1, nMaxFiles);
			retcode_func = -1;
			goto join_empty_fileF1_exit;
		}
	}
	/* in this point nIdx1 is max for number of files input */

	nIsEOF = 0;
	nPosition = 0;
	nSumEof = 0;
	for (kj = 0; kj < MAX_FILES_INPUT; kj++) {
		nSumEof = nSumEof + bIsEof[kj];
	}

	bFirstRound = 0;

	nMaxEle = MAX_FILES_INPUT;
	if (nIdx1 < MAX_FILES_INPUT)
		nMaxEle = nIdx1;
	nPosPtr = join_IdentifyBuf(ptrBuf, nMaxEle);
	/* Reset counter input  */
	job->recordNumberTotal = 0;

	/* Reset counter output */
	job->recordWriteOutTotal = 0;


	int nCmd = 0;
	int nFirstRound = 1;
	int useRecord = 1;

	while ((nSumEof) < MAX_FILES_INPUT) /*  job->nNumTmpFile)   */
	{
		nLenRecOut = file_getMaxLength(job->outputFile);
		nLastRead = 1;
		nCmd = 0;
		nSequenceRek = 0;
		nFirstRound = 0;

		bIsFirstTimeF1 = 0;
		bIsFirstTimeF2 = 0;

		memset(recordBufferF1, 0x20, job->inputFile->next->maxLength);

		gc_memcpy(recordBufferF2, szBufRek[1], job->inputFile->next->maxLength);
		job->recordNumberTotal++;
		memset(recordBuffer, 0x20, recordBufferLength + nSplitPosPnt);

		nPosPtr = 1;   /* F2 */
		if (bIsEof[nPosPtr] == 0) {
			nbyteRead = byteReadFile[nPosPtr];		/* Number of characters readed by COB_READ */
			nLenRek = nbyteRead;					/* Len of record */
		}
		/* new new new  INCLUDE - OMIT  */
		useRecord = 1;
		if (useRecord == 1 && job->includeCondField != NULL && condField_test(job->includeCondField, (unsigned char*)recordBufferF1 + nSplitPosPnt, job) == FALSE)
			useRecord = 0;
		if (useRecord == 1 && job->omitCondField != NULL && condField_test(job->omitCondField, (unsigned char*)recordBufferF1 + nSplitPosPnt, job) == TRUE)
			useRecord = 0;
		/*  */
		if (useRecord == 1) {
			memset(szBuffRek, 0x20, recordBufferLength);
			/* Fill buffer with fill character ( blank default */
			memset(recordBuffer, join->cFill, join->fileSaveOut->maxLength);
			/* set len output */

			nFrom = 2;  /* F2 */

			nbyteRead = join_reformat(job, recordBufferF1, recordBufferF2, recordBuffer, nSplitPosPnt, nFrom);

			if (job->outrec != NULL) {
				/* check overlay    */
				if (job->outrec->nIsOverlay == 0) {
					memset(szBuffRek, 0x20, recordBufferLength);
					nbyteRead = outrec_copy(job->outrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
					memset(recordBuffer, 0x20, recordBufferLength);  
					memcpy(recordBuffer, szBuffRek, nbyteRead + nSplitPosPnt);
					job->LenCurrRek = nbyteRead;
					nLenRek = nbyteRead;
				}
				else
				{		/* Overlay  */
					memset(szBuffRek, 0x20, recordBufferLength);
					memmove(szBuffRek, recordBuffer, nLenRek + nSplitPosPnt);	/* s.m. 202101 copy input record    */
					nbyteRead = outrec_copy_overlay(job->outrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
					nbyteRead++;
					if (nbyteRead < nLenRek)
						nbyteRead = nLenRek;
					if (recordBufferLength < nbyteRead)
						recordBuffer = (unsigned char*)realloc(recordBuffer, nLenInRec + 1);
					memset(recordBuffer, 0x20, recordBufferLength);  
					memcpy(recordBuffer + nSplitPosPnt, szBuffRek + nSplitPosPnt, nbyteRead);
					job->LenCurrRek = nbyteRead;
					nLenRek = nbyteRead;
				}
			}

			
			if ((nbyteRead > 0) && (job->outfil == NULL)) {
				job_set_area(job, job->outputFile, recordBuffer + nSplitPosPnt, nLenRecOut, nbyteRead);
				cob_write(job->outputFile->stFileDef, job->outputFile->stFileDef->record, job->outputFile->opt, NULL, 0);
				switch (atol((char*)job->outputFile->stFileDef->file_status))
				{
					case 0: 
						break;
					case  4:		/* record successfully read, but too short or too long */
						fprintf(stdout,"*GCSORT*S867*ERROR:record successfully read, but too short or too long. %s - File Status (%c%c)\n", job->outputFile->stFileDef->assign->data,
							job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
						util_view_numrek();
						retcode_func = -1;
						goto join_empty_fileF1_exit;
						break;
					case 71:
						fprintf(stdout,"*GCSORT*S867*ERROR: Record contains bad character %s - File Status (%c%c)\n", file_getName(job->outputFile),
							job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
						util_view_numrek();
						retcode_func = -1;
						goto join_empty_fileF1_exit;
						break;
					default:
						fprintf(stdout,"*GCSORT*S867*ERROR: Cannot write file %s - File Status (%c%c)\n", file_getName(job->outputFile),
							job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
						util_view_numrek();
						retcode_func = -1;
						goto join_empty_fileF1_exit;
				}
				job->recordWriteOutTotal++;
			}
			/* OUTFIL   */
			if ((job->LenCurrRek > 0) && (job->outfil != NULL)) {
				if (outfil_write_buffer(job, recordBuffer, job->LenCurrRek, szBuffRek, nSplitPosPnt) < 0) {
					retcode_func = -1;
					goto join_empty_fileF1_exit;
				}
				job->recordWriteOutTotal++;
			}
		}
		if (bIsEof[nLastRead] == 0) {
			bIsEof[nLastRead] = join_ReadFileSingleRow(join, nLastRead, Arrayfile_s[nLastRead], &byteReadFile[nLastRead], szBufRek[nLastRead]);
			if (bIsEof[nLastRead] == 1) {
				ptrBuf[nLastRead] = 0x00;
				nSumEof = nSumEof + bIsEof[nLastRead];
				join->neleF2 = 0;
			}
			else
				join->joinkeysF2->nNumRow++;
		}
		/* F2 */
		if (join->joinkeysF2->nIsSorted == SORTED) {  /* If file declare sorted, check sequence */
			if (bcheckF2 > 0) {
				nSequenceRek = join_compare_rek(recordBufferF2, szBufRek[1]);
				if (nSequenceRek > 0) {
					fprintf(stdout,"*GCSORT*S828*ERROR: Sequence error for file F2 record: " NUM_FMT_LLD    " - name: %s \n", (long long)join->joinkeysF2->nNumRow, file_getName(job->inputFile->next));
					utl_abend_terminate(SEQUENCE_ERR, 501, ABEND_EXEC);
				}
			}
			bcheckF2 = 1;
		}


	}  /* while */
join_empty_fileF1_exit:
	free(szBuffRek);
	free(recordBuffer);
	free(recordBufferF1);
	free(recordBufferF2);

	for (kj = 0; kj < MAX_HANDLE_TEMPFILE; kj++) {
		if (Arrayfile_s[kj] != NULL) {
			if (Arrayfile_s[kj]->stFileDef != NULL)
				cob_close(Arrayfile_s[kj]->stFileDef, NULL, COB_CLOSE_NORMAL, 0);
		}
	}
	cob_close(job->outputFile->stFileDef, NULL, COB_CLOSE_NORMAL, 0);
	return retcode_func;
}
/* Case file F2 Empty */
int join_empty_fileF2(struct job_t* job) {

	char szNameTmp[MAX_RECSIZE];
	int	bIsEof[MAX_FILES_INPUT];
	int	bIsFirstSumFields = 0;
	int	bTempEof = 0;
	int	handleFile[MAX_FILES_INPUT];
	int	nCompare = 1;
	int	nSumEof;
	unsigned int	recordBufferLength;
	int bFirstRound = 0;
	int bIsFirstTimeF1 = 1;
	int bIsFirstTimeF2 = 1;
	int bcheckF1 = 0;
	int bcheckF2 = 0;
	int bIsWrited = 0;
	int byteReadFile[MAX_RECSIZE];
	int k;
	int kj;
	int nIdx1;
	int nIdxFileIn = 0;
	int nLastRead = 0;
	unsigned int nLenInRec = 0;
	int nMaxEle;
	int nMaxFiles = MAX_FILES_INPUT;		/* size of elements */
	int nNumBytes = 0;
	int nPosPtr, nIsEOF;
	int nPosition = 0;
	int nSplitPosPnt = 0;	/* for pospnt   */
	unsigned int nbyteRead;
	int previousRecord = -1;
	int retcode_func = 0;
	int64_t			lPosPnt = 0;
	struct file_t* file;
	struct file_t* Arrayfile_s[MAX_FILES_INPUT];
	unsigned char	szBufKey[MAX_FILES_INPUT][GCSORT_KEY_MAX + SZPOSPNT];	/* key  */
	unsigned char	szBufRek[MAX_FILES_INPUT][GCSORT_MAX_BUFF_REK];	    /* key  */
	unsigned char* ptrBuf[MAX_FILES_INPUT];
	unsigned char* recordBuffer;
	unsigned char* recordBufferF1;
	unsigned char* recordBufferF2;
	unsigned char* szBuffRek;
	unsigned int	nLenRecOut = 0;
	unsigned int	nLenRek = 0;
	int				nFrom = 0;
	int				nLenKey = 0;
	struct join_t* join;
	struct joinunpaired_t* unp;
	int				useRecord = 1;
	int				nSequenceRek = 0;

	join = job->join;

	recordBufferLength = MAX_RECSIZE;

	job->nLenKeys = job_GetLenKeys();
	job->nLastPosKey = job_GetLastPosKeys();

	if (job->nLastPosKey <= NUMCHAREOL)
		job->nLastPosKey = NUMCHAREOL;	/* problem into memchr  */

	for (k = 0; k < MAX_FILES_INPUT; k++)
	{
		byteReadFile[k] = 0;
		Arrayfile_s[k] = NULL;
		memset(szBufKey[k], 0x00, GCSORT_KEY_MAX);
		memset(szBufRek[k], 0x00, GCSORT_MAX_BUFF_REK);
		ptrBuf[k] = 0x00;
	}
	recordBufferLength = MAX_RECSIZE;
	/* onlyfor Line Sequential  */
	if ((file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUENTIAL) || (file_getOrganization(job->outputFile) == FILE_ORGANIZATION_LINESEQUFIXED))
		recordBufferLength = recordBufferLength + 2 + 1;

	recordBuffer = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (recordBuffer == 0)
		fprintf(stdout,"*GCSORT*S862*ERROR: Cannot Allocate recordBuffer : %s\n", strerror(errno));

	recordBufferF1 = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (recordBufferF1 == 0)
		fprintf(stdout,"*GCSORT*S862*ERROR: Cannot Allocate recordBufferF1 : %s\n", strerror(errno));

	recordBufferF2 = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (recordBufferF2 == 0)
		fprintf(stdout,"*GCSORT*S862*ERROR: Cannot Allocate recordBufferF2 : %s\n", strerror(errno));

	szBuffRek = (unsigned char*)malloc(recordBufferLength + nSplitPosPnt);
	if (szBuffRek == 0)
		fprintf(stdout,"*GCSORT*S864*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));

	for (kj = 0; kj < MAX_FILES_INPUT; kj++) {
		byteReadFile[kj] = 0;
		handleFile[kj] = 0;
		bIsEof[kj] = 1;
	}
	/*  new
		Verify segmentation and if last section of file input
	*/
	if (job->outfil != NULL) {
		if (outfil_open_files(job) < 0) {
			retcode_func = -1;
			goto join_empty_fileF2_exit;
		}
	}
	/* If Outfile is not null and OutFil not present or OutFil present without FNAME    */
	if ((job->outputFile != NULL) && (job->nOutFileSameOutFile == 0)) { /* new  */
		cob_open(job->outputFile->stFileDef, COB_OPEN_OUTPUT, 0, NULL);
		if (atol((char*)job->outputFile->stFileDef->file_status) != 0) {
			fprintf(stdout,"*GCSORT*S865*ERROR: Cannot open file %s - File Status (%c%c)\n", file_getName(job->outputFile),
				job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
			retcode_func = -1;
			goto join_empty_fileF2_exit;
		}
	}

	/* Check unpaired */
	unp = join->joinunpaired;

	/*
	|=========================|===================|============|=================================|
	| Command			      | Join Type		  | Flag	   | Output						     |
	|=========================|===================|============|=================================|
	| not specified			  | Inner join		  | F1=I, F2=I | F1 matched, F2 matched          |
	*/
	if ((unp->cF1 == 'I') && (unp->cF2 == 'I')) {   /* Nothing todo */
		retcode_func = 0;
		goto join_empty_fileF2_exit;
	}
	/*
	|=========================|===================|============|=================================|
	| Command			      | Join Type		  | Flag	   | Output						     |
	|=========================|===================|============|=================================|
	| Unpaired, F2            | Right outer join  | F1=I, F2=U | F1 matched and F2 all records   |
	*/
	if ((unp->cF1 == 'I') && (unp->cF2 == 'U')) {
		retcode_func = 0;
		goto join_empty_fileF2_exit;
	}
	/*
	|=========================|===================|============|=================================|
	| Command			      | Join Type		  | Flag	   | Output						     |
	|=========================|===================|============|=================================|
	| Unpaired, F2, Only      | Unpaired from F2  | F1=S, F2=O | F1 Skipped, F2 only no matched  |
	*/
	if ((unp->cF1 == 'S') && (unp->cF2 == 'O')) {
		retcode_func = 0;
		goto join_empty_fileF2_exit;
	}

	bFirstRound = 1;
	bIsFirstTimeF1 = 1;
	bIsFirstTimeF2 = 1;
	nLastRead = 0;
	/* Open files for Join */
	nIdx1 = 0;
	nSumEof = 0;
	for (file = job->inputFile; file != NULL; file = file_getNext(file)) {
		strcpy(szNameTmp, file_getName(file));
		/* Save reference for file  */
		Arrayfile_s[nIdx1] = file;
		bIsEof[nIdx1] = 0;
		/* LIBCOB for all files */
		cob_open(Arrayfile_s[nIdx1]->stFileDef, COB_OPEN_INPUT, 0, NULL);
		if (atol((char*)Arrayfile_s[nIdx1]->stFileDef->file_status) != 0) {
			fprintf(stdout,"*GCSORT*S866*ERROR: Cannot open file %s - File Status (%c%c)\n", file_getName(Arrayfile_s[nIdx1]), Arrayfile_s[nIdx1]->stFileDef->file_status[0], Arrayfile_s[nIdx1]->stFileDef->file_status[1]);
			retcode_func = -1;
			goto join_empty_fileF2_exit;
		}
		/* Read a single line  not buffered (join_ReadFileSingleRow)  */
		bIsEof[nIdx1] = join_ReadFileSingleRow(join, nIdx1, Arrayfile_s[nIdx1], &byteReadFile[nIdx1], szBufRek[nIdx1]);
		if (bIsEof[nIdx1] == 0) {
			ptrBuf[nIdx1] = (unsigned char*)szBufRek[nIdx1];
			if (nIdx1 == 0)
				join->joinkeysF1->nNumRow = 1;
			else
				join->joinkeysF2->nNumRow = 1;

		}
		nIdx1++;
		if (nIdx1 > nMaxFiles) {
			fprintf(stderr, "Too many files input for JOIN Actual/Limit: %d/%d\n", nIdx1, nMaxFiles);
			retcode_func = -1;
			goto join_empty_fileF2_exit;
		}
	}
	/* in this point nIdx1 is max for number of files input */

	nIsEOF = 0;
	nPosition = 0;
	nSumEof = 0;
	for (kj = 0; kj < MAX_FILES_INPUT; kj++) {
		nSumEof = nSumEof + bIsEof[kj];
	}

	bFirstRound = 0;

	nMaxEle = MAX_FILES_INPUT;
	if (nIdx1 < MAX_FILES_INPUT)
		nMaxEle = nIdx1;
	nPosPtr = join_IdentifyBuf(ptrBuf, nMaxEle);
	/* Reset counter input  */
	job->recordNumberTotal = 0;

	/* Reset counter output */
	job->recordWriteOutTotal = 0;


	while ((nSumEof) < MAX_FILES_INPUT) /*  job->nNumTmpFile)   */
	{
		nLenRecOut = file_getMaxLength(job->outputFile);
		nLastRead = 0;

		nSequenceRek = 0;

		bIsFirstTimeF1 = 0;
		bIsFirstTimeF2 = 0;

		memset(recordBufferF2, 0x20, job->inputFile->next->maxLength);

		/* -- */
		/* F1 */
		if (join->joinkeysF1->nIsSorted == SORTED) {  /* If file declare sorted, check sequence */
			if (bcheckF1 > 0) {
				nSequenceRek = join_compare_rek(recordBufferF1, szBufRek[0]);
				if (nSequenceRek > 0) {
					fprintf(stdout,"*GCSORT*S828*ERROR: Sequence error for file F2 record: " NUM_FMT_LLD    " - name: %s \n", (long long)join->joinkeysF2->nNumRow, file_getName(job->inputFile->next));
					utl_abend_terminate(SEQUENCE_ERR, 501, ABEND_EXEC);
				}
			}
			bcheckF2 = 1;
		}
		gc_memcpy(recordBufferF1, szBufRek[0], job->inputFile->next->maxLength);
		job->recordNumberTotal++;
		memset(recordBuffer, 0x20, recordBufferLength + nSplitPosPnt);

		nPosPtr = 0;   /* F1 */
		if (bIsEof[nPosPtr] == 0) {
			nbyteRead = byteReadFile[nPosPtr];		/* Number of characters readed by COB_READ */
			nLenRek = nbyteRead;					/* Len of record */
		}
		/* new new new  INCLUDE - OMIT  */
		useRecord = 1;
		if (useRecord == 1 && job->includeCondField != NULL && condField_test(job->includeCondField, (unsigned char*)recordBufferF1 + nSplitPosPnt, job) == FALSE)
			useRecord = 0;
		if (useRecord == 1 && job->omitCondField != NULL && condField_test(job->omitCondField, (unsigned char*)recordBufferF1 + nSplitPosPnt, job) == TRUE)
			useRecord = 0;
		/*  */
		if (useRecord == 1) {
			memset(szBuffRek, 0x20, recordBufferLength);
			/* Fill buffer with fill character ( blank default */
			memset(recordBuffer, join->cFill, join->fileSaveOut->maxLength);
			/* set len output */

			nFrom = 1;  /* F2 */

			nbyteRead = join_reformat(job, recordBufferF1, recordBufferF2, recordBuffer, nSplitPosPnt, nFrom);
			if (job->outrec != NULL) {
				/* check overlay    */
				if (job->outrec->nIsOverlay == 0) {
					memset(szBuffRek, 0x20, recordBufferLength);
					nbyteRead = outrec_copy(job->outrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
					memset(recordBuffer, 0x20, recordBufferLength);
					memcpy(recordBuffer, szBuffRek, nbyteRead + nSplitPosPnt);
					job->LenCurrRek = nbyteRead;
					nLenRek = nbyteRead;
				}
				else
				{		/* Overlay  */
					memset(szBuffRek, 0x20, recordBufferLength);
					memmove(szBuffRek, recordBuffer, nLenRek + nSplitPosPnt);	/* s.m. 202101 copy input record    */
					nbyteRead = outrec_copy_overlay(job->outrec, szBuffRek, recordBuffer, nLenRecOut, nbyteRead, file_getFormat(job->outputFile), file_GetMF(job->outputFile), job, nSplitPosPnt);
					nbyteRead++;
					if (nbyteRead < nLenRek)
						nbyteRead = nLenRek;
					if (recordBufferLength < nbyteRead)
						recordBuffer = (unsigned char*)realloc(recordBuffer, nLenInRec + 1);
					memset(recordBuffer, 0x20, recordBufferLength);
					memcpy(recordBuffer + nSplitPosPnt, szBuffRek + nSplitPosPnt, nbyteRead);
					job->LenCurrRek = nbyteRead;
					nLenRek = nbyteRead;
				}
			}

			if ((nbyteRead > 0) && (job->outfil == NULL)) {
				job_set_area(job, job->outputFile, recordBuffer + nSplitPosPnt, nLenRecOut, nbyteRead);
				cob_write(job->outputFile->stFileDef, job->outputFile->stFileDef->record, job->outputFile->opt, NULL, 0);
				switch (atol((char*)job->outputFile->stFileDef->file_status))
				{
					case 0: 
						break;
					case  4:		/* record successfully read, but too short or too long */
						fprintf(stdout,"*GCSORT*S867*ERROR:record successfully read, but too short or too long. %s - File Status (%c%c)\n", job->outputFile->stFileDef->assign->data,
							job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
						retcode_func = -1;
						util_view_numrek();
						goto join_empty_fileF2_exit;
						break;
					case 71:
						fprintf(stdout,"*GCSORT*S867*ERROR: Record contains bad character %s - File Status (%c%c)\n", file_getName(job->outputFile),
							job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
						util_view_numrek();
						retcode_func = -1;
						goto join_empty_fileF2_exit;
						break;
					default:
						fprintf(stdout,"*GCSORT*S867*ERROR: Cannot write file %s - File Status (%c%c)\n", file_getName(job->outputFile),
							job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
						util_view_numrek();
						retcode_func = -1;
						goto join_empty_fileF2_exit;
				}
				job->recordWriteOutTotal++;
			}
			/* OUTFIL   */
			if ((job->LenCurrRek > 0) && (job->outfil != NULL)) {
				if (outfil_write_buffer(job, recordBuffer, job->LenCurrRek, szBuffRek, nSplitPosPnt) < 0) {
					retcode_func = -1;
					goto join_empty_fileF2_exit;
				}
				job->recordWriteOutTotal++;
			}
		}
		if (bIsEof[nLastRead] == 0) {
			bIsEof[nLastRead] = join_ReadFileSingleRow(join, nLastRead, Arrayfile_s[nLastRead], &byteReadFile[nLastRead], szBufRek[nLastRead]);
			if (bIsEof[nLastRead] == 1) {
				ptrBuf[nLastRead] = 0x00;
				nSumEof = nSumEof + bIsEof[nLastRead];
				join->neleF1 = 0;
			}
			else
				join->joinkeysF1->nNumRow++;
		}

	}  /* while */
join_empty_fileF2_exit:
	free(szBuffRek);
	free(recordBuffer);
	free(recordBufferF1);
	free(recordBufferF2);

	for (kj = 0; kj < MAX_HANDLE_TEMPFILE; kj++) {
		if (Arrayfile_s[kj] != NULL) {
			if (Arrayfile_s[kj]->stFileDef != NULL)
				cob_close(Arrayfile_s[kj]->stFileDef, NULL, COB_CLOSE_NORMAL, 0);
		}
	}
	cob_close(job->outputFile->stFileDef, NULL, COB_CLOSE_NORMAL, 0);
	return retcode_func;
}

int join_empty_fileF1F2(struct job_t* job) {
	if ((job->outputFile != NULL) && (job->nOutFileSameOutFile == 0)) { /* new  */
		cob_open(job->outputFile->stFileDef, COB_OPEN_OUTPUT, 0, NULL);
		if (atol((char*)job->outputFile->stFileDef->file_status) != 0) {
			fprintf(stdout,"*GCSORT*S365*ERROR: Cannot open file %s - File Status (%c%c)\n", file_getName(job->outputFile),
				job->outputFile->stFileDef->file_status[0], job->outputFile->stFileDef->file_status[1]);
			return -1;
		}
	}
	return 0;
}