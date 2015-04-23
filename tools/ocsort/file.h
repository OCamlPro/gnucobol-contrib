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

#ifndef FILE_H_INCLUDED
#define FILE_H_INCLUDED





struct file_t;

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
int file_getMaxLength(struct file_t *file);
int file_getOrganization(struct file_t *file);


#endif // FILE_H_INCLUDED
