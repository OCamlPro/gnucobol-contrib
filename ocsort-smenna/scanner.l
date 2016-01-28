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
%{
  #include <stdio.h>
  #include <stdlib.h>
  #ifndef _MSC_VER
	  #define _strdup strdup
	  #include "utils.h"
	  #define xstrtoll   strtoll
  #else
	  #include <io.h>
	  #define isatty _isatty
	  #define fileno _fileno
	  #define xstrtoll    _strtoi64
  #endif
  #include "parser.h"
  char * pEnd;
  void yyerror(const char *error) {
	printf("Error : %s\n",error);
	if(yytext != NULL)
		printf("Error near element : %s\n", yytext);
} 
#define YY_NO_INPUT
%}

%option noyywrap nounput batch
%option case-insensitive

DIGIT		[0-9]{1,5}
DIGITBIG	[0-9]{6,32}
SIGN		[+]|[-]
ORDER       [A]|[D]
STRING		[a-zA-Z0-9_.]*
SPECHR      [,;:#\[\]!£$%&()\/]
BLANK		[ \t]*  
LITERAL		["][']{STRING}|{BLANK}[']["]
XFIELDTYPE	CH|BI|PD|ZD|FI
CHARTYPE    C|X|Z


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
"REMOVECC"	printf("OCSort - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP;
",REMOVECC"	printf("OCSort - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP;
"CONVERT"	printf("OCSort - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP;
",CONVERT"	printf("OCSort - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP;
"EQUALS"	printf("OCSort - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP; 
",EQUALS"	printf("OCSort - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP; 
"NODETAIL"  printf("OCSort - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP; 
",NODETAIL"  printf("OCSort - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP; 


","{BLANK}"AND"{BLANK}","		return AND;
","{BLANK}"OR"{BLANK}","		return OR;

 
{ORDER}				yylval.string = _strdup(yytext) ;				return ORDER; 
{DIGIT}				yylval.number = strtol(yytext, &pEnd, 10) ;		return DIGIT;  
{SIGN}{DIGIT}		yylval.number = strtol(yytext, &pEnd, 10) ;		return DIGIT; 
{DIGITBIG}			yylval.llnumber = xstrtoll(yytext, &pEnd, 10) ;		return SIGNDIGITBIG;  
{SIGN}{DIGITBIG}	yylval.llnumber = xstrtoll(yytext, &pEnd, 10) ;		return SIGNDIGITBIG;  


   /* String C'      NFXA=''KK_NEW_'   */
   /*  {  "'"*"''"*"'" */
"'"{STRING}*{SPECHR}*{STRING}*"''"{STRING}*{SPECHR}*{STRING}*"'"
			{ 
			 yylval.string=malloc(strlen(yytext)-1);
			 memcpy(yylval.string,yytext+1,strlen(yytext)-2);
			 yylval.string[strlen(yytext)-2]=0;
			 return STRING;
			 }
   /* String C''';'   */
"'"[^']*"'"	{yylval.string=malloc(strlen(yytext)-1);
					 memcpy(yylval.string,yytext+1,strlen(yytext)-2);
					 yylval.string[strlen(yytext)-2]=0;
					 return STRING;}


{XFIELDTYPE}	yylval.string = _strdup(yytext) ; return XFIELDTYPE;
{CHARTYPE}		yylval.string = _strdup(yytext) ; return CHARTYPE; 
{LITERAL}		yylval.string = _strdup(yytext) ; return LITERAL;
{STRING}		yylval.string = _strdup(yytext) ; return STRING;
{BLANK}		
.			return yytext[0];
%%