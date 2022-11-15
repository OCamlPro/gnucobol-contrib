/*
    Copyright (C) 2016-2022 Sauro Menna
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
 
#include <stdio.h>
#include <stdlib.h>
#include "fieldvalue.h"
#include "findreplace.h"
#include "utils.h"

struct findrep_t* findrep_constructor( int nType ) {
	struct findrep_t* field = (struct findrep_t*)malloc(sizeof(struct findrep_t));
	if (field != NULL) {
		field->nfindrep_type = nType;
        field->nStartPos = 0;	
        field->nEndPos = 0;
        field->nDo = 0;
        field->nMaxLen = 0;
        field->nOverRun = 1;    /* Default OVERRUN ERROR */
        field->nShift = 1;      /* Default SHIFT YES     */
		field->pFindRepField = NULL;
	}
	return field;
}

void findrep_setType(struct findrep_t* fr, int ntype)
{
	if (fr != NULL)
		fr->nfindrep_type = ntype;
	return;
}

void findrep_setStartPos ( struct findrep_t *fr, int n)
{
    if (fr != NULL)
        fr->nStartPos = n;
    return;
}
int findrep_getStartPos ( struct findrep_t *fr)
{
    if (fr != NULL)
        return fr->nStartPos;
    return 0;
}
void findrep_setEndPos ( struct findrep_t *fr, int n)
{
    if (fr != NULL)
        fr->nEndPos = n;
    return;
}
int findrep_getEndPos ( struct findrep_t *fr)
{
    if (fr != NULL)
        return fr->nEndPos;
    return 0;
}
void findrep_setDo ( struct findrep_t *fr, int n)
{
    if (fr != NULL)
        fr->nDo = n;
    return;
}
int findrep_getDo ( struct findrep_t *fr)
{
    if (fr != NULL)
        return fr->nDo;
    return 0;
}
void findrep_setMaxLen ( struct findrep_t *fr, int n)
{
    if (fr != NULL)
        fr->nMaxLen = n;
    return;
}
int findrep_getMaxLen ( struct findrep_t *fr)
{
    if (fr != NULL)
        return fr->nMaxLen;
    return 0;
}
void findrep_setOverRun ( struct findrep_t *fr, int n)
{
    if (fr != NULL)
        fr->nOverRun = n;
    return;
}
int findrep_getOverRun ( struct findrep_t *fr)
{
    if (fr != NULL)
        return fr->nOverRun;
    return 0;
}
void findrep_setShift ( struct findrep_t *fr, int n)
{
    if (fr != NULL)
        fr->nShift = n;
    return;
}
int findrep_getShift ( struct findrep_t *fr)
{
    if (fr != NULL)
        return fr->nShift;
    return 0;
}


void findrep_destructor(struct findrep_t *fr) 
{
	int nIdx = 0;
	int nIdy = 0;
	struct findrepfield_t* fPField[128];
	struct findrepfield_t* f;
	if (fr != NULL) {
		for (f = fr->pFindRepField; f != NULL; f = findrepfield_getNext(f)) {
			fPField[nIdx] = f;
			nIdx++;
		}
		if (fr->nfindrep_type == FINDREP_TYPE_ININOUT) { /* In this case only out first element is presents */
			for (nIdy = 0; nIdy < nIdx; nIdy++) {
				if (nIdy == 0) 
					findrepfield_destructor(fPField[nIdy]);
				else
					findrepfield_destructorin(fPField[nIdy]);
			}
		}
		else 
		{
			for (nIdy = 0; nIdy < nIdx; nIdy++)
				findrepfield_destructor(fPField[nIdy]);
		}
	}
	free(fr);
}
void findrep_print(struct findrep_t* field) {
	if (field != NULL) {
		fprintf(stdout, " FINDREP=(");
		findrepfield_print(field->pFindRepField);
		fprintf(stdout, ")");
	}
	return;
}

void findrep_setpairs(struct findrep_t* field, struct findrepfield_t* p) {
	if (p != NULL)
		field->pFindRepField = p;
	return;
}

void findrep_fields_setin(struct findrepfield_t* p, struct fieldValue_t* field) {
	if (p != NULL) {
		p->in = field;
	}
	return;
}
void findrep_fields_setout(struct findrepfield_t* p, struct fieldValue_t* field) {
	if (p != NULL) {
		p->out = field;
	}
	return;
}

int findrep_search_replace(struct findrep_t* CmdOpt, unsigned char* BufIn, unsigned char* BufOut, int lenIn, int lenOut, unsigned char* inputrec, int nMaxOcc)
{
	/* unsigned char szRekIn[COB_FILE_BUFF]; */
	int nSubs = 0;
	int nOc = nMaxOcc;
	int nOverChar = 0;
	int nShift = CmdOpt->nShift;
	if (nMaxOcc == 0)
		nMaxOcc = 1000;  /* Standard DFSort */
	int nMaxLen = CmdOpt->nMaxLen;
	struct findrepfield_t* f;
	if (CmdOpt != NULL) {
		for (f = CmdOpt->pFindRepField; f != NULL; f = f->next) {
			nSubs += utl_replace_recursive_str(BufIn, (unsigned char*)f->in->generated_value, (unsigned char*) f->out->generated_value, BufOut, lenIn, lenOut, nSubs, nMaxOcc, &nOverChar, nShift);
			/* Check OverRun */
			memcpy(BufIn, BufOut, lenIn);
			if (nSubs > nMaxOcc)
				break;	/* Stop after n substitution  VERIFY */
		}
	}
	if (nOverChar < 0) {		
		if (CmdOpt->nOverRun == 1) {  /* ERROR */
			fprintf(stdout,"*GCSORT*S627*ERROR:FINDREP - Record length exceeds maximum size [Use OVERRUN=TRUNCATE]\n");
			utl_abend_terminate(RECORD_LENGTH, 627, ABEND_EXEC);
		}
		else
		{
			/* TRUNC */
	
		}
	}
	
	if (nSubs == 0)
		return 0;	/* False */
	return nSubs;		
}

struct findrepfield_t *findrepfield_constructor(struct fieldValue_t* in, struct fieldValue_t* out) {
	struct findrepfield_t *field=(struct findrepfield_t *)malloc(sizeof(struct findrepfield_t));
    if (field != NULL) {
        field->in = in;
        field->out = out;
        field->next = NULL;
	}
	return field;
}

void findrepfield_destructor(struct findrepfield_t *fr) {
    
	if (fr->in != NULL)
		fieldValue_destructor((struct fieldValue_t*)fr->in);
    if (fr->out != NULL)
		fieldValue_destructor((struct fieldValue_t*) fr->out);
	free(fr);
}

void findrepfield_destructorin(struct findrepfield_t* fr) {

	if (fr->in != NULL)
		fieldValue_destructor((struct fieldValue_t*)fr->in);
	free(fr);
}


int findrepfield_print(struct findrepfield_t *field) {
	struct findrepfield_t* f;
	if (field != NULL) {
		int i = 0;
		for (f = field; f != NULL; f = f->next) {
			if (i > 0)
				fprintf(stdout, ",");
			i++;
			fprintf(stdout, "IN=");
			fieldValue_print(f->in);
			fprintf(stdout, ",");
			fprintf(stdout, "OUT=");
			fieldValue_print(f->out);
		}
	}
	return 0;
}

struct findrepfield_t* findrepfield_getNext(struct findrepfield_t *field) {
	if (field==NULL) {
		return NULL;
	} else {
		return field->next;
	}
}
int findrepfield_t_addQueue(struct findrepfield_t **field, struct findrepfield_t *fieldToAdd) {
	struct findrepfield_t *f;
	if (*field==NULL) {
		*field=fieldToAdd;
	} else {
		for (f=*field;f->next!=NULL;f=f->next);
		f->next=fieldToAdd;
	}
	return 0;
}

void findrepfield_setOutForAll(struct findrepfield_t* fin, struct fieldValue_t* out)
{
	struct findrepfield_t* f;
	for (f = fin; f != NULL; f = findrepfield_getNext(f)) {
		f->out = out;
	}
	return;
}

int findrepfield_t_setValues(struct findrepfield_t *field, struct fieldValue_t *in, struct fieldValue_t *out) {
	field->in = in;
	field->out = out;
	return 0;
}

int findrepfield_t_getFind(struct findrepfield_t *field, struct fieldValue_t* in) {
	in = field->in;
	return 0;
}
int findrepfield_t_getRep(struct findrepfield_t *field, struct fieldValue_t *out) {
	out = field->out;
	return 0;
}

