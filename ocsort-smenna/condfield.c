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
#include "file.h"
#include "job.h"
#include "condfield.h"
#include "ocsort.h"
#include "utils.h"
#include "fieldvalue.h"
#include "sortfield.h"
#include "sumfield.h" 
 
struct condField_t *condField_constructor_condition(int position, int length, int type, int condition, struct fieldValue_t *fieldValue) {
	struct condField_t *condField=(struct condField_t *)malloc(sizeof(struct condField_t));
	condField->type=COND_TYPE_CONDITION;
	condField->condition.position=position-1;
	condField->condition.length=length;
	condField->condition.type=type;
	condField->condition.condition=condition;
	condField->condition.fieldValue=fieldValue;
	if (fieldValue->generated_length !=  length)		// uniform length
		fieldValue->generated_length = length;
	condField->next=NULL; 
	return condField;
} 
struct condField_t *condField_constructor_operation(int operation, struct condField_t *first, struct condField_t *second) {
	struct condField_t *condField=(struct condField_t *)malloc(sizeof(struct condField_t));
	condField->type=COND_TYPE_OPERATION; 
	condField->operation.operation=operation;
	condField->operation.first=first;
	condField->operation.second=second;
	condField->next=NULL;
	return condField;
}

struct condField_t *condField_constructor_conditionfield(int position1, int length1, int type1, int condition, int position2, int length2, int type2) {
	struct condField_t *condField=(struct condField_t *)malloc(sizeof(struct condField_t));
	condField->type=COND_TYPE_COND_FIELDS;
	condField->condition_field.position1=position1-1;
	condField->condition_field.length1=length1;
	condField->condition_field.type1=type1;
	condField->condition_field.condition=condition;
	condField->condition_field.position2=position2-1;
	condField->condition_field.length2=length2;
	condField->condition_field.type2=type2;
	condField->next=NULL;
	return condField;
}

void condField_destructor(struct condField_t *condField) {

	struct fieldValue_t *fieldValue;
	struct condField_t  *condFieldTemp;
//
	if (condField->type == COND_TYPE_CONDITION) {
		fieldValue = condField->condition.fieldValue;
		if (fieldValue != NULL)
			fieldValue_destructor(fieldValue);
	} 
	if (condField->type == COND_TYPE_OPERATION) {
		condFieldTemp = condField->operation.first;
		if (condFieldTemp != NULL)
			condField_destructor(condFieldTemp);
		condFieldTemp = condField->operation.second;
		if (condFieldTemp != NULL)
			condField_destructor(condFieldTemp);
	}
	if (condField->type == COND_TYPE_COND_FIELDS) {
	}

//
	free(condField);
}
 
int condField_addDefinition(struct condField_t *condField) {
	condField_addQueue(&(globalJob->tmpCondField), condField);
	return 0;
}

int condField_addQueue(struct condField_t **condField, struct condField_t *condFieldToAdd) {
	struct condField_t *f;
	if (*condField==NULL) {
		*condField=condFieldToAdd;
	} else {
		for (f=*condField;f->next!=NULL;f=f->next);
		f->next=condFieldToAdd;
	}
	return 0;
}

struct condField_t *condField_getNext(struct condField_t *condField) {
	if (condField==NULL) {
		return NULL;
	} else {
		return condField->next;
	}}

int condField_print(struct condField_t *condField) {
	switch (condField->type) {
		case COND_TYPE_CONDITION:
			fprintf(stdout,"%d,%d,%s,%s,",
					condField->condition.position+1,
					condField->condition.length,
					utils_getFieldTypeName(condField->condition.type),
					utils_getCondConditionName(condField->condition.condition));
			fieldValue_print(condField->condition.fieldValue);
			break;
		case COND_TYPE_OPERATION:
			if (condField->operation.first != NULL)	{
				condField_print(condField->operation.first);
				fprintf(stdout,",%s,",utils_getCondOperationName(condField->operation.operation));
			}
			if (condField->operation.second != NULL)
				condField_print(condField->operation.second);
			break;
		case COND_TYPE_COND_FIELDS:
			fprintf(stdout,"%d,%d,%s,%s,%d,%d,%s",
					condField->condition_field.position1+1,
					condField->condition_field.length1,
					utils_getFieldTypeName(condField->condition_field.type1),
					utils_getCondConditionName(condField->condition_field.condition),
					condField->condition_field.position2+1,
					condField->condition_field.length2,
					utils_getFieldTypeName(condField->condition_field.type2));
			break;
		default:
			break;
	}
	return 0;
}
 
int condField_test(struct condField_t *condField, unsigned char *record, struct job_t* job) {
	int result;
	int nVerify; 
	char szBufVLSCMP[MAX_RECSIZE+1];
	int nTcmp = 0;
	switch (condField->type) {
		case COND_TYPE_CONDITION:
//
// check for option VLSCMP and VLSHRT 
// VLSCMP tells DFSORT that you want to temporarily replace any missing compare field bytes 
//		  with binary zeros, thus allowing the short fields to be validly compared 
//		  (the zeros are not kept for the output records). 
// OPTION COPY,VLSCMP
//  INCLUDE COND=(21,8,CH,EQ,C'Type 200')
// In this example, records less than 28 bytes are not included because the binary zeros 
//			added for the missing bytes in the field prevent it from being equal to 'Type 200'.
//
// VLSHRT tells DFSORT to treat any comparison involving a short field as false. 
//   OPTION COPY,VLSHRT
//  INCLUDE COND=(21,8,CH,EQ,C'Type 200')
// In this example, any records less than 28 bytes are not included.
//
			//
			nTcmp = 0;
			if (file_getOrganization(job->inputFile) != FILE_ORGANIZATION_LINESEQUENTIAL){
				if ((unsigned long)(condField->condition.position+condField->condition.length) > job->LenCurrRek) {
					if (job->nVLSCMP == 1) {
						memset(szBufVLSCMP, 0x00, MAX_RECSIZE);
						memcpy(szBufVLSCMP, record, job->LenCurrRek);
						nTcmp = 1;
					}

					if ((job->nVLSCMP == 0) && (job->nVLSHRT == 0)) {
						fprintf(stderr,"*OCSort*S100* OCSORT - ERROR : Record len:%ld < of condition(position):%ld, condition(length):%ld\n", job->LenCurrRek, condField->condition.position, condField->condition.length);
						fprintf(stderr,"*OCSort*S101* OCSORT - TERMINATED\n");
						exit(OC_RTC_ERROR);
					}
					else
						return 0;	// false condition
				}
			}
			if (nTcmp == 0)
				result=fieldValue_test((struct fieldValue_t *)condField->condition.fieldValue, (unsigned char*) record+condField->condition.position,condField->condition.length);
			else
				result=fieldValue_test((struct fieldValue_t *)condField->condition.fieldValue, (unsigned char*) szBufVLSCMP+condField->condition.position,condField->condition.length);
			switch (condField->condition.condition) {
				case COND_CONDITION_EQUAL:
					nVerify = (result==0);
					return (result==0);
				case COND_CONDITION_GREATERTHAN:
					return (result<0);
				case COND_CONDITION_GREATEREQUAL:
					return (result<=0);
				case COND_CONDITION_LESSERTHAN:
					return (result>0);
				case COND_CONDITION_LESSEREQUAL:
					return (result>=0);
				case COND_CONDITION_NOTEQUAL:
					return (result!=0);
				default:
					break;
			}
			break;
		case COND_TYPE_OPERATION:
			switch (condField->operation.operation) {
				case COND_OPERATION_AND:
					return (condField_test(condField->operation.first,record, job) && condField_test(condField->operation.second,record, job));
				case COND_OPERATION_OR:
					return (condField_test(condField->operation.first,record, job) || condField_test(condField->operation.second,record, job));
				default:
					break;
			}
			break;
// new
		case COND_TYPE_COND_FIELDS:
			result=condField_compare(condField, record);
			switch (condField->condition.condition) {
				case COND_CONDITION_EQUAL:
					nVerify = (result==0);
					return (result==0);
				case COND_CONDITION_GREATERTHAN:
					return (result<0);
				case COND_CONDITION_GREATEREQUAL:
					return (result<=0);
				case COND_CONDITION_LESSERTHAN:
					return (result>0);
				case COND_CONDITION_LESSEREQUAL:
					return (result>=0);
				case COND_CONDITION_NOTEQUAL:
					return (result!=0);
				default:
					break;
			}
			break;// new 
		default:
			break;
	}
	return 0;
}
/*
Permissible Field-to-Field Comparisons for INCLUDE/OMIT
=================================
Field Format| BI| CH| ZD| PD| FI|
=================================
	BI		| X	| X	| 	| 	|   |
	CH		| X	| X	| 	| 	|   |
	ZD		| 	| 	| X	| X	|   |
	PD		| 	| 	| X	| X	|   |
	FI		| 	| 	| 	| 	| X |
================================= 
*/

int condField_compare(struct condField_t *condField, unsigned char *record) {

	// GetValue for first field
	// GetValue for second field
	// compare value for condition
	unsigned char	szCharField1[OCSORT_MAX_BUFF_REK];
	unsigned char	szCharField2[OCSORT_MAX_BUFF_REK];

	int nRtc = 0;
	int result;

	nRtc = GetValueForType(condField, record, szCharField1, szCharField2);

	// assume same lenght
	// if (condField->condition_field.length1 != condField->condition_field.length2)

	result=memcmp((unsigned char*)szCharField1,(unsigned char*)szCharField2,condField->condition_field.length1);

	return result;
}

int GetValueForType(struct condField_t *condField, unsigned char *record, unsigned char* ValueChar1, unsigned char* ValueChar2) {

	int result=0;
	int nSp=0;
	switch (condField->condition_field.type1)
	 {
			case FIELD_TYPE_CHARACTER:
			case FIELD_TYPE_BINARY:
			case FIELD_TYPE_FIXED:
			case FIELD_TYPE_ZONED:
			case FIELD_TYPE_PACKED:
				memcpy(ValueChar1, (unsigned char*) record+condField->condition_field.position1, condField->condition_field.length1);
				break;
			default:
				break;
	}
//
	switch (condField->condition_field.type2)
	 {
			case FIELD_TYPE_CHARACTER:
			case FIELD_TYPE_BINARY:
			case FIELD_TYPE_FIXED:
			case FIELD_TYPE_ZONED:
			case FIELD_TYPE_PACKED:
				memcpy(ValueChar2, (unsigned char*) record+condField->condition_field.position2, condField->condition_field.length2);
				break;
			default:
				break;
	}
	return 0;
}

int condField_addInclude(struct condField_t *condField) {
	//-->>
	globalJob->includeCondField=condField;
	return 0;
}

int condField_addOmit(struct condField_t *condField) {
	//-->>
	globalJob->omitCondField=condField;
	return 0;
}


// FORMAT=xx set or all conditions
int condField_setCondFieldsTypeAll( int nTypeCond, int nVal) {
	struct condField_t *condField;
	if (nTypeCond == 1) // Include
	{
		if (globalJob->includeCondField != NULL)
		{
			for (condField=globalJob->includeCondField; condField!=NULL; condField=condField_getNext(condField)) {
				if (condField->type == COND_TYPE_CONDITION) // new for problem FORMAT=CH
					condField->condition.type = nVal;
			}
		}
	}
	if (nTypeCond == 2) // Omit
	{
		if (globalJob->omitCondField != NULL)
		{
			for (condField=globalJob->omitCondField; condField!=NULL; condField=condField_getNext(condField)) {
				if (condField->type == COND_TYPE_CONDITION) // new for problem FORMAT=CH
					condField->condition.type = nVal;
			}
		}
	}
	return 0;
}

// FORMAT=xx set or all Fields SORT / MERGE
int condField_setFormatFieldsTypeAll( int nTypeFormat, int nVal) {
//-->>nTypeFormat;			// 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields
//-->>nTypeIncludeOmit;		// 0= Nothing, 1 = Include, 2 = Omit

	struct sortField_t *sortField;
	struct SumField_t  *SumField;

	if (nTypeFormat == 1) {
		for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
			sortField->type = nVal;
		}
	}
	if (nTypeFormat == 3) // SumFields
	{
		for (SumField=globalJob->SumField; SumField!=NULL; SumField=SumField_getNext(SumField)) {
				SumField_setType(SumField, nVal);
		}
	}
	return 0;
}

