/*
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
#include "libocsort.h"

#ifdef _WIN32
	#include <Windows.h>
#endif

#include "sumfield.h"
#include "ocsort.h"
#include "utils.h"
#include "job.h"

static const unsigned char packed_bytes[] = {
	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,
	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,
	0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29,
	0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
	0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
	0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
	0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
	0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
	0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
	0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99
};

void cob_set_packedint64_t(cob_field * f, int64_t val);

typedef cob_field_attr cob_field_attr;

struct SumField_t {
	int position;
	int length;
	int type;
	int64_t TotRes;
	cob_field_attr  pCobFAttr;
	cob_field	   pCobField;

	struct SumField_t *next;
};

struct SumField_t *SumField_constructor(int position, int length, int type) {
	struct SumField_t *SumField=(struct SumField_t *)malloc(sizeof(struct SumField_t));
	SumField->position=position; 
	SumField->length=length;
	SumField->type=type;
	SumField->next=NULL;
	SumField->TotRes=0;
	SumField->pCobField.data=NULL;
	SumField->pCobField.data = (unsigned char*)malloc(COB_MAX_DIGITS);

	return SumField;
}
void SumField_destructor(struct SumField_t *SumField) {

	if (SumField->pCobField.data != NULL)
		free(SumField->pCobField.data);
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

int SumField_setFunction( int nVal) {
	globalJob->sumFields=nVal;
	return 0;
}


int SumField_addDefinition(struct SumField_t *SumField) {
	SumField_addQueue(&(globalJob->SumField), SumField);
	return 0;
}

int SumField_SumField(const void *pRek) {
	unsigned char    szBufPK1[128];
	int64_t		mValue64 = 0;			    // 8bytes
	unsigned char  ucSign;
	int lenFieldSize	= 0;
	int lenFieldDigit	= 0;
	int result=0;
	int npB = 0;
	int nk = 0;
	struct SumField_t *SumField;
	memset(szBufPK1, 0x00, sizeof(szBufPK1));
	for (SumField=globalJob->SumField; SumField!=NULL; SumField=SumField_getNext(SumField)) {
		mValue64 = 0;		
		memset(szBufPK1, 0x00, sizeof(szBufPK1));
		switch (SumField_getType(SumField)) {
// ===========//
// Binary
// ===========//
// FIELD_TYPE_BINARY:
			case FIELD_TYPE_BINARY:
				lenFieldSize  = SumField_getLength(SumField);
				// byte for sign littel endian
				if (globalJob->nByteOrder == 1)
					ucSign = ((unsigned char*) pRek+(SumField_getPosition(SumField)-1))[0];
				else
					ucSign = ((unsigned char*) pRek+(SumField_getPosition(SumField)-1))[lenFieldSize-1];// byte for sign littel endian
				// sign indicator placed in the most significant bit
				if ((ucSign & (1 << 7))) {
					memset(szBufPK1,0xff, sizeof(szBufPK1));
					mValue64=-1;
				}
				memcpy((unsigned char*) szBufPK1+SIZEINT64-lenFieldSize, (unsigned char*) pRek+(SumField_getPosition(SumField)-1), lenFieldSize);
				if (globalJob->nByteOrder == 1)
					memcpy(&mValue64, (unsigned char*) szBufPK1, SIZEINT64);
				else
					memcpy((unsigned char*)&mValue64, (unsigned char*) pRek+(SumField_getPosition(SumField)-1), lenFieldSize);
				if (globalJob->nByteOrder == 1) 
					mValue64 = COB_BSWAP_64(mValue64);

				if (mValue64 < 0)		// only unsigned
					mValue64 *=-1;

				SumField_AddTot(SumField, mValue64);  
				break;
// ===========//
// Fixed
// ===========//
// FIELD_TYPE_FIXED:
			case FIELD_TYPE_FIXED:
				lenFieldSize  = SumField_getLength(SumField);
				// byte for sign littel endian
				if (globalJob->nByteOrder == 1)
					ucSign = ((unsigned char*) pRek+(SumField_getPosition(SumField)-1))[0];
				else
					ucSign = ((unsigned char*) pRek+(SumField_getPosition(SumField)-1))[lenFieldSize-1];// byte for sign little endian
				// sign indicator placed in the most significant bit
				if ((ucSign & (1 << 7))) {
					memset(szBufPK1,0xff, sizeof(szBufPK1));
					mValue64=-1;
				}
				memcpy((unsigned char*) szBufPK1+SIZEINT64-lenFieldSize, (unsigned char*) pRek+(SumField_getPosition(SumField)-1), lenFieldSize);
				
				if (globalJob->nByteOrder == 1)
					memcpy(&mValue64, (unsigned char*) szBufPK1, SIZEINT64);
				else
					memcpy((unsigned char*)&mValue64, (unsigned char*) pRek+(SumField_getPosition(SumField)-1), lenFieldSize);
				
				if (globalJob->nByteOrder == 1) 
					mValue64 = COB_BSWAP_64(mValue64);
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
				SumField->pCobFAttr.type= COB_TYPE_NUMERIC_PACKED;
				SumField->pCobFAttr.digits = lenFieldDigit;
				SumField->pCobFAttr.scale = 0;
				SumField->pCobFAttr.flags = COB_FLAG_HAVE_SIGN;
				SumField->pCobFAttr.pic = NULL;
				SumField->pCobField.attr =  &SumField->pCobFAttr;//pFieldAttr;
				memset (SumField->pCobField.data, 0x00, COB_MAX_DIGITS);
				SumField->pCobField.size = lenFieldSize;
				cob_set_packed_zero(&SumField->pCobField);
				memcpy(SumField->pCobField.data, (unsigned char*) pRek+(SumField_getPosition(SumField)-1), SumField_getLength(SumField));
				mValue64 = cob_get_llint(&(SumField->pCobField));
				SumField_AddTot(SumField, mValue64);  // verify if correct 

				break;

// ===========//
// Zoned
// ===========//
// FIELD_TYPE_ZONED:
			case FIELD_TYPE_ZONED:
				lenFieldSize = SumField_getLength(SumField);
 				lenFieldDigit = SumField_getLength(SumField);
				if (lenFieldSize <=	18)
					SumField->pCobFAttr.type= COB_TYPE_NUMERIC_DISPLAY;
				else
					SumField->pCobFAttr.type= COB_TYPE_NUMERIC_DOUBLE;

				SumField->pCobFAttr.digits = lenFieldDigit;
				SumField->pCobFAttr.scale = 0;
				SumField->pCobFAttr.flags = COB_FLAG_HAVE_SIGN;
				SumField->pCobFAttr.pic = NULL;
				SumField->pCobField.attr =  &SumField->pCobFAttr;//pFieldAttr;
				memset (SumField->pCobField.data, 0x00, COB_MAX_DIGITS);
				SumField->pCobField.size = lenFieldSize;
			    memset(SumField->pCobField.data, 0x00, lenFieldSize);
				memcpy(SumField->pCobField.data, (unsigned char*) pRek+(SumField_getPosition(SumField)-1), SumField_getLength(SumField));
				mValue64 = cob_get_llint(&SumField->pCobField);
				SumField_AddTot(SumField, mValue64);  // verify if correct 

				break;
			default:
				fprintf(stderr,"*OCSort*S092* ERROR Type for SUM FIELDS:Pos:%ld - Len:%ld - Type:%c \n", SumField_getPosition(SumField), SumField_getLength(SumField), SumField_getType(SumField));
				break;
		}
	}
	return 0;
}
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
	int lenFieldSize	= 0;
	int lenFieldDigit	= 0;
	unsigned char    szBufPK1[128];

	for (SumField=globalJob->SumField; SumField!=NULL; SumField=SumField_getNext(SumField)) {
		nTot = SumField_GetTot(SumField);
		switch (SumField_getType(SumField)) {
// FIELD_TYPE_BINARY:
			case FIELD_TYPE_BINARY:
				if (globalJob->nByteOrder == 1) {
					nTot = COB_BSWAP_64(nTot);
					memcpy((unsigned char*) szBufPK1, &nTot, sizeof(nTot));
					memcpy((unsigned char*) pRek+(SumField_getPosition(SumField)-1), (unsigned char*) szBufPK1+SIZEINT64-SumField_getLength(SumField), SumField_getLength(SumField));
				}
				else
				{
					memcpy((unsigned char*) szBufPK1, &nTot, sizeof(nTot));
					memcpy((unsigned char*) pRek+(SumField_getPosition(SumField)-1), (unsigned char*) szBufPK1, SumField_getLength(SumField));
				}
				break;
// FIELD_TYPE_FIXED:
			case FIELD_TYPE_FIXED:
				if (globalJob->nByteOrder == 1) {
					nTot = COB_BSWAP_64(nTot);
					memcpy((unsigned char*) szBufPK1, &nTot, sizeof(nTot));
					memcpy((unsigned char*) pRek+(SumField_getPosition(SumField)-1), (unsigned char*) szBufPK1+SIZEINT64-SumField_getLength(SumField), SumField_getLength(SumField));
				}
				else
				{
					memcpy((unsigned char*) szBufPK1, &nTot, sizeof(nTot));
					memcpy((unsigned char*) pRek+(SumField_getPosition(SumField)-1), (unsigned char*) szBufPK1, SumField_getLength(SumField));
				}
				break;
// FIELD_TYPE_PACKED
			case FIELD_TYPE_PACKED:
		//
		// ==============================================
					lenFieldSize  = SumField_getLength(SumField);
 					lenFieldDigit = SumField_getLength(SumField);
					lenFieldDigit = lenFieldDigit*2-1;
					SumField->pCobFAttr.type = COB_TYPE_NUMERIC_PACKED;// Type
					SumField->pCobFAttr.digits = lenFieldDigit;
					SumField->pCobFAttr.scale = 0;
					SumField->pCobFAttr.flags = 1;
					SumField->pCobFAttr.pic = NULL;
					SumField->pCobField.attr = &SumField->pCobFAttr; //pFieldAttr;
					memset (SumField->pCobField.data, 0x00, COB_MAX_DIGITS);
					SumField->pCobField.size = lenFieldSize;
					cob_set_packedint64_t(&SumField->pCobField, SumField_GetTot(SumField));
					memcpy((unsigned char*) pRek+(SumField_getPosition(SumField)-1), SumField->pCobField.data, SumField_getLength(SumField));
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
			#ifdef	_MSC_VER
					strncat(szPrintf,	 "I64d", 4);
			#else
				strncat(szPrintf,	 "lld", 3);
			#endif
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

int SumField_ResetTot(struct job_t* job) {
	struct SumField_t *SumField;
	for (SumField=job->SumField; SumField!=NULL; SumField=SumField_getNext(SumField)) {
		if (SumField!=NULL) 
			SumField_ResetTotSingle(SumField);
	}
	return 0;
}


int SumFields_KeyCheck(struct job_t* job, 
						int* bIsWrited, 
                        unsigned char* szKeyPrec, 
                        unsigned int* nLenPrec, 
                        unsigned char* szKeyCurr,  
                        unsigned int* nLenRek, 
                        unsigned char* szKeySave,  
                        unsigned int* nLenSave, 
                        unsigned char* szPrecSumFields, 
                        unsigned char* szSaveSumFields, 
                        unsigned char* szBuffRek,
						int nSplit)
{
    int useRecord = 1;
        if (job_compare_key(szKeyPrec, szKeyCurr) == 0) {	// Compare Keys
            *nLenPrec = *nLenRek;
            SumField_SumField((unsigned char*)szBuffRek+nSplit);
            memcpy(szPrecSumFields, szBuffRek, *nLenRek+nSplit);
            useRecord=0;
            *bIsWrited = 1;
        }
        else // Keys not equal write buffer to file
        {
            useRecord = 1;
            // Save
            memcpy(szKeySave,		szKeyPrec,      job->nLenKeys+SIZEINT64);			   //lPosPnt + Key
            memcpy(szSaveSumFields, szPrecSumFields, *nLenPrec+nSplit);
            *nLenSave = *nLenPrec;
            // Previous
            memcpy(szKeyPrec,		szKeyCurr, job->nLenKeys+SIZEINT64);			   //lPosPnt + key
            memcpy(szPrecSumFields, (unsigned char*) szBuffRek, *nLenRek+nSplit); // PosPnt
            *nLenPrec = *nLenRek;
            //Current
            memcpy(szKeyCurr, szKeySave,       job->nLenKeys+SIZEINT64);			   //lPosPnt + Key
            memcpy(szBuffRek, szSaveSumFields, *nLenSave+nSplit);
            *nLenRek = *nLenSave;
    }
    return useRecord;
}

void cob_set_packedint64_t(cob_field * f, int64_t val)
{
	int sign = FALSE; 
	cob_u64_t n;
	unsigned char * p ;
	if(!val) {
		cob_set_packed_zero(f);
		return;
	}
	if(val < 0) {
		n = (cob_u64_t) -val;
		sign = TRUE;
	} else {
		n = (cob_u64_t)val;
	}
	memset(f->data, 0, f->size);
	p = f->data + f->size - 1;
	if(!COB_FIELD_NO_SIGN_NIBBLE(f)) {
		*p = (n % 10) << 4;
		if(!COB_FIELD_HAVE_SIGN(f)) {
			*p |= 0x0FU;
		} else if(sign) {
			*p |= 0x0DU;
		} else {
			*p |= 0x0CU;
		}
		n /= 10;
		p--;
	}
	for(; n && p >= f->data; n /= 100, p--) {
		*p = packed_bytes[n % 100];
	}
	if(COB_FIELD_NO_SIGN_NIBBLE(f)) {
		if((COB_FIELD_DIGITS(f) % 2) == 1) {
			*(f->data) &= 0x0FU;
		}
		return;
	}
	if((COB_FIELD_DIGITS(f) % 2) == 0) {
		*(f->data) &= 0x0FU;
	}
}

