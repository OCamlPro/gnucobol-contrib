/*
 *  Copyright (C) 2009 Cedric ISSALY
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




struct fieldValue_t {
	//Parsed
	int occursion;
	int type;
	char *value;
	//Generated
	int generated_length;
	char *generated_value;
};

struct fieldValue_t *fieldValue_constructor(char *type, char *value) {
	int i,j;
	char buffer[3];
	struct fieldValue_t *fieldValue=(struct fieldValue_t *)malloc(sizeof(struct fieldValue_t));
	fieldValue->type=utils_parseFieldValueType(type[strlen(type)-1]);

	if (strlen(type)>1) {
		type[strlen(type)-1]=0;
		fieldValue->occursion=atoi(type);
	} else {
		fieldValue->occursion=1;
	}
	fieldValue->value=value;

	switch (fieldValue->type) {
		case FIELD_VALUE_TYPE_Z:
				fieldValue->generated_length=fieldValue->occursion;
				fieldValue->generated_value=(char *)malloc(sizeof(char)*fieldValue->generated_length+1);
				for(i=0;i<fieldValue->occursion;i++) {
					fieldValue->generated_value[i]=0;
				}
				fieldValue->generated_value[fieldValue->generated_length]=0;
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
					for(j=0;j<strlen(value)/2;j++) {
						buffer[0]=value[2*j];
						buffer[1]=value[2*j+1];
						fieldValue->generated_value[i*strlen(value)/2+j]=strtol(buffer,NULL,16);
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
			printf("WARNING\n");
			break;
	}
	return fieldValue;
}
int fieldValue_print(struct fieldValue_t *fieldValue) {
	if (fieldValue->occursion>1) {
		printf("%d",fieldValue->occursion);
	}
	printf("%s",utils_getFieldValueTypeName(fieldValue->type));
	if (strlen(fieldValue->value)>0) {
		printf("'%s'",fieldValue->value);
	}
 	return 0;
}
int fieldValue_test(struct fieldValue_t *fieldValue, char *record, int length) {
	int used_length;
	int result;
	used_length=(length<fieldValue->generated_length?length:fieldValue->generated_length);
	result=memcmp(fieldValue->generated_value,record,used_length);
	return result;
}
int fieldValue_getGeneratedLength(struct fieldValue_t *fieldValue) {
	return fieldValue->generated_length;
}
char *fieldValue_getGeneratedValue(struct fieldValue_t *fieldValue) {
	return fieldValue->generated_value;
}
