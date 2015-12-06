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

#include <string.h>
#include "utils.h"

int utils_parseFileFormat(const char *format) {
	if (!strcasecmp(format,"F")) {
		return FILE_TYPE_FIXED;
	} else if (!strcasecmp(format,"V")) {
		return FILE_TYPE_VARIABLE;
	} else {
		return -1;
	}
}
int utils_parseFileOrganization(const char *organization) {
	if (!strcasecmp(organization,"IX")) {
		return FILE_ORGANIZATION_INDEXED;
	} else if (!strcasecmp(organization,"RL")) {
		return FILE_ORGANIZATION_RELATIVE;
	} else if (!strcasecmp(organization,"SQ")) {
		return FILE_ORGANIZATION_SEQUENTIAL;
	} else if (!strcasecmp(organization,"LS")) {
		return FILE_ORGANIZATION_LINESEQUENTIAL;
	} else {
		return -1;
	}
}

int utils_parseFieldType(const char *type) {
	if (!strcasecmp(type,"CH")) {
		return FIELD_TYPE_CHARACTER;
	} else if (!strcasecmp(type,"BI")) {
		return FIELD_TYPE_BINARY;
	} else {
		return -1;
	}
}
int utils_parseFieldValueType(const char type) {
	switch (type) {
		case 'Z':
			return FIELD_VALUE_TYPE_Z;
		case 'X':
			return FIELD_VALUE_TYPE_X;
		case 'C':
			return FIELD_VALUE_TYPE_C;
		default:
			return -1;
	}
}
int utils_parseSortDirection(const char *direction) {
	if (!strcasecmp(direction,"A")) {
		return SORT_DIRECTION_ASCENDING;
	} else if (!strcasecmp(direction,"D")) {
		return SORT_DIRECTION_DESCENDING;
	} else {
		return -1;
	}
}


int utils_parseCondCondition(const char *condition) {
	if (!strcasecmp(condition,"EQ")) {
		return COND_CONDITION_EQUAL;
	} else if (!strcasecmp(condition,"GT")) {
		return COND_CONDITION_GREATERTHAN;
	} else if (!strcasecmp(condition,"GE")) {
		return COND_CONDITION_GREATEREQUAL;
	} else if (!strcasecmp(condition,"LT")) {
		return COND_CONDITION_LESSERTHAN;
	} else if (!strcasecmp(condition,"LE")) {
		return COND_CONDITION_LESSEREQUAL;
	} else {
		return -1;
	}
}

int utils_parseCondOperation(const char *operation) {
	if (!strcasecmp(operation,"AND")) {
		return COND_OPERATION_AND;
	} else if (!strcasecmp(operation,"OR")) {
		return COND_OPERATION_OR;
	} else {
		return -1;
	}
}


const char *utils_getFileFormatName(int format) {
	switch (format) {
		case FILE_TYPE_FIXED:
			return "FIXED";
		case FILE_TYPE_VARIABLE:
			return "VARIABLE";
		default:
			return "UNKNOWN";
	}
}
const char *utils_getFileOrganizationName(int organization) {
	switch (organization) {
		case FILE_ORGANIZATION_INDEXED:
			return "IX";
		case FILE_ORGANIZATION_RELATIVE:
			return "RL";
		case FILE_ORGANIZATION_SEQUENTIAL:
			return "SQ";
		case FILE_ORGANIZATION_LINESEQUENTIAL:
			return "LS";
		default:
			return "";
	}
}
const char *utils_getFieldTypeName(int type) {
	switch(type) {
		case FIELD_TYPE_CHARACTER:
			return "CH";
		case FIELD_TYPE_BINARY:
			return "BI";
		default:
			return "";

	}
}
const char *utils_getSortDirectionName(int direction) {
	switch (direction) {
		case SORT_DIRECTION_ASCENDING:
			return "A";
		case SORT_DIRECTION_DESCENDING:
			return "D";
		default:
			return "";
	}
}
const char *utils_getCondConditionName(int condition) {
	switch (condition) {
		case COND_CONDITION_EQUAL:
			return "EQ";
		case COND_CONDITION_GREATERTHAN:
			return "GT";
		case COND_CONDITION_GREATEREQUAL:
			return "GE";
		case COND_CONDITION_LESSERTHAN:
			return "LT";
		case COND_CONDITION_LESSEREQUAL:
			return "LE";
		default:
			return "";
	}
}
const char *utils_getCondOperationName(int operation) {
		switch (operation) {
			case COND_OPERATION_AND:
				return "AND";
			case COND_OPERATION_OR:
				return "OR";
			default:
				return "";
		}
}
const char *utils_getFieldValueTypeName(int type) {
	switch (type) {
		case FIELD_VALUE_TYPE_Z:
			return "Z";
		case FIELD_VALUE_TYPE_X:
			return "X";
		case FIELD_VALUE_TYPE_C:
			return "C";
		default:
			return " ";
	};
}
