/*
 *  Copyright (C) 2009 Cedric ISSALY
 *  Copyright (C) 2016 Sauro Menna
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
#include "job.h"
#include "sumfield.h"
#include "ocsort.h"
#include "utils.h"

struct sortField_t {
	int position;
	int length;
	int type;
	int direction;
	struct sortField_t *next;
};

struct sortField_t *sortField_constructor(int position, int length, int type, int direction) {
	struct sortField_t *sortField=(struct sortField_t *)malloc(sizeof(struct sortField_t));
	sortField->position=position;
	sortField->length=length;
	sortField->type=type;
	sortField->direction=direction;
	sortField->next=NULL;
	return sortField;
}
void sortField_destructor(struct sortField_t *sortField) {
	free(sortField);
}


int sortField_print(struct sortField_t *sortField) {
	printf("%d,%d,%s,%s",
		sortField->position,
		sortField->length,
		utils_getFieldTypeName(sortField->type),
		utils_getSortDirectionName(sortField->direction));
	return 0;
}

struct sortField_t *sortField_getNext(struct sortField_t *sortField) {
	if (sortField==NULL) {
		return NULL;
	} else {
		return sortField->next;
	}}
int sortField_addHead(struct sortField_t **sortField, struct sortField_t *sortFieldToAdd) {
	sortFieldToAdd->next=*sortField;
	*sortField=sortFieldToAdd;
	return 0;
}
int sortField_addQueue(struct sortField_t **sortField, struct sortField_t *sortFieldToAdd) {
	struct sortField_t *f;
	if (*sortField==NULL) {
		*sortField=sortFieldToAdd;
	} else {
		for (f=*sortField;f->next!=NULL;f=f->next);
		f->next=sortFieldToAdd;
	}
	return 0;
}


int sortField_setPosition(struct sortField_t *sortField, int position) {
	sortField->position=position;
	return 0;
}

int sortField_setLength(struct sortField_t *sortField, int length) {
	sortField->length=length;
	return 0;
}

int sortField_setType(struct sortField_t *sortField, int type) {
	sortField->type=type;
	return 0;
}

int sortField_setDirection(struct sortField_t *sortField, int direction) {
	sortField->direction=direction;
	return 0;
}
int sortField_setNext(struct sortField_t *sortField, struct sortField_t *sortFieldToAdd) {
	sortField->next=sortFieldToAdd;
	return 0;
}
int sortField_getPosition(struct sortField_t *sortField) {
	return sortField->position;
}
int sortField_getLength(struct sortField_t *sortField) {
	return sortField->length;
}
int sortField_getType(struct sortField_t *sortField) {
	return sortField->type;
}
int sortField_getDirection(struct sortField_t *sortField) {
	return sortField->direction;
}

int sortField_addDefinition(struct sortField_t *sortField) {
	sortField_addQueue(&(globalJob->sortField), sortField);
	return 0;
}
int sortField_setDefinition(struct sortField_t *sortField) {
	globalJob->sortField=sortField;
	return 0;
}
