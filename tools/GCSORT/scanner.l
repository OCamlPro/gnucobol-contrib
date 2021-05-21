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
  #include "gcsort.h"
  #include "parser.h"
  char * pEnd;
  int    nPhase = 0;
  extern char szMexToken[260];

  void yyerror(const char *error) {
	printf("Error : %s\n",error);
	if(yytext != NULL) {
		printf("Error near element : %s\n", yytext);
		printf("Token  : %s\n", szMexToken);
	}
} 
#define YY_NO_INPUT
%}


%option noyywrap nounput batch
%option case-insensitive

			/* for position and length */
DIGIT		    [0-9]{1,5}
			/* for value, example condition */
DIGITBIG	    [0-9]{6,32}                        
			/* sign for numeric values */
SIGN		    [+]|[-]                            
			/* string */
STRING		    [a-zA-Z0-9_.]*                     

BLANK		    [ \t]*  

            /* File type */
FILETYPE	    LS|SQ|IX|RL

            /*  Format Type Field   */
         /* CH|BI|FI|FL|PD|ZD|TI|OT|CTO|LI|OL|CLO|CST|LS|CSL */
            /*  CH  Char            
                BI  Unsigned Binary
                FI  Signed Binary
                Fl  Floating Point
                PD  Packed
TI / OT / CTO / ZD  Zoned decimal  - sign trailing
      LI / OL / CLO Signed Numeric - sign lealing 
                CST Signed Numeric - trailing separate sign
           LS / CSL Signed Numeric - leading separate sign
           FS / CSF Signed Numeric - with optional leading floating sign  (PIC +++9, PIC ----,...)
            */
    /* FORMATTYPE	 CH|BI|FI|FL|PD|ZD|CLO|CST|CSL */
	/* extended FORMATTYPE	 CH|BI|FI|FL|PD|ZD|TI|OT|CTO|LI|OL|CLO|CST|LS|CSL */

    /* released FORMATTYPE	 CH|BI|FI|FL|PD|ZD|CLO|CST|CSL */
FORMATTYPE	 CH|BI|FI|FL|PD|ZD|CLO|CST|CSL|Y2T|Y2B|Y2C|Y2D|Y2P|Y2S|Y2U|Y2V|Y2X|Y2Y|Y2Z
    /*
  DataType	Len	Type
    Y2T		8	ZD Y2T8 = Y4T8 (?) C'ccyymmdd' or Z'ccyymmdd'     
    Y2T		4	ZD Y2T4 : C'yyxx' or Z'yyxx' 
    Y2T		2	ZD Y2T2 'yy'
    Y2T		3	ZD Y2T2 'yyx'
    Y2T		5	ZD 5,Y2T: C'yyddd' or Z'yyddd'
    Y2T		6	ZD 6,Y2T: C'yymmdd' or Z'yymmdd'     
    Y4T		7	ZD 7,Y4T: C'ccyyddd' or Z'ccyyddd'    
    Y2B		1	BI
    Y2C		2	ZD
    Y2D		1	PD
    Y2P		2	PD
    Y2S		2	ZD
    Y2U		3	PD  P'yyddd'   
    Y2V		4	PD  P'yymmdd'    
    Y2X		3	PD  P'dddyy'    
    Y2Y		4	PD  P'mmddyy'
    Y2Z		2	ZD
    */
    
            /*  Char Type  for condition CharType = C(char) | X(hexdical) <String>    */
   /* prec CHARTCOND       C|X  */
CHARTCOND       C|X|Y
            /*  Char Type  CharType = C(char) | X(hexdical) |Z(zero binary) <String>    */
CHARTYPE        C|X|Z				
            /*  Order A = Ascending, D = Descending */
ORDER           A|D				
            /*  Key Tye for indexed file P=Primary, A= ALternative, AD = Alternative with duuplicates, C = Continue */
KEYTYPE         P|A|AD|C	
            /* Fixed record */
RECTYPEFIX	    F
            /* Variable record */
RECTYPEVAR      V
            /* comment for occursfill */ 
            /* ntimes X,Z,C */
OCCURFILL   [0-9]{1,5}[C|X|Z]{1} 
            /* Operator condition */ 
OPCOND          EQ|GT|GE|LT|LE|NE|SS

    /* OCCURFILL   [0-9]{1,5}[C|X|Z]{1} */
	/* <CHSC>{CHARTYPE} */
	/* <ORDK>{ORDER} */
	/* <KEYV>{KEYTYPE} */
    
EXROUT          E15|E35

%s KEYV
%s ORDK
%s CHSC
%s TCOND
%s TORG

%%

"BUILD"[=]*{BLANK}                              return BUILD;
"COND"                          BEGIN(TCOND);   return COND; 
[(]{BLANK}"COPY"{BLANK}[)]                      return COPY; 
"COPY"                                          return COPY; 
"END"		                                    return TOKSKIP;
[,]*{BLANK}"ENDREC"	                            return ENDREC;
"FIELDS"{BLANK}[=]{BLANK}   if (nPhase == 1) { 
                                BEGIN(ORDK);  
                                nPhase = 0; 
                            }else {	
                                BEGIN(CHSC); 
                            } return FIELDS; 
"FIELDS"                    if (nPhase == 1) { 
                                BEGIN(ORDK);  
                                nPhase = 0; 
                            }else {	
                                BEGIN(CHSC); 
                           } return FIELDS; 

                                                      
"OVERLAY"{BLANK}[=]{BLANK}   if (nPhase == 1) {       
                                BEGIN(ORDK);          
                                nPhase = 0;           
                            }else {	                  
                                BEGIN(CHSC);          
                            } return OVERLAY;         
"OVERLAY"                    if (nPhase == 1) {       
                                BEGIN(ORDK);          
                                nPhase = 0;           
                            }else {	                  
                                BEGIN(CHSC);          
                           } return OVERLAY;          
                                                      
[,]*{BLANK}"FILES"{BLANK}[,]*                   return FNAMES; //return FILES;
[,]*{BLANK}"FNAMES"{BLANK}[,]*	                return FNAMES;
[,]*{BLANK}"FORMAT"{BLANK}[,]*                  return FORMAT;
"GIVE"		                    BEGIN(INITIAL); return GIVE;
[,]*{BLANK}"INCLUDE"            BEGIN(TCOND);   return INCLUDE; 
"INREC"		                    BEGIN(CHSC);    return INREC;		
"OUTREC"		                BEGIN(CHSC);    return OUTREC;		
"KEY"	                        BEGIN(KEYV);    return KEY;
"MERGE"		       nPhase = 1;  BEGIN(INITIAL); return MERGE;
[(]*{BLANK}"NONE"{BLANK}[)]*	                return NONE;
[,]*{BLANK}"OMIT"		        BEGIN(TCOND);   return OMIT; 
"OPTION"	                                    return OPTION;
    /*"ORG"		                                    return ORG;*/
"ORG"		                    BEGIN(TORG);                return ORG;
"OUTFIL"	                                    return OUTFIL;
"OUTFILE"                                       return OUTFIL;
[,]*{BLANK}"OUTREC"	            BEGIN(CHSC);    return OUTREC;		
    /* "RECORD"	                         return RECORD; */
"RECORD"	                    BEGIN(INITIAL); return RECORD;
[,]*{BLANK}"SAVE"{BLANK}[,]*	                return SAVE;
[,]*{BLANK}"SKIPREC"	                        return SKIPREC;
[,]*{BLANK}"Y2PAST"	                            return Y2PAST;
[,]*{BLANK}"MODS"                           	return MODS;
"EXROUT"                                        return EXROUT;
"SORT"		       nPhase = 1;  BEGIN(INITIAL); return SORT;
[,]*{BLANK}"STARTREC"	                        return STARTREC;
[,]*{BLANK}"STOPAFT"	                        return STOPAFT;
[,]*{BLANK}"SPLIT"                              return SPLIT;
[,]*{BLANK}"SPLITBY"{BLANK}[=]{BLANK}           return SPLITBY;
"SUM"		                                    return SUM;
"USE"		                    BEGIN(INITIAL); return USE;
[,]*{BLANK}"VLSCMP"                             return VLSCMP;
[,]*{BLANK}"VLSHRT"	                            return VLSHRT;

"REMOVECC"	 printf("GCSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP;
",REMOVECC"	 printf("GCSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP;
"CONVERT"	 printf("GCSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP;
",CONVERT"	 printf("GCSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP;
"EQUALS"	 printf("GCSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP; 
",EQUALS"	 printf("GCSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP; 
"NODETAIL"   printf("GCSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP; 
",NODETAIL"  printf("GCSORT - Warning - Token skipped : "); ECHO; printf("\n"); // return TOKSKIP; 


","{BLANK}"AND"{BLANK}","	return AND;
","{BLANK}"&"{BLANK}","		return AND;
","{BLANK}"OR"{BLANK}","	return OR;
","{BLANK}"|"{BLANK}","		return OR;


{OPCOND}                    yylval.string = _strdup(yytext) ;					return OPCOND; 	
<ORDK>{ORDER}		        yylval.string = _strdup(yytext) ;					return ORDER; 
{DIGIT}				        yylval.number = strtol(yytext, &pEnd, 10) ;			return DIGIT;  
{SIGN}{DIGIT}		        yylval.number = strtol(yytext, &pEnd, 10) ;			return DIGIT; 
{DIGITBIG}			        yylval.llnumber = xstrtoll(yytext, &pEnd, 10) ;		return SIGNDIGITBIG;  
{SIGN}{DIGITBIG}	        yylval.llnumber = xstrtoll(yytext, &pEnd, 10) ;		return SIGNDIGITBIG;  
    /* {FORMATTYPE}		        yylval.string = _strdup(yytext) ;                   return FORMATTYPE;  */
{RECTYPEFIX}   	            yylval.string = _strdup(yytext) ;                   return RECTYPEFIX;
{RECTYPEVAR}                yylval.string = _strdup(yytext) ;                   return RECTYPEVAR;
        /* {FILETYPE}   	            yylval.string = _strdup(yytext) ;                   return FILETYPE;  */ 
<TORG>{FILETYPE}            yylval.string = _strdup(yytext) ;                   return FILETYPE; 
{OCCURFILL} 		        yylval.string = _strdup(yytext) ;                   return OCCURFILL;
<TCOND>{CHARTCOND}	        yylval.string = _strdup(yytext) ;                   return CHARTCOND;    
<CHSC>{CHARTYPE}	        yylval.string = _strdup(yytext) ;                   return CHARTYPE; 


{FORMATTYPE}		        yylval.string = _strdup(yytext) ;                   return FORMATTYPE;  

{EXROUT}                    yylval.string = _strdup(yytext) ;					return EXROUT; 	
  
   /* String C''';'   */
"'"[^']*"'"	{yylval.string=malloc(strlen(yytext)-1);
					 memcpy(yylval.string,yytext+1,strlen(yytext)-2);
					 yylval.string[strlen(yytext)-2]=0;
					 return STRING;}

<KEYV>{KEYTYPE}		yylval.string = _strdup(yytext) ; return KEYTYPE; 
{STRING}			yylval.string = _strdup(yytext) ; return STRING;
{BLANK}
.			        return yytext[0];


%%