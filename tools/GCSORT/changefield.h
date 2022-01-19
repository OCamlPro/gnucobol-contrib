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

#ifndef CHANGEFIELD_H_INCLUDED
#define CHANGEFIELD_H_INCLUDED

#include <stdint.h>
#include <libcob.h>
#include "fieldvalue.h"


#define CHANGETYPE_VALUE	1		
#define CHANGETYPE_POSLEN	2

struct changefield_t {
	int    change_type;
	struct fieldValue_t *find;
	struct fieldValue_t	*set;
	int		setpos;
	int		setlen;
	struct changefield_t *next;
};

struct change_t {
	int vlen;						/* len of output field */
	struct fieldValue_t *sNoMatch;	/* Field NOMATCH */
	struct changefield_t *pairs;	/* pairs of values	*/
	int nomatchPos;
	int nomatchLen;
};

struct change_t* change_constructor(int v);
void change_destructor(struct change_t *field);
void change_print(struct change_t* field);
void change_setNoMatch(struct change_t *field, struct fieldValue_t *nomatch);
void change_setNoMatchPosLen(struct change_t* field, int nPos, int nLen);
void change_setpairs(struct change_t* field, struct changefield_t* p);

struct changefield_t *changefield_constructor(struct fieldValue_t *find, struct fieldValue_t *set);
struct changefield_t* changefield_constructorPosLen(struct fieldValue_t* find, int pos, int len);
void changefield_destructor(struct changefield_t *field);
int changefield_print(struct changefield_t *field);
struct changefield_t *changefield_getNext(struct changefield_t *field);
int changefield_t_addQueue(struct changefield_t **field, struct changefield_t *fieldToAdd);
int changefield_t_setValues(struct changefield_t *field, struct fieldValue_t *find, struct fieldValue_t *set);
int changefield_t_getFind(struct changefield_t *field, struct fieldValue_t *find);
int changefield_t_getSet(struct changefield_t *field, struct fieldValue_t *set);
int change_search_replace(struct change_t* CmdOpt, unsigned char* BufIn, unsigned char* BufOut, int lenIn, int lenOut, unsigned char* inputrec);
int changefield_t_getSetPos(struct changefield_t* field, int* pos, int* len);
int changefield_t_setPosLen(struct changefield_t* field, struct fieldValue_t* find, int setPos, int setLen);

#endif /* CHANGEFIELD_H_INCLUDED   */
