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
#include <sys/stat.h>
/* #ifdef _WIN32    */
#if	defined(_MSC_VER) /* s.m. 20201021 || defined(__MINGW32__) || defined(__MINGW64__)  */
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
#include "file.h"
#include "outfil.h"
#include "exitroutines.h"
#include "gcshare.h"

/* s.m.                                                     */
/* inserita funzione per gestione del test case sensitive   */


int utl_counter = 0;

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
	} else if (!strcasecmp(organization, "LSF")) {
		return FILE_ORGANIZATION_LINESEQUFIXED;
		/* future use	} else if (!strcasecmp(organization,"SQMF")) {		//SEQ MF    */
/* future use		return FILE_ORGANIZATION_SEQUENTIALMF;                      */
	} else {
		fprintf(stdout,"*GCSORT*P001 - Error parsing organization : %s invalid\n", organization);
		return -1;
	}
}
/* convert organization from GCSort to GNUCobol - LibCob */
int utl_fileConvertFileType(int organization) {
	switch (organization) {
	case FILE_ORGANIZATION_TEMP:			/* 0 */
		return -1;
	case FILE_ORGANIZATION_INDEXED:			/* 1 */
		return COB_ORG_INDEXED;
	case FILE_ORGANIZATION_RELATIVE:		/* 2 */
		return COB_ORG_RELATIVE;
	case FILE_ORGANIZATION_SEQUENTIAL:		/* 3 */
		return COB_ORG_SEQUENTIAL;
	case FILE_ORGANIZATION_LINESEQUENTIAL:	/* 4 */
		return COB_ORG_LINE_SEQUENTIAL;
	case FILE_ORGANIZATION_SEQUENTIALMF:	/* 5 */
		return COB_ORG_LINE_SEQUENTIAL;
	case FILE_ORGANIZATION_LINESEQUFIXED:	/* 6 */
		return COB_ORG_LINE_SEQUENTIAL;
	}
	return -1;
}

/* ==================================================== */
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
/* ==================================================== */
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
/* TI / OT / CTO / ZD  Zoned decimal  - sign trailing   */
	} else if (!strcasecmp(type,"ZD")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(type,"TI")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(type,"OT")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(type,"CTO")) {
		return FIELD_TYPE_ZONED;
/* LI / OL / CLO Signed Numeric - sign lealing  */
	} else if (!strcasecmp(type,"CLO")) {
		return FIELD_TYPE_NUMERIC_CLO;
	} else if (!strcasecmp(type,"LI")) {
		return FIELD_TYPE_NUMERIC_CLO;
	} else if (!strcasecmp(type,"OL")) {
		return FIELD_TYPE_NUMERIC_CLO;
/* CST Signed Numeric - trailing separate sign  */
	} else if (!strcasecmp(type,"CST")) {
		return FIELD_TYPE_NUMERIC_CST;
	} else if (!strcasecmp(type,"TS")) {
		return FIELD_TYPE_NUMERIC_CST;
/*  LS / CSL Signed Numeric - leading separate sign */
	} else if (!strcasecmp(type,"LS")) {
		return FIELD_TYPE_NUMERIC_CSL;
	} else if (!strcasecmp(type,"CSL")) {
		return FIELD_TYPE_NUMERIC_CSL;
/* Date */
	} else if (!strcasecmp(type, "Y2T")) {
		return FIELD_TYPE_NUMERIC_Y2T;
		
	}	else if (!strcasecmp(type, "Y2B")) {
		return FIELD_TYPE_NUMERIC_Y2B;
		
	}
	else if (!strcasecmp(type, "Y2C")) {
		return FIELD_TYPE_NUMERIC_Y2C;
		
	}
	else if (!strcasecmp(type, "Y2D")) {
		return FIELD_TYPE_NUMERIC_Y2D;
		
	}
	else if (!strcasecmp(type, "Y2P")) {
		return FIELD_TYPE_NUMERIC_Y2P;
		
	}
	else if (!strcasecmp(type, "Y2S")) {
		return FIELD_TYPE_NUMERIC_Y2S;
		
	}
	else if (!strcasecmp(type, "Y2U")) {
		return FIELD_TYPE_NUMERIC_Y2U;
		
	}
	else if (!strcasecmp(type, "Y2V")) {
		return FIELD_TYPE_NUMERIC_Y2V;
		
	}
	else if (!strcasecmp(type, "Y2X")) {
		return FIELD_TYPE_NUMERIC_Y2X;
		
	}
	else if (!strcasecmp(type, "Y2Y")) {
		return FIELD_TYPE_NUMERIC_Y2Y;
		
	}
	else if (!strcasecmp(type, "Y2Z")) {
		return FIELD_TYPE_NUMERIC_Y2Z;
		
	} 
	else if (!strcasecmp(type, "SS")) {
		return FIELD_TYPE_SUBSTRING;

	}
	else if (!strcasecmp(type, "UFF")) {
		return FIELD_TYPE_UNSIGNEDFF;

	}
	else if (!strcasecmp(type, "SFF")) {
		return FIELD_TYPE_SIGNEDFF;

	}
	else {
		fprintf(stdout,"*GCSORT*P002 - Error parsing datatye : %s invalid\n", type);
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
/* TI / OT / CTO / ZD  Zoned decimal  - sign trailing   */
	} else if (!strcasecmp(strType,"ZD")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(strType,"TI")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(strType,"OT")) {
		return FIELD_TYPE_ZONED;
	} else if (!strcasecmp(strType,"CTO")) {
		return FIELD_TYPE_ZONED;
/* LI / OL / CLO Signed Numeric - sign lealing */
	} else if (!strcasecmp(strType,"CLO")) {
		return FIELD_TYPE_NUMERIC_CLO;
	} else if (!strcasecmp(strType,"LI")) {
		return FIELD_TYPE_NUMERIC_CLO;
	} else if (!strcasecmp(strType,"OL")) {
		return FIELD_TYPE_NUMERIC_CLO;
/* CST Signed Numeric - trailing separate sign  */
	} else if (!strcasecmp(strType,"CST")) {
		return FIELD_TYPE_NUMERIC_CST;
/*  LS / CSL Signed Numeric - leading separate sign */
	} else if (!strcasecmp(strType,"LS")) {
		return FIELD_TYPE_NUMERIC_CSL;
	} else if (!strcasecmp(strType,"CSL")) {
		return FIELD_TYPE_NUMERIC_CSL;
	}
	/* date */
	else if (!strcasecmp(strType, "Y2T")) {
		return FIELD_TYPE_NUMERIC_Y2T;
	}
	else if (!strcasecmp(strType, "Y2B")) {
		return FIELD_TYPE_NUMERIC_Y2B;
	}
	else if (!strcasecmp(strType, "Y2C")) {
		return FIELD_TYPE_NUMERIC_Y2C;
	}
	else if (!strcasecmp(strType, "Y2D")) {
		return FIELD_TYPE_NUMERIC_Y2D;
	}
	else if (!strcasecmp(strType, "Y2P")) {
		return FIELD_TYPE_NUMERIC_Y2P;
	}
	else if (!strcasecmp(strType, "Y2S")) {
		return FIELD_TYPE_NUMERIC_Y2S;
	}
	else if (!strcasecmp(strType, "Y2U")) {
		return FIELD_TYPE_NUMERIC_Y2U;
	}
	else if (!strcasecmp(strType, "Y2V")) {
		return FIELD_TYPE_NUMERIC_Y2V;
	}
	else if (!strcasecmp(strType, "Y2X")) {
		return FIELD_TYPE_NUMERIC_Y2X;
	}
	else if (!strcasecmp(strType, "Y2Y")) {
		return FIELD_TYPE_NUMERIC_Y2Y;
	}
	else if (!strcasecmp(strType, "Y2Z")) {
		return FIELD_TYPE_NUMERIC_Y2Z;
	}
	else if (!strcasecmp(strType, "SS")) {
		return FIELD_TYPE_SUBSTRING;
	}
	else if (!strcasecmp(strType, "UFF")) {
		return FIELD_TYPE_UNSIGNEDFF;
	}
	else if (!strcasecmp(strType, "SFF")) {
		return FIELD_TYPE_SIGNEDFF;
	}
	fprintf(stdout,"*GCSORT*P003 - Error parsing datatye : %s invalid\n", strType);
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
		case 'Y':
			return FIELD_VALUE_TYPE_Y;
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
		case FILE_ORGANIZATION_LINESEQUFIXED:
			return "LSF";
			/*  FUTURE USE		case FILE_ORGANIZATION_SEQUENTIALMF:    */
/*  FUTURE USE			return "SQMF";                      */    
		default:
			return "";
	}
}


int utils_getFieldTypeLIBCOBInt(int nInteralType, int nLen) 
{
	switch (nInteralType) {
	case FIELD_TYPE_CHARACTER:
		return COB_TYPE_ALPHANUMERIC;
	case FIELD_TYPE_SUBSTRING:			/* SubString */
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
    case FIELD_TYPE_NUMERIC_CLO:       /* sign leading              */
    case FIELD_TYPE_NUMERIC_CSL:       /* sign leading separate     */
    case FIELD_TYPE_NUMERIC_CST:       /* sign trailing separate    */
	case FIELD_TYPE_UNSIGNEDFF:		   /* Unsigned format free */
	case FIELD_TYPE_SIGNEDFF:		   /* Signed format free */
		/* date */
	case FIELD_TYPE_NUMERIC_Y2T:       /* sign trailing separate    */
			return COB_TYPE_NUMERIC_DISPLAY;
	case FIELD_TYPE_NUMERIC_Y2B:       
		return COB_TYPE_NUMERIC_BINARY;
	case FIELD_TYPE_NUMERIC_Y2C:       
		return COB_TYPE_NUMERIC_DISPLAY;
	case FIELD_TYPE_NUMERIC_Y2D:       
		return COB_TYPE_NUMERIC_PACKED;
	case FIELD_TYPE_NUMERIC_Y2P:
		return COB_TYPE_NUMERIC_PACKED;
	case FIELD_TYPE_NUMERIC_Y2S:
		return COB_TYPE_NUMERIC_DISPLAY;
	case FIELD_TYPE_NUMERIC_Y2U:
		return COB_TYPE_NUMERIC_PACKED;
	case FIELD_TYPE_NUMERIC_Y2V:
		return COB_TYPE_NUMERIC_PACKED;
	case FIELD_TYPE_NUMERIC_Y2X:
		return COB_TYPE_NUMERIC_PACKED;
	case FIELD_TYPE_NUMERIC_Y2Y:
		return COB_TYPE_NUMERIC_PACKED;
	case FIELD_TYPE_NUMERIC_Y2Z:
		return COB_TYPE_NUMERIC_DISPLAY;
	}
	return -1;
}

/* From internal type get flags for create/setting cob_field    */
int utils_getFieldTypeLIBCOBFlags(int nInteralType) 
{
	switch (nInteralType) {
	case FIELD_TYPE_CHARACTER:
	case FIELD_TYPE_SUBSTRING:	/* SubString*/
		return 0;
	case FIELD_TYPE_BINARY:
        return COB_FLAG_BINARY_SWAP;
		/* 20160914 return 0;   */
	case FIELD_TYPE_FIXED:
        return COB_FLAG_HAVE_SIGN | COB_FLAG_BINARY_SWAP;
		/* 20160914 return COB_FLAG_HAVE_SIGN ; */
	case FIELD_TYPE_FLOAT:
		return COB_FLAG_HAVE_SIGN;
        /* s.m. 20160925    */
        /* return COB_FLAG_HAVE_SIGN | COB_FLAG_IS_FP;  */

	case FIELD_TYPE_PACKED:
        return COB_FLAG_HAVE_SIGN;    
	case FIELD_TYPE_ZONED:
		/*-->> s.m. 20160914 return COB_FLAG_HAVE_SIGN; */
        /* Zoned for number 00001, +00001,-000001       */
        /*-->>return COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_SEPARATE | COB_FLAG_SIGN_LEADING;      // s.m. 20160914 insert COB_FLAG_SIGN_LEADING    */
        return COB_FLAG_HAVE_SIGN ;      /* s.m. 20160914 insert COB_FLAG_SIGN_LEADING problem with +/n zoned   */
	case FIELD_TYPE_UNSIGNEDFF:		/* Unsigned Free Format */	/* s.m. 202309 */
	case FIELD_TYPE_NUMERIC_CLO:         /* sign leading   */
		return COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_LEADING;
	case FIELD_TYPE_SIGNEDFF:		/* Signed Free Format */
	case FIELD_TYPE_NUMERIC_CSL:         /* sign leading separate  */
		return COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_LEADING | COB_FLAG_SIGN_SEPARATE;
    case  FIELD_TYPE_NUMERIC_CST:         /* sign trailing separate */
        return COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_SEPARATE;      
/*  Date    */
	case  FIELD_TYPE_NUMERIC_Y2T:         /* sign trailing separate */
		/* s.m. 20210513 return COB_FLAG_HAVE_SIGN | COB_FLAG_SIGN_SEPARATE;    */
		return COB_FLAG_HAVE_SIGN;
	case  FIELD_TYPE_NUMERIC_Y2B:         
		return COB_FLAG_BINARY_SWAP ;
	case  FIELD_TYPE_NUMERIC_Y2C:
		return 0;
	case  FIELD_TYPE_NUMERIC_Y2D:
		return COB_FLAG_NO_SIGN_NIBBLE; /* new  */
	case  FIELD_TYPE_NUMERIC_Y2P:
		return 0;
	case  FIELD_TYPE_NUMERIC_Y2S:
		return COB_FLAG_HAVE_SIGN;
	case  FIELD_TYPE_NUMERIC_Y2U:
		return 0;
	case  FIELD_TYPE_NUMERIC_Y2V:
		return 0;
	case  FIELD_TYPE_NUMERIC_Y2X:
		return COB_FLAG_HAVE_SIGN;
	case  FIELD_TYPE_NUMERIC_Y2Y:
		return COB_FLAG_HAVE_SIGN;
	case  FIELD_TYPE_NUMERIC_Y2Z:
		return COB_FLAG_HAVE_SIGN;
	}
	return -1;
}


const char *utils_getFieldTypeName(int type) 
{
	switch(type) {
		case FIELD_TYPE_CHARACTER:
			return "CH";
		case FIELD_TYPE_SUBSTRING:	/* SubString */
			return "SS";
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
/* s.m. */
		case FIELD_TYPE_ZONED:
			return "ZD"; 
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
/* Date */
		case FIELD_TYPE_NUMERIC_Y2T:
			return "Y2T";
		case FIELD_TYPE_NUMERIC_Y2B:
			return "Y2B";
		case FIELD_TYPE_NUMERIC_Y2C:
			return "Y2C";
		case FIELD_TYPE_NUMERIC_Y2D:
			return "Y2D";
		case FIELD_TYPE_NUMERIC_Y2P:
			return "Y2P";
		case FIELD_TYPE_NUMERIC_Y2S:
			return "Y2S";
		case FIELD_TYPE_NUMERIC_Y2U:
			return "Y2U";
		case FIELD_TYPE_NUMERIC_Y2V:
			return "Y2V";
		case FIELD_TYPE_NUMERIC_Y2X:
			return "Y2X";
		case FIELD_TYPE_NUMERIC_Y2Y:
			return "Y2Y";
		case FIELD_TYPE_NUMERIC_Y2Z:
			return "Y2Z";
		case FIELD_TYPE_UNSIGNEDFF:
			return "UFF";
		case FIELD_TYPE_SIGNEDFF:
			return "SFF";

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
		case FIELD_VALUE_TYPE_Y:
			return "Y";
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
			job_SetTypeOP('C');
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

int utils_SetOptionY2Past(char* optSort, int nNum)
{
	int nYear = nNum;
	/* verify len of nNum                                                                                           */
	/* 00 - 99 : specifies the number of years DFSORT is to subtract from the current year to set the beginning of  */
	/* the sliding century window                                                                                   */
	/* 1000 - 3000 : specifies the beginning of the fixed century window                                            */
	/*                                                                                                              */
	/* default of variable globalJob->nY2Past is current date                                                       */
	/* int with 4 numbers                                                                                           */
	/*                                                                                                              */
	if (strcasecmp(optSort, "Y2PAST") == 0) {
		if ((nYear >= 0) && (nYear <= 99)) {
			globalJob->nY2Past = nYear;
			globalJob->nY2PastLimInf = globalJob->nY2Year - globalJob->nY2Past;											/* YYYYY inf.   */
			globalJob->nY2PastLimSup = globalJob->nY2Year + 99 - globalJob->nY2Past;
			globalJob->nY2PastLimInfyy2 = globalJob->nY2PastLimInf - ((globalJob->nY2PastLimInf / 100) * 100);			/* YY   */
			globalJob->nY2PastLimInfyy3 = globalJob->nY2PastLimInf - ((globalJob->nY2PastLimInf / 1000) * 1000);		/* YYY  */
		}
		if ((nYear >= 1000) && (nYear <= 3000)) {
			globalJob->nY2Past = nYear;
			globalJob->nY2Year = nYear;
			globalJob->nY2PastLimInf = globalJob->nY2Year;
			globalJob->nY2PastLimSup = globalJob->nY2Year + 99;
			globalJob->nY2PastLimInfyy2 = globalJob->nY2PastLimInf - ((globalJob->nY2PastLimInf / 100) * 100);
			globalJob->nY2PastLimInfyy3 = globalJob->nY2PastLimInf - ((globalJob->nY2PastLimInf / 1000) * 1000);		/* YYY  */
		}
	}
	return 0;
}

/* Exit routine */
int utils_SetOptionExRoutine(char* optSort, char* szType, char* sCallName)
{
	if (strcasecmp(optSort, "MODS") == 0) {
		if (strcmp(szType, "E15") == 0)
		{
			strcpy(globalJob->strCallNameE15, sCallName);           /* Call Name E15  */
			globalJob->nExitRoutine= globalJob->nExitRoutine+1;	    /* code  0= no routine, 1=E15, 2=E35, 3=E15 and E35 */
		/*	globalJob->E15Routine = E15Call_constructor(globalJob->inputLength);    */
		}
		if (strcmp(szType, "E35") == 0)
		{
			strcpy(globalJob->strCallNameE35, sCallName);           /* Call Name E35    */
			globalJob->nExitRoutine = globalJob->nExitRoutine+2;	/* code  0= no routine, 1=E15, 2=E35, 3=E15 and E35 */
		/*  globalJob->E35Routine = E35Call_constructor(globalJob->outputLength);   */
		}
	}
	return 0;
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

cob_field* util_MakeAttrib_call(int type, int digits, int scale, int flags, int nLen, int nData)
{
	cob_field* field_ret;
	cob_field_attr* attrArea;
	attrArea = (cob_field_attr*)malloc(sizeof(cob_field_attr));
	if (attrArea == NULL)
		utl_abend_terminate(MEMORYALLOC, 11, ABEND_EXEC);
	attrArea->type = type;
	attrArea->digits = digits;
	attrArea->scale = scale;
	attrArea->flags = flags;
	attrArea->pic = NULL;
	field_ret = (cob_field*)malloc(sizeof(cob_field));
	if (field_ret == NULL)
		utl_abend_terminate(MEMORYALLOC, 12, ABEND_EXEC);
	field_ret->attr = attrArea;
	field_ret->data = NULL;
	if (nData == ALLOCATE_DATA) {
		field_ret->data = (unsigned char*)malloc((sizeof(unsigned char) * nLen) + 1);
		if (field_ret->data == NULL)
			utl_abend_terminate(MEMORYALLOC, 13, ABEND_EXEC);
		memset(field_ret->data, 0x00, nLen);
	}
	field_ret->size = nLen;
	/* fix value for single type of field   */
	attrArea->digits = digits;
	switch (type) {
	case COB_TYPE_ALPHANUMERIC_ALL:
	case COB_TYPE_ALPHANUMERIC:
		attrArea->scale = 0;
		break;
	case COB_TYPE_NUMERIC_BINARY:
		attrArea->scale = 0;
		/* attrArea->flags = attrArea->flags | COB_FLAG_BINARY_TRUNC | COB_FLAG_BINARY_SWAP;    */
		attrArea->flags = COB_FLAG_BINARY_TRUNC | COB_FLAG_BINARY_SWAP;
		break;
	case COB_TYPE_NUMERIC_DISPLAY:
		attrArea->scale = 0;
		attrArea->flags = attrArea->flags; /* | COB_FLAG_HAVE_SIGN;     */
		break;
	default:
		fprintf(stdout, "util_setAttrib - type not found %d \n", type);
		exit(GC_RTC_ERROR);
	}

	return field_ret;
}


void util_setAttrib ( cob_field_attr *attrArea, int type, int nLen)
{
/* fix value for single type of field   */
	switch (type) {
        case COB_TYPE_ALPHANUMERIC_ALL:
        case COB_TYPE_ALPHANUMERIC:
            attrArea->digits = 0;
            attrArea->scale = 0;
            break;
	    case COB_TYPE_NUMERIC_BINARY:
            if (nLen <= 2)
                attrArea->digits = 4;           
            if ((nLen > 2) && (nLen <= 4))
                attrArea->digits = 9;           
            if (nLen > 4) 
                attrArea->digits = 18;         
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
			/*
             if (nLen <= 1) 
                /* Why ?? attrArea->digits = nLen * 2; */
			/*
				attrArea->digits = nLen * 1;
             else
             {
                if (nLen % 2 == 0)
    		    	attrArea->digits = (nLen*2)-1;  
			    else
	    	    	attrArea->digits = (nLen*2)-1;
             }
			*/
			attrArea->digits = (nLen * 2) - 1;	/* digits number */
            attrArea->scale = 0;
    	    attrArea->flags  = attrArea->flags | COB_FLAG_HAVE_SIGN;
            break;
        case COB_TYPE_NUMERIC_DISPLAY:
            /*  s.m. 20210121 attrArea->digits = 0; */
            attrArea->scale = 0;
/* s.m. 20201015    */
    	    attrArea->flags  = attrArea->flags | COB_FLAG_HAVE_SIGN;
/* s.m. 20201015    */
            break;
			/* date */
/*            
            case DATE_TYPE_BINARY_PACKED:
                if (nLen <= 1)
                    attrArea->digits = nLen * 2;
                else
                {
                    if (nLen % 2 == 0)
                        attrArea->digits = (nLen * 2) - 1; //(nLen-1)*2;
                    else
                        attrArea->digits = (nLen * 2) - 1;
                }
                attrArea->scale = 0;
            ///	attrArea->flags = attrArea->flags;			// NO SIGN
                break;
*/
		default:
			fprintf(stdout, "util_setAttrib - type not found %d \n", type);
			exit(GC_RTC_ERROR);
			return ;
	}

    return;
}

/* Reset flags only for data type Y2<x> */
void util_resetAttrib(cob_field_attr* attrArea, int type, int digits)
{
	/* fix value for single type of field   */
	switch (type) {
	case COB_TYPE_NUMERIC_PACKED:
		attrArea->flags = attrArea->flags >> COB_FLAG_HAVE_SIGN;
	/*  -->> attenzione	    */
		attrArea->flags = attrArea->flags | COB_FLAG_NO_SIGN_NIBBLE; /* new */
		break;
	case COB_TYPE_NUMERIC_DISPLAY:
		attrArea->flags = attrArea->flags >> COB_FLAG_HAVE_SIGN;
		break;
	default:
		/* no action    */
		return;
	}
	if (digits >= 0)
		attrArea->digits = digits;

	return;
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
		field_ret->attr = NULL;
		if (nData == ALLOCATE_DATA) {
			if (field_ret->data!=NULL)
				free(field_ret->data); 
			field_ret->data = NULL;
		}
		free(field_ret);
		field_ret = NULL;
	}
}

void utl_abend_terminate(int nAbendType, int nCodeErr, int nTerminate)
{
	switch (nAbendType) {
    case MEMORYALLOC:
        fprintf(stdout,"*GCSORT* ERROR: Aborting execution for problems with memory allocation. Code : %d\n", nCodeErr);
        break;
	case EXITROUTINE:
		fprintf(stdout,"*GCSORT* ERROR: Aborting execution from E15 routine. Code : %d\n", nCodeErr);
		break;
	case NOMATCH_FOUND:
		fprintf(stdout,"*GCSORT* ERROR: Aborting execution from CHANGE statement. NOMATCH found. Code : %d\n", nCodeErr);
		break;
	default:
        fprintf(stdout,"*GCSORT* ERROR: Aborting execution.  Code : %d\n", nCodeErr);
        break;
    }
    if (nTerminate == ABEND_EXEC)
        exit(GC_RTC_ERROR);       
    return;
}
int utl_GetFileSizeEnvName(struct file_t* file) {
	char* pEnv;
	struct stat filestatus;
	char szname[GCSORT_SIZE_FILENAME];
	snprintf(szname, (size_t)COB_FILE_MAX, "%s", (const char*)file->stFileDef->assign->data);
	pEnv = getenv(szname);
	if (pEnv != NULL) {
		stat(pEnv, &filestatus);
		return filestatus.st_size;
	}
	snprintf(szname, (size_t)COB_FILE_MAX, "DD_%s", (const char*)file->stFileDef->assign->data);
	pEnv = getenv(szname);
	if (pEnv != NULL) {
		stat(pEnv, &filestatus);
		return filestatus.st_size;
	}
	snprintf(szname, (size_t)COB_FILE_MAX, "dd_%s", (const char*)file->stFileDef->assign->data);
	pEnv = getenv(szname);
	if (pEnv != NULL) {
		stat(pEnv, &filestatus);
		return filestatus.st_size;
	}
	return 0;
}

int64_t utl_GetFileSize(struct file_t* file) 
{
	struct stat filestatus;
	stat(file->name, &filestatus);
	return filestatus.st_size;
}

void utils_SetRecordOptionSortType (char* szType)
{
	int nType = utils_parseFileFormat(szType);

	globalJob->nTypeRecordFormat = nType;

	return;
}
 
void utils_SetRecordOptionSortLen(int l1, int l2, int l3, int l4, int l5, int l6, int l7)
{
	globalJob->nLenInputL1 = l1;
	globalJob->nLenE15L2 = l2;
	globalJob->nLenOutputL3 = l3;
	globalJob->nLenMinLenL4 = l4;
	globalJob->nLenAvgLenL5 = l5;
	globalJob->nLenFutureUseL6 = l6;
	globalJob->nLenFutureUseL7 = l7;
	return;
}

int utl_replace_recursive_str(unsigned char* str, unsigned char* find, unsigned char* set, unsigned char* result, int lenIn, int lenOut, int nCurrOcc, int nMaxOcc, int *nOverChar, int nShift)
{
	int nS = 0;
	int nSizeFRT = 0;
	unsigned char* pCheck = malloc(COB_FILE_BUFF);
	if (pCheck == NULL) {
		utl_abend_terminate(MEMORYALLOC, 16, ABEND_EXEC);
	}
	memset(pCheck, 0x00, COB_FILE_BUFF);
	if (strlen(find) > 0 ) {
		strcpy(pCheck, str);
		nS = utl_replace_findrep(pCheck, find, set, result, strlen(find), strlen(set), lenIn, lenOut, nCurrOcc, nMaxOcc, nShift);
		strncpy(pCheck, result, lenOut);
	}
	free(pCheck);
	*nOverChar = (strlen(find) - strlen(set)) * nS;		/* Calculate difference record length  */

	return nS;
}

int utl_replace_single_str(unsigned char* str, unsigned char* find, unsigned char* set, unsigned char* result, int lenIn, int lenOut)
{
	int nS = 0;
	int nT = 0;
	unsigned char* pCheck = malloc(COB_FILE_BUFF);
	if (pCheck == NULL) {
		utl_abend_terminate(MEMORYALLOC, 16, ABEND_EXEC);
	}
	memset(pCheck, 0x00, COB_FILE_BUFF);
	if (strlen(find) > 0) {
		strcpy(pCheck, str);
		/* do { */
		nS = utl_replace_str(pCheck, find, set, result, lenIn, lenOut);
		if (nS == 0) {
			/* strncpy(pCheck, result, (strlen(str) + (lenIn - lenOut))); */
			strncpy(pCheck, result, lenOut);
			nT++;
		}
		/*  } while (nS == 0); */
	}
	free(pCheck);
	if (nT > 0)
		return 1;
	return 0;
}

int utl_replace_str(unsigned char* str, unsigned char* find, unsigned char* set, unsigned char* result, int lenIn, int lenOut)
{
	unsigned char buffer[COB_FILE_BUFF];
	memset(buffer, 0x00, COB_FILE_BUFF);
	unsigned char* p;
	if (!(p = strstr(str, find))) {
		strcpy(result, str);
		return 1;
	}

	gc_memcpy(result, set, lenOut);

	return 0;
}

int utl_replace_findrep(unsigned char* str, unsigned char* find, unsigned char* set, unsigned char* result, int find_len, int repl_len, int lenIn, int lenOut, int nCurrOcc, int nMaxOcc, int nShift)
{
	char buffer[COB_FILE_BUFF];
	memset(buffer, 0x00, COB_FILE_BUFF);
	char* insert_point = &buffer[0];
	const char* tmp = str;
	int nSubs = nCurrOcc;
	int nNumShift = 0;
	while (1) {
		const char* p = strstr(tmp, find);

		/* walked past last occurrence of find; copy remaining part */
		if (p == NULL) {
			strcpy(insert_point, tmp);
			break;
		}
		nSubs = nSubs + 1;
		if (nSubs > nMaxOcc) {
			strcpy(insert_point, tmp);
			break;				/* Break replace after n occurences */
		}
		/* copy part before find */
		memcpy(insert_point, tmp, p - tmp);
		insert_point += p - tmp;

		/* copy set string */
		memcpy(insert_point, set, repl_len);
		insert_point += repl_len;

		/* adjust pointers, move on */
		tmp = p + find_len;
		/* Check Shift option (FINDREP)  */
		if ((nShift == 1) && ((find_len - repl_len) > 0)) {
			nNumShift = (find_len - repl_len);
			memcpy(insert_point, tmp - nNumShift, nNumShift);
			insert_point += nNumShift;
		}
	}

	/* write altered string back to str */
	memcpy(result, buffer, lenOut);

	return nSubs;
}

void sort_temp_name(const char* ext)
{
#if defined(_MSC_VER)  ||  defined(__MINGW32__) || defined(__MINGW64__)
	/* s.m. 202101 if (globalJob->strPathTempFile == NULL)  */
	if (strlen(globalJob->strPathTempFile) == 0) {
		GetTempPath(FILENAME_MAX, cob_tmp_temp);
		if (strlen(cob_tmp_temp) == 0) {
			cob_tmp_temp[0] = '.';
			cob_tmp_temp[1] = '\\';
			cob_tmp_temp[2] = 0x00;
		}
	}
	else
		strcpy(cob_tmp_temp, globalJob->strPathTempFile);
	GetTempFileName(cob_tmp_temp, "Srt", 0, cob_tmp_buff);
	DeleteFile(cob_tmp_buff);
	strcpy(cob_tmp_temp, cob_tmp_buff);
	strcpy(cob_tmp_temp + strlen(cob_tmp_temp) - 4, ext);
	return;
#else
	char* buff;
	char* cob_tmpdir = NULL;
	char* p = NULL;
	pid_t			cob_process_id = 0;
	int                  cob_iteration;
	cob_process_id = getpid();
	cob_iteration = globalJob->nIndextmp;
	memset(cob_tmp_temp, 0x00, FILENAME_MAX + 8);
	/* -->>printf("globalJob->strPathTempFile %s \n", globalJob->strPathTempFile);  */

/* linux 	if (globalJob->strPathTempFile == NULL){    */
	if (strlen(globalJob->strPathTempFile) == 0) {
		if ((p = getenv("TMPDIR")) != NULL) {
			cob_tmpdir = p;
		}
		else if ((p = getenv("TMP")) != NULL) {
			cob_tmpdir = p;
		}
		if (p == NULL)
			sprintf(cob_tmp_temp, "./Srt%d_%d%s", (int)cob_process_id,
				(int)cob_iteration, ext);
		else
			sprintf(cob_tmp_temp, "%s/Srt%d_%d%s", cob_tmpdir, (int)cob_process_id,
				(int)cob_iteration, ext);

	}
	else
		sprintf(cob_tmp_temp, "%s/Srt%d_%d%s", globalJob->strPathTempFile, (int)cob_process_id, (int)cob_iteration, ext);

	/* -->>	printf(" Temporary File \n%s\n", cob_tmp_temp );    */

	return;
#endif
	printf("cob_tmp_temp : \n%s\n", cob_tmp_temp);
}
/* check len and realloc data out */
int  utl_copy_realloc(char* out, char* in) {
	strcpy(out, in);
	return strlen(out);
}

/* String  search - replace */
int utl_str_searchreplace(char* orig, char* search, char* replace, char* result) {
	char* ins;			/* the next insert point										 */
	char* tmp;			/* varies														 */
	int len_search;		/* length of search (the string to remove)						 */
	int len_replace;	/* length of replace (the string to searchlace search replace)	 */
	int len_front;		/* distance between search and end of last search				 */
	int count;			/* number of searchlacements									 */

	/* sanity checks and initialization */
	if (!orig || !search)
		return 0;
	len_search = strlen(search);
	if (len_search == 0)
		return 0; /* empty search causes infinite loop during count */
	if (!replace)
		replace = "";
	len_replace = strlen(replace);

	/* count the number of searchlacements needed */
	ins = orig;
	for (count = 0; tmp = strstr(ins, search); ++count) {
		ins = tmp + len_search;
	}
	tmp = result;

	/*
	 first time through the loop, all the variable are set correctly
	 from here on,
	    tmp points to the end of the result string
	    ins points to the next occurrence of search in orig
	    orig points to the remainder of orig after "end of search"
	*/
	while (count--) {
		ins = strstr(orig, search);
		len_front = ins - orig;
		tmp = strncpy(tmp, orig, len_front) + len_front;
		tmp = strcpy(tmp, replace) + len_replace;
		orig += len_front + len_search; /* move to next "end of search" */
	}
	strcpy(tmp, orig);
	return 1;
}

void util_view_numrek(void) {
	fprintf(stdout, " Total Records Readed  : " NUM_FMT_LLD "\n", (long long)globalJob->recordNumberTotal);
	fprintf(stdout, " Total Records Writed  : " NUM_FMT_LLD "\n", (long long)globalJob->recordWriteOutTotal);
}

int64_t util_UFFSFF(unsigned char* pData, int nFieldLen, int nUS) {

	int i = 0;
	int64_t newVal = 0;
	int bSign = 0;

	for (i = 0; i < nFieldLen; i++) {
		/* Get number */
		if ((unsigned char)(pData[i]) >= '0' && (unsigned char)pData[i] <= '9') {
			newVal = (int64_t) (newVal * 10 + ((unsigned char)pData[i] - '0'));
		}
		/* Verify sign */
		if (((unsigned char)pData[i] == ')') || ((unsigned char)pData[i] == '-'))
			bSign = 1;
	}

	/* Check UFF or SFF */
	if ((nUS == 1) && (bSign == 1) && (newVal > 0))
		newVal = newVal * -1;

	/* fprintf(stdout, " Value string=%s - Value num=" NUM_FMT_LLD "\n", pData, (long long)newVal); */

	return newVal;
}
