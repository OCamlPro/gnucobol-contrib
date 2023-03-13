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

#ifndef OUTFIL_H_INCLUDED
#define OUTFIL_H_INCLUDED


struct job_t;

struct outfil_t{

	struct file_t 		*outfil_File;
	struct condField_t	*outfil_includeCond;
	struct condField_t	*outfil_omitCond;
	struct outrec_t 	*outfil_outrec;

	int64_t	outfil_nStartRec;		/* StartRek for outfil          */
	int64_t	outfil_nEndRec;			/* EndRek for outfil            */
	int	    nSave;
	int     nSplit;			        /* (SPLIT SPLITBY -SPLIT1R=n-)  */	
    int     nRecSplit;              /* Num record split by = nn     */
    int     nRecTmp;                /* Num record split by = nn     */
	int	    bIsCopy;		        /* SORT-MERGE FIELDS=COPY       */
	int		recordWriteOutTotal;
	int		recordNumber;
	int     isVirtualFile;			/* 0 - Normal, 1 - Virtual (Virtual File - Outfil without FILES/FNAMES - write record in GIVE File) */
    struct  file_t* pLastFileSplit; /* for SPLIT                    */
	struct outfil_t *next;
};

struct outfil_t *outfil_constructor( void );
void outfil_destructor(struct outfil_t *outfil);
struct outfil_t *outfil_getNext(struct outfil_t *outfil);
int outfil_addQueue(struct outfil_t **outfil, struct outfil_t *outfilToAdd);
int outfil_SetStartRec(struct outfil_t* outfil, int64_t nStartRek);
int outfil_SetEndRec(struct outfil_t* outfil, int64_t nEndRek);
int outfil_SetSave(struct outfil_t *outfil);
int setOutfilFiles(struct outfil_t *outfil, struct file_t * file);
int setOutfilIncludeCondField(struct outfil_t* outfil, struct condField_t * condfield);
void setOutfilOmitCondField(struct outfil_t* outfil, struct condField_t * condfield);
int outfil_addDefinition(struct outfil_t* outfil) ;
int outfil_addoutfilrec(struct outfil_t* outfil, struct outrec_t *outrec);
int outfil_setOutfilFiles(struct outfil_t *outfil, struct file_t * file);
int outfil_open_files( struct job_t *job  );
int outfil_close_files(  struct job_t *job  );
int outfil_write_buffer( struct job_t *job, unsigned char* buffer_pointer, unsigned int  nLenRek, unsigned char* szBuffRek, int nSplitPosPnt, int userec);
int outfil_write_buffer_split( struct job_t *job, struct outfil_t* outfil, unsigned char* buffer_pointer, unsigned int  nLenRek, unsigned char* szBuffRek, int nSplitPosPnt);
int outfile_clone_output(struct job_t* job, struct file_t* file);
int outfil_set_area (struct file_t* file, unsigned char* szBuf, int nLen );
void outfil_SetVirtualFile(struct outfil_t* outfil, int nValue);

#endif
