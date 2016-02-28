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
#include "gencfg.h"
#include "genscript.h"


int gen_script_linux (struct params_t* params, struct key_t** pKey ) 
{
	FILE* pFile;
	char* pBuf;
	int i, n;
	char szFile[FILENAME_MAX];
	char mode[] = "0776";

	strcpy(szFile, params->PathBatsh);
	strcat(szFile, params->ScriptName);
	strcat(szFile, ".sh");

	pBuf = (char*) malloc(MAX_RECORD+2);
	memset(pBuf, 0x20, params->nLenMax);

	pFile=fopen(szFile, "w");
	if (pFile==NULL){
		fprintf(stderr,"*  *S003* Cannot open file %s : %s\n",szFile,strerror(errno));
		return -1;
	}

	fprintf(stdout,"Script for execution Linux\n");
	fprintf(stdout,"%s\n", szFile);
	fprintf(stdout,"------------------------------------------------------------------------------\n");

	write_line(pFile, (char*)"## * ----------------------------------------------------------------------------\n");
	write_line(pFile, (char*)"## * File generated from ocsort_gentestcase\n");
	write_line(pFile, (char*)"## * ----------------------------------------------------------------------------\n");
	sprintf((char*) pBuf,  (char*)"## * pathgen     =%s\n",	params->PathGen);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf,  (char*)"## * filename    =%s\n",	params->szFileName);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf,  (char*)"## * organization=%s\n",	params->szOrg);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf,  (char*)"## * record      =%s\n",	params->szRec);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf,  (char*)"## * lenmin      =%05d\n",	params->nLenMin);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf,  (char*)"## * lenmax      =%05d\n",	params->nLenMax);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf,  (char*)"## * numrec      =%05lu\n",	params->nNumRec);
	write_line(pFile, (char*) pBuf);
	write_line(pFile, (char*)"## * ----------------------------------------------------------------------------\n");

	for (i=0; i <= params->nMaxFields; i++) {
		//sprintf((char*) pBuf, (char*)  "##  * Field : %05d - Pos=%05d, Len=%05d, Type=%s, IsKey=%d, KeySequence=%d\n", i+1, pKey[i]->pos, pKey[i]->len, pKey[i]->type, pKey[i]->iskey, pKey[i]->seqkey);
		sprintf((char*) pBuf, (char*)  "##  * Field : %05d - Pos=%05d, Len=%05d, Type=%s", i+1, pKey[i]->pos, pKey[i]->len, pKey[i]->type);
		write_line(pFile, (char*) pBuf);
		if ( pKey[i]->iskey == 1)
			sprintf((char*) pBuf, (char*)  ", Order=%s, KeySequence=%d\n", pKey[i]->order, pKey[i]->seqkey);
		else
			sprintf(pBuf, "\n");
		write_line(pFile, (char*) pBuf);
	}
	write_line(pFile, (char*) "## * ----------------------------------------------------------------------------\n");
	write_line(pFile, (char*) "## *                             Key definition\n");



	if (params->nNumKeys > 0) {
		n=1;
		i=0;
		do {
			if (pKey[i]->iskey == 1) {
				if (pKey[i]->seqkey == n) {
					sprintf((char*) pBuf,  (char*) "##  * Key   : Order field %05d - KeySequence=%d - Pos=%05d, Len=%05d, Type=%s\n", i+1, pKey[i]->seqkey, pKey[i]->pos, pKey[i]->len, pKey[i]->type);
					write_line(pFile, (char*) pBuf);
					n++;
				}
			}
			i++;
			if (i > params->nMaxFields)
				i=0;
		} while (n <= params->nNumKeys);
	}
	write_line(pFile, (char*)"##* ----------------------------------------------------------------------------\n");



	for (i=0; i < n_scripthead; i++) {
		strcpy(pBuf, szscripthead[i]);
		write_line(pFile, (char*)pBuf);
	}

	write_line(pFile, (char*)"export RTC=0\n");

	write_line(pFile, (char*)"if [ \"$RTC\" == \"0\" ] ; then 	\n");
	sprintf((char*) pBuf, "      cobc -x -std=mf -debug -Wall -D_FILE_OFFSET_BITS=\"64\" -o ../bin/%s ../src/%s.cbl\n", params->PgmCheckData, params->PgmCheckData);
	write_line(pFile, (char*) pBuf);

	write_line(pFile, (char*)"export RTC=$?\n");
	write_line(pFile, (char*)"else\n");
	write_line(pFile, (char*)"export RTC=1\n");
	write_line(pFile, (char*)"fi\n");

	write_line(pFile, (char*)"if [ \"$RTC\" == \"0\" ] ; then 	\n");
	sprintf((char*) pBuf, "     cobc -x -std=mf -debug -Wall -D_FILE_OFFSET_BITS=\"64\" -o ../bin/%s ../src/%s.cbl\n", params->PgmCheckSort, params->PgmCheckSort);
	write_line(pFile, (char*) pBuf);
	write_line(pFile, (char*)"export RTC=$?\n");
	write_line(pFile, (char*)"else\n");
	write_line(pFile, (char*)"export RTC=1\n");
	write_line(pFile, (char*)"fi\n");


	write_line(pFile, (char*)"if [ \"$RTC\" == \"0\" ] ; then 	\n");
	sprintf((char*) pBuf, "export FGENFILE=%s%s\n", params->PathGen, params->szFileName);
	write_line(pFile, (char*) pBuf);

	sprintf((char*) pBuf, (char*)"      ../bin/%s\n",params->PgmCheckData);
	write_line(pFile, (char*) pBuf);
	write_line(pFile, (char*)"export RTC=$?\n");
	write_line(pFile, (char*)"else\n");
	write_line(pFile, (char*)"export RTC=1\n");
	write_line(pFile, (char*)"fi\n");

	write_line(pFile, (char*)"if [ \"$RTC\" == \"0\" ] ; then 	\n");

	for (i=0; i < n_ocsort_top; i++) {
		strcpy(pBuf, "export ");
		strcat(pBuf, szocsort_top[i]);
		write_line(pFile, (char*)pBuf);
	}



	sprintf((char*) pBuf, (char*)"../bin/ocsort TAKE  ../take/%s.prm\n", params->szFileName);
	write_line(pFile, (char*) pBuf);
	write_line(pFile, (char*)"export RTC=$?\n");
	write_line(pFile, (char*)"else\n");
	write_line(pFile, (char*)"export RTC=1\n");
	write_line(pFile, (char*)"fi\n");


	write_line(pFile, (char*)"##  checkdata sortede by OCSort \n");
	write_line(pFile, (char*)"if [ \"$RTC\" == \"0\" ] ; then 	\n");
	sprintf((char*) pBuf, "export FGENFILE=%s%s.srt\n", params->PathGen, params->szFileName);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf, (char*)"     ../bin/%s\n", params->PgmCheckSort);
	write_line(pFile, (char*) pBuf);

	write_line(pFile, (char*)"export RTC=$?\n");
	write_line(pFile, (char*)"else\n");
	write_line(pFile, (char*)"export RTC=1\n");
	write_line(pFile, (char*)"fi\n");

	write_line(pFile, (char*)"if [ \"$RTC\" == \"0\" ] ; then 	\n");
	write_line(pFile, (char*)"     echo \"Script OK\"\n");
	write_line(pFile, (char*)"else\n");
	write_line(pFile, (char*)"	   echo \"Script KO\"\n");
	write_line(pFile, (char*)"fi\n");


	fclose(pFile);

    i = strtol(mode, 0, 8);
    if (chmod (szFile,i) < 0) {
		fprintf(stderr,"*ocsort_gentestcase*S004* Cannot open file %s : %s\n",szFile,strerror(errno));
		return -1;
	}
	free(pBuf);

	return 0;
}

int gen_script_win(struct params_t* params, struct key_t** pKey )
{
	FILE* pFile;
	char* pBuf;
	int i, n;
	char szFile[FILENAME_MAX];

	strcpy(szFile, params->PathBatsh);
	strcat(szFile, params->ScriptName);
	strcat(szFile, ".bat");


	pBuf = (char*) malloc(MAX_RECORD+2);
	memset(pBuf, 0x20, params->nLenMax);

	pFile=fopen(szFile, "w");
	if (pFile==NULL){
		fprintf(stderr,"*  *S005* Cannot open file %s : %s\n",szFile,strerror(errno));
		return -1;
	}

	fprintf(stdout,"Script for execution Windows\n");
	fprintf(stdout,"%s\n", szFile);
	fprintf(stdout,"------------------------------------------------------------------------------\n");

	write_line(pFile, (char*)"@echo off\n");
	write_line(pFile, (char*)"echo \"Start Script \"\n");
	write_line(pFile, (char*)"::* ----------------------------------------------------------------------------\n");
	write_line(pFile, (char*)"::* File generated from ocsort_gentestcase\n");
	write_line(pFile, (char*)"::* ----------------------------------------------------------------------------\n");
	sprintf((char*) pBuf,  (char*)"::* pathgen     =%s\n",	params->PathGen);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf,  (char*)"::* filename    =%s\n",	params->szFileName);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf,  (char*)"::* organization=%s\n",	params->szOrg);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf,  (char*)"::* record      =%s\n",	params->szRec);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf,  (char*)"::* lenmin      =%05d\n",	params->nLenMin);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf,  (char*)"::* lenmax      =%05d\n",	params->nLenMax);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf,  (char*)"::* numrec      =%05lu\n",	params->nNumRec);
	write_line(pFile, (char*) pBuf);
	write_line(pFile, (char*)"::* ----------------------------------------------------------------------------\n");

	for (i=0; i <= params->nMaxFields; i++) {
		sprintf((char*) pBuf, (char*)  "::  * Field : %05d - Pos=%05d, Len=%05d, Type=%s", i+1, pKey[i]->pos, pKey[i]->len, pKey[i]->type);
		write_line(pFile, (char*) pBuf);
		if ( pKey[i]->iskey == 1)
			sprintf((char*) pBuf, (char*)  ", Order=%s, KeySequence=%d\n", pKey[i]->order, pKey[i]->seqkey);
		else
			sprintf((char*) pBuf, "\n");
		write_line(pFile, (char*) pBuf);
	}
	write_line(pFile, (char*) "::* ----------------------------------------------------------------------------\n");
	write_line(pFile, (char*) "::*                             Key definition\n");

	if (params->nNumKeys > 0) {
		n=1;
		i=0;
		do {
			if (pKey[i]->iskey == 1) {
				if (pKey[i]->seqkey == n) {
					sprintf((char*) pBuf,  (char*) ":: * Key   : Order field %05d - KeySequence=%d - Pos=%05d, Len=%05d, Type=%s\n", i+1, pKey[i]->seqkey, pKey[i]->pos, pKey[i]->len, pKey[i]->type);
					write_line(pFile, (char*) pBuf);
					n++;
				}
			}
			i++;
			if (i > params->nMaxFields)
				i=0;
		} while (n <= params->nNumKeys);
	}
	write_line(pFile, (char*)"::* ----------------------------------------------------------------------------\n");


	for (i=0; i < n_scripthead; i++) {
		strcpy(pBuf, szscripthead[i]);
		write_line(pFile, (char*)pBuf);
	}
	

	sprintf((char*) pBuf, "cobc -x -std=mf -debug -Wall -D_FILE_OFFSET_BITS=\"64\" -o ..\\bin\\%s ..\\src\\%s.cbl\n", params->PgmCheckData, params->PgmCheckData);
	write_line(pFile, (char*) pBuf);

	write_line(pFile, (char*)"if %errorlevel = 1 goto lberr\n");

	sprintf((char*) pBuf, "cobc -x -std=mf -debug -Wall -D_FILE_OFFSET_BITS=\"64\" -o ..\\bin\\%s ..\\src\\%s.cbl\n", params->PgmCheckSort, params->PgmCheckSort);
	write_line(pFile, (char*) pBuf);

	write_line(pFile, (char*)"if %errorlevel = 1 goto lberr\n");


	sprintf((char*) pBuf, "set FGENFILE=..\\files\\%s\n", params->szFileName);
	write_line(pFile, (char*) pBuf);

	sprintf((char*) pBuf, (char*)"..\\bin\\%s\n",params->PgmCheckData);
	write_line(pFile, (char*) pBuf);

	for (i=0; i < n_ocsort_top; i++) {
		strcpy(pBuf, "SET "); 
		strcat(pBuf, szocsort_top[i]);
		write_line(pFile, (char*)pBuf);
	}


	sprintf((char*) pBuf, (char*)"..\\bin\\ocsort TAKE %s%s.prm\n", params->PathTake, params->szFileName);
	write_line(pFile, (char*) pBuf);

	write_line(pFile, (char*)"if %errorlevel = 1 goto lberr\n");

	write_line(pFile, (char*)":: checkdata sortede by OCSort \n");
	sprintf((char*) pBuf, "set FGENFILE=..\\files\\%s.srt\n", params->szFileName);
	write_line(pFile, (char*) pBuf);
	sprintf((char*) pBuf, (char*)"..\\bin\\%s\n", params->PgmCheckSort);
	write_line(pFile, (char*) pBuf);

	write_line(pFile, (char*)"if %errorlevel = 1 goto lberr\n");

	write_line(pFile, (char*)"goto lbend\n");
	write_line(pFile, (char*)":lberr\n");
	write_line(pFile, (char*)"echo \"Errors check log and steps\"\n");
	write_line(pFile, (char*)":lbend\n");
	write_line(pFile, (char*)"echo \"End Script \"\n");



	fclose(pFile);

	free(pBuf);

	return 0;
}

