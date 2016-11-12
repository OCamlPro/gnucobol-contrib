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
%debug
%error-verbose
%union { 
	int         number;
	long        lnumber;
	long long   llnumber;
	char        *string;
	char        character;
	struct condField_t  *condField;
	struct fieldValue_t *fieldValue;
	struct SumField_t   *SumField;
};
%code {
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#ifdef _MSC_VER
		#include <io.h>
	#else
		#include <stdlib.h> 
		#include <unistd.h>
	#endif
	#include "ocsort.h"
	#include "file.h"
	#include "keyidxrel.h"
	#include "job.h"
	#include "sortfield.h"
	#include "condfield.h"
	#include "fieldvalue.h"
	#include "outrec.h"
	#include "inrec.h"
	#include "outfil.h"
	#include "sumfield.h"
	#include "utils.h"

	#define  INREC_CASE		1
	#define  OUTREC_CASE	2

	int yylex    (void);
	void yyerror (char const *);

	struct file_t*		current_file=NULL;
	struct outfil_t*	current_outfil=NULL;
	struct condField_t*	condField=NULL;

	int nRecCase=0;
	int nTypeFile=0;
	int current_outrec=0;
	int current_inrec=0;
	int current_sortField=0;
	int nPosAbsRec=0;
	int nRtc=0;
	int nCountGroupFiles=0;
	char* pszInt;

	extern int nTypeFieldsCmd;
	char szTmp[5];
	int	 nIntTmp;
	int  nTypeFormat;			// 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields
	int  nTypeIncludeOmit;		// 0= Nothing, 1 = Include, Omit=2
	int  nstate_outfil = 0;

}
%token				AND						"AND clause"
%token				COND					"COND clause"
%token				ENDREC					"ENDREC clause"
    //  %token				FILES					"FILES  clause"
%token				FNAMES					"FNAMES clause"
%token				FORMAT					"FORMAT clause"
%token				INCLUDE					"INCLUDE clause"
%token				INREC					"INREC clause"
%token				NONE					"NONE clause"
%token				OMIT					"OMIT clause"
%token				OPTION					"OPTION clause"
%token				OR						"OR clause"
%token				OUTFIL					"OUTFIL clause"
%token				OUTREC					"OUTREC clause"
%token				SAVE					"SAVE clause"
%token				SKIPREC					"SKIP clause"
%token				STARTREC				"STARTREC clause"
%token				STOPAFT					"STOPAFT clause"
%token				SUM						"SUM clause"
%token				SPLIT					"SPLIT clause"
%token				SPLITBY					"SPLITBY clause"
%token				VLSCMP					"VLSCMP clause"
%token				VLSHRT					"VLSHRT clause"
%token 				BUILD					"BUILD instruction"
%token 				FIELDS					"FIELDS instruction"
%token 				GIVE					"GIVE clause"
%token 				MERGE					"MERGE clause"
%token 				ORG						"ORG instruction"
%token 				RECORD					"RECORD instruction"
%token 				SORT					"SORT clause"
%token 				USE						"USE clause"
%token 				COPY					"COPY"
%token <number>		DIGIT					"DIGIT"
%token <string>		CHARTCOND  			    "CHARTCOND" 
%token <string>		CHARTYPE				"CHARTYPE" 
%token <string>		FILETYPE				"FILETYPE"
%token <string>		FORMATTYPE				"FORMATTYPE"
%token <string>		KEY						"KEY" 
%token <string>		KEYTYPE					"KEYTYPE" 
%token <string>		OCCURFILL				"OCCURFILL"
%token <string>		OPCOND					"OPCOND"
%token <string>		ORDER					"ORDER"
%token <string>		RECTYPEFIX				"RECTYPEFIX"
%token <string>		RECTYPEVAR				"RECTYPEVAR"
%token <string>		STRING					"STRING"
%token <string>		TOKSKIP					"TOKSKIP clause"
%token <llnumber>	SIGNDIGITBIG			"SIGNDIGITBIG"
%type <number>		fieldtype
%type <number>		fielddirection
%type <number>		condition
%type <fieldValue>	fieldvaluerec
%type <fieldValue>	fieldvaluecond
%type <condField>	condfield
%type <condField>	allcondfield
%type <SumField>	sumfield
%type <SumField>	allsumfield
%type <fieldValue>	fieldvalueconst
%type <string>      filesgroup
%left OR
%left AND
%%
%start beginning
;
beginning:
		| clause beginning
;
clause:   sortclause {}
		| mergeclause {}
        | useclause {}
		| giveclause {}
		| formatclause {}
		| startrecclause {}
		| endrecclause {}
		| includeclause {}
		| omitclause {}
		| inrecclause {}
		| sumclause {}
		| outrecclause {}
		| tokskipclause {}
		| outfilclause {}
		| outfilincludeclause {}
		| outfilomitclause {}
		| fnamesclause {}
            // | filesclause {}
		| saveclause {}
		| optionclause {}
;

useclause: 
	  USE STRING { 
        struct file_t *file=file_constructor($2);
        strcpy(szMexToken, "use clause");
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 100, ABEND_SKIP);
			YYABORT;
		}
        file_setInputFile(file);
        current_file=file;
        nTypeFile=0;
        free($2);
    } recordorginstruction {
        file_SetInfoForFile(current_file, COB_OPEN_INPUT); // Input
        current_file=NULL;
}
;
giveclause: 
      GIVE STRING {
        struct file_t *file=file_constructor($2);
        strcpy(szMexToken, " give clause ");
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 101, ABEND_SKIP);
			YYABORT;
		}
        file_setOutputFile(file);
        current_file=file;
        nTypeFile=0;
        free($2);
} recordorginstruction {
        file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); //Output
        current_file=NULL;
};

recordorginstruction: 
    { 	
        strcat(szMexToken, " record org instruction "); 
}
	| ORG FILETYPE recordorginstruction {  
        strcpy(szMexToken, " org file type ");
   
        if (current_file!=NULL) {
            nRtc = file_setOrganization(current_file,utils_parseFileOrganization($2));
            if (nRtc == -1)
                exit(OC_RTC_ERROR);
            nTypeFile = utils_parseFileOrganization($2);
        }
        free($2);
}
	| RECORD RECTYPEVAR ',' DIGIT ',' DIGIT recordorginstruction {    
        strcpy(szMexToken, " record type ");
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat($2));
            file_setRecordLength(current_file,$4);
            file_setMaxLength(current_file,$6);
        }
        free($2);
}
	| RECORD '(' RECTYPEVAR ',' DIGIT ',' DIGIT ')' recordorginstruction {
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat($3));
            file_setRecordLength(current_file,$5);
            file_setMaxLength(current_file,$7);
        }
        free($3);
}

	| RECORD RECTYPEFIX ',' DIGIT recordorginstruction {		
        strcpy(szMexToken, " record type ");
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat($2));
            file_setRecordLength(current_file,$4);
            file_setMaxLength(current_file,$4);
        }
        free($2);
}
	| RECORD '(' RECTYPEFIX ',' DIGIT ')' recordorginstruction {
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat($3));
            file_setRecordLength(current_file,$5);
            file_setMaxLength(current_file,$5);
        }
        free($3);
}

	| KEY '(' allkeyfield ')' recordorginstruction {
}
;

 allkeyfield: 
      keyfield { 
        strcat(szMexToken, " key instruction ");
}
    | keyfield ',' allkeyfield {}
 ;
 
 keyfield:	
      DIGIT ',' DIGIT ',' KEYTYPE {
        if (current_file!=NULL) {
            struct KeyIdx_t *KeyIdx;
            KeyIdx=KeyIdx_constructor($1, $3, utils_parseKeyType($5));
            if (KeyIdx == NULL) {
               utl_abend_terminate(MEMORYALLOC, 102, ABEND_SKIP);
               YYABORT;
            }
            KeyIdx_addDefinition(KeyIdx, current_file);
        }
        free($5);
 }
;
    // key clause - END
fieldtype: 
      FORMATTYPE {
		$$=utils_parseFieldType($1);
		free($1);
}
;
fielddirection: 
      ORDER {
		$$=utils_parseSortDirection($1);
		free($1); 
}
;

condition: 
      OPCOND {
		$$=utils_parseCondCondition($1);
		free($1);
}
;

 /* fieldvaluecond: CHARTYPE  STRING  { */
fieldvaluecond: 
    /* ########################## */
    /*  CharType = C|X <String>   */
    /*  C'-' or X'hh...hh'        */
    /* ########################## */
      CHARTCOND  STRING  { 
		$$=fieldValue_constructor((char*) $1, $2, TYPE_STRUCT_STD);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 104, ABEND_SKIP);
			YYABORT;
		}
		free($1); 
		free($2); 
}		
 /* fieldvalue: CHARTYPE  STRING  { */
fieldvaluerec: 
    /* ########################## */
    /*  CharType = C|X|Z <String>   */
    /*  C'-' or X'hh...hh' or Z'nn' */
    /* ########################## */
      CHARTYPE  STRING  { 
		$$=fieldValue_constructor((char*) $1, $2, TYPE_STRUCT_STD);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 105, ABEND_SKIP);
			YYABORT;
		}
		free($1); 
		free($2); 
}		
;

fieldvalueconst:  
    /* #################################################################################################### */
    // DIGIT = Numeric value max [+/-] 5 digit
    /* #################################################################################################### */
      DIGIT {
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%d", $1);
		$$=(struct fieldValue_t *) fieldValue_constructor((char*)"Z", pszInt, TYPE_STRUCT_NEW);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 106, ABEND_SKIP);
			YYABORT;
		}
		free(pszInt); 
}
    /* #################################################################################################### */
    // DIGIT = Numeric value DIGIT from [+/-] 6 to n digit
    /* #################################################################################################### */
    | SIGNDIGITBIG  {
		char szType[] = "Z";
		pszInt = (char*) malloc(32);		 
		#ifdef	_MSC_VER
			sprintf(pszInt, CB_FMT_LLD , $1);
		#else
			sprintf(pszInt, CB_FMT_LLD , $1);
		#endif
		//-->> 20160914 $$=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_STD);
		$$=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_NEW);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 107, ABEND_SKIP);
			YYABORT;
		}
		free(pszInt); 
}
;

allsortfield: 
      sortfield {
}
    | sortfield ',' allsortfield {
        
}
;

sortfield:	
      DIGIT ',' DIGIT ',' fielddirection {
        if (current_sortField==1) {
            struct sortField_t *sortField;
            sortField=sortField_constructor($1,$3,0, $5);
			if (sortField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 108, ABEND_SKIP);
				YYABORT;
			}
            sortField_addDefinition(sortField);
            nTypeFormat = 1;
        }
}
    | DIGIT ',' DIGIT ',' fieldtype ',' fielddirection {
        if (current_sortField==1) {
            struct sortField_t *sortField;
            sortField=sortField_constructor($1,$3,$5,$7);
			if (sortField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 109, ABEND_SKIP);
				YYABORT;
			}
            sortField_addDefinition(sortField);
            //-->> nTypeFormat = 1; // Format external token
			}
}
;

sortclause: 
      SORT FIELDS '(' {
        current_sortField=1;
        } allsortfield ')' {
        current_sortField=0;
        job_SetTypeOP('S');		// for Sort
        strcpy(szMexToken, " sort clause ");
}
    | SORT FIELDS COPY {
        job_SetTypeOP('M');		// for Merge
        job_SetFieldCopy(1);
        strcpy(szMexToken, " sort clause ");
}

mergeclause: 
      MERGE FIELDS '(' {
        current_sortField=1;
        strcpy(szMexToken, " merge clause ");
        } allsortfield ')' {
        current_sortField=0;
        // typeOP = 'M'; // for Merge
        job_SetTypeOP('M');
        strcpy(szMexToken, " merge clause ");
}
    | MERGE FIELDS COPY {
        job_SetTypeOP('M');
        job_SetFieldCopy(1);
        strcpy(szMexToken, " merge clause ");
}
;

/* #################################################################################################### */
//-->>nTypeFormat;			// 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields
//-->>nTypeIncludeOmit;		// 0= Nothing, 1 = Include, 2 = Omit
/* #################################################################################################### */
formatclause: 
      FORMAT '=' fieldtype {
		strcpy(szMexToken, " format clause ");
		if (nTypeFormat == 1)
			condField_setFormatFieldsTypeAll(nTypeFormat, $3);
		if (nTypeFormat == 2)
			condField_setCondFieldsTypeAll(nTypeIncludeOmit, $3);
		if (nTypeFormat == 3)	// for SumFields
			condField_setFormatFieldsTypeAll(nTypeFormat, $3);
}
/* s.m. 20160914
    | ',' FORMAT '=' fieldtype {
        if (nTypeFormat == 1)
            condField_setFormatFieldsTypeAll(nTypeFormat, $4);
        if (nTypeFormat == 2)
            condField_setCondFieldsTypeAll(nTypeIncludeOmit, $4);
        if (nTypeFormat == 3)	// for SumFields
            condField_setFormatFieldsTypeAll(nTypeFormat, $4);
		strcpy(szMexToken, " format clause ");
}
*/
;
allcondfield: 
    condfield {
		$$=$1;
}
	| '(' allcondfield ')' {
		$$=$2;
		strcat(szMexToken, " condition field ");
}
    | allcondfield AND allcondfield {
		condField=condField_constructor_operation(COND_OPERATION_AND, $1, $3);
		$$=condField;
		strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 110, ABEND_SKIP);
			YYABORT;
		}
}
    | allcondfield OR allcondfield {
		condField=condField_constructor_operation(COND_OPERATION_OR, $1, $3);
		$$=condField;
		strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 111, ABEND_SKIP);
			YYABORT;
		}
}
;


condfield: 	
    /* #################################################################################################### */
    // pos1, len1, format1, operator, pos2, len2, format2 - 
    // check field in pos1 for len1 and format1 with field in pos2 for len2 and format2, apply operator   
    // (156,15,CH,LT,141,15,CH)
    /* #################################################################################################### */
      DIGIT ',' DIGIT ',' fieldtype ',' condition ',' DIGIT ',' DIGIT ',' fieldtype {
        nTypeFormat = 2; // Format external token
        condField=condField_constructor_conditionfield($1,$3,$5,$7,$9,$11,$13);
        $$=condField;
        strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
}

    /* #################################################################################################### */
    // pos1, len1, format1, operator, pos2, len2, format2 - 
    // check field in pos1 for len1 with field in pos2 for len2 and apply operator, mandatory FORMAT=nn
    // (156,15,LT,141,15),FORMAT=CH
    /* #################################################################################################### */
    |  DIGIT ',' DIGIT ',' condition ',' DIGIT ',' DIGIT  {
        nTypeFormat = 2; // Format external token
        condField=condField_constructor_conditionfield($1,$3,0,$5,$7,$9,0);
        $$=condField;
        strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
}
    /* #################################################################################################### */
    // pos, len, operator, format, condition, value 
    // case 1,6,CH,EQ,C'String'  field in position 1 with length 6 equal 'String'
    /* #################################################################################################### */
    | DIGIT ',' DIGIT ',' fieldtype ',' condition ',' fieldvaluecond  {    
		$$=condField_constructor_condition($1,$3,$5,$7,$9);
		strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 113, ABEND_SKIP);
			YYABORT;
		} 
}
    /* #################################################################################################### */
    // pos, len, type field, operator, value numeric 
    // case 88,13,ZD,LT,-10  field ZD in position 88 with length 13 must be less then -10
    /* #################################################################################################### */
    | DIGIT ',' DIGIT ',' fieldtype ',' condition ',' fieldvalueconst {
        $$=condField_constructor_condition($1,$3,$5,$7,$9);
        strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 114, ABEND_SKIP);
			YYABORT;
		}
}
    /* #################################################################################################### */
    // pos, len, operator, value numeric .   Mandatory FORMAT= for type
    // case 88,13,LT,-10  field in position 88 with length 13 less then -10
    /* #################################################################################################### */
    | DIGIT ',' DIGIT ',' condition ',' fieldvalueconst  {    
        condField=condField_constructor_condition($1,$3,0,$5,(struct fieldValue_t *)$7);
        nTypeFormat = 2; // Format external token
        $$=condField;
        strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 115, ABEND_SKIP);
			YYABORT;
		}
}
    /* #################################################################################################### */
    // pos, len, operator, value numeric .   Mandatory FORMAT= for type
    // case 45,6,LE,C'999999'  field in position 45 with length 6 less then '999999'
    /* #################################################################################################### */
    | DIGIT ',' DIGIT ',' condition ',' fieldvaluecond  {    
        condField=condField_constructor_condition($1,$3,0,$5,(struct fieldValue_t *)$7);
        nTypeFormat = 2; // Format external token
        $$=condField;
        strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 116, ABEND_SKIP);
			YYABORT;
		}
}

omitclause: 
      OMIT COND allcondfield  {
        condField_addOmit($3);
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
/* s.m. 20160915 */
    | OMIT COND '=' allcondfield  {
        condField_addOmit($4);
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
/* */
;

includeclause: 
      INCLUDE COND allcondfield  {
        condField_addInclude($3);
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    /* 20160915 */
    | INCLUDE COND '=' allcondfield  {
        condField_addInclude($4);
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    /* */
;

/* =================================================================================== */

allinoutrec: 
    inoutrec {	
}
		| allinoutrec ',' allinoutrec {	};
;
inoutrec: 
    /* #################################################################################################### */
    // pos , len of  input
    // case 10,5  copy field from position 10 for len 5 from input, into actual position of output record 
    /* #################################################################################################### */
      DIGIT ',' DIGIT {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_range($1,$3);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 117, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            else
            {
                struct outrec_t *outrec=outrec_constructor_range($1,$3);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 118, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                    struct inrec_t *inrec=inrec_constructor_range($1,$3);
                    if (inrec == NULL) {
                        utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                        YYABORT;
                    }
                    nPosAbsRec += inrec->range.length;
                    inrec_addDefinition(inrec);
            }
            break;
        default:
            break;
        }
}
    /* ######################################################################################## */
    // (pos 20 output), (pos 10, len 5 input)
    // case 20:10,5  (from position 20 output, copy field position 10 for len 5 from input)
    /* ######################################################################################## */
    | DIGIT ':' DIGIT ',' DIGIT {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_range_position($1, $3, $5);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 120, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec = outrec->range_position.posAbsRec + outrec->range_position.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                struct inrec_t *inrec=inrec_constructor_range_position($1, $3, $5);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 121, ABEND_SKIP);
                    YYABORT;
                }
                nPosAbsRec = inrec->range_position.posAbsRec + inrec->range_position.length;
                inrec_addDefinition(inrec);
            }
            break;
       }
}
    // ######################################################################################## 
    // [0-9]{1,5}[C|X|Z]{1}
    // nZ  n times of binary zero 
    // nX  n times of blank, 
    // case : 50X  (repeat 50 times blank)
    // ######################################################################################## 
    | OCCURFILL {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_subst($1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 122, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                struct inrec_t *inrec=inrec_constructor_subst($1);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 123, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
            break;
        default:
            break;
        }
		free($1);
}
    // ####################################################### 
    // [0-9]{1,5}[C|X|Z]{1} <string>                           
    // nC'string'  n times of string						   
    // 5C'XYZ'	-> XYZXYZXYZXYZXYZ   						   
    // ####################################################### 
    | OCCURFILL STRING {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_substnchar($1,$2);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 124, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                struct inrec_t *inrec=inrec_constructor_substnchar($1,$2);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 125, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
           break;
        default:
            break;
        }
		free($1); 
		free($2); 
}
    // ######################################################## 
    // position absolute (output) : (C|X|Z) CharType	
    // case 80:X
    // ######################################################## 
    | DIGIT ':' CHARTYPE {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_padding($1, $3, nPosAbsRec);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 126, ABEND_SKIP);
                    YYABORT;
                }
                if ($1 > nPosAbsRec) 
                    nPosAbsRec = $1;
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                struct inrec_t *inrec=inrec_constructor_padding($1, $3, nPosAbsRec);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 127, ABEND_SKIP);
                    YYABORT;
                }
                if ($1 > nPosAbsRec) 
                    nPosAbsRec = $1;		// - inrec->change_position.fieldValue->generated_length;
                inrec_addDefinition(inrec);
            }
           break;
        default:
            break;
        }
        free($3); 
}
    // ######################################################## 
    // (C|X|Z) CharType	
    // case X or Z 
    // ######################################################## 
    | CHARTYPE {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_subst($1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 128, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                struct inrec_t *inrec=inrec_constructor_subst($1);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 129, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
           break;
        default:
            break;
        }
}			

    /* ################################################## */
    /*  C|X|Z String									  */
    /*  C'-'											  */
    /* ################################################## */
    | fieldvaluerec {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec;
                outrec=outrec_constructor_change($1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 130, ABEND_SKIP);
                    YYABORT;
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                struct inrec_t *inrec=inrec_constructor_change($1);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 131, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
            break;
        default:
            break;
        }
	}
	
// condizione di posizione di partenza senza lunghezza per i file variabili
    | DIGIT ',' {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_range($1,-1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            else
            {
                struct outrec_t *outrec=outrec_constructor_range($1,-1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                struct inrec_t *inrec=inrec_constructor_range($1,-1);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 134, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
            }
            break;
        default:
            break;
        }
}
;
outrecclause: 
/* s.m. 20160915 */
      OUTREC FIELDS '=' '(' {
		strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_outrec=0;
        nRecCase=0;
}
 /* */
    | 
      OUTREC FIELDS '(' {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_outrec=0;
        nRecCase=0;
}
/* s.m. 20160915 */
    | OUTREC BUILD '=' '(' {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
   /* */
    | OUTREC BUILD '(' {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_outrec=0;
        nRecCase=0;
}
;

/* Case for OUTREC in OUTFIL */
outrecclause:
/*  */
      OUTREC '=' '(' {
        current_outrec=1;
        nRecCase=2;
        strcpy(szMexToken, " outrec clause ");
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_outrec=0;
        nRecCase=0;
}
 /* */
  | OUTREC '(' {
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
        strcpy(szMexToken, " outrec clause ");
} allinoutrec ')' {
        current_outrec=0;
        nRecCase=0;
}
;


inrecclause: 
    /* s.m. 20160914 */
      INREC FIELDS '=' '(' {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_inrec=0;
        nRecCase=0;
}
    |   /* */
      INREC FIELDS '(' {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
        } allinoutrec ')' {
        current_inrec=0;
        nRecCase=0;
}
    /* */
    | INREC BUILD '=' '(' {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_inrec=0;
        nRecCase=0;
}
    /* */
    | INREC BUILD '(' {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
} allinoutrec ')' {
			current_inrec=0;
			nRecCase=0;
}
;
/* =================================================================================== */


// OUTFIL

allsumfield: sumfield {}
		| sumfield ',' allsumfield {}
;
sumfield: 
      DIGIT ',' DIGIT   {
        struct SumField_t *SumField=SumField_constructor($1, $3, 0);
        if (SumField == NULL) {
            utl_abend_terminate(MEMORYALLOC, 135, ABEND_SKIP);
			YYABORT;
		}
        nTypeFormat=3;			// for SumFields Format=
        SumField_addDefinition(SumField); 
        strcpy(szMexToken, " sum fields clause ");
}
    | DIGIT ',' DIGIT ',' DIGIT ',' DIGIT    {
			struct SumField_t *SumField1=SumField_constructor($1, $3, 0);
			struct SumField_t *SumField2=SumField_constructor($5, $7, 0);
			if (SumField1 == NULL) {
                utl_abend_terminate(MEMORYALLOC, 136, ABEND_SKIP);
				YYABORT;
			}
			if (SumField2 == NULL) {
                utl_abend_terminate(MEMORYALLOC, 103, ABEND_SKIP);
				YYABORT;
			}
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField1); 
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField2); 
		strcpy(szMexToken, " sum fields clause ");
}
    | DIGIT ',' DIGIT ',' fieldtype  {
        struct SumField_t *SumField=SumField_constructor($1, $3, $5);
        if (SumField == NULL) {
            utl_abend_terminate(MEMORYALLOC, 137, ABEND_SKIP);
			YYABORT;
		}
        SumField_addDefinition(SumField); 
        strcpy(szMexToken, " sum fields clause ");
}    
;   

sumclause: 
      SUM FIELDS NONE {
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
}
    | SUM FIELDS '(' allsumfield ')' {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
}
;
/* ============================================== */
tokskipclause: 
       TOKSKIP {
		//printf("OCSORT: Warning Token skipped : %s\n",yylval.string);
}
;

filesgroup:
         STRING {
        struct file_t *file;
		file=file_constructor($1);
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 138, ABEND_SKIP);
			YYABORT;
		}
		nCountGroupFiles++;
		if (nCountGroupFiles == 1) 
			outfil_setOutfilFiles(current_outfil, file);
		else
            file_addQueue(&current_outfil->outfil_File, file);
        file_SetInfoForFile(file, COB_OPEN_OUTPUT); 
        free($1);
        strcpy(szMexToken, " files clause ");
}	
    /* ################################################## */
    /*  OUTFIL FNAMES=(FILE1,FILE2,FILE3,FILE4)           */
    /* ################################################## */
      | filesgroup ',' filesgroup {
		strcat(szMexToken, " group files outfil ");
}
;

fnamesclause: 
	   FNAMES '=' '(' filesgroup ')' {
}
	 | FNAMES '=' filesgroup  {
}
	|  SPLIT {
	   utils_SetOptionSort("SPLIT", current_outfil, 0);
       strcpy(szMexToken, " option SPLIT clause ");
}
	|  SPLITBY DIGIT {
	   utils_SetOptionSort("SPLITBY", current_outfil, $2);
       strcpy(szMexToken, " option SPLITBY clause ");
}
;
outfilincludeclause: 
      INCLUDE '=' allcondfield  {

		if (current_outfil != NULL)
			setOutfilIncludeCondField(current_outfil, $3);
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil include clause ");
}
;
outfilomitclause: 
      OMIT '=' allcondfield  {
		if (current_outfil != NULL)
			setOutfilOmitCondField(current_outfil, $3);
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil omit clause ");
}
;
outfilclause: 
      OUTFIL  {
		struct outfil_t *outfil=outfil_constructor();
        if (outfil == NULL) {
            utl_abend_terminate(MEMORYALLOC, 139, ABEND_SKIP);
			YYABORT;
		}
		if (current_outfil == NULL)
			outfil_addDefinition(outfil); 
		else 
			outfil_addDefinition(outfil); 
		current_outfil=outfil; 
		nstate_outfil=1;
        strcpy(szMexToken, " outfil clause ");
}
;
startrecclause: 
      STARTREC '=' SIGNDIGITBIG {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, $3);
		strcpy(szMexToken, " start rec clause ");
}
    | STARTREC '=' DIGIT {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, $3);
		strcpy(szMexToken, " start rec clause ");
}
;

endrecclause: 
      ENDREC '=' SIGNDIGITBIG {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, $3);
		strcpy(szMexToken, " end rec clause ");
}
    | ENDREC '=' DIGIT {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, $3);
		strcpy(szMexToken, " end rec clause ");
}
;

saveclause: SAVE {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
		strcpy(szMexToken, " save clause ");
}
;


alloption: 
      option {}
        //| option ',' alloption {}
    | option  alloption {}
;
option: 
      COPY {
        utils_SetOptionSort("COPY", NULL, 0);
		strcpy(szMexToken, " option copy clause ");
}
    | SKIPREC '=' SIGNDIGITBIG {
        utils_SetOptionSortNum("SKIPREC", $3);
		strcpy(szMexToken, " option skip rec clause ");
}
    | SKIPREC '=' DIGIT {
        utils_SetOptionSortNum("SKIPREC", $3);
		strcpy(szMexToken, " option skip rec clause ");
}
    | STOPAFT '=' SIGNDIGITBIG {
        utils_SetOptionSortNum("STOPAFT", $3);
		strcpy(szMexToken, " option stop after clause ");
}
    | STOPAFT '=' DIGIT {
        utils_SetOptionSortNum("STOPAFT", $3);
		strcpy(szMexToken, " option stop after clause ");
}
    | VLSCMP {
        utils_SetOptionSort("VLSCMP", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    | VLSHRT {
        utils_SetOptionSort("VLSHRT", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
;
optionclause: 
       OPTION {
} alloption {
};



%%
