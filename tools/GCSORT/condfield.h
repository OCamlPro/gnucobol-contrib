/*
    Copyright (C) 2016-2024 Sauro Menna
    Copyright (C) 2009 Cedric ISSALY
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

#ifndef CONDFIELD_H_INCLUDED
#define CONDFIELD_H_INCLUDED

#define COND_TYPE_OPERATION		0
#define COND_TYPE_CONDITION		1
#define COND_TYPE_PARENTHESIS	2
#define COND_TYPE_COND_FIELDS	3	/* 156,15,CH,LT,141,15,CH   */

#include <libcob.h>

struct condField_t;
struct fieldValue_t;

struct condField_t {
	int type;
	union {
		struct {
			int operation;
			struct condField_t *first;
			struct condField_t *second;
		} operation;                                    /* COND_TYPE_OPERATION */
		struct {
			int position;
			int length;
			int type;
			int condition;
			cob_field* cb_fd;
			int isDateValue;
			struct fieldValue_t *fieldValue;
		} condition;                                    /* COND_TYPE_CONDITION	*/
		struct {
			int position1;
			int length1;
			int type1;
			cob_field* cb_fd1;
			int condition;
			int position2;
			int length2;
			int type2;
			cob_field* cb_fd2;
		} condition_field;                              /* COND_TYPE_COND_FIELDS */
	};
	struct condField_t *next;
};

struct condField_t *condField_constructor_condition(int position, int length, int type, int condition, struct fieldValue_t *fieldValue);
struct condField_t *condField_constructor_operation(int operation, struct condField_t *first, struct condField_t *second);
struct condField_t *condField_constructor_conditionfield(int position1, int length1, int type1, int condition, int position2, int length2, int type2);
struct condField_t* condField_constructor_condition4Date(int position, int length, int type, int condition, struct fieldValue_t* fieldValue);
void condField_destructor(struct condField_t *condField);
int condField_print(struct condField_t *condField);
struct condField_t *condField_getNext(struct condField_t *condField);
int condField_test(struct condField_t *condField, unsigned char *record, struct job_t* job);
int condField_compare(struct condField_t *condField, unsigned char *record);

int condField_addDefinition(struct condField_t *condField);

int condField_addQueue(struct condField_t **condField, struct condField_t *condFieldToAdd);
int condField_addInclude(struct condField_t *condField);
int condField_addOmit(struct condField_t *condField);
int condField_setCondFieldsTypeAll(int nTypeCond, int nVal);
int condField_setFormatFieldsTypeAll(int nTypeFormat, int nVal);
int condField_setFormat(struct condField_t *condField, int nVal);
int condField_addIncludeOutfil(struct outfil_t* outfil, struct condField_t* condField);
int condField_addOmitOutfil(struct outfil_t* outfil, struct condField_t* condField);
/* int condField_getLen(struct condField_t* condField); */
int condField_checkLen(struct condField_t* condField, int nLen);



#endif /* CONDFIELD_H_INCLUDED */
