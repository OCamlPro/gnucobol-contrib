/*
    Copyright (C) 2016-2020 Sauro Menna
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
#include "job.h"
#include "inrec.h"
#include "fieldvalue.h"
#include "utils.h"
#include "gcsort.h"
#include "gcshare.h"
#include "changefield.h"
#include "join.h"



void inrec_initialize(struct inrec_t* inrec) {
	inrec->nIsOverlay = 0;
	inrec->type = 0;
	inrec->next = NULL;
	inrec->range.position = 0;
	inrec->range.length = 0;
	inrec->range.posAbsRec = 0;
	inrec->range.fieldValue = NULL;
	inrec->range.type = 0;
	inrec->range.changeCmdOpt = NULL;
	inrec->szChangeBufIn = NULL;
	inrec->szChangeBufOut = NULL;
	inrec->joinCmd.nFileJoin = 0;			/*  1=F1, 2=F2 */

}
struct inrec_t *inrec_constructor_range(int position, int length) {
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
    if (inrec != NULL) {
		inrec_initialize(inrec);
	    inrec->type=INREC_TYPE_RANGE;
	    inrec->range.position=position-1;
	    inrec->range.length=length;
	    inrec->next=NULL;
		inrec->changeCmd.changeCmdOpt = NULL;
	}
	return inrec;
}

struct inrec_t* inrec_constructor_range_join(int nField, int position, int length) {
	struct inrec_t* inrec = (struct inrec_t*)malloc(sizeof(struct inrec_t));
	if (inrec != NULL) {
		inrec_initialize(inrec);
		inrec->type = INREC_TYPE_JOIN;
		inrec->joinCmd.position = position - 1;
		inrec->joinCmd.length = length;
		inrec->next = NULL;
		inrec->joinCmd.changeCmdOpt = NULL;
		inrec->joinCmd.nFileJoin = nField;
	}
	return inrec;
}

struct inrec_t *inrec_constructor_change_position(int position, struct fieldValue_t *fieldValue) {
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
    if (inrec != NULL) {
		inrec_initialize(inrec);
		inrec->type=INREC_TYPE_CHANGE_POSITION;
	    inrec->change_position.position=position;
	    inrec->change_position.fieldValue=fieldValue;
	    inrec->next=NULL;
		inrec->changeCmd.changeCmdOpt = NULL;
	}
	return inrec;
}
struct inrec_t *inrec_constructor_change(struct fieldValue_t *fieldValue) {
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
    if (inrec != NULL) {
		inrec_initialize(inrec);
		inrec->type=INREC_TYPE_CHANGE;
	    inrec->change.fieldValue=fieldValue;
	    inrec->change.posAbsRec = -1;
	    inrec->change.type = 0x00;
	    inrec->next=NULL;
		inrec->changeCmd.changeCmdOpt = NULL;
	}
	return inrec;
}
/*
* 
*/
struct inrec_t *inrec_constructor_range_position(int posAbsRec, int position, int length) {
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
    if (inrec != NULL) {
		inrec_initialize(inrec);
		inrec->type=INREC_TYPE_RANGE_POSITION;
	    inrec->range_position.posAbsRec=posAbsRec-1;		/* position rec out (start from posAbsRec   */
	    inrec->range_position.position=position-1;
	    inrec->range_position.length=length;
	    inrec->next=NULL;
		inrec->changeCmd.changeCmdOpt = NULL;
	}
	return inrec;
}

/*
   syntax nn:X
   Example 80:X  padding record with blank for max 80 bytes 
   Deve tener conto dell'ultima posizione utilizzata dei campi per il padding a 80 crt con blank
  
   CONTROLLO formato  nnnnX  oppure nnnZ
   attenzione 80:X
   attenzione formalismi diversi
*/
struct inrec_t *inrec_constructor_padding(int nAbsPos, unsigned char *chfieldValue, int nPosAbsRec) {
	int nDif=0;
	int nsp=0;
	char szVal[12];
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
    if (inrec != NULL) {
		inrec_initialize(inrec);
		inrec->type=INREC_TYPE_CHANGE;
	    memset(szVal, 0x00, 12);
	    if (nPosAbsRec <= 0)
		    sprintf((char*) szVal,"%05d", (nAbsPos));
	    else
		    if (nAbsPos > nPosAbsRec)
			    sprintf((char*) szVal,"%05d", (nAbsPos - nPosAbsRec));
		    else
    /* this is error because abs position is < of current position of field */
            {
                fprintf(stderr,"*GCSORT*S400*ERROR: absolute position %d is minor of current position of field %d\n",
                nAbsPos, nPosAbsRec+1);
                exit(GC_RTC_ERROR);
            }
	    inrec->change.fieldValue = fieldValue_constr_newF((char*) chfieldValue, szVal, TYPE_STRUCT_STD, 0);
	    inrec->change.posAbsRec = nAbsPos;
	    inrec->change.type = *chfieldValue;
	    inrec->next=NULL;
		inrec->changeCmd.changeCmdOpt = NULL;
	}
	return inrec;
}

struct inrec_t *inrec_constructor_subst(unsigned char *chfieldValue) {
	int nj=0;
	int nsp=0;
	char szSubstType[10];
	char szSubstValue[10];
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
    if (inrec != NULL) {
		inrec_initialize(inrec);
		inrec->type=INREC_TYPE_CHANGE;
	    nsp = strlen((char*)chfieldValue)-1;
	    memset(szSubstValue, 0x00, 10);
	    memset(szSubstType, 0x00,  2);
	    memcpy(szSubstValue, chfieldValue, nsp);
		memcpy((char*)szSubstValue, chfieldValue, nsp);
	    memcpy(szSubstType, (char*)chfieldValue+nsp, 1);	/* Type */
		/* check if len = 1 */
		if (nsp == 0) {
			if (szSubstType[0] == 'X')
				szSubstValue[0] = ' ';
			if (szSubstType[0] == 'Z')
				szSubstValue[0] = '0';
		}
	    inrec->change.fieldValue = fieldValue_constr_newF((char*)szSubstType, (char*)szSubstValue, TYPE_STRUCT_STD, 0);
	    inrec->change.posAbsRec = -2;	/* For print    */
	    inrec->change.type = 0x00;
	    inrec->next=NULL;
		inrec->changeCmd.changeCmdOpt = NULL;
	}
	return inrec;
}

struct inrec_t* inrec_constructor_possubstnchar(int npos, unsigned char* ntch, unsigned char* chfieldValue) {
	struct inrec_t* inrec = (struct inrec_t*)malloc(sizeof(struct inrec_t));
	if (inrec != NULL) {
		inrec_initialize(inrec);
		inrec->type = INREC_TYPE_CHANGE_ABSPOS;     /*  INREC_TYPE_CHANGE;  */
		inrec->change.fieldValue = fieldValue_constructor((char*)ntch, (char*)chfieldValue, TYPE_STRUCT_STD, 0);
		inrec->change.posAbsRec = npos - 1;     /* ?? -1;   */
		inrec->change.type = 0x00;
		inrec->next = NULL;
		inrec->changeCmd.changeCmdOpt = NULL;
	}
	return inrec;
}


struct inrec_t *inrec_constructor_substnchar(unsigned char* ntch, unsigned char *chfieldValue) {
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
    if (inrec != NULL) {
		inrec_initialize(inrec);
		inrec->type=INREC_TYPE_CHANGE;
	    inrec->change.fieldValue = fieldValue_constructor((char*)ntch, (char*)chfieldValue, TYPE_STRUCT_STD, 0);
	    inrec->change.posAbsRec = -2;   /* ?? -1;   */
	    inrec->change.type = 0x00;
	    inrec->next=NULL;
		inrec->changeCmd.changeCmdOpt = NULL;
	}
	return inrec;
}

void inrec_destructor(struct inrec_t *inrec) {
	switch (inrec->type) {
		case INREC_TYPE_RANGE:
			break;
		case INREC_TYPE_CHANGE_POSITION:
			if (inrec->change_position.fieldValue != NULL)
				fieldValue_destructor(inrec->change_position.fieldValue);
			break;
		case INREC_TYPE_CHANGE:
		case INREC_TYPE_CHANGE_ABSPOS:
			if (inrec->change.fieldValue != NULL)		/* look nsp */
				fieldValue_destructor(inrec->change.fieldValue);
			break;
		case INREC_TYPE_CHANGE_CMDOPT:
			if (inrec->changeCmd.changeCmdOpt != NULL) {
				change_destructor(inrec->changeCmd.changeCmdOpt);
				free(inrec->szChangeBufIn);
				free(inrec->szChangeBufOut);
			}
		case INREC_TYPE_JOIN:
			break;
        default:
			break;
	}
	free(inrec);
}
int inrec_addQueue(struct inrec_t **inrec,struct inrec_t *inrec_add) {
	struct inrec_t *o;
	if (*inrec==NULL) {
		*inrec=inrec_add;
	} else {
		for (o=*inrec;o->next!=NULL;o=o->next);
		o->next=inrec_add;
	}
	return 0;
}
struct inrec_t *inrec_getNext(struct inrec_t *inrec) {
	return inrec->next;
}
int inrec_print(struct inrec_t *inrec) {
	switch (inrec->type) {
		case INREC_TYPE_RANGE:
			fprintf(stdout, "%d,%d",inrec->range.position+1,inrec->range.length);
			break;
		case INREC_TYPE_CHANGE_POSITION:
			fprintf(stdout, "%d:",inrec->change_position.position);
			fieldValue_print(inrec->change_position.fieldValue);
			break;
		case INREC_TYPE_CHANGE:
			if (inrec->change.posAbsRec == -1) 
				fieldValue_print(inrec->change.fieldValue);
			else
				if (inrec->change.posAbsRec == -2) 
					printf("%d%s",inrec->change.fieldValue->occursion,utils_getFieldValueTypeName(inrec->change.type));
				else
					printf("%d:%c",inrec->change.posAbsRec,inrec->change.type);
			break;
		case INREC_TYPE_CHANGE_ABSPOS:
			fprintf(stdout, "%d:", inrec->change.posAbsRec);
			fieldValue_print(inrec->change_position.fieldValue);
			break;
		case INREC_TYPE_RANGE_POSITION:
			fprintf(stdout, "%d:%d,%d",inrec->range_position.posAbsRec, inrec->range_position.position+1, inrec->range_position.length);
			break;
		case INREC_TYPE_CHANGE_CMDOPT:
			fprintf(stdout, "%d,%d", inrec->range.position + 1, inrec->range.length);
			change_print(inrec->changeCmd.changeCmdOpt);
		case INREC_TYPE_JOIN:
			if (inrec->joinCmd.position == -100)
				fprintf(stdout, "B");
			else
				fprintf(stdout, "%d,%d",inrec->joinCmd.position+1,inrec->joinCmd.length);
			break;
		default:
			break;
	}
	return 0;
}
int inrec_getLength(struct inrec_t *inrec) {
	int length=0;
	struct inrec_t *o;

	for (o=inrec;o!=NULL;o=o->next) {
		switch (o->type) {
			case INREC_TYPE_RANGE:
				length+=o->range.length;
				break;
			case INREC_TYPE_CHANGE_POSITION:
				length+=fieldValue_getGeneratedLength(o->change_position.fieldValue);
				break;
			case INREC_TYPE_CHANGE:
				length+=fieldValue_getGeneratedLength(o->change.fieldValue);
				break;
			case INREC_TYPE_CHANGE_ABSPOS:
				length += o->change.posAbsRec+ fieldValue_getGeneratedLength(o->change.fieldValue);
				break;
			case INREC_TYPE_RANGE_POSITION:
				length+=o->range_position.length;
				break;
			case INREC_TYPE_CHANGE_CMDOPT:
				length += o->changeCmd.changeCmdOpt->vlen;
                break;
			case INREC_TYPE_JOIN:
				length += o->joinCmd.length;
			default:
				break;
		}
	}
	return length;
}
int inrec_copy(struct inrec_t *inrec, unsigned char *output, unsigned char *input, int outputLength, int inputLength, int nFileFormat, int nIsMF, struct job_t* job, int nSplitPos) {
	int position=0;
	int nSplit = 0;
	struct inrec_t *i;
	int nIRangeLen = 0;
	if (nIsMF == 1)  /* EMULATE MFSORT  position is 1 for DFSORT position is +4 */
	if (job_EmuleMFSort() == 2) /* DFSort    0 Normal yes shift, 1 MF no shift  */
	{
		if (nFileFormat == FILE_TYPE_VARIABLE)
			nSplit = -4;		/* Postion */
	}
	for (i=inrec;i!=NULL;i=i->next) {
		switch (i->type) { 
			case INREC_TYPE_RANGE:
				nIRangeLen = i->range.length;
				if (nIRangeLen == -1)		/* outrec pos, -1  (for variable)   */
					nIRangeLen = inputLength - i->range.position - nSplit;
				if ((i->range.position+nSplit+ nIRangeLen) <= inputLength)
					memcpy(output+position+nSplitPos+nSplit, input+i->range.position+nSplitPos+nSplit, nIRangeLen);
				else
					/* copy only chars present in input for max len input   */
					memcpy(output+position+nSplitPos+nSplit, input+i->range.position+nSplitPos+nSplit, abs(inputLength - (i->range.position+nSplit)));
				position+=nIRangeLen;
				break;
			case INREC_TYPE_CHANGE_POSITION:
				memcpy(output+position+nSplitPos+nSplit, fieldValue_getGeneratedValue(i->change_position.fieldValue),fieldValue_getGeneratedLength(i->change_position.fieldValue));
				position+=fieldValue_getGeneratedLength(i->change_position.fieldValue);
				break;
			case INREC_TYPE_CHANGE:
				memcpy(output+position+nSplitPos+nSplit, fieldValue_getGeneratedValue(i->change.fieldValue),fieldValue_getGeneratedLength(i->change.fieldValue));
				position+=fieldValue_getGeneratedLength(i->change.fieldValue);
				break;
				/* new 202012   */
			case INREC_TYPE_CHANGE_ABSPOS:
				/* s.m. 20220215 memcpy(output + i->range.position + nSplitPos + nSplit, fieldValue_getGeneratedValue(i->change.fieldValue), fieldValue_getGeneratedLength(i->change.fieldValue)); */
				/* s.m. 20220215 position = i->range.position + fieldValue_getGeneratedLength(i->change.fieldValue); */
				memcpy(output + i->change.posAbsRec + nSplitPos + nSplit, fieldValue_getGeneratedValue(i->change.fieldValue), fieldValue_getGeneratedLength(i->change.fieldValue));
				position = i->change.posAbsRec + fieldValue_getGeneratedLength(i->change.fieldValue);
				break;
			case INREC_TYPE_RANGE_POSITION:
/* 20160408 record input len */
				nIRangeLen = i->range_position.length;
				if (nIRangeLen == -1)		/* outrec pos, -1  (for variable) */
					nIRangeLen = inputLength - i->range_position.position - nSplit;
				
				if ((i->range_position.position+nSplitPos+nSplit+nIRangeLen) <= inputLength)
                    memcpy(output+i->range_position.posAbsRec+nSplitPos+nSplit, input+i->range_position.position+nSplitPos+nSplit, nIRangeLen);
				else
					/* copy only char present in input for max len input    */
                    memcpy(output+i->range_position.posAbsRec+nSplitPos+nSplit, input+i->range_position.position+nSplitPos+nSplit, abs(inputLength - (i->range_position.position+nSplit)));
				position = (i->range_position.posAbsRec+nIRangeLen);
				break;
			case INREC_TYPE_CHANGE_CMDOPT:
				nIRangeLen = i->range.length;
				if (nIRangeLen == -1)		/* outrec pos, -1  (for variable)   */
					nIRangeLen = inputLength - i->range.position - nSplit;
				/* Change Option search & replace */
				if (i->changeCmd.changeCmdOpt != NULL) {
					/* Reset buffer in and buffer out */
					memset(i->szChangeBufIn,  0x00, COB_FILE_BUFF);
					memset(i->szChangeBufOut, 0x00, COB_FILE_BUFF);
					gc_memcpy(i->szChangeBufIn, input + i->range.position + nSplitPos + nSplit, nIRangeLen);
					/* Nomatch with pos, len */
					if (i->changeCmd.changeCmdOpt->nomatchLen > 0) {
						memset(i->szChangeBufNoMatch, 0x00, COB_FILE_BUFF);
						gc_memcpy(i->szChangeBufNoMatch, input + i->changeCmd.changeCmdOpt->nomatchPos + nSplitPos + nSplit, i->changeCmd.changeCmdOpt->nomatchLen);
					}

					if (change_search_replace(i->changeCmd.changeCmdOpt, i->szChangeBufIn, i->szChangeBufOut, nIRangeLen, i->changeCmd.changeCmdOpt->vlen, input + nSplitPos) == 0) { /* False */
						/* If NOMATCH not present  ABEND (Look manual DFSORT)*/
						if (i->changeCmd.changeCmdOpt->sNoMatch == NULL) {
							if (i->changeCmd.changeCmdOpt->nomatchLen == 0)
								utl_abend_terminate(NOMATCH_FOUND, 536, 16);
							else
								/* NOMATCH with pos, len */
								gc_memcpy(i->szChangeBufOut, i->szChangeBufNoMatch, i->changeCmd.changeCmdOpt->vlen);
						} else
						/* Force NOMATCH*/
							gc_memcpy(i->szChangeBufOut, i->changeCmd.changeCmdOpt->sNoMatch->generated_value, i->changeCmd.changeCmdOpt->vlen);
					}
					/* Force len output */
					nIRangeLen = i->changeCmd.changeCmdOpt->vlen;
					if ((i->range.position + nSplit + nIRangeLen) <= inputLength)
						memcpy(output + position + nSplitPos + nSplit, i->szChangeBufOut, nIRangeLen);
					else
						memcpy(output + position + nSplitPos + nSplit, i->szChangeBufOut, nIRangeLen);
					/* copy only chars present in input for max len input   */
						/* memcpy(output + position + nSplitPos + nSplit, i->szChangeBufOut + i->range.position + nSplitPos + nSplit, abs(inputLength - (i->range.position + nSplit)));*/
					position += nIRangeLen;
				}
				else
				{
					utl_abend_terminate(CHANGE_ERR, 16, ABEND_EXEC);
				}
			break;			
			default:
				break;
		}
	}
	/* return position - 1; */     /* position contains a first position of buffer */
	return position; 
}
/* 20201211 -  OVERLAY INREC    */
int inrec_copy_overlay(struct inrec_t* inrec, unsigned char* output, unsigned char* input, int outputLength, int inputLength, int nFileFormat, int nIsMF, struct job_t* job, int nSplitPos) {
	int position = 0;
	int nSplit = 0;
	struct inrec_t* i;
	int nIRangeLen = 0;
	if (nIsMF == 1)                 /* EMUALTE MFSORT  position is 1 for DFSORT position is +4  */
		if (job_EmuleMFSort() == 2) /* DFSort    0 Normal yes shift, 1 MF no shift            */
		{
			if (nFileFormat == FILE_TYPE_VARIABLE)
				nSplit = -4;		/* Position */
		}
	for (i = inrec; i != NULL; i = i->next) {
		switch (i->type) {
		case INREC_TYPE_RANGE:
			nIRangeLen = i->range.length;
			if (nIRangeLen == -1)		/* outrec pos, -1  (for variable)   */
				nIRangeLen = inputLength - i->range.position - nSplit;
			if ((i->range.position + nSplit + nIRangeLen) <= inputLength)
				memcpy(output + position + nSplitPos + nSplit, input + i->range.position + nSplitPos + nSplit, nIRangeLen);
			else
				/* copy only chars present in input for max len input   */
				memcpy(output + position + nSplitPos + nSplit, input + i->range.position + nSplitPos + nSplit, abs(inputLength - (i->range.position + nSplit)));
			position += nIRangeLen;
			break;
		case INREC_TYPE_CHANGE_POSITION:
			memcpy(output + position + nSplitPos + nSplit, fieldValue_getGeneratedValue(i->change_position.fieldValue), fieldValue_getGeneratedLength(i->change_position.fieldValue));
			position += fieldValue_getGeneratedLength(i->change_position.fieldValue);
			break;
		case INREC_TYPE_CHANGE:
			memcpy(output + position + nSplitPos + nSplit, fieldValue_getGeneratedValue(i->change.fieldValue), fieldValue_getGeneratedLength(i->change.fieldValue));
			position += fieldValue_getGeneratedLength(i->change.fieldValue);
			break;
			/* new 202012 */
		case INREC_TYPE_CHANGE_ABSPOS:
			/*   s.m. 20220215 memcpy(output + i->range.position + nSplitPos + nSplit, fieldValue_getGeneratedValue(i->change.fieldValue), fieldValue_getGeneratedLength(i->change.fieldValue)); */
			/*   s.m. 20220215 position = i->range.position + fieldValue_getGeneratedLength(i->change.fieldValue); */
			memcpy(output + i->change.posAbsRec + nSplitPos + nSplit, fieldValue_getGeneratedValue(i->change.fieldValue), fieldValue_getGeneratedLength(i->change.fieldValue));
			position = i->change.posAbsRec + fieldValue_getGeneratedLength(i->change.fieldValue);
			break;
		case INREC_TYPE_RANGE_POSITION:
			/* 20160408 record input len    */
			nIRangeLen = i->range_position.length;
			if (nIRangeLen == -1)		/* outrec pos, -1  (for variable)   */
				nIRangeLen = inputLength - i->range_position.position - nSplit;

			if ((i->range_position.position + nSplitPos + nSplit + nIRangeLen) <= inputLength)
				memcpy(output + i->range_position.posAbsRec + nSplitPos + nSplit, input + i->range_position.position + nSplitPos + nSplit, nIRangeLen);
			else
				/* copy only char present in input for max len input    */
				memcpy(output + i->range_position.posAbsRec + nSplitPos + nSplit, input + i->range_position.position + nSplitPos + nSplit, abs(inputLength - (i->range_position.position + nSplit)));
			position = (i->range_position.posAbsRec + nIRangeLen);
			break;
		case INREC_TYPE_CHANGE_CMDOPT:
			nIRangeLen = i->range.length;
			if (nIRangeLen == -1)		/* outrec pos, -1  (for variable)   */
				nIRangeLen = inputLength - i->range.position - nSplit;
			/* Change Option search & replace */
			if (i->changeCmd.changeCmdOpt != NULL) {
				/* Reset buffer in and buffer out */
				memset(i->szChangeBufIn, 0x00, COB_FILE_BUFF);
				memset(i->szChangeBufOut, 0x00, COB_FILE_BUFF);
				gc_memcpy(i->szChangeBufIn, input + i->range.position + nSplitPos + nSplit, nIRangeLen);
				/* Nomatch with pos, len */
				if (i->changeCmd.changeCmdOpt->nomatchLen > 0) {
					memset(i->szChangeBufNoMatch, 0x00, COB_FILE_BUFF);
					gc_memcpy(i->szChangeBufNoMatch, input + i->changeCmd.changeCmdOpt->nomatchPos + nSplitPos + nSplit, i->changeCmd.changeCmdOpt->nomatchLen);
				}

				if (change_search_replace(i->changeCmd.changeCmdOpt, i->szChangeBufIn, i->szChangeBufOut, nIRangeLen, i->changeCmd.changeCmdOpt->vlen, input + nSplitPos) == 0) { /* False */
					/* If NOMATCH not present  ABEND (Look manual DFSORT)*/
					if (i->changeCmd.changeCmdOpt->sNoMatch == NULL) {
						if (i->changeCmd.changeCmdOpt->nomatchLen == 0)
							utl_abend_terminate(NOMATCH_FOUND, 536, 16);
						else
							/* NOMATCH with pos, len */
							gc_memcpy(i->szChangeBufOut, i->szChangeBufNoMatch, i->changeCmd.changeCmdOpt->vlen);
					} else
						/* Force NOMATCH*/
						gc_memcpy(i->szChangeBufOut, i->changeCmd.changeCmdOpt->sNoMatch->generated_value, i->changeCmd.changeCmdOpt->vlen);
				}
				/* Force len output */
				nIRangeLen = i->changeCmd.changeCmdOpt->vlen;
				if ((i->range.position + nSplit + nIRangeLen) <= inputLength)
					memcpy(output + position + nSplitPos + nSplit, i->szChangeBufOut, nIRangeLen);
				else
					/* copy only chars present in input for max len input   */
					memcpy(output + position + nSplitPos + nSplit, i->szChangeBufOut, nIRangeLen);
				position += nIRangeLen;
			}
			else
			{
				utl_abend_terminate(CHANGE_ERR, 16, ABEND_EXEC);
			}
		break;
		default:
			break;
		}
	}
	/* return position - 1;*/  /* position contains a first position of buffer   */
	return position;
}

int inrec_addDefinition(struct inrec_t *Inrec) {
	inrec_addQueue(&(globalJob->inrec), Inrec);
	return 0;
}
/* Set Overlay flag */
int inrec_SetOverlay(struct inrec_t* Inrec, int nOverlay) {
	struct inrec_t* inrec;
	for (inrec = globalJob->inrec; inrec != NULL; inrec = inrec_getNext(inrec)) {
	/* -->> force value for all elements	if (Inrec == inrec) {   */
			inrec->nIsOverlay= nOverlay;
	/* -->> force value for all elements		break;  */
	/* -->> force value for all elements	}   */
	}
	return 0;
}
int inrec_SetChangeCmdOpt(struct inrec_t* inrec, struct change_t* chg)
{
	if ((inrec != NULL) && (chg != NULL)) {
		inrec->changeCmd.changeCmdOpt = chg;
		/* Set type 5 to change CMD Option */
		inrec->type = INREC_TYPE_CHANGE_CMDOPT;
		/* Allocate field to compare values CHANGE */
		inrec->szChangeBufIn = malloc(COB_FILE_BUFF);
		inrec->szChangeBufOut = malloc(COB_FILE_BUFF);
	}
	return 0;
}
