/*
    Copyright (C) 2016-2021 Sauro Menna
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
    struct changefield_t *changefield;
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
    #include <time.h>
	#include "gcsort.h"
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
    #include "gcshare.h"
    #include "datediff.h"
    #include "changefield.h"
    #include "join.h"

	#define  INREC_CASE		1
	#define  OUTREC_CASE	2
    #define  JOIN_CASE      3
    
    /* -->> extern char szMexToken[260];    */

	int yylex    (void);
	void yyerror (char const *);

	struct file_t*		  current_file=NULL;
	struct outfil_t*	  current_outfil=NULL;
	struct condField_t*	  condField=NULL;
    struct inrec_t *      inrec=NULL;
    struct outrec_t *     outrec=NULL;
    struct changefield_t* current_changefield=NULL;
    struct join_t*        current_join=NULL;
    struct join_t*        F1_join=NULL;
    struct join_t*        F2_join=NULL;
    int    pntChange = 0;  /* 1 = Inrec , 2 = Inrec */

	int nRecCase=0;
	int nTypeFile=0;
	int current_outrec=0;
	int current_inrec=0;
	int current_sortField=0;
    int current_filejoin=0;         /* Join File 1 = F1, 2 = F2  */
    int inrec_overlay=0;
    int outrec_overlay=0;
	int nPosAbsRec=0;
	int nRtc=0;
	int nCountGroupFiles=0;
	char* pszInt;
    
    int nDateType=-1;
    int nDateCheck=0;
    int nDateNew=0;
    char szBuf[30];

	extern int nTypeFieldsCmd;
	char szTmp[5];
	int	 nIntTmp;
	int  nTypeFormat;			/* 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields  */
	int  nTypeIncludeOmit;		/* 0= Nothing, 1 = Include, Omit=2                              */
	int  nstate_outfil = 0;
    int  nOnly=0;

}
%token				AND						"AND clause"
%token				COND					"COND clause"
%token				ENDREC					"ENDREC clause"
    /*  %token				FILES					"FILES  clause" */
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
%token       		VLSCMP					"VLSCMP clause"
%token          	VLSHRT					"VLSHRT clause"
%token              Y2PAST                  "Y2PAST clause"
%token              MODS                    "MODS clause"
%token <string>     EXROUT                  "EXROUT clause"
%token 				BUILD					"BUILD instruction"
%token 				FIELDS					"FIELDS instruction"
%token 				OVERLAY					"OVERLAY instruction"
%token 				GIVE					"GIVE clause"
%token 				MERGE					"MERGE clause"
%token 				ORG						"ORG instruction"
%token 				RECORD					"RECORD instruction"
%token 				SORT					"SORT clause"
%token              JOINKEYS                "JOINKEYS clause"
%token 				USE						"USE clause"
%token 				COPY					"COPY"
%token 				TYPE                    "TYPE"
%token 				LENGTH                  "LENGTH"
%token 				DATE1                   "DATE1"
%token 				DATE2                   "DATE2"
%token 				DATE3                   "DATE3"
%token 				DATE4                   "DATE4"
%token              CHANGE                  "CHANGE"
%token              NOMATCH                 "NOMATCH"
%token              SORTED                  "SORTED"                   
%token              NOSEQCK                 "NOSEQCK"
%token              UNPAIRED                "UNPAIRED"
%token              ONLY                    "ONLY"
%token              JOIN                    "JOIN"
%token              JOINREFORMAT            "JOINREFORMAT"
%token              FILL                    "FILL"

%token <number>		DIGIT					"DIGIT"
%token <number>		DIGITBIG		        "DIGITBIG"
        /* %token <number>     ADDSUBNUM               "ADDSUBNUM" */
%token <string>		CHARTCOND  			    "CHARTCOND" 
%token <string>		CHARTYPE				"CHARTYPE" 
%token <string>		FILETYPE				"FILETYPE"
%token <string>		FORMATTYPE				"FORMATTYPE"
%token <string>     JOINFILE                "JOINFILE"
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
%type <fieldValue>	datetype
%type <condField>	condfieldcond
%type <condField>	allcondfield
%type <SumField>	sumfield
%type <SumField>	allsumfield
%type <fieldValue>	fieldvalueconst
%type <string>      filesgroup
%type <changefield> changepair
%type <changefield> changepairdet
%type <fieldValue>  changeCmdOpt      
%left OR
%left AND
%%
%start beginning
;
beginning:
		| clause beginning
;
clause:   recordclause {}
		| sortclause {}
		| mergeclause {}
        | joinkeysclause {}
        | joinclause {}
        | joinreformatclause{}
        | joinkeysalloptions{}
        | joinoptions{}
        | fill_char{}
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
            /* | filesclause {} */
		| saveclause {}
		| optionclause {}
        | buildclause {}
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
        file_SetInfoForFile(current_file, COB_OPEN_INPUT); /* Input */
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
        file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); /*  Output  */
        current_file=NULL;
};

recordorginstruction: 
    { 	
        strcat(szMexToken, " record org instruction "); 
    }
    /*
	| ORG FILETYPE  {  
        strcpy(szMexToken, " org file type ");
   
        if (current_file!=NULL) {
            nRtc = file_setOrganization(current_file,utils_parseFileOrganization($2));
            if (nRtc == -1)
                exit(GC_RTC_ERROR);
            nTypeFile = utils_parseFileOrganization($2);
        }
        free($2);    
}
    */
	| ORG FILETYPE recordorginstruction {  
        strcpy(szMexToken, " org file type ");
   
        if (current_file!=NULL) {
            nRtc = file_setOrganization(current_file,utils_parseFileOrganization($2));
            if (nRtc == -1)
                exit(GC_RTC_ERROR);
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
    /* key clause - END */
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
		$$=fieldValue_constructor((char*) $1, $2, TYPE_STRUCT_STD, 0);
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
		$$=fieldValue_constructor((char*) $1, $2, TYPE_STRUCT_STD, 0);
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
    /* DIGIT = Numeric value max [+/-] 5 digit  */
    /* #################################################################################################### */
      DIGIT {
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%d", $1);
		$$=(struct fieldValue_t *) fieldValue_constructor((char*)"Z", pszInt, TYPE_STRUCT_NEW, 0);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 106, ABEND_SKIP);
			YYABORT;
		}
		free(pszInt); 
}
    /* #################################################################################################### */
    /* DIGIT = Numeric value DIGIT from [+/-] 6 to n digit  */
    /* #################################################################################################### */
    | SIGNDIGITBIG  {
		char szType[] = "Z";
		pszInt = (char*) malloc(32);		 
		#ifdef	_MSC_VER
			sprintf(pszInt, CB_FMT_LLD , $1);
		#else
			sprintf(pszInt, CB_FMT_LLD , $1);
		#endif
		/*  -->> 20160914 $$=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_STD);    */
		$$=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_NEW, 0);
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
            /* Sort Fields */
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
            /* JoinKeys */
        if (current_sortField==3) {             
            struct sortField_t *joinField;
            joinField=sortField_constructor($1,$3,0, $5);
			if (joinField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 108, ABEND_SKIP);
				YYABORT;
			}
            join_addDefinitionJoin(current_filejoin, joinField);
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
            /*  -->> nTypeFormat = 1; // Format external token  */
			}
}
;

sortclause: 
      SORT FIELDS '(' {
        current_sortField=1;
        } allsortfield ')' {
        current_sortField=0;
        job_SetTypeOP('S');		/* for Sort */
        strcpy(szMexToken, " sort clause ");
}
    | SORT FIELDS COPY {
        job_SetTypeOP('C');		/* for Merge    */
        job_SetFieldCopy(1);
        strcpy(szMexToken, " sort clause ");

}

mergeclause: 
      MERGE FIELDS '(' {
        current_sortField=1;
        strcpy(szMexToken, " merge clause ");
        } allsortfield ')' {
        current_sortField=0;
        /* typeOP = 'M'; // for Merge   */
        job_SetTypeOP('M');
        strcpy(szMexToken, " merge clause ");
}
    | MERGE FIELDS COPY {
        job_SetTypeOP('C');
        job_SetFieldCopy(1);
        strcpy(szMexToken, " merge clause ");
}
;

        /* JOINKEYS Statement */
        /* JOINKEYS  FILE=F1 , FIELDS=(pos,len,ord,.....) */
joinkeysclause: 
      JOINKEYS FNAMES '=' JOINFILE ',' FIELDS '(' {
        job_SetTypeOP('J');		/* for Join */
        current_sortField=3;            /* Sort field / Join field for JOIN STATEMENT */
        if (globalJob->join == NULL) {
            struct join_t* pJoin = join_constructor();
            if (pJoin == NULL) {
                utl_abend_terminate(MEMORYALLOC, 509, ABEND_SKIP);
                YYABORT;
            }
            current_join = pJoin;
            join_SetReferenceJob(current_join);     /* Save reference join into job */
        }
        if (memcmp($4,(char*) "F1",2)==0) {
            current_filejoin = 1;
        }
        if (memcmp($4,(char*) "F2",2)==0) {
            current_filejoin = 2;
        }
        } allsortfield ')'  {
        current_sortField=0;
        strcpy(szMexToken, " joinkeys clause ");        
        free($4);  /* Verify */
}
;


joinkeysalloptions: 
      joinkeysoptions {}
    | joinkeysoptions  joinkeysalloptions {}
;

joinkeysoptions:
      ',' SORTED  {
		strcpy(szMexToken, " join option sorted  ");
        join_IsSorted(current_filejoin, current_join);
}
    | ',' SORTED ',' NOSEQCK {
		strcpy(szMexToken, " join option noseqck  ");
        join_noSeqCk(current_filejoin, current_join);
}
    | STOPAFT '=' SIGNDIGITBIG {
		strcpy(szMexToken, " join option stop after 1");
        join_stopAfter(current_filejoin, current_join, $3);
}
    | STOPAFT '=' DIGIT {
		strcpy(szMexToken, " join option stop after 2");
        join_stopAfter(current_filejoin, current_join, $3);
}
;

        /* JOIN Statement */
        /* JOIN UNPAIRED,F1,F2,ONLY  */
        /* I = Inner, U = Unpaired , O = Only,  S= Skip
        |=========================|===================|============|=================================|
        |       Command           |   Join Type       |    Flag    |           Output                |
        |=========================|===================|============|=================================|
        | not specified           | Inner join        | F1=I, F2=I | F1 matched, F2 matched          |
        | Unpaired, F1, F2        | Full outer join   | F1=U, F2=U | All records                     |
        | Unpaired                | Full outer join   | F1=U, F2=U | All records                     |
        | Unpaired, F1            | Left outer join   | F1=U, F2=I | F1 all records and F2 matched   |
        | Unpaired, F2            | Right outer join  | F1=I, F2=U | F1 matched and F2 all records   |
        | Unpaired, F1, F2, Only  | Only unpaired     | F1=O, F2=O | F1 no matched, F2 no matched    |
        | Unpaired, Only          | Only unpaired     | F1=O, F2=O | F1 no matched, F2 no matched    |
        | Unpaired, F1, Only      | Unpaired from F1  | F1=O, F2=S | F1 only no matched, F2 Skipped  |
        | Unpaired, F2, Only      | Unpaired from F2  | F1=S, F2=O | F1 Skipped, F2 only no matched  |
        |=========================|===================|============|=================================|
        */
joinclause: 
      JOIN  UNPAIRED  {
        strcpy(szMexToken, " join unpaired clause ");
        join_setUnpaired(1, 'U');
        join_setUnpaired(2, 'U');
        nOnly=0;
}
    | JOIN  UNPAIRED joinoptions {
        strcpy(szMexToken, " join unpaired clause ");
        if (nOnly  == 0) {
            join_setUnpaired(1, 'U');
            join_setUnpaired(2, 'U');
        }
        if (nOnly  == 1) {
            join_setUnpaired(1, 'O');
            join_setUnpaired(2, 'O');
        }
        nOnly=0;
}
        /* JOIN UNPAIRED,F1 or F2 */
    | JOIN  UNPAIRED ',' JOINFILE joinoptions {
        strcpy(szMexToken, " join unpaired clause ");
        if (nOnly  == 0) {
            if (memcmp($4,(char*) "F1",2)==0) {
                join_setUnpaired(1, 'U');
                join_setUnpaired(2, 'I');
            }
            if (memcmp($4,(char*) "F2",2)==0) {
                join_setUnpaired(1, 'I');
                join_setUnpaired(2, 'U');
            }
        }
        if (nOnly  == 1) {
            if (memcmp($4,(char*) "F1",2)==0) {
                join_setUnpaired(1, 'O');
                join_setUnpaired(2, 'S');
            }
            if (memcmp($4,(char*) "F2",2)==0) {
                join_setUnpaired(1, 'S');
                join_setUnpaired(2, 'O');
            }
        }
        nOnly=0;
        free($4); 
}
        /*     JOIN UNPAIRED,F1,F2 */
    | JOIN  UNPAIRED ',' JOINFILE ',' JOINFILE joinoptions {          
        current_sortField=0;                                          
        strcpy(szMexToken, " sort clause ");                          
        if (nOnly  == 0) {                                            
            join_setUnpaired(1, 'U');                             
            join_setUnpaired(2, 'U');                             
        }
        if (nOnly  == 1) {
            join_setUnpaired(1, 'O');
            join_setUnpaired(2, 'O');
        }
        nOnly=0;
        free($4); 
        free($6); 
}
;

joinoptions:
    |   ',' ONLY  {
        /* utils_SetOptionSort("ONLY", NULL, 0); */
		strcpy(szMexToken, " joinoptions ONLY clause ");
        nOnly=1;
}
;

    /* JOINREFORMAT */
    

joinreformatclause: 
/* s.m. 20160915 */
           /*     JOINREFORMAT FIELDS '(' {
                    strcpy(szMexToken, " joinreformat clause ");
                    //  verify if mandatory current_outrec=1;  
                    nRecCase=JOIN_CASE;
                    nPosAbsRec = 0;
            } allinoutrec ')' {
                    current_outrec=0;
                    nRecCase=0;
            } */
     JOINREFORMAT FIELDS '(' {
		strcpy(szMexToken, " joinreformat clause ");
        /*  verify if mandatory current_outrec=1;  */
        nRecCase=JOIN_CASE;
		nPosAbsRec = 0;
} allinoutrec ')' fill_char {
        current_outrec=0;
        nRecCase=0;
}
;

fill_char:
    |  FILL  CHARTYPE  STRING {
        current_outrec=0;
        nRecCase=0;
        strcpy(szMexToken, " join fill clause ");
        /* fill character * */
        join_fillbuff(current_filejoin, current_join, $2, $3);
        free($2);
        free($3);
}
;

/* #################################################################################################### */
/* -->>nTypeFormat;			// 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields  */
/* -->>nTypeIncludeOmit;		// 0= Nothing, 1 = Include, 2 = Omit                        */
/* #################################################################################################### */
formatclause: 
      FORMAT '=' fieldtype {
		strcpy(szMexToken, " format clause ");
		if (nTypeFormat == 1)
			condField_setFormatFieldsTypeAll(nTypeFormat, $3);
		if (nTypeFormat == 2)
			condField_setCondFieldsTypeAll(nTypeIncludeOmit, $3);
		if (nTypeFormat == 3)	/* for SumFields    */
			condField_setFormatFieldsTypeAll(nTypeFormat, $3);
}
/* s.m. 20160914
    | ',' FORMAT '=' fieldtype {
        if (nTypeFormat == 1)
            condField_setFormatFieldsTypeAll(nTypeFormat, $4);
        if (nTypeFormat == 2)
            condField_setCondFieldsTypeAll(nTypeIncludeOmit, $4);
        if (nTypeFormat == 3)	//  for SumFields  
            condField_setFormatFieldsTypeAll(nTypeFormat, $4);
		strcpy(szMexToken, " format clause ");
}
*/
;
allcondfield: 
    condfieldcond {
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


condfieldcond: 	
    /* #################################################################################################### */
    /* pos1, len1, format1, operator, pos2, len2, format2 -                                                 */
    /* check field in pos1 for len1 and format1 with field in pos2 for len2 and format2, apply operator     */
    /* (156,15,CH,LT,141,15,CH)                                                                             */
    /* #################################################################################################### */
      DIGIT ',' DIGIT ',' fieldtype ',' condition ',' DIGIT ',' DIGIT ',' fieldtype {
        nTypeFormat = 2; /* Format external token   */
        condField=condField_constructor_conditionfield($1,$3,$5,$7,$9,$11,$13);
        $$=condField;
        strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
}

    /* #################################################################################################### */
    /* pos1, len1, format1, operator, pos2, len2, format2 -                                                 */
    /* check field in pos1 for len1 with field in pos2 for len2 and apply operator, mandatory FORMAT=nn     */
    /* (156,15,LT,141,15),FORMAT=CH                                                                         */
    /* #################################################################################################### */
    |  DIGIT ',' DIGIT ',' condition ',' DIGIT ',' DIGIT  {
        nTypeFormat = 2; /* Format external token   */
        condField=condField_constructor_conditionfield($1,$3,0,$5,$7,$9,0);
        $$=condField;
        strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
}
    /* #################################################################################################### */
    /* pos, len, operator, format, condition, value                                 */    
    /* case 1,6,CH,EQ,C'String'  field in position 1 with length 6 equal 'String'   */
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
    /* pos, len, type field, operator, value numeric    */
    /* case 88,13,ZD,LT,-10  field ZD in position 88 with length 13 must be less then -10   */
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
    /* pos, len, operator, value numeric .   Mandatory FORMAT= for type     */
    /* case 88,13,LT,-10  field in position 88 with length 13 less then -10 */
    /* #################################################################################################### */
    | DIGIT ',' DIGIT ',' condition ',' fieldvalueconst  {    
        condField=condField_constructor_condition($1,$3,0,$5,(struct fieldValue_t *)$7);
        nTypeFormat = 2; /* Format external token   */
        $$=condField;
        strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 115, ABEND_SKIP);
			YYABORT;
		}
}
    /* #################################################################################################### */
    /* pos, len, operator, value numeric .   Mandatory FORMAT= for type     */
    /* case 45,6,LE,C'999999'  field in position 45 with length 6 less then '999999'    */
    /* #################################################################################################### */
    | DIGIT ',' DIGIT ',' condition ',' fieldvaluecond  {    
        condField=condField_constructor_condition($1,$3,0,$5,(struct fieldValue_t *)$7);
        nTypeFormat = 2; /* Format external token   */
        $$=condField;
        strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 116, ABEND_SKIP);
			YYABORT;
		}
}
    /* #################################################################################################### */
    /* pos, len, operator, date .   DATE1/DATE2/DATE3/DATE4                 */
    /* case INCLUDE COND=(1,13,CH,GT,DATE4)                                                   */
    /* #################################################################################################### */
    | DIGIT ',' DIGIT ','  fieldtype ','condition ',' datetype  {    
        condField=condField_constructor_condition4Date($1,$3,$5,$7,(struct fieldValue_t *)$9);
        nTypeFormat = 2; /* Format external token   */
        $$=condField;
        strcat(szMexToken, " condition field ");
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 141, ABEND_SKIP);
			YYABORT;
		}
}

 /* datetype: Constant Date currente date  */
datetype: 
    /* ########################## */
    /*  DATETYPE -->  DATE1/2/3/4 */
    /* ########################## */
    /* All date type Y2T field len define rappresentation */
    /* DATE1    C'yyyymmdd'    C'20010419' */
       DATE1  { 
		nDateType = 1;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        memset(szBuf, 0x00, 30);
        /* current date into string */
        sprintf(szBuf, "%d", nDateCheck);   
        $$=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 142, ABEND_SKIP);
			YYABORT;
		}
}
    /* DATE1    C'yyyymmdd'    C'20010419' */
    /* |   DATE1 ADDSUBNUM { */
    |   DATE1 DIGIT { 
		nDateType = 1;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        /* check range */
        if ($2 > 366) {
            utl_abend_terminate(0, 142, ABEND_SKIP);
			YYABORT;
        }
        /* Add/Sub days to date */
        gcDateAddDays(nDateCheck, &nDateNew, $2);
        nDateCheck = nDateNew;

        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string */
        $$=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 142, ABEND_SKIP);
			YYABORT;
		}
}
    /* DATE2    C'yyyymm'      C'200104'  */
    |  DATE2  {             /* Problem ++ to define datetype */
		nDateType = 2;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 100 + (tm.tm_mon + 1);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string */
        $$=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 143, ABEND_SKIP);
			YYABORT;
		}
}
    /* DATE2    C'yyyymm'      C'200104'  */
    /* |  DATE2 ADDSUBNUM { */            /* Problem ++ to define datetype */
    |  DATE2 DIGIT {             /* Problem ++ to define datetype */
		nDateType = 2;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 100 + (tm.tm_mon + 1);
        /* check range */
        if ($2 > 12) {
            utl_abend_terminate(0, 142, ABEND_SKIP);
			YYABORT;
        }
        /* Add/Sub months to date */
        /* from YYYYMM  to YYYYMMDD */
        nDateCheck = nDateCheck * 100 + 1 ;
        /* add Month to date*/
        gcDateAddMonths(nDateCheck, &nDateNew, $2);
        /* from YYYYMMDD  to YYYYMM */
        nDateCheck = (nDateNew / 100);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string */
        $$=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 143, ABEND_SKIP);
			YYABORT;
		}
}
    /* DATE3    C'yyyyddd'     C'2001109' */
    |  DATE3  { 
		nDateType = 3;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        /* Convert date from YYMMAA  to YYDDD */
        gcDate2Ord(nDateCheck, &nDateNew);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateNew);   /* current date into string with format yyyyddd */
        $$=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 144, ABEND_SKIP);
			YYABORT;
		}
}
    /* DATE3    C'yyyyddd'     C'2001109' */
    /* |  DATE3 ADDSUBNUM { */
    |  DATE3 DIGIT { 
		nDateType = 3;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        /* Convert date from YYMMAA  to YYDDD */
        /* check range */
        if ($2 > 366) {
            utl_abend_terminate(0, 142, ABEND_SKIP);
			YYABORT;
        }
        /* Add/Sub days to date */
        gcDateAddDays(nDateCheck, &nDateNew, $2);
        gcDate2Ord(nDateNew, &nDateCheck);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string with format yyyyddd */
        $$=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 144, ABEND_SKIP);
			YYABORT;
		}
}
     /* DATE4    C'yyyy-mm-dd-hh.mm.ss' */
    |  DATE4  { 
		nDateType = 4;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Datetime */
        memset(szBuf, 0x00, 30);
        /* Problem with timestamp force to Y2T8 8 bytes  CCYYMMAA without time */
        /* TODO timestamp */
        /* sprintf(szBuf, "%0.4d-%0.2d-%0.2d-%0.2d.%0.2d.%0.2d", tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec);  */ /* current datetime into string */
        /* prepare date like CCYYMMDD */
        sprintf(szBuf, "%04d%02d%02d", tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday);  
        $$=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 145, ABEND_SKIP);
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
    /* pos , len of  input      */
    /* case 10,5  copy field from position 10 for len 5 from input, into actual position of output record   */
    /* #################################################################################################### */
    /*     int    pntChange = 0; 1 = Inrec , 2 = Inrec */
      DIGIT ',' DIGIT {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_range($1,$3);
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
                pntChange = 2; 
            }
            else
            {
                /* struct outrec_t * */
                outrec=outrec_constructor_range($1,$3);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 118, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
                pntChange = 2; 
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                    /* struct inrec_t * */
                    inrec=inrec_constructor_range($1,$3);
                    if (inrec == NULL) {
                        utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                        YYABORT;
                    }
                    nPosAbsRec += inrec->range.length;
                    inrec->nIsOverlay=inrec_overlay;
                    inrec_addDefinition(inrec);
                    /* save pointer CHANGE option */
                    pntChange = 1; 
            }
            break;
        case JOIN_CASE :
            strcpy(szMexToken, " join reformat clause ");
            /* struct reformat_t * */
            inrec=inrec_constructor_range_join(current_filejoin, $1,$3);
            if (inrec == NULL) {
                utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                YYABORT;
            }
            nPosAbsRec += inrec->range.length;
            /* inrec->nIsOverlay=inrec_overlay; */
            join_reformat_addDefinition(inrec);
            /* save pointer CHANGE option */
            pntChange = 1; 
            break;
        default:
            break;
        }
} 
    /*      Character ? for statement JOINKEYS                */
    | '?'  {
        if (nRecCase == 3)
            strcpy(szMexToken, " join reformat clause ");
            /* struct reformat_t * */
            inrec=inrec_constructor_range_join(current_filejoin, -99,1);       /* Fix value */
            if (inrec == NULL) {
                utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                YYABORT;
            }
            nPosAbsRec += inrec->range.length;
            /* inrec->nIsOverlay=inrec_overlay; */
            join_reformat_addDefinition(inrec);
            /* save pointer CHANGE option */
            pntChange = 1; 
}
    | JOINFILE ':' DIGIT ',' DIGIT {
            strcpy(szMexToken, " join reformat clause ");
            /* struct reformat_t * */
            if (memcmp($1,(char*) "F1",2)==0) {
                current_filejoin = 1;
            }
            if (memcmp($1,(char*) "F2",2)==0) {
                current_filejoin = 2;
            }
            inrec=inrec_constructor_range_join(current_filejoin, $3,$5);
            if (inrec == NULL) {
                utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                YYABORT;
            }

            nPosAbsRec += inrec->range.length;
            /* inrec->nIsOverlay=inrec_overlay; */
            join_reformat_addDefinition(inrec);
            /* save pointer CHANGE option */
            pntChange = 1; 
            free($1);
}      
    /* new  20201211 start  */
    /* ######################################################################################## */
    /* case 11:C'A'  (from position 11 output, copy character 'A')  */
    /* ######################################################################################## */
    | DIGIT ':' CHARTYPE STRING {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_possubstnchar($1, $3, $4);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 124, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_possubstnchar($1, $3, $4);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 125, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
           break;
        default:
            break;
        }
        free($3); /* s.m. 202015    */
		free($4); 
}
    /* new  20201211 end    */
    /* ######################################################################################## */
    /* (pos 20 output), (pos 10, len 5 input)       */
    /* case 20:10,5  (from position 20 output, copy field position 10 for len 5 from input)     */
    /* ######################################################################################## */
    | DIGIT ':' DIGIT ',' DIGIT {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_range_position($1, $3, $5);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 120, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec = outrec->range_position.posAbsRec + outrec->range_position.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_range_position($1, $3, $5);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 121, ABEND_SKIP);
                    YYABORT;
                }
                nPosAbsRec = inrec->range_position.posAbsRec + inrec->range_position.length;
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
            }
            break;
       }
}
    /* ######################################################################################## */ 
    /* [0-9]{1,5}[C|X|Z]{1}                                                                     */
    /* nZ  n times of binary zero                                                               */
    /* nX  n times of blank,                                                                    */
    /* case : 50X  (repeat 50 times blank)                                                      */
    /* ######################################################################################## */
    | OCCURFILL {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_subst($1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 122, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_subst($1);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 123, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
            break;
        default:
            break;
        }
		free($1);
}
    /* #######################################################  */
    /* [0-9]{1,5}[C|X|Z]{1} <string>                            */
    /* nC'string'  n times of string						    */
    /* 5C'XYZ'	-> XYZXYZXYZXYZXYZ   						    */
    /* #######################################################  */
    | OCCURFILL STRING {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_substnchar($1,$2);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 124, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_substnchar($1,$2);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 125, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
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
    /* ######################################################## */    
    /* position absolute (output) : (C|X|Z) CharType	        */
    /* case 80:X                                                */
    /* ######################################################## */
    | DIGIT ':' CHARTYPE {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_padding($1, $3, nPosAbsRec);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 126, ABEND_SKIP);
                    YYABORT;
                }
                if ($1 > nPosAbsRec) 
                    nPosAbsRec = $1;
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_padding($1, $3, nPosAbsRec);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 127, ABEND_SKIP);
                    YYABORT;
                }
                if ($1 > nPosAbsRec) 
                    nPosAbsRec = $1;		/* - inrec->change_position.fieldValue->generated_length;   */
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
            }
           break;
        default:
            break;
        }
        free($3); 
}
    /* ######################################################## */
    /* (C|X|Z) CharType	                                        */
    /* case X or Z                                              */
    /* ######################################################## */
    | CHARTYPE {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
       /*         struct outrec_t *outrec=outrec_constructor_subst($1); */
                char szType01[3];
                memset(szType01, 0x00, 3);
                szType01[0]='1';
                strcat(szType01, $1);
                /* struct outrec_t * */
                outrec=outrec_constructor_subst(szType01);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 128, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
        /*                inrec=inrec_constructor_subst($1);    */
                char szType01[3];
                memset(szType01, 0x00, 3);
                szType01[0]='1';
                strcat(szType01, $1);
                inrec=inrec_constructor_subst(szType01);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 129, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
           break;
        default:
            break;
        }
        free($1); /* s.m. 202105    */
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
                /* struct outrec_t * outrec; */
                outrec=outrec_constructor_change($1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 130, ABEND_SKIP);
                    YYABORT;
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_change($1);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 131, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
            break;
        default:
            break;
        }
	}
	
/* condizione di posizione di partenza senza lunghezza per i file variabili */
    | DIGIT ',' {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_range($1,-1);
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
                /* struct outrec_t * */ 
                outrec=outrec_constructor_range($1,-1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_range($1,-1);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 134, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
            }
            break;
        default:
            break;
        }
}
    /* CHANGE OPTION */
    /*  pos, len,  CHANGE=( v , find, set ) , NOMATCH=(set) */
    /* | CHANGE '(' DIGIT ',' changepair ')' ',' NOMATCH '(' fieldvaluecond ')' { */        
    /* CHANGE=(1,C'22',X'51',C'88',X'58',C'44',X'52',C'66',X'53'),NOMATCH=(X'77') */
     | CHANGE '(' DIGIT ',' changepair ')' ',' NOMATCH '(' changeCmdOpt ')' { 
        /* define struct for change field */
        
        struct change_t* chg = change_constructor($3);
        change_setNoMatch(chg, $10);  
        change_setpairs(chg, $5);
        /*    int    pntChange = 0 - 1 = Inrec , 2 = Inrec */
         if (pntChange == 1) {       /* InRec */
            inrec_SetChangeCmdOpt(inrec, chg);  /* setting INREC_TYPE_CHANGE_CMDOPT; */
         } else 
             if (pntChange == 2) {       /* OutRec */
                outrec_SetChangeCmdOpt(outrec, chg);  /* setting OUTREC_TYPE_CHANGE_CMDOPT; */
             } else {
                 utl_abend_terminate(100, 234, ABEND_SKIP);
                 YYABORT;
         }
         /* adjust position */
         nPosAbsRec += $3;       /* len output change */
}
        /* CHANGE=(6,C'2',28,6),NOMATCH=(2,6) */
     | CHANGE '(' DIGIT ',' changepair ')' ',' NOMATCH '(' DIGIT ',' DIGIT ')' { 
        /* define struct for change field */
        
        struct change_t* chg = change_constructor($3);
        change_setNoMatchPosLen(chg, $10, $12);  
        change_setpairs(chg, $5);
        /*    int    pntChange = 0 - 1 = Inrec , 2 = Inrec */
         if (pntChange == 1) {       /* InRec */
            inrec_SetChangeCmdOpt(inrec, chg);  /* setting INREC_TYPE_CHANGE_CMDOPT; */
         } else 
             if (pntChange == 2) {       /* OutRec */
                outrec_SetChangeCmdOpt(outrec, chg);  /* setting OUTREC_TYPE_CHANGE_CMDOPT; */
             } else {
                 utl_abend_terminate(100, 234, ABEND_SKIP);
                 YYABORT;
         }
         /* adjust position */
         nPosAbsRec += $3;       /* len output change */
}
;

changepair: 
      changepairdet { 
        strcat(szMexToken, " changepairdet instruction ");
        $$=$1;
}
    | changepairdet ',' changepair {}
 ;

changepairdet: 
    /* #################################################################################################### */
    /*  find, set  */
    /*   C'STR',C'String' */
    /* #################################################################################################### */
      CHARTYPE  STRING ',' CHARTYPE  STRING { 
		/* $$=changefield_constructor((char*) $2, $5); */
        /* verify      CHARTCOND  vs CHARTYPE */     
        struct fieldValue_t* fv1 = fieldValue_constructor((char*) $1, $2, TYPE_STRUCT_STD, 0);
		if (fv1 == NULL) {
            utl_abend_terminate(MEMORYALLOC, 218, ABEND_SKIP);
			YYABORT;
		}
        struct fieldValue_t* fv2 = fieldValue_constructor((char*) $4, $5, TYPE_STRUCT_STD, 0);
		if (fv2 == NULL) {
            utl_abend_terminate(MEMORYALLOC, 218, ABEND_SKIP);
			YYABORT;
		}
        
        struct changefield_t* pcf = changefield_constructor(fv1, fv2);
		if (pcf == NULL) {
            utl_abend_terminate(MEMORYALLOC, 215, ABEND_SKIP);
			YYABORT;
		}
        if (current_changefield == NULL)
			changefield_t_addQueue(&current_changefield, pcf); 
		else 
			changefield_t_addQueue(&current_changefield, pcf); 
		current_changefield = pcf; 
		free($1); 
		free($2); 
        free($4);
		free($5); 
        $$=pcf;
}
        /* CHANGE=(6,C'2',28,6) */
   |   CHARTYPE  STRING ',' DIGIT ',' DIGIT  { 
        /* verify      CHARTCOND  vs CHARTYPE */     
        struct fieldValue_t* fv1 = fieldValue_constructor((char*) $1, $2, TYPE_STRUCT_STD, 0);
		if (fv1 == NULL) {
            utl_abend_terminate(MEMORYALLOC, 218, ABEND_SKIP);
			YYABORT;
		}
        struct changefield_t* pcf = changefield_constructorPosLen(fv1, $4, $6);
		if (pcf == NULL) {
            utl_abend_terminate(MEMORYALLOC, 215, ABEND_SKIP);
			YYABORT;
		}
        if (current_changefield == NULL)
			changefield_t_addQueue(&current_changefield, pcf); 
		else 
			changefield_t_addQueue(&current_changefield, pcf); 
		current_changefield = pcf; 
		free($1); 
		free($2); 
        $$=pcf;
};

changeCmdOpt:
    /* #################################################################################################### */
    /*  Deault Value for no match  */
    /*   C'STR'  */
    /* #################################################################################################### */
    /* NOMATCH=(X'77') */
    CHARTYPE  STRING { 
        /* $$=changefield_constructor((char*) $2, $5); */
		$$=fieldValue_constructor((char*) $1, $2, TYPE_STRUCT_STD, 0);
		if ($$ == NULL) {
            utl_abend_terminate(MEMORYALLOC, 104, ABEND_SKIP);
			YYABORT;
		}
		free($1); 
		free($2);         
}
;
            

outrecclause: 
/* s.m. 20160915 */
      OUTREC FIELDS '=' '(' {
		strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
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
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_outrec=0;
        nRecCase=0;
}
/* s.m. 20160915 */
    | OUTREC BUILD '=' '(' {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
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
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_outrec=0;
        nRecCase=0;
}
    /* s.m. 20201206 */
    | OUTREC OVERLAY '=' '(' {
        strcpy(szMexToken, " outrec clause Overlay");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    |   /* */
      OUTREC OVERLAY '(' {
        strcpy(szMexToken, " outrec clause Overlay");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
        } allinoutrec ')' {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
};


/* Case for OUTREC in OUTFIL */
outrecclause:
/*  */
      OUTREC '=' '(' {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        strcpy(szMexToken, " outrec clause ");
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_outrec=0;
        nRecCase=0;
}
 /* */
  | OUTREC '(' {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
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
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_inrec=0;
        nRecCase=0;
}
    |   /* */
      INREC FIELDS '(' {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
        } allinoutrec ')' {
        current_inrec=0;
        nRecCase=0;
}
    /* */
    | INREC BUILD '=' '(' {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_inrec=0;
        nRecCase=0;
}
    /* */
    | INREC BUILD '(' {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
} allinoutrec ')' {
			current_inrec=0;
			nRecCase=0;
}
    /* s.m. 20201206 */
    | INREC OVERLAY '=' '(' {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
} allinoutrec ')' {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    |   /* */
      INREC OVERLAY '(' {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
        } allinoutrec ')' {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
};
/* =================================================================================== */


buildclause:
     ',' BUILD '(' {
        strcpy(szMexToken, " build clause ");
        /* current_inrec=1;         */
        /* nRecCase=INREC_CASE;     */
		nPosAbsRec = 0;
} allinoutrec ')' {
		/*  current_inrec=0;    */
		nRecCase=0;
}

/* OUTFIL   */
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
        nTypeFormat=3;			/* for SumFields Format=    */
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
                utl_abend_terminate(MEMORYALLOC, 140, ABEND_SKIP);
				YYABORT;
			}
			nTypeFormat=3;			/* for SumFields Format=    */
 			SumField_addDefinition(SumField1); 
			nTypeFormat=3;			/* for SumFields Format=    */
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
		/*  printf("GCSORT: Warning Token skipped : %s\n",yylval.string);   */
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
        if (nRecCase == JOIN_CASE) {
            if (current_join != NULL)       /* Join */
			    join_IncludeCondField(current_filejoin, current_join, $3);
        }
		if (current_outfil != NULL)
			setOutfilIncludeCondField(current_outfil, $3);
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil include clause ");
}
;
outfilomitclause: 
      OMIT '=' allcondfield  {
        if (nRecCase == JOIN_CASE) {
            if (current_join != NULL)       /* Join */
                join_OmitCondField(current_filejoin, current_join, $3);
        }
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
        /*  | option ',' alloption {}   */
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
    | Y2PAST '=' DIGIT {
        utils_SetOptionY2Past("Y2PAST", $3);
		strcpy(szMexToken, " option y2past clause ");
}
    | ',' EXROUT '=' '(' STRING ')' 
    {
        utils_SetOptionExRoutine("MODS", $2, $5);
		strcpy(szMexToken, " option MODS E15 clause 1");
        free($2);
        free($5);
}
    | MODS EXROUT '=' '(' STRING ')'
    {
        utils_SetOptionExRoutine("MODS", $2, $5);
		strcpy(szMexToken, " option MODS E15 clause 1");
        free($2);
        free($5);
}
    | MODS EXROUT '=' '(' STRING ',' DIGITBIG ')' {
        utils_SetOptionExRoutine("MODS", $2, $5);
		strcpy(szMexToken, " option MODS E15 clause 2");
        free($2);
        free($5);
}
    | MODS EXROUT '=' '(' STRING ',' DIGITBIG ',' STRING ')' {
        utils_SetOptionExRoutine("MODS", $2, $5);
		strcpy(szMexToken, " option MODS E15 clause 3");
        free($2);
        free($5);
        free($9);
}
    | MODS EXROUT '=' '(' STRING ',' DIGIT ')' {
        utils_SetOptionExRoutine("MODS", $2, $5);
		strcpy(szMexToken, " option MODS E15 clause 2");
        free($2);
        free($5);
}
    | MODS EXROUT '=' '(' STRING ',' DIGIT ',' STRING ')' {
        utils_SetOptionExRoutine("MODS", $2, $5);
		strcpy(szMexToken, " option MODS E15 clause 3");
        free($2);
        free($5);
        free($9);
}
;
optionclause: 
       OPTION {
} alloption {
};

/* RECORD CONTROL STATEMENT */
/*
allrecordoption: 
      recordoption {}
    | recordoption  allrecordoption {}
;
*/
recordoption: 
      RECTYPEFIX {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free($1);
}
    /* TYPE = F, LENGTH=(<num> */
    | RECTYPEFIX  LENGTH  '(' DIGIT ')' {
        utils_SetRecordOptionSortType($1);
        utils_SetRecordOptionSortLen($4, -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free($1);
}
    | RECTYPEFIX  LENGTH  '(' DIGIT ',' DIGIT ')' {
        utils_SetRecordOptionSortType($1);
        utils_SetRecordOptionSortLen($4, $6, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free($1);
}
    | RECTYPEFIX  LENGTH  '(' ',' DIGIT ')' {
        utils_SetRecordOptionSortType($1);
        utils_SetRecordOptionSortLen(-1, $5, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free($1);
}
    | RECTYPEFIX  LENGTH  '(' DIGIT ',' DIGIT ',' DIGIT ')' {
        utils_SetRecordOptionSortType($1);
        utils_SetRecordOptionSortLen($4, $6, $8, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free($1);
}
    | RECTYPEFIX  LENGTH  '('  ','  ',' DIGIT ')' {
        utils_SetRecordOptionSortType($1);
        utils_SetRecordOptionSortLen(-1, -1, $6, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free($1);
}
    | RECTYPEFIX  LENGTH  '(' DIGIT ','  ',' DIGIT ')' {
        utils_SetRecordOptionSortType($1);
        utils_SetRecordOptionSortLen($4, -1, $7, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free($1);
}
    /* TYPE = V, LENGTH=(<num> */
     | RECTYPEVAR {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free($1);
}
    /* TYPE = F, LENGTH=(<num> */
    | RECTYPEVAR  LENGTH '(' DIGIT ')' {
        utils_SetRecordOptionSortType($1);
        utils_SetRecordOptionSortLen($4, -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free($1);
}
    | RECTYPEVAR  LENGTH  '(' DIGIT ',' DIGIT ')' {
        utils_SetRecordOptionSortType($1);
        utils_SetRecordOptionSortLen($4, $6, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free($1);
}
    | RECTYPEVAR  LENGTH '(' ',' DIGIT ')' {
        utils_SetRecordOptionSortType($1);
        utils_SetRecordOptionSortLen(-1, $5, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free($1);
}
    | RECTYPEVAR  LENGTH  '(' DIGIT ',' DIGIT ',' DIGIT ')' {
        utils_SetRecordOptionSortType($1);
        utils_SetRecordOptionSortLen($4, $6, $8, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free($1);
}
    | RECTYPEVAR  LENGTH  '('  ','  ',' DIGIT ')' {
        utils_SetRecordOptionSortType($1);
        utils_SetRecordOptionSortLen(-1, -1, $6, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free($1);
}
    | RECTYPEVAR LENGTH '(' DIGIT ','  ',' DIGIT ')' {
        utils_SetRecordOptionSortType($1);
        utils_SetRecordOptionSortLen($4, -1, $7, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free($1);
}


;

recordclause: 
       RECORD TYPE recordoption {
    /*} allrecordoption { */
};


%%
