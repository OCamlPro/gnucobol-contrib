/*
    Copyright (C) 2016-2019 Sauro Menna
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

#ifndef FIELDVALUE_H_INCLUDED
#define FIELDVALUE_H_INCLUDED 
#include <stdint.h>
#include <stdio.h>

#include <libcob.h>
//
#include "libgcsort.h"


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
int fieldValue_checkvalue(struct fieldValue_t *fieldValue, cob_field* pField, int length);
int fieldValue_getGeneratedLength(struct fieldValue_t *fieldValue);
char *fieldValue_getGeneratedValue(struct fieldValue_t *fieldValue);
int fieldValue_checksubstring(struct fieldValue_t *fieldValue, cob_field* pField, int length);
int fieldValue_ss_array(struct fieldValue_t *fieldValue, cob_field* pField, int length);
int fieldValue_ss_value(struct fieldValue_t *fieldValue, cob_field* pField, int length);
#endif // FIELDVALUE_H_INCLUDED
