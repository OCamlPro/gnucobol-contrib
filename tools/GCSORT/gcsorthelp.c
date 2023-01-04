/*
    Copyright (C) 2016-2021 Sauro Menna
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
/* -->>## aix #if	defined(__GNUC__) && !defined(__MINGW32__) && !defined(__MINGW64__) */
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
/* linux debug printf("long page_size \n"); */
	long page_size ;
	page_size = sysconf (_SC_PAGESIZE);
#endif
	job=job_constructor();
	/*
	fprintf(stdout,"__________________________________________________________________________________________________________\n");
	fprintf(stdout,"gcsort Version %s\n", GCSORT_VERSION); 
	fprintf(stdout,"Copyright (C) 2009-2021 Cedric ISSALY / Sauro Menna\n");
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
	fprintf(stdout,"GCSORT_STATISTICS - 0 Minimal informations, 1 for Summary, 2 for Details       : %ld\n", job->nStatistics);
	fprintf(stdout,"GCSORT_TESTCMD    - 0 for normal operations, 1 for ONLY test command line      : %ld\n", job->nTestCmdLine);
	fprintf(stdout,"__________________________________________________________________________________________________________\n");
	*/
	fprintf(stdout,"________________________________________________________________________\n");
	fprintf(stdout,"gcsort Version %s\n", GCSORT_VERSION); 
	fprintf(stdout,"Copyright (C) 2009-2022 Cedric ISSALY / Sauro Menna\n");
	fprintf(stdout,"________________________________________________________________________\n");
	fprintf(stdout,"\n");
	fprintf(stdout,"GCSORT_DEBUG                 : %d", job->ndeb);
	if (job->ndeb == 0) {
		fprintf(stdout," - No info debug\n");
    }
	else
    {
		if (job->ndeb == 1)
			fprintf(stdout," - Info debug\n");
		else
			fprintf(stdout," - Info debug Parser/Scanner\n");
    }
	fprintf(stdout,"GCSORT_MEMSIZE               : " NUM_FMT_LLD " MByte\n", (long long)(job->ulMemSizeAlloc+job->ulMemSizeAllocSort)/1024000);
	fprintf(stdout,"        Memory size for key  : " NUM_FMT_LLD " MByte\n", (long long)(job->ulMemSizeAllocSort/1024000));
	fprintf(stdout,"        Memory size for data : " NUM_FMT_LLD " MByte\n", (long long)(job->ulMemSizeAlloc/1024000));
	fprintf(stdout,"GCSORT_MLT                   : %7d  Pages for cache MemoryMappedFile\n", job->nMlt);
	fprintf(stdout,"  MemoryMappedFile page size : %7.2f MByte\n", (double)(job->nMlt * page_size)/1024000);
	fprintf(stdout,"            System page size : %7ld Bytes\n", page_size);
	fprintf(stdout,"GCSORT_PATHTMP               : %s\n",  job->strPathTempFile);
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

	job_destructor(job);
	return;
}

void GCSORT_Version ( void ) 
{
	printf("gcsort Version %s\n", GCSORT_VERSION); 
	printf("Copyright (C) 2009-2022 Cedric ISSALY / Sauro Menna\n");
	printf("Packaged  %s\n", GCSORT_TAR_DATE);

#if __LIBCOB_VERSION >= 3
    print_version_summary();        /* GnuCOBOL Version */
#endif
    if (sizeof(void*) > 4U) 
        printf("gcsort 64bit-mode %s\n", "yes");
    else
        printf("gcsort 64bit-mode %s\n", "no");

    return;
} 
/*
void GCSORT_Usage ( void ) 
{
    printf("________________________________________________________________________________________\n");
    printf(" gcsort help\n");
    printf(" gcsort is a program to sort, merge, copy and join records in a file into a specified order\n");
    printf("________________________________________________________________________________________\n");
    printf(" Syntax case insensitive                                                         \n");
    printf(" Return code : 0 (ok) - 4 (warning) - 16 (error)                                 \n");
    printf("________________________________________________________________________________________\n");
    printf("Usage with file parameters  : gcsort <options> take filename   \n");
    printf("Usage from command line     : gcsort <options> <control statements> \n");
    printf("________________________________________________________________________________________\n");
    printf("gcsort options\n");
    printf("-fsign=[ASCII|EBCDIC] define display sign representation\n");
#if __LIBCOB_RELEASE >= 30200
    printf("-fcolseq=[NATIVE|ASCII|EBCDIC] collating sequence to use\n");
    printf("-febcdic-table=[DEFAULT|IBM|GCOS] EBCDIC table to use\n");
#endif / * __LIBCOB_RELEASE >= 30200 * /
    printf("________________________________________________________________________________________\n");
    printf("gcsort control statements\n");
    printf("Notations: '{name}' = parameters , '|' = Alternative format of control statement\n");
    printf("________________________________________________________________________________________\n");
    printf(" SORT | MERGE | COPY FIELDS Control statement for Sort, Merge, Copy file(s)\n");
    printf(" USE                 Declare input file(s)\n");
    printf(" GIVE                Declare output file\n");
    printf(" [ SUM FIELDS ]      Sum fields for same record key, or eliminate duplicate keys)\n");
    printf(" [ RECORD     ]      Record control statement \n");
    printf(" [ INCLUDE    ]      Select input records that respect include condition(s)\n");
    printf(" [ OMIT       ]      Omit input records that respect omit condition(s)\n");
    printf(" [ INREC      ]      Reformat input record Before sort, merge or copy operation\n");
    printf(" [ OUTREC     ]      Reformat input record After sort, merge or copy operation\n");
    printf(" [ OUTFIL     ]      Create one or more output files for sort,merge or copy operation \n");
    printf(" [ OPTION     ]      Specifies option for control statements\n");
    printf("________________________________________________________________________________________\n");
    printf("gcsort\n");
    printf("    SORT | MERGE | COPY                                                        \n");
    printf("         FIELDS({Pos},{Len},{FormatType},{Order}, ...)          |              \n");
    printf("         FIELDS({Pos},{Len},{Order}, ...),FORMAT={FormatType}   |              \n");
    printf("         FIELDS=COPY                                                           \n");
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
    printf("    RECORD [TYPE=[{V}(Variable-length)/{F}(Fixed-length)]],[LENGTH=[{len}(L1-Input record length)]\n");
    printf("                                                                ','[{len}(L2-Record length)]\n");
    printf("                                                                ','[{len}(L3-Output record length)]\n");
    printf("    INCLUDE | OMIT\n");
    printf("            COND=({Condition})[,FORMAT={FormatType}]                     \n");
    printf("\n");
    printf("    INREC   FIELDS | INREC   BUILD =({FieldSpec})\n");                     
    printf("    INREC   OVERLAY =({FieldSpec})\n");
    printf("    OUTREC  FIELDS | OUTREC  BUILD =({FieldSpec})\n");
    printf("    OUTREC  OVERLAY =({FieldSpec}) \n");
    printf(" \n");
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
    printf("         Y2PAST           (YY) - Sliding, (YYYY) century\n");
    printf("         MODS E15=(<name>) [,]     <name>= Name E15 Cobol Program for input\n");
    printf("              E35=(<name>)         <name>= Name E35 Cobol Program for ouput\n");
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
    printf("  Format 4  - ( Pos,Len,{FormatType},{Relational}, [DATE1][(+/-)num] | [DATE2][(+/-)num]\n");
    printf("                                                   [DATE3][(+/-)num] | [DATE4][(+/-)num]\n");
    printf("       DATE - Currente Date : DATE1 (C'yyyymmdd'), DATE2 (C'yyyymm'),                   \n");
    printf("                              DATE3 (C'yyyyddd'),  DATE4 (C'yyyy-mm-dd') (no Timestamp) \n");
    printf("       [(+/-)num]  [+num] future date, [-num] past date) only for DATE1,DATE2,DATE3     \n");
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
    printf("_Format_Len_Type__Date field_______________|_Format_Len_Type__Date field________________\n");
    printf("  Y2T = 8   ZD    CCYYMMDD                 |  Y2D = 1   PD    YY                        \n");
    printf("  Y2T = 4   ZD    YYXX                     |  Y2P = 2   PD    YY                        \n");
    printf("  Y2T = 2   ZD    YYX                      |  Y2U = 3   PD    YYDDD                     \n");
    printf("  Y2T = 3   ZD    YY                       |  Y2S = 2   ZD    YY                        \n");
    printf("  Y2T = 5   ZD    YYDDD                    |  Y2V = 4   PD    YYMMDD                    \n");
    printf("  Y2T = 6   ZD    YYMMDD                   |  Y2X = 3   PD    DDDYY                     \n");
    printf("  Y2B = 1   BI    YY                       |  Y2Y = 4   PD    MMDDYY                    \n");
    printf("  Y2C = 2   ZD    YY                       |  Y2Z = 2   ZD    YY                        \n");
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
    printf("  CHANGE=(vlen,[C | X]'<valueFind>',[C | X]'<valueSet>',.....),NOMATCH=([C | X]'<valueSet>)    \n");
    printf("  CHANGE=(vlen,[C | X]'<valueFind>', posIn, lenIn), NOMATCH = (posIn, posLen)\n");
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
*/
void GCSORT_Usage(unsigned char* cmd) {
    int nT = 0;
    if (cmd == NULL)
        nT = 3;
    else
        if ((_stricmp(cmd, "SORT") == 0) || (_stricmp(cmd, "MERGE") == 0) || (_stricmp(cmd, "COPY") == 0))
            nT = 1;
        else
            if (_stricmp(cmd, "JOIN") == 0)
                nT = 2;
                else {
                    printf("*GCSort* Help message : Control statement invalid \n");
                    return;
                }
        
    gcsort_help_header();
    gcsort_help_header2();
    if (nT == 1)
        gcsort_help_body_SMC();
    if (nT == 2)
        gcsort_help_body_JOIN();
    if (nT == 3)
    {
        gcsort_help_body_SMC();
        gcsort_help_body_JOIN();
    }

    gcsort_help_footer();
    return;
}

void GCSORT_Usage_all(void)
{
    printf("________________________________________________________________________________________\n");
    printf(" gcsort help\n");
    printf(" gcsort is a utility to sort, merge, copy and join records in a file into a \n");
    printf("   specified order in GnuCOBOL environment.\n");
    printf("________________________________________________________________________________________\n");
    printf(" Syntax case insensitive                                                         \n");
    printf(" Return code : 0 (ok) - 4 (warning) - 16 (error)                                 \n");
    printf("________________________________________________________________________________________\n");
    printf("Usage with file parameters  : gcsort <options> take filename   \n");
    printf("Usage from command line     : gcsort <options> <control statements> \n");
    printf("________________________________________________________________________________________\n");
    printf("gcsort options\n");
    printf("-fsign=[ASCII|EBCDIC] define display sign representation\n");
#if __LIBCOB_RELEASE >= 30200
    printf("-fcolseq=[NATIVE|ASCII|EBCDIC] collating sequence to use\n");
    printf("-febcdic-table=[DEFAULT|IBM|GCOS] EBCDIC table to use\n");
#endif /* __LIBCOB_RELEASE >= 30200 */
    printf("________________________________________________________________________________________\n");
    printf("gcsort control statements\n");
    printf("Notations: '{name}' = parameters , '|' = Alternative format of control statement\n");
    printf("========================================================================================\n");
    printf("                Section for SORT, MERGE and COPY control statements\n");
    printf("========================================================================================\n");
    printf(" SORT | MERGE | COPY FIELDS Control statement for Sort, Merge, Copy file(s)\n");
    printf("________________________________________________________________________________________\n");
    printf(" USE                 Declare input file(s)\n");
    printf(" GIVE                Declare output file\n");
    printf(" [ SUM FIELDS ]      Sum fields for same record key, or eliminate duplicate keys)\n");
    printf(" [ RECORD     ]      Record control statement \n");
    printf(" [ INCLUDE    ]      Select input records that respect include condition(s)\n");
    printf(" [ OMIT       ]      Omit input records that respect omit condition(s)\n");
    printf(" [ INREC      ]      Reformat input record Before sort, merge or copy operation\n");
    printf(" [ OUTREC     ]      Reformat input record After sort, merge or copy operation\n");
    printf(" [ OUTFIL     ]      Create one or more output files for sort,merge or copy operation \n");
    printf(" [ OPTION     ]      Specifies option for control statements\n");
    printf("________________________________________________________________________________________\n");
    printf("gcsort\n");
    printf("    SORT | MERGE | COPY                                                        \n");
    printf("         FIELDS({Pos},{Len},{FormatType},{Order}, ...)          |              \n");
    printf("         FIELDS({Pos},{Len},{Order}, ...),FORMAT={FormatType}   |              \n");
    printf("         FIELDS=COPY                                                           \n");
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
    printf("    RECORD [TYPE=[{V}(Variable-length)/{F}(Fixed-length)]],[LENGTH=[{len}(L1-Input record length)]\n");
    printf("                                                                ','[{len}(L2-Record length)]\n");
    printf("                                                                ','[{len}(L3-Output record length)]\n");
    printf("    INCLUDE | OMIT\n");
    printf("            COND=({Condition})[,FORMAT={FormatType}]                     \n");
    printf("\n");
    printf("    INREC   FIELDS | INREC   BUILD =({FieldSpec})\n");
    printf("    INREC   OVERLAY =({FieldSpec})\n");
    printf("    OUTREC  FIELDS | OUTREC  BUILD =({FieldSpec})\n");
    printf("    OUTREC  OVERLAY =({FieldSpec}) \n");
    printf(" \n");
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
    printf("         Y2PAST           (YY) - Sliding, (YYYY) century\n");
    printf("         MODS E15=(<name>) [,]     <name>= Name E15 Cobol Program for input\n");
    printf("              E35=(<name>)         <name>= Name E35 Cobol Program for ouput\n");
    printf("========================================================================================\n");
    printf("  Section for JOIN control statement\n");
    printf("========================================================================================\n");
    printf(" JOIN file(s)\n");
    printf("    USE                 Declare input file F1 \n");
    printf("    USE                 Declare input file F2 \n");
    printf("    GIVE                Declare output file\n");
    printf("    JOINKEYS FILES=F1   Declare keys file F1 \n");
    printf("    JOINKEYS FILES=F2   Declare keys file F2 \n");
    printf("    UNPAIRED            Declare join type \n");
    printf("    REFORMAT FIELDS     Declare output format \n");
    printf("    [ INCLUDE    ]      Select input records that respect include condition(s)\n");
    printf("    [ OMIT       ]      Omit input records that respect omit condition(s)\n");
    printf("    [ INREC      ]      Reformat input record before join operation\n");
    printf("    [ OUTREC     ]      Reformat input record after join operation\n");
    printf("    [ OUTFIL     ]      Create one or more output files from join operation \n");
    printf("    [ OPTION     ]      Specifies option for control statements\n");
    printf("________________________________________________________________________________________\n");
    printf("    JOIN                                                         \n");
    printf("    USE  {Filename}             [File F1]\n");
    printf("         ORG {Org}\n");
    printf("         RECORD [F,{RecordLen}] | [V,{MinLen},{MaxLen}] \n");
    printf("                [KEY ({Pos},{Len},{KeyType})]\n");
    printf("\n");
    printf("    USE  {Filename}             [File F2]\n");
    printf("         ORG {Org}\n");
    printf("         RECORD [F,{RecordLen}] | [V,{MinLen},{MaxLen}] \n");
    printf("                [KEY ({Pos},{Len},{KeyType})]\n");
    printf("\n");
    printf("    GIVE same parameters of USE \n");
    printf("\n");
    printf("    JOINKEYS FILES=F1,FIELDS=[({Pos},{Len},{Order}, ...)] \n");
    printf("                             [,SORTED] [,STOPAFT] \n");
    printf("            INCLUDE | OMIT\n");
    printf("                    COND=({Condition})[,FORMAT={FormatType}]                     \n");
    printf("\n");
    printf("    JOINKEYS FILES=F2,FIELDS=[({Pos},{Len},{Order}, ...)] \n");
    printf("                             [,SORTED] [,STOPAFT] \n");
    printf("            INCLUDE | OMIT\n");
    printf("                    COND=({Condition})[,FORMAT={FormatType}]                     \n");
    printf("\n");
    printf("    JOIN UNPAIRED [,F1][,F2][,ONLY]    \n");
    printf("         UNPAIRED,F1,F2 or UNPAIRED    \n");
    printf("             Unpaired records from F1 and F2 as well as paired records (Full outer join).    \n");
    printf("         UNPAIRED,F1    \n");
    printf("             Unpaired records from F1 as well as paired records (Left outer join).    \n");
    printf("         UNPAIRED,F2    \n");
    printf("             Unpaired records from F2 as well as paired records (Right outer join).    \n");
    printf("         UNPAIRED,F1,F2,ONLY or UNPAIRED,ONLY    \n");
    printf("             Unpaired records from F1 and F2.    \n");
    printf("         UNPAIRED,F1,ONLY    \n");
    printf("             Unpaired records from F1.    \n");
    printf("         UNPAIRED,F2,ONLY    \n");
    printf("             Unpaired records from F2.    \n");
    printf("\n");
    printf("    REFORMAT FIELDS=({File}:{Pos},{Len},{?},{File}:{Pos},{Len}.....) [,FILL=[C'constant'] | [X'hh'] \n");
    printf("________________________________________________________________________________________\n");
    printf("___{Parameters}____________________________|___{Parameters}_____________________________\n");
    printf("  {File}     = F1 or F2                    | ? = 1-byte indicator joined record        \n");
    printf("  {Pos}      = Field Position              |    'B' = 'Both' - Key  found in F1 and F2  \n");
    printf("  {Len}      = Field Length                |    '1' = Key found in F1, but not in F2    \n");
    printf("  {Order}    = A(ascending) | D(descending)|    '2' = Key found in F1, but not in F1    \n");
    printf("  C'Constant'= Character fill byte         |                                            \n");
    printf("  X'hh' = Hexadecimal fill byte (00-FF).   |                                            \n");
    printf("________________________________________________________________________________________\n");
    printf("    SUM FIELDS = [({Pos},{Len},{FormatType2}, ...)]         |\n");
    printf("                 [({Pos},{Len}, ...)],FORMAT={FormatType2}  |\n");
    printf("                 [NONE] | [(NONE)]\n");
    printf("\n");
    printf("    INCLUDE | OMIT\n");
    printf("            COND=({Condition})[,FORMAT={FormatType}]                     \n");
    printf("\n");
    printf("    INREC   FIELDS | INREC   BUILD =({FieldSpec})\n");
    printf("    INREC   OVERLAY =({FieldSpec})\n");
    printf("    OUTREC  FIELDS | OUTREC  BUILD =({FieldSpec})\n");
    printf("    OUTREC  OVERLAY =({FieldSpec}) \n");
    printf(" \n");
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
    printf("  Format 4  - ( Pos,Len,{FormatType},{Relational}, [DATE1][(+/-)num] | [DATE2][(+/-)num]\n");
    printf("                                                   [DATE3][(+/-)num] | [DATE4][(+/-)num]\n");
    printf("       DATE - Currente Date : DATE1 (C'yyyymmdd'), DATE2 (C'yyyymm'),                   \n");
    printf("                              DATE3 (C'yyyyddd'),  DATE4 (C'yyyy-mm-dd') (no Timestamp) \n");
    printf("       [(+/-)num]  [+num] future date, [-num] past date) only for DATE1,DATE2,DATE3     \n");
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
    printf("_Format_Len_Type__Date field_______________|_Format_Len_Type__Date field________________\n");
    printf("  Y2T = 8   ZD    CCYYMMDD                 |  Y2D = 1   PD    YY                        \n");
    printf("  Y2T = 4   ZD    YYXX                     |  Y2P = 2   PD    YY                        \n");
    printf("  Y2T = 2   ZD    YYX                      |  Y2U = 3   PD    YYDDD                     \n");
    printf("  Y2T = 3   ZD    YY                       |  Y2S = 2   ZD    YY                        \n");
    printf("  Y2T = 5   ZD    YYDDD                    |  Y2V = 4   PD    YYMMDD                    \n");
    printf("  Y2T = 6   ZD    YYMMDD                   |  Y2X = 3   PD    DDDYY                     \n");
    printf("  Y2B = 1   BI    YY                       |  Y2Y = 4   PD    MMDDYY                    \n");
    printf("  Y2C = 2   ZD    YY                       |  Y2Z = 2   ZD    YY                        \n");
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
    printf("  CHANGE=(vlen,[C | X]'<valueFind>',[C | X]'<valueSet>',.....),NOMATCH=([C | X]'<valueSet>)    \n");
    printf("  CHANGE=(vlen,[C | X]'<valueFind>', posIn, lenIn), NOMATCH = (posIn, posLen)\n");
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
    return;
}
void gcsort_help_header(void) {
    printf("________________________________________________________________________________________\n");
    printf(" gcsort help\n");
    printf(" gcsort is a utility to sort, merge, copy and join records in a file into a \n");
    printf("   specified order in GnuCOBOL environment.\n");
    printf("________________________________________________________________________________________\n");
    return;
}
void gcsort_help_header2(void) {
    printf(" Syntax case insensitive                                                         \n");
    printf(" Return code : 0 (ok) - 4 (warning) - 16 (error)                                 \n");
    printf("________________________________________________________________________________________\n");
    printf("Usage with file parameters  : gcsort <options> take filename   \n");
    printf("Usage from command line     : gcsort <options> <control statements> \n");
    printf("________________________________________________________________________________________\n");
    printf("gcsort options\n");
    printf("-fsign=[ASCII|EBCDIC] define display sign representation\n");
#if __LIBCOB_RELEASE >= 30200
    printf("-fcolseq=[NATIVE|ASCII|EBCDIC] collating sequence to use\n");
    printf("-febcdic-table=[DEFAULT|IBM|GCOS] EBCDIC table to use\n");
#endif /* __LIBCOB_RELEASE >= 30200 */
    printf("________________________________________________________________________________________\n");
    return;
}
void gcsort_help_body_SMC(void) {
    printf("gcsort control statements\n");
    printf("Notations: '{name}' = parameters , '|' = Alternative format of control statement\n");
    printf("========================================================================================\n");
    printf("                Section for SORT, MERGE and COPY control statements\n");
    printf("========================================================================================\n");
    printf(" SORT | MERGE | COPY FIELDS Control statement for Sort, Merge, Copy file(s)\n");
    printf("________________________________________________________________________________________\n");
    printf(" USE                 Declare input file(s)\n");
    printf(" GIVE                Declare output file\n");
    printf(" [ SUM FIELDS ]      Sum fields for same record key, or eliminate duplicate keys)\n");
    printf(" [ RECORD     ]      Record control statement \n");
    printf(" [ INCLUDE    ]      Select input records that respect include condition(s)\n");
    printf(" [ OMIT       ]      Omit input records that respect omit condition(s)\n");
    printf(" [ INREC      ]      Reformat input record Before sort, merge or copy operation\n");
    printf(" [ OUTREC     ]      Reformat input record After sort, merge or copy operation\n");
    printf(" [ OUTFIL     ]      Create one or more output files for sort,merge or copy operation \n");
    printf(" [ OPTION     ]      Specifies option for control statements\n");
    printf("________________________________________________________________________________________\n");
    printf("gcsort\n");
    printf("    SORT | MERGE | COPY                                                        \n");
    printf("         FIELDS({Pos},{Len},{FormatType},{Order}, ...)          |              \n");
    printf("         FIELDS({Pos},{Len},{Order}, ...),FORMAT={FormatType}   |              \n");
    printf("         FIELDS=COPY                                                           \n");
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
    printf("    RECORD [TYPE=[{V}(Variable-length)/{F}(Fixed-length)]],[LENGTH=[{len}(L1-Input record length)]\n");
    printf("                                                                ','[{len}(L2-Record length)]\n");
    printf("                                                                ','[{len}(L3-Output record length)]\n");
    printf("    INCLUDE | OMIT\n");
    printf("            COND=({Condition})[,FORMAT={FormatType}]                     \n");
    printf("\n");
    printf("    INREC   FIELDS | INREC   BUILD =({FieldSpec})\n");
    printf("    INREC   OVERLAY =({FieldSpec})\n");
    printf("    OUTREC  FIELDS | OUTREC  BUILD =({FieldSpec})\n");
    printf("    OUTREC  OVERLAY =({FieldSpec}) \n");
    printf(" \n");
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
    printf("         Y2PAST           (YY) - Sliding, (YYYY) century\n");
    printf("         MODS E15=(<name>) [,]     <name>= Name E15 Cobol Program for input\n");
    printf("              E35=(<name>)         <name>= Name E35 Cobol Program for ouput\n");
    printf("    SUM FIELDS = [({Pos},{Len},{FormatType2}, ...)]         |\n");
    printf("                 [({Pos},{Len}, ...)],FORMAT={FormatType2}  |\n");
    printf("                 [NONE] | [(NONE)]\n");
    printf("\n");
    printf("    INCLUDE | OMIT\n");
    printf("            COND=({Condition})[,FORMAT={FormatType}]                     \n");
    printf("\n");
    printf("    INREC   FIELDS =({FieldSpec})   | INREC   BUILD =({FieldSpec})\n");
    printf("    INREC   OVERLAY =({FieldSpec})  | INREC   FINDREP =({FindRepSpec}) \n");
    printf("    OUTREC  FIELDS =({FieldSpec})   | OUTREC  BUILD =({FieldSpec})\n");
    printf("    OUTREC  OVERLAY =({FieldSpec})  | OUTREC  FINDREP =({FindRepSpec}) \n");
    printf(" \n");
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
    printf("  Format 4  - ( Pos,Len,{FormatType},{Relational}, [DATE1][(+/-)num] | [DATE2][(+/-)num]\n");
    printf("                                                   [DATE3][(+/-)num] | [DATE4][(+/-)num]\n");
    printf("       DATE - Currente Date : DATE1 (C'yyyymmdd'), DATE2 (C'yyyymm'),                   \n");
    printf("                              DATE3 (C'yyyyddd'),  DATE4 (C'yyyy-mm-dd') (no Timestamp) \n");
    printf("       [(+/-)num]  [+num] future date, [-num] past date) only for DATE1,DATE2,DATE3     \n");
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
    printf("_Format_Len_Type__Date field_______________|_Format_Len_Type__Date field________________\n");
    printf("  Y2T = 8   ZD    CCYYMMDD                 |  Y2D = 1   PD    YY                        \n");
    printf("  Y2T = 4   ZD    YYXX                     |  Y2P = 2   PD    YY                        \n");
    printf("  Y2T = 2   ZD    YYX                      |  Y2U = 3   PD    YYDDD                     \n");
    printf("  Y2T = 3   ZD    YY                       |  Y2S = 2   ZD    YY                        \n");
    printf("  Y2T = 5   ZD    YYDDD                    |  Y2V = 4   PD    YYMMDD                    \n");
    printf("  Y2T = 6   ZD    YYMMDD                   |  Y2X = 3   PD    DDDYY                     \n");
    printf("  Y2B = 1   BI    YY                       |  Y2Y = 4   PD    MMDDYY                    \n");
    printf("  Y2C = 2   ZD    YY                       |  Y2Z = 2   ZD    YY                        \n");
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
    printf("  CHANGE=(vlen,[C | X]'<valueFind>',[C | X]'<valueSet>',.....),NOMATCH=([C | X]'<valueSet>)    \n");
    printf("  CHANGE=(vlen,[C | X]'<valueFind>', posIn, lenIn), NOMATCH = (posIn, posLen)\n");
    printf("________________________________________________________________________________________\n");
    printf("____{FindRepSpec}___Field Find/Replace Specification____________________________________\n");
    printf("  IN=C'constant' , OUT=C'constant'                      constant character value. \n");
    printf("  IN=(C'constant', C'constant' ....) , OUT=C'constant'  constant character value. \n");
    printf("  INOUT=(C'constantIn', C'constantOut' , C'constantIn', C'constantOut', ....) \n");
    printf("  STARTPOS=pos        pos = Start Position to find/replace\n");
    printf("  ENDPOS=pos          pos = End Position to find/replace\n");
    printf("  DO=n                n=Maximum number of times find and replace \n");
    printf("  MAXLEN=n            n=Maximum len of record n\n");
    printf("  OVERRUN=TRUNC|ERROR Truncate or Error(Default) for overrun\n");
    printf("  SHIFT=YES|NO        Shift data or no (default) when different length between find replace\n");
    printf("________________________________________________________________________________________\n");
    return;
}
void gcsort_help_body_JOIN(void) {
    printf("========================================================================================\n");
    printf("  Section for JOIN control statement\n");
    printf("========================================================================================\n");
    printf(" JOIN file(s)\n");
    printf("    USE                 Declare input file F1 \n");
    printf("    USE                 Declare input file F2 \n");
    printf("    GIVE                Declare output file\n");
    printf("    JOINKEYS FILES=F1.. Declare keys file F1 \n");
    printf("        [ INCLUDE]  Input file F1 - Select input records that respect include condition(s)\n");
    printf("        [ OMIT   ]  Input file F1 - Omit input records that respect omit condition(s)\n");
  /*  printf("        [ INREC  ]  Input file F1 - Reformat input record before join operation\n");  */
    printf("    JOINKEYS FILES=F2.. Declare keys file F2 \n");
    printf("        [ INCLUDE]  Input file F2 - Select input records that respect include condition(s)\n");
    printf("        [ OMIT   ]  Input file F2 - Omit input records that respect omit condition(s)\n");
  /*  printf("        [ INREC  ]  Input file F2 - Reformat input record before join operation\n");  */
    printf("    UNPAIRED            Declare join type \n");
    printf("    REFORMAT FIELDS     Declare output format \n");
    printf("    [ INCLUDE]      Output file - Select input records that respect include condition(s)\n");
    printf("    [ OMIT   ]      Output file - Omit input records that respect omit condition(s)\n");
    printf("    [ INREC  ]      Output file - Reformat input record before join operation\n");
  /*  printf("    [ OUTREC ]      Output file - Reformat input record after join operation\n"); */
    printf("    [ OUTFIL ]      Output file - Create one or more output files from join operation \n");
    printf("________________________________________________________________________________________\n");
    printf("    JOIN                                                         \n");
    printf("    USE  {Filename}             [File F1]\n");
    printf("         ORG {Org}\n");
    printf("         RECORD [F,{RecordLen}] | [V,{MinLen},{MaxLen}] \n");
    printf("                [KEY ({Pos},{Len},{KeyType})]\n");
    printf("\n");
    printf("    USE  {Filename}             [File F2]\n");
    printf("         ORG {Org}\n");
    printf("         RECORD [F,{RecordLen}] | [V,{MinLen},{MaxLen}] \n");
    printf("                [KEY ({Pos},{Len},{KeyType})]\n");
    printf("\n");
    printf("    GIVE same parameters of USE \n");
    printf("\n");
    printf("    JOINKEYS FILES=F1,FIELDS=[({Pos},{Len},{Order}, ...)] \n");
    printf("                             [,SORTED] [,STOPAFT={nn]] \n");
    printf("           [, INCLUDE ] | [, OMIT]\n");
    printf("                   [ COND=({Condition})[,FORMAT={FormatType}] ]                    \n");
    printf("\n");
    printf("    JOINKEYS FILES=F2,FIELDS=[({Pos},{Len},{Order}, ...)] \n");
    printf("                             [,SORTED] [,STOPAFT={nn]] \n");
    printf("           [, INCLUDE ] | [, OMIT]\n");
    printf("                   [ COND=({Condition})[,FORMAT={FormatType}] ]                   \n");
    printf("\n");
    printf("    JOIN UNPAIRED [,F1][,F2][,ONLY]    \n");
    printf("         UNPAIRED,F1,F2 or UNPAIRED    \n");
    printf("             Unpaired records from F1 and F2 as well as paired records (Full outer join).    \n");
    printf("         UNPAIRED,F1    \n");
    printf("             Unpaired records from F1 as well as paired records (Left outer join).    \n");
    printf("         UNPAIRED,F2    \n");
    printf("             Unpaired records from F2 as well as paired records (Right outer join).    \n");
    printf("         UNPAIRED,F1,F2,ONLY or UNPAIRED,ONLY    \n");
    printf("             Unpaired records from F1 and F2.    \n");
    printf("         UNPAIRED,F1,ONLY    \n");
    printf("             Unpaired records from F1.    \n");
    printf("         UNPAIRED,F2,ONLY    \n");
    printf("             Unpaired records from F2.    \n");
    printf("\n");
    printf("    REFORMAT FIELDS=({File}:{Pos},{Len},{?},{File}:{Pos},{Len}.....) [,FILL=[C'constant'] | [X'hh'] \n");
   /* printf("    SUM FIELDS = [({Pos},{Len},{FormatType2}, ...)]         |\n");    */
   /* printf("                 [({Pos},{Len}, ...)],FORMAT={FormatType2}  |\n");    */
   /* printf("                 [NONE] | [(NONE)]\n");                               */
   /* printf("\n");                                                                 */
    printf("______Commands for output file__________________________________________________________\n");
    printf("    INCLUDE | OMIT\n");
    printf("            COND=({Condition})[,FORMAT={FormatType}]                     \n");
    printf("\n");
    printf("    INREC   FIELDS | INREC   BUILD =({FieldSpec})\n");
    printf("    INREC   OVERLAY =({FieldSpec})\n");
    printf("    OUTREC  FIELDS | OUTREC  BUILD =({FieldSpec})\n");
    printf("    OUTREC  OVERLAY =({FieldSpec}) \n");
    printf(" \n");
    printf("    OUTFIL                                                                         \n");
    printf("         INCLUDE | OMIT ({Condition})[,FORMAT={FormatType}]                            \n");
    printf("         OUTREC BUILD | BUILD = ({FieldSpec})                                                   \n");
    printf("         FILES/FNAMES= {Filename}  \n");
    /* printf("         FILES/FNAMES= {Filename}  | (file1, file2, file3,...) \n"); */
   /* printf("         STARTREC={nn}    Start from record nn                                     \n");  */
   /* printf("         ENDREC={nn}      Skip record after nn                                      \n"); */
   /* printf("         SAVE                            \n");    */
   /* printf("         SPLIT            Split 1 record  output for file group (file1, file2, file3,...)  \n"); */
   /* printf("         SPLITBY={nn}     Split n records output for file group (file1, file2, file3,...)  \n"); */
    printf("\n");
    printf("________________________________________________________________________________________\n");
    printf("___{Parameters}____________________________|___{Parameters}_____________________________\n");
    printf("  {File}     = F1 or F2                    | ? = 1-byte indicator joined record        \n");
    printf("  {Pos}      = Field Position              |    'B' = 'Both' - Key  found in F1 and F2  \n");
    printf("  {Len}      = Field Length                |    '1' = Key found in F1, but not in F2    \n");
    printf("  {Order}    = A(ascending) | D(descending)|    '2' = Key found in F1, but not in F1    \n");
    printf("  C'Constant'= Character fill byte         |     nn = Numbers of records from input file\n");
    printf("  X'hh' = Hexadecimal fill byte (00-FF).   |                                            \n");
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
    printf("  Format 4  - ( Pos,Len,{FormatType},{Relational}, [DATE1][(+/-)num] | [DATE2][(+/-)num]\n");
    printf("                                                   [DATE3][(+/-)num] | [DATE4][(+/-)num]\n");
    printf("       DATE - Currente Date : DATE1 (C'yyyymmdd'), DATE2 (C'yyyymm'),                   \n");
    printf("                              DATE3 (C'yyyyddd'),  DATE4 (C'yyyy-mm-dd') (no Timestamp) \n");
    printf("       [(+/-)num]  [+num] future date, [-num] past date) only for DATE1,DATE2,DATE3     \n");
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
    printf("_Format_Len_Type__Date field_______________|_Format_Len_Type__Date field________________\n");
    printf("  Y2T = 8   ZD    CCYYMMDD                 |  Y2D = 1   PD    YY                        \n");
    printf("  Y2T = 4   ZD    YYXX                     |  Y2P = 2   PD    YY                        \n");
    printf("  Y2T = 2   ZD    YYX                      |  Y2U = 3   PD    YYDDD                     \n");
    printf("  Y2T = 3   ZD    YY                       |  Y2S = 2   ZD    YY                        \n");
    printf("  Y2T = 5   ZD    YYDDD                    |  Y2V = 4   PD    YYMMDD                    \n");
    printf("  Y2T = 6   ZD    YYMMDD                   |  Y2X = 3   PD    DDDYY                     \n");
    printf("  Y2B = 1   BI    YY                       |  Y2Y = 4   PD    MMDDYY                    \n");
    printf("  Y2C = 2   ZD    YY                       |  Y2Z = 2   ZD    YY                        \n");
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
    printf("  CHANGE=(vlen,[C | X]'<valueFind>',[C | X]'<valueSet>',.....),NOMATCH=([C | X]'<valueSet>)    \n");
    printf("  CHANGE=(vlen,[C | X]'<valueFind>', posIn, lenIn), NOMATCH = (posIn, posLen)\n");
    return;
}
void gcsort_help_footer(void) {
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
    return;
}
