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
//
// Structure for Key definition Indexed File
// Input and Output
//

#ifndef KEYIDXREL_H_INCLUDED
#define KEYIDXREL_H_INCLUDED

#include <stdint.h>
#include <libcob.h>

struct file_t;
struct KeyIdx_t {
    int             position;       // Position extract from instruction KEY
    int             length;         // Len extract from instruction KEY
    int             type;           // Type extract from instruction KEY  
                                    //     0 = P  Primary, 
                                    //     1 = A  Alternative, 
                                    //     2 = AD Alternative with duplicates, 
                                    //     3 = C  Continue previous definition
	cob_field* 	     pCobFieldKey;    // Field
	struct KeyIdx_t *next;          // Next
} KeyIdx;


struct KeyIdx_t *KeyIdx_constructor(int position, int length, int type);
void KeyIdx_destructor(struct KeyIdx_t *KeyIdx);
void KeyIdx_setDataForKey(struct KeyIdx_t *KeyIdx, unsigned char* szBuf);
struct KeyIdx_t *KeyIdx_getNext(struct KeyIdx_t *KeyIdx);
int KeyIdx_addHead(struct KeyIdx_t **KeyIdx, struct KeyIdx_t *KeyIdxToAdd);
int KeyIdx_addQueue(struct KeyIdx_t **KeyIdx, struct KeyIdx_t *KeyIdxToAdd);
int KeyIdx_addDefinition(struct KeyIdx_t *KeyIdx, struct file_t *fkey);


#endif // KEYIDXREL_H_INCLUDED