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
	int number;
	long lnumber;
	long long llnumber;
	char *string;
	char character;
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
	#include "job.h"
	#include "sortfield.h"
	#include "condfield.h"
	#include "fieldvalue.h"
	#include "outrec.h"
	#include "inrec.h"
	#include "outfil.h"
	#include "sumfield.h"
	#include "utils.h"
	int yylex (void);
	void yyerror (char const *);

	struct file_t*		current_file=NULL;
	struct outfil_t*	current_outfil=NULL;
	struct condField_t*	condField=NULL;

	int current_outrec=0;
	int current_inrec=0;
	int current_sortField=0;
	int nPosAbsRec=0;
	int nRtc=0;
	char* pszInt;

	extern int nTypeFieldsCmd;
	char szTmp[5];
	char szPath[260];
	int	 nIntTmp;
	int  nTypeFormat;			// 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields
	int  nTypeIncludeOmit;		// 0= Nothing, 1 = Include, Omit=2
	int  nstate_outfil = 0;

}
%token 				USE						"USE clause"
%token 				GIVE					"GIVE clause"
%token 				SORT					"SORT clause"
%token 				MERGE					"MERGE clause"
%token 				FIELDS					"FIELDS instruction"
%token 				BUILD					"BUILD instruction"
%token 				RECORD					"RECORD instruction"
%token 				ORG						"ORG instruction"
%token				OUTREC					"OUTREC clause"
%token				INREC					"INREC clause"
%token				SUM						"SUM clause"
%token				INCLUDE					"INCLUDE clause"
%token				OMIT					"OMIT clause"
%token				COND					"COND clause"
%token				NONE					"NONE clause"
%token				AND						"AND clause"
%token				OR						"OR clause"
%token				FORMAT					"FORMAT clause"
%token				OUTFIL					"OUTFIL clause"
%token				FNAMES					"FNAMES clause"
%token				FILES					"FILES  clause"
%token				STARTREC				"STARTREC clause"
%token				ENDREC					"ENDREC clause"
%token				SAVE					"SAVE clause"
%token				OPTION					"OPTION clause"
%token				SKIPREC					"SKIP clause"
%token				STOPAFT					"STOPAFT clause"
%token <string>		TOKSKIP					"TOKSKIP clause"
%token <string>		STRING					"STRING"
%token <string>		XFIELDTYPE				"XFIELDTYPE"
%token <string>		CHARTYPE				"CHARTYPE" 
%token <number>		DIGIT					"DIGIT"
%token <string>		ORDER					"ORDER"
%token 				COPY					"COPY"
%token <string>		LITERAL					"LITERAL"
%token <llnumber>	SIGNDIGITBIG			"SIGNDIGITBIG"
%type <number>		fieldtype
%type <number>		fielddirection
%type <number>		fieldcondition
%type <fieldValue>	fieldvalue
%type <condField>	condfield
%type <condField>	allcondfield
%type <SumField>	sumfield
%type <SumField>	allsumfield
%type <fieldValue>	fieldvalueconst
%left OR
%left AND
%%
%start beginning
;
beginning:
		| clause beginning
;
clause: useclause {}
		| formatclause {}
		| giveclause {}
		| sortclause {}
		| mergeclause {}
		| omitclause {}
		| includeclause {}
		| outrecclause {}
		| inrecclause {}
		| sumclause {}
		| tokskipclause {}
		| outfilclause {}
		| fnamesclause {}
		| filesclause {}
		| outfilincludeclause {}
		| outfilomitclause {}
		| startrecclause {}
		| endrecclause {}
		| saveclause {}
		| optionclause {}
//		| copyclause {}
;

useclause: 
	USE STRING { 
	struct file_t *file=file_constructor($2);
	file_setInputFile(file);
	current_file=file;
	free($2);
} recordorginstruction {
	current_file=NULL;
}
;
giveclause: GIVE STRING {
	struct file_t *file=file_constructor($2);
	file_setOutputFile(file);
	current_file=file;
	free($2);
} recordorginstruction {
	current_file=NULL;
};

recordorginstruction: {}
				| ORG STRING recordorginstruction {
	if (current_file!=NULL) {
		nRtc = file_setOrganization(current_file,utils_parseFileOrganization($2));
		if (nRtc == -1)
			exit(OC_RTC_ERROR);
	}
	free($2);
}
				| ORG '(' STRING ')' recordorginstruction {
	if (current_file!=NULL) {
		file_setOrganization(current_file,utils_parseFileOrganization($3));
	}
	free($3);
}
				| RECORD STRING ',' DIGIT ',' DIGIT recordorginstruction {
	if (current_file!=NULL) {
		file_setFormat(current_file,utils_parseFileFormat($2));
		file_setRecordLength(current_file,$4);
		file_setMaxLength(current_file,$6);
	}
	free($2);
}
				| RECORD STRING ',' DIGIT recordorginstruction {
	if (current_file!=NULL) {
		file_setFormat(current_file,utils_parseFileFormat($2));
		file_setRecordLength(current_file,$4);
		file_setMaxLength(current_file,$4);
	}
	free($2);
}
				| RECORD '(' STRING ',' DIGIT ',' DIGIT ')' recordorginstruction {
	if (current_file!=NULL) {
		file_setFormat(current_file,utils_parseFileFormat($3));
		file_setRecordLength(current_file,$5);
		file_setMaxLength(current_file,$7);
	}
	free($3);
}
				| RECORD '(' STRING ',' DIGIT ')' recordorginstruction {
	if (current_file!=NULL) {
		file_setFormat(current_file,utils_parseFileFormat($3));
		file_setRecordLength(current_file,$5);
		file_setMaxLength(current_file,$5);
	}
	free($3);
}
;

fieldtype: XFIELDTYPE {
		$$=utils_parseFieldType($1);
		free($1);
}
;
fielddirection: ORDER {
		$$=utils_parseSortDirection($1);
		free($1); 
}
;

fieldcondition: STRING {
		$$=utils_parseCondCondition($1);
		free($1);
}
;
fieldvalue: CHARTYPE  STRING  {
		$$=fieldValue_constructor((char*) $1, $2, TYPE_STRUCT_STD);
		free($1); 
		free($2); 
}		
		| DIGIT STRING {
		// char* pszInt;
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%d", $1);
		//-->>ok $$=fieldValue_constr_newF((char*)$1, (char*)$2, TYPE_STRUCT_STD);
		$$=fieldValue_constr_newF((char*)pszInt, (char*)$2, TYPE_STRUCT_STD);
		free($2); 
		(pszInt); 
}			// 80X
	// new
		| DIGIT CHARTYPE {
		// char* pszInt;
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%d", $1);
		// ok ok $$=fieldValue_constr_newF((char*)$1, (char*)$2, TYPE_STRUCT_STD);
		$$=fieldValue_constr_newF((char*)pszInt, (char*)$2, TYPE_STRUCT_STD);
		free($2); 
		free(pszInt); 
}			// 80:X
		| STRING STRING {
//-->>		$$=fieldValue_constr_newF($1, $2, TYPE_STRUCT_STD);
		$$=fieldValue_constructor($1, $2, TYPE_STRUCT_STD);
		free($1); 
		free($2); 
		// free(pszInt); 
}
	
;

fieldvalueconst:  DIGIT {
		//char* pszInt;
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%d", $1);
		$$=(struct fieldValue_t *) fieldValue_constructor((char*)"Z",pszInt, TYPE_STRUCT_STD);
		free(pszInt); 
}
		| SIGNDIGITBIG  {
		char szType[] = "Z";
		//char* pszInt;
		pszInt = (char*) malloc(32);		 
		#ifdef	_MSC_VER
			sprintf(pszInt, "%I64ld", $1);
		#else
			sprintf(pszInt, "%lld", $1);
		#endif
		$$=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_STD);
		free(pszInt); 
}
;

allsortfield: sortfield {}
			| sortfield ',' allsortfield {}
;

sortfield:	DIGIT ',' DIGIT ',' fielddirection {
			if (current_sortField==1) {
				struct sortField_t *sortField;
				sortField=sortField_constructor($1,$3,0, $5);
				sortField_addDefinition(sortField);
				nTypeFormat = 1;
			}
		}
		|  DIGIT ',' DIGIT ',' fieldtype ',' fielddirection {
			if (current_sortField==1) {
				struct sortField_t *sortField;
				sortField=sortField_constructor($1,$3,$5,$7);
				sortField_addDefinition(sortField);
				//-->> nTypeFormat = 1; // Format external token
			}
		}
		|	STRING {
			// typeOP = 'M'; // for Merge
			job_SetTypeOP('M');
			job_SetFieldCopy(1);

			free($1); //201512
		}
;

sortclause: SORT FIELDS '(' {
			current_sortField=1;
} allsortfield ')' {
			current_sortField=0;
			job_SetTypeOP('S');		// for Sort
}
			| SORT FIELDS '=' '(' {
			current_sortField=1;
} allsortfield ')' {
			current_sortField=0;
			job_SetTypeOP('S');
}
			| SORT FIELDS '=' COPY {
			job_SetTypeOP('M');		// for Merge
			job_SetFieldCopy(1);
}
			| SORT FIELDS '=' '(' COPY ')' {
			job_SetTypeOP('M');
			job_SetFieldCopy(1);
}
;

mergeclause: MERGE FIELDS '(' {
			current_sortField=1;
} allsortfield ')' {
			current_sortField=0;
			// typeOP = 'M'; // for Merge
			job_SetTypeOP('M');

}
			| MERGE FIELDS '=' '(' {
			current_sortField=1;
} allsortfield ')' {
			current_sortField=0;
			job_SetTypeOP('M');
}
			| MERGE FIELDS '=' '(' COPY ')' {
			job_SetTypeOP('M');
			job_SetFieldCopy(1);
}
			| MERGE FIELDS '=' COPY {
			job_SetTypeOP('M');
			job_SetFieldCopy(1);
}

;

allcondfield: condfield {
		$$=$1;
}
		| '(' allcondfield ')' {
		$$=$2;
}
        | allcondfield AND allcondfield {
		condField=condField_constructor_operation(COND_OPERATION_AND, $1, $3);
		$$=condField;
}
        | allcondfield OR allcondfield {
		condField=condField_constructor_operation(COND_OPERATION_OR, $1, $3);
		$$=condField;
}
;

formatclause: FORMAT '=' fieldtype {
//-->>nTypeFormat;			// 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields
//-->>nTypeIncludeOmit;		// 0= Nothing, 1 = Include, 2 = Omit

		if (nTypeFormat == 1)
			condField_setFormatFieldsTypeAll(nTypeFormat, $3);
		if (nTypeFormat == 2)
			condField_setCondFieldsTypeAll(nTypeIncludeOmit, $3);
		if (nTypeFormat == 3)	// for SumFields
			condField_setFormatFieldsTypeAll(nTypeFormat, $3);
}
		|  ',' FORMAT '=' fieldtype {
			if (nTypeFormat == 1)
				condField_setFormatFieldsTypeAll(nTypeFormat, $4);
			if (nTypeFormat == 2)
				condField_setCondFieldsTypeAll(nTypeIncludeOmit, $4);
			if (nTypeFormat == 3)	// for SumFields
				condField_setFormatFieldsTypeAll(nTypeFormat, $4);

}
;
	// ----------------------------------------------------------------------------------------------//
	// -->> OMIT   COND=(01,12,CH,EQ,C'000000003030')
	// -->> OMIT   COND=(01,12,EQ,C'000000003030'),FORMAT=CH
	// ----------------------------------------------------------------------------------------------//
	// (01,12,CH,EQ,C'000000003030')
	// (01,03,CH,EQ,C'110',AND,24,04,CH,GT,C'0000',AND,24,04,CH,LE,C'9999')
	// ----------------------------------------------------------------------------------------------//
condfield: 	DIGIT ',' DIGIT ',' fieldtype ',' fieldcondition ',' fieldvalue  {    
			$$=condField_constructor_condition($1,$3,$5,$7,$9);

}
			| DIGIT ',' DIGIT ',' fieldtype ',' fieldcondition ',' fieldvalueconst {
			$$=condField_constructor_condition($1,$3,$5,$7,$9);
}
		//(45,17,LE,00999999999999999),FORMAT=ZD
		//(45,17,GT,C'00999999999999999'),FORMAT=CH
		//(45,17,LE,999999),FORMAT=ZD
   		|   DIGIT ',' DIGIT ',' fieldcondition ',' fieldvalueconst  {    
			condField=condField_constructor_condition($1,$3,0,$5,(struct fieldValue_t *)$7);
			nTypeFormat = 2; // Format external token
			$$=condField;
}
   		|   DIGIT ',' DIGIT ',' fieldcondition ',' fieldvalue  {    
			condField=condField_constructor_condition($1,$3,0,$5,(struct fieldValue_t *)$7);
			nTypeFormat = 2; // Format external token
			$$=condField;
}
		// ----------------------------------------------------------------------------------------------//
		//(156,15,CH,LT,141,15,CH)
		// ----------------------------------------------------------------------------------------------//
		|	DIGIT ',' DIGIT ',' fieldtype ',' fieldcondition ',' DIGIT ',' DIGIT ',' fieldtype {
			nTypeFormat = 2; // Format external token
			condField=condField_constructor_conditionfield($1,$3,$5,$7,$9,$11,$13);
			$$=condField;
}
;

omitclause: OMIT COND allcondfield  {
			condField_addOmit($3);
			nTypeIncludeOmit = 2;
}
			| OMIT COND '=' allcondfield  {
			condField_addOmit($4);
			nTypeIncludeOmit = 2;
}
;

includeclause: INCLUDE COND  allcondfield  {
			condField_addInclude($3);
			nTypeIncludeOmit = 1;
}
			| INCLUDE COND  '=' allcondfield  {
			condField_addInclude($4);
			nTypeIncludeOmit = 1;
}
;

alloutrec: outrec {	nPosAbsRec = -1;}
		| outrec ',' alloutrec {	nPosAbsRec = -1;}
;
outrec: DIGIT ',' DIGIT {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_range($1,$3);
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
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += outrec->range.length;
		}

}
		// case 20:10,5  (from position 20 output, move field position 10 for len 5 from input)
		| DIGIT ':' DIGIT ',' DIGIT {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_range_position($1, $3, $5);
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec = outrec->range_position.posAbsRec + outrec->range_position.length;
		}
}
	
			| STRING {    
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_subst($1);
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
		}
		free($1);
}
		| DIGIT ':' CHARTYPE {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_padding($1, $3, nPosAbsRec);
			if ($1 > nPosAbsRec) 
				nPosAbsRec = $1;
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
		}
		free($3); 
}
	// new single CHAR XZC
		| CHARTYPE {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_subst($1);
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
		}
}			
		
		| fieldvalue {
		// | DIGIT CHARTYPE  {
		if (current_outrec==1) {
			struct outrec_t *outrec;
			outrec=outrec_constructor_change($1);
			nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
		}
	}
	
// condizione di posizione di partenza senza lunghezza per i file variabili
		| DIGIT ',' {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_range($1,-1);
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
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += outrec->range.length;
		}
}
;
outrecclause: OUTREC FIELDS '=' '(' {
			current_outrec=1;
} alloutrec ')' {
			current_outrec=0;
}
			| OUTREC FIELDS '(' {
			current_outrec=1;
} alloutrec ')' {
			current_outrec=0;
}
			| OUTREC BUILD '=' '(' {
			current_outrec=1;
} alloutrec ')' {
			current_outrec=0;
}
			| OUTREC BUILD '(' {
			current_outrec=1;
} alloutrec ')' {
			current_outrec=0;
}
;
// inrec
allinrec: inrec {	nPosAbsRec = -1;}
		| inrec ',' allinrec {	nPosAbsRec = -1; }
;

inrec: DIGIT ',' DIGIT {
		if (current_inrec==1) {
				struct inrec_t *inrec=inrec_constructor_range($1,$3);
				nPosAbsRec += inrec->range.length;
				inrec_addDefinition(inrec);
		}
}
		| DIGIT ':' fieldvalue {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_change_position($1,$3);
			nPosAbsRec += inrec->change_position.fieldValue->generated_length;
			inrec_addDefinition(inrec);
		}
}
		// case 80:X
		| DIGIT ':' CHARTYPE {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_padding($1, $3, nPosAbsRec);
			if ($1 > nPosAbsRec) 
				nPosAbsRec = $1;		// - inrec->change_position.fieldValue->generated_length;
			inrec_addDefinition(inrec);
		}

		free($3); 
}
		// case 20:10,5  (from position 20 output, move field position 10 for len 5 from input)
		| DIGIT ':' DIGIT ',' DIGIT {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_range_position($1, $3, $5);
			nPosAbsRec = inrec->range_position.posAbsRec + inrec->range_position.length;
			inrec_addDefinition(inrec);
		}
}
		| STRING {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_subst($1);
			inrec_addDefinition(inrec);
			nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
		}
		free($1); 

}
	// new single CHAR XZC
		| CHARTYPE {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_subst($1);
			inrec_addDefinition(inrec);
			nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
		}
		free($1);
}			

		| fieldvalue {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_change($1);
			inrec_addDefinition(inrec);
			nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
		}
}
;

inrecclause: INREC FIELDS '=' '(' {
			current_inrec=1;
} allinrec ')' {
			current_inrec=0;
}
			| INREC FIELDS '(' {
			current_inrec=1;
} allinrec ')' {
			current_inrec=0;
}
			| INREC BUILD '=' '(' {
			current_inrec=1;
} allinrec ')' {
			current_inrec=0;
}
			| INREC BUILD '(' {
			current_inrec=1;
} allinrec ')' {
			current_inrec=0;
}
;

// inrec
// OUTFIL

allsumfield: sumfield {}
		| sumfield ',' allsumfield {}
;
sumfield: '(' DIGIT ',' DIGIT   { 
			struct SumField_t *SumField=SumField_constructor($2, $4, 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
		| ',' DIGIT ',' DIGIT  {
			struct SumField_t *SumField=SumField_constructor($2, $4, 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
		| DIGIT ',' DIGIT ',' DIGIT ',' DIGIT    {
			struct SumField_t *SumField1=SumField_constructor($1, $3, 0);
			struct SumField_t *SumField2=SumField_constructor($5, $7, 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField1); 
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField2); 
}
		| ',' DIGIT ',' DIGIT ')'  {
			struct SumField_t *SumField=SumField_constructor($2, $4, 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
		|   DIGIT ',' DIGIT   {
			struct SumField_t *SumField=SumField_constructor($1, $3, 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
		| DIGIT ',' DIGIT ',' fieldtype  {
 			struct SumField_t *SumField=SumField_constructor($1, $3, $5);
 			SumField_addDefinition(SumField); 
}
;   
sumclause: SUM FIELDS '=' NONE {
			SumField_setFunction(1);
}
		 | SUM FIELDS '=' '(' NONE ')' {
			SumField_setFunction(1);
}         
         | SUM FIELDS '=' '(' allsumfield ')'{
			SumField_setFunction(2);
}
;

/* ============================================== */

tokskipclause: TOKSKIP {
		//printf("ENGSORT: Warning Token skipped : %s\n",yylval.string);
}
;

fnamesclause: FNAMES '=' STRING {

	struct file_t *file=file_constructor($3);
	outfil_setOutfilFiles(current_outfil, file);
	free($3);
}
			| ',' FNAMES '=' STRING {
	struct file_t *file=file_constructor($4);
	outfil_setOutfilFiles(current_outfil, file);
	free($4);
}
;

filesclause: FILES '=' STRING {
	struct file_t *file=file_constructor($3);
	outfil_setOutfilFiles(current_outfil, file);
	free($3);
}
			| ',' FILES '=' STRING {
	struct file_t *file=file_constructor($4);
	outfil_setOutfilFiles(current_outfil, file);
	free($4);
}
;

outfilincludeclause: INCLUDE '=' allcondfield  {
			if (current_outfil != NULL)
				setOutfilIncludeCondField(current_outfil, $3);
			nTypeIncludeOmit = 1;
}
;


outfilomitclause: OMIT '=' allcondfield  {
			if (current_outfil != NULL)
				setOutfilOmitCondField(current_outfil, $3);
			nTypeIncludeOmit = 1;
}
;

outrecclause: OUTREC '=' '(' {
			current_outrec=1;
} alloutrec ')' {
			current_outrec=0;
}
		| OUTREC '(' {
		current_outrec=1;
} alloutrec ')' {
			current_outrec=0;
}


outfilclause: OUTFIL {
		struct outfil_t *outfil=outfil_constructor();
		if (current_outfil == NULL)
			outfil_addDefinition(outfil); 
		else 
			outfil_addDefinition(outfil); 
		current_outfil=outfil; 
		nstate_outfil=1;
}
;

startrecclause: STARTREC '=' SIGNDIGITBIG {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, $3);
}
;

endrecclause: ENDREC '=' SIGNDIGITBIG {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, $3);
}
;

saveclause: SAVE {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
}
		| SAVE ',' {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
}
		| ',' SAVE {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
}
;


alloption: option {}
		| option ',' alloption {}
		| option  alloption {}
;
option: STRING {
	utils_SetOptionSort($1);
	free($1);
}
        | COPY {
	utils_SetOptionSort("COPY");
}
		| SKIPREC '=' SIGNDIGITBIG {
	utils_SetOptionSortNum("SKIPREC", $3);
}
		| SKIPREC '=' DIGIT {
	utils_SetOptionSortNum("SKIPREC", $3);
}
		| STOPAFT '=' SIGNDIGITBIG {
	utils_SetOptionSortNum("STOPAFT", $3);
}
		| STOPAFT '=' DIGIT {
	utils_SetOptionSortNum("STOPAFT", $3);
}
;

optionclause: OPTION {
} alloption {
};



%%
