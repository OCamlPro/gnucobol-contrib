/*
 *  Copyright (C) 2015 Sauro Menna 
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
 *  along with OCSort.  If not, see [http://www.gnu.org/licenses/].

*/
#include <stdio.h>
#include <stdlib.h>
#include "ocsort.h"


void OCSort_Version ( void ) 
{
	printf("ocsort Version %s\n", OCSORT_VERSION); 
	printf("Copyright (C) 2009-2015 Cedric ISSALY / Sauro Menna\n");
}
void OCSort_Usage ( void ) 
{
	printf("___________________________________________________________________________________\n");
	printf(" ocsort	Help                                                                       \n");
	printf("___________________________________________________________________________________\n");
	printf(" Syntax = Uppercase sensitive                                                      \n");
	printf("___________________________________________________________________________________\n");
	printf("Usage with file parameters   : OCSORT TAKE filename                                \n");
	printf("___________________________________________________________________________________\n");
	printf("Usage with command line                                                            \n");
	printf("OCSORT                                                                             \n");
	printf("	SORT | MERGE                                                                   \n");
	printf("		FIELDS (START,LENGTH,TYPE,[A|D], ...)           |                          \n");
	printf("		FIELDS ((START,LENGTH,[A|D], ...),FORMAT=TYPE	|                 	       \n");
	printf("		FIELDS=COPY 							                          	       \n");
	printf("	USE  FILENAME ORG [LS|SQ|SQMF] RECORD [[F,Record Len] | [V,MIN,MAX Record Len]]\n");
	printf("	GIVE FILENAME ORG [LS|SQ|SQMF] RECORD [[F,Record Len] | [V,MIN,MAX Record Len]]\n");
	printf("	INCLUDE|OMIT COND=(CONDITION) [FORMAT=TYPE]                                    \n");
	printf("	   (CONDITION) (pos,len,type,cond,[AND|OR],pos,len,type)					   \n");
	printf("	               (pos,len,type,cond,[X|C|Z]'[value]')							   \n");
	printf("	               (cond,[AND|OR],cond)											   \n");
	printf("	INREC FIELDS=(FIELD-SPEC...)                                                   \n");
	printf("	SUM FIELDS = (pos,len,type, ...)                                               \n");
	printf("	SUM FIELDS = (NONE)  or   SUM FIELDS = NONE									   \n");
	printf("	OUTREC FIELDS=(FIELD-SPEC...)                                                  \n");
	printf("	OUTFIL                                                                         \n");
	printf("		FILES/FNAMES= (enviroment variable)                                        \n");
	printf("		STARTREC=nn                                                                \n");
	printf("		ENDREC=nn                                                                  \n");
	printf("		[SAVE|[INCLUDE|OMIT] (CONDITION) [FORMAT=TYPE]]                            \n");
	printf("		SPLIT                                                                      \n");
	printf("	    OUTREC = (FIELD-SPEC...)                                                   \n");
	printf("	OPTION                                                                         \n");
	printf("	       SKIPREC=nn, STOPAFT=nn                                                  \n");
	printf("	       VLSCMP VLSHRT EQUALS REMOVECC                                           \n");
	printf("___________________________________________________________________________________\n");
	printf("Format Type                                                                        \n");
	printf("___________________________________________________________________________________\n");
	printf("	CH = Char                                                                      \n");
	printf("	BI = Binary   binary-byteorder: native                                         \n");
	printf("	PD = Packed   binary-byteorder: native                                         \n");
	printf("	ZD = Zoned    max 18 digits                                                    \n");
	printf("___________________________________________________________________________________\n");
	printf("File Organization                                                                  \n");
	printf("___________________________________________________________________________________\n");
	printf("    LS  = Line Sequential                                                          \n");
	printf("    SQ  = Sequential Fixed or Variable (first 4 byte  record len )                 \n");
	printf("    SQMF= Sequential (Header file + first 2/4 byte record len )                    \n");
	printf("___________________________________________________________________________________\n");
	printf("Variables Environment                                                              \n");
	printf("___________________________________________________________________________________\n");
	printf("OCSORT_EMULATE     Value 0 for OCSORT, 1 for MF Emulator                           \n");
	printf("OCSORT_MEMSIZE     Memory Allocation in byte(Default 512000000 byte)               \n");
	printf("OCSORT_TESTCMD     Value 0 for normal operations , 1 for ONLY test command line    \n");
	printf("OCSORT_DEBUG       Value 0 for normal operations , 1 for DEBUG, 2 for DEBUG Parser \n");
	printf("OCSORT_PATHTMP     Pathname for temporary files							   	       \n");
	printf("OCSORT_STATISTICS  0 for normal operations , 1 for Summary, 2 for Details          \n");
	printf("___________________________________________________________________________________\n");
return ;
}
