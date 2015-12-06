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
#include "job.h"
#include "inrec.h"
#include "fieldvalue.h"
#include "utils.h"


struct inrec_t *inrec_constructor_range(int position, int length) {
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
	inrec->type=INREC_TYPE_RANGE;
	inrec->range.position=position-1;
	inrec->range.length=length;
	inrec->next=NULL;
	return inrec;
}
struct inrec_t *inrec_constructor_change_position(int position, struct fieldValue_t *fieldValue) {
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
	inrec->type=INREC_TYPE_CHANGE_POSITION;
	inrec->change_position.position=position;
	inrec->change_position.fieldValue=fieldValue;
	inrec->next=NULL;
	return inrec;
}
struct inrec_t *inrec_constructor_change(struct fieldValue_t *fieldValue) {
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
	inrec->type=INREC_TYPE_CHANGE;
	inrec->change.fieldValue=fieldValue;
	inrec->next=NULL;
	return inrec;
}
struct inrec_t *inrec_constructor_range_position(int posAbsRec, int position, int length) {
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
	inrec->type=INREC_TYPE_RANGE_POSITION;
	inrec->range_position.posAbsRec=posAbsRec;		// position rec out (start from posAbsRec
	inrec->range_position.position=position-1;
	inrec->range_position.length=length;
	inrec->next=NULL;
	return inrec;
}

// syntax nn:X
// Example 80:X  padding record with blank for max 80 bytes 
// Deve tener conto dell'ultima posizione utilizzata dei campi per il padding a 80 crt con blank
//
// CONTROLLO formato  nnnnX  oppure nnnZ
// attenzione 80:X
// attenzion formalismi diversi
struct inrec_t *inrec_constructor_padding(int nAbsPos, unsigned char *chfieldValue, int nPosAbsRec) {
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
	int nDif=0;
	int nsp=0;
	char szVal[12];
	char* pszChar;
	int cChar = ' ';
	pszChar = malloc(4);
	memset(pszChar, 0x00, 4);
	inrec->type=INREC_TYPE_CHANGE;
	nsp = strlen((char*)chfieldValue)-1;
	memset(szVal, 0x00, 12);
	if (nPosAbsRec == -1)
		sprintf(szVal,"%ld%s", (nAbsPos), chfieldValue);
	else
		sprintf(szVal,"%ld%s", (nAbsPos - nPosAbsRec), chfieldValue);
	inrec->change.fieldValue = fieldValue_constructor(szVal, pszChar, TYPE_STRUCT_STD);
	inrec->next=NULL;
	return inrec;
}

struct inrec_t *inrec_constructor_subst(unsigned char *chfieldValue) {
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
	int nj=0;
	int nsp=0;
	char* pVal;
	inrec->type=INREC_TYPE_CHANGE;
	nsp = strlen((char*)chfieldValue)-1;
	pVal = (char*) malloc(2);
	memset(pVal, 0x00, 2);
	if (nsp > 0)
		memcpy(pVal, chfieldValue+nsp, 1);
	inrec->change.fieldValue = fieldValue_constructor((char*)chfieldValue, pVal, TYPE_STRUCT_STD);
	inrec->next=NULL;
	return inrec;
}

struct inrec_t *inrec_constructor_substnchar(int ntimes, unsigned char *chfieldValue) {
	struct inrec_t *inrec=(struct inrec_t *)malloc(sizeof(struct inrec_t));
	inrec->type=INREC_TYPE_CHANGE;
	memset(inrec->change.fieldValue, (int)chfieldValue, ntimes);
	inrec->next=NULL;
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
			if (inrec->change.fieldValue != NULL)		// look nsp
				fieldValue_destructor(inrec->change.fieldValue);
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
			printf("%d,%d",inrec->range.position+1,inrec->range.length);
			break;
		case INREC_TYPE_CHANGE_POSITION:
			printf("%d:",inrec->change_position.position);
			fieldValue_print(inrec->change_position.fieldValue);
			break;
		case INREC_TYPE_CHANGE:
			fieldValue_print(inrec->change.fieldValue);
			break;
		case INREC_TYPE_RANGE_POSITION:
			printf("%d:%d,%d",inrec->range_position.posAbsRec, inrec->range_position.position+1, inrec->range_position.length);
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
		case INREC_TYPE_RANGE_POSITION:
				length+=o->range_position.length;
				break;
			default:
				break;
		}
	}
	return length;
}
int inrec_copy(struct inrec_t *inrec, unsigned char *output, unsigned char *input, int outputLength, int inputLength, int nFileFormat, int nIsMF) {
	int position=0;
	int nSplitPos = 0;
	struct inrec_t *i;
	// for File Variable +4 byte position
	if (nFileFormat == FILE_TYPE_VARIABLE)
		nSplitPos = 4;
	if ((nIsMF == 1) && (outputLength < 4096))
		nSplitPos = 2;
	if ((nIsMF == 1) && (outputLength >= 4096))
		nSplitPos = 4;
	//
	for (i=inrec;i!=NULL;i=i->next) {
		switch (i->type) {
			case INREC_TYPE_RANGE:
				memcpy(output+position+nSplitPos, input+i->range.position+nSplitPos, i->range.length);
				position+=i->range.length;
				break;
			case INREC_TYPE_CHANGE_POSITION:
				memcpy(output+position+nSplitPos, fieldValue_getGeneratedValue(i->change_position.fieldValue),fieldValue_getGeneratedLength(i->change_position.fieldValue));
				position+=fieldValue_getGeneratedLength(i->change_position.fieldValue);
				break;
			case INREC_TYPE_CHANGE:
				memcpy(output+position+nSplitPos, fieldValue_getGeneratedValue(i->change.fieldValue),fieldValue_getGeneratedLength(i->change.fieldValue));
				position+=fieldValue_getGeneratedLength(i->change.fieldValue);
				break;
			case INREC_TYPE_RANGE_POSITION:
				memcpy(output+i->range_position.posAbsRec+position+nSplitPos, input+i->range_position.position+nSplitPos, i->range_position.length);
				position+= (i->range_position.posAbsRec+i->range_position.length);
				break;
			default:
				break;
		}
	}
	return position;
}
// int job_addInrec(struct inrec_t *inrec) {
int inrec_addDefinition(struct inrec_t *Inrec) {
	inrec_addQueue(&(globalJob->inrec), Inrec);
	return 0;
}
