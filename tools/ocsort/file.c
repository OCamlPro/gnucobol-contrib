/*
 *  Copyright (C) 2009 Cedric ISSALY
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "file.h"
#include "utils.h"

struct file_t {
	char *name;
	int format;
	int organization;
	int recordLength;
	int maxLength;

	struct file_t *next;
};


struct file_t *file_constructor(char *name) {
	struct file_t *file=(struct file_t *)malloc(sizeof(struct file_t));
	file->name=name;
	file->format=FILE_TYPE_FIXED;
	file->organization=FILE_ORGANIZATION_SEQUENTIAL;
	file->recordLength=0;
	file->maxLength=0;
	file->next=NULL;
	return file;
}
void file_destructor(struct file_t *file) {
	free(file);
}


int file_print(struct file_t *file) {
	printf("%s %s (%d,%d) %s\n",
		file->name,
		utils_getFileFormatName(file->format),
		file->recordLength,
		file->maxLength,
		utils_getFileOrganizationName(file->organization));
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
	file->organization=organization;
	return 0;
}
char *file_getName(struct file_t *file) {
	return file->name;
}
int file_getFormat(struct file_t *file) {
	return file->format;
}
int file_getRecordLength(struct file_t *file) {
	return file->recordLength;
}
int file_getMaxLength(struct file_t *file) {
	return file->maxLength;
}
int file_getOrganization(struct file_t *file) {
	return file->organization;
}
