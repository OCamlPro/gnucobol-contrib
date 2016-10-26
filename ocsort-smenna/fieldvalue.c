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

#include <libcob.h>

#include "ocsort.h"
#include "libocsort.h"
#include "fieldvalue.h"
#include "utils.h"
#include "job.h"
#include "outrec.h"


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
	
	if (strlen(fieldValue->value) > 0) {
		job_RescanCmdSpecialChar(fieldValue->value);
		job_RescanCmdSpecialChar(value);
	}
	else
		fieldValue->occursion=1;

		switch (fieldValue->type) {
		case FIELD_VALUE_TYPE_Z:
				fieldValue->generated_length=fieldValue->occursion;
				fieldValue->generated_length = strlen(value);
                fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
                if (fieldValue->generated_value == NULL)
                    utl_abend_terminate(MEMORYALLOC, 1, ABEND_EXEC);
				if (nTypeF == TYPE_STRUCT_STD) {            // NULL value
					for(i=0;i<fieldValue->occursion;i++) {
						fieldValue->generated_value[i]=0;	// original is OK from DFSORT Manual
					}
					fieldValue->generated_value[fieldValue->generated_length]=0;
				}
				else
				{   // TYPE_STRUCT_NEW  get value from param
					strcpy(fieldValue->generated_value, value);
					fieldValue->generated_value[fieldValue->generated_length]=0;
					fieldValue->value64 = _atoi64(value);
				}
			break;
		case FIELD_VALUE_TYPE_X:
			if (strlen(value)==0) {
				fieldValue->generated_length=fieldValue->occursion;
				fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
                if (fieldValue->generated_value == NULL)
                    utl_abend_terminate(MEMORYALLOC, 2, ABEND_EXEC);
				for(i=0;i<fieldValue->occursion;i++) {
					fieldValue->generated_value[i]=' ';
				}
				fieldValue->generated_value[fieldValue->generated_length]=0;
			} else {
				fieldValue->generated_length=fieldValue->occursion*strlen(value)/2;
				fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
                if (fieldValue->generated_value == NULL)
                    utl_abend_terminate(MEMORYALLOC, 3, ABEND_EXEC);
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
            if (fieldValue->generated_value == NULL)
                    utl_abend_terminate(MEMORYALLOC, 5, ABEND_EXEC);
			for(i=0;i<fieldValue->occursion;i++) {
				memcpy(fieldValue->generated_value+i*strlen(value),value,strlen(value));
			}
			fieldValue->generated_value[fieldValue->generated_length]=0;
			break;
		default:
			fprintf(stdout,"*OCSort*S200*ERROR:  Field Type unknow %d\n", fieldValue->type);
            exit(OC_RTC_ERROR); 
			break;
	}
	fieldValue->pCobField.data = NULL;
	return fieldValue;
}
 
struct fieldValue_t *fieldValue_constr_newF(char *type, char *value, int nTypeF) {
	int i;
	char szB1 [256];
	struct fieldValue_t *fieldValue=(struct fieldValue_t *)malloc(sizeof(struct fieldValue_t));
    if (fieldValue == NULL)
        utl_abend_terminate(MEMORYALLOC, 6, ABEND_EXEC);
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
                fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
                if (fieldValue->generated_value == NULL)
                    utl_abend_terminate(MEMORYALLOC, 7, ABEND_EXEC);
				if (nTypeF == 0) {
					for(i=0;i<fieldValue->occursion;i++) {
						fieldValue->generated_value[i]=0;	// original is OK from DFSORT Manual
					}
					fieldValue->generated_value[fieldValue->generated_length]=0;
				}
				else
				{
					strcpy(fieldValue->generated_value, value);
					fieldValue->generated_value[fieldValue->generated_length]=0;
					fieldValue->value64 = _atoi64(value);
				}
		break;
		case FIELD_VALUE_TYPE_X:
				fieldValue->generated_length=fieldValue->occursion;
				fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
                if (fieldValue->generated_value == NULL)
                    utl_abend_terminate(MEMORYALLOC, 8, ABEND_EXEC);
				for(i=0;i<fieldValue->occursion;i++) {
					fieldValue->generated_value[i]=' ';
				}
				fieldValue->generated_value[fieldValue->generated_length]=0;
			break;
		case FIELD_VALUE_TYPE_C:
			fieldValue->generated_length=fieldValue->occursion*strlen(value);
			fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
                if (fieldValue->generated_value == NULL)
                    utl_abend_terminate(MEMORYALLOC, 9, ABEND_EXEC);
			for(i=0;i<fieldValue->occursion;i++) {
				memcpy(fieldValue->generated_value+i*strlen(value),value,strlen(value));
			}
			fieldValue->generated_value[fieldValue->generated_length]=0;
           
			break;
		default:
			fprintf(stdout,"*OCSort*S201*ERROR: Field Value Type unknow %d\n", fieldValue->type);
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

int fieldValue_checkvalue(struct fieldValue_t *fieldValue, cob_field* pField, int length) {
	int used_length;
	int result;
	int64_t						mValue64 = 0;
    int                         mValueint=0;
	int lenFieldSize	= 0;
	int lenFieldDigit	= 0;
	// checktype of field for compare 
	used_length=(length<fieldValue->generated_length?length:fieldValue->generated_length);
	switch (fieldValue->type) {
		case FIELD_VALUE_TYPE_Z:
            result = cob_cmp_llint(pField, fieldValue->value64);
            result = result*-1;
		break;

		case FIELD_VALUE_TYPE_X:
            result=memcmp((char*)fieldValue->generated_value,(char*)pField->data, used_length);
             
		break;
		case FIELD_VALUE_TYPE_C:
            result=memcmp((char*)fieldValue->generated_value,(char*)pField->data, used_length);
		break;
		default:
        fprintf(stdout,"*OCSort*S202*ERROR: Field Value Type unknow %d\n", fieldValue->type);
        exit(OC_RTC_ERROR); 
		break;

	}
	return result;
}

int fieldValue_getGeneratedLength(struct fieldValue_t *fieldValue) {
	return fieldValue->generated_length;
}
char *fieldValue_getGeneratedValue(struct fieldValue_t *fieldValue) {

	return fieldValue->generated_value;
}
