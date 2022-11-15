/*
    Copyright (C) 2016-2020 Sauro Menna
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

#ifndef SUMFIELD_H_INCLUDED
#define SUMFIELD_H_INCLUDED

#include <stdint.h>
#include "job.h"

struct SumField_t {
	int position;
	int length;
	int type;

	cob_field_attr  pCobFAttr;				/* Attribute for record area    */
	cob_field	    pCobField;				/* Field for record area        */

	cob_field_attr  pCobFAttrTotRes;		/* Attribute for totalizer      */
	cob_field	    pCobFieldTotRes;		/* Field for totalizer          */

	struct SumField_t *next;
};

struct SumField_t *SumField_constructor(int position, int length, int type);
void SumField_destructor(struct SumField_t *SumField);
int SumField_print(struct SumField_t *SumField);
struct SumField_t *SumField_getNext(struct SumField_t *SumField);
int SumField_addQueue(struct SumField_t **SumField, struct SumField_t *SumFieldToAdd);
int SumField_addHead(struct SumField_t **SumField, struct SumField_t *SumFieldToAdd);
int SumField_setPosition(struct SumField_t *SumField, int position);
int SumField_setLength(struct SumField_t *SumField, int length);
int SumField_setType(struct SumField_t *SumField, int type);
int SumField_setNext(struct SumField_t *SumField, struct SumField_t *SumFieldToAdd);
int SumField_getPosition(struct SumField_t *SumField);
int SumField_getLength(struct SumField_t *SumField);
int SumField_getType(struct SumField_t *SumField);
void SumField_ResetTotSingle(struct SumField_t *SumField);
int SumField_setFunction( int nVal );
int SumField_addDefinition(struct SumField_t *SumField);
int SumField_SumField(const void *pRek);
int SumField_SumFieldUpdateRek(const void *pRek);
int SumField_ResetTot(struct job_t* job);
void SumField_setTypeCobField(struct SumField_t *SumField, int type, int length);
int SumFields_KeyCheck(struct job_t* job, int* bIsWrited, unsigned char* szKeyPrec, unsigned int* nLenPrec, 
                        unsigned char* szKeyCurr,  unsigned int* nLenRek, unsigned char* szKeySave,  unsigned int* nLenSave, 
                        unsigned char* szPrecSumFields, unsigned char* szSaveSumFields, unsigned char* szBuffRek, int nSplit);
#endif /* SUMFIELD_H_INCLUDED   */
