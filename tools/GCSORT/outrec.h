/*
    Copyright (C) 2016-2020 Sauro Menna
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

#ifndef OUTREC_H_INCLUDED
#define OUTREC_H_INCLUDED

#define TYPE_STRUCT_STD		0
#define TYPE_STRUCT_NEW		1

struct outrec_t;
struct fieldValue_t;
struct change_t;

#define OUTREC_TYPE_RANGE				0
#define OUTREC_TYPE_CHANGE_POSITION		1
#define OUTREC_TYPE_CHANGE				2
#define OUTREC_TYPE_RANGE_POSITION		3
#define OUTREC_TYPE_CHANGE_ABSPOS	    4
#define OUTREC_TYPE_CHANGE_CMDOPT	    5
#define OUTREC_TYPE_FINDREP				6


struct outrec_t {
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
			struct findrep_t* findrepCmdOpt;
		} range;				/* 0	OUTREC_TYPE_RANGE    */
		struct {
			int position;
			int length;
			int posAbsRec;
			struct fieldValue_t* fieldValue;
			char type;
			struct change_t* changeCmdOpt;
			struct findrep_t* findrepCmdOpt;
		} change_position;		/*  1	OUTREC_TYPE_CHANGE_POSITION  */
		struct {
			int position;
			int length;
			int posAbsRec;
			struct fieldValue_t* fieldValue;
			char type;
			struct change_t* changeCmdOpt;
			struct findrep_t* findrepCmdOpt;
		} change;				/*  2	OUTREC_TYPE_CHANGE - 4  OUTREC_TYPE_CHANGE_ABSPOS  */
		struct {
			int position;
			int length;
			int posAbsRec;
			struct fieldValue_t* fieldValue;
			char type;
			struct change_t* changeCmdOpt;
			struct findrep_t* findrepCmdOpt;
		} range_position;		/*  3	OUTREC_TYPE_RANGE_POSITION   */
		struct {
			int position;
			int length;
			int posAbsRec;
			struct fieldValue_t* fieldValue;
			char type;
			struct change_t* changeCmdOpt;
			struct findrep_t* findrepCmdOpt;
		} changeCmd;			/*  5	OUTREC_TYPE_CHANGE_CMDOPT   */
		struct {
			int position;
			int length;
			int posAbsRec;
			struct fieldValue_t* fieldValue;
			char type;
			struct change_t* changeCmdOpt;
			struct findrep_t* findrepCmdOpt;
		} findrepCmd;			/*  6	OUTREC_TYPE_FINDREP   */
	};
	unsigned char* szChangeBufIn;
	unsigned char* szChangeBufOut;
	unsigned char* szChangeBufNoMatch;
	struct outrec_t* next;
};

void outrec_initialize(struct outrec_t* outrec);
struct outrec_t *outrec_constructor_range(int position, int length);
struct outrec_t *outrec_constructor_change(struct fieldValue_t *fieldValue);
struct outrec_t *outrec_constructor_range_position(int posAbsRec, int position, int length);
struct outrec_t *outrec_constructor_subst(unsigned char *chfieldValue);
struct outrec_t *outrec_constructor_padding(int nAbsPos, unsigned char *chfieldValue, int nPosAbsRec);
struct outrec_t *outrec_constructor_substnchar(unsigned char* ntch, unsigned char *chfieldValue);
struct outrec_t* outrec_constructor_possubstnchar(int npos, unsigned char* ntch, unsigned char* chfieldValue);
struct outrec_t* outrec_constructor_findrep( void );
int outrec_set_findrep(struct outrec_t* outrec, struct findrep_t* findrep);

void outrec_destructor(struct outrec_t *outrec);
int outrec_addQueue(struct outrec_t **outrec,struct outrec_t *outrec_add);
struct outrec_t *outrec_getNext(struct outrec_t *outrec);
int outrec_print(struct outrec_t *outrec);
int outrec_getLength(struct outrec_t *outrec);
int outrec_copy(struct outrec_t *outrec, unsigned char *output, unsigned char *input, int outputLength, int inputLength, int nFileFormat, int nIsMF, struct job_t* job, int nSplitPos);
int outrec_copy_overlay(struct outrec_t* outrec, unsigned char* output, unsigned char* input, int outputLength, int inputLength, int nFileFormat, int nIsMF, struct job_t* job, int nSplitPos);
int outrec_SetOverlay(struct outrec_t* Outrec, int nOverlay);
int outrec_SetChangeCmdOpt(struct outrec_t* Outrec, struct change_t* chg);
int outrec_addDefinition(struct outrec_t *outrec);
int outrec_SetFindRepCmdOpt(struct outrec_t* Outrec);


#endif /* OUTREC_H_INCLUDED */
