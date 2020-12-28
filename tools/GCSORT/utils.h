/*
    Copyright (C) 2016-2020 Sauro Menna
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

#ifndef UTILS_H_INCLUDED
#define UTILS_H_INCLUDED
 
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>

//#ifndef _WIN32
//#ifndef _MSC_VER
//-->>#if	!defined(__MINGW32__) && !defined(__MINGW64__)
#if	defined(__GNUC__) && !defined(__MINGW32__) && !defined(__MINGW64__)
	#include <unistd.h>
	#include <time.h>
	#include <strings.h>
	#define NUMCHAREOL 1		// UNIX
	typedef unsigned long DWORD;
	typedef unsigned short WORD;
	typedef unsigned int UNINT32;

	typedef unsigned char       BYTE;
	//typedef BYTE far            *LPBYTE;
	typedef BYTE             *LPBYTE;
	typedef BYTE             *PBYTE;
	typedef const char 	    *LPCSTR, *PCSTR;
	typedef long LONG;

	#if !defined(__MINGW32__) && !defined(__MINGW64__)
		typedef int HANDLE;
		#define INVALID_HANDLE_VALUE 0
		#define _S_IREAD	S_IREAD
		#define _S_IWRITE	S_IWRITE

		#define _O_TRUNC 	O_TRUNC
		#define _O_RDONLY	O_RDONLY
		#define _O_CREAT 	O_CREAT 
		#define _O_BINARY 	O_BINARY
		#define O_BINARY 	0
		#define _O_WRONLY   O_WRONLY
	#endif

	
	
	#define FALSE	0
	#define TRUE	1

	#define _atoi64 atoll
	#define _strdup strdup
	#define _open open
	#define _read read
	#define _close close
	#define _write write
	#define _stricmp strcasecmp
	#define strnicmp strncasecmp
	#define _strdup  strdup

#else
	#define NUMCHAREOL 2		// WINDOWS

#endif

#if defined(__MINGW32__) || defined(__MINGW64__)
	#include <fcntl.h>
	#include <windows.h>
	#include <sys/stat.h>
#endif

//#ifdef _MSC_VER
#if defined(_MSC_VER) 
  #define INLINE __forceinline /* use __forceinline (VC++ specific) */
#else
//fix for ubuntu envronment  #define INLINE __inline__ //			 inline        /* use standard inline */
  #define INLINE 
#endif

#include <libcob.h>
#include "job.h"
#include "outfil.h"


#define FILE_TYPE_FIXED			0
#define FILE_TYPE_VARIABLE		1

#define FILE_ORGANIZATION_TEMP				0//0
#define FILE_ORGANIZATION_INDEXED			1//0
#define FILE_ORGANIZATION_RELATIVE			2//1
#define FILE_ORGANIZATION_SEQUENTIAL		3//2
#define FILE_ORGANIZATION_LINESEQUENTIAL	4//3
#define FILE_ORGANIZATION_SEQUENTIALMF		5//4


#define FIELD_TYPE_CHARACTER	0
#define FIELD_TYPE_BINARY		1
#define FIELD_TYPE_PACKED		2
#define FIELD_TYPE_ZONED		3
#define FIELD_TYPE_FIXED		4
#define FIELD_TYPE_FLOAT        5
#define FIELD_TYPE_NUMERIC_CLO  6       // sign leading
#define FIELD_TYPE_NUMERIC_CSL  7       // sign leading separate
#define FIELD_TYPE_NUMERIC_CST  8       // sign trailing separate


#define SORT_DIRECTION_ASCENDING	0
#define SORT_DIRECTION_DESCENDING	1


#define KEY_IDX_PRIMARY				0
#define KEY_IDX_ALTERNATIVE			1
#define KEY_IDX_ALTERNATIVE_DUP		2
#define KEY_IDX_CONTINUE_DEF		3


#define COND_CONDITION_EQUAL			0
#define COND_CONDITION_GREATERTHAN		1
#define COND_CONDITION_GREATEREQUAL		2
#define COND_CONDITION_LESSERTHAN		3
#define COND_CONDITION_LESSEREQUAL		4
#define COND_CONDITION_NOTEQUAL			5
#define COND_CONDITION_SUBSTRING		6

#define COND_OPERATION_AND			0
#define COND_OPERATION_OR			1


#define FIELD_VALUE_TYPE_Z	0
#define FIELD_VALUE_TYPE_X	1
#define FIELD_VALUE_TYPE_C	2
#define FIELD_VALUE_TYPE_F	3 // FIXED

#define MAX_SLOT_SEEKENV  48
#define MAX_SLOT_SEEK	1
#define MAX_MLTP_BYTE	63


#define ALLOCATE_DATA	0
#define NOALLOCATE_DATA 1


#define MEMORYALLOC     1

#define ABEND_SKIP      1
#define ABEND_EXEC      2


#ifdef _WIN32
	#define charSep '\\'
	#define strSep  "\\"
#else
	#define charSep '/'
	#define strSep  "/"
#endif


int utils_parseFileFormat(const char *format);
int utils_parseFileOrganization(const char *organization);
int utils_parseFieldType(const char *type);
int utils_parseFieldValueType(const char type);
int utils_parseSortDirection(const char *direction);
int utils_parseCondCondition(const char *condition);
int utils_parseCondOperation(const char *operation);
int utils_parseKeyType(const char *keyType);

const char *utils_getFileFormatName(int format);
const char *utils_getFileOrganizationName(int organization);
const char *utils_getFieldTypeName(int type);
const char *utils_getFieldValueTypeName(int type);
const char *utils_getSortDirectionName(int direction);
const char *utils_getCondConditionName(int condition);
const char *utils_getCondOperationName(int operation);
const char* utils_getKeyType(int nkeyType);
int utils_SetOptionSort(char* optSort, struct outfil_t* outfil, int nValue);
int utils_SetOptionSortNum(char* optSort, int64_t nNum);
int utils_setFieldTypInt(char * strType);
void util_print_time_elap( const  char* szMex );
void util_covertToUpper(char *strIn, char* strOut);
// Function for cob_field & cob_field_attrib
cob_field* util_cob_field_make (int type, int digits, int scale, int flags, int nLen, int nData);
void util_cob_field_del (cob_field* field_ret, int nData);
int utils_getFieldTypeLIBCOBInt(int nInteralType, int nLen);
int utils_getFieldTypeLIBCOBFlags(int nInteralType);
void util_setAttrib ( cob_field_attr *attrArea, int type, int nLen);
void utl_abend_terminate(int nAbendType, int nCodeErr, int nTerminate);


//#ifndef _WIN32
#if defined(__GNUC__) && !defined(__MINGW32__) && !defined(__MINGW64__)
	unsigned long  GetTickCount(void);  
#endif


#endif // UTILS_H_INCLUDED
