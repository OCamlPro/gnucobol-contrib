%{
#include <io.h>  
#include "parser.h"
void yyerror(const char *error) {
	printf("Error : %s\n",error);
	if(yytext != NULL)
		printf("Error near element : %s\n", yytext);
} 
#define YY_NO_INPUT
%}

%option noyywrap nounput batch
%option case-insensitive

	/*	DIGIT		[0-9]{1,5}
		DIGITBIG	[0-9]{6,32} */

DIGIT		[0-9]{1,5}
DIGITBIG	[0-9]{6,32} 

SIGN		[+]|[-]

ORDER       [A]|[D]

		  /* original scanner for string		STRING		[a-zA-Z0-9\./]* */
	      /* version modified for : separator	STRING		[a-zA-Z0-9\.\/\\\:\_\;]*  */

STRING		[a-zA-Z0-9_.]*
SPECHR      [,;:#\[\]!£$%&()]

BLANK		[ \t]*  
LITERAL		\"{STRING}|{BLANK}\"

FIELDYPE	CH|BI|PD|ZD|FI

/*  TOKEND      END  */

/* ok \"[^\"]*\" */

/*   "'"[^']*[']{2,}"'"	{yylval.string=malloc(strlen(yytext)-1);  */

%%

"USE"		return USE;
"GIVE"		return GIVE;
"SORT"		return SORT;
"MERGE"		return MERGE;
"FIELDS"	return FIELDS;
"BUILD"		return BUILD;
"RECORD"	return RECORD;
"OUTREC"	return OUTREC;
"INREC"		return INREC;
"SUM"		return SUM;
"INCLUDE"	return INCLUDE;
"OMIT"		return OMIT;
"COND"		return COND;
"ORG"		return ORG;
"NONE"		return NONE;
"COPY"		return COPY; 
"FORMAT"    return FORMAT;
"OUTFIL"	return OUTFIL;
"FNAMES"	return FNAMES;
"FILES"		return FILES;
"STARTREC"	return STARTREC;
"ENDREC"	return ENDREC;
"SAVE"		return SAVE;
"OPTION"	return OPTION;
"SKIPREC"	return SKIPREC;
"STOPAFT"	return STOPAFT;

"END"		return TOKSKIP;
"REMOVECC"	printf("ENGSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP;
",REMOVECC"	printf("ENGSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP;
"CONVERT"	printf("ENGSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP;
",CONVERT"	printf("ENGSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP;
"EQUALS"	printf("ENGSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP; 
",EQUALS"	printf("ENGSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP; 
"NODETAIL"  printf("ENGSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP; 
",NODETAIL"  printf("ENGSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP; 


","{BLANK}"AND"{BLANK}","		return AND;
","{BLANK}"OR"{BLANK}","		return OR;

 
	/* yylval.string[0] = yytext[0]; return ORDER; */
{ORDER}				yylval.string = _strdup(yytext) ; return ORDER; 
{DIGIT}				yylval.number = atoi(yytext) ; return NUMBER;  

   /* in questo caso ritorna una stringa che poi deve essere trasformata in numero */

	
{SIGN}{DIGIT}		yylval.number = atoi(yytext) ; return NUMBER;

{DIGITBIG}			yylval.string = _strdup(yytext) ; return SIGNDIGITBIG;

{SIGN}{DIGITBIG}	yylval.string = _strdup(yytext) ; return SIGNDIGITBIG; 

		/* return a string for conversion 
			{yylval.number = atol(yytext+1) ; 
				if(yytext[0] == '-')
					yylval.number = yylval.number * -1;
				return NUMBER;
				}
		*/



			/* String C'      NFNAME=''ZZ_FIX_'   */
	/*  {  "'"*"''"*"'" */
"'"{STRING}*{SPECHR}*{STRING}*"''"{STRING}*{SPECHR}*{STRING}*"'"
			{ 
			 yylval.string=malloc(strlen(yytext)-1);
			 memcpy(yylval.string,yytext+1,strlen(yytext)-2);
			 yylval.string[strlen(yytext)-2]=0;
			 return STRING;
			 }


			/* String C''';'   */
	/*
	"'''"{STRING}*{SPECHR}*"'"	{yylval.string=malloc(strlen(yytext)-1);
				 memcpy(yylval.string,yytext+1,strlen(yytext)-2);
				 yylval.string[strlen(yytext)-2]=0;
				 return STRING;}

	*/
				/* String C'  WHERE GD_DATARIL ='''   */
				/* old "'"[^']*[']{2,}"'"	{yylval.string=malloc(strlen(yytext)-1); */
	/*
	"'"[^']*[']{2,}{STRING}*{SPECHR}*"'"	{yylval.string=malloc(strlen(yytext)-1);
				 memcpy(yylval.string,yytext+1,strlen(yytext)-2);
				 yylval.string[strlen(yytext)-2]=0;
				 return STRING;}

	*/
"'"[^']*"'"	{yylval.string=malloc(strlen(yytext)-1);
					 memcpy(yylval.string,yytext+1,strlen(yytext)-2);
					 yylval.string[strlen(yytext)-2]=0;
					 return STRING;}


{FIELDYPE}	yylval.string = _strdup(yytext) ; return FIELDTYPE;

{LITERAL}	yylval.string = _strdup(yytext) ; return LITERAL;

{STRING}	yylval.string = _strdup(yytext) ; return STRING;

{BLANK}		
.			return yytext[0];
%%
