/*
    Copyright (C) 2016-2024 Sauro Menna
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
#include "libgcsort.h"

#ifdef _WIN32
	#include <Windows.h>
#endif

#include "sumfield.h"
#include "gcsort.h"
#include "utils.h"
#include "job.h"
#include "gcshare.h"

/* ##-->> s.m. 20201021 typedef cob_field_attr cob_field_attr;  */
/* s.m. 20250110   static const cob_field_attr cob_all_attr = {0x22, 0, 0, 0, NULL};		*/
/* s.m. 20250110   static cob_field cob_all_zero	= {1, (cob_u8_ptr)"0", &cob_all_attr};  */


struct SumField_t *SumField_constructor(int position, int length, int type) 
{

	struct SumField_t *SumField=(struct SumField_t *)malloc(sizeof(struct SumField_t));
    if (SumField != NULL) {
	    SumField->position=position; 
	    SumField->length=length;
	    SumField->type=type;
	    SumField->next=NULL;
	    SumField->pCobField.data=NULL;
	    SumField->pCobField.attr = &SumField->pCobFAttr;
	    SumField->pCobFieldTotRes.data=NULL;
	    /* s.m. 20250110 SumField->pCobFieldTotRes.data = (unsigned char*)malloc(COB_MAX_BINARY); */
		SumField->pCobFieldTotRes.data = (unsigned char*)calloc(COB_MAX_BINARY, sizeof(char));
		if (SumField->pCobFieldTotRes.data == NULL)
			utl_abend_terminate(MEMORYALLOC, 1351, ABEND_EXEC);

	    SumField->pCobFieldTotRes.attr = &SumField->pCobFAttrTotRes;

	    SumField_setTypeCobField(SumField, type, length);
    }
	else
		utl_abend_terminate(MEMORYALLOC, 1350, ABEND_EXEC);
	return SumField;
}
void SumField_destructor(struct SumField_t *SumField) 
{

	if (SumField->pCobFieldTotRes.data != NULL)
		free(SumField->pCobFieldTotRes.data);

	free(SumField);
}

int SumField_print(struct SumField_t *SumField) 
{
	printf("%d,%d,%s",
		SumField->position,
		SumField->length,
		utils_getFieldTypeName(SumField->type));
	return 0;
}

struct SumField_t *SumField_getNext(struct SumField_t *SumField) 
{
	if (SumField==NULL) {
		return NULL;
	} else {
		return SumField->next;
	}
}
int SumField_addHead(struct SumField_t **SumField, struct SumField_t *SumFieldToAdd) 
{
	SumFieldToAdd->next=*SumField;
	*SumField=SumFieldToAdd;
	return 0;
}
int SumField_addQueue(struct SumField_t **SumField, struct SumField_t *SumFieldToAdd) 
{
	struct SumField_t *f;
	if (*SumField==NULL) {
		*SumField=SumFieldToAdd;
	} else {
		for (f=*SumField;f->next!=NULL;f=f->next);
		f->next=SumFieldToAdd;
	}
	return 0;
}

int SumField_setPosition(struct SumField_t *SumField, int position) 
{
	SumField->position=position;
	return 0;
}

int SumField_setLength(struct SumField_t *SumField, int length) 
{
	SumField->length=length;
	return 0;
}

int SumField_setType(struct SumField_t *SumField, int type) 
{
	SumField->type=type;
	SumField_setTypeCobField( SumField, SumField->type, SumField->length);
	return 0;
}

void SumField_setTypeCobField(struct SumField_t *SumField, int type, int length) 
{
	switch (type) {
			case FIELD_TYPE_BINARY:
				job_cob_field_set(&SumField->pCobField,       COB_TYPE_NUMERIC_BINARY, length, 0, COB_FLAG_BINARY_SWAP, length);
				job_cob_field_set(&SumField->pCobFieldTotRes, COB_TYPE_NUMERIC_BINARY, length, 0, COB_FLAG_BINARY_SWAP, length);
			break;
			case FIELD_TYPE_FIXED:
				job_cob_field_set(&SumField->pCobField,       COB_TYPE_NUMERIC_BINARY, length, 0, COB_FLAG_HAVE_SIGN | COB_FLAG_BINARY_SWAP, length);
				job_cob_field_set(&SumField->pCobFieldTotRes, COB_TYPE_NUMERIC_BINARY, length, 0, COB_FLAG_HAVE_SIGN | COB_FLAG_BINARY_SWAP, length);
			break;
			case FIELD_TYPE_FLOAT:
				if (length > 4) {
					job_cob_field_set(&SumField->pCobField,       COB_TYPE_NUMERIC_DOUBLE, length, 0, COB_FLAG_HAVE_SIGN, length);
                    job_cob_field_set(&SumField->pCobFieldTotRes, COB_TYPE_NUMERIC_DOUBLE, length, 0, COB_FLAG_HAVE_SIGN, length);
				}
				else
				{
					job_cob_field_set(&SumField->pCobField,       COB_TYPE_NUMERIC_FLOAT, length, 0, COB_FLAG_HAVE_SIGN, length);
                    job_cob_field_set(&SumField->pCobFieldTotRes, COB_TYPE_NUMERIC_FLOAT, length, 0, COB_FLAG_HAVE_SIGN, length);
				}
			break;
			case FIELD_TYPE_PACKED:
                job_cob_field_set(&SumField->pCobField,       COB_TYPE_NUMERIC_PACKED, length, 0, COB_FLAG_HAVE_SIGN, length);
			 	job_cob_field_set(&SumField->pCobFieldTotRes, COB_TYPE_NUMERIC_PACKED, length, 0, COB_FLAG_HAVE_SIGN, length);
			break;
			case FIELD_TYPE_ZONED:
				job_cob_field_set(&SumField->pCobField,       COB_TYPE_NUMERIC_DISPLAY, length, 0, COB_FLAG_HAVE_SIGN, length);
		  		job_cob_field_set(&SumField->pCobFieldTotRes, COB_TYPE_NUMERIC_DISPLAY, length, 0, COB_FLAG_HAVE_SIGN, length);
			break;
			case FIELD_TYPE_NUMERIC_CLO:
				job_cob_field_set(&SumField->pCobField,       COB_TYPE_NUMERIC_DISPLAY, length, 0, COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_LEADING, length);
		  		job_cob_field_set(&SumField->pCobFieldTotRes, COB_TYPE_NUMERIC_DISPLAY, length, 0, COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_LEADING, length);
			break;
			case FIELD_TYPE_NUMERIC_CSL:
				job_cob_field_set(&SumField->pCobField,       COB_TYPE_NUMERIC_DISPLAY, length, 0, COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_LEADING | COB_FLAG_SIGN_SEPARATE, length);
		  		job_cob_field_set(&SumField->pCobFieldTotRes, COB_TYPE_NUMERIC_DISPLAY, length, 0, COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_LEADING | COB_FLAG_SIGN_SEPARATE, length);
			break;
			case FIELD_TYPE_NUMERIC_CST:
				job_cob_field_set(&SumField->pCobField,       COB_TYPE_NUMERIC_DISPLAY, length, 0, COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_SEPARATE, length);
		  		job_cob_field_set(&SumField->pCobFieldTotRes, COB_TYPE_NUMERIC_DISPLAY, length, 0, COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_SEPARATE, length);
			break;
			default:
			break;
	}
}



int SumField_setNext(struct SumField_t *SumField, struct SumField_t *SumFieldToAdd) 
{
	SumField->next=SumFieldToAdd;
	return 0;
}
int SumField_getPosition(struct SumField_t *SumField) 
{
	return SumField->position;
}
int SumField_getLength(struct SumField_t *SumField) 
{
	return SumField->length;
}
int SumField_getType(struct SumField_t *SumField) 
{
	return SumField->type;
}

void SumField_ResetTotSingle(struct SumField_t *SumField) 
{
	/* set zero to totalizer    */
	/* s.m. 20250110 cob_move(&cob_all_zero, &SumField->pCobFieldTotRes); */

	cob_set_llint(&SumField->pCobFieldTotRes, (int64_t) 0L);

	return ;
}

int SumField_setFunction( int nVal)
{
	globalJob->sumFields=nVal;
	return 0;
}

int SumField_enableXSUM( void )
{
	globalJob->nXSumFilePresent = 1;
	return 0;
}


int SumField_addDefinition(struct SumField_t *SumField) 
{
	SumField_addQueue(&(globalJob->SumField), SumField);
	return 0;
}

int SumField_SumField(const void *pRek) 
{
	struct SumField_t *SumField;
	for (SumField=globalJob->SumField; SumField!=NULL; SumField=SumField_getNext(SumField)) {
		/* set pointer field area */
		SumField->pCobField.data = (unsigned char*) pRek+(SumField_getPosition(SumField)-1);
		/* add to totalizer value of field  */
		cob_add (&SumField->pCobFieldTotRes, &SumField->pCobField, 0);
	}
	return 0;
}
int SumField_SumFieldUpdateRek(const void *pRek)
{
	struct SumField_t *SumField;
	for (SumField=globalJob->SumField; SumField!=NULL; SumField=SumField_getNext(SumField)) {
		/* copy totalizer into record area                                              */
		/* use this instruction only when length of totalizer is the same of field      */
        /*                                                                              */
        memcpy((unsigned char*) pRek+(SumField_getPosition(SumField)-1), SumField->pCobFieldTotRes.data, SumField_getLength(SumField));
        /* In this point move totalizer into field and copy value for length of field declared in gcsort                                            */
        /*         cob_move(&SumField->pCobFieldTotRes, &SumField->pCobField);                                                                      */
        /*         memcpy((unsigned char*) pRek+(SumField_getPosition(SumField)-1), SumField->pCobField.data, SumField_getLength(SumField));        */
	}
	return 0;
}

int SumField_ResetTot(struct job_t* job) 
{
	struct SumField_t *SumField;
	for (SumField=job->SumField; SumField!=NULL; SumField=SumField_getNext(SumField)) {
		if (SumField!=NULL) 
			SumField_ResetTotSingle(SumField);
	}
	return 0;
}

