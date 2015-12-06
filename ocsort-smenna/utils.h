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

#ifndef UTILS_H_INCLUDED
#define UTILS_H_INCLUDED

#define FILE_TYPE_FIXED			0
#define FILE_TYPE_VARIABLE		1

#define FILE_ORGANIZATION_INDEXED			0
#define FILE_ORGANIZATION_RELATIVE			1
#define FILE_ORGANIZATION_SEQUENTIAL		2
#define FILE_ORGANIZATION_LINESEQUENTIAL	3


#define FIELD_TYPE_CHARACTER	0
#define FIELD_TYPE_BINARY		1

#define SORT_DIRECTION_ASCENDING	0
#define SORT_DIRECTION_DESCENDING	1

#define COND_CONDITION_EQUAL			0
#define COND_CONDITION_GREATERTHAN		1
#define COND_CONDITION_GREATEREQUAL		2
#define COND_CONDITION_LESSERTHAN		3
#define COND_CONDITION_LESSEREQUAL		4

#define COND_OPERATION_AND			0
#define COND_OPERATION_OR			1


#define FIELD_VALUE_TYPE_Z	0
#define FIELD_VALUE_TYPE_X	1
#define FIELD_VALUE_TYPE_C	2



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


#endif // UTILS_H_INCLUDED
