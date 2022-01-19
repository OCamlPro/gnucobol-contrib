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
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libcob.h>
#include "file.h"
#include "keyidxrel.h"

struct KeyIdx_t *KeyIdx_constructor(int position, int length, int type)
{
	struct KeyIdx_t *KeyIdx; 
	cob_field_attr*  pCobFAttrKey;
	KeyIdx=(struct KeyIdx_t*)malloc(sizeof(struct KeyIdx_t));
    if (KeyIdx != NULL) {
	    pCobFAttrKey = (cob_field_attr *)malloc(sizeof(cob_field_attr));
        if (pCobFAttrKey == NULL) 
            return NULL;
	    KeyIdx->pCobFieldKey = (cob_field *)malloc(sizeof(cob_field));
        if (KeyIdx->pCobFieldKey == NULL) 
            return NULL;
   	    KeyIdx->position=position-1;	/* Position -1  */
	    KeyIdx->length=length;
	    KeyIdx->type=type;              /*     0=P Primary,                         */
                                        /*     1=A Alternative,                     */
                                        /*     2=AD Alternative with duplicates,    */
                                        /*     3=C Continue previous definition     */
	    KeyIdx->next=NULL;
    /* Attribute    */
        pCobFAttrKey->type = COB_TYPE_ALPHANUMERIC; /* type;                */   
	    pCobFAttrKey->digits = length;				/* len = digit          */
        pCobFAttrKey->scale = 0;					/* fix                  */
        pCobFAttrKey->flags = 0;					/* COB_FLAG_HAVE_SIGN;  */
        pCobFAttrKey->pic = NULL;
    /* Field        */
        KeyIdx->pCobFieldKey->size = length;
	    KeyIdx->pCobFieldKey->data = NULL;
 	    KeyIdx->pCobFieldKey->attr =  pCobFAttrKey;
    }
	return KeyIdx;
}

void KeyIdx_destructor(struct KeyIdx_t *KeyIdx) 
{

	if (KeyIdx->pCobFieldKey->attr != NULL) 
		free((void*)KeyIdx->pCobFieldKey->attr);

	if (KeyIdx->pCobFieldKey->data != NULL) {
		free(KeyIdx->pCobFieldKey->data);
	}
	 free(KeyIdx->pCobFieldKey);
}

/* Set pointer to buffer record for input/output    */
void KeyIdx_setDataForKey(struct KeyIdx_t *KeyIdx, unsigned char* szBuf) 
{
    KeyIdx->pCobFieldKey->data = szBuf+KeyIdx->position;  /* Position into principal buffer of record   */
}

struct KeyIdx_t *KeyIdx_getNext(struct KeyIdx_t *KeyIdx) 
{
	if (KeyIdx==NULL) {
		return NULL;
	} else {
		return KeyIdx->next;
	}
}
int KeyIdx_addHead(struct KeyIdx_t **KeyIdx, struct KeyIdx_t *KeyIdxToAdd) 
{
	KeyIdxToAdd->next=*KeyIdx;
	*KeyIdx=KeyIdxToAdd;
	return 0;
}
int KeyIdx_addQueue(struct KeyIdx_t **KeyIdx, struct KeyIdx_t *KeyIdxToAdd) {
	struct KeyIdx_t *f;
	if (*KeyIdx==NULL) {
		*KeyIdx=KeyIdxToAdd;
	} else {
		for (f=*KeyIdx;f->next!=NULL;f=f->next);
		f->next=KeyIdxToAdd;
	} 
	return 0;
} 
int KeyIdx_addDefinition(struct KeyIdx_t *KeyIdx, struct file_t *fkey) {
	KeyIdx_addQueue(&fkey->stKeys, KeyIdx);
	fkey->nNumKeys++;	/* increment number of key for file */
	return 0;
}


