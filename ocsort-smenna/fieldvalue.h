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

#ifndef FIELDVALUE_H_INCLUDED
#define FIELDVALUE_H_INCLUDED 
#include <stdint.h>
#include <stdio.h>


//
#include "libocsort.h"


struct fieldValue_t {
	int occursion;
	int type;
	char *value;
	int64_t value64;
	int generated_length;
	char *generated_value;
	cob_field_attr pCobFAttr;
	cob_field	  pCobField;
};

struct fieldValue_t* fieldValue_constructor( char *type,  char *value, int nTypeF);
struct fieldValue_t* fieldValue_constr_newF(char *type,  char *value, int nTypeF);
void fieldValue_destructor(struct fieldValue_t *fieldValue);
int fieldValue_print(struct fieldValue_t *fieldValue);
int fieldValue_test(struct fieldValue_t *fieldValue, unsigned char *record, int length);
int fieldValue_getGeneratedLength(struct fieldValue_t *fieldValue);
char *fieldValue_getGeneratedValue(struct fieldValue_t *fieldValue);
#endif // FIELDVALUE_H_INCLUDED
