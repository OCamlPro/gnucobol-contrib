%debug 
%error-verbose
%union { 
	int number;
	int number64;
	char *string;
	char character;
	struct condField_t *condField;
	struct fieldValue_t *fieldValue;
	struct SumField_t *SumField;
};
%code {
	#include <stdio.h>
	#include <string.h>
	#include <io.h>
	#include "ocsort.h"
	#include "file.h"
	#include "job.h"
	#include "sortfield.h"
	#include "condfield.h"
	#include "fieldvalue.h"
	#include "outrec.h"
	#include "inrec.h"
	#include "outfil.h"
	#include "SumField.h"
	#include "utils.h"
	int yylex (void);
	void yyerror (char const *);

	struct file_t *current_file=NULL;
	struct outfil_t *current_outfil=NULL;

	int current_outrec=0;
	int current_inrec=0;
	int current_sortField=0;
	int nPosAbsRec=-1;

	extern int nTypeFieldsCmd;
	char szTmp[5];
	char szPath[260];
	int	 nIntTmp;
	int  nTypeFormat;			// 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields
	int  nTypeIncludeOmit;		// 0= Nothing, 1 = Include, Omit=2
	int  nstate_outfil = 0;

}
//%token				END			0			"end of line"
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
%token <number>		NUMBER					"NUMBER"
%token <string>		STRING					"STRING"
%token <string>		FIELDTYPE				"FIELDTYPE"
// %token <character>	ORDER					"ORDER"
%token <string>		ORDER					"ORDER"
%token 				COPY					"COPY"
%token <string>		LITERAL					"LITERAL"
%token <string>		SIGNDIGITBIG			"SIGNDIGITBIG"
%type <number>		fieldtype
%type <number>		fielddirection
%type <number>		fieldcondition
%type <fieldValue>	fieldvalue
%type <condField>	condfield
%type <condField>	allcondfield
%type <SumField>	sumfield
%type <SumField>	allsumfield
%type <string>	signdigitvalue 
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
		file_setOrganization(current_file,utils_parseFileOrganization($2));
	}
	free($2);
}
				| ORG '(' STRING ')' recordorginstruction {
	if (current_file!=NULL) {
		file_setOrganization(current_file,utils_parseFileOrganization($3));
	}
	free($3);
}

				| RECORD STRING ',' NUMBER ',' NUMBER recordorginstruction {
	if (current_file!=NULL) {
		file_setFormat(current_file,utils_parseFileFormat($2));
		file_setRecordLength(current_file,$4);
		file_setMaxLength(current_file,$6);
	}
	free($2);
}
				| RECORD STRING ',' NUMBER recordorginstruction {
	if (current_file!=NULL) {
		file_setFormat(current_file,utils_parseFileFormat($2));
		file_setRecordLength(current_file,$4);
		file_setMaxLength(current_file,$4);
	}
	free($2);
}
				| RECORD '(' STRING ',' NUMBER ',' NUMBER ')' recordorginstruction {
	if (current_file!=NULL) {
		file_setFormat(current_file,utils_parseFileFormat($3));
		file_setRecordLength(current_file,$5);
		file_setMaxLength(current_file,$7);
	}
	free($3);
}
				| RECORD '(' STRING ',' NUMBER ')' recordorginstruction {
	if (current_file!=NULL) {
		file_setFormat(current_file,utils_parseFileFormat($3));
		file_setRecordLength(current_file,$5);
		file_setMaxLength(current_file,$5);
	}
	free($3);
}
;

// fieldtype: STRING {
fieldtype: FIELDTYPE {
	$$=utils_parseFieldType($1);
	free($1);
}
;
fielddirection: ORDER {
	$$=utils_parseSortDirection($1);
}
;

fieldcondition: STRING {
	$$=utils_parseCondCondition($1);
	free($1);
}
;
fieldvalue: STRING  STRING  {
	$$=fieldValue_constructor($1,$2, TYPE_STRUCT_STD);
	free($1);
}		
		| NUMBER STRING {
	$$=fieldValue_constructor2((char*)$1,$2, TYPE_STRUCT_STD);
}		
;

signdigitvalue: SIGNDIGITBIG  {
		char szType[] = "Z";
		$$=(char *)fieldValue_constructor(szType,$1, TYPE_STRUCT_NEW);		// flag 3° for value
}
;

allsortfield: sortfield {}
			| sortfield ',' allsortfield {}
;
//-->>	OK	sortfield:  NUMBER ',' NUMBER ',' fieldtype ',' fielddirection {
sortfield:	NUMBER ',' NUMBER ',' fielddirection {
			if (current_sortField==1) {
				struct sortField_t *sortField;
				sortField=sortField_constructor($1,$3,0, $5);
				sortField_addDefinition(sortField);
				nTypeFormat = 1;
			}
		}
		|  NUMBER ',' NUMBER ',' fieldtype ',' fielddirection {
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
		$$=condField_constructor_operation(COND_OPERATION_AND, $1, $3);
}
            | allcondfield OR allcondfield {
		$$=condField_constructor_operation(COND_OPERATION_OR, $1, $3);
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
|
			 ',' FORMAT '=' fieldtype {
			if (nTypeFormat == 1)
				condField_setFormatFieldsTypeAll(nTypeFormat, $4);
			if (nTypeFormat == 2)
				condField_setCondFieldsTypeAll(nTypeIncludeOmit, $4);
			if (nTypeFormat == 3)	// for SumFields
				condField_setFormatFieldsTypeAll(nTypeFormat, $4);

}

;

// -->> OMIT   COND=(01,12,CH,EQ,C'000000003030')
// -->> OMIT   COND=(01,12,EQ,C'000000003030'),FORMAT=CH

condfield: 	NUMBER ',' NUMBER ',' fieldtype ',' fieldcondition ',' fieldvalue  {
			$$=condField_constructor_condition($1,$3,$5,$7,$9);
}
										/* 00999999999999999 */
   		|   NUMBER ',' NUMBER ',' fieldtype ',' fieldcondition ',' NUMBER  {    
			struct fieldValue_t *fieldValue_temp;
			char szType[] = "Z";
			char* pszInt;
			pszInt = (char*) malloc(32);		// 
			// itoa($9, pszInt, 10);
			sprintf(pszInt, "%ld", $9);
			fieldValue_temp=fieldValue_constructor(szType, pszInt, TYPE_STRUCT_NEW);		// flag 3° for value
			$$=condField_constructor_condition($1,$3,$5,$7,fieldValue_temp);
}
										/* -0999999999999999  */
   		|   NUMBER ',' NUMBER ',' fieldtype ',' fieldcondition ',' signdigitvalue  {    
			$$=condField_constructor_condition($1,$3,$5,$7,(struct fieldValue_t *)$9);
}

		|	NUMBER ',' NUMBER ',' STRING ',' fieldcondition ',' fieldvalue {
			$$=condField_constructor_condition($1,$3,utils_parseFieldType($5),$7,$9);
			//-->> nTypeFormat = 2; // Format external token
}
		|   NUMBER ',' NUMBER ',' STRING ',' fieldcondition ',' NUMBER  {
			$$=condField_constructor_condition($1,$3,(int)$5,$7,(struct fieldValue_t *)$9);
}
		|	NUMBER ',' NUMBER ',' STRING ',' fieldvalue {
			$$=condField_constructor_condition($1,$3,0, utils_parseCondCondition($5),$7);
			nTypeFormat = 2; // Format external token
}

		|	NUMBER ',' NUMBER ',' fieldtype ',' fieldcondition ',' NUMBER ',' NUMBER ',' fieldtype {
			$$=condField_constructor_conditionfield($1,$3,$5,$7,$9,$11,$13);
			nTypeFormat = 2; // Format external token
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
outrec: NUMBER ',' NUMBER {
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
		| NUMBER ':' fieldvalue {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_change_position($1,$3);
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += outrec->change_position.fieldValue->generated_length;
		}
}
		// case 80:X
		| NUMBER ':' STRING {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_padding($1, $3, nPosAbsRec);
			if ($1 > nPosAbsRec) 
				nPosAbsRec = $1;		// 
			outrec_addDefinition(outrec);
		}
}
		// case 20:10,5  (from position 20 output, move field position 10 for len 5 from input)
		| NUMBER ':' NUMBER ',' NUMBER {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_range_position($1, $3, $5);
			nPosAbsRec = outrec->range_position.posAbsRec + outrec->range_position.length;
			outrec_addDefinition(outrec);
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
		// new		
		free($1);
		// new
}
		| fieldvalue {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_change($1);
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
		}
}
// condizione di posizione di partenza senza lunghezza per i file variabili
		| NUMBER ',' {
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
inrec: NUMBER ',' NUMBER {
		if (current_inrec==1) {
				struct inrec_t *inrec=inrec_constructor_range($1,$3);
				nPosAbsRec += inrec->range.length;
				inrec_addDefinition(inrec);
		}
}
		| NUMBER ':' fieldvalue {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_change_position($1,$3);
			nPosAbsRec += inrec->change_position.fieldValue->generated_length;
			inrec_addDefinition(inrec);
		}
}
		// case 80:X
		| NUMBER ':' STRING {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_padding($1, $3, nPosAbsRec);
			if ($1 > nPosAbsRec) 
				nPosAbsRec = $1;		// - inrec->change_position.fieldValue->generated_length;
			inrec_addDefinition(inrec);
		}
}
		// case 20:10,5  (from position 20 output, move field position 10 for len 5 from input)
		| NUMBER ':' NUMBER ',' NUMBER {
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
sumfield: '(' NUMBER ',' NUMBER   { 
			struct SumField_t *SumField=SumField_constructor($2, $4, 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
		| ',' NUMBER ',' NUMBER  {
			struct SumField_t *SumField=SumField_constructor($2, $4, 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
		| NUMBER ',' NUMBER ',' NUMBER ',' NUMBER    {
			struct SumField_t *SumField1=SumField_constructor($1, $3, 0);
			struct SumField_t *SumField2=SumField_constructor($5, $7, 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField1); 
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField2); 
}
		| ',' NUMBER ',' NUMBER ')'  {
			struct SumField_t *SumField=SumField_constructor($2, $4, 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
		|   NUMBER ',' NUMBER   {
			struct SumField_t *SumField=SumField_constructor($1, $3, 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
		| NUMBER ',' NUMBER ',' fieldtype  {
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

startrecclause: STARTREC '=' NUMBER {
			if (current_outfil != NULL)
				outfil_SetStartRec(current_outfil, $3);
}
;

endrecclause: ENDREC '=' NUMBER {
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
	job_SetOptionSort($1);
}
        | COPY {
	job_SetOptionSort("COPY");
}
        | SKIPREC '=' NUMBER {
	job_SetOptionSortNum("SKIPREC", $3);
}
        | STOPAFT '=' NUMBER {
	job_SetOptionSortNum("STOPAFT", $3);
}
;

optionclause: OPTION {
} alloption {
};



%%
