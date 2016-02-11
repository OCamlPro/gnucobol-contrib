/*
 *  Copyright (C) 2016 Sauro Menna
 *
 *	This file is part of ocsortgentestcase.
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
//
// #ifdef _WIN32
#if defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	#include <Windows.h>
#else
	#include <unistd.h>
	#include <sys/mman.h>
	#include <math.h>
	#include <stdlib.h>
	#include <sys/types.h>
	#include <sys/stat.h>
	#include <fcntl.h>
	#include <errno.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h> 
#include <stdint.h>

#include "ocsort_gentestcase.h"
#include "gencob4check.h"
int generate_CobfileCheckFile ( struct params_t* params, struct key_t** pKey ) {

	FILE* pFile;
	char* pBuf;
	int i,nPosAbs;
	char szszTakeFile[FILENAME_MAX];

	strcpy(szszTakeFile, params->PathSrc);
	strcat(szszTakeFile, params->PgmCheckData);
	strcat(szszTakeFile, ".cbl");

	pBuf = (char*) malloc(MAX_RECORD+2);
	memset(pBuf, 0x20, params->nLenMax);

	pFile=fopen(szszTakeFile, "w");

	if (pFile==NULL){
		fprintf(stderr,"*  *S001* Cannot open file %s : %s\n",szszTakeFile,strerror(errno));
		return -1;
	}

	fprintf(stdout,"Cobol Program check data created\n");
	fprintf(stdout,"%s\n", szszTakeFile);
	fprintf(stdout,"------------------------------------------------------------------------------\n");



	write_line(pFile, (char*) "999999 IDENTIFICATION DIVISION.\n");

	sprintf((char*) pBuf, "999999 PROGRAM-ID. %s.\n", params->PgmCheckData);
	write_line(pFile, (char*) pBuf);
	write_line(pFile, (char*) "999999 ENVIRONMENT DIVISION.\n");
	write_line(pFile, (char*) "999999 INPUT-OUTPUT SECTION.\n");
	write_line(pFile, (char*) "999999 FILE-CONTROL.\n");
	write_line(pFile, (char*) "999999* ************************* Select \n");

	sprintf((char*) pBuf, "999999      SELECT FGENFILE	ASSIGN TO 'FGENFILE'\n");
	write_line(pFile, (char*) pBuf);
	

	if (strcmp(params->szOrg, "LS") == 0)
		write_line(pFile, (char*) "999999            ORGANIZATION IS LINE SEQUENTIAL\n");
	else
		write_line(pFile, (char*) "999999            ORGANIZATION IS SEQUENTIAL\n");

	write_line(pFile, (char*) "999999            ACCESS MODE  IS SEQUENTIAL.\n");

	write_line(pFile, (char*) "999999 DATA DIVISION.\n");
	write_line(pFile, (char*) "999999 FILE SECTION.\n");
	write_line(pFile, (char*) "999999* ************************* Fd \n");
	write_line(pFile, (char*) "999999      FD FGENFILE	\n");

	if (strcmp(params->szRec, "F") == 0) {
		write_line(pFile, (char*) "999999           RECORDING MODE IS F.\n");
	}
	else
	{
		write_line(pFile, (char*) "999999           RECORDING MODE IS V\n");
		sprintf((char*) pBuf, "999999           RECORD IS VARYING IN SIZE FROM %05d TO %05d\n", params->nLenMin, params->nLenMax);
		write_line(pFile, (char*) pBuf);
		write_line(pFile, (char*) "999999           DEPENDING ON recordsize.\n");
	}

	write_line(pFile, (char*) "999999 01   MasterSeqRecord-F.\n");
	nPosAbs = 1;

#include "genrows.hpp"

	write_line(pFile, (char*) "999999* ************************* Working \n");
    write_line(pFile, (char*) "999999 WORKING-STORAGE SECTION.\n");
	write_line(pFile, (char*) "999999*\n");
	sprintf((char*) pBuf, "999999 77   recordsize     PIC 9(10) COMP.\n");
	write_line(pFile, (char*) pBuf);
	write_line(pFile, (char*) "999999 77   numrecords		   PIC 9(15) VALUE ZERO.\n");
	write_line(pFile, (char*) "999999 77   segment-01          PIC 9(15) VALUE ZERO.\n");
	write_line(pFile, (char*) "999999 77   segment-02          PIC 9(15) VALUE ZERO.\n");
	write_line(pFile, (char*) "999999*\n");
	write_line(pFile, (char*) "999999* ************************* Procedure \n");
    write_line(pFile, (char*) "999999 PROCEDURE DIVISION.\n");
    write_line(pFile, (char*) "999999 Begin-Procedure.\n");
    sprintf((char*) pBuf,     "999999     display \"Start Program %s \".\n", params->PgmCheckData);
	write_line(pFile, (char*) pBuf);
    write_line(pFile, (char*) "999999     display \"Check data file created by ocsort_gentestcase\"\n");
    write_line(pFile, (char*) "999999     open input FGENFILE.\n");
    write_line(pFile, (char*) "999999 Read-Again-00.\n");
    write_line(pFile, (char*) "999999     read FGENFILE at end go to Read-End.\n");
    write_line(pFile, (char*) "999999     add 1  to numrecords.\n");
    write_line(pFile, (char*) "999999     divide numrecords by 100000 giving segment-02\n"); 
    write_line(pFile, (char*) "999999     		remainder segment-01.\n");
    write_line(pFile, (char*) "999999     if (segment-01 = ZERO)\n");
    write_line(pFile, (char*) "999999        display \"Readed \" numrecords.\n");
	write_line(pFile, (char*) "999999     go Read-Again-00.\n");
	write_line(pFile, (char*) "999999 Read-End.\n");
	write_line(pFile, (char*) "999999     close FGENFILE.      \n");
	write_line(pFile, (char*) "999999     display  \" Total records : \" NUMRECORDS.\n");
    sprintf((char*) pBuf, "999999     display \"End Program %s \".\n", params->PgmCheckData);
	write_line(pFile, (char*) pBuf);
	write_line(pFile, (char*) "999999 End-Procedure.\n");
	write_line(pFile, (char*) "999999     goback.\n");

	fclose(pFile);

	free(pBuf);

	return 0;
}
