%{
#include "parser.h"
void yyerror(const char *error) {
	printf("Error : %s\n",error);
}
#define YY_NO_INPUT
%}

%option noyywrap nounput batch
%option case-insensitive
DIGIT		[0-9]
STRING		[a-zA-Z0-9\./]*
BLANK		[ "\t]*
%%


"USE"		return USE;
"GIVE"		return GIVE;
"SORT"		return SORT;
"MERGE"		return MERGE;
"FIELDS"	return FIELDS;
"RECORD"	return RECORD;
"OUTREC"	return OUTREC;
"SUM"		return SUM;
"INCLUDE"	return INCLUDE;
"OMIT"		return OMIT;
"COND"		return COND;
"ORG"		return ORG;
"NONE"		return NONE;
","{BLANK}"AND"{BLANK}","		return AND;
","{BLANK}"OR"{BLANK}","		return OR;

{DIGIT}+	yylval.number = atoi(yytext) ; return NUMBER;
{STRING}	yylval.string = strdup(yytext) ; return STRING;
"'"[^']*"'"	{yylval.string=malloc(strlen(yytext)-1);
			 memcpy(yylval.string,yytext+1,strlen(yytext)-2);
			 yylval.string[strlen(yytext)-2]=0;
			 return STRING;}
{BLANK}
.			return yytext[0];
%%
