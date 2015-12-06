%debug
%error-verbose
%union {
	int number;
	char *string;
	struct condField_t *condField;
	struct fieldValue_t *fieldValue;
};
%code {
	#include <stdio.h>
	#include "ocsort.h"
	#include "file.h"
	#include "job.h"
	#include "sortfield.h"
	#include "condfield.h"
	#include "fieldvalue.h"
	#include "outrec.h"
	#include "utils.h"
	int yylex (void);
	void yyerror (char const *);

	struct file_t *current_file=NULL;
	int current_outrec=0;
	int current_sortField=0;
}
%token				END			0			"end of line"
%token 				USE						"USE clause"
%token 				GIVE					"GIVE clause"
%token 				SORT					"SORT clause"
%token 				MERGE					"MERGE clause"
%token 				FIELDS					"FIELDS instruction"
%token 				RECORD					"RECORD instruction"
%token 				ORG						"ORG instruction"
%token				OUTREC					"OUTREC clause"
%token				SUM						"SUM clause"
%token				INCLUDE					"INCLUDE clause"
%token				OMIT					"OMIT clause"
%token				COND					"COND clause"
%token				NONE					"NONE clause"
%token				AND					"AND clause"
%token				OR					"OR clause"
%token <number>		NUMBER					"NUMBER"
%token <string>		STRING					"STRING"
%type <number> fieldtype
%type <number> fielddirection
%type <number> fieldcondition
%type <fieldValue> fieldvalue
%type <condField> condfield
%type <condField> allcondfield
%left OR
%left AND
%%
%start beginning
;
beginning:
		| clause beginning
;
clause: useclause {}
		| giveclause {}
		| sortclause {}
		| mergeclause {}
		| omitclause {}
		| includeclause {}
		| outrecclause {}
		| sumclause {}
;
useclause: USE STRING {
	struct file_t *file=file_constructor($2);
	job_addInputFile(file);
	current_file=file;
} recordorginstruction {
	current_file=NULL;
};
giveclause: GIVE STRING {
	struct file_t *file=file_constructor($2);
	job_setOutputFile(file);
	current_file=file;
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
;

fieldtype: STRING {
	$$=utils_parseFieldType($1);
	free($1);
}
;
fielddirection: STRING {
	$$=utils_parseSortDirection($1);
	free($1);
}
;
fieldcondition: STRING {
	$$=utils_parseCondCondition($1);
	free($1);
}
;
fieldvalue: STRING  STRING  {
	$$=fieldValue_constructor($1,$2);
}
;
allsortfield: sortfield {}
			| sortfield ',' allsortfield {}
;
sortfield:  NUMBER ',' NUMBER ',' fieldtype ',' fielddirection {
			if (current_sortField==1) {
				struct sortField_t *sortField=sortField_constructor($1, $3,$5,$7);
				job_addSortField(sortField);
			}
}
;
sortclause: SORT FIELDS '(' {
			current_sortField=1;
} allsortfield ')' {
			current_sortField=0;
}
			| SORT FIELDS '=' '(' {
			current_sortField=1;
} allsortfield ')' {
			current_sortField=0;
}
;
mergeclause: MERGE {}
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

condfield: NUMBER ',' NUMBER ',' fieldtype ',' fieldcondition ',' fieldvalue  {
			$$=condField_constructor_condition($1,$3,$5,$7,$9);
}
;
omitclause: OMIT COND allcondfield  {
			job_setOmitCondField($3);
}
			| OMIT COND '=' allcondfield  {
			job_setOmitCondField($4);
}

;
includeclause: INCLUDE COND  allcondfield  {
			job_setIncludeCondField($3);
}
			| INCLUDE COND  '=' allcondfield  {
			job_setIncludeCondField($4);
}
;

alloutrec: outrec {}
		| outrec ',' alloutrec {}
;
outrec: NUMBER ',' NUMBER {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_range($1,$3);
			job_addOutrec(outrec);
		}
}
		| NUMBER ':' fieldvalue {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_change_position($1,$3);
			job_addOutrec(outrec);
		}
}
		| fieldvalue {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_change($1);
			job_addOutrec(outrec);
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
;
sumclause: SUM FIELDS '=' NONE {
			job_setSumFields();
}
;

%%
