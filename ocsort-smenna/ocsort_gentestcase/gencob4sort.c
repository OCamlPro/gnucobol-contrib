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
#include "gencob4sort.h"

int generate_CobfileSortFile ( struct params_t* params, struct key_t** pKey ) {

	FILE* pFile;
	char* pBuf;
	int i, n, nPosAbs;
	char szszTakeFile[FILENAME_MAX];

	strcpy(szszTakeFile, params->PathSrc);
	strcat(szszTakeFile, params->PgmCheckSort);
	strcat(szszTakeFile, ".cbl");

	pBuf = (char*) malloc(MAX_RECORD+2);
	memset(pBuf, 0x20, params->nLenMax);

	pFile=fopen(szszTakeFile, "w");

	if (pFile==NULL){
		fprintf(stderr,"*  *S002* Cannot open file %s : %s\n",szszTakeFile,strerror(errno));
		return -1;
	}

	fprintf(stdout,"Cobol Program check data sorted from OCSort\n");
	fprintf(stdout,"%s\n", szszTakeFile);
	fprintf(stdout,"------------------------------------------------------------------------------\n");

	

	write_line(pFile, (char*) "999999 IDENTIFICATION DIVISION.\n");

	sprintf((char*) pBuf, "999999 PROGRAM-ID. %s.\n", params->PgmCheckSort);
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
//
	write_line(pFile, (char*) "999999 01   WK-MasterSeqRecord-F.\n");
	nPosAbs = 1;
	for (i=0; i <= params->nMaxFields; i++) {
		if (nPosAbs < pKey[i]->pos) {
			if ((pKey[i]->pos - nPosAbs) > 1)
				sprintf((char*) pBuf, "999999       03   WK-FILLER-%05d          PIC  X(%05d).\n", nPosAbs, (pKey[i]->pos - nPosAbs));
			else
				sprintf((char*) pBuf, "999999       03   WK-FILLER-%05d          PIC  X.\n", nPosAbs);
			write_line(pFile, (char*) pBuf);
			nPosAbs = nPosAbs + (pKey[i]->pos - nPosAbs);
		}

// special fields
		if (strcmp(pKey[i]->type, "PR") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC S9(%05d).\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, pKey[i]->len);
			else
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC  9.\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}
		if (strcmp(pKey[i]->type, "FX") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC  X(%05d).\n", 
												         pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, pKey[i]->len);
			else
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC  X.\n", 
													 	 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}

// standard field
		if (strcmp(pKey[i]->type, "CH") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC  X(%05d).\n",		
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, pKey[i]->len);
			else
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC  X.\n", 
				                                         pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}
		if (strcmp(pKey[i]->type, "ZD") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC S9(%05d).\n", 
				                                         pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, pKey[i]->len);
			else
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC  9.\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}
		if (strcmp(pKey[i]->type, "BI") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC  9(%05d) COMP.\n", 
				                                         pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, pKey[i]->len*2);
			else
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC  9 COMP.\n", 
				                                         pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}
		if (strcmp(pKey[i]->type, "FI") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC S9(%05d) COMP.\n", 
				                                         pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, pKey[i]->len*2);
			else
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC S9 COMP.\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}
		if (strcmp(pKey[i]->type, "PD") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC S9(%05d) COMP-3.\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, (pKey[i]->len*2)-1);
			else
				sprintf((char*) pBuf, "999999       03   WK-F-%s-%05d-%05d-%s      PIC  9 COMP-3.\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}

		nPosAbs = nPosAbs  + (pKey[i]->len);
	}

	//if (strcmp(params->szRec, "F") == 0) {
		if (nPosAbs < params->nLenMax) {
			sprintf((char*) pBuf, "999999       03   WK-FILLER-%05d           PIC  X(%05d).\n", params->nLenMax, (params->nLenMax - nPosAbs + 1));
			write_line(pFile, (char*) pBuf);
		}
	//}
//
	write_line(pFile, (char*) "999999 77   wk-field-error      PIC X(20).\n");
	write_line(pFile, (char*) "999999 77   numrecords		   PIC 9(15) VALUE ZERO.\n");
	write_line(pFile, (char*) "999999 77   segment-01          PIC 9(15) VALUE ZERO.\n");
	write_line(pFile, (char*) "999999 77   segment-02          PIC 9(15) VALUE ZERO.\n");
	write_line(pFile, (char*) "999999*\n");
	write_line(pFile, (char*) "999999* ************************* Procedure \n");
    write_line(pFile, (char*) "999999 PROCEDURE DIVISION.\n");
    write_line(pFile, (char*) "999999 Begin-Procedure.\n");
	sprintf((char*) pBuf,     "999999     display \"Start Program %s \".\n", params->PgmCheckSort);
	write_line(pFile, (char*) pBuf);
    write_line(pFile, (char*) "999999     display \"Check data file sorted by OCSort.\"\n");
    write_line(pFile, (char*) "999999     open input FGENFILE.\n");
    write_line(pFile, (char*) "999999     read FGENFILE at end go to Read-End.\n");
    write_line(pFile, (char*) "999999     add 1  to numrecords.\n");
	write_line(pFile, (char*) "999999     move MasterSeqRecord-F to WK-MasterSeqRecord-F.\n");
    write_line(pFile, (char*) "999999 Read-Again-00.\n");
    write_line(pFile, (char*) "999999     read FGENFILE at end go to Read-End.\n");
    write_line(pFile, (char*) "999999     add 1  to numrecords.\n");
    write_line(pFile, (char*) "999999     divide numrecords by 100000 giving segment-02\n"); 
    write_line(pFile, (char*) "999999     		remainder segment-01.\n");
    write_line(pFile, (char*) "999999     if (segment-01 = ZERO)\n");
    write_line(pFile, (char*) "999999        display \"Readed \" numrecords.\n");
	//
	n=1;
	i=0;
	do {
		if (pKey[i]->iskey == 1) {
			if (pKey[i]->seqkey == n) {

				sprintf((char*) pBuf, "999999** Check Field F-%s-%05d-%05d-%s \n", pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
				write_line(pFile, (char*) pBuf);

				if (strcmp(pKey[i]->order, "D") == 0) {	// Descending
					write_line(pFile, (char*) "999999*  Field sort Descending\n");
					sprintf((char*) pBuf, "999999     if (F-%s-%05d-%05d-%s > WK-F-%s-%05d-%05d-%s)\n", 
															pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order,
															pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
				}
				else
				{
					write_line(pFile, (char*) "999999*  Field sort Ascending\n");
					sprintf((char*) pBuf,         "999999     if (F-%s-%05d-%05d-%s < WK-F-%s-%05d-%05d-%s)\n", 
																  pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order,
																  pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
				}
				write_line(pFile, (char*) pBuf);
				sprintf((char*) pBuf,             "999999           move \"F-%s-%05d-%05d-%s\" to wk-field-error \n", 
																	     pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
				if (strcmp(pKey[i]->order, "D") == 0) 	// Descending
						write_line(pFile, (char*) "999999                 display \" Error Field NOT Descending order \"\n");
				else
						write_line(pFile, (char*) "999999                 display \" Error Field NOT Ascending order \"\n");
				write_line(pFile, (char*) pBuf);
				write_line(pFile, (char*) "999999              go Error-Sort.\n");

				if (strcmp(pKey[i]->order, "D") == 0) {	// Descending
					write_line(pFile, (char*) "999999*  Field sort Descending\n");
					sprintf((char*) pBuf, "999999     if (F-%s-%05d-%05d-%s < WK-F-%s-%05d-%05d-%s)\n",
															pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order,
															pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
				}
				else
				{
					write_line(pFile, (char*) "999999*  Field sort Ascending\n");
					sprintf((char*) pBuf, "999999     if (F-%s-%05d-%05d-%s > WK-F-%s-%05d-%05d-%s)\n", 
						                                  pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order,
														  pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
				}
				write_line(pFile, (char*) pBuf);
				write_line(pFile, (char*) "999999            move MasterSeqRecord-F to WK-MasterSeqRecord-F\n");
				write_line(pFile, (char*) "999999                    go Read-Again-00.\n");

				n++;
			}
		}
		i++;
		if (i > params->nMaxFields)
			i=0;
	} while (n <= params->nNumKeys);
	//
	write_line(pFile, (char*) "999999     move MasterSeqRecord-F to WK-MasterSeqRecord-F.\n");
	write_line(pFile, (char*) "999999     go Read-Again-00.\n");
	write_line(pFile, (char*) "999999 Error-Sort.\n");
	write_line(pFile, (char*) "999999     display \"Error sort order \"\n");
	write_line(pFile, (char*) "999999     display \"Field error :  \" wk-field-error\n");
	write_line(pFile, (char*) "999999     display \"Keys for current and previous record \"\n");
	write_line(pFile, (char*) "999999     display \"================================== \"\n");
	n=1;
	do {
		if (pKey[i]->iskey == 1) {
			if (pKey[i]->seqkey == n) {
				write_line(pFile, (char*) "999999     display \n");
					sprintf((char*) pBuf, "999999     \"   F-%s-%05d-%05d-%s = \"     F-%s-%05d-%05d-%s\n", 
														   pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order,
														   pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
					write_line(pFile, (char*) pBuf);
				write_line(pFile, (char*) "999999     display \n");
					sprintf((char*) pBuf, "999999     \"WK-F-%s-%05d-%05d-%s = \"  WK-F-%s-%05d-%05d-%s\n", 
														   pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, 
														   pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
					write_line(pFile, (char*) pBuf);
					write_line(pFile, (char*) "999999     display \"================================== \"\n");
				n++;
			}
		}
		i++;
		if (i > params->nMaxFields)
			i=0;
	} while (n <= params->nNumKeys);

	//



	write_line(pFile, (char*) "999999     display \"Number records read : \" NUMRECORDS.\n");
	write_line(pFile, (char*) "999999     go End-Close.\n");
	write_line(pFile, (char*) "999999 Read-End.\n");
	write_line(pFile, (char*) "999999     display  \"SORT  OK \".\n");
	write_line(pFile, (char*) "999999     display  \" Total records : \" NUMRECORDS.\n");
	write_line(pFile, (char*) "999999 End-Close.\n");
	write_line(pFile, (char*) "999999     close FGENFILE.      \n");
    write_line(pFile, (char*) "999999 Begin-Procedure.\n");
	sprintf((char*) pBuf, "999999     display \"End Program %s \".\n", params->PgmCheckSort);
	write_line(pFile, (char*) pBuf);
	write_line(pFile, (char*) "999999 End-Procedure.\n");
	write_line(pFile, (char*) "999999     goback.\n");

	fclose(pFile);

	free(pBuf);

	return 0;
}
