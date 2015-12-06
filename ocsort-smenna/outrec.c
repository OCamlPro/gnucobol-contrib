/*
 *  Copyright (C) 2009 Cedric ISSALY
 *
 *	This file is part of OCSort.
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "outrec.h"
#include "fieldvalue.h"
#define OUTREC_TYPE_RANGE 0
#define OUTREC_TYPE_CHANGE_POSITION 1
#define OUTREC_TYPE_CHANGE 2

struct outrec_t {
	int type;
	union {
		struct {
			int position;
			int length;
		} range;
		struct {
			int position;
			struct fieldValue_t *fieldValue;
		} change_position;
		struct {
			struct fieldValue_t *fieldValue;
		} change;
	};
	struct outrec_t *next;
};

struct outrec_t *outrec_constructor_range(int position, int length) {
	struct outrec_t *outrec=(struct outrec_t *)malloc(sizeof(struct outrec_t));
	outrec->type=OUTREC_TYPE_RANGE;
	outrec->range.position=position;
	outrec->range.length=length;
	outrec->next=NULL;
	return outrec;
}
struct outrec_t *outrec_constructor_change_position(int position, struct fieldValue_t *fieldValue) {
	struct outrec_t *outrec=(struct outrec_t *)malloc(sizeof(struct outrec_t));
	outrec->type=OUTREC_TYPE_CHANGE_POSITION;
	outrec->change_position.position=position;
	outrec->change_position.fieldValue=fieldValue;
	outrec->next=NULL;
	return outrec;
}
struct outrec_t *outrec_constructor_change(struct fieldValue_t *fieldValue) {
	struct outrec_t *outrec=(struct outrec_t *)malloc(sizeof(struct outrec_t));
	outrec->type=OUTREC_TYPE_CHANGE;
	outrec->change.fieldValue=fieldValue;
	outrec->next=NULL;
	return outrec;
}
int outrec_addQueue(struct outrec_t **outrec,struct outrec_t *outrec_add) {
	struct outrec_t *o;
	if (*outrec==NULL) {
		*outrec=outrec_add;
	} else {
		for (o=*outrec;o->next!=NULL;o=o->next);
		o->next=outrec_add;
	}
	return 0;
}
struct outrec_t *outrec_getNext(struct outrec_t *outrec) {
	return outrec->next;
}
int outrec_print(struct outrec_t *outrec) {
	switch (outrec->type) {
		case OUTREC_TYPE_RANGE:
			printf("%d,%d",outrec->range.position,outrec->range.length);
			break;
		case OUTREC_TYPE_CHANGE_POSITION:
			printf("%d:",outrec->change_position.position);
			fieldValue_print(outrec->change_position.fieldValue);
			break;
		case OUTREC_TYPE_CHANGE:
			fieldValue_print(outrec->change.fieldValue);
			break;
		default:
			break;
	}
	return 0;
}
int outrec_getLength(struct outrec_t *outrec) {
	int length=0;
	struct outrec_t *o;

	for (o=outrec;o!=NULL;o=o->next) {
		switch (o->type) {
			case OUTREC_TYPE_RANGE:
				length+=o->range.length;
				break;
			case OUTREC_TYPE_CHANGE_POSITION:
				length+=fieldValue_getGeneratedLength(o->change_position.fieldValue);
				break;
			case OUTREC_TYPE_CHANGE:
				length+=fieldValue_getGeneratedLength(o->change.fieldValue);
				break;
			default:
				break;
		}
	}
	return length;
}
int outrec_copy(struct outrec_t *outrec, char *output, char *input, int outputLength, int inputLength) {
	int position=0;
	struct outrec_t *o;
	for (o=outrec;o!=NULL;o=o->next) {
		switch (o->type) {
			case OUTREC_TYPE_RANGE:
				memcpy(output+position, input+o->range.position, o->range.length);
				position+=o->range.length;
				break;
			case OUTREC_TYPE_CHANGE_POSITION:
				memcpy(output+position, fieldValue_getGeneratedValue(o->change_position.fieldValue),fieldValue_getGeneratedLength(o->change_position.fieldValue));
				position+=fieldValue_getGeneratedLength(o->change_position.fieldValue);
				break;
			case OUTREC_TYPE_CHANGE:
				memcpy(output+position, fieldValue_getGeneratedValue(o->change.fieldValue),fieldValue_getGeneratedLength(o->change.fieldValue));
				position+=fieldValue_getGeneratedLength(o->change.fieldValue);
				break;
			default:
				break;
		}
	}
	return 0;
}
