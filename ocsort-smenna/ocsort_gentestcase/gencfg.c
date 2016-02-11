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

int print_paramCFG (FILE* pFile, struct params_t* params, struct key_t** pKey )
{
	int i,n;
	fprintf(pFile,"* ----------------------------------------------------------------------------\n");
	fprintf(pFile,"* File generated from ocsort_gentestcase\n");
	fprintf(pFile,"* ----------------------------------------------------------------------------\n");
	fprintf(pFile,"* pathgen     =%s\n",	params->PathGen);
	fprintf(pFile,"* filename    =%s\n",	params->szFileName);
	fprintf(pFile,"* organization=%s\n",	params->szOrg);
	fprintf(pFile,"* record      =%s\n",	params->szRec);
	fprintf(pFile,"* lenmin      =%05d\n",	params->nLenMin);
	fprintf(pFile,"* lenmax      =%05d\n",	params->nLenMax);
	fprintf(pFile,"* numrec      =%05lu\n",	params->nNumRec);
	fprintf(pFile,"* ----------------------------------------------------------------------------\n");
	fprintf(pFile,"*                             Record definition\n");
	for (i=0; i <= params->nMaxFields; i++) {
		fprintf(pFile, (char*)  "* Field : %05d - Pos=%05d, Len=%05d, Type=%s", i+1, pKey[i]->pos, pKey[i]->len, pKey[i]->type);
		if ( pKey[i]->iskey == 1)
			fprintf(pFile, (char*)  ", Order=%s, KeySequence=%d\n", pKey[i]->order, pKey[i]->seqkey);
		else
			fprintf(pFile, "\n");
	}
	fprintf(pFile,"* ----------------------------------------------------------------------------\n");
	fprintf(pFile, "*                             Key definition\n");

	if (params->nNumKeys > 0) {
		n=1;
		i=0;
		do {
			if (pKey[i]->iskey == 1) {
				if (pKey[i]->seqkey == n) {
					fprintf(pFile, "* Key   : Order %05d - KeySequence=%d - Pos=%05d, Len=%05d, Type=%s\n", i+1, pKey[i]->seqkey, pKey[i]->pos, pKey[i]->len, pKey[i]->type);
					n++;
				}
			}
			i++;
			if (i > params->nMaxFields)
				i=0;
		} while (n <= params->nNumKeys);
	}
	fprintf(pFile, "* ----------------------------------------------------------------------------\n");
	return 0;
}

int destroy_paramCFG ( struct params_t* params, struct key_t** pKey )
{
	int i;
	for (i=0; i <= params->nMaxFields; i++) 
		free(pKey[i]);
	free(params);
	return 0;
}

int	read_fileCFG ( char* szCmdLine, struct params_t* pParams , struct key_t** pKey )
{
	char szCFGFile[256];
	char szLine[120];
	int nNumKey = 0;
	int nL = 0;
	FILE *pFile;
	int nNewLine;
	int maxLen=0;



	int  nPKey=-1;
	int  nNumRec=0;
	nNewLine=1;
	
	if (szCmdLine[1]!=0) {
		strcpy(szCFGFile, (const char*) szCmdLine);
		if((pFile=fopen(szCFGFile, "rt"))==NULL) {
			fprintf(stderr, "\n*GenTestcase* ERROR Unable to open file %s", (char*)szCFGFile);
			exit(-1); 
		}
	}

	strcpy(pParams->Config, (const char*) szCmdLine); //

	b_scripthead = 0;
	n_scripthead = 0;

	b_ocsort_top = 0;
	n_ocsort_top = 0;

	b_ocsort_bottom = 0;
	n_ocsort_bottom = 0;
	

	while( fgets(szLine, sizeof(szLine), pFile) != NULL)
	{
		if(szLine[0] == '*')	// Is comment
			continue;
		if(szLine[0] == '#')	// Is comment
			continue;

// * ----------------------------------------------------
		if(strncmp(szLine, "scripthead_end",14) == 0) {
			b_scripthead=0;
			continue;
		}
		if(strncmp(szLine, "scripthead_start",16) == 0) {
			b_scripthead=1;
			continue;
		}
		if (b_scripthead == 1) {
			strcpy(szscripthead[n_scripthead], szLine);
			n_scripthead++;
			continue;
		}

// * ----------------------------------------------------
// * ----------------------------------------------------
		if(strncmp(szLine, "ocsort_top_end",14) == 0) {
			b_ocsort_top=0;
			continue;
		}
		if(strncmp(szLine, "ocsort_top_start",16) == 0) {
			b_ocsort_top=1;
			continue;
		}
		if (b_ocsort_top == 1) {
			strcpy(szocsort_top[n_ocsort_top], szLine);
			n_ocsort_top++;
			continue;
		}

// * ----------------------------------------------------
// * ----------------------------------------------------
		if(strncmp(szLine, "ocsort_bottom_end",17) == 0) {
			b_ocsort_bottom=0;
			continue;
		}
		if(strncmp(szLine, "ocsort_bottom_start",19) == 0) {
			b_ocsort_bottom=1;
			continue;
		}
		if (b_ocsort_bottom == 1) {
			strcpy(szocsort_bottom[n_ocsort_bottom], szLine);
			n_ocsort_bottom++;
			continue;
		}

// * ----------------------------------------------------
		if(strncmp(szLine, "pathgen=",8) == 0) {
			strcpy(pParams->PathGen, szLine+8);
			pParams->PathGen[strlen(pParams->PathGen)-1]=0x00;
			#ifdef _WIN32
				if (pParams->PathGen[strlen(pParams->PathGen)-1] !=  '\\' ) 
					strcat(pParams->PathGen, "\\");
			#else
				if (pParams->PathGen[strlen(pParams->PathGen)-1] !=  '/' ) 
					strcat(pParams->PathGen, "/");
			#endif
		}

		if(strncmp(szLine, "pathsrc=",8) == 0) {
			strcpy(pParams->PathSrc, szLine+8);
			pParams->PathSrc[strlen(pParams->PathSrc)-1]=0x00;
			#ifdef _WIN32
				if (pParams->PathSrc[strlen(pParams->PathSrc)-1] !=  '\\' ) 
					strcat(pParams->PathSrc, "\\");
			#else
				if (pParams->PathGen[strlen(pParams->PathGen)-1] !=  '/' ) 
					strcat(pParams->PathGen, "/");
			#endif
		}

		if(strncmp(szLine, "pathtake=",9) == 0) {
			strcpy(pParams->PathTake, szLine+9);
			pParams->PathTake[strlen(pParams->PathTake)-1]=0x00;
			#ifdef _WIN32
				if (pParams->PathTake[strlen(pParams->PathTake)-1] !=  '\\' ) 
					strcat(pParams->PathTake, "\\");
			#else
				if (pParams->PathGen[strlen(pParams->PathGen)-1] !=  '/' ) 
					strcat(pParams->PathGen, "/");
			#endif
		}

		if(strncmp(szLine, "pathbatsh=",10) == 0) {
			strcpy(pParams->PathBatsh, szLine+10);
			pParams->PathBatsh[strlen(pParams->PathBatsh)-1]=0x00;
			#ifdef _WIN32
				if (pParams->PathBatsh[strlen(pParams->PathBatsh)-1] !=  '\\' ) 
					strcat(pParams->PathBatsh, "\\");
			#else
				if (pParams->PathGen[strlen(pParams->PathGen)-1] !=  '/' ) 
					strcat(pParams->PathGen, "/");
			#endif
		}
		
		if(strncmp(szLine, "script=",7) == 0) {
			strcpy(pParams->ScriptName, szLine+7);
			pParams->ScriptName[strlen(pParams->ScriptName)-1]=0x00;
		}

		
		if(strncmp(szLine, "pgmcheckdata=",13) == 0) {
			strcpy(pParams->PgmCheckData, szLine+13);
			pParams->PgmCheckData[strlen(pParams->PgmCheckData)-1]=0x00;
		}

		if(strncmp(szLine, "pgmchecksort=",13) == 0) {
			strcpy(pParams->PgmCheckSort, szLine+13);
			pParams->PgmCheckSort[strlen(pParams->PgmCheckSort)-1]=0x00;
		}

		if(strncmp(szLine, "filename=",9) == 0) {
			strcpy(pParams->szFileName, szLine+9);
			pParams->szFileName[strlen(pParams->szFileName)-1]=0x00;
		}
		if(strncmp(szLine, "organization=",13) == 0){
			strcpy(pParams->szOrg, szLine+13); 
			pParams->szOrg[strlen(pParams->szOrg)-1]=0x00;
		}

		if(strncmp(szLine, "record=",7) == 0){
			strcpy(pParams->szRec, szLine+7);
			pParams->szRec[strlen(pParams->szRec)-1]=0x00;
		}

		if(strncmp(szLine, "lenmin=",7) == 0){
			pParams->nLenMin=atoi(szLine+7);
		}

		if(strncmp(szLine, "lenmax=",7) == 0){
			pParams->nLenMax=atoi(szLine+7);
		}

		if(strncmp(szLine, "numrec=",7) == 0){
			pParams->nNumRec = atol(szLine+7);
		}
		if(strncmp(szLine, "byteorder=",9) == 0){
			pParams->byteorder = atoi(szLine+9);
		}


	// Keys
		if(strncmp(szLine, "pos=",4) == 0){
			pParams->nMaxFields++;
			pKey[pParams->nMaxFields] = (struct key_t*) malloc(sizeof( struct key_t));		// max 20 elements
			pKey[pParams->nMaxFields]->pos=atoi(szLine+4);
			pKey[pParams->nMaxFields]->iskey=0;
			pKey[pParams->nMaxFields]->len=0;
			pKey[pParams->nMaxFields]->seqkey=0;
			strcpy(pKey[pParams->nMaxFields]->order, "A");
		}
		if(strncmp(szLine, "len=",4) == 0){
			pKey[pParams->nMaxFields]->len = atoi(szLine+4);
		}
		if(strncmp(szLine, "type=",5) == 0){
			strcpy(pKey[pParams->nMaxFields]->type, szLine+5);
			pKey[pParams->nMaxFields]->type[strlen(pKey[pParams->nMaxFields]->type)-1]=0x00;
		}

		if(strncmp(szLine, "value=",6) == 0){
			strcpy(pKey[pParams->nMaxFields]->value, szLine+6);
			pKey[pParams->nMaxFields]->value[strlen(pKey[pParams->nMaxFields]->value)-1]=0x00;
		}

		if(strncmp(szLine, "iskey=",6) == 0){
			if (strncmp(szLine+6, "yes",3) == 0) {
				pKey[pParams->nMaxFields]->iskey = 1;
				pParams->nNumKeys++;
			}
		}
		if(strncmp(szLine, "seqkey=",7) == 0){
			pKey[pParams->nMaxFields]->seqkey = atoi(szLine+7);
		}
		if(strncmp(szLine, "order=",6) == 0){
			if (strncmp(szLine+6, "A",1) != 0) {
				strcpy(pKey[pParams->nMaxFields]->order, "D");
			}
		}
	//

	};
	fclose(pFile);
	return 0;
}
