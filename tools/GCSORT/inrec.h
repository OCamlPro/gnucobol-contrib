/*
    Copyright (C) 2016-2020 Sauro Menna
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

#ifndef INREC_H_INCLUDED
#define INREC_H_INCLUDED

#define TYPE_STRUCT_STD		0
#define TYPE_STRUCT_NEW		1

struct inrec_t;
struct fieldValue_t;
struct change_t;

#define INREC_TYPE_RANGE			0
#define INREC_TYPE_CHANGE_POSITION	1
#define INREC_TYPE_CHANGE			2
#define INREC_TYPE_RANGE_POSITION	3
#define INREC_TYPE_CHANGE_ABSPOS	4
#define INREC_TYPE_CHANGE_CMDOPT	5

struct inrec_t {
	int nIsOverlay;
	int type;
	union {
		struct {
			int position;
			int length;
			int posAbsRec;
			struct fieldValue_t* fieldValue;
			char type;
			struct change_t* changeCmdOpt;
		} range;				/* 0	INREC_TYPE_RANGE    */
		struct {
			int position;
			int length;
			int posAbsRec;
			struct fieldValue_t *fieldValue;
			char type;
			struct change_t* changeCmdOpt;
		} change_position;		/*  1	INREC_TYPE_CHANGE_POSITION  */
		struct {
			int position;
			int length;
			int posAbsRec;
			struct fieldValue_t *fieldValue;
			char type;
			struct change_t* changeCmdOpt;
		} change;				/*  2	INREC_TYPE_CHANGE   */
		struct {		
			int position;
			int length;
			int posAbsRec;
			struct fieldValue_t* fieldValue;
			char type;
			struct change_t* changeCmdOpt;
		} range_position;		/*  3	INREC_TYPE_RANGE_POSITION   */
		struct {
			int position;
			int length;
			int posAbsRec;
			struct fieldValue_t* fieldValue;
			char type;
			struct change_t* changeCmdOpt;
		} changeCmd;			/*  5	INREC_TYPE_CHANGE_CMDOPT   */
	};
	unsigned char* szChangeBufIn;
	unsigned char* szChangeBufOut;
	unsigned char* szChangeBufNoMatch;

	struct inrec_t *next;
};

void inrec_initialize(struct inrec_t* inrec);
struct inrec_t *inrec_constructor_range(int position, int length);
struct inrec_t *inrec_constructor_change_position(int position, struct fieldValue_t *fieldValue);
struct inrec_t *inrec_constructor_change(struct fieldValue_t *fieldValue);
struct inrec_t *inrec_constructor_range_position(int posAbsRec, int position, int length);
struct inrec_t *inrec_constructor_subst(unsigned char *chfieldValue);
struct inrec_t *inrec_constructor_padding(int nAbsPos, unsigned char *chfieldValue, int nPosAbsRec);
struct inrec_t *inrec_constructor_substnchar(unsigned char *ntch, unsigned char *chfieldValue);
struct inrec_t* inrec_constructor_possubstnchar(int npos, unsigned char* ntch, unsigned char* chfieldValue);

void inrec_destructor(struct inrec_t *inrec);
int inrec_addQueue(struct inrec_t **inrec,struct inrec_t *inrec_add);
struct inrec_t *inrec_getNext(struct inrec_t *inrec);
int inrec_print(struct inrec_t *inrec);
int inrec_getLength(struct inrec_t *inrec);
int inrec_copy(struct inrec_t *inrec, unsigned char *output, unsigned char *input, int outputLength, int inputLength, int nFileFormat, int nIsMF, struct job_t* job, int nSplitPos);
int inrec_copy_overlay(struct inrec_t* inrec, unsigned char* output, unsigned char* input, int outputLength, int inputLength, int nFileFormat, int nIsMF, struct job_t* job, int nSplitPos);
int inrec_SetOverlay(struct inrec_t* Inrec, int nOverlay);
int inrec_SetChangeCmdOpt(struct inrec_t* inrec, struct change_t* chg);
int inrec_addDefinition(struct inrec_t *Inrec);

#endif /* INREC_H_INCLUDED  */

