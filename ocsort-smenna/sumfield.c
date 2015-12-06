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
#include <libcob.h>
#include "SumField.h"
#include "ocsort.h"
#include "utils.h"
#include "job.h"


unsigned int szSizeBinarySigned   [] = {1,1,2,2,3,3,4,4,4,5,5,6,6,6,7,7,8,8};
unsigned int szSizeBinaryUnsigned [] = {1,1,2,2,3,3,3,4,4,5,5,5,6,6,7,7,8,8};

unsigned int szSizePackedSigned   [] = {1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,16,16};
unsigned int szSizePackedUnsigned [] = {1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,16,16};

void cob_set_packedint64_t(cob_field * f, int64_t val);

struct SumField_t {
	int position;
	int length;
	int type;
	int64_t TotRes;
	struct cob_field_attr* pCobFAttr;
	struct cob_field*	   pCobField;

	struct SumField_t *next;
};

struct SumField_t *SumField_constructor(int position, int length, int type) {
	struct SumField_t *SumField=(struct SumField_t *)malloc(sizeof(struct SumField_t));
	SumField->position=position;
	SumField->length=length;
	SumField->type=type;
	SumField->next=NULL;
	SumField->TotRes=0;

	SumField->pCobFAttr = (struct cob_field_attr*) malloc(sizeof(struct cob_field_attr));
	SumField->pCobField = (struct cob_field*)malloc(sizeof(struct cob_field));

	return SumField;
}
void SumField_destructor(struct SumField_t *SumField) {

	if (SumField->pCobFAttr != NULL)
		free(SumField->pCobFAttr);
	if (SumField->pCobField != NULL)
		free(SumField->pCobField);

	free(SumField);
}


int SumField_print(struct SumField_t *SumField) {
	printf("%d,%d,%s",
		SumField->position,
		SumField->length,
		utils_getFieldTypeName(SumField->type));
	return 0;
}

struct SumField_t *SumField_getNext(struct SumField_t *SumField) {
	if (SumField==NULL) {
		return NULL;
	} else {
		return SumField->next;
	}
}
int SumField_addHead(struct SumField_t **SumField, struct SumField_t *SumFieldToAdd) {
	SumFieldToAdd->next=*SumField;
	*SumField=SumFieldToAdd;
	return 0;
}
int SumField_addQueue(struct SumField_t **SumField, struct SumField_t *SumFieldToAdd) {
	struct SumField_t *f;
	if (*SumField==NULL) {
		*SumField=SumFieldToAdd;
	} else {
		for (f=*SumField;f->next!=NULL;f=f->next);
		f->next=SumFieldToAdd;
	}
	return 0;
}

int SumField_setPosition(struct SumField_t *SumField, int position) {
	SumField->position=position;
	return 0;
}

int SumField_setLength(struct SumField_t *SumField, int length) {
	SumField->length=length;
	return 0;
}

int SumField_setType(struct SumField_t *SumField, int type) {
	SumField->type=type;
	return 0;
}

int SumField_setNext(struct SumField_t *SumField, struct SumField_t *SumFieldToAdd) {
	SumField->next=SumFieldToAdd;
	return 0;
}
int SumField_getPosition(struct SumField_t *SumField) {
	return SumField->position;
}
int SumField_getLength(struct SumField_t *SumField) {
	return SumField->length;
}
int SumField_getType(struct SumField_t *SumField) {
	return SumField->type;
}

void SumField_ResetTotSingle(struct SumField_t *SumField) {
	SumField->TotRes = 0;
	return ;
}
int64_t SumField_SetTot(struct SumField_t *SumField, int64_t nTot64) {
	SumField->TotRes = nTot64;
	return SumField->TotRes;
}

int64_t SumField_GetTot(struct SumField_t *SumField) {
	return SumField->TotRes;
}

int64_t SumField_AddTot(struct SumField_t *SumField, int64_t nTot64) {
	SumField->TotRes += nTot64;
	return SumField->TotRes;
}

// return logical len of Field
int SumField_GetDigit(struct SumField_t *SumField ) {
	
	switch(SumField->type) {
		case FIELD_TYPE_BINARY:
			// force unsigned
			return szSizeBinaryUnsigned[(SumField->length*2)-1];
// s.m.
		case FIELD_TYPE_PACKED:
			// force signed
			return szSizePackedSigned[(SumField->length*2)-1];
// s.m.
		case FIELD_TYPE_ZONED:
			// force signed
			return SumField->length;  // same
// s.m.
		case FIELD_TYPE_FIXED:
			// 
			return szSizeBinarySigned[(SumField->length*2)-1];
		default:
			return 0;

	}
	return SumField->length;
}

// nVal = 0  nothing 
// nVal = 1  SUM FIELDS = NONE
// nVal = 2  SUM FIELDS = (P,L,T,....)
//-->old int job_setSumFields( int nVal) {
int SumField_setFunction( int nVal) {
	globalJob->sumFields=nVal;
	return 0;
}

// old int job_addSumField(struct SumField_t *SumField) {
int SumField_addDefinition(struct SumField_t *SumField) {
	SumField_addQueue(&(globalJob->SumField), SumField);
	return 0;
}

// int job_SumField(const void *pRek) {
int SumField_SumField(const void *pRek) {

	short int SPK1	 = 0;
	int SPK1x		 = 0;
	short int SPK2	 = 0;
	int SPK2x		 = 0;

	short int	siValue2 = 0; // 2bytes
	
	long int	liValue4 = 0; // 4bytes
	unsigned long int	usliValue4 = 0; // 4bytes

	int			iValue4  = 0; // 4bytes
	float		fValue4  = 0; // 4bytes
	double		dValue8  = 0; // 8bytes
	int64_t		mValue64 = 0;
	

	cob_u8_t    szBufPK1[128]; 
	unsigned char*		pFieldBuf;

	 //struct cob_field_attr		CobFAttr;
	 struct cob_field_attr*		pFieldAttr; 
	 unsigned char				FieldBuf[32];
	 //struct cob_field			CobF;
	 cob_field_ptr				pCobF;

	 int lenFieldSize	= 0;
	 int lenFieldDigit	= 0;

	int result=0;
	struct SumField_t *SumField;

// only debug
// only debug	memset(szBufPK1, 0x00, sizeof (szBufPK1));
// only debug	memset(szBufPK2, 0x00, sizeof (szBufPK2));
// only debug	memset(szCnv, 0x00, sizeof(szCnv));
// only debug	memcpy(szBufPK1, pRek, sizeof (szBufPK1));
//
	
	for (SumField=globalJob->SumField; SumField!=NULL; SumField=SumField_getNext(SumField)) {
		switch (SumField_getType(SumField)) {
// ===========//
// Binary
// ===========//
// FIELD_TYPE_BINARY:
			case FIELD_TYPE_BINARY:

				lenFieldSize  = SumField_getLength(SumField);
 				lenFieldDigit = SumField_getLength(SumField);
				if (lenFieldSize % 2 == 0){
					lenFieldDigit = lenFieldDigit*2;
					if (lenFieldSize > 5)
						lenFieldDigit += 2;
				}
				else
				{
					lenFieldDigit = lenFieldDigit*2;
				}

				if (lenFieldSize < 3) {
					memcpy(&siValue2, (unsigned char*) pRek+(SumField_getPosition(SumField)-1), SumField_getLength(SumField));
					//-->> native bigendian siValue2 = Endian_Word_Conversion(siValue2); 
				}
				if ((lenFieldSize >= 3) && (lenFieldSize <= 5)){
					memset(szBufPK1,0x00,sizeof(szBufPK1));
					if (lenFieldSize % 2 == 0)
					{
						memcpy(&szBufPK1, (unsigned char*) pRek+(SumField_getPosition(SumField)-1), SumField_getLength(SumField));
						szBufPK1[SumField_getLength(SumField)+1]=0x00;
						memcpy(&liValue4, (unsigned char*) szBufPK1, lenFieldSize);
						//-->> native bigendian liValue4 = Endian_DWord_Conversion(liValue4); 
					}
					else
					{
						memcpy(&szBufPK1[1], (unsigned char*) pRek+(SumField_getPosition(SumField)-1), SumField_getLength(SumField));
						szBufPK1[0]=0xFF; // negative
						szBufPK1[0]=0x00; // positive  look manual DFSort  BI = Unsigned binary
						szBufPK1[SumField_getLength(SumField)+1]=0x00;
						//memcpy(&liValue4, (unsigned char*) szBufPK1, SumField_getLength(SumField)+1);
						memcpy(&liValue4, (unsigned char*) szBufPK1, lenFieldSize+1);
						//-->> native bigendian liValue4 = Endian_DWord_Conversion(liValue4); 
					}
				}
				if (lenFieldSize > 5) {
					memset(szBufPK1,0x00,sizeof(szBufPK1));
					if (lenFieldSize % 2 == 0)
					{
						memcpy(&mValue64, (unsigned char*) pRek+(SumField_getPosition(SumField)-1), SumField_getLength(SumField));
						//-->> native bigendian mValue64 = COB_BSWAP_64(mValue64); 
					}
					else
					{
						memcpy(&szBufPK1[1], (unsigned char*) pRek+(SumField_getPosition(SumField)-1), SumField_getLength(SumField));
						szBufPK1[0]=0x00; // // positive  look manual DFSort  BI = Unsigned binary
						szBufPK1[SumField_getLength(SumField)+1]=0x00;
						memcpy(&mValue64, (unsigned char*) szBufPK1, lenFieldSize+1);
						//-->> native bigendian mValue64 = COB_BSWAP_64(mValue64); 
					}

				}

 				 if (lenFieldSize <  3)
					 SumField_AddTot(SumField, siValue2);  
				if ((lenFieldSize >=  3) && (lenFieldSize <= 5))
					 SumField_AddTot(SumField, liValue4);  
 				 if (lenFieldSize > 5) 
					 SumField_AddTot(SumField, mValue64);  

				break;
// ===========//
// Packed
// ===========//
// FIELD_TYPE_PACKED:
			case FIELD_TYPE_PACKED:
				lenFieldSize  = SumField_getLength(SumField);
 				lenFieldDigit = SumField_getLength(SumField);
				if (lenFieldSize % 2 == 0)
					lenFieldDigit = (lenFieldDigit-1)*2+1;
				else
					lenFieldDigit = (lenFieldDigit-1)*2;

				pFieldAttr = SumField->pCobFAttr; //&CobFAttr;
				pFieldAttr->type = COB_TYPE_NUMERIC_PACKED;
				pFieldAttr->digits = lenFieldDigit;
				pFieldAttr->scale = 0;
				pFieldAttr->flags = COB_FLAG_HAVE_SIGN;
				pFieldAttr->pic = NULL;
	 
				pFieldBuf = (unsigned char*)&FieldBuf[0];
				memset (pFieldBuf , 0, lenFieldSize);
 	 
				pCobF = SumField->pCobField; // (struct cob_field*)&CobF;
				pCobF->attr = pFieldAttr;
				pCobF->data = pFieldBuf;
				pCobF->size = lenFieldSize;
				memset(pFieldBuf+lenFieldSize, 0x00, 1);

				cob_set_packed_zero(pCobF);

				memcpy(pCobF->data, (char*) pRek+(SumField_getPosition(SumField)-1), SumField_getLength(SumField));

				mValue64 = cob_get_llint(pCobF);
				SumField_AddTot(SumField, mValue64);  // verify if correct 

				break;

// ===========//
// Zoned
// ===========//
// FIELD_TYPE_ZONED:
			case FIELD_TYPE_ZONED:
				lenFieldSize = SumField_getLength(SumField);
 				lenFieldDigit = SumField_getLength(SumField);

				pFieldAttr = SumField->pCobFAttr; //&CobFAttr;
				if (lenFieldSize <=	18)
					pFieldAttr->type = COB_TYPE_NUMERIC_DISPLAY;// Type
				else
					pFieldAttr->type = COB_TYPE_NUMERIC_DOUBLE;
				pFieldAttr->digits = lenFieldDigit;
				pFieldAttr->scale = 0;
				pFieldAttr->flags = 1;
				pFieldAttr->pic = NULL;
	 
				pFieldBuf = (unsigned char*)&FieldBuf[0];
				memset (pFieldBuf, 0, lenFieldSize);
	 	 
				pCobF = SumField->pCobField; //&CobF;
				pCobF->attr = pFieldAttr;
				pCobF->data = pFieldBuf;
				pCobF->size = lenFieldSize;

			    memset(pCobF->data, 0x00, lenFieldSize);
				memcpy(pCobF->data, (char*) pRek+(SumField_getPosition(SumField)-1), SumField_getLength(SumField));
				memset(pFieldBuf+lenFieldSize, 0x00, 1);

				mValue64 = cob_get_llint(pCobF);
				SumField_AddTot(SumField, mValue64);  // verify if correct 

				break;
			default:
				fprintf(stderr,"*OCSort*S092* ERROR Type for SUM FIELDS:Pos:%ld - Len:%ld - Type:%c \n", SumField_getPosition(SumField), SumField_getLength(SumField), SumField_getType(SumField));
				break;
		}
	}
	return 0;
}
//int job_SumFieldUpdateRek(const void *pRek) {
int SumField_SumFieldUpdateRek(const void *pRek) {

	struct SumField_t *SumField;
	int64_t		nTot = 0;
	unsigned short int	siValue2 = 0; // 2bytes
	unsigned long int	liValue4 = 0; // 4bytes
	float		fValue4  = 0; // 4bytes
	double		dValue8  = 0; // 8bytes
	long int    SPK1=0;
	long int	SPK2=0;
	long int	SPK3=0;

	unsigned char        szZoned[32];
	char        szPrintf[10];
	char        szLen[10];
	int64_t				mValue64 = 0;

	 unsigned char*			    pFieldBuf;
	 struct cob_field_attr*		pFieldAttr; 
	 unsigned char				FieldBuf[32];
	 cob_field_ptr				pCobF;

	int lenFieldSize	= 0;
	int lenFieldDigit	= 0;
	cob_u8_t    szBufPK1[128];

	for (SumField=globalJob->SumField; SumField!=NULL; SumField=SumField_getNext(SumField)) {
		nTot = SumField_GetTot(SumField);
		switch (SumField_getType(SumField)) {
// FIELD_TYPE_BINARY:
			case FIELD_TYPE_BINARY:
				lenFieldSize  = SumField_getLength(SumField);
 				lenFieldDigit = SumField_getLength(SumField);
				if (lenFieldSize % 2 == 0){
					lenFieldDigit = lenFieldDigit*2;
					if (lenFieldSize > 5)
						lenFieldDigit += 2;
				}
				else
				{
					lenFieldDigit = lenFieldDigit*2;
				}
					
				pFieldAttr = SumField->pCobFAttr;//		&CobFAttr;
				pFieldAttr->type = COB_TYPE_NUMERIC_BINARY;// Type
				pFieldAttr->digits = lenFieldDigit;
				pFieldAttr->scale = 0;
				pFieldAttr->flags = 1;
				pFieldAttr->pic = NULL;
	 
				pFieldBuf = (unsigned char*)&FieldBuf;
				memset (pFieldBuf , 0, lenFieldSize);
 	 
				pCobF = SumField->pCobField; //&CobF;
				pCobF->attr = pFieldAttr;
				pCobF->data = pFieldBuf;
				pCobF->size = lenFieldSize;
				memset(pFieldBuf+lenFieldSize, 0x00, 1);

				cob_set_int(pCobF, (int) SumField_GetTot(SumField));

				memset(szBufPK1, 0x00, sizeof(szBufPK1));

				if (lenFieldSize < 3) {
					siValue2 = (unsigned short) nTot;
					//-->>>bigendian siValue2 = Endian_Word_Conversion(siValue2); 
					memcpy((char*) szBufPK1, &siValue2, sizeof(siValue2));
				}
				if ((lenFieldSize >= 3) && (lenFieldSize <= 5)){
					memset(szBufPK1,0x00,sizeof(szBufPK1));
					if (lenFieldSize % 2 == 0)
					{
						liValue4 = (unsigned long)nTot;
						//-->>>bigendian liValue4 = Endian_DWord_Conversion(liValue4); 
						memcpy((char*) szBufPK1, &liValue4, sizeof(liValue4));
					}
					else
					{
						liValue4 = (unsigned long)nTot;
						//-->>>bigendian liValue4 = Endian_DWord_Conversion(liValue4); 
						memcpy((char*)&szBufPK1, &liValue4, sizeof(liValue4));
					}
				}
				if (lenFieldSize > 5) {
					mValue64 = nTot;
					//-->>>bigendian mValue64 = COB_BSWAP_64(mValue64); 
					memcpy((char*) szBufPK1, &mValue64, sizeof(mValue64));
				}

				if (lenFieldSize > 1) {
					if (lenFieldSize % 2 == 0) 
						memcpy((char*) pRek+(SumField_getPosition(SumField)-1), szBufPK1, SumField_getLength(SumField));
					else
						memcpy((char*) pRek+(SumField_getPosition(SumField)-1), szBufPK1+1, SumField_getLength(SumField));
				}
				else
					memcpy((char*) pRek+(SumField_getPosition(SumField)-1), szBufPK1, SumField_getLength(SumField));
				break;
// FIELD_TYPE_PACKED
				case FIELD_TYPE_PACKED:
		//
		// ==============================================
					lenFieldSize  = SumField_getLength(SumField);
 					lenFieldDigit = SumField_getLength(SumField);
					lenFieldDigit = lenFieldDigit*2-1;
					pFieldAttr = SumField->pCobFAttr; //&CobFAttr;
					pFieldAttr->type = COB_TYPE_NUMERIC_PACKED;// Type
					pFieldAttr->digits = lenFieldDigit;
					pFieldAttr->scale = 0;
					pFieldAttr->flags = 1;
					pFieldAttr->pic = NULL;
	 
					pFieldBuf = (unsigned char*)&FieldBuf;
					memset (pFieldBuf , 0, lenFieldSize);
 	 
					pCobF = SumField->pCobField; // &CobF;
					pCobF->attr = pFieldAttr;
					pCobF->data = pFieldBuf;
					pCobF->size = lenFieldSize;
					memset(pFieldBuf+lenFieldSize, 0x00, 1);

					cob_set_packedint64_t(pCobF, SumField_GetTot(SumField));
					memcpy((char*) pRek+(SumField_getPosition(SumField)-1), pCobF->data, SumField_getLength(SumField));

					break;
// FIELD_TYPE_ZONED:
			case FIELD_TYPE_ZONED:
				memset(szZoned,		0x00, sizeof szZoned);
				memset(szPrintf,	0x00, sizeof szPrintf);

				// Esempio per inserire gli zeri in testa : 	%0nd  n = num interi			
				//sprintf(szLen,   "%I64d", SumField_getLength(SumField) + 1); // sign on first char
				sprintf(szLen,   "%d", SumField_getLength(SumField)); // sign on first char
				strncat(szPrintf,	"%0", 3);
				strncat(szPrintf,	szLen, 2);
				strncat(szPrintf,	 "I64d", 4);
				sprintf((char*) szZoned,   szPrintf, nTot);
				if (nTot < 0)
					szZoned[SumField_getLength(SumField)] += 0x40; //Negative
				
				memcpy((char*) pRek+(SumField_getPosition(SumField)-1), szZoned, SumField_getLength(SumField));
				break;
			default:
				fprintf(stderr,"*OCSort*S093* ERROR Type for SUM FIELDS:Pos:%ld - Len:%ld - Type:%c \n", SumField_getPosition(SumField), SumField_getLength(SumField), SumField_getType(SumField));
				break;
		}
	}
	return 0;
}

// int JobSumField_ResetTot(struct job_t* job)
int SumField_ResetTot(struct job_t* job) {
	struct SumField_t *SumField;
	for (SumField=job->SumField; SumField!=NULL; SumField=SumField_getNext(SumField)) {
		if (SumField!=NULL) 
			SumField_ResetTotSingle(SumField);
	}
	return 0;
}
