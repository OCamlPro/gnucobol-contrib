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
#include <stddef.h>


#include "ocsort.h"
#include "libocsort.h"
#include "fieldvalue.h"
#include "utils.h"
#include "job.h"


struct cob_field_attr ;
struct cob_field ;
 
struct fieldValue_t *fieldValue_constructor(char *type, char *value, int nTypeF) {
	int i,j;
	unsigned char buffer[3];
	struct fieldValue_t *fieldValue=(struct fieldValue_t *)malloc(sizeof(struct fieldValue_t));
	fieldValue->type=utils_parseFieldValueType(type[strlen(type)-1]);
	if (strlen(type)>1) {
		type[strlen(type)-1]=0;
		fieldValue->occursion=atoi(type);
	} else {
		fieldValue->occursion=1;
	}
	fieldValue->value=strdup(value);
	
	job_RescanCmdSpecialChar(fieldValue->value);
	job_RescanCmdSpecialChar(value);

		switch (fieldValue->type) {
		case FIELD_VALUE_TYPE_Z:
				fieldValue->generated_length=fieldValue->occursion;
				fieldValue->generated_length = strlen(value);
				if (nTypeF == 0) {
					fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
					for(i=0;i<fieldValue->occursion;i++) {
						fieldValue->generated_value[i]=0;	// original is OK from DFSORT Manual
					}
					fieldValue->generated_value[fieldValue->generated_length]=0;
				}
				else
				{
					fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
					strcpy(fieldValue->generated_value, value);
					fieldValue->generated_value[fieldValue->generated_length]=0;
					fieldValue->value64 = _atoi64(value);
				}
			break;
		case FIELD_VALUE_TYPE_X:
			if (strlen(value)==0) {
				fieldValue->generated_length=fieldValue->occursion;
				fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
				for(i=0;i<fieldValue->occursion;i++) {
					fieldValue->generated_value[i]=' ';
				}
				fieldValue->generated_value[fieldValue->generated_length]=0;
			} else {
				fieldValue->generated_length=fieldValue->occursion*strlen(value)/2;
				fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
				buffer[2]=0;
				for(i=0;i<fieldValue->occursion;i++) {
					for(j=0;j< (int) strlen(value)/2;j++) {
						buffer[0]=value[2*j];
						buffer[1]=value[2*j+1];
						fieldValue->generated_value[i*strlen(value)/2+j]= (char) strtol((char*) buffer,NULL,16);
					}
				}
				fieldValue->generated_value[fieldValue->generated_length]=0;
			}
			break;
		case FIELD_VALUE_TYPE_C:
			fieldValue->generated_length=fieldValue->occursion*strlen(value);
			fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
			for(i=0;i<fieldValue->occursion;i++) {
				memcpy(fieldValue->generated_value+i*strlen(value),value,strlen(value));
			}
			fieldValue->generated_value[fieldValue->generated_length]=0;
			break;
		default:
			fprintf(stdout,"*OCSort*S810* ERROR Field Type unknow %n\n", fieldValue->type);
            exit(OC_RTC_ERROR); 
			break;
	}
	fieldValue->pCobField.data = NULL;
	return fieldValue;
}

struct fieldValue_t *fieldValue_constructor2(char *type, char *value, int nTypeF) {
	int i;
	char szB1 [256];
	struct fieldValue_t *fieldValue=(struct fieldValue_t *)malloc(sizeof(struct fieldValue_t));
	fieldValue->type=utils_parseFieldValueType(type[strlen(type)-1]);
	memset(szB1, 0x00, sizeof(szB1));
	if (strlen(type) > 1) {
		memcpy(szB1, type, strlen(type)-1);	//36C'xx'
		fieldValue->occursion=atoi(szB1);
	}
	else	
	{
		fieldValue->occursion=atoi(value);	// 80:X		(padding blank record fix reclen = 80)
	}
	fieldValue->value=strdup(value);
	if (strlen(fieldValue->value) > 0) {
		job_RescanCmdSpecialChar(fieldValue->value);
		job_RescanCmdSpecialChar(value);
	}
	else
		fieldValue->occursion=1;
	


	switch (fieldValue->type) {
		case FIELD_VALUE_TYPE_Z:
				fieldValue->generated_length=fieldValue->occursion;
				// ?? fieldValue->generated_length = strlen(value);
				if (nTypeF == 0) {
					fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
					for(i=0;i<fieldValue->occursion;i++) {
						fieldValue->generated_value[i]=0;	// original is OK from DFSORT Manual
					}
					fieldValue->generated_value[fieldValue->generated_length]=0;
				}
				else
				{
					fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
					strcpy(fieldValue->generated_value, value);
					fieldValue->generated_value[fieldValue->generated_length]=0;
					fieldValue->value64 = _atoi64(value);
				}
		break;
		case FIELD_VALUE_TYPE_X:
				fieldValue->generated_length=fieldValue->occursion;
				fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
				for(i=0;i<fieldValue->occursion;i++) {
					fieldValue->generated_value[i]=' ';
				}
				fieldValue->generated_value[fieldValue->generated_length]=0;
			break;
		case FIELD_VALUE_TYPE_C:
			fieldValue->generated_length=fieldValue->occursion*strlen(value);
			fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
			for(i=0;i<fieldValue->occursion;i++) {
				memcpy(fieldValue->generated_value+i*strlen(value),value,strlen(value));
			}
			fieldValue->generated_value[fieldValue->generated_length]=0;
           
			break;
		default:
			fprintf(stdout,"*OCSort*S811* ERROR Field Value Type unknow %n\n", fieldValue->type);
            exit(OC_RTC_ERROR); 
			break;
	}
	fieldValue->pCobField.data = NULL;
	return fieldValue;
}

void fieldValue_destructor(struct fieldValue_t *fieldValue) {

	if (fieldValue->generated_value != NULL)
		free(fieldValue->generated_value);
	if (fieldValue->value != NULL)
		free(fieldValue->value);
	free(fieldValue);
	return;
}


int fieldValue_print(struct fieldValue_t *fieldValue) {
	if (fieldValue->occursion>1) {
		fprintf(stdout,"%d",fieldValue->occursion);
	}
	fprintf(stdout,"%s",utils_getFieldValueTypeName(fieldValue->type));
	if (strlen(fieldValue->value)>0) {
			fprintf(stdout,"'%s'",fieldValue->value);
	}
 	return 0;
}
int fieldValue_test(struct fieldValue_t *fieldValue, unsigned char *record, int length) {
	int used_length;
	int result;
	unsigned char*				pFieldBuf;
	unsigned char				FieldBuf[32];
	int64_t						mValue64 = 0;
	int lenFieldSize	= 0;
	int lenFieldDigit	= 0;
	// checktype of field for compare 
	used_length=(length<fieldValue->generated_length?length:fieldValue->generated_length);
	switch (fieldValue->type) {
		case FIELD_VALUE_TYPE_Z:
			lenFieldSize = used_length;
 			lenFieldDigit = 0;		
			fieldValue->pCobFAttr.type = COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_SEPARATE |COB_FLAG_SIGN_LEADING;//COB_TYPE_NUMERIC_DISPLAY;// Type
			fieldValue->pCobFAttr.digits = lenFieldDigit;
			fieldValue->pCobFAttr.scale = 0;
			fieldValue->pCobFAttr.flags = COB_FLAG_SIGN_LEADING; // 1; // COB_FLAG_SIGN_SEPARATE
			fieldValue->pCobFAttr.pic = NULL;
			pFieldBuf = (unsigned char*) &FieldBuf;
			memset (pFieldBuf, 0, lenFieldSize);
			
			fieldValue->pCobField.attr = &fieldValue->pCobFAttr; //pFieldAttr;
			fieldValue->pCobField.data = pFieldBuf;
			fieldValue->pCobField.size = lenFieldSize;

			memset(fieldValue->pCobField.data, 0x00, lenFieldSize);
			memcpy(fieldValue->pCobField.data, (char*) record, used_length); 
			memset(pFieldBuf+lenFieldSize, 0x00, 1);

			mValue64 = cob_get_llint(&fieldValue->pCobField);

			if (fieldValue->value64 ==  mValue64)
				result = 0;
			if (fieldValue->value64  >  mValue64 )
				result = 1;
			if (fieldValue->value64  <  mValue64 )
				result = -1;
		break;

		case FIELD_VALUE_TYPE_X:
			result=memcmp((char*)fieldValue->generated_value,(char*)record,used_length);
		break;
		case FIELD_VALUE_TYPE_C:
			result=memcmp((char*)fieldValue->generated_value,(char*)record,used_length);
		break;
		default:
        fprintf(stdout,"*OCSort*S812* ERROR Field Value Type unknow %n\n", fieldValue->type);
        exit(OC_RTC_ERROR); 
		break;

	}
	return result;
}
int fieldValue_getGeneratedLength(struct fieldValue_t *fieldValue) {
/*
// verify if fix len - case 80:X
	if (fieldValue->nPadding == 1){	// case 80:X
		if ((unsigned int) fieldValue->generated_length > globalJob->outputLength)
			return (fieldValue->generated_length - globalJob->outputLength);	// padding
		else
			return (globalJob->outputLength - fieldValue->generated_length);	// padding
	}
*/
	return fieldValue->generated_length;
}
char *fieldValue_getGeneratedValue(struct fieldValue_t *fieldValue) {

	return fieldValue->generated_value;
}
