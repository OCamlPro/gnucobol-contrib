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

#ifndef OUTREC_H_INCLUDED
#define OUTREC_H_INCLUDED

struct outrec_t;
struct fieldValue_t;


struct outrec_t *outrec_constructor_range(int position, int length);
struct outrec_t *outrec_constructor_change_position(int position, struct fieldValue_t *fieldValue);
struct outrec_t *outrec_constructor_change(struct fieldValue_t *fieldValue);

int outrec_addQueue(struct outrec_t **outrec,struct outrec_t *outrec_add);
struct outrec_t *outrec_getNext(struct outrec_t *outrec);
int outrec_print(struct outrec_t *outrec);
int outrec_getLength(struct outrec_t *outrec);
int outrec_copy(struct outrec_t *outrec, char *output, char *input, int outputLength, int inputLength);
#endif // OUTREC_H_INCLUDED
