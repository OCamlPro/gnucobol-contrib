/*
 *  Copyright (C) 2009 Cedric ISSALY 
 *  Copyright (C) 2015 Sauro Menna
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

#define TYPE_STRUCT_STD		0
#define TYPE_STRUCT_NEW		1

struct outrec_t;
struct fieldValue_t;

#define OUTREC_TYPE_RANGE				0
#define OUTREC_TYPE_CHANGE_POSITION		1
#define OUTREC_TYPE_CHANGE				2
#define OUTREC_TYPE_RANGE_POSITION		3

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
		struct {		
			int posAbsRec;
			int position;
			int length;
		} range_position;		//3
	};
	struct outrec_t *next;
};

struct outrec_t *outrec_constructor_range(int position, int length);
struct outrec_t *outrec_constructor_change_position(int position, struct fieldValue_t *fieldValue);
struct outrec_t *outrec_constructor_change(struct fieldValue_t *fieldValue);
struct outrec_t *outrec_constructor_range_position(int posAbsRec, int position, int length);
struct outrec_t *outrec_constructor_subst(unsigned char *chfieldValue);
struct outrec_t *outrec_constructor_padding(int nAbsPos, unsigned char *chfieldValue, int nPosAbsRec);
struct outrec_t *outrec_constructor_substnchar(int ntimes, unsigned char *chfieldValue);
void outrec_destructor(struct outrec_t *outrec);
int outrec_addQueue(struct outrec_t **outrec,struct outrec_t *outrec_add);
struct outrec_t *outrec_getNext(struct outrec_t *outrec);
int outrec_print(struct outrec_t *outrec);
int outrec_getLength(struct outrec_t *outrec);
int outrec_copy(struct outrec_t *outrec, unsigned char *output, unsigned char *input, int outputLength, int inputLength, int nFileFormat, int nIsMF, struct job_t* job);
int outrec_addDefinition(struct outrec_t *outrec);

#endif // OUTREC_H_INCLUDED
