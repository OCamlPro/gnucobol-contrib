/*
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
 *  along with OCSort.  If not, see [http://www.gnu.org/licenses/].

*/
#include <stdio.h>
#include <stdlib.h>
#include "ocsort.h"
#include "job.h"

void OCSort_Config ( void ) 
{
	struct job_t *job;
#if defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	DWORD page_size;
	SYSTEM_INFO sinf;
	GetSystemInfo(&sinf);
	page_size = sinf.dwAllocationGranularity;
#else
// linux debug printf("long page_size \n");
	long page_size ;
	page_size = sysconf (_SC_PAGESIZE);
#endif
	job=job_constructor();
	/*
	fprintf(stdout,"__________________________________________________________________________________________________________\n");
	fprintf(stdout,"ocsort Version %s\n", OCSORT_VERSION); 
	fprintf(stdout,"Copyright (C) 2009-2016 Cedric ISSALY / Sauro Menna\n");
	fprintf(stdout,"__________________________________________________________________________________________________________\n");
	fprintf(stdout,"\n");
	fprintf(stdout,"OCSORT_BYTEORDER  - 0 for NATIVE, 1 for BIGENDIAN                              : %ld\n", job->nByteOrder);
	fprintf(stdout,"OCSORT_DEBUG      - 0 no print info, 1 info DEBUG, 2 for info Parser           : %ld\n", job->ndeb);
	fprintf(stdout,"OCSORT_MEMSIZE    - Memory Allocation in MByte                                 : %7ld MByte\n", (job->ulMemSizeAlloc+job->ulMemSizeAllocSort)/1024000);
	fprintf(stdout,"                                                          Memory size for key  : %7ld MByte\n", (job->ulMemSizeAllocSort/1024000));
	fprintf(stdout,"                                                          Memory size for data : %7ld MByte\n", (job->ulMemSizeAlloc/1024000));
	fprintf(stdout,"OCSORT_MLT        - Numbers of page for cache MemoryMappedFile                 : %ld\n", job->nMlt);
	fprintf(stdout,"                                                              System page size : %7ld\n", page_size);
	fprintf(stdout,"                                                    MemoryMappedFile page size : %7.2f MByte\n", (double)(job->nMlt * page_size)/1024000);
	fprintf(stdout,"OCSORT_PATHTMP    - Pathname for temporary files                               : %s\n",  job->strPathTempFile);
//	fprintf(stdout,"OCSORT_SLOT       - Numbers of slot for MemoryMappedFile                       : %ld\n", job->nSlot);
	fprintf(stdout,"OCSORT_STATISTICS - 0 Minimal informations, 1 for Summary, 2 for Details       : %ld\n", job->nStatistics);
	fprintf(stdout,"OCSORT_TESTCMD    - 0 for normal operations, 1 for ONLY test command line      : %ld\n", job->nTestCmdLine);
	fprintf(stdout,"__________________________________________________________________________________________________________\n");
	*/
//
	fprintf(stdout,"________________________________________________________________________\n");
	fprintf(stdout,"ocsort Version %s\n", OCSORT_VERSION); 
	fprintf(stdout,"Copyright (C) 2009-2016 Cedric ISSALY / Sauro Menna\n");
	fprintf(stdout,"________________________________________________________________________\n");
	fprintf(stdout,"\n");
	fprintf(stdout,"OCSORT_BYTEORDER             : %ld", job->nByteOrder);
	if (job->nByteOrder == 0)
		fprintf(stdout," - Native\n");
	else
		fprintf(stdout," - Bigendian\n");
	fprintf(stdout,"OCSORT_DEBUG                 : %ld", job->ndeb);
	if (job->ndeb == 0)
		fprintf(stdout," - No info debug\n");
	else
		if (job->ndeb == 1)
			fprintf(stdout," - Info debug\n");
		else
			fprintf(stdout," - Info debug Parser/Scanner\n");

	fprintf(stdout,"OCSORT_MEMSIZE               : %7ld MByte\n", (job->ulMemSizeAlloc+job->ulMemSizeAllocSort)/1024000);
	fprintf(stdout,"         Memory size for key : %7ld MByte\n", (job->ulMemSizeAllocSort/1024000));
	fprintf(stdout,"        Memory size for data : %7ld MByte\n", (job->ulMemSizeAlloc/1024000));
	fprintf(stdout,"OCSORT_MLT                   : %7ld Pages for cache MemoryMappedFile\n", job->nMlt);
	fprintf(stdout,"  MemoryMappedFile page size : %7.2f MByte\n", (double)(job->nMlt * page_size)/1024000);
	fprintf(stdout,"            System page size : %7ld Bytes\n", page_size);
	fprintf(stdout,"OCSORT_PATHTMP               : %s\n",  job->strPathTempFile);
//	fprintf(stdout,"OCSORT_SLOT       - Numbers of slot for MemoryMappedFile                       : %ld\n", job->nSlot);
	fprintf(stdout,"OCSORT_STATISTICS            : %ld", job->nStatistics);
	if (job->nStatistics == 0) 
		fprintf(stdout," - Statistics Minimal informations\n");
	else
		if (job->nStatistics == 1)
			fprintf(stdout," - Statistics Summary\n");
		else
			fprintf(stdout," - Statistics Detail\n");       
	fprintf(stdout,"OCSORT_TESTCMD               : %ld", job->nTestCmdLine);
	if (job->nTestCmdLine == 0)
		fprintf(stdout," - Normal operations\n");
	else
		fprintf(stdout," - ONLY test command line, NO SORT/MERGE operation\n");      
	fprintf(stdout,"________________________________________________________________________\n");

//
	job_destructor(job);
	return;
}

void OCSort_Version ( void ) 
{
	printf("ocsort Version %s\n", OCSORT_VERSION); 
	printf("Copyright (C) 2009-2016 Cedric ISSALY / Sauro Menna\n");
	return;
}
void OCSort_Usage ( void ) 
{
	printf("___________________________________________________________________________________\n");
	printf(" ocsort	Help                                                                       \n");
	printf("___________________________________________________________________________________\n");
	printf(" Syntax = Uppercase sensitive                                                      \n");
	printf(" Return code : 0 (ok) - 16 (error)                                                 \n");
	printf("___________________________________________________________________________________\n");
	printf("Usage with file parameters   : ocsort TAKE filename                                \n");
	printf("___________________________________________________________________________________\n");
	printf("Usage with command line                                                            \n");
	printf("OCSORT                                                                             \n");
	printf("	SORT | MERGE                                                                   \n");
	printf("		FIELDS (START,LENGTH,TYPE,[A|D], ...)           |                          \n");
	printf("		FIELDS ((START,LENGTH,[A|D], ...),FORMAT=TYPE	|                 	       \n");
	printf("		FIELDS=COPY 							                          	       \n");
	printf("	USE  FILENAME ORG [LS|SQ] RECORD [[F,Record Len] | [V,MIN,MAX Record Len]]     \n");
	printf("	GIVE FILENAME ORG [LS|SQ] RECORD [[F,Record Len] | [V,MIN,MAX Record Len]]     \n");
	printf("	INCLUDE|OMIT COND=(CONDITION) [FORMAT=TYPE]                                    \n");
	printf("	   (CONDITION) (pos,len,type,cond,[AND|OR],pos,len,type)					   \n");
	printf("	               (pos,len,type,cond,[X|C|Z]'[value]')							   \n");
	printf("	               (cond,[AND|OR],cond)											   \n");
	printf("	INREC FIELDS=(FIELD-SPEC...)                                                   \n");
	printf("	INREC BUILD=(FIELD-SPEC...)                                                    \n");
	printf("	SUM FIELDS = (pos,len,type, ...)                                               \n");
	printf("	SUM FIELDS = (NONE)  or   SUM FIELDS = NONE									   \n");
	printf("	OUTREC FIELDS=(FIELD-SPEC...)                                                  \n");
	printf("	OUTREC BUILD=(FIELD-SPEC...)                                                   \n");
	printf("	OUTFIL                                                                         \n");
	printf("		FILES/FNAMES= (enviroment variable)                                        \n");
	printf("		STARTREC=nn                                                                \n");
	printf("		ENDREC=nn                                                                  \n");
	printf("		[SAVE|[INCLUDE|OMIT] (CONDITION) [FORMAT=TYPE]]                            \n");
	printf("		SPLIT                                                                      \n");
	printf("	    OUTREC = (FIELD-SPEC...)                                                   \n");
	printf("	OPTION                                                                         \n");
	printf("	       SKIPREC=nn		Skip nn records from input							   \n");
	printf("	       STOPAFT=nn		Stop read after nn records							   \n");
	printf("	       VLSCMP           0 disabled , 1 = enabled -- temporarily replace any    \n");
	printf("	       	                  missing compare field bytes with binary zeros        \n");
	printf("	       VLSHRT           0 disabled , 1 = enabled -- treat any comparison       \n");
	printf("	       	                  involving a short field as false                     \n");
	printf("	       EQUALS           Command skipped                                        \n");
	printf("	       REMOVECC         Command skipped                                        \n");
	printf("	       CONVERT          Command skipped                                        \n");
	printf("	       NODETAIL         Command skipped                                        \n");
	printf("___________________________________________________________________________________\n");
	printf("Format Type                                                                        \n");
	printf("___________________________________________________________________________________\n");
	printf("	CH = Char                                                                      \n");
	printf("	BI = Binary unsigned                                                           \n");
	printf("	FI = Binary signed                                                             \n");
	printf("	PD = Packed                                                                    \n");
	printf("	ZD = Zoned    max 18 digits                                                    \n");
	printf("___________________________________________________________________________________\n");
	printf("File Organization                                                                  \n");
	printf("___________________________________________________________________________________\n");
	printf("    LS  = Line Sequential                                                          \n");
	printf("    SQ  = Sequential Fixed or Variable (first 4 byte  record len )                 \n");
//future use	printf("    SQMF= Sequential (Header file + first 2/4 byte record len )                    \n");
	printf("___________________________________________________________________________________\n");
	printf("Variables Environment                                                              \n");
	printf("___________________________________________________________________________________\n");
//future use	printf("OCSORT_EMULATE     Value 0 for OCSORT, 1 for MF Emulator                        \n");
	printf("OCSORT_BYTEORDER   0 for NATIVE , 1 for BIGENDIAN. Default 0 (NATIVE)              \n");
	printf("OCSORT_DEBUG       0 no print info, 1 info DEBUG, 2 for info Parser                \n");
	printf("OCSORT_MEMSIZE     Memory Allocation in byte(Default 512000000 byte)               \n");
	printf("OCSORT_PATHTMP     Pathname for temporary files							   	       \n");
	printf("OCSORT_STATISTICS  0 minimal informations, 1 for Summary, 2 for Details            \n");
	printf("OCSORT_TESTCMD     0 for normal operations , 1 for ONLY test command line (NO SORT)\n");
	printf("___________________________________________________________________________________\n");
return ;
}
