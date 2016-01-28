/*
 *  Copyright (C) 2009 Cedric ISSALY
 *  Copyright (C) 2016 Sauro Menna
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
#include "fieldvalue.h"
#include "utils.h"
#include "job.h"
#include "outrec.h"


struct outrec_t *outrec_constructor_range(int position, int length) {
	struct outrec_t *outrec=(struct outrec_t *)malloc(sizeof(struct outrec_t));
	outrec->type=OUTREC_TYPE_RANGE;
	outrec->range.position=position-1;
	outrec->range.length=length;
	outrec->next=NULL;
	return outrec;
}
struct outrec_t *outrec_constructor_change_position(int position, struct fieldValue_t *fieldValue) {
	struct outrec_t *outrec=(struct outrec_t *)malloc(sizeof(struct outrec_t));
	outrec->type=OUTREC_TYPE_CHANGE_POSITION;
	outrec->change_position.position=position-1;
	outrec->change_position.fieldValue=fieldValue;
	outrec->next=NULL;
	return outrec;
}
struct outrec_t *outrec_constructor_change(struct fieldValue_t *fieldValue) {
	struct outrec_t *outrec=(struct outrec_t *)malloc(sizeof(struct outrec_t));
	outrec->type=OUTREC_TYPE_CHANGE;
	outrec->change.fieldValue=fieldValue;
	outrec->change.posAbsRec = -1;
	outrec->change.type = 0x00;
	outrec->next=NULL;
	return outrec;
}
struct outrec_t *outrec_constructor_range_position(int posAbsRec, int position, int length) {
	struct outrec_t *outrec=(struct outrec_t *)malloc(sizeof(struct outrec_t));
	outrec->type=OUTREC_TYPE_RANGE_POSITION;
	outrec->range_position.posAbsRec=posAbsRec-1;		// position rec out (start from posAbsRec
	outrec->range_position.position=position-1;
	outrec->range_position.length=length;
	outrec->next=NULL;
	return outrec;
}
struct outrec_t *outrec_constructor_padding(int nAbsPos, unsigned char *chfieldValue, int nPosAbsRec) {
	struct outrec_t *outrec=(struct outrec_t *)malloc(sizeof(struct outrec_t));
	int nDif=0;
	int nsp=0;
	char szVal[12];
	outrec->type=OUTREC_TYPE_CHANGE;
	memset(szVal, 0x00, 12);
	if (nPosAbsRec == 0)
		sprintf((char*) szVal,"%05ld", (nAbsPos));
	else
		if ((nAbsPos-1) > nPosAbsRec)
			sprintf((char*) szVal,"%05ld", (nAbsPos-1 - nPosAbsRec + 1 ));
		else
			sprintf((char*) szVal,"%05ld", (nPosAbsRec - nAbsPos-1 + 1));
	outrec->change.fieldValue = fieldValue_constructor2((char*) chfieldValue, szVal, TYPE_STRUCT_STD);
	outrec->change.posAbsRec = nAbsPos;
	outrec->change.type = *chfieldValue;
	outrec->next=NULL;
	return outrec;
}

/*
struct outrec_t *outrec_constructor_padding(struct fieldValue_t *fieldValue) {
	struct outrec_t *outrec=(struct outrec_t *)malloc(sizeof(struct outrec_t));
	outrec->type=OUTREC_TYPE_PAD_POSITION;
	outrec->pad_position.fieldValue = fieldValue;
	outrec->pad_position.posAbsRec=0;
	outrec->next=NULL;
	return outrec;
}
*/
// 
struct outrec_t *outrec_constructor_subst(unsigned char *chfieldValue) {
	struct outrec_t *outrec=(struct outrec_t *)malloc(sizeof(struct outrec_t));
	int nj=0;
	int nsp=0;
	char szSubstType[10];
	char szSubstValue[10];
	outrec->type=OUTREC_TYPE_CHANGE;
	nsp = strlen((char*)chfieldValue)-1;
	memset(szSubstValue, 0x00, nsp+1);
	memset(szSubstType, 0x00,  2);
	memcpy(szSubstValue, chfieldValue, nsp);
	
	memcpy((char*)szSubstValue, chfieldValue, nsp);
	memcpy(szSubstType, (char*)chfieldValue+nsp, 1);	// TYpe
	outrec->change.fieldValue = fieldValue_constructor2((char*)szSubstType, (char*)szSubstValue, TYPE_STRUCT_STD);
	outrec->change.posAbsRec = -2;	// For print
	outrec->change.type = 0x00;

	outrec->next=NULL;
	//free(pVal);
	return outrec;
}

struct outrec_t *outrec_constructor_substnchar(int ntimes, unsigned char *chfieldValue) {
	struct outrec_t *outrec=(struct outrec_t *)malloc(sizeof(struct outrec_t));
	outrec->type=OUTREC_TYPE_CHANGE;
	//-->>memset(outrec->change.fieldValue, (int) chfieldValue, ntimes);
	memset(outrec->change.fieldValue, (int) (*chfieldValue), ntimes);
	outrec->change.posAbsRec = -1;
	outrec->change.type = 0x00;
	outrec->next=NULL;
	return outrec;
}

void outrec_destructor(struct outrec_t *outrec) {
	switch (outrec->type) {
		case OUTREC_TYPE_RANGE:
			break;
		case OUTREC_TYPE_CHANGE_POSITION:
			if (outrec->change_position.fieldValue != NULL) {
				fieldValue_destructor(outrec->change.fieldValue);
			}
			break;
		case OUTREC_TYPE_CHANGE:
			if (outrec->change.fieldValue != NULL) {
				fieldValue_destructor(outrec->change.fieldValue);
			}
			break;
		default:
			break;
	}
	free(outrec);
}


int outrec_addQueue(struct outrec_t **outrec,struct outrec_t *outrec_add) {
	struct outrec_t *o;
	if (*outrec==NULL) {
		*outrec=outrec_add;
	} else {
		for (o=*outrec;o->next!=NULL;o=o->next);
		o->next=outrec_add;
	}
	return 0;
}
struct outrec_t *outrec_getNext(struct outrec_t *outrec) {
	return outrec->next;
}
int outrec_print(struct outrec_t *outrec) {
	switch (outrec->type) {
		case OUTREC_TYPE_RANGE:
			printf("%d,%d",outrec->range.position+1,outrec->range.length);
			break;
		case OUTREC_TYPE_CHANGE_POSITION:
			printf("%d:",outrec->change_position.position+1);
			fieldValue_print(outrec->change_position.fieldValue);
			break;
		case OUTREC_TYPE_CHANGE:
			if (outrec->change.posAbsRec == -1) 
				fieldValue_print(outrec->change.fieldValue);
			else
				if (outrec->change.posAbsRec == -2) 
					printf("%d%s",outrec->change.fieldValue->occursion,utils_getFieldValueTypeName(outrec->change.type));
				else
					printf("%d:%c",outrec->change.posAbsRec,outrec->change.type);
			break;
		case OUTREC_TYPE_RANGE_POSITION:
			printf("%d:%d,%d",outrec->range_position.posAbsRec+1, outrec->range_position.position+1, outrec->range_position.length);
			break;
		default:
			break;
	}
	return 0;
}
int outrec_getLength(struct outrec_t *outrec) {
	int length=0;
	struct outrec_t *o;

	for (o=outrec;o!=NULL;o=o->next) {
		switch (o->type) {
			case OUTREC_TYPE_RANGE:
				length+=o->range.length;
				break;
			case OUTREC_TYPE_CHANGE_POSITION:
				length+=fieldValue_getGeneratedLength(o->change_position.fieldValue);
				break;
			case OUTREC_TYPE_CHANGE:
				length+=fieldValue_getGeneratedLength(o->change.fieldValue);
				break;
			case OUTREC_TYPE_RANGE_POSITION:
				length+=o->range_position.length;
				break;
			default:
				break;
		}
	}
	return length;
}
int outrec_copy(struct outrec_t *outrec, unsigned char *output, unsigned char *input, int outputLength, int inputLength, int nFileFormat, int nIsMF, struct job_t* job, int nSplitPos) {
	int position=0;
	int nSplit = 0;
	struct outrec_t *o;
	int nORangeLen = 0;
	if (nIsMF == 1)  // EMUALTE MFSORT  position is 1 for DFSORT position is +4 
	if (job_EmuleMFSort() == 2) // DFSort   // 0 Normal yes shift, 1 MF no shift
	{
		if (nFileFormat == FILE_TYPE_VARIABLE)
			nSplit = -4;		// Postion 
	}
	for (o=outrec;o!=NULL;o=o->next) {
		switch (o->type) {
			case OUTREC_TYPE_RANGE:
// 20160408 record input len 
				nORangeLen = o->range.length;
				if (nORangeLen == -1)		// outrec pos, -1  (for variable)
					nORangeLen = inputLength - o->range.position - nSplit;
				if ((o->range.position+nSplit+ nORangeLen) <= inputLength)
					memcpy(output+position+nSplitPos+nSplit, input+o->range.position+nSplitPos+nSplit, nORangeLen);
				else
					// copy only chars present in input for max len input
					memcpy(output+position+nSplitPos+nSplit, input+o->range.position+nSplitPos+nSplit, abs(inputLength - (o->range.position+nSplit)));
				position+=nORangeLen;
				break;
			case OUTREC_TYPE_CHANGE_POSITION:
				memcpy(output+position+nSplitPos+nSplit, fieldValue_getGeneratedValue(o->change_position.fieldValue),fieldValue_getGeneratedLength(o->change_position.fieldValue));
				position+=fieldValue_getGeneratedLength(o->change_position.fieldValue);
				break;
			case OUTREC_TYPE_CHANGE:
				memcpy(output+position+nSplitPos+nSplit, fieldValue_getGeneratedValue(o->change.fieldValue),fieldValue_getGeneratedLength(o->change.fieldValue));
				position+=fieldValue_getGeneratedLength(o->change.fieldValue);
				break;
			case OUTREC_TYPE_RANGE_POSITION:
// 20160408 record input len 
				//-->>nORangeLen = o->range.length;
				nORangeLen = o->range_position.length;
				if (nORangeLen == -1)		// outrec pos, -1  (for variable)
					nORangeLen = inputLength - o->range_position.position - nSplit;
				
				if ((o->range_position.position+nSplitPos+nSplit+nORangeLen) <= inputLength)
					memcpy(output+o->range_position.posAbsRec+position+nSplitPos+nSplit, input+o->range_position.position+nSplitPos+nSplit, nORangeLen);
				else
					// copy only char present in input for max len input
					memcpy(output+o->range_position.posAbsRec+position+nSplitPos+nSplit, input+o->range_position.position+nSplitPos+nSplit, abs(inputLength - (o->range_position.position+nSplit)));
				//position+= (o->range_position.posAbsRec+nORangeLen);
				position = (o->range_position.posAbsRec+nORangeLen);
				break;
			default:
				break;
		}
	}
//	return position;
	return position;  // position contains a first position of buffer
}

int outrec_addDefinition(struct outrec_t *outrec) {
	outrec_addQueue(&(globalJob->outrec), outrec);
	return 0;
}

