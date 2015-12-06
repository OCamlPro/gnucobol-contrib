/* 
 *  Copyright (C) 2009 Cedric ISSALY
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

#ifndef UTILS_H_INCLUDED
#define UTILS_H_INCLUDED

#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include "job.h"

#ifndef _WIN32
	#define NUMCHAREOL 1		// UNIX
#else
	#define NUMCHAREOL 2		// WINDOWS
#endif


#define FILE_TYPE_FIXED			0
#define FILE_TYPE_VARIABLE		1

#define FILE_ORGANIZATION_TEMP				0//0
#define FILE_ORGANIZATION_INDEXED			1//0
#define FILE_ORGANIZATION_RELATIVE			2//1
#define FILE_ORGANIZATION_SEQUENTIAL		3//2
#define FILE_ORGANIZATION_LINESEQUENTIAL	4//3
#define FILE_ORGANIZATION_SEQUENTIALMF		5//4


#define FILE_ORGTYPE_TMP		 0
#define FILE_ORGTYPE_IXFIX		10
#define FILE_ORGTYPE_IXVAR		11
#define FILE_ORGTYPE_RLFIX		20
#define FILE_ORGTYPE_RLVAR		21
#define FILE_ORGTYPE_SQFIX		30
#define FILE_ORGTYPE_SQVAR		31
#define FILE_ORGTYPE_LSFIX		40
#define FILE_ORGTYPE_LSVAR		41
#define FILE_ORGTYPE_SQFIXMF	50
#define FILE_ORGTYPE_SQVARMF	51


#define FIELD_TYPE_CHARACTER	0
#define FIELD_TYPE_BINARY		1
//s.m.
#define FIELD_TYPE_PACKED		2
//s.m.
#define FIELD_TYPE_ZONED		3
//s.m.
#define FIELD_TYPE_FIXED		4

#define SORT_DIRECTION_ASCENDING	0
#define SORT_DIRECTION_DESCENDING	1

#define COND_CONDITION_EQUAL			0
#define COND_CONDITION_GREATERTHAN		1
#define COND_CONDITION_GREATEREQUAL		2
#define COND_CONDITION_LESSERTHAN		3
#define COND_CONDITION_LESSEREQUAL		4
// NEW
#define COND_CONDITION_NOTEQUAL			5

#define COND_OPERATION_AND			0
#define COND_OPERATION_OR			1


#define FIELD_VALUE_TYPE_Z	0
#define FIELD_VALUE_TYPE_X	1
#define FIELD_VALUE_TYPE_C	2
#define FIELD_VALUE_TYPE_F	3 // FIXED



int utils_parseFileFormat(const char *format);
int utils_parseFileOrganization(const char *organization);
int utils_parseFieldType(const char *type);
int utils_parseFieldValueType(const char type);
int utils_parseSortDirection(const char *direction);
int utils_parseCondCondition(const char *condition);
int utils_parseCondOperation(const char *operation);

const char *utils_getFileFormatName(int format);
const char *utils_getFileOrganizationName(int organization);
const char *utils_getFieldTypeName(int type);
const char *utils_getFieldValueTypeName(int type);
const char *utils_getSortDirectionName(int direction);
const char *utils_getCondConditionName(int condition);
const char *utils_getCondOperationName(int operation);

int utils_setFieldTypInt(char * strType);

int utils_GenPadSize(int nLR);

unsigned short int Endian_Word_Conversion(unsigned short int word) ;
unsigned long int Endian_DWord_Conversion(unsigned long int dword) ;
int file_stat_win (char* filename );

#endif // UTILS_H_INCLUDED
