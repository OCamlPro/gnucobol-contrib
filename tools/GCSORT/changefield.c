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
#include "changefield.h"
#include "utils.h"

struct changefield_t *changefield_constructor(struct fieldValue_t *find, struct fieldValue_t *set) {
	struct changefield_t *field=(struct changefield_t *)malloc(sizeof(struct changefield_t));
    if (field != NULL) {
		field->change_type = CHANGETYPE_VALUE;
		field->setpos = 0;
		field->setlen = 0;
        field->find = find;
        field->set = set;
        field->next = NULL;
	}
	return field;
}
struct changefield_t* changefield_constructorPosLen(struct fieldValue_t* find,int pos, int len) {
	struct changefield_t* field = (struct changefield_t*)malloc(sizeof(struct changefield_t));
	if (field != NULL) {
		field->change_type = CHANGETYPE_POSLEN;
		field->setpos = pos;
		field->setlen = len;
		field->find = find;
		field->set = NULL;
		field->next = NULL;
	}
	return field;
}
void changefield_destructor(struct changefield_t *fv) {
    
	if (fv->find != NULL)
		fieldValue_destructor((struct fieldValue_t*)fv->find);
    if (fv->set != NULL)
		fieldValue_destructor((struct fieldValue_t*) fv->set);
	free(fv);
}


int changefield_print(struct changefield_t *field) {
	struct changefield_t* f;
	if (field != NULL) {
		for (f = field; f != NULL; f = f->next) {
			fieldValue_print(f->find);
			fprintf(stdout, ",");
			if( f->change_type == CHANGETYPE_VALUE)
				fieldValue_print(f->set);
			else
				fprintf(stdout, "%d,%d", f->setpos, f->setlen);
		}
	}
	return 0;
}

struct changefield_t* changefield_getNext(struct changefield_t *field) {
	if (field==NULL) {
		return NULL;
	} else {
		return field->next;
	}
}
int changefield_t_addQueue(struct changefield_t **field, struct changefield_t *fieldToAdd) {
	struct changefield_t *f;
	if (*field==NULL) {
		*field=fieldToAdd;
	} else {
		for (f=*field;f->next!=NULL;f=f->next);
		f->next=fieldToAdd;
	}
	return 0;
}


int changefield_t_setValues(struct changefield_t *field, struct fieldValue_t *find, struct fieldValue_t *set) {
	field->find = find;
	field->set = set;
	return 0;
}

int changefield_t_setPosLen(struct changefield_t* field, struct fieldValue_t* find, int setPos, int setLen) {
	field->find = find;
	field->set = NULL;
	field->setpos = setPos;
	field->setlen = setLen;
	return 0;
}

int changefield_t_getFind(struct changefield_t *field, struct fieldValue_t* find) {
	find = field->find;
	return 0;
}
int changefield_t_getSet(struct changefield_t *field, struct fieldValue_t *set) {
	set = field->set;
	return 0;
}
int changefield_t_getSetPos(struct changefield_t* field, int* pos, int* len) {
	*pos = field->setpos;
	*len = field->setlen;
	return 0;
}
struct change_t* change_constructor(int v) {
	struct change_t* field = (struct change_t*)malloc(sizeof(struct change_t));
	if (field != NULL) {
		field->vlen = v;
		field->sNoMatch = NULL;
		field->pairs = NULL;
	}
	return field;
}

void change_destructor(struct change_t *fv) 
{
	int nIdx = 0;
	int nIdy = 0;
	struct changefield_t* fPField[128];
	struct changefield_t* f;
	if (fv != NULL) {
		for (f = fv->pairs; f != NULL; f = changefield_getNext(f)) {
			fPField[nIdx] = f;
			nIdx++;
		}
		for (nIdy = 0; nIdy < nIdx; nIdy++) {
			changefield_destructor(fPField[nIdy]);
		}

	}
	if (fv->sNoMatch != NULL)
		fieldValue_destructor((struct fieldValue_t*)fv->sNoMatch);

	free(fv);
}
void change_print(struct change_t* field) {
	if (field != NULL) {
		fprintf(stdout, ",CHANGE=(%d,", field->vlen);
		changefield_print(field->pairs);
		fprintf(stdout, ")");
		if (field->sNoMatch != NULL) {
			fprintf(stdout, ",NOMATCH=(");
			fieldValue_print(field->sNoMatch);
		} else
			if (field->nomatchLen > 0){
				fprintf(stdout, ",NOMATCH=(%d,%d)", field->nomatchPos, field->nomatchLen);
		}
	}
	return;
}
void change_setNoMatch(struct change_t *field, struct fieldValue_t *nomatch) {
	if (nomatch != NULL) 
			field->sNoMatch = nomatch;
	return ;
}
void change_setNoMatchPosLen(struct change_t* field, int nPos, int nLen) {
	field->nomatchPos = nPos;
	field->nomatchLen = nLen;
	return;
}
void change_setpairs(struct change_t* field, struct changefield_t* p) {
	if (p != NULL)
		field->pairs = p;
	return;
}
int change_search_replace(struct change_t* CmdOpt, unsigned char* BufIn, unsigned char* BufOut, int lenIn, int lenOut, unsigned char* inputrec)
{
	unsigned char szRekIn[COB_FILE_BUFF];
	int nSubs = 0;
	struct changefield_t* f;
	if (CmdOpt != NULL) {
		for (f = CmdOpt->pairs; f != NULL; f = f->next) {
			if (f->change_type == CHANGETYPE_VALUE)
				nSubs += utl_replace_single_str(BufIn, (unsigned char*)f->find->generated_value, (unsigned char*) f->set->generated_value, BufOut, lenIn, lenOut);
			else
				/* f->change_type == CHANGETYPE_POSLEN */
			{
				memset(szRekIn, 0x00, COB_FILE_BUFF);
				gc_memcpy(szRekIn, inputrec + f->setpos - 1, lenOut);
				nSubs += utl_replace_single_str(BufIn, (unsigned char*)f->find->generated_value, (unsigned char*)&szRekIn, BufOut, lenIn, f->setlen);
			}
			if (nSubs > 0)
				break;	/* Stop after first substitution */
		}
	}
	if (nSubs == 0)
		return 0;	/* False */
	return 1;		/* Found one occurrence */
}
