/*
    Copyright (C) 2016-2020 Sauro Menna
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
 *  along with GCSORT.  If not, see [http://www.gnu.org/licenses/].

*/
#include <stdio.h>
#include <stdlib.h>
//-->>## aix #if	defined(__GNUC__) && !defined(__MINGW32__) && !defined(__MINGW64__)
#if	(defined(__GNUC__) || defined(__xlc__))&& !defined(__MINGW32__) && !defined(__MINGW64__)
    #include <inttypes.h>
#endif
#include "gcsort.h"
#include "job.h"

void GCSORT_Config ( void ) 
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
	fprintf(stdout,"gcsort Version %s\n", GCSORT_VERSION); 
	fprintf(stdout,"Copyright (C) 2009-2020 Cedric ISSALY / Sauro Menna\n");
	fprintf(stdout,"__________________________________________________________________________________________________________\n");
	fprintf(stdout,"\n");
	fprintf(stdout,"GCSORT_BYTEORDER  - 0 for NATIVE, 1 for BIGENDIAN                              : %ld\n", job->nByteOrder);
	fprintf(stdout,"GCSORT_DEBUG      - 0 no print info, 1 info DEBUG, 2 for info Parser           : %ld\n", job->ndeb);
	fprintf(stdout,"GCSORT_MEMSIZE    - Memory Allocation in MByte                                 : %7ld MByte\n", (job->ulMemSizeAlloc+job->ulMemSizeAllocSort)/1024000);
	fprintf(stdout,"                                                          Memory size for key  : %7ld MByte\n", (job->ulMemSizeAllocSort/1024000));
	fprintf(stdout,"                                                          Memory size for data : %7ld MByte\n", (job->ulMemSizeAlloc/1024000));
	fprintf(stdout,"GCSORT_MLT        - Numbers of page for cache MemoryMappedFile                 : %ld\n", job->nMlt);
	fprintf(stdout,"                                                              System page size : %7ld\n", page_size);
	fprintf(stdout,"                                                    MemoryMappedFile page size : %7.2f MByte\n", (double)(job->nMlt * page_size)/1024000);
	fprintf(stdout,"GCSORT_PATHTMP    - Pathname for temporary files                               : %s\n",  job->strPathTempFile);
//	fprintf(stdout,"GCSORT_SLOT       - Numbers of slot for MemoryMappedFile                       : %ld\n", job->nSlot);
	fprintf(stdout,"GCSORT_STATISTICS - 0 Minimal informations, 1 for Summary, 2 for Details       : %ld\n", job->nStatistics);
	fprintf(stdout,"GCSORT_TESTCMD    - 0 for normal operations, 1 for ONLY test command line      : %ld\n", job->nTestCmdLine);
	fprintf(stdout,"__________________________________________________________________________________________________________\n");
	*/
//
	fprintf(stdout,"________________________________________________________________________\n");
	fprintf(stdout,"gcsort Version %s\n", GCSORT_VERSION); 
	fprintf(stdout,"Copyright (C) 2009-2020 Cedric ISSALY / Sauro Menna\n");
	fprintf(stdout,"________________________________________________________________________\n");
	fprintf(stdout,"\n");
//-->>	fprintf(stdout,"GCSORT_BYTEORDER             : %d", job->nByteOrder);
//-->>	if (job->nByteOrder == 0)
//-->>		fprintf(stdout," - Native\n");
//-->>	else
//-->>		fprintf(stdout," - Bigendian\n");
	fprintf(stdout,"GCSORT_DEBUG                 : %d", job->ndeb);
	if (job->ndeb == 0)
		fprintf(stdout," - No info debug\n");
	else
		if (job->ndeb == 1)
			fprintf(stdout," - Info debug\n");
		else
			fprintf(stdout," - Info debug Parser/Scanner\n");

	fprintf(stdout,"GCSORT_MEMSIZE               : " CB_FMT_LLD " MByte\n", (long long)(job->ulMemSizeAlloc+job->ulMemSizeAllocSort)/1024000);
	fprintf(stdout,"         Memory size for key : " CB_FMT_LLD " MByte\n", (long long)(job->ulMemSizeAllocSort/1024000));
	fprintf(stdout,"        Memory size for data : " CB_FMT_LLD " MByte\n", (long long)(job->ulMemSizeAlloc/1024000));
	fprintf(stdout,"GCSORT_MLT                   : %7d  Pages for cache MemoryMappedFile\n", job->nMlt);
	fprintf(stdout,"  MemoryMappedFile page size : %7.2f MByte\n", (double)(job->nMlt * page_size)/1024000);
	fprintf(stdout,"            System page size : %7ld Bytes\n", page_size);
	fprintf(stdout,"GCSORT_PATHTMP               : %s\n",  job->strPathTempFile);
//	fprintf(stdout,"GCSORT_SLOT       - Numbers of slot for MemoryMappedFile                       : %ld\n", job->nSlot);
	fprintf(stdout,"GCSORT_STATISTICS            : %d", job->nStatistics);
	if (job->nStatistics == 0) 
		fprintf(stdout," - Statistics Minimal informations\n");
	else
		if (job->nStatistics == 1)
			fprintf(stdout," - Statistics Summary\n");
		else
			fprintf(stdout," - Statistics Detail\n");       
	fprintf(stdout,"GCSORT_TESTCMD               : %d", job->nTestCmdLine);
	if (job->nTestCmdLine == 0)
		fprintf(stdout," - Normal operations\n");
	else
		fprintf(stdout," - ONLY test command line, NO SORT/MERGE operation\n");      
	fprintf(stdout,"________________________________________________________________________\n");

//
	job_destructor(job);
	return;
}

void GCSORT_Version ( void ) 
{
	printf("gcsort Version %s\n", GCSORT_VERSION); 
	printf("Copyright (C) 2009-2020 Cedric ISSALY / Sauro Menna\n");
	printf("Packaged  %s\n", GCSORT_TAR_DATE);
	return;
} 
void GCSORT_Usage ( void ) 
{
    printf("________________________________________________________________________________________\n");
    printf(" gcsort help\n");
    printf(" gcsort is a  program to sort, merge and copy records in a file into a specified order\n");
    printf("________________________________________________________________________________________\n");
    printf(" Syntax case insensitive                                                         \n");
    printf(" Return code : 0 (ok) - 16 (error)                                                 \n");
    printf("________________________________________________________________________________________\n");
    printf("Usage with file parameters  : gcsort <options> take filename   \n");
    printf("Usage from command line     : gcsort <options> <control statements> \n");
    printf("________________________________________________________________________________________\n");
    printf("gcsort options\n");
    printf("-fsign=[ASCII|EBCDIC] define display sign representation\n");
    printf("________________________________________________________________________________________\n");
    printf("gcsort control statements\n");
    printf("Notations: '{name}' = parameters , '|' = Alternative format of control statement\n");
    printf("________________________________________________________________________________________\n");
    printf(" SORT | MERGE FIELDS Control statement for Sort or Merge file(s)\n");
    printf(" USE                 Declare input file(s)\n");
    printf(" GIVE                Declare output file\n");
    printf(" [ SUM FIELDS ]      Sum fields for same record key, or eliminate duplicate keys)\n");
    printf(" [ INCLUDE    ]      Select input records that respect include condition(s)\n");
    printf(" [ OMIT       ]      Omit input records that respect include condition(s)\n");
    printf(" [ INREC      ]      Reformat input record Before sort, merge or copy operation\n");
    printf(" [ OUTREC     ]      Reformat input record After sort, merge or copy operation\n");
    printf(" [ OUTFIL     ]      Create one or more output files for sort,merge or copy operation \n");
    printf(" [ OPTION     ]      Specifies option for control statements\n");
    printf("________________________________________________________________________________________\n");
    printf("gcsort\n");
    printf("    SORT | MERGE                                                                   \n");
    printf("         FIELDS({Pos},{Len},{FormatType},{Order}, ...)          |              \n");
    printf("         FIELDS({Pos},{Len},{Order}, ...),FORMAT={FormatType}   |              \n");
    printf("         FIELDS=COPY                                                               \n");
    printf("\n");
    printf("    USE  {Filename} \n");
    printf("         ORG {Org}\n");
    printf("         RECORD [F,{RecordLen}] | [V,{MinLen},{MaxLen}] \n");
    printf("                [KEY ({Pos},{Len},{KeyType})]\n");
    printf("\n");
    printf("    GIVE same parameters of USE \n");
    printf("\n");
    printf("    SUM FIELDS = [({Pos},{Len},{FormatType2}, ...)]         |\n");
    printf("                 [({Pos},{Len}, ...)],FORMAT={FormatType2}  |\n");
    printf("                 [NONE] | [(NONE)]\n");
    printf("\n");
    printf("    INCLUDE | OMIT\n");
    printf("            COND=({Condition})[,FORMAT={FormatType}]                     \n");
    printf("\n");
    printf("    INREC   FIELDS | INREC   BUILD =({FieldSpec})\n");                     
    printf("    OUTREC  FIELDS | OUTREC  BUILD =({FieldSpec})\n");                     
    printf("\n");
    printf("    OUTFIL                                                                         \n");
    printf("         INCLUDE | OMIT ({Condition})[,FORMAT={FormatType}]                            \n");
    printf("         OUTREC = ({FieldSpec})                                                   \n");
    printf("         FILES/FNAMES= {Filename}  | (file1, file2, file3,...) \n");
    printf("         STARTREC={nn}    Start from record nn                                     \n");
    printf("         ENDREC={nn}      Skip record after nn                                      \n");
    printf("         SAVE                            \n");
    printf("         SPLIT            Split 1 record  output for file group (file1, file2, file3,...)  \n");
    printf("         SPLITBY={nn}     Split n records output for file group (file1, file2, file3,...)  \n");
    printf("\n");
    printf("    OPTION                                                                         \n");
    printf("         SKIPREC={nn}     Skip nn records from input                               \n");
    printf("         STOPAFT={nn}     Stop read after nn records                               \n");
    printf("         VLSCMP           0 disabled , 1 = enabled -- temporarily replace any    \n");
    printf("                               missing compare field bytes with binary zeros        \n");
    printf("         VLSHRT           0 disabled , 1 = enabled -- treat any comparison       \n");
    printf("                               involving a short field as false                     \n");
    printf("\n");
    printf("________________________________________________________________________________________\n");
    printf("___{Parameters}____________________________|___{Relational}_____________________________\n");
    printf("  {FileName} = Filename or Env. Variable   |  EQ = Equal                                \n");
    printf("  {Pos}      = Field Position              |  GT = GreaterThan                          \n");
    printf("  {Len}      = Field Length                |  GE = GreaterEqual                         \n");
    printf("  {RecordLen}= Record Length               |  LT = LesserThan                           \n");
    printf("  {MinLen}   = Min size of record          |  LE = LesserEqual                          \n");
    printf("  {MaxLen}   = Max size of record          |  NE = NotEqual                             \n");
    printf("  {Order}    = A(ascending) | D(descending)|  SS = SubString (only for Field Type 'CH') \n");
    printf("___________________________________________|____________________________________________\n");
    printf("___{Condition}__________________________________________________________________________\n");
    printf("  Format 1  - (Pos,Len,{FormatType},{Relational},[AND|OR],Pos,Len,{FormatType})         \n");
    printf("  Format 2  - (Pos,Len,{FormatType},{Relational},[X|C'[value]'] | numeric value)]       \n");
    printf("  Format 3  - ( {Condition} ,[AND|OR],{Condition} )                                     \n");
    printf("________________________________________________________________________________________\n");
    printf("___{Org}___File Organization_______________|___{KeyType}____Mandatory for ORG = IX______\n");
    printf("  LS  = Line Sequential                    |  P  = Primary Key                          \n");
    printf("  SQ  = Sequential Fixed or Variable       |  A  = Alternative Key                      \n");
    printf("  IX  = Indexed Fixed or Variable          |  D  = Alternative Key with Duplicates      \n");
    printf("  RL  = Relative Fixed or Variable         |  C  = Continue definition                  \n");
    printf("___________________________________________|____________________________________________\n");
    printf("__{FormatType}____Field Format Type________|___{FormatType2}____Format Type SumField____\n");
    printf("  CH  = Char                               |  BI = Binary unsigned                      \n");
    printf("  BI  = Binary unsigned                    |  FI = Binary signed                        \n");
    printf("  FI  = Binary signed                      |  FL = Floating Point                       \n");
    printf("  FL  = Floating Point                     |  PD = Packed                               \n");
    printf("  PD  = Packed                             |  ZD = Zoned                                \n");
    printf("  ZD  = Zoned                              |  CLO = Numeric sign leading                \n");
    printf("  CLO = Numeric sign leading               |  CSL = Numeric sign leading separate       \n");
    printf("  CSL = Numeric sign leading separate      |  CST = Numeric sign trailing separate      \n");
    printf("  CST = Numeric sign trailing separate     |                                            \n");
    printf("___________________________________________|____________________________________________\n");
    printf("____{FieldSpec}___Field Specification___________________________________________________\n");
    printf("  pos, len           pos = position input record, len = length of field            \n");
    printf("  posOut:pos,len     posOut  = position output, pos = position input , len = length \n");
    printf("  n:X                Filling with Blank character from last position to n\n");
    printf("                         (absolute position of output record).\n");
    printf("  n:Z                Filling with zero Binary character from last position to n \n");
    printf("                         (absoluteposition of output record). \n");
    printf("  C'constant'        constant character value.                \n");
    printf("  nC'constant'       repeat n times constant character value. \n");
    printf("  nX                 repeat n times Blank character.          \n");
    printf("  nZ                 repeat n times Binary (0x00) character.  \n");
    printf("  X'hh....hh'        hexdecimal characters.                   \n");
    printf("  nX'hh...hh'        repeat n times hexdecimal characters.    \n");
    printf("________________________________________________________________________________________\n");
    printf("Environment Variables                                                                   \n");
    printf("________________________________________________________________________________________\n");
    printf("COB_VARSEQ_FORMAT  Used by GnuCOBOL\n");
    printf("GCSORT_DEBUG       0 no print info, 1 info DEBUG, 2 for info Parser                \n");
    printf("GCSORT_MEMSIZE     Memory Allocation in byte (Default 512000000 byte)              \n");
    printf("GCSORT_PATHTMP     Pathname for temporary files     (Default TMP / TEMP / TMPDIR)     \n");
    printf("GCSORT_STATISTICS  0 minimal informations, 1 for Summary, 2 for Details            \n");
    printf("GCSORT_TESTCMD     0 for normal operations , 1 for ONLY test command line (NO SORT)\n");
    printf("________________________________________________________________________________________\n");
return ;
}
