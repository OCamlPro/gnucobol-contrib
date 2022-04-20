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

#ifndef JOIN_H_INCLUDED
#define JOIN_H_INCLUDED

#include <stdint.h>
#include <libcob.h>
#include "condfield.h"
#include "fieldvalue.h"
#include "inrec.h"
#include "outrec.h"

#define FILEF1		1
#define FILEF2		2
#define FILETMPF1	3
#define FILETMPF2	4
#define FILETMPOUT	5
#define FILEOUT		6

#define NOTSORTED	0  
#define SORTED		1  


struct joinkeys_t {
	int		nIsSorted;      /* 0 = no, 1 = yes */
	int		nNoseqck;	    /*  1 = No check sequence */
	int     nFileType;      /* 0=Fixed, 1 = Variable */
	int64_t nStopAfter; 	/* Stop after nrek */
	struct sortField_t* joinField;	/* Keys to compare*/
	struct condField_t* includeCondField;
	struct condField_t* omitCondField;
	int64_t	nNumRow;
	int64_t nNumRowReadSort;
	int64_t nNumRowWriteSort;
};
/*
	|=========================|===================|============|=================================|
	|       Command           |   Join Type       |    Flag    |           Output                |
	|=========================|===================|============|=================================|
	| not specified           | Inner join        | F1=I, F2=I | F1 matched, F2 matched          |
	| Unpaired, F1, F2        | Full outer join   | F1=U, F2=U | All records                     |
	| Unpaired                | Full outer join   | F1=U, F2=U | All records                     |
	| Unpaired, F1            | Left outer join   | F1=U, F2=I | F1 all records and F2 matched   |
	| Unpaired, F2            | Right outer join  | F1=I, F2=U | F1 matched and F2 all records   |
	| Unpaired, F1, F2, Only  | Only unpaired     | F1=O, F2=O | F1 no matched, F2 no matched    |
	| Unpaired, Only          | Only unpaired     | F1=O, F2=O | F1 no matched, F2 no matched    |
	| Unpaired, F1, Only      | Unpaired from F1  | F1=O, F2=S | F1 only no matched, F2 Skipped  |
	| Unpaired, F2, Only      | Unpaired from F2  | F1=S, F2=O | F1 Skipped, F2 only no matched  |
	|=========================|===================|============|=================================|
*/
struct joinunpaired_t {
	char cF1;
	char cF2;
};

struct joinreformat_t {
	struct inrec_t* joinreformatrec;		/* similar inrec-outrec */
};


struct join_t {
	char* pNameFileF1;
	char* pNameFileF2;
	char* pNameTmpF1;
	char* pNameTmpF2;
	char* pNameTmpOut;
	char* pNameFileOut;
	struct file_t* fileF1;
	struct file_t* fileF2;
	struct file_t* fileTmpOut;
	struct file_t* fileSaveOut;
	struct file_t* fileSaveF1;
	struct file_t* fileSaveF2;
	struct joinkeys_t*		joinkeysF1;
	struct joinkeys_t*		joinkeysF2;
	struct joinunpaired_t*	joinunpaired;
	struct joinreformat_t*	joinreformat;
	struct sortField_t*		outsortField;	/* sort field for final output not allocated but copy from SORT if presents */
	struct outrec_t* outrec_save;	/* Save outrec for final sort (Not Used in sort in join phases */
	struct outfil_t* outfil_save;
	int64_t	nStopAfterSave;

	/* Save pointer include - omit conditions */
	struct condField_t* includeCondField_save;
	struct condField_t* omitCondField_save;

	int64_t llMaxMemSize;	/* value for single file (F1/F2)*/
	unsigned char* pDataF1;
	int64_t neleF1;
	int64_t nMaxeleF1;
	unsigned char* pDataF2;
	int64_t neleF2;
	int64_t nMaxeleF2;

	char    cFill;			/* character fill record */
};

struct join_t* join_constructor( void );
int join_allocateData(struct join_t* join, struct job_t* job);
void join_destructor(struct join_t* join);
int join_addDefinitionJoin(int njoin, struct sortField_t* sortField);
int join_addQueue(struct sortField_t** sortField, struct sortField_t* sortFieldToAdd);
int join_reformat_addDefinition(struct inrec_t* refo);
int join_addQueueRefo(struct inrec_t** Field, struct inrec_t* FieldToAdd);

int  join_print(struct job_t* job, struct join_t* join);
void join_IsSorted(int nFile, struct join_t* join);

void join_SetReferenceJob(struct join_t* join);

struct inrec_t* join_getNextRefo(struct inrec_t* field);
int join_setUnpaired(int nFile, char cType);
void join_noSeqCk(int nFile, struct join_t* join);
void join_stopAfter(int nFile, struct join_t* join, int64_t nStop);
void join_SetFile(struct join_t* join, int nFile, char* pFile);
int job_joiner(struct job_t* job);
int join_sortFile(struct job_t* job);
int join_join_files(struct job_t* job);
int join_compare_rek(const void* first, const void* second);
int join_unpaired(struct join_t* join, int nPosPtr, int nCmp, unsigned char* rF1, unsigned char* rF2, int lenkey, int* bEofF1, int* bEofF2, int* nSumEof);
int join_GetKeys(unsigned char* szBufferIn, unsigned char* szKeyOut, int nPosPnt, struct join_t* join);
int join_IdentifyBuf(unsigned char** ptrBuf, int nMaxEle);
int join_reformat(struct job_t* job, unsigned char* rF1, unsigned char* rF2, unsigned char* sRek, int nSplitPos, int nFrom);
int join_reformat_copy(struct inrec_t* inrec, unsigned char* inputF1, unsigned char* inputF2, unsigned char* output, struct job_t* job, int nSplitPos, int nFrom);
int join_ReadFile(struct join_t* join, int nF, struct file_t* file, int* descTmp, int* nLR, unsigned char* szBuffRek, int nFirstF1, int nFirstF2);
int join_ReadFileSingleRow(struct join_t* join, int nF, struct file_t* file, int* nLR, unsigned char* szBuffRek);
int join_IncludeCondField(int nFile, struct join_t* join, struct condField_t* condfield);
void join_OmitCondField(int nFile, struct join_t* join, struct condField_t* condfield);
void join_fillbuff(int nFile, struct join_t* join, unsigned char* cType, unsigned char* cValue);
int join_empty_fileF1(struct job_t* job);
int join_empty_fileF2(struct job_t* job);
int join_empty_fileF1F2(struct job_t* job);
int join_F1_read(void);
int join_F1_write(void);
int join_F2_read(void);
int join_F2_write(void);



#endif /* JOIN_H_INCLUDED   */
