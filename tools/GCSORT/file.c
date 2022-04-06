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
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libcob.h>
#include "gcsort.h"
#include "job.h"
#include "file.h"
#include "utils.h"
#include "gcshare.h"

struct file_t *file_constructor(char *name) {
	struct file_t *file=(struct file_t *)malloc(sizeof(struct file_t));
    if (file != NULL) {
        /* s.m. 202202 file->name = _strdup(name); */
		file->name = ((unsigned char*)malloc((sizeof(unsigned char) * GCSORT_SIZE_FILENAME)));
		if (file->name == NULL)
			utl_abend_terminate(MEMORYALLOC, 1, ABEND_EXEC);
		else
			strcpy(file->name, name);
        file->handleFile=0;
        file->format=FILE_TYPE_FIXED;
        file->organization=FILE_ORGANIZATION_SEQUENTIAL;
        file->recordLength=0;
        file->maxLength=0;
        file->pHeaderMF=NULL;
        file->bIsSeqMF = 0;
        file->nFileMaxSize=0;
        file->next=NULL;
        file->opt = 0;
        file->nCountRow=0;

        file->nNumKeys=0;
        file->stFileDef=NULL;
        file->stKeys=NULL;
	}
	return file;
}
void file_destructor(struct file_t *file) {
	int k,j;
	struct KeyIdx_t *ki;
	struct KeyIdx_t *ARKeyIdx[128];
	if (file->stKeys != NULL) {
		k=0;
		ki=file->stKeys;
		if (file->stFileDef != NULL) {
			for (k=0; k<(int)file->stFileDef->nkeys;k++){
				KeyIdx_destructor(ki);
				ARKeyIdx[k]=ki;
				ki=ki->next;
			}
		}
		for (j=0;j<k;j++) 
			free(ARKeyIdx[j]);
	}

	if (file->stFileDef != NULL) {
			free(file->stFileDef->file_status);  

			/* cob_field    */
			util_cob_field_del(file->stFileDef->assign, ALLOCATE_DATA);
			util_cob_field_del(file->stFileDef->record, ALLOCATE_DATA);
            if (file->stFileDef->variable_record != NULL)
			    util_cob_field_del(file->stFileDef->variable_record, ALLOCATE_DATA);
            if (file->organization == FILE_ORGANIZATION_RELATIVE)  /* delete field for relative */
            	    util_cob_field_del(file->stFileDef->keys[0].field, ALLOCATE_DATA);
 			for (k=0; k<file->nNumKeys;k++) {
                 if (file->stFileDef->keys != NULL)
				    util_cob_field_del(file->stFileDef->keys[k].field, NOALLOCATE_DATA);
			}
			if (file->stFileDef->keys != NULL)
				free(file->stFileDef->keys); 
			free(file->stFileDef); 
	}

	if (file->name != NULL)
		free(file->name);
	if (file->bIsSeqMF == 1) {
		if (file->pHeaderMF != NULL) {
			free(file->pHeaderMF);
			file->pHeaderMF=NULL;
		}
	}
	free(file);
}


int file_print(struct file_t *file) {
	int k;
	struct KeyIdx_t *ki;
	fprintf(stdout,"%s %s (%d,%d) %s",
		file->name,
		utils_getFileFormatName(file->format),
		file->recordLength,
		file->maxLength,
		utils_getFileOrganizationName(file->organization));
	if (file->organization == FILE_ORGANIZATION_INDEXED) {
		if (file->stKeys != NULL) {
			fprintf(stdout," KEY (");
			ki = file->stKeys;
			for (k=0;k<(int)file->stFileDef->nkeys;k++) {
				fprintf(stdout,"%d,%d,%s", ki->position+1, ki->length, utils_getKeyType(ki->type));
				ki = ki->next;
				if (ki != NULL)
					fprintf(stdout,",");
			}
		}
		fprintf(stdout,")");
	}
	fprintf(stdout,"\n");
	return 0;
}

struct file_t *file_getNext(struct file_t *file) {
	if (file==NULL) {
		return NULL;
	} else {
		return file->next;
	}
}
int file_addQueue(struct file_t **file, struct file_t *fileToAdd) {
	struct file_t *f;
	if (*file==NULL) {
		*file=fileToAdd;
	} else {
		for (f=*file;f->next!=NULL;f=f->next);
		f->next=fileToAdd;
	}
	return 0;
}



int file_setFormat(struct file_t *file, int format) {
	file->format=format;
	return 0;
}
int file_setRecordLength(struct file_t *file, int recordLength) {
	file->recordLength=recordLength;
	return 0;
}
int file_setMaxLength(struct file_t *file, int maxLength) {
	file->maxLength=maxLength;
	return 0;
}
int file_setOrganization(struct file_t *file, int organization) {
	if (organization == -1)
		return -1;
	file->organization=organization;
	return 0;
}
char *file_getName(struct file_t *file) {
	return file->name;
}
int file_getRecordLength(struct file_t *file) {
	return file->recordLength;
}

unsigned int file_getMaxLength(struct file_t *file) {
	return file->maxLength;
}
int file_SetMF(struct file_t *file) {
	file->bIsSeqMF = 1;
	return 0;
}
int file_GetMF(struct file_t *file) {
	return file->bIsSeqMF;
}
int file_getOrganization(struct file_t *file) {
	return file->organization;
}
int file_getFormat(struct file_t *file) {
	return file->format;
}
/*
int file_getOrgType(struct file_t *file) {
	return file->nOrgType;
}
*/
int file_setOutputFile(struct file_t *file) {
	globalJob->outputFile=file;
	return 0;
}
int file_setInputFile(struct file_t *file) {
	file_addQueue(&globalJob->inputFile,file);
	return 0;
}
int file_SetInfoForFile(struct file_t* file, int nMode) {

	struct KeyIdx_t* tKeys; 
	int	k=0;
	file->stFileDef = (cob_file*) malloc(sizeof(cob_file));
	file->stFileDef->file_status = NULL; 
	file->stFileDef->file_status = ((unsigned char*)malloc((sizeof(unsigned char)*3)));
	memset (file->stFileDef->file_status, 0x00, 3);

	file->stFileDef->select_name = (const char *)"masterseqfile";
	/* Problem with Join file name //-->>file->stFileDef->assign = util_cob_field_make( COB_TYPE_ALPHANUMERIC, strlen(file->name), 0, 0, strlen(file->name), ALLOCATE_DATA); */
	file->stFileDef->assign = util_cob_field_make( COB_TYPE_ALPHANUMERIC, strlen(file->name), 0, 0, GCSORT_SIZE_FILENAME, ALLOCATE_DATA);

	file->stFileDef->record = NULL;

	/* new option Record Control Statement */
	if (file->maxLength > 0)
		file->stFileDef->record = util_cob_field_make( COB_TYPE_ALPHANUMERIC, file->maxLength, 0, 0, file->maxLength, ALLOCATE_DATA);

	if (file->format == FILE_TYPE_VARIABLE)
		file->stFileDef->variable_record = util_cob_field_make(COB_TYPE_NUMERIC_DISPLAY, 5, 0, 0, 5, ALLOCATE_DATA); 
	else
		file->stFileDef->variable_record = NULL;

	file->stFileDef->record_min = file->recordLength;                         
	file->stFileDef->record_max = file->maxLength;            
	file->stFileDef->nkeys = file->nNumKeys;            
	file->stFileDef->keys = NULL;
	file->stFileDef->file = NULL;  
	file->stFileDef->fd = -1;  
	file->stFileDef->access_mode = COB_ACCESS_SEQUENTIAL;
	file->stFileDef->lock_mode = 0; /* COB_LOCK_AUTOMATIC;   	COB_FILE_EXCLUSIVE;  0; */
	file->stFileDef->open_mode = COB_OPEN_CLOSED;
	file->stFileDef->flag_optional = 0;
	file->stFileDef->last_open_mode = 0;
	file->stFileDef->flag_operation = 0;
	file->stFileDef->flag_nonexistent = 0;
	file->stFileDef->flag_end_of_file = 0;           
	file->stFileDef->flag_begin_of_file = 0;           
	file->stFileDef->flag_first_read = 0;           
	file->stFileDef->flag_read_done = 0;           
	file->stFileDef->flag_select_features = 0;           
	file->stFileDef->flag_needs_nl = 0;           
	file->stFileDef->flag_needs_top = 0;           
	file->stFileDef->file_version = 1;


#if __LIBCOB_VERSION >= 3
	file->stFileDef->linorkeyptr = NULL;
	file->stFileDef->sort_collating = NULL;
	file->stFileDef->extfh_ptr = NULL;
#endif

    /* default: */
    file->stFileDef->organization = COB_ORG_SEQUENTIAL;

	switch(file->organization) {

		case FILE_ORGANIZATION_SEQUENTIAL:		
			file->stFileDef->organization = COB_ORG_SEQUENTIAL;
			break;

		case FILE_ORGANIZATION_LINESEQUENTIAL:
			file->opt = COB_WRITE_BEFORE | COB_WRITE_LINES | 1;
			file->stFileDef->organization = COB_ORG_LINE_SEQUENTIAL;
			cob_putenv("COB_LS_FIXED=OFF");	/* change value of environment value GnuCOBOL*/
			break;
		case FILE_ORGANIZATION_LINESEQUFIXED:
			file->opt = COB_WRITE_BEFORE | COB_WRITE_LINES | 1;
			file->stFileDef->organization = COB_ORG_LINE_SEQUENTIAL;
			cob_putenv("COB_LS_FIXED=ON");	/* change value of environment value GnuCOBOL*/
			break;
		case FILE_ORGANIZATION_RELATIVE:
			tKeys =  file->stKeys;
			file->stFileDef->keys = (cob_file_key*)(malloc (sizeof (cob_file_key) * 1));
			file->stFileDef->keys[0].field = util_cob_field_make( COB_TYPE_NUMERIC_DISPLAY, 5, 0, 0, 5, ALLOCATE_DATA);
			file->stFileDef->keys[0].flag = 0;
			file->stFileDef->keys[0].offset = 0;
			file->stFileDef->organization = COB_ORG_RELATIVE;
			break;
		case FILE_ORGANIZATION_INDEXED:
			tKeys =  file->stKeys;
			/* check keys - for indexed file is mandatory   */
			if (file->nNumKeys == 0) {
				fprintf(stderr,"*GCSORT*S300*ERROR: KEY definitions are not specified for Indexed file. \n");
				exit(GC_RTC_ERROR);
			}
			/* check keys - for indexed file Primary is first definition    */
			if (tKeys->type != KEY_IDX_PRIMARY) {
				fprintf(stderr,"*GCSORT*S301*ERROR: KEY specifications error. First field is not primary key.\n");
				exit(GC_RTC_ERROR);
			}

			file->stFileDef->keys = (cob_file_key*)(malloc (sizeof (cob_file_key) * file->nNumKeys));
			for (k=0; k<file->nNumKeys;k++) {
					file->stFileDef->keys[k].field = util_cob_field_make( tKeys->pCobFieldKey->attr->type, tKeys->pCobFieldKey->attr->digits, 
						tKeys->pCobFieldKey->attr->scale, tKeys->pCobFieldKey->attr->flags, tKeys->pCobFieldKey->size, NOALLOCATE_DATA);
					file->stFileDef->keys[k].field->data = file->stFileDef->record->data+tKeys->position;
                    file->stFileDef->keys[k].field->size = tKeys->length;
					file->stFileDef->keys[k].flag = 0;		/* ASCENDING/DESCENDING (for SORT) */
/* s.m. 202101 start    */
#if __LIBCOB_VERSION >= 3
					file->stFileDef->keys[k].tf_duplicates = 0;
					if (tKeys->type == KEY_IDX_ALTERNATIVE_DUP)
						file->stFileDef->keys[k].tf_duplicates = 1;		/* with duplicates  */
					file->stFileDef->keys[k].tf_ascending=0;
					file->stFileDef->keys[k].tf_suppress=0;
					file->stFileDef->keys[k].char_suppress = 0;
					file->stFileDef->keys[k].count_components = 0;      /* count_components */
					file->stFileDef->keys[k].component[0] = NULL;

					/* s.m. 20210215    */
					file->stFileDef->extfh_ptr = NULL;
					file->stFileDef->linorkeyptr = NULL;
					file->stFileDef->sort_collating = NULL;
#endif
/* s.m. 202101 end  */
					file->stFileDef->keys[k].offset = tKeys->position;
					tKeys =  tKeys->next;
			}
/* s.m. 202101 start    */
#if __LIBCOB_VERSION >= 3
			file->stFileDef->flag_line_adv=0;
			file->stFileDef->curkey=-1;
			file->stFileDef->mapkey=-1;
#endif
/* s.m. 202101 end  */

            file->stFileDef->access_mode = COB_ACCESS_DYNAMIC;  
			file->stFileDef->organization = COB_ORG_INDEXED;
			break;
	}
	return 0;
}
int file_clone(struct file_t* fout, struct file_t* fin) {
	fout->bIsSeqMF = fin->bIsSeqMF;
	fout->file_length = fin->file_length;
	fout->format = fin->format;
	fout->maxLength = fin->maxLength;
	fout->next = NULL;
	fout->nFileMaxSize = fin->nFileMaxSize;
	fout->nNumKeys = 0;
	fout->nTypeNameFile = fin->nTypeNameFile;
	fout->opt = fin->opt;
	fout->organization = fin->organization;
	fout->pHeaderMF = NULL;
	fout->recordLength = fin->recordLength;
	fout->stFileDef = NULL;
	fout->stKeys = NULL;
	return 0;
}