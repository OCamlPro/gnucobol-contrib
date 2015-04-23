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

#ifndef CONDFIELD_H_INCLUDED
#define CONDFIELD_H_INCLUDED

struct condField_t;
struct fieldValue_t;
struct condField_t *condField_constructor_condition(int position, int length, int type, int condition, struct fieldValue_t *fieldValue);
struct condField_t *condField_constructor_operation(int operation, struct condField_t *first, struct condField_t *second);



void condField_destructor(struct condField_t *condField);


int condField_print(struct condField_t *condField);

struct condField_t *condField_getNext(struct condField_t *condField);


int condField_test(struct condField_t *condField, char *record);
#endif // CONDFIELD_H_INCLUDED
