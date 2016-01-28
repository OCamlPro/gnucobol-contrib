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

#include <string.h>
#include <stdio.h> 
#include <stdlib.h> 
#include <time.h>
// #ifdef _WIN32
#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	#include <windows.h>
#else
	#include <limits.h>
	#include <strings.h>
#endif

#include "libocsort.h"
#include "utils.h"

// s.m.
// inserita funzione per gestione del test case sensitive

// #ifdef _WIN32
/*
#ifdef _MSC_VER
int strcasecmp ( const char *str1, const char *str2) {
 	return _stricmp( str1, str2 );
}
#endif
*/
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
//future use	} else if (!strcasecmp(organization,"SQMF")) {		//SEQ MF
//future use		return FILE_ORGANIZATION_SEQUENTIALMF;
	} else {
		fprintf(stderr,"*OCSort*P001 - Error parsing organization : %s invalid\n", organization);
		return -1;
	}
}

int utils_parseFieldType(const char *type) {
	if (!strcasecmp(type,"CH")) {
		return FIELD_TYPE_CHARACTER;
	} else if (!strcasecmp(type,"BI")) {
		return FIELD_TYPE_BINARY;
// s.m.
	} else if (!strcasecmp(type,"PD")) {
		return FIELD_TYPE_PACKED;
	} else if (!strcasecmp(type,"ZD")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(type,"FI")) {
		return FIELD_TYPE_FIXED;
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
		case 'F':
			return FIELD_VALUE_TYPE_F;
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
	} else if (!strcasecmp(condition,"NE")) {
		return COND_CONDITION_NOTEQUAL;
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
//FUTURE USE		case FILE_ORGANIZATION_SEQUENTIALMF:
//FUTURE USE			return "SQMF";
		default:
			return "";
	}
}
int utils_getFieldTypeInt(char* strType) {
	if (!strcasecmp(strType,"CH")) {
		return FIELD_TYPE_CHARACTER;
	} else if (!strcasecmp(strType,"BI")) {
		return FIELD_TYPE_BINARY;
	} else if (!strcasecmp(strType,"PD")) {
		return FIELD_TYPE_PACKED;
	} else if (!strcasecmp(strType,"ZD")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(strType,"FI")) {
		return FIELD_TYPE_FIXED;
	}
	return -1;
}

const char *utils_getFieldTypeName(int type) {
	switch(type) {
		case FIELD_TYPE_CHARACTER:
			return "CH";
/* BI Binary
PIC 9(n) COMP|BINARY|COMP-4|COMP-5
		n = 1 to 4	len 2 BI
		n = 5 to 9	len	4 BI
		n >= 10		len	8 BI
*/
		case FIELD_TYPE_BINARY:
			return "BI";
/* Packed
PIC 9(n) COMP-3|PACKED-DECIMAL or 
PIC S9(n) COMP-3|PACKED-DECIMAL
	len (n/2)+1 PD
*/
		case FIELD_TYPE_PACKED:
			return "PD";
// s.m.
		case FIELD_TYPE_ZONED:
			return "ZD";
// 
/* FI Fixed 
	PIC S9(n) COMP|BINARY|COMP-4|COMP-5
		n = 1 to 4	len 2 FI
		n = 5 to 9	len 4 FI
		n >= 10		len 8 FI
*/			
		case FIELD_TYPE_FIXED:
			return "FI";
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
		case COND_CONDITION_NOTEQUAL:
			return "NE";
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

int utils_GenPadSize(int nLR)
{
	double n1, n2, nj;
	long   nk;
	int	   ny;

	n1 = nLR;
	n2 = SIZEINT;

	nj = n1/n2;
	nk = (long) (n1/n2);
	ny = (int) (nj*SIZEINT) - (nk*SIZEINT);
	if (ny > 0)
		ny = SIZEINT - ny;
	return ny;
}
unsigned short int Endian_Word_Conversion(unsigned short int word) {
   return ((word>>8)&0x00FF) | ((word<<8)&0xFF00)  ;
}
unsigned long int Endian_DWord_Conversion(unsigned long int dword) {
   return ((dword>>24)&0x000000FF) | ((dword>>8)&0x0000FF00) | ((dword<<8)&0x00FF0000) | ((dword<<24)&0xFF000000);
}

void util_print_time_elap( const char* szMex )
{
   time_t st;
   struct tm *info;
   time( &st );
   info = localtime( &st );
   fprintf(stdout,"%s - %s", szMex, asctime(info));

   //-->> printf("Current local time and date: %s", asctime(info));
	//-->>printf("%s - %04d-%02d-%02d %02d:%02d:%02d\n" , szMex,
	//-->>	info->tm_year,info->tm_mon,info->tm_mday, info->tm_hour,info->tm_min,info->tm_sec); //,st.wMilliseconds);

   return;
}
// #ifndef _WIN32

#if	defined(__GNUC__) && !defined(__MINGW32__) && !defined(__MINGW64__)
unsigned long GetTickCount(void) {
	if (globalJob->ndeb > 0) {
		struct timespec timenow;
		if (clock_gettime(CLOCK_MONOTONIC, &timenow))
					return 0;
		return timenow.tv_sec * 1000.0 + timenow.tv_nsec / 1000000.0;
	}
	return 0L;
}
#endif


int utils_SetOptionSortNum(char* optSort, int64_t nNum) {
	if (strcasecmp(optSort,"SKIPREC")==0)
			globalJob->nSkipRec=nNum;
	if (strcasecmp(optSort,"STOPAFT")==0)
			globalJob->nStopAft=nNum;
	return 0;
};

int utils_SetOptionSort(char* optSort) {

	if (!strcasecmp(optSort,"COPY")) {
			job_SetTypeOP('M');
			job_SetFieldCopy(1);
		return 0;
	} else if (!strcasecmp(optSort,"VLSCMP")) {
				globalJob->nVLSCMP = 1;
				return 0;
	} else if (!strcasecmp(optSort,"VLSHRT")) {
				globalJob->nVLSHRT = 1;
				return 0;
	} else {
		return -1;
	}
	return -1;
}
