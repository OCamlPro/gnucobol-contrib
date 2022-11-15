/*
    Copyright (C) 2016-2022 Sauro Menna
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

#ifndef FINDREP_FIELD_H_INCLUDED
#define FINDREP_FIELD_H_INCLUDED

#include <stdint.h>
#include <libcob.h>
#include "fieldvalue.h"
/*
    FINDREP
            IN=incon, OUT=outcon
            
            IN=(incon, incon, incon,.... ), OUT=outcon
            
            INOUT=(incon,outcon,incon,outcon,...)

                , STARTPOS=p
                , ENDPOS=q
                , DO=n
                , MAXLEN=n
                , OVERRUN=ERROR or , OVERRUN=TRUNC
                , SHIFT=YES     or , SHIFT=NO 
                
                incon = C'cost' 
                outcon= C'cost'  or nC'cost'
                n from 1 to 256
                
                incon = X'cost' 
                outcon= X'cost'  or nX'cost'
                n from 1 to 256
                

*/

#define FINDREP_TYPE_INOUT	    1		
#define FINDREP_TYPE_ININOUT	2
#define FINDREP_TYPE_INOUTPAIR	3

struct findrepfield_t {
	struct fieldValue_t *in;
	struct fieldValue_t	*out;
	struct findrepfield_t *next;
};

struct findrep_t {
	int nfindrep_type;                /* 1 = in,out - 2 = in,in,in..., out  - 3 inout(in,out,in,out,in,out,...) */
	int nStartPos;						
    int nEndPos;
    int nDo;
    int nMaxLen;
    int nOverRun;                   /* OVERRUN=ERROR (Default) or , OVERRUN=TRUNC */
    int nShift;                     /* Default SHIFT YES (Default) or SHIFT NO    */
    struct findrepfield_t *pFindRepField;	
};

struct findrep_t* findrep_constructor( int nType );
void findrep_destructor(struct findrep_t *field);
void findrep_print(struct findrep_t* field);
void findrep_fields_setin(struct findrepfield_t* p, struct fieldValue_t* field);
void findrep_fields_setout(struct findrepfield_t* p, struct fieldValue_t* field);
void findrep_setType(struct findrep_t* fr, int ntype);
void findrep_setStartPos ( struct findrep_t *fr, int n);
int  findrep_getStartPos ( struct findrep_t *fr);
void findrep_setEndPos ( struct findrep_t *fr, int n);
int  findrep_getEndPos ( struct findrep_t *fr);
void findrep_setDo ( struct findrep_t *fr, int n);
int  findrep_getDo ( struct findrep_t *fr);
void findrep_setMaxLen ( struct findrep_t *fr, int n);
int  findrep_getMaxLen ( struct findrep_t *fr);
void findrep_setOverRun ( struct findrep_t *fr, int n);
int  findrep_getOverRun ( struct findrep_t *fr);
void findrep_setShift ( struct findrep_t *fr, int n);
int  findrep_getShift ( struct findrep_t *fr);
void findrep_setpairs(struct findrep_t* field, struct findrepfield_t* p);
int findrep_search_replace(struct findrep_t* CmdOpt, unsigned char* BufIn, unsigned char* BufOut, int lenIn, int lenOut, unsigned char* inputrec,int nMaxOcc);
void findrepfield_setOutForAll(struct findrepfield_t* fin, struct fieldValue_t* out);
struct findrepfield_t *findrepfield_constructor(struct fieldValue_t *in, struct fieldValue_t *out);
void findrepfield_destructor(struct findrepfield_t *field);
void findrepfield_destructorin(struct findrepfield_t* fr);

int findrepfield_print(struct findrepfield_t *field);
struct findrepfield_t *findrepfield_getNext(struct findrepfield_t *field);
int findrepfield_t_addQueue(struct findrepfield_t **field, struct findrepfield_t *fieldToAdd);
int findrepfield_t_setValues(struct findrepfield_t *field, struct fieldValue_t *in, struct fieldValue_t *out);
int findrepfield_t_getFind(struct findrepfield_t *field, struct fieldValue_t *in);
int findrepfield_t_getRep(struct findrepfield_t *field, struct fieldValue_t *out);

#endif /* FINDREP_FIELD_H_INCLUDED   */
