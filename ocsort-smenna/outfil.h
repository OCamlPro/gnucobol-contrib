/*
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

#ifndef OUTFIL_H_INCLUDED
#define OUTFIL_H_INCLUDED


struct outfil_t{

	struct file_t 		*outfil_File;
	struct condField_t	*outfil_includeCond;
	struct condField_t	*outfil_omitCond;
	struct outrec_t 	*outfil_outrec;

	int	outfil_nStartRec;		// StartRek for outfil
	int	outfil_nEndRec;			// EndRek for outfil
	int	nSave;

	int   nSplit;			// (SPLIT SPLITBY -SPLIT1R=n-)	
    int   nMaxFileSplit;
    int   nLastFileSplit;	
	// new
	int		bIsCopy;		// SORT-MERGE FIELDS=COPY
	int		recordWriteOutTotal;
	int		recordNumber;
	// char	*recordData;
	struct outfil_t *next;
};

struct outfil_t *outfil_constructor( void );
void outfil_destructor(struct outfil_t *outfil);
int outfil_print(struct outfil_t *outfil);
struct outfil_t *outfil_getNext(struct outfil_t *outfil);
int outfil_addQueue(struct outfil_t **outfil, struct outfil_t *outfilToAdd);
int outfil_SetStartRec(struct outfil_t* outfil, int nStartRek);
int outfil_SetEndRec(struct outfil_t* outfil, int nEndRek);
int outfil_SetSave(struct outfil_t *outfil);
int setOutfilFiles(struct outfil_t *outfil, struct file_t * file);
int setOutfilIncludeCondField(struct outfil_t* outfil, struct condField_t * condfield);
void setOutfilOmitCondField(struct outfil_t* outfil, struct condField_t * condfield);
int outfil_addDefinition(struct outfil_t* outfil) ;
int outfil_addoutfilrec(struct outrec_t *outrec);
int outfil_setOutfilFiles(struct outfil_t *outfil, struct file_t * file);
int outfil_open_files( struct job_t *job  );
int outfil_close_files(  struct job_t *job  );
int outfil_write_buffer( struct job_t *job, unsigned char* buffer_pointer, int  nLenRek, unsigned char* szBuffRek );

#endif