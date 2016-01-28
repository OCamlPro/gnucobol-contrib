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

#ifndef SORTFIELD_H_INCLUDED
#define SORTFIELD_H_INCLUDED


struct sortField_t {
	int position;
	int length;
	int type;
	int direction;
	struct sortField_t *next;
};

struct sortField_t;
struct sortField_t *sortField_constructor(int position, int length, int type, int direction);
void sortField_destructor(struct sortField_t *sortField);
int sortField_print(struct sortField_t *sortField);
struct sortField_t *sortField_getNext(struct sortField_t *sortField);
int sortField_addQueue(struct sortField_t **sortField, struct sortField_t *sortFieldToAdd);
int sortField_addHead(struct sortField_t **sortField, struct sortField_t *sortFieldToAdd);
int sortField_setPosition(struct sortField_t *sortField, int position);
int sortField_setLength(struct sortField_t *sortField, int length);
int sortField_setType(struct sortField_t *sortField, int type);
int sortField_setDirection(struct sortField_t *sortField, int direction);
int sortField_setNext(struct sortField_t *sortField, struct sortField_t *sortFieldToAdd);
int sortField_getPosition(struct sortField_t *sortField);
int sortField_getLength(struct sortField_t *sortField);
int sortField_getType(struct sortField_t *sortField);
int sortField_getDirection(struct sortField_t *sortField);
int sortField_addDefinition(struct sortField_t *sortField);
int sortField_setDefinition(struct sortField_t *sortField);

#endif // SORTFIELD_H_INCLUDED
