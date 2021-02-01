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

#include <string.h>
#include <stdio.h> 
#include <stdlib.h> 
#include <time.h>
// #ifdef _WIN32
#if	defined(_MSC_VER) // s.m. 20201021 || defined(__MINGW32__) || defined(__MINGW64__)
	#include <windows.h>
#else
	#include <limits.h>
	#include <strings.h>
	#include <ctype.h>
#endif

#include <libcob.h>
#include "libgcsort.h"
#include "gcsort.h"
#include "utils.h"
#include "outfil.h"
#include "gcshare.h"

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
int utils_parseFileFormat(const char *format) 
{
if (!strcasecmp(format,"F")) {
		return FILE_TYPE_FIXED;
} else if (!strcasecmp(format,"V")) {
		return FILE_TYPE_VARIABLE;
	} else {
		return -1;
	}
}
int utils_parseFileOrganization(const char *organization) 
{
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
		fprintf(stderr,"*GCSORT*P001 - Error parsing organization : %s invalid\n", organization);
		return -1;
	}
}

// ==================================================== //
/*  Format Type Field   */
/*
                CH  Char            
                BI  Unisgned Binary
                FI  Signed Binary
                FL  Ploating Point
                PD  Packed
TI / OT / CTO / ZD  Zoned decimal  - sign trailing
      LI / OL / CLO Signed Numeric - sign lealing 
                CST Signed Numeric - trailing separate sign
           LS / CSL Signed Numeric - leading separate sign
             ???  FS / CSF Signed Numeric - with optional leading floating sign  (PIC +++9, PIC ----,...)
*/
// ==================================================== //
int utils_parseFieldType(const char *type) 
{
	if (!strcasecmp(type,"CH")) {
		return FIELD_TYPE_CHARACTER;
	} else if (!strcasecmp(type,"BI")) {
		return FIELD_TYPE_BINARY;
	} else if (!strcasecmp(type,"FI")) {
		return FIELD_TYPE_FIXED;
	} else if (!strcasecmp(type,"FL")) {
		return FIELD_TYPE_FLOAT;
	} else if (!strcasecmp(type,"PD")) {
		return FIELD_TYPE_PACKED;
// TI / OT / CTO / ZD  Zoned decimal  - sign trailing
	} else if (!strcasecmp(type,"ZD")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(type,"TI")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(type,"OT")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(type,"CTO")) {
		return FIELD_TYPE_ZONED;
// LI / OL / CLO Signed Numeric - sign lealing 
	} else if (!strcasecmp(type,"CLO")) {
		return FIELD_TYPE_NUMERIC_CLO;
	} else if (!strcasecmp(type,"LI")) {
		return FIELD_TYPE_NUMERIC_CLO;
	} else if (!strcasecmp(type,"OL")) {
		return FIELD_TYPE_NUMERIC_CLO;
//
// CST Signed Numeric - trailing separate sign
	} else if (!strcasecmp(type,"CST")) {
		return FIELD_TYPE_NUMERIC_CST;
	} else if (!strcasecmp(type,"TS")) {
		return FIELD_TYPE_NUMERIC_CST;
// 
//  LS / CSL Signed Numeric - leading separate sign
	} else if (!strcasecmp(type,"LS")) {
		return FIELD_TYPE_NUMERIC_CSL;
	} else if (!strcasecmp(type,"CSL")) {
		return FIELD_TYPE_NUMERIC_CSL;
//
	} else {
		return -1;
	}
}

int utils_getFieldTypeInt(char* strType) 
{
	if (!strcasecmp(strType,"CH")) {
		return FIELD_TYPE_CHARACTER;
	} else if (!strcasecmp(strType,"BI")) {
		return FIELD_TYPE_BINARY;
	} else if (!strcasecmp(strType,"FI")) {
		return FIELD_TYPE_FIXED;
	} else if (!strcasecmp(strType,"FL")) {
		return FIELD_TYPE_FLOAT;
	} else if (!strcasecmp(strType,"PD")) {
		return FIELD_TYPE_PACKED;
// TI / OT / CTO / ZD  Zoned decimal  - sign trailing
	} else if (!strcasecmp(strType,"ZD")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(strType,"TI")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(strType,"OT")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(strType,"CTO")) {
		return FIELD_TYPE_ZONED;
// LI / OL / CLO Signed Numeric - sign lealing 
	} else if (!strcasecmp(strType,"CLO")) {
		return FIELD_TYPE_NUMERIC_CLO;
	} else if (!strcasecmp(strType,"LI")) {
		return FIELD_TYPE_NUMERIC_CLO;
	} else if (!strcasecmp(strType,"OL")) {
		return FIELD_TYPE_NUMERIC_CLO;
//
// CST Signed Numeric - trailing separate sign
	} else if (!strcasecmp(strType,"CST")) {
		return FIELD_TYPE_NUMERIC_CST;
// 
//  LS / CSL Signed Numeric - leading separate sign
	} else if (!strcasecmp(strType,"LS")) {
		return FIELD_TYPE_NUMERIC_CSL;
	} else if (!strcasecmp(strType,"CSL")) {
		return FIELD_TYPE_NUMERIC_CSL;
	}
	return -1;
}



int utils_parseFieldValueType(const char type) 
{
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
int utils_parseSortDirection(const char *direction) 
{
	if (!strcasecmp(direction,"A")) {
		return SORT_DIRECTION_ASCENDING;
	} else if (!strcasecmp(direction,"D")) {
		return SORT_DIRECTION_DESCENDING;
	} else {
		return -1;
	}
}

int utils_parseKeyType(const char *keyType) 
{
	if (!strcasecmp(keyType,"P")) {
		return KEY_IDX_PRIMARY;
	} else if (!strcasecmp(keyType,"A")) {
		return KEY_IDX_ALTERNATIVE;
	} else if (!strcasecmp(keyType,"AD")) {
		return KEY_IDX_ALTERNATIVE_DUP;
	} else if (!strcasecmp(keyType,"C")) {
		return KEY_IDX_CONTINUE_DEF;
	} else {
		return -1;
	}
}

const char* utils_getKeyType(int nkeyType) 
{

	if (nkeyType == KEY_IDX_PRIMARY)
		return "P";
	if (nkeyType == KEY_IDX_ALTERNATIVE)
		return "A";
	if (nkeyType == KEY_IDX_ALTERNATIVE_DUP)
		return "AD";
	if (nkeyType == KEY_IDX_CONTINUE_DEF)
		return "C";
	return "";
}
 
int utils_parseCondCondition(const char *condition) 
{
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
	} else if (!strcasecmp(condition,"SS")) {
		return COND_CONDITION_SUBSTRING;
	} else {
		return -1;
	}
}

int utils_parseCondOperation(const char *operation) 
{
	if (!strcasecmp(operation,"AND")) {
		return COND_OPERATION_AND;
	} else if (!strcasecmp(operation,"OR")) {
		return COND_OPERATION_OR;
	} else {
		return -1;
	}
}


const char *utils_getFileFormatName(int format) 
{
	switch (format) {
		case FILE_TYPE_FIXED:
			return "FIXED";
		case FILE_TYPE_VARIABLE:
			return "VARIABLE";
		default:
			return "UNKNOWN";
	}
}
const char *utils_getFileOrganizationName(int organization) 
{
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


int utils_getFieldTypeLIBCOBInt(int nInteralType, int nLen) 
{
	switch (nInteralType) {
	case FIELD_TYPE_CHARACTER:
		return COB_TYPE_ALPHANUMERIC;
	case FIELD_TYPE_BINARY:
		return COB_TYPE_NUMERIC_BINARY;
	case FIELD_TYPE_FIXED:
		return COB_TYPE_NUMERIC_BINARY;
	case FIELD_TYPE_FLOAT:
		if (nLen > 4) 
			return COB_TYPE_NUMERIC_DOUBLE;
		else
			return COB_TYPE_NUMERIC_FLOAT;
	case FIELD_TYPE_PACKED:
		return COB_TYPE_NUMERIC_PACKED;
	case FIELD_TYPE_ZONED:
    case FIELD_TYPE_NUMERIC_CLO:       // sign leading
    case FIELD_TYPE_NUMERIC_CSL:       // sign leading separate
    case FIELD_TYPE_NUMERIC_CST:       // sign trailing separate
		return COB_TYPE_NUMERIC_DISPLAY;
	}
	return -1;
}

// From internal type get flags for create/setting cob_field
int utils_getFieldTypeLIBCOBFlags(int nInteralType) 
{
	switch (nInteralType) {
	case FIELD_TYPE_CHARACTER:
		return 0;
	case FIELD_TYPE_BINARY:
        return COB_FLAG_BINARY_SWAP;
		// 20160914 return 0;
	case FIELD_TYPE_FIXED:
        return COB_FLAG_HAVE_SIGN | COB_FLAG_BINARY_SWAP;
		// 20160914 return COB_FLAG_HAVE_SIGN ;
	case FIELD_TYPE_FLOAT:
		return COB_FLAG_HAVE_SIGN;
        // s.m. 20160925
        // return COB_FLAG_HAVE_SIGN | COB_FLAG_IS_FP;

	case FIELD_TYPE_PACKED:
        return COB_FLAG_HAVE_SIGN;    
	case FIELD_TYPE_ZONED:
		//-->> s.m. 20160914 return COB_FLAG_HAVE_SIGN;
        // Zoned for number 00001, +00001,-000001
        //-->>return COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_SEPARATE | COB_FLAG_SIGN_LEADING;      // s.m. 20160914 insert COB_FLAG_SIGN_LEADING
        return COB_FLAG_HAVE_SIGN ;      // s.m. 20160914 insert COB_FLAG_SIGN_LEADING problem with +/n zoned
//
    case  FIELD_TYPE_NUMERIC_CLO:         // sign leading
        return COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_LEADING;      
    case  FIELD_TYPE_NUMERIC_CSL:         // sign leading separate
        return COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_LEADING | COB_FLAG_SIGN_SEPARATE;      
    case  FIELD_TYPE_NUMERIC_CST:         // sign trailing separate
        return COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_SEPARATE;      
//
	}
	return -1;
}


const char *utils_getFieldTypeName(int type) 
{
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
		case FIELD_TYPE_FLOAT:
			return "FL";
		case FIELD_TYPE_NUMERIC_CLO:
			return "CLO";
        case FIELD_TYPE_NUMERIC_CSL:
			return "CSL";
        case FIELD_TYPE_NUMERIC_CST:
			return "CST";

		default:
			fprintf(stderr, "* utils_getFieldTypeName*  : %d\n", type);
			return "";

	}
}
const char *utils_getSortDirectionName(int direction)
{
	switch (direction) {
		case SORT_DIRECTION_ASCENDING:
			return "A";
		case SORT_DIRECTION_DESCENDING:
			return "D";
		default:
			return "";
	}
}
const char *utils_getCondConditionName(int condition)
{
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
		case COND_CONDITION_SUBSTRING:
			return "SS";
		default:
			return "";
	}
}
const char *utils_getCondOperationName(int operation)
{
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

/*
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
*/
/*
unsigned short int Endian_Word_Conversion(unsigned short int word) 
{
   return ((word>>8)&0x00FF) | ((word<<8)&0xFF00)  ;
}
unsigned long int Endian_DWord_Conversion(unsigned long int dword)
{
   return ((dword>>24)&0x000000FF) | ((dword>>8)&0x0000FF00) | ((dword<<8)&0x00FF0000) | ((dword<<24)&0xFF000000);
}
*/
void util_print_time_elap( const char* szMex )
{
   time_t st;
   struct tm *info;
   time( &st );
   info = localtime( &st );
   fprintf(stdout,"%s - %s", szMex, asctime(info));
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


int utils_SetOptionSortNum(char* optSort, int64_t nNum)
{
	if (strcasecmp(optSort,"SKIPREC")==0)
			globalJob->nSkipRec=nNum;
	if (strcasecmp(optSort,"STOPAFT")==0)
			globalJob->nStopAft=nNum;
	return 0;
};

int utils_SetOptionSort(char* optSort, struct outfil_t* outfil, int nValue) 
{

    if (!strcasecmp(optSort,"SPLIT")) {
            outfil->nSplit=1;
            outfil->nRecSplit=1;
    }
    if (!strcasecmp(optSort,"SPLITBY")) {
            outfil->nSplit=1;
            outfil->nRecSplit=nValue;
    }

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

void util_covertToUpper(char *strIn, char* strOut)
{
    char* pIn;
	char* pOut;
    pIn =strIn;
	pOut=strOut;
    while(*pIn != 0x00) {
		*pOut=toupper(*pIn);
		pIn++;
		pOut++;
	}
    return ;
}


void util_setAttrib ( cob_field_attr *attrArea, int type, int nLen)
{
// fix value for single type of field
	switch (type) {
        case COB_TYPE_ALPHANUMERIC_ALL:
        case COB_TYPE_ALPHANUMERIC:
            attrArea->digits = 0;
            attrArea->scale = 0;
            break;
	    case COB_TYPE_NUMERIC_BINARY:
            if (nLen <= 2)
                attrArea->digits = 4;   //        
            if ((nLen > 2) && (nLen <= 4))
                attrArea->digits = 9;   //        
            if (nLen > 4) 
                attrArea->digits = 18;   //       
            attrArea->scale = 0;
            break;
	    case COB_TYPE_NUMERIC_DOUBLE:
            attrArea->digits = 34;
            attrArea->scale = 17;
            attrArea->flags  = attrArea->flags | COB_FLAG_IS_FP | COB_FLAG_HAVE_SIGN;
            break;
	    case COB_TYPE_NUMERIC_FLOAT:
            attrArea->digits = 15;
            attrArea->scale = 8;
           attrArea->flags  = attrArea->flags | COB_FLAG_IS_FP | COB_FLAG_HAVE_SIGN;
            break;
        case COB_TYPE_NUMERIC_PACKED:
             if (nLen <= 1) 
                attrArea->digits = nLen*2;
             else
             {
                if (nLen % 2 == 0)
    		    	attrArea->digits = (nLen*2)-1; //(nLen-1)*2;
			    else
	    	    	attrArea->digits = (nLen*2)-1;
             }
            attrArea->scale = 0;
    	    attrArea->flags  = attrArea->flags | COB_FLAG_HAVE_SIGN;
            break;
        case COB_TYPE_NUMERIC_DISPLAY:
            //s.m. 20210121 attrArea->digits = 0;
            attrArea->scale = 0;
// s.m. 20201015
    	    attrArea->flags  = attrArea->flags | COB_FLAG_HAVE_SIGN;
// s.m. 20201015
            break;
		default:
			fprintf(stdout, "util_setAttrib - type not found %d \n", type);
			exit(GC_RTC_ERROR);
			return ;
	}

    return;//
}

 cob_field* util_cob_field_make (int type, int digits, int scale, int flags, int nLen, int nData)
{
	cob_field       *field_ret;
	cob_field_attr	*attrArea;
	attrArea = (cob_field_attr*) malloc(sizeof(cob_field_attr));
    if (attrArea == NULL)
        utl_abend_terminate(MEMORYALLOC, 11, ABEND_EXEC);
	attrArea->type   = type;
	attrArea->digits = digits;
	attrArea->scale  = scale;
	attrArea->flags  = flags;
	attrArea->pic    = NULL;
	field_ret = (cob_field*)malloc(sizeof(cob_field));
    if (field_ret == NULL)
        utl_abend_terminate(MEMORYALLOC, 12, ABEND_EXEC);
	field_ret->attr = attrArea;
	field_ret->data = NULL;
	if (nData == ALLOCATE_DATA) {
		field_ret->data = (unsigned char*) malloc((sizeof(unsigned char)*nLen)+1);
        if (field_ret->data == NULL)
            utl_abend_terminate(MEMORYALLOC, 13, ABEND_EXEC);
		memset(field_ret->data, 0x00, nLen);
	}
	field_ret->size = nLen;
    util_setAttrib(attrArea, type, nLen);
	return field_ret;
}
void util_cob_field_del ( cob_field* field_ret, int nData)
{
	if (field_ret!=NULL) {
		if (field_ret->attr!=NULL)
				free((void*)field_ret->attr); 
		if (nData == ALLOCATE_DATA) {
			if (field_ret->data!=NULL)
				free(field_ret->data); 
		}
		free(field_ret);  
	}
}

void utl_abend_terminate(int nAbendType, int nCodeErr, int nTerminate)
{
	switch (nAbendType) {
    case MEMORYALLOC:
        fprintf(stderr,"*GCSORT* ERROR: Aborting execution for problems with memory allocation. Code : %d\n", nCodeErr);
        break;
    default:
        fprintf(stderr,"*GCSORT* ERROR: Aborting execution.  Code : %d\n", nCodeErr);
        break;
    }
    if (nTerminate == ABEND_EXEC)
        exit(GC_RTC_ERROR);       
    return;
}
