/*
    Copyright (C) 2016-2024 Sauro Menna
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


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <libcob.h>

#include "gcsort.h"
#include "libgcsort.h"
#include "fieldvalue.h"
#include "utils.h"
#include "job.h"
#include "outrec.h"

struct fieldValue_t *fieldValue_constructor(char *type, char *value, int nTypeF, int datetype) {
	int i,j;
	unsigned char buffer[3];
	struct fieldValue_t *fieldValue=(struct fieldValue_t *)malloc(sizeof(struct fieldValue_t));
	if (fieldValue == NULL) 
		utl_abend_terminate(MEMORYALLOC, 1010, ABEND_EXEC);

	fieldValue->datetype = datetype;
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
				if (nTypeF == TYPE_STRUCT_STD) {            /* NULL value */
					for(i=0;i<fieldValue->occursion;i++) {
						fieldValue->generated_value[i]=0;	/* original is OK from DFSORT Manual */
					}
					fieldValue->generated_value[fieldValue->generated_length]=0;
				}
				else
				{   /* TYPE_STRUCT_NEW  get value from param */
					strcpy(fieldValue->generated_value, value);
					fieldValue->generated_value[fieldValue->generated_length]=0;
					fieldValue->value64 = _atoi64(value);
				}
			break;
		case FIELD_VALUE_TYPE_Y:
			fieldValue->generated_length = fieldValue->occursion;
			fieldValue->generated_length = strlen(value);
			fieldValue->generated_value = (char*)malloc(sizeof(char) * fieldValue->generated_length + 1);
			if (fieldValue->generated_value == NULL)
				utl_abend_terminate(MEMORYALLOC, 1, ABEND_EXEC);
			strcpy(fieldValue->generated_value, value);
			fieldValue->generated_value[fieldValue->generated_length] = 0;
			/* TODO delete characters separator*/
			fieldValue->value64 = _atoi64(value);
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
			fprintf(stdout,"*GCSORT*S200*ERROR:  Field Type unknow %d\n", fieldValue->type);
            exit(GC_RTC_ERROR); 
			break;
	}
	fieldValue->pCobField.data = NULL;
	return fieldValue;
}
 
struct fieldValue_t *fieldValue_constr_newF(char *type, char *value, int nTypeF, int datetype) {
	int i;
	char szB1 [256];
	struct fieldValue_t *fieldValue=(struct fieldValue_t *)malloc(sizeof(struct fieldValue_t));
	fieldValue->datetype = datetype;
	if (fieldValue == NULL)
        utl_abend_terminate(MEMORYALLOC, 6, ABEND_EXEC);
	fieldValue->type=utils_parseFieldValueType(type[strlen(type)-1]);
	/* memset(szB1, 0x00, sizeof(szB1));*/
	memset(szB1, 0x00, 256);
	if (strlen(type) > 1) {
		memcpy(szB1, type, strlen(type)-1);	/* 36C'xx' */
		fieldValue->occursion=atoi(szB1);
	}
	else	
	{
		fieldValue->occursion=atoi(value);	/* 80:X		(padding blank record fix reclen = 80)  */
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
		case FIELD_VALUE_TYPE_Y:
			fieldValue->generated_length=fieldValue->occursion;
                fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
                if (fieldValue->generated_value == NULL)
                    utl_abend_terminate(MEMORYALLOC, 7, ABEND_EXEC);
				if (nTypeF == 0) {
					for(i=0;i<fieldValue->occursion;i++) {
						fieldValue->generated_value[i]=0;	/* original is OK from DFSORT Manual    */
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
		/* Date */
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
			fprintf(stdout,"*GCSORT*S201*ERROR: Field Value Type unknow %d\n", fieldValue->type);
            exit(GC_RTC_ERROR); 
			break;
	}
	fieldValue->pCobField.data = NULL;
	return fieldValue;
}

void fieldValue_destructor(struct fieldValue_t* fieldValue) {

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

/*
    first  parameter value from command
    second parameter value from record 
*/    
int fieldValue_checkvalue(struct job_t* job, struct fieldValue_t *fieldValue, cob_field* pField, int length) {
	/* s.m. 20250110 int used_length; */
	size_t used_length;
	int result;
	int64_t						mValue64 = 0;
	/* checktype of field for compare */
	used_length=(length<fieldValue->generated_length?length:fieldValue->generated_length);
	switch (fieldValue->type) {
		case FIELD_VALUE_TYPE_Z:
			mValue64 = fieldValue->value64;			/* condition    */
			int64_t t2 = cob_get_llint(pField);		/* record       */
			result = 0;
			if (t2 > mValue64)
				result = 1;
			if (t2 < mValue64)
				result = -1;
		break;
		/* Date
		   Y2T Fix len to working field - Zoned - size = digit = length
        */ 
		case FIELD_VALUE_TYPE_Y:
			job_cob_field_reset(job->g_ckfdate1, COB_TYPE_NUMERIC_DISPLAY, length, length);
			job_cob_field_reset(job->g_ckfdate2, COB_TYPE_NUMERIC_DISPLAY, length, length);
			cob_set_int(job->g_ckfdate2, (int)fieldValue->value64);							/* Command Condition				*/
			cob_move(pField, job->g_ckfdate1);											    /* Record Value                     */
			result = job_CheckTypeDate(FIELD_TYPE_NUMERIC_Y2T, (cob_field*)job->g_ckfdate1, (cob_field*)job->g_ckfdate2);
			break;

		case FIELD_VALUE_TYPE_X:
			result = memcmp((char*)pField->data, (char*)fieldValue->generated_value, used_length);
			break;

		case FIELD_VALUE_TYPE_C:
			result=memcmp((char*)pField->data, (char*)fieldValue->generated_value, used_length);
			break;
		default:
        fprintf(stdout,"*GCSORT*S202*ERROR: Field Value Type unknow %d\n", fieldValue->type);
        exit(GC_RTC_ERROR); 
		break;

	}
	return result;
}

/*
   case A
   verify if value of buffer is one of array
   Array is [value1,value2,value3,...]
   len of single element is equal length parameter
*/  
int fieldValue_ss_array(struct fieldValue_t *fieldValue, cob_field* pField, int length) {
	int n, nLenValue, nElements; 
	int res, bFound;
	/* s.m. 20250110 */
	nLenValue = (int) strlen((char*)fieldValue->generated_value);     /* len of array     */
    nElements = ((int)nLenValue / (length+1))+1;                     /* num of elements  */
    bFound=0;
    for(n=0; n < nElements; n++) {
        res = memcmp((char*)pField->data, (char*)fieldValue->generated_value+(n*(length+1)), length);
        if (res == 0) {
            bFound=1;
            break;
        }
    }
    return res;
}
/*
   case B
   search generated value into record
*/
int fieldValue_ss_value(struct fieldValue_t *fieldValue, cob_field* pField, int length) {
    int bFound, nLenBufA, nLenBufB;
    int n, res;
    res=1;
    nLenBufA = (int)pField->size;
    nLenBufB = (int)strlen((char*)fieldValue->generated_value);
    bFound=0;
    for(n=0; n<nLenBufA;n++){
        if (pField->data[n] != fieldValue->generated_value[0])      /* verify single char   */
            continue;
        if (n+nLenBufB > nLenBufA)
            break;
        res=memcmp(pField->data+n, fieldValue->generated_value, fieldValue->generated_length);
        if (res == 0) {
            bFound = 0;
            break;
        }
    }
    return res;
}

int fieldValue_checksubstring(struct fieldValue_t *fieldValue, cob_field* pField, int length) {
	int result;

    if (fieldValue->generated_length > length)      
        result = fieldValue_ss_array(fieldValue, pField, length);                                        /* search value */
    else
        result = fieldValue_ss_value(fieldValue, pField, length);                                        /* search array */
    return result;
}

int fieldValue_getGeneratedLength(struct fieldValue_t *fieldValue) {
	/* s.m. 20250110 */
	return (int)fieldValue->generated_length;
}
char *fieldValue_getGeneratedValue(struct fieldValue_t *fieldValue) {

	return fieldValue->generated_value;
}
