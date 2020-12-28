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

#ifndef FILE_H_INCLUDED
#define FILE_H_INCLUDED
#define HEADER_MF 128

#include <stdint.h>
// #include "libgcsort.h"
#include <libcob.h>
#include "keyidxrel.h"

struct file_t {
	char *name;
	int format;
	int organization;
	int recordLength;
	int maxLength;
	unsigned char* pHeaderMF;
	int bIsSeqMF;
	int64_t file_length;
	int nTypeNameFile; // Outfile
	int handleFile;
	int nFileMaxSize;
	//   int nOrgType;
	int nNumKeys;
	cob_file* stFileDef;		// info for cob_open, cob_read, cob_write, cob_close
	int opt; // option for write
    int nCountRow;
	struct KeyIdx_t* stKeys;
	struct file_t *next;
};

struct file_t *file_constructor(char *name);
void file_destructor(struct file_t *file);
int file_print(struct file_t *file);
struct file_t *file_getNext(struct file_t *file);
int file_addQueue(struct file_t **file, struct file_t *fileToAdd);
int file_setFormat(struct file_t *file, int format);
int file_setRecordLength(struct file_t *file, int recordLength);
int file_setMaxLength(struct file_t *file, int maxLength);
int file_setOrganization(struct file_t *file, int organization);
char *file_getName(struct file_t *file);
int file_getFormat(struct file_t *file);
int file_getRecordLength(struct file_t *file);
unsigned int file_getMaxLength(struct file_t *file);
int file_getOrganization(struct file_t *file);
int file_SetMF(struct file_t *file);
int file_GetMF(struct file_t *file);
//int file_getOrgType(struct file_t *file);
int file_setOutputFile(struct file_t *file);
int file_setInputFile(struct file_t *file);
int file_SetInfoForFile(struct file_t* fkey, int nMode);

#endif // FILE_H_INCLUDED
